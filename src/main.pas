unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, dxBar, idFrameContainer,
  xmldom, XMLIntf, msxmldom, XMLDoc, ImgList, dxBarExtItems, XPMan, ActnList,
  StdCtrls, Buttons, dxsbar, varianten,
  chBasics, chWingGeo, chGraphic, chFunctions, Placemnt, idTranslator,
  idWebupdate;

const
  { Framenames }
  fainBasics = 'faiBasics';
  fainWingGeo = 'faiWingGeo';
  fainFunctions = 'faiFunctions';

type
  TChildPages = ( pagBasics, pagWingGeo, pagFunctions );
  TTEC = ( tecOk, tecInvalidMF, tecInvalidExe, tecExpDate, tecMFNotFound, tecOther );

  TLanguageItem = class
  private
    FLanguageCode: string;
  public
    property LangCode: string read FLanguageCode write FLanguageCode;
  end;

  TfrmMain = class(TForm)
    dxBarManager1: TdxBarManager;
    pnlWorkspace: TPanel;
    miExit: TdxBarButton;
    Splitter1: TSplitter;
    pnlDetail: TPanel;
    miProfile: TdxBarSubItem;
    miModell: TdxBarSubItem;
    miHelp: TdxBarSubItem;
    miAbout: TdxBarButton;
    miModellNeu: TdxBarButton;
    miVariante: TdxBarSubItem;
    miModellLoeschen: TdxBarButton;
    miProfilBearbeiten: TdxBarButton;
    miHilfeUpdate: TdxBarButton;
    miVarianteNeu: TdxBarButton;
    miVarianteLoeschen: TdxBarButton;
    miVarianteModellauslegungAnzeigen: TdxBarButton;
    miVarianteModellauslegungDrucken: TdxBarButton;
    ImageList1: TImageList;
    ImageList2: TImageList;
    miAnsicht: TdxBarSubItem;
    miViewModellauslegung: TdxBarButton;
    miViewNeutralpunkte: TdxBarButton;
    Panel1: TPanel;
    Label1: TLabel;
    lbVariante: TLabel;
    cmbVariante: TComboBoxEx;
    edModell: TEdit;
    Image1: TImage;
    Image2: TImage;
    miStatModell: TdxBarEdit;
    miStatVariante: TdxBarEdit;
    miStatAltered: TdxBarStatic;
    miModellSpeichern: TdxBarButton;
    lbModellBeschreibung: TLabel;
    btnModellBeschreibung: TSpeedButton;
    ImageList3: TImageList;
    miModellLoad: TdxBarButton;
    lblVarBeschr: TLabel;
    btnVariantenBeschreibung: TSpeedButton;
    edModBeschr: TEdit;
    edVarBeschr: TEdit;
    Sidebar: TdxSideBar;
    XPManifest1: TXPManifest;
    miHelpWeb: TdxBarSubItem;
    miHelpWebMan: TdxBarButton;
    miHelpForum: TdxBarButton;
    miHelpWebProduct: TdxBarButton;
    miHelpWebIdev: TdxBarButton;
    miViewFunctions: TdxBarButton;
    miModellGraphicOverview: TdxBarButton;
    SpeedButton1: TSpeedButton;
    miSenden: TdxBarButton;
    dlgExportModel: TSaveDialog;
    miExport: TdxBarButton;
    miImport: TdxBarButton;
    dlgImportModel: TOpenDialog;
    miReadOnly: TdxBarStatic;
    miLicence: TdxBarButton;
    TECTimer: TTimer;
    FormPlacement1: TFormPlacement;
    MainTranslator: TidTranslator;
    dxBarButton1: TdxBarButton;
    miWingDesigner: TdxBarSubItem;
    miWDImportTragflaeche: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    miWDImportHlw: TdxBarButton;
    miWDExportTragflaeche: TdxBarButton;
    miWDExportHlw: TdxBarButton;
    miLanguageList: TdxBarListItem;
    miLanguage: TdxBarSubItem;
    pnlUpdateAvailable: TPanel;
    Shape1: TShape;
    lblUpdateAvailableCaption: TLabel;
    lblAvailableVersionText: TLabel;
    lblInstalledVersionText: TLabel;
    lblAvailableVersion: TLabel;
    lblInstalledVersion: TLabel;
    Image3: TImage;
    btnDownloadAndInstallUpdate: TBitBtn;
    lblUpdateReleaseNotes: TLabel;
    miAutoCheckForUpdates: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton2: TdxBarButton;
    miOrder: TdxBarButton;
    procedure acExitExecute(Sender: TObject);
    procedure miViewModellauslegungClick(Sender: TObject);
    procedure miViewNeutralpunkteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnModellBeschreibungClick(Sender: TObject);
    procedure miModellSpeichernClick(Sender: TObject);
    procedure miModellNeuClick(Sender: TObject);
    procedure miModellLoadClick(Sender: TObject);
    procedure miVarianteNeuClick(Sender: TObject);
    procedure miVarianteLoeschenClick(Sender: TObject);
    procedure fraModellVariante1edProfilInnenChange(Sender: TObject);
    procedure cmbVarianteSelect(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miAboutClick(Sender: TObject);
    procedure miProfilBearbeitenClick(Sender: TObject);
    procedure miModellLoeschenClick(Sender: TObject);
    procedure btnVariantenBeschreibungClick(Sender: TObject);
    procedure SidebarItemClick(Sender: TObject; Item: TdxSideBarItem);
    procedure miHilfeUpdateClick(Sender: TObject);
    procedure miHelpWebProductClick(Sender: TObject);
    procedure miHelpWebIdevClick(Sender: TObject);
    procedure miViewFunctionsClick(Sender: TObject);
    procedure miModellGraphicOverviewClick(Sender: TObject);
    procedure miSendenClick(Sender: TObject);
    procedure miExportClick(Sender: TObject);
    procedure miImportClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure miWDImportTragflaecheClick(Sender: TObject);
    procedure miWDExportTragflaecheClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miLanguageListClick(Sender: TObject);
    procedure MainTranslatorTranslate(Sender: TObject);
    procedure btnDownloadAndInstallUpdateClick(Sender: TObject);
    procedure lblUpdateReleaseNotesClick(Sender: TObject);
    procedure miAutoCheckForUpdatesClick(Sender: TObject);
  private
    { Private declarations }
    FAltered: boolean;
    FrameContainer: TidFrameContainer;
    procedure SetAltered(const Value: boolean);
    procedure UpdateUI;
    function GetFraBasics: TfraBasics;
    function GetFraWingGeo: TfraWingGeo;
    function GetFraFunctions: TfraFunctions;
    procedure UpdateHeaderData;
    procedure FillLanguages;
    function CheckForUpdate: boolean;
    function CreateLiftoffWebupdate: TidWebUpdate;
  public
    { Public declarations }
    IsUpdateing: boolean;
    procedure SetPage(AChilPage: TChildPages);
    function  CheckForSave: boolean; // True = Ok, False = Abbrechen, die Daten konnten nicht gespeichert werden
    procedure EnableModell(AEnabled: boolean);
    procedure ChangedData;
    procedure StartUpAfterTranslationIsReady;

    function  LoadModell(AModellFileName: string) : boolean;
    function  SaveModell : boolean;
    function  NewModell : boolean;
    function  LoadData: boolean; // Daten aus TModell und TVariante in Controls laden
    function  SaveData: boolean; // Daten von Controls in TVariante und TModell speichern
    function  Validate: boolean; // Validieren
    procedure Import( _fileName: string; _silent: boolean = false  ); // Modell aus _filename importieren

    procedure ShowModelGraficWindow( AOnTop: boolean; AHidWindow: boolean = false );
    procedure UpdateModelGraphics;

    { Direct frame links }
    property fraBasics: TfraBasics read GetFraBasics;
    property fraWingGeo: TfraWingGeo read GetFraWingGeo;
    property fraFunctions: TfraFunctions read GetFraFunctions;

    { Root business logic }
    procedure AddVariante(AVariante: TModellVariante);

    property  Altered: boolean read FAltered write SetAltered;
  end;

var
  frmMain: TfrmMain;

var
  TEC: TTEC;

implementation

{$R *.dfm}

uses inifiles, ad_consts, modell, id_string, modellauswahl, versinfo,
  textedit, modellneu, splash, profileverwaltung, varianteneu,
  id_tools, modellgraphic, modelpainter, mapi, logging, maindata,
  WingDesignerInterface, configuration;


procedure TfrmMain.StartUpAfterTranslationIsReady;
begin
  FillLanguages;
end;

procedure TfrmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.SetPage(AChilPage: TChildPages);
begin

  case AChilPage of

    pagBasics:
      begin
        FrameContainer.ActiveFrameItem := FrameContainer.Frames.ByName[fainBasics];
        Sidebar.SelectedItem := Sidebar.Groups[0].Items[0];
        miViewModellauslegung.Down := true;
        if assigned( frmModelGraphic ) then begin
          frmModelGraphic.Painter.DrawMode:= dmSimple;
        end;
      end;

    pagWingGeo:
      begin
        FrameContainer.ActiveFrameItem := FrameContainer.Frames.ByName[fainWingGeo];
        Sidebar.SelectedItem := Sidebar.Groups[0].Items[1];
        miViewNeutralpunkte.Down := true;
        fraWingGeo.PageControl.ActivePageIndex:= 0;
        if assigned( frmModelGraphic ) then begin
          frmModelGraphic.Painter.DrawMode:= dmDetailed;
        end;
      end;

    pagFunctions:
      begin
        FrameContainer.ActiveFrameItem := FrameContainer.Frames.ByName[fainFunctions];
        Sidebar.SelectedItem := Sidebar.Groups[0].Items[2];
        miViewFunctions.Down := true;
      end;

    else
      Assert(false, 'ChildPage not implemented yet!');
  end;

end;

procedure TfrmMain.miViewModellauslegungClick(Sender: TObject);
begin
  SetPage(pagBasics);
end;

procedure TfrmMain.miViewNeutralpunkteClick(Sender: TObject);
begin
  SetPage(pagWingGeo);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  Caption:= ProgramName;

  FrameContainer := TidFrameContainer.Create(pnlDetail);
  with FrameContainer do begin
    Parent := pnlDetail;
    Align := alClient;
    Name := 'ChildFrames';
  end;

  FrameContainer.Frames.Clear;
  with FrameContainer.Frames.Add do begin
    Name := fainBasics;
    FrameClass := TfraBasics;
  end;
  with FrameContainer.Frames.Add do begin
    Name := fainWingGeo;
    FrameClass := TfraWingGeo;
  end;
  with FrameContainer.Frames.Add do begin
    Name := fainFunctions;
    FrameClass := TfraFunctions;
  end;
  FrameContainer.ActiveFrameItem := FrameContainer.Frames.ByName[fainBasics];
  SetPage(pagBasics);

  IsUpdateing := false;
  CurrentModell := TModell.Create;

  miViewModellauslegungClick(self);
  FAltered := false;

  EnableModell(false);

  miAutoCheckForUpdates.Down := GlobalConfig.AutoCheckForUpdates;
  if (GlobalConfig.AutoCheckForUpdates) then CheckForUpdate();
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  miModellLoad.Click;
end;

function TfrmMain.CheckForSave: boolean;
var
  MsgRes : integer;
begin
  result := true;
  if FAltered then begin
     MsgRes := Application.MessageBox(PChar(
        Format(MainTranslator.GetLit('SaveChangesMessage'),
               [edModell.Text]
        )
      ),
      PAnsiChar(MainTranslator.GetLitDef('SaveChangesCaption', 'Änderungen speichern')),
      mb_IconQuestion + mb_YesNoCancel);
     case MsgRes of
       id_Yes    : if not SaveModell then result := false;
       id_No     : ;
       id_Cancel : result := false;
       else        assert(false, 'Unknown Message Result!');
     end;
  end;
end;

function TfrmMain.LoadModell(AModellFileName: string): boolean;
begin
  IsUpdateing:= true;
  try
    result :=  CurrentModell.Load(AModellFileName);
    if result then EnableModell(true);
    UpdateModelGraphics
  finally
    Altered := false;
    IsUpdateing:= false;
  end;
end;

function TfrmMain.SaveModell: boolean;
begin
  result := false;
  IsUpdateing:= true;
  Screen.Cursor := crHourGlass;
  try
    if SaveData then begin
      CurrentModell.Save;
      result := true;
      Altered := false;
    end;
  finally
    IsUpdateing:= false;
    Screen.Cursor := crDefault;
  end;
end;


procedure TfrmMain.btnModellBeschreibungClick(Sender: TObject);
var s : string;
begin
  s := CurrentModell.ModellBezeichnung;
  if frmTextEdit.Execute(MainTranslator.GetLit('AirplaneDescription'), s) then begin
    CurrentModell.ModellBezeichnung := s;
    Altered := true;
    UpdateHeaderData;
  end;
end;

procedure TfrmMain.miModellSpeichernClick(Sender: TObject);
begin
  SaveModell;
end;

function TfrmMain.NewModell: boolean;
var
  frmModellNeu : TfrmModellNeu;
begin
  if CheckForSave then begin
    frmModellNeu := TfrmModellNeu.Create(self);
    try
      if frmModellNeu.ShowModal = idOk then begin
        IsUpdateing:= true;
        try
          if assigned(CurrentModell) then FreeAndNil(CurrentModell);
          CurrentModell := TModell.Create;
          CurrentModell.DoNotSaveOnNextSetVariante:= true;
          result := CurrentModell.New(frmModellNeu.edModellName.Text,
                                      frmModellNeu.edVariantenName.Text);
          if result then begin
            LoadData;
            Altered := true;
            EnableModell(true);
          end;
        finally
          IsUpdateing:= false;
        end;
      end;
    finally
      FreeAndNil(frmModellNeu);
    end;
  end;
  UpdateHeaderData;
  result:= true;
end;

procedure TfrmMain.AddVariante(AVariante: TModellVariante);
begin
  with cmbVariante do begin
    ItemsEx.AddItem(AVariante.VariantenName, 0, 0, -1, -1, AVariante);
  end;
end;

procedure TfrmMain.SetAltered(const Value: boolean);
begin
  UpdateModelGraphics;
  if FAltered <> Value then begin
    FAltered := Value;
    miStatAltered.Enabled := FAltered;
    miModellSpeichern.Enabled := FAltered;
  end;
end;

procedure TfrmMain.EnableModell(AEnabled: boolean);
begin
  cmbVariante.Enabled := AEnabled;
  if cmbVariante.Enabled then cmbVariante.Color := clWindow
  else cmbVariante.Color := clBtnFace;
  fraBasics.Enabled := AEnabled;
  fraWingGeo.Enabled := AEnabled;
  fraFunctions.Enabled := AEnabled;
  btnModellBeschreibung.Enabled := AEnabled;
  lbVariante.Enabled := AEnabled;
  lbModellBeschreibung.Enabled := AEnabled;
  FrameContainer.Visible := AEnabled;
  miVariante.Enabled := AEnabled;
  miModellSpeichern.Enabled := AEnabled;
  miModellLoeschen.Enabled := AEnabled;
  miSenden.Enabled:= AEnabled;
  miExport.Enabled:= AEnabled;
  lblVarBeschr.Enabled := AEnabled;
  edVarBeschr.Enabled := AEnabled;
  btnVariantenBeschreibung.Enabled := AEnabled;
  miWingDesigner.Enabled := AEnabled;

  if not AEnabled then begin
    edModell.Text := '';
    cmbVariante.Clear;
    cmbVariante.ItemIndex := -1;
  end;
end;

procedure TfrmMain.miModellNeuClick(Sender: TObject);
begin
  NewModell;
end;

function TfrmMain.LoadData: boolean;
begin
  result := true;
  edModell.Text := CurrentModell.ModellName;
  UpdateHeaderData;
  if not fraBasics.LoadData then result := false;
  if not fraWingGeo.LoadData then result := false;
  if not fraFunctions.LoadData then result := false;
  UpdateModelGraphics;
end;

procedure TfrmMain.UpdateHeaderData;
begin
  if assigned(CurrentModell) then begin
    edModBeschr.Text := CurrentModell.ModellBezeichnung;
    if assigned(CurrentModell.Variante) then
      edVarBeschr.Text := CurrentModell.Variante.VariantenBeschreibung
    else
      edVarBeschr.Text := '';
  end else begin
    edModBeschr.Text := '';
    edVarBeschr.Text := '';
  end;
end;

function TfrmMain.SaveData: boolean;
begin
  result := true;
  if not fraBasics.SaveData then result := false;
  if not fraWingGeo.SaveData then result := false;
  if not fraFunctions.SaveData then result := false;
end;

procedure TfrmMain.miModellLoadClick(Sender: TObject);
var
  path: string;
begin
  frmModellAuswahl.FillData;
  if frmModellAuswahl.ShowModal = mrOk then begin
    if frmModellAuswahl.PageControl1.ActivePage = frmModellAuswahl.tsOwnModels then
      path:= ModellPath + frmModellAuswahl.lvModelle.Selected.Caption + ModellFileExt
    else
      path:= SmpModellPath + frmModellAuswahl.lvSamples.Selected.Caption + ModellFileExt;
    LoadModell( path );
  end;
end;

procedure TfrmMain.miVarianteNeuClick(Sender: TObject);
var
  frmVarNew : TfrmVarianteNeu;
begin
  frmVarNew := TfrmVarianteNeu.Create(self);
  try
    if frmVarNew.ShowModal = idOk then begin
      IsUpdateing := true;
      try
        CurrentModell.DontLoadDataNextTime := frmVarNew.cbCopyValues.Checked;
        CurrentModell.DoNotSaveOnNextSetVariante := true;
        CurrentModell.Variante := CurrentModell.Varianten.AddVariante(frmVarNew.edVariantenName.Text);
        SaveData;
      finally
        IsUpdateing:= false;
        Altered := true;
      end;
    end;
  finally
    FreeAndNil(frmVarNew);
  end;
end;

procedure TfrmMain.miVarianteLoeschenClick(Sender: TObject);
begin
  if CurrentModell.Varianten.Count < 2 then
    Application.MessageBox(PAnsiChar(MainTranslator.GetLit('DeleteLastVersionNotAllowed')),
                           PAnsiChar(MainTranslator.GetLit('DeleteVersionCaption')),
                           mb_IconStop + mb_Ok)
  else
  if Application.MessageBox(PAnsiChar(Format(MainTranslator.GetLit('DeleteVersionMessage'), [CurrentModell.Variante.VariantenName])),
                            PAnsiChar(MainTranslator.GetLit('DeleteVersionCaption')),
                            mb_IconWarning + mb_YesNo) = idYes then
  begin
    CurrentModell.Varianten.DeleteVariante(CurrentModell.Variante);
    Altered := true;
  end;
end;

procedure TfrmMain.fraModellVariante1edProfilInnenChange(Sender: TObject);
begin
  ChangedData;
end;

procedure TfrmMain.ChangedData;
begin
  if not IsUpdateing then Altered := true;
end;

procedure TfrmMain.cmbVarianteSelect(Sender: TObject);
var
  NewVar : TModellVariante;
begin
  NewVar := TModellVariante(cmbVariante.Items.Objects[cmbVariante.ItemIndex]);
  if NewVar <> CurrentModell.Variante then begin
    CurrentModell.Variante := NewVar;
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckForSave;
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
var
  OrigW, OrigH : integer;
begin
  frmSplash := TfrmSplash.Create(self);
  try
    with frmSplash do begin
      OrigW := ClientWidth;
      OrigH := ClientHeight;
      BorderStyle := bsDialog;
      FormStyle := fsNormal;
      ClientWidth := OrigW;
      ClientHeight := OrigH;
      Shape1.Visible := false;
      frmSplash.ShowModal;
    end;
  finally
    FreeAndNil(frmSplash);
  end;
end;

procedure TfrmMain.UpdateUI;
begin
  UpdateHeaderData;
end;

procedure TfrmMain.miProfilBearbeitenClick(Sender: TObject);
begin
  frmProfileMan := TfrmProfileMan.Create(self);
  try
    frmProfileMan.ShowModal;
  finally
    FreeAndNil(frmProfileMan);
  end;
end;

function TfrmMain.GetFraBasics: TfraBasics;
begin
  result := TfraBasics(FrameContainer.Frames.ByName[fainBasics].Frame);
end;

function TfrmMain.GetFraWingGeo: TfraWingGeo;
begin
  result := TfraWingGeo(FrameContainer.Frames.ByName[fainWingGeo].Frame);
end;

function TfrmMain.GetFraFunctions: TfraFunctions;
begin
  result := TfraFunctions(FrameContainer.Frames.ByName[fainFunctions].Frame);
end;

procedure TfrmMain.miModellLoeschenClick(Sender: TObject);
begin
  if  (assigned(CurrentModell))
  and (Application.MessageBox(PAnsiChar(Format(MainTranslator.GetLit('DeleteAirplaneMessage'), [CurrentModell.ModellName])),
                              PAnsiChar(MainTranslator.GetLit('DeleteAirplaneCaption')),
                              mb_IconWarning + mb_YesNo) = idYes) then
  begin
    CurrentModell.Delete;
    Altered := false;
    EnableModell(false);
  end;
end;

procedure TfrmMain.btnVariantenBeschreibungClick(Sender: TObject);
var s : string;
begin
  if (not assigned(CurrentModell))
  or (not assigned(CurrentModell.Variante)) then exit;

  s := CurrentModell.Variante.VariantenBeschreibung;
  if frmTextEdit.Execute(MainTranslator.GetLitDef('VersionDescription', 'Variantenbeschreibung'), s) then
    if s <> CurrentModell.Variante.VariantenBeschreibung then begin
      CurrentModell.Variante.VariantenBeschreibung := s;
      Altered := true;
      UpdateHeaderData;
    end;
end;

procedure TfrmMain.SidebarItemClick(Sender: TObject; Item: TdxSideBarItem);
begin
  case Item.Tag of
    1 : miViewModellauslegung.Click;
    2 : miViewNeutralpunkte.Click;
    4 : miViewFunctions.Click;
    else assert( false );
  end;
end;

function TfrmMain.CreateLiftoffWebupdate : TidWebUpdate;
begin
  result := TidWebUpdate.Create(nil);
  if (LowerCase(GlobalConfig.Language) = 'de') then result.Texts.SetGermanTexts;
  result.LocalVersion := ProgVersion;
  result.UpdateInfoFileURL := TheLiftoffUpdateURL;
end;

function TfrmMain.CheckForUpdate() : boolean;
var
  webUpdate : TidWebUpdate;
  updateAvailable : boolean;
begin
  webUpdate := CreateLiftoffWebupdate();
  try
    updateAvailable := webUpdate.IsUpdateAvailable(true);

    if (updateAvailable) then begin
      lblAvailableVersion.Caption := webUpdate.AvailableVersion;
      lblInstalledVersion.Caption := webUpdate.LocalVersion;
      lblUpdateReleaseNotes.Hint := webUpdate.ReadMeURL;
    end;

    pnlUpdateAvailable.Visible := updateAvailable;
  finally
    FreeAndNil(WebUpdate);
  end;
end;

procedure TfrmMain.lblUpdateReleaseNotesClick(Sender: TObject);
begin
  OpenFile(lblUpdateReleaseNotes.Hint);
end;

procedure TfrmMain.miHilfeUpdateClick(Sender: TObject);
var
  WebUpdate : TidWebUpdate;
begin

  if  (Altered)
  and (Application.MessageBox(PAnsiChar(MainTranslator.GetLit('UpdateCheckSaveMessage')),
                              PAnsiChar(MainTranslator.GetLit('UpdateCheckSaveCaption')),
                              mb_IconWarning + mb_YesNo) = idYes) then
  begin
    SaveModell;
  end;

  if not Altered then begin
    WebUpdate := CreateLiftoffWebupdate();
    try
      WebUpdate.IsUpdateAvailable;
    finally
      FreeAndNil(WebUpdate);
    end;
  end;
end;

procedure TfrmMain.btnDownloadAndInstallUpdateClick(Sender: TObject);
var
  WebUpdate : TidWebUpdate;
begin

  if  (Altered)
  and (Application.MessageBox(PAnsiChar(MainTranslator.GetLit('UpdateCheckSaveMessage')),
                              PAnsiChar(MainTranslator.GetLit('UpdateCheckSaveCaption')),
                              mb_IconWarning + mb_YesNo) = idYes) then
  begin
    SaveModell;
  end;

  if not Altered then begin
    WebUpdate := CreateLiftoffWebupdate();
    try
      WebUpdate.IsUpdateAvailable(true);
      WebUpdate.DownloadAndExecuteUpdate();
    finally
      FreeAndNil(WebUpdate);
    end;
  end;
end;

procedure TfrmMain.miHelpWebProductClick(Sender: TObject);
begin
  OpenFile(WebSiteProduct);
end;

procedure TfrmMain.miHelpWebIdevClick(Sender: TObject);
begin
  OpenFile(WebSiteCompany);
end;

procedure TfrmMain.miViewFunctionsClick(Sender: TObject);
begin
  SetPage( pagFunctions );
end;

function TfrmMain.Validate: boolean;
begin
  result:= fraBasics.Validate and
           fraWingGeo.Validate {and
           fraHolm.Validete};
end;

procedure TfrmMain.UpdateModelGraphics;
begin
  if assigned( frmModelGraphic ) then begin
    if FrameContainer.ActiveFrameItem = FrameContainer.Frames.ByName[fainBasics] then begin
      frmModelGraphic.Painter.DrawMode:= dmSimple;
    end else begin
      frmModelGraphic.Painter.DrawMode:= dmDetailed;
    end;

    frmModelGraphic.Painter.ModellVariante:= CurrentModell.Variante;
    frmModelGraphic.Painter.NeedsUpdate;
  end;

end;

procedure TfrmMain.ShowModelGraficWindow( AOnTop: boolean; AHidWindow: boolean = false );
var
  frmModelGraphicLarge: TfrmModelGraphic;
begin
  if AOnTop then begin
    frmModelGraphicLarge:= TfrmModelGraphic.Create( self );
    try
      frmModelGraphicLarge.Position:= poScreenCenter;
      frmModelGraphicLarge.BorderStyle:= bsSizeable;
      frmModelGraphicLarge.miShowGrid.Click;
      frmModelGraphicLarge.miAlwaysOnTop.Visible:= ivNever;
      frmModelGraphicLarge.dxBarManager1.Bars[1].Row:= 0;
      if FrameContainer.ActiveFrameItem = FrameContainer.Frames.ByName[fainBasics] then begin
        frmModelGraphicLarge.Painter.DrawMode:= dmSimple;
      end else begin
        frmModelGraphicLarge.Painter.DrawMode:= dmDetailed;
      end;
      frmModelGraphicLarge.Painter.ModellVariante:= CurrentModell.Variante;
      frmModelGraphicLarge.Painter.NeedsUpdate;

      frmModelGraphicLarge.Top:= 0;
      frmModelGraphicLarge.Left:= 0;
      frmModelGraphicLarge.WindowState:= wsMaximized;

      frmModelGraphicLarge.ShowModal;
    finally
      FreeAndNil( frmModelGraphicLarge );
    end;
  end else begin
    if not AHidWindow then begin
      if not assigned( frmModelGraphic ) then begin
        frmModelGraphic:= TfrmModelGraphic.Create( self );
      end;
      frmModelGraphic.Top:= 0;
      frmModelGraphic.Left:= Screen.Width - frmModelGraphic.Width;
      UpdateModelGraphics;
      frmModelGraphic.Show;
      frmModelGraphic.BringToFront;
    end else begin
      FreeAndNil( frmModelGraphic );
    end;
  end;
end;

procedure TfrmMain.miModellGraphicOverviewClick(Sender: TObject);
begin
  if miModellGraphicOverview.Down then begin
    ShowModelGraficWindow( false, false );
  end else begin
    ShowModelGraficWindow( false, true );
  end;
end;

procedure TfrmMain.miSendenClick(Sender: TObject);
type 
  TAttachAccessArray = array [0..0] of TMapiFileDesc; 
  PAttachAccessArray = ^TAttachAccessArray; 
var 
  MapiMessage: TMapiMessage; 
  Receip: TMapiRecipDesc; 
  Attachments: PAttachAccessArray; 
  dwRet: Cardinal;
  MAPI_Session: Cardinal;
  WndList: Pointer;
begin 
  dwRet := MapiLogon(Handle, 
    PChar(''),
    PChar(''), 
    MAPI_LOGON_UI or MAPI_NEW_SESSION, 
    0, @MAPI_Session); 

  if (dwRet <> SUCCESS_SUCCESS) then 
  begin 
    MessageBox(Handle, 
      PAnsiChar(MainTranslator.GetLit('MapiLogonFailt')),
      PAnsiChar(MainTranslator.GetLit('SendByEmailCaption')),
      MB_ICONERROR or MB_OK);
  end
  else 
  begin 
    FillChar(MapiMessage, SizeOf(MapiMessage), #0); 
    Attachments := nil; 
    FillChar(Receip, SizeOf(Receip), #0);
    GetMem(Attachments, SizeOf(TMapiFileDesc) * 1);
    Attachments[0].ulReserved:= 0;
    Attachments[0].flFlags:= 0;
    Attachments[0].nPosition:= ULONG($FFFFFFFF);
    Attachments[0].lpszPathName:= StrNew(PChar(CurrentModell.ModFileName));
    Attachments[0].lpszFileName:= StrNew(PChar(ExtractFileName(CurrentModell.ModFileName)));
    Attachments[0].lpFileType:= nil;
    MapiMessage.nFileCount := 1;
    MapiMessage.lpFiles := @Attachments^;

    MapiMessage.lpszSubject := StrNew(PChar( CurrentModell.ModellName ));
    MapiMessage.lpszNoteText := StrNew(PChar( '<see Attachment>' ));

    WndList:= DisableTaskWindows(0);
    try
      MapiSendMail(MAPI_Session, Handle, MapiMessage, MAPI_DIALOG, 0);
    finally
      EnableTaskWindows( WndList );
    end;

    StrDispose(Attachments[0].lpszPathName);
    StrDispose(Attachments[0].lpszFileName);

    if Assigned(MapiMessage.lpszSubject) then StrDispose(MapiMessage.lpszSubject);
    if Assigned(MapiMessage.lpszNoteText) then StrDispose(MapiMessage.lpszNoteText);
    if Assigned(Receip.lpszAddress) then StrDispose(Receip.lpszAddress);
    if Assigned(Receip.lpszName) then StrDispose(Receip.lpszName);
    MapiLogOff(MAPI_Session, Handle, 0, 0);
  end;
end;

procedure TfrmMain.miExportClick(Sender: TObject);
begin
  dlgExportModel.FileName:= ExtractFileName(CurrentModell.ModFileName);
  if dlgExportModel.Execute then begin
    if CopyFile( PChar(CurrentModell.ModFileName),
                 PChar(dlgExportModel.FileName),
                 false )
    then begin
      Application.MessageBox( PAnsiChar(Format(MainTranslator.GetLit('ModelExportedSuccessfullyMessage'), [dlgExportModel.FileName])),
                              PAnsiChar(MainTranslator.GetLit('ModelExportedSuccessfullyCaption')), mb_IconInformation + mb_Ok );
    end else begin
      Application.MessageBox( PAnsiChar(Format(MainTranslator.GetLit('ModelExportedErrorMessage'), [dlgExportModel.FileName])),
                              PAnsiChar(MainTranslator.GetLit('ModelExportedErrorCaption')), mb_IconStop + mb_Ok );
    end;
  end;
end;

procedure TfrmMain.Import( _fileName: string; _silent: boolean = false );
var
  targetFileName: string;
begin
  targetFileName:= IncludeTrailingBackslash( ModellPath ) + ExtractFileName( _filename );
  if (FileExists( targetFileName )
    and (Application.MessageBox(
      PAnsiChar(MainTranslator.GetLit('ModelImportAlreadyExistsMessage')),
      PAnsiChar(MainTranslator.GetLit('ModelAlreadyExistsCaption')),
      mb_IconWarning + mb_YesNo) = idYes ))
    or (not FileExists( targetFileName ))
  then begin

    if CopyFile( PChar( _fileName ),
                 PChar( targetFileName ),
                 false )
    then begin

      if SameText(CurrentModell.ModFileName, targetFileName) then begin
        LoadModell( targetFileName );
        Application.MessageBox( PAnsiChar(Format(MainTranslator.GetLit('ModelImportedSuccessfullyMessage'), [_fileName])),
                                PAnsiChar(MainTranslator.GetLit('ModelImportedSuccessfullyCaption')), mb_IconInformation + mb_Ok );
      end else begin
        if (_silent)
          or (Application.MessageBox( PAnsiChar(Format(MainTranslator.GetLit('ModelImportedShowNowMessage'), [_fileName])),
                                PAnsiChar(MainTranslator.GetLit('ModelImportedSuccessfullyCaption')), mb_IconInformation + mb_YesNo ) = idYes)
        then begin
          if (Altered and SaveModell)
            or (not Altered)
          then begin
            LoadModell( targetFileName )
          end;
        end;
      end;
    end else begin
      Application.MessageBox( PChar(Format(MainTranslator.GetLit('ModelImportErrorMessage'), [_fileName])),
                              PAnsiChar(MainTranslator.GetLit('ModelImportErrorCaption')), mb_IconStop + mb_Ok );
    end;
  end;
end;

procedure TfrmMain.miImportClick(Sender: TObject);
begin
  if dlgImportModel.Execute then begin
    Import( dlgImportModel.FileName );
  end;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ ssCtrl ] then begin
    case Key of
      VK_F12: begin
                Key:= 0;
                MainTranslator.WriteDefaultTranslationData;
                fraBasics.Translator.WriteDefaultTranslationData;
                fraWingGeo.Translator.WriteDefaultTranslationData;
                fraFunctions.Translator.WriteDefaultTranslationData;
                ShowMessage( 'Language data have been written.' );
              end;
    end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  MainTranslator.RefreshTranslation();
  fraBasics.Translator.RefreshTranslation();
  fraWingGeo.Translator.RefreshTranslation();
  fraFunctions.Translator.RefreshTranslation();
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  fraBasics.Translator.DataProvider := nil;
  fraWingGeo.Translator.DataProvider := nil;
  fraFunctions.Translator.DataProvider := nil;
end;

procedure TfrmMain.miWDImportTragflaecheClick(Sender: TObject);
var
  dmWingDesigner: TdmWingDesigner;
  whatToImport: TWingDesignerElement;
begin
  if ((CurrentModell = nil) or (CurrentModell.Variante = nil)) then begin
    Application.MessageBox(
      PAnsiChar(MainTranslator.GetLit('WingDesignerInterfaceNoModelVersionOpen')),
      PAnsiChar(MainTranslator.GetLit('WingDesignerInterfaceNoModelVersionOpenCaption')),
      MB_OK + MB_ICONSTOP);

    exit;
  end;

  dmWingDesigner := TdmWingDesigner.Create(self);
  try
    if sender = miWDImportTragflaeche then
      whatToImport := wdeDeck
    else
      whatToImport := wdeElevator;

    IsUpdateing := true;
    try
      if dmWingDesigner.ImportFromWingDesigner(CurrentModell.Variante, whatToImport) then
      begin
        LoadData;
        Altered := true;
        ShowMessage(MainTranslator.GetLit('WingDesignerInterfaceImportSuccessfullMessage'));
      end;
    finally
      IsUpdateing := false;
    end;

  finally
    FreeAndNil(dmWingDesigner);
  end;
end;

procedure TfrmMain.miWDExportTragflaecheClick(Sender: TObject);
var
  dmWingDesigner: TdmWingDesigner;
  whatToExport: TWingDesignerElement;
begin
  if ((CurrentModell = nil) or (CurrentModell.Variante = nil)) then begin
    Application.MessageBox(
      PAnsiChar(MainTranslator.GetLit('WingDesignerInterfaceNoModelVersionOpen')),
      PAnsiChar(MainTranslator.GetLit('WingDesignerInterfaceNoModelVersionOpenCaption')),
      MB_OK + MB_ICONSTOP);

    exit;
  end;

  dmWingDesigner := TdmWingDesigner.Create(self);
  try
    if sender = miWDExportTragflaeche then
      whatToExport := wdeDeck
    else
      whatToExport := wdeElevator;

    dmWingDesigner.ExportToWingDesigner(CurrentModell.Variante, whatToExport);
    ShowMessage(PAnsiChar(MainTranslator.GetLit('WingDesignerInterfaceExportSuccessfullMessage')));

  finally
    FreeAndNil(dmWingDesigner);
  end;
end;

procedure TfrmMain.FillLanguages;
var
  sr: TSearchRec;
  status: integer;
  ini: TIniFile;
  langName: string;
  langItem: TLanguageItem;
  i: integer;
begin
  miLanguageList.Items.Clear;
  status:= FindFirst( ProgPath + '*.lng', faAnyFile, sr );
  miLanguageList.Items.Clear;
  try
    while status = 0 do begin

      { Open language file and read description }
      ini:= TIniFile.Create( ProgPath + sr.Name );
      try
        langName:= ini.ReadString( 'strings', 'languageName',
                                   Format( MainTranslator.GetLitDef( 'UnknownLanguageName', '<unknown: %s>' ), [sr.Name] ));

        langItem:= TLanguageItem.Create;
        langItem.LangCode:= '';
        if SameText( Copy( sr.Name, 1, 7), 'liftoff' ) then begin
          langItem.langCode:= Copy( sr.Name, 8, Pos( '.', sr.Name ) - 8 );
        end;

        i:= miLanguageList.Items.AddObject( langName, langItem );
        if langItem.LangCode = GlobalConfig.Language then miLanguageList.ItemIndex:= i;

      finally
        FreeAndNil( ini );
      end;

      { Read next file }
      status:= FindNext( sr );
    end;
  finally
    FindClose( sr );
  end;
end;

procedure TfrmMain.miLanguageListClick(Sender: TObject);
var
  langItem: TLanguageItem;
begin
  { Set the selected language }

  if miLanguageList.ItemIndex > -1 then begin
    langItem:= miLanguageList.Items.Objects[ miLanguageList.ItemIndex ] as TLanguageItem;
    if assigned( langItem ) then begin
      GlobalConfig.Language := langItem.LangCode;
      GlobalConfig.Save();
      dmMain.RefreshLanguageRelatedData;
    end;
  end;
end;

procedure TfrmMain.MainTranslatorTranslate(Sender: TObject);
begin
  Sidebar.Groups[0].Items[0].Caption := MainTranslator.GetLitDef('SidebarBasics', 'Basisdaten');
  Sidebar.Groups[0].Items[1].Caption := MainTranslator.GetLitDef('SidebarPlanform', 'Flügelgeometrie');
  Sidebar.Groups[0].Items[2].Caption := MainTranslator.GetLitDef('SidebarCalculations', 'Berechnungen');
end;

procedure TfrmMain.miAutoCheckForUpdatesClick(Sender: TObject);
begin
  GlobalConfig.AutoCheckForUpdates := miAutoCheckForUpdates.Down;
  GlobalConfig.Save();
end;

initialization
  TEC:= tecOk;
end.
