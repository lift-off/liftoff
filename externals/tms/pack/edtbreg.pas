{********************************************************************}
{ TEDITBUTTON component                                              }
{ for Delphi 3.0,4.0,5.0,6.0 & C++ Builder 3.0,4.0,5.0               }
{ version 1.5                                                        }
{                                                                    }
{ written by                                                         }
{   TMS Software                                                     }
{   copyright © 1998-2001                                            }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{********************************************************************}
unit edtbreg;

interface

uses
  EditBtn, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TEditBtn,TUnitEditBtn]);
end;


end.
 
