{********************************************************************}
{ THTMLButtons components                                            }
{ for Delphi 2.0,3.0,4.0,5.0,6.0 & C++Builder 1.0, 3.0,4.0,5.0       }
{ version 1.2                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 1999 - 2001                                 }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{********************************************************************}

unit htmbureg;

interface
{$I TMSDEFS.INC}
uses
  Classes, htmlbtns, htmlde,
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
  RegisterComponents('TMS HTML', [THTMLRadioButton,THTMLCheckbox,THTMLButton,THTMLRadioGroup,THTMLCheckGroup]);
  RegisterPropertyEditor(TypeInfo(String), THTMLCheckbox, 'Caption', THTMLStringProperty);
  RegisterPropertyEditor(TypeInfo(String), THTMLRadioButton, 'Caption', THTMLStringProperty);
  RegisterPropertyEditor(TypeInfo(String), THTMLButton, 'Caption', THTMLStringProperty);
end;



end.

