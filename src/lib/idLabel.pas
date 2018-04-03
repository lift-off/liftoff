{Test}
unit idLabel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Graphics;

type
  TidLabel = class(TCustomLabel)
  private
    { Private declarations }
    FHoverFont: TFont;
    FHoverActive: boolean;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetHoverFont(const Value: TFont);
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure DoDrawText(var Rect: TRect; Flags: Longint); dynamic;
  public
    { Public declarations }
  published
    { Published declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property HoverFont: TFont read FHoverFont write SetHoverFont;

    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Layout;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

implementation

{$R idLabel.dcr}

procedure Register;
begin
  RegisterComponents('iDev', [TidLabel]);
end;

{ TidLabel }

procedure TidLabel.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FHoverActive := true;
  if Assigned(OnMouseEnter) then
    OnMouseEnter(Self);
  Paint;
end;

procedure TidLabel.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FHoverActive := false;
  if Assigned(OnMouseLeave) then
    OnMouseLeave(Self);
  Paint;
end;

constructor TidLabel.Create(AOwner: TComponent);
begin
  inherited;
  FHoverActive := false;
  FHoverFont := TFont.Create;
  HoverFont := Font;
  HoverFont.Style := HoverFont.Style + [fsUnderline];
  HoverFont.Color := clHighlightText;
  AutoSize := true;
end;

procedure TidLabel.Paint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  Rect, CalcRect: TRect;
  DrawStyle: Longint;
begin
  with Canvas do
  begin
    if not Transparent then
    begin
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      FillRect(ClientRect);
    end;
    Brush.Style := bsClear;
    Rect := ClientRect;
    { DoDrawText takes care of BiDi alignments }
    DrawStyle := DT_EXPANDTABS or WordWraps[WordWrap] or Alignments[Alignment];
    { Calculate vertical layout }
    if Layout <> tlTop then
    begin
      CalcRect := Rect;
      DoDrawText(CalcRect, DrawStyle or DT_CALCRECT);
      if Layout = tlBottom then OffsetRect(Rect, 0, Height - CalcRect.Bottom)
      else OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);
    end;
    DoDrawText(Rect, DrawStyle);
  end;
end;

procedure TidLabel.SetHoverFont(const Value: TFont);
begin
  FHoverFont.Assign(Value);
end;

procedure TidLabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  Text: string;
begin
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  Canvas.Font := Font;
  if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    Canvas.Font.Color := clBtnHighlight;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    Canvas.Font.Color := clBtnShadow;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else begin
    if FHoverActive then Canvas.Font := FHoverFont;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end;
end;


destructor TidLabel.Destroy;
begin
  if assigned(FHoverFont) then FHoverFont.Free;
  inherited;
end;

end.
