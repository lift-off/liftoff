unit idWebupdateDownload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, SyncObjs;

type
  TfrmIdWebupdateDownload = class(TForm)
    Ani: TAnimate;
    btnCancel: TButton;
    lblPleaseWait: TLabel;
    ProgressBar: TProgressBar;
    lblEstimatedTime: TLabel;
    lblDownloadRate: TLabel;
    lblEstimated: TLabel;
    lblRate: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Lock: TCriticalSection;
  end;

var
  frmIdWebupdateDownload: TfrmIdWebupdateDownload;

implementation

{$R *.dfm}

procedure TfrmIdWebupdateDownload.FormCreate(Sender: TObject);
begin
  Lock := TCriticalSection.Create;
  Ani.Active := true;
end;

procedure TfrmIdWebupdateDownload.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Lock);
end;

end.
