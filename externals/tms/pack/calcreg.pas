{********************************************************************}
{ TCALCOMP component                                                 }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0                }
{ version 2.1                                                        }
{                                                                    }
{ Written by TMS Software                                            }
{   Copyright © 1998-2001                                            }
{   Email : info@tmssoftware.com                                     }
{   Website : http://www.tmssoftware.com                             }
{********************************************************************}
unit calcreg;

interface
{$I TMSDEFS.INC}
uses
  Calcomp, Classes,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;

type

  TCalcompEditor = class(TComponentEditor)
  public
    function GetVerb(Index: Integer):string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS', [TCalComp]);
  RegisterComponentEditor(TCalcomp,TCalcompEditor);
end;

procedure TCalcompEditor.ExecuteVerb(Index: Integer);
begin
  (Component as TCalComp).Execute;
end;

function TCalcompEditor.GetVerb(Index: Integer): string;
begin
  Result := '&Test';
end;

function TCalcompEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

end.

