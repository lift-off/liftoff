{****************************************************************}
{ TWEBCOPY component                                             }
{ for Delphi 4.0,5.0,6.0 - C++Builder 4,5,6                      }
{ version 1.4 - March 2002                                       }
{                                                                }
{ written by                                                     }
{   TMS Software                                                 }
{   copyright © 2000-2002                                        }
{   Email : info@tmssoftware.com                                 }
{   Web : http://www.tmssoftware.com                             }
{****************************************************************}
unit webcreg;

interface
                    
uses
  WebCopy, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Web',[TWebCopy]);
end;

end.

