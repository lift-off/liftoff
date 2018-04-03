{*********************************************************************}
{ TGradientLabel component                                            }
{ for Delphi & C++Builder                                             }
{ version 1.0                                                         }
{                                                                     }
{ written by                                                          }
{  TMS Software                                                       }
{  copyright © 2002                                                   }
{  Email : info@tmssoftware.com                                       }
{  Web : http://www.tmssoftware.com                                   }
{*********************************************************************}

unit GradientLblReg;

interface

uses
  Classes, GradientLabel;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS', [TGradientLabel]);
end;



end.

