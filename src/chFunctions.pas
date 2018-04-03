unit chFunctions;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, idTitleBar, ComCtrls, Buttons, idTranslator;

type
  TfraFunctions = class(TFrame)
    Shape1: TShape;
    idTitleBar1: TidTitleBar;
    Label26: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Shape4: TShape;
    Panel1: TPanel;
    Shape2: TShape;
    idTitleBar2: TidTitleBar;
    Shape3: TShape;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    Shape5: TShape;
    Shape6: TShape;
    btnCalcND: TBitBtn;
    idTitleBar3: TidTitleBar;
    Label3: TLabel;
    Label4: TLabel;
    edFromCa: TEdit;
    edToCa: TEdit;
    Label6: TLabel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Panel4: TPanel;
    Shape7: TShape;
    Shape8: TShape;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    btnHolme: TBitBtn;
    idTitleBar4: TidTitleBar;
    edHolmMaxCA: TEdit;
    edHolmMaxV: TEdit;
    Label9: TLabel;
    cmbHolmart: TComboBox;
    Label10: TLabel;
    cmbSteckart: TComboBox;
    btnSteckung: TBitBtn;
    Bevel1: TBevel;
    Label11: TLabel;
    edAuslegung: TEdit;
    btnSelectAuslegung: TButton;
    btnExperten: TButton;
    Translator: TidTranslator;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnCalcNDClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure btnHolmeClick(Sender: TObject);
    procedure btnSteckungClick(Sender: TObject);
    procedure btnSelectAuslegungClick(Sender: TObject);
    procedure btnExpertenClick(Sender: TObject);
    procedure edFromCaChange(Sender: TObject);
    procedure TranslatorTranslate(Sender: TObject);
  private
    { Private declarations }
    FIsUpdateing: boolean;
    function ValidateHolme: boolean;
    function GetAuslegungstext(holmart: byte; cl: currency; speedMax: integer) : string;
    procedure FillHolmart();
    procedure FillSteckart();
    procedure FillAuslegungstext;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;

    function SaveData: boolean;
    function LoadData: boolean;
    procedure SetAltered;

  end;

implementation

uses
  modell, varianten, profile,
  report_modellauslegung, main, chBasics, chWingGeo, ad_utils,
  report_neutralpunkt, report_variantenvergleich, report_gleitsinkpolare,
  report_holmberechnung, materialien, report_steckung, selectAuslegung,
  enterAuslegung, maindata;

{$R *.dfm}

type
  GliderDefinition = record
    Description: string;
    Cl: currency;
    MaxSpeed: integer;
  end;

var
  GliderDefinitions: array[0..1, 0..4] of GliderDefinition;

procedure FillGliderDefinitions();
begin
  { GFK / CFK }

  with GliderDefinitions[0, 0] do begin
    Description := dmMain.Translator.GetLit('GliderAllround');
    Cl := 0.8;
    MaxSpeed := 30;
  end;

  with GliderDefinitions[0, 1] do begin
    Description := dmMain.Translator.GetLit('GliderLarge');
    Cl := 0.8;
    MaxSpeed := 40;
  end;

  with GliderDefinitions[0, 2] do begin
    Description := dmMain.Translator.GetLit('GliderSpeed');
    Cl := 0.8;
    MaxSpeed := 50;
  end;

  with GliderDefinitions[0, 3] do begin
    Description := dmMain.Translator.GetLit('GliderCustom');
    Cl := 0.8;
    MaxSpeed := 60;
  end;

  { Kiefer }

  with GliderDefinitions[1, 0] do begin
    Description := dmMain.Translator.GetLit('GliderThermal');
    Cl := 0.8;
    MaxSpeed := 15;
  end;

  with GliderDefinitions[1, 1] do begin
    Description := dmMain.Translator.GetLit('GliderAllround');
    Cl := 0.8;
    MaxSpeed := 20;
  end;

  with GliderDefinitions[1, 2] do begin
    Description := dmMain.Translator.GetLit('GliderLarge');
    Cl := 0.8;
    MaxSpeed := 30;
  end;

  with GliderDefinitions[1, 3] do begin
    Description := '';
    Cl := 0;
    MaxSpeed := 0;
  end;

end;
  
constructor TfraFunctions.Create(AOwner: TComponent);
begin
  inherited;

  FillGliderDefinitions();

  FIsUpdateing:= true;
  try

    { Code needed becaus of language spezific decimal format }

    edFromCa.Text:= FloatToStr( 0.4 );
    edToCa.Text:= FloatToStr( 0.8 );

    FillHolmart();
    FillSteckart();

  finally
    FIsUpdateing:= false;
  end;

end;

procedure TfraFunctions.FillHolmart();
var
  i: integer;
  oldItemIndex : integer;
begin
  oldItemIndex := cmbHolmart.ItemIndex;
  cmbHolmart.Clear;
  for i:= Low( Holmarten ) to High( Holmarten ) do begin
    cmbHolmart.AddItem( Holmarten[i].Bezeichnung, nil );
  end;
  cmbHolmart.ItemIndex:= oldItemIndex;
end;

procedure TfraFunctions.FillSteckart();
var
  oldItemIndex: integer;
begin
  oldItemIndex := cmbSteckart.ItemIndex;
  cmbSteckart.Items.Text := dmMain.Translator.GetLit('JoinerTypes');
  cmbSteckart.ItemIndex:= oldItemIndex;
end;

procedure TfraFunctions.FillAuslegungstext();
begin
  if (CurrentModell.Variante <> nil) then begin
    with CurrentModell.Variante do begin
      edAuslegung.Text:= GetAuslegungstext(Holmart, MaxCa, MaxV);
    end;
  end;
end;

procedure TfraFunctions.BitBtn1Click(Sender: TObject);
var
  qrpModellauslegung: TqrpModellauslegung;
begin
  with frmMain.fraBasics do begin

    if frmMain.fraBasics.Validate then begin
      SaveData;
      CurrentModell.Variante.AuslegungBerechnen;
      UpdateBerechneteDaten;

      qrpModellauslegung := TqrpModellauslegung.Create(self);
      try
        qrpModellauslegung.ModellVariante := CurrentModell.Variante;
        { Modaler Preview aus welchem auch gedruckt werden kann }
        qrpModellauslegung.QuickRep1.PreviewModal;
      finally
        FreeAndNil(qrpModellauslegung);
      end;

    end;

  end;
end;

procedure TfraFunctions.BitBtn2Click(Sender: TObject);
var
  qrpVar: TqrpVariantenVergleich;
begin
  with frmMain.fraBasics do begin

    if Validate then begin
      SaveData;
      CurrentModell.Varianten.CalcLeistungsdaten;
      UpdateBerechneteDaten;

      qrpVar := TqrpVariantenVergleich.Create(self);
      try
        qrpVar.Modell:= CurrentModell;
        { Modaler Preview aus welchem auch gedruckt werden kann }
        qrpVar.QuickRep1.PreviewModal;
      finally
        FreeAndNil(qrpVar);
      end;
    end;

  end;
end;

procedure TfraFunctions.btnCalcNDClick(Sender: TObject);
var
  qrpReport: TqrpNeutralpunkt;
  fromCa,
  toCa : currency;
begin
  with frmMain.fraWingGeo do begin

    if (frmMain.fraBasics.Validate)
      and (frmMain.fraWingGeo.Validate)
    then begin
      SaveData;

      fromCa:= UIStringToCurrDef(edFromCa.Text, -1);
      toCa:= UIStringToCurrDef(edToCa.Text, -1);

      if fromCa < 0 then begin
        dmMain.ShowValidationError(Format(dmMain.Translator.GetLit('ValidationInvalidFromCl'), [DecimalSeparator]));
        exit;
      end;
      if toCa < 0 then begin
        dmMain.ShowValidationError(Format(dmMain.Translator.GetLit('ValidationInvalidToCl'), [DecimalSeparator]));
        exit;
      end;

      Screen.Cursor:= crHourglass;
      try
        CurrentModell.Variante.NeutralpunktBerechnung(fromCa, toCa);
      finally
        Screen.Cursor:= crDefault;
      end;

      qrpReport := TqrpNeutralpunkt.Create(self);
      try
        qrpReport.ModellVariante := CurrentModell.Variante;
        { Modaler Preview aus welchem auch gedruckt werden kann }
        qrpReport.PreviewModal;
      finally
        FreeAndNil(qrpReport);
      end;
    end;

  end;

end;

procedure TfraFunctions.BitBtn3Click(Sender: TObject);
var
  qrpGleitSinkpolare: TqrpGleitSinkpolare;
begin
  with frmMain.fraBasics do begin

    if frmMain.fraBasics.Validate then begin
      SaveData;
      CurrentModell.Variante.AuslegungBerechnen;
      UpdateBerechneteDaten;

      try
        qrpGleitSinkpolare := TqrpGleitSinkpolare.Create(nil);
        try
            qrpGleitSinkpolare.ModellVariante := CurrentModell.Variante;
            qrpGleitSinkpolare.QuickRep1.PreviewModal;
        finally
          FreeAndNil(qrpGleitSinkpolare);
        end;
      except
      end;

    end;

  end;
end;

procedure TfraFunctions.BitBtn4Click(Sender: TObject);
var
  qrpGleitSinkpolare: TqrpGleitSinkpolare;
begin
  with frmMain.fraBasics do begin

    if frmMain.fraBasics.Validate then begin
      SaveData;
      CurrentModell.Variante.AuslegungBerechnen;
      UpdateBerechneteDaten;

      try
        qrpGleitSinkpolare := TqrpGleitSinkpolare.Create(nil);
        try
            qrpGleitSinkpolare.ModellVariante := CurrentModell.Variante;
            qrpGleitSinkpolare.QuickRep1.Print;
        finally
          FreeAndNil(qrpGleitSinkpolare);
        end;
      except
      end;

    end;

  end;
end;

function TfraFunctions.ValidateHolme: boolean;
var
  fromCa,
  toCa,
  maxCa,
  maxV : currency;
begin
  result:= false;

  if (frmMain.fraBasics.Validate)
    //and (frmMain.fraWingGeo.Validate)
  then begin
    frmMain.fraBasics.SaveData;
    frmMain.fraWingGeo.SaveData;

//    if Holmarten[cmbHolmart.ItemIndex].BerechnungsMethode = 2 then begin
//      Application.MessageBox( PChar('Die Berechnungsmethode für ' + Holmarten[cmbHolmart.ItemIndex].Bezeichnung + ' Holme ist noch nicht integriert.'),
//                              'Berechnung nicht möglich',
//                              mb_IconStop + mb_Ok );
//      exit;
//    end;

    fromCa:= StrToCurrDef(edFromCa.Text, -1);
    toCa:= StrToCurrDef(edToCa.Text, -1);
    if fromCa < 0 then begin
      dmMain.ShowValidationError(Format(dmMain.Translator.GetLit('ValidationInvalidFromCl'), [DecimalSeparator]));
      edFromCa.SetFocus;
      exit;
    end;
    if toCa < 0 then begin
      dmMain.ShowValidationError(Format(dmMain.Translator.GetLit('ValidationInvalidToCl'), [DecimalSeparator]));
      edToCa.SetFocus;
      exit;
    end;

    maxCa:= StrToCurrDef( edHolmMaxCA.Text, -1 );
    maxV:= StrToCurrDef( edHolmMaxV.Text, -1 );
    if maxCa < 0 then begin
      dmMain.ShowValidationError(dmMain.Translator.GetLit('ValidationInvalidMaxLift'));
      edHolmMaxCA.SetFocus;
      exit;
    end;
    if maxV < 0 then begin
      dmMain.ShowValidationError(dmMain.Translator.GetLit('ValidationInvalidMaxSpeed'));
      edHolmMaxV.SetFocus;
      exit;
    end;

    { Holmbreite an der Wurzel }
    if CurrentModell.Variante.HolmbreiteWurzel <= 0 then begin
      frmMain.SetPage( pagWingGeo );
      frmMain.fraWingGeo.PageControl.ActivePage:= frmMain.fraWingGeo.tsTragflaeche;
      frmMain.fraWingGeo.edHolmbreiteWurzel.SetFocus;
      dmMain.ShowValidationError(dmMain.Translator.GetLit('ValidationInvalidSpareWidthWingRoot'));
      exit;
    end;

    { Holmbreite am Randbogen }
    if CurrentModell.Variante.HolmbreiteRandbogen <= 0 then begin
      frmMain.SetPage( pagWingGeo );
      frmMain.fraWingGeo.PageControl.ActivePage:= frmMain.fraWingGeo.tsTragflaeche;
      frmMain.fraWingGeo.edHolmbreiteWurzel.SetFocus;
      dmMain.ShowValidationError(dmMain.Translator.GetLit('ValidationInvalidSpareWidthWingTip'));
      exit;
    end;

//    { Holmbreite am Randbogen }
//    if CurrentModell.Variante.HolmbreiteRandbogen <= 0 then begin
//      frmMain.SetPage( pagWingGeo );
//      frmMain.fraWingGeo.PageControl.ActivePage:= tsTragflaeche;
//      frmMain.fraWingGeo.edHolmbreiteWurzel.SetFocus;
//      Application.MessageBox( 'Holmbreite am Randbogen muss grösser als Null sein!',
//                              'Eingabefehler',
//                              mb_IconStop + mb_Ok );
//      exit;
//    end;
//
//    CurrentModell.Variante.ProfildickeWurzel
//    CurrentModell.Variante.ProfildickeRandbogen

    result:= true;
  end;
end;

procedure TfraFunctions.btnHolmeClick(Sender: TObject);
var
  qrpHolme: TqrpHolmberechnung;
  fromCa,
  toCa,
  maxCa,
  maxV : currency;
begin

  if ValidateHolme then begin

    fromCa:= UIStringToCurrDef(edFromCa.Text, -1);
    toCa:= UIStringToCurrDef(edToCa.Text, -1);
    maxCa:= UIStringToCurrDef( edHolmMaxCA.Text, -1 );
    maxV:= UIStringToCurrDef( edHolmMaxV.Text, -1 );

    try
      CurrentModell.Variante.AuslegungBerechnen;
      CurrentModell.Variante.NeutralpunktBerechnung( fromCa, toCa );
      CurrentModell.Variante.Holmberechnung( maxCa, maxV, Holmarten[cmbHolmart.ItemIndex], adsNone );
    except
      on e: exception do begin
        Application.Messagebox(PChar(Format(dmMain.Translator.GetLit('ErrorDuringSparCalcText'), [ e.Message ])),
                               PChar(dmMain.Translator.GetLit('ErrorDuringCalculationCaption')),
                               mb_IconStop + mb_Ok );
        exit;
      end;
    end;

    qrpHolme:= TqrpHolmberechnung.Create( nil );
    try
      qrpHolme.ModellVariante:= CurrentModell.Variante;
      qrpHolme.Holmart:= Holmarten[cmbHolmart.ItemIndex];
      qrpHolme.Auslegung:= edAuslegung.Text;
      qrpHolme.MaxCa:= edHolmMaxCA.Text;
      qrpHolme.MaxV:= edHolmMaxV.Text;
      qrpHolme.QuickRep1.PreviewModal();
    finally
      FreeAndNil( qrpHolme );
    end;

  end;

end;

procedure TfraFunctions.btnSteckungClick(Sender: TObject);
var
  qrpSteckung: TqrpSteckung;
  fromCa,
  toCa,
  maxCa,
  maxV : currency;
  steckungsart: TArtDerSteckung;
begin

  if ValidateHolme then begin

    fromCa:= UIStringToCurrDef(edFromCa.Text, -1);
    toCa:= UIStringToCurrDef(edToCa.Text, -1);
    maxCa:= UIStringToCurrDef( edHolmMaxCA.Text, -1 );
    maxV:= UIStringToCurrDef( edHolmMaxV.Text, -1 );

    case cmbSteckart.ItemIndex of
      0: steckungsart:= adsRechteckigerQueryschnitt;
      1: steckungsart:= adsRunderQuerschnitt;
      else assert( false, 'Unbekannte Steckungsart!' );
    end;

    try
      CurrentModell.Variante.AuslegungBerechnen;
      CurrentModell.Variante.NeutralpunktBerechnung( fromCa, toCa );
      CurrentModell.Variante.Holmberechnung( maxCa, maxV, Holmarten[cmbHolmart.ItemIndex], steckungsart );
    except
      on e: exception do begin
        Application.Messagebox(PChar(Format(dmMain.Translator.GetLit('ErrorDuringSparCalcText'), [ e.Message ])),
                               PChar(dmMain.Translator.GetLit('ErrorDuringCalculationCaption')),
                               mb_IconStop + mb_Ok );
        exit;
      end;
    end;

    qrpSteckung:= TqrpSteckung.Create( nil );
    try
      qrpSteckung.ModellVariante:= CurrentModell.Variante;
      qrpSteckung.Holmart:= Holmarten[cmbHolmart.ItemIndex];
      qrpSteckung.DruckeRundeSteckungen:= steckungsart = adsRunderQuerschnitt;
      qrpSteckung.QuickRep1.PreviewModal();
    finally
      FreeAndNil( qrpSteckung );
    end;

  end;

end;

procedure TfraFunctions.btnSelectAuslegungClick(Sender: TObject);
var
  frmSelectAuslegung: TfrmSelectAuslegung;

  procedure AddAuslegungsItem( ACaption, ACA, AV: string );
  begin
    with frmSelectAuslegung.lvAuslegung.Items.Add do begin
      Caption:= ACaption;
      SubItems.Add( ACA );
      SubItems.Add( AV );
    end;
  end;

begin
  frmSelectAuslegung:= TfrmSelectAuslegung.Create( nil );
  try

    { Verfügbare Auslegungen in Auswahl abfüllen }
    with frmSelectAuslegung do begin
      lvAuslegung.Items.BeginUpdate;
      try
        if cmbHolmart.ItemIndex = 0 then begin
          { GFK / CFK }
          AddAuslegungsItem( GliderDefinitions[0, 0].Description, CurrToStr( GliderDefinitions[0, 0].Cl ), CurrToStr( GliderDefinitions[0, 0].MaxSpeed ) );
          AddAuslegungsItem( GliderDefinitions[0, 1].Description, CurrToStr( GliderDefinitions[0, 1].Cl ), CurrToStr( GliderDefinitions[0, 1].MaxSpeed ) );
          AddAuslegungsItem( GliderDefinitions[0, 2].Description, CurrToStr( GliderDefinitions[0, 2].Cl ), CurrToStr( GliderDefinitions[0, 2].MaxSpeed ) );
          AddAuslegungsItem( GliderDefinitions[0, 3].Description, CurrToStr( GliderDefinitions[0, 3].Cl ), CurrToStr( GliderDefinitions[0, 3].MaxSpeed ) );
        end else begin
          { Kiefer }
          AddAuslegungsItem( GliderDefinitions[1, 0].Description, CurrToStr( GliderDefinitions[1, 0].Cl ), CurrToStr( GliderDefinitions[1, 0].MaxSpeed ) );
          AddAuslegungsItem( GliderDefinitions[1, 1].Description, CurrToStr( GliderDefinitions[1, 1].Cl ), CurrToStr( GliderDefinitions[1, 1].MaxSpeed ) );
          AddAuslegungsItem( GliderDefinitions[1, 2].Description, CurrToStr( GliderDefinitions[1, 2].Cl ), CurrToStr( GliderDefinitions[1, 2].MaxSpeed ) );
        end;
      finally
        lvAuslegung.Items.EndUpdate;
      end;
    end;

    if frmSelectAuslegung.ShowModal = idOk then begin
      if assigned( frmSelectAuslegung.lvAuslegung.Selected ) then begin
        edAuslegung.Text:= frmSelectAuslegung.lvAuslegung.Selected.Caption;
        edHolmMaxCA.Text:= frmSelectAuslegung.lvAuslegung.Selected.SubItems[0];
        edHolmMaxV.Text:= frmSelectAuslegung.lvAuslegung.Selected.SubItems[1];
      end;
    end;

  finally
    FreeAndNil( frmSelectAuslegung );
  end;
end;

function TfraFunctions.GetAuslegungstext(holmart: byte; cl: currency; speedMax: integer) : string;
var
  auslegungIdx: byte;
  i: integer;
begin
  for i := 0 to 4 do begin
    if ((GliderDefinitions[holmart, i].Cl = cl) and
        (GliderDefinitions[holmart, i].MaxSpeed = speedMax)) then
    begin
      result := GliderDefinitions[holmart, i].Description;
      break;
    end;
  end;

  result := dmMain.Translator.GetLit('GliderCustom');
end;

procedure TfraFunctions.btnExpertenClick(Sender: TObject);
var
  frmEnterAuslegung: TfrmEnterAuslegung;
begin
  frmEnterAuslegung:= TfrmEnterAuslegung.Create(self);
  try
    frmEnterAuslegung.edCa.Text:= edHolmMaxCA.Text;
    frmEnterAuslegung.edV.Text:= edHolmMaxV.Text;
    if frmEnterAuslegung.ShowModal = idOk then begin
      edAuslegung.Text:= dmMain.Translator.GetLit('CustomDimensioning');
      edHolmMaxCA.Text:= frmEnterAuslegung.edCa.Text;
      edHolmMaxV.Text:= frmEnterAuslegung.edV.Text;
    end;
  finally
    FreeAndNil(frmEnterAuslegung);
  end;
end;

function TfraFunctions.LoadData: boolean;
begin
  with CurrentModell.Variante do begin
    edFromCa.Text:= UICurrToStr( NpVonCa );
    edToCa.Text:= UICurrToStr( NpBisCa );
    cmbHolmart.ItemIndex:= Holmart;
    cmbSteckart.ItemIndex:= ArtSteckverbindung;
    FillAuslegungstext();
    edHolmMaxCA.Text:= UICurrToStr( MaxCa );
    edHolmMaxV.Text:= UICurrToStr( MaxV );
  end;
  result := true;

end;

function TfraFunctions.SaveData: boolean;
begin
  with CurrentModell.Variante do begin
    NpVonCa:= UIStringToCurrDef( edFromCa.Text, 0.2 );
    NpBisCa:= UIStringToCurrDef( edToCa.Text, 0.9 );
    Holmart:= cmbHolmart.ItemIndex;
    MaxCa:= UIStringToCurrDef( edHolmMaxCA.Text, 1 );
    MaxV:= StrToIntDef( edHolmMaxV.Text, 40 );
    ArtSteckverbindung:= cmbSteckart.ItemIndex;
  end;
  result := true;
end;

procedure TfraFunctions.SetAltered;
begin
  if (not frmMain.IsUpdateing)
    and (not FIsUpdateing) then
  begin
    frmMain.Altered := true;
  end;
end;

procedure TfraFunctions.edFromCaChange(Sender: TObject);
begin
  SetAltered;
end;

procedure TfraFunctions.TranslatorTranslate(Sender: TObject);
begin
  LoadSparTexts();
  FillGliderDefinitions();
  FillHolmart();
  FillSteckart();
  FillAuslegungstext();
end;

end.
