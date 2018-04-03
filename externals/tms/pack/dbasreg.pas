{********************************************************************}
{ TDBADVSPINEDIT component                                           }
{ for Delphi  & C++Builder                                           }
{ version 1.3                                                        }
{                                                                    }
{ Written by                                                         }
{   TMS Software                                                     }
{   Copyright © 2000-2003                                            }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{********************************************************************}

unit dbasreg;

interface

uses
  DBAdvSp, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TDBAdvSpinEdit]);
end;



end.

