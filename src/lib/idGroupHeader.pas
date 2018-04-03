{-----------------------------------------------------------------------------
 Unit Name: idGroupHeader
 Author:    Marc
 Purpose:   Graphical group separator
 History:
-----------------------------------------------------------------------------}


unit idGroupHeader;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics;

const

  { Default Color's }
  ColDefFill       : TColor = $00FFE2C6;
  ColDefBorder     : TColor = $00FFBC79;
  ColDefFont       : TColor = clBlack;

type
  TidGroupHeader = class(TGraphicControl)
  private
    FCaption: TCaption;
    FFillColor: TColor;
    FBorderColor: TColor;
    FFontColor: TColor;
    FUseDefaultColors: boolean;
    FColor: TColor;
    FBoldLabel: boolean;
    procedure SetBorderColor(const Value: TColor);
    procedure SetCaption(const Value: TCaption);
    procedure SetFillColor(const Value: TColor);
    procedure SetFontColor(const Value: TColor);
    procedure SetUseDefaultColors(const Value: boolean);
    procedure SetColor(const Value: TColor);
    procedure SetBoldLabel(const Value: boolean);
    { Private declarations }
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    { Published declarations }
    property Caption: TCaption read FCaption write SetCaption;

    property Color: TColor read FColor write SetColor;
    property FontColor: TColor read FFontColor write SetFontColor;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property FillColor: TColor read FFillColor write SetFillColor;
    property UseDefaultColors: boolean read FUseDefaultColors write SetUseDefaultColors;

    property BoldLabel: boolean read FBoldLabel write SetBoldLabel;

    property Align;
    property Anchors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Hint;
    property ShowHint;
    property Visible;
  end;

procedure Register;

implementation

{$R idGroupHeader.dcr}

procedure Register;
begin
  RegisterComponents('iDev', [TidGroupHeader]);
end;

{ TidGroupHeader }

constructor TidGroupHeader.Create(AOwner: TComponent);
begin
  inherited;
  FUseDefaultColors := true;
  FColor := clBtnFace;
  FCaption := Name;
  FFillColor := ColDefFill;
  FBorderColor := ColDefBorder;
  FFontColor := ColDefFont;
  FBoldLabel := false;
end;

destructor TidGroupHeader.Destroy;
begin
  inherited;
end;

procedure TidGroupHeader.Paint;
var
  y : integer;
  r : TRect;
begin
  with Canvas do begin

    r := ClientRect;

    Brush.Color := FColor;
    Brush.Style := bsSolid;
    Pen.Style := psClear;
    FillRect(r);

    if FUseDefaultColors then begin
      Brush.Color := ColDefFill;
      Pen.Color := ColDefBorder;
      Font.Color := ColDefFont;
    end else begin
      Brush.Color := FFillColor;
      Pen.Color := FBorderColor;
      Font.Color := FFontColor;
    end;
    Brush.Style := bsSolid;
    Pen.Style := psSolid;
    Pen.Width := 1;
    FillRect(r);
    Brush.Style := bsClear;
    Rectangle(r);

    Font.Name := 'Verdana';
    Font.Size := 8;
    if FBoldLabel then Font.Style := Font.Style + [fsBold]
    else Font.Style := Font.Style - [fsBold];
    y := round((Height - TextHeight(FCaption)) / 2);
    TextRect(r, 3, y, FCaption);
  end;
end;

procedure TidGroupHeader.SetBoldLabel(const Value: boolean);
begin
  FBoldLabel := Value;
  Invalidate;
end;

procedure TidGroupHeader.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TidGroupHeader.SetCaption(const Value: TCaption);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TidGroupHeader.SetColor(const Value: TColor);
begin
  FColor := Value;
  Invalidate;
end;

procedure TidGroupHeader.SetFillColor(const Value: TColor);
begin
  FFillColor := Value;
  Invalidate;
end;

procedure TidGroupHeader.SetFontColor(const Value: TColor);
begin
  FFontColor := Value;
  Invalidate;
end;

procedure TidGroupHeader.SetUseDefaultColors(const Value: boolean);
begin
  FUseDefaultColors := Value;
  Invalidate;
end;

end.
