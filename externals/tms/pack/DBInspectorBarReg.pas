{***************************************************************************}
{ TDBInspectorBar component                                                 }
{ for Delphi & C++Builder                                                   }
{ version 1.2                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2001 - 2003                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{***************************************************************************}

unit DBInspectorBarReg;

interface
{$I TMSDEFS.INC}
uses
  DBInspectorBar, Classes, DBInspDE,
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
  RegisterComponents('TMS Bars',[TDBInspectorBar]);
  RegisterPropertyEditor(TypeInfo(string),TDBInspectorItem,'DataField',TInspectorItemFieldNameProperty);
end;

end.
 