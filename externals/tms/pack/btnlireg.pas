{********************************************************************}
{ TBUTTONLISTBOX component                                           }
{ for Delphi  3.0, 4.0, 5.0 & C++Builder 3.0, 4.0, 5.0               }
{ version 1.1                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2001                                        }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{********************************************************************}

unit btnlireg;

interface

uses
  BtnListb, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS', [TButtonListBox]);
end;



end.

