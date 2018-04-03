{********************************************************************}
{ TWEBDATA component                                                 }
{ for Delphi 3.0,4.0,5.0,6.0 C++Builder 3,4,5                        }
{ version 1.0 - 30/10/2001                                           }
{                                                                    }
{ written by                                                         }
{     TMS Software                                                   }
{     copyright © 1999-2001                                          }
{     Email: info@tmssoftware.com                                    }
{     Web: http://www.tmssoftware.com                                }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The component can be freely used in any application. The source    }
{ code remains property of the writer and may not be distributed     }
{ freely as such.                                                    }
{********************************************************************}

unit WebData;

interface

{$I TMSDEFS.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ShellApi, IniFiles, WinInet;

type
  TWebDataProgressEvent = procedure(Sender:TObject;iItem: Integer) of object;
  TWebDataDataEvent = procedure(Sender:TObject;iItem: Integer;data:string) of object;
  TThreadCollectDoneEvent = procedure(Sender:TObject) of object;
  TCollectErrorEvent = procedure(Sender:TObject;iItem,errcode: Integer) of object;

  TWebData = class;

  TWDInetThread = class(TThread)
  private
    Webdata: TWebData;
  protected
    procedure Execute; override;
  public
    constructor Create(awebdata:TWebData);
  end;

  TWebDataItem = class(TCollectionItem)
  private
    FURL: string;
    FScanFirst: string;
    FScanFrom: string;
    FScanTo: string;
    FData: string;
    FSuccess: Boolean;
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
    property Data:string read FData write FData;
    property Success: Boolean read FSuccess;
  published
    property URL: string read FURL write FURL;
    property ScanFirst: string read FScanFirst write FScanFirst;
    property ScanFrom: string read FScanFrom write FScanFrom;
    property ScanTo: string read FScanTo write FScanTo;
  end;

  TWebDataCollection = class(TCollection)
  private
    FOwner: TWebData;
    function GetItem(Index: Integer): TWebDataItem;
    procedure SetItem(Index: Integer; Value: TWebDataItem);
  public
    constructor Create(aOwner: TWebData);
    function Add:TWebDataItem;
    property Items[Index: Integer]: TWebDataItem read GetItem write SetItem;
  protected
    procedure Update(Item: TCollectionItem); override;
    function GetOwner: TPersistent; override;
  end;

  TImageType = (itAll,itGIF,itJPG,itPNG);

  TWebData = class(TComponent)
  private
    FImageType: TImageType;
    FImageRefs: TStrings;
    FHyperLinks: TStrings;
    FHyperLinkType: string;
    FProxy: string;
    FProxyUserID: string;
    FProxyPassword: string;
    FWebDataCollection: TWebDataCollection;
    FOnData: TWebDataDataEvent;
    FOnProgress: TWebDataProgressEvent;
    FOnCollectDone: TThreadCollectDoneEvent;
    FOnCollectError: TCollectErrorEvent;
    procedure SetWebDataCollection(const Value: TWebDataCollection);
    function MakeProxyUrl(url,proxyuser,proxypwd: string):string;
    function URLGetFile(hfile:hinternet;url,tgt: string;idx:integer):boolean;
    procedure ThreadDone(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CollectData;
    function Execute: Boolean;
    procedure ThreadCollectData;
    function ImageRefs: TStrings;
    function Hyperlinks: TStrings;
  published
    property Proxy: string read FProxy write FProxy;
    property ProxyUserID: string read FProxyUserID write FProxyUserID;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
    property Data: TWebDataCollection read FWebDataCollection write SetWebDataCollection;
    property ImageType: TImageType read FImageType write FImageType;
    property HyperLinkType: string read FHyperLinkType write FHyperLinkType;
    property OnProgress: TWebDataProgressEvent read FOnProgress write FOnProgress;
    property OnData: TWebDataDataEvent read FOnData write FOnData;
    property OnCollectDone: TThreadCollectDoneEvent read FOnCollectDone write FOnCollectDone;
    property OnCollectError: TCollectErrorEvent read FOnCollectError write FOnCollectError;
  end;


implementation

const
  READBUFFERSIZE = 4096;

function IPos(su,s:string):integer;
begin
  Result := Pos(UpperCase(su),UpperCase(s));
end;

function MergeURL(host,resource: string): string;
var
  srvr: string;
begin
  srvr := '';

  if IPos('HTTP://',host) > 0 then
  begin
    srvr := 'HTTP://';
    delete(host,1,7);
  end;

  while (Length(host) > 0) and not (host[1] in ['/','\']) do
  begin
    srvr := srvr + host[1];
    delete(host,1,1);
  end;

  if IPos('HTTP:',resource) > 0 then
    Result := resource
  else
  begin
    if  (Length(resource) > 0) and (Resource[1] in ['\','/']) then
      Result := srvr + resource
    else
    begin
      while (Length(host) > 0) and not (host[Length(host)] in ['/','\']) do
        Delete(host,length(host),1);
      if host = '' then
        host := '/';

      Result := srvr + host + resource;
    end
  end;
end;

procedure TWDInetThread.Execute;
begin
  WebData.CollectData;
end;

constructor TWDInetThread.Create(AWebData:TWebData);
begin
  WebData := AWebData;
  FreeOnTerminate := True;
  inherited Create(False);
end;

{ TWebDataItem }

constructor TWebDataItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

destructor TWebDataItem.Destroy;
begin
  inherited Destroy;
end;

function TWebDataItem.GetDisplayName: string;
begin
  Result := FURL;
end;


{ TWebDataCollection }

function TWebDataCollection.Add: TWebDataItem;
begin
  Result := TWebDataItem(inherited Add);
end;


constructor TWebDataCollection.Create(aOwner: TWebData);
begin
  inherited Create(TWebDataItem);
  FOwner := AOwner;
end;

function TWebDataCollection.GetItem(Index: Integer): TWebDataItem;
begin
  Result := TWebDataItem(inherited GetItem(Index));
end;

function TWebDataCollection.GetOwner: tPersistent;
begin
  Result := FOwner;
end;

procedure TWebDataCollection.SetItem(Index: Integer; Value: TWebDataItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TWebDataCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;


{ TWebData }
function TWebData.MakeProxyUrl(url,proxyuser,proxypwd:string):string;
begin
  Result := url;
  if (pos('HTTP://',uppercase(url))>0) and (proxyuser<>'') then
  begin
    Delete(url,1,7);
    Result := 'http://' + proxyuser + ':' + proxypwd + '@' + url;
  end;
end;

function TWebData.URLGetFile(hfile:hinternet;url,tgt:string;idx:integer):boolean;
var
  buf:array[0..READBUFFERSIZE-1] of char;
  bufsize: dword;
  lf: file;
  hintfile: hinternet;
  lpdwlen,lpdwidx,lpdword: dword;

begin
  Result := False;
  url := MakeProxyURL(url,FProxyUserID,FProxyPassword);

  {$IFDEF TMSDEBUG}
  outputdebugstring(pchar(url));
  {$ENDIF}

  hintfile := InternetOpenURL(hfile,pchar(url),nil,0,INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE,0);

  if (hintfile = nil) then
  begin
    if Assigned(FOnCollectError) then
      FOnCollectError(self,idx,-1);
    Exit;
  end;

  lpdwlen := 4;
  lpdwidx := 0;

  if (hintfile <> nil) then
  begin
    HttpQueryInfo(hintfile,HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER ,@lpdword,lpdwlen,lpdwidx);
    if (lpdword >= 300) then
    begin
      if Assigned(FOnCollectError) then
        FOnCollectError(self,idx,lpdword);
      Exit;
     end;
  end;

  AssignFile(lf,tgt);
  Rewrite(lf,1);

  bufsize := READBUFFERSIZE;

  while (bufsize=READBUFFERSIZE) do
  begin
    application.processmessages;
    if not InternetReadFile(hintfile,@buf,READBUFFERSIZE,bufsize) then break;
    {$IFDEF TMSDEBUG}
    outputdebugstring(pchar('read from http = '+inttostr(bufsize)));
    {$ENDIF}
    if (bufsize>0) and (bufsize<=READBUFFERSIZE) then
      blockwrite(lf,buf,bufsize);

    if (bufsize > 0) then Result := True;
  end;

  CloseFile(lf);
  InternetCloseHandle(hintfile);
end;

procedure TWebData.ThreadCollectData;
begin
  with TWDInetThread.Create(self) do
    OnTerminate := ThreadDone;
end;

procedure TWebData.ThreadDone(Sender: TObject);
begin
  if Assigned(FOnCollectDone) then
    FOnCollectDone(self);
end;


procedure TWebData.CollectData;
var
  hint: hinternet;
  i,j: integer;
  wd: TWebDataItem;
  s,ir,hr,su: string;
  ch: Char;
  f: TMemorystream;
  prevurl: string;
  res: Boolean;
  hpos,tpos: Integer;
  szTempName: array[0..255] of char;
  FileName:string;

begin
  if Data.Count = 0 then
    Exit;

  FImageRefs.Clear;
  FHyperLinks.Clear;

  // http
  if FProxy = '' then
    hint := InternetOpen('WebData',INTERNET_OPEN_TYPE_PRECONFIG {or INTERNET_FLAG_ASYNC},nil,nil,0)
  else
    hint := InternetOpen('WebData',INTERNET_OPEN_TYPE_PROXY {or INTERNET_FLAG_ASYNC},PChar(FProxy),nil,0);

  if hint = nil then
    Exit;

  f := TMemoryStream.Create;
  prevURL := '';

  GetTempFileName(pchar(GetCurrentDir),'WD',0,szTempName);
  FileName := strpas(szTempName);

  for i := 1 to Data.Count do
  begin
    wd := Data.Items[i - 1];
    wd.FSuccess := False;

    if prevURL <> wd.URL then
      res := URLGetFile(hint,wd.URL,FileName,i - 1)
    else
      res := true;

    if not res then
      prevurl := ''
    else
      prevurl := wd.URL;

    if not res and (prevURL <> wd.URL) then
      Continue;

    if not FileExists(FileName) then
      Continue;

    f.Clear;
    f.LoadFromfile(FileName);
    f.Position := 0;
    s := '';
    wd.data := '';

    if Assigned(FOnProgress) then
      FOnProgress(self,i-1);

    for j := 1 to f.size do
    begin
      f.Read(ch,1);
      s := s + ch;
    end;
    ir := s;
    hr := s;
    if Pos(wd.ScanFirst,s) > 0 then
    begin
      Delete(s,1,pos(wd.ScanFirst,s) + Length(wd.ScanFirst) - 1);
      if Pos(wd.ScanFrom,s) > 0 then
      begin
        Delete(s,1,Pos(wd.ScanFrom,s) + Length(wd.ScanFrom) - 1);
        if Pos(wd.ScanTo,s) > 0 then
        begin
          wd.Data := Copy(s,1,Pos(wd.ScanTo,s) - 1);
          wd.FSuccess := True;
          if Assigned(FOnData) then
            FOnData(Self,i - 1,wd.Data);
        end;
      end;
    end;

    while IPos('<IMG',ir) > 0 do
    begin
      Delete(ir,1,ipos('<IMG',ir));
      su := Copy(ir,1,ipos('>',ir));
      if IPos('SRC="',ir) > 0 then
      begin
        Delete(ir,1,ipos('SRC="',ir)+4);
        if Pos('"',ir) > 0 then
        begin
          su := Copy(ir,1,pos('"',ir)-1);
          su := MergeURL(wd.URL,su);
          case FImageType of
          itAll:FImageRefs.Add(su);
          itGIF:if IPos('.GIF',su) > 0 then FImageRefs.Add(su);
          itJPG:if IPos('.JPG',su) > 0 then FImageRefs.Add(su);
          itPNG:if IPos('.PNG',su) > 0 then FImageRefs.Add(su);
          end;
        end;
      end;
    end;

    while IPos('<A',hr) > 0 do
    begin
      Delete(hr,1,ipos('<A',hr));
      su := Copy(hr,1,pos('>',hr));

      if IPos('HREF=',hr) > 0 then
      begin
        Delete(hr,1,ipos('HREF=',hr)+4);

        if pos('"',hr) = 1 then
         delete(hr,1,1);

        hpos := pos('"',hr);
        tpos := pos('>',hr);

        if (hpos > 0) and (tpos > hpos) then
        begin
          su := Copy(hr,1,pos('"',hr)-1);

          if Pos('://',su) = 0 then
            su := MergeURL(wd.URL,su);

          if FHyperLinkType <> '' then
          begin
            if IPos(FHyperLinkType,su) > 0 then
              FHyperLinks.Add(su);
          end
          else
          begin
            {$IFDEF TMSDEBUG}
            outputdebugstring(pchar('anchor : '+su));
            {$ENDIF}
            FHyperLinks.Add(su);
          end;
        end;

        if (tpos > 0) and (tpos < hpos) then
        begin
          su := Copy(hr,1,tpos-1);

          if Pos('://',su) = 0 then
            su := MergeURL(wd.URL,su);

          if FHyperLinkType <> '' then
          begin
            if IPos(FHyperLinkType,su) > 0 then
              FHyperLinks.Add(su);
          end
          else
          begin
            {$IFDEF TMSDEBUG}
            outputdebugstring(pchar('anchor : '+su));
            {$ENDIF}
            FHyperLinks.Add(su);
          end;
        end;

      end;
    end;
  end;

  f.free;

  //for debugging, do not delete

  if FileExists(FileName) then
    DeleteFile(FileName);

  InternetCloseHandle(hint);
end;

constructor TWebData.Create(AOwner: TComponent);
begin
  inherited Create(aOwner);
  FWebDataCollection := TWebDataCollection.Create(Self);
  FImageRefs := TStringlist.Create;
  FHyperlinks := TStringlist.Create;
end;

destructor TWebData.Destroy;
begin
  FWebDatacollection.Free;
  FimageRefs.Free;
  FHyperlinks.Free;
  inherited Destroy;
end;

procedure TWebData.SetWebDataCollection(const Value: TWebDataCollection);
begin
  FWebDataCollection := Value;
end;

function TWebData.Hyperlinks: TStrings;
begin
  Result := FHyperlinks;
end;

function TWebData.ImageRefs: TStrings;
begin
  Result := FImageRefs;
end;

function TWebData.Execute: Boolean;
var
  i: Integer;
begin
  for i := 1 to Data.Count do
    Data.Items[i - 1].FSuccess := False;
  CollectData;

  Result := True;
  for i := 1 to Data.Count do
    if Data.Items[i - 1].Success = False then
      Result := False;

end;

end.
