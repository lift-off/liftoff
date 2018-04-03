{*******************************************************************}
{ TWEBUPDATE Wizard component                                       }
{ for Delphi & C++Builder                                           }
{ version 1.5                                                       }
{                                                                   }
{ written by                                                        }
{    TMS Software                                                   }
{    copyright © 1998-2002                                          }
{    Email : info@tmssoftware.com                                   }
{    Web   : http://www.tmssoftware.com                             }
{                                                                   }
{ The source code is given as is. The author is not responsible     }
{ for any possible damage done due to the use of this code.         }
{ The component can be freely used in any application. The source   }
{ code remains property of the writer and may not be distributed    }
{ freely as such.                                                   }
{*******************************************************************}

unit WUpdateWiz;

interface

uses
  WUpdate, WuWizForm, Classes, Windows, SysUtils, Forms;

type
  TWebUpdateWizard = class(TComponent)
  private
    FWebUpdate: TWebUpdate;
    FCaption: string;
    FPosition: TPosition;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Execute;
  published
    property Caption: string read FCaption write FCaption;
    property Position: TPosition read FPosition write FPosition;
    property WebUpdate: TWebUpdate read FWebUpdate write FWebUpdate;
  end;


implementation

{ TWebUpdateWizard }

constructor TWebUpdateWizard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WebUpdate := nil;
end;

procedure TWebUpdateWizard.Execute;
var
  WuWiz: TWuWiz;
begin
  if not Assigned(WebUpdate) then
    raise Exception.Create('No WebUpdate component assigned');

  WuWiz := TWuWiz.Create(Self);
  try
    WuWiz.WebUpdate := WebUpdate;
    WuWiz.Caption := FCaption;
    WuWiz.Position := FPosition;
    WuWiz.ShowModal;
  finally
    WuWiz.Free;
  end;

end;

end.
