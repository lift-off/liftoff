{********************************************************************}
{ TAdvTreeComboBox component                                         }
{ for Delphi & C++Builder                                            }
{ version 1.0                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2003                                        }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{                -                                                   }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The component can be freely used in any application. The source    }
{ code remains property of the author and may not be distributed     }
{ freely as such.                                                    }
{********************************************************************}

{$I TMSDEFS.INC}
unit AdvTreeComboBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, buttons, imglist, menus, extctrls;

type
  TSelectMode = (smSingleClick, smDblClick);

  TDropPosition = (dpAuto, dpDown, dpUp);
  //acceptdrop=true allow tree dropping

  TDropDown = procedure(Sender: TObject; var acceptdrop: boolean) of object;
  //canceled=true ignores SelecteItem and stores Old Edit caption
  //canceled=false on selection and true when Cancel (key=Esc, click outside of tree...)

  TDropUp = procedure(Sender: TObject; canceled: boolean) of object;

  TDropTreeForm = class(TForm)
  private
    procedure WMClose(var Msg: TMessage); message WM_CLOSE;
  end;

  TDropTreeButton = class(TSpeedButton)
  private
    FFocusControl: TWinControl;
    FMouseClick: TNotifyEvent;
    procedure WMLButtonDown(var Msg: TMessage); message WM_LBUTTONDOWN;
  protected
    procedure Paint; override;
  public
    procedure Click; override;
    constructor Create(AOwner: TComponent); override;
  published
    property FocusControl: TWinControl read FFocusControl write FFocusControl;
    property MouseClick: TNotifyEvent read FMouseClick write FMouseClick;
  end;

  TAdvTreeComboBox = class(TCustomEdit)
  private
   { Private declarations }
    FtreeView: TTreeview;
    FdropTreeForm: TDropTreeForm;
    FButton: TDropTreeButton;
    FDropWidth: integer;
    FDropHeight: integer;
    FEditorEnabled: boolean;
    FExpandOnDrop: boolean;
    FCollapseOnDrop: boolean;
    FDropPosition: TDropPosition;
    FOldCaption: string;
    FOndropDown: TdropDown;
    FOndropUP: TdropUP;
    FAutoOpen: boolean;
    FSelectMode: TselectMode;
    FFlat: Boolean;
    function GetMinHeight: Integer;
    procedure SetEditRect;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    function GetTreeNodes: TTreeNodes;
    procedure SetTreeNodes(const Value: TTreeNodes);
    procedure SetEditorEnabled(const Value: boolean);
    procedure SetCollapseOnDrop(const Value: boolean);
    procedure SetExpandOnDrop(const Value: boolean);
    procedure SetShowButtons(const Value: Boolean);
    function GetShowButtons: Boolean;
    function GetShowLines: Boolean;
    procedure SetShowLines(const Value: Boolean);
    function GetShowRoot: Boolean;
    procedure SetShowRoot(const Value: Boolean);
    function GetSortType: TSortType;
    procedure SetSortType(const Value: TSortType);
    function GetRightClickSelect: Boolean;
    procedure SetRightClickSelect(const Value: Boolean);
    function GetRowSelect: Boolean;
    procedure SetRowSelect(const Value: Boolean);
    function GetIndent: Integer;
    procedure SetIndent(const Value: Integer);
    function GetImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
    function GetReadOnlyTree: boolean;
    procedure SetReadOnlyTree(const Value: boolean);
    procedure SetStateImages(const Value: TCustomImageList);
    function GetStateImages: TCustomImageList;
    function GetTreeFont: Tfont;
    procedure SetTreeFont(const Value: Tfont);
    function GetTreeColor: TColor;
    procedure SetTreeColor(const Value: TColor);
    function GetTreeBorder: TBorderStyle;
    procedure SetTreeBorder(const Value: TBorderStyle);
    function GetTreepopupmenu: Tpopupmenu;
    procedure SetTreepopupmenu(const Value: Tpopupmenu);
    function getSelection: integer;
    procedure SetSelection(const Value: integer);
    procedure SetFlat(const Value: Boolean);
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    procedure DestroyWnd; override;

    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MouseClick(Sender: TObject);
    procedure DownClick(Sender: TObject);
    procedure ShowTree;
    procedure FindtextinNode;
    procedure HideTree(canceled: boolean);
    procedure TreeViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewKeyPress(Sender: TObject; var Key: Char);
    procedure TreeViewDblClick(Sender: TObject);
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TreeViewBlockChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure TreeViewExit(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Button: TDropTreeButton read FButton;
    { Public declarations }
  published
    { Published declarations }
    property SelectMode: TSelectMode read FSelectMode write FSelectMode default smDblClick;
    property DropWidth: integer read FDropWidth write fDropWidth;
    property DropHeight: integer read FDropHeight write fDropHeight;
    property Items: TTreeNodes read GetTreeNodes write SetTreeNodes;
    property EditorEnabled: boolean read FEditorEnabled write SetEditorEnabled default true;
    property CollapseOnDrop: boolean read FCollapseOnDrop write SetCollapseOnDrop default false;
    property ExpandOnDrop: boolean read FExpandOnDrop write SetExpandOnDrop default false;
    property DropPosition: TDropPosition read FDropPosition write FDropPosition default dpAuto;
    property AutoOpen: boolean read FAutoOpen write FAutoOpen default True;
    property Flat: Boolean read FFlat write SetFlat default False;
     //----- Tree properties
    property ReadOnlyTree: boolean read GetReadOnlyTree write SetReadOnlyTree default true;
    property ShowButtons: Boolean read GetShowButtons write SetShowButtons default True;
    property ShowLines: Boolean read GetShowLines write SetShowLines default True;
    property ShowRoot: Boolean read GetShowRoot write SetShowRoot default True;
    property SortType: TSortType read GetSortType write SetSortType default stNone;
    property RightClickSelect: Boolean read GetRightClickSelect write SetRightClickSelect default False;
    property RowSelect: Boolean read GetRowSelect write SetRowSelect default False;
    property Indent: Integer read GetIndent write SetIndent;
    property Images: TCustomImageList read GetImages write SetImages;
    property StateImages: TCustomImageList read GetStateImages write SetStateImages;
    property TreeFont: Tfont read GetTreeFont write SetTreeFont;
    property TreeColor: TColor read GetTreeColor write SetTreeColor;
    property TreeBorder: TBorderStyle read GetTreeBorder write SetTreeBorder;
    property TreePopupMenu: Tpopupmenu read GetTreepopupmenu write SetTreepopupmenu;
    property Selection: integer read getSelection write SetSelection;

     //--------
    property OndropDown: TdropDown read FOndropDown write FOndropDown;
    property OndropUp: TdropUP read FOndropUP write FOndropUp;

     //------- Edit Properties
{$IFDEF DELPHI4_LVL}
    property Anchors;
    property Constraints;
    property DragKind;
{$ENDIF}
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Height;
    property Width;
    property Text;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
{$IFDEF DELPHI4_LVL}
    property OnEndDock;
    property OnStartDock;
{$ENDIF}
  end;



implementation
{$R AdvTreeComboBox.res}

{ TAdvTreeComboBox }

constructor TAdvTreeComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  SetBounds(left, top, 200, 25);
{$IFDEF DELPHI4_LVL}
  FDropTreeForm := TDropTreeForm.CreateNew(self, 0);
{$ELSE}
  FDropTreeForm := TDropTreeForm.CreateNew(self);
{$ENDIF}
  with FDropTreeForm do
  begin
    BorderStyle := bsNone;
    FormStyle := fsStayOnTop;
    Visible := False;
    Width := FDropWidth;
    Height := FDropHeight;
    OnDeactivate := FormDeactivate;
    OnExit := FormDeactivate;
    OnHide := FormDeactivate;
    OnClose := FormClose;
  end;
  FtreeView := TTreeView.Create(FdropTreeForm);
  with FtreeView do
  begin
    parent := FdropTreeForm;
    Align := alClient;
    ReadOnly := true;
    ShowButtons := True;
    ShowLines := True;
    ShowRoot := True;
    SortType := stNone;
    RightClickSelect := False;
    RowSelect := False;
    visible := true;
    OnKeyDown := TreeViewKeyDown;
    OnChange := TreeViewChange;
    OnMouseDown := TreeViewMouseDown;
    OnDblClick := TreeViewDblClick;
    OnKeyPress := TreeViewKeyPress;
  end;
  FButton := TDropTreeButton.Create(Self);
  FButton.Width := 15;
  FButton.Height := 17;
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.FocusControl := Self;
  FButton.MouseClick := MouseClick;
  FButton.OnClick := DownClick;
  ControlStyle := ControlStyle - [csSetCaption];
  FDropHeight := 100;
  FDropWidth := self.width;
  FEditorEnabled := true;
  ReadOnly := false;
  FCollapseOnDrop := false;
  FExpandOnDrop := false;
  FDropPosition := dpAuto;
  FOldCaption := '';
  FAutoOpen := true;
  FselectMode := smDblClick;
end;

destructor TAdvTreeComboBox.Destroy;
begin
  FButton.free;
  FtreeView.free;
  FdropTreeForm.free;
  inherited Destroy;
end;

procedure TAdvTreeComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;

end;


procedure TAdvTreeComboBox.FormDeactivate(Sender: TObject);
begin
  HideTree(true);
end;

procedure TAdvTreeComboBox.DownClick(Sender: TObject);
begin
  ShowTree;
end;

procedure TAdvTreeComboBox.MouseClick(Sender: TObject);
begin

end;

procedure TAdvTreeComboBox.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
  Dist: integer;
begin
  inherited;
  if BorderStyle = bsNone then Dist := 2 else Dist := 5;
  MinHeight := GetMinHeight;
    { text edit bug: if size to less than minheight, then edit ctrl does
      not display the text }

  if Height < MinHeight then
    Height := MinHeight
  else if FButton <> nil then
  begin
    if NewStyleControls and Ctl3D then
      FButton.SetBounds(Width - FButton.Width - Dist, 0, FButton.Width, Height - Dist)
    else FButton.SetBounds(Width - FButton.Width, 1, FButton.Width, Height - 3);
    SetEditRect;
  end;
end;

function TAdvTreeComboBox.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  I := SysMetrics.tmHeight;
  if I > Metrics.tmHeight then I := Metrics.tmHeight;
  Result := Metrics.tmHeight + I div 4 {+ GetSystemMetrics(SM_CYBORDER) * 4};
end;


procedure TAdvTreeComboBox.SetEditRect;
var
  Loc: TRect;
begin
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight + 1; {+1 is workaround for windows paint bug}
  Loc.Right := ClientWidth - FButton.Width - 3;
  if self.BorderStyle = bsNone then
  begin
    Loc.Top := 2;
    Loc.Left := 2;
  end
  else
  begin
    Loc.Top := 1;
    Loc.Left := 1;
  end;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc)); {debug}
end;

function TAdvTreeComboBox.GetTreeNodes: TTreeNodes;
begin
  result := FtreeView.items;
end;

procedure TAdvTreeComboBox.SetTreeNodes(const Value: TTreeNodes);
begin
  FtreeView.items.Assign(Value);
  FtreeView.Update;
end;

procedure TAdvTreeComboBox.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;

end;

procedure TAdvTreeComboBox.DestroyWnd;
begin
  inherited;

end;

procedure TAdvTreeComboBox.SetEditorEnabled(const Value: boolean);
begin
  FEditorEnabled := Value;
  ReadOnly := not (Value);
end;

procedure TAdvTreeComboBox.SetCollapseOnDrop(const Value: boolean);
begin
  FCollapseOnDrop := Value;
  if value then FExpandOnDrop := false;
end;

procedure TAdvTreeComboBox.SetExpandOnDrop(const Value: boolean);
begin
  FExpandOnDrop := Value;
  if value then FCollapseOnDrop := false;
end;

procedure TAdvTreeComboBox.TreeViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  VK_ESCAPE, VK_F4:
    begin
      HideTree(true);
      key := 0;
    end;
  VK_RETURN:
    begin
      HideTree(false);
    end;
  end;
end;

procedure TAdvTreeComboBox.ShowTree;
var
  p: TPoint;
  acpt: boolean;
begin
  if FDropTreeForm.Visible then
    Exit;

  FOldCaption := Caption;
  FDropTreeForm.Left := self.Left;
  FDropTreeForm.Top := self.Top;
  FDropTreeForm.Width := FDropWidth;
  FDropTreeForm.Height := FDropHeight;
  P := Point(0, 0);
  P := ClientToScreen(P);
  case FDropPosition of
    dpAuto: begin
        if P.y + fDropHeight >= GetSystemMetrics(SM_CYSCREEN) then
        begin //Up
          FdropTreeForm.Left := P.x;
          FdropTreeForm.Top := p.y - FDropHeight;
        end
        else
        begin //Down
          FdropTreeForm.Left := P.x;
          FdropTreeForm.Top := p.y + Height;
        end;
      end;
    dpDown: begin
        FdropTreeForm.Left := P.x;
        FdropTreeForm.Top := p.y + Height;
      end;
    dpUp: begin
        FdropTreeForm.Left := P.x;
        FdropTreeForm.Top := p.y - FDropHeight;
      end;
  end;
  
  if FCollapseOnDrop then FTreeView.FullCollapse;
  if FExpandOnDrop then FTreeView.FullExpand;
  acpt := true;

  FtreeView.Items.GetFirstNode; //Force return of correct items count

  FindtextinNode;
  if Assigned(FOnDropDown) then
    FOnDropdown(Self, acpt);
  if acpt then
  begin
    if FtreeView.Selected <> nil then
      Text := FtreeView.Selected.Text;
    FDropTreeForm.Show;
    FTreeView.SetFocus;
  end;
  FTreeView.OnChanging := nil; // Please leave this here, otherwise procedure FindtextinNode must be modified
end;

procedure TAdvTreeComboBox.WMKeyDown(var Message: TWMKeyDown);
begin
  if Message.CharCode = VK_RETURN then
  begin
    Message.Result := 1;
    exit;
  end;
  inherited;
  case Message.CharCode of
  VK_DOWN: ShowTree;
  VK_F4:
    begin
      if FDropTreeForm.Visible then
        HideTree(False)
      else
        ShowTree;
    end;
  else
    begin
      // if FdropTreeForm.Visible then exit;

    end;
  end; //end CASE
end;

procedure TAdvTreeComboBox.TreeViewChange(Sender: TObject;
  Node: TTreeNode);
begin
  if FDropTreeForm.Visible then
    Text := node.Text;
end;

procedure TAdvTreeComboBox.TreeViewDblClick(Sender: TObject);
begin
  if Fselectmode = smDblClick then HideTree(false);
end;

procedure TAdvTreeComboBox.SetShowButtons(const Value: Boolean);
begin
  FtreeView.ShowButtons := value;
end;

function TAdvTreeComboBox.GetShowButtons: Boolean;
begin
  result := FtreeView.ShowButtons;
end;

function TAdvTreeComboBox.GetShowLines: Boolean;
begin
  result := FtreeView.ShowLines;
end;

procedure TAdvTreeComboBox.SetShowLines(const Value: Boolean);
begin
  FtreeView.ShowLines := value;
end;

function TAdvTreeComboBox.GetShowRoot: Boolean;
begin
  result := FtreeView.ShowRoot;
end;

procedure TAdvTreeComboBox.SetShowRoot(const Value: Boolean);
begin
  FtreeView.ShowRoot := value;
end;

function TAdvTreeComboBox.GetSortType: TSortType;
begin
  Result := FtreeView.SortType;
end;

procedure TAdvTreeComboBox.SetSortType(const Value: TSortType);
begin
  FtreeView.SortType := value;
end;

function TAdvTreeComboBox.GetRightClickSelect: Boolean;
begin
  Result := FtreeView.RightClickSelect;
end;

procedure TAdvTreeComboBox.SetRightClickSelect(const Value: Boolean);
begin
  FtreeView.RightClickSelect := value;
end;

function TAdvTreeComboBox.GetRowSelect: Boolean;
begin
  Result := FtreeView.RowSelect;
end;

procedure TAdvTreeComboBox.SetRowSelect(const Value: Boolean);
begin
  FtreeView.RowSelect := value;
end;

function TAdvTreeComboBox.GetIndent: Integer;
begin
  Result := FtreeView.Indent;
end;

procedure TAdvTreeComboBox.SetIndent(const Value: Integer);
begin
  FtreeView.Indent := value;
end;

function TAdvTreeComboBox.GetImages: TCustomImageList;
begin
  result := FtreeView.Images;
end;

procedure TAdvTreeComboBox.SetImages(const Value: TCustomImageList);
begin
  FtreeView.Images := value;
end;

function TAdvTreeComboBox.GetReadOnlyTree: boolean;
begin
  Result := FtreeView.ReadOnly;
end;

procedure TAdvTreeComboBox.SetReadOnlyTree(const Value: boolean);
begin
  FtreeView.ReadOnly := value;
end;

procedure TAdvTreeComboBox.SetStateImages(const Value: TCustomImageList);
begin
  FtreeView.StateImages := value;
end;

function TAdvTreeComboBox.GetStateImages: TCustomImageList;
begin
  result := FtreeView.StateImages;
end;

function TAdvTreeComboBox.GetTreeFont: Tfont;
begin
  result := FtreeView.Font;
end;

procedure TAdvTreeComboBox.SetTreeFont(const Value: Tfont);
begin
  FtreeView.Font.Assign(value);
end;

function TAdvTreeComboBox.GetTreeColor: TColor;
begin
  result := FtreeView.Color;
end;

procedure TAdvTreeComboBox.SetTreeColor(const Value: TColor);
begin
  FtreeView.Color := value;
end;

procedure TAdvTreeComboBox.TreeViewKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key <= #27 then key := #0; // stop beeping
end;

procedure TAdvTreeComboBox.HideTree(canceled: boolean);
begin
  if not FdropTreeForm.Visible then exit;
  FdropTreeForm.Hide;
  if canceled then
  begin
    text := FOldCaption;
  end else
  begin
    if FtreeView.Selected <> nil then
      Text := FtreeView.Selected.Text;
  end;
  if Assigned(FondropUp) then
    FOndropUP(self, canceled);
end;

function TAdvTreeComboBox.GetTreeBorder: TBorderStyle;
begin
  result := FtreeView.BorderStyle;
end;

procedure TAdvTreeComboBox.SetTreeBorder(const Value: TBorderStyle);
begin
  FtreeView.BorderStyle := value;
end;

function TAdvTreeComboBox.GetTreepopupmenu: Tpopupmenu;
begin
  result := FtreeView.PopupMenu;
end;

procedure TAdvTreeComboBox.SetTreepopupmenu(const Value: Tpopupmenu);
begin
  FtreeView.PopupMenu := value;
end;

procedure TAdvTreeComboBox.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := 1; // Message.Result and DLGC_WANTALLKEYS;
end;

procedure TAdvTreeComboBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(key);
  if (Key = Char(VK_RETURN)) then Key := #0;
end;

procedure TAdvTreeComboBox.FindtextinNode;
var
  i: integer;
  itm, its: TTreenode;
  sfind, stext: string;
  function noopen(Node: TTreenode): boolean;
  begin
    result := true;
    if node = nil then exit;
    while Node.Parent <> nil do
    begin
      node := Node.Parent;
      if not node.Expanded then exit;
    end;
    result := false;
  end;

begin
  sfind := UpperCase(text);
  itm := nil;
  repeat
    for i := 0 to FTreeView.Items.count - 1 do
    begin
   // Don't search if AutoOpen disabled and the nodes are not open.
      if not AutoOpen then
        if noopen(FTreeView.items[i]) then continue;
      stext := UpperCase(FTreeView.Items[i].text);
      if ansipos(sfind, stext) = 1 then
      begin
        itm := FTreeView.items[i];
        Break;
      end;
    end;
    if length(sfind) > 0 then delete(sfind, length(sfind), 1);
  until (itm <> nil) or (sfind = '');
  if itm = nil then
  begin
    FTreeView.OnChanging := TreeViewBlockChanging;
    exit;
  end;
  its := itm;
  if AutoOpen then
  begin
    while itm.Parent <> nil do
    begin
      itm := itm.Parent;
      itm.Expand(false);
    end;
  end;
  FTreeView.Selected := its;
end;

procedure TAdvTreeComboBox.TreeViewBlockChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  AllowChange := false;
end;

procedure TAdvTreeComboBox.TreeViewExit(Sender: TObject);
begin
  HideTree(False);
end;

procedure TAdvTreeComboBox.TreeViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AnItem: TTreeNode;
  HT: THitTests;
begin
  if Fselectmode = smDblClick then exit;
  if FTreeView.Selected = nil then Exit;
  HT := FTreeView.GetHitTestInfoAt(X, Y);
  AnItem := FTreeView.GetNodeAt(X, Y);
  // We can add htOnLabel,htOnStateIcon,htOnItem,htOnLabel
  if (htOnitem in ht) and (AnItem <> nil) then
  begin
    HideTree(false);
  end;
end;

procedure TAdvTreeComboBox.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormDeactivate(self);
end;

function TAdvTreeComboBox.getSelection: integer;
begin
  try
    result := FtreeView.Selected.AbsoluteIndex;
  except
    on exception do result := -1;
  end;
end;

procedure TAdvTreeComboBox.SetSelection(const Value: integer);
begin
  if Value = -1 then
    Exit;

  try
    FtreeView.Selected := FtreeView.items[Value];
  except
    on exception do
      FtreeView.Selected := nil;
  end;
end;

procedure TAdvTreeComboBox.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
  FButton.Flat := True;
end;

{ TDropTreeForm }

procedure TDropTreeForm.WMClose(var Msg: TMessage);
begin
  inherited;

end;

{ TDropTreeButton }

procedure TDropTreeButton.Click;
begin
  if (FFocusControl <> nil) and FFocusControl.CanFocus and (GetFocus <> FFocusControl.Handle) then
    FFocusControl.SetFocus;
  inherited Click;
end;

constructor TDropTreeButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Cursor := crArrow;
  Glyph.Handle := LoadBitmap(HInstance, 'DROPTREE_ARROW_DOWN');
end;

procedure TDropTreeButton.Paint;
begin
  inherited Paint;
end;

procedure TDropTreeButton.WMLButtonDown(var Msg: TMessage);
begin
  if Assigned(FMouseClick) then
    FMouseClick(self);
  inherited;
end;


end.
