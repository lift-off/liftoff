unit pi_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DB, Grids, DBGrids, StdCtrls, ExtCtrls, jpeg;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Shape1: TShape;
    Label1: TLabel;
    Shape2: TShape;
    Label2: TLabel;
    edProfiliDb: TEdit;
    btnChooseDb: TButton;
    Label3: TLabel;
    DBGrid1: TDBGrid;
    Label4: TLabel;
    btnImport: TButton;
    ProfiliConnection: TADOConnection;
    tabProfile: TADOTable;
    qryKoordinaten: TADOQuery;
    qryPolarkoepfe: TADOQuery;
    qryPolarkoordinaten: TADOQuery;
    dlgBrowseMdb: TOpenDialog;
    dsProfile: TDataSource;
    procedure btnChooseDbClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
  private
    { Private declarations }
    procedure ImportCurrentAirfoil;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  id_string, profile, ad_consts;

procedure TfrmMain.btnChooseDbClick(Sender: TObject);
const
  connectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=....;Mode=Read;Persist Security Info=False;Jet OLEDB:Compact Without Replica Repair=True';
begin
  dlgBrowseMdb.FileName:= ExtractFileName( edProfiliDb.Text );
  dlgBrowseMdb.InitialDir:= ExtractFilePath( edProfiliDb.Text );
  if dlgBrowseMdb.Execute then begin
    edProfiliDb.Text:= dlgBrowseMdb.FileName;

    ProfiliConnection.Connected:= false;
    ProfiliConnection.ConnectionString:= BuildADOConnectionStr( connectionString, edProfiliDb.Text );
    ProfiliConnection.Connected:= true;
    tabProfile.Active:= true;
    dsProfile.Enabled:= true;

  end;
end;

procedure TfrmMain.btnImportClick(Sender: TObject);

  procedure ShowError(err: string);
  begin
    Application.MessageBox(PChar(Err), 'Eingabefehler', MB_ICONSTOP + MB_OK);
  end;

begin

  if not ProfiliConnection.Connected then begin
    ShowError('Sie müssen erst eine gültige Profili-Datenbank auswählen!');
    edProfiliDb.SetFocus;
    btnChooseDb.SetFocus;
    exit;
  end;

  if Application.MessageBox(
     PChar(Format('Soll das Profil "%s" importiert werden?', [tabProfile.FieldValues['Nome']])),
     'Importiern',
     MB_ICONQUESTION + MB_YESNO) = idYes
  then begin

    dsProfile.Enabled:= false;
    ImportCurrentAirfoil();

  end;

end;

procedure TfrmMain.ImportCurrentAirfoil;
var
  airfoil: TProfil;
  x, y: currency;
  filename: string;
  currentAirfoilName: string;
  reSet: TReSet;
  profilDir: string;
begin
  airfoil:= TProfil.Create;
  try

    currentAirfoilName:= ReplaceChars(VarToStr( tabProfile.FieldValues[ 'Nome' ] ), [','], '.');
    profilDir:= ExtractFilePath(ParamStr(0)) + 'profile';
    filename:= IncludeTrailingPathDelimiter(profilDir) +
               MakeValidFileName( currentAirfoilName ) +
               ProfilFileExt;

    if FileExists( filename ) then begin
      if Application.MessageBox('Ein Profil mit diesem Namen existiert in LiftOff bereits. Wollen Sie dieses Überschreiben?',
                                'Bestehendes Profil überschreiben',
                                MB_ICONWARNING + MB_YESNO ) = idNo
      then begin
        exit;
      end else begin
        { Delete existing airfoil }
        {$i-}
        DeleteFile( fileName );
        {$i+}
      end;
    end;

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

    Application.MessageBox(
      PChar(Format('Das Profil "%s" wurde erfolgreich in LiftOff Importiert.', [currentAirfoilName])),
      'Profil importiert',
      MB_ICONINFORMATION + MB_OK);

  finally
    FreeAndNil( airfoil );
    dsProfile.Enabled:= true;
  end;

  if Application.MessageBox('Wollen Sie weitere Profile importieren?',
                            'Weitere Profile Importieren',
                            MB_ICONQUESTION + MB_YESNO) = idNo
  then begin
    Close;
  end;

end;


end.
