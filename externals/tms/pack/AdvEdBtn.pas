{*********************************************************************}
{ TADVEDITBTN component                                               }
{ for Delphi & C++Builder                                             }
{ version 1.3                                                         }
{                                                                     }
{ written by TMS Software                                             }
{            copyright © 2000-2002                                    }
{            Email : info@tmssoftware.com                             }
{            Web : http://www.tmssoftware.com                         }
{                                                                     }
{ The source code is given as is. The author is not responsible       }
{ for any possible damage done due to the use of this code.           }
{ The component can be freely used in any application. The source     }
{ code remains property of the author and may not be distributed      }
{ freely as such.                                                     }
{*********************************************************************}

unit AdvEdBtn;
                
{$I TMSDEFS.INC}

interface

uses
  Windows, Classes, StdCtrls, ExtCtrls, Controls, Messages, SysUtils,
  Forms, Graphics, Buttons, Dialogs, Menus, AdvEdit, AEBXPVS;

type
  TNumGlyphs = Buttons.TNumGlyphs;

  { TAdvSpeedButton }

  TAdvSpeedButton = class(TSpeedButton)
  private
    {$IFNDEF DELPHI3_LVL}
    FFlat: Boolean;
    {$ENDIF}
    FEtched: Boolean;
    FFocused: Boolean;
    FHot: Boolean;
    FIsWinXP: Boolean;
    procedure SetEtched(const Value: Boolean);
    procedure SetFocused(const Value: Boolean);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  protected
    procedure Paint; override;
    function DoVisualStyles: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Etched: boolean read FEtched write SetEtched;
    property Focused: boolean read FFocused write SetFocused;
    {$IFNDEF DELPHI3_LVL}
    property Flat: boolean read fFlat write fFlat;
    {$ENDIF}
  end;

  { TEditButton }

  TEditButton = class (TWinControl)
  private
    FButton: TAdvSpeedButton;
    FFocusControl: TWinControl;
    FOnClick: TNotifyEvent;
    FBWidth: Integer;
    function CreateButton: TAdvSpeedButton;
    function GetGlyph: TBitmap;
    procedure SetGlyph(Value: TBitmap);
    function GetNumGlyphs: TNumGlyphs;
    procedure SetNumGlyphs(Value: TNumGlyphs);
    procedure SetCaption(value:string);
    function GetCaption:string;
    procedure BtnClick(Sender: TObject);
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AdjustWinSize (var W: Integer; var H: Integer);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property BWidth: Integer read fBWidth write fBWidth;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property Align;
    property Ctl3D;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property ButtonCaption:string read GetCaption write SetCaption;
    property NumGlyphs: TNumGlyphs read GetNumGlyphs write SetNumGlyphs default 1;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FocusControl: TWinControl read FFocusControl write FFocusControl;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$IFDEF WIN32}
    property OnStartDrag;
    {$ENDIF}
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

{ TAdvEditBtn }

  TAdvEditBtn = class(TAdvEdit)
  private
    FUnitSize : integer;
    FButton: TEditButton;
    FEditorEnabled: Boolean;
    FOnClickBtn:TNotifyEvent;
    FFlat: boolean;
    FEtched: boolean;
    // FFocusBorder: boolean;
    FMouseInControl: boolean;
    FButtonHint: string;
    function GetMinHeight: Integer;
    procedure SetGlyph(value:tBitmap);
    function GetGlyph:TBitmap;
    procedure SetCaption(value:string);
    function GetCaption:string;
    procedure SetFlat(const Value : boolean);
    procedure SetEtched(const Value : boolean);
    procedure DrawControlBorder(DC:HDC);
    procedure DrawButtonBorder;
    procedure DrawBorders;
    function  Is3DBorderControl: Boolean;
    function  Is3DBorderButton: Boolean;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMPaste(var Message: TWMPaste);   message WM_PASTE;
    procedure WMCut(var Message: TWMCut);   message WM_CUT;
    procedure WMPaint(var Msg: TWMPAINT); message WM_PAINT;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    function GetButtonWidth: integer;
    procedure SetButtonWidth(const Value: integer);
    procedure ResizeControl;
    procedure SetButtonHint(const Value: string);
  protected
    procedure BtnClick (Sender: TObject); virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
  public
    procedure SetEditRect;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Button: TEditButton read FButton;
  published
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property ButtonWidth: Integer read GetButtonWidth write SetButtonWidth;
    property ButtonHint: string read FButtonHint write SetButtonHint;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled default True;
    property Enabled;
    property Flat: boolean read FFlat write SetFlat;
    property Font;
    property Etched: Boolean read fEtched write SetEtched;
    //  property FocusBorder: Boolean read FFocusBorder write FFocusBorder;
    property FocusBorder;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property ButtonCaption:string read GetCaption write SetCaption;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property Height;
    property Width;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    {$IFDEF WIN32}
    property OnStartDrag;
    {$ENDIF}
    property OnClickBtn: TNotifyEvent read FOnClickBtn write FOnClickBtn;
  end;

  TUnitChangeEvent = procedure(Sender: TObject; NewUnit:string) of object;

  TUnitAdvEditBtn = class(TAdvEditBtn)
  private
    FUnitID: string;
    FUnits: TStringList;
    FUnitChanged: TUnitChangeEvent;
    function GetUnitSize: Integer;
    procedure SetUnitSize(value: Integer);
    procedure SetUnits(value:tstringlist);
    procedure SetUnitID(value:string);
    procedure WMPaint(var Msg: TWMPAINT); message WM_PAINT;
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
  protected
    procedure BtnClick (Sender: TObject); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Units: TStringList read FUnits write SetUnits;
    property UnitID:string read FUnitID write SetUnitID;
    property UnitSpace: Integer read GetUnitSize write SetUnitSize;
    property OnUnitChanged: TUnitChangeEvent read FUnitChanged write FUnitChanged;
  end;



implementation

procedure DrawBitmapTransp(Canvas: TCanvas;bmp:TBitmap;bkcolor:TColor;r:TRect);
var
  tmpbmp: TBitmap;
  srcColor: TColor;
  tgtrect: TRect;
begin
  TmpBmp := TBitmap.Create;
  TmpBmp.Height := bmp.Height;
  TmpBmp.Width := bmp.Width;

  tgtrect.left := 0;
  tgtrect.top := 0;
  tgtrect.right := r.right - r.left;
  tgtrect.bottom := r.bottom - r.Top;

  TmpBmp.Canvas.Brush.Color := bkcolor;
  srcColor := bmp.Canvas.Pixels[0,0];
  TmpBmp.Canvas.BrushCopy(tgtrect,bmp,tgtrect,srcColor);
  Canvas.CopyRect(r, TmpBmp.Canvas, tgtrect);
  TmpBmp.Free;
end;

{ TAdvSpeedButton }
procedure TAdvSpeedButton.SetEtched(const Value: Boolean);
begin
  if Value <> FEtched then
  begin
    FEtched := value;
    Invalidate;
  end;
end;

procedure TAdvSpeedButton.SetFocused(const Value: Boolean);
begin
  if Value <> FFocused then
  begin
    FFocused := Value;
    Invalidate;
  end;
end;

procedure TAdvSpeedButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FHot := True;
  Invalidate;
end;

procedure TAdvSpeedButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FHot := False;
  Invalidate;
end;


procedure TAdvSpeedButton.Paint;
const
  Flags: array[Boolean] of Integer = (0, BF_FLAT);
  Edge: array[Boolean] of Integer = (EDGE_RAISED,EDGE_ETCHED);

var
  r: TRect;
  BtnFaceBrush: HBRUSH;
  HTheme: THandle;
begin
  if DoVisualStyles then
  begin
    r := BoundsRect;
    FillRect(Canvas.Handle,r,Canvas.Brush.Handle);

    r := Rect(0, 0, Width + 1, Height + 1);

    HTheme := OpenThemeData(Parent.Handle,'button');

    if FState in [bsDown, bsExclusive] then
      DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_PRESSED,@r,nil)
    else
      if FHot then
        DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_HOT,@r,nil)
      else
        DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_NORMAL,@r,nil);

    CloseThemeData(HTheme);

    r := ClientRect;

    if Assigned(Glyph) then
    begin
      if not Glyph.Empty then
      begin
        InflateRect(r,-2,-2);

        if Glyph.Width < r.Right - r.Left then
          r.Left := r.Left + (r.Right - r.Left - Glyph.Width) shr 1;

        if Glyph.Height < r.Bottom - r.Top then
          r.Top := r.Top + (r.Bottom - r.Top - Glyph.Height) shr 1;

        if FState = bsdown then OffsetRect(r,1,1);


        DrawBitmapTransp(canvas,glyph,ColorToRGB(clBtnFace),r);
      end;
    end;

    if (Caption<>'') then
    begin
      Inflaterect(r,-3,-1);
      if FState = bsdown then Offsetrect(r,1,1);
      Windows.setbkmode(canvas.handle,windows.TRANSPARENT);
      DrawText(canvas.handle,pchar(Caption),length(Caption),r,DT_CENTER);
    end;

  end
  else
  begin
  if not Flat then inherited Paint else
  begin
    r := BoundsRect;
    FillRect(Canvas.Handle,r,Canvas.Brush.Handle);

    BtnFaceBrush := CreateSolidBrush(GetSysColor(COLOR_BTNFACE));

    FillRect(Canvas.Handle, r, BtnFaceBrush);

    DeleteObject(BtnFaceBrush);

    r.Bottom := r.Bottom + 1;
    r.Right := r.Right + 1;
    DrawEdge(Canvas.Handle, r, Edge[fEtched], BF_RECT or flags[fState=bsDown]);

    r := ClientRect;

    if Assigned(Glyph) then
    begin
      if not Glyph.Empty then
      begin
        InflateRect(r,-3,-3);
        if fstate = bsdown then offsetrect(r,1,1);
        DrawBitmapTransp(canvas,glyph,ColorToRGB(clBtnFace),r);
      end;
    end;

    if (Caption <> '') then
    begin
      Inflaterect(r,-3,-1);
      if FState = bsdown then Offsetrect(r,1,1);
      Windows.SetBKMode(canvas.handle,windows.TRANSPARENT);
      DrawText(canvas.handle,pchar(Caption),length(Caption),r,DT_CENTER);
    end;
  end;
  end;
end;

function TAdvSpeedButton.DoVisualStyles: Boolean;
begin
  if FIsWinXP then
    Result := IsThemeActive 
  else
    Result := False;
end;

constructor TAdvSpeedButton.Create(AOwner: TComponent);
var
  dwVersion:Dword;
  dwWindowsMajorVersion,dwWindowsMinorVersion:Dword;
begin
  inherited;
  dwVersion := GetVersion;
  dwWindowsMajorVersion :=  DWORD(LOBYTE(LOWORD(dwVersion)));
  dwWindowsMinorVersion :=  DWORD(HIBYTE(LOWORD(dwVersion)));

  FIsWinXP := (dwWindowsMajorVersion > 5) OR
    ((dwWindowsMajorVersion = 5) AND (dwWindowsMinorVersion >= 1));
end;

{ TEditButton }
constructor TEditButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] +
    [csFramed, csOpaque];
  FButton := CreateButton;
  Glyph := nil;
  Width := 16;
  Height := 25;
  FBWidth := 16;
end;

function TEditButton.CreateButton: TAdvSpeedButton;
begin
  Result := TAdvSpeedButton.Create(Self);
  Result.OnClick := BtnClick;
  Result.OnMouseUp := BtnMouseDown;
  Result.Visible := True;
  Result.Enabled := True;
  Result.Parent := Self;
  Result.Caption:='';
end;

procedure TEditButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

procedure TEditButton.AdjustWinSize (var W: Integer; var H: Integer);
begin
  if (FButton = nil) or (csLoading in ComponentState) then Exit;
  W := FBWidth;
  FButton.SetBounds (0, 0, W, H);
end;

procedure TEditButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustWinSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TEditButton.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  { check for minimum size }
  W := Width;
  H := Height;
  AdjustWinSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds(Left, Top, W, H);
  Message.Result := 0;
end;

procedure TEditButton.BtnMouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if (Sender = FButton) then FOnClick(Self);

    if (FFocusControl <> nil) and FFocusControl.TabStop and
        FFocusControl.CanFocus and (GetFocus <> FFocusControl.Handle) then
      FFocusControl.SetFocus
    else if TabStop and (GetFocus <> Handle) and CanFocus then
      SetFocus;
  end;
end;

procedure TEditButton.BtnClick(Sender: TObject);
begin
 {
 if (Sender=FButton) then FOnClick(Self);
 }
end;

procedure TEditButton.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  AdjustWinSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
end;

function TEditButton.GetGlyph: TBitmap;
begin
  Result := FButton.Glyph;
end;

procedure TEditButton.SetGlyph(Value: TBitmap);
begin
  FButton.Glyph := Value;
end;

procedure TEditButton.SetCaption(value:string);
begin
  FButton.Caption := Value;
end;

function TEditButton.GetCaption:string;
begin
  Result := FButton.Caption;
end;

function TEditButton.GetNumGlyphs: TNumGlyphs;
begin
  Result := FButton.NumGlyphs;
end;

procedure TEditButton.SetNumGlyphs(Value: TNumGlyphs);
begin
  FButton.NumGlyphs := Value;
end;

{ TSpinEdit }

constructor TAdvEditBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButton := TEditButton.Create (Self);
  FButton.Width := 15;
  FButton.Height := 17;
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.FocusControl := Self;
  FButton.OnClick := BtnClick;
  Text := '';
  ControlStyle := ControlStyle - [csSetCaption];
  FEditorEnabled := True;
  FUnitSize := 0;
  IndentR := 18;
end;

destructor TAdvEditBtn.Destroy;
begin
  FButton := nil;
  inherited Destroy;
end;

procedure TAdvEditBtn.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style OR (ES_MULTILINE);
end;

procedure TAdvEditBtn.CreateWnd;
begin
  inherited CreateWnd;
  Width := Width - 1;
  Width := Width + 1;
end;

procedure TAdvEditBtn.Loaded;
begin
  inherited Loaded;
  SetEditRect;
end;

procedure TAdvEditBtn.SetGlyph(value:TBitmap);
begin
  FButton.Glyph := Value;
end;

function TAdvEditBtn.GetGlyph:TBitmap;
begin
  Result := FButton.Glyph;
end;

procedure TAdvEditBtn.SetCaption(value:string);
begin
  FButton.ButtonCaption := value;
end;

function TAdvEditBtn.GetCaption:string;
begin
  Result := FButton.ButtonCaption;
end;

procedure TAdvEditBtn.SetEditRect;
var
  Loc: TRect;
begin
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := ClientWidth - FButton.Width - 4 - FUnitsize;
  if (BorderStyle = bsNone) then
  begin
    Loc.Top := 4;
    Loc.Left := 2;
  end
  else
  begin
    Loc.Top := 1;
    Loc.Left := 1;
  end;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
end;

procedure TAdvEditBtn.ResizeControl;
var
  MinHeight: Integer;
  Dist,FlatCorr: Integer;
begin
  if (BorderStyle = bsNone) then
    Dist := 2
  else
    Dist := 4;

  if FFlat then
    Dist := 3;

  if FFlat then
    FlatCorr := 1
  else
    FlatCorr := -1;

  MinHeight := GetMinHeight;

  { text edit bug: if size to less than minheight, then edit ctrl does
    not display the text }

  if (Height<MinHeight) then
    Height:=MinHeight
  else
  if (FButton <> nil) then
   begin
    if NewStyleControls and Ctl3D then
      FButton.SetBounds(Width - FButton.FBWidth - Dist,1 + FlatCorr,FButton.FBWidth,Height - Dist - 1)
    else
      FButton.SetBounds (Width - FButton.FBWidth,1,FButton.FBWidth,Height - 3);
    SetEditRect;
   end;

  Invalidate;
end;

procedure TAdvEditBtn.WMSize(var Message: TWMSize);
begin
  inherited;
  ResizeControl;
end;

function TAdvEditBtn.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  I := SysMetrics.tmHeight;
  if I > Metrics.tmHeight then I := Metrics.tmHeight;
  {Result := Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4 +2;}
  Result := Metrics.tmHeight + I div 4 {+ GetSystemMetrics(SM_CYBORDER) * 4};
end;

procedure TAdvEditBtn.BtnClick (Sender: TObject);
begin
  if Assigned(FOnClickBtn) then
    FOnClickBtn(Self);
end;

procedure TAdvEditBtn.WMPaste(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TAdvEditBtn.WMCut(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TAdvEditBtn.CMExit(var Message: TCMExit);
begin
  inherited;
  DrawBorders;
end;

procedure TAdvEditBtn.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll;
  inherited;
  DrawBorders;
end;

procedure TAdvEditBtn.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if not FMouseInControl and Enabled then
  begin
    FMouseInControl := True;
    DrawBorders;
  end;
end;

procedure TAdvEditBtn.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled then
  begin
    FMouseInControl:=False;
    DrawBorders;
  end;
end;

procedure TAdvEditBtn.SetFlat(const Value: boolean);
begin
  if (FFlat <> value) then
  begin
    FFlat := Value;
    FButton.FButton.Flat := FFlat;
    inherited Flat := Value;
    // cause a proper repaint of full control
    Width := Width + 1;
    Width := Width - 1;
  end;
end;

procedure TAdvEditBtn.SetEtched(const Value: boolean);
begin
  if FEtched <> value then
  begin
    FEtched := Value;
    FButton.FButton.Etched:=value;
    Invalidate;
  end;
end;

function TAdvEditBtn.Is3DBorderControl: Boolean;
begin
  if csDesigning in ComponentState then
    Result := False
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);
//  Result := Result and FFocusBorder;
end;

function TAdvEditBtn.Is3DBorderButton: Boolean;
begin
  if csDesigning in ComponentState then
    Result := Enabled
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);
end;

procedure TAdvEditBtn.DoEnter;
begin
  inherited;
  SetEditRect;
end;


procedure TAdvEditBtn.DrawControlBorder(DC: HDC);
var
  ARect:TRect;
  BtnFaceBrush, WindowBrush: HBRUSH;
begin
  if Is3DBorderControl then
    BtnFaceBrush := CreateSolidBrush(GetSysColor(COLOR_BTNFACE))
  else
    BtnFaceBrush := CreateSolidBrush(ColorToRGB((parent as TWinControl).brush.color));

  WindowBrush := CreateSolidBrush(GetSysColor(COLOR_WINDOW));

  try
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);
    if Is3DBorderControl then
    begin
      DrawEdge(DC, ARect, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
    end
    else
    begin
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
    end;
  finally
    DeleteObject(WindowBrush);
    DeleteObject(BtnFaceBrush);
  end;
end;


procedure TAdvEditBtn.DrawButtonBorder;
begin
  FButton.FButton.Focused := Is3DBorderButton;
end;

procedure TAdvEditBtn.DrawBorders;
var
  DC: HDC;
begin
  if not FFlat then Exit;
  DC := GetWindowDC(Handle);
  try
    if (1<0) then DrawControlBorder(DC);

    DrawButtonBorder;
  finally
    ReleaseDC(DC, Handle);
  end;
end;

procedure TAdvEditBtn.WMPaint(var Msg: TWMPAINT);
begin
  inherited;
//  DrawBorders;
end;

procedure TAdvEditBtn.WMNCPaint(var Message: TMessage);
begin
  inherited;
//  DrawBorders;
end;

procedure TAdvEditBtn.CMFontChanged(var Message: TMessage);
begin
  inherited;
  SetEditRect;
end;

procedure TAdvEditBtn.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = vk_F4) and
     (GetKeyState(vk_control) and $8000 = 0) and
     (GetKeyState(vk_lmenu) and $8000 = 0) and
     (GetKeyState(vk_rmenu) and $8000 = 0) then
   if Assigned(OnClickBtn) then
     OnClickBtn(self);
end;

function TAdvEditBtn.GetButtonWidth: integer;
begin
 if Assigned(FButton) then
   Result := FButton.FBWidth
 else
   Result := 16;
end;

procedure TAdvEditBtn.SetButtonWidth(const Value: integer);
begin
  if Assigned(FButton) then
  begin
    FButton.FBWidth := Value;
    if FButton.HandleAllocated then
      ResizeControl;
  end;
end;

procedure TAdvEditBtn.SetButtonHint(const Value: string);
begin
  if FButtonHint <> Value then
  begin
    FButtonHint := Value;
    FButton.Hint := Value;
    FButton.ShowHint := Value <> '';
  end;
end;



{ TUnitAdvEditBtn }
procedure TUnitAdvEditBtn.BtnClick(Sender: TObject);
var
  popmenu: THandle;
  pt: TPoint;
  i: Integer;
begin
  pt := ClientToScreen(point(0,0));
  popmenu := CreatePopupMenu;

  for i := 1 to FUnits.Count do
    InsertMenu(popmenu,$FFFFFFFF,MF_BYPOSITION ,i,PChar(FUnits.Strings[i-1]));

  TrackPopupMenu(popmenu,TPM_LEFTALIGN or TPM_LEFTBUTTON,pt.x+ClientWidth-15,pt.y+ClientHeight,0,self.handle,nil);

  Destroymenu(popmenu);
  if Assigned(FOnClickBtn) then
    FOnClickBtn(Sender);
end;

constructor TUnitAdvEditBtn.Create(AOwner: TComponent);
begin
  inherited Create(aOwner);
  FUnitSize := 20;
  FUnits := TStringList.Create;
end;

destructor TUnitAdvEditBtn.Destroy;
begin
  FUnits.Free;
  inherited Destroy;
end;

procedure TUnitAdvEditBtn.SetUnitID(value: string);
begin
  FUnitID := value;
  Repaint;
end;

procedure TUnitAdvEditBtn.SetUnits(value: TStringList);
begin
  if Assigned(Value) then
    FUnits.Assign(Value);
end;

function TUnitAdvEditBtn.GetUnitSize: Integer;
begin
  Result := FUnitSize;
end;

procedure TUnitAdvEditBtn.SetUnitSize(value: Integer);
begin
  FUnitSize := Value;
  SetEditRect;
  Repaint;
end;

procedure TUnitAdvEditBtn.WMCommand(var Message: TWMCommand);
begin
  UnitID:=fUnits.Strings[message.itemID-1];
  if Assigned(OnUnitChanged) then
    OnUnitChanged(Self,UnitID);
end;

procedure TUnitAdvEditBtn.WMPaint(var Msg: TWMPAINT);
var
  hdc:THandle;
  oldfont:THandle;
  r:trect;
begin
  inherited;
  hdc := GetDC(Handle);
  r.left := ClientWidth - FButton.Width - 3 - FUnitsize;
  r.right := r.left + FUnitSize;
  r.top := 2;
  r.bottom := ClientHeight;
  oldfont := selectobject(hdc,self.Font.handle);
  DrawText(HDC,PChar(FUnitID),Length(FUnitID),r,DT_LEFT or DT_EDITCONTROL);
  SelectObject(hdc,oldfont);
  ReleaseDC(self.handle,hdc);
end;





end.

