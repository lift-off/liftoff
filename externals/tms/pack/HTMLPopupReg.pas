{********************************************************************}
{ THTMLPopup component                                               }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0,6.0            }
{ version 1.1                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2001-2002                                   }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{********************************************************************}

unit HTMLPopupReg;

interface
{$I TMSDEFS.INC}
uses
  Classes, HTMLPopup, HTMLDE,
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
  RegisterComponents('TMS HTML', [THTMLPopup]);
  RegisterPropertyEditor(TypeInfo(TStringList), THTMLPopup, 'Text', THTMLTextProperty);
end;



end.

