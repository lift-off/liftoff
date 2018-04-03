{********************************************************************}
{ TADVEDITBTN and TUnitAdvEditBtn component                          }
{ for Delphi & C++Builder                                            }
{ version 1.3                                                        }
{                                                                    }
{ written by                                                         }
{   TMS Software                                                     }
{   Copyright © 2000 - 2002                                          }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{********************************************************************}

unit advedbr;

interface

uses
  AdvEdBtn,Classes, AdvFileNameEdit, AdvDirectoryEdit;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TAdvEditBtn,TUnitAdvEditBtn]);
  RegisterComponents('TMS Edits', [TAdvFileNameEdit]);
  RegisterComponents('TMS Edits', [TAdvDirectoryEdit]);    
end;



end.

