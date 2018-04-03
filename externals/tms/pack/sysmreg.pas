{********************************************************************
TSYSMON component
for Delphi 3.0, 4.0, 5.0 & C++Builder 3.0, 4.0
version 1.1

written by TMS Software
           copyright © 1998-1999
           Email : info@tmssoftware.com
           Web : http://www.tmssoftware.com
{********************************************************************}

unit sysmreg;

interface
{$I TMSDEFS.INC}
uses
  SysMon, SysmDE, Classes,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


procedure Register;

implementation

procedure Register;
begin
 RegisterComponents('TMS', [TSysMon]);
 RegisterPropertyEditor(TypeInfo(string),TMonObject,'SysObject',TMonObjectProperty);
 RegisterPropertyEditor(TypeInfo(string),TMonObject,'Counter',TMonCounterProperty);
end;



end.
