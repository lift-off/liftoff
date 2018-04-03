unit report_gleitsinkpolare;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QRCtrls, QuickRpt, ExtCtrls, modell, varianten, TeEngine,
  Series, TeeProcs, Chart, DbChart, QRTEE;

type
  TqrpGleitSinkpolare = class(TForm)
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
    lblProg: TQRLabel;
    lblSubtitle: TQRLabel;
    QRDBChart1: TQRDBChart;
    Chart: TQRChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QuickRep1AfterPrint(Sender: TObject);
  private
    { Private declarations }
    FModellVariante: TModellVariante;
    procedure SetModellVariante(const Value: TModellVariante);
    procedure SetTexts();
  public
    { Public declarations }
    property ModellVariante: TModellVariante read FModellVariante write SetModellVariante;
  end;

var
  qrpGleitSinkpolare: TqrpGleitSinkpolare;

implementation

{$R *.dfm}

uses
  math, ad_consts, maindata;

{$OPTIMIZATION OFF}
procedure TqrpGleitSinkpolare.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
var
  i: integer;
begin
  SetTexts();

  { Daten in Report abfüllen }
  qrModellName.Caption := CurrentModell.ModellName;
  qrVariantenName.Caption := ModellVariante.VariantenName;

  Series1.Clear;
  Series2.Clear;
  Series1.XValues.Order:= loNone;
  Series1.YValues.Order:= loNone;
  Series2.XValues.Order:= loNone;
  Series2.YValues.Order:= loNone;
//  Series2.AssociatedToAxis( Chart.Chart.AxesList[2] );
  for i:= ModellVariante.Leistungsdaten.Count - 1 downto 0 do begin
    Series1.AddXY( ModellVariante.Leistungsdaten.Items[i].V_ms,
                   ModellVariante.Leistungsdaten.Items[i].Vs * 10 );
    Series2.AddXY( ModellVariante.Leistungsdaten.Items[i].V_ms,
                   ModellVariante.Leistungsdaten.Items[i].E );
  end;

end;
{$OPTIMIZATION ON}

procedure TqrpGleitSinkpolare.SetModellVariante(
  const Value: TModellVariante);
begin
  FModellVariante := Value;
end;

procedure TqrpGleitSinkpolare.QuickRep1AfterPrint(Sender: TObject);
begin
  FreeAndNil( QuickRep1 );
end;

procedure TqrpGleitSinkpolare.SetTexts;
begin
  QuickRep1.ReportTitle := dmMain.Translator.GetLit('ReportGSPolarsTitle');
  lblSubtitle.Caption := dmMain.Translator.GetLit('ReportGSPolarsSubtitle');
  lblModelName.Caption := dmMain.Translator.GetLit('ReportModelname');
  lblVersionname.Caption := dmMain.Translator.GetLit('ReportVersionname');
  Series1.Title := dmMain.Translator.GetLit('ReportGSPolarsSeriesSink'); // Sinkploaren
  Chart.Chart.LeftAxis.Title.Caption := dmMain.Translator.GetLit('ReportGSPolarsSeriesSinkAxis');
  Series2.Title := dmMain.Translator.GetLit('ReportGSPolarsSeriesGlide'); // Gleitpolaren
  Chart.Chart.BottomAxis.Title.Caption := dmMain.Translator.GetLit('ReportGSPolarsSeriesGlideAxis');
  lblProg.Caption:= Format( dmMain.Translator.GetLit('ReportProgramCaption'), [ProgramName, ProgVersion] );
end;

end.
