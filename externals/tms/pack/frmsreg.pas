{********************************************************************
TFORMSIZE component
for Delphi 3.0, 4.0, 5.0 & C++Builder 3.0,4.0,5.0
version 1.0

written by TMS Software
           copyright © 2001
           Email : info@tmssoftware.com
           Web : http://www.tmssoftware.com
{********************************************************************}

unit frmsreg;

interface

uses
 formsize,classes;

procedure Register;

implementation

procedure Register;
begin
 RegisterComponents('TMS', [TFormSize]);
end;



end.

