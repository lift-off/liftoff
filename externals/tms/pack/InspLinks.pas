{***************************************************************************}
{ TInspectorBar EditLink components                                         }
{ for Delphi & C++Builder                                                   }
{ version 1.1                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright � 2001 - 2002                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of TMS software.                                    }
{***************************************************************************}

unit InspLinks;

interface

uses
  Windows, Graphics, Forms, Classes, InspectorBar, AdvEdit, Controls, ColCombo,
  StdCtrls, Dialogs, Messages, AdvMoneyEdit;

type
  TAEInspectorEditLink = class(TInspectorEditLink)
  private
    FAdvEdit: TAdvEdit;
    FShowModified: Boolean;
    FPrecision: integer;
    FSuffix: string;
    FPrefix: string;
    FEditType: TAdvEditType;
    FModifiedColor: TColor;
    FEditColor: TColor;
    FEditAlign: TEditAlign;
    FOrigValue: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetEditor: TWinControl; override;
    procedure CreateEditor(AParent: TWinControl); override;
    procedure DestroyEditor; override;
    procedure SetProperties(R: TRect; Item: TInspectorItem); override;
    procedure SetOriginalValue; override;
    procedure StartEdit(Item: TInspectorItem); override;
    procedure StopEdit(Item: TInspectorItem); override;
  published
    property EditAlign:TEditAlign read FEditAlign write FEditAlign;
    property EditColor:TColor read FEditColor write FEditColor;
    property ModifiedColor:TColor read FModifiedColor write FModifiedColor;
    property EditType:TAdvEditType read FEditType write FEditType;
    property Prefix:string read FPrefix write FPrefix;
    property ShowModified: Boolean read FShowModified write FShowModified;
    property Suffix:string read FSuffix write FSuffix;
    property Precision:integer read FPrecision write FPrecision;
  end;

  TColComboInspectorEditLink = class(TInspectorEditLink)
  private
    FColCombo: TColumnComboBox;
    FDropDownHeight: Integer;
    FDropDownWidth: Integer;
    FEditColumn: Integer;
    FOrigIndex: Integer;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetEditor: TWinControl; override;
    procedure CreateEditor(AParent: TWinControl); override;
    procedure DestroyEditor; override;
    procedure SetProperties(R: TRect; Item: TInspectorItem); override;
    procedure SetOriginalValue; override;
    procedure StartEdit(Item: TInspectorItem); override;
    procedure StopEdit(Item: TInspectorItem); override;
    property ColumnComboBox: TColumnComboBox read FColCombo;
  published
    property DropHeight: Integer read FDropDownHeight write FDropDownHeight;
    property DropWidth: Integer read FDropDownWidth write FDropDownWidth;
    property EditColumn: Integer read FEditColumn write FEditColumn;
  end;

  TMemoInspectorEditLink = class(TInspectorEditLink)
  private
    FEdit: TMemo;
    FColor: TColor;
    FScrollbars: TScrollStyle;
    FSelectAll: Boolean;
    FOrigValue: string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetEditor: TWinControl; override;
    procedure CreateEditor(AParent: TWinControl); override;
    procedure DestroyEditor; override;
    procedure SetProperties(R: TRect; Item: TInspectorItem); override;
    procedure SetOriginalValue; override;
    procedure StartEdit(Item: TInspectorItem); override;
    procedure StopEdit(Item: TInspectorItem); override;
  published
    property Color: TColor read FColor write FColor;
    property Scrollbars: TScrollStyle read FScrollbars write FScrollbars;
    property SelectAll: Boolean read FSelectAll write FSelectAll;
  end;

  TAdvMoneyEditInspectorEditLink = class(TInspectorEditLink)
  private
    FAdvEdit: TAdvMoneyEdit;
    FShowModified: Boolean;
    FPrecision: integer;
    FSuffix: string;
    FPrefix: string;
    FEditType: TAdvEditType;
    FModifiedColor: TColor;
    FEditColor: TColor;
    FEditAlign: TEditAlign;
    FOrigValue: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetEditor: TWinControl; override;
    procedure CreateEditor(AParent: TWinControl); override;
    procedure DestroyEditor; override;
    procedure SetProperties(R: TRect; Item: TInspectorItem); override;
    procedure SetOriginalValue; override;
    procedure StartEdit(Item: TInspectorItem); override;
    procedure StopEdit(Item: TInspectorItem); override;
  published
    property EditAlign:TEditAlign read FEditAlign write FEditAlign;
    property EditColor:TColor read FEditColor write FEditColor;
    property ModifiedColor:TColor read FModifiedColor write FModifiedColor;
    property EditType:TAdvEditType read FEditType write FEditType;
    property Prefix:string read FPrefix write FPrefix;
    property ShowModified: Boolean read FShowModified write FShowModified;
    property Suffix:string read FSuffix write FSuffix;
    property Precision: Integer read FPrecision write FPrecision;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Bars',[TAEInspectorEditLink, TColComboInspectorEditLink,
    TMemoInspectorEditLink, TAdvMoneyEditInspectorEditLink]);
end;


{ TAEInspectorEditLink }

constructor TAEInspectorEditLink.Create(AOwner: TComponent);
begin
  inherited;
  FAdvEdit := nil;
  FEditColor := clWhite;
  FModifiedColor := clRed;
end;

procedure TAEInspectorEditLink.CreateEditor(AParent: TWinControl);
begin
  inherited;
  if not Assigned(FAdvEdit) then
    FAdvEdit := TAdvEdit.Create(AParent);

  FAdvEdit.Width := 0;
  FAdvEdit.Height := 0;
  FAdvEdit.Parent := AParent;
  FAdvEdit.Visible := False;
  FAdvEdit.OnKeyDown := EditKeyDown;
end;

destructor TAEInspectorEditLink.Destroy;
begin
  if Assigned(FAdvEdit) then
    FAdvEdit.Free;
  FAdvEdit := nil;
  inherited;
end;

procedure TAEInspectorEditLink.DestroyEditor;
begin
  if Assigned(FAdvEdit) then
    FAdvEdit.Free;
  FAdvEdit := nil;
  inherited;
end;

function TAEInspectorEditLink.GetEditor: TWinControl;
begin
  Result := FAdvEdit;
end;

procedure TAEInspectorEditLink.SetOriginalValue;
begin
  inherited;
  FAdvEdit.Text := FOrigValue;
end;

procedure TAEInspectorEditLink.SetProperties(R: TRect; Item: TInspectorItem);
begin
  inherited;

  InflateRect(R,-2,-1);
  R.Right := R.Right - 20;

  FAdvEdit.Left := R.Left;
  FAdvEdit.Top := R.Top;
  FAdvEdit.Width := R.Right - R.Left;
  FAdvEdit.Height := R.Bottom - R.Top;
  FAdvEdit.BorderStyle := bsNone;
  FAdvEdit.Font.Assign(Item.InspectorPanel.Font);

  FAdvEdit.Color := FEditColor;
  FAdvEdit.FocusColor := FEditColor;
  FAdvEdit.EditType := FEditType;
  FAdvEdit.EditAlign := FEditAlign;
  FAdvEdit.ModifiedColor := FModifiedColor;
  FAdvEdit.Prefix := FPrefix;
  FAdvEdit.Suffix := FSuffix;
  FAdvEdit.ShowModified := FShowModified;
  FAdvEdit.Precision := FPrecision;
end;

procedure TAEInspectorEditLink.StartEdit(Item: TInspectorItem);
var
  s:string;
begin
  inherited;

  s := Item.TextValue;

  Delete(s,1,Length(Prefix));
  Delete(s,Length(s) - Length(Suffix),Length(Suffix));

  FOrigValue := s;
  FAdvEdit.Text := s;
  FAdvEdit.Visible := True;
  FAdvEdit.SetFocus;
end;

procedure TAEInspectorEditLink.StopEdit(Item: TInspectorItem);
begin
  inherited;
  Item.TextValue := Prefix + FAdvEdit.Text + Suffix;
  FAdvEdit.Visible := False;
end;

{ TColComboInspectorEditLink }

constructor TColComboInspectorEditLink.Create(AOwner: TComponent);
begin
  inherited;
  FColCombo := nil;
  FDropDownHeight := 100;
  WantKeyUpDown := True;
  WantKeyReturn := True;
end;

procedure TColComboInspectorEditLink.CreateEditor(AParent: TWinControl);
begin
  inherited;
  if not Assigned(FColCombo) then
    FColCombo := TColumnComboBox.Create(AParent);

  FColCombo.Width := 0;
  FColCombo.Height := 0;
  FColCombo.Parent := AParent;
  FColCombo.Visible := False;
  FColCombo.Flat := True;
  FColCombo.FlatLineColor := clNone;
  FColCombo.Color := clWindow;

  FColCombo.OnKeyDown := EditKeyDown;
end;

destructor TColComboInspectorEditLink.Destroy;
begin
  if Assigned(FColCombo) then
    FColCombo.Free;
  FColCombo := nil;
  inherited;
end;

procedure TColComboInspectorEditLink.DestroyEditor;
begin
  if Assigned(FColCombo) then
    FColCombo.Free;
  FColCombo := nil;
  inherited;
end;

function TColComboInspectorEditLink.GetEditor: TWinControl;
begin
   Result := FColCombo;
end;

procedure TColComboInspectorEditLink.SetOriginalValue;
begin
  inherited;
  FColCombo.ItemIndex := FOrigIndex;
end;

procedure TColComboInspectorEditLink.SetProperties(R: TRect;
  Item: TInspectorItem);
begin
  FColCombo.Left := R.Left;
  FColCombo.Top := R.Top;
  FColCombo.Width := R.Right - R.Left;
  FColCombo.Height := R.Bottom - R.Top;
  FColCombo.Font.Assign(Item.InspectorPanel.Font);
  FColCombo.DropHeight := FDropDownHeight;
  FColCombo.DropWidth := FDropDownWidth;
  FColCombo.EditColumn := FEditColumn;
  inherited;
  FOrigIndex := FColCombo.ItemIndex;
end;

procedure TColComboInspectorEditLink.StartEdit(Item: TInspectorItem);
begin
  inherited;
  FColCombo.Visible := True;
  FColCombo.SetFocus;
  FColCombo.DroppedDown := True;
end;

procedure TColComboInspectorEditLink.StopEdit(Item: TInspectorItem);
begin
  inherited;
  Item.IntValue := FColCombo.ItemIndex;
  Item.TextValue := FColCombo.ColumnItems[FColCombo.ItemIndex,0];
  FColCombo.Visible := False;
end;

{ TMemoInspectorEditLink }

constructor TMemoInspectorEditLink.Create(AOwner: TComponent);
begin
  inherited;
  FEdit := nil;
  WantKeyUpDown := True;
  WantKeyHomeEnd := True;
  WantKeyReturn := True;
  EditStyle := esPopup;
  PopupHeight := 150;
  PopupWidth := 150;
end;

procedure TMemoInspectorEditLink.CreateEditor(AParent: TWinControl);
begin
  inherited;
  FEdit := TMemo.Create(AParent);
  FEdit.OnKeydown := EditKeyDown;
  FEdit.BorderStyle := bsSingle;
  FEdit.Scrollbars := ssBoth;
  FEdit.Width := 0;
  FEdit.Height := 0;
  FEdit.Parent := AParent;
end;

destructor TMemoInspectorEditLink.Destroy;
begin
  if Assigned(FEdit) then
    FEdit.Free;
  FEdit := nil;
  inherited;
end;

procedure TMemoInspectorEditLink.DestroyEditor;
begin
  if Assigned(FEdit) then
    FEdit.Free;
  FEdit := nil;
  inherited;
end;

function TMemoInspectorEditLink.GetEditor: TWinControl;
begin
   Result := FEdit;
end;

procedure TMemoInspectorEditLink.SetOriginalValue;
begin
  inherited;
  FEdit.Lines.Text := FOrigValue;
  Inspector.HidePopup;
end;

procedure TMemoInspectorEditLink.SetProperties(R: TRect;
  Item: TInspectorItem);
begin
  FEdit.Align := alClient;
  FEdit.Font.Assign(Item.InspectorPanel.Font);
  FEdit.Color := Color;
  inherited;
end;

procedure TMemoInspectorEditLink.StartEdit(Item: TInspectorItem);
begin
  inherited;
  FEdit.Lines.Text := Item.TextValue;
  FEdit.Visible := True;
  FEdit.SetFocus;
  if FSelectAll then FEdit.SelectAll;
  FOrigValue := Item.TextValue;
end;

procedure TMemoInspectorEditLink.StopEdit(Item: TInspectorItem);
var
  i: Integer;
begin
  inherited;
  if Assigned(FEdit) then
  begin
    Item.TextValue := '';
    for i := 1 to FEdit.Lines.Count do
      Item.TextValue := Item.TextValue + FEdit.Lines[i-1] + #13;
  end;
end;

{ TAdvMoneyEditnspectorEditLink }

constructor TAdvMoneyEditInspectorEditLink.Create(AOwner: TComponent);
begin
  inherited;
  FAdvEdit := nil;
  FEditColor := clWhite;
  FModifiedColor := clRed;
end;

procedure TAdvMoneyEditInspectorEditLink.CreateEditor(AParent: TWinControl);
begin
  inherited;
  if not Assigned(FAdvEdit) then
    FAdvEdit := TAdvMoneyEdit.Create(AParent);

  FAdvEdit.Width := 0;
  FAdvEdit.Height := 0;
  FAdvEdit.Parent := AParent;
  FAdvEdit.Visible := False;
  FAdvEdit.OnKeyDown := EditKeyDown;
end;

destructor TAdvMoneyEditInspectorEditLink.Destroy;
begin
  if Assigned(FAdvEdit) then
    FAdvEdit.Free;
  FAdvEdit := nil;
  inherited;
end;

procedure TAdvMoneyEditInspectorEditLink.DestroyEditor;
begin
  if Assigned(FAdvEdit) then
    FAdvEdit.Free;
  FAdvEdit := nil;
  inherited;
end;

function TAdvMoneyEditInspectorEditLink.GetEditor: TWinControl;
begin
  Result := FAdvEdit;
end;

procedure TAdvMoneyEditInspectorEditLink.SetOriginalValue;
begin
  inherited;
  FAdvEdit.Text := FOrigValue;
end;

procedure TAdvMoneyEditInspectorEditLink.SetProperties(R: TRect; Item: TInspectorItem);
begin
  inherited;

  InflateRect(R,-2,-1);

  FAdvEdit.Left := R.Left;
  FAdvEdit.Top := R.Top;
  FAdvEdit.Width := R.Right - R.Left;
  FAdvEdit.Height := R.Bottom - R.Top;
  FAdvEdit.BorderStyle := bsNone;
  FAdvEdit.Font.Assign(Item.InspectorPanel.Font);

  FAdvEdit.Color := FEditColor;
  FAdvEdit.FocusColor := FEditColor;
  FAdvEdit.EditType := FEditType;
  FAdvEdit.EditAlign := FEditAlign;
  FAdvEdit.ModifiedColor := FModifiedColor;
  FAdvEdit.Prefix := FPrefix;
  FAdvEdit.Suffix := FSuffix;
  FAdvEdit.ShowModified := FShowModified;
  FAdvEdit.Precision := FPrecision;
  FAdvEdit.ButtonCaption := '...';
  FAdvEdit.ButtonHint := 'Show calculator';
end;

procedure TAdvMoneyEditInspectorEditLink.StartEdit(Item: TInspectorItem);
var
  s:string;
begin
  inherited;

  s := Item.TextValue;

  Delete(s,1,Length(Prefix));
  Delete(s,Length(s) - Length(Suffix),Length(Suffix));

  FOrigValue := s;
  FAdvEdit.Text := s;

  FAdvEdit.Visible := True;
  FAdvEdit.SetFocus;
end;

procedure TAdvMoneyEditInspectorEditLink.StopEdit(Item: TInspectorItem);
begin
  inherited;
  Item.TextValue := Prefix + FAdvEdit.Text + Suffix;
  FAdvEdit.Visible := False;
end;


end.
