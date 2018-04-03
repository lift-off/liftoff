unit selectAuslegung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, idTranslator, maindata;

type
  TfrmSelectAuslegung = class(TForm)
    lvAuslegung: TListView;
    Panel1: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    translator: TidTranslator;
    procedure lvAuslegungClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvAuslegungDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure translatorTranslate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSelectAuslegung: TfrmSelectAuslegung;

implementation

{$R *.dfm}

procedure TfrmSelectAuslegung.lvAuslegungClick(Sender: TObject);
begin
  btnOk.Enabled:= assigned( lvAuslegung.Selected );
end;

procedure TfrmSelectAuslegung.FormCreate(Sender: TObject);
begin
  lvAuslegungClick( self );
end;

procedure TfrmSelectAuslegung.lvAuslegungDblClick(Sender: TObject);
begin
  lvAuslegungClick(self);
  btnOk.Click;
end;

procedure TfrmSelectAuslegung.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  dmMain.CheckForSpecialKey(key, Shift, translator);
end;

procedure TfrmSelectAuslegung.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

procedure TfrmSelectAuslegung.translatorTranslate(Sender: TObject);
begin
  lvAuslegung.Columns[0].Caption := translator.GetLit('colDescription');
  lvAuslegung.Columns[1].Caption := translator.GetLit('colCl');
  lvAuslegung.Columns[2].Caption := translator.GetLit('colMaxSpeed');
end;

end.
