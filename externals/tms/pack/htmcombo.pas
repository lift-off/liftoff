{************************************************************************}
{ THTMLComboBox component                                                }
{ for Delphi 3.0,4.0,5.0,6.0 + C++Builder 3.0,4.0,5.0                    }
{ version 1.4, August 2001                                               }
{                                                                        }
{ Copyright © 1999-2001                                                  }
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

unit htmcombo;

{$I TMSDEFS.INC}
{$DEFINE REMOVEDRAW}
{$DEFINE HILIGHT}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls,
  PictureContainer;


{$IFNDEF DELPHI3_LVL}
const
  crHandPoint = crUpArrow;
{$ENDIF}

type
  EHTMLComboBoxError = class(Exception);

  TAnchorClick = procedure(Sender:TObject;index:integer;anchor:string) of object;

  TBaseCustomComboBox = class(TCustomComboBox)
  private
    FAutoFocus: boolean;
    FFlat: Boolean;
    FEtched: Boolean;
    FOldColor: TColor;
    FOldParentColor: Boolean;
    FButtonWidth: Integer;
    FFocusBorder: Boolean;
    FMouseInControl: Boolean;
    fDropWidth: integer;
    procedure SetEtched(const Value: Boolean);
    procedure SetFlat(const Value: Boolean);
    procedure SetButtonWidth(const Value: Integer);
    procedure DrawButtonBorder(DC:HDC);
    procedure DrawControlBorder(DC:HDC);
    procedure DrawBorders;
    function  Is3DBorderControl: Boolean;
    function  Is3DBorderButton: Boolean;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CNCommand (var Message: TWMCommand); message CN_COMMAND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure SetDropWidth(const Value: integer);
  protected
    property ButtonWidth: integer read fButtonWidth write SetButtonWidth;
    property Flat: Boolean read FFlat write SetFlat;
    property Etched: Boolean read FEtched write SetEtched;
    property FocusBorder: Boolean read FFocusBorder write FFocusBorder;
    property AutoFocus: Boolean read FAutoFocus write FAutoFocus;
    property DropWidth: integer read FDropWidth write SetDropWidth;
  public
    constructor Create(AOwner: TComponent); override;
  end;


  THTMLComboBox = class(TBaseCustomComboBox)
  private
    FURLColor:TColor;
    FIncrLookup:boolean;
    FImages:TImageList;
    FDropHeight:integer;
    FOldAnchor:string;
    FLookup:string;
    FItemIndex:integer;
    FSortedEx: boolean;
    FDropped: boolean;
    FAnchorClick:TAnchorClick;
    FAnchorEnter:TAnchorClick;
    FAnchorExit:TAnchorClick;
    FEllipsis: Boolean;
    FContainer: TPictureContainer;
    FShadowOffset: Integer;
    FShadowColor: TColor;
    FImageCache:THTMLPictureCache;
    FItemHint: Boolean;
    FHTMLHint: Boolean;
    procedure SetDropWidth(value:integer);
    function GetDropWidth:integer;
    procedure SetEditHeight(value:integer);
    function GetEditHeight:integer;
    procedure SetImages(const Value: TImageList);
    procedure SetURLColor(const Value: TColor);
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CMHintShow(Var Msg: TMessage); message CM_HINTSHOW;    
    procedure WMLButtonDown(var Msg:TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg:TWMLButtonDown); message WM_LBUTTONUP;
    procedure WMChar(var Msg:TWMChar); message WM_CHAR;
    function GetTextItem(index:integer):string;
    procedure SetItemIndexP(const Value : integer);
    function GetItemIndexP:integer;
    function GetSortedEx: boolean;
    procedure SetSortedEx(const Value: Boolean);
    procedure SetEllipsis(const Value: Boolean);
    procedure SetShadowColor(const Value: TColor);
    procedure SetShadowOffset(const Value: Integer);
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure SetStyle(Value: TComboBoxStyle); override;
    procedure MeasureItem(Index: Integer; var Height: Integer); override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure CreateWnd; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure HilightInList(HiText: string; DoCase: Boolean);
    procedure HilightInItem(Index: Integer; HiText: string; DoCase: Boolean);
    procedure UnHilightInList;
    procedure UnHilightInItem(Index: Integer);
    procedure MarkInList(HiText: string; DoCase: Boolean);
    procedure MarkInItem(Index: Integer; HiText: string; DoCase: Boolean);
    procedure UnMarkInList;
    procedure UnMarkInItem(Index: Integer);

    property TextItems[index:integer]:string read GetTextItem;
    property Text;
  published
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property Constraints;
    {$ENDIF}
    property AutoFocus;
    property ButtonWidth;
    property Style;
    property Flat;
    property Etched;
    property FocusBorder;

    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property DropWidth: Integer read GetDropWidth write SetDropWidth;
    property DropHeight: Integer read fDropHeight write fDropHeight;
    property EditHeight: Integer read GetEditheight write SetEditHeight;
    property Ellipsis: Boolean read FEllipsis write SetEllipsis;
    property Enabled;
    property Font;
    property HTMLHint: Boolean read FHTMLHint write FHTMLHint;
    property Images:TImageList read FImages write SetImages;
    property IncrLookup: Boolean read FIncrLookup write FIncrLookup default false;
    property ItemHint: Boolean read FItemHint write FItemHint;
    property Items;
    property ItemIndex: Integer read GetItemIndexP write SetItemIndexP;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PictureContainer: TPictureContainer read FContainer write FContainer;
    property PopupMenu;
    property ShadowColor: TColor read FShadowColor write SetShadowColor;
    property ShadowOffset: Integer read FShadowOffset write SetShadowOffset;
    property ShowHint;
    property Sorted: Boolean read GetSortedEx write SetSortedEx;
    property TabOrder;
    property TabStop;
    property URLColor: TColor read fURLColor write SetURLColor;
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
    property OnAnchorClick: TAnchorClick read FAnchorClick write FAnchorClick;
    property OnAnchorEnter: TAnchorClick read FAnchorEnter write FAnchorEnter;
    property OnAnchorExit: TAnchorClick read FAnchorExit write FAnchorExit;
  end;


implementation
uses
  Extctrls,ShellApi,CommCtrl,Forms {$IFDEF DELPHI4_LVL} ,ImgList {$ENDIF};

{$I htmlengo.pas}

procedure THTMLComboBox.SetStyle(Value: TComboBoxStyle);
begin
//  inherited SetStyle(csOwnerDrawVariable);
 inherited SetStyle(csOwnerDrawFixed);
end;

procedure THTMLComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  r,hr: TRect;
  a,s,fa : string;
  xsize,ysize,hoverlink,mouselink : Integer;
  urlcol: TColor;
begin
  r := Rect;
  if odSelected in State then
  begin
    Canvas.Brush.Color := clHighLight;
    Canvas.Pen.Color := clHighLight;
    Canvas.Font.Color := clHighLightText;
    Urlcol := clHighLightText;
  end
  else
  begin
    Canvas.Brush.Color := Color;
    Canvas.Pen.Color := Color;
    Canvas.Font.Color := Font.Color;
    Urlcol := FURLColor;
   end;

  Canvas.Rectangle(r.left,r.top,r.right,r.bottom);

  Offsetrect(r,2,0);
  HTMLDrawEx(Canvas,Items[Index],r,FImages,0,0,-1,-1,FShadowOffset,False,False,False,(odSelected in State),True,False,not Ellipsis,
             1.0,URLCol,clNone,clNone,FShadowColor,a,s,fa,xsize,ysize,hoverlink,mouselink,hr,FImageCache,FContainer);

  Canvas.Brush.Color := self.Color;
  Canvas.Pen.Color := self.Color;
end;

procedure THTMLComboBox.CreateWnd;
begin
  inherited CreateWnd;
end;

constructor THTMLComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := csOwnerDrawFixed;
  FURLColor := clBlue;
  FDropHeight := 200;
  FOldAnchor := '';
  FLookup := '';
  FItemIndex := -1;
  FImageCache := THTMLPictureCache.Create;
end;

procedure THTMLComboBox.MeasureItem(Index: Integer; var Height: Integer);
var
  res,xsize,ysize,hoverlink,mouselink: Integer;
  r,hr: TRect;
  a,s,fa: string;
  Canvas: TCanvas;
begin
  height := 40;
  if (index >= 0) and (index < self.Items.Count) then
  begin
    r := GetClientRect;
    r.bottom := r.top + 1000;
    Canvas := TCanvas.Create;
    Canvas.handle := GetDC(self.Handle);


    HTMLDrawEx(Canvas,Items[Index],r,FImages,0,0,-1,-1,FShadowOffset,True,True,False,True,True,False,not Ellipsis,
               1.0,FURLColor,clNone,clNone,FShadowColor,a,s,fa,xsize,ysize,hoverlink,mouselink,hr,FImageCache,FContainer);

//    HTMLDraw(Canvas,items[index],r,fImages,0,0,true,true,false,true,true,true,1.0,fURLColor,a,s,xsize,ysize);
    ReleaseDC(Handle,Canvas.Handle);
    Canvas.Free;
    res := ysize + 4;
    SendMessage(self.handle,CB_SETITEMHEIGHT,index,res);
  end
  else
    Res := EditHeight;
  Height := Res;
end;

function THTMLComboBox.GetDropWidth: integer;
begin
  Result := SendMessage(self.handle,CB_GETDROPPEDWIDTH,0,0);
end;

procedure THTMLComboBox.SetDropWidth(value: integer);
begin
 SendMessage(self.Handle,CB_SETDROPPEDWIDTH,value,0);
end;

function THTMLComboBox.GetEditHeight: integer;
begin
 result := SendMessage(self.Handle,CB_GETITEMHEIGHT,-1,0);
end;

procedure THTMLComboBox.SetEditHeight(value: integer);
begin
  SendMessage(self.Handle,CB_SETITEMHEIGHT,-1,value);
  SendMessage(self.Handle,CB_SETITEMHEIGHT,0,value);
end;

procedure THTMLComboBox.SetImages(const Value: TImageList);
begin
  FImages := Value;
  Repaint;
end;

procedure THTMLComboBox.CNCommand(var Message: TWMCommand);
begin
 case message.NotifyCode of
 CBN_DROPDOWN:
  begin
    MoveWindow(self.Handle,self.left,self.top,width,EditHeight+fDropheight,true);
    DropDown;
    message.Result := 0;
    FDropped := True;
    if Assigned(OnClick) then
      OnClick(Self);
  end;
 CBN_SELCHANGE:
   begin
     fDropped := False;
     fItemIndex := SendMessage(self.Handle,CB_GETCURSEL,0,0);
     if Assigned(OnChange) then
       OnChange(Self);
   end;
 else inherited;
 end;
end;

procedure THTMLComboBox.WMLButtonUp(var Msg:TWMLButtonDown);
begin
 inherited;
 if fDropped and (fItemIndex<>-1) then
  begin
    ItemIndex:=fItemIndex;
    if SendMessage(self.Handle,CB_GETDROPPEDSTATE,0,0)=0 then
        fDropped:=false;
  end;
end;

procedure THTMLComboBox.WMLButtonDown(var Msg:TWMLButtonDown);
var
  res: Integer;
  r,hr: TRect;
  anchor,stripped,fa: string;
  xsize,ysize,hoverlink,mouselink: Integer;
  Canvas: TCanvas;
begin
  res := self.ItemIndex;

  if (res >= 0) and (res < self.Items.Count) then
  begin
    r := ClientRect;
    Canvas := TCanvas.Create;
    Canvas.handle := GetDC(self.handle);

    if HTMLDrawEx(Canvas,Items[res],r,FImages,msg.XPos,msg.YPos,-1,-1,FShadowOffset,True,False,False,True,True,False,not Ellipsis,
             1.0,FURLColor,clNone,clNone,FShadowColor,anchor,stripped,fa,xsize,ysize,hoverlink,mouselink,hr,FImageCache,FContainer) then

//    if HTMLDraw(canvas,self.Items[res],r,fImages,msg.Xpos,msg.Ypos,true,false,false,true,true,true,1.0,fURLColor,anchor,stripped,xsize,ysize) then
    begin
     ReleaseDC(self.handle,canvas.handle);
     canvas.Free;

     if (pos('://',anchor)>0) or (pos('mailto:',anchor)>0) then
        shellexecute(0,'open',pchar(anchor),nil,nil,SW_NORMAL)
     else
       begin
        if assigned(fAnchorClick) then fAnchorClick(self,res,anchor);
       end;
     msg.Result:=0;
     Exit;
    end;
    ReleaseDC(self.handle,canvas.handle);
    canvas.free;
  end;

 inherited;
end;



procedure THTMLComboBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
  r,hr: TRect;
  a,s,fa: string;
  xsize,ysize,hoverlink,mouselink: Integer;
  canvas: TCanvas;
begin
  inherited MouseMove(Shift,X,Y);

 res:=self.ItemIndex;

 if (res>=0) and (res<self.Items.Count) then
  begin
   r := ClientRect;
   canvas := TCanvas.Create;
   canvas.handle := GetDC(self.handle);

    if HTMLDrawEx(Canvas,Items[res],r,FImages,X,Y,-1,-1,FShadowOffset,True,False,False,True,True,False,not Ellipsis,
             1.0,FURLColor,clNone,clNone,FShadowColor,a,s,fa,xsize,ysize,hoverlink,mouselink,hr,FImageCache,FContainer) then

//   if HTMLDraw(canvas,self.Items[res],r,fImages,X,Y,true,false,false,true,true,true,1.0,fURLColor,a,s,xsize,ysize) then
    begin
     if (a<>fOldAnchor) then
       if assigned(fAnchorExit) then fAnchorEnter(self,res,fOldAnchor);
     if assigned(fAnchorEnter) then fAnchorEnter(self,res,a);
     self.Cursor:=crHandPoint;
     fOldAnchor:=a;
    end
   else
    begin
     if (self.Cursor<>crDefault) or (a<>fOldAnchor) then
          if assigned(fAnchorExit) then fAnchorExit(self,res,fOldAnchor);
     self.Cursor:=crDefault;
     fOldAnchor:='';
    end;

   ReleaseDC(self.handle,canvas.handle);
   canvas.Free;
  end;

end;

procedure THTMLComboBox.SetURLColor(const Value: TColor);
begin
 fURLColor:=value;
 self.Repaint;
end;

function THTMLCombobox.GetTextItem(Index: Integer):string;
var
  xsize,ysize,hoverlink,mouselink:integer;
  a,s,fa:string;
  r,hr: TRect;
  Canvas: TCanvas;
begin
  Result := '';
  
  if (Index >= 0) and (Index < self.Items.Count) then
  begin
    r := self.ClientRect;
    Canvas := TCanvas.Create;
    Canvas.Handle := GetDC(self.Handle);

    HTMLDrawEx(Canvas,Items[index],r,FImages,0,0,-1,-1,FShadowOffset,True,True,False,True,True,False,not Ellipsis,
               1.0,FURLColor,clNone,clNone,FShadowColor,a,s,fa,xsize,ysize,hoverlink,mouselink,hr,FImageCache,FContainer);

//   HTMLDraw(canvas,self.Items[index],r,fImages,0,0,true,true,false,true,true,true,1.0,fURLColor,a,s,xsize,ysize);
    ReleaseDC(self.Handle,Canvas.Handle);
    Canvas.Free;
    Result := s;
  end
  else
    raise EHTMLComboboxError.Create('Item index out of range');
end;


function THTMLComboBox.GetItemIndexP: integer;
begin
  Result := SendMessage(self.Handle,CB_GETCURSEL,0,0);
end;

procedure THTMLComboBox.SetItemIndexP(const Value: integer);
begin
  if FDropped then
    FItemIndex := Value;
  SendMessage(self.handle,CB_SETCURSEL,value,0);
end;

procedure THTMLComboBox.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FImages) then
    FImages := nil;

  if (AOperation = opRemove) and (AComponent = FContainer) then
    FContainer := nil;

  inherited;
end;

procedure THTMLComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  Inherited;

  if key in [vk_up,vk_down,vk_left,vk_right,vk_next,vk_prior,vk_home,vk_end,vk_escape] then
      fLookup:='';

  if (key=vk_back) and (length(fLookup)>0) then delete(fLookup,length(fLookup),1);
end;

procedure THTMLComboBox.DoEnter;
begin
  inherited;
  fLookup:='';
end;

procedure THTMLComboBox.WMChar(var Msg: TWMChar);
var
  i:integer;
  s:string;
  Key: Char;

  function Max(a,b:integer):integer;
  begin
   if a>b then result:=a else result:=b;
  end;

begin
  Inherited;

  Key := Chr(Msg.CharCode);

  if not fIncrLookup then fLookup:=Key else
  fLookup:=fLookup+Key;

  if (ItemIndex>=0) or (fIncrLookup) then
   begin
      for i:=Max(1,ItemIndex+1) to Items.Count do
       begin
        s:=TextItems[i-1];
        if (s<>'') then
        if (pos(uppercase(fLookup),uppercase(s))=1) then
          begin
           ItemIndex:=i-1;
           Exit;
          end;
       end;
   end;

  for i:=1 to Items.Count do
   begin
    s:=TextItems[i-1];
    if (s<>'') then
    if (pos(uppercase(fLookup),uppercase(s))=1) then
      begin
       ItemIndex:=i-1;
       Exit;
      end;
   end;

  if fIncrLookup then
   begin
    fLookup:=Key;
    for i:=1 to Items.Count do
     begin
      s:=TextItems[i-1];
      if (s<>'') then
      if (pos(uppercase(fLookup),uppercase(s))=1) then
       begin
        ItemIndex:=i-1;
        Exit;
       end;
     end;
   end;
end;

function THTMLComboBox.GetSortedEx: boolean;
begin
  Result := FSortedEx;
end;

{$IFDEF DELPHI5_LVL}
function HTMLCompare(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := AnsiStrComp(pchar(HTMLStrip(List.Strings[Index1])),pchar(HTMLStrip(List.Strings[Index2])));
end;
{$ELSE}
procedure QuickSortList(List:TStringList;left,right:integer);
var
  i,j: Integer;
  s,sw: string;

begin
  i := Left;
  j := Right;

  {get middle item here}
  s := HTMLStrip(List.Strings[(left+right) shr 1]);

  repeat
    {$IFDEF VER90}
    while (StrComp(pchar(s),pchar(HTMLStrip(List.Strings[i])))>0) and (i<right) do inc(i);
    while (StrComp(pchar(s),pchar(HTMLStrip(List.Strings[j])))<0) and (j>left) do dec(j);
    {$ELSE}
    while (AnsiStrComp(pchar(s),pchar(HTMLStrip(List.Strings[i])))>0) and (i<right) do inc(i);
    while (AnsiStrComp(pchar(s),pchar(HTMLStrip(List.Strings[j])))<0) and (j>left) do dec(j);
    {$ENDIF}
    if (i<=j) then
    begin
      if (i<>j) then
      begin
        {$IFDEF VER90}
        if StrComp(pchar(HTMLStrip(List.Strings[i])),pchar(HTMLStrip(List.Strings[j])))<>0 then
        {$ELSE}
        if AnsiStrComp(pchar(HTMLStrip(List.Strings[i])),pchar(HTMLStrip(List.Strings[j])))<>0 then
        {$ENDIF}
        begin
          sw := List.Strings[i];
          List.Strings[i] := List.Strings[j];
          List.Strings[j] := sw;
        end;
      end;
      inc(i);
      dec(j);
    end;
  until i > j;

  if left < j then QuicksortList(List,left,j);
  if i < right then QuickSortList(List,i,right);
end;
{$ENDIF}


procedure THTMLComboBox.SetSortedEx(const Value: boolean);
var
 sl: TStringList;
 idx: integer;
begin
 fsortedEx := Value;

 if Value then
  begin
   idx := ItemIndex;
   sl := TStringList.Create;
   sl.Assign(Items);

   {$IFDEF DELPHI5_LVL}
   sl.CustomSort(HTMLCompare);
   {$ELSE}
   if sl.Count>1 then
   QuickSortList(sl,0,sl.Count-1);
   {$ENDIF}

   Items.Assign(sl);
   sl.Free;
   ItemIndex := idx;
  end;

end;


procedure THTMLComboBox.SetEllipsis(const Value: Boolean);
begin
  FEllipsis := Value;
  Invalidate;
end;

procedure THTMLComboBox.SetShadowColor(const Value: TColor);
begin
  FShadowColor := Value;
  Invalidate;
end;

procedure THTMLComboBox.SetShadowOffset(const Value: Integer);
begin
  FShadowOffset := Value;
  Invalidate;
end;

destructor THTMLComboBox.Destroy;
begin
  FImageCache.Free;
  inherited;
end;

procedure THTMLComboBox.CMHintShow(var Msg: TMessage);
{$IFNDEF DELPHI3_LVL}
type
  PHintInfo = ^THintInfo;
{$ENDIF}
var
  CanShow: Boolean;
  hi: PHintInfo;
  Anchor: string;
  R: TRect;

Begin
  CanShow := True;
  hi := PHintInfo(Msg.LParam);
  Anchor :='';

  if FItemHint then
  begin
    if HTMLHint then
      Hi^.HintStr := Items[ItemIndex]
    else
      Hi^.HintStr := TextItems[ItemIndex];
    Hi^.Hintpos.X := 0;
    Hi^.Hintpos.Y := R.Top;
    Hi^.HintPos := ClientToScreen(Hi^.HintPos);
  end;
  Msg.Result := Ord(Not CanShow);
end;

procedure THTMLComboBox.HilightInItem(Index: Integer; HiText: string;
  DoCase: Boolean);
begin
  Items[Index] := Hilight(Items[Index],HiText,'hi',DoCase);
end;

procedure THTMLComboBox.HilightInList(HiText: string; DoCase: Boolean);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items[i - 1] := Hilight(Items[i - 1],HiText,'hi',DoCase);
end;

procedure THTMLComboBox.MarkInItem(Index: Integer; HiText: string;
  DoCase: Boolean);
begin
  Items[Index] := Hilight(Items[Index],HiText,'e',DoCase);
end;

procedure THTMLComboBox.MarkInList(HiText: string; DoCase: Boolean);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items[i - 1] := Hilight(Items[i - 1],HiText,'e',DoCase);
end;

procedure THTMLComboBox.UnHilightInItem(Index: Integer);
begin
  Items[Index] := UnHilight(Items[Index],'hi');
end;

procedure THTMLComboBox.UnHilightInList;
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items[i - 1] := UnHilight(Items[i - 1],'hi');
end;

procedure THTMLComboBox.UnMarkInItem(Index: Integer);
begin
  Items[Index] := UnHilight(Items[Index],'e');
end;

procedure THTMLComboBox.UnMarkInList;
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items[i - 1] := UnHilight(Items[i - 1],'e');
end;




{ TBaseCustomComboBox }
constructor TBaseCustomComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL) + 2;
  FOldColor := inherited Color;
  FOldParentColor := inherited ParentColor;
  FFlat := False;
  FMouseInControl := false;
end;

procedure TBaseCustomComboBox.SetButtonWidth(const Value: integer);
begin
  if (value<14) or (value>32) then
    Exit;

  FButtonWidth:=value;
  Invalidate;
end;

procedure TBaseCustomComboBox.SetFlat(const Value: Boolean);
begin
  if Value<>FFlat then
  begin
    FFlat:=Value;
    Ctl3D:=not Value;
    Invalidate;
  end;
end;

procedure TBaseCustomComboBox.SetEtched(const Value: Boolean);
begin
  if Value<>FEtched then
  begin
    FEtched:=Value;
    Invalidate;
  end;
end;

procedure TBaseCustomComboBox.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if not (csDesigning in ComponentState) then DrawBorders;
end;

procedure TBaseCustomComboBox.CMExit(var Message: TCMExit);
begin
  inherited;
  if not (csDesigning in ComponentState) then DrawBorders;
end;

procedure TBaseCustomComboBox.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if not FMouseInControl and Enabled then
    begin
     FMouseInControl := True;
     DrawBorders;
    end;
  if fAutoFocus then self.SetFocus;
end;

procedure TBaseCustomComboBox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled then
    begin
     FMouseInControl := False;
     DrawBorders;
    end;
end;

procedure TBaseCustomComboBox.CMEnabledChanged(var Msg: TMessage);
begin
  if FFlat then
   begin
    if Enabled then
      begin
       inherited ParentColor:=FOldParentColor;
       inherited Color:=FOldColor;
      end
    else
      begin
       FOldParentColor:=inherited Parentcolor;
       FOldColor:=inherited Color;
       inherited ParentColor:=True;
      end;
   end;
 inherited;
end;

procedure TBaseCustomComboBox.WMNCPaint(var Message: TMessage);
begin
  inherited;
  if FFlat then DrawBorders;
end;

procedure TBaseCustomComboBox.WMPaint(var Message: TWMPaint);
var
   DC: HDC;
   PS: TPaintStruct;

   procedure DrawButton;
   var
     ARect: TRect;
   begin
     GetWindowRect(Handle, ARect);
     OffsetRect(ARect, -ARect.Left, -ARect.Top);
     Inc(ARect.Left, ClientWidth - FButtonWidth);
     InflateRect(ARect, -1, -1);
     DrawFrameControl(DC, ARect, DFC_SCROLL, DFCS_SCROLLCOMBOBOX or DFCS_FLAT );
     ExcludeClipRect(DC, ClientWidth - FButtonWidth - 2, 0, ClientWidth, ClientHeight);
   end;

begin

  if not FFlat then
    begin
     inherited;
     Exit;
    end;

  if Message.DC = 0 then
    DC:=BeginPaint(Handle, PS)
  else
    DC:=Message.DC;
  try
    if (Style<>csSimple) then
      begin
       FillRect(DC, ClientRect, Brush.Handle);
       DrawButton;
      end;
    PaintWindow(DC);
  finally
    if Message.DC=0 then
      EndPaint(Handle, PS);
  end;
  DrawBorders;
end;

function TBaseCustomComboBox.Is3DBorderControl: Boolean;
begin
  if csDesigning in ComponentState then
    Result := False
  else
    Result := FMouseInControl or (GetFocus = Handle);

  Result := Result and FFocusBorder;
end;

function TBaseCustomComboBox.Is3DBorderButton: Boolean;
begin
  if csDesigning in ComponentState then
    Result := Enabled
  else
    Result := FMouseInControl or (GetFocus = Handle);
end;

procedure TBaseCustomComboBox.DrawButtonBorder(DC: HDC);
const
   Flags: array[Boolean] of Integer = (0, BF_FLAT);
   Edge: array[Boolean] of Integer = (EDGE_RAISED,EDGE_ETCHED);
var
   ARect: TRect;
   BtnFaceBrush: HBRUSH;
begin

  ExcludeClipRect(DC, ClientWidth - FButtonWidth + 4, 4, ClientWidth - 4, ClientHeight - 4);

  GetWindowRect(Handle, ARect);
  OffsetRect(ARect, -ARect.Left, -ARect.Top);
  Inc(ARect.Left, ClientWidth - FButtonWidth - 2);
  InflateRect(ARect, -2, -2);

  if Is3DBorderButton then
   DrawEdge(DC, ARect, Edge[Etched], BF_RECT or Flags[DroppedDown])
  else
    begin
     BtnFaceBrush:=CreateSolidBrush(GetSysColor(COLOR_BTNFACE));
     InflateRect(ARect, 0, -1);
     arect.right:=arect.right-1;
     FillRect(DC, ARect, BtnFaceBrush);
     DeleteObject(BtnFaceBrush);
    end;

  ExcludeClipRect(DC, ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
end;

procedure TBaseCustomComboBox.DrawControlBorder(DC: HDC);
var
  ARect:TRect;
  BtnFaceBrush, WindowBrush: HBRUSH;
begin

  if Is3DBorderControl then
   BtnFaceBrush:=CreateSolidBrush(GetSysColor(COLOR_BTNFACE))
  else
   BtnFaceBrush:=CreateSolidBrush(ColorToRGB((parent as TWinControl).brush.color));

  //WindowBrush:=CreateSolidBrush(GetSysColor(COLOR_WINDOW));
  WindowBrush:=CreateSolidBrush(ColorToRGB(self.Color));

  try
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);
    if Is3DBorderControl then
     begin
      DrawEdge(DC, ARect, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, WindowBrush);
     end
    else
     begin
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, WindowBrush);
     end;
  finally
    DeleteObject(WindowBrush);
    DeleteObject(BtnFaceBrush);
  end;
end;

procedure TBaseCustomComboBox.DrawBorders;
var
  DC: HDC;
begin
  if not FFlat then Exit;
  DC := GetWindowDC(Handle);
  try
   DrawControlBorder(DC);
   if (Style<>csSimple) then DrawButtonBorder(DC);
  finally
   ReleaseDC(DC, Handle);
  end;
end;

procedure TBaseCustomComboBox.CNCommand(var Message: TWMCommand);
var
  r:TRect;
begin
  inherited;
 
  if (Message.NotifyCode in [CBN_CLOSEUP,CBN_DROPDOWN]) then
  begin
    r := GetClientRect;
    r.Left := r.Right - Fbuttonwidth;
    InvalidateRect(Handle,@r,FALSE);
  end;
end;


procedure TBaseCustomComboBox.SetDropWidth(const Value: integer);
begin
  FDropWidth := Value;
  if Value > 0 then
    SendMessage(self.Handle,CB_SETDROPPEDWIDTH,FDropWidth,0);
end;




end.
