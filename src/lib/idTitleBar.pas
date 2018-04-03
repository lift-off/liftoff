unit idTitleBar;

interface

uses
  Messages, Sysutils, Classes, controls, windows,
  Graphics, Menus, Forms, extctrls
  {$IFNDEF VER100}
  , imglist, ActnList
  {$ENDIF}
  ;

type
  TidTitleBar = class(TPanel)
  private
    { Private declarations }
    bDrawGradient : boolean;
    FColors: array[0..255] of Longint;
    FStartColor: TColor;
    FEndColor: TColor;
    procedure PrepareGradient;
    procedure SetEndColor(const Value: TColor);
    procedure SetStartColor(const Value: TColor);
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure CMSYSCOLORCHANGE(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message wm_EraseBkgnd;
  public
    { Public declarations }
    constructor Create(AOwner : Tcomponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    {$IFNDEF VER100}
    property Anchors;
    property Constraints;
    {$ENDIF}
    property Align;
    property Alignment;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Caption;
    property Color;
    property Ctl3D;
    property Font;
    property Locked;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;

    property ColorStart: TColor read FStartColor write SetStartColor;
    property ColorEnd: TColor read FEndColor write SetEndColor;
  end;

procedure Register;

function  CanUseHighlightColor : boolean;

implementation

{$R idtitlebar.dcr}

procedure Register;
begin
  RegisterComponents('iDev', [TidTitleBar]);
end;

function CanUseHighlightColor : boolean;
var
  DC : HDC;
begin
  DC := GetDC(0);
  try
    Result := GetDeviceCaps(DC, BITSPIXEL) > 8;
  finally
    ReleaseDC(0, DC);
  end;
end;

{ TidTitleBar }

procedure TidTitleBar.CMSYSCOLORCHANGE(var Message: TMessage);
begin

  bDrawGradient := CanUseHighlightColor;
  Color := clWhite;

  If bDrawGradient Then
    PrepareGradient;

end;

constructor TidTitleBar.Create(AOwner: Tcomponent);
begin

  inherited Create(AOwner);

  Color := clWhite;
  Font.Color := clBlack;
  Font.Name := 'Verdana';
  Font.Size := 11;
  Font.Style := [fsBold];
  Alignment := taLeftJustify;
  FStartColor := clWhite;
  FEndColor := GetSysColor(COLOR_3DFACE);

  bDrawGradient := CanUseHighlightColor;
  If bDrawGradient Then
    PrepareGradient;

end;

destructor TidTitleBar.Destroy;
begin
  inherited Destroy;
end;

procedure TidTitleBar.Paint;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  ARec : TRect;
  iFontHeight : integer;
  TempStepV  : Single  ;
  ColorCode  : Integer ;
  TempTop    : Integer ;
  TempHeight : Integer ;
  TempRect   : TRect;
begin

  ARec := Canvas.ClipRect;

  If bDrawGradient Then
    begin
      TempStepV := Width / 255;
      TempHeight := Trunc(TempStepV + 1);
        with Canvas do
          begin
            TempTop := 0;
            ColorCode := 0;
            TempRect.Top := 0;
            TempRect.Bottom := Height;
            for ColorCode := 0 to 255 do
              begin
                Brush.Color := FColors[ColorCode];
                TempRect.Left  := TempTop;
                TempRect.Right := TempTop + TempHeight;
                FillRect(TempRect);
                TempTop := Trunc(TempStepV * ColorCode);
              end;
          end;

    end
  else If Not CanUseHighlightColor Then
    begin
      SetTextColor (Canvas.Handle, clBlack);
      SetBkColor (Canvas.Handle, clWhite);
      PatBlt(Canvas.Handle, ARec.Left, ARec.Top, ARec.Right, ARec.Bottom, patcopy);
      Canvas.Brush.Bitmap := nil;
    end
  else
    begin
      Canvas.Brush.Color := Color;
      Canvas.Fillrect(ARec);
    end;

  ARec := Rect(5, 0, Width, Height);

  with Canvas do
    begin
      Brush.Style := bsClear;
      Font := Self.Font;
      iFontHeight := TextHeight('W');
      with ARec do
        begin
          Top := ((Bottom + Top) - iFontHeight) div 2;
          Bottom := Top + iFontHeight;
        end;
      DrawText(Handle, PChar(Caption), -1, ARec, DT_VCENTER or Alignments[Alignment]);
    end;

end;

procedure TidTitleBar.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  If bDrawGradient Then
    Message.Result := 1
  else
    inherited;
end;

procedure TidTitleBar.PrepareGradient;
var
  X: Integer;
  SColor, EColor : TColor;
  DiffR, DiffG, DiffB : Currency;
  LastR, LastG, LastB : Currency;
  MySR, MySG, MySB : Integer;
  MyER, MyEG, MyEB : Integer;

begin
  //eColor := Color;
  //sColor := GetSysColor(COLOR_3DFACE);
  eColor := FStartColor;
  sColor := FEndColor;

  MySR := GetRValue(SColor);
  MySG := GetGValue(SColor);
  MySB := GetBValue(SColor);

  MyER := GetRValue(EColor);
  MyEG := GetGValue(EColor);
  MyEB := GetBValue(EColor);

  EColor := RGB(MySR, MySG, MySB);
  SColor := RGB(MyER, MyEG, MyEB);

  DiffR := (GetRValue(SColor) - GetRValue(EColor)) / 255.0; // work out the difference between
  DiffG := (GetGValue(SColor) - GetGValue(EColor)) / 255.0; // each R G and B pair and divide
  DiffB := (GetBValue(SColor) - GetBValue(EColor)) / 255.0; // into 255 increments

  FColors[0] := SColor;
  LastR := GetRValue(SColor);
  LastG := GetGValue(SColor);
  LastB := GetBValue(SColor);

   for X := 1 to 254 do begin
      LastR := LastR - DiffR; // keep incrementing the colour stored
      LastG := LastG - DiffG;
      LastB := LastB - DiffB;
      FColors[x] := RGB( Trunc(LastR), Trunc(LastG), Trunc(LastB) );
   end;
   FColors[255] := EColor; // fix the end colour
   
end;


procedure TidTitleBar.SetEndColor(const Value: TColor);
begin
  if FEndColor <> Value then begin
    FEndColor := Value;
    PrepareGradient;
    Invalidate;
  end;
end;

procedure TidTitleBar.SetStartColor(const Value: TColor);
begin
  if FStartColor <> Value then begin
    FStartColor := Value;
    PrepareGradient;
    Invalidate;
  end;
end;

end.
