{***********************************************************************}
{ TADVSPINEDIT component                                                }
{ for Delphi & C++Builder                                               }
{ version 1.3                                                           }
{                                                                       }
{ written by                                                            }
{   TMS Software                                                        }
{   Copyright © 1998-2002                                               }
{   Email : info@tmssoftware.com                                        }
{   Web : http://www.tmssoftware.com                                    }
{***********************************************************************}
unit asreg;

interface

uses
  AdvSpin, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TAdvSpinEdit]);
end;

end.

