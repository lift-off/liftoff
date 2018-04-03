{********************************************************************}
{ TADVLUEDIT component                                               }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0,6.0            }
{ version 1.4                                                        }
{                                                                    }
{ written by                                                         }
{   TMS Software                                                     }
{   Copyright © 2000 - 2002                                          }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{********************************************************************}

unit advluedr;

interface

uses
  AdvLuEd, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TAdvLUEdit]);
end;


end.
 