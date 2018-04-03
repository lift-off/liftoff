{*************************************************************************}
{ TADVTOOLBUTON component                                                 }
{ for Delphi 4.0,5.0,6.0 & C++Builder 4.0,5.0                             }
{ version 1.0 - rel. January, 2002                                        }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright © 2002                                              }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{*************************************************************************}

unit atbreg;

interface

uses
  Classes, AdvToolBtn;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS',[TAdvToolButton]);
end;

end.
