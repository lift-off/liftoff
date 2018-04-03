{**************************************************************************}
{ THTMLPopup component                                                     }
{ for Delphi 3.0,4.0,5.0,6.0 + C++Builder 3.0,4.0,5.0,6.0                  }
{ version 1.1, August  2002                                                }
{                                                                          }
{ Copyright © 2001-2002                                                    }
{   TMS Software                                                           }
{   Email : info@tmssoftware.com                                           }
{   Web : http://www.tmssoftware.com                                       }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit HTMLPopup;

interface

{$I TMSDEFS.INC}
{$DEFINE REMOVESTRIP}
{$DEFINE REMOVEDRAW}

uses
  Classes, Windows, Graphics, Messages, Controls, Forms, SysUtils,
  PictureContainer;

type
  TAnchorClickEvent = procedure(Sender: TObject; Anchor: string) of object;

  TShadeDirection = (sdHorizontal, sdVertical);

  { THTMLPopup }
  THTMLPopupWindow = class(THintWindow)
  private
    FImageCache: THTMLPictureCache;
    FContainer: TPictureContainer;
    FHoverLink: Integer;
    FHover: Boolean;
    FHoverRect: TRect;
    FOnAnchorClick: TAnchorClickEvent;
    FShadeEnable: Boolean;
    FShadeSteps: Integer;
    FShadeStartColor: TColor;
    FShadeEndColor: TColor;
    FColor: TColor;
    FShadeDirection: TShadeDirection;
    FBorderSize: Integer;
    FImages: TImageList;
    FAutoHide: Boolean;
    FAutoSize: Boolean;
    FAlwaysOnTop: Boolean;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetHover(const Value: Boolean);
    procedure SetAutoSizeEx(const Value: Boolean);
    procedure SetAlwaysOnTop(const Value: Boolean);
  protected
    procedure PaintShading(FromColor,ToColor: TColor; Steps: Integer; Direction: Boolean);
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AlwaysOnTop: Boolean read FAlwaysOnTop write SetAlwaysOnTop;
    property AutoHide: Boolean read FAutoHide write FAutoHide;
    property AutoSize: Boolean read FAutoSize write SetAutoSizeEx;
    property BorderSize: Integer read FBorderSize write FBorderSize;
    property Color: TColor read FColor write FColor;
    property Images: TImageList read FImages write FImages;    
    property ShadeEnable: Boolean read FShadeEnable write FShadeEnable;
    property ShadeStartColor: TColor read FShadeStartColor write FShadeStartColor;
    property ShadeEndColor: TColor read FShadeEndColor write FShadeEndColor;
    property ShadeSteps: Integer read FShadeSteps write FShadeSteps;
    property ShadeDirection: TShadeDirection read FShadeDirection write FShadeDirection;
    property Hover: Boolean read FHover write SetHover;
    property PictureContainer: TPictureContainer read FContainer write FContainer;
    property OnAnchorClick: TAnchorClickEvent read FOnAnchorClick write FOnAnchorClick;
  end;

  THTMLPopup = class(TComponent)
  private
    FOwner: TWinControl;
    FHTMLPopupWindow: THTMLPopupWindow;
    FHeight: Integer;
    FWidth: Integer;
    FContainer: TPictureContainer;
    FText: TStringList;
    FLeft: Integer;
    FTop: Integer;
    FHover: Boolean;
    FOnAnchorClick: TAnchorClickEvent;
    FShadeEnable: Boolean;
    FShadeSteps: Integer;
    FShadeStartColor: TColor;
    FShadeEndColor: TColor;
    FColor: TColor;
    FFont: TFont;
    FShadeDirection: TShadeDirection;
    FBorderSize: Integer;
    FImages: TImageList;
    FAutoHide: Boolean;
    FAutoSize: Boolean;
    FAlwaysOnTop: Boolean;
    procedure SetText(const Value: TStringList);
    procedure SetImages(const Value: TImageList);
    procedure SetFont(const Value: TFont);
  protected
    procedure WindowAnchorClick(Sender: TObject; Anchor:string);
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure CreatePopup;
    procedure TextChanged(Sender: TObject);    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Show;
    procedure RollUp;
    procedure RollDown;
    procedure Hide;
  published
    property AlwaysOnTop: Boolean read FAlwaysOnTop write FAlwaysOnTop;
    property AutoHide: Boolean read FAutoHide write FAutoHide;
    property AutoSize: Boolean read FAutoSize write FAutoSize;    
    property BorderSize: Integer read FBorderSize write FBorderSize;
    property Color: TColor read FColor write FColor;
    property Font: TFont read FFont write SetFont;
    property Hover: Boolean read FHover write FHover;
    property Images: TImageList read FImages write SetImages;
    property PopupLeft: Integer read FLeft write FLeft;
    property PopupTop: Integer read FTop write FTop;
    property ShadeEnable: Boolean read FShadeEnable write FShadeEnable;
    property ShadeStartColor: TColor read FShadeStartColor write FShadeStartColor;
    property ShadeEndColor: TColor read FShadeEndColor write FShadeEndColor;
    property ShadeSteps: Integer read FShadeSteps write FShadeSteps;
    property ShadeDirection: TShadeDirection read FShadeDirection write FShadeDirection;

    property Text: TStringList read FText write SetText;
    property PictureContainer: TPictureContainer read FContainer write FContainer;
    property PopupWidth: Integer read FWidth write FWidth;
    property PopupHeight: Integer read FHeight write FHeight;
    property OnAnchorClick: TAnchorClickEvent read FOnAnchorClick write FOnAnchorClick;
  end;


implementation


uses
  Commctrl, ShellApi
{$IFDEF DELPHI4_LVL}
  ,Imglist
{$ENDIF}
  ;

{$I HTMLENGO.PAS}

{ THTMLPopupWindow }

constructor THTMLPopupWindow.Create(AOwner: TComponent);
begin
  inherited;
  FImageCache := THTMLPictureCache.Create;
  FHoverLink := -1;
  FHover := True;
  FImages := nil;
end;

destructor THTMLPopupWindow.Destroy;
begin
  FImageCache.Free;
  inherited;
end;

procedure THTMLPopupWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style - WS_BORDER;
  if FAlwaysOnTop then
    Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST;
end;

procedure THTMLPopupWindow.PaintShading(FromColor,ToColor: TColor; Steps: Integer; Direction: Boolean);
var
  diffr,startr,endr:longint;
  diffg,startg,endg:longint;
  diffb,startb,endb:longint;
  rstepr:real;
  rstepg:real;
  rstepb:real;
  rstepw:real;
  i,stepw:word;

begin
  if Steps = 0 then
    Steps := 1;

  startr := (FromColor and $0000ff);
  startg := (FromColor and $00ff00) shr 8;
  startb := (FromColor and $ff0000) shr 16;
  endr := (ToColor and $0000ff);
  endg := (ToColor and $00ff00) shr 8;
  endb := (ToColor and $ff0000) shr 16;

  diffr := endr-startr;
  diffg := endg-startg;
  diffb := endb-startb;

  rstepr := diffr/steps;
  rstepg := diffg/steps;
  rstepb := diffb/steps;

  if Direction then
    rstepw := width/Steps
  else
    rstepw := height/Steps;

  with Canvas do
  begin
    for i := 0 to steps-1 do
    begin
      endr := startr+round(rstepr*i);
      endg := startg+round(rstepg*i);
      endb := startb+round(rstepb*i);
      stepw := round(i*rstepw);

      pen.Color := endr + (endg shl 8) + (endb shl 16);

      brush.Color := pen.Color;
      if Direction then
        Rectangle(stepw,0,stepw+round(rstepw)+1,height)
      else
        Rectangle(0,stepw,width,stepw+round(rstepw)+1);
    end;
  end;
end;

procedure THTMLPopupWindow.SetAutoSizeEx(const Value: Boolean);
var
  R, rd, hr : TRect;
  Anchor,Stripped,FocusAnchor:string;
  XSize,YSize,HyperLinks,MouseLink:integer;
begin
  FAutoSize := Value;

  if not FAutoSize then
    Exit;

  R := ClientRect;
  RD := ClientRect;

  InflateRect(R,-FBorderSize,-FBorderSize);

  RD.Left := R.Left + 6;
  RD.Top := R.Top + 2;
//  RD.Bottom := R.bottom - 8;
//  RD.Right := R.Right - 4;

  RD.Right := RD.Left + 4096;
  RD.Bottom := RD.Top + 4096;

  Canvas.Font.Assign(Self.Font);

  HTMLDrawEx(Canvas,Caption,rd,FImages,0,0,-1,FHoverLink,1,False,False,False,False,True,FHover,True,
             1.0,clBlue,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,XSize,YSize,
             HyperLinks,MouseLink,hr,FImageCache,FContainer);

  Width := XSize + 16 + BorderSize *2;
  Height := YSize + 16 + BorderSize * 2;
end;

procedure THTMLPopupWindow.Paint;
var
  DC: HDC;
  R, rd, hr : TRect;
  Brush, SaveBrush: HBRUSH;
  Anchor,Stripped,FocusAnchor:string;
  XSize,YSize,HyperLinks,MouseLink:integer;

  procedure DCFrame3D(var R: TRect; const TopLeftColor, BottomRightColor: TColor);
  var
    Pen, SavePen: HPEN;
    P: array[0..2] of TPoint;
  begin
    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(TopLeftColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-2);
    P[1] := Point(R.Left, R.Top);
    P[2] := Point(R.Right-1, R.Top);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);

    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(BottomRightColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-1);
    P[1] := Point(R.Right-1, R.Bottom-1);
    P[2] := Point(R.Right-1, R.Top-1);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);
  end;

begin
  DC := Canvas.Handle;
  R := ClientRect;
  RD := ClientRect;

  // Background
  if FShadeEnable then
    PaintShading(FShadeStartColor,FShadeEndColor,FShadeSteps,FShadeDirection = sdHorizontal)
  else
  begin
    Brush := CreateSolidBrush(ColorToRGB(Color));

    SaveBrush := SelectObject(DC, Brush);
    FillRect(DC, R, Brush);
    SelectObject(DC, SaveBrush);
    DeleteObject(Brush);
  end;

  // Border
  if FBorderSize = 0 then
   DCFrame3D(R, cl3DLight, cl3DDkShadow)
  else
  begin
    Canvas.Brush.Color := clBtnFace;
    Canvas.Pen.Color := clBtnFace;

    Canvas.Rectangle(0,0,R.Right, FBorderSize);
    Canvas.Rectangle(R.Right - FBorderSize,0,R.Right, R.Bottom);
    Canvas.Rectangle(0,R.Bottom - FBorderSize,R.Right, R.Bottom);
    Canvas.Rectangle(0,0,FBorderSize,R.Bottom);

    Canvas.Pen.Color := clWhite;
    Canvas.MoveTo(0,R.Bottom);
    Canvas.LineTo(0,0);
    Canvas.LineTo(R.Right - 1,0);
    Canvas.Pen.Color := clGray;
    Canvas.LineTo(R.Right - 1,R.Bottom - 1);
    Canvas.LineTo(0,R.Bottom - 1);


    Canvas.MoveTo(FBorderSize,R.Bottom - FBorderSize);
    Canvas.LineTo(FBorderSize,FBorderSize);
    Canvas.LineTo(R.Right - FBorderSize,FBorderSize);
    Canvas.Pen.Color := clWhite;

    Canvas.LineTo(R.Right - FBorderSize,R.Bottom - FBorderSize);
    Canvas.LineTo(FBorderSize,R.Bottom - FBorderSize);



    InflateRect(R,-FBorderSize,-FBorderSize);
  end;

  RD.Left := R.Left + 6;
  RD.Top := R.Top + 2;
  RD.Bottom := R.bottom - 8;
  RD.Right := R.Right - 4;

  Canvas.Font.Assign(Self.Font);

  HTMLDrawEx(Canvas,Caption,rd,FImages,0,0,-1,FHoverLink,1,False,False,False,False,True,FHover,True,
             1.0,clBlue,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,XSize,YSize,
             HyperLinks,MouseLink,hr,FImageCache,FContainer);


end;

constructor THTMLPopup.Create(AOwner: TComponent);
begin
  inherited;
  FText := TStringList.Create;
  FText.OnChange := TextChanged;
  FOwner := TWinControl(AOwner);
  FHTMLPopupWindow := nil;
  FWidth := 200;
  FHeight := 200;
  FColor := clInfoBk;
  FShadeStartColor := clSilver;
  FShadeEndColor := clGray;
  FShadeSteps := 40;
  FImages := nil;
  FFont := TFont.Create;  
end;

procedure THTMLPopup.Hide;
begin
  if Assigned(FHTMLPopupWindow) then
    FHTMLPopupWindow.Visible := False;
end;

procedure THTMLPopup.TextChanged(Sender: TObject);
var
  s: string;
  i: Integer;
begin

  if Assigned(FHTMLPopupWindow) then
  begin
    s := '';
    for i := 1 to FText.Count do
      s := s + FText.Strings[i - 1];
    FHTMLPopupWindow.Caption := s;
  end;
end;

procedure THTMLPopup.CreatePopup;
var
  i: Integer;
  s: string;
begin
  if not Assigned(FHTMLPopupWindow) then
    FHTMLPopupWindow := THTMLPopupWindow.Create(FOwner);

  FHTMLPopupWindow.Visible := False;
  FHTMLPopupWindow.Parent := nil;
  FHTMLPopupWindow.ParentWindow := FOwner.Handle;
  s := '';
  for i := 1 to FText.Count do
    s := s + FText.Strings[i - 1];

  FHTMLPopupWindow.Caption := s;

  FHTMLPopupWindow.AlwaysOnTop := FAlwaysOnTop;
  FHTMLPopupWindow.Width := FWidth;
  FHTMLPopupWindow.Height := FHeight;
  FHTMLPopupWindow.Left := FLeft;
  FHTMLPopupWindow.Top := FTop;
  FHTMLPopupWindow.PictureContainer := FContainer;
  FHTMLPopupWindow.Hover := FHover;
  FHTMLPopupWindow.Images := FImages;
  FHTMLPopupWindow.ShadeEnable := FShadeEnable;
  FHTMLPopupWindow.ShadeStartColor := FShadeStartColor;
  FHTMLPopupWindow.ShadeEndColor := FShadeEndColor;
  FHTMLPopupWindow.ShadeDirection := FShadeDirection;
  FHTMLPopupWindow.ShadeSteps := FShadeSteps;
  FHTMLPopupWindow.Font.Assign(FFont);

  FHTMLPopupWindow.AutoHide := FAutoHide;
  FHTMLPopupWindow.BorderSize := FBorderSize;
  FHTMLPopupWindow.Color := Color;

  FHTMLPopupWindow.OnAnchorClick := WindowAnchorClick;

  FHTMLPopupWindow.AutoSize := FAutoSize;
end;

procedure THTMLPopup.Show;
begin
  CreatePopup;
  FHTMLPopupWindow.Visible := True;  
end;

procedure THTMLPopup.SetText(const Value: TStringList);
begin
  FText.Assign(Value);
end;

destructor THTMLPopup.Destroy;
begin
  FText.Free;
  FFont.Free;
  inherited;
end;

procedure THTMLPopupWindow.WMNCHitTest(var Message: TWMNCHitTest);
var
  pt: TPoint;
  RD,hr,r: TRect;
  hl,ml: Integer;
  XSize, YSize: Integer;
  a,s,fa: string;
  Anchor: string;
begin
  pt := ScreenToClient(Point(message.Xpos,message.YPos));

  r := ClientRect;
  RD.Left := R.Left + 6;
  RD.Top := R.Top + 2;
  RD.Bottom := r.bottom - 8;
  RD.Right := R.Right - 4;

  InflateRect(RD,-FBorderSize,-FBorderSize);

  Anchor := '';

  Canvas.Font.Assign(Self.Font);  

  if HTMLDrawEx(Canvas,Caption,rd,FImages,pt.X,pt.Y,-1,-1,1,True,False,False,False,False,False,True,
             1.0,clBlue,clNone,clNone,clGray,a,s,fa,XSize,YSize,
             hl,ml,hr,FImageCache,FContainer) then
  begin
    Anchor := a;
  end;

  if (Anchor <> '') then
  begin
    Cursor := crHandPoint;
    if (FHoverLink <> hl) and FHover then
      InvalidateRect(Handle,@hr,True);
    FHoverLink := hl;
    FHoverRect := hr;
  end
  else
  begin
    Cursor := crDefault;
    if (FHoverLink <> -1) and (FHover) then
      InvalidateRect(Handle,@FHoverRect,True);;
    FHoverLink := -1;
  end;

  Message.Result := HTCLIENT;
end;


procedure THTMLPopupWindow.WMSetFocus(var Msg: TWMSetFocus);
var
  pt: TPoint;
  RD,hr,r: TRect;
  hl,ml: Integer;
  XSize, YSize: Integer;
  a,s,fa: string;
  Anchor: string;
begin
  msg.Result := 0;

  GetCursorPos(pt);
  pt := ScreenToClient(pt);

  r := ClientRect;
  RD.Left := R.Left + 6;
  RD.Top := R.Top + 2;
  RD.Bottom := R.bottom - 8;
  RD.Right := R.Right - 4;

  InflateRect(RD,-FBorderSize,-FBorderSize);

  Anchor := '';

  Canvas.Font.Assign(Self.Font);  

  if HTMLDrawEx(Canvas,Caption,rd,nil{FHint.FImages},pt.X,pt.Y,-1,-1,1,True,False,False,False,False,False,True,
             1.0,clBlue,clNone,clNone,clGray,a,s,fa,XSize,YSize,
             hl,ml,hr,FImageCache,FContainer) then
  begin
    Anchor := a;
    if Assigned(FOnAnchorClick) then
      FOnAnchorClick(Self,a);
  end;

  Windows.SetFocus(ParentWindow);

  if (FHoverLink <> -1) and (FHover) then
    InvalidateRect(Handle,@FHoverRect,True);;
end;

procedure THTMLPopup.WindowAnchorClick(Sender: TObject; Anchor: string);
begin
  if Assigned(FOnAnchorClick) then
    FOnAnchorClick(Self,Anchor);
end;

procedure THTMLPopup.RollDown;
var
  t: DWORD;
  r: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0,@r,0);

  while FHTMLPopupWindow.Top < r.Bottom do
  begin
    t := GetTickCount;
    while GetTickCount - t < 50 do
      Application.ProcessMessages;

    FHTMLPopupWindow.Top := FHTMLPopupWindow.Top + 20;
  end;
  Hide;
end;

procedure THTMLPopup.RollUp;
var
  t: DWORD;
  r: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0,@r,0);

  FTop := r.Bottom;

  CreatePopup;
  FLeft := r.Right - FHTMLPopupWindow.Width - 20;
  Show;

  while FHTMLPopupWindow.Top + FHTMLPopupWindow.Height > r.Bottom do
  begin
    t := GetTickCount;
    while GetTickCount - t < 50 do
      Application.ProcessMessages;

    if FHTMLPopupWindow.Top - 20 < r.Bottom - FHTMLPopupWindow.Height then
      FHTMLPopupWindow.Top := r.Bottom - FHTMLPopupWindow.Height
    else
      FHTMLPopupWindow.Top := FHTMLPopupWindow.Top - 20;

  end;

  FHTMLPopupWindow.Top := r.Bottom - FHTMLPopupWindow.Height
end;

procedure THTMLPopupWindow.SetHover(const Value: Boolean);
begin
  FHover := Value;
  FHoverLink := -1;
end;

procedure THTMLPopup.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FContainer) then
    FContainer := nil;

  if (AOperation = opRemove) and (AComponent = FImages) then
    FImages := nil;

  inherited;
end;

procedure THTMLPopup.SetImages(const Value: TImageList);
begin
  FImages := Value;
end;

procedure THTMLPopup.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure THTMLPopupWindow.CMMouseLeave(var Message: TMessage);
begin
  if FAutoHide then
    Self.Visible := False;
end;

procedure THTMLPopupWindow.SetAlwaysOnTop(const Value: Boolean);
begin
  FAlwaysOnTop := Value;
  RecreateWnd;
end;


end.
