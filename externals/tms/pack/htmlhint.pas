{*************************************************************************}
{ HTMLHint component                                                      }
{ for Delphi & C++Builder                                                 }
{ version 1.3                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{            copyright � 1999 - 2002                                      }
{            Email : info@tmssoftware.com                                 }
{            Website : http://www.tmssoftware.com/                        }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit htmlhint;

{$I TMSDEFS.INC}
{$DEFINE REMOVESTRIP}
{$DEFINE REMOVEDRAW}

interface

uses
  Classes, Windows, Graphics, Messages, Controls, Forms, SysUtils,
  PictureContainer;

const
  HINTROUNDING = 16;

type
  { THTMLHint }
  EHTMLHintError = class(Exception);

  THintStyle = (hsRectangle,hsRounded);

  THTMLHint = class(TComponent)
  private
    FImages:TImageList;
    FHintFont: TFont;
    FHintInfo: THintInfo;
    FHintColor: TColor;
    FOnShowHint: TShowHintEvent;
    FURLColor: TColor;
    FImageCache: THTMLPictureCache;
    FEllipsis: Boolean;
    FShadowOffset: Integer;
    FShadowColor: TColor;
    FContainer: TPictureContainer;
    FYMargin: Integer;
    FXMargin: Integer;
    FHintStyle: THintStyle;
    FMaxWidth: Integer;
    procedure GetHintInfo(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure SetHintColor(const Value: TColor);
    procedure SetHintFont(const Value: TFont);
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Ellipsis: Boolean read FEllipsis write FEllipsis;
    property HintColor: TColor read FHintColor write SetHintColor default clInfoBk;
    property HintFont: TFont read FHintFont write SetHintFont;
    property HintStyle: THintStyle read FHintStyle write FHintStyle;
    property Images:TImageList read FImages write FImages;
    property MaxWidth: Integer read FMaxWidth write FMaxWidth;
    property PictureContainer: TPictureContainer read FContainer write FContainer;
    property ShadowColor: TColor read FShadowColor write FShadowColor default clGray;
    property ShadowOffset: Integer read FShadowOffset write FShadowOffset default 1;
    property URLColor: TColor read FURLColor write FURLColor default clBlue;
    property XMargin: Integer read FXMargin write FXMargin;
    property YMargin: Integer read FYMargin write FYMargin;
    property OnShowHint: TShowHintEvent read FOnShowHint write FOnShowHint;
  end;

  { THTMLHintWindow }
  THTMLHintWindow = class(THintWindow)
  private
    FHint: THTMLHint;
    FTextHeight, FTextWidth: Integer;
    function FindHintControl: THTMLHint;
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); Override;
  published
  end;


implementation

uses
  Commctrl, ShellApi {$IFDEF DELPHI4_LVL} ,Imglist {$ENDIF};

var
  HintControl: TControl; { control the tooltip belongs to }
  HintMaxWidth: Integer; { max width of the tooltip }

{$I HTMLENGO.PAS}

constructor THTMLHint.Create(AOwner: TComponent);
var
  I,Instances:Integer;

begin
  inherited Create(AOwner);
  if not (Owner is TForm) then
    raise EHTMLHintError.Create('Control parent must be a form!');

  Instances := 0;
  for I := 0 to Owner.ComponentCount - 1 do
    if (Owner.Components[I] is THTMLHint) then Inc(Instances);
  if (Instances > 1) then
    raise EHTMLHintError.Create('Only one instance of THTMLHint allowed on form');

  if not (csDesigning in ComponentState) then
  begin
    HintWindowClass := THTMLHintWindow;
    with Application do
    begin
      ShowHint := not ShowHint;
      ShowHint := not ShowHint;
      OnShowHint := GetHintInfo;
    end;
  end;

  FImageCache := THTMLPictureCache.Create;

  FHintColor := clInfoBK;
  FHintFont := TFont.Create;
  FHintFont.Color := clInfoText;
  FHintFont.Name:='Tahoma';
  FShadowOffset := 1;
  FShadowColor := clGray;
end;

destructor THTMLHint.Destroy;
begin
  FHintFont.Free;
  FImageCache.Free;
  inherited Destroy;
end;

procedure THTMLHint.GetHintInfo(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  HintInfo.HintColor := FHintColor;
  if MaxWidth <> 0 then
    HintInfo.HintMaxWidth := MaxWidth; 
  if Assigned(FOnShowHint) then
    FOnShowHint(HintStr, CanShow, HintInfo);
  HintControl := HintInfo.HintControl;
  HintMaxWidth := HintInfo.HintMaxWidth;
  FHintInfo := HintInfo;
end;

{ THTMLHintWindow }

function THTMLHintWindow.FindHintControl: THTMLHint;
var
  I: Integer;
begin
  Result := nil;

  with Application.MainForm do
  for I := 0 to ComponentCount-1 do
    if Components[I] is THTMLHint then begin
      Result := THTMLHint(Components[I]);
      Break;
    end;
end;

procedure THTMLHintWindow.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;

begin
  inherited CreateParams(Params);
  Params.Style := Params.Style - WS_BORDER;
  if (Win32Platform = VER_PLATFORM_WIN32_NT) and
     ((Win32MajorVersion > 5) or
      ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1))) then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure THTMLHintWindow.Paint;
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
  Brush := CreateSolidBrush(ColorToRGB(FHint.FHintInfo.HintColor));

  SaveBrush := SelectObject(DC, Brush);
  FillRect(DC, R, Brush);
  SelectObject(DC, SaveBrush);
  DeleteObject(Brush);

  // Border
  if FHint.FHintStyle = hsRectangle then
    DCFrame3D(R, cl3DLight, cl3DDkShadow)
  else
    begin
      Canvas.Pen.Color := clGray;
      Canvas.Brush.Style := bsClear;
      Canvas.RoundRect(R.Left,R.Top,R.Right-1,R.Bottom-1,HINTROUNDING,HINTROUNDING);
    end;

  // Caption
  RD.Left := R.Left + 4 + FHint.FXMargin;
  RD.Top := R.Top + (R.Bottom - R.Top - FTextHeight) div 2 + FHint.FYMargin;
  RD.Bottom := RD.Top + FTextHeight + 8;
  RD.Right := RD.Right - 4;
  Canvas.Brush.Color := FHint.FHintInfo.HintColor;

  HTMLDrawEx(Canvas,Caption,rd,FHint.FImages,0,0,-1,-1,FHint.FShadowOffset,False,False,False,False,True,False,not FHint.Ellipsis,
             1.0,FHint.FURLColor,clNone,clNone,FHint.FShadowColor,Anchor,Stripped,FocusAnchor,XSize,YSize,HyperLinks,MouseLink,hr,FHint.FImageCache,FHint.FContainer);
end;

procedure THTMLHintWindow.ActivateHint(Rect: TRect; const AHint: string);
var
  dx, dy : Integer;
  Pnt: TPoint;
  II: TIconInfo;
  XSize,YSize, HyperLinks, MouseLink:integer;
  Anchor,Stripped,FocusAnchor:string;
  hr: TRect;
  rgn:  THandle;
{$IFDEF DELPHI6_LVL}
  Monitor : TMonitor;
{$ENDIF}

  // Scans a cursor bitmap to get its real height
  function RealCursorHeight(Cur: HBITMAP): Integer;
  var
    Bmp: TBitmap;
    x, y: Integer;
    found: Boolean;
  begin
    Result := 0;
    Bmp := TBitmap.Create;
    Bmp.Handle := Cur;

    // Scan the "normal" cursor mask (lines 1 to 32)
    for y := 31 downto 0 do
    begin
      for x := 0 to 31 do
      begin
        Found := GetPixel(Bmp.Canvas.Handle,x,y)=DWORD(ColorToRGB(clBlack));
        if Found then Break;
      end;

      if Found then
      begin
        Result := y - Integer(II.yHotSpot);
        Break;
      end;
    end;

    // No result? Then scan the inverted mask (lines 32 to 64)
    if not Found then
    for y := 63 downto 31 do begin
      for x := 0 to 31 do begin
        Found := GetPixel(Bmp.Canvas.Handle,x,y)=DWORD(ColorToRGB(clWhite));
        if Found then Break;
      end;

      if Found then begin
        Result := y - integer(II.yHotSpot)-32;
        Break;
      end;
    end;
    Bmp.Free;

    // No result yet?! Ok, let's say the cursor height is 32 pixels...
    if not Found then
      Result := 32;
  end;

begin
  if IsWindowVisible(Handle) then
    ShowWindow(Handle, SW_HIDE);

  Caption := AHint;
  FHint := FindHintControl;

  if not Assigned(FHint) then
    Exit;

  dx := 16;
  dy := 4;

  Canvas.Font.Assign(FHint.FHintFont);
  Color := FHint.FHintColor;


  with Rect do
  begin
    // Calculate width and height
    Rect.Right := Rect.Left + HintMaxWidth - dx;

    HTMLDrawEx(Canvas,AHint,Rect,FHint.FImages,0,0,-1,-1,1,False,True,False,False,True,False,not FHint.Ellipsis,
             1.0,FHint.FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,XSize,YSize,HyperLinks,MouseLink,hr,FHint.FImageCache,FHint.FContainer);

    FTextWidth := XSize + (2 * FHint.XMargin);
    Right := Left + FTextWidth + dx;

    FTextHeight := YSize + (2 * FHint.YMargin);
    Bottom := Top + FTextHeight + dy;

    // Calculate position
    Pnt := FHint.FHintinfo.HintPos;
    Left := Pnt.X;
    Top := Pnt.Y;
    Right := Right - Left + Pnt.X;
    Bottom := Bottom - Top + Pnt.Y;

    // Make sure the tooltip is completely visible

    {$IFDEF DELPHI6_LVL}
    Monitor := Screen. MonitorFromPoint (Pnt);

    if Right - Monitor. Left > Monitor. Width then
    begin
      Left := Monitor. Left + Monitor. Width - Right + Left - 2;
      Right := Left + FTextWidth + dx;
    end;

    if Bottom - Monitor. Top > Monitor. Height then
    begin
      Bottom := Monitor. Top + Monitor. Height - 2;
      Top := Bottom - FTextHeight - dy;
    end;
    {$ELSE}

    {$IFDEF DELPHI4_LVL}
    if Right > Screen.DesktopWidth then
    begin
      Left := Screen.DesktopWidth - Right + Left -2;
      Right := Left + FTextWidth + dx;
    end;

    if Bottom > Screen.DesktopHeight then
    begin
      Bottom := Screen.DesktopHeight - 2;
      Top := Bottom - FTextHeight - dy;
    end;
    {$ELSE}
    if Right > GetSystemMetrics(SM_CXSCREEN) then
    begin
      Left := GetSystemMetrics(SM_CXSCREEN) - Right + Left -2;
      Right := Left + FTextWidth + dx;
    end;

    if Bottom > GetSystemMetrics(SM_CYSCREEN) then
    begin
      Bottom := GetSystemMetrics(SM_CYSCREEN) - 2;
      Top := Bottom - FTextHeight - dy;
    end;

    {$ENDIF}
    {$ENDIF}
  end;

  BoundsRect := Rect;

  if not IsWindowVisible(Handle) then
    if FHint.FHintStyle = hsRounded then
    begin
      rgn := CreateRoundRectRgn(0,0,Rect.Right-Rect.Left,Rect.Bottom-Rect.Top,HINTROUNDING,HINTROUNDING);
      SetWindowRgn(Handle,rgn,true);
      DeleteObject(rgn);
    end;

  Pnt := ClientToScreen(Point(0, 0));
  SetWindowPos(Handle, HWND_TOPMOST, Pnt.X, Pnt.Y, 0, 0,
               SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
end;


procedure THTMLHint.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FImages) then
    FImages:=nil;

  if (AOperation = opRemove) and (AComponent = FContainer) then
    FContainer := nil;

  inherited;
end;

procedure THTMLHint.SetHintColor(const Value: TColor);
begin
  FHintColor := Value;
end;

procedure THTMLHint.SetHintFont(const Value: TFont);
begin
  FHintFont.Assign(Value);
end;

end.
