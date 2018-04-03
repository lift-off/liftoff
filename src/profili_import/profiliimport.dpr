program profiliimport;

uses
  Forms,
  main in 'main.pas' {frmMain},
  profile in '..\profile.pas',
  ad_utils in '..\ad_utils.pas',
  ad_consts in '..\ad_consts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Profili Airfoil Importer';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
