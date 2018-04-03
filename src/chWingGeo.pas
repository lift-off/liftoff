unit chWingGeo;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, idTitleBar, ComCtrls, pfeilungliste, Buttons, ImgList,
  idTranslator;

type
  TfraWingGeo = class(TFrame)
    Shape1: TShape;
    idTitleBar1: TidTitleBar;
    Label26: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Shape4: TShape;
    PageControl: TPageControl;
    tsTragflaeche: TTabSheet;
    tsHLW: TTabSheet;
    Panel1: TPanel;
    Label6: TLabel;
    edPfeilungRandbogen: TEdit;
    Panel2: TPanel;
    Shape2: TShape;
    idTitleBar2: TidTitleBar;
    Shape3: TShape;
    Panel4: TPanel;
    Panel5: TPanel;
    Shape7: TShape;
    btnFlAdd: TSpeedButton;
    btnFlInsert: TSpeedButton;
    btnFlDelete: TSpeedButton;
    Panel6: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edHlwSpannweite: TEdit;
    edHlwWurzeltiefe: TEdit;
    edHlwAussentiefe: TEdit;
    edHlwPfeilung: TEdit;
    Panel7: TPanel;
    Shape8: TShape;
    Shape9: TShape;
    idTitleBar4: TidTitleBar;
    Panel8: TPanel;
    Shape10: TShape;
    btnHlwAdd: TSpeedButton;
    btnHlwInsert: TSpeedButton;
    btnHlwDelete: TSpeedButton;
    Images: TImageList;
    edAbstandFluegelHlw: TEdit;
    Label11: TLabel;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    Label3: TLabel;
    edHolmbreiteWurzel: TEdit;
    Label4: TLabel;
    edHolmbreiteRandbogen: TEdit;
    Label5: TLabel;
    edProfildickeWurzel: TEdit;
    Label12: TLabel;
    edProfildickeRandbogen: TEdit;
    btnCalcND: TBitBtn;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label13: TLabel;
    Label17: TLabel;
    Translator: TidTranslator;
    procedure btnFlAddClick(Sender: TObject);
    procedure btnFlInsertClick(Sender: TObject);
    procedure btnFlDeleteClick(Sender: TObject);
    procedure btnHlwAddClick(Sender: TObject);
    procedure btnHlwInsertClick(Sender: TObject);
    procedure btnHlwDeleteClick(Sender: TObject);
    procedure edSpannweiteChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnCalcNDClick(Sender: TObject);
  private
    { Private declarations }
    plFlaeche: TPfeilungEdit;
    plHLW: TPfeilungEdit;
    procedure plFlaecheEnter(ASender: TObject);
    procedure plFlaecheExit(ASender: TObject);
    procedure plHlwEnter(ASender: TObject);
    procedure plHlwExit(ASender: TObject);
    procedure DoOnChange( ASender: TObject );
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SetAltered;

    function LoadData: boolean;
    function SaveData: boolean;
    function Validate: boolean;
  end;

implementation

uses main, modell, ad_utils, varianten, report_neutralpunkt, maindata;

{$R *.dfm}

{ TfraNeutralpunkte }

constructor TfraWingGeo.Create(AOwner: TComponent);
begin
  inherited;
  plFlaeche := TPfeilungEdit.Create(self);
  with plFlaeche do begin
    Parent := Panel2;
    Align := alClient;
    OnEnter := plFlaecheEnter;
    OnExit := plFlaecheExit;
    OnChange := DoOnChange;
    ShowProfilDicke:= true;
  end;

  plHLW := TPfeilungEdit.Create(self);
  with plHLW do begin
    Parent := Panel7;
    Align := alClient;
    OnEnter := plHlwEnter;
    OnExit := plHlwExit;
    OnChange := DoOnChange;
  end;

end;

procedure TfraWingGeo.plFlaecheEnter(ASender: TObject);
begin
  btnFlAdd.Enabled := true;
  btnFlInsert.Enabled := true;
  btnFlDelete.Enabled := true;
end;

procedure TfraWingGeo.plFlaecheExit(ASender: TObject);
begin
//  btnFlAdd.Enabled := false;
  btnFlInsert.Enabled := false;
  btnFlDelete.Enabled := false;
end;

procedure TfraWingGeo.btnFlAddClick(Sender: TObject);
begin
  plFlaeche.AddItem;
end;

procedure TfraWingGeo.btnFlInsertClick(Sender: TObject);
begin
  plFlaeche.InsertItem( plFlaeche.ItemIndex );
end;

procedure TfraWingGeo.btnFlDeleteClick(Sender: TObject);
begin
  plFlaeche.DeleteItemMessage( plFlaeche.ItemIndex )
end;

procedure TfraWingGeo.SetAltered;
begin
  frmMain.Altered := true;
  if not frmMain.IsUpdateing then begin
    SaveData;
    frmMain.UpdateModelGraphics;
  end;
end;

procedure TfraWingGeo.DoOnChange(ASender: TObject);
begin
  SetAltered;
end;

procedure TfraWingGeo.plHlwEnter(ASender: TObject);
begin
  btnHlwAdd.Enabled := true;
  btnHlwInsert.Enabled := true;
  btnHlwDelete.Enabled := true;
end;

procedure TfraWingGeo.plHlwExit(ASender: TObject);
begin
//  btnHlwAdd.Enabled := false;
  btnHlwInsert.Enabled := false;
  btnHlwDelete.Enabled := false;
end;

procedure TfraWingGeo.btnHlwAddClick(Sender: TObject);
begin
  plHLW.AddItem;
end;

procedure TfraWingGeo.btnHlwInsertClick(Sender: TObject);
begin
  plHLW.InsertItem( plHLW.ItemIndex );
end;

procedure TfraWingGeo.btnHlwDeleteClick(Sender: TObject);
begin
  plHLW.DeleteItemMessage( plHLW.ItemIndex )
end;

function TfraWingGeo.LoadData: boolean;
begin

  with CurrentModell.Variante do begin

    { Fläche }
    edPfeilungRandbogen.Text := UICurrToStr( PflgFlRandbogen );
    edHolmbreiteWurzel.Text := IntToStr( HolmbreiteWurzel );
    edHolmbreiteRandbogen.Text := IntToStr( HolmbreiteRandbogen );
    edProfildickeWurzel.Text := UICurrToStr( ProfildickeWurzel );
    edProfildickeRandbogen.Text := UICurrToStr( ProfildickeRandbogen );
    plFlaeche.Load( PflgFlKnicke );

    { HLW }
    edAbstandFluegelHlw.text := IntToStr( PflgHlwAbstandFluegelHlw );
    edHlwSpannweite.Text := IntToStr( PflgHlwSpannweite );
    edHlwWurzeltiefe.Text := UICurrToStr( PflgHlwWurzeltiefe );
    edHlwAussentiefe.Text := UICurrToStr( PflgHlwAussentiefe );
    edHlwPfeilung.Text := UICurrToStr( PflgHlwPfeilung );
    plHLW.Load( PflgHlwKnicke );

  end;

  result := true;
end;

function TfraWingGeo.SaveData: boolean;
begin

  with CurrentModell.Variante do begin

    { Fläche }
    PflgFlRandbogen := UIStringToCurrDef( edPfeilungRandbogen.Text, 0 );
    HolmbreiteWurzel := StrToIntDef( edHolmbreiteWurzel.Text, 0 );
    HolmbreiteRandbogen := StrToIntDef( edHolmbreiteRandbogen.Text, 0 );
    ProfildickeWurzel:= UIStringToCurrDef( edProfildickeWurzel.Text, 0);
    ProfildickeRandbogen:= UIStringToCurrDef( edProfildickeRandbogen.Text, 0);
    plFlaeche.Save( PflgFlKnicke );

    { HLW }
    PflgHlwAbstandFluegelHlw := StrToIntDef( edAbstandFluegelHlw.Text, 0);
    PflgHlwSpannweite := StrToIntDef( edHlwSpannweite.Text, 0);
    PflgHlwWurzeltiefe := UIStringToCurrDef( edHlwWurzeltiefe.Text, 0);
    PflgHlwAussentiefe := UIStringToCurrDef( edHlwAussentiefe.Text, 0);
    PflgHlwPfeilung := UIStringToCurrDef( edHlwPfeilung.Text, 0);
    plHLW.Save( PflgHlwKnicke );

  end;

  result := true;
end;

procedure TfraWingGeo.edSpannweiteChange(Sender: TObject);
begin
  SetAltered;
end;

function TfraWingGeo.Validate: boolean;
var
  i: Integer;
begin
  result := false;

  with CurrentModell.Variante do begin

    { Knicke der Flächen }
    if PflgFlKnicke.Count > 0 then begin
      for I := 0 to PflgFlKnicke.Count - 1 do begin    // Iterate
        if (PflgFlKnicke.Items[i].Abstand = 0)
          or (PflgFlKnicke.Items[i].Fluegeltiefe = 0)
        then begin
          result:= false;
          frmMain.SetPage( pagWingGeo );
          PageControl.ActivePage:= tsTragflaeche;
          plFlaeche.SetFocus;
          dmMain.ShowValidationError(Format(dmMain.Translator.GetLit('ValidationInvalidWingPanelEndpoint'), [ i+2]));
        end;
      end;    // for
    end else begin
      result:= false;
      frmMain.SetPage( pagWingGeo );
      PageControl.ActivePage:= tsTragflaeche;
      plFlaeche.SetFocus;
    end;

    { Knicke des HLW's }
    if PflgHlwKnicke.Count > 0 then begin
      for I := 0 to PflgHlwKnicke.Count - 1 do begin    // Iterate
        if (PflgHlwKnicke.Items[i].Abstand = 0)
          or (PflgHlwKnicke.Items[i].Fluegeltiefe = 0)
        then begin
          result:= false;
          frmMain.SetPage( pagWingGeo );
          PageControl.ActivePage:= tsHLW;
          plHLW.SetFocus;
          dmMain.ShowValidationError(Format(dmMain.Translator.GetLit('ValidationInvalidElevatorPanelEndpoint'), [ i+2]));
        end;
      end;    // for
    end;

    { Pfeilung Vorderkante Randbogen }
    // Hinweis: Pfeilungen können bei Grosssegler auch negative Werte beinhalten
    {if not ValidateInt( Label6.Caption, edPfeilungRandbogen, 0 ) then begin
      frmMain.SetPage( pagWingGeo );
      PageControl.ActivePage:= tsTragflaeche;
      edPfeilungRandbogen.SetFocus;
      exit;
    end;}

    { Abstand Vorderkante Flügel bis Höhenleitwerk }
    if not ValidateInt( Label11.Caption, edAbstandFluegelHlw, 150, 3500 ) then begin
      frmMain.SetPage( pagWingGeo );
      PageControl.ActivePage:= tsHLW;
      edAbstandFluegelHlw.SetFocus;
      exit;
    end;

    { Spannweite HLW }
    if not ValidateInt( Label7.Caption, edHlwSpannweite, 200, 15000 ) then begin
      frmMain.SetPage( pagWingGeo );
      PageControl.ActivePage:= tsHLW;
      edHlwSpannweite.SetFocus;
      exit;
    end;

    { Wurzeltiefe }
    if not ValidateInt( Label8.Caption, edHlwWurzeltiefe, 20, 1000 ) then begin
      frmMain.SetPage( pagWingGeo );
      PageControl.ActivePage:= tsHLW;
      edHlwWurzeltiefe.SetFocus;
      exit;
    end;

    { Aussentiefe }
    if not ValidateInt( Label9.Caption, edHlwAussentiefe, 10, 800 ) then begin
      frmMain.SetPage( pagWingGeo );
      PageControl.ActivePage:= tsHLW;
      edHlwAussentiefe.SetFocus;
      exit;
    end;

    { Pfeilung Vorderkannte Randbogen }
    // Hinweis: Pfeilungen können bei Grosssegler auch negative Werte beinhalten
    {if not ValidateInt( Label10.Caption, edHlwPfeilung, -300, 300 ) then begin
      frmMain.SetPage( pagWingGeo );
      PageControl.ActivePage:= tsHLW;
      edHlwPfeilung.SetFocus;
      exit;
    end;}

    result := true;

  end;

end;

procedure TfraWingGeo.BitBtn1Click(Sender: TObject);
begin
  frmMain.ShowModelGraficWindow( true, false );
end;

procedure TfraWingGeo.btnCalcNDClick(Sender: TObject);
begin
  frmMain.fraFunctions.btnCalcNDClick(Sender);
end;

end.
