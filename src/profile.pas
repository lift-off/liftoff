{-----------------------------------------------------------------------------
 Unit Name: profile
 Author:    marc
 Purpose:   Kapslung der Profil (Koordinaten und Polaren in einer Klasse
 History:
-----------------------------------------------------------------------------}


unit profile;

interface
uses     
  classes, sysutils, Contnrs, forms, windows, XMLDoc, XMLIntf, XMLDOM, dialogs;

const
  cProfilVersion   = '1.0';

const
  ndNameProfil     = 'airfoil';
  attrVersion      = 'version';
  attrDesc         = 'description';
  ndNameKoord      = 'coordinates';
  ndNameKoordPoint = 'point';
  attrKoordPointX  = 'x';
  attrKoordPointY  = 'y';
  ndNamePolaren    = 'polar';
  ndNamePolBerech  = 'calculation';
  attrPolBerech    = 'name';
  atvlPolDefault   = 'default';
  ndNameRE         = 're_set';
  attrREValue      = 'value';
  ndNamePolarItem  = 'value';
  attrCA           = 'cl';
  attrCW           = 'cd';

  PEFDefaultOrigin = 'Princeton';

type

  EProfilError = class(exception)
  public
    ProfilName: string;
  end;

  TKoordinate = class
    x : currency;
    y : currency;
  end;

  TKoordinaten = class(TObjectList)
  private
    function  Get(Index: Integer): TKoordinate;
    procedure Put(Index: Integer; Item: TKoordinate);
  public
    function AddKoordinate(x, y: currency): TKoordinate;
    property Items[Index: Integer]: TKoordinate read Get write Put; default;
  end;

  TPolare = class
  private
    Fca : currency;
    Fcw : currency;
    procedure SetCW(const Value: currency);
    function GetcwCalc: currency;
  public
    function CalcCwcalc(aCa: currency): currency;
    property ca : currency read Fca write Fca;
    property cw : currency read Fcw write SetCW;
    property cwCalc : currency read GetcwCalc;
  end;

  TREDir = (reEqual, reLess, reGreater);
  TRESet = class(TObjectList)
  private
    Fre: currency;
    function  Get(Index: Integer): TPolare;
    procedure Put(Index: Integer; Item: TPolare);
    function GetByCA(aCA: currency; ADir: TREDir = reEqual): TPolare;
  public
    function Add(aCA, aCW: currency) : TPolare;
    property re : currency read Fre write Fre;
    function GetCWcalcByCA(aCA: currency): currency;
    property Items[Index: Integer]: TPolare read Get write Put;
  end;

  TRESets = class(TObjectList)
  private
    function  Get(Index: Integer): TRESet;
    procedure Put(Index: Integer; Item: TRESet);
    function GetByRE(aRE: currency): TRESet;
  public
    function Add(aRE: currency): TRESet;
    function GetNearestByRe( aRE: currency): integer;
    property Items[Index: Integer]: TRESet read Get write Put;
    property ByRE[aRE: currency]: TRESet read GetByRE;
  end;

  TProfil = class
  private
    FKoord: TKoordinaten;
    FBezeichnung: string;
    FDateiname: string;
    FAlpha0: currency;
    FCM0: currency;
    FPolaren: TRESets;
    FVersion: string;
    FCurrentFileNameWithPath: string;
    FProfilName: string;
    FProfilDickeProzent: byte;
    procedure SetDateiName(const Value: string);
    function GetProfilName: string;
  protected
    procedure LoadKoordinaten(ANode: IXMLNode);
    procedure LoadPolaren(ANode: IXMLNode);
    procedure RaiseProfilError(AMsg: string);

    procedure LoadPLR;                          // Liesst alte .PLR-Dateien ein.
//    procedure CalcProfilDickeProzent;           // Berechnet die % Profildicke anhand der aktuellen Koordinaten
  public
    constructor Create;
    destructor  Destroy; override;

    function  New(ADateiname: string): boolean; // Neues Profil erfassen (versuchen)
    procedure Load;                             // Profil aus Datei laden (XML)
    procedure LoadOldFiles(AFileName: string);  // Alte .KOO und .PLR Dateien laden
    procedure LoadKOO(AFileName: string = '');  // Liesst die Koordinaten aus einer .KOO-Datei ein
    procedure LoadPEF(AFileName: string = '');  // Liesst die Polaren aus einer .PEF-Datei ein
    procedure ExportToKooFile(AFileName: string); // Exportiert die Profilkoordinaten in eine .KOO-Datei
    function  Save: boolean;                    // Speichern in Datei (XML)
    function  SaveAs(ANewName: string; IsAbsoluteName: boolean = false): boolean;// Profil unter neuem Namen speichern (kopieren)
    function  Delete: boolean;                  // Löscht ein Profil

    function CalcProfilFileName(ADateiname: string = ''): string;        // Berechnet den Dateipfad für die Profildatei
    procedure CalcAlpha0Cm0; virtual; // Berechnet Alpha0 und Ccm0 eines Profiles

    property Dateiname: string read FDateiname write SetDateiName;
    property CurrentFileNameWithPath: string read FCurrentFileNameWithPath;
    property Version: string read FVersion;
    property Bezeichnung: string read FBezeichnung write FBezeichnung;
    property Koordinaten: TKoordinaten read FKoord write FKoord;
    property Polaren: TRESets read FPolaren write FPolaren;
    property ProfilName: string read GetProfilName;

    property cm0: currency read Fcm0 write Fcm0;
    property Alpha0: currency read FAlpha0;
    property ProfilDickeProzent: byte read FProfilDickeProzent;
  end;

function ConvertProfilnameToFilename(AProfilName: string) : string;

implementation

uses
  IniFiles, math, shellapi,
{$IFNDEF WITHOUT_UI}
  chVariante, main,
{$ENDIF}
  id_string, id_tools, idShellFolder, ad_consts, ad_utils, maindata,
  idTranslator;

type

  TAlphaNullDaten = record
    PX: currency;
    NBI: currency;
  end;

  TCmNullDaten = record
    PX: currency;
    MDI: currency;
  end;

  TStuetzstelle = record
    b,
    d,
    st : currency;
  end;

const
  // Wird für das Berechnen des Nullauftriebswinkels nach Lichte benötigt
  AlphaNullDaten: array[1..6] of TAlphaNullDaten = (
    (PX:  98.3;    NBI: -4.8919),
    (PX:  85.36;   NBI: -0.5690),
    (PX:  62.94;   NBI: -0.2249),
    (PX:  37.6;    NBI: -0.1324),
    (PX:  14.65;   NBI: -0.0976),
    (PX:   1.7;    NBI: -0.0848)
  );

  CmNullDaten: array[1..10] of TCmNullDaten = (
    (PX:  98.30;   MDI:  -7.9370),
    (PX:  93.30;   MDI:  -0.2267),
    (PX:  85.36;   MDI:  -1.0790),
    (PX:  75.00;   MDI:  -0.1309),
    (PX:  62.94;   MDI:  -0.4210),
    (PX:  37.06;   MDI:  -0.1402),
    (PX:  25.00;   MDI:  -0.1309),
    (PX:  14.65;   MDI:   0.0318),
    (PX:   6.70;   MDI:   0.2267),
    (PX:   1.70;   MDI:   0.1197)
  );



{
lfd Nr  feste     Faktoren    Faktoren
        X-Werte   für a0      für cm0
i       Xi        Bi          Di
--------------------------------------
1	0,9830     -4,8919     -7,9370
2	0,9330      0,0000     -0,2267
3	0,8536     -0,5690     -1,0790
4	0,7500	    0,0000     -0,1309
5	0,6294	   -0,2249     -0,4210
6	0,5000	    0,0000      0,0000
7	0,3706	   -0,1324     -0,1402
8	0,2500	    0,0000      0,1309
9	0,1465	   -0,0976      0,0318
10	0,0670	    0,0000      0,2267
11	0,0170	   -0,0848      0,1197
}

function ConvertProfilnameToFilename(AProfilName: string) : string;
begin
  result := Trim(AProfilName);
  result := ReplaceChars(result, ['\', '>', '<', '/', '*', '|', '!' ], '-');
  result := ReplaceChars(result, ['"' ], '''');
  result := ReplaceChars(result, ['(', ')'], ' ');
end;

{ TProfil }

constructor TProfil.Create;
begin
  FKoord := TKoordinaten.Create;
  FPolaren := TRESets.Create;
  FCurrentFileNameWithPath := '';
end;

destructor TProfil.Destroy;
begin
  FreeAndNil(FKoord);
  FreeAndNil(FPolaren);
end;

procedure TProfil.LoadKOO(AFileName: string = '');
var
  f : textfile;   // Filehandle
  i,o : integer;
  s : string;
  n : integer;
  fn : string;
  k : TKoordinate;

begin
  FKoord.Clear;

  if AFileName = '' then
    fn := ProfilPath + Dateiname + KoordFileExt
  else
    fn := AFileName;

  if FileExists(fn) then begin
    { Datei öffnen }
    AssignFile(f, fn);
    Reset(f);

    try
      ReadLn(f, s);
      FBezeichnung := '';
      FProfilName := OemToAnsi(ExtractItem(1, s, [',']));
      N := StrToIntDef(ExtractItem(2, s, [',']), 0);
      o := 0;

      while (not EoF(f)) and (o <= n) do begin
        ReadLn(f, s);
        inc(o);

        k := TKoordinate.Create;

        with k do begin
          { Die Koordinatenzeilen innerhalb der Datei können sowohl mit Komma
            wie auch mit einem Leerschlag getrennt sein. Aus diesem Grund müssen
            zwei unterschiedliche Formate unterstützt werden. }

          s := Trim(s);
          if ItemCount(s, [',']) = 2 then begin
            { Kommagetrennt }
            x := ADStrToCurr(ExtractItem(1, s, [',']));
            y := ADStrToCurr(ExtractItem(2, s, [',']));
          end else begin
            { Spacegetrennt }
            i := LastPos(' ', s);
            if (i > 2) then begin
              try
                x := ADStrToCurr(Trim(Copy(s, 1, i -1)));
                y := ADStrToCurr(Trim(CopyEnd(s, i + 1)));
              except
                raise Exception.CreateFmt('Unzulässige Koordinatenwerte in Koordinatendatei %s !', [fn]);
              end;
            end else
              raise Exception.CreateFmt('Unbekannten Zeilenformat in Koordinatendatei %s !', [fn]);
          end;
        end;
        FKoord.Add(k);

      end;

    finally
      CloseFile(f); // Datei auf jedenfall wieder schliessen
    end;

  end else
    raise Exception.CreateFmt('Koordinatendatei %s nicht vorhanden!', [fn]);

end;

{$o-}
{ Alpha0 und Cm0 gemäss "Profile für Windows" berechnen (L. Wiechers) }
procedure TProfil.CalcAlpha0Cm0;
const

  Stuetzstellen : array[1..11] of TStuetzstelle = (
    (b:  -4.8919;      d: -7.937;     St:   98.29629),
    (b:   0;           d: -0.2267;    St:   93.30125),
    (b:  -0.569;       d: -1.079;     St:   85.35532),
    (b:   0;           d: -0.1309;    St:   75),
    (b:  -0.2249;      d: -0.421;     St:   62.94093),
    (b:   0;           d:  0;         St:   50),
    (b:  -0.1324;      d: -0.1402;    St:   37.05904),
    (b:   0;           d:  0.1309;    St:   25),
    (b:  -0.0976;      d:  0.0318;    St:   14.64466),
    (b:   0;           d:  0.2267;    St:    6.698727),
    (b:  -0.0848;      d:  0.1197;    St:    1.703708)
   );

  { Werte gemäss "Profile für Windows"
  b(1) = -4.8919: d(1) = -7.937:      St(1) = 98.29629
  b(2) = 0:       d(2) = -.2267:      St(2) = 93.30125
  b(3) = -.569:   d(3) = -1.079:      St(3) = 85.35532
  b(4) = 0:       d(4) = -.1309:      St(4) = 75
  b(5) = -.2249:  d(5) = -.421:       St(5) = 62.94093
  b(6) = 0:       d(6) = 0:           St(6) = 50
  b(7) = -.1324:  d(7) = -.1402:      St(7) = 37.05904
  b(8) = 0:       d(8) = .1309:       St(8) = 25
  b(9) = -.0976:  d(9) = .0318:       St(9) = 14.64466
  b(10) = 0:      d(10) = .2267:      St(10) = 6.698727
  b(11) = -.0848: d(11) = .1197:      St(11) = 1.703708}



var
  i, i1, i2, n : integer;
  xges, sklt, yoben, yunten, tmp : currency;
  b1, b2, c1, c2, d1, d2 : array of currency;

  procedure CalcSpline;
  var i, n : integer;
  begin
    n := FKoord.Count -1;

    d1[1] := 4;
    b1[1] := 3 / 4 * (FKoord.Items[3].x - 2 * FKoord.Items[2].x + FKoord.Items[1].x);
    b2[1] := 3 / 4 * (FKoord.Items[3].y - 2 * FKoord.Items[2].y + FKoord.Items[1].y);
    for i := 2 to n - 2 do begin
       d2[i - 1] := 1 / d1[i - 1];
       d1[i] := 4 - d2[i - 1];
       b1[i] := (3 * (FKoord.Items[i + 2].x - 2 * FKoord.Items[i + 1].x + FKoord.Items[i].x) - b1[i - 1]) / d1[i];
       b2[i] := (3 * (FKoord.Items[i + 2].y - 2 * FKoord.Items[i + 1].y + FKoord.Items[i].y) - b2[i - 1]) / d1[i];
    end;

    c1[n - 1] := b1[n - 2];
    c2[n - 1] := b2[n - 2];

    for i := n - 3 downto 1 do begin
       c1[i + 1] := b1[i] - d2[i] * c1[i + 2];
       c2[i + 1] := b2[i] - d2[i] * c2[i + 2];
    end;

    c1[1] := 0; c1[n] := 0;
    c2[1] := 0; c2[n] := 0;
    for i := 1 To n - 1 do begin
       b1[i] := FKoord.Items[i + 1].x - FKoord.Items[i].x - (2 * c1[i] + c1[i + 1]) / 3;
       b2[i] := FKoord.Items[i + 1].y - FKoord.Items[i].y - (2 * c2[i] + c2[i + 1]) / 3;
       d1[i] := (c1[i + 1] - c1[i]) / 3;
       d2[i] := (c2[i + 1] - c2[i]) / 3;
    end;
  end;

  { Routine zum Bestimmen eines Y-Wertes y0 zu einem X-Wert xges!
    anhand der vorher berechneten Spline-Koeffizienten }
  function YWert(xges: currency; k: integer): currency;
  var
    zae,
    joben, junten,
    j1, x0  : currency;
  begin
    zae := 0;
    joben := 1; junten := 0; // oberer, unterer Parameter
    repeat
      repeat

        j1 := (joben + junten) / 2;             // binäres Suchen
        X0 := ((d1[k] * j1 + c1[k]) * j1 + b1[k]) * j1 + FKoord.Items[k].x;
        if k = FKoord.Count-1 Then k := k - 1;
        if FKoord.Items[k].x > FKoord.Items[k + 1].x then begin
          // Profiloberseite
          if X0 > xges then
            junten := j1
          else
            joben := j1;
        end else begin
          // Profilunterseite
          if X0 > xges then
            joben := j1
          else
            junten := j1;
        end;
        Zae := Zae + 1;

      until (Abs(xges - X0) < 0.001) or (Zae > 100);
      dec(k);

    until (Zae <= 100) or (k <= 0);
    inc(k);

    result := ((d2[k] * j1 + c2[k]) * j1 + b2[k]) * j1 + FKoord.Items[k].y;
    //y0! = ((d2(k%) * j1! + c2(k%)) * j1! + b2(k%)) * j1! + Yp(k%)
    //k% = k_urspr%
  end;

begin
  FAlpha0 := 0;
  FCm0 := 0;

  if FKoord.Count < 3 then exit;

  try
    SetLength(b1, FKoord.Count);
    SetLength(b2, FKoord.Count);
    SetLength(c1, FKoord.Count);
    SetLength(c2, FKoord.Count);
    SetLength(d1, FKoord.Count);
    SetLength(d2, FKoord.Count);

    CalcSpline;

    i := 1;
    i1 := 1;
    i2 := FKoord.Count -1;

    for n := Low(Stuetzstellen) to High(Stuetzstellen) do begin
      // Stützwertformel von Lichte;
      xges := Stuetzstellen[n].St;

      // Oberseite
      // i1 ist die gegenüber xges nächstgrössere X-Koordinate auf der Oberseite
      while FKoord.Items[i1+1].x >= xges do
        inc(i1);

      // Unterseite
      // i2 ist die gegenüber xges nächstgrössere K-Koordinate auf der Unterseite
      while FKoord.Items[i2].x > xges do
        dec(i2);

      yoben := ywert(xges, i1);
      yunten := ywert(xges, i2);

      sklt := 0.5 * (yoben + yunten);
      FAlpha0 := FAlpha0 + Stuetzstellen[n].b * sklt;
      Fcm0 := Fcm0 + Stuetzstellen[n].d * sklt;
    end;
    FAlpha0 := 1.146 * FAlpha0;
    tmp := FCm0 / 50;
    Cm0 := currency(tmp);
    //cm0 := -0.0682;

    try
      SetLength(b1, 0);
      SetLength(b2, 0);
      SetLength(c2, 0);
      SetLength(d1, 0);
      SetLength(d2, 0);
      SetLength(c1, 0); // aus irgend einem Grund crasht er hier - keine Ahnung warum, hab's bis jetzt nicht rausgefunden, was mit C1 nicht stimmen soll
    except
    end;
  except
    FAlpha0 := 0;
    FCm0 := 0;
  end;
end;
{$o+}

procedure TProfil.Load;
var
  XML : TXMLDocument;
  i : integer;
  iRe : integer;
  XMLRoot,
  XMLNode : IXMLNode;
begin
  XML := TXMLDocument.Create(Application);
  try

    FProfilName := '';
    FKoord.Clear;
    FPolaren.Clear;

    with XML do begin
      XML.Clear;
      FCurrentFileNameWithPath := CalcProfilFileName;

      if not FileExists(FCurrentFileNameWithPath) then begin
        Application.MessageBox(
          PChar(Format(dmMain.Translator.GetLit('AirfoilNotFoundText'), [Dateiname])),
          PChar(dmMain.Translator.GetLit('AirfoilNotFoundCaption')),
          mb_IconStop + mb_Ok);
        exit;
      end;

      LoadFromFile(FCurrentFileNameWithPath);

      Active := true;

      if ChildNodes.Count > 0 then begin
        { Root }
        XMLRoot := ChildNodes.FindNode(ndNameProfil);
        if assigned(XMLRoot) then begin

          { Versionsnr. laden (wenn vorhanden, ansonsten "0.0" }
          if XMLRoot.HasAttribute(attrVersion) then
            FVersion := XMLRoot.Attributes[attrVersion]
          else
            FVersion := '0.0';

          { Bezeichnung laden (wenn vorhanden) }
          if XMLRoot.HasAttribute(attrDesc) then
            Bezeichnung := XMLRoot.Attributes[attrDesc]
          else
            Bezeichnung := '';

          { Koordinaten }
          XMLNode := XMLRoot.ChildNodes.FindNode(ndNameKoord);
          if assigned(XMLNode) then
            LoadKoordinaten(XMLNode)
          else
            RaiseProfilError('Im Profil-DOM wurden keine Koordinaten gefunden!');

          { Polaren }
          XMLNode := XMLRoot.ChildNodes.FindNode(ndNamePolaren);
          if assigned(XMLNode) then
            LoadPolaren(XMLNode)
          else
            RaiseProfilError('Im Profil-DOM wurden keine Polaren gefunden!');

        end else
          RaiseProfilError('Kein Hauptknoten (Root-Node) in Profil-DOM vorhanden!');
      end else
        RaiseProfilError('Auf oberster Ebene des Profil-DOM''''s sind keine Unterknoten verhanden!');
    end;

    { Berechnungen anstellen }
    if Koordinaten.Count > 0 then begin
      CalcAlpha0Cm0;  // Alpha0 und cm0 nur berechnen, wenn Profilkoordinaten vorhanden sind.
    end else begin
      FCM0 := 0;
      FAlpha0 := 0;
    end;
  finally
    FreeAndNil(XML);
  end;
end;

procedure TProfil.SetDateiName(const Value: string);
begin
  FDateiname := Value;
  if FDateiname <> '' then
    Load;
end;

procedure TProfil.LoadPLR;
var
  fn : string;
  f : textfile;
  CAMin,
  CAMax : real;
  sLine : string;
  p : integer;
  CurCA : real;
  TmpRE : currency;
  TempCW : real;
  i, c : integer;

  procedure RaisePolarException(AMsg: string);
  begin
    raise EProfilError.CreateFmt('Fehlerhafte Polarendatei (%s): %s!', [fn, AMsg]);
  end;

begin
  Polaren.Clear;

  fn := ProfilPath + Dateiname + PolareFileExt;
  if FileExists(fn) then begin
    Assign(f, fn);
    Reset(f);
    try

      ReadLn(f, sLine);  // 1. Zeile: Min / Max CA

      if not EoF(f) then begin
        { Min. / Max. CA extrahieren }
        sLine := FilterLine(sLine);
        if ItemCount(sLine, [#32]) <> 2 then RaisePolarException('Zeile mit min./max CA''''s weisst ein ungültiges Format auf.');
        caMin := ADStrToCurr(ExtractItem(1, sLine, [#32]));
        caMax := ADStrToCurr(ExtractItem(2, sLine, [#32]));

        ReadLn(f, sLine);  // 2. Zeile: RE-Zahlen
        if not EoF(f) then begin
          sLine := FilterLine(sLine);
          c := ItemCount(sLine, [#32]);
          if c < 1 then RaisePolarException('Es sind keine RE-Zahlen vorhanden!');

          { Re-Zahlen als Liste aufbauen }
          for i := 1 to c do begin
            TmpRE := ADStrToCurr(ExtractItem(i, sLine, [#32]), -1);
            if TmpRE = -1 then RaisePolarException('RE-Wert kann nicht in eine Zahl umgewandelt werden!');
            Polaren.Add(TmpRe);
          end;

          CurCA := caMin;
          while not EoF(f) do begin  // CA / CW - Werte ermitteln
            ReadLn(f, sLine);
            if  (sLine <> '')
            and (sLine[1] <> ';')
            and (sLine[1] <> '#') then begin
              sLine := FilterLine(sLine);
              c := ItemCount(sLine, [#32]);
              if c < 1 then RaisePolarException('In der Zeile sind keine Werte vorhanden!');
              for i := 0 to pred(Polaren.Count) do begin

                if i + 1 > c then TempCW := 0
                else TempCW := ADStrToCurr(ExtractItem(i+1, sLine, [#32]), 0);

                Polaren.Items[i].Add(CurCA, TempCW);

              end;
              CurCA := CurCA + 0.1;
            end;
          end;

        end;
      end;

    finally
      CloseFile(f);
    end;

  end;
end;

procedure TProfil.LoadOldFiles(AFileName: string);
var
  fn: string;
begin
  FDateiname := AFileName;
  FCurrentFileNameWithPath := CalcProfilFileName();
  LoadKOO;
  LoadPLR;
  fn := ProfilPath + Dateiname + PEFFileExt;
  if FileExists(fn) then LoadPEF(fn);
  //CalcAlpha0Cm0;
end;

function TProfil.Save: boolean;
var
  XML : TXMLDocument;
  i : integer;
  iRe : integer;
begin
  result := false;
  XML := TXMLDocument.Create(Application);
  try
    with XML do begin
      Options := [doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix, doNamespaceDecl];
      ParseOptions := [poPreserveWhiteSpace];

      XML.Clear;
      Active := true;
      with AddChild(ndNameProfil) do begin  // Node: Profil
        Attributes[attrVersion] := cProfilVersion;  // Attribut: Version
        FVersion := cProfilVersion; // Versionsnummer aktualisieren
        Attributes[attrDesc] := Bezeichnung; // Attribut: Description
        with AddChild(ndNameKoord) do begin  // Node: Koordinaten
          if Koordinaten.Count > 0 then
            for i := 0 to pred(Koordinaten.Count) do begin
              with AddChild(ndNameKoordPoint) do begin
                Attributes[attrKoordPointX] := ADCurrToStr(Koordinaten.Items[i].x);
                Attributes[attrKoordPointY] := ADCurrToStr(Koordinaten.Items[i].y);
              end;
            end;
        end;  // Node: Koordinaten

        with AddChild(ndNamePolaren) do begin  // Node: Polaren
          with AddChild(ndNamePolBerech) do begin // Node: Berechnung Default
            Attributes[attrPolBerech] := atvlPolDefault;
            if Polaren.Count > 0 then
              for iRe := 0 to pred(Polaren.Count) do
                with AddChild(ndNameRE) do begin  // Node: RE
                  Attributes[attrREValue] := ADCurrToStr(Polaren.Items[iRE].re);
                  if Polaren.Items[iRe].Count > 0 then
                    for i := 0 to pred(Polaren.Items[iRe].Count) do
                      with AddChild(ndNamePolarItem) do begin  // Node: Polareintrag
                        Attributes[attrCA] := ADCurrToStr(Polaren.Items[iRe].Items[i].ca);
                        Attributes[attrCW] := ADCurrToStr(Polaren.Items[iRe].Items[i].cw);
                      end;  // Node: Polareintrag
                end;  // Node: Re
          end;  // Node: Berechnung Default
        end;  // Node Polaren
      end;  // Node: Profil

      try
        SaveToFile(FCurrentFileNameWithPath);
      except
        result := false;
        Application.MessageBox(
          PChar(Format(dmMain.Translator.GetLit('AirfoilSaveErrorText'), [FCurrentFileNameWithPath])),
          PChar(dmMain.Translator.GetLit('AirfoilSaveErrorCaption')),
          mb_IconStop + mb_Ok);
        raise;
      end;

      result := true;
    end;  // with XML
  finally
    FreeAndNil(XML);
  end;

end;

procedure TProfil.RaiseProfilError(AMsg: string);
var
  e : EProfilError;
begin
  e := EProfilError.Create(AMsg);
  e.ProfilName := Dateiname;
  raise e;
end;

procedure TProfil.LoadKoordinaten(ANode: IXMLNode);
var
  i : integer;
  noseIdx: integer;
  loadMode : byte; // 1 = From Tail to Front, 2 = Twice from Front to Tail
  topTailIdx : integer;

  function FindTopTailIdx(): integer;
  var
    i: integer;
    maxX: currency;
    maxIdx: integer;
    newX: currency;
    lastX: currency;
  begin
    maxX:= 0;
    lastX:= 0;
    maxIdx:= 0;
    result:= -1;
    for i:= 0 to pred(ANode.ChildNodes.Count) do begin
      newX := ADStrToCurr(ANode.ChildNodes[i].Attributes[attrKoordPointX]);
      if (newX > maxX) then begin
        maxX:= newX;
        maxIdx:= i;
      end else begin
        if newX < lastX then begin
          break;
        end;
      end;
      lastX:= newX;
    end;

    if maxIdx > -1 then begin
      result:= maxIdx;
    end else begin
      RaiseProfilError('Koordinatenpunkt der Nase konnte nicht ermittelt werden!');
    end;
  end;

  procedure AddKoord(idx: integer);
  var
    x, y : currency;
  begin
    if  (ANode.ChildNodes[idx].HasAttribute(attrKoordPointX))
    and (ANode.ChildNodes[idx].HasAttribute(attrKoordPointY)) then begin
      x := ADStrToCurr(ANode.ChildNodes[idx].Attributes[attrKoordPointX]);
      y := ADStrToCurr(ANode.ChildNodes[idx].Attributes[attrKoordPointY]);
    end else
      RaiseProfilError(Format('Koordinate %s hat kein vollständiges X/Y-Wertepaar!', [IntToStr(i)]));
    FKoord.AddKoordinate(x, y);
  end;

begin
  if ANode.HasChildNodes then begin

    // First detect load mode
    loadMode:= 1; // Default load mode
    if ANode.ChildNodes.Count > 0 then begin
      if (ADStrToCurr(ANode.ChildNodes[0].Attributes[attrKoordPointX]) > 90) then loadMode := 1
      else loadMode := 2;
    end;

    // DEBUG CODE:
    // Force old methode
    //loadMode:= 1;
    // END DEBUG CODE

    if loadMode = 1 then begin
      // Koordinaten liegen in einer Line von hinten oben durch zur Nase und
      // wieder mach hinten
      for i := 0 to pred(ANode.ChildNodes.Count) do begin
        AddKoord(i);
      end;
    end else

    if loadMode = 2 then begin
      // Koordinaten liegen in zwei Reihen vor: von der Nase oben durch nach
      // hinten und von der Nase unten durch nach hinten.

      topTailIdx:= FindTopTailIdx();
      // Lade obere Profilschale
      for i:= topTailIdx downto 0 do begin
        AddKoord(i);
      end;

      // Lade untere Profilschale
      for i:= topTailIdx to pred(ANode.ChildNodes.Count) do begin
        AddKoord(i);
      end;

    end else

    begin
      RaiseProfilError('Die Koordinatenreihenfolge konnte nicht richtig erkannt werden!');
    end;
  end;
end;

procedure TProfil.LoadPolaren(ANode: IXMLNode);
var
  i, iRE : integer;
  NodeBerech,
  NodeRE : IXMLNode;
  RESet : TRESet;
  tmpCA,
  tmpCW : currency;
begin
  if ANode.HasChildNodes then begin
    { Nach Bode Berechnung = Default suchen }
    for i := 0 to pred(ANode.ChildNodes.Count) do
      if  (ANode.ChildNodes[i].HasAttribute(attrPolBerech))
      and (Anode.ChildNodes[i].Attributes[attrPolBerech] = atvlPolDefault) then begin
        NodeBerech := ANode.ChildNodes[i];
        Break;
      end;

    if  (assigned(NodeBerech))
    and (NodeBerech.HasChildNodes) then begin
      for iRE := 0 to pred(NodeBerech.ChildNodes.Count) do begin
        if NodeBerech.ChildNodes[iRE].HasAttribute(attrREValue) then begin
          RESet := Polaren.Add(ADStrToCurr(NodeBerech.ChildNodes[iRe].Attributes[attrREValue]));
          if NodeBerech.ChildNodes[iRe].HasChildNodes then begin
            for i := 0 to pred(NodeBerech.ChildNodes[iRe].ChildNodes.Count) do begin
              tmpCA := ADStrToCurr(NodeBerech.ChildNodes[iRe].ChildNodes[i].Attributes[attrCA]);
              tmpCW := ADStrToCurr(NodeBerech.ChildNodes[iRe].ChildNodes[i].Attributes[attrCW]);
              //tmpCW := 100 * ((tmpCA - 0.1) * 10) + 10 * tmpCW;
              RESet.Add(tmpCA, tmpCW);
            end;
          end;
        end else
          RaiseProfilError('RE-Eintrag (Knoten) beinhaltet keine RE-Wert! Eintrag ungültig.');
      end;
    end;

  end;
end;

function TProfil.New(ADateiname: string): boolean;
begin
  result := false;

  if ADateiname = '' then begin
     Application.MessageBox(PChar(dmMain.Translator.GetLit('AirfoilNewNoName')),
                            PChar(dmMain.Translator.GetLit('AirfoilNewCaption')),
                            mb_IconStop + mb_Ok);
  end else
    if FileExists(CalcProfilFileName(ADateiname)) then begin
      Application.MessageBox(
        PChar(Format(dmMain.Translator.GetLit('AirfoilAlreadyExists'), [ADateiname])),
        PChar(dmMain.Translator.GetLit('AirfoilNewCaption')),
        mb_IconHand + mb_Ok);
    end else begin
      FProfilName := '';
      FDateiname := ADateiname;
      Koordinaten.Clear;
      Polaren.Clear;
      FCurrentFileNameWithPath := CalcProfilFileName;
      result := true;
    end;
end;

function TProfil.CalcProfilFileName(ADateiname: string = ''): string;
var
  path: string;
begin
  if ADateiname <> '' then
    result := ProfilPath + ADateiname + ProfilFileExt
  else
    result := ProfilPath + FDateiname + ProfilFileExt;
end;

procedure TProfil.LoadPEF(AFileName: string);
var
  fn : string;
  PEF : TMemIniFile;  // Verwende Memory-Buffered INI-Files der Performance zuliebe
  i : integer;
  SetID : string;
  NoOfPols : integer;
  Bez : string;

  { Sucht das entsprechende Set, mit der gewünschten Berechnungsmethode und
    liefert die entsprechende Section-ID als String zurück. }
  function FindSetID: string;
  var
    CurSetNr: integer;
    SectionNames : TStringList;
  begin
    result := '';

    SectionNames := TStringList.Create;
    try
      PEF.ReadSections(SectionNames);
      if SectionNames.Count > 0 then begin

        for CurSetNr := 0 to pred(SectionNames.Count) do
          if PEF.ReadString(SectionNames[CurSetNr], 'Origin', '') <> '' then begin
            result := SectionNames[CurSetNr];
            break;
          end;
      end;

    finally
      FreeAndNil(SectionNames);
    end;
  end;

  procedure ImportPolare(ASectionID: string);
  var
    i : integer;
    re : currency;
    NoOfPoints: integer;
    ReSet: TReSet;
    s : string;
  begin
    if ASectionID = '' then exit;

    re := PEF.ReadFloat(ASectionID, 'Re-Nr', 0);
    if re > 0 then begin   // Nullwerte werden nicht importiert
      ReSet := Polaren.Add(re);
      NoOfPoints := PEF.ReadInteger(ASectionID, 'NumberPoints', 0);
      if NoOfPoints > 0 then
        for i := 1 to NoOfPoints do begin
          s := PEF.ReadString(ASectionID, 'Value'+IntToStrEx(i, 2), '');

          if s <> '' then begin
            s := FilterLine(s);
            if ItemCount(s, [#32]) = 2 then
              ReSet.Add(ADStrToCurr(ExtractItem(1, s, [#32])),
                        ADStrToCurr(ExtractItem(2, s, [#32])))
            else
            if ItemCount(s, [#32]) = 4 then
              ReSet.Add(ADStrToCurr(ExtractItem(2, s, [#32])),
                        ADStrToCurr(ExtractItem(3, s, [#32])))
            else
              raise Exception.Create('Fehler in PEF-Datei! Unbekannt anzahl Werte in Polaren-Definition.');
          end;
        end;
    end;
  end;

begin
  FPolaren.Clear;

  if AFileName = '' then
    fn := ProfilPath + Dateiname + KoordFileExt
  else
    fn := AFileName;

  if FileExists(fn) then begin
    PEF := TMemIniFile.Create(fn);
    try

      SetID := FindSetID;
      if SetID = '' then begin
        Application.MessageBox(PChar(dmMain.Translator.GetLit('AirfoilErrorCalcMethod')),
                               PChar(dmMain.Translator.GetLit('AirfoilImportCaption')),
                               mb_IconStop + mb_Ok)
      end else begin
        { Profilbeschreibung importieren }
        Bez := '';
        i := 1;
        while PEF.ValueExists(SetID, 'Description'+IntToStr(i)) do begin
          if Bez <> '' then Bez := Bez + ' ';
          Bez := Bez + PEF.ReadString(SetID, 'Description'+IntToStr(i), '');
          inc(i);
        end;
        if Bez <> '' then
          Bezeichnung := OemToAnsi(Bez);


        { Polarendaten pro RE importieren }
        NoOfPols := PEF.ReadInteger(SetID, 'NumberPolars', 0);
        if NoOfPols > 0 then
          for i := 1 to NoOfPols do
            ImportPolare(SetID + '-Polar' + IntToStr(i));

      end;

    finally
      FreeAndNil(PEF);
    end;
  end;

end;

function TProfil.Delete: boolean;
begin
  result := false;
  try
    {$i-}
    try
      DeleteFile(PChar(CalcProfilFileName));
      result := true;
    finally
      {$i+}
    end;
  except
  end;
end;

function TProfil.SaveAs(ANewName: string; IsAbsoluteName: boolean = false): boolean;
begin
  result := false;
  if FileExists(CalcProfilFileName(ANewName)) then begin
    RaiseProfilError(Format(dmMain.Translator.GetLit('AirfoilAlreadyExists'), [ANewName]));
  end else begin
    if IsAbsoluteName then begin
      FDateiname := ExtractFileName( ANewName );
      FCurrentFileNameWithPath := ANewName;
    end else begin
      FDateiname := ANewName;
      FCurrentFileNameWithPath := CalcProfilFileName();
    end;
    result := Save();
  end;
end;

function TProfil.GetProfilName: string;
begin
  if FProfilName <> '' then
    result := FProfilName
  else
    Result := Dateiname;
end;

procedure TProfil.ExportToKooFile(AFileName: string);
var
  content: TStringList;
  iKoo: integer;
  s: string;
begin

  content:= TStringList.Create();
  try

    { 1. Zeile:
      - Profilname im OEM-Format
      - Anzahl Koordinateneinträge }
    s:= AnsiToOEM(ProfilName);
    content.Add(Format( '%s,%d', [s, Koordinaten.Count]));

    for iKoo:= 0 to pred( Koordinaten.Count ) do begin
      content.Add(Format('%f,%f', [Koordinaten[iKoo].x, Koordinaten[iKoo].y]));
    end;

    content.SaveToFile(AFileName);

  finally
    FreeAndNil( content );
  end;

end;

{ TKoordinaten }

function TKoordinaten.AddKoordinate(x, y: currency): TKoordinate;
var
  k : TKoordinate;
begin
  k := TKoordinate.Create;
  k.x := x;
  k.y := y;
  Add(k);
  result:= k;
end;

function TKoordinaten.Get(Index: Integer): TKoordinate;
begin
  result := TKoordinate(inherited Get(Index));
end;

procedure TKoordinaten.Put(Index: Integer; Item: TKoordinate);
begin
  inherited Put(Index, Item);
end;

{ TRESet }

function TRESet.Add(aCA, aCW: currency): TPolare;
begin
  result := TPolare.Create;
  result.ca := aCA;
  result.cw := aCW;
  inherited Add(result);
end;

function TRESet.Get(Index: Integer): TPolare;
begin
  result := inherited Get(Index);
end;

function TRESet.GetByCA(aCA: currency; ADir: TREDir = reEqual): TPolare;
var
  i : integer;

begin
  result := nil;
  if Count > 0 then begin

    case ADir of
      reEqual: begin
        { Suchen nach genauem CA-Wert }
        for i := 0 to pred(count) do
          if Items[i].ca = aCa then begin
            result := Items[i];
            break;
          end;
      end;

      reLess: begin
        { Nach nächst kleinerem CA suchen }
        if not assigned(result) then
          for i := pred(count) downto 0 do
            if (Items[i].ca <= aCA)
            or (i = 0) then begin
              result := Items[i];
              break;
            end;
          end;

      reGreater: begin
        { Nach nächst grösserem CA suchen }
        if not assigned(result) then
          for i := 0 to pred(count) do
            if (Items[i].ca >= aCA)
            or (i = pred(Count)) then begin
              result := Items[i];
              break;
            end;
          end;
      end;

  end;
end;

function TRESet.GetCWcalcByCA(aCA: currency): currency;
var
  pol, pol2 : TPolare;
  fak: currency;
begin
  pol := GetByCA(aCA);
  if assigned(pol) then
    result := pol.CalccwCalc(aCA)
  else begin
    pol := GetByCA(aCA, reLess);
    pol2 := GetByCA(aCA, reGreater);

    if pol2 = pol then begin

      result := pol.CalccwCalc(aCA);

    end else begin

      if pol2.ca = pol.ca then pol2.ca := pol2.ca + 0.01;
      fak := 100 / (pol2.ca - pol.ca) * (aCA - pol.ca);

      //if pol2.cw = pol.cw then pol2.cw := pol2.cw + 0.01;
      if pol2.cw = pol.cw then pol2.cw := pol2.cw + 0.001;
      result := pol.CalccwCalc(aCA) + ((pol2.CalccwCalc(aCA) - pol.CalccwCalc(aCA)) /100 * Fak);

    end;

  end;
end;

procedure TRESet.Put(Index: Integer; Item: TPolare);
begin
  inherited Put(Index, Item);
end;

function TRESets.Add(aRE: currency): TRESet;
begin
  result := ByRE[aRE];
  if not assigned(result) then begin
    result := TRESet.Create;
    result.re := aRE;
    inherited Add(result);
  end;
end;

function TRESets.Get(Index: Integer): TRESet;
begin
  result := inherited Get(Index);
end;

function TRESets.GetByRE(aRE: currency): TRESet;
var
  i : integer;
begin
  result := nil;
  if Count > 0 then
    for i := 0 to pred(Count) do
      if  Items[i].re = ARE then begin
        result := Items[i];
        break;
      end;
end;

function TRESets.GetNearestByRe(aRE: currency): integer;
var
  i: integer;
begin
  result:= -1;
  for i:= 0 to pred( Count ) do begin
    if (Items[i].re > aRE) and (Items[i].re <> 0) then begin
      result:= i;
      break;
    end;
  end;
  if result = -1 then begin
   result:= Count - 1;
  end;
end;

procedure TRESets.Put(Index: Integer; Item: TRESet);
begin
  inherited Put(Index, Item);
end;

{ TPolare }

function TPolare.GetcwCalc: currency;
begin
  result := 100 * ((ca - 0.1) * 10) + 10 * cw;
end;

function TPolare.CalccwCalc(aCa: currency): currency;
begin
  result := 100 * ((aCa - 0.1) * 10) + 10 * cw;
end;

procedure TPolare.SetCW(const Value: currency);
begin
  Fcw := Value;
end;

end.
