unit report_variantenvergleich;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuickRpt, QRCtrls, ExtCtrls, modell, varianten;

type
  TqrpVariantenVergleich = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRSysData2: TQRSysData;
    QRLabel1: TQRLabel;
    qrModellName: TQRLabel;
    QRBand2: TQRBand;
    QRSysData1: TQRSysData;
    ChildBand1: TQRChildBand;
    QRSubDetail1: TQRSubDetail;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    lbVariante: TQRLabel;
    lbAllround: TQRLabel;
    lbThermik: TQRLabel;
    lbHang: TQRLabel;
    procedure QuickRep1StartPage(Sender: TCustomQuickRep);
    procedure QRSubDetail1NeedData(Sender: TObject; var MoreData: Boolean);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private
    { Private declarations }
    FModell: TModell;
    FVarIdx: integer;
    procedure SetModell(const Value: TModell);
  public
    { Public declarations }
    property Modell: TModell read FModell write SetModell;
  end;

var
  qrpVariantenVergleich: TqrpVariantenVergleich;

implementation

{$R *.dfm}

procedure TqrpVariantenVergleich.QuickRep1StartPage(
  Sender: TCustomQuickRep);
begin
  qrModellName.Caption := Modell.ModellName;
end;

procedure TqrpVariantenVergleich.QRSubDetail1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  MoreData := FVarIdx < FModell.Varianten.Count;
  if MoreData then begin
    lbVariante.Caption := Modell.Varianten.Items[FVarIdx].VariantenName;
    try
      lbAllround.Caption := Format('%1.2f', [Modell.Varianten.Items[FVarIdx].LKZ]);
      lbThermik.Caption := Format('%1.2f', [Modell.Varianten.Items[FVarIdx].LKZTH]);
      lbHang.Caption := Format('%1.2f', [Modell.Varianten.Items[FVarIdx].LKZSTR]);
    except
      lbAllround.Caption := '-';
      lbThermik.Caption := '-';
      lbHang.Caption := '-';
    end;

    inc(FVarIdx);
  end;
end;

procedure TqrpVariantenVergleich.QuickRep1BeforePrint(
  Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
  FVarIdx := 0;
end;

procedure TqrpVariantenVergleich.SetModell(const Value: TModell);
begin
  FModell := Value;
end;

end.
