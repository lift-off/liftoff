{***********************************************************************}
{ TPlannerDatePicker component                                          }
{ for Delphi & C++ Builder                                              }
{ version 1.3                                                           }
{                                                                       }
{ written by :                                                          }
{            TMS Software                                               }
{            copyright © 1999-2003                                      }
{            Email : info@tmssoftware.com                               }
{            Website : http://www.tmssoftware.com                       }
{                                                                       }
{ The source code is given as is. The author is not responsible         }
{ for any possible damage done due to the use of this code.             }
{ The component can be freely used in any application. The source       }
{ code remains property of the writer and may not be distributed        }
{ freely as such.                                                       }
{***********************************************************************}

{$I TMSDEFS.INC}

unit PlannerDatePicker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AdvEdBtn, PlannerCal;

type
  TPlannerDatePicker = class(TAdvEditBtn)
  private
    FPlannerCalendar: TPlannerCalendar;
    APlannerCalendar: TPlannerCalendar;
    PlannerParent : TForm;
    CancelThisBtnClick : Boolean;
    FHideCalendarAfterSelection: boolean;
    FOnDaySelect: TDaySelectEvent;
    function GetOnGetDateHint: TGetDateEvent;
    function GetOnGetDateHintString: TGetDateEventHint;
    procedure SetOnGetDateHint(const Value: TGetDateEvent);
    procedure SetOnGetDateHintString(const Value: TGetDateEventHint);
    procedure HideParent;
    procedure InitEvents;
    function GetParentEx: TWinControl;
    procedure SetParentEx(const Value: TWinControl);
    function GetOnGetEventProp: TEventPropEvent;
    procedure SetOnGetEventProp(const Value: TEventPropEvent);
    function GetOnWeekSelect: TNotifyEvent;
    procedure SetOnWeekSelect(const Value: TNotifyEvent);
    function GetOnAllDaySelect: TNotifyEvent;
    procedure SetOnAllDaySelect(const Value: TNotifyEvent);
    function GetDate: TDateTime;
    procedure SetDate(const Value: TDateTime);
    { Private declarations }
  protected
    { Protected declarations }
    procedure BtnClick(Sender: TObject); override;
    procedure PlannerParentDeactivate(Sender: TObject);
    procedure PlannerCalendarDaySelect(Sender: TObject; SelDate: TDateTime);
    procedure PlannerCalendarKeyPress(Sender: TObject; var Key: Char);
    procedure PlannerCalendarKeyDown(Sender: TObject; var Key: Integer;
      Shift: TShiftState);
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    // methods to do correct streaming, because the planner calendar is
    // stored on a hidden form
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetChildParent : TComponent; override;
    function GetChildOwner : TComponent; override;
    procedure Loaded; override;
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure CancelBtnClick;
    destructor Destroy; override;

    procedure DropDown; virtual;
    procedure CreateWnd; override;
    property Date: TDateTime read GetDate write SetDate;
    property Parent: TWinControl read GetParentEx write SetParentEx;
  published
    { Published declarations }
    property Calendar : TPlannerCalendar read FPlannerCalendar
      write FPlannerCalendar;
    property HideCalendarAfterSelection : boolean read FHideCalendarAfterSelection
      write FHideCalendarAfterSelection;
    property OnGetDateHint: TGetDateEvent read GetOnGetDateHint
      write SetOnGetDateHint;
    property OnGetDateHintString: TGetDateEventHint read GetOnGetDateHintString
      write SetOnGetDateHintString;
    property OnGetEventProp: TEventPropEvent read GetOnGetEventProp
      write SetOnGetEventProp;
    property OnWeekSelect: TNotifyEvent read GetOnWeekSelect write SetOnWeekSelect;
    property OnAllDaySelect: TNotifyEvent read GetOnAllDaySelect write SetOnAllDaySelect;
    property OnDaySelect: TDaySelectEvent read FOnDaySelect write FOnDaySelect;
  end;

implementation


{ TPlannerDatePicker }

procedure TPlannerDatePicker.DropDown;
var
  PlannerPosition : TPoint;
  r: TRect;

  function Min(a,b: Integer): Integer;
  begin
    if (a > b) then
      Result := b
    else
      Result := a;
  end;

  function CHeckDate(dt: TDateTime): TDateTime;
  begin
    Result := dt;
    if dt < Calendar.MinDate.Date then
      Result := Calendar.MinDate.Date;
    if dt > Calendar.MaxDate.Date then
      Result := Calendar.MinDate.Date;
  end;

begin
  // Set planner position
  PlannerPosition.x := -2;
  PlannerPosition.y := Height - 3;
  PlannerPosition := ClientToScreen(PlannerPosition);

  SystemParametersInfo(SPI_GETWORKAREA, 0,@r,0); //account for taskbar...

  if (plannerposition.y + FPlannerCalendar.Height > r.Bottom) then
    plannerposition.Y := plannerposition.Y - FPlannerCalendar.Height - Height + 3;

  if (plannerposition.x + FPlannerCalendar.Width > r.right) then
    plannerposition.x := plannerposition.x - (FPlannerCalendar.Width - Width);

  PlannerParent.Left := PlannerPosition.x;
  PlannerParent.Top := PlannerPosition.y;

  {$IFNDEF DELPHI4_LVL}
  PlannerParent.Width := FPlannerCalendar.Width;
  PlannerParent.Height := FPlannerCalendar.Height;
  {$ENDIF}

  // Set planner date

  if FPlannerCalendar.MultiSelect then
    Text := FPlannerCalendar.DatesAsText
  else
  begin
    try
      if Text = '' then
        FPlannerCalendar.Date := CheckDate(Now)
      else
        FPlannerCalendar.Date := StrToDate(Text);
    except
      on Exception do
         Text := FPlannerCalendar.DatesAsText;
    end;
  end;

  PlannerParent.Show;
  FPlannerCalendar.SetFocus;
end;


procedure TPlannerDatePicker.BtnClick(Sender: TObject);
begin
  CancelThisBtnClick := False;
  inherited;
  // call event OnClick - the user can cancel calendar appearance of calendar by calling .CancelBtnClick
  if CancelThisBtnClick then
    Exit;
  DropDown;
end;

procedure TPlannerDatePicker.CancelBtnClick;
begin
  CancelThisBtnClick := True;
end;

constructor TPlannerDatePicker.Create(AOwner: TComponent);
begin
  inherited;
  // Make planner parent form and a planner, put planner on parent form
  Text := '';
  PlannerParent := TForm.Create(Self);
  PlannerParent.BorderStyle := bsNone;

  FPlannerCalendar := TPlannerCalendar.Create(Self);
  FPlannerCalendar.Parent := PlannerParent;

  {$IFDEF DELPHI4_LVL}
  PlannerParent.Autosize := True;
  {$ELSE}
  PlannerParent.Width := FPlannerCalendar.Width;
  PlannerParent.Height := FPlannerCalendar.Height;
  {$ENDIF}

  PlannerParent.OnDeactivate := PlannerParentDeactivate;
  FPlannerCalendar.OnDaySelect := PlannerCalendarDaySelect;

  Width := FPlannerCalendar.Width;
  FHideCalendarAfterSelection := True;

  Button.Glyph.Handle := LoadBitmap(0, MakeIntResource(OBM_COMBO));

  // Make the button NOT change the focus
  Button.FocusControl := nil;
end;


destructor TPlannerDatePicker.Destroy;
begin
  FPlannerCalendar.Free;
  PlannerParent.Free;
  inherited;
end;

function TPlannerDatePicker.GetChildOwner: TComponent;
begin
  Result := PlannerParent;
end;

function TPlannerDatePicker.GetChildParent: TComponent;
begin
  Result := PlannerParent;
end;

procedure TPlannerDatePicker.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
  inherited;
  Proc(FPlannerCalendar);
  FPlannerCalendar.Parent := PlannerParent;
end;

function TPlannerDatePicker.GetOnGetDateHint: TGetDateEvent;
begin
  Result := FPlannerCalendar.OnGetDateHint;
end;

function TPlannerDatePicker.GetOnGetDateHintString: TGetDateEventHint;
begin
  Result := FPlannerCalendar.OnGetDateHintString;
end;

procedure TPlannerDatePicker.HideParent;
begin
  PlannerParent.Hide;
  SetFocus;
end;

procedure TPlannerDatePicker.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (key = VK_F4) and not (ssAlt in Shift) and not (ssCtrl in Shift) then
    if PlannerParent.Visible then
      HideParent
    else
      BtnClick(Self);
end;

procedure TPlannerDatePicker.InitEvents;
begin
  FPlannerCalendar.OnDaySelect := PlannerCalendarDaySelect;
  FPlannerCalendar.OnKeyPress := PlannerCalendarKeypress;
end;

procedure TPlannerDatePicker.Loaded;
begin
  inherited;

  if PlannerParent.ComponentCount > 0 then
  begin
    APlannerCalendar := (PlannerParent.Components[0] as TPlannerCalendar);
    APlannerCalendar.OnGetDateHint := FPlannerCalendar.OnGetDateHint;
    APlannerCalendar.OnGetDateHintString := FPlannerCalendar.OnGetDateHintString;
    FPlannerCalendar.Free;
    FPlannerCalendar := APlannerCalendar;
    InitEvents;
  end;
end;

procedure TPlannerDatePicker.PlannerCalendarDaySelect(Sender: TObject; SelDate: TDateTime);
begin
  Text := FPlannerCalendar.DatesAsText;
  if FHideCalendarAfterSelection then
    HideParent;
  if Assigned(FOnDaySelect) then
    FOnDaySelect(Self,SelDate);
end;

procedure TPlannerDatePicker.PlannerCalendarKeyDown(Sender: TObject;
  var Key: Integer; Shift: TShiftState);
begin
  if Key = VK_F4 then
    HideParent;
end;

procedure TPlannerDatePicker.PlannerCalendarKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then
  begin
    PlannerCalendarDaySelect(Sender, FPlannerCalendar.Date);
  end;
  if Key = #27 then
  begin
    HideParent;
  end;
end;

procedure TPlannerDatePicker.PlannerParentDeactivate(Sender: TObject);
begin
  (Sender as TForm).Hide;
end;

procedure TPlannerDatePicker.SetOnGetDateHint(const Value: TGetDateEvent);
begin
  FPlannerCalendar.OnGetDateHint := Value;
end;

procedure TPlannerDatePicker.SetOnGetDateHintString(
  const Value: TGetDateEventHint);
begin
  FPlannerCalendar.OnGetDateHintString := Value;
end;

function TPlannerDatePicker.GetOnGetEventProp: TEventPropEvent;
begin
  Result := FPlannerCalendar.OnGetEventProp;
end;

procedure TPlannerDatePicker.SetOnGetEventProp(
  const Value: TEventPropEvent);
begin
  FPlannerCalendar.OnGetEventProp := Value;
end;


procedure TPlannerDatePicker.WMSetFocus(var Message: TWMSetFocus);
begin
  if EditorEnabled then
    inherited
  else
    Button.SetFocus;
end;

procedure TPlannerDatePicker.Change;
var
  dt: TDateTime;
begin
  inherited;

  // try to extract the date
  try
    dt := strtodate(Text);
    Calendar.Date := dt;
  except
  end;

end;

procedure TPlannerDatePicker.CreateWnd;
begin
  inherited;
  InitEvents;
end;

function TPlannerDatePicker.GetParentEx: TWinControl;
begin
  Result := inherited Parent;
end;

procedure TPlannerDatePicker.SetParentEx(const Value: TWinControl);
begin
  inherited Parent := Value;
  InitEvents;
end;

function TPlannerDatePicker.GetOnWeekSelect: TNotifyEvent;
begin
  Result := FPlannerCalendar.OnWeekSelect;
end;

procedure TPlannerDatePicker.SetOnWeekSelect(const Value: TNotifyEvent);
begin
  FPlannerCalendar.OnWeekSelect := Value;
end;

function TPlannerDatePicker.GetOnAllDaySelect: TNotifyEvent;
begin
  Result := FPlannerCalendar.OnAllDaySelect;
end;

procedure TPlannerDatePicker.SetOnAllDaySelect(const Value: TNotifyEvent);
begin
  FPlannerCalendar.OnAllDaySelect := Value;
end;

function TPlannerDatePicker.GetDate: TDateTime;
begin
  Result := FPlannerCalendar.Date;
end;

procedure TPlannerDatePicker.SetDate(const Value: TDateTime);
begin
  FPlannerCalendar.Date := Value;
  Text := DateToStr(Value);
end;

initialization
  RegisterClass(TPlannerDatePicker);

end.
