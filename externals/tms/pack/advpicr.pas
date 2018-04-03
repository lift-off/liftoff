{********************************************************************}
{ TAdvPicture component                                              }
{ for Delphi 3.0,4.0,5.0,6.0 C++Builder 3,4,5                        }
{ version 1.2                                                        }
{                                                                    }
{ written                                                            }
{   TMS Software                                                     }
{   copyright © 2001                                                 }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The component can be freely used in any application. The source    }
{ code remains property of the writer and may not be distributed     }
{ freely as such.                                                    }
{********************************************************************}

unit advpicr;

interface
{$I TMSDEFS.INC}
uses
  AdvPicture,AdvPicDE,Classes,
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
  RegisterComponents('TMS', [TAdvPicture]);
  RegisterPropertyEditor(TypeInfo(TIPicture), TAdvPicture, 'Picture', TAdvPictureProperty);
end;

end.

