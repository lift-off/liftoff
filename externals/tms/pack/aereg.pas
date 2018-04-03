{***********************************************************************}
{ TADVEDIT component                                                    }
{ for Delphi & C++Builder                                               }
{ version 2.4                                                           }
{                                                                       }
{ written by                                                            }
{   TMS Software                                                        }
{   Copyright © 1996-2002                                               }
{   Email : info@tmssoftware.com                                        }
{   Web : http://www.tmssoftware.com                                    }
{***********************************************************************}
unit aereg;

interface

uses
  AdvEdit, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TAdvEdit,TAdvMaskEdit]);
end;



end.

