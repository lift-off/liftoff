{**************************************************************************}
{ CAB FDI procs                                                            }
{ for Delphi & C++Builder                                                  }
{ version 1.1                                                              }
{                                                                          }
{ written by TMS Software                                                  }
{           copyright © 1999 - 2002                                        }
{           Email : info@tmssoftware.com                                   }
{           Web : http://www.tmssoftware.com                               }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit cabfdi;

{$DEFINE noTMSDEBUG}

interface

uses
 wintypes;

const
    cabdll = 'cabinet.dll';

    FDIERROR_NONE = 0;
    FDIERROR_CABINET_NOT_FOUND = 1;
    FDIERROR_NOT_A_CABINET = 2;
    FDIERROR_UNKNOWN_CABINET_VERSION = 3;
    FDIERROR_CORRUPT_CABINET = 4;
    FDIERROR_ALLOC_FAIL = 5;
    FDIERROR_BAD_COMPR_TYPE = 6;
    FDIERROR_MDI_FAIL = 7;
    FDIERROR_TARGET_FILE = 8;
    FDIERROR_RESERVE_MISMATCH = 9;
    FDIERROR_WRONG_CABINET = 10;
    FDIERROR_USER_ABORT = 11;
    fdintCABINET_INFO = 0;              // General information about cabinet
    fdintPARTIAL_FILE = 1;              // First file in cabinet is continuation
    fdintCOPY_FILE = 2;                 // File to be copied
    fdintCLOSE_FILE_INFO = 3;           // close the file, set relevant info
    fdintNEXT_CABINET = 4;              // File continued to next cabinet
    fdintENUMERATE = 5;                 // Enumeration status


type
  perf = ^terf;
  terf = record
          erfOper,erfType:integer;
          fError:longbool;
         end;

  PFDICABINETINFO = ^TFDICABINETINFO;
  TFDICABINETINFO = record
        cbCabinet:longint;              // Total length of cabinet file
        cFolders:smallint;              // Count of folders in cabinet
        cFiles:smallint;                // Count of files in cabinet
        setID:smallint;                 // Cabinet set ID
        iCabinet:smallint;              // Cabinet number in set (0 based)
        fReserve:integer;               // TRUE => RESERVE present in cabinet
        hasprev:integer;                // TRUE => Cabinet is chained prev
        hasnext:integer;                // TRUE => Cabinet is chained next
       end;

  PFDINOTIFICATION = ^TFDINOTIFICATION;
  TFDINOTIFICATION = record
    cb:longint;
    psz1:pchar;
    psz2:pchar;
    psz3:pchar;                       // Points to a 256 character buffer
    pv:pointer;                       // Value for client
    hf:integer;
    date:smallint;
    time:smallint;
    attribs:smallint;
    setID:smallint;                   // Cabinet set ID
    iCabinet:smallint;                // Cabinet number (0-based)
    iFolder:smallint;                 // Folder number (0-based)
    FDIERROR:integer;
  end;



function CabExtract(cabfile,targetdir:string):integer;

implementation


var
 doExtract:boolean;
 doRelative:boolean;
 doExtractPath:string;


function ExpandFileName(const FileName: pchar): string;
var
  FName: PChar;
  Buffer: array[0..MAX_PATH - 1] of Char;
begin
  SetString(Result, Buffer, GetFullPathName(FileName, SizeOf(Buffer),
    Buffer, FName));
end;

function StrPas(const Str: PChar): string;
begin
  Result := Str;
end;

function ExtractFileDir( FileName: string): string;
begin
  result:='';
  while pos('\',filename)>0 do
   begin
    result:=result+copy(filename,1,pos('\',filename));
    system.delete(filename,1,pos('\',filename));
   end;
end;

function ExtractFileName( FileName: string): string;
begin
  while pos('\',filename)>0 do delete(filename,1,pos('\',filename));
  result:=filename;
end;

function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;


function FdiNotification(fdint:integer; notif :PFDINOTIFICATION):integer; cdecl;
var
 FileTime:TFileTime;
 subdir:string;
begin
  result:=0;

  case fdint of
    fdintCABINET_INFO : begin
        {$IFDEF TMSDEBUG}
        outputdebugstring('cabinet info');
        {$ENDIF}
        end;
    fdintPARTIAL_FILE : begin
        {$IFDEF TMSDEBUG}
        outputdebugstring('partial file');
        {$ENDIF}
        end;
    fdintCOPY_FILE : begin

        {$IFDEF TMSDEBUG}
        outputdebugstring('copy file');
        outputdebugstring(notif^.psz1);
        {$ENDIF}

        if doExtract then
         begin
          if doRelative then
           subdir:=extractfiledir(expandfilename(notif^.psz1))
          else
           subdir:=doExtractPath+extractfiledir(notif^.psz1);

          if not DirectoryExists(subdir) then
             begin
              CreateDirectory(PChar(subdir), nil);
             end;

          result:=_lcreat(pchar(doExtractPath+strpas(notif^.psz1)),0);
         end
        else
        result:=0; {skip}

      end;
    fdintCLOSE_FILE_INFO :
      begin
       {$IFDEF TMSDEBUG}
       outputdebugstring('close file');
       {$ENDIF}
       if doExtract then
        begin
         DosDateTimeToFileTime(Word(notif^.Date), Word(notif^.Time), FileTime);
         SetFileTime(notif^.hf, nil, nil, @FileTime);
         _lclose(notif^.hf);
        end;

       Result:=1;
      end;
    fdintNEXT_CABINET :
      begin
       {$IFDEF TMSDEBUG}
       outputdebugstring('next cabinet');
       {$ENDIF}
      end;
    fdintENUMERATE :
      begin
       {$IFDEF TMSDEBUG}
       outputdebugstring('enumerate');
       {$ENDIF}
      end;
  end;
end;

function StdFdiOpen (pszFile : PChar; pmode : Integer): Integer; cdecl;
begin
  {$IFDEF TMSDEBUG}
  outputdebugstring('open call');
  {$ENDIF}
  Result:=_lopen(pszFile, pmode);
end;

function StdFdiRead (hf : Integer; memory : pointer; cb : integer) : integer; cdecl;
begin
  {$IFDEF TMSDEBUG}
  outputdebugstring('read call');
  {$ENDIF}
  Result:=_lread(hf,memory,cb);
end;

function StdFdiWrite (hf : Integer; memory : pointer; cb : integer) : integer; cdecl;
begin
  {$IFDEF TMSDEBUG}
  outputdebugstring('write call');
  {$ENDIF}
  Result:=_lwrite(hf, memory, cb);
end;

function StdFdiClose (hf : Integer) : Integer; cdecl;
begin
  {$IFDEF TMSDEBUG}
  outputdebugstring('close call');
  {$ENDIF}
  Result:=_lclose(hf);
end;

function StdFdiSeek (hf : Integer; dist : Longint; seektype : Integer) : Longint; cdecl;
begin
  {$IFDEF TMSDEBUG}
  outputdebugstring('seek call');
  {$ENDIF}
  Result:=_llseek(hf, dist, seektype);
end;

function StdFdiAlloc (cb : longint) : pointer; cdecl;
begin
 GetMem(Result, cb);
end;

function StdFdiFree (memory : pointer) : Pointer; cdecl;
begin
  FreeMem(memory);
  Result:=nil;
end;

function CabExtract(cabfile,targetdir:string):integer;
var
  hfdi:thandle;
  hf:integer;
  IsCab:bool;
  cabinetDLL:THandle;
  cablib:thandle;
  cabname,cabpath:string;
  erf:terf;
  FDICABINETINFO:TFDICABINETINFO;

  _FDICreate:function(pfnalloc,pfnfree,pfnopen,pfnread,pfnwrite,
                      pfnclose,pfnseek:pointer;
                      cpuType:integer;PERF:perf): thandle; cdecl;
  _FDIDestroy:function(hfdi:thandle): bool; cdecl;
  _FDIIsCabinet:function(hfdi:thandle; hf:integer;PFDIINFO:PFDICABINETINFO):bool; cdecl;
  _FDICopy:function(hfdi:thandle;pszCabinet,pszCabPath:pchar;flags:integer;
                    pfnfdin,pfnfdid:pointer;pvUser:pointer) : bool; cdecl;

begin
  Result := -1;

  hf :=_lopen(pchar(cabfile),OF_READ);
  if (hf <> integer(HFILE_ERROR)) then
    _lclose(hf)
  else
    Exit;

  cablib := LoadLibrary(cabdll);
  if (cablib = 0) then
    Exit;

  cabinetdll:=GetModuleHandle(cabdll);

  if (CabinetDLL>0) then
  begin
    @_FDICreate := GetProcAddress(CabinetDLL,'FDICreate');
    @_FDIIsCabinet := GetProcAddress(CabinetDLL,'FDIIsCabinet');
    @_FDICopy := GetProcAddress(CabinetDLL,'FDICopy');
    @_FDIDestroy := GetProcAddress(CabinetDLL,'FDIDestroy');

    doExtractPath:=targetdir;

    hfdi := _FDICreate(@StdFdiAlloc,@StdFdiFree,
                     @StdFdiOpen,@StdFdiRead,@StdFdiWrite,@StdFdiClose,@StdFdiSeek,1,@erf);

    {$IFDEF TMSDEBUG}
    outputdebugstring(pchar(cabfile));
    {$ENDIF}

    hf:=_lopen(pchar(cabfile),OF_READ);
    IsCab:=_FDIIsCabinet(hfdi,hf,@FDICABINETINFO);
    _lclose(hf);

    if IsCab then
    begin
      {$IFDEF TMSDEBUG}
      outputdebugstring(pchar('cabinet size = '+inttostr(FDICABINETINFO.cbCabinet)));
      outputdebugstring(pchar('cabinet folders = '+inttostr(FDICABINETINFO.cFolders)));
      outputdebugstring(pchar('cabinet files = '+inttostr(FDICABINETINFO.cFolders)));
      {$ENDIF}

      doExtract := True;
      doRelative := Targetdir='';

      cabname := ExtractFileName(cabfile);
      cabpath := ExtractFileDir(expandfilename(pchar(cabfile)))+'\';

      {$IFDEF TMSDEBUG}
      outputdebugstring(pchar(cabname));
      outputdebugstring(pchar(cabpath));
      {$ENDIF}

      if _FDICopy(hfdi,pchar(cabname),pchar(cabpath),0,@FdiNotification,nil,nil) then
        Result := 0
      else
        Result := -1;
   end;

   {$IFDEF TMSDEBUG}
   if _FDIDestroy(hfdi) then
   begin
     Result := 0;
     outputdebugstring(' destroy ok ')
   end
   else
   begin
     Result := -1;
     outputdebugstring('destroy fail');
   end;
   {$ELSE}
   if _FDIDestroy(hfdi) and (result=0) then
     Result := 0
   else
     Result := -1;
   {$ENDIF}
  end
  else
    Result:=-1;

  FreeLibrary(cablib);
end;




end.
