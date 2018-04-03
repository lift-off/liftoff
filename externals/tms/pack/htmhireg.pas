{*************************************************************************}
{ THTMLHint component                                                     }
{ for Delphi 3.0,4.0,5.0,6.0 + C++Builder 3.0,4.0,5.0                     }
{ version 1.3                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{            copyright © 1999 - 2001                                      }
{            Email : info@tmssoftware.com                                 }
{            Web : http://www.tmssoftware.com                             }
{                                                                         }
{*************************************************************************}

unit htmhireg;

interface

uses
  Classes,htmlhint;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS HTML',[ THTMLHint ]);
end;

end.

