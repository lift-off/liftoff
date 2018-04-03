{********************************************************************}
{ TCOLUMNLISTBOX component                                           }
{ for Delphi  3.0, 4.0, 5.0, 6.0 & C++Builder 3.0, 4.0, 5.0          }
{ version 1.2                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2000-2001                                   }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{********************************************************************}

unit collireg;

interface

uses
 collistb,classes;

procedure Register;

implementation

procedure Register;
begin
 RegisterComponents('TMS', [TColumnListBox]);
end;



end.

