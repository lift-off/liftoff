program TranslationSample;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  idTranslatorDataProvider in '..\idTranslatorDataProvider.pas',
  idTranslatorDataProviderXML in '..\idTranslatorDataProviderXML.pas',
  idTranslatorDataProviderINI in '..\idTranslatorDataProviderINI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
