{********************************************************************}
{ THTMLTREEVIEW component                                            }
{ for Delphi & C++Builder                                            }
{ version 1.0                                                        }
{                                                                    }
{ Written by                                                         }
{   TMS Software                                                     }
{   Copyright © 2000-2003                                            }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{********************************************************************}

unit paramtreeviewreg;

{$I TMSDEFS.INC}

interface

uses
  ParamTreeview, Classes, paramsde, ComCtrls,
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
  RegisterComponents('TMS Param', [TParamTreeview]);
  RegisterPropertyEditor(TypeInfo(TTreeNodes), TParamTreeView, 'Items', TParamNodesProperty);
  RegisterComponentEditor(TParamTreeView, TParamListDefaultEditor);
end;



end.

