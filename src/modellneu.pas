unit modellneu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, idGroupHeader, idTranslator;

type
  TfrmModellNeu = class(TForm)
    idGroupHeader1: TidGroupHeader;
    Image1: TImage;
    Label1: TLabel;
    edModellName: TEdit;
    edVariantenName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Image2: TImage;
    Image3: TImage;
    btnOk: TButton;
    btnCancel: TButton;
    translator: TidTranslator;
    procedure btnOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function CheckModellName: boolean;
  end;

var
  frmModellNeu: TfrmModellNeu;

implementation

uses
  ad_consts, maindata;

{$R *.dfm}

procedure TfrmModellNeu.btnOkClick(Sender: TObject);
begin
  if CheckModellName then begin
    Close;
    ModalResult := btnOk.ModalResult;
  end else begin
    ModalResult := mrNone;
  end;
end;

function TfrmModellNeu.CheckModellName: boolean;
begin
  result := false;

  if Trim(edModellName.Text) = '' then begin
    dmMain.ShowValidationError(dmMain.Translator.GetLit('ValidationEnterAModelname'));
    exit;
  end;

  if Trim(edVariantenName.Text) = '' then begin
    dmMain.ShowValidationError(dmMain.Translator.GetLit('ValidationEnterAVersionname'));
    exit;
  end;

  result := not FileExists(ModellPath + edModellName.Text + ModellFileExt);
  if not result then
    Application.MessageBox(PChar(
                             Format(dmMain.Translator.GetLit('ValidationModelAlreadyExists'),
                                    [edModellName.Text]
                             )
                           ),
                           PChar(dmMain.Translator.GetLit('ValidationModelAlreadyExistsCaption')),
                           mb_IconStop + mb_Ok);
end;

procedure TfrmModellNeu.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  dmMain.CheckForSpecialKey(key, Shift, translator);
end;

procedure TfrmModellNeu.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

end.
