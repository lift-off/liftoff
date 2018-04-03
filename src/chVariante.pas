unit chVariante;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  modell, varianten, ComCtrls, StdCtrls, ExtCtrls, Buttons, ad_consts,
  profile, idTitleBar;

type
  TfraModellVariante = class(TFrame)
    idTitleBar1: TidTitleBar;
    Label1: TLabel;
    Shape1: TShape;
    Label2: TLabel;
    Label26: TLabel;
    Panel2: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    Label8: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    edSchwerpunkt: TEdit;
    edStabilitaetsmass: TEdit;
    edLeitwerkshebel: TEdit;
    edTiefeRandbogen: TEdit;
    edTiefeTrapezstoss: TEdit;
    edLageTrapezstoss: TEdit;
    edWurzeltiefe: TEdit;
    edSpannweite: TEdit;
    edFlaechenbelastung: TEdit;
    edProfilInnen: TEdit;
    edProfilAussen: TEdit;
    edAlpha0Innen: TEdit;
    edAlpha0Aussen: TEdit;
    edCm0Innen: TEdit;
    edCm0Aussen: TEdit;
    BitBtn1: TBitBtn;
    Shape2: TShape;
    idTitleBar2: TidTitleBar;
    Shape3: TShape;
    Shape4: TShape;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure edLageTrapezstossExit(Sender: TObject);
    procedure edLageTrapezstossChange(Sender: TObject);
    procedure edProfilInnenExit(Sender: TObject);
    procedure edProfilAussenExit(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure edProfilAussenEnter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure edProfilInnenChange(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateProfildatenInnen;
    procedure UpdateProfildatenAussen;
    procedure ReportModellauslegung;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Validate: boolean;
    function SaveData: boolean;
    function LoadData: boolean;
    procedure SetAltered;

    procedure UpdateBerechneteDaten;
  end;

implementation

uses report_modellauslegung, main, report_variantenvergleich, profilchoose,
  calcflaechenbelastung;

{$R *.dfm}

constructor TfraModellVariante.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TfraModellVariante.Destroy;
begin
  inherited;
end;

function TfraModellVariante.Validate: boolean;
begin
  { Hier werden die Eingabevalidierungen vorgenommen }
  result := true;
end;

function TfraModellVariante.SaveData: boolean;
begin
  { Werte aus dem UI in das Modell-Objekt abfüllen, welches die gesammten
    Berechnungen etc. vornimmt. }
  result := false;

  assert(assigned(CurrentModell));
  if Trim(edProfilAussen.Text) = '' then
    edProfilAussen.Text := edProfilInnen.Text;

  with CurrentModell.Variante do begin
    //VariantenName := frmMain.edVariantenName.Text;

    ProfilInnen.Dateiname := edProfilInnen.Text;
    ProfilAussen.Dateiname := edProfilAussen.Text;

    Flaechenbelastung := StrToFloat(edFlaechenbelastung.Text);
    Spannweite := StrToInt(edSpannweite.Text);
    Wurzeltiefe := StrToFloat(edWurzeltiefe.Text);
    LageTrapezstoss := StrToFloat(edLageTrapezstoss.Text);
    TiefeTrapezstoss := StrToFloat(edTiefeTrapezstoss.Text);
    TiefeRandbogen := StrToFloat(edTiefeRandbogen.Text);
    Leitwerkshebel := StrToFloat(edLeitwerkshebel.Text) / 100;
    Stabilitatsmass := StrToFloat(edStabilitaetsmass.Text);
    Schwerpunkt := StrToFloat(edSchwerpunkt.Text);


  end;
  result := true;
end;

procedure TfraModellVariante.ReportModellauslegung;
var
  qrpModellauslegung: TqrpModellauslegung;
begin
  qrpModellauslegung := TqrpModellauslegung.Create(self);
  try
    qrpModellauslegung.ModellVariante := CurrentModell.Variante;
    with qrpModellauslegung, CurrentModell.Variante do begin
      { Daten in Report abfüllen }
      qrModellName.Caption := CurrentModell.ModellName;
      qrVariantenName.Caption := VariantenName;
      qrProfilInnen.Caption := ProfilInnen.Dateiname;
      qrProfilAussen.Caption := ProfilAussen.Dateiname;
      qrProfilInnenDaten.Caption := Format('(Alpha0 = %-1.2f°, Cm0 = %-2.4f)', [ProfilInnen.Alpha0, ProfilInnen.cm0]);
      qrProfilAussenDaten.Caption := Format('(Alpha0 = %-1.2f°, Cm0 = %-2.4f)', [ProfilAussen.Alpha0, ProfilAussen.cm0]);

      qr1.Caption := Format('%-.0f', [G]);
      qr2.Caption := Format('%-.1f', [Flaechenbelastung]);
      qr3.Caption := Format('%d', [Spannweite]);
      qr4.Caption := Format('%.0f', [Wurzeltiefe]);
      qr5.Caption := Format('%.0f', [TiefeTrapezstoss]);
      qr6.Caption := Format('%.0f', [LageTrapezstoss]);
      qr7.Caption := Format('%.0f', [TiefeRandbogen]);
      qr8.Caption := Format('%-.1f', [F]);
      qr9.Caption := Format('%1.2f', [Z]);
      qr10.Caption := Format('%2.1f', [L1]);
      qr11.Caption := Format('%3.1f', [T4]);
      qr12.Caption := Format('%3.1f', [TMF]);
      qr13.Caption := Format('%4.1f', [XTMF]);

      qr14.Caption := Format('%3.1f', [FAI]);
      qr15.Caption := Format('%3.1f', [NP]);
      qrCAE.Caption := Format('%1.1f', [Schwerpunkt]);
      qr16.Caption := Format('%3.1f', [DP]);
      qr17.Caption := Format('%3.1f', [NE]);
      qr18.Caption := Format('%2.1f', [Stabilitatsmass]);
      qr19.Caption := Format('%4.1f', [RH * 100]);
      qr20.Caption := Format('%2.1f', [FH]);
      qr21.Caption := Format('%2.1f', [VH]);
      qr22.Caption := Format('%2.1f', [LHLw]);
      qr23.Caption := Format('%4.1f', [BHLw]);
      qr24.Caption := Format('%3.1f', [TMH]);
      qr25.Caption := Format('%2.1f', [FS]);
      qr26.Caption := Format('%1.4f', [cm0zwi]);

      qr27.Caption := Format('%3.2f', [NPNeu]);
      qr28.Caption := Format('%3.2f', [STFH]);
      qr29.Caption := Format('%3.2f', [STFS]);

      { Modaler Preview aus welchem auch gedruckt werden kann }
      QuickRep1.PreviewModal;
    end;
  finally
    FreeAndNil(qrpModellauslegung);
  end;
end;

procedure TfraModellVariante.BitBtn1Click(Sender: TObject);
begin
  if Validate then begin
    SaveData;
    CurrentModell.Variante.AuslegungBerechnen;
    UpdateBerechneteDaten;
    ReportModellauslegung;
  end;
end;

procedure TfraModellVariante.edLageTrapezstossExit(Sender: TObject);
var
  trap : currency;
begin
  trap := 0;

  if Trim(edLageTrapezstoss.Text) <> '' then begin
    try
      trap := StrToFloat(edLageTrapezstoss.Text);
    except
      trap := 0;
    end;
  end;

  edTiefeTrapezstoss.Enabled := (trap <> 0);
  if ((Trap = 0) or (edTiefeTrapezstoss.Text = ''))
  and (edTiefeTrapezstoss.Text <> edWurzeltiefe.Text) then
    edTiefeTrapezstoss.Text := edWurzeltiefe.Text;
end;

procedure TfraModellVariante.edLageTrapezstossChange(Sender: TObject);
begin
  edTiefeTrapezstoss.Enabled := Trim(edLageTrapezstoss.Text) <> '';
end;

procedure TfraModellVariante.UpdateProfildatenInnen;
//var i : integer;
begin
  edAlpha0Innen.Text := Format('%-1.2f°', [CurrentModell.Variante.ProfilInnen.Alpha0]);
  edCm0Innen.Text := Format('%-0.4f', [CurrentModell.Variante.ProfilInnen.Cm0]);

  {
  Memo1.Clear;
  for i := Low(Modell.ProfilInnen.Koordinaten) to
           High(Modell.ProfilInnen.Koordinaten) do
    Memo1.Lines.Add(CurrToStr(Modell.ProfilInnen.Koordinaten[i].x) + ', ' + CurrToStr(Modell.ProfilInnen.Koordinaten[i].y));
  }
end;

procedure TfraModellVariante.UpdateProfildatenAussen;
begin
  edAlpha0Aussen.Text := Format('%-1.2f°', [CurrentModell.Variante.ProfilAussen.Alpha0]);
  edCm0Aussen.Text := Format('%-0.4f', [CurrentModell.Variante.ProfilAussen.Cm0]);
end;

procedure TfraModellVariante.UpdateBerechneteDaten;
begin
  UpdateProfildatenInnen;
  UpdateProfildatenAussen;
end;

procedure TfraModellVariante.edProfilInnenExit(Sender: TObject);
begin
  if edProfilInnen.Text <> '' then
    CurrentModell.Variante.ProfilInnen.Dateiname := edProfilInnen.Text;
  UpdateProfildatenInnen;
end;

procedure TfraModellVariante.edProfilAussenExit(Sender: TObject);
begin
  if edProfilAussen.Text <> '' then
    CurrentModell.Variante.ProfilAussen.Dateiname := edProfilAussen.Text;
  UpdateProfildatenAussen;
end;

procedure TfraModellVariante.SetAltered;
begin
  frmMain.Altered := true;
end;

function TfraModellVariante.LoadData: boolean;
begin
  result := false;
  with CurrentModell.Variante do begin
    edProfilInnen.Text := ProfilInnen.Dateiname;
    edProfilAussen.Text := ProfilAussen.Dateiname;

    edFlaechenbelastung.Text := FloatToStr(Flaechenbelastung);
    edSpannweite.Text := IntToStr(Spannweite);
    edWurzeltiefe.Text := FloatToStr(Wurzeltiefe);
    edLageTrapezstoss.Text := FloatToStr(LageTrapezstoss);
    edTiefeTrapezstoss.Text := FloatToStr(TiefeTrapezstoss);
    edTiefeRandbogen.Text := FloatToStr(TiefeRandbogen);
    edLeitwerkshebel.Text := FloatToStr(Leitwerkshebel * 100);
    edStabilitaetsmass.Text := FloatToStr(Stabilitatsmass);
    edSchwerpunkt.Text := FloatToStr(Schwerpunkt);

    UpdateBerechneteDaten;
  end;
  result := true;
end;

procedure TfraModellVariante.BitBtn2Click(Sender: TObject);
var
  qrpModellauslegung: TqrpModellauslegung;
begin
  if Validate then begin
    SaveData;
    CurrentModell.Variante.AuslegungBerechnen;
    UpdateBerechneteDaten;
    qrpVariantenVergleich := TqrpVariantenVergleich.Create(self);
    try
      qrpVariantenVergleich.Modell := CurrentModell;
      qrpVariantenVergleich.QuickRep1.PreviewModal;
    finally
      FreeAndNil(qrpVariantenVergleich);
    end;
  end;
end;

procedure TfraModellVariante.Button1Click(Sender: TObject);
var
  frmProfilChoose : TfrmProfilChoose;
begin
  frmProfilChoose := TfrmProfilChoose.Create(self);
  try
    frmProfilChoose.Profilname := edProfilInnen.Text;
    if frmProfilChoose.Execute then 
      edProfilInnen.Text := frmProfilChoose.Profilname;
  finally
    FreeAndNil(frmProfilChoose);
    edProfilInnenExit(self);
  end;
end;

procedure TfraModellVariante.Button2Click(Sender: TObject);
var
  frmProfilChoose : TfrmProfilChoose;
begin
  frmProfilChoose := TfrmProfilChoose.Create(self);
  try
    frmProfilChoose.Profilname := edProfilAussen.Text;
    if frmProfilChoose.Execute then edProfilAussen.Text := frmProfilChoose.Profilname;
  finally
    FreeAndNil(frmProfilChoose);
    edProfilAussenExit(self);
  end;
end;

procedure TfraModellVariante.edProfilAussenEnter(Sender: TObject);
begin
  if  (edProfilAussen.Text = '')
  and (edProfilInnen.Text <> '') then
    edProfilAussen.Text := edProfilInnen.Text;
end;

procedure TfraModellVariante.SpeedButton1Click(Sender: TObject);
begin
  if not assigned(frmCalcFlaechenbelastung) then
    Application.CreateForm(TfrmCalcFlaechenbelastung,  frmCalcFlaechenbelastung);

  frmCalcFlaechenbelastung.edB.Text := edSpannweite.Text;
  if frmCalcFlaechenbelastung.ShowModal = mrOk then begin
    edFlaechenbelastung.Text := frmCalcFlaechenbelastung.Edit6.Text;
    edSpannweite.Text := frmCalcFlaechenbelastung.edB.Text;
    SetAltered;
  end;
end;

procedure TfraModellVariante.edProfilInnenChange(Sender: TObject);
begin
  SetAltered;
end;

end.
