unit report_neutralpunkt;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, modell, varianten;

type
  TqrpNeutralpunkt = class(TQuickRep)
    QRBand1: TQRBand;
    QRSysData2: TQRSysData;
    lblModel: TQRLabel;
    qrModellName: TQRLabel;
    lblVersion: TQRLabel;
    qrVariantenName: TQRLabel;
    QRBand3: TQRBand;
    QRShape1: TQRShape;
    lblAirfoilRoot: TQRLabel;
    qrProfilInnen: TQRLabel;
    qrProfilInnenDaten: TQRLabel;
    lblWingData: TQRLabel;
    lblCountWingPanels: TQRLabel;
    lblFlCount: TQRLabel;
    lblAirfoilTitle: TQRLabel;
    lblWingSpan: TQRLabel;
    lblSpannweite: TQRLabel;
    lblWingSpanUnit: TQRLabel;
    lblRootChord: TQRLabel;
    lblFlWurzeltiefe: TQRLabel;
    lblRootChordUnit: TQRLabel;
    lblTipChord: TQRLabel;
    lblFlTiefeRandbogen: TQRLabel;
    lblTipChordUnit: TQRLabel;
    lblTipSweep: TQRLabel;
    lblFlPfeilungRandbogen: TQRLabel;
    lblTipSweepUnit: TQRLabel;
    lblFlKnickNr: TQRLabel;
    lblFlAbstand: TQRLabel;
    lblFlFluegeltiefe: TQRLabel;
    lblFlPfeilung: TQRLabel;
    QRBand2: TQRBand;
    lblTitleElevator: TQRLabel;
    lblElevatorCountPanels: TQRLabel;
    lblElevatorSpan: TQRLabel;
    lblElevatorRootChord: TQRLabel;
    lblHlwSpannweite: TQRLabel;
    lblHlwWurzeltiefe: TQRLabel;
    lblHlwAnzahlTrap: TQRLabel;
    lblElevatorSpanUnit: TQRLabel;
    lblElevatorRootChordUnit: TQRLabel;
    lblElevatorTipChord: TQRLabel;
    lblElevatorSweepTip: TQRLabel;
    lblHlwTiefeRandbogen: TQRLabel;
    lblPfeilungRandbogen: TQRLabel;
    lblElevatorTipChordUnit: TQRLabel;
    lblElevatorSweepTipUnit: TQRLabel;
    lblElevatorColPanelNo: TQRLabel;
    lblElevatorColDistanceCenterLine: TQRLabel;
    lblElevatorColChord: TQRLabel;
    lblElevatorColSweep: TQRLabel;
    QRShape3: TQRShape;
    QRGroup1: TQRGroup;
    lblColPanelNo: TQRLabel;
    lblColDistanceFromCenterLine: TQRLabel;
    lblColPanelChord: TQRLabel;
    lblColSweep: TQRLabel;
    QRShape2: TQRShape;
    lblHlwKnickNr: TQRLabel;
    lblHlwAbstand: TQRLabel;
    lblHlwFluegeltiefe: TQRLabel;
    lblHlwPfeilung: TQRLabel;
    QRBand4: TQRBand;
    QRShape8: TQRShape;
    lblResults: TQRLabel;
    QRLabel26: TQRLabel;
    lblWingSize: TQRLabel;
    lblAspectRatio: TQRLabel;
    lblAvarageWingChord: TQRLabel;
    lblNeutralPointPosition: TQRLabel;
    lblStabLeverArm: TQRLabel;
    lblResFlLeitwerkshebel: TQRLabel;
    lblResFlNeutralpunktlage: TQRLabel;
    lblResFlBezugstiefe: TQRLabel;
    lblResFlStreckung: TQRLabel;
    lblResFlFlaecheninhalt: TQRLabel;
    lblWingSizeUnit: TQRLabel;
    lblAvarageWingChordUnit: TQRLabel;
    lblNeutralPointPositionUnit: TQRLabel;
    lblStabLeverArmUnit: TQRLabel;
    QRLabel49: TQRLabel;
    lblElevatorSize: TQRLabel;
    lblElevatorAspectRatio: TQRLabel;
    lblAvarageElevatorChord: TQRLabel;
    lblElevatorNeutralPointPosition: TQRLabel;
    lblResHlwFlaecheninhalt: TQRLabel;
    lblResHlwStreckung: TQRLabel;
    lblResHlwBezugsfluegeltiefe: TQRLabel;
    lblResHlwNeutralpunktlage: TQRLabel;
    lblElevatorNeutralPointPositionUnit: TQRLabel;
    lblAvarageElevatorChordUnit: TQRLabel;
    lblElevatorSizeUnit: TQRLabel;
    lblModelNeutralPoint: TQRLabel;
    lblXNPerseke: TQRLabel;
    lblModelNeutralPointUnit: TQRLabel;
    lblPressurePoint: TQRLabel;
    QRShape9: TQRShape;
    lblColCl: TQRLabel;
    lblColPP: TQRLabel;
    lblDpCa: TQRLabel;
    lblDpMm: TQRLabel;
    lblCenterGravity: TQRLabel;
    QRBand5: TQRBand;
    lblLegend: TQRLabel;
    lblElevatorDistanceWingElevator: TQRLabel;
    lblAbstandFlHlw: TQRLabel;
    lblElevatorDistanceWingElevatorUnit: TQRLabel;
    QRBand6: TQRBand;
    QRSysData1: TQRSysData;
    lblProg: TQRLabel;
    lblSubtitle: TQRLabel;
    lblStabilityMargin1: TQRLabel;
    lblStabilityMargin2: TQRLabel;
    lblStabilityMargin3: TQRLabel;
    lblStab1: TQRLabel;
    lblStab2: TQRLabel;
    lblStab3: TQRLabel;
    lblLegendText: TQRLabel;
    lblStabilityMarginRecommendation: TQRLabel;
    lblLegendStab1: TQRLabel;
    lblLegendStab2: TQRLabel;
    lblLegendStab3: TQRLabel;
    lblLegendStab1Text: TQRLabel;
    lblLegendStab2Text: TQRLabel;
    lblLegendStab3Text: TQRLabel;
    imgProfil: TQRImage;
    lblColEWD: TQRLabel;
    lblDpEwd: TQRLabel;
    lblColSetPoint: TQRLabel;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRShape7: TQRShape;
    QRShape10: TQRShape;
    lblDrawingTitle: TQRLabel;
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QRSubDetail1NeedData(Sender: TObject; var MoreData: Boolean);
    procedure QRSubDetail2NeedData(Sender: TObject; var MoreData: Boolean);
    procedure QRSubDetail3NeedData(Sender: TObject; var MoreData: Boolean);
  private
    FModellVariante: TModellVariante;
    FFlIdx,
    FHlwIdx,
    FDruckpunktIdx: integer;
    FDemoCheck: boolean;
    procedure SetModellVariante(const Value: TModellVariante);
    procedure SetTexts();
  public
    property ModellVariante: TModellVariante read FModellVariante write SetModellVariante;

  end;

var
  qrpNeutralpunkt: TqrpNeutralpunkt;

implementation

{$R *.DFM}

uses
  math, ad_consts, ad_utils, ProfilGraph, maindata, idTranslator;

procedure TqrpNeutralpunkt.QuickRepBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  PrintReport:= true;

  with ModellVariante do begin

    FFlIdx:= 0;
    FHLWIdx:= 0;
    FDruckpunktIdx:= 0;

    qrModellName.Caption := CurrentModell.ModellName;
    qrVariantenName.Caption := VariantenName;
    qrProfilInnen.Caption := ProfilInnen.Dateiname;
    qrProfilInnenDaten.Caption := Format(dmMain.Translator.GetLit('ReportAlphaCmHeader'), [ProfilInnen.Alpha0, ProfilInnen.cm0] );

    { Flügeldaten }
    lblFlCount.Caption:= IntToStr( PflgFlKnicke.Count + 1 );
    lblAbstandFlHlw.Caption:= IntToStr( PflgHlwAbstandFluegelHlw );
    lblSpannweite.Caption:= IntToStr( Spannweite );
    lblFlWurzeltiefe.Caption:= CurrToStr( Wurzeltiefe );
    lblFlTiefeRandbogen.Caption:= CurrToStr( TiefeRandbogen );
    lblFlPfeilungRandbogen.Caption:= CurrToStr( PflgFlRandbogen );

    { HLW-Daten }
    lblHlwAnzahlTrap.Caption:= IntToStr( PflgHlwKnicke.Count + 1 );
    lblHlwSpannweite.Caption:= CurrToStr( PflgHlwSpannweite );
    lblHlwWurzeltiefe.Caption:= CurrToStr( PflgHlwWurzeltiefe );
    lblHlwTiefeRandbogen.Caption:= CurrToStr( PflgHlwAussentiefe );
    lblPfeilungRandbogen.Caption := Format('%1.1f', [PflgHlwPfeilung]); // Pfeilung am Randbogen

    { ------------ Ergebisse ------------- }

    { Flügel }
    lblResFlFlaecheninhalt.Caption := Format('%1.1f', [ RoundTo(FLW / 10000, -1) ]); // Flächeninhalt
    lblResFlStreckung.Caption := Format('%1.1f', [RoundTo( LA, -1)]);       // Streckung
    lblResFlBezugstiefe.Caption := Format('%d', [Round( LM)]);             // Bezugsflügeltiefe
    lblResFlNeutralpunktlage.Caption := Format('%d', [Round(XN)]);        // Neutralpunkt
    lblResFlLeitwerkshebel.Caption := Format('%d', [Round(RL)]);          // Leitwerkshebelarm

    { HLW }
    lblResHlwFlaecheninhalt.Caption := Format('%1.1f', [RoundTo(FHLW / 10000, -1)]); // Flächeninhalt
    lblResHlwStreckung.Caption := Format('%1.1f', [RoundTo(LAH, -1)]);       // Streckung
    lblResHlwBezugsfluegeltiefe.Caption := Format('%d', [Round(LMH)]); // Bezugsflügeltiefe
    lblResHlwNeutralpunktlage.Caption := Format('%d', [Round(XNH)]); // Neutralpunkt

    { Modellneutralpunkte }
    lblXNPerseke.Caption := Format('%d', [Round(XNPerseke)]);// nach Perseke
  end;

  SetTexts();

end;

procedure TqrpNeutralpunkt.QRSubDetail1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin

  if ModellVariante.PflgFlKnicke.Count = 0 then  begin
    if FFlIdx = 0 then begin
      inc(FFlIdx);
      lblFlKnickNr.Caption:= 'Keine';
      lblFlKnickNr.AutoSize:= true;
      lblFlKnickNr.Alignment:= taLeftJustify;
      lblFlAbstand.Caption:= '';
      lblFlFluegeltiefe.Caption:= '';
      lblFlPfeilung.Caption:= '';
      MoreData:= true;
    end else begin
      MoreData:= false;
    end;
    exit;
  end;

  MoreData:= FFlIdx < ModellVariante.PflgFlKnicke.Count;

  if MoreData then begin

    lblFlKnickNr.Caption:= IntToStr( FFlIdx + 1 );
    lblFlAbstand.Caption:= CurrToStr( ModellVariante.PflgFlKnicke.Items[ FFlIdx ].Abstand ) + ' mm';
    lblFlFluegeltiefe.Caption:= CurrToStr( ModellVariante.PflgFlKnicke.Items[ FFlIdx ].Fluegeltiefe ) + ' mm';
    lblFlPfeilung.Caption:= CurrToStr( ModellVariante.PflgFlKnicke.Items[ FFlIdx ].Pfeilung ) + ' mm';

    inc( FFlIdx );
  end;

end;

procedure TqrpNeutralpunkt.QRSubDetail2NeedData(Sender: TObject;
  var MoreData: Boolean);
begin

  if ModellVariante.PflgHlwKnicke.Count = 0 then  begin
    if FHlwIdx = 0 then begin
      inc(FHlwIdx);
      lblHlwKnickNr.Caption:= 'Keine';
      lblHlwKnickNr.AutoSize:= true;
      lblHlwKnickNr.Alignment:= taLeftJustify;
      lblHlwAbstand.Caption:= '';
      lblHlwFluegeltiefe.Caption:= '';
      lblHlwPfeilung.Caption:= '';
      MoreData:= true;
    end else begin
      MoreData:= false;
    end;
  end else begin

    MoreData:= FHlwIdx < ModellVariante.PflgHlwKnicke.Count;
    if MoreData then begin
      lblHlwKnickNr.Caption:= IntToStr( FHlwIdx + 1 );
      lblHlwAbstand.Caption:= CurrToStr( ModellVariante.PflgHlwKnicke.Items[ FHlwIdx ].Abstand ) + ' mm';
      lblHlwFluegeltiefe.Caption:= CurrToStr( ModellVariante.PflgHlwKnicke.Items[ FHlwIdx ].Fluegeltiefe ) + ' mm';
      lblHlwPfeilung.Caption:= CurrToStr( ModellVariante.PflgHlwKnicke.Items[ FHlwIdx ].Pfeilung ) + ' mm';
      inc( FHlwIdx );
    end;
  end;

end;

procedure TqrpNeutralpunkt.QRSubDetail3NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  MoreData:= FDruckpunktIdx < ModellVariante.Schwerpunkte.Count;

  if MoreData then begin

    lblDpCa.Caption:= Format('%-1.1f', [RoundTo(ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].ca, -1)]);
    lblDpEwd.Caption:= Format('%-1.1f', [RoundTo(ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].EWD, -1)]);
    lblDpMm.Caption:= Format('%d mm', [Round(ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].DP)]);

    { Stab 1 - 3 }
    lblStab1.Caption:= Format('%d mm', [Round(ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].Stab1)]);
    lblStab2.Caption:= Format('%d mm', [Round(ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].Stab2)]);
    lblStab3.Caption:= Format('%d mm', [Round(ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].Stab3)]);

    { Graue Unterlegung Stab 1 }
    if (ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].ca >= 0.6)
      and (ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].ca <= 0.7)
    then begin
      lblStab1.Font.Style:= [ fsBold ];
    end else begin
      lblStab1.Font.Style:= [];
    end;

    { Graue Unterlegung Stab 2 }
    if (ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].ca >= 0.5)
      and (ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].ca <= 0.6)
    then begin
      lblStab2.Font.Style:= [ fsBold ];
    end else begin
      lblStab2.Font.Style:= [];
    end;

    { Graue Unterlegung Stab 3 }
    if (ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].ca >= 0.4)
      and (ModellVariante.Schwerpunkte.Items[FDruckpunktIdx].ca <= 0.5)
    then begin
      lblStab3.Font.Style:= [ fsBold ];
    end else begin
      lblStab3.Font.Style:= [];
    end;

    inc( FDruckpunktIdx );
  end;

end;

procedure TqrpNeutralpunkt.SetModellVariante(const Value: TModellVariante);
var
  profilPainter: TProfilCoordPainter;
  bmp: TBitmap;
  sp: TSchwerpunkt;
begin
  FModellVariante := Value;

  { Profilgrafik }
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
      profilPainter.ShowSchwerpunkte:= spDrei;
      profilPainter.AlignTopLeft:= true;

      sp:= Schwerpunkte.ItemByCa( 0.7 );
      if Assigned( sp ) then begin
        profilPainter.Schwerpunkt1:= 100 / Wurzeltiefe * sp.Stab1;
        profilPainter.Schwerpunkt1Text:= 'Stabmass 1';
      end;
      sp:= Schwerpunkte.ItemByCa( 0.6 );
      if Assigned( sp ) then begin
        profilPainter.Schwerpunkt2:= 100 / Wurzeltiefe * sp.Stab2;
        profilPainter.Schwerpunkt2Text:= 'Stabmass 2';
      end;
      sp:= Schwerpunkte.ItemByCa( 0.5 );
      if Assigned( sp ) then begin
        profilPainter.Schwerpunkt3:= 100 / Wurzeltiefe * sp.Stab3;
        profilPainter.Schwerpunkt3Text:= 'Stabmass 3';
      end;

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

procedure TqrpNeutralpunkt.SetTexts;
begin
  ReportTitle := dmMain.Translator.GetLit('ReportNppReportTitle');
  lblProg.Caption := Format( dmMain.Translator.GetLit('ReportProgramCaption'), [ProgramName, ProgVersion] );
  lblModel.Caption := dmMain.Translator.GetLit('ReportModelname');
  lblVersion.Caption := dmMain.Translator.GetLit('ReportVersionname');
  lblSubtitle.Caption := dmMain.Translator.GetLit('ReportNppSubtitle');
  lblAirfoilTitle.Caption := dmMain.Translator.GetLit('ReportNppAirfoilTitle');
  lblAirfoilRoot.Caption := dmMain.Translator.GetLit('ReportNppAirfoilRoot');

  lblWingData.Caption := dmMain.Translator.GetLit('ReportNppTitleWingData');
  lblCountWingPanels.Caption := dmMain.Translator.GetLit('ReportNppCountWingPanels');
  lblWingSpan.Caption := dmMain.Translator.GetLit('ReportNppWingSpan');
  lblWingSpanUnit.Caption := dmMain.Translator.GetLit('ReportNppWingSpanUnit');
  lblRootChord.Caption := dmMain.Translator.GetLit('ReportNppRootChord');
  lblRootChordUnit.Caption := dmMain.Translator.GetLit('ReportNppRootChordUnit');
  lblTipChord.Caption := dmMain.Translator.GetLit('ReportNppTipChord');
  lblTipChordUnit.Caption := dmMain.Translator.GetLit('ReportNppTipChordUnit');
  lblTipSweep.Caption := dmMain.Translator.GetLit('ReportNppTipSweep');
  lblTipSweepUnit.Caption := dmMain.Translator.GetLit('ReportNppTipSweepUnit');
  lblColPanelNo.Caption := dmMain.Translator.GetLit('ReportNppColPanelNo');
  lblColDistanceFromCenterLine.Caption := dmMain.Translator.GetLit('ReportNppColDistanceFromCenterLine');
  lblColPanelChord.Caption := dmMain.Translator.GetLit('ReportNppColPanelChord');
  lblColSweep.Caption := dmMain.Translator.GetLit('ReportNppColSweep');

  lblTitleElevator.Caption := dmMain.Translator.GetLit('ReportNppTitleElevator');
  lblElevatorCountPanels.Caption := dmMain.Translator.GetLit('ReportNppElevatorCountPanels');
  lblElevatorSpan.Caption := dmMain.Translator.GetLit('ReportNppElevatorSpan');
  lblElevatorSpanUnit.Caption := dmMain.Translator.GetLit('ReportNppElevatorSpanUnit');
  lblElevatorRootChord.Caption := dmMain.Translator.GetLit('ReportNppElevatorRootChord');
  lblElevatorRootChordUnit.Caption := dmMain.Translator.GetLit('ReportNppElevatorRootChordUnit');
  lblElevatorDistanceWingElevator.Caption := dmMain.Translator.GetLit('ReportNppElevatorDistanceWingElevator');
  lblElevatorDistanceWingElevatorUnit.Caption := dmMain.Translator.GetLit('ReportNppElevatorDistanceWingElevatorUnit');
  lblElevatorTipChord.Caption := dmMain.Translator.GetLit('ReportNppElevatorTipChord');
  lblElevatorTipChordUnit.Caption := dmMain.Translator.GetLit('ReportNppElevatorTipChordUnit');
  lblElevatorSweepTip.Caption := dmMain.Translator.GetLit('ReportNppElevatorSweepTip');
  lblElevatorSweepTipUnit.Caption := dmMain.Translator.GetLit('ReportNppElevatorSweepTipUnit');
  lblElevatorColPanelNo.Caption := dmMain.Translator.GetLit('ReportNppElevatorColPanelNo');
  lblElevatorColDistanceCenterLine.Caption := dmMain.Translator.GetLit('ReportNppColDistanceFromCenterLine');
  lblElevatorColChord.Caption := dmMain.Translator.GetLit('ReportNppElevatorColChord');
  lblElevatorColSweep.Caption := dmMain.Translator.GetLit('ReportNppElevatorColSweep');

  lblResults.Caption := dmMain.Translator.GetLit('ReportNppResTitle');
  QRLabel26.Caption := dmMain.Translator.GetLit('ReportNppTitleWingData');
  lblWingSize.Caption := dmMain.Translator.GetLit('ReportNppWingSize');
  lblWingSizeUnit.Caption := dmMain.Translator.GetLit('ReportNppWingSizeUnit');
  lblAspectRatio.Caption := dmMain.Translator.GetLit('ReportNppAspectRatio');
  lblAvarageWingChord.Caption := dmMain.Translator.GetLit('ReportNppAvarageWingChord');
  lblAvarageWingChordUnit.Caption := dmMain.Translator.GetLit('ReportNppAvarageWingChordUnit');
  lblNeutralPointPosition.Caption := dmMain.Translator.GetLit('ReportNppNeutralPointPosition');
  lblNeutralPointPositionUnit.Caption := dmMain.Translator.GetLit('ReportNppNeutralPointPositionUnit');
  lblStabLeverArm.Caption := dmMain.Translator.GetLit('ReportNppStabLeverArm');
  lblStabLeverArmUnit.Caption := dmMain.Translator.GetLit('ReportNppStabLeverArmUnit');
  QRLabel49.Caption := dmMain.Translator.GetLit('ReportNppTitleElevator');
  lblElevatorSize.Caption := dmMain.Translator.GetLit('ReportNppWingSize');
  lblElevatorSizeUnit.Caption := dmMain.Translator.GetLit('ReportNppWingSizeUnit');
  lblElevatorAspectRatio.Caption := dmMain.Translator.GetLit('ReportNppAspectRatio');
  lblAvarageElevatorChord.Caption := dmMain.Translator.GetLit('ReportNppAvarageWingChord');
  lblAvarageElevatorChordUnit.Caption := dmMain.Translator.GetLit('ReportNppAvarageWingChordUnit');
  lblElevatorNeutralPointPosition.Caption := dmMain.Translator.GetLit('ReportNppNeutralPointPosition');
  lblElevatorNeutralPointPositionUnit.Caption := dmMain.Translator.GetLit('ReportNppNeutralPointPositionUnit');
  lblModelNeutralPoint.Caption := dmMain.Translator.GetLit('ReportNppModelNeutralPoint');
  lblModelNeutralPointUnit.Caption := dmMain.Translator.GetLit('ReportNppModelNeutralPointUnit');
  lblColSetPoint.Caption := dmMain.Translator.GetLit('ReportNppSetPoint');
  lblColCl.Caption := dmMain.Translator.GetLit('ReportNppColCl');
  lblColEWD.Caption := dmMain.Translator.GetLit('ReportNppColEWD');
  lblPressurePoint.Caption := dmMain.Translator.GetLit('ReportNppColPressurePoint');
  lblColPP.Caption := dmMain.Translator.GetLit('ReportNppColPP');
  lblCenterGravity.Caption := dmMain.Translator.GetLit('ReportNppCenterGravity');
  lblCenterGravity.Caption := dmMain.Translator.GetLit('ReportNppCenterGravity');
  lblStabilityMargin1.Caption := dmMain.Translator.GetLit('ReportNppStabilityMargin1');
  lblStabilityMargin2.Caption := dmMain.Translator.GetLit('ReportNppStabilityMargin2');
  lblStabilityMargin3.Caption := dmMain.Translator.GetLit('ReportNppStabilityMargin3');
  lblDrawingTitle.Caption := dmMain.Translator.GetLit('ReportNppDrawingTitle');
  lblStabilityMarginRecommendation.Caption := dmMain.Translator.GetLit('ReportNppStabilityMarginRecommendation');
  lblLegendStab1.Caption := dmMain.Translator.GetLit('ReportNppStab1');
  lblLegendStab2.Caption := dmMain.Translator.GetLit('ReportNppStab2');
  lblLegendStab3.Caption := dmMain.Translator.GetLit('ReportNppStab3');
  lblLegendStab1Text.Caption := dmMain.Translator.GetLit('ReportNppStab1Text');
  lblLegendStab2Text.Caption := dmMain.Translator.GetLit('ReportNppStab2Text');
  lblLegendStab3Text.Caption := dmMain.Translator.GetLit('ReportNppStab3Text');
  lblLegend.Caption := dmMain.Translator.GetLit('ReportNppLegend');
  lblLegendText.Caption := dmMain.Translator.GetLit('ReportNppLegendText'); 

end;


end.
