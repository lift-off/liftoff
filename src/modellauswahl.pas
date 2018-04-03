unit modellauswahl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, dxBar, ImgList, StdCtrls, idGroupHeader,
  idTranslator;

type
  TfrmModellAuswahl = class(TForm)
    lvModelle: TListView;
    Panel1: TPanel;
    ImageList1: TImageList;
    btnOk: TButton;
    btnCancel: TButton;
    pnlKeinModellGefunden: TPanel;
    PageControl1: TPageControl;
    tsOwnModels: TTabSheet;
    tsSampleModels: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Image1: TImage;
    lvSamples: TListView;
    idGroupHeader1: TidGroupHeader;
    Label5: TLabel;
    Image2: TImage;
    translator: TidTranslator;
    procedure btnOkClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure lvModelleDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function FillData : boolean;
  end;

var
  frmModellAuswahl: TfrmModellAuswahl;

implementation

{$R *.dfm}

uses
  ad_consts, id_string, main, maindata;

{ TfrmModellAuswahl }

function TfrmModellAuswahl.FillData: boolean;
var
  ownModellsFound: boolean;

  procedure FillDir( _dir: string; _ownModels: boolean );
  var
    SearchRec : TSearchRec;
    status : integer;
    s : string;
  begin
    status := FindFirst(_dir + '*' + ModellFileExt, faAnyFile, SearchRec);
    while status = 0 do begin

      s := SearchRec.Name;
      if LastPos(ModellFileExt, s) > 0 then s := Copy(s, 1, LastPos(ModellFileExt, s) -1);

      if not _ownModels then
        lvSamples.AddItem(s, TObject(SearchRec.Time))
      else begin
        lvModelle.AddItem(s, TObject(SearchRec.Time));
        if _ownModels then ownModellsFound:= true;
      end;
      result := true;

      status := FindNext(SearchRec);
    end;
  end;

begin
  result := false;
  ownModellsFound:= false;
  lvModelle.Items.BeginUpdate;
  lvSamples.Items.BeginUpdate;
  try
    lvModelle.Clear;
    lvSamples.Clear;

    FillDir( ModellPath, true );
    FillDir( SmpModellPath, false );

  finally
    lvSamples.Items.EndUpdate;
    lvModelle.Items.EndUpdate;
  end;

  pnlKeinModellGefunden.Visible := not result;
  btnOk.Enabled := result;

  if ownModellsFound then PageControl1.ActivePage:= tsOwnModels
  else PageControl1.ActivePage:= tsSampleModels;

end;

procedure TfrmModellAuswahl.btnOkClick(Sender: TObject);
begin
  if ((PageControl1.ActivePage = tsOwnModels) and (not assigned(lvModelle.Selected)))
  or ((PageControl1.ActivePage = tsSampleModels) and (not assigned(lvSamples.Selected ))) then
    Application.MessageBox(PChar(Translator.GetLit('ChooseAModel')),
                           PChar(dmMain.Translator.GetLit('ValidationErrorCaption')),
                           mb_IconStop + mb_Ok)
  else begin
    ModalResult := mrOk;
  end;

end;

procedure TfrmModellAuswahl.Label2Click(Sender: TObject);
begin
  btnCancel.Click;
  Hide;
  frmMain.miModellNeu.Click;
end;

procedure TfrmModellAuswahl.lvModelleDblClick(Sender: TObject);
begin
  btnOk.Click;
end;


procedure TfrmModellAuswahl.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  dmMain.CheckForSpecialKey(key, Shift, translator);
end;

procedure TfrmModellAuswahl.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

end.
