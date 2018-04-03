unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxShellBrowserDialog, DB, StdCtrls, ADODB, XPMan, ComCtrls;

type
  TfrmMain = class(TForm)
    ProfiliConnection: TADOConnection;
    tabProfile: TADOTable;
    Label1: TLabel;
    edMdb: TEdit;
    btnBrwoseMdb: TButton;
    dlgBrowseMdb: TOpenDialog;
    Label2: TLabel;
    edOutputFolder: TEdit;
    btnBrowseOutputFolder: TButton;
    dlgBrowseOutputFolder: TcxShellBrowserDialog;
    btnStart: TButton;
    btnAbort: TButton;
    XPManifest1: TXPManifest;
    GroupBox1: TGroupBox;
    prgAirfoilcount: TProgressBar;
    Label3: TLabel;
    lblAirfoilCount: TLabel;
    Label4: TLabel;
    memLog: TMemo;
    lblAirfoilName: TLabel;
    cbNewOnly: TCheckBox;
    qryPolarkoordinaten: TADOQuery;
    qryPolarkoepfe: TADOQuery;
    qryKoordinaten: TADOQuery;
    procedure btnBrwoseMdbClick(Sender: TObject);
    procedure btnBrowseOutputFolderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
  private
    { Private declarations }
    procedure ImportAirfoils;
    procedure UpdateAirfoilCount( APos, AMax: integer );
    procedure AddLogLine( AText: string );
    procedure ImportCurrentAirfoil;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  id_string, id_tools,
  profile, ad_consts;

{$R *.dfm}

procedure TfrmMain.btnBrwoseMdbClick(Sender: TObject);
begin
  dlgBrowseMdb.FileName:= ExtractFileName( edMdb.Text );
  dlgBrowseMdb.InitialDir:= ExtractFilePath( edMdb.Text );
  if dlgBrowseMdb.Execute then begin
    edMdb.Text:= dlgBrowseMdb.FileName;
  end;
end;

procedure TfrmMain.btnBrowseOutputFolderClick(Sender: TObject);
begin
  dlgBrowseOutputFolder.Path:= edOutputFolder.Text;
  if dlgBrowseOutputFolder.Execute then begin
    edOutputFolder.Text:= dlgBrowseOutputFolder.Path;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  edMdb.Text:= UpNLevels( ExtractFilePath( ParamStr(0) ), 1 ) + '\profili_packs\Profili1.mdb';
  edOutputFolder.Text:= ExtractFilePath( ParamStr(0) ) + 'output';
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  ImportAirfoils;
end;

procedure TfrmMain.UpdateAirfoilCount( APos, AMax: integer );
begin
  lblAirfoilCount.Caption:= Format( '%d / %d', [ APos, AMax ] );
  prgAirfoilcount.Max:= AMax;
  prgAirfoilcount.Position:= APos;
end;

procedure TfrmMain.AddLogLine(AText: string);
begin
  memLog.Lines.Add( '[' + DateTimeToStr( Now ) + '] ' + AText );
  memLog.ScrollBy( 0, 1 );
end;

procedure TfrmMain.ImportAirfoils;
const
  connectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=....;Mode=Read;Persist Security Info=False;Jet OLEDB:Compact Without Replica Repair=True';
var
  countAirfoils: integer;
  countAirfoilsDone: integer;
begin

  assert( not ProfiliConnection.Connected, 'ADO Database is already connected! Use the delphi designer to diconnect it before run this tool.' );

  if not FileExists( edMdb.Text ) then begin
    Application.MessageBox( PChar( Format( 'No database found in [%s]!', [ edMdb.Text ] )),
                            'Invalid .mdb',
                            mb_IconStop + mb_Ok );
    exit;
  end;

  if not DirExists( edOutputFolder.Text ) then begin
    Application.MessageBox( PChar( Format( 'Outputfolder [%s] not found!', [ edOutputFolder.Text ] )),
                            'Invalid output folder',
                            mb_IconStop + mb_Ok );
    exit;
  end;

  btnAbort.Tag:= 0;
  btnStart.Enabled:= false;
  btnAbort.Enabled:= true;
  Screen.Cursor:= crHourglass;
  try

    memLog.Clear;

    ProfiliConnection.ConnectionString:= BuildADOConnectionStr( connectionString, edMdb.Text );
    AddLogLine( 'Connecting Profili database using ADO...  ' + ProfiliConnection.ConnectionString );
    ProfiliConnection.Connected:= true;
    try
      AddLogLine( 'Connected.' );

      AddLogLine( 'Open table [Profili] ...' );
      tabProfile.Active:= true;
      AddLogLine( 'Open table [Coordinate] ...' );

      AddLogLine( 'Starting import ...' );
      countAirfoils:= tabProfile.RecordCount;
      countAirfoilsDone:= 0;
      UpdateAirfoilCount( countAirfoilsDone, countAirfoils );

      tabProfile.First;
      while not tabProfile.Eof do begin

        ImportCurrentAirfoil();

        inc( countAirfoilsDone );
        UpdateAirfoilCount( countAirfoilsDone, countAirfoils );

        Application.ProcessMessages;

        { Abort by user ? }
        if btnAbort.Tag = 1 then begin
          AddLogLine( 'ABORTED BY USER.' );
          Break;
        end;

        tabProfile.Next;

      end;

      AddLogLine( 'Import finished.');

    finally
      AddLogLine( 'Disconnecting Profili database ...');
      ProfiliConnection.Connected:= false;
      AddLogLine( 'Disconnected.');
    end;


  finally
    btnStart.Enabled:= true;
    btnAbort.Enabled:= false;
    Screen.Cursor:= crDefault;
  end;
end;


procedure TfrmMain.btnAbortClick(Sender: TObject);
begin
  btnAbort.Enabled:= false;
  btnAbort.Tag:= 1;
end;

procedure TfrmMain.ImportCurrentAirfoil;
var
  airfoil: TProfil;
  x, y: currency;
  filename: string;
  currentAirfoilName: string;
  reSet: TReSet;
begin
  airfoil:= TProfil.Create;
  try

    currentAirfoilName:= ReplaceChars(VarToStr( tabProfile.FieldValues[ 'Nome' ] ), [','], '.');
    lblAirfoilName.Caption:= currentAirfoilName;

    filename:= IncludeTrailingPathDelimiter(edOutputFolder.Text) +
               MakeValidFileName( currentAirfoilName ) +
               ProfilFileExt;

    if FileExists( filename ) then begin
      if cbNewOnly.Checked then begin
        AddLogLine( Format( 'Airfoil [%s] SKIPED!', [ currentAirfoilName ] ));
        exit;
      end else begin
        { Delete existing airfoil }
        {$i-}
        DeleteFile( fileName );
        {$i+}
      end;
    end;
    AddLogLine( Format( 'Airfoil [%s] ...', [ currentAirfoilName ] ));

    airfoil.Bezeichnung:= VarToStrDef(tabProfile.FieldValues['Note'], '');

    { Coordiantes }
    qryKoordinaten.SQL.Text:=
      'SELECT Fk_Id_Profilo, X, Y FROM Coordinate' +
      ' WHERE Fk_Id_Profilo = ' + CurrToStr(tabProfile.FieldValues[ 'Id' ]);
    qryKoordinaten.Open;
    try
      qryKoordinaten.First;
      while not qryKoordinaten.Eof do begin
        x:= qryKoordinaten.FieldValues[ 'X' ];
        y:= qryKoordinaten.FieldValues[ 'Y' ];
        airfoil.Koordinaten.AddKoordinate( x, y );
        qryKoordinaten.Next;
      end;
    finally
      qryKoordinaten.Close;
    end;

    { Polarheaders }
    qryPolarkoepfe.SQL.Clear;
    qryPolarkoepfe.SQL.Text:=
      'SELECT Id, Fk_Id_Profilo, Re FROM PolariHeader' +
      ' WHERE Fk_Id_Profilo = ' + CurrToStr(tabProfile.FieldValues[ 'Id' ]) +
      ' ORDER BY Re';
    qryPolarkoepfe.Open;
    try

      qryPolarkoepfe.First;
      while not qryPolarkoepfe.Eof do begin

        reSet:= airfoil.Polaren.Add( qryPolarkoepfe.FieldValues[ 'Re' ] * 1000 );

        qryPolarkoordinaten.SQL.Text:=
          'SELECT Fk_Id_Polare, CL, CD FROM PolariCoordinate' +
          ' WHERE Fk_Id_Polare = ' + CurrToStr(qryPolarkoepfe.FieldValues[ 'Id' ])+
          ' ORDER BY CL';
        qryPolarkoordinaten.Open;
        try

          { Polardata }
          qryPolarkoordinaten.First;
          while not qryPolarkoordinaten.Eof do begin

            reSet.Add( qryPolarkoordinaten.FieldValues['CL'] / 10000 ,
                       qryPolarkoordinaten.FieldValues['CD'] / 10000 );

            qryPolarkoordinaten.Next;
          end;

        finally
          qryPolarkoordinaten.Close;
        end;

        qryPolarkoepfe.Next;

      end;
    finally
      qryPolarkoepfe.Close;
    end;


    { Save new airfoil }
    airfoil.SaveAs( filename, true );

  finally
    FreeAndNil( airfoil );
  end;
end;

end.
