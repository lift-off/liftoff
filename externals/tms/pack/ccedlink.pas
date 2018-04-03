{**************************************************************************}
{ TADVSTRINGGRID EDITLINK FOR TCOLUMNCOMBOBOX                              }
{ version 1.0 - rel. 2001                                                  }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright � 2000-2001                                         }
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

unit ccedlink;

{$DEFINE ASG194}

interface

uses
  Windows, Classes, Controls, StdCtrls, Graphics, Forms, SysUtils,
  AdvGrid, ColCombo;

type
  TColumnComboEditLink = class(TEditLink)
  private
    FCellHeight: Integer;
    FCombo: TColumnComboBox;
    FFlat: Boolean;
    FDropHeight: Integer;
    FDropWidth: Integer;
    FEtched: Boolean;
    FItems: TStrings;
    FColumns: Integer;
    FEditColumn: Integer;
    FGridLines: Boolean;
    FEditColor: TColor;
    FEditFont: TFont;
    FImages: TImageList;
    FLookupIncr: Boolean;
    FLookupColumn: Integer;
    procedure SetItems(const Value: TStrings);
    procedure SetImages(const Value: TImageList);
  protected
    procedure EditExit(Sender: TObject);
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateEditor(AParent: TWinControl); override;
    function GetEditorValue:string; override;
    procedure SetEditorValue(s:string); override;
    function GetEditControl:TWinControl; override;
    procedure SetProperties; override;
    {$IFDEF ASG194}
    procedure SetCellProps(AColor: TColor; AFont: TFont); override;
    {$ENDIF}
    procedure SetRect(R: TRect); override;
    property Combo: TColumnComboBox read FCombo;
  published
    property Columns: Integer read FColumns write FColumns;
    property DropHeight: Integer read FDropHeight write FDropHeight;
    property DropWidth: Integer read FDropWidth write FDropWidth;
    property EditColumn: Integer read FEditColumn write FEditColumn;
    property Etched: Boolean read FEtched write FEtched;
    property Flat: Boolean read FFlat write FFlat;
    property GridLines: Boolean read FGridLines write FGridLines;
    property Images: TImageList read FImages write SetImages;
    property Items: TStrings read FItems write SetItems;
    property LookupColumn: Integer read FLookupColumn write FLookupColumn;
    property LookupIncr: Boolean read FLookupIncr write FLookupIncr; 
  end;


procedure Register;

implementation

{ TColumnComboEditLink }

constructor TColumnComboEditLink.Create(AOwner: TComponent);
begin
  inherited;
  FCombo := nil;
  FDropHeight := 200;
  FDropWidth := 150;
  FItems := TStringList.Create;
  WantKeyUpDown := True;
end;

procedure TColumnComboEditLink.CreateEditor(AParent: TWinControl);
begin
  inherited;
  if not Assigned(FCombo) then
  begin
    FCombo := TColumnComboBox.Create(AParent);
    FCombo.Parent := AParent;
    FCombo.OnExit := EditExit;
    FCombo.OnKeydown := EditKeyDown;
  end;
end;

destructor TColumnComboEditLink.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TColumnComboEditLink.EditExit(Sender: TObject);
begin
  HideEditor;
end;

function TColumnComboEditLink.GetEditControl: TWinControl;
begin
  Result := FCombo;
end;

function TColumnComboEditLink.GetEditorValue: string;
begin
  if FCombo.ItemIndex >= 0 then
    Result := FCombo.ColumnItems[FCombo.ItemIndex,FEditColumn];
end;

procedure TColumnComboEditLink.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
   if (AOperation = opRemove) and (AComponent = FImages) then
     FImages:=nil;
   inherited;
end;

{$IFDEF ASG194}
procedure TColumnComboEditLink.SetCellProps(AColor: TColor; AFont: TFont);
begin
  FCombo.Color := AColor;
  FCombo.Font := AFont;
  FEditColor := AColor;
  FEditFont := AFont;
end;
{$ENDIF}

procedure TColumnComboEditLink.SetEditorValue(s: string);
var
  i: Integer;
begin
  if (FEditColumn < 0) or (FEditColumn > FCombo.Columns.Count) then
    Exit;

  for i := 1 to FCombo.ComboItems.Count do
  begin
    if FCombo.ColumnItems[i - 1,FEditColumn] = s then
    begin
      FCombo.ItemIndex := i - 1;
      Break;
    end;
  end;
end;

procedure TColumnComboEditLink.SetImages(const Value: TImageList);
begin
  FImages := Value;
end;

procedure TColumnComboEditLink.SetItems(const Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TColumnComboEditLink.SetProperties;
var
  i: Integer;
begin
  inherited;
  FCombo.Flat := FFlat;
  FCombo.Etched := FEtched;
  FCombo.DropHeight := FDropHeight;
  FCombo.Height := FDropHeight;
  FCombo.DropWidth := FDropWidth;
  FCombo.LookupColumn := FLookupColumn;
  FCombo.LookupIncr := FLookupIncr;

  if FFlat then
    FCombo.EditHeight :=  FCellHeight - 6
  else
    FCombo.EditHeight :=  FCellHeight - 4;

  FCombo.EditColumn := FEditColumn;
  FCombo.GridLines := FGridLines;

  FCombo.BeginUpdate;
  FCombo.Columns.Clear;

  if Assigned(FImages) then
    FCombo.Images := FImages
  else
    FCombo.Images := nil;

  for i := 1 to FColumns do
  begin
    with FCombo.Columns.Add do
    begin
      {$IFDEF ASG194}
      Color := FEditColor;
      Font.Assign(FEditFont);
      {$ENDIF}
    end;
  end;
    
  FCombo.ComboItems.Clear;
  for i := 1 to FItems.Count do
  begin
    with FCombo.ComboItems.Add do
      Strings.CommaText := FItems.Strings[i - 1];
  end;
  FCombo.EndUpdate;
end;

procedure TColumnComboEditLink.SetRect(r: TRect);
begin
  inherited;
  FCellHeight := r.Bottom - r.Top;
end;

procedure Register;
begin
  RegisterComponents('TMS EditLinks', [TColumnComboEditLink]);
end;

end.
