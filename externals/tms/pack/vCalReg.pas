{***************************************************************************}
{ TvCalendar component                                                      }
{ for Delphi 3.0,4.0,5.0 & C++Builder 3.0,4.0,5.0                           }
{ version 1.0 - rel. March 2001                                             }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2001                                               }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{***************************************************************************}

unit vCalReg;

interface
{$I TMSDEFS.INC}
uses
  Classes, vCal,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS',[TvCalendar]);
end;



end.
 