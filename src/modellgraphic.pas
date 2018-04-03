unit modellgraphic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxBar, modelpainter, ComCtrls, StdCtrls, ExtCtrls, Buttons,
  dxBarExtItems, idTranslator;

type
  TfrmModelGraphic = class(TForm)
    dxBarManager1: TdxBarManager;
    miAlwaysOnTop: TdxBarButton;
    miShowGrid: TdxBarButton;
    miClose: TdxBarButton;
    miZoomAuto: TdxBarButton;
    miZoomFactor: TdxBarControlContainerItem;
    pnlZoom: TPanel;
    Image1: TImage;
    tbZoom: TTrackBar;
    Image2: TImage;
    dxBarStatic1: TdxBarStatic;
    dxBarStatic2: TdxBarStatic;
    miPanLeft: TdxBarButton;
    miPanRight: TdxBarButton;
    miPanUp: TdxBarButton;
    miPanDown: TdxBarButton;
    translator: TidTranslator;
    procedure miAlwaysOnTopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cbAutoZoomClick(Sender: TObject);
    procedure tbZoomChange(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure miShowGridClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miPanLeftClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FPainter: TModellPainter;
  public
    { Public declarations }
    property Painter: TModellPainter read FPainter;
  end;

var
  frmModelGraphic: TfrmModelGraphic;

implementation

uses main, maindata;

{$R *.dfm}

procedure TfrmModelGraphic.miAlwaysOnTopClick(Sender: TObject);
begin
  if miAlwaysOnTop.Down then FormStyle:= fsStayOnTop
  else FormStyle:= fsNormal;
end;

procedure TfrmModelGraphic.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.miModellGraphicOverview.Down:= false;
end;

procedure TfrmModelGraphic.FormCreate(Sender: TObject);
begin
  FPainter:= TModellPainter.Create( Self );
  FPainter.Parent:= self;
  FPainter.Align:= alClient;
  FPainter.ShowGrid:= false;
  FPainter.SmallPen:= true;
end;

procedure TfrmModelGraphic.cbAutoZoomClick(Sender: TObject);
begin
  FPainter.AutoScale:= miZoomAuto.Down;
  tbZoom.Enabled:= not miZoomAuto.Down;
  miPanDown.Enabled:= not miZoomAuto.Down;
  miPanUp.Enabled:= not miZoomAuto.Down;
  miPanLeft.Enabled:= not miZoomAuto.Down;
  miPanRight.Enabled:= not miZoomAuto.Down;
end;

procedure TfrmModelGraphic.tbZoomChange(Sender: TObject);
begin
  FPainter.Zoom:= tbZoom.Position;
end;

procedure TfrmModelGraphic.Image1Click(Sender: TObject);
begin
  tbZoom.Position:= tbZoom.Position - tbZoom.PageSize;
end;

procedure TfrmModelGraphic.Image2Click(Sender: TObject);
begin
  tbZoom.Position:= tbZoom.Position + tbZoom.PageSize;
end;

procedure TfrmModelGraphic.miShowGridClick(Sender: TObject);
begin
  FPainter.ShowGrid:= miShowGrid.Down;
end;

procedure TfrmModelGraphic.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmModelGraphic.miPanLeftClick(Sender: TObject);
begin
  if Sender = miPanDown then FPainter.Pan( pdDown ) else
  if Sender = miPanUp then FPainter.Pan( pdUp ) else
  if Sender = miPanLeft then FPainter.Pan( pdLeft ) else
  if Sender = miPanRight then FPainter.Pan( pdRight );
end;

procedure TfrmModelGraphic.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  dmMain.CheckForSpecialKey(key, Shift, translator);
end;

procedure TfrmModelGraphic.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

end.
