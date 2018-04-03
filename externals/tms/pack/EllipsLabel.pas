{*********************************************************************}
{ TEllipsLabel component                                              }
{ for Delphi 3.0,4.0,5.0 & C++Builder 3.0,4.0,5.0                     }
{ version 1.0                                                         }
{                                                                     }
{ written by                                                          }
{  TMS Software                                                       }
{  copyright © 2001                                                   }
{  Email : info@tmssoftware.com                                       }
{  Web : http://www.tmssoftware.com                                   }
{*********************************************************************}

unit EllipsLabel;

{$IFDEF VER120}
{$DEFINE DELPHI4_LVL}
{$ENDIF}

{$IFDEF VER125}
{$DEFINE DELPHI4_LVL}
{$ENDIF}

{$IFDEF VER130}
{$DEFINE DELPHI4_LVL}
{$ENDIF}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type

  TEllipsType = (etNone, etEndEllips, etPathEllips);

  TEllipsLabel = class(TLabel)
  private
    FEllipsType: TEllipsType;
    procedure SetEllipsType(const Value: TEllipsType);
    { Private declarations }
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
  published
    { Published declarations }
    property EllipsType: TEllipsType read FEllipsType write SetEllipsType;
  end;

implementation

const
  ALIGNSTYLE : array[TAlignment] of DWORD = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WORDWRAPSTYLE : array[Boolean] of DWORD = (DT_SINGLELINE, DT_WORDBREAK);
  LAYOUTSTYLE : array[TTextLayout] of DWORD = (0,DT_VCENTER,DT_BOTTOM);
  ELLIPSSTYLE : array[TEllipsType] of DWORD = (0,DT_END_ELLIPSIS,DT_PATH_ELLIPSIS);
  ACCELSTYLE : array[Boolean] of DWORD = (DT_NOPREFIX,0);

{ TEllipsLabel }

procedure TEllipsLabel.Paint;
var
  R: TRect;
  DrawStyle: DWORD;

begin
  R := GetClientRect;

  if not Transparent then
  begin
    Canvas.Brush.Color := Color;
    Canvas.Pen.Color := Color;
    Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
  end;

  Canvas.Brush.Style := bsClear;

  DrawStyle := ALIGNSTYLE[Alignment] or WORDWRAPSTYLE[WordWrap] or
    LAYOUTSTYLE[Layout] or ELLIPSSTYLE[FEllipsType] or ACCELSTYLE[ShowAccelChar];

  {$IFDEF DELPHI4_LVL}
  DrawStyle := DrawTextBiDiModeFlags(DrawStyle);
  {$ENDIF}

  Canvas.Font := Font;

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

procedure TEllipsLabel.SetEllipsType(const Value: TEllipsType);
begin
  if FEllipsType <> Value then
  begin
    FEllipsType := Value;
    Invalidate;
  end;
end;

end.
