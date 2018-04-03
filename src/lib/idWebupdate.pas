{-----------------------------------------------------------------------------
 Unit Name: idWebupdate
 Author:    Marc (marc@idev.ch, www.idev.ch)
 Purpose:   Component to enable a Webupdate-Feature in apps.
 Requires:  - iDev StringLib: id_string.pas
            - Internet Direct (INDY) Version 9.x (http://www.nevrona.com/indy/)
 History:   01.01.2003 - Initial coding
            11.11.2003 - Proper handling if Info-File URL is invalid
                       - Texts outsourced into the TidWebUpdateText-Class so it
                         can be changed at design- and runtime
-----------------------------------------------------------------------------}

unit idWebupdate;

interface

uses
  classes, windows, sysutils, forms,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdHTTPHeaderInfo,
  idWebupdateDownload;

type

  TDownloadThread = class;
  TidWebUpdateTexts = class;

  TidWebUpdate = class(TComponent)
  private
    FAvailableVersion: string;
    FLocalVersion: string;
    FUpdateInfoFileURL: string;
    FDownloadURL: string;
    FReadMeURL: string;
    FProxyParams: TIdProxyConnectionInfo;
    FHTTP: TidHTTP;
    FUpdateFileContent: string;
    FUpdateFileName: string;
    FUpdateParameters: string;
    STime: TDateTime;
    sest: string;
    FTexts: TidWebUpdateTexts;
    FReadMeOpenWith: string;
  protected
    frmUpdDown : TfrmIdWebupdateDownload;
    UpdDwnThread : TDownloadThread;
    procedure InitHTTP; virtual;
    function GetUpdateFileContent: boolean; virtual;
    procedure ParseUpdateFileContent; virtual;
    procedure OnReadMeClick(Sender: TObject);
    procedure OnDownloadCancelClick(Sender: TObject);
    procedure OnDownloadWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
    procedure OnDownloadWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    { Core methodes }
    function IsUpdateAvailable(ASilent: boolean = false): boolean; virtual;
    function DownloadAndExecuteUpdate: boolean; virtual;

    { Read-Only properties }
    property AvailableVersion: string read FAvailableVersion;
    property ReadMeURL: string read FReadMeURL;
    property ReadMeOpenWith: string read FReadMeOpenWith;
    property DownloadURL: string read FDownloadURL;
    property UpdateFileName: string read FUpdateFileName;
    property UpdateParameters: string read FUpdateParameters;

    { Special, optional properties }
    property UpdateFileContent: string read FUpdateFileContent;

  published

    property UpdateInfoFileURL: string read FUpdateInfoFileURL write FUpdateInfoFileURL;
    property LocalVersion: string read FLocalVersion write FLocalVersion;
    property ProxyParams: TIdProxyConnectionInfo read FProxyParams write FProxyParams;

    property Texts: TidWebUpdateTexts read FTexts write FTexts;

  end;

  { Supportclass for the thread to download the update itself }
  TDownloadThread = class(TThread)
  private
  public
    URL : string;
    HTTP : TidHTTP;
    DestFile : string;
    frmUpdDown : TfrmIdWebupdateDownload;
    Done: boolean;

    constructor Create;
    procedure Execute; override;
  end;

  { Supporting class containing all the texts for the webupdate }
  TidWebUpdateTexts = class(TPersistent)
  private
    FAreYouOnline: string;
    FAreYouOnlineCapt: string;
    FNoUpdateAvailable: string;
    FCaption: string;
    FBytes: string;
    FKBperSec: string;
    FCancelDownloadCapt: string;
    FCancelDownload: string;
    FWouldYouLikeToUpgrade: string;
    FbtnYes: string;
    FUpdateAvailableCapt: string;
    FAvailableVersion: string;
    FUpdateAvailableInfo: string;
    FbtnNo: string;
    FInstalledVersion: string;
    FViewUpdateNotes: string;
    FDownloadCapt: string;
    FDownloadRate: string;
    FCancel: string;
    FEstimatedTime: string;
    FDownloading: string;
  public
    constructor Create; virtual;
    
    procedure SetEnglishTexts;
    procedure SetGermanTexts;
  published
    property AreYouOnline: string read FAreYouOnline write FAreYouOnline;
    property AreYouOnlineCapt: string read FAreYouOnlineCapt write FAreYouOnlineCapt;
    property NoUpdateAvailable: string read FNoUpdateAvailable write FNoUpdateAvailable;
    property Caption: string read FCaption write FCaption;
    property Bytes: string read FBytes write FBytes;
    property KBperSec: string read FKBperSec write FKBperSec;
    property CancelDownload: string read FCancelDownload write FCancelDownload;
    property CancelDownloadCapt: string read FCancelDownloadCapt write FCancelDownloadCapt;
    property UpdateAvailableCapt: string read FUpdateAvailableCapt write FUpdateAvailableCapt;
    property UpdateAvailableInfo: string read FUpdateAvailableInfo write FUpdateAvailableInfo;
    property InstalledVersion: string read FInstalledVersion write FInstalledVersion;
    property AvailableVersion: string read FAvailableVersion write FAvailableVersion;
    property ViewUpdateNotes: string read FViewUpdateNotes write FViewUpdateNotes;
    property WouldYouLikeToUpgrade: string read FWouldYouLikeToUpgrade write FWouldYouLikeToUpgrade;
    property btnYes: string read FbtnYes write FbtnYes;
    property btnNo: string read FbtnNo write FbtnNo;
    property DownloadCapt: string read FDownloadCapt write FDownloadCapt;
    property Downloading: string read FDownloading write FDownloading;
    property EstimatedTime: string read FEstimatedTime write FEstimatedTime;
    property DownloadRate: string read FDownloadRate write FDownloadRate;
    property Cancel: string read FCancel write FCancel;
  end;

procedure Register;

implementation

{$R idWebUpdate.dcr}

uses
  id_string, id_tools, dialogs, idIPWatch,
  idWebupdateAvailable, DateUtils;

const
  cReadme        = 'readme';
  cReadmeOpenWith= 'readmeopenwith';
  cDownloadURL   = 'downloadurl';
  cVersion       = 'version';
  cFileName      = 'filename';
  cParameters    = 'parameters';

procedure Register;
begin
  RegisterComponents('iDev', [TidWebUpdate]);
end;

function IsVersionNewer(OldVersion, NewVersion: string) : boolean;
const
    Sep: Charset = ['.',','];
var i : integer;
    OldNo,
    NewNo : integer;
begin
  result := false;
  if NewVersion = '' then exit;
  if OldVersion = '' then begin
    result := true;
    exit;
  end;

  for i := 1 to ItemCount(OldVersion, Sep) do begin
    OldNo := StrToInt(ExtractItem(i, OldVersion, Sep));
    if ItemCount(NewVersion, Sep) >= i then begin
      NewNo := StrToInt(ExtractItem(i, NewVersion, Sep));
      if NewNo > OldNo then begin
        result := true;
        Break;
      end else
      if NewNo < OldNo then begin
        result := false;
        Break;
      end;
    end else begin
      Break;
    end;
  end;
end;


{ TidWebUpdate }

constructor TidWebUpdate.Create(AOwner: TComponent);
begin
  inherited;
  FProxyParams := TIdProxyConnectionInfo.Create;
  FHTTP := nil;
  frmUpdDown := nil;
  FAvailableVersion := '';
  FLocalVersion := '';
  FUpdateInfoFileURL := '';
  FUpdateFileName := '';
  FUpdateParameters := '';
  UpdDwnThread := nil;
  FTexts := TidWebUpdateTexts.Create;
end;

destructor TidWebUpdate.Destroy;
begin
  FreeAndNil(frmUpdDown);
  FreeAndNil(FProxyParams);
  FreeAndNil(FHTTP);
  FreeAndNil(FTexts);
  inherited;
end;

function TidWebUpdate.DownloadAndExecuteUpdate: boolean;
var
  DestFileName : string;
begin
  InitHTTP;
  frmUpdDown := TfrmIdWebupdateDownload.Create(nil);
  frmUpdDown.btnCancel.OnClick := OnDownloadCancelClick;
  try
    with frmUpdDown do begin
      Caption := Texts.DownloadCapt;
      lblPleaseWait.Caption := Texts.Downloading;
      lblEstimatedTime.Caption := Texts.EstimatedTime;
      lblDownloadRate.Caption := Texts.DownloadRate;
      btnCancel.Caption := Texts.Cancel;

      Ani.Active := true;
      Show;

      DestFileName := IncludeTrailingPathDelimiter(GetTempDir) + UpdateFileName;

      UpdDwnThread := TDownloadThread.Create;
      try
        UpdDwnThread.URL := DownloadURL;
        UpdDwnThread.HTTP := FHTTP;
        UpdDwnThread.DestFile := DestFileName;

        fHTTP.OnWorkBegin := OnDownloadWorkBegin;
        fHTTP.OnWork := OnDownloadWork;
        UpdDwnThread.Resume;

      finally

        repeat
          Sleep(1);
          Application.ProcessMessages;
        until UpdDwnThread.Terminated;

        result := UpdDwnThread.Done;
        if result then begin
          OpenProgram(DestFileName, UpdateParameters);
          Application.Terminate;
        end else begin
        end;

        fHTTP.OnWorkBegin := nil;
        fHTTP.OnWork := nil;

        UpdDwnThread.WaitFor; // to get sure it is really done
        UpdDwnThread.Free;
      end;

    end;
  finally
    FreeAndNil(frmUpdDown);
  end;

  result:= true;
end;

procedure TidWebUpdate.InitHTTP;
begin
  if not assigned(FHTTP) then
    FHTTP := TidHTTP.Create(nil);

  if fHTTP.Connected then FHTTP.Disconnect;

  with FHTTP do begin
    HandleRedirects := true;   // Switch on automatic redirection-handling
    RedirectMaximum := 15;
  end;

  with FHTTP.ProxyParams do begin
    Authentication := ProxyParams.Authentication;
    BasicAuthentication := ProxyParams.BasicAuthentication;
    ProxyPassword := ProxyParams.ProxyPassword;
    ProxyPort := ProxyParams.ProxyPort;
    ProxyServer := ProxyParams.ProxyServer;
    ProxyUsername := ProxyParams.ProxyUsername;
  end;
end;

function TidWebUpdate.GetUpdateFileContent: boolean;
begin
  assert(UpdateInfoFileURL <> '', 'TidWebUpdate: Property UpdateInfoFileURL needs to be set to a valid URL!');
  InitHTTP;
  try
    FUpdateFileContent := FHTTP.Get(UpdateInfoFileURL);
    ParseUpdateFileContent;
    result := true;
  except
    result := false;
  end;
end;

function TidWebUpdate.IsUpdateAvailable(ASilent: boolean = false): boolean;
var
  frmUpdAvail : TfrmIdWebupdateAvailable;
  IpWatch : TidIPWatch;
  IsOnline : boolean;
begin
  result := false;

  IpWatch := TidIpWatch.Create(nil);
  try
    IpWatch.HistoryEnabled := false;

    if not ASilent then begin
      IsOnline := IpWatch.ForceCheck;
      if  (not IsOnline)
      and (Application.MessageBox(PChar(Texts.AreYouOnline),
                                  PChar(Texts.AreYouOnlineCapt),
                                  mb_IconWarning + mb_OkCancel) = idCancel)
      then
        exit;
    end;

    IpWatch.ForceCheck;

    if  (GetUpdateFileContent)
    and (AvailableVersion <> '') then begin
      result := IsVersionNewer(LocalVersion, AvailableVersion);
    end else
      result := false;

    if not ASilent then
      if result then begin
        frmUpdAvail := TfrmIdWebupdateAvailable.Create(nil);
        try
          with frmUpdAvail do begin
            Caption := Application.Title + ' ' + Texts.UpdateAvailableCapt;
            lblUpdateText.Caption := Texts.UpdateAvailableInfo;
            lblInstalledVersion.Caption := Texts.InstalledVersion;
            lblAvailableVersion.Caption := Texts.AvailableVersion;
            btnReadme.Caption := Texts.ViewUpdateNotes;
            lblUpgrade.Caption := Texts.WouldYouLikeToUpgrade;
            btnYes.Caption := Texts.btnYes;
            btnNo.Caption := Texts.btnNo;

            edVersionInstalled.Text := LocalVersion;
            edAvailableVersion.Text := AvailableVersion;
            btnReadme.OnClick := OnReadMeClick;
            btnReadme.Visible := ReadMeURL <> ''; 

            if ShowModal = idYes then begin
              Hide;
              Application.ProcessMessages;
              DownloadAndExecuteUpdate;
            end;
          end;

        finally
          FreeAndNil(frmUpdAvail);
        end;

      end else begin
        Application.MessageBox(PChar(Texts.NoUpdateAvailable),
                               PChar(Texts.Caption),
                               mb_IconInformation);
      end;

  finally
    FreeAndNil(IpWatch);
  end;

end;

procedure TidWebUpdate.ParseUpdateFileContent;
var
  str : TStringList;
  line, i : integer;
  id, value : string;
begin
  FAvailableVersion := '';
  FReadMeURL := '';
  FReadMeOpenWith:= '';
  FDownloadURL := '';

  str := TStringList.Create;
  try
    Str.Text := FUpdateFileContent;

    if str.Count > 0 then
      for line := 0 to pred(str.Count) do begin
        i := Pos('=', str[line]);
        if i > 0 then begin
          id := Copy(str[line], 1, i - 1);
          value := CopyEnd(str[line], i + 1);

          if LowerCase(id) = cReadme then
            FReadMeURL := value
          else
          if LowerCase(id) = cReadmeOpenWith then
            FReadMeOpenWith := value
          else
          if LowerCase(id) = cDownloadURL then
            FDownloadURL := value
          else
          if LowerCase(id) = cVersion then
            FAvailableVersion := value
          else
          if LowerCase(id) = cFileName then
            FUpdateFileName := value
          else
          if LowerCase(id) = cParameters then
            FUpdateParameters := value;

        end;
      end;

  finally
    FreeAndNil(Str);
  end;
end;

procedure TidWebUpdate.OnReadMeClick(Sender: TObject);
begin
  if ReadmeURL <> '' then begin
    OpenFile(ReadmeURL);
  end;
end;

procedure TidWebUpdate.OnDownloadWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
var
  S: String;
  TotalTime: TDateTime;
  H, M, Sec, MS: Word;
  DLTime: Double;
  est : double;
  AverageSpeed: double;
begin
  if assigned(frmUpdDown) then begin

    frmUpdDown.Lock.Enter;
    try
      TotalTime :=  Now - STime;
      DecodeTime(TotalTime, H, M, Sec, MS);
      Sec := Sec + M * 60 + H * 3600;
      DLTime := Sec + MS / 1000;
      if DLTime > 0 then begin
        AverageSpeed := (AWorkCount / 1024) / DLTime;
      end else
        AverageSpeed := 0;

      if AverageSpeed > 0 then
        est := (frmUpdDown.ProgressBar.Max - AWorkCount) / (AWorkCount / DLTime)
      else
        est := 0;

      if est > 0 then begin
        h := round(int(est / 3600));
        m := round(int(est / 60));
        sec := round(est - ((h * 3600) + (m * 60)));
        sest := IntToStr(h) + ':' + IntToStr(m) + ':' + IntToStr(sec);
      end;

      s := FormatFloat('#,##', AWorkCount) + ' / ' + FormatFloat('#,##', frmUpdDown.ProgressBar.Max) + ' ' + Texts.Bytes;
      if sest <> '' then
        s := sest + ' (' + s + ')';

      frmUpdDown.ProgressBar.Position := AWorkCount;
      frmUpdDown.lblEstimated.Caption := s;
      frmUpdDown.lblRate.Caption := FormatFloat('#,##0.00', AverageSpeed) + ' ' + Texts.KBperSec;
      frmUpdDown.Refresh;
    finally
      frmUpdDown.Lock.Leave;
    end;
  end;
end;

procedure TidWebUpdate.OnDownloadWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
  STime := Now;
  if assigned(frmUpdDown) then begin
    frmUpdDown.Lock.Enter;
    try
      sest := '';
      frmUpdDown.ProgressBar.Max := AWorkCountMax;
      frmUpdDown.ProgressBar.Position := 0;
      frmUpdDown.Refresh;
    finally
      frmUpdDown.Lock.Leave;
    end;
  end;
end;


procedure TidWebUpdate.OnDownloadCancelClick(Sender: TObject);
begin
  if Application.MessageBox(PCHar(Texts.CancelDownload),
                            PChar(Texts.CancelDownloadCapt),
                            mb_IconExclamation + mb_YesNo) = idYes then begin

    if assigned(frmUpdDown) then begin
      try
        frmUpdDown.btnCancel.Enabled := false;
        Application.ProcessMessages;
        if assigned(UpdDwnThread) then begin
          fHTTP.Disconnect;
        end;
      except
      end;
    end;

  end;
end;

{ TDownloadThread }

constructor TDownloadThread.Create;
begin
  inherited Create(true);
  URL := '';
  HTTP := nil;
  DestFile := '';
  Done := false;
end;

procedure TDownloadThread.Execute;
var
  FileStream : TFileStream;
begin
  FileStream := nil;
  try
    with frmUpdDown do begin
      FileStream := TFileStream.Create(DestFile, fmCreate);
      try
        HTTP.Get(URL, FileStream);
        Done := true;
      except
        {$i-}
        DeleteFile( DestFile );
        {$i+}
      end;
    end;

  finally
    FreeAndNil(FileStream);
    Terminate;
  end;

end;


{ TidWebUpdateTexts }

constructor TidWebUpdateTexts.Create;
begin
  SetEnglishTexts;
end;

procedure TidWebUpdateTexts.SetEnglishTexts;
begin
  AreYouOnline := 'Please make sure you are connected to the internet!'+#13#13+'Continue?';
  AreYouOnlineCapt := 'You are not online';
  NoUpdateAvailable := 'Currently there is no update for this application available.';
  Caption := 'Online-Update';
  Bytes := 'bytes';
  KBperSec := 'kB/s';
  CancelDownload := 'Are you sure to cancel the Download and the Update?';
  CancelDownloadCapt := 'Cancel Download and Update';
  UpdateAvailableCapt := 'Update available';
  UpdateAvailableInfo := 'There is an update for this application available:';
  InstalledVersion := 'Currently installed version:';
  AvailableVersion := 'Available version:';
  ViewUpdateNotes := 'View update notes ...';
  WouldYouLikeToUpgrade := 'Would you like to download and install the available version?';
  btnYes := '&Yes';
  btnNo := '&No';
  DownloadCapt := 'Downloading Update';
  Downloading := 'Downloading update. Plese wait ...';
  EstimatedTime := 'Estimated time:';
  DownloadRate := 'Download rate:';
  Cancel := 'Cancel';
end;

procedure TidWebUpdateTexts.SetGermanTexts;
begin
  AreYouOnline := 'Bitte stellen Sie sicher, dass Sie eine Internetverbindung haben!'+#13#13+'Weiter?';
  AreYouOnlineCapt := 'Sie sind z.Z. nicht Online';
  NoUpdateAvailable := 'Es sind z.Z. keine Updates für diese Applikation verfügbar.';
  Caption := 'Online-Update';
  Bytes := 'bytes';
  KBperSec := 'kB/s';
  CancelDownload := 'Sind Sie sicher, dass Sie den Update abbrechen wollen?';
  CancelDownloadCapt := 'Update abbrechen';
  UpdateAvailableCapt := 'Update vorhanden';
  UpdateAvailableInfo := 'Folgender Update ist verfügbar:';
  InstalledVersion := 'Aktuell installierte Version:';
  AvailableVersion := 'Verfügbare Version:';
  ViewUpdateNotes := 'Versionsbeschreibung anzeigen ...';
  WouldYouLikeToUpgrade := 'Wollen Sie die verfügbare Version runter laden und installieren?';
  btnYes := '&Ja';
  btnNo := '&Nein';
  DownloadCapt := 'Upldate wird runter geladen';
  Downloading := 'Update wird runter geladen. Bitte warten ...';
  EstimatedTime := 'Verbleibende Zeit:';
  DownloadRate := 'Geschwindigkeit:';
  Cancel := 'Abbrechen';
end;

end.
