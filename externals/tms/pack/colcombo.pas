{*************************************************************************}
{ TColumnComboBox component                                               }
{ for Delphi & C++Builder                                                 }
{ version 1.3                                                             }
{                                                                         }
{ Copyright © 2000-2002                                                   }
{   TMS Software                                                          }
{   Email : info@tmssoftware.com                                          }
{   Web : http://www.tmssoftware.com                                      }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit ColCombo;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, AdvCombo, Forms
{$IFDEF CODESITE}
  , CSIntf
{$ENDIF}
  ;

const
  COLUMN_DELIMITER = '|';

type
  TColumnComboBox = class;

  TColumnType = (ctText,ctImage);

  TComboColumnItem = class(TCollectionItem)
  private
    FWidth: Integer;
    FAlignment:TAlignment;
    FFont:TFont;
    FColor:TColor;
    FColumnType:TColumnType;
    procedure SetWidth(const Value: Integer);
    procedure SetAlignment(const Value:tAlignment);
    procedure SetFont(const Value:TFont);
    procedure SetColor(const Value:TColor);
    procedure SetColumnType(const Value: TColumnType);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Color:TColor read FColor write SetColor;
    property ColumnType:TColumnType read FColumnType write SetColumnType;
    property Width: Integer read FWidth write SetWidth;
    property Alignment:TAlignment read FAlignment write SetAlignment;
    property Font:TFont read FFont write SetFont;
  end;

  TComboColumnCollection = class(TCollection)
  private
    FOwner:TColumnComboBox;
    function GetItem(Index: Integer): TComboColumnItem;
    procedure SetItem(Index: Integer; const Value: TComboColumnItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add:TComboColumnItem;
    function Insert(index: Integer): TComboColumnItem;
    property Items[Index: Integer]: TComboColumnItem read GetItem write SetItem;
    constructor Create(AOwner:TColumnComboBox);
    function GetOwner: TPersistent; override;
  end;

  TComboItem = class(TCollectionItem)
  private
    FImageIndex: Integer;
    FStrings:TStringList;
    FTag: Integer;
    procedure SetImageIndex(const Value: Integer);
    procedure SetStrings(const Value: TStringList);
    procedure StringsChanged(Sender:TObject);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Strings: TStringList read FStrings write SetStrings;
    property Tag: Integer read FTag write FTag;
  end;

  TComboItemCollection = class(TCollection)
  private
    FOwner:TColumnComboBox;
    function GetItem(Index: Integer): TComboItem;
    procedure SetItem(Index: Integer; const Value: TComboItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add:TComboItem;
    function Insert(index: Integer): TComboItem;
    property Items[Index: Integer]: TComboItem read GetItem write SetItem;
    constructor Create(AOwner:TColumnComboBox);
    function GetOwner: tPersistent; override;
    function IndexOf(s:string):tpoint;
    function IndexInColumnOf(col: Integer;s:string): Integer;
    function IndexInRowOf(row: Integer;s:string): Integer;
  end;

  TColumnComboBox = class(TAdvCustomCombo)
  private
    FImages:TImageList;
    FDropHeight: Integer;
    FColumns:TComboColumnCollection;
    fComboItems:TComboItemCollection;
    FGridLines:boolean;
    FEditColumn: Integer;
    FItemIndex: Integer;
    FSelItemIndex: Integer;
    FUpdateCount: Integer;
    FLookup: string;
    FLookupColumn: Integer;
    FLookupIncr: Boolean;
    FSortColumn: Integer;
    FSortedEx: Boolean;
    FDropped: Boolean;
    FShowItemHint: Boolean;
    {$IFNDEF DELPHI5_LVL}
    FComboEdit: Boolean;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    {$ENDIF}
    procedure CMHintShow(var Msg: TMessage); message CM_HINTSHOW;
    procedure SetDropWidth(Value: Integer);
    function GetDropWidth: Integer;
    procedure SetEditHeight(Value: Integer);
    function GetEditHeight: Integer;
    procedure SetImages(const Value: TImageList);
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure WMLButtonUp(var Msg:TWMLButtonDown); message WM_LBUTTONUP;
    procedure WMChar(var Msg:TWMChar); message WM_CHAR;
    procedure SetItemIndexP(const Value : Integer);
    function GetItemIndexP: Integer;
    procedure SetGridLines(const Value: boolean);
    procedure SetEditColumn(const Value: Integer);
    procedure BuildItems;
    function GetColumnItems(i, j: Integer): String;
    procedure SetColumnItems(i, j: Integer; const Value: String);
    function GetSortedEx: boolean;
    procedure SetSortedEx(const Value: boolean);
    procedure Sort;
    function GetDelimiter: Char;
    procedure SetDelimiter(const Value: Char);
    procedure QuickSortList(List:TStringList;left,right: Integer);    
  protected
    procedure SetStyle(Value: TComboBoxStyle); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MeasureItem(Index: Integer; var Height: Integer); override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure CreateWnd; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    property Items;
    procedure WndProc(var Msg:TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    property Text;
    procedure BeginUpdate;
    procedure EndUpdate;
    property ColumnItems[i,j: Integer]: String read GetColumnItems write SetColumnItems;
    property Delimiter: Char read GetDelimiter write SetDelimiter;
  published
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property Constraints;
    property DragKind;
    {$ENDIF}
    property Color;
    property Ctl3D;
    property Columns:TComboColumnCollection read FColumns write FColumns;
    property ComboItems:TComboItemCollection read FComboItems write FComboItems;
    property DragMode;
    property DragCursor;
    property EditColumn: Integer read FEditColumn write SetEditColumn;
    property EditHeight: Integer read GetEditheight write SetEditHeight;
    property DropWidth: Integer read GetDropWidth write SetDropWidth;
    property DropHeight: Integer read FDropHeight write FDropHeight;
    property DropDownCount;
    property Images: TImageList read FImages write SetImages;
    property Enabled;
    property Etched;
    property Flat;
    property FlatParentColor;
    property FlatLineColor;
    property FocusBorder;
    property Font;
    property GridLines: Boolean read FGridLines write SetGridLines;
  //    property ItemHeight;
    property ItemIndex: Integer read GetItemIndexP write SetItemIndexP;
    property LookupIncr: Boolean read FLookupIncr write FLookupIncr default false;
    property LookupColumn: Integer read FLookupColumn write FLookupColumn;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property ShowItemHint: Boolean read FShowItemHint write FShowItemHint;
    property SortColumn: Integer read FSortColumn write FSortColumn;
    property Sorted: Boolean read GetSortedEx write SetSortedEx;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
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
  ExtCtrls,ShellApi,CommCtrl {$IFDEF DELPHI4_LVL} ,ImgList {$ENDIF};

const
  FDelimiter : Char = COLUMN_DELIMITER;

var
  SortCol: Integer;

{$IFNDEF DELPHI5_LVL}
procedure TColumnComboBox.CNDrawItem(var Message: TWMDrawItem);
begin
  with Message.DrawItemStruct^ do
    FComboEdit := itemState and ODS_COMBOBOXEDIT <> 0;
  inherited;
end;
{$ENDIF}


procedure TColumnComboBox.SetStyle(Value: TComboBoxStyle);
begin
  inherited SetStyle(csOwnerDrawFixed);
end;

function GetColumnString(var s:string):string;
var
  DelPos: Integer;
begin
  DelPos := Pos(FDelimiter,s);
  if DelPos > 0 then
  begin
    Result := Copy(s,1,DelPos-1);
    Delete(s,1,DelPos);
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

procedure TColumnComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  r,dr:TRect;
  s,su:string;
  align:DWORD;
  col,imgidx,err: Integer;
  ct:TColumnType;
  isEdit:boolean;
begin
  {$IFNDEF DELPHI5_LVL}
  isEdit := FComboEdit;
  {$ELSE}
  isEdit := odComboBoxEdit in State;
  {$ENDIF}

  r := Rect;

  if Index < 0 then
  begin
    if (odSelected in State) then
    begin
      Canvas.Brush.Color := clHighLight;
      Canvas.Pen.Color := clHighLight;
      Canvas.Font.Color := clHighLightText;
    end
    else
    begin
      Canvas.Brush.Color := Color;
      Canvas.Pen.Color := Canvas.Brush.Color;
    end;
    Canvas.Rectangle(r.Left,r.Top,r.Right,r.Bottom);
    Exit;
  end;

  if (odSelected in State) then
    Canvas.Rectangle(r.Left,r.Top,r.Right,r.Bottom);

  s := Items[Index];
  Val(GetColumnString(s),imgidx,err);

  for col := 1 to FColumns.Count do
  begin
    ct := FColumns.Items[col-1].ColumnType;

    if (ct = ctText) then
      su := GetColumnString(s)
    else
      su := '';

    Canvas.Font.Assign(FColumns.Items[col-1].Font);

    if (odSelected in State) then
    begin
      Canvas.brush.color:=clHighLight;
      Canvas.pen.color:=clHighLight;
      Canvas.font.color:=clHighLightText;
    end
    else
    begin
      Canvas.brush.Color:=FColumns.Items[col-1].Color;
      Canvas.pen.color:=Canvas.brush.Color;
    end;

    dr := r;
    if col = FColumns.Count then
      dr.right := r.right
    else
      dr.right := dr.left + FColumns.Items[col-1].Width;

    case FColumns.Items[col-1].Alignment of
    taLeftJustify: Align := DT_LEFT;
    taRightJustify: Align := DT_RIGHT;
    taCenter: Align := DT_CENTER;
    else
      align := DT_LEFT;
    end;

    if (not isEdit) or (EditColumn=-1) then
    begin
      if not (odSelected in State) then
      begin
        if (s='') then
          Canvas.rectangle(dr.left,dr.top,dr.right,dr.bottom)
        else
          Canvas.rectangle(dr.left,dr.top,dr.right,dr.bottom);
      end;

      dr.Left := dr.Left + 2;
      dr.Top := r.Top + 1;

      if (ct=ctImage) and assigned(FImages) then
      begin
        FImages.Draw(Canvas,dr.left,dr.top,imgidx);
      end
      else
      begin
        dr.right:=dr.right-2;
        DrawTextEx(Canvas.handle,pchar(su),length(su),dr,align or DT_END_ELLIPSIS or DT_VCENTER or DT_SINGLELINE,nil);
        dr.right:=dr.right+2;
      end;
      r.left:=dr.right;
    end
    else
    begin

      if FDropped then
        su := ColumnItems[FSelItemIndex,EditColumn]
      else
       su := ColumnItems[ItemIndex,EditColumn];

      dr.left := dr.left+2;
      dr.top := r.top+1;
      if (col=EditColumn+1) and (isEdit) then
        DrawTextEx(Canvas.handle,pchar(su),length(su),dr,align or DT_END_ELLIPSIS or DT_VCENTER or DT_SINGLELINE,nil);
    end;
  end;

  if fGridLines then
  begin
    Canvas.pen.color:=clGray;

    if not IsEdit then
    begin
      Canvas.MoveTo(rect.Left,rect.Bottom-1);
      Canvas.LineTo(rect.Right,rect.Bottom-1);
    end;

    ImgIdx := rect.Left;

    if not IsEdit or (EditColumn = -1) then
      for col := 1 to FColumns.Count-1 do
      begin
        ImgIdx := ImgIdx + FColumns.Items[Col - 1].Width;
        Canvas.moveto(imgidx,dr.top);
        Canvas.lineto(imgidx,dr.bottom);
      end;
  end;

  Canvas.Brush.Color := Self.Color;
  Canvas.Pen.Color := Self.Color;
end;

procedure TColumnComboBox.CreateWnd;
begin
  inherited CreateWnd;
end;

constructor TColumnComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := csOwnerDrawFixed;
  fDropheight := 200;
  fEditColumn := -1;
  FColumns := TComboColumnCollection.Create(self);
  fComboItems := TComboItemCollection.Create(self);
  Flat := false;
  FDelimiter := COLUMN_DELIMITER;
end;

destructor TColumnComboBox.Destroy;
begin
  FColumns.Free;
  FComboItems.Free;
  inherited Destroy;
end;

procedure TColumnComboBox.MeasureItem(Index: Integer; var Height: Integer);
var
 res: Integer;
 Canvas: TCanvas;
begin
  height:=40;
  if (index>=0) then
  begin
    Canvas:=tCanvas.Create;
    Canvas.handle:=getdc(self.handle);
    res:=Canvas.textheight('gh')+4; {some overlap on fonts}
    releasedc(handle,Canvas.handle);
    Canvas.free;

    SendMessage(self.handle,CB_SETITEMHEIGHT,index,res);
  end
  else
    res := EditHeight;

  Height := res;
end;

function TColumnComboBox.GetDropWidth: Integer;
begin
 Result:=sendmessage(self.handle,CB_GETDROPPEDWIDTH,0,0);
end;

procedure TColumnComboBox.SetDropWidth(Value: Integer);
begin
 sendmessage(self.handle,CB_SETDROPPEDWIDTH,Value,0);
end;

function TColumnComboBox.GetEditHeight: Integer;
begin
  Result := SendMessage(self.Handle,CB_GETITEMHEIGHT,-1,0);
end;

procedure TColumnComboBox.SetEditHeight(Value: Integer);
begin
  SendMessage(self.handle,CB_SETITEMHEIGHT,-1,Value);
  SendMessage(self.handle,CB_SETITEMHEIGHT,0,Value);
end;

procedure TColumnComboBox.SetImages(const Value: TImageList);
begin
  FImages := Value;
  Invalidate;
end;

procedure TColumnComboBox.CNCommand(var Message: TWMCommand);
begin
  case message.NotifyCode of
  CBN_DROPDOWN:
    begin
      MoveWindow(self.Handle,Self.Left,Self.Top,Width,EditHeight + FDropheight,True);
      DropDown;
      FDropped := True;
      ItemIndex := SendMessage(self.Handle,CB_GETCURSEL,0,0);
      message.Result := 0;
    end;
  CBN_SELCHANGE:
    begin
      FDropped := False;
      FItemIndex := SendMessage(self.Handle,CB_GETCURSEL,0,0);

      if Assigned(OnClick) then
        OnClick(Self);

      if Assigned(OnChange) then
        OnChange(Self);
      Invalidate;
    end;
  else
    inherited;

  end;
end;

function TColumnComboBox.GetItemIndexP: Integer;
begin
  Result := SendMessage(Handle,CB_GETCURSEL,0,0);
end;

procedure TColumnComboBox.SetItemIndexP(const Value: Integer);
begin
  if FDropped then
    FItemIndex := Value;
  FSelItemIndex := FItemIndex;
  SendMessage(Handle,CB_SETCURSEL,Value,0);
end;

procedure TColumnComboBox.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FImages) then
    FImages := nil;
  inherited;
end;

procedure TColumnComboBox.SetGridLines(const Value: boolean);
begin
  FGridLines := Value;
  Invalidate;
end;

procedure TColumnComboBox.SetEditColumn(const Value: Integer);
begin
  FEditColumn := Value;
  Invalidate;
end;

procedure TColumnComboBox.BuildItems;
var
  i,j: Integer;
  s:string;
begin
  if (csLoading in ComponentState) then exit;

  if FUpdateCount>0 then Exit;

  while Items.Count > FComboItems.Count do
    Items.Delete(Items.Count-1);

  for i:=1 to FComboItems.Count do
  begin {image index is always first}
   s:=inttostr(fComboItems.Items[i-1].FImageIndex);

   for j:=1 to FColumns.Count do
     if (j<=fComboItems.Items[i-1].Strings.Count) then
       s := s + FDelimiter + FComboItems.Items[i-1].Strings[j-1]
     else
       s := s + FDelimiter;

   if (Items.Count>=i) then
      Items[i-1]:=s
    else
      Items.Add(s);
  end;

end;

procedure TColumnComboBox.Loaded;
begin
  inherited;
  BuildItems;
  ItemIndex := fItemIndex;
  if FSortedEx then Sort;
end;

procedure TColumnComboBox.BeginUpdate;
begin
  inc(FUpdateCount);
end;

procedure TColumnComboBox.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      BuildItems;
  end;
end;

function TColumnComboBox.GetColumnItems(i, j: Integer): String;
var
  k: Integer;

begin
  if (i >= Items.Count) then raise Exception.Create('Item index out of range');

  for k := 1 to j do
   if FColumns.Items[k-1].ColumnType<>ctText then dec(j);

  Result := GetColumn(succ(j), Items[i]);
end;

procedure TColumnComboBox.SetColumnItems(i, j: Integer;
  const Value: String);
var
  s,n,l: String;
  k, OldIndex: Integer;
begin
  if (i >= Items.Count) then raise Exception.Create('Item index out of range');

  for k := 1 to j do
   if FColumns.Items[k-1].ColumnType<>ctText then dec(j);
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

  OldIndex := ItemIndex;
  Items[i] := n;
  ItemIndex := OldIndex;
end;


procedure TColumnComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if key in [vk_up,vk_down,vk_left,vk_right,vk_next,vk_prior,vk_home,vk_end,vk_escape] then
  begin
    FLookup := '';
    Exit;
  end;

  if (Key = vk_back) and (Length(FLookup)>0) then
    Delete(FLookup,Length(FLookup),1);
end;

function TColumnComboBox.GetSortedEx: boolean;
begin
  Result := fSortedEx;
end;

procedure TColumnComboBox.QuickSortList(List:TStringList;left,right: Integer);
var
  i,j: Integer;
  s,sw: string;

begin
  i := left;
  j := right;

  {get middle item here}
  s := List.Strings[(left + right) shr 1];

  repeat
    while (AnsiStrComp(pchar(GetColumn(SortCol,s)),pchar(GetColumn(SortCol,List.Strings[i])))>0) and (i<right) do inc(i);
    while (AnsiStrComp(pchar(GetColumn(SortCol,s)),pchar(GetColumn(SortCol,List.Strings[j])))<0) and (j>left) do dec(j);

    if (i <= j) then
    begin
      if (i <> j) then
      begin
        if AnsiStrComp(PChar(GetColumn(SortCol,List.Strings[i])),PChar(GetColumn(SortCol,List.Strings[j])))<>0 then
        begin
          sw := List.Strings[i];
          List.Strings[i] := List.Strings[j];
          List.Strings[j] := sw;
        end;
      end;
      inc(i);
      dec(j);
    end;
  until (i>j);

  if (left<j) then QuicksortList(List,left,j);
  if (i<right) then QuickSortList(List,i,right);
end;

procedure TColumnComboBox.Sort;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  sl.Assign(Items);
  SortCol := FSortColumn;

  if sl.Count>1 then
    QuickSortList(sl,0,sl.Count-1);

  Items.Assign(sl);
  sl.Free;
end;

procedure TColumnComboBox.SetSortedEx(const Value: boolean);
begin
  fSortedEx := Value;
  if Value then
    if not (csLoading in ComponentState) then Sort;
end;

procedure TColumnComboBox.WMLButtonUp(var Msg:TWMLButtonDown);
begin
 inherited;
 if FDropped then
  begin
    ItemIndex:=fItemIndex;
    if SendMessage(self.Handle,CB_GETDROPPEDSTATE,0,0)=0 then
        FDropped:=false;
  end;
end;

procedure TColumnComboBox.CMHintShow(var Msg: TMessage);
var
  hi: PHintInfo;
  s: string;
  i: Integer;
begin
  hi := PHintInfo(Msg.LParam);

  if (ItemIndex >= 0) and FShowItemHint then
  begin
    hi^.HintStr := Items[ItemIndex];
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

function TColumnComboBox.GetDelimiter: Char;
begin
  Result := FDelimiter;
end;

procedure TColumnComboBox.SetDelimiter(const Value: Char);
begin
  FDelimiter := Value;
end;

procedure TColumnComboBox.WMChar(var Msg: TWMChar);
var
  i: Integer;
  s: string;
  Key: Char;

  function Max(a,b: Integer): Integer;
  begin
   if (a > b) then
     Result := a
   else
     Result := b;
  end;

begin
  inherited;

  Key := Chr(Msg.CharCode);

  if Key = #13 then
    Exit;

  if not FLookupIncr then
    FLookup := Key
  else
    FLookup := FLookup + Key;

  if (ItemIndex>=0) or (FLookupIncr) then
  begin
    for i := Max(1,ItemIndex+1) to Items.Count do
    begin
      s := ColumnItems[i-1,FLookupColumn];
      if (s <> '') then
        if (pos(AnsiUpperCase(FLookup),AnsiUpperCase(s)) = 1) then
        begin
          ItemIndex := i-1;
          if Assigned(OnChange) then
            OnChange(Self);
          Exit;
        end;
    end;
  end;

  for i := 1 to Items.Count do
  begin
    s := ColumnItems[i-1,FLookupColumn];

    if (s <> '') then
      if (Pos(Uppercase(FLookup),Uppercase(s))=1) then
      begin
        ItemIndex := i - 1;
        if Assigned(OnChange) then
          OnChange(Self);
        Exit;
      end;
  end;

  if FLookupIncr then
  begin
    FLookup := Key;
    for i := 1 to Items.Count do
    begin
      s := ColumnItems[i-1,FLookupColumn];
      if (s<>'') then
        if (pos(AnsiUpperCase(FLookup),AnsiUpperCase(s))=1) then
        begin
          ItemIndex := i - 1;
          if Assigned(OnChange) then
            OnChange(Self);
          Exit;
        end;
    end;
  end;
end;



{ TComboColumnItem }

procedure TComboColumnItem.Assign(Source: TPersistent);
begin
 if Source is TComboColumnItem then
  begin
    Color:=TComboColumnItem(source).Color;
    ColumnType:=TComboColumnItem(source).ColumnType;
    Width:=TComboColumnItem(source).Width;
    Alignment:=TComboColumnItem(source).Alignment;
    Font.Assign(TComboColumnItem(source).Font);
  end;
end;

constructor TComboColumnItem.Create(Collection: TCollection);
begin
  inherited;
  FFont:=TFont.Create;
  FWidth:=100;
  FColor:=clWindow;
end;

destructor TComboColumnItem.Destroy;
begin
  FFont.Free;
  Inherited;
end;

function TComboColumnItem.GetDisplayName: string;
begin
  Result := 'Column'+inttostr(index);
end;

procedure TComboColumnItem.SetAlignment(const Value: tAlignment);
begin
  FAlignment:=Value;
  TComboColumnCollection(Collection).FOwner.Invalidate;
end;

procedure TComboColumnItem.SetColor(const Value: TColor);
begin
  FColor:=Value;
  TComboColumnCollection(Collection).FOwner.Invalidate;
end;

procedure TComboColumnItem.SetColumnType(const Value: TColumnType);
begin
  FColumnType := Value;
  TComboColumnCollection(Collection).FOwner.Invalidate;
end;

procedure TComboColumnItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  TComboColumnCollection(Collection).FOwner.Invalidate;
end;

procedure TComboColumnItem.SetWidth(const Value: Integer);
begin
  FWidth := Value;
  TComboColumnCollection(Collection).FOwner.Invalidate;
end;

{ TComboColumnCollection }

function TComboColumnCollection.Add: TComboColumnItem;
begin
  Result := TComboColumnItem(inherited Add);
end;

constructor TComboColumnCollection.Create(AOwner: TColumnComboBox);
begin
  inherited Create(TComboColumnItem);
  FOwner := AOwner;
end;

function TComboColumnCollection.GetItem(Index: Integer): TComboColumnItem;
begin
  Result := TComboColumnItem(inherited Items[index]);
end;

function TComboColumnCollection.GetOwner: tPersistent;
begin
  Result := FOwner;
end;

function TComboColumnCollection.Insert(index: Integer): TComboColumnItem;
begin
  {$IFNDEF DELPHI4_LVL}
  Result := TComboColumnItem(inherited Add);
  {$ELSE}
  Result := TComboColumnItem(inherited Insert(index));
  {$ENDIF}
end;

procedure TComboColumnCollection.SetItem(Index: Integer;
  const Value: TComboColumnItem);
begin
 inherited SetItem(Index, Value);
end;

procedure TComboColumnCollection.Update(Item: TCollectionItem);
begin
  inherited;
end;


{ TComboItemCollection }

function TComboItemCollection.Add: TComboItem;
begin
  Result := TComboItem(inherited Add);
end;

constructor TComboItemCollection.Create(AOwner: TColumnComboBox);
begin
  inherited Create(TComboItem);
  FOwner := AOwner;
end;

function TComboItemCollection.GetItem(Index: Integer): TComboItem;
begin
  Result := TComboItem(inherited Items[index]);
end;

function TComboItemCollection.GetOwner: tPersistent;
begin
  Result := FOwner;
end;

function TComboItemCollection.IndexInColumnOf(col: Integer;
  s: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 1 to Count do
  begin
    if Items[i - 1].Strings.Count > Col then
      if Items[i - 1].Strings[Col] = s then
      begin
        Result := i - 1;
        Break;
      end;
  end;
end;

function TComboItemCollection.IndexInRowOf(row: Integer;
  s: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  if (Count > Row) then
    for i := 1 to Items[row].Strings.Count do
    begin
      if Items[Row].Strings[i - 1] = s then
      begin
        Result := i - 1;
        Break;
      end;
    end;
end;


function TComboItemCollection.IndexOf(s: string): tpoint;
var
  i,j: Integer;

begin
  Result:=point(-1,-1);

  for i := 1 to Count do
  begin
    for j := 1 to Items[i-1].Strings.Count do
      if Items[i-1].Strings[j-1]=s then
      begin
        Result.y := i-1;
        Result.x := j-1;
        Break;
      end;
  end;
end;

function TComboItemCollection.Insert(Index: Integer): TComboItem;
begin
  {$IFNDEF DELPHI4_LVL}
  Result := TComboItem(inherited Add);
  {$ELSE}
  Result := TComboItem(inherited Insert(Index));
  {$ENDIF}
end;

procedure TComboItemCollection.SetItem(Index: Integer;
  const Value: TComboItem);
begin
 inherited SetItem(Index, Value);
end;

procedure TComboItemCollection.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TComboItem }

procedure TComboItem.Assign(Source: TPersistent);
begin
  if Source is TComboItem then
  begin
    ImageIndex:=TComboItem(Source).ImageIndex;
    Strings.Assign(TComboItem(Source).Strings);
    TComboItemCollection(collection).FOwner.BuildItems;
  end;
end;

constructor TComboItem.Create(Collection: TCollection);
begin
  inherited;
  FStrings:=TStringList.Create;
  FImageIndex:=-1;
  FStrings.OnChange:=StringsChanged;
end;

destructor TComboItem.Destroy;
var
  AOwner: TColumnCombobox;
begin
  AOwner := TComboItemCollection(Collection).FOwner;
  FStrings.Free;
  inherited;
  if AOwner.HandleAllocated then AOwner.BuildItems;
end;

function TComboItem.GetDisplayName: string;
begin
  Result := 'Item'+inttostr(index);
end;

procedure TComboItem.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  TComboItemCollection(collection).FOwner.Invalidate;
end;

procedure TComboItem.SetStrings(const Value: TStringList);
begin
  FStrings.Assign(Value);
  TComboItemCollection(Collection).FOwner.Invalidate;
end;

procedure TComboItem.StringsChanged(Sender: TObject);
var
  idx: Integer;
begin
  if TComboItemCollection(Collection).FOwner.FUpdateCount > 0 then
    Exit;
  idx := TComboItemCollection(Collection).FOwner.ItemIndex;
  TComboItemCollection(Collection).FOwner.BuildItems;
  TComboItemCollection(Collection).FOwner.ItemIndex := idx;
end;

procedure TColumnComboBox.WndProc(var Msg: TMessage);
begin
  inherited;
end;


end.
