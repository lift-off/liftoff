unit varianteneu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, idGroupHeader, ExtCtrls, idTranslator;

type
  TfrmVarianteNeu = class(TForm)
    Image1: TImage;
    idGroupHeader1: TidGroupHeader;
    Label1: TLabel;
    Label2: TLabel;
    edVariantenName: TEdit;
    cbCopyValues: TCheckBox;
    btnOk: TButton;
    btncancel: TButton;
    translator: TidTranslator;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVarianteNeu: TfrmVarianteNeu;

implementation

uses maindata;

{$R *.dfm}

procedure TfrmVarianteNeu.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  dmMain.CheckForSpecialKey(key, Shift, translator);
end;

procedure TfrmVarianteNeu.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

end.
