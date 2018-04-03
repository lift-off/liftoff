{************************************************************************}
{ THTMLTreeView component                                                }
{ for Delphi & C++Builder                                                }
{ version 1.1                                                            }
{                                                                        }
{ Copyright © 1999-2002                                                  }
{   TMS Software                                                         }
{   Email : info@tmssoftware.com                                         }
{   Web : http://www.tmssoftware.com                                     }
{                                                                        }
{ The source code is given as is. The author is not responsible          }
{ for any possible damage done due to the use of this code.              }
{ The component can be freely used in any application. The complete      }
{ source code remains property of the author and may not be distributed, }
{ published, given or sold in any form as such. No parts of the source   }
{ code can be included in any other component or application without     }
{ written authorization of the author.                                   }
{************************************************************************}

unit htmltv;

{$I TMSDEFS.INC}
{$R HTMLTV.RES}
{$DEFINE REMOVEDRAW}

interface

uses
   Windows, Classes, ComCtrls, Messages, Controls, Graphics, HTMLXPVS,
   PictureContainer;

{$IFNDEF DELPHI3_LVL}
const
  crHandPoint = crUpArrow;
{$ENDIF}


type
  TAnchorClick = procedure(Sender:TObject;Node:TTreeNode;anchor:string) of object;

  TCheckBoxClick = procedure(Sender:TObject;Node:TTreeNode;Check: Boolean) of object;

  TRadioClick = procedure(Sender: TObject; Node: TTreeNode) of object;

  TControlStyle = (csClassic,csFlat,csWinXP,csBorland,csTMS,csGlyph,csTheme);

  THTMLTreeview = class(TCustomTreeView)
  private
    { Private declarations }
    FIndent: Integer;
    FOldCursor: Integer;
    FOldScrollPos: Integer;
    FURLColor: TColor;
    FSelectionColor: TColor;
    FSelectionFontColor: TColor;
    FItemHeight: Integer;
    FOldAnchor: string;
    FAnchorClick: TAnchorClick;
    FAnchorEnter: TAnchorClick;
    FAnchorExit: TAnchorClick;
    FImages:TImageList;
    FOnCheckBoxClick: TCheckBoxClick;
    FControlStyle: TControlStyle;
    FControlColor: TColor;
    FGlyphUnChecked: TBitmap;
    FGlyphChecked: TBitmap;
    FIsWinXP: Boolean;
    FOnRadioClick: TRadioClick;
    FSelectionNFFontColor: TColor;
    FSelectionNFColor: TColor;
    FUpdateCount: Integer;
    FImageCache: THTMLPictureCache;    
    procedure CMDesignHitTest(var message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CNNotify(var message: TWMNotify); message CN_NOTIFY;
    procedure WMRButtonDown(var message: TWMLButtonDown); message WM_RBUTTONDOWN;
    procedure WMLButtonDown(var message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseMove(var message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMHScroll(var message:TMessage); message WM_HSCROLL;
    procedure WMSize(var message:TMessage); message WM_SIZE;
    function GetItemHeight: integer;
    procedure SetItemHeight(const Value: integer);
    procedure SetSelectionColor(const Value: tcolor);
    procedure SetSelectionFontColor(const Value: tcolor);
    procedure SetURLColor(const Value: tcolor);
    procedure SetImages(const Value: TImageList);
    procedure SetControlStyle(const Value: TControlStyle);
    procedure SetControlColor(const Value: TColor);
    procedure SetGlyphChecked(const Value: TBitmap);
    procedure SetGlyphUnChecked(const Value: TBitmap);
    procedure SetSelectionNFColor(const Value: TColor);
    procedure SetSelectionNFFontColor(const Value: TColor);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure KeyPress(var Key: Char); override;
    procedure DrawCheck(ACanvas: TCanvas; R: TRect; State: Boolean);
    procedure DrawRadio(ACanvas: TCanvas; R:TRect;State: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetNodeCheck(Node: TTreeNode; Check: Boolean);
    procedure RemoveNodeCheck(Node: TTreeNode);
    function GetNodeCheck(Node: TTreeNode; var Check: Boolean): Boolean;
    procedure SetRadioButton(Node: TTreeNode; Check: Boolean);
    procedure RemoveRadioButton(Node: TTreeNode);
    function GetRadioButton(Node: TTreeNode; var Check: Boolean): Boolean;
    procedure BeginUpdate;
    procedure EndUpdate;
  published
   { Published declarations }
    {new introduced properties}
    property GlyphChecked: TBitmap read FGlyphChecked write SetGlyphChecked;
    property GlyphUnChecked: TBitmap read FGlyphUnChecked write SetGlyphUnChecked;
    property ControlStyle: TControlStyle read FControlStyle write SetControlStyle;
    property ControlColor: TColor read FControlColor write SetControlColor;
    property HTMLImages: TImageList read FImages write SetImages;
    property ItemHeight: Integer read GetItemHeight write SetItemHeight;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor;
    property SelectionFontColor: TColor read FSelectionFontColor write SetSelectionFontColor;
    property SelectionNFColor: TColor read FSelectionNFColor write SetSelectionNFColor;
    property SelectionNFFontColor: TColor read FSelectionNFFontColor write SetSelectionNFFontColor;

    property URLColor: TColor read fURLColor write SetURLColor;
    property OnAnchorClick: TAnchorClick read FAnchorClick write FAnchorClick;
    property OnAnchorEnter: TAnchorClick read FAnchorEnter write FAnchorEnter;
    property OnAnchorExit: TAnchorClick read FAnchorExit write FAnchorExit;
    property OnCheckBoxClick: TCheckBoxClick read FOnCheckBoxClick write FOnCheckBoxClick;
    property OnRadioClick: TRadioClick read FOnRadioClick write FOnRadioClick;
    {reintroduced properties}
    property Align;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property AutoExpand;
    property BiDiMode;
    property BorderWidth;
    property ChangeDelay;
    property Constraints;
    property DragKind;
    property HotTrack;
    property ParentBiDiMode;
    property RowSelect;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF}
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    //property Images;
    property Indent;
    property Items;
    {$IFDEF DELPHI6_LVL}
    property MultiSelect;
    {$ENDIF}
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RightClickSelect;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property ShowRoot;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    // property ToolTips;
    property Visible;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnCollapsing;
    property OnCollapsed;
    property OnCompare;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanding;
    property OnExpanded;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;


implementation

uses
  Commctrl, shellapi, sysutils {$IFDEF DELPHI4_LVL} ,imglist {$ENDIF};


{$IFNDEF DELPHI4_LVL}
const
  NM_CUSTOMDRAW            = NM_FIRST-12;

  CDDS_PREPAINT           = $00000001;
  CDDS_POSTPAINT          = $00000002;
  CDDS_PREERASE           = $00000003;
  CDDS_POSTERASE          = $00000004;
  CDDS_ITEM               = $00010000;
  CDDS_ITEMPREPAINT       = CDDS_ITEM or CDDS_PREPAINT;
  CDDS_ITEMPOSTPAINT      = CDDS_ITEM or CDDS_POSTPAINT;
  CDDS_ITEMPREERASE       = CDDS_ITEM or CDDS_PREERASE;
  CDDS_ITEMPOSTERASE      = CDDS_ITEM or CDDS_POSTERASE;
  CDDS_SUBITEM            = $00020000;

  // itemState flags
  CDIS_SELECTED       = $0001;
  CDIS_GRAYED         = $0002;
  CDIS_DISABLED       = $0004;
  CDIS_CHECKED        = $0008;
  CDIS_FOCUS          = $0010;
  CDIS_DEFAULT        = $0020;
  CDIS_HOT            = $0040;
  CDIS_MARKED         = $0080;
  CDIS_INDETERMINATE  = $0100;

  CDRF_DODEFAULT          = $00000000;
  CDRF_NEWFONT            = $00000002;
  CDRF_SKIPDEFAULT        = $00000004;
  CDRF_NOTIFYPOSTPAINT    = $00000010;
  CDRF_NOTIFYITEMDRAW     = $00000020;
  CDRF_NOTIFYSUBITEMDRAW  = $00000020;  // flags are the same, we can distinguish by context
  CDRF_NOTIFYPOSTERASE    = $00000040;

  TVM_GETITEMHEIGHT         = TV_FIRST + 28;
  TVM_SETITEMHEIGHT         = TV_FIRST + 27;

type
  tagNMCUSTOMDRAWINFO = packed record
    hdr: TNMHdr;
    dwDrawStage: DWORD;
    hdc: HDC;
    rc: TRect;
    dwItemSpec: DWORD;  // this is control specific, but it's how to specify an item.  valid only with CDDS_ITEM bit set
    uItemState: UINT;
    lItemlParam: LPARAM;
  end;
  PNMCustomDraw = ^TNMCustomDraw;
  TNMCustomDraw = tagNMCUSTOMDRAWINFO;

  tagNMTVCUSTOMDRAW = packed record
    nmcd: TNMCustomDraw;
    clrText: COLORREF;
    clrTextBk: COLORREF;
    iLevel: Integer;
  end;
  PNMTVCustomDraw = ^TNMTVCustomDraw;
  TNMTVCustomDraw = tagNMTVCUSTOMDRAW;

  TCustomDrawTarget = (dtControl, dtItem, dtSubItem);
  TCustomDrawStage = (cdPrePaint, cdPostPaint, cdPreErase, cdPostErase);
  TCustomDrawState = set of (cdsSelected, cdsGrayed, cdsDisabled, cdsChecked,
    cdsFocused, cdsDefault, cdsHot, cdsMarked, cdsIndeterminate);
  

function TreeView_SetItemHeight(hwnd: HWND; iHeight: Integer): Integer;
begin
  Result := SendMessage(hwnd, TVM_SETITEMHEIGHT, iHeight, 0);
end;

function TreeView_GetItemHeight(hwnd: HWND): Integer;
begin
  Result := SendMessage(hwnd, TVM_GETITEMHEIGHT, 0, 0);
end;

{$ENDIF}

{$I HTMLENGO.PAS}

procedure THTMLTreeview.CMDesignHitTest(var message: TCMDesignHitTest);
begin
  if htOnItem in GetHitTestInfoAt(message.XPos,message.YPos) then
    message.Result := 1
  else
    message.Result := 0;
end;


procedure THTMLTreeview.DrawRadio(ACanvas: TCanvas; R:TRect;State: Boolean);
var
  DrawState: Integer;
  DrawRect: TRect;
  BMP: TBitmap;
  HTheme: THandle;
  OldColor: TColor;
begin
  case ControlStyle of
  csClassic,csFlat:
    begin
      DrawState := DFCS_BUTTONRADIO;

      if State then
        DrawState := DrawState or DFCS_CHECKED;

      if ControlStyle = csFlat then
        DrawState := DrawState or DFCS_FLAT;

      DrawRect.Left := R.Left + (R.Right - R.Left - 12) div 2;
      DrawRect.Top:= R.Top + (R.Bottom - R.Top - 12) div 2;
      DrawRect.Right := DrawRect.Left + 12;
      DrawRect.Bottom := DrawRect.Top + 12;

      DrawFrameControl(ACanvas.Handle,DrawRect,DFC_BUTTON,DrawState);
    end;
  csTMS:
    begin
      Bmp := TBitmap.Create;
      if State then
        Bmp.LoadFromResourceName(hinstance,'TVRAD01')
      else
        Bmp.LoadFromResourceName(hinstance,'TVRAD02');

      Bmp.Transparent := True;
      Bmp.TransparentMode := tmAuto;

      ACanvas.Draw(R.Left,R.Top,bmp);
      Bmp.free;
    end;
  csGlyph:
    begin
      if State and not GlyphChecked.Empty then
      begin
        GlyphChecked.Transparent := True;
        GlyphChecked.TransparentMode := tmAuto;
        ACanvas.Draw(R.Left,R.Top,GlyphChecked);
      end;

      if not State and not GlyphUnChecked.Empty then
      begin
        GlyphUnChecked.Transparent := True;
        GlyphUnChecked.TransparentMode := tmAuto;
        ACanvas.Draw(R.Left,R.Top,GlyphUnChecked);
      end;
    end;
  csTheme:
    begin
      if FIsWinXP then
      begin
        HTheme := OpenThemeData(Self.Handle,'button');

        r := Rect(R.Left, R.Top, R.Left + 14, R.Top + 14);

        if State then
          DrawThemeBackground(HTheme,ACanvas.Handle, BP_RADIOBUTTON,RBS_CHECKEDNORMAL,@r,nil)
        else
          DrawThemeBackground(HTheme,ACanvas.Handle, BP_RADIOBUTTON,RBS_UNCHECKEDNORMAL,@r,nil);

        CloseThemeData(HTheme);
      end;
    end;
  csWinXP:
    begin
      Bmp := TBitmap.Create;
      if State then
        Bmp.LoadFromResourceName(hinstance,'TVRAD03')
      else
        Bmp.LoadFromResourceName(hinstance,'TVRAD04');

      Bmp.Transparent := True;
      Bmp.TransparentMode := tmAuto;

      ACanvas.Draw(R.Left,R.Top,bmp);																									// <PI>
      Bmp.free;
    end;

  csBorland:
    begin
      OldColor := ACanvas.Brush.Color;

      ACanvas.Brush.Color := clBtnFace;

      ACanvas.Polygon([Point(r.Left + 2,r.Top + 8),
                      Point(r.Left + 8,r.Top + 2),
                      Point(r.Left + 14,r.Top + 8),
                      Point(r.Left + 8,r.Top + 14)]);

      if State then
        ACanvas.Pen.Color := clGray
      else
        ACanvas.Pen.Color := clWhite;

      ACanvas.MoveTo(r.Left + 8,r.Top + 14);
      ACanvas.LineTo(r.Left + 2,r.Top + 8);
      ACanvas.LineTo(r.Left + 8,r.Top + 2);

      if State then
        ACanvas.Pen.Color := clWhite
      else
        ACanvas.Pen.Color := clGray;

      ACanvas.LineTo(r.Left + 14,r.Top + 8);
      ACanvas.LineTo(r.Left + 8,r.Top + 14);

      ACanvas.Brush.Color := clRed;
      ACanvas.Pen.Color := clRed;

      if State then
        ACanvas.Polygon([Point(r.Left + 6,r.Top + 8),
                        Point(r.Left + 8,r.Top + 6),
                        Point(r.Left + 10,r.Top + 8),
                        Point(r.Left + 8,r.Top + 10)]);

      ACanvas.Brush.Color := OldColor;

    end;
  end;
end;



procedure THTMLTreeview.DrawCheck(ACanvas: TCanvas; R:TRect;State: Boolean);
var
  DrawState: Integer;
  DrawRect: TRect;
  BMP: TBitmap;
  HTheme: THandle;
begin
  case ControlStyle of
  csClassic,csFlat:
    begin
      if State then
        DrawState := DFCS_BUTTONCHECK or DFCS_CHECKED
      else
        DrawState := DFCS_BUTTONCHECK;

      if ControlStyle = csFlat then
        DrawState := DrawState or DFCS_FLAT;

      DrawRect.Left := R.Left + (R.Right - R.Left - 14) div 2;
      DrawRect.Top:= R.Top + (R.Bottom - R.Top - 14) div 2;
      DrawRect.Right := DrawRect.Left + 14;
      DrawRect.Bottom := DrawRect.Top + 14;

      DrawFrameControl(ACanvas.Handle,DrawRect,DFC_BUTTON,DrawState);
    end;
  csTMS:
    begin
      Bmp := TBitmap.Create;
      if State then
        Bmp.LoadFromResourceName(hinstance,'TVCHK01')
      else
        Bmp.LoadFromResourceName(hinstance,'TVCHK02');

      Bmp.Transparent := True;
      Bmp.TransparentMode := tmAuto;

      ACanvas.Draw(R.Left,R.Top,bmp);
      Bmp.free;
    end;
  csGlyph:
    begin
      if State and not GlyphChecked.Empty then
      begin
        GlyphChecked.Transparent := True;
        GlyphChecked.TransparentMode := tmAuto;
        ACanvas.Draw(R.Left,R.Top,GlyphChecked);
      end;

      if not State and not GlyphUnChecked.Empty then
      begin
        GlyphUnChecked.Transparent := True;
        GlyphUnChecked.TransparentMode := tmAuto;
        ACanvas.Draw(R.Left,R.Top,GlyphUnChecked);
      end;
    end;
  csTheme:
    begin
      if FIsWinXP then
      begin
        HTheme := OpenThemeData(Self.Handle,'button');

        r := Rect(R.Left, R.Top, R.Left + 14, R.Top + 14);

        if State then
          DrawThemeBackground(HTheme,ACanvas.Handle, BP_CHECKBOX,CBS_CHECKEDNORMAL,@r,nil)
        else
          DrawThemeBackground(HTheme,ACanvas.Handle, BP_CHECKBOX,CBS_UNCHECKEDNORMAL,@r,nil);

        CloseThemeData(HTheme);
      end;
    end;
  csWinXP:
    begin
      Bmp := TBitmap.Create;
      if State then
        Bmp.LoadFromResourceName(hinstance,'TVCHK03')
      else
        Bmp.LoadFromResourceName(hinstance,'TVCHK04');

      Bmp.Transparent := True;
      Bmp.TransparentMode := tmAuto;

      ACanvas.Draw(R.Left,R.Top,bmp);																									// <PI>
      Bmp.free;
    end;

  csBorland:
    begin
      if Enabled then
        ACanvas.Brush.Color := clBtnFace
      else
        ACanvas.Brush.Color := clBtnShadow;

      ACanvas.Pen.Color := clBtnFace;
      ACanvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
      ACanvas.Pen.Color := clBtnHighLight;
      ACanvas.MoveTo(R.Left,R.Bottom);
      ACanvas.LineTo(R.Left,R.Top);
      ACanvas.LineTo(R.Right,R.Top);
      ACanvas.Pen.Color := clBtnShadow;
      ACanvas.LineTo(R.Right,R.Bottom);
      ACanvas.LineTo(R.Left,R.Bottom);

      if State then
      begin
        ACanvas.Pen.Color := FControlColor;
        ACanvas.Pen.Width := 1;
        Dec(R.Top);
        Dec(R.Bottom);
        ACanvas.MoveTo(R.Left + 2,R.Top + 14 div 2 + 1);
        ACanvas.LineTo(R.Left + 2,R.Bottom - 1);
        ACanvas.MoveTo(R.Left + 3,R.Top + 14 div 2);
        ACanvas.LineTo(R.Left + 3,R.Bottom - 2);
        ACanvas.MoveTo(R.Left + 2,R.Bottom - 1);
        ACanvas.LineTo(R.Right - 2,R.Top + 3);
        ACanvas.MoveTo(R.Left + 3,R.Bottom - 1);
        ACanvas.LineTo(R.Right - 1,R.Top + 3);
      end;
    end;
  end;
end;


procedure THTMLTreeview.CNNotify(var message: TWMNotify);
var
  TVcd: TNMTVCustomDraw;
  TVdi: TTVDISPINFO;
  canvas: TCanvas;
  a,s,fa: string;
  xsize,ysize,ml,hl,imgs: Integer;
  tn: TTreenode;
  r,cr,hr: TRect;
  urlcol: TColor;
  DefaultDraw: Boolean;
  DrawState: TCustomDrawState;

begin
  if message.NMHdr^.code = TVN_GETDISPINFO then
  begin
    TVDi := PTVDispInfo(pointer(message.nmhdr))^;

    if (tvdi.item.mask and TVIF_TEXT = TVIF_TEXT) then
    begin
      tn := Items.GetNode(tvdi.item.hitem);
      s := HTMLStrip(tn.Text);

      // Compensate for checkbox
      if tn.ImageIndex > 0 then
        s := s + '       ';

      while (length(s) < length(tn.Text)) do
        s := s + ' ';

      strplcopy(tvdi.item.pszText,s,255);

      tvdi.item.Mask := tvdi.item.Mask or TVIF_DI_SETITEM;
      message.Result := 0;
      Exit;
    end;
  end;

  if message.NMHdr^.code = NM_CUSTOMDRAW then
  begin
    FIndent := TreeView_GetIndent(self.Handle);
    TVcd := PNMTVCustomDraw(Pointer(message.NMHdr))^;
    case TVcd.nmcd.dwDrawStage of
    CDDS_PREPAINT:
      message.Result := CDRF_NOTIFYITEMDRAW or CDRF_NOTIFYPOSTPAINT;
    CDDS_ITEMPREPAINT:
      begin
        if  (TVcd.nmcd.uItemState and CDIS_SELECTED=CDIS_SELECTED) then
        begin
          TVcd.nmcd.uItemState := TVcd.nmcd.uItemState and (not CDIS_SELECTED);
          SetTextColor(TVcd.nmcd.hdc,ColorToRGB(Color));
          SetBkColor(TVcd.nmcd.hdc,ColorToRGB(Color));
          TVcd.clrTextBk := ColorToRGB(Color);
          TVcd.clrText := ColorToRGB(Color);
        end
        else
        begin
          SetTextColor(TVcd.nmcd.hdc,ColorToRGB(Color));
          SetBkColor(TVcd.nmcd.hdc,ColorToRGB(Color));
        end;
        message.Result := CDRF_NOTIFYPOSTPAINT;
      end;
    CDDS_ITEMPOSTPAINT:
      begin
        Canvas := TCanvas.Create;
        Canvas.Handle := TVcd.nmcd.hdc;
        Canvas.Font.Assign(self.Font);
        tn := Items.GetNode(HTReeItem(TVcd.nmcd.dwitemSpec));

        TVcd.nmcd.rc.Left := TVcd.nmcd.rc.Left + FIndent * (tn.Level + 1) - GetScrollPos(Handle,SB_HORZ);

        DefaultDraw := True;
        DrawState := [];
        if  (TVcd.nmcd.uItemState and CDIS_SELECTED = CDIS_SELECTED) then
          DrawState := [cdsSelected];

        if  (TVcd.nmcd.uItemState and CDIS_SELECTED = CDIS_SELECTED) then
          DrawState := DrawState + [cdsFocused];

        {$IFDEF DELPHI4_LVL}
        if Assigned(OnCustomDrawItem) then
          OnCustomDrawItem(Self,tn,DrawState,DefaultDraw);
        {$ENDIF}  

        if DefaultDraw and (FUpdateCount = 0) then
        begin
          HTMLDrawEx(Canvas,tn.Text,TVcd.nmcd.rc,TImageList(FImages),0,0,-1,-1,1,False,True,False,False,False,False,False,
            1.0,clBlue,clNone,clNone,clGray,a,s,fa,XSize,YSize,hl,ml,hr,FImageCache,nil);

          r := TVcd.nmcd.rc;
          if (YSize < r.Bottom - r.Top) then
            r.Top := r.Top+((r.Bottom - r.Top - ysize) shr 1);

          if tn.ImageIndex > 0 then
            imgs := 16
          else
            imgs := 0;

          if  (TVcd.nmcd.uItemState and CDIS_SELECTED = CDIS_SELECTED) then
          begin
            hr := TVcd.nmcd.rc;

            if GetFocus = Handle then
            begin
              Canvas.Brush.Color := FSelectionColor;
              Canvas.Pen.Color := FSelectionColor;
              Canvas.Font.Color := FSelectionFontColor;
            end
            else
            begin
              Canvas.Brush.Color := FSelectionNFColor;
              Canvas.Pen.Color := FSelectionNFColor;
              Canvas.Font.Color := FSelectionNFFontColor;
            end;

            hr.Right := hr.Left + XSize + imgs + 4;

            with hr do
              Canvas.Rectangle(Left,Top,Right,Bottom);

            if  (TVcd.nmcd.uItemState and CDIS_FOCUS = CDIS_FOCUS) then
            begin
              Canvas.Pen.Color := clWhite;
              Canvas.Brush.Color := clWhite;
              Canvas.DrawFocusRect(hr);
            end;

            hr.Left := hr.Right;
            hr.Right := TVcd.nmcd.rc.Right;

            Canvas.Pen.Color := Color;
            Canvas.Brush.Color := Color;

            with hr do
              Canvas.Rectangle(Left,Top,Right,Bottom);

            TVcd.nmcd.rc := r;
            TVcd.nmcd.rc.Left := TVcd.nmcd.rc.Left + XSize + 4;
          end
          else
          begin
            Canvas.Brush.Color := Color;
            Canvas.Pen.Color := Color;
            with TVcd.nmcd.rc do
              Canvas.Rectangle(Left,Top,Right,Bottom);
          end;

          TVcd.nmcd.rc := r;
          TVcd.nmcd.rc.Left := TVcd.nmcd.rc.Left + 2;

          urlcol := FURLColor;

          if  (TVcd.nmcd.uItemState and CDIS_SELECTED = CDIS_SELECTED) then
          begin
            if GetFocus = Handle then
            begin
              Canvas.Brush.Color := FSelectionColor;
              Canvas.Pen.Color := FSelectionColor;
              urlcol := FSelectionFontColor;
            end
            else
            begin
              Canvas.Brush.Color := FSelectionNFColor;
              Canvas.Pen.Color := FSelectionNFColor;
              urlcol := FSelectionNFFontColor;
            end;
          end;

          r := TVcd.nmcd.rc;

          if (tn.ImageIndex in [1,2]) then
          begin
            cr := Rect(r.Left,r.Top,r.Left + 14,r.Top + 14);
            DrawCheck(Canvas,cr,tn.ImageIndex = 2);
            r.Left := r.Left + 16;
          end;

          if (tn.ImageIndex in [3,4]) then
          begin
            cr := Rect(r.Left,r.Top,r.Left + 14,r.Top + 14);
            DrawRadio(Canvas,cr,tn.ImageIndex = 4);
            r.Left := r.Left + 16;
          end;

          HTMLDrawEx(Canvas,tn.Text,r,TImageList(FImages),0,0,-1,-1,1,False,False,False,
            ((TVcd.nmcd.uItemState and CDIS_SELECTED) = CDIS_SELECTED),False,False,False,1.0,URLCol,clNone,clNone,clGray,a,s,fa,xsize,ysize,hl,ml,hr,FImageCache,nil);
        end;
        Canvas.Free;
      end;
      else
        message.Result := 0;
    end;
  end
  else inherited;
end;

procedure THTMLTreeview.WMRButtonDown(var message: TWMRButtonDown);
var
  Node: TTreeNode;
begin
  inherited;
  if RightClickSelect then
  begin
    Node := GetNodeAt(message.XPos,message.YPos);
    if Assigned(Node) then
      Node.Selected := True;


  end;
end;

procedure THTMLTreeview.WMLButtonDown(var message: TWMLButtonDown);
var
  Node,PN : TTreeNode;
  r,hr: TRect;
  s,a,fa,hs:string;
  xsize,ysize,ml,hl,i: Integer;
  {$IFNDEF DELPHI4_LVL}
  Canvas: TCanvas;
  {$ENDIF}
begin
  inherited;

  if (csDesigning in ComponentState) then
    Exit;

  Node := GetNodeAt(message.XPos,message.YPos);
  if Assigned(Node) then
  begin
    r := Node.Displayrect(True);

    if (Node.ImageIndex in [1,2]) and
       (Message.XPos < R.Left + 16) and (Message.XPos > R.Left) then
    begin
      if Node.ImageIndex = 1 then
        Node.ImageIndex := 2
      else
        Node.ImageIndex := 1;

      {$IFNDEF DELPHI5_LVL}
      Node.Text := Node.Text;
      {$ENDIF}

      if Assigned(FOnCheckBoxClick) then
        FOnCheckBoxClick(Self,Node,Node.ImageIndex = 2);
      Exit;
    end;

    if (Node.ImageIndex = 3) and Assigned(Node.Parent) and
       (Message.XPos < R.Left + 16) and (Message.XPos > R.Left) then
    begin
      PN := Node.Parent;

      for i := 1 to PN.Count do
      begin
        if (PN.Item[i - 1].Level = Node.Level) then
        begin
          if (PN.Item[i - 1].ImageIndex = 4) then
            PN.Item[i - 1].ImageIndex := 3;

         {$IFNDEF DELPHI5_LVL}
         PN.Item[i - 1].Text := PN.Item[i - 1].Text;
         {$ENDIF}

        end;
      end;
      Node.ImageIndex := 4;

      {$IFNDEF DELPHI5_LVL}
      Node.Text := Node.Text;
      {$ENDIF}

      if Assigned(FOnRadioClick) then
        FOnRadioClick(Self,Node);
    end;

    if (Node.ImageIndex > 0) then
      r.Left := r.Left + 16;

    {$IFNDEF DELPHI4_LVL}
    Canvas := TCanvas.Create;
    Canvas.Handle := GetDC(self.handle);
    {$ENDIF}
    Canvas.Font.Assign(Font);

    hs := Node.Text + ' ';

    HTMLDrawEx(Canvas,hs,r,TImageList(FImages),0,0,0,0,1,True,True,False,
      False,False,False,False,1.0,clBlue,clNone,clNone,clGray,a,s,fa,xsize,ysize,hl,ml,hr,FImageCache,nil);

    if (ysize < r.Bottom - r.Top) then
      r.Top := r.Top + ((r.Bottom - r.Top - ysize) shr 1);

    a := '';
    HTMLDrawEx(Canvas,hs,r,TImageList(FImages),message.XPos,message.Ypos,0,0,1,True,True,False,
      False,False,False,False,1.0,clBlue,clNone,clNone,clGray,a,s,fa,xsize,ysize,hl,ml,hr,FImageCache,nil);

    {$IFNDEF DELPHI4_LVL}
    ReleaseDC(self.Handle,canvas.Handle);
    Canvas.Free;
    {$ENDIF}

    if (a <> '') then
    begin
      if Assigned(FAnchorClick) then
        FAnchorClick(self,Node,a);
    end;
  end;
end;

procedure THTMLTreeView.WMHScroll(var message:TMessage);
begin
  inherited;
  if FOldScrollPos <> GetScrollPos(handle,SB_HORZ) then
  begin
    Invalidate;
    FOldScrollPos := GetScrollPos(handle,SB_HORZ);
  end;
end;


procedure THTMLTreeview.WMMouseMove(var message: TWMMouseMove);
var
  Node : TTreeNode;
  r,hr: TRect;
  s,a,fa,hs: string;
  xsize,ysize,ml,hl: Integer;
  {$IFNDEF DELPHI4_LVL}
  Canvas: TCanvas;
  {$ENDIF}

begin
  Node := GetNodeAt(message.XPos,message.YPos);
  if Assigned(Node) then
  begin
    r := Node.DisplayRect(True);
    a := '';
    {$IFNDEF DELPHI4_LVL}
    Canvas := TCanvas.Create;
    Canvas.Handle := GetDC(self.handle);
    {$ENDIF}

    Canvas.Font.Assign(Font);

    if (Node.ImageIndex > 0) then
      r.Left := r.Left + 16;

    hs := Node.Text + ' ';

    HTMLDrawEx(Canvas,hs,r,TImageList(FImages),Message.Xpos,Message.Ypos,-1,-1,1,True,True,False,
      False,False,False,False,1.0,clBlue,clNone,clNone,clGray,a,s,fa,xsize,ysize,hl,ml,hr,FImageCache,nil);

    a := '';

    if (ysize < r.Bottom - r.Top) then
      r.top := r.top+((r.bottom-r.top-ysize) shr 1);

    HTMLDrawEx(Canvas,hs,r,TImageList(FImages),Message.Xpos,Message.Ypos,-1,-1,1,True,True,False,
      False,False,False,False,1.0,clBlue,clNone,clNone,clGray,a,s,fa,xsize,ysize,hl,ml,hr,FImageCache,nil);

    {$IFNDEF DELPHI4_LVL}
    ReleaseDC(self.Handle,Canvas.Handle);
    Canvas.Free;
    {$ENDIF}

    if (a <> '') then // new anchor
    begin
      if (self.Cursor <> crHandPoint) then
      begin
        FOldCursor := self.Cursor;
        Self.Cursor := crHandPoint;
      end;

      if (a <> FOldAnchor) then
        if Assigned(FAnchorExit) then
           FAnchorExit(Self,Node,FOldAnchor);
      FOldAnchor := a;

      if Assigned(FAnchorEnter) then
        FAnchorEnter(Self,Node,a);
    end
    else
    begin
      if (self.Cursor = crHandPoint) then
      begin
        Self.Cursor := FOldCursor;
        if Assigned(FAnchorExit) and (FOldAnchor <> '') then
           FAnchorExit(Self,Node,FOldAnchor);
        FOldAnchor := '';   
      end;
    end;
  end
  else
    if (self.Cursor = crHandPoint) then
    begin
      self.Cursor := FOldCursor;
      if Assigned(FAnchorExit) and (FOldAnchor <> '') then
        FAnchorExit(Self,Node,FOldAnchor);
      FOldAnchor := '';
    end;

  inherited;
end;

constructor THTMLTreeview.Create(AOwner: TComponent);
var
  VerInfo: TOSVersioninfo;

begin
  inherited Create(AOwner);
  {$IFDEF DELPHI4_LVL}
  Tooltips := False;
  {$ENDIF}
  FURLColor := clBlue;
  FSelectionColor := clHighLight;
  FSelectionFontColor := clHighLightText;

  FSelectionNFColor := clSilver;
  FSelectionNFFontColor := clBlack;

  FItemHeight := 16;
  FOldScrollPos := -1;
  ReadOnly := True;
  FControlColor := clRed;
  FGlyphChecked := TBitmap.Create;
  FGlyphUnChecked := TBitmap.Create;
  FOldAnchor := '';

  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(verinfo);

  FIsWinXP := (verinfo.dwMajorVersion > 5) OR
    ((verinfo.dwMajorVersion = 5) AND (verinfo.dwMinorVersion >= 1));

  if FIsWinXP then
    FIsWinXP := FIsWinXP and IsThemeActive;

  FImageCache := THTMLPictureCache.Create;

end;


function THTMLTreeview.GetItemHeight: Integer;
begin
  Result := TreeView_GetItemHeight(self.Handle);
end;

procedure THTMLTreeview.SetItemHeight(const Value: integer);
begin
  if (Value <> FItemHeight) then
  begin
    FItemHeight := value;
    TreeView_SetItemHeight(self.Handle,FItemHeight);
  end;
end;


procedure THTMLTreeview.SetSelectionColor(const Value: tcolor);
begin
   FSelectionColor := Value;
   Invalidate;
end;

procedure THTMLTreeview.SetSelectionFontColor(const Value: tcolor);
begin
  FSelectionFontColor := Value;
  Invalidate;
end;

procedure THTMLTreeview.SetURLColor(const Value: tcolor);
begin
  FURLColor := Value;
  Invalidate;
end;

procedure THTMLTreeview.Loaded;
begin
  inherited;
  FOldCursor := self.Cursor;
end;

procedure THTMLTreeview.CreateWnd;
begin
  inherited;
  ItemHeight := FItemHeight;
end;

procedure THTMLTreeview.SetImages(const Value: TImageList);
begin
  FImages := Value;
  Invalidate;
end;

procedure THTMLTreeView.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FImages) then
    FImages := nil;
  inherited;
end;


procedure THTMLTreeview.WMSize(var message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure THTMLTreeview.KeyPress(var Key: Char);
var
  PN: TTreeNode;
  i: Integer;
begin
  if Assigned(Selected) and (Key = #32) then
  begin
    Key := #0;
    if Selected.ImageIndex in [1,2] then
    begin
      if Selected.ImageIndex = 1 then
        Selected.ImageIndex := 2
      else
        Selected.ImageIndex := 1;

      {$IFNDEF DELPHI5_LVL}
      Selected.Text := Selected.Text;
      {$ENDIF}

      if Assigned(FOnCheckBoxClick) then
        FOnCheckBoxClick(Self,Selected,Selected.ImageIndex = 2);
    end;
    if Selected.ImageIndex = 3 then
    begin
      if Assigned(Selected.Parent) then
      begin
        PN := Selected.Parent;

        for i := 1 to PN.Count do
        begin
          if (PN.Item[i - 1].Level = Selected.Level) then
          begin
            if (PN.Item[i - 1].ImageIndex = 4) then
              PN.Item[i - 1].ImageIndex := 3;

            {$IFNDEF DELPHI5_LVL}
            PN.Item[i - 1].Text := PN.Item[i - 1].Text;
            {$ENDIF}
          end;
        end;
        Selected.ImageIndex := 4;

        {$IFNDEF DELPHI5_LVL}
        Selected.Text := Selected.Text;
        {$ENDIF}

        if Assigned(FOnRadioClick) then
          FOnRadioClick(Self,Selected);
      end;
    end;


    Exit;
  end;
  inherited;
end;

function THTMLTreeview.GetNodeCheck(Node: TTreeNode;
  var Check: Boolean): Boolean;
begin
  Result := False;
  if Node.ImageIndex in [1,2] then
  begin
    Check := Node.ImageIndex = 2;
    Result := True;
  end
end;

procedure THTMLTreeview.SetNodeCheck(Node: TTreeNode; Check: Boolean);
begin
  if Check then
    Node.ImageIndex := 2
  else
    Node.ImageIndex := 1;
  {$IFNDEF DELPHI5_LVL}
  Node.Text := Node.Text;
  {$ENDIF}

end;

procedure THTMLTreeview.RemoveNodeCheck(Node: TTreeNode);
begin
  Node.ImageIndex := 0;
  {$IFNDEF DELPHI5_LVL}
  Node.Text := Node.Text;
  {$ENDIF}

end;

procedure THTMLTreeview.SetControlStyle(const Value: TControlStyle);
begin
  FControlStyle := Value;
  Invalidate;
end;

procedure THTMLTreeview.SetControlColor(const Value: TColor);
begin
  FControlColor := Value;
  Invalidate;
end;

procedure THTMLTreeview.SetGlyphChecked(const Value: TBitmap);
begin
  FGlyphChecked.Assign(Value);
end;

procedure THTMLTreeview.SetGlyphUnChecked(const Value: TBitmap);
begin
  FGlyphUnChecked.Assign(Value);
end;

destructor THTMLTreeview.Destroy;
begin
  FImageCache.Free;
  FGlyphChecked.Free;
  FGlyphUnChecked.Free;
  inherited;
end;

function THTMLTreeview.GetRadioButton(Node: TTreeNode;
  var Check: Boolean): Boolean;
begin
  Result := False;
  if Node.ImageIndex in [3,4] then
  begin
    Check := Node.ImageIndex = 4;
    Result := True;
  end

end;

procedure THTMLTreeview.RemoveRadioButton(Node: TTreeNode);
begin
  Node.ImageIndex := 0;
end;

procedure THTMLTreeview.SetRadioButton(Node: TTreeNode; Check: Boolean);
begin
  if Check then
    Node.ImageIndex := 4
  else
    Node.ImageIndex := 3;
  {$IFNDEF DELPHI5_LVL}
  Node.Text := Node.Text;
  {$ENDIF}

end;

procedure THTMLTreeview.SetSelectionNFColor(const Value: TColor);
begin
  FSelectionNFColor := Value;
  Invalidate;
end;

procedure THTMLTreeview.SetSelectionNFFontColor(const Value: TColor);
begin
  FSelectionNFFontColor := Value;
  Invalidate;
end;

procedure THTMLTreeview.BeginUpdate;
begin
  inc(FUpdateCount);
end;

procedure THTMLTreeview.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    dec(FUpdateCount);
    if FUpdateCount = 0 then
      Invalidate;
  end;

end;

end.

