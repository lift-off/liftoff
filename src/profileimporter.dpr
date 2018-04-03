program profileimporter;

uses
  Forms,
  pi_main in 'pi_main.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'LiftOff Profil Importer';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
