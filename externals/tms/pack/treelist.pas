{************************************************************************}
{ TTREELIST component                                                    }
{ for Delphi & C++Builder                                                }
{ version 0.8                                                            }
{                                                                        }
{ written by TMS Software                                                }
{            copyright © 2000 - 2003                                     }
{            Email : info@tmssoftware.com                                }
{            Web : http://www.tmssoftware.com                            }
{                                                                        }
{ The source code is given as is. The author is not responsible          }
{ for any possible damage done due to the use of this code.              }
{ The component can be freely used in any application. The complete      }
{ source code remains property of the author and may not be distributed, }
{ published, given or sold in any form as such. No parts of the source   }
{ code can be included in any other component or application without     }
{ written authorization of the author.                                   }
{************************************************************************}

unit treelist;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, Comctrls, ExtCtrls, CommCtrl;

type
  TTreeList = class;

  {$IFDEF DELPHI3_LVL}
  TColumnItem = class(TCollectionItem)
  private
    FWidth: Integer;
    FAlignment: TAlignment;
    FColumnHeader: string;
    FFont: TFont;
    FImage: Boolean;
    FHeaderAlign: TAlignment;
    FHeaderImage: Integer;
    procedure SetWidth(const value:integer);
    procedure SetAlignment(const value:tAlignment);
    procedure SetColumnHeader(const value:string);
    procedure SetFont(const value:TFont);
    procedure SetImage(const Value: boolean);
    procedure SetHeaderAlign(const Value: TAlignment);
    procedure SetHeaderImage(const Value: integer);
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
    procedure Assign(source :TPersistent); override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Font: TFont read FFont write SetFont;
    property Header:string read FColumnHeader write SetColumnHeader;
    property HeaderAlign: TAlignment read FHeaderAlign write SetHeaderAlign default taLeftJustify;
    property HeaderImage: Integer read FHeaderImage write SetHeaderImage default -1;
    property Image: Boolean read FImage write SetImage default false;
    property Width: Integer read FWidth write SetWidth;
  end;

  TColumnCollection = class(TCollection)
  private
    FOwner:TTreeList;
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner:TTreeList);
    function GetOwner: tPersistent; override;
 end;
 {$ENDIF}

  TTLHeaderClickEvent = procedure (Sender:TObject; SectionIdx:integer) of object;

  TTLHeader = class(THeader)
  private
    FColor: TColor;
    FOnClick: TTLHeaderClickEvent;
    FOnRightClick:TTLHeaderClickEvent;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMLButtonDown); message WM_RBUTTONDOWN;
    procedure SetColor(const Value: TColor);
  public
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;
    procedure DestroyWnd; override;
  protected
    procedure Paint; override;
  published
    property Color:TColor read fColor write SetColor;
    property OnClick:TTLHeaderClickEvent read fOnClick write fOnClick;
    property OnRightClick:TTLHeaderClickEvent read fOnRightClick write fOnRightClick;
  end;

  THeaderSettings = class(TPersistent)
  private
    FOwner:TTreelist;
    FOldHeight: Integer;
    FHeight: Integer;
    FVisible: Boolean;
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
    procedure SetVisible(const Value: Boolean);
  public
    constructor Create(aOwner:TTreeList);
  published
    property AllowResize:boolean read GetAllowResize write SetAllowResize default False;
    property Color:tColor read GetColor write SetColor;
    property Flat:boolean read GetFlat write SetFlat default False;
    property Font:tFont read GetFont write SetFont;
    property Height:integer read GetHeight write SetHeight;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TTreeList = class(TTreeview)
  private
    { Private declarations }
    FHeader:TTLHeader;
    FHeaderSettings:THeaderSettings;
    FFlatHeader:boolean;
    FColumnCollection:TColumnCollection;
    FColumnLines:boolean;
    FColumnSpace:integer;
    FOldScrollPos:integer;
    FSeparator:string;
    FItemHeight:integer;
    FOnClick:TTLHeaderClickEvent;
    FOnRightClick:TTLHeaderClickEvent;
    procedure WMHScroll(var message:TMessage); message WM_HSCROLL;
    procedure WMLButtonDown(var message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMPaint(var message: TWMPaint); message WM_PAINT;
    procedure CNNotify(var message: TWMNotify); message CN_NOTIFY;
    procedure SetColumnCollection(const Value: TColumnCollection);
    procedure SetColumnLines(const Value: boolean);
    procedure UpdateColumns;
    procedure SectionSize(sender:TObject; ASection, AWidth:integer);
    procedure HeaderClick(sender:TObject; ASection:integer); procedure HeaderRightClick(sender:TObject; ASection:integer);
    function GetColImage(idx:integer):boolean;
    function GetColWidth(idx:integer):integer;
    function GetColFont(idx:integer):TFont;
    function GetAlignment(idx:integer):integer;
    procedure SetSeparator(const Value: string);
    function GetItemHeight: integer;
    procedure SetItemHeight(const Value: integer);
    function GetVisible: boolean;
    procedure SetVisible(const Value: boolean);
  protected
    { Protected declarations }
    procedure WndProc(var Message:tMessage); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function GetClientRect:TRect; override;
  public
    { Public declarations }
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetNodeColumn(tn:TTreeNode;idx:integer;value:string);
    function GetNodeColumn(tn:TTreeNode;idx:integer):string;
  published
    { Pubished declarations }
    property Columns:TColumnCollection read fColumnCollection write SetColumnCollection;
    property ColumnLines:boolean read fColumnLines write SetColumnLines;
    property Separator:string read fSeparator write SetSeparator;
    property ItemHeight:integer read GetItemHeight write SetItemHeight;
    property OnHeaderClick:TTLHeaderClickEvent read fOnClick write fOnClick;
    property OnHeaderRightClick:TTLHeaderClickEvent read fOnRightClick write fOnRightClick;
    property Visible:boolean read GetVisible write SetVisible;
    property HeaderSettings:THeaderSettings read FHeaderSettings write FHeaderSettings;
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

{ TColumnItem }

constructor TColumnItem.Create(Collection: TCollection);
begin
  inherited;
  FWidth := 50;
  FFont := TFont.Create;
  FFont.Assign((TColumnCollection(Collection).FOwner).Font);
  FHeaderImage := -1;
  if (Index = 0) and
     (csDesigning in (TColumnCollection(Collection).FOwner).ComponentState) and
    not (csLoading in (TColumnCollection(Collection).FOwner).ComponentState) then
    FImage := True;
end;

destructor TColumnItem.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TColumnItem.SetWidth(const value:integer);
begin
  FWidth := Value;
  TColumnCollection(Collection).Update(Self);
end;

procedure TColumnItem.SetAlignment(const value:tAlignment);
begin
  FAlignment := Value;
  TColumnCollection(Collection).Update(Self);
end;

procedure TColumnItem.SetColumnHeader(const value:string);
begin
  FColumnHeader := Value;
  TColumnCollection(Collection).Update(Self);
end;

procedure TColumnItem.SetFont(const value:TFont);
begin
  FFont.Assign(Value);
  TColumnCollection(Collection).Update(Self);
end;


procedure TColumnItem.Assign(source: TPersistent);
begin
  if Source is TColumnItem then
  begin
    Width := TColumnItem(Source).Width;
    Alignment := TColumnItem(Source).Alignment;
    Header := TColumnItem(Source).Header;
    HeaderAlign := TColumnItem(Source).HeaderAlign;
    Font.Assign(TColumnItem(Source).Font);
    Image := TColumnItem(Source).Image;
  end
  else
    inherited Assign(Source);
end;

procedure TColumnItem.SetImage(const Value: boolean);
begin
  FImage := Value;
  TColumnCollection(Collection).Update(Self);
end;

procedure TColumnItem.SetHeaderAlign(const Value: TAlignment);
begin
  FHeaderAlign := Value;
  TColumnCollection(Collection).Update(Self);
end;

procedure TColumnItem.SetHeaderImage(const Value: integer);
begin
  FHeaderImage := Value;
  TColumnCollection(Collection).Update(Self);
end;

{ TColumnCollection }

constructor TColumnCollection.Create(aOwner:TTreeList);
begin
  inherited Create(TColumnItem);
  FOwner := AOwner;
end;

function TColumnCollection.GetOwner:tPersistent;
begin
  Result := FOwner;
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
  x := 0;
  i := 0;
  while (x < Message.XPos) and (i < Sections.Count) do
  begin
    x := x + SectionWidth[i];
    inc(i);
  end;
  Dec(i);
  if Assigned(FOnClick) then
    FOnClick(self,i);
end;

procedure TTLHeader.WMRButtonDown(var Message: TWMLButtonDown);
var
  x,i:integer;
begin
  inherited;
  x := 0;
  i := 0;
  while (x < Message.xpos) and (i < Sections.Count) do
  begin
    x := x + SectionWidth[i];
    Inc(i);
  end;
  Dec(i);
  if Assigned(FOnRightClick) then
    FOnRightClick(self,i);
end;

procedure TTLHeader.Paint;
var
  I, W: Integer;
  S: string;
  R: TRect;
  PR: TRect;
  halign:word;

begin
  with Canvas do
  begin
    Font := Self.Font;
    Brush.Color := fColor;
    I := 0;
    R := Rect(0, 0, 0, ClientHeight);
    W := 0;
    S := '';

    halign:=DT_RIGHT;

    repeat
      with Owner as TTreeList do
      begin
        if Columns.Count>I then
          case (Columns.Items[I] as TColumnItem).HeaderAlign of
          taleftJustify:halign:=DT_LEFT;
          taRightJustify:halign:=DT_RIGHT;
          taCenter:halign:=DT_CENTER;
          else
            halign:=DT_LEFT;
          end;
      end;

      if I < Sections.Count then
      begin
        W := SectionWidth[i];

        if (i<sections.Count) then
          s := Sections[i]
        else
          s := Sections[0];

        Inc(I);
      end;

      R.Left := R.Right;
      Inc(R.Right, W);
      if (ClientWidth - R.Right < 2) or (I = Sections.Count) then
        R.Right := ClientWidth;

      pr := r;
      FillRect(r);
      InflateRect(pr,-2,-2);

      with (Owner as TTreeList) do
      begin
        if (Columns.Count>I) and Assigned(Images) then
        if ((Columns.Items[I] as TColumnItem).HeaderImage >= 0) then
        begin
          Images.Draw(self.Canvas,pr.Left,pr.Top,(Columns.Items[I] as TColumnItem).HeaderImage);
          pr.Left:=pr.Left+Images.Width+2;
        end;
      end;

      DrawText(canvas.handle,pchar(s),length(s),PR,DT_NOPREFIX or DT_END_ELLIPSIS or halign);
      DrawEdge(Canvas.Handle, R, BDR_RAISEDINNER, BF_TOPLEFT);
      DrawEdge(Canvas.Handle, R, BDR_RAISEDINNER, BF_BOTTOMRight);
    until R.Right = ClientWidth;
  end;
end;



constructor TTLHeader.Create(aOwner: TComponent);
begin
  inherited;
  FColor := clBtnFace;
end;

procedure TTLHeader.SetColor(const Value: TColor);
begin
  FColor := Value;
  Invalidate;
end;


destructor TTLHeader.Destroy;
begin
  inherited;
end;

procedure TTLHeader.DestroyWnd;
begin
  inherited;
end;

{ TTreeList }

constructor TTreeList.Create(aOwner:TComponent);
begin
  inherited Create(aOwner);
  FHeader := nil;
  FColumnCollection := TColumnCollection.Create(self);
  FHeaderSettings := THeaderSettings.Create(self);
  FSeparator := ';';
  FItemHeight := 16;
  FColumnLines := true;
  FColumnSpace := 4;
  FOldScrollPos := -1;
end;

procedure TTreeList.CreateWnd;
const
  hdr: array[boolean] of TBorderStyle = (bsSingle,bsNone);
begin
  inherited CreateWnd;

  if not Assigned(FHeader) then
  begin
    FHeader := TTLHeader.Create(self);
    FHeader.Parent := self.Parent;
    FHeader.top := Top - 16;
    FHeader.left := Left;
    FHeader.Width := Width-1;
    FHeader.Height := 18;
    Fheader.borderstyle := hdr[FFlatHeader];
    FHeader.OnSized := SectionSize;
    FHeader.OnClick := HeaderClick;
    FHeader.OnRightClick := HeaderRightClick;
  end;

  ItemHeight := FItemHeight;
end;

procedure TTreeList.SectionSize(sender:TObject; ASection, AWidth:integer);
var
  FIndent: Integer;
begin
  FIndent := TreeView_GetIndent(self.Handle);
  if Assigned(Images) then
    FIndent := FIndent + Images.Width;

  if (ASection = 0) and (AWidth < FIndent) then
  begin
    AWidth := FIndent;
    if Assigned(FHeader) then
      FHeader.SectionWidth[ASection] := FIndent;
  end;

  TColumnItem(fColumnCollection.Items[ASection]).FWidth := AWidth;
  Invalidate;
end;

procedure TTreeList.HeaderClick(sender:TObject; ASection:integer);
begin
  if Assigned(OnHeaderClick) then
    OnHeaderClick(self,ASection);
end;

procedure TTreeList.HeaderRightClick(sender:TObject; ASection:integer);
begin
  if Assigned(OnHeaderRightClick) then
    OnHeaderRightClick(self,ASection);
end;

procedure TTreeList.DestroyWnd;
begin
  //if assigned(fHeader) then fHeader.Free;
  //fHeader:=nil;
  inherited;
end;

destructor TTreeList.Destroy;
begin
  FHeaderSettings.Free;
  FColumnCollection.Free;
  inherited;
end;

procedure TTreeList.SetColumnLines(const value :boolean);
begin
  if (FColumnLines <> Value) then
  begin
    FColumnLines := Value;
    if FColumnLines then
      FColumnSpace := 4
    else
      FColumnSpace := 2;
    self.Invalidate;
  end;
end;

procedure TTreeList.SetColumnCollection(const value :TColumnCollection);
begin
  FColumnCollection.Assign(Value);
end;

procedure TTreeList.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  HeaderHeight: Integer;
begin
  if not Assigned(FHeaderSettings) then
  begin
    inherited;
    Exit;
  end;

  if not  FHeaderSettings.Visible then
    HeaderHeight := 2
  else
    HeaderHeight := FHeaderSettings.FHeight;

  if Align in [alClient,alTop] then
  begin
    inherited SetBounds(ALeft,ATop + HeaderHeight - 2,AWidth,AHeight - HeaderHeight + 2);

    if Assigned(FHeader) then
    begin
      FHeader.Top := ATop;
      FHeader.Left := ALeft;
      FHeader.Width := AWidth - 1;
      FHeader.Height := FHeaderSettings.Height;
    end;
  end
  else
  begin
    inherited SetBounds(ALeft,ATop,AWidth,AHeight);
    if Assigned(FHeader) then
    begin
      FHeader.Top := ATop - (FHeaderSettings.Height - 2);
      FHeader.Left := ALeft;
      FHeader.Width := AWidth - 1;
      FHeader.Height := FHeaderSettings.Height;
    end;
  end;
end;


procedure TTreeList.UpdateColumns;
var
  i: Integer;
begin
  if Assigned(FHeader) then
  begin
    FHeader.Sections.Clear;
    for i := 1 to FColumnCollection.Count do
    begin
      FHeader.Sections.Add(TColumnItem(FColumnCollection.Items[i-1]).Header);
      fHeader.SectionWidth[i-1] := TColumnItem(FColumnCollection.Items[i-1]).Width;
    end;
    Self.Invalidate;
  end;
end;

function TTreeList.GetColImage(idx:Integer):boolean;
begin
  if idx >= FColumnCollection.Count then
    Result := False
  else
    Result := TColumnItem(FColumnCollection.Items[idx]).FImage;
end;

function TTreeList.GetColWidth(idx:integer):integer;
begin
  if idx >= FColumnCollection.Count then
    Result := self.Width
  else
    Result := TColumnItem(FColumnCollection.Items[idx]).FWidth;
end;

function TTreeList.GetColFont(idx:integer):TFont;
begin
  if idx >= FColumnCollection.Count then
    Result := self.Font
  else
    Result := TColumnItem(FColumnCollection.Items[idx]).FFont;
end;

function TTreeList.GetAlignment(idx:integer):integer;
begin
  if idx >= FColumnCollection.Count then
    Result := DT_LEFT
  else
    case TColumnItem(FColumnCollection.Items[idx]).FAlignment of
    taLeftJustify:Result := DT_LEFT;
    taCenter:Result := DT_CENTER;
    taRightJustify:Result:=DT_RIGHT
    else
      Result := DT_LEFT;
  end;
end;

procedure TTreeList.CNNotify(var message: TWMNotify);
var
  TVcd:TNMTVCustomDraw;
  TVdi:TTVDISPINFO;
  canvas:tcanvas;
  s,su:string;
  tn:ttreenode;
  r:trect;
  fIndent,fIdx,fImgWidth:integer;

begin

  if message.NMHdr^.code = TVN_GETDISPINFO then
  begin

    TVDi := PTVDispInfo(pointer(message.nmhdr))^;
    if (tvdi.item.mask and TVIF_TEXT=TVIF_TEXT) then
    begin
      tn := Items.GetNode(tvdi.item.hitem);
      s := tn.Text;
      StrPLCopy(tvdi.item.pszText,s,255);
      tvdi.Item.Mask := tvdi.item.mask or TVIF_DI_SETITEM;
      message.result:=0;
      Exit;
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

      CDDS_ITEMPOSTPAINT :
        begin
          Canvas := TCanvas.Create;
          Canvas.Handle := TVcd.nmcd.hdc;

          tn := Items.GetNode(HTReeItem(TVcd.nmcd.dwitemSpec));

          {get left pos from tree level}
          TVcd.nmcd.rc.Left := TVcd.nmcd.rc.Left + FIndent*(tn.Level + 1) - GetScrollPos(handle,SB_HORZ);

          {paint image in first column}
          FImgWidth := 0;

          if Assigned(Images) and GetColImage(0) and
            ((tn.ImageIndex >= 0) or (tn.SelectedIndex >= 0)) then
          begin
            FImgWidth := Images.Width;
            Canvas.Brush.Color := Color;
            Canvas.Pen.Color := Color;
            Canvas.Rectangle(TVcd.nmcd.rc.left,TVcd.nmcd.rc.top,TVcd.nmcd.rc.left+fImgWidth,TVcd.nmcd.rc.bottom);
            if (TVcd.nmcd.rc.left+fImgWidth<GetColWidth(0)) then
            begin
              if (TVcd.nmcd.uItemState and CDIS_SELECTED=CDIS_SELECTED) and
                (tn.SelectedIndex >= 0) then
                Images.draw(canvas,TVcd.nmcd.rc.left,TVcd.nmcd.rc.top,tn.SelectedIndex)
              else
                if (tn.ImageIndex >= 0) then
                  Images.draw(canvas,TVcd.nmcd.rc.left,TVcd.nmcd.rc.top,tn.ImageIndex);
            end;
            if tn.OverlayIndex >= 0 then
              Images.Draw(canvas,TVcd.nmcd.rc.left,TVcd.nmcd.rc.top,tn.OverlayIndex);
          end;

          TVcd.nmcd.rc.left:=TVcd.nmcd.rc.left+fImgWidth;

                  r:=TVcd.nmcd.rc;

                  fIdx:=canvas.textheight('gh');
                  if (fIdx<r.bottom-r.top) then
                   r.top:=r.top+((r.bottom-r.top-fIdx) shr 1);

                  if  (TVcd.nmcd.uItemState and CDIS_SELECTED=CDIS_SELECTED) then
                    begin
                     canvas.brush.color:=clHighLight;
                     canvas.pen.color:=clHighLight;
                     with TVcd.nmcd.rc do canvas.rectangle(left,top,right,bottom);
                     canvas.font.Color:=clHighLightText;
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
                    r.right:=GetColWidth(fIdx)
                   else
                    r.right:=r.left+GetColWidth(fIdx);//+getScrollPos(self.handle,SB_HORZ);

                   if (pos(fSeparator,s)>0) then
                     begin
                      su:=copy(s,1,pos(fSeparator,s)-1);
                      system.delete(s,1,pos(fSeparator,s)+length(fSeparator)-1);
                     end
                   else
			       begin

			        su:=s;
                                s:='';
                                if (fIdx>=fColumnCollection.Count) then
                                r.right:=TVcd.nmcd.rc.right;
                               end;

                             r.right:=r.right-fColumnSpace;

                             if Assigned(Images) and GetColImage(fIdx) and (tn.ImageIndex>=0) and (fIdx>0) then
                              begin
                                fImgWidth := Images.Width;
                                if (fImgWidth<GetColWidth(fIdx)) then
                                  images.draw(canvas,r.left,TVcd.nmcd.rc.top,tn.ImageIndex );
                                r.left:=r.left+fImgWidth+2;
                              end;


                             DrawText(canvas.handle,pchar(su),length(su),r,DT_END_ELLIPSIS or GetAlignment(fIdx));
                             r.right:=r.right+fColumnSpace;

                             r.left:=r.right;
                             inc(fIdx);

                            until (length(s)=0);

                            canvas.Free;
                           end;

     else message.Result:=0;
    end;
  end
  else inherited;
end;

procedure TTreeList.SetSeparator(const Value: string);
begin
  fSeparator := Value;
  self.Invalidate;
end;

procedure TTreeList.WMLButtonDown(var message: TWMLButtonDown);
var
 Node : TTreeNode;
begin
 if not (csDesigning in ComponentState) then inherited else exit;
 Node:=GetNodeAt(message.XPos,message.YPos);
 if assigned(Node) then
  begin
   Node.selected:=true;
  end;
end;

procedure TTreeList.WMHScroll(var message:TMessage);
begin
 inherited;
 if fOldScrollPos<>GetScrollPos(handle,SB_HORZ) then
   begin
    Invalidate;
    fOldScrollPos:=GetScrollPos(handle,SB_HORZ);
   end;
end;

procedure TTreeList.WMPaint(var message: TWMPaint);
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

function TTreeList.GetItemHeight: integer;
begin
  result:=TreeView_GetItemHeight(self.Handle);
end;

procedure TTreeList.SetItemHeight(const Value: integer);
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

function TTreeList.GetVisible: boolean;
begin
  Result := inherited Visible;
end;

procedure TTreeList.SetVisible(const Value: boolean);
begin
 inherited Visible := Value;
 if Assigned(FHeader) then
   FHeader.Visible := Value;
end;

function TTreeList.GetClientRect: TRect;
var
  r: TRect;
begin
  r := inherited GetClientRect;
  r.bottom := r.bottom + FHeaderSettings.Height;
  Result := r;
end;

function VarPos(su,s:string;var vp: Integer):Integer;
begin
  vp := Pos(su,s);
  Result := vp;
end;

function TTreeList.GetNodeColumn(tn: TTreeNode; idx: integer):string;
var
  s: string;
  i,vp: Integer;

begin
  Result := '';
  if Assigned(tn) then
    s := tn.Text
  else
    Exit;

  i := 0;
  while (i <= idx) and (s <> '') do
  begin
    if VarPos(Separator,s,vp) > 0 then
    begin
     if idx = i then
       Result := Copy(s,1,vp-1);

     System.Delete(s,1,vp);
     inc(i);
    end
    else
    begin
      if i = idx then
        Result := s;
      s := '';
    end;
  end;

end;

procedure TTreeList.SetNodeColumn(tn: TTreeNode; idx: integer;
  value: string);
var
  s,su: string;
  i,vp: Integer;

begin
  if Assigned(tn) then
    s := tn.Text
  else
    Exit;

  i := 0;
  su := '';
  while (i <= idx) and (s <> '') do
  begin
    if VarPos(Separator,s,vp) > 0 then
    begin
      if i < idx then
        su := su + copy(s,1,vp);
      if i = idx then
        su := su + Value + Separator;

      System.Delete(s,1,vp);
      Inc(i);
    end
    else
    begin
      s := '';
      if i = idx then
        su := su + Value;
      Inc(i);
    end;
  end;
  
  su := su + s;
  tn.Text := su;
end;

procedure TTreeList.WndProc(var Message: tMessage);
begin
  inherited;
end;

{ THeaderSettings }

constructor THeaderSettings.Create(aOwner: TTreeList);
begin
  inherited Create;
  FOwner := AOwner;
  FHeight := 18;
  FOldHeight := FHeight;
  FVisible := True;
end;

function THeaderSettings.GetAllowResize: Boolean;
begin
  Result := True;
  if Assigned(FOwner.FHeader) then
    Result := FOwner.FHeader.AllowResize;
end;

function THeaderSettings.GetColor: TColor;
begin
  Result := clBtnFace;
  if Assigned(FOwner.FHeader) then
    Result := FOwner.FHeader.Color;
end;

function THeaderSettings.GetFlat: Boolean;
begin
  if Assigned(FOwner.FHeader) then
    Result := (FOwner.FHeader.BorderStyle = bsNone)
  else
    Result := False;
end;

function THeaderSettings.GetFont: TFont;
begin
  if Assigned(FOwner.FHeader) then
    Result := FOwner.FHeader.Font
  else
    Result := nil;
end;

function THeaderSettings.GetHeight: integer;
begin
  Result := FHeight;
end;

procedure THeaderSettings.SetAllowResize(const Value: Boolean);
begin
  if Assigned(FOwner.FHeader) then
    FOwner.fHeader.AllowResize := Value;
end;

procedure THeaderSettings.SetColor(const Value: TColor);
begin
  if Assigned(FOwner.FHeader) then
    FOwner.FHeader.Color := Value;
end;

procedure THeaderSettings.SetFlat(const Value: Boolean);
begin
  if Assigned(FOwner.FHeader) then
  begin
    if Value then
      FOwner.FHeader.BorderStyle := bsNone
    else
      FOwner.FHeader.BorderStyle := bsSingle;
  end;
end;

procedure THeaderSettings.SetFont(const Value: TFont);
begin
  if Assigned(FOwner.FHeader) then
    FOwner.FHeader.Font.Assign(Value);
end;

procedure THeaderSettings.SetHeight(const Value: Integer);
begin
  if Assigned(FOwner.FHeader) then
    FOwner.FHeader.Height := Value;
  FHeight := Value;
  FOldHeight := FHeight;
  FOwner.Top := FOwner.Top;
end;

procedure THeaderSettings.SetVisible(const Value: Boolean);
begin
  if Assigned(FOwner.FHeader) then
  begin
    if (csDesigning in FOwner.ComponentState) then
    begin
      if Value then
        Height := FOldHeight
      else
      begin
        FOldHeight := Height;
        FOwner.FHeader.Height := 0;
      end;
    end;
  end;

  FOwner.FHeader.Visible := Value;
  FVisible := Value;
end;

end.
