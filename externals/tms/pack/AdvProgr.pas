{********************************************************************
TADVPROGRESS component
for Delphi 2.0,3.0,4.0,5.0 C++Builder 1,3,4
version 1.2

written by
  TMS Software
  copyright � 1998-2000
  Email : info@tmssoftware.com
  Website : http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The source
code remains property of the author and may not be distributed
freely as such.
********************************************************************}

unit AdvProgr;

{$I TMSDEFS.INC}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ComCtrls, commctrl;


type
 {$IFNDEF DELPHI5_LVL}
  TProgressStyle = (psHorizontal,psVertical);
 {$ENDIF}

  TAdvProgress = class(TProgressBar)
  private
    {$IFNDEF DELPHI5_LVL}
    FProgressStyle:tProgressStyle;
    FSmooth:boolean;
    {$ENDIF}
    FBarColor:tColor;
    FBkColor:tColor;
    { Private declarations }
    procedure SetProBarColor(avalue:tcolor);
    procedure SetProBkColor(avalue:tcolor);
    {$IFNDEF DELPHI5_LVL}
    procedure SetSmooth(avalue:boolean);
    procedure SetProgressStyle(avalue:tprogressStyle);
    {$ENDIF}
  protected
    { Protected declarations }
    procedure CreateParams(var Params:TCreateParams); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(aOwner:TComponent); override;
  published
    property BarColor:tColor read FBarColor write SetProBarColor;
    property BkColor:tColor read FBkColor write SetProBkColor;
    {$IFNDEF DELPHI5_LVL}
    property Smooth:boolean read FSmooth write SetSmooth;
    property ProgressStyle:TProgressStyle read FProgressStyle write SetProgressStyle;
    {$ENDIF}
    { Published declarations }
  end;

implementation

{$IFNDEF DELPHI4_LVL}
const
  PBM_SETBARCOLOR = (WM_USER+9);
  CCM_FIRST = $2000;
  PBM_SETBKCOLOR = CCM_FIRST+1;
  PBS_SMOOTH = $01;
  PBS_VERTICAL = $04;
{$ENDIF}

procedure TAdvProgress.CreateParams(var Params:TCreateParams);
begin
 inherited CreateParams(params);
 {$IFNDEF DELPHI5_LVL}
 if FSmooth then
  params.style:=params.style OR PBS_SMOOTH;
 if FProgressStyle=psVertical then
  params.style:=params.style OR PBS_VERTICAL
 else 
  params.style:=params.style AND NOT PBS_VERTICAL;
 {$ENDIF}
end;

procedure TAdvProgress.Loaded;
begin
 inherited;
end;

{$IFNDEF DELPHI5_LVL}
procedure TAdvProgress.SetProgressStyle(avalue:tprogressStyle);
var
 ih,iw:integer;
begin
 if (FProgressStyle<>avalue) then
  begin

   iw:=self.width;
   ih:=self.height;
   FProgressStyle:=avalue;
   recreatewnd;
   BkColor:=FBkColor;
   BarColor:=FBarColor;
   if not (csLoading in ComponentState) then
    begin
     Width:=ih;
     Height:=iw;
    end; 
  end;
end;

procedure TAdvProgress.SetSmooth(avalue:boolean);
var
 po,mi,ma:integer;
begin
 FSmooth:=avalue;
 po:=Position;
 mi:=Min;
 ma:=Max;
 recreatewnd;
 BkColor:=FBkColor;
 BarColor:=FBarColor;
 Position:=po;
 Min:=mi;
 Max:=ma;
end;
{$ENDIF}

procedure TAdvProgress.SetProBarColor(avalue:tcolor);
begin
  FBarColor:=avalue;
  sendmessage(self.handle,PBM_SETBARCOLOR,0,longint(colortorgb(avalue)));
end;

procedure TAdvProgress.SetProBkColor(avalue:tcolor);
begin
  FBkColor:=avalue;
  sendmessage(self.handle,PBM_SETBKCOLOR,0,longint(colortorgb(avalue)));
end;


constructor TAdvProgress.Create(aOwner: TComponent);
begin
  inherited;
  fBarColor:=clHighLight;
  fBkColor:=clWindow;
end;

end.
