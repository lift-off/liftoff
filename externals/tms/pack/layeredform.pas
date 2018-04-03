{********************************************************************
TLAYEREDFORM component
for Delphi 3.0,4.0,5.0 & C++Builder 3.0,4.0,5.0
version 1.0 - rel. June 2000

written by TMS Software
           copyright © 1996-2000
           Email : info@tmssoftware.com
           Web : http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The complete
source code remains property of the author and may not be distributed,
published, given or sold in any form as such. No parts of the source
code can be included in any other component or application without
written authorization of the author.
********************************************************************}

unit LayeredForm;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TLayerType = (ltNone,ltAlphaBlend, ltColorKey);

  ELayeredFormError = class(Exception);

  TFadeThreadDone = procedure(Sender:TObject) of object;

  TLayeredForm  = class;

  TFadeThread = class(TThread)
  private
   fLayeredForm:TLayeredForm;
  protected
    procedure Execute; override;
  public
    constructor Create(aLayeredForm:TLayeredForm);
  end;

  TLayeredForm = class(TComponent)
  private
    fAlpha: byte;
    fLayerType: TLayerType;
    fColorKey: TColor;
    fOwner:TForm;
    r:trect;
    fOnFadeInDone:TFadeThreadDone;
    fOnFadeOutDone:TFadeThreadDone;
    fFadeStep:byte;
    fFadeTime:dword;
    fFadeIn:boolean;
    procedure SetAlpha(const Value: byte);
    procedure SetColorKey(const Value: TColor);
    procedure SetLayerType(const Value: TLayerType);
    { Private declarations }
    procedure Update;
    procedure ThreadDone(Sender:TObject);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    procedure FadeIn(time:integer;step:byte);
    procedure FadeOut(time:integer;step:byte);
  published
    { Published declarations }
    property Alpha:byte read fAlpha write SetAlpha;
    property ColorKey:TColor read fColorKey write SetColorKey;
    property LayerType:TLayerType read fLayerType write SetLayerType;
    property OnFadeInDone:TFadeThreadDone read fOnFadeInDone write fOnFadeInDone;
    property OnFadeOutDone:TFadeThreadDone read fOnFadeOutDone write fOnFadeOutDone;
  end;


implementation

const
  WS_EX_LAYERED  = $00080000;
  ULW_ALPHA      = $00000002;

{$IFNDEF DELPHI4_LVL}
  AC_SRC_OVER = $00;

type

 _BLENDFUNCTION = packed record
    BlendOp: BYTE;
    BlendFlags: BYTE;
    SourceConstantAlpha: BYTE;
    AlphaFormat: BYTE;
 end;
 TBlendFunction = _BLENDFUNCTION;

{$ENDIF}



function DynaLink_UpdateLayeredWindow(hwnd,hdcDst:thandle;
                                   pptDst,size:ppoint;hdcSrc:thandle;
                                   pptSrc:ppoint;
                                   crKey:dword;
                                   var pblend:_BLENDFUNCTION;
                                   dwFlags:DWORD):boolean;

var
 UserDLL: THandle;
 user_UpdateLayeredWindow:function(hwnd,hdcDst:thandle;
                                   pptDst,size:ppoint;hdcSrc:thandle;
                                   pptSrc:ppoint;
                                   crKey:dword;
                                   var pblend:_BLENDFUNCTION;
                                   dwFlags:DWORD):DWORD; stdcall;

begin
 result:=TRUE;
 UserDLL:=GetModuleHandle('USER32.DLL');
 if (UserDLL>0) then
  begin
   @user_UpdateLayeredWindow:=GetProcAddress(UserDLL,'UpdateLayeredWindow');
   if assigned(user_UpdateLayeredWindow) then
    begin
     result:=user_UpdateLayeredWindow(hwnd,hdcDst,pptDst,size,hdcSrc,pptSrc,crKey,pblend,dwFlags)<>0;
    end;
  end;
end;


function DynaLink_SetLayeredWindowAttributes(HWND:thandle;crKey:DWORD;bAlpha:byte;dwFlags:DWORD):boolean;
var
 UserDLL: THandle;
 user_SetLayeredWindowAttributes:function(HWND:thandle;crKey:DWORD;bAlpha:byte;dwFlags:DWORD):DWORD; stdcall;

begin
 result:=TRUE;
 UserDLL:=GetModuleHandle('USER32.DLL');
 if (UserDLL>0) then
  begin
   @user_SetLayeredWindowAttributes:=GetProcAddress(UserDLL,'SetLayeredWindowAttributes');
   if assigned(user_SetLayeredWindowAttributes) then
    begin
     result:=user_SetLayeredWindowAttributes(hwnd,crKey,bAlpha,dwFlags)<>0;
    end;
  end;
end;

{
procedure WindowBlendUpdate(hwnd:thandle;alpha:byte);
begin
 DynaLink_SetLayeredWindowAttributes(hwnd,0,alpha,2);
end;
}

procedure WindowBlend(hwnd,hdc:thandle;colorkey:tcolor;alpha:byte;r:trect);
var
 dw:dword;
 blnd:_BLENDFUNCTION;
 dskdc:thandle;
 size,src:tpoint;
begin
 dw:=getwindowlong(hwnd, GWL_EXSTYLE);
 setwindowlong(hwnd, GWL_EXSTYLE,dw or WS_EX_LAYERED);
 DynaLink_SetLayeredWindowAttributes(hwnd,DWORD(colorkey),alpha,2);
 blnd.BlendOp :=   AC_SRC_OVER;
 blnd.BlendFlags := 0;
 blnd.SourceConstantAlpha := 0;
 blnd.AlphaFormat := 0;
 dskdc:=getdc(0);
 size:=point(r.right-r.left,r.bottom-r.top);
 src:=point(r.left,r.top);
 DynaLink_UpdateLayeredWindow(hwnd,dskdc,nil,@size,hdc,@src,dword(colorkey), blnd,ULW_ALPHA);
end;

procedure WindowColorKey(hwnd,hdc:thandle;colorkey:tcolor;alpha:byte;r:trect);
var
 dw:dword;
 blnd:_BLENDFUNCTION;
 dskdc:thandle;
 size,src:tpoint;
begin
 dw:=getwindowlong(hwnd, GWL_EXSTYLE);
 setwindowlong(hwnd, GWL_EXSTYLE,dw or WS_EX_LAYERED);
 DynaLink_SetLayeredWindowAttributes(hwnd,DWORD(colorkey),alpha,1);
 blnd.BlendOp :=   AC_SRC_OVER;
 blnd.BlendFlags := 0;
 blnd.SourceConstantAlpha := 0;
 blnd.AlphaFormat := 0;
 dskdc:=getdc(0);
 size:=point(r.right-r.left,r.bottom-r.top);
 src:=point(r.left,r.top);
 DynaLink_UpdateLayeredWindow(hwnd,dskdc,nil,@size,hdc,@src,dword(colorkey), blnd,ULW_ALPHA);
end;


{ TLayeredForm }

constructor TLayeredForm.Create(AOwner: TComponent);
var
 I,Instances:Integer;

begin
 inherited Create(AOwner);
 if not (Owner is TForm) then
  raise ELayeredFormError.Create('Control parent must be a form!');

 Instances := 0;
 for I := 0 to Owner.ComponentCount - 1 do
  if (Owner.Components[I] is TLayeredForm) then Inc(Instances);
 if (Instances > 1) then
  raise ELayeredFormError.Create('Only one instance of TLayeredForm allowed on form');

 fOwner:=TForm(Owner);
 fAlpha:=255;
end;

procedure TLayeredForm.Loaded;
begin
 inherited;

 with (Owner as TForm) do
  begin
   r:=ClientRect;
   Update;
  end;
end;

procedure TLayeredForm.Update;
var
 dw:DWORD;
begin
 if csDesigning in ComponentState then exit;
 with (Owner as TForm) do
 case fLayerType of
 ltColorKey:WindowColorKey(Handle,Canvas.Handle,colortoRGB(fColorKey),fAlpha,r);
 ltAlphaBlend:WindowBlend(Handle,Canvas.Handle,colortoRGB(fColorKey),fAlpha,r);
 ltNone:begin
         dw:=GetWindowLong(Handle,GWL_EXSTYLE);
         dw:=dw AND not (WS_EX_LAYERED);
         SetWindowLong(Handle,GWL_EXSTYLE,dw);
        end;
 end;
end;

procedure TLayeredForm.SetAlpha(const Value: byte);
begin
  fAlpha := Value;
  if (fLayerType=ltAlphaBlend) then Update;
end;

procedure TLayeredForm.SetColorKey(const Value: TColor);
begin
  fColorKey := Value;
  if (fLayerType=ltColorKey) then Update;
end;

procedure TLayeredForm.SetLayerType(const Value: TLayerType);
begin
  if (fLayerType<>value) then
   begin
    fLayerType := Value;
    Update;
   end;
end;

procedure TLayeredForm.FadeIn(time: integer; step:byte);
begin
 fFadeIn:=true;
 fFadeTime:=time;
 fFadeStep:=step;
 with TFadeThread.Create(self) do  OnTerminate := ThreadDone;
end;

procedure TLayeredForm.FadeOut(time: integer; step:byte);
begin
 fFadeIn:=false;
 fFadeTime:=time;
 fFadeStep:=step;
 with TFadeThread.Create(self) do  OnTerminate := ThreadDone;
end;

procedure TLayeredForm.ThreadDone(Sender: TObject);
begin
 if fFadeIn then
  begin
   if assigned(fOnFadeInDone) then fOnFadeInDone(self);
  end
 else
  begin
   if assigned(fOnFadeOutDone) then fOnFadeOutDone(self);
  end;
end;

{ TFadeThread }

constructor TFadeThread.Create(aLayeredForm: TLayeredForm);
begin
 fLayeredForm:=aLayeredForm;
 FreeOnTerminate := True;
 inherited Create(False);
end;

procedure TFadeThread.Execute;
var
 t:integer;
 ti:DWORD;
begin
  if fLayeredForm.fFadeIn then
   begin
    fLayeredForm.Alpha:=0;
    fLayeredForm.LayerType := ltAlphaBlend;
    t:=0;
    while (t<255) do
     begin
      fLayeredForm.Alpha:=t;
      t:=t+fLayeredForm.fFadeStep;

      ti:=GetTickCount;
      while (GetTickCount-ti<fLayeredForm.fFadeTime) do
        begin

        end;
     end;

    fLayeredForm.Alpha:=255;
   end;

  if not fLayeredForm.fFadeIn then
   begin
    fLayeredForm.Alpha:=0;
    fLayeredForm.LayerType := ltAlphaBlend;
    t:=255;
    while (t>0) do
     begin
      fLayeredForm.Alpha:=t;
      t:=t-fLayeredForm.fFadeStep;

      ti:=GetTickCount;

      while (GetTickCount-ti<fLayeredForm.fFadeTime) do begin end;
     end;

    fLayeredForm.Alpha:=0;
   end;

end;

end.
