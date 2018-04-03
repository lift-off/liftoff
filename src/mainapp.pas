unit mainapp;

interface

uses
  forms, sysutils, windows, classes,
  main, maindata, dialogs,
  ad_consts,
  modellauswahl,
  textedit,
  splash;

type
  TLiftOff = class
  public
    class procedure CheckCmdParams;
    class procedure InitializeAndRun;
  end;

var
  AppPath : string;

implementation

uses
  versinfo, id_string, id_tools, logging, materialien, configuration,
  idTranslator;

{ TLiftOff }

class procedure TLiftOff.InitializeAndRun;
var
  VInfo : TdfsVersionInfoResource;
  act: string;
begin
  AppPath := ExtractFilePath(ParamStr(0));

  Logfile.WriteToLog( llInfo, 'Starting Liftoff (InitializeAndRun) ...' );

  Logfile.WriteToLog( llInfo, 'Loading global configuration ...' );
  GlobalConfig.Load();
  Logfile.WriteToLog( llInfo, '- Language: ' + GlobalConfig.Language );

  Logfile.WriteToLog( llInfo, 'Create main data module ...' );
  dmMain := TdmMain.Create(Application);
  LoadSparTexts();

  // Loading version info
  Logfile.WriteToLog( llInfo, 'Reading version info ...' );
  VInfo := TdfsVersionInfoResource.Create(nil);
  try
    with VInfo do begin
      ForceEXE := true;
      ProgVersion := FileVersion.AsString;
      ProgVersionLong := ProductVersion.AsString + ' (' + FileVersion.AsString + ')';
    end;
  finally
    FreeAndNil(VInfo);
  end;

  // Show splash form
  Logfile.WriteToLog( llInfo, 'Create and show splash form ...' );
  frmSplash := TfrmSplash.Create(nil);
  try
    frmSplash.Show;
    Application.ProcessMessages;

    // Initialize application settings
    Logfile.WriteToLog( llInfo, 'Initialize application settings ...' );
    Application.Initialize;
    Application.Title := ProgramName;

    // Create and start main form and main data module
    Logfile.WriteToLog( llInfo, 'Create main form ...' );
    Application.CreateForm(TfrmMain, frmMain);
    frmMain.StartUpAfterTranslationIsReady();
    Logfile.WriteToLog( llInfo, 'Create frmModellAuswahl ...' );
    Application.CreateForm(TfrmModellAuswahl, frmModellAuswahl);
    Logfile.WriteToLog( llInfo, 'Create frmTextEdit ...' );
    Application.CreateForm(TfrmTextEdit, frmTextEdit);

    Logfile.WriteToLog( llInfo, 'Forms created successfully.' );

    Application.ProcessMessages;

  finally
    Logfile.WriteToLog( llInfo, 'Destroy splash form ...' );
    FreeAndNil(frmSplash);

    Logfile.WriteToLog( llInfo, 'Check command line parameters ...' );
    CheckCmdParams;

    Logfile.WriteToLog( llInfo, 'Application initalized successfully.' );
    Logfile.WriteToLog( llInfo, 'Enter global message loop (run) ...' );
    Application.Run;
    GlobalConfig.Save();
    Logfile.WriteToLog( llInfo, 'Global message loop left, shuting down ...' );
  end;
end;

class procedure TLiftOff.CheckCmdParams;
var
  i: Integer;
  cmd: TStringList;
  fn: string;
  dbfn: string;
begin
  ParseCommandLine( cmd );
  try
    if cmd.Count > 1 then begin
      for i:= 1 to pred( cmd.Count ) do begin
        { Filename as parameter indicates that a model file needs to be opened }
        fn:= RemoveBorders( cmd[i], '"' );
        if FileExists( fn ) then begin
          frmMain.LoadModell( fn );
          if not SameText( IncludeTrailingBackslash(ExtractFilepath( fn )),
                           IncludeTrailingBackslash(ModellPath) )
          then begin
            dbfn:= IncludeTrailingBackslash(ModellPath) + ExtractFileName( fn );
            if Application.MessageBox( PChar(dmMain.Translator.GetLit('ImportModelText')),
                                       PChar(dmMain.Translator.GetLit('ImportModelCaption')),
                                       mb_IconInformation + mb_YesNo ) = idYes
            then begin
              frmMain.Import( fn, true );
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil( cmd );
  end;
end;

end.
