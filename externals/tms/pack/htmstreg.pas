{**************************************************************************}
{ THTMLStaticText component                                                }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0                      }
{ version 1.2                                                              }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright © 2000 - 2001                                       }
{            Email : info@tmssoftware.com                                  }
{            Web : http://www.tmssoftware.com                              }
{**************************************************************************}

unit htmstreg;

interface
{$I TMSDEFS.INC}
uses
  Classes, HTMLText, HTMLDE,
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
 RegisterComponents('TMS HTML', [THTMLStaticText ]);
 RegisterPropertyEditor(TypeInfo(TStrings), THTMLStaticText, 'HTMLText', THTMLTextProperty);
 RegisterComponentEditor(THTMLStaticText, THTMLDefaultEditor);  
end;

end.
 
