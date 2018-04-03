{**************************************************************************}
{ THTMLabel component                                                      }
{ for Delphi 2.0,3.0,4.0,5.0,6.0 + C++Builder 1.0,3.0,4.0,5.0              }
{ version 1.7, August 2001                                                 }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright © 1999-2001                                         }
{            Email : info@tmssoftware.com                                  }
{            Website : http://www.tmssoftware.com/                         }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit HTMLabel;

{$I TMSDEFS.INC}

{$DEFINE REMOVEDRAW}
{$DEFINE HILIGHT}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ComObj, ActiveX, PictureContainer
  {$IFDEF DELPHI4_LVL}
  ,ImgList
  {$ENDIF}
  ;

{$IFNDEF DELPHI3_LVL}
const
  crHandPoint = crUpArrow;
{$ENDIF}

type
  TRichText = string;

  TAnchorClick = procedure (Sender:TObject; Anchor:string) of object;

  TAnchorHintEvent = procedure (Sender:TObject; var Anchor:string) of object;

  TAutoSizeType = (asVertical,asHorizontal,asBoth);

  TVAlignment = (tvaTop,tvaCenter,tvaBottom);

  THTMLabel = class(TCustomLabel)
  private
    { Private declarations }
    FAnchor: string;
    FAutoSizing: Boolean;
    FAutoSizeType: TAutoSizeType;
    FHTMLText: TStringList;
    FAnchorClick: TAnchorClick;
    FAnchorHint: Boolean;
    FAnchorEnter: TAnchorClick;
    FAnchorExit: TAnchorClick;
    FImages: TImageList;
    FImageCache: THTMLPictureCache;
    FUpdateCount: Integer;
    FURLColor: TColor;
    FBevelInner: TPanelBevel;
    FBevelOuter: TPanelBevel;
    FBevelWidth: TBevelWidth;
    FBorderWidth: TBorderWidth;
    FBorderStyle: TBorderStyle;
    FShadowOffset: integer;
    FShadowColor: TColor;
    FHover:boolean;
    FHoverHyperLink: Integer;
    FOldHoverHyperLink: Integer;
    FHoverColor:TColor;
    FHoverFontColor:TColor;
    FVAlignment: TVAlignment;
    FEllipsis: Boolean;
    FCurrHoverRect: TRect;
    FContainer: TPictureContainer;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnAnchorHint: TAnchorHintEvent;
    FXSize: integer;
    FHintShowFull: Boolean;
    FHTMLHint: Boolean;
    {$IFDEF DELPHI4_LVL}
    FILChangeLink: TChangeLink;
    {$ENDIF}
    procedure SetHTMLText(value : TStringList);
    procedure SetImages(value : TImageList);
    procedure SetURLColor(value : TColor);
    procedure SetAutoSizing(value : boolean);
    procedure HTMLChanged(sender:tObject);
    procedure ImageListChanged(sender:TObject);
    procedure SetBevelInner(Value: TPanelBevel);
    procedure SetBevelOuter(Value: TPanelBevel);
    procedure SetBevelWidth(Value: TBevelWidth);
    procedure SetBorderWidth(Value: TBorderWidth);
    procedure SetBorderStyle(Value: TBorderStyle);
    function IsAnchor(x,y: Integer;var hoverrect:trect):string;
    procedure CMHintShow(Var Msg: TMessage); message CM_HINTSHOW;
    procedure CMMouseLeave(Var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(Var Msg: TMessage); message CM_MOUSEENTER;
    procedure SetShadowColor(const Value: TColor);
    procedure SetShadowOffset(const Value: integer);
    procedure SetHover(const Value: boolean);
    procedure SetHoverColor(const Value: TColor);
    procedure SetHoverFontColor(const Value: TColor);
    procedure HoverInvalidate(r:trect);
    function GetText: string;
    procedure SetVAlignment(const Value: TVAlignment);
    procedure SetAutoSizeType(const Value: TAutoSizeType);
    procedure SetEllipsis(const Value: Boolean);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure Paint; override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function GetDisplText:string; virtual;
    procedure UpdateDisplText; virtual;
    function HTMLPaint(Canvas:TCanvas;s:string;fr:TRect;
                       FImages:TImageList;
                       xpos,ypos,focuslink,hoverlink,shadowoffset: Integer;
                       checkhotspot,checkheight,print,selected,blink,hoverstyle:boolean;
                       resfactor:double;
                       urlcolor,hovercolor,hoverfontColor,shadowcolor:TColor;
                       var anchorval,stripval,focusanchor:string;
                       var xsize,ysize,hyperlinks,mouselink: Integer;
                       var hoverrect:TRect):boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Doit;
    property Text:string read GetText;
    property ImageCache: THTMLPictureCache read FImageCache;
    procedure HTMLPrint(Canvas:TCanvas;r:TRect);
    procedure HilightText(HiText: string; DoCase: Boolean);
    procedure UnHilightText;
    procedure MarkText(HiText: string; DoCase: Boolean);
    procedure UnMarkText;
  published
    { Published declarations }
    property Align;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    {$ENDIF}
    property AnchorHint: Boolean read FAnchorHint write FAnchorHint;
    property AutoSizing: Boolean read FAutoSizing write SetAutoSizing;
    property AutoSizeType: TAutoSizeType read FAutoSizeType write SetAutoSizeType;
    property BevelInner: TPanelBevel read FBevelInner write SetBevelInner default bvNone;
    property BevelOuter: TPanelBevel read FBevelOuter write SetBevelOuter default bvNone;
    property BevelWidth: TBevelWidth read FBevelWidth write SetBevelWidth default 1;
    property BorderWidth: TBorderWidth read FBorderWidth write SetBorderWidth default 0;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsNone;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Ellipsis: Boolean read FEllipsis write SetEllipsis;
    property FocusControl;
    property Font;
    property Hint;
    property HintShowFull: Boolean read FHintShowFull write FHintShowFull;
    property Hover:boolean read fHover write SetHover;
    property HoverColor:TColor read fHoverColor write SetHoverColor;
    property HoverFontColor:TColor read FHoverFontColor write SetHoverFontColor;
    property HTMLHint: Boolean read FHTMLHint write FHTMLHint;
    property HTMLText: TStringList read FHTMLText write SetHTMLText;
    property Images: TImageList read FImages write SetImages;
    property ParentShowHint;
    property ParentColor;
    property ParentFont;
    property PictureContainer: TPictureContainer read FContainer write FContainer;
    property PopupMenu;
    property ShadowColor:TColor read fShadowColor write SetShadowColor;
    property ShadowOffset: Integer read fShadowOffset write SetShadowOffset;
    property ShowHint;
    property Transparent;
    property URLColor:TColor read fURLColor write SetURLColor;
    property VAlignment:TVAlignment read fVAlignment write SetVAlignment;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnAnchorClick: TAnchorClick read FAnchorClick write FAnchorClick;
    property OnAnchorEnter: TAnchorClick read FAnchorEnter write FAnchorEnter;
    property OnAnchorExit: TAnchorClick read FAnchorExit write FAnchorExit;
    property OnAnchorHint: TAnchorHintEvent read FOnAnchorHint write FOnAnchorHint;
    property OnMouseLeave: TNotifyEvent read fOnMouseLeave write fOnMouseLeave;
    property OnMouseEnter: TNotifyEvent read fOnMouseEnter write fOnMouseEnter;
  end;


implementation
uses
 commctrl, shellapi ;

{$I HTMLENGO.PAS}

procedure THTMLabel.BeginUpdate;
begin
  inc(FUpdateCount);
end;

procedure THTMLabel.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
    begin
      Invalidate;
    end;
  end;
end;


procedure THTMLabel.Paint;
var
  r,mr:trect;
  x,y,hyperlinks,mouselink: Integer;
  s,anchor,stripped,focusanchor:string;
  TopColor, BottomColor: TColor;
  pt:tpoint;

  procedure AdjusTColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

begin
  Caption := '';
  inherited Paint;

  if FUpdateCount > 0 then
    Exit;

  R := GetClientRect;

  if BevelOuter <> bvNone then
  begin
    AdjusTColors(BevelOuter);
    Frame3D(Canvas, R, TopColor, BottomColor, BevelWidth);
  end;
    Frame3D(Canvas, R, Color, Color, BorderWidth);

  if BevelInner <> bvNone then
  begin
    AdjusTColors(BevelInner);
    Frame3D(Canvas, R, TopColor, BottomColor, BevelWidth);
  end;

  if (FBorderStyle = bsSingle) and (FBorderWidth>0) then
  begin
    Canvas.Pen.Width := FBorderWidth;
    Canvas.Pen.Color := clBlack;
    Canvas.Rectangle(r.left,r.top,r.right,r.bottom);
  end;

  if (BevelInner <> bvNone) or (BevelOuter <> bvNone) then
  begin
    InflateRect(r,-BevelWidth,-BevelWidth);
  end;

  if FBorderStyle = bsSingle then
  begin
    InflateRect(r,-BorderWidth,-BorderWidth);
  end;

  s := GetDisplText;

  Canvas.Brush.Color := self.Color;

  if FAutoSizing then
  begin
    if ((Align = alLeft) or (Align = alRight) or (Align = alNone)) and
       (FAutoSizeType in [asHorizontal,asBoth]) then
      r.Right := r.Right + $FFFF;

    if ((Align = alTop) or (Align = alBottom) or (Align = alNone)) and
       (FAutoSizeType in [asVertical,asBoth]) then
      r.Bottom := r.Bottom + $FFFF;
  end;

  GetCursorPos(pt);
  pt := self.ScreenToClient(pt);

  if FVAlignment in [tvaCenter,tvaBottom] then
  begin
    HTMLPaint(Canvas,s,r,FImages,pt.x,pt.y,-1,FHoverHyperLink,FShadowOffset,True,False,False,False,False,FHover,1.0,fURLcolor,FHoverColor,FHoverFontColor,FShadowColor,anchor,stripped,focusanchor,x,y,hyperlinks,mouselink,mr);
    if y < Height then
    case FVAlignment of
    tvaCenter:r.Top := r.Top+((r.Bottom - r.Top - y) shr 1);
    tvaBottom:r.Top := r.Bottom - y;
    end;
  end;

  HTMLPaint(Canvas,s,r,FImages,pt.x,pt.y,-1,FHoverHyperLink,FShadowOffset,False,False,False,False,False,FHover,
            1.0,FURLcolor,FHoverColor,FHoverFontColor,FShadowColor,Anchor,Stripped,FocusAnchor,x,y,HyperLinks,mouselink,mr);

  if FAutoSizing then
  begin
    if ((Align = alTop) or (Align = alBottom) or (Align = alNone)) and
       (FAutoSizeType in [asVertical,asBoth]) then
      if (y + 6 <> Height) then Height := y + 6;
    if ((Align = alLeft) or (Align = alRight) or (Align = alNone)) and
       (FAutoSizeType in [asHorizontal,asBoth]) then
      if (x + 6 <> Width) then Width := x + 6;
  end;

end;

constructor THTMLabel.Create(AOwner: TComponent);
begin
  inherited;
  FAutoSizing := False;
  FImageCache := THTMLPictureCache.Create;
  FHTMLText := TStringList.Create;
  FHTMLText.OnChange := HTMLChanged;
  {$IFDEF DELPHI4_LVL}
  FILChangeLink := TChangeLink.Create;
  FILChangeLink.OnChange := ImageListChanged;
  {$ENDIF}
  Caption := '';
  AutoSize := False;
  FUpdateCount := 0;
  FURLColor := clBlue;
  FShadowColor := clGray;
  FShadowOffset := 2;
  BevelWidth := 1;
  FBorderStyle := bsNone;
  FHover := False;
  FHoverHyperLink := -1;
  FHoverColor := clNone;
  FHoverFontColor := clNone;
end;

destructor THTMLabel.Destroy;
begin
  FImageCache.ClearPictures;
  FImageCache.Free;
  FHTMLText.Free;
  {$IFDEF DELPHI4_LVL}
  FILChangeLink.Free;
  {$ENDIF}
  inherited;
end;

procedure THTMLabel.HTMLChanged(sender:TObject);
begin
  FImageCache.Clear;
  Invalidate;
end;

procedure THTMLabel.ImageListChanged(sender:TObject);
begin
  Invalidate;
end;

procedure THTMLabel.SetAutoSizing(Value : boolean);
begin
  FAutoSizing := Value;
  if FAutoSizing then
  begin
    if (Align = alLeft) or (Align = alRight) then
      Width := 6;
    if (Align = alTop) or (Align = alBottom) then
      Height := 6;
  end;
  Invalidate;
end;


procedure THTMLabel.SetHTMLText(Value: TStringlist);
begin
  if Assigned(Value) then
    FHTMLText.Text := CRLFStrip(Value.Text,False);
  UpdateDisplText;
end;

procedure THTMLabel.UpdateDisplText;
begin
  Invalidate;
end;

procedure THTMLabel.SetImages(value:TImagelist);
begin
  FImages := Value;
{$IFDEF DELPHI4_LVL}
  if Assigned(FImages) then
    FImages.RegisterChanges(FILChangeLink);
{$ENDIF}    
  Invalidate;
end;

procedure THTMLabel.SetURLColor(value:TColor);
begin
  if Value <> FURLColor then
  begin
    FURLColor := Value;
    Invalidate;
  end;
end;

procedure THTMLabel.Loaded;
begin
  inherited;
  Caption := '';
end;

function THTMLabel.IsAnchor(x,y: Integer;var HoverRect:TRect):string;
var
  r: TRect;
  xsize,ysize: Integer;
  s: string;
  Anchor,Stripped,Focusanchor: string;
  hl: Integer;

begin
  r := ClientRect;

  if (bevelInner <> bvNone) or (bevelOuter <> bvNone) then
  begin
    Inflaterect(r,-BevelWidth,-BevelWidth);
  end;

  if FBorderStyle = bsSingle then
  begin
    InflateRect(r,-BorderWidth,-BorderWidth);
  end;

  s := GetDisplText;

  Anchor := '';
  HoverRect := Rect(-1,-1,-1,-1);

  if FVAlignment in [tvaCenter,tvaBottom] then
  begin
    HTMLPaint(Canvas,s,r,FImages,x,y,-1,-1,FShadowOffset,True,False,False,False,False,FHover,1.0,
      fURLcolor,FHoverColor,FHoverFontColor,FShadowColor,anchor,stripped,focusanchor,XSize,YSize,hl,FHOverHyperLink,HoverRect);
    if y < Height then
    case FVAlignment of
    tvaCenter:r.Top := r.Top+((r.Bottom - r.Top - y) shr 1);
    tvaBottom:r.Top := r.Bottom - y;
    end;
  end;


  if HTMLPaint(Canvas,s,r,FImages,x,y,-1,-1,FShadowOffset,True,False,False,False,False,FHover,1.0,
     clWhite,clNone,clNone,clNone,Anchor,Stripped,FocusAnchor,XSize,YSize,hl,FHoverHyperlink,HoverRect) then
    Result := Anchor
  else
    FHoverHyperLink := -1;
end;

procedure THTMLabel.HoverInvalidate(r:trect);
begin
  if Assigned(Parent) and (Parent is TWinControl) then
  begin
    Offsetrect(r,self.Left,self.Top);
    Invalidaterect((Parent as TWinControl).Handle,@r,True);
  end;
end;

procedure THTMLabel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Anchor:string;
  hr: TRect;
begin
  Anchor := IsAnchor(x,y,hr);

  if Anchor <> '' then
  begin
    if (FAnchor <> Anchor) or not Equalrect(FCurrHoverRect,hr) or (FHoverHyperlink = -1) then
    begin
      outputdebugstring(pchar(inttostr(fhoverhyperlink)));

      if FHover then
      begin
        if hr.Left <> -1 then
          HoverInvalidate(FCurrHoverRect)
      end;
    end;

    if (Cursor = crDefault) or (FAnchor <> Anchor) or (FOldHoverHyperLink <> FHoverHyperLink) then
    begin
      if FAnchorHint then
        Application.CancelHint;
      Cursor := crHandPoint;

      if Assigned(FAnchorEnter) then
        FAnchorEnter(self,anchor);

      if FHover then
      begin
        if hr.Left <> -1 then
          HoverInvalidate(FCurrHoverRect)
        else
          Invalidate;
      end;
    end;

     FAnchor := Anchor;
     FOldHoverHyperLink := FHoverHyperLink;
     FCurrHoverRect := hr;

     if FHover then
       HoverInvalidate(FCurrHoverRect)
  end
  else
  begin
    if self.Cursor = crHandPoint then
    begin
      self.Cursor := crDefault;
      if Assigned(FAnchorExit) then
        FAnchorExit(self,anchor);

      if FHover then
      begin
        if FCurrHoverRect.Left <> -1 then
          HoverInvalidate(FCurrHoverRect)
        else
          Invalidate;
      end;

      FCurrHoverRect := hr;
      if FHover then
        HoverInvalidate(FCurrHoverRect)

    end;
  end;
end;

procedure THTMLabel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Anchor:string;
  hr: TRect;
begin
  inherited MouseDown(Button,Shift,X,Y);

  Anchor := IsAnchor(X,Y,hr);
  if Anchor <> '' then
  begin
    if (Pos('://',Anchor) > 0) or (Pos('mailto:',Anchor) > 0) then
     shellexecute(0,'open',PChar(Anchor),nil,nil,SW_NORMAL)
    else
    begin
      if Assigned(FAnchorClick) then
         FAnchorClick(self,Anchor);
    end;
  end;
end;

procedure THTMLabel.SetBevelInner(Value: TPanelBevel);
begin
  FBevelInner := Value;
  Invalidate;
end;

procedure THTMLabel.SetBevelOuter(Value: TPanelBevel);
begin
  FBevelOuter := Value;
  Invalidate;
end;

procedure THTMLabel.SetBevelWidth(Value: TBevelWidth);
begin
  FBevelWidth := Value;
  Invalidate;
end;

procedure THTMLabel.SetBorderWidth(Value: TBorderWidth);
begin
  FBorderWidth := Value;
  Invalidate;
end;

procedure THTMLabel.SetBorderStyle(Value: TBorderStyle);
begin
  FBorderStyle := Value;
  Invalidate;
end;

Procedure THTMLabel.CMHintShow(Var Msg: TMessage);
{$IFDEF DELPHI2_LVL}
type
  PHintInfo = ^THintInfo;
{$ENDIF}
var
  CanShow: Boolean;
  hi: PHintInfo;
  Anchor:string;
  hr:trect;

Begin
  CanShow := True;
  hi := PHintInfo(Msg.LParam);
  Anchor := '';
  
  if FAnchorHint then
  begin
    Anchor := IsAnchor(hi^.cursorPos.x,hi^.cursorpos.y,hr);
    if Anchor <> '' then
    begin
      if Assigned(FOnAnchorHint) then
        FOnAnchorHint(Self,Anchor);

      hi^.HintPos := clienttoscreen(hi^.CursorPos);
      hi^.hintpos.y := hi^.hintpos.y - 10;
      hi^.hintpos.x := hi^.hintpos.x + 10;
      {$IFNDEF DELPHI3_LVL}
      Hint := Anchor;
      {$ELSE}
      hi^.HintStr := Anchor;
      {$ENDIF}
    end
    else

  end;

  if FHintShowFull and not ((Anchor <> '') and FAnchorHint)  then
  begin
    if FHTMLHint then
  {$IFNDEF DELPHI3_LVL}
    Hint := GetDisplText
  {$ELSE}
    hi^.HintStr := GetDisplText
  {$ENDIF}
    else
  {$IFNDEF DELPHI3_LVL}
    Hint := HTMLStrip(GetDisplText);
  {$ELSE}
    hi^.HintStr := HTMLStrip(GetDisplText);
  {$ENDIF}
  end;

  Msg.Result := Ord(Not CanShow);
end;

procedure THTMLabel.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FImages) then
    FImages := nil;

  if (AOperation = opRemove) and (AComponent = FContainer) then
    FContainer := nil;

  inherited;
end;

procedure THTMLabel.SetShadowColor(const Value: TColor);
begin
  FShadowColor := Value;
  Invalidate;
end;

procedure THTMLabel.SetShadowOffset(const Value: integer);
begin
  FShadowOffset := Value;
  Invalidate;
end;

procedure THTMLabel.SetHover(const Value: boolean);
begin
  FHover := Value;
  Invalidate;
end;

procedure THTMLabel.SetHoverColor(const Value: TColor);
begin
  FHoverColor := Value;
  Invalidate;
end;

procedure THTMLabel.SetHoverFontColor(const Value: TColor);
begin
  FHoverFontColor := Value;
  Invalidate;
end;

procedure THTMLabel.CMMouseLeave(var Msg: TMessage);
begin
  if FHover and (FHoverHyperLink <> -1) then
    HoverInvalidate(FCurrHoverRect);
  fHoverHyperLink := -1;
  inherited;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(self);
end;

procedure THTMLabel.CMMouseEnter(var Msg: TMessage);
begin
  inherited;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(self);
end;


function THTMLabel.GetDisplText: string;
var
  i: Integer;
begin
  Result:='';
  for i:=1 to FHTMLText.Count do
    Result := Result + FHTMLText.Strings[i - 1];
end;


function THTMLabel.GetText: string;
begin
  Result := HTMLStrip(GetDisplText);
end;

function THTMLabel.HTMLPaint(canvas: TCanvas; s: string; fr: TRect;
  FImages: TImageList; xpos, ypos, Focuslink, Hoverlink,
  shadowoffset: integer; checkhotspot, checkheight, print, selected, blink,
  hoverstyle: boolean; resfactor: double; urlcolor, hovercolor,
  hoverfontColor, shadowcolor: TColor; var anchorval, stripval,
  focusanchor: string; var xsize, ysize, hyperlinks, mouselink: integer;
  var hoverrect: trect): boolean;
begin
  Result := HTMLDrawEx(Canvas,s,fr,FImages,xpos,ypos,-1,HoverLink,ShadowOffset,checkhotspot,checkheight,print,selected,Blink,
                       Hoverstyle,not FEllipsis,Resfactor,urlcolor,hovercolor,hoverfontColor,shadowcolor,anchorval,stripval,focusanchor,
                       XSize,YSize,HyperLinks,MouseLink,HoverRect,FImageCache,FContainer);
  FXSize := XSize;                     
end;


procedure THTMLabel.HTMLPrint(Canvas: TCanvas;r: TRect);
var
  a,st,fa,s:string;
  xs,ys,hl,ml: Integer;
  mr: TRect;
begin
  s := GetDisplText;
  HTMLPaint(Canvas,s,r,FImages,0,0,-1,-1,1,False,False,True,False,False,False,
            1.0,clBlue,clNone,clNone,clGray,a,st,fa,xs,ys,hl,ml,mr);
end;

procedure THTMLabel.SetVAlignment(const Value: TVAlignment);
begin
  if fVAlignment<>Value then
   begin
    FVAlignment := Value;
    Invalidate;
   end;
end;

procedure THTMLabel.SetAutoSizeType(const Value: TAutoSizeType);
begin
  FAutoSizeType := Value;
  AutoSizing := AutoSizing;
end;

procedure THTMLabel.Doit;
begin
  Paint;
end;

procedure THTMLabel.SetEllipsis(const Value: Boolean);
begin
  if FEllipsis <> Value then
  begin
    FEllipsis := Value;
    Invalidate;
  end;
end;

procedure THTMLabel.HilightText(HiText: string; DoCase: Boolean);
begin
  HTMLText.Text := Hilight(HTMLText.Text, HiText,'hi',DoCase);
end;

procedure THTMLabel.MarkText(HiText: string; DoCase: Boolean);
begin
  HTMLText.Text := Hilight(HTMLText.Text,HiText,'e',DoCase);
end;

procedure THTMLabel.UnHilightText;
begin
  HTMLText.Text := UnHilight(HTMLText.Text,'hi');
end;

procedure THTMLabel.UnMarkText;
begin
  HTMLText.Text := UnHilight(HTMLText.Text,'e');
end;

end.
