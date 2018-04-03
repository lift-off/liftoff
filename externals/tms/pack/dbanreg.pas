{*************************************************************************}
{ TDBADVNAVIGATOR component                                               }
{ for Delphi & C++Builder                                                 }
{ version 1.1                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright © 2002 - 2003                                       }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{*************************************************************************}

unit dbanreg;

interface

uses
  Classes, DBAdvNavigator;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS',[TDBAdvNavigator]);
end;

end.
 