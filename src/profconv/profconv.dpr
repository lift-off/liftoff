program profconv;

uses
  Forms,
  main in 'main.pas' {frmKonvMain},
  profile in '..\profile.pas',
  ad_consts in '..\ad_consts.pas';

{$R *.res}

begin

  Application.Initialize;
  Application.Title := 'AeroDesign Profil Konverter';
  ExecApp;
  Application.Run;

end.
