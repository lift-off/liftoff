unit textedit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, idTranslator;

type
  TfrmTextEdit = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    btnOk: TButton;
    btnCancel: TButton;
    Memo1: TMemo;
    translator: TidTranslator;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Execute(ACaption: string; var AContent: string) : boolean;
  end;

var
  frmTextEdit: TfrmTextEdit;

implementation

uses maindata;

{$R *.dfm}

{ TfrmTextEdit }

function TfrmTextEdit.Execute(ACaption: string; var AContent: string): boolean;
begin
  Caption := ACaption;
  Memo1.Text := AContent;
  result := ShowModal = idOk;
  if result then
    AContent := Memo1.Text;
end;

procedure TfrmTextEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  dmMain.CheckForSpecialKey(key, Shift, translator);
end;

procedure TfrmTextEdit.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

end.
