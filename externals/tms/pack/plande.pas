{$I TMSDEFS.INC}

{***********************************************************************}
{ TPlanner component design time code                                   }
{ for Delphi & C++Builder                                               }
{ version 1.7, Dec 2002                                                 }
{                                                                       }
{ written by TMS Software                                               }
{            copyright © 1999-2002                                      }
{            Email: info@tmssoftware.com                                }
{            Web: http://www.tmssoftware.com                            }
{                                                                       }
{ The source code is given as is. The author is not responsible         }
{ for any possible damage done due to the use of this code.             }
{ The component can be freely used in any application. The complete     }
{ source code remains property of the author and may not be distributed,}
{ published, given or sold in any form as such. No parts of the source  }
{ code can be included in any other component or application without    }
{ written authorization of the author.                                  }
{***********************************************************************}

unit plande;

interface



uses
  Classes,Windows, SysUtils, Dialogs, Planner, Forms
  {$IFDEF DELPHI5_LVL}
  , PlanPropPref
  {$ENDIF}
  {$IFDEF DELPHI6_LVL}
  , DesignIntf, DesignEditors
  {$ELSE}
  , DsgnIntf
  {$ENDIF}
  ;


type

  TPlannerEditor = class(TDefaultEditor)
  protected
  {$IFNDEF DELPHI6_LVL}
    procedure EditProperty(PropertyEditor: TPropertyEditor;
                           var Continue, FreeEditor: Boolean); override;
  {$ELSE}
    procedure EditProperty(const PropertyEditor:IProperty; var Continue:Boolean); override;
  {$ENDIF}
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;


implementation

uses
  ShlObj, ActiveX;

{ get My Documents folder }

{$IFDEF DELPHI5_LVL}
procedure FreePidl( pidl: PItemIDList );
var
  allocator: IMalloc;
begin
  if Succeeded(SHGetMalloc(allocator)) then
    allocator.Free(pidl);
end;

function GetMyDocuments: string;
var
  pidl: PItemIDList;
  Path: array [0..MAX_PATH-1] of char;
begin
  Result := '';

  if Succeeded(
       SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, pidl)
     ) then
  begin
    if SHGetPathFromIDList(pidl, Path) then
      Result := StrPas(Path);
    FreePidl(pidl);
  end;
end;
{$ENDIF}

procedure TPlannerEditor.ExecuteVerb(Index: integer);
var
  compiler:string;
  {$IFDEF DELPHI5_LVL}
  od,sd: topendialog;
  {$ENDIF}
begin
  case Index of
  0:begin
      {$IFDEF VER90}
      compiler := 'Delphi 2';
      {$ENDIF}
      {$IFDEF VER93}
      compiler:='C++Builder 1';
      {$ENDIF}
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
      {$IFDEF VER140}
      {$IFDEF BCB}
      compiler := 'C++Builder 6';
      {$ELSE}
      compiler := 'Delphi 6';
      {$ENDIF}
      {$ENDIF}
      {$IFDEF VER150}
      {$IFDEF BCB}

      {$ELSE}
      compiler := 'Delphi 7';
      {$ENDIF}
      {$ENDIF}

      MessageDlg(Component.ClassName+' version '+ (Component as TCustomPlanner).VersionString + ' for ' + compiler + #13#10#13#10'© 1999-2002 by TMS software'#13#10'http://www.tmssoftware.com',
                 mtInformation,[mbok],0);
    end;

  1: Edit;
  {$IFDEF DELPHI5_LVL}
  2: begin
       if FileExists(GetMyDocuments + '\PLANPREF.CFG') then
         RestorePropertiesToFile(Component,GetMyDocuments + '\PLANPREF.CFG');
     end;
  3: begin
       StorePropertiesToFile(Component,GetMyDocuments + '\PLANPREF.CFG');
     end;
  4: begin
       od := TOpenDialog.Create(Application);
       if od.Execute then
         RestorePropertiesToFile(Component,od.FileName);
       od.Free;
     end;
  5: begin
      sd := TSaveDialog.Create(Application);
      if sd.Execute then
        StorePropertiesToFile(Component,sd.FileName);
      sd.Free;
    end;
  {$ENDIF}
  end;
end;

{$IFNDEF DELPHI6_LVL}
procedure TPlannerEditor.EditProperty(PropertyEditor: TPropertyEditor;
                                      var Continue, FreeEditor: Boolean);
{$ELSE}
procedure TPlannerEditor.EditProperty(const PropertyEditor:IProperty;
                                      var Continue:Boolean);
{$ENDIF}
var
  PropName: string;
begin

  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'ITEMS') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;


function TPlannerEditor.GetVerb(Index: Integer): string;
begin
  Result := '';
  case Index of
  0:Result := 'About';
  1:Result := 'Items Editor';
  {$IFDEF DELPHI5_LVL}
  2:Result := 'Get preference';
  3:Result := 'Set preference';
  4:Result := 'Load Config';
  5:Result := 'Save Config';
  {$ENDIF}
  end;
end;

function TPlannerEditor.GetVerbCount: Integer;
begin
  {$IFDEF DELPHI5_LVL}
  Result := 6;
  {$ELSE}
  Result := 2;
  {$ENDIF}
end;


end.

