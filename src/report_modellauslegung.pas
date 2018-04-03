unit report_modellauslegung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QRCtrls, QuickRpt, ExtCtrls, modell, varianten;

type
  TqrpModellauslegung = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    QRSysData1: TQRSysData;
    QRSysData2: TQRSysData;
    lblModelName: TQRLabel;
    qrModellName: TQRLabel;
    lblVersionname: TQRLabel;
    qrVariantenName: TQRLabel;
    QRBand3: TQRBand;
    lblAirfoilRoot: TQRLabel;
    qrProfilInnen: TQRLabel;
    qrProfilInnenDaten: TQRLabel;
    lblAirfoilTip: TQRLabel;
    qrProfilAussen: TQRLabel;
    qrProfilAussenDaten: TQRLabel;
    lblWeight: TQRLabel;
    QRShape1: TQRShape;
    lblWingLoading: TQRLabel;
    lblWingSpan: TQRLabel;
    lblWingRootChord: TQRLabel;
    lblWingCenterlineChord: TQRLabel;
    lblDistanceFromPanelLine: TQRLabel;
    lblWingTipChord: TQRLabel;
    lblWingSurface: TQRLabel;
    lblEffectiveTaper: TQRLabel;
    lblAspectRatio: TQRLabel;
    lblMeanChord: TQRLabel;
    lblMeanGeometricChord: TQRLabel;
    lblDistanceMeanGeoChordFromCenterLine: TQRLabel;
    lblFAIWingLoadWIthTail: TQRLabel;
    lblModelNeutralPoint: TQRLabel;
    lblCenterGravityCl: TQRLabel;
    lblDistanceToNeutralPoint: TQRLabel;
    lblStabilityMargin: TQRLabel;
    lblStabLeverArm: TQRLabel;
    lblElevatorSurface: TQRLabel;
    lblRelativeSizeElevatorWing: TQRLabel;
    lblElevatorAspectRatio: TQRLabel;
    lblElevatorSpan: TQRLabel;
    lblElevatorMeanChord: TQRLabel;
    lblVerticalTailSurface: TQRLabel;
    lblCm0AtMeanGeometricChord: TQRLabel;
    qr1: TQRLabel;
    qr2: TQRLabel;
    qr3: TQRLabel;
    qr4: TQRLabel;
    qr5: TQRLabel;
    qr6: TQRLabel;
    qr7: TQRLabel;
    qr8: TQRLabel;
    qr9: TQRLabel;
    qr10: TQRLabel;
    qr11: TQRLabel;
    qr12: TQRLabel;
    qr13: TQRLabel;
    QRLabel44: TQRLabel;
    QRLabel45: TQRLabel;
    QRLabel46: TQRLabel;
    QRLabel50: TQRLabel;
    QRLabel51: TQRLabel;
    QRLabel52: TQRLabel;
    QRLabel53: TQRLabel;
    QRLabel54: TQRLabel;
    QRLabel55: TQRLabel;
    QRLabel56: TQRLabel;
    QRLabel48: TQRLabel;
    qr14: TQRLabel;
    qr15: TQRLabel;
    qr16: TQRLabel;
    qr17: TQRLabel;
    qr18: TQRLabel;
    qr19: TQRLabel;
    qr20: TQRLabel;
    qr21: TQRLabel;
    qr22: TQRLabel;
    qr23: TQRLabel;
    qr25: TQRLabel;
    qr24: TQRLabel;
    qr26: TQRLabel;
    QRLabel68: TQRLabel;
    QRLabel69: TQRLabel;
    QRLabel70: TQRLabel;
    QRLabel71: TQRLabel;
    QRLabel72: TQRLabel;
    QRLabel73: TQRLabel;
    QRLabel74: TQRLabel;
    QRLabel75: TQRLabel;
    QRLabel77: TQRLabel;
    QRLabel78: TQRLabel;
    QRLabel79: TQRLabel;
    lblAdditionalInformation: TQRLabel;
    lblStabilityMarginPerseke: TQRLabel;
    lblLongitudalStability: TQRLabel;
    lblYawStability: TQRLabel;
    qr27: TQRLabel;
    qr28: TQRLabel;
    qr29: TQRLabel;
    QRLabel38: TQRLabel;
    qrCAE: TQRLabel;
    QRChildBand1: TQRChildBand;
    QRSubDetail1: TQRSubDetail;
    QRShape2: TQRShape;
    lblHeading2: TQRLabel;
    lblHeading1: TQRLabel;
    lblColCl: TQRLabel;
    lbCA: TQRLabel;
    lblColSpeed: TQRLabel;
    lblColSpeedUnit: TQRLabel;
    lbV_ms: TQRLabel;
    lbV_kmh: TQRLabel;
    lbRei: TQRLabel;
    lbRem: TQRLabel;
    lbRea: TQRLabel;
    lblColRei: TQRLabel;
    lblColReUnit: TQRLabel;
    lblColRem: TQRLabel;
    lblColRea: TQRLabel;
    lbCwp: TQRLabel;
    lbCwi: TQRLabel;
    lbCw: TQRLabel;
    lbCwges: TQRLabel;
    lbE: TQRLabel;
    lblColCwp: TQRLabel;
    lblColCwi: TQRLabel;
    lblColCw: TQRLabel;
    lblColCwges: TQRLabel;
    lblCwpUnit: TQRLabel;
    lblColCwiUnit: TQRLabel;
    lblColCwUnit: TQRLabel;
    lblColE: TQRLabel;
    lbVs: TQRLabel;
    lblColVs: TQRLabel;
    lblColVsUnit: TQRLabel;
    lbEwd: TQRLabel;
    lblColEwd: TQRLabel;
    lbD: TQRLabel;
    lblColSp: TQRLabel;
    lblColSpUnit: TQRLabel;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRShape9: TQRShape;
    QRShape10: TQRShape;
    QRShape11: TQRShape;
    QRBand4: TQRBand;
    lblColEwdUnit: TQRLabel;
    lblLegend1: TQRLabel;
    lblLegend3: TQRLabel;
    lblProg: TQRLabel;
    lblSubtitle: TQRLabel;
    imgProfil: TQRImage;
    lblLegend2: TQRLabel;
    QRLabel58: TQRLabel;
    procedure QRSubDetail1NeedData(Sender: TObject; var MoreData: Boolean);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private
    { Private declarations }
    FModellVariante: TModellVariante;
    FNextLeistungsIdx: integer;
    procedure SetModellVariante(const Value: TModellVariante);
    procedure SetTexts();
  public
    { Public declarations }
    property ModellVariante: TModellVariante read FModellVariante write SetModellVariante;
  end;

var
  qrpModellauslegung: TqrpModellauslegung;

implementation

{$R *.dfm}

uses
  math, ad_consts, ad_utils, ProfilGraph, maindata, idTranslator;

procedure TqrpModellauslegung.QRSubDetail1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  MoreData := FNextLeistungsIdx < ModellVariante.Leistungsdaten.Count;

  if MoreData then begin
    { Detailzeilen abfüllen }
    with ModellVariante.Leistungsdaten.Items[FNextLeistungsIdx] do begin
      lbCA.Caption := Format('%1.1f', [RoundTo(ca, -1)]);
      lbV_ms.Caption := Format('%1.1f', [RoundTo(V_ms, -1)]);
      lbV_kmh.Caption := Format('%1.1f', [RoundTo(V_kmh, -1)]);
      lbRei.Caption := Format('%1.0f', [Rei / 1000]);
      lbRem.Caption := Format('%1.0f', [Rem / 1000]);
      lbRea.Caption := Format('%1.0f', [Rea / 1000]);
      lbCwp.Caption := Format('%1.4f', [RoundTo(cwp, -4)]);
      lbCwi.Caption := Format('%1.4f', [RoundTo(cwi, -4)]);
      lbCw.Caption := Format('%1.4f', [RoundTo(cw, -4)]);
      lbCwges.Caption := Format('%1.4f', [RoundTo(cwges, -4)]);
      lbE.Caption := Format('%1.1f', [RoundTo(E, -1)]);
      lbVs.Caption := Format('%1.2f', [RoundTo(Vs, -2)]);
      lbEwd.Caption := Format('%-1.1f', [RoundTo(ewd, -1)]);
      lbD.Caption := Format('%d', [Round(sp)]);
    end;
    Inc(FNextLeistungsIdx);
  end;
end;

procedure TqrpModellauslegung.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  FNextLeistungsIdx := 0;

  SetTexts();

  with ModellVariante do begin
    { Daten in Report abfüllen }
    qrModellName.Caption := CurrentModell.ModellName;
    qrVariantenName.Caption := VariantenName;
    qrProfilInnen.Caption := ProfilInnen.Dateiname;
    qrProfilAussen.Caption := ProfilAussen.Dateiname;
    qrProfilInnenDaten.Caption := Format(dmMain.Translator.GetLit('ReportAlphaCmHeader'), [ProfilInnen.Alpha0, ProfilInnen.cm0]);
    qrProfilAussenDaten.Caption := Format(dmMain.Translator.GetLit('ReportAlphaCmHeader'), [ProfilAussen.Alpha0, ProfilAussen.cm0]);

    qr1.Caption := Format('%d', [Round(G)]);
    qr2.Caption := Format('%-.1f', [RoundTo(Flaechenbelastung, -1)]);
    qr3.Caption := Format('%d', [Spannweite]);
    qr4.Caption := Format('%.0f', [Wurzeltiefe]);
    qr5.Caption := Format('%.0f', [TiefeTrapezstoss]);
    qr6.Caption := Format('%.0f', [LageTrapezstoss]);
    qr7.Caption := Format('%.0f', [TiefeRandbogen]);
    qr8.Caption := Format('%-.1f', [RoundTo(F, -1)]);
    qr9.Caption := Format('%1.2f', [RoundTo(Z, -1)]);
    qr10.Caption := Format('%2.1f', [RoundTo(L1, -1)]);
    qr11.Caption := Format('%d', [Round(T4)]);
    qr12.Caption := Format('%d', [Round(TMF)]);
    qr13.Caption := Format('%d', [Round(XTMF)]);

    qr14.Caption := Format('%3.1f', [RoundTo(FAI, -1)]);
    qr15.Caption := Format('%d',    [Round(NP)]);
    qrCAE.Caption := Format('%0.1f',[RoundTo(Schwerpunkt, -1)]);
    qr16.Caption := Format('%d',    [Round(Leistungsdaten.GetSPforCA(Schwerpunkt))]);
    qr17.Caption := Format('%d',    [Round(NE)]);
    qr18.Caption := Format('%2.1f', [RoundTo(Stabilitatsmass, -1)]);
    qr19.Caption := Format('%d',    [Round(RH * 100)]);
    qr20.Caption := Format('%2.1f', [RoundTo(FH, -1)]);
    qr21.Caption := Format('%2.1f', [RoundTo(VH, -1)]);
    qr22.Caption := Format('%2.1f', [RoundTo(LHLw, -1)]);
    qr23.Caption := Format('%d',    [Round(BHLw)]);
    qr24.Caption := Format('%d',    [Round(TMH)]);
    qr25.Caption := Format('%.1f',  [RoundTo(FS, -1)]);
    qr26.Caption := Format('%1.4f', [RoundTo(cm0zwi, -4)]);

    qr27.Caption := Format('%3.1f', [RoundTo(NPNeu, -1)]);
    qr28.Caption := Format('%3.2f', [RoundTo(STFH, -2)]);
    qr29.Caption := Format('%3.1f', [RoundTo(STFS, -1)]);

    QRLabel58.Caption := Format('%3.1f%%', [RoundTo(NPNeu, -1)]);

  end;

end;

procedure TqrpModellauslegung.SetModellVariante(
  const Value: TModellVariante);
var
  profilPainter: TProfilCoordPainter;
  bmp: TBitmap;
begin
  FModellVariante := Value;

  with ModellVariante do begin
    { Zeichne Profil }
    profilPainter:= TProfilCoordPainter.Create( nil );
    try
      profilPainter.Top:= imgProfil.Top;
      profilPainter.Left:= imgProfil.Left;
      profilPainter.Height:= imgProfil.Height;
      profilPainter.Width:= imgProfil.Width;

      profilPainter.Profil:= ProfilInnen;
      profilPainter.ShowPoints:= false;
      profilPainter.ShowSchwerpunkte:= spEiner;
      profilPainter.Schwerpunkt1:= 100 / Wurzeltiefe * Leistungsdaten.GetSPforCA(Schwerpunkt);
      profilPainter.Schwerpunkt1Text:= Format( dmMain.Translator.GetLit('ReportDesignCenterGravity'),
                                               [RoundTo(Schwerpunkt, -1),
                                                Round(Leistungsdaten.GetSPforCA(Schwerpunkt)) ] );

      bmp:= TBitmap.Create;
      try
        bmp.Width:= imgProfil.Width;
        bmp.Height:= imgProfil.Height;
        profilPainter.PaintToCanvas( bmp.Canvas );
        bmp.SaveToFile( GetTempBitmapPath() );
        imgProfil.Picture.Bitmap.LoadFromFile( GetTempBitmapPath() );
      finally
        FreeAndNil( bmp );
        DeleteFile( GetTempBitmapPath() );
      end;
    finally
      FreeAndNil( profilPainter );
    end;
  end;
end;

procedure TqrpModellauslegung.SetTexts;
begin
  lblProg.Caption := Format( dmMain.Translator.GetLit('ReportProgramCaption'), [ProgramName, ProgVersion] );
  QuickRep1.ReportTitle := dmMain.Translator.GetLit('ReportDesignReportTitle');
  lblSubtitle.Caption := dmMain.Translator.GetLit('ReportDesignSubtitle');
  lblModelName.Caption := dmMain.Translator.GetLit('ReportModelname');
  lblVersionname.Caption := dmMain.Translator.GetLit('ReportVersionname');

  lblHeading1.Caption := dmMain.Translator.GetLit('ReportDesignHeading1');
  lblAirfoilRoot.Caption := dmMain.Translator.GetLit('ReportDesignAirfoilRoot');
  lblAirfoilTip.Caption := dmMain.Translator.GetLit('ReportDesignAirfoilTip:');
  lblWeight.Caption := dmMain.Translator.GetLit('ReportDesignWeight');
  lblWingLoading.Caption := dmMain.Translator.GetLit('ReportDesignWingLoading');
  lblWingSpan.Caption := dmMain.Translator.GetLit('ReportDesignWingSpan');
  lblWingRootChord.Caption := dmMain.Translator.GetLit('ReportDesignWingRootChord');
  lblWingCenterlineChord.Caption := dmMain.Translator.GetLit('ReportDesignWingCenterlineChord');
  lblDistanceFromPanelLine.Caption := dmMain.Translator.GetLit('ReportDesignDistanceFromPanelLine');
  lblWingTipChord.Caption := dmMain.Translator.GetLit('ReportDesignWingTipChord');
  lblWingSurface.Caption := dmMain.Translator.GetLit('ReportDesignWingSurface');
  lblEffectiveTaper.Caption := dmMain.Translator.GetLit('ReportDesignEffectiveTaper');
  lblAspectRatio.Caption := dmMain.Translator.GetLit('ReportDesignAspectRatio');
  lblMeanChord.Caption := dmMain.Translator.GetLit('ReportDesignMeanChord');
  lblMeanGeometricChord.Caption := dmMain.Translator.GetLit('ReportDesignMeanGeometricChord');
  lblDistanceMeanGeoChordFromCenterLine.Caption := dmMain.Translator.GetLit('ReportDesignDistanceMeanGeometricChordFromCenterline');
  lblFAIWingLoadWIthTail.Caption := dmMain.Translator.GetLit('ReportDesignFAIWingLoadWithTail');
  lblModelNeutralPoint.Caption := dmMain.Translator.GetLit('ReportDesignModelNeutralPoint');
  lblCenterGravityCl.Caption := dmMain.Translator.GetLit('ReportDesignCenterGravityCl');
  lblDistanceToNeutralPoint.Caption := dmMain.Translator.GetLit('ReportDesignDistanceToNeutralPoint');
  lblStabilityMargin.Caption := dmMain.Translator.GetLit('ReportDesignStabilityMargin');
  lblStabLeverArm.Caption := dmMain.Translator.GetLit('ReportDesignStabLeverArm');
  lblElevatorSurface.Caption := dmMain.Translator.GetLit('ReportDesignElevatorSurface');
  lblRelativeSizeElevatorWing.Caption := dmMain.Translator.GetLit('ReportDesignRelativeSizeElevatorWing');
  lblElevatorAspectRatio.Caption := dmMain.Translator.GetLit('ReportDesignElevatorAspectRatio');
  lblElevatorSpan.Caption := dmMain.Translator.GetLit('ReportDesignElevatorSpan');
  lblElevatorMeanChord.Caption := dmMain.Translator.GetLit('ReportDesignElevatorMeanChord');
  lblVerticalTailSurface.Caption := dmMain.Translator.GetLit('ReportDesignVerticalTailSurface');
  lblCm0AtMeanGeometricChord.Caption := dmMain.Translator.GetLit('ReportDesignCm0AtMeanChord');
  lblAdditionalInformation.Caption := dmMain.Translator.GetLit('ReportDesignAdditionalInformation');
  lblStabilityMarginPerseke.Caption := dmMain.Translator.GetLit('ReportDesignStabilityMarginPerseke');
  lblLongitudalStability.Caption := dmMain.Translator.GetLit('ReportDesignLongitudalStability');
  lblYawStability.Caption := dmMain.Translator.GetLit('ReportDesignYawStability');

  lblHeading2.Caption := dmMain.Translator.GetLit('ReportDesignHeading2');
  lblColCl.Caption := dmMain.Translator.GetLit('ReportDesignColCl');
  lblColSpeed.Caption := dmMain.Translator.GetLit('ReportDesignColSpeed');
  lblColSpeedUnit.Caption := dmMain.Translator.GetLit('ReportDesignColSpeedUnit');
  lblColRei.Caption := dmMain.Translator.GetLit('ReportDesignColRei');
  lblColRem.Caption := dmMain.Translator.GetLit('ReportDesignColRem');
  lblColRea.Caption := dmMain.Translator.GetLit('ReportDesignColRea');
  lblColReUnit.Caption := dmMain.Translator.GetLit('ReportDesignColReUnit');
  lblColCwp.Caption := dmMain.Translator.GetLit('ReportDesignColCwp');
  lblCwpUnit.Caption := dmMain.Translator.GetLit('ReportDesignColCwpUnit');
  lblColCwi.Caption := dmMain.Translator.GetLit('ReportDesignColCwi');
  lblColCwiUnit.Caption := dmMain.Translator.GetLit('ReportDesignColCwiUnit');
  lblColCw.Caption := dmMain.Translator.GetLit('ReportDesignColCw');
  lblColCwUnit.Caption := dmMain.Translator.GetLit('ReportDesignColCwUnit');
  lblColCwges.Caption := dmMain.Translator.GetLit('ReportDesignColCwges');
  lblColE.Caption := dmMain.Translator.GetLit('ReportDesignColE');
  lblColVs.Caption := dmMain.Translator.GetLit('ReportDesignColVs');
  lblColVsUnit.Caption := dmMain.Translator.GetLit('ReportDesignColVsUnit');
  lblColEwd.Caption := dmMain.Translator.GetLit('ReportDesignColEwd');
  lblColEwdUnit.Caption := dmMain.Translator.GetLit('ReportDesignColEwdUnit');
  lblColSp.Caption := dmMain.Translator.GetLit('ReportDesignColSp');
  lblColSpUnit.Caption := dmMain.Translator.GetLit('ReportDesignColSpUnit');
  lblLegend1.Caption := dmMain.Translator.GetLit('ReportDesignLegend1');
  lblLegend2.Caption := dmMain.Translator.GetLit('ReportDesignLegend2');
  lblLegend3.Caption := dmMain.Translator.GetLit('ReportDesignLegend3');

end;

end.
