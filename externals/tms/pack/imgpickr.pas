{********************************************************************}
{ TImagePicker component                                             }
{ for Delphi  3.0, 4.0, 5.0 & C++Builder 3.0, 4.0, 5.0               }
{ version 1.0                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2001                                        }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{********************************************************************}

unit imgpickr;

interface

uses
  ImagePicker,Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS', [TImagePicker]);
end;



end.

