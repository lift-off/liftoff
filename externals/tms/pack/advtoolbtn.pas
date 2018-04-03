{*************************************************************************}
{ TADVTOOLBUTON component                                                 }
{ for Delphi & C++Builder                                                 }
{ version 1.1                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright ©  2003                                             }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit AdvToolBtn;

interface

uses
  Classes, Windows, Graphics, Buttons, Controls, Messages, Forms, Dialogs;

type

  TAdvToolButton = class(TGraphicControl)
  private
    FGroupIndex: Integer;
    FGlyph: TBitmap;
    FDown: Boolean;
    FDragging: Boolean;
    FAllowAllUp: Boolean;
    FLayout: TButtonLayout;
    FSpacing: Integer;
    FTransparent: Boolean;
    FMargin: Integer;
    FFlat: Boolean;
    FMouseInControl: Boolean;
    FColorHot: TColor;
    FColorDown: TColor;
    FGlyphDisabled: TBitmap;
    FGlyphHot: TBitmap;
    FGlyphDown: TBitmap;
    FGlyphShade: TBitmap;
    FShaded: Boolean;
    procedure GlyphChanged(Sender: TObject);
    procedure UpdateExclusive;
    procedure SetGlyph(Value: TBitmap);
    procedure SetDown(Value: Boolean);
    procedure SetFlat(Value: Boolean);
    procedure SetAllowAllUp(Value: Boolean);
    procedure SetGroupIndex(Value: Integer);
    procedure SetLayout(Value: TButtonLayout);
    procedure SetSpacing(Value: Integer);
    procedure SetMargin(Value: Integer);
    procedure UpdateTracking;
    procedure WMLButtonDblClk(var Message: TWMLButtonDown); message WM_LBUTTONDBLCLK;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetGlyphDisabled(const Value: TBitmap);
    procedure SetGlyphDown(const Value: TBitmap);
    procedure SetGlyphHot(const Value: TBitmap);
    procedure GenerateShade;
    procedure SetShaded(const Value: Boolean);
  protected
    FState: TButtonState;
    {$IFDEF DELPHI6_LVL}
    function GetActionLinkClass: TControlActionLinkClass; override;
    {$ENDIF}
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DrawButtonGlyph(Canvas: TCanvas; const GlyphPos: TPoint;
      State: TButtonState; Transparent: Boolean);
    procedure DrawButtonText(Canvas: TCanvas; const Caption: string;
      TextBounds: TRect; State: TButtonState; BiDiFlags: LongInt);
    function DrawButton(Canvas: TCanvas; const Client: TRect;
      const Offset: TPoint; const Caption: string; Layout: TButtonLayout;
      Margin, Spacing: Integer; State: TButtonState; Transparent: Boolean;
      BiDiFlags: LongInt): TRect;
    procedure CalcButtonLayout(Canvas: TCanvas; const Client: TRect;
      const Offset: TPoint; const Caption: string; Layout: TButtonLayout; Margin,
      Spacing: Integer; var GlyphPos: TPoint; var TextBounds: TRect;
      BiDiFlags: LongInt);
    procedure Paint; override;
    property MouseInControl: Boolean read FMouseInControl;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property Action;
    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default False;
    property Anchors;
    property BiDiMode;
    property Color;
    property ColorDown: TColor read FColorDown write FColorDown;
    property ColorHot: TColor read FColorHot write FColorHot;
    property Constraints;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property Down: Boolean read FDown write SetDown default False;
    property Caption;
    property Enabled;
    property Flat: Boolean read FFlat write SetFlat default False;
    property Font;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property GlyphHot: TBitmap read FGlyphHot write SetGlyphHot;
    property GlyphDown: TBitmap read FGlyphDown write SetGlyphDown;
    property GlyphDisabled: TBitmap read FGlyphDisabled write SetGlyphDisabled;
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property Margin: Integer read FMargin write SetMargin default -1;
    property ParentFont;
    property ParentShowHint;
    property ParentBiDiMode;
    property PopupMenu;
    property Shaded: Boolean read FShaded write SetShaded default True;
    property ShowHint;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


implementation

uses
  ActnList, SysUtils, ImgList;

constructor TAdvToolButton.Create(AOwner: TComponent);
begin
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := GlyphChanged;
  FGlyphHot := TBitmap.Create;
  FGlyphDown := TBitmap.Create;
  FGlyphDisabled := TBitmap.Create;
  FGlyphShade := TBitmap.Create;

  inherited Create(AOwner);
  SetBounds(0, 0, 23, 22);
  ControlStyle := [csCaptureMouse, csDoubleClicks];
  ParentFont := True;
  Color := clBtnFace;
  ColorHot := RGB(199,199,202);
  ColorDown := RGB(210,211,216);
  FSpacing := 4;
  FMargin := -1;
  FLayout := blGlyphLeft;
  FTransparent := True;
  FShaded := True;
end;

destructor TAdvToolButton.Destroy;
begin
  inherited Destroy;
  FGlyph.Free;
  FGlyphHot.Free;
  FGlyphDown.Free;
  FGlyphDisabled.Free;
  FGlyphShade.Free;
end;

procedure TAdvToolButton.DrawButtonGlyph(Canvas: TCanvas; const GlyphPos: TPoint;
  State: TButtonState; Transparent: Boolean);
var
  SelGlyph: TBitmap;
begin
  if FMouseInControl then
  begin
    if FState = bsDown then
    begin
      if GlyphDown.Empty then
        SelGlyph := FGlyph
      else
        SelGlyph := GlyphDown;
    end
    else
    begin
      if GlyphHot.Empty or (csDesigning in ComponentState) then
        SelGlyph := FGlyph
      else
        SelGlyph := GlyphHot;
    end;
  end
  else
  begin
    SelGlyph := FGlyph;
  end;

  if not Enabled then
  begin
    if FGlyphDisabled.Empty then
      SelGlyph := FGlyph
    else
      SelGlyph := FGlyphDisabled;
  end;

  Shaded := true;

  if not SelGlyph.Empty then
  begin
    if FMouseInControl and Shaded and Enabled and not (FState = bsDown) then
    begin
      FGlyphShade.TransparentMode := tmAuto;
      FGlyphShade.Transparent := True;
      Canvas.Draw(GlyphPos.X + 2,GlyphPos.Y + 2, FGlyphShade);
    end;

    SelGlyph.TransparentMode := tmAuto;
    SelGlyph.Transparent := True;
    Canvas.Draw(GlyphPos.X,GlyphPos.Y,SelGlyph);
  end;
end;
    
procedure TAdvToolButton.DrawButtonText(Canvas: TCanvas; const Caption: string;
  TextBounds: TRect; State: TButtonState; BiDiFlags: LongInt);
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    if State = bsDisabled then
    begin
      OffsetRect(TextBounds, 1, 1);
      Font.Color := clBtnHighlight;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
      OffsetRect(TextBounds, -1, -1);
      Font.Color := clBtnShadow;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
    end else
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
  end;
end;

procedure TAdvToolButton.CalcButtonLayout(Canvas: TCanvas; const Client: TRect;
  const Offset: TPoint; const Caption: string; Layout: TButtonLayout; Margin,
  Spacing: Integer; var GlyphPos: TPoint; var TextBounds: TRect;
  BiDiFlags: LongInt);
var
  TextPos: TPoint;
  ClientSize, GlyphSize, TextSize: TPoint;
  TotalSize: TPoint;
begin
  if (BiDiFlags and DT_RIGHT) = DT_RIGHT then
    if Layout = blGlyphLeft then Layout := blGlyphRight
    else
      if Layout = blGlyphRight then Layout := blGlyphLeft;
  { calculate the item sizes }
  ClientSize := Point(Client.Right - Client.Left, Client.Bottom -
    Client.Top);

  if not FGlyph.Empty then
    GlyphSize := Point(FGlyph.Width, FGlyph.Height) else
    GlyphSize := Point(0, 0);

  if Length(Caption) > 0 then
  begin
    TextBounds := Rect(0, 0, Client.Right - Client.Left, 0);
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption), TextBounds,
      DT_CALCRECT or BiDiFlags);
    TextSize := Point(TextBounds.Right - TextBounds.Left, TextBounds.Bottom -
      TextBounds.Top);
  end
  else
  begin
    TextBounds := Rect(0, 0, 0, 0);
    TextSize := Point(0,0);
  end;
    
  { If the layout has the glyph on the right or the left, then both the
    text and the glyph are centered vertically.  If the glyph is on the top
    or the bottom, then both the text and the glyph are centered horizontally.}
  if Layout in [blGlyphLeft, blGlyphRight] then
  begin
    GlyphPos.Y := (ClientSize.Y - GlyphSize.Y + 1) div 2;
    TextPos.Y := (ClientSize.Y - TextSize.Y + 1) div 2;
  end
  else
  begin
    GlyphPos.X := (ClientSize.X - GlyphSize.X + 1) div 2;
    TextPos.X := (ClientSize.X - TextSize.X + 1) div 2;
  end;
    
  { if there is no text or no bitmap, then Spacing is irrelevant }
  if (TextSize.X = 0) or (GlyphSize.X = 0) then
    Spacing := 0;
    
  { adjust Margin and Spacing }
  if Margin = -1 then
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(GlyphSize.X + TextSize.X, GlyphSize.Y + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X) div 3
      else
        Margin := (ClientSize.Y - TotalSize.Y) div 3;
      Spacing := Margin;
    end
    else
    begin
      TotalSize := Point(GlyphSize.X + Spacing + TextSize.X, GlyphSize.Y +
        Spacing + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X + 1) div 2
      else
        Margin := (ClientSize.Y - TotalSize.Y + 1) div 2;
    end;
  end
  else
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(ClientSize.X - (Margin + GlyphSize.X), ClientSize.Y -
        (Margin + GlyphSize.Y));
      if Layout in [blGlyphLeft, blGlyphRight] then
        Spacing := (TotalSize.X - TextSize.X) div 2
      else
        Spacing := (TotalSize.Y - TextSize.Y) div 2;
    end;
  end;
    
  case Layout of
    blGlyphLeft:
      begin
        GlyphPos.X := Margin;
        TextPos.X := GlyphPos.X + GlyphSize.X + Spacing;
      end;
    blGlyphRight:
      begin
        GlyphPos.X := ClientSize.X - Margin - GlyphSize.X;
        TextPos.X := GlyphPos.X - Spacing - TextSize.X;
      end;
    blGlyphTop:
      begin
        GlyphPos.Y := Margin;
        TextPos.Y := GlyphPos.Y + GlyphSize.Y + Spacing;
      end;
    blGlyphBottom:
      begin
        GlyphPos.Y := ClientSize.Y - Margin - GlyphSize.Y;
        TextPos.Y := GlyphPos.Y - Spacing - TextSize.Y;
      end;
  end;
    
  { fixup the result variables }
  with GlyphPos do
  begin
    Inc(X, Client.Left + Offset.X);
    Inc(Y, Client.Top + Offset.Y);
  end;
  OffsetRect(TextBounds, TextPos.X + Client.Left + Offset.X,
    TextPos.Y + Client.Top + Offset.X);
end;
    
function TAdvToolButton.DrawButton(Canvas: TCanvas; const Client: TRect;
  const Offset: TPoint; const Caption: string; Layout: TButtonLayout;
  Margin, Spacing: Integer; State: TButtonState; Transparent: Boolean;
  BiDiFlags: LongInt): TRect;
var
  GlyphPos: TPoint;
begin
  CalcButtonLayout(Canvas, Client, Offset, Caption, Layout, Margin, Spacing,
    GlyphPos, Result, BiDiFlags);
    
  DrawButtonGlyph(Canvas, GlyphPos, State, Transparent);

  if not (State in [bsDown, bsExclusive]) then
  begin
    if FMouseInControl and Enabled and not (State = bsDown) and Flat then
      OffsetRect(Result,+1,+1)
  end;

  DrawButtonText(Canvas, Caption, Result, State, BiDiFlags);
end;


procedure TAdvToolButton.Paint;
const
  DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
  FillStyles: array[Boolean] of Integer = (BF_MIDDLE, 0);
var
  PaintRect: TRect;
  DrawFlags: Integer;
  Offset: TPoint;
begin
  if not Enabled then
  begin
    FState := bsDisabled;
    FDragging := False;
  end
  else if FState = bsDisabled then
    if FDown and (GroupIndex <> 0) then
      FState := bsExclusive
    else
      FState := bsUp;
  Canvas.Font := Self.Font;
  PaintRect := Rect(0, 0, Width, Height);
  if not FFlat then
  begin
    DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
    if FState in [bsDown, bsExclusive] then
      DrawFlags := DrawFlags or DFCS_PUSHED;
    DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
  end
  else
  begin
    if (FState in [bsDown, bsExclusive]) or
      (FMouseInControl and (FState <> bsDisabled)) or
      (csDesigning in ComponentState) then
      DrawEdge(Canvas.Handle, PaintRect, DownStyles[FState in [bsDown, bsExclusive]],
        FillStyles[FTransparent] or BF_RECT);

      if (csDesigning in ComponentState) then
        InflateRect(PaintRect,-1,-1);

      if FMouseInControl and Enabled and not (csDesigning in ComponentState) then
      begin
        if FState in [bsDown] then
          Canvas.Brush.Color := ColorDown
         else
          Canvas.Brush.Color := ColorHot;

        Canvas.Pen.Color := clGray;
        Canvas.Pen.Width := 1;
        Canvas.Rectangle(PaintRect.Left,PaintRect.Top,PaintRect.Right,PaintRect.Bottom);
      end
      else
      begin
        Canvas.Brush.Color := Color;
        Canvas.FillRect(PaintRect);
      end;

    InflateRect(PaintRect, -1, -1);
  end;

  Offset := Point(0,0);

  if FState in [bsDown, bsExclusive] then
  begin
    if (FState = bsExclusive) and (not FFlat or not FMouseInControl) then
    begin
      Canvas.Brush.Bitmap := AllocPatternBitmap(clBtnFace, clBtnHighlight);
      Canvas.FillRect(PaintRect);
    end;
    if not FFlat and not (csDesigning in ComponentState) then
      Offset := Point(1,1);
  end
  else
  begin
    if FFlat then
    begin
      if FMouseInControl and Enabled and not (FState = bsDown) and not (csDesigning in ComponentState) then
        Offset := Point(-1,-1)
    end;
  end;

  DrawButton(Canvas, PaintRect, Offset, Caption, FLayout, FMargin,
    FSpacing, FState, FTransparent, DrawTextBiDiModeFlags(0));

end;
    
procedure TAdvToolButton.UpdateTracking;
var
  P: TPoint;
begin
  if FFlat then
  begin
    if Enabled then
    begin
      GetCursorPos(P);
      FMouseInControl := not (FindDragTarget(P, True) = Self);
      if FMouseInControl then
        Perform(CM_MOUSELEAVE, 0, 0)
      else
        Perform(CM_MOUSEENTER, 0, 0);
    end;
  end;
end;
    
procedure TAdvToolButton.Loaded;
begin
  inherited Loaded;

  if FShaded then
    GenerateShade;
end;

procedure TAdvToolButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    if not FDown then
    begin
      FState := bsDown;
      Invalidate;
    end;
    FDragging := True;
  end;
end;
    
procedure TAdvToolButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewState: TButtonState;
begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then
  begin
    if not FDown then NewState := bsUp
    else NewState := bsExclusive;
    if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      if FDown then NewState := bsExclusive else NewState := bsDown;
    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end
  else if not FMouseInControl then
    UpdateTracking;
end;
    
procedure TAdvToolButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  DoClick: Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then
  begin
    FDragging := False;
    DoClick := (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight);
    if FGroupIndex = 0 then
    begin
      { Redraw face in-case mouse is captured }
      FState := bsUp;
      FMouseInControl := False;
      if DoClick and not (FState in [bsExclusive, bsDown]) then
        Invalidate;
    end
    else
      if DoClick then
      begin
        SetDown(not FDown);
        if FDown then Repaint;
      end
      else
      begin
        if FDown then FState := bsExclusive;
        Repaint;
      end;
    if DoClick then Click;
    UpdateTracking;
  end;
end;
    
procedure TAdvToolButton.Click;
begin
  inherited Click;
end;
    

{$IFDEF DELPHI6_LVL}
function TAdvToolButton.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TSpeedButtonActionLink;
end;
{$ENDIF}

    
procedure TAdvToolButton.SetGlyph(Value: TBitmap);
var
  x,y: Integer;
  PxlColor: TColor;
  c: byte;
begin
  FGlyph.Assign(Value);
  //if no disabled glyph is given... add this automatically...
  if FGlyphDisabled.Empty then
  begin
    FGlyphDisabled.Assign(Value);
    for x := 0 to FGlyphDisabled.Width - 1 do
      for y := 0 to FGlyphDisabled.Height - 1 do
      begin
        PxlColor := ColorToRGB(FGlyphDisabled.Canvas.Pixels[x, y]);
        c := Round((((PxlColor shr 16) + ((PxlColor shr 8) and $00FF) +
               (PxlColor and $0000FF)) div 3)) div 2 + 96;
        FGlyphDisabled.Canvas.Pixels[x, y] := RGB(c, c, c);
      end;
  end;
  Invalidate;
end;
    
procedure TAdvToolButton.GlyphChanged(Sender: TObject);
begin
  Invalidate;
end;
    
procedure TAdvToolButton.UpdateExclusive;
var
  Msg: TMessage;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;
    
procedure TAdvToolButton.SetDown(Value: Boolean);
begin
  if FGroupIndex = 0 then Value := False;
  if Value <> FDown then
  begin
    if FDown and (not FAllowAllUp) then Exit;
    FDown := Value;
    if Value then
    begin
      if FState = bsUp then Invalidate;
      FState := bsExclusive
    end
    else
    begin
      FState := bsUp;
      Repaint;
    end;
    if Value then UpdateExclusive;
  end;
end;
    
procedure TAdvToolButton.SetFlat(Value: Boolean);
begin
  if Value <> FFlat then
  begin
    FFlat := Value;
    Invalidate;
  end;
end;
    
procedure TAdvToolButton.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    UpdateExclusive;
  end;
end;
    
procedure TAdvToolButton.SetLayout(Value: TButtonLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;
    
procedure TAdvToolButton.SetMargin(Value: Integer);
begin
  if (Value <> FMargin) and (Value >= -1) then
  begin
    FMargin := Value;
    Invalidate;
  end;
end;
    
procedure TAdvToolButton.SetSpacing(Value: Integer);
begin
  if Value <> FSpacing then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;

procedure TAdvToolButton.SetAllowAllUp(Value: Boolean);
begin
  if FAllowAllUp <> Value then
  begin
    FAllowAllUp := Value;
    UpdateExclusive;
  end;
end;
    
procedure TAdvToolButton.WMLButtonDblClk(var Message: TWMLButtonDown);
begin
  inherited;
  if FDown then DblClick;
end;
    
procedure TAdvToolButton.CMEnabledChanged(var Message: TMessage);
const
  NewState: array[Boolean] of TButtonState = (bsDisabled, bsUp);
begin
  UpdateTracking;
  Repaint;
end;
    
procedure TAdvToolButton.CMButtonPressed(var Message: TMessage);
var
  Sender: TAdvToolButton;
begin
  if Message.WParam = FGroupIndex then
  begin
    Sender := TAdvToolButton(Message.LParam);
    if Sender <> Self then
    begin
      if Sender.Down and FDown then
      begin
        FDown := False;
        FState := bsUp;
        if (Action is TCustomAction) then
          TCustomAction(Action).Checked := False;
        Invalidate;
      end;
      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;
    
procedure TAdvToolButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and Enabled and Visible and
      (Parent <> nil) and Parent.Showing then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;
    
procedure TAdvToolButton.CMFontChanged(var Message: TMessage);
begin
  Invalidate;
end;
    
procedure TAdvToolButton.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;
    
procedure TAdvToolButton.CMSysColorChange(var Message: TMessage);
begin
  with TBitmap(FGlyph) do
  begin
    Invalidate;
  end;
end;
    
procedure TAdvToolButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  { Don't draw a border if DragMode <> dmAutomatic since this button is meant to 
    be used as a dock client. }
  if FFlat and not FMouseInControl and Enabled and (DragMode <> dmAutomatic) 
    and (GetCapture = 0) then
  begin
    FMouseInControl := True;
    Repaint;
  end;
end;

procedure TAdvToolButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FFlat and FMouseInControl and Enabled and not FDragging then
  begin
    FMouseInControl := False;
    Invalidate;
  end;
end;

procedure TAdvToolButton.SetGlyphDisabled(const Value: TBitmap);
begin
  FGlyphDisabled.Assign(Value);
end;

procedure TAdvToolButton.SetGlyphDown(const Value: TBitmap);
begin
  FGlyphDown.Assign(Value);
end;

procedure TAdvToolButton.SetGlyphHot(const Value: TBitmap);
begin
  FGlyphHot.Assign(Value);
end;

procedure TAdvToolButton.GenerateShade;
var
  r: TRect;
  bmp: TBitmap;
begin
  if not FGlyph.Empty then
  begin
    FGlyphShade.Width := FGlyph.Width;
    FGlyphShade.Height := FGlyph.Height;

    r := Rect(0,0,FGlyphShade.Width,FGlyphShade.Height);
    FGlyphShade.Canvas.Brush.Color := ColorToRGB(clBlack);
    FGlyphShade.Canvas.BrushCopy(r,FGlyph,r, FGlyph.Canvas.Pixels[0,FGlyph.Height-1]);
    FGlyphShade.Canvas.CopyMode := cmSrcInvert;
    FGlyphShade.Canvas.CopyRect(r,FGlyph.Canvas,r);

    bmp := TBitmap.Create;
    bmp.Width := FGlyph.Width;
    bmp.Height := FGlyph.Height;
    bmp.Canvas.Brush.Color := ColorToRGB(clGray);
    bmp.Canvas.BrushCopy(r,FGlyphShade,r,ColorToRGB(clBlack));

    FGlyphShade.Canvas.CopyMode := cmSrcCopy;
    FGlyphShade.Canvas.CopyRect(r,bmp.Canvas,r);
    bmp.Free;
  end;
end;

procedure TAdvToolButton.SetShaded(const Value: Boolean);
begin
  FShaded := Value;

  if FShaded then
    if not (csLoading in ComponentState) then
    begin
      GenerateShade;
    end;
end;

end.
