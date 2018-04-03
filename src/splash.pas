unit splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfrmSplash = class(TForm)
    Shape1: TShape;
    Image1: TImage;
    Label1: TLabel;
    lblVersion: TLabel;
    Label4: TLabel;
    Image2: TImage;
    Label5: TLabel;
    procedure Image2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

uses
  id_tools, ad_consts, maindata;

{$R *.dfm}

procedure TfrmSplash.Image2Click(Sender: TObject);
begin
  OpenFile(WebSiteCompany);
end;

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := ProgVersionLong;
end;

end.
