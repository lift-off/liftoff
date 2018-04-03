{********************************************************************
TTREELIST component
for Delphi 3.0, 4.0, 5.0 & C++Builder 1.0, 3.0, 4.0, 5.0
version 0.8

written by TMS Software
           copyright © 1999-2000
           Email : info@tmssoftware.com
           Web : http://www.tmssoftware.com
{********************************************************************}

unit tlreg;

interface

uses
 treelist,classes;

procedure Register;

implementation

procedure Register;
begin
 RegisterComponents('TMS', [TTreeList]);
end;

end.

