{*************************************************************************}
{ TDBADVNAVIGATOR component                                               }
{ for Delphi & C++Builder                                                 }
{ version 1.2                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright © 2002 - 2003                                       }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit DBAdvNavigator;

interface

{$R DBADVNAV.RES}
{$I TMSDEFS.INC}

uses
  DBCtrls, Classes, Windows, Messages, StdCtrls, AdvToolBtn, DB, Controls,
  ExtCtrls, Dialogs, Buttons, Graphics;

type
  TAdvNavButton = class;

  TAdvNavDataLink = class;

  TNavigatorOrientation = (noHorizontal, noVertical);

  TAdvNavigateBtn = (nbFirst, nbPrior, nbNext, nbLast,
    nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh, nbSearch, nbSetBookmark, nbGotoBookMark);

  TButtonSet = set of TAdvNavigateBtn;

  ENavClick = procedure (Sender: TObject; Button: TAdvNavigateBtn) of object;    

  TGlyphSize = (gsSmall, gsLarge);

  TDBAdvNavigator = class (TCustomPanel)
  private
    FDataLink: TAdvNavDataLink;
    FVisibleButtons: TButtonSet;
    FHints: TStrings;
    FDefHints: TStrings;
    ButtonWidth: Integer;
    ButtonHeight: Integer;
    MinBtnSize: TPoint;
    FOnNavClick: ENavClick;
    FBeforeAction: ENavClick;
    FocusedButton: TAdvNavigateBtn;
    FConfirmDelete: Boolean;
    FFlat: Boolean;
    FColorDown: TColor;
    FColorHot: TColor;
    FColor: TColor;
    FShaded: Boolean;
    FOnBtnPrior : TNotiFyEvent;
    FOnBtnNext : TNotiFyEvent;
    FOnBtnFirst : TNotiFyEvent;
    FOnBtnLast : TNotiFyEvent;
    FOnBtnInsert : TNotiFyEvent;
    FOnBtnEdit : TNotiFyEvent;
    FOnBtnCancel : TNotiFyEvent;
    FOnBtnPost : TNotiFyEvent;
    FOnBtnRefresh : TNotiFyEvent;
    FOnBtnDelete : TNotiFyEvent;
    FOrientation: TNavigatorOrientation;
    FGlyphSize: TGlyphSize;
    FOnBtnSearch: TNotifyEvent;
    FOnBtnGotoBookmark: TNotifyEvent;
    FOnBtnSetBookmark: TNotifyEvent;
    FBookmark: string;
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClickHandler(Sender: TObject);
    function GetDataSource: TDataSource;
    function GetHints: TStrings;
    procedure HintsChanged(Sender: TObject);
    procedure InitButtons;
    procedure InitHints;
    procedure SetDataSource(Value: TDataSource);
    procedure SetFlat(Value: Boolean);
    procedure SetHints(Value: TStrings);
    procedure SetSize(var W: Integer; var H: Integer);
    procedure SetVisible(Value: TButtonSet);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure SetColor(const Value: TColor);
    procedure SetColorDown(const Value: TColor);
    procedure SetColorHot(const Value: TColor);
    procedure SetShaded(const Value: Boolean);
    procedure SetOrientation(const Value: TNavigatorOrientation);
    procedure SetGlyphSize(const Value: TGlyphSize);
  protected
    Buttons: array[TAdvNavigateBtn] of TAdvNavButton;
    procedure DataChanged;
    procedure EditingChanged;
    procedure ActiveChanged;
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure CalcMinSize(var W, H: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BtnClick(Index: TAdvNavigateBtn); virtual;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property VisibleButtons: TButtonSet read FVisibleButtons write SetVisible
      default [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete,
        nbEdit, nbPost, nbCancel, nbRefresh];
    property Align;
    property Anchors;
    property Color: TColor read FColor write SetColor;
    property ColorDown: TColor read FColorDown write SetColorDown;
    property ColorHot: TColor read FColorHot write SetColorHot;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Flat: Boolean read FFlat write SetFlat default False;
    property GlyphSize: TGlyphSize read FGlyphSize write SetGlyphSize; 
    property Ctl3D;
    property Hints: TStrings read GetHints write SetHints;
    property Orientation: TNavigatorOrientation read FOrientation write SetOrientation;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property Shaded: Boolean read FShaded write SetShaded default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property BeforeAction: ENavClick read FBeforeAction write FBeforeAction;
    property OnClick: ENavClick read FOnNavClick write FOnNavClick;
    property OnBtnPrior : TNotifyEvent read FOnBtnPrior write FOnBtnPrior;
    property OnBtnNext : TNotifyEvent read FOnBtnNext write FOnBtnNext;
    property OnBtnFirst : TNotifyEvent read FOnBtnFirst write FOnBtnFirst;
    property OnBtnLast : TNotifyEvent read FOnBtnLast write FOnBtnLast;
    property OnBtnInsert : TNotifyEvent read FOnBtnInsert write FOnBtnInsert;
    property OnBtnEdit : TNotifyEvent read FOnBtnEdit write FOnBtnEdit;
    property OnBtnCancel : TNotifyEvent read FOnBtnCancel write FOnBtnCancel;
    property OnBtnPost : TNotifyEvent read FOnBtnPost write FOnBtnPost;
    property OnBtnRefresh : TNotifyEvent read FOnBtnRefresh write FOnBtnRefresh;
    property OnBtnDelete : TNotifyEvent read FOnBtnDelete write FOnBtnDelete;
    property OnBtnSearch: TNotifyEvent read FOnBtnSearch write FOnBtnSearch;
    property OnBtnSetBookmark: TNotifyEvent read FOnBtnSetBookmark write FOnBtnSetBookmark;
    property OnBtnGotoBookmark: TNotifyEvent read FOnBtnGotoBookmark write FOnBtnGotoBookmark;
    {$IFDEF DELPHI5_LVL}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

{ TAdvNavButton }

  TAdvNavButton = class(TAdvToolButton)
  private
    FIndex: TAdvNavigateBtn;
    FNavStyle: TNavButtonStyle;
    FRepeatTimer: TTimer;
    procedure TimerExpired(Sender: TObject);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    destructor Destroy; override;
    property NavStyle: TNavButtonStyle read FNavStyle write FNavStyle;
    property Index : TAdvNavigateBtn read FIndex write FIndex;
  end;

{ TNavDataLink }

  TAdvNavDataLink = class(TDataLink)
  private
    FNavigator: TDBAdvNavigator;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
  public
    constructor Create(ANav: TDBAdvNavigator);
    destructor Destroy; override;
  end;

implementation

uses
  Math, SysUtils,
  {$IFDEF DELPHI6_LVL}
  VDBConsts
  {$ELSE}
  DBConsts
  {$ENDIF}
  ;

{ TDBAdvNavigator }

var
  BtnTypeAdvName: array[TAdvNavigateBtn] of PChar = ('TMSNAVFIRST', 'TMSNAVPREVIOUS', 'TMSNAVNEXT',
    'TMSNAVLAST', 'TMSNAVINSERT', 'TMSNAVDELETE', 'TMSNAVEDIT', 'TMSNAVPOST', 'TMSNAVCANCEL', 'TMSNAVREFRESH',
    'TMSNAVSEARCH','TMSNAVBOOK','TMSNAVGOTO');

constructor TDBAdvNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  FDataLink := TAdvNavDataLink.Create(Self);
  FVisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbInsert,
    nbDelete, nbEdit, nbPost, nbCancel, nbRefresh];
  FHints := TStringList.Create;
  TStringList(FHints).OnChange := HintsChanged;

  InitButtons;
  InitHints;

  BevelOuter := bvNone;
  BevelInner := bvNone;
  Width := 241;
  Height := 25;
  ButtonWidth := 0;
  ButtonHeight := 0;
  FocusedButton := nbFirst;
  FConfirmDelete := True;
  FullRepaint := False;
  FShaded := True;
 
  Color := clBtnFace;
  ColorHot := RGB(199,199,202);
  ColorDown := RGB(210,211,216);

  FBookmark := '';
end;

destructor TDBAdvNavigator.Destroy;
begin
  FDefHints.Free;
  FDataLink.Free;
  FHints.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TDBAdvNavigator.InitButtons;
var
  I: TAdvNavigateBtn;
  Btn: TAdvNavButton;
  X: Integer;
  ResName: string;
begin
  if GlyphSize = gsSmall then
    MinBtnSize := Point(20, 18)
  else
    MinBtnSize := Point(32, 30);

  X := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Btn := TAdvNavButton.Create (Self);
    Btn.Flat := Flat;
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);

    if GlyphSize = gsSmall then
      FmtStr(ResName, '%sE', [BtnTypeAdvName[I]])
    else
      FmtStr(ResName, '%sLE', [BtnTypeAdvName[I]]);

    Btn.Glyph.LoadFromResourceName(Hinstance,ResName);

    if GlyphSize = gsSmall then
      FmtStr(ResName, '%sH', [BtnTypeAdvName[I]])
    else
      FmtStr(ResName, '%sLH', [BtnTypeAdvName[I]]);

    Btn.GlyphHot.LoadFromResourceName(Hinstance,ResName);

    Btn.Shaded := FShaded;

    if GlyphSize = gsSmall then
      FmtStr(ResName, '%sD', [BtnTypeAdvName[I]])
    else
      FmtStr(ResName, '%sLD', [BtnTypeAdvName[I]]);

    Btn.GlyphDisabled.LoadFromResourceName(Hinstance,ResName);

    Btn.Enabled := False;
    Btn.Enabled := True;
    Btn.OnClick := ClickHandler;
    Btn.OnMouseDown := BtnMouseDown;
    Btn.Parent := Self;
    Buttons[I] := Btn;
    X := X + MinBtnSize.X;
  end;
  Buttons[nbPrior].NavStyle := Buttons[nbPrior].NavStyle + [nsAllowTimer];
  Buttons[nbNext].NavStyle  := Buttons[nbNext].NavStyle + [nsAllowTimer];
end;

procedure TDBAdvNavigator.InitHints;
var
  I: Integer;
  J: TAdvNavigateBtn;
begin
  if not Assigned(FDefHints) then
  begin
    FDefHints := TStringList.Create;

    FDefHints.Add(SFirstRecord);
    FDefHints.Add(SPriorRecord);
    FDefHints.Add(SNextRecord);
    FDefHints.Add(SLastRecord);
    FDefHints.Add(SInsertRecord);
    FDefHints.Add(SDeleteRecord);
    FDefHints.Add(SEditRecord);
    FDefHints.Add(SPostEdit);
    FDefHints.Add(SCancelEdit);
    FDefHints.Add(SRefreshRecord);

    FDefHints.Add('Find record');
    FDefHints.Add('Set bookmark');
    FDefHints.Add('Goto bookmark');

  end;
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].Hint := FDefHints[Ord(J)];
  J := Low(Buttons);
  for I := 0 to (FHints.Count - 1) do
  begin
    if FHints.Strings[I] <> '' then Buttons[J].Hint := FHints.Strings[I];
    if J = High(Buttons) then Exit;
    Inc(J);
  end;
end;

procedure TDBAdvNavigator.HintsChanged(Sender: TObject);
begin
  InitHints;
end;

procedure TDBAdvNavigator.SetFlat(Value: Boolean);
var
  I: TAdvNavigateBtn;
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Flat := Value;
  end;
end;

procedure TDBAdvNavigator.SetHints(Value: TStrings);
begin
  if Value.Text = FDefHints.Text then
    FHints.Clear else
    FHints.Assign(Value);
end;

function TDBAdvNavigator.GetHints: TStrings;
begin
  if (csDesigning in ComponentState) and not (csWriting in ComponentState) and
     not (csReading in ComponentState) and (FHints.Count = 0) then
    Result := FDefHints else
    Result := FHints;
end;

procedure TDBAdvNavigator.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TDBAdvNavigator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBAdvNavigator.SetVisible(Value: TButtonSet);
var
  I: TAdvNavigateBtn;
  W, H: Integer;
begin
  W := Width;
  H := Height;
  FVisibleButtons := Value;
  for I := Low(Buttons) to High(Buttons) do
    Buttons[I].Visible := I in FVisibleButtons;
  SetSize(W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  Invalidate;
end;

procedure TDBAdvNavigator.CalcMinSize(var W, H: Integer);
var
  Count: Integer;
  I: TAdvNavigateBtn;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  if Orientation = noHorizontal then
  begin
    W := Max(W, Count * MinBtnSize.X);
    H := Max(H, MinBtnSize.Y);
  end
  else
  begin
    W := Max(W, MinBtnSize.X);
    H := Max(H, Count * MinBtnSize.Y);
  end;

  if Align = alNone then W := (W div Count) * Count;
end;

procedure TDBAdvNavigator.SetSize(var W: Integer; var H: Integer);
var
  Count: Integer;
  I: TAdvNavigateBtn;
  Space, Temp, Remain: Integer;
  X, Y: Integer;
begin
  if (csLoading in ComponentState) then
    Exit;
  if Buttons[nbFirst] = nil then
    Exit;

  CalcMinSize(W, H);

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  if Orientation = noHorizontal then
  begin
    ButtonWidth := W div Count;
    Temp := Count * ButtonWidth;
    if Align = alNone then W := Temp;

    X := 0;
    Remain := W - Temp;
    Temp := Count div 2;
    for I := Low(Buttons) to High(Buttons) do
    begin
      if Buttons[I].Visible then
      begin
        Space := 0;
        if Remain <> 0 then
        begin
          Dec(Temp, Remain);
          if Temp < 0 then
          begin
            Inc(Temp, Count);
            Space := 1;
          end;
        end;
        Buttons[I].SetBounds(X, 0, ButtonWidth + Space, Height);
        Inc(X, ButtonWidth + Space);
      end
      else
        Buttons[I].SetBounds (Width + 1, 0, ButtonWidth, Height);
    end;
  end
  else
  begin
    ButtonHeight := H div Count;
    Temp := Count * ButtonHeight;
    if Align = alNone then
      H := Temp;

    Y := 0;
    Remain := H - Temp;
    Temp := Count div 2;
    for I := Low(Buttons) to High(Buttons) do
    begin
      if Buttons[I].Visible then
      begin
        Space := 0;
        if Remain <> 0 then
        begin
          Dec(Temp, Remain);
          if Temp < 0 then
          begin
            Inc(Temp, Count);
            Space := 1;
          end;
        end;
        Buttons[I].SetBounds(0, Y, Width, ButtonHeight + Space);
        Inc(Y, ButtonHeight + Space);
      end
      else
        Buttons[I].SetBounds(0,Height + 1, Width, ButtonHeight);
    end;

  end;

end;

procedure TDBAdvNavigator.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  if not HandleAllocated then SetSize(W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TDBAdvNavigator.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  W := Width;
  H := Height;
  SetSize(W, H);
end;

procedure TDBAdvNavigator.WMWindowPosChanging(var Message: TWMWindowPosChanging);
begin
  inherited;
  if (SWP_NOSIZE and Message.WindowPos.Flags) = 0 then
    CalcMinSize(Message.WindowPos.cx, Message.WindowPos.cy);
end;

procedure TDBAdvNavigator.ClickHandler(Sender: TObject);
begin
  BtnClick (TAdvNavButton (Sender).Index);
end;

procedure TDBAdvNavigator.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: TAdvNavigateBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := TAdvNavButton (Sender).Index;
  if TabStop and (GetFocus <> Handle) and CanFocus then
  begin
    SetFocus;
    if (GetFocus <> Handle) then
      Exit;
  end
  else if TabStop and (GetFocus = Handle) and (OldFocus <> FocusedButton) then
  begin
    Buttons[OldFocus].Invalidate;
    Buttons[FocusedButton].Invalidate;
  end;
end;

procedure TDBAdvNavigator.BtnClick(Index: TAdvNavigateBtn);
begin
  if (DataSource <> nil) and (DataSource.State <> dsInactive) then
  begin
    if not (csDesigning in ComponentState) and Assigned(FBeforeAction) then
      FBeforeAction(Self, Index);
    with DataSource.DataSet do
    begin
      case Index of
      nbPrior:
        if Assigned(FOnBtnPrior) then
          FOnBtnPrior(Self)
        else
          Prior;
      nbNext:
        if Assigned(FOnBtnNext) then
          FOnBtnNext(Self)
        else
          Next;
      nbFirst:
        if Assigned(FOnBtnFirst) then
          FOnBtnFirst(Self)
        else
          First;
      nbLast:
        if Assigned(FOnBtnLast) then
          FOnBtnLast(Self)
        else
          Last;
      nbInsert:
        if Assigned(FOnBtnInsert) then
          FOnBtnInsert(Self)
        else
          Insert;
      nbEdit:
        if Assigned(FOnBtnEdit) then
          FOnBtnEdit(Self)
        else
          Edit;
      nbCancel:
        if Assigned(FOnBtnCancel) then
          FOnBtnCancel(Self)
        else
          Cancel;
      nbPost:
        if Assigned(FOnBtnPost) then
          FOnBtnPost(Self)
        else
          Post;
      nbRefresh:
        if Assigned(FOnBtnRefresh) then
          FOnBtnRefresh(Self)
        else
          Refresh;
      nbDelete:
        if Assigned(FOnBtnDelete) then
          FOnBtnDelete(Self)
        else
        begin
          if not FConfirmDelete or
            (MessageDlg(SDeleteRecordQuestion, mtConfirmation,
              mbOKCancel, 0) <> idCancel) then
            Delete;
        end;
      nbSearch:
        if Assigned(FOnBtnSearch) then
          FOnBtnSearch(Self);
      nbSetBookmark:
        if Assigned(FOnBtnSetBookmark) then
          FOnBtnSetBookmark(Self)
        else
        begin
          FBookmark := Bookmark;
          Buttons[nbGotoBookmark].Enabled := True;
        end;  
      nbGotoBookmark:
        if Assigned(FOnBtnGotoBookmark) then
          FOnBtnGotoBookmark(Self)
        else
        begin
          if FBookmark <> '' then
            Bookmark := FBookmark
        end;  
      end;
    end;
  end;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
end;

procedure TDBAdvNavigator.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TDBAdvNavigator.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TDBAdvNavigator.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: TAdvNavigateBtn;
  OldFocus: TAdvNavigateBtn;
begin
  OldFocus := FocusedButton;
  case Key of
    VK_RIGHT:
      begin
        if OldFocus < High(Buttons) then
        begin
          NewFocus := OldFocus;
          repeat
            NewFocus := Succ(NewFocus);
          until (NewFocus = High(Buttons)) or (Buttons[NewFocus].Visible);
          if Buttons[NewFocus].Visible then
          begin
            FocusedButton := NewFocus;
            Buttons[OldFocus].Invalidate;
            Buttons[NewFocus].Invalidate;
          end;
        end;
      end;
    VK_LEFT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus > Low(Buttons) then
            NewFocus := Pred(NewFocus);
        until (NewFocus = Low(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_SPACE:
      begin
        if Buttons[FocusedButton].Enabled then
          Buttons[FocusedButton].Click;
      end;
  end;
end;

procedure TDBAdvNavigator.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TDBAdvNavigator.DataChanged;
var
  UpEnable, DnEnable: Boolean;
begin
  UpEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.BOF;
  DnEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.EOF;
  Buttons[nbFirst].Enabled := UpEnable;
  Buttons[nbPrior].Enabled := UpEnable;
  Buttons[nbNext].Enabled := DnEnable;
  Buttons[nbLast].Enabled := DnEnable;
  Buttons[nbDelete].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF);

  Buttons[nbSearch].Enabled := Enabled and FDataLink.Active;
  Buttons[nbSetBookmark].Enabled := Enabled and FDataLink.Active;
  Buttons[nbGotoBookmark].Enabled := Enabled and FDataLink.Active and (FBookmark <> '');
end;

procedure TDBAdvNavigator.EditingChanged;
var
  CanModify: Boolean;
begin
  CanModify := Enabled and FDataLink.Active and FDataLink.DataSet.CanModify;
  Buttons[nbInsert].Enabled := CanModify;
  Buttons[nbEdit].Enabled := CanModify and not FDataLink.Editing;
  Buttons[nbPost].Enabled := CanModify and FDataLink.Editing;
  Buttons[nbCancel].Enabled := CanModify and FDataLink.Editing;
  Buttons[nbRefresh].Enabled := CanModify;
end;

procedure TDBAdvNavigator.ActiveChanged;
var
  I: TAdvNavigateBtn;
begin
  if not (Enabled and FDataLink.Active) then
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Enabled := False
  else
  begin
    DataChanged;
    EditingChanged;
  end;
end;

procedure TDBAdvNavigator.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    ActiveChanged;
end;

procedure TDBAdvNavigator.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if not (csLoading in ComponentState) then
    ActiveChanged;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBAdvNavigator.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBAdvNavigator.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  SetSize(W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  InitHints;
  ActiveChanged;
  Shaded := FShaded;
end;

procedure TDBAdvNavigator.SetColor(const Value: TColor);
var
  J: TAdvNavigateBtn;
begin
  FColor := Value;
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].Color := Value;
end;

procedure TDBAdvNavigator.SetColorDown(const Value: TColor);
var
  J: TAdvNavigateBtn;
begin
  FColorDown := Value;
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].ColorDown := Value;
end;

procedure TDBAdvNavigator.SetColorHot(const Value: TColor);
var
  J: TAdvNavigateBtn;
begin
  FColorHot := Value;
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].ColorHot := Value;
end;

procedure TDBAdvNavigator.SetShaded(const Value: Boolean);
var
  I: TAdvNavigateBtn;
begin
  FShaded := Value;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Buttons[I].Shaded := FShaded;
  end;
end;

procedure TDBAdvNavigator.SetOrientation(const Value: TNavigatorOrientation);
var
  I: TAdvNavigateBtn;
  Count: Integer;
  W,H: Integer;
begin
  if (csDesigning in ComponentState) and (Value <> FOrientation)
    and not (csLoading in ComponentState) then
  begin
    FOrientation := Value;


    Count := 0;
    for I := Low(Buttons) to High(Buttons) do
      if Buttons[I].Visible then
        Inc(Count);

    if Value = noHorizontal then
      SetBounds(Left,Top,Count * MinBtnSize.X, MinBtnSize.Y)
    else
      SetBounds(Left,Top,MinBtnSize.X, MinBtnSize.Y * Count);


    if Value = noHorizontal then
    begin
      Width := Count * MinBtnSize.X;
      Height := MinBtnSize.Y;
    end
    else
    begin
      Width := MinBtnSize.X;
      Height := Count * MinBtnSize.Y;
    end;
    
    W := Width;
    H := Height;
    
    SetSize(W,H);
  end;

  FOrientation := Value;
end;

procedure TDBAdvNavigator.SetGlyphSize(const Value: TGlyphSize);
var
  I: TAdvNavigateBtn;
  ResName: string;
begin
  if FGlyphSize <> Value then
  begin
    FGlyphSize := Value;

    if GlyphSize = gsSmall then
      MinBtnSize := Point(20, 18)
    else
      MinBtnSize := Point(32, 30);

    for I := Low(Buttons) to High(Buttons) do
    begin
      if GlyphSize = gsSmall then
        FmtStr(ResName, '%sE', [BtnTypeAdvName[I]])
      else
        FmtStr(ResName, '%sLE', [BtnTypeAdvName[I]]);

      Buttons[I].Glyph.LoadFromResourceName(Hinstance,ResName);

      if GlyphSize = gsSmall then
        FmtStr(ResName, '%sH', [BtnTypeAdvName[I]])
      else
        FmtStr(ResName, '%sLH', [BtnTypeAdvName[I]]);

      Buttons[I].GlyphHot.LoadFromResourceName(Hinstance,ResName);

      if GlyphSize = gsSmall then
        FmtStr(ResName, '%sD', [BtnTypeAdvName[I]])
      else
        FmtStr(ResName, '%sLD', [BtnTypeAdvName[I]]);

      Buttons[I].GlyphDisabled.LoadFromResourceName(Hinstance,ResName);

    end;

  end;
end;

{TAdvNavButton}

destructor TAdvNavButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TAdvNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if nsAllowTimer in FNavStyle then
  begin
    if FRepeatTimer = nil then
      FRepeatTimer := TTimer.Create(Self);

    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
end;

procedure TAdvNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure TAdvNavButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if (FState = bsDown) and MouseCapture then
  begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

procedure TAdvNavButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if (GetFocus = Parent.Handle) and
     (FIndex = TDBAdvNavigator (Parent).FocusedButton) then
  begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if FState = bsDown then
      OffsetRect(R, 1, 1);
    Canvas.Brush.Style := bsSolid;
    Font.Color := clBtnShadow;
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

{ TAdvNavDataLink }

constructor TAdvNavDataLink.Create(ANav: TDBAdvNavigator);
begin
  inherited Create;
  FNavigator := ANav;
  VisualControl := True;
end;

destructor TAdvNavDataLink.Destroy;
begin
  FNavigator := nil;
  inherited Destroy;
end;

procedure TAdvNavDataLink.EditingChanged;
begin
  if FNavigator <> nil then FNavigator.EditingChanged;
end;

procedure TAdvNavDataLink.DataSetChanged;
begin
  if FNavigator <> nil then FNavigator.DataChanged;
end;

procedure TAdvNavDataLink.ActiveChanged;
begin
  if FNavigator <> nil then FNavigator.ActiveChanged;
end;


end.
