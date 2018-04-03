unit chNeutralpunkte;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, idTitleBar, ComCtrls, pfeilungliste, Buttons, ImgList;

type
  TfraNeutralpunkte = class(TFrame)
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
    Shape5: TShape;
    Panel3: TPanel;
    btnCalcND: TBitBtn;
    Panel4: TPanel;
    idTitleBar3: TidTitleBar;
    Shape6: TShape;
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
    ImageList1: TImageList;
    edAbstandFluegelHlw: TEdit;
    Label11: TLabel;
    procedure btnFlAddClick(Sender: TObject);
    procedure btnFlInsertClick(Sender: TObject);
    procedure btnFlDeleteClick(Sender: TObject);
    procedure btnHlwAddClick(Sender: TObject);
    procedure btnHlwInsertClick(Sender: TObject);
    procedure btnHlwDeleteClick(Sender: TObject);
    procedure edSpannweiteChange(Sender: TObject);
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

uses main, modell, ad_utils, varianten, report_neutralpunkt;

{$R *.dfm}

{ TfraNeutralpunkte }

constructor TfraNeutralpunkte.Create(AOwner: TComponent);
begin
  inherited;
  plFlaeche := TPfeilungEdit.Create(self);
  with plFlaeche do begin
    Parent := Panel2;
    Align := alClient;
    OnEnter := plFlaecheEnter;
    OnExit := plFlaecheExit;
    OnChange := DoOnChange;
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

procedure TfraNeutralpunkte.plFlaecheEnter(ASender: TObject);
begin
  btnFlAdd.Enabled := true;
  btnFlInsert.Enabled := true;
  btnFlDelete.Enabled := true;
end;

procedure TfraNeutralpunkte.plFlaecheExit(ASender: TObject);
begin
  btnFlAdd.Enabled := false;
  btnFlInsert.Enabled := false;
  btnFlDelete.Enabled := false;
end;

procedure TfraNeutralpunkte.btnFlAddClick(Sender: TObject);
begin
  plFlaeche.AddItem;
end;

procedure TfraNeutralpunkte.btnFlInsertClick(Sender: TObject);
begin
  plFlaeche.InsertItem( plFlaeche.ItemIndex );
end;

procedure TfraNeutralpunkte.btnFlDeleteClick(Sender: TObject);
begin
  plFlaeche.DeleteItemMessage( plFlaeche.ItemIndex )
end;

procedure TfraNeutralpunkte.SetAltered;
begin
  frmMain.Altered := true;
end;

procedure TfraNeutralpunkte.DoOnChange(ASender: TObject);
begin
  SetAltered;
end;

procedure TfraNeutralpunkte.plHlwEnter(ASender: TObject);
begin
  btnHlwAdd.Enabled := true;
  btnHlwInsert.Enabled := true;
  btnHlwDelete.Enabled := true;
end;

procedure TfraNeutralpunkte.plHlwExit(ASender: TObject);
begin
  btnHlwAdd.Enabled := false;
  btnHlwInsert.Enabled := false;
  btnHlwDelete.Enabled := false;
end;

procedure TfraNeutralpunkte.btnHlwAddClick(Sender: TObject);
begin
  plHLW.AddItem;
end;

procedure TfraNeutralpunkte.btnHlwInsertClick(Sender: TObject);
begin
  plHLW.InsertItem( plHLW.ItemIndex );
end;

procedure TfraNeutralpunkte.btnHlwDeleteClick(Sender: TObject);
begin
  plHLW.DeleteItemMessage( plHLW.ItemIndex )
end;

function TfraNeutralpunkte.LoadData: boolean;
begin
  result := false;

  with CurrentModell.Variante do begin

    { Fläche }
    edPfeilungRandbogen.Text := ADCurrToStr( PflgFlRandbogen );
    plFlaeche.Load( PflgFlKnicke );

    { HLW }
    edAbstandFluegelHlw.text := IntToStr( PflgHlwAbstandFluegelHlw );
    edHlwSpannweite.Text := IntToStr( PflgHlwSpannweite );
    edHlwWurzeltiefe.Text := ADCurrToStr( PflgHlwWurzeltiefe );
    edHlwAussentiefe.Text := ADCurrToStr( PflgHlwAussentiefe );
    edHlwPfeilung.Text := ADCurrToStr( PflgHlwRandbogen );
    plHLW.Load( PflgHlwKnicke );

  end;

  result := true;
end;

function TfraNeutralpunkte.SaveData: boolean;
begin
  result := false;

  with CurrentModell.Variante do begin

    { Fläche }
    PflgFlRandbogen := ADStrToCurr( edPfeilungRandbogen.Text );
    plFlaeche.Save( PflgFlKnicke );

    { HLW }
    PflgHlwAbstandFluegelHlw := StrToIntDef( edAbstandFluegelHlw.Text, 0);
    PflgHlwSpannweite := StrToIntDef( edHlwSpannweite.Text, 0 );
    PflgHlwWurzeltiefe := ADStrToCurr( edHlwWurzeltiefe.Text );
    PflgHlwAussentiefe := ADStrToCurr( edHlwAussentiefe.Text );
    PflgHlwRandbogen := ADStrToCurr( edHlwPfeilung.Text );
    plHLW.Save( PflgHlwKnicke );

  end;

  result := true;
end;

procedure TfraNeutralpunkte.edSpannweiteChange(Sender: TObject);
begin
  SetAltered;
end;

procedure TfraNeutralpunkte.btnCalcNDClick(Sender: TObject);
var
  qrpReport: TqrpNeutralpunkt;
begin
  if Validate then begin
    SaveData;

    qrpReport := TqrpNeutralpunkt.Create(self);
    try
      qrpReport.ModellVariante := CurrentModell.Variante;
      { Modaler Preview aus welchem auch gedruckt werden kann }
      qrpReport.PreviewModal;
    finally
      FreeAndNil(qrpReport);
    end;
  end;
end;

function TfraNeutralpunkte.Validate: boolean;
begin
  result := true;
end;

end.
