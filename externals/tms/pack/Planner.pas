{$I TMSDEFS.INC}

{***********************************************************************}
{ TPlanner component                                                    }
{ for Delphi & C++Builder                                               }
{ version 1.7, June 2003                                                }
{                                                                       }
{ written by TMS Software                                               }
{            copyright © 1999-2003                                      }
{            Email: info@tmssoftware.com                                }
{            Web: http://www.tmssoftware.com                            }
{                                                                       }
{ The source code is given as is. The author is not responsible         }
{ for any possible damage done due to the use of this code.             }
{ The component can be freely used in any application. The complete     }
{ source code remains property of the author and may not be distributed,}
{ published, given or sold in any form as such. No parts of the source  }
{ code can be included in any other component or application without    }
{ written authorization of the author.                                  }
{***********************************************************************}



unit Planner;

{$IFDEF VER90}
{$DEFINE DELPHI2COLLECTION}
{$ENDIF}

{$IFDEF VER100}
{$DEFINE DELPHI2COLLECTION}
{$ENDIF}

{$DEFINE REMOVESTRIP}
{$DEFINE REMOVEDRAW}
{$DEFINE HILIGHT}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, Buttons, ComCtrls, Menus, Mask, RichEdit,
  Printers, ClipBrd, PlanUtil, PlanCheck, PlanXPVS, PlanHTML, PlanCombo,
  PictureContainer, ComObj
{$IFDEF DELPHI6_LVL}
  ,Variants
{$ENDIF}
  ;

const
{$IFDEF VER90}

  crSizeAll = crCross;
{$ENDIF}

  MAJ_VER = 1; // Major version nr.
  MIN_VER = 7; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 6; // Build nr.
  DATE_VER = 'June, 2003'; // Month version


var
  CF_PLANNERITEM: Word;


const
  crZoomIn = 100;
  crZoomOut = 101;

  EDITOFFSET = 4;

  NumColors = 288;

  MININDAY = 1440;

  // Values only applicable for Delphi 4, C++Builder 4
  MAX_COLS = 192;  // previous value 512 caused problems to run on ActiveForm
  MAX_ROWS = 288;  // previous value 512 caused problems to run on ActiveForm

  CORNER_EFFECT = 10;

{$IFDEF FREEWARE}
  COPYRIGHT = 'Printed by %s © 2003 by TMS software';
{$ENDIF}


type
  TCustomPlanner = class;

  TPlannerGrid = class;
  TPlannerItem = class;

  TPlannerBarItem = class;
  TPlannerBarItemList = class;

  EPlannerError = class(Exception);

  TItemEvent = procedure(Sender: TObject; Item: TPlannerItem) of object;

  TPlannerAnchorEvent = procedure(Sender: TObject; X,Y: Integer;
    Anchor:string) of object;

  TItemControlEvent = procedure(Sender: TObject; X,Y: Integer;
    Item: TPlannerItem; ControlID, ControlType, ControlValue:string) of object;

  TItemComboControlEvent = procedure(Sender: TObject; X,Y: Integer;
    Item: TPlannerItem; ControlID, ControlValue:string; ComboIdx: Integer;ComboObject: TObject) of object;

  TItemControlListEvent = procedure(Sender: TObject; Item: TPlannerItem;
    ControlID, ControlValue:string; var Edit:Boolean; Values: TStringList; var Dropheight: Integer) of object;

  TItemAnchorEvent = procedure(Sender: TObject; Item: TPlannerItem;
    Anchor: string) of object;

  TItemImageEvent = procedure(Sender: TObject; Item: TPlannerItem;
    ImageIndex: Integer) of object;

  TItemHintEvent = procedure(Sender: TObject; Item: TPlannerItem;
    var Hint: string) of object;

  TItemLinkEvent = procedure(Sender: TObject; Item: TPlannerItem;
    Link: string; var AutoHandle: Boolean) of object;

  TItemMoveEvent = procedure(Sender: TObject; Item: TPlannerItem;
    FromBegin, FromEnd, FromPos, ToBegin, ToEnd, ToPos: Integer) of object;

  TItemMovingEvent = procedure(Sender: TObject; Item: TPlannerItem;
    DeltaBegin, DeltaPos: Integer; var Allow: Boolean) of object;

  TItemUpdateEvent = procedure(Sender: TObject; Item: TPlannerItem;
    var NewBegin, NewEnd, NewPos: Integer) of object;

  TItemSizingEvent = procedure(Sender: TObject; Item: TPlannerItem;
    DeltaBegin, DeltaEnd: Integer; var Allow: Boolean) of object;

  TItemDragEvent = procedure(Sender: TObject; Item: TPlannerItem;
    var Allow: Boolean) of object;

  TItemClipboardAction = (itCut,itCopy,itPaste);

  TItemClipboardEvent = procedure(Sender: TObject; Item: TPlannerItem;
    Action: TItemClipboardAction; var Text: string) of object;

  TItemSizeEvent = procedure(Sender: TObject; Item: TPlannerItem;
    Position, FromBegin, FromEnd, ToBegin, ToEnd: Integer) of object;

  TItemPopupPrepareEvent = procedure(Sender: TObject; PopupMenu:TPopupMenu;
    Item: TPlannerItem) of object;

  TPlannerEvent = procedure(Sender: TObject;
    Position, FromSel, FromSelPrecise, ToSel, ToSelPrecise: Integer) of object;

  TPlannerKeyEvent = procedure(Sender: TObject; var Key: Char;
    Position, FromSel, FromSelPrecis, ToSel, ToSelPrecis: Integer) of object;

  TPlannerKeyDownEvent = procedure(Sender: TObject; var Key: Word; Shift: TShiftState;
    Position, FromSel, FromSelPrecis, ToSel, ToSelPrecis: Integer) of object;

  TPlannerItemDraw = procedure(Sender: TObject; PlannerItem: TPlannerItem;
    Canvas: TCanvas; Rect: TRect; Selected: Boolean) of object;

  TPlannerItemText = procedure(Sender: TObject; PlannerItem: TPlannerItem; var Text: string) of object;

  TPlannerSideDraw = procedure(Sender: TObject; Canvas: TCanvas; Rect: TRect;
    Index: Integer) of object;

  TPlannerBkgDraw = procedure(Sender: TObject; Canvas: TCanvas; Rect: TRect;
    Index, Position: Integer) of object;

  TPlannerHeaderDraw = procedure(Sender: TObject; Canvas: TCanvas;
    Rect: TRect; Index: Integer; var DoDraw: Boolean) of object;

  TPlannerCaptionDraw = procedure(Sender: TObject; Canvas: TCanvas;
    Rect: TRect; var DoDraw: Boolean) of object;

  TPlannerPlanTimeToStrings = procedure (Sender: TObject; MinutesValue: Cardinal;
    var HoursString, MinutesString, AmPmString: string) of object;

  TPlannerGetSideBarLines = procedure (Sender: TObject;
    Index, Position: Integer; var HourString, MinuteString, AmPmString: string) of object;

  TPlannerPrintEvent = procedure(Sender: TObject; Canvas: TCanvas) of object;

  TPlannerSelectCellEvent = procedure(Sender: TObject; Index, Pos: Integer;
    var CanSelect: Boolean) of object;

  TPlannerBottomLineEvent = procedure(Sender: TObject; Index, Pos: Integer;
    APen: TPen) of object;

  TGetCurrentTimeEvent = procedure(Sender: TObject;
    var CurrentTime: TDateTime) of object;

  TPlannerBtnEvent = procedure(Sender: TObject) of object;

  TSideBarPosition = (spLeft, spRight, spTop, spLeftRight);
  TSideBarOrientation = (soHorizontal, soVertical);

  TCustomEditEvent = procedure(Sender: TObject; R: TRect;
    Item: TPlannerItem) of object;

  TPlannerPositionToDay = procedure(Sender: TObject; Pos: Integer;
    var Day: TDateTime) of object;

  TPlannerPositionZoom = procedure(Sender: TObject; Pos: Integer; ZoomIn: Boolean) of object;

  TPlannerActiveEvent = procedure(Sender: TObject; Index, Position: Integer; var Active: Boolean) of object;

  TCustomITEvent = procedure(Sender: TObject; Index: Integer; var DT: TDateTime) of object;
  TCustomTIEvent = procedure(Sender: TObject; DT: TDateTime; var Index: Integer) of object;

  {TBands}

  TBands = class(TPersistent)
  private
    FOwner: TCustomPlanner;
    FShow: Boolean;
    FActivePrimary: TColor;
    FActiveSecondary: TColor;
    FNonActivePrimary: TColor;
    FNonActiveSecondary: TColor;
    procedure SetActivePrimary(const Value: TColor);
    procedure SetActiveSecondary(const Value: TColor);
    procedure SetNonActivePrimary(const Value: TColor);
    procedure SetNonActiveSecondary(const Value: TColor);
    procedure SetShow(const Value: Boolean);
  public
    constructor Create(AOwner:TCustomPlanner);
  published
    property Show: Boolean read FShow write SetShow default False;
    property ActivePrimary: TColor read FActivePrimary write SetActivePrimary;
    property ActiveSecondary: TColor read FActiveSecondary write SetActiveSecondary;
    property NonActivePrimary: TColor read FNonActivePrimary write SetNonActivePrimary;
    property NonActiveSecondary: TColor read FNonActiveSecondary write SetNonActiveSecondary;
  end;

  TAMPMPos = (apUnderTime,NextToTime);

  TPlannerSideBar = class(TPersistent)
  private
    FAlignment: TAlignment;
    FBackGround: TColor;
    FBackGroundTo: TColor;
    FFont: TFont;
    FOwner: TCustomPlanner;
    FVisible: Boolean;
    FWidth: Integer;
    FColOffset: Integer;
    FRowOffset: Integer;
    FPosition: TSideBarPosition;
    FShowInPositionGap: Boolean;
    FShowOccupied: Boolean;
    FFlat: Boolean;
    FOccupied: TColor;
    FOccupiedFontColor: TColor;
    FDateTimeFormat: string;
    FBorder: Boolean;
    FRotateOnTop: Boolean;
    FShowDayName: Boolean;
    FSeparatorLineColor: TColor;
    FAMPMPos: TAMPMPos;
    FActiveColor: TColor;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetBackground(const Value: TColor);
    procedure SetBackgroundTo(const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure FontChanged(Sender: TObject);
    procedure SetVisible(const Value: Boolean);
    procedure SetWidth(const Value: Integer);
    procedure SetPosition(const Value: TSideBarPosition);
    function GetOrientation: TSideBarOrientation;
    procedure SetShowInPositionGap(const Value: Boolean);
    procedure SetShowOccupied(const Value: Boolean);
    procedure SetFlat(const Value: Boolean);
    procedure SetOccupied(const Value: TColor);
    procedure SetOccupiedFontColor(const Value: TColor);
    procedure SetDateTimeFormat(const Value: string);
    procedure SetBorder(const Value: Boolean);
    procedure SetRotateOnTop(const Value: Boolean);
    procedure SetShowDayName(const Value: Boolean);
    procedure SetSeparatorLineColor(const Value: TColor);
    procedure SetAMPMPos(const Value: TAMPMPos);
    procedure SetActiveColor(const Value: TColor);
  public
    constructor Create(AOwner: TCustomPlanner);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Orientation: TSideBarOrientation read GetOrientation;
  protected
    procedure UpdateGrid;
  published
    property ActiveColor: TColor read FActiveColor write SetActiveColor;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property AMPMPos: TAMPMPos read FAMPMPos write SetAMPMPos;
    property Background: TColor read FBackGround write SetBackground;
    property BackgroundTo: TColor read FBackGroundTo write SetBackgroundTo;
    property Border: Boolean read FBorder write SetBorder default True;
    property DateTimeFormat: string read FDateTimeFormat write SetDateTimeFormat;
    property Flat: Boolean read FFlat write SetFlat default True;
    property Font: TFont read FFont write SetFont;
    property Occupied: TColor read FOccupied write SetOccupied;
    property OccupiedFontColor: TColor read FOccupiedFontColor write SetOccupiedFontColor;
    property Position: TSideBarPosition read FPosition write SetPosition;
    property RotateOnTop: Boolean read FRotateOnTop write SetRotateOnTop default True;
    property SeparatorLineColor: TColor read FSeparatorLineColor write SetSeparatorLineColor;
    property ShowInPositionGap: Boolean read FShowInPositionGap write SetShowInPositionGap;
    property ShowOccupied: Boolean read FShowOccupied write SetShowOccupied;
    property ShowDayName: Boolean read FShowDayName write SetShowDayName default True;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Integer read FWidth write SetWidth;
  end;

  TPlannerCaption = class(TPersistent)
  private
    FTitle: string;
    FAlignment: TAlignment;
    FBackGround: TColor;
    FBackgroundTo: TColor;
    FFont: TFont;
    FOwner: TCustomPlanner;
    FHeight: Integer;
    FVisible: Boolean;
    FBackgroundSteps: Integer;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetBackground(const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure SetTitle(const Value: string);
    procedure SetHeigth(const Value: Integer);
    procedure FontChanged(Sender: TObject);
    procedure SetVisible(const Value: Boolean);
    procedure SetBackgroundTo(const Value: TColor);
    procedure SetBackgroundSteps(const Value: Integer);              
  protected
    procedure UpdatePanel;
  public
    constructor Create(AOwner: TCustomPlanner);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Title: string read FTitle write SetTitle;
    property Font: TFont read FFont write SetFont;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property Background: TColor read FBackGround write SetBackground;
    property BackgroundSteps: Integer read FBackgroundSteps write SetBackgroundSteps;
    property BackgroundTo: TColor read FBackgroundTo write SetBackgroundTo default clNone;
    property Height: Integer read FHeight write SetHeigth;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TPlannerType = (plDay, plWeek, plMonth, plDayPeriod, plHalfDayPeriod, plMultiMonth,
    plCustom, plTimeLine, plCustomList);

  TPlannerPanel = class(TPanel)
  private
    FOldAnchor: string;
    function IsAnchor(x,y: Integer): string;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  end;

  TPlannerMode = class(TPersistent)
  private
    FClip: Boolean;
    FOwner: TCustomPlanner;
    FPlannerType: TPlannerType;
    FWeekStart: Integer;
    FYear: Integer;
    FMonth: Integer;
    FDateTimeFormat: string;
    FPeriodStartDay: Integer;
    FPeriodStartMonth: Integer;
    FPeriodStartYear: Integer;
    FPeriodEndDay: Integer;
    FPeriodEndMonth: Integer;
    FPeriodEndYear: Integer;
    FUpdateCount: Integer;
    FTimeLineStart: TDateTime;
    procedure SetMonth(const Value: Integer);
    procedure SetPlannerType(const Value: TPlannerType);
    procedure SetWeekStart(const Value: Integer);
    procedure SetYear(const Value: Integer);
    procedure SetDateTimeFormat(const Value: string);
    procedure SetPeriodStartDay(const Value: Integer);
    procedure SetPeriodStartMonth(const Value: Integer);
    procedure SetPeriodStartYear(const Value: Integer);
    procedure SetPeriodEndDay(const Value: Integer);
    procedure SetPeriodEndMonth(const Value: Integer);
    procedure SetPeriodEndYear(const Value: Integer);
    function GetPeriodEndDate: TDateTime;
    function GetPeriodStartDate: TDateTime;
    function GetStartOfMonth: TDateTime;
    procedure UpdatePeriod;
    procedure SetPeriodEndDate(const Value: TDateTime);
    procedure SetPeriodStartDate(const Value: TDateTime);
    procedure SetTimeLineStart(const Value: TDateTime);
  public
    constructor Create(AOwner: TCustomPlanner);
    destructor Destroy; override;
    property PeriodStartDate: TDateTime read GetPeriodStartDate write SetPeriodStartDate;
    property PeriodEndDate: TDateTime read GetPeriodEndDate write SetPeriodEndDate;
    property StartOfMonth: TDateTime read GetStartOfMonth;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Assign(Source: TPersistent); override;
  published
    property Clip: Boolean read FClip write FClip;
    property DateTimeFormat: string read FDateTimeFormat write SetDateTimeFormat;
    property Month: Integer read FMonth write SetMonth;
    property PeriodStartDay: Integer read FPeriodStartDay write SetPeriodStartDay;
    property PeriodStartMonth: Integer read FPeriodStartMonth write SetPeriodStartMonth;
    property PeriodStartYear: Integer read FPeriodStartYear write SetPeriodStartYear;
    property PeriodEndDay: Integer read FPeriodEndDay write SetPeriodEndDay;
    property PeriodEndMonth: Integer read FPeriodEndMonth write SetPeriodEndMonth;
    property PeriodEndYear: Integer read FPeriodEndYear write SetPeriodEndYear;
    property PlannerType: TPlannerType read FPlannerType write SetPlannerType;
    property TimeLineStart: TDateTime read FTimeLineStart write SetTimeLineStart;
    property WeekStart: Integer read FWeekStart write SetWeekStart;
    property Year: Integer read FYear write SetYear;
  end;

  TPlannerMaskEdit = class(TMaskEdit)
  private
    FPlannerItem: TPlannerItem;
    procedure WMPaste(var Msg:TMessage); message WM_PASTE;
    procedure WMCopy(var Msg:TMessage); message WM_COPY;
    procedure WMCut(var Msg:TMessage); message WM_CUT;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoExit; override;
  public
  published
    property PlannerItem: TPlannerItem read FPlannerItem write FPlannerItem;
  end;

  TPlannerMemo = class(TMemo)
  private
    FPlannerItem: TPlannerItem;
    FPlanner: TCustomPlanner;
    procedure WMPaste(var Msg:TMessage); message WM_PASTE;
    procedure WMCopy(var Msg:TMessage); message WM_COPY;
    procedure WMCut(var Msg:TMessage); message WM_CUT;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DblClick; override;
  public
  published
    property PlannerItem: TPlannerItem read FPlannerItem write FPlannerItem;
    property Planner: TCustomPlanner read FPlanner write FPlanner;
  end;

  TPlannerRichEdit = class(TRichEdit)
  private
    FPlannerItem: TPlannerItem;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
    procedure DoExit; override;
  published
    property PlannerItem: TPlannerItem read FPlannerItem write FPlannerItem;
  end;

  TPlannerDisplay = class(TPersistent)
  private
    FOwner: TCustomPlanner;
    FDisplayStart: Integer;
    FDisplayScale: Integer;
    FDisplayEnd: Integer;
    FDisplayUnit: Integer;
    FActiveEnd: Integer;
    FActiveStart: Integer;
    FColorNonActive: TColor;
    FColorActive: TColor;
    FColorCurrent: TColor;
    FColorCurrentItem: TColor;
    FActiveStartPrecis: Integer;
    FActiveEndPrecis: Integer;
    FDisplayStartPrecis: Integer;
    FDisplayEndPrecis: Integer;
    FShowCurrent: Boolean;
    FShowCurrentItem: Boolean;
    FScaleToFit: Boolean;
    FOldScale: Integer;
    FDisplayOffset: Integer;
    FUpdateCount: Integer;
    FUpdateUnit: Boolean;
    FDisplayText: Integer;
    FCurrentPosFrom: Integer;
    FCurrentPosTo: Integer;    
    procedure SetDisplayStart(const Value: Integer);
    procedure SetDisplayEnd(const Value: Integer);
    procedure SetDisplayScale(const Value: Integer);
    procedure SetDisplayUnit(const Value: Integer);
    procedure SetDisplayOffset(const Value: Integer);    
    procedure UpdatePlanner;
    procedure SetActiveEnd(const Value: Integer);
    procedure SetActiveStart(const Value: Integer);
    procedure SetColorActive(const Value: TColor);
    procedure SetColorNonActive(const Value: TColor);
    procedure SetColorCurrent(const Value: TColor);
    procedure SetShowCurrent(const Value: Boolean);
    procedure SetColorCurrentItem(const Value: TColor);
    procedure SetShowCurrentItem(const Value: Boolean);
    procedure SetScaleToFit(const Value: Boolean);
    procedure SetDisplayText(const Value: Integer);
    procedure SetCurrentPosFrom(const Value: Integer);
    procedure SetCurrentPosTo(const Value: Integer);    
  protected
    procedure InitPrecis;
    procedure AutoScale;
  public
    constructor Create(AOwner: TCustomPlanner);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
  published
    property ActiveStart: Integer read FActiveStart write SetActiveStart;
    property ActiveEnd: Integer read FActiveEnd write SetActiveEnd;
    property CurrentPosFrom: Integer read FCurrentPosFrom write SetCurrentPosFrom;
    property CurrentPosTo: Integer read FCurrentPosTo write SetCurrentPosTo;    
    property DisplayStart: Integer read FDisplayStart write SetDisplayStart;
    property DisplayEnd: Integer read FDisplayEnd write SetDisplayEnd;
    property DisplayOffset: Integer read FDisplayOffset write SetDisplayOffset;
    property DisplayScale: Integer read FDisplayScale write SetDisplayScale;
    property DisplayUnit: Integer read FDisplayUnit write SetDisplayUnit;
    property DisplayText: Integer read FDisplayText write SetDisplayText;
    property ColorActive: TColor read FColorActive write SetColorActive;
    property ColorNonActive: TColor read FColorNonActive write SetColorNonActive;
    property ColorCurrent: TColor read FColorCurrent write SetColorCurrent;
    property ColorCurrentItem: TColor read FColorCurrentItem write SetColorCurrentItem;
    property ScaleToFit: Boolean read FScaleToFit write SetScaleToFit;
    property ShowCurrent: Boolean read FShowCurrent write SetShowCurrent;
    property ShowCurrentItem: Boolean read FShowCurrentItem write SetShowCurrentItem;
  end;

  TNavigatorButtons = class(TPersistent)
  private
    FOwner: TCustomPlanner;
    FVisible: Boolean;
    FShowHint: Boolean;
    FNextHint: string;
    FPrevHint: string;
    FFlat: Boolean;
    procedure SetVisible(Value: Boolean);
    procedure SetNextHint(const Value: string);
    procedure SetPrevHint(const Value: string);
    procedure SetShowHint(const Value: Boolean);
    procedure SetFlat(const Value: Boolean);
  public
    constructor Create(AOwner: TCustomPlanner);
  published
    property Flat: Boolean read FFlat write SetFlat default True;
    property Visible: Boolean read FVisible write SetVisible default True;
    property PrevHint: string read FPrevHint write SetPrevHint;
    property NextHint: string read FNextHint write SetNextHint;
    property ShowHint: Boolean read FShowHint write SetShowHint;
  end;

  TImagePosition = (ipLeft, ipRight);

  TPlannerHeader = class(TPersistent)
  private
    FOwner: TCustomPlanner;
    FCaptions: TStringList;
    FVisible: Boolean;
    FHeight: Integer;
    FFont: TFont;
    FColor: TColor;
    FFlat: Boolean;
    FAlignment: TAlignment;
    FVAlignment: TVAlignment;
    FImages: TImageList;
    FImagePosition: TImagePosition;
    FReadOnly: Boolean;
    FItemHeight: Integer;
    FTextHeight: Integer;
    FAllowResize: Boolean;
    FAutoSize: Boolean;
    FItemColor: TColor;
    FGroupCaptions: TStringList;
    FPopupMenu: TPopupMenu;
    FLineColor: TColor;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetCaptions(const Value: TStringList);
    function GetDragDrop: Boolean;
    procedure SetDragDrop(const Value: Boolean);
    procedure SetHeight(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetColor(const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure FontChanged(Sender: TObject);
    procedure ItemsChanged(Sender: TObject);
    procedure SetImages(const Value: TImageList);
    procedure SetImagePosition(const Value: TImagePosition);
    procedure SetFlat(const Value: Boolean);
    procedure SetVAlignment(const Value: TVAlignment);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetItemHeight(const Value: Integer);
    procedure SetTextHeight(const Value: Integer);
    procedure SetAllowResize(const Value: Boolean);
    procedure SetAutoSize(const Value: Boolean);
    procedure SetItemColor(const Value: TColor);
    procedure SetGroupCaptions(const Value: TStringList);
    procedure SetLineColor(const Value: TColor);
    procedure UpdateHeights;
  public
    constructor Create(AOwner: TCustomPlanner);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure MergeHeader(FromSection,ToSection: Integer);
    procedure UnMergeHeader(FromSection,ToSection: Integer);
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property AllowResize: Boolean read FAllowResize write SetAllowResize default False;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Captions: TStringList read FCaptions write SetCaptions;
    property Color: TColor read FColor write SetColor;
    property DragDrop: Boolean read GetDragDrop write SetDragDrop default False;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default True;
    property Height: Integer read FHeight write SetHeight;
    property Flat: Boolean read FFlat write SetFlat default False;
    property Font: TFont read FFont write SetFont;
    property GroupCaptions: TStringList read FGroupCaptions write SetGroupCaptions;
    property Images: TImageList read FImages write SetImages;
    property ImagePosition: TImagePosition read FImagePosition write SetImagePosition;
    property ItemColor: TColor read FItemColor write SetItemColor;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property LineColor: TColor read FLineColor write SetLineColor;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property TextHeight: Integer read FTextHeight write SetTextHeight;
    property VAlignment: TVAlignment read FVAlignment write SetVAlignment;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TCaptionType = (ctNone, ctText, ctTime, ctTimeText);

  TImageChangeEvent = procedure(Sender: TObject) of object;

  TPlannerIntList = class(TList)
  private
    FOnChange: TImageChangeEvent;
    FPlannerItem: TPlannerItem;
    procedure SetInteger(Index: Integer; Value: Integer);
    function GetInteger(Index: Integer): Integer;
  public
    constructor Create(Value: TPlannerItem);
    property Items[Index: Integer]: Integer read GetInteger write SetInteger;
    default;
    procedure Add(Value: Integer);
    procedure Delete(Index: Integer);
    {$IFDEF DELPHI4_LVL}
    procedure Clear; override;
    {$ELSE}
    procedure Clear;
    {$ENDIF}
  published
    property OnChange: TImageChangeEvent read FOnChange write FOnChange;
  end;

  TPlannerItemEdit = (peMemo, peEdit, peMaskEdit, peRichText, peCustom
    , peForm
  );

  TPlannerLinkType = (ltLinkFull, ltLinkBeginEnd, ltLinkEndBegin, ltLinkEndEnd,
    ltLinkBeginBegin);

  TPlannerShape = (psRect, psRounded, psHexagon, psTool);

  TFindTextParameter = (fnMatchCase,fnMatchFull,fnMatchRegular,fnMatchStart,
    fnAutoGoto,fnIgnoreHTMLTags,fnBackward,fnCaptionText,fnText);

  TFindTextParams = set of TFindTextParameter;

  TAlarmNotifyType = (anCaption,anNotes,anMessage);

  TCompletionDisplay = (cdNone, cdVertical, cdHorizontal);

  TPlannerBarItem = class( TPersistent)
  private
    FBegin: Integer;
    FEnd: Integer;
    FColor: TColor;
    FStyle: TBrushStyle;
    FOnDestroy: TNotifyEvent;
    FOwner: TPlannerBarItemList;
    function GetEndTime: TDateTime;
    function GetStartTime: TDateTime;
    procedure SetEndTime( const pEndTime: TDateTime);
    procedure SetStartTime( const pStartTime: TDateTime);
    function CheckOwners: Boolean;
  public
    constructor create( pOwner: TPlannerBarItemList);
    destructor destroy; override;
  published
    property BarColor: TColor read FColor write FColor;
    property BarBegin: Integer read FBegin write FBegin;
    property BarEnd: Integer read FEnd write FEnd;
    property BarStyle: TBrushStyle read FStyle write FStyle;
    property Owner: TPlannerBarItemList read FOwner;
    property EndTime: TDateTime read getEndTime write setEndTime;
    property StartTime: TDateTime read getStartTime write setStartTime;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

  TPlannerBarItemList = class(TList)
  private
    FOwner: TPlannerItem;
    function GetItem(Index: Integer): TPlannerBarItem;
  public
    function AddItem(pStart,pEnd: TDateTime; pColor: TColor; pStyle: TBrushStyle): Integer;
    constructor Create(AOwner: TPlannerItem);
    destructor Destroy; override;
    property Items[Index: Integer]: TPlannerBarItem read GetItem; default;
    property Owner: TPlannerItem read FOwner write FOwner;
  published
  end;

  TPlannerAlarmHandler = class(TComponent)
  public
    function HandleAlarm(Address,Message:string; Tag, ID: Integer;
      Item: TPlannerItem): Boolean; virtual;
  end;

  TAlarmMessage = class(TPlannerAlarmHandler)
  public
    function HandleAlarm(Address,Message:string; Tag, ID: Integer;
      Item: TPlannerItem): Boolean; override;
  end;

  TAlarmTime = (atBefore,atAfter,atBoth);

  TPlannerAlarm = class(TPersistent)
  private
    FActive: Boolean;
    FTag: Integer;
    FID: Integer;
    FAddress: string;
    FMessage: string;
    FNotifyType: TAlarmNotifyType;
    FTimeBefore: TDateTime;
    FTimeAfter: TDateTime;
    FHandler: TPlannerAlarmHandler;
    FTime: TAlarmTime;
  protected
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Active: Boolean read FActive write FActive;
    property Address: string read FAddress write FAddress;
    property Handler: TPlannerAlarmHandler read FHandler write FHandler;
    property ID: Integer read FID write FID;
    property Message: string read FMessage write FMessage;
    property NotifyType: TAlarmNotifyType read FNotifyType write FNotifyType;
    property Tag: Integer read FTag write FTag;
    property Time: TAlarmTime read FTime write FTime;
    property TimeBefore: TDateTime read FTimeBefore write FTimeBefore;
    property TimeAfter: TDateTime read FTimeAfter write FTimeAfter;    
  end;

  TItemRelationShip = (irParent,irChild);

  TEditorUse = (euAlways, euDblClick);

  TEditDoneEvent = procedure (Sender: TObject; ModalResult: TModalResult) of object;

  TCustomItemEditor = class(TComponent)
  private
    //FEditItem: TPlannerItem;
    FPlanner: TCustomPlanner;
    FCaption: string;
    FEditorUse: TEditorUse;
    FOnEditDone: TEditDoneEvent;
    FModalResult: TModalResult;
    procedure Edit(APlanner: TCustomPlanner;APlannerItem: TPlannerItem);
  protected
  public
    function QueryEdit(APlannerItem: TPlannerItem): Boolean; virtual;
    procedure CreateEditor(AOwner: TComponent); virtual;
    procedure DestroyEditor; virtual;
    function Execute: Integer; virtual;
    procedure PlannerItemToEdit(APlannerItem: TPlannerItem); virtual;
    procedure EditToPlannerItem(APlannerItem: TPlannerItem); virtual;
    property Planner: TCustomPlanner read FPlanner;
    property ModalResult: TModalResult read FModalResult write FModalResult;
  published
    property Caption: string read FCaption write FCaption;
    property EditorUse: TEditorUse read FEditorUse write FEditorUse;
    property OnEditDone: TEditDoneEvent read FOnEditDone write FOnEditDone;
  end;

  TCustomItemDrawTool = class(TComponent)
  private
  public
    procedure DrawItem(PlannerItem: TPlannerItem; Canvas: TCanvas; Rect: TRect;
      Selected,Print: Boolean); virtual;
  end;

  TSelectButton = (sbLeft, sbRight, sbBoth);

  TPlannerItemSelection = class(TPersistent)
  private
    FAutoUnSelect: Boolean;
    FButton: TSelectButton;

  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property AutoUnSelect: Boolean read FAutoUnSelect write FAutoUnSelect;
    property Button: TSelectButton read FButton write FButton;
  end;

  TPlannerItem = class(TCollectionItem)
  private
    FAlarm: TPlannerAlarm;
    FBarItems: TPlannerBarItemList;
    FTag: Integer;
    FId: Integer;
    FObject: TObject;
    FAlignment: TAlignment;
    FAttachement: string;
    FCaptionType: TCaptionType;
    FCaptionText: string;
    FEditMask: string;
    FText: TStringList;
    FInplaceEdit: TPlannerItemEdit;
    FItemBegin: Integer;
    FItemEnd: Integer;
    FItemBeginPrecis: Integer;
    FItemEndPrecis: Integer;
    FItemFullBegin: Integer;
    FImageID: Integer;
    FInHeader: Boolean;
    FColor: TColor;
    FFixedPos: Boolean;
    FFixedSize: Boolean;
    FFixedPosition: Boolean;
    FReadOnly: Boolean;
    FPlanner: TCustomPlanner;
    FItemPos: Integer;
    FConflicts: Integer;
    FConflictPos: Integer;
    FVisible: Boolean;
    FFocus: Boolean;
    FName: string;
    FOnEditModal: TNotifyEvent; 
    FLayer: Integer;
    FTrackColor: TColor;
    FTrackVisible: Boolean;
    FHint: string;
    FImageIndexList: TPlannerIntList;
    FItemStartTime: TDateTime;
    FItemEndTime: TDateTime;
    FItemRealStartTime: TDateTime;
    FItemRealEndTime: TDateTime;
    FAllowOverlap: Boolean;
    FBackGround: Boolean;
    FFont: TFont;
    FLinkedItem: TPlannerItem;
    FLinkType: TPlannerLinkType;
    FIsCurrent: Boolean;
    FBrushStyle: TBrushStyle;
    FCaptionAlign: TAlignment;
    FCaptionBkg: TColor;
    FCaptionBkgTo: TColor;
    FCaptionFont: TFont;
    FCaptionHeight: Integer;
    FSelected: Boolean;
    FSelectColor: TColor;
    FOwnsItemObject: Boolean;
    FRepainted: Boolean;
    FShape: TPlannerShape;
    FBeginExt: Integer;
    FEndExt: Integer;
    FPopupMenu: TPopupMenu;
    FShowSelection: Boolean;
    FDBTag: Integer;
    FDBKey: string;
    FSynched: Boolean;
    FWordWrap: Boolean;
    FURL: string;
    FEndOffset: Integer;
    FBeginOffset: Integer;
    FChanged: Boolean;
    FDoExport: Boolean;
    FRealTime: Boolean;
    FFlashOn: Boolean;
    FFlashing: Boolean;
    FUniformBkg: Boolean;
    FParentIndex: Integer;
    FCursor: TCursor;
    FClipped: Boolean;
    FRelationShip: TItemRelationShip;
    FNonDBItem: Boolean;
    FShadow: Boolean;
    FTransparent: Boolean;
    FSelectFontColor: TColor;
    FEditor: TCustomItemEditor;
    FPopupEdit: Boolean;
    FDrawTool: TCustomItemDrawTool;
    FCompletion: Integer;
    FCompletionDisplay: TCompletionDisplay;
    procedure SetColor(const Value: TColor);
    procedure SetTrackColor(const Value: TColor);
    procedure SetLayer(const Value: Integer);
    procedure SetItemEnd(const Value: Integer);
    procedure SetItemBegin(const Value: Integer);
    procedure SetText(const Value: TStringList);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetAllowOverlap(const Value: Boolean);
    procedure SetCaptionType(const Value: TCaptionType);
    procedure SetCaptionText(const Value: string);
    procedure SetImageID(const Value: Integer);
    procedure SetItemPos(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    function GetVisible: Boolean;
    procedure SetFocus(const Value: Boolean);
    procedure SetFont(const Value: TFont);
    procedure SetBackground(const Value: Boolean);
    procedure ReOrganize;
    procedure Repaint;
    procedure FontChange(Sender: TObject);
    procedure ImageChange(Sender: TObject);
    procedure TextChange(Sender: TObject);
    procedure SetItemEndTime(const Value: TDateTime);
    procedure SetItemStartTime(const Value: TDateTime);
    function GetItemEndTime: TDateTime;
    function GetItemStartTime: TDateTime;
    function GetItemEndTimeStr: string;
    function GetItemStartTimeStr: string;
    function GetItemSpanTimeStr: string;
    procedure SetIsCurrent(const Value: Boolean);
    procedure SetItemRealEndTime(const Value: TDateTime);
    procedure SetItemRealStartTime(const Value: TDateTime);
    procedure SetBrusStyle(const Value: TBrushStyle);
    procedure SetCaptionAlign(const Value: TAlignment);
    procedure SetCaptionBkg(const Value: TColor);
    procedure SetCaptionBkgTo(const Value: TColor);
    procedure SetCaptionFont(const Value: TFont);
    procedure SetSelectColor(const Value: TColor);
    procedure SetSelected(const Value: Boolean);
    procedure SetShadow(const Value: Boolean);
    procedure SetObject(const Value: TObject);
    procedure SetInHeader(const Value: Boolean);
    procedure SetItemBeginPrecis(const Value: Integer);
    procedure SetItemEndPrecis(const Value: Integer);
    procedure SetTrackVisible(const Value: Boolean);
    procedure SetShape(const Value: TPlannerShape);
    procedure SetPopupMenu(const Value: TPopupMenu);
    procedure SetShowSelection(const Value: Boolean);
    procedure SetTimeTag;
    procedure GetTimeTag;
    function GetItemText: string;
    procedure SetWordWrap(const Value: Boolean);
    procedure SetAttachement(const Value: string);
    function GetItemRealEndTime: TDateTime;
    function GetItemRealStartTime: TDateTime;
    procedure SetURL(const Value: string);
    procedure SetAlarm(const Value: TPlannerAlarm);
    function GetStrippedItemText: string;
    procedure SetFlashing(const Value: Boolean);
    function GetParentItem: TPlannerItem;
    function GetCanEdit: Boolean;
    procedure SetSelectFontColor(const Value: TColor);
    procedure SetDrawTool(const Value: TCustomItemDrawTool);
    procedure SetCompletion(const Value: Integer);
    procedure SetCompletionDisplay(const Value: TCompletionDisplay);
    procedure CompletionAdapt(var R:TRect);
  protected
{$IFNDEF VER90}
    function GetDisplayName: string; override;
{$ENDIF VER90}
    procedure UpdateWnd;
    procedure CalcConflictRect(var Rect: TRect; Width, Height: Integer;
      Position: Boolean);
    property IsCurrent: Boolean read FIsCurrent write SetIsCurrent;
    function GetCaptionHeight: Integer;
    function GetGridRect: TRect;
    function GetItemRect: TRect;
    function GetVisibleSpan: Integer;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignEx(Source: TPersistent);
    function Planner: TCustomPlanner; virtual;
    procedure Changed; virtual;
    procedure ScrollInView;
    procedure EnsureFullVisibility;
    procedure Edit;
    procedure PopupEdit;
    procedure MoveItem(NewBegin,NewEnd,NewPos: Integer; var NewOffset: Integer);
    procedure SizeItem(NewBegin,NewEnd: Integer);
    procedure DefOrganize;
    procedure Update;
    procedure ChangeCrossing;
    function SetValue(ID,Value:string): Boolean;
    function GetValue(ID:string;var Value:string): Boolean;
    function GetCaptionTimeString: string; virtual;
    function GetCaptionString: string;
    property ItemObject: TObject read FObject write SetObject;
    property ID: Integer read FId write FId;
    property BeginOffset: Integer read FBeginOffset write FBeginOffset;
    property EndOffset: Integer read FEndOffset write FEndOffset;
    property Clipped: Boolean read FClipped;
    property Conflicts: Integer read FConflicts;
    property ConflictPos: Integer read FConflictPos;
    property Focus: Boolean read FFocus write SetFocus;
    property ImageIndexList: TPlannerIntList read FImageIndexList write FImageIndexList;
    property ItemBeginPrecis: Integer read FItemBeginPrecis write SetItemBeginPrecis;
    property ItemEndPrecis: Integer read FItemEndPrecis write SetItemEndPrecis;
    property ItemStartTime: TDateTime read GetItemStartTime write SetItemStartTime;
    property ItemEndTime: TDateTime read GetItemEndTime write SetItemEndTime;
    property ItemRealStartTime: TDateTime read GetItemRealStartTime write SetItemRealStartTime;
    property ItemRealEndTime: TDateTime read GetItemRealEndTime write SetItemRealEndTime;
    property ItemStartTimeStr: string read GetItemStartTimeStr;
    property ItemEndTimeStr: string read GetItemEndTimeStr;
    property ItemSpanTimeStr: string read GetItemSpanTimeStr;
    property ItemText: string read GetItemText;
    property StrippedItemText: string read GetStrippedItemText;
    property LinkedItem: TPlannerItem read FLinkedItem write FLinkedItem;
    property LinkType: TPlannerLinkType read FLinkType write FLinkType;
    property Owner: TCustomPlanner read FPlanner;
    property Repainted: Boolean read FRepainted write FRepainted;
    property DBKey: string read FDBKey write FDBKey;
    property Synched: Boolean read FSynched write FSynched;
    property DoExport: Boolean read FDoExport write FDoExport;
    property RealTime: Boolean read FRealTime write FRealTime;
    property Flashing: Boolean read FFlashing write SetFlashing;
    property FlashOn: Boolean read FFlashOn write FFlashOn;
    property ParentItem: TPlannerItem read GetParentItem;
    property ParentIndex: Integer read FParentIndex write FParentIndex;
    property RelationShip: TItemRelationShip read FRelationShip write FRelationShip;
    property BarItems: TPlannerBarItemList read FBarItems write FBarItems;
    property NotEditable: Boolean read GetCanEdit;
    property NonDBItem: Boolean read FNonDBItem write FNonDBItem;
    property Transparent: Boolean read FTransparent write FTransparent;
    property ItemRect: TRect read GetItemRect;
  published
    property Alarm: TPlannerAlarm read FAlarm write SetAlarm;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property AllowOverlap: Boolean read FAllowOverlap write SetAllowOverlap;
    property Attachement: string read FAttachement write SetAttachement;
    property Background: Boolean read FBackGround write SetBackground;
    property BrushStyle: TBrushStyle read FBrushStyle write SetBrusStyle;
    property CaptionAlign: TAlignment read FCaptionAlign write SetCaptionAlign;
    property CaptionBkg: TColor read FCaptionBkg write SetCaptionBkg;
    property CaptionBkgTo: TColor read FCaptionBkgTo write SetCaptionBkgTo default clNone;    
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property CaptionType: TCaptionType read FCaptionType write SetCaptionType;
    property CaptionText: string read FCaptionText write SetCaptionText;
    property Color: TColor read FColor write SetColor;
    property Completion: Integer read FCompletion write SetCompletion;
    property CompletionDisplay: TCompletionDisplay read FCompletionDisplay write SetCompletionDisplay;
    property Cursor: TCursor read FCursor write FCursor;
    property DBTag: Integer read FDBTag write FDBTag;
    property DrawTool: TCustomItemDrawTool read FDrawTool write SetDrawTool;
    property EditMask: string read FEditMask write FEditMask;
    property Editor: TCustomItemEditor read FEditor write FEditor;
    property FixedPos: Boolean read FFixedPos write FFixedPos;
    property FixedPosition: Boolean read FFixedPosition write FFixedPosition;
    property FixedSize: Boolean read FFixedSize write FFixedSize;
    property Font: TFont read FFont write SetFont;
    property Hint: string read FHint write FHint;    
    property ImageID: Integer read FImageID write SetImageID;
    property InHeader: Boolean read FInHeader write SetInHeader;
    property InplaceEdit: TPlannerItemEdit read FInplaceEdit write FInplaceEdit;
    property ItemBegin: Integer read FItemBegin write SetItemBegin;
    property ItemEnd: Integer read FItemEnd write SetItemEnd;
    property ItemPos: Integer read FItemPos write SetItemPos;
    property Layer: Integer read FLayer write SetLayer;
    property Name: string read FName write FName;
    property OnEditModal: TNotifyEvent read FOnEditModal write FOnEditModal; //##jpl
    property OwnsItemObject: Boolean read FOwnsItemObject write FOwnsItemObject;
    property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property Shape: TPlannerShape read FShape write SetShape default psRect;
    property SelectColor: TColor read FSelectColor write SetSelectColor;
    property SelectFontColor: TColor read FSelectFontColor write SetSelectFontColor;
    property Selected: Boolean read FSelected write SetSelected;
    property Shadow: Boolean read FShadow write SetShadow;
    property ShowSelection: Boolean read FShowSelection write SetShowSelection default True;
    property Tag: Integer read FTag write FTag;
    property Text: TStringList read FText write SetText;
    property TrackColor: TColor read FTrackColor write SetTrackColor;
    property TrackVisible: Boolean read FTrackVisible write SetTrackVisible default True;
    property UniformBkg: Boolean read FUniformBkg write FUniformBkg default True;
    property URL: string read FURL write SetURL;
    property Visible: Boolean read GetVisible write SetVisible default True;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default True;
  end;

  TPlannerItems = class(TCollection)
  private
    FOwner: TCustomPlanner;
    FSelected: TPlannerItem;
    FDBItem: TPlannerItem;
    FUpdateCount: Integer;
    FFindIndex: Integer;
    FChanging: Boolean;
    function GetItem(Index: Integer): TPlannerItem;
    procedure SetItem(Index: Integer; Value: TPlannerItem);
    function NumConflicts(var ItemBegin, ItemEnd: Integer; ItemPos: Integer): Integer;
    function GetSelCount: Integer;
  protected
{$IFNDEF VER90}
    function GetOwner: TPersistent; override;
{$ENDIF}
    procedure ClearSelectedRepaints(ItemBegin,ItemPos: Integer);
    function NumItem(ItemBegin, ItemEnd, ItemPos: Integer): TPoint;
    function NumItemPos(ItemBegin, ItemEnd, ItemPos: Integer): TPoint;
    function NumItemPosStart(ItemBegin, ItemPos: Integer): Integer;
    function FindItem(ItemBegin, ItemPos: Integer): TPlannerItem;
    function FindItemIdx(ItemBegin: Integer): TPlannerItem;
    function FindItemPos(ItemBegin, ItemPos, ItemSubPos: Integer): TPlannerItem;
    function FindBkgPos(ItemBegin, ItemPos, ItemSubPos: Integer): TPlannerItem;    
    function FindItemPosIdx(
      ItemBegin, ItemPos, ItemSubPos: Integer): TPlannerItem;
    function FindItemIndex(
      ItemBegin, ItemPos, ItemSubIdx: Integer): TPlannerItem;
    function FindBackground(ItemBegin, ItemPos: Integer): TPlannerItem;
    function QueryItem(Item: TPlannerItem;
      ItemBegin, ItemPos: Integer): TPlannerItem;
    function FocusItem(ItemBegin, ItemPos, ItemSubPos: Integer;
      Control: Boolean): TPlannerItem;
    procedure SetCurrent(ItemCurrent: Integer);
    procedure PasteItem(Position: Boolean);
    procedure ClearRepaints;
    procedure SetTimeTags;
    procedure GetTimeTags;
    function MatchItem(Item:TPlannerItem; s:string; Param:TFindTextParams): Boolean;
    function MaxItemsInPos(Position: Integer):Integer;    
  public
    function GetItemClass: TCollectionItemClass; virtual;
    constructor Create(AOwner: TCustomPlanner);
    function CheckItems: Boolean;
    function CheckPosition(Position: Integer): Boolean;
    function CheckLayer(Layer: Integer): Boolean;
    function CheckItem(Item: TPlannerItem): Boolean;
    function HasItem(ItemBegin, ItemEnd, ItemPos: Integer): Boolean;
    function FindFirst(ItemBegin, ItemEnd, ItemPos: Integer): TPlannerItem;
    function FindNext(ItemBegin, ItemEnd, ItemPos: Integer): TPlannerItem;
    function FindKey(DBKey: string): TPlannerItem;
    function HeaderFirst(ItemPos: Integer): TPlannerItem;
    function HeaderNext(ItemPos: Integer): TPlannerItem;
    function FindText(StartItem:TPlannerItem;s: string; Param: TFindTextParams):TPlannerItem;
    function Add: TPlannerItem;
    function Insert(Index: Integer): TPlannerItem;
    property Items[Index: Integer]: TPlannerItem read GetItem write SetItem; default;
    function SelectNext: TPlannerItem;
    function SelectPrev: TPlannerItem;
    procedure UnSelect;
    procedure UnSelectAll;
    procedure Select(Item: TPlannerItem);
    property Selected: TPlannerItem read FSelected write FSelected;
    property DBItem: TPlannerItem read FDBItem write FDBItem;
    function InVisibleLayer(Layer: Integer): Boolean;
    procedure ClearConflicts;
    procedure SetConflicts;
    procedure ItemChanged(Item: TPlannerItem);
    function ItemsAtPosition(Pos: Integer): Integer;
    function ItemsAtIndex(Idx: Integer): Integer;
    procedure BeginUpdate;
{$IFDEF DELPHI4_LVL} override;
{$ENDIF}
    procedure EndUpdate;
{$IFDEF DELPHI4_LVL} override;
{$ENDIF}
    procedure ResetUpdate;
    procedure ClearPosition(Position: Integer);
    procedure ClearLayer(Layer: Integer);
    procedure ClearAll;
    procedure ClearDB;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure PasteFromClipboard;
    procedure PasteFromClipboardAtPos;
    procedure OffsetItems(Offset: Integer);
    procedure MoveAll(DeltaPos, DeltaBegin: Integer);
    procedure MoveSelected(DeltaPos, DeltaBegin: Integer);
    procedure SizeAll(DeltaStart, DeltaEnd: Integer);
    procedure SizeSelected(DeltaStart, DeltaEnd: Integer);
    property Changing: Boolean read FChanging write FChanging;
  published
    property SelCount: Integer read GetSelCount;
  end;



  TNumColorsRange = 0..NumColors;

  TPlannerColorArray = array[TNumColorsRange] of TColor;
  PPlannerColorArray = ^TPlannerColorArray;

  TColorChangeEvent = procedure(Sender: TObject; Index: Integer) of object;

  TPlannerColorArrayList = class(TList)
  private
    FOnChange: TColorChangeEvent;
    procedure SetArray(Index: Integer; Value: PPlannerColorArray);
    function GetArray(Index: Integer): PPlannerColorArray;
  public
    constructor Create;
    destructor Destroy; override;
    property Items[Index: Integer]: PPlannerColorArray read GetArray write SetArray;
    function Add: PPlannerColorArray;
    procedure Delete(Index: Integer);
  published
    property OnChange: TColorChangeEvent read FOnChange write FOnChange;
  end;

  TPositionProp = class(TCollectionItem)
  private
    FActiveStart: Integer;
    FActiveEnd: Integer;
    FColorNonActive: TColor;
    FColorActive: TColor;
    FMinSelection: Integer;
    FMaxSelection: Integer;
    FBrushNoSelect: TBrushStyle;
    FColorNoSelect: TColor;
    FBackground: TBitmap;
    FUse: Boolean;
    procedure SetActiveEnd(const Value: Integer);
    procedure SetActiveStart(const Value: Integer);
    procedure SetColorActive(const Value: TColor);
    procedure SetColorNonActive(const Value: TColor);
    procedure SetMaxSelection(const Value: Integer);
    procedure SetMinSelection(const Value: Integer);
    procedure SetBrushNoSelect(const Value: TBrushStyle);
    procedure SetColorNoSelect(const Value: TColor);
    procedure SetBackground(const Value: TBitmap);
    procedure SetUse(const Value: Boolean);
    procedure BackgroundChanged(Sender: TObject);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ActiveStart: Integer read FActiveStart write SetActiveStart;
    property ActiveEnd: Integer read FActiveEnd write SetActiveEnd;
    property Background: TBitmap read FBackground write SetBackground;
    property ColorActive: TColor read FColorActive write SetColorActive;
    property ColorNonActive: TColor read FColorNonActive write SetColorNonActive;
    property MinSelection: Integer read FMinSelection write SetMinSelection;
    property MaxSelection: Integer read FMaxSelection write SetMaxSelection;
    property ColorNoSelect: TColor read FColorNoSelect write SetColorNoSelect;
    property BrushNoSelect: TBrushStyle read FBrushNoSelect write SetBrushNoSelect;
    property Use: Boolean read FUse write SetUse;
  end;

  TPositionProps = class(TCollection)
  private
    FOwner: TCustomPlanner;
    function GetItem(Index: Integer): TPositionProp;
    procedure SetItem(Index: Integer; const Value: TPositionProp);
  protected
{$IFNDEF VER90}
    function GetOwner: TPersistent; override;
{$ENDIF}
  public
    constructor Create(AOwner: TCustomPlanner);
    function Add: TPositionProp;
    function Insert(Index: Integer): TPositionProp;
    property Items[Index: Integer]: TPositionProp read GetItem write SetItem; default;
  end;

  TPlannerScrollStyle = (ssNormal,ssFlat,ssEncarta);

  TPlannerScrollBar = class(TPersistent)
  private
    FOwner: TCustomPlanner;
    FFlat: Boolean;
    FWidth: Integer;
    FColor: TColor;
    FStyle: TPlannerScrollStyle;
    procedure SetColor(const Value: TColor);
    procedure SetFlat(const Value: Boolean);
    procedure SetStyle(const Value: TPlannerScrollStyle);
    procedure SetWidth(const Value: Integer);
  public
    constructor Create(AOwner: TCustomPlanner);
    procedure UpdateProps;
  published
    property Color: TColor read FColor write SetColor;
    property Flat: Boolean read FFlat write SetFlat default False;
    property Style: TPlannerScrollStyle read FStyle write SetStyle;
    property Width: Integer read FWidth write SetWidth;
  end;

  TBackgroundDisplay = (bdTile,bdFixed);

  TBackground = class(TPersistent)
  private
    FPlanner: TCustomPlanner;
    FTop: Integer;
    FLeft: Integer;
    FDisplay: TBackgroundDisplay;
    procedure SetBitmap(Value: TBitmap);
    procedure SetTop(Value: Integer);
    procedure SetLeft(Value: Integer);
    procedure SetDisplay(Value: TBackgroundDisplay);
    procedure BackgroundChanged(Sender: TObject);
  private
    FBitmap: TBitmap;
  public
    constructor Create(APlanner: TCustomPlanner);
    destructor Destroy; override;
    property Display: TBackgroundDisplay read FDisplay write SetDisplay;
    property Top: Integer read FTop write SetTop;
    property Left: Integer read FLeft write SetLeft;
  published
    property Bitmap: TBitmap read FBitmap write SetBitmap;
  end;

  TActiveCellShow = (assNone, assCol, assRow);
  
  TPlannerGrid = class(TCustomGrid)
  private
    { Private declarations }
    FActiveCellShow: TActiveCellShow;
    FLastHintPos: TPoint;
    FUpdateCount: Integer;
    FPlanner: TCustomPlanner;
    FMemo: TPlannerMemo;
    FMaskEdit: TPlannerMaskEdit;
    FMouseDown: Boolean;
    FMouseDownMove: Boolean;
    FMouseDownSizeUp: Boolean;
    FMouseDownSizeDown: Boolean;
    FMouseStart: Boolean;
    FMouseXY: TPoint;
    FColorList: TPlannerColorArrayList;
    FScrollHintWindow: THintWindow;
    FItemXY: TPoint;
    FItemXYS: TRect;
    FEraseBkGnd: Boolean;
    FSelItem: TPlannerItem;
    FOldSelection, FHiddenSelection: TGridRect;
    FOldTopRow: Integer;
    FOldLeftCol: Integer;
    FScrolling: Boolean;
    FScrollTime: Cardinal;
    FCurrCtrlR: TRect;
    FCurrCtrlID: string;
    FCurrCtrlItem: TPlannerItem;
    FCurrCtrlEdit: string;
    FPosResizing: Boolean;
    FInplaceEdit: TEdit;
    FInplaceCombo: TPlanCombobox;
    procedure WMVScroll(var WMScroll: TWMScroll); message WM_VSCROLL;
    procedure WMHScroll(var WMScroll:TWMScroll ); message WM_HSCROLL;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMEraseBkGnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure CNKeyDown(var Message: TWMKeydown); message CN_KEYDOWN;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;    
    procedure RTFPaint(ARect: TRect; const rtf: string; Background: TColor);
    {$IFNDEF DELPHI4_LVL}
    procedure WMSize(var WMSize: TWMSize); message WM_SIZE;
    {$ENDIF}
    procedure UpdatePositions;
    procedure StartEditCol(ARect: TRect; APlannerItem: TPlannerItem;
      X, Y: Integer);
    procedure StartEditRow(ARect: TRect; APlannerItem: TPlannerItem;
      X, Y: Integer);
    procedure PaintItemCol(Canvas: TCanvas; ARect: TRect;
      APlannerItem: TPlannerItem; Print, SelColor: Boolean);
    procedure PaintItemRow(Canvas: TCanvas; ARect: TRect;
      APlannerItem: TPlannerItem; Print, SelColor: Boolean);
    procedure PaintSideCol(Canvas: TCanvas; ARect: TRect;
      ARow, APos: Integer; Occupied, Print: Boolean);
    procedure PaintSideRow(Canvas: TCanvas; ARect: TRect; AColumn, APos: Integer;
      Occupied,Print: Boolean);
    procedure GetSideBarLines(Index, Position: Integer; var Line1, Line2, Line3: string; var HS: Boolean);
    procedure DrawWallPaperFixed(CRect: TRect;xcorr,ycorr: Integer;BKColor:TColor);
    procedure DrawWallPaperTile(ACol,ARow:integer;CRect: TRect;xcorr,ycorr: Integer;BKColor:TColor);
    procedure DrawCellCol(AColumn, ARow: LongInt; ARect: TRect;
      AState: TGridDrawState);
    procedure DrawCellRow(AColumn, ARow: LongInt; ARect: TRect;
      AState: TGridDrawState);
    procedure SetEditDirectSelection(ARect: TRect; X, Y: Integer);
    function CellRectEx(X, Y: Integer):TRect;
    function ColWidthEx(ItemPos: Integer): Integer;
    function RowHeightEx(ItemPos: Integer): Integer;
    procedure SetActiveCellShow(AValue: TActiveCellShow);
    procedure UpdateNVI;
  protected
    { Protected declarations }
    procedure DrawCell(AColumn, ARow: LongInt; ARect: TRect;
      AState: TGridDrawState); override;
    procedure HintShowXY(X, Y: Integer; Caption: TCaption);
    procedure HintHide;
    procedure Loaded; override;
    {$IFDEF DELPHI4_LVL}
    procedure Resize; override;
    {$ENDIF}
    procedure DestroyWnd; override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; ShiftState: TShiftState); override;
    procedure KeyUp(var Key: Word; ShiftState: TShiftState); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure TopLeftChanged; override;
    function GetHScrollSize: Integer;
    function GetVScrollSize: Integer;
    property RowCount;
    procedure DoEnter; override;
    procedure DoExit; override;
    property ColorList: TPlannerColorArrayList read FColorList write FColorList;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure RepaintSelection(ASelection: TGridRect);  
    procedure SelChanged;
    function SelectCell(AColumn, ARow: LongInt): Boolean; override;
    procedure MouseToCell(X, Y: Integer; var ACol, ARow: Longint);
    procedure RepaintRect(r:TRect);
    procedure InvalidateCellRect(r:TRect);
    procedure CorrectSelection;
    procedure UpdateVScrollBar;
    procedure UpdateHScrollBar;
    procedure FlatSetScrollInfo(Code: Integer; var ScrollInfo:TScrollInfo; FRedraw: Bool);
    procedure FlatSetScrollProp(Index,NewValue: Integer; FRedraw:bool);
    procedure FlatShowScrollBar(Code: Integer;Show:bool);
    procedure FlatScrollInit;
    procedure FlatScrollDone;
    procedure FormHandle(Item: TPlannerItem; ControlRect: TRect; ControlID,ControlType,ControlValue: string);
    procedure FormExit(Sender: TObject);
    {$IFDEF DELPHI5_LVL}
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    {$ENDIF}
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateWnd; override;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure HideSelection;
    procedure UnHideSelection;
    procedure BeginUpdate;
    procedure EndUpdate;
    property Canvas;
    property Col;
    property EditorMode;
    property GridHeight;
    property GridWidth;
    property LeftCol;
    property Selection;
    property Row;
    property TabStops;
    property TopRow;
  published
    { Published declarations }
    property ActiveCellShow: TActiveCellShow read FActiveCellShow write SetActiveCellShow;
    property ScrollBars;
  end;

  THourType = (ht24hrs, ht12hrs, htAMPM0, htAMPM1, htAMPMOnce);

  TInplaceEditType = (ieAlways, ieNever);

  THeaderOrientation = (hoHorizontal, hoVertical);

  THeaderClickEvent = procedure(Sender: TObject; SectionIndex: Integer) of object;
  THeaderDragDropEvent = procedure(Sender: TObject;
    FromSection, ToSection: Integer) of object;

  THeaderEditEvent = procedure(Sender: TObject; SectionIndex: Integer; var Text:string) of object;  

  TAdvHeader = class(THeader)
  private
    FOffset: Integer;
    FLeftPos: Integer;
    FAlignment: TAlignment;
    FVAlignment: TVAlignment;
    FColor: TColor;
    FLineColor: TColor;
    FFlat: Boolean;
    FImageList: TImageList;
    FInplaceEdit: TMemo;
    FImagePosition: TImagePosition;
    FOnClick: THeaderClickEvent;
    FOnRightClick: THeaderClickEvent;
    FOnDragDrop: THeaderDragDropEvent;
    FOrientation: THeaderOrientation;
    FSectionDragDrop: Boolean;
    FDragging: Boolean;
    FDragStart: Integer;
    FEditSection: Integer;
    FEditWidth: Integer;
    FOnSectionEditEnd: THeaderClickEvent;
    FOnSectionEditStart: THeaderClickEvent;
    FSectionEdit: Boolean;
    FItemHeight: Integer;
    FTextHeight: Integer;
    FOnDblClick: THeaderClickEvent;
    FShowFixed: Boolean;
    FFixedHeight: Integer;
    FFixedColor: TColor;
    FZoomCol: Integer;
    FZoom: Boolean;
    FLastHintPos: TPoint;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetColor(const Value: TColor);
    procedure SetImageList(const Value: TImageList);
    procedure SetImagePosition(const Value: TImagePosition);
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure WMLButtonDown(var Msg:TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk);
      message WM_LBUTTONDBLCLK;
    procedure SetOrientation(const Value: THeaderOrientation);
    procedure SetFlat(const Value: Boolean);
    procedure SetLineColor(const Value: TColor);
    procedure SetVAlignment(const Value: TVAlignment);
    procedure InplaceExit(Sender: TObject);
    procedure SetItemHeight(const Value: Integer);
    procedure SetTextHeight(const Value: Integer);
    procedure SetFixedColor(const Value: TColor);
    procedure SetFixedHeight(const Value: Integer);
    procedure SetShowFixed(const Value: Boolean);
  protected
    function XYToSection(X, Y: Integer): Integer; virtual;
    function GetSectionRect(X: Integer): TRect; virtual;
    function GetSectionIdx(X: Integer): Integer; virtual;
    procedure StartEdit(ARect: TRect; APlannerItem: TPlannerItem; X, Y:Integer); virtual;
    procedure StopEdit;
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ItemAtXY(X, Y: Integer;var ARect: TRect): TPlannerItem;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property Color: TColor read FColor write SetColor;
    property Flat: Boolean read FFlat write SetFlat;
    property FixedColor: TColor read FFixedColor write SetFixedColor;
    property FixedHeight: Integer read FFixedHeight write SetFixedHeight;
    property ShowFixed: Boolean read FShowFixed write SetShowFixed;
    property Images: TImageList read FImageList write SetImageList;
    property ImagePosition: TImagePosition read FImagePosition write SetImagePosition;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property TextHeight: Integer read FTextHeight write SetTextHeight;
    property LineColor: TColor read FLineColor write SetLineColor;
    property SectionDragDrop: Boolean read FSectionDragDrop write FSectionDragDrop;
    property SectionEdit: Boolean read FSectionEdit write FSectionEdit;
    property VAlignment: TVAlignment read FVAlignment write SetVAlignment;
    property Zoom: Boolean read FZoom write FZoom;
    property ZoomCol: Integer read FZoomCol write FZoomCol;
    property Orientation: THeaderOrientation read FOrientation write SetOrientation default hoHorizontal;
    property OnClick: THeaderClickEvent read FOnClick write FOnClick;
    property OnRightClick: THeaderClickEvent read FOnRightClick write FOnRightClick;
    property OnDblClick: THeaderClickEvent read FOnDblClick write FOnDblClick;
    property OnDragDrop: THeaderDragDropEvent read FOnDragDrop write FOnDragDrop;
    property OnSectionEditStart: THeaderClickEvent read FOnSectionEditStart write FOnSectionEditStart;
    property OnSectionEditEnd: THeaderClickEvent read FOnSectionEditEnd write FOnSectionEditEnd;
  end;

  TPlannerPrintOptions = class(TPersistent)
  private
    FFooterSize: Integer;
    FLeftMargin: Integer;
    FRightMargin: Integer;
    FHeaderSize: Integer;
    FHeaderFont: TFont;
    FFooterFont: TFont;
    FOrientation: TPrinterOrientation;
    FFooter: TStrings;
    FHeader: TStrings;
    FHeaderAlignment: TAlignment;
    FFooterAlignment: TAlignment;
    FFitToPage: Boolean;
    FJobname: string;
    FCellHeight: Integer;
    FCellWidth: Integer;
    FSidebarWidth: Integer;
    procedure SetFooter(const Value: TStrings);
    procedure SetFooterFont(const Value: TFont);
    procedure SetHeader(const Value: TStrings);
    procedure SetHeaderFont(const Value: TFont);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property CellHeight: Integer read FCellHeight write FCellHeight default 0;
    property CellWidth: Integer read FCellWidth write FCellWidth default 0;
    property FitToPage: Boolean read FFitToPage write FFitToPage default True;
    property Footer: TStrings read FFooter write SetFooter;
    property FooterAlignment: TAlignment read FFooterAlignment write FFooterAlignment;
    property FooterFont: TFont read FFooterFont write SetFooterFont;
    property FooterSize: Integer read FFooterSize write FFooterSize;
    property Header: TStrings read FHeader write SetHeader;
    property HeaderAlignment: TAlignment read FHeaderAlignment write FHeaderAlignment;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property HeaderSize: Integer read FHeaderSize write FHeaderSize;
    property JobName: string read FJobname write FJobname;
    property LeftMargin: Integer read FLeftMargin write FLeftMargin;
    property Orientation: TPrinterOrientation read FOrientation write FOrientation;
    property RightMargin: Integer read FRightMargin write FRightMargin;
    property SidebarWidth: Integer read FSidebarWidth write FSidebarWidth default 0;
  end;

  TPlannerHTMLOptions = class(TPersistent)
  private
    FFooterFile: string;
    FHeaderFile: string;
    FBorderSize: Integer;
    FCellSpacing: Integer;
    FTableStyle: string;
    FPrefixTag: string;
    FSuffixTag: string;
    FWidth: Integer;
    FSidebarFontTag: string;
    FHeaderFontTag: string;
    FCellFontTag: string;
    FCellFontStyle: TFontStyles;
    FHeaderFontStyle: TFontStyles;
    FSidebarFontStyle: TFontStyles;
    FShowCaption: Boolean;
  public
    constructor Create;
  published
    property BorderSize: Integer read FBorderSize write FBorderSize default 1;
    property CellSpacing: Integer read FCellSpacing write FCellSpacing
    default 0;
    property FooterFile: string read FFooterFile write FFooterFile;
    property HeaderFile: string read FHeaderFile write FHeaderFile;
    property TableStyle: string read FTableStyle write FTableStyle;
    property PrefixTag: string read FPrefixTag write FPrefixTag;
    property SuffixTag: string read FSuffixTag write FSuffixTag;
    property Width: Integer read FWidth write FWidth;
    property CellFontTag: string read FCellFontTag write FCellFontTag;
    property CellFontStyle: TFontStyles read FCellFontStyle write FCellFontStyle;
    property HeaderFontTag: string read FHeaderFontTag write FHeaderFontTag;
    property HeaderFontStyle: TFontStyles read FHeaderFontStyle write FHeaderFontStyle;
    property SidebarFontTag: string read FSidebarFontTag write FSidebarFontTag;
    property SidebarFontStyle: TFontStyles read FSidebarFontStyle write FSidebarFontStyle;
    property ShowCaption: Boolean read FShowCaption write FShowCaption;
  end;

  TDragOverItemEvent = procedure(Sender, Source: TObject; X, Y: Integer;
    APlannerItem: TPlannerItem; State: TDragState; var Accept: Boolean) of object;

  TDragDropItemEvent = procedure(Sender, Source: TObject; X, Y: Integer;
    PlannerItem: TPlannerItem) of object;

  TWeekDays = class(TPersistent)
  private
    FSat: Boolean;
    FSun: Boolean;
    FMon: Boolean;
    FTue: Boolean;
    FWed: Boolean;
    FThu: Boolean;
    FFri: Boolean;
    FChanged: TNotifyEvent;
    procedure SetSat(const Value: Boolean);
    procedure SetSun(const Value: Boolean);
    procedure SetMon(const Value: Boolean);
    procedure SetTue(const Value: Boolean);
    procedure SetWed(const Value: Boolean);
    procedure SetThu(const Value: Boolean);
    procedure SetFri(const Value: Boolean);
    procedure Changed;
  public
    constructor Create;
  published
    property Sat: Boolean read FSat write SetSat;
    property Sun: Boolean read FSun write SetSun;
    property Mon: Boolean read FMon write SetMon;
    property Tue: Boolean read FTue write SetTue;
    property Wed: Boolean read FWed write SetWed;
    property Thu: Boolean read FThu write SetThu;
    property Fri: Boolean read FFri write SetFri;
    property OnChanged: TNotifyEvent read FChanged write FChanged;
  end;

  TByteSet = set of Byte;

  TButtonDirection = (bdLeft,bdRight);

  TAdvSpeedButton = class(TSpeedButton)
  private
    FButtonDirection: TButtonDirection;
    FIsWinXP: Boolean;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Direction: TButtonDirection read FButtonDirection write FButtonDirection;
  end;

  TPlannerExChange = class(TComponent)
  private
    FPlanner: TCustomPlanner;
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  public
    function NumItemsForExport: Integer;
    procedure DoExport; virtual;
    procedure DoImport; virtual;
  published
    property Planner: TCustomPlanner read FPlanner write FPlanner;  
  end;


  TCustomPlanner = class(TCustomControl)
  private
    { Private declarations }
    FHTMLFactor: Double;
    FRichEdit: TPlannerRichEdit;
    FActiveDisplay: Boolean;
    FBands: TBands;
    FOverlap: Boolean;
    FColor: TColor;
    FLayer: Integer;
    FEditRTF: Boolean;
    FEditDirect: Boolean;
    FEditScroll: TScrollStyle;
    FTrackColor: TColor;
    FTrackProportional: Boolean;
    FTrackWidth: Integer;
    FFont: TFont;
    FGrid: TPlannerGrid;
    FGridPopup: TPopupmenu;
    FGridLineColor: TColor;
    FItemPopup: TPopupmenu;
    FPopupPlannerItem: TPlannerItem;
    FHeader: TAdvHeader;
    FHintOnItemChange: Boolean;
    FHintColor: TColor;
    FItemGap: Integer;
    FNext: TAdvSpeedButton;
    FPrev: TAdvSpeedButton;
    FMode: TPlannerMode;
    FCaption: TPlannerCaption;
    FSidebar: TPlannerSideBar;
    FDisplay: TPlannerDisplay;
    FDayNames: TStringList;
    FHourType: THourType;
    FPlannerHeader: TPlannerHeader;
    FPlannerItems: TPlannerItems;
    FPlannerImages: TImageList;
    FContainer: TPictureContainer;
    FImageCache:  THTMLPictureCache;
    FTimerActiveCells: Integer;
    FPlanChecker: TPlannerCheck;
    FPanel: TPlannerPanel;
    FPositions: Integer;
    FPositionGap: Integer;
    FPositionWidth: Integer;
    FPositionZoomWidth: Integer;
    FPositionProps: TPositionProps;
    FPrintOptions: TPlannerPrintOptions;
    FHTMLOptions: TPlannerHTMLOptions;
    FInactiveDays: TWeekDays;
    FInactive: TByteSet;
    FLinkUpdate: Boolean;
    FPrinterDriverFix: Boolean;
    FScrollSynch: Boolean;
    FDirectMove: Boolean;
    FTimerID: Integer;
    FNavigatorButtons: TNavigatorButtons;
    FOnItemAnchorClick: TItemAnchorEvent;
    FOnItemAnchorEnter: TItemAnchorEvent;
    FOnItemAnchorExit: TItemAnchorEvent;
    FOnItemRightClick: TItemEvent;
    FOnItemDblClick: TItemEvent; //##jpl: Must become a virtual method that calls it; default-> Edit dialog
    FOnItemImageClick: TItemImageEvent;
    FOnItemLeftClick: TItemEvent;
    FOnItemMove: TItemMoveEvent;
    FOnItemSize: TItemSizeEvent;
    FOnItemDelete: TItemEvent;
    FOnItemInsert: TPlannerEvent;
    FOnItemStartEdit: TItemEvent;
    FOnItemEndEdit: TItemEvent;
    FOnItemSelect: TItemEvent;
    FOnItemEnter: TItemEvent;
    FOnItemExit: TItemEvent;
    FOnItemHint: TItemHintEvent;
    FOnItemClipboardAction: TItemClipboardEvent;
    FOnItemSelChange: TItemEvent;
    FOnItemActivate: TItemEvent;
    FOnItemDeActivate: TItemEvent;
    FOnItemPopupPrepare: TItemPopupPrepareEvent;
    FOnItemPlaceUpdate: TItemUpdateEvent;
    FOnPlannerLeftClick: TPlannerEvent;
    FOnPlannerRightClick: TPlannerEvent;
    FOnPlannerDblClick: TPlannerEvent;
    FOnPlannerKeypress: TPlannerKeyEvent;
    FOnPlannerKeyDown: TPlannerKeyDownEvent;
    FOnPlannerKeyUp: TPlannerKeyDownEvent;
    FOnPlannerItemDraw: TPlannerItemDraw;
    FOnPlannerIsActive: TPlannerActiveEvent;    
    FOnPlannerSideDraw: TPlannerSideDraw;
    FOnPlannerGetSideBarLines: TPlannerGetSideBarLines;
    FOnPlannerBkgDraw: TPlannerBkgDraw;
    FOnPlannerHeaderDraw: TPlannerHeaderDraw;
    FOnPlannerCaptionDraw: TPlannerCaptionDraw;
    FOnPlannerNext: TPlannerBtnEvent;
    FOnPlannerPrev: TPlannerBtnEvent;
    FOnPlannerMouseMove: TMouseMoveEvent;
    FOnPlannerMouseUp: TMouseEvent;
    FOnPlannerMouseDown: TMouseEvent;
    FOnCaptionAnchorEnter: TPlannerAnchorEvent;
    FOnCaptionAnchorExit: TPlannerAnchorEvent;
    FOnCaptionAnchorClick: TPlannerAnchorEvent;
    FOnCustomEdit: TCustomEditEvent;
    FOnCustomITEvent: TCustomITEvent;
    FOnCustomTIEvent: TCustomTIEvent;
    FOnHeaderClick: THeaderClickEvent;
    FOnHeaderRightClick: THeaderClickEvent;
    FOnHeaderStartEdit: THeaderEditEvent;
    FOnHeaderEndEdit: THeaderEditEvent;
    FOnPrintStart: TPlannerPrintEvent;
    FOnTopLeftChanged: TPlannerBtnEvent;
    FOnDragOver: TDragOverEvent;
    FOnDragOverCell: TDragOverEvent;
    FOnDragOverItem: TDragOverItemEvent;
    FOnDragDrop: TDragDropEvent;
    FOnDragDropCell: TDragDropEvent;
    FOnDragDropItem: TDragDropItemEvent;
    FOnPlannerSelChange: TPlannerEvent;
    FOnPlannerSelectCell: TPlannerSelectCellEvent;
    FOnItemMoving: TItemMovingEvent;
    FOnItemSizing: TItemSizingEvent;
    FOnItemText: TPlannerItemText;
    FOnGetCurrentTime: TGetCurrentTimeEvent;
    FOnPlanTimeToStrings: TPlannerPlanTimeToStrings;
    FOnExit: TNotifyEvent;
    FOnEnter: TNotifyEvent;
    FMultiSelect: Boolean;
    FDefaultItem: TPlannerItem;
    FDefaultItems: TPlannerItems;
    FSelectColor: TColor;
    FFlat: Boolean;
    FLoading: Boolean;
    FOnPlannerBottomLine: TPlannerBottomLineEvent;
    FStreamPersistentTime: Boolean;
    FHTMLHint: Boolean;
    FOnHeaderDragDrop: THeaderDragDropEvent;
    FURLColor: TColor;
    FOnItemURLClick: TItemLinkEvent;
    FOnItemAttachementClick: TItemLinkEvent;
    FScrollBarStyle: TPlannerScrollBar;
    FBackground: TBackground;
    FPaintMarginTY: Integer;
    FPaintMarginLX: Integer;
    FPaintMarginBY: Integer;
    FPaintMarginRX: Integer;
    FEnableAlarms: Boolean;
    FEnableFlashing: Boolean;
    FIndicateNonVisibleItems: Boolean;
    FHandlingAlarm: Boolean;
    FWheelDelta: Integer;
    FScrollDelay: Cardinal;
    FOnHeaderDblClick: THeaderClickEvent;
    FAutoItemScroll: Boolean;
    FOnPositionToDay: TPlannerPositionToDay;
    FSelectionAlways: Boolean;
    FFlashColor: TColor;
    FOnItemAlarm: TItemEvent;
    FFlashFontColor: TColor;
    FDragItem: Boolean;
    FOnItemDrag: TItemDragEvent;
    FScrollSmooth: Boolean;
    FPositionGroup: Integer;
    FTrackBump: Boolean;
    FOnPlannerPositionZoom: TPlannerPositionZoom;
    FSelectBlend: Integer;
    FInsertAlways: Boolean;
    FShowHint: Boolean;
    FTopIndicator: Boolean;
    FBottomIndicator: Boolean;
    FShadowColor: TColor;
    FInplaceEdit: TInplaceEditType;
    FGradientSteps: Integer;
    FGradientHorizontal: Boolean;
    FCompletionColor1: TColor;
    FCompletionColor2: TColor;
    FItemSelection: TPlannerItemSelection;
    FDTList: TDateTimeList;
    FDrawPrecise: Boolean;
    FRoundTime: Boolean;
    FOnItemControlClick: TItemControlEvent;
    FOnItemControlEditStart: TItemControlEvent;
    FOnItemControlEditDone: TItemControlEvent;
    FOnItemControlComboList: TItemControlListEvent;
    FOnItemControlComboSelect: TItemComboControlEvent;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure WMEraseBkGnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure WMMoving(var Message: TMessage); message WM_MOVING;
    {$IFNDEF DELPHI4_LVL}
    procedure WMSize(var WMSize: TWMSize); message WM_SIZE;
    {$ENDIF}
    procedure InactiveChanged(Sender: TObject);
    procedure SetCaption(const Value: TPlannerCaption);
    procedure SetSideBar(const Value: TPlannerSideBar);
    procedure SetDisplay(const Value: TPlannerDisplay);
    procedure SetDayNames(const Value: TStringList);
    procedure SetHeader(const Value: TPlannerHeader);
    procedure SetMode(const Value: TPlannerMode);
    procedure SetPlannerItems(const Value: TPlannerItems);
    procedure SetImages(const Value: TImageList);
    procedure SetLayer(const Value: LongInt);
    procedure SetDrawPrecise(const Value: Boolean);
    procedure SetHourType(const Value: THourType);
    procedure SetPositions(const Value: Integer);
    procedure SetPositionWidth(const Value: Integer);
    procedure SetGridTopRow(const Value: Integer);
    procedure SetGridLeftCol(const Value: Integer);
    function GetGridTopRow: Integer;
    function GetGridLeftCol: Integer;
    procedure SetFont(Value: TFont);
    procedure SetTrackColor(const Value: TColor);
    procedure SetTrackProportional(const Value: Boolean);
    procedure SetActiveDisplay(const Value: Boolean);
    procedure PlanFontChanged(Sender: TObject);
    procedure HeaderClick(Sender: TObject; SectionIndex: Integer);
    procedure HeaderRightClick(Sender: TObject; SectionIndex: Integer);
    procedure HeaderDblClick(Sender: TObject; SectionIndex: Integer);
    procedure HeaderDragDrop(Sender: TObject; FromSection, ToSection: Integer);
    procedure HeaderSized(Sender: TObject; ASection, AWidth: Integer);
    procedure UpdateSizes;
    procedure UpdateTimer;
    function GetSelItemEnd: Integer;
    function GetSelItemBegin: Integer;
    function GetSelPosition: Integer;
    function GetCellTime(i,j: Integer): TDateTime;
    procedure SetSelItemEnd(const Value: Integer);
    procedure SetSelItemBegin(const Value: Integer);
    procedure SetSelPosition(Value: Integer);
    procedure SetShadowColor(const Value: TColor);
    procedure SetGradientSteps(const Value: Integer);
    procedure SetGradientHorizontal(const Value: Boolean);
    procedure SelChange(Sender: TObject);
    procedure SetGridLineColor(const Value: TColor);
    procedure SetColor(const Value: TColor);
    function GetBackGroundColor(ACol, ARow: Integer): TColor;
    procedure SetBackGroundColor(ACol, ARow: Integer; const Value: TColor);
    procedure SetItemGap(const Value: Integer);
    procedure SaveToHTMLCol(FileName: string);
    procedure SaveToHTMLRow(FileName: string);
    function GetMemo: TMemo;
    function GetMaskEdit: TMaskEdit;
    procedure SetDefaultItem(const Value: TPlannerItem);
    procedure SetSelectColor(const Value: TColor);
    procedure SetFlat(const Value: Boolean);
    procedure SetPositionGap(const Value: Integer);
    procedure SetTrackWidth(const Value: Integer);
    procedure SetURLColor(const Value: TColor);
    procedure SetEnableAlarms(const Value: Boolean);
    procedure SetPositionProps(const Value: TPositionProps);
    procedure SetEnableFlashing(const Value: Boolean);
    procedure SetFlashColor(const Value: TColor);
    procedure SetFlashFontColor(const Value: TColor);
    function GetDragCopy: Boolean;
    function GetDragMove: Boolean;
    procedure SetPositionGroup(const Value: Integer);
    procedure SetTrackBump(const Value: Boolean);
    function GetPositionWidths(Position: Integer): Integer;
    procedure SetPositionWidths(Position: Integer; const Value: Integer);
    procedure SetPositionZoomWidth(const Value: Integer);
    procedure SetSelectBlend(const Value: Integer);
    procedure SetShowHint(const Value: Boolean);
    procedure SetItemSelection(AValue: TPlannerItemSelection);
  protected
    { Protected declarations }
    procedure Loaded; override;
    {$IFDEF DELPHI4_LVL}
    procedure Resize; override;
    {$ENDIF}
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DestroyWnd; override;
    procedure WndProc(var Message: TMessage); override;
    procedure CreateWnd; override;
    procedure Paint; override;
    function GetDayName(WeekDay: Integer): string; virtual;
    procedure PrintCol(ACanvas:TCanvas; FromPos, ToPos, FromRow, ToRow: Integer);
    procedure PrintRow(ACanvas:TCanvas; FromPos, ToPos, FromCol, ToCol: Integer);
    procedure GetCellBrush(Pos,Index: Integer; ABrush:TBrush);
    function GetCellColorCol(Pos,Index: Integer): TColor;
    procedure NextClick(Sender: TObject); virtual;
    procedure PrevClick(Sender: TObject); virtual;
    procedure ItemMoved(FromBegin, FromEnd, FromPos, ToBegin, ToEnd, ToPos: Integer); virtual;
    procedure ItemSized(FromBegin, FromEnd, ToBegin, ToEnd: Integer); virtual;
    procedure ItemEdited(Item: TPlannerItem); virtual;
    procedure ItemSelected(Item: TPlannerItem); virtual;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    function CreateItems: TPlannerItems; virtual;
    function GetSelMinMax(Pos: Integer; var SelMin, SelMax: Integer): Boolean;
    procedure MapItemTimeOnPlanner(APlannerItem: TPlannerItem); virtual;
    function GetVersionNr: Integer; virtual;
    function GetVersionString:string; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AutoSizeHeader;
    procedure SaveToHTML(FileName: string);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure InsertFromStream(Stream: TStream);
    procedure SavePositionToStream(Stream: TStream; Position: Integer);
    procedure LoadPositionFromStream(Stream: TStream; Position: Integer);
    procedure SaveLayerToStream(Stream: TStream; Layer: Integer);
    procedure LoadLayerFromStream(Stream: TStream; Layer: Integer);
    procedure SaveToFile(FileName: string);
    procedure LoadFromFile(FileName: string);
    procedure InsertFromFile(FileName: string);
    procedure SavePositionToFile(FileName: string; Position: Integer);
    procedure LoadPositionFromFile(FileName: string; Position: Integer);
    procedure SaveLayerToFile(FileName: string; Layer: Integer);
    procedure LoadLayerFromFile(FileName: string; Layer: Integer);
    procedure Print;
    procedure PrintPages(NrOfPages: Integer);
    procedure PrintSelection(FromPos, ToPos: Integer);
    procedure PrintRange(FromPos, ToPos, FromItem, ToItem: Integer);
    procedure PrintTo(ACanvas:TCanvas);
    procedure PrintSelectionTo(ACanvas:TCanvas;FromPos, ToPos: Integer);
    procedure PrintRangeTo(ACanvas:TCanvas;FromPos, ToPos, FromItem, ToItem: Integer);
    procedure Invalidate; override;
    procedure TextToRich(const RtfText: string);
    function RichToText: string;
    procedure PreviewPaint(APlannerItem: TPlannerItem; Canvas: TCanvas; r: TRect);
    procedure SelectGrid;
    procedure SelectCells(SelBegin,SelEnd,SelPos: Integer);
    property CompletionColor1: TColor read FCompletionColor1 write FCompletionColor1;
    property CompletionColor2: TColor read FCompletionColor2 write FCompletionColor2;
    property SelPosition: Integer read GetSelPosition write SetSelPosition;
    property SelItemBegin: Integer read GetSelItemBegin write SetSelItemBegin;
    property SelItemEnd: Integer read GetSelItemEnd write SetSelItemEnd;
    property DateTimeList: TDateTimeList read FDTList write FDTList;
    property GradientSteps: Integer read FGradientSteps write SetGradientSteps;
    property GradientHorizontal: Boolean read FGradientHorizontal write SetGradientHorizontal;
    property RichEdit: TPlannerRichEdit read FRichEdit write FRichEdit;
    property MemoEdit: TMemo read GetMemo;
    property MaskEdit: TMaskEdit read GetMaskEdit;
    property BackGroundColor[ACol, ARow: Integer]: TColor read GetBackGroundColor write SetBackGroundColor;
    property PrinterDriverFix: Boolean read FPrinterDriverFix write FPrinterDriverFix;
    function PlanTimeToStr(MinutesValue: Integer): string;
    procedure PlanTimeToStrings(MinutesValue: Integer; var HoursString, MinutesString, AmPmString: string);
    function IsSelected(AIndex, APosition: Integer): Boolean;
    function IsActive(AIndex, APosition: Integer): Boolean;
    function IsCurPos(APosition: Integer): Boolean;
    function XYToCell(X, Y: Integer): TPoint;
    function XYToItem(X, Y: Integer): TPlannerItem;
    function CellToItem(X, Y: Integer): TPlannerItem;
    function CellToItemNum(X, Y: Integer): Integer;
    function CellToItemIdx(X, Y, Index: Integer): TPlannerItem;
    function CellInCurrTime(X, Y: Integer): Boolean;
    function CellToTime(X, Y: Integer): TDateTime;
    function CellRect(X,Y: Integer): TRect;
    function PosToDay(Pos: Integer): TDateTime; virtual;
    function IndexToTime(Index: Integer): TDateTime; virtual;
    function TimeToIndex(DT: TDateTime): Integer; virtual;
    procedure CellToAbsTime(X: Integer; var dtStart, dtEnd: TDateTime);
    function AbsTimeToCell(DateTime: TDateTime): Integer;
    procedure HideSelection;
    procedure UnHideSelection;
    procedure MovePosition(FromPos, ToPos: Integer);
    procedure DeletePosition(Position: Integer);
    procedure InsertPosition(Position: Integer);
    function CreateItem:TPlannerItem; virtual;
    function CloneItem(Item: TPlannerItem): TPlannerItem; virtual;
    procedure RemoveClones(Item: TPlannerItem);
    function CreateItemAtSelection:TPlannerItem; virtual;
    function CloneItemAtSelection(Item: TPlannerItem): TPlannerItem; virtual;
    procedure UpdateItem(APlannerItem:TPlannerItem); virtual;
    procedure RefreshItem(APlannerItem:TPlannerItem); virtual;
    procedure FreeItem(APlannerItem:TPlannerItem); virtual;
    procedure Refresh; virtual;
    procedure MarkInItem(APlannerItem: TPlannerItem; AText: string; DoCase: Boolean);
    procedure MarkInPositon(Pos: Integer; AText: string; DoCase: Boolean);
    procedure MarkInItems(AText: string; DoCase: Boolean);
    procedure UnMarkInItem(APlannerItem: TPlannerItem);
    procedure UnMarkInPositon(Pos: Integer);
    procedure UnMarkInItems;
    procedure HilightInItem(APlannerItem: TPlannerItem; AText: string; DoCase: Boolean);
    procedure HilightInPositon(Pos: Integer; AText: string; DoCase: Boolean);
    procedure HilightInItems(AText: string; DoCase: Boolean);
    procedure UnHilightInItem(APlannerItem: TPlannerItem);
    procedure UnHilightInPositon(Pos: Integer);
    procedure UnHilightInItems;
    procedure ExportItem(APlannerItem: TPlannerItem);
    procedure ExportPosition(Pos: Integer);
    procedure ExportItems;
    procedure ExportLayer(Layer: Integer);
    procedure ExportClear;
    procedure UpdateNVI;
    procedure ZoomPosition(Pos: Integer);
    procedure UnZoomPosition(Pos: Integer);
    property VersionNr: Integer read GetVersionNr;
    property VersionString: string read GetVersionString;
    property PopupPlannerItem: TPlannerItem read FPopupPlannerItem write FPopupPlannerItem;
    property StreamPersistentTime: Boolean read FStreamPersistentTime write FStreamPersistentTime;
    property PaintMarginTY: Integer read FPaintMarginTY write FPaintMarginTY;
    property PaintMarginLX: Integer read FPaintMarginLX write FPaintMarginLX;
    property PaintMarginBY: Integer read FPaintMarginBY write FPaintMarginBY;
    property PaintMarginRX: Integer read FPaintMarginRX write FPaintMarginRX;
    property AutoItemScroll: Boolean read FAutoItemScroll write FAutoItemScroll;
    property DragCopy: Boolean read GetDragCopy;
    property DragMove: Boolean read GetDragMove;
    property PositionWidths[Position: Integer]: Integer read GetPositionWidths write SetPositionWidths;
    property ScrollDelay: Cardinal read FScrollDelay write FScrollDelay;
    property HeaderControl: TAdvHeader read FHeader;
    property GridControl: TPlannerGrid read FGrid;
    { Normal published declarations }
    property ActiveDisplay: Boolean read FActiveDisplay write SetActiveDisplay;
    property Align;
    property Background: TBackground read FBackground write FBackground;
    property Bands: TBands read FBands write FBands;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property BiDiMode;
    property Constraints;
    {$ENDIF}
    property Caption: TPlannerCaption read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor;
    property DayNames: TStringList read FDayNames write SetDayNames;
    property DefaultItem: TPlannerItem read FDefaultItem write SetDefaultItem;
    property DirectMove: Boolean read FDirectMove write FDirectMove;
    property Display: TPlannerDisplay read FDisplay write SetDisplay;
    property DragItem: Boolean read FDragItem write FDragItem;
    property DrawPrecise: Boolean read FDrawPrecise write SetDrawPrecise;
    property RoundTime: Boolean read FRoundTime write FRoundTime;
    property EditRTF: Boolean read FEditRTF write FEditRTF;
    property EditDirect: Boolean read FEditDirect write FEditDirect;
    property EditScroll: TScrollStyle read FEditScroll write FEditScroll;
    property EnableAlarms: Boolean read FEnableAlarms write SetEnableAlarms;
    property EnableFlashing: Boolean read FEnableFlashing write SetEnableFlashing;
    property FlashColor: TColor read FFlashColor write SetFlashColor;
    property FlashFontColor: TColor read FFlashFontColor write SetFlashFontColor;
    property Flat: Boolean read FFlat write SetFlat;
    property Font: TFont read FFont write SetFont;
    property GridPopup: TPopupmenu read FGridPopup write FGridPopup;
    property GridLeftCol: Integer read GetGridLeftCol write SetGridLeftCol;
    property GridLineColor: TColor read FGridLineColor write SetGridLineColor default clGray;
    property GridTopRow: Integer read GetGridTopRow write SetGridTopRow;
    property Header: TPlannerHeader read FPlannerHeader write SetHeader;
    property HintColor: TColor read FHintColor write FHintColor;
    property HintOnItemChange: Boolean read FHintOnItemChange write FHintOnItemChange;
    property HourType: THourType read FHourType write SetHourType;
    property HTMLHint: Boolean read FHTMLHint write FHTMLHint;
    property HTMLOptions: TPlannerHTMLOptions read FHTMLOptions write FHTMLOptions;
    property InActiveDays: TWeekDays read FInactiveDays write FInactiveDays;
    property IndicateNonVisibleItems: Boolean read FIndicateNonVisibleItems write FIndicateNonVisibleItems;
    property InplaceEdit: TInplaceEditType read FInplaceEdit write FInplaceEdit;
    property InsertAlways: Boolean read FInsertAlways write FInsertAlways;
    property ItemChecker: TPlannerCheck read FPlanChecker write FPlanChecker;
    property ItemGap: Integer read FItemGap write SetItemGap;
    property ItemPopup: TPopupmenu read FItemPopup write FItemPopup;
    property Items: TPlannerItems read FPlannerItems write SetPlannerItems;
    property ItemSelection: TPlannerItemSelection read FItemSelection write SetItemSelection;
    property Layer: LongInt read FLayer write SetLayer;
    property Mode: TPlannerMode read FMode write SetMode;
    property MultiSelect: Boolean read FMultiSelect write FMultiSelect;
    property NavigatorButtons: TNavigatorButtons read FNavigatorButtons write FNavigatorButtons;
    property SelectionAlways: Boolean read FSelectionAlways write FSelectionAlways default True;
    property ShadowColor: TColor read FShadowColor write SetShadowColor;
    property ShowHint: Boolean read FShowHint write SetShowHint;
    property Sidebar: TPlannerSideBar read FSidebar write SetSideBar;
    property Overlap: Boolean read FOverlap write FOverlap default True;
    property PictureContainer: TPictureContainer read FContainer write FContainer;
    property PlannerImages: TImageList read FPlannerImages write SetImages;
    property Positions: Integer read FPositions write SetPositions;
    property PositionGap: Integer read FPositionGap write SetPositionGap;
    property PositionGroup: Integer read FPositionGroup write SetPositionGroup;
    property PositionProps: TPositionProps read FPositionProps write SetPositionProps;
    property PositionWidth: Integer read FPositionWidth write SetPositionWidth;
    property PositionZoomWidth: Integer read FPositionZoomWidth write SetPositionZoomWidth;
    property PrintOptions: TPlannerPrintOptions read FPrintOptions write FPrintOptions;
    property ScrollSmooth: Boolean read FScrollSmooth write FScrollSmooth;
    property ScrollSynch: Boolean read FScrollSynch write FScrollSynch;
    property ScrollBarStyle: TPlannerScrollBar read FScrollBarStyle write FScrollBarStyle;
    property SelectBlend: Integer read FSelectBlend write SetSelectBlend default 90;
    property SelectColor: TColor read FSelectColor write SetSelectColor;
    property TrackBump: Boolean read FTrackBump write SetTrackBump;
    property TrackColor: TColor read FTrackColor write SetTrackColor;
    property TrackProportional: Boolean read FTrackProportional write SetTrackProportional default False;
    property TrackWidth: Integer read FTrackWidth write SetTrackWidth;
    property URLColor: TColor read FURLColor write SetURLColor default clBlue;
    property Visible;
    {$IFDEF DELPHI5_LVL}
    property WheelDelta: Integer read FWheelDelta write FWheelDelta default 1;
    {$ENDIF}
    property OnStartDrag;
    property OnEndDrag;
    property OnCaptionAnchorEnter: TPlannerAnchorEvent read FOnCaptionAnchorEnter write FOnCaptionAnchorEnter;
    property OnCaptionAnchorExit: TPlannerAnchorEvent read FOnCaptionAnchorExit write FOnCaptionAnchorExit;
    property OnCaptionAnchorClick: TPlannerAnchorEvent read FOnCaptionAnchorClick write FOnCaptionAnchorClick;
    property OnCustomEdit: TCustomEditEvent read FOnCustomEdit write FOnCustomEdit;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
    property OnItemAnchorClick: TItemAnchorEvent read FOnItemAnchorClick write FOnItemAnchorClick;
    property OnItemAnchorEnter: TItemAnchorEvent read FOnItemAnchorEnter write FOnItemAnchorEnter;
    property OnItemAnchorExit: TItemAnchorEvent read FOnItemAnchorExit write FOnItemAnchorExit;
    property OnItemControlEditStart: TItemControlEvent read FOnItemControlEditStart write FOnItemControlEditStart;
    property OnItemControlEditDone: TItemControlEvent read FOnItemControlEditDone write FOnItemControlEditDone;
    property OnItemControlComboList: TItemControlListEvent read FOnItemControlComboList write FOnItemControlComboList;
    property OnItemControlClick: TItemControlEvent read FOnItemControlClick write FOnItemControlClick;
    property OnItemControlComboSelect: TItemComboControlEvent read FOnItemControlComboSelect write FOnItemControlComboSelect;
    property OnItemClipboardAction: TItemClipboardEvent read FOnItemClipboardAction write FOnItemClipboardAction;
    property OnItemLeftClick: TItemEvent read FOnItemLeftClick write FOnItemLeftClick;
    property OnItemRightClick: TItemEvent read FOnItemRightClick write FOnItemRightClick;
    property OnItemDblClick: TItemEvent read FOnItemDblClick write FOnItemDblClick;
    property OnItemDrag: TItemDragEvent read FOnItemDrag write FOnItemDrag;
    property OnItemImageClick: TItemImageEvent read FOnItemImageClick write FOnItemImageClick;
    property OnItemURLClick: TItemLinkEvent read FOnItemURLClick write FOnItemURLClick;
    property OnItemAlarm: TItemEvent read FOnItemAlarm write FOnItemAlarm;
    property OnItemAttachementClick: TItemLinkEvent read FOnItemAttachementClick write FOnItemAttachementClick;
    property OnItemSize: TItemSizeEvent read FOnItemSize write FOnItemSize;
    property OnItemMove: TItemMoveEvent read FOnItemMove write FOnItemMove;
    property OnItemSizing: TItemSizingEvent read FOnItemSizing write FOnItemSizing;
    property OnItemMoving: TItemMovingEvent read FOnItemMoving write FOnItemMoving;
    property OnItemDelete: TItemEvent read FOnItemDelete write FOnItemDelete;
    property OnItemInsert: TPlannerEvent read FOnItemInsert write FOnItemInsert;
    property OnItemStartEdit: TItemEvent read FOnItemStartEdit write FOnItemStartEdit;
    property OnItemEndEdit: TItemEvent read FOnItemEndEdit write FOnItemEndEdit;
    property OnItemSelect: TItemEvent read FOnItemSelect write FOnItemSelect;
    property OnItemEnter: TItemEvent read FOnItemEnter write FOnItemEnter;
    property OnItemExit: TItemEvent read FOnItemExit write FOnItemExit;
    property OnItemHint: TItemHintEvent read FOnItemHint write FOnItemHint;
    property OnItemSelChange: TItemEvent read FOnItemSelChange write FOnItemSelChange;
    property OnItemActivate: TItemEvent read FOnItemActivate write FOnItemActivate;
    property OnItemDeActivate: TItemEvent read FOnItemDeActivate write FOnItemDeActivate;
    property OnItemPlaceUpdate: TItemUpdateEvent read FOnItemPlaceUpdate write FOnItemPlaceUpdate;
    property OnItemPopupPrepare: TItemPopupPrepareEvent read FOnItemPopupPrepare write FOnItemPopupPrepare;
    property OnItemText: TPlannerItemText read FOnItemText write FOnItemText;
    property OnPlannerLeftClick: TPlannerEvent read FOnPlannerLeftClick write FOnPlannerLeftClick;
    property OnPlannerRightClick: TPlannerEvent read FOnPlannerRightClick write FOnPlannerRightClick;
    property OnPlannerDblClick: TPlannerEvent read FOnPlannerDblClick write FOnPlannerDblClick;
    property OnPlannerKeyPress: TPlannerKeyEvent read FOnPlannerKeypress write FOnPlannerKeypress;
    property OnPlannerKeyDown: TPlannerKeyDownEvent read FOnPlannerKeyDown write FOnPlannerKeyDown;
    property OnPlannerKeyUp: TPlannerKeyDownEvent read FOnPlannerKeyUp write FOnPlannerKeyUp;
    property OnPlannerItemDraw: TPlannerItemDraw read FOnPlannerItemDraw write FOnPlannerItemDraw;
    property OnPlannerIsActive: TPlannerActiveEvent read FOnPlannerIsActive write FOnPlannerIsActive;
    property OnPlannerBottomLine: TPlannerBottomLineEvent read FOnPlannerBottomLine write FOnPlannerBottomLine;
    property OnPlannerSideDraw: TPlannerSideDraw read FOnPlannerSideDraw write FOnPlannerSideDraw;
    property OnPlannerGetSideBarLines: TPlannerGetSideBarLines read FOnPlannerGetSideBarLines write FOnPlannerGetSideBarLines;
    property OnPlannerBkgDraw: TPlannerBkgDraw read FOnPlannerBkgDraw write FOnPlannerBkgDraw;
    property OnPlannerHeaderDraw: TPlannerHeaderDraw read FOnPlannerHeaderDraw write FOnPlannerHeaderDraw;
    property OnPlannerCaptionDraw: TPlannerCaptionDraw read FOnPlannerCaptionDraw write FOnPlannerCaptionDraw;
    property OnPlannerNext: TPlannerBtnEvent read FOnPlannerNext write FOnPlannerNext;
    property OnPlannerPrev: TPlannerBtnEvent read FOnPlannerPrev write FOnPlannerPrev;
    property OnPlannerSelChange: TPlannerEvent read FOnPlannerSelChange write FOnPlannerSelChange;
    property OnPlannerSelectCell: TPlannerSelectCellEvent read FOnPlannerSelectCell write FOnPlannerSelectCell;
    property OnPlannerMouseMove: TMouseMoveEvent read FOnPlannerMouseMove write FOnPlannerMouseMove;
    property OnPlannerMouseUp: TMouseEvent read FOnPlannerMouseUp write FOnPlannerMouseUp;
    property OnPlannerMouseDown: TMouseEvent read FOnPlannerMouseDown write FOnPlannerMouseDown;
    property OnPlannerPositionZoom: TPlannerPositionZoom read FOnPlannerPositionZoom write FOnPlannerPositionZoom;
    property OnPlanTimeToStrings: TPlannerPlanTimeToStrings read FOnPlanTimeToStrings write FOnPlanTimeToStrings;
    property OnPositionToDay: TPlannerPositionToDay read FOnPositionToDay write FOnPositionToDay;
    property OnHeaderClick: THeaderClickEvent read FOnHeaderClick write FOnHeaderClick;
    property OnHeaderRightClick: THeaderClickEvent read FOnHeaderRightClick write FOnHeaderRightClick;
    property OnHeaderDblClick: THeaderClickEvent read FOnHeaderDblClick write FOnHeaderDblClick;
    property OnHeaderDragDrop: THeaderDragDropEvent read FOnHeaderDragDrop write FOnHeaderDragDrop;
    property OnHeaderStartEdit: THeaderEditEvent read FOnHeaderStartEdit write FOnHeaderStartEdit;
    property OnHeaderEndEdit: THeaderEditEvent read FOnHeaderEndEdit write FOnHeaderEndEdit;
    property OnTopLeftChanged: TPlannerBtnEvent read FOnTopLeftChanged write FOnTopLeftChanged;
    property OnPrintStart: TPlannerPrintEvent read FOnPrintStart write FOnPrintStart;
    property OnDragOver: TDragOverEvent read FOnDragOver write FOnDragOver;
    property OnDragOverCell: TDragOverEvent read FOnDragOverCell write FOnDragOverCell;
    property OnDragOverItem: TDragOverItemEvent read FOnDragOverItem write FOnDragOverItem;
    property OnDragDrop: TDragDropEvent read FOnDragDrop write FOnDragDrop;
    property OnDragDropCell: TDragDropEvent read FOnDragDropCell write FOnDragDropCell;
    property OnDragDropItem: TDragDropItemEvent read FOnDragDropItem write FOnDragDropItem;
    property OnGetCurrentTime: TGetCurrentTimeEvent read FOnGetCurrentTime write FOnGetCurrentTime;
    property OnCustomIndexToTime: TCustomITEvent read FOnCustomITEvent write FOnCustomITEvent;
    property OnCustomTimeToIndex: TCustomTIEvent read FOnCustomTIEvent write FOnCustomTIEvent;
  end;


  TPlanner = class(TCustomPlanner)
  published
    { Published declarations }
    property ActiveDisplay;
    property Align;
    property Background;
    property Bands;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property BiDiMode;
    property Constraints;
    {$ENDIF}
    property Caption;
    property Color;
    property DayNames;
    property DefaultItem;
    property DirectMove;
    property Display;
    property DragItem;
    property EditRTF;
    property EditDirect;
    property EditScroll;
    property EnableAlarms;
    property EnableFlashing;
    property FlashColor;
    property FlashFontColor;
    property Flat;
    property Font;
    property GradientHorizontal;
    property GridPopup;
    property GridLeftCol;
    property GridLineColor;
    property GridTopRow;
    property Header;
    property HintColor;
    property HintOnItemChange;
    property HourType;
    property HTMLHint;
    property HTMLOptions;
    property InActiveDays;
    property IndicateNonVisibleItems;
    property InplaceEdit;
    property InsertAlways;
    property ItemChecker;
    property ItemGap;
    property ItemPopup;
    property Items;
    property ItemSelection;
    property Layer;
    property Mode;
    property MultiSelect;
    property NavigatorButtons;
    property SelectionAlways;
    property ShadowColor;
    property ShowHint;
    property Sidebar;
    property Overlap;
    property PictureContainer;
    property PlannerImages;
    property Positions;
    property PositionGap;
    property PositionGroup;
    property PositionProps;
    property PositionWidth;
    property PositionZoomWidth;
    property PrintOptions;
    property ScrollSmooth;
    property ScrollSynch;
    property ScrollBarStyle;
    property SelectBlend;
    property SelectColor;
    property TrackBump;
    property TrackColor;
    property TrackProportional;
    property TrackWidth;
    property URLColor;
    property Visible;
    {$IFDEF DELPHI5_LVL}
    property WheelDelta;
    {$ENDIF}
    property OnStartDrag;
    property OnEndDrag;
    property OnCaptionAnchorEnter;
    property OnCaptionAnchorExit;
    property OnCaptionAnchorClick;
    property OnCustomEdit;
    property OnCustomIndexToTime;
    property OnCustomTimeToIndex;
    property OnEnter;
    property OnExit;
    property OnItemAnchorClick;
    property OnItemAnchorEnter;
    property OnItemAnchorExit;
    property OnItemControlEditStart;
    property OnItemControlEditDone;
    property OnItemControlComboList;
    property OnItemControlClick;
    property OnItemControlComboSelect;
    property OnItemClipboardAction;
    property OnItemLeftClick;
    property OnItemRightClick;
    property OnItemDblClick;
    property OnItemDrag;
    property OnItemImageClick;
    property OnItemURLClick;
    property OnItemAlarm;
    property OnItemAttachementClick;
    property OnItemSize;
    property OnItemMove;
    property OnItemSizing;
    property OnItemMoving;
    property OnItemDelete;
    property OnItemInsert;
    property OnItemStartEdit;
    property OnItemEndEdit;
    property OnItemSelect;
    property OnItemEnter;
    property OnItemExit;
    property OnItemHint;
    property OnItemSelChange;
    property OnItemActivate;
    property OnItemDeActivate;
    property OnItemPlaceUpdate;
    property OnItemPopupPrepare;
    property OnItemText;
    property OnPlannerLeftClick;
    property OnPlannerRightClick;
    property OnPlannerDblClick;
    property OnPlannerKeyPress;
    property OnPlannerKeyDown;
    property OnPlannerKeyUp;
    property OnPlannerItemDraw;
    property OnPlannerBottomLine;
    property OnPlannerSideDraw;
    property OnPlannerGetSideBarLines;
    property OnPlannerBkgDraw;
    property OnPlannerHeaderDraw;
    property OnPlannerCaptionDraw;
    property OnPlannerNext;
    property OnPlannerPrev;
    property OnPlannerSelChange;
    property OnPlannerSelectCell;
    property OnPlannerMouseMove;
    property OnPlannerMouseUp;
    property OnPlannerMouseDown;
    property OnPlannerPositionZoom;
    property OnPlanTimeToStrings;
    property OnPositionToDay;
    property OnHeaderClick;
    property OnHeaderRightClick;
    property OnHeaderDblClick;
    property OnHeaderDragDrop;
    property OnHeaderStartEdit;
    property OnHeaderEndEdit;
    property OnTopLeftChanged;
    property OnPrintStart;
    property OnDragOver;
    property OnDragOverCell;
    property OnDragOverItem;
    property OnDragDrop;
    property OnDragDropCell;
    property OnDragDropItem;
    property OnGetCurrentTime;
  end;

  TPlannerIO = class(TComponent)
    FItems: TPlannerItems;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Items: TPlannerItems read FItems write FItems;
  end;

  TPlannerItemIO = class(TComponent)
    FItem: TPlannerItem;
  public
    constructor CreateItem(AOwner: TPlannerItems);
    destructor Destroy; override;
  published
    property Item: TPlannerItem read FItem write FItem;
  end;




{$R PLANNER.RES}

implementation

uses
  ShellApi, CommCtrl
{$IFDEF DELPHI4_LVL}
  , ImgList
{$ENDIF}

{$IFDEF TMSCODESITE}
  , CsIntf
{$ENDIF}
  ;



const
  ComCtrl = 'comctl32.dll';

  BtnWidth = 16;
  DaysPerWeek = 7;
  FirstDayOfWeek = 1;
  LastDayOfWeek = DaysPerWeek;

  ShortDaySun = 'Sun';
  ShortDayMon = 'Mon';
  ShortDayTue = 'Tue';
  ShortDayWed = 'Wed';
  ShortDayThu = 'Thu';
  ShortDayFri = 'Fri';
  ShortDaySat = 'Sat';

{$IFNDEF DELPHI4_LVL}
  //constant definitions for flat/encarta scrollbars}
  WSB_PROP_CYVSCROLL  = $0000001;
  WSB_PROP_CXHSCROLL  = $0000002;
  WSB_PROP_CYHSCROLL  = $0000004;
  WSB_PROP_CXVSCROLL  = $0000008;
  WSB_PROP_CXHTHUMB   = $0000010;
  WSB_PROP_CYVTHUMB   = $0000020;
  WSB_PROP_VBKGColOR  = $0000040;
  WSB_PROP_HBKGColOR  = $0000080;
  WSB_PROP_VSTYLE     = $0000100;
  WSB_PROP_HSTYLE     = $0000200;
  WSB_PROP_WINSTYLE   = $0000400;
  WSB_PROP_PALETTE    = $0000800;
  WSB_PROP_MASK       = $0000FFF;

  FSB_FLAT_MODE       =    2;
  FSB_ENCARTA_MODE    =    1;
  FSB_REGULAR_MODE    =    0;
{$ENDIF}

type
  PHeaderSection = ^THeaderSection;
  THeaderSection = record
    FObject: TObject;
    Width: Integer;
    Title: string;
  end;


function Max(a, b: Integer): Integer;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

function Min(a, b: Integer): Integer;
begin
  if a < b then
    Result := a
  else
    Result := b;
end;

function Clip(const Value: Integer; const RangeLow, RangeHigh: Integer): Integer;
begin
  if Value > RangeHigh then
    Result := RangeHigh
  else if Value < RangeLow then
    Result := RangeLow
  else
    Result := Value;
end;

type
  TColorRecord = record
    RedValue: Byte;    //  clRed = TColor($0000FF);   Low byte
    GreenValue: Byte;  //  clLime = TColor($00FF00);  Middle byte
    BlueValue: Byte;   //  clBlue = TColor($FF0000);  High byte
    SystemValue: Byte; //  becomes zero when calling ColorToRgb
  end;

//--> ok, indeed problem with syscolor in previous version,

function ColorToHtmlHexBgColor(const Value: TColor): string;
const
  HtmlHexBgColor = ' BGCOLOR="#RRGGBB"';

const
  HexDigit: array[0..$F] of Char = '0123456789ABCDEF';
begin
 //  HTML Color looks like this: #RRGGBB 
  with TColorRecord(ColorToRGb(Value)) do
  begin
    Result := HtmlHexBgColor;
    Result[12] := HexDigit[RedValue shr 4];
    Result[13] := HexDigit[RedValue and $F];
    Result[14] := HexDigit[GreenValue shr 4];
    Result[15] := HexDigit[GreenValue and $F];
    Result[16] := HexDigit[BlueValue shr 4];
    Result[17] := HexDigit[BlueValue and $F];
  end;
end;

const
  CStyleLF = '\n';
  RegularCRLF = #13#10;
  HtmlBreak = '<BR>';
  RtfStart = '{\';
  HtmlEndTagStart = '</';
  HtmlNonBreakingSpace = '&nbsp;';

function ReplaceCLFWith(const Value: string; const Replacement: string): string;
var
  CLFPos: Integer;
begin
  Result := Value;
  CLFPos := Pos(CStyleLF, Result);
  while CLFPos > 0 do
  begin
    Result := Copy(Result, 1, CLFPos - 1) +
      RegularCRLF +
      Copy(Result, CLFPos + 2, Length(Result));
    CLFPos := Pos(CStyleLF, Result);
  end;
end;

function CLFToLF(Value: string): string;
begin
  Result := ReplaceCLFWith(Value, RegularCRLF);
end;

function CLToBR(Value: string): string;
begin
  Result := ReplaceCLFWith(Value, HtmlBreak);
end;

function IsRtf(const Value: string): Boolean;
begin
  Result := (Pos(RtfStart, Value) = 1);
end;

function IsHtml(APlannerItem: TPlannerItem; const Value: string): Boolean;
begin
  Result := (Pos(HTMLEndTagStart, Value) > 0);
  if APlannerItem.InplaceEdit = peForm then
    Result := True;
end;

(*
function PlanTimeToStr(HourType: THourType; MinutesValue: Cardinal): string;
var
  Hours, Minutes: Integer;
begin
  Hours := MinutesValue div 60;
  Minutes := MinutesValue mod 60;
  Hours := Hours mod 24;

  if (HourType = ht12hrs) then
  begin
    if (Hours >= 12) then
      Result := TimePMString
    else
      Result := TimeAMString;
    Result := ' ' + Result;
    if (Hours > 12) then
      Hours := Hours - 12
  end
  else
    Result := '';

  Result := Format('%d%s%.2d%s', [Hours, TimeSeparator, Minutes, Result]);
end;
*)

{ TCustomPlanner }

constructor TCustomPlanner.Create(AOwner: TComponent);
var
  Bitmap: TBitmap;
  PlannerColorArrayPointer: PPlannerColorArray;
  ColorIndex: Integer;

begin
{$IFDEF ACTIVEXDEBUG}
  ShowMessage('TPlanner Create Start');
{$ENDIF}
  inherited Create(AOwner);
  Width := 300;
  Height := 250;
  FHTMLFactor := 1.0;
  FScrollDelay := 50;
  FFont := TFont.Create;
  FWheelDelta := 1;
  FFont.OnChange := PlanFontChanged;
  FRichEdit := TPlannerRichEdit.Create(Self);
  FNavigatorButtons := TNavigatorButtons.Create(Self);
  FHeader := TAdvHeader.Create(Self);
{$IFDEF DELPHI4_LVL}
  FHeader.DoubleBuffered := True;
{$ENDIF}
  FPrev := TAdvSpeedButton.Create(Self);
  FPrev.Direction := bdLeft;
  FNext := TAdvSpeedButton.Create(Self);
  FNext.Direction := bdRight;
  FMode := TPlannerMode.Create(Self);
  FGrid := TPlannerGrid.Create(Self);

  FGrid.Options := FGrid.Options - [goHorzLine];
{$IFDEF DELPHI4_LVL}
  FGrid.DoubleBuffered := False;
{$ENDIF}
  FPlannerHeader := TPlannerHeader.Create(Self);
  FPanel := TPlannerPanel.Create(Self);
{$IFDEF DELPHI4_LVL}
  FPanel.DoubleBuffered := True;
{$ENDIF}
  FBands := TBands.Create(Self);
  FCaption := TPlannerCaption.Create(Self);
  FSidebar := TPlannerSideBar.Create(Self);
  FDisplay := TPlannerDisplay.Create(Self);
  FPlannerItems := CreateItems;
  FPrintOptions := TPlannerPrintOptions.Create;
  FHTMLOptions := TPlannerHTMLOptions.Create;
  FScrollBarStyle := TPlannerScrollBar.Create(Self);
  FInactiveDays := TWeekDays.Create;
  FDefaultItems := CreateItems;
  FBackground := TBackground.Create(Self);
  FDefaultItem := FDefaultItems.Add;
  FInactiveDays.OnChanged := InactiveChanged;
  FImageCache := THTMLPictureCache.Create;
  FPositionProps := TPositionProps.Create(Self);

  FItemSelection := TPlannerItemSelection.Create;

  FFlat := True;
  FDrawPrecise := False;
  FRoundTime := False;

  FGrid.Visible := True;
  FGrid.Parent := Self;
  FGrid.ShowHint := True;
  FGrid.Ctl3D := False;
  FPanel.Visible := True;
  FPanel.Parent := Self;
  FPanel.BevelOuter := bvNone;
  FPanel.BevelInner := bvNone;
  FTrackColor := clBlue;
  FFlashColor := clRed;
  FFlashFontColor := clWhite;
  FTrackWidth := 4;
  FPositions := 3;
  FPositionWidth := 0;
  FPrinterDriverFix := False;
  FLayer := 0;
  FItemGap := 11;
  FColor := clWindow;
  FSelectBlend := 90;
  FGradientSteps := 32;
  FGradientHorizontal := False;
  FSelectColor := clHighLight;
  FGridLineColor := clGray;
  FInplaceEdit := ieAlways;
  FDayNames := TStringList.Create;

  FDayNames.Add(ShortDaySun);
  FDayNames.Add(ShortDayMon);
  FDayNames.Add(ShortDayTue);
  FDayNames.Add(ShortDayWed);
  FDayNames.Add(ShortDayThu);
  FDayNames.Add(ShortDayFri);
  FDayNames.Add(ShortDaySat);

  FHeader.Visible := True;
  FHeader.Parent := Self;
  FHeader.BorderStyle := bsNone;
  FHeader.AllowResize := False;
  FHeader.OnClick := HeaderClick;
  FHeader.OnRightClick := HeaderRightClick;
  FHeader.OnDblClick := HeaderDblClick;
  FHeader.OnDragDrop := HeaderDragDrop;
  FHeader.OnSized := HeaderSized;

  FPrev.Parent := Self;
  FNext.Parent := Self;
  FPrev.OnClick := PrevClick;
  FNext.OnClick := NextClick;

  Bitmap := TBitmap.Create;
  Bitmap.LoadFromResourceID(HInstance, 500);
  FPrev.Glyph.Assign(Bitmap);
  Bitmap.LoadFromResourceID(HInstance, 501);
  FNext.Glyph.Assign(Bitmap);
  Bitmap.Free;
  
  FShadowColor := clGray;
  FHintColor := clInfoBk;
  FHintOnItemChange := True;
  FTimerID := 0;
  FOverlap := True;
  FLoading := False;
  FURLColor := clBlue;
  FAutoItemScroll := True;
  FSelectionAlways := True;
  FInsertAlways := True;
{$IFDEF ACTIVEXDEBUG}
  ShowMessage('TPlanner Create Done');
{$ENDIF}

  while FGrid.ColorList.Count < FPositions do
  begin
    PlannerColorArrayPointer := FGrid.ColorList.Add;
    for ColorIndex := 0 to NumColors do
      PlannerColorArrayPointer^[ColorIndex] := clNone;
  end;

  FCompletionColor1 := clRed;
  FCompletionColor2 := clWhite;

  FDTList := TDateTimeList.Create;

  ControlStyle := ControlStyle + [csAcceptsControls];
end;

destructor TCustomPlanner.Destroy;
begin
  FDefaultItem.Free;
  FDefaultItem := nil;
  FDefaultItems.Free;
  FRichEdit.Free;
  FGrid.Free;
  FGrid := nil;
  FPanel.Free;
  FBands.Free;
  FCaption.Free;
  FSidebar.Free;
  FDisplay.Free;
  FPlannerHeader.Free;
  FPlannerItems.Free;
  FPlannerItems := nil;
  FMode.Free;
  FFont.Free;
  FHeader.Free;
  FNext.Free;
  FPrev.Free;
  FNavigatorButtons.Free;
  FScrollBarStyle.Free;
  FPrintOptions.Free;
  FHTMLOptions.Free;
  FDayNames.Free;
  FInactiveDays.Free;
  FBackground.Free;
  FImageCache.Free;
  FPositionProps.Free;
  FItemSelection.Free;
  FDTList.Free;
  inherited;
end;

procedure TCustomPlanner.Assign(Source: TPersistent);
begin
  if Assigned(Source) then
  begin
    Items.Assign((Source as TCustomPlanner).Items);
    Display.Assign((Source as TCustomPlanner).Display);
    SideBar.Assign((Source as TCustomPlanner).SideBar);
    Header.Assign((Source as TCustomPlanner).Header);
    Caption.Assign((Source as TCustomPlanner).Caption);
  end;
end;

function TCustomPlanner.GetBackGroundColor(ACol, ARow: Integer): TColor;
var
  PlannerColorArrayPointer: PPlannerColorArray;
begin
  if SideBar.Position = spTop then
  begin
    if (ARow < FGrid.ColorList.Count) then
    begin
      PlannerColorArrayPointer := FGrid.ColorList.Items[ARow];
      if (ACol < NumColors) then
        Result := PlannerColorArrayPointer^[ACol]
      else
        Result := clNone;
    end
    else
      Result := FGrid.Color;
  end
  else
  begin
    if (ACol < FGrid.ColorList.Count) then
    begin
      Result := clNone;
      PlannerColorArrayPointer := FGrid.ColorList.Items[ACol];
      if (ARow < NumColors) then
        Result := PlannerColorArrayPointer^[ARow];
    end
    else
      Result := FGrid.Color;
  end;
end;

procedure TCustomPlanner.SetBackGroundColor(ACol, ARow: Integer; const Value: TColor);
var
  PlannerColorArrayPointer: PPlannerColorArray;
begin
  if (ACol < 0) or
     (ARow < 0) or
     (ACol >= FGrid.ColCount) or
     (ARow >= FGrid.RowCount) then Exit;

  if SideBar.Position = spTop then
  begin
    if (ARow < FGrid.ColorList.Count) then
    begin
      PlannerColorArrayPointer := FGrid.ColorList.Items[ARow];
      if (ACol < NumColors) then
        PlannerColorArrayPointer^[ACol] := Value;
    end;
    FGrid.InvalidateCell(ACol, ARow + FSideBar.FRowOffset);
  end
  else
  begin
    if (ACol < FGrid.ColorList.Count) then
    begin
      PlannerColorArrayPointer := FGrid.ColorList.Items[ACol];
      if (ARow < NumColors) then
        PlannerColorArrayPointer^[ARow] := Value;
    end;
    FGrid.InvalidateCell(ACol + FSidebar.FColOffset, ARow);
  end;
end;

function TCustomPlanner.GetCellColorCol(Pos,Index: Integer): TColor;
var
  ABrush: TBrush;
  PlannerColorArrayPointer: PPlannerColorArray;
begin
  ABrush := TBrush.Create;
  GetCellBrush(Pos,Index,ABrush);
  Result := ABrush.Color;
  ABrush.Free;

  { Custom cell Color }
  if (Pos < FGrid.ColorList.Count) and (Pos >= 0) and
      (Index < NumColors) then
  begin
    PlannerColorArrayPointer := FGrid.FColorList.Items[Pos];
    if PlannerColorArrayPointer^[Index] <> clNone then
      Result := PlannerColorArrayPointer^[Index];
  end;

  if CellInCurrTime(Index,Pos) then
    Result := FDisplay.ColorCurrent;
end;

function TCustomPlanner.IsCurPos(APosition: Integer): Boolean;
begin
  Result := True;
  if (Display.CurrentPosFrom = -1) or (Display.CurrentPosTo = -1) then
    Exit;

  Result := (APosition >= Display.CurrentPosFrom) and
            (APosition <= Display.CurrentPosTo);
end;

function TCustomPlanner.IsActive(AIndex, APosition: Integer): Boolean;
var
  DateTime: TDateTime;
  ActiveStart,ActiveEnd,M,Y: Integer;
  UsePP: Boolean;

begin
  UsePP := (PositionProps.Count > APosition) and (APosition >= 0);
  if UsePP then
    UsePP := PositionProps.Items[APosition].Use;
  if UsePP then
  begin
    ActiveStart := PositionProps.Items[APosition].ActiveStart;
    ActiveEnd := PositionProps.Items[APosition].ActiveEnd;
  end
  else
  begin
    ActiveStart := FDisplay.ActiveStart;
    ActiveEnd := FDisplay.ActiveEnd;
  end;

  Result := True;

  case FMode.FPlannerType of
  plDay:
    Result := (AIndex < ActiveStart) or (AIndex >= ActiveEnd);
  plWeek:
    Result := ((AIndex - FMode.WeekStart) mod DaysPerWeek) in [0, 1];
  plMonth:
    begin
      DateTime := Mode.StartOfMonth + AIndex;
      Result := DayOfWeek(DateTime) in FInactive;
    end;
  plDayPeriod:
    begin
      DateTime := Mode.PeriodStartDate + AIndex;
      Result :=DayOfWeek(DateTime) in FInactive;
    end;
  plHalfDayPeriod:
    begin
      DateTime := Mode.PeriodStartDate + AIndex / 2;
      Result := DayOfWeek(DateTime) in FInactive;
    end;
  plMultiMonth:
    begin
      M := Mode.Month + APosition;
      Y := Mode.Year;
      while M > 12 do
      begin
        Dec(M,12);
        Inc(Y);
      end;
      if AIndex < DaysInMonth(M,Y) then
      begin
        DateTime := EncodeDate(Y,M,AIndex + 1);
        Result := DayOfWeek(DateTime) in FInactive;
      end;
    end;  
  plCustom, plCustomList:
    begin
      Result := False;
    end;
  plTimeLine:
    begin
      Result := False;    
    end;
  end;
  Result := not Result;

  if Assigned(FOnPlannerIsActive) then
    FOnPlannerIsActive(Self,AIndex, APosition, Result);
end;

procedure TCustomPlanner.GetCellBrush(Pos,Index: Integer; ABrush: TBrush);
var
  DateTime: TDateTime;
  ActiveStart,ActiveEnd,M,Y: Integer;
  ColorActive,ColorNonActive: TColor;
  UsePP: Boolean;

begin
  UsePP := (PositionProps.Count > Pos) and (Pos >= 0);
  if UsePP then
    UsePP := PositionProps.Items[Pos].Use;
  if UsePP then
  begin
    ColorActive := PositionProps.Items[Pos].ColorActive;
    ColorNonActive := PositionProps.Items[Pos].ColorNonActive;
    ActiveStart := PositionProps.Items[Pos].ActiveStart;
    ActiveEnd := PositionProps.Items[Pos].ActiveEnd;
  end
  else
  begin
    ColorActive := Self.Display.ColorActive;
    ColorNonActive := Self.Display.ColorNonActive;
    ActiveStart := FDisplay.ActiveStart;
    ActiveEnd := FDisplay.ActiveEnd;
  end;

  if FBands.Show then
  begin
    if Odd(Index) then
      ColorActive := FBands.ActivePrimary
    else
      ColorActive := FBands.ActiveSecondary;

    if Odd(Index) then
      ColorNonActive := FBands.NonActivePrimary
    else
      ColorNonActive := FBands.NonActiveSecondary;
  end;

  ABrush.Style := bsSolid;
  ABrush.Color := ColorActive;

  case FMode.FPlannerType of
    plDay:
      begin
        if (Index < ActiveStart) or (Index >= ActiveEnd) then
          ABrush.Color := ColorNonActive;
      end;
    plWeek:
      begin
        if ((Index - FMode.WeekStart) mod DaysPerWeek) in [0, 1] then
          ABrush.Color := ColorNonActive;
      end;
    plMonth:
      begin
        DateTime := Mode.StartOfMonth + Index;
        if DayOfWeek(DateTime) in FInactive then
          ABrush.Color := ColorNonActive;
      end;
    plDayPeriod:
      begin
        DateTime := Mode.PeriodStartDate + Index;
        if DayOfWeek(DateTime) in FInactive then
          ABrush.Color := ColorNonActive;
      end;
    plHalfDayPeriod:
      begin
        DateTime := Mode.PeriodStartDate + Index / 2;
        if DayOfWeek(DateTime) in FInactive then
          ABrush.Color := ColorNonActive;
      end;
    plMultiMonth:
      begin
        M := Mode.Month + Pos;
        Y := Mode.Year;
        while M > 12 do
        begin
          Dec(M,12);
          Inc(Y);
        end;

        if Index < DaysInMonth(M,Y) then
        begin
          DateTime := EncodeDate(Y,M,Index + 1);
          if DayOfWeek(DateTime) in FInactive then
            ABrush.Color := ColorNonActive;
        end;
      end;
    plCustom, plCustomList:
      begin
      end;
    plTimeLine:
      begin

      end;
  end;


  if UsePP then
  begin
    if PositionProps.Items[Pos].MinSelection > 0 then
    begin
      if  Index < PositionProps.Items[Pos].MinSelection then
      begin
        ABrush.Style := PositionProps.Items[Pos].BrushNoSelect;
        ABrush.Color := PositionProps.Items[Pos].ColorNoSelect;
      end;
    end;
    if PositionProps.Items[Pos].MaxSelection > 0 then
    begin
      if  Index >= PositionProps.Items[Pos].MaxSelection then
      begin
        ABrush.Style := PositionProps.Items[Pos].BrushNoSelect;
        ABrush.Color := PositionProps.Items[Pos].ColorNoSelect;
      end;
    end;
  end;

end;

procedure TCustomPlanner.Print;
begin
  PrintSelection(0,Positions - 1);
end;

procedure TCustomPlanner.PrintTo(ACanvas:TCanvas);
begin
  PrintSelectionTo(ACanvas,0, Positions - 1);
end;

procedure TCustomPlanner.PrintSelection(FromPos, ToPos: Integer);
begin
  with Printer do
  begin
    Title := FPrintOptions.JobName;
    Orientation := FPrintOptions.Orientation;
    BeginDoc;
    PrintSelectionTo(Canvas, FromPos, ToPos);
    EndDoc;
  end;
end;

procedure TCustomPlanner.PrintPages(NrOfPages: Integer);
var
  ItemsPerPage,i: Integer;
  FirstItem,LastItem: Integer;
  
begin
  if NrOfPages <= 0 then
    Exit;

  ItemsPerPage := (Display.DisplayEnd - Display.DisplayStart) div NrOfPages;

  with Printer do
  begin
    Title := FPrintOptions.JobName;
    Orientation := FPrintOptions.Orientation;
    BeginDoc;

    FirstItem := 0;
    LastItem := ItemsPerPage;

    for i := 1 to NrOfPages do
    begin
      PrintRangeTo(Printer.Canvas, 0, Positions - 1, FirstItem, LastItem);
      FirstItem := LastItem + 1;
      LastItem := LastItem + ItemsPerPage;
      if i < NrOfPages then
        NewPage;
    end;
    EndDoc;
  end;
end;


procedure TCustomPlanner.PrintSelectionTo(ACanvas:TCanvas;FromPos, ToPos: Integer);
begin
  if (FromPos > ToPos) then
    Exit;

  if Sidebar.Orientation = soVertical then
    PrintCol(ACanvas, FromPos, ToPos, 0, FGrid.RowCount - 1)
  else
    PrintRow(ACanvas, FromPos, ToPos, 0, FGrid.ColCount - 1);
end;

procedure TCustomPlanner.PrintRange(FromPos, ToPos, FromItem, ToItem: Integer);
begin
  with Printer do
  begin
    Title := FPrintOptions.JobName;
    Orientation := FPrintOptions.Orientation;
    BeginDoc;
    PrintRangeTo(Printer.Canvas, FromPos, ToPos, FromItem, ToItem);
    EndDoc;
  end;
end;

procedure TCustomPlanner.PrintRangeTo(ACanvas:TCanvas; FromPos, ToPos, FromItem, ToItem: Integer);
begin
  if Sidebar.Orientation = soVertical then
    PrintCol(ACanvas, FromPos, ToPos, FromItem, ToItem)
  else
    PrintRow(ACanvas, FromPos, ToPos, FromItem, ToItem);
end;


function PrinterDrawString(Canvas:TCanvas; Value: string; var Rect: TRect; Format: UINT): Integer;
begin
  if Assigned(Canvas) then
    Result := DrawText(Canvas.Handle, PChar(Value), Length(Value), Rect, Format)
  else
    Result := -1; // indicate failure
end;

{$IFDEF FREEWARE}
procedure PrintFreewareNotice(ACanvas:TCanvas; XSize, YSize: Integer; ClassName: string);
var
  DrawRect: TRect;
  LFont: TLogFont;
  HOldFont, HNewFont: HFont;
begin

  DrawRect.Left := 0;
  DrawRect.Right := XSize;
  DrawRect.Top := YSize shr 1;
  DrawRect.Bottom := YSize;

  ACanvas.Font.Size := 20;
  ACanvas.Font.Style := [fsBold];
  ACanvas.Font.Color := clSilver;

  GetObject(ACanvas.Font.Handle, SizeOf(LFont), Addr(LFont));
  LFont.lfEscapement := 45 * 10;
  LFont.lfOrientation := 45 * 10;

  HNewFont := CreateFontIndirect(LFont);
  HOldFont := SelectObject(ACanvas.Handle, HNewFont);

  SetTextAlign(ACanvas.Handle, TA_TOP);
  SetBkMode(ACanvas.Handle, TRANSPARENT);

  ACanvas.TextOut(XSize shr 2, (YSize shr 2) + (YSize shr 1), Format(COPYRIGHT, [ClassName]));

  HNewFont := SelectObject(ACanvas.Handle, HOldFont);
  DeleteObject(HNewFont);

end;
{$ENDIF}

function CanvasToHTMLFactor(ScreenCanvas,Canvas: TCanvas): Double;
begin
  Result := GetDeviceCaps(Canvas.Handle,LOGPIXELSX) / GetDeviceCaps(ScreenCanvas.Handle, LOGPIXELSX);
end;

procedure TCustomPlanner.PrintCol(ACanvas: TCanvas; FromPos, ToPos, FromRow, ToRow: Integer);
var
  XSize, YSize: Integer;
  PositionIndex, RowIndex, SubIndex, GroupIndex, ConflictingCellWidth: Integer;
  NumberOfConflicts: TPoint;
  DrawRect, ARect, NRect, SRect: TRect;
  APlannerItem: TPlannerItem;
  SideBarWidth, HeaderHeight, GroupHeight, Side: Integer;
  LeftIndent, TopIndent: Integer;
  ColumnWidth, ColumnHeight, GapWidth: Integer;
  PrintPositions, NumCols: Integer;
  DoDraw: Boolean;
  SizedCols: Boolean;
  BottomPen: TPen;
  hdr,a,sa,fa:string;
  XS, YS, ml, hl: Integer;
  cr,hr: TRect;
  CID,CV,CT:string;

begin
  PrintPositions := (ToPos - FromPos) + 1;

  if Assigned(FOnPrintStart) then
    FOnPrintStart(Self, ACanvas);

  // Get the paper dimensions
  XSize := ACanvas.ClipRect.Right - ACanvas.ClipRect.Left -
    FPrintOptions.FLeftMargin - FPrintOptions.FRightMargin;

  YSize := ACanvas.ClipRect.Bottom - ACanvas.ClipRect.Top -
    FPrintOptions.FHeaderSize - FPrintOptions.FFooterSize;

  FHTMLFactor := CanvasToHTMLFactor(Canvas,ACanvas);

  LeftIndent := FPrintOptions.FLeftMargin;
  TopIndent := FPrintOptions.FHeaderSize;

  SideBarWidth := 0;
  HeaderHeight := 0;
  GroupHeight := 0;

  if PositionGroup > 0 then
    GroupIndex := FromPos div PositionGroup
  else
    GroupIndex := 0;

  Side := 0;

  // Column Width
  if FSidebar.Visible then
    NumCols := PrintPositions + 1
  else
    NumCols := PrintPositions;

  SizedCols := (Round(FGrid.ColWidths[1] * (NumCols) {* FHTMLFactor}) > XSize);

  if SizedCols or FPrintOptions.FFitToPage then
    ColumnWidth := (XSize div NumCols)
  else
    ColumnWidth := Round(FGrid.ColWidths[1] {* FHTMLFactor});

  if (FPositionGap > 0) and (FSideBar.ShowInPositionGap) then
    GapWidth := Round(FPositionGap / FGrid.ColWidths[1] * ColumnWidth)
  else
    GapWidth := 0;

  // Row Height
  if FHeader.Visible then
    HeaderHeight := Round(YSize * (Header.Height / (FGrid.RowHeights[0] *
      (ToRow - FromRow + 1))));

  // Double header size when group captions need to be printed
  if FHeader.Visible and (PositionGroup > 0) then
    GroupHeight := HeaderHeight;

  YSize := YSize - HeaderHeight - GroupHeight;

  ColumnHeight := YSize div (ToRow - FromRow + 1);

  if FPrintOptions.CellHeight > 0 then
    ColumnHeight := FPrintOptions.CellHeight;

  if FPrintOptions.CellWidth > 0 then
    ColumnWidth := FPrintOptions.CellWidth;

  if (FPrintOptions.FHeader.Count > 0) then
  begin
    // Print Header over full size
    DrawRect.Left := LeftIndent;
    DrawRect.Right := XSize;
    DrawRect.Top := 0;
    DrawRect.Bottom := TopIndent;

    ACanvas.Font.Assign(FPrintOptions.FHeaderFont);
    PrinterDrawString(ACanvas,FPrintOptions.FHeader.Text, DrawRect,
      AlignToFlag(FPrintOptions.FHeaderAlignment));
  end;

  if (FPrintOptions.FFooter.Count > 0) then
  begin
    // Print footer over full size
    DrawRect.Left := LeftIndent;
    DrawRect.Right := XSize;
    DrawRect.Top := YSize + HeaderHeight + GroupHeight + FPrintOptions.FHeaderSize;
    DrawRect.Bottom := DrawRect.Top + FPrintOptions.FFooterSize;
    ACanvas.Font.Assign(FPrintOptions.FFooterFont);
    PrinterDrawString(ACanvas,FPrintOptions.FFooter.Text, DrawRect, AlignToFlag(FPrintOptions.FFooterAlignment));
  end;

  // Draw the SideBar
  if FSidebar.Visible then
  begin
    if SizedCols or FPrintOptions.FFitToPage then
    begin
      SideBarWidth := Round(XSize *
        (FGrid.ColWidths[0] / (FGrid.ColWidths[1] * (PrintPositions))));

      ColumnWidth := Trunc((XSize - SideBarWidth)/PrintPositions);
    end
    else
      SideBarWidth := Round(FGrid.ColWidths[0] {* FHTMLFactor});

    if FPrintOptions.SidebarWidth > 0 then
      SidebarWidth := FPrintOptions.SidebarWidth;

    Side := 1;

    for PositionIndex := FromRow to ToRow do
    begin
      DrawRect.Left := LeftIndent;
      DrawRect.Top := TopIndent + HeaderHeight + GroupHeight + ColumnHeight * (PositionIndex - FromRow);
      DrawRect.Right := DrawRect.Left + SideBarWidth;
      DrawRect.Bottom := DrawRect.Top + ColumnHeight;

      ACanvas.Font.Assign(Sidebar.Font);
      ACanvas.Brush.Color := Sidebar.Background;
      ACanvas.Pen.Color := ACanvas.Brush.Color;

      if PositionIndex = FromRow then
      begin
        ACanvas.MoveTo(DrawRect.Left, DrawRect.Top);
        ACanvas.LineTo(DrawRect.Right, DrawRect.Top);
      end;

      ACanvas.Rectangle(DrawRect.Left, DrawRect.Top, DrawRect.Right, DrawRect.Bottom);

      ACanvas.Pen.Color := SideBar.SeparatorLineColor;

      if PositionIndex = FromRow then
      begin
        ACanvas.MoveTo(DrawRect.Left, DrawRect.Top);
        ACanvas.LineTo(DrawRect.Right, DrawRect.Top);
      end;

      InflateRect(DrawRect, -1, -1);

      if (Assigned(FOnPlannerSideDraw)) then
        FOnPlannerSideDraw(Self, ACanvas, DrawRect, PositionIndex)
      else
        FGrid.PaintSideCol(ACanvas, DrawRect, PositionIndex, 0, False, True);

      ACanvas.Brush.Color := Color;
      ACanvas.Font.Assign(Font);
    end;
  end;

  // Draw the Header
  if FHeader.Visible then
  begin
    SetBkMode(ACanvas.Handle,TRANSPARENT);

    for PositionIndex := FromPos to ToPos do
    begin
      ACanvas.Font.Assign(Header.Font);

      if PositionGroup > 0 then
      begin
        if (PositionIndex mod PositionGroup = 0) or (PositionIndex = FromPos) then
        begin
          DrawRect.Left := LeftIndent + SideBarWidth + (ColumnWidth * (PositionIndex - FromPos));
          DrawRect.Top := 1 + TopIndent;
          DrawRect.Right := DrawRect.Left + ColumnWidth * (PositionGroup - (PositionIndex mod PositionGroup));

          if DrawRect.Right > LeftIndent + SideBarWidth + ColumnWidth * (1 + ToPos - FromPos) then
            DrawRect.Right := LeftIndent + SideBarWidth + ColumnWidth * (1 + ToPos - FromPos);

          DrawRect.Bottom := GroupHeight + TopIndent;

          RectLine(ACanvas, DrawRect, GridLineColor, 1);

          if Header.GroupCaptions.Count > GroupIndex then
          begin
            InflateRect(DrawRect, -1, -1);

            hdr := Header.GroupCaptions[GroupIndex];
            if pos('</',hdr) > 0 then
            begin
              HTMLDrawEx(ACanvas, hdr, DrawRect, PlannerImages, 0, 0, -1, -1, 1, False, False,
              True, False, True, False, False
              ,False
              , FHTMLFactor, URLColor, clNone, clNone, clGray, a, sa, fa, XS, YS, ml, hl, hr
              , cr, CID, CV, CT, FImageCache, FContainer, Handle
              );
            end
            else
              PrinterDrawString(ACanvas,CLFToLF(hdr), DrawRect,
                AlignToFlag(Header.Alignment));
          end;
          inc(GroupIndex);
        end;
      end;

      DrawRect.Left := LeftIndent + SideBarWidth + (ColumnWidth * (PositionIndex - FromPos));
      DrawRect.Top := 1 + TopIndent + GroupHeight;
      DrawRect.Right := DrawRect.Left + ColumnWidth;
      DrawRect.Bottom := HeaderHeight + GroupHeight + TopIndent;

      RectLine(ACanvas, DrawRect, GridLineColor, 1);


      InflateRect(DrawRect, -1, -1);

      DoDraw := True;

      if Assigned(FOnPlannerHeaderDraw) then
      begin
        Font := Self.Font;
        ACanvas.Brush.Color := FColor;
        ACanvas.Pen.Color := FHeader.FLineColor;
        ACanvas.Pen.Width := 1;
        FOnPlannerHeaderDraw(Self, ACanvas, DrawRect, PositionIndex + 1, DoDraw);
      end;

      if DoDraw then
      begin
        DrawRect.Bottom := DrawRect.Top + Round(HeaderHeight * Header.TextHeight /
          Header.Height);

        if Header.Captions.Count > PositionIndex + Side then
        begin
          hdr := Header.Captions[PositionIndex + 1];
          if pos('</',hdr) > 0 then
          begin
            HTMLDrawEx(ACanvas, hdr, DrawRect, PlannerImages, 0, 0, -1, -1, 1, False, False,
            True, False, True, False, False            
            ,False
            , FHTMLFactor, URLColor, clNone, clNone, clGray, a, sa, fa, XS, YS, ml, hl, hr
            , cr, CID, CV, CT, FImageCache, FContainer, Handle
            );
          end
          else
            PrinterDrawString(ACanvas,CLFToLF(hdr), DrawRect,
              AlignToFlag(Header.Alignment));
        end;    

        APlannerItem := Items.HeaderFirst(PositionIndex);
        while Assigned(APlannerItem) do
        begin
          DrawRect.Left := DrawRect.Left + 2;
          DrawRect.Right := DrawRect.Right - 2;
          DrawRect.Top := DrawRect.Bottom;
          DrawRect.Bottom := DrawRect.Top + Round(HeaderHeight * Header.ItemHeight /
            Header.Height);

          APlannerItem.FRepainted := False;
          {Paint full Items here}
          FGrid.PaintItemCol(ACanvas, DrawRect, APlannerItem, True, False);
          APlannerItem := Items.HeaderNext(PositionIndex);
        end;
      end;

    end;
  end;

  // Draw the background cells
  for RowIndex := FromRow to ToRow do
    for PositionIndex := FromPos to ToPos do
    begin
      // nr. of Items at cell
      NumberOfConflicts := Items.NumItem(RowIndex, RowIndex, PositionIndex);

      // Cell bounding rect
      DrawRect.Left := LeftIndent + SideBarWidth + ColumnWidth * (PositionIndex - FromPos);
      DrawRect.Top := TopIndent + HeaderHeight + GroupHeight + ColumnHeight * (RowIndex - FromRow);
      DrawRect.Right := DrawRect.Left + ColumnWidth;
      DrawRect.Bottom := DrawRect.Top + ColumnHeight;
      RectLineEx(ACanvas, DrawRect, GridLineColor, 1);

      BottomPen := TPen.Create;
      BottomPen.Assign(ACanvas.Pen);

      BottomPen.Width := 1;
      BottomPen.Color := GridLineColor;

      if Assigned(FOnPlannerBottomLine) then
        FOnPlannerBottomLine(Self, RowIndex, PositionIndex, BottomPen);

      GetCellBrush(PositionIndex,RowIndex,ACanvas.Brush);
      ACanvas.Pen.Color := BottomPen.Color;
      ACanvas.Pen.Width := BottomPen.Width;
      ACanvas.MoveTo(DrawRect.Left, DrawRect.Bottom);
      ACanvas.LineTo(DrawRect.Right, DrawRect.Bottom);
      BottomPen.Free;

      ACanvas.Pen.Color := GridLineColor;

      ACanvas.Pen.Width := 1;

      if GapWidth > 0 then
      begin
        SRect := DrawRect;
        SRect.Right := SRect.Left + GapWidth;
        RectLine(ACanvas, SRect, GridLineColor, 1);
        InflateRect(SRect, -1, -1);
        ACanvas.Rectangle(SRect.Left, SRect.Top, SRect.Right, SRect.Bottom);
        FGrid.PaintSideCol(ACanvas, SRect, RowIndex, PositionIndex, False, True);
        DrawRect.Left := DrawRect.Left + GapWidth;
      end;

      if (BackGroundColor[PositionIndex, RowIndex] <> clNone) then
        ACanvas.Brush.Color := BackGroundColor[PositionIndex, RowIndex];

      InflateRect(DrawRect, -1, -1);
      ACanvas.FillRect(DrawRect);
      ACanvas.Brush.Color := Color;

      APlannerItem := Items.FindBackground(RowIndex, PositionIndex);

      if Assigned(APlannerItem) then
      begin
        ARect := DrawRect;
        InflateRect(ARect,1,1);
        NRect.Top := ARect.Top -
          ((RowIndex - APlannerItem.ItemBegin) * (ARect.Bottom - ARect.Top));
        NRect.Bottom := ARect.Bottom +
          ((APlannerItem.ItemEnd - RowIndex - 1) * (ARect.Bottom - ARect.Top));
        NRect.Left := ARect.Left;
        NRect.Right := ARect.Right;

        APlannerItem.Repainted := False;
        FGrid.PaintItemCol(ACanvas, NRect, APlannerItem, True, False);
      end;

      if (Assigned(FOnPlannerBkgDraw)) then
        FOnPlannerBkgDraw(Self, ACanvas, DrawRect, RowIndex, PositionIndex);
    end;

  // Draw the normal cells
  for RowIndex := FromRow to ToRow do
    for PositionIndex := FromPos to ToPos do
    begin
      // nr. of Items at cell
      NumberOfConflicts := Items.NumItem(RowIndex, RowIndex, PositionIndex);

      // Cell bounding rect
      DrawRect.Left := LeftIndent + SideBarWidth + GapWidth + ColumnWidth * (PositionIndex - FromPos);
      DrawRect.Top := TopIndent + HeaderHeight + GroupHeight + ColumnHeight * (RowIndex - FromRow);
      DrawRect.Right := DrawRect.Left + ColumnWidth - GapWidth;
      DrawRect.Bottom := DrawRect.Top + ColumnHeight;

      for SubIndex := 0 to NumberOfConflicts.Y do
      begin
        ARect := DrawRect;
        //InflateRect(ARect,1,1);
        if (NumberOfConflicts.Y > 0) then
        begin
          ConflictingCellWidth := (ARect.Right - ARect.Left) div (NumberOfConflicts.Y);
          ARect.Left := ARect.Left + SubIndex * ConflictingCellWidth;
          ARect.Right := ARect.Left + ConflictingCellWidth;
        end;

        APlannerItem := Items.FindItemIndex(RowIndex, PositionIndex, SubIndex);
        if (APlannerItem <> nil) then
        begin
          NRect.Top := ARect.Top -
            ((RowIndex - APlannerItem.ItemBegin) * (ARect.Bottom - ARect.Top));
          NRect.Bottom := ARect.Bottom +
            ((APlannerItem.ItemEnd - RowIndex - 1) * (ARect.Bottom - ARect.Top));
          NRect.Left := ARect.Left;
          NRect.Right := ARect.Right;
          APlannerItem.Repainted := False;
          FGrid.PaintItemCol(ACanvas, NRect, APlannerItem, True, False);
          ARect.Left := ARect.Right - FItemGap;
          {item found, paint only extra rect at Right}
        end;
      end;
    end;


  FHTMLFactor := 1.0;

{$IFDEF FREEWARE}
  PrintFreewareNotice(ACanvas, XSize, YSize, Self.ClassName);
{$ENDIF}
end;

procedure TCustomPlanner.PrintRow(ACanvas:TCanvas; FromPos, ToPos, FromCol, ToCol: Integer);
var
  XSize, YSize: Integer;
  PositionIndex, ColIndex, SubIndex, ConflictingCellWidth: Integer;
  NumberOfConflicts: TPoint;
  DrawRect, ARect, NRect: TRect;
  APlannerItem: TPlannerItem;
  SideBarWidth, HeaderHeight, GroupHeight, GroupIndex: Integer;
  LeftIndent, TopIndent: Integer;
  ColumnWidth, ColumnHeight: Integer;
  PrintPositions, NumRows: Integer;
  DoDraw: Boolean;
  SizedRows: Boolean;
  BottomPen: TPen;
  HeadIndent,MaxRight: Integer;
  hdr,a,sa,fa:string;
  XS, YS, ml, hl: Integer;
  cr,hr: TRect;
  CID,CV,CT:string;
  
begin
  PrintPositions := (ToPos - FromPos) + 1;


  if Assigned(FOnPrintStart) then
    FOnPrintStart(Self, ACanvas);

  XSize := ACanvas.ClipRect.Right - ACanvas.ClipRect.Left -
    FPrintOptions.FLeftMargin - FPrintOptions.FRightMargin;
  YSize := ACanvas.ClipRect.Bottom - ACanvas.ClipRect.Top -
    FPrintOptions.FHeaderSize - FPrintOptions.FFooterSize;

  FHTMLFactor := CanvasToHTMLFactor(Canvas,ACanvas);

  if FSidebar.Visible then
    NumRows := PrintPositions + 1
  else
    NumRows := PrintPositions;

  SizedRows := (Round(FGrid.RowHeights[1] * NumRows {* FHTMLFactor}) > YSize);

  if SizedRows or FPrintOptions.FFitToPage then
    ColumnHeight := (YSize div NumRows)
  else
    ColumnHeight := Round(FGrid.RowHeights[1] {* FHTMLFactor});

  LeftIndent := FPrintOptions.FLeftMargin;
  TopIndent := FPrintOptions.FHeaderSize;

  HeadIndent := LeftIndent;

  // Draw Header
  if FPrintOptions.FHeader.Count > 0 then
  begin
    DrawRect.Left := LeftIndent;
    DrawRect.Right := XSize;
    DrawRect.Top := 0;
    DrawRect.Bottom := TopIndent;
    ACanvas.Font.Assign(FPrintOptions.FHeaderFont);
    SetBkMode(ACanvas.Handle,TRANSPARENT);
    PrinterDrawString(ACanvas,FPrintOptions.FHeader.Text, DrawRect,
      AlignToFlag(FPrintOptions.FHeaderAlignment));
  end;

  // Draw Footer
  if FPrintOptions.FFooter.Count > 0 then
  begin
    DrawRect.Left := LeftIndent;
    DrawRect.Right := XSize;
    DrawRect.Top := YSize;
    DrawRect.Bottom := YSize + FPrintOptions.FFooterSize;

    DrawRect.Top := YSize + FPrintOptions.FHeaderSize;
    DrawRect.Bottom := DrawRect.Top +   FPrintOptions.FFooterSize;

    ACanvas.Font.Assign(FPrintOptions.FFooterFont);
    SetBkMode(ACanvas.Handle,TRANSPARENT);
    PrinterDrawString(ACanvas,FPrintOptions.FFooter.Text, DrawRect,
      AlignToFlag(FPrintOptions.FFooterAlignment));
  end;

  SideBarWidth := 0;
  GroupHeight := 0;
  
  if PositionGroup > 0 then
    GroupIndex := FromPos div PositionGroup
  else
    GroupIndex := 0;


  HeaderHeight := Round(XSize * (Header.Height / (FGrid.ColWidths[0] *
    (ToCol - FromCol + 1))));

  if FHeader.Visible and (PositionGroup > 0) then
    GroupHeight := HeaderHeight;

  // XSize := XSize - HeaderHeight - GroupHeight;

  ColumnWidth := (XSize - HeaderHeight - GroupHeight) div (ToCol - FromCol + 1);

  if FPrintOptions.CellHeight > 0 then
    ColumnHeight := FPrintOptions.CellHeight;

  if FPrintOptions.CellWidth > 0 then
    ColumnWidth := FPrintOptions.CellWidth;

  // Print the SideBar on Top
  if Sidebar.Visible then
  begin
    if SizedRows or FPrintOptions.FitToPage then
      SideBarWidth := Round(YSize * (FGrid.RowHeights[0] / (FGrid.RowHeights[1]
        * (PrintPositions))))
    else
      SideBarWidth := Round(FGrid.RowHeights[0] {* FHTMLFactor});

    if FPrintOptions.SidebarWidth > 0 then
      SidebarWidth := FPrintOptions.SidebarWidth;

    for ColIndex := FromCol to ToCol do
    begin
      DrawRect.Top := TopIndent;
      DrawRect.Left := LeftIndent + HeaderHeight + ColumnWidth * (ColIndex - FromCol);
      DrawRect.Bottom := DrawRect.Top + SideBarWidth;
      DrawRect.Right := DrawRect.Left + ColumnWidth;

      ACanvas.Font.Assign(Sidebar.Font);
      ACanvas.Brush.Color := Sidebar.Background;
      ACanvas.Pen.Color := ACanvas.Brush.Color;

      ACanvas.Rectangle(DrawRect.Left, DrawRect.Top, DrawRect.Right, DrawRect.Bottom);

      InflateRect(DrawRect, -1, -1);

      ACanvas.Pen.Color := SideBar.SeparatorLineColor;
      ACanvas.Pen.Width := 1;

      if (Assigned(FOnPlannerSideDraw)) then
        FOnPlannerSideDraw(Self, ACanvas, DrawRect, ColIndex)
      else
        FGrid.PaintSideRow(ACanvas, DrawRect, ColIndex, 0, False, True);

      ACanvas.Brush.Color := Color;
      ACanvas.Font.Assign(Font);
    end;
  end;

  // Draw the Header
  if FHeader.Visible then
  begin
    SetBkMode(ACanvas.Handle,TRANSPARENT);
    for PositionIndex := FromPos to ToPos do
    begin
      ACanvas.Font.Assign(Header.Font);

      if PositionGroup > 0 then
      begin
        if (PositionIndex mod PositionGroup = 0) or (PositionIndex = FromPos) then
        begin
          DrawRect.Top := TopIndent + SideBarWidth + (ColumnHeight * (PositionIndex - FromPos));
          DrawRect.Left := 1 + LeftIndent;
          DrawRect.Right := (GroupHeight shr 1) + LeftIndent;
          DrawRect.Bottom := DrawRect.Top + ColumnHeight * (PositionGroup - (PositionIndex mod PositionGroup));

          if DrawRect.Bottom > TopIndent + SideBarWidth + ColumnHeight * (1 + ToPos - FromPos) then
            DrawRect.Bottom := TopIndent + SideBarWidth + ColumnHeight * (1 + ToPos - FromPos);

          RectLine(ACanvas, DrawRect, GridLineColor, 1);

          if Header.GroupCaptions.Count > GroupIndex then
          begin
            InflateRect(DrawRect, -1, -1);

            hdr := Header.GroupCaptions[GroupIndex];
            if pos('</',hdr) > 0 then
            begin
              HTMLDrawEx(ACanvas, hdr, DrawRect, PlannerImages, 0, 0, -1, -1, 1, False, False,
              True, False, True, False, False
              ,False
              , FHTMLFactor, URLColor, clNone, clNone, clGray, a, sa, fa, XS, YS, ml, hl, hr
              , cr, CID, CV, CT, FImageCache, FContainer, Handle
              );
            end
            else
              PrinterDrawString(ACanvas,CLFToLF(hdr), DrawRect,
                AlignToFlag(Header.Alignment));
          end;
          inc(GroupIndex);
        end;
      end;

      DrawRect.Top := TopIndent + SideBarWidth + ColumnHeight * (PositionIndex - FromPos);
      DrawRect.Left := 1 + LeftIndent + (GroupHeight shr 1);
      DrawRect.Bottom := DrawRect.Top + ColumnHeight;
      DrawRect.Right := HeaderHeight + LeftIndent;
      RectLine(ACanvas, DrawRect, GridLineColor, 1);

      HeadIndent := DrawRect.Right;

      InflateRect(DrawRect, -1, -1);

      DoDraw := True;
      if Assigned(FOnPlannerHeaderDraw) then
      begin
        Font := Self.Font;
        ACanvas.Brush.Color := FColor;
        ACanvas.Pen.Color := FHeader.FLineColor;
        ACanvas.Pen.Width := 1;
        FOnPlannerHeaderDraw(Self, ACanvas, DrawRect, PositionIndex + 1, DoDraw);
      end;

      if DoDraw then
      begin
        DrawRect.Bottom := DrawRect.Top + Round(HeaderHeight * Header.TextHeight /
          Header.Height);

        if FSidebar.Visible then
        begin
          if Header.GroupCaptions.Count > PositionIndex + 1 then
          begin

            hdr := Header.GroupCaptions[PositionIndex + 1];
            if pos('</',hdr) > 0 then
            begin
              HTMLDrawEx(ACanvas, hdr, DrawRect, PlannerImages, 0, 0, -1, -1, 1, False, False,
              True, False, True, False, False
              ,False
              , FHTMLFactor, URLColor, clNone, clNone, clGray, a, sa, fa, XS, YS, ml, hl, hr
              , cr, CID, CV, CT, FImageCache, FContainer, Handle
              );
            end
            else
              PrinterDrawString(ACanvas,CLFToLF(Header.Captions[PositionIndex + 1]),
                DrawRect, AlignToFlag(Header.Alignment))
          end;       
        end
        else
        begin
          if Header.Captions.Count > PositionIndex then
            PrinterDrawString(ACanvas,Header.Captions[PositionIndex],
              DrawRect, AlignToFlag(Header.Alignment));
        end;

        APlannerItem := Items.HeaderFirst(PositionIndex);
        while Assigned(APlannerItem) do
        begin
          DrawRect.Left := DrawRect.Left + 2;
          DrawRect.Right := DrawRect.Right - 2;
          DrawRect.Top := DrawRect.Bottom;
          DrawRect.Bottom := DrawRect.Top + Round(HeaderHeight * Header.ItemHeight /
            Header.Height);

          APlannerItem.FRepainted := False;
          {Paint full Items here}
          FGrid.PaintItemCol(Canvas, DrawRect, APlannerItem, True, False);
          APlannerItem := Items.HeaderNext(PositionIndex);
        end;
      end;

    end;
  end;

  // Draw the background cells

  for ColIndex := FromCol to ToCol do
    for PositionIndex := FromPos to ToPos do
    begin
      // Nr. of Items at cell
      NumberOfConflicts := Items.NumItem(ColIndex, ColIndex, PositionIndex);

      // Cell bounding rect
      DrawRect.Top := TopIndent + SideBarWidth + ColumnHeight * (PositionIndex - FromPos);
      DrawRect.Left := LeftIndent + HeaderHeight + ColumnWidth * (ColIndex - FromCol);
      DrawRect.Bottom := DrawRect.Top + ColumnHeight;
      DrawRect.Right := DrawRect.Left + ColumnWidth;

      if DrawRect.Left < HeadIndent then
        DrawRect.Left := HeadIndent;

      if DrawRect.Right > XSize then
        DrawRect.Right := XSize;

      GetCellBrush(PositionIndex,ColIndex,ACanvas.Brush);

      if BackGroundColor[ColIndex,PositionIndex] <> clNone then
        ACanvas.Brush.Color := BackGroundColor[ColIndex,PositionIndex];

      RectLineExEx(ACanvas, DrawRect, GridLineColor, 1);

      BottomPen := TPen.Create;
      BottomPen.Assign(ACanvas.Pen);

      BottomPen.Width := 1;
      BottomPen.Color := GridLineColor;

      if Assigned(FOnPlannerBottomLine) then
        FOnPlannerBottomLine(Self, ColIndex, PositionIndex, BottomPen);

      ACanvas.Pen.Color := BottomPen.Color;
      ACanvas.Pen.Width := BottomPen.Width;
      ACanvas.MoveTo(DrawRect.Right, DrawRect.Top);
      ACanvas.LineTo(DrawRect.Right, DrawRect.Bottom);
      ACanvas.Pen.Width := 1;
      BottomPen.Free;

      InflateRect(DrawRect, -1, -1);
      ACanvas.FillRect(DrawRect);
      ACanvas.Brush.Color := Color;

      if ColIndex = ToCol then
      begin
        ACanvas.MoveTo(DrawRect.Right, DrawRect.Top);
        ACanvas.LineTo(DrawRect.Right, DrawRect.Bottom);
      end;

      if PositionIndex = ToPos then
      begin
        ACanvas.MoveTo(DrawRect.Left, DrawRect.Bottom);
        ACanvas.LineTo(DrawRect.Right, DrawRect.Bottom);
      end;

      APlannerItem := Items.FindBackground(ColIndex , PositionIndex);

      if Assigned(APlannerItem) then
      begin
        ARect := DrawRect;
        InflateRect(DrawRect, 1, 1);

        NRect.Left := ARect.Left - ((ColIndex - APlannerItem.ItemBegin) * (ARect.Right -
           ARect.Left));
        NRect.Right := ARect.Right + ((APlannerItem.ItemEnd - ColIndex - 1) * (ARect.Right
           - ARect.Left));
        NRect.Top := ARect.Top;
        NRect.Bottom := ARect.Bottom;

        if NRect.Left < HeadIndent then
          NRect.Left := HeadIndent;

        if NRect.Right > XSize then
          NRect.Right := XSize;

        APlannerItem.Repainted := False;
        FGrid.PaintItemRow(ACanvas, NRect, APlannerItem, True, False);
      end;
    end;

  // Draw the normal cells
  for ColIndex := FromCol to ToCol do
    for PositionIndex := FromPos to ToPos do
    begin
      // Nr. of Items at cell
      NumberOfConflicts := Items.NumItem(ColIndex, ColIndex, PositionIndex);

      // Cell bounding rect
      DrawRect.Top := TopIndent + SideBarWidth + ColumnHeight * (PositionIndex - FromPos);
      DrawRect.Left := LeftIndent + HeaderHeight + ColumnWidth * (ColIndex - FromCol);
      DrawRect.Bottom := DrawRect.Top + ColumnHeight;
      DrawRect.Right := DrawRect.Left + ColumnWidth;

      if DrawRect.Left < HeadIndent then
        DrawRect.Left := HeadIndent;

      for SubIndex := 0 to NumberOfConflicts.Y do
      begin
        ARect := DrawRect;
        InflateRect(DrawRect, 1, 1);

        if (NumberOfConflicts.Y > 0) then
        begin
          ConflictingCellWidth := (ARect.Bottom - ARect.Top) div (NumberOfConflicts.Y);
          ARect.Top := ARect.Top + SubIndex * ConflictingCellWidth;
          ARect.Bottom := ARect.Top + ConflictingCellWidth;
        end;

        APlannerItem := Items.FindItemIndex(ColIndex, PositionIndex, SubIndex);

        if (APlannerItem <> nil) then
        begin
          NRect.Left := ARect.Left - ((ColIndex - APlannerItem.ItemBegin) * (ARect.Right -
            ARect.Left));
          NRect.Right := ARect.Right + ((APlannerItem.ItemEnd - ColIndex - 1) * (ARect.Right
            - ARect.Left));

          NRect.Top := ARect.Top;
          NRect.Bottom := ARect.Bottom;
          APlannerItem.Repainted := False;

          if NRect.Left < HeadIndent then
            NRect.Left := HeadIndent;

          if NRect.Right > XSize then
            NRect.Right := XSize;

          FGrid.PaintItemRow(ACanvas, NRect, APlannerItem, True, False);
          ARect.Left := ARect.Right - FItemGap;
          // Item found, paint only extra rect at Right
        end;
      end;

    end;


  FHTMLFactor := 1.0;

{$IFDEF FREEWARE}
  PrintFreewareNotice(ACanvas, XSize, YSize, Self.ClassName);
{$ENDIF}

end;

function TCustomPlanner.GetDayName(WeekDay: Integer): string;
begin
  if (WeekDay > DaysPerWeek) then
    WeekDay := WeekDay mod DaysPerWeek;

  while (WeekDay < FirstDayOfWeek) do
    WeekDay := WeekDay + DaysPerWeek;

  if (WeekDay <= FDayNames.Count) and (WeekDay > 0) then
    Result := FDayNames.Strings[WeekDay - 1]
  else
    case WeekDay of
      1: Result := ShortDaySun;
      2: Result := ShortDayMon;
      3: Result := ShortDayTue;
      4: Result := ShortDayWed;
      5: Result := ShortDayThu;
      6: Result := ShortDayFri;
      7: Result := ShortDaySat;
    end;
end;

procedure TCustomPlanner.SelectGrid;
begin
  if Assigned(Items.Selected) then
    Items.Selected.Focus := False;
  Items.Selected := nil;
  FGrid.SetFocus;
end;

function TCustomPlanner.RichToText: string;
var
  MemoryStream: TMemoryStream;
begin
  Result := '';
  MemoryStream := TMemoryStream.Create;
  FRichEdit.Lines.SaveToStream(MemoryStream);
  MemoryStream.Position := 0;
  if MemoryStream.Size > 0 then
    SetString(Result, PChar(MemoryStream.Memory), MemoryStream.Size);
  MemoryStream.Free;
  Result := Result;
end;

procedure TCustomPlanner.SetGridLineColor(const Value: TColor);
begin
  if Value <> GridLineColor then
  begin
    FGridLineColor := Value;
    FGrid.Invalidate;
  end;
end;

procedure TCustomPlanner.SetColor(const Value: TColor);
begin
  if Value <> Color then
  begin
    FColor := Value;
    FGrid.Color := FColor;
    FGrid.Invalidate;
  end;
end;

procedure TCustomPlanner.TextToRich(const RtfText: string);
var
  MemoryStream: TMemoryStream;
begin
  if (RtfText <> '') then
  begin
    MemoryStream := TMemoryStream.Create;
    MemoryStream.Write(RtfText[1], Length(RtfText));
    MemoryStream.Position := 0;
    FRichEdit.Lines.LoadFromStream(MemoryStream);
    MemoryStream.Free;
  end
  else
    FRichEdit.Clear;
end;

procedure TCustomPlanner.SaveToFile(FileName: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TCustomPlanner.LoadFromFile(FileName: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TCustomPlanner.InsertFromFile(FileName: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    InsertFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TCustomPlanner.SavePositionToStream(Stream: TStream; Position: Integer);
var
  NewItems: TPlannerItems;
  ItemIndex: Integer;
  PlannerIO: TPlannerIO;

begin
  Items.SetTimeTags;

//  NewItems := TPlannerItems.Create(Self);
  NewItems := CreateItems;
  try
    for ItemIndex := 0 to Items.Count - 1 do
    begin
      if Items.Items[ItemIndex].ItemPos = Position then
      begin
        NewItems.Add.Assign(Items.Items[ItemIndex]);
      end;
    end;

    PlannerIO := TPlannerIO.Create(Self);
    try
      PlannerIO.Items.Assign(NewItems);
      Stream.WriteComponent(PlannerIO);
    finally
      PlannerIO.Free;
    end;
  finally
    NewItems.Free;
  end;
end;

procedure TCustomPlanner.LoadPositionFromStream(Stream: TStream; Position: Integer);
var
  NewItems: TPlannerItems;
  PlannerIO: TPlannerIO;
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;

begin
  PlannerIO := TPlannerIO.Create(Self);
  try
    Stream.ReadComponent(PlannerIO);
//    NewItems := TPlannerItems.Create(Self);
    NewItems := CreateItems;
    try
      NewItems.Assign(PlannerIO.Items);
      Items.BeginUpdate;
      for ItemIndex := 0 to NewItems.Count - 1 do
      begin
        NewItems.Items[ItemIndex].ItemPos := Position;
        APlannerItem := Items.Add;
        APlannerItem.Assign(NewItems.Items[ItemIndex]);
        APlannerItem.GetTimeTag;
      end;

    finally
      Items.EndUpdate;
      NewItems.Free;
    end;
  finally
    PlannerIO.Free;
  end;
end;

procedure TCustomPlanner.SavePositionToFile(FileName: string; Position: Integer);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    SavePositionToStream(FileStream, Position);
  finally
    FileStream.Free;
  end;
end;

procedure TCustomPlanner.LoadPositionFromFile(FileName: string; Position: Integer);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadPositionFromStream(FileStream, Position);
  finally
    FileStream.Free;
  end;
end;

procedure TCustomPlanner.SaveLayerToStream(Stream: TStream; Layer: Integer);
var
  NewItems: TPlannerItems;
  ItemIndex: Integer;
  PlannerIO: TPlannerIO;
begin
  Items.SetTimeTags;
//  NewItems := TPlannerItems.Create(Self);
  NewItems := CreateItems;
  try
    for ItemIndex := 0 to Items.Count - 1 do
    begin
      if Items.Items[ItemIndex].Layer = Layer then
      begin
        NewItems.Add.Assign(Items.Items[ItemIndex]);
      end;
    end;

    PlannerIO := TPlannerIO.Create(Self);
    try
      PlannerIO.Items.Assign(NewItems);
      Stream.WriteComponent(PlannerIO);
    finally
      PlannerIO.Free;
    end;
  finally
    NewItems.Free;
  end;
end;

procedure TCustomPlanner.LoadLayerFromStream(Stream: TStream; Layer: Integer);
var
  NewItems: TPlannerItems;
  PlannerIO: TPlannerIO;
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  PlannerIO := TPlannerIO.Create(Self);
  try
    Stream.ReadComponent(PlannerIO);
//    NewItems := TPlannerItems.Create(Self);
    NewItems := CreateItems;
    try
      NewItems.Assign(PlannerIO.Items);
      Items.BeginUpdate;
      for ItemIndex := 0 to NewItems.Count - 1 do
      begin
        NewItems.Items[ItemIndex].Layer := Layer;
        APlannerItem := Items.Add;
        APlannerItem.Assign(NewItems.Items[ItemIndex]);
        APlannerItem.GetTimeTag;
      end;
    finally
      Items.EndUpdate;
      NewItems.Free;
    end;
  finally
    PlannerIO.Free;
  end;
end;

procedure TCustomPlanner.SaveLayerToFile(FileName: string; Layer: Integer);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveLayerToStream(FileStream, Layer);
  finally
    FileStream.Free;
  end;
end;

procedure TCustomPlanner.LoadLayerFromFile(FileName: string; Layer: Integer);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadLayerFromStream(FileStream, Layer);
  finally
    FileStream.Free;
  end;
end;

procedure TCustomPlanner.SaveToStream(Stream: TStream);
var
  PlannerIO: TPlannerIO;
begin
  //save ItemBegin / ItemEnd correct for current display unit
  Items.BeginUpdate;
  Items.SetTimeTags;

  PlannerIO := TPlannerIO.Create(Self);
  try
    PlannerIO.Items.Assign(Self.Items);
    Stream.WriteComponent(PlannerIO);
  finally
    PlannerIO.Free;
  end;
  Items.EndUpdate;
end;

procedure TCustomPlanner.LoadFromStream(Stream: TStream);
var
  PlannerIO: TPlannerIO;
begin
  FLoading := True;
  try
    PlannerIO := TPlannerIO.Create(Self);
    try
      Stream.ReadComponent(PlannerIO);
      Items.Assign(PlannerIO.Items);
    finally
      PlannerIO.Free;
    end;
    Items.SetConflicts;
  finally
    FLoading := False;
  end;

  Items.BeginUpdate;
  Items.GetTimeTags;
  Items.OffsetItems(0);
  Items.EndUpdate;
end;

procedure TCustomPlanner.InsertFromStream(Stream: TStream);
var
  PlannerIO: TPlannerIO;
  NewItems: TPlannerItems;
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  PlannerIO := TPlannerIO.Create(Self);
  try
    Stream.ReadComponent(PlannerIO);

//    NewItems := TPlannerItems.Create(Self);
    NewItems := CreateItems;
    try
      NewItems.Assign(PlannerIO.Items);
      Items.BeginUpdate;

      for ItemIndex := 1 to NewItems.Count do
      begin
        APlannerItem := Items.Add;
        APlannerItem.Assign(NewItems.Items[ItemIndex - 1]);
        APlannerItem.GetTimeTag;
      end;
    finally
      NewItems.Free;
      Items.EndUpdate;
    end;
  finally
    PlannerIO.Free;
  end;
end;

function FontSizeToHtmlFontSize(FontSize: Integer): string;
begin
  case FontSize of
    1..8: Result := '"1"';
    9, 10: Result := '"2"';
    11, 12: Result := '"3"';
    13, 14: Result := '"4"';
    15..18: Result := '"5"';
    19..24: Result := '"6"';
  else
    Result := '"2"';
  end;
end;

function FontToHtmlFont(const Font: TFont): string;
begin
  Result := Format('<Font face="%s" size=%s>',
    [Font.Name, FontSizeToHtmlFontSize(Font.Size)]);
end;

function EmbedInHtmlTag(const Value: string; const Tag: string): string;
begin
  Result := Format('<%s>%s</%s>', [Tag, Value, Tag]);
end;

function EmbedInHtmlFontStyles(const Value: string; const FontStyle: TFontStyles): string;
begin
  Result := Value;
  if fsBold in FontStyle then
    Result := EmbedInHtmlTag(Result, 'B');
  if fsItalic in FontStyle then
    Result := EmbedInHtmlTag(Result, 'I');
  if fsUnderline in FontStyle then
    Result := EmbedInHtmlTag(Result, 'U');
end;

function EmbedInHtmlOptions(const Value: string;
  const FontStyle: TFontStyles; const FontTag: string): string;
begin
  Result := EmbedInHtmlFontStyles(Value, FontStyle);
  if (FontTag <> '') then
    Result := Format('<Font %s>%s</Font>', [FontTag, Result]);
end;

const
  Percent = '%';

function HtmlOptionsToHtmlTablePrefix(HTMLOptions: TPlannerHTMLOptions): string;
begin
//  style="border-collapse:collapse"

  with HTMLOptions do
    Result := Format('<table border="%d" cellspacing="%d" Width="%d%s"%s >',
      [BorderSize, CellSpacing, Width, Percent, TableStyle]);
end;

function PlannerGetIdCol(Planner: TCustomPlanner; Index, Position: Integer): string;
var
  Line1, Line2, Line3: string; // HoursString, MinutesString, AmPmString
  HS: Boolean;
begin
  Planner.FGrid.GetSideBarLines(Index, Position, Line1, Line2, Line3, HS);

  if Planner.Mode.PlannerType in [plDay,plTimeLine] then
  begin
    Result := Format('%s%s%s', [Line1, TimeSeparator, Line2]);
    if Line3 <> '' then
      Result := Format('%s %s', [Result, Line3]);
  end
  else
  begin
    Result := Line1 + Line2 + Line3;
  end;

end;

procedure TCustomPlanner.SaveToHTMLCol(FileName: string);
var
  RowIndex, ColIndex, PosIndex: Integer;
  WidthPercentage, MaxPos, TotCol: Integer;
  TheBackgroundColor: TColor;
  HtmlText, HtmlBackGroundColor,ColSpan: string;
  tf: TextFile;
  APlannerItem: TPlannerItem;
  w, sw, txt: string;
  HtmlAlignment: string;
  rtf: string;
  GotSpan: Boolean;
  ABrush: TBrush;
  sl: TStringList;

begin
  HtmlText := '';

  if HtmlOptions.HeaderFile <> '' then
  begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(HtmlOptions.HeaderFile);
      HtmlText := HtmlText + sl.Text;
    finally
      sl.Free;
    end;  
  end;


  with FGrid do
  begin
    HtmlText := HtmlText + HtmlOptions.PrefixTag + FontToHtmlFont(Self.Font) +
      HtmlOptionsToHtmlTablePrefix(HTMLOptions);

    WidthPercentage := Round((Sidebar.Width / Self.Width) * 100);
    w := Format('Width="%d%s"', [Round((100 - WidthPercentage) / ColCount), Percent]);
    sw := Format('Width="%d%s"', [WidthPercentage, Percent]);

    HtmlText := HtmlText + '<tr>';

    for ColIndex := 0 to ColCount - 1 do
    begin

      if (ColIndex = 0) then
        HtmlText := HtmlText + '<td ' + sw
      else
      begin
        MaxPos := Items.MaxItemsInPos(ColIndex - 1);

        {$IFDEF TMSDEBUG}
        outputdebugstring(pchar(inttostr(colindex-1)+':'+inttostr(maxpos)));
        {$ENDIF}

        if (MaxPos > 1) and (ColIndex > 0) then
          ColSpan := ' colspan="'+ IntToStr(MaxPos)+'"'
        else
          ColSpan := '';

        HtmlText := HtmlText + '<td ' + w + ColSpan;
      end;

      HtmlAlignment := '';
      case Header.Alignment of
      taRightJustify: HtmlAlignment := ' align="Right"';
      taCenter: HtmlAlignment := ' align="center"';
      end;

      HtmlText := HtmlText + HtmlAlignment;


      HtmlBackGroundColor := ColorToHtmlHexBgColor(Sidebar.Background);

      if Header.Captions.Count > ColIndex then
        txt := CLToBR(Header.Captions[ColIndex])
      else
        txt := HtmlNonBreakingSpace;

      txt := EmbedInHtmlOptions(txt, HTMLOptions.HeaderFontStyle, HTMLOptions.HeaderFontTag);

      HtmlText := HtmlText + HtmlBackGroundColor + '>' + txt + '</td>'#13#10
    end;
    HtmlText := HtmlText + '</tr>';

    w := '';

    for RowIndex := 0 to RowCount - 1 do
    begin
      HtmlText := HtmlText + '<tr>';


      for ColIndex := 0 to ColCount - 1 do
      begin
        GotSpan := False;

        if ColIndex = 0 then
        begin
          HtmlBackGroundColor := ColorToHtmlHexBgColor(Sidebar.Background);
          txt := PlannerGetIdCol(Self, RowIndex, ColIndex);

          txt := EmbedInHtmlOptions(txt, HTMLOptions.SidebarFontStyle, HTMLOptions.SidebarFontTag);

          HtmlText := HtmlText + '<td ' + sw + HtmlBackGroundColor + '>' + txt + '</td>';
        end
        else
        begin
          MaxPos := Items.MaxItemsInPos(ColIndex - 1);

          for PosIndex := 0 to MaxPos - 1 do
          begin
            HtmlBackGroundColor := '';

            ABrush := TBrush.Create;
            GetCellBrush(ColIndex,RowIndex,ABrush);

            HtmlBackGroundColor := ColorToHtmlHexBgColor(ABrush.Color);

            ABrush.Free;

            TheBackgroundColor := BackGroundColor[ColIndex - 1, RowIndex];
            if TheBackgroundColor <> clNone then
              HtmlBackGroundColor := ColorToHtmlHexBgColor(TheBackgroundColor);

            APlannerItem := Items.FindItem(RowIndex, ColIndex - 1);

            if Assigned(APlannerItem) then
              TotCol := APlannerItem.Conflicts
            else
              TotCol := 0;

            APlannerItem := Items.FindItemPosIdx(RowIndex, ColIndex - 1, PosIndex);

            if Assigned(APlannerItem) then
            begin
              HtmlAlignment := ' valign="Top"';
              case APlannerItem.Alignment of
                taRightJustify: HtmlAlignment := HtmlAlignment + ' align="Right"';
                taCenter: HtmlAlignment := HtmlAlignment + ' align="center"';
              end;

              if (APlannerItem.ItemBegin = RowIndex) then
              begin
                rtf := APlannerItem.Text.Text;

                if IsRtf(rtf) then
                begin
                  TextToRich(rtf);
                  rtf := FRichEdit.Text;
                end;

                if HTMLOptions.ShowCaption then
                  rtf := APlannerItem.GetCaptionString + '<HR>' + rtf;

                rtf := EmbedInHtmlOptions(rtf, HTMLOptions.CellFontStyle, HTMLOptions.CellFontTag);

                HtmlBackGroundColor := ColorToHtmlHexBgColor(APlannerItem.Color);

                if  (MaxPos > 1) and (APlannerItem.ConflictPos = 0) and (TotCol = 1) then
                begin
                  ColSpan := ' colspan="' + IntToStr(MaxPos)+'"';
                end
                else
                  ColSpan := '';

                if (APlannerItem.ItemEnd > APlannerItem.ItemBegin) and not GotSpan and
                   (APlannerItem.ConflictPos = PosIndex) then
                  HtmlText := HtmlText + '<td ' + w + HtmlAlignment + ' rowspan="' +
                    IntToStr(APlannerItem.ItemEnd - APlannerItem.ItemBegin) +
                    '"' + ColSpan + HtmlBackGroundColor + ' bordercolor="#000000">' + rtf + '</td>'
                else
                begin
                  HtmlText := HtmlText + '<td ' + w + HtmlAlignment + HtmlBackGroundColor + '>' + rtf + '</td>'
                end;
              end;

              if  (MaxPos > 0) and (APlannerItem.ConflictPos = 0) and (TotCol = 1) then
                GotSpan := True;
            end
            else
            begin
              if TotCol = 0 then
              begin
                if (PosIndex = 0) then
                begin
                  if MaxPos > 1 then
                    ColSpan := ' colspan="' + IntToStr(MaxPos) + '"'
                  else
                    ColSpan := '';

                  HtmlText := HtmlText + '<td ' + ColSpan + HtmlBackGroundColor + '>&nbsp;'+'</td>'#13#10
                end;
              end
              else
              begin
                if not GotSpan then
                  HtmlText := HtmlText + '<td ' + w + HtmlBackGroundColor + '>&nbsp;'+'</td>'
              end;
            end;
          end;

        end;

      end;
      HtmlText := HtmlText + '</tr>';
    end;
    HtmlText := HtmlText + '</table></Font>';
  end;

  HtmlText := HtmlText + HTMLOptions.SuffixTag;

  if HtmlOptions.FooterFile <> '' then
  begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(HtmlOptions.FooterFile);
      HtmlText := HtmlText + sl.Text;
    finally
      sl.Free;
    end;  
  end;


  AssignFile(tf, FileName);
  Rewrite(tf);
  try
    Write(tf, HtmlText);
  finally
    CloseFile(tf);
  end;
end;

procedure TCustomPlanner.SaveToHTMLRow(FileName: string);
var
  RowIndex, ColIndex, StartCol: Integer;
  WidthPercentage: Integer;
  HtmlText, HtmlBackGroundColor, txt: string;
  tf: TextFile;
  APlannerItem: TPlannerItem;
  w, sw: string;
  HtmlAlignment: string;
  rtf: string;
  ABrush: TBrush;
  sl: TStringList;
begin
  HtmlText := '';

  if HtmlOptions.HeaderFile <> '' then
  begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(HtmlOptions.HeaderFile);
      HtmlText := HtmlText + sl.Text;
    finally
      sl.Free;
    end;   
  end;


  with FGrid do
  begin
    HtmlText := HtmlText + FontToHtmlFont(Self.Font) + HtmlOptionsToHtmlTablePrefix(HTMLOptions);

    WidthPercentage := Round((Sidebar.Width / Self.Width) * 100);

    w := Format('Width="%d%s"', [Round((100 - WidthPercentage) / ColCount), Percent]);
    sw := Format('Width="%d%s"', [WidthPercentage, Percent]);

    HtmlText := HtmlText + '<tr>';
    StartCol := 1;
    if Header.Visible then
    begin
      HtmlBackGroundColor := ColorToHtmlHexBgColor(Header.Color);
      HtmlText := HtmlText + '<td ' + sw + HtmlBackGroundColor + '>&nbsp;</td>';
      StartCol := 0;
    end;

    for ColIndex := 0 to ColCount - 1 do
    begin
      HtmlBackGroundColor := ColorToHtmlHexBgColor(Sidebar.Background);

      txt := PlannerGetIdCol(Self, ColIndex, 0);
      txt := EmbedInHtmlOptions(txt, HTMLOptions.HeaderFontStyle, HTMLOptions.HeaderFontTag);

      HtmlText := HtmlText + '<td ' + w + HtmlBackGroundColor + '>' + txt + '</td>';
    end;
    HtmlText := HtmlText + '</tr>';

    for RowIndex := 1 to RowCount - 1 do
    begin
      HtmlText := HtmlText + '<tr>';

      for ColIndex := StartCol to ColCount do
      begin
        if ColIndex = 0 then
        begin
          HtmlBackGroundColor := ColorToHtmlHexBgColor(Header.Color);

          if Header.Captions.Count > ColIndex then
            txt := CLToBR(Header.Captions[RowIndex])
          else
            txt := HtmlNonBreakingSpace;

          txt := EmbedInHtmlOptions(txt, HTMLOptions.SidebarFontStyle, HTMLOptions.SidebarFontTag);

          HtmlText := HtmlText + '<td ' + HtmlBackGroundColor + '>' + txt + '</td>';
        end
        else
        begin
          HtmlBackGroundColor := '';

          ABrush := TBrush.Create;

          GetCellBrush(RowIndex,ColIndex - 1,ABrush);

          HtmlBackGroundColor := ColorToHtmlHexBgColor(ABrush.Color);

          ABrush.Free;

          if BackGroundColor[RowIndex - 1, ColIndex - 1] <> clNone then
            HtmlBackGroundColor := ColorToHtmlHexBgColor(BackGroundColor[RowIndex - 1, ColIndex - 1]);

          APlannerItem := Items.FindItem(ColIndex - 1, RowIndex - 1);
          if Assigned(APlannerItem) then
          begin
            HtmlAlignment := ' valign="Top"';
            case APlannerItem.Alignment of
              taRightJustify: HtmlAlignment := HtmlAlignment + ' align="Right"';
              taCenter: HtmlAlignment := HtmlAlignment + ' align="center"';
            end;
            if (APlannerItem.ItemBegin = ColIndex - 1) then
            begin
              rtf := APlannerItem.Text.Text;
              if IsRtf(rtf) then
              begin
                TextToRich(rtf);
                rtf := FRichEdit.Text;
              end;

              rtf := EmbedInHtmlOptions(rtf, HTMLOptions.CellFontStyle, HTMLOptions.CellFontTag);

              HtmlBackGroundColor := ColorToHtmlHexBgColor(APlannerItem.Color);
              if APlannerItem.ItemEnd > APlannerItem.ItemBegin then
                HtmlText := HtmlText + '<td ' + w + HtmlAlignment + ' colspan="' + IntToStr(APlannerItem.ItemEnd
                  - APlannerItem.ItemBegin) + '"' + HtmlBackGroundColor + ' bordercolor="#000000">' + rtf
                  +
                  '</td>'
              else
              begin
                HtmlText := HtmlText + '<td ' + w + HtmlAlignment + HtmlBackGroundColor + '>' + rtf + '</td>'
              end;
            end;
          end
          else
            HtmlText := HtmlText + '<td ' + w + HtmlBackGroundColor + '>&nbsp;</td>'
        end;

      end;
      HtmlText := HtmlText + '</tr>';
    end;
    HtmlText := HtmlText + '</table></Font>';
  end;

  if HtmlOptions.FooterFile <> '' then
  begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(HtmlOptions.FooterFile);
      HtmlText := HtmlText + sl.Text;
    finally
      sl.Free;
    end;
  end;


  AssignFile(tf, FileName);
  Rewrite(tf);
  try
    Write(tf, HtmlText);
  finally
    CloseFile(tf);
  end;
end;

procedure TCustomPlanner.SaveToHTML(FileName: string);
begin
  if Sidebar.Orientation = soVertical then
    SaveToHTMLCol(FileName)
  else
    SaveToHTMLRow(FileName);
end;


{$IFDEF DELPHI4_LVL}
procedure TCustomPlanner.Resize;
{$ENDIF}
{$IFNDEF DELPHI4_LVL}
procedure TCustomPlanner.WMSize(var WMSize: TWMSize);
{$ENDIF}
begin
  inherited;
  if FGrid.FMemo.Visible then
    FGrid.FMemo.Visible := False;
  if FRichEdit.Visible then
    FRichEdit.Visible := False;
  if Assigned(FHeader) then
    if Assigned(FHeader.FInplaceEdit) then
    begin
      if FHeader.FInplaceEdit.Visible then
        FHeader.FInplaceEdit.Visible := False;
    end;
  UpdateSizes;
end;

procedure TCustomPlanner.WMMoving(var Message: TMessage);
begin
  inherited;
end;

procedure TCustomPlanner.SetItemSelection(AValue: TPlannerItemSelection);
begin
  FItemSelection.Assign(AValue);
end;

procedure TCustomPlanner.Loaded;
begin
  inherited;
{$IFDEF TMSCODESITE}
  CodeSite.SendMsg('TPlanner Loaded begin');
{$ENDIF}
  FCaption.UpdatePanel;
  FDisplay.InitPrecis;
  FDisplay.UpdatePlanner;

  Items.SetConflicts;
  FGrid.Color := Self.Color;
  FGrid.UpdatePositions;
  FHeader.Flat := FPlannerHeader.Flat;

  if FPlannerHeader.AutoSize then
    AutoSizeHeader;

  FScrollBarStyle.UpdateProps;
  FGrid.UpdateVScrollBar;

{$IFDEF TMSCODESITE}
  CodeSite.SendMsg('TPlanner Loaded end');
{$ENDIF}
  UpdateTimer;
  FGrid.UpdateNVI;

  SideBar.ActiveColor := SideBar.ActiveColor;
  FGrid.FOldSelection := FGrid.Selection;
end;

procedure TCustomPlanner.NextClick(Sender: TObject);
begin
  if Assigned(FOnPlannerNext) then
    FOnPlannerNext(Self);
end;

procedure TCustomPlanner.PrevClick(Sender: TObject);
begin
  if Assigned(FOnPlannerPrev) then
    FOnPlannerPrev(Self);
end;

procedure TCustomPlanner.HeaderClick(Sender: TObject; SectionIndex: Integer);
begin
  if Assigned(FOnHeaderClick) then
    FOnHeaderClick(Self, SectionIndex);
end;

procedure TCustomPlanner.HeaderRightClick(Sender: TObject; SectionIndex: Integer);
begin
  if Assigned(FOnHeaderRightClick) then
    FOnHeaderRightClick(Self, SectionIndex);
end;

procedure TCustomPlanner.HeaderDblClick(Sender: TObject; SectionIndex: Integer);
begin
  if Assigned(FOnHeaderDblClick) then
    FOnHeaderDblClick(Self, SectionIndex)
end;

procedure TCustomPlanner.HeaderDragDrop(Sender: TObject; FromSection, ToSection:
  Integer);
begin
  if Sidebar.Orientation = soHorizontal then
  begin
    if FSidebar.Visible then
      MovePosition(FromSection - 1 {+ FGrid.TopRow - 1}, ToSection - 1 {+
        FGrid.TopRow - 1})
    else
      MovePosition(FromSection {+ FGrid.TopRow} - 1, ToSection {+ FGrid.TopRow} -
        1);
  end
  else
  begin
//    if FSidebar.Visible then
      MovePosition(FromSection - 1 + FGrid.LeftCol - 1, ToSection - 1 +
        FGrid.LeftCol - 1)
//    else
//      MovePosition(FromSection + FGrid.LeftCol - 1, ToSection + FGrid.LeftCol -
//        1);
  end;

  if Assigned(FOnHeaderDragDrop) then
    FOnHeaderDragDrop(Self,FromSection,ToSection);
end;

procedure TCustomPlanner.PlanFontChanged(Sender: TObject);
begin
  Invalidate;
end;


procedure TCustomPlanner.CreateWnd;
begin
  inherited;
  FCaption.UpdatePanel;
end;


procedure TCustomPlanner.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style and not WS_BORDER;
  end;
end;

procedure TCustomPlanner.DestroyWnd;
begin
  inherited;
end;

procedure TCustomPlanner.Paint;
var
  r: TRect;
begin
  inherited;

  r := ClientRect;

  if FHeader.Visible and (FSideBar.Position <> spTop) then
  begin
    r.Bottom := FHeader.Height + FCaption.Height;
    Canvas.Brush.Color := FHeader.Color;
    Canvas.Pen.Color := FHeader.Color;
    Canvas.FillRect(r); // fill the Header background
    r := ClientRect;
    r.Top := FHeader.Height + FCaption.Height;
  end;

end;

procedure TCustomPlanner.Invalidate;
var
  i: Integer;
begin
  inherited;

  for i := 1 to ControlCount do
    Controls[i - 1].Invalidate;
end;

procedure TCustomPlanner.SetActiveDisplay(const Value: Boolean);
begin
  if FActiveDisplay <> Value then
  begin
    if Sidebar.Orientation = soVertical then
    begin
      if Value then
        FGrid.TopRow := Display.ActiveStart
      else
        FGrid.TopRow := 0;
    end
    else
    begin
      if Value then
        FGrid.LeftCol := Display.ActiveStart
      else
        FGrid.LeftCol := 0;
    end;

    FActiveDisplay := Value;
  end;
end;

procedure TCustomPlanner.SetFont(Value: TFont);
begin
  Font.Assign(Value);
end;

procedure TCustomPlanner.SetTrackColor(const Value: TColor);
begin
  if FTrackColor <> Value then
  begin
    FTrackColor := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.SetTrackProportional(const Value: Boolean);
begin
  if FTrackProportional <> Value then
  begin
    FTrackProportional := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.SetImages(const Value: TImageList);
begin
  if FPlannerImages <> Value then
  begin
    FPlannerImages := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.SetDrawPrecise(const Value: Boolean);
begin
  if FDrawPrecise <> Value then
  begin
    FDrawPrecise := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.SetLayer(const Value: LongInt);
begin
  if FLayer <> Value then
  begin
    FLayer := Value;
    Items.SetConflicts;
    Invalidate;
  end;
end;

procedure TCustomPlanner.SetHourType(const Value: THourType);
begin
  if FHourType <> Value then
  begin
    FHourType := Value;
    FGrid.Invalidate;
  end;
end;

procedure TCustomPlanner.SetGridTopRow(const Value: Integer);
begin
  if Value <> FGrid.TopRow then
  begin
    if Value < FGrid.FixedRows then
      FGrid.TopRow := FGrid.FixedRows
    else
      FGrid.TopRow := Value;
  end;
end;

function TCustomPlanner.GetGridTopRow: Integer;
begin
  Result := FGrid.TopRow;
end;

procedure TCustomPlanner.SetGridLeftCol(const Value: Integer);
begin
  if (PositionWidth = 0) and (Sidebar.Position <> spTop) then
    Exit;

  if FGrid.ColCount - FGrid.VisibleColCount < Value then
    FGrid.LeftCol := FGrid.ColCount - FGrid.VisibleColCount
  else
    FGrid.LeftCol := Value;
end;

function TCustomPlanner.GetGridLeftCol: Integer;
begin
  Result := FGrid.LeftCol;
end;

procedure TCustomPlanner.SetPositions(const Value: Integer);
var
  ColorIndex: Integer;
  PlannerColorArrayPointer: PPlannerColorArray;
begin
  if Value <= 0 then
    Exit;

  if Value = FPositions then
    Exit;

  FPositions := Value;

  { Force Sidebar & position update }
  SideBar.Position := SideBar.Position;

  {Synchronize Header with nr of positions}
  while FPlannerHeader.Captions.Count <= FPositions do
    FPlannerHeader.Captions.Add('');

  if PositionGroup > 0 then
  begin
    while FPlannerHeader.GroupCaptions.Count <= (Positions div PositionGroup) do
      FPlannerHeader.GroupCaptions.Add('');
  end;

  FPlannerHeader.ItemsChanged(Self);

{$IFDEF TMSCODESITE}
  CodeSite.SendInteger('In setpositions :',Value);
{$ENDIF}

  { Synchronize the background Color list with the nr. of positions }
  while FGrid.ColorList.Count < Value do
  begin
    PlannerColorArrayPointer := FGrid.ColorList.Add;
    for ColorIndex := 0 to NumColors do
      PlannerColorArrayPointer^[ColorIndex] := clNone;
  end;

  while FGrid.ColorList.Count > Value do
    FGrid.ColorList.Delete(FGrid.ColorList.Count - 1);
end;

procedure TCustomPlanner.SetPositionWidth(const Value: Integer);
begin
  if (Value <> FPositionWidth) then
  begin
    FPositionWidth := Value;
    FGrid.UpdatePositions;
  end;
end;

procedure TCustomPlanner.SetPlannerItems(const Value: TPlannerItems);
begin
  FPlannerItems := Value;
end;

procedure TCustomPlanner.SetCaption(const Value: TPlannerCaption);
begin
  FCaption := Value;
  FPanel.Repaint;
end;

procedure TCustomPlanner.SetDayNames(const Value: TStringList);
begin
  if Assigned(Value) then
    FDayNames.Assign(Value);
  Self.Repaint;
end;

procedure TCustomPlanner.SetDisplay(const Value: TPlannerDisplay);
begin
  FDisplay := Value;
end;

procedure TCustomPlanner.SetHeader(const Value: TPlannerHeader);
begin
  FPlannerHeader := Value;
end;

procedure TCustomPlanner.SetMode(const Value: TPlannerMode);
begin
  FMode := Value;
end;

procedure TCustomPlanner.SetSideBar(const Value: TPlannerSideBar);
begin
  FSidebar := Value;
end;

procedure TCustomPlanner.WMEraseBkGnd(var Message: TMessage);
begin
  Message.Result := 0;
end;

procedure TCustomPlanner.UpdateSizes;
begin
  if Sidebar.Orientation = soVertical then
  begin
    if FPlannerHeader.Visible then
    begin
      FHeader.Visible := True;
      FHeader.Top := FPanel.Height;
      FHeader.Height := FPlannerHeader.Height;
    end
    else
    begin
      FHeader.Height := 0;
      FHeader.Visible := False;
    end;

    if FNavigatorButtons.Visible then
      FHeader.Width := Self.Width - 2 * BtnWidth
    else
      FHeader.Width := Self.Width;

    FGrid.Top := FPanel.Height + FHeader.Height;
    FGrid.Left := 0;

    FGrid.Width := Self.Width;
    FGrid.Height := Self.Height - FPanel.Height - FHeader.Height;
    FPanel.Width := Self.Width;

    if FNavigatorButtons.Visible and FPlannerHeader.Visible then
    begin
      FHeader.Left := BtnWidth;
      FNext.Top := FPanel.Height;
      FNext.Left := Width - BtnWidth;
      
      FNext.Width := BtnWidth;
      FNext.Height := FHeader.Height;
      FPrev.Height := FHeader.Height;
      FPrev.Width := BtnWidth;
    end
    else
      FHeader.Left := 0;
  end
  else
  begin
    if FPlannerHeader.Visible then
    begin
      FHeader.Visible := True;
      FHeader.Top := FPanel.Height;
      FHeader.Left := 0;
      FHeader.Width := FPlannerHeader.Height;
      FHeader.Height := Self.Height - FPanel.Height;
    end
    else
    begin
      FHeader.Width := 0;
      FHeader.Visible := False;
    end;

    FGrid.Top := FPanel.Height;
    FGrid.Left := FHeader.Width;
    FGrid.Width := Self.Width - FHeader.Width;
    FGrid.Height := Self.Height - FPanel.Height;
    FPanel.Width := Self.Width;
  end;
end;

procedure TCustomPlanner.UpdateTimer;
begin
  if csLoading in ComponentState then
    Exit;
  if (FDisplay.ShowCurrent or FDisplay.ShowCurrentItem or FEnableAlarms or FEnableFlashing)
    and (FTimerID = 0) then
    FTimerID := SetTimer(Self.Handle, 1, 500, nil);

  if not (FDisplay.ShowCurrent or FDisplay.ShowCurrentItem or FEnableAlarms or FEnableFlashing)
    and (FTimerID <> 0) then
  begin
    KillTimer(Self.Handle, FTimerID);
    FTimerID := 0;
  end;
end;

function TCustomPlanner.IsSelected(AIndex, APosition: Integer): Boolean;
begin
  Result := (AIndex >= SelItemBegin) and
    (AIndex < SelItemEnd) and
    (APosition = SelPosition);
end;

function TCustomPlanner.GetSelItemEnd: Integer;
begin
  if Sidebar.Orientation = soVertical then
    Result := FGrid.Selection.Bottom + 1
  else
    Result := FGrid.Selection.Right + 1;
end;

function TCustomPlanner.GetSelItemBegin: Integer;
begin
  if Sidebar.Orientation = soVertical then
    Result := FGrid.Selection.Top
  else
    Result := FGrid.Selection.Left;
end;

function TCustomPlanner.GetSelPosition: Integer;
begin
  case FSidebar.Position of
    spLeft, spLeftRight: Result := FGrid.Selection.Left - 1;
    spRight: Result := FGrid.Selection.Left;
    spTop: Result := FGrid.Selection.Top - 1;
  else
    Result := FGrid.Selection.Left - 1;
  end;
end;

procedure TCustomPlanner.SetSelItemEnd(const Value: Integer);
var
  GridRect: TGridRect;
begin
  GridRect := FGrid.Selection;

  if Sidebar.Orientation = soVertical then
    GridRect.Bottom := Value
  else
    GridRect.Right := Value;

  FGrid.Selection := GridRect;
end;

procedure TCustomPlanner.SetSelItemBegin(const Value: Integer);
var
  GridRect: TGridRect;
begin
  GridRect := FGrid.Selection;

  if Sidebar.Orientation = soVertical then
    GridRect.Top := Value
  else
    GridRect.Left := Value;

  FGrid.Selection := GridRect;
end;

procedure TCustomPlanner.SetSelPosition(Value: Integer);
var
  GridRect: TGridRect;
begin
  GridRect := FGrid.Selection;

  Inc(Value);

  if Sidebar.Orientation = soVertical then
  begin
    GridRect.Left := Value;
    GridRect.Right := Value;
  end
  else
  begin
    GridRect.Top := Value;
    GridRect.Bottom := Value;
  end;

  if GridRect.Bottom > 31 then
    GridRect.Bottom := 31;
  if GridRect.Right > 31 then
    GridRect.Right := 31;


  FGrid.Selection := GridRect;
end;

procedure TCustomPlanner.SetGradientSteps(const Value: Integer);
begin
  if (Value <> FGradientSteps) then
  begin
    FGradientSteps := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.SetGradientHorizontal(const Value: Boolean);
begin
  if (Value <> FGradientHorizontal) then
  begin
    FGradientHorizontal := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.SelChange(Sender: TObject);
begin
  if Assigned(FOnItemSelChange) then
    FOnItemSelChange(Sender, FRichEdit.FPlannerItem);
end;

function TCustomPlanner.XYToCell(X, Y: Integer): TPoint;
var
  GridCoord: TGridCoord;
begin
  GridCoord := FGrid.MouseCoord(X, Y);
  if {(FSidebar.Visible) and} (FSidebar.Position in [spLeft, spLeftRight]) then
    GridCoord.X := GridCoord.X - 1;
  if {(FSidebar.Visible) and} (FSidebar.Position = spTop) then
    GridCoord.Y := GridCoord.Y - 1;
  Result := Point(GridCoord.X, GridCoord.Y);
end;

function TCustomPlanner.XYToItem(X, Y: Integer): TPlannerItem;
var
  CellPoint: TPoint;
begin
  CellPoint := XYToCell(X, Y);
  Result := CellToItem(CellPoint.X, CellPoint.Y);
end;

function TCustomPlanner.CellToItem(X, Y: Integer): TPlannerItem;
begin
  if Sidebar.Orientation = soVertical then
    Result := Items.FindItemPos(Y, X, 1)
  else
    Result := Items.FindItemPos(X, Y, 1);
end;

function TCustomPlanner.CellToItemIdx(X, Y, Index: Integer): TPlannerItem;
begin
  if Sidebar.Orientation = soVertical then
    Result := Items.FindItemPosIdx(Y, X, Index)
  else
    Result := Items.FindItemPosIdx(X, Y, Index);
end;

function TCustomPlanner.CellToItemNum(X, Y: Integer): Integer;
var
  APlannerItem: TPlannerItem;
begin
  if Sidebar.Orientation = soVertical then
    APlannerItem := Items.FindItem(Y, X)
  else
    APlannerItem := Items.FindItem(X, Y);

  if Assigned(APlannerItem) then
    Result := APlannerItem.FConflicts
  else
    Result := 0;
end;

procedure TCustomPlanner.CellToAbsTime(X: Integer; var dtStart, dtEnd: TDateTime);
var
  res: Integer;
  ANow: TDateTime;
begin
  case Mode.PlannerType of
    plDay:
      begin
        ANow := Now;
        if Assigned(FOnGetCurrentTime) then
          FOnGetCurrentTime(Self, ANow);

        res := ((X + Display.DisplayStart) * Display.DisplayUnit) + Display.DisplayOffset;
        if (res div 60 < 24) then
          dtStart := int(Now) + EncodeTime(res div 60, res mod 60, 0, 0);
        res := res + Display.DisplayUnit;
        if (res div 60 < 24) then
          dtEnd := int(Now) + EncodeTime(res div 60, res mod 60, 0, 0);
      end;
    plWeek:
      begin
        dtStart := Mode.StartOfMonth + X;
        dtEnd := dtStart + 1;
      end;
    plMonth:
      begin
        dtStart := Mode.StartOfMonth + X;
        dtEnd := dtStart + 1;
      end;
    plDayPeriod:
      begin
        dtStart := Mode.PeriodStartDate + X;
        dtEnd := dtStart + 1;
      end;
    plHalfDayPeriod:
      begin
        dtStart := Mode.PeriodStartDate + X / 2;
        dtEnd := dtStart + 1;
      end;
    plMultiMonth:
      begin
      end;
    plCustom, plCustomList:
      begin
        dtStart := IndexToTime(X);
        dtEnd := IndexToTime(X + 1);
      end;
    plTimeLine:
      begin
        //
        res := ((X + Display.DisplayStart) * Display.DisplayUnit) + Display.DisplayOffset;

        dtStart := int(Mode.TimeLineStart);

        if res >= MinInDay then
        begin
          dtStart := dtStart + (res div MinInDay);
        end;

        res := res mod MinInDay;

        dtStart :=  dtStart + EncodeTime(res div 60, res mod 60, 0, 0);

        res := Display.DisplayUnit;

        dtEnd := dtStart + EncodeTime(res div 60, res mod 60, 0, 0);

      end;  
  end;
end;

function TCustomPlanner.AbsTimeToCell(DateTime: TDateTime): Integer;
var
  Year, Month, Day, Hour, Minute, Second, Second100: Word;
  DateTimeStart: TDateTime;

begin
  Result := 0;
  case Mode.PlannerType of
    plDay:
      begin
        DecodeTime(DateTime, Hour, Minute, Second, Second100);
        Minute := Minute + Hour * 60;
        Result := ((Minute - Display.DisplayOffset) div Display.DisplayUnit) - Display.DisplayStart;
      end;
    plWeek:
      begin
        Result := Trunc(DateTime - Mode.StartOfMonth);
      end;
    plMonth:
      begin
        DecoDedate(DateTime, Year, Month, Day);
        Result := Day - 1;
      end;
    plDayPeriod:
      begin
        DateTimeStart := Mode.PeriodStartDate;
        if DateTime > DateTimeStart then
          Result := Round(DateTime - DateTimeStart) + 1;
      end;
    plHalfDayPeriod:
      begin
        DateTimeStart := Mode.PeriodStartDate;
        if DateTime > DateTimeStart then
          Result := 2 * (Round(DateTime - DateTimeStart) + 1);
      end;
    plMultiMonth:
      begin
      end;
    plCustom, plCustomList:
      begin
        Result := TimeToIndex(DateTime);
      end;
    plTimeLine:
      begin
        DecodeTime(DateTime, Hour, Minute, Second, Second100);
        Minute := Minute + Hour * 60;
        Result := ((Minute - Display.DisplayOffset) div Display.DisplayUnit) - Display.DisplayStart;
        DecodeDate(DateTime, Year, Month, Day);
        Result := Result +  (MININDAY div Display.DisplayUnit) * Round((Int(DateTime - Mode.TimeLineStart)));
      end;
  end;
end;

function TCustomPlanner.CellInCurrTime(X,Y: Integer): Boolean;
var
  DateTime: TDateTime;
  dtStart, dtEnd: TDateTime;
  BCurPos: Boolean;
begin
  CellToAbsTime(X, dtStart, dtEnd);

  DateTime := Now;
  if Assigned(FOnGetCurrentTime) then
    FOnGetCurrentTime(Self, DateTime);

  if Sidebar.Orientation = soVertical then
    BCurPos := IsCurPos(Y - Sidebar.FColOffset)
  else
    BCurPos := IsCurPos(Y - Sidebar.FRowOffset);

  Result := ((DateTime >= dtStart) and (DateTime <= dtEnd)) and (FDisplay.ShowCurrent) and BCurPos;
end;

procedure TCustomPlanner.MovePosition(FromPos, ToPos: Integer);
var
  ItemIndex: Integer;
begin
  {Add extra Position}
  Items.BeginUpdate;

  if ToPos > FromPos then
    Inc(ToPos);

  InsertPosition(ToPos);
  if (ToPos < FromPos) then
    Inc(FromPos);
  with Self.Items do
    for ItemIndex := 0 to Count - 1 do
    begin
      if Items[ItemIndex].ItemPos = FromPos then
        Items[ItemIndex].ItemPos := ToPos;
    end;

  Header.Captions.Strings[ToPos + 1] := Header.Captions.Strings[FromPos + 1];
  
  DeletePosition(FromPos);

  Items.EndUpdate;
end;

procedure TCustomPlanner.DeletePosition(Position: Integer);
var
  ItemIndex: Integer;
begin
  Items.BeginUpdate;
  ItemIndex := 0;

  with Self.Items do
    while (ItemIndex < Count) do
    begin
      if Items[ItemIndex].ItemPos > Position then
      begin
        Items[ItemIndex].ItemPos := Items[ItemIndex].ItemPos - 1;
        Inc(ItemIndex);
      end
      else if Items[ItemIndex].ItemPos = Position then
        Items[ItemIndex].Free
      else
        Inc(ItemIndex);

    end;
  Positions := Positions - 1;
  Items.EndUpdate;
  Header.Captions.Delete(Position + 1);
end;

procedure TCustomPlanner.InsertPosition(Position: Integer);
var
  ItemIndex: Integer;
begin
  Items.BeginUpdate;
  Positions := Positions + 1;
  with Items do
    for ItemIndex := 0 to Count - 1 do
    begin
      if Items[ItemIndex].ItemPos >= Position then
        Items[ItemIndex].ItemPos := Items[ItemIndex].ItemPos + 1;
    end;
  Items.EndUpdate;
  Header.Captions.Insert(Position + 1, '');
end;

procedure TCustomPlanner.HideSelection;
begin
  FGrid.HideSelection;
end;

procedure TCustomPlanner.UnHideSelection;
begin
  FGrid.UnHideSelection;
end;

procedure TCustomPlanner.SetItemGap(const Value: Integer);
begin
  if FItemGap <> Value then
  begin
    FItemGap := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.WMTimer(var Message: TWMTimer);
var
  ac,i: Integer;
  ANow: TDateTime;
  Msg: string;
  CondA,CondB: Boolean;
begin
  inherited;

  ANow := Now;
  if Assigned(FOnGetCurrentTime) then
    FOnGetCurrentTime(Self, ANow);

  if not (csDesigning in ComponentState) and EnableFlashing then
  begin
    for i := 1 to Items.Count do
    begin
      if Items[i - 1].Flashing then
      begin
        Items[i - 1].FlashOn := not Items[i - 1].FlashOn;
        Items[i - 1].Repaint;
      end;
    end;
  end;


  if not (csDesigning in ComponentState) and EnableAlarms and
     (GetCapture <> FGrid.Handle) and not FHandlingAlarm then
  begin

    for i := 1 to Items.Count do
    begin
      with Items[i - 1].Alarm do

      if Active and Assigned(Handler) then
      begin
        if Items[i - 1].RealTime then
        begin
          CondB := (ANow + TimeBefore > Items[i - 1].ItemRealStartTime) and
            (ANow < Items[i - 1].ItemRealStartTime);

          CondA := (ANow + TimeAfter > Items[i - 1].ItemRealEndTime);
        end
        else
        begin
          CondB := (Frac(ANow) + Frac(TimeBefore) > Frac(Items[i - 1].ItemStartTime)) and
            (Frac(ANow) < Frac(Items[i - 1].ItemStartTime));

          if CondB then
          begin
            CondB := ( (Int(ANow) = Int(Items[i - 1].FItemRealStartTime)) or
              (Int(Items[i - 1].FItemRealStartTime) = 0) );
          end;

          CondA := (Frac(ANow) + Frac(TimeAfter) > Frac(Items[i - 1].ItemEndTime)) and
            (((Int(ANow) >= Int(Items[i - 1].ItemEndTime)) or (Int(Items[i - 1].ItemEndTime) = 0)));

          if CondA then
          begin
            CondA := ( (Int(ANow) >= Int(Items[i - 1].FItemRealEndTime)) or
              (Int(Items[i - 1].FItemEndTime) = 0) );
          end;

        end;

        if (CondB and (Items[i - 1].Alarm.Time in [atBefore,atBoth])) or
           (CondA and (Items[i - 1].Alarm.Time in [atAfter,atBoth])) then
        begin
          Active := False;
          FHandlingAlarm := True;

          case NotifyType of
          anCaption: msg := HTMLStrip(Items[i - 1].CaptionText);
          anMessage: msg := Items[i - 1].Alarm.Message;
          anNotes: msg := HTMLStrip(Items[i - 1].Text.Text);
          end;

          if Assigned(FOnItemAlarm) then
            FOnItemAlarm(Self,Items[i - 1]);

          if not Handler.HandleAlarm(Address,Msg,Tag,ID,Items[i - 1]) then
            Active := True;
          FHandlingAlarm := False;
        end;
      end;
    end;
  end;

  ac := AbsTimeToCell(ANow);

  if (ac <> FTimerActiveCells) then
  begin
    if Sidebar.Orientation = soHorizontal then
    begin
      FGrid.InvalidateCol(FTimerActiveCells);
      FTimerActiveCells := ac;
      FGrid.InvalidateCol(FTimerActiveCells);
    end
    else
    begin
      FGrid.InvalidateRow(FTimerActiveCells);
      FTimerActiveCells := ac;
      FGrid.InvalidateRow(FTimerActiveCells);
    end;
  end;
  if FDisplay.ShowCurrentItem then
    Items.SetCurrent(ac);
end;

procedure TCustomPlanner.WndProc(var Message: TMessage);
begin
  if (Message.Msg = WM_DESTROY) then
  begin
    if ((FDisplay.ShowCurrent) or (FDisplay.ShowCurrentItem)) and (FTimerID <> 0) then
      KillTimer(Handle, FTimerID);
    FTimerID := 0;
  end;

  inherited;
end;

function TCustomPlanner.GetMemo: TMemo;
begin
  Result := FGrid.FMemo;
end;

function TCustomPlanner.GetMaskEdit: TMaskEdit;
begin
  Result := FGrid.FMaskEdit;
end;

procedure TCustomPlanner.InactiveChanged(Sender: TObject);
begin
  FInactive := [];
  if FInactiveDays.FSun then
    FInactive := FInactive + [1];
  if FInactiveDays.FMon then
    FInactive := FInactive + [2];
  if FInactiveDays.FTue then
    FInactive := FInactive + [3];
  if FInactiveDays.FWed then
    FInactive := FInactive + [4];
  if FInactiveDays.FThu then
    FInactive := FInactive + [5];
  if FInactiveDays.FFri then
    FInactive := FInactive + [6];
  if FInactiveDays.FSat then
    FInactive := FInactive + [7];
  Invalidate;
end;

procedure TCustomPlanner.PreviewPaint(APlannerItem: TPlannerItem; Canvas: TCanvas;
  r: TRect);
begin
  FGrid.PaintItemCol(Canvas, r, APlannerItem, False, False);
end;

procedure TCustomPlanner.SetDefaultItem(const Value: TPlannerItem);
begin
  FDefaultItem.Assign(Value);
end;

procedure TCustomPlanner.SetSelectColor(const Value: TColor);
begin
  if FSelectColor <> Value then
  begin
    FSelectColor := Value;
    Self.Invalidate;
  end;
end;


procedure TCustomPlanner.SetFlat(const Value: Boolean);
begin
  if Value <> FFlat then
  begin
    if Value then
    begin
      FGrid.BorderStyle := bsNone;
      FGrid.Ctl3D := False;
    end
    else
    begin
      FGrid.BorderStyle := bsSingle;
      FGrid.Ctl3D := True;
    end;
    FFlat := Value;
  end;
  FGrid.UpdatePositions;
end;

procedure TCustomPlanner.AutoSizeHeader;
var
  PositionIndex, MaxItemPerPosition: Integer;
  MaxItemOverAll: Integer;
  APlannerItem: TPlannerItem;
begin
  MaxItemOverAll := 0;

  for PositionIndex := 0 to Positions - 1 do
  begin
    MaxItemPerPosition := 0;
    APlannerItem := Items.HeaderFirst(PositionIndex);
    while Assigned(APlannerItem) do
    begin
      Inc(MaxItemPerPosition);
      APlannerItem := Items.HeaderNext(PositionIndex);
    end;

    if (MaxItemPerPosition > MaxItemOverAll) then
      MaxItemOverAll := MaxItemPerPosition;
  end;

  Header.Height := Header.TextHeight + MaxItemOverAll * Header.ItemHeight + 2;
end;

procedure TCustomPlanner.SetPositionGap(const Value: Integer);
begin
  if FPositionGap <> Value then
  begin
    FPositionGap := Value;
    FGrid.Invalidate;
  end;
end;


procedure TCustomPlanner.Notification(AComponent: TComponent;
  AOperation: TOperation);
var
  i: Integer;
begin
  inherited;

  if csDestroying in ComponentState then
    Exit;
    
  if (AOperation = opRemove) and
     (AComponent = FPlannerImages) then
    FPlannerImages := nil;
  if (AOperation = opRemove) and
     (AComponent = FContainer) then
    FContainer := nil;
  if (AOperation = opRemove) and
     (AComponent = FPlanChecker) then
    FPlanChecker := nil;

  if (AOperation = opRemove) and Assigned(DefaultItem) then
  begin
    if DefaultItem.Alarm.Handler = AComponent then
      DefaultItem.Alarm.Handler := nil;
    if DefaultItem.Editor = AComponent then
      DefaultItem.Editor := nil;
    if DefaultItem.PopupMenu = AComponent then
      DefaultItem.PopupMenu := nil;
    if DefaultItem.DrawTool = AComponent then
      DefaultItem.DrawTool := nil;
  end;

  if (AOperation = opRemove) and Assigned(Items) then
  begin
    for i := 1 to Items.Count do
    begin
      if Items[i - 1].Alarm.Handler = AComponent then
        Items[i - 1].Alarm.Handler := nil;

      if Items[i - 1].Editor = AComponent then
        Items[i - 1].Editor := nil;

      if Items[i - 1].PopupMenu = AComponent then
        Items[i - 1].PopupMenu := nil;

      if Items[i - 1].DrawTool = AComponent then
        Items[i - 1].DrawTool := nil;

    end;
  end;


end;

procedure TCustomPlanner.ItemMoved(FromBegin, FromEnd, FromPos, ToBegin, ToEnd,
  ToPos: Integer);
var
  i: Integer;
  NewBegin,NewEnd,NewPos: Integer;

begin
  if (FromBegin = ToBegin) and (FromEnd = ToEnd) and (FromPos = ToPos) then
    Exit;

  if not Assigned(Items.Selected) then
    Exit;

  if Assigned(FOnItemMove) then
    FOnItemMove(Self, Items.Selected, FromBegin, FromEnd, FromPos, ToBegin, ToEnd, ToPos);

  Items.Changing := True;
  if Assigned(Items.Selected) then
  begin
    if Items.Selected.ParentIndex >= 0 then
    begin
      i := 0;
      while i < Items.Count do
      begin
        if (Items[i] <> Items.Selected) and (Items[i].ParentIndex = Items.Selected.ParentIndex) then
        begin
          NewBegin := Items[i].ItemBegin + ToBegin - FromBegin;
          NewEnd := Items[i].ItemEnd + ToEnd - FromEnd;
          NewPos := Items[i].ItemPos + ToPos - FromPos;

          if (NewPos < 0) or (NewPos >= Positions) or
             (NewBegin < Display.DisplayStart) or (NewEnd > Display.DisplayEnd)  then
          begin
            if Items[i].RelationShip = irParent then
              Items.Selected.RelationShip := irParent;
            Items[i].Free;
          end
          else
          begin
            Items[i].ItemBegin := NewBegin;
            Items[i].ItemEnd := NewEnd;
            Items[i].ItemPos := NewPos;
            inc(i);
          end;
        end
        else
          inc(i);
      end;
    end;
  end;  

  Items.Changing := False;
end;

procedure TCustomPlanner.ItemSized(FromBegin, FromEnd, ToBegin, ToEnd: Integer);
var
  i: Integer;
  NewBegin,NewEnd: Integer;

begin
  if (FromBegin = ToBegin) and (FromEnd = ToEnd) then
    Exit;

  if not Assigned(Items.Selected) then
    Exit;

  if Assigned(FOnItemSize) then
    FOnItemSize(Self, Items.Selected, Items.Selected.ItemPos, FromBegin, FromEnd,
                ToBegin, ToEnd);

  Items.Changing := True;
  if Assigned(Items.Selected) then
  begin
    if Items.Selected.ParentIndex >= 0 then
    begin
      i := 0;
      while i < Items.Count do
      begin
        if (Items[i] <> Items.Selected) and (Items[i].ParentIndex = Items.Selected.ParentIndex) then
        begin
          NewBegin := Items[i].ItemBegin + ToBegin - FromBegin;
          NewEnd := Items[i].ItemEnd + ToEnd - FromEnd;

          if (NewBegin < Display.DisplayStart) or (NewEnd > Display.DisplayEnd)  then
          begin
            if Items[i].RelationShip = irParent then
              Items.Selected.RelationShip := irChild;
            Items[i].Free;
          end
          else
          begin
            Items[i].ItemBegin := NewBegin;
            Items[i].ItemEnd := NewEnd;
            inc(i);
          end
        end
        else
          inc(i);
      end;
    end;
  end;  

  Items.Changing := False;
end;

procedure TCustomPlanner.ItemEdited(Item: TPlannerItem);
begin
  if Assigned(ItemChecker) then
  begin
    if ItemChecker.AutoCorrect then
      Item.Text.Text := ItemChecker.Correct(Item.Text.Text);

    if ItemChecker.AutoMarkError then
      Item.Text.Text := ItemChecker.MarkError(Item.Text.Text);
  end;

  if Assigned(FOnItemEndEdit) then
    begin
      FOnItemEndEdit(Self, Item);
      // Workaround for hanging selection when OnItemEndEdit takes focus away
      // from the Planner.
      PostMessage(fgrid.handle,WM_LBUTTONDOWN,0,0);
    end;
end;

function TCustomPlanner.CreateItem: TPlannerItem;
begin
  Result := Items.Add;
  FGrid.UpdateNVI;  
end;

function TCustomPlanner.CloneItem(Item: TPlannerItem): TPlannerItem;
begin
  Result := Items.Add;
  Result.Assign(Item);
  Result.RelationShip := irChild;
  Item.RelationShip := irParent;
  Item.ParentIndex := Item.Index;
  Result.ParentIndex := Item.Index;
end;

procedure TCustomPlanner.RemoveClones(Item: TPlannerItem);
var
  i, idx: Integer;
begin
  idx := Item.ParentIndex;
  i := 0;
  while (i < Items.Count) do
  begin
    if (Items[i].ParentIndex = idx) and (Items[i].RelationShip = irChild) then
      Items[i].Free
    else
      inc(i);
  end;

end;

procedure TCustomPlanner.FreeItem(APlannerItem: TPlannerItem);
begin
  if Items.FSelected = APlannerItem then
    Items.FSelected := nil;
  APlannerItem.ParentItem.Free;
  FGrid.UpdateNVI;
end;

procedure TCustomPlanner.UpdateItem(APlannerItem: TPlannerItem);
begin
  // only used by DBPlanner
end;

procedure TCustomPlanner.RefreshItem(APlannerItem: TPlannerItem);
begin
  // only used by DBPlanner
end;

procedure TCustomPlanner.MapItemTimeOnPlanner(APlannerItem: TPlannerItem);
begin

end;

procedure TCustomPlanner.SetTrackWidth(const Value: Integer);
begin
  if FTrackWidth <> Value then
  begin
    FTrackWidth := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.PlanTimeToStrings(MinutesValue: Integer;
  var HoursString: string; var MinutesString: string; var AmPmString: string);
var
  Hours, Minutes: Integer;

  function ChooseNonEmpty(s1,s2:string):string;
  begin
    if s2 = '' then
      Result := s1
    else
      Result := s2;
  end;

begin
  while MinutesValue < 0 do
    MinutesValue := MinutesValue + MININDAY;

  Hours := MinutesValue div 60;
  Minutes := MinutesValue mod 60;
  Hours := Hours mod 24;

  MinutesString := Format('%.2d', [Minutes]);

  case HourType of
  ht24hrs: AmPmString := '';
  ht12hrs: if Hours > 12 then
             Hours := Hours - 12;
  htAMPM0:
    begin
      if Hours >= 12 then
        AmPmString := ChooseNonEmpty('PM',TimePMString)
      else
        AmPmString := ChooseNonEmpty('AM',TimeAMString);
      if Hours > 12 then
        Hours := Hours - 12
    end;
  htAMPM1:
    begin
      if Hours in [1..12] then
        AmPmString := ChooseNonEmpty('AM',TimePMString)
      else
        AmPmString := ChooseNonEmpty('PM',TimeAMString);
      if Hours > 12 then
        Hours := Hours - 12
    end;
  htAMPMOnce:
    begin
      If Minutes = 0 then
      begin
        AMPMString := '';
        if Hours >= 12 then
          MinutesString := ChooseNonEmpty('PM',TimePMString)
        else
          MinutesString := ChooseNonEmpty('AM',TimeAMString);
      end;
      if Hours > 12 then
        Hours := Hours - 12
    end;
  end;

  HoursString := Format('%d', [Hours]);

  if Assigned(OnPlanTimeToStrings) then
    OnPlanTimeToStrings(Self, MinutesValue, HoursString, MinutesString, AmPmString);
end;

function TCustomPlanner.PlanTimeToStr(MinutesValue: Integer): string;
// Result: "HH:MM" (24 hr format) or "HH:MM ZZ" (12 hr format) where ZZ is TimePMString or TimeAMString
var
  HoursString, MinutesString, AmPmString: string;
begin
  while MinutesValue < 0 do
    MinutesValue := MinutesValue + MININDAY;

  PlanTimeToStrings(MinutesValue, HoursString, MinutesString, AmPmString);
  Result := Format('%s%s%s', [HoursString, TimeSeparator, MinutesString]);
  if AmPmString <> '' then
    Result := Format('%s %s', [Result, AmPmString]);
end;


procedure TCustomPlanner.ItemSelected(Item: TPlannerItem);
begin
  if Assigned(OnItemSelect) then
    OnItemSelect(Self, Item);
end;

procedure TCustomPlanner.SetShadowColor(const Value: TColor);
begin
  if FShadowColor <> Value then
  begin
    FShadowColor := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.SetURLColor(const Value: TColor);
begin
  if FURLColor <> Value then
  begin
    FURLColor := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.HeaderSized(Sender: TObject; ASection, AWidth: Integer);
begin
  if ASection = 0 then
  begin
    if Sidebar.Position = spTop then
      AWidth := FGrid.RowHeights[0]
    else
    begin
      if not NavigatorButtons.Visible then
        AWidth := FGrid.ColWidths[0]
      else
        AWidth := FGrid.ColWidths[0] - BtnWidth;
    end;

    if FFlat then
      FHeader.SectionWidth[0] := AWidth
    else
      FHeader.SectionWidth[0] := AWidth + 2;

  end
  else
  begin
    if FNavigatorButtons.Visible then
      PositionWidth := AWidth + BtnWidth
    else
      PositionWidth := AWidth;
  end;
end;

function TCustomPlanner.CreateItemAtSelection: TPlannerItem;
begin

  Result := Items.Add;
  Result.ItemBegin := SelItemBegin;
  Result.ItemEnd := SelItemEnd;
  Result.ItemPos := SelPosition;

  FGrid.UpdateNVI;
end;

function TCustomPlanner.CloneItemAtSelection(Item: TPlannerItem): TPlannerItem;
begin
  Result := CloneItem(Item);
  Result.ItemBegin := SelItemBegin;
  Result.ItemEnd := SelItemEnd;
  Result.ItemPos := SelPosition;
end;

procedure TCustomPlanner.SetEnableAlarms(const Value: Boolean);
begin
  FEnableAlarms := Value;
  UpdateTimer;
end;

procedure TCustomPlanner.SetEnableFlashing(const Value: Boolean);
begin
  FEnableFlashing := Value;
  UpdateTimer;
end;

procedure TCustomPlanner.SetPositionProps(const Value: TPositionProps);
begin
  FPositionProps.Assign(Value);
end;

function TCustomPlanner.CreateItems: TPlannerItems;
begin
  Result := TPlannerItems.Create(Self);
end;

procedure TCustomPlanner.Refresh;
begin

end;

function TCustomPlanner.IndexToTime(Index: Integer): TDateTime;
begin
  Result := 0;
  
  if Mode.PlannerType = plCustomList then
  begin
    if Index < FDTList.Count then
      Result := FDTList.Items[Index];
  end;

  if Assigned(FOnCustomITEvent) then
    FOnCustomITEvent(Self,Index,Result);
end;

function TCustomPlanner.TimeToIndex(DT: TDateTime): Integer;
var
  Idx: Integer;
begin
  Result := 0;
  if Mode.PlannerType = plCustomList then
  begin
    Idx := 0;
    while Idx < FDTList.Count do
    begin
      if FDTList.Items[Idx] >= DT then
      begin
        Result := Idx;
        Break;
      end
      else
       Inc(Idx);
    end;
  end;

  if Assigned(FOnCustomTIEvent) then
    FOnCustomTIEvent(Self,DT,Result);
end;

function TCustomPlanner.PosToDay(Pos: Integer): TDateTime;
begin
  Result := 0;
  if Assigned(FOnPositionToDay) then
    FOnPositionToDay(Self,Pos,Result);
end;


procedure TCustomPlanner.SetFlashColor(const Value: TColor);
begin
  if FFlashColor <> Value then
  begin
    FFlashColor := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.SetFlashFontColor(const Value: TColor);
begin
  if FFlashFontColor <> Value then
  begin
    FFlashFontColor := Value;
    Invalidate;
  end;
end;

procedure TCustomPlanner.ExportItem(APlannerItem: TPlannerItem);
begin
  APlannerItem.DoExport := True;
end;

procedure TCustomPlanner.ExportItems;
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items.Items[i - 1].DoExport := True;
end;

procedure TCustomPlanner.ExportClear;
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items.Items[i - 1].DoExport := False;
end;


procedure TCustomPlanner.ExportLayer(Layer: Integer);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    if Items.Items[i - 1].Layer and Layer = Layer then
      Items.Items[i - 1].DoExport := True;
end;

procedure TCustomPlanner.ExportPosition(Pos: Integer);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    if Items.Items[i - 1].ItemPos = Pos then
      Items.Items[i - 1].DoExport := True;
end;

procedure TCustomPlanner.HilightInItem(APlannerItem: TPlannerItem; AText: string;
  DoCase: Boolean);
begin
  APlannerItem.Text.Text := Hilight(APlannerItem.Text.Text,AText,'hi',DoCase);
end;

procedure TCustomPlanner.HilightInItems(AText: string; DoCase: Boolean);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items.Items[i - 1].Text.Text := Hilight(Items.Items[i - 1].Text.Text,AText,'hi',DoCase);
end;

procedure TCustomPlanner.HilightInPositon(Pos: Integer; AText: string;
  DoCase: Boolean);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    if Items.Items[i - 1].ItemPos = Pos then
      Items.Items[i - 1].Text.Text := Hilight(Items.Items[i - 1].Text.Text,AText,'hi',DoCase);
end;

procedure TCustomPlanner.MarkInItem(APlannerItem: TPlannerItem; AText: string;
  DoCase: Boolean);
begin
  APlannerItem.Text.Text := Hilight(APlannerItem.Text.Text,AText,'e',DoCase);
end;

procedure TCustomPlanner.MarkInItems(AText: string; DoCase: Boolean);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items.Items[i - 1].Text.Text := Hilight(Items.Items[i - 1].Text.Text,AText,'e',DoCase);
end;

procedure TCustomPlanner.MarkInPositon(Pos: Integer; AText: string;
  DoCase: Boolean);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    if Items.Items[i - 1].ItemPos = Pos then
      Items.Items[i - 1].Text.Text := Hilight(Items.Items[i - 1].Text.Text,AText,'e',DoCase);
end;

procedure TCustomPlanner.UnHilightInItem(APlannerItem: TPlannerItem);
begin
  APlannerItem.Text.Text := UnHilight(APlannerItem.Text.Text,'hi');
end;

procedure TCustomPlanner.UnHilightInItems;
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items.Items[i - 1].Text.Text := UnHilight(Items.Items[i - 1].Text.Text,'hi');
end;

procedure TCustomPlanner.UnHilightInPositon(Pos: Integer);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    if Items.Items[i - 1].ItemPos = Pos then
      Items.Items[i - 1].Text.Text := UnHilight(Items.Items[i - 1].Text.Text,'hi');
end;

procedure TCustomPlanner.UnMarkInItem(APlannerItem: TPlannerItem);
begin
  APlannerItem.Text.Text := UnHilight(APlannerItem.Text.Text,'e');
end;

procedure TCustomPlanner.UnMarkInItems;
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    Items.Items[i - 1].Text.Text := UnHilight(Items.Items[i - 1].Text.Text,'e');
end;

procedure TCustomPlanner.UnMarkInPositon(Pos: Integer);
var
  i: Integer;
begin
  for i := 1 to Items.Count do
    if Items.Items[i - 1].ItemPos = Pos then
      Items.Items[i - 1].Text.Text := UnHilight(Items.Items[i - 1].Text.Text,'e');
end;

function TCustomPlanner.GetDragCopy: Boolean;
begin
  Result := GetKeyState(VK_CONTROL) and $8000 = $8000;
end;

function TCustomPlanner.GetDragMove: Boolean;
begin
  Result := GetKeyState(VK_MENU) and $8000 = $8000;
end;

procedure TCustomPlanner.SetPositionGroup(const Value: Integer);
begin
  FPositionGroup := Value;
  FHeader.Invalidate;
end;

procedure TCustomPlanner.SetTrackBump(const Value: Boolean);
begin
  FTrackBump := Value;
  Invalidate;
end;

function TCustomPlanner.GetPositionWidths(Position: Integer): Integer;
begin
  if SideBar.Visible then
    inc(Position);

  if SideBar.Position <> spTop then
     Result := FGrid.ColWidths[Position]
   else
     Result := FGrid.RowHeights[Position];
end;

procedure TCustomPlanner.SetPositionWidths(Position: Integer;
  const Value: Integer);
begin
  if SideBar.Visible then
    Inc(Position);


  if SideBar.Position <> spTop then
  begin
    if Position >= FGrid.ColCount then
      Exit;
    FGrid.FPosResizing := True;
    FGrid.ColWidths[Position] := Value
  end
  else
  begin
    if Position >= FGrid.RowCount then
      Exit;
    FGrid.FPosResizing := True;
    FGrid.RowHeights[Position] := Value;
  end;  


  if Header.Visible then
    FHeader.SectionWidth[Position] := Value;

  FGrid.FPosResizing := False;
end;

procedure TCustomPlanner.SetPositionZoomWidth(const Value: Integer);
begin
  FPositionZoomWidth := Value;
  FHeader.Zoom := (FPositionZoomWidth > 0) and (PositionZoomWidth > PositionWidth);
  if FHeader.Zoom then
    Header.AllowResize := False
  else
    FHeader.Cursor := crDefault;
end;

procedure TCustomPlanner.SetSelectBlend(const Value: Integer);
begin
  if (Value > 100) or (Value < 0) then
    raise Exception.Create('Illegal blend factor');
  FSelectBlend := Value;
  Invalidate;
end;

procedure TCustomPlanner.SelectCells(SelBegin, SelEnd, SelPos: Integer);
begin
  SelPosition := SelPos;
  SelItemEnd := SelEnd;
  SelItemBegin := SelBegin;
  SelItemEnd := SelEnd;
  SelItemBegin := SelBegin;
end;

function TCustomPlanner.GetSelMinMax(Pos: Integer; var SelMin,
  SelMax: Integer): Boolean;
begin
  Result := False;
  if (PositionProps.Count >= Pos) and (Pos > 0) then
  begin
    if PositionProps[Pos - 1].Use then
    begin
      Result := True;
      SelMin := PositionProps[Pos - 1].MinSelection;
      SelMax := PositionProps[Pos - 1].MaxSelection;
    end;  
  end;
end;

procedure TCustomPlanner.SetShowHint(const Value: Boolean);
begin
  FShowHint := Value;
  FGrid.ShowHint := Value;
end;

procedure TCustomPlanner.UnZoomPosition(Pos: Integer);
begin
  if (Pos >=0) and (Pos < Positions) and
     (PositionWidth > 0) and (PositionZoomWidth > 0) then
  begin
    PositionWidths[Pos] := PositionWidth;
  end;
end;

procedure TCustomPlanner.ZoomPosition(Pos: Integer);
begin
  if (Pos >=0) and (Pos < Positions) and
     (PositionWidth > 0) and (PositionZoomWidth > 0) then
  begin
    PositionWidths[Pos] := PositionZoomWidth;
  end;
end;

procedure TCustomPlanner.UpdateNVI;
begin
  FGrid.UpdateNVI;
end;

function TCustomPlanner.GetVersionNr: Integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

function TCustomPlanner.GetVersionString:string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)))+' '+DATE_VER;
end;


function TCustomPlanner.GetCellTime(i, j: Integer): TDateTime;
var
  res,ID,Y: Integer;
begin
  Result := 0;

  case Mode.PlannerType of
    plDay,plTimeLine:
      begin
        res := (i + Display.DisplayStart) * Display.DisplayUnit + Display.DisplayOffset;
        ID := 0;
        while (res >= 24 * 60) do
        begin
          res := res - 60 * 24;
          inc(ID);
        end;

        Result := EncodeTime(res div 60, res mod 60, 0, 0);
        Result := Result + PosToDay(j) + ID;
      end;
    plMonth,plWeek:
      begin
        Result := Mode.StartOfMonth + i;
      end;
    plDayPeriod:
      begin
        Result := Mode.PeriodStartDate + i;
      end;
    plHalfDayPeriod:
      begin
        Result := Mode.PeriodStartDate + i / 2;
      end;
    plMultiMonth:
      begin
        res := Mode.Month + j;
        Y := Mode.Year;
        while (res > 12) do
        begin
          res := res - 12;
          inc(y);
        end;
        Result := EncodeDate(y,res,i + 1);
      end;
    plCustom, plCustomList:
      begin
        Result := IndexToTime(i);
      end;
  end;
end;

function TCustomPlanner.CellRect(X,Y: Integer): TRect;
begin
  Result := FGrid.CellRect(X,Y);
end;

function TCustomPlanner.CellToTime(X, Y: Integer): TDateTime;
begin
  if SideBar.Position = spTop then
    Result := GetCellTime(X,Y)
  else
    Result := GetCellTime(Y,X);
end;

{ TPlannerGrid }

constructor TPlannerGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ColCount := 2;
  FixedCols := 1;
  FixedRows := 0;
  RowCount := 49;
  ColWidths[0] := 40;
  GridLineWidth := 0;
  FUpdateCount := 0;
  FSaveCellExtents := False;
  Options := [goRangeSelect];
  Width := 200;
  Height := 250;
  DefaultDrawing := False;

  FEraseBkGnd := False;
  FPlanner := AOwner as TCustomPlanner;

  FMemo := TPlannerMemo.Create(Self);
  FMemo.Parent := Self;
  FMemo.Visible := False;
  FMemo.Width := 0;
  FMemo.Height := 0;
  FMemo.Planner := FPlanner;

  FMaskEdit := TPlannerMaskEdit.Create(Self);
  FMaskEdit.Parent := Self;
  FMaskEdit.Visible := False;
  FMaskEdit.Width := 0;
  FMaskEdit.Height := 0;

  FMouseDownMove := False;
  FMouseDownSizeUp := False;
  FMouseDownSizeDown := False;
  FMouseStart := False;

  FColorList := TPlannerColorArrayList.Create;

  FScrollHintWindow := THintWindow.Create(Self);
  FOldSelection := Selection;

  BorderStyle := bsNone;
  Ctl3D := False;
  FInplaceEdit := TEdit.Create(Self);
  FInplaceEdit.Visible := False;
  FInplaceCombo := TPlanCombobox.Create(Self);
  FInplaceCombo.Visible := False;
  FInplaceCombo.IsWinXP := IsWinXP;
end;

procedure TPlannerGrid.CreateWnd;
begin
  inherited;
  FPlanner.FRichEdit.Parent := Self;
  FPlanner.FRichEdit.Left := 0;
  FPlanner.FRichEdit.Width := 0;
  FPlanner.FRichEdit.Visible := False;
  FPlanner.FRichEdit.BorderStyle := bsNone;
  FPlanner.FRichEdit.OnSelectionChange := FPlanner.SelChange;
end;

destructor TPlannerGrid.Destroy;
begin
  FPlanner.Items.Clear;
  FMemo.Free;
  FMaskEdit.Free;
  FColorList.Free;
  FScrollHintWindow.Free;
  FInplaceEdit.Free;
  FInplaceCombo.Free;
  inherited Destroy;
end;

procedure TPlannerGrid.SetActiveCellShow(AValue: TActiveCellShow);
begin
  FActiveCellShow := AValue;
  Invalidate;
end;

{$IFDEF DELPHI4_LVL}
procedure TPlannerGrid.Resize;
{$ENDIF}
{$IFNDEF DELPHI4_LVL}
procedure TPlannerGrid.WMSize(var WMSize: TWMSize);
{$ENDIF}
begin
  inherited;
  if not Assigned(FPlanner) then
    Exit;

  if FPosResizing then
    Exit;

  UpdatePositions;
  if FPlanner.Display.ScaleToFit then
    FPlanner.Display.AutoScale;
end;

procedure TPlannerGrid.Loaded;
begin
  inherited Loaded;
end;

procedure TPlannerGrid.HideSelection;
begin
  FHiddenSelection := Selection;
  if HandleAllocated then
    Self.Selection := TGridRect(Rect(ColCount, RowCount, ColCount, RowCount))
  else
    Self.Selection := TGridRect(Rect(-1, -1, -1, -1))
end;

procedure TPlannerGrid.UnHideSelection;
begin
  Selection := FHiddenSelection;
end;

procedure TPlannerGrid.BeginUpdate;
begin
  Perform(WM_SETREDRAW,integer(False),0);
end;

procedure TPlannerGrid.EndUpdate;
begin
  Perform(WM_SETREDRAW,integer(True),0);
  Repaint;
end;


procedure TPlannerGrid.RTFPaint(ARect: TRect; const rtf: string; Background: TColor);
const
  RTF_OFFSET = 2;
  TWIPS_FACTOR = 1440;

type
  TFormatRange = record
    hdc: hdc;
    hdcTarget: hdc;
    rc: TRect;
    rcPage: TRect;
    chrg: TCharRange;
  end;
var
  FormatRange: TFormatRange;
  nLogPixelsX, nLogPixelsY: Integer;
  SaveMapMode: Integer;
  SaveText: string;
  SaveSelStart, SaveSelLength: Integer;
begin
  SaveText := FPlanner.RichToText;
  SaveSelStart := FPlanner.RichEdit.SelStart;
  SaveSelLength := FPlanner.RichEdit.SelLength;
  try
    FPlanner.TextToRich(rtf);

    SendMessage(FPlanner.RichEdit.Handle, EM_SETBKGNDCOLOR, 0, ColorToRGb(Background));

    FillChar(FormatRange, SizeOf(TFormatRange), 0);

    LPtoDP(Canvas.Handle, ARect.TopLeft, 1);
    LPtoDP(Canvas.Handle, ARect.BottomRight, 1);

    nLogPixelsX := GetDeviceCaps(Canvas.Handle, LOGPIXELSX);
    nLogPixelsY := GetDeviceCaps(Canvas.Handle, LOGPIXELSY);

    with FormatRange do
    begin
      FormatRange.hdc := Canvas.Handle;
      FormatRange.hdcTarget := Canvas.Handle;
      {convert to twips}{ 1440 TWIPS = 1 inch. }
      FormatRange.rcPage.Left := Round(((ARect.Left + RTF_OFFSET) / nLogPixelsX) * TWIPS_FACTOR); 
      FormatRange.rcPage.Top := Round(((ARect.Top + RTF_OFFSET) / nLogPixelsY) * TWIPS_FACTOR);
      FormatRange.rcPage.Right := FormatRange.rcPage.Left +
        Round(((ARect.Right - ARect.Left - RTF_OFFSET) / nLogPixelsX) * TWIPS_FACTOR);
      FormatRange.rcPage.Bottom := (FormatRange.rcPage.Top +
        Round(((ARect.Bottom - ARect.Top - RTF_OFFSET) / nLogPixelsY) * TWIPS_FACTOR));
      FormatRange.rc := FormatRange.rcPage;
      FormatRange.chrg.cpMin := 0;
      FormatRange.chrg.cpMax := -1;
    end;

    SaveMapMode := GetMapMode(Canvas.Handle);
    try
      SetMapMode(Canvas.Handle, mm_text);
      SendMessage(FPlanner.FRichEdit.Handle, EM_FORMATRANGE, 1, LongInt(@FormatRange));
      {clear the richtext cache}
      SendMessage(FPlanner.FRichEdit.Handle, EM_FORMATRANGE, 0, 0);
    finally
      SetMapMode(Canvas.Handle, SaveMapMode);
    end;

  finally
    FPlanner.TextToRich(SaveText);
    FPlanner.RichEdit.SelStart := SaveSelStart;
    FPlanner.RichEdit.SelLength := SaveSelLength;
  end;
end;

(*
PROCEDURE PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
  VAR
    BitmapHeader:  pBitmapInfo;
    BitmapImage:  POINTER;
    HeaderSize :  DWORD;
    ImageSize  :  DWORD;
BEGIN
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage,  ImageSize);
  TRY
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
                  DestRect.Left, DestRect.Top,     // Destination Origin
                  DestRect.Right  - DestRect.Left, // Destination Width
                  DestRect.Bottom - DestRect.Top,  // Destination Height
                  0, 0,                            // Source Origin
                  Bitmap.Width, Bitmap.Height,     // Source Width & Height
                  BitmapImage,
                  TBitmapInfo(BitmapHeader^),
                  DIB_RGB_COLORS,
                  SRCCOPY)
  FINALLY
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  END
END {PrintBitmap};
*)

const
  DefaultPixelsPerInch = 96;


function TrackBarWidth(TrackBarLogicalPixels:Integer; Canvas: TCanvas): Integer;
begin
  Result := Round(
    TrackBarLogicalPixels * GetDeviceCaps(Canvas.Handle, LOGPIXELSX) /
    DefaultPixelsPerInch
    );
end;

function TrackBarHeight(TrackBarLogicalPixels:Integer; Canvas: TCanvas): Integer;
begin
  Result := Round(
    TrackBarLogicalPixels * GetDeviceCaps(Canvas.Handle, LOGPIXELSY) /
    DefaultPixelsPerInch
    );
end;

function ConcatenateTextStrings(Text: TStrings): string;
var
  Index: Integer;
begin
  Result := '';
  for Index := 0 to Text.Count - 1 do
    Result := Result + Text.Strings[Index];
end;

procedure TPlannerGrid.PaintItemCol(Canvas: TCanvas; ARect: TRect; APlannerItem:
  TPlannerItem; Print, SelColor: Boolean);
var
  PaintString, Anchor, StrippedHTMLString, CaptionPaintString, FocusAnchor: string;
  r, ro, hr, cr, sr: TRect;
  ColumnHeight, i, iw, ih, pw, ph, ImageIndex, ml, hl: Integer;
  MultiImage: Boolean;
  HorizontalAlign, DrawFlags: DWORD;
  rr, dr, XSize, YSize: Integer;
  PlannerImagePoint: TPoint;
  Bitmap: TBitmap;
  Background: TColor;
  CID,CV,CT: string;
  pt: TPoint;
  tmpBegin, tmpEnd: integer;
  CellColor, OldColor: TColor;
  HRGN: THandle;

label
  BackGroundOnly;
begin
  if APlannerItem.Repainted then
    Exit;



  if APlannerItem.ItemBegin = APlannerItem.ItemEnd then
    Exit;

  CellColor := Canvas.Brush.Color;

  if not (csDesigning in FPlanner.ComponentState) and not Print then
    APlannerItem.Repainted := True;

  if not APlannerItem.Background and not APlannerItem.InHeader then
    ARect.Right := ARect.Right - FPlanner.FItemGap;

  if Assigned(APlannerItem.FPlanner.OnPlannerItemDraw) then
  begin
    try
      APlannerItem.FPlanner.OnPlannerItemDraw(APlannerItem.FPlanner, APlannerItem,
        Canvas, ARect, False);
      Exit;
    except
      on e: EAbort do {nothing};
    end;
  end;

  if (APlannerItem.Shape = psTool) and Assigned(APlannerItem.DrawTool) then
  begin
    APlannerItem.DrawTool.DrawItem(APlannerItem,Canvas,ARect,APlannerItem.Selected,Print);
    Exit;
  end;

  if APlannerItem.Shadow and not APlannerItem.Background and (APlannerItem.Shape = psRect) then
  begin
    Canvas.Brush.Color := FPlanner.ShadowColor;
    Canvas.Pen.Color := Canvas.Brush.Color;
    Canvas.Rectangle(ARect.Right - 3,ARect.Top + 3,ARect.Right,ARect.Bottom);
    Canvas.Rectangle(ARect.Left + 3,ARect.Bottom - 3,ARect.Right,ARect.Bottom);
    Canvas.Brush.Color := CellColor;
    Canvas.Pen.Color := CellColor;
    Canvas.Rectangle(ARect.Right - 3,ARect.Top ,ARect.Right,ARect.Top + 3);
    Canvas.Rectangle(ARect.Left ,ARect.Bottom - 4,ARect.Left + 3,ARect.Bottom -1);

    ARect.Right := ARect.Right - 3;
    ARect.Bottom := ARect.Bottom - 3;
  end;

  if APlannerItem.Background then
    ARect.Bottom := ARect.Bottom - 1;

  ro := ARect;
  r := ARect;

  APlannerItem.FClipped := False;

  Background := APlannerItem.Color;

  if APlannerItem.Selected and
     APlannerItem.ShowSelection {and
     not APlannerItem.InHeader} then
    Background := APlannerItem.SelectColor;

  if (APlannerItem.Background) then
  begin
    if APlannerItem.BrushStyle <> bsSolid then
    begin
      Canvas.Brush.Color := Background;
      Canvas.Brush.Style := APlannerItem.BrushStyle;
      SetBkMode(Canvas.Handle, TRANSPARENT);
      SetBkColor(Canvas.Handle, ColorToRGb(FPlanner.Color));
    end;

    goto BackGroundOnly;
  end;

  {Draw the item trackbar}
  r.Right := r.Left + TrackBarWidth(APlannerItem.FPlanner.TrackWidth,Canvas);

  if not APlannerItem.InHeader and
     APlannerItem.TrackVisible and
     (APlannerItem.Shape = psRect) then
  begin
    if (FPlanner.TrackProportional) then
    begin
      Canvas.Brush.Color := FPlanner.Display.ColorActive;
      Canvas.FillRect(r);

      dr := APlannerItem.FItemBeginPrecis - (APlannerItem.FItemBegin +
        FPlanner.Display.DisplayStart) * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;

      dr := Round(dr / FPlanner.Display.DisplayUnit * FPlanner.Display.DisplayScale);
      rr := Round((APlannerItem.FItemEndPrecis - APlannerItem.FItemBeginPrecis) /
        FPlanner.Display.DisplayUnit * FPlanner.Display.DisplayScale) + FPlanner.Display.DisplayOffset;
    end
    else
    begin
      dr := 0;
      rr := r.Bottom - r.Top;
    end;

    r.Top := r.Top + dr;
    r.Bottom := r.Top + rr;

    Canvas.Brush.Color := APlannerItem.TrackColor;
    Canvas.FillRect(r);

    if FPlanner.TrackBump then
      DrawBumpVert(Canvas,r,APlannerItem.TrackColor);

    ARect.Left := ARect.Left + TrackBarWidth(APlannerItem.FPlanner.TrackWidth,Canvas);

    for i := 0 to APlannerItem.BarItems.Count - 1 do
    begin
      with APlannerItem.BarItems[i] do
      begin
        tmpBegin := BarBegin;
        tmpEnd := BarEnd;
        if BarBegin = -1 then
          tmpBegin := 0;
        if BarEnd = -1 then
          tmpEnd := APlannerItem.ItemEnd - APlannerItem.ItemBegin;

        rr := (r.Bottom - r.Top) div (APlannerItem.ItemEnd - APlannerItem.ItemBegin);
        sr.Top := r.Top + (tmpBegin * rr);
        sr.Bottom := r.Top + (tmpEnd * rr);
        sr.Left := r.Left ;
        sr.Right :=  Arect.Left;
        Canvas.Brush.Color := BarColor;
        Canvas.Pen.Color := APlannerItem.TrackColor;
        Canvas.Brush.Style := BarStyle;
        Canvas.Rectangle(sr.Left,sr.Top,sr.Right,sr.Bottom);
       end;
    end;
  end;

  if APlannerItem.FIsCurrent and not Print then
  begin
    Background := FPlanner.FDisplay.FColorCurrentItem;
    Canvas.Brush.Color := Background;
  end
  else
  begin
    if APlannerItem.BrushStyle <> bsSolid then
    begin
      Background := APlannerItem.Color;

      Canvas.Brush.Color := Background;
      Canvas.Brush.Style := APlannerItem.BrushStyle;

      SetBkMode(Canvas.Handle, TRANSPARENT);
      SetBkColor(Canvas.Handle, ColorToRGb(FPlanner.Color));
    end
    else
      Canvas.Brush.Color := Background;
  end;

  if APlannerItem.Flashing and APlannerItem.FlashOn then
    Canvas.Brush.Color := FPlanner.FlashColor;

  case APlannerItem.Shape of
  psRect:
    begin
      Canvas.FillRect(ARect);
      Canvas.Pen.Color := clBlack;

      Canvas.Polygon([Point(ARect.Left, ARect.Top),
                      Point(ARect.Right - 1, ARect.Top),
                      Point(ARect.Right - 1, ARect.Bottom - 1),
                      Point(ARect.Left, ARect.Bottom - 1)]);

    end;
  psRounded:
    begin
      InflateRect(ARect,-1,-1);

      if APlannerItem.Shadow then
      begin
        InflateRect(ARect,-2,-2);
        Canvas.Pen.Color := FPlanner.ShadowColor;
        Canvas.Pen.Width := 2;
        OldColor := Canvas.Brush.Color;
        Canvas.Brush.Color := FPlanner.ShadowColor;

        Canvas.RoundRect(ARect.Left + 2,ARect.Top + 2,ARect.Right + 2,ARect.Bottom + 2,CORNER_EFFECT,CORNER_EFFECT);

        Canvas.Brush.Color := OldColor;
      end;

      if APlannerItem.TrackVisible and APlannerItem.FFocus then
      begin
        Canvas.Pen.Color := APlannerItem.TrackColor;
        Canvas.Pen.Width := 2;
      end
      else
      begin
        Canvas.Pen.Color := clBlack;
        Canvas.Pen.Width := 1;
      end;
      Canvas.RoundRect(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom,CORNER_EFFECT,CORNER_EFFECT);
      InflateRect(ARect,-(CORNER_EFFECT shr 1),-(CORNER_EFFECT shr 1));
    end;
  psHexagon:
    begin
      InflateRect(ARect,-1,-1);

      if APlannerItem.Shadow then
      begin
        InflateRect(ARect,-2,-2);
        Canvas.Pen.Color := FPlanner.ShadowColor;
        Canvas.Pen.Width := 2;
        OldColor := Canvas.Brush.Color;
        Canvas.Brush.Color := FPlanner.ShadowColor;

        Canvas.Polygon([Point(2 + ARect.Left + CORNER_EFFECT, 2 + ARect.Top),
                        Point(2 + ARect.Right - 1 - CORNER_EFFECT, 2 + ARect.Top),
                        Point(2 + ARect.Right - 1, 2 + ARect.Top +((Arect.Bottom - ARect.Top) shr 1)),
                        Point(2 + ARect.Right - 1 - CORNER_EFFECT, 2 + ARect.Bottom - 2),
                        Point(2 + ARect.Left + CORNER_EFFECT, 2 + ARect.Bottom - 2),
                        Point(2 + ARect.Left, 2 + ARect.Top +((Arect.Bottom - ARect.Top) shr 1))]);

        Canvas.Brush.Color := OldColor;
      end;

      if APlannerItem.TrackVisible and APlannerItem.FFocus then
      begin
        Canvas.Pen.Color := APlannerItem.TrackColor;
        Canvas.Pen.Width := 2;
      end
      else
      begin
        Canvas.Pen.Color := clBlack;
        Canvas.Pen.Width := 1;
      end;


      Canvas.Polygon([Point(ARect.Left + CORNER_EFFECT, ARect.Top),
                      Point(ARect.Right - 1 - CORNER_EFFECT, ARect.Top),
                      Point(ARect.Right - 1, ARect.Top +((Arect.Bottom - ARect.Top) shr 1)),
                      Point(ARect.Right - 1 - CORNER_EFFECT, ARect.Bottom - 2),
                      Point(ARect.Left + CORNER_EFFECT, ARect.Bottom - 2),
                      Point(ARect.Left, ARect.Top +((Arect.Bottom - ARect.Top) shr 1))]);
      InflateRect(ARect,-CORNER_EFFECT,0);
    end;
  end;

  Canvas.Brush.Style := bsSolid;

  if APlannerItem.FFocus and
     not Print and
     APlannerItem.FTrackVisible and
     (APlannerItem.Shape = psRect) and
     not APlannerItem.InHeader then
  begin
    Canvas.Brush.Color := APlannerItem.TrackColor;
    r := ARect;
    r.Bottom := r.Top + 3;
    Canvas.FillRect(r);
    r := ARect;
    r.Top := ARect.Bottom - 4;
    r.Bottom := ARect.Bottom;
    Canvas.FillRect(r);
  end;


  BackGroundOnly:

  if APlannerItem.FIsCurrent and not Print then
    Canvas.Brush.Color := FPlanner.FDisplay.FColorCurrentItem
  else
    Canvas.Brush.Color := APlannerItem.Color;

  InflateRect(ARect, -2, -4);

  if APlannerItem.Background then
  begin
    if APlannerItem.Transparent and SelColor then
      Canvas.Brush.Color := BlendColor(CellColor,APlannerItem.Color,FPlanner.SelectBlend);

    Canvas.FillRect(r);
    Canvas.Pen.Color := APlannerItem.FPlanner.GridLineColor;

    Canvas.Moveto(r.Left,r.Bottom);
    Canvas.Lineto(r.Right - 1,r.Bottom);
  end;

  ih := 0;
  iw := 0;
  MultiImage := False;

  if (APlannerItem.FBeginOffset <> 0) or (APlannerItem.FEndOffset <> 0) then
    ARect.Right := ARect.Right - 8;

  if Assigned(APlannerItem.FPlanner.PlannerImages) then
  begin
    PlannerImagePoint.X := Round((APlannerItem.FPlanner.PlannerImages.Width + 2) *
      GetDeviceCaps(Canvas.Handle, LOGPIXELSX) / 96);
    PlannerImagePoint.Y := Round((APlannerItem.FPlanner.PlannerImages.Height + 2) *
      GetDeviceCaps(Canvas.Handle, LOGPIXELSY) / 96);


    if (APlannerItem.ImageID >= 0) and Assigned(APlannerItem.FPlanner.PlannerImages) then
    begin
      if ARect.Left + APlannerItem.FPlanner.PlannerImages.Width < ARect.Right then
      begin
        iw := PlannerImagePoint.X;
        ih := PlannerImagePoint.Y;
        if Print then
        begin
          Bitmap := TBitmap.Create;
          APlannerItem.FPlanner.PlannerImages.GetBitmap(APlannerItem.ImageID, Bitmap);
          PrintBitmap(Canvas, Rect(ARect.Left, ARect.Top, ARect.Left + iw,
            ARect.Top + ih), Bitmap);
          Bitmap.Free;
        end
        else
          APlannerItem.FPlanner.PlannerImages.Draw(Canvas, ARect.Left, ARect.Top,
            APlannerItem.ImageID);
      end;
    end;

    for ImageIndex := 0 to APlannerItem.FImageIndexList.Count - 1 do
    begin
      if ARect.Left + iw + APlannerItem.FPlanner.PlannerImages.Width < ARect.Right then
      begin
        if Print then
        begin
          Bitmap := TBitmap.Create;
          try
            APlannerItem.FPlanner.PlannerImages.GetBitmap(
              APlannerItem.FImageIndexList.Items[ImageIndex], Bitmap);
            PrintBitmap(Canvas, Rect(ARect.Left + iw, ARect.Top,
              ARect.Left + iw + PlannerImagePoint.X, ARect.Top + ih), Bitmap);
          finally
            Bitmap.Free;
          end;
        end
        else
          APlannerItem.FPlanner.PlannerImages.Draw(Canvas, ARect.Left + iw, ARect.Top,
            APlannerItem.FImageIndexList.Items[ImageIndex]);

        iw := iw + PlannerImagePoint.X;
        ih := PlannerImagePoint.Y;
      end;
      MultiImage := True;
    end;
  end;

  if APlannerItem.CaptionType in [ctTime, ctText, ctTimeText] then
  begin
    Canvas.Font.Assign(APlannerItem.CaptionFont);

    if APlannerItem.Selected and
      APlannerItem.ShowSelection then
      Canvas.Font.Color := APlannerItem.SelectFontColor;

    ColumnHeight := Canvas.TextHeight('gh');

    if APlannerItem.Flashing and APlannerItem.FlashOn and APlannerItem.UniformBkg then
      Canvas.Font.Color := FPlanner.FlashFontColor;

    ih := Max(ih, ColumnHeight);

    // Draw line under Caption
    if ARect.Top + ih + 1 < ARect.Bottom then
    begin
      Canvas.MoveTo(ARect.Left, ARect.Top + ih + 1);
      Canvas.LineTo(ARect.Right, ARect.Top + ih + 1);
    end;

    ih := Min(ARect.Bottom - ARect.Top - 1, ih);

    if not APlannerItem.UniformBkg then
    begin
      Canvas.Brush.Color := APlannerItem.CaptionBkg;
      Canvas.Pen.Color := APlannerItem.CaptionBkg;
    end
    else
    begin
      if APlannerItem.Flashing and APlannerItem.FlashOn then
        Canvas.Brush.Color := FPlanner.FlashColor
      else
        Canvas.Brush.Color := Background;
    end;

    r := ARect;

    r.Left := ARect.Left + iw;
    r.Bottom := r.Top + ih;
    Inflaterect(r,1,1);
    if not APlannerItem.Focus then
      r.Top := r.Top - 2;

    if APlannerItem.CaptionBkgTo <> clNone then
      DrawGradient(Canvas,APlannerItem.CaptionBkg,APlannerItem.CaptionBkgTo,FPlanner.GradientSteps,r,not FPlanner.GradientHorizontal)
    else
      Canvas.FillRect(r);

    if not APlannerItem.Focus then
      r.Top := r.Top + 2;

    ih := ih + 2;

    if (APlannerItem.URL <> '') and (r.Right - r.Left > 32) then
      r.Right := r.Right -16;

    if (APlannerItem.Attachement <> '')  and (r.Right - r.Left > 32) then
      r.Right := r.Right -16;

    CaptionPaintString := APlannerItem.GetCaptionString;

    HorizontalAlign := AlignToFlag(APlannerItem.CaptionAlign);
    SetBkMode(Canvas.Handle, TRANSPARENT);

    if IsHtml(APlannerItem,CaptionPaintString) then
      HTMLDrawEx(Canvas, CaptionPaintString, r, FPlanner.PlannerImages, 0, 0, -1, -1, 1, False, False,
        Print, False, True, False, False
        ,False
        , FPlanner.FHTMLFactor, FPlanner.URLColor, clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
        , cr, CID, CV, CT,FPlanner.FImageCache, FPlanner.FContainer, Handle
        )
    else
    begin
      DrawFlags := DT_NOPREFIX or DT_END_ELLIPSIS or HorizontalAlign;
      {$IFDEF DELPHI4_LVL}
      DrawFlags := FPlanner.DrawTextBiDiModeFlags(DrawFlags);
      {$ENDIF}
      DrawText(Canvas.Handle, PChar(CaptionPaintString), Length(CaptionPaintString), r, DrawFlags);

    end;

    r.Right := ARect.Right;
    r.Top := r.Top - 2;

    if (APlannerItem.Attachement <> '') and (r.Right - r.Left > 32) then
    begin
      Bitmap := TBitmap.Create;
      Bitmap.LoadFromResourceID(HInstance,502);
      Bitmap.TransparentColor := Bitmap.Canvas.Pixels[0,0];
      Bitmap.Transparent := True;

      if Print then
      begin
        pw := Round(16 * GetDeviceCaps(Canvas.Handle, LOGPIXELSX) / 96);
        ph := Round(16 * GetDeviceCaps(Canvas.Handle, LOGPIXELSY) / 96);
        PrintBitmap(Canvas, Rect(r.Right - pw, r.Top, r.Right, r.Top + ph), Bitmap);
        r.Right := r.Right - pw;
      end
      else
      begin
        Canvas.Draw(r.Right - 16,r.Top,Bitmap);
        r.Right := r.Right - 16;
      end;

      Bitmap.Free;
    end;

    if (APlannerItem.URL <> '') and (r.Right - r.Left > 32) then
    begin
      Bitmap := TBitmap.Create;
      Bitmap.LoadFromResourceID(HInstance,503);
      Bitmap.TransparentColor := Bitmap.Canvas.Pixels[0,0];
      Bitmap.Transparent := True;

      if Print then
      begin
        pw := Round(16 * GetDeviceCaps(Canvas.Handle, LOGPIXELSX) / 96);
        ph := Round(16 * GetDeviceCaps(Canvas.Handle, LOGPIXELSY) / 96);
        PrintBitmap(Canvas, Rect(r.Right - pw, r.Top, r.Right, r.Top + ph), Bitmap);
      end
      else
        Canvas.Draw(r.Right - 16,r.Top,Bitmap);

      Bitmap.Free;
    end;

    iw := 0;
  end
  else
    ih := 0;

  if MultiImage then
  begin
    iw := 0;
    ih := PlannerImagePoint.Y;
  end;

  APlannerItem.FCaptionHeight := ih;

  ARect.Top := ARect.Top + ih + 2 + FPlanner.PaintMarginTY;
  ARect.Left := ARect.Left + iw + FPlanner.PaintMarginLX;

  ARect.Bottom := ARect.Bottom - FPlanner.PaintMarginBY;
  ARect.Right := ARect.Right - FPlanner.PaintMarginRX;

  if APlannerItem.CompletionDisplay = cdVertical then
  begin
    Canvas.Brush.Color := FPlanner.CompletionColor1;
    Canvas.Pen.Color := FPlanner.CompletionColor1;
    Canvas.Rectangle(ARect.Left,  ARect.Top - 1 + Round((100 - APlannerItem.Completion) / 100 * (ARect.Bottom - ARect.Top + 2)),ARect.Left + 10, ARect.Bottom);

    Canvas.Brush.Color := FPlanner.CompletionColor2;
    Canvas.Pen.Color := FPlanner.CompletionColor2;
    Canvas.Rectangle(ARect.Left, ARect.Top - 1, ARect.Left + 10,ARect.Top -  2+ Round((100 - APlannerItem.Completion) / 100 * (ARect.Bottom - ARect.Top + 2)));

    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := clBlack;
    Canvas.Rectangle(ARect.Left,ARect.Top - 1,ARect.Left + 10, ARect.Bottom );

    ARect.Left := ARect.Left + 11;
  end;

  if APlannerItem.CompletionDisplay = cdHorizontal then
  begin
    Canvas.Brush.Color := FPlanner.CompletionColor1;
    Canvas.Pen.Color := FPlanner.CompletionColor1;
    Canvas.Rectangle(ARect.Left,  ARect.Top, ARect.Left + Round((APlannerItem.Completion) / 100 * (ARect.Right - ARect.Left + 2)),ARect.Top + 10);

    Canvas.Brush.Color := FPlanner.CompletionColor2;
    Canvas.Pen.Color := FPlanner.CompletionColor2;
    Canvas.Rectangle(ARect.Left + Round((APlannerItem.Completion) / 100 * (ARect.Right - ARect.Left + 2)),ARect.Top, ARect.Right, ARect.Top + 10);

    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := clBlack;
    Canvas.Rectangle(ARect.Left,ARect.Top ,ARect.Right, ARect.Top + 10 );

    ARect.Top := ARect.Top + 11;
  end;

  PaintString := APlannerItem.ItemText;

  if Assigned(FPlanner.OnItemText) then
    FPlanner.OnItemText(FPlanner,APlannerItem,PaintString);

  Canvas.Font.Assign(APlannerItem.Font);

  if APlannerItem.Selected and APlannerItem.ShowSelection then
    Canvas.Font.Color := APlannerItem.SelectFontColor;

  if APlannerItem.Flashing and APlannerItem.FlashOn then
    Canvas.Font.Color := FPlanner.FlashFontColor;

  HorizontalAlign := AlignToFlag(APlannerItem.Alignment);
  if IsRtf(PaintString) then
    RTFPaint(ARect, PaintString, Background)
  else
  if IsHtml(APlannerItem,PaintString) then
  begin
    PaintString := ConcatenateTextStrings(APlannerItem.Text);

    GetCursorPos(pt);
    pt := ScreenToClient(pt);

    HRGN := CreateRectRgn(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom);
    SelectClipRgn(Canvas.Handle,HRGN);

    HTMLDrawEx(Canvas, PaintString, ARect, FPlanner.PlannerImages, pt.X, pt.Y, -1, -1, 1, False, False,
      Print, False, True, False, APlannerItem.FWordWrap
      , FMouseDown
      , FPlanner.FHTMLFactor, FPlanner.URLColor,
      clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
      , cr, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
      );

     SelectClipRgn(Canvas.Handle,0);
     DeleteObject(HRGN);
     
     APlannerItem.FClipped := YSize > (ARect.Bottom - ARect.Top);
  end
  else
  begin
    SetBkMode(Canvas.Handle, TRANSPARENT);

    DrawFlags := DT_NOPREFIX or DT_EDITCONTROL or HorizontalAlign;

    if APlannerItem.FWordWrap then
      DrawFlags := DrawFlags or DT_WORDBREAK
    else
      DrawFlags := DrawFlags or DT_SINGLELINE or DT_END_ELLIPSIS;

    {$IFDEF DELPHI4_LVL}
    DrawFlags := FPlanner.DrawTextBiDiModeFlags(DrawFlags);
    {$ENDIF}

    YSize := DrawTextEx(Canvas.Handle, PChar(PaintString), Length(PaintString), ARect, DrawFlags,nil);


    APlannerItem.FClipped := YSize > (ARect.Bottom - ARect.Top);
  end;

  if (APlannerItem.FBeginOffset <> 0) and not APlannerItem.InHeader then
  begin
    DrawArrow(Canvas,clBlue,ro.Right - 4 - FPlanner.TrackWidth,
      ro.Top + FPlanner.TrackWidth,adUp);
  end;

  if (APlannerItem.FEndOffset <> 0) and not APlannerItem.InHeader then
  begin
    DrawArrow(Canvas,clBlue,ro.Right - 4 - FPlanner.TrackWidth,
      ro.Bottom - 8 - FPlanner.TrackWidth,adDown);
  end;


end;

procedure TPlannerGrid.PaintItemRow(Canvas: TCanvas; ARect: TRect; APlannerItem:
  TPlannerItem; Print, SelColor: Boolean);
var
  PaintString, Anchor, StrippedHtmlString, CaptionPaintString, FocusAnchor: string;
  r, ro, hr, cr, sr: TRect;
  ColumnHeight, iw, ih, ImageIndex, ml, hl, i: Integer;
  MultiImage: Boolean;
  HorizontalAlign, DrawFlags: DWORD;
  rr, dr, XSize, YSize: Integer;
  PlannerImagePoint: TPoint;
  Bitmap: TBitmap;
  Background: TColor;
  CID,CV,CT: string;
  pt: TPoint;
  tmpBegin,tmpEnd: Integer;
  CellColor,OldColor: TColor;
  HRGN: THandle;

label
  BackGroundOnly;
begin
  if APlannerItem.Repainted then
    Exit;

  if APlannerItem.ItemBegin = APlannerItem.ItemEnd then
    Exit;

  if not (csDesigning in FPlanner.ComponentState) and not Print then
    APlannerItem.Repainted := True;

  if not APlannerItem.Background then
    ARect.Bottom := ARect.Bottom - FPlanner.FItemGap;

  if Assigned(APlannerItem.FPlanner.OnPlannerItemDraw) then
  begin
    APlannerItem.FPlanner.OnPlannerItemDraw(APlannerItem.FPlanner, APlannerItem, Canvas, ARect,
      False);
    Exit;
  end;

  if (APlannerItem.Shape = psTool) and Assigned(APlannerItem.DrawTool) then
  begin
    APlannerItem.DrawTool.DrawItem(APlannerItem,Canvas,ARect,APlannerItem.Selected,Print);
    Exit;
  end;


  CellColor := Canvas.Brush.Color;

  if APlannerItem.Shadow and not APlannerItem.Background and (APlannerItem.Shape = psRect) then
  begin
    Canvas.Brush.Color := FPlanner.ShadowColor;
    Canvas.Pen.Color := Canvas.Brush.Color;
    Canvas.Rectangle(ARect.Right - 3,ARect.Top + 3,ARect.Right,ARect.Bottom);
    Canvas.Rectangle(ARect.Left + 3,ARect.Bottom - 4,ARect.Right,ARect.Bottom - 1);
    Canvas.Brush.Color := CellColor;
    Canvas.Pen.Color := CellColor;
    Canvas.Rectangle(ARect.Right - 3,ARect.Top ,ARect.Right,ARect.Top + 3);
    Canvas.Rectangle(ARect.Left ,ARect.Bottom - 4,ARect.Left + 3,ARect.Bottom - 1);

    ARect.Right := ARect.Right - 3;
    ARect.Bottom := ARect.Bottom - 3;
  end;

  Canvas.Font.Assign(APlannerItem.Font);

  ro := ARect;
  r := ARect;
  Background := APlannerItem.Color;
  if APlannerItem.Selected and
     APlannerItem.ShowSelection and
     not APlannerItem.InHeader then
    Background := APlannerItem.SelectColor;

  APlannerItem.FClipped := False;

  if APlannerItem.Background then
  begin
    if APlannerItem.BrushStyle <> bsSolid then
    begin
      Canvas.Brush.Color := Background;
      Canvas.Brush.Style := APlannerItem.BrushStyle;
      SetBkMode(Canvas.Handle, TRANSPARENT);
      SetBkColor(Canvas.Handle, ColorToRGb(FPlanner.Color));
    end;
    goto BackGroundOnly;
  end;

  // Draw the item trackbar
  r.Bottom := r.Top + TrackBarHeight(APlannerItem.FPlanner.TrackWidth,Canvas);

  if APlannerItem.TrackVisible and
     (APlannerItem.Shape = psRect) then
  begin
    if FPlanner.TrackProportional then
    begin
      Canvas.Brush.Color := FPlanner.Display.ColorActive;
      Canvas.FillRect(r);
      dr := APlannerItem.FItemBeginPrecis - (APlannerItem.FItemBegin +
        FPlanner.Display.DisplayStart) * FPlanner.Display.DisplayUnit +  FPlanner.Display.DisplayOffset;
      dr := Round(dr / FPlanner.Display.DisplayUnit *
        FPlanner.Display.DisplayScale);
      rr := Round((APlannerItem.FItemEndPrecis - APlannerItem.FItemBeginPrecis) /
        FPlanner.Display.DisplayUnit * FPlanner.Display.DisplayScale) + FPlanner.Display.DisplayOffset;
    end
    else
    begin
      dr := 0;
      rr := r.Right - r.Left;
    end;

    r.Left := r.Left + dr;
    r.Right := r.Left + rr;

    Canvas.Brush.Color := APlannerItem.TrackColor;
    Canvas.FillRect(r);

    if FPlanner.TrackBump then
      DrawBumpHorz(Canvas,r,APlannerItem.TrackColor);

    ARect.Top := ARect.Top + TrackBarHeight(APlannerItem.FPlanner.TrackWidth,Canvas);

    for i := 0 to APlannerItem.BarItems.Count - 1 do
    begin
      with APlannerItem.BarItems[ i] do
      begin
        tmpBegin := BarBegin;
        tmpEnd := BarEnd;
        if BarBegin = -1 then
          tmpBegin := 0;
        if BarEnd = -1 then
          tmpEnd := APlannerItem.ItemEnd - APlannerItem.ItemBegin;

        rr := (r.Right - r.Left) div (APlannerItem.ItemEnd - APlannerItem.ItemBegin);
        sr.Left := r.Left + (tmpBegin * rr);
        sr.Right := r.Left + (tmpEnd * rr);
        sr.Top := r.Top + 2;
        sr.Bottom := r.Bottom - 1;
        Canvas.Brush.Color := BarColor;
        Canvas.Pen.Color := APlannerItem.TrackColor;
        Canvas.Brush.Style := BarStyle;
        Canvas.Rectangle(sr.Left,sr.Top,sr.Right,sr.Bottom);
       end;
    end;
  end;

  if APlannerItem.FIsCurrent and not Print then
  begin
    Background := FPlanner.FDisplay.FColorCurrentItem;
    Canvas.Brush.Color := Background;
  end
  else
  begin
    if APlannerItem.BrushStyle <> bsSolid then
    begin
      Background := APlannerItem.Color;
      Canvas.Brush.Color := Background;
      Canvas.Brush.Style := APlannerItem.BrushStyle;
      SetBkMode(Canvas.Handle, TRANSPARENT);
      SetBkColor(Canvas.Handle, ColorToRGb(FPlanner.Color));
    end
    else
      Canvas.Brush.Color := Background;
  end;

  if APlannerItem.Flashing and APlannerItem.FlashOn then
    Canvas.Brush.Color := FPlanner.FlashColor;

  case APlannerItem.Shape of
  psRect:
    begin
      hr := ARect;
      hr.Bottom := hr.Bottom - 1;
      Canvas.FillRect(hr);
      Canvas.Pen.Color := clBlack;
      Canvas.Polygon([Point(ARect.Left, ARect.Top),
                      Point(ARect.Right - 1, ARect.Top),
                      Point(ARect.Right - 1, ARect.Bottom - 2),
                      Point(ARect.Left, ARect.Bottom - 2)]);
    end;
  psRounded:
    begin
      InflateRect(ARect,-1,-1);

      if APlannerItem.Shadow then
      begin
        InflateRect(ARect,-2,-2);
        Canvas.Pen.Color := FPlanner.ShadowColor;
        Canvas.Pen.Width := 2;
        OldColor := Canvas.Brush.Color;
        Canvas.Brush.Color := FPlanner.ShadowColor;
        Canvas.RoundRect(ARect.Left + 2,ARect.Top + 2,ARect.Right + 2,ARect.Bottom + 2,CORNER_EFFECT,CORNER_EFFECT);
        Canvas.Brush.Color := OldColor;
      end;

      if APlannerItem.TrackVisible and APlannerItem.FFocus then
      begin
        Canvas.Pen.Color := APlannerItem.TrackColor;
        Canvas.Pen.Width := 2;
      end
      else
      begin
        Canvas.Pen.Color := clBlack;
        Canvas.Pen.Width := 1;
      end;

      Canvas.RoundRect(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom,CORNER_EFFECT,CORNER_EFFECT);

      InflateRect(ARect,-(CORNER_EFFECT shr 1),-(CORNER_EFFECT shr 1));
    end;
  psHexagon:
    begin
      InflateRect(ARect,-1,-1);

      if APlannerItem.Shadow then
      begin
        InflateRect(ARect,-2,-2);
        Canvas.Pen.Color := FPlanner.ShadowColor;
        Canvas.Pen.Width := 2;
        OldColor := Canvas.Brush.Color;
        Canvas.Brush.Color := FPlanner.ShadowColor;
        Canvas.Polygon([Point(2 + ARect.Left + CORNER_EFFECT, 2 + ARect.Top),
                        Point(2 + ARect.Right - 1 - CORNER_EFFECT, 2 + ARect.Top),
                        Point(2 + ARect.Right - 1, 2 + ARect.Top +((Arect.Bottom - ARect.Top) shr 1)),
                        Point(2 + ARect.Right - 1 - CORNER_EFFECT, 2 + ARect.Bottom - 2),
                        Point(2 + ARect.Left + CORNER_EFFECT, 2 + ARect.Bottom - 2),
                        Point(2 + ARect.Left, 2 + ARect.Top +((Arect.Bottom - ARect.Top) shr 1))]);

        Canvas.Brush.Color := OldColor;
      end;

      if APlannerItem.TrackVisible and APlannerItem.FFocus then
      begin
        Canvas.Pen.Color := APlannerItem.TrackColor;
        Canvas.Pen.Width := 2;
      end
      else
      begin
        Canvas.Pen.Color := clBlack;
        Canvas.Pen.Width := 1;
      end;

      Canvas.Polygon([Point(ARect.Left + CORNER_EFFECT, ARect.Top),
                      Point(ARect.Right - 1 - CORNER_EFFECT, ARect.Top),
                      Point(ARect.Right - 1, ARect.Top +((Arect.Bottom - ARect.Top) shr 1)),
                      Point(ARect.Right - 1 - CORNER_EFFECT, ARect.Bottom - 2),
                      Point(ARect.Left + CORNER_EFFECT, ARect.Bottom - 2),
                      Point(ARect.Left, ARect.Top +((Arect.Bottom - ARect.Top) shr 1))]);
      InflateRect(ARect,-CORNER_EFFECT,0);
    end;
  end;

  Canvas.Brush.Style := bsSolid;

  if APlannerItem.FFocus and
     not Print and
     APlannerItem.FTrackVisible and
     (APlannerItem.Shape = psRect) and
     not APlannerItem.InHeader then
  begin
    Canvas.Brush.Color := APlannerItem.TrackColor;
    r := ARect;
    r.Right := r.Left + 3;
    Canvas.FillRect(r);
    r := ARect;
    r.Left := ARect.Right - 3;
    Canvas.FillRect(r);
  end;

  BackGroundOnly:

  ARect.Top := ARect.Top + 2;

  if APlannerItem.FIsCurrent and not Print then
    Canvas.Brush.Color := FPlanner.FDisplay.FColorCurrentItem
  else
    Canvas.Brush.Color := APlannerItem.Color;

  InflateRect(ARect, -4, 0);

  if APlannerItem.Background then
  begin
    if APlannerItem.Transparent and SelColor then
      Canvas.Brush.Color := BlendColor(CellColor, APlannerItem.Color, FPlanner.SelectBlend);

    Canvas.FillRect(r);
    Canvas.Pen.Color := APlannerItem.FPlanner.GridLineColor;
    Canvas.MoveTo(r.Right - 1, r.Top);
    Canvas.LineTo(r.Right - 1, r.Bottom);
  end;

  ih := 0;
  iw := 0;
  MultiImage := False;

  if Assigned(APlannerItem.FPlanner.PlannerImages) then
  begin
    PlannerImagePoint.X := Round((APlannerItem.FPlanner.PlannerImages.Width + 2) *
      GetDeviceCaps(Canvas.Handle, LOGPIXELSX) / 96);
    PlannerImagePoint.Y := Round((APlannerItem.FPlanner.PlannerImages.Height + 2) *
      GetDeviceCaps(Canvas.Handle, LOGPIXELSY) / 96);

    if (APlannerItem.ImageID >= 0) and Assigned(APlannerItem.FPlanner.PlannerImages) then
    begin
      if ARect.Left + APlannerItem.FPlanner.PlannerImages.Width < ARect.Right then
      begin
        iw := PlannerImagePoint.X;
        ih := PlannerImagePoint.Y;
        if Print then
        begin
          Bitmap := TBitmap.Create;
          APlannerItem.FPlanner.PlannerImages.GetBitmap(APlannerItem.ImageID, Bitmap);
          PrintBitmap(Canvas, Rect(ARect.Left, ARect.Top, ARect.Left + iw,
            ARect.Top + ih), Bitmap);
          Bitmap.Free;
        end
        else
          APlannerItem.FPlanner.PlannerImages.Draw(Canvas, ARect.Left, ARect.Top,
            APlannerItem.ImageID);
      end;
    end;

    for ImageIndex := 1 to APlannerItem.FImageIndexList.Count do
    begin
      if ARect.Left + iw + APlannerItem.FPlanner.PlannerImages.Width < ARect.Right then
      begin
        if Print then
        begin
          Bitmap := TBitmap.Create;
          APlannerItem.FPlanner.PlannerImages.GetBitmap(APlannerItem.FImageIndexList.Items[ImageIndex -
            1], Bitmap);
          PrintBitmap(Canvas, Rect(ARect.Left + iw, ARect.Top, ARect.Left + iw +
            PlannerImagePoint.X, ARect.Top + ih), Bitmap);
          Bitmap.Free;
        end
        else
          APlannerItem.FPlanner.PlannerImages.Draw(Canvas, ARect.Left + iw, ARect.Top,
            APlannerItem.FImageIndexList.Items[ImageIndex - 1]);

        iw := iw + PlannerImagePoint.X;
        ih := PlannerImagePoint.Y;
      end;
      MultiImage := True;
    end;
  end;

  if APlannerItem.CaptionType in [ctTime, ctText, ctTimeText] then
  begin
    Canvas.Font.Assign(APlannerItem.CaptionFont);

    if APlannerItem.Selected and
      APlannerItem.ShowSelection then
        Canvas.Font.Color := APlannerItem.SelectFontColor;

    if APlannerItem.Flashing and APlannerItem.FlashOn and APlannerItem.UniformBkg then
        Canvas.Font.Color := FPlanner.FlashFontColor;
    SetBkMode(Canvas.Handle, TRANSPARENT);
    ColumnHeight := Canvas.TextHeight('gh');

    ih := Max(ColumnHeight, ih);

    Canvas.MoveTo(ARect.Left, ARect.Top + ih + 1);
    Canvas.LineTo(ARect.Right, ARect.Top + ih + 1);

    if not APlannerItem.UniformBkg then
    begin
      Canvas.Brush.Color := APlannerItem.CaptionBkg;
      Canvas.Pen.Color := APlannerItem.CaptionBkg;
      Canvas.Brush.Style := bsSolid;
    end
    else
    begin
      if APlannerItem.Flashing and APlannerItem.FlashOn then
        Canvas.Brush.Color := FPlanner.FlashColor
      else
        Canvas.Brush.Color := Background;
    end;

    r := ARect;
    r.Left := ARect.Left + iw;
    r.Bottom := r.Top + ih;

    InflateRect(r,1,1);

    if not APlannerItem.Focus then
      r.Left := r.Left - 2;

    if APlannerItem.CaptionBkgTo <> clNone then
      DrawGradient(Canvas,APlannerItem.CaptionBkg,APlannerItem.CaptionBkgTo,FPlanner.GradientSteps,r,not FPlanner.GradientHorizontal)
    else
      Canvas.FillRect(r);

    if not APlannerItem.Focus then
      r.Left := r.Left + 2;

    ih := ih + 2;

    if (APlannerItem.URL <> '') and (r.Right - r.Left > 32) then
      r.Right := r.Right -16;

    if (APlannerItem.Attachement <> '')  and (r.Right - r.Left > 32) then
      r.Right := r.Right -16;

    CaptionPaintString := APlannerItem.GetCaptionString;

    HorizontalAlign := AlignToFlag(APlannerItem.CaptionAlign);

    SetBkMode(Canvas.Handle, TRANSPARENT);

    if IsHtml(APlannerItem,CaptionPaintString) then

      HTMLDrawEx(Canvas, CaptionPaintString, r, FPlanner.PlannerImages, 0, 0, -1, -1, 1, False, False,
        Print, False, True, False, APlannerItem.WordWrap
        ,False
        , FPlanner.FHTMLFactor, FPlanner.URLColor,
        clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
        , cr, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
        )

    else
    begin
      DrawFlags := DT_NOPREFIX or DT_END_ELLIPSIS or HorizontalAlign;
      {$IFDEF DELPHI4_LVL}
      DrawFlags := FPlanner.DrawTextBiDiModeFlags(DrawFlags);
      {$ENDIF}
      DrawText(Canvas.Handle, PChar(CaptionPaintString), Length(CaptionPaintString), r, DrawFlags);
    end;

    r.Right := ARect.Right;
    r.Top := r.Top - 2;

    if (APlannerItem.Attachement <> '') and (r.Right - r.Left > 32) then
    begin
      Bitmap := TBitmap.Create;
      Bitmap.LoadFromResourceID(HInstance,502);
      Bitmap.TransparentColor := Bitmap.Canvas.Pixels[0,0];
      Bitmap.Transparent := True;
      Canvas.Draw(r.Right - 16,r.Top,Bitmap);
      r.Right := r.Right - 16;
      Bitmap.Free;
    end;

    if (APlannerItem.URL <> '') and (r.Right - r.Left > 32) then
    begin
      Bitmap := TBitmap.Create;
      Bitmap.LoadFromResourceID(HInstance,503);
      Bitmap.TransparentColor := Bitmap.Canvas.Pixels[0,0];
      Bitmap.Transparent := True;
      Canvas.Draw(r.Right - 16,r.Top,Bitmap);
      Bitmap.Free;
    end;

    iw := 0;
  end
  else
    ih := 0;

  if MultiImage then
  begin
    iw := 0;
    ih := PlannerImagePoint.Y;
  end;

  Canvas.Font.Assign(APlannerItem.Font);

  if APlannerItem.Selected and
    APlannerItem.ShowSelection then
      Canvas.Font.Color := APlannerItem.SelectFontColor;

  if APlannerItem.Flashing and APlannerItem.FlashOn then
    Canvas.Font.Color := FPlanner.FlashFontColor;

  APlannerItem.FCaptionHeight := ih;

  ARect.Top := ARect.Top + ih + 2 + FPlanner.PaintMarginTY;
  ARect.Left := ARect.Left + iw + FPlanner.PaintMarginLX;

  ARect.Bottom := ARect.Bottom - FPlanner.PaintMarginBY;
  ARect.Right := ARect.Right - FPlanner.PaintMarginRX;

  if APlannerItem.CompletionDisplay = cdVertical then
  begin
    Canvas.Brush.Color := FPlanner.CompletionColor1;
    Canvas.Pen.Color := FPlanner.CompletionColor1;
    Canvas.Rectangle(ARect.Left,  ARect.Top - 1 + Round((100 - APlannerItem.Completion) / 100 * (ARect.Bottom - ARect.Top - 4)),ARect.Left + 10, ARect.Bottom - 4);

    Canvas.Brush.Color := FPlanner.CompletionColor2;
    Canvas.Pen.Color := FPlanner.CompletionColor2;
    Canvas.Rectangle(ARect.Left, ARect.Top - 1, ARect.Left + 10,ARect.Top -  2+ Round((100 - APlannerItem.Completion) / 100 * (ARect.Bottom - ARect.Top - 4)));

    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := clBlack;
    Canvas.Rectangle(ARect.Left,ARect.Top - 1,ARect.Left + 10, ARect.Bottom - 4 );

    ARect.Left := ARect.Left + 11;
  end;

  if APlannerItem.CompletionDisplay = cdHorizontal then
  begin
    Canvas.Brush.Color := FPlanner.CompletionColor1;
    Canvas.Pen.Color := FPlanner.CompletionColor1;
    Canvas.Rectangle(ARect.Left,  ARect.Top, ARect.Left + Round((100 - APlannerItem.Completion) / 100 * (ARect.Right - ARect.Left + 2)),ARect.Top + 10);

    Canvas.Brush.Color := FPlanner.CompletionColor2;
    Canvas.Pen.Color := FPlanner.CompletionColor2;
    Canvas.Rectangle(ARect.Left + Round((100 - APlannerItem.Completion) / 100 * (ARect.Right - ARect.Left + 2)),ARect.Top, ARect.Right, ARect.Top + 10);

    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := clBlack;
    Canvas.Rectangle(ARect.Left,ARect.Top ,ARect.Right, ARect.Top + 10 );

    ARect.Top := ARect.Top + 11;
  end;



  PaintString := APlannerItem.ItemText;

  HorizontalAlign := AlignToFlag(APlannerItem.Alignment);

  if IsRtf(PaintString) then
    RTFPaint(ARect, PaintString, Background)
  else
  if IsHtml(APlannerItem,PaintString) then
  begin
    PaintString := ConcatenateTextStrings(APlannerItem.Text);

    GetCursorPos(pt);
    pt := ScreenToClient(pt);
    pt.y := pt.y + 2;

    HRGN := CreateRectRgn(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom);
    SelectClipRgn(Canvas.Handle,HRGN);

    HTMLDrawEx(Canvas, PaintString, ARect, FPlanner.PlannerImages, pt.X, pt.Y, -1, -1, 1, False, False,
      Print, False, True, False, APlannerItem.FWordWrap
      ,False
      , FPlanner.FHTMLFactor, FPlanner.URLColor,
      clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
      , cr, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
      );

    SelectClipRgn(Canvas.Handle,0);
    DeleteObject(HRGN);

    APlannerItem.FClipped := YSize > (ARect.Bottom - ARect.Top);
  end
  else
  begin
    SetBkMode(Canvas.Handle, TRANSPARENT);

    DrawFlags := DT_NOPREFIX or DT_EDITCONTROL or HorizontalAlign;

    if APlannerItem.FWordWrap then
      DrawFlags := DrawFlags or DT_WORDBREAK
    else
      DrawFlags := DrawFlags or DT_SINGLELINE or DT_END_ELLIPSIS;

    {$IFDEF DELPHI4_LVL}
    DrawFlags := FPlanner.DrawTextBiDiModeFlags(DrawFlags);
    {$ENDIF}
    YSize := DrawTextEx(Canvas.Handle, PChar(PaintString), Length(PaintString), ARect, DrawFlags, nil);

    APlannerItem.FClipped := YSize > (ARect.Bottom - ARect.Top);
  end;

  if (APlannerItem.FBeginOffset <> 0) and not APlannerItem.InHeader then
  begin
    DrawArrow(Canvas,clBlue,ro.Left + FPlanner.TrackWidth,
      ro.Bottom - 8 - FPlanner.TrackWidth,adLeft);
  end;

  if (APlannerItem.FEndOffset <> 0) and not APlannerItem.InHeader then
  begin
    DrawArrow(Canvas,clBlue,ro.Right - 8 - FPlanner.FTrackWidth,
      ro.Bottom - 8 - FPlanner.TrackWidth,adRight);
  end;

end;


procedure TPlannerGrid.PaintSideCol(Canvas: TCanvas; ARect: TRect; ARow, APos:
  Integer; Occupied, Print: Boolean);
var
  Line1,Line2,Line3,DT: string;
  HorizontalAlign: Integer;
  MinutesWidth, HoursWidth, MinutesHeight: Integer;
  OldSize: Integer;
  OnTheHour: Boolean;
  HS,IsDay: Boolean;
  DNum,delta: Integer;
  DRect: TRect;
  HOldFont, HNewFont: THandle;
  LFont: TLogFont;

begin
  // Initialize
  HS := False;

  if (FPlanner.Display.DisplayText > 0) then
  begin
    delta := (FPlanner.Display.DisplayStart + ARow) mod FPlanner.Display.DisplayText;
    if (delta <> 0) then
    begin
      ARow := ARow - delta;
      ARect.Top := ARect.Top - delta * FPlanner.Display.DisplayScale;
    end;
  end;

  GetSideBarLines(ARow, APos, Line1, Line2, Line3, HS);
  Canvas.Font.Assign(FPlanner.Sidebar.Font);

  MinutesWidth := Canvas.TextWidth(Line2);
  MinutesHeight := Canvas.TextHeight(Line2);

  if Occupied then
    Canvas.Font.Color := FPlanner.Sidebar.OccupiedFontColor;

  HorizontalAlign := AlignToFlag(FPlanner.Sidebar.Alignment);

  if (FPlanner.FMode.FPlannerType = plTimeLine) then
  begin
    delta := ARow mod (MININDAY div (FPlanner.Display.DisplayUnit));

    DNum := ((ARow * FPlanner.Display.DisplayUnit) div MININDAY);

    DT := DateToStr(FPlanner.Mode.TimeLineStart + DNum);

    DRect := ARect;

    DRect.Top := ARect.Top - Delta * DefaultRowHeight;

    DRect.Bottom := DRect.Top + (MININDAY div (FPlanner.Display.DisplayUnit)) * DefaultRowHeight;

    SetBkMode(Canvas.Handle,TRANSPARENT);

    // do font rotation here
    GetObject(Canvas.Font.Handle, SizeOf(LFont), Addr(LFont));
    LFont.lfEscapement := 90 * 10;
    LFont.lfOrientation := 90 * 10;

    if Print and FPlanner.FPrinterDriverFix then
    begin
      LFont.lfEscapement  := -LFont.lfEscapement;
      LFont.lfOrientation := -LFont.lfEscapement;
    end;

    HNewFont := CreateFontIndirect(LFont);
    HOldFont := SelectObject(Canvas.Handle, HNewFont);

    DrawText(Canvas.Handle,PChar(DT),Length(DT),DRect,
       DT_NOPREFIX or DT_WORDBREAK or DT_VCENTER or DT_LEFT or DT_SINGLELINE);


    HNewFont := SelectObject(Canvas.Handle, HOldFont);
    DeleteObject(HNewFont);

    if (delta = 0) and (ARow > 0) then
    begin
      DRect.Top := ARow * DefaultRowHeight;
      Canvas.Pen.Color := FPlanner.GridLineColor;
      Canvas.MoveTo(ARect.Left - 1,ARect.Top - 1);
      Canvas.LineTo(ARect.Right - 1,ARect.Top - 1);
    end;

    ARect.Left := ARect.Left + (ARect.Right - ARect.Left) div 2;

    Line2 := Line1;
    Line1 := '';
  end;


  if (ARect.Bottom - ARect.Top < MinutesHeight * 2) and
     (FPlanner.Mode.PlannerType <> plDay) then
    Line1 := '';

  // Special painting in case there is a Line1
  if (FPlanner.FMode.FPlannerType in [plDay]) or (Line1 <> '') then
  begin
    OnTheHour := False;
    IsDay := FPlanner.FMode.FPlannerType = plDay;

    HS := HS or not IsDay;

     // Line1=HoursString, Line2=MinutesString, Line3=AmPmString
    if ARow >= 0 then
    begin
      if FPlanner.FMode.FPlannerType = plDay then
      begin
        OnTheHour := Pos('00',Line2) > 0; // Don't display hours if we are not 'on the hour'

        if Line3 <> '' then       // There is an AM/PM, so concatenate it to the minutes
        begin
          if FPlanner.SideBar.AMPMPos = apUnderTime then
            Line2 := Line2 + RegularCRLF + Line3
          else
            Line2 := Line2 + ' ' + Line3;
        end;
      end;

      if FPlanner.FMode.FPlannerType = plHalfDayPeriod then
      begin
        if FPlanner.SideBar.AMPMPos = apUnderTime then
          Line2 := Line2 + RegularCRLF + Line3
        else
          Line2 := Line2 + ' ' + Line3
      end;

      if FPlanner.FSideBar.Flat and (FPlanner.FMode.FPlannerType = plDay) and
        (ARow <> FPlanner.FGrid.TopRow ) then
      begin
        if OnTheHour then
          Canvas.MoveTo(ARect.Left, ARect.Top - 1) // paint Hours
        else
          Canvas.MoveTo(ARect.Right - MinutesWidth, ARect.Top - 1); // do not paint hours

        Canvas.LineTo(ARect.Right - 1, ARect.Top - 1);
      end;

    end;

    OldSize := Canvas.Font.Size;
    try
      if IsDay then
        Canvas.Font.Size := Round(Canvas.Font.Size * 1.2)
      else
        MinutesWidth := 0;

      HoursWidth := Canvas.TextWidth(Line1);

      SetBKMode(Canvas.Handle,TRANSPARENT);


      case FPlanner.Sidebar.Alignment of
        taLeftJustify:
          begin
            if HS then
              Canvas.TextOut(ARect.Left, ARect.Top, Line1);
            if IsDay then
              ARect.Left := ARect.Left + HoursWidth + 4
          end;
        taRightJustify:
          begin
            if HS then
              Canvas.TextOut(ARect.Right - MinutesWidth - 4 - HoursWidth, ARect.Top, Line1);
          end;
        taCenter:
          begin
            if HS then
              Canvas.TextOut(ARect.Left + (ARect.Right - ARect.Left - HoursWidth - MinutesWidth)
                shr 1, ARect.Top, Line1);
            if IsDay then
              ARect.Left := ARect.Left + HoursWidth + 4 +
                (ARect.Right - ARect.Left - HoursWidth - MinutesWidth) shr 1;
          end;
      end;

      if not IsDay then
        ARect.Top := ARect.Top + MinutesHeight + 2;

    finally
      if IsDay then
        Canvas.Font.Size := OldSize;
    end;
  end;

  if (FPlanner.Display.DisplayText > 0) then
  begin
    if ((FPlanner.Display.DisplayStart + ARow) mod FPlanner.Display.DisplayText <> 0) then
    begin
      Line2 := '';
    end;
  end;

  { Painting }
  if (Line2 <> '') then
  begin
    SetBKMode(Canvas.Handle,TRANSPARENT);
    DrawText(Canvas.Handle, PChar(Line2), Length(Line2), ARect, DT_NOPREFIX
      or DT_WORDBREAK or HorizontalAlign);
  end;

end;

procedure TPlannerGrid.PaintSideRow(Canvas: TCanvas; ARect: TRect; AColumn, APos:
  Integer; Occupied, Print: Boolean);
var
  Line1, Line2, Line3,DT: string;
  HorizontalAlign: Integer;
  OldSize: Integer;
  OnTheOur: Boolean;
  LFont: TLogFont;
  HOldFont, HNewFont: HFont;
  MinorLineWidth: Integer;
  MajorLineWidth: Integer;
  HS: Boolean;
  DNum,delta: Integer;
  DRect: TRect;
begin
  { Initialize }
  GetSideBarLines(AColumn, APos, Line1, Line2, Line3, HS);
  MinorLineWidth := Canvas.TextHeight(Line2);
  Canvas.Font.Assign(FPlanner.Sidebar.Font);
  HorizontalAlign := AlignToFlag(FPlanner.Sidebar.Alignment);

  HOldFont := 0;
  SetBkMode(Canvas.Handle, TRANSPARENT);

  if (FPlanner.Display.DisplayText > 0) then
  begin
    delta := (FPlanner.Display.DisplayStart + AColumn) mod FPlanner.Display.DisplayText;
    if (delta <> 0) then
    begin
      AColumn := AColumn - delta;
      ARect.Left := ARect.Left - delta * FPlanner.Display.DisplayScale;
      GetSideBarLines(AColumn, APos, Line1, Line2, Line3, HS);
    end;
  end;

  if Occupied then Canvas.Font.Color := FPlanner.Sidebar.OccupiedFontColor;

  if (FPlanner.FMode.FPlannerType = plTimeLine) then
  begin
    delta := AColumn mod (MININDAY div (FPlanner.Display.DisplayUnit));

    DNum := ((AColumn * FPlanner.Display.DisplayUnit) div MININDAY);

    DT := DateToStr(FPlanner.Mode.TimeLineStart + DNum);

    DRect := ARect;
    DRect.Left := ARect.Left - Delta * DefaultColWidth;

    DrawText(Canvas.Handle,PChar(DT),Length(DT),DRect,
       DT_NOPREFIX or DT_WORDBREAK or DT_LEFT);


    if delta = 0 then
    begin
      DRect.Left := AColumn * DefaultColWidth;
      Canvas.Pen.Color := FPlanner.GridLineColor;
      Canvas.MoveTo(DRect.Left - 1,ARect.Top);
      Canvas.LineTo(DRect.Left - 1,ARect.Bottom);
    end;

    ARect.Top := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
    Line2 := Line1;
    Line1 := '';
  end;

  { Special painting in case there is a Line1 }
  if (FPlanner.FMode.FPlannerType = plDay) or
     ((Line1 <> '') and not FPlanner.SideBar.RotateOnTop) then
  begin
    OnTheOur := False;
    OldSize := Canvas.Font.Size;
    Canvas.Font.Size := Round(Canvas.Font.Size * 1.2);
    try
      MajorLineWidth := Canvas.TextHeight(Line1);
      if FPlanner.FMode.FPlannerType = plDay then
      begin
        OnTheOur := Line2 = '00'; // Don't display hours if we are not 'on the hour'
        if Line3 <> '' then // There is an AM/PM, so concatenate it to the minutes
          Line2 := Line2 + RegularCRLF + Line3;
      end;

      if OnTheOur or HS then
      begin

        DrawText(Canvas.Handle, PChar(Line1), Length(Line1), ARect,
          DT_NOPREFIX or DT_WORDBREAK or HorizontalAlign);
      end;

      if (AColumn > 0) and (AColumn <= ColCount - 1) and
        (FPlanner.FMode.FPlannerType = plDay) then
      begin
        if OnTheOur then
          Canvas.MoveTo(Arect.Left - 4,ARect.Bottom - 24)
        else
          Canvas.MoveTo(Arect.Left - 4,ARect.Bottom - 12);
        Canvas.LineTo(Arect.Left - 4,ARect.Bottom);
      end;

      ARect.Top := ARect.Top + MajorLineWidth + 4;
    finally
      Canvas.Font.Size := OldSize;
    end;
  end;


  { Painting }

  if Line2 <> '' then
    case FPlanner.FMode.FPlannerType of
      plDay, plWeek, plCustom,plCustomList,plTimeLine:
        DrawText(Canvas.Handle, PChar(Line2), Length(Line2), ARect,
          DT_NOPREFIX or DT_WORDBREAK or HorizontalAlign);
      plMonth, plDayPeriod, plHalfDayPeriod, plMultiMonth:
        begin
          if FPlanner.SideBar.RotateOnTop then
          begin
            GetObject(Canvas.Font.Handle, SizeOf(LFont), Addr(LFont));
            LFont.lfEscapement := 90 * 10;
            LFont.lfOrientation := 90 * 10;
            if Print and FPlanner.FPrinterDriverFix then
            begin
              LFont.lfEscapement  := -LFont.lfEscapement;
              LFont.lfOrientation := -LFont.lfEscapement;
            end;
            HNewFont := CreateFontIndirect(LFont);
            HOldFont := SelectObject(Canvas.Handle, HNewFont);

            SetTextAlign(Canvas.Handle, TA_TOP);
          end;

          if MinorLineWidth >= ARect.Right - ARect.Left then
            MinorLineWidth := 0 // does not fit in the box, so left align
          else
          case HorizontalAlign of
            DT_LEFT:   MinorLineWidth := 0;
            DT_RIGHT:  MinorLineWidth := ARect.Right - ARect.Left - MinorLineWidth;
            DT_CENTER: MinorLineWidth := (ARect.Right - ARect.Left - MinorLineWidth) shr 1;
          end;

          try
            if FPlanner.SideBar.RotateOnTop then
            begin

              Canvas.Brush.Style := bsClear;
              Canvas.TextRect(ARect, ARect.Left + MinorLineWidth, ARect.Bottom - 4, Line2);
              ARect.Left := ARect.Left + Canvas.TextHeight('gh');
              if Line3 <> '' then
                Canvas.TextRect(ARect, ARect.Left + MinorLineWidth, ARect.Bottom - 4, Line3);
            end
            else
            begin
              SetBKMode(Canvas.Handle,TRANSPARENT);
              DrawText(Canvas.Handle, PChar(Line2), Length(Line2), ARect,
                DT_NOPREFIX or DT_WORDBREAK or HorizontalAlign);
            end;

          finally
            { Cleanup }
            if FPlanner.FMode.FPlannerType in [plMonth, plDayPeriod, plHalfDayPeriod, plMultiMonth] then
            begin
              if FPlanner.SideBar.RotateOnTop then
              begin
                HNewFont := SelectObject(Canvas.Handle, HOldFont);
                DeleteObject(HNewFont);
              end;
            end;
          end;
        end;
    end;
end;

procedure TPlannerGrid.DrawCell(AColumn, ARow: LongInt; ARect: TRect;
  AState: TGridDrawState);
begin
  if FPlanner.Sidebar.Orientation = soVertical then
    DrawCellCol(AColumn, ARow, ARect, AState)
  else
    DrawCellRow(AColumn, ARow, ARect, AState);
end;

procedure TPlannerGrid.DrawWallPaperFixed(CRect: TRect;xcorr,ycorr: Integer;BKColor:TColor);
var
  SrcRect,DsTRect,Irect: TRect;
  x,y,ox,oy: Integer;
  dst: TPoint;
begin
  dst.x := FPlanner.FBackground.Left;
  dst.y := FPlanner.FBackground.Top;
  
  x := FPlanner.FBackground.Bitmap.Width;
  y := FPlanner.FBackground.Bitmap.Height;

  DsTRect.Top := dst.y;
  DsTRect.Left := dst.x;
  DsTRect.Right := DsTRect.Left+x;
  DsTRect.Bottom := DsTRect.Top+y;

  if not IntersectRect(irect,crect,dsTRect) then
    Exit;

  SetBkMode(Canvas.Handle,TRANSPARENT);

  ox := crect.Left - dst.x;
  oy := crect.Top - dst.y;

  SrcRect.Left := ox;
  SrcRect.Top := oy;
  SrcRect.Right := ox + crect.Right - crect.Left;
  SrcRect.Bottom := oy + crect.Bottom - crect.Top;


  dst.x := dst.x - xcorr;
  dst.y := dst.y - ycorr;

  if dst.x < 0 then Exit;

  DsTRect := crect;

  if ox <= 0 then
  begin
    DsTRect.Left := dst.x;
    SrcRect.Left := 0;
    SrcRect.Right := DsTRect.Right-DsTRect.Left;
  end;

  if oy <= 0 then
  begin
    DsTRect.Top := dst.y;
    SrcRect.Top := 0;
    SrcRect.Bottom := DsTRect.Bottom-DsTRect.Top;
  end;

  if (SrcRect.Left + (DsTRect.Right - DsTRect.Left) > x) then
  begin
    DsTRect.Right := DsTRect.Left + x - SrcRect.Left;
    SrcRect.Right := x;
  end;

  if (SrcRect.Top + DsTRect.Bottom - DsTRect.Top > y) then
  begin
    DsTRect.Bottom := DsTRect.Top + y - SrcRect.Top;
    SrcRect.Bottom := y;
  end;

  Canvas.CopyRect(DstRect,FPlanner.FBackground.Bitmap.Canvas,SrcRect);
end;

procedure TPlannerGrid.DrawWallPaperTile(ACol,ARow:integer;crect:TRect;xCorr,yCorr:integer;BKColor:TColor);
var
  SrcRect,DsTRect:TRect;
  x,y,xo,yo,ox,oy,i: Integer;
  Bmp: TBitmap;
begin
  Bmp := FPlanner.FBackground.Bitmap;

  if FPlanner.SideBar.Position <> spTop then
  begin
    if (FPlanner.PositionProps.Count >= ACol) and (ACol > 0) then
    begin
      if (not FPlanner.PositionProps[ACol - 1].Background.Empty) and
        FPlanner.PositionProps[ACol - 1].Use then
        Bmp := FPlanner.PositionProps[ACol - 1].Background;
    end;
  end
  else
  begin
    if (FPlanner.PositionProps.Count >= ARow) and (ARow > 0) then
    begin
      if (not FPlanner.PositionProps[ARow - 1].Background.Empty) and
        FPlanner.PositionProps[ARow - 1].Use then
          Bmp := FPlanner.PositionProps[ARow - 1].Background;
    end;
  end;

  x := Bmp.Width;
  y := Bmp.Height;

  SetBkMode(Canvas.Handle,TRANSPARENT);

  if (FPlanner.FSidebar.Position = spLeft) and FPlanner.FSidebar.Visible then
    xo := 1
  else
    xo := 0;

  ox := 0;
  for i := xo + 1 to ACol do
    ox := ox + ColWidths[i - 1];

  yo := 0;
  oy := 0;
  for i := yo + 1 to ARow do
    oy := oy + RowHeights[i - 1];

  ox := ox + xCorr;
  oy := oy + yCorr;

  ox := ox mod x;
  oy := oy mod y;

  SrcRect.Left := ox;
  SrcRect.Top := oy;
  SrcRect.Right := x;
  SrcRect.Bottom := y;

  yo := cRect.Top;

  while yo < cRect.Bottom do
  begin
    xo := cRect.Left;
    SrcRect.Left := ox;
    SrcRect.Right := x;
    while xo < cRect.Right do
    begin
      DstRect := Rect(xo,yo,xo+SrcRect.Right-SrcRect.Left,yo+SrcRect.Bottom-SrcRect.Top);

      if DstRect.Right > crect.Right then
      begin
        DstRect.Right := crect.Right;
        SrcRect.Right := SrcRect.Left + (dstRect.Right - dstRect.Left);
      end;
      if DstRect.Bottom > crect.Bottom then
      begin
        DsTRect.Bottom := crect.Bottom;
        SrcRect.Bottom := SrcRect.Top + (dstRect.Bottom - dstRect.Top);
      end;

      Canvas.CopyRect(DsTRect,Bmp.Canvas,SrcRect);

      xo := xo + SrcRect.Right - SrcRect.Left;
      SrcRect.Left := 0;
      SrcRect.Right := x;
    end;
    yo := yo + SrcRect.Bottom-SrcRect.Top;
    SrcRect.Top := 0;          
    SrcRect.Bottom := y;
  end;
end;


procedure TPlannerGrid.DrawCellCol(AColumn, ARow: LongInt; ARect: TRect;
  AState: TGridDrawState);
var
  OldBrush: TBrush;
  OldFont: TFont;
  SubIndex, m: Integer;
  APlannerItem: TPlannerItem;
  NRect, r: TRect;
  NumberOfConflicts: TPoint;
  CellColor: TColor;
  CellBrush: TBrushStyle;
  Fixcol: Integer;
  ColOffset: Integer;
  PlannerColorArrayPointer: PPlannerColorArray;
  BottomPen: TPen;
  Occupied: Boolean;
  ABrush: TBrush;
  BkgFlag: Boolean;
  RGN: THandle;
  delta: Integer;
  dts,dte: TDateTime;

begin
  ColOffset := FPlanner.FSidebar.FColOffset;

  if ColOffset = 0 then
    FixCol := ColCount - 1
  else
    FixCol := 0;

  OldFont := TFont.Create;
  OldFont.Assign(Canvas.Font);
  OldBrush := TBrush.Create;
  OldBrush.Assign(Canvas.Brush);

  if (AColumn = FixCol) or
     ((FPlanner.PositionGap > 0) and (FPlanner.SideBar.ShowInPositionGap)) or
     ((AColumn = ColCount -1) and (FPlanner.SideBar.Position = spLeftRight) and FPlanner.SideBar.Visible) then
  begin
    { Draw the SideBar }
    r := ARect;

    if (AColumn <> FixCol) and not
       ((AColumn = ColCount - 1) and (FPlanner.SideBar.Position = spLeftRight) and FPlanner.SideBar.Visible) then
    begin
      r.Right := r.Left + FPlanner.FPositionGap;
      ARect.Left := ARect.Left + FPlanner.FPositionGap;
    end;

    Canvas.Brush.Color := FPlanner.Sidebar.Background;

    if AColumn = FixCol then
      APlannerItem := FPlanner.Items.FindItemIdx(ARow)
    else
      APlannerItem := FPlanner.Items.FindItem(ARow, AColumn - ColOffset);

    Occupied := (APlannerItem <> nil) and FPlanner.Sidebar.ShowOccupied;

    if ((ARow >= Selection.Top) and (ARow <= Selection.Bottom) and (FPlanner.SideBar.ActiveColor <> clNone)) then
    begin
      Canvas.Brush.Color := FPlanner.SideBar.ActiveColor;
      Canvas.FillRect(r);
    end
    else
    begin
      if Occupied  then
      begin
        Canvas.Brush.Color := FPlanner.SideBar.Occupied;
        Canvas.FillRect(r);
      end
      else
      begin
        if FPlanner.SideBar.BackgroundTo <> clNone then
          DrawGradient(Canvas,FPlanner.SideBar.Background,FPlanner.SideBar.BackgroundTo,FPlanner.GradientSteps,r,True)
        else
         Canvas.FillRect(r);
      end;
    end;  

    if not FPlanner.SideBar.Flat then
      Frame3D(Canvas,r,clWhite,clGray,1);

    if FPlanner.SideBar.Border then
    begin
      Canvas.Pen.Color := clWhite;
      Canvas.MoveTo(r.Left,r.Top);
      Canvas.LineTo(r.Left,r.Bottom);

      if ARow = FPlanner.FGrid.TopRow then
      begin
        Canvas.MoveTo(r.Left,r.Top);
        Canvas.LineTo(r.Right,r.Top);
      end;

      Canvas.Pen.Color := clGray;
      Canvas.MoveTo(r.Right - 1,r.Top);
      Canvas.LineTo(r.Right - 1,r.Bottom);

      if ARow = FPlanner.FGrid.RowCount -1 then
      begin
        Canvas.MoveTo(r.Left,r.Bottom - 1);
        Canvas.LineTo(r.Right,r.Bottom - 1);
      end;
    end;

    Canvas.Pen.Color := FPlanner.SideBar.SeparatorLineColor;

    if not (FPlanner.FMode.FPlannerType in [plDay,plTimeLine]) then
    begin
      Canvas.MoveTo(r.Left, r.Bottom - 1);
      Canvas.LineTo(r.Right - 1, r.Bottom - 1);
      Canvas.Pen.Color := clGray;
      Canvas.LineTo(r.Right - 1, r.Top);
    end;

    r.Left := r.Left + 4;
    r.Right := r.Right - 4;
    r.Top := r.Top + 1;
    r.Bottom := r.Bottom - 1;

    if Assigned(FPlanner.OnPlannerSideDraw) then
      FPlanner.OnPlannerSideDraw(FPlanner, Self.Canvas, ARect, ARow)
    else
      PaintSideCol(Canvas, r, ARow, AColumn, Occupied, False);

    if (AColumn = 0) and (ARow = TopRow) and FPlanner.FTopIndicator then
    begin
      Canvas.Brush.Color := clInfoBk;
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Width := 1;
      Canvas.Rectangle(r.Left,r.Top,r.Left + 22, r.Top + 10);
      Canvas.Brush.Color := clBlack;
      Canvas.Polygon([Point(r.Left + 4,r.Top + 2),Point(r.Left + 6,r.Top + 6),Point(r.Left + 2,r.Top + 6)]);
      Canvas.Rectangle(r.Left + 8,r.Top + 5,r.Left + 10,r.Top + 7);
      Canvas.Rectangle(r.Left + 12,r.Top + 5,r.Left + 14,r.Top + 7);
      Canvas.Rectangle(r.Left + 16,r.Top + 5,r.Left + 18,r.Top + 7);
    end;

    if (AColumn = 0) and (ARow = TopRow + VisibleRowCount - 1) and FPlanner.FBottomIndicator then
    begin
      Canvas.Brush.Color := clInfoBk;
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Width := 1;
      r := CellRect(0,ARow);
      Canvas.Rectangle(r.Left,r.Bottom - 10,r.Left + 22, r.Bottom);
      Canvas.Brush.Color := clBlack;
      Canvas.Polygon([Point(r.Left + 4,r.Bottom - 4),Point(r.Left + 6,r.Bottom - 8),Point(r.Left + 2,r.Bottom - 8)]);
      Canvas.Rectangle(r.Left + 8,r.Bottom - 5,r.Left + 10,r.Bottom - 3);
      Canvas.Rectangle(r.Left + 12,r.Bottom - 5,r.Left + 14,r.Bottom - 3);
      Canvas.Rectangle(r.Left + 16,r.Bottom - 5,r.Left + 18,r.Bottom - 3);
    end;

  end;

  if (AColumn <> FixCol) and not
     ((AColumn = ColCount -1) and (FPlanner.SideBar.Position = spLeftRight) and FPlanner.SideBar.Visible) then
  begin
    if (FPlanner.FPositionGap > 0) and not FPlanner.SideBar.ShowInPositionGap then
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Width := 1;

      APlannerItem := FPlanner.Items.FindItem(ARow, AColumn - ColOffset);

      if (APlannerItem <> nil) then
        Canvas.Brush.Color := FPlanner.FTrackColor
      else
        Canvas.Brush.Color := clWhite;

      Canvas.FillRect(Rect(ARect.Left, ARect.Top, ARect.Left+FPlanner.FPositionGap,ARect.Bottom));

      ARect.Left := ARect.Left + FPlanner.FPositionGap;

      Canvas.MoveTo(ARect.Left-1,ARect.Top);
      Canvas.LineTo(ARect.Left-1,ARect.Bottom);
    end;

    { Draw the normal cells - set BackGround Color }

    ABrush := TBrush.Create;
    FPlanner.GetCellBrush(AColumn - ColOffset,ARow,ABrush);
    CellColor := ABrush.Color;
    CellBrush := ABrush.Style;
    ABrush.Free;

    { Custom cell Color }
    if (AColumn - ColOffset < FColorList.Count) and (AColumn - ColOffset >= 0) and
      (ARow < NumColors) then
    begin
      PlannerColorArrayPointer := FColorList.Items[AColumn - ColOffset];
      if PlannerColorArrayPointer^[ARow] <> clNone then
        CellColor := PlannerColorArrayPointer^[ARow];
    end;

    if FPlanner.CellInCurrTime(ARow,AColumn) then
      CellColor := FPlanner.FDisplay.ColorCurrent;

    if (gdSelected in AState) then
    begin
      CellBrush := bsSolid;
      // do color blend
      CellColor := BlendColor(FPlanner.FSelectColor,CellColor,FPlanner.FSelectBlend);
    end;

    Canvas.Brush.Color := CellColor;

    { Nr of Items at cell }
    NumberOfConflicts := FPlanner.Items.NumItem(ARow, ARow + 1, AColumn - ColOffset);

    r := ARect;

    BottomPen := TPen.Create;
    BottomPen.Assign(Canvas.Pen);

    BottomPen.Width := 1;
    BottomPen.Color := FPlanner.GridLineColor;

    if Assigned(FPlanner.FOnPlannerBottomLine) then
      FPlanner.FOnPlannerBottomLine(Self, ARow, AColumn, BottomPen);

    { Draw Items / cell background }

    // if background item, draw first here

    APlannerItem := FPlanner.Items.FindBackground(ARow,AColumn - ColOffset);

    if Assigned(APlannerItem) then
    begin

      NRect.Top := ARect.Top - ((ARow - APlannerItem.ItemBegin) * (ARect.Bottom -
        ARect.Top));
      NRect.Bottom := ARect.Bottom + ((APlannerItem.ItemEnd - ARow - 1) * (ARect.Bottom
        - ARect.Top));
      NRect.Left := ARect.Left;
      NRect.Right := ARect.Right;

      RGN := CreateRectRgn(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom);
      SelectClipRgn(Canvas.Handle,RGN);

      PaintItemCol(Canvas, NRect, APlannerItem, False, (gdSelected in AState));

      // draw bottom line for background item if required
      if ARow = APlannerItem.ItemEnd -1 then
      begin
        Canvas.Pen.Assign(BottomPen);
        Canvas.MoveTo(ARect.Left,ARect.Bottom - 1);
        Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
      end;

      APlannerItem.Repainted := False;

      SelectClipRgn(Canvas.Handle,0);
      DeleteObject(RGN);

      // make sure overlapping items are repainted  afterwards
      FPlanner.Items.ClearSelectedRepaints(ARow, AColumn - ColOffset);
    end;

    BkgFlag := Assigned(APlannerItem);

    for SubIndex := 1 to NumberOfConflicts.Y do
    begin
      ARect := r;
      m := (ARect.Right - ARect.Left) div NumberOfConflicts.Y;
      ARect.Left := ARect.Left + (SubIndex - 1) * m;

//      if SubIndex = NumberOfConflicts.Y then
//        ARect.Right := r.Right
//      else
        ARect.Right := ARect.Left + m;

      APlannerItem := FPlanner.Items.FindItemIndex(ARow, AColumn - ColOffset, SubIndex - 1);

      if (APlannerItem <> nil) then
      begin
        NRect.Top := ARect.Top - ((ARow - APlannerItem.ItemBegin) * (ARect.Bottom -
          ARect.Top));
        NRect.Bottom := ARect.Bottom + ((APlannerItem.ItemEnd - ARow - 1) * (ARect.Bottom
          - ARect.Top));
        NRect.Left := ARect.Left;
        NRect.Right := ARect.Right;

        if APlannerItem.Shape <> psRect then
        begin
          RectHorzEx(Canvas, ARect, CellColor,FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width,CellBrush);
          APlannerItem.Repainted := False;
        end;

        {do precise time based adaption here}

        if FPlanner.DrawPrecise then
        begin
          if FPlanner.Mode.PlannerType = plTimeLine then
          begin
            FPlanner.CellToAbsTime(APlannerItem.ItemBegin,dts,dte);
            delta := 0;
          end
          else
          begin
            delta := APlannerItem.ItemBeginPrecis - ((APlannerItem.ItemBegin + FPlanner.Display.DisplayStart) * FPlanner.Display.DisplayUnit);
            delta := round(delta / FPlanner.Display.DisplayUnit * FPlanner.Display.DisplayScale);
          end;  

          if delta > 0 then
          begin
            if (APlannerItem.ItemBegin >= Selection.Top) and
               (APlannerItem.ItemBegin <= Selection.Bottom) and
               (APlannerItem.ItemPos + ColOffset >= Selection.Left) and
               (APlannerItem.ItemPos + ColOffset <= Selection.Right) then
               Canvas.Brush.Color := FPlanner.SelectColor
            else
              Canvas.Brush.Color := FPlanner.GetCellColorCol(AColumn - ColOffset,APlannerItem.ItemBegin);


            Canvas.Pen.Color := Canvas.Brush.Color;
            Canvas.Rectangle(NRect.Left,NRect.Top,NRect.Right-1,NRect.Top + delta);
          end;

          NRect.Top := NRect.Top + delta;

          if FPlanner.Mode.PlannerType = plTimeLine then
          begin
            FPlanner.CellToAbsTime(APlannerItem.ItemBegin,dts,dte);
            delta := 0;

          end
          else
          begin
            delta := ((APlannerItem.ItemEnd + FPlanner.Display.DisplayStart)* FPlanner.Display.DisplayUnit) - APlannerItem.ItemEndPrecis;
            delta := round(delta / FPlanner.Display.DisplayUnit * FPlanner.Display.DisplayScale);
          end;

          if delta > 0 then
          begin
            inc(delta);

            if (APlannerItem.ItemEnd >= Selection.Top) and
               (APlannerItem.ItemEnd <= Selection.Bottom) then
               Canvas.Brush.Color := FPlanner.SelectColor
            else
              Canvas.Brush.Color := FPlanner.GetCellColorCol(AColumn - ColOffset,APlannerItem.ItemEnd);

            Canvas.Brush.Color := CellColor;
            Canvas.Pen.Color := Canvas.Brush.Color;
            Canvas.Rectangle(NRect.Left,NRect.Bottom - delta,NRect.Right - 1,NRect.Bottom - 1);
            Canvas.Pen.Color := FPlanner.GridLineColor;
            Canvas.MoveTo(NRect.Left,NRect.Bottom - 1);
            Canvas.LineTo(NRect.Right,NRect.Bottom - 1);
          end;

          NRect.Bottom := NRect.Bottom - delta;
        end;

        PaintItemCol(Canvas, NRect, APlannerItem, False, False);

        if not (APlannerItem.Background and not APlannerItem.AllowOverlap) then
          ARect.Left := ARect.Right - FPlanner.FItemGap
        else
          ARect.Left := ARect.Right;

        // Item found, paint only extra rect at Right
        if (not APlannerItem.Background or (SubIndex > 1)) and not BkgFlag then
        begin
          NRect := ARect;
          NRect.Left := ARect.Right - FPlanner.FItemGap;

          if SubIndex = NumberOfConflicts.Y then
            ARect.Right := r.Right;

          NRect.Right := ARect.Right;

          if (not FPlanner.Background.Bitmap.Empty) and not (gdSelected in AState) and FPlanner.IsActive(ARow,AColumn - 1) then
          begin
            if FPlanner.Background.Display = bdTile then
            begin
              DrawWallPaperTile(AColumn,ARow,NRect,NRect.Left - r.Left,0,CellColor);
              RectHorzEx(Canvas, NRect, clNone, FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width,CellBrush);
            end
            else
            begin
              RectHorzEx(Canvas, NRect, CellColor, FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width,CellBrush);
              DrawWallPaperFixed(NRect,NRect.Left - r.Left,0,CellColor);
              RectHorzEx(Canvas, NRect, clNone, FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
            end;
          end
          else
          begin
            Canvas.Pen.Style := BottomPen.Style;
            RectHorzEx(Canvas, NRect, CellColor, FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
            Canvas.Pen.Style := psSolid;
          end;

          if (AColumn > 0) and (Assigned(FPlanner.OnPlannerBkgDraw)) then
          begin
            FPlanner.OnPlannerBkgDraw(FPlanner, Canvas, NRect, ARow, AColumn - 1);
          end;

        end;
      end
      else
      begin
        if not BkgFlag then
        begin
          NRect := ARect;
          NRect.Left := ARect.Left;

          if SubIndex = NumberOfConflicts.Y then
            NRect.Right := r.Right + 1;

          if (not FPlanner.Background.Bitmap.Empty) and not (gdSelected in AState) and FPlanner.IsActive(ARow,AColumn - 1) then
          begin
            if FPlanner.Background.Display = bdTile then
            begin
              DrawWallPaperTile(AColumn, ARow, NRect, NRect.Left - r.Left, 0, CellColor);
              RectHorzEx(Canvas, NRect, clNone,FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
            end
            else
            begin
              RectHorzEx(Canvas, NRect, CellColor,FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
              DrawWallPaperFixed(NRect,NRect.Left - r.Left,0,CellColor);
              RectHorzEx(Canvas, NRect, clNone,FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
            end;
          end
          else
          begin
            Canvas.Pen.Style := BottomPen.Style;
            RectHorzEx(Canvas, NRect, CellColor,FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
            Canvas.Pen.Style := psSolid;
          end;

          if (AColumn > 0) and (Assigned(FPlanner.OnPlannerBkgDraw)) then
          begin
            FPlanner.OnPlannerBkgDraw(FPlanner, Canvas, NRect, ARow, AColumn - 1);
          end;
        end;

      end;
    end;

    { Draws line on Top & Bottom of cell if no Items are present }
    if NumberOfConflicts.X = 0 then
    begin
      if (not FPlanner.Background.Bitmap.Empty) and not (gdSelected in AState) and FPlanner.IsActive(ARow,AColumn - 1) then
      begin
        if FPlanner.Background.Display = bdTile then
        begin
          DrawWallPaperTile(AColumn,ARow,ARect,0,0,CellColor);
          RectHorzEx(Canvas, ARect, clNone,FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
        end
        else
        begin
          RectHorzEx(Canvas, ARect, CellColor, FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
          DrawWallPaperFixed(ARect,0,0,CellColor);
          RectHorzEx(Canvas, ARect, clNone,FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
        end;
      end
      else
      begin
        Canvas.Pen.Style := BottomPen.Style;
        RectHorzEx(Canvas, ARect, CellColor, FPlanner.Color, FPlanner.FGridLineColor, BottomPen.Color, BottomPen.Width, CellBrush);
        Canvas.Pen.Style := psSolid;        
      end;
    end;

    BottomPen.Free;

    if (AColumn > 0) and (Assigned(FPlanner.OnPlannerBkgDraw)) then
    begin
      FPlanner.OnPlannerBkgDraw(FPlanner, Canvas, ARect, ARow, AColumn - 1);
    end;

    { Draw cell line at end of cell }
    if FPlanner.FGridLineColor <> clNone then
    begin
      Canvas.Pen.Color := FPlanner.FGridLineColor;
      Canvas.MoveTo(r.Right - 1, ARect.Top - 1);
      Canvas.LineTo(r.Right - 1, ARect.Bottom - 1);
    end;
  end;

  Canvas.Font.Assign(OldFont);
  Canvas.Brush.Assign(OldBrush);
  OldFont.Free;
  OldBrush.Free;
end;

procedure TPlannerGrid.DrawCellRow(AColumn, ARow: LongInt; ARect: TRect;
  AState: TGridDrawState);
var
  OldBrush: TBrush;
  OldFont: TFont;
  APlannerItem: TPlannerItem;
  NRect, r: TRect;
  NumberOfConflicts: TPoint;
  CellColor: TColor;
  CellBrush: TBrushStyle;
  FixRow, SubIndex, m: Integer;
  RowOffset: Integer;
  PlannerColorArrayPointer: PPlannerColorArray;
  BottomPen: TPen;
  Occupied: Boolean;
  ABrush: TBrush;
  BkgFlag: Boolean;
  RGN: THandle;
  delta: Integer;
  dts,dte: TDateTime;
  
begin
  RowOffset := FPlanner.FSidebar.FRowOffset;

  if RowOffset = 0 then
    FixRow := RowCount - 1
  else
    FixRow := 0;


  OldFont := TFont.Create;
  OldFont.Assign(Canvas.Font);
  OldBrush := TBrush.Create;
  OldBrush.Assign(Canvas.Brush);

  if (ARow = FixRow) then
  begin

    Canvas.Brush.Color := FPlanner.Sidebar.Background;

    APlannerItem := FPlanner.Items.FindItemIdx(AColumn);

    Occupied := False;

    if (APlannerItem <> nil) and FPlanner.Sidebar.ShowOccupied then
    begin
      Occupied := True;
      Canvas.Brush.Color := FPlanner.SideBar.Occupied;
    end;

    if ((AColumn >= Selection.Left) and (AColumn <= Selection.Right) and (FPlanner.SideBar.ActiveColor <> clNone)) then
    begin
      Canvas.Brush.Color := FPlanner.SideBar.ActiveColor;
      Canvas.FillRect(ARect);
    end
    else
    begin
      if FPlanner.SideBar.BackgroundTo <> clNone then
        DrawGradient(Canvas,FPlanner.SideBar.Background,FPlanner.SideBar.BackgroundTo,FPlanner.GradientSteps,ARect,False)
      else
        Canvas.FillRect(ARect);
    end;    

    if not FPlanner.SideBar.Flat then
      Frame3D(Canvas,ARect,clWhite,clGray,1);

    if FPlanner.SideBar.Border then
    begin
      Canvas.Pen.Color := clWhite;
      Canvas.MoveTo(ARect.Left,ARect.Top);
      Canvas.LineTo(ARect.Right,ARect.Top);

      if AColumn = FPlanner.FGrid.LeftCol then
      begin
        Canvas.MoveTo(ARect.Left,ARect.Top);
        Canvas.LineTo(ARect.Left,ARect.Bottom);
      end;

      Canvas.Pen.Color := clGray;
      Canvas.MoveTo(ARect.Left,ARect.Bottom - 1);
      Canvas.LineTo(ARect.Right,ARect.Bottom - 1);

      if AColumn = FPlanner.FGrid.ColCount -1 then
      begin
        Canvas.MoveTo(ARect.Right - 1,ARect.Top);
        Canvas.LineTo(ARect.Right - 1,ARect.Bottom);
      end;
    end;

    if not (FPlanner.FMode.FPlannerType in [plDay,plTimeLine]) then
    begin
      Canvas.Pen.Color := clGray;
      Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
      Canvas.LineTo(ARect.Right - 1, ARect.Bottom - 1);
      Canvas.Pen.Color := FPlanner.Sidebar.SeparatorLineColor;
      Canvas.LineTo(ARect.Right - 1, ARect.Top);
    end;

    r := ARect;

    ARect.Left := ARect.Left + 4;
    ARect.Right := ARect.Right - 4;
    ARect.Top := ARect.Top + 1;
    ARect.Bottom := ARect.Bottom - 1;

    Canvas.Pen.Color := FPlanner.SideBar.SeparatorLineColor;

    if Assigned(FPlanner.OnPlannerSideDraw) then
      FPlanner.OnPlannerSideDraw(FPlanner, Canvas, ARect, AColumn)
    else
      PaintSideRow(Canvas, ARect, AColumn, ARow, Occupied, False);

    if (ARow = 0) and (AColumn = LeftCol) and FPlanner.FTopIndicator then
    begin
      Canvas.Brush.Color := clInfoBk;
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Width := 1;
      Canvas.Rectangle(r.Left,r.Top,r.Left + 22, r.Top + 10);
      Canvas.Brush.Color := clBlack;
      Canvas.Polygon([Point(r.Left + 2,r.Top + 4),Point(r.Left + 4,r.Top + 2),Point(r.Left + 4,r.Top + 6)]);
      Canvas.Rectangle(r.Left + 8,r.Top + 5,r.Left + 10,r.Top + 7);
      Canvas.Rectangle(r.Left + 12,r.Top + 5,r.Left + 14,r.Top + 7);
      Canvas.Rectangle(r.Left + 16,r.Top + 5,r.Left + 18,r.Top + 7);
    end;

    if (ARow = 0) and (AColumn = LeftCol + VisibleColCount - 1) and FPlanner.FBottomIndicator then
    begin
      Canvas.Brush.Color := clInfoBk;
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Width := 1;
      r := CellRect(AColumn,0);
      r.Bottom := r.Top + 10;
      // Canvas.Rectangle(r.Left,r.Top,r.Left + 22, r.Top + 10);

      Canvas.Rectangle(r.Right - 24,r.Top,r.Right - 2, r.Top + 10);
      Canvas.Brush.Color := clBlack;
      Canvas.Polygon([Point(r.Right - 6,r.Top + 4),Point(r.Right - 8,r.Top + 2),Point(r.Right - 8,r.Top + 6)]);
      Canvas.Rectangle(r.Right - 10,r.Bottom - 5,r.Right - 12,r.Bottom - 3);
      Canvas.Rectangle(r.Right - 14,r.Bottom - 5,r.Right - 16,r.Bottom - 3);
      Canvas.Rectangle(r.Right - 18,r.Bottom - 5,r.Right - 20,r.Bottom - 3);
    end;

  end
  else
  begin
    { Determine the cell background Color first }

    ABrush := TBrush.Create;
    FPlanner.GetCellBrush(ARow - RowOffset, AColumn,ABrush);
    CellColor := ABrush.Color;
    CellBrush := ABrush.Style;
    ABrush.Free;

    if (ARow - RowOffset < FColorList.Count) and (ARow - RowOffset >= 0) and
      (AColumn < NumColors) then
    begin
      PlannerColorArrayPointer := FColorList.Items[ARow - RowOffset];
      if PlannerColorArrayPointer^[AColumn] <> clNone then
        CellColor := PlannerColorArrayPointer^[AColumn];
    end;

    if FPlanner.CellInCurrTime(AColumn,ARow) then
      CellColor := FPlanner.FDisplay.ColorCurrent;

    if (gdSelected in AState) then
    begin
      CellColor := BlendColor(FPlanner.FSelectColor,CellColor,FPlanner.FSelectBlend);
    end;

    { End of setting cell background Color }
    NumberOfConflicts := FPlanner.Items.NumItem(AColumn, AColumn + 1, ARow - RowOffset);

    r := ARect;

    BottomPen := TPen.Create;
    BottomPen.Assign(Canvas.Pen);

    BottomPen.Width := 1;
    BottomPen.Color := FPlanner.GridLineColor;

    if Assigned(FPlanner.FOnPlannerBottomLine) then
      FPlanner.FOnPlannerBottomLine(Self, AColumn, ARow, BottomPen);

    Canvas.Brush.Color := CellColor;

    // if background item, draw first here
    APlannerItem := FPlanner.Items.FindBackground(AColumn,ARow - RowOffset);

    if Assigned(APlannerItem) then
    begin
      NRect.Left := ARect.Left - ((AColumn - APlannerItem.ItemBegin) * (ARect.Right -
        ARect.Left));
      NRect.Right := ARect.Right + ((APlannerItem.ItemEnd - AColumn - 1) * (ARect.Right -
        ARect.Left));
      NRect.Top := ARect.Top;
      NRect.Bottom := ARect.Bottom;

      RGN := CreateRectRgn(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom);
      SelectClipRgn(Canvas.Handle,RGN);

      PaintItemRow(Canvas, NRect, APlannerItem, False, (gdSelected in AState));

      // draw bottom line for background item if required
      if ARow = APlannerItem.ItemEnd -1 then
      begin
        Canvas.Pen.Assign(BottomPen);
        Canvas.MoveTo(ARect.Right - 1,ARect.Top);
        Canvas.LineTo(ARect.Right - 1, ARect.Bottom-1);
      end;

      APlannerItem.Repainted := False;

      SelectClipRgn(Canvas.Handle,0);
      DeleteObject(RGN);

      // make sure overlapping items are repainted  afterwards
      FPlanner.Items.ClearSelectedRepaints(AColumn, ARow - RowOffset);
    end;

    BkgFlag := Assigned(APlannerItem);

    for SubIndex := 1 to NumberOfConflicts.Y do
    begin
      ARect := r;
      m := (ARect.Bottom - ARect.Top) div (NumberOfConflicts.Y);
      ARect.Top := ARect.Top + (SubIndex - 1) * m;
      ARect.Bottom := ARect.Top + m;

      APlannerItem := FPlanner.Items.FindItemIndex(AColumn, ARow - RowOffset, SubIndex - 1);

      if (APlannerItem <> nil) then
      begin
        NRect.Left := ARect.Left - ((AColumn - APlannerItem.ItemBegin) * (ARect.Right -
          ARect.Left));
        NRect.Right := ARect.Right + ((APlannerItem.ItemEnd - AColumn - 1) * (ARect.Right -
          ARect.Left));
        NRect.Top := ARect.Top+1;
        NRect.Bottom := ARect.Bottom;

        if APlannerItem.Shape <> psRect then
        begin
          RectVertEx(Canvas, ARect, CellColor, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
          APlannerItem.Repainted := False;
        end;

        if FPlanner.DrawPrecise then
        begin

          if FPlanner.Mode.PlannerType = plTimeLine then
          begin
            FPlanner.CellToAbsTime(APlannerItem.ItemBegin,dts,dte);
            delta := 0;
          end
          else
          begin
            delta := APlannerItem.ItemBeginPrecis - ((APlannerItem.ItemBegin + FPlanner.Display.DisplayStart) * FPlanner.Display.DisplayUnit);
            delta := round(delta / FPlanner.Display.DisplayUnit * FPlanner.Display.DisplayScale);
          end;

          if delta > 0 then
          begin
            if (APlannerItem.ItemBegin >= Selection.Left) and
               (APlannerItem.ItemBegin <= Selection.Right) and
               (APlannerItem.ItemPos + RowOffset >= Selection.Top) and
               (APlannerItem.ItemPos + RowOffset <= Selection.Bottom) then
               Canvas.Brush.Color := FPlanner.SelectColor
            else
              Canvas.Brush.Color := FPlanner.GetCellColorCol(ARow - RowOffset,APlannerItem.ItemBegin);

            Canvas.Pen.Color := Canvas.Brush.Color;
            Canvas.Rectangle(NRect.Left,NRect.Top,NRect.Left + delta,NRect.Bottom);
          end;

          NRect.Left := NRect.Left + delta;

          delta := ((APlannerItem.ItemEnd + FPlanner.Display.DisplayStart)  * FPlanner.Display.DisplayUnit) - APlannerItem.ItemEndPrecis;
          delta := round(delta / FPlanner.Display.DisplayUnit * FPlanner.Display.DisplayScale);

          if delta > 0 then
          begin
            inc(delta);

            Canvas.Brush.Color := CellColor;
            Canvas.Pen.Color := Canvas.Brush.Color;
            Canvas.Rectangle(NRect.Right - delta,NRect.Top, NRect.Right - 1, NRect.Bottom);

            Canvas.Pen.Color := FPlanner.GridLineColor;
            Canvas.MoveTo(NRect.Right - 1,NRect.Top);
            Canvas.LineTo(NRect.Right - 1,NRect.Bottom);
          end;

          NRect.Right := NRect.Right - delta;
        end;

        PaintItemRow(Canvas, NRect, APlannerItem, False, False);

        NRect.Left := ARect.Left;
        NRect.Right := ARect.Right;

        if not (APlannerItem.Background and not APlannerItem.AllowOverlap) then
          NRect.Top := ARect.Bottom - FPlanner.FItemGap - 1
        else
          NRect.Top := ARect.Bottom - 1;

        if SubIndex = NumberOfConflicts.Y then
          NRect.Bottom := ARect.Bottom + 1
        else
          NRect.Bottom := ARect.Bottom;


        if not BkgFlag then
        begin
          if (not FPlanner.Background.Bitmap.Empty) and not (gdSelected in AState) and FPlanner.IsActive(AColumn,ARow) then
          begin
            if FPlanner.Background.Display = bdTile then
            begin
              DrawWallPaperTile(AColumn,ARow,NRect,0,NRect.Top - r.Top,CellColor);
              RectVertEx(Canvas, NRect, clNone,FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
            end
            else
            begin
              RectVertEx(Canvas, NRect, CellColor, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
              DrawWallPaperFixed(NRect,0,0,CellColor);
              RectVertEx(Canvas, NRect, clNone, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
            end;
          end
          else
          begin
            Canvas.Pen.Style := BottomPen.Style;
            RectVertEx(Canvas, NRect, CellColor, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
            Canvas.Pen.Style := psSolid;
          end;

          if (ARow > 0) and (Assigned(FPlanner.OnPlannerBkgDraw)) then
          begin
            FPlanner.OnPlannerBkgDraw(FPlanner, Canvas, NRect, AColumn, ARow - 1);
          end;
        end;
      end
      else
      begin
        if not BkgFlag then
        begin
          if (not FPlanner.Background.Bitmap.Empty) and not (gdSelected in AState) and FPlanner.IsActive(AColumn,ARow) then
          begin
            if FPlanner.Background.Display = bdTile then
            begin
              DrawWallPaperTile(AColumn,ARow,ARect,0,ARect.Top - r.Top,CellColor);
              RectVertEx(Canvas, ARect, clNone, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
            end
            else
            begin
              RectVertEx(Canvas, ARect, CellColor, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
              DrawWallPaperFixed(ARect,0,0,CellColor);
              RectVertEx(Canvas, ARect, clNone, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
            end;
          end
          else
          begin
            Canvas.Pen.Style := BottomPen.Style;
            RectVertEx(Canvas, ARect, CellColor, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
            Canvas.Pen.Style := psSolid;
          end;  

          if (ARow > 0) and (Assigned(FPlanner.OnPlannerBkgDraw)) then
          begin
            FPlanner.OnPlannerBkgDraw(FPlanner, Canvas, ARect, AColumn , ARow - 1);
          end;
        end;
      end;
    end;

    if (NumberOfConflicts.Y = 0) and not BkgFlag then
    begin
      if (not FPlanner.Background.Bitmap.Empty) and not (gdSelected in AState) and FPlanner.IsActive(AColumn, ARow) then
      begin
        if FPlanner.Background.Display = bdTile then
        begin
          DrawWallPaperTile(AColumn,ARow,ARect,0,0,CellColor);
          RectVertEx(Canvas, ARect, clNone, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
        end
        else
        begin
          RectVertEx(Canvas, ARect, CellColor, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
          DrawWallPaperFixed(ARect,0,0,CellColor);
          RectVertEx(Canvas, ARect, clNone, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
        end;
      end
      else
      begin
        Canvas.Pen.Style := BottomPen.Style;
        RectVertEx(Canvas, ARect, CellColor, FPlanner.Color, BottomPen.Color, BottomPen.Width, CellBrush);
        Canvas.Pen.Style := psSolid;
      end;

      if (ARow > 0) and (Assigned(FPlanner.OnPlannerBkgDraw)) then
      begin
        FPlanner.OnPlannerBkgDraw(FPlanner, Canvas, ARect, AColumn, ARow - 1);
      end;
    end;

    BottomPen.Free;

    ARect := r;
    if (FPlanner.FGridLineColor <> clNone) then
    begin
      Canvas.Pen.Color := FPlanner.FGridLineColor;
      Canvas.MoveTo(ARect.Left, ARect.Top);
      Canvas.LineTo(ARect.Right, ARect.Top);
      if (ARow = RowCount - 1) then
      begin
        Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
        Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
      end;
    end;
  end;

  Canvas.Font.Assign(OldFont);
  Canvas.Brush.Assign(OldBrush);
  OldFont.Free;
  OldBrush.Free;
end;

procedure TPlannerGrid.DragDrop(Source: TObject; X, Y: Integer);
var
  Point: TPoint;
  ColOffset, RowOffset: Integer;
  GridRect: TRect;
  GridCoord: TGridCoord;
  APlannerItem: TPlannerItem;
begin
  ColOffset := FPlanner.FSidebar.FColOffset;
  RowOffset := FPlanner.FSidebar.FRowOffset;

  GridCoord := mousecoord(X, Y);
  GridRect := CellRectEx(GridCoord.X, GridCoord.Y);

  if FPlanner.Sidebar.Orientation = soVertical then
  begin
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.Y - RowOffset,
      GridCoord.X - ColOffset, X - GridRect.Left);
  end
  else
  begin
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.X - ColOffset, GridCoord.Y - RowOffset,
      Y - GridRect.Top);
  end;

  if Assigned(FPlanner.FOnDragDrop) then
    FPlanner.FOnDragDrop(FPlanner, Source, X, Y);

  if Assigned(FPlanner.FOnDragDropCell) then
  begin
    Point := FPlanner.XYToCell(X, Y);
    FPlanner.FOnDragDropCell(FPlanner, Source, Point.X, Point.Y);
  end;

  if Assigned(APlannerItem) then
  begin
    if Assigned(FPlanner.FOnDragDropItem) then
      FPlanner.FOnDragDropItem(FPlanner, Source, GridCoord.X, GridCoord.Y - RowOffset, APlannerItem);
  end;

end;

procedure TPlannerGrid.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  GridCoord: TGridCoord;
  APlannerItem: TPlannerItem;
  ColOffset, RowOffset: Integer;
  GridRect: TRect;
begin
  Accept := False;
  inherited;

  GridCoord := MouseCoord(X, Y);

  if Assigned(FPlanner.FOnDragOver) then
  begin
    Accept := True;
    FPlanner.FOnDragOver(FPlanner, Source, X, Y, State, Accept);
  end;

  if Assigned(FPlanner.FOnDragOverCell) then
  begin
    Accept := True;
    if (FPlanner.FSidebar.Visible) and (FPlanner.FSidebar.Position in [spLeft, spLeftRight]) then
      GridCoord.X := GridCoord.X - 1;
    if (FPlanner.FSidebar.Visible) and (FPlanner.Sidebar.Position = spTop) then
      GridCoord.Y := GridCoord.Y - 1;
    FPlanner.FOnDragOverCell(FPlanner, Source, GridCoord.X, GridCoord.Y, State, Accept);
  end;

  ColOffset := FPlanner.FSidebar.FColOffset;
  RowOffset := FPlanner.FSidebar.FRowOffset;

  GridCoord := MouseCoord(X, Y);  
  GridRect := CellRectEx(GridCoord.X, GridCoord.Y);

  if FPlanner.Sidebar.Orientation = soVertical then
  begin
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.Y - RowOffset, GridCoord.X - ColOffset, X - GridRect.Left);
  end
  else
  begin
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.X - ColOffset, GridCoord.Y, 1);
  end;

  if Assigned(APlannerItem) then
  begin
    if Assigned(FPlanner.FOnDragOverItem) then
      FPlanner.FOnDragOverItem(Self, Source, GridCoord.X, GridCoord.Y, APlannerItem, State, Accept);
  end;
end;

function TPlannerGrid.GetHScrollSize: Integer;
begin
  Result := 0;
  if VisibleRowCount < RowCount then
  begin
    Result := GetSystemMetrics(SM_CXVSCROLL);
  end;
end;

function TPlannerGrid.GetVScrollSize: Integer;
begin
  Result := 0;
  if VisibleColCount < ColCount then
  begin
    Result := GetSystemMetrics(SM_CYHSCROLL);
  end;
end;


procedure TPlannerGrid.UpdatePositions;
var
  ColumnIndex: Integer;
  ItemIndex: Integer;
  SectionIndex: Integer;
  ColumnWidth, j, bw: Integer;
  ColOffset, RowOffset: Integer;
  poswi: SmallInt;
begin
  if csLoading in FPlanner.ComponentState then
    Exit;
  if FPlanner.Positions = 0 then
    Exit;

{$IFDEF TMSCODESITE}
  CodeSite.SendMsg(Format('Updatepositions : %d * %d', [FPlanner.Positions, ColCount]));
{$ENDIF}

  ColOffset := FPlanner.FSidebar.FColOffset;
  RowOffset := FPlanner.FSidebar.FRowOffset;

  if FPlanner.Flat then
    bw := 1
  else
    bw := 5;

  if FPlanner.Sidebar.Orientation = soVertical then
  begin
    if ColCount < FPlanner.Positions + ColOffset then
      ColCount := FPlanner.Positions + ColOffset;

    if FPlanner.SideBar.Visible then
      ColumnWidth := FPlanner.FSidebar.Width
    else
      ColumnWidth := 0;

    case FPlanner.SideBar.Position of
    spLeft:
      begin
        ColumnWidth := Self.Width - ColumnWidth - GetHScrollSize - bw;
        ColumnWidth := ColumnWidth div FPlanner.Positions;
      end;
    spRight:
      begin
        ColumnWidth := Self.Width - ColumnWidth - GetHScrollSize - bw;
        ColumnWidth := ColumnWidth div FPlanner.Positions;
        ColWidths[ColCount - 1] := FPlanner.FSidebar.Width;
      end;
    spLeftRight:
      begin
        ColumnWidth := Self.Width - 2 * ColumnWidth - GetHScrollSize - bw;
        ColumnWidth := ColumnWidth div FPlanner.Positions;
        ColWidths[ColCount - 1] := FPlanner.FSidebar.Width;
      end
    else
    begin
      ColumnWidth := Self.Width - ColumnWidth - GetHScrollSize - bw;
      ColumnWidth := ColumnWidth div FPlanner.Positions;
    end;
    end;

    DefaultRowHeight := FPlanner.FDisplay.FDisplayScale;

    if FPlanner.FPositionWidth <> 0 then
      ColumnWidth := FPlanner.FPositionWidth;

    for ColumnIndex := ColOffset to FPlanner.Positions + ColOffset - 1 do
      if (ColumnIndex < ColCount) then
        ColWidths[ColumnIndex] := ColumnWidth;
  end
  else
  begin
    if RowOffset = 1 then
    begin
      RowHeights[0] := FPlanner.FSidebar.Width;
      ColumnWidth := Self.Height - RowHeights[0] - GetVScrollSize - bw;
      ColumnWidth := ColumnWidth div FPlanner.Positions;
    end
    else
    begin
      ColumnWidth := Self.Height - GetVScrollSize - 10 - FPlanner.FSidebar.Width;
      ColumnWidth := ColumnWidth div FPlanner.Positions;
      RowHeights[RowCount - 1] := FPlanner.FSidebar.Width;
    end;
    DefaultColWidth := FPlanner.FDisplay.FDisplayScale;
    if FPlanner.FPositionWidth <> 0 then
      ColumnWidth := FPlanner.FPositionWidth;

    for ItemIndex := RowOffset to FPlanner.Positions + RowOffset - 1 do
      RowHeights[ItemIndex] := ColumnWidth;
  end;

  for ItemIndex := 0 to FPlanner.Items.Count-1 do
    (FPlanner.Items.Items[ItemIndex] as TPlannerItem).UpdateWnd;

  poswi := 0;

  if FPlanner.Sidebar.Visible then
    Inc(poswi);


  while (FPlanner.FHeader.Sections.Count < FPlanner.Positions + poswi + 1) do
    FPlanner.FHeader.Sections.Add('');
  while (FPlanner.FHeader.Sections.Count > FPlanner.Positions + poswi + 1) do
    FPlanner.FHeader.Sections.Delete(FPlanner.FHeader.Sections.Count - 1);

  for SectionIndex := 0 to FPlanner.FHeader.Sections.Count-1 do
  begin
    if SectionIndex < FPlanner.FPlannerHeader.Captions.Count then
      FPlanner.FHeader.Sections[SectionIndex] :=
        FPlanner.FPlannerHeader.Captions.Strings[SectionIndex];

    if FPlanner.Sidebar.Orientation = soVertical then
      FPlanner.FHeader.SectionWidth[SectionIndex] := ColWidths[SectionIndex]
    else
      FPlanner.FHeader.SectionWidth[SectionIndex] := RowHeights[SectionIndex];

    if FPlanner.FSidebar.Visible then
      j := 0
    else
      j := 1;

    if (SectionIndex = j) and FPlanner.NavigatorButtons.Visible and
       (FPlanner.SideBar.Position <> spTop) then
    begin
      FPlanner.FHeader.SectionWidth[SectionIndex] := ColWidths[SectionIndex] - BtnWidth
    end;

    if (SectionIndex = FPlanner.FHeader.Sections.Count - 1) and
      (FPlanner.SideBar.Position <> spTop) and FPlanner.NavigatorButtons.Visible then
      FPlanner.FHeader.SectionWidth[SectionIndex] := ColWidths[SectionIndex] - BtnWidth;
  end;

  if FPlanner.Flat then
  begin
    if FPlanner.FHeader.Flat then
      FPlanner.FHeader.SectionWidth[0] := FPlanner.FHeader.SectionWidth[0] - 2
    else
      FPlanner.FHeader.SectionWidth[0] := FPlanner.FHeader.SectionWidth[0];
  end
  else
  begin
    if not FPlanner.FHeader.Flat then
      FPlanner.FHeader.SectionWidth[0] := FPlanner.FHeader.SectionWidth[0] + 2
  end;

end;

procedure TPlannerGrid.SelChanged;
var
  FromSel, ToSel, FromSelPrecis, ToSelPrecis: Integer;

  function EqualSel(a, b: TGridRect): Boolean;
  begin
    Result := (a.Left = b.Left) and (a.Top = b.Top) and
              (a.Right = b.Right) and (a.Bottom = b.Bottom);
  end;

begin
  if not EqualSel(FOldSelection, Selection) then
  begin
    if FPlanner.Sidebar.Orientation = soHorizontal then
    begin
      FromSel := Selection.Left;
      ToSel := 1 + Selection.Right;
    end
    else
    begin
      FromSel := Selection.Top;
      ToSel := 1 + Selection.Bottom;
    end;

    FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
    ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;

    if Assigned(FPlanner.FOnPlannerSelChange) then
      FPlanner.FOnPlannerSelChange(FPlanner, Selection.Top - 1, FromSel,
        FromSelPrecis, ToSel, ToSelPrecis);

    RepaintSelection(FOldSelection);
    RepaintSelection(Selection);

    FOldSelection := Selection;
  end;
end;

procedure TPlannerGrid.UpdateNVI;
var
  i,j: Integer;
  TVS,BVS: Boolean;

begin
  if not FPlanner.IndicateNonVisibleItems then
    Exit;

  TVS := False;
  BVS := False;

  if FPlanner.SideBar.Position <> spTop then
  begin
    if TopRow > 0 then
    begin
      for j := 0 to TopRow - 1 do
        for i := 1 to FPlanner.Positions do
        begin
          if Assigned(FPlanner.Items.FindItem(j,i - 1)) then
          begin
            TVS := True;
            Break;
          end;
        end;
    end;

    if TopRow + VisibleRowCount < RowCount then
    begin
      for j := TopRow + VisibleRowCount to RowCount - 1 do
        for i := 1 to FPlanner.Positions  do
        begin
          if Assigned(FPlanner.Items.FindItem(j,i - 1)) then
          begin
            BVS := True;
            Break;
          end;
        end;
    end;

    if FPlanner.FTopIndicator <> TVS then
    begin
      FPlanner.FTopIndicator := TVS;
      FPlanner.FGrid.RepaintRect(Rect(0,0,22,20));
    end;

    FPlanner.FBottomIndicator := BVS;
    FPlanner.FGrid.RepaintRect(Rect(0,FPlanner.FGrid.Height - 30,22,FPlanner.FGrid.Height));

  end
  else
  begin
    if LeftCol > 0 then
    begin
      for j := 0 to LeftCol - 1 do
        for i := 1 to FPlanner.Positions do
        begin
          if Assigned(FPlanner.Items.FindItem(j,i - 1)) then
          begin
            TVS := True;
            Break;
          end;
        end;
    end;

    if LeftCol + VisibleColCount < ColCount then
    begin
      for j := LeftCol + VisibleColCount to ColCount - 1 do
        for i := 1 to FPlanner.Positions  do
        begin
          if Assigned(FPlanner.Items.FindItem(j,i - 1)) then
          begin
            BVS := True;
            Break;
          end;
        end;
    end;

    if FPlanner.FTopIndicator <> TVS then
    begin
      FPlanner.FTopIndicator := TVS;
      FPlanner.FGrid.RepaintRect(Rect(0,0,22,20));
    end;

    FPlanner.FBottomIndicator := BVS;
    FPlanner.FGrid.RepaintRect(Rect(FPlanner.FGrid.Width - 22,0,FPlanner.FGrid.Width,22));

  end;

end;

procedure TPlannerGrid.TopLeftChanged;
var
  ItemIndex: Integer;

begin
  for ItemIndex := 0 to FPlanner.Items.Count - 1 do
  begin
    if ((FPlanner.Items.Items[ItemIndex] as TPlannerItem).ItemBegin >= TopRow - 1)
      and
      ((FPlanner.Items.Items[ItemIndex] as TPlannerItem).ItemEnd <= TopRow +
      VisibleRowCount + 1) then
      (FPlanner.Items.Items[ItemIndex] as TPlannerItem).UpdateWnd;
  end;

  if FPlanner.Sidebar.Orientation = soVertical then
    FPlanner.FHeader.FLeftPos := Max(0, LeftCol - 1)
  else
    FPlanner.FHeader.FLeftPos := Max(0, TopRow - 1);

  FPlanner.FHeader.Invalidate;

  if Assigned(FPlanner.FOnTopLeftChanged) then
    FPlanner.FOnTopLeftChanged(FPlanner);

  if FPlanner.ScrollBarStyle.Flat then
  begin
    UpdateVScrollBar;
    UpdateHScrollBar;
  end;

  if (FPlanner.FSideBar.Position in [spLeft,spLeftRight,spRight]) and
     (FPlanner.FSidebar.ActiveColor <> clNone) then
  begin
    for ItemIndex := 0 to RowCount - 1 do
      InvalidateCell(0,ItemIndex);
  end;

  if FPlanner.FSideBar.Visible and FPlanner.FSideBar.Border and
     (FPlanner.FSideBar.Position in [spLeft,spLeftRight,spRight]) then
  begin
    if FPlanner.FSideBar.Position in [spLeft,spLeftRight] then
    begin
      InvalidateCell(0,TopRow);
      InvalidateCell(0,FOldTopRow);
      FOldTopRow := TopRow;
    end;

    if FPlanner.FSideBar.Position in [spRight,spLeftRight] then
    begin
      InvalidateCell(ColCount - 1,TopRow);
      InvalidateCell(ColCount - 1,FOldTopRow);
      FOldTopRow := TopRow;
    end;
  end;

  if (FPlanner.FSideBar.ShowInPositionGap and
    (FPlanner.FSideBar.Position in [spLeft,spLeftRight,spRight])) then
  begin
    for ItemIndex := 0 to ColCount - 1 do
    begin
      InvalidateCell(ItemIndex,TopRow);
      InvalidateCell(ItemIndex,FOldTopRow);
    end;
    FOldTopRow := TopRow;
  end;

  if FPlanner.FSideBar.Visible and FPlanner.FSideBar.Border and
     (FPlanner.FSideBar.Position = spTop) then
  begin
    InvalidateCell(LeftCol,0);
    InvalidateCell(FOldLeftCol,0);
    FOldLeftCol := LeftCol;
  end;

  UpdateNVI;

end;

procedure TPlannerGrid.StartEditCol(ARect: TRect; APlannerItem: TPlannerItem; X, Y:
  Integer);
var
  ColumnHeight, ih, iw, ew, tw, eh, TopOffset: Integer;
  s: string;
  ER: TRect;

begin
  if APlannerItem = nil then
    Exit;

  if APlannerItem.FPopupEdit then
    Exit;

  if Assigned(APlannerItem.Editor) then
  begin
    if APlannerItem.Editor.EditorUse = euAlways then
    begin
      if Assigned(FPlanner.OnItemStartEdit) then
      begin
        FPlanner.OnItemStartEdit(Self, APlannerItem);
      end;

      APlannerItem.Editor.Edit(FPlanner,APlannerItem);

      if Assigned(FPlanner.OnItemEndEdit) then
        FPlanner.OnItemEndEdit(Self, APlannerItem);
      Exit;
    end;
  end;

  if FPlanner.InplaceEdit = ieNever then
    Exit;

  if Assigned(FPlanner.OnItemStartEdit) then
  begin
    FPlanner.OnItemStartEdit(Self, APlannerItem);
  end;

  if (APlannerItem.FConflicts > 1) then
  begin
    iw := ColWidthEx(APlannerItem.ItemPos) div APlannerItem.FConflicts;
    ARect.Left := ARect.Left + APlannerItem.FConflictPos * iw;
    ARect.Right := ARect.Left + iw;
  end;

  ColumnHeight := 0;
  ih := 0;
  iw := 0;
  ew := 0;
  eh := 0;

  if APlannerItem.Shape = psRect then
    tw := FPlanner.TrackWidth
  else
    tw := 0;

  case APlannerItem.Shape of
  psRounded:
    begin
      ew := ew + (CORNER_EFFECT shr 1) + 1;
      ARect.Top := ARect.Top + 6;
      eh := eh + 6;
    end;
  psHexagon:
    begin
      ew := ew + CORNER_EFFECT;
      ARect.Top := ARect.Top + 4;
      eh := eh + 6;
     end;
  end;

  if APlannerItem.Shadow then
  begin
    ew := ew + 1;
    eh := eh + 3;
  end;

  if APlannerItem.CompletionDisplay = cdVertical then
    ew := ew + 10;

  if ((APlannerItem.ImageID >= 0) or (APlannerItem.FImageIndexList.Count > 0)) and
    Assigned(FPlanner.PlannerImages) then
  begin
    ih := FPlanner.PlannerImages.Height + 2;
    iw := FPlanner.PlannerImages.Width + 2;
  end;

  if (APlannerItem.CaptionType <> ctNone) or (APlannerItem.FImageIndexList.Count > 1) then
  begin
    Canvas.Font.Assign(APlannerItem.CaptionFont);
    ColumnHeight := Canvas.TextHeight('gh') + 2;
    iw := 0;
  end
  else
    ih := 0;

  if (ih > ColumnHeight) then
    ColumnHeight := ih;

  s := APlannerItem.Text.Text;

  if APlannerItem.ItemBegin < TopRow then
    TopOffset := 0
  else
    TopOffset := 2 + EDITOFFSET + ColumnHeight;

  if APlannerItem.CompletionDisplay = cdHorizontal then
    TopOffset := TopOffset + 12;

  if IsRtf(s) or (APlannerItem.InplaceEdit = peRichText) then
  begin
    FPlanner.FRichEdit.Parent := Self;
    FPlanner.FRichEdit.ScrollBars := FPlanner.EditScroll;
    FPlanner.FRichEdit.PlannerItem := APlannerItem;
    FPlanner.TextToRich(s);
    FPlanner.FRichEdit.Top := ARect.Top + 6 + ColumnHeight;
    FPlanner.FRichEdit.Left := ARect.Left + tw + 1 + iw + ew;
    FPlanner.FRichEdit.Width := ARect.Right - ARect.Left - tw - 3 - FPlanner.FItemGap
      - iw - 2 * ew;
    FPlanner.FRichEdit.Height := (APlannerItem.ItemEnd - APlannerItem.ItemBegin) * RowHeights[0]
      - 10 - ColumnHeight;
    FPlanner.FRichEdit.Visible := True;
    BringWindowToTop(FPlanner.FRichEdit.Handle);
    FPlanner.FRichEdit.SetFocus;
    FPlanner.FRichEdit.SelectAll;
  end
  else
    case APlannerItem.InplaceEdit of
      peMaskEdit, peEdit:
        begin
          if APlannerItem.InplaceEdit = peMaskEdit then
            FMaskEdit.EditMask := APlannerItem.EditMask
          else
            FMaskEdit.EditMask := '';
          FMaskEdit.Font.Assign(FPlanner.Font);
          if APlannerItem.ShowSelection then
          begin
            FMaskEdit.Color := APlannerItem.SelectColor;
            FMaskEdit.Font.Color := APlannerItem.SelectFontColor
          end
          else
            FMaskEdit.Color := APlannerItem.Color;

          FMaskEdit.PlannerItem := APlannerItem;
          FMaskEdit.Top := ARect.Top + TopOffset;
          FMaskEdit.Left := ARect.Left + tw + 1 + iw + ew;
          FMaskEdit.Width := ARect.Right - ARect.Left - tw - 3 - FPlanner.FItemGap -
            iw - 2 * ew;
          FMaskEdit.Height := APlannerItem.GetVisibleSpan * RowHeights[0] - 2 - TopOffset;
          FMaskEdit.BorderStyle := bsNone;
          FMaskEdit.Visible := True;
          if (APlannerItem.Text.Count > 0) then
            FMaskEdit.Text := APlannerItem.Text[0];
          BringWindowToTop(FMaskEdit.Handle);
          FMaskEdit.SetFocus;
        end;
      peMemo:
        begin
          FMemo.Parent := Self;
          FMemo.ScrollBars := FPlanner.EditScroll;
          FMemo.Font.Assign(APlannerItem.Font);
          if APlannerItem.ShowSelection then
          begin
            FMemo.Color := APlannerItem.SelectColor;
            FMemo.Font.Color := APlannerItem.SelectFontColor;
          end
          else
            FMemo.Color := APlannerItem.Color;
          FMemo.PlannerItem := APlannerItem;

          FMemo.Top := ARect.Top +  TopOffset;

          FMemo.Left := ARect.Left + tw + 1 + iw + ew;
          FMemo.Width := ARect.Right - ARect.Left - tw - 4 - FPlanner.FItemGap
            - iw - 2 * ew;

          FMemo.Height := APlannerItem.GetVisibleSpan * RowHeights[0] - 4 - eh - TopOffset;

          FMemo.BorderStyle := bsNone;
          FMemo.Visible := True;
          BringWindowToTop(FMemo.Handle);
          FMemo.Lines.Text := HTMLStrip(APlannerItem.Text.Text);
          FMemo.SetFocus;

          SetEditDirectSelection(ARect, X, Y);
        end;
      peCustom:
        begin
          ER.Left := ARect.Left + tw + 1 + iw + ew;
          ER.Top := ARect.Top + TopOffset;
          ER.Right := ARect.Right - tw - 3 - FPlanner.FItemGap - iw - 2 * ew;
          ER.Bottom := ARect.Top + APlannerItem.GetVisibleSpan * RowHeights[0] - 10 -
            ColumnHeight;
          if Assigned(FPlanner.FOnCustomEdit) then
            FPlanner.FOnCustomEdit(Self,ER,APlannerItem);
        end;
    end;
end;

procedure TPlannerGrid.SetEditDirectSelection(ARect: TRect; X, Y: Integer);
var
  CharacterCoordinate: Integer;
begin
  if (FPlanner.EditDirect) and (X > -1) then
  begin
    CharacterCoordinate := SendMessage(FMemo.Handle, EM_CHARFROMPOS, 0,
      MakeLong(X - ARect.Left, Y - ARect.Top));
    if (CharacterCoordinate = -1) then
      Exit;
    FMemo.SelStart := LoWord(CharacterCoordinate);
    FMemo.SelLength := 0;
  end
  else
    FMemo.SelectAll;
end;

procedure TPlannerGrid.StartEditRow(ARect: TRect; APlannerItem: TPlannerItem; X, Y:
  Integer);
var
  ColumnHeight, ih, iw, ew, eh: Integer;
  s: string;
  ER: TRect;

begin
  if APlannerItem = nil then
    Exit;

  if APlannerItem.FPopupEdit then
    Exit;

  if Assigned(APlannerItem.Editor) then
  begin
    if APlannerItem.Editor.EditorUse = euAlways then
    begin
      if Assigned(FPlanner.OnItemStartEdit) then
      begin
        FPlanner.OnItemStartEdit(Self, APlannerItem);
      end;

      APlannerItem.Editor.Edit(FPlanner,APlannerItem);
      if Assigned(FPlanner.OnItemEndEdit) then
        FPlanner.OnItemEndEdit(Self, APlannerItem);
      Exit;
    end;
  end;

  if FPlanner.InplaceEdit = ieNever then
    Exit;

  if Assigned(FPlanner.OnItemStartEdit) then
  begin
    FPlanner.OnItemStartEdit(Self, APlannerItem);
  end;

  if (APlannerItem.FConflicts > 1) then
  begin
    iw := RowHeightEx(APlannerItem.ItemPos) div APlannerItem.FConflicts;
    ARect.Top := ARect.Top + APlannerItem.FConflictPos * iw;
    ARect.Bottom := ARect.Top + iw;
  end;

  ColumnHeight := 0;
  ih := 0;
  iw := 0;
  ew := 0;
  eh := 0;

  case APlannerItem.Shape of
  psRounded:
    begin
      ew := ew + (CORNER_EFFECT shr 1) - 1;
      ARect.Top := ARect.Top + 4;
    end;
  psHexagon: ew := ew + CORNER_EFFECT;
  end;

  if APlannerItem.Shadow then
  begin
    ew := ew + 1;
    eh := eh + 2;
  end;

  if APlannerItem.CompletionDisplay = cdVertical then
    ew := ew + 10;

  if APlannerItem.CompletionDisplay = cdHorizontal then
    ARect.Top := ARect.Top + 12;

  if ((APlannerItem.ImageID >= 0) or (APlannerItem.FImageIndexList.Count > 0)) and
    Assigned(FPlanner.PlannerImages) then
  begin
    ih := FPlanner.PlannerImages.Height + 2;
    iw := FPlanner.PlannerImages.Width + 2;
  end;

  if (APlannerItem.CaptionType <> ctNone) or (APlannerItem.FImageIndexList.Count > 1) then
  begin
    ColumnHeight := Canvas.TextHeight('gh') + 2;
    iw := 0;
  end
  else
    ih := 0;

  if (ih > ColumnHeight) then
    ColumnHeight := ih;

  s := APlannerItem.Text.Text;

  if IsRtf(s) or (APlannerItem.InplaceEdit = peRichText) then
  begin
    FPlanner.FRichEdit.Parent := Self;
    FPlanner.FRichEdit.ScrollBars := FPlanner.EditScroll;
    FPlanner.FRichEdit.PlannerItem := APlannerItem;
    FPlanner.TextToRich(s);
    FPlanner.FRichEdit.Top := ARect.Top + FPlanner.TrackWidth + 2 + ColumnHeight;
    FPlanner.FRichEdit.Left := ARect.Left + 3 + iw + ew;
    FPlanner.FRichEdit.Width := (APlannerItem.ItemEnd - APlannerItem.ItemBegin) * ColWidthEx(APlannerItem.ItemPos) -
      6 - ColumnHeight - 2 * ew;
    FPlanner.FRichEdit.Height := ARect.Bottom - ARect.Top - 18 - iw;
    FPlanner.FRichEdit.Visible := True;
    BringWindowToTop(FPlanner.FRichEdit.Handle);
    FPlanner.FRichEdit.SetFocus;
    FPlanner.FRichEdit.SelectAll;
  end
  else
    case APlannerItem.InplaceEdit of
      peMaskEdit, peEdit:
        begin
          if APlannerItem.InplaceEdit = peMaskEdit then
            FMaskEdit.EditMask := APlannerItem.EditMask
          else
            FMaskEdit.EditMask := '';
          FMaskEdit.Font.Assign(FPlanner.Font);
          FMaskEdit.Color := APlannerItem.Color;
          FMaskEdit.PlannerItem := APlannerItem;
          FMaskEdit.Top := ARect.Top + FPlanner.TrackWidth + 2 + ColumnHeight;
          FMaskEdit.Left := ARect.Left + 3 + iw + ew;
          FMaskEdit.Width := APlannerItem.GetVisibleSpan * ColWidthEx(APlannerItem.ItemPos) - 6
            - iw - 2 * ew;
          FMaskEdit.Height := ARect.Bottom - ARect.Top - FPlanner.FItemGap - ColumnHeight - FPlanner.TrackWidth;
          FMaskEdit.BorderStyle := bsNone;
          FMaskEdit.Visible := True;
          if (APlannerItem.Text.Count > 0) then
            FMaskEdit.Text := APlannerItem.Text[0];
          BringWindowToTop(FMaskEdit.Handle);
          FMaskEdit.SetFocus;
        end;
      peMemo:
        begin
          FMemo.Parent := Self;
          FMemo.ScrollBars := FPlanner.EditScroll;
          FMemo.Font.Assign(APlannerItem.Font);

          if APlannerItem.ShowSelection then
          begin
            FMemo.Color := APlannerItem.SelectColor;
            FMemo.Font.Color := APlannerItem.SelectFontColor;
          end
          else
            FMemo.Color := APlannerItem.Color;

          FMemo.PlannerItem := APlannerItem;
          FMemo.Top := ARect.Top + FPlanner.TrackWidth + 2 + ColumnHeight;
          FMemo.Left := ARect.Left + 3 + iw + ew;
          FMemo.Width := APlannerItem.GetVisibleSpan * ColWidthEx(APlannerItem.ItemPos) - 6 -
            iw - 2 * ew;
          FMemo.Height := ARect.Bottom - ARect.Top - FPlanner.FItemGap - ColumnHeight - FPlanner.TrackWidth - 6 - eh;
          FMemo.BorderStyle := bsNone;
          FMemo.Visible := True;
          FMemo.Lines.Text := HTMLStrip(APlannerItem.Text.Text);
          BringWindowToTop(FMemo.Handle);
          FMemo.SetFocus;
          SetEditDirectSelection(ARect, X, Y);
        end;
      peCustom:
        begin
          ER.Left := ARect.Left + 3 + iw + ew;
          ER.Top := ARect.Top + FPlanner.TrackWidth + 2 + ColumnHeight;
          ER.Right := ARect.Left + APlannerItem.GetVisibleSpan * ColWidthEx(APlannerItem.ItemPos)
            - 6 - iw - 2 * ew;
          ER.Bottom := ARect.Bottom - FPlanner.FItemGap - ColumnHeight - FPlanner.TrackWidth -6;
          if Assigned(FPlanner.FOnCustomEdit) then
            FPlanner.FOnCustomEdit(Self,ER,APlannerItem);
        end;
    end;
end;

procedure TPlannerGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  FromSel, FromSelPrecis: Integer;
  ToSel, ToSelPrecis: Integer;
  APlannerItem, nplIt: TPlannerItem;
  GridCoord: TGridCoord;
  GridRect,GridRectE, r, tr, hr, cr: TRect;
  iw: Integer;
  grr: TGridRect;
  s, Anchor, StrippedHtmlString, FocusAnchor: string;
  XSize, YSize, ImgSize, ml, hl: Integer;
  ColOffset, RowOffset: Integer;
  OutBounds, AutoHandle: Boolean;
  //ShiftState: TShiftState;
  ScreenPoint: TPoint;
  CID, CV, CT: string;
  OrigButton: TMouseButton;

begin
  ColOffset := FPlanner.FSidebar.FColOffset;
  RowOffset := FPlanner.FSidebar.FRowOffset;

  if Assigned(FPlanner.FOnPlannerMouseDown) then
  begin
    FPlanner.FOnPlannerMouseDown(FPlanner, Button, Shift, X, Y);
  end;

  OrigButton := Button;

  if (Button = mbRight) and (FPlanner.ItemSelection.Button in [sbRight,sbBoth]) then
    Button := mbLeft
  else
    if (Button = mbLeft) and (FPlanner.ItemSelection.Button in [sbRight]) then
    begin
      Button := mbRight;
    end;  

  if (Button = mbLeft) then
  begin
    SetCapture(Self.Handle);

    FMouseDown := True;
    FMouseXY := Point(X,Y);
    GridCoord := MouseCoord(X,Y);

    GridRect := CellRectEx(GridCoord.X, GridCoord.Y);

    if GetFocus <> Self.Handle then
    begin
      Self.SetFocus;
      //++v1.6b++
      if (Selection.Left < 0) or (Selection.Top < 0) or
         (Selection.Left >= ColCount) or (Selection.Top >= RowCount) then
      //--v1.6b--
      begin
        grr.Top := GridCoord.Y;
        grr.Left := GridCoord.X;
        grr.Bottom := GridCoord.Y;
        grr.Right := GridCoord.X;
        Selection := grr;
        SelChanged;
      end;
    end;

    if FPlanner.Sidebar.Orientation = soVertical then
    begin
      APlannerItem := FPlanner.Items.FindItemPos(GridCoord.Y - RowOffset, GridCoord.X - ColOffset, X
        - GridRect.Left);
      OutBounds := (X > GridRect.Right - FPlanner.ItemGap);
    end
    else
    begin
      APlannerItem := FPlanner.Items.FindItemPos(GridCoord.X - ColOffset, GridCoord.Y - RowOffset, Y
        - GridRect.Top);
      OutBounds := (Y > GridRect.Bottom - FPlanner.ItemGap);
    end;

    if (APlannerItem = nil) or OutBounds then
    begin
      inherited;
      if FPlanner.ItemSelection.AutoUnSelect then
      begin
        FPlanner.Items.UnSelectAll;
        SelChanged;
      end;
      if Assigned(FPlanner.FOnPlannerLeftClick) then
      begin
        if FPlanner.Sidebar.Orientation = soVertical then
        begin
          FromSel := Selection.Top + FPlanner.Display.DisplayStart;
          ToSel := 1 + Selection.Bottom + FPlanner.Display.DisplayStart;
          FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          FPlanner.FOnPlannerLeftClick(FPlanner, Col - ColOffset, FromSel,
            FromSelPrecis, ToSel, ToSelPrecis);
        end
        else
        begin
          FromSel := Selection.Left + FPlanner.Display.DisplayStart;
          ToSel := 1 + Selection.Right + FPlanner.Display.DisplayStart;
          FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          FPlanner.FOnPlannerLeftClick(FPlanner, Row - RowOffset, FromSel,
            FromSelPrecis, ToSel, ToSelPrecis);
        end;
      end;
      Exit;
    end
    else
    begin
      if not FPlanner.SelectionAlways then
        HideSelection;

      if FPlanner.Sidebar.Orientation = soVertical then
      begin
        if (APlannerItem.ItemBegin < TopRow) and FPlanner.AutoItemScroll then
          TopRow := APlannerItem.ItemBegin;
      end
      else
      begin
        if (APlannerItem.ItemBegin < LeftCol) and FPlanner.AutoItemScroll then
          LeftCol := APlannerItem.ItemBegin;
      end;

      if Assigned(FPlanner.FOnItemLeftClick) then
        FPlanner.FOnItemLeftClick(FPlanner, APlannerItem);
    end;

    APlannerItem := FPlanner.Items.FSelected;

    if FPlanner.Sidebar.Orientation = soVertical then
    begin
      nplIt := FPlanner.Items.FocusItem(GridCoord.Y - RowOffset, GridCoord.X - ColOffset, X -
        GridRect.Left, ssCtrl in Shift);

      if (Assigned(nplIt)) and (APlannerItem <> nplIt) then
      begin
        FPlanner.ItemSelected(nplIt);
        SetFocus;

        {direct move fix}
        if (FPlanner.DirectMove or nplIt.NotEditable) and not nplIt.FixedPos then
        begin
          FItemXY := Point(nplIt.ItemPos, nplIt.ItemBegin);
          FItemXYS := Rect(nplIt.ItemPos, nplIt.ItemBegin, nplIt.ItemEnd, 0);
          FMouseDownMove := not nplIt.FixedPos;
          FMouseStart := FMouseDownMove;
          if FMemo.Visible then
            FMemo.DoExit;
          HintShowXY(X, Y, nplIt.ItemSpanTimeStr);
          Exit;
        end;

        if FPlanner.EditDirect then
        begin
          APlannerItem := nplIt;
          APlannerItem.EnsureFullVisibility;
        end
        else
          Exit;
      end;

      if (APlannerItem = nplIt) and Assigned(APlannerItem) then
      begin
        GridRect := CellRectEx(APlannerItem.ItemPos + ColOffset, APlannerItem.ItemBegin);

        GridRectE := CellRectEx(APlannerItem.ItemPos + ColOffset, APlannerItem.ItemEnd - 1);

        ImgSize := 0;

        if Assigned(FPlanner.PlannerImages) and
           ((APlannerItem.ImageID >= 0) or (APlannerItem.FImageIndexList.Count > 0)) then
          begin
            iw := FPlanner.PlannerImages.Width;
            ImgSize := 8 + (iw * APlannerItem.FImageIndexList.Count) + iw;
          end;

        APlannerItem.CalcConflictRect(GridRect, ColWidthEx(nplIt.ItemPos), RowHeightEx(RowOffset),
          FPlanner.Sidebar.Orientation = soVertical);

        if APlannerItem.Focus then
        begin
          s := ConcatenateTextStrings(APlannerItem.Text);

          r := CellRectEx(GridCoord.X, GridCoord.Y);

          APlannerItem.CalcConflictRect(r, ColWidthEx(nplIt.ItemPos), RowHeightEx(1),
            FPlanner.Sidebar.Orientation = soVertical);

          r.Left := r.Left + FPlanner.TrackWidth;
          r.Top := r.Top - ((GridCoord.Y - APlannerItem.ItemBegin) * DefaultRowHeight) + 4;
          r.Bottom := r.Bottom + ((APlannerItem.ItemEnd - GridCoord.Y - 1) * DefaultRowHeight)
            + 4;

          if (APlannerItem.CaptionType <> ctNone) then
          begin
            tr := r;

            tr.Bottom := tr.Top + 16;

            if APlannerItem.Attachement <> '' then
            begin
              tr.Left := tr.Right - 16;

              if PtInRect(tr,Point(X,Y)) then
              begin
                AutoHandle := true;

                if Assigned(FPlanner.FOnItemAttachementClick) then
                  FPlanner.FOnItemAttachementCLick(FPlanner,APlannerItem,APlannerItem.Attachement,AutoHandle);
                if AutoHandle then
                  ShellExecute(0,'open',PChar(APlannerItem.Attachement),nil,nil,SW_NORMAL);

                Exit;
              end;

              tr.Right := tr.Right - 16;
            end;

            if APlannerItem.URL <> '' then
            begin
              tr.Left := tr.Right - 16;

              if PtInRect(tr,Point(X,Y)) then
              begin
                AutoHandle := true;

                if Assigned(FPlanner.FOnItemURLClick) then
                  FPlanner.FOnItemURLCLick(FPlanner,APlannerItem,APlannerItem.URL,AutoHandle);
                if AutoHandle then
                  ShellExecute(0,'open',PChar(APlannerItem.URL),nil,nil,SW_NORMAL);

                Exit;
              end;
            end;


            if (APlannerItem.CaptionType in [ctText,ctTimeText]) then
            begin
              if IsHtml(APlannerItem,APlannerItem.CaptionText) then

                if HTMLDrawEx(Canvas, APlannerItem.CaptionText, r, FPlanner.PlannerImages, X, Y,
                  -1, -1, 1, True, False, False, True, True, False, APlannerItem.WordWrap
                  ,False
                  , 1.0, FPlanner.URLColor,
                  clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
                  ,cr, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
                  ) then

              begin
                if Assigned(FPlanner.FOnItemAnchorClick) then
                  FPlanner.FOnItemAnchorClick(FPlanner, APlannerItem, Anchor);
                Exit;
              end;
            end;

            r.Top := r.Top + APlannerItem.FCaptionHeight;
          end;

          if IsHtml(APlannerItem,s) then
          begin
            Canvas.Font := APlannerItem.Font;

            APlannerItem.CompletionAdapt(r);

            if HTMLDrawEx(Canvas, s, r, FPlanner.PlannerImages, X, Y,
              -1, -1, 1, True, False, False, True, True, False, APlannerItem.WordWrap
              ,False
              , 1.0, FPlanner.URLColor,
              clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
              ,cr, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
              ) then

            begin
              if cr.Right <> 0 then
              begin
                FormHandle(APlannerItem, cr, CID, CT, CV);

                If Assigned(FPlanner.FOnItemControlClick) then
                  FPlanner.FOnItemControlClick(Self,X,Y,APlannerItem,CID,CT,CV);

                InvalidateRect(Handle,@cr,False);
              end;

              if Assigned(FPlanner.FOnItemAnchorClick) then
                FPlanner.FOnItemAnchorClick(FPlanner, APlannerItem, Anchor);
              Exit;
            end;
          end;
        end;

        if ((X < GridRect.Left + FPlanner.TrackWidth + 2) or
          ((Y > GridRect.Top + 3) and (Y < GridRect.Top +
            APlannerItem.GetCaptionHeight) and (APlannerItem.ItemBegin = GridCoord.Y) and
           (X > GridRect.Left + ImgSize) ))

        and not APlannerItem.Background and not APlannerItem.FixedPos then
        begin
          FItemXY := Point(APlannerItem.ItemPos, APlannerItem.ItemBegin);
          FItemXYS := Rect(APlannerItem.ItemPos, APlannerItem.ItemBegin, APlannerItem.ItemEnd, 0);
          FMouseDownMove := not APlannerItem.FixedPos;
          FMouseStart := FMouseDownMove;
          if FMemo.Visible then
            FMemo.DoExit;
          HintShowXY(X, Y, APlannerItem.ItemSpanTimeStr);
          Exit;
        end;

        if (Y < GridRect.Top + 3) and not APlannerItem.Background and not
          APlannerItem.FixedSize then
        begin
          FItemXY := Point(APlannerItem.ItemPos, APlannerItem.ItemBegin);
          FItemXYS := Rect(APlannerItem.ItemPos, APlannerItem.ItemBegin, APlannerItem.ItemEnd, 0);
          FMouseDownSizeUp := not APlannerItem.FixedSize;
          FMouseStart := FMouseDownSizeUp;
          if FMemo.Visible then
            FMemo.DoExit;
          HintShowXY(X, Y, APlannerItem.ItemStartTimeStr);
          Exit;
        end;

        {
        if (Message.YPos + 5 > GridRect.Bottom + (APlannerItem.ItemEnd - APlannerItem.ItemBegin - 1) *
          DefaultRowHeight) and
          not APlannerItem.Background and not APlannerItem.FixedSize then
        }
        if (Y + 5 > GridRectE.Bottom)  and
          not APlannerItem.Background and not APlannerItem.FixedSize then
        begin
          FItemXY := Point(APlannerItem.ItemPos, APlannerItem.ItemEnd);
          FItemXYS := Rect(APlannerItem.ItemPos, APlannerItem.ItemBegin, APlannerItem.ItemEnd, 0);
          FMouseDownSizeDown := not APlannerItem.FixedSize;
          FMouseStart := FMouseDownSizeDown;
          HintShowXY(X, Y, APlannerItem.ItemEndTimeStr);
          if FMemo.Visible then
            FMemo.DoExit;
          Exit;
        end;


        if Assigned(FPlanner.PlannerImages) and
           Assigned(FPlanner.FOnItemImageClick) then
        begin
          if (Y > GridRect.Top) and (Y < GridRect.Top +
            FPlanner.PlannerImages.Height + 3) and
            ((APlannerItem.ImageID >= 0) or (APlannerItem.FImageIndexList.Count > 0)) then
          begin
            iw := FPlanner.PlannerImages.Width;

            if (X < GridRect.Left + ImgSize) and (iw > 0) then
            begin
              if (((X - GridRect.Left + 8) div iw) <=
                APlannerItem.FImageIndexList.Count) or (APlannerItem.ImageID >= 0) then
                FPlanner.FOnItemImageClick(FPlanner, APlannerItem, ((X - GridRect.Left
                  + 8) div iw) - 1);
            end;
            Exit;
          end;
        end;

        if APlannerItem.NotEditable and FPlanner.DirectMove and not APlannerItem.FixedPos then
        begin
          FItemXY := Point(APlannerItem.ItemPos, APlannerItem.ItemBegin);
          FItemXYS := Rect(APlannerItem.ItemPos, APlannerItem.ItemBegin, APlannerItem.ItemEnd, 0);
          FMouseDownMove := not APlannerItem.FixedPos;
          FMouseStart := FMouseDownMove;
          HintShowXY(X, Y, APlannerItem.ItemSpanTimeStr);
          Exit;
        end;

        if APlannerItem.NotEditable then
          Exit;

        GridRect := CellRectEx(APlannerItem.ItemPos + ColOffset, APlannerItem.ItemBegin);

        StartEditCol(GridRect, APlannerItem, X, Y);

      end
      else
        inherited;
    end
    else
    begin
      nplIt := FPlanner.Items.FocusItem(GridCoord.X - ColOffset, GridCoord.Y - RowOffset, Y -
        GridRect.Top, ssCtrl in Shift);

      if Assigned(nplIt) and (APlannerItem <> nplIt) then
      begin
        FPlanner.ItemSelected(nplIt);
        SetFocus;

        // Direct move handling or always move of readonly items
        if (FPlanner.DirectMove or nplIt.NotEditable) and not nplIt.FixedPos then
        begin
          FItemXY := Point(nplIt.ItemBegin, nplIt.ItemPos);
          FItemXYS := Rect(nplIt.ItemPos, nplIt.ItemBegin, nplIt.ItemEnd, 0);
          FMouseDownMove := not nplIt.FixedPos;
          FMouseStart := FMouseDownMove;
          if FMemo.Visible then
            FMemo.DoExit;
          HintShowXY(X, Y, nplIt.ItemSpanTimeStr);
        end;

        if FPlanner.EditDirect then
        begin
          APlannerItem := nplIt;
          APlannerItem.EnsureFullVisibility;
        end
        else
          Exit;
      end;

      if (APlannerItem = nplIt) and Assigned(APlannerItem) then
      begin

        GridRect := CellRectEx(APlannerItem.ItemBegin, APlannerItem.ItemPos + RowOffset);

        ImgSize := 0;

        if Assigned(FPlanner.PlannerImages) and
           ((APlannerItem.ImageID >= 0) or (APlannerItem.FImageIndexList.Count > 0)) then
          begin
            iw := FPlanner.PlannerImages.Width;
            ImgSize := 8 + (iw * APlannerItem.FImageIndexList.Count) + iw;
          end;

        APlannerItem.CalcConflictRect(GridRect, ColWidthEx(nplIt.ItemPos), RowHeightEx(RowOffset),
          FPlanner.Sidebar.Orientation = soVertical);

        if APlannerItem.Focus then
        begin
          s := ConcatenateTextStrings(APlannerItem.Text);

          r := CellRectEx(GridCoord.X, GridCoord.Y);

          APlannerItem.CalcConflictRect(r, ColWidthEx(nplIt.ItemPos), RowHeightEx(1),
            FPlanner.Sidebar.Orientation = soVertical);

          r.Top := r.Top + FPlanner.TrackWidth;
          r.Left := r.Left - ((GridCoord.X - APlannerItem.ItemBegin) * DefaultColWidth) + 4;
          r.Right := r.Right + ((APlannerItem.ItemEnd - GridCoord.X - 1) * DefaultColWidth) +
            4;

          if APlannerItem.CaptionType <> ctNone then
          begin
            tr := r;

            tr.Bottom := tr.Top + 16;

            if APlannerItem.Attachement <> '' then
            begin
              tr.Left := tr.Right - 16;

              if PtInRect(tr,Point(X,Y)) then
              begin
                AutoHandle := true;

                if Assigned(FPlanner.FOnItemAttachementClick) then
                  FPlanner.FOnItemAttachementCLick(FPlanner,APlannerItem,APlannerItem.Attachement,AutoHandle);
                if AutoHandle then
                  ShellExecute(0,'open',PChar(APlannerItem.Attachement),nil,nil,SW_NORMAL);

                Exit;
              end;

              tr.Right := tr.Right - 16;
            end;

            if APlannerItem.URL <> '' then
            begin
              tr.Left := tr.Right - 16;

              if PtInRect(tr,Point(X,Y)) then
              begin
                AutoHandle := true;

                if Assigned(FPlanner.FOnItemURLClick) then
                  FPlanner.FOnItemURLCLick(FPlanner,APlannerItem,APlannerItem.URL,AutoHandle);
                if AutoHandle then
                  ShellExecute(0,'open',PChar(APlannerItem.URL),nil,nil,SW_NORMAL);

                Exit;
              end;
            end;

            if (APlannerItem.CaptionType in [ctText,ctTimeText]) then
            begin
              if IsHtml(APlannerItem,APlannerItem.CaptionText) then

              if HTMLDrawEx(Canvas, APlannerItem.CaptionText, r, FPlanner.PlannerImages, X, Y,
                -1, -1, 1, True, False, False, True, True, False, APlannerItem.WordWrap
                ,False
                , 1.0, FPlanner.URLColor,
                clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
                , cr, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
                ) then

              begin
                if Assigned(FPlanner.FOnItemAnchorClick) then
                  FPlanner.FOnItemAnchorClick(FPlanner, APlannerItem, Anchor);
                Exit;
              end;

              r.Top := r.Top + APlannerItem.FCaptionHeight;
            end;
          end;

          if IsHtml(APlannerItem,s) then
          begin
            Canvas.Font := APlannerItem.Font;

            APlannerItem.CompletionAdapt(r);

            if HTMLDrawEx(Canvas, s, r, FPlanner.PlannerImages, X, Y,
              -1, -1, 1, True, False, False, True, True, False, APlannerItem.WordWrap
              ,False
              , 1.0, FPlanner.URLColor,
              clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
              , cr, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
              ) then

            begin
              if cr.Right <> 0 then
              begin
                OffsetRect(cr,-2,2);
                FormHandle(APlannerItem, cr, CID, CT, CV);

                If Assigned(FPlanner.FOnItemControlClick) then
                  FPlanner.FOnItemControlClick(Self,X,Y,APlannerItem,CID,CT,CV);

                InvalidateRect(Handle,@cr,False);
              end;
            
              if Assigned(FPlanner.FOnItemAnchorClick) then
                FPlanner.FOnItemAnchorClick(FPlanner, APlannerItem, Anchor);
              Exit;
            end;
          end;
        end;

        if ((Y < GridRect.Top + FPlanner.TrackWidth + 2) or
          ((Y > GridRect.Top + FPlanner.TrackWidth + 2) and (Y < GridRect.Top +
          APlannerItem.GetCaptionHeight) and (APlannerItem.ItemPos = GridCoord.Y - RowOffset) and
          (X > r.Left + ImgSize))) and
          not APlannerItem.Background and not APlannerItem.FixedPos then
        begin
          FItemXY := Point(APlannerItem.ItemBegin, APlannerItem.ItemPos);
          FItemXYS := Rect(APlannerItem.ItemPos, APlannerItem.ItemBegin, APlannerItem.ItemEnd, 0);
          FMouseDownMove := not APlannerItem.FixedPos;
          FMouseStart := FMouseDownMove;
          if FMemo.Visible then
            FMemo.DoExit;
          HintShowXY(X, Y, APlannerItem.ItemSpanTimeStr);
          Exit;
        end;

        if (X < GridRect.Left + 3) and not APlannerItem.Background and not
          APlannerItem.FixedSize then
        begin
          FItemXY := Point(APlannerItem.ItemBegin, APlannerItem.ItemPos);
          FItemXYS := Rect(APlannerItem.ItemPos, APlannerItem.ItemBegin, APlannerItem.ItemEnd, 0);
          FMouseDownSizeUp := not APlannerItem.FixedSize;
          FMouseStart := FMouseDownSizeUp;
          if FMemo.Visible then
            FMemo.DoExit;
          HintShowXY(X, Y, APlannerItem.ItemStartTimeStr);
          Exit;
        end;

        GridRect := CellRectEx(APlannerItem.ItemEnd -1, APlannerItem.ItemPos + RowOffset);

        if (X + 5 > GridRect.Right) and
          not APlannerItem.Background and not APlannerItem.FixedSize then
        begin
          FItemXY := Point(APlannerItem.ItemEnd, APlannerItem.ItemPos);
          FItemXYS := Rect(APlannerItem.ItemPos, APlannerItem.ItemBegin, APlannerItem.ItemEnd, 0);
          FMouseDownSizeDown := not APlannerItem.FixedSize;
          FMouseStart := FMouseDownSizeDown;
          HintShowXY(X, Y, APlannerItem.ItemEndTimeStr);
          if FMemo.Visible then
            FMemo.DoExit;
          Exit;
        end;

        if Assigned(FPlanner.PlannerImages) and
          Assigned(FPlanner.FOnItemImageClick) then
        begin
          if (X > r.Left) and (X < r.Left + ImgSize) and
            ((APlannerItem.ImageID >= 0) or (APlannerItem.FImageIndexList.Count > 0)) then
          begin
            iw := FPlanner.PlannerImages.Width;

            if (Y < GridRect.Top + 8 + (iw * APlannerItem.FImageIndexList.Count) + iw)
              and (iw > 0) then
            begin
              if (((Y - GridRect.Top + 8) div iw) <=
                APlannerItem.FImageIndexList.Count) or (APlannerItem.ImageID >= 0) then
                FPlanner.FOnItemImageClick(FPlanner, APlannerItem, ((Y - GridRect.Top
                  + 8) div iw) - 1);
            end;
            Exit;
          end;
        end;

        if nplIt.NotEditable and FPlanner.DirectMove then
        begin
          FItemXY := Point(nplIt.ItemBegin, nplIt.ItemPos);
          FItemXYS := Rect(nplIt.ItemPos, nplIt.ItemBegin, nplIt.ItemEnd, 0);
          FMouseDownMove := not nplIt.FixedPos;
          FMouseStart := FMouseDownMove;
          HintShowXY(X, Y, nplIt.ItemSpanTimeStr);
          Exit;
        end;

        if APlannerItem.Focus then
        begin
          s := ConcatenateTextStrings(APlannerItem.Text);

          GridRect := CellRectEx(GridCoord.X, GridCoord.Y);
          APlannerItem.CalcConflictRect(GridRect, ColWidthEx(nplIt.ItemPos), RowHeightEx(1),
            FPlanner.Sidebar.Orientation = soVertical);

          GridRect.Top := GridRect.Top + FPlanner.TrackWidth;
          GridRect.Left := GridRect.Left - ((GridCoord.X - APlannerItem.ItemBegin) * DefaultColWidth) + 4;
          GridRect.Right := GridRect.Right + ((APlannerItem.ItemEnd - GridCoord.X - 1) * DefaultColWidth) +
            4;

          if (APlannerItem.CaptionType <> ctNone) then
            GridRect.Top := GridRect.Top + APlannerItem.FCaptionHeight;

          if IsHtml(APlannerItem,s) then
          begin
            Canvas.Font := APlannerItem.Font;

            APlannerItem.CompletionAdapt(GridRect);

            if HTMLDrawEx(Canvas, s, GridRect, FPlanner.PlannerImages, X, Y,
              -1, -1, 1, True, False, False, True, True, False, APlannerItem.WordWrap
              ,False
              , 1.0, FPlanner.URLColor,
              clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
              ,cr, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
              ) then

            begin
              if Assigned(FPlanner.FOnItemAnchorClick) then
                FPlanner.FOnItemAnchorClick(FPlanner, APlannerItem, Anchor);
            end;
          end;
        end;

        if APlannerItem.NotEditable then
          Exit;

        GridRect := CellRectEx(APlannerItem.ItemBegin, APlannerItem.ItemPos + RowOffset);

        StartEditRow(GridRect, APlannerItem, X, Y);

      end
      else
        inherited;
    end;
  end;

  if OrigButton = mbRight then
  begin
    ColOffset := FPlanner.FSidebar.FColOffset;
    RowOffset := FPlanner.FSidebar.FRowOffset;

    if FMouseDownMove or
      FMouseDownSizeUp or
      FMouseDownSizeDown then
      Exit;

    GridCoord := MouseCoord(X, Y);
    GridRect := CellRectEx(GridCoord.X, GridCoord.Y);

    if FPlanner.Sidebar.Orientation = soVertical then
      APlannerItem := FPlanner.Items.FindItemPos(GridCoord.Y - RowOffset, GridCoord.X - ColOffset, X
        - GridRect.Left)
    else
      APlannerItem := FPlanner.Items.FindItemPos(GridCoord.X - ColOffset, GridCoord.Y - RowOffset, Y
        - GridRect.Top);

    if not Assigned(APlannerItem) or
       ( (FPlanner.Sidebar.Orientation = soVertical) and (X > GridRect.Right - FPlanner.FItemGap)) or
       ( (FPlanner.Sidebar.Orientation = soHorizontal) and (Y > GridRect.Bottom - FPlanner.FItemGap)) then
    begin
      if Assigned(FPlanner.FOnPlannerRightClick) then
      begin
        if FPlanner.Sidebar.Orientation = soVertical then
        begin
          FromSel := Selection.Top + FPlanner.Display.DisplayStart;
          ToSel := 1 + Selection.Bottom + FPlanner.Display.DisplayStart;
          FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;

          FPlanner.FOnPlannerRightClick(FPlanner, Col - ColOffset, FromSel,
            FromSelPrecis, ToSel, ToSelPrecis);
        end
        else
        begin
          FromSel := Selection.Left + FPlanner.Display.DisplayStart;
          ToSel := 1 + Selection.Right + FPlanner.Display.DisplayStart;
          FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          FPlanner.FOnPlannerRightClick(FPlanner, Row - RowOffset, FromSel,
            FromSelPrecis, ToSel, ToSelPrecis);
        end;
      end;
    end;

    if Assigned(APlannerItem) then
    begin
      ScreenPoint := ClientToScreen(Point(X, Y));

      if Assigned(FPlanner.OnItemRightClick) then
        FPlanner.OnItemRightClick(FPlanner, APlannerItem);

      if Assigned(APlannerItem.PopupMenu) then
      begin
        if Assigned(FPlanner.OnItemPopupPrepare) then
          FPlanner.OnItemPopupPrepare(FPlanner, APlannerItem.PopupMenu, APlannerItem);

        FPlanner.PopupPlannerItem := APlannerItem;
        APlannerItem.PopupMenu.PopupComponent := Self;
        APlannerItem.PopupMenu.Popup(ScreenPoint.X, ScreenPoint.Y);
      end;

      if (Assigned(FPlanner.FItemPopup)) then
      begin
        if Assigned(FPlanner.OnItemPopupPrepare) then
          FPlanner.OnItemPopupPrepare(FPlanner, FPlanner.ItemPopup, APlannerItem);

        FPlanner.PopupPlannerItem := APlannerItem;
        FPlanner.ItemPopup.PopupComponent := Self;
        FPlanner.FItemPopup.Popup(ScreenPoint.X, ScreenPoint.Y);
      end;
    end;

    if (Assigned(FPlanner.FGridPopup)) and (APlannerItem = nil) then
    begin
      ScreenPoint := ClientToScreen(Point(X, Y));
      FPlanner.PopupPlannerItem := nil;
      FPlanner.GridPopup.PopupComponent := Self;
      FPlanner.GridPopup.Popup(ScreenPoint.X, ScreenPoint.Y);
    end;
  end;
end;



procedure TPlannerGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    ReleaseCapture;

  if FCurrCtrlR.Right <> 0 then
    InvalidateRect(Handle,@FCurrCtrlR,False);

  inherited;

  if Assigned(FPlanner.FOnPlannerMouseUp) then
  begin
    FPlanner.FOnPlannerMouseUp(FPlanner, Button, Shift, X, Y);
  end;

  if Button = mbLeft then
  begin

    with FPlanner.Items do
    begin
      if Assigned(Selected) then
      begin

        if FMouseDownMove then
        begin
          HintHide;
          if (FItemXYS.Top <> Selected.ItemBegin) or (FItemXYS.Left <> Selected.ItemPos)
            or (FItemXYS.Right <> Selected.ItemEnd)
            or (Selected.BeginOffset <> 0) or (Selected.EndOffset <> 0) then
            FPlanner.ItemMoved(FItemXYS.Top, FItemXYS.Right, FItemXYS.Left,
              Selected.ItemBegin, Selected.ItemEnd, Selected.ItemPos);
        end;

        if FMouseDownSizeUp then
        begin
          HintHide;
          FPlanner.ItemSized(FItemXYS.Top, FItemXYS.Right,
                             Selected.ItemBegin, Selected.ItemEnd);
        end;
        
        if FMouseDownSizeDown then
        begin
          HintHide;
          FPlanner.ItemSized(FItemXYS.Top, FItemXYS.Right,
                             Selected.ItemBegin, Selected.ItemEnd);
        end;
      end;
    end;

    FMouseDown := False;
    FMouseDownMove := False;
    FMouseDownSizeUp := False;
    FMouseDownSizeDown := False;
  end;
end;

procedure TPlannerGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  GridCoord: TGridCoord;
  cr, r, tr, ir, hr, cor: TRect;
  APlannerItem: TPlannerItem;
  dx, dy, h: Integer;
  s, Anchor, StrippedHtmlString, FocusAnchor: string;
  XSize, YSize, ml, hl: Integer;
  ColOffset, RowOffset: Integer;
//  ShiftState: TShiftState;
  Allow: Boolean;
  MaxCol: Integer;
  ImgSize: Integer;
  NoClip: Boolean;
  SideCorr: Integer;
  CID, CV, CT: string;

begin
  ColOffset := FPlanner.FSidebar.FColOffset;
  RowOffset := FPlanner.FSidebar.FRowOffset;
  GridCoord := MouseCoord(x,y);
  NoClip := (FPlanner.Mode.PlannerType in [plDay, plDayPeriod, plMonth, plHalfDayPeriod, plWeek,plTimeLine]) and
            not FPlanner.Mode.Clip;

  if FPlanner.SideBar.Visible and
     (FPlanner.SideBar.Position in [spLeft,spTop]) then
    SideCorr := 1
  else
    SideCorr := 0;

  if FScrolling then
  begin
    if GettickCount - FScrollTime > FPlanner.FScrollDelay then
      FScrolling := False;
    Inherited;
    Exit;
  end;

  FScrollTime := GetTickCount;

  if (ssCtrl in Shift)
     or (GetKeystate(VK_MENU) and $8000 = $8000)
  then
  begin
    if FMouseDownMove and FPlanner.DragItem and Assigned(FPlanner.Items.Selected)
       and not FPlanner.Dragging then
    begin
      Allow := True;

      if Assigned(FPlanner.OnItemDrag) then
        FPlanner.OnItemDrag(FPlanner,FPlanner.Items.Selected, Allow);

      if Allow then
      begin
        inherited;
        HintHide;
        FPlanner.BeginDrag(True{$IFDEF DELPHI4_LVL},-1{$ENDIF});
        FMouseDownMove := False;
        Exit;
      end;
    end;
  end;

 { Handles vertical planner mode }
  if FPlanner.Sidebar.Orientation = soVertical then
  begin
    if FMouseDownMove and Assigned(FPlanner.Items.Selected) then
    begin
      dy := (Y - FMouseXY.Y) div DefaultRowHeight;
      dx := (GridCoord.X - ColOffset - FItemXY.X);

      if FPlanner.Items.Selected.FixedPosition then
        dx := 0;

      case FPlanner.SideBar.Position of
      spLeft: MaxCol := ColCount - 1;
      spRight: MaxCol := ColCount - 2;
      spLeftRight: MaxCol := ColCount - 3
      else
        MaxCol := ColCount - 1;
      end;

      if not FPlanner.SideBar.Visible then
        MaxCol := ColCount - 1;

      with FPlanner.Items.Selected do
      begin
        h := ItemEnd - ItemBegin + BeginOffset + EndOffset;

        if ((ItemBegin <> FItemXY.Y + dy) or (ItemPos <> FItemXY.X + dx)) and
           (FItemXY.X + dx >= 0) and not
           FPlanner.Items.HasItem(FItemXY.Y + dy, FItemXY.Y + dy + h, FItemXY.X + dx) and
           (((FItemXY.Y + dy + h <= RowCount) and (FItemXY.Y + dy >= 0)) or NoClip) and
           (FItemXY.X + dx <= MaxCol) then
        begin
          Allow := True;

          if Assigned(FPlanner.FOnItemMoving) then
            FPlanner.FOnItemMoving(FPlanner, FPlanner.Items.Selected, (FItemXY.Y
              + dy) - ItemBegin, (FItemXY.X + dx) - ItemPos, Allow);

          if not Allow then
          begin
            SendMessage(Handle,WM_LBUTTONUP,0,0);
            Exit;
          end;

          ir := FPlanner.Items.Selected.GetGridRect;
          FPlanner.Items.BeginUpdate;
          MoveItem(FItemXY.Y + dy, FItemXY.Y + dy + h, FItemXY.X + dx, FItemXY.Y);
          FPlanner.Items.ResetUpdate;

          FPlanner.FGrid.InvalidateCellRect(ir);
          FPlanner.Items.Selected.Repaint;

          // Check here if scroll required
          if (ItemEnd - TopRow >= VisibleRowCount) and (TopRow + VisibleRowCount
            < RowCount) then
          begin
            TopRow := TopRow + 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;
            FMouseXY.Y := FMouseXY.Y - DefaultRowHeight;
          end;

          if (ItemBegin <= TopRow) and (TopRow > 0) then
          begin
            TopRow := TopRow - 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;
            FMouseXY.Y := FMouseXY.Y + DefaultRowHeight;
          end;

          if FPlanner.ScrollSmooth then
          begin
            if (ItemPos + SideCorr <= LeftCol) and (LeftCol > SideCorr) then
            begin
              LeftCol := LeftCol - 1;
              FScrolling := True;
            end;

            if (ItemPos + SideCorr >= VisibleColCount + LeftCol) and
               (LeftCol + VisibleColCount < ColCount) then
            begin
              LeftCol := LeftCol + 1;
              FScrolling := True;
            end;
          end;

          HintShowXY(X, Y,
            FPlanner.Items.Selected.ItemSpanTimeStr);
        end;
      end;
      Exit;
    end;

    if FMouseDownSizeUp and Assigned(FPlanner.Items.Selected) then
    begin
      dy := (Y - FMouseXY.Y) div DefaultRowHeight;
      with FPlanner.Items.Selected do
      begin
        if (ItemBegin <> FItemXY.Y + dy) and
           (FItemXY.Y + dy >= 0) and
           (FItemXY.Y + dy < ItemEnd) and not FPlanner.Items.HasItem(FItemXY.Y +
            dy, ItemEnd, ItemPos) then
        begin
          Allow := True;

          if Assigned(FPlanner.FOnItemSizing) then
            FPlanner.FOnItemSizing(FPlanner, FPlanner.Items.Selected, FItemXY.Y
              + dy - ItemBegin, 0, Allow);

          if not Allow then
            Exit;

          ir := FPlanner.Items.Selected.GetGridRect;
          FPlanner.Items.BeginUpdate;
          SizeItem(FItemXY.Y + dy, ItemEnd);
          FPlanner.Items.ResetUpdate;

          FPlanner.FGrid.InvalidateCellRect(ir);
          FPlanner.Items.Selected.Repaint;


          { Check here if scroll required }
          if (ItemBegin <= TopRow) and (TopRow > 0) then
          begin
            TopRow := TopRow - 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;

            FMouseXY.Y := FMouseXY.Y + DefaultRowHeight;
          end;
          HintShowXY(X, Y,
            FPlanner.Items.Selected.ItemStartTimeStr);
        end;
      end;
      Exit;
    end;

    if FMouseDownSizeDown and Assigned(FPlanner.Items.Selected) then
    begin
      dy := (Y - FMouseXY.Y) div DefaultRowHeight;
      with FPlanner.Items.Selected do
      begin

        if ((ItemEnd <> FItemXY.Y + dy)) and
           (FItemXY.Y + dy >= 0) and (FItemXY.Y + dy <= RowCount) and
           (FItemXY.Y + dy > ItemBegin) and not FPlanner.Items.HasItem(ItemBegin,
            FItemXY.Y + dy, ItemPos) then
        begin
          Allow := True;

          if Assigned(FPlanner.FOnItemSizing) then
            FPlanner.FOnItemSizing(FPlanner, FPlanner.Items.Selected, 0,
              FItemXY.Y + dy - ItemEnd, Allow);

          if not Allow then
            Exit;

          ir := FPlanner.Items.Selected.GetGridRect;
          FPlanner.Items.BeginUpdate;
          SizeItem(ItemBegin, FItemXY.Y + dy);

          FPlanner.Items.ResetUpdate;
          FPlanner.FGrid.InvalidateCellRect(ir);
          FPlanner.Items.Selected.Repaint;

          { Check here if scroll required }
          if (ItemEnd - TopRow >= VisibleRowCount) and (TopRow + VisibleRowCount
            < RowCount) then
          begin
            TopRow := TopRow + 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;

            FMouseXY.Y := FMouseXY.Y - DefaultRowHeight;
          end;
          HintShowXY(X,Y, FPlanner.Items.Selected.ItemEndTimeStr);
        end;
      end;
      Exit;
    end;
  end
  else

 { Handles horizontal planner mode }
  begin
    if FMouseDownMove and Assigned(FPlanner.Items.Selected) then
    begin
      dx := (X - FMouseXY.X) div DefaultColWidth;
      dy := (GridCoord.Y - RowOffset - FItemXY.Y);

      if FPlanner.Items.Selected.FixedPosition then
        dy := 0;

      {$IFDEF TMSDEBUG}
      outputdebugstring(pchar('dx:'+inttostr(dx)));
      {$ENDIF}

      with FPlanner.Items.Selected do
      begin
        h := ItemEnd - ItemBegin;
        if ((ItemBegin <> FItemXY.X + dx) or (ItemPos <> FItemXY.Y + dy)) and
           (FItemXY.Y + dy >= 0) and not FPlanner.Items.HasItem(FItemXY.X + dx,
            FItemXY.X + dx + h, FItemXY.Y + dy) and
           (((FItemXY.X + dx + h <= ColCount) and (FItemXY.X + dx >= 0)) or NoClip) then
        begin
          Allow := True;

          if Assigned(FPlanner.FOnItemMoving) then
            FPlanner.FOnItemMoving(FPlanner, FPlanner.Items.Selected, (FItemXY.X
              + dx) - ItemBegin, (FItemXY.Y + dy) - ItemPos, Allow);

          if not Allow then
          begin
            SendMessage(Handle,WM_LBUTTONUP,0,0);
            Exit;
          end;

          ir := FPlanner.Items.Selected.GetGridRect;
          FPlanner.Items.BeginUpdate;
          MoveItem(FItemXY.X + dx,FItemXY.X + dx + h,FItemXY.Y + dy, FItemXY.X);
          FPlanner.Items.ResetUpdate;

          FPlanner.FGrid.InvalidateCellRect(ir);
          FPlanner.Items.Selected.Repaint;

          { Check here if scroll required }
          if (ItemEnd - LeftCol >= VisibleColCount) and
             (LeftCol + VisibleColCount < ColCount) then
          begin
            LeftCol := LeftCol + 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;
            FMouseXY.X := FMouseXY.X - DefaultColWidth;
          end;

          if (ItemBegin <= LeftCol) and (LeftCol > 0) then
          begin
            LeftCol := LeftCol - 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;
            FMouseXY.X := FMouseXY.X + DefaultColWidth;
          end;

          if (ItemPos - TopRow + SideCorr >= VisibleRowCount) and
             (TopRow + VisibleRowCount < RowCount) then
          begin
            TopRow := TopRow + 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;
            FMouseXY.Y := FMouseXY.Y + DefaultRowHeight;
          end;

          if (ItemPos + SideCorr <= TopRow) and (TopRow > SideCorr) then
          begin
            TopRow := TopRow - 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;
            FMouseXY.Y := FMouseXY.Y - DefaultRowHeight;
          end;

          HintShowXY(X, Y, FPlanner.Items.Selected.ItemSpanTimeStr);
        end;
      end;
      Exit;
    end;

    if FMouseDownSizeUp and Assigned(FPlanner.Items.Selected) then
    begin
      dx := (X - FMouseXY.X) div DefaultColWidth;

      with FPlanner.Items.Selected do
      begin
        if (ItemBegin <> FItemXY.X + dx) and
           (FItemXY.X + dx >= 0) and
           (FItemXY.X + dx < ItemEnd) and not FPlanner.Items.HasItem(FItemXY.X +
            dx, ItemEnd, ItemPos) then
        begin
          Allow := True;

          if Assigned(FPlanner.FOnItemSizing) then
            FPlanner.FOnItemSizing(FPlanner, FPlanner.Items.Selected, (FItemXY.X
              + dx) - ItemBegin, 0, Allow);

          if not Allow then
            Exit;

          ir := FPlanner.Items.Selected.GetGridRect;
          FPlanner.Items.BeginUpdate;
          SizeItem(FItemXY.X + dx, ItemEnd);
          FPlanner.Items.ResetUpdate;
          FPlanner.FGrid.InvalidateCellRect(ir);
          FPlanner.Items.Selected.Repaint;

          { Check here if scroll required }
          if (ItemBegin <= LeftCol) and (LeftCol > 0) then
          begin
            LeftCol := LeftCol - 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;

            FMouseXY.X := FMouseXY.X + DefaultColWidth;
          end;
          HintShowXY(X, Y, FPlanner.Items.Selected.ItemStartTimeStr);
        end;
      end;
      Exit;
    end;

    if FMouseDownSizeDown and Assigned(FPlanner.Items.Selected) then
    begin
      dx := (X - FMouseXY.X) div DefaultColWidth;
      with FPlanner.Items.Selected do
      begin
        if ((ItemEnd <> FItemXY.X + dx)) and
           (FItemXY.X + dx >= 0) and (FItemXY.X + dx <= ColCount) and
           (FItemXY.X + dx > ItemBegin) and not FPlanner.Items.HasItem(ItemBegin,
            FItemXY.X + dx, ItemPos) then
        begin
          Allow := True;

          if Assigned(FPlanner.FOnItemSizing) then
            FPlanner.FOnItemSizing(FPlanner, FPlanner.Items.Selected, 0,
              (FItemXY.X + dx) - ItemEnd, Allow);

          if not Allow then
            Exit;

          ir := FPlanner.Items.Selected.GetGridRect;
          FPlanner.Items.BeginUpdate;
          SizeItem(ItemBegin, FItemXY.X + dx);
          FPlanner.Items.ResetUpdate;
          FPlanner.FGrid.InvalidateCellRect(ir);
          FPlanner.Items.Selected.Repaint;


          { Check here if scroll required }
          if (ItemEnd - LeftCol >= VisibleColCount) and (LeftCol +
            VisibleColCount < ColCount) then
          begin
            LeftCol := LeftCol + 1;
            if FPlanner.ScrollSmooth then
              FScrolling := True;
            
            FMouseXY.X := FMouseXY.X - DefaultColWidth;
          end;
          HintShowXY(X, Y, FPlanner.Items.Selected.ItemEndTimeStr);
        end;
      end;
      Exit;
    end;
  end;

  inherited;

  if FMouseDown then
    SelChanged;


  if Assigned(FPlanner.FOnPlannerMouseMove) then
  begin
    FPlanner.FOnPlannerMouseMove(FPlanner, Shift, X, Y);
  end;

  CorrectSelection;

  if (FLastHintPos.X <> -1) then
    if (GridCoord.X <> FLastHintPos.X) or (GridCoord.Y <> FLastHintPos.Y) then
    begin
      Application.CancelHint;
      FLastHintPos := Point(-1, -1);
    end;

  cr := CellRectEx(GridCoord.X, GridCoord.Y);

  if FPlanner.Sidebar.Orientation = soVertical then
  begin
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.Y, GridCoord.X - ColOffset, X -
      cr.Left);

    if Assigned(APlannerItem) and (APlannerItem = FPlanner.Items.Selected) then
    begin
      APlannerItem.CalcConflictRect(cr, ColWidthEx(APlannerItem.ItemPos), RowHeightEx(1),
        FPlanner.Sidebar.Orientation = soVertical);

      ImgSize := 0;

      if APlannerItem.Focus then
      begin
        s := ConcatenateTextStrings(APlannerItem.Text);

        r := cr;
        r.Left := r.Left + FPlanner.TrackWidth;
        r.Top := r.Top - ((GridCoord.Y - APlannerItem.ItemBegin) * DefaultRowHeight) + 4;
        r.Bottom := r.Bottom + ((APlannerItem.ItemEnd - GridCoord.Y - 1) * DefaultRowHeight)
          + 4;

        if Assigned(FPlanner.PlannerImages) and
           ((APlannerItem.ImageID >= 0) or (APlannerItem.FImageIndexList.Count > 0)) then
          begin
            ImgSize := FPlanner.PlannerImages.Width;
            ImgSize := 8 + (ImgSize * APlannerItem.FImageIndexList.Count) + ImgSize;
          end;

        if (APlannerItem.CaptionType <> ctNone) then
        begin
          tr := r;

          tr.Bottom := tr.Top + 16;

          if APlannerItem.Attachement <> '' then
          begin
            tr.Left := tr.Right - 16;

            if PtInRect(tr,Point(X,Y)) then
            begin
              if Self.Cursor <> crHandPoint then
              begin
                Self.Cursor := crHandPoint;
              end;
              Exit;
            end;

            tr.Right := tr.Right - 16;
          end;

          if APlannerItem.URL <> '' then
          begin
            tr.Left := tr.Right - 16;

            if PtInRect(tr,Point(X,Y)) then
            begin
              if Self.Cursor <> crHandPoint then
              begin
                Self.Cursor := crHandPoint;
              end;
              Exit;
            end;
          end;

          if APlannerItem.CaptionType in [ctText,ctTimeText] then
          begin
            if IsHtml(APlannerItem,APlannerItem.CaptionText) then
            begin
             Canvas.Font := APlannerItem.CaptionFont;

             if HTMLDrawEx(Canvas, APlannerItem.CaptionText, r, FPlanner.PlannerImages, X, Y,
               -1, -1, 1, True, False, False, True, True, False, APlannerItem.WordWrap
               , False
               , 1.0, FPlanner.URLColor,
               clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
               ,cor, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
               ) then

             begin
               if Self.Cursor <> crHandPoint then
               begin
                 Self.Cursor := crHandPoint;
                 if Assigned(FPlanner.OnItemAnchorEnter) then
                   FPlanner.OnItemAnchorEnter(FPlanner, APlannerItem, Anchor);
               end;
               Exit;
             end
             else if Self.Cursor = crHandPoint then
             begin
               if Assigned(FPlanner.OnItemAnchorExit) then
                 FPlanner.OnItemAnchorExit(FPlanner, APlannerItem, Anchor);
             end;

            end;
          end;
          r.Top := r.Top + APlannerItem.FCaptionHeight;
        end;

        if IsHtml(APlannerItem,s) then
        begin
          Canvas.Font := APlannerItem.Font;

          APlannerItem.CompletionAdapt(r);
          if HTMLDrawEx(Canvas, s, r, FPlanner.PlannerImages, X, Y,
            -1, -1, 1, True, False, False, True, True, False, APlannerItem.WordWrap
            , False
            , 1.0, FPlanner.URLColor,
            clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
            , cor, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
            ) then

          begin
            if (Self.Cursor <> crHandPoint)
             or (CID <> FCurrCtrlID)
            then
            begin
              Self.Cursor := crHandPoint;

              if (cor.Right <> 0) and IsWinXP then
              begin
                if FCurrCtrlR.Right <> 0 then
                  InvalidateRect(Handle,@FCurrCtrlR,false);

                {$IFDEF TMSDEBUG}
                outputdebugstring('control hot');
                {$ENDIF}
                FCurrCtrlID := CID;
                FCurrCtrlR := cor;
                InvalidateRect(Handle,@cor,false);
              end;

              if Assigned(FPlanner.OnItemAnchorEnter) then
                FPlanner.OnItemAnchorEnter(FPlanner, APlannerItem, Anchor);
            end;
            Exit;
          end
          else
          if (Self.Cursor = crHandPoint)
             or (CID <> FCurrCtrlID)
            then
          begin
            if (FCurrCtrlR.Right <> 0) and IsWinXP then
            begin
              {$IFDEF TMSDEBUG}
              outputdebugstring(pchar('control cold:'+inttostr(fcurrctrlr.Right)));
              {$ENDIF}

              InvalidateRect(Handle,@FCurrCtrlR,false);
              if CID = '' then
                FCurrCtrlR := Rect(0,0,0,0)
              else
                FCurrCtrlR := cor;

              FCurrCtrlID := CID;
            end;
            if Assigned(FPlanner.OnItemAnchorExit) then
              FPlanner.OnItemAnchorExit(FPlanner, APlannerItem, Anchor);
          end;
        end;
      end;

      if (((X > cr.Left) and (X < cr.Left + FPlanner.TrackWidth)) or
        ((Y > cr.Top + 3) and (Y < cr.Top +
        APlannerItem.GetCaptionHeight) and (APlannerItem.ItemBegin = GridCoord.Y) and
        (X > cr.Left + ImgSize))) and
        not APlannerItem.FixedPos then
      begin
{$IFNDEF DELPHI4_LVL}
        Self.Cursor := crCross;
{$ENDIF}
{$IFDEF DELPHI4_LVL}
        if APlannerItem.Cursor = crNone then
           Self.Cursor := crSizeAll
        else
           self.cursor := APlannerItem.Cursor;
{$ENDIF}
        FSelItem := APlannerItem;
        Exit;
      end;

      if APlannerItem.Focus and (APlannerItem.ItemBegin = GridCoord.Y) and
        (Y < cr.Top + 3) and not APlannerItem.FixedSize then
      begin
        if APlannerItem.cursor = crNone then
           self.Cursor := crSizeNS
        else
           self.Cursor := APlannerItem.cursor;

        FSelItem := APlannerItem;
        Exit;
      end;

      if APlannerItem.Focus and (APlannerItem.ItemEnd - 1 = GridCoord.Y) and
        (Y > cr.Bottom - 5) and not APlannerItem.FixedSize then
      begin
        if APlannerItem.cursor = crNone then
           self.Cursor := crSizeNS
        else
           self.Cursor := APlannerItem.Cursor;

        FSelItem := APlannerItem;
        Exit;
      end;

      if APlannerItem.Focus and
         APlannerItem.NotEditable and
         FPlanner.DirectMove and
         not APlannerItem.BackGround and not APlannerItem.FixedPos then
      begin
{$IFNDEF DELPHI4_LVL}
        Self.Cursor := crCross;
{$ENDIF}
{$IFDEF DELPHI4_LVL}
        if APlannerItem.Cursor = crNone then
           self.Cursor := crSizeAll
        else
           self.Cursor := APlannerItem.Cursor;
{$ENDIF}
        FSelItem := APlannerItem;
        Exit;
      end;
    end
    else
      if Assigned(APlannerItem) then
        if (APlannerItem.Cursor <> crNone) and FPlanner.DirectMove then
        begin
          Self.Cursor := APlannerItem.Cursor;
          Exit;
        end;
  end
  else
  begin
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.X - ColOffset, GridCoord.Y - RowOffset, Y
      - cr.Top);

    if Assigned(APlannerItem) and (APlannerItem = FPlanner.Items.Selected) then
    begin

      APlannerItem.CalcConflictRect(cr, ColWidthEx(APlannerItem.ItemPos), RowHeightEx(1),
        FPlanner.Sidebar.Orientation = soVertical);

      ImgSize := 0;

      if APlannerItem.Focus then
      begin
        s := ConcatenateTextStrings(APlannerItem.Text);

        r := cr;

        r.Top := r.Top + FPlanner.TrackWidth;
        r.Left := r.Left - ((GridCoord.X - APlannerItem.ItemBegin) * DefaultColWidth) + 4;
        r.Right := r.Right + ((APlannerItem.ItemEnd - GridCoord.X - 1) * DefaultColWidth) +
          4;

        if Assigned(FPlanner.PlannerImages) and
           ((APlannerItem.ImageID >= 0) or (APlannerItem.FImageIndexList.Count > 0)) then
          begin
            ImgSize := FPlanner.PlannerImages.Width;
            ImgSize := 8 + (ImgSize * APlannerItem.FImageIndexList.Count) + ImgSize;
          end;

        if (APlannerItem.CaptionType <> ctNone) then
        begin
          tr := r;

          tr.Bottom := tr.Top + 16;

          if APlannerItem.Attachement <> '' then
          begin
            tr.Left := tr.Right - 16;

            if PtInRect(tr,Point(X,Y)) then
            begin
              if Self.Cursor <> crHandPoint then
              begin
                Self.Cursor := crHandPoint;
              end;
              Exit;
            end;

            tr.Right := tr.Right - 16;
          end;

          if APlannerItem.URL <> '' then
          begin
            tr.Left := tr.Right - 16;

            if PtInRect(tr,Point(X,Y)) then
            begin
              if Self.Cursor <> crHandPoint then
              begin
                Self.Cursor := crHandPoint;
              end;
              Exit;
            end;
          end;

          if (APlannerItem.CaptionType in [ctText,ctTimeText]) then
          begin
            if IsHtml(APlannerItem,APlannerItem.CaptionText) then
            begin
             Canvas.Font := APlannerItem.CaptionFont;

             if HTMLDrawEx(Canvas, APlannerItem.CaptionText, r, FPlanner.PlannerImages, X, Y,
               -1, -1, 1, True, False, False, True, True, False, APlannerItem.WordWrap
               , False
               , 1.0, FPlanner.URLColor,
               clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
               , cor, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
               ) then

             begin
               if (Self.Cursor <> crHandPoint) then
               begin
                 Self.Cursor := crHandPoint;
                 if Assigned(FPlanner.OnItemAnchorEnter) then
                   FPlanner.OnItemAnchorEnter(FPlanner, APlannerItem, Anchor);
               end;
               Exit;
             end
             else if (Self.Cursor = crHandPoint) then
             begin
               if Assigned(FPlanner.OnItemAnchorExit) then
                 FPlanner.OnItemAnchorExit(FPlanner, APlannerItem, Anchor);
             end;

            end;
          end;
          r.Top := r.Top + APlannerItem.FCaptionHeight;
        end;

        if IsHtml(APlannerItem,s) then
        begin
          Canvas.Font := APlannerItem.Font;

          APlannerItem.CompletionAdapt(r);

          if HTMLDrawEx(Canvas, s, r, FPlanner.PlannerImages, X, Y,
            -1, -1, 1, True, False, False, True, True, False, APlannerItem.WordWrap
            , False
            , 1.0, FPlanner.URLColor,
            clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor, XSize, YSize, ml, hl, hr
            , cor, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
            ) then

          begin
            if (Self.Cursor <> crHandPoint)
              or (CID <> FCurrCtrlID)
            then

            begin
              Self.Cursor := crHandPoint;

              if (cor.Right <> 0) and IsWinXP then
              begin
                if FCurrCtrlR.Right <> 0 then
                  InvalidateRect(Handle,@FCurrCtrlR,False);
                InflateRect(cor,0,2);
                FCurrCtrlID := CID;
                FCurrCtrlR := cor;

                InvalidateRect(Handle,@cor,False);
              end;

              if Assigned(FPlanner.OnItemAnchorEnter) then
                FPlanner.OnItemAnchorEnter(FPlanner, APlannerItem, Anchor);
            end;
            Exit;
          end
          else
          if (Self.Cursor = crHandPoint)
             or (CID <> FCurrCtrlID)
          then
          begin
            if (FCurrCtrlR.Right <> 0) and IsWinXP then
            begin
              InflateRect(FCurrCtrlR,0,2);

              InvalidateRect(Handle,@FCurrCtrlR,False);
              if CID = '' then
                FCurrCtrlR := Rect(0,0,0,0)
              else
                FCurrCtrlR := cor;

              FCurrCtrlID := CID;
            end;

            if Assigned(FPlanner.OnItemAnchorExit) then
              FPlanner.OnItemAnchorExit(FPlanner, APlannerItem, Anchor);
          end;
        end;
      end;

      if (((Y > cr.Top) and (Y < cr.Top + FPlanner.TrackWidth)) or
        ((Y > cr.Top + 3) and (Y < cr.Top +
        APlannerItem.GetCaptionHeight) and (APlannerItem.ItemPos = GridCoord.Y - RowOffset) and
        (X > r.Left + ImgSize))) and
        not APlannerItem.FixedPos then
      begin
{$IFNDEF DELPHI4_LVL}
        Self.Cursor := crCross;
{$ENDIF}
{$IFDEF DELPHI4_LVL}
        if APlannerItem.Cursor = crNone then
           Self.Cursor := crSizeAll
        else
           self.Cursor := APlannerItem.Cursor;
{$ENDIF}
        FSelItem := APlannerItem;
        Exit;
      end;

      if APlannerItem.Focus and (APlannerItem.ItemBegin = GridCoord.X) and
        (X < cr.Left + 3) and not APlannerItem.FixedSize then
      begin
        if APlannerItem.cursor = crNone then
           Self.Cursor := crSizeWE
        else
           self.Cursor := APlannerItem.Cursor;

        FSelItem := APlannerItem;
        Exit;
      end;

      if APlannerItem.Focus and (APlannerItem.ItemEnd - 1 = GridCoord.X) and
        (X > cr.Right - 5) and not APlannerItem.FixedSize then
      begin
        if APlannerItem.cursor = crNone then
           Self.Cursor := crSizeWE
        else
           self.Cursor := APlannerItem.Cursor;

        FSelItem := APlannerItem;
        Exit;
      end;

      if APlannerItem.Focus and
         APlannerItem.NotEditable and
         FPlanner.DirectMove and
         not APlannerItem.Background and not APlannerItem.FixedPos then
      begin
{$IFNDEF DELPHI4_LVL}
        Self.Cursor := crCross;
{$ENDIF}
{$IFDEF DELPHI4_LVL}
        if APlannerItem.Cursor = crNone then
           Self.Cursor := crSizeAll
        else
           self.Cursor := APlannerItem.Cursor;
{$ENDIF}
        FSelItem := APlannerItem;
        Exit;
      end;
    end
    else
      if Assigned(APlannerItem) then
        if (APlannerItem.Cursor <> crNone) and FPlanner.DirectMove then
        begin
          Self.Cursor := APlannerItem.Cursor;
          Exit;
        end;
  end;

  if not FMouseDown then
    FSelItem := nil;

  if (Self.Cursor <> crDefault) then
  begin
    if (FCurrCtrlR.Right <> 0) and IsWinXP then
    begin
      InvalidateRect(Handle,@FCurrCtrlR,False);
      FCurrCtrlR := Rect(0,0,0,0);
    end;
    Self.Cursor := crDefault;
  end;
end;



procedure TPlannerGrid.CMHintShow(var Message: TMessage);
{$IFDEF DELPHI2_LVL}
type
  PHintInfo = ^THintInfo;
{$ENDIF}
var
  CanShow: Boolean;
  Hi: PHintInfo;
  cr, hr, cor: TRect;
  APlannerItem: TPlannerItem;
  GridCoord: TGridCoord;
  s, CID, CV, CT: string;
  Anchor, StrippedHtmlString, FocusAnchor: string;
  XSize, YSize, ml, hl: Integer;
begin
  if FMouseDownMove or FMouseDownSizeUp or FMouseDownSizeDown then
    Exit;

  Hi := PHintInfo(Message.LParam);

  GridCoord := MouseCoord(Hi.CursorPos.X, Hi.CursorPos.Y);
  cr := CellRectEx(GridCoord.X, GridCoord.Y);

  FLastHintPos := Point(GridCoord.X, GridCoord.Y);

  if FPlanner.Sidebar.Orientation = soVertical then
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.Y, GridCoord.X - 1, Hi.CursorPos.X - cr.Left)
  else
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.X, GridCoord.Y - 1, Hi.CursorPos.Y - cr.Top);

  if not Assigned(APlannerItem) then
  begin
    if FPlanner.Sidebar.Orientation = soVertical then
      APlannerItem := FPlanner.Items.FindBkgPos(GridCoord.Y, GridCoord.X - 1, Hi.CursorPos.X - cr.Left)
    else
      APlannerItem := FPlanner.Items.FindBkgPos(GridCoord.X, GridCoord.Y - 1, Hi.CursorPos.Y - cr.Top);
  end;

  if Assigned(APlannerItem) then
  begin
    s := APlannerItem.ItemText;

    if IsRtf(s) then
    begin
      FPlanner.TextToRich(s);
      s := FPlanner.FRichEdit.Text;
    end;

    if APlannerItem.Hint <> '' then
      s := APlannerItem.Hint;

    if IsHtml(APlannerItem,s) then
    begin
      {Change ? if HTML Hint is enabled ?}
      s := s + ConcatenateTextStrings(APlannerItem.Text);
      cr := ClientRect;
      if not FPlanner.HTMLHint then
      begin
        HTMLDrawEx(Canvas, s, cr, FPlanner.PlannerImages, 0, 0, -1, -1, 1,
          True, True, False, True, True, False, APlannerItem.WordWrap
          , False
          , 1.0, FPlanner.URLColor,
          clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor,
          XSize, YSize, ml, hl, hr
          , cor, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
          );

        s := StrippedHtmlString;
      end;
    end;

    {$IFDEF TMSCODESITE}
    CodeSite.SendMsg(s+'*');
    {$ENDIF}


{$IFNDEF VER90}
    Hi.HintStr := s;
    if Assigned(FPlanner.OnItemHint) then
      FPlanner.OnItemHint(FPlanner, APlannerItem, Hi.HintStr);
{$ENDIF}
{$IFNDEF VER90}
    if Assigned(FPlanner.OnItemHint) then
      FPlanner.OnItemHint(FPlanner, APlannerItem, s);
{$ENDIF}

  end;

  Hi.HintColor := FPlanner.HintColor;

  CanShow := Assigned(APlannerItem);

  Message.Result := Ord(not CanShow);
end;

procedure TPlannerGrid.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if (csDesigning in ComponentState) then
    Message.Result := 1
  else
    inherited;
end;

procedure TPlannerGrid.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  FromSel, FromSelPrecis: Integer;
  ToSel, ToSelPrecis: Integer;
  GridCoord: TGridCoord;
  APlannerItem: TPlannerItem;
  GridRect: TRect;
  ColOffset, RowOffset: Integer;
begin
  if (csDesigning in ComponentState) then
  begin
    Message.Result := 1;
    Exit;
  end;

  ColOffset := FPlanner.FSidebar.FColOffset;
  RowOffset := FPlanner.FSidebar.FRowOffset;

  GridCoord := MouseCoord(Message.XPos, Message.YPos);
  GridRect := CellRectEx(GridCoord.X, GridCoord.Y);

  if FPlanner.Sidebar.Orientation = soVertical then
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.Y - RowOffset, GridCoord.X - ColOffset, Message.xpos
      - GridRect.Left)
  else
    APlannerItem := FPlanner.Items.FindItemPos(GridCoord.X - ColOffset, GridCoord.Y - RowOffset, Message.ypos
      - GridRect.Top);

  if (Assigned(APlannerItem)) then
  begin
    if Assigned(APlannerItem.Editor) then
      if APlannerItem.Editor.EditorUse = euDblClick then
        APlannerItem.FPopupEdit := True;
  end;

  inherited;


  if (Assigned(APlannerItem)) then
  begin
    HintHide;
    FMouseDown := False;
    FMouseDownMove := False;
    FMouseDownSizeUp := False;
    FMouseDownSizeDown := False;

    if Assigned(APlannerItem.Editor) then
      if APlannerItem.Editor.EditorUse = euDblClick then
      begin
        APlannerItem.PopupEdit;
        APlannerItem.FPopupEdit := False;
      end;

    if Assigned(FPlanner.OnItemDblClick) then
      FPlanner.OnItemDblClick(FPlanner, APlannerItem);
      
  end
  else
  begin
    if (Message.xpos < GridRect.Right - 10) or (1 > 0) then
    begin
      if Assigned(FPlanner.FOnPlannerDblClick) then
      begin
        if FPlanner.Sidebar.Position = spTop then
        begin
          FromSel := Selection.Left + FPlanner.Display.DisplayStart;
          ToSel := 1 + Selection.Right + FPlanner.Display.DisplayStart;
          FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          FPlanner.FOnPlannerDblClick(FPlanner, Row - 1, FromSel, FromSelPrecis, ToSel, ToSelPrecis)
        end
        else
        begin
          FromSel := Selection.Top + FPlanner.Display.DisplayStart;
          ToSel := 1 + Selection.Bottom + FPlanner.Display.DisplayStart;
          FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
          FPlanner.FOnPlannerDblClick(FPlanner, Col - 1, FromSel, FromSelPrecis, ToSel, ToSelPrecis);
        end;
      end;
    end;
  end;


end;

procedure TPlannerGrid.WMEraseBkGnd(var Message: TMessage);
begin
  if FEraseBkGnd then
    inherited
  else
    Message.Result := 0 // Avoid erase backgnd to reduce flicker !
end;


procedure TPlannerGrid.CNKeyDown(var Message: TWMKeydown);
var
  APlannerItem: TPlannerItem;
begin
  APlannerItem := nil;
  if (Message.CharCode = VK_TAB) then
  begin
    if (GetKeyState(VK_SHIFT) and $8000 > 0) then
      APlannerItem := FPlanner.Items.SelectPrev
    else
      APlannerItem := FPlanner.Items.SelectNext;
  end;

  inherited;

  if Assigned(APlannerItem) then
  begin
    SetFocus;
    FPlanner.ItemSelected(APlannerItem);
  end;
end;

procedure TPlannerGrid.KeyDown(var Key: Word; ShiftState: TShiftState);
var
  APlannerItem: TPlannerItem;
  GridRect: TRect;
  FromSel, FromSelPrecis: Integer;
  ToSel, ToSelPrecis: Integer;
  CharCode: Word;
  Allow: Boolean;

begin
  APlannerItem := FPlanner.Items.Selected;

  CharCode := Key;
  if FPlanner.Sidebar.Orientation = soHorizontal then
  begin // Map keyboard movement from Horizontal to Vertical
    case CharCode of
      VK_RIGHT: CharCode := VK_DOWN;
      VK_LEFT: CharCode := VK_UP;
      VK_UP: CharCode := VK_LEFT;
      VK_DOWN: CharCode := VK_RIGHT;
    end;
  end;

  case CharCode of
    VK_RETURN, VK_SPACE, VK_F2:
      begin
        if Assigned(APlannerItem) then
        begin
          if not APlannerItem.NotEditable then
          begin
            if FPlanner.Sidebar.Orientation = soVertical then
            begin
              GridRect := CellRectEx(APlannerItem.ItemPos + 1, APlannerItem.ItemBegin);
              StartEditCol(GridRect, APlannerItem, -1, -1);
            end
            else
            begin
              GridRect := CellRectEx(APlannerItem.ItemBegin, APlannerItem.ItemPos +
                FPlanner.FSidebar.FRowOffset);
              StartEditRow(GridRect, APlannerItem, -1, -1);
            end;
          end;
        end;
      end;
    VK_INSERT:
      begin
        if Assigned(FPlanner.FOnItemInsert) then
        begin
          if FPlanner.Sidebar.Orientation = soHorizontal then
          begin
            FromSel := Selection.Left;
            ToSel := 1 + Selection.Right;
            FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
            ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;

            if FPlanner.InsertAlways or not FPlanner.Items.HasItem(FromSel,ToSel,Row - 1) then
              FPlanner.FOnItemInsert(FPlanner, Row - 1, FromSel, FromSelPrecis,
                ToSel, ToSelPrecis);
          end
          else
          begin
            FromSel := Selection.Top;
            ToSel := 1 + Selection.Bottom;
            FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
            ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;

            if FPlanner.InsertAlways or not FPlanner.Items.HasItem(FromSel,ToSel,Col - 1) then
              FPlanner.FOnItemInsert(FPlanner, Col - 1, FromSel, FromSelPrecis,
                ToSel, ToSelPrecis);
          end;
        end;
      end;

    VK_DELETE:
      begin
        if Assigned(FPlanner.OnItemDelete) and Assigned(APlannerItem) then
        begin
          FPlanner.OnItemDelete(FPlanner, APlannerItem);
          Exit;
        end;
      end;

    VK_RIGHT:
      begin
        if Assigned(FPlanner.Items.Selected) then
          with FPlanner.Items.Selected do
          begin
            if (ItemPos < FPlanner.Positions - 1) and
              not FPlanner.Items.HasItem(ItemBegin, ItemEnd, ItemPos + 1) and
              not FixedPos and not FixedPosition then
            begin
              Allow := True;

              if Assigned(FPlanner.FOnItemMoving) then
              begin
                FPlanner.FOnItemMoving(FPlanner,FPlanner.Items.Selected,0,+1,Allow);
              end;

              if Allow then
              begin
                ItemPos := ItemPos + 1;
                FPlanner.Items.SetConflicts;

                with FPlanner.Items do
                FPlanner.ItemMoved(Selected.ItemBegin,
                      Selected.ItemEnd, Selected.ItemPos - 1,
                      Selected.ItemBegin, Selected.ItemEnd, Selected.ItemPos);

                if (FPlanner.PositionWidth > 0) then
                  if FPlanner.Sidebar.Orientation = soHorizontal then
                  begin
                    if ItemPos >= VisibleRowCount + TopRow then
                      TopRow := TopRow + 1;
                  end
                  else
                  begin
                    if ItemPos >= VisibleColCount + LeftCol then
                      LeftCol := LeftCol + 1;
                  end;
              end;
            end;
            Key := 0;
          end
      end;
    VK_LEFT:
      begin
        if Assigned(FPlanner.Items.Selected) then
          with FPlanner.Items.Selected do
          begin
            if (ItemPos > 0) and not FPlanner.Items.HasItem(ItemBegin, ItemEnd,
              ItemPos - 1) and not FixedPos and not FixedPosition then
            begin
              Allow := True;

              if Assigned(FPlanner.FOnItemMoving) then
              begin
                FPlanner.FOnItemMoving(FPlanner,FPlanner.Items.Selected,0,-1,Allow);
              end;

              if Allow then
              begin
                ItemPos := ItemPos - 1;
                FPlanner.Items.SetConflicts;

                with FPlanner.Items do
                  FPlanner.ItemMoved(Selected.ItemBegin,
                      Selected.ItemEnd, Selected.ItemPos + 1,
                      Selected.ItemBegin, Selected.ItemEnd, Selected.ItemPos);

                if (FPlanner.PositionWidth > 0) then
                  if FPlanner.Sidebar.Orientation = soHorizontal then
                  begin
                    if (ItemPos < TopRow - 1) and (TopRow > 1) then
                      TopRow := TopRow - 1;
                  end
                  else
                  begin
                    if (ItemPos < LeftCol - 1) and (LeftCol > 1) then
                      LeftCol := LeftCol - 1;
                  end;

              end;
            end;
            Key := 0;
          end
        else if (Col = 1) and (FPlanner.Sidebar.Visible) and
          (FPlanner.Sidebar.Orientation = soVertical) then
          Key := 0;
      end;
    VK_UP:
      begin
        if Assigned(FPlanner.Items.Selected) then
        begin
          with FPlanner.Items.Selected do
          begin
            if (GetKeyState(VK_SHIFT) and $8000 = 0) and not FixedPos then
            begin
              if not FPlanner.Items.HasItem(ItemBegin - 1, ItemEnd - 1,
                ItemPos) and (ItemBegin > 0) then
              begin
                Allow := True;

                if Assigned(FPlanner.FOnItemMoving) then
                begin
                  FPlanner.FOnItemMoving(FPlanner,FPlanner.Items.Selected,-1,0,Allow);
                end;

                if Allow then
                begin
                  ItemBegin := ItemBegin - 1;
                  ItemEnd := ItemEnd - 1;
                  RealTime := False;
                  FPlanner.Items.SetConflicts;

                  with FPlanner.Items do
                    FPlanner.ItemMoved(Selected.ItemBegin
                        + 1, Selected.ItemEnd + 1, Selected.ItemPos,
                        Selected.ItemBegin, Selected.ItemEnd, Selected.ItemPos);
                end;
              end;
            end
            else
            begin
              if (ItemEnd > ItemBegin + 1) and
                not FPlanner.Items.HasItem(ItemBegin, ItemEnd - 1, ItemPos)
                and
                (FixedSize = False) then
              begin
                Allow := True;

                if Assigned(FPlanner.FOnItemSizing) then
                begin
                  FPlanner.FOnItemSizing(FPlanner,FPlanner.Items.Selected,0,-1,Allow);
                end;

                if Allow then
                begin
                  ItemEnd := ItemEnd - 1;
                  RealTime := False;
                  FPlanner.Items.SetConflicts;

                  with FPlanner.Items do
                    FPlanner.ItemSized(Selected.ItemBegin, Selected.ItemEnd + 1,
                      Selected.ItemBegin, Selected.ItemEnd);
                end;
              end;
            end;

            if FPlanner.Sidebar.Orientation = soHorizontal then
            begin
              if (ItemBegin < LeftCol) then
                LeftCol := LeftCol - 1;
            end
            else
            begin
              if ItemBegin < TopRow then
                TopRow := TopRow - 1;
            end;
          end;
          Key := 0;
        end;  
      end;
    VK_DOWN:
      begin
        if Assigned(FPlanner.Items.Selected) then
          with FPlanner.Items.Selected do
          begin
            if ItemEnd <= FPlanner.Display.DisplayEnd then
            begin
              if (GetKeyState(vk_shift) and $8000 = 0) and not FixedPos then
              begin
                if not FPlanner.Items.HasItem(ItemBegin + 1, ItemEnd + 1,
                  ItemPos) then
                begin
                  Allow := True;

                  if Assigned(FPlanner.FOnItemMoving) then
                  begin
                    FPlanner.FOnItemMoving(FPlanner,FPlanner.Items.Selected,+1,0,Allow);
                  end;

                  if Allow then
                  begin
                    ItemBegin := ItemBegin + 1;
                    ItemEnd := ItemEnd + 1;
                    RealTime := False;
                    FPlanner.Items.SetConflicts;

                    with FPlanner.Items do
                      FPlanner.ItemMoved(Selected.ItemBegin
                          - 1, Selected.ItemEnd - 1, Selected.ItemPos,
                          Selected.ItemBegin, Selected.ItemEnd, Selected.ItemPos);
                  end;
                end;
                Key := 0;
              end
              else
              begin
                if not FPlanner.Items.HasItem(ItemBegin, ItemEnd + 1, ItemPos)
                  and (FixedSize = False) then
                begin
                  Allow := True;

                  if Assigned(FPlanner.FOnItemSizing) then
                  begin
                    FPlanner.FOnItemSizing(FPlanner,FPlanner.Items.Selected,0,+1,Allow);
                  end;

                  if Allow then
                  begin
                    ItemEnd := ItemEnd + 1;
                    RealTime := False;
                    FPlanner.Items.SetConflicts;

                    with FPlanner.Items do
                      FPlanner.ItemSized(Selected.ItemBegin, Selected.ItemEnd - 1,
                                         Selected.ItemBegin, Selected.ItemEnd);
                  end;                       
                end;
              end;

              if FPlanner.Sidebar.Orientation = soHorizontal then
              begin
                if (ItemEnd > visiblecolcount) then
                  LeftCol := LeftCol + 1;
              end
              else
              begin
                if ItemEnd > TopRow + VisibleRowCount then
                  TopRow := TopRow + 1;
              end;
            end;
            Key := 0;
          end;
      end;
  end;

  if not FPlanner.SelectionAlways and Assigned(APlannerItem) then
  begin
    Key := 0;
    Exit;
  end;

  inherited;

  if Key in [VK_UP,VK_LEFT,VK_RIGHT,VK_DOWN,VK_PRIOR,VK_NEXT,
    VK_HOME,VK_END] then
      SelChanged;

  CorrectSelection;

  if Assigned(FPlanner.FOnPlannerKeyDown) then
  begin
    if FPlanner.Sidebar.Orientation = soVertical then
    begin
      FromSel := Selection.Top;
      ToSel := 1 + Selection.Bottom;
      FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      FPlanner.FOnPlannerKeyDown(FPlanner, Key, ShiftState, Col - 1, FromSel,
        FromSelPrecis, ToSel, ToSelPrecis)
    end
    else
    begin
      FromSel := Selection.Left;
      ToSel := 1 + Selection.Right;
      FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      FPlanner.FOnPlannerKeyDown(FPlanner, Key, ShiftState, Row - 1, FromSel,
        FromSelPrecis, ToSel, ToSelPrecis)
    end;
  end;

end;

procedure TPlannerGrid.DoExit;
begin
  inherited;
  if Assigned(FPlanner.OnExit) then
    FPlanner.OnExit(FPlanner);
end;


procedure TPlannerGrid.DoEnter;
var
  GridRect: TGridRect;
begin
  inherited;
  if (Selection.Left = -1) or (Selection.Top = -1) then
  begin
    FillChar(GridRect, SizeOf(GridRect), 0);
    Selection := GridRect;
    SelChanged;
  end;
  if Assigned(FPlanner.OnEnter) then
    FPlanner.OnEnter(FPlanner);
end;

procedure TPlannerGrid.KeyPress(var Key: Char);
var
  FromSel, FromSelPrecis: Integer;
  ToSel, ToSelPrecis: Integer;

begin
  if Assigned(FPlanner.FOnPlannerKeypress) then
  begin
    if FPlanner.Sidebar.Orientation = soVertical then
    begin
      FromSel := Selection.Top;
      ToSel := 1 + Selection.Bottom;
      FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      FPlanner.FOnPlannerKeypress(FPlanner, Key, Col - 1, FromSel,
        FromSelPrecis, ToSel, ToSelPrecis)
    end
    else
    begin
      FromSel := Selection.Left;
      ToSel := 1 + Selection.Right;
      FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      FPlanner.FOnPlannerKeypress(FPlanner, Key, Row - 1, FromSel,
        FromSelPrecis, ToSel, ToSelPrecis)
    end;

  end;
end;


function LongMulDiv(Mult1, Mult2, Div1: Integer): Integer; stdcall;
  external 'kernel32.dll' Name 'MulDiv';

procedure TPlannerGrid.WMVScroll(var WMScroll: TWMScroll);
begin
  if (Row < FixedRows) or (Col < FixedCols) then
  begin
    Selection := TGridRect(Rect(FixedCols, FixedRows, FixedCols, FixedRows));
    SelChanged;
  end;

  if (WMScroll.ScrollCode = SB_THUMBTRACK) and (FPlanner.FScrollSynch) then
  begin
    TopRow := FixedRows + LongMulDiv(WMScroll.Pos, RowCount - VisibleRowCount -
      FixedRows, MaxShortInt);
  end;

  FOldTopRow := TopRow;

  inherited;

  UpdateVScrollBar;
end;

procedure TPlannerGrid.DestroyWnd;
begin
  inherited;
end;

procedure TPlannerGrid.HintHide;
begin
  FScrollHintWindow.ReleaseHandle;
end;

procedure TPlannerGrid.HintShowXY(X, Y: Integer; Caption: TCaption);
var
  HintRect: TRect;
  ScreenPoint: TPoint;
begin
  if not FPlanner.HintOnItemChange then
    Exit;

  HintRect := FScrollHintWindow.CalcHintRect(100, Caption, nil);
  FScrollHintWindow.Caption := Caption;
  FScrollHintWindow.Color := FPlanner.HintColor;
  ScreenPoint := ClientToScreen(Point(X, Y));
  HintRect.Left := HintRect.Left + ScreenPoint.X + 10;
  HintRect.Right := HintRect.Right + ScreenPoint.X + 10;
  HintRect.Top := HintRect.Top + ScreenPoint.Y + 10;
  HintRect.Bottom := HintRect.Bottom + ScreenPoint.Y + 10;
  FScrollHintWindow.ActivateHint(HintRect, Caption);
end;

procedure TPlannerGrid.Paint;
{$IFDEF FREEWARE}
var
  r: TRect;
{$ENDIF}  
begin
  FPlanner.Items.ClearRepaints;
  inherited;

  {$IFDEF FREEWARE}
  if (TopRow = RowCount - VisibleRowCount) then
  begin
    Canvas.Font.Name := 'Tahoma';
    Canvas.Font.Size := 8;
    Canvas.Font.Color := clGray;
    Canvas.Brush.Style := bsClear;

    r := CellRect(1,RowCount -1);
    Canvas.TextOut(r.Left + 4,r.Top + 4,FPlanner.ClassName + ' : Copyright © 2003 by TMS software');
  end;
  {$ENDIF}
end;

procedure TPlannerGrid.RepaintSelection(ASelection: TGridRect);
var
  i: integer;
  r: TRect;

begin
  if ActiveCellShow = assRow then
  begin
    for i := ASelection.Left to ASelection.Right do
    begin
      r := CellRect(i,0);
      InvalidateRect(Handle,@r,True);

    end;
  end;

  if (ActiveCellShow = assCol) or (FPlanner.Display.DisplayText > 0) then
  begin
    for i := ASelection.Top to ASelection.Bottom do
    begin
      r := CellRect(0,i);
      InflateRect(r,2,2);
      InvalidateRect(Handle,@r,True);

    end;
  end;
end;

function TPlannerGrid.SelectCell(AColumn, ARow: Integer): Boolean;
var
  CanSelect: Boolean;
begin
  SetFocus;

  CanSelect := inherited SelectCell(AColumn, ARow);

  if Assigned(FPlanner.OnPlannerSelectCell) then
  begin
    if FPlanner.SideBar.Position in [spLeft,spRight,spLeftRight] then
      FPlanner.OnPlannerSelectCell(FPlanner,ARow,AColumn,CanSelect)
    else
      FPlanner.OnPlannerSelectCell(FPlanner,AColumn,ARow,CanSelect);
  end;

  Result := CanSelect;
end;

function TPlannerGrid.CellRectEx(X, Y: Integer): TRect;
begin
  if Y > TopRow + VisibleRowCount then
    Y := TopRow + VisibleRowCount - 1;

  if Y < TopRow then
    Y := TopRow;

  if X > LeftCol + VisibleColCount then
    X := LeftCol + VisibleColCount - 1;

  if (X < LeftCol) and (FPlanner.SideBar.Position <> spRight) then
    X := LeftCol;

  Result := CellRect(X,Y);

  if (FPlanner.Sidebar.Position in [spLeft,spLeftRight,spTop]) and (FPlanner.FPositionGap > 0) then
  begin
    Result.Left := Result.Left + FPlanner.FPositionGap;
  end;
end;

function TPlannerGrid.ColWidthEx(ItemPos: Integer): Integer;
begin
  Inc(ItemPos);

  Result := ColWidths[ItemPos] - FPlanner.FPositionGap;
end;

function TPlannerGrid.RowHeightEx(ItemPos: Integer): Integer;
begin
  if FPlanner.FSideBar.Visible then
    Inc(ItemPos);

  Result := RowHeights[ItemPos] - FPlanner.FPositionGap;
end;


procedure TPlannerGrid.GetSideBarLines(Index, Position: Integer; var Line1,
  Line2, Line3: string;var HS: Boolean);
var
  Mins: Integer;
  dt: TDatetime;
begin
  Line1 := '';
  Line2 := '';
  Line3 := '';

  case FPlanner.FMode.FPlannerType of
    plDay,plTimeLine:
      begin
        Mins := (Index + FPlanner.Display.DisplayStart) * FPlanner.Display.DisplayUnit
          + FPlanner.Display.DisplayOffset;

        HS := (Mins div 60) <> ((Mins - FPlanner.Display.DisplayUnit) div 60);

        FPlanner.PlanTimeToStrings(Mins, Line1, Line2, Line3);
      end;
    plWeek:
      begin
        if FPlanner.SideBar.ShowDayName then
          Line2 := FPlanner.GetDayName(Index - FPlanner.FMode.WeekStart);
        if FPlanner.SideBar.FDateTimeFormat <> '' then
          Line2 := Line2 + ' ' + FormatDateTime(FPlanner.SideBar.FDateTimeFormat,
          FPlanner.Mode.StartOfMonth + Index);
      end;
    plMonth:
      begin
        if FPlanner.SideBar.ShowDayName then
          Line1 := FPlanner.GetDayName(DayOfWeek(Index + FPlanner.FMode.StartOfMonth));
        Line2 := FormatDateTime(FPlanner.SideBar.FDateTimeFormat,
          FPlanner.Mode.StartOfMonth + Index);
      end;
    plDayPeriod:
      begin
        if FPlanner.SideBar.ShowDayName then
          Line1 := FPlanner.GetDayName(DayOfWeek(Index + FPlanner.FMode.PeriodStartDate));
        Line2 := FormatDateTime(FPlanner.SideBar.DateTimeFormat,
          FPlanner.Mode.PeriodStartDate + Index);
      end;
    plHalfDayPeriod:
    begin
      if FPlanner.SideBar.ShowDayName then
        Line1 := FPlanner.GetDayName(DayOfWeek(Trunc(Index / 2) + FPlanner.FMode.PeriodStartDate));
      Line2 := FormatDateTime(FPlanner.SideBar.DateTimeFormat,
        Trunc(FPlanner.Mode.PeriodStartDate + Index / 2));
      if Odd(Index) then
      Line3 := 'PM' else Line3 := 'AM';
    end;
    plMultiMonth:
    begin
      if Index < 31 then
        Line2 := IntTostr(Index + 1);
    end;
    plCustom, plCustomList:
    begin
      dt := FPlanner.IndexToTime(Index);
      Line1 := FormatDateTime(FPlanner.Sidebar.DateTimeFormat,dt);
    end;
  end;

  if Assigned(FPlanner.OnPlannerGetSideBarLines) then
  begin
    FPlanner.OnPlannerGetSideBarLines(FPlanner, Index, Position, Line1, Line2, Line3);
    HS := Line1 <> '';
  end;
end;

procedure TPlannerGrid.KeyUp(var Key: Word; ShiftState: TShiftState);
var
  FromSel, FromSelPrecis: Integer;
  ToSel, ToSelPrecis: Integer;
begin
  inherited;
  if Assigned(FPlanner.FOnPlannerKeyUp) then
  begin
    if FPlanner.Sidebar.Orientation = soVertical then
    begin
      FromSel := Selection.Top;
      ToSel := 1 + Selection.Bottom;
      FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      FPlanner.FOnPlannerKeyUp(FPlanner, Key, ShiftState, Col - 1, FromSel,
        FromSelPrecis, ToSel, ToSelPrecis)
    end
    else
    begin
      FromSel := Selection.Left;
      ToSel := 1 + Selection.Right;
      FromSelPrecis := FromSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      ToSelPrecis := ToSel * FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
      FPlanner.FOnPlannerKeyUp(FPlanner, Key, ShiftState, Row - 1, FromSel,
        FromSelPrecis, ToSel, ToSelPrecis)
    end;
  end;
end;

procedure TPlannerGrid.UpdateHScrollBar;
var
  ScrollInfo: TScrollinfo;
begin
  if not (ScrollBars in [ssBoth,ssHorizontal]) then
    Exit;

  if not FPlanner.ScrollBarStyle.Flat then
    Exit;

  ScrollInfo.FMask := SIF_ALL;
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  GetScrollInfo(self.Handle,SB_HORZ,ScrollInfo);
  ScrollInfo.FMask := SIF_ALL;
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  FlatSetScrollInfo(SB_HORZ,ScrollInfo,True)
end;

procedure TPlannerGrid.UpdateVScrollBar;
var
  ScrollInfo: TScrollInfo;
begin
  if not (ScrollBars in [ssBoth,ssVertical]) then
    Exit;

  if not FPlanner.ScrollBarStyle.Flat then
    Exit;

  ScrollInfo.FMask := SIF_ALL;
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  GetScrollInfo(Handle,SB_VERT,ScrollInfo);

  ScrollInfo.FMask := SIF_ALL;
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  FlatSetScrollInfo(SB_VERT,ScrollInfo,True);
end;

procedure TPlannerGrid.FlatSetScrollInfo(Code: Integer;var scrollinfo:TScrollInfo;FRedraw: Bool);
var
  ComCtl32DLL: THandle;
  _FlatSB_SetScrollInfo: function(wnd:hwnd;Code: Integer;var ScrollInfo: TScrollInfo;FRedraw: Bool): Integer; stdcall;

begin
  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_FlatSB_SetScrollInfo := GetProcAddress(ComCtl32DLL,'FlatSB_SetScrollInfo');
    if Assigned(_FlatSB_SetScrollInfo) then
    begin
      _FlatSB_SetScrollInfo(self.Handle,code,scrollinfo,fRedraw);
    end;
  end;
end;

procedure TPlannerGrid.FlatScrollInit;
var
  ComCtl32DLL: THandle;
  _InitializeFlatSB: function(wnd:hwnd):Bool stdcall;
begin
  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_InitializeFlatSB := GetProcAddress(ComCtl32DLL,'InitializeFlatSB');
    if Assigned(_InitializeFlatSB) then
      _InitializeFlatSB(self.Handle);
  end;
end;

procedure TPlannerGrid.FlatScrollDone;
var
  ComCtl32DLL: THandle;
  _UninitializeFlatSB: function(wnd:hwnd):Bool stdcall;
begin
  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_UninitializeFlatSB := GetProcAddress(ComCtl32DLL,'UninitializeFlatSB');
    if Assigned(_UninitializeFlatSB) then
      _UninitializeFlatSB(self.Handle);
  end;
end;

procedure TPlannerGrid.FormExit(Sender: TObject);
var
  s: string;
  ComboIdx: Integer;
  ComboObj: TObject;
begin
  if FInplaceEdit.Visible then
  begin
    s := FCurrCtrlItem.Text.Text;
    SetControlValue(s,FCurrCtrlEdit,FInplaceEdit.Text);
    FCurrCtrlItem.Text.Text := s;
    FInplaceEdit.Hide;
    if Assigned(FPlanner.OnItemControlEditDone) then
      FPlanner.OnItemControlEditDone(Self,0,0,
        FCurrCtrlItem, FCurrCtrlEdit,'EDIT',FInplaceEdit.Text);
  end;

  if FInplaceCombo.Visible then
  begin
    s := FCurrCtrlItem.Text.Text;

    ComboIdx := FInplaceCombo.ItemIndex;
    if ComboIdx >= 0 then
      ComboObj := FInplaceCombo.Items.Objects[ComboIdx]
    else
      ComboObj := nil;

    SetControlValue(s,FCurrCtrlEdit,FInplaceCombo.Text);
    FCurrCtrlItem.Text.Text := s;
    FInplaceCombo.Hide;
    if Assigned(FPlanner.OnItemControlEditDone) then
      FPlanner.OnItemControlEditDone(Self,0,0,
        FCurrCtrlItem, FCurrCtrlEdit,'COMBO',s);
    if Assigned(FPlanner.OnItemControlComboSelect) then
      FPlanner.OnItemControlComboSelect(Self,0,0,FCurrCtrlItem,FCurrCtrlEdit,s,ComboIdx,ComboObj);
  end;
end;

procedure TPlannerGrid.FormHandle(Item: TPlannerItem; ControlRect: TRect;
  ControlID,ControlType,ControlValue: string);
var
  s: string;
  sl: TStringList;
  Edit: Boolean;
  DropHeight: Integer;
begin
  FCurrCtrlItem := Item;
  FCurrCtrlEdit := ControlID;
  
  if ControlType = 'CHECK' then
  begin
    s := Item.Text.Text;

    if Uppercase(ControlValue) = 'TRUE' then
      SetControlValue(s,ControlID,'FALSE')
    else
      SetControlValue(s,ControlID,'TRUE');

    Item.Text.Text := s;
  end;

  if Assigned(FPlanner.OnItemControlEditStart) then
    FPlanner.OnItemControlEditStart(Self,ControlRect.Left,ControlRect.Right,
      Item, ControlID,ControlType,ControlValue);

  if ControlType = 'EDIT' then
  begin
    FInplaceEdit.Width := 0;
    FInplaceEdit.Parent := self;
    FInplaceEdit.Visible := True;
    FInplaceEdit.OnExit := FormExit;
    FInplaceEdit.Text := ControlValue;
    FInplaceEdit.BorderStyle := bsNone;
    FInplaceEdit.Left := ControlRect.Left + 4;
    FInplaceEdit.Width := ControlRect.Right - ControlRect.Left - 4;
    FInplaceEdit.Top := ControlRect.Top + 6;
    FInplaceEdit.Height := ControlRect.Bottom - ControlRect.Top - 4;
    BringWindowToTop(FInplaceEdit.Handle);
    FInplaceEdit.SetFocus;
  end;

  if ControlType = 'COMBO' then
  begin
    FInplaceCombo.Width := 0;
    FInplaceCombo.Parent := Self;

    FInplaceCombo.BkColor := ColorToRGB(Item.SelectColor);
    FInplaceCombo.Color := ColorToRGB(Item.SelectColor);
    FInplaceCombo.Visible := True;
    FInplaceCombo.OnExit := FormExit;
    FInplaceCombo.Text := ControlValue;
    FInplaceCombo.Left := ControlRect.Left + 4;
    FInplaceCombo.Width := ControlRect.Right - ControlRect.Left - 4;
    FInplaceCombo.Top := ControlRect.Top + 6;

    DropHeight := 200;

    if Assigned(FPlanner.OnItemControlComboList) then
    begin
      sl := TStringList.Create;
      Edit := True;
      FPlanner.OnItemControlComboList(Self,Item,ControlID,ControlValue,Edit,sl,DropHeight);

      if Edit then
        FInplaceCombo.Style := csDropDown
      else
        FInplaceCombo.Style := csDropDownList;

      FInplaceCombo.Items.Assign(sl);

      FInplaceCombo.ItemIndex := sl.IndexOf(ControlValue);

      sl.Free;
    end;

    if Edit then
      FInplaceCombo.Height := ControlRect.Bottom - ControlRect.Top - 4
    else
      FInplaceCombo.Height := DropHeight;

    BringWindowToTop(FInplaceCombo.Handle);
    FInplaceCombo.SetFocus;

    FInplaceCombo.DroppedDown := True;
  end;
end;

procedure TPlannerGrid.WMHScroll(var WMScroll: TWMScroll);
begin
  FOldLeftCol := LeftCol;

  inherited;

  UpdateHScrollBar;
end;

procedure TPlannerGrid.FlatSetScrollProp(Index, NewValue: Integer;
  FRedraw: bool);
var
  ComCtl32DLL: THandle;
  _FlatSB_SetScrollProp:function(wnd:hwnd;Index,newValue: Integer;fredraw:bool):bool stdcall;

begin
  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_FlatSB_SetScrollProp:=GetProcAddress(ComCtl32DLL,'FlatSB_SetScrollProp');
    if Assigned(_FlatSB_SetScrollProp) then
      _FlatSB_SetScrollProp(self.Handle,index,newValue,FRedraw);
  end;
end;

procedure TPlannerGrid.FlatShowScrollBar(Code: Integer; Show: bool);
var
  ComCtl32DLL: THandle;
  _FlatSB_ShowScrollBar:function(wnd:hwnd;code: Integer;show:bool): Integer; stdcall;

begin
  case code of
  SB_VERT:if not (ScrollBars in [ssBoth,ssVertical]) then Exit;
  SB_HORZ:if not (ScrollBars in [ssBoth,ssHorizontal]) then Exit;
  end;

  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_FlatSB_ShowScrollBar:=GetProcAddress(ComCtl32DLL,'FlatSB_ShowScrollBar');
    if Assigned(_FlatSB_ShowScrollBar) then
      _FlatSB_ShowScrollBar(self.Handle,code,show);
  end;
end;

procedure TPlannerGrid.MouseToCell(X, Y: Integer; var ACol, ARow: Longint);
var
  Coord: TGridCoord;
begin
  Coord := MouseCoord(X, Y);
  ACol := Coord.X;
  ARow := Coord.Y;
end;

procedure TPlannerGrid.RepaintRect(r: TRect);
var
  r1,r2,ur:TRect;
begin
  r1 := CellRect(r.Left,r.Top);
  r2 := CellRect(r.Right,r.Bottom);
  UnionRect(ur,r1,r2);
  if IsRectEmpty(r1) or IsRectEmpty(r2) then
    Repaint
  else
    InvalidateRect(Handle,@ur,True);
end;

procedure TPlannerGrid.InvalidateCellRect(R: TRect);
var
  i,j: Integer;
begin
  for i := R.Left to R.Right do
    for j := R.Top to R.Bottom do
      InvalidateCell(i,j);

  if (FPlanner.Sidebar.Orientation = soVertical) and
     FPlanner.Sidebar.Visible and
     FPlanner.Sidebar.ShowOccupied then
    for i := R.Top to R.Bottom do
    begin
      InvalidateCell(0, i);
    end;

  if (FPlanner.Sidebar.Orientation = soHorizontal) and
     FPlanner.Sidebar.Visible and
     FPlanner.Sidebar.ShowOccupied then
    for i := r.Left to r.Right do
    begin
      InvalidateCell(i, 0);
    end;
end;

{$IFDEF DELPHI5_LVL}
function TPlannerGrid.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if (Row < 0) or (Col < 0) or (Row >= RowCount) or (Col >= ColCount) then
  begin
    Selection := TGridRect(Rect(FixedCols,FixedRows,FixedCols,FixedRows));
    SelChanged;
  end;

  if Row + FPlanner.WheelDelta < RowCount - 1 then
    Row := Row + FPlanner.WheelDelta
  else
    Row := RowCount - 1;

  Result := True;
  CorrectSelection;
  SelChanged;
end;

function TPlannerGrid.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if (Row < 0) or (Col < 0) or (Row >= RowCount) or (Col >= ColCount) then
  begin
    Selection := TGridRect(Rect(FixedCols,FixedRows,FixedCols,FixedRows));
    SelChanged;
  end;

  if Row - FPlanner.WheelDelta >= FixedRows then
    Row := Row - FPlanner.WheelDelta
  else
    Row := FixedRows;

  Result := True;
  CorrectSelection;
  SelChanged;
end;
{$ENDIF}

procedure TPlannerGrid.CorrectSelection;
var
  GridRect: TGridRect;
  MinSel,MaxSel: Integer;
begin
  MinSel := 0;
  MaxSel := 0;
  GridRect := Selection;

  if FPlanner.Sidebar.Orientation = soVertical then
  begin
    FPlanner.GetSelMinMax(Selection.Left,MinSel,MaxSel);

    if Selection.Left <> Selection.Right then
    begin
      if Col < GridRect.Right then
        GridRect.Left := GridRect.Right
      else
        GridRect.Right := GridRect.Left;

      Selection := GridRect;
    end;

    if MinSel > 0 then
      if GridRect.Top <= MinSel then
      begin
        GridRect.Top := MinSel;
        if GridRect.Bottom <= MinSel then
          GridRect.Bottom := MinSel;
        Selection := GridRect;
      end;

    if MaxSel > 0 then
      if GridRect.Bottom >= MaxSel then
      begin
        GridRect.Bottom := MaxSel - 1;
        if GridRect.Top >= MaxSel then
          GridRect.Top := MaxSel - 1;
        Selection := GridRect;
      end;
  end
  else
  begin
    FPlanner.GetSelMinMax(Selection.Top,MinSel,MaxSel);

    if Selection.Top <> Selection.Bottom then
    begin
      if Row < GridRect.Bottom then
        GridRect.Top := GridRect.Bottom
      else
        GridRect.Bottom := GridRect.Top;

      Selection := GridRect;
    end;

    if MinSel > 0 then
      if GridRect.Left <= MinSel then
      begin
        GridRect.Left := MinSel;
        if GridRect.Right <= MinSel then
          GridRect.Right := MinSel;
        Selection := GridRect;
      end;
    if MaxSel > 0 then
      if GridRect.Right >= MaxSel then
      begin
        GridRect.Right := MaxSel - 1;
        if GridRect.Left >= MaxSel then
          GridRect.Left := MaxSel - 1;
        Selection := GridRect;
      end;
  end;
end;

{ TPlannerCaption }

constructor TPlannerCaption.Create(AOwner: TCustomPlanner);
begin
  inherited Create;
  FFont := TFont.Create;
  FFont.Color := clWhite;
  FFont.Size := 10;
  FFont.Style := [fsBold];

  FFont.OnChange := FontChanged;
  FOwner := AOwner;
  FHeight := 32;
  FBackGround := clGray;
  FBackgroundTo := clNone;
  FBackgroundSteps := 32;  
  UpdatePanel;
  FTitle := AOwner.ClassName;
  FVisible := True;
end;

destructor TPlannerCaption.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TPlannerCaption.UpdatePanel;
begin

  FOwner.FPanel.Font.Assign(FFont);
  FOwner.FPanel.Color := FBackGround;
  FOwner.FPanel.Alignment := FAlignment;
  FOwner.FPanel.Caption := FTitle;
  FOwner.FPanel.Visible := FVisible;

  if FOwner.FPanel.Visible then
    FOwner.FPanel.Height := FHeight
  else
    FOwner.FPanel.Height := 0;

  FOwner.FPanel.Repaint;

  if not Assigned(FOwner.FSidebar) then
    Exit;

  if (FOwner.Sidebar.Orientation = soVertical) then
  begin
    if FOwner.FHeader.Visible then
    begin
      FOwner.FHeader.Top := FOwner.FPanel.Height;
      FOwner.FHeader.Height := FOwner.FPlannerHeader.Height;
    end
    else
    begin
      FOwner.FHeader.Top := FOwner.FPanel.Height;
      FOwner.FHeader.Height := 0;
    end;

    if not FOwner.FNavigatorButtons.Visible then
    begin
      FOwner.FPrev.Visible := False;
      FOwner.FNext.Visible := False;
      FOwner.FHeader.Width := FOwner.Width;
      FOwner.FHeader.Left := 0;
    end
    else
    begin
      FOwner.FPrev.Visible := True;
      FOwner.FNext.Visible := True;

      FOwner.FHeader.Left := BtnWidth;
      FOwner.FHeader.Width := FOwner.Width - 2 * BtnWidth - 2;
      FOwner.FPrev.Top := FOwner.FPanel.Height;
      FOwner.FPrev.Left := 0;
      FOwner.FPrev.Width := BtnWidth;
      FOwner.FPrev.Height := FOwner.FHeader.Height;

      FOwner.FNext.Top := FOwner.FPanel.Height;
      FOwner.FNext.Left := FOwner.Width - BtnWidth;
      FOwner.FNext.Width := BtnWidth;
      FOwner.FNext.Height := FOwner.FHeader.Height;

      if not FOwner.FHeader.Flat then
      begin
        FOwner.FHeader.Left := FOwner.FHeader.Left + 1;
        FOwner.FHeader.Width := FOwner.FHeader.Width - 1;
      end;
    end;

    FOwner.FGrid.Height := FOwner.Height - FOwner.FPanel.Height - FOwner.FHeader.Height;
    FOwner.FGrid.Top := FOwner.FPanel.Height + FOwner.FHeader.Height;

  end
  else
  begin
    if FOwner.FHeader.Visible then
    begin
      FOwner.FHeader.Top := FOwner.FPanel.Height;
      FOwner.FHeader.Width := FOwner.FPlannerHeader.Height;
      FOwner.FHeader.Height := FOwner.Height - FHeight;
    end
    else
    begin
      FOwner.FHeader.Top := FOwner.FPanel.Height;
      FOwner.FHeader.Width := 0;
    end;

    FOwner.FGrid.Height := FOwner.Height - FOwner.FPanel.Height;
    FOwner.FGrid.Width := FOwner.Width - FOwner.FHeader.Width;
    FOwner.FGrid.Top := FOwner.FPanel.Height;
    FOwner.FGrid.Left := FOwner.FHeader.Width;

    FOwner.FPrev.Visible := False;
    FOwner.FNext.Visible := False;
  end;

end;

procedure TPlannerCaption.FontChanged(Sender: TObject);
begin
  UpdatePanel;
end;

procedure TPlannerCaption.SetAlignment(const Value: TAlignment);
begin
  if Alignment <> Value then
  begin
    FAlignment := Value;
    UpdatePanel;
  end;
end;

procedure TPlannerCaption.SetBackground(const Value: TColor);
begin
  if Background <> Value then
  begin
    FBackGround := Value;
    UpdatePanel;
  end;
end;

procedure TPlannerCaption.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  FontChanged(Self);
end;

procedure TPlannerCaption.SetHeigth(const Value: Integer);
begin
  if FHeight <> Value then
  begin
    FHeight := Value;
    UpdatePanel;
  end;
end;

procedure TPlannerCaption.SetTitle(const Value: string);
begin
  if FTitle <> Value then
  begin
    FTitle := Value;
    FOwner.FPanel.Caption := FTitle;
    FOwner.FPanel.Repaint;
  end;
end;

procedure TPlannerCaption.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    UpdatePanel;
  end;
end;

procedure TPlannerCaption.SetBackgroundTo(const Value: TColor);
begin
  if BackgroundTo <> Value then
  begin
    FBackGroundTo := Value;
    UpdatePanel;
  end;
end;

procedure TPlannerCaption.SetBackgroundSteps(const Value: Integer);
begin
  if (BackgroundSteps <> Value) then
  begin
    FBackgroundSteps := Value;
    UpdatePanel;
  end;
end;

procedure TPlannerCaption.Assign(Source: TPersistent);
begin
  if Assigned(Source) then
  begin
    Title := (Source as TPlannerCaption).Title;
    Font.Assign((Source as TPlannerCaption).Font);
    Alignment := (Source as TPlannerCaption).Alignment;
    Background := (Source as TPlannerCaption).Background;
    BackgroundSteps := (Source as TPlannerCaption).BackgroundSteps;
    BackgroundTo := (Source as TPlannerCaption).BackgroundTo;
    Height := (Source as TPlannerCaption).Height;
    Visible := (Source as TPlannerCaption).Visible;
  end;
end;

{ TPlannerSideBar }

constructor TPlannerSideBar.Create(AOwner: TCustomPlanner);
begin
  inherited Create;
  FOwner := AOwner;
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FFont.Name := 'Arial'; // choose a truetype font by default
  FBackGround := clBtnFace;
  FBackGroundTo := clWhite;
  FOccupied := clBlue;
  FOccupiedFontColor := clWhite;
  FVisible := True;
  FWidth := 40;
  FColOffset := 1;
  FRowOffset := 0;
  FFlat := True;
  FBorder := True;
  FRotateOnTop := True;
  FShowDayName := True;
  FSeparatorLineColor := clGray;
  FActiveColor := clNone;
end;

destructor TPlannerSideBar.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TPlannerSideBar.FontChanged(Sender: TObject);
begin
  FOwner.FGrid.Repaint;
end;

procedure TPlannerSideBar.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  FOwner.FGrid.Repaint;
end;

procedure TPlannerSideBar.SetBackground(const Value: TColor);
begin
  FBackGround := Value;
  FOwner.FGrid.Repaint;
end;

procedure TPlannerSideBar.SetBackgroundTo(const Value: TColor);
begin
  FBackGroundTo := Value;
  FOwner.FGrid.Repaint;
end;


procedure TPlannerSideBar.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  FOwner.FGrid.Repaint;
end;

procedure TPlannerSideBar.SetVisible(const Value: Boolean);
begin
  if (FVisible <> Value) then
  begin
    FVisible := Value;
    UpdateGrid;
    FOwner.FGrid.UpdatePositions;
    Position := Position;
  end;
end;

procedure TPlannerSideBar.SetWidth(const Value: Integer);
begin
  FWidth := Value;
  if FVisible then
  begin
    UpdateGrid;
    FOwner.FGrid.UpdatePositions;
  end;
end;

procedure TPlannerSideBar.SetPosition(const Value: TSideBarPosition);
begin
  FPosition := Value;
  case FPosition of
    spLeft:
      begin
        if Visible then
          FOwner.FHeader.FOffset := 1
        else
          FOwner.FHeader.FOffset := 0;
        FColOffset := 1;
        FRowOffset := 0;
        FOwner.FGrid.ColCount := FOwner.Positions + 1;
        FOwner.FGrid.FixedCols := 1;
        FOwner.FGrid.FixedRows := 0;
        FOwner.FHeader.Orientation := hoHorizontal;
      end;
    spLeftRight:
      begin
        if Visible then
          FOwner.FHeader.FOffset := 1
        else
          FOwner.FHeader.FOffset := 0;

        FColOffset := 1;
        FRowOffset := 0;

        if FVisible then
          FOwner.FGrid.ColCount := FOwner.Positions + 2
        else
          FOwner.FGrid.ColCount := FOwner.Positions + 1;

        FOwner.FGrid.FixedCols := 1;
        FOwner.FGrid.FixedRows := 0;
        FOwner.FHeader.Orientation := hoHorizontal;
      end;
    spRight:
      begin
        FOwner.FHeader.FOffset := 0;
        FColOffset := 0;
        FRowOffset := 0;
        FOwner.FGrid.ColCount := FOwner.Positions + 1;
        FOwner.FGrid.FixedCols := 0;
        FOwner.FGrid.FixedRows := 0;
        FOwner.FHeader.Orientation := hoHorizontal;
      end;
    spTop:
      begin
        FOwner.FGrid.RowCount := FOwner.Positions + 1;
        FColOffset := 0;
        FRowOffset := 1;
        FOwner.FHeader.FOffset := 1;
        FOwner.FGrid.FixedCols := 0;
        FOwner.FGrid.FixedRows := 1;
        FOwner.FHeader.Orientation := hoVertical;
      end;
  end;

  UpdateGrid;
  FOwner.UpdateSizes;
  FOwner.FGrid.UpdatePositions;
  FOwner.FDisplay.UpdatePlanner;
end;

procedure TPlannerSideBar.UpdateGrid;
begin
  case FPosition of
    spLeft, spRight, spLeftRight:
      if not FVisible then
      begin
        if FColOffset = 1 then
        begin
          FOwner.FGrid.ColWidths[0] := 1;
          FOwner.FGrid.ColWidths[1] := FOwner.Width - 5 -
            FOwner.FGrid.GetHScrollSize;
        end
        else
        begin
          FOwner.FGrid.ColWidths[1] := 1;
          FOwner.FGrid.ColWidths[0] := FOwner.Width - 5 -
            FOwner.FGrid.GetHScrollSize;
        end;
      end
      else
      begin
        if FColOffset = 1 then
        begin
          FOwner.FGrid.ColWidths[1] := FOwner.Width - FWidth -
            FOwner.FGrid.GetHScrollSize;
          FOwner.FGrid.ColWidths[0] := FWidth;
        end
        else
        begin
          FOwner.FGrid.ColWidths[0] := FOwner.Width - FWidth -
            FOwner.FGrid.GetHScrollSize;
          FOwner.FGrid.ColWidths[1] := FWidth;
        end;
      end;
    spTop {,spBottom}:

      if not FVisible then
      begin
        if FRowOffset = 1 then
        begin
          FOwner.FGrid.RowHeights[0] := 1;
          FOwner.FGrid.RowHeights[1] := FOwner.Height - 5 -
            FOwner.FGrid.GetVScrollSize;
        end
        else
        begin
          FOwner.FGrid.RowHeights[1] := 1;
          FOwner.FGrid.RowHeights[0] := FOwner.Height - 5 -
            FOwner.FGrid.GetVScrollSize;
        end;
      end
      else
      begin
        if FRowOffset = 1 then
        begin
          FOwner.FGrid.RowHeights[0] := FWidth;
        end
        else
        begin
          FOwner.FGrid.RowHeights[0] := FOwner.Height - FWidth -
            FOwner.FGrid.GetVScrollSize;
          FOwner.FGrid.RowHeights[1] := FWidth;
        end;
      end;
  end;

end;

function TPlannerSideBar.GetOrientation: TSideBarOrientation;
begin
  if Position = spTop then
    Result := soHorizontal
  else
    Result := soVertical;
end;

procedure TPlannerSideBar.SetShowInPositionGap(const Value: Boolean);
begin
  if FShowInPositionGap <> Value then
  begin
    FShowInPositionGap := Value;
    if (csDesigning in FOwner.ComponentState) then
      Visible := not Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetShowOccupied(const Value: Boolean);
begin
  if FShowOccupied <> Value then
  begin
    FShowOccupied := Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetFlat(const Value: Boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetOccupied(const Value: TColor);
begin
  if FOccupied <> Value then
  begin
    FOccupied := Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetOccupiedFontColor(const Value: TColor);
begin
  if FOccupiedFontColor <> Value then
  begin
    FOccupiedFontColor := Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetDateTimeFormat(const Value: string);
begin
  if FDateTimeFormat <> Value then
  begin
    FDateTimeFormat := Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetBorder(const Value: Boolean);
begin
  if FBorder <> Value then
  begin
    FBorder := Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetRotateOnTop(const Value: Boolean);
begin
  if FRotateOnTop <> Value then
  begin
    FRotateOnTop := Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetShowDayName(const Value: Boolean);
begin
  if FShowDayName <> Value then
  begin
    FShowDayName := Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetSeparatorLineColor(const Value: TColor);
begin
  if FSeparatorLineColor <> Value then
  begin
    FSeparatorLineColor := Value;
    FOwner.FGrid.Invalidate;
  end;
end;


procedure TPlannerSideBar.SetAMPMPos(const Value: TAMPMPos);
begin
  if FAMPMPos <> Value then
  begin
    FAMPMPos := Value;
    FOwner.FGrid.Invalidate;
  end;
end;

procedure TPlannerSideBar.SetActiveColor(const Value: TColor);
begin
  FActiveColor := Value;

  if Position = spTop then
  begin
    if FActiveColor <> clNone then
      FOwner.FGrid.ActiveCellShow := assRow
    else
      FOwner.FGrid.ActiveCellShow := assNone;
  end
  else
  begin
    if FActiveColor <> clNone then
      FOwner.FGrid.ActiveCellShow := assCol
    else
      FOwner.FGrid.ActiveCellShow := assNone;
  end;
end;

procedure TPlannerSideBar.Assign(Source: TPersistent);
begin

  if Assigned(Source) then
  begin
    ActiveColor := (Source as TPlannerSideBar).ActiveColor;
    Alignment := (Source as TPlannerSideBar).Alignment;
    AMPMPos := (Source as TPlannerSideBar).AMPMPos;
    Background := (Source as TPlannerSideBar).Background;
    BackgroundTo := (Source as TPlannerSideBar).BackgroundTo;
    Border := (Source as TPlannerSideBar).Border;
    DateTimeFormat := (Source as TPlannerSideBar).DateTimeFormat;
    Flat := (Source as TPlannerSideBar).Flat;
    Font.Assign((Source as TPlannerSideBar).Font);
    Occupied := (Source as TPlannerSideBar).Occupied;
    OccupiedFontColor := (Source as TPlannerSideBar).OccupiedFontColor;
    Position := (Source as TPlannerSideBar).Position;
    RotateOnTop := (Source as TPlannerSideBar).RotateOnTop;
    SeparatorLineColor := (Source as TPlannerSideBar).SeparatorLineColor;
    ShowInPositionGap := (Source as TPlannerSideBar).ShowInPositionGap;
    ShowOccupied := (Source as TPlannerSideBar).ShowOccupied;
    ShowDayName := (Source as TPlannerSideBar).ShowDayName;
    Visible := (Source as TPlannerSideBar).Visible;
    Width := (Source as TPlannerSideBar).Width;
  end;

end;

{ TPlannerDisplay }

constructor TPlannerDisplay.Create(AOwner: TCustomPlanner);
begin
  inherited Create;
  FOwner := AOwner;
  FDisplayStart := 0;
  FDisplayEnd := 47;
  FDisplayScale := 24;
  FOldScale := FDisplayScale;
  FDisplayUnit := 30;
  FDisplayOffset := 0;
  FActiveStart := 16;
  FActiveEnd := 40;
  InitPrecis;
  FColorActive := clWhite;
  FColorNonActive := clSilver;
  FColorCurrent := clYellow;
  FColorCurrentItem := clLime;
  FCurrentPosFrom := -1;
  FCurrentPosTo := -1;
  FUpdateUnit := False;
end;

destructor TPlannerDisplay.Destroy;
begin
  inherited;
end;

procedure TPlannerDisplay.SetDisplayEnd(const Value: Integer);
begin
  FDisplayEnd := Value;
  FDisplayEndPrecis := (FDisplayEnd + 1) * FDisplayUnit + FDisplayOffset;
  UpdatePlanner;
  if ScaleToFit then
    AutoScale;
end;

procedure TPlannerDisplay.SetDisplayStart(const Value: Integer);
begin
  FDisplayStart := Value;
  FDisplayStartPrecis := FDisplayStart * FDisplayUnit + FDisplayOffset;
  FUpdateUnit := True;
  UpdatePlanner;
  FUpdateUnit := False;
  if ScaleToFit then
    AutoScale;
end;

procedure TPlannerDisplay.SetDisplayScale(const Value: Integer);
var
  ItemIndex: Integer;
begin
  FDisplayScale := Value;
  { Update here all planneritems! }
  for ItemIndex := 0 to FOwner.Items.Count - 1 do
  begin
    (FOwner.Items.Items[ItemIndex] as TPlannerItem).UpdateWnd;
  end;

  UpdatePlanner;
end;

procedure TPlannerDisplay.SetDisplayUnit(const Value: Integer);
var
  TopRowPrecis: Integer;
begin
  if csLoading in FOwner.ComponentState then
  begin
    if Value <> 0 then
    begin
      FDisplayUnit := Value;
      UpdatePlanner;
    end;
    Exit;
  end;

  if FOwner.Sidebar.Position = spTop then
  begin
    if Value <> 0 then
      FDisplayUnit := Value
    else
      Exit;

    TopRowPrecis := FDisplayUnit * FOwner.FGrid.LeftCol + FDisplayOffset;

    { Rescale everything }
    FActiveStart := FActiveStartPrecis div FDisplayUnit;
    FActiveEnd := FActiveEndPrecis div FDisplayUnit;
    FDisplayStart := FDisplayStartPrecis div FDisplayUnit;
    FDisplayEnd := ((FDisplayEndPrecis - FDisplayOffset) div FDisplayUnit) - 1;

    FOwner.FGrid.LeftCol := TopRowPrecis div FDisplayUnit;
  end
  else
  begin
    TopRowPrecis := FDisplayUnit * FOwner.FGrid.TopRow + FDisplayOffset;

    if Value <> 0 then
      FDisplayUnit := Value
    else
      Exit;

    { Rescale everything }
    FActiveStart := FActiveStartPrecis div FDisplayUnit;
    FActiveEnd := FActiveEndPrecis div FDisplayUnit;
    FDisplayStart := FDisplayStartPrecis div FDisplayUnit;
    FDisplayEnd := ((FDisplayEndPrecis - FDisplayOffset) div FDisplayUnit) - 1;

    FOwner.FGrid.TopRow := TopRowPrecis div FDisplayUnit;
  end;

  FUpdateUnit := True;
  UpdatePlanner;
  FUpdateUnit := False;
end;

procedure TPlannerDisplay.SetDisplayOffset(const Value: Integer);
begin
  if Value > FDisplayUnit then
    Exit;

  if Value <> FDisplayOffset then
  begin
    FUpdateUnit := True;
    FDisplayOffset := Value;
    UpdatePlanner;
    FUpdateUnit := False;    
  end;
end;

procedure TPlannerDisplay.UpdatePlanner;
var
  ItemIndex: Integer;
begin
  if FUpdateCount > 0 then
    Exit;

  with FOwner do
    if not (csLoading in ComponentState) then
    begin
      if not FUpdateUnit then
        for ItemIndex := 0 to Items.Count - 1 do
          (FOwner.Items.Items[ItemIndex] as TPlannerItem).DefOrganize;

      if Sidebar.Orientation = soVertical then
      begin
        if FGrid.RowCount <> 1 + FDisplayEnd - FDisplayStart then
          FGrid.RowCount := 1 + FDisplayEnd - FDisplayStart;
        FGrid.DefaultRowHeight := FDisplayScale;
      end
      else
      begin
        if FGrid.ColCount <> 1 + FDisplayEnd - FDisplayStart then
          FGrid.ColCount := 1 + FDisplayEnd - FDisplayStart;
        FGrid.DefaultColWidth := FDisplayScale;
      end;

      for ItemIndex := 0 to Items.Count - 1 do
        (FOwner.Items.Items[ItemIndex] as TPlannerItem).ReOrganize;
      FGrid.Repaint;
    end;
end;

procedure TPlannerDisplay.SetActiveEnd(const Value: Integer);
begin
  FActiveEnd := Value;
  FActiveEndPrecis := (FActiveEnd + FOwner.Display.DisplayStart) *
    FOwner.Display.DisplayUnit + FOwner.Display.DisplayOffset;
  UpdatePlanner;
end;

procedure TPlannerDisplay.SetActiveStart(const Value: Integer);
begin
  FActiveStart := Value;
  FActiveStartPrecis := (FActiveStart + FOwner.Display.DisplayStart) *
    FOwner.Display.DisplayUnit + FOwner.Display.DisplayOffset;
  UpdatePlanner;
end;

procedure TPlannerDisplay.SetColorActive(const Value: TColor);
begin
  FColorActive := Value;
  UpdatePlanner;
end;

procedure TPlannerDisplay.SetColorNonActive(const Value: TColor);
begin
  FColorNonActive := Value;
  UpdatePlanner;
end;

procedure TPlannerDisplay.SetColorCurrent(const Value: TColor);
begin
  FColorCurrent := Value;
  UpdatePlanner;
end;

procedure TPlannerDisplay.SetShowCurrent(const Value: Boolean);
begin
  FShowCurrent := Value;
  UpdatePlanner;
  FOwner.UpdateTimer;
end;

procedure TPlannerDisplay.SetColorCurrentItem(const Value: TColor);
begin
  FColorCurrentItem := Value;
  UpdatePlanner;
end;

procedure TPlannerDisplay.SetShowCurrentItem(const Value: Boolean);
begin
  FShowCurrentItem := Value;
  UpdatePlanner;
  FOwner.UpdateTimer;
  if not Value then
    FOwner.Items.SetCurrent(-1);
end;

procedure TPlannerDisplay.SetScaleToFit(const Value: Boolean);
begin
  if FScaleToFit <> Value then
  begin
    FScaleToFit := Value;

    if FScaleToFit then
    begin
      FOldScale := DisplayScale;
      AutoScale;
    end
    else
      DisplayScale := FOldScale;
  end;
end;

procedure TPlannerDisplay.AutoScale;
var
  R: TRect;
begin
  R := FOwner.FGrid.ClientRect;

  if FOwner.Sidebar.Position = spTop then
    DisplayScale := (R.Right - R.Left) div (DisplayEnd - DisplayStart + 1)
  else
    DisplayScale := (R.Bottom - R.Top) div (DisplayEnd - DisplayStart + 1);
end;


procedure TPlannerDisplay.InitPrecis;
begin
  // initialize precise values properly after load
  FDisplayStartPrecis := FDisplayStart * FDisplayUnit + FDisplayOffset;
  FDisplayEndPrecis := (FDisplayEnd + 1) * FDisplayUnit + FDisplayOffset;

  FActiveStartPrecis := (FActiveStart + FDisplayStart) *
    FDisplayUnit + FDisplayOffset;

  FActiveEndPrecis := (FActiveEnd + FDisplayStart) *
    FDisplayUnit + FDisplayOffset;
end;

procedure TPlannerDisplay.BeginUpdate;
begin
  inc(FUpdateCount);
end;

procedure TPlannerDisplay.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    dec(FUpdateCount);
    if FUpdateCount = 0 then
      UpdatePlanner;
  end;
end;

procedure TPlannerDisplay.SetDisplayText(const Value: Integer);
begin
  if (FDisplayText <> Value) then
  begin
    FDisplayText := Value;
    UpdatePlanner;
  end;
end;

procedure TPlannerDisplay.Assign(Source: TPersistent);
begin
  if Assigned(Source) then
  begin
    ActiveStart := (Source as TPlannerDisplay).ActiveStart;
    ActiveEnd := (Source as TPlannerDisplay).ActiveEnd;
    CurrentPosFrom := (Source as TPlannerDisplay).CurrentPosFrom;
    CurrentPosTo := (Source as TPlannerDisplay).CurrentPosTo;    
    DisplayStart := (Source as TPlannerDisplay).DisplayStart;
    DisplayEnd := (Source as TPlannerDisplay).DisplayEnd;
    DisplayOffset := (Source as TPlannerDisplay).DisplayOffset;
    DisplayScale := (Source as TPlannerDisplay).DisplayScale;
    DisplayUnit := (Source as TPlannerDisplay).DisplayUnit;
    DisplayText := (Source as TPlannerDisplay).DisplayText;
    ColorActive := (Source as TPlannerDisplay).ColorActive;
    ColorNonActive := (Source as TPlannerDisplay).ColorNonActive;
    ColorCurrent := (Source as TPlannerDisplay).ColorCurrent;
    ColorCurrentItem := (Source as TPlannerDisplay).ColorCurrentItem;
    ScaleToFit := (Source as TPlannerDisplay).ScaleToFit;
    ShowCurrent := (Source as TPlannerDisplay).ShowCurrent;
    ShowCurrentItem := (Source as TPlannerDisplay).ShowCurrentItem;
  end;
end;

procedure TPlannerDisplay.SetCurrentPosFrom(const Value: Integer);
begin
  if (FCurrentPosFrom <> Value) then
  begin
    FCurrentPosFrom := Value;
    UpdatePlanner;
  end;
end;

procedure TPlannerDisplay.SetCurrentPosTo(const Value: Integer);
begin
  if (FCurrentPosTo <> Value) then
  begin
    FCurrentPosTo := Value;
    UpdatePlanner;
  end;
end;


{ TPlannerItem }

constructor TPlannerItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPlanner := (Collection as TPlannerItems).FOwner;
  FItemBegin := FPlanner.Display.ActiveStart;
  FItemEnd := FItemBegin + 1;
  FItemPos := 0;
  FColor := clWhite;
  FTrackColor := FPlanner.TrackColor;
  FTrackVisible := True;
  FText := TStringList.Create;
  FFixedPos := False;
  FFixedSize := False;
  FReadOnly := False;
  FImageID := -1;
  FVisible := (csDesigning in FPlanner.ComponentState);
  FImageIndexList := TPlannerIntList.Create(Self);
  FImageIndexList.OnChange := ImageChange;
  FName := 'PlannerItem' + IntToStr(Index);
  FObject := nil;
  FPopupMenu := nil;
  FShape := psRect;
  FConflicts := 0;
  FConflictPos := 0;
  FShadow := True;
  FIsCurrent := False;
  if FPlanner.Sidebar.Orientation = soVertical then
    FAllowOverlap := True
  else
    FAllowOverlap := False;
  FFont := TFont.Create;
  FFont.Assign(FPlanner.Font);
  FFont.OnChange := FontChange;
  FText.OnChange := TextChange;
  FCaptionFont := TFont.Create;
  FCaptionFont.Assign(FPlanner.Font);
  FCaptionFont.OnChange := FontChange;
  FCaptionBkg := clWhite;
  FCaptionBkgTo := clNone;
  FCaptionAlign := taLeftJustify;
  FBrushStyle := bsSolid;
  FSelected := False;
  FSelectColor := clInfoBk;
  FSelectFontColor := clRed;
  FShowSelection := True;
  FTrackColor := clBlue;
  FWordWrap := True;
  FUniformBkg := True;
  FAlarm := TPlannerAlarm.Create;
  FParentIndex := -1;
  FRelationShip := irParent;
  FCursor := crNone;
  FBarItems := TPlannerBarItemList.Create(Self);
  FPopupEdit := False;
  DefOrganize;
end;

destructor TPlannerItem.Destroy;
var
  plItems: TPlannerItems;
  i: Integer;
begin
  plItems := (Collection as TPlannerItems);

  if (RelationShip = irParent) and (ParentIndex <> -1) then
  begin
    i := 0;
    while i < plItems.Count do
      if (plItems.Items[i].ParentIndex = ParentIndex) and (plItems.Items[i].RelationShip = irChild) then
        plItems.Items[i].Free
      else
        inc(i);
  end;

  FImageIndexList.Free;
  FAlarm.Free;

  if Assigned(FPlanner.FGrid) then
  begin
    if FPlanner.FGrid.FMemo.Visible then
      FPlanner.FGrid.FMemo.Visible := False;
    if FPlanner.FRichEdit.FPlannerItem = Self then
      FPlanner.FRichEdit.Visible := False;
  end;

  if FOwnsItemObject and Assigned(FObject) then
  begin
    FObject.Free;
    FObject := nil;
  end;

  if Self = plItems.Selected then
  begin
    plItems.SelectNext;

    if not Assigned(plItems.Selected) then
    begin
      plItems.Selected := Self;
      plItems.SelectPrev;
    end;
  end;

  FFont.Free;
  FCaptionFont.Free;
  Visible := False;
  FText.Free;

  for i := FBarItems.Count - 1 downto 0 do
    FBarItems[ i].Free;
  FBarItems.free;

  inherited;

  plItems.SetConflicts;
end;

{$IFNDEF VER90}
function TPlannerItem.GetDisplayName: string;
begin
  Result := FName;
end;
{$ENDIF}

procedure TPlannerItem.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Repaint;
end;

procedure TPlannerItem.SetAllowOverlap(const Value: Boolean);
begin
  if FAllowOverlap <> Value then
  begin
    FAllowOverlap := Value;
    Repaint;
    Changed;
  end;
end;

procedure TPlannerItem.SetCaptionType(const Value: TCaptionType);
begin
  if (FCaptionType <> Value) then
  begin
    FCaptionType := Value;
    Repaint;
    Changed;    
  end;
end;

procedure TPlannerItem.SetCaptionText(const Value: string);
begin
  FCaptionText := Value;
  Repaint;
  Changed;
end;

procedure TPlannerItem.ImageChange(Sender: TObject);
begin
  Repaint;
  Changed;
end;

procedure TPlannerItem.FontChange(Sender: TObject);
begin
  Repaint;
  Changed;
end;

procedure TPlannerItem.TextChange(Sender: TObject);
begin
  Repaint;
  Changed;
end;

procedure TPlannerItem.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Repaint;
  end;
end;

function TPlannerItem.GetVisible: Boolean;
begin
  Result := FVisible and not FInHeader;
end;

procedure TPlannerItem.ScrollInView;
begin
  with (Collection as TPlannerItems).FOwner do
  begin
    if SideBar.Position <> spTop then
    begin
      if FGrid.VisibleRowCount < FGrid.RowCount then
        GridTopRow := FItemBegin;

      if (FGrid.VisibleColCount < FGrid.ColCount) and (PositionWidth > 0) then
      begin
        if SideBar.Visible and (SideBar.Position = spLeft) then
          GridLeftCol := FItemPos + 1
        else
          GridLeftCol := FItemPos
      end
    end
    else
    begin
      if FGrid.VisibleColCount < FGrid.ColCount then
        GridLeftCol := FItemBegin;

      if (FGrid.VisibleRowCount < FGrid.RowCount) and (PositionWidth > 0) then
        GridTopRow := FItemPos + 1;
    end;
  end;
end;

procedure TPlannerItem.PopupEdit;
begin
  if Assigned(Editor) then
  begin
    if Assigned(FPlanner.OnItemStartEdit) then
      FPlanner.OnItemStartEdit(FPlanner, Self);

    Editor.Edit(FPlanner,Self);

    if Assigned(FPlanner.OnItemEndEdit) then
      FPlanner.OnItemEndEdit(FPlanner, Self);
  end;
end;

procedure TPlannerItem.Edit;
var
  GridRect: TRect;
  ColOffset, RowOffset: Integer;
begin
  if (FPlanner.Sidebar.Orientation = soVertical) then
  begin
    ColOffset := FPlanner.FSidebar.FColOffset;
    GridRect := FPlanner.FGrid.CellRectEx(ItemPos + ColOffset, ItemBegin);
    FPlanner.FGrid.StartEditCol(GridRect, Self, -1, -1);
  end
  else
  begin
    RowOffset := FPlanner.FSidebar.FRowOffset;
    GridRect := FPlanner.FGrid.CellRectEx(ItemBegin, ItemPos + RowOffset);
    FPlanner.FGrid.StartEditRow(GridRect, Self, -1, -1);
  end;
end;


procedure TPlannerItem.SetFocus(const Value: Boolean);
begin
  if (csDestroying in FPlanner.ComponentState) then
    Exit;

  if (FFocus <> Value) then
  begin
    if Value then
    begin
      if Assigned(FPlanner.FOnItemEnter) then
        FPlanner.FOnItemEnter(FPlanner, Self);
    end
    else
    begin
      if Assigned(FPlanner.FOnItemExit) then
        FPlanner.FOnItemExit(FPlanner, Self);
    end;

    FFocus := Value;
    Self.Repaint;
  end;
end;

procedure TPlannerItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  Self.Repaint;
  Changed;
end;

procedure TPlannerItem.SetBackground(const Value: Boolean);
begin
  if (FBackGround <> Value) then
  begin
    FBackGround := Value;
    FReadOnly := True;
    FFixedPos := True;
    FFixedSize := True;
    FAllowOverlap := False;
    Self.Repaint;
    Changed;     
  end;
end;

procedure TPlannerItem.SetImageID(const Value: Integer);
begin
  FImageID := Value;
  Self.Repaint;
  Changed;
end;

procedure TPlannerItem.SetColor(const Value: TColor);
begin
  FColor := Value;
  Self.Repaint;
  Changed;
end;

procedure TPlannerItem.SetTrackColor(const Value: TColor);
begin
  FTrackColor := Value;
  Self.Repaint;
  Changed;
end;

procedure TPlannerItem.SetLayer(const Value: Integer);
begin
  FLayer := Value;
  Self.Repaint;
end;

procedure TPlannerItem.SetItemEnd(const Value: Integer);
var
  Difference: Integer;
  OldVisible: Boolean;

begin
  if Assigned(FLinkedItem) and not FPlanner.FLinkUpdate then
  begin
    Difference := Value - FItemEnd;
    FPlanner.FLinkUpdate := True;
    FPlanner.Items.ResetUpdate;
    case LinkType of
      ltLinkFull, ltLinkEndEnd:
        begin
          if (FLinkedItem.ItemEnd + Difference < FPlanner.FDisplay.FDisplayStart) or
            (FLinkedItem.ItemEnd + Difference > FPlanner.FDisplay.FDisplayEnd) then
          begin
            FPlanner.FLinkUpdate := False;
            Exit;
          end;
          FLinkedItem.ItemEnd := FLinkedItem.ItemEnd + Difference;
        end;
      ltLinkEndBegin:
        begin
          if (FLinkedItem.ItemEnd + Difference < FPlanner.FDisplay.FDisplayStart) or
            (FLinkedItem.ItemEnd + Difference > FPlanner.FDisplay.FDisplayEnd) or
            (FLinkedItem.ItemBegin + Difference < FPlanner.FDisplay.FDisplayStart) or
            (FLinkedItem.ItemBegin + Difference > FPlanner.FDisplay.FDisplayEnd) then
          begin
            FPlanner.FLinkUpdate := False;
            Exit;
          end;
          FLinkedItem.ItemEnd := FLinkedItem.ItemEnd + Difference;
          FLinkedItem.ItemBegin := FLinkedItem.ItemBegin + Difference;
        end;
    end;
    FPlanner.FLinkUpdate := False;
  end;

  OldVisible := Visible;
  Visible := False;
  FItemEnd := Value;

  if not FPlanner.FLoading then
  begin
    FItemEndPrecis := (FItemEnd + EndOffset + FPlanner.Display.DisplayStart) *
      FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
  end;

  Visible := OldVisible;
  (Collection as TPlannerItems).SetConflicts;
end;

procedure TPlannerItem.SetItemBegin(const Value: Integer);
var
  Difference: Integer;
begin
  if Assigned(FLinkedItem) and not FPlanner.FLinkUpdate then
  begin
    FPlanner.FLinkUpdate := True;
    FPlanner.Items.ResetUpdate;
    Difference := Value - FItemBegin;
    case LinkType of
      ltLinkFull, ltLinkBeginBegin:
        begin
          if (FLinkedItem.ItemBegin + Difference < FPlanner.FDisplay.FDisplayStart) or
            (FLinkedItem.ItemBegin + Difference > FPlanner.FDisplay.FDisplayEnd) then
          begin
            FPlanner.FLinkUpdate := False;
            Exit;
          end;

          FLinkedItem.ItemBegin := FLinkedItem.ItemBegin + Difference;
        end;
      ltLinkBeginEnd:
        begin
          if (FLinkedItem.ItemEnd + Difference < FPlanner.FDisplay.FDisplayStart) or
            (FLinkedItem.ItemEnd + Difference > FPlanner.FDisplay.FDisplayEnd) or
            (FLinkedItem.ItemBegin + Difference < FPlanner.FDisplay.FDisplayStart) or
            (FLinkedItem.ItemBegin + Difference > FPlanner.FDisplay.FDisplayEnd) then
          begin
            FPlanner.FLinkUpdate := False;
            Exit;
          end;
          FLinkedItem.ItemBegin := FLinkedItem.ItemBegin + Difference;
          FLinkedItem.ItemEnd := FLinkedItem.ItemEnd + Difference;
        end;
    end;
    FPlanner.FLinkUpdate := False;
  end;

  Visible := False;
  FItemFullBegin := Value;

  if (Value >= 0) then
    FItemBegin := Value
  else
    FItemBegin := 0;

  if not FPlanner.FLoading then
  begin
    FItemBeginPrecis := (FItemBegin + FPlanner.Display.DisplayStart) *
      FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
  end;

  Visible := True;
  (Collection as TPlannerItems).SetConflicts;
end;

function TPlannerItem.GetVisibleSpan: Integer;
var
  cb,ce: Integer;
begin
  cb := ItemBegin;
  ce := ItemEnd;
  if FPlanner.SideBar.Position <> spTop then
  begin
    if cb < FPlanner.FGrid.TopRow then
      cb := FPlanner.FGrid.TopRow;
    if ce > FPlanner.FGrid.VisibleRowCount + FPlanner.FGrid.TopRow then
      ce := FPlanner.FGrid.VisibleRowCount + FPlanner.FGrid.TopRow + 1;
  end
  else
  begin
    if cb < FPlanner.FGrid.LeftCol then
      cb := FPlanner.FGrid.LeftCol;
    if ce >= FPlanner.FGrid.VisibleColCount + FPlanner.FGrid.LeftCol then
      ce := FPlanner.FGrid.VisibleColCount + FPlanner.FGrid.LeftCol;
  end;

  Result := ce - cb;
end;

function TPlannerItem.GetItemRect: TRect;
var
  gr1,gr2: TRect;
begin
  if (FPlanner.Sidebar.Orientation = soVertical) then
  begin
    gr1 := FPlanner.FGrid.CellRectEx(ItemPos + FPlanner.FSideBar.FColOffset, ItemBegin);
    gr2 := FPlanner.FGrid.CellRectEx(ItemPos + FPlanner.FSideBar.FColOffset, ItemEnd - 1);

    CalcConflictRect(gr1, FPlanner.FGrid.ColWidthEx(ItemPos),
      FPlanner.FGrid.RowHeightEx(FPlanner.FSideBar.FRowOffset), True);

    gr1.Bottom := gr2.Bottom;
    Result := gr1;  
  end;
end;

function TPlannerItem.GetGridRect:TRect;
var
  nBegin, nEnd: Integer;
begin
  nBegin := Self.ItemBegin;
  nEnd := Self.ItemEnd;

  if FPlanner.Sidebar.Orientation = soVertical then
  begin
    Result := Rect(Self.ItemPos + FPlanner.FSidebar.FColOffset,
                   nBegin,
                   Self.ItemPos + FPlanner.FSidebar.FColOffset,
                   nEnd - 1);

  end
  else
  begin
    Result := Rect(nBegin,
                   Self.ItemPos + FPlanner.FSidebar.FRowOffset,
                   nEnd - 1,
                   Self.ItemPos + FPlanner.FSidebar.FRowOffset);
  end;
end;

procedure TPlannerItem.Repaint;
var
  ItemPositionIndex: Integer;
  nBegin, nEnd, nPos: Integer;
begin
  if FPlanner.Items.FUpdateCount > 0 then
    Exit;

  { Repaint the complete conflictzone }
  if InHeader then
  begin
    FPlanner.FHeader.Invalidate;
  end
  else
  begin
    FRepainted := False;
    nBegin := Self.ItemBegin;
    nEnd := Self.ItemEnd;
    nPos := Self.ItemPos;
    FPlanner.Items.NumConflicts(nBegin, nEnd, nPos);

    for ItemPositionIndex := nBegin to nEnd - 1 do
    begin
      if FPlanner.Sidebar.Orientation = soVertical then
        FPlanner.FGrid.InvalidateCell(
          Self.ItemPos + FPlanner.FSidebar.FColOffset, ItemPositionIndex)
      else
        FPlanner.FGrid.InvalidateCell(
          ItemPositionIndex, Self.ItemPos + FPlanner.FSidebar.FRowOffset)
    end;

    if (FPlanner.Sidebar.Orientation = soVertical) and
       FPlanner.Sidebar.Visible and
       FPlanner.Sidebar.ShowOccupied then
      for ItemPositionIndex := nBegin to nEnd do
      begin
        FPlanner.FGrid.InvalidateCell(0, ItemPositionIndex);
      end;

    if (FPlanner.Sidebar.Orientation = soHorizontal) and
       FPlanner.Sidebar.Visible and
       FPlanner.Sidebar.ShowOccupied then
      for ItemPositionIndex := nBegin to nEnd do
      begin
        FPlanner.FGrid.InvalidateCell(ItemPositionIndex, 0);
      end;

  end;
end;

procedure TPlannerItem.DefOrganize;
begin
  FItemBeginPrecis := (FItemBegin + FPlanner.Display.DisplayStart) *
    FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
  FItemEndPrecis := (FItemEnd + FPlanner.Display.DisplayStart) *
    FPlanner.Display.DisplayUnit + FPlanner.Display.DisplayOffset;
end;

procedure TPlannerItem.ReOrganize;
begin

  FItemBegin := (FItemBeginPrecis div FPlanner.Display.DisplayUnit) -
    FPlanner.Display.DisplayStart;

  if Frac(FItemEndPrecis / FPlanner.Display.DisplayUnit) > 0 then
    FItemEnd := 1 + (FItemEndPrecis div FPlanner.Display.DisplayUnit) -
      FPlanner.Display.DisplayStart
  else
    FItemEnd := (FItemEndPrecis div FPlanner.Display.DisplayUnit) -
      FPlanner.Display.DisplayStart;

  UpdateWnd;
end;

procedure TPlannerItem.SetText(const Value: TStringList);
begin
  if Assigned(Value) then
    FText.Assign(Value);
  Repaint;
end;

procedure TPlannerItem.UpdateWnd;
begin
  Self.Repaint;
end;

procedure TPlannerItem.CalcConflictRect(var Rect: TRect; Width, Height: Integer;
  Position: Boolean);
begin
  if FConflicts > 1 then
  begin
    if Position then
    begin
      Width := Width div FConflicts;
      Rect.Left := Rect.Left + Width * FConflictPos;
      Rect.Right := Rect.Left + Width - FPlanner.ItemGap;
    end
    else
    begin
      Height := Height div FConflicts;
      Rect.Top := Rect.Top + Height * FConflictPos;
      Rect.Bottom := Rect.Top + Height - FPlanner.ItemGap;
    end;
  end
  else
  begin
    if Position then
      Rect.Right := Rect.Right - FPlanner.ItemGap
    else
      Rect.Bottom := Rect.Bottom - FPlanner.ItemGap;
  end;
end;

procedure TPlannerItem.SetItemPos(const Value: Integer);
var
  Difference: Integer;
begin
  if FItemPos <> Value then
  begin
    if Assigned(FLinkedItem) and not FPlanner.FLinkUpdate then
    begin
      FPlanner.FLinkUpdate := True;
      FPlanner.Items.ResetUpdate;
      Difference := Value - FItemPos;
      FLinkedItem.ItemPos := FLinkedItem.ItemPos + Difference;
      FPlanner.FLinkUpdate := False;
    end;

    Visible := False;
    Repaint;

    FItemPos := Value;
    Visible := True;
    FPlanner.Items.SetConflicts;
    Repaint;
  end;
end;

procedure TPlannerItem.Assign(Source: TPersistent);
begin
  if Source is TPlannerItem then
  begin
    ItemPos := TPlannerItem(Source).ItemPos;
    ItemBegin := TPlannerItem(Source).ItemBegin;
    ItemEnd := TPlannerItem(Source).ItemEnd;
    Color := TPlannerItem(Source).Color;
    Completion := TPlannerItem(Source).Completion;
    CompletionDisplay := TPlannerItem(Source).CompletionDisplay;
    Cursor := TPlannerItem(Source).Cursor;
    Text.Text := TPlannerItem(Source).Text.Text;
    ReadOnly := TPlannerItem(Source).ReadOnly;
    FixedSize := TPlannerItem(Source).FixedSize;
    FixedPos := TPlannerItem(Source).FixedPos;
    CaptionType := TPlannerItem(Source).CaptionType;
    ImageID := TPlannerItem(Source).ImageID;
    Alignment := TPlannerItem(Source).Alignment;
    Name := TPlannerItem(Source).Name;
    Visible := TPlannerItem(Source).Visible;
    Tag := TPlannerItem(Source).Tag;
    TrackColor := TPlannerItem(Source).TrackColor;
    TrackVisible := TPlannerItem(Source).TrackVisible;
    CaptionText := TPlannerItem(Source).CaptionText;
    EditMask := TPlannerItem(Source).EditMask;
    InplaceEdit := TPlannerItem(Source).InplaceEdit;
    Layer := TPlannerItem(Source).Layer;
    Font.Assign(TPlannerItem(Source).Font);
    Background := TPlannerItem(Source).Background;
    AllowOverlap := TPlannerItem(Source).AllowOverlap;
    Selected := TPlannerItem(Source).Selected;
    SelectColor := TPlannerItem(Source).SelectColor;
    CaptionBkg := TPlannerItem(Source).CaptionBkg;
    CaptionBkgTo := TPlannerItem(Source).CaptionBkgTo;
    CaptionAlign := TPlannerItem(Source).CaptionAlign;
    CaptionFont.Assign(TPlannerItem(Source).CaptionFont);
    CaptionType := TPlannerItem(Source).CaptionType;
    BrushStyle := TPlannerItem(Source).BrushStyle;
    InHeader := TPlannerItem(Source).InHeader;
    OwnsItemObject := TPlannerItem(Source).OwnsItemObject;
    Selected := TPlannerItem(Source).Selected;
    SelectColor := TPlannerItem(Source).SelectColor;
    SelectFontColor := TPlannerItem(Source).SelectFontColor;
    Shape := TPlannerItem(Source).Shape;
    PopupMenu := TPlannerItem(Source).PopupMenu;
    ShowSelection := TPlannerItem(Source).ShowSelection;
    DBTag := TPlannerItem(Source).DBTag;
    WordWrap := TPlannerItem(Source).WordWrap;
    Attachement := TPlannerItem(Source).Attachement;
    URL := TPlannerItem(Source).URL;
    UniformBkg := TPlannerItem(Source).UniformBkg;
    Alarm.Assign(TPlannerItem(Source).Alarm);
    Shadow := TPlannerItem(Source).Shadow;
    Editor := TPlannerItem(Source).Editor;
    DrawTool := TPlannerItem(Source).DrawTool;
    Hint := TPlannerItem(Source).Hint;
  end;
end;

procedure TPlannerItem.AssignEx(Source: TPersistent);
begin
  if Source is TPlannerItem then
  begin
    Color := TPlannerItem(Source).Color;
    Cursor := TPlannerItem(Source).Cursor;
    Text.Text := TPlannerItem(Source).Text.Text;
    ReadOnly := TPlannerItem(Source).ReadOnly;
    FixedSize := TPlannerItem(Source).FixedSize;
    FixedPos := TPlannerItem(Source).FixedPos;
    CaptionType := TPlannerItem(Source).CaptionType;
    ImageID := TPlannerItem(Source).ImageID;
    Alignment := TPlannerItem(Source).Alignment;
    Name := TPlannerItem(Source).Name;
    Visible := TPlannerItem(Source).Visible;
    Tag := TPlannerItem(Source).Tag;
    TrackColor := TPlannerItem(Source).TrackColor;
    TrackVisible := TPlannerItem(Source).TrackVisible;
    CaptionText := TPlannerItem(Source).CaptionText;
    EditMask := TPlannerItem(Source).EditMask;
    InplaceEdit := TPlannerItem(Source).InplaceEdit;
    Layer := TPlannerItem(Source).Layer;
    Font.Assign(TPlannerItem(Source).Font);
    Background := TPlannerItem(Source).Background;
    AllowOverlap := TPlannerItem(Source).AllowOverlap;
    Selected := TPlannerItem(Source).Selected;
    SelectColor := TPlannerItem(Source).SelectColor;
    CaptionBkg := TPlannerItem(Source).CaptionBkg;
    CaptionBkgTo := TPlannerItem(Source).CaptionBkgTo;    
    CaptionAlign := TPlannerItem(Source).CaptionAlign;
    CaptionFont.Assign(TPlannerItem(Source).CaptionFont);
    CaptionType := TPlannerItem(Source).CaptionType;
    BrushStyle := TPlannerItem(Source).BrushStyle;
    InHeader := TPlannerItem(Source).InHeader;
    OwnsItemObject := TPlannerItem(Source).OwnsItemObject;
    Selected := TPlannerItem(Source).Selected;
    SelectColor := TPlannerItem(Source).SelectColor;
    Shape := TPlannerItem(Source).Shape;
    PopupMenu := TPlannerItem(Source).PopupMenu;
    ShowSelection := TPlannerItem(Source).ShowSelection;
    DBTag := TPlannerItem(Source).DBTag;
    WordWrap := TPlannerItem(Source).WordWrap;
    Attachement := TPlannerItem(Source).Attachement;
    URL := TPlannerItem(Source).URL;
    UniformBkg := TPlannerItem(Source).UniformBkg;
    Alarm.Assign(TPlannerItem(Source).Alarm);
    DrawTool := TPlannerItem(Source).DrawTool;
    Editor := TPlannerItem(Source).Editor;
  end;
end;


procedure TPlannerItem.SetItemEndTime(const Value: TDateTime);
var
  Hour, Minute, Second, Second100: Word;
  Da, Mo, Ye: Word;
  dte,dts: TDateTime;
  nv, delta, DInc: Integer;

begin
  FItemEndTime := Value;
  with TPlannerItems(Collection).FOwner do
  begin
    case Mode.PlannerType of
      plDay:
        begin
          delta := 0;
          BeginOffset := 0;
          EndOffset := 0;

          if Int(Value) > Int(FItemRealStartTime) then
            delta := 24 * 60;

          if Int(Value) < Int(FItemRealStartTime) then
            delta := - 24 * 60;

          DecodeTime(Value, Hour, Minute, Second, Second100);

          Minute := Minute + Hour * 60;

          // start 1.6.0.2 fix to display items on day crossing views
          // if (Minute div Display.DisplayUnit < Display.DisplayStart) then
          //   Minute := Minute + 1440;
          // end 1.6.0.2 fix to display items on day crossing views

          Minute := Minute + Delta;

          FItemEndPrecis := Minute; // moved after delta

          if FItemEndPrecis < FItemBeginPrecis then
          begin
            FItemEndPrecis := FItemEndPrecis + 60 * 24;
            Minute := Minute + 60 * 24;
          end;

          if Minute > Display.FDisplayEndPrecis then
          begin
            if FRoundTime then
              EndOffset := Round((Minute - Display.FDisplayEndPrecis) / Display.DisplayUnit)
            else
              EndOffset := (Minute - Display.FDisplayEndPrecis) div Display.DisplayUnit;

            ItemEnd := Display.DisplayEnd - Display.DisplayStart + 1;
          end
          else
            if FItemBeginPrecis < Display.FDisplayStartPrecis then
            begin
              // hide item if falling outside displayed timespan
              if (Minute < Display.FDisplayStartPrecis) then
              begin
                //ItemBegin := 0;
                //ItemEnd := 0;
                InHeader := true;
              end
              else
              begin
                ItemBegin := 0;
                if FRoundTime then
                  BeginOffset := Round((Display.FDisplayStartPrecis - Minute) /
                    Display.DisplayUnit)
                else
                  BeginOffset := (Display.FDisplayStartPrecis - Minute) div
                    Display.DisplayUnit;

                if FRoundTime then
                  ItemEnd := Round(Minute / Display.DisplayUnit)  -
                    Display.DisplayStart
                else
                  ItemEnd := ((Minute - 1) div Display.DisplayUnit) + 1 -
                    Display.DisplayStart;
              end;
            end
            else
            begin
              if FRoundTime then
                ItemEnd := Round(Minute / Display.DisplayUnit)  -
                  Display.DisplayStart
              else
                ItemEnd := ((Minute - 1) div Display.DisplayUnit) + 1 -
                  Display.DisplayStart;
            end;

          if FRoundTime then
            if ItemEnd = ItemBegin then
              ItemEnd := ItemEnd + 1;

          // removed in 1.6.0.2
          FItemEndPrecis := Minute; // moved after delta

          {$IFDEF TMSDEBUG}
          outputdebugstring(pchar(formatdatetime('hh:nn dd/mm/yyyy',value)));
          {$ENDIF}

          FItemRealEndTime := Value;
        end;
      plTimeLine:
        begin
          DecodeTime(Value, Hour, Minute, Second, Second100);
          Minute := Minute + Hour * 60;
          FItemEndPrecis := Minute;

          // start 1.6.0.2 fix to display items on day crossing views
          // if ((Minute div Display.DisplayUnit) - Display.DisplayStart) < 0 then
          //  Minute := Minute + 1440;
          // end 1.6.0.2 fix to display items on day crossing views

          DInc := Round(Int(Value) - Int(Mode.TimeLineStart)) * (MININDAY div Display.DisplayUnit);

          // outputdebugstring(pchar('day diff: '+inttostr(Dinc)));

          Minute := (Minute div Display.DisplayUnit) - Display.DisplayStart;

          if Minute + DInc > Display.FDisplayEnd then
          begin
            EndOffset := Minute + DInc - Display.DisplayEnd - 1;
            ItemEnd := Display.DisplayEnd - Display.DisplayStart + 1;
          end
          else
            ItemEnd := Minute + DInc;

          FItemRealEndTime := Value;
        end;

      plDayPeriod,plMonth,plWeek:
        begin
          dte := FPlanner.Mode.PeriodEndDate;
          dts := FPlanner.Mode.PeriodStartDate;

          FItemRealEndTime := Value;
          EndOffset := 0;

          if Trunc(Value) > dte then
            EndOffset := Trunc(Value - dte);

          nv := Trunc(Value - FPlanner.Mode.PeriodStartDate) + 1;

          // Clip(nv, FPlanner.Display.DisplayStart, FPlanner.Display.DisplayEnd - FPlanner.Display.DisplayStart);

          if (nv < 0) then // Because of the 0 we can't use the Clip function
            nv := FPlanner.Display.DisplayStart;

          if (nv > FPlanner.Display.DisplayEnd - FPlanner.Display.DisplayStart) then
            nv := FPlanner.Display.DisplayEnd - FPlanner.Display.DisplayStart + 1;

          if Value < dts then
          begin
            Self.Visible := False;
          end
          else
            ItemEnd := nv;

          {$IFDEF TMSCODESITE}
          CodeSite.SendInteger('endtime',ItemEnd);
          CodeSite.SendInteger('set endoffset',EndOffset);
          {$ENDIF}

          {$IFDEF TMSDEBUG}
          outputdebugstring(pchar(formatdatetime('et : hh:nn dd/mm/yyyy',value)));
          {$ENDIF}

          FItemRealEndTime := Value;
        end;
      plHalfDayPeriod:
        begin
          dte := FPlanner.Mode.PeriodEndDate;

          EndOffset := 0;

          {$IFDEF TMSCODESITE}
          codesite.SendFloat('diff:',Value - FPlanner.Mode.PeriodStartDate);
          {$ENDIF}

          nv := Trunc(2 * (Value - FPlanner.Mode.PeriodStartDate));

          if Frac(Value) > 0 then
            inc(nv);

          if nv < 0 then // Because of the 0 we can't use the Clip function
            nv := FPlanner.Display.DisplayStart;

          if nv > FPlanner.Display.DisplayEnd - FPlanner.Display.DisplayStart then
            nv := FPlanner.Display.DisplayEnd - FPlanner.Display.DisplayStart + 1;

          ItemEnd := nv;

          if Value > dte then
            EndOffset := Round(2 * (Value - dte));

          {$IFDEF TMSCODESITE}
          CodeSite.SendInteger('starttime',ItemBegin);
          CodeSite.SendInteger('set beginoffset',BeginOffset);
          {$ENDIF}

          FItemRealEndTime := Value;
        end;
      plMultiMonth:
        begin
          DecodeDate(Value,Ye,Mo,Da);

          while (FPlanner.Mode.Year < Ye) do
          begin
            Mo := Mo + 12;
            dec(Ye);
          end;

          ItemPos := Limit(Mo - FPlanner.Mode.Month, 0, Positions - 1);
          ItemEnd := Da;
        end;
      plCustom, plCustomList:
        begin
          ItemEnd := FPlanner.TimeToIndex(Value);
        end;
    end;
  end;

end;

procedure TPlannerItem.SetItemStartTime(const Value: TDateTime);
var
  Hour, Minute, Second, Second100: Word;
  Da, Mo, Ye: Word;
  dts,dte: TDateTime;
  DInc: integer;

begin
  FItemStartTime := Value;
  with TPlannerItems(Collection).FOwner do
  begin
    case Mode.PlannerType of
      plDay:
        begin
          DecodeTime(Value, Hour, Minute, Second, Second100);
          Minute := Minute + Hour * 60;

          // start 1.6.0.2 fix to display items on day crossing views
          // if ((Minute div Display.DisplayUnit) - Display.DisplayStart) < 0 then
          //  Minute := Minute + 1440;
          // end 1.6.0.2 fix to display items on day crossing views
          if FRoundTime then
            ItemBegin := Round(Minute / Display.DisplayUnit) - Display.DisplayStart
          else
            ItemBegin := (Minute div Display.DisplayUnit) - Display.DisplayStart;

          FItemBeginPrecis := Minute;
          FItemRealStartTime := Value;
        end;
      plTimeLine:
        begin
          DecodeTime(Value, Hour, Minute, Second, Second100);
          Minute := Minute + Hour * 60;

          FItemBeginPrecis := Minute;

          // start 1.6.0.2 fix to display items on day crossing views
          // if ((Minute div Display.DisplayUnit) - Display.DisplayStart) < 0 then
          //  Minute := Minute + 1440;
          // end 1.6.0.2 fix to display items on day crossing views

          DInc := Round(Int(Value) - Int(Mode.TimeLineStart)) * (MININDAY div Display.DisplayUnit);

          {$IFDEF TMSDEBUG}
          outputdebugstring(pchar('day diff: '+inttostr(Dinc)));
          {$ENDIF}

          Minute := (Minute div Display.DisplayUnit) - Display.DisplayStart;

          if Minute + DInc < 0 then
          begin
            ItemBegin := 0;
            BeginOffset := - (Minute + DInc);
          end
          else
            ItemBegin := Minute + DInc;

          FItemRealStartTime := Value;
        end;

      plDayPeriod,plMonth,plWeek:
        begin
          dts := FPlanner.Mode.PeriodStartDate;
          dte := FPlanner.Mode.PeriodEndDate;

          BeginOffset := 0;

          if (Trunc(Value) > dts) and (Trunc(Value) <= dte) then
            ItemBegin := Trunc(Value - dts)
          else
          begin
            BeginOffset := Trunc(dts- Trunc(Value));

            ItemBegin := 0;
            if Trunc(Value) > dte then
              Self.Visible := False;
          end;

          {$IFDEF TMSCODESITE}
          CodeSite.SendInteger('starttime',ItemBegin);
          CodeSite.SendInteger('set beginoffset',BeginOffset);
          {$ENDIF}

          FItemRealStartTime := Value;
        end;
      plHalfDayPeriod:
        begin
          dts := FPlanner.Mode.PeriodStartDate;
          dte := FPlanner.Mode.PeriodEndDate;

          BeginOffset := 0;

          {$IFDEF TMSCODESITE}
          codesite.SendDateTime('dts',dts);
          codesite.SendDateTime('dte',dte);
          {$ENDIF}

          if (Value >= dts) and (Value <= dte) then
            ItemBegin := Trunc(2*(Value - dts))
          else
          begin
            BeginOffset := Trunc(1 + 2*(dts - Value));
            {$IFDEF TMSCODESITE}
            codesite.SendInteger('beginoffset=',beginoffset);
            {$ENDIF}
            ItemBegin := 0;
          end;

          FItemRealStartTime := Value;
        end;
      plMultiMonth:
        begin
          DecodeDate(Value,Ye,Mo,Da);
          while (FPlanner.Mode.Year < Ye) do
          begin
            Mo := Mo + 12;
            dec(Ye);
          end;
          
          ItemPos := Limit(Mo - FPlanner.Mode.Month, 0, Positions - 1);
          ItemBegin := Da - 1;
        end;
      plCustom, plCustomList:
        begin
          ItemBegin := TimeToIndex(Value);
        end;
    end;
  end;
end;

function TPlannerItem.GetItemEndTime: TDateTime;
var
  res,ID,DInc: Integer;
  da,mo,ye: word;
begin
  with TPlannerItems(Collection).FOwner do
  begin
    Result := 0;
    case Mode.PlannerType of
      plDay:
        begin
          res := FItemEndPrecis;
          ID := 0;
          while (res >= MinInDay) do
          begin
            res := res - MinInDay;
            inc(ID);
          end;
          Result := EncodeTime(res div 60, res mod 60, 0, 0);

          {
          if EndOffset > 0 then
          begin
            res := EndOffset * Display.DisplayUnit;
            Result := Result + EncodeTime(res div 60,res mod 60,0 ,0);
          end;
          }

          Result := Result + PosToDay(ItemPos) + ID;
        end;

      plTimeLine:
        begin
          // res := FItemEndPrecis + (EndOffset - 1) * Display.DisplayUnit
          res := FItemEndPrecis;

          while (res >= MININDAY) do
          begin
            res := res - MININDAY;
          end;

          Result := EncodeTime(res div 60, res mod 60, 0, 0);

          DInc := (ItemEnd + EndOffset) div ((MININDAY div Display.DisplayUnit));

          Result := Result + Int(FPlanner.Mode.TimeLineStart + DInc);
        end;

      plMonth,plWeek:
        begin
          Result := Mode.StartOfMonth - 1 + EndOffset + ItemEnd + Frac(FItemRealEndTime);
        end;
      plDayPeriod:
        begin
          Result := FPlanner.Mode.PeriodStartDate -1 + EndOffset + ItemEnd + Frac(FItemRealEndTime);
        end;
      plHalfDayPeriod:
        begin
          Result := FPlanner.Mode.PeriodStartDate + (ItemEnd + EndOffset) / 2;
        end;
      plMultiMonth:
        begin
          ye := FPlanner.Mode.Year;
          mo := FPlanner.Mode.Month + ItemPos;
          da := ItemEnd + 1;

          while (mo > 12) do
          begin
            mo := mo - 12;
            ye := ye + 1;
          end;

          if da > DaysInMonth(mo,ye) then
          begin
            inc(mo);
            if mo > 12 then
            begin
              mo := 1;
              inc(ye);
            end;
            da := 1;
          end;

          Result := EncodeDate(ye,mo,da);
        end;
      plCustom, plCustomList:
        begin
          Result := IndexToTime(ItemEnd);
        end;
    end;
  end;

end;

function TPlannerItem.GetItemStartTime: TDateTime;
var
  res,ID,y,DInc: Integer;
begin
  with TPlannerItems(Collection).FOwner do
  begin
    Result := 0;
    case Mode.PlannerType of
      plDay:
        begin
          res := FItemBeginPrecis;
          ID := 0;

          while (res >= 24 * 60) do
          begin
            res := res - 60 * 24;
            inc(ID);
          end;

          Result := EncodeTime(res div 60, res mod 60, 0, 0);

          if BeginOffset > 0 then
          begin
            res := BeginOffset * Display.DisplayUnit;
            Result := Result - EncodeTime(res div 60,res mod 60,0 ,0);
          end;

          Result := Result + PosToDay(ItemPos) + ID;
        end;
      plTimeLine:
        begin
          res := FItemBeginPrecis - BeginOffset * Display.DisplayUnit;

          while (res >= MININDAY) do
            res := res - MININDAY;

          while (res < 0) do
            res := res + MININDAY;

          Result := EncodeTime(res div 60, res mod 60, 0, 0);
          DInc := (ItemBegin) div ((MININDAY div Display.DisplayUnit));
          if BeginOffset > 0 then
            DInc := DInc - 1 - (BeginOffset div (MININDAY div Display.DisplayUnit));

          Result := Result + Int(FPlanner.Mode.TimeLineStart + DInc);
        end;
      plMonth,plWeek:
        begin
          Result := Mode.StartOfMonth - BeginOffset + ItemBegin + Frac(FItemRealStartTime);
        end;
      plDayPeriod:
        begin
          Result := FPlanner.Mode.PeriodStartDate - BeginOffset + ItemBegin + Frac(FItemRealStartTime);
        end;
      plHalfDayPeriod:
        begin
          Result := FPlanner.Mode.PeriodStartDate + (ItemBegin - BeginOffset) / 2;
        end;
      plMultiMonth:
        begin
          res := FPlanner.Mode.Month + ItemPos;
          y := FPlanner.Mode.Year;
          while (res > 12) do
          begin
            res := res - 12;
            inc(y);
          end;
          Result := EncodeDate(y,res,ItemBegin + 1);
        end;
      plCustom, plCustomList:
        begin
          Result := FPlanner.IndexToTime(ItemBegin);
        end;
    end;
    FItemStartTime := Result;
  end;
end;

function TPlannerItem.GetItemSpanTimeStr: string;
begin
  Result := GetCaptionTimeString;
end;

function TPlannerItem.GetItemEndTimeStr: string;
begin
  with TPlannerItems(Collection).FOwner do
  begin
    Result := '';
    case Mode.PlannerType of
      plDay,plTimeLine:
        begin
          Result := PlanTimeToStr(FItemEndPrecis);
        end;
      plMonth,plWeek:
        begin
          Result := DateToStr(Mode.StartOfMonth - 1 + ItemEnd + EndOffset);
        end;
      plDayPeriod:
        begin
          Result := DateToStr(Mode.PeriodStartDate -1 + ItemEnd + EndOffset);
        end;
      plHalfDayPeriod:
        begin
          Result := DateToStr(Mode.PeriodStartDate + (ItemEnd - 1 + EndOffset) / 2);
        end;
      plMultiMonth:
        begin
          if not RealTime then
            Result := DateToStr(GetItemEndTime - 1)
          else
            Result := DateToStr(GetItemRealEndTime);
        end;
      plCustom, plCustomList:
        begin
          Result := FormatDateTime(Mode.DateTimeFormat, ItemEndTime);
        end;

    end;
  end;
end;

function TPlannerItem.GetItemStartTimeStr: string;
begin
  with TPlannerItems(Collection).FOwner do
  begin
    Result := '';
    case Mode.PlannerType of
      plDay,plTimeLine:
        begin
          Result := PlanTimeToStr(FItemBeginPrecis -
            BeginOffset * FPlanner.FDisplay.FDisplayUnit + MININDAY);
        end;
      plDayPeriod,plMonth,plWeek:
        begin
          Result := DateToStr(Mode.PeriodStartDate + ItemBegin - BeginOffset);
        end;
      plHalfDayPeriod:
        begin
          Result := DateToStr(Mode.PeriodStartDate + (ItemBegin - BeginOffset) / 2);
        end;
      plMultiMonth:
        begin
          if not RealTime then
            Result := DateToStr(GetItemStartTime)
          else
            Result := DateToStr(GetItemRealStartTime);
        end;
      plCustom, plCustomList:
        begin
          Result := FormatDateTime(Mode.DateTimeFormat, ItemStartTime);
        end;
    end;
  end;
end;

procedure TPlannerItem.SetIsCurrent(const Value: Boolean);
begin
  if FIsCurrent <> Value then
  begin
    FIsCurrent := Value;

    if FIsCurrent and Assigned(FPlanner.FOnItemActivate) then
      FPlanner.FOnItemActivate(FPlanner, Self);

    if not FIsCurrent and Assigned(FPlanner.FOnItemDeActivate) then
      FPlanner.FOnItemDeActivate(FPlanner, Self);

    Repaint;
  end;
end;

procedure TPlannerItem.SetItemRealEndTime(const Value: TDateTime);
begin
  FItemRealEndTime := Value;
end;

procedure TPlannerItem.SetItemRealStartTime(const Value: TDateTime);
begin
  FItemRealStartTime := Value;
end;

procedure TPlannerItem.SetBrusStyle(const Value: TBrushStyle);
begin
  if (FBrushStyle <> Value) then
  begin
    FBrushStyle := Value;
    Repaint;
  end;
end;

procedure TPlannerItem.SetCaptionAlign(const Value: TAlignment);
begin
  if (FCaptionAlign <> Value) then
  begin
    FCaptionAlign := Value;
    Repaint;
  end;
end;

procedure TPlannerItem.SetCaptionBkg(const Value: TColor);
begin
  if (FCaptionBkg <> Value) then
  begin
    FCaptionBkg := Value;
    Self.Repaint;
  end;
end;

procedure TPlannerItem.SetCaptionFont(const Value: TFont);
begin
  FCaptionFont.Assign(Value);
  Self.Repaint;
end;

function TPlannerItem.GetCaptionTimeString: string;
var
  s1, s2: string;
  DateTime: TDateTime;
  DOffs1,DOffs2: Integer;
  ho,mi,se,se100: word;
begin
  case FPlanner.FMode.FPlannerType of
    plDay:
      begin
        s1 := FPlanner.PlanTimeToStr(FItemBeginPrecis -
          BeginOffset * FPlanner.FDisplay.FDisplayUnit + 60 * 24);
        s2 := FPlanner.PlanTimeToStr(FItemEndPrecis {+
          EndOffset * FPlanner.FDisplay.FDisplayUnit});

        if RealTime or InHeader then
        begin
          DecodeTime(ItemRealStartTime,ho,mi,se,se100);

          mi := mi + ho * 60;
          s1 := FPlanner.PlanTimeToStr(mi);

          // s1 := TimeToStr(ItemRealStartTime);

          DecodeTime(ItemRealEndTime,ho,mi,se,se100);
          mi := mi + ho * 60;
          s2 := FPlanner.PlanTimeToStr(mi);

          // s2 := TimeToStr(ItemRealEndTime);

          if (Int(ItemRealStartTime) <> Int(ItemRealEndTime)) and
             (Int(ItemRealStartTime) <> 0) and (Int(ItemRealEndTime) <> 0) then
            Result := s1 + ' ' + DateToStr(ItemRealStartTime) + ' - ' + s2 + ' ' + DateToStr(ItemRealEndTime)
          else
            Result := s1 + ' - ' + s2;

          {$IFDEF TMSDEBUG}
          outputdebugstring(pchar(datetostr(itemrealendtime)));
          {$ENDIF}
        end
        else
        begin
          if (Int(ItemStartTime) <> Int(ItemEndTime)) and
             (Int(ItemStartTime) <> 0) and (Int(ItemEndTime) <> 0) then
            Result := s1 + ' ' + DateToStr(ItemStartTime) + ' - ' + s2 + ' ' + DateToStr(ItemEndTime)
          else
            Result := s1 + ' - ' + s2;
        end;
      end;
    plTimeLine:
      begin
        s1 := FPlanner.PlanTimeToStr(FItemBeginPrecis -
          BeginOffset * FPlanner.FDisplay.FDisplayUnit + MININDAY);

        s2 := FPlanner.PlanTimeToStr(FItemEndPrecis);

        {
        s2 := FPlanner.PlanTimeToStr(FItemEndPrecis +
          EndOffset * FPlanner.FDisplay.FDisplayUnit);
        }
        if RealTime or InHeader then
        begin
          s1 := TimeToStr(ItemRealStartTime);
          s2 := TimeToStr(ItemRealEndTime);

          if (Int(ItemRealStartTime) <> Int(ItemRealEndTime)) and
             (Int(ItemRealStartTime) <> 0) and (Int(ItemRealEndTime) <> 0) then
            Result := s1 + ' ' + DateToStr(ItemRealStartTime) + ' - ' + s2 + ' ' + DateToStr(ItemRealEndTime)
          else
            Result := s1 + ' - ' + s2;

          {$IFDEF TMSDEBUG}
          outputdebugstring(pchar(datetostr(itemrealendtime)));
          {$ENDIF}
        end
        else
        begin
          DOffs1 := (((ItemBegin) * FPlanner.Display.DisplayUnit) div MININDAY);
          DOffs2 := (((ItemEnd + EndOffset) * FPlanner.Display.DisplayUnit) div MININDAY);

          if BeginOffset > 0 then
            DOffs1 := DOffs1 - 1 - ((BeginOffset * FPlanner.Display.DisplayUnit) div MININDAY);

          if (Doffs1 <> Doffs2) then
            Result := s1 + ' ' + DateToStr(Planner.Mode.TimeLineStart + DOffs1) + ' - ' + s2 + ' ' + DateToStr(Planner.Mode.TimeLineStart + DOffs2)
          else
            Result := s1 + ' - ' + s2 + ' ' + DateToStr(Planner.Mode.TimeLineStart + DOffs1);
        end;
      end;
    plWeek:
      begin
        s2 := '';
        s1 := FPlanner.GetDayName(ItemBegin - FPlanner.FMode.WeekStart);

        DateTime := FPlanner.Mode.PeriodStartDate + FItemBegin;
        DateTime := DateTime - BeginOffset;

        if FPlanner.Mode.FDateTimeFormat <> '' then
          s1 := s1 + ' ' + FormatDateTime(FPlanner.Mode.FDateTimeFormat,DateTime);

        DateTime := FPlanner.Mode.PeriodStartDate + FItemEnd;
        DateTime := DateTime + EndOffset - 1;

        if FItemEnd > FItemBegin + 1 then
        begin
          s2 := FPlanner.GetDayName(FItemEnd - 1 - FPlanner.FMode.WeekStart);
          if FPlanner.Mode.FDateTimeFormat <> '' then
            s2 := s2 + ' ' + FormatDateTime(FPlanner.Mode.FDateTimeFormat,DateTime);
        end;

        if s2 <> '' then
          s1 := s1 + ' - ' + s2;
        Result := s1;
      end;

    plDayPeriod,plMonth:
      begin
        with FPlanner.FMode do
        begin
          //v1.2
          DateTime := FPlanner.Mode.PeriodStartDate + FItemBegin;
          DateTime := DateTime - BeginOffset;

          s1 := FormatDateTime(FDateTimeFormat, DateTime);

          DateTime := FPlanner.Mode.PeriodStartDate + FItemEnd;
          DateTime := DateTime + EndOffset - 1;

          if FItemEnd > FItemBegin + 1 then
            s2 := '';
          if FItemEnd > FItemBegin + 1 then
            s2 := FormatDateTime(FDateTimeFormat, DateTime);
          if (s2 <> '') then
            s1 := s1 + ' - ' + s2;
          Result := s1;
        end;
      end;
    plHalfDayPeriod:
      begin
        with FPlanner.FMode do
        begin
          DateTime := Trunc(FPlanner.Mode.PeriodStartDate + (FItemBegin - BeginOffset) / 2);

          s1 := FormatDateTime(FDateTimeFormat, DateTime);

          if Odd(FItemBegin - BeginOffset) then
            s1 := s1 + ' PM'
          else
            s1 := s1 + ' AM';

          DateTime := Trunc((FPlanner.Mode.PeriodStartDate + (FItemEnd - 1 + EndOffset) / 2));

          s2 := FormatDateTime(FDateTimeFormat, DateTime);
          if Odd(FItemEnd + EndOffset) then
            s2 := s2 + ' AM'
          else
            s2 := s2 + ' PM';

          Result := s1 + ' - ' + s2;
        end;
      end;
    plMultiMonth:
      begin
        Result := ItemStartTimeStr +  ' - ' + ItemEndTimeStr;
      end;
    plCustom, plCustomList:
      begin
        Result := ItemStartTimeStr +  ' - ' + ItemEndTimeStr;
      end;
  end;
end;

function TPlannerItem.GetCaptionString: string;
begin
  if RelationShip = irChild then
  begin
    Result := ParentItem.GetCaptionString;
    Exit;
  end;

  if CaptionType in [ctTime,ctTimeText] then
  begin
    Result := GetCaptionTimeString;
    if CaptionType = ctTimeText then
      Result := Result + ' ' + CaptionText;
  end
  else
    Result := CaptionText;
end;

function TPlannerItem.GetCaptionHeight: Integer;
begin
  Result := FCaptionHeight;
end;

procedure TPlannerItem.SetSelectColor(const Value: TColor);
begin
  if FSelectColor <> Value then
  begin
    FSelectColor := Value;
    Self.Repaint;
  end;
end;

procedure TPlannerItem.SetSelectFontColor(const Value: TColor);
begin
  if FSelectFontColor <> Value then
  begin
    FSelectFontColor := Value;
    Self.Repaint;
  end;
end;


procedure TPlannerItem.SetSelected(const Value: Boolean);
begin
  if FSelected <> Value then
  begin
    FSelected := Value;
    Self.Repaint;
  end;
end;

procedure TPlannerItem.SetShadow(const Value: Boolean);
begin
  if FShadow <> Value then
  begin
    FShadow := Value;
    Self.Repaint;
  end;
end;


procedure TPlannerItem.SetObject(const Value: TObject);
begin
  if FObject = Value then
    Exit;
  if FOwnsItemObject and Assigned(FObject) then
    FObject.Free;
  FObject := Value;
end;

procedure TPlannerItem.SetInHeader(const Value: Boolean);
begin
  if FInHeader <> Value then
  begin
    FInHeader := Value;
    FVisible := not FInHeader;

    Self.Repaint;
    FPlanner.FHeader.Invalidate;
    FPlanner.FGrid.Invalidate;

    if FPlanner.FPlannerHeader.AutoSize then
      FPlanner.AutoSizeHeader;

    FPlanner.Items.SetConflicts;
    FPlanner.FGrid.Invalidate;
  end;
end;

procedure TPlannerItem.SetItemBeginPrecis(const Value: Integer);
begin
  FItemBeginPrecis := Value;
  ItemBegin := (FItemBeginPrecis div FPlanner.Display.DisplayUnit) -
    FPlanner.Display.DisplayStart;
end;

procedure TPlannerItem.SetItemEndPrecis(const Value: Integer);
begin
  FItemEndPrecis := Value;
  ItemEnd := (FItemEndPrecis div FPlanner.Display.DisplayUnit) -
    FPlanner.Display.DisplayStart;
end;

procedure TPlannerItem.SetTrackVisible(const Value: Boolean);
begin
  FTrackVisible := Value;
  Repaint;
end;

procedure TPlannerItem.SetShape(const Value: TPlannerShape);
begin
  FShape := Value;
  Repaint;
end;

procedure TPlannerItem.SetPopupMenu(const Value: TPopupMenu);
begin
  FPopupMenu := Value;
end;

procedure TPlannerItem.SetShowSelection(const Value: Boolean);
begin
  FShowSelection := Value;
  Repaint;
end;

procedure TPlannerItem.GetTimeTag;
begin
  ItemBeginPrecis := LoWord(DBTag);
  ItemEndPrecis := HiWord(DBTag);
  FRepainted := False;
end;

procedure TPlannerItem.SetTimeTag;
begin
  ItemBegin := ItemBegin;
  ItemEnd := ItemEnd;
  DBTag := MakeLong(ItemBeginPrecis,ItemEndPrecis);
end;

procedure TPlannerItem.Update;
begin
  FPlanner.UpdateItem(Self);
end;

function TPlannerItem.GetItemText: string;
var
  Index: Integer;
begin
  Result := '';
  for Index := 0 to Text.Count - 1 do
  begin
    if Result <> '' then Result := Result + #13;
    Result := Result + Text.Strings[Index];
  end;
end;

procedure TPlannerItem.SetWordWrap(const Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Self.Repaint;
  end;
end;

procedure TPlannerItem.SetAttachement(const Value: string);
begin
  if FAttachement <> Value then
  begin
    FAttachement := Value;
    Self.Repaint;
  end;
end;

procedure TPlannerItem.MoveItem(NewBegin, NewEnd, NewPos: Integer; var NewOffset: Integer);
var
  Delta,W: Integer;
begin
  if Assigned(FPlanner.OnItemPlaceUpdate) then
    FPlanner.OnItemPlaceUpdate(FPlanner,Self,NewBegin,NewEnd,NewPos);

  Delta := NewBegin - ItemBegin;

  W := newend- newbegin + beginoffset;

  RealTime := False;

{$IFDEF CODESITE}
  CodeSite.SendInteger('Moved Begin:',NewBegin);
  CodeSite.SendInteger('Moved End:',NewEnd);
  CodeSite.SendInteger('Delta:',Delta);
{$ENDIF}

  if BeginOffset <> 0 then
  begin
    BeginOffset := BeginOffset - Delta;

    If BeginOffset < 0 then
    begin
      NewBegin := ItemBegin + BeginOffset;
      NewEnd := NewBegin + W;
      BeginOffset := 0;
      NewOffset := NewOffset - Delta;
    end
    else
    begin
      NewBegin := NewBegin - Delta;
      NewOffset := NewOffset - Delta;
    end;
  end;

  if EndOffset <> 0 then
  begin
    EndOffset := EndOffset + Delta;

    if EndOffset < 0 then
    begin
      NewEnd := ItemEnd + EndOffset;
      EndOffset := 0;
    end
    else
    begin
      NewEnd := NewEnd - Delta;
      NewOffset := NewOffset;
    end;
  end;

  if NewBegin < 0 then
  begin
    BeginOffset := -NewBegin;
    NewBegin := 0;
    NewOffset := NewOffset - Delta;
  end;

  if FPlanner.Sidebar.Position = spTop then
  begin
    if NewEnd > FPlanner.FGrid.ColCount then
    begin
      EndOffset := NewEnd - FPlanner.FGrid.ColCount;
      NewEnd := FPlanner.FGrid.ColCount;
    end;
  end
  else
  begin
    if NewEnd > FPlanner.FGrid.RowCount then
    begin
      EndOffset := NewEnd - FPlanner.FGrid.RowCount;
      NewEnd := FPlanner.FGrid.RowCount;
    end;
  end;

{$IFDEF TMSCODESITE}
  CodeSite.SendInteger('NewBegin:',NewBegin);
  CodeSite.SendInteger('NewEnd:',NewEnd);
{$ENDIF}
  ItemBegin := NewBegin;
  ItemEnd := NewEnd;
  ItemPos := NewPos;
end;

procedure TPlannerItem.SizeItem(NewBegin, NewEnd: Integer);
var
  NewPos: Integer;
begin
  RealTime := False;

  NewPos := ItemPos;

  if Assigned(FPlanner.OnItemPlaceUpdate) then
    FPlanner.OnItemPlaceUpdate(FPlanner,Self,NewBegin,NewEnd,NewPos);

  if ItemBegin <> NewBegin then
    ItemBegin := NewBegin;
  if ItemEnd <> NewEnd then
    ItemEnd := NewEnd;
  if ItemPos <> NewPos then
    ItemPos := NewPos;
end;

function TPlannerItem.GetItemRealEndTime: TDateTime;
begin
  if RealTime or InHeader then
    Result := FItemRealEndTime
  else
    Result := ItemEndTime;
end;

function TPlannerItem.GetItemRealStartTime: TDateTime;
begin
  if RealTime then
    Result := FItemRealStartTime
  else
    Result := ItemStartTime;
end;

procedure TPlannerItem.SetURL(const Value: string);
begin
  if FURL <> Value then
  begin
    FURL := Value;
    Self.Repaint;
  end;
end;

procedure TPlannerItem.SetAlarm(const Value: TPlannerAlarm);
begin
  FAlarm.Assign(Value);
end;

function TPlannerItem.GetStrippedItemText: string;
begin
  Result := HTMLStrip(GetItemText);
end;

procedure TPlannerItem.SetFlashing(const Value: Boolean);
begin
  if FFlashing <> Value then
  begin
    FFlashing := Value;
    if not FFlashing then Repaint;
  end;
end;

procedure TPlannerItem.Changed;
begin
  FPlanner.Items.ItemChanged(Self);
end;

procedure TPlannerItem.ChangeCrossing;
var
  delta: Integer;
begin
  delta := ItemEnd + EndOffset - ItemBegin;

  BeginOffset := - (ItemBegin - 1440 div Planner.Display.DisplayUnit);
  ItemBegin := 0;
  EndOffset := 0;
  ItemEnd := delta - BeginOffset;
end;

function TPlannerItem.Planner: TCustomPlanner;
begin
  Result := (Collection as TPlannerItems).FOwner;
end;

function TPlannerItem.GetParentItem: TPlannerItem;
var
  i: Integer;
begin
  Result := Self;
  if (ParentIndex = -1) or (RelationShip = irParent) then
    Result := Self
  else
    for i := 1 to (Collection as TPlannerItems).Count do
    begin
      if ((Collection as TPlannerItems).Items[i - 1].ParentIndex = ParentIndex) and
         ((Collection as TPlannerItems).Items[i - 1].RelationShip = irParent) then
      begin
        Result := (Collection as TPlannerItems).Items[i - 1];
        Break;
      end;
    end;
end;

function TPlannerItem.GetValue(ID: string; var Value: string): Boolean;
begin
  Result := GetControlValue(Text.Text,ID,Value);
end;

function TPlannerItem.SetValue(ID, Value: string): Boolean;
var
  s:string;
begin
  s := Text.Text;
  Result := SetControlValue(s,ID,Value);
  if Result then
    Text.Text := s;
end;

function TPlannerItem.GetCanEdit: Boolean;
begin
  Result := ReadOnly or (InplaceEdit = peForm);

end;

procedure TPlannerItem.EnsureFullVisibility;
begin
  if FPlanner.Sidebar.Position = spTop then
  begin
    if ItemBegin < FPlanner.FGrid.LeftCol then
     FPlanner.FGrid.LeftCol := ItemBegin;

    if ItemEnd > FPlanner.FGrid.LeftCol + FPlanner.FGrid.VisibleColCount then
     FPlanner.FGrid.LeftCol := ItemEnd - FPlanner.FGrid.VisibleColCount;
  end
  else
  begin
    if ItemBegin < FPlanner.FGrid.TopRow then
     FPlanner.FGrid.TopRow := ItemBegin;

    if ItemEnd > FPlanner.FGrid.TopRow + FPlanner.FGrid.VisibleRowCount then
     FPlanner.FGrid.TopRow := ItemEnd - FPlanner.FGrid.VisibleRowCount;
  end;
end;



procedure TPlannerItem.SetCaptionBkgTo(const Value: TColor);
begin
  if (FCaptionBkgTo <> Value) then
  begin
    FCaptionBkgTo := Value;
    Repaint;
  end;
end;

procedure TPlannerItem.SetDrawTool(const Value: TCustomItemDrawTool);
begin
  if (FDrawTool <> Value) then
  begin
    FDrawTool := Value;
    Repaint;
  end;  
end;

procedure TPlannerItem.SetCompletion(const Value: Integer);
begin
  if Value > 100 then
    raise Exception.Create('Completion cannot be larger than 100');

  if Value < 0 then
    raise Exception.Create('Completion cannot be smaller than 0');

  if (FCompletion <> Value) then
  begin
    FCompletion := Value;
    Repaint;
  end;

end;

procedure TPlannerItem.CompletionAdapt(var R:TRect);
begin
  if CompletionDisplay = cdVertical then
    r.Left := r.Left + 11;

  if CompletionDisplay = cdHorizontal then
    r.Top := r.Top + 11;
end;

procedure TPlannerItem.SetCompletionDisplay(
  const Value: TCompletionDisplay);
begin
  if (FCompletionDisplay <> Value) then
  begin
    FCompletionDisplay := Value;
    Repaint;
  end;
end;

{ TPlannerItems }

function TPlannerItems.Add: TPlannerItem;
begin
  Result := TPlannerItem(inherited Add);
  Result.Assign(FOwner.DefaultItem);
  SetConflicts;
end;

constructor TPlannerItems.Create(AOwner: TCustomPlanner);
begin
  inherited Create(GetItemClass);
  FOwner := AOwner;
  FSelected := nil;
  FUpdateCount := 0;
end;

function TPlannerItems.GetItem(Index: Integer): TPlannerItem;
begin
  Result := TPlannerItem(inherited GetItem(Index));
end;

{$IFNDEF VER90}

function TPlannerItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;
{$ENDIF}

function TPlannerItems.CheckItems: Boolean;
var
  i: Integer;
begin
  Result := True;

  if not Assigned(FOwner.ItemChecker) then
    Exit;

  FOwner.ItemChecker.StartCheck;

  for i := 1 to Count do
    if not CheckItem(Items[i - 1]) then
      Result := False;

  FOwner.ItemChecker.StopCheck;
end;

function TPlannerItems.CheckPosition(Position: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;

  if not Assigned(FOwner.ItemChecker) then
    Exit;

  FOwner.ItemChecker.StartCheck;

  for i := 1 to Count do
    if Items[i - 1].ItemPos = Position then
      if not CheckItem(Items[i - 1]) then
        Result := False;

  FOwner.ItemChecker.StopCheck;
end;

function TPlannerItems.CheckLayer(Layer: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;

  if not Assigned(FOwner.ItemChecker) then
    Exit;

  FOwner.ItemChecker.StartCheck;

  for i := 1 to Count do
    if Items[i - 1].Layer and Layer = Layer then
      if not CheckItem(Items[i - 1]) then
        Result := False;

  FOwner.ItemChecker.StopCheck;
end;

function TPlannerItems.CheckItem(Item: TPlannerItem): Boolean;
var
  Corr: string;
begin
  Result := True;

  if Assigned(FOwner.ItemChecker) then
  begin
    Item.Selected := True;
                                                             
    if FOwner.ItemChecker.UseCorrect then
    begin
      Corr := FOwner.ItemChecker.Correct(HTMLStrip(Item.Text.Text));
      if Corr <> Item.Text.Text then
        Result := False;
      Item.Text.Text := Corr;
    end;

    if FOwner.ItemChecker.UseMarkError then
    begin
      Corr := FOwner.ItemChecker.MarkError(Item.Text.Text);
      if Corr <> Item.Text.Text then
        Result := False;
      Item.Text.Text := Corr;
    end;

    Item.Selected := False;    
  end;

end;


function TPlannerItems.Insert(Index: Integer): TPlannerItem;
begin
{$IFDEF DELPHI2COLLECTION}
  Result := TPlannerItem(inherited Add);
{$ELSE}
  Result := TPlannerItem(inherited Insert(Index));
{$ENDIF}
  Result.Assign(FOwner.DefaultItem);
end;

function TPlannerItems.HasItem(ItemBegin, ItemEnd, ItemPos: Integer): Boolean;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := False;

  for ItemIndex := 0 to Self.Count - 1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    if (
      ((APlannerItem.ItemBegin <= ItemBegin) and (APlannerItem.ItemEnd > ItemBegin)) or
      ((APlannerItem.ItemBegin < ItemEnd) and (APlannerItem.ItemEnd >= ItemEnd)) or
      ((ItemBegin < APlannerItem.ItemEnd) and (ItemEnd >= APlannerItem.ItemEnd)) or
      ((ItemBegin <= APlannerItem.ItemBegin) and (ItemEnd > APlannerItem.ItemBegin))
      ) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and (APlannerItem <> Selected)
      and (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Result := (not APlannerItem.AllowOverlap) or (not FOwner.FOverlap);
      if Result then
        Break;
    end;
  end;
end;

function TPlannerItems.FindFirst(ItemBegin, ItemEnd, ItemPos: Integer):
TPlannerItem;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;

begin
  Result := nil;

  FFindIndex := 1;

  for ItemIndex := 1 to Self.Count do
  begin
    APlannerItem := Self.Items[ItemIndex - 1];
    if (
      ((APlannerItem.ItemBegin <= ItemBegin) and (APlannerItem.ItemEnd > ItemBegin)) or
      ((APlannerItem.ItemBegin < ItemEnd) and (APlannerItem.ItemEnd >= ItemEnd)) or
      ((ItemBegin < APlannerItem.ItemEnd) and (ItemEnd >= APlannerItem.ItemEnd)) or
      ((ItemBegin <= APlannerItem.ItemBegin) and (ItemEnd > APlannerItem.ItemBegin))
      )
      and (APlannerItem.ItemPos = ItemPos) then
    begin
      Result := APlannerItem;
      FFindIndex := ItemIndex + 1;
      Break;
    end;
  end;
end;

function TPlannerItems.FindNext(ItemBegin, ItemEnd, ItemPos: Integer):
TPlannerItem;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;

begin
  Result := nil;

  for ItemIndex := FFindIndex to Self.Count do
  begin
    APlannerItem := Self.Items[ItemIndex - 1];
    if (
      ((APlannerItem.ItemBegin <= ItemBegin) and (APlannerItem.ItemEnd > ItemBegin)) or
      ((APlannerItem.ItemBegin < ItemEnd) and (APlannerItem.ItemEnd >= ItemEnd)) or
      ((ItemBegin < APlannerItem.ItemEnd) and (ItemEnd >= APlannerItem.ItemEnd)) or
      ((ItemBegin <= APlannerItem.ItemBegin) and (ItemEnd > APlannerItem.ItemBegin))
      )
      and (APlannerItem.ItemPos = ItemPos) then
    begin
      FFindIndex := ItemIndex + 1;
      Result := APlannerItem;
      Break;
    end;
  end;
end;

procedure TPlannerItems.ClearSelectedRepaints(ItemBegin,ItemPos: Integer);
var
  ItemIndex,ItemEnd: Integer;
  APlannerItem: TPlannerItem;
begin
  ItemEnd := ItemBegin + 1;
  for ItemIndex := 0 to Self.Count - 1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    if (

      ((ItemBegin >= APlannerItem.ItemBegin) and (ItemBegin < APlannerItem.ItemEnd)) or
      ((ItemEnd > APlannerItem.ItemBegin) and (ItemEnd < APlannerItem.ItemEnd)) or
      ((APlannerItem.ItemBegin >= ItemBegin) and (APlannerItem.ItemBegin < ItemEnd)) or
      ((APlannerItem.ItemEnd > ItemBegin) and (APlannerItem.ItemEnd <= ItemEnd))

      ) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      APlannerItem.Repainted := False;
    end;
  end;
end;

function TPlannerItems.NumItem(ItemBegin, ItemEnd, ItemPos: Integer): TPoint;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result.X := 0;
  Result.Y := 0;
  for ItemIndex := 0 to Self.Count - 1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    if (

      ((ItemBegin >= APlannerItem.ItemBegin) and (ItemBegin < APlannerItem.ItemEnd)) or
      ((ItemEnd > APlannerItem.ItemBegin) and (ItemEnd < APlannerItem.ItemEnd)) or
      ((APlannerItem.ItemBegin >= ItemBegin) and (APlannerItem.ItemBegin < ItemEnd)) or
      ((APlannerItem.ItemEnd > ItemBegin) and (APlannerItem.ItemEnd <= ItemEnd))

      ) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
      (InVisibleLayer(APlannerItem.Layer)) and (APlannerItem.ItemEnd > APlannerItem.ItemBegin) then
    begin
      Inc(Result.X);
      if APlannerItem.FConflicts > Result.Y then
        Result.Y := APlannerItem.FConflicts;
      if ItemBegin > APlannerItem.ItemBegin then
        ItemBegin := APlannerItem.ItemBegin;
      if ItemEnd < APlannerItem.ItemEnd then
        ItemEnd := APlannerItem.ItemEnd;
    end;
  end;
end;

function TPlannerItems.NumItemPos(ItemBegin, ItemEnd, ItemPos: Integer): TPoint;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result.X := 0;
  Result.Y := 0;
  for ItemIndex := 0 to Self.Count-1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    if (
      ((APlannerItem.ItemBegin <= ItemBegin) and (APlannerItem.ItemEnd > ItemBegin)) or
      ((APlannerItem.ItemBegin < ItemEnd) and (APlannerItem.ItemEnd >= ItemEnd)) or
      ((ItemBegin < APlannerItem.ItemEnd) and (ItemEnd >= APlannerItem.ItemEnd)) or
      ((ItemBegin <= APlannerItem.ItemBegin) and (ItemEnd > APlannerItem.ItemBegin))
      ) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Inc(Result.X);
      if APlannerItem.FConflictPos > Result.Y then
        Result.Y := APlannerItem.FConflictPos;
    end;
  end;
end;

function TPlannerItems.NumItemPosStart(ItemBegin, ItemPos: Integer): Integer;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := 0;
  for ItemIndex := 0 to Self.Count-1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    if (APlannerItem.ItemBegin = ItemBegin) and
       (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
       (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Inc(Result);
    end;
  end;
end;


function TPlannerItems.FindItem(ItemBegin, ItemPos: Integer): TPlannerItem;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;
  for ItemIndex := 0 to Self.Count - 1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    if (APlannerItem.ItemBegin <= ItemBegin) and
      (APlannerItem.ItemEnd > ItemBegin) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Result := APlannerItem;
      Break;
    end;
  end;
end;

function TPlannerItems.FindItemIdx(ItemBegin: Integer): TPlannerItem;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;
  for ItemIndex := 0 to Self.Count - 1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    if (APlannerItem.ItemBegin <= ItemBegin) and
      (APlannerItem.ItemEnd > ItemBegin) and
      (APlannerItem.Visible) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Result := APlannerItem;
      Break;
    end;
  end;
end;


function TPlannerItems.FindItemPos(ItemBegin, ItemPos, ItemSubPos: Integer): TPlannerItem;
var
  ItemIndex, w, wo: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;

  if FOwner.Sidebar.Orientation = soVertical then
    wo := FOwner.FGrid.ColWidthEx(ItemPos)
  else
    wo := FOwner.FGrid.RowHeightEx(ItemPos);

  for ItemIndex := 0 to Self.Count-1 do
  begin
    APlannerItem := Self.Items[ItemIndex];

    if (APlannerItem.ItemBegin <= ItemBegin) and
      (APlannerItem.ItemEnd > ItemBegin) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
      not (APlannerItem.Background and APlannerItem.AllowOverlap) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      if APlannerItem.FConflicts > 1 then
        w := wo div APlannerItem.FConflicts
      else
        w := wo;
      if (ItemSubPos > APlannerItem.FConflictPos * w) and
         (ItemSubPos < (APlannerItem.FConflictPos + 1) * w - FOwner.FItemGap)
      then
      begin
        Result := APlannerItem;
        Break;
      end;
    end;
  end;
end;

function TPlannerItems.FindBkgPos(ItemBegin, ItemPos, ItemSubPos: Integer): TPlannerItem;
var
  ItemIndex, w, wo: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;

  if FOwner.Sidebar.Orientation = soVertical then
    wo := FOwner.FGrid.ColWidthEx(ItemPos)
  else
    wo := FOwner.FGrid.RowHeightEx(ItemPos);

  for ItemIndex := 0 to Self.Count-1 do
  begin
    APlannerItem := Self.Items[ItemIndex];

    if (APlannerItem.ItemBegin <= ItemBegin) and
      (APlannerItem.ItemEnd > ItemBegin) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
      (APlannerItem.Background and APlannerItem.AllowOverlap) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      if APlannerItem.FConflicts > 1 then
        w := wo div APlannerItem.FConflicts
      else
        w := wo;
      if (ItemSubPos > APlannerItem.FConflictPos * w) and
         (ItemSubPos < (APlannerItem.FConflictPos + 1) * w - FOwner.FItemGap)
      then
      begin
        Result := APlannerItem;
        Break;
      end;
    end;
  end;
end;



function TPlannerItems.FindItemPosIdx(ItemBegin, ItemPos, ItemSubPos: Integer): TPlannerItem;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;
  for ItemIndex := 0 to Self.Count - 1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    if (APlannerItem.ItemBegin <= ItemBegin) and
      (APlannerItem.ItemEnd > ItemBegin) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
      not (APlannerItem.Background and APlannerItem.AllowOverlap) and
      (APlannerItem.FConflictPos = ItemSubPos) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Result := APlannerItem;
      Break;
    end;
  end;
end;

function TPlannerItems.FindItemIndex(ItemBegin, ItemPos, ItemSubIdx: Integer): TPlannerItem;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;
  for ItemIndex := 0 to Self.Count - 1 do
  begin
    APlannerItem := Self.Items[ItemIndex];

    if (APlannerItem.ItemBegin <= ItemBegin) and
      (APlannerItem.ItemEnd > ItemBegin) and
      (APlannerItem.ItemPos = ItemPos) and
      (APlannerItem.FConflictPos = ItemSubIdx) and
      (APlannerItem.Visible) and
      not (APlannerItem.Background and APlannerItem.AllowOverlap) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Result := APlannerItem;
      Break;
    end;
  end;
end;

function TPlannerItems.FindBackground(ItemBegin, ItemPos: Integer): TPlannerItem;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;
  for ItemIndex := 0 to Self.Count - 1 do
  begin
    APlannerItem := Self.Items[ItemIndex];

    if (APlannerItem.ItemBegin <= ItemBegin) and
      (APlannerItem.ItemEnd > ItemBegin) and
      (APlannerItem.ItemPos = ItemPos) and
      (APlannerItem.AllowOverlap) and
      (APlannerItem.Visible) and (APlannerItem.Background) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Result := APlannerItem;
      Break;
    end;
  end;
end;


function TPlannerItems.QueryItem(Item: TPlannerItem; ItemBegin, ItemPos:
  Integer): TPlannerItem;
var
  ItemIndex, StartIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;
  if Assigned(Item) then
    StartIndex := Item.Index + 2
  else
    StartIndex := 1;

  for ItemIndex := StartIndex to Self.Count do
  begin
    APlannerItem := Self.Items[ItemIndex - 1];
    if (APlannerItem.ItemBegin <= ItemBegin) and
      (APlannerItem.ItemEnd > ItemBegin) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Result := APlannerItem;
      Break;
    end;
  end;
end;

procedure TPlannerItems.SetCurrent(ItemCurrent: Integer);
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  for ItemIndex := 0 to Self.Count - 1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    APlannerItem.IsCurrent := (APlannerItem.ItemBegin <= ItemCurrent) and
      (APlannerItem.ItemEnd > ItemCurrent) and
      not APlannerItem.InHeader and APlannerItem.Planner.IsCurPos(APlannerItem.ItemPos);
  end;
end;

function TPlannerItems.FocusItem(ItemBegin, ItemPos, ItemSubPos: Integer; Control:
  Boolean): TPlannerItem;
var
  ItemIndex, w: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;
  FSelected := nil;

  for ItemIndex := 0 to Self.Count - 1 do
  begin
    if FOwner.Sidebar.Orientation = soVertical then
      w := FOwner.FGrid.ColWidthEx(ItemPos)
    else
      w := FOwner.FGrid.RowHeightEx(ItemPos);

    APlannerItem := Self.Items[ItemIndex];
    if (APlannerItem.ItemBegin <= ItemBegin) and
      (APlannerItem.ItemEnd > ItemBegin) and
      (APlannerItem.ItemPos = ItemPos) and
      (APlannerItem.Visible) and
      not (APlannerItem.Background and APlannerItem.AllowOverlap) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      if APlannerItem.FConflicts > 1 then
        w := w div APlannerItem.FConflicts;
      if (ItemSubPos > APlannerItem.FConflictPos * w) and (ItemSubPos <
        (APlannerItem.FConflictPos + 1) * w) then
      begin
        Result := APlannerItem;
        APlannerItem.Focus := True;
        if Control and APlannerItem.Selected then
          APlannerItem.Selected := False
        else
          APlannerItem.Selected := True;
        FSelected := APlannerItem;
      end
      else
      begin
        APlannerItem.Focus := False;
        if not Control or not FOwner.MultiSelect then
          APlannerItem.Selected := False;
      end;
    end
    else
    begin
      APlannerItem.Focus := False;
      if not Control or not FOwner.MultiSelect then
        APlannerItem.Selected := False;
    end;
  end;
end;

procedure TPlannerItems.UnSelect;
begin
  if Assigned(FSelected) then
  begin
    FSelected.Focus := False;
    FSelected.Selected := False;
    FSelected := nil;
  end;
end;

procedure TPlannerItems.UnSelectAll;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  with Items[i] do
  begin
    Focus := False;
    Selected := False;
  end;
  Selected := nil;
end;


function TPlannerItems.SelectNext: TPlannerItem;
var
  idx: Integer;
begin
  if FSelected <> nil then
  begin
    FSelected.Focus := False;
    FSelected.Selected := False;
    idx := FSelected.Index;
    while idx + 1 < Self.Count do
    begin
      if not (Self.Items[idx + 1].Background) then
      begin
        FSelected := Self.Items[idx + 1];
        FSelected.Selected := True;
        Break;
      end
      else
        inc(idx);
    end;
    if (idx + 1 = Self.Count) then
      FSelected := nil;
  end
  else
  begin
    if (Self.Count > 0) then
    begin
      FSelected := Self.Items[0];
      FSelected.Focus := True;
      FSelected.Selected := True;
    end;
  end;
  if Assigned(FSelected) then
    FSelected.Focus := True;
  Result := FSelected;
end;

function TPlannerItems.SelectPrev: TPlannerItem;
var
  idx: Integer;
begin
  if FSelected <> nil then
  begin
    FSelected.Focus := False;
    FSelected.Selected := False;
    idx := FSelected.Index;
    while idx > 0 do
    begin
      if not Self.Items[idx - 1].Background then
      begin
        FSelected := Self.Items[idx - 1];
        FSelected.Selected := True;
        Break;
      end
      else
        dec(idx);
    end;
    if (idx < 0) then
      FSelected := nil;
  end
  else
  begin
    if Self.Count > 0 then
    begin
      FSelected := Self.Items[Self.Count - 1];
      FSelected.Selected := True;
    end;
  end;
  if Assigned(FSelected) then
    FSelected.Focus := True;
  Result := FSelected;
end;

function TPlannerItems.InVisibleLayer(Layer: Integer): Boolean;
begin
  Result := (FOwner.Layer = 0) or ((FOwner.Layer > 0) and (Layer and FOwner.Layer
    > 0));
end;

procedure TPlannerItems.SetItem(Index: Integer; Value: TPlannerItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TPlannerItems.ClearPosition(Position: Integer);
var
  ItemIndex: Integer;
begin
  BeginUpdate;
  for ItemIndex := Count downto 1 do
  begin
    if Items[ItemIndex - 1].ItemPos = Position then
      Items[ItemIndex - 1].Free
  end;
  EndUpdate;
end;

procedure TPlannerItems.ClearLayer(Layer: Integer);
var
  ItemIndex: Integer;
begin
  BeginUpdate;
  for ItemIndex := Count downto 1 do
  begin
    if Items[ItemIndex - 1].Layer = Layer then
      Items[ItemIndex - 1].Free
  end;
  EndUpdate;
end;

procedure TPlannerItems.BeginUpdate;
begin
  inherited;
  Inc(FUpdateCount);
end;

procedure TPlannerItems.EndUpdate;
begin
  if FUpdateCount > 0 then Dec(FUpdateCount);
  if FUpdateCount = 0 then
  begin
    SetConflicts;
    FOwner.FGrid.Invalidate;
  end;
  inherited;
end;

procedure TPlannerItems.ResetUpdate;
var
  i: Integer;
begin
  if FUpdateCount > 0 then Dec(FUpdateCount);
  if FUpdateCount = 0 then
  begin
    SetConflicts;
    ClearRepaints;
    for i := 1 to Count do
      if Items[i - 1].FChanged then
        Items[i - 1].Repaint;
  end;
end;

procedure TPlannerItems.SetConflicts;
type
  tbp = record
    X, Y,Z: Byte;
  end;

  {$IFDEF DELPHI5_LVL}
  confarray = array of array of tbp;
  {$ENDIF}

var
  {$IFDEF DELPHI5_LVL}
  conf: confarray;
  {$ELSE}
  conf: array[0..MAX_COLS, 0..MAX_ROWS] of tbp;
  {$ENDIF}

  i, j, k, m, n, mm, NumRows: Integer;
  flg: Boolean;

  function IsOverlapping(APlannerItem: TPlannerItem; ItemBegin: Integer):boolean;
  begin
    Result := False;

    if (APlannerItem.ItemBegin <= ItemBegin) and
       (APlannerItem.ItemEnd > ItemBegin) and
       (APlannerItem.Visible) and
       not (APlannerItem.Background and APlannerItem.AllowOverlap) and
       (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Result := True;
    end;
  end;

begin
  if FUpdateCount > 0 then
    Exit;

  if Count = 0 then
    Exit;

  for i := 1 to Count do
  with Items[i - 1] do
    begin
      FBeginExt := ItemBegin;
      FEndExt := ItemEnd;
      FChanged := False;
    end;

  {Clear counters of overlapping Items}

  {$IFDEF DELPHI5_LVL}
  if FOwner.SideBar.Orientation = soVertical then
  begin
    SetLength(conf,FOwner.FGrid.ColCount + 1,FOwner.FGrid.RowCount + 1);
    NumRows := FOwner.FGrid.RowCount + 1;
  end
  else
  begin
    SetLength(conf,FOwner.FGrid.RowCount + 1,FOwner.FGrid.ColCount + 1);
    NumRows := FOwner.FGrid.ColCount + 1;
  end;
  {$ELSE}
  FillChar(Conf,SizeOf(Conf),0);
  NumRows := MAX_ROWS;
  {$ENDIF}

  {Calculate worst-case item overlap count}

  for i := 1 to Count do
  begin
    m := 0;                 // +++1.6b+++
    if Items[i - 1].Visible and not (Items[i - 1].Background and Items[i - 1].AllowOverlap) then
      for j := 1 to Count do
      begin
        if (i <> j) and (Items[j - 1].ItemPos = Items[i - 1].ItemPos) then
        for k := Items[i - 1].ItemBegin to Items[i - 1].ItemEnd - 1 do
        begin
          if IsOverlapping(Items[j - 1], k) then
          begin
            if Items[j - 1].FBeginExt < Items[i - 1].FBeginExt then
               Items[i - 1].FBeginExt := Items[j - 1].FBeginExt
            else
               Items[j - 1].FBeginExt := Items[i - 1].FBeginExt;

            if Items[j - 1].FEndExt > Items[i - 1].FEndExt then
               Items[i - 1].FEndExt := Items[j - 1].FEndExt
            else
               Items[j - 1].FEndExt := Items[i - 1].FEndExt;

            Inc(m);
            Break;
          end;

        end;
      end;

    Items[i - 1].FChanged := Items[i - 1].FConflicts <> m + 1;
    Items[i - 1].FConflicts := m + 1;
  end;

  {Count. nr of overlapping Items per cell}
  for i := 1 to Count do
  begin
    with Items[i - 1] do
    begin                                     // +++1.6b+++
      if Visible and InVisibleLayer(Layer) and not (Background and AllowOverlap) then
        for j := FBeginExt to FEndExt - 1 do
        begin
{$IFDEF DELPHI5_LVL}
          if (ItemPos < High(Conf)) and (ItemPos >=0) and (j < High(Conf[ItemPos])) then
{$ELSE}
          if (ItemPos < MAX_COLS) and (ItemPos >=0) and (j < MAX_ROWS) then
{$ENDIF}
            if Items[i - 1].FConflicts > Conf[ItemPos, j].X then
              Conf[ItemPos, j].X := Items[i - 1].FConflicts;
        end;
    end;
  end;


  {Assign Items conflicts & conflict positions}
  for i := 1 to Count do
  begin
    with Items[i - 1] do                   // +++1.6b+++
      if Visible and InVisibleLayer(Layer) and not (Background and AllowOverlap) then
      begin
        m := 0;
        mm := 0;

        {get last assigned conflict position}
        for j := ItemBegin to ItemEnd - 1 do
        begin
{$IFDEF DELPHI5_LVL}
          if (ItemPos < High(Conf)) and (ItemPos >=0) and (j < High(Conf[ItemPos])) then
{$ELSE}
          if (ItemPos < MAX_COLS) and (ItemPos >=0) and (j < MAX_ROWS) then
{$ENDIF}
          begin

            if (Conf[ItemPos, j].Y > m)   then
              m := Conf[ItemPos, j].Y;

            if (Conf[ItemPos, j].Z > mm)   then
              mm := Conf[ItemPos, j].Z;
          end;
        end;

        if mm = m then mm := 0;

        {get nr. of conflicts from extended zone}
        n := 0;
        for j := FBeginExt to FEndExt - 1 do
{$IFDEF DELPHI5_LVL}
          if (ItemPos < High(Conf)) and (ItemPos >=0) and (j < High(Conf[ItemPos])) then
{$ELSE}
          if (ItemPos < MAX_COLS) and (ItemPos >=0) and (j < MAX_ROWS) then
{$ENDIF}
            if Conf[ItemPos, j].X > n then
              n := Conf[ItemPos, j].X;

        {scan ... if Assigned Position 0,1,2}
        flg := (FConflicts <> n) or
               (FConflictPos <> m);

        FConflicts := n;

        if m < FConflicts then
        begin
          FChanged := FChanged or (FConflictPos <> m);
          FConflictPos := m
        end
        else
        begin
          FChanged := FChanged or (FConflictPos <> mm);
          FConflictPos := mm;
        end;

        if m >= FConflicts then
        begin
          mm := mm + 1;
          for j := ItemBegin to ItemEnd - 1 do
          begin
{$IFDEF DELPHI5_LVL}
            if (ItemPos < High(Conf)) and (ItemPos >=0) and (j < High(Conf[ItemPos])) then
{$ELSE}
            if (ItemPos < MAX_COLS) and (ItemPos >=0) and (j < MAX_ROWS) then
{$ENDIF}
              Conf[ItemPos, j].Z := mm;
          end;
        end;

        if m < FConflicts then
          m := m + 1;

        for j := ItemBegin to ItemEnd - 1 do
        begin
{$IFDEF DELPHI5_LVL}
          if (ItemPos < High(Conf)) and (ItemPos >=0) and (j < High(Conf[ItemPos])) then
{$ELSE}
          if (ItemPos < MAX_COLS) and (ItemPos >=0) and (j < MAX_ROWS) then
{$ENDIF}
            Conf[ItemPos, j].Y := m;
        end;

        if Flg then
          Repaint;
      end;
  end;

  {If better than worst case position found, optimize}
  for i := 1 to Count do
  begin
    with Items[i - 1] do
    begin
      m := 0;
      for j := 1 to NumRows do
{$IFDEF DELPHI5_LVL}
        if (ItemPos < High(Conf)) and (ItemPos >=0) and (j <= High(Conf[ItemPos])) then
{$ELSE}
        if (ItemPos < MAX_COLS) and (ItemPos >=0) and (j <= MAX_ROWS) then
{$ENDIF}
          if Conf[ItemPos, j - 1].Y > m then
            m := Conf[ItemPos, j - 1].Y;

      if FConflicts > m then
      begin
        FChanged := FChanged or (FConflicts <> m);
        FConflicts := m;
        Repaint;
      end;
    end;
  end;

end;

procedure TPlannerItems.ClearConflicts;
var
  ItemIndex: Integer;
begin
  for ItemIndex := 0 to Count-1 do
  begin
    Items[ItemIndex].FConflictPos := 0;
    Items[ItemIndex].FConflicts := 0;
  end;
end;

function TPlannerItems.NumConflicts(var ItemBegin, ItemEnd: Integer; ItemPos: Integer):
  Integer;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := 0;
  for ItemIndex := 0 to Self.Count-1 do
  begin
    APlannerItem := Self.Items[ItemIndex];
    if (
      ((APlannerItem.ItemBegin <= ItemBegin) and (APlannerItem.ItemEnd > ItemBegin)) or
      ((APlannerItem.ItemBegin < ItemEnd) and (APlannerItem.ItemEnd >= ItemEnd)) or
      ((ItemBegin < APlannerItem.ItemEnd) and (ItemEnd >= APlannerItem.ItemEnd)) or
      ((ItemBegin <= APlannerItem.ItemBegin) and (ItemEnd > APlannerItem.ItemBegin))
      ) and
      (APlannerItem.ItemPos = ItemPos) and (APlannerItem.Visible) and
      (InVisibleLayer(APlannerItem.Layer)) then
    begin
      Inc(Result);
      if APlannerItem.ItemBegin < ItemBegin then
        ItemBegin := APlannerItem.ItemBegin;
      if APlannerItem.ItemEnd > ItemEnd then
        ItemEnd := APlannerItem.ItemEnd;
    end;
  end;
end;

procedure TPlannerItems.CopyToClipboard;
var
  Clipboard: TClipboard;
  PlannerItemIO: TPlannerItemIO;
  MemStream: TMemoryStream;
  Data: THandle;
  DataPtr: Pointer;
begin
  Clipboard := TClipboard.Create;

  if Assigned(Selected) then
  begin
    Selected.ItemBegin := Selected.ItemBegin;
    Selected.ItemEnd := Selected.ItemEnd;
    Selected.DBTag := MakeLong(Selected.ItemBeginPrecis, Selected.ItemEndPrecis);

    PlannerItemIO := TPlannerItemIO.CreateItem(Self);
    PlannerItemIO.Item.Assign(Selected);

    MemStream := TMemoryStream.Create;
    try
      MemStream.WriteComponent(PlannerItemIO);

      Clipboard.Open;
      try
        Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, MemStream.Size);
        try
          DataPtr := GlobalLock(Data);
          try
            Move(MemStream.Memory^, DataPtr^, MemStream.Size);
            Clipboard.Clear;
            SetClipboardData(CF_PLANNERITEM, Data);
          finally
            GlobalUnlock(Data);
          end;
        except
          GlobalFree(Data);
          raise;
        end;
      finally
        Clipboard.Close;
      end;
    finally
      MemStream.Free;
    end;
    PlannerItemIO.Free;
  end;
  Clipboard.Free;
end;

procedure TPlannerItems.CutToClipboard;
begin
  CopyToClipboard;
  if Assigned(Selected) then
    FOwner.FreeItem(Selected);
end;

procedure TPlannerItems.PasteItem(Position: Boolean);
var
  Clipboard: TClipboard;
  PlannerItemIO: TPlannerItemIO;
  MemStream: TMemoryStream;
  Data: THandle;
  DataPtr: Pointer;

begin
  Clipboard := TClipboard.Create;

  Clipboard.Open;

  Data := 0;

  try
    Data := GetClipboardData(CF_PLANNERITEM);
    if Data = 0 then
      Exit;

    DataPtr := GlobalLock(Data);
    if DataPtr = nil then
      Exit;
    try
      MemStream := TMemoryStream.Create;
      MemStream.WriteBuffer(DataPtr^, GlobalSize(Data));
      MemStream.Position := 0;
      PlannerItemIO := TPlannerItemIO.CreateItem(Self);
      try
        MemStream.ReadComponent(PlannerItemIO);
        with PlannerItemIO.Item do
          if Position then
          begin
            ItemBegin := FOwner.SelItemBegin;
            ItemEnd := FOwner.SelItemEnd;
            ItemPos := FOwner.SelPosition;
          end
          else
          begin
            ItemBeginPrecis := LoWord(DBTag);
            ItemEndPrecis := HiWord(DBTag);
          end;

        FOwner.CreateItem.Assign(PlannerItemIO.Item);

      finally
        PlannerItemIO.Free;
        MemStream.Free;
      end;
    finally

    end;
  finally
    GlobalUnlock(Data);
  end;

  Clipboard.Close;
  Clipboard.Free;
end;

procedure TPlannerItems.PasteFromClipboard;
begin
  PasteItem(False);
end;

procedure TPlannerItems.PasteFromClipboardAtPos;
begin
  PasteItem(True);
end;

procedure TPlannerItems.OffsetItems(Offset: Integer);
var
  ItemIndex: Integer;
begin
  BeginUpdate;
  try
    for ItemIndex := 0 to Count - 1 do
    begin
      Items[ItemIndex].ItemBegin := Items[ItemIndex].ItemBegin + Offset;
      Items[ItemIndex].ItemEnd := Items[ItemIndex].ItemEnd + Offset;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TPlannerItems.MoveAll(DeltaPos, DeltaBegin: Integer);
var
  ItemIndex: Integer;
begin
  for ItemIndex := 0 to Count - 1 do
  begin
    Items[ItemIndex].ItemBegin := Clip(Items[ItemIndex].ItemBegin + DeltaBegin,
      FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
    Items[ItemIndex].ItemEnd := Clip(Items[ItemIndex].ItemEnd + DeltaBegin,
      FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
    Items[ItemIndex].ItemPos := Clip(Items[ItemIndex].ItemPos + DeltaPos,
      FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
  end;
end;

procedure TPlannerItems.MoveSelected(DeltaPos, DeltaBegin: Integer);
var
  ItemIndex: Integer;
begin
  for ItemIndex := 0 to Count - 1 do
  begin
    if Items[ItemIndex].Selected and not Items[ItemIndex].Focus then
    begin
      Items[ItemIndex].ItemBegin := Clip(Items[ItemIndex].ItemBegin + DeltaBegin,
        FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
      Items[ItemIndex].ItemEnd := Clip(Items[ItemIndex].ItemEnd + DeltaBegin,
        FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
      Items[ItemIndex].ItemPos := Clip(Items[ItemIndex].ItemPos + DeltaPos,
        FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
    end;
  end;
end;

procedure TPlannerItems.SizeAll(DeltaStart, DeltaEnd: Integer);
var
  ItemIndex: Integer;
begin
  for ItemIndex := 0 to Count - 1 do
  begin
    Items[ItemIndex].ItemBegin := Clip(Items[ItemIndex].ItemBegin + DeltaStart,
      FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
    Items[ItemIndex].ItemEnd := Clip(Items[ItemIndex].ItemEnd + DeltaEnd,
      FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
  end;
end;

procedure TPlannerItems.SizeSelected(DeltaStart, DeltaEnd: Integer);
var
  ItemIndex: Integer;
begin
  for ItemIndex := 0 to Count - 1 do
  begin
    if Items[ItemIndex].Selected and not Items[ItemIndex].Focus then
    begin
      Items[ItemIndex].ItemBegin := Clip(Items[ItemIndex].ItemBegin + DeltaStart,
        FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
      Items[ItemIndex].ItemEnd := Clip(Items[ItemIndex].ItemEnd + DeltaEnd,
        FOwner.Display.DisplayStart, FOwner.Display.DisplayEnd);
    end;
  end;
end;

procedure TPlannerItems.ClearRepaints;
var
  ItemIndex: Integer;
begin
  for ItemIndex := 0 to Count - 1 do
    Items[ItemIndex].Repainted := False;
end;


function TPlannerItems.HeaderFirst(ItemPos: Integer): TPlannerItem;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;
  FFindIndex := 1;

  for ItemIndex := 1 to Count do
  begin
    APlannerItem := Items[ItemIndex - 1];
    if (APlannerItem.ItemPos = ItemPos) and (APlannerItem.InHeader) then
    begin
      Result := APlannerItem;
      FFindIndex := ItemIndex + 1;
      Break;
    end;
  end;
end;

function TPlannerItems.HeaderNext(ItemPos: Integer): TPlannerItem;
var
  ItemIndex: Integer;
  APlannerItem: TPlannerItem;
begin
  Result := nil;
  for ItemIndex := FFindIndex to Count do
  begin
    APlannerItem := Items[ItemIndex - 1];
    if (APlannerItem.ItemPos = ItemPos) and (APlannerItem.FInHeader) then
    begin
      Result := APlannerItem;
      FFindIndex := ItemIndex + 1;
      Break;
    end;
  end;
end;


procedure TPlannerItems.ClearAll;
begin
  Clear;
  Selected := nil;
  FOwner.Invalidate;
end;

procedure TPlannerItems.ClearDB;
var
  i: Integer;
begin
  i := 0;
  while i < Count do
  begin
    if not Items[i].NonDBItem then
      Items[i].Free
    else
      inc(i);
  end;
end;

procedure TPlannerItems.GetTimeTags;
var
  i: Integer;
begin
  if not FOwner.FStreamPersistentTime then
    Exit;

  for i := 1 to Count do
    Items[i - 1].GetTimeTag;
end;

procedure TPlannerItems.SetTimeTags;
var
  i: Integer;
begin
  for i := 1 to Count do
    Items[i - 1].SetTimeTag;
end;

function TPlannerItems.FindKey(DBKey: string): TPlannerItem;
var
  i: Integer;
begin
  Result := Nil;

  for i := 1 to Count do
  begin
    if Items[i - 1].DBKey = DBKey then
    begin
      Result := Items[i - 1];
      Break;
    end;
  end;
end;

procedure TPlannerItems.Select(Item: TPlannerItem);
begin
  UnSelect;
  Item.Focus := True;
  Item.Selected := True;
  FSelected := Item;
  FOwner.ItemSelected(Item);
end;


function TPlannerItems.MatchItem(Item: TPlannerItem; s: string;
  Param: TFindTextParams): Boolean;
var
  SrchText: string;

begin
  Result := False;

  if fnCaptionText in Param then
  begin
    SrchText := Item.CaptionText;

    if fnIgnoreHTMLTags in Param then
      SrchText := HTMLStrip(SrchText);

    if not (fnMatchCase in Param) then
    begin
      SrchText := AnsiUpperCase(SrchText);
      s := AnsiUpperCase(s);
    end;

    if fnMatchFull in Param then
      Result := (s = SrchText)
    else
      if fnMatchStart in Param then
        Result := Pos(s,SrchText) = 1
      else
        if fnMatchRegular in Param then
          Result := MatchStr(s,SrchText,fnMatchCase in Param)
            else
              Result := Pos(s,SrchText) > 0;
  end;

  if Result then Exit;

  if fnText in Param then
  begin
    SrchText := Item.Text.Text;

    if fnIgnoreHTMLTags in Param then
      SrchText := HTMLStrip(SrchText);

    if not (fnMatchCase in Param) then
    begin
      SrchText := AnsiUpperCase(SrchText);
      s := AnsiUpperCase(s);
    end;

    if fnMatchFull in Param then
      Result := (s = SrchText)
    else
      if fnMatchStart in Param then
        Result := Pos(s,SrchText) = 1
      else
        if fnMatchRegular in Param then
          Result := MatchStr(s,SrchText,fnMatchCase in Param)
            else
              Result := Pos(s,SrchText) > 0;
  end;

end;

function TPlannerItems.FindText(StartItem: TPlannerItem; s: string;
  Param: TFindTextParams): TPlannerItem;
var
  i: Integer;

begin
  Result := nil;
  if Count = 0 then
    Exit;

  if not (fnBackward in Param) then
  begin
    i := 0;

    if Assigned(StartItem) then
    begin
      while i < Count do
      begin
        if Items[i] = StartItem then
          Break
        else
          Inc(i);
      end;

      if i < Count then
        Inc(i)
      else
        i := 0;
    end;

    while i < Count do
    begin
      if MatchItem(Items[i],s,Param) then
      begin
        Result := Items[i];
        if fnAutoGoto in Param then
        begin
          Items[i].ScrollInView;
          Items[i].SetFocus(True);
          Items[i].Selected := True;
        end;
        Break;
      end
      else
        inc(i);
  end;
  end
  else
  begin
    i := Count - 1;

    if Assigned(StartItem) then
    begin
      while i > 0 do
      begin
        if Items[i] = StartItem then
          Break
        else
          Dec(i);
      end;

      if i > 0 then
        Dec(i)
      else
        i := Count - 1;
    end;

    while i > 0 do
    begin
      if MatchItem(Items[i],s,Param) then
      begin
        Result := Items[i];
        if fnAutoGoto in Param then
        begin
          Items[i].ScrollInView;
          Items[i].SetFocus(True);
          Items[i].Selected := True;
        end;
        Break;
      end
      else
        Dec(i);
    end;
  end;

end;

function TPlannerItems.MaxItemsInPos(Position: Integer): Integer;
var
  i,m : Integer;
  APlannerItem: TPlannerItem;
begin
  m := 1;
  for i := 1 to Count do
  begin
    APlannerItem := Items[i - 1];

    if (APlannerItem.ItemPos = Position) and (APlannerItem.Visible) and
       (InVisibleLayer(APlannerItem.Layer)) then
    begin
      if APlannerItem.Conflicts > m then
        m := APlannerItem.Conflicts;
    end;
  end;
  Result := m;
end;

function TPlannerItems.ItemsAtIndex(Idx: Integer): Integer;
var
  APlannerItem: TPlannerItem;
  i: Integer;
begin
  Result := 0;

  for i := 1 to Count do
  begin
    APlannerItem := Items[i - 1];
    if (APlannerItem.ItemBegin <= Idx) and (APlannerItem.ItemEnd > Idx)
     and APlannerItem.Visible and InVisibleLayer(APlannerItem.Layer) then
      Result := Result + 1;
  end;
end;

function TPlannerItems.ItemsAtPosition(Pos: Integer): Integer;
var
  APlannerItem: TPlannerItem;
  i: Integer;  
begin
  Result := 0;

  for i := 1 to Count do
  begin
    APlannerItem := Items[i - 1];
    if (APlannerItem.ItemPos = Pos) and APlannerItem.Visible and
       InVisibleLayer(APlannerItem.Layer) then
      Result := Result + 1;
  end;
end;

function TPlannerItems.GetItemClass: TCollectionItemClass;
begin
  Result := TPlannerItem;
end;

procedure TPlannerItems.ItemChanged(Item:TPlannerItem);
var
  i: Integer;

begin
  if FChanging then
    Exit;

  if Item.ParentIndex = -1 then
    Exit;

  FChanging := True;

  for i := 1 to Count do
  begin
    if (Items[i - 1] <> Item) and (Item.ParentIndex = Items[i - 1].ParentIndex) then
    begin
      Items[i - 1].AssignEx(Item);
    end;
  end;

  FChanging := False;
end;

function TPlannerItems.GetSelCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Count do
  begin
    if Items[i - 1].Selected then
      Inc(Result);
  end;
end;

{ TPlannerMemo }

procedure TPlannerMemo.DoEnter;
begin
  inherited;
end;

procedure TPlannerMemo.DoExit;
var
  s: string;
begin
  inherited;
  if Assigned(Lines) and Assigned(PlannerItem) then
  begin
    s := Lines.Text;
    PlannerItem.Text.Text := s;
    PlannerItem.FPlanner.ItemEdited(PlannerItem);
  end;
  Visible := False;
  Parent.SetFocus;
end;

procedure TPlannerMemo.WMPaste(var Msg:TMessage);
var
  s: string;
begin
  inherited;
  if Assigned(FPlannerItem.FPlanner.OnItemClipboardAction) then
  begin
    s := Lines.Text;
    FPlannerItem.FPlanner.OnItemClipboardAction(FPlannerItem.FPlanner,FPlannerItem,itPaste,s);
    if s <> Lines.Text then
      Lines.Text := s;
  end;
end;

procedure TPlannerMemo.WMCopy(var Msg:TMessage);
var
  s:string;
begin
  inherited;
  if Assigned(FPlannerItem.FPlanner.OnItemClipboardAction) then
  begin
    s := Lines.Text;
    FPlannerItem.FPlanner.OnItemClipboardAction(FPlannerItem.FPlanner,FPlannerItem,itCopy,s);
    if s <> Lines.Text then
      Lines.Text := s;
  end;
end;

procedure TPlannerMemo.WMCut(var Msg:TMessage);
var
  s:string;
begin
  inherited;
  if Assigned(FPlannerItem.FPlanner.OnItemClipboardAction) then
  begin
    s := Lines.Text;
    FPlannerItem.FPlanner.OnItemClipboardAction(FPlannerItem.FPlanner,FPlannerItem,itCut,s);
    if s <> Lines.Text then
      Lines.Text := s;
  end;
end;



procedure TPlannerMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = vk_Escape then
  begin
    Self.Lines.Assign(PlannerItem.Text);
    PlannerItem.FPlanner.SetFocus;
  end;
end;

procedure TPlannerMemo.DblClick;
begin
  inherited;
  if Assigned(FPlanner.OnItemDblClick) then
    FPlanner.OnItemDblClick(FPlanner, FPlannerItem);
end;

{ TPlannerMaskEdit }

procedure TPlannerMaskEdit.DoExit;
begin
  inherited;
  if Assigned(PlannerItem) then
  begin
    PlannerItem.Text.Text := Self.Text;

    PlannerItem.FPlanner.ItemEdited(PlannerItem);
  end;
  Self.Visible := False;
  Self.Parent.SetFocus;
end;

procedure TPlannerMaskEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = vk_Escape then
  begin
    Self.Text := PlannerItem.Text[0];
    PlannerItem.FPlanner.SetFocus;
  end;
end;

procedure TPlannerMaskEdit.WMPaste(var Msg:TMessage);
var
  s:string;
begin
  inherited;
  if Assigned(FPlannerItem.FPlanner.OnItemClipboardAction) then
  begin
    s := Text;
    FPlannerItem.FPlanner.OnItemClipboardAction(FPlannerItem.FPlanner,FPlannerItem,itPaste,s);
    if s <> Text then
      Text := s;
  end;
end;

procedure TPlannerMaskEdit.WMCopy(var Msg:TMessage);
var
  s:string;
begin
  inherited;
  if Assigned(FPlannerItem.FPlanner.OnItemClipboardAction) then
  begin
    s := Text;
    FPlannerItem.FPlanner.OnItemClipboardAction(FPlannerItem.FPlanner,FPlannerItem,itCopy,s);
    if s <> Text then
      Text := s;
  end;   
end;

procedure TPlannerMaskEdit.WMCut(var Msg:TMessage);
var
  s:string;
begin
  inherited;
  if Assigned(FPlannerItem.FPlanner.OnItemClipboardAction) then
  begin
    s := Text;
    FPlannerItem.FPlanner.OnItemClipboardAction(FPlannerItem.FPlanner,FPlannerItem,itCut,s);
    if s <> Text then
      Text := s;
  end;
end;

{ TPlannerHeader }

constructor TPlannerHeader.Create(AOwner: TCustomPlanner);
begin
  inherited Create;
  FOwner := AOwner;
  FCaptions := TStringList.Create;
  FGroupCaptions := TStringList.Create;
  FHeight := 16;
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FCaptions.OnChange := ItemsChanged;
  FGroupCaptions.OnChange := ItemsChanged;
  FColor := clBtnFace;
  FItemColor := clGray;
  FReadOnly := True;
  FFlat := False;
  FTextHeight := 16;
  FItemHeight := 16;
  FLineColor := clGray;
  FVisible := True;
end;

destructor TPlannerHeader.Destroy;
begin
  FCaptions.Free;
  FGroupCaptions.Free;
  FFont.Free;
  inherited Destroy;
end;

procedure TPlannerHeader.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  FOwner.FHeader.Alignment := Value;
end;

procedure TPlannerHeader.SetCaptions(const Value: TStringList);
begin
  if Assigned(Value) then
    FCaptions.Assign(Value);
  ItemsChanged(Self); 
end;

procedure TPlannerHeader.SetImages(const Value: TImageList);
begin
  FImages := Value;
  FOwner.FHeader.Images := Value;
end;

procedure TPlannerHeader.SetImagePosition(const Value: TImagePosition);
begin
  FImagePosition := Value;
  FOwner.FHeader.ImagePosition := Value;
end;

procedure TPlannerHeader.ItemsChanged(Sender: TObject);
var
  SectionIndex, SectionWidth: Integer;
begin
  if (FOwner.FHeader.Sections.Count = 0) then
    Exit;
  SectionIndex := 0;
  while (SectionIndex < FCaptions.Count) and
    (SectionIndex < FOwner.FHeader.Sections.Count) do
  begin
    SectionWidth := FOwner.FHeader.SectionWidth[SectionIndex];
    FOwner.FHeader.Sections[SectionIndex] := FCaptions.Strings[SectionIndex];
    FOwner.FHeader.SectionWidth[SectionIndex] := SectionWidth;
    Inc(SectionIndex);
  end;
end;

procedure TPlannerHeader.FontChanged(Sender: TObject);
begin
  FOwner.FHeader.Font.Assign(FFont);
end;

procedure TPlannerHeader.SetFont(const Value: TFont);
begin
  Self.FFont.Assign(Value);
  FOwner.FHeader.Font.Assign(Value);
end;

procedure TPlannerHeader.SetColor(const Value: TColor);
begin
  FColor := Value;
  FOwner.FHeader.Color := Value;
end;

procedure TPlannerHeader.SetHeight(const Value: Integer);
begin
  FHeight := Value;
  UpdateHeights;
  FOwner.UpdateSizes;
end;

procedure TPlannerHeader.SetVisible(const Value: Boolean);
begin
  if (FVisible <> Value) then
  begin
    FVisible := Value;
    if FVisible then
    begin
      FOwner.Header.Color := Color;
      FOwner.Header.Flat := Flat;
    end;
    FOwner.UpdateSizes;
  end;
end;

procedure TPlannerHeader.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
  FOwner.FHeader.Flat := Value;
  FOwner.FGrid.UpdatePositions;
end;

procedure TPlannerHeader.SetVAlignment(const Value: TVAlignment);
begin
  FVAlignment := Value;
  FOwner.FHeader.VAlignment := Value;
end;

function TPlannerHeader.GetDragDrop: Boolean;
begin
  Result := FOwner.FHeader.SectionDragDrop;
end;

procedure TPlannerHeader.SetDragDrop(const Value: Boolean);
begin
  FOwner.FHeader.SectionDragDrop := Value;
end;

procedure TPlannerHeader.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  FOwner.FHeader.SectionEdit := not Value;
end;

procedure TPlannerHeader.UpdateHeights;
begin
  FOwner.FHeader.Height := FHeight;
  FOwner.FHeader.FItemHeight := FItemHeight;
  FOwner.FHeader.FFixedHeight := FHeight - FTextHeight;
  FOwner.FHeader.FTextHeight := FTextHeight;
end;


procedure TPlannerHeader.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
  UpdateHeights;
  FOwner.FHeader.ShowFixed := Height - TextHeight > 0;
  FOwner.UpdateSizes;
end;

procedure TPlannerHeader.SetTextHeight(const Value: Integer);
begin
  FTextHeight := Value;
  UpdateHeights;
  FOwner.FHeader.ShowFixed := Height - TextHeight > 0;
  FOwner.UpdateSizes;
end;

procedure TPlannerHeader.SetAllowResize(const Value: Boolean);
begin
  FAllowResize := Value;
  FOwner.FHeader.AllowResize := Value;
end;

procedure TPlannerHeader.MergeHeader(FromSection, ToSection: Integer);
var
  i,w: Integer;
  s: String;
begin
  for i := FromSection to ToSection do
  begin
    if i < FOwner.FHeader.Sections.Count then
    begin
      w := FOwner.FHeader.SectionWidth[i];
      if i = FromSection then
      begin
        if Pos('#',FOwner.FHeader.Sections[i]) = 1 then
        begin
          s := FOwner.FHeader.Sections[i];
          Delete(s,1,1);
          FOwner.FHeader.Sections[i] := s;
          FOwner.FHeader.SectionWidth[i] := w;
        end;
      end
      else
      begin
        if Pos('#',FOwner.FHeader.Sections[i]) <> 1 then
        begin
          FOwner.FHeader.Sections[i] := '#' + FOwner.FHeader.Sections[i];
          FOwner.FHeader.SectionWidth[i] := w;
        end;
      end;
    end;
  end;
end;

procedure TPlannerHeader.UnMergeHeader(FromSection, ToSection: Integer);
var
  i: Integer;
  s: String;
  w: Integer;
begin
  for i := FromSection to ToSection do
  begin
    if i < FOwner.FHeader.Sections.Count then
    begin
      if Pos('#',FOwner.FHeader.Sections[i]) = 1 then
      begin
        s := FOwner.FHeader.Sections[i];
        w := FOwner.FHeader.SectionWidth[i];
        Delete(s,1,1);
        FOwner.FHeader.Sections[i] := s;
        FOwner.FHeader.SectionWidth[i] := w;
      end;
    end;
  end;
end;

procedure TPlannerHeader.SetAutoSize(const Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if FAutoSize then
      FOwner.AutoSizeHeader;
  end;
end;

procedure TPlannerHeader.SetItemColor(const Value: TColor);
begin
  FItemColor := Value;
  FOwner.FHeader.FixedColor := Value;
end;

procedure TPlannerHeader.SetGroupCaptions(const Value: TStringList);
begin
  FGroupCaptions.Assign(Value);
  FOwner.FHeader.Invalidate;
end;

procedure TPlannerHeader.Assign(Source: TPersistent);
begin
  if Assigned(Source) then
  begin
    Alignment := (Source as TPlannerHeader).Alignment;
    AllowResize := (Source as TPlannerHeader).AllowResize;
    AutoSize := (Source as TPlannerHeader).AutoSize;
    Captions.Assign((Source as TPlannerHeader).Captions);
    Color := (Source as TPlannerHeader).Color;
    DragDrop := (Source as TPlannerHeader).DragDrop;
    ReadOnly := (Source as TPlannerHeader).ReadOnly;
    Height := (Source as TPlannerHeader).Height;
    Flat := (Source as TPlannerHeader).Flat;
    Font.Assign((Source as TPlannerHeader).Font);
    GroupCaptions.Assign((Source as TPlannerHeader).GroupCaptions);
    Images := (Source as TPlannerHeader).Images;
    ImagePosition := (Source as TPlannerHeader).ImagePosition;
    ItemColor := (Source as TPlannerHeader).ItemColor;
    ItemHeight := (Source as TPlannerHeader).ItemHeight;
    PopupMenu := (Source as TPlannerHeader).PopupMenu;
    TextHeight := (Source as TPlannerHeader).TextHeight;
    VAlignment := (Source as TPlannerHeader).VAlignment;
    Visible := (Source as TPlannerHeader).Visible;
  end;
end;

procedure TPlannerHeader.SetLineColor(const Value: TColor);
begin
  FLineColor := Value;
  FOwner.FHeader.LineColor := Value;
end;


{ TPlannerMode }

constructor TPlannerMode.Create(AOwner: TCustomPlanner);
var
  Day, Month, Year: Word;
begin
  inherited Create;
  FOwner := AOwner;
  FPlannerType := plDay;
  FWeekStart := 0;
  FUpdateCount := 0;

  DecoDedate(Now, Year, Month, Day);
  FYear := Year;
  FMonth := Month;

  // default start time in DayPeriod mode
  FPeriodStartYear := Year;
  FPeriodStartMonth := Month;
  FPeriodStartDay := Day;

  // default end time in DayPeriod mode
  DecoDedate(Now + 48, Year, Month, Day);
  FPeriodEndYear := Year;
  FPeriodEndMonth := Month;
  FPeriodEndDay := Day;

  FTimeLineStart := Int(Now);
end;

destructor TPlannerMode.Destroy;
begin
  inherited Destroy;
end;

procedure TPlannerMode.SetMonth(const Value: Integer);
begin
  FMonth := Value;
  FOwner.Repaint;
end;

procedure TPlannerMode.SetPlannerType(const Value: TPlannerType);
begin
  FPlannerType := Value;
  FOwner.InactiveChanged(Self);
  FOwner.FGrid.Repaint; 
end;

procedure TPlannerMode.SetWeekStart(const Value: Integer);
begin
  FWeekStart := Value;
  FOwner.FGrid.Repaint;
end;

procedure TPlannerMode.SetYear(const Value: Integer);
begin
  FYear := Value;
  FOwner.Repaint;
end;

procedure TPlannerMode.SetDateTimeFormat(const Value: string);
begin
  FDateTimeFormat := Value;
  FOwner.Repaint;
end;

procedure TPlannerMode.SetPeriodStartDay(const Value: Integer);
begin
  if (Value > 0) and (Value < 32) then
  begin
    FPeriodStartDay := Value;
    UpdatePeriod;
  end;
end;

procedure TPlannerMode.SetPeriodStartMonth(const Value: Integer);
begin
  if (Value > 0) and (Value < 13) then
  begin
    FPeriodStartMonth := Value;
    UpdatePeriod;
  end;
end;

procedure TPlannerMode.SetPeriodStartYear(const Value: Integer);
begin
  FPeriodStartYear := Value;
  UpdatePeriod;
end;

procedure TPlannerMode.SetPeriodEndDay(const Value: Integer);
begin
  if (Value > 0) and (Value < 32) then
  begin
    FPeriodEndDay := Value;
    UpdatePeriod;
  end;
end;

procedure TPlannerMode.SetPeriodEndMonth(const Value: Integer);
begin
  if (Value > 0) and (Value < 13) then
  begin
    FPeriodEndMonth := Value;
    UpdatePeriod;
  end;
end;

procedure TPlannerMode.SetPeriodEndYear(const Value: Integer);
begin
  FPeriodEndYear := Value;
  UpdatePeriod;
end;

function LimitMonth(Month: word):word;
begin
  Result := Month;
  if Result > 12 then Result := 12;
  if Result < 1 then Result := 1;
end;

function LimitDay(Year, Month, Day: word):word;
const
  NumDays : array[1..12] of word = (31,29,31,30,31,30,31,31,30,31,30,31);
begin

  if Day > NumDays[Month] then
    Result := NumDays[Month]
  else
    Result := Day;

  if (Month = 2) and (Result = 29) then
    if (Year mod 4 <> 0) then
      Result := 28;
end;

function EncodePlannerDate(Year, Month, Day: Word): TDateTime;
begin
   if (Year = 0) or (Month = 0) or (Day = 0) then
    Result := 0
  else
    try
      Month := LimitMonth(Month);
      Day := LimitDay(Year,Month,Day);

      Result := EncodeDate(Year, Month, Day);
    except
      Result := 0;
    end;
end;

function TPlannerMode.GetPeriodEndDate: TDateTime;
begin
  case PlannerType of
  plDay,plHalfDayPeriod: Result := EncodePlannerDate(PeriodEndYear, PeriodEndMonth, PeriodEndDay);
  plMonth,plWeek: Result := GetStartOfMonth +
                    (FOwner.Display.FDisplayEnd - FOwner.Display.FDisplayStart)
  else
    Result := EncodePlannerDate(PeriodEndYear, PeriodEndMonth, PeriodEndDay);
  end;
end;

function TPlannerMode.GetPeriodStartDate: TDateTime;
begin
  case PlannerType of
  plDay,plHalfDayPeriod: Result := EncodePlannerDate(PeriodStartYear, PeriodStartMonth, PeriodStartDay);
  plWeek, plMonth: Result := GetStartOfMonth
  else
    Result := EncodePlannerDate(PeriodStartYear, PeriodStartMonth, PeriodStartDay);
  end;
end;

function TPlannerMode.GetStartOfMonth: TDateTime;
var
  Diff: Integer;
begin
  Result := EncodePlannerDate(Year, Month, 1);
  if PlannerType = plWeek then
  begin
    Diff := (7 - WeekStart) - DayOfWeek(Result);
    if Diff > 0 then
      Diff := Diff - 7;
    Result := Result + Diff;
  end;
end;

procedure TPlannerMode.UpdatePeriod;
var
  DS,DE: TDateTime;
begin
  if FUpdateCount > 0 then
    Exit;

  DS := EncodePlannerDate(FPeriodStartYear,FPeriodStartMonth,FPeriodStartDay);
  DE := EncodePlannerDate(FPeriodEndYear,FPeriodEndMonth,FPeriodEndDay);

  if (DS < DE) and (DS > 0) and (DE > 0) and
     not (csLoading in FOwner.ComponentState) and
     (PlannerType = plDayPeriod) then
  begin
    FOwner.Display.BeginUpdate;
    FOwner.Display.DisplayStart := 0;
    FOwner.Display.DisplayEnd := Trunc(DE - DS);
    FOwner.Display.EndUpdate;
  end;

  if (DS < DE) and (DS > 0) and (DE > 0) and
     not (csLoading in FOwner.ComponentState) and
     (PlannerType = plHalfDayPeriod) then
  begin
    FOwner.Display.BeginUpdate;
    FOwner.Display.DisplayStart := 0;
    FOwner.Display.DisplayEnd := 2 * Trunc(DE - DS) + 1;
    FOwner.Display.EndUpdate;
  end;

  FOwner.Invalidate;
end;

procedure TPlannerMode.SetPeriodEndDate(const Value: TDateTime);
var
  Da,Mo,Ye: word;
begin
  DecodeDate(Value,Ye,Mo,Da);
  FPeriodEndYear := Ye;
  FPeriodEndMonth := Mo;
  FPeriodEndDay := Da;
  UpdatePeriod;
end;

procedure TPlannerMode.SetPeriodStartDate(const Value: TDateTime);
var
  Da,Mo,Ye: word;
begin
  DecodeDate(Value,Ye,Mo,Da);
  FPeriodStartYear := Ye;
  FPeriodStartMonth := Mo;
  FPeriodStartDay := Da;
  UpdatePeriod;
end;

procedure TPlannerMode.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TPlannerMode.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      UpdatePeriod;
  end;
end;

procedure TPlannerMode.SetTimeLineStart(const Value: TDateTime);
begin
  FTimeLineStart := Value;
  FOwner.FGrid.Invalidate;
end;

procedure TPlannerMode.Assign(Source: TPersistent);
begin
  if (Source is TPlannerMode) then
  begin
    FClip := (Source as TPlannerMode).Clip;
    FDateTimeFormat := (Source as TPlannerMode).DateTimeFormat;
    FMonth := (Source as TPlannerMode).Month;
    PeriodStartDay := (Source as TPlannerMode).PeriodStartDay;
    PeriodStartMonth := (Source as TPlannerMode).PeriodStartMonth;
    PeriodStartYear := (Source as TPlannerMode).PeriodStartYear;
    PeriodEndDay := (Source as TPlannerMode).PeriodEndDay;
    PeriodEndMonth := (Source as TPlannerMode).PeriodEndMonth;
    PeriodEndYear := (Source as TPlannerMode).PeriodEndYear;
    PlannerType := (Source as TPlannerMode).PlannerType;
    TimeLineStart := (Source as TPlannerMode).TimeLineStart;
    WeekStart := (Source as TPlannerMode).WeekStart;
    Year := (Source as TPlannerMode).Year;
  end;
end;

{ TPlannerIO }

constructor TPlannerIO.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := (AOwner as TCustomPlanner).CreateItems;
end;

destructor TPlannerIO.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

{ TNavigatorButtons }

constructor TNavigatorButtons.Create(AOwner: TCustomPlanner);
begin
  FOwner := AOwner;
  inherited Create;
  FVisible := True;
  FFlat := True;
end;

procedure TNavigatorButtons.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
  FOwner.FNext.Flat := Value;
  FOwner.FPrev.Flat := Value;
end;

procedure TNavigatorButtons.SetNextHint(const Value: string);
begin
  FNextHint := Value;
  FOwner.FNext.Hint := Value;
end;

procedure TNavigatorButtons.SetPrevHint(const Value: string);
begin
  FPrevHint := Value;
  FOwner.FPrev.Hint := Value;
end;

procedure TNavigatorButtons.SetShowHint(const Value: Boolean);
begin
  FShowHint := Value;
  FOwner.FNext.ShowHint := Value;
  FOwner.FPrev.ShowHint := Value;
end;

procedure TNavigatorButtons.SetVisible(Value: Boolean);
begin
  FVisible := Value;
  FOwner.FCaption.UpdatePanel;
  FOwner.FGrid.UpdatePositions;
end;


{TPlannerRichEdit}

procedure TPlannerRichEdit.DoEnter;
begin
  inherited;
  SelStart := 0;
  SelLength := $FFFF;
end;

procedure TPlannerRichEdit.DoExit;
begin
  inherited;
  if Assigned(PlannerItem) then
  begin
    PlannerItem.Text.Text := PlannerItem.FPlanner.RichToText;
    PlannerItem.FPlanner.ItemEdited(PlannerItem);
  end;
  Self.Visible := False;
  Self.Parent.SetFocus;
end;

procedure TPlannerRichEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = vk_Escape then
  begin
    PlannerItem.FPlanner.TextToRich(PlannerItem.Text.Text);
    PlannerItem.FPlanner.SetFocus;
  end;
end;

constructor TPlannerIntList.Create(Value: TPlannerItem);
begin
  inherited Create;
  FPlannerItem := Value;
end;

procedure TPlannerIntList.SetInteger(Index: Integer; Value: Integer);
begin
  inherited Items[Index] := Pointer(Value);
  if Assigned(OnChange) then
    OnChange(Self);
end;

function TPlannerIntList.GetInteger(Index: Integer): Integer;
begin
  Result := Integer(inherited Items[Index]);
end;

procedure TPlannerIntList.Clear;
begin
  inherited;
  if Assigned(OnChange) then
    OnChange(Self);
end;

procedure TPlannerIntList.Add(Value: Integer);
begin
  inherited Add(Pointer(Value));
  if Assigned(OnChange) then
    OnChange(Self);
end;

procedure TPlannerIntList.Delete(Index: Integer);
begin
  inherited Delete(Index);
  if Assigned(OnChange) then
    OnChange(Self);
end;

{ TAdvHeader }

constructor TAdvHeader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColor := clBtnFace;
  FFixedColor := clGray;
  FLeftPos := 0;
  FSectionDragDrop := False;
  FTextHeight := 16;
  FItemHeight := 16;
  FShowFixed := True;

  if not (csDesigning in ComponentState) then
  begin
    FInplaceEdit := TMemo.Create(Self);
    FInplaceEdit.Parent := Self;
    FInplaceEdit.Visible := False;
    FInplaceEdit.OnExit := InplaceExit;
  end;

  Zoom := False;
  ZoomCol := -1;
  ShowHint := True;
  Hint := '';
  FLastHintPos := Point(-1,-1);
end;

destructor TAdvHeader.Destroy;
begin
  if not (csDesigning in ComponentState) then
    FInplaceEdit.Free;
  inherited;
end;

procedure TAdvHeader.InplaceExit(Sender: TObject);
var
  EditIdx: Integer;
  s: string;
begin
  EditIdx := GetSectionIdx(FEditSection);
  s := LFToCLF(FInplaceEdit.Text);

  if Assigned((Owner as TCustomPlanner).OnHeaderEndEdit) then
    (Owner as TCustomPlanner).OnHeaderEndEdit(Owner, EditIdx, s);

  Sections[EditIdx] := s;
  SectionWidth[EditIdx] := FEditWidth;
  FInplaceEdit.Visible := False;
end;

procedure TAdvHeader.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TAdvHeader.SetVAlignment(const Value: TVAlignment);
begin
  FVAlignment := Value;
  Invalidate;
end;

procedure TAdvHeader.SetColor(const Value: TColor);
begin
  FColor := Value;
  Invalidate;
end;

procedure TAdvHeader.SetLineColor(const Value: TColor);
begin
  FLineColor := Value;
  Invalidate;
end;

procedure TAdvHeader.SetImageList(const Value: TImageList);
begin
  FImageList := Value;
  Invalidate;
end;

procedure TAdvHeader.SetOrientation(const Value: THeaderOrientation);
begin
  FOrientation := Value;
  Invalidate;
end;

procedure TAdvHeader.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
  Invalidate;
end;

procedure TAdvHeader.SetImagePosition(const Value: TImagePosition);
begin
  FImagePosition := Value;
  Invalidate;
end;

function TAdvHeader.GetSectionRect(X: Integer): TRect;
var
  Offset, SectionIndex: Integer;
begin
  Offset := 0;

  for SectionIndex := FLeftPos to X - 1 do
  begin
    if SectionIndex = FLeftPos then
      Offset := Offset + SectionWidth[0]
    else
      Offset := Offset + SectionWidth[SectionIndex];
  end;

  if FOrientation = hoHorizontal then
  begin
    Result.Left := Offset;
    Result.Right := Offset + SectionWidth[X];
    Result.Top := 0;
    Result.Bottom := Self.Height;
  end
  else
  begin
    Result.Left := 0;
    Result.Right := Self.Width;
    Result.Top := Offset;
    Result.Bottom := Offset + SectionWidth[X];
  end;

end;

function TAdvHeader.XYToSection(X, Y: Integer): Integer;
var
  Ofs, SectionIndex: Integer;
begin
  Ofs := 0;
  SectionIndex := FLeftPos;

  if FOrientation = hoHorizontal then
  begin
    while (Ofs < X) and (SectionIndex < Sections.Count) do
    begin
      if SectionIndex = FLeftPos then
        Ofs := Ofs + SectionWidth[0]
      else
        Ofs := Ofs + SectionWidth[SectionIndex];
      Inc(SectionIndex);
    end;
    Dec(SectionIndex);
  end
  else
  begin

    while (Ofs < Y) and (SectionIndex < Sections.Count) do
    begin
      if SectionIndex = FLeftPos then
        Ofs := Ofs + SectionWidth[0]
      else
        Ofs := Ofs + SectionWidth[SectionIndex];
      Inc(SectionIndex);
    end;
    Dec(SectionIndex);
  end;
  Result := SectionIndex;
end;

procedure TAdvHeader.Paint;
var
  SectionIndex, w, AIdx,BIdx,MergeNum: Integer;
  s:string;
  CT,CID,CV: string;
  cr: TRect;
  DrawFlags: DWord;
  DrawGroupFlags: DWord;
  r: TRect;
  pr: TRect;
  HorizontalAlign: Word;
  VerticalAlign: Word;
  AllPainted: Boolean;
  APlannerItem: TPlannerItem;
  DoDraw: Boolean;
  Anchor,Strip,FocusAnchor: string;
  ml,hl,XSize,YSize: integer;
  hr: TRect;
  Planner: TCustomPlanner;
  Orgx,Oldx,GroupIdx: Integer;

begin
  Planner := Owner as TCustomPlanner;
  with Canvas do
  begin
    Font := Self.Font;
    Brush.Color := FColor;

    if FLineColor = clNone then
      Pen.Color := FColor
    else
      Pen.Color := FLineColor;

    Pen.Width := 1;
    SectionIndex := 0;
    OrgX := 0;

    if (Orientation = hoHorizontal) then
      r := Rect(0, 0, 0, ClientHeight)
    else
      r := Rect(0, 0, ClientWidth, 0);

    AIdx := 0;
    w := 0;
    s := '';

    HorizontalAlign := AlignToFlag(FAlignment);
    VerticalAlign := 0;

    AllPainted := False;
    repeat
      MergeNum := 1;

      if SectionIndex + FLeftPos < Sections.Count then
      begin
        if SectionIndex > 0 then
          w := SectionWidth[SectionIndex + FLeftPos]
        else
          w := SectionWidth[SectionIndex] + 1;

        VerticalAlign := VAlignToFlag(FVAlignment);

        if FOffset = 1 then
        begin
          if (SectionIndex < Sections.Count - 1 - FLeftPos) and (SectionIndex > 0) then
          begin
            AIdx := SectionIndex + FLeftPos;
            s := Sections[AIdx];
          end
          else
          begin
            AIdx := -1;
            s := '';
          end;
        end
        else
        begin
          if (SectionIndex < Sections.Count - FLeftPos) then
            AIdx := SectionIndex + 1 + FLeftPos - 1
          else
            AIdx := 0;
          s := Sections[AIdx];
        end;

        if (Pos('#',s) = 1) and (AIdx > 0) then
        begin
          BIdx := AIdx - 1;
          while (BIdx >=0) and (Pos('#',Sections[BIdx]) = 1) do
          begin
            Dec(BIdx);
          end;
          s := Sections[BIdx];
        end;

        if AIdx <> -1 then
        begin
          BIdx := AIdx + 1;
          while BIdx < Sections.Count do
          begin
            if Pos('#',Sections[BIdx])=1 then
            begin
              w := w + SectionWidth[SectionIndex];
              inc(MergeNum);
            end;
            inc(BIdx);
          end;
        end;

        Inc(SectionIndex,MergeNum);
      end;

      if (Orientation = hoHorizontal) then
      begin
        r.Left := r.Right;
        Inc(r.Right, w);
        if (ClientWidth - r.Right < 2) or (SectionIndex + FLeftPos = Sections.Count) then
        begin
          r.Right := ClientWidth;
          AllPainted := True;
        end;
      end
      else
      begin
        r.Top := r.Bottom;
        Inc(r.Bottom, w);

        if (ClientHeight - r.Bottom < 2) or (SectionIndex + FLeftPos = Sections.Count) then
        begin
          r.Bottom := ClientHeight;
          AllPainted := True;
        end;
      end;

      pr := r;

      if FShowFixed and (SectionIndex > 1) then
      begin
        Canvas.Brush.Color := FFixedColor;

        if Orientation = hoHorizontal then
          r.Top := r.Bottom - FFixedHeight
        else
          r.Left := r.Right - FFixedHeight;

        FillRect(r);
        r := pr;

        if Orientation = hoHorizontal then
          r.Bottom := r.Bottom - FFixedHeight
        else
          r.Right := r.Right - FFixedHeight;

        Canvas.Brush.Color := FColor;

        FillRect(r);
        r := pr;
      end
      else
      begin
        FillRect(r);
      end;

      DoDraw := True;

      if Assigned(Planner.FOnPlannerHeaderDraw) then
      begin
        Font := Self.Font;
        Brush.Color := FColor;
        Pen.Color := FLineColor;
        Pen.Width := 1;
        Planner.FOnPlannerHeaderDraw(TCustomPlanner(Owner), Canvas, r, AIdx, DoDraw);
      end;

      if DoDraw then
      begin
        InflateRect(pr, -4, -2);

        if Assigned(FImageList) and (FImageList.Count + 1 + FOffset - FLeftPos >
          SectionIndex) and (SectionIndex > FOffset)
          and (SectionIndex <= Sections.Count - 1 - FLeftPos) then
        begin
          if FImagePosition = ipLeft then
          begin
            FImageList.Draw(Canvas, pr.Left, pr.Top, SectionIndex - 1 - FOffset +
              FLeftPos);
            pr.Left := pr.Left + FImageList.Width;
          end
          else
          begin
            pr.Right := pr.Right - FImageList.Width;
            FImageList.Draw(Canvas, pr.Right, pr.Top, SectionIndex - 1 - FOffset);
          end;
        end;

        s := CLFToLF(s);

        if Pos(#13, s) = 0 then
          VerticalAlign := VerticalAlign or DT_SINGLELINE
        else
          VerticalAlign := 0;

        pr.Bottom := pr.Top + FTextHeight;

        if (Planner.PositionGroup > 0) and (Orientation = hoHorizontal)  then
          pr.Top := pr.Top + (FTextHeight shr 1);

        if (Planner.PositionGroup > 0) and (Orientation = hoVertical)  then
        begin
          pr.Left := pr.Left + (FTextHeight shr 1);
        end;

        if (Orientation = hoVertical) then
          pr.Bottom := pr.Top + w - 2;


        DrawFlags := DT_NOPREFIX or DT_END_ELLIPSIS or HorizontalAlign or VerticalAlign;

        {$IFDEF DELPHI4_LVL}
        DrawFlags := Planner.DrawTextBiDiModeFlags(DrawFlags);
        {$ENDIF}

        if Pos('</',s) > 0 then
        begin
          HTMLDrawEx(Canvas,s,pr,Planner.PlannerImages,0,0,-1,-1,1,False,False,False,False,False,False,True
            , False
            ,1,
            clBlue,clNone,clNone,clgray,Anchor,Strip,FocusAnchor,XSize,YSize,ml,hl,hr
            ,cr, CID, CV, CT, Planner.FImageCache,Planner.FContainer, Handle
            );
        end
        else
        begin
          DrawText(Canvas.Handle, PChar(s), Length(s), pr, DrawFlags);
        end;

        if FShowFixed and (Orientation = hoHorizontal) and (SectionIndex > 1) then
          r.Bottom := r.Bottom - FFixedHeight;

        if FShowFixed and (Orientation = hoVertical) and (SectionIndex > 1) then
          r.Right := r.Right - FFixedHeight;

        if (Planner.PositionGroup > 0) and (Orientation = hoHorizontal) and (SectionIndex > 1) then
          r.Top := r.Top + FTextHeight div 2;

        if (Planner.PositionGroup > 0) and (Orientation = hoVertical) and (SectionIndex > 1) then
          r.Left := r.Left + FTextHeight shr 1;

        if not FFlat then
        begin
          DrawEdge(Canvas.Handle, r, BDR_RAISEDINNER, BF_TOPLEFT);
          DrawEdge(Canvas.Handle, r, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
        end
        else
        begin
          if (SectionIndex > 1) and (Orientation = hoHorizontal) and (FLineColor <> clNone) then
          begin
            Canvas.MoveTo(r.Left +2, r.Top);
            Canvas.LineTo(r.Left +2, r.Bottom);
          end;
          if (SectionIndex > 1) and (Orientation = hoVertical) and (FLineColor <> clNone) then
          begin
            Canvas.MoveTo(r.Left, r.Top + 2);
            Canvas.LineTo(r.Right, r.Top + 2);
          end;
        end;

        if (Planner.PositionGroup > 0) and (Orientation = hoHorizontal)
           and (SectionIndex > 1) then
        begin
          if SectionIndex = 2 then
            orgx := r.Left;

          r.Top := r.Top - FTextHeight div 2;
          r.Bottom := r.Top + FTextHeight div 2;

          if ((SectionIndex - 1 + FLeftPos) mod Planner.PositionGroup = 0) or AllPainted then
          begin
            oldx := r.Left;
            r.Left := orgx;
            if not FFlat then
            begin
              DrawEdge(Canvas.Handle, r, BDR_RAISEDINNER, BF_TOPLEFT);
              DrawEdge(Canvas.Handle, r, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
            end
            else
            begin
              OffsetRect(R,2,0);
              Canvas.MoveTo(R.Left,r.Top);
              Canvas.LineTo(R.Right,r.Top);
              Canvas.LineTo(R.Right,r.Bottom);
              Canvas.LineTo(R.Left,r.Bottom);
              Canvas.LineTo(R.Left,r.Top);
              OffsetRect(R,-2,0);
            end;

            GroupIdx := (SectionIndex - 2 + FLeftPos) div Planner.PositionGroup;

            if Planner.Header.GroupCaptions.Count > GroupIdx then
            begin
              s := CLFToLF(Planner.Header.GroupCaptions.Strings[GroupIdx]);

              VerticalAlign := VAlignToFlag(Planner.Header.FVAlignment);

              if Pos(#13, s) = 0 then
                DrawGroupFlags := DT_NOPREFIX or HorizontalAlign or DT_SINGLELINE or VerticalAlign
              else
                DrawGroupFlags := DT_NOPREFIX or HorizontalAlign or DT_WORDBREAK or VerticalAlign;

              {$IFDEF DELPHI4_LVL}
              DrawGroupFlags := Planner.DrawTextBiDiModeFlags(DrawGroupFlags);
              {$ENDIF}


              if Pos('</',s) > 0 then
              begin
                HTMLDrawEx(Canvas,s,r,Planner.PlannerImages,0,0,-1,-1,1,False,False,False,False,False,False,True
                  , False
                  ,1, clBlue,clNone,clNone,clgray,Anchor,Strip,FocusAnchor,XSize,YSize,ml,hl,hr
                  , cr, CID, CV, CT, Planner.FImageCache,Planner.FContainer, Handle
                  );
              end
              else
                DrawText(Canvas.Handle, PChar(s), Length(s), r, DrawGroupFlags);
            end;

            r.Left := oldx;
            orgx := r.Right;
          end;

          r.Bottom := r.Top + FTextHeight;
        end;

        if (Planner.PositionGroup > 0) and (Orientation = hoVertical)
           and (SectionIndex > 1) then
        begin
          if SectionIndex = 2 then
            orgx := r.Top;

          r.Left := r.Left - FTextHeight shr 1;
          r.Right := r.Left + FTextHeight shr 1;

          if ((SectionIndex - 1 + FLeftPos) mod Planner.PositionGroup = 0) or AllPainted then
          begin
            oldx := r.Top;
            r.Top := orgx;
            if not FFlat then
            begin
              DrawEdge(Canvas.Handle, r, BDR_RAISEDINNER, BF_TOPLEFT);
              DrawEdge(Canvas.Handle, r, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
            end
            else
            begin
              OffsetRect(R,2,0);
              Canvas.MoveTo(R.Left,R.Top);
              Canvas.LineTo(R.Right,r.Top);
              Canvas.LineTo(R.Right,r.Bottom);
              Canvas.LineTo(R.Left,r.Bottom);
              Canvas.LineTo(R.Left,r.Top);
              OffsetRect(R,-2,0);
            end;

            GroupIdx := (SectionIndex - 2 + FLeftPos) div Planner.PositionGroup;

            if Planner.Header.GroupCaptions.Count > GroupIdx then
            begin
              s := CLFToLF(Planner.Header.GroupCaptions.Strings[GroupIdx]);

              if Pos(#13, s) = 0 then
                DrawGroupFlags := DrawFlags
              else
                DrawGroupFlags := DT_NOPREFIX or HorizontalAlign or DT_WORDBREAK;

              {$IFDEF DELPHI4_LVL}
              DrawGroupFlags := Planner.DrawTextBiDiModeFlags(DrawGroupFlags);
              {$ENDIF}


              if Pos('</',s) > 0 then
              begin
                HTMLDrawEx(Canvas,s,r,Planner.PlannerImages,0,0,-1,-1,1,False,False,False,False,False,False,True
                  , False
                  ,1, clBlue,clNone,clNone,clgray,Anchor,Strip,FocusAnchor,XSize,YSize,ml,hl,hr
                  ,cr, CID, CV, CT, Planner.FImageCache,Planner.FContainer, Handle
                  );
              end
              else
                DrawText(Canvas.Handle, PChar(s), Length(s), r, DrawGroupFlags);
            end;

            r.Top := oldx;
            orgx := r.Bottom;
          end;

          r.Right := r.Left + FTextHeight;
        end;

        if FShowFixed and (Orientation = hoHorizontal) and (SectionIndex > 1) then
        begin
          Canvas.Pen.Color := FLineColor;
          if FFlat then
          begin
            Canvas.MoveTo(r.Left + 1,r.Bottom);
            Canvas.LineTo(r.Left + 1,R.Bottom + FFixedHeight);
          end
          else
          begin
            Canvas.MoveTo(r.Right - 1,r.Bottom);
            Canvas.LineTo(r.Right - 1,R.Bottom + FFixedHeight);
          end;
          r.Bottom := r.Bottom + FFixedHeight;
        end;

        if FShowFixed and (Orientation = hoVertical) and (SectionIndex > 1) then
        begin
          Canvas.Pen.Color := FLineColor;
          Canvas.MoveTo(r.Right,r.Bottom - 1);
          Canvas.LineTo(r.Right + + FFixedHeight,r.Bottom - 1);
          r.Right := r.Right + FFixedHeight;
        end;

        with Planner do
        begin
          APlannerItem := Items.HeaderFirst(SectionIndex - 2 + FLeftPos);

          pr.Top := r.Top;
          
          while Assigned(APlannerItem) and (SectionIndex > 1) do
          begin

            APlannerItem.FRepainted := False;
            {Paint full Items here}
            if Orientation = hoHorizontal then
            begin
              pr.Left := r.Left + 2;
              pr.Right := r.Right - 2;
              pr.Top := pr.Bottom;
              pr.Bottom := pr.Bottom + FItemHeight;
              FGrid.PaintItemCol(Self.Canvas, pr, APlannerItem, False, False);
            end
            else
            begin
              pr.Left := r.Left + FTextHeight;
              pr.Right := r.Right - 2;
              pr.Bottom := pr.Top + FItemHeight;
              FGrid.PaintItemCol(Self.Canvas, pr, APlannerItem, False, False);
              pr.Top := pr.Top + FItemHeight;
            end;
            APlannerItem := Items.HeaderNext(SectionIndex - 2 + FLeftPos);
          end;
        end;

        Font := Self.Font;
        Brush.Color := FColor;
        Pen.Color := FLineColor;
        Pen.Width := 1;
      end;

    until AllPainted;
  end;
end;

procedure TAdvHeader.CMHintShow(var Message: TMessage);
{$IFDEF DELPHI2_LVL}
type
  PHintInfo = ^THintInfo;
{$ENDIF}
var
  CanShow: Boolean;
  Hi: PHintInfo;
  cr, hr, pr, cor: TRect;
  APlannerItem: TPlannerItem;
  s, CID, CV, CT: string;
  Anchor, StrippedHtmlString, FocusAnchor: string;
  XSize, YSize, ml, hl: Integer;
  FPlanner: TCustomPlanner;
begin
  Hi := PHintInfo(Message.LParam);

  APlannerItem := ItemAtXY(Hi.CursorPos.X, Hi.CursorPos.Y,pr);

  FPlanner := TCustomPlanner(Owner);

  FLastHintPos := Point(Hi.CursorPos.X, Hi.CursorPos.Y);

  if Assigned(APlannerItem) then
  begin
    s := APlannerItem.ItemText;

    if IsRtf(s) then
    begin
      FPlanner.TextToRich(s);
      s := FPlanner.FRichEdit.Text;
    end;
    if IsHtml(APlannerItem,s) then
    begin
      {Change ? if HTML Hint is enabled ?}
      s := ConcatenateTextStrings(APlannerItem.Text);
      cr := ClientRect;
      if not FPlanner.HTMLHint then
      begin
        HTMLDrawEx(Canvas, s, cr, FPlanner.PlannerImages, 0, 0, -1, -1, 1,
          True, True, False, True, True, False, APlannerItem.WordWrap
          ,False
          , 1.0, FPlanner.URLColor,
          clNone, clNone, clGray, Anchor, StrippedHtmlString, FocusAnchor,
          XSize, YSize, ml, hl, hr
          , cor, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
          );

        s := StrippedHtmlString;
      end;
    end;

    {$IFDEF TMSCODESITE}
    CodeSite.SendMsg(s+'*');
    {$ENDIF}

{$IFNDEF VER90}
    Hi.HintStr := s;
    if Assigned(FPlanner.OnItemHint) then
      FPlanner.OnItemHint(FPlanner, APlannerItem, Hi.HintStr);
{$ENDIF}
{$IFNDEF VER90}
    if Assigned(FPlanner.OnItemHint) then
      FPlanner.OnItemHint(FPlanner, APlannerItem, s);
{$ENDIF}

  end;

  Hi.HintColor := FPlanner.HintColor;

  CanShow := Assigned(APlannerItem);

  Message.Result := Ord(not CanShow);

end;


procedure TAdvHeader.WMLButtonDown(var Msg: TWMLButtonDown);
var
  SectionIndex: Integer;
  r: TRect;
begin
  SectionIndex := XYToSection(Msg.XPos, Msg.YPos);

  r := GetSectionRect(SectionIndex);

  if FSectionDragDrop and not FDragging then
  begin
    FDragStart := SectionIndex;

    InflateRect(r,-2,-2);

    if (FDragStart >= FOffset) and PtInRect(r,Point(Msg.XPos,Msg.YPos)) then
    begin
      FDragging := True;
      Self.Cursor := crDrag;
      SetCapture(Self.Handle);
    end;
  end;
  inherited;
end;

procedure TAdvHeader.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  r,pr: TRect;
  APlannerItem: TPlannerItem;
  SectionIndex,EditIdx: Integer;
  FPlanner: TCustomPlanner;
  s: string;
  ScreenPoint: TPoint;

begin
  SectionIndex := XYToSection(X, Y);
  r := GetSectionRect(SectionIndex);

  if Button = mbRight then
  begin
    inherited;

    if Assigned(FOnRightClick) then
      FOnRightClick(Self, XYToSection(X, Y));

    APlannerItem := ItemAtXY(X, Y,pr);
    FPlanner := Owner as TCustomPlanner;

    ScreenPoint := ClientToScreen(Point(X, Y));

    if Assigned(APlannerItem) then
    begin
      with FPlanner do
        if Assigned(OnItemRightClick) then
          OnItemRightClick(Owner,APlannerItem);

      if Assigned(APlannerItem.PopupMenu) then
      begin
        if Assigned(FPlanner.OnItemPopupPrepare) then
          FPlanner.OnItemPopupPrepare(FPlanner, APlannerItem.PopupMenu, APlannerItem);

        FPlanner.PopupPlannerItem := APlannerItem;
        APlannerItem.PopupMenu.PopupComponent := Self;
        APlannerItem.PopupMenu.Popup(ScreenPoint.X, ScreenPoint.Y);
      end;

      if (Assigned(FPlanner.FItemPopup)) then
      begin
        if Assigned(FPlanner.OnItemPopupPrepare) then
          FPlanner.OnItemPopupPrepare(FPlanner, FPlanner.ItemPopup, APlannerItem);

        FPlanner.PopupPlannerItem := APlannerItem;
        FPlanner.ItemPopup.PopupComponent := Self;
        FPlanner.FItemPopup.Popup(ScreenPoint.X, ScreenPoint.Y);
      end;
    end
    else
    begin
      if Assigned(FPlanner.Header.PopupMenu) then
      begin
        FPlanner.Header.PopupMenu.PopupComponent := Self;
        FPlanner.Header.PopupMenu.Popup(ScreenPoint.X,ScreenPoint.Y);
      end;
    end;
    Exit;
  end;



  if Button = mbLeft then
  begin
    FPlanner := Owner as TCustomPlanner;

    if FPlanner.FGrid.FMemo.Visible then
      FPlanner.FGrid.FMemo.DoExit;

    APlannerItem := ItemAtXY(X, Y,pr);
    if Assigned(APlannerItem) then
    begin

      with (Owner as TCustomPlanner) do
      begin
        if APlannerItem <> Items.Selected then
        Items.UnSelectAll;
        Items.Selected := APlannerItem;

        if Assigned(OnItemLeftClick) then
          OnItemLeftClick(Owner,APlannerItem);

        if not APlannerItem.NotEditable and (APlannerItem.Selected or FPlanner.EditDirect) then
          StartEdit(pr,APlannerItem, X, Y + TextHeight);

        APlannerItem.Selected := True;

        ItemSelected(APlannerItem);
      end;
    end;

    if FSectionEdit and not (csDesigning in ComponentState) then
    begin
      if FInplaceEdit.Visible then
      begin
        EditIdx := GetSectionIdx(FEditSection);
        s := LFToCLF(FInplaceEdit.Text);

        if Assigned(FPlanner.OnHeaderEndEdit) then
          FPlanner.OnHeaderEndEdit(FPlanner,EditIdx,s);

        Sections[EditIdx] := s;
        SectionWidth[EditIdx] := FEditWidth;
      end;

      FEditSection := XYToSection(X, Y);
      r := GetSectionRect(FEditSection);

      EditIdx := GetSectionIdx(FEditSection);

      InflateRect(r, -2, -2);
      OffsetRect(r, 2, 2);

      s := CLFToLF(Self.Sections[EditIdx]);

      if Assigned(FPlanner.OnHeaderStartEdit) then
        FPlanner.OnHeaderStartEdit(FPlanner,EditIdx,s);

      {$IFDEF DELPHI4_LVL}
      FInplaceEdit.BiDiMode := FPlanner.BiDiMode;
      {$ENDIF}
      FInplaceEdit.Top := r.Top;
      FInplaceEdit.Left := r.Left;
      FInplaceEdit.Width := r.Right - r.Left - 2;
      FInplaceEdit.Height := r.Bottom - r.Top - 2;
      FInplaceEdit.Color := Self.Color;
      FInplaceEdit.Font.Assign(Self.Font);
      FInplaceEdit.Text := s;
      FInplaceEdit.BorderStyle := bsNone;
      FInplaceEdit.Visible := True;
      FInplaceEdit.SelectAll;

      FEditWidth := SectionWidth[FEditSection];

      FInplaceEdit.SetFocus;
    end;

    if FPlanner.SideBar.Orientation = soVertical then
    begin
      if SectionIndex > FPlanner.FGrid.ColCount then SectionIndex := -1;
    end
    else
    begin
      if SectionIndex >= FPlanner.FGrid.RowCount then SectionIndex := -1;
    end;

    if Zoom and (SectionIndex > 0) and (FPlanner.PositionWidth > 0) then
    begin
      if Cursor = crZoomIn then
      begin
        FPlanner.PositionWidths[SectionIndex - 1] := FPlanner.PositionZoomWidth;
        ZoomCol := SectionIndex;
        if Assigned(FPlanner.OnPlannerPositionZoom) then
          FPlanner.OnPlannerPositionZoom(FPlanner, ZoomCol, True);
      end
      else
      begin
        FPlanner.PositionWidths[SectionIndex - 1] := FPlanner.PositionWidth;
        if Assigned(FPlanner.OnPlannerPositionZoom) then
          FPlanner.OnPlannerPositionZoom(FPlanner, ZoomCol, False);
        ZoomCol := -1;
      end;
    end;
  end;

  inherited;
  {
  if Assigned(FOnClick) then
    FOnClick(Self, XYToSection(X, Y));
  }
end;


procedure TAdvHeader.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  FDragStop: Integer;
begin
  inherited;

  if Assigned(FOnClick) then
    FOnClick(Self, XYToSection(X, Y));

  if FSectionDragDrop and FDragging then
  begin
    FDragging := False;
    Self.Cursor := crDefault;
    ReleaseCapture;
    if Assigned(FOnDragDrop) then
    begin
      FDragStop := XYToSection(X, Y);

      if (FDragStop >= FOffset) and (FDragStop <> FDragStart) then
        FOnDragDrop(Self, FDragStart, FDragStop);
    end;
  end;
end;


procedure TAdvHeader.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  APlannerItem: TPlannerItem;
  pr: TRect;
begin
  APlannerItem := ItemAtXY(Message.XPos, Message.YPos,pr);
  if Assigned(APlannerItem) then
  begin
    with (Owner as TCustomPlanner) do
      if Assigned(OnItemDblClick) then
        OnItemDblClick(Owner,APlannerItem);
  end
  else
   if Assigned(FOnDblClick) then
     FOnDblClick(Self, XYToSection(Message.xpos, Message.ypos));
end;


procedure TAdvHeader.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  SectionIdx: Integer;
  HdrYStart: Integer;
  FPlanner: TCustomPlanner;
  PosOk: Boolean;
begin
  inherited;

  if FDragging then
  begin
    Cursor := crDrag;
    Exit;
  end;

  if (FLastHintPos.X <> -1) then
    if (Abs(X - FLastHintPos.X) > 4) or (Abs(Y - FLastHintPos.Y) > 4) then
    begin
      Application.CancelHint;
      FLastHintPos := Point(-1, -1);
    end;

  if Zoom then
  begin
    SectionIdx := XYToSection(X,Y);

    FPlanner := Owner as TCustomPlanner;
    HdrYStart := 0;

    if FPlanner.PositionGroup > 0 then
      HdrYStart := TextHeight shr 1;

    if FPlanner.SideBar.Orientation = soVertical then
      PosOK := (Y < TextHeight) and (Y > HdrYStart) and (SectionIdx < FPlanner.FGrid.ColCount)
    else
      PosOK := (X < TextHeight) and (X > HdrYStart) and (SectionIdx < FPlanner.FGrid.RowCount);

    if PosOk and (SectionIdx > 0) then
    begin
      if (SectionWidth[SectionIdx] <> FPlanner.PositionWidth) then
        Cursor := crZoomOut
      else
        Cursor := crZoomIn;
    end
    else
      if (Cursor <> crDefault) and not FDragging then
        Cursor := crDefault;
  end;
end;

procedure TAdvHeader.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
  Invalidate;
end;

procedure TAdvHeader.SetTextHeight(const Value: Integer);
begin
  FTextHeight := Value;
  Invalidate;
end;

function TAdvHeader.ItemAtXY(X, Y: Integer;var ARect: TRect): TPlannerItem;
var
  SectionIndex: Integer;
  r,pr: TRect;
  APlannerItem: TPlannerItem;

begin
  Result := nil;

  SectionIndex := XYToSection(X,Y);
  r := GetSectionRect(SectionIndex);

  with (Owner as TCustomPlanner) do
  begin
    APlannerItem := Items.HeaderFirst(SectionIndex - 1);

    InflateRect(r,-2,-2);
    pr := r;

    if Orientation = hoHorizontal then
      pr.Top := r.Top + FTextHeight 
    else
      pr.Left := r.Left + FTextHeight;

    while Assigned(APlannerItem) do
    begin
      pr.Bottom := pr.Top + FItemHeight;

      if PtInRect(pr,Point(X,Y)) then
      begin
        ARect := pr;
        Result := APlannerItem;
        Break;
      end;
      APlannerItem := Items.HeaderNext(SectionIndex - 1);
      pr.Top := pr.Bottom;
    end;
  end;

end;

procedure TAdvHeader.StopEdit;
var
  FPlanner: TCustomPlanner;
begin
  FPlanner := Owner as TCustomPlanner;

  with FPlanner.FGrid do
  begin
    if FMemo.Visible then
    begin
      FMemo.DoExit;
      FMemo.Visible := False;
    end;

  end;

end;

procedure TAdvHeader.StartEdit(ARect: TRect; APlannerItem: TPlannerItem; X, Y:
  Integer);
var
  ColumnHeight, ih, iw, ew: Integer;
  s: string;
  ER: TRect;
  FPlanner: TCustomPlanner;

begin
  if APlannerItem = nil then
    Exit;

  FPlanner := Owner as TCustomPlanner;

  if Assigned(FPlanner.OnItemStartEdit) then
  begin
    FPlanner.OnItemStartEdit(Self, APlannerItem);
  end;

  ColumnHeight := 0;
  ih := 0;
  iw := 0;
  ew := 0;

  case APlannerItem.Shape of
  psRounded: ew := ew + (CORNER_EFFECT shr 1) - 1;
  psHexagon: ew := ew + CORNER_EFFECT;
  end;

  if ((APlannerItem.ImageID >= 0) or (APlannerItem.FImageIndexList.Count > 0)) and
    Assigned(FPlanner.PlannerImages) then
  begin
    ih := FPlanner.PlannerImages.Height + 2;
    iw := FPlanner.PlannerImages.Width + 2;
  end;

  if (APlannerItem.CaptionType <> ctNone) or (APlannerItem.FImageIndexList.Count > 1) then
  begin
    Canvas.Font.Assign(APlannerItem.CaptionFont);
    ColumnHeight := Canvas.TextHeight('gh') + 2;
    iw := 0;
  end
  else
    ih := 0;

  if (ih > ColumnHeight) then
    ColumnHeight := ih;

  s := APlannerItem.Text.Text;

  with FPlanner.FGrid do
  begin
    if IsRtf(s) or (APlannerItem.InplaceEdit = peRichText) then
    begin
      FPlanner.FRichEdit.Parent := Self;
      FPlanner.FRichEdit.ScrollBars := FPlanner.EditScroll;
      FPlanner.FRichEdit.PlannerItem := APlannerItem;
      FPlanner.TextToRich(s);
      FPlanner.FRichEdit.Top := ARect.Top + 3 + ColumnHeight;
      FPlanner.FRichEdit.Left := ARect.Left;
      FPlanner.FRichEdit.Width := ARect.Right - ARect.Left - 3;
      FPlanner.FRichEdit.Height := ItemHeight - 3;

      FPlanner.FRichEdit.Visible := True;
      BringWindowToTop(FPlanner.FRichEdit.Handle);
      FPlanner.FRichEdit.SetFocus;
      FPlanner.FRichEdit.SelectAll;
    end
    else
      case APlannerItem.InplaceEdit of
        {
        peMaskEdit, peEdit:
          begin
            if APlannerItem.InplaceEdit = peMaskEdit then
              FMaskEdit.EditMask := APlannerItem.EditMask
            else
              FMaskEdit.EditMask := '';
            FMaskEdit.Font.Assign(FPlanner.Font);
            if APlannerItem.ShowSelection then
              FMaskEdit.Color := APlannerItem.SelectColor
            else
              FMaskEdit.Color := APlannerItem.Color;
            FMaskEdit.PlannerItem := APlannerItem;
            FMaskEdit.Top := ARect.Top + 6 + ColumnHeight;
            FMaskEdit.Left := ARect.Left + tw + 1 + iw + ew;
            FMaskEdit.Width := ARect.Right - ARect.Left - tw - 3 - FPlanner.FItemGap -
              iw - 2 * ew;
            FMaskEdit.Height := (APlannerItem.ItemEnd - APlannerItem.ItemBegin) * RowHeights[0] - 8
              - ColumnHeight;
            FMaskEdit.BorderStyle := bsNone;
            FMaskEdit.Visible := True;
            if (APlannerItem.Text.Count > 0) then
              FMaskEdit.Text := APlannerItem.Text[0];
            BringWindowToTop(FMaskEdit.Handle);
            FMaskEdit.SetFocus;
          end;
        }
        peMemo, peMaskEdit, peEdit:
          begin
            FMemo.Parent := Self;
            FMemo.ScrollBars := FPlanner.EditScroll;
            {$IFDEF DELPHI4_LVL}
            FMemo.BiDiMode := FPlanner.BiDiMode;
            {$ENDIF}
            FMemo.Font.Assign(APlannerItem.Font);
            if APlannerItem.ShowSelection then
              FMemo.Color := APlannerItem.SelectColor
            else
              FMemo.Color := APlannerItem.Color;
            FMemo.PlannerItem := APlannerItem;
            FMemo.Top := ARect.Top + 3 + ColumnHeight;
            FMemo.Left := ARect.Left + 1 + iw + ew;
            FMemo.Width := ARect.Right - ARect.Left - 3;
            FMemo.Height := ItemHeight - 6;
            FMemo.BorderStyle := bsNone;
            FMemo.Visible := True;
            BringWindowToTop(FMemo.Handle);
            FMemo.Lines.Text := HTMLStrip(APlannerItem.Text.Text);
            FMemo.SetFocus;

            SetEditDirectSelection(ARect, X, Y);
          end;
        peCustom:
          begin
            ER.Left := ARect.Left + 3;
            ER.Top := ARect.Top + 3  + ColumnHeight;
            ER.Right := ARect.Right - 3;
            ER.Bottom := ARect.Top + ItemHeight - 6;
            if Assigned(FPlanner.FOnCustomEdit) then
              FPlanner.FOnCustomEdit(Self,ER,APlannerItem);
          end;
      end;
  end;
end;


function TAdvHeader.GetSectionIdx(X: Integer): Integer;
var
  FPlanner: TCustomPlanner;
begin
  FPlanner := Owner as TCustomPlanner;

  if FPlanner.SideBar.Position = spTop then
    Result := X + FPlanner.FGrid.TopRow - 1
  else
    Result := X + FPlanner.FGrid.LeftCol - 1;
end;

procedure TAdvHeader.SetFixedColor(const Value: TColor);
begin
  FFixedColor := Value;
  Invalidate;
end;

procedure TAdvHeader.SetFixedHeight(const Value: Integer);
begin
  FFixedHeight := Value;
  Invalidate;
end;

procedure TAdvHeader.SetShowFixed(const Value: Boolean);
begin
  FShowFixed := Value;
  Invalidate;
end;

{ TPlannerColorArrayList }

function TPlannerColorArrayList.Add: PPlannerColorArray;
begin
  New(Result);
  inherited Add(Result);
end;

constructor TPlannerColorArrayList.Create;
begin
  inherited;
end;

procedure TPlannerColorArrayList.Delete(Index: Integer);
begin
  if Assigned(Items[Index]) then
    Dispose(Items[Index]);
  inherited Delete(Index);
end;

destructor TPlannerColorArrayList.Destroy;
var
  Index: Integer;
begin
  for Index := 0 to Self.Count - 1 do
    if Assigned(Items[Index]) then
      Dispose(Items[Index]);
  inherited;
end;

function TPlannerColorArrayList.GetArray(
  Index: Integer): PPlannerColorArray;
begin
  Result := PPlannerColorArray(inherited Items[Index]);
end;

procedure TPlannerColorArrayList.SetArray(Index: Integer;
  Value: PPlannerColorArray);
begin
  inherited Items[Index] := Value;
end;

{ TPlannerPrintOptions }

constructor TPlannerPrintOptions.Create;
begin
  inherited Create;
  FHeaderFont := TFont.Create;
  FFooterFont := TFont.Create;
  FFooter := TStringList.Create;
  FHeader := TStringList.Create;
  FFitToPage := True;
end;

destructor TPlannerPrintOptions.Destroy;
begin
  FFooterFont.Free;
  FHeaderFont.Free;
  FFooter.Free;
  FHeader.Free;
  inherited;
end;

procedure TPlannerPrintOptions.SetFooter(const Value: TStrings);
begin
  if Assigned(Value) then
    FFooter.Assign(Value);
end;

procedure TPlannerPrintOptions.SetFooterFont(const Value: TFont);
begin
  if Assigned(Value) then
    FFooterFont.Assign(Value);
end;

procedure TPlannerPrintOptions.SetHeader(const Value: TStrings);
begin
  if Assigned(Value) then
    FHeader.Assign(Value);
end;

procedure TPlannerPrintOptions.SetHeaderFont(const Value: TFont);
begin
  if Assigned(Value) then
    FHeaderFont.Assign(Value);
end;

{ TPlannerHTMLOptions }

constructor TPlannerHTMLOptions.Create;
begin
  inherited Create;
  FBorderSize := 1;
  FCellSpacing := 0;
  FWidth := 100;
end;

{ TPlannerItemIO }

constructor TPlannerItemIO.CreateItem(AOwner: TPlannerItems);
begin
  inherited Create(nil);

  FItem := TPlannerItem(AOwner.GetItemClass.Create(AOwner));
end;

destructor TPlannerItemIO.Destroy;
begin
  FItem.Free;
  inherited;
end;

{ TWeekDays }

procedure TWeekDays.Changed;
begin
  if Assigned(OnChanged) then
    OnChanged(Self);
end;

constructor TWeekDays.Create;
begin
  FSun := True;
  FSat := True;
end;

procedure TWeekDays.SetFri(const Value: Boolean);
begin
  FFri := Value;
  Changed;
end;

procedure TWeekDays.SetMon(const Value: Boolean);
begin
  FMon := Value;
  Changed;
end;

procedure TWeekDays.SetSat(const Value: Boolean);
begin
  FSat := Value;
  Changed;
end;

procedure TWeekDays.SetSun(const Value: Boolean);
begin
  FSun := Value;
  Changed;
end;

procedure TWeekDays.SetThu(const Value: Boolean);
begin
  FThu := Value;
  Changed;
end;

procedure TWeekDays.SetTue(const Value: Boolean);
begin
  FTue := Value;
  Changed;
end;

procedure TWeekDays.SetWed(const Value: Boolean);
begin
  FWed := Value;
  Changed;
end;

{ TPlannerPanel }

function TPlannerPanel.IsAnchor(x, y: Integer): string;
var
  r,hr: TRect;
  XSize,YSize, ml, hl: Integer;
  a,s,fa:string;
  CID, CV, CT: string;
  cr: TRect;

begin
  r := ClientRect;
  a := '';

  if HTMLDrawEx(Canvas, Caption, r, (Owner as TCustomPlanner).PlannerImages, x, y,
            -1, -1, 1, True, False, False, True, True, False, True
            , False
            , 1.0, clBlue, clNone, clNone, clGray, a, s, fa, XSize, YSize, ml, hl, hr
            ,cr, CID, CV, CT, (Owner as TCustomPlanner).FImageCache, (Owner as TCustomPlanner).FContainer, Handle
            ) then
    Result := a;
end;

procedure TPlannerPanel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Anchor: string;
begin
  inherited;

  if Pos('</',Caption) = 0 then
    Exit;

  Anchor := IsAnchor(X,Y);

  if Anchor <> '' then
  begin
    with Owner as TCustomPlanner do
    begin
      if Assigned(FOnCaptionAnchorClick) then
        FOnCaptionAnchorClick(Self.Owner,x,y,Anchor);
    end;
  end;
end;

procedure TPlannerPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Anchor: string;
begin
  inherited;

  if Pos('</',Caption) = 0 then
    Exit;

  Anchor := IsAnchor(X,Y);

  if Anchor <> '' then
  begin
    if (Cursor = crDefault) or (FOldAnchor <> Anchor) then
    begin
      Self.Cursor := crHandPoint;

      with Owner as TCustomPlanner do
      begin
        if Assigned(FOnCaptionAnchorEnter) then
          FOnCaptionAnchorEnter(self.Owner,x,y,Anchor);
      end;
    end;
    FOldAnchor := Anchor;
  end
  else
  begin
    if (self.Cursor = crHandPoint) then
    begin
      Self.Cursor:=crDefault;

      with (Owner as TCustomPlanner) do
      begin
        if Assigned(FOnCaptionAnchorExit) then
          FOnCaptionAnchorExit(self.Owner,x,y,FOldAnchor);
      end;
      FOldAnchor := '';
    end;
  end;

end;

procedure TPlannerPanel.Paint;
var
  DoDraw: Boolean;
  a,s,fa: string;
  CID,CV,CT : string;
  cr: TRect;
  XSize, YSize, ml, hl: Integer;
  hr: TRect;
  FPlanner: TCustomPlanner;
  DTFLAGS: DWORD;

begin
  FPlanner := (Owner as TCustomPlanner);
  DoDraw := True;
  if Assigned(FPlanner.OnPlannerCaptionDraw) then
    FPlanner.OnPlannerCaptionDraw(FPlanner, Canvas, GetClientRect, DoDraw);
  if DoDraw then

  begin
    if (Pos('</',Caption) > 0) or ((Owner as TCustomPlanner).Caption.BackGroundTo <> clNone) then
    begin
      Canvas.Brush.Color := (Owner as TCustomPlanner).Caption.BackGround;
      Canvas.Pen.Color := Canvas.Brush.Color;

      if ((Owner as TCustomPlanner).Caption.BackGroundTo <> clNone) then
        DrawGradient(Canvas,Canvas.Brush.Color,(Owner as TCustomPlanner).Caption.BackGroundTo,
           (Owner as TCustomPlanner).Caption.BackgroundSteps,ClientRect,True)
      else
        Canvas.Rectangle(ClientRect.Left,ClientRect.Top,ClientRect.Right,ClientRect.Bottom);

      Canvas.Font.Assign(Font);

      if (Pos('</',Caption) > 0) then
      begin
        HTMLDrawEx(Canvas, Caption, ClientRect, (Owner as TCustomPlanner).PlannerImages, 0, 0,
              -1, -1, 1, False, False, False, False, False, False, True
              , False
              , 1.0, (Owner as TCustomPlanner).URLColor, clNone, clNone, clGray, a, s, fa,
              XSize, YSize, ml, hl, hr
              ,cr, CID, CV, CT, FPlanner.FImageCache, FPlanner.FContainer, Handle
              );
      end
      else
      begin
        if Pos(#13,Caption) = 0 then
          DTFLAGS := DT_VCENTER or DT_END_ELLIPSIS or DT_SINGLELINE
        else
          DTFLAGS := DT_END_ELLIPSIS or DT_WORDBREAK;

        case (Owner as TCustomPlanner).Caption.Alignment of
        taLeftJustify: DTFLAGS := DTFLAGS or DT_LEFT;
        taRightJustify: DTFLAGS := DTFLAGS or DT_RIGHT;
        taCenter: DTFLAGS := DTFLAGS or DT_CENTER;
        end;
        cr := ClientRect;       

        SetBkMode(Canvas.Handle,TRANSPARENT);
        DrawText(Canvas.Handle,PChar(Caption),Length(Caption),cr,DTFLAGS);

      end;
    end
    else
      inherited;
  end;
end;

{ TPlannerScrollBar }

constructor TPlannerScrollBar.Create(AOwner: TCustomPlanner);
begin
  inherited Create;
  FOwner := AOwner;
  FStyle := ssNormal;
  FWidth := 16;
  FColor := clNone;
  FFlat := False;
end;

procedure TPlannerScrollBar.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    UpdateProps;
  end;
end;

procedure TPlannerScrollBar.SetFlat(const Value: Boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    if FFlat then
      FOwner.FGrid.FlatScrollInit
    else
      FOwner.FGrid.FlatScrollDone;


    if FOwner.PositionWidth = 0 then
    begin
      if FOwner.SideBar.Position = spTop then
        FOwner.FGrid.FlatShowScrollBar(SB_VERT,FALSE)
      else
        FOwner.FGrid.FlatShowScrollBar(SB_HORZ,FALSE);
    end;

  end;
end;

procedure TPlannerScrollBar.SetStyle(const Value: TPlannerScrollStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    UpdateProps;
  end;
end;

procedure TPlannerScrollBar.SetWidth(const Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    UpdateProps;
  end;
end;

procedure TPlannerScrollBar.UpdateProps;
begin
  if FFlat then
  begin
    if FColor <>clNone then
    begin
      FOwner.FGrid.FlatSetScrollProp(WSB_PROP_VBKGCOLOR,Integer(FColor),True);
      FOwner.FGrid.FlatSetScrollProp(WSB_PROP_HBKGCOLOR,Integer(FColor),True);
    end;

    FOwner.FGrid.FlatSetScrollProp(WSB_PROP_CXVSCROLL,FWidth,True);
    FOwner.FGrid.FlatSetScrollProp(WSB_PROP_CYHSCROLL,FWidth,True);

    case FStyle of
    ssNormal:FOwner.FGrid.FlatSetScrollProp(WSB_PROP_VSTYLE,FSB_REGULAR_MODE,True);
    ssFlat:FOwner.FGrid.FlatSetScrollProp(WSB_PROP_VSTYLE,FSB_FLAT_MODE,True);
    ssEncarta:FOwner.FGrid.FlatSetScrollProp(WSB_PROP_VSTYLE,FSB_ENCARTA_MODE,True);
    end;

    case FStyle of
    ssNormal:FOwner.FGrid.FlatSetScrollProp(WSB_PROP_HSTYLE,FSB_REGULAR_MODE,True);
    ssFlat:FOwner.FGrid.FlatSetScrollProp(WSB_PROP_HSTYLE,FSB_FLAT_MODE,True);
    ssEncarta:FOwner.FGrid.FlatSetScrollProp(WSB_PROP_HSTYLE,FSB_ENCARTA_MODE,True);
    end;
  end;
end;

{ TBackground }

procedure TBackground.BackgroundChanged(Sender: TObject);
begin
  FPlanner.FGrid.Invalidate;
end;

constructor TBackground.Create(APlanner: TCustomPlanner);
begin
  inherited Create;
  FPlanner := APlanner;
  FBitmap := TBitmap.Create;
  FBitmap.OnChange := BackgroundChanged;
end;

destructor TBackground.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TBackground.SetBitmap(Value: TBitmap);
begin
  FBitmap.Assign(Value);
  FPlanner.Invalidate;
end;

procedure TBackground.SetDisplay(Value: TBackgroundDisplay);
begin
  if FDisplay <> Value then
  begin
    FDisplay := Value;
    FPlanner.Invalidate;
  end;
end;

procedure TBackground.SetLeft(Value: Integer);
begin
  if FLeft <> Value then
  begin
    FLeft := Value;
    FPlanner.Invalidate;
  end;
end;

procedure TBackground.SetTop(Value: Integer);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    FPlanner.Invalidate;
  end;
end;

{ TPlannerAlarmHandler }

function TPlannerAlarmHandler.HandleAlarm(Address, Message: string; Tag,
  ID: Integer; Item: TPlannerItem): Boolean;
begin
  Result := True;
end;

{ TAlarmMessage }

function TAlarmMessage.HandleAlarm(Address, Message: string; Tag,
  ID: Integer; Item: TPlannerItem): Boolean;
begin
  case Item.Alarm.NotifyType of
  anMessage:MessageDlg(Item.Alarm.Message,mtInformation,[mbok],0);
  anNotes:MessageDlg(HTMLStrip(Item.Text.Text),mtInformation,[mbok],0);
  anCaption:MessageDlg(Item.CaptionText,mtInformation,[mbok],0);
  end;
  Result := True;
end;

{ TAdvSpeedButton }

procedure TAdvSpeedButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TAdvSpeedButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

constructor TAdvSpeedButton.Create(AOwner: TComponent);
var
  VerInfo: TOSVersioninfo;
begin
  inherited;
  Flat := True; // change default value
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(verinfo);
  FIsWinXP := (verinfo.dwMajorVersion > 5) OR
    ((verinfo.dwMajorVersion = 5) AND (verinfo.dwMinorVersion >= 1));
end;

procedure TAdvSpeedButton.Paint;
const
  DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
var
  PaintRect: TRect;
  Offset: TPoint;
  DrawFlags: Integer;
  HTheme: THandle;
  Hot: Boolean;
  pt: TPoint;
begin
  Canvas.Font := Self.Font;
  PaintRect := Rect(0, 0, Width, Height);

  if FIsWinXP then
  begin
    if IsThemeActive then
    begin
      GetCursorPos(pt);
      pt := ScreenToClient(pt);

      Hot := PtInRect(PaintRect,pt);

      HTheme := OpenThemeData(Parent.Handle,'Scrollbar');

      if Direction = bdLeft then
      begin
        if FState in [bsDown, bsExclusive] then
          DrawThemeBackground(HTheme,Canvas.Handle, SBP_ARROWBTN,ABS_LEFTPRESSED,@PaintRect,nil)
        else
        if Hot then
          DrawThemeBackground(HTheme,Canvas.Handle, SBP_ARROWBTN,ABS_LEFTHOT,@PaintRect,nil)
        else
          DrawThemeBackground(HTheme,Canvas.Handle, SBP_ARROWBTN,ABS_LEFTNORMAL,@PaintRect,nil)
      end
      else
      begin
        if FState in [bsDown, bsExclusive] then
          DrawThemeBackground(HTheme,Canvas.Handle, SBP_ARROWBTN,ABS_RIGHTPRESSED,@PaintRect,nil)
        else
        if Hot then
          DrawThemeBackground(HTheme,Canvas.Handle, SBP_ARROWBTN,ABS_RIGHTHOT,@PaintRect,nil)
        else
          DrawThemeBackground(HTheme,Canvas.Handle, SBP_ARROWBTN,ABS_RIGHTNORMAL,@PaintRect,nil);
      end;
      CloseThemeData(HTheme);
      Exit;
    end;  
  end;

  if not Flat then
  begin
    DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
    if FState in [bsDown, bsExclusive] then
      DrawFlags := DrawFlags or DFCS_PUSHED;
    DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
  end
  else
  begin
    DrawEdge(Canvas.Handle, PaintRect, DownStyles[FState in [bsDown, bsExclusive]],
      BF_MIDDLE or BF_RECT);
    InflateRect(PaintRect, -1, -1);
  end;

  if not (FState in [bsDown, bsExclusive]) then
  begin
    Offset.X := 0;
    Offset.Y := 0;
  end;


  if Assigned(Glyph) then
    if not Glyph.Empty then
    begin
      Glyph.Transparent := True;
      Offset.X := 0;
      Offset.Y := 0;
      if Glyph.Width < Width then
        Offset.X := (Width - Glyph.Width) shr 1;
      if Glyph.Height < Height then
        Offset.Y := (Height - Glyph.Height) shr 1;

      if FState = bsDown then
        Canvas.Draw(Offset.X + 1 ,Offset.Y + 1,Glyph)
      else
        Canvas.Draw(Offset.X ,Offset.Y,Glyph)
    end
    else
    begin
      if FState = bsDown then
      begin
        Offset.X := 5;
        Offset.Y := 5;
      end
      else
      begin
        Offset.X := 4;
        Offset.Y := 4;
      end;
      
      Canvas.TextRect(PaintRect,Offset.X,Offset.Y,Caption);
    end;
end;

{ TPositionProps }

function TPositionProps.Add: TPositionProp;
begin
  Result := TPositionProp(Inherited Add);
end;

constructor TPositionProps.Create(AOwner: TCustomPlanner);
begin
  Inherited Create(TPositionProp);
  FOwner := AOwner;
end;

function TPositionProps.GetItem(Index: Integer): TPositionProp;
begin
  Result := TPositionProp(inherited Items[Index]);
end;

function TPositionProps.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TPositionProps.Insert(Index: Integer): TPositionProp;
begin
  {$IFDEF DELPHI4_LVL}
  Result := TPositionProp(Inherited Insert(Index));
  {$ELSE}
  Result := TPositionProp(Inherited Add);
  {$ENDIF}
end;

procedure TPositionProps.SetItem(Index: Integer;
  const Value: TPositionProp);
begin
  inherited SetItem(Index, Value);
end;

{ TPositionProp }

procedure TPositionProp.Assign(Source: TPersistent);
begin
  inherited;
  FActiveStart := (Source as TPositionProp).ActiveStart;
  FActiveEnd := (Source as TPositionProp).ActiveEnd;
  FBackground := (Source as TPositionProp).Background;
  FColorActive := (Source as TPositionProp).ColorActive;
  FColorNonActive := (Source as TPositionProp).ColorNonActive;
  FMinSelection := (Source as TPositionProp).MinSelection;
  FMaxSelection := (Source as TPositionProp).MaxSelection;
  FColorNoSelect := (Source as TPositionProp).ColorNoSelect;
  FBrushNoSelect := (Source as TPositionProp).BrushNoSelect;
  FUse := (Source as TPositionProp).Use;
end;

procedure TPositionProp.BackgroundChanged(Sender: TObject);
begin
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

constructor TPositionProp.Create(Collection: TCollection);
begin
  inherited;
  FActiveStart := TPositionProps(Collection).FOwner.Display.ActiveStart;
  FActiveEnd := TPositionProps(Collection).FOwner.Display.ActiveEnd;
  FColorActive := TPositionProps(Collection).FOwner.Display.ColorActive;
  FColorNonActive := TPositionProps(Collection).FOwner.Display.ColorNonActive;
  FColorNoSelect := clRed;
  FBrushNoSelect := bsSolid;
  FBackground := TBitmap.Create;
  FBackground.OnChange := BackgroundChanged;
  FUse := True;
end;

destructor TPositionProp.Destroy;
begin
  TPositionProps(Collection).FOwner.Invalidate;
  FBackground.Free;
  inherited;
end;

procedure TPositionProp.SetActiveEnd(const Value: Integer);
begin
  FActiveEnd := Value;
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

procedure TPositionProp.SetActiveStart(const Value: Integer);
begin
  FActiveStart := Value;
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

procedure TPositionProp.SetBackground(const Value: TBitmap);
begin
  FBackground.Assign(Value);
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

procedure TPositionProp.SetBrushNoSelect(const Value: TBrushStyle);
begin
  FBrushNoSelect := Value;
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

procedure TPositionProp.SetColorActive(const Value: TColor);
begin
  FColorActive := Value;
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

procedure TPositionProp.SetColorNonActive(const Value: TColor);
begin
  FColorNonActive := Value;
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

procedure TPositionProp.SetColorNoSelect(const Value: TColor);
begin
  FColorNoSelect := Value;
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

procedure TPositionProp.SetMaxSelection(const Value: Integer);
begin
  FMaxSelection := Value;
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

procedure TPositionProp.SetMinSelection(const Value: Integer);
begin
  FMinSelection := Value;
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

procedure TPositionProp.SetUse(const Value: Boolean);
begin
  FUse := Value;
  TPositionProps(Collection).FOwner.FGrid.Invalidate;
end;

{ TPlannerExChange }

procedure TPlannerExChange.DoExport;
begin

end;

procedure TPlannerExChange.DoImport;
begin

end;

procedure TPlannerExChange.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FPlanner) then
    FPlanner := nil;
  inherited;
end;

function TPlannerExChange.NumItemsForExport: Integer;
var
  i: Integer;
begin
  Result := 0;
  
  if not Assigned(FPlanner) then
    Exit;

  for i := 1 to FPlanner.Items.Count do
  begin
    if FPlanner.Items[i - 1].DoExport then
      Result := Result + 1;
  end;
end;

{ TPlannerAlarm }

procedure TPlannerAlarm.Assign(Source: TPersistent);
begin
  Active := TPlannerAlarm(Source).Active;
  Address := TPlannerAlarm(Source).Address;
  Handler := TPlannerAlarm(Source).Handler;
  ID := TPlannerAlarm(Source).ID;
  Message := TPlannerAlarm(Source).Message;
  NotifyType := TPlannerAlarm(Source).NotifyType;
  Tag := TPlannerAlarm(Source).Tag;
  TimeBefore := TPlannerAlarm(Source).TimeBefore;
  TimeAfter := TPlannerAlarm(Source).TimeAfter;
  Time := TPlannerAlarm(Source).Time;
end;


{ TPlannerBarItem }

function TPlannerBarItem.CheckOwners: Boolean;
begin
  Result := False;

  // check for list
  if not Assigned(Owner) then
    Exit;
  // check for planner item
  if not Assigned(Owner.Owner) then
    Exit;
  // check for planner
  if not Assigned(Owner.Owner.Owner) then
    Exit;

  Result := True;  
end;

constructor TPlannerBarItem.create( pOwner: TPlannerBarItemList);
begin
  inherited Create;
  FOwner := pOwner;
  FColor := clGreen;
  FBegin := -1;
  FEnd := -1;
  FStyle := bsSolid;
  FOnDestroy := nil;
end;

destructor TPlannerBarItem.Destroy;
begin
  if Assigned(FOwner) then
    FOwner.Remove(Self);
  if Assigned(FOnDestroy) then
    FOnDestroy(Self);
  inherited;
end;

function TPlannerBarItem.GetEndTime: TDateTime;
var
  du: Integer;
begin
  Result := 0;

  if not CheckOwners then
    Exit;

  // Get display unit from planner
  du := Owner.Owner.Owner.Display.displayUnit;

  Result := (BarEnd * du) / 24 /60 + Owner.Owner.ItemStartTime;
end;

function TPlannerBarItem.GetStartTime: TDateTime;
var
  du: Integer;
begin
  Result := 0;

  if not CheckOwners then
    Exit;

  // Get display unit from planner
  du := Owner.Owner.Owner.Display.displayUnit;

  Result := (BarBegin * du) / 24 /60 + Owner.Owner.ItemStartTime;
end;

procedure TPlannerBarItem.SetEndTime(const pEndTime: TDateTime);
var
  du: Integer;
  dDiff: Double;
begin
  if not CheckOwners then
    Exit;

  // Get display unit from planner
  du := Owner.Owner.Owner.Display.DisplayUnit;
  dDiff := Frac(pEndTime - Owner.Owner.ItemStartTime);

  // if over start of day
  if dDiff < 0 then dDiff := dDiff + 1;

  BarEnd := Round(dDiff * 24 * 60  / du);
end;

procedure TPlannerBarItem.SetStartTime(const pStartTime: TDateTime);
var
  du: Integer;
  dDiff: Double;
begin
  if not CheckOwners then
    Exit;

  // get display unit from planner
  du := Owner.Owner.Owner.Display.DisplayUnit;
  dDiff := Frac(pStartTime - Owner.Owner.ItemStartTime);

  // if over start of day
  if dDiff < 0 then dDiff := dDiff + 1;

  BarBegin := Round(dDiff * 24 * 60  / du);
end;

{ TPlannerBarItemList }

constructor TPlannerBarItemList.Create(AOwner: TPlannerItem);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TPlannerBarItemList.getItem(Index: Integer): TPlannerBarItem;
begin
  Result := nil;
  if (( Index > -1) and ( Index < Count)) then
    Result := TPlannerBarItem( inherited Items[ Index]);
end;

function TPlannerBarItemList.AddItem(pStart, pEnd: TDateTime;
  pColor: TColor; pStyle: TBrushStyle): Integer;
var
  pbi: TPlannerBarItem;
begin
  Result := -1;
  if pEnd < pStart then
    Exit;
  pbi := TPlannerBarItem.create(Self);
  pbi.StartTime := pStart;
  pbi.EndTime := pEnd;
  pbi.BarColor := pColor;
  pbi.BarStyle := pStyle;
  Result := inherited Add(pbi);
end;

destructor TPlannerBarItemList.Destroy;
var
  i: Integer;
begin
  if Count > 0 then
    for i := Count - 1 downto 0 do
      Items[ i].free;
  inherited;
end;



{ TBands }

constructor TBands.Create(AOwner: TCustomPlanner);
begin
  inherited Create;
  FOwner := AOwner;
  FActivePrimary := $00FEE7CB;
  FActiveSecondary := $00FAD9AF;
  FNonActivePrimary := clSilver;
  FNonActiveSecondary := $00A8A8A8;
end;

procedure TBands.SetActivePrimary(const Value: TColor);
begin
  FActivePrimary := Value;
  FOwner.Invalidate;
end;

procedure TBands.SetActiveSecondary(const Value: TColor);
begin
  FActiveSecondary := Value;
  FOwner.Invalidate;
end;

procedure TBands.SetNonActivePrimary(const Value: TColor);
begin
  FNonActivePrimary := Value;
  FOwner.Invalidate;
end;

procedure TBands.SetNonActiveSecondary(const Value: TColor);
begin
  FNonActiveSecondary := Value;
  FOwner.Invalidate;
end;

procedure TBands.SetShow(const Value: Boolean);
begin
  FShow := Value;
  FOwner.Invalidate;
end;


{ TCustomItemEditor }

procedure TCustomItemEditor.CreateEditor(AOwner: TComponent);
begin
end;

procedure TCustomItemEditor.DestroyEditor;
begin
  If Assigned(FOnEditDone) Then
    FOnEditDone(Self, ModalResult);
end;

procedure TCustomItemEditor.Edit(APlanner: TCustomPlanner; APlannerItem: TPlannerItem);
begin
  FPlanner := APlanner;
  if QueryEdit(APlannerItem) then
  begin
    CreateEditor(APlanner.Owner);
    try //##jpl

      //FEditItem := TPlannerItem(APlanner.Items.GetItemClass.Create(APlanner.Items));
      //FEditItem.Assign(APlannerItem);

      PlannerItemToEdit(APlannerItem);
      if Execute = mrOK then
        EditToPlannerItem(APlannerItem);

    finally //##jpl
      DestroyEditor;
    end;
  end;
end;


procedure TCustomItemEditor.EditToPlannerItem(APlannerItem: TPlannerItem);
begin

end;

function TCustomItemEditor.Execute: Integer;
begin
  Result := mrOK;
end;

procedure TCustomItemEditor.PlannerItemToEdit(APlannerItem: TPlannerItem);
begin

end;

function TCustomItemEditor.QueryEdit(APlannerItem: TPlannerItem): Boolean;
begin
  Result := True;
end;

{ TCustomItemDrawTool }

procedure TCustomItemDrawTool.DrawItem(PlannerItem: TPlannerItem;
  Canvas: TCanvas; Rect: TRect; Selected, Print: Boolean);
begin

end;

{ TPlannerItemSelection }

procedure TPlannerItemSelection.Assign(Source: TPersistent);
begin
  if Assigned(Source) then
  begin
    FAutoUnSelect := (Source as TPlannerItemSelection).AutoUnSelect;
    FButton := (Source as TPlannerItemSelection).Button;
  end;
end;

constructor TPlannerItemSelection.Create;
begin
  inherited Create;
  FAutoUnSelect := True;
  Button := sbLeft;
end;

initialization

{$IFDEF ACTIVEXDEBUG}
  ShowMessage('Initialization Start');
{$ENDIF}

//  if FindClassHInstance(TPlannerItem) = 0 then
//  begin

    RegisterClass(TSpeedButton);
    RegisterClass(TPlannerGrid);
    RegisterClass(TPlannerItem);
    RegisterClass(TPlannerItems);
    RegisterClass(TPlannerPanel);
    RegisterClass(TPlannerAlarm);
    RegisterClass(THeader);

    CF_PLANNERITEM := RegisterClipboardFormat('TPlanner Item');

//  end;

    Screen.Cursors[crZoomIn] := LoadCursor(hinstance,'TMSZOOMIN');
    Screen.Cursors[crZoomOut] := LoadCursor(hinstance,'TMSZOOMOUT');

{$IFDEF ACTIVEXDEBUG}
  ShowMessage('Initialization Done');
{$ENDIF}

finalization



end.
