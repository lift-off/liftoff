{********************************************************************}
{ THTMDialog component                                               }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0                }
{ version 1.0, Februari 2001                                         }
{                                                                    }
{  Written by                                                        }
{    TMS Software                                                    }
{    Copyright © 2001                                                }
{    Email : info@tmssoftware.com                                    }
{    Web : http://www.tmssoftware.com                                }
{********************************************************************}

unit htmldlgr;

interface
{$I TMSDEFS.INC}
uses
  Classes, HTMLDialog, HTMLDE,
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
  RegisterComponents('TMS HTML',[ THTMLDialog ]);
  RegisterPropertyEditor(TypeInfo(TStringList), THTMLDialog, 'HTMLText', THTMLTextProperty);
end;

end.

