unit report_holmberechnung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QRCtrls, QuickRpt, ExtCtrls, modell, varianten, RxGIF,
  Materialien;

type
  TqrpHolmberechnung = class(TForm)
    QuickRep1: TQuickRep;
    QRBand6: TQRBand;
    QRSysData1: TQRSysData;
    lblProg: TQRLabel;
    QRBand1: TQRBand;
    QRSysData2: TQRSysData;
    lblModelname: TQRLabel;
    qrModellName: TQRLabel;
    lblVersionname: TQRLabel;
    qrVariantenName: TQRLabel;
    lblSubtitle: TQRLabel;
    QRBand3: TQRBand;
    lblInfoCaption: TQRLabel;
    lblSpareCapMatCaption: TQRLabel;
    lblSparWebMatCaption: TQRLabel;
    lblCoreMatCaption: TQRLabel;
    lblGurtmaterial: TQRLabel;
    lblStegmaterial: TQRLabel;
    lblKernmaterial: TQRLabel;
    lblColHeaders: TQRLabel;
    QRGroup1: TQRGroup;
    lblColDistance: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    lblColDistanceUnit: TQRLabel;
    QRSubDetail1: TQRSubDetail;
    lblColWidth: TQRLabel;
    lblColBendingMoment: TQRLabel;
    lblColShearForce: TQRLabel;
    lblColAirfoilThickness: TQRLabel;
    lblColAirfoilThicknessReduced: TQRLabel;
    lblColDragMoment: TQRLabel;
    lblColAreaForShearForce: TQRLabel;
    lblColWebBetweenSparCab: TQRLabel;
    lblColSparCabHeight: TQRLabel;
    lblColCountRovings: TQRLabel;
    lblColShearWebThickness: TQRLabel;
    lblColShearLoad: TQRLabel;
    QRShape3: TQRShape;
    lblColWidthUnit: TQRLabel;
    lblColBendingMomentUnit: TQRLabel;
    lblColShearForceUnit: TQRLabel;
    lblColAirfoilThicknessUnit: TQRLabel;
    lblColAirfoilThicknessReducedUnit: TQRLabel;
    lblColDragMomentUnit: TQRLabel;
    lblColAreaForShearForceUnit: TQRLabel;
    lblColWebBetweenSparCabUnit: TQRLabel;
    lblColSparCabHeightUnit: TQRLabel;
    lblColCountRovingsUnit: TQRLabel;
    lblColShearWebThicknessUnit: TQRLabel;
    lblColShearLoadUnit: TQRLabel;
    imgCFK: TQRImage;
    lblGraphicCaption: TQRLabel;
    lblAbstand: TQRLabel;
    lblHolmbreite: TQRLabel;
    lblBiegemoment: TQRLabel;
    lblQuerkraft: TQRLabel;
    lblProfilhoehe: TQRLabel;
    lblProfilhoeheRed: TQRLabel;
    lblWiderstandsmoment: TQRLabel;
    lblQuerschnittsflaeche: TQRLabel;
    lblSteghoehe: TQRLabel;
    lblHoeheHolmgurt: TQRLabel;
    lblAnzahlRovings: TQRLabel;
    lblDickeStegwand: TQRLabel;
    lblSchubkraft: TQRLabel;
    lblColPointlist: TQRLabel;
    QRShape4: TQRShape;
    lblInfoText: TQRLabel;
    imgKiefer: TQRImage;
    lblDesignCaption: TQRLabel;
    lblMaxLiftCoefficientCaption: TQRLabel;
    lblMaxSpeedCaption: TQRLabel;
    lblV: TQRLabel;
    lblCa: TQRLabel;
    lblAuslegung: TQRLabel;
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QRSubDetail1NeedData(Sender: TObject; var MoreData: Boolean);
  private
    { Private declarations }
    FModellVariante: TModellVariante;
    FHolmIdx: integer;
    FHolmart: THolmart;
    FMaxCa: string;
    FAuslegung: string;
    FMaxV: string;
    FDemoCheck: boolean;
    procedure SetTexts();
  public
    { Public declarations }
    property ModellVariante: TModellVariante read FModellVariante write FModellVariante;
    property Holmart: THolmart read FHolmart write FHolmart;
    property Auslegung: string read FAuslegung write FAuslegung;
    property MaxCa: string read FMaxCa write FMaxCa;
    property MaxV: string read FMaxV write FMaxV;
  end;

var
  qrpHolmberechnung: TqrpHolmberechnung;

implementation

{$R *.dfm}

uses
  math, ad_consts, maindata, idTranslator;

procedure TqrpHolmberechnung.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  FHolmIdx:= 0 ;

  SetTexts();

  with ModellVariante do begin
    qrModellName.Caption := CurrentModell.ModellName;
    qrVariantenName.Caption := VariantenName;
    lblGurtmaterial.Caption:= self.Holmart.Gurtmaterial;
    lblStegmaterial.Caption:= self.Holmart.Stegmaterial;
    lblKernmaterial.Caption:= self.Holmart.Kernmaterial;

    { Holmskizzen }
    case self.Holmart.BerechnungsMethode of
      1: begin
          imgCFK.AutoSize:= true;
          imgKiefer.AutoSize:= false;
          imgKiefer.Width:= 0;
         end;
      2: begin
          imgKiefer.AutoSize:= true;
          imgCFK.AutoSize:= false;
          imgCFK.Width:= 0;

          lblColCountRovings.Caption:= '';
          lblColPointlist.Caption:= '';
          lblColCountRovingsUnit.Caption:= '';

          lblColSparCabHeight.Font.Style:= [fsBold];
          lblColSparCabHeightUnit.Font.Style:= [fsBold];
          lblHoeheHolmgurt.Font.Style:= [fsBold];

         end;
      else assert( false, 'Unknown Holmart.BerechungsMethode!' );
    end;

    lblAuslegung.Caption:= self.Auslegung;
    lblCa.Caption:= self.MaxCa;
    lblV.Caption:= self.MaxV;

  end;

end;

procedure TqrpHolmberechnung.QRSubDetail1NeedData(Sender: TObject;
  var MoreData: Boolean);
var
  holm: THolmItem;
begin
  MoreData:= FHolmIdx < ModellVariante.Holme.Count;

  if MoreData then begin

    holm:= ModellVariante.Holme.Items[ FHolmIdx ];

    lblAbstand.Caption:= Format( '%1.0f', [ holm.Abstand ] );
    lblHolmbreite.Caption:= Format( '%1.0f' , [ holm.Holmbreite ] );
    lblBiegemoment.Caption:= Format( '%1.0f', [ holm.Biegemoment ] );
    lblQuerkraft.Caption:= Format( '%1.3f', [ holm.Querkraft ] );
    lblProfilhoehe.Caption:= Format( '%1.1f', [ holm.Profilhoehe ] );
    lblProfilhoeheRed.Caption:= Format( '%1.1f', [ holm.ProfilhoeheReduziert ] );
    lblWiderstandsmoment.Caption:= Format( '%1.0f', [ holm.Widerstandsmoment ] );
    lblQuerschnittsflaeche.Caption:= Format( '%1.2f', [ holm.Querschnittsflaeche ] );
    lblSteghoehe.Caption:= Format( '%1.1f', [ holm.Steghoehe ] );
    lblHoeheHolmgurt.Caption:= Format( '%1.2f', [ holm.Holmgurthoehe ] );
    lblAnzahlRovings.Caption:= Format( '%1.0d', [ holm.AnzahlRovings ] );
    lblDickeStegwand.Caption:= Format( '%1.2f', [ holm.DickeStegwand ] );
    lblSchubkraft.Caption:= Format( '%1.0f', [ holm.Schubkraftbeanspruchung ] );

    if Holmart.BerechnungsMethode = 2 then begin
      lblAnzahlRovings.Caption:= '';
      QRShape4.Width:= 0;
    end;

    inc( FHolmIdx );

  end;

end;

procedure TqrpHolmberechnung.SetTexts;
begin
  // Report stuff
  QuickRep1.ReportTitle := dmMain.Translator.GetLit('ReportSpareTitle');
  lblSubtitle.Caption := dmMain.Translator.GetLit('ReportSpareSubtitle');
  lblModelname.Caption := dmMain.Translator.GetLit('ReportModelname');
  lblVersionname.Caption := dmMain.Translator.GetLit('ReportVersionname');
  lblProg.Caption:= Format( dmMain.Translator.GetLit('ReportProgramCaption'),
                            [ProgramName, ProgVersion] );

  // Info texts
  lblInfoCaption.Caption := dmMain.Translator.GetLit('ReportSpareInfoCaption');
  lblInfoText.Caption := dmMain.Translator.GetLit('ReportSpareInfoText');
  lblGraphicCaption.Caption := dmMain.Translator.GetLit('ReportSpareGraphicCaption');
  lblSpareCapMatCaption.Caption := dmMain.Translator.GetLit('ReportSpareCapMatCaption');
  lblSparWebMatCaption.Caption := dmMain.Translator.GetLit('ReportSpareWebMatCaption');
  lblCoreMatCaption.Caption := dmMain.Translator.GetLit('ReportSpareCoreMatCaption');
  lblDesignCaption.Caption := dmMain.Translator.GetLit('ReportSpareDesignCaption');
  lblMaxLiftCoefficientCaption.Caption := dmMain.Translator.GetLit('ReportSpareMaxLiftCoefficientCaption');
  lblMaxSpeedCaption.Caption := dmMain.Translator.GetLit('ReportSpareMaxSpeedCaption');

  // Column headers
  lblColHeaders.Caption := dmMain.Translator.GetLit('ReportSpareDimensionsCaption');

  lblColDistance.Caption := dmMain.Translator.GetLit('ReportSpareColDistance');
  lblColWidth.Caption := dmMain.Translator.GetLit('ReportSpareColWidth');
  lblColBendingMoment.Caption := dmMain.Translator.GetLit('ReportSpareColBendingMoment');
  lblColShearForce.Caption := dmMain.Translator.GetLit('ReportSpareColShearForce');
  lblColAirfoilThickness.Caption := dmMain.Translator.GetLit('ReportSpareColAirfoilThickness');
  lblColAirfoilThicknessReduced.Caption := dmMain.Translator.GetLit('ReportSpareColAirfoilThicknessReduced');
  lblColDragMoment.Caption := dmMain.Translator.GetLit('ReportSpareColDragMoment');
  lblColAreaForShearForce.Caption := dmMain.Translator.GetLit('ReportSpareColAreaForShearForce');
  lblColShearLoad.Caption := dmMain.Translator.GetLit('ReportSpareColShearLoad');
  lblColWebBetweenSparCab.Caption := dmMain.Translator.GetLit('ReportSpareColWebBetweenSparCab');
  lblColShearWebThickness.Caption := dmMain.Translator.GetLit('ReportSpareColShearWeb');
  lblColSparCabHeight.Caption := dmMain.Translator.GetLit('ReportSpareColSparCabHeight');
  lblColCountRovings.Caption := dmMain.Translator.GetLit('ReportSpareColCountRovings');
  lblColPointlist.Caption := dmMain.Translator.GetLit('ReportSpareColPointList');

  lblColDistanceUnit.Caption := dmMain.Translator.GetLit('ReportSpareColDistanceUnit');
  lblColWidthUnit.Caption := dmMain.Translator.GetLit('ReportSpareColWidthUnit');
  lblColBendingMomentUnit.Caption := dmMain.Translator.GetLit('ReportSpareColBendingMomentUnit');
  lblColShearForceUnit.Caption := dmMain.Translator.GetLit('ReportSpareColShearForceUnit');
  lblColAirfoilThicknessUnit.Caption := dmMain.Translator.GetLit('ReportSpareColAirfoilThicknessUnit');
  lblColAirfoilThicknessReducedUnit.Caption := dmMain.Translator.GetLit('ReportSpareColAirfoilThicknessReducedUnit');
  lblColDragMomentUnit.Caption := dmMain.Translator.GetLit('ReportSpareColDragMomentUnit');
  lblColAreaForShearForceUnit.Caption := dmMain.Translator.GetLit('ReportSpareColAreaForShearForceUnit');
  lblColShearLoadUnit.Caption := dmMain.Translator.GetLit('ReportSpareColShearLoadUnit');
  lblColWebBetweenSparCabUnit.Caption := dmMain.Translator.GetLit('ReportSpareColWebBetweenSparCabUnit');
  lblColShearWebThicknessUnit.Caption := dmMain.Translator.GetLit('ReportSpareColShearWebUnit');
  lblColSparCabHeightUnit.Caption := dmMain.Translator.GetLit('ReportSpareColSparCabHeightUnit');
  lblColCountRovingsUnit.Caption := dmMain.Translator.GetLit('ReportSpareColCountRovingsUnit');


end;

end.
