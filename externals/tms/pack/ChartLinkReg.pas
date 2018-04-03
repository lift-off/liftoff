{*************************************************************************}
{ TChartLink component                                                    }
{ for Delphi 3.0,4.0,5.0 + C++Builder 3.0,4.0,5.0                         }
{ version 1.0, April 2001                                                 }
{                                                                         }
{ Copyright © 2000-2001                                                   }
{   TMS Software                                                          }
{   Email : info@tmssoftware.com                                          }
{   Web : http://www.tmssoftware.com                                      }
{                                                                         }
{*************************************************************************}

unit ChartLinkReg;

interface

uses
 Classes, ChartLink;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Grids',[TChartLink]);
end;


end.
 