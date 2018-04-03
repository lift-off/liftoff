{***************************************************************************}
{ TInspectorBar component                                                   }
{ for Delphi & C++Builder                                                   }
{ version 1.2                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2001 - 2003                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{***************************************************************************}
unit InspectorBarReg;

interface
{$I TMSDEFS.INC}
uses
  Classes, InspectorBar, InspImg, InspDE, Controls,
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
  RegisterComponents('TMS Bars',[TInspectorBar]);
  RegisterComponentEditor(TInspectorBar,TInspectorBarEditor);
  RegisterPropertyEditor(TypeInfo(TInspImage), TInspectorPanel, 'Splitter', TInspImageProperty);
  RegisterPropertyEditor(TypeInfo(TInspImage), TInspectorItem, 'Background', TInspImageProperty);
  RegisterPropertyEditor(TypeInfo(TWinControl), TInspectorPanel, 'Control', TInspControlProperty);
end;

end.
