{*****************************************************************}
{ TWEBDATA component                                              }
{ for Delphi 3.0,4.0,5.0,6.0 C++Builder 3,4,5                     }
{ version 1.0 - October 2001                                      }
{                                                                 }
{ written by                                                      }
{   TMS Software                                                  }
{   copyright © 1999 - 2001                                       }
{   Email: info@tmssoftware.com                                   }
{   Web: http://www.tmssoftware.com                               }
{*****************************************************************}
unit wdatreg;

interface

uses
  WebData, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Web',[TWebData]);
end;

end.

