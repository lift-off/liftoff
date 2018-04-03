{********************************************************************
THTMLStatusBar component
for Delphi 2.0,3.0,4.0,5.0 + C++Builder 1.0,3.0,4.0,5.0
version 1.0
                        
written by TMS Software
           copyright © 2000
           Email : info@tmssoftware.com
           Website : http://www.tmssoftware.com/

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The complete
source code remains property of the author and may not be distributed,
published, given or sold in any form as such. No parts of the source
code can be included in any other component or application without
written authorization of the author.
********************************************************************}

unit HTMLStatusBar;

{$I TMSDEFS.INC}
{$DEFINE REMOVESTRIP}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, commctrl, {$IFDEF DELPHI4_LVL} stdactns,{$ENDIF} shellapi;

type

{ THTMLStatusBar }

  THTMLStatusBar = class;

  THTMLStatusPanelStyle = (psHTML, psText, psOwnerDraw, psTime, psDate, psNumLock, psCapsLock, psScrollLock, psProgress);
  THTMLStatusPanelBevel = (pbNone, pbLowered, pbRaised);

  TAnchorClick = procedure (Sender:TObject; Anchor:string) of object;

  TProgressIndication = (piPercentage, piAbsolute, piNone );

  THTMLStatusPanel = class;

  TProgressStyle = class(TPersistent)
  private
    fMin: integer;
    fPosition: integer;
    fMax: integer;
    fColor: tColor;
    fIndication: TProgressIndication;
    fBackground: tColor;
    fTextColor: tColor;
    fOwner:THTMLStatusPanel;
    procedure SetColor(const Value: tColor);
    procedure SetIndication(const Value: TProgressIndication);
    procedure SetMax(const Value: integer);
    procedure SetMin(const Value: integer);
    procedure SetPosition(const Value: integer);
    procedure SetBackGround(const Value: tColor);
    procedure SetTextColor(const Value: tColor);
  protected
    procedure Changed;
  public
    constructor Create(aOwner:THTMLStatusPanel);
    destructor Destroy; override;
  published
    property Color:tColor read fColor write SetColor;
    property BackGround:tColor read fBackground write SetBackGround;
    property TextColor: tColor read fTextColor write SetTextColor;
    property Indication:TProgressIndication read fIndication write SetIndication;
    property Min:integer read fMin write SetMin;
    property Max:integer read fMax write SetMax;
    property Position:integer read fPosition write SetPosition;
  end;

  THTMLStatusPanel = class(TCollectionItem)
  private
    FText: string;
    FWidth: Integer;
    FAlignment: TAlignment;
    FBevel: THTMLStatusPanelBevel;
    {$IFDEF DELPHI4_LVL}
    FBiDiMode: TBiDiMode;
    FParentBiDiMode: Boolean;
    {$ENDIF}
    FStyle: THTMLStatusPanelStyle;
    FUpdateNeeded: Boolean;
    FTimeFormat:string;
    fDateFormat:string;
    fHint:string;
    fProgressStyle: TProgressStyle;
    procedure SetAlignment(Value: TAlignment);
    procedure SetBevel(Value: THTMLStatusPanelBevel);
    {$IFDEF DELPHI4_LVL}
    procedure SetBiDiMode(Value: TBiDiMode);
    procedure SetParentBiDiMode(Value: Boolean);
    function IsBiDiModeStored: Boolean;
    {$ENDIF}
    procedure SetStyle(Value: THTMLStatusPanelStyle);
    procedure SetText(const Value: string);
    procedure SetWidth(Value: Integer);
    procedure SetDateFormat(const Value: string);
    procedure SetTimeFormat(const Value: string);
    procedure SetProgressStyle(const Value: TProgressStyle);
    procedure SetHint(const Value: string);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    {$IFDEF DELPHI4_LVL}
    procedure ParentBiDiModeChanged;
    {$ENDIF}
    function UseRightToLeftAlignment: Boolean;
    function UseRightToLeftReading: Boolean;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Bevel: THTMLStatusPanelBevel read FBevel write SetBevel default pbLowered;
    {$IFDEF DELPHI4_LVL}
    property BiDiMode: TBiDiMode read FBiDiMode write SetBiDiMode stored IsBiDiModeStored;
    property ParentBiDiMode: Boolean read FParentBiDiMode write SetParentBiDiMode default True;
    {$ENDIF}
    property Style: THTMLStatusPanelStyle read FStyle write SetStyle default psText;
    property Text: string read FText write SetText;
    property Width: Integer read FWidth write SetWidth;
    property DateFormat:string read fDateFormat write SetDateFormat;
    property TimeFormat:string read fTimeFormat write SetTimeFormat;
    property Progress:TProgressStyle read fProgressStyle write SetProgressStyle;
    property Hint:string read fHint write SetHint;
  end;

  THTMLStatusPanels = class(TCollection)
  private
    FStatusBar: THTMLStatusBar;
    function GetItem(Index: Integer): THTMLStatusPanel;
    procedure SetItem(Index: Integer; Value: THTMLStatusPanel);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(StatusBar: THTMLStatusBar);
    function Add: THTMLStatusPanel;
    property Items[Index: Integer]: THTMLStatusPanel read GetItem write SetItem; default;
  end;

  TDrawPanelEvent = procedure(StatusBar: THTMLStatusBar; Panel: THTMLStatusPanel;
    const Rect: TRect) of object;

  THTMLStatusBar = class(TWinControl)
  private
    FPanels: THTMLStatusPanels;
    FCanvas: TCanvas;
    FSimpleText: string;
    FSimplePanel: Boolean;
    FSizeGrip: Boolean;
    FUseSystemFont: Boolean;
    FAutoHint: Boolean;
    FOnDrawPanel: TDrawPanelEvent;
    FOnHint: TNotifyEvent;
    FURLColor:TColor;
    fTimerID: integer;
    fTimerCount: integer;
    fImages: TImageList;
    fMousePanel: integer;
    fAnchor:string;
    fAnchorHint:boolean;
    fAnchorClick:TAnchorClick;
    fAnchorEnter:TAnchorClick;
    fAnchorExit:TAnchorClick;
    function IsAnchor(x,y:integer):string;
    function GetPanel(x:integer):integer;
    procedure DoRightToLeftAlignment(var Str: string; AAlignment: TAlignment;
      ARTLAlignment: Boolean);
    function IsFontStored: Boolean;
    procedure SetPanels(Value: THTMLStatusPanels);
    procedure SetSimplePanel(Value: Boolean);
    procedure UpdateSimpleText;
    procedure SetSimpleText(const Value: string);
    procedure SetSizeGrip(Value: Boolean);
    procedure SyncToSystemFont;
    procedure UpdatePanel(Index: Integer; Repaint: Boolean);
    procedure UpdatePanels(UpdateRects, UpdateText: Boolean);
    {$IFDEF DELPHI4_LVL}
    procedure CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    {$ENDIF}
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMHintShow(var Msg: TMessage); message CM_HINTSHOW;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMWinIniChange(var Message: TMessage); message CM_WININICHANGE;
    procedure CMSysFontChanged(var Message: TMessage); message CM_SYSFONTCHANGED;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WMGetTextLength(var Message: TWMGetTextLength); message WM_GETTEXTLENGTH;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMTimer(var Msg:TWMTimer); message WM_TIMER;
    procedure SetUseSystemFont(const Value: Boolean);
    procedure SetImages(const Value: TImageList);
  protected
    procedure UpdateStatusBar; virtual;
    procedure ChangeScale(M, D: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Loaded; override;
    function DoHint: Boolean; virtual;
    procedure DrawPanel(Panel: THTMLStatusPanel; const Rect: TRect); dynamic;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {$IFDEF DELPHI4_LVL}
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure FlipChildren(AllLevels: Boolean); override;
    {$ENDIF}
    property Canvas: TCanvas read FCanvas;
  published
    {$IFDEF DELPHI4_LVL}
    property Action;
    property Anchors;
    property BiDiMode;
    property BorderWidth;
    property DragKind;
    property Constraints;
    property ParentBiDiMode;
    {$ENDIF}
    property AnchorHint:boolean read fAnchorHint write fAnchorHint;
    property AutoHint: Boolean read FAutoHint write FAutoHint default False;
    property Align default alBottom;
    property Color default clBtnFace;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font stored IsFontStored;
    property Images:TImageList read fImages write SetImages;
    property Panels: THTMLStatusPanels read FPanels write SetPanels;
    property ParentColor default False;
    property ParentFont default False;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property SimplePanel: Boolean read FSimplePanel write SetSimplePanel;
    property SimpleText: string read FSimpleText write SetSimpleText;
    property SizeGrip: Boolean read FSizeGrip write SetSizeGrip default True;
    property URLColor: TColor read fURLColor write fURLColor;
    property UseSystemFont: Boolean read FUseSystemFont write SetUseSystemFont default True;
    property Visible;
    property OnClick;
    {$IFDEF DELPHI5_LVL}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF DELPHI4_LVL}
    property OnEndDock;
    property OnStartDock;
    property OnResize;
    {$ENDIF}
    property OnEndDrag;
    property OnHint: TNotifyEvent read FOnHint write FOnHint;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDrawPanel: TDrawPanelEvent read FOnDrawPanel write FOnDrawPanel;
    property OnStartDrag;
    property OnAnchorClick:TAnchorClick read fAnchorClick write fAnchorClick;
    property OnAnchorEnter:TAnchorClick read fAnchorEnter write fAnchorEnter;
    property OnAnchorExit:TAnchorClick read fAnchorExit write fAnchorExit;
  end;


implementation

{$I HTMLENGL.PAS}

{ THTMLStatusPanel }

constructor THTMLStatusPanel.Create(Collection: TCollection);
begin
  FWidth := 50;
  FBevel := pbLowered;
  inherited Create(Collection);
  {$IFDEF DELPHI4_LVL}
  FParentBiDiMode := True;
  ParentBiDiModeChanged;
  {$ENDIF}
  fTimeFormat:='hh:mm:ss';
  fDateFormat:='mm/dd/yyyy';
  fProgressStyle:=TProgressStyle.Create(self);
end;

procedure THTMLStatusPanel.Assign(Source: TPersistent);
begin
  if Source is THTMLStatusPanel then
  begin
    Text := THTMLStatusPanel(Source).Text;
    Width := THTMLStatusPanel(Source).Width;
    Alignment := THTMLStatusPanel(Source).Alignment;
    Bevel := THTMLStatusPanel(Source).Bevel;
    Style := THTMLStatusPanel(Source).Style;
    DateFormat:= THTMLStatusPanel(Source).DateFormat;
    TimeFormat:= THTMLStatusPanel(Source).TimeFormat;
    Progress.Assign(THTMLStatusPanel(Source).Progress);
    Hint:= THTMLStatusPanel(Source).Hint; 
  end
  else inherited Assign(Source);
end;

{$IFDEF DELPHI4_LVL}
procedure THTMLStatusPanel.SetBiDiMode(Value: TBiDiMode);
begin
  if Value <> FBiDiMode then
  begin
    FBiDiMode := Value;
    FParentBiDiMode := False;
    Changed(False);
  end;
end;

function THTMLStatusPanel.IsBiDiModeStored: Boolean;
begin
  Result := not FParentBiDiMode;
end;

procedure THTMLStatusPanel.SetParentBiDiMode(Value: Boolean);
begin
  if FParentBiDiMode <> Value then
  begin
    FParentBiDiMode := Value;
    ParentBiDiModeChanged;
  end;
end;

procedure THTMLStatusPanel.ParentBiDiModeChanged;
begin
  if FParentBiDiMode then
  begin
    if GetOwner <> nil then
    begin
      BiDiMode := THTMLStatusPanels(GetOwner).FStatusBar.BiDiMode;
      FParentBiDiMode := True;
    end;
  end;
end;

{$ENDIF}

function THTMLStatusPanel.UseRightToLeftReading: Boolean;
begin
  {$IFDEF DELPHI4_LVL}
  Result := SysLocale.MiddleEast and (BiDiMode <> bdLeftToRight);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function THTMLStatusPanel.UseRightToLeftAlignment: Boolean;
begin
  {$IFDEF DELPHI4_LVL}
  Result := SysLocale.MiddleEast and (BiDiMode = bdRightToLeft);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function THTMLStatusPanel.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then Result := inherited GetDisplayName;
end;

procedure THTMLStatusPanel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure THTMLStatusPanel.SetBevel(Value: THTMLStatusPanelBevel);
begin
  if FBevel <> Value then
  begin
    FBevel := Value;
    Changed(False);
  end;
end;

procedure THTMLStatusPanel.SetStyle(Value: THTMLStatusPanelStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Changed(False);
  end;
end;

procedure THTMLStatusPanel.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(False);
  end;
end;

procedure THTMLStatusPanel.SetWidth(Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    Changed(True);
  end;
end;

procedure THTMLStatusPanel.SetDateFormat(const Value: string);
begin
  fDateFormat := Value;
  Changed(True);
end;

procedure THTMLStatusPanel.SetTimeFormat(const Value: string);
begin
  fTimeFormat := Value;
  Changed(True);
end;


procedure THTMLStatusPanel.SetProgressStyle(const Value: TProgressStyle);
begin
  fProgressStyle.Assign(Value);
  Changed(True);
end;

procedure THTMLStatusPanel.SetHint(const Value: string);
begin
  fHint := Value;
  Changed(True);
end;

destructor THTMLStatusPanel.Destroy;
begin
  fProgressStyle.Free;
  inherited;
end;

{ THTMLStatusPanels }

constructor THTMLStatusPanels.Create(StatusBar: THTMLStatusBar);
begin
  inherited Create(THTMLStatusPanel);
  FStatusBar := StatusBar;
end;

function THTMLStatusPanels.Add: THTMLStatusPanel;
begin
  Result := THTMLStatusPanel(inherited Add);
end;

function THTMLStatusPanels.GetItem(Index: Integer): THTMLStatusPanel;
begin
  Result := THTMLStatusPanel(inherited GetItem(Index));
end;

function THTMLStatusPanels.GetOwner: TPersistent;
begin
  Result := FStatusBar;
end;

procedure THTMLStatusPanels.SetItem(Index: Integer; Value: THTMLStatusPanel);
begin
  inherited SetItem(Index, Value);
end;

procedure THTMLStatusPanels.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    FStatusBar.UpdatePanel(Item.Index, False) else
    FStatusBar.UpdatePanels(True, False);
end;

{ THTMLStatusBar }

constructor THTMLStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Color := clBtnFace;
  Height := 19;
  Align := alBottom;
  FPanels := THTMLStatusPanels.Create(Self);
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  FSizeGrip := True;
  ParentFont := False;
  FURLColor:=clBlue;
  FUseSystemFont := True;
  SyncToSystemFont;
  ControlStyle := ControlStyle + [csAcceptsControls];
  FMousepanel:=-1;
  FTimerCount:=0;
end;

destructor THTMLStatusBar.Destroy;
begin
  FCanvas.Free;
  FPanels.Free;
  inherited Destroy;
end;

procedure THTMLStatusBar.CreateParams(var Params: TCreateParams);
const
  GripStyles: array[Boolean] of DWORD = (CCS_TOP, SBARS_SIZEGRIP);
begin
  InitCommonControl(ICC_BAR_CLASSES);
  inherited CreateParams(Params);
  CreateSubClass(Params, STATUSCLASSNAME);
  with Params do
  begin
    Style := Style or GripStyles[FSizeGrip and (Parent is TCustomForm)
      {$IFDEF DELPHI4_LVL} and (TCustomForm(Parent).BorderStyle in [bsSizeable, bsSizeToolWin]){$ENDIF}];
    WindowClass.style := WindowClass.style and not CS_HREDRAW;
  end;
end;

procedure THTMLStatusBar.DestroyWnd;
begin
 KillTimer(handle,fTimerID);
 inherited DestroyWnd;
end;

procedure THTMLStatusBar.CreateWnd;
begin
  inherited CreateWnd;
  {$IFDEF DELPHI4_LVL}
  SendMessage(Handle, SB_SETBKCOLOR, 0, ColorToRGB(Color));
  {$ENDIF}
  UpdatePanels(True, False);
  if FSimpleText <> '' then
    SendMessage(Handle, SB_SETTEXT, 255, Integer(PChar(FSimpleText)));
  if FSimplePanel then
    SendMessage(Handle, SB_SIMPLE, 1, 0);

  fTimerID:=settimer(handle,111,100,nil);
end;

function THTMLStatusBar.DoHint: Boolean;
begin
  if Assigned(FOnHint) then
  begin
    FOnHint(Self);
    Result := True;
  end
  else Result := False;
end;

procedure THTMLStatusBar.DrawPanel(Panel: THTMLStatusPanel; const Rect: TRect);
var
 anchor,stripped,pros:string;
 xsize,ysize:integer;
 srcrect,tgtrect,r:trect;
 srcColor:tcolor;
 refwi,th:integer;
begin
  r:=rect;
  case Panel.Style of
  psHTML:begin
          HTMLDraw(canvas,panel.Text,rect,fImages,0,0,false,false,false,false,(fTimerCount>5),true,1.0,URLColor,anchor,stripped,xsize,ysize);
         end;
  psProgress:begin
     srccolor:=canvas.brush.color;
     canvas.brush.color:=panel.progress.color;
     canvas.pen.color:=panel.progress.color;
     canvas.font.color:=panel.progress.textcolor;
     inflaterect(r,-2,-2);
     srcrect:=r;

     case panel.progress.Indication of
     piNone:pros:='';
     piPercentage:if (panel.progress.max-panel.progress.min)>0 then pros:=inttostr(round(100*panel.progress.position/(panel.progress.max-panel.progress.min)))+'%'
                  else pros:='0%';
     piAbsolute:pros:=inttostr(panel.progress.position);
     end;

     th := canvas.textHeight(pros);

     refwi:=panel.progress.max-panel.progress.min;
     if (refwi=0) then refwi:=panel.progress.position;

     srcrect.right:=srcrect.left+round( (srcrect.right-srcrect.left)*(panel.progress.position)/(refwi));
     tgtrect.left:=r.left+(((r.right-r.left)-canvas.textwidth(pros)) shr 1);
     
     if (r.Bottom - r.Top > th) then
       tgtrect.top:=r.top+(((r.bottom-r.top)-th) shr 1);

     canvas.textrect(srcrect,tgtrect.left,tgtrect.top,pros);

     canvas.brush.color:=panel.progress.background;
     canvas.pen.color:=panel.progress.background;
     canvas.font.color:=panel.progress.background xor $ffffff;

     srcrect.left:=srcrect.right;
     srcrect.right:=r.right;
     canvas.textrect(srcrect,tgtrect.left,tgtrect.top,pros);

     canvas.brush.Color:=srcColor;
     canvas.pen.color:=srcColor;
     inflaterect(r,1,1);
     canvas.framerect(r);
     inflaterect(r,1,1);
     canvas.framerect(r);
     end
  else
  if Assigned(FOnDrawPanel) then
    FOnDrawPanel(Self, Panel, Rect) else
    FCanvas.FillRect(Rect);
  end; {of case}
end;

procedure THTMLStatusBar.SetPanels(Value: THTMLStatusPanels);
begin
  FPanels.Assign(Value);
end;

procedure THTMLStatusBar.SetSimplePanel(Value: Boolean);
begin
  if FSimplePanel <> Value then
  begin
    FSimplePanel := Value;
    if HandleAllocated then
      SendMessage(Handle, SB_SIMPLE, Ord(FSimplePanel), 0);
  end;
end;

procedure THTMLStatusBar.DoRightToLeftAlignment(var Str: string;
  AAlignment: TAlignment; ARTLAlignment: Boolean);
begin
  {$IFDEF DELPHI4_LVL}
  if ARTLAlignment then ChangeBiDiModeAlignment(AAlignment);
  {$ENDIF}

  case AAlignment of
    taCenter: Insert(#9, Str, 1);
    taRightJustify: Insert(#9#9, Str, 1);
  end;
end;

procedure THTMLStatusBar.UpdateSimpleText;
const
  RTLReading: array[Boolean] of Longint = (0, SBT_RTLREADING);
begin
  {$IFDEF DELPHI4_LVL}
  DoRightToLeftAlignment(FSimpleText, taLeftJustify, UseRightToLeftAlignment);
  {$ELSE}
  DoRightToLeftAlignment(FSimpleText, taLeftJustify, False);
  {$ENDIF}
  if HandleAllocated then
    SendMessage(Handle, SB_SETTEXT, 255 {$IFDEF DELPHI4_LVL} or RTLREADING[UseRightToLeftReading] {$ENDIF},
      Integer(PChar(FSimpleText)));
end;

procedure THTMLStatusBar.SetSimpleText(const Value: string);
begin
  if FSimpleText <> Value then
  begin
    FSimpleText := Value;
    UpdateSimpleText;
  end;
end;

{$IFDEF DELPHI4_LVL}
procedure THTMLStatusBar.CMBiDiModeChanged(var Message: TMessage);
var
  Loop: Integer;
begin
  inherited;
  if HandleAllocated then
    if not SimplePanel then
    begin
      for Loop := 0 to Panels.Count - 1 do
        if Panels[Loop].ParentBiDiMode then
          Panels[Loop].ParentBiDiModeChanged;
      UpdatePanels(True, True);
    end
    else
      UpdateSimpleText;
end;


procedure THTMLStatusBar.FlipChildren(AllLevels: Boolean);
var
  Loop, FirstWidth, LastWidth: Integer;
  APanels: THTMLStatusPanels;
begin
  if HandleAllocated and
     (not SimplePanel) and (Panels.Count > 0) then
  begin
    { Get the true width of the last panel }
    LastWidth := ClientWidth;
    FirstWidth := Panels[0].Width;
    for Loop := 0 to Panels.Count - 2 do Dec(LastWidth, Panels[Loop].Width);
    { Flip 'em }
    APanels := THTMLStatusPanels.Create(Self);
    try
      for Loop := 0 to Panels.Count - 1 do with APanels.Add do
        Assign(Self.Panels[Loop]);
      for Loop := 0 to Panels.Count - 1 do
        Panels[Loop].Assign(APanels[Panels.Count - Loop - 1]);
    finally
      APanels.Free;
    end;
    { Set the width of the last panel }
    if Panels.Count > 1 then
    begin
      Panels[Panels.Count-1].Width := FirstWidth;
      Panels[0].Width := LastWidth;
    end;
    UpdatePanels(True, True);
  end;
end;
{$ENDIF}

procedure THTMLStatusBar.SetSizeGrip(Value: Boolean);
begin
  if FSizeGrip <> Value then
  begin
    FSizeGrip := Value;
    RecreateWnd;
  end;
end;

procedure THTMLStatusBar.SyncToSystemFont;
begin
  {$IFDEF DELPHI5_LVL}
  if FUseSystemFont then
    Font := Screen.HintFont;
  {$ENDIF}
end;

procedure THTMLStatusBar.UpdatePanel(Index: Integer; Repaint: Boolean);
var
  Flags: Integer;
  S: string;
  PanelRect: TRect;
begin
  if HandleAllocated then
    with Panels[Index] do
    begin
      if not Repaint then
      begin
        FUpdateNeeded := True;
        SendMessage(Handle, SB_GETRECT, Index, Integer(@PanelRect));
        InvalidateRect(Handle, @PanelRect, True);
        Exit;
      end
      else if not FUpdateNeeded then Exit;
      FUpdateNeeded := False;
      Flags := 0;
      case Bevel of
        pbNone: Flags := SBT_NOBORDERS;
        pbRaised: Flags := SBT_POPOUT;
      end;
      if UseRightToLeftReading then Flags := Flags or SBT_RTLREADING;

      if Style in [psHTML, psOwnerDraw, psProgress] then Flags := Flags or SBT_OWNERDRAW;
      S := Text;
      if UseRightToLeftAlignment then
        DoRightToLeftAlignment(S, Alignment, UseRightToLeftAlignment)
      else
        case Alignment of
          taCenter: Insert(#9, S, 1);
          taRightJustify: Insert(#9#9, S, 1);
        end;
      SendMessage(Handle, SB_SETTEXT, Index or Flags, Integer(PChar(S)));

    end;
end;

procedure THTMLStatusBar.UpdatePanels(UpdateRects, UpdateText: Boolean);
const
  MaxPanelCount = 128;
var
  I, Count, PanelPos: Integer;
  PanelEdges: array[0..MaxPanelCount - 1] of Integer;
begin
  if HandleAllocated then
  begin
    Count := Panels.Count;
    if UpdateRects then
    begin
      if Count > MaxPanelCount then Count := MaxPanelCount;
      if Count = 0 then
      begin
        PanelEdges[0] := -1;
        SendMessage(Handle, SB_SETPARTS, 1, Integer(@PanelEdges));
        SendMessage(Handle, SB_SETTEXT, 0, Integer(PChar('')));
      end else
      begin
        PanelPos := 0;
        for I := 0 to Count - 2 do
        begin
          Inc(PanelPos, Panels[I].Width);
          PanelEdges[I] := PanelPos;
        end;
        PanelEdges[Count - 1] := -1;
        SendMessage(Handle, SB_SETPARTS, Count, Integer(@PanelEdges));
      end;
    end;
    for I := 0 to Count - 1 do
      UpdatePanel(I, UpdateText);
  end;
end;

procedure THTMLStatusBar.CMWinIniChange(var Message: TMessage);
begin
  inherited;
  if (Message.WParam = 0) or (Message.WParam = SPI_SETNONCLIENTMETRICS) then
    SyncToSystemFont;
end;

procedure THTMLStatusBar.CNDrawItem(var Message: TWMDrawItem);
var
  SaveIndex: Integer;
begin
  with Message.DrawItemStruct^ do
  begin
    SaveIndex := SaveDC(hDC);
    FCanvas.Lock;
    try
      FCanvas.Handle := hDC;
      FCanvas.Font.Assign(Font);
      FCanvas.Brush.Color := clBtnFace;
      FCanvas.Brush.Style := bsSolid;
      DrawPanel(Panels[itemID], rcItem);
    finally
      FCanvas.Handle := 0;
      FCanvas.Unlock;
      RestoreDC(hDC, SaveIndex);
    end;
  end;
  Message.Result := 1;
end;

procedure THTMLStatusBar.WMGetTextLength(var Message: TWMGetTextLength);
begin
  Message.Result := Length(FSimpleText);
end;

procedure THTMLStatusBar.WMPaint(var Message: TWMPaint);
begin
  UpdatePanels(False, True);

  inherited;
end;

procedure THTMLStatusBar.UpdateStatusBar;
var
 i:integer;
 s:string;
begin
 for i:=1 to Panels.Count do
  begin
   case Panels[i-1].Style of
   psHTML:if (pos('<BLINK',uppercase(Panels[i-1].Text))<>0) and (fTimerCount in [5,10]) then
           begin
            s:=Panels[i-1].Text;
            Panels[i-1].Text:='';
            Panels[i-1].Text:=s;
           end;
   psTime:Panels[i-1].Text:=FormatDateTime(Panels[i-1].TimeFormat,Now);
   psDate:Panels[i-1].Text:=FormatDateTime(Panels[i-1].DateFormat,Now);
   psNumLock:begin
              if getkeystate(vk_numlock) and $1=$1 then
                Panels[i-1].Text:='NUM'
              else
                Panels[i-1].Text:=''
             end;
   psCapsLock:begin
               if getkeystate(vk_capital) and $1=$1 then
               Panels[i-1].Text:='CAP'
               else
               Panels[i-1].Text:=''
              end;
   psScrollLock:begin
               if getkeystate(vk_scroll) and $1=$1 then
               Panels[i-1].Text:='SCRL'
               else
               Panels[i-1].Text:=''
              end;
   end;
  end;
end;

procedure THTMLStatusBar.WMTimer(var Msg:TWMTimer);
begin
  UpdateStatusBar;
  inc(fTimerCount);
  if (fTimerCount>10) then fTimerCount:=0;
end;

procedure THTMLStatusBar.WMSize(var Message: TWMSize);
begin
  { Eat WM_SIZE message to prevent control from doing alignment }
  {$IFDEF DELPHI4_LVL}
  if not (csLoading in ComponentState) then Resize;
  {$ENDIF}
  Repaint;
end;

function THTMLStatusBar.IsFontStored: Boolean;
begin
  Result := not FUseSystemFont and not ParentFont and not DesktopFont;
end;

procedure THTMLStatusBar.SetUseSystemFont(const Value: Boolean);
begin
  if FUseSystemFont <> Value then
  begin
    FUseSystemFont := Value;
    if Value then
    begin
      if ParentFont then ParentFont := False;
      SyncToSystemFont;
    end;
  end;
end;

procedure THTMLStatusBar.CMColorChanged(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;

procedure THTMLStatusBar.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if FUseSystemFont and ParentFont then FUseSystemFont := False;
end;

{$IFDEF DELPHI4_LVL}
function THTMLStatusBar.ExecuteAction(Action: TBasicAction): Boolean;
begin
  if AutoHint and (Action is THintAction) and not DoHint then
  begin
    if SimplePanel or (Panels.Count = 0) then
      SimpleText := THintAction(Action).Hint else
      Panels[0].Text := THintAction(Action).Hint;
    Result := True;
  end
  else Result := inherited ExecuteAction(Action);
end;
{$ENDIF}

procedure THTMLStatusBar.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;

procedure THTMLStatusBar.CMSysFontChanged(var Message: TMessage);
begin
  inherited;
  SyncToSystemFont;
end;

procedure THTMLStatusBar.ChangeScale(M, D: Integer);
begin
  if UseSystemFont then  // status bar size based on system font size
    ScalingFlags := [sfTop];
  inherited;
end;

procedure THTMLStatusBar.SetImages(const Value: TImageList);
begin
  fImages := Value;
  self.Invalidate;
end;

procedure THTMLStatusBar.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (aOperation=opRemove) and (aComponent=fImages) then fImages:=nil;
  inherited;
end;

procedure THTMLStatusBar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
 anchor:string;
 idx:integer;
begin
 anchor:=IsAnchor(x,y);

 idx:=GetPanel(x);
 if fMousePanel<>idx then
  begin
   Application.CancelHint;
   fMousePanel:=idx;
  end;

 if (Anchor<>'') then
   begin
    if (self.Cursor=crDefault) or (fAnchor<>Anchor) then
     begin
      fAnchor:=Anchor;
      self.Cursor:=crHandPoint;
      if fAnchorHint then Application.CancelHint;
      if assigned(fAnchorEnter) then fAnchorEnter(self,anchor);
     end;
   end
 else
   begin
     if (self.Cursor=crHandPoint) then
      begin
       self.Cursor:=crDefault;
       if assigned(fAnchorExit) then fAnchorExit(self,anchor);
      end;
   end;
 inherited;
end;

function THTMLStatusBar.IsAnchor(x, y: integer): string;
var
 r:trect;
 xsize,ysize:integer;
 anchor,stripped:string;
 idx:integer;
begin
 idx:=GetPanel(x);
 if (idx<0) then exit;

 sendmessage(self.Handle,SB_GETRECT,idx,longint(@r));
 anchor:='';
 if HTMLDraw(canvas,panels.items[idx].Text,r,fImages,x,y,true,false,false,true,true,true,1.0,FURLColor,anchor,stripped,xsize,ysize) then
  result:=anchor;
end;

function THTMLStatusBar.GetPanel(x: integer): integer;
var
 r:trect;
 i:integer;
begin
 result:=-1;
 for i:=1 to panels.Count do
  begin
   sendmessage(self.Handle,SB_GETRECT,i-1,longint(@r));
   if (x>=r.left) and (x<=r.right) then
    begin
     result:=i-1;
     break;
    end;
  end;

end;

Procedure THTMLStatusBar.CMHintShow(Var Msg: TMessage);
var
  CanShow: Boolean;
  hi: PHintInfo;
  anchor:string;
  idx:integer;
Begin
  CanShow := True;
  hi := PHintInfo(Msg.LParam);

  idx:=GetPanel(hi^.cursorPos.x);

  if (idx >= 0) and (idx < Panels.Count) then
  begin
    if Panels[idx].Style=psHTML then
    begin
      if FAnchorHint then
      begin
        anchor := IsAnchor(hi^.cursorPos.x,hi^.cursorpos.y);
        if (anchor <> '') then
        begin
          hi^.HintPos := clienttoscreen(hi^.CursorPos);
          hi^.hintpos.y := hi^.hintpos.y-10;
          hi^.hintpos.x := hi^.hintpos.x+10;
          hi^.HintStr := anchor;
        end
        else
        begin
          if (Panels[idx].Hint <> '') then
            hi^.HintStr := Panels[idx].Hint;
        end;
      end
      else
      begin
        if (Panels[idx].Hint <> '') then
          hi^.HintStr := Panels[idx].Hint;
      end;
    end
    else
    begin
      if (Panels[idx].Hint<>'') then hi^.HintStr := Panels[idx].Hint;
    end;
  end;


 Msg.Result := Ord(Not CanShow);
end;


procedure THTMLStatusBar.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 Anchor:string;
begin
 inherited MouseDown(Button,Shift,X,Y);

 anchor:=IsAnchor(X,Y);
 if anchor<>'' then
   begin
    if (pos('://',anchor)>0) or (pos('mailto:',anchor)>0) then
     shellexecute(0,'open',pchar(anchor),nil,nil,SW_NORMAL)
    else
     begin
      if assigned(fAnchorClick) then
         fAnchorClick(self,anchor);
     end;
   end;

end;

procedure THTMLStatusBar.Loaded;
begin
  inherited;
  UpdateStatusBar;
end;

{ TProgressStyle }

procedure TProgressStyle.Changed;
var
 r:trect;
begin
 {optimized repaint}
 sendmessage(THTMLStatusPanels(fOwner.Collection).fStatusbar.handle,SB_GETRECT,fOwner.index,longint(@r));
 invalidaterect(THTMLStatusPanels(fOwner.Collection).fStatusbar.handle,@r,true);
 {fOwner.Changed(true);}
end;

constructor TProgressStyle.Create(aOwner:THTMLStatusPanel);
begin
  inherited Create;
  fBackground:=clBtnFace;
  fTextColor:=clHighLightText;
  fColor:=clHighLight;
  fMin:=0;
  fMax:=100;
  fOwner:=aOwner;
end;

destructor TProgressStyle.Destroy;
begin
  inherited;
end;

procedure TProgressStyle.SetBackGround(const Value: tColor);
begin
  fBackground := Value;
  Changed;
end;

procedure TProgressStyle.SetColor(const Value: tColor);
begin
  fColor := Value;
  Changed;
end;

procedure TProgressStyle.SetIndication(const Value: TProgressIndication);
begin
  fIndication := Value;
  Changed;
end;

procedure TProgressStyle.SetMax(const Value: integer);
begin
  fMax := Value;
  Changed;
end;

procedure TProgressStyle.SetMin(const Value: integer);
begin
  fMin := Value;
  Changed;
end;

procedure TProgressStyle.SetPosition(const Value: integer);
begin
  fPosition := Value;
  Changed;
end;

procedure TProgressStyle.SetTextColor(const Value: tColor);
begin
  fTextColor := Value;
  Changed;
end;

end.
