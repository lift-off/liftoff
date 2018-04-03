{********************************************************************
TRTFLabel component
for Delphi 2.0,3.0,4.0,5.0, C++Builder 1.0,3.0,4.0,5.0
version 1.2

written by
   TMS Software
   copyright © 1999-2000
   Email : info@tmssoftware.com
   Website : http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The complete
source code remains property of the author and may not be distributed,
published, given or sold in any form as such. No parts of the source
code can be included in any other component or application without
written authorization of the author.
********************************************************************}

unit rtflabel;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  StdCtrls, richedit, comctrls, forms;

type
  TRichText = string;

  TRTFLabel = class(TCustomLabel)
  private
    { Private declarations }
   frichedit:TRichEdit;
   frichtext:TRichText;
   fupdatecount:integer;
   procedure RTFPaint(canvas:tcanvas;arect:trect);
   function GetRichEdit:TRichEdit;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    property RTF:TRichEdit read GetRichEdit;
    procedure ShowRTF;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure CopyFromRichEdit(richedit:TRichEdit);
    procedure CopyToRichEdit(richedit:TRichEdit);
    procedure Print(caption:string);
  published
    { Published declarations }
    property RichText:TRichText read fRichText write fRichText;
    property Align;
    property Color;
    property Transparent;
    property Visible;
    property Hint;
    property ShowHint;
    property FocusControl;
    property ParentShowHint;
    property DragCursor;
    property DragMode;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property PopupMenu;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;



implementation

procedure TRTFLabel.BeginUpdate;
begin
 inc(fUpdateCount);
end;

procedure TRTFLabel.EndUpdate;
begin
 if fUpdateCount>0 then
   begin
    dec(fUpdateCount);
    if (fUpdateCount=0) then ShowRTF;
   end;
end;

function TRTFLabel.GetRichEdit:TRichEdit;
begin
 if assigned(self.Parent) and assigned(fRichEdit) then
  begin
   fRichEdit.parent:=self.Parent;
   if fRichEdit.parent.handleallocated then
     begin
      fRichEdit.Lines.Clear;
      fRichEdit.Selattributes:=fRichEdit.DefAttributes;
     end;
    result:=fRichEdit;
  end
 else
  result:=nil;
end;

procedure TRTFLabel.ShowRTF;
var
 ms:tmemorystream;
 s:string;
 ch:char;
 i:integer;
begin
 if not assigned(self.Parent) then exit;
 if not assigned(fRichEdit) then exit;
 if not self.parent.handleallocated then exit;

 fRichEdit.parent:=self.Parent;
 ms:=tmemorystream.create;
 fRichEdit.lines.savetostream(ms);
 ms.position:=0;
 s:='';
 if ms.size>0 then
   for i:=0 to ms.size-1 do
    begin
     ms.read(ch,1);
     s:=s+ch;
     end;
 ms.free;
 RichText:=s;
 self.Repaint;
 fRichEdit.parent:=nil;
end;

procedure TRTFLabel.RTFPaint(canvas:tcanvas;arect:trect);
const
 RTF_OFFSET :integer = 1;
type
  rFormatRange = record
    hdc: HDC;
    hdcTarget: HDC;
    rc: TRect;
    rcPage: TRect;
    chrg: TCharRange;
  end;
var
 ms:tmemorystream;
 i:integer;
 s:string;

var
 fr:rFORMATRANGE;
 nLogPixelsX,nLogPixelsY:integer;
begin
 s:=RichText;
 ms:=tmemorystream.create;
 for i:=1 to length(s) do ms.write(s[i],1);
 ms.position:=0;
 frichedit.lines.loadfromstream(ms);
 ms.free;

 FillChar(fr, SizeOf(TFormatRange), 0);

 nLogPixelsX := GetDeviceCaps(canvas.handle,LOGPIXELSX);
 nLogPixelsY := GetDeviceCaps(canvas.handle,LOGPIXELSY);

 if transparent then
  sendmessage(frichedit.handle,EM_SETBKGNDCOLOR,0,colortorgb(Parent.Brush.Color))
 else
 sendmessage(frichedit.handle,EM_SETBKGNDCOLOR,0,colortorgb(Color));


 with fr do
  begin
   fr.hdc:=canvas.handle;
   fr.hdctarget:=canvas.handle;
   fr.rcPage.left:=round(((arect.left+RTF_OFFSET)/nLogPixelsX)*1440);
   fr.rcPage.top:=round(((arect.top+RTF_OFFSET)/nLogPixelsY)*1440);
   fr.rcPage.right:=fr.rcPage.left+round(((arect.right-arect.left-RTF_OFFSET)/nLogPixelsX) * 1440);
   fr.rcPage.bottom:=(fr.rcPage.top+round(((arect.bottom-arect.top-RTF_OFFSET)/nLogPixelsY) * 1440));
   fr.rc.left:=fr.rcPage.left;  { 1440 TWIPS = 1 inch. }
   fr.rc.top:=fr.rcPage.top;
   fr.rc.right:=fr.rcPage.right;
   fr.rc.bottom:=fr.rcPage.bottom;
   fr.chrg.cpMin := 0;
   fr.chrg.cpMax := -1;
 end;
 sendmessage(frichedit.handle,EM_FORMATRANGE,1,longint(@fr));
 {clear the richtext cache}
 sendmessage(frichedit.handle,EM_FORMATRANGE,0,0);
end;


procedure TRTFLabel.Paint;
var
 r:trect;
begin
 Caption:='';
 inherited Paint;

 if fUpdateCount>0 then exit;
 if not assigned(fRichEdit) then exit;

 frichedit.parent:=self.parent;
 if not frichedit.parent.handleallocated then exit;
 frichedit.height:=0;
 r.left:=0;
 r.right:=r.left+self.width;
 r.top:=0;
 r.bottom:=r.top+self.Height;
 setbkmode(canvas.handle,1);
 RTFPaint(canvas,r);
 frichedit.parent:=nil;
end;

constructor TRTFLabel.Create(AOwner: TComponent);
begin
 inherited;
 fRichEdit:=TRichEdit.Create(self);
 AutoSize:=false;
 Caption:='';
 fUpdateCount:=0;
end;

destructor TRTFLabel.Destroy;
begin
 fRichEdit.Free;
 fRichEdit:=nil;
 inherited;
end;

procedure TRTFLabel.Loaded;
begin
 inherited;
 fRichEdit.left:=0;
 fRichEdit.top:=0;
 fRichEdit.width:=0;
 fRichEdit.height:=0;
 fRichEdit.visible:=false;
 fRichEdit.BorderStyle:=bsNone;
 Caption:='';
end;

procedure TRTFLabel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
 inherited MouseDown(Button,Shift,X,Y);
end;

procedure TRTFLabel.CopyFromRichEdit(richedit: TRichEdit);
var
 ms:tmemorystream;
 s:string;
 i:integer;
 ch:char;
begin
 ms:=tmemorystream.create;
 RichEdit.lines.savetostream(ms);
 ms.position:=0;
 s:='';
 if ms.size>0 then
   for i:=0 to ms.size-1 do
    begin
     ms.read(ch,1);
     s:=s+ch;
     end;
 ms.free;
 RichText:=s;
 self.Repaint;
end;

procedure TRTFLabel.CopyToRichEdit(richedit: TRichEdit);
var
 ms:tmemorystream;
 i:integer;
 ch:char;
begin
 ms:=tmemorystream.create;
 for i:=1 to length(RichText) do
  begin
   ch:=richtext[i];
   ms.write(ch,1);
  end;
 ms.position:=0;
 RichEdit.plaintext:=false;
 RichEdit.Lines.LoadFromStream(ms);
 ms.Free;
end;

procedure TRTFLabel.Print(caption:string);
begin
 if assigned(self.Parent) and assigned(fRichEdit) then
  begin
   fRichEdit.parent:=self.Parent;
   if fRichEdit.parent.handleallocated then
    begin
      copytorichedit(fRichEdit);
      fRichEdit.print(caption);
    end;
   frichedit.parent:=nil;
  end;
end;


end.
