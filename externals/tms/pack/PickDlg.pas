{********************************************************************
TPICKDIALOG component
for Delphi 2.0,3.0,4.0,5.0 & C++ Builder 1.0,3.0,4.0
version 1.5

written by 
           TMS Software
           copyright © 1998-1999
           Email : info@tmssoftware.com
           Website : http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The source
code remains property of the author and may not be distributed
freely as such.
********************************************************************}

unit PickDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TButtonPosition = (bpBottom,bpRight,bpNone);

  TDialogPosition = (fposCenter,fposAbsolute,fposDefault);

  TClickItemEvent = procedure(Sender:TObject;index:integer;itemstr:string) of object;
  TDblClickItemEvent = procedure(Sender:TObject;index:integer;itemstr:string) of object;

  TPickDialog = class;

  TSelectForm = class(TForm)
    SelectList: TListBox;
    okbtn: TButton;
    cancelbtn: TButton;
    title: TLabel;
    procedure okbtnClick(Sender: TObject);
    procedure cancelbtnClick(Sender: TObject);
    procedure SelectListDblClick(Sender: TObject);
    procedure SelectListClick(Sender: TObject);
  private
    fparentcontrol:TPickDialog;
    { Private declarations }
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message wm_EraseBkGnd;
    procedure WMSize(var Message: TWMSize); message wm_size;
    procedure WMNCHitTest(var Message: TMessage); message wm_nchittest;
    procedure WMMinMaxInfo(var Message: TMessage); message wm_getminmaxinfo;
  public
    cresizex,cresizey:integer;
    fbuttonpos:tbuttonposition;
    acceptdblclick:boolean;
    { Public declarations }
  end;


  TPickDialog = class(TComponent)
             private
              fCaption:string;
              fTitle:string;
              fPickList:TStringlist;
              fSelectIndex:integer;
              fSelectString:string;
              fSelectList:tstringlist;
              fbuttonpos:tbuttonposition;
              fmultisel,fsort,fshowtitle:boolean;
              fDialogPosition:TDialogPosition;
              fDblClick:boolean;
              fHeight: integer;
              fWidth: integer;
              fTopPosition: integer;
              fLeftPosition: integer;
              fCancelCaption:string;
              fOkCaption:string;
              fSelectData:tObject;
              fSizeable:boolean;
              fToolWindow:boolean;
              fSelectForm:tSelectForm;
              fCount:integer;
              fOnClickItem:TClickItemEvent;
              fOnDblClickItem:TDblClickItemEvent;
              procedure SetPickList(value: tstringlist);
              procedure SetHeight(value:integer);
              procedure SetWidth(value:integer);
              procedure CreateSelect;
             public
              constructor Create(aOwner:TComponent); override;
              destructor Destroy; override;
              function Execute:integer;
              procedure Show;
              procedure Hide;
              property SelectIndex:integer read fSelectIndex write fSelectIndex;
              property SelectString:string read fSelectString;
              property SelectData:tObject read FSelectData;
              property SelectList:tstringlist read fSelectList;
             published
              property PickItems:tStringlist read fPickList write SetPickList;
              property Caption:string read fCaption write fCaption;
              property Title:string read fTitle write fTitle;
              property MultiSel:boolean read fMultisel write fMultisel;
              property AcceptDblClick:boolean read fDblClick write fDblClick;
              property Sort:boolean read fSort write fSort;
              property ShowTitle:boolean read fShowTitle write fShowTitle;
              property ButtonPosition:tButtonPosition read fButtonpos write fButtonpos;
              property Width:integer read fWidth write SetWidth;
              property Height:integer read fHeight write SetHeight;
              property TopPosition:integer read fTopPosition write fTopPosition;
              property LeftPosition:integer read fLeftPosition write fLeftPosition;
              property DialogPosition:TDialogPosition read fDialogPosition write fDialogPosition;
              property CancelCaption:string read fCancelCaption write fCancelCaption;
              property OkCaption:string read fOkCaption write fOkCaption;
              property Sizeable:boolean read fSizeAble write fSizeAble;
              property ToolWindow:boolean read fToolWindow write fToolWindow;
              property OnClickItem:TClickItemEvent read FOnClickItem write FOnClickItem;
              property OnDblClickItem:TDblClickItemEvent read FOnDblClickItem write FOnDblClickItem;
             end;


implementation

{$R *.DFM}

{ TPickDialog }

constructor TPickDialog.Create(aOwner: tComponent);
begin
 inherited Create(aOwner);
 fPickList:=tStringlist.Create;
 fSelectList:=tStringlist.Create;
 fSelectIndex:=-1;
 fSelectString:='';
 fWidth:=280;
 fHeight:= 270;
 fCancelCaption:='Cancel';
 fOkCaption:='OK';
 fCount:=0;
end;

procedure TPickDialog.SetPickList(value: tstringlist);
begin
 if assigned(value) then
   fpicklist.assign(value);
end;

procedure TPickDialog.CreateSelect;
var
 r:trect;
 {
 i:integer;
 clientheight:integer;
 clientwidth:integer;
 }
begin
 if fcount>0 then exit;

 if csDesigning in ComponentState then
  fSelectForm:=tSelectForm.Create(Application)
 else
  fSelectForm:=tSelectForm.Create(self.owner);

 fSelectForm.Width:=fwidth;
 fSelectForm.Height:=fHeight;
 fSelectForm.CreSizeX:=fWidth;
 fSelectForm.CreSizeY:=fHeight;
 fSelectForm.acceptdblclick :=fDblClick;
 fSelectForm.fbuttonpos := fbuttonpos;
 fSelectForm.fParentControl:=self;

 case fDialogPosition of
 fposCenter:fSelectForm.Position:=poScreenCenter;
 fposDefault:fSelectForm.Position:=poDefaultPosOnly;
 fposAbsolute:
  begin
   fSelectForm.Top:=fTopPosition;
   fSelectForm.Left:=fLeftPosition;
   fSelectForm.Position:=poDesigned;
  end;
 end;

  if ftoolwindow then
  begin
   if fSizeable then fSelectForm.BorderStyle:=bsSizeToolWin
   else fSelectForm.BorderStyle:=bsToolWindow;
  end
 else
  begin
   if fSizeable then fSelectForm.BorderStyle:=bsSizeable
   else fSelectForm.BorderStyle:=bsSingle;
  end;

 r:=fSelectform.getclientrect;
 {
 clientheight:=r.bottom-r.top;
 clientwidth:=r.right-r.left;
 }
 with fSelectForm do
  begin
   SelectList.Items.AddStrings(fPickList);
   Caption:=fCaption;
   Okbtn.caption:=fOkCaption;
   Cancelbtn.caption:=fCancelCaption;
   Title.caption:=fTitle;
   SelectList.MultiSelect:=fmultisel;
   SelectList.Sorted:=fsort;
   SelectList.Itemindex:=1;

   if (SelectList.Items.Count>0) then
    begin
     if (fSelectIndex=-1) then
       SelectList.ItemIndex:=0
     else
       SelectList.ItemIndex:=fSelectIndex;
    end;

   if fShowTitle=false then
     begin
      title.visible:=false;
      SelectList.top:=SelectList.top-title.height-4;
      SelectList.Height:=SelectList.Height+title.height+4;
      SelectList.left:=8;
     end;

   case fbuttonpos of
    bpNone:begin
            SelectList.Width :=ClientWidth - 2*8;
            SelectList.Height:=Clientheight- SelectList.top-2*8;
            cancelbtn.visible:=false;
            okbtn.visible:=false;
           end;
    bpBottom:
       begin
         SelectList.Width :=ClientWidth - 2*8;
         SelectList.Height:=Clientheight- SelectList.top-2*8-cancelbtn.height;

         cancelbtn.top:=ClientHeight-cancelbtn.height-8;
         cancelbtn.left:=ClientWidth-cancelbtn.width-8;
         okbtn.top:=clientheight-8-okbtn.height;
         okbtn.left:=ClientWidth-2*cancelbtn.width-2*8;
       end;
    bpRight:
       begin
         SelectList.Width :=ClientWidth - cancelbtn.width- 3*8;
         SelectList.Height:=ClientHeight- SelectList.top-8;
         cancelbtn.top:=ClientHeight-2*cancelbtn.height-2*8;
         cancelbtn.left:=ClientWidth-cancelbtn.width-8;
         okbtn.top:=ClientHeight-8-okbtn.height;
         okbtn.left:=cancelbtn.left;
       end;
    end;
  end;
 inc(fcount);
end;

procedure TPickDialog.Show;
begin
 CreateSelect;
 fSelectForm.FormStyle:=fsStayontop;
 fSelectForm.Show;
end;

procedure TPickDialog.Hide;
begin
 if (fcount>0) then fSelectForm.Free;
 fcount:=0;
end;

function TPickDialog.Execute:integer;
var
 i:integer;
begin
 try
  CreateSelect;

  with fSelectForm do
  begin
  result:=ShowModal;
  fSelectIndex:=SelectList.ItemIndex;
   if fSelectIndex>=0 then
      begin
        fSelectString:=SelectList.Items[fSelectIndex];
        fSelectData:=tObject(sendmessage(selectlist.handle,lb_getitemdata,fSelectIndex,0));
      end;
    if fMultiSel and (SelectList.items.count>0) then
      begin
       fSelectList.Clear;
       for i:=0 to SelectList.Items.Count-1 do
        begin
         if SelectList.Selected[i] then fSelectList.Add(SelectList.Items[i]);
        end;
      end;
   end;
 finally
  fSelectForm.Free;
  fcount:=0;
 end;

end;

destructor TPickDialog.Destroy;
begin
 fSelectList.Free;
 fPickList.Free;
 inherited Destroy;
end;

procedure TSelectForm.okbtnClick(Sender: TObject);
begin
 modalresult:=mrOk;
end;

procedure TSelectForm.cancelbtnClick(Sender: TObject);
begin
 modalresult:=mrCancel;
end;

procedure TPickDialog.SetHeight(value: integer);
begin
 if value> 180 then fHeight:=value;
end;

procedure TPickDialog.SetWidth(value: integer);
begin
 if value>180 then fWidth:=value;
end;


procedure TSelectForm.SelectListDblClick(Sender: TObject);
begin
 if acceptdblclick then modalresult:=mrOk;

 with (fParentControl as TPickDialog) do
  if assigned(OnDblClickItem) then
   fOnDblClickItem(owner,self.selectlist.itemindex,
      self.selectlist.items[self.selectlist.itemindex]);

end;

procedure TSelectForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
var
 r:trect;
begin
 inherited;
 if (BorderStyle=bsSingle) then exit;
 r:=clientrect;
 r.left:=r.right-GetSystemMetrics(SM_CXVSCROLL);
 r.top:=r.bottom-GetSystemMetrics(SM_CXHSCROLL);
 DrawFrameControl(canvas.handle,r,DFC_SCROLL,DFCS_SCROLLSIZEGRIP);
end;

procedure TSelectForm.WMNCHitTest(var Message: TMessage);
var
 r:trect;
 p:tpoint;
begin
 if (BorderStyle=bsSingle) then
   inherited
 else
  begin
   r:=clientrect;
   r.left:=r.right-GetSystemMetrics(SM_CXVSCROLL);
   r.top:=r.bottom-GetSystemMetrics(SM_CXHSCROLL);

   p.x:=loword(message.lparam);
   p.y:=hiword(message.lparam);
   p:=screentoclient(p);

   if ptInRect(r,p) then
      message.result:=HTBOTTOMRIGHT
   else inherited;
  end;
end;

procedure TSelectForm.WMMinMaxInfo(var Message: TMessage);
begin
 with PMinMaxInfo(message.lParam)^ do
 begin
  ptMinTrackSize.X := CreSizeX;
  ptMinTrackSize.Y := CreSizeY;
 end;

end;

procedure TSelectForm.WMSize(var Message: TWMSize);
begin
 if (BorderStyle in [bsSizeable,bsSizeToolWin]) then
  invalidaterect(self.handle,nil,true);
 inherited;
 {resize the list here}
 if (BorderStyle in [bsSizeable,bsSizeToolWin]) then
  begin
    case fbuttonpos of
    bpNone:begin
            SelectList.Width :=ClientWidth - 2*8;
            SelectList.Height:=Clientheight- SelectList.top-2*8;
            cancelbtn.visible:=false;
            okbtn.visible:=false;
           end;
    bpBottom:
       begin
         SelectList.Width :=ClientWidth - 2*8;
         SelectList.Height:=Clientheight- SelectList.top-2*8-cancelbtn.height;
         cancelbtn.top:=ClientHeight-cancelbtn.height-8;
         cancelbtn.left:=ClientWidth-cancelbtn.width-8;
         okbtn.top:=clientheight-8-okbtn.height;
         okbtn.left:=ClientWidth-2*cancelbtn.width-2*8;
       end;
    bpRight:
       begin
         SelectList.Width :=ClientWidth - cancelbtn.width- 3*8;
         SelectList.Height:=ClientHeight- SelectList.top-8;
         cancelbtn.top:=ClientHeight-2*cancelbtn.height-2*8;
         cancelbtn.left:=ClientWidth-cancelbtn.width-8;
         okbtn.top:=ClientHeight-8-okbtn.height;
         okbtn.left:=cancelbtn.left;
       end;
    end;
  end;
end;

procedure TSelectForm.SelectListClick(Sender: TObject);
begin
 {do some code here too}
 with (fParentControl as TPickDialog) do
  if assigned(OnClickItem) then
   fOnClickItem(owner,self.selectlist.itemindex,
      self.selectlist.items[self.selectlist.itemindex]);
end;

end.
