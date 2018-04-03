{**************************************************************************}
{ TADVCOLUMNGRID DESIGN TIME EDITOR                                        }
{ for Delphi & C++Builder                                                  }
{ version 2.5.x.x                                                          }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright © 1996-2002                                         }
{            Email : info@tmssoftware.com                                  }
{            Web : http://www.tmssoftware.com                              }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit acgde;

interface
{$I TMSDEFS.INC}
uses
  Classes, AdvCGrid,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;

type
  TAdvColumnGridEditor = class(TDefaultEditor)
  protected
  {$IFNDEF DELPHI6_LVL}
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
  {$ELSE}
    procedure EditProperty(const PropertyEditor: IProperty; var Continue: Boolean); override;
  {$ENDIF}
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;

implementation

uses
  SysUtils, Dialogs;

{$IFDEF DELPHI6_LVL}
procedure TAdvColumnGridEditor.EditProperty(const PropertyEditor: IProperty; var Continue: Boolean);
{$ELSE}
procedure TAdvColumnGridEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue, FreeEditor: Boolean);
{$ENDIF}
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'COLUMNS') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;


procedure TAdvColumnGridEditor.ExecuteVerb(Index: integer);
var
  compiler: string;
  od: TOpendialog;
begin
  case index of
  0:begin
    {$IFDEF VER100}
    compiler := 'Delphi 3';
    {$ENDIF}
    {$IFDEF VER110}
    compiler := 'C++Builder 3';
    {$ENDIF}
    {$IFDEF VER120}
    compiler := 'Delphi 4';
    {$ENDIF}
    {$IFDEF VER125}
    compiler := 'C++Builder 4';
    {$ENDIF}
    {$IFDEF VER130}
    {$IFDEF BCB}
    compiler := 'C++Builder 5';
    {$ELSE}
    compiler := 'Delphi 5';
    {$ENDIF}
    {$ENDIF}
    {$IFDEF DELPHI6_LVL}
    {$IFDEF BCB}
    compiler := 'C++Builder 6';
    {$ELSE}
    compiler := 'Delphi 6';
    {$ENDIF}
    {$ENDIF}
    {$IFDEF DELPHI7_LVL}
    {$IFDEF BCB}
    {$ELSE}
    compiler := 'Delphi 7';
    {$ENDIF}
    {$ENDIF}

    MessageDlg(Component.ClassName+' version '+(Component as TAdvColumnGrid).VersionString+' for '+compiler+#13#10'© 1997-2003 by TMS software',
               mtinformation,[mbok],0);
    end;
  1:begin
    od := TOpenDialog.Create(nil);
    od.DefaultExt := '*.CSV';
    od.Filter := 'CSV files (*.csv)|*.csv|All files (*.*)|*.*';
    if od.Execute then
    begin
      (Component as TAdvColumnGrid).SaveFixedCells := False;
      (Component as TAdvColumnGrid).LoadFromCSV(od.FileName);
    end;
    od.Free;
   end;
  2:begin
     (Component as TAdvColumnGrid).Clear;
    end;
  3:begin
      Edit;
    end;
  end;
end;

function TAdvColumnGridEditor.GetVerb(index: integer): string;
begin
  case index of
  0:Result := '&Version';
  1:Result := '&Load CSV file';
  2:Result := '&Clear';
  3:Result := 'C&olumns';
  end;
end;

function TAdvColumnGridEditor.GetVerbCount: integer;
begin
  Result := 4;
end;


end.

