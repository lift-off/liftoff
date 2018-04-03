unit profilchoose;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, StdCtrls, ExtCtrls, idTranslator;

type
  TfrmProfilChoose = class(TForm)
    Panel1: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    lvProfile: TListView;
    ImageList1: TImageList;
    translator: TidTranslator;
    procedure lvProfileDblClick(Sender: TObject);
    procedure lvProfileClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FProfilname: string;
    procedure UpdateProfileList;
  public
    { Public declarations }
    function Execute: boolean;
    property Profilname: string read FProfilname write FProfilname;
  end;

var
  frmProfilChoose: TfrmProfilChoose;

implementation

{$R *.dfm}

uses ad_consts, maindata;

function TfrmProfilChoose.Execute: boolean;
begin
  UpdateProfileList;
  lvProfileClick(self);
  result := ShowModal = idOk;
end;

procedure TfrmProfilChoose.UpdateProfileList;
var
  SearchRec : TSearchRec;
  status : integer;
  p : integer;
  sExt : string;
  s : string;
  NewItem,
  ListItem: TListItem;
begin
  sExt := ProfilFileExt;
  ListItem := nil;
  Status := FindFirst(ProfilPath + '*' + sExt, faAnyFile, SearchRec);
  try
    lvProfile.Items.BeginUpdate;
    lvProfile.Clear;
    while status = 0 do begin
      NewItem := lvProfile.Items.Add;
      with NewItem do begin
        s := SearchRec.Name;
        p := Pos(UpperCase(sExt), UpperCase(s));
        if p > 0 then s := Copy(s, 1, p-1);
        Caption := s;
        ImageIndex := 0;
        if UpperCase(Caption) = UpperCase(FProfilName) then ListItem := NewItem;
      end;

      status := FindNext(SearchRec);

    end;
  finally
    FindClose(SearchRec);
    lvProfile.Items.EndUpdate;
    lvProfile.AlphaSort;
    lvProfile.Refresh;
    Application.ProcessMessages;

//    ListItem := lvProfile.FindCaption(0, FProfilName, false, true, true);
    if assigned(ListItem) then begin
      ListItem.Selected := true;
      lvProfile.ItemIndex := ListItem.Index;
      ListItem.MakeVisible(true);
    end;
  end;
end;


procedure TfrmProfilChoose.lvProfileDblClick(Sender: TObject);
begin
  btnOk.Click;
end;

procedure TfrmProfilChoose.lvProfileClick(Sender: TObject);
begin
  btnOk.Enabled := assigned(lvProfile.Selected);
end;

procedure TfrmProfilChoose.btnOkClick(Sender: TObject);
begin
  FProfilname := lvProfile.Selected.Caption;
  ModalResult := mrOk;
end;

procedure TfrmProfilChoose.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  dmMain.CheckForSpecialKey(key, Shift, translator);
end;

procedure TfrmProfilChoose.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

end.
