{*************************************************************************}
{ THTMLTreeList component                                                 }
{ for Delphi & C++Builder                                                 }
{ version 1.0                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright © 2000 - 2002                                       }
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

unit HTMLTreeList;

{$I TMSDEFS.INC}

interface

uses
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Clipbrd,Mask, comctrls, extctrls, commctrl;

type
  TAnchorEvent = procedure(Sender:TObject;Node:TTreeNode;anchor:string) of object;

  THTMLTreeList = class;


  TColumnItem = class(TCollectionItem)
  private
    FWidth:integer;
    FColumnHeader:string;
    FFont:TFont;
    procedure SetWidth(const value:integer);
    procedure SetColumnHeader(const value:string);
    procedure SetFont(const value:TFont);
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
    procedure Assign(source :TPersistent); override;
  published
    property Width:integer read fWidth write SetWidth;
    property Header:string read fColumnHeader write SetColumnHeader;
    property Font:TFont read fFont write SetFont;
  end;

  TColumnCollection = class(TCollection)
  private
    FOwner: THTMLTreeList;
    function GetItem(Index: Integer): TColumnItem;
    procedure SetItem(Index: Integer; const Value: TColumnItem);
  protected
  procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(aOwner:THTMLTreeList);
    function GetOwner: tPersistent; override;
    function Add: TColumnItem;
    function Insert(index: Integer): TColumnItem;
    property Items[Index: Integer]: TColumnItem read GetItem write SetItem; default;    
  end;


  TTLHeaderClickEvent = procedure (Sender:TObject; SectionIdx:integer) of object;

  TTLHeader = class(THeader)
  private
    fColor:tColor;
    fOnClick:TTLHeaderClickEvent;
    fOnRightClick:TTLHeaderClickEvent;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMLButtonDown); message WM_RBUTTONDOWN;
    procedure SetColor(const Value: TColor);
  public
    constructor Create(aOwner:TComponent); override;
  protected
    procedure Paint; override;
  published
    property Color:TColor read fColor write SetColor;
    property OnClick:TTLHeaderClickEvent read fOnClick write fOnClick;
    property OnRightClick:TTLHeaderClickEvent read fOnRightClick write fOnRightClick;
  end;

 THeaderSettings = class(TPersistent)
 private
  fOwner:THTMLTreeList;
  fHeight:integer;
  function GetFont: tFont;
  procedure SetFont(const Value: tFont);
  function GetFlat: boolean;
  procedure SetFlat(const Value: boolean);
  function GetAllowResize: boolean;
  procedure SetAllowResize(const Value: boolean);
  function GetColor: tColor;
  procedure SetColor(const Value: tColor);
  function GetHeight: integer;
  procedure SetHeight(const Value: integer);
 public
  constructor Create(aOwner:THTMLTreeList);
 published
  property AllowResize:boolean read GetAllowResize write SetAllowResize;
  property Color:tColor read GetColor write SetColor;
  property Flat:boolean read GetFlat write SetFlat;
  property Font:tFont read GetFont write SetFont;
  property Height:integer read GetHeight write SetHeight;
 end;

 THTMLTreeList = class(TTreeview)
 private
  { Private declarations }
  fAnchorHint: boolean;
  fHeader:TTLHeader;
  fHeaderSettings:THeaderSettings;
  fFlatHeader:boolean;
  fColumnCollection:TColumnCollection;
  fColumnLines:boolean;
  fColumnSpace:integer;
  fOldScrollPos:integer;
  fSeparator:string;
  fItemHeight:integer;
  fOldCursor:tCursor;
  fOldAnchor:string;
  fURLColor:TColor;
  fImages:TImageList;
  fOnClick:TTLHeaderClickEvent;
  fOnRightClick:TTLHeaderClickEvent;
  fOnAnchorClick:TAnchorEvent;
  fOnAnchorEnter:TAnchorEvent;
  fOnAnchorExit:TAnchorEvent;
  fSelectionColor: tcolor;
  fSelectionFontColor: tcolor;
  procedure WMHScroll(var message:TMessage); message WM_HSCROLL;
  procedure WMMouseMove(var message: TWMMouseMove); message WM_MOUSEMOVE;
  procedure WMLButtonDown(var message: TWMLButtonDown); message WM_LBUTTONDOWN;
  procedure WMPaint(var message: TWMPaint); message WM_PAINT;
  procedure CNNotify(var message: TWMNotify); message CN_NOTIFY;
  procedure CMHintShow(Var Msg: TMessage); message CM_HINTSHOW;
  procedure SetColumnCollection(const Value: TColumnCollection);
  procedure SetColumnLines(const Value: boolean);
  procedure UpdateColumns;
  procedure SectionSize(sender:TObject; ASection, AWidth:integer);
  procedure HeaderClick(sender:TObject; ASection:integer); procedure HeaderRightClick(sender:TObject; ASection:integer);
  function GetColWidth(idx:integer):integer;
  function GetColFont(idx:integer):TFont;
  procedure SetSeparator(const Value: string);
  function GetItemHeight: integer;
  procedure SetItemHeight(const Value: integer);
  function GetVisible: boolean;
  procedure SetVisible(const Value: boolean);
  function IsAnchor(node:ttreenode;x,y:integer):string;
  procedure SetURLColor(const value:TColor);
  procedure SetImages(const value:TImageList);
  procedure SetSelectionColor(const Value: tcolor);
  procedure SetSelectionFontColor(const Value: tcolor);
  function GetColumnText(col:integer;s:string):string;
 protected
  { Protected declarations }
  procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  procedure CreateWnd; override;
  procedure DestroyWnd; override;
  function GetClientRect:TRect; override;
  {$IFDEF DELPHI4_LVL}
  property ToolTips;
  {$ENDIF}
 public
  { Public declarations }
  constructor Create(aOwner:TComponent); override;
  destructor Destroy; override;
  procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  procedure SetNodeColumn(tn:TTreeNode;idx:integer;value:string);
  function GetNodeColumn(tn:TTreeNode;idx:integer):string;
 published
  { Pubished declarations }
  property AnchorHint:boolean read fAnchorHint write fAnchorHint;
  property Columns:TColumnCollection read fColumnCollection write SetColumnCollection;
  property ColumnLines:boolean read fColumnLines write SetColumnLines;
  property Separator:string read fSeparator write SetSeparator;
  property ItemHeight:integer read GetItemHeight write SetItemHeight;
  property Visible:boolean read GetVisible write SetVisible;
  property HeaderSettings:THeaderSettings read fHeaderSettings write fHeaderSettings;
  property HTMLImages:TImageList read fImages write SetImages;
  property SelectionColor:tcolor read fSelectionColor write SetSelectionColor;
  property SelectionFontColor:tcolor read fSelectionFontColor write SetSelectionFontColor;
  property URLColor:TColor read fURLColor write SetURLColor;
  property OnHeaderClick:TTLHeaderClickEvent read fOnClick write fOnClick;
  property OnHeaderRightClick:TTLHeaderClickEvent read fOnRightClick write fOnRightClick;
  property OnAnchorClick:TAnchorEvent read fOnAnchorClick write fOnAnchorClick;
  property OnAnchorEnter:TAnchorEvent read fOnAnchorEnter write fOnAnchorEnter;
  property OnAnchorExit:TAnchorEvent read fOnAnchorExit write fOnAnchorExit;
 end;

{$IFDEF VER100}
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

function TreeView_SetItemHeight(hwnd: HWND; iHeight: Integer): Integer;

function TreeView_GetItemHeight(hwnd: HWND): Integer;

{$ENDIF}


implementation

uses
 shellapi;

{$I HTMLENGL.PAS}

{ TColumnItem }

constructor TColumnItem.Create(Collection:TCollection);
begin
 inherited;
 fWidth:=50;
 fFont:=TFont.Create;
 fFont.Assign((TColumnCollection(Collection).fOwner).Font);
end;

destructor TColumnItem.Destroy;
begin
 fFont.Free;
 inherited Destroy;
end;

procedure TColumnItem.SetWidth(const value:integer);
begin
 fWidth:=value;
 TColumnCollection(Collection).Update(self);
end;


procedure TColumnItem.SetColumnHeader(const value:string);
begin
 fColumnHeader:=value;
 TColumnCollection(Collection).Update(self);
end;

procedure TColumnItem.SetFont(const value:TFont);
begin
 fFont.Assign(value);
 TColumnCollection(Collection).Update(self);
end;


procedure TColumnItem.Assign(source: TPersistent);
begin
  if Source is TColumnItem then
  begin
   Width := TColumnItem(Source).Width;
   Header := TColumnItem(Source).Header;
   Font.Assign(TColumnItem(Source).Font);
  end
  else inherited Assign(Source);
end;

{ TColumnCollection }

function TColumnCollection.Add: TColumnItem;
begin
  Result := TColumnItem(inherited Add);
end;

constructor TColumnCollection.Create(aOwner:THTMLTreeList);
begin
  inherited Create(TColumnItem);
  FOwner := AOwner;
end;

function TColumnCollection.GetItem(Index: Integer): TColumnItem;
begin
  Result := TColumnItem(inherited Items[Index]);
end;

function TColumnCollection.GetOwner:TPersistent;
begin
  Result := FOwner;
end;

function TColumnCollection.Insert(Index: Integer): TColumnItem;
begin
  Result := TColumnItem(inherited Insert(Index));
end;

procedure TColumnCollection.SetItem(Index: Integer;
  const Value: TColumnItem);
begin
  Items[Index] := Value;
end;

procedure TColumnCollection.Update(Item:TCollectionItem);
begin
  inherited Update(Item);
  {reflect changes}
  FOwner.UpdateColumns;
end;

{ TTLHeader }

procedure TTLHeader.WMLButtonDown(var Message: TWMLButtonDown);
var
 x,i:integer;
begin
 inherited;
 x:=0;
 i:=0;
 while (x<message.xpos) and (i<sections.Count) do
  begin
   x:=x+sectionwidth[i];
   inc(i);
  end;
 dec(i);
 if assigned(fOnClick) then fOnClick(self,i);
end;

procedure TTLHeader.WMRButtonDown(var Message: TWMLButtonDown);
var
 x,i:integer;
begin
 inherited;
 x:=0;
 i:=0;
 while (x<message.xpos) and (i<sections.Count) do
  begin
   x:=x+sectionwidth[i];
   inc(i);
  end;
 dec(i);
 if assigned(fOnRightClick) then fOnRightClick(self,i);
end;

procedure TTLHeader.paint;
var
  I, W: Integer;
  S: string;
  R: TRect;
  PR: TRect;
  anchor,stripped:string;
  xsize,ysize:integer;
  urlcol:tcolor;
  imagelist:TImageList;

begin
  with Canvas do
  begin
    Font := Self.Font;
    Brush.Color := fColor;
    I := 0;
    R := Rect(0, 0, 0, ClientHeight);
    W := 0;
    S := '';

    repeat
       with Owner as THTMLTreeList do
        begin
         urlcol:=URLColor;
         imagelist:=HTMLImages;
        end;

      if I < Sections.Count then
      begin
      W := SectionWidth[i];

      if (i<sections.Count) then
         S := Sections[i]
      else s:=sections[0];


      Inc(I);
      end;

      R.Left := R.Right;
      Inc(R.Right, W);
      if (ClientWidth - R.Right < 2) or (I = Sections.Count) then
        R.Right := ClientWidth;

      pr:=r;
      fillrect(r);
      InflateRect(pr,-2,-2);

      HTMLDraw(canvas,s,pr,imagelist,0,0,false,false,false,false,false,true,1.0,URLCol,anchor,stripped,xsize,ysize);

      DrawEdge(Canvas.Handle, R, BDR_RAISEDINNER, BF_TOPLEFT);
      DrawEdge(Canvas.Handle, R, BDR_RAISEDINNER, BF_BOTTOMRight);
    until R.Right = ClientWidth;
  end;
end;



constructor TTLHeader.Create(aOwner: TComponent);
begin
  inherited;
  fColor:=clBtnFace;
end;

procedure TTLHeader.SetColor(const Value: TColor);
begin
  fColor := Value;
  invalidate;
end;

{ THTMLTreeList }

constructor THTMLTreeList.Create(aOwner:TComponent);
begin
 inherited Create(aOwner);
 fHeader:=nil;
 {$IFDEF DELPHI4_LVL}
 Tooltips:=false;
 {$ENDIF}
 fColumnCollection:=tColumnCollection.Create(self);
 fHeaderSettings:=THeaderSettings.Create(self);
 fSeparator:=';';
 fItemHeight:=16;
 fColumnLines:=true;
 fColumnSpace:=2;
 fOldScrollPos:=-1;
 fHeader:=nil;
 fURLColor:=clBlue;
 fSelectionColor:=clHighLight;
 fSelectionFontColor:=clHighLightText;

end;

procedure THTMLTreeList.CreateWnd;
const
 hdr: array[boolean] of TBorderStyle = (bsSingle,bsNone);
begin
 inherited CreateWnd;

 if not assigned(fHeader) then
  begin
   fHeader:=TTLHeader.Create(self);
   fHeader.top:=Top-16;
   fHeader.left:=Left;
   fHeader.Width:=Width-1;
   fHeader.Height:=18;
   fheader.borderstyle:=hdr[fFlatHeader];
   fHeader.OnSized:=SectionSize;
   fHeader.OnClick:=HeaderClick;
   fHeader.OnRightClick:=HeaderRightClick;
  end;
 fHeader.Parent:=self.parent;

 ItemHeight:=fItemHeight;
end;

procedure THTMLTreeList.SectionSize(sender:TObject; ASection, AWidth:integer);
var
 fIndent:integer;
begin
 fIndent:=TreeView_GetIndent(self.handle);
 if assigned(Images) then fIndent:=fIndent+Images.Width;

 if (ASection=0) and (AWidth<fIndent) then
   begin
    AWidth:=fIndent;
    if assigned(fHeader) then fHeader.SectionWidth[ASection]:=fIndent;
   end;

 TColumnItem(fColumnCollection.Items[ASection]).fWidth:=AWidth;
 self.Invalidate;
end;

procedure THTMLTreeList.HeaderClick(sender:TObject; ASection:integer);
begin
 if assigned(OnHeaderClick) then OnHeaderClick(self,ASection);
end;

procedure THTMLTreeList.HeaderRightClick(sender:TObject; ASection:integer);
begin
 if assigned(OnHeaderRightClick) then OnHeaderRightClick(self,ASection);
end;

procedure THTMLTreeList.DestroyWnd;
begin
 {
 fHeader.parent:=nil;
 if assigned(fHeader) then fHeader.Free;
 fHeader:=nil;
 }
 inherited;
end;

destructor THTMLTreeList.Destroy;
begin
 fColumnCollection.Free;
 fHeaderSettings.Free;
// fHeader.parent:=nil;
 inherited;
end;

procedure THTMLTreeList.SetColumnLines(const value :boolean);
begin
 if (fColumnLines<>value) then
  begin
   fColumnLines:=value;
   if fColumnLines then fColumnSpace:=4 else fColumnSpace:=2;
   self.Invalidate;
  end;
end;


function THTMLTreeList.GetNodeColumn(tn: TTreeNode; idx: integer):string;
var
 s:string;
 i:integer;
begin
 result:='';
 if assigned(tn) then
 s:=tn.Text else exit;

 i:=0;
 while (i<=idx) and (s<>'') do
  begin
   if (pos(Separator,s)>0) then
    begin
     if (idx=i) then result:=copy(s,1,pos(Separator,s)-1);
     system.delete(s,1,pos(Separator,s));
     inc(i);
    end
   else s:='';
  end;

end;

procedure THTMLTreeList.SetNodeColumn(tn: TTreeNode; idx: integer;
  value: string);
var
 s,su:string;
 i:integer;

begin
 if assigned(tn) then
 s:=tn.Text else exit;

 i:=0;
 su:='';
 while (i<=idx) and (s<>'') do
  begin
   if (pos(Separator,s)>0) then
    begin
     if (i<idx) then su:=su+copy(s,1,pos(Separator,s));
     if (i=idx) then su:=su+value+Separator;
     system.delete(s,1,pos(Separator,s));
     inc(i);
    end
   else
    begin
     s:='';
     if (i=idx) then su:=su+value;
     inc(i);
    end;
  end;
 su:=su+s;
 tn.Text:=su;
end;


procedure THTMLTreeList.SetColumnCollection(const value :TColumnCollection);
begin
 fColumnCollection.Assign(value);
end;

procedure THTMLTreeList.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if Align in [alClient,alTop] then
   begin
    inherited SetBounds(ALeft,ATop+fHeaderSettings.height-2,AWidth,AHeight-(FHeaderSettings.height-2));
    if assigned(fHeader) then
     begin
      fHeader.top:=ATop;
      fHeader.left:=ALeft;
      fHeader.Width:=AWidth-1;
      fHeader.Height:=fHeaderSettings.Height;
     end;
   end
  else
   begin
    inherited SetBounds(ALeft,ATop,AWidth,AHeight);
    if assigned(fHeader) then
     begin
      fHeader.top:=ATop-(fHeaderSettings.height-2);
      fHeader.left:=ALeft;
      fHeader.Width:=AWidth-1;
      fHeader.Height:=fHeaderSettings.height;
     end;
   end;
end;


procedure THTMLTreeList.UpdateColumns;
var
 i:integer;
begin
 if assigned(fHeader) then
  begin
    fHeader.Sections.Clear;
    for i:=1 to fColumnCollection.Count do
     begin
      fHeader.Sections.Add(TColumnItem(fColumnCollection.Items[i-1]).Header);
      fHeader.SectionWidth[i-1]:=TColumnItem(fColumnCollection.Items[i-1]).Width;
     end;
    self.Invalidate;
  end;
end;


function THTMLTreeList.GetColWidth(idx:integer):integer;
begin
 if idx>=fColumnCollection.Count-1 then result:=self.width
 else result:=TColumnItem(fColumnCollection.Items[idx]).fWidth;
end;

function THTMLTreeList.GetColFont(idx:integer):TFont;
begin
 if idx>=fColumnCollection.Count then result:=self.Font
 else result:=TColumnItem(fColumnCollection.Items[idx]).fFont;
end;

procedure THTMLTreeList.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
 if (aOperation=opRemove) and (aComponent=fImages) then fImages:=nil;
 inherited;
end;

procedure THTMLTreeList.CNNotify(var message: TWMNotify);
var
  TVcd:TNMTVCustomDraw;
  TVdi:TTVDISPINFO;
  canvas:tcanvas;
  s,su,anchor,stripped:string;
  tn:ttreenode;
  r:trect;
  fIndent,fIdx,fImgWidth:integer;
  xsize,ysize:integer;

begin
  if message.NMHdr^.code = TVN_GETDISPINFO then
   begin
    TVDi:=PTVDispInfo(pointer(message.nmhdr))^;
    if (tvdi.item.mask and TVIF_TEXT=TVIF_TEXT) then
     begin
       tn:=items.getnode(tvdi.item.hitem);
       s:=HTMLStrip(tn.text);
       strpcopy(tvdi.item.pszText,s);
       tvdi.item.mask := tvdi.item.mask or TVIF_DI_SETITEM;
       message.result:=0;
       exit;
     end;
   end;

  if message.NMHdr^.code = NM_CUSTOMDRAW then
  begin
    fIndent:=TreeView_GetIndent(self.handle);
    TVcd:=PNMTVCustomDraw(Pointer(message.NMHdr))^;
    case TVcd.nmcd.dwDrawStage of
      CDDS_PREPAINT     : message.Result:=CDRF_NOTIFYITEMDRAW or CDRF_NOTIFYPOSTPAINT;
      CDDS_ITEMPREPAINT : begin
                            if  (TVcd.nmcd.uItemState and CDIS_SELECTED=CDIS_SELECTED) then
                              begin
                               TVcd.nmcd.uItemState:=TVcd.nmcd.uItemState and (not CDIS_SELECTED);
                               SetTextColor(TVcd.nmcd.hdc,ColorToRGB(self.Color));
                               SetBkColor(TVcd.nmcd.hdc,ColorToRGB(self.Color));
                               TVcd.clrTextBk:=colortorgb(self.Color);
                               TVcd.clrText:=colortorgb(self.Color);
                              end
                            else
                              begin
                               SetTextColor(TVcd.nmcd.hdc,ColorToRGB(self.Color));
                               SetBkColor(TVcd.nmcd.hdc,ColorToRGB(self.Color));
                              end;
                            message.Result:=CDRF_NOTIFYPOSTPAINT;
                          end;

      CDDS_ITEMPOSTPAINT :begin
                            canvas:=tcanvas.Create;
                            canvas.handle:=TVcd.nmcd.hdc;

                            tn:=Items.GetNode(HTReeItem(TVcd.nmcd.dwitemSpec));
                            TVcd.nmcd.rc.left:=TVcd.nmcd.rc.left+fIndent*(tn.level+1)-getscrollpos(handle,SB_HORZ);

                            fImgWidth:=0;
                            if assigned(Images) then
                              begin
                                fImgWidth:=Images.Width;
                                canvas.brush.color:=self.Color;
                                canvas.pen.color:=self.Color;
                                canvas.rectangle(TVcd.nmcd.rc.left,TVcd.nmcd.rc.top,TVcd.nmcd.rc.left+fImgWidth,TVcd.nmcd.rc.bottom);
                                if (TVcd.nmcd.rc.left+fImgWidth<GetColWidth(0)) and (tn.ImageIndex>=0) then
                                 begin
                                  images.draw(canvas,TVcd.nmcd.rc.left,TVcd.nmcd.rc.top,tn.ImageIndex );
                                 end;
                              end;
                            TVcd.nmcd.rc.left:=TVcd.nmcd.rc.left+fImgWidth;

                            r:=TVcd.nmcd.rc;

                            if  (TVcd.nmcd.uItemState and CDIS_SELECTED=CDIS_SELECTED) then
                              begin
                               canvas.brush.color:=fSelectionColor;
                               canvas.pen.color:=fSelectionColor;
                               with TVcd.nmcd.rc do canvas.rectangle(left,top,right,bottom);
                               canvas.font.Color:=fSelectionFontColor;
                               if  (TVcd.nmcd.uItemState and CDIS_FOCUS=CDIS_FOCUS) then
                                 begin
                                  canvas.pen.color:=self.Color;
                                  canvas.brush.color:=self.Color;
                                  canvas.DrawFocusRect(TVcd.nmcd.rc);
                                 end;
                               TVcd.nmcd.rc:=r;
                               TVcd.nmcd.rc.left:=TVcd.nmcd.rc.left+4;
                              end
                            else
                              begin
                               canvas.brush.color:=self.Color;
                               canvas.pen.color:=self.Color;
                               with TVcd.nmcd.rc do canvas.rectangle(left,top,right,bottom);
                              end;

                            TVcd.nmcd.rc:=r;
                            TVcd.nmcd.rc.left:=TVcd.nmcd.rc.left+2;

                            if  (TVcd.nmcd.uItemState and CDIS_SELECTED=CDIS_SELECTED) then
                              begin
                               canvas.brush.color:=clHighLight;
                               canvas.pen.color:=clHighLight;
                              end;
                            s:=tn.text;
                            fIdx:=0;

                            setbkmode(TVcd.nmcd.hdc,TRANSPARENT);

                            repeat
                             canvas.Font.Assign(GetColFont(fIdx));
                             if  (TVcd.nmcd.uItemState and CDIS_SELECTED=CDIS_SELECTED) then
                               begin
                                canvas.font.color:=clHighLightText;
                               end;

                             if (fIdx=0) then
                               r.right:=GetColWidth(0)
                             else
                              r.right:=r.left+GetColWidth(fIdx);//+getScrollPos(self.handle,SB_HORZ);

                             if fIdx=columns.Count-1 then r.right:=width;

                             if (pos(fSeparator,s)>0) then
                               begin
                                su:=copy(s,1,pos(fSeparator,s)-1);
                                system.delete(s,1,pos(fSeparator,s)+length(fSeparator)-1);
                               end
                             else
			       begin
			        su:=s;
                                s:='';
                               end;

                             r.right:=r.right-fColumnSpace;

                             if (r.left<r.right) then
                             HTMLDraw(canvas,su,r,fImages,0,0,false,false,false,false,false,true,1.0,fURLColor,anchor,stripped,xsize,ysize);

                             r.right:=r.right+fColumnSpace;

                             r.left:=r.right;
                             inc(fIdx);

                            until (length(s)=0);

                            canvas.free;
                           end;

     else message.Result:=0;
    end;
  end
  else inherited;
end;

procedure THTMLTreeList.SetSeparator(const Value: string);
begin
  fSeparator := Value;
  self.Invalidate;
end;

procedure THTMLTreeList.WMLButtonDown(var message: TWMLButtonDown);
var
 Node : TTreeNode;
 a:string;
begin
 if not (csDesigning in ComponentState) then inherited else exit;
 Node:=GetNodeAt(message.XPos,message.YPos);
 if assigned(Node) then
  begin
   Node.selected:=true;
   a:=IsAnchor(node,message.XPos,message.YPos);
   if (a<>'') then
    if assigned(fOnAnchorClick) then fOnAnchorClick(self,Node,a);
  end;
end;

procedure THTMLTreeList.WMHScroll(var message:TMessage);
begin
 inherited;
 if fOldScrollPos<>GetScrollPos(handle,SB_HORZ) then
   begin
    Invalidate;
    fOldScrollPos:=GetScrollPos(handle,SB_HORZ);
   end;
end;

procedure THTMLTreeList.WMPaint(var message: TWMPaint);
var
 canvas:tcanvas;
 i:integer;
 xp:integer;
begin
 inherited ;
 if fColumnLines then
  begin
   canvas:=tcanvas.create;
   canvas.handle:=getdc(self.handle);
   xp:=0;
   canvas.pen.color:=clSilver;
   for i:=1 to fColumnCollection.Count-1 do
    begin
     xp:=xp+TColumnItem(fColumnCollection.Items[i-1]).Width;
     canvas.MoveTo (xp-2-getScrollPos(self.handle,SB_HORZ),0);
     canvas.Lineto (xp-2-getScrollPos(self.handle,SB_HORZ),height);
    end;
   releasedc(self.handle,canvas.handle);
   canvas.free;
  end;
end;

function THTMLTreeList.GetItemHeight: integer;
begin
  result:=TreeView_GetItemHeight(self.Handle);
end;

procedure THTMLTreeList.SetItemHeight(const Value: integer);
begin
 if (value<>fItemHeight) then
  begin
   fItemHeight:=value;
   TreeView_SetItemHeight(self.Handle,fItemHeight);
  end;
end;


{$IFDEF VER100}
function TreeView_SetItemHeight(hwnd: HWND; iHeight: Integer): Integer;
begin
  Result := SendMessage(hwnd, TVM_SETITEMHEIGHT, iHeight, 0);
end;

function TreeView_GetItemHeight(hwnd: HWND): Integer;
begin
  Result := SendMessage(hwnd, TVM_GETITEMHEIGHT, 0, 0);
end;
{$ENDIF}



function THTMLTreeList.GetVisible: boolean;
begin
 result:=inherited Visible;
end;

procedure THTMLTreeList.SetVisible(const Value: boolean);
begin
 inherited Visible:=value;
 if assigned(fHeader) then
  begin
   if value then fHeader.Show else fHeader.Hide;
  end; 
end;

function THTMLTreeList.GetClientRect: TRect;
var
 r:trect;
begin
 r:=inherited GetClientRect;
 r.bottom:=r.bottom+fHeaderSettings.Height;
 result:=r;
end;

function THTMLTreeList.IsAnchor(node:ttreenode;x,y:integer):string;
var
 r:trect;
 s,a:string;
 xsize,ysize:integer;
 {$IFNDEF DELPHI4_LVL}
 canvas:tcanvas;
 {$ENDIF}
 i,w:integer;

begin
  r:=node.DisplayRect(true);

  a:='';
  {$IFNDEF DELPHI4_LVL}
  Canvas := TCanvas.Create;
  Canvas.handle := GetDC(self.handle);
  {$ENDIF}
  Canvas.Font.Assign(Font);
  
  w:=0;
  i:=0;
  while not ((x>=w-2) and (x<=w+GetColWidth(i)-2)) and (i<Columns.Count) do
  begin
    w:=w+GetColWidth(i);
    inc(i);
  end;

 if (i=Columns.Count) then dec(i);
 s:=GetColumnText(i,node.Text);

 r.left:=w;
 if (i<Columns.Count-1) then r.right:=r.left+GetColWidth(i) else r.right:=self.width;

 if (i=0) then
   begin
    r.left:=r.left+integer(TreeView_GetIndent(self.handle))*(node.level+1);
    if assigned(Images) then r.left:=r.left+Images.Width;
   end;

 {$IFDEF DEBUG}
 outputdebugstring(pchar('mouse is at pos '+inttostr(x)+' in col ('+inttostr(i)+') @ ['+inttostr(r.left)+':'+inttostr(r.right)+']'));
 outputdebugstring(pchar(s));
 {$ENDIF}

 HTMLDraw(canvas,s,r,fImages,x,y,true,false,false,true,true,true,1.0,clBlue,a,s,xsize,ysize);

 {$IFNDEF DELPHI4_LVL}
 releasedc(self.handle,canvas.handle);
 canvas.free;
 {$ENDIF}
 result:=a;

end;

procedure THTMLTreeList.WMMouseMove(var message: TWMMouseMove);
var
 Node : TTreeNode;
 {$IFDEF DELPHI3_ONLY}
 canvas:tcanvas;
 {$ENDIF}
 a:string;

begin
 Node:=GetNodeAt(message.XPos,message.YPos);
 if assigned(Node) then
  begin
   a:=IsAnchor(node,message.XPos,message.YPos);
   if (a<>'') then
     begin
      {change from anchor to anchor}
      if (a<>fOldAnchor) and (self.Cursor=crHandPoint) then
       begin
        if fAnchorHint then Application.CancelHint;
        if assigned(fOnAnchorExit) then fOnAnchorExit(self,Node,fOldAnchor);
       end;

      if (a<>fOldAnchor) then
       begin
        if assigned(fOnAnchorEnter) then fOnAnchorEnter(self,Node,a);
       end;

      if (self.Cursor<>crHandPoint) then
       begin
        fOldCursor:=self.Cursor;
        fOldAnchor:=a;
        self.Cursor:=crHandPoint;
       end;

     end
   else
     begin
      if fAnchorHint then Application.CancelHint;
      if (fOldAnchor<>'') then
       begin
        if assigned(fOnAnchorExit) then fOnAnchorExit(self,Node,fOldAnchor);
        fOldAnchor:='';
       end;

      if (self.Cursor=crHandPoint) then
        begin
         self.Cursor:=fOldCursor;
        end;
     end;
  end
 else
   if (self.Cursor=crHandPoint) then self.Cursor:=fOldCursor;
 inherited;
end;

function THTMLTreeList.GetColumnText(col: integer; s: string): string;
var
 i:integer;
 su:string;
begin
 i:=0;
 su:=s;
 while (i<=col) do
   begin
    if (pos(fSeparator,s)>0) then
      begin
        su:=copy(s,1,pos(fSeparator,s)-1);
        system.delete(s,1,pos(fSeparator,s)+length(fSeparator)-1);
      end
    else
      begin
       su:=s;
       s:='';
      end;
      
    inc(i);
   end;
 result:=su;
end;


procedure THTMLTreeList.SetImages(const Value: TImageList);
begin
  fImages := Value;
  self.Invalidate;
end;

procedure THTMLTreeList.SetURLColor(const value: TColor);
begin
  fURLColor:=value;
  self.Invalidate;
end;

procedure THTMLTreeList.SetSelectionColor(const Value: tcolor);
begin
  fSelectionColor := Value;
  self.Invalidate;
end;

procedure THTMLTreeList.SetSelectionFontColor(const Value: tcolor);
begin
  fSelectionFontColor := Value;
  self.Invalidate;
end;

procedure THTMLTreeList.CMHintShow(var Msg: TMessage);
var
 CanShow: Boolean;
 hi: PHintInfo;
 anchor:string;
 Node:TTreeNode;
Begin
 CanShow := True;
 hi := PHintInfo(Msg.LParam);

 Node:=GetNodeAt(hi^.cursorPos.x,hi^.cursorpos.y);
 if assigned(Node) and fAnchorHint then
  begin
   anchor:=IsAnchor(Node,hi^.cursorPos.x,hi^.cursorpos.y);
   if (anchor<>'') then
    begin
     hi^.HintPos := clienttoscreen(hi^.CursorPos);
     hi^.hintpos.y:=hi^.hintpos.y-10;
     hi^.hintpos.x:=hi^.hintpos.x+10;
     hi^.HintStr := anchor;
    end;
  end;
 Msg.Result := Ord(Not CanShow);
end;


{ THeaderSettings }

constructor THeaderSettings.Create(aOwner: THTMLTreeList);
begin
 inherited Create;
 fOwner:=aOwner;
 fHeight:=18;
end;

function THeaderSettings.GetAllowResize: boolean;
begin
 result:=true;
 if assigned(fOwner.fHeader) then
  result:=fOwner.fHeader.AllowResize;
end;

function THeaderSettings.GetColor: tColor;
begin
 result:=clBtnFace;
 if assigned(fOwner.fHeader) then
  result:=fOwner.fHeader.Color;
end;

function THeaderSettings.GetFlat: boolean;
begin
 if assigned(fOwner.fHeader) then
 result:=(fOwner.fHeader.BorderStyle=bsNone) else result:=false;
end;

function THeaderSettings.GetFont: tFont;
begin
 result:=fOwner.Font;
// if assigned(fOwner.fHeader) then result:=fOwner.fHeader.Font else result:=nil;
end;

function THeaderSettings.GetHeight: integer;
begin

 if assigned(fOwner.fHeader) then
  result:=fOwner.fHeader.Height
 else
  result:=fHeight;
end;

procedure THeaderSettings.SetAllowResize(const Value: boolean);
begin
 if assigned(fOwner.fHeader) then
  fOwner.fHeader.AllowResize:=value;
end;

procedure THeaderSettings.SetColor(const Value: tColor);
begin
 if assigned(fOwner.fHeader) then
  fOwner.fHeader.Color:=value;
end;

procedure THeaderSettings.SetFlat(const Value: boolean);
begin
 if assigned(fOwner.fHeader) then
 begin
   if value then
    fOwner.fHeader.BorderStyle:=bsNone
   else
    fOwner.fHeader.BorderStyle:=bsSingle;
 end;
end;

procedure THeaderSettings.SetFont(const Value: tFont);
begin
 {
 if assigned(fOwner.fHeader) then
 fOwner.fHeader.Font.Assign(value);
 }
end;

procedure THeaderSettings.SetHeight(const Value: integer);
begin
 if assigned(fOwner.fHeader) then
  fOwner.fHeader.height:=value;
 fHeight:=value;
 fOwner.top:=fOwner.top
end;

end.
