unit modell;

interface

uses
  classes, sysutils, windows, XMLDoc, varianten, forms, dialogs;

type

  EModellError = class(exception) end;

  TModell = class
  private
    FModellBezeichnung: string;
    FModFileName: string;
    FVariante: TModellVariante;
    FVarianten: TModellVarianten;
    FDontLoadDataNextTime: boolean;
    FDoNotSaveOnNextSetVariante: boolean;
    procedure SetModellBezeichnung(const Value: string);
    function GetModellName: string;
    procedure SetAltered(const Value: boolean);
    function GetAltered: boolean;
    procedure SetVariante(const Value: TModellVariante);
    function CheckModelFileForReadOnly: boolean;
  public
    constructor Create;
    destructor  Destroy; override;

    property Altered: boolean read GetAltered write SetAltered;

    function New(AModellName, AVariantenName: string) : boolean;
    function Load(AModellFileName: string): boolean;
    function Save: boolean;
    function SaveAs(AFileName: string): boolean;
    function Rename(ANewModellName: string): boolean;
    function Delete: boolean;

    property ModellName: string read GetModellName;
    property ModFileName: string read FModFileName;

    property ModellBezeichnung: string read FModellBezeichnung write SetModellBezeichnung;
    property Variante: TModellVariante read FVariante write SetVariante;
    property Varianten: TModellVarianten read FVarianten;

    property DontLoadDataNextTime: boolean read FDontLoadDataNextTime write FDontLoadDataNextTime;
    property DoNotSaveOnNextSetVariante: boolean read FDoNotSaveOnNextSetVariante write FDoNotSaveOnNextSetVariante;
  end;

var
  CurrentModell: TModell;

implementation

uses
  dxBar, dxBarExtItems, dxsbar,
  ad_consts, id_string, XMLIntf, main, maindata;

{ TModell }

constructor TModell.Create;
begin
  FVarianten := TModellVarianten.Create(self);
  FVariante := nil;
end;

function TModell.Delete: boolean;
begin
  {$i-}
  result := DeleteFile(PChar(ModFileName));
  FModFileName := '';
  {$i+}
end;

destructor TModell.Destroy;
begin
  FVariante := nil;
  FreeAndNil(FVarianten);
  inherited;
end;

function TModell.GetAltered: boolean;
begin
  result := frmMain.Altered;
end;

function TModell.GetModellName: string;
var
  i : integer;
  s : string;
begin
  result := '';
  s := ExtractFileName(FModFileName);
  if s <> '' then begin
    i := LastPos(ModellFileExt, s);
    if i < 1 then i := Length(s)
    else dec(i);
    result := Copy(s, 1, i);
  end;
end;

function TModell.Load(AModellFileName: string): boolean;
var
  XMLDocument : TXMLDocument;
  TmpNode: IXMLNode;
begin

  FVarianten.Clear;
  FVariante := nil;

  FModFileName := AModellFileName;

  if Pos('.', FModFileName) = 0 then FModFileName := FModFileName + ModellFileExt;

  if FileExists(FModFileName) then begin

    { Aus XML-Datei laden }
    XMLDocument := TXMLDocument.Create(frmMain);
    with XMLDocument do begin
      //Options := Options + [doNodeAutoIndent];
      //ParseOptions := ParseOptions + [poPreserveWhiteSpace];
      LoadFromFile(FModFileName);
//      Active := true;
      TmpNode := ChildNodes.FindNode('modell');
      if assigned(TmpNode) then begin
        if assigned(TmpNode.ChildNodes.FindNode('description')) then
          ModellBezeichnung := TmpNode.ChildNodes['description'].Text
        else
          ModellBezeichnung := '';
      end;
      TmpNode := TmpNode.ChildNodes.FindNode('varianten');
      if assigned(TmpNode) then begin
        Varianten.Load(TmpNode);
      end;

      if Varianten.Count > 0 then Variante := Varianten.Items[0];

    end;

    if FVarianten.Count > 0 then FVariante := FVarianten.Items[0]
    else FVariante := nil;

    result := true;

    if CheckModelFileForReadOnly then begin
      frmMain.miReadOnly.Visible:= ivAlways;
      Application.MessageBox(PChar(dmMain.Translator.GetLit('ModelIsWriteProtectedText')),
                             PChar(dmMain.Translator.GetLit('ModelIsWriteProtectedCaption')),
                             mb_IconInformation + mb_Ok );
    end else begin
      frmMain.miReadOnly.Visible:= ivNever;
    end;

  end else
    raise EModellError.CreateFmt(dmMain.Translator.GetLit('ModelfileForModelNotFound'), [AModellFileName]);
end;

function TModell.New(AModellName, AVariantenName: string): boolean;
var
  NewVar : TModellVariante;
begin
  FModFileName := ModellPath + AModellName + ModellFileExt;
  FVarianten.Clear;
  frmMain.cmbVariante.Clear;
  Variante := FVarianten.AddVariante(AVariantenName);
  result := true;
end;

function TModell.Rename(ANewModellName: string): boolean;
begin
  result:= false;
end;

function TModell.CheckModelFileForReadOnly: boolean;
begin
  if FileExists(ModFileName ) then begin
    result:= FileGetAttr( ModFileName ) and faReadOnly <> 0;
  end else begin
    result:= false;
  end;
end;

function TModell.Save: boolean;
var
  XMLDocument : TXMLDocument;
  TmpNode: IXMLNode;
begin

  result:= false;
  if CheckModelFileForReadOnly then begin
    Application.MessageBox(PChar(dmMain.Translator.GetLit('ModelIsWriteProtectedErrorText')),
                           PChar(dmMain.Translator.GetLit('ModelIsWriteProtectedCaption')),
                           mb_IconStop + mb_Ok );
  end else begin

    XMLDocument := TXMLDocument.Create(nil);
    try
      with XMLDocument do begin
        Options := Options + [doNodeAutoIndent];
        ParseOptions := ParseOptions + [poPreserveWhiteSpace];
        Active := true;

        { Modelldaten generell }
        with AddChild('modell') do begin
          AddChild('description').Text := FModellBezeichnung;
          TmpNode := AddChild('varianten');
          //with TmpNode.AddChild('test1') do Text := 'test1';
          //with TmpNode.AddChild('test2') do Text := 'test2';
          Varianten.Save(TmpNode);
        end;

        SaveToFile(ModFileName);
        result:= true;
      end;

      Altered := false;
    finally
      //FreeAndNil(XMLDocument); // braucht's nicht, da hier Interfaces im Spiel sind
    end;
  end;

end;

function TModell.SaveAs(AFileName: string): boolean;
begin
  result := false;
end;

procedure TModell.SetAltered(const Value: boolean);
begin
  frmMain.Altered := Value;
end;

procedure TModell.SetModellBezeichnung(const Value: string);
begin
  FModellBezeichnung := Value;
  Altered := true;
end;

procedure TModell.SetVariante(const Value: TModellVariante);
var i : integer;
begin
  frmMain.IsUpdateing:= true;
  try
    if (not DoNotSaveOnNextSetVariante)
      and (assigned(Variante))
    then begin
      frmMain.SaveData;
    end;
    DoNotSaveOnNextSetVariante:= false;
    FVariante := Value;
    i := frmMain.cmbVariante.Items.IndexOfObject(FVariante);
    if i < 0 then frmMain.AddVariante(FVariante);
    i := frmMain.cmbVariante.Items.IndexOfObject(FVariante);
    frmMain.cmbVariante.ItemIndex := i;
    if DontLoadDataNextTime then
      DontLoadDataNextTime := false
    else
      if assigned(Variante) then frmMain.LoadData;
  finally
    frmMain.IsUpdateing:= false;
  end;
end;

end.

