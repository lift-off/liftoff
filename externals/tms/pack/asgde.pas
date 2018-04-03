{**************************************************************************}
{ TADVSTRINGGRID DESIGN TIME EDITOR                                        }
{ for Delphi & C++Builder                                                  }
{ version 2.5.x.x                                                          }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright © 1996-2003                                         }
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

unit asgde;

interface
{$I TMSDEFS.INC}
uses
  Classes, AdvGrid, Windows, Forms, TypInfo
{$IFDEF DELPHI6_LVL}
  , DesignIntf, DesignEditors, ContNrs, AsgPropPref
{$ELSE}
  , DsgnIntf
{$ENDIF}
  ;

type
  TAdvStringGridEditor = class(TDefaultEditor)
  protected
    {$IFDEF DELPHI6_LVL}
    procedure PrintSetProc(const Prop: IProperty);
    {$ELSE}
    procedure PrintSetProc(PropEd: TPropertyEditor);
    {$ENDIF}
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;

implementation

uses
  Dialogs, SysUtils, ShlObj, ActiveX;

{ get My Documents folder }

{$IFDEF DELPHI6_LVL}
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

{$IFNDEF DELPHI6_LVL}
procedure TAdvStringGridEditor.PrintSetProc(PropEd: TPropertyEditor);
begin
  try
    if PropEd.GetName = 'PrintSettings' then
      PropEd.Edit
  finally
    PropEd.Free;
  end;
end;

{$ELSE}
procedure TAdvStringGridEditor.PrintSetProc(const Prop: IProperty);
begin
  if Prop.GetName = 'PrintSettings' then
    Prop.Edit
end;
{$ENDIF}


procedure TAdvStringGridEditor.ExecuteVerb(Index: integer);
var
  compiler: string;
  od: TOpendialog;
  {$IFDEF DELPHI6_LVL}
  sd: TSaveDialog;
  CList: IDesignerSelections;
  {$ENDIF}

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
    {$IFDEF VER140}
      {$IFDEF BCB}
      compiler := 'C++Builder 6';
      {$ELSE}
      compiler := 'Delphi 6';
      {$ENDIF}
    {$ENDIF}
    {$IFDEF VER150}
      {$IFDEF BCB}
      compiler := '';
      {$ELSE}
      compiler := 'Delphi 7';
      {$ENDIF}
    {$ENDIF}

    MessageDlg(Component.ClassName+' version '+(Component as TAdvStringGrid).VersionString+' for '+compiler+#13#10'© 1997-2003 by TMS software',
               mtinformation,[mbok],0);
    end;
  1:begin
    od := TOpenDialog.Create(nil);
    od.DefaultExt := '*.CSV';
    od.Filter := 'CSV files (*.csv)|*.csv|All files (*.*)|*.*';
    if od.Execute then
    begin
      (Component as TAdvStringGrid).SaveFixedCells := False;
      (Component as TAdvStringGrid).LoadFromCSV(od.FileName);
    end;
    od.Free;
   end;
  2:begin
     (Component as TAdvStringGrid).Clear;
    end;

  {$IFDEF DELPHI6_LVL}
  3:begin
      CList := TDesignerSelections.Create;
      CList.Add(Component);
      GetComponentProperties(CList, tkProperties, Designer, PrintSetProc,nil);
    end;
  4:begin
      if FileExists(GetMyDocuments + '\ASGPREF.CFG') then
        RestorePropertiesToFile(Component,GetMyDocuments + '\ASGPREF.CFG');
    end;
  5:begin
      StorePropertiesToFile(Component,GetMyDocuments + '\ASGPREF.CFG');
    end;
  6:begin
      od := TOpenDialog.Create(Application);
      if od.Execute then
        RestorePropertiesToFile(Component,od.FileName);
      od.Free;
    end;
  7:begin
      sd := TSaveDialog.Create(Application);
      if sd.Execute then
        StorePropertiesToFile(Component,sd.FileName);
      sd.Free;
    end;
  {$ENDIF}
  end;
end;

function TAdvStringGridEditor.GetVerb(index: integer): string;
begin
  case index of
  0:result := '&Version';
  1:result := '&Load CSV file';
  2:result := '&Clear';
  {$IFDEF DELPHI6_LVL}
  3:result := '&Print settings';
  4:Result := 'Get preference';
  5:Result := 'Set preference';
  6:Result := 'Load Config';
  7:Result := 'Save Config';
  {$ENDIF}
  end;
end;

function TAdvStringGridEditor.GetVerbCount: integer;
begin
  {$IFDEF DELPHI6_LVL}
  Result := 8;
  {$ELSE}
  Result := 3;
  {$ENDIF}
end;


end.

