{****************************************************************}
{ TWebUpdate & TWebUpdate Wizard component                       }
{ for Delphi & C++Builder                                        }
{ version 1.5                                                    }
{                                                                }
{ written by                                                     }
{   TMS Software                                                 }
{   copyright © 1998-2002                                        }
{   Email : info@tmssoftware.com                                 }
{   Web : http://www.tmssoftware.com                             }
{****************************************************************}
unit wupdreg;

{$I TMSDEFS.INC}

interface

uses
  Classes, WUpdate
  {$IFDEF DELPHI5_LVL}
  , WUpdateWiz
  {$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Web',[TWebUpdate
  {$IFDEF DELPHI5_LVL}
  , TWebUpdateWizard
  {$ENDIF}
  ]);
end;

end.

