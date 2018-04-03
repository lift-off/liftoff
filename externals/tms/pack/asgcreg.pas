{**********************************************************************}
{ TADVCOLUMNGRID component                                             }
{ for Delphi & C++Builder                                              }
{ version 2.5.x.x                                                      }
{                                                                      }
{ written by TMS Software                                              }
{            copyright © 1996-2003                                     }
{            Email : info@tmssoftware.com                              }
{            Web : http://www.tmssoftware.com                          }
{**********************************************************************}

unit asgcreg;

interface

{$I TMSDEFS.INC}

uses
  AdvGrid, AdvCGrid, Classes, ACGDE,
{$IFDEF DELPHI6_LVL}
  DesignIntf
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Grids', [TAdvColumnGrid]);
  RegisterComponentEditor(TAdvColumnGrid,TAdvColumnGridEditor);
end;

end.

