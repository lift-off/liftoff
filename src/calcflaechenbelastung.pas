unit calcflaechenbelastung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, idGroupHeader, Buttons, idTranslator;

type
  TfrmCalcFlaechenbelastung = class(TForm)
    idGroupHeader1: TidGroupHeader;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edB: TEdit;
    edStreck: TEdit;
    edG: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    BitBtn1: TBitBtn;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    translator: TidTranslator;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    B,
    GFF,
    B1F,
    b1,
    F : currency;
    function Validate: boolean;
    procedure UpdateUI;
  end;

var
  frmCalcFlaechenbelastung: TfrmCalcFlaechenbelastung;

implementation

uses
  math, maindata;

{$R *.dfm}

procedure TfrmCalcFlaechenbelastung.BitBtn1Click(Sender: TObject);
begin
  if Validate then begin
    b := StrToCurr(edB.Text) / 1000;  // Spannweite (B) in m
    GFF := 0.43 * (Power(B, 0.25) + Power(StrToCurr(edStreck.Text), 0.333)); // Baugewicht Fläche in kg/qm
    F := Power(b, 2) / StrToCurr(edStreck.Text); // Tragflügelfläche aus Streckung und Spannweite in qm errechnen
    B1F := F * GFF; // Gewicht Tragflügel in kg
    b1 := (B1F + StrToCurr(edG.Text)) / F; // Modell-Flächenbelastung in kg/qm

    Edit4.Text := CurrToStr(GFF * 10);
    Edit5.Text := CurrToStr(1.75 * SQRT(b1 * 10));
    Edit6.Text := CurrToStr(b1 * 10);

    UpdateUI;
  end;
end;

procedure TfrmCalcFlaechenbelastung.UpdateUI;
begin
  btnOk.Enabled := Edit4.Text <> '';
end;

function TfrmCalcFlaechenbelastung.Validate: boolean;
begin
  result := false;

  if StrToCurrDef(edB.Text, 0) = 0 then begin
    Application.MessageBox('Ungültige Spannweite!', 'Eingabefehler', mb_IconStop +mb_OK);
    edB.SetFocus;
  end else
  if StrToCurrDef(edStreck.Text, 0) = 0 then begin
    Application.MessageBox('Ungültige Streckung!', 'Eingabefehler', mb_IconStop +mb_OK);
    edStreck.SetFocus;
  end else
  if StrToCurrDef(edG.Text, 0) = 0 then begin
    Application.MessageBox('Ungültiges Gewicht!', 'Eingabefehler', mb_IconStop +mb_OK);
    edG.SetFocus;
  end else
    result := true;
end;

procedure TfrmCalcFlaechenbelastung.FormCreate(Sender: TObject);
begin
  UpdateUI;
end;

procedure TfrmCalcFlaechenbelastung.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  dmMain.CheckForSpecialKey(key, Shift, translator);
end;

procedure TfrmCalcFlaechenbelastung.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

end.
