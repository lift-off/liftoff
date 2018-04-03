{********************************************************************}
{ THTMLTREEVIEW component                                            }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0                }
{ version 1.0                                                        }
{                                                                    }
{ Written by                                                         }
{   TMS Software                                                     }
{   Copyright © 1998-2001                                            }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{********************************************************************}

unit htmltvr;

interface

uses
  HTMLTV, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS HTML', [THTMLTreeview]);
end;



end.

