{**************************************************************************}
{ THTMLCredit component                                                    }
{ for Delphi & C++Builder                                                  }
{ version 1.0                                                              }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright © 2003                                              }
{            Email : info@tmssoftware.com                                  }
{            Web : http://www.tmssoftware.com                              }
{**************************************************************************}

unit HTMLCreditReg;

interface
{$I TMSDEFS.INC}
uses
  Classes, HTMLCredit, HTMLDE,
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
  RegisterComponents('TMS HTML', [THTMLCredit]);
  RegisterPropertyEditor(TypeInfo(TStrings), THTMLCredit, 'HTMLText', THTMLTextProperty);
  RegisterComponentEditor(THTMLCredit, THTMLDefaultEditor);  
end;

end.
 
