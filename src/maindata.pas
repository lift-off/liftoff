unit maindata;

interface

uses
  SysUtils, Classes, idTranslatorDataProvider, idTranslator, idTranslatorDataProviderINI;

type
  TdmMain = class(TDataModule)
    idTranslationProvider: TidTlINIDataProvider;
    Translator: TidTranslator;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    { Translation / Multilanguage support }
    procedure CheckForSpecialKey( var Key: Word; Shift: TShiftState; Translator: TidTranslator );
    procedure RefreshLanguageRelatedData;
    procedure ShowValidationError(text: string);
    
  end;

var
  dmMain: TdmMain;

implementation

uses
  windows, dialogs, mainapp, configuration, main, forms;

{$R *.dfm}

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  idTranslationProvider.IniFileName:= AppPath + 'liftoff.lng';

  RefreshLanguageRelatedData;
  if (frmMain <> nil) then frmMain.StartUpAfterTranslationIsReady();
end;

procedure TdmMain.CheckForSpecialKey( var Key: Word; Shift: TShiftState; Translator: TidTranslator );
begin
  if Shift = [ ssCtrl ] then begin
    case Key of
      VK_F12: begin
                Key:= 0;
                Translator.WriteDefaultTranslationData;
                ShowMessage( 'Language data have been written.' );
              end;
    end;
  end;
end;

procedure TdmMain.RefreshLanguageRelatedData;
begin
  idTranslationProvider.Language:= GlobalConfig.Language;
end;

procedure TdmMain.ShowValidationError(text: string);
begin
  Application.MessageBox(PChar(text),
                         PChar(Translator.GetLit('ValidationErrorCaption')),
                         mb_IconStop + mb_Ok );
end;

end.
