{*********************************************************************}
{ TGradientLabel component                                            }
{ for Delphi & C++Builder                                             }
{ version 1.0                                                         }
{                                                                     }
{ written by                                                          }
{  TMS Software                                                       }
{  copyright © 2001 - 2002                                            }
{  Email : info@tmssoftware.com                                       }
{  Web : http://www.tmssoftware.com                                   }
{*********************************************************************}

unit GradientLabel;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TVAlignment = (vaTop,vaCenter,vaBottom);

  TEllipsType = (etNone, etEndEllips, etPathEllips);

  TGradientType = (gtFullHorizontal, gtFullVertical, gtBottomLine, gtCenterLine, gtTopLine);

  TGradientLabel = class(TLabel)
  private
    { Private declarations }  
    FColorTo: TColor;
    FEllipsType: TEllipsType;
    FValignment: TVAlignment;
    FIndent: Integer;
    FGradientType: TGradientType;
    FTransparentText: Boolean;
    FLineWidth: Integer;
    procedure SetColor(const Value: TColor);
    procedure SetEllipsType(const Value: TEllipsType);
    procedure SetVAlignment(const Value: TVAlignment);
    procedure SetIndent(const Value: Integer);
    procedure SetGradientType(const Value: TGradientType);
    procedure SetTransparentText(const Value: Boolean);
    procedure SetLineWidth(const Value: Integer);
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property ColorTo: TColor read FColorTo write SetColor;
    property EllipsType: TEllipsType read FEllipsType write SetEllipsType;
    property GradientType: TGradientType read FGradientType write SetGradientType;
    property Indent: Integer read FIndent write SetIndent;
    property LineWidth: Integer read FLineWidth write SetLineWidth;
    property TransparentText: Boolean read FTransparentText write SetTransparentText;
    property VAlignment: TVAlignment read FValignment write SetVAlignment;
  end;

implementation

const
  ALIGNSTYLE : array[TAlignment] of DWORD = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WORDWRAPSTYLE : array[Boolean] of DWORD = (DT_SINGLELINE, DT_WORDBREAK);
  LAYOUTSTYLE : array[TTextLayout] of DWORD = (0,DT_VCENTER,DT_BOTTOM);
  ELLIPSSTYLE : array[TEllipsType] of DWORD = (0,DT_END_ELLIPSIS,DT_PATH_ELLIPSIS);
  ACCELSTYLE : array[Boolean] of DWORD = (DT_NOPREFIX,0);
  VALIGNSTYlE : array[TVAlignment] of DWORD = (DT_TOP,DT_VCENTER,DT_BOTTOM);

procedure DrawGradient(Canvas: TCanvas; FromColor,ToColor: TColor; Steps: Integer;R:TRect; Direction: Boolean);
var
  diffr,startr,endr: Integer;
  diffg,startg,endg: Integer;
  diffb,startb,endb: Integer;
  iend: Integer;
  rstepr,rstepg,rstepb,rstepw: Real;
  i,stepw: Word;

begin
  if Steps = 0 then
    Steps := 1;

  FromColor := ColorToRGB(FromColor);
  ToColor := ColorToRGB(ToColor);  

  startr := (FromColor and $0000FF);
  startg := (FromColor and $00FF00) shr 8;
  startb := (FromColor and $FF0000) shr 16;
  endr := (ToColor and $0000FF);
  endg := (ToColor and $00FF00) shr 8;
  endb := (ToColor and $FF0000) shr 16;

  diffr := endr - startr;
  diffg := endg - startg;
  diffb := endb - startb;

  rstepr := diffr / steps;
  rstepg := diffg / steps;
  rstepb := diffb / steps;

  if Direction then
    rstepw := (R.Right - R.Left) / Steps
  else
    rstepw := (R.Bottom - R.Top) / Steps;

  with Canvas do
  begin
    for i := 0 to Steps - 1 do
    begin
      endr := startr + Round(rstepr*i);
      endg := startg + Round(rstepg*i);
      endb := startb + Round(rstepb*i);
      stepw := Round(i*rstepw);
      Pen.Color := endr + (endg shl 8) + (endb shl 16);
      Brush.Color := Pen.Color;
      if Direction then
      begin
        iend := R.Left + stepw + Trunc(rstepw) + 1;
        if iend > R.Right then
          iend := R.Right;
        Rectangle(R.Left + stepw,R.Top,iend,R.Bottom)
      end
      else
      begin
        iend := R.Top + stepw + Trunc(rstepw)+1;
        if iend > r.Bottom then
          iend := r.Bottom;
        Rectangle(R.Left,R.Top + stepw,R.Right,iend);
      end;
    end;
  end;
end;



{ TGradientLabel }

constructor TGradientLabel.Create(AOwner: TComponent);
begin
  inherited;
  FLineWidth := 2;
  FColorTo := clWhite;
  AutoSize := False;
end;

{$WARNINGS OFF}
procedure TGradientLabel.Paint;
var
  R,LR: TRect;
  DrawStyle: DWORD;
  tw: Integer;
  gsteps: Integer;
  rgn1,rgn2,rgn3: THandle;
begin
  R := GetClientRect;

  Canvas.Font := Font;

  DrawStyle := DT_LEFT;

  DrawTextEx(Canvas.Handle,PChar(Caption),Length(Caption),R, DrawStyle or DT_CALCRECT, nil);

  tw := R.Right - R.Left;

  R := GetClientRect;  

  gsteps := (R.Right - R.Left) div 4;

  if not Transparent then
  begin
    if (ColorTo <> clNone) and (GradientType in [gtFullHorizontal,gtFullVertical]) then
    begin
      DrawGradient(Canvas,Color,ColorTo,gsteps,R,GradientType = gtFullHorizontal);
    end
    else
    begin
      Canvas.Brush.Color := Color;
      Canvas.Pen.Color := Color;
      Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
    end;
  end;

  case GradientType of
  gtBottomLine: R.Top := R.Bottom - 2;
  gtTopLine: R.Bottom := R.Top + 2;
  gtCenterLine:
    begin
      R.Top := R.Top + (R.Bottom - R.Top) div 2;
      R.Bottom := R.Top + 2;
    end;
  end;

  if GradientType in [gtBottomLine, gtTopLine, gtCenterLine] then
  begin
    {clip out region}

    if TransparentText then
    begin
      LR := R;
      OffsetRect(LR,Left,Top);

      rgn3 := CreateRectRgn(LR.Left,LR.Top,LR.Right,LR.Bottom);
      case Alignment of
      taLeftJustify:
        begin
          rgn1 := CreateRectRgn(LR.Left,LR.Top,LR.Left + Indent,LR.Bottom);
          rgn2 := CreateRectRgn(LR.Left + Indent + tw,LR.Top, LR.Right,LR.Bottom);
          CombineRgn( rgn3,rgn1,rgn2, RGN_OR);
        end;
      taRightJustify:
        begin
          rgn1 := CreateRectRgn(LR.Left,LR.Top,LR.Right - tw - Indent,LR.Bottom);
          rgn2 := CreateRectRgn(LR.Right - Indent,LR.Top, LR.Right,LR.Bottom);
          CombineRgn( rgn3,rgn1,rgn2, RGN_OR);
        end;
      taCenter:
        begin
          rgn1 := CreateRectRgn(LR.Left,LR.Top,LR.Left + ((LR.Right - LR.Left - tw) div 2),LR.Bottom);
          rgn2 := CreateRectRgn(LR.Left + tw + ((LR.Right - LR.Left -tw) div 2),LR.Top, LR.Right,LR.Bottom);
          CombineRgn( rgn3,rgn1,rgn2, RGN_OR);
        end;
      end;

      SelectClipRgn(Canvas.Handle,rgn3);
    end;  

    DrawGradient(Canvas,Color,ColorTo,gsteps,R,true);

    if TransparentText then
    begin
      SelectClipRgn(Canvas.Handle,0);
      DeleteObject(rgn1);
      DeleteObject(rgn2);
      DeleteObject(rgn3);
    end;  

  end;

  R := GetClientRect;

  Canvas.Brush.Style := bsClear;

  DrawStyle := ALIGNSTYLE[Alignment] or WORDWRAPSTYLE[WordWrap] or
    LAYOUTSTYLE[Layout] or ELLIPSSTYLE[FEllipsType] or ACCELSTYLE[ShowAccelChar] or
    VALIGNSTYLE[VAlignment];

  {$IFDEF DELPHI4_LVL}
  DrawStyle := DrawTextBiDiModeFlags(DrawStyle);
  {$ENDIF}

  if Alignment = taLeftJustify then
    R.Left := R.Left + Indent;

  if Alignment = taRightJustify then
    R.Right := R.Right - Indent;

  if not Enabled then
  begin
    OffsetRect(R, 1, 1);
    Canvas.Font.Color := clBtnHighlight;
    DrawTextEx(Canvas.Handle,PChar(Caption),Length(Caption),R, DrawStyle, nil);
    OffsetRect(R, -1, -1);
    Canvas.Font.Color := clBtnShadow;
    DrawTextEx(Canvas.Handle,PChar(Caption),Length(Caption),R, DrawStyle, nil);
  end
  else
    DrawTextEx(Canvas.Handle,PChar(Caption),Length(Caption),R, DrawStyle, nil);
end;
{$WARNINGS ON}

procedure TGradientLabel.SetColor(const Value: TColor);
begin
  FColorTo := Value;
  Invalidate;
end;

procedure TGradientLabel.SetEllipsType(const Value: TEllipsType);
begin
  if FEllipsType <> Value then
  begin
    FEllipsType := Value;
    Invalidate;
  end;
end;

procedure TGradientLabel.SetGradientType(const Value: TGradientType);
begin
  FGradientType := Value;
  Invalidate;
end;

procedure TGradientLabel.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  Invalidate;
end;

procedure TGradientLabel.SetLineWidth(const Value: Integer);
begin
  FLineWidth := Value;
  Invalidate;
end;

procedure TGradientLabel.SetTransparentText(const Value: Boolean);
begin
  FTransparentText := Value;
  Invalidate;
end;

procedure TGradientLabel.SetVAlignment(const Value: TVAlignment);
begin
  FValignment := Value;
  Invalidate;
end;

end.
