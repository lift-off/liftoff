unit enterAuslegung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, idTranslator;

type
  TfrmEnterAuslegung = class(TForm)
    edCa: TEdit;
    edV: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    Label5: TLabel;
    Label7: TLabel;
    translator: TidTranslator;
    procedure edCaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnterAuslegung: TfrmEnterAuslegung;

implementation

uses maindata;

{$R *.dfm}

procedure TfrmEnterAuslegung.edCaChange(Sender: TObject);
begin
  btnOk.Enabled:= (edCa.Text <> '') and (edV.Text <> '');
end;

procedure TfrmEnterAuslegung.FormCreate(Sender: TObject);
begin
  edCaChange( self );
end;

procedure TfrmEnterAuslegung.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  dmMain.CheckForSpecialKey(key, Shift, translator);
end;

procedure TfrmEnterAuslegung.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

end.
