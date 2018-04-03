{********************************************************************}
{ TPARAMLISTBOX component                                            }
{ for Delphi & C++Builder                                            }
{ version 1.2                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2000 - 2003                                 }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{********************************************************************}

{$I TMSDEFS.INC}

unit paramlstreg;

interface

uses
  Paramlistbox,Classes, paramsde,
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
  RegisterComponents('TMS Param', [TParamListBox]);
  RegisterPropertyEditor(TypeInfo(TStrings), TParamListBox, 'Items', TParamStringListProperty);
  RegisterComponentEditor(TParamListBox, TParamListDefaultEditor);
end;



end.

