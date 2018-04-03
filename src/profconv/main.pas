unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, WinXP, ComCtrls, StdCtrls, xmldom, XMLIntf, msxmldom,
  XMLDoc;

type
  TfrmKonvMain = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    pgrConvert: TProgressBar;
    WinXP1: TWinXP;
    Label3: TLabel;
    Label4: TLabel;
    lblProfilname: TLabel;
    btnAbort: TButton;
    Shape1: TShape;
    procedure btnAbortClick(Sender: TObject);
  private
    { Private declarations }
    FileList: TStringList;
    procedure ImportOldDescriptions;
  public
    { Public declarations }
    Aborted : boolean;
    function  ScanForOldFiles: boolean;
    function  ConvertOldFiles: boolean;
    procedure ConvertFile(AFileName: string);
    procedure CleanUpDir;
    function  Execute: boolean;
  end;

var
  frmKonvMain: TfrmKonvMain;

procedure ExecApp;

implementation

uses
  id_string, ad_consts, profile;

{$R *.dfm}

procedure ExecApp;
begin
  Application.CreateForm(TfrmKonvMain, frmKonvMain);
  frmKonvMain.Show;
  Application.ProcessMessages;
  frmKonvMain.Execute;
  //Application.Run;
end;

function TfrmKonvMain.ConvertOldFiles: boolean;
var
  iFile : integer;
  sErr : string;
begin
  result := false;
  sErr := '';

  if FileList.Count > 0 then begin
    pgrConvert.Max := FileList.Count;
    pgrConvert.Position := 0;

    for iFile := 0 to pred(FileList.Count) do begin
      lblProfilname.Caption := FileList[iFile];
      Update;
      Application.ProcessMessages;

      try
        if not FileExists(ProfilPath + FileList[iFile] + ProfilFileExt) then
          ConvertFile(FileList[iFile]);
      except
        if sErr <> '' then sErr := sErr + #13;
        sErr := sErr + FileList[iFile];
      end;

      pgrConvert.Position := iFile + 1;
      Update;
      Application.ProcessMessages;

      if Aborted then begin // Abbruch
        exit;
      end;
    end;
  end;
  result := true;

  if sErr <> '' then begin
    Application.MessageBox(Pchar(
                             Format('Bei einem oder mehreren Profilen trat ein Fehler beim Konvertieren auf!'+#13+
                                    'Die folgenden Profile konnten nicht konvertiert werden:'+#13#13+
                                    '%s',
                                    [FileList[iFile]])
                             ),
                           'Fehler beim Konvertieren',
                           mb_IconExclamation + mb_Ok);
  end;
end;

function TfrmKonvMain.Execute: boolean;
begin
  result := false;
  try
    FileList := TStringList.Create;
    Aborted := false;
    if ScanForOldFiles then
      if ConvertOldFiles then begin
        result := true;

        ImportOldDescriptions;

        lblProfilname.Caption := 'Profilverzeichnis wird aufgeräumt ...';
        Update;
        CleanUpDir;
      end;
  finally
    FreeAndNil(FileList);
    Close;
  end;
end;

procedure TFrmKonvMain.ImportOldDescriptions;
var
  f : TextFile;
  fn : string;
  line : string;
  NeedHeaderLine : boolean;
  ProfilFileName,
  ProfilName,
  ProfilDesc : string;
  Profil : TProfil;
  p : integer;
begin
  fn := ProgPath + 'DESCR.TXT';
  if FileExists(fn) then begin
    lblProfilname.Caption := 'Alte Profilbeschreibungen werden gesucht und importiert ...';
    pgrConvert.Position := 0;
    Update;

    AssignFile(f, fn);
    Reset(f);

    NeedHeaderLine := true;
    ProfilName := '';
    ProfilDesc := '';

    try

      while (not EoF(f)) do begin
        ReadLn(f, Line);
        Line := Trim(Line);

        if Line <> '' then begin

          Line := OemToAnsi(Line);

          { Need header }
          if NeedHeaderLine then begin
            NeedHeaderLine := false;
            p := Pos(#32, line);
            if p > 0 then begin
              ProfilName := Trim(CopyEnd(line, p));
              lblProfilname.Caption := ProfilName;
              Update;
            end;
          end else

          { Ende des Profils -> Suchen und Speichern }
          if Line = '=========================================' then begin
            assert(ProfilName <> '', 'Kein Profilname gefunden!');

            if ProfilDesc <> '' then begin
              ProfilFileName := ConvertProfilnameToFilename(ProfilName);
              Profil := TProfil.Create;
              try
                try

                  if FileExists(Profil.CalcProfilFileName(ProfilFileName)) then begin
                    Profil.Dateiname := ProfilFileName;
                    //Profil.Load;

                    if Pos(Trim(ProfilDesc), Profil.Bezeichnung) = 0 then begin  // Doppelerfassungen verhindern
                      Profil.Bezeichnung := ProfilDesc + #13#13 + Profil.Bezeichnung; // Beschreibung vor den best. Text einfügen
                      Profil.Save;
                    end;
                  end;

                except
                  //Application.MessageBox(PChar('Problem beim Profil ' + ProfilName + ' mit der Beschreibung: ' + #13#13 + ProfilDesc),
                  //                       'Fehler',
                  //                       mb_IconStop + mb_Ok);
                  //raise;
                end;

              finally
                FreeAndNil(Profil);
              end;
            end;

            NeedHeaderLine := true;
            ProfilName := '';
            ProfilDesc := '';
          end else

          { Text }
          begin
            if ProfilDesc <> '' then ProfilDesc := ProfilDesc + #13;
            ProfilDesc := ProfilDesc + line;
          end;

        end;

      end;

    finally
      CloseFile(f);
    end;

  end;
end;

function TfrmKonvMain.ScanForOldFiles: boolean;
var
  SearchRec : TSearchRec;
  status : integer;
  s : string;
begin
  result := false;
  FileList.Clear;
  status := FindFirst(ProfilPath + '*' + KoordFileExt, faAnyFile, SearchRec);
  try
    while status = 0 do begin
      if not (SearchRec.Attr and faDirectory = SearchRec.Attr) then begin
        s := SearchRec.Name;
        if LastPos(KoordFileExt, LowerCase(s)) > 1 then s := Copy(s, 1, LastPos(KoordFileExt, LowerCase(s)) -1);
        FileList.Add(s);
      end;
      status := FindNext(SearchRec);
    end;
    result := true;
  finally
    FindClose(SearchRec);
  end;
end;

procedure TfrmKonvMain.btnAbortClick(Sender: TObject);
begin
  btnAbort.Enabled := false;
  Aborted := true;
end;

procedure TfrmKonvMain.ConvertFile(AFileName: string);
var
  Profil: TProfil;
begin
  Profil := TProfil.Create;
  try
    { Alte Profildaten einlesen }
    Profil.LoadOldFiles(AFileName);

    try

      try
        Profil.SaveAs(ConvertProfilnameToFilename(Profil.ProfilName));
      except
      end;

    finally

      {$i-}
      if FileExists(ProfilPath + AFileName + KoordFileExt) then
        DeleteFile(ProfilPath + AFileName + KoordFileExt);
      if FileExists(ProfilPath + AFileName + PolareFileExt) then
        DeleteFile(ProfilPath + AFileName + PolareFileExt);
      if FileExists(ProfilPath + AFileName + PEFFileExt) then
        DeleteFile(ProfilPath + AFileName + PEFFileExt);
      {$i+}
    end;

  finally
    FreeAndNil(Profil);
  end;
end;

procedure TfrmKonvMain.CleanUpDir;
var
  SearchRec : TSearchRec;
  status : integer;
begin
  status := FindFirst(ProfilPath + '*' + PolareFileExt, faAnyFile, SearchRec);
  try
    while status = 0 do begin
      if not (SearchRec.Attr and faDirectory = SearchRec.Attr) then begin
        {$i-}
        DeleteFile(ProfilPath + Searchrec.name);
        {$i+}
      end;
      status := FindNext(SearchRec);
    end;
  finally
    FindClose(SearchRec);
  end;
end;

end.
