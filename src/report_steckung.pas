unit report_steckung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuickRpt, QRCtrls, ExtCtrls, modell, varianten, Materialien;

type
  TqrpSteckung = class(TForm)
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
    lblHeading1: TQRLabel;
    lblHeading2: TQRLabel;
    lblText1: TQRLabel;
    lblColDistanceFromMidFuse: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    lblColDistanceFromMidFuseUnit: TQRLabel;
    lblColSparWidth: TQRLabel;
    lblColJoinerWidth: TQRLabel;
    QRShape3: TQRShape;
    lblColSparWidthUnit: TQRLabel;
    lblColJoinerWidthUnit: TQRLabel;
    QRSubDetail1: TQRSubDetail;
    lblHeadingCFK: TQRLabel;
    QRShape5: TQRShape;
    lblColMaxJoinerWidth: TQRLabel;
    lblColMaxJoinerWidthUnit: TQRLabel;
    lblColMaxJoinerHeight: TQRLabel;
    lblColMaxJoinerHeightUnit: TQRLabel;
    lblHeadingGFK: TQRLabel;
    lblCalcMinJoinerWidth: TQRLabel;
    lblColGFKMaxJoinerWidth: TQRLabel;
    lblColGFKMaxJoinerHeight: TQRLabel;
    lblCalcMinJoinerWidthUnit: TQRLabel;
    lblColGFKMaxJoinerWidthUnit: TQRLabel;
    lblColGFKMaxJoinerHeightUnit: TQRLabel;
    QRShape6: TQRShape;
    lblHeadingSteel: TQRLabel;
    lblColSteelCalcJoinerWidth: TQRLabel;
    lblColSteelMaxJoinerWidth: TQRLabel;
    lblColSteelMaxJoinerHeight: TQRLabel;
    lblColSteelCalcJoinerWidthUnit: TQRLabel;
    lblColSteelMaxJoinerWidthUnit: TQRLabel;
    lblColSteelMaxJoinerHeightUnit: TQRLabel;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRShape9: TQRShape;
    QRShape10: TQRShape;
    lblAbstand: TQRLabel;
    lblHolmbreite: TQRLabel;
    lblCFKMin: TQRLabel;
    lblCFKMax: TQRLabel;
    lblCFKHoehe: TQRLabel;
    lblGFKMin: TQRLabel;
    lblGFKMax: TQRLabel;
    lblGFKHoehe: TQRLabel;
    lblStahlMin: TQRLabel;
    lblStahlMax: TQRLabel;
    lblStahlHoehe: TQRLabel;
    ColumnHeaderBand2: TQRBand;
    lblText2: TQRLabel;
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QRSubDetail1NeedData(Sender: TObject; var MoreData: Boolean);
  private
    { Private declarations }
    FModellVariante: TModellVariante;
    FHolmIdx: integer;
    FHolmart: THolmart;
    FDruckeRundeSteckungen: boolean;
    procedure SetTexts();
  public
    { Public declarations }
    property ModellVariante: TModellVariante read FModellVariante write FModellVariante;
    property Holmart: THolmart read FHolmart write FHolmart;
    property DruckeRundeSteckungen: boolean read FDruckeRundeSteckungen write FDruckeRundeSteckungen;
  end;

var
  qrpSteckung: TqrpSteckung;

implementation

uses
  math, ad_consts, maindata, idTranslator;

{$R *.dfm}

procedure TqrpSteckung.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  SetTexts();

  FHolmIdx:= 0 ;

  with ModellVariante do begin
    qrModellName.Caption := CurrentModell.ModellName;
    qrVariantenName.Caption := VariantenName;
  end;

end;

procedure TqrpSteckung.QRSubDetail1NeedData(Sender: TObject;
  var MoreData: Boolean);
var
  holm: THolmItem;
begin
  MoreData:= FHolmIdx < ModellVariante.Holme.Count;

  if MoreData then begin

    holm:= ModellVariante.Holme.Items[ FHolmIdx ];

    lblAbstand.Caption:= Format( '%1.0f', [ holm.Abstand ] );
    lblHolmbreite.Caption:= Format( '%1.0f' , [ holm.Holmbreite ] );

    lblCFKMin.Caption:= Format( '%1.1f', [ holm.CFK_Mindeststabbreite ] );
    lblCFKMax.Caption:= Format( '%1.0f', [ holm.CFK_MaximaleStabbreite ] );
    lblCFKHoehe.Caption:= Format( '%1.1f', [ holm.CFK_Stabhoehe ] );

    lblGFKMin.Caption:= Format( '%1.1f', [ holm.GFK_Mindeststabbreite ] );
    lblGFKMax.Caption:= Format( '%1.0f', [ holm.GFK_MaximaleStabbreite ] );
    lblGFKHoehe.Caption:= Format( '%1.1f', [ holm.GFK_Stabhoehe ] );

    lblStahlMin.Caption:= Format( '%1.1f', [ holm.Stahl_Mindeststabbreite ] );
    lblStahlMax.Caption:= Format( '%1.0f', [ holm.Stahl_MaximaleStabbreite ] );
    lblStahlHoehe.Caption:= Format( '%1.1f', [ holm.Stahl_Stabhoehe ] );

    if DruckeRundeSteckungen then begin
      lblCFKHoehe.Caption:= '';
      lblGFKHoehe.Caption:= '';
      lblStahlHoehe.Caption:= '';
    end;

//    property CFK_Mindeststabbreite: currency read FCFK_Mindeststabbreite write FCFK_Mindeststabbreite; // Berechnete Mindeststabbreite in mm
//    property CFK_MaximaleStabbreite: currency read FCFK_MaximaleStabbreite write FCFK_MaximaleStabbreite; // maximal mögliche Stabbreite aufgrund der gewählten Holmstegbreite in mm
//    property CFK_Stabhoehe: currency read FCFK_Stabhoehe write FCFK_Stabhoehe; // Stabhöhe in der Rechnung in mm
//    { GFK }
//    property GFK_Mindeststabbreite: currency read FGFK_Mindeststabbreite write FGFK_Mindeststabbreite; // Berechnete Mindeststabbreite in mm
//    property GFK_MaximaleStabbreite: currency read FGFK_MaximaleStabbreite write FGFK_MaximaleStabbreite; // maximal mögliche Stabbreite aufgrund der gewählten Holmstegbreite in mm
//    property GFK_Stabhoehe: currency read FGFK_Stabhoehe write FGFK_Stabhoehe; // Stabhöhe in der Rechnung in mm
//    { Stahl }
//    property Stahl_Mindeststabbreite: currency read FStahl_Mindeststabbreite write FStahl_Mindeststabbreite; // Berechnete Mindeststabbreite in mm
//    property Stahl_MaximaleStabbreite: currency read FStahl_MaximaleStabbreite write FStahl_MaximaleStabbreite; // maximal mögliche Stabbreite aufgrund der gewählten Holmstegbreite in mm
//    property Stahl_Stabhoehe: currency read FStahl_Stabhoehe write FStahl_Stabhoehe; // Stabhöhe in der Rechnung in mm

    inc( FHolmIdx );

  end;
end;

procedure TqrpSteckung.SetTexts;
begin

  QuickRep1.ReportTitle := dmMain.Translator.GetLit('ReportJoinerReportTitle');
  lblProg.Caption:= Format( dmMain.Translator.GetLit('ReportProgramCaption'),
                            [ProgramName, ProgVersion] );
  lblSubtitle.Caption := dmMain.Translator.GetLit('ReportJoinerSubtitle');
  lblModelname.Caption := dmMain.Translator.GetLit('ReportModelname');
  lblVersionname.Caption := dmMain.Translator.GetLit('ReportVersionname');
  lblHeading1.Caption := dmMain.Translator.GetLit('ReportJoinerHeading1');
  lblText1.Caption := dmMain.Translator.GetLit('ReportJoinerText1');
  lblText2.Caption := dmMain.Translator.GetLit('ReportJoinerText2');
  lblHeading2.Caption := dmMain.Translator.GetLit('ReportJoinerHeading2');

  lblColDistanceFromMidFuse.Caption := dmMain.Translator.GetLit('ReportJoinerColDistanceFromMidFuse');
  lblColDistanceFromMidFuseUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColDistanceFromMidFuseUnit');
  lblColSparWidth.Caption := dmMain.Translator.GetLit('ReportJoinerColSparWidth');
  lblColSparWidthUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColSparWidthUnit');
  lblColJoinerWidth.Caption := dmMain.Translator.GetLit('ReportJoinerColJoinerWidth');
  lblColJoinerWidthUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColJoinerWidthUnit');
  lblColMaxJoinerWidth.Caption := dmMain.Translator.GetLit('ReportJoinerColMaxJoinerWidth');
  lblColMaxJoinerWidthUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColMaxJoinerWidthUnit');
  lblColMaxJoinerHeight.Caption := dmMain.Translator.GetLit('ReportJoinerColMaxJoinerHeight');
  lblColMaxJoinerHeightUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColMaxJoinerHeightUnit');
  lblCalcMinJoinerWidth.Caption := dmMain.Translator.GetLit('ReportJoinerCalcMinJoinerWidth');
  lblCalcMinJoinerWidthUnit.Caption := dmMain.Translator.GetLit('ReportJoinerCalcMinJoinerWidthUnit');
  lblColGFKMaxJoinerWidth.Caption := dmMain.Translator.GetLit('ReportJoinerColGFKMaxJoinerWidth');
  lblColGFKMaxJoinerWidthUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColGFKMaxJoinerWidthUnit');
  lblColGFKMaxJoinerHeight.Caption := dmMain.Translator.GetLit('ReportJoinerColGFKMaxJoinerHeight');
  lblColGFKMaxJoinerHeightUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColGFKMaxJoinerHeightUnit');
  lblColSteelCalcJoinerWidth.Caption := dmMain.Translator.GetLit('ReportJoinerColSteelCalcJoinerWidth');
  lblColSteelCalcJoinerWidthUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColSteelCalcJoinerWidthUnit');
  lblColSteelMaxJoinerWidth.Caption := dmMain.Translator.GetLit('ReportJoinerColSteelMaxJoinerWidth');
  lblColSteelMaxJoinerWidthUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColSteelMaxJoinerWidthUnit');
  lblColSteelMaxJoinerHeight.Caption := dmMain.Translator.GetLit('ReportJoinerColSteelMaxJoinerHeight');
  lblColSteelMaxJoinerHeightUnit.Caption := dmMain.Translator.GetLit('ReportJoinerColSteelMaxJoinerHeightUnit');
  lblHeadingCFK.Caption := dmMain.Translator.GetLit('ReportJoinerHeadingCFK');
  lblHeadingGFK.Caption := dmMain.Translator.GetLit('ReportJoinerHeadingGFK');
  lblHeadingSteel.Caption := dmMain.Translator.GetLit('ReportJoinerHeadingSteel');

  if DruckeRundeSteckungen then begin

    lblColJoinerWidthUnit.Caption:= '';
    lblCalcMinJoinerWidthUnit.Caption:= '';
    lblColSteelMaxJoinerHeight.Caption:= '';
    lblColMaxJoinerHeightUnit.Caption:= '';
    lblColGFKMaxJoinerHeightUnit.Caption:= '';
    lblColSteelMaxJoinerHeightUnit.Caption:= '';

    lblColJoinerWidth.Caption:= dmMain.Translator.GetLit('ReportJoinerCalcMinDiameter');
    lblCalcMinJoinerWidth.Caption:= dmMain.Translator.GetLit('ReportJoinerCalcMinDiameter');
    lblColSteelCalcJoinerWidth.Caption:= dmMain.Translator.GetLit('ReportJoinerCalcMinDiameter');

    lblColMaxJoinerWidth.Caption:= dmMain.Translator.GetLit('ReportJoinerCalcMaxDiameter');
    lblColGFKMaxJoinerWidth.Caption:= dmMain.Translator.GetLit('ReportJoinerCalcMaxDiameter');
    lblColSteelMaxJoinerWidth.Caption:= dmMain.Translator.GetLit('ReportJoinerCalcMaxDiameter');

  end;

end;

end.
