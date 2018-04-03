unit idWebupdateAvailable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmIdWebupdateAvailable = class(TForm)
    lblUpdateText: TLabel;
    Image1: TImage;
    lblInstalledVersion: TLabel;
    lblAvailableVersion: TLabel;
    edVersionInstalled: TEdit;
    edAvailableVersion: TEdit;
    lblUpgrade: TLabel;
    btnReadme: TButton;
    btnYes: TButton;
    btnNo: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmIdWebupdateAvailable: TfrmIdWebupdateAvailable;

implementation

{$R *.dfm}

end.
