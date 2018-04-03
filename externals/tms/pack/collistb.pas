{**************************************************************************}
{ TColumnListBox component                                                 }
{ for Delphi & C++Builder                                                  }
{ version 1.2                                                              }
{                                                                          }
{ Copyright © 2000 - 2002                                                  }
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

unit ColListb;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, Forms;


type
 TColumnListBox = class;

 TColumnType = (ctText,ctImage);

 TEllipsisType = (etAtEnd, etInMiddle, etNone);

  TListBoxColumnItem = class(TCollectionItem)
  private
    FWidth: Integer;
    FAlignment:TAlignment;
    FFont:TFont;
    FColor:TColor;
    FColumnType:TColumnType;
    FEllipsis: TEllipsisType;
    procedure SetWidth(const value: Integer);
    procedure SetAlignment(const value:tAlignment);
    procedure SetFont(const value:TFont);
    procedure SetColor(const value:TColor);
    procedure SetColumnType(const Value: TColumnType);
    procedure SetEllipsis(const Value: TEllipsisType);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Color:TColor read fColor write SetColor;
    property ColumnType:TColumnType read fColumnType write SetColumnType;
    property Ellipsis: TEllipsisType read FEllipsis write SetEllipsis;
    property Width: Integer read fWidth write SetWidth;
    property Alignment:TAlignment read fAlignment write SetAlignment;
    property Font:TFont read fFont write SetFont;
  end;

  TListBoxColumnCollection = class(TCollection)
  private
    FOwner:TColumnListBox;
    function GetItem(Index: Integer): TListBoxColumnItem;
    procedure SetItem(Index: Integer; const Value: TListBoxColumnItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add:TListBoxColumnItem;
    function Insert(index: Integer): TListBoxColumnItem;
    property Items[Index: Integer]: TListBoxColumnItem read GetItem write SetItem; default;
    constructor Create(aOwner:TColumnListBox);
    function GetOwner: tPersistent; override;
  end;

  TListBoxItem = class(TCollectionItem)
  private
    FImageIndex: Integer;
    fStrings:TStringList;
    fTag: Integer;
    procedure SetImageIndex(const value: Integer);
    procedure SetStrings(const Value: TStringList);
    procedure StringsChanged(sender:TObject);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Strings:TStringList read fStrings write SetStrings;
    property Tag: Integer read fTag write fTag;
  end;

  TListBoxItemCollection = class(TCollection)
  private
    FOwner:TColumnListBox;
    function GetItem(Index: Integer): TListBoxItem;
    procedure SetItem(Index: Integer; const Value: TListBoxItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add:TListBoxItem;
    function Insert(index: Integer): TListBoxItem;
    property Items[Index: Integer]: TListBoxItem read GetItem write SetItem; default;
    constructor Create(aOwner:TColumnListBox);
    function GetOwner: tPersistent; override;
    function IndexOf(s:string):tpoint;
    function IndexInColumnOf(col: Integer;s:string): Integer;
    function IndexInRowOf(row: Integer;s:string): Integer;
  end;

  TColumnListBox = class(TCustomListBox)
  private
    FImages:TImageList;
    FColumns:TListBoxColumnCollection;
    FListBoxItems:TListBoxItemCollection;
    FGridLines:Boolean;
    FItemIndex: Integer;
    FUpdateCount: Integer;
    FSortColumn: Integer;
    FSortedEx: Boolean;
    FLookupIncr: Boolean;
    FLookupColumn: Integer;
    FLookup: string;
    FShowItemHint: Boolean;
    FLastHintIdx: Integer;
    procedure SetImages(const Value: TImageList);
    procedure SetItemIndexP(const Value : Integer);
    function GetItemIndexP: Integer;
    procedure SetGridLines(const Value: Boolean);
    procedure BuildItems;
    function GetColumnItems(i, j: Integer): String;
    procedure SetColumnItems(i, j: Integer; const Value: String);
    function GetSortedEx: Boolean;
    procedure SetSortedEx(const Value: Boolean);
    procedure Sort;
    procedure CMHintShow(var Msg: TMessage); message CM_HINTSHOW;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    function GetDelimiter: char;
    procedure SetDelimiter(const Value: char);
    procedure QuickSortList(List:TStringList;left,right: Integer);
  protected
    procedure MeasureItem(Index: Integer; var Height: Integer); override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure CreateWnd; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    property Items;
    procedure DoEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    property Text;
    procedure BeginUpdate;
    procedure EndUpdate;
    property ColumnItems[i,j: Integer]: String read GetColumnItems write SetColumnItems;
    property Delimiter: char read GetDelimiter write SetDelimiter;
  published
    property Align;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property Constraints;
    property DragKind;
    {$ENDIF}
    property BorderStyle;
    property Color;
    property Cursor;
    property Ctl3D;
    property Columns:TListBoxColumnCollection read fColumns write fColumns;
    property ListBoxItems:TListBoxItemCollection read fListBoxItems write fListBoxItems;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property GridLines:Boolean read fGridLines write SetGridLines;
    property Images:TImageList read FImages write SetImages;
    property IntegralHeight;
    property ItemHeight;
    property ItemIndex: Integer read GetItemIndexP write SetItemIndexP;
    property LookupIncr: Boolean read fLookupIncr write fLookupIncr;
    property LookupColumn: Integer read fLookupColumn write fLookupColumn;
    property MultiSelect;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property ShowItemHint: Boolean read FShowItemHint write FShowItemHint;
    property SortColumn: Integer read fSortColumn write fSortColumn;
    property Sorted: Boolean read GetSortedEx write SetSortedEx;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
    {$IFDEF DELPHI4_LVL}
    property OnStartDock;
    property OnEndDock;
    {$ENDIF}
    {$IFDEF DELPHI5_LVL}
    property OnContextPopup;
    {$ENDIF}
  end;


implementation

uses
  ExtCtrls, ShellApi, Commctrl {$IFDEF DELPHI4_LVL} , ImgList {$ENDIF};

const
  COLUMN_DELIMITER = '|';
  FDelimiter : Char = COLUMN_DELIMITER;

var
  SortCol: Integer;

function GetColumnString(var s:string):string;
begin
 if (Pos(FDelimiter,s)>0) then
   begin
    Result := Copy(s,1,Pos(FDelimiter,s)-1);
    Delete(s,1,Pos(FDelimiter,s));
  end
 else
  begin
    Result := s;
    s := '';
  end;
end;

function GetColumn(i: Integer; s:string): String;
var
  k: Integer;
begin
  k := 0;
  repeat
   Result := GetColumnString(s);
   inc(k);
  until (k > i);
end;


procedure TColumnListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  r,dr:TRect;
  s,su:string;
  align:DWORD;
  col,imgidx,err: Integer;
  ct:TColumnType;
begin
  if (index<0) then exit;

  r:=rect;


  if (odSelected in State) then
    Canvas.rectangle(r.left,r.top,r.right,r.bottom);

  s:=Items[index];
  val(GetColumnString(s),imgidx,err);

  for col:=1 to fColumns.Count do
  begin
    ct:=fColumns.Items[col-1].ColumnType;

    if (ct=ctText) then su:=GetColumnString(s) else su:='';

    Canvas.Font.Assign(fColumns.Items[col-1].Font);

    if (odSelected in State) then
    begin
      Canvas.brush.color:=clHighLight;
      Canvas.pen.color:=clHighLight;
      Canvas.font.color:=clHighLightText;
    end
    else
    begin
      Canvas.brush.Color:=fColumns.Items[col-1].Color;
      Canvas.pen.color:=Canvas.brush.Color;
    end;

    dr:=r;
    if col=fColumns.Count then
      dr.right:=r.right
    else
      dr.right:=dr.left+fColumns.Items[col-1].Width;

    case fColumns.Items[col-1].Alignment of
    taLeftJustify:align:=DT_LEFT;
    taRightJustify:align:=DT_RIGHT;
    taCenter:align:=DT_CENTER;
    else
      align:=DT_LEFT;
    end;

    if not (odSelected in State) then
    begin
      if (s='') then
        Canvas.rectangle(dr.left,dr.top,dr.right,dr.bottom)
      else
        Canvas.rectangle(dr.left,dr.top,dr.right,dr.bottom);
    end;

    dr.left:=dr.left+2;
    dr.top:=r.top+1;

    if (ct=ctImage) and assigned(FImages) then
    begin
      FImages.Draw(Canvas,dr.left,dr.top,imgidx);
    end
    else
    begin
      dr.right:=dr.right-2;
      case FColumns.Items[col-1].Ellipsis of
      etAtEnd: align := align or DT_END_ELLIPSIS or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;
      etInMiddle: align := align or DT_PATH_ELLIPSIS or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;
      etNone: align := align or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;
      end;

      DrawTextEx(Canvas.handle,pchar(su),length(su),dr,align,nil);
      dr.right:=dr.right+2;
    end;
    r.left:=dr.right;
  end;

  if fGridLines then
  begin
    Canvas.pen.color:=clGray;

    Canvas.moveto(rect.left,rect.bottom-1);
    Canvas.lineto(rect.right,rect.bottom-1);

    imgidx:=rect.left;

    for col:=1 to fColumns.Count-1 do
    begin
      imgidx:=imgidx+fColumns.Items[col-1].Width;
      Canvas.moveto(imgidx,dr.top);
      Canvas.lineto(imgidx,dr.bottom);
    end;
  end;
end;

procedure TColumnListBox.CreateWnd;
begin
  inherited CreateWnd;
end;

constructor TColumnListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := lbOwnerDrawFixed;
  FColumns := TListBoxColumnCollection.Create(self);
  FListBoxItems := TListBoxItemCollection.Create(self);
  FUpdateCount := 0;
  FDelimiter := COLUMN_DELIMITER;
end;

destructor TColumnListBox.Destroy;
begin
  FColumns.Free;
  FListBoxItems.Free;
  inherited Destroy;
end;

procedure TColumnListBox.MeasureItem(Index: Integer; var Height: Integer);
var
  Res: Integer;
  Canvas: TCanvas;
begin
  height:=40;
  if (index>=0) then
  begin
    Canvas := TCanvas.Create;
    Canvas.Handle := GetDC(self.handle);
    res := Canvas.TextHeight('gh')+4; {some overlap on fonts}
    ReleaseDC(Handle,Canvas.Handle);
    Canvas.free;

//   if (index=0) and (fShowHeader) then res:=res*2;
   SendMessage(Handle,CB_SETITEMHEIGHT,index,res);
  end
  else
    Res:=20;
  Height := Res;
end;

procedure TColumnListBox.SetImages(const Value: TImageList);
begin
  FImages := Value;
  Invalidate;
end;


function TColumnListBox.GetItemIndexP: Integer;
begin
 Result:=sendmessage(handle,LB_GETCURSEL,0,0);
end;

procedure TColumnListBox.SetItemIndexP(const Value: Integer);
begin
 fItemIndex:=value;
 if MultiSelect then
  begin
  sendmessage(handle,LB_SELITEMRANGE,Value,MakeLParam(Value,Value));
  end;

 sendmessage(handle,LB_SETCURSEL,value,0);
end;

procedure TColumnListBox.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
 if (aOperation=opRemove) and (aComponent=FImages) then FImages:=nil;
 inherited;
end;

procedure TColumnListBox.SetGridLines(const Value: Boolean);
begin
  fGridLines := Value;
  Invalidate;
end;


procedure TColumnListBox.BuildItems;
var
 i,j: Integer;
 s:string;
begin
  if (csLoading in ComponentState) then Exit;
  if (FUpdateCount>0) then Exit;

  while (Items.Count>fListBoxItems.Count) do Items.Delete(Items.Count-1);

  for i := 1 to FListBoxItems.Count do
  begin {image index is always first}
   s := IntToStr(fListBoxItems.Items[i-1].FImageIndex);

   for j := 1 to FColumns.Count do
     if (j<=fListBoxItems.Items[i-1].Strings.Count) then
       s := s + FDelimiter + FListBoxItems.Items[i-1].Strings[j-1]
     else
       s := s + FDelimiter;

   if (Items.Count >= i) then
      Items[i-1] := s
    else
      Items.Add(s);
  end;

end;

procedure TColumnListBox.Loaded;
begin
  inherited;
  BuildItems;
  ItemIndex:=fItemIndex;
  if fSortedEx then Sort;
  {$IFDEF DELPHI4_LVL}
  DoubleBuffered := True;
  {$ENDIF}
end;

procedure TColumnListBox.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TColumnListBox.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      BuildItems;
  end;
end;

function TColumnListBox.GetColumnItems(i, j: Integer): String;
var
 k: Integer;
begin
  if (i >= Items.Count) then raise Exception.Create('Item index out of range');

  for k := 1 to j do
   if fColumns.Items[k-1].ColumnType<>ctText then dec(j);

  Result := GetColumn(succ(j), Items[i]);
end;

procedure TColumnListBox.SetColumnItems(i, j: Integer;
  const Value: String);
var
  s,n,l: String;
  k: Integer;

begin
  if (i >= Items.Count) then raise Exception.Create('Item index out of range');

  for k := 1 to j do
   if fColumns.Items[k-1].ColumnType<>ctText then dec(j);
  inc(j);
  
  s := self.Items[i];
  k := 0;
  n := '';
  repeat
   if n <> '' then n := n + FDelimiter;
   l := GetColumnString(s);
   if (k <> j) then
     n := n + l
   else
     n := n + Value;

   inc(k);
  until (k > j);

  if (s <> '') then
   begin

    n := n + FDelimiter + s;
   end;

  Items[i] := n;
end;

function TColumnListBox.GetSortedEx: Boolean;
begin
 Result := fSortedEx;
end;

procedure TColumnListBox.QuickSortList(List:TStringList;left,right: Integer);
var
  i,j,tag,idx: Integer;
  s,sw: string;
  sl:string;

begin
  i := left;
  j := right;

  //get middle item here
  s := List.Strings[(left+right) shr 1];

  repeat
    while (AnsiStrComp(pchar(GetColumn(SortCol,s)),pchar(GetColumn(SortCol,List.Strings[i])))>0) and (i<right) do inc(i);
    while (AnsiStrComp(pchar(GetColumn(SortCol,s)),pchar(GetColumn(SortCol,List.Strings[j])))<0) and (j>left) do dec(j);
    if (i<=j) then
    begin
      if (i<>j) then
      begin
        if AnsiStrComp(pchar(GetColumn(SortCol,List.Strings[i])),pchar(GetColumn(SortCol,List.Strings[j])))<>0 then
        begin
          sw := List.Strings[i];
          List.Strings[i] := List.Strings[j];
          List.Strings[j] := sw;

          sl := ListBoxItems.Items[i].Strings.Text;
          tag := ListBoxItems.Items[i].Tag;
          idx := ListBoxItems.Items[i].ImageIndex;

          ListBoxItems.Items[i].Strings.Text := ListBoxItems.Items[j].Strings.Text;
          ListBoxItems.Items[i].Tag := ListBoxItems.Items[j].Tag;
          ListBoxItems.Items[i].ImageIndex := ListBoxItems.Items[j].ImageIndex;

          ListBoxItems.Items[j].Tag := tag;
          ListBoxItems.Items[j].ImageIndex := idx;
          ListBoxItems.Items[j].Strings.Text := sl;


        end;
      end;
      inc(i);
      dec(j);
    end;
  until (i>j);

  if left < j then QuicksortList(List,left,j);
  if i < right then QuickSortList(List,i,right);
end;


procedure TColumnListBox.Sort;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  sl.Assign(Items);
  SortCol := fSortColumn;

  inc(FUpdateCount);

  if sl.Count>1 then
    QuickSortList(sl,0,sl.Count-1);

  dec(FUpdateCount);
  Items.Assign(sl);
  sl.Free;
end;

procedure TColumnListBox.SetSortedEx(const Value: Boolean);
begin
  FSortedEx := Value;
  if Value then
    if not (csLoading in ComponentState) then Sort;
end;

procedure TColumnListBox.DoEnter;
begin
  inherited;
  fLookup:='';
end;

procedure TColumnListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if key in [vk_up,vk_down,vk_left,vk_right,vk_next,vk_prior,vk_home,vk_end,vk_escape] then
    begin
      fLookup := '';
      Exit;
    end;

  if (key=vk_back) and (length(fLookup)>0) then delete(fLookup,length(fLookup),1);
end;

procedure TColumnListBox.KeyPress(var Key: Char);
var
  i: Integer;
  s: string;

  function Max(a,b: Integer): Integer;
  begin
   if (a > b) then Result := a else Result := b;
  end;

begin
  inherited;

  if not fLookupIncr then
    fLookup := key
  else
    fLookup := fLookup + key;

  if (ItemIndex>=0) or (fLookupIncr) then
   begin
      for i := Max(1,ItemIndex+1) to Items.Count do
       begin
        s := ColumnItems[i-1,fLookupColumn];
        if (s <> '') then
        if (pos(uppercase(fLookup),uppercase(s)) = 1) then
          begin
           ItemIndex := i-1;
           Invalidate;
           Exit;
          end;
       end;
   end;

  for i := 1 to Items.Count do
   begin
    s := ColumnItems[i-1,fLookupColumn];

    if (s <> '') then
    if (pos(uppercase(fLookup),uppercase(s))=1) then
      begin
       ItemIndex := i-1;
       Exit;
      end;
   end;

  if fLookupIncr then
   begin
    fLookup:=key;
    for i := 1 to Items.Count do
     begin
      s := ColumnItems[i-1,fLookupColumn];
      if (s<>'') then
      if (pos(uppercase(fLookup),uppercase(s))=1) then
       begin
        ItemIndex := i-1;
        Exit;
       end;
     end;
   end;
end;

procedure TColumnListBox.CMHintShow(var Msg: TMessage);
var
  hi: PHintInfo;
  s: string;
  i, idx: Integer;
begin
  hi := PHintInfo(Msg.LParam);

  Idx := SendMessage(Handle,LB_ITEMFROMPOINT,0,makelparam(hi^.cursorpos.x,hi^.cursorpos.y));
  FLastHintIdx := Idx;

  if (Idx >= 0) and (Idx < Items.Count) and FShowItemHint then
  begin

    hi^.HintStr := Items[Idx];
    s := '';
    for i := 1 to Columns.Count do
    begin
      s := s + ' ' + GetColumn(i, hi^.HintStr);
    end;
    hi^.HintStr := s;
  end
  else
    hi^.HintStr := Hint;
end;

procedure TColumnListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Idx: Integer;
begin
  inherited;
  Idx := SendMessage(Handle,LB_ITEMFROMPOINT,0,makelparam(X,Y));
  if Idx <> FLastHintIdx then
  begin
    Application.CancelHint;
    FLastHintIdx := Idx;
  end;
end;


function TColumnListBox.GetDelimiter: char;
begin
  Result := FDelimiter;
end;

procedure TColumnListBox.SetDelimiter(const Value: char);
begin
  FDelimiter := Value;
end;




{ TListBoxColumnItem }

procedure TListBoxColumnItem.Assign(Source: TPersistent);
begin
 if Source is TListBoxColumnItem then
  begin
    Color:=TListBoxColumnItem(source).Color;
    ColumnType:=TListBoxColumnItem(source).ColumnType;
    Width:=TListBoxColumnItem(source).Width;
    Alignment:=TListBoxColumnItem(source).Alignment;
    Font.Assign(TListBoxColumnItem(source).Font);
  end;
end;

constructor TListBoxColumnItem.Create(Collection: TCollection);
begin
  inherited;
  FFont := TFont.Create;
  FWidth := 100;
  FColor := clWindow;
end;

destructor TListBoxColumnItem.Destroy;
begin
  FFont.Free;
  Inherited;
end;

function TListBoxColumnItem.GetDisplayName: string;
begin
  Result := 'Column'+inttostr(index);
end;

procedure TListBoxColumnItem.SetAlignment(const value: tAlignment);
begin
  FAlignment := Value;
  TListBoxColumnCollection(collection).FOwner.Invalidate;
end;

procedure TListBoxColumnItem.SetColor(const value: TColor);
begin
  FColor := Value;
  TListBoxColumnCollection(collection).FOwner.Invalidate;
end;

procedure TListBoxColumnItem.SetColumnType(const Value: TColumnType);
begin
  FColumnType := Value;
  TListBoxColumnCollection(collection).FOwner.Invalidate;
end;

procedure TListBoxColumnItem.SetEllipsis(const Value: TEllipsisType);
begin
  FEllipsis := Value;
  TListBoxColumnCollection(collection).FOwner.Invalidate;
end;

procedure TListBoxColumnItem.SetFont(const value: TFont);
begin
 fFont.Assign(value);
 TListBoxColumnCollection(collection).FOwner.Invalidate;
end;

procedure TListBoxColumnItem.SetWidth(const value: Integer);
begin
 fWidth:=value;
 TListBoxColumnCollection(collection).FOwner.Invalidate;
end;

{ TListBoxColumnCollection }

function TListBoxColumnCollection.Add: TListBoxColumnItem;
begin
 Result:=TListBoxColumnItem(inherited Add);
end;

constructor TListBoxColumnCollection.Create(aOwner: TColumnListBox);
begin
 inherited Create(TListBoxColumnItem);
 FOwner:=aOwner;
end;

function TListBoxColumnCollection.GetItem(Index: Integer): TListBoxColumnItem;
begin
 Result:=TListBoxColumnItem(inherited Items[index]);
end;

function TListBoxColumnCollection.GetOwner: tPersistent;
begin
 Result:=FOwner;
end;

function TListBoxColumnCollection.Insert(index: Integer): TListBoxColumnItem;
begin
 {$IFNDEF DELPHI4_LVL}
 Result:=TListBoxColumnItem(inherited Add);
 {$ELSE}
 Result:=TListBoxColumnItem(inherited Insert(index));
 {$ENDIF}
end;

procedure TListBoxColumnCollection.SetItem(Index: Integer;
  const Value: TListBoxColumnItem);
begin
 inherited SetItem(Index, Value);
end;

procedure TListBoxColumnCollection.Update(Item: TCollectionItem);
begin
  inherited;
end;


{ TListBoxItemCollection }

function TListBoxItemCollection.Add: TListBoxItem;
begin
 Result:=TListBoxItem(inherited Add);
end;

constructor TListBoxItemCollection.Create(aOwner: TColumnListBox);
begin
 inherited Create(TListBoxItem);
 FOwner:=aOwner;
end;

function TListBoxItemCollection.GetItem(Index: Integer): TListBoxItem;
begin
 Result:=TListBoxItem(inherited Items[index]);
end;

function TListBoxItemCollection.GetOwner: tPersistent;
begin
 Result:=FOwner;
end;

function TListBoxItemCollection.Insert(index: Integer): TListBoxItem;
begin
 {$IFNDEF DELPHI4_LVL}
 Result:=TListBoxItem(inherited Add);
 {$ELSE}
 Result:=TListBoxItem(inherited Insert(index));
 {$ENDIF}
end;

function TListBoxItemCollection.IndexInColumnOf(col: Integer;
  s: string): Integer;
var
 i: Integer;
begin
 Result:=-1;
 for i:=1 to Count do
  begin
   if Items[i-1].Strings.Count>col then
     if Items[i-1].Strings[col]=s then
       begin
        Result := i-1;
        break;
       end;
  end;

end;

function TListBoxItemCollection.IndexInRowOf(row: Integer;
  s: string): Integer;
var
 i: Integer;
begin
 Result:=-1;
 if (Count>Row) then

 for i:=1 to Items[row].Strings.Count do
  begin
   if Items[row].Strings[i-1]=s then
     begin
      Result:=i-1;
      break;
     end;
  end;

end;


function TListBoxItemCollection.IndexOf(s: string): tpoint;
var
 i,j: Integer;

begin
 Result:=point(-1,-1);

 for i:=1 to Count do
  begin
   for j:=1 to Items[i-1].Strings.Count do

     if Items[i-1].Strings[j-1]=s then
       begin
        Result.y:=i-1;
        Result.x:=j-1;
        break;
       end;
  end;

end;


procedure TListBoxItemCollection.SetItem(Index: Integer;
  const Value: TListBoxItem);
begin
 inherited SetItem(Index, Value);
end;

procedure TListBoxItemCollection.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TListBoxItem }

procedure TListBoxItem.Assign(Source: TPersistent);
begin
  if Source is TListBoxItem then
  begin
    ImageIndex := TListBoxItem(Source).ImageIndex;
    Strings.Assign(TListBoxItem(Source).Strings);
    TListBoxItemCollection(collection).FOwner.BuildItems;
  end;
end;

constructor TListBoxItem.Create(Collection: TCollection);
begin
  inherited;
  FStrings := TStringList.Create;
  FImageIndex := -1;
  FStrings.OnChange := StringsChanged;
end;

destructor TListBoxItem.Destroy;
var
  AOwner: TColumnListBox;
begin
  AOwner := TListBoxItemCollection(collection).FOwner;
  fStrings.Free;
  inherited;
  if AOwner.HandleAllocated then AOwner.BuildItems;
end;

function TListBoxItem.GetDisplayName: string;
begin
  Result := 'Item' + IntToStr(Index);
end;

procedure TListBoxItem.SetImageIndex(const value: Integer);
begin
  FImageIndex := Value;

  with TListBoxItemCollection(Collection).FOwner do
  begin
    if FUpdateCount > 0 then Exit;
    if (csDesigning in ComponentState) then BuildItems;
    Invalidate;
  end;
end;

procedure TListBoxItem.SetStrings(const Value: TStringList);
begin
  FStrings.Assign(Value);
  TListBoxItemCollection(collection).FOwner.Invalidate;
end;

procedure TListBoxItem.StringsChanged(sender: TObject);
var
  idx: Integer;
begin
  if TListBoxItemCollection(Collection).FOwner.FUpdateCount > 0 then
    Exit;

  idx := TListBoxItemCollection(Collection).FOwner.ItemIndex;
  TListBoxItemCollection(Collection).FOwner.BuildItems;
  TListBoxItemCollection(Collection).FOwner.ItemIndex := idx;
end;





procedure TColumnListBox.WMSize(var Msg: TMessage);
begin
  inherited;
  Invalidate;
end;

end.
