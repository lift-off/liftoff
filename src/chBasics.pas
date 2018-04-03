unit chBasics;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  modell, varianten, ComCtrls, StdCtrls, ExtCtrls, Buttons, ad_consts,
  profile, idTitleBar, idTranslator;

type
  TfraBasics = class(TFrame)
    idTitleBar1: TidTitleBar;
    TitleLabel: TLabel;
    Shape1: TShape;
    SubtitleLabel: TLabel;
    Label26: TLabel;
    Panel2: TPanel;
    WingLoadingLabel: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    WingLoadingUnitLabel: TLabel;
    WingLoadingCalcButton: TSpeedButton;
    Label8: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    AirfoilFilenameNearLabel: TLabel;
    AirfoilFilenameFarLabel: TLabel;
    AirfoilAlphaNearLabel: TLabel;
    AirfoilAlphaFarLabel: TLabel;
    AirfoilCm0NearLabel: TLabel;
    AirfoilCm0FarLabel: TLabel;
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
    Shape4: TShape;
    ChooseAirfoilNearButton: TBitBtn;
    ChooseAirfoilFarButton: TBitBtn;
    BitBtn1: TBitBtn;
    pnlLeitwerkshebelInfo: TPanel;
    Shape2: TShape;
    Label27: TLabel;
    Image1: TImage;
    btnCalcLeitwerkshebel: TSpeedButton;
    BitBtn2: TBitBtn;
    Translator: TidTranslator;
    procedure edLageTrapezstossChange(Sender: TObject);
    procedure edProfilInnenExit(Sender: TObject);
    procedure edProfilAussenExit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure edProfilAussenEnter(Sender: TObject);
    procedure WingLoadingCalcButtonClick(Sender: TObject);
    procedure edProfilInnenChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnCalcLeitwerkshebelClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateProfildatenInnen;
    procedure UpdateProfildatenAussen;
    procedure UpdateLeitwerkshebelInfo;
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

uses
  ad_utils,
  report_modellauslegung, main, report_variantenvergleich, profilchoose,
  calcflaechenbelastung, Math, maindata;

{$R *.dfm}

constructor TfraBasics.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TfraBasics.Destroy;
begin
  inherited;
end;

function TfraBasics.Validate: boolean;

  procedure FocusControl( AControl: TWinControl );
  begin
    frmMain.SetPage( pagBasics );
    AControl.SetFocus;
    result:= false;
  end;

begin
  result:= false;

  { Hier werden die Eingabevalidierungen vorgenommen }

  if not ValidateCurr( WingLoadingLabel.Caption, edFlaechenbelastung, 1 ) then begin
    FocusControl( edFlaechenbelastung );
    exit;
  end;

  if not ValidateInt( Label7.Caption, edSpannweite, 1 ) then begin
    FocusControl( edSpannweite );
    exit;
  end;
  if not ValidateInt( Label9.Caption, edWurzeltiefe, 1 ) then begin
    FocusControl( edWurzeltiefe );
    exit;
  end;
  if not ValidateInt( Label13.Caption, edTiefeTrapezstoss, 0 ) then begin
    FocusControl( edTiefeTrapezstoss );
    exit;
  end;
  if not ValidateInt( Label15.Caption, edTiefeRandbogen, 1 ) then begin
    FocusControl( edFlaechenbelastung );
    exit;
  end;
  if not ValidateCurr( Label19.Caption, edStabilitaetsmass, 1 ) then begin
    FocusControl( edStabilitaetsmass );
    exit;
  end;
  if not ValidateCurr( Label21.Caption, edSchwerpunkt, 0.1, 2.0 ) then begin
    FocusControl( edSchwerpunkt );
    exit;
  end;

  result := true;
end;

function TfraBasics.SaveData: boolean;
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

    Flaechenbelastung := UIStringToCurrDef(edFlaechenbelastung.Text, 0);
    Spannweite := StrToInt(edSpannweite.Text);
    Wurzeltiefe := UIStringToCurrDef(edWurzeltiefe.Text, 0);
    LageTrapezstoss := UIStringToCurrDef(edLageTrapezstoss.Text, 0);
    TiefeTrapezstoss := UIStringToCurrDef(edTiefeTrapezstoss.Text, 0);
    TiefeRandbogen := UIStringToCurrDef(edTiefeRandbogen.Text, 0);
    if (UIStringToCurrDef(edLeitwerkshebel.Text, -1) <> -1) then
      Leitwerkshebel := UIStringToCurrDef(edLeitwerkshebel.Text, 0) / 100
    else
      Leitwerkshebel := 0;
    Stabilitatsmass := UIStringToCurrDef(edStabilitaetsmass.Text, 0);
    Schwerpunkt := UIStringToCurrDef(edSchwerpunkt.Text, 0);
  end;
  result := true;
end;

procedure TfraBasics.edLageTrapezstossChange(Sender: TObject);
begin
  edTiefeTrapezstoss.Enabled := Trim(edLageTrapezstoss.Text) <> '';
end;

procedure TfraBasics.UpdateProfildatenInnen;
var i : integer;
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

procedure TfraBasics.UpdateProfildatenAussen;
begin
  edAlpha0Aussen.Text := Format('%-1.2f°', [CurrentModell.Variante.ProfilAussen.Alpha0]);
  edCm0Aussen.Text := Format('%-0.4f', [CurrentModell.Variante.ProfilAussen.Cm0]);
end;

procedure TfraBasics.UpdateBerechneteDaten;
begin
  UpdateProfildatenInnen;
  UpdateProfildatenAussen;
end;

procedure TfraBasics.edProfilInnenExit(Sender: TObject);
begin
  if edProfilInnen.Text <> '' then
    CurrentModell.Variante.ProfilInnen.Dateiname := edProfilInnen.Text;
  UpdateProfildatenInnen;
end;

procedure TfraBasics.edProfilAussenExit(Sender: TObject);
begin
  if edProfilAussen.Text <> '' then
    CurrentModell.Variante.ProfilAussen.Dateiname := edProfilAussen.Text;
  UpdateProfildatenAussen;
end;

procedure TfraBasics.SetAltered;
begin
  frmMain.Altered := true;
  if not frmMain.IsUpdateing then begin
    { Es kann sein, dass während der Eingabe ein Eingabewert ungültig ist.
      Ist dies der Fall, kann die Modellgrafik nicht richtig aktualisiert werden.
      Es wird also "versucht" die Werte in die Variante zu speichern und die
      Grafik entsprechend zu aktualisieren. Tritt dabei eine Exception auf
      (z.B: EConvertError etc.), wird diese abgefangen und ignoriert. }
    try
      SaveData;
      frmMain.UpdateModelGraphics;
    except
    end;
  end;
end;

function TfraBasics.LoadData: boolean;
begin
  result := false;
  with CurrentModell.Variante do begin
    edProfilInnen.Text := ProfilInnen.Dateiname;
    edProfilAussen.Text := ProfilAussen.Dateiname;

    edFlaechenbelastung.Text := UICurrToStr(Flaechenbelastung);
    edSpannweite.Text := IntToStr(Spannweite);
    edWurzeltiefe.Text := UICurrToStr(Wurzeltiefe);
    edLageTrapezstoss.Text := UICurrToStr(LageTrapezstoss);
    edTiefeTrapezstoss.Text := UICurrToStr(TiefeTrapezstoss);
    edTiefeRandbogen.Text := UICurrToStr(TiefeRandbogen);
    edLeitwerkshebel.Text := UICurrToStr(Leitwerkshebel * 100);
    edStabilitaetsmass.Text := UICurrToStr(Stabilitatsmass);
    edSchwerpunkt.Text := UICurrToStr(Schwerpunkt);

    UpdateBerechneteDaten;
  end;
  UpdateLeitwerkshebelInfo;

  result := true;
end;

procedure TfraBasics.Button1Click(Sender: TObject);
var
  frmProfilChoose : TfrmProfilChoose;
begin
  frmProfilChoose := TfrmProfilChoose.Create(self);
  try
    frmProfilChoose.Profilname := edProfilInnen.Text;
    if frmProfilChoose.Execute then begin
      edProfilInnen.Text := frmProfilChoose.Profilname;
      SetAltered;
    end;
  finally
    FreeAndNil(frmProfilChoose);
    edProfilInnenExit(self);
  end;
end;

procedure TfraBasics.Button2Click(Sender: TObject);
var
  frmProfilChoose : TfrmProfilChoose;
begin
  frmProfilChoose := TfrmProfilChoose.Create(self);
  try
    frmProfilChoose.Profilname := edProfilAussen.Text;
    if frmProfilChoose.Execute then begin
      edProfilAussen.Text := frmProfilChoose.Profilname;
      SetAltered;
    end;
  finally
    FreeAndNil(frmProfilChoose);
    edProfilAussenExit(self);
  end;
end;

procedure TfraBasics.edProfilAussenEnter(Sender: TObject);
begin
  if  (edProfilAussen.Text = '')
  and (edProfilInnen.Text <> '') then
    edProfilAussen.Text := edProfilInnen.Text;
end;

procedure TfraBasics.WingLoadingCalcButtonClick(Sender: TObject);
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

procedure TfraBasics.edProfilInnenChange(Sender: TObject);
begin
  if not frmMain.IsUpdateing then begin
    SetAltered;
    UpdateLeitwerkshebelInfo;
  end;
end;

procedure TfraBasics.UpdateLeitwerkshebelInfo;
begin
  btnCalcLeitwerkshebel.Enabled:= ( edProfilInnen.Text <> '' ) and ( edProfilInnen.Text <> '0' ) and
                                  ( edProfilAussen.Text <> '' ) and ( edProfilAussen.Text <> '0' ) and
                                  ( edFlaechenbelastung.Text <> '' ) and ( edFlaechenbelastung.Text <> '0' ) and
                                  ( edSpannweite.Text <> '' ) and ( edSpannweite.Text <> '0' ) and
                                  ( edWurzeltiefe.Text <> '' ) and ( edWurzeltiefe.Text <> '0' ) and
                                  ( edTiefeTrapezstoss.Text <> '' ) and ( edTiefeTrapezstoss.Text <> '0' ) and
                                  ( edTiefeRandbogen.Text <> '' ) and ( edTiefeRandbogen.Text <> '0' ) and
                                  ( edStabilitaetsmass.Text <> '' ) and ( edStabilitaetsmass.Text <> '0' ) and
                                  ( edSchwerpunkt.Text <> '' ) and ( edSchwerpunkt.Text <> '0' );

  pnlLeitwerkshebelInfo.Visible:= not btnCalcLeitwerkshebel.Enabled;
end;

procedure TfraBasics.BitBtn1Click(Sender: TObject);
begin
  frmMain.ShowModelGraficWindow( true, false );
end;

procedure TfraBasics.btnCalcLeitwerkshebelClick(Sender: TObject);
begin
  if SaveData then begin
    try
      CurrentModell.Variante.Leitwerkshebel:= 0;
      CurrentModell.Variante.AuslegungBerechnen;
      edLeitwerkshebel.Text:= CurrToStr( CurrentModell.Variante.RH * 100 );
    except
    end;

  end;
end;

procedure TfraBasics.BitBtn2Click(Sender: TObject);
begin
  frmMain.fraFunctions.BitBtn1Click(Sender);
end;

end.
