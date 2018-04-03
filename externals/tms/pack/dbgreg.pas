{*******************************************************************}
{ TDBADVSTRINGGRID component                                        }
{ for Delphi 4.0,5.0,6.0 & C++Builder 4.0,5.0,6.0                   }
{ version 1.7                                                       }
{                                                                   }
{ written by                                                        }
{    TMS Software                                                   }
{    copyright © 1999-2002                                          }
{    Email : info@tmssoftware.com                                   }
{    Web : http://www.tmssoftware.com                               }
{                                                                   }
{*******************************************************************}

unit dbgreg;

interface
{$I TMSDEFS.INC}
uses
  dbadvgrd, Classes, DBAsgDE, HtmlDE,
{$IFDEF DELPHI6_LVL}
  DesignIntf
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Grids', [TDBAdvStringGrid]);
  RegisterComponentEditor(TDBAdvStringGrid,TDBAdvStringGridEditor);

  RegisterPropertyEditor(TypeInfo(string),TStringGridField,'FieldName',TSgFieldNameProperty);

  {$IFNDEF NOEDITOR}
  RegisterPropertyEditor(TypeInfo(TStringList), TDBAdvStringGrid, 'HTMLTemplate', THTMLTextProperty);
  {$ENDIF}
end;


end.
