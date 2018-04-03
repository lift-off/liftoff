{***********************************************************************}
{ TADVCOMBO component                                                   }
{ for Delphi & C++Builder                                               }
{ version 1.1                                                           }
{                                                                       }
{ written by                                                            }
{   TMS Software                                                        }
{   Copyright © 1998-2002                                               }
{   Email : info@tmssoftware.com                                        }
{   Web : http://www.tmssoftware.com                                    }
{***********************************************************************}
unit acreg;

interface

uses
  AdvCombo, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TAdvComboBox]);
end;



end.

