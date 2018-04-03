{********************************************************************}
{ TCHECKLISTEDIT component                                           }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0                }
{ version 1.2, October 2000                                          }
{                                                                    }
{ Written by                                                         }
{    TMS Software                                                    }
{    Copyright © 1999-2000                                           }
{    Email : info@tmssoftware.com                                    }
{    Web : http://www.tmssoftware.com                                }
{********************************************************************}

unit clistedr;

interface

uses
  Classes,CListEd;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Edits', [TCheckListEdit]);
end;


end.
