unit pfeilungliste;

interface

uses
  windows, classes, sysutils, forms, graphics, controls, StdCtrls, ExtCtrls,
  varianten;

type

  TPfeilungEdit = class;

  TPfeilungItemUI = class(TPanel)
  private
    FPfeilungsEdit: TPfeilungEdit;
    FBorderShape : TShape;
    FShowProfildicke : boolean;
  protected
    procedure PfeilungExit(ASender: TObject);
    procedure ProfildickeExit(ASender: TObject);
    function Validate: boolean;
    procedure DoEnter(ASender: TObject); reintroduce;
    procedure DoExit(ASender: TObject); reintroduce;
  public
    edAbstand : TEdit;
    edTiefe : TEdit;
    edPfeilung : TEdit;
    edProfildicke: TEdit;
    edHolmbreite: TEdit;
    lblNo,
    lblAbstand,
    lblTiefe,
    lblPfeilung,
    lblProfildicke: TLabel;

    constructor Create(AOwner: TComponent; AParent: TPfeilungEdit; AShowProfildicke: boolean ); reintroduce;
    destructor  Free; virtual;

    procedure IsOther(AIsOther: boolean);
    function  IsEmpty: boolean;
    procedure SetNo(ANo: integer);
    function Index: integer;
    procedure ClearItem;

    procedure SaveTo( var AItem: TPfeilungsItem );
    procedure LoadFrom( AItem: TPfeilungsItem );

  end;

  TPfeilungListUI = class(TList);

  TPfeilungEdit = class(TScrollBox)
  private
    FItems: TPfeilungListUI;
    FIndex: integer;
    FModified: boolean;
    FOnChange: TNotifyEvent;
    FNeedAtLeastCountItem: integer;
    FShowProfilDicke: boolean;
    function GetItemYPos(APos: integer): integer;
    function CreateItemAtPos(APos: integer): TPfeilungItemUI;
    procedure RemoveEmptyItems;
    procedure SetIndex(AIndex: integer);
    procedure DoOnChange(ASender: TObject);
  protected
    procedure DoExit; override;
    procedure SetAltered(AValue: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function ClearItems: boolean;
    function InsertItem(APos: integer): boolean;
    function DeleteItem(APos: integer): boolean;
    function DeleteItemMessage(APos: integer): boolean;
    function AddItem: TPfeilungItemUI;

    function Load(APfeilungsItems: TPfeilungsItems): boolean;
    function Save(APfeilungsItems: TPfeilungsItems): boolean;

    property Items: TPfeilungListUI read FItems;
    property ItemIndex: integer read FIndex;
    property Modified: boolean read FModified;
    property NeedAtLeastCountItem: integer read FNeedAtLeastCountItem write FNeedAtLeastCountItem default 1;
    property ShowProfilDicke: boolean read FShowProfilDicke write FShowProfilDicke default false;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  ad_utils, maindata;

function DarkenColor(AColor: TColor; ADarkValue: byte): TColor;
begin
  result := 0;
end;

{ TPfeilungEdit }

const
  ItemHeight          = 27;
  ItemSpace           = 1;
  ItemInnerSpace      = 2;
  ItemColorNormal     = clWhite;
  ItemColorEven       = clBlue;

function TPfeilungEdit.AddItem: TPfeilungItemUI;
begin
  result := CreateItemAtPos(FItems.Count);
  FItems.Add( result );
end;

function TPfeilungEdit.ClearItems: boolean;
var
  i: integer;
begin
  if Items.Count > 0 then
    for i := pred( Items.Count ) downto 0 do begin
      TObject(Items[i]).Free;
      Items[i] := nil;
    end;

  Items.Clear;
  result:= true;
end;

constructor TPfeilungEdit.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TPfeilungListUI.Create;
  BorderStyle := bsNone;
  BevelOuter := bvNone;
  Color := clWhite;

//  FItems.Add(CreateItemAtPos(0));
end;

function TPfeilungEdit.CreateItemAtPos(APos: integer): TPfeilungItemUI;
begin
  result := TPfeilungItemUI.Create( self, self, ShowProfilDicke );
  with result do begin
    Top := GetItemYPos(APos);
    SetNo( APos + 1 );
  end;
end;

function TPfeilungEdit.DeleteItem(APos: integer): boolean;
var i : integer;
begin


//  if APos > 0 then begin

    { Delte item at pos APOS }
    if assigned(FItems[APos]) then begin
      TOBject(FItems[APos]).Free;
      FItems[APos] := nil;
    end;

    { Move all items below one pos uf }
    if APos < FItems.Count - 1 then begin
      for i := APos +1 to pred(FItems.Count) do begin
        FItems[i-1] := FItems[i];
        if assigned(FItems[i-1]) then begin
          TPfeilungItemUI(FItems[i-1]).Top := GetItemYPos(i-1);
          TPfeilungItemUI(FItems[i-1]).SetNo(i);
        end;
      end;

      { Delete lost Item }
      FItems.Delete(FItems.Count -1);

    end else begin
      { Delete item }
      FItems.Delete(APos);
    end;

    result:= true;

//  end else begin
//    TPfeilungItemUI(FItems[APos]).edTiefe.Text := '';
//    TPfeilungItemUI(FItems[APos]).edAbstand.Text := '';
//    TPfeilungItemUI(FItems[APos]).edPfeilung.Text := '';
//    TPfeilungItemUI(FItems[APos]).edTiefe.SetFocus;
//  end;

end;

function TPfeilungEdit.DeleteItemMessage(APos: integer): boolean;
begin
//  if Items.Count < NeedAtLeastCountItem then begin
//
//    result := false;
//    Application.MessageBox( Format( 'Mindestens %s Knick muss eingetragen werden!', [IntToStr( NeedAtLeastCountItem )]),
//                            'Eingabefehler',
//                            mb_IconStop + mb_Ok );
//    exit;
//
//  end else begin
    Result := DeleteItem( APos );
//  end;

end;

destructor TPfeilungEdit.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TPfeilungEdit.DoExit;
begin
  RemoveEmptyItems;
  inherited;
end;

procedure TPfeilungEdit.DoOnChange(ASender: TObject);
begin
  SetAltered(true);
  if assigned( FOnChange ) then OnChange( ASender );
end;

function TPfeilungEdit.GetItemYPos(APos: integer): integer;
begin
  result := ItemSpace + APos * (ItemHeight + ItemSpace);
end;

function TPfeilungEdit.InsertItem(APos: integer): boolean;
var
  item: TPfeilungItemUI;
  i: integer;
begin
  result:= false;
  assert( APos < FItems.Count, 'Index out of bounds!' );

  if not TPfeilungItemUI( Items[APos] ).IsEmpty then begin

    item:= CreateItemAtPos(APos);
    FItems.Insert(APos, Item);
    if  APos < FItems.Count -1 then
      for i:= APos + 1 to Pred(FItems.Count) do begin
        TPfeilungItemUI( FItems[i] ).Top := GetItemYPos(i);
        TPfeilungItemUI( FItems[i] ).SetNo( i + 1 );
      end;

    result := true;

  end;

end;

function TPfeilungEdit.Load(APfeilungsItems: TPfeilungsItems): boolean;
var
  i: integer;
  item: TPfeilungItemUI;
begin
  assert( assigned( APfeilungsItems ));

  ClearItems;
//  if APfeilungsItems.Count > 0 then begin
    for i:= 0 to pred( APfeilungsItems.Count ) do begin
      item := AddItem;
      item.LoadFrom( TPfeilungsItem( APfeilungsItems.Items[i] ));
    end;
//  end else begin
//    // wenn kein Item existiert, wird ein leeres für die erste eingabe eingesetzt
//    item := AddItem;
//  end;
  result:= true;
end;

procedure TPfeilungEdit.RemoveEmptyItems;
var
  i : integer;
begin
  if Items.Count > 1 then              // don't remove the first item
    for i := pred(Items.Count) downto 1 do
      if TPfeilungItemUI(Items[i]).IsEmpty then
        DeleteItem(i);
end;

function TPfeilungEdit.Save(APfeilungsItems: TPfeilungsItems): boolean;
var
  i: integer;
  item: TPfeilungsItem;
begin
  assert( assigned( APfeilungsItems ));

  RemoveEmptyItems;
  APfeilungsItems.Clear;

  if Items.Count > 0 then
    for i := 0 to pred( Items.Count ) do begin
      item := TPfeilungsItem.Create;
      TPfeilungItemUI(Items[i]).SaveTo(item);
      APfeilungsItems.Add(item);
    end;

  result:= true;
end;

procedure TPfeilungEdit.SetAltered(AValue: boolean);
begin
  FModified := AValue;
  if ( Modified) and ( assigned( FOnChange )) then
    FOnChange(self);
end;

procedure TPfeilungEdit.SetIndex(AIndex: integer);
begin
  if FIndex <> AIndex then
    FIndex:= AIndex;
end;

{ TPfeilungItemUI }

procedure TPfeilungItemUI.ClearItem;
begin
  edTiefe.Text := '';
  edAbstand.Text := '';
  edPfeilung.Text := '';
  if assigned( edProfildicke ) then edProfildicke.Text := '';
end;

constructor TPfeilungItemUI.Create(AOwner: TComponent; AParent: TPfeilungEdit; AShowProfildicke: boolean);
const
  editWidth = 35;
begin
  inherited Create(AOwner);
  FShowProfildicke:= AShowProfildicke;
  BorderWidth := 0;
  BorderStyle := bsNone;
  BevelOuter := bvNone;
  Left := ItemSpace;
  Height := ItemHeight;
  Width := TScrollBox(AOwner).Width - (2 * ItemSpace);
  Anchors := [akLeft, akTop, akRight];  // To do proper resizing
  Parent := TWincontrol(AOwner);
  FPfeilungsEdit := AParent;

  OnEnter := DoEnter;
  OnExit := DoExit;

  { Bordershape }
  FBorderShape := TShape.Create(self);
  with FBorderShape do begin
    Parent := self;
    Align := alClient;
    Brush.Color := self.Color;
    Pen.Color := RGB(200, 200, 200);
  end;

  { No }
  lblNo := TLabel.Create(self);
  with lblNo do begin
    Parent := self;
    Left := ItemInnerSpace;
    Caption := 'K';
    Top := round((self.Height - Height) / 2)-1;
  end;

  { Abstand }
  lblAbstand := TLabel.Create(self);
  with lblAbstand do begin
    Parent := self;
    Left := 70;
    Caption := dmMain.Translator.GetLit('SweepListDistance');
    Top := round((self.Height - Height) / 2)-1;
  end;

  edAbstand := TEdit.Create(self);
  with edAbstand do begin
    Parent := self;
    Left := lblAbstand.Left + lblAbstand.Width + 5;
    Top := round((self.Height - Height) / 2)-1;
    MaxLength := 4;
    OnChange := FPfeilungsEdit.DoOnChange;
    Width:= editWidth;
  end;

  { Tiefe }
  lblTiefe := TLabel.Create(self);
  with lblTiefe do begin
    Parent := self;
    Left := edAbstand.Left + edAbstand.Width + 5;
    Caption := dmMain.Translator.GetLit('SweepListCord');
    Top := round((self.Height - Height) / 2)-1;
  end;

  edTiefe := TEdit.Create(self);
  with edTiefe do begin
    Parent := self;
    Left := lblTiefe.Left + lblTiefe.Width + 5;
    Top := round((self.Height - Height) / 2)-1;
    MaxLength := 3;
    OnChange := FPfeilungsEdit.DoOnChange;
    Width:= editWidth;
  end;

  { Pfeilung }
  lblPfeilung := TLabel.Create(self);
  with lblPfeilung do begin
    Parent := self;
    Left := edTiefe.Left + edTiefe.Width + 5;
    Caption := dmMain.Translator.GetLit('SweepListSweep');
    Top := round((self.Height - Height) / 2)-1;
  end;

  edPfeilung := TEdit.Create(self);
  with edPfeilung do begin
    Parent := self;
    Left := lblPfeilung.Left + lblPfeilung.Width + 5;
    Top := round((self.Height - Height) / 2)-1;
    OnExit := PfeilungExit;
    MaxLength := 3;
    OnChange := FPfeilungsEdit.DoOnChange;
    Width:= editWidth;
  end;

  if FShowProfildicke then begin

    { Profildicke }
    lblProfildicke := TLabel.Create(self);
    with lblProfildicke do begin
      Parent := self;
      Left := edPfeilung.Left + edPfeilung.Width + 5;
      Caption := dmMain.Translator.GetLit('SweepListAirfoilThickness');
      Top := round((self.Height - Height) / 2)-1;
    end;

    edProfildicke := TEdit.Create(self);
    with edProfildicke do begin
      Parent := self;
      Left := lblProfildicke.Left + lblProfildicke.Width + 5;
      Top := round((self.Height - Height) / 2)-1;
      //OnExit := ProfildickeExit;
      MaxLength := 5;
      OnChange := FPfeilungsEdit.DoOnChange;
      Width:= editWidth;
    end;

  end;

end;

procedure TPfeilungItemUI.DoEnter(ASender: TObject);
begin
  FPfeilungsEdit.SetIndex(Index);
  FBorderShape.Pen.Color := RGB(150, 150, 150);
  FBorderShape.Pen.Width := 2;
end;

procedure TPfeilungItemUI.DoExit(ASender: TObject);
begin
  FBorderShape.Pen.Color := RGB(200, 200, 200);
  FBorderShape.Pen.Width := 1;
  FPfeilungsEdit.SetIndex(-1);
end;

destructor TPfeilungItemUI.Free;
begin
  inherited Free;
end;

function TPfeilungItemUI.Index: integer;
begin
  result := FPfeilungsEdit.Items.IndexOf(self);
end;

function TPfeilungItemUI.IsEmpty: boolean;
begin
  result := (edAbstand.Text = '') and
            (edTiefe.Text = '') and
            (edPfeilung.Text = '');
end;

procedure TPfeilungItemUI.IsOther(AIsOther: boolean);
begin
  if AIsOther then begin
    Color := RGB(240, 240, 240);
  end else
    Color := clWhite;
  FBorderShape.Brush.Color := self.Color;
end;

procedure TPfeilungItemUI.LoadFrom(AItem: TPfeilungsItem);
begin
  assert( assigned( AItem ));
  edAbstand.Text := IntToStr( AItem.Abstand );
  edTiefe.Text := IntToStr( AItem.Fluegeltiefe );
  edPfeilung.Text := IntToStr( AItem.Pfeilung );
  if assigned( edPfeilung ) then edProfildicke.Text := UICurrToStr( AItem.ProfilDicke );
end;

procedure TPfeilungItemUI.PfeilungExit(ASender: TObject);
begin
//  if  (edAbstand.Text <> '')
//  and (edTiefe.Text <> '')
//  and (edPfeilung.Text <> '')
//  and (not assigned( edProfildicke ))
//  and (Index = FPfeilungsEdit.Items.Count - 1) then begin
//    FPfeilungsEdit.AddItem;
//    try // Catchching the exception is needed because of page switches
//      TPfeilungItemUI(FPfeilungsEdit.Items[ FPfeilungsEdit.Items.Count -1 ]).edAbstand.SetFocus;
//    except
//    end;
//  end;
end;

procedure TPfeilungItemUI.ProfildickeExit(ASender: TObject);
begin
//  if  (edAbstand.Text <> '')
//  and (edTiefe.Text <> '')
//  and (edPfeilung.Text <> '')
//  and (Index = FPfeilungsEdit.Items.Count - 1) then begin
//    FPfeilungsEdit.AddItem;
//    try // Catiching the exception is needed because of page switches
//      TPfeilungItemUI(FPfeilungsEdit.Items[ FPfeilungsEdit.Items.Count -1 ]).edAbstand.SetFocus;
//    except
//    end;
//  end;
end;

procedure TPfeilungItemUI.SaveTo(var AItem: TPfeilungsItem);
begin
  assert( assigned( AItem ));
  AItem.Abstand := StrToIntDef( edAbstand.Text, 0 );
  AItem.Fluegeltiefe := StrToIntDef( edTiefe.Text, 0 );
  AItem.Pfeilung := StrToIntDef( edPfeilung.Text, 0 );
  if assigned( edProfildicke ) then AItem.ProfilDicke := ADStrToCurr( edProfildicke.Text, 0 )
  else AItem.ProfilDicke:= 0;
end;

procedure TPfeilungItemUI.SetNo(ANo: integer);
begin
  lblNo.Caption := Format('%s %s:',
    [dmMain.Translator.GetLit('SweepListPanelEndNo'),
     IntToStr(ANo)]);
  IsOther(Frac((ANo) / 2) = 0);
end;

function TPfeilungItemUI.Validate: boolean;
begin
  result := true;

  if StrToIntDef(edTiefe.Text, -1) = -1 then begin
    result := false;
    edTiefe.SetFocus;
    dmMain.ShowValidationError(Format(dmMain.Translator.GetLit('ValidationErrorInvalidValue'), [lblTiefe.Caption]));
  end else
  if StrToIntDef(edAbstand.Text, -1) = -1 then begin
    result := false;
    edAbstand.SetFocus;
    dmMain.ShowValidationError(Format(dmMain.Translator.GetLit('ValidationErrorInvalidValue'), [lblAbstand.Caption]));
  end else
  if StrToIntDef(edPfeilung.Text, -1) = -1 then begin
    result := false;
    edTiefe.SetFocus;
    dmMain.ShowValidationError(Format(dmMain.Translator.GetLit('ValidationErrorInvalidValue'), [lblTiefe.Caption]));
  end;

end;

end.
