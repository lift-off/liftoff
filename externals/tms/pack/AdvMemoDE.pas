{********************************************************************}
{ IntraWeb script editor property editor                             }
{ for Delphi & C++Builder                                            }
{ version 1.0                                                        }
{                                                                    }
{ written by : TMS Software                                          }
{               copyright © 2002 - 2003                              }
{               Email : info@tmssoftware.com                         }
{               Web : http://www.tmssoftware.com                     }
{********************************************************************}
unit AdvMemoDE;

interface
{$I TMSDEFS.INC}

uses
  Classes, AdvMemo, Dialogs, uMemoEdit, Forms, Controls,
  {$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
  {$ELSE}
  DsgnIntf
  {$ENDIF}
  ;

type
  TAdvMemoProperty = class(TClassProperty)
  public
    function GetAttributes:TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TAdvMemoEditor = class(TDefaultEditor)
  protected
  {$IFNDEF DELPHI6_LVL}
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
  {$ELSE}
    procedure EditProperty(const PropertyEditor: IProperty; var Continue: Boolean); override;
  {$ENDIF}
  public
  end;

implementation

uses
  SysUtils;

{ TIWScriptEventProperty }

procedure TAdvMemoProperty.Edit;
var
  SE: TTMSMemoEdit;
begin
  SE := TTMSMemoEdit.Create(Application);

  try
    SE.AdvMemo1.Lines.Assign(TStrings(GetOrdValue));

    if GetComponent(0) is TAdvMemo then
    begin
      SE.AdvMemo1.SyntaxStyles := (GetComponent(0) as TAdvMemo).SyntaxStyles;
    end;

    if SE.ShowModal = mrOk then
      SetOrdValue(longint(SE.AdvMemo1.Lines));
  finally
    SE.Free;
  end;
end;

function TAdvMemoProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

{ TAdvMemoEditor }
{$IFDEF DELPHI6_LVL}
procedure TAdvMemoEditor.EditProperty(const PropertyEditor: IProperty; var Continue: Boolean);
{$ELSE}
procedure TAdvMemoEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue, FreeEditor: Boolean);
{$ENDIF}
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'LINES') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;



end.




