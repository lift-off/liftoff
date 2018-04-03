{********************************************************************}
{ TDBHTMLCheckBox & TDBHTMLRadioGroup component                      }
{ for Delphi 2.0,3.0,4.0,5.0,6.0 & C++Builder 1.0, 3.0,4.0,5.0       }
{ version 1.0                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 1999 - 2001                                 }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{********************************************************************}

unit DBHTMLBtnsReg;

interface
{$I TMSDEFS.INC}
uses
  Classes, htmlbtns, htmlde, DBHTMLBtns,
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
  RegisterComponents('TMS HTML', [TDBHTMLCheckbox]);
  RegisterComponents('TMS HTML', [TDBHTMLRadioGroup]);
  RegisterPropertyEditor(TypeInfo(String), TDBHTMLCheckbox, 'Caption', THTMLStringProperty);
end;



end.

