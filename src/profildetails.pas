unit profildetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, Menus,
  StdCtrls, profile, ProfilGraph, dxBar, ComCtrls,
  ImgList, Grids, BaseGrid, AdvGrid, idTranslator;

type
  TfrmProfilDetails = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    graPolare: TChart;
    Label1: TLabel;
    edProfilname: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    dxBarManager1: TdxBarManager;
    miReAdd: TdxBarButton;
    miReDel: TdxBarButton;
    miPolAdd: TdxBarButton;
    Series1: TFastLineSeries;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    pnlKoordGraph: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    dxBarDockControl1: TdxBarDockControl;
    lstRE: TListBox;
    Panel7: TPanel;
    Shape1: TShape;
    Panel5: TPanel;
    dxBarDockControl2: TdxBarDockControl;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    ImageList1: TImageList;
    miReEdit: TdxBarButton;
    miPolDel: TdxBarButton;
    dxBarDockControl3: TdxBarDockControl;
    miCoordAdd: TdxBarButton;
    miCoordDel: TdxBarButton;
    Label3: TLabel;
    Label4: TLabel;
    edAlpha0: TEdit;
    edCm0: TEdit;
    Label5: TLabel;
    miCoordImport: TdxBarButton;
    dlgImportKOO: TOpenDialog;
    miPolImport: TdxBarButton;
    dlgImportPEF: TOpenDialog;
    edProfilbez: TMemo;
    Label2: TLabel;
    tlKoord: TAdvStringGrid;
    tlPolaren: TAdvStringGrid;
    dxBarButton1: TdxBarButton;
    dlgExportKoo: TSaveDialog;
    translator: TidTranslator;
    procedure FormCreate(Sender: TObject);
    procedure lstREClick(Sender: TObject);
    procedure miReAddClick(Sender: TObject);
    procedure miReDelClick(Sender: TObject);
    procedure miPolAddClick(Sender: TObject);
    procedure miPolDelClick(Sender: TObject);
    procedure miReEditClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure miCoordAddClick(Sender: TObject);
    procedure miCoordDelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miCoordImportClick(Sender: TObject);
    procedure miPolImportClick(Sender: TObject);
    procedure tlKoordRowChanging(Sender: TObject; OldRow, NewRow: Integer;
      var Allow: Boolean);
    procedure tlKoordEditingDone(Sender: TObject);
    procedure tlPolarenEditingDone(Sender: TObject);
    procedure dxBarButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FProfil: TProfil;
    FKoordGraph: TProfilCoordPainter;
    FCurrentRE: integer;
    procedure LoadData;
    procedure UpdateProfilKoord;
    procedure SetProfil(const Value: TProfil);
    procedure LoadRE;
    procedure LoadWerte;
    procedure SaveWerte;
    procedure SetCurrentRE(const Value: integer);
    procedure UpdatePolarenGraph;
    procedure UpdateInfo;
  public
    { Public declarations }
    procedure SaveData;

    property Profil : TProfil read FProfil write SetProfil;
    property CurrentRE : integer read FCurrentRE write SetCurrentRE;
  end;

var
  frmProfilDetails: TfrmProfilDetails;

implementation

uses maindata;

{$R *.dfm}

{ TfrmProfilDetails }

procedure TfrmProfilDetails.LoadData;
var i : integer;
begin

  { Allgemein }
  Caption := Format('%s - %s', [Translator.GetLit('Caption'), Profil.Dateiname]);
  edProfilname.Text := Profil.Dateiname;
  edProfilbez.Lines.Text := Profil.Bezeichnung;

  { Koordinaten }
  tlKoord.Clear;
  tlKoord.RowCount := Profil.Koordinaten.Count + 1;
  tlKoord.Cells[0, 0] := 'x';
  tlKoord.Cells[1, 0] := 'y';
  if Profil.Koordinaten.Count > 0 then
    for i := 0 to pred(Profil.Koordinaten.Count) do begin
      //tlKoord.AddRow;
      tlKoord.Cells[0, i+1] := CurrToStr(Profil.Koordinaten.Items[i].x);
      tlKoord.Cells[1, i+1] := CurrToStr(Profil.Koordinaten.Items[i].y);
    end;

  { RE-Werte }
  LoadRE;

  FKoordGraph.Profil := Profil;
  UpdateInfo;
end;

procedure TfrmProfilDetails.SaveData;
begin
  Profil.Bezeichnung := edProfilbez.Lines.Text;
  UpdateProfilKoord;
end;

procedure TfrmProfilDetails.SetProfil(const Value: TProfil);
begin
  FProfil := Value;
  LoadData;
end;

procedure TfrmProfilDetails.FormCreate(Sender: TObject);
begin
  FKoordGraph := TProfilCoordPainter.Create(self);
  with FKoordGraph do begin
    parent := pnlKoordGraph;
    Align := alClient;
  end;
  PageControl1.ActivePage := TabSheet1;
  miPolAdd.ShortCut := TextToShortCut('F5');

end;

procedure TfrmProfilDetails.UpdateProfilKoord;
var
  i : integer;
  x, y: currency;
begin
  Profil.Koordinaten.Clear;

  if tlKoord.RowCount > 0 then
    for i := 1 to pred(tlKoord.RowCount) do begin
      if tlKoord.Cells[0, i] <> '' then
        x := StrToCurrDef(tlKoord.Cells[0, i], 0)
      else
        x := 0;
      if tlKoord.Cells[1, i] <> '' then
        y := StrToCurrDef(tlKoord.Cells[1, i], 0)
      else
        y := 0;
      Profil.Koordinaten.AddKoordinate(x,y);
    end;

  FKoordGraph.Update;
  UpdateInfo;
end;

procedure TfrmProfilDetails.UpdateInfo;
begin
  Profil.CalcAlpha0Cm0;
  edAlpha0.Text := CurrToStr(Profil.Alpha0);
  edCm0.Text := CurrToStr(Profil.cm0);
end;

procedure TfrmProfilDetails.LoadRE;
var
  i : integer;
begin
  lstRE.Clear;
  if Profil.Polaren.Count > 0 then
    for i := 0 to pred(Profil.Polaren.Count) do
      lstRE.AddItem(CurrToStr(Profil.Polaren.Items[i].re), Profil.Polaren.Items[i]);

  if lstRe.Count > 0 then
    lstRe.ItemIndex := 0;
  CurrentRE := lstRE.ItemIndex;
  LoadWerte;
  UpdatePolarenGraph;
end;

procedure TfrmProfilDetails.LoadWerte;
var
  i : integer;
begin
  tlPolaren.Clear;
  tlPolaren.Cells[0, 0] := translator.GetLit('PolarClCaption');
  tlPolaren.Cells[1, 0] := translator.GetLit('PolarCwCaption');

  if  (lstRe.ItemIndex > -1)
  and (assigned(lstRE.Items.Objects[lstRe.ItemIndex]))
  and (TRESet(lstRE.Items.Objects[lstRe.ItemIndex]).Count > 0) then
    for i := 0 to pred(TRESet(lstRE.Items.Objects[lstRe.ItemIndex]).Count) do begin
      tlPolaren.AddRow;
      tlPolaren.Cells[0, i+1] := CurrToStr(TRESet(lstRE.Items.Objects[lstRe.ItemIndex]).Items[i].ca);
      tlPolaren.Cells[1, i+1] := CurrToStr(TRESet(lstRE.Items.Objects[lstRe.ItemIndex]).Items[i].cw);
    end;

  if lstRe.ItemIndex > -1 then
    if TRESet(lstRE.Items.Objects[lstRe.ItemIndex]).Count > 0 then
      tlPolaren.RowCount := TRESet(lstRE.Items.Objects[lstRe.ItemIndex]).Count + 1
    else
      tlPolaren.RowCount := 2;

end;

procedure TfrmProfilDetails.SaveWerte;
var
  i : integer;
  TmpCW,
  TmpCA  : currency;
begin
  if CurrentRE < 0 then exit;
  if not assigned(lstRE.Items.Objects[CurrentRE]) then exit;

  TReSet(lstRE.Items.Objects[CurrentRE]).Clear;
  if tlPolaren.RowCount > 0 then
    for i := 1 to pred(tlPolaren.RowCount) do begin
      if tlPolaren.Cells[0, i] = '' then TmpCA := 0
      else TmpCA := StrToCurrDef(tlPolaren.Cells[0, i], 0);
      if tlPolaren.Cells[1, i] = '' then TmpCW := 0
      else TmpCW := StrToCurrDef(tlPolaren.Cells[1, i], 0);
      TReSet(lstRE.Items.Objects[CurrentRE]).Add(TmpCA, TmpCW);
    end;
  UpdatePolarenGraph;
end;

procedure TfrmProfilDetails.lstREClick(Sender: TObject);
begin
  CurrentRE := lstRE.ItemIndex;
end;

procedure TfrmProfilDetails.SetCurrentRE(const Value: integer);
begin
  if FCurrentRE <> Value then begin
    FCurrentRE := Value;
    LoadWerte;
  end;
end;

procedure TfrmProfilDetails.UpdatePolarenGraph;
var
  iRE,
  iWert : integer;
  Serie : TLineSeries;
begin
  graPolare.SeriesList.Clear;

  if Profil.Polaren.Count > 0 then
    for iRE := 0 to pred(Profil.Polaren.Count) do begin
      Serie := TLineSeries.Create(self);
      with Serie do begin
        Title := Format('%s = %s',
          [translator.GetLit('Re'),
           CurrToStr(Profil.Polaren.Items[iRE].re)]);
        Active := true;
        LinePen.Width := 1;
        case iRe of
          0 : SeriesColor := clNavy;
          1 : SeriesColor := clBlack;
          2 : SeriesColor := clRed;
          3 : SeriesColor := clTeal;
          4 : SeriesColor := clGreen;
          5 : SeriesColor := clMaroon;
        end;
        ParentChart := graPolare;
        XValues.Order := loNone;
        YValues.Order := loNone;
      end;

      if Profil.Polaren.Items[iRE].Count > 0 then
        for iWert := 0 to pred(Profil.Polaren.Items[iRE].Count) do begin
          if Profil.Polaren.Items[iRE].Items[iWert].cw = 0 then
            Serie.AddNullXY(Profil.Polaren.Items[iRE].Items[iWert].cw * 1000,
                        Profil.Polaren.Items[iRE].Items[iWert].ca,
                        '')
          else
            Serie.AddXY(Profil.Polaren.Items[iRE].Items[iWert].cw * 1000,
                        Profil.Polaren.Items[iRE].Items[iWert].ca,
                        '');
        end;

    end;
end;

procedure TfrmProfilDetails.miReAddClick(Sender: TObject);
var
  NewRE : string;
  cNewRE : currency;
  ReSet: TRESet;
begin
  if InputQuery(translator.GetLit('AddReCaption'), translator.GetLit('AddReText'), NewRE) then begin
    cNewRE := StrToCurrDef(NewRe, -1);
    if cNewRE = -1 then
      dmMain.ShowValidationError(dmMain.Translator.GetLit('ValidationInvalidReValue'))
    else begin
      ReSet := Profil.Polaren.Add(cNewRE);
      LoadRE;
      lstRE.ItemIndex := lstRE.Items.IndexOfObject(ReSet);
      CurrentRE := lstRE.ItemIndex;
    end;
  end;
end;

procedure TfrmProfilDetails.miReDelClick(Sender: TObject);
begin
  if  (lstRE.ItemIndex > -1)
  and (Application.MessageBox(PChar(
                                Format(translator.GetLit('DeleteRe'),
                                       [CurrToStr(TReSet(lstRE.Items.Objects[lstRE.ItemIndex]).re)])),
                               PChar(translator.GetLit('DeleteReCaption')),
                               mb_IconWarning + mb_YesNo
                               ) = idYes) then
  begin
    Profil.Polaren.Remove(TReSet(lstRE.Items.Objects[CurrentRE]));
    LoadRE;
    if lstRe.Count > 0 then CurrentRE := 0
    else CurrentRE := -1;
    lstRe.ItemIndex := CurrentRE;
  end;
end;

procedure TfrmProfilDetails.miPolAddClick(Sender: TObject);
begin
  if tlPolaren.RowCount > 1 then
    tlPolaren.InsertRows(tlPolaren.Row+1, 1)
  else
    tlPolaren.AddRow;
  tlPolaren.EditMode := true;
end;

procedure TfrmProfilDetails.miPolDelClick(Sender: TObject);
begin
  if tlPolaren.RowCount > 1 then
    tlPolaren.RemoveRows(tlPolaren.Row, 1);
end;

procedure TfrmProfilDetails.miReEditClick(Sender: TObject);
var
  NewRE : string;
  cNewRE : currency;
  idx : integer;
begin
  if lstRE.ItemIndex < 0 then exit;

  if InputQuery(translator.GetLit('EditReCaption'), translator.GetLit('EditReText'), NewRE) then begin
    cNewRE := StrToCurrDef(NewRe, -1);
    if cNewRE = -1 then
      dmMain.ShowValidationError(dmMain.Translator.GetLit('ValidationInvalidReValue'))
    else begin
      idx := lstRE.ItemIndex;
      TReSet(lstRE.Items.Objects[idx]).re := cNewRE;
      LoadRE;
      lstRE.ItemIndex := idx;
      CurrentRE := lstRE.ItemIndex;
    end;
  end;
end;

procedure TfrmProfilDetails.btnOkClick(Sender: TObject);
begin
  SaveData;
  ModalResult := mrOk;
end;

procedure TfrmProfilDetails.miCoordAddClick(Sender: TObject);
begin
  if tlKoord.RowCount > 1 then
    tlKoord.InsertRows(tlKoord.Row+1, 1)
  else
    tlKoord.AddRow;
  tlKoord.EditorMode := true;
end;

procedure TfrmProfilDetails.miCoordDelClick(Sender: TObject);
begin
  if tlKoord.RowCount > 1 then
    tlKoord.RemoveRows(tlKoord.Row, 1);
end;

procedure TfrmProfilDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_F6 then begin
    if ActiveControl = tlKoord then miCoordAdd.Click;
    if ActiveControl = lstRE then miReAdd.Click else
    if ActiveControl = tlPolaren then miPolAdd.Click;
    Key := 0;
  end else
  if Key = vk_F8 then begin
    if ActiveControl = tlKoord then miCoordDel.Click else
    if ActiveControl = lstRE then miReDel.Click else
    if ActiveControl = tlPolaren then miPolDel.Click;
    Key := 0;
  end else begin
    dmMain.CheckForSpecialKey(key, Shift, translator);
  end;
end;

procedure TfrmProfilDetails.miCoordImportClick(Sender: TObject);
begin
  if dlgImportKOO.Execute then begin
    SaveData;
    Profil.LoadKOO(dlgImportKOO.FileName);
    LoadData;
  end;
end;

procedure TfrmProfilDetails.miPolImportClick(Sender: TObject);
begin
  if dlgImportPEF.Execute then begin
    SaveData;
    Profil.LoadPEF(dlgImportPEF.FileName);
    LoadData;
  end;
end;

procedure TfrmProfilDetails.tlKoordRowChanging(Sender: TObject; OldRow,
  NewRow: Integer; var Allow: Boolean);
begin
  FKoordGraph.SelectedIndex := NewRow -1;
end;

procedure TfrmProfilDetails.tlKoordEditingDone(Sender: TObject);
begin
  UpdateProfilKoord;
end;

procedure TfrmProfilDetails.tlPolarenEditingDone(Sender: TObject);
begin
  SaveWerte;
end;

procedure TfrmProfilDetails.dxBarButton1Click(Sender: TObject);
begin
  dlgExportKoo.FileName:= Profil.ProfilName + '.koo';
  if dlgExportKoo.Execute then begin
    Profil.ExportToKooFile(dlgExportKoo.FileName);
    Application.MessageBox(PChar(Format(translator.GetLit('CoordiantesExportedSuccessfullyMessage'), [dlgExportKoo.FileName])),
                           PChar(translator.GetLit('CoordiantesExportedSuccessfullyCaption')),
                           mb_IconInformation);
  end;
end;

procedure TfrmProfilDetails.FormShow(Sender: TObject);
begin
  translator.RefreshTranslation();
end;

end.
