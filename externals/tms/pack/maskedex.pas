{********************************************************************
TMASKEDEX component
for Delphi 2.0,3.0,4.0,5.0 & C++Builder 1,3,4
version 1.1

Copyright � 1998-1999
  TMS Software
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
unit MaskEdEx;

{$I TMSDEFS.INC}

interface

uses
  {$IFDEF WIN32} Windows, {$ELSE} Winprocs, Wintypes, {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask;

type
  TMaskEditEx = class(TMaskEdit)
  private
   FAutoTab:boolean;
   FEnterTab:boolean;
   FAlignment:TAlignment;
    { Private declarations }
   procedure SetAlignment(value:TAlignment);
  protected
   procedure KeyUp(var Key: Word; Shift: TShiftState); override;
   procedure DoEnter; override;
   procedure CreateParams(var Params:TCreateParams); override;
   procedure KeyPress(var Key: Char); override;
    { Protected declarations }
  public
   constructor Create(AOwner: TComponent); override;
    { Public declarations }
  published
   property AutoTab:boolean read FAutoTab write FAutoTab default true;
   property EnterTab:boolean read FEnterTab write FEnterTab default true;
   property Alignement:TAlignment read FAlignment write SetAlignment default taLeftJustify;
    { Published declarations }
  end;

implementation

constructor TMaskEditEx.Create(AOwner: TComponent);
begin
 inherited Create(aOwner);
 FAutoTab:=true;
 FEnterTab:=true;
end;

procedure TMaskEditEx.SetAlignment(value:tAlignment);
begin
 if FAlignment <> Value then
  begin
   FAlignment := Value;
   RecreateWnd;
  end;
end;

procedure TMaskEditEx.CreateParams(var Params:TCreateParams);
begin
 inherited CreateParams(params);

 if (FAlignment = taRightJustify) then
  begin
   params.style:=params.style AND NOT (ES_LEFT);
   params.style:=params.style or (ES_RIGHT);
   params.style:=params.style or (ES_MULTILINE);
  end;
end;



procedure TMaskEditEx.KeyUp(var Key: Word; Shift: TShiftState);
begin
 inherited keyUp(key,shift);
 if (pos(' ',self.text)=0) and (self.selstart=length(self.text)) and (self.editmask<>'') then
  begin
   if AutoTab then postmessage(self.handle,wm_keydown,VK_TAB,0);
  end;
end;

procedure TMaskEditEx.DoEnter;
begin
  inherited DoEnter;
  self.selstart:=0;
  self.sellength:=1;
end;


procedure TMaskEditEx.KeyPress(var Key: Char);
begin
 if EnterTab and (key=#13) then postmessage(self.handle,wm_keydown,VK_TAB,0);
 inherited Keypress(key);
end;




end.


