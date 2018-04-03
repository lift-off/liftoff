{********************************************************************}
{ TPARAMCHECKLIST component                                          }
{ for Delphi & C++Builder                                            }
{ version 1.2                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2000 - 2003                                 }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{********************************************************************}

unit paramchklreg;

{$I TMSDEFS.INC}

interface

uses
  paramchklist,classes,paramsde,
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
  RegisterComponents('TMS Param', [TParamCheckList]);
  RegisterPropertyEditor(TypeInfo(TStrings), TParamCheckList, 'Items', TParamStringListProperty);
  RegisterComponentEditor(TParamCheckList, TParamListDefaultEditor);
end;



end.

