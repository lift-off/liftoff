{*******************************************************************}
{ TWebUpdate Wizard form                                            }
{ for Delphi & C++Builder                                           }
{ version 1.5                                                       }
{                                                                   }
{ written by                                                        }
{    TMS Software                                                   }
{    copyright © 1998-2002                                          }
{    Email : info@tmssoftware.com                                   }
{    Web   : http://www.tmssoftware.com                             }
{                                                                   }
{ The source code is given as is. The author is not responsible     }
{ for any possible damage done due to the use of this code.         }
{ The component can be freely used in any application. The source   }
{ code remains property of the writer and may not be distributed    }
{ freely as such.                                                   }
{*******************************************************************}

unit WuWizForm;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, WUpdate, ComCtrls, ExtCtrls, CheckLst;

const
  STR_NEWFOUND     = 'New version found :'#13#13;
  STR_NEWVERSION   = 'New version :';
  STR_CURVERSION   = 'Current version : ';
  STR_NONEWVERSION = 'No new version available.';
  STR_GETUPDATE    = 'Get update';
  STR_EXIT         = 'Exit';
  STR_NONEWFILES   = 'No files found for update';
  STR_CANNOTCONNECT= 'Could not connect to update server or';
  STR_NOUPDATE     = ' no update found on server ...';
  STR_NEXT         = 'Next';

type
  TWUWIZ = class(TForm)
    WebUpdate1: TWebUpdate;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Image1: TImage;
    WelcomeLabel: TLabel;
    StartButton: TButton;
    TabSheet3: TTabSheet;
    VersionInfoLabel: TLabel;
    ControlButton: TButton;
    WhatsNewMemo: TMemo;
    Label1: TLabel;
    TabSheet4: TTabSheet;
    Label2: TLabel;
    EULAMemo: TMemo;
    RAccept: TRadioButton;
    RNoAccept: TRadioButton;
    TabSheet5: TTabSheet;
    CheckListBox1: TCheckListBox;
    Label3: TLabel;
    NewButton: TButton;
    EULAButton: TButton;
    TabSheet6: TTabSheet;
    Label4: TLabel;
    FileProgress: TProgressBar;
    TotalProgress: TProgressBar;
    CancelButton: TButton;
    Label5: TLabel;
    Label6: TLabel;
    FilesButton: TButton;
    TabSheet7: TTabSheet;
    RestartButton: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    FileLabel: TLabel;
    procedure StartButtonClick(Sender: TObject);
    procedure ControlButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure EULAButtonClick(Sender: TObject);
    procedure RAcceptClick(Sender: TObject);
    procedure FilesButtonClick(Sender: TObject);
    procedure WebUpdateFileProgress(Sender: TObject; filename: String;
      pos, size: Integer);
    procedure WebUpdateCancel(Sender: TObject; var Cancel: Boolean);  
    procedure FormCreate(Sender: TObject);
    procedure RestartButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FWebUpdate: TWebUpdate;
    FCancelled: Boolean;
    procedure SetWebUpdate(const Value: TWebUpdate);
    procedure SetCancelled(const Value: Boolean);
  public
    { Public declarations }
    procedure UpdateDone;
    function CheckFileCount: Boolean;
    property WebUpdate: TWebUpdate read FWebUpdate write SetWebUpdate;
    property Cancelled: Boolean read FCancelled write SetCancelled;
  end;

var
  WUWIZ: TWUWIZ;

implementation

{$R *.dfm}

procedure TWUWIZ.StartButtonClick(Sender: TObject);
var
  res: Integer;
begin
  if WebUpdate.StartConnection = WU_SUCCESS then
  begin
    if WebUpdate.UpdateType = ftpUpdate then
      WebUpdate.FTPConnect;

    WebUpdate.UpdateUpdate := wuuSilent;

    if WebUpdate.GetControlFile = WU_SUCCESS then
    begin
      {$IFDEF DELPHI5_LVL}
      PageControl1.ActivePageIndex := 1;
      {$ELSE}
      PageControl1.ActivePage := TabSheet2;
      {$ENDIF}

      res := WebUpdate.DoVersionCheck;
      case res of
      WU_DATEBASEDNEWVERSION:
        VersionInfoLabel.Caption := STR_NEWFOUND +
          STR_CURVERSION + DateToStr(WebUpdate.CurVersionDate) + #13 +
          STR_NEWVERSION + DateToStr(WebUpdate.NewVersionDate)+ #13#13+
          WebUpdate.UpdateDescription;
      WU_VERSIONINFOBASEDNEWVERSION:
        VersionInfoLabel.Caption := STR_NEWFOUND +
          STR_CURVERSION + WebUpdate.CurVersionInfo + #13 +
          STR_NEWVERSION + WebUpdate.NewVersionInfo+ #13#13+
          WebUpdate.UpdateDescription;
      WU_NONEWVERSION:
        VersionInfoLabel.Caption := STR_NONEWVERSION;
      end;

      VersionInfoLabel.Width := 200;

      if res <> WU_NONEWVERSION then
        ControlButton.Caption := STR_GETUPDATE
      else
        ControlButton.Caption := STR_EXIT;

      ControlButton.SetFocus;
    end
    else
    begin
      {$IFDEF DELPHI5_LVL}
      PageControl1.ActivePageIndex := 1;
      {$ELSE}
      PageControl1.ActivePage := TabSheet2;
      {$ENDIF}
      
      VersionInfoLabel.Caption := STR_CANNOTCONNECT +
        STR_NOUPDATE;

      VersionInfoLabel.Width := 200;

      ControlButton.Caption := STR_EXIT;
      ControlButton.SetFocus;
    end;
  end
  else
    UpdateDone;
end;

procedure TWUWIZ.ControlButtonClick(Sender: TObject);
var
  sl: TStringList;
  i: Integer;
begin
  if ControlButton.Caption <> STR_EXIT then
  begin
    // check for custom actions to handle
    if WebUpdate.HandleActions = WU_SUCCESS then
    begin
      // check for a What's new file
      sl := WebUpdate.GetWhatsNew;
      if Assigned(sl) then
      begin
        WhatsNewMemo.Lines.Assign(sl);
        {$IFDEF DELPHI5_LVL}
        PageControl1.ActivePageIndex := 2;
        {$ELSE}
        PageControl1.ActivePage := TabSheet3;
        {$ENDIF}
        NewButton.SetFocus;
        Exit;
      end;

      // check for a EULA file
      sl := WebUpdate.GetEULA;
      if Assigned(sl) then
      begin
        EULAMemo.Lines.Assign(sl);
        {$IFDEF DELPHI5_LVL}
        PageControl1.ActivePageIndex := 3;
        {$ELSE}
        PageControl1.ActivePage := TabSheet4;
        {$ENDIF}
        Exit;
      end;

      // Get list of file details
      WebUpdate.GetFileDetails;
      for i := 1 to WebUpdate.FileList.Count do
      begin
        CheckListBox1.Items.Add(WebUpdate.FileList.Items[i - 1].Description);
      end;

      for i := 1 to CheckListBox1.Items.Count do
        CheckListBox1.Checked[i - 1] := True;

      if CheckFileCount then
      {$IFDEF DELPHI5_LVL}
        PageControl1.ActivePageIndex := 4;
      {$ELSE}
        PageControl1.ActivePage := TabSheet5;
      {$ENDIF}
    end
    else
      UpdateDone;
  end
  else
    UpdateDone;
end;

procedure TWUWIZ.NewButtonClick(Sender: TObject);
var
  sl: TStringList;
  i: Integer;
begin
  sl := WebUpdate.GetEULA;
  if Assigned(sl) then
  begin
    EULAMemo.Lines.Assign(sl);
    {$IFDEF DELPHI5_LVL}
    PageControl1.ActivePageIndex := 3;
    {$ELSE}
    PageControl1.ActivePage := TabSheet4;
    {$ENDIF}
    Exit;
  end;

  WebUpdate.GetFileDetails;
  for i := 1 to WebUpdate.FileList.Count do
  begin
    CheckListBox1.Items.Add(WebUpdate.FileList.Items[i - 1].Description);
  end;

  if CheckFileCount then
  {$IFDEF DELPHI5_LVL}
    PageControl1.ActivePageIndex := 4;
  {$ELSE}
    PageControl1.ActivePage := TabSheet5;
  {$ENDIF}
end;

procedure TWUWIZ.EULAButtonClick(Sender: TObject);
var
  i: Integer;
begin
  if RAccept.Checked then
  begin
    WebUpdate.GetFileDetails;

    for i := 1 to WebUpdate.FileList.Count do
    begin
      CheckListBox1.Items.Add(WebUpdate.FileList.Items[i - 1].Description);
    end;

    for i := 1 to WebUpdate.FileList.Count do
    begin
      CheckListBox1.Checked[i - 1] := True;
    end;

    {$IFDEF DELPHI5_LVL}
    PageControl1.ActivePageIndex := 4;
    {$ELSE}
    PageControl1.ActivePage := TabSheet5;
    {$ENDIF}
  end;

  if RNoAccept.Checked then
    UpdateDone;
end;

procedure TWUWIZ.RAcceptClick(Sender: TObject);
begin
  if RAccept.Checked then
  begin
    EULAButton.Enabled := true;
    EULAButton.Caption := STR_NEXT;
  end;

  if RNoAccept.Checked then
  begin
    EULAButton.Enabled := true;
    EULAButton.Caption := STR_EXIT;
  end;
end;

procedure TWUWIZ.FilesButtonClick(Sender: TObject);
var
  i,j: Integer;
begin
  j := 0;
  for i := 1 to CheckListBox1.Items.Count do
  begin
    if not CheckListBox1.Checked[i - 1] then
      WebUpdate.FileList.Items[j].Free
    else
      inc(j);
  end;

  if CheckFileCount then
  begin
    FileLabel.Caption := '';
    FileProgress.Position := 0;
    TotalProgress.Position := 0;

    {$IFDEF DELPHI5_LVL}
    PageControl1.ActivePageIndex := 5;
    {$ELSE}
    PageControl1.ActivePage := TabSheet6;
    {$ENDIF}

    Cursor := crHourGlass;
    
    WebUpdate.GetFileUpdates;

    Cursor := crDefault;

    if WebUpdate.Cancelled then
    begin
      UpdateDone;
    end
    else
    begin
      WebUpdate.StopConnection;
      {$IFDEF DELPHI5_LVL}
      PageControl1.ActivePageIndex := 6;
      {$ELSE}
      PageControl1.ActivePage := TabSheet7; 
      {$ENDIF}
    end;
  end;
end;

procedure TWUWIZ.WebUpdateFileProgress(Sender: TObject; filename: String;
  pos, size: Integer);
begin
  FileLabel.Caption := ExtractFileName(Filename);
  FileProgress.Max := size;
  FileProgress.Position := pos;

  TotalProgress.Max := WebUpdate.FileList.TotalSize;
  TotalProgress.Position := WebUpdate.FileList.CompletedSize + pos;
  Application.ProcessMessages;
end;

procedure TWUWIZ.FormCreate(Sender: TObject);
begin
  {$IFDEF DELPHI5_LVL}
  PageControl1.ActivePageIndex := 0;
  {$ELSE}
  PageControl1.ActivePage := TabSheet1;
  {$ENDIF}
  WebUpdate := webupdate1;
end;

procedure TWUWIZ.RestartButtonClick(Sender: TObject);
begin
  WebUpdate.DoRestart;
end;

procedure TWUWIZ.UpdateDone;
begin
  WebUpdate.StopConnection;
  Close;
end;

function TWUWIZ.CheckFileCount: Boolean;
begin
  Result := True;
  if WebUpdate.FileList.Count = 0 then
  begin
    ShowMessage(STR_NONEWFILES);
    UpdateDone;
    Result := False;
  end;
end;

procedure TWUWIZ.SetWebUpdate(const Value: TWebUpdate);
begin
  FWebUpdate := Value;
  FWebUpdate.OnFileProgress := WebUpdateFileProgress;
  FWebUpdate.OnProgressCancel := WebUpdateCancel;
  FCancelled := False;
end;

procedure TWUWIZ.SetCancelled(const Value: Boolean);
begin
  FCancelled := Value;
end;

procedure TWUWIZ.WebUpdateCancel(Sender: TObject; var Cancel: Boolean);
begin
  Cancel := FCancelled;
end;

procedure TWUWIZ.CancelButtonClick(Sender: TObject);
begin
  FCancelled := True;
end;

procedure TWUWIZ.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   UpdateDone;
end;

end.
