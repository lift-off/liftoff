{********************************************************************}
{ TPARAMETERLISTBOX component                                        }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3,4,5                      }
{ version 1.9                                                        }
{                                                                    }
{ Written by                                                         }
{   TMS Software                                                     }
{   Copyright © 1998-2001                                            }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{********************************************************************}

unit parlreg;

interface
{$I TMSDEFS.INC}
uses
  ParamLst, ParamDE, Classes,
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
  RegisterComponents('TMS', [TParameterListBox]);
  RegisterPropertyEditor(TypeInfo(string),TParameterListBox,'Delimiter',TParamDelimiterProperty);
end;


end.
