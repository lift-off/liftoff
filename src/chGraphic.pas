unit chGraphic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, idTitleBar, modelpainter, ComCtrls, Buttons;

type
  TfraGraphic = class(TFrame)
    Shape4: TShape;
    Shape1: TShape;
    idTitleBar1: TidTitleBar;
    Label26: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    pnlPainter: TPanel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    rbAuto: TRadioButton;
    rbSimple: TRadioButton;
    rbDetailed: TRadioButton;
    Label4: TLabel;
    cbAutoZoom: TCheckBox;
    tbZoom: TTrackBar;
    btnUp: TSpeedButton;
    btnLeft: TSpeedButton;
    btnRight: TSpeedButton;
    btnDown: TSpeedButton;
    Image1: TImage;
    Image2: TImage;
    cbGrid: TCheckBox;
    procedure rbAutoClick(Sender: TObject);
    procedure cbAutoZoomClick(Sender: TObject);
    procedure tbZoomChange(Sender: TObject);
    procedure btnLeftMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure cbGridClick(Sender: TObject);
  private
    { Private declarations }
    FPainter: TModellPainter;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;

    property Painter: TModellPainter read FPainter;
  end;

implementation

{$R *.dfm}

{ TfraGraphic }

constructor TfraGraphic.Create(AOwner: TComponent);
begin
  inherited;
  FPainter:= TModellPainter.Create( self );
  FPainter.Parent:= pnlPainter;
  FPainter.Align:= alClient;
end;

procedure TfraGraphic.rbAutoClick(Sender: TObject);
begin
  if rbAuto.Checked then FPainter.DrawMode:= dmAuto else
  if rbSimple.Checked then FPainter.DrawMode:= dmSimple else
  if rbDetailed.Checked then FPainter.DrawMode:= dmDetailed;
end;

procedure TfraGraphic.cbAutoZoomClick(Sender: TObject);
begin
  FPainter.AutoScale:= cbAutoZoom.Checked;
  tbZoom.Enabled:= not cbAutoZoom.Checked;
  btnDown.Enabled:= not cbAutoZoom.Checked;
  btnUp.Enabled:= not cbAutoZoom.Checked;
  btnLeft.Enabled:= not cbAutoZoom.Checked;
  btnRight.Enabled:= not cbAutoZoom.Checked;
end;

procedure TfraGraphic.tbZoomChange(Sender: TObject);
begin
  FPainter.Zoom:= tbZoom.Position;
end;

procedure TfraGraphic.btnLeftMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Sender = btnDown then FPainter.Pan( pdDown ) else
  if Sender = btnUp then FPainter.Pan( pdUp ) else
  if Sender = btnLeft then FPainter.Pan( pdLeft ) else
  if Sender = btnRight then FPainter.Pan( pdRight );
end;

procedure TfraGraphic.Image1Click(Sender: TObject);
begin
  tbZoom.Position:= tbZoom.Position - tbZoom.PageSize;
end;

procedure TfraGraphic.Image2Click(Sender: TObject);
begin
  tbZoom.Position:= tbZoom.Position + tbZoom.PageSize;
end;

procedure TfraGraphic.cbGridClick(Sender: TObject);
begin
  FPainter.ShowGrid:= cbGrid.Checked;
end;

end.
