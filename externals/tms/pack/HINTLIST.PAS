{********************************************************************
THINTLISTBOX component
for Delphi 2.0, 3.0, 4.0, 5.0 & C++Builder 1.0,3.0,4.0
version 1.4

written by
    TMS Software
    copyright © 1998-1999
    Email : info@tmssoftware.com
    Web : http://www.tmssoftware.com
********************************************************************}

{$IFDEF VER80}
 {$DEFINE DELPHI1}
 {$DEFINE ISDELPHI}
{$ENDIF}

{$IFDEF VER90}
 {$DEFINE DELPHI2}
 {$DEFINE DELPHI2_LVL}
 {$DEFINE ISDELPHI}
{$ENDIF}

{$IFDEF VER93}
 {$DEFINE BCB1}
 {$DEFINE DELPHI2_LVL}
 {$DEFINE ISBCB}
{$ENDIF}

{$IFDEF VER100}
 {$DEFINE DELPHI3}
 {$DEFINE DELPHI3_LVL}
 {$DEFINE DELPHI3_4_ONLY}
 {$DEFINE ISDELPHI}
{$ENDIF}

{$IFDEF VER110}
 {$DEFINE BCB3}
 {$DEFINE DELPHI3_LVL}
 {$DEFINE ISBCB}
{$ENDIF}

{$IFDEF VER120}
 {$DEFINE DELPHI4}
 {$DEFINE DELPHI3_LVL}
 {$DEFINE DELPHI4_LVL}
 {$DEFINE DELPHI3_4_ONLY}
 {$DEFINE ISDELPHI}
{$ENDIF}

{$IFDEF VER125}
 {$DEFINE DELPHI4}
 {$DEFINE DELPHI3_LVL}
 {$DEFINE DELPHI4_LVL}
{$ENDIF}

{$IFDEF VER130}
 {$DEFINE DELPHI5}
 {$DEFINE DELPHI3_LVL}
 {$DEFINE DELPHI4_LVL}
 {$DEFINE DELPHI3_4_ONLY}
 {$DEFINE ISDELPHI}
{$ENDIF}

{$IFDEF VER110}
 {$ObjExportAll On}
{$ENDIF}

{$IFDEF VER125}
 {$ObjExportAll On}
{$ENDIF}

unit hintlist;

interface

uses
  stdctrls,graphics,wintypes,winprocs,messages,classes,forms,controls;

type
 THintList = class(TListbox)
  private
   FHintColor:tcolor;
   FLastHintPos:tpoint;
   procedure CMHintShow(Var Msg: TMessage); Message CM_HINTSHOW;
   procedure ShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
  protected
   procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(aOwner:tComponent); override;
    destructor Destroy; override;
  published
   property HintColor: tColor read fHintColor write fHintColor;
 end;

implementation

procedure THintList.CMHintShow(var Msg: TMessage);
{$IFDEF DELPHI2_LVL}
type
 PHintInfo = ^THintInfo;
{$ENDIF}
var
 CanShow: Boolean;
 hi: PHintInfo;
{$IFDEF DELPHI2_LVL}
 s:string;
{$ENDIF}

Begin
 CanShow := True;
 hi := PHintInfo(Msg.LParam);
 {$IFDEF DELPHI2_LVL}
 s:=self.hint;
 ShowHintProc(s, CanShow, hi^);
 {$ELSE}
 ShowHint(hi.HintStr, CanShow, hi^);
 {$ENDIF}
 Msg.Result := Ord(Not CanShow);
end;

constructor THintList.Create(aOwner:tComponent);
{$IFNDEF WIN32}
var
 tmp:tshowhintevent;
{$ENDIF}

begin
 inherited Create(aOwner);
 fhintcolor:=clwhite;
 FLastHintPos:=point(-1,-1);
end;

destructor THintList.Destroy;
begin
 inherited Destroy;
end;

procedure THintList.MouseMove(Shift: TShiftState; X, Y: Integer);
var
 idx:integer;
begin
 if (FLastHintPos.y>=0) then
  begin
   idx:=y div itemheight;
   if (idx<>FLastHintPos.y) then
    begin
       Application.CancelHint;
       FLastHintPos:=Point(-1,-1);
     end;
  end;
 inherited MouseMove(Shift, X, Y);
end;

procedure THintList.ShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var
 hintpos:tpoint;
 idx:integer;

begin
 if (Hintinfo.Hintcontrol=self) then
   begin
    Hintinfo.Hintcolor:=FHintColor;

    {search over which thing mouse is}
    with (hintinfo.HintControl as tlistbox) do
     begin
       idx:=hintinfo.cursorpos.y div itemheight;
       if (idx+topindex<items.count) then
        hintstr:=items[topindex+idx]
       else
        hintstr:='';

       hintpos.x:=0;
       hintpos.y:=idx*itemheight-2;

       flasthintpos.y:=idx;
       flasthintpos.x:=0;
     end;
    hintinfo.hintpos:=self.clienttoscreen(hintpos);
   end;
end;

end.
