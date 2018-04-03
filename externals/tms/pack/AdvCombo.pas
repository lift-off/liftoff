{**********************************************************************}
{ TAdvComboBox component                                               }
{ for Delphi & C++Builder                                              }
{ version 1.1                                                          }
{                                                                      }
{ written by                                                           }
{  TMS Software                                                        }
{  copyright © 1996-2002                                               }
{  Email : info@tmssoftware.com                                        }
{  Web : http://www.tmssoftware.com                                    }
{                                                                      }
{ The source code is given as is. The author is not responsible        }
{ for any possible damage done due to the use of this code.            }
{ The component can be freely used in any application. The source      }
{ code remains property of the author and may not be distributed       }
{ freely as such.                                                      }
{**********************************************************************}

unit AdvCombo;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, Classes, Forms, Controls, Graphics, StdCtrls,
  SysUtils, ACXPVS;

type
  TWinCtrl = class(TWinControl);

  TLabelPosition = (lpLeftTop,lpLeftCenter,lpLeftBottom,lpTopLeft,lpBottomLeft,
                    lpLeftTopLeft,lpLeftCenterLeft,lpLeftBottomLeft,lpTopCenter,
                    lpBottomCenter);

  TAdvCustomCombo = class(TCustomComboBox)
  private
    FAutoFocus: boolean;
    FFlat: Boolean;
    FEtched: Boolean;
    FOldColor: TColor;
    FLoadedColor: TColor;
    FOldParentColor: Boolean;
    FButtonWidth: Integer;
    FFocusBorder: Boolean;
    FMouseInControl: Boolean;
    FDropWidth: integer;
    FIsWinXP: Boolean;
    FButtonHover: Boolean;
    FLabelAlwaysEnabled: Boolean;
    FLabelTransparent: Boolean;
    FLabelMargin: Integer;
    FLabelFont: TFont;
    FLabelPosition: TLabelPosition;
    FLabel: TLabel;
    FFlatLineColor: TColor;
    FFlatParentColor: Boolean;
    procedure SetEtched(const Value: Boolean);
    procedure SetFlat(const Value: Boolean);
    procedure SetButtonWidth(const Value: Integer);
    procedure DrawButtonBorder(DC:HDC);
    procedure DrawControlBorder(DC:HDC);
    procedure DrawBorders;
    function  Is3DBorderControl: Boolean;
    function  Is3DBorderButton: Boolean;

    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CNCommand (var Message: TWMCommand); message CN_COMMAND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure SetDropWidth(const Value: integer);
    function GetLabelCaption: string;
    procedure SetLabelAlwaysEnabled(const Value: Boolean);
    procedure SetLabelCaption(const Value: string);
    procedure SetLabelFont(const Value: TFont);
    procedure SetLabelMargin(const Value: Integer);
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelTransparent(const Value: Boolean);
    procedure UpdateLabel;
    procedure LabelFontChange(Sender: TObject);
    procedure SetFlatLineColor(const Value: TColor);
    procedure SetFlatParentColor(const Value: Boolean);
    function GetColorEx: TColor;
    procedure SetColorEx(const Value: TColor);
  protected
    function DoVisualStyles: Boolean;
    function CreateLabel: TLabel;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    property ButtonWidth: integer read fButtonWidth write SetButtonWidth;
    property Flat: Boolean read FFlat write SetFlat;
    property FlatLineColor: TColor read FFlatLineColor write SetFlatLineColor;
    property FlatParentColor: Boolean read FFlatParentColor write SetFlatParentColor;
    property Etched: Boolean read FEtched write SetEtched;
    property FocusBorder: Boolean read FFocusBorder write FFocusBorder;
    property AutoFocus: Boolean read FAutoFocus write FAutoFocus;
    property DropWidth: integer read FDropWidth write SetDropWidth;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;    
    property LabelCaption:string read GetLabelCaption write SetLabelCaption;
    property LabelPosition:TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelMargin: Integer read FLabelMargin write SetLabelMargin;
    property LabelTransparent: Boolean read FLabelTransparent write SetLabelTransparent;
    property LabelAlwaysEnabled: Boolean read FLabelAlwaysEnabled write SetLabelAlwaysEnabled;
    property LabelFont:TFont read FLabelFont write SetLabelFont;
  published
    property Color: TColor read GetColorEx write SetColorEx;  
  end;

  TAdvComboBox = class(TAdvCustomCombo)
  published
    property AutoFocus;
    property ButtonWidth;
    property Style;
    property Flat;
    property FlatLineColor;
    property FlatParentColor;
    property Etched;
    property FocusBorder;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property DropWidth;
    property Enabled;
    property Font;
    {$IFNDEF DELPHI2_LVL}
    property ImeMode;
    property ImeName;
    {$ENDIF}
    property ItemHeight;
    property Items;
    property LabelCaption;
    property LabelPosition;
    property LabelMargin;
    property LabelTransparent;
    property LabelAlwaysEnabled;
    property LabelFont;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF}
  end;


implementation

{ TAdvCustomCombo }
constructor TAdvCustomCombo.Create(AOwner: TComponent);
var
  dwVersion:Dword;
  dwWindowsMajorVersion,dwWindowsMinorVersion:Dword;

begin
  inherited;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL) + 2;
//  FOldColor := inherited Color;
//  FOldParentColor := inherited ParentColor;
  FFlat := True;
  FMouseInControl := False;

  dwVersion := GetVersion;
  dwWindowsMajorVersion :=  DWORD(LOBYTE(LOWORD(dwVersion)));
  dwWindowsMinorVersion :=  DWORD(HIBYTE(LOWORD(dwVersion)));

  FIsWinXP := (dwWindowsMajorVersion > 5) OR
    ((dwWindowsMajorVersion = 5) AND (dwWindowsMinorVersion >= 1));
  FButtonHover := False;
  FLabel := nil;
  FLabelFont := TFont.Create;
  FLabelFont.OnChange := LabelFontChange;
  FLabelMargin := 4;
  FFlatLineColor := clBlack;
  FFlatParentColor := True;
  FLoadedColor := clWindow;
end;

procedure TAdvCustomCombo.SetButtonWidth(const Value: integer);
begin
  if (value<14) or (value>32) then
    Exit;

  FButtonWidth := Value;
  Invalidate;
end;

procedure TAdvCustomCombo.SetFlat(const Value: Boolean);
begin
  if Value <> FFlat then
  begin
    FFlat := Value;
    Ctl3D := not Value;
    if FFlatParentColor and FFlat then
    begin
      if (Parent is TWinControl) then
        inherited Color := (Parent as TWinControl).Brush.Color;
    end
    else
      inherited Color := FLoadedColor;

    Invalidate;
  end;
end;

procedure TAdvCustomCombo.SetEtched(const Value: Boolean);
begin
  if Value <> FEtched then
  begin
    FEtched := Value;
    Invalidate;
  end;
end;

procedure TAdvCustomCombo.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if not (csDesigning in ComponentState) then DrawBorders;
end;

procedure TAdvCustomCombo.CMExit(var Message: TCMExit);
begin
  inherited;
  if not (csDesigning in ComponentState) then DrawBorders;
end;

procedure TAdvCustomCombo.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if not FMouseInControl and Enabled then
    begin
     FMouseInControl := True;
     DrawBorders;
    end;
  if FAutoFocus then
    SetFocus;
  if FIsWinXP then
    Invalidate;
end;

procedure TAdvCustomCombo.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled then
    begin
     FMouseInControl := False;
     DrawBorders;
    end;
  if FIsWinXP then
  begin
    FButtonHover := False;
    Invalidate;
  end;
end;

procedure TAdvCustomCombo.CMEnabledChanged(var Msg: TMessage);
begin
  if FFlat then
  begin
    if not (csLoading in ComponentState) then
    begin
      if Enabled then
      begin
        inherited ParentColor := FOldParentColor;
        inherited Color := FOldColor;
      end
      else
      begin
        FOldParentColor := inherited Parentcolor;
        FOldColor := inherited Color;
        inherited ParentColor := True;
      end;
    end;
  end;
  inherited;
end;

procedure TAdvCustomCombo.WMNCPaint(var Message: TMessage);
begin
  inherited;
  if FFlat then DrawBorders;
end;

function IsMouseButtonDown:Boolean;
{
  Returns a "True" if a Mouse button happens to be down.
}
begin
  {Note: Key state is read twice because the first time you read it,
   you learn if the bittpm has been pressed ever.
   The second time you read it you learn if
   the button is currently pressed.}
  Result := not(((GetAsyncKeyState(VK_RBUTTON)and $8000)=0) and
     ((GetAsyncKeyState(VK_LBUTTON)and $8000)=0));
     (*
  begin
    {Mouse buttons are up}
    Result := False;
  end
  else
  begin
    {Mouse buttons are up}
    Result:=True;
  end;
  *)
end;


procedure TAdvCustomCombo.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  PS: TPaintStruct;

  procedure DrawButton;
  var
    ARect: TRect;
    htheme: THandle;
  begin
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);
    Inc(ARect.Left, ClientWidth - FButtonWidth);
    InflateRect(ARect, -1, -1);

    if DoVisualStyles then
    begin
      htheme := OpenThemeData(Handle,'combobox');
      if IsMouseButtonDown and DroppedDown then
        DrawThemeBackground(htheme,DC,CP_DROPDOWNBUTTON,CBXS_PRESSED,@ARect,nil)
      else
      begin
        if not IsMouseButtonDown and FButtonHover and not DroppedDown then
          DrawThemeBackground(htheme,DC,CP_DROPDOWNBUTTON,CBXS_HOT,@ARect,nil)
        else

        DrawThemeBackground(htheme,DC,CP_DROPDOWNBUTTON,CBXS_NORMAL,@ARect,nil);
      end;

      CloseThemeData(htheme);
    end
    else
      DrawFrameControl(DC, ARect, DFC_SCROLL, DFCS_SCROLLCOMBOBOX or DFCS_FLAT );

    ExcludeClipRect(DC, ClientWidth - FButtonWidth -4 , 0, ClientWidth +2, ClientHeight);
  end;


begin
  if not FFlat then
  begin
    inherited;
    Exit;
  end;

  if Message.DC = 0 then
    DC := BeginPaint(Handle, PS)
  else
    DC := Message.DC;
  try
    if (Style <> csSimple) then
    begin
      FillRect(DC, ClientRect, Brush.Handle);
      DrawButton;

    end;

    PaintWindow(DC);


  finally
    if Message.DC = 0 then
      EndPaint(Handle, PS);
  end;

  DrawBorders;
  
end;

function TAdvCustomCombo.Is3DBorderControl: Boolean;
begin
  if csDesigning in ComponentState then
    Result:=false
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);

  result := result and FFocusBorder;
end;

function TAdvCustomCombo.Is3DBorderButton: Boolean;
begin
  if csDesigning in ComponentState then
    Result:=Enabled
  else
    Result:=FMouseInControl or (Screen.ActiveControl = Self);
end;

procedure TAdvCustomCombo.DrawButtonBorder(DC: HDC);
const
   Flags: array[Boolean] of Integer = (0, BF_FLAT);
   Edge: array[Boolean] of Integer = (EDGE_RAISED,EDGE_ETCHED);
var
   ARect: TRect;
   BtnFaceBrush: HBRUSH;
begin

  ExcludeClipRect(DC, ClientWidth - FButtonWidth + 4, 4, ClientWidth - 4, ClientHeight - 4);

  GetWindowRect(Handle, ARect);
  OffsetRect(ARect, -ARect.Left, -ARect.Top);
  Inc(ARect.Left, ClientWidth - FButtonWidth - 2);
  InflateRect(ARect, -2, -2);

  if Is3DBorderButton then
   DrawEdge(DC, ARect, Edge[Etched], BF_RECT or Flags[DroppedDown])
  else
    begin
     BtnFaceBrush:=CreateSolidBrush(GetSysColor(COLOR_BTNFACE));
     InflateRect(ARect, 0, -1);
     arect.right:=arect.right-1;
     FillRect(DC, ARect, BtnFaceBrush);
     DeleteObject(BtnFaceBrush);
    end;

  ExcludeClipRect(DC, ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
end;

procedure TAdvCustomCombo.DrawControlBorder(DC: HDC);
var
  ARect:TRect;
  BtnFaceBrush, WindowBrush: HBRUSH;
  OldPen: HPen;
begin
  if Is3DBorderControl then
    BtnFaceBrush := CreateSolidBrush(GetSysColor(COLOR_BTNFACE))
  else
    BtnFaceBrush := CreateSolidBrush(ColorToRGB((Parent as TWinControl).Brush.Color));

  //WindowBrush:=CreateSolidBrush(GetSysColor(COLOR_WINDOW));
  WindowBrush := CreateSolidBrush(ColorToRGB(self.Color));

  try
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);
    if Is3DBorderControl then
    begin
      DrawEdge(DC, ARect, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, WindowBrush);
    end
    else
    begin
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, WindowBrush);
    end;

    if FFlat and (FFlatLineColor <> clNone) then
    begin
      OldPen := SelectObject(DC,CreatePen( PS_SOLID,1,ColorToRGB(FFlatLineColor)));
      MovetoEx(DC,ARect.Left - 2,Height - 1,nil);
      LineTo(DC,ARect.Right - 18 ,Height - 1);
      DeleteObject(SelectObject(DC,OldPen));
    end;

  finally
    DeleteObject(WindowBrush);
    DeleteObject(BtnFaceBrush);
  end;
end;

procedure TAdvCustomCombo.DrawBorders;
var
  DC: HDC;
begin
  if not FFlat then
    Exit;

  DC := GetWindowDC(Handle);
  try
    DrawControlBorder(DC);
    if (Style <> csSimple) and not
       (FIsWinXP and DoVisualStyles) then DrawButtonBorder(DC);

  finally
    ReleaseDC(Handle,DC);
  end;
end;

procedure TAdvCustomCombo.CNCommand(var Message: TWMCommand);
var
  r:TRect;
begin
  inherited;

  if (Message.NotifyCode in [CBN_CLOSEUP,CBN_DROPDOWN]) then
  begin
    r := GetClientRect;
    r.Left := r.Right - Fbuttonwidth;
    InvalidateRect(Handle,@r,FALSE);
  end;
end;


procedure TAdvCustomCombo.SetDropWidth(const Value: integer);
begin
  FDropWidth := Value;
  if Value > 0 then
    SendMessage(self.Handle,CB_SETDROPPEDWIDTH,FDropWidth,0);
end;

function TAdvCustomCombo.DoVisualStyles: Boolean;
begin
  if FIsWinXP then
    Result := IsThemeActive
  else
    Result := False;
end;

procedure TAdvCustomCombo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (X > Width - FButtonWidth) and (X < Width) then
  begin
    if not FButtonHover then
    begin
      FButtonHover := True;
      Invalidate;
    end;
  end
  else
  begin
    if FButtonHover then
    begin
      FButtonHover := False;
      Invalidate;
    end;
  end;

end;

function TAdvCustomCombo.GetLabelCaption: string;
begin
  if FLabel <> nil then
    Result := FLabel.Caption
  else
    Result := '';
end;

procedure TAdvCustomCombo.SetLabelAlwaysEnabled(const Value: Boolean);
begin
  FLabelAlwaysEnabled := Value;
  if FLabel <> nil then UpdateLabel;  
end;

procedure TAdvCustomCombo.SetLabelCaption(const Value: string);
begin
  if FLabel = nil then
     FLabel := CreateLabel;
  FLabel.Caption := Value;
  UpdateLabel;
end;

procedure TAdvCustomCombo.SetLabelFont(const Value: TFont);
begin
  FLabelFont.Assign(Value);
end;

procedure TAdvCustomCombo.SetLabelMargin(const Value: Integer);
begin
  FLabelMargin := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvCustomCombo.SetLabelPosition(const Value: TLabelPosition);
begin
  FLabelPosition := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvCustomCombo.SetLabelTransparent(const Value: Boolean);
begin
  FLabelTransparent := Value;
  if FLabel <> nil then UpdateLabel;
end;

destructor TAdvCustomCombo.Destroy;
begin
  FlabelFont.Destroy;
  if FLabel <> nil then
    FLabel.Free;
  inherited;
end;

function TAdvCustomCombo.CreateLabel: TLabel;
begin
  Result := Tlabel.Create(self);
  Result.Parent:=self.parent;
  Result.FocusControl:=self;
  Result.Font.Assign(LabelFont);
end;


procedure TAdvCustomCombo.UpdateLabel;
begin
  FLabel.Transparent := FLabeltransparent;
  case FLabelPosition of
  lpLeftTop:
    begin
      FLabel.top := self.top;
      FLabel.left := self.left-FLabel.canvas.textwidth(FLabel.caption)-FLabelMargin;
    end;
  lpLeftCenter:
    begin
      FLabel.top := self.top+((self.height-FLabel.height) shr 1);
      FLabel.left := self.left-FLabel.canvas.textwidth(FLabel.caption)-FLabelMargin;
    end;
  lpLeftBottom:
    begin
      FLabel.top := self.top+self.height-FLabel.height;
      FLabel.left := self.left-FLabel.canvas.textwidth(FLabel.caption)-FLabelMargin;
    end;
  lpTopLeft:
    begin
      FLabel.top := self.top-FLabel.height-FLabelMargin;
      FLabel.left := self.left;
    end;
  lpTopCenter:
    begin
      FLabel.Top := self.top-FLabel.height-FLabelMargin;
      FLabeL.Left := self.Left + ((self.Width-FLabel.width) shr 1);
    end;
  lpBottomLeft:
    begin
      FLabel.top := self.top+self.height+FLabelMargin;
      FLabel.left := self.left;
    end;
  lpBottomCenter:
    begin
      FLabel.top := self.top+self.height+FLabelMargin;
      FLabeL.Left := self.Left + ((self.Width-FLabel.width) shr 1);
    end;
  lpLeftTopLeft:
    begin
      FLabel.top := self.top;
      FLabel.left := self.left-FLabelMargin;
    end;
  lpLeftCenterLeft:
    begin
      FLabel.top := self.top+((self.height-FLabel.height) shr 1);
      FLabel.left := self.left-FLabelMargin;
    end;
  lpLeftBottomLeft:
    begin
      FLabel.top:=self.top+self.height-FLabel.height;
      FLabel.left:=self.left-FLabelMargin;
    end;
  end;
  FLabel.Font.Assign(FLabelFont);
  FLabel.Visible := Visible;
end;

procedure TAdvCustomCombo.LabelFontChange(Sender: TObject);
begin
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvCustomCombo.Loaded;
begin
  inherited;
  if FLabel <> nil then
    UpdateLabel;
  if FDropWidth > 0 then
    DropWidth := FDropWidth;
  FOldColor := FLoadedColor;
  if not FlatParentColor or Flat then
    Color := FLoadedColor;
end;

procedure TAdvCustomCombo.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if FLabel <> nil then
    UpdateLabel;
end;

procedure TAdvCustomCombo.SetFlatLineColor(const Value: TColor);
begin
  FFlatLineColor := Value;
  Invalidate;
end;

procedure TAdvCustomCombo.SetFlatParentColor(const Value: Boolean);
begin
  FFlatParentColor := Value;
  Invalidate;
end;

function TAdvCustomCombo.GetColorEx: TColor;
begin
  Result := inherited Color;
end;

procedure TAdvCustomCombo.SetColorEx(const Value: TColor);
begin
  if (csLoading in ComponentState) then
    FLoadedColor := Value;

  inherited Color := Value;
end;

end.

