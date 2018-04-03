{********************************************************************}
{ TPARAMLABEL component                                              }
{ for Delphi & C++Builder                                            }
{ version 1.1                                                        }
{                                                                    }
{ written by TMS Software                                            }
{           copyright © 2000 - 2003                                  }
{           Email : info@tmssoftware.com                             }
{           Web : http://www.tmssoftware.com                         }
{********************************************************************}

unit paramlabreg;

interface

{$I TMSDEFS.INC}

uses
  ParamLabel, Classes,
{$IFNDEF NOEDITOR}
  paramsde,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
{$ENDIF}
  ;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Param', [TParamLabel]);
  RegisterPropertyEditor(TypeInfo(TStringList), TParamLabel, 'HTMLText', TParamStringProperty);
  RegisterComponentEditor(TParamLabel, TParamDefaultEditor); 
end;



end.

