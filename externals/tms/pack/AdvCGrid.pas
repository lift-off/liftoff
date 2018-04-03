{**************************************************************************}
{ TADVCOLUMNGRID component                                                 }
{ for Delphi & C++Builder                                                  }
{ version 2.5                                                              }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright © 1996-2003                                         }
{            Email : info@tmssoftware.com                                  }
{            Web : http://www.tmssoftware.com                              }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

{$I TMSDEFS.INC}

unit AdvCGrid;

interface

uses
  BaseGrid, AdvGrid, Classes, Grids, Graphics, SysUtils, Windows, StdCtrls,
  Controls, Menus, IniFiles, AdvUtil
{$IFDEF TMSCODESITE}
  ,CSIntf
{$ENDIF}
  ;

const
  MAJ_VER = 2; // Major version nr.
  MIN_VER = 5; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 0; // Build nr.
  DATE_VER = 'June, 2003'; // Release date

type
  TAdvColumnGrid = class;

  TFilterSelectEvent = procedure(Sender: TObject; Column, ItemIndex: Integer;
    FriendlyName: string; var FilterCondition: string) of object;

  TDropSelectEvent = procedure(Sender: TObject; ItemIndex: Integer) of object;

  TColumnPopupEvent = procedure(Sender: TObject; ACol, ARow: Integer; PopupMenu: TPopupMenu) of object;

  TDropList = class(TListBox)
  private
    FOnSelect: TDropSelectEvent;
  protected
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyPress(var Key: Char); override;
  public
  published
    property OnSelect: TDropSelectEvent read FOnSelect write FOnSelect;
  end;

  TFilterDropDown = class(TPersistent)
  private
    FHeight: Integer;
    FWidth: Integer;
    FColor: TColor;
    FFont: TFont;
    FColumnWidth: Boolean;
    procedure SetFont(const Value: TFont);
  protected
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Color: TColor read FColor write FColor;
    property ColumnWidth: Boolean read FColumnWidth write FColumnWidth;
    property Font: TFont read FFont write SetFont;
    property Height: Integer read FHeight write FHeight;
    property Width: Integer read FWidth write FWidth;
  end;

  TColumnPopupType = (cpFixedCellsRClick,cpFixedCellsLClick,
    cpNormalCellsRClick,cpNormalCellsLClick,cpAllCellsRClick,cpAllCellsLClick);

  TGridColumnItem = class(TCollectionItem)
  private
    FWidth: Integer;
    FAlignment: TAlignment;
    FColumnHeader: string;
    FSortStyle: TSortStyle;
    FSortPrefix: string;
    FSortSuffix: string;
    FEditMask: string;
    FEditLength: Integer;
    FEditLink: TEditLink;
    FFont: TFont;
    FColor: TColor;
    FEditorType: TEditorType;
    FFixed: Boolean;
    FReadOnly: Boolean;
    FComboItems: TStringList;
    FSpinMin: Integer;
    FSpinMax: Integer;
    FSpinStep: Integer;
    FPassword: Boolean;
    FPrintFont: TFont;
    FPrintColor: TColor;
    FBorders: TCellBorders;
    FBorderPen: TPen;
    FPrintBorders: TCellBorders;
    FPrintBorderPen: TPen;
    FTag: Integer;
    FDefIdx: Integer;
    FName: string;
    FCheckFalse: string;
    FCheckTrue: string;
    FShowBands: Boolean;
    FFilter: TStringList;
    FMaxSize: Integer;
    FMinSize: Integer;
    FAutoMinSize: Integer;
    FAutoMaxSize: Integer;
    FColumnPopupType: TColumnPopupType;
    FColumnPopup: TPopupMenu;
    FFilterCaseSensitive: Boolean;
    FFloatFormat: string;
    procedure SetWidth(const Value: Integer);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetColumnHeader(const Value:string);
    procedure SetFont(const Value:TFont);
    procedure SetColor(const Value:TColor);
    procedure SetFixed(const Value: Boolean);
    procedure SetPassword(const Value: Boolean);
    procedure SetComboItems(const Value: TStringList);
    procedure FontChanged(Sender: TObject);
    procedure PenChanged(Sender: TObject);
    procedure SetBorders(const Value: TCellBorders);
    procedure SetBorderPen(const Value: TPen);
    function GetRows(idx: Integer): string;
    procedure SetRows(idx: Integer; const Value: string);
    function GetDates(idx: Integer): TDateTime;
    function GetFloats(idx: Integer): Double;
    function GetInts(idx: Integer): Integer;
    procedure SetDates(idx: Integer; const Value: TDateTime);
    procedure SetFloats(idx: Integer; const Value: Double);
    procedure SetInts(idx: Integer; const Value: Integer);
    function GetTimes(idx: Integer): TDateTime;
    procedure SetTimes(idx: Integer; const Value: TDateTime);
    procedure SetEditorType(const Value: TEditorType);
    procedure SetShowBands(const Value: Boolean);
    procedure SetFilter(const Value: TStringList);
    procedure FilterChanged(Sender: TObject);
    procedure SetFloatFormat(const Value: string);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property DefIdx: Integer read FDefIdx write FDefIdx;
    property Rows[idx: Integer]: string read GetRows write SetRows;
    property Ints[idx: Integer]: Integer read GetInts write SetInts;
    property Floats[idx: Integer]: Double read GetFloats write SetFloats;
    property Dates[idx: Integer]: TDateTime read GetDates write SetDates;
    property Times[idx: Integer]: TDateTime read GetTimes write SetTimes;
  published
    property AutoMinSize: Integer read FAutoMinSize write FAutoMinSize;
    property AutoMaxSize: Integer read FAutoMaxSize write FAutoMaxSize;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property Borders: TCellBorders read FBorders write SetBorders;
    property BorderPen: TPen read FBorderPen write SetBorderPen;
    property CheckFalse: string read FCheckFalse write FCheckFalse;
    property CheckTrue: string read FCheckTrue write FCheckTrue;
    property Color: TColor read FColor write SetColor;
    property ColumnPopup: TPopupMenu read FColumnPopup write FColumnPopup;
    property ColumnPopupType: TColumnPopupType read FColumnPopupType write FColumnPopupType;
    property ComboItems: TStringList read FComboItems write SetComboItems;
    property EditLength: Integer read FEditLength write FEditLength;
    property EditLink: TEditLink read FEditLink write FEditLink;
    property EditMask: string read FEditMask write FEditMask;
    property Editor: TEditorType read FEditorType write SetEditorType;
    property Filter: TStringList read FFilter write SetFilter;
    property FilterCaseSensitive: Boolean read FFilterCaseSensitive write FFilterCaseSensitive;
    property Fixed: Boolean read FFixed write SetFixed;
    property FloatFormat: string read FFloatFormat write SetFloatFormat;
    property Font: TFont read FFont write SetFont;
    property Header: string read FColumnHeader write SetColumnHeader;
    property MinSize: Integer read FMinSize write FMinSize;
    property MaxSize: Integer read FMaxSize write FMaxSize;
    property Name: string read FName write FName;
    property Password: Boolean read FPassword write SetPassword;
    property PrintBorders: TCellBorders read FPrintBorders write FPrintBorders;
    property PrintBorderPen: TPen read fPrintBorderPen write FPrintBorderPen;
    property PrintColor: TColor read FPrintColor write FPrintColor;
    property PrintFont: TFont read FPrintFont write FPrintFont;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property ShowBands: Boolean read FShowBands write SetShowBands;
    property SortStyle: TSortStyle read FSortStyle write fSortStyle;
    property SortPrefix: string read FSortPrefix write FSortPrefix;
    property SortSuffix: string read FSortSuffix write FSortSuffix;
    property SpinMax: Integer read FSpinMax write FSpinMax;
    property SpinMin: Integer read FSpinMin write FSpinMin;
    property SpinStep: Integer read FSpinStep write FSpinStep;
    property Tag: Integer read FTag write FTag;
    property Width: Integer read FWidth write SetWidth;
  end;

  TGridColumnCollection = class(TCollection)
  private
    FOwner: TAdvColumnGrid;
    FNoRecursiveUpdate: Boolean;
    function GetItem(Index: Integer): TGridColumnItem;
    procedure SetItem(Index: Integer; const Value: TGridColumnItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function GetItemClass: TCollectionItemClass; virtual;
    function Add: TGridColumnItem;
    function Insert(index: Integer): TGridColumnItem;
    property Items[Index: Integer]: TGridColumnItem read GetItem write SetItem; default;
    constructor Create(AOwner: TAdvColumnGrid);
    function GetOwner: TPersistent; override;
    procedure SetOrganization;
    procedure ResetOrganization;
  end;

  TAdvColumnGrid = class(TAdvStringGrid)
  private
    FColumnCollection: TGridColumnCollection;
    FColMoving: Boolean;
    FCellGraphic: TCellGraphic;
    FDropList: TDropList;
    FFilterCol: Integer;
    FAutoFilterDisplay: Boolean;
    FAutoFilterUpdate: Boolean;
    FFilterDropDown: TFilterDropDown;
    FOnFilterSelect: TFilterSelectEvent;
    FOnColumnPopup: TColumnPopupEvent;
    FOnFilterDone: TNotifyEvent;
    procedure SetColumnCollection(const Value: TGridColumnCollection);
    function GetColCount: integer;
    procedure SetColCount(const Value: integer);
    procedure SynchColumns;
    function GetColumnByName(AValue: string): TGridColumnItem;
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure ColWidthsChanged; override;
    procedure CellsLoaded; override;
    procedure Loaded; override;
    procedure FilterSelect(Sender: TObject; ItemIndex: Integer);
    function GetFilter(ACol: Integer): Boolean; override;
    procedure UpdateColSize(ACol: Integer; var NewWidth: Integer); override;
    procedure UpdateAutoColSize(ACol: Integer; var NewWidth: Integer); override;
    procedure UpdateColHeaders; override;
    function GetEditMask(ACol, ARow: Longint): string; override;
    function GetEditLimit: Integer; override;
    function GetCellType(ACol,ARow: Integer): TCellType; override;
    function GetCellGraphic(ACol,ARow: Integer): TCellGraphic; override;
    procedure GetCellColor(ACol,ARow: Integer;AState: TGridDrawState; ABrush: TBrush; AFont: TFont); override;
    procedure GetCellPrintColor(ACol,ARow: Integer;AState: TGridDrawState; ABrush: TBrush; AFont: TFont); override;
    procedure GetCellBorder(ACol,ARow: Integer; APen:TPen;var borders:TCellBorders); override;
    procedure GetCellPrintBorder(ACol,ARow: Integer; APen:TPen;var borders:TCellBorders); override;
    procedure GetCellAlign(ACol,ARow: Integer;var HAlign:TAlignment;var VAlign: TVAlignment); override;
    procedure GetColFormat(ACol: Integer;var ASortStyle:TSortStyle;var aPrefix,aSuffix:string); override;
    procedure GetCellEditor(ACol,ARow: Integer;var AEditor:TEditorType); override;
    procedure GetCellFixed(ACol,ARow: Integer;var IsFixed: Boolean); override;
    procedure GetCellReadOnly(ACol,ARow: Integer;var IsReadOnly: Boolean); override;
    procedure GetCellPassword(ACol,ARow: Integer;var IsPassword: Boolean); override;
    function GetFormattedCell(ACol,ARow: Integer): string; override;
    function GetCheckTrue(ACol,ARow: Integer): string; override;
    function GetCheckFalse(ACol,ARow: Integer): string; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function CreateColumns: TGridColumnCollection; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetVersionNr: Integer; override;
    function GetVersionString:string; override;
    procedure SaveColumnsToStream(st: TStream);
    procedure LoadColumnsFromStream(st: TStream);
    property ColumnByName[AValue:string]: TGridColumnItem read GetColumnByName;
    procedure SaveColumnPositions(Key,Section: string);
    procedure LoadColumnPositions(Key,Section: string);
    procedure RemoveCols(ColIndex, CCount: Integer); override;
    procedure InsertCols(ColIndex, CCount: Integer); override;        
  published
    property AutoFilterUpdate: Boolean read FAutoFilterUpdate write FAutoFilterUpdate default False;
    property AutoFilterDisplay: Boolean read FAutoFilterDisplay write FAutoFilterDisplay default False;
    property Columns: TGridColumnCollection read FColumnCollection write SetColumnCollection;
    property ColCount: Integer read GetColCount write SetColCount;
    property FilterDropDown: TFilterDropDown read FFilterDropDown write FFilterDropDown;
    property OnColumnPopup: TColumnPopupEvent read FOnColumnPopup write FOnColumnPopup;
    property OnFilterSelect: TFilterSelectEvent read FOnFilterSelect write FOnFilterSelect;
    property OnFilterDone: TNotifyEvent read FOnFilterDone write FOnFilterDone;
  end;

  TAdvColumnGridIO = class(TComponent)
  private
    FItems: TGridColumnCollection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Items: TGridColumnCollection read FItems write FItems;
  end;


implementation

{ TGridColumnItem }

constructor TGridColumnItem.Create(Collection:TCollection);
begin
  inherited;
  FWidth := 50;
  FFont := TFont.Create;
  FPrintFont := TFont.Create;
  FBorderPen := TPen.Create;
  FBorderPen.Width := 1;
  FBorderPen.Color := clSilver;

  FPrintBorders := [cbTop,cbLeft,cbRight,cbBottom];
  FPrintBorderPen := TPen.Create;
  FPrintBorderPen.Width := 1;
  FPrintBorderPen.Color := clBlack;

  FFont.Assign((TGridColumnCollection(Collection).FOwner).Font);
  FPrintFont.Assign((TGridColumnCollection(Collection).FOwner).Font);
  FColor := TGridColumnCollection(Collection).FOwner.Color;
  FPrintColor := clWhite;
  FFont.OnChange := FontChanged;
  FBorderPen.OnChange := PenChanged;
  FComboItems := TStringList.Create;
  FCheckTrue := 'Y';
  FCheckFalse := 'N';
  FSpinStep := 1;


  FMinSize := 0;
  FMaxSize := 0;
  FFilter := TStringList.Create;
  FFilter.OnChange := FilterChanged;
end;

destructor TGridColumnItem.Destroy;
begin
  FFilter.Free;
  FFont.Free;
  FPrintFont.Free;
  FComboItems.Free;
  FBorderPen.Free;
  FPrintBorderPen.Free;
  inherited Destroy;
end;

procedure TGridColumnItem.FontChanged(Sender:TObject);
begin
  TGridColumnCollection(Collection).Update(self);
end;

procedure TGridColumnItem.PenChanged(Sender:TObject);
begin
  TGridColumnCollection(Collection).Update(self);
end;

procedure TGridColumnItem.SetWidth(const Value: Integer);
begin
  FWidth := Value;
  TGridColumnCollection(Collection).FOwner.AllColWidths[Index] := FWidth;
end;

procedure TGridColumnItem.SetAlignment(const Value:TAlignment);
begin
  FAlignment := Value;
  TGridColumnCollection(Collection).Update(Self);
end;

procedure TGridColumnItem.SetColumnHeader(const Value:string);
var
  i: Integer;
begin
  FColumnHeader := Value;
  if (TGridColumnCollection(Collection).FOwner.FixedRows > 0) and
    not TGridColumnCollection(Collection).FOwner.FColMoving then
  begin
    TGridColumnCollection(Collection).FOwner.Cells[Index,0] := Value;
    TGridColumnCollection(Collection).Update(Self);
  end;

  TGridColumnCollection(Collection).FOwner.ColumnHeaders.Clear;

  for i := 1 to TGridColumnCollection(Collection).Count do
  begin
    TGridColumnCollection(Collection).FOwner.ColumnHeaders.Add(
       TGridColumnCollection(Collection).Items[i - 1].Header);
  end;
end;

procedure TGridColumnItem.SetFont(const value:TFont);
begin
  FFont.Assign(value);
  TGridColumnCollection(Collection).Update(Self);
end;

procedure TGridColumnItem.SetColor(const Value:TColor);
begin
  FColor := Value;
  TGridColumnCollection(Collection).Update(Self);
end;

procedure TGridColumnItem.SetShowBands(const Value: Boolean);
begin
  FShowBands := Value;
  TGridColumnCollection(Collection).Update(Self);  
end;

procedure TGridColumnItem.SetFixed(const Value: Boolean);
begin
  FFixed := Value;
  TGridColumnCollection(Collection).Update(Self);
end;

procedure TGridColumnItem.Assign(Source: TPersistent);
begin
  if Source is TGridColumnItem then
  begin
    FAlignment := TGridColumnItem(Source).Alignment;
    FBorderPen.Assign(TGridColumnItem(Source).BorderPen);
    FBorders := TGridColumnItem(Source).Borders;
    FCheckFalse := TGridColumnItem(Source).CheckFalse;
    FCheckTrue := TGridColumnItem(Source).CheckTrue;
    FColor := TGridColumnItem(Source).Color;
    FComboItems.Assign(TGridColumnItem(Source).ComboItems);
    FEditLength := TGridColumnItem(Source).EditLength;
    FEditLink := TGridColumnItem(Source).EditLink;
    FEditMask := TGridColumnItem(Source).EditMask;
    FEditorType := TGridColumnItem(Source).Editor;
    FFixed := TGridColumnItem(Source).Fixed;
    FFont.Assign(TGridColumnItem(Source).Font);
    FColumnHeader := TGridColumnItem(source).Header;
    FName := TGridColumnItem(Source).Name;
    FPassword := TGridColumnItem(Source).Password;
    FPrintBorderPen.Assign(TGridColumnItem(Source).PrintBorderPen);
    FPrintBorders := TGridColumnItem(Source).PrintBorders;
    FPrintColor := TGridColumnItem(Source).PrintColor;
    FPrintFont.Assign(TGridColumnItem(Source).PrintFont);
    FReadOnly := TGridColumnItem(Source).ReadOnly;
    FSortPrefix := TGridColumnItem(Source).SortPrefix;
    FSortStyle := TGridColumnItem(Source).SortStyle;
    FSortSuffix := TGridColumnItem(Source).SortSuffix;
    FSpinMax := TGridColumnItem(Source).SpinMax;
    FSpinMin := TGridColumnItem(Source).SpinMin;
    FSpinStep := TGridColumnItem(Source).SpinStep;
    FColumnPopup := TGridColumnItem(Source).ColumnPopup;
    FTag := TGridColumnItem(Source).Tag;
    FWidth := TGridColumnItem(Source).Width;
    FShowBands := TGridColumnItem(Source).ShowBands;
    FMinSize := TGridColumnItem(Source).MinSize;
    FMaxSize := TGridColumnItem(Source).MaxSize;
    FAutoMinSize := TGridColumnItem(Source).AutoMinSize;
    FAutoMaxSize := TGridColumnItem(Source).AutoMaxSize;
    FFilter.Assign(TGridColumnItem(Source).Filter);
    FFilterCaseSensitive := TGridColumnItem(Source).FilterCaseSensitive;
    FDefIdx := TGridColumnItem(Source).DefIdx;
  end;
end;

function TGridColumnItem.GetDisplayName: string;
begin
  if Name = '' then
    Result := 'Column ' + Inttostr(Index)
  else
    Result := Name;
end;

procedure TGridColumnItem.SetComboItems(const Value: TStringList);
begin
  FComboItems.Assign(Value);
end;

procedure TGridColumnItem.SetPassword(const Value: Boolean);
begin
  FPassword := Value;
  TGridColumnCollection(Collection).Update(Self);
end;

procedure TGridColumnItem.SetBorderPen(const Value: TPen);
begin
  FBorderPen := Value;
  TGridColumnCollection(Collection).Update(Self);
end;

procedure TGridColumnItem.SetBorders(const Value: TCellBorders);
begin
  FBorders := Value;
  TGridColumnCollection(Collection).Update(Self);
end;

function TGridColumnItem.GetRows(idx: integer): string;
begin
  Result := (Collection as TGridColumnCollection).FOwner.Cells[Index,idx];
end;

procedure TGridColumnItem.SetRows(idx: integer; const Value: string);
begin
  (Collection as TGridColumnCollection).FOwner.Cells[Index,idx] := Value;
end;

function TGridColumnItem.GetDates(idx: Integer): TDateTime;
begin
  Result := (Collection as TGridColumnCollection).FOwner.Dates[Index,idx];
end;

function TGridColumnItem.GetFloats(idx: Integer): Double;
begin
  Result := (Collection as TGridColumnCollection).FOwner.Floats[Index,idx];
end;

function TGridColumnItem.GetInts(idx: Integer): Integer;
begin
  Result := (Collection as TGridColumnCollection).FOwner.Ints[Index,idx];
end;

procedure TGridColumnItem.SetDates(idx: Integer; const Value: TDateTime);
begin
  (Collection as TGridColumnCollection).FOwner.Dates[Index,idx] := Value;
end;

procedure TGridColumnItem.SetFloats(idx: Integer; const Value: Double);
begin
  (Collection as TGridColumnCollection).FOwner.Floats[Index,idx] := Value;
end;

procedure TGridColumnItem.SetInts(idx: Integer; const Value: Integer);
begin
  (Collection as TGridColumnCollection).FOwner.Ints[Index,idx] := Value;
end;

function TGridColumnItem.GetTimes(idx: Integer): TDateTime;
begin
  Result := (Collection as TGridColumnCollection).FOwner.Times[Index,idx];
end;

procedure TGridColumnItem.SetTimes(idx: Integer; const Value: TDateTime);
begin
  (Collection as TGridColumnCollection).FOwner.Times[Index,idx] := Value;
end;

procedure TGridColumnItem.SetEditorType(const Value: TEditorType);
var
  UpdateFlg: Boolean;
begin
  if FEditorType <> Value then
  begin
    UpdateFlg := (FEditorType = edDataCheckBox) or (Value = edDataCheckBox);
    FEditorType := Value;
    if UpdateFlg then
      (Collection as TGridColumnCollection).FOwner.Invalidate;
  end;
end;


procedure TGridColumnItem.SetFilter(const Value: TStringList);
begin
  FFilter.Assign(Value);
end;

procedure TGridColumnItem.FilterChanged(Sender: TObject);
begin
  (Collection as TGridColumnCollection).FOwner.Invalidate;
end;

procedure TGridColumnItem.SetFloatFormat(const Value: string);
begin
  FFloatFormat := Value;
  (Collection as TGridColumnCollection).FOwner.Invalidate;
end;

{ TGridColumnCollection }

function TGridColumnCollection.Add: TGridColumnItem;
begin
  Result := TGridColumnItem(inherited Add);
end;

constructor TGridColumnCollection.Create(AOwner:TAdvColumnGrid);
begin
  inherited Create(GetItemClass);
  FOwner := AOwner;
  FNoRecursiveUpdate := False;
end;

function TGridColumnCollection.GetItem(Index: Integer): TGridColumnItem;
begin
  Result := TGridColumnItem(inherited GetItem(Index));
end;


function TGridColumnCollection.GetItemClass: TCollectionItemClass;
begin
  Result := TGridColumnItem;
end;

function TGridColumnCollection.GetOwner:TPersistent;
begin
  Result := FOwner;
end;

function TGridColumnCollection.Insert(Index: Integer): TGridColumnItem;
{$IFDEF VER100}
var
  i: Integer;
{$ENDIF}
begin
{$IFNDEF VER100}
  Result := TGridColumnItem(inherited Insert(Index));
{$ELSE}
  inherited Add;
  for i := Count - 1 downto Index + 1 do
    TGridColumnItem(Items[i]).Assign(TGridColumnItem(Items[i - 1]));
  Result := TGridColumnItem(Items[Index]);
{$ENDIF}
end;

procedure TGridColumnCollection.ResetOrganization;
var
  i: Integer;
  rst: Boolean;
begin
  rst := False;
  while not rst do
  begin
    rst := True;
    for i := 1 to Count do
    begin
      if i - 1 > Items[i - 1].DefIdx then
      begin
        rst := False;
        FOwner.MoveColumn(i - 1,Items[i - 1].DefIdx);
      end;
    end;
  end;
end;

procedure TGridColumnCollection.SetItem(Index: Integer;
  const Value: TGridColumnItem);
begin
  inherited SetItem(Index, Value);
end;


procedure TGridColumnCollection.SetOrganization;
var
  i: Integer;
begin
  FNoRecursiveUpdate := True;
  FOwner.SynchColumns;
  FNoRecursiveUpdate := False;

  for i := 1 to Count do
    Items[i - 1].DefIdx := i - 1;

{$IFDEF TMSDEBUG}
  for i := 1 to Count do
    outputdebugstring(pchar(inttostr(Items[i-1].DefIdx)));
{$ENDIF}
end;

procedure TGridColumnCollection.Update(Item:TCollectionItem);
var
  VisCols: Integer;  
begin
  inherited Update(Item);
  //reflect changes
  if not FNoRecursiveUpdate then
  begin
    VisCols := Count - FOwner.NumHiddenColumns;
    //if (csDesigning in fOwner.ComponentState) then
    if (VisCols <> FOwner.ColCount) and (VisCols > FOwner.FixedCols) then
      FOwner.ColCount := VisCols;
    FOwner.Invalidate;
   end;
end;


{ TAdvColumnGrid }

procedure TAdvColumnGrid.ColumnMoved(FromIndex, ToIndex: Integer);
var
  CN: TGridColumnItem;
  tr: Integer;
  RFI,RTI: Integer;
begin
  FColumnCollection.FNoRecursiveUpdate := True;
  SynchColumns;

  tr := TopRow;

  RFI := RealColIndex(FromIndex);
  RTI := RealColIndex(ToIndex);

  inherited;


  BeginUpdate;
  FColMoving := True;
  TGridColumnItem(FColumnCollection.Add).Assign(TGridColumnItem(FColumnCollection.Items[RFI]));
  TGridColumnItem(FColumnCollection.Items[RFI]).Free;
  CN := TGridColumnItem(FColumnCollection.Insert(RTI));
  CN.Assign(FColumnCollection.Items[FColumnCollection.Count - 1]);
  FColumnCollection.Items[FColumnCollection.Count - 1].Free;
  TopRow := tr;
  FColMoving := False;
  EndUpdate;
  FColumnCollection.FNoRecursiveUpdate := False;
  //HideSelection;
end;

procedure TAdvColumnGrid.ColWidthsChanged;

var
  i: Integer;

begin
  inherited;

  for i := 1 to ColCount do
  begin
    if i <= FColumnCollection.Count then
    TGridColumnItem(FColumnCollection.Items[i - 1]).FWidth := ColWidths[i - 1];
  end;

end;


constructor TAdvColumnGrid.Create(AOwner: TComponent);
begin
  inherited;
  FColumnCollection := CreateColumns;
  FColumnCollection.FNoRecursiveUpdate := True;
  SynchColumns;
  FColumnCollection.FNoRecursiveUpdate := False;
  FColMoving := False;
  FCellGraphic := TCellGraphic.Create;

  FDropList := TDropList.Create(Self);
  FDropList.Parent := Self;
  FDropList.Width := 0;
  FDropList.Height := 0;
  FDropList.Visible := False;
  FDropList.OnSelect := FilterSelect;
  FFilterCol := -1;

  FFilterDropDown := TFilterDropDown.Create;
end;

destructor TAdvColumnGrid.Destroy;
begin
  FFilterDropDown.Free;
  FDropList.Free;
  FColumnCollection.Free;
  FCellGraphic.Free;
  inherited;
end;

procedure TAdvColumnGrid.GetCellAlign(ACol, ARow: integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if FColumnCollection.Count > Acol then
  begin
     HAlign := TGridColumnItem(FColumnCollection.Items[ACol]).Alignment;
  end;
  inherited;
end;

procedure TAdvColumnGrid.GetCellBorder(ACol, ARow: integer; APen: TPen;
  var borders: TCellBorders);
begin
  if FColumnCollection.Count > Acol then
  begin
    if (ACol >= FixedCols) and (Arow >= FixedRows) then
    begin
      Borders := TGridColumnItem(FColumnCollection.Items[ACol]).Borders;
      APen.Assign(TGridColumnItem(FColumnCollection.Items[ACol]).BorderPen);
    end;
  end;
  inherited;
end;

procedure TAdvColumnGrid.GetCellPrintBorder(ACol, ARow: integer; APen: TPen;
  var borders: TCellBorders);
begin
  if FColumnCollection.Count > Acol then
  begin
    if (ACol >= FixedCols) and (Arow >= FixedRows) then
    begin
      Borders := TGridColumnItem(FColumnCollection.Items[ACol]).PrintBorders;
      APen.Assign(TGridColumnItem(FColumnCollection.Items[ACol]).PrintBorderPen);
    end;
  end;
  inherited;
end;

procedure TAdvColumnGrid.GetCellPrintColor(ACol, ARow: integer;
  AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if FColumnCollection.Count > ACol then
  begin

    if (ACol >= FixedCols) and (Arow >= FixedRows) and
       (ACol < ColCount - FixedRightCols + NumHiddenColumns) and
       (ARow < RowCount - FixedFooters) then
    begin
      if TGridColumnItem(FColumnCollection.Items[ACol]).Fixed then
        ABrush.Color := FixedColor
      else
        if not (TGridColumnItem(FColumnCollection.Items[ACol]).ShowBands and Bands.Active and Bands.Print) then
          ABrush.Color := TGridColumnItem(FColumnCollection.Items[ACol]).PrintColor;

      AFont.Assign(TGridColumnItem(FColumnCollection.Items[ACol]).PrintFont);
    end
    else
    begin
      AFont.Assign(PrintSettings.HeaderFont);
    end;
  end;
  inherited;
end;


procedure TAdvColumnGrid.GetCellColor(ACol, ARow: integer;
  AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if FColumnCollection.Count > Acol then
  begin
    if (ACol >= FixedCols) and (Arow >= FixedRows) and
       (ACol < ColCount - FixedRightCols + NumHiddenColumns) and
       (ARow < RowCount - FixedFooters) then
    begin
      if TGridColumnItem(FColumnCollection.Items[ACol]).Fixed then
        ABrush.Color := FixedColor
      else
        if not (TGridColumnItem(FColumnCollection.Items[ACol]).ShowBands and Bands.Active) then
          ABrush.Color := TGridColumnItem(FColumnCollection.Items[ACol]).Color;

      AFont.Assign(TGridColumnItem(FColumnCollection.Items[ACol]).Font);
    end;
  end;
  inherited;
end;

procedure TAdvColumnGrid.GetCellEditor(ACol, ARow: integer;
  var AEditor: TEditorType);
begin
  if FColumnCollection.Count > ACol then
  begin
    if (ACol >= FixedCols) and (Arow >= FixedRows) then
    begin
      AEditor := TGridColumnItem(FColumnCollection.Items[acol]).Editor;
      ComboBox.Items.Assign(TGridColumnItem(FColumnCollection.Items[ACol]).ComboItems);
      SpinEdit.MinValue := TGridColumnItem(FColumnCollection.Items[ACol]).SpinMin;
      SpinEdit.MaxValue := TGridColumnItem(FColumnCollection.Items[ACol]).SpinMax;
      SpinEdit.Increment := TGridColumnItem(FColumnCollection.Items[ACol]).SpinStep;
      EditLink := TGridColumnItem(FColumnCollection.Items[ACol]).EditLink;
    end;
  end;
  inherited;
end;

procedure TAdvColumnGrid.GetCellFixed(ACol, ARow: integer;
  var IsFixed: boolean);
begin
  if FColumnCollection.Count > Acol then
  begin
    if (ACol >= FixedCols) and (Arow >= FixedRows) then
    begin
      IsFixed := TGridColumnItem(FColumnCollection.Items[ACol]).Fixed;
    end;
  end;
  inherited;
end;

procedure TAdvColumnGrid.GetCellPassword(ACol, ARow: integer;
  var IsPassword: boolean);
begin
  if FColumnCollection.Count > Acol then
  begin
    IsPassword := TGridColumnItem(FColumnCollection.Items[ACol]).Password;
  end;
  inherited;
end;

procedure TAdvColumnGrid.GetCellReadOnly(ACol, ARow: integer;
  var IsReadOnly: boolean);
begin
  IsReadOnly := False;

  if not (csLoading in ComponentState) then
  begin
    if FColumnCollection.Count > ACol then
    begin
      if (ACol >= FixedCols) and (ARow >= FixedRows) then
      begin
        IsReadOnly := not TGridColumnItem(FColumnCollection.Items[ACol]).ReadOnly and
                      not TGridColumnItem(FColumnCollection.Items[ACol]).Fixed;
      end;
    end;
  end;
    
  inherited;
end;

function TAdvColumnGrid.GetColCount: integer;
begin
  Result := inherited ColCount;
end;

procedure TAdvColumnGrid.GetColFormat(ACol: integer;
  var ASortStyle: TSortStyle; var aPrefix, aSuffix: string);
begin
  if FColumnCollection.Count > ACol then
  begin
    if ACol >= FixedCols then
    begin
      ASortStyle := TGridColumnItem(FColumnCollection.Items[ACol]).SortStyle;
      APrefix := TGridColumnItem(FColumnCollection.Items[ACol]).SortPrefix;
      ASuffix := TGridColumnItem(FColumnCollection.Items[ACol]).SortSuffix;
    end;
  end;
  inherited;
end;

function TAdvColumnGrid.GetEditLimit: Integer;
begin
  Result := 0;
  if FColumnCollection.Count > Col then
  begin
    if Col >= FixedCols then
    begin
      Result := TGridColumnItem(FColumnCollection.Items[RealColIndex(Col)]).EditLength;
    end;
  end;
end;

function TAdvColumnGrid.GetEditMask(ACol, ARow: Integer): string;
var
  msk: string;
begin
  if FColumnCollection.Count > Acol then
  begin
    if ACol >= FixedCols then
    begin
      Result := TGridColumnItem(FColumnCollection.Items[RealColIndex(ACol)]).EditMask;
    end;
  end;
  msk := inherited GetEditMask(ACol,ARow);
  if msk <> '' then
    Result := msk;
end;

function TAdvColumnGrid.GetVersionNr: Integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

function TAdvColumnGrid.GetVersionString: string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)))+' '+DATE_VER;
end;

procedure TAdvColumnGrid.Loaded;
begin
  inherited;
  SynchColumns;
  Columns.SetOrganization; 
end;

procedure TAdvColumnGrid.SetColCount(const Value: integer);
begin
  inherited ColCount := Value;
  FColumnCollection.FNoRecursiveUpdate := True;
  SynchColumns;
  FColumnCollection.FNoRecursiveUpdate := False;
end;

procedure TAdvColumnGrid.SetColumnCollection(const value :TGridColumnCollection);
begin
  FColumnCollection.Assign(Value);
end;

procedure TAdvColumnGrid.SynchColumns;
var
  i,j: Integer;
begin
  while FColumnCollection.Count < ColCount + NumHiddenColumns do
  begin
    FColumnCollection.Add;
  end;

  while FColumnCollection.Count > ColCount + NumHiddenColumns do
  begin

    FColumnCollection.Items[FColumnCollection.Count - 1].Free;
  end;

  if csDesigning in ComponentState then
    for i := 1 to ColCount do
      Cells[i - 1,FixedRows] := 'Column ' + IntToStr(i - 1);

  if FixedRows > 0 then
    for i := 1 to ColCount do
    begin
      j := RealColIndex(i - 1);
      FColumnCollection.Items[j].FColumnHeader := Cells[j,0];
    end;  
end;

procedure TAdvColumnGrid.SaveColumnsToStream(st: TStream);
var
  gcio: TAdvColumnGridIO;
begin
  gcio := TAdvColumnGridIO.Create(self);
  gcio.Items.FNorecursiveUpdate := True;
  gcio.Items.Assign(self.Columns);
  st.Writecomponent(gcio);
  gcio.Free;
end;

procedure TAdvColumnGrid.LoadColumnsFromStream(st: TStream);
var
  gcio: TAdvColumnGridIO;
begin
  Columns.FNoRecursiveUpdate := True;

  gcio := TAdvColumnGridIO.Create(Self);
  gcio.Items.FNorecursiveUpdate := True;
  st.ReadComponent(gcio);
  Self.Columns.Assign(gcio.Items);
  gcio.Free;
  Columns.FNoRecursiveUpdate := False;
  Invalidate;
end;



procedure TAdvColumnGrid.Notification(AComponent: TComponent;
  AOperation: TOperation);
var
  i: Integer;
begin
  inherited;
  if (AOperation = opRemove) and (AComponent is TEditLink) then
    for i := 1 to Columns.Count do
      if Columns.Items[i - 1].EditLink = AComponent then
        Columns.Items[i - 1].EditLink := nil;

  if (AOperation = opRemove) and (AComponent is TPopupMenu) then
    for i := 1 to Columns.Count do
      if Columns.Items[i - 1].ColumnPopup = AComponent then
        Columns.Items[i - 1].ColumnPopup := nil;
end;

function TAdvColumnGrid.GetColumnByName(AValue: string): TGridColumnItem;
var
  i: Integer;
begin
  Result := nil;
  i := 0;
  while i < Columns.Count do
  begin
    if Columns.Items[i].Name = AValue then
    begin
      Result := Columns.Items[i];
      Break;
    end;
    inc(i);
  end;
end;

procedure TAdvColumnGrid.CellsLoaded;
begin
  inherited;
  Columns.FNoRecursiveUpdate := True;
  SynchColumns;
  Columns.FNoRecursiveUpdate := False;
end;

function TAdvColumnGrid.GetCellGraphic(ACol, ARow: Integer): TCellGraphic;
begin
  Result := inherited GetCellGraphic(ACol, ARow);

  if (csDestroying in ComponentState) then
    Exit;

  if (FColumnCollection.Count > Acol) and (Result = nil) then
  begin
    if (ACol >= FixedCols) and (Arow >= FixedRows) and
       (ACol < ColCount - FixedRightCols + NumHiddenColumns) and
       (ARow < RowCount - FixedFooters) then
    begin
      if TGridColumnItem(FColumnCollection.Items[ACol]).Editor = edDataCheckBox then
      begin
        FCellGraphic.CellType := ctVirtCheckBox;
        FCellGraphic.CellTransparent := ControlLook.ControlStyle = csFlat;
        Result := FCellGraphic;
      end;
    end;
  end;
end;

function TAdvColumnGrid.GetCellType(ACol, ARow: Integer): TCellType;

begin
  Result := inherited GetCellType(ACol, ARow);

  if Assigned(FColumnCollection) then
  begin
    if (FColumnCollection.Count > Acol) and (Result = ctEmpty) then
    begin
      if (ACol >= FixedCols) and (Arow >= FixedRows) and
         (ACol < ColCount - FixedRightCols + NumHiddenColumns) and
         (ARow < RowCount - FixedFooters) then
      begin
        if TGridColumnItem(FColumnCollection.Items[ACol]).Editor = edDataCheckBox then
        begin
          Result := ctDataCheckBox;
        end;
      end;
    end;
  end;
end;

function TAdvColumnGrid.GetCheckFalse(ACol,ARow: Integer): string;
begin
  Result := inherited GetCheckFalse(ACol,ARow);

  if (FColumnCollection.Count > ACol) then
  begin
    if (ACol >= FixedCols) and (ARow >= FixedRows) and
       (ACol < ColCount - FixedRightCols + NumHiddenColumns) and
       (ARow < RowCount - FixedFooters) then
    begin
      Result := TGridColumnItem(FColumnCollection.Items[ACol]).CheckFalse;
    end;
  end;
end;

function TAdvColumnGrid.GetCheckTrue(ACol,ARow: Integer): string;
begin
  Result := inherited GetCheckTrue(ACol,ARow);

  if (FColumnCollection.Count > Acol) then
  begin
    if (ACol >= FixedCols) and (Arow >= FixedRows) and
       (ACol < ColCount - FixedRightCols + NumHiddenColumns) and
       (ARow < RowCount - FixedFooters) then
    begin
      Result := TGridColumnItem(FColumnCollection.Items[ACol]).CheckTrue;
    end;
  end;
end;

procedure TAdvColumnGrid.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  R,C,I,VP: Integer;
  CR: TRect;
  GC: TGridColumnItem;
  PT: TPoint;
  RC: Integer;
begin
  inherited;

  MouseToCell(X,Y,C,R);
  RC := RealColIndex(C);

  if (R = 0) and (RC <> FFilterCol) then
  begin
    CR := CellRect(C,R);

    if (X > CR.Right - 16) and
       (X < CR.Right - 3) and (FColumnCollection.Items[RC].Filter.Count > 0) then
    begin
      FFilterCol := RC;
      FDropList.Color := FFilterDropDown.Color;
      FDropList.Font.Assign(FFilterDropDown.Font);
      FDropList.Width := FFilterDropDown.Width;
      FDropList.Height := FFilterDropDown.Height;

      if FFilterDropDown.ColumnWidth then
       FDropList.Width := CR.Right - CR.Left;

      FDropList.Top := CR.Bottom;
      FDropList.Left := CR.Left;
      FDropList.Visible := True;
      FDropList.SetFOcus;
      FDropList.Ctl3D := False;
      FDropList.Items.Clear;

      for I := 1 to FColumnCollection.Items[RC].Filter.Count do
      begin

        VP := Pos('=', FColumnCollection.Items[RC].Filter.Strings[I - 1]);
        if VP > 0 then
          FDropList.Items.Add(Copy(FColumnCollection.Items[RC].Filter.Strings[I - 1],1,VP - 1))
        else
          FDropList.Items.Add(FColumnCollection.Items[RC].Filter.Strings[I - 1]);
        if I = 1 then
          FDropList.ItemIndex := 0;
      end;
    end
    else
    begin
      if FDropList.Visible then
        FDropList.Visible := false;
      FFilterCol := -1;
    end;
  end
  else
  begin
    if FDropList.Visible then
      FDropList.Visible := false;
    FFilterCol := -1;
  end;

  if (R <> -1) and (C <> -1) then
  begin
    GC := FColumnCollection.Items[C];
    CR := CellRect(C,R);

    PT := ClientToScreen(Point(CR.Left,CR.Bottom));

    if (Button = mbLeft) and Assigned(GC.ColumnPopup) and
       (GC.ColumnPopupType in [cpFixedCellsLClick,cpNormalCellsLClick,cpAllCellsLClick]) then
    begin
      if Assigned(FOnColumnPopup) then
        FOnColumnPopup(Self,C,R,GC.ColumnPopup);

      if (R < FixedRows) and (GC.ColumnPopupType in [cpFixedCellsLClick,cpAllCellsLClick]) then
      begin
        GC.ColumnPopup.Popup(PT.X,PT.Y);
      end;

      if (R >= FixedRows) and (GC.ColumnPopupType in [cpNormalCellsLClick,cpAllCellsLClick]) then
      begin
        GC.ColumnPopup.Popup(PT.X,PT.Y);
      end;
    end;

    if (Button = mbRight) and Assigned(GC.ColumnPopup) and
       (GC.ColumnPopupType in [cpFixedCellsRClick,cpNormalCellsRClick,cpAllCellsRClick]) then
    begin
      if Assigned(FOnColumnPopup) then
        FOnColumnPopup(Self,C,R,GC.ColumnPopup);

      if (R < FixedRows) and (GC.ColumnPopupType in [cpFixedCellsRClick,cpAllCellsRClick]) then
      begin
        GC.ColumnPopup.Popup(PT.X,PT.Y);
      end;

      if (R >= FixedRows) and (GC.ColumnPopupType in [cpNormalCellsRClick,cpAllCellsRClick]) then
      begin
        GC.ColumnPopup.Popup(PT.X,PT.Y);
      end;
    end;
  end;
end;

function TAdvColumnGrid.GetFilter(ACol: Integer): Boolean;
begin
  if (FColumnCollection.Count > ACol) then
  begin
    Result := FColumnCollection.Items[ACol].Filter.Count > 0;
  end
  else
    Result := False;
end;

procedure TAdvColumnGrid.UpdateColSize(ACol: Integer;
  var NewWidth: Integer);
begin

  if (FColumnCollection.Count > ACol) and (ACol >= 0) then
  begin
    if (FColumnCollection.Items[ACol].MinSize > 0) then
    begin
      if NewWidth < FColumnCollection.Items[ACol].MinSize then
        NewWidth := FColumnCollection.Items[ACol].MinSize;
    end;

    if (FColumnCollection.Items[ACol].MaxSize > 0) then
    begin
      if NewWidth > FColumnCollection.Items[ACol].MaxSize then
        NewWidth := FColumnCollection.Items[ACol].MaxSize;
    end;
  end;
  inherited;

end;

procedure TAdvColumnGrid.UpdateAutoColSize(ACol: Integer;
  var NewWidth: Integer);
begin

  if (FColumnCollection.Count > ACol) and (ACol >= 0) then
  begin
    if (FColumnCollection.Items[ACol].AutoMinSize > 0) then
    begin
      if NewWidth < FColumnCollection.Items[ACol].AutoMinSize then
        NewWidth := FColumnCollection.Items[ACol].AutoMinSize;
    end;

    if (FColumnCollection.Items[ACol].AutoMaxSize > 0) then
    begin
      if NewWidth > FColumnCollection.Items[ACol].AutoMaxSize then
        NewWidth := FColumnCollection.Items[ACol].AutoMaxSize;
    end;
  end;
  inherited;
end;

procedure TAdvColumnGrid.FilterSelect(Sender: TObject; ItemIndex: Integer);
var
  F,FN: string;
begin
  if (FFilterCol >= 0) and (FFilterCol < FColumnCollection.Count) then
  begin
    if (ItemIndex >= 0) and (ItemIndex < FColumnCollection.Items[FFilterCol].Filter.Count) then
    begin
      F := FColumnCollection.Items[FFilterCol].Filter.Strings[ItemIndex];

      if Pos('=',F) > 0 then
        FN := Copy(F,1,Pos('=',F)-1)
      else
        FN := F;

      if FAutoFilterDisplay then
        FColumnCollection.Items[FFilterCol].Header := FN;

      if FAutoFilterUpdate then
        FilterActive := False;

      if Pos('=',F) > 0 then
        F := Copy(F,Pos('=',F)+1,Length(F));

      if Assigned(FOnFilterSelect) then
        FOnFilterSelect(Self,FFilterCol,ItemIndex,FN,F);

      Filter.ColumnFilter[FFilterCol].Condition := F;
      Filter.ColumnFilter[FFilterCol].CaseSensitive :=
        FColumnCollection.Items[FFilterCol].FilterCaseSensitive;

      if FAutoFilterUpdate then
      begin
        FilterActive := True;

        if not ((RowCount = FixedRows) or ((RowCount = 1) and FixedRowAlways)) then
          Row := FixedRows;

        if Assigned(FOnFilterDone) then
          FOnFilterDone(Self);
      end;
    end;
  end;

  FFilterCol := -1;
end;

procedure TAdvColumnGrid.UpdateColHeaders;
var
  i: Integer;
begin
  for i := 1 to Columns.Count do
  begin
    if i < ColumnHeaders.Count then
    begin
      Columns.Items[i - 1].FColumnHeader := ColumnHeaders.Strings[i - 1];
    end;
  end;
end;

procedure TAdvColumnGrid.LoadColumnPositions(Key, Section: string);
var
  IniFile: TIniFile;
  i: Integer;
begin
  IniFile := TIniFile.Create(Key);

  for i := 1 to Columns.Count do
  begin
    Columns[i - 1].DefIdx := IniFile.ReadInteger(Section,'CP'+IntToStr(i - 1),0);
  end;
  IniFile.Free;

  Columns.ResetOrganization;
end;

procedure TAdvColumnGrid.SaveColumnPositions(Key, Section: string);
var
  IniFile: TIniFile;
  i: Integer;
begin
  IniFile := TIniFile.Create(Key);

  for i := 1 to Columns.Count do
  begin
    IniFile.WriteInteger(Section,'CP'+IntToStr(i - 1),Columns[i - 1].DefIdx);
  end;
  IniFile.Free;
end;

function TAdvColumnGrid.CreateColumns: TGridColumnCollection;
begin
  Result := TGridColumnCollection.Create(Self);
end;

function TAdvColumnGrid.GetFormattedCell(ACol, ARow: Integer): string;
var
  fmt: string;
begin
  Result := inherited GetFormattedCell(ACol,ARow);

  if (FColumnCollection.Count > ACol) then
  begin
    fmt := TGridColumnItem(FColumnCollection.Items[ACol]).FloatFormat;

    if (fmt <> '') and (IsType(Result) in [atNumeric,atFloat]) then
    begin
      Result := Format(fmt,[Floats[ACol,ARow]]);
    end;

  end;

end;

procedure TAdvColumnGrid.InsertCols(ColIndex, CCount: Integer);
var
  i: integer;
begin
  inherited;
  for i := 1 to CCount do
    Columns.Insert(ColIndex);
end;

procedure TAdvColumnGrid.RemoveCols(ColIndex, CCount: Integer);
var
  i: integer;
begin
  inherited;
  {$IFDEF DELPHI5_LVL}
  for i := 1 to CCount do
    Columns.Delete(ColIndex);
  {$ELSE}
  for i := 1 to CCount do
    Columns[0].Free;
  {$ENDIF}
end;

{ TAdvColumnGridIO }

constructor TAdvColumnGridIO.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TGridColumnCollection.Create(AOwner as TAdvColumnGrid);
end;

destructor TAdvColumnGridIO.Destroy;
begin
  FItems.Free;
  inherited;
end;

{ FDropList }


procedure TDropList.KeyPress(var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    Visible := False;
    if Assigned(FOnSelect) then
      FOnSelect(Self,ItemIndex);
  end;
end;

procedure TDropList.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;

  Visible := False;
  if Assigned(FOnSelect) then
    FOnSelect(Self,ItemIndex);
end;

{ TFilterDropDown }

constructor TFilterDropDown.Create;
begin
  FFont := TFont.Create;
  FWidth := 200;
  FHeight := 200;
  FColumnWidth := False;
  FColor := clWindow;
end;

destructor TFilterDropDown.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TFilterDropDown.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

initialization
  Classes.RegisterClass(TGridColumnItem);
  Classes.RegisterClass(TGridColumnCollection);
end.
