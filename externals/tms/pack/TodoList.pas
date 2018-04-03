{*************************************************************************}
{ TTodoList component                                                     }
{ for Delphi & C++Builder                                                 }
{ version 1.2                                                             }
{                                                                         }
{ Copyright © 2001-2003 by TMS software                                   }
{ Email : info@tmssoftware.com                                            }
{ Web : http://www.tmssoftware.com                                        }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit TodoList;

{
  With the USE_PLANNERDATEPICKER definition disabled, the component uses the
  Win32 date picker component for date editing. It's colors can be set using
  the EditColors.DefaultDateEditor property.

  With the USE_PLANNERDATEPICKER definition enabled, the component has a
  CalendarType property. The programmer can choose to use the Win32 date
  picker, or to use the TMS date picker.

  The colors of the TMS date picker can be set using the
  EditColors.PlannerDateEditor property.

  So, for editing the colors of the Win32 date picker, we use the
  EditColors.DefaultDateEditor property, and for editing the colors of
  the TMS date picker, we use the EditColors.PlannerDateEditor property.
}

// {$DEFINE USE_PLANNERDATEPICKER}

{ $INCLUDE TMSDEFS.INC}
{$R TODOLIST.RES}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, ExtCtrls,
  Forms, Spin, ComCtrls, ImgList, Math
  {$IFDEF USE_PLANNERDATEPICKER}
  , PlannerCal, PlannerDatePicker
  {$ENDIF}
  ;

const
  CHECKBOXSIZE = 14;
{$IFNDEF DELPHI3_LVL}
  crHandPoint = crUpArrow;
{$ENDIF}

type
  TTodoListBox = class;
  TCustomTodoList = class;

  TTodoData = (tdSubject,tdCompletion,tdNotes,tdPriority,tdDueDate,tdStatus,
               tdImage,tdComplete,tdTotalTime,tdCompletionDate,tdCreationDate,
               tdResource, tdHandle, tdProject);

  TCheckType = (ctCheckBox,ctCheckMark,ctGlyph);

  TSortDirection = (sdAscending, sdDescending);

  TTodoDateTimePicker = class(TDateTimePicker)
  private
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
  published
  end;

  { TCompleteCheck }

  TCompleteCheck = class(TPersistent)
  private
    FUnCompletedGlyph: TBitmap;
    FCompletedGlyph: TBitmap;
    FCheckType: TCheckType;
    FOnChange: TNotifyEvent;
    procedure SetCheckType(const Value: TCheckType);
    procedure SetCompletedGlyph(const Value: TBitmap);
    procedure SetUnCompletedGlyph(const Value: TBitmap);
  protected
    procedure Changed;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property CompletedGlyph: TBitmap read FCompletedGlyph write SetCompletedGlyph;
    property UnCompletedGlyph: TBitmap read FUnCompletedGlyph write SetUnCompletedGlyph;
    property CheckType: TCheckType read FCheckType write SetCheckType;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TProgressLook }

  TProgressLook = class(TPersistent)
  private
    FUnCompleteFontColor: TColor;
    FCompleteColor: TColor;
    FUnCompleteColor: TColor;
    FCompleteFontColor: TColor;
    FOnChange: TNotifyEvent;
    procedure SetCompleteColor(const Value: TColor);
    procedure SetCompleteFontColor(const Value: TColor);
    procedure SetUnCompleteColor(const Value: TColor);
    procedure SetUnCompleteFontColor(const Value: TColor);
  protected
    procedure Changed;
  public
    constructor Create;
  published
    property CompleteColor: TColor read FCompleteColor write SetCompleteColor;
    property CompleteFontColor: TColor read FCompleteFontColor write SetCompleteFontColor;
    property UnCompleteColor: TColor read FUnCompleteColor write SetUnCompleteColor;
    property UnCompleteFontColor: TColor read FUnCompleteFontColor write SetUnCompleteFontColor;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TTodoColumnItem = class(TCollectionItem)
  private
    FWidth: Integer;
    FAlignment: TAlignment;
    FFont: TFont;
    FColor: TColor;
    FTodoData: TTodoData;
    FCaption: string;
    FOnChange: TNotifyEvent;
    FEditable: Boolean;
    procedure SetWidth(const value:Integer);
    procedure SetAlignment(const value:tAlignment);
    procedure SetFont(const value:TFont);
    procedure SetColor(const value:TColor);
    procedure SetTodoData(const Value: TTodoData);
    procedure SetCaption(const Value: string);
  protected
    function GetDisplayName: string; override;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Changed; virtual;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Alignment: TAlignment read fAlignment write SetAlignment;
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor;
    property Font: TFont read FFont write SetFont;
    property TodoData: TTodoData read FTodoData write SetTodoData;
    property Width: Integer read FWidth write SetWidth;
    property Editable : Boolean read FEditable write FEditable; // Can this column be edited in-place by the user?
  end;

  TTodoColumnCollection = class(TCollection)
  private                                  
    FOwner: TTodoListBox;
    function GetItem(Index: Integer): TTodoColumnItem;
    procedure SetItem(Index: Integer; const Value: TTodoColumnItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTodoListBox);
    procedure Swap(Item1,Item2: TTodoColumnItem);
    function Add: TTodoColumnItem;
    function Insert(Index: Integer): TTodoColumnItem;
    property Items[Index: Integer]: TTodoColumnItem read GetItem write SetItem; default;
    function GetOwner: TPersistent; override;
  end;

  TTodoStatus = (tsNotStarted,tsCompleted,tsInProgress,tsDeferred);
  TTodoPriority = (tpLowest,tpLow,tpNormal,tpHigh,tpHighest);
  EConversionFunctionException = class(Exception);

  TStatusStrings = class(TPersistent)
  private
    FOwner: TCustomTodoList;
    FStatusStrings: array[Low(TTodoStatus)..High(TTodoStatus)] of String;
    function GetStringD: String;
    procedure SetStringD(const Value: String);
    function GetStringC: String;
    procedure SetStringC(const Value: String);
    function GetStringI: String;
    procedure SetStringI(const Value: String);
    function GetStringN: String;
    procedure SetStringN(const Value: String);
    function GetString(Index: TTodoStatus): String;
    procedure SetString(Index: TTodoStatus; const Value: String);
  protected
    property Owner: TCustomTodoList read FOwner;
  public
    constructor Create(AOwner: TCustomTodoList);
    property Items[Index: TTodoStatus]: String read GetString write SetString; default;
  published
    property Deferred: String read GetStringD write SetStringD;
    property NotStarted: String read GetStringN write SetStringN;
    property Completed: String read GetStringC write SetStringC;
    property InProgress: String read GetStringI write SetStringI;
  end;

  TPriorityStrings = class(TPersistent)
  private
    FOwner: TCustomTodoList;
    FPriorityStrings: array[Low(TTodoPriority)..High(TTodoPriority)] of String;
    function GetStringH: String;
    function GetStringHS: String;
    function GetStringL: String;
    function GetStringLS: String;
    function GetStringN: String;
    procedure SetStringH(const Value: String);
    procedure SetStringHS(const Value: String);
    procedure SetStringL(const Value: String);
    procedure SetStringLS(const Value: String);
    procedure SetStringN(const Value: String);
    function GetString(Index: TTodoPriority): String;
    procedure SetString(Index: TTodoPriority; const Value: String);
  protected
    property Owner: TCustomTodoList read FOwner;
  public
    constructor Create(AOwner: TCustomTodoList);
    property Items[Index: TTodoPriority]: String read GetString write SetString; default;
  published
    property Lowest: String read GetStringLS write SetStringLS;
    property Low: String read GetStringL write SetStringL;
    property Normal: String read GetStringN write SetStringN;
    property High: String read GetStringH write SetStringH;
    property Highest: String read GetStringHS write SetStringHS;
  end;

  TEditColors = class;

  TBackForeColors = class(TPersistent)
  private
    FColorControl: TWinControl;
    FOwner: TEditColors;
    procedure SetFontColor(const Value: TColor);
    procedure SetBackColor(const Value: TColor);
    function GetBackColor: TColor;
    function GetFontColor: TColor;
  public
    constructor Create(AOwner: TEditColors; AColorControl: TWinControl);
    property ColorControl: TWinControl read FColorControl write FColorControl;
    property Owner: TEditColors read FOwner;
  published
    property FontColor: TColor read GetFontColor write SetFontColor;
    property BackColor: TColor read GetBackColor write SetBackColor;
  end;

  TDatePickerColors = class(TPersistent)
  private
    FOwner: TEditColors;
    FColorControl: TTodoDateTimePicker;
    function GetBackColor: TColor;
    function GetFontColor: TColor;
    procedure SetBackColor(const Value: TColor);
    procedure SetFontColor(const Value: TColor);
    function GetCalColors: TMonthCalColors;
    procedure SetCalColors(const Value: TMonthCalColors);
  public
    constructor Create(AOwner: TEditColors; AColorControl: TTodoDateTimePicker);
    property Owner: TEditColors read FOwner;
  published
    property BackColor: TColor read GetBackColor write SetBackColor;
    property FontColor: TColor read GetFontColor write SetFontColor;
    property CalColors: TMonthCalColors read GetCalColors write SetCalColors;
  end;

{$IFDEF USE_PLANNERDATEPICKER}
  TPlannerDatePickerColors = class;

  TCalendarColors = class(TPersistent)
  private
    FOwner: TPlannerDatePickerColors;
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    function GetEventDayColor: TColor;
    procedure SetEventDayColor(const Value: TColor);
    function GetEventMarkerColor: TColor;
    procedure SetEventMarkerColor(const Value: TColor);
    function GetFocusColor: TColor;
    procedure SetFocusColor(const Value: TColor);
    function GetHeaderColor: TColor;
    procedure SetHeaderColor(const Value: TColor);
    function GetInactiveColor: TColor;
    procedure SetInactiveColor(const Value: TColor);
    function GetSelectColor: TColor;
    procedure SetSelectColor(const Value: TColor);
    function GetSelectFontColor: TColor;
    procedure SetSelectFontColor(const Value: TColor);
    function GetTextColor: TColor;
    procedure SetTextColor(const Value: TColor);
    function GetWeekendColor: TColor;
    procedure SetWeekendColor(const Value: TColor);
  public
    constructor Create(AOwner: TPlannerDatePickerColors);
    property Owner: TPlannerDatePickerColors read FOwner;
  published
    property Color: TColor read GetColor write SetColor;
    property EventDayColor: TColor read GetEventDayColor write SetEventDayColor;
    property EventMarkerColor: TColor read GetEventMarkerColor write SetEventMarkerColor;
    property FocusColor: TColor read GetFocusColor write SetFocusColor;
    property HeaderColor: TColor read GetHeaderColor write SetHeaderColor;
    property InactiveColor: TColor read GetInactiveColor write SetInactiveColor;
    property SelectColor: TColor read GetSelectColor write SetSelectColor;
    property SelectFontColor: TColor read GetSelectFontColor write SetSelectFontColor;
    property TextColor: TColor read GetTextColor write SetTextColor;
    property WeekendColor: TColor read GetWeekendColor write SetWeekendColor;
  end;

  TPlannerDatePickerColors = class(TPersistent)
  private
    FOwner: TEditColors;
    FColorControl: TPlannerDatePicker;
    FCalendarColors: TCalendarColors;
    function GetBackColor: TColor;
    function GetFontColor: TColor;
    procedure SetBackColor(const Value: TColor);
    procedure SetFontColor(const Value: TColor);
  public
    constructor Create(AOwner: TEditColors; AColorControl: TPlannerDatePicker);
    destructor Destroy; override;
    property Owner: TEditColors read FOwner;
  published
    property BackColor: TColor read GetBackColor write SetBackColor;
    property FontColor: TColor read GetFontColor write SetFontColor;
    property CalendarColors: TCalendarColors read FCalendarColors write FCalendarColors;
  end;
{$ENDIF}

  TEditColors = class(TPersistent)
  private
    FOwner: TCustomTodoList;
    FStringEditor: TBackForeColors;
    FMemoEditor: TBackForeColors;
    FIntegerEditor: TBackForeColors;
    FPriorityEditor: TBackForeColors;
    FStatusEditor: TBackForeColors;
{$IFDEF USE_PLANNERDATEPICKER}
    FPlannerDateEditor: TPlannerDatePickerColors;
{$ENDIF}
    FDefaultDateEditor: TDatePickerColors;
  public
    property Owner: TCustomTodoList read FOwner;
    constructor Create(AOwner: TCustomTodoList);
    destructor Destroy; override;
  published
    property StringEditor: TBackForeColors read FStringEditor write FStringEditor;
    property MemoEditor: TBackForeColors read FMemoEditor write FMemoEditor;
    property IntegerEditor: TBackForeColors read FIntegerEditor write FIntegerEditor;
    property PriorityEditor: TBackForeColors read FPriorityEditor write FPriorityEditor;
    property StatusEditor: TBackForeColors read FStatusEditor write FStatusEditor;
{$IFDEF USE_PLANNERDATEPICKER}
    property PlannerDateEditor: TPlannerDatePickerColors read FPlannerDateEditor write FPlannerDateEditor;
    property DefaultDateEditor: TDatePickerColors read FDefaultDateEditor write FDefaultDateEditor;
{$ELSE}
    property DateEditor: TDatePickerColors read FDefaultDateEditor write FDefaultDateEditor;
{$ENDIF}
  end;

  { Some functions which work with this: TodoStatusToString,
  TodoStatusFromString, TodoStatusCommaText.

  The same naming convention for TodoPriority: TodoPriorityToString,
  TodoPriorityFromString, TodoPriorityCommaText

  If any of these functions fail, they raise an EConversionFunctionException.
  }

  TInplaceSpinEdit = class(TSpinEdit)
  private
    FTodoList: TTodoListBox;
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
  protected
  public
    constructor Create(AOwner: TComponent); override;
  published
  end;


  TInplaceListBox = class(TListBox)
  private
    FOldItemIndex: Integer;
    FOnSelected: TNotifyEvent;
    FMouseDown: Boolean;
    FTodoList: TTodoListBox;
    function GetItemIndexEx: Integer;
    procedure SetItemIndexEx(const Value: Integer);
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnSelected: TNotifyEvent read FOnSelected write FOnSelected;
    property ItemIndex: Integer read GetItemIndexEx write SetItemIndexEx;
  end;

  TInplaceODListBox = class(TInplaceListBox)
  private
    FImageList: TImageList;
    FTodoList: TTodoListBox;
  protected
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ImageList: TImageList read FImageList write FImageList;
  end;

  TInplaceMemo = class(TMemo)
  private
    FOldText: TStringList;
    FTodoList: TTodoListBox;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;  
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OrigLines: TStringList read FOldText;
  end;

  TInplaceEdit = class(TEdit)
  private
    FOldText: string;
    FTodoList: TTodoListBox;
    function GetText: string;
    procedure SetText(const Value: string);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Text: string read GetText write SetText;
  end;

  TCompletion = 0..100;

  TTodoItem = class(TCollectionItem)
  private
    FImageIndex: Integer;
    FNotes: TStringList;
    FTag: Integer;
    FTotalTime: Integer;
    FSubject: string;
    FCompletion: TCompletion;
    FDueDate: TDateTime;
    FPriority: TTodoPriority;
    FStatus: TTodoStatus;
    FOnChange: TNotifyEvent;
    FComplete: Boolean;
    FCreationDate: TDateTime;
    FCompletionDate: TDateTime;
    FResource: string;
    FDBKey: string;
    FProject: String;
    procedure SetImageIndex(const value:Integer);
    procedure StringsChanged(sender:TObject);
    procedure SetCompletion(const Value: TCompletion);
    procedure SetDueDate(const Value: TDateTime);
    procedure SetNotes(const Value: TStringList);
    procedure SetPriority(const Value: TTodoPriority);
    procedure SetStatus(const Value: TTodoStatus);
    procedure SetSubject(const Value: string);
    procedure SetTotalTime(const Value: Integer);
    procedure SetComplete(const Value: Boolean);
    procedure SetCompletionDate(const Value: TDateTime);
    procedure SetCreationDate(const Value: TDateTime);
    procedure SetResource(const Value: string);
    function GetNotesLine: string;
    procedure SetProject(const Value: String);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Changed; virtual;
    procedure Select;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);
    property DBKey: string read FDBKey write FDBKey;
    property NotesLine: string read GetNotesLine;
  published
    property Complete: Boolean read FComplete write SetComplete;
    property Completion: TCompletion read FCompletion write SetCompletion;
    property CompletionDate: TDateTime read FCompletionDate write SetCompletionDate;
    property CreationDate: TDateTime read FCreationDate write SetCreationDate;
    property DueDate: TDateTime read FDueDate write SetDueDate;
    property ImageIndex:Integer read FImageIndex write SetImageIndex;
    property Notes: TStringList read FNotes write SetNotes;
    property Priority: TTodoPriority read FPriority write SetPriority;
    property Project: String read FProject write SetProject;
    property Resource: string read FResource write SetResource;
    property Status: TTodoStatus read FStatus write SetStatus;
    property Subject: string read FSubject write SetSubject;
    property Tag:Integer read FTag write FTag;
    property TotalTime: Integer read FTotalTime write SetTotalTime;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TTodoItemCollection = class(TCollection)
  private
    FOwner: TTodoListBox;
    function GetItem(Index: Integer): TTodoItem;
    procedure SetItem(Index: Integer; const Value: TTodoItem);
  protected
    procedure Update(Item: TCollectionItem); override;
    procedure ItemChanged(Index: Integer);
  public
    constructor Create(AOwner: TTodoListBox);
    procedure Changed; virtual;
    function Add:TTodoItem;
    function Insert(Index: Integer): TTodoItem;
    function GetOwner: TPersistent; override;
    function IndexOf(s:string): TPoint;
    function IndexInTodoOf(col: Integer;s: string): Integer;
    function IndexInRowOf(row: Integer;s: string): Integer;
    property Items[Index: Integer]: TTodoItem read GetItem write SetItem; default;
  end;

  TTodoListBox = class(TCustomListBox)
  private
    // Variables that represent the current editing state
    ActiveEditor: TWinControl; // current active editor, or nil if no active editor
    EditedColumn: TTodoColumnItem;
    EditedItem: TTodoItem;

    { If ActiveEditor<>nil, then the Edited* variables represent the current
    edited column and item. }
    // The actual editor objects.
    StringEditor: TInplaceEdit;
    StringListEditor: TInplaceMemo;
    {$IFDEF USE_PLANNERDATEPICKER}
    PlannerDateEditor: TPlannerDatePicker;
    {$ENDIF}
    DefaultDateEditor: TTodoDateTimePicker;
    IntegerEditor: TInplaceSpinEdit;
    PriorityEditor: TInplaceODListBox;
    StatusEditor: TInplaceListBox;
    EditorParent: TForm;
    { end of in-place editor object }
    FOwner: TCustomTodoList;
    FImages: TImageList;
    FPriorityImageList: TImageList;
    FTodoColumns: TTodoColumnCollection;
    FTodoItems: TTodoItemCollection;
    FGridLines: Boolean;
    FItemIndex: Integer;
    FUpdateCount: Integer;
    FSortTodo: Integer;
    FSortedEx: Boolean;
    FLookupIncr: Boolean;
    FLookupTodo: Integer;
    FLookup: string;
    FDateFormat: string;
    FColumnsChanged: TNotifyEvent;
    FPreview: Boolean;
    FPreviewFont: TFont;
    FCompletionFont: TFont;
    FProgressLook: TProgressLook;
    FShowSelection: Boolean;
    FPriorityFont: TFont;
    FEditable: Boolean;
    FEditSelectAll : Boolean;
    FSelectionColor: TColor;
    FSelectionFontColor: TColor;
    FFocusColumn: Integer;
    FOnSelectItem: TNotifyEvent;
    procedure EditorOnExit(Sender : TObject); { This procedure is executed
    when the in-place editors lose focus. The task of this procedure is to
    transfer the edited data from the editor to the TodoListBox, then to
    hide the editor. }
    procedure EditorParentOnDeactivate(Sender: TObject); { This procedure is
    executed when the EditorParent deactivates. This calls EditorOnExit, in
    order to deactivate the active in-place editor. }

    procedure SetImages(const Value: TImageList);
    procedure SetItemIndexEx(const Value : Integer);
    function GetItemIndexEx: Integer;
    procedure SetGridLines(const Value: Boolean);
    procedure SynchItems;
    procedure SynchColumns;
    {
    function GetTodoItems(i, j: Integer): String;
    procedure SetTodoItems(i, j: Integer; const Value: String);
    }
    function GetSortedEx: Boolean;
    procedure SetSortedEx(const Value: Boolean);
    procedure SetDateFormat(const Value: string);
    procedure SetPreview(const Value: Boolean);
    procedure SetCompletionFont(const Value: TFont);
    procedure SetPreviewFont(const Value: TFont);
    procedure SetProgressLook(const Value: TProgressLook);
    procedure ProgressLookChanged(Sender: TObject);
    procedure SetShowSelection(const Value: Boolean);
    procedure SetPriorityFont(const Value: TFont);
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure WMLButtonUp(var Message: TWMLButtonDown); message WM_LBUTTONUP;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;    
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMVScroll(var Message: TWMScroll); message WM_VSCROLL;
    procedure CMHintShow(var M: TCMHintShow); message CM_HINTSHOW;
    function XYToColItem(const X, Y: Integer; var ColIdx, ItemIdx: Integer; var R:TRect): Boolean;
    procedure ColItemRect(ColIdx, ItemIdx: Integer; var R:TRect);
    function ClickedOnNotes(const CalcItem: Boolean; const P: TPoint; out ItemIdx: Integer; out R: TRect): Boolean;
    procedure SetSelectionColor(const Value: TColor);
    procedure SetSelectionFontColor(const Value: TColor);
    procedure StartEdit(Index,Column: Integer; FromMouse: Boolean; Msg: TMessage; X,Y: Integer;ch:Char);
    procedure AdvanceEdit;
  protected
    procedure MeasureItem(Index: Integer; var Height: Integer); override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateWnd; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    property Items;
    procedure DoEnter; override;
    procedure SendClickMessage(Msg: TMessage; X,Y: Integer);
    procedure SetEditorFont(Editor : TWinControl; Font : TFont);
    procedure EditNotesInPreviewArea(Idx: Integer; R: TRect; Msg: TMessage; X,Y: Integer);
    procedure ShowEditor(Editor : TWinControl; R: TRect; UseSeparateParent : boolean);
    procedure RepaintItem(Index: Integer);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    property Text;
    procedure BeginUpdate;
    procedure EndUpdate;
  published
    property Align;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property Constraints;
    property DragKind;
    {$ENDIF}
    property BorderStyle;
    property Color;
    property CompletionFont: TFont read FCompletionFont write SetCompletionFont;
    property Cursor;
    property Ctl3D;
    property DateFormat: string read FDateFormat write SetDateFormat;
    property DragCursor;
    property DragMode;
    property Editable: Boolean read FEditable write FEditable;
    property EditSelectAll: Boolean read FEditSelectAll write FEditSelectAll; // If false, the caret will be put in the location the user clicked. If true, the whole subject text will be selected on user click.
    property Enabled;
    property Font;
    property GridLines: Boolean read FGridLines write SetGridLines;
    property Images: TImageList read FImages write SetImages;
    property IntegralHeight;
    property ItemHeight;
    property ItemIndex:Integer read GetItemIndexEx write SetItemIndexEx;
    property LookupIncr: Boolean read fLookupIncr write fLookupIncr;
    property LookupTodo: Integer read fLookupTodo write fLookupTodo;
    property MultiSelect;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Preview: Boolean read FPreview write SetPreview;
    property PreviewFont: TFont read FPreviewFont write SetPreviewFont;
    property PriorityFont: TFont read FPriorityFont write SetPriorityFont;
    property ProgressLook: TProgressLook read FProgressLook write SetProgressLook;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor;
    property SelectionFontColor: TColor read FSelectionFontColor write SetSelectionFontColor;
    property ShowHint;
    property ShowSelection: Boolean read FShowSelection write SetShowSelection;
    property SortTodo: Integer read FSortTodo write FSortTodo;
    property Sorted: Boolean read GetSortedEx write SetSortedEx;
    property TabOrder;
    property TabStop;
    property TodoColumns: TTodoColumnCollection read FTodoColumns write FTodoColumns;
    property TodoItems: TTodoItemCollection read FTodoItems write FTodoItems;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
    {$IFDEF DELPHI4_LVL}
    property OnStartDock;
    property OnEndDock;
    {$ENDIF}
    {$IFDEF DELPHI5_LVL}
    property OnContextPopup;
    {$ENDIF}
    property OnColumnsChanged: TNotifyEvent read FColumnsChanged write FColumnsChanged;
    property OnSelectItem: TNotifyEvent read FOnSelectItem write FOnSelectItem;
  end;

  TImagePosition = (ipLeft, ipRight);
  TVAlignment = (vtaCenter, vtaTop, vtaBottom);
  THeaderOrientation = (hoHorizontal, hoVertical);

  THeaderClickEvent = procedure(Sender: TObject; SectionIndex: Integer) of object;
  THeaderDragDropEvent = procedure(Sender: TObject; FromSection, ToSection: Integer) of object;

  TTodoHeader = class(THeader)
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
    FSortedSection: Integer;
    FSortDirection: TSortDirection;
    FSortShow: Boolean;
    FOwner: TCustomTodoList;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetColor(const Value: TColor);
    procedure SetImageList(const Value: TImageList);
    procedure SetImagePosition(const Value: TImagePosition);
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonDown(var Message: TWMLButtonDown); message WM_RBUTTONDOWN;
    procedure SetOrientation(const Value: THeaderOrientation);
    procedure SetFlat(const Value: Boolean);
    procedure SetLineColor(const Value: TColor);
    procedure SetVAlignment(const Value: TVAlignment);
    procedure InplaceExit(Sender: TObject);
    procedure SetItemHeight(const Value: Integer);
    procedure SetTextHeight(const Value: Integer);
    procedure SetSortDirection(const Value: TSortDirection);
    procedure SetSortedSection(const Value: Integer);
    procedure DrawSortIndicator(Canvas: TCanvas; X,Y: Integer);
    procedure OwnOnDragDrop(Sender: TObject; FromSection, ToSection: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    function XYToSection(X, Y: Integer): Integer;
    function GetSectionRect(X: Integer): TRect;
    procedure Paint; override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property Color: TColor read FColor write SetColor;
    property Flat: Boolean read FFlat write SetFlat;
    property Images: TImageList read FImageList write SetImageList;
    property ImagePosition: TImagePosition read FImagePosition write SetImagePosition;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property TextHeight: Integer read FTextHeight write SetTextHeight;
    property LineColor: TColor read FLineColor write SetLineColor;
    property SectionDragDrop: Boolean read FSectionDragDrop write FSectionDragDrop;
    property SectionEdit: Boolean read FSectionEdit write FSectionEdit;
    property SortedSection: Integer read FSortedSection write SetSortedSection;
    property SortDirection: TSortDirection read FSortDirection write SetSortDirection;
    property SortShow: Boolean read FSortShow write FSortShow;
    property VAlignment: TVAlignment read FVAlignment write SetVAlignment;
    property Orientation: THeaderOrientation read FOrientation write SetOrientation default hoHorizontal;
    property OnClick: THeaderClickEvent read FOnClick write FOnClick;
    property OnDragDrop: THeaderDragDropEvent read FOnDragDrop write FOnDragDrop;
    property OnRightClick: THeaderClickEvent read FOnRightClick write FOnRightClick;
    property OnSectionEditStart: THeaderClickEvent read FOnSectionEditStart write FOnSectionEditStart;
    property OnSectionEditEnd: THeaderClickEvent read FOnSectionEditEnd write FOnSectionEditEnd;
  end;

  TStatusToStringEvent = procedure(Sender: TObject; AValue: TTodoStatus; var AString: string) of object;
  TStringToStatusEvent = procedure(Sender: TObject; AString: string; var AValue: TTodoStatus) of object;
  TPriorityToStringEvent = procedure(Sender: TObject; AValue: TTodoPriority; var AString: string) of object;
  TStringToPriorityEvent = procedure(Sender: TObject; AString: string; var AValue: TTodoPriority) of object;

  TTodoItemEvent = procedure(Sender: TObject; ATodoItem: TTodoItem; var Allow: Boolean) of object;

  TTodoItemSelectEvent = procedure(Sender: TObject; ATodoItem: TTodoItem) of object;

  TListHeaderEvent = procedure(Sender: TObject; Column: Integer) of object;
  TOnHeaderDragDropEvent = procedure(Sender: TObject; FromCol, ToCol: Integer) of object;

{$IFDEF USE_PLANNERDATEPICKER}
  TCalendarType = (tcDefaultCalendar, tcPlannerCalendar);
{$ENDIF}

  TCustomTodoList = class(TCustomControl) { TCustomTodoList is made of a TTodoHeader and a TTodoListBox bellow it. }
  private
{$IFDEF USE_PLANNERDATEPICKER}
    FCalendarType: TCalendarType;
{$ENDIF}
    FTodoHeader: TTodoHeader;
    FTodoListBox: TTodoListBox;
    FBorderStyle: TBorderStyle;
    FOnMouseUp: TMouseEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnKeyDown: TKeyEvent;
    FOnKeyUp: TKeyEvent;
    FOnKeyPress: TKeyPressEvent;
    FOnPriorityToString: TPriorityToStringEvent;
    FOnStatusToString: TStatusToStringEvent;
    FOnStringToPriority: TStringToPriorityEvent;
    FOnStringToStatus: TStringToStatusEvent;
    FPreviewHeight: Integer;
    FItemHeight: Integer;
    FStatusStrings: TStatusStrings;
    FPriorityStrings: TPriorityStrings;
    FEditColors: TEditColors;
    FCompleteCheck: TCompleteCheck;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnDragDrop: TDragDropEvent;
    FOnEndDrag: TEndDragEvent;
    FOnDragOver: TDragOverEvent;
    FOnStartDrag: TStartDragEvent;
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
    FSorted: Boolean;
    FSortColumn: Integer;
    FSortDirection: TSortDirection;
    FNewIdx: Integer;
    FOnHeaderRightClick: TListHeaderEvent;
    FOnHeaderClick: TListHeaderEvent;
    FAutoInsertItem: Boolean;
    FAutoDeleteItem: Boolean;
    FOnItemInsert: TTodoItemEvent;
    FOnItemDelete: TTodoItemEvent;
    FOnEditStart: TNotifyEvent;
    FOnEditDone: TNotifyEvent;
    FOnItemSelect: TTodoItemSelectEvent;
    FCompletionGraphic: Boolean;
    FHintShowFullText: Boolean;
    FHeaderDragDrop: Boolean;
    FOnHeaderDragDrop: TOnHeaderDragDropEvent;
    FAutoAdvanceEdit: Boolean;
    FStatusListWidth: Integer;
    FPriorityListWidth: Integer;
    FNullDate: string;
    procedure NCPaintProc;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;

    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    function GetFont: TFont;
    procedure SetFont(const Value: TFont);
    function GetTodoItems: TTodoItemCollection;
    procedure SetTodoItems(const Value: TTodoItemCollection);
    procedure SetBorderStyle(const Value: TBorderStyle);
    function GetTodoColumns: TTodoColumnCollection;
    procedure SetTodoColumns(const Value: TTodoColumnCollection);
    procedure SectionSized(Sender: TObject; SectionIdx, SectionWidth: Integer);
    function GetDateFormat: string;
    procedure SetDateFormat(const Value: string);
    procedure SetImages(const Value: TImageList);
    function GetImages: TImageList;
    function GetGridLines: Boolean;
    procedure SetGridLines(const Value: Boolean);
    function GetItemHeight: Integer;
    procedure SetItemHeight(const Value: Integer);
    function GetPreview: Boolean;
    procedure SetPreview(const Value: Boolean);
    function GetCompletionFont: TFont;
    function GetPreviewFont: TFont;
    procedure SetCompletionFont(const Value: TFont);
    procedure SetPreviewFont(const Value: TFont);
    function GetProgressLook: TProgressLook;
    procedure SetProgressLook(const Value: TProgressLook);
    {
    function XYToColItem(const X,Y: Integer; var ColIdx,ItemIdx: Integer; var R:TRect): Boolean;
    }
    function GetPriorityFont: TFont;
    procedure SetPriorityFont(const Value: TFont);
    procedure SetEditable(const Value: boolean);
    function GetEditable: boolean;
    function GetSelectAllInSubjectEdit: Boolean;
    procedure SetSelectAllInSubjectEdit(const Value: Boolean);
    function GetShowSelection: Boolean;
    procedure SetShowSelection(const Value: Boolean);
    procedure SetPreviewHeight(const Value: Integer);
    function GetSelectionColor: TColor;
    function GetSelectionFontColor: TColor;
    procedure SetSelectionColor(const Value: TColor);
    procedure SetSelectionFontColor(const Value: TColor);
    procedure SetCompleteCheck(const Value: TCompleteCheck);
    function GetDragCursor: TCursor;
    function GetDragKind: TDragKind;
    function GetDragMode: TDragMode;
    procedure SetDragCursor(const Value: TCursor);
    procedure SetDragKind(const Value: TDragKind);
    procedure SetDragModeEx(const Value: TDragMode);
    procedure SetSortColumn(const Value: Integer);
    procedure SetSortDirection(const Value: TSortDirection);
    procedure SetSorted(const Value: Boolean);
    function GetSelected: TTodoItem;
    function GetHeaderFont: TFont;
    procedure SetHeaderFont(const Value: TFont);
    function GetEditColumn: Integer;
    procedure SetEditColumn(const Value: Integer);
    function GetTabStopEx: Boolean;
    procedure SetTabStopEx(const Value: Boolean);
    function GetTabOrderEx: Integer;
    procedure SetTabOrderEx(const Value: Integer);
    procedure SetCompletionGraphic(const Value: Boolean);
    procedure SetHeaderDragDrop(const Value: Boolean);
    procedure SetHintShowFullText(const Value: Boolean);
    procedure SetNullDate(const Value: string);
    function GetEditItem: TTodoItem;
  protected
    procedure CreateParams(var Params: TCreateParams); override;

    { The procedures bellow (ListXXX) are event handlers for the member
    TTodoListBox object. Their only purpose is to call the TCustomTodoList event
    handlers. }
    procedure ListMouseMove(Sender:TObject; Shift: TShiftState; X, Y: Integer);
    procedure ListMouseDown(Sender:TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure ListMouseUp(Sender:TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);

    procedure ListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListKeyPress(Sender: TObject; var Key: Char);
    procedure ListClick(Sender: TObject);
    procedure ListDblClick(Sender: TObject);
    procedure ListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ListStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ListEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ListEnter(Sender: TObject);
    procedure ListExit(Sender: TObject);
    procedure ListSelect(Sender: TObject);

    procedure HeaderClick(Sender: TObject; Section: Integer);
    procedure HeaderRightClick(Sender: TObject; Section: Integer);

    procedure CheckChanged(Sender: TObject);
    function CompareItems(A,B: Integer): Integer;
    procedure SwapItems(A,B: Integer);
    procedure QuickSortItems(Left,Right:Integer);
    function AllowAutoDelete(ATodoItem: TTodoItem): Boolean; virtual;
    function AllowAutoInsert(ATodoItem: TTodoItem): Boolean; virtual;
    procedure ItemSelect(ATodoItem: TTodoItem); virtual;
    procedure EditDone(Data: TTodoData; EditItem: TTodoItem); virtual;
    procedure EditStart; virtual;
    property TodoListBox: TTodoListBox read FTodoListBox;
    procedure ColumnsChanged(Sender: TObject);
    function FormatDateTimeEx(Format:string; dt:TDateTime): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    function StatusToString(AValue: TTodoStatus): string; virtual;
    function StringToStatus(AValue: string): TTodoStatus; virtual;
    function PriorityToString(AValue: TTodoPriority): string; virtual;
    function StringToPriority(AValue: string): TTodoPriority; virtual;
    function StatusCommaText: string; virtual;
    function PriorityCommaText: string; virtual;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);
    procedure SaveToFile(FileName: String);
    procedure LoadFromFile(FileName: String);
    procedure SaveColumns(FileName: String);
    procedure LoadColumns(FileName: String);
    procedure Sort;
    procedure HideEditor;
    procedure ShowEditor(Index,Column: Integer);
    property List: TTodoListBox read FTodoListBox;
    property Selected: TTodoItem read GetSelected;
    property EditColumn: Integer read GetEditColumn write SetEditColumn;
    property EditItem: TTodoItem read GetEditItem;
    procedure AddColumn(Data: TTodoData; ACaption: string);
    procedure RemoveColumn(Data: TTodoData);
    property Align;
    property AutoAdvanceEdit: Boolean read FAutoAdvanceEdit write FAutoAdvanceEdit;
    property AutoInsertItem: Boolean read FAutoInsertItem write FAutoInsertItem;
    property AutoDeleteItem: Boolean read FAutoDeleteItem write FAutoDeleteItem;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
{$IFDEF USE_PLANNERDATEPICKER}
    property CalendarType: TCalendarType read FCalendarType write FCalendarType default tcPlannerCalendar;
{$ENDIF}
    property Color: TColor read GetColor write SetColor;
    property Columns: TTodoColumnCollection read GetTodoColumns write SetTodoColumns;
    property CompleteCheck: TCompleteCheck read FCompleteCheck write SetCompleteCheck;
    property CompletionFont: TFont read GetCompletionFont write SetCompletionFont;
    property CompletionGraphic: Boolean read FCompletionGraphic write SetCompletionGraphic default True;
    property Cursor;
    property DateFormat: string read GetDateFormat write SetDateFormat;
    property DragCursor: TCursor read GetDragCursor write SetDragCursor;
    property DragMode: TDragMode read GetDragMode write SetDragModeEx;
    property DragKind: TDragKind read GetDragKind write SetDragKind;
    property Editable: boolean read GetEditable write SetEditable;
    property EditColors: TEditColors read FEditColors write FEditColors;
    property EditSelectAll: Boolean read GetSelectAllInSubjectEdit
      write SetSelectAllInSubjectEdit; // If false, the caret will be put in the location the user clicked. If true, the whole subject text will be selected on user click.
    property Font: TFont read GetFont write SetFont;
    property GridLines: Boolean read GetGridLines write SetGridLines;
    property HeaderDragDrop: Boolean read FHeaderDragDrop write SetHeaderDragDrop default False;
    property HeaderFont: TFont read GetHeaderFont write SetHeaderFont;
    property HintShowFullText: Boolean read FHintShowFullText write SetHintShowFullText default False;
    property Images: TImageList read GetImages write SetImages;
    property Items: TTodoItemCollection read GetTodoItems write SetTodoItems;
    property ItemHeight: Integer read GetItemHeight write SetItemHeight;
    property NullDate: string read FNullDate write SetNullDate;
    property Preview: Boolean read GetPreview write SetPreview;
    property PreviewFont: TFont read GetPreviewFont write SetPreviewFont;
    property PreviewHeight: Integer read FPreviewHeight write SetPreviewHeight;
    property PriorityFont: TFont read GetPriorityFont write SetPriorityFont;
    property PriorityStrings: TPriorityStrings read FPriorityStrings write FPriorityStrings;
    property PriorityListWidth: Integer read FPriorityListWidth write FPriorityListWidth;
    property ProgressLook: TProgressLook read GetProgressLook write SetProgressLook;
    property SelectionColor: TColor read GetSelectionColor write SetSelectionColor;
    property SelectionFontColor: TColor read GetSelectionFontColor write SetSelectionFontColor;
    property ShowSelection: Boolean read GetShowSelection write SetShowSelection;
    property Sorted: Boolean read FSorted write SetSorted;
    property SortDirection: TSortDirection read FSortDirection write SetSortDirection;
    property SortColumn: Integer read FSortColumn write SetSortColumn;
    property StatusStrings: TStatusStrings read FStatusStrings write FStatusStrings;
    property StatusListWidth: Integer read FStatusListWidth write FStatusListWidth;
    property TabStop: Boolean read GetTabStopEx write SetTabStopEx;
    property TabOrder: Integer read GetTabOrderEx write SetTabOrderEx;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnDragDrop: TDragDropEvent read FOnDragDrop write FOnDragDrop;
    property OnDragOver: TDragOverEvent read FOnDragOver write FOnDragOver;
    property OnEditDone: TNotifyEvent read FOnEditDone write FOnEditDone;
    property OnEditStart: TNotifyEvent read FOnEditStart write FOnEditStart;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnHeaderClick: TListHeaderEvent read FOnHeaderClick write FOnHeaderClick;
    property OnHeaderDragDrop: TOnHeaderDragDropEvent read FOnHeaderDragDrop write FOnHeaderDragDrop;
    property OnHeaderRightClick: TListHeaderEvent read FOnHeaderRightClick write FOnHeaderRightClick;
    property OnItemDelete: TTodoItemEvent read FOnItemDelete write FOnItemDelete;
    property OnItemInsert: TTodoItemEvent read FOnItemInsert write FOnItemInsert;
    property OnItemSelect: TTodoItemSelectEvent read FOnItemSelect write FOnItemSelect;
    property OnStartDrag: TStartDragEvent read FOnStartDrag write FOnStartDrag;
    property OnEndDrag: TEndDragEvent read FOnEndDrag write FOnEndDrag;
    property OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyUp: TKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnStatusToString: TStatusToStringEvent read FOnStatusToString
      write FOnStatusToString;
    property OnStringToStatus: TStringToStatusEvent read FOnStringToStatus
      write FOnStringToStatus;
    property OnPriorityToString: TPriorityToStringEvent read FOnPriorityToString
      write FOnPriorityToString;
    property OnStringToPriority: TStringToPriorityEvent read FOnStringToPriority
      write FOnStringToPriority;
  end;


  TTodoList = class(TCustomTodoList)
  published
    property Align;
    property AutoAdvanceEdit;
    property AutoInsertItem;
    property AutoDeleteItem;
    property BorderStyle;
{$IFDEF USE_PLANNERDATEPICKER}
    property CalendarType;
{$ENDIF}
    property Color;
    property Columns;
    property CompleteCheck;
    property CompletionFont;
    property CompletionGraphic;
    property Cursor;
    property DateFormat;
    property DragCursor;
    property DragMode;
    property DragKind;
    property Editable;
    property EditColors;
    property EditSelectAll;
    property Font;
    property GridLines;
    property HeaderDragDrop;
    property HeaderFont;
    property HintShowFullText;
    property Images;
    property ItemHeight;
    property Items;
    property NullDate;
    property Preview;
    property PreviewFont;
    property PreviewHeight;
    property PriorityFont;
    property PriorityStrings;
    property PriorityListWidth;
    property ProgressLook;
    property SelectionColor;
    property SelectionFontColor;
    property ShowSelection;
    property Sorted;
    property SortDirection;
    property SortColumn;
    property StatusStrings;
    property StatusListWidth;
    property TabOrder;
    property TabStop;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditDone;
    property OnEditStart;
    property OnEnter;
    property OnExit;
    property OnHeaderClick;
    property OnHeaderDragDrop;
    property OnHeaderRightClick;
    property OnItemDelete;
    property OnItemInsert;
    property OnItemSelect;
    property OnStartDrag;
    property OnEndDrag;
    property OnKeyDown;
    property OnKeyUp;
    property OnKeyPress;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnStatusToString;
    property OnStringToStatus;
    property OnPriorityToString;
    property OnStringToPriority;
  end;

function ReadInteger(S: TStream): Integer;
function ReadWord(S: TStream): Word;
function ReadString(S: TStream; Size: Integer): String;
function ReadDateTime(S: TStream): TDateTime;
function ReadByte(S: TStream): Byte;
function ReadBoolean(S: TStream): Boolean;
procedure WriteInteger(S: TStream; Value: Integer);
procedure SaveProperty(S: TStream; ID: Byte; Buffer: Pointer; Size: Word);

implementation
uses
 ShellApi,CommCtrl, Dialogs {$IFDEF DELPHI4_LVL} ,ImgList {$ENDIF};

procedure SaveProperty(S: TStream; ID: Byte; Buffer: Pointer; Size: Word);
begin
  S.Write(ID, 1);
  S.Write(Size, 2);
  S.Write(Buffer^, Size);
end;

procedure WriteInteger(S: TStream; Value: Integer);
begin
  S.Write(Value, 4);
end;

function ReadBoolean(S: TStream): Boolean;
begin
  S.Read(Result, 1);
end;

function ReadByte(S: TStream): Byte;
begin
  S.Read(Result, 1);
end;

function ReadDateTime(S: TStream): TDateTime;
begin
  S.Read(Result, 8);
end;

function ReadString(S: TStream; Size: Integer): String;
begin
  SetLength(Result, Size);
  S.Read(Result[1], Size);
end;


function ReadWord(S: TStream): Word;
begin
  S.Read(Result, 2);
end;

function ReadInteger(S: TStream): Integer;
begin
  S.Read(Result, 4);
end;

{ Calculates the border withs of a WinControl. }
procedure WinControlBorderWidths(WinControl: TWinControl;
  out LeftBorderWidth, RightBorderWidth, TopBorderWidth, BottomBorderWidth: integer);
var
  WindowRect: TRect;
  ClientOrigin: TPoint;
begin
  // Put window rect, client origin into local variables
  GetWindowRect(WinControl.Handle, WindowRect);
  ClientOrigin := WinControl.ClientOrigin;

  LeftBorderWidth := ClientOrigin.X - WindowRect.Left;
  TopBorderWidth := ClientOrigin.Y - WindowRect.Top;

  RightBorderWidth := WindowRect.Right - (ClientOrigin.X + WinControl.ClientWidth);
  BottomBorderWidth := WindowRect.Bottom - (ClientOrigin.Y + WinControl.ClientHeight);
end;


function AlignToFlag(alignment:TAlignment):dword;
begin
  case Alignment of
  taLeftJustify:Result := DT_LEFT;
  taRightJustify:Result := DT_RIGHT;
  taCenter:Result := DT_CENTER;
  else Result := DT_LEFT;
  end;
end;

procedure TTodoListBox.CNCommand(var Message: TWMCommand);
begin
  inherited;
  if Message.NotifyCode = LBN_SELCHANGE then
  begin
    if Assigned(FOnSelectItem) then
      FOnSelectItem(Self);
  end;
end;

function TTodoListBox.XYToColItem(const X, Y: Integer; var ColIdx,
  ItemIdx: Integer; var R:TRect): Boolean;
begin
  ItemIdx := SendMessage(Handle,LB_ITEMFROMPOINT,0,MakeLong(X,Y));

  Result := ItemIdx >= 0;

  if Result then
  begin
    SendMessage(Handle,LB_GETITEMRECT,ItemIdx,Longint(@R));

    R.Bottom := R.Top + FOwner.ItemHeight - 1;

    Result := False;
    ColIdx := 0;

    while ColIdx < TodoColumns.Count do
    begin
      R.Right := R.Left + TodoColumns.Items[ColIdx].Width;

      if (X >= R.Left) and (X < R.Right) and (Y <= R.Bottom) then
      begin
        Result := True;
        Break;
      end
      else
        R.Left := R.Right;

      Inc(ColIdx);
    end;
  end;
end;

procedure TTodoListBox.ColItemRect(ColIdx, ItemIdx: Integer; var R:TRect);
var
  j: Integer;
begin
  SendMessage(Handle,LB_GETITEMRECT,ItemIdx,Longint(@R));

  R.Bottom := R.Top + FOwner.ItemHeight - 1;

  j := 0;

  while (j < TodoColumns.Count) do
  begin
    R.Right := R.Left + TodoColumns.Items[j].Width;

    if (j = ColIdx) then
      Break
    else
      R.Left := R.Right;

    Inc(j);
  end;
end;


procedure TTodoListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  r, pr: TRect;
  su: string;
  Align: DWORD;
  col: Integer;
  IHeight: Integer;
  IIndent: Integer;
  
  procedure DrawCheck(R:TRect;State: Boolean; Alignment: TAlignment);
  var
    DrawState: Integer;
    DrawRect: TRect;
    Bmp: TBitmap;
  begin
    if State then
      DrawState := DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT
    else
      DrawState := DFCS_BUTTONCHECK or DFCS_FLAT;

    case Alignment of
    taLeftJustify:
      begin
        DrawRect.Left := R.Left + 1;
        DrawRect.Top := R.Top + 1;
        DrawRect.Right := DrawRect.Left + CHECKBOXSIZE;
        DrawRect.Bottom := DrawRect.Top + CHECKBOXSIZE;
      end;
    taCenter:
      begin
        DrawRect.Left := R.Left + ((R.Right - R.Left - CHECKBOXSIZE) shr 1) + 1;
        DrawRect.Top := R.Top + 1;
        DrawRect.Right := DrawRect.Left + CHECKBOXSIZE;
        DrawRect.Bottom := DrawRect.Top + CHECKBOXSIZE;
      end;
    taRightJustify:
      begin
        DrawRect.Left := R.Right - CHECKBOXSIZE - 1;
        DrawRect.Top := R.Top + 1;
        DrawRect.Right := DrawRect.Left + CHECKBOXSIZE;
        DrawRect.Bottom := DrawRect.Top + CHECKBOXSIZE;
      end;
    end;

    case FOwner.CompleteCheck.CheckType of
    ctCheckBox: DrawFrameControl(Canvas.Handle,DrawRect,DFC_BUTTON,DrawState);
    ctCheckMark:
      begin
        Bmp := TBitmap.Create;
        if State then
          Bmp.LoadFromResourceName(hinstance,'TMSTODO02')
        else
          Bmp.LoadFromResourceName(hinstance,'TMSTODO03');

        Bmp.TransparentMode := tmAuto;
        Bmp.Transparent := True;

        Canvas.Draw(DrawRect.Left,DrawRect.Top,Bmp);

        Bmp.Free;
      end;
    ctGlyph:
      begin
        if State and not FOwner.FCompleteCheck.FCompletedGlyph.Empty then
          Canvas.Draw(DrawRect.Left,DrawRect.Top,FOwner.FCompleteCheck.FCompletedGlyph);

        if not State and not FOwner.FCompleteCheck.FUnCompletedGlyph.Empty then
          Canvas.Draw(DrawRect.Left,DrawRect.Top,FOwner.FCompleteCheck.FUnCompletedGlyph);
      end;
    end;
  end;

  procedure DrawHandle(R:TRect;Alignment:TAlignment);
  var
    Bmp: TBitmap;
    DrawRect: TRect;
  begin
    case Alignment of
    taLeftJustify:
      begin
        DrawRect.Left := R.Left + 1;
        DrawRect.Top := R.Top + 1;
        DrawRect.Right := DrawRect.Left + CHECKBOXSIZE;
        DrawRect.Bottom := DrawRect.Top + CHECKBOXSIZE;
      end;
    taCenter:
      begin
        DrawRect.Left := R.Left + ((R.Right - R.Left - CHECKBOXSIZE) shr 1) + 1;
        DrawRect.Top := R.Top + 1;
        DrawRect.Right := DrawRect.Left + CHECKBOXSIZE;
        DrawRect.Bottom := DrawRect.Top + CHECKBOXSIZE;
      end;
    taRightJustify:
      begin
        DrawRect.Left := R.Right - CHECKBOXSIZE - 1;
        DrawRect.Top := R.Top + 1;
        DrawRect.Right := DrawRect.Left + CHECKBOXSIZE;
        DrawRect.Bottom := DrawRect.Top + CHECKBOXSIZE;
      end;
    end;
    Bmp := TBitmap.Create;
    Bmp.LoadFromResourceName(hinstance,'TMSTODO02');
    Bmp.TransparentMode := tmAuto;
    Bmp.Transparent := True;
    Canvas.Draw(DrawRect.Left,DrawRect.Top,Bmp);
    Bmp.Free;
  end;

  procedure DrawCompletion(R:TRect;Completion: Integer);
  var
    SrcColor: TColor;
    SrcRect, TgtRect: TRect;
    W,H: Integer;
    Txt: string;
    FS: TFontStyles;

  begin
    SrcColor := Canvas.Brush.Color;
    Canvas.Brush.Color := Color;
    Canvas.Brush.Color := FProgressLook.CompleteColor;
    Canvas.Pen.Color := FProgressLook.CompleteColor;
    Canvas.Font.Color := FProgressLook.CompleteFontColor;
    FS := Canvas.Font.Style;
    Canvas.Font.Style := [];
    InflateRect(R,-2,-2);
    SrcRect := R;
    W := R.Right - R.Left;
    H := R.Bottom - R.Top;
    Txt := IntToStr(Completion)+'%';
    SrcRect.Right := SrcRect.Left + Round( W * Completion / 100);
    TgtRect.Left := R.Left + ((W - Canvas.Textwidth(Txt)) shr 1);
    TgtRect.Top := R.Top + ((H - Canvas.Textheight(Txt)) shr 1);
    Canvas.TextRect(SrcRect,TgtRect.Left,TgtRect.Top,Txt);

    Canvas.Brush.Color := FProgressLook.UnCompleteColor;
    Canvas.Pen.Color := FProgressLook.UnCompleteColor;
    Canvas.Font.Color := FProgressLook.UnCompleteFontColor;

    SrcRect.Left := SrcRect.Right;
    SrcRect.Right := R.Right;
    Canvas.TexTRect(SrcRect,TgtRect.Left,TgtRect.Top,Txt);

    Canvas.Brush.Color := SrcColor;
    Canvas.Pen.Color := SrcColor;
    Inflaterect(R,1,1);
    Canvas.FrameRect(R);
    Inflaterect(R,1,1);
    Canvas.FrameRect(R);
    Canvas.Font.Style := FS;
  end;

begin
  if (Index < 0) or (Index >= TodoItems.Count) then
    Exit;

  r := Rect;

  if Index = TodoItems.Count - 1 then
  begin
    r.Bottom := Height;
    Canvas.Pen.Color := Color;
    Canvas.Brush.Color := Color;
    Canvas.Rectangle(r.Left,r.Top,r.Right,r.Bottom);
  end;

  r := Rect;
  // Rect is the rectangle covering the entire row.

  IHeight := FOwner.ItemHeight;
  
  SetBkMode(Canvas.Handle, TRANSPARENT);

  for Col := 1 to TodoColumns.Count do
  begin
    r.Right := r.Left + TodoColumns.Items[Col - 1].Width;

    { At the end of this for loop there is an r.Left := r.Right }

    if TodoItems.Items[Index].Complete then
      Canvas.Font.Assign(FCompletionFont)
    else
    begin
      if TodoItems.Items[Index].Priority in [tpHighest,tpHigh] then
        Canvas.Font.Assign(FPriorityFont)
      else
        Canvas.Font.Assign(TodoColumns.Items[Col-1].Font);
    end;

    if (odSelected in State) and FShowSelection then
    begin
      Canvas.Brush.Color := FSelectionColor;
      Canvas.Font.Color := FSelectionFontColor;
    end
    else
    begin
      Canvas.Brush.Color := TodoColumns.Items[Col - 1].Color;
    end;

    if ((FFocusColumn = Col - 1) and (GetFocus = Handle)) and
       (odSelected in State) and FOwner.Editable then
    begin
      Canvas.Brush.Color := Color;
      Canvas.Font.Color := Font.Color;
    end;

    case TodoColumns.Items[Col - 1].Alignment of
    taLeftJustify: Align := DT_LEFT;
    taCenter: Align := DT_CENTER;
    taRightJustify: Align := DT_RIGHT;
    else
      Align := DT_LEFT;
    end;

    Canvas.Pen.Color := Canvas.Brush.Color;

    if Col = TodoColumns.Count then
      Canvas.Rectangle(r.Left,Rect.Top,Rect.Right,Rect.Top + FOwner.FItemHeight)
    else
      Canvas.Rectangle(r.Left,Rect.Top,r.Right,Rect.Top + FOwner.FItemHeight);

    if FGridLines then OffsetRect(r,1,1);

    r.Bottom := r.Top + IHeight;

    case TodoColumns.Items[Col - 1].TodoData of
    tdSubject:
    begin
      su := TodoItems.Items[Index].Subject;
      DrawTextEx(Canvas.Handle,Pchar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
    end;
    tdResource:
    begin
      su := TodoItems.Items[Index].Resource;
      DrawTextEx(Canvas.Handle,Pchar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
    end;
    tdNotes:
    begin
      su := TodoItems.Items[Index].NotesLine;
      DrawTextEx(Canvas.Handle,PChar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
    end;
    tdDueDate:
    begin
      su := FOwner.FormatDateTimeEx(FDateFormat,TodoItems.Items[Index].DueDate);
      DrawTextEx(Canvas.Handle,PChar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
    end;
    tdCreationDate:
    begin
      su := FOwner.FormatDateTimeEx(FDateFormat,TodoItems.Items[Index].CreationDate);
      DrawTextEx(Canvas.handle,PChar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
    end;
    tdCompletionDate:
    begin
      su := FOwner.FormatDateTimeEx(FDateFormat,TodoItems.Items[Index].CompletionDate);
      DrawTextEx(Canvas.handle,PChar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
    end;
    tdTotalTime:
    begin
      su := IntToStr(TodoItems.Items[Index].TotalTime) + 'h';
      DrawTextEx(Canvas.handle,PChar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
    end;
    tdStatus:
    begin
      su := FOwner.StatusToString(TodoItems.Items[Index].Status);
      DrawTextEx(Canvas.Handle,PChar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
    end;
    tdProject:
    begin
      su := TodoItems.Items[Index].Project;
      DrawTextEx(Canvas.Handle,Pchar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
    end;
    tdImage:
    begin
      if Assigned(FImages) and (TodoItems.Items[Index].ImageIndex >= 0) then
      begin
        FImages.Draw(Canvas,r.Left,r.Top,TodoItems.Items[Index].ImageIndex);
      end;
    end;
    tdComplete:
    begin
      DrawCheck(r,TodoItems.Items[Index].Complete,TodoColumns.Items[Col - 1].Alignment);
    end;

    tdHandle:
    begin
      DrawHandle(r,TodoColumns.Items[Col - 1].Alignment);
    end;

    tdCompletion:
    begin
      if FOwner.CompletionGraphic then
      begin
        if TodoItems.Items[Index].Complete then
          DrawCompletion(r,100)
        else
          DrawCompletion(r,TodoItems.Items[Index].Completion)
      end else
      begin
        if TodoItems.Items[Index].Complete
          then su := '100%'
          else su := IntToStr(TodoItems.Items[Index].Completion) + '%';
        DrawTextEx(Canvas.Handle,Pchar(su),Length(su),r,Align or DT_END_ELLIPSIS or DT_SINGLELINE,nil);
      end;
    end;

    tdPriority:
    begin
      IIndent := 0;
      case Align of
      DT_CENTER: IIndent := Max(0,r.Right - r.Left - FPriorityImageList.Width) div 2;
      DT_LEFT: IIndent := 0;
      DT_RIGHT: IIndent := Max(0,r.Right - r.Left - FPriorityImageList.Width);
      end;

      case TodoItems.Items[Index].Priority of
      tpLowest: FPriorityImageList.Draw(Canvas,r.Left + IIndent,r.Top,4,True);
      tpLow: FPriorityImageList.Draw(Canvas,r.Left + IIndent,r.Top,3,True);
      tpNormal: FPriorityImageList.Draw(Canvas,r.Left + IIndent,r.Top,2,True);
      tpHigh: FPriorityImageList.Draw(Canvas,r.Left + IIndent,r.Top,1,True);
      tpHighest: FPriorityImageList.Draw(Canvas,r.Left + IIndent,r.Top,0,True);
      end;
    end;

    end;

    if (FFocusColumn = Col - 1) and (GetFocus = Handle) and (ItemIndex = Index) then
    begin
      // DrawFocusRect(Canvas.Handle,R);
    end;

    if FGridLines then OffsetRect(r,-1,-1);

    r.Left := r.Right;
  end;

  if FPreview then
  begin
    SetBkMode(Canvas.Handle, TRANSPARENT);
    Canvas.Font.Assign(FPreviewFont);

    su := TodoItems.Items[Index].Notes.Text;
    pr := Rect;
    pr.Top := Rect.Top + IHeight;
    Canvas.Rectangle(pr.Left,pr.Top,pr.Right,pr.Bottom);
    pr.Top := pr.Top + 1;
    DrawTextEx(Canvas.Handle,Pchar(su),length(su),pr,DT_TOP or DT_WORDBREAK,nil);
  end;

  if (odSelected in State) and FShowSelection then
  begin
     Canvas.Brush.Color := FSelectionColor;
  end
  else
  begin
     Canvas.Brush.Color := Color;
  end;

  r.Right := Rect.Right;

  Canvas.Pen.Color := Canvas.Brush.Color;
  Canvas.Rectangle(r.Left,r.Top,r.Right,r.Bottom);

  if FGridLines then
  begin
    Canvas.Pen.Color:=clGray;
    Canvas.Moveto(Rect.Left,Rect.Bottom-1);
    Canvas.lineto(Rect.Right,Rect.Bottom-1);

    r.Left := Rect.Left;
    if not Preview then
    begin
      for Col:=1 to FTodoColumns.Count-1 do
      begin
        r.Left := r.Left + FTodoColumns.Items[Col-1].Width;
        Canvas.MoveTo(r.Left,Rect.Top);
        Canvas.LineTo(r.Left,Rect.Bottom);
      end;
    end;
  end;

  Canvas.Font.Color := clBlack;
  Canvas.Pen.Color := clBlack;
  Canvas.TextOut(0,0,'');
end;


procedure TTodoListBox.CreateWnd;
begin
  inherited CreateWnd;
end;

procedure TTodoListBox.EditorParentOnDeactivate(Sender: TObject);
begin
  EditorOnExit(ActiveEditor);
end;

constructor TTodoListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // FOwner := AOwner as TCustomTodoList; // Yields 'invalid class typecast' when component put on a form
  FOwner := AOwner as TCustomTodoList;

  Style := lbOwnerDrawFixed;
  FTodoColumns := TTodoColumnCollection.Create(self);
  FTodoItems := TTodoItemCollection.Create(self);
  FUpdateCount := 0;
  FDateFormat := ShortDateFormat;
  DoubleBuffered := True;

  FCompletionFont := TFont.Create;
  FCompletionFont.Style := FCompletionFont.Style + [fsStrikeOut];
  FCompletionFont.Color := clGray;

  FPriorityFont := TFont.Create;
  FPriorityFont.Color := clRed;
  FPriorityFont.OnChange := ProgressLookChanged;

  FPreviewFont := TFont.Create;
  FPreviewFont.Color := clBlue;
  FPreviewFont.OnChange := ProgressLookChanged;

  FProgressLook := TProgressLook.Create;
  FProgressLook.OnChange := ProgressLookChanged;

  FShowSelection := True;

  FEditable := True; // TODO: default to false
  FEditSelectAll := False;

  // Create the components used as in-place editors
  ActiveEditor := nil;

  EditorParent := TForm.Create(self);
  EditorParent.Visible := False;
//  EditorParent.Parent := Self;
  EditorParent.BorderStyle := bsNone;
  EditorParent.OnDeactivate := EditorParentOnDeactivate;

  StringEditor := TInplaceEdit.Create(Self);
  StringEditor.Visible := False;
  StringEditor.BorderStyle := bsNone;

  IntegerEditor := TInplaceSpinEdit.Create(Self);
  IntegerEditor.Visible := False;
  StringListEditor := TInplaceMemo.Create(self);
  StringListEditor.Visible := False;
  StringListEditor.Ctl3D := False;

{$IFDEF USE_PLANNERDATEPICKER}
  PlannerDateEditor := TPlannerDatePicker.Create(Self);
  PlannerDateEditor.EditorEnabled := False;
  PlannerDateEditor.Visible := False;
{$ENDIF}

  DefaultDateEditor := TTodoDateTimePicker.Create(Self);
  DefaultDateEditor.Visible := False;
  if Assigned(FOwner) then  DefaultDateEditor.Parent := FOwner;

  PriorityEditor := TInplaceODListBox.Create(Self);
  PriorityEditor.Visible := False;
  PriorityEditor.Ctl3D := False;

  StatusEditor := TInplaceListBox.Create(Self);
  StatusEditor.Visible := False;
  StatusEditor.Ctl3D := False;

  // Assign the in-place editors OnExit event
  StringEditor.OnExit := EditorOnExit;
  IntegerEditor.OnExit := EditorOnExit;
  StringListEditor.OnExit := EditorOnExit;
{$IFDEF USE_PLANNERDATEPICKER}
  PlannerDateEditor.OnExit := EditorOnExit;
{$ENDIF}
  DefaultDateEditor.OnExit := EditorOnExit;
  PriorityEditor.OnExit := EditorOnExit;
  PriorityEditor.OnSelected := EditorOnExit;
  StatusEditor.OnExit := EditorOnExit;
  StatusEditor.OnSelected := EditorOnExit;

  FPriorityImageList := TImageList.Create(Self);
//  FPriorityImageList.GetResource(rtBitmap,'TMSTODO01',12,[],RGB(255,255,255));
  FPriorityImageList.GetInstRes(HInstance,rtBitmap,'TMSTODO01',12,[],RGB(255,255,255)); 



  FSelectionColor := clHighLight;
  FSelectionFontColor := clHighLightText;
end;


destructor TTodoListBox.Destroy;
begin
  FCompletionFont.Free;
  FPreviewFont.Free;
  FPriorityFont.Free;
  FTodoColumns.Free;
  FTodoItems.Free;
  FProgressLook.Free;
  FPriorityImageList.Free;
  inherited Destroy;
end;

procedure TTodoListBox.MeasureItem(Index: Integer; var Height: Integer);
var
  Res: Integer;
  Canvas: TCanvas;
begin
  Height := 40;
  if (Index >= 0) then
  begin
    Canvas := TCanvas.Create;
    Canvas.Handle := GetDC(Handle);
    Res := Canvas.TextHeight('gh')+4; {some overlap on fonts}
    ReleaseDC(Handle,Canvas.Handle);
    Canvas.Free;
    SendMessage(Handle,CB_SETITEMHEIGHT,Index,Res);
  end
  else
    Res := 20;
    
  Height := Res;
end;

procedure TTodoListBox.SetImages(const Value: TImageList);
begin
  FImages := Value;
  Invalidate;
end;

function TTodoListBox.GetItemIndexEx: Integer;
begin
  Result := SendMessage(Self.Handle,LB_GETCURSEL,0,0);
end;

procedure TTodoListBox.SetItemIndexEx(const Value: Integer);
begin
  FItemIndex := Value;
  if MultiSelect then
  begin
    SendMessage(Handle,LB_SELITEMRANGE,Value,MakeLParam(Value,Value));
  end;
  SendMessage(Handle,LB_SETCURSEL,value,0);
end;

procedure TTodoListBox.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FImages) then
    FImages := Nil;
  inherited;
end;

procedure TTodoListBox.SynchColumns;
begin
  if Assigned(FColumnsChanged) then
    FColumnsChanged(self);
end;

procedure TTodoListBox.SetProgressLook(const Value: TProgressLook);
begin
  FProgressLook.Assign(Value);
end;

procedure TTodoListBox.ProgressLookChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TTodoListBox.SetGridLines(const Value: Boolean);
begin
  FGridLines := Value;
  Invalidate;
end;

procedure TTodoListBox.SynchItems;
var
  OldIdx: Integer;

begin
  OldIdx := ItemIndex;
  if (csLoading in ComponentState) then Exit;
  if FUpdateCount > 0 then Exit;

  //synchronize nr. of listboxitems with collection
  while (Items.Count > FTodoItems.Count) do
    Items.Delete(Items.Count - 1);

  while (Items.Count < FTodoItems.Count) do
    Items.Add('');

  if (ItemIndex = -1) and (Items.Count > 0) and (OldIdx <> -1) then
  begin
    if OldIdx < Items.Count then
      ItemIndex := OldIdx
    else
      ItemIndex := Items.Count - 1;
  end;
end;

procedure TTodoListBox.Loaded;
begin
  inherited;
  SynchItems;
  ItemIndex := FItemIndex;
end;

procedure TTodoListBox.BeginUpdate;
begin
  inc(FUpdateCount);
end;

procedure TTodoListBox.EndUpdate;
begin
  if FUpdateCount>0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then SynchItems;
  end;
end;

procedure TTodoListBox.SetDateFormat(const Value: string);
begin
  FDateFormat := Value;
  Invalidate;
end;

{
function TTodoListBox.GetTodoItems(i, j: Integer): String;
begin
  if (i >= Items.Count) then raise Exception.Create('Item index out of range');

//  for k := 1 to j do
//   if fTodos.Items[k-1].TodoData<>ctText then dec(j);

  Result := GetTodo(succ(j), Items[i]);
end;

procedure TTodoListBox.SetTodoItems(i, j: Integer;
  const Value: String);
var
  s,n,l: String;
  k: Integer;

begin
  if (i >= Items.Count) then raise Exception.Create('Item index out of range');

//  for k := 1 to j do
//   if fTodos.Items[k-1].TodoType<>ctText then dec(j);
  inc(j);

  s := self.Items[i];
  k := 0;
  n := '';
  repeat
   if n <> '' then n := n + '|';
   l := GetTodoString(s);
   if (k <> j) then
     n := n + l
   else
     n := n + Value;

   inc(k);
  until (k > j);

  if (s <> '') then
   begin

    n := n + '|' + s;
   end;

  Items[i] := n;
end;
}

function TTodoListBox.GetSortedEx: Boolean;
begin
  Result := FSortedEx;
end;

procedure TTodoListBox.SetShowSelection(const Value: Boolean);
begin
  if FShowSelection <> Value then
  begin
    FShowSelection := Value;
    Invalidate;
  end;
end;


procedure TTodoListBox.SetSortedEx(const Value: Boolean);
begin
  FSortedEx := Value;
end;

procedure TTodoListBox.DoEnter;
begin
  inherited;
  FLookup := '';
end;

procedure TTodoListBox.KeyPress(var Key: Char);
var
  Msg: TMessage;
begin
  if (Key in ['A'..'z','0'..'9']) and FOwner.Editable then
    StartEdit(ItemIndex,FFocusColumn,False,Msg,0,0,Key);
  inherited;
end;

procedure TTodoListBox.KeyDown(var Key: Word; Shift: TShiftState);
var
  i: Integer;
  s: String;
  Msg: TMessage;
  ATodoItem: TTodoItem;

  function Max(a,b: Integer):Integer;
  begin
    if (a > b) then Result := a else Result := b;
  end;

begin
  if key in [VK_LEFT,VK_RIGHT] then
  begin
    if Key = VK_LEFT then
      if FFocusColumn > 0 then
      begin
        FFocusColumn := FFocusColumn - 1;
        ItemIndex := ItemIndex;
      end;

    if Key = VK_RIGHT then
      if FFocusColumn < FOwner.Columns.Count - 1 then
      begin
        FFocusColumn := FFocusColumn + 1;
        ItemIndex := ItemIndex;
      end;

    Key := 0;
  end;

  inherited;

  if (Key = VK_F2) or (Key = VK_SPACE) then
  begin
    StartEdit(ItemIndex,FFocusColumn,False,Msg,0,0,#0);
  end;

  if (Key = VK_INSERT) and FOwner.AutoInsertItem  then
  begin
    ATodoItem := FOwner.Items.Add;

    ATodoItem.CreationDate := Now;
    ATodoItem.DueDate := Now + 1;
    ATodoItem.CompletionDate := ATodoItem.DueDate;

    if FOwner.AllowAutoInsert(ATodoItem) then
    begin
      ATodoItem.Select;

      for i := 1 to FOwner.Columns.Count do
        if FOwner.Columns[i - 1].TodoData = tdSubject then
          FFocusColumn := i - 1;

      StartEdit(ItemIndex,FFocusColumn,False,Msg,0,0,#0);
    end
    else
    begin
      ATodoItem.Free;
    end;
  end;

  if (Key = VK_DELETE) and FOwner.AutoDeleteItem  then
  begin
    ATodoItem := FOwner.Items[ItemIndex];

    if FOwner.AllowAutoDelete(ATodoItem) then
      FOwner.Items[ItemIndex].Free;
  end;


  if key in [VK_UP,VK_DOWN,VK_LEFT,VK_RIGHT,VK_NEXT,VK_PRIOR,VK_HOME,VK_END,VK_ESCAPE] then
  begin
    FLookup := '';
    Exit;
  end;

  if (key = VK_BACK) and (Length(FLookup) > 0) then
    Delete(FLookup,Length(FLookup),1)
  else
    if not FLookupIncr then fLookup := chr(key) else
      if (key>31) and (key<=255) then FLookup := FLookup + chr(key);

  if (ItemIndex >= 0) or (FLookupIncr) then
  begin
    for i := Max(1,ItemIndex+1) to Items.Count do
    begin
      // s := TodoItems[i-1,fLookupTodo];
      if (s <> '') then
      if (pos(UpperCase(FLookup),uppercase(s)) = 1) then
      begin
        ItemIndex := i - 1;
//        Invalidate;
        Exit;
      end;
    end;
  end;

  for i := 1 to Items.Count do
  begin
    //s := TodoItems[i-1,fLookupTodo];

    if (s <> '') then
    if (pos(uppercase(fLookup),uppercase(s))=1) then
      begin
       ItemIndex := i-1;
       Exit;
      end;
   end;

  if FLookupIncr then
   begin
    fLookup:=chr(key);
    for i := 1 to Items.Count do
     begin
      //s := TodoItems[i-1,fLookupTodo];
      if (s<>'') then
      if (pos(uppercase(fLookup),uppercase(s))=1) then
       begin
        ItemIndex := i-1;
        Exit;
       end;
     end;
   end;

end;

procedure TTodoListBox.SetPreview(const Value: Boolean);
begin
  FPreview := Value;
  Invalidate;
end;


procedure TTodoListBox.SetCompletionFont(const Value: TFont);
begin
  FCompletionFont.Assign(Value);
  Invalidate;
end;

procedure TTodoListBox.SetPreviewFont(const Value: TFont);
begin
  FPreviewFont.Assign(Value);
  Invalidate;
end;

procedure TTodoListBox.SetPriorityFont(const Value: TFont);
begin
  FPriorityFont.Assign(Value);
  Invalidate;
end;

procedure TTodoListBox.SetSelectionColor(const Value: TColor);
begin
  FSelectionColor := Value;
  Invalidate;
end;

procedure TTodoListBox.SetSelectionFontColor(const Value: TColor);
begin
  FSelectionFontColor := Value;
  Invalidate;  
end;

{ TTodoColumnItem }

procedure TTodoColumnItem.Assign(Source: TPersistent);
begin
  if Source is TTodoColumnItem then
  begin
    Alignment := TTodoColumnItem(Source).Alignment;
    Caption := TTodoColumnItem(Source).Caption;
    Color := TTodoColumnItem(Source).Color;
    Editable := TTodoColumnItem(Source).Editable;
    Font.Assign(TTodoColumnItem(Source).Font);
    TodoData := TTodoColumnItem(Source).TodoData;
    Width := TTodoColumnItem(Source).Width;
  end;
end;

constructor TTodoColumnItem.Create(Collection: TCollection);
var
  AOwner: TTodoListBox;
begin
  inherited;
  FFont := TFont.Create;
  FWidth := 100;
  FColor := clWindow;
  FEditable:=True;
  AOwner := TTodoColumnCollection(Collection).FOwner;
  if AOwner.HandleAllocated then AOwner.SynchColumns;
  FFont.Assign(AOwner.Font);
end;

destructor TTodoColumnItem.Destroy;
var
  AOwner: TTodoListBox;
begin
  AOwner := TTodoColumnCollection(Collection).FOwner;
  FFont.Free;
  Inherited;
  if AOwner.HandleAllocated then AOwner.SynchColumns;
end;

function TTodoColumnItem.GetDisplayName: string;
begin
  if Caption <> '' then
    Result := Caption
  else
    Result := 'Column' + IntToStr(Index);
end;

procedure TTodoColumnItem.SetAlignment(const value: tAlignment);
begin
  FAlignment := Value;
  Changed;
end;

procedure TTodoColumnItem.SetColor(const value: TColor);
begin
  FColor := Value;
  Changed;
end;

procedure TTodoColumnItem.SetTodoData(const Value: TTodoData);
begin
  FTodoData := Value;
  if FTodoData = tdHandle then
    FEditable := False;
  Changed;
end;

procedure TTodoColumnItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  Changed;
end;

procedure TTodoColumnItem.SetWidth(const Value: Integer);
var
  AOwner: TTodoListBox;
begin
  FWidth := Value;
  Changed;
  AOwner := TTodoColumnCollection(Collection).FOwner;
  if AOwner.HandleAllocated then AOwner.SynchColumns;
end;

procedure TTodoColumnItem.SetCaption(const Value: string);
var
  AOwner: TTodoListBox;
begin
  FCaption := Value;
  Changed;
  AOwner := TTodoColumnCollection(Collection).FOwner;
  if AOwner.HandleAllocated then AOwner.SynchColumns;
end;

procedure TTodoColumnItem.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
  TTodoColumnCollection(Collection).Changed;
end;

procedure TTodoColumnItem.LoadFromStream(S: TStream);
var Count, i, ID, Size: Integer;
begin
  Count := ReadInteger(S);
  for i := 1 to Count do
  begin
    ID := ReadByte(S);
    Size := ReadWord(S);
    case ID of
       1: Width := ReadInteger(S);
       2: Caption := ReadString(S, Size);
       3: TodoData := TTodoData(ReadByte(S));
    end
  end;
end;

procedure TTodoColumnItem.SaveToStream(S: TStream);
begin
  // the number of properties i'm saving
  WriteInteger(S, 3);

  SaveProperty(S, 1, @FWidth, 4);
  SaveProperty(S, 2, @FCaption[1], Length(FCaption));
  SaveProperty(S, 3, @FTodoData, 1);
end;

{ TTodoColumnCollection }

function TTodoColumnCollection.Add: TTodoColumnItem;
begin
  Result := TTodoColumnItem(inherited Add);
end;

constructor TTodoColumnCollection.Create(AOwner: TTodoListBox);
begin
  inherited Create(TTodoColumnItem);
  FOwner := AOwner;
end;

function TTodoColumnCollection.GetItem(Index: Integer): TTodoColumnItem;
begin
  Result := TTodoColumnItem(inherited Items[index]);
end;

function TTodoColumnCollection.GetOwner: tPersistent;
begin
  Result := FOwner;
end;

function TTodoColumnCollection.Insert(Index: Integer): TTodoColumnItem;
begin
  {$IFNDEF DELPHI4_LVL}
  Result := TTodoColumnItem(inherited Add);
  {$ELSE}
  Result := TTodoColumnItem(inherited Insert(index));
  {$ENDIF}
end;

procedure TTodoColumnCollection.SetItem(Index: Integer;
  const Value: TTodoColumnItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TTodoColumnCollection.Swap(Item1, Item2: TTodoColumnItem);
var
  ti: TTodoColumnItem;
begin
  ti := TTodoColumnItem.Create(Self);
  ti.Assign(Item1);
  Item1.Assign(Item2);
  Item2.Assign(ti);
  ti.Free;
end;

procedure TTodoColumnCollection.Update(Item: TCollectionItem);
begin
  inherited;
  if FOwner.HandleAllocated then
  begin
    FOwner.Invalidate;
    FOwner.SynchColumns;
  end;
end;


{ TTodoItemCollection }

function TTodoItemCollection.Add: TTodoItem;
begin
  Result := TTodoItem(inherited Add);
end;

constructor TTodoItemCollection.Create(aOwner: TTodoListBox);
begin
  inherited Create(TTodoItem);
  FOwner := AOwner;
end;

function TTodoItemCollection.GetItem(Index: Integer): TTodoItem;
begin
  Result := TTodoItem(inherited Items[index]);
end;

function TTodoItemCollection.GetOwner: tPersistent;
begin
  Result := FOwner;
end;

function TTodoItemCollection.Insert(index: Integer): TTodoItem;
begin
  {$IFNDEF DELPHI4_LVL}
  Result := TTodoItem(inherited Add);
  {$ELSE}
  Result := TTodoItem(inherited Insert(index));
  {$ENDIF}
end;

function TTodoItemCollection.IndexInTodoOf(col: Integer;
  s: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 1 to Count do
  begin
    if Items[i-1].Notes.Count > col then
    if Items[i-1].Notes[col] = s then
    begin
      Result := i-1;
      Break;
    end;
  end;
end;

function TTodoItemCollection.IndexInRowOf(row: Integer;
  s: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  if (Count>Row) then
  for i := 1 to Items[row].Notes.Count do
  begin
    if Items[row].Notes[i-1] = s then
    begin
      Result := i-1;
      Break;
    end;
  end;
end;


function TTodoItemCollection.IndexOf(s: string): tpoint;
var
  i,j: Integer;
begin
  Result := Point(-1,-1);
  for i := 1 to Count do
  begin
    for j := 1 to Items[i-1].Notes.Count do
      if Items[i-1].Notes[j-1] = s then
      begin
        Result.y := i-1;
        Result.x := j-1;
        Break;
      end;
  end;
end;

procedure TTodoItemCollection.SetItem(Index: Integer;
  const Value: TTodoItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TTodoItemCollection.Update(Item: TCollectionItem);
begin
  inherited;
end;

procedure TTodoItemCollection.Changed;
begin
  FOwner.Invalidate;
end;

procedure TTodoItemCollection.ItemChanged(Index: Integer);
begin
  if (Index >= 0) and (Index < FOwner.Items.Count) then
  begin
    FOwner.RepaintItem(Index)
  end;
end;

{ TTodoItem }

procedure TTodoItem.Assign(Source: TPersistent);
begin
  if Source is TTodoItem then
  begin
    ImageIndex := TTodoItem(Source).ImageIndex;
    Notes.Assign(TTodoItem(Source).Notes);
    TTodoItemCollection(collection).FOwner.SynchItems;
    Subject := TTodoItem(Source).Subject;
    Complete := TTodoItem(Source).Complete;
    Completion := TTodoItem(Source).Completion;
    CompletionDate := TTodoItem(Source).CompletionDate;
    CreationDate := TTodoItem(Source).CreationDate;
    DueDate := TTodoItem(Source).DueDate;
    Priority := TTodoItem(Source).Priority;
    Project := TTodoItem(Source).Project;
    Resource := TTodoItem(Source).Resource;
    Status := TTodoItem(Source).Status;
    Tag := TTodoItem(Source).Tag;
    TotalTime := TTodoItem(Source).TotalTime;
  end;
end;

constructor TTodoItem.Create(Collection: TCollection);
var
  AOwner: TTodoListBox;
begin
  inherited;
  FNotes := TStringList.Create;
  FImageIndex := -1;
  FNotes.OnChange := StringsChanged;

  AOwner := TTodoItemCollection(Collection).FOwner;
  if AOwner.HandleAllocated then
  AOwner.SynchItems;
end;

destructor TTodoItem.Destroy;
var
  AOwner: TTodoListBox;
begin
  AOwner := TTodoItemCollection(Collection).FOwner;
  FNotes.Free;
  inherited;
  if AOwner.HandleAllocated then
     AOwner.SynchItems;
end;

function TTodoItem.GetDisplayName: string;
begin
  if Subject <> '' then
    Result := Subject
  else
    Result := 'Item' + IntToStr(Index);
end;

procedure TTodoItem.Changed;
begin
  {
  if Assigned(FOnChange) then
    FOnChange(Self);
  }
  TTodoItemCollection(Collection).ItemChanged(Index);
end;

procedure TTodoItem.SetCompletion(const Value: TCompletion);
begin
  if FCompletion <> Value then
  begin
    FCompletion := Value;
    Changed;
  end;
end;

procedure TTodoItem.SetDueDate(const Value: TDateTime);
begin
  if FDueDate <> Value then
  begin
    FDueDate := Value;
    Changed;
  end;
end;

procedure TTodoItem.SetImageIndex(const Value: Integer);
begin
 if FImageIndex <> Value then
 begin
   FImageIndex := value;
   Changed;
 end;
end;

procedure TTodoItem.SetNotes(const Value: TStringList);
begin
  FNotes.Assign(Value);
  Changed;
end;

procedure TTodoItem.SetPriority(const Value: TTodoPriority);
begin
  if FPriority <> Value then
  begin
    FPriority := Value;
    Changed;
  end;
end;

procedure TTodoItem.SetStatus(const Value: TTodoStatus);
begin
  if FStatus <> Value then
  begin
    FStatus := Value;
    Changed;
  end;
end;

procedure TTodoItem.SetSubject(const Value: string);
begin
  if FSubject <> Value then
  begin
    FSubject := Value;
    Changed;
  end;
end;

procedure TTodoItem.SetTotalTime(const Value: Integer);
begin
  if FTotalTime <> Value then
  begin
    FTotalTime := Value;
    Changed;
  end;
end;

procedure TTodoItem.StringsChanged(sender: TObject);
var
  Idx: Integer;
begin
  Idx := TTodoItemCollection(Collection).FOwner.ItemIndex;
  TTodoItemCollection(Collection).FOwner.SynchItems;
  TTodoItemCollection(Collection).FOwner.ItemIndex := Idx;
end;

procedure TTodoItem.SetComplete(const Value: Boolean);
begin
  if FComplete <> Value then
  begin
    FComplete := Value;
    Changed;
  end;
end;

procedure TTodoItem.SetCompletionDate(const Value: TDateTime);
begin
  if FCompletionDate <> Value then
  begin
    FCompletionDate := Value;
    Changed;
  end;
end;

procedure TTodoItem.SetCreationDate(const Value: TDateTime);
begin
  if FCreationDate <> Value then
  begin
    FCreationDate := Value;
    Changed;
  end;
end;

procedure TTodoItem.SetResource(const Value: string);
begin
  if FResource <> Value then
  begin
    FResource := Value;
    Changed;
  end;
end;

procedure TTodoItem.Select;
begin
   with (Collection as TTodoItemCollection).FOwner as TTodoListBox do
   begin
     ItemIndex := Self.Index;
   end;
end;

function TTodoItem.GetNotesLine: string;
begin
  if Notes.Count > 0 then
    Result := Notes.Strings[0]
  else
    Result := '';
end;

procedure TTodoItem.SaveToStream(S: TStream);
var
  STemp: String;
begin
  // the number of properties i'm saving
  WriteInteger(S, 14);

  // save the properties
  STemp := Notes.Text;
  SaveProperty(S,  1, @FComplete, 1);
  SaveProperty(S,  2, @FCompletion, 1);
  SaveProperty(S,  3, @FCompletionDate, 8);
  SaveProperty(S,  4, @FCreationDate, 8);
  SaveProperty(S,  5, @FDueDate, 8);
  SaveProperty(S,  6, @FImageIndex, 4);
  SaveProperty(S,  7, @STemp[1], Length(STemp));
  SaveProperty(S,  8, @FPriority, 1);
  SaveProperty(S,  9, @FResource[1], Length(FResource));
  SaveProperty(S, 10, @FStatus, 1);
  SaveProperty(S, 11, @FSubject[1], Length(FSubject));
  SaveProperty(S, 12, @FTag, 4);
  SaveProperty(S, 13, @FTotalTime, 4);
  SaveProperty(S, 14, @FProject[1], Length(FProject));
end;

procedure TTodoItem.LoadFromStream(S: TStream);
var Count, i, ID, Size: Integer;
begin
  Count := ReadInteger(S);
  for i := 1 to Count do
  begin
    ID := ReadByte(S);
    Size := ReadWord(S);
    case ID of
       1: Complete := ReadBoolean(S);
       2: Completion := ReadByte(S);
       3: CompletionDate := ReadDateTime(S);
       4: CreationDate := ReadDateTime(S);
       5: DueDate := ReadDateTime(S);
       6: ImageIndex := ReadInteger(S);
       7: Notes.Text := ReadString(S, Size);
       8: Priority := TTodoPriority(ReadByte(S));
       9: Resource := ReadString(S, Size);
      10: Status := TTodoStatus(ReadByte(S));
      11: Subject := ReadString(S, Size);
      12: Tag := ReadInteger(S);
      13: TotalTime := ReadInteger(S);
      14: Project := ReadString(S, Size);
      else S.Seek(Size, soFromCurrent);
    end
  end;
end;

procedure TTodoItem.SetProject(const Value: String);
begin
  if FProject <> Value then
  begin
    FProject := Value;
    Changed;
  end;
end;

{ TTodoHeader }

constructor TTodoHeader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOwner := AOwner as TCustomTodoList;
  FColor := clBtnFace;
  FLeftPos := 0;
  FTextHeight := 16;
  FItemHeight := 16;

  if not (csDesigning in ComponentState) then
  begin
    FInplaceEdit := TMemo.Create(Self);
    FInplaceEdit.Parent := Self;
    FInplaceEdit.Visible := False;
    FInplaceEdit.OnExit := InplaceExit;
  end;

  FOnDragDrop := OwnOnDragDrop;
end;

destructor TTodoHeader.Destroy;
begin
  if not (csDesigning in ComponentState) then
    FInplaceEdit.Free;
  inherited;
end;

procedure TTodoHeader.InplaceExit(Sender: TObject);
begin
  Sections[FEditSection] := FInplaceEdit.Text;
  SectionWidth[FEditSection] := FEditWidth;
  FInplaceEdit.Visible := False;
end;

procedure TTodoHeader.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TTodoHeader.SetVAlignment(const Value: TVAlignment);
begin
  FVAlignment := Value;
  Invalidate;
end;

procedure TTodoHeader.SetColor(const Value: TColor);
begin
  FColor := Value;
  Invalidate;
end;

procedure TTodoHeader.SetLineColor(const Value: TColor);
begin
  FLineColor := Value;
  Invalidate;
end;

procedure TTodoHeader.SetImageList(const Value: TImageList);
begin
  FImageList := Value;
  Invalidate;
end;

procedure TTodoHeader.SetOrientation(const Value: THeaderOrientation);
begin
  FOrientation := Value;
  Invalidate;
end;

procedure TTodoHeader.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
  Invalidate;
end;

procedure TTodoHeader.SetImagePosition(const Value: TImagePosition);
begin
  FImagePosition := Value;
  Invalidate;
end;

function TTodoHeader.GetSectionRect(X: Integer): TRect;
var
  Offset, SectionIndex: Integer;
begin
  Offset := 0;
  for SectionIndex := 0 to X-1 do
    Offset := Offset + SectionWidth[SectionIndex];

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
    Result.Right := Self.Height;
    Result.Top := Offset;
    Result.Bottom := Offset + SectionWidth[X];
  end;
end;

function TTodoHeader.XYToSection(X, Y: Integer): Integer;
var
  Ofs, SectionIndex: Integer;
begin
  Ofs := 0;
  SectionIndex := 0;
  if FOrientation = hoHorizontal then
  begin
    while (Ofs < X) and (SectionIndex < Sections.Count) do
    begin
      Ofs := Ofs + SectionWidth[SectionIndex];
      Inc(SectionIndex);
    end;
    Dec(SectionIndex);
  end
  else
  begin
    while (Ofs < Y) and (SectionIndex < Sections.Count) do
    begin
      Ofs := Ofs + SectionWidth[SectionIndex];
      Inc(SectionIndex);
    end;
    Dec(SectionIndex);
  end;
  Result := SectionIndex;
end;

procedure TTodoHeader.DrawSortIndicator(Canvas:TCanvas;x,y: Integer);
var
  left,vpos: Integer;
begin
  left := x;
  vpos := y;

  if FSortDirection = sdDescending then
  begin
    {draw a full Colored triangle}
    Canvas.Pen.Color := clWhite;
    Canvas.Pen.Width := 1;
    Canvas.MoveTo(Left + 4,vpos - 4);
    Canvas.LineTo(Left,vpos + 4);
    Canvas.pen.Color := clGray;
    Canvas.LineTo(Left - 4,vpos - 4);
    Canvas.LineTo(Left + 4,vpos - 4);
    Canvas.pen.Color := clBlack;
  end
  else
  begin
    Canvas.pen.Color := clWhite;
    Canvas.pen.Width := 1;
    Canvas.MoveTo(Left - 4,vpos + 4);
    Canvas.LineTo(Left + 4,vpos + 4);
    Canvas.LineTo(Left,vpos - 4);
    Canvas.pen.Color := clGray;
    Canvas.LineTo(Left - 4,vpos + 4);
    Canvas.pen.Color := clBlack;
  end;
end;


procedure TTodoHeader.Paint;
var
  SectionIndex, w, AIdx: Integer;
  s: string;
  r: TRect;
  pr: TRect;
  HorizontalAlign: Word;
  VerticalAlign: Word;
  AllPainted: Boolean;
  DoDraw: Boolean;
  
begin
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
    if (Orientation = hoHorizontal) then
      r := Rect(0, 0, 0, ClientHeight)
    else
      r := Rect(0, 0, ClientWidth, 0);

    w := 0;
    s := '';

    HorizontalAlign := AlignToFlag(FAlignment);
    VerticalAlign := 0;

    AllPainted := False;
    repeat
      if SectionIndex < Sections.Count then
      begin
        w := SectionWidth[SectionIndex];

        case FVAlignment of
          vtaTop: VerticalAlign := DT_TOP;
          vtaCenter: VerticalAlign := DT_VCENTER;
          vtaBottom: VerticalAlign := DT_BOTTOM;
        else
          VerticalAlign := DT_TOP;
        end;

        if FOffset = 1 then
        begin
          if (SectionIndex < Sections.Count - 1 - FLeftPos) and (SectionIndex > 0) then
          begin
            AIdx := SectionIndex + FLeftPos;
            s := Sections[AIdx];
          end
          else
          begin
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
        Inc(SectionIndex);
      end;

      if (Orientation = hoHorizontal) then
      begin
        r.Left := r.Right;
        Inc(r.Right, w);
        if (ClientWidth - r.Right < 2) or (SectionIndex = Sections.Count) then
        begin
          r.Right := ClientWidth;
          AllPainted := True;
        end;
      end
      else
      begin
        r.Top := r.Bottom;
        Inc(r.Bottom, w);

        if (ClientHeight - r.Bottom < 2) or (SectionIndex = Sections.Count) then
        begin
          r.Bottom := ClientHeight;
          AllPainted := True;
        end;
      end;

      pr := r;

      FillRect(r);

      DoDraw := True;
      
      {
      if Assigned(TPlanner(Owner).FOnPlannerHeaderDraw) then
      begin
        Font := Self.Font;
        Brush.Color := FColor;
        Pen.Color := FLineColor;
        Pen.Width := 1;
        TPlanner(Owner).FOnPlannerHeaderDraw(TPlanner(Owner), Canvas, r, AIdx,
          DoDraw);
      end;
      }

      if DoDraw then
      begin
        InflateRect(pr, -4, -2);

        {
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
        }

        if Pos(#13, s) = 0 then
          VerticalAlign := VerticalAlign or DT_SINGLELINE
        else
          VerticalAlign := 0;

        pr.Bottom := pr.Top + FTextHeight;

        if (SectionIndex - 1 = SortedSection) and FSortShow then
          pr.Right := pr.Right - 16;

        DrawText(Canvas.Handle, PChar(s), Length(s), pr, DT_NOPREFIX or
          DT_END_ELLIPSIS or HorizontalAlign or VerticalAlign);

        if (SectionIndex - 1 = SortedSection) and FSortShow then
        begin
          DrawText(Canvas.Handle, PChar(s), Length(s), pr, DT_NOPREFIX or
            DT_END_ELLIPSIS or HorizontalAlign or VerticalAlign or DT_CALCRECT);

          if r.Right > pr.Right then
            DrawSortIndicator(Canvas,r.Right - 8,pr.Top + 6)
          else
            DrawSortIndicator(Canvas,pr.Right + 8,pr.Top + 6)
        end;

        if not FFlat then
        begin
          DrawEdge(Canvas.Handle, r, BDR_RAISEDINNER, BF_TOPLEFT);
          DrawEdge(Canvas.Handle, r, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
        end
        else
        begin
          if (SectionIndex > 1) and (Orientation = hoHorizontal) and (FLineColor <> clNone) then
          begin
            Canvas.MoveTo(r.Left + 1, r.Top);
            Canvas.LineTo(r.Left + 1, r.Bottom);
          end;
          if (SectionIndex > 1) and (Orientation = hoVertical) and (FLineColor <> clNone) then
          begin
            Canvas.MoveTo(r.Left, r.Top + 2);
            Canvas.LineTo(r.Right, r.Top + 2);
          end;
        end;

        {
        with (Owner as TPlanner) do
        begin
          APlannerItem := Items.HeaderFirst(SectionIndex - 2 + FLeftPos);

          while Assigned(APlannerItem) do
          begin
            pr.Left := r.Left + 2;
            pr.Right := r.Right - 2;
            pr.Top := pr.Bottom;
            pr.Bottom := pr.Bottom + FItemHeight;

            APlannerItem.FRepainted := False;
            FGrid.PaintItemCol(Self.Canvas, pr, APlannerItem, False);
            APlannerItem := Items.HeaderNext(SectionIndex - 2 + FLeftPos);
          end;
        end;
        }

        Font := Self.Font;
        Brush.Color := FColor;
        Pen.Color := FLineColor;
        Pen.Width := 1;
      end;

    until (AllPainted);
  end;
end;

procedure TTodoHeader.WMLButtonDown(var Message: TWMLButtonDown);
var
  r: TRect;
  Column: Integer;
begin
  if FSectionDragDrop and not FDragging then
  begin
    FDragStart := XYToSection(Message.XPos, Message.YPos);

    if (FDragStart >= FOffset) then
    begin
      FDragging := True;
      Self.Cursor := crDrag;
      SetCapture(Self.Handle);
    end;
  end;

  if FSectionEdit and not (csDesigning in ComponentState) then
  begin
    if FInplaceEdit.Visible then
    begin
      Sections[FEditSection] := FInplaceEdit.Text;
      SectionWidth[FEditSection] := FEditWidth;
    end;

    FEditSection := XYToSection(Message.xpos, Message.ypos);
    r := GetSectionRect(FEditSection);

    InflateRect(r, -2, -2);
    OffsetRect(r, 2, 2);

    FInplaceEdit.Top := r.Top;
    FInplaceEdit.Left := r.Left;
    FInplaceEdit.Width := r.Right - r.Left;
    FInplaceEdit.Height := r.Bottom - r.Top;
    FInplaceEdit.Color := Self.Color;
    FInplaceEdit.Font.Assign(Self.Font);
    FInplaceEdit.Text := Self.Sections[FEditSection];
    FInplaceEdit.BorderStyle := bsNone;
    FInplaceEdit.Visible := True;
    FInplaceEdit.SelectAll;

    FEditWidth := SectionWidth[FEditSection];

    FInplaceEdit.SetFocus;
  end;

  inherited;

  Column := XYToSection(Message.XPos, Message.YPos);

  with Owner as TCustomTodoList do
  begin
    r := GetSectionRect(Column);

    HideEditor;

    if (Column >= 0) and (Column < Columns.Count) and
       (Abs(Message.Xpos - r.Left) > 4) and (Abs(Message.XPos - r.Right) > 4) then
    begin
      if Columns[Column].TodoData <> tdHandle then
      begin
        if SortColumn = Column then
        begin
          if SortDirection = sdAscending then
            SortDirection := sdDescending
          else
            SortDirection := sdAscending;
        end
        else
        begin
          SortColumn := Column;
        end;
      end;
    end;
  end;

  if Assigned(FOnClick) then
    FOnClick(Self, Column);
end;

procedure TTodoHeader.WMLButtonUp(var Message: TWMLButtonUp);
var
  FDragStop: Integer;
begin
  inherited;

  if Assigned(FOnClick) then
    FOnClick(Self, XYToSection(Message.xpos, Message.ypos));

  if FSectionDragDrop and FDragging then
  begin
    FDragging := False;
    Self.Cursor := crDefault;
    ReleaseCapture;
    if Assigned(FOnDragDrop) then
    begin
      FDragStop := XYToSection(Message.xpos, Message.ypos);

      if (FDragStop >= FOffset) and (FDragStop <> FDragStart) then
        FOnDragDrop(Self, FDragStart, FDragStop);
    end;
  end;

end;

procedure TTodoHeader.WMRButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  if Assigned(FOnRightClick) then
    FOnRightClick(Self, XYToSection(Message.xpos, Message.ypos));
end;

procedure TTodoHeader.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
  Invalidate;
end;

procedure TTodoHeader.SetTextHeight(const Value: Integer);
begin
  FTextHeight := Value;
  Invalidate;
end;


procedure TTodoHeader.SetSortDirection(const Value: TSortDirection);
begin
  FSortDirection := Value;
  Invalidate;
end;

procedure TTodoHeader.SetSortedSection(const Value: Integer);
begin
  FSortedSection := Value;
  Invalidate;
end;

procedure TTodoHeader.OwnOnDragDrop(Sender: TObject; FromSection,
  ToSection: Integer);
begin
  FOwner.Columns.Items[FromSection].Index := ToSection;
  FOwner.ColumnsChanged(FOwner);
  if Assigned(FOwner.FOnHeaderDragDrop)
    then FOwner.FOnHeaderDragDrop(FOwner, FromSection, ToSection); 
end;

{ TCustomTodoList }

procedure TCustomTodoList.CheckChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TCustomTodoList.ColumnsChanged(Sender: TObject);
var
  Col: Integer;
begin
  if (csLoading in ComponentState) then Exit;

  with FTodoHeader do
  begin
    while (Sections.Count > FTodoListBox.TodoColumns.Count) do
      Sections.Delete(Sections.Count-1);

    while (Sections.Count < FTodoListBox.TodoColumns.Count) do
      Sections.Add('');

    for Col := 1 to Sections.Count do
    begin
      Sections[Col-1] := FTodoListBox.TodoColumns.Items[Col-1].Caption;
      SectionWidth[Col-1] := FTodoListBox.TodoColumns.Items[Col-1].Width;
    end;
  end;
end;

constructor TCustomTodoList.Create(AOwner: TComponent);
begin
  inherited;
  FTodoListBox := TTodoListBox.Create(Self);
  FTodoHeader := TTodoHeader.Create(Self);
  FStatusStrings := TStatusStrings.Create(Self);
  FPriorityStrings := TPriorityStrings.Create(Self);
  FEditColors := TEditColors.Create(Self);
  FCompleteCheck := TCompleteCheck.Create;
  FCompleteCheck.OnChange := CheckChanged;
  {$IFDEF USE_PLANNERDATEPICKER}
  FCalendarType := tcPlannerCalendar;
  {$ENDIF}

  FTodoHeader.Parent := self;
  FTodoHeader.Visible := True;
  FTodoHeader.BorderStyle := bsNone;
  FTodoHeader.Height := 18;
  FTodoHeader.Align := alTop;
  FTodoHeader.OnSized := SectionSized;
  FTodoHeader.OnClick := HeaderClick;
  FTodoHeader.OnRightClick := HeaderRightClick;

  FTodoListBox.Parent := Self;
  FTodoListBox.Visible := True;
  FTodoListBox.Align := alClient;
  FTodoListBox.BorderStyle := bsNone;
  FTodoListBox.OnColumnsChanged := ColumnsChanged;
  FTodoListBox.ParentShowHint := False;

  FTodoListBox.OnMouseMove := ListMouseMove;
  FTodoListBox.OnMouseDown := ListMouseDown;
  FTodoListBox.OnMouseUp := ListMouseUp;

  FTodoListBox.OnKeyDown := ListKeyDown;
  FTodoListBox.OnKeyUp := ListKeyUp;
  FTodoListBox.OnKeyPress := ListKeyPress;

  FTodoListBox.OnClick := ListClick;
  FTodoListBox.OnDblClick := ListDblClick;

  FTodoListBox.OnDragDrop := ListDragDrop;
  FTodoListBox.OnDragOver := ListDragOver;
  FTodoListBox.OnStartDrag := ListStartDrag;
  FTodoListBox.OnEndDrag := ListEndDrag;

  FTodoListBox.OnEnter := ListEnter;
  FTodoListBox.OnExit := ListExit;
  FTodoListBox.OnSelectItem := ListSelect;

  FNullDate := 'None';

  TabStop := False;

  ItemHeight := 18;

  Width := 100;
  Height := 100;
  FStatusListWidth := 70;
  FPriorityListWidth := 70;
  BorderStyle := bsSingle;

  FCompletionGraphic := True;
  FHintShowFullText := False;
  HeaderDragDrop := False;
end;

procedure TCustomTodoList.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if FBorderStyle = bsSingle then
    Params.Style := Params.Style or WS_BORDER
  else
    Params.Style := Params.Style and not WS_BORDER;
end;

destructor TCustomTodoList.Destroy;
begin
  FTodoListBox.Free;
  FTodoHeader.Free;
  FStatusStrings.Free;
  FPriorityStrings.Free;
  FEditColors.Free;
  FCompleteCheck.Free;
  inherited;
end;

function TCustomTodoList.GetColor: TColor;
begin
  Result := FTodoListBox.Color;
end;

function TCustomTodoList.GetCompletionFont: TFont;
begin
  Result := FTodoListBox.CompletionFont;
end;

function TCustomTodoList.GetDateFormat: string;
begin
  Result := FTodoListBox.DateFormat;
end;

function TCustomTodoList.GetEditable: boolean;
begin
  result:=FTodoListBox.Editable;
end;

function TCustomTodoList.GetFont: TFont;
begin
  Result := FTodoListBox.Font;
end;

function TCustomTodoList.GetGridLines: Boolean;
begin
  Result := FTodoListBox.GridLines;
end;

function TCustomTodoList.GetImages: TImageList;
begin
  Result := FTodoListBox.Images;
end;

function TCustomTodoList.GetItemHeight: Integer;
begin
  Result := FItemHeight;
end;

function TCustomTodoList.GetPreview: Boolean;
begin
  Result := FTodoListBox.Preview;
end;

function TCustomTodoList.GetPreviewFont: TFont;
begin
  Result := FTodoListBox.PreviewFont;
end;

function TCustomTodoList.GetPriorityFont: TFont;
begin
  Result := FTodoListBox.PriorityFont;
end;

function TCustomTodoList.GetProgressLook: TProgressLook;
begin
  Result := FTodoListBox.ProgressLook;
end;

function TCustomTodoList.GetSelectAllInSubjectEdit: Boolean;
begin
  Result := FTodoListBox.EditSelectAll;
end;

function TCustomTodoList.GetSelectionColor: TColor;
begin
  Result := FTodoListBox.SelectionColor;
end;

function TCustomTodoList.GetSelectionFontColor: TColor;
begin
  Result := FTodoListBox.SelectionFontColor;
end;

function TCustomTodoList.GetShowSelection: Boolean;
begin
  Result := FTodoListBox.ShowSelection;
end;

function TCustomTodoList.GetTodoColumns: TTodoColumnCollection;
begin
  Result := FTodoListBox.TodoColumns;
end;

function TCustomTodoList.GetTodoItems: TTodoItemCollection;
begin
  Result := FTodoListBox.TodoItems;
end;

procedure TCustomTodoList.ListClick(Sender: TObject);
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TCustomTodoList.ListDblClick(Sender: TObject);
begin
  if Assigned(FOnDblClick) then
    FOnDblClick(Self);
end;

procedure TCustomTodoList.ListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(FOnKeyDown) then
    FOnKeyDown(Self, Key, Shift);
end;

procedure TCustomTodoList.ListKeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(FOnKeyPress) then
    FOnKeyPress(Self, Key);
end;

procedure TCustomTodoList.ListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(FOnKeyUp) then
    FOnKeyUp(Self, Key, Shift);
end;

procedure TCustomTodoList.ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Self,Button,Shift,X,Y);
end;

procedure TCustomTodoList.ListMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Assigned(FOnMouseMove) then
    FOnMouseMove(Self,Shift,X,Y);
end;

procedure TCustomTodoList.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseUp) then
    FOnMouseUp(Self,Button,Shift,X,Y);
end;

procedure TCustomTodoList.ListDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Assigned(FOnDragDrop) then
    FOnDragDrop(Self, Source, X, Y);
end;

procedure TCustomTodoList.ListDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(FOnDragOver) then
    FOnDragOver(Self, Source, X, Y, State, Accept);
end;

procedure TCustomTodoList.ListEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if Assigned(FOnEndDrag) then
    FOnEndDrag(Self, Target, X, Y);
end;

procedure TCustomTodoList.ListStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if Assigned(FOnStartDrag) then
    FOnStartDrag(Self, DragObject);
end;

procedure TCustomTodoList.Loaded;
begin
  inherited;
  FTodoListBox.SynchItems;
  ColumnsChanged(FTodoListBox);
end;

function TCustomTodoList.PriorityCommaText: string;
var i: TTodoPriority;
begin
  for i := Low(TTodoPriority) to High(TTodoPriority) do
    Result := Result + ',"' + PriorityStrings[i] + '"';
  Delete(Result, 1, 1);
//  Result := '"Lowest", "Low", "Normal", "High", "Highest"';
end;

function TCustomTodoList.PriorityToString(AValue: TTodoPriority): string;
begin
//  case AValue of
//  tpLowest: Result := 'Lowest';
//  tpLow: Result := 'Low';
//  tpNormal: Result := 'Normal';
//  tpHigh: Result := 'High';
//  tpHighest: Result := 'Highest';
//  else
//    EConversionFunctionException.Create('TodoPriorityToString error. Unknown priority passed as parameter to the function.');
//  end;

  Result := PriorityStrings[AValue];

  if Assigned(FOnPriorityToString) then
    FOnPriorityToString(Self,AValue,Result);
end;

procedure TCustomTodoList.SectionSized(Sender: TObject; SectionIdx,
  SectionWidth: Integer);
begin
  if FTodoListBox.TodoColumns.Count > SectionIdx then
  begin
    FTodoListBox.TodoColumns.Items[SectionIdx].Width := SectionWidth;
  end;
end;

procedure TCustomTodoList.SetBorderStyle(const Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TCustomTodoList.SetColor(const Value: TColor);
begin
  FTodoListBox.Color := Value;
end;

procedure TCustomTodoList.SetCompleteCheck(const Value: TCompleteCheck);
begin
  FCompleteCheck.Assign(Value);
end;

procedure TCustomTodoList.SetCompletionFont(const Value: TFont);
begin
  FTodoListBox.CompletionFont.Assign(Value);
end;

procedure TCustomTodoList.SetDateFormat(const Value: string);
begin
  FTodoListBox.DateFormat := Value;
end;

procedure TCustomTodoList.SetEditable(const Value: boolean);
begin
  FTodoListBox.Editable:=Value;
end;

procedure TCustomTodoList.SetFont(const Value: TFont);
begin
  FTodoListBox.Font.Assign(Value);
end;

procedure TCustomTodoList.SetGridLines(const Value: Boolean);
begin
  FTodoListBox.GridLines := Value;
end;

procedure TCustomTodoList.SetImages(const Value: TImageList);
begin
  FTodoListBox.Images := Value;
end;

procedure TCustomTodoList.SetItemHeight(const Value: Integer);
begin
  if Preview then
  begin
    FTodoListBox.ItemHeight := Value + PreviewHeight;
    FItemHeight := FTodoListBox.ItemHeight - PreviewHeight;
  end
  else
  begin
    FTodoListBox.ItemHeight := Value;
    FItemHeight := FTodoListBox.ItemHeight;
  end;
{ Why not just a FItemHeight := Value; at the end of the Set method? Because
  the TCustomListBox ItemHeight property refuses to take all values. For
  example, if I assign to 0, it will remain set to the default value.
  The FItemHeight setting code above exists in order to propagate this
  behaviour to the TCustomTodoList level. }
end;

procedure TCustomTodoList.SetPreview(const Value: Boolean);
begin
  FTodoListBox.Preview := Value;
  SetItemHeight(ItemHeight);
end;

procedure TCustomTodoList.SetPreviewFont(const Value: TFont);
begin
  FTodoListBox.PreviewFont.Assign(Value);
end;

procedure TCustomTodoList.SetPreviewHeight(const Value: Integer);
begin
  FPreviewHeight := Value;
  SetItemHeight(ItemHeight);
end;

procedure TCustomTodoList.SetPriorityFont(const Value: TFont);
begin
  FTodoListBox.PriorityFont.Assign(Value);
end;

procedure TCustomTodoList.SetProgressLook(const Value: TProgressLook);
begin
  FTodoListBox.ProgressLook.Assign(Value);
end;

procedure TCustomTodoList.SetSelectAllInSubjectEdit(const Value: Boolean);
begin
  FTodoListBox.EditSelectAll := Value;
end;

procedure TCustomTodoList.SetSelectionColor(const Value: TColor);
begin
  FTodoListBox.SelectionColor := Value;
end;

procedure TCustomTodoList.SetSelectionFontColor(const Value: TColor);
begin
  FTodoListBox.SelectionFontColor := Value;
end;

procedure TCustomTodoList.SetShowSelection(const Value: Boolean);
begin
  FTodoListBox.ShowSelection := Value;
end;

procedure TCustomTodoList.SetTodoColumns(const Value: TTodoColumnCollection);
begin
  FTodoListBox.TodoColumns.Assign(Value);
end;

procedure TCustomTodoList.SetTodoItems(const Value: TTodoItemCollection);
begin
  FTodoListBox.TodoItems.Assign(Value);
end;

function TCustomTodoList.StatusCommaText: string;
var i: TTodoStatus;
begin
  for i := Low(TTodoStatus) to High(TTodoStatus) do
    Result := Result + ',"' + StatusStrings[i] + '"';
  Delete(Result, 1, 1);
//  Result:='"Not started", "In progress", "Completed", "Deferred"';
end;

function TCustomTodoList.StatusToString(AValue: TTodoStatus): string;
begin
  Result := StatusStrings[AValue];

  if Assigned(FOnStatusToString) then
     FOnStatusToString(Self,AValue,Result);
end;

function TCustomTodoList.StringToPriority(AValue: string): TTodoPriority;
var
  i: TTodoPriority;
  lFound: Boolean;
begin
  AValue := LowerCase(AValue);

  lFound := False;
  for i := Low(TTodoPriority) to High(TTodoPriority) do
    if LowerCase(PriorityStrings[i]) = AValue then begin
      lFound := True;
      Result := i;
    end;

  if not lFound then
    raise EConversionFunctionException.Create('TodoPriorityFromString error. The parameter "'+AValue+'" is not a valid priority string.');

  if Assigned(FOnStringToPriority) then
    FOnStringToPriority(Self,AValue,Result);
end;

function TCustomTodoList.StringToStatus(AValue: string): TTodoStatus;
var
  i: TTodoStatus;
  lFound: Boolean;
begin
  lFound := False;
  AValue := LowerCase(AValue);

  for i := Low(TTodoStatus) to High(TTodoStatus) do
    if LowerCase(StatusStrings[i]) = AValue then
    begin
      lFound := True;
      Result := i;
    end;

  if not lFound then
    raise EConversionFunctionException.Create('TodoStatusFromString error. The parameter "'+AValue+'" is not a valid status string.');

  if Assigned(FOnStringToStatus) then
    FOnStringToStatus(Self,AValue,Result);
end;

function TCustomTodoList.CompareItems(A,B: Integer): Integer;
var
  Item1,Item2: TTodoItem;

begin
  Item1 := Items.Items[A];
  Item2 := Items.Items[B];

  Result := 0;

  case Columns.Items[FSortColumn].TodoData of
  tdComplete:
    begin

      if Item1.Complete and not Item2.Complete then
        Result := 1;

      if not Item1.Complete and Item2.Complete then
        Result := -1;
    end;
  tdCompletion:
    begin
      if Item1.Completion > Item2.Completion then
        Result := 1 else
          if Item1.Completion < Item2.Completion then
            Result := -1;
    end;
  tdCompletionDate:
    begin
      if Item1.CompletionDate > Item2.CompletionDate then
        Result := 1 else
          if Item1.CompletionDate < Item2.CompletionDate then
            Result := -1;
    end;
  tdCreationDate:
    begin
      if Item1.CreationDate > Item2.CreationDate then
        Result := 1 else
          if Item1.CreationDate < Item2.CreationDate then
            Result := -1;
    end;
  tdDueDate:
    begin
      if Item1.DueDate > Item2.DueDate then
        Result := 1 else
          if Item1.DueDate < Item2.DueDate then
            Result := -1;
    end;
  tdPriority:
    begin
      if Item1.Priority > Item2.Priority then
        Result := 1 else
          if Item1.Priority < Item2.Priority then
            Result := -1;
    end;
  tdSubject:
    begin
      Result := AnsiStrComp(PChar(Item1.Subject),PChar(Item2.Subject));
    end;
  tdResource:
    begin
      Result := AnsiStrComp(PChar(Item1.Resource),PChar(Item2.Resource));
    end;
  tdNotes:
    begin
      Result := AnsiStrComp(PChar(Item1.Notes.Text),PChar(Item2.Notes.Text));
    end;
  tdProject:
    begin
      Result := AnsiStrComp(PChar(Item1.Project),PChar(Item2.Project));
    end;
  tdImage:
      if Item1.ImageIndex > Item2.ImageIndex then
        Result := 1 else
          if Item1.ImageIndex < Item2.ImageIndex then
            Result := -1;
  end;

  if FSortDirection = sdDescending then
    Result := Result * -1;
end;

procedure TCustomTodoList.SwapItems(A,B: Integer);
var
  SI: TTodoItem;
  SK: string;
begin
  SI := Items.Add;
  SI.Assign(Items.Items[A]);
  SK := Items.Items[A].DBKey; // public property
  Items.Items[A].Assign(Items.Items[B]);
  Items.Items[A].DBKey := Items.Items[B].DBKey;
  Items.Items[B].Assign(SI);
  Items.Items[B].DBKey := SK;
  SI.Free;
end;

procedure TCustomTodoList.QuickSortItems(Left,Right: Integer);
var
  i,j: Integer;
  Mid: Integer;

begin
  i := Left;
  j := Right;

  // get middle item here
  Mid := (Left + Right) shr 1;

  repeat
    while (CompareItems(Mid,i) > 0) and (i < Right) do Inc(i);
    while (CompareItems(Mid,j) < 0) and (j > Left) do Dec(j);
    if i <= j then
    begin
      if i <> j then
      begin
        if CompareItems(i,j) <> 0 then
        begin
          if i = FNewIdx then
            FNewIdx := j
          else
            if j = FNewIdx then
              FNewIdx := i;

          SwapItems(i,j);
        end;
      end;
      Inc(i);
      Dec(j);
    end;
  until i > j;

  if (Left < j) then
    QuicksortItems(Left,j);
  if (i < Right) then
    QuickSortItems(i,right);
end;


procedure TCustomTodoList.Sort;
begin
  FNewIdx := FTodoListBox.ItemIndex;

  if Items.Count > 1 then
    QuickSortItems(0,Items.Count - 1);

  FTodoListBox.ItemIndex := FNewIdx;

  ListSelect(Self);
end;

{
function TCustomTodoList.XYToColItem(const X, Y: Integer; var ColIdx,
  ItemIdx: Integer; var R:TRect): Boolean;
begin
  ItemIdx := SendMessage(FTodoListBox.Handle,LB_ITEMFROMPOINT,0,MakeLong(X,Y));

  Result := ItemIdx >= 0;


  if Result then
  begin
    SendMessage(FTodoListBox.Handle,LB_GETITEMRECT,ItemIdx,Longint(@R));
    Result := False;
    ColIdx := 0;

    while ColIdx < Columns.Count do
    begin
      R.Right := R.Left + Columns.Items[ColIdx].Width;

      if (X >= R.Left) and (X <= R.Right) then
      begin
        Result := True;
        Break;
      end
      else
        R.Left := R.Right;

      Inc(ColIdx);
    end;
  end;
end;
}

procedure TCustomTodoList.ListEnter(Sender: TObject);
begin
  if Assigned(FOnEnter) then
    FOnEnter(Self);
end;

procedure TCustomTodoList.ListExit(Sender: TObject);
begin
  if Assigned(FOnExit) then
    FOnExit(Self);
end;

function TCustomTodoList.GetDragCursor: TCursor;
begin
  Result := FTodoListBox.DragCursor;
end;

function TCustomTodoList.GetDragKind: TDragKind;
begin
  Result:= FTodoListBox.DragKind;
end;

function TCustomTodoList.GetDragMode: TDragMode;
begin
  Result := FTodoListBox.DragMode;
end;

procedure TCustomTodoList.SetDragCursor(const Value: TCursor);
begin
  FTodoListBox.DragCursor := Value;
end;

procedure TCustomTodoList.SetDragKind(const Value: TDragKind);
begin
  FTodoListBox.DragKind := Value;
end;

procedure TCustomTodoList.SetDragModeEx(const Value: TDragMode);
begin
  FTodoListBox.DragMode := Value;
end;

procedure TCustomTodoList.SetSortColumn(const Value: Integer);
begin
  if FSortColumn <> Value then
  begin
    FSortColumn := Value;
    FTodoHeader.SortedSection := Value;
    if FSorted and (FSortColumn >= 0) then
      Sort;
  end;
end;

procedure TCustomTodoList.SetSortDirection(const Value: TSortDirection);
begin
  if FSortDirection <> Value then
  begin
    FSortDirection := Value;
    FTodoHeader.SortDirection := Value;
    if FSorted then Sort;
  end;
end;

procedure TCustomTodoList.SetSorted(const Value: Boolean);
begin
  FSorted := Value;
  FTodoHeader.SortShow := Value;
  FTodoHeader.Invalidate; 
  if FSorted = True then
    Sort;
end;

procedure TCustomTodoList.HeaderClick(Sender: TObject; Section: Integer);
begin
  if Assigned(FOnHeaderClick) then
    FOnHeaderClick(Self,Section);
end;

procedure TCustomTodoList.HeaderRightClick(Sender: TObject; Section: Integer);
begin
  if Assigned(FOnHeaderRightClick) then
    FOnHeaderRightClick(Self,Section);
end;

procedure TCustomTodoList.HideEditor;
begin
  FTodoListBox.EditorOnExit(Self);
end;

procedure TCustomTodoList.ShowEditor(Index,Column: Integer);
var
  Msg: TMessage;
begin
  FTodoListBox.StartEdit(Index,Column,False,Msg,0,0,#0);
end;

function TCustomTodoList.GetSelected: TTodoItem;
begin
  Result := nil;
  if FTodoListBox.ItemIndex >= 0 then
    Result := Items[FTodoListBox.ItemIndex];
end;

function TCustomTodoList.GetHeaderFont: TFont;
begin
  Result := FTodoHeader.Font;
end;

procedure TCustomTodoList.SetHeaderFont(const Value: TFont);
begin
  FTodoHeader.Font.Assign(Value);
end;

function TCustomTodoList.AllowAutoDelete(ATodoItem: TTodoItem): Boolean;
var
  Allow: Boolean;
begin
  Allow := True;
  if Assigned(FOnItemDelete) then
    FOnItemDelete(Self,ATodoItem,Allow);

  Result := Allow;
end;

function TCustomTodoList.AllowAutoInsert(ATodoItem: TTodoItem): Boolean;
var
  Allow: Boolean;
begin
  Allow := True;
  if Assigned(FOnItemInsert) then
    FOnItemInsert(Self,ATodoItem,Allow);
  Result := Allow;
end;

procedure TCustomTodoList.EditDone;
begin
  if Assigned(FOnEditDone) then
    FOnEditDone(Self);
end;

procedure TCustomTodoList.EditStart;
begin
  if Assigned(FOnEditStart) then
    FOnEditStart(Self);
end;

function TCustomTodoList.GetEditColumn: Integer;
begin
  Result := FTodoListBox.FFocusColumn;
end;

procedure TCustomTodoList.SetEditColumn(const Value: Integer);
begin
  FTodoListBox.FFocusColumn := Value;
end;

procedure TCustomTodoList.ListSelect(Sender: TObject);
var
  ATodoItem: TTodoItem;
begin
  if FTodoListBox.ItemIndex >= 0 then
    ATodoItem := Items[FTodoListBox.ItemIndex]
  else
    ATodoItem := nil;

  ItemSelect(ATodoItem);
end;

procedure TCustomTodoList.ItemSelect(ATodoItem: TTodoItem);
begin
  if Assigned(FOnItemSelect) then
    FOnItemSelect(Self, ATodoItem);
end;

procedure TCustomTodoList.AddColumn(Data: TTodoData; ACaption: string);
begin
  with Columns.Add do
  begin
    TodoData := Data;
    Caption := ACaption;
  end
end;

procedure TCustomTodoList.RemoveColumn(Data: TTodoData);
var
  i: Integer;
begin
  for i := 1 to Columns.Count do
  begin
    if Columns[i - 1].TodoData = Data then
    begin
      Columns[i - 1].Free;
      Break;
    end;
  end;
end;

function TCustomTodoList.GetTabStopEx: Boolean;
begin
  Result := FTodoListBox.TabStop;
end;

procedure TCustomTodoList.SetTabStopEx(const Value: Boolean);
begin
  inherited TabStop := False;
  FTodoListBox.TabStop := Value;
end;

function TCustomTodoList.GetTabOrderEx: Integer;
begin
  Result := FTodoListBox.TabOrder;
end;

procedure TCustomTodoList.SetTabOrderEx(const Value: Integer);
begin
  FTodoListBox.TabOrder := Value;
end;

procedure TCustomTodoList.SaveToStream(S: TStream);
var i: Integer;
begin
  i := Items.Count;
  S.Write(i, 4);
  for i := 0 to Items.Count-1 do Items[i].SaveToStream(S);
end;

procedure TCustomTodoList.LoadFromStream(S: TStream);
var i, Count: Integer; 
begin
  S.Read(Count, 4);
  Items.Clear;
  for i := 1 to Count do
    Items.Add.LoadFromStream(S);
  SortColumn := -1;    
end;

procedure TCustomTodoList.LoadFromFile(FileName: String);
var S: TFileStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TCustomTodoList.SaveToFile(FileName: String);
var S: TFileStream;
begin
  S := TFileStream.Create(FileName, fmCreate or fmShareExclusive);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TCustomTodoList.LoadColumns(FileName: String);
var
  S: TFileStream;
  Count, i: Integer;
begin
  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Columns.Clear;
    Count := ReadInteger(S);
    for i := 1 to Count do Columns.Add.LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TCustomTodoList.SaveColumns(FileName: String);
var
  S: TFileStream;
  i: Integer;
begin
  S := TFileStream.Create(FileName, fmCreate or fmShareExclusive);
  try
    WriteInteger(S, Columns.Count);
    for i := 0 to Columns.Count-1 do Columns[i].SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TCustomTodoList.SetCompletionGraphic(const Value: Boolean);
begin
  FCompletionGraphic := Value;
  Invalidate;
end;

procedure TCustomTodoList.SetHeaderDragDrop(const Value: Boolean);
begin
  FHeaderDragDrop := Value;
  FTodoHeader.SectionDragDrop := Value;
end;

procedure TCustomTodoList.SetHintShowFullText(const Value: Boolean);
begin
  FHintShowFullText := Value;
  FTodoListBox.ShowHint := Value;
end;

procedure TCustomTodoList.NCPaintProc;

var
  DC: HDC;
  ARect: TRect;
  Canvas: TCanvas;
begin
  if BorderStyle = bsNone then Exit;

  DC := GetWindowDC(Handle);
  try
    Canvas := TCanvas.Create;
    Canvas.Handle := DC;

    GetWindowRect(Handle, ARect);

    if (Parent is TWinControl) then
    begin
      Canvas.Pen.Color := clGray;
      Canvas.MoveTo(0,Height);
      Canvas.LineTo(0,0);
      Canvas.LineTo(Width-1,0);
      Canvas.LineTo(Width-1,Height-1);
      Canvas.LineTo(0,Height-1);
    end;

    Canvas.Free;
  finally

    ReleaseDC(Handle,DC);
  end;
end;


procedure TCustomTodoList.WMNCPaint (var Message: TMessage);
begin
  inherited;
  NCPaintProc;
end;


procedure TCustomTodoList.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if Assigned(Parent) then
    if Parent.HandleAllocated then
      NCPaintProc;
end;

function TCustomTodoList.FormatDateTimeEx(Format: string;
  dt: TDateTime): string;
begin
  Result := FormatDateTime(Format,dt);
  if (dt = 0) and (FNullDate <> '') then
    Result := FNullDate;
end;

procedure TCustomTodoList.SetNullDate(const Value: string);
begin
  FNullDate := Value;
  Invalidate;
end;

function TCustomTodoList.GetEditItem: TTodoItem;
begin
  Result := List.EditedItem;
end;

{ TProgressLook }

procedure TProgressLook.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TProgressLook.Create;
begin
  inherited;
  FCompleteColor := clRed;
  FCompleteFontColor := clWhite;
  FUnCompleteColor := clWindow;
  FUnCompleteFontColor := clWindowText;
end;

procedure TProgressLook.SetCompleteColor(const Value: TColor);
begin
  if FCompleteColor <> Value then
  begin
    FCompleteColor := Value;
    Changed;
  end;
end;

procedure TProgressLook.SetCompleteFontColor(const Value: TColor);
begin
  if FCompleteFontColor <> Value then
  begin
    FCompleteFontColor := Value;
    Changed;
  end;
end;


procedure TProgressLook.SetUnCompleteColor(const Value: TColor);
begin
  if FUnCompleteColor <> Value then
  begin
    FUnCompleteColor := Value;
    Changed;
  end;
end;

procedure TProgressLook.SetUnCompleteFontColor(const Value: TColor);
begin
  if FUnCompleteFontColor <> Value then
  begin
    FUnCompleteFontColor := Value;
    Changed;
  end;
end;

procedure TTodoListBox.EditorOnExit(Sender: TObject);
var
  Date : TDateTime;
  TodoData : TTodoData;
begin
  if ActiveEditor = nil then
    Exit;
  { This event handler executes when an in-place editor component loses focus.
  The task of this event handler is to transfer the data to the TodoListBox, then
  to make the editor disappear. }
  if Assigned(EditedColumn)
    then TodoData := EditedColumn.TodoData
    else TodoData := tdNotes;

  if ActiveEditor = StringEditor then                     // string
  begin
    if TodoData = tdSubject then
      EditedItem.Subject := StringEditor.Text;

    if TodoData = tdResource then
      EditedItem.Resource := StringEditor.Text;

    if TodoData = tdProject then
      EditedItem.Project := StringEditor.Text;
  end
{$IFDEF USE_PLANNERDATEPICKER}
  else if ActiveEditor = PlannerDateEditor then              // date
  begin
    Date := PlannerDateEditor.Calendar.Date;

    if TodoData = tdCompletionDate then
      EditedItem.CompletionDate := Date
    else if TodoData = tdCreationDate then
      EditedItem.CreationDate := Date
    else if TodoData = tdDueDate then
      EditedItem.DueDate := Date;
  end
{$ENDIF}
  else if ActiveEditor = DefaultDateEditor then              // date
  begin
    Date := DefaultDateEditor.Date;

    if TodoData = tdCompletionDate then
      EditedItem.CompletionDate := Date
    else if TodoData = tdCreationDate then
      EditedItem.CreationDate := Date
    else if TodoData = tdDueDate then
      EditedItem.DueDate := Date;
  end
  else if ActiveEditor = IntegerEditor then               // integer
  begin
    if TodoData = tdTotalTime then
      EditedItem.TotalTime := IntegerEditor.Value
    else if TodoData = tdCompletion then
    begin
      EditedItem.Completion := Min(Max(IntegerEditor.Value, 0), 100);
      EditedItem.Complete := EditedItem.Completion = 100;
    end;
  end
  else if ActiveEditor = StringListEditor then            // string list
  begin
    EditedItem.Notes.Text := StringListEditor.Lines.Text;
  end
  else if ActiveEditor = PriorityEditor then              // priority
  begin
    if TodoData = tdPriority then
      EditedItem.Priority := FOwner.StringToPriority(PriorityEditor.Items[PriorityEditor.ItemIndex]);
  end
  else if ActiveEditor = StatusEditor then
  begin
    if TodoData = tdStatus then
      EditedItem.Status := FOwner.StringToStatus(StatusEditor.Items[StatusEditor.ItemIndex]);
  end;

  if ActiveEditor.Parent = EditorParent then
     ActiveEditor.Parent.Hide
  else
     ActiveEditor.Hide;
  ActiveEditor := nil;

  FOwner.EditDone(TodoData, EditedItem);

  SetFocus;
end;

constructor TInplaceListBox.Create(AOwner: TComponent);
begin
  inherited;
  FMouseDown := False;
  FTodoList := TTodoListBox(AOwner);
end;

function TInplaceListBox.GetItemIndexEx: Integer;
begin
  Result := inherited ItemIndex;
end;

procedure TInplaceListBox.SetItemIndexEx(const Value: Integer);
begin
  FOldItemIndex := Value;
  inherited ItemIndex := Value;
end;

procedure TInplaceListBox.KeyPress(var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    if Assigned(FOnSelected) then
      FOnSelected(Self);
    FTodoList.AdvanceEdit;
  end;

  if Key = #27 then
  begin
    ItemIndex := FOldItemIndex;
    if Assigned(FOnSelected) then
      FOnSelected(Self);
  end;
end;

procedure TInplaceListBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FMouseDown := True;
end;

procedure TInplaceListBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

  if FMouseDown then
    if Assigned(FOnSelected) then
      FOnSelected(Self);

  FMouseDown := False;
end;

procedure TInplaceListBox.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  if Msg.CharCode = VK_TAB then
  begin
    PostMessage(Handle,WM_CHAR,ord(#13),0);
  end;
  inherited;
end;

{ TInplaceODListBox }

constructor TInplaceODListBox.Create(AOwner: TComponent);
begin
  inherited;
  Style := lbOwnerDrawFixed;
  FTodoList := TTodoListBox(AOwner);
end;

procedure TInplaceODListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  Rect.Left := Rect.Left + 16;
  inherited DrawItem(Index,Rect,State);

  if Assigned(ImageList) then
  begin
    Rect.Left := Rect.Left - 16;

    if odSelected in State then
      Canvas.Brush.Color := clHighLight
    else
      Canvas.Brush.Color := clWindow;

    Canvas.Pen.Color := Canvas.Brush.Color;
    Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Left + 16,Rect.Bottom);

    ImageList.DrawingStyle := dsTransparent;
    ImageList.Draw(Canvas,Rect.Left,Rect.Top,4 - Index, True);
  end;
end;

{ TInplaceEdit }

constructor TInplaceEdit.Create(AOwner: TComponent);
begin
  inherited;
  FTodoList := TTodoListBox(AOwner);
end;

procedure TInplaceEdit.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or ES_MULTILINE;
end;

function TInplaceEdit.GetText: string;
begin
   Result := inherited Text;
end;

procedure TInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_F4 then
    DoExit;
end;

procedure TInplaceEdit.KeyPress(var Key: Char);
begin
  inherited;
  if Key = #27 then
  begin
    Text := FOldText;
    DoExit;
  end;

  if Key = #13 then
  begin
    DoExit;
    FTodoList.AdvanceEdit;
  end;
end;

procedure TInplaceEdit.SetText(const Value: string);
begin
  inherited Text := Value;
  FOldText := Value;
end;


procedure ComboBoxDropDown(ComboBoxHandle : THandle; Down : boolean = true);
begin
  if Down then
    SendMessage(ComboBoxHandle, CB_SHOWDROPDOWN, 1, 0)
  else
    SendMessage(ComboBoxHandle, CB_SHOWDROPDOWN, 0, 0);
end;

procedure TTodoListBox.WMVScroll(var Message: TWMScroll);
begin
  if ActiveEditor <> nil then
    EditorOnExit(Self);
  inherited;
end;

procedure SetFontButKeepFontColor(Destination, Source: TFont);
var SaveColor: TColor;
begin
  SaveColor := Destination.Color;
  Destination.Assign(Source);
  Destination.Color := SaveColor;
end;

procedure TTodoListBox.SetEditorFont(Editor : TWinControl; Font : TFont);
begin
  if Editor = StatusEditor then
     SetFontButKeepFontColor(StatusEditor.Font, Font)
  else if Editor = PriorityEditor then
     SetFontButKeepFontColor(PriorityEditor.Font, Font)
{$IFDEF USE_PLANNERDATEPICKER}
  else if Editor = PlannerDateEditor then
     SetFontButKeepFontColor(PlannerDateEditor.Font, Font)
{$ENDIF}
  else if Editor = DefaultDateEditor then
     SetFontButKeepFontColor(DefaultDateEditor.Font, Font)
  else if Editor = IntegerEditor then
     SetFontButKeepFontColor(IntegerEditor.Font, Font)
  else if Editor = StringListEditor then
     SetFontButKeepFontColor(StringListEditor.Font, Font)
  else if Editor = StringEditor then
     SetFontButKeepFontColor(StringEditor.Font, Font);
end;


procedure SetControlRect(Control : TControl; Rect : TRect);
begin
  Control.Top := Rect.Top;
  Control.Left := Rect.Left;
  Control.Width := Rect.Right-Rect.Left;
  Control.Height := Rect.Bottom-Rect.Top;
end;

procedure TTodoListBox.ShowEditor(Editor : TWinControl; R: TRect; UseSeparateParent : Boolean);
begin
  ActiveEditor := Editor;

  if UseSeparateParent then
  begin
    // Empty the content of the form
    while EditorParent.ControlCount <> 0 do
      EditorParent.Controls[EditorParent.ControlCount-1].Parent := nil;

    // Set size
    ActiveEditor.Parent := EditorParent;
    ActiveEditor.Left:=0; ActiveEditor.Top:=0;
    ActiveEditor.Width := R.Right - R.Left;
    ActiveEditor.Height := R.Bottom - R.Top;

    // Put the editor parent in the correct position
    R.TopLeft := ClientToScreen(R.TopLeft);
    R.BottomRight := ClientToScreen(R.BottomRight);
    SetControlRect(EditorParent, R);
  end
  else
  begin
    ActiveEditor.Parent := Self;
    SetControlRect(ActiveEditor, R);
  end;

  SetEditorFont(ActiveEditor, EditedColumn.Font);
  ActiveEditor.Visible := True;
  if UseSeparateParent then
    EditorParent.Visible := True;
  ActiveEditor.SetFocus;
end;

procedure PopulateListBoxEditor(ListBoxEditor : TListBox; CommaText : string);
var
  R : TRect;
begin
  { In the constructor, I create TListBox editors. For example, the
  PriorityEditor is of type TListBox, and it's parent is the TodoListBox.
  When I access the Items property of TListBox, TListBox checks to see if
  the final parent of the TListBox is a TCustomForm. It finds it is not
  (because the parent is not set yet), and raises an exception. That is
  why I use this workaround. }
  if ListBoxEditor.Tag = 0 then
  begin
    ListBoxEditor.Items.CommaText := CommaText;
    R := ListBoxEditor.ItemRect(ListBoxEditor.Items.Count-1);
    ListBoxEditor.Tag := R.Bottom;
  end;
  ListBoxEditor.ClientHeight := ListBoxEditor.Tag;
  ListBoxEditor.Parent.Height := ListBoxEditor.Height;
end;

procedure TTodoListBox.SendClickMessage(Msg: TMessage; X,Y: Integer);
var
  P   : TPoint;
  MMsg : TWMLButtonDown absolute Msg;

begin
  // Calculate screen coordinates
//  P.X := Message.XPos;
//  P.Y := Message.YPos;

  P := Point(X,Y);

  P := ClientToScreen(P);
  P := ActiveEditor.ScreenToClient(P);

  MMsg.XPos := P.X;
  MMsg.YPos := P.Y;

//  ActiveEditor.Perform(WM_LBUTTONDOWN, RawMessage.WParam, Msg.LParam);
//  ActiveEditor.Perform(WM_LBUTTONUP, RawMessage.WParam, Msg.LParam);

  ActiveEditor.Perform(WM_LBUTTONDOWN, Msg.WParam, Msg.LParam);
  ActiveEditor.Perform(WM_LBUTTONUP, Msg.WParam, Msg.LParam);
end;

procedure TTodoListBox.EditNotesInPreviewArea(Idx: Integer; R:TRect; Msg: TMessage; X,Y: Integer);
begin
  EditedItem := TodoItems.Items[Idx];

  if ActiveEditor <> nil then
    EditorOnExit(ActiveEditor);

  // ShowEditor function does not apply here, because of the possibility
  // that the "Notes" column might be missing
  ActiveEditor := StringListEditor;

  StringListEditor.Parent := FOwner;
  StringListEditor.BorderStyle := bsNone;

  with StringListEditor do
  begin
    SetFontButKeepFontColor(Font, TCustomTodoList(Self.Parent).PreviewFont);
    Lines.Assign(EditedItem.Notes);
    OrigLines.Assign(EditedItem.Notes);

    { Here I could substract the top border height and the left border
    width, in order to put the string list editor in the correct position.
    However, if the TodoList has left=0, this makes all components on the
    form shift to the right. So I have to adjust preview drawing in order to
    achieve the same effect. }
    Top := Self.Top + R.Top + Self.FOwner.ItemHeight + 1;
    Left := Self.Left + R.Left;

    Height := TCustomTodoList(Self.Parent).PreviewHeight;
    Width := R.Right - R.Left;

    Visible := True;
    SendClickMessage(Msg,X,Y);

    if FEditSelectAll then
      SelectAll;
  end;
end;

procedure TTodoListBox.AdvanceEdit;
begin

  if (FFocusColumn < FOwner.Columns.Count) and FOwner.AutoAdvanceEdit then
  begin
    FFocusColumn := FFocusColumn +1;
    PostMessage(Self.Handle,WM_KEYDOWN,VK_F2,0);
  end;
  
end;


procedure TTodoListBox.StartEdit(Index,Column: Integer; FromMouse: Boolean; Msg: TMessage; X,Y: Integer;ch: Char);
var
  R: TRect;
  P: TPoint;
  NewCompletion: Integer;
  TodoData: TTodoData;
  OldIdx: Integer;
begin
  if not FOwner.Editable then
    Exit;

  if (Index < 0) or (Index >= Items.Count) then
    Exit;

  if Index <> ItemIndex then
  begin
    ItemIndex := Index;
    FOwner.ListSelect(Self);
  end;

  if (Column >= 0) and (Column < TodoColumns.Count) then
  begin
    if not TodoColumns.Items[Column].Editable then
      Exit;
  end
  else
    if not FOwner.Preview then
      Exit;

  FOwner.EditStart;

  ColItemRect(Column,Index,R);

  R.Bottom := R.Top + FOwner.ItemHeight;

  P := Point(X,Y);

  // If there is an active editor,
  if ActiveEditor <> nil then
    EditorOnExit(ActiveEditor);

  // Assign current column and item fields
  EditedColumn := nil;
  if (Column >= 0) and (Column < TodoColumns.Count) then
  begin
    EditedColumn := TodoColumns.Items[Column];
    TodoData := EditedColumn.TodoData;
  end
  else
    TodoData := tdNotes;

  EditedItem := TodoItems.Items[Index];

  case TodoData of
  tdSubject:
  begin
    if ch <> #0 then
      StringEditor.Text := ch
    else
      StringEditor.Text := EditedItem.Subject;

    StringEditor.Font.Assign(TodoColumns.Items[Column].Font);

    ShowEditor(StringEditor, R, False);
    if FEditSelectAll and (ch = #0) then
      StringEditor.SelectAll // Select all the text in editor. This call may not be needed.
    else
      if FromMouse then
        SendClickMessage(Msg,X,Y)
      else
        StringEditor.SelStart := Length(StringEditor.Text);
  end;

  tdResource:
  begin
    if ch <> #0 then
      StringEditor.Text := ch
    else
      StringEditor.Text := EditedItem.Resource;

    StringEditor.Font.Assign(TodoColumns.Items[Column].Font);

    ShowEditor(StringEditor, R, False);
    if FEditSelectAll and (ch = #0) then
      StringEditor.SelectAll // Select all the text in editor. This call may not be needed.
    else
      if FromMouse then
        SendClickMessage(Msg,X,Y)
      else
        StringEditor.SelStart := Length(StringEditor.Text);

  end;

  tdProject:
  begin
    if ch <> #0 then
      StringEditor.Text := ch
    else
      StringEditor.Text := EditedItem.Project;

    StringEditor.Font.Assign(TodoColumns.Items[Column].Font);

    ShowEditor(StringEditor, R, False);
    if FEditSelectAll and (ch = #0) then
      StringEditor.SelectAll // Select all the text in editor. This call may not be needed.
    else
      if FromMouse then
        SendClickMessage(Msg,X,Y)
      else
        StringEditor.SelStart := Length(StringEditor.Text);
  end;

  tdNotes:
  if FOwner.Preview then
  begin
    StringListEditor.Font.Assign(PreviewFont);
    OldIdx := Index;
    ClickedOnNotes(False, P, Index, R); // Calculate correct rectangle
    EditNotesInPreviewArea(OldIdx, R, Msg, X, Y);
  end
  else
  begin
    ShowEditor(StringListEditor, R, True);
    StringListEditor.Font.Assign(TodoColumns.Items[Column].Font);
    StringListEditor.BorderStyle := bsSingle;
    StringListEditor.Lines.Assign(EditedItem.Notes);
    StringListEditor.OrigLines.Assign(EditedItem.Notes);

    if (StringListEditor.Lines.Text = '') and (ch <> #0) then
    begin
      StringListEditor.Lines.Text := ch;
      StringListEditor.SelStart := 1;
    end;

    StringListEditor.Height := StringListEditor.Width;
    EditorParent.Height := StringListEditor.Height;
  end;

  tdTotalTime:
  begin
    IntegerEditor.Value := EditedItem.TotalTime;
    ShowEditor(IntegerEditor, R, False);
    IntegerEditor.Font.Assign(TodoColumns.Items[Column].Font);
  end;

  tdDueDate:
  begin
{$IFDEF USE_PLANNERDATEPICKER}
    if TCustomTodoList(Parent).CalendarType = tcPlannerCalendar then
    begin
      PlannerDateEditor.Calendar.Date := EditedItem.DueDate;
      PlannerDateEditor.Text := DateToStr(EditedItem.DueDate);
      ShowEditor(PlannerDateEditor, False);
      PlannerDateEditor.DropDown;
    end else
    begin
{$ENDIF}
      DefaultDateEditor.Date := EditedItem.DueDate;
      ShowEditor(DefaultDateEditor, R, False);
      DefaultDateEditor.Font.Assign(TodoColumns.Items[Column].Font);

      if FromMouse then
        SendClickMessage(Msg,X,Y);
//        ResendThisClickMessageToActiveEditor;
{$IFDEF USE_PLANNERDATEPICKER}
    end;
{$ENDIF}
  end;

  tdCompletionDate:
  begin
{$IFDEF USE_PLANNERDATEPICKER}
    if TCustomTodoList(Parent).CalendarType = tcPlannerCalendar then
    begin
      PlannerDateEditor.Calendar.Date := EditedItem.CompletionDate;
      PlannerDateEditor.Text := DateToStr(EditedItem.CompletionDate);
      ShowEditor(PlannerDateEditor, False);
      PlannerDateEditor.DropDown;
    end else
    begin
{$ENDIF}
      DefaultDateEditor.Date := EditedItem.CompletionDate;
      ShowEditor(DefaultDateEditor, R, False);
      DefaultDateEditor.Font.Assign(TodoColumns.Items[Column].Font);
{$IFDEF USE_PLANNERDATEPICKER}
    end;
{$ENDIF}
  end;

  tdCreationDate:
  begin
{$IFDEF USE_PLANNERDATEPICKER}
    if TCustomTodoList(Parent).CalendarType = tcPlannerCalendar then
    begin
      PlannerDateEditor.Calendar.Date := EditedItem.CreationDate;
      PlannerDateEditor.Text := DateToStr(EditedItem.CreationDate);
      ShowEditor(PlannerDateEditor, False);
      PlannerDateEditor.DropDown;
    end else
    begin
{$ENDIF}
      DefaultDateEditor.Date := EditedItem.CreationDate;
      ShowEditor(DefaultDateEditor, R, False);
      DefaultDateEditor.Font.Assign(TodoColumns.Items[Column].Font);
      ComboBoxDropDown(DefaultDateEditor.Handle);
{$IFDEF USE_PLANNERDATEPICKER}
    end;
{$ENDIF}
  end;

  tdPriority:
  begin
    R.Right := R.Left + TCustomTodoList(Parent).FPriorityListWidth;
    ShowEditor(PriorityEditor, R, True);
    PopulateListBoxEditor(PriorityEditor, FOwner.PriorityCommaText); // must be always called after ShowEditor
    PriorityEditor.ItemIndex := PriorityEditor.Items.IndexOf(FOwner.PriorityToString(EditedItem.Priority));
    PriorityEditor.Ctl3D := False;
    PriorityEditor.Font.Assign(TodoColumns.Items[Column].Font);
    PriorityEditor.ImageList := FPriorityImageList;
  end;

  tdStatus:
  begin
    R.Right := R.Left + TCustomTodoList(Parent).FStatusListWidth;
    ShowEditor(StatusEditor, R, True);
    PopulateListBoxEditor(StatusEditor, FOwner.StatusCommaText);
    StatusEditor.ItemIndex := StatusEditor.Items.IndexOf(FOwner.StatusToString(EditedItem.Status));
    StatusEditor.Font.Assign(TodoColumns.Items[Column].Font);
    StatusEditor.Ctl3D := False;
  end;

  // Items which don't have a specialized editor
  tdComplete:
  begin
    TodoItems.Items[Index].Complete:=
       not TodoItems.Items[Index].Complete;

    FOwner.EditDone(TodoData,TodoItems.Items[Index]);
  end;

  tdCompletion:
    if FOwner.CompletionGraphic then
    begin
      NewCompletion := 100 * (X - R.Left) div (R.Right - R.Left - 1);

      TodoItems.Items[Index].Complete := NewCompletion = 100;
      TodoItems.Items[Index].Completion := NewCompletion;
      FOwner.EditDone(TodoData,TodoItems.Items[Index]);      
    end
    else
    begin
      IntegerEditor.Value := EditedItem.Completion;
      ShowEditor(IntegerEditor, R, False);
      IntegerEditor.Font.Assign(TodoColumns.Items[Column].Font);
    end;
  end;
end;

procedure TTodoListBox.RepaintItem(Index: Integer);
var
  r: TRect;
begin
  SendMessage(Handle,LB_GETITEMRECT,Index,longint(@r));
  InvalidateRect(Handle,@r,False);
end;

procedure TTodoListBox.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 0;
end;

procedure TTodoListBox.WMLButtonUp(var Message: TWMLButtonDown);
var
  R: TRect;
  P: TPoint;
  EditedColIdx, EditedItemIdx : Integer;
  RawMessage : TMessage absolute Message;

begin
  if not FEditable then
  begin
    inherited;
    Exit;
  end;

  P.X := Message.XPos;
  P.Y := Message.YPos;

  if XYToColItem(P.X, P.Y, EditedColIdx, EditedItemIdx, R) and
    (EditedItemIdx < TodoItems.Count) then
  begin
    if FFocusColumn <> EditedColIdx then
    begin
      FFocusColumn := EditedColIdx;
      RepaintItem(EditedItemIdx);
    end;

    if not TodoColumns.Items[EditedColIdx].Editable then
    begin
      inherited;
      Exit;
    end;
    if FOwner.DragMode = dmAutomatic then
      EndDrag(False);

    inherited;

    StartEdit(EditedItemIdx,EditedColIdx,True,RawMessage,Message.XPos, Message.YPos,#0);
  end
  else
    inherited;

  if FOwner.Preview and ClickedOnNotes(True, P, EditedItemIdx, R) then
  begin
    if FOwner.DragMode = dmAutomatic then
      EndDrag(False);
    EditNotesInPreviewArea(EditedItemIdx, R, RawMessage, Message.XPos, Message.YPos);
  end;
end;

{ Even if the result is false, it calculates the preview rectangle of the clicked item. }
function TTodoListBox.ClickedOnNotes(const CalcItem: Boolean; const P: TPoint; out ItemIdx: Integer; out R: TRect): Boolean;
var
   TopBorderWidth, LeftBorderWidth, RightBorderWidth, BottomBorderWidth : integer;
begin
  if CalcItem then
    ItemIdx := ItemAtPos(P, True);

  if ItemIdx = -1 then
    Result := False
  else
  begin
    SendMessage(Handle,LB_GETITEMRECT,ItemIdx,Longint(@R));
    Result := (P.Y > R.Top + FOwner.ItemHeight) and (P.Y < R.Bottom);

    // Take into account listbox border width
    WinControlBorderWidths(self, LeftBorderWidth, RightBorderWidth, TopBorderWidth, BottomBorderWidth);
    R.Top := R.Top + TopBorderWidth;
    R.Bottom := R.Bottom + TopBorderWidth;
    R.Left := R.Left + LeftBorderWidth;
    R.Right := R.Right + LeftBorderWidth;
  end
end;

{ TStatusStrings }

constructor TStatusStrings.Create(AOwner: TCustomTodoList);
begin
  inherited Create;

  FOwner := AOwner;
  FStatusStrings[tsDeferred] := 'Deferred';
  FStatusStrings[tsNotStarted] := 'Not started';
  FStatusStrings[tsCompleted] := 'Completed';
  FStatusStrings[tsInProgress] := 'In progress';
end;

function TStatusStrings.GetString(Index: TTodoStatus): String;
begin
  Result := FStatusStrings[Index];
end;

function TStatusStrings.GetStringC: String;
begin
  Result := FStatusStrings[tsCompleted];
end;

function TStatusStrings.GetStringD: String;
begin
  Result := FStatusStrings[tsDeferred];
end;

function TStatusStrings.GetStringI: String;
begin
  Result := FStatusStrings[tsInProgress];
end;

function TStatusStrings.GetStringN: String;
begin
  Result := FStatusStrings[tsNotStarted];
end;

procedure TStatusStrings.SetString(Index: TTodoStatus;
  const Value: String);
begin
  FStatusStrings[Index] := Value;
  FOwner.Invalidate;
end;

procedure TStatusStrings.SetStringC(const Value: String);
begin
  FStatusStrings[tsCompleted] := Value;
  FOwner.Invalidate;
end;

procedure TStatusStrings.SetStringD(const Value: String);
begin
  FStatusStrings[tsDeferred] := Value;
  FOwner.Invalidate;
end;

procedure TStatusStrings.SetStringI(const Value: String);
begin
  FStatusStrings[tsInProgress] := Value;
  FOwner.Invalidate;
end;

procedure TStatusStrings.SetStringN(const Value: String);
begin
  FStatusStrings[tsNotStarted] := Value;
  FOwner.Invalidate;
end;

{ TPriorityStrings }

constructor TPriorityStrings.Create(AOwner: TCustomTodoList);
begin
  inherited Create;

  FOwner := AOwner;
  FPriorityStrings[tpLowest] := 'Lowest';
  FPriorityStrings[tpLow] := 'Low';
  FPriorityStrings[tpNormal] := 'Normal';
  FPriorityStrings[tpHigh] := 'High';
  FPriorityStrings[tpHighest] := 'Highest';
end;

function TPriorityStrings.GetString(Index: TTodoPriority): String;
begin
  Result := FPriorityStrings[Index];
end;

function TPriorityStrings.GetStringH: String;
begin
  Result := FPriorityStrings[tpHigh];
end;

function TPriorityStrings.GetStringHS: String;
begin
  Result := FPriorityStrings[tpHighest];
end;

function TPriorityStrings.GetStringL: String;
begin
  Result := FPriorityStrings[tpLow];
end;

function TPriorityStrings.GetStringLS: String;
begin
  Result := FPriorityStrings[tpLowest];
end;

function TPriorityStrings.GetStringN: String;
begin
  Result := FPriorityStrings[tpNormal];
end;

procedure TPriorityStrings.SetString(Index: TTodoPriority;
  const Value: String);
begin
  FPriorityStrings[Index] := Value;
  FOwner.Invalidate;
end;

procedure TPriorityStrings.SetStringH(const Value: String);
begin
  FPriorityStrings[tpHigh] := Value;
  FOwner.Invalidate;
end;

procedure TPriorityStrings.SetStringHS(const Value: String);
begin
  FPriorityStrings[tpHighest] := Value;
  FOwner.Invalidate;
end;

procedure TPriorityStrings.SetStringL(const Value: String);
begin
  FPriorityStrings[tpLow] := Value;
  FOwner.Invalidate;
end;

procedure TPriorityStrings.SetStringLS(const Value: String);
begin
  FPriorityStrings[tpLowest] := Value;
  FOwner.Invalidate;
end;

procedure TPriorityStrings.SetStringN(const Value: String);
begin
  FPriorityStrings[tpNormal] := Value;
  FOwner.Invalidate;
end;

{ TEditColors }

constructor TEditColors.Create(AOwner: TCustomTodoList);
begin
  inherited Create;
  FOwner := AOwner;
  FStringEditor := TBackForeColors.Create(Self, FOwner.FTodoListBox.StringEditor);
  FMemoEditor := TBackForeColors.Create(Self, FOwner.FTodoListBox.StringListEditor);
  FIntegerEditor := TBackForeColors.Create(Self, FOwner.FTodoListBox.IntegerEditor);
  FPriorityEditor := TBackForeColors.Create(Self, FOwner.FTodoListBox.PriorityEditor);
  FStatusEditor := TBackForeColors.Create(Self, FOwner.FTodoListBox.StatusEditor);
{$IFDEF USE_PLANNERDATEPICKER}
  FPlannerDateEditor := TPlannerDatePickerColors.Create(Self, TPlannerDatePicker(FOwner.FTodoListBox.PlannerDateEditor));
{$ENDIF}
  FDefaultDateEditor := TDatePickerColors.Create(Self, TTodoDateTimePicker(FOwner.FTodoListBox.DefaultDateEditor));
end;

destructor TEditColors.Destroy;
begin
  FStringEditor.Free;
  FMemoEditor.Free;
  FIntegerEditor.Free;
  FPriorityEditor.Free;
  FStatusEditor.Free;
{$IFDEF USE_PLANNERDATEPICKER}
  FPlannerDateEditor.Free;
{$ENDIF}
  FDefaultDateEditor.Free;
  inherited;
end;

{ TBackForeColors }

constructor TBackForeColors.Create(AOwner: TEditColors;
  AColorControl: TWinControl);
begin
  inherited Create;
  FOwner := AOwner;
  FColorControl := AColorControl;
end;

function TBackForeColors.GetBackColor: TColor;
begin
  if FColorControl is TInPlaceEdit
    then Result := TInPlaceEdit(FColorControl).Color
  else if FColorControl is TInplaceMemo
    then Result := TInplaceMemo(FColorControl).Color
  else if FColorControl is TSpinEdit
    then Result := TSpinEdit(FColorControl).Color
  else if FColorControl is TInPlaceODListBox
    then Result := TInPlaceODListBox(FColorControl).Color
  else if FColorControl is TInPlaceListBox
    then Result := TInPlaceListBox(FColorControl).Color
  else raise Exception.Create('TEditColors.GetBackColor: unknown control class.');
end;

function TBackForeColors.GetFontColor: TColor;
begin
  if FColorControl is TInPlaceEdit
    then Result := TInPlaceEdit(FColorControl).Font.Color
  else if FColorControl is TInplaceMemo
    then Result := TInplaceMemo(FColorControl).Font.Color
  else if FColorControl is TSpinEdit
    then Result := TSpinEdit(FColorControl).Font.Color
  else if FColorControl is TInPlaceODListBox
    then Result := TInPlaceODListBox(FColorControl).Font.Color
  else if FColorControl is TInPlaceListBox
    then Result := TInPlaceListBox(FColorControl).Font.Color
  else raise Exception.Create('TEditColors.GetFontColor: unknown control class.');
end;

procedure TBackForeColors.SetBackColor(const Value: TColor);
begin
  if FColorControl is TInPlaceEdit
    then TInPlaceEdit(FColorControl).Color := Value
  else if FColorControl is TInplaceMemo
    then TInplaceMemo(FColorControl).Color := Value
  else if FColorControl is TSpinEdit
    then TSpinEdit(FColorControl).Color := Value
  else if FColorControl is TInPlaceODListBox
    then TInPlaceODListBox(FColorControl).Color := Value
  else if FColorControl is TInPlaceListBox
    then TInPlaceListBox(FColorControl).Color := Value
  else raise Exception.Create('TEditColors.SetBackColor: unknown control class.');
end;

procedure TBackForeColors.SetFontColor(const Value: TColor);
begin
  if FColorControl is TInPlaceEdit
    then TInPlaceEdit(FColorControl).Font.Color := Value
  else if FColorControl is TInplaceMemo
    then TInplaceMemo(FColorControl).Font.Color := Value
  else if FColorControl is TSpinEdit
    then TSpinEdit(FColorControl).Font.Color := Value
  else if FColorControl is TInPlaceODListBox
    then TInPlaceODListBox(FColorControl).Font.Color := Value
  else if FColorControl is TInPlaceListBox
    then TInPlaceListBox(FColorControl).Font.Color := Value
  else raise Exception.Create('TEditColors.SetFontColor: unknown control class.');
end;

{ TDatePickerColors }

constructor TDatePickerColors.Create(AOwner: TEditColors; AColorControl: TTodoDateTimePicker);
begin
  inherited Create;
  FOwner := AOwner;
  FColorControl := AColorControl;
end;

function TDatePickerColors.GetBackColor: TColor;
begin
  Result := FColorControl.Color;
end;

function TDatePickerColors.GetCalColors: TMonthCalColors;
begin
  Result := FColorControl.CalColors;
end;

function TDatePickerColors.GetFontColor: TColor;
begin
  Result := FColorControl.Font.Color;
end;

procedure TDatePickerColors.SetBackColor(const Value: TColor);
begin
  FColorControl.Color := Value;
end;

procedure TDatePickerColors.SetCalColors(const Value: TMonthCalColors);
begin
  FColorControl.CalColors.Assign(Value);
end;

procedure TDatePickerColors.SetFontColor(const Value: TColor);
begin
  FColorControl.Font.Color := Value;
end;

{$IFDEF USE_PLANNERDATEPICKER}

{ TPlannerDatePickerColors }

constructor TPlannerDatePickerColors.Create(AOwner: TEditColors; AColorControl: TPlannerDatePicker);
begin
  inherited Create;
  FOwner := AOwner;
  FColorControl := AColorControl;
  FCalendarColors := TCalendarColors.Create(Self);
end;

function TPlannerDatePickerColors.GetBackColor: TColor;
begin
  Result := FColorControl.Color;
end;

function TPlannerDatePickerColors.GetFontColor: TColor;
begin
  Result := FColorControl.Font.Color;
end;

procedure TPlannerDatePickerColors.SetBackColor(const Value: TColor);
begin
  FColorControl.Color := Value;
end;

procedure TPlannerDatePickerColors.SetFontColor(const Value: TColor);
begin
  FColorControl.Font.Color := Value;
end;

destructor TPlannerDatePickerColors.Destroy;
begin
  FCalendarColors.Free;
  inherited;
end;

constructor TCalendarColors.Create(AOwner: TPlannerDatePickerColors);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TCalendarColors.GetColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.Color;
end;

function TCalendarColors.GetEventDayColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.EventDayColor;
end;

function TCalendarColors.GetEventMarkerColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.EventMarkerColor;
end;

function TCalendarColors.GetFocusColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.FocusColor;
end;

function TCalendarColors.GetHeaderColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.HeaderColor;
end;

function TCalendarColors.GetInactiveColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.InactiveColor;
end;

function TCalendarColors.GetSelectColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.SelectColor;
end;

function TCalendarColors.GetSelectFontColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.SelectFontColor;
end;

function TCalendarColors.GetTextColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.TextColor;
end;

function TCalendarColors.GetWeekendColor: TColor;
begin
  Result := FOwner.FColorControl.Calendar.WeekendColor;
end;

procedure TCalendarColors.SetColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.Color := Value;
end;

procedure TCalendarColors.SetEventDayColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.EventDayColor := Value;
end;

procedure TCalendarColors.SetEventMarkerColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.EventMarkerColor := Value;
end;

procedure TCalendarColors.SetFocusColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.FocusColor := Value;
end;

procedure TCalendarColors.SetHeaderColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.HeaderColor := Value;
end;

procedure TCalendarColors.SetInactiveColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.InactiveColor := Value;
end;

procedure TCalendarColors.SetSelectColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.SelectColor := Value;
end;

procedure TCalendarColors.SetSelectFontColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.SelectFontColor := Value;
end;

procedure TCalendarColors.SetTextColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.TextColor := Value;
end;

procedure TCalendarColors.SetWeekendColor(const Value: TColor);
begin
  FOwner.FColorControl.Calendar.WeekendColor := Value;
end;

{$ENDIF}



{ TCompleteCheck }

procedure TCompleteCheck.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TCompleteCheck.Create;
begin
  FCompletedGlyph := TBitmap.Create;
  FUnCompletedGlyph := TBitmap.Create;
end;

destructor TCompleteCheck.Destroy;
begin
  FCompletedGlyph.Free;
  FUnCompletedGlyph.Free;
  inherited;
end;

procedure TCompleteCheck.SetCheckType(const Value: TCheckType);
begin
  FCheckType := Value;
  Changed;
end;

procedure TCompleteCheck.SetCompletedGlyph(const Value: TBitmap);
begin
  FCompletedGlyph.Assign(Value);
  Changed;
end;

procedure TCompleteCheck.SetUnCompletedGlyph(const Value: TBitmap);
begin
  FUnCompletedGlyph.Assign(Value);
  Changed;
end;

{ TTodoDateTimePicker }

procedure TTodoDateTimePicker.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Parent.SetFocus;
  inherited;
end;

{ TInplaceMemo }

procedure TInplaceMemo.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  if Msg.CharCode = VK_ESCAPE then
  begin
    Lines.Assign(FOldText);
    DoExit;
  end;
  if Msg.CharCode = VK_TAB then
  begin
    PostMessage(Handle,WM_CHAR,ord(#27),0);
  end;

  inherited;
end;

constructor TInplaceMemo.Create(AOwner: TComponent);
begin
  inherited;
  FTodoList := TTodoListBox(AOwner);
  FOldText := TStringList.Create;
end;

destructor TInplaceMemo.Destroy;
begin
  FOldText.Free;
  inherited;
end;

procedure TInplaceMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_F4 then
    DoExit;
end;

procedure TInplaceMemo.KeyPress(var Key: Char);
begin
  inherited;
  if Key = #27 then
  begin
    DoExit;
    FTodoList.AdvanceEdit;
  end;
end;

procedure TTodoListBox.CMHintShow(var M: TCMHintShow);
var
  ColIdx, ItemIdx: Integer;
  R: TRect;
  Text: String;
  Canvas: TCanvas;
begin
  if not FOwner.HintShowFullText then
  begin
    inherited;
    Exit;
  end;

  // get the item underneath the mouse cursor
  if XYToColItem(M.HintInfo.CursorPos.X, M.HintInfo.CursorPos.Y, ColIdx, ItemIdx, R) and
    (ItemIdx < TodoItems.Count) then
  begin
    // fetch the text that should appear untrimmed in the column
    Text := '';
    with TodoItems.Items[ItemIdx] do
    case TodoColumns.Items[ColIdx].TodoData of
      tdSubject:        Text := Subject;
      tdCompletion:     if not FOwner.CompletionGraphic then Text := IntToStr(Completion);
      tdNotes:          if not FOwner.Preview then Text := Notes.Text;
      tdPriority:       Text := FOwner.PriorityToString(Priority);
      tdDueDate:        Text := FormatDateTime(FDateFormat, DueDate);
      tdStatus:         Text := FOwner.StatusStrings[Status];
      tdTotalTime:      Text := IntToStr(TotalTime) + 'h';
      tdCompletionDate: Text := FormatDateTime(FDateFormat, CompletionDate);
      tdCreationDate:   Text := FormatDateTime(FDateFormat, CreationDate);
      tdResource:       Text := Resource;
      tdProject:        Text := Project;
    end;

    // see if the text fits the column, and if not, show the hint
    if Length(Trim(Text)) > 0 then
    with M.HintInfo^ do
    begin
      Canvas := TCanvas.Create;
      Canvas.Handle := GetDC(0);
      try
        Canvas.Font := TodoColumns.Items[ColIdx].Font;
        if Canvas.TextWidth(Text) > R.Right - R.Left then
        begin
          HintStr := Text;
          R.TopLeft := ClientToScreen(R.TopLeft);
          R.BottomRight := ClientToScreen(R.BottomRight);
          HintPos.Y := R.Top;
          HintPos.X := R.Left;
          CursorRect := R;
          HintMaxWidth := FOwner.ClientWidth;
        end;
      finally
        ReleaseDC(0, Canvas.Handle);
        Canvas.Free;
      end;
    end;
  end;
end;


{ TInplaceSpinEdit }


constructor TInplaceSpinEdit.Create(AOwner: TComponent);
begin
  inherited;
  FTodoList := TTodoListBox(AOwner);
end;

procedure TInplaceSpinEdit.WMChar(var Msg: TWMChar);
begin
  if Msg.CharCode = VK_RETURN then
    Msg.CharCode := 0;

  inherited;
end;

procedure TInplaceSpinEdit.WMKeyDown(var Msg: TWMKeydown);
begin
  if Msg.CharCode = VK_RETURN then
  begin
    DoExit;
    FTodoList.AdvanceEdit;
    Msg.CharCode := 0;
  end;
  inherited;
end;

procedure TTodoListBox.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
end;

end.
