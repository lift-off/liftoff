unit id_tools;

interface

uses classes, windows, forms, shellapi, sysutils;

type
  aShellDir =
    ( shdDesktop, shdPrograms, shdStart, shdStartup,
      shdFavorites, shdPersonal, shdHistory, shdRecent,
      shdSendTo, shdTemplates,
      shdLocalAppData, shdLocalSettings, shdAppData );

{ Open & Execute }
procedure OpenFile(filename : string);
procedure OpenProgram(prog, params : string);
function  OpenCmdLine(const CmdLine: string; WindowState: word): boolean;
function  ExecAndWait(const Filename, Params: string;
                      WindowState: word): boolean;
function  ExecCmdLineAndWait(const CmdLine: string;
                      WindowState: word): boolean; { WindowState is one of the SW_xxx constants }

{ Misc }
function  MsgBox(text,titel : string; flags : longint) : integer;
function  GetAssociatedIcon(const AExtension: string; ASmall: Boolean): HIcon; // Filename oder Extension für das File
function  GetTimeZoneStr : string; // Returns the system time zone
function  GetTimeZoneDiff : longint; // Return the time difference between UCT und local time in mins

{ Dirs }
function  DirExists(path : string) : boolean;
function  GetTempDir: string; // Ermittelt das Temp-Verzeichnis
function  GetTempFileName( AFilePath: string; AFileNamePrefix: string): string; // Ermittelt einen Temp-Dateinamen
function  ProgramFilesDir{}: string;
function  CommonFilesDir{}: string;
function  WindowsSystemDir{}: string;
function  WindowsDir{}: string;
function  ShellDir( ADir: aShellDir; ACommon: boolean ): string;
function  BuildRelativePath( _basePath, _path: string ): string;
function  AdjustDirRelativeTo( const _fileName, _relativeTo: string ): string;
function  AdjustDir( const _fileName: string ): string;
function  UpNLevels( const _path: string; _n: integer ): string;

{ Env-Vars }
function  ReplaceEnvVars( const _expr: string ): string;
function  GetEnvVar( const AVar: string ): string;

{ IDE }
function IsIDERunning: boolean;

{ System info }
function  GetCurrentUserName: string;
function  GetCurrentUserDomain: string;
function  GetComputerName: string;

{ Help System }
function HelpJump( ATopicName: string ): boolean;

implementation

uses
  registry, math,
  id_string;

{ This function works also with non-winhelp files in Delphi 7 because Borland
  has broken parts of the helpsystem with Delphi 6 +  :(( }
function HelpJump( ATopicName: string ): boolean;
var
  command: array[0..255] of Char;
begin
  StrPCopy( command, ATopicName );
  Application.HelpCommand(HELP_COMMAND, Longint(@command));
  result:= true;
end;

function AdjustDirRelativeTo( const _fileName, _relativeTo: string ): string;
begin
  result:= _fileName;
  if Copy(result,1,2) = '.\' then begin
    result:= _relativeTo + Copy(result,2,999);
  end;
  if Pos( '%WIN%', result ) > 0 then begin
    ReplaceStr( result, '%WIN%', WindowsDir(), true );
  end;
  if Pos( '%SYS%', result ) > 0 then begin
    ReplaceStr( result, '%SYS%', WindowsSystemDir(), true );
  end;
  if Pos( '%PROGRAM%', result ) > 0 then begin
    ReplaceStr( result, '%PROGRAM%', ProgramFilesDir(), true );
  end;
  if Pos( '%COMMON%', result ) > 0 then begin
    ReplaceStr( result, '%COMMON%', CommonFilesDir(), true );
  end;
end {AdjustDirRelativeTo};

function ProgramFilesDir{}: string;
begin
  with TRegistry.Create do try
    RootKey:= HKey_Local_Machine;
    if OpenKey( 'Software\Microsoft\Windows\CurrentVersion', True ) then begin
      if ValueExists( 'ProgramFilesDir' ) then begin
        result:= ReadString( 'ProgramFilesDir' );
      end else begin
        result:= Copy(WindowsDir{},1,2) + '\Program Files';
        WriteString( 'ProgramFilesDir', result );
      end;
    end;
  finally Free end {with TRegistry};
end {ProgramFilesDir};

function CommonFilesDir{}: string;
begin
  with TRegistry.Create do try
    RootKey:= HKey_Local_Machine;
    if OpenKey( 'Software\Microsoft\Windows\CurrentVersion', True ) then begin
      if ValueExists( 'CommonFilesDir' ) then begin
        result:= ReadString( 'CommonFilesDir' );
      end else begin
        result:= Copy(WindowsDir{},1,2) + '\Program Files\Common Files';
        WriteString( 'CommonFilesDir', result );
      end;
    end;
  finally Free end {with TRegistry};
end {CommonFilesDir};

function WindowsSystemDir{}: string;
begin
  SetLength( result, 255 );
  Windows.GetSystemDirectory( pChar(result), 255 );
  SetLength( result, StrLen(pChar(result)) );
end {WindowsSystemDir};

function WindowsDir{}: string;
begin
  SetLength( result, 255 );
  Windows.GetWindowsDirectory( pChar(result), 255 );
  SetLength( result, StrLen(pChar(result)) );
end {WindowsDir};

function ShellDir( ADir: aShellDir; ACommon: boolean ): string;
const
  DirMap: array[aShellDir] of string
    = ( 'Desktop', 'Programs', 'Start Menu', 'Startup'
      , 'Favorites', 'Personal'
      , 'History', 'Recent', 'SendTo', 'Templates'
      , 'Local AppData', 'Local Settings', 'AppData'
      );
var
  n: string;
begin
  with TRegistry.Create do try
    if ACommon
      then RootKey:= HKey_Local_Machine
      else RootKey:= HKey_Current_User;
    if OpenKey( 'Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders', False ) then begin
      n:= DirMap[ADir];
      if ACommon then n:= 'Common ' + n;
      if ValueExists( n ) then begin
        result:= ReplaceEnvVars( ReadString( n ));
      end else begin
        result:= '';
      end;
    end;
  finally Free end {with TRegistry};
end {ShellDir};

function AdjustDir( const _fileName: string ): string;
begin
  result:= AdjustDirRelativeTo( _fileName, ExtractFilePath( ParamStr(0)) );
end {AdjustDir};


function BuildRelativePath( _basePath, _path: string ): string;

  function NumLevels( _path: string; _delimitor: char = '\' ): integer;
  var
    i: integer;
  begin
    result:= 1;
    i:= 1;
    while i < Length( _path ) + 1 do begin
      if _path[ i ] = _delimitor then begin
        Inc( result );
      end;
      Inc( i );
    end;
  end {NumLevels};

  function CreateBackspaces( const _num: integer ): string;
  begin
    result:= StringOfChar( ';', _num );
    result:= ReplaceStr( result, ';', '..\' );
  end {CreateBackspcaes};

var
  level: integer;
  numBaseLevels: integer;
  numPathLevels: integer;
begin
  _basePath:= ExcludeTrailingPathDelimiter( _basePath );
  _path:= ExcludeTrailingPathDelimiter( _path );
  numBaseLevels:= NumLevels( _basePath );
  numPathLevels:= NumLevels( _path );
  level:= -1;
  while level < Min( numBaseLevels, numPathLevels ) do begin
    inc( level );
    if not SameText( UpNLevels( _basePath, numBaseLevels - level - 1 ), UpNLevels( _path, numPathLevels - level - 1 ) ) then begin
      break;
    end;
  end;
  if level = 0 then begin
    result:= '';
  end else if level = numBaseLevels then begin
    result:= '.\' + Copy( _path, Length( IncludeTrailingPathDelimiter( _basePath ) ) + 1, 999 );
  end else if level = numPathLevels then begin
    result:= CreateBackspaces( numBaseLevels - numPathLevels );
  end else begin
    result:= CreateBackspaces( numBaseLevels - level );
    result:= result + Copy( _path, Length( UpNLevels( _path, numPathLevels - level ) ) + 2, 999 );
  end;
end {BuildRelativePath};

function UpNLevels( const _path: string; _n: integer ): string;
var
  i: integer;
begin
  result:= ExcludeTrailingPathDelimiter( _path );
  for i:= 1 to _n do begin
    result:= Copy( result, 1, LastDelimiter( '\/', result ) - 1 );
  end;
end {UpNLevels};

function ReplaceEnvVars( const _expr: string ): string;
var
  p, c: integer;
  s, env: string;
begin
  result:= AdjustDir( _expr );

  while True do begin
    p:= Pos( '%', result );
    if p > 0 then begin
      c:= Pos( '%', Right( result, Length( result ) - p ) ) + 1;
      if c > 1 then begin
        s:= Copy( result, p, c );
        env:= GetEnvVar( s );
        if env <> '' then result:= ReplaceStr( result, s, env, true );
      end else Break;
    end else Break;
  end;
end {ReplaceEnvVars};

function GetEnvVar( const AVar: string ): string;
var
  s: string;
  c: integer;
  buf: PChar;
begin
  result:= '';
  if AVar = '' then Exit;
  s:= ReplaceStr( AVar, '%', '', true );
  c:= GetEnvironmentVariable( PChar( s ), nil, 0 );
  if c > 0 then begin
    GetMem( buf, c );
    try
      GetEnvironmentVariable( PChar( s ), buf, c );
      result:= buf;
    finally
      FreeMem( buf, c );
    end;
  end;
end {GetEnvVar};


procedure OpenFile(filename : string);
var c : array[0..800] of char;
begin
 StrPCopy(c,filename);
 ShellExecute(Application.Handle,'open',c, nil, nil, SW_NORMAL);
end;

procedure OpenProgram(prog, params : string);
var c,p : array[0..800] of char;
begin
 StrPCopy(c,prog);
 StrPCopy(p,params);
 ShellExecute(Application.Handle,'open',c,p, nil, SW_NORMAL);
end;


{ WindowState is one of the SW_xxx constants }
function  ExecAndWait(const Filename, Params: string;
                      WindowState: word): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
begin
  { Enclose filename in quotes to take care of
    long filenames with spaces. }
  CmdLine := '"' + Filename + '"' + Params;
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WindowState;
  end;
  Result := CreateProcess(NIL, PChar(CmdLine), NIL, NIL, FALSE,
                          CREATE_NEW_CONSOLE or
                          NORMAL_PRIORITY_CLASS, NIL,
                          PChar(ExtractFilePath(Filename)),
                          SUInfo, ProcInfo);
  { Wait for it to finish. }
  if Result then
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
end;

function  ExecCmdLineAndWait(const CmdLine: string;
                      WindowState: word): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  { Enclose filename in quotes to take care of
    long filenames with spaces. }
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WindowState;
  end;
  Result := CreateProcess(NIL, PChar(CmdLine), NIL, NIL, FALSE,
                          CREATE_NEW_CONSOLE or
                          NORMAL_PRIORITY_CLASS, NIL,
                          nil {PChar(ExtractFilePath(Filename))},
                          SUInfo, ProcInfo);
  { Wait for it to finish. }
  if Result then
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
end;

function  OpenCmdLine(const CmdLine: string;
                      WindowState: word): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  { Enclose filename in quotes to take care of
    long filenames with spaces. }
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WindowState;
  end;
  Result := CreateProcess(NIL, PChar(CmdLine), NIL, NIL, FALSE,
                          CREATE_NEW_CONSOLE or
                          NORMAL_PRIORITY_CLASS, NIL,
                          nil {PChar(ExtractFilePath(Filename))},
                          SUInfo, ProcInfo);
end;

function DirExists(path : string) : boolean;
var OldDir : string;
begin
  GetDir(0,OldDir);
  {$i-}
  ChDir(path);
  result := (IOResult = 0);
  ChDir(OldDir);
  {$i+}
end;

function  MsgBox(text,titel : string; flags : longint) : integer;
var
  c1 : array[0..1024] of char;
  c2 : array[0..150] of char;
begin
  StrPCopy(c1,Text);
  StrPCopy(c2,Titel);
  result := Application.MessageBox(c1,c2,flags);
end;

function GetAssociatedIcon(const AExtension: string; ASmall: Boolean): HIcon;
var
  Info: TSHFileInfo;
  Flags: Cardinal;
begin
  if ASmall then
    Flags := SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES
  else
    Flags := SHGFI_ICON or SHGFI_LARGEICON or SHGFI_USEFILEATTRIBUTES;

  SHGetFileInfo(PChar(AExtension), FILE_ATTRIBUTE_NORMAL, Info, SizeOf(TSHFileInfo), Flags);
  Result := Info.hIcon;
end;

function GetTimeZoneDiff : longint;
var tzInfo : _TIME_ZONE_INFORMATION;
begin
  GetTimeZoneInformation(tzInfo);
  result := tzInfo.Bias;
end;

function  GetTimeZoneStr : string;
var TimeDiff : longint;
    HourDiff,
    MinDiff  : integer;
begin
  result := '';
  TimeDiff := GetTimeZoneDiff;
  if TimeDiff < 0 then begin
    result := result + '+';
    TimeDiff := TimeDiff * -1;
  end else begin
    result := result + '-';
  end;
  HourDiff := round(Int(TimeDiff / 60));
  MinDiff := TimeDiff - (HourDiff * 60);
  result := result + IntToStrEx(HourDiff, 2) + ':' + IntToStrEx(MinDiff, 2);
end;

function GetTempDir: string;
var
  Buffer: array[0..2048] of char;
begin
  GetTempPath(SizeOf(Buffer), Buffer);
  result := StrPas(Buffer);
end;

function GetTempFileName( AFilePath: string; AFileNamePrefix: string): string;
var
  pathname: array[0..2048] of char;
  tmpFileName: array[0..2048] of char;
  prefix: array[0..100] of char;
begin

  StrPCopy( pathname, AFilePath );
  StrPCopy( prefix, AFileNamePrefix );
  if Windows.GetTempFileName( pathname, prefix, 0, tmpFileName ) <> 0 then begin
    result:= String( tmpFileName );
  end else begin
    result:= '';
  end;

end {GetTempFileName};


function GetCurrentUserName: string;
begin
  result:= GetEnvVar( 'USERNAME' );
end {GetCurrentUserName};

function GetCurrentUserDomain: string;
begin
  result:= GetEnvVar( 'USERDOMAIN' );
end {GetCurrentUserDomain};

function GetComputerName: string;
begin
  result:= GetEnvVar( 'COMPUTERNAME' );
end {GetComputerName};

function IsIDERunning: boolean;
begin
  result:= DebugHook = 1;
end {IsIDERunning};

end.
