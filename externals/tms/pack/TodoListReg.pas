{*************************************************************************}
{ TTodoList component                                                     }
{ for Delphi & C++Builder                                                 }
{ version 1.2 - rel. February 2003                                        }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright © 2001 - 2003                                       }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{*************************************************************************}

unit TodoListReg;

interface

uses
  Classes, TodoList;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Planner', [TTodoList]);
end;


end.
 