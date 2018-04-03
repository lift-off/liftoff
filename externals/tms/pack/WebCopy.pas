{*******************************************************************}
{ TWEBCOPY component                                                }
{ for Delphi 3,4,5,6 - C++Builder 3,4,5,6                           }
{ version 1.4 - March 2002                                          }
{                                                                   }
{ written by                                                        }
{    TMS Software                                                   }
{    copyright © 2000-2002                                          }
{    Email : info@tmssoftware.com                                   }
{    Web   : http://www.tmssoftware.com                             }
{                                                                   }
{ Added network file transfer capability                            }
{    by David Di Certo - ddicerto@pingnet.ch                        }
{                                                                   }
{ The source code is given as is. The author is not responsible     }
{ for any possible damage done due to the use of this code.         }
{ The component can be freely used in any application. The source   }
{ code remains property of the writer and may not be distributed    }
{ freely as such.                                                   }
{*******************************************************************}

unit WebCopy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinInet,  ComCtrls, StdCtrls, ShellApi;

{$R WEBCOPY.RES}
{$I TMSDEFS.INC}

const
  errFilesIdentical = 0;
  errCannotOpenSourceFile = 1;
  errSourceFileZeroLength = 2;
  errCannotCreateTargetFile = 3;
  errCopyReadFailure = 4;
  errCopyWriteFailure = 5;
  errCannotConnect = 6;

type
  TWebCopy = class;

  TWCopyThread = class(TThread)
  private
    webcopy: TWebCopy;
  protected
    procedure Execute; override;
  public
    constructor Create(AWebCopy: TWebCopy);
  end;

  TWebCopyURLNotFound = procedure(Sender:TObject;url:string) of object;
  TWebCopyError = procedure(Sender:TObject;ErrorCode:longint) of object;
  TWebCopyErrorInfo = procedure(Sender:TObject;ErrorCode:longint;ErrorInfo:string) of object;
  TWebCopyThreadDone = procedure(Sender:TObject) of object;
  TWebCopyCancel = procedure(Sender:TObject) of object;
  TWebCopyFileDone = procedure(Sender:TObject;idx:integer) of object;
  TWebCopyFileStart = procedure(Sender:TObject;idx:integer) of object;
  TWebCopyFileDateCheck = procedure(Sender:TObject;idx: Integer;newdate: TDateTime;allow:boolean) of object;
  TWebCopyConnectError = procedure(Sender: TObject) of object;
  TWebCopyProtocol = (wpHttp,wpFtp,wpFile,wpFtpUpload,wpHttpUpload);
  TWebCopyHTTPCommand = (hcPost,hcPut);
  TWebCopyOverwrite = procedure(Sender:TObject;tgtfile:string;var allow:boolean) of object;
  TWebCopyProgress = procedure(Sender:TObject;fileidx:integer;size,totsize:integer) of object;
  TWebCopyNoNewFile = procedure(Sender:TObject;tgtfile:string;curdate,newdate:TDateTime) of object;

  TWebCopyItem = class(TCollectionItem)
  private
    FURL: string;
    FTargetDir: string;
    FTargetFilename: string;
    FProtocol: TWebCopyProtocol;
    FHTTPCommand: TWebCopyHTTPCommand;
    FFTPHost: string;
    FFTPUserID: string;
    FFTPPassword: string;
    FFTPPort: Integer;
    FActive: Boolean;
    FSuccess: Boolean;
    FCopyNewerOnly: Boolean;
    FFileDate: TDateTime;
    FNoNewVersion: Boolean;
    FNewFileDate: TDateTime;
  public
    constructor Create(Collection: TCollection); override;
    property Success: Boolean read FSuccess;
    property NoNewVersion: Boolean read FNoNewVersion;
    property NewFileDate: TDateTime read FNewFileDate write FNewFileDate;
  published
    property Active: Boolean read FActive write FActive default True;
    property CopyNewerOnly: Boolean read FCopyNewerOnly write FCopyNewerOnly default False;
    property FileDate: TDateTime read FFileDate write FFileDate;
    property FTPHost: string read FFTPHost write FFTPHost;
    property FTPUserID: string read FFTPUserID write FFTPUserID;
    property FTPPassword: string read FFTPPassword write FFTPPassword;
    property FTPPort: Integer read FFTPPort write FFTPPort;
    property HTTPCommand: TWebCopyHTTPCommand read FHTTPCommand write FHTTPCommand;
    property Protocol: TWebCopyProtocol read FProtocol write FProtocol;
    property TargetDir: string read FTargetDir write FTargetDir;
    property TargetFilename: string read FTargetFilename write FTargetFilename;
    property URL: string read FURL write FURL;
  end;

  TWebCopyItems = class(TCollection)
  private
    FOwner: TComponent;
    function GetItem(Index: Integer): TWebCopyItem;
    procedure SetItem(Index: Integer; Value: TWebCopyItem);
    function GetActiveItems: integer;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner:TComponent);
    function Add: TWebCopyItem;
    function Insert(Index: Integer): TWebCopyItem;
    property Items[Index: Integer]: TWebCopyItem read GetItem write SetItem;
    property ActiveItems: Integer read GetActiveItems;
  end;

  TWebCopy = class(TComponent)
  private
    { Private declarations }
    FAlwaysOnTop: Boolean;
    FFileNum: Integer;
    FCancelled: Boolean;
    FForm: TForm;
    FFormClosed: Boolean;
    FProgress: TProgressBar;
    FFileLbl: TLabel;
    FSizeLbl: TLabel;
    FRateLbl: TLabel;
    FTimeLbl: TLabel;
    FCancelBtn: TButton;
    FBtnShowFile,FBtnShowFolder: TButton;
    FAnim:TAnimate;
    FLastFile: string;
    FLastDir: string;
    FDlgCaption:string;
    FDlgUpload: string;
    FFileLabel: string;
    FProgressLabel: string;
    FRateLabel: string;
    FTimeLabel: string;
    FProxy: string;
    FProxyUserID: string;
    FProxyPassword: string;
    FItems: TWebCopyItems;
    FHinternet: hinternet;
    FOnError: TWebCopyError;
    FOnErrorInfo: TWebCopyErrorInfo;
    FOnCopyDone: TWebCopyThreadDone;
    FOnFileDone: TWebCopyFileDone;
    FOnFileStart: TWebCopyFileStart;
    FOnConnectError: TWebCopyConnectError;
    FOnURLNotFound: TWebCopyURLNotFound;
    FOnCopyCancel: TWebCopyCancel;
    FOnCopyOverwrite: TWebCopyOverwrite;
    FOnCopyProgress: TWebCopyProgress;
    FShowDialog: Boolean;
    FFileOfLabel: string;
    FFromServerLabel: string;
    FToServerLabel: string;
    FShowOpenFolder: Boolean;
    FShowOpenFile: Boolean;
    FFTPPassive: Boolean;
    FShowTime: Boolean;
    FShowCompletion: Boolean;
    FDlgCompleted: string;
    FDlgDwnload: string;
    FDlgCopying: string;
    FCopyCompleted: Boolean;
    FOnNoNewFile: TWebCopyNoNewFile;
    FDlgCancel: string;
    FDlgOpenFolder: string;
    FDlgOpenFile: string;
    FOnFileDateCheck: TWebCopyFileDateCheck;
    function HttpGetFile(idx: Integer;url,tgtdir,tgtfn:string; UseDate: Boolean; var FileDate: TDateTime;var NoNew: Boolean): Boolean;
    function HttpPutFile(url,tgtdir,tgtfn:string; HttpCommand: TWebCopyHTTPCommand): Boolean;
    function FileGetFile(idx: Integer;FUserid, FPassword, FHost: string; FPort: integer; url, tgtdir,tgtfn: string;
      UseDate: Boolean; var FileDate: TDateTime;var NoNew: Boolean): Boolean;
    function FtpGetFile(idx: Integer;FUserid,FPassword,FHost:string;FPort:Integer;
      URL, TgtDir,TgtFn: string; UseDate: Boolean; var FileDate: TDateTime;var NoNew: Boolean): Boolean;
    function FtpPutFile(idx: Integer;fuserid,fpassword,FHost:string;FPort:Integer;
      URL, TgtDir,TgtFn: string; UseDate: Boolean; var FileDate: TDateTime;var NoNew: Boolean): Boolean;
    function MakeProxyUrl(url:string): string;
    function ExtractServer(url:string): string;
{$IFDEF DELPHI4_LVL}
    function RemoveServer(url:string): string;
{$ENDIF}
    procedure CreateForm;
    procedure DestroyForm;
    procedure ThreadDone(Sender: TObject);
    function NumInetItems: Integer;
  protected
    { Protected declarations }
    procedure CancelClick(Sender:TObject);
    procedure OpenFile(Sender:TObject);
    procedure OpenFolder(Sender:TObject);
  public
    { Public declarations }
    procedure Execute;
    procedure ThreadExecute;
    procedure ThreadExecAndWait;
    procedure DoCopy;
    procedure CancelCopy;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ProgressForm: TForm read FForm;
    property ProgressBar: TProgressBar read FProgress;
    property ProgressFileLabel: TLabel read FFileLbl;
    property ProgressSizeLabel: TLabel read FSizeLbl;
    property ProgressRateLabel: TLabel read FRateLbl;
    property FormClosed: Boolean read FFormClosed write FFormClosed;
  published
    { Published declarations }
    property AlwaysOnTop: Boolean read FAlwaysOnTop write fAlwaysOnTop default False;
    property DlgCancel: string read FDlgCancel write FDlgCancel;
    property DlgCaption: string read FDlgCaption write FDlgCaption;
    property DlgCompleted: string read FDlgCompleted write FDlgCompleted;
    property DlgFileLabel: string read FFileLabel write FFileLabel;
    property DlgFileOfLabel: string read FFileOfLabel write FFileOfLabel;
    property DlgFromServerLabel: string read FFromServerLabel write FFromServerLabel;
    property DlgToServerLabel: string read FToServerLabel write FToServerLabel;
    property DlgProgressLabel: string read FProgressLabel write FProgressLabel;
    property DlgRateLabel: string read FRateLabel write FRateLabel;
    property DlgTimeLabel: string read FTimeLabel write FTimeLabel;
    property DlgCopying: string read FDlgCopying write FDlgCopying;
    property DlgDwnload: string read FDlgDwnload write FDlgDwnload;
    property DlgUpload: string read FDlgUpload write FDlgUpload;
    property DlgOpenFile: string read FDlgOpenFile write FDlgOpenFile;
    property DlgOpenFolder: string read FDlgOpenFolder write FDlgOpenFolder;
    property FTPPassive: Boolean read FFTPPassive write FFTPPassive;
    property Items: TWebCopyItems read FItems write FItems;
    property Proxy: string read FProxy write FProxy;
    property ProxyUserID: string read FProxyUserID write FProxyUserID;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
    property ShowDialog: Boolean read FShowDialog write FShowDialog default True;
    property ShowOpenFile: Boolean read FShowOpenFile write FShowOpenFile default False;
    property ShowOpenFolder: Boolean read FShowOpenFolder write FShowOpenFolder default False;
    property ShowCompletion: Boolean read FShowCompletion write FShowCompletion default False;
    property ShowTime: Boolean read FShowTime write FShowTime default False;
    property OnConnectError: TWebCopyConnectError read FOnConnectError write FOnConnectError;
    property OnCopyCancel: TWebCopyCancel read FOnCopyCancel write FOnCopyCancel;
    property OnCopyDone: TWebCopyThreadDone read FOnCopyDone write FOnCopyDone;
    property OnCopyOverWrite: TWebCopyOverwrite read FOnCopyOverwrite write FOnCopyOverwrite;
    property OnCopyProgress: TWebCopyProgress read FOnCopyProgress write FOnCopyProgress;
    property OnError: TWebCopyError read FOnError write FOnError;
    property OnErrorInfo: TWebCopyErrorInfo read FOnErrorInfo write FOnErrorInfo;
    property OnFileDone: TWebCopyFileDone read FOnFileDone write FOnFileDone;
    property OnFileStart: TWebCopyFileStart read FOnFileStart write FOnFileStart;
    property OnFileDateCheck: TWebCopyFileDateCheck read FOnFileDateCheck write FOnFileDateCheck;
    property OnURLNotFound: TWebCopyURLNotFound read FOnURLNotFound write FOnURLNotFound;
    property OnNoNewFileFound: TWebCopyNoNewFile read FOnNoNewFile write FOnNoNewFile;
  end;


implementation

const
  READBUFFERSIZE = 4096;

{$IFNDEF DELPHI5_LVL}
type
  PInternetBuffersA = ^INTERNET_BUFFERSA;
  PInternetBuffersW = ^INTERNET_BUFFERSW;
  PInternetBuffers = PInternetBuffersA;
  INTERNET_BUFFERSA = record
    dwStructSize: DWORD;      { used for API versioning. Set to sizeof(INTERNET_BUFFERS) }
    Next: PInternetBuffers;   { chain of buffers }
    lpcszHeader: PAnsiChar;   { pointer to headers (may be NULL) }
    dwHeadersLength: DWORD;   { length of headers if not NULL }
    dwHeadersTotal: DWORD;    { size of headers if not enough buffer }
    lpvBuffer: Pointer;       { pointer to data buffer (may be NULL) }
    dwBufferLength: DWORD;    { length of data buffer if not NULL }
    dwBufferTotal: DWORD;     { total size of chunk, or content-length if not chunked }
    dwOffsetLow: DWORD;       { used for read-ranges (only used in HttpSendRequest2) }
    dwOffsetHigh: DWORD;
  end;
  {$IFDEF DELPHI4_LVL}
  {$EXTERNALSYM INTERNET_BUFFERSA}
  {$ENDIF}
  TInternetBuffersA = INTERNET_BUFFERSA;
  LPINTERNET_BUFFERSA = PInternetBuffersA;
  {$IFDEF DELPHI4_LVL}
  {$EXTERNALSYM LPINTERNET_BUFFERSA}
  {$ENDIF}
  INTERNET_BUFFERSW = record
    dwStructSize: DWORD;      { used for API versioning. Set to sizeof(INTERNET_BUFFERS) }
    Next: PInternetBuffers;   { chain of buffers }
    lpcszHeader: PAnsiChar;   { pointer to headers (may be NULL) }
    dwHeadersLength: DWORD;   { length of headers if not NULL }
    dwHeadersTotal: DWORD;    { size of headers if not enough buffer }
    lpvBuffer: Pointer;       { pointer to data buffer (may be NULL) }
    dwBufferLength: DWORD;    { length of data buffer if not NULL }
    dwBufferTotal: DWORD;     { total size of chunk, or content-length if not chunked }
    dwOffsetLow: DWORD;       { used for read-ranges (only used in HttpSendRequest2) }
    dwOffsetHigh: DWORD;
  end;
  {$IFDEF DELPHI4_LVL}
  {$EXTERNALSYM INTERNET_BUFFERSW}
  {$ENDIF}
  TInternetBuffersW = INTERNET_BUFFERSW;
  LPINTERNET_BUFFERSW = PInternetBuffersW;
  {$IFDEF DELPHI4_LVL}
  {$EXTERNALSYM LPINTERNET_BUFFERSW}
  {$ENDIF}
  INTERNET_BUFFERS = INTERNET_BUFFERSA;
{$ENDIF}

{ TWebCopy helper functions }

procedure FileTimeToDateTime(ft: _FileTime; var FTime: TDateTime);
var
  st: _SYSTEMTIME;
begin
  FileTimeToSystemTime(ft,st);

  FTime := EncodeDate(st.wYear,st.wMonth,st.wDay) +
    EncodeTime(st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
end;

procedure SystemTimeToDateTime(st: _SystemTime; var FTime: TDateTime);
begin
  FTime := EncodeDate(st.wYear,st.wMonth,st.wDay) +
    EncodeTime(st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
end;


function URLtoFile(url:string): string;
begin
  while Pos('/',url) > 0 do
    Delete(url,1,Pos('/',url));
  while Pos('\',url) > 0 do
   Delete(url,1,pos('\',url));
  Result := url;
end;

function FileSizeFmt(Size: Integer): string;
begin
  if size < 1000 then
    Result := IntToStr(Size) + ' bytes';
  if (Size >= 1000) and (Size < 1000000) then
    Result := Format('%.2f',[Size/1000])+' Kb';
  if Size >= 1000000 then
    Result := Format('%.2f',[Size/1000000])+' Mb';
end;

function FileSizeFmtSpeed(Size: Integer):string;
begin
  if Size < 1000 then
    Result := IntToStr(Size)+' bytes/sec';
  if (Size >= 1000) and (Size < 1000000) then
    Result := Format('%.2f',[Size/1000])+' Kb/sec';
  if Size >= 1000000 then
    Result := Format('%.2f',[Size/1000000])+' Mb/sec';
end;

function TimeFmt(ticks,cursize,totsize: Integer): string;
var
  secs,mins,hours: Integer;
  ratio: double;
begin

  if cursize > 0 then
  begin
    ratio := ticks;
    ratio := ratio * (totsize - cursize) / cursize;

    ticks := Round(ratio);
    
    {$IFDEF TMSDEBUG}
    outputdebugstring(pchar(inttostr(ticks)+' : '+inttostr(cursize)+' : '+inttostr(totsize)));
    {$ENDIF}

    secs := round(ticks / 1000);
    mins := round(secs / 60);
    hours := round(mins / 60);

    if (mins = 0) and (hours = 0) then
    begin
      Result := IntToStr(secs)+ ' sec.';
    end
    else
    begin
      if hours > 0 then
      begin
        Result := IntToStr(mins div 60)+'h '+IntToStr(mins mod 60);
      end
      else
      begin
        Result := IntToStr(mins)+' minutes';
      end;
    end;
  end;
end;

function AddFileToDir(Dir,fn:string):string;
begin
  if Length(Dir) > 0 then
  begin
    if Dir[Length(dir)] = '\' then
      Result := dir + fn
    else
      Result := dir + '\' + fn;
  end
  else
    Result := fn;
end;

function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function ForceDirectories(Dir: string): Boolean;
begin
  Result := True;
  if Length(Dir) = 0 then
    raise Exception.Create('Cannot create directory');

  if Dir[length(Dir)] = '\' then
    Delete(Dir,length(Dir),1);

  if (Length(Dir) < 3) or DirectoryExists(Dir)
    or (ExtractFilePath(Dir) = Dir) then Exit; // avoid 'xyz:\' problem.
  Result := ForceDirectories(ExtractFilePath(Dir)) and CreateDir(Dir);
end;


function WinInetError(Err: Integer):string;
var
  buf:array[0..255] of Char;
  bufsize:integer;
  hwininet:thandle;
begin
  hwininet := GetModuleHandle('wininet.dll');
  bufsize := SizeOf(buf);
  FormatMessage(FORMAT_MESSAGE_FROM_HMODULE,Pointer(hwininet),Err,0,buf,bufsize,nil);
  Result := StrPas(buf);
end;

{ TWebCopy }

procedure TWebCopy.CancelClick(sender: tobject);
begin
  if Assigned(FOnCopyCancel) then
    FOnCopyCancel(self);
  FCancelled := True;
  FForm.Close;
end;

function TWebCopy.MakeProxyUrl(url:string):string;
begin
  Result := url;
  if (Pos('HTTP://',Uppercase(url)) = 1) and
     (FProxyUserID <> '') and (FProxyPassword <> '') then
  begin
    Delete(url,1,7);
    Result := 'http://' + FProxyUserID + ':' + FProxyPassword + '@' + url;
  end;
end;

function TWebCopy.ExtractServer(url:string): string;
begin
  if Pos('://',UpperCase(url)) > 0 then
    Delete(url,1,Pos('://',url) + 2);

  if Pos('@',UpperCase(url)) > 0 then
    Delete(url,1,Pos('@',url) + 1);

  if Pos('/',url) > 0 then
    url := Copy(url,1,Pos('/',url)-1);

  Result := url;
end;

{$IFDEF DELPHI4_LVL}
function TWebCopy.RemoveServer(url:string): string;
begin
  if Pos('://',UpperCase(url)) > 0 then
    Delete(url,1,Pos('://',url) + 2);

  if Pos('@',UpperCase(url)) > 0 then
    Delete(url,1,Pos('@',url) + 1);

  if Pos('/',url) > 0 then
    Delete(url,1,Pos('/',url)-1);

  Result := url;
end;
{$ENDIF}


function TWebCopy.HttpPutFile(url,tgtdir,tgtfn:string; HttpCommand: TWebCopyHTTPCommand): Boolean;
var
{$IFDEF DELPHI4_LVL}
  buf:array[0..READBUFFERSIZE - 1] of char;
  bufsize:dword;
  lf:file;
  fn,furl,fsrvr:string;
  fsize,totsize:dword;
  hconnect:hinternet;
  hintfile:hinternet;
  lpdword:dword;
  tck:dword;
  bufferin:INTERNET_BUFFERS;
  ErrCode: Integer;
{$ENDIF}
{$IFDEF TMSDEBUG}
  wsize: integer;
{$ENDIF}  

begin
  Result := False;

{$IFDEF DELPHI4_LVL}

  FUrl := url;

  FAnim.ResID := 258;
  FAnim.ResHandle := hinstance;
  FAnim.Active  := True;

  fn:=UrlToFile(url);

  url := MakeProxyURL(url);

  if FItems.Count > 1 then
    FFileLbl.Caption := IntToStr(FFileNum) + ' ' + FFileOfLabel + ' ' + IntToStr(FItems.ActiveItems)+' : '
  else
    FFileLbl.Caption := '';

  FFileLbl.Caption := FFileLabel + ' ' + FFileLbl.Caption + fn + ' ' + FFromServerLabel + ' '  + ExtractServer(url);

  if tgtfn <> '' then
    fn := tgtfn
  else
    fn := URLtoFile(url);

  fn := AddFileToDir(tgtdir,fn);
  if not FileExists(fn) then
    Exit;

  Application.ProcessMessages;

  fsrvr := ExtractServer(url);
  url := RemoveServer(url);

  hconnect := InternetConnect(FHinternet,PChar(fsrvr),INTERNET_DEFAULT_HTTP_PORT,nil,nil,INTERNET_SERVICE_HTTP,0,0);

  if HttpCommand = hcPost then
    hintfile := HttpOpenRequest(HConnect,'POST',PChar(url),nil,nil,nil,INTERNET_FLAG_NO_CACHE_WRITE ,0)
  else
    hintfile := HttpOpenRequest(HConnect,'PUT',PChar(url),nil,nil,nil,INTERNET_FLAG_NO_CACHE_WRITE ,0);

  if hintfile = nil then
  begin
    if Assigned(FOnError) then
      FOnError(Self,errCannotConnect);
    if Assigned(FOnErrorInfo) then
      FOnErrorInfo(Self,errCannotConnect,'Cannot connect to server ' + FSrvr);
    Exit;
  end;

  if hintfile <> nil then
  begin
    AssignFile(lf,fn);
    Reset(lf,1);
    TotSize := FileSize(lf);

    bufsize := READBUFFERSIZE;
    FSize := 0;
    FillChar(bufferin, SizeOf(bufferin),0);
    bufferin.dwStructSize := SizeOf(INTERNET_BUFFERS);
    bufferin.dwBufferTotal := TotSize;

    if not HttpSendRequestEx(hintfile,@bufferin,nil,HSR_INITIATE,0) then
    begin
      ErrCode := GetLastError;
      CloseFile(lf);
      InternetCloseHandle(hintfile);
      InternetCloseHandle(hconnect);
      if Assigned(FOnError) then
        FOnError(Self, ErrCode);
      if Assigned(FOnErrorInfo) then
        FOnErrorInfo(Self,ErrCode, WinInetError(ErrCode));
      Exit;
    end;

    tck := GetTickCount;

    while (bufsize = READBUFFERSIZE) and not FCancelled do
    begin
      BlockRead(lf,buf,READBUFFERSIZE,bufsize);

      if not InternetWriteFile(hintfile,@buf,bufsize,lpdword) then
      begin
        ErrCode := GetLastError;
        if Assigned(FOnError) then
          FOnError(Self, ErrCode);
        if Assigned(FOnErrorInfo) then
          FOnErrorInfo(Self,ErrCode, WinInetError(ErrCode));
        Break;
      end;

      {$IFDEF TMSDEBUG}
      wsize := wsize + lpdword;
      outputdebugstring(PChar('bytes written = '+inttostr(lpdword)+' total  = '+inttostr(wsize)));
      {$ENDIF}

      FSize := FSize + bufsize;

      if lpdword > 0 then
      begin
        FProgress.Position := Round(100 * FSize / lpdword);
        FSizeLbl.Caption := FProgressLabel + ' ' + FileSizeFmt(FSize) + ' ' + DlgFileOfLabel + ' ' + FileSizeFmt(TotSize);
        {$IFDEF TMSDEBUG}
        outputdebugstring(pchar('bytes read = '+inttostr(FSize)+ ' of '+inttostr(totsize)));
        {$ENDIF}
      end
      else
        FSizeLbl.Caption := FProgressLabel + ' ' + FileSizeFmt(FSize);

      if Assigned(FOnCopyProgress) then
        FOnCopyProgress(Self,FFilenum,FSize,TotSize);

      if FShowCompletion then
        FForm.Caption := DlgUpload + ' : ' + IntToStr(FProgress.Position) + '% ' + DlgCompleted;

      FRatelbl.Caption := FRateLabel + ' ' + FileSizeFmtSpeed(Round(FSize/((GetTickCount-tck)+1)*1000));

      FTimeLbl.Caption := FTimeLabel + ' '+ TimeFmt(GetTickCount-tck,FSize,TotSize);

      Application.Processmessages;
    end;

    if not HttpEndRequest(hintfile,nil,0,0) then
    begin
      ErrCode := GetLastError;
      if Assigned(FOnError) then
        FOnError(Self, ErrCode);
      if Assigned(FOnErrorInfo) then
        FOnErrorInfo(Self,ErrCode, WinInetError(ErrCode));
    end;

    CloseFile(lf);

    InternetCloseHandle(hintfile);
    InternetCloseHandle(hconnect);

    Result := FSize = TotSize;
  end;
{$ENDIF}
end;

//-----------------------------
// download files over a HTTP
//-----------------------------
function TWebCopy.HttpGetFile(idx:Integer; url,tgtdir,tgtfn:string;
  UseDate: Boolean; var FileDate: TDateTime; var NoNew: Boolean): Boolean;
var
  buf: array[0..READBUFFERSIZE-1] of char;
  bufsize: DWord;
  lf: file;
  fn,furl: string;
  fsize: DWord;
  hintfile: hinternet;
  lpdwlen,lpdwidx,lpdword,tck: DWord;
  allow: Boolean;
  datebuf: _SYSTEMTIME;
  ftime: TDateTime;

begin
  Result := False;
  NoNew := False;
  FUrl := url;

  fn := UrlToFile(url);

  url := MakeProxyURL(url);

  if FItems.Count > 1 then
    FFileLbl.Caption := IntToStr(FFileNum) + ' ' + FFileOfLabel + ' ' + IntToStr(FItems.ActiveItems) + ' : '
  else
    FFileLbl.Caption := '';

  FFileLbl.Caption := FFileLabel + ' ' + FFileLbl.Caption + fn + ' ' + FFromServerLabel + ' ' + ExtractServer(url);

  Application.Processmessages;

  hintfile := InternetOpenURL(fhinternet,PChar(url),nil,0,INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE,0);
  lpdwlen := 4;
  lpdwidx := 0;

  Application.ProcessMessages;

  if hintfile <> nil then
  begin
    HttpQueryInfo(hintfile,HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER ,@lpdword,lpdwlen,lpdwidx);
    if lpdword >= 300 then
    begin
      InternetCloseHandle(hintfile);
      if Assigned(FOnError) then
        FOnError(Self,lpdword);

      if Assigned(FOnErrorInfo) then
        FOnErrorInfo(Self,lpdword,'Returned http error code '+IntToStr(lpdword));

      {$IFDEF TMSDEBUG}
      outputdebugstring(pchar('Http status : '+inttostr(lpdword)));
      {$ENDIF}
      Exit;
    end;
  end;

  if hintfile = nil then
  begin
    if Assigned(FOnURLNotFound) then
      FOnURLNotFound(Self,url);
    {$IFDEF TMSDEBUG}
    outputdebugstring('could not open file');
    {$ENDIF}
    Exit;
  end;

  if UseDate or Assigned(FOnFileDateCheck) then
  begin
    lpdwlen := SizeOf(datebuf);
    lpdwidx := 0;
    HttpQueryInfo(hintfile,HTTP_QUERY_LAST_MODIFIED or HTTP_QUERY_FLAG_SYSTEMTIME,@datebuf,lpdwlen,lpdwidx);

    SystemTimeToDateTime(datebuf,FTime);
    {$IFDEF TMSDEBUG}
     outputdebugstring(pchar(formatdatetime('dd/mm/yyyy hh:nn:ss',ftime)));
    {$ENDIF}

    if Assigned(FOnFileDateCheck) then
    begin
      allow := true;
      FileDate := FTime;
      FOnFileDateCheck(Self,idx,ftime,allow);
      if not allow then
      begin
        InternetCloseHandle(hintfile);
        Exit;
      end;
    end
    else
      if ftime <= FileDate then
      begin
        NoNew := True;
        FileDate := FTime;

        InternetCloseHandle(hintfile);

        if Assigned(FOnNoNewFile) then
          FOnNoNewFile(Self,fn,FileDate,FTime);

        Exit;
      end;
    FileDate := FTime;
  end;

  if tgtfn <> '' then
    fn := tgtfn
  else
    fn := URLtoFile(url);

  fn := AddFileToDir(tgtdir,fn);

  FLastFile := fn;
  FLastDir := tgtdir;

  if FileExists(fn) then
  begin
    Allow := True;
    if Assigned(FOnCopyOverwrite) then
      FOnCopyOverwrite(self,fn,allow);

    if not Allow then
    begin
      InternetCloseHandle(hintfile);
      Exit;
    end;
  end;

  ForceDirectories(ExtractFilePath(fn));

  AssignFile(lf,fn);
  {$i-}
  Rewrite(lf,1);
  {$i+}
  if IOResult <> 0 then
  begin
    InternetCloseHandle(hintfile);

    if Assigned(FOnError) then
      FOnError(Self,errCannotCreateTargetFile);
    if Assigned(FOnErrorInfo) then
      FOnErrorInfo(Self,errCannotCreateTargetFile,'Cannot create file '+fn);

    Exit;
  end;

  bufsize := READBUFFERSIZE;

  lpdword:=0;
  lpdwlen:=4;
  lpdwidx:=0;

  HttpQueryInfo(hintfile,HTTP_QUERY_CONTENT_LENGTH or HTTP_QUERY_FLAG_NUMBER ,@lpdword,lpdwlen,lpdwidx);

  FSize := 0;

  tck := GetTickCount;
  bufsize := READBUFFERSIZE;

  while (bufsize > 0) and not FCancelled do
  begin
    Application.Processmessages;
    if not InternetReadFile(hintfile,@buf,READBUFFERSIZE,bufsize) then Break;

    {$IFDEF TMSDEBUG}
    outputdebugstring(pchar('read from http = '+inttostr(bufsize)));
    {$ENDIF}

    if (bufsize > 0) and (bufsize <= READBUFFERSIZE) then
      BlockWrite(lf,buf,bufsize);

    FSize := FSize + bufsize;

    if lpdword > 0 then
    begin
      FProgress.Position := Round(100 * FSize / lpdword);
      FSizelbl.Caption := FProgressLabel + ' ' + FileSizeFmt(FSize)+ ' ' +DlgFileOfLabel +' ' +FileSizeFmt(lpdword);
    end
    else
      FSizelbl.Caption := FProgressLabel + ' ' + FileSizeFmt(FSize);

    if Assigned(FOnCopyProgress) then
      FOnCopyProgress(Self,FFilenum,FSize,lpdword);

    if FShowCompletion then
      FForm.Caption := DlgDwnload + ' : ' + IntToStr(FProgress.Position) + '% ' + DlgCompleted;

    FRateLbl.Caption := FRateLabel + ' '+FileSizeFmtSpeed(Round(FSize/((GetTickCount-tck)+1)*1000));
    FTimeLbl.Caption := FTimeLabel + ' '+ TimeFmt(GetTickCount-tck,FSize,lpdword);

    Application.Processmessages;

    if bufsize > 0 then
      Result := True;
  end;

  CloseFile(lf);

  if FCancelled then
    Deletefile(fn);

  InternetCloseHandle(hintfile);
end;

//-----------------------
// copy files over a LAN
//-----------------------
function TWebCopy.FileGetFile(idx: Integer;fuserid, fpassword, fhost: string; fPort: integer;
  url, tgtdir,tgtfn: string; UseDate: Boolean; var FileDate: TDateTime;var NoNew: Boolean): Boolean;
const
  BlockSize = $4000;
type
  pBuf = ^tBuf;
  TBuf = array[1..BlockSize] of char;

var
  SourceSize: LongInt;
  sour: tFileRec;
  targ: tFileRec;
  numRead, numWritten: integer;
  fbuf: pBuf;
  fsize: integer;
  tck: dword;
  NetResource: TNetResource;
  dwFlags: DWORD;
  source, dest: string;
  allow:boolean;
  crT,laT,lwT: _FileTime;
  FTime: TDateTime;

label
  CleanExit;

begin
  NoNew := False;
  Result := False;

  FAnim.CommonAVI := aviCopyFiles;
  FAnim.Active  := True;

  if FItems.Count > 1 then
    FFileLbl.Caption := IntToStr(FFileNum) + ' ' + FFileOfLabel + ' ' + IntToStr(FItems.ActiveItems) + ' : '
  else
    FFileLbl.Caption := '';

  if FHost <> '' then
    FFileLbl.Caption := FFileLabel + ' ' + FFileLbl.Caption + URLToFile(url) + ' '+FFromServerLabel+' ' + FHost
  else
    FFileLbl.Caption := FFileLabel + ' ' + FFileLbl.Caption + URLToFile(url) + ' '+FFromServerLabel+' ' + ExtractFileDir(URL);


  if FHost <> '' then
  begin
    NetResource.dwType := RESOURCETYPE_DISK;
    NetResource.lpLocalName := '';
    NetResource.lpRemoteName := PChar(fHost);
    NetResource.lpProvider := '';
    dwFlags := 0;
    if WNetAddConnection2(NetResource, PChar(fpassword), PChar(fuserid),
                          dwFlags) <> NO_ERROR then
        begin
         if Assigned(FOnConnectError) then
           FOnConnectError(self);
         goto CleanExit;
        end;
  end;

  FSize := 0;
  tck := GetTickCount;

  if FHost <> '' then
    Source := FHost + '\' + url
  else
    Source := url;

  if tgtfn <> '' then
    dest := tgtfn
  else
    dest := URLtoFile(url);

  dest := AddFileToDir(tgtdir,dest);

  FLastFile := dest;
  FLastDir := tgtdir;

   // if source file and target file are identical raises an error
  if source = dest then
  begin
    if Assigned(OnError) then
      OnError(Self,errFilesIdentical);
    if Assigned(OnErrorInfo) then
      OnErrorInfo(Self,errFilesIdentical,'Cannot copy identical files '+Source);
    goto CleanExit;
  end;

  new(FBuf);

  // tries to open the source file
  Sour.Handle := FileOpen(Source, fmOpenRead);
  if Sour.handle = -1 then
  begin
    Dispose(FBuf);
    if Assigned(OnError) then
       OnError(Self,errCannotOpenSourceFile);
    if Assigned(OnErrorInfo) then
       OnErrorInfo(Self,errCannotOpenSourceFile,'Cannot open source file '+Source);

    goto CleanExit;
  end;

  if UseDate or Assigned(FOnFileDateCheck) then
  begin
    GetFileTime(sour.Handle,@crT,@laT,@lwT);

    FileTimeToDateTime(lwT,FTime);

    if Assigned(OnFileDateCheck) then
    begin
      allow := true;
      FOnFileDateCheck(Self,idx,ftime,allow);
      if not Allow then
      begin
        Dispose(FBuf);
        FileClose(Sour.Handle);
        Exit;
      end;
    end
    else
      if FTime <= FileDate then
      begin
        NoNew := True;
        FileDate := FTime;

        Dispose(FBuf);
        FileClose(Sour.Handle);

        if Assigned(FOnNoNewFile) then
          FOnNoNewFile(Self,Source,FileDate,FTime);
        Exit;
      end;
    FileDate := FTime;
  end;

  // compute how many block are needed
  SourceSize := FileSeek(Sour.handle, 0, 2);
  if SourceSize = -1 then
  begin
    Dispose(FBuf);
    FileClose(Sour.Handle);
    if Assigned(OnError) then
      OnError(Self,errSourceFileZeroLength);
    if Assigned(OnErrorInfo) then
      OnErrorInfo(Self,errSourceFileZeroLength,'Zero length source file '+Source);

    goto CleanExit;
  end;

  // set the handle to the file beginning
  FileSeek(Sour.handle, 0, 0);

  if FileExists(dest) then
  begin
    Allow := True;
    if Assigned(FOnCopyOverwrite) then
      FOnCopyOverwrite(self,dest,allow);
    if not Allow then
    begin
      Dispose(FBuf);
      FileClose(Sour.handle);
      goto CleanExit;
    end;
  end;

  ForceDirectories(ExtractFilePath(Dest));

  // tries to create the target file
  Targ.handle := FileCreate(Dest);

  if Targ.Handle < 0 then
  begin
    FileClose(Sour.Handle);
    Dispose(FBuf);
    if Assigned(OnError) then
      OnError(Self,errCannotCreateTargetFile);
    if Assigned(OnErrorInfo) then
      OnErrorInfo(Self,errCannotCreateTargetFile,'Cannot create target file ' + Dest);
    goto CleanExit;
  end;

  FCancelled := False;

  // copy block
  repeat
    // reading
    numRead := FileRead(Sour.Handle, FBuf^, sizeOf(FBuf^));

    if numRead < 0 then
    begin
      Dispose(FBuf);
      FileClose(Sour.Handle);
      FileClose(Targ.handle);
      if Assigned(OnError) then
        OnError(Self,errCopyReadFailure);
      if Assigned(OnErrorInfo) then
        OnErrorInfo(Self,errCopyReadFailure,'Error reading source file ' + Source);
      goto CleanExit;
    end;

    // writing
    numWritten := FileWrite(Targ.Handle, FBuf^, numRead);
    if numWritten < 0 then
    begin
      Dispose(FBuf);
      FileClose(Sour.Handle);
      FileClose(Targ.handle);
      if Assigned(OnError) then
        OnError(Self,errCopyWriteFailure);
      if Assigned(OnErrorInfo) then
        OnErrorInfo(Self,errCopyWriteFailure,'Error writing to destination file '+Dest);
      goto CleanExit;
    end;

    FSize := FSize + numWritten;
    if Assigned(FOnCopyProgress) then
      FOnCopyProgress(Self,FFileNum,FSize,SourceSize);

    FProgress.Position := Round(100 * FSize/SourceSize);
    FSizeLbl.Caption := FProgressLabel + ' ' + FileSizeFmt(FSize) + ' ' + DlgFileOfLabel + ' ' + FileSizeFmt(Sourcesize);
    FRateLbl.Caption := FRateLabel + ' ' + FileSizeFmtSpeed(Round(FSize / ((GetTickCount - tck) + 1) * 1000));

    if FShowCompletion then
      FForm.Caption := DlgCopying + ' : ' + IntToStr(FProgress.Position) + '% ' + DlgCompleted;

    FTimeLbl.Caption := FTimeLabel + ' '+ TimeFmt(GetTickCount-tck,FSize,SourceSize);

    Application.ProcessMessages;

  until (numRead = 0) or (numRead <> numWritten) or FCancelled;

  FileClose(Sour.Handle);
  FileClose(Targ.handle);
  Dispose(FBuf);

  Result := true;

CleanExit:

  if FHost <> '' then
  begin
    if WNetCancelConnection2(PChar(fhost), CONNECT_UPDATE_PROFILE, true) <> NO_ERROR then
    begin
      if Assigned(FOnConnectError) then
        FOnConnectError(Self);
      Result:=false;
    end;
  end;
end;

//---------------------------
// Get files from FTP server
//---------------------------
function TWebCopy.FtpGetFile(idx: Integer;FUserid,FPassword,FHost:string;FPort:Integer;
  URL, TgtDir,TgtFn: string; UseDate: Boolean;var FileDate:TDateTime; var NoNew: Boolean): Boolean;
var
  hintconnect: hinternet;
  hintfile: hinternet;
  ftpflag: Integer;
  buf: array[0..READBUFFERSIZE-1] of Char;
  bufsize: DWord;
  lf: file;
  fn,fdir: string;
  fsize,tck: DWord;
  lpdword: DWord;
  ffi: TWin32FindData;
  Allow: Boolean;
  FTime: TDateTime;

begin
  Result := False;
  NoNew := False;

  if FItems.Count > 1 then
    FFileLbl.Caption := IntToStr(FFileNum) + ' ' + FFileOfLabel + ' ' + IntToStr(FItems.ActiveItems) + ' : '
  else
    FFileLbl.Caption := '';

  FFileLbl.Caption := FFileLabel + ' ' + FFilelbl.caption + URLToFile(url) + ' ' + FFromServerLabel+' '+FHost;

  if FFTPPassive then
    ftpflag := INTERNET_FLAG_PASSIVE
  else
    ftpflag := 0;

  {$IFDEF TMSDEBUG}
  outputdebugstring(pchar('host:'+FHost));
  outputdebugstring(pchar('userid:'+FUserID));
  outputdebugstring(pchar('pwd:'+FPassword));
  {$ENDIF}

  if (FUserID = '') or (FPassword = '') then
    hintconnect := InternetConnect(FHinternet,PChar(FHost),FPort,nil,nil,INTERNET_SERVICE_FTP,ftpflag,0)
 else
    hintconnect := InternetConnect(FHinternet,PChar(FHost),FPort,PChar(FUserID),PChar(FPassword),INTERNET_SERVICE_FTP,ftpflag,0);

  if hintconnect = nil then
  begin
    if Assigned(FOnError) then
      FOnError(Self,errCannotConnect);
    if Assigned(FOnErrorInfo) then
      FOnErrorInfo(Self,errCannotConnect,'Cannot connect to FTP server ' + FHost);
    Exit;
  end;

  Application.ProcessMessages;

  if Pos('/',url) > 0 then
  begin
    FDir := url;
    while (FDir[Length(FDir)] <> '/') and (Length(FDir) > 0) do
      Delete(FDir,Length(FDir),1);

    if Length(FDir) > 0 then
      FtpSetCurrentDirectory(hintconnect,PChar(FDir));
  end;

  fn := URLtoFile(url);

  if FtpFindFirstFile(hintconnect,PChar(fn),ffi,0,0) = nil then
    lpdword := 0
  else
  begin
    lpdword := ffi.nFileSizeLow;

    if UseDate or Assigned(FOnFileDateCheck) then
    begin
      FileTimeToDateTime(ffi.ftLastWriteTime,FTime);

      {$IFDEF TMSDEBUG}
      outputdebugstring(pchar(formatdatetime('dd/mm/yyyy hh:nn:ss',ftime)));
      {$ENDIF}

      if Assigned(FOnFileDateCheck) then
      begin
        Allow := true;
        FOnFileDateCheck(Self,idx,FTime,allow);
        FileDate := FTime;
        if not Allow then
        begin
          InternetCloseHandle(hintconnect);
          Exit;
        end;
      end
      else
        if FTime <= FileDate then
        begin
          NoNew := True;
          FileDate := FTime;

          InternetCloseHandle(hintconnect);

          if Assigned(FOnNoNewFile) then
            FOnNoNewFile(Self,fn,FileDate,FTime);
          Exit;
        end;
      FileDate := FTime;
    end;
  end;

  Application.ProcessMessages;

  hintfile := FtpOpenFile(hintconnect,PChar(fn),GENERIC_READ,FTP_TRANSFER_TYPE_BINARY,0);

  Application.ProcessMessages;

  if hintfile = nil then
  begin
    if Assigned(FOnURLNotFound) then
      FOnURLNotFound(Self,url);
    InternetCloseHandle(hintconnect);
    Exit;
  end;

  if tgtfn <> '' then
    fn := tgtfn
  else
    fn := URLtoFile(url);

  fn := AddFileToDir(tgtdir,fn);

  FLastFile := fn;
  FLastDir := tgtdir;


  if FileExists(fn) then
  begin
    Allow := True;
    if Assigned(FOnCopyOverwrite) then
      FOnCopyOverwrite(Self,fn,Allow);
    if not Allow then
    begin
      InternetCloseHandle(hintconnect);
      InternetCloseHandle(hintfile);
      Exit;
    end;
  end;

  AssignFile(lf,fn);
  {$i-}
  Rewrite(lf,1);
  {$i+}

  if IOResult <> 0 then
  begin
    InternetCloseHandle(hintconnect);
    InternetCloseHandle(hintfile);
    if Assigned(FOnError) then
      FOnError(Self,errCannotCreateTargetFile);
    if Assigned(FOnErrorInfo) then
      FOnErrorInfo(Self,errCannotCreateTargetFile,'Cannot create target file '+fn);
    Exit;
  end;

  bufsize := READBUFFERSIZE;

  FSize := 0;

  FCancelled := False;

  tck := GetTickCount;

  bufsize := READBUFFERSIZE;
  while (bufsize > 0) and not FCancelled  do
  begin
    Application.ProcessMessages;
    if not InternetReadFile(hintfile,@buf,READBUFFERSIZE,bufsize) then Break;
    {$IFDEF TMSDEBUG}
    outputdebugstring(pchar('read from ftp = '+inttostr(bufsize)));
    {$ENDIF}
    if (bufsize > 0) and (bufsize <= READBUFFERSIZE) then
      BlockWrite(lf,buf,bufsize);

    FSize := FSize + bufsize;


    if lpdword > 0 then
    begin
      FProgress.Position := Round(100 * FSize / lpdword);
      FSizeLbl.Caption := FProgressLabel + ' ' + FileSizeFmt(FSize) + ' ' + DlgFileOfLabel + ' '+ FileSizeFmt(lpdword);
    end
    else
      FSizeLbl.Caption := FProgressLabel + ' ' + FileSizeFmt(FSize);

    if Assigned(FOnCopyProgress) then
      FOnCopyProgress(Self,FFilenum,FSize,lpdword);

    if FShowCompletion then
      FForm.Caption := DlgDwnload + ' : ' + IntToStr(FProgress.Position) + '% ' + DlgCompleted;

    FRateLbl.Caption := FRateLabel + ' ' + FileSizeFmtSpeed(Round(FSize/((GetTickCount-tck)+1)*1000));
    FTimeLbl.Caption := FTimeLabel + ' '+ TimeFmt(GetTickCount-tck,FSize,lpdword);
  end;

  Closefile(lf);
  InternetCloseHandle(hintfile);
  InternetCloseHandle(hintconnect);
  Result := True;
end;

//-------------------
// Put files to FTP
//-------------------
function TWebCopy.FtpPutFile(idx: Integer; FUserid,FPassword,FHost:string;FPort: Integer;
  URL, TgtDir,TgtFn: string; UseDate: Boolean;var FileDate: TDateTime; var NoNew: Boolean): Boolean;
var
  hintconnect: hinternet;
  hintfile: hinternet;
  ftpflag: Integer;
  buf: array[0..READBUFFERSIZE-1] of char;
  bufsize,numread: DWord;
  lf: file;
  fn: string;
  FSize,lpdword,tck: DWord;
  ffi: TWin32FindData;
  FTime: TDateTime;
  Allow: Boolean;

begin
  NoNew := False;
  Result := False;
  FAnim.ResID := 258;
  FAnim.ResHandle := hinstance;
  FAnim.Active  := True;

  if FItems.Count>1 then
    FFileLbl.Caption := IntToStr(FFilenum) + ' ' + FFileOfLabel + ' ' + IntToStr(FItems.ActiveItems) + ' : '
  else
    FFileLbl.Caption := '';

  FFileLbl.Caption := FFileLabel + ' ' + FFileLbl.Caption + URLToFile(url) + ' ' + FToServerLabel+' '+Fhost;

  if FFTPPassive then
    ftpflag := INTERNET_FLAG_PASSIVE
  else
    ftpflag := 0;

  {$IFDEF TMSDEBUG}
  outputdebugstring(pchar('host:'+fHost));
  outputdebugstring(pchar('userid:'+fUserID));
  outputdebugstring(pchar('pwd:'+fPassword));
  {$ENDIF}

  if (FUserID = '') or (FPassword = '') then
    hintconnect := InternetConnect(fhinternet,PChar(FHost),FPort,nil,nil,INTERNET_SERVICE_FTP,ftpflag,0)
  else
    hintconnect := InternetConnect(fhinternet,PChar(FHost),FPort,PChar(FUserID),PChar(FPassword),INTERNET_SERVICE_FTP,ftpflag,0);

  if hintconnect = nil then
  begin
    if Assigned(FOnError) then
      FOnError(Self,errCannotConnect);
    if Assigned(FOnErrorInfo) then
      FOnErrorInfo(Self,errCannotConnect,'Cannot connect to FTP server ' + FHost);
    Exit;
  end;

  Application.ProcessMessages;

  // change to directory / create it if used
  if tgtdir <> '' then
  begin
    if not FtpSetCurrentDirectory(hintconnect,PChar(tgtdir)) then
    begin
      if not FtpCreateDirectory(hintconnect,PChar(tgtdir)) then
      begin
        InternetCloseHandle(hintconnect);
        Exit;
      end
      else
        FtpSetCurrentDirectory(hintconnect,PChar(tgtdir));
    end;
  end;

  Application.ProcessMessages;

  //fn:=URLtoFile(url);
  fn := URL;

  if tgtfn = '' then
    tgtfn := URLToFile(url);

  if UseDate or Assigned(FOnFileDateCheck) then
  begin
    if FtpFindFirstFile(hintconnect,PChar(tgtfn),ffi,0,0) <> nil then
    begin
      FileTimeToDateTime(ffi.ftLastWriteTime,FTime);

      {$IFDEF TMSDEBUG}
      outputdebugstring(pchar(formatdatetime('dd/mm/yyyy hh:nn:ss',ftime)));
      {$ENDIF}
      if Assigned(FOnFileDateCheck) then
      begin
        Allow := True;
        FOnFileDateCheck(Self,idx,FTime,Allow);
        FileDate := FTime;
        if not Allow then
        begin
          InternetCloseHandle(hintconnect);
          Exit;
        end;
      end
      else
        if FTime <= FileDate then
        begin
          FileDate := FTime;
          NoNew := True;
          InternetCloseHandle(hintconnect);
          if Assigned(FOnNoNewFile) then
            FOnNoNewFile(Self,tgtfn,FileDate,FTime);
          Exit;
        end;
      FileDate := FTime;
    end;
  end;

  hintfile := FtpOpenFile(hintconnect,PChar(tgtfn),GENERIC_WRITE,FTP_TRANSFER_TYPE_BINARY,0);

  if hintfile = nil then
  begin
    if Assigned(FOnURLNotFound) then
      FOnURLNotFound(self,url);
    InternetCloseHandle(hintconnect);
    Exit;
  end;

  Application.ProcessMessages;

  FLastFile := fn;
  FLastDir := tgtdir;

  AssignFile(lf,fn);
  {$i-}
  Reset(lf,1);
  {$i+}

  lpdword := FileSize(lf);

  if IOResult <> 0 then
  begin
    InternetCloseHandle(hintconnect);
    InternetCloseHandle(hintfile);

    if Assigned(FOnError) then
      FOnError(Self,errCannotOpenSourceFile);
    if Assigned(FOnErrorInfo) then
      FOnErrorInfo(Self,errCannotOpenSourceFile,'Cannot create target file ' + fn);
    Exit;
  end;

  bufsize := READBUFFERSIZE;
  FSize := 0;
  FCancelled := False;
  tck := GetTickCount;

  while (bufsize = READBUFFERSIZE) and not FCancelled  do
  begin
    Application.ProcessMessages;
    BlockRead(lf,buf,bufsize,numread);

    if not InternetWriteFile(hintfile,@buf,numread,bufsize) then Break;
    {$IFDEF TMSDEBUG}
    outputdebugstring(pchar('write from ftp = '+IntToStr(bufsize)));
    {$ENDIF}

    FSize := FSize + bufsize;

    if (lpdword>0) then
    begin
      FProgress.Position := Round(100 * FSize/lpdword);
      FSizeLbl.Caption := FProgressLabel + ' ' + FileSizeFmt(FSize) + ' ' +DlgFileOfLabel + ' ' + FileSizeFmt(lpdword);
    end
    else
      FSizeLbl.Caption := FProgressLabel + ' ' + FileSizeFmt(FSize);

    if Assigned(FOnCopyProgress) then
      FOnCopyProgress(Self,ffilenum,fsize,lpdword);

    if FShowCompletion then
      FForm.Caption := DlgUpload + ' : ' + IntToStr(FProgress.Position) + '% ' + DlgCompleted;

    FRateLbl.Caption := FRateLabel + ' ' + FileSizeFmtSpeed(Round(FSize/((GetTickCount-tck)+1)*1000));
    FTimeLbl.Caption := FTimeLabel + ' '+ TimeFmt(GetTickCount-tck,FSize,lpdword);
  end;

  CloseFile(lf);
  InternetCloseHandle(hintfile);
  InternetCloseHandle(hintconnect);
  Result := True;
end;


constructor TWebCopy.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FItems := TWebCopyItems.Create(self);
  FFileLabel := 'File :';
  FProgressLabel := 'Progress :';
  FRateLabel := 'Transfer rate :';
  FTimeLabel := 'Estimated time left :';
  FDlgCaption := 'Downloading';
  FDlgUpload := 'Uploading';
  FDlgDwnload := 'Downloading';
  FDlgCopying := 'Copying';   
  FDlgCompleted := 'completed';
  FShowDialog := True;
  FFromServerLabel := 'from';
  FToServerLabel := 'to';
  FFileOfLabel := 'of';
  FDlgCancel := 'Cancel';
  FDlgOpenFile := 'Open file';
  FDlgOpenFolder := 'Open folder';
end;

destructor TWebCopy.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TWebCopy.DoCopy;
var
  i: Integer;
  ok: Boolean;
  NoNew: Boolean;
  FDate: TDateTime;
begin
  CreateForm;

  fhinternet := nil;

  if NumInetItems > 0 then
  begin
    if FProxy = '' then
      fhinternet := InternetOpen('WebCopy',INTERNET_OPEN_TYPE_PRECONFIG {or INTERNET_FLAG_ASYNC},nil,nil,0)
    else
      fhinternet := InternetOpen('WebCopy',INTERNET_OPEN_TYPE_PROXY
                    {or INTERNET_FLAG_ASYNC},PChar(FProxy),nil,0);
  end;

  FFileNum := 0;

  for i := 1 to FItems.Count do
  begin
    if FItems.Items[i-1].Active then
    begin
      Inc(FFileNum);
      if Assigned(FOnFileStart) then
        FOnFileStart(Self,i - 1);

      with FItems.Items[i - 1] do
      begin
        ok := False;

        case Protocol of
        wpHttp,wpFtp:FForm.Caption := FDlgDwnload + ' ...';
        wpFile:FForm.Caption := FDlgCopying + ' ...';
        wpHttpUpload,wpFtpUpload:FForm.Caption := FDlgUpload + ' ...';
        end;

        FDate := FileDate;

        case Protocol of
        wpHttp:
          ok := HttpGetFile(i - 1,url,targetdir,targetfilename,CopyNewerOnly,FDate,NoNew);
        wpHttpUpload:
          ok := HttpPutFile(url,targetdir,targetfilename,HTTPCommand);
        wpFile:
          ok := FileGetFile(i - 1,FTPUserID, FTPPassword, FTPHost, FTPPort, URL, Targetdir,TargetFilename,CopyNewerOnly,FDate,NoNew);
        wpFtp:
          ok := FtpGetFile(i - 1,FTPUserID,FTPPassword,FTPHost,FTPPort,URL,TargetDir,TargetFileName,CopyNewerOnly,FDate,NoNew);
        wpFtpUpload:
          ok := FtpPutFile(i - 1,FTPUserID,FTPPassword,FTPHost,FTPPort,URL,TargetDir,TargetFileName,CopyNewerOnly,FDate,NoNew);
        end;
      end;

      FItems.Items[i - 1].NewFileDate := FDate;
      FItems.Items[i - 1].FSuccess := ok and not FCancelled;
      FItems.Items[i - 1].FNoNewVersion := NoNew;

      if FCancelled then
        Break
      else
        if Assigned(FOnFileDone) then
          FOnFileDone(Self,i - 1);
    end;
  end;

  if Assigned(fhinternet) then
    InternetCloseHandle(fhinternet);

  if Assigned(FOnCopyDone) then
    FOnCopyDone(Self);

  if FShowOpenFile or FShowOpenFolder then
  begin
    FCancelBtn.Caption := 'Close';
    FAnim.Active := False;
    if not FCancelled and FShowOpenFile then
      FBtnShowFile.Enabled := True;
    if not FCancelled and FShowOpenFolder then
      FBtnShowFolder.Enabled := True;
  end
  else
  begin
    FForm.Close;
    DestroyForm;
  end;
end;


procedure TWebCopy.CancelCopy;
begin
  FCancelled := True;
end;

procedure TWebCopy.CreateForm;
var
  BtnTop: Integer;
  capdy: Integer;

begin
  FForm := TForm.Create(Self);

  FForm.Width := 300;

  capdy := GetSystemMetrics(SM_CYCAPTION);

  if FShowTime then
  begin
    FForm.Height := 208 + capdy;
    BtnTop := 160;
  end
  else
  begin
    FForm.Height := 188 + capdy;
    BtnTop := 140;
  end;

  FForm.Position := poScreenCenter;
  FForm.Borderstyle := bsDialog;

  FFileLbl := TLabel.Create(FForm);
  FFileLbl.Parent := FForm;

  FFileLbl.Top := 80;
  FFileLbl.Left := 10;
  FFileLbl.Width := FForm.Width - 20;
  FFileLbl.Autosize := False;
  FFileLbl.Caption := FFileLabel;

  FSizeLbl := TLabel.Create(FForm);
  FSizeLbl.Parent := FForm;
  FSizeLbl.Top := 100;
  FSizeLbl.Left := 10;
  FSizeLbl.Caption := FProgressLabel;

  FRateLbl := TLabel.Create(FForm);
  FRateLbl.Parent := FForm;
  FRateLbl.Top := 120;
  FRateLbl.Left := 10;
  FRateLbl.Caption := FRateLabel;

  FTimeLbl := TLabel.Create(FForm);
  FTimeLbl.Parent := FForm;
  FTimeLbl.Top := 140;
  FTimeLbl.Left := 10;
  FTimeLbl.Caption := FTimeLabel;
  FTimeLbl.Visible := FShowTime;

  FAnim := TAnimate.Create(FForm);
  FAnim.Parent := FForm;
  FAnim.Left := 10;
  FAnim.Top := 0;
  FAnim.ResID := 257;
  FAnim.ResHandle := hinstance;
  FAnim.Active  := True;

  FCancelBtn := TButton.Create(FForm);
  FCancelBtn.Parent := FForm;
  FCancelBtn.Top := BtnTop;
  FCancelBtn.Left := FForm.Width - FCancelbtn.width - 10;
  FCancelBtn.Caption := FDlgCancel;
  FCancelBtn.OnClick  := CancelClick;

  if FShowOpenFolder then
  begin
    FBtnshowfolder := TButton.Create(FForm);
    FBtnshowfolder.Parent := FForm;
    FBtnshowfolder.Top := BtnTop;
    FBtnshowfolder.Left := FForm.Width - FCancelBtn.Width - FCancelBtn.Width - 10 - 10;
    FBtnshowfolder.Caption := FDlgOpenFolder;
    FBtnshowfolder.OnClick  := OpenFolder;
    FBtnshowfolder.Enabled := False;
  end;

  if FShowOpenFile then
  begin
    FBtnshowfile := TButton.Create(FForm);
    FBtnshowfile.Parent := FForm;
    FBtnshowfile.Top := BtnTop;
    FBtnshowfile.Left := FForm.Width - FCancelBtn.Width - FCancelBtn.Width - 10 - 10;
    if FShowOpenFolder then
      FBtnshowfile.left := FBtnshowfile.Left - FCancelBtn.Width - 10;
    FBtnshowfile.Caption := FDlgOpenFile;
    FBtnshowfile.OnClick  := OpenFile;
    FBtnshowfile.Enabled := False;
  end;

  FProgress := TProgressBar.Create(FForm);
  FProgress.Parent := FForm;
  FProgress.Top := 60;
  FProgress.Left := 10;
  FProgress.Height := 12;
  FProgress.Width := FForm.Width - 20;

  FFormClosed := false;
  FForm.BorderIcons := [];
  FForm.Caption := FDlgCaption + ' ...';
  FCancelled := False;
  if FShowDialog then
  begin
    FForm.Show;
    if FAlwaysOnTop then
      SetWindowPos(FForm.Handle,HWND_TOPMOST,FForm.Left,FForm.top,FForm.Width,FForm.height,0);
  end;
  FCancelled := False;
end;

procedure TWebCopy.DestroyForm;
begin
  FForm.Free;
end;

procedure TWebCopy.Execute;
begin
  DoCopy;
end;


procedure TWebCopy.ThreadExecute;
begin
  with TWCopyThread.Create(Self) do
    OnTerminate := ThreadDone;
end;

procedure TWebCopy.ThreadDone(Sender:TObject);
begin
  FCopyCompleted := True;
end;

procedure TWebCopy.ThreadExecAndWait;
begin
   FCopyCompleted := False;

   ThreadExecute;
   while not FCopyCompleted do
     Application.ProcessMessages;
end;



procedure TWebCopy.OpenFile(sender: tobject);
begin
  ShellExecute(0,'open',PChar(FLastFile),nil,nil, SW_NORMAL);
  FForm.Close;
  DestroyForm;
  FFormClosed := True;
end;

procedure TWebCopy.OpenFolder(sender: tobject);
begin
  ShellExecute(0,'open',PChar(FLastDir),nil,nil, SW_NORMAL);
  FForm.Close;
  DestroyForm;
  FFormClosed:=true;
end;

function TWebCopy.NumInetItems: integer;
var
  i,j: Integer;
begin
  j := 0;
  for i := 1 to Items.Count do
  begin
    if Items.Items[i - 1].Active and (Items.Items[i - 1].Protocol <> wpFile) then
      Inc(j);
  end;
  result:=j;
end;


{ TWebCopyItems }

function TWebCopyItems.Add: TWebCopyItem;
begin
  Result := TWebCopyItem(inherited Add);
end;

constructor TWebCopyItems.Create(aOwner:TComponent);
begin
  inherited Create(TWebCopyItem);
  FOwner := AOwner;
end;

function TWebCopyItems.GetActiveItems: integer;
var
  i,r: Integer;

begin
  r := 0;
  for i := 1 to Count do
  begin
    if Items[i - 1].Active then
      Inc(r);
  end;
  Result := r;
end;

function TWebCopyItems.GetItem(Index: Integer): TWebCopyItem;
begin
  Result := TWebCopyItem(inherited GetItem(Index));
end;

function TWebCopyItems.GetOwner: tPersistent;
begin
  Result := FOwner;
end;

function TWebCopyItems.Insert(index: integer): TWebCopyItem;
begin
  {$IFDEF VER100}
  Result := TWebCopyItem(inherited Add);
  {$ELSE}
  Result := TWebCopyItem(inherited Insert(Index));
  {$ENDIF}
end;

procedure TWebCopyItems.SetItem(Index: Integer; Value: TWebCopyItem);
begin
  inherited SetItem(Index, Value);
end;

{ TWCopyThread }

constructor TWCopyThread.Create(AWebCopy: TWebCopy);
begin
  WebCopy := AWebCopy;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TWCopyThread.Execute;
begin
  WebCopy.DoCopy;
end;

{ TWebCopyItem }

constructor TWebCopyItem.Create(Collection: TCollection);
begin
  inherited;
  FActive := True;
  FFTPPort := 21;
end;

end.
