{*************************************************************************}
{ TDBADVEDITBTN component                                                 }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0                     }
{ version 1.0 - rel. August, 2001                                         }
{                                                                         }
{ written by                                                              }
{   TMS Software                                                          }
{   Copyright © 1996-2001                                                 }
{   Email : info@tmssoftware.com                                          }
{   Web : http://www.tmssoftware.com                                      }
{*************************************************************************}

unit DBAdvEdBtnReg;

interface

uses
  DBAdvEdBtn, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TDBAdvEditBtn]);
end;



end.

