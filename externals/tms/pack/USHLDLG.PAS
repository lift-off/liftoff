{********************************************************************
SHELLDLG components
for Delphi 2.0, 3.0, 4.0, 5.0 & C++Builder 1.0, 3.0
version 1.4

written by 
   TMS Software
   copyright © 1998-1999
   Email : info@tmssoftware.com
   Website : http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The source
code remains property of the author and may not be distributed
freely as such.
********************************************************************}
unit ushldlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Controls, shellapi, forms;

const
  SHFD_CAPACITY_DEFAULT = 0;    // default drive capacity
  SHFD_CAPACITY_360 = 3;        // 360KB, applies to 5.25" drives only
  SHFD_CAPACITY_720 = 5;        // 720KB, applies to 3.5" drives only

  SHFD_FORMAT_FULL_NT = 0;      // full format
  SHFD_FORMAT_QUICK_NT = 1;     // quick format

  SHFD_FORMAT_QUICK_95 = 0;     // quick format
  SHFD_FORMAT_FULL_95 = 1;      // full format
  SHFD_FORMAT_SYSONLY_95 = 2;   // copies system files only

type
 TFormatType = (fmQuick,fmFull, fmSysOnly);
 TFormatCapacity = (fcDefault,fc360k,fc720k);

 TRunDialog = class(TComponent)
 private
   FTitle:string;
   FPrompt:string;
   FShowLast:boolean;
 public
   function Execute:integer;
 published
   property Title:string read FTitle write FTitle;
   property Prompt:string read FPrompt write FPrompt;
   property ShowLastPrompt:boolean read FShowLast write FShowLast;
 end;


 TShutDownDialog = class(TComponent)
 private
   FDefaultShutDown:integer;
 public
   function Execute:integer;
 published
   property DefaultShutDown:integer read FDefaultShutDown write FDefaultShutDown;
 end;

 TChangeIconDialog = class(TComponent)
 private
   Ffilename:string;
   FIdx:integer;
   function GetIconHandle:thandle;
 public
   function Execute:integer;
   property IconHandle:tHandle read GetIconHandle;
 published
   property FileName:string read Ffilename write Ffilename;
   property IconIndex:integer read FIdx write FIdx;
 end;

 TFormatDialog = class(TComponent)
 private
   FDrive:integer;
   FCapacity:TFormatCapacity;
   FType:TFormatType;
 public
   function Execute:integer;
 published
   property Drive:integer read FDrive write FDrive;
   property Capacity:TFormatCapacity read FCapacity write FCapacity;
   property FormatType:TFormatType read FType write FType;
 end;

Function SHShutDownDialog(YourGuess:integer):longint; stdcall;
Function SHRunDialog(hOwner:thandle;Unknown1:integer;Unknown2:pointer;szTitle,szPrompt:pchar;uiFlags:integer):integer; stdcall;
Function SHFormatDrive(hOwner:thandle;iDrive,iCapacity,iFormatType:integer):integer; stdcall;
Function SHChangeIconDialog(hOwner:thandle;szFileName:pchar;reserved:integer;var lpIconIndex:integer):integer; stdcall;

implementation
{$WARNINGS OFF}
Function SHShutDownDialog; external 'shell32.dll' index 60;
Function SHRunDialog; external 'shell32.dll' index 61;
Function SHChangeIconDialog; external 'shell32.dll' index 62;
Function SHFormatDrive; external 'shell32.dll' name 'SHFormatDrive';
{$WARNINGS ON}
function TRunDialog.Execute;
const
 ShowL:array[boolean] of integer = (2,0);
var
 szTitle,szPrompt:array[0..255] of char;
begin
 strpcopy(szTitle,FTitle);
 strpcopy(szPrompt,FPrompt);
 result:=SHRunDialog((owner as twincontrol).handle,0,nil,szTitle,szPrompt,ShowL[FShowLast]);
end;

function TShutDownDialog.Execute;
begin
 result:=SHShutDownDialog(FDefaultShutdown);
end;

function TChangeIconDialog.Execute;
var
 szFilename:array[0..255] of char;
begin
 strpcopy(szFileName,fFileName);
 result:=SHChangeIconDialog((owner as twincontrol).handle,szFileName,0,FIdx);
 if (result<>0) then
   begin
    fFileName:=strpas(szFileName);
    result:=idOk;
   end;
end;

function TChangeIconDialog.GetIconHandle;
begin
 result:=extracticon(application.handle,pchar(fFilename),fidx);
end;

function TFormatDialog.Execute;
const
 Capac:array[TFormatCapacity] of integer = (0,3,5);
 Type95:array[TFormatType] of integer = (SHFD_FORMAT_QUICK_95,SHFD_FORMAT_FULL_95,SHFD_FORMAT_SYSONLY_95);
 TypeNT:array[TFormatType] of integer = (SHFD_FORMAT_FULL_NT,SHFD_FORMAT_QUICK_NT,SHFD_FORMAT_QUICK_NT);
var
 osv:TOSVersionInfo;

begin
 osv.dwOSVersionInfoSize :=Sizeof(osv);
 GetVersionEx(osv);
 if (osv.dwPlatformId = VER_PLATFORM_WIN32_NT) then
   result:=SHFormatDrive((owner as twincontrol).handle,FDrive,Capac[FCapacity],TypeNT[FType])
 else
   result:=SHFormatDrive((owner as twincontrol).handle,FDrive,Capac[FCapacity],Type95[FType]);
end;



end.
