{***************************************************************************}
{ TAdvMemo component                                                        }
{ for Delphi & C++Builder                                                   }
{ version 1.3                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2001 - 2003                                        }
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

{$I TMSDEFS.INC}

unit AdvMemo;              

interface

//{$DEFINE TMSDEBUG}
{$DEFINE BLINK}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Math, Printers;

type
  TBorderType = (btRaised, btLowered, btFlatRaised, btFlatLowered);
  TStyleType = (stKeyword, stBracket, stSymbol);
  TAutoHintParameters = (hpAuto,hpManual,hpNone);
  TAutoHintParameterPosition = (hpBelowCode,hpAboveCode);

  TAllowEvent = procedure (Sender: TObject; var Allow:Boolean) of object; 

  TCommand = Integer;

  TCellSize = record
    W, H: integer;
  end;

  TCellPos = record
    X, Y: integer;
  end;

  TFullPos = record
    LineNo, Pos: integer;
  end;

  TStyle = record
    isComment,
    isBracket,
    isnumber,
    iskeyWord,
    isdelimiter,
    isURL: boolean;
    EndBracket: char;
    index: integer;
  end;

  TAdvAutoform = class(TForm)
  protected
    procedure WMClose(var Msg:TMessage); message WM_CLOSE;
  end;

  TAdvHintform = class(TForm)
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    part1,part2,part3: string;
    Active: Byte;
  end;

  //--------------------------------------------------------------
  TIntList = class(TList)
  private
    procedure SetInteger(Index: Integer; Value: Integer);
    function GetInteger(Index: Integer): Integer;
  public
    constructor Create;
    property Items[index: Integer]: Integer read GetInteger write SetInteger; default;
    procedure Add(Value: integer);
    procedure Delete(Index: Integer);
  published
  end;


  TLineProp = class
  private
    FObject: TObject;
    FErrStart: TIntList;
    FErrLen: TIntList;
  public
    BreakPoint: Boolean;
    Executable: Boolean;
    Style: TStyle;
    CachedStyle: Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  THintParameter= class(TPersistent)
  private
    FTextColor, FBkColor: TColor;
    FStartchar: char;
    FEndchar: char;
    FDelimiterchar: char;
    FParameters: Tstringlist;
    FWritedelimiterchar: char;
    procedure SetParameters(const Value: Tstringlist);
  public
    constructor Create;
    destructor Destroy;override;
  published
    property TextColor: TColor read FTextColor write FTextColor;
    property BkColor: TColor read FBkColor write FBkColor;
    property HintCharStart:char read FStartchar write FStartChar;
    property HintCharEnd:char read FEndchar write FEndChar;
    property HintCharDelimiter:char read FDelimiterChar write FDelimiterChar;
    property HintCharWriteDelimiter:char read FWriteDelimiterChar write FWritedelimiterChar;
    property Parameters: TStringlist read FParameters write SetParameters;
  end;

  //--------------------------------------------------------------
  //        CHAR STYLE LIST
  //--------------------------------------------------------------
  TCharStyle = class(TPersistent)
  private
    FTextColor, FBkColor: TColor;
    FStyle: TFontStyles;
  published
    property TextColor: TColor read FTextColor write FTextColor;
    property BkColor: TColor read FBkColor write FBkColor;
    property Style: TFontStyles read FStyle write FStyle;
  end;

  TPrintOptions = class(TPersistent)
  private
    FJobName: string;
    FTitle: string;
    FPageNr: Boolean;
    FMarginLeft: Integer;
    FMarginRight: Integer;
    FMarginTop: Integer;
    FMarginBottom: Integer;
    FPagePrefix: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property JobName: string read FJobName write FJobName;
    property Title: string read FTitle write FTitle;
    property MarginLeft: integer read FMarginLeft write FMarginLeft;
    property MarginRight: integer read FMarginRight write FMarginRight;
    property MarginTop: integer read FMarginTop write FMarginTop;
    property MarginBottom: Integer read FMarginBottom write FMarginBottom;
    property PageNr: Boolean read FPageNr write FPageNr;
    property PagePrefix: string read FPagePrefix write FPagePrefix;
  end;
  
  //--------------------------------------------------------------
  TAdvCustomMemo = class;
  TAdvCustomMemoStyler = class;

  //--------------------------------------------------------------
  //        TAdvMemoStrings
  //--------------------------------------------------------------
  TAdvMemoStrings = class(TStringList)
  private
    Memo: TAdvCustomMemo;
    FLockCount: Integer;
    FDeleting: Boolean;
    FLinesProp: TList;
    FListLengths: TList;
    function GetRealCount: integer;
  protected
    procedure SetUpdateState(Updating: boolean); override;
    function Get(Index: Integer): string; override;
    procedure Put(Index: Integer; const S: string); override;
    function GetObject(Index: Integer): TObject; override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    function CreateProp(Index: integer): TLineProp;
    procedure ClearLinesProp;
    function GetLineProp(Index: Integer):TLineProp;
    procedure SetLineProp(Index: Integer; const Value:TLineProp);
  public
    constructor Create;
    destructor Destroy; override;
    function DoAdd(const S: string): integer;
    function Add(const S: string): integer; override;
    procedure Clear; override;
    procedure DoInsert(Index: integer; const S: string);
    procedure Assign(Source: TPersistent); override;
    procedure Delete(Index: integer); override;
    procedure Insert(Index: integer; const S: string); override;
    procedure LoadFromFile(const FileName: string); override;
    property RealCount: Integer read GetRealcount;
  published
    property OnChange;
    property OnChanging;
  end;


  //--------------------------------------------------------------
  //        TAdvGutter
  //--------------------------------------------------------------
  TAdvGutter = class
  private
    Memo: TAdvCustomMemo;
    FLeft, FTop, FWidth, FHeight: integer;
    FColor: TColor;
    FColorTo: TColor;
    procedure SetParams(Index: integer; Value: integer);
    function GetRect: TRect;
  protected
    procedure PaintTo(ACanvas: TCanvas);
    procedure Invalidate;
  public
    property Left: integer index 0 read FLeft write SetParams;
    property Top: integer index 1 read FTop write SetParams;
    property Width: integer index 2 read FWidth write SetParams default 45;
    property Height: integer index 3 read FHeight write SetParams;
    property FullRect: TRect read GetRect;
  end;

  //--------------------------------------------------------------
  //        TUNDO
  //--------------------------------------------------------------
  TUndo = class
  private
    Memo: TAdvCustomMemo;
    FUndoCurX0, FUndoCurY0: integer;
    FUndoCurX, FUndoCurY: integer;
    FUndoText: string;
  public
    constructor Create(ACurX0, ACurY0, ACurX, ACurY: integer; AText: string);
    function Append(NewUndo: TUndo): boolean; virtual;
    procedure Undo;
    procedure Redo;
    procedure PerformUndo; virtual; abstract;
    procedure PerformRedo; virtual; abstract;
    property UndoCurX0: integer read FUndoCurX0 write FUndoCurX0;
    property UndoCurY0: integer read FUndoCurY0 write FUndoCurY0;
    property UndoCurX: integer read FUndoCurX write FUndoCurX;
    property UndoCurY: integer read FUndoCurY write FUndoCurY;
  end;

  TInsertCharUndo = class(TUndo)
  public
    function Append(NewUndo: TUndo): boolean; override;
    procedure PerformUndo; override;
    procedure PerformRedo; override;
  end;

  TDeleteCharUndo = class(TUndo)
  private
    FIsBackspace: boolean;
  public
    function Append(NewUndo: TUndo): boolean; override;
    procedure PerformUndo; override;
    procedure PerformRedo; override;
    property IsBackspace: boolean read FIsBackspace write FIsBackspace;
  end;

  TDeleteLineUndo = class(TUndo)
  public
    procedure PerformUndo; override;
    procedure PerformRedo; override;
  end;

  TSelUndo = class(TUndo)
  private
    FUndoSelStartX, FUndoSelStartY,
    FUndoSelEndX, FUndoSelEndY: integer;
  public
    property UndoSelStartX: integer read FUndoSelStartX write FUndoSelStartX;
    property UndoSelStartY: integer read FUndoSelStartY write FUndoSelStartY;
    property UndoSelEndX: integer read FUndoSelEndX write FUndoSelEndX;
    property UndoSelEndY: integer read FUndoSelEndY write FUndoSelEndY;
  end;

  TDeleteBufUndo = class(TSelUndo)
  public
    procedure PerformUndo; override;
    procedure PerformRedo; override;
  end;

  TPasteUndo = class(TUndo)
  public
    procedure PerformUndo; override;
    procedure PerformRedo; override;
  end;

  TAdvUndoList = class(TList)
  private
    FPos: integer;
    FMemo: TAdvCustomMemo;
    FIsPerforming: boolean;
    FLimit: integer;
  protected
    function Get(Index: integer): TUndo;
    procedure SetLimit(Value: integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: Pointer): integer;
    {$IFNDEF DELPHI4_LVL} { Borland Delphi 3.0 }
    procedure Clear;
    {$ELSE}
    procedure Clear; override;
    {$ENDIF}
    procedure Delete(Index: integer);
    procedure Undo;
    procedure Redo;
    property Items[Index: integer]: TUndo read Get; default;
    property IsPerforming: boolean read FIsPerforming write FIsPerforming;
    property Memo: TAdvCustomMemo read FMemo write FMemo;
    property Pos: integer read FPos write FPos;
    property Limit: integer read FLimit write SetLimit;
  end;

  //--------------------------------------------------------------
  TGutterClickEvent = procedure(Sender: TObject; LineNo: integer) of object;
  TGutterDrawEvent = procedure(Sender: TObject; ACanvas: TCanvas;
    LineNo: integer; rct: TRect) of object;

  TUndoChangeEvent = procedure(Sender: TObject; CanUndo, CanRedo: boolean) of object;
  TURLClick = procedure(Sender: TObject; URL: string) of object;
  TScrollMode = (smAuto, smStrict);

  TDrawMode = (dmScreen, dmHTML, dmPrinter);

  //--------------------------------------------------------------
  //        TAdvCustomMemo - declaration
  //--------------------------------------------------------------
  TAdvCustomMemo = class(TCustomControl)
  private
    FInternalStyles: TAdvCustomMemoStyler;
    FCaseSensitive: boolean;
    FBorderStyle: TBorderStyle;
    FAutoIndent: boolean;
    FMargin: integer;
    FHiddenCaret, FCaretVisible: boolean;
    FCellSize: TCellSize;
    FCurX, FCurY: integer;
    FbackupTopLine,
    FLeftCol, FTopLine: integer;
    FTabSize: integer;
    FFont: TFont;
    FBkColor: TColor;
    FSelColor: TColor;
    FSelBkColor: TColor;
    FReadOnly: boolean;
    FDelErase: boolean;
    FLines: TAdvMemoStrings;
    FSelStartX, FSelStartY,
    FSelEndX, FSelEndY,
    FPrevSelX, FPrevSelY: integer;
    FScrollBars: TScrollStyle;
    FGutter: TAdvGutter;
    FGutterWidth: integer;
    sbVert, sbHorz: TScrollBar;
    FLineBitmap: TBitmap;
    FSelCharPos: TFullPos;
    FLeftButtonDown: boolean;
    FScrollMode: TScrollMode;
    FUndoList: TAdvUndoList;
    FUndoLimit: integer;
    FBackupTopStyle:Tstyle;
    FTempdelimiters: string;
    FUrlDelimiters: string;
    Timer: TTimer;
    FHintForm: TAdvHintform;
    FAutoHintParameters: TAutoHintParameters;
    FUrlStyle: TCharStyle;
    FUrlAware: Boolean;
    FActiveLine: Integer;
    FCtl3D: boolean;
    FOldCursor: TCursor;
    Html: TStringList;
    Htmlfont: string;
    FMaxLength: Integer;
    FLetShowAutoCompletion: Boolean;
    FSearching: Boolean;
    FHintShowing: Boolean;
    FListcompletion: TListBox;
    FormAutoCompletion: TAdvAutoform;
    FAutoCompletionWidth: Integer;
    FAutoCompletionHeight: Integer;
    FAutoCompletion: boolean;
    { Events }
    FOnChange: TNotifyEvent;
    FOnStatusChange: TNotifyEvent;
    FOnSelectionChange: TNotifyEvent;
    FOnGutterDraw: TGutterDrawEvent;
    FOnGutterClick: TGutterClickEvent;
    FOnUndoChange: TUndoChangeEvent;
    FOnURLClick: TurlClick;
    FOnReplace: TNotifyEvent;
    FOnFind: TNotifyEvent;
    FOnAutoCompletion: TNotifyEvent;
    FOnCanceltAutoCompletion: TNotifyEvent;
    FOnStartAutoCompletion: TNotifyEvent;
    FPrintOptions: TPrintOptions;
    FAutoHintParameterPos: TAutoHintParameterPosition;
    FtmpNoStart,FtmpNo,FtmpNoHex:String;
    FCaretTime:cardinal;
    FletgetCaretTime: Boolean;
    FCaretX,FCaretY: Cardinal;
    FLineNumbers: Boolean;
    BSelLine, BSelStart, BSelLen: Integer;
    BOldSelLine: Integer;
    FOnCursorChange: TNotifyEvent;
    FBlockShow: Boolean;
    FBlockLineColor: TColor;
    FOverwrite: Boolean;
    FOnOverwriteToggle: TAllowEvent;
    procedure showform;
    procedure hideform;
    procedure PrepareShowHint;
    function SearchParameter: Boolean;
    procedure FormHintMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Hideauto(Sender:Tobject);
    procedure ListKeyDown(Sender:Tobject;var Key: word; Shift: TShiftState);
    procedure FormHintClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerHint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetHiddenCaret(Value: boolean);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetGutterWidth(Value: integer);
    procedure SetGutterColor(Value: TColor);
    function GetGutterColor: TColor;
    procedure SetCaseSensitive(Value: boolean);
    procedure SetCurX(Value: integer);
    procedure SetCurY(Value: integer);
    procedure SetFont(Value: TFont);
    procedure SetColor(Index: integer; Value: TColor);
    procedure SetLines(ALines: TAdvMemoStrings);
    procedure ExpandSelection;
    function GetSelText: string;
    procedure SetSelText(const AValue: string);
    function GetSelLength: integer;
    procedure MovePage(dP: integer; Shift: TShiftState);
    procedure ShowCaret(State: boolean);
    procedure MakeVisible;
    function GetVisible(Index: integer): Integer;
    procedure SetMaxLength;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMEraseBkgnd(var Msg: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
    procedure MoveCursor(dX, dY: integer; Shift: TShiftState);
    procedure ResizeEditor;
    procedure ResizeScrollBars;
    procedure ResizeGutter;
    procedure DoCommand(cmd: TCommand; const AShift: TShiftState);
    procedure DrawLine(ACanvas: TCanvas;LineNo: integer; var Style: TStyle;DM: TDrawMode; PR: TRect);
    procedure DrawHTML(Part: string; var Drawstyle: Tstyle;lineno:integer);
    procedure ExtractURL(s: string; var urls: TStringList);
    procedure FreshLineBitmap;
    procedure SetUndoLimit(Value: integer);
    function GetSelStart: Integer;
    procedure SetSelStart(const Value: integer);
    procedure SetSelLength(const Value: integer);
    procedure SetActiveLine(const Value: integer);
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetCtl3D(const Value: boolean);
    procedure UpdateGutter;
    procedure SetLeftCol(const Value: integer);
    procedure SetTopLine(const Value: integer);
    procedure SetMemoStyler(Value: TAdvCustomMemoStyler);
    function GetUpStyle(stopat: Integer): TStyle;
    procedure SetUrlAware(const Value: boolean);
    procedure SetUrlStyle(const Value: TCharStyle);
    procedure ScrollVChange(Sender: TObject);
    procedure ScrollHChange(Sender: TObject);
    function GetBreakPoint(Index: Integer): Boolean;
    procedure SetBreakPoint(Index: Integer; const Value: Boolean);
    function GetExecutable(Index: Integer): Boolean;
    procedure SetExecutable(Index: Integer; const Value: Boolean);
    procedure SetLineStyle(Index: Integer; const LineStyle: TStyle);
    procedure ClearLineStyles;
    function GetLineStyle(Index: Integer; var LineStyle: TStyle): Boolean;
    procedure SwapColors;
    procedure SetEventAutoCompletion;
    procedure KilleventAutoCompletion;
    procedure SetAutoHintParameters(const Value: TAutoHintParameters);
    procedure SetPrintOptions(const Value: TPrintOptions);
    procedure SetGutterColorTo(const Value: TColor);
    procedure SetLineNumbers(const Value: Boolean);
    function GetGutterColorTo: TColor;
  protected
    FLetRefresh: boolean;
    {$IFDEF DELPHI5_LVL}
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
    {$ENDIF}
    function EditorRect: TRect;
    function CellFromPos(X, Y: integer): TCellPos;
    function CellRect(ACol, ARow: integer): TRect;
    function LineRect(ARow: integer): TRect;
    function LineRangeRect(FromLine, ToLine: integer): TRect;
    function ColRect(ACol: integer): TRect;
    function ColRangeRect(FromCol, ToCol: integer): TRect;
    function AddString(S: string): integer;
    procedure InsertString(Index: integer; S: string);
    procedure GoHome(Shift: TShiftState);
    procedure GoEnd(Shift: TShiftState);
    procedure InsertChar(C: char);
    procedure DeleteChar(OldX, OldY: integer);
    procedure DeleteLine;
    procedure BackSpace;
    procedure BackWord;
    function  IndentCurrLine: string;
    procedure TestforURLClick(s: string);
    function  TestforURLMove(s: string; locx: integer): boolean;
    procedure SetBlockMatch(LineNo, BlockStart, BlockLen: Integer);
    procedure NewLine;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DrawMargin;
    procedure DrawGutter;
    procedure ScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: integer);
    procedure KeyDown(var Key: word; Shift: TShiftState); override;
    procedure KeyPress(var Key: char); override;
    procedure KeyUp(var Key: word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure DoScroll(Sender: TScrollBar; ByValue: integer);
    procedure DoScrollPage(Sender: TScrollBar; ByValue: integer);
    property MaxLength:integer read FmaxLength;
    property VisiblePosCount: Integer index 0 read GetVisible;
    property VisibleLineCount: Integer index 1 read GetVisible;
    property LastVisiblePos: Integer index 2 read GetVisible;
    property LastVisibleLine: Integer index 3 read GetVisible;
    procedure DeleteSelection(bRepaint: boolean);
    procedure LinesChanged(Sender: TObject);
    procedure SelectionChanged; virtual;
    procedure StatusChanged; virtual;
    procedure FontChanged(Sender: TObject);
    function IsWordBoundary(ch: char): boolean; virtual;
    procedure ClearUndoList;
    procedure UndoChange;
    function GetCursorEx: TCursor;
    procedure CursorChanged; virtual;
    procedure SetCursorEx(const Value: TCursor);
    function EditCanModify: Boolean; virtual;
    procedure InsertTemplate(AText: string);
    procedure OutputHTML(FixedFonts: Boolean);
    procedure DoFind;
    procedure DoReplace;
    property AutoIndent: Boolean read FAutoIndent write FAutoIndent;
    property BlockShow: Boolean read FBlockShow write FBlockShow;
    property BlockLineColor: TColor read FBlockLineColor write FBlockLineColor;
    property GutterWidth: Integer read FGutterWidth write SetGutterWidth default 45;
    property GutterColor: TColor read GetGutterColor write SetGutterColor;
    property GutterColorTo: TColor read GetGutterColorTo write SetGutterColorTo;    
    property LineNumbers: Boolean read FLineNumbers write SetLineNumbers;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssBoth;
    property Font: TFont read FFont write SetFont;
    property ReadOnly: boolean read FReadOnly write FReadOnly;
    property Lines: TAdvMemoStrings read FLines write SetLines;
    property BkColor: TColor index 0 read FBkColor write SetColor;
    property SelColor: TColor index 1 read FSelColor write SetColor;
    property SelBkColor: TColor index 2 read FSelBkColor write SetColor;
    property HiddenCaret: boolean read FHiddenCaret write SetHiddenCaret;
    property TabSize: integer read FTabSize write FTabSize;
    property Searching: Boolean read FSearching write FSearching;
    property ScrollMode: TScrollMode read FScrollMode write FScrollMode default smAuto;
    property UndoLimit: Integer read FUndoLimit write SetUndoLimit;
    property UrlStyle: TCharStyle read FUrlStyle write SetUrlStyle;
    property AutoCompletionHeight: Integer read FAutoCompletionHeight write FAutoCompletionHeight default 100;
    property AutoCompletionWidth: Integer read FAutoCompletionWidth write FAutoCompletionWidth default 200;
    property AutoCompletion: Boolean read FAutoCompletion write FAutoCompletion default true;
    property AutoHintParameters: TAutoHintParameters read FAutoHintParameters write SetAutoHintParameters default hpAuto;
    property AutoHintParameterPosition: TAutoHintParameterPosition read FAutoHintParameterPos write FAutoHintParameterPos;    
    { Events }
    property OnStartAutoCompletion:TNotifyEvent read FOnStartAutoCompletion write FOnStartAutoCompletion;
    property OnAutoCompletion:TNotifyEvent read FOnAutoCompletion write FOnAutoCompletion;
    property OnCanceltAutoCompletion:TNotifyEvent read FOnCanceltAutoCompletion write FOnCanceltAutoCompletion;
    property OnGutterClick: TGutterClickEvent read FOnGutterClick write FOnGutterClick;
    property OnGutterDraw: TGutterDrawEvent read FOnGutterDraw write FOnGutterDraw;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnSelectionChange: TNotifyEvent read FOnSelectionChange write FOnSelectionChange;
    property OnStatusChange: TNotifyEvent read FOnStatusChange write FOnStatusChange;
    property OnUndoChange: TUndoChangeEvent read FOnUndoChange write FOnUndoChange;
    property OnFind: TNotifyEvent read FOnFind write FOnFind;
    property OnReplace: TNotifyEvent read FOnReplace write FOnReplace;
    property OnCursorChange: TNotifyEvent read FOnCursorChange write FOnCursorChange;
    property OnOverwriteToggle: TAllowEvent read FOnOverwriteToggle write FOnOverwriteToggle;
    property OnURLClick: TurlClick read FOnURLClick write FOnURLClick;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CopyToClipBoard;
    procedure PasteFromClipBoard;
    procedure CutToClipBoard;
    procedure SelectAll;
    procedure ClearBreakpoints;
    procedure ClearExecutableLines;
    procedure SetError(LineNo,ErrPos,ErrLen: Integer);
    procedure ClearErrors;
    procedure ClearLineErrors(LineNo: Integer);
    function CharFromPos(X, Y: integer): TFullPos;
    procedure PosFromText(TextPos: integer; var X, Y: Integer);
    procedure TextFromPos(X,Y: Integer; var TextPos: Integer);
    procedure InsertText(AValue: string);
    procedure InsertTextAtXY(AValue: string;X,Y: Integer);
    procedure DeleteTextAtXY(X,Y,NumChar: Integer);
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
    property Ctl3D: boolean read FCtl3D write SetCtl3D;
    property SyntaxStyles: TAdvCustomMemoStyler read FInternalStyles write SetMemoStyler;
    property Selection: string read GetSelText write SetSelText;
    property SelStart: integer read GetSelStart write SetSelStart;
    property SelLength: integer read GetSelLength write SetSelLength;
    function WordAtCursor: string;
    function WordAtCursorPos(var Pos: Integer): string;
    property CaseSensitive: boolean read FCaseSensitive write SetCaseSensitive default False;
    procedure ClearSelection;
    function FindText(SearchStr: string; Options: TFindOptions): Integer;
    function FindTextPos(SearchStr: string; Options: TFindOptions): Integer;
    procedure Clear;
    procedure SetCursor(ACurX, ACurY: integer);
    procedure Undo;
    procedure Redo;
    procedure HideHint;
    function CanUndo: boolean;
    function CanRedo: boolean;
    property ActiveLine: integer read FActiveLine write SetActiveLine;
    property BreakPoint[Index: Integer]: Boolean read GetBreakPoint write SetBreakPoint;
    property Executable[Index: Integer]: Boolean read GetExecutable write SetExecutable;
    property Overwrite: Boolean read FOverwrite write FOverwrite;
    property CurX: integer read FCurX write SetCurX;
    property CurY: integer read FCurY write SetCurY;
    property DelErase: boolean read FDelErase write FDelErase;
    property TopLine: integer read FTopLine write SetTopLine;
    property LeftCol: integer read FLeftCol write SetLeftCol;
    property UrlAware: boolean read FUrlAware write SetUrlAware default True;
    property PrintOptions: TPrintOptions read FPrintOptions write SetPrintOptions;
    function SaveToHTML(FileName: string; Fixedfonts:Boolean = True): Boolean;
    procedure CopyHTMLToClipboard;
    procedure Print;
  published
    property Cursor: TCursor read GetCursorEx write SetCursorEx;  
  end;

  //---------------------------------------------------------
  //--------------------- TAdvStringList---------------------
  TAdvStringList = class(TStringList)
  private
    procedure ReadStrings(Reader: TReader);
    procedure WriteStrings(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
  end;

  TElementStyles = class;
  TAdvMemo = class;

  TAdvCustomMemoStyler = class(TComponent)
  private
    FAllStyles: TElementStyles;
    FLineComment: string;
    FMultiCommentLeft: string;
    FMultiCommentRight: string;
    FCommentStyle: TCharStyle;
    FNumberStyle: TCharStyle;
    FlistAuto: Tstringlist;
    FHintParameter: THintParameter;
    FNumericChars: string;
    FHexIdentifier: string;
    FBlockEnd: string;
    FBlockStart: string;
    procedure SetStyle(const Index: integer; const Value: TCharStyle); virtual;
    procedure SetStyles(const Value: TElementStyles);
    procedure Update;
    procedure SetlistAuto(const Value: Tstringlist);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property BlockStart: string read FBlockStart write FBlockStart;
    property BlockEnd: string read FBlockEnd write FBlockEnd;
    property LineComment: string read FLineComment write FLineComment;
    property MultiCommentLeft: string read FMultiCommentLeft write FMultiCommentLeft;
    property MultiCommentRight: string read FMultiCommentRight write FMultiCommentRight;
    property AllStyles: TElementStyles read FAllStyles write SetStyles;
    property CommentStyle: TCharStyle index 1 read FCommentStyle write SetStyle;
    property NumberStyle: TCharStyle index 2 read FNumberStyle write SetStyle;
    property AutoCompletion: TStringlist read FlistAuto write SetlistAuto;
    property HintParameter: THintParameter read fHintParameter write fhintparameter;
    property NumericChars: string Read FNumericChars write FNumericChars;
    property HexIdentifier: string Read FHexIdentifier write FHexIdentifier;
  end;

  //--------------------------------------------------------------
  //         TAdvMemo (SYNTAX MEMO) - declaration
  //--------------------------------------------------------------
  TAdvMemo = class(TAdvCustomMemo)
  private
    { Private declarations }
    FInComment: boolean;
    FInBrackets: integer;
    procedure AdvSyntaxMemoChange(Sender: TObject);
    procedure AdvSyntaxMemoGutterDraw(Sender: TObject; ACanvas: TCanvas;
      LineNo: integer; rct: TRect);
    procedure AdvSyntaxMemoGutterClick(Sender: TObject; LineNo: integer);
    procedure LoadStyle;
  protected
    { Protected declarations }
    procedure Loaded; override;
    function IsWordBoundary(ch: char): boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshMemo;
  published
    {TControl}
    property PopupMenu;
    {TCustomControl}
    property Align;
    property Anchors;
    property AutoCompletionHeight;
    property AutoCompletionWidth;
    property AutoCompletion;
    property AutoHintParameters;
    property AutoHintParameterPosition;    
    property AutoIndent;
    property BlockShow;
    property BlockLineColor;    
    property BkColor default clWhite;
    property BorderStyle;
    property CaseSensitive;
    property Ctl3D;
    property Cursor;
    property DelErase;
    property Enabled;
    property GutterColor default clActiveBorder;
    property GutterColorTo default clNone;
    property GutterWidth;
    property Font;
    property LineNumbers;
    property Lines;
    property HiddenCaret;
    property PrintOptions;
    property ReadOnly default False;
    property ScrollBars;
    property ScrollMode;
    property SelColor;
    property SelBkColor;
    property ShowHint;
    property SyntaxStyles;
    property TabOrder;
    property TabSize;
    property TabStop;
    property UndoLimit;    
    property UrlAware;
    property UrlStyle;
    property Visible;
    property OnAutoCompletion;
    property OnCanceltAutoCompletion;
    property OnCursorChange;
    property OnEnter;
    property OnExit;
    property OnClick;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyUp;
    property OnKeyPress;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnDragOver;
    property OnDragDrop;
    property OnEndDock;
    property OnEndDrag;
    property OnStartDock;
    property OnStartDrag;
    property OnGutterClick;
    property OnGutterDraw;
    property OnChange;
    property OnOverwriteToggle;
    property OnSelectionChange;
    property OnStartAutoCompletion;    
    property OnStatusChange;
    property OnUndoChange;
    property OnURLClick;
    property OnFind;
    property OnReplace;
  end;

  TElementStyle = class(TCollectionItem)
  private
    FKeyWords: TStrings;
    FFont: Tfont;
    FBGColor: Tcolor;
    FInfo: string;
    FStyleType: TStyleType;
    StyleNo: integer;
    FBracket: Char;
    FSymbols: string;
    procedure SetColorbg(const Value: Tcolor);
    procedure SetFont(const Value: Tfont);
    procedure SetKeyWords(const Value: TStrings);
    procedure SetStyleType(const Value: TStyleType);
    procedure SetBracket(const Value: Char);
    procedure SetSymbols(const Value: string);
  protected
    function GetDisplayName: string; override;
  public
    procedure Changed;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property KeyWords: TStrings read FKeyWords write SetKeyWords;
    property Font: TFont read FFont write SetFont;
    property BGColor: TColor read FBGColor write SetColorbg;
    property StyleType: TStyleType read FStyleType write SetStyleType;
    property Bracket: Char read FBracket write SetBracket;
    property Symbols: string read FSymbols write SetSymbols;
    property Info: string read Finfo write Finfo;
  end;

  TElementStyles = class(TOwnedCollection)
  private
    FOwner: TAdvmemo;
    FModified: boolean;
    function GetItem(Index: integer): TElementStyle;
    procedure SetItem(Index: integer; const Value: TElementStyle);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function CreateItemClass: TCollectionItemClass; virtual;
    constructor Create(AOwner: TComponent);
    function Add: TElementStyle;
    function Insert(Index: integer): TElementStyle;
    property Items[Index: integer]: TElementStyle read GetItem write SetItem; default;
    function IsWordBoundary(ch: char): boolean;
  published
  end;
  
  TAdvMemoFindDialog = class(TComponent)
  private
    FDisplayMessage: boolean;
    FNotFoundMessage: string;
    FFindText: string;
    FAdvMemo: TAdvcustomMemo;
    FindDialog: TFinddialog;
  protected
    procedure Find(Sender: TObject);
    procedure Close(Sender: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    procedure Execute;
  published
    property NotFoundMessage: string read FNotFoundMessage write FNotFoundMessage;
    property DisplayMessage: boolean read FDisplayMessage write FDisplayMessage default True;
    property FindText: string read FFindText write FFindText;
    property AdvMemo: TAdvcustomMemo read FAdvMemo write FAdvMemo;
  end;
  
  TAdvMemoFindReplaceDialog = class(TComponent)
  private
    FDisplayMessage: boolean;
    FNotFoundMessage: string;
    FFindText: string;
    FAdvMemo: TAdvcustomMemo;
    ReplaceDialog: TReplacedialog;
    FReplaceText: string;
  protected
    procedure Find(Sender: TObject);
    procedure Close(Sender: TObject);    
    procedure Replace(Sender: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    procedure Execute;
  published
    property NotFoundMessage: string read FNotFoundMessage write FNotFoundMessage;
    property DisplayMessage: boolean read FDisplayMessage write FDisplayMessage default True;
    property FindText: string read FFindText write FFindText;
    property ReplaceText: string read FReplaceText write FReplaceText;
    property AdvMemo: TAdvcustomMemo read FAdvMemo write FAdvMemo;
  end;


procedure Border(Canvas: TCanvas; rct: TRect; BorderType: TBorderType);
function ansiRPos(Substr, str: string): integer;

implementation

uses
  ClipBrd;

const
  cmDelete = VK_DELETE;
  cmBackSpace = VK_BACK;
  cmNewLine = VK_RETURN;
  cmHome = VK_HOME;
  cmEnd = VK_END;
  cmPageUp = VK_PRIOR;
  cmPageDown = VK_NEXT;
  cmInsert = VK_INSERT;
  cmDelLine = 25; // Ctrl-Y
  cmSelectAll = 1;//Ctrl+A
  cmCopy = 3;  // Ctrl-C
  cmCut = 24; // Ctrl-X
  cmPaste = 22; // Ctrl-V

procedure DrawError(Canvas: TCanvas; cr: TRect);
var
  l,o: Integer;
begin
  Canvas.Pen.Color := clRed;
  Canvas.Pen.Width := 1;
  l := (cr.Left div 2) * 2;
  if (l mod 4)=0 then o := 2 else o := 0;

  Canvas.MoveTo(l,cr.Bottom + o - 1);
  while l < cr.Right do
  begin
    if o = 2 then o := 0 else o := 2;
    Canvas.LineTo(l + 2,cr.bottom + o - 1);
    Inc(l,2);
  end;
end;

procedure DrawGradient(Canvas: TCanvas; FromColor,ToColor: TColor; Steps: Integer;R:TRect; Direction: Boolean);
var
  diffr,startr,endr: Integer;
  diffg,startg,endg: Integer;
  diffb,startb,endb: Integer;
  iend: Integer;
  rstepr,rstepg,rstepb,rstepw: Real;
  i,stepw: Word;

begin
  if Steps = 0 then
    Steps := 1;

  FromColor := ColorToRGB(FromColor);
  ToColor := ColorToRGB(ToColor);  

  startr := (FromColor and $0000FF);
  startg := (FromColor and $00FF00) shr 8;
  startb := (FromColor and $FF0000) shr 16;
  endr := (ToColor and $0000FF);
  endg := (ToColor and $00FF00) shr 8;
  endb := (ToColor and $FF0000) shr 16;

  diffr := endr - startr;
  diffg := endg - startg;
  diffb := endb - startb;

  rstepr := diffr / steps;
  rstepg := diffg / steps;
  rstepb := diffb / steps;

  if Direction then
    rstepw := (R.Right - R.Left) / Steps
  else
    rstepw := (R.Bottom - R.Top) / Steps;

  with Canvas do
  begin
    for i := 0 to Steps - 1 do
    begin
      endr := startr + Round(rstepr*i);
      endg := startg + Round(rstepg*i);
      endb := startb + Round(rstepb*i);
      stepw := Round(i*rstepw);
      Pen.Color := endr + (endg shl 8) + (endb shl 16);
      Brush.Color := Pen.Color;
      if Direction then
      begin
        iend := R.Left + stepw + Trunc(rstepw) + 1;
        if iend > R.Right then
          iend := R.Right;
        Rectangle(R.Left + stepw,R.Top,iend,R.Bottom)
      end
      else
      begin
        iend := R.Top + stepw + Trunc(rstepw)+1;
        if iend > r.Bottom then
          iend := r.Bottom;
        Rectangle(R.Left,R.Top + stepw,R.Right,iend);
      end;  
    end;
  end;
end;


//--------------------------------------------------------------
//        POINT IN RECT
//--------------------------------------------------------------
function PointInRect(P: TPoint; rct: TRect): boolean;
begin
  with rct do
    Result := (Left <= P.X) and (Top <= P.Y) and
      (Right >= P.X) and (Bottom >= P.Y);
end;

//--------------------------------------------------------------
//        SWAP
//--------------------------------------------------------------
procedure Swap(var I1, I2: integer);
var 
  temp: integer;
begin
  temp := I1;
  I1 := I2;
  I2 := temp;
end;

//--------------------------------------------------------------
//        ORDER POS
//--------------------------------------------------------------
procedure OrderPos(var StartX, StartY, EndX, EndY: integer);
begin
  if (EndY < StartY) or
    ((EndY = StartY) and (EndX < StartX)) then
  begin
    Swap(StartX, EndX);
    Swap(StartY, EndY);
  end;
end;

//--------------------------------------------------------------
//        TOTAL RECT
//--------------------------------------------------------------
function TotalRect(rct1, rct2: TRect): TRect;
begin
  Result := rct1;
  with Result do 
  begin
    if rct2.Left < Left then Left := rct2.Left;
    if rct2.Top < Top then Top := rct2.Top;
    if rct2.Right > Right then Right := rct2.Right;
    if rct2.Bottom > Bottom then Bottom := rct2.Bottom;
  end;
end;

//--------------------------------------------------------------
//        SET CURSOR
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetCursor(ACurX, ACurY: integer);
begin
  ClearSelection;
  CurX := 0;
  CurY := ACurY;
  CurX := ACurX;
end;


//--------------------------------------------------------------
//        CLEAR
//--------------------------------------------------------------
procedure TAdvCustomMemo.Clear;
begin
  CurX := 0;
  CurY := 0;
  FLeftCol := 0;
  FTopLine := 0;
  Fletrefresh := False;
  Lines.Clear;
  Invalidate;
  CurY := 0;
  CurX := 0;
  FSelStartX := 0;
  FSelStartY := 0;  

  Fletrefresh := True;
  LinesChanged(nil);
  ClearLineStyles;
end;

//--------------------------------------------------------------
//        SELECT ALL
//--------------------------------------------------------------
procedure TAdvCustomMemo.SelectAll;
begin
  FSelStartY := 0;
  FSelStartX := 0;
  FSelEndY := Lines.Count - 1;
  FSelEndX := Length(Lines[Lines.Count - 1]);
  Invalidate;
  if Assigned(OnSelectionChange) then
    OnSelectionChange(Self);
end;
//--------------------------------------------------------------
//        COPY TO CLIPBOARD
//--------------------------------------------------------------

procedure TAdvCustomMemo.CopyToClipBoard;
begin
  ClipBoard.SetTextBuf(PChar(GetSelText));
end;
//--------------------------------------------------------------
//        PASTE FROM CLIPBOARD
//--------------------------------------------------------------

procedure TAdvCustomMemo.PasteFromClipBoard;
var 
  H, len: integer;
  Buff: string;
begin
  if FReadOnly or not EditCanModify then
    Exit;

  H := ClipBoard.GetAsHandle(CF_TEXT);
  len := GlobalSize(H);
  if len = 0 then Exit;
  SetLength(Buff, len);
  SetLength(Buff, ClipBoard.GetTextBuf(PChar(Buff), len));
  AdjustLineBreaks(Buff);
  SetSelText(Buff);
  Invalidate;
end;

//--------------------------------------------------------------
//        DELETE SELECTION
//--------------------------------------------------------------
procedure TAdvCustomMemo.DeleteSelection(bRepaint: boolean);
var
  xSelStartX, xSelStartY, xSelEndX, xSelEndY: integer;
  i: integer;
  OldX, OldY: integer;
  S1, S2, S: string;
  Undo: TDeleteBufUndo;
begin
  if not EditCanModify then
    Exit;

  if (FSelStartY = FSelEndY) and (FSelStartX = FSelEndX) then
    Exit;
  if (max(FSelStartY, FSelEndY) >= Lines.Count) or (min(FSelStartY, FSelEndY) < 0) or
    (Lines.Count = 0) then
  begin
    FSelStartY := 0;
    FSelEndY := 0;
    FSelStartX := 0;
    FSelEndX := 0;
    Exit;
  end;

  OldX := CurX;
  OldY := CurY;
  xSelStartX := FSelStartX;
  xSelStartY := FSelStartY;
  xSelEndX := FSelEndX;
  xSelEndY := FSelEndY;

  OrderPos(xSelStartX, xSelStartY, xSelEndX, xSelEndY);

  if xSelStartY = xSelEndY then
  begin
    S1 := Copy(Lines[xSelStartY], xSelStartX + 1, xSelEndX - xSelStartX);
    S2 := '';
  end
  else
  begin
    S1 := Copy(Lines[xSelStartY], xSelStartX + 1, Length(Lines[xSelStartY]));
    S2 := Copy(Lines[xSelEndY], 1, xSelEndX);
  end;
  Fletrefresh := False;
  Lines[xSelStartY] := Copy(Lines[xSelStartY], 1, xSelStartX) +
    Copy(Lines[xSelEndY], xSelEndX + 1, Length(Lines[xSelEndY]));

  CurY := xSelStartY;
  CurX := xSelStartX;

  ClearSelection;

  S := S1 + S;
  for i := xSelStartY + 1 to xSelEndY do
  begin
    S := S + #13#10;
    if i <> xSelEndY then
      S := S + Lines[xSelStartY + 1];
    Lines.Delete(xSelStartY + 1);
  end;
  S := S + S2;

  SelectionChanged;
  if bRepaint then
    Invalidate;
  Fletrefresh := True;
  LinesChanged(nil);
  Undo := TDeleteBufUndo.Create(OldX, OldY, CurX, CurY, S);
  Undo.UndoSelStartX := xSelStartX;
  Undo.UndoSelStartY := xSelStartY;
  Undo.UndoSelEndX := xSelEndX;
  Undo.UndoSelEndY := xSelEndY;
  FUndoList.Add(Undo);
end;

//--------------------------------------------------------------
//        CUT TO CLIPBOARD
//--------------------------------------------------------------
procedure TAdvCustomMemo.CutToClipBoard;
begin
  if FReadOnly or not EditCanModify then
    Exit;

  ClipBoard.SetTextBuf(PChar(GetSelText));
  DeleteSelection(True);
end;

procedure TAdvCustomMemo.TextFromPos(X,Y: Integer; var TextPos: integer);
var
  i,l: Integer;
begin
  l := 0;

  for i := 0 to Y - 1 do
  begin
    if i < Lines.Count then
      l := l + Length(Lines[i]) + 2;
  end;
  if Y < Lines.Count then
  begin
    if X < Length(Lines[Y]) then
      l := l + X
    else
      l := l + Length(Lines[Y]);
  end;

  TextPos := l;
end;

procedure TAdvCustomMemo.PosFromText(TextPos: integer; var X, Y: integer);
var
  i, j, l: integer;
begin
  X := 0;
  Y := 0;

  j := 0;
  i := 0;

  l := TextPos;

  while (j <= TextPos) and (i < Lines.Count) do
  begin
    j := j + Length(Lines[i]) + 2;

    if (TextPos < j) then
    begin
      X := l;
      Y := i;
      Break;
    end;
    l := l - (Length(Lines[i]) + 2);
    inc(i);
  end;
end;

procedure TAdvCustomMemo.InsertText(AValue: string);
begin
  SetSelText(Avalue);
end;

procedure TAdvCustomMemo.InsertTextAtXY(AValue: string;X,Y: Integer);
var
  s:string;
begin
  s := Lines[y];
  Insert(AValue,s,X + 1);
  Lines[y] := s;
end;

procedure TAdvCustomMemo.DeleteTextAtXY(X,Y,NumChar: Integer);
var
  s: string;
begin
  s := Lines[y];
  Delete(s,X + 1,NumChar);
  Lines[y] := s;
end;


function TAdvCustomMemo.GetSelStart: Integer;
var
  i: integer;
  xSelStartX, xSelStartY, xSelEndX, xSelEndY: integer;
begin
  Result := 0;

  if (FSelStartY = FSelEndY) and (FSelStartX = FSelEndX) then

  begin
    for i := 1 to FSelStartY do
    begin
      Result := Result + Length(Lines[i - 1]) + 2;
    end;

    Result := Result + FSelStartX;

    Exit;
  end;

  xSelStartX := FSelStartX;
  xSelStartY := FSelStartY;
  xSelEndX := FSelEndX;
  xSelEndY := FSelEndY;

  OrderPos(xSelStartX, xSelStartY, xSelEndX, xSelEndY);

  for i := 1 to xSelStartY do
  begin
    Result := Result + Length(Lines[i - 1]) + 2;
  end;

  Result := Result + xSelStartX;
end;


procedure TAdvCustomMemo.SetSelStart(const Value: integer);
var
  len: integer;
begin
  len := GetSelLength;
  PosFromText(Value, FSelStartX, FSelStartY);

  {$IFDEF TMSDEBUG}
  outputdebugstring(PChar(IntToStr(FSelStartX) + ':' + IntToStr(FSelStartY)));
  outputdebugstring(PChar('len=' + IntToStr(len)));
  {$ENDIF}

  PosFromText(Value + len, FSelEndX, FSelEndY);

  {$IFDEF TMSDEBUG}
  outputdebugstring(PChar(IntToStr(FSelEndX) + ':' + IntToStr(FSelEndY)));
  {$ENDIF}
  Invalidate;
end;

procedure TAdvCustomMemo.SetSelLength(const Value: integer);
begin
  {$IFDEF TMSDEBUG}
  outputdebugstring(PChar(IntToStr(FSelStartX) + ':' + IntToStr(FSelStartY)));
  {$ENDIF}
  PosFromText(SelStart + Value, FSelEndX, FSelEndY);
  Invalidate;
end;



//--------------------------------------------------------------
//        GET SEL TEXT
//--------------------------------------------------------------
function TAdvCustomMemo.GetSelText: string;
var
  i: integer;
  xSelStartX, xSelStartY, xSelEndX, xSelEndY: integer;
begin
  Result := '';
  if (FSelStartY = FSelEndY) and (FSelStartX = FSelEndX) then
    Exit;

  xSelStartX := FSelStartX;
  xSelStartY := FSelStartY;
  xSelEndX := FSelEndX;
  xSelEndY := FSelEndY;
  
  OrderPos(xSelStartX, xSelStartY, xSelEndX, xSelEndY);

  if xSelStartY = xSelEndY then
    Result := Copy(Lines[xSelStartY], xSelStartX + 1, xSelEndX - xSelStartX)
  else
  begin
    Result := Copy(Lines[xSelStartY], xSelStartX + 1, Length(Lines[xSelStartY]));
    for i := xSelStartY + 1 to xSelEndY - 1 do
      Result := Result + #13#10 + Lines[i];
    Result := Result + #13#10 + Copy(Lines[xSelEndY], 1, xSelEndX);
  end;
end;

//--------------------------------------------------------------
//        SET SEL TEXT
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetSelText(const AValue: string);
var
  i, k,j: integer;
  xSelStartX, xSelStartY, xSelEndX, xSelEndY: integer;
  Buff, S: string;
  OldX, OldY: integer;
  tz:Tstringlist;
begin
  Buff := AValue;
  xSelStartX := FSelStartX;
  xSelStartY := FSelStartY;
  xSelEndX := FSelEndX;
  xSelEndY := FSelEndY;
  OrderPos(xSelStartX, xSelStartY, xSelEndX, xSelEndY);

  DeleteSelection(False);

  OldX := CurX;
  OldY := CurY;
  i := Pos(#13#10, Buff);
  S := Lines[xSelStartY];
  if i = 0 then
  begin
    Lines[xSelStartY] := Copy(S, 1, xSelStartX) + Buff + Copy(S, xSelStartX + 1, Length(S));
    CurX := xSelStartX;
    if Buff <> '' then
      CurX := CurX + Length(Buff);
  end
  else
  begin
    k := xSelStartY;
    Lines[k] := Copy(S, 1, xSelStartX) + Copy(Buff, 1, i - 1);
    TAdvMemoStrings(Lines).DoInsert(k + 1, Copy(S, xSelStartX + 1, Length(S)));
    Lines.OnChange := nil;
    tz := TStringList.Create;
    tz.text := buff;
    j := 0;
    for k := 1 to tz.count - 1 do
    begin
      if xSelStartY+k >= lines.count then
        Continue;
      if k < tz.Count - 1 then
        TAdvMemoStrings(Lines).DoInsert(xSelStartY+k,tz.Strings[k])
      else
      begin
        Lines[xSelStartY+k] := tz.Strings[k] + Lines[xSelStartY+k];
        j := length(tz.Strings[k]);
      end;
    end;
    k := xSelStartY + tz.count - 1;
    tz.free;

    lines.OnChange := LinesChanged;
    
    CurY := k;
    CurX := j;
    LinesChanged(nil);
  end;
  ClearSelection;
  FUndoList.Add(TPasteUndo.Create(OldX, OldY, CurX, CurY, AValue));
  Invalidate;
end;

//--------------------------------------------------------------
//        GET SEL LENGTH
//--------------------------------------------------------------
function TAdvCustomMemo.GetSelLength: integer;
begin
  Result := Length(GetSelText);
end;

//--------------------------------------------------------------
//        SELECTION CHANGED
//--------------------------------------------------------------
procedure TAdvCustomMemo.SelectionChanged;
begin
  if Assigned(FOnSelectionChange) then
    FOnSelectionChange(Self);
end;

//--------------------------------------------------------------
//        FONT CHANGED
//--------------------------------------------------------------
procedure TAdvCustomMemo.FontChanged(Sender: TObject);
var
  wW, wi: integer;
  OldFontName: string;
begin
  if not HandleAllocated then
    Exit;

  OldFontName := Canvas.Font.Name;
  Canvas.Font.Name := FFont.Name;


  wW := Canvas.TextWidth('W');
  wi := Canvas.TextWidth('i');
  Canvas.Font.Name := OldFontName;

  if wW <> wi then
    raise EAbort.Create('Monospace font required');

  Canvas.Font.Assign(FFont);
  FCellSize.W := Canvas.TextWidth('W');
  FCellSize.H := Canvas.TextHeight('W');

  if FCaretVisible then
  begin
    ShowCaret(False);
    DestroyCaret;
    CreateCaret(Handle, HBITMAP(0), 2, FCellSize.H - 2);
    ShowCaret(True);
  end;

  // update scrollbars in case new font settings require scrollbar change
  ResizeScrollBars;
  Invalidate;
end;


//--------------------------------------------------------------
//        STATUS CHANGED
//--------------------------------------------------------------
procedure TAdvCustomMemo.StatusChanged;
begin
  if Assigned(FOnStatusChange) then FOnStatusChange(Self);
end;

//--------------------------------------------------------------
//        CLEAR SELECTION
//--------------------------------------------------------------
procedure TAdvCustomMemo.ClearSelection;
var
  Changed: boolean;
begin
  Changed := not ((FSelStartX = FSelEndX) and (FSelStartY = FSelEndY));
  FSelStartX := CurX;
  FSelStartY := CurY;
  FSelEndX := CurX;
  FSelEndY := CurY;
  FPrevSelX := CurX;
  FPrevSelY := CurY;
  if Changed then
  begin
    SelectionChanged;
    Invalidate;
  end;
end;

//--------------------------------------------------------------
//        EXPAND SELECTION
//--------------------------------------------------------------
procedure TAdvCustomMemo.ExpandSelection;
var 
  rct: TRect;
begin
  rct := LineRangeRect(FPrevSelY, CurY);
  FSelEndX := CurX;
  FSelEndY := CurY;
  FPrevSelX := CurX;
  FPrevSelY := CurY;
  SelectionChanged;
  InvalidateRect(Handle, @rct, True);
end;

//--------------------------------------------------------------
//        MAX LENGTH
//--------------------------------------------------------------
Procedure TAdvCustomMemo.SetMaxLength;
var
  i, len,mx: integer;
begin
  mx := 0;

  if Lines.FListLengths.Count <> Lines.Count then
    Exit;

  for i := 0 to lines.FListLengths.Count - 1 do
  begin

    len := integer(lines.FListLengths[i]);
    if len > mx then
    begin
      mx := len;
    end;
  end;
  FmaxLength := mx;
end;

//--------------------------------------------------------------
//        DO SCROLL
//--------------------------------------------------------------
procedure TAdvCustomMemo.DoScroll(Sender: TScrollBar; ByValue: integer);
var
  eRect: TRect;
  Old: integer;
begin
  eRect := EditorRect;
  case Sender.Kind of
    sbVertical:
    begin
      Old := FTopLine;
      FTopLine := FTopLine + ByValue;
      if FTopLine > Sender.Max then
        FTopLine := Sender.Max;
      if FTopLine < 0 then FTopLine := 0;
      if Old <> FTopLine then
      begin
        Invalidate;  {!!!!!!}
        if CurX > FLeftCol then ShowCaret(True)
                           else ShowCaret(false);
      end;
    end;
    sbHorizontal:
    begin
      Old := FLeftCol;
      FLeftCol := FLeftCol + ByValue;
      if FLeftCol > Sender.Max then
        FLeftCol := Sender.Max;
      if FLeftCol < 0 then FLeftCol := 0;
      if Old <> FLeftCol then
      begin
        Invalidate;
        if CurX > FLeftCol then  ShowCaret(True)
                           else  ShowCaret(false)
      end;
    end;
  end;
end;

//--------------------------------------------------------------
//        DO SCROLL PAGE
//--------------------------------------------------------------

procedure TAdvCustomMemo.DoScrollPage(Sender: TScrollBar; ByValue: integer);
begin
  case Sender.Kind of
  sbVertical: DoScroll(Sender, ByValue * VisibleLineCount);
  sbHorizontal: DoScroll(Sender, ByValue * VisiblePosCount);
  end;
end;

//--------------------------------------------------------------
//        SET LINES
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetLines(ALines: TAdvMemoStrings);
begin
  if ALines <> nil then
  begin
    FLines.Clear;
    FLines.AddStrings(ALines);
    if (csDesigning in ComponentState) then
    begin
      ResizeEditor;
      Repaint;
    end
    else
    begin
      SelectionChanged;
      Invalidate;
    end;
  end;
end;


//--------------------------------------------------------------
//        SYNTAX MEMO - SET CASE SENSITIVE
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetCaseSensitive(Value: boolean);
begin
  if Value <> FCaseSensitive then
  begin
    FCaseSensitive := Value;
    Invalidate;
  end;
end;
//--------------------------------------------------------------

procedure TAdvCustomMemo.SetCurX(Value: integer);
var
  len: integer;
  WasVisible: boolean;
  lf: boolean;
begin
  if Value = FCurX then
    Exit;



  if Value < 0 then
    if CurY = 0 then Value := 0
    else
    begin
      CurY := CurY - 1;

      if (CurY >= 0) and (CurY < Lines.Count) then
        Value := Length(Lines[CurY]);
    end;

  FCurX := Value;

  if (CurY >= 0) and (CurY < Lines.Count) then
  begin
    len := Length(Lines[CurY]);

    lf := FLetRefresh;
    FLetRefresh := False;

    if Value > FMaxLength then
    begin
      FLeftCol := Value - VisiblePosCount;
      if FLeftCol < 0 then
        FLeftCol := 0;
      FmaxLength := value;
    end
    else
    begin
      len := Length(Lines[cury]);
      SetMaxLength;
    end;

    if Value > len then
    begin
      if Lines.Count > 0 then
        Lines[CurY] := Lines[CurY] + StringOfChar(' ', Value - len)
      else
        Lines.Add(StringOfChar(' ', Value - len));

      Invalidate;
    end;
    FLetRefresh := lf;
  end;

  FCurX := Value;
  WasVisible := FCaretVisible;

  MakeVisible;
  ResizeScrollBars;
  StatusChanged;

  if WasVisible then
    ShowCaret(True);

  if {SearchParameter and} (FAutoHintParameters = hpAuto) then
    PrepareShowHint;

  CursorChanged;
end;

//--------------------------------------------------------------
//        SET CUR Y
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetCurY(Value: integer);
var
  Old: integer;
  WasVisible: boolean;
  lf: boolean;
  ny: Boolean;
begin
// The current should NOT test:  if Value = FCurY then exit

  ny := Value <> FCurY;

  if Lines.Count = 0 then
    Lines.Add('');

  WasVisible := FCaretVisible;
  Old := CurY;

  if Value >= Lines.Count then
    Value := Lines.Count - 1;

  if Value < 0 then
    Value := 0;

  FCurY := Value;
  lf := FLetRefresh;
  FLetRefresh := False;

  if (CurY <> Old) and (Old >= 0) and (Old < Lines.Count) then
  begin
    Lines[Old] := TrimRight(Lines[Old]);
    if FHintForm.Visible then
      FHintForm.Hide;
  end;

  FLetRefresh := lf;

  CurX := CurX;

  MakeVisible;
  ResizeScrollBars;
  StatusChanged;
  if WasVisible then
    ShowCaret(True);

  if ny then
    CursorChanged;
end;

//--------------------------------------------------------------
//        MOVE CURSOR
//--------------------------------------------------------------
procedure TAdvCustomMemo.MoveCursor(dX, dY: integer; Shift: TShiftState);
var
  Selecting: boolean;
  S: string;
  //------------------------------------------------------------
  procedure MoveWordLeft;
  begin
    CurX := CurX - 1;
    S := TrimRight(Lines[CurY]);
    while (CurX > 0) and (CurX <= Length(s)) do
    begin
      if (S[CurX] = ' ') and (S[CurX + 1] <> ' ') then
        Break;
      CurX := CurX - 1;
    end;
    if (CurX < 0) then
      if CurY > 0 then
      begin
        CurY := CurY - 1;
        CurX := Length(Lines[CurY]);
      end;
  end;
  //------------------------------------------------------------
  procedure MoveWordRight;
  var
    Len: integer;
  begin
    S := TrimRight(Lines[CurY]);
    Len := Length(S);
    CurX := CurX + 1;
    while CurX < Len do
    begin
      if (S[CurX] = ' ') and (S[CurX + 1] <> ' ') then
        Break;
      CurX := CurX + 1;
    end;
    if CurX > Len then
      if CurY < Lines.Count - 1 then
      begin
        CurY := CurY + 1;
        CurX := 0;
      end;
  end;
  //------------------------------------------------------------
begin
  Selecting := (ssShift in Shift) and (CurX = FPrevSelX) and (CurY = FPrevSelY);

  if ssCtrl in Shift then
  begin
    if dX > 0 then MoveWordRight;
    if dX < 0 then MoveWordLeft;
  end
  else
  begin
    CurY := CurY + dY;
    CurX := CurX + dX;
  end;

  if Selecting then
    ExpandSelection
  else
    ClearSelection;
end;

//--------------------------------------------------------------
//        MOVE PAGE
//--------------------------------------------------------------
procedure TAdvCustomMemo.MovePage(dP: integer; Shift: TShiftState);
var
  eRect: TRect;
  LinesPerPage: integer;
  Selecting: boolean;
begin
  if FCellSize.H = 0 then
    Exit;

  Selecting := (ssShift in Shift) and (CurX = FPrevSelX) and (CurY = FPrevSelY);

  eRect := EditorRect;
  LinesPerPage := (eRect.Bottom - eRect.Top) div FCellSize.H - 1;

  CurY := CurY + dP * LinesPerPage;
  
  if ssCtrl in Shift then
    if dP > 0 then
    begin
      CurY := Lines.Count - 1;
      CurX := Length(Lines[Lines.Count - 1]);
    end
    else
    begin
      CurY := 0;
      CurX := 0;
    end;

  if Selecting then
    ExpandSelection
  else
    ClearSelection;
end;

//--------------------------------------------------------------
//        GO HOME
//--------------------------------------------------------------
procedure TAdvCustomMemo.GoHome(Shift: TShiftState);
var 
  Selecting: boolean;
begin
  if (ssCtrl in Shift) then
  begin
    CurX := 0;
    CurY := 0;
  end;

  Selecting := (ssShift in Shift) and (CurX = FPrevSelX) and (CurY = FPrevSelY);
  CurX := 0;
  FLeftCol := 0;
  if Selecting then
    ExpandSelection
  else              
    ClearSelection;
end;

//--------------------------------------------------------------
//        GO END
//--------------------------------------------------------------
procedure TAdvCustomMemo.GoEnd(Shift: TShiftState);
var
  Selecting: boolean;
begin
  if ssCtrl in Shift then
  begin
    CurY := Lines.Count - 1;
    CurX := Length(Lines[Lines.Count - 1]);
  end;  

  Selecting := (ssShift in Shift) and (CurX = FPrevSelX) and (CurY = FPrevSelY);
  CurX := Length(TrimRight(Lines[CurY]));

  if Selecting then ExpandSelection
  else              
    ClearSelection;
end;

//--------------------------------------------------------------
//        INSERT CHAR
//--------------------------------------------------------------
procedure TAdvCustomMemo.InsertChar(C: char);
var
  S, S1: string;
  NewPlace: integer;
  CurX0, CurY0: integer;
begin
  if (curY >= Lines.Count) then
  begin
    curY := curY;
  end;

  CurX0 := CurX;
  CurY0 := CurY;
  S := Lines[CurY];
  if C = #9 then
    S1 := StringOfChar(' ', TabSize)
  else
  begin
    if CurX > Length(s) then
      S := S + StringOfChar(' ',CurX);
    S1 := C;
  end;

  NewPlace := CurX + length(s1);

  if FOverwrite then
  begin
    if length(S) >= CurX + 1 then
      S[CurX + 1] := C
    else
      Insert(S1, S, CurX + 1);
  end
  else
    Insert(S1, S, CurX + 1);
  fletrefresh := False;
  Lines[CurY] := S;
  fletrefresh := True;
  CurX := NewPlace;
  ClearSelection;
  FUndoList.Add(TInsertCharUndo.Create(CurX0, CurY0, CurX, CurY, S1));
  LinesChanged(nil);
  Invalidate;
end;

//--------------------------------------------------------------
//        INSERT TEMPLATE
//--------------------------------------------------------------
procedure TAdvCustomMemo.InsertTemplate(AText: string);
var
  i, NewCurX, NewCurY: integer;
  Indent: string;
  FoundCursor: boolean;
begin
  Indent := IndentCurrLine;

  NewCurX := CurX;
  NewCurY := CurY;
  FoundCursor := False;
  i := 1;
  while i <= Length(AText) do 
  begin
    if AText[i] = #13 then 
    begin
      if (i = Length(AText)) or (AText[i + 1] <> #10) then
        Insert(#10 + Indent, AText, i + 1);
      if not FoundCursor then 
      begin
        Inc(NewCurY);
        NewCurX := Length(Indent);
      end;
      Inc(i, 1 + Length(Indent));
    end
    else if AText[i] = #7 then 
    begin
      FoundCursor := True;
      Delete(AText, i, 1);
      Dec(i);
    end
    else if Ord(AText[i]) < Ord(' ') then 
    begin
      Delete(AText, i, 1);
      Dec(i);
    end
    else if not FoundCursor then
      Inc(NewCurX);
    Inc(i);
  end;

  ClearSelection;
  SetSelText(AText);
  SetCursor(NewCurX, NewCurY);
  SetFocus;
end;

//--------------------------------------------------------------
//        DELETE CHAR
//--------------------------------------------------------------
procedure TAdvCustomMemo.DeleteChar(OldX, OldY: integer);
var
  S: string;
  C: char;
  Undo: TDeleteCharUndo;
  IsBackspace: boolean;
begin
  if not EditCanModify then
    Exit;

  Fletrefresh := False;

  if OldX < 0 then
  begin
    OldX := CurX;
    OldY := CurY;
    IsBackspace := False;
  end
  else
    IsBackspace := True;

  ClearSelection;

  {$IFDEF TMSDEBUG}
  outputdebugstring(pchar('before delete ->'+lines[cury]+'*'));
  {$ENDIF}

  if (CurX < Length(Lines[CurY])) then
  begin
    S := Lines[CurY];
    C := S[CurX + 1];
    Delete(S, CurX + 1, 1);
    Lines[CurY] := S;

    Undo := TDeleteCharUndo.Create(OldX, OldY, CurX, CurY, C);
    Undo.IsBackSpace := IsBackSpace;
    FUndoList.Add(Undo);
  end
  else if CurY < Lines.Count - 1 then
  begin
    S := Lines[CurY] + Lines[CurY + 1];
    Lines[CurY] := S;

    Lines.Delete(CurY + 1);
    Undo := TDeleteCharUndo.Create(OldX, OldY, CurX, CurY, #13);
    Undo.IsBackSpace := IsBackSpace;
    FUndoList.Add(Undo);
  end;
  Fletrefresh := True;
  LinesChanged(nil);

  Invalidate;
  {$IFDEF TMSDEBUG}
  outputdebugstring(pchar('after delete ->'+lines[cury]+'*'));
  {$ENDIF}
end;

//--------------------------------------------------------------
//        DELETE LINE
//--------------------------------------------------------------
procedure TAdvCustomMemo.DeleteLine;
var
  OldX, OldY: integer;
  s: string;
begin
  if not EditCanModify then
    Exit;
  OldX := CurX;
  OldY := CurY;
  s := Lines[CurY];
  CurX := 0;

  if Lines.Count = 1 then
    TAdvMemoStrings(Lines)[0] := ''
  else if CurY = Lines.Count - 1 then
  begin
    CurY := CurY - 1;
    Lines.Delete(CurY + 1);
  end
  else
    Lines.Delete(CurY);

  ClearSelection;
  Invalidate;
  FUndoList.Add(TDeleteLineUndo.Create(OldX, OldY, CurX, CurY, S));
end;

//--------------------------------------------------------------
//        BACK SPACE
//--------------------------------------------------------------
procedure TAdvCustomMemo.BackSpace;
var
  OldX, OldY: integer;
begin
  OldX := CurX;
  OldY := CurY;

  MoveCursor(-1, 0, []);

  if (OldX = CurX) and (OldY = CurY) then
    Exit;

  DeleteChar(OldX, OldY);
end;

procedure TAdvCustomMemo.BackWord;
var
  OldX, OldY: integer;
  s: string;
begin
  s := Lines[CurY];
  repeat
    OldX := CurX;
    OldY := CurY;

    MoveCursor(-1, 0, []);

    if (OldX = CurX) and (OldY = CurY) then
      Exit;

    DeleteChar(OldX, OldY);
  until (OldX = CurX) or (s[CurX] = ' ');
end;


//--------------------------------------------------------------
//        INDENT CURR LINE
//--------------------------------------------------------------
function TAdvCustomMemo.IndentCurrLine: string;
var
  Len, Count: integer;
  CurS: string;
begin
  Result := '';
  if not AutoIndent then Exit;
  CurS := Lines[CurY];
  Len := Length(CurS);
  Count := 0;
  while (Count < CurX) and (Count < Len) do
  begin
    if CurS[Count + 1] <> ' ' then break;
    Inc(Count);
  end;
  Result := StringOfChar(' ', Count);
end;

//--------------------------------------------------------------
//        NEW LINE
//--------------------------------------------------------------
procedure TAdvCustomMemo.NewLine;
var
  S, sIndent: string;
  OldX, OldY: integer;
begin
  if not EditCanModify then
    Exit;
  FLetRefresh := False;
  if (curY >= Lines.Count) then
  begin
    curY := curY;
  end;

  OldX := CurX;
  OldY := CurY;

  S := Lines[CurY];
  sIndent := IndentCurrLine;
  Lines[CurY] := Copy(S, 1, CurX);     

  S := TrimRight(Copy(S, CurX + 1, Length(S)));
  if AutoIndent then
    while (Length(S) > 0) and (S[1] = ' ') do
        Delete(S, 1, 1);
  TAdvMemoStrings(Lines).DoInsert(CurY + 1, sIndent + S);
  GoHome([]);
  MoveCursor(0, 1, []);
  CurX := Length(sIndent);
  FUndoList.Add(TInsertCharUndo.Create(OldX, OldY, CurX, CurY, #13 + sIndent));
  Fletrefresh := True;
  LinesChanged(Self);
end;

//--------------------------------------------------------------
//        ADD STRING
//--------------------------------------------------------------
function TAdvCustomMemo.AddString(S: string): integer;
begin
  if Lines.Count = 0 then
    TAdvMemoStrings(Lines).DoAdd('');
  MovePage(1, [ssCtrl]); // end of text
  if not ((Lines.Count = 1) and (Lines[0] = '')) then
  begin
    TAdvMemoStrings(Lines).DoAdd('');
    CurX := 0;
    CurY := Lines.Count;
    ClearSelection;
  end;
  SetSelText(S);
  Result := Lines.Count - 1;
end;

//--------------------------------------------------------------
//        INSERT STRING
//--------------------------------------------------------------
procedure TAdvCustomMemo.InsertString(Index: integer; S: string);
begin
  CurY := Index;
  CurX := 0;
  ClearSelection;
  if not ((Lines.Count = 1) and (Lines[0] = '')) then
    S := S + #13#10;
  SetSelText(S);
end;

//--------------------------------------------------------------
//        DO COMMAND
//--------------------------------------------------------------
procedure TAdvCustomMemo.DoCommand(cmd: TCommand; const AShift: TShiftState);
var
  Allow: Boolean;
begin
  if ReadOnly then
    Exit;
  case cmd of
    cmDelete: if ssShift in AShift then
        CutToClipboard
      else if FDelErase and
        (not ((FSelStartX = FSelEndX) and (FSelStartY = FSelEndY))) then
        DeleteSelection(True)
      else
        DeleteChar(-1, - 1);
    cmBackSpace:
    begin
      if not EditCanModify then
        Exit;

      if ssCtrl in AShift then
      begin
        BackWord;
      end
      else
      begin
        if FDelErase and
          (not ((FSelStartX = FSelEndX) and (FSelStartY = FSelEndY))) then
          DeleteSelection(True)
        else
          BackSpace;
      end;
    end;
    cmNewLine: NewLine;
    cmDelLine: DeleteLine;
    cmCopy: CopyToClipboard;
    cmSelectAll: SelectAll;
    cmCut: CutToClipboard;
    cmPaste: PasteFromClipboard;
    cmHome:
      begin
        GoHome(AShift);
        if (ssCtrl in AShift) and (ssShift in AShift) then
          SelectAll;
      end;
    cmEnd:
      begin
        GoEnd(AShift);
        if (ssCtrl in AShift) and (ssShift in AShift) then
          SelectAll;
       end;
    cmPageDown: MovePage(1, AShift);
    cmPageUp: MovePage(-1, AShift);
    cmInsert:
    begin
      if ssShift in AShift then PasteFromClipboard
      else
        if ssCtrl in AShift then CopyToClipboard
          else
          begin
            Allow := True;
            if Assigned(OnOverwriteToggle) then
              OnOverwriteToggle(Self, Allow);
            if Allow then
              FOverwrite := not FOverwrite;
          end;

    end;
  end;
end;

//--------------------------------------------------------------
//        KEY DOWN
//--------------------------------------------------------------
procedure TAdvCustomMemo.KeyDown(var Key: word; Shift: TShiftState);
begin
  inherited;
  
  {$IFDEF BLINK}
  if FletgetCaretTime then
    FCaretTime := GetCaretBlinkTime;
  FletgetCaretTime := False;
  SetCaretBlinkTime(dword(-1));
  {$ENDIF}
  FLetShowAutocompletion := True;

  if not (Key in [VK_UP,VK_DOWN,VK_LEFT,VK_RIGHT]) then
  begin
    curx := curx;
    cury := cury;
  end;

  case Key of
    VK_LEFT: MoveCursor(-1, 0, Shift);
    VK_RIGHT: MoveCursor(1, 0, Shift);
    VK_UP: MoveCursor(0, - 1, Shift);
    VK_DOWN: MoveCursor(0, 1, Shift);
    VK_HOME, VK_END,
    VK_DELETE: DoCommand(Key, Shift);
    VK_PRIOR, VK_NEXT:
      DoCommand(Key, Shift);
    VK_INSERT: DoCommand(Key, Shift);
    VK_BACK: DoCommand(Key, Shift);
    ord('F'):if ssctrl in Shift then DoFind;
    ord('H'):if ssctrl in Shift then DoReplace;
    VK_SPACE:if [ssctrl] = Shift then
    begin
      if FAutoCompletion then
      begin
        FletShowAutocompletion := False;
        ShowForm;
      end;
    end
    else
    begin
      if ([ssShift,ssCtrl] = shift) and (FAutoHintParameters <> hpNone) then
      begin
        PrepareShowHint;
      end
    end;
  end;
end;

//--------------------------------------------------------------
//        KEY PRESS
//--------------------------------------------------------------
procedure TAdvCustomMemo.KeyPress(var Key: char);
begin
  if FReadOnly or not EditCanModify then
    Exit;

  if FAutoCompletion then
    if not FletShowAutocompletion then
      Exit;

  inherited;

  if Ord(Key) in [9,32..126,128..255] then
  begin
    if FDelErase and (not ((FSelStartX = FSelEndX) and (FSelStartY = FSelEndY))) then
      DeleteSelection(True);
    InsertChar(Key);
  end
  else
    if Ord(Key) <> 8 then
      DoCommand(Ord(Key), []);
end;

//--------------------------------------------------------------
//        MOUSE DOWN
//--------------------------------------------------------------
procedure TAdvCustomMemo.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  newPos: TCellPos;
  charPos: TFullPos;
  yold: Integer;
  lc: Boolean;
begin

  inherited;

  if not Focused then
  begin
    SetFocus;
    { Allow direct caret positioning when memo has not focus }
    //Exit;
  end;

  if Button <> mbLeft then
    Exit;

  if PointInRect(Point(X, Y), EditorRect) then
  begin
    ShowCaret(False);

    newPos := CellFromPos(X, Y);

    yold := Fcury;

    if newPos.x < 0 then newPos.x := 0;
    if newPos.y < 0 then newPos.y := 0;
    // Please leave FCury not Cury (otherwise problems appear when the text is
    // scrolled and when the cursor is not in the visible area and the user
    // clicks)
    FCurY := newPos.Y + FTopLine;
    if fcury >= lines.Count then
      fcury := lines.Count - 1;
    if fcury < 0 then
      fcury := 0;

    CurX := newPos.X + FLeftCol;
    cury := cury;
    lc := FLetRefresh;
    FLetRefresh := False;

    if (yold <> FCurY) and (yold < Lines.Count) then
      Lines[yold] := TrimRight(Lines[yold]);

    FLetRefresh := lc;
    if Button = mbLeft then
    begin
      if (ssShift in Shift)  then
        ExpandSelection
      else
        ClearSelection;

      FLeftButtonDown := True; //Continue selection if hold shift and mouse move
      TestForURLClick(Lines[CurY]);
    end
    else
      ShowCaret(True);
  end;



  if Assigned(FOnGutterClick) then
    if PointInRect(Point(X, Y), FGutter.FullRect) then
    begin
      CharPos := CharFromPos(X, Y);
      if charPos.LineNo < Lines.Count then
        FOnGutterClick(Self, charPos.LineNo);
    end;
end;

//--------------------------------------------------------------
//        MOUSE MOVE
//--------------------------------------------------------------
procedure TAdvCustomMemo.MouseMove(Shift: TShiftState; X, Y: integer);
var
  newPos: TCellPos;
  oldSx, oldSy, oldEy, oldEx: integer;
begin
  inherited;
  newPos := CellFromPos(X, Y);
  if newPos.x < 0 then
    newPos.x := 0
  else
    newPos.x := newPos.x + FLeftCol;

  if newPos.Y < 0 then  newPos.y := 0
  else
    newPos.y := newPos.y + FTopLine;

  if (newPos.y >= 0) and (newPos.y < Lines.Count) then
  begin
    if TestforURLMove(Lines[newPos.y], newPos.x) then
    begin
      if Cursor <> crHandPoint then
        FoldCursor := Cursor;
      inherited Cursor := crHandPoint;
    end
    else
      inherited Cursor := FoldCursor;
  end
  else
    inherited Cursor := FoldCursor;

  oldSx := FSelStartX;
  oldSy := FSelStartY;
  oldEx := FSelEndX;
  oldEY := FSelEndY;

  if (ssLEft in Shift) and FLeftButtonDown then
  begin
    newPos := CellFromPos(X, Y);
    if newPos.x < 0 then
    begin
      curx := 0;
      FLeftCol := 0;
    end
    else
      CurX := newPos.X + FLeftCol;
    CurY := newPos.Y + FTopLine;
    ExpandSelection;
    // Force
    if ((oldSx <> FSelStartX) or
      (oldSy <> FSelStartY) or
      (oldEx <> FSelEndX) or
      (oldEY <> FSelEndY)) then  Repaint;
  end;
end;

//--------------------------------------------------------------
//        MOUSE UP
//--------------------------------------------------------------
procedure TAdvCustomMemo.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  if Button = mbLeft then
    ShowCaret(True);
  FLeftButtonDown := False;
end;

//--------------------------------------------------------------
//        WM_GETDLGCODE
//--------------------------------------------------------------
procedure TAdvCustomMemo.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS or DLGC_WANTTAB or DLGC_WANTCHARS;
end;

//--------------------------------------------------------------
//        WM_ERASEBKGND
//--------------------------------------------------------------
procedure TAdvCustomMemo.WMEraseBkgnd(var Msg: TWmEraseBkgnd);
begin
  Msg.Result := 1;
end;

//--------------------------------------------------------------
//        WM_SIZE
//--------------------------------------------------------------
procedure TAdvCustomMemo.WMSize(var Msg: TWMSize);
begin
  try
    ResizeEditor;
  except
  end;
end;

//--------------------------------------------------------------
//        WM_SETCURSOR
//--------------------------------------------------------------
procedure TAdvCustomMemo.WMSetCursor(var Msg: TWMSetCursor);
var
  P: TPoint;
begin
  Msg.Result := 1;
  GetCursorPos(P);
  P := ScreenToClient(P);
  if PointInRect(P, EditorRect) then
    Windows.SetCursor(Screen.Cursors[Cursor])
  else
    Windows.SetCursor(Screen.Cursors[crArrow]);
end;

//--------------------------------------------------------------
//        WM_SETFOCUS
//--------------------------------------------------------------
procedure TAdvCustomMemo.WMSetFocus(var Msg: TWMSetFocus);
begin
  if FCellSize.H = 0 then
    SetFont(FFont);
  CreateCaret(Handle, HBITMAP(0), 2, FCellSize.H - 2);
  FCaretX := $FFFF;
  FCaretY := $FFFF;

  ShowCaret(True);
  {$IFDEF BLINK}
  FCaretTime := GetCaretBlinkTime;
  {$ENDIF}
  Invalidate;
end;

//--------------------------------------------------------------
//        WM_KILLFOCUS
//--------------------------------------------------------------
procedure TAdvCustomMemo.WMKillFocus(var Msg: TWMSetFocus);
begin
  Timer.Enabled := True;

  if not FHintShowing and FHintForm.Visible then
    FHintForm.Visible := False;

  if (sbVert.Focused) or (sbHorz.Focused) then
  begin
    inherited;
    Exit;
  end;
  {$IFDEF BLINK}
  SetCaretBlinkTime(FCaretTime);
  {$ENDIF}
  DestroyCaret;
  FCaretVisible := False;

  inherited;
  Invalidate;
end;

//--------------------------------------------------------------
//        SHOW CARET
//--------------------------------------------------------------
procedure TAdvCustomMemo.ShowCaret(State: boolean);
var
  rct: TRect;
begin
  if not State then
  begin
    if FCaretVisible then
      HideCaret(Handle);
    FCaretVisible := False;
  end
  else if Focused and not HiddenCaret then
  begin
    rct := CellRect(CurX - FLeftCol, CurY - FTopLine);
    if (FCaretX <> Cardinal(rct.Left)) or (FCaretY <> Cardinal(rct.Top + 1)) then
       SetCaretPos(rct.Left, rct.Top + 1);

    FCaretX := rct.Left;
    FCaretY := rct.Top + 1;

    if not FCaretVisible then
      Windows.ShowCaret(Handle);
    FCaretVisible := True;
  end;
end;

//--------------------------------------------------------------
//        CELL RECT
//--------------------------------------------------------------
function TAdvCustomMemo.CellRect(ACol, ARow: integer): TRect;
var
  rct: TRect;
begin
  rct := EditorRect;
  with FCellSize do
    Result := Rect(rct.Left + W * ACol, rct.Top + H * ARow + 1,
      rct.Left + W * (ACol + 1), rct.Top + H * (ARow + 1) + 1);
end;

//--------------------------------------------------------------
//        LINE RECT
//--------------------------------------------------------------
function TAdvCustomMemo.LineRect(ARow: integer): TRect;
var
  rct: TRect;
begin
  rct := EditorRect;
  ARow := ARow - FTopLine;
  with FCellSize do
    Result := Rect(rct.Left, rct.Top + H * ARow, rct.Right, rct.Top + H * (ARow + 1));
end;

//--------------------------------------------------------------
//        COL RECT
//--------------------------------------------------------------
function TAdvCustomMemo.ColRect(ACol: integer): TRect;
var
  rct: TRect;
begin
  rct := EditorRect;
  ACol := ACol - FLeftCol;
  with FCellSize do
    Result := Rect(rct.Left + W * ACol, rct.Top, rct.Left + W * (ACol + 1), rct.Bottom);
end;

//--------------------------------------------------------------
//        LINE RANGE RECT
//--------------------------------------------------------------
function TAdvCustomMemo.LineRangeRect(FromLine, ToLine: integer): TRect;
var
  rct1, rct2: TRect;
begin
  rct1 := LineRect(FromLine);
  rct2 := LineRect(ToLine);
  Result := TotalRect(rct1, rct2);
end;

//--------------------------------------------------------------
//        COL RANGE RECT
//--------------------------------------------------------------
function TAdvCustomMemo.ColRangeRect(FromCol, ToCol: integer): TRect;
var
  rct1, rct2: TRect;
begin
  rct1 := ColRect(FromCol);
  rct2 := ColRect(ToCol);
  Result := TotalRect(rct1, rct2);
end;

//--------------------------------------------------------------
//        CELL and CHAR FROM POS
//--------------------------------------------------------------
function TAdvCustomMemo.CellFromPos(X, Y: integer): TCellPos;
var
  rct: TRect;
begin
  rct := EditorRect;
  if (FCellSize.H = 0) and Assigned(FFont) then
    SetFont(FFont);
  if (FCellSize.W <> 0) and (FCellSize.H <> 0) then
  begin
    Result.X := (X - rct.Left) div FCellSize.W;
    Result.Y := (Y - rct.Top) div FCellSize.H;
  end
  else
  begin
    Result.X := 0;
    Result.Y := 0;
  end;
end;

function TAdvCustomMemo.CharFromPos(X, Y: integer): TFullPos;
var
  rct: TRect;
begin
  rct := EditorRect;
  if (FCellSize.H = 0) and Assigned(FFont) then SetFont(FFont);
  if (FCellSize.W <> 0) and (FCellSize.H <> 0) then
  begin
    Result.Pos := (X - rct.Left) div FCellSize.W + FLeftCol;
    Result.LineNo := (Y - rct.Top) div FCellSize.H + FTopLine;
  end
  else
  begin
    Result.Pos := 1;
    Result.LineNo := 1;
  end;
end;

//--------------------------------------------------------------
//        SET COLOR
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetColor(Index: integer; Value: TColor);
var
  Changed: boolean;
begin
  Changed := False;
  case Index of
    0: if FBkColor <> Value then
      begin
        FBkColor := Value;
        Changed := True;
      end;
    1: if FSelColor <> Value then
      begin
        FSelColor := Value;
        Changed := True;
      end;
    2: if FSelBkColor <> Value then
      begin
        FSelBkColor := Value;
        Changed := True;
      end;
  end;

  if Changed then
    Invalidate;
end;

//--------------------------------------------------------------
//        SET FONT
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetFont(Value: TFont);
var
  wW, wi: integer;
  OldFontName: string;
begin
  OldFontName := Canvas.Font.Name;
  Canvas.Font.Name := Value.Name;
  wW := Canvas.TextWidth('W');
  wi := Canvas.TextWidth('i');
  Canvas.Font.Name := OldFontName;

  if wW <> wi then
    raise EAbort.Create('Monospace font required');

  FFont.Assign(Value);
  Canvas.Font.Assign(Value);
  FCellSize.W := Canvas.TextWidth('W');
  FCellSize.H := Canvas.TextHeight('W');

  if FCaretVisible then
  begin
    ShowCaret(False);
    DestroyCaret;
    CreateCaret(Handle, HBITMAP(0), 2, FCellSize.H - 2);
    ShowCaret(True);
  end;

  Invalidate;
end;

//--------------------------------------------------------------
//        SET GUTTER WIDTH
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetGutterWidth(Value: integer);
begin
  FGutterWidth := Value;
  FGutter.FWidth := Value;
  if not (csLoading in ComponentState) then
    ResizeEditor;
end;

//--------------------------------------------------------------
//        SET GUTTER COLOR
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetGutterColor(Value: TColor);
begin
  if FGutter.FColor <> Value then
  begin
    FGutter.FColor := Value;
    FGutter.Invalidate;
  end;
end;

//--------------------------------------------------------------
//        GET GUTTER COLOR
//--------------------------------------------------------------
function TAdvCustomMemo.GetGutterColor: TColor;
begin
  Result := FGutter.FColor;
end;


//--------------------------------------------------------------
//        SET HIDDEN CARET
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetHiddenCaret(Value: boolean);
begin
  if Value <> FHiddenCaret then
  begin
    FHiddenCaret := Value;
    if Focused then
      if FHiddenCaret = FCaretVisible then
        ShowCaret(not FHiddenCaret);
  end;
end;

function ansiRPos(Substr, str: string): integer;
var
  i, last: integer;
begin
  Result := 0;
  if length(Substr) > length(str) then exit;
  if Substr = str then
  begin
    Result := 1;
    exit;
  end;
  last := 0;
  repeat
    i := ansipos(Substr, str);
    if i > 0 then
    begin
      last := last + i;
      Delete(str, 1, i);
    end;
  until i = 0;
  Result := last;
end;


//--------------------------------------------------------------
//        BORDER
//--------------------------------------------------------------
procedure Border(Canvas: TCanvas; rct: TRect; BorderType: TBorderType);
const
  Colors: array [TBorderType] of array[1..4] of
    TColor = (($D0D0D0, clWhite, clGray, clBlack),
    (clGray, clBlack, $D0D0D0, clWhite),
    (clWhite, clWhite, clWhite, clGray),
    (clGray, clWhite, clWhite, clGray));
begin
  with Canvas do
  begin
    Pen.Color := Colors[BorderType][1];
    MoveTo(rct.Left, rct.Bottom - 1);
    LineTo(rct.Left, rct.Top);
    LineTo(rct.Right, rct.Top);
    if BorderType in [btRaised, btLowered] then
    begin
      Pen.Color := Colors[BorderType][2];
      MoveTo(rct.Left + 1, rct.Bottom);
      LineTo(rct.Left + 1, rct.Top + 1);
      LineTo(rct.Right, rct.Top + 1);
      Pen.Color := Colors[BorderType][3];
      MoveTo(rct.Left + 1, rct.Bottom - 2);
      LineTo(rct.Right - 2, rct.Bottom - 2);
      LineTo(rct.Right - 2, rct.Top + 1);
    end;
    Pen.Color := Colors[BorderType][4];
    MoveTo(rct.Left, rct.Bottom - 1);
    LineTo(rct.Right - 1, rct.Bottom - 1);
    LineTo(rct.Right - 1, rct.Top);
  end;
end;

//--------------------------------------------------------------
//        EDITOR RECT
//--------------------------------------------------------------
function TAdvCustomMemo.EditorRect: TRect;
var
  l, t, r, b: integer;
begin
  l := 2;
  r := Width - 2;
  t := 2;
  b := Height - 2;

  if GutterWidth > 2 then
    l := l + GutterWidth;
    
  if (FScrollBars in [ssBoth, ssVertical]) and (sbVert.Visible) then
    r := r - sbVert.Width;
  if (FScrollBars in [ssBoth, ssHorizontal]) and (sbHorz.Visible) then
    b := b - sbHorz.Height;
    
  Result := Rect(l + FMargin, t, r, b);

  if BorderStyle = bsNone then
  begin
    InflateRect(Result, 2, 2);
  end
  else
  begin
    if not Ctl3D then
      InflateRect(Result, 1, 1);
  end;
end;

//--------------------------------------------------------------
//        DRAW MARGIN
//--------------------------------------------------------------
procedure TAdvCustomMemo.DrawMargin;
var
  eRect: TRect;
  i: integer;
begin
  eRect := EditorRect;

  with Canvas do
  begin
    Pen.Color := clWhite;

    for i := 1 to FMargin do
    begin
      MoveTo(eRect.Left - i, eRect.Top);
      LineTo(eRect.Left - i, eRect.Bottom + 1);
    end;

    Brush.Color := clScrollBar;
    Pen.Color := clScrollBar;

    if FScrollBars in [ssBoth, ssHorizontal] then
    begin
      eRect := sbHorz.BoundsRect;
      InflateRect(eRect, 1, 1);
      FillRect(eRect);
    end;

    if FScrollBars in [ssBoth, ssVertical] then
    begin
      eRect := sbVert.BoundsRect;
      InflateRect(eRect, 1, 1);
      FillRect(eRect);
    end;
  end;
end;

//--------------------------------------------------------------
//        DRAW GUTTER
//--------------------------------------------------------------
procedure TAdvCustomMemo.DrawGutter;
begin
  if GutterWidth < 2 then
    Exit;
  ResizeGutter;
  FGutter.PaintTo(Canvas);
end;

//--------------------------------------------------------------
//        FRESH LINE BITMAP
//--------------------------------------------------------------
procedure TAdvCustomMemo.FreshLineBitmap;
var 
  eRect: TRect;
begin
  eRect := EditorRect;
  with FLineBitmap do
  begin
    Width := eRect.Right - eRect.Left;
    Height := FCellSize.H;
    FLineBitmap.Canvas.Font.Assign(Self.Canvas.Font);
  end;
end;

//--------------------------------------------------------------
//        PAINT
//--------------------------------------------------------------

function TAdvCustomMemo.GetUpStyle(stopat: integer): TStyle;
var
  i, allb, ll,Iurl: integer;
  comment, bracket,linecomment: boolean;
  ch: char;
  s: string;
  urls:TStringList;
  start: Integer;
  AStyle: TStyle;
begin
  Result.isComment := False;
  Result.isBracket := False;
  Result.isnumber := False;
  Result.iskeyWord := False;
  Result.isdelimiter := False;
  Result.isURL := False;
  Result.index := -1;
  Result.EndBracket := #0;

  if Lines.Count = 0 then
    Exit;

  ch := #0;
  FTempdelimiters := '';

  if not Assigned(FInternalStyles) then
    Exit;

  comment := False;
  bracket := False;

  for allb := 0 to FInternalStyles.FAllStyles.Count - 1 do
  begin
    if FInternalStyles.FAllStyles.Items[allb].FStyleType <> stSymbol then
      Continue;
    FTempdelimiters := FTempdelimiters + FInternalStyles.FAllStyles.Items[allb].FSymbols;
  end;

  start := 0;

  // Find first occurence of cached last line style
  i := stopat - 1;
  while (i >= 0) do
  begin
    if GetLineStyle(i,AStyle) then
    begin
      comment := AStyle.isComment;
      bracket := AStyle.isBracket;
      start := i;
      Result := AStyle;
      Break;
    end
    else
      dec(i);
  end;

  urls := TStringList.Create;
  for i := start to stopat - 1 do
  begin
    if i >= Lines.Count then
      Break;
    s := Lines.Strings[i];
    if s = '' then
      Continue;
    urls.Clear;

    ExtractURL(s,urls);
    linecomment := False;

    for Iurl := 0 to urls.Count - 1 do
    begin
      s := urls[iurl];
      if FUrlAware then
        Result.isURL := (AnsiPos('http://', LowerCase(s)) = 1) or (AnsiPos('mailto:', LowerCase(s)) = 1)
      else
        Result.isURL := False;

      if (not linecomment) and (not Result.isURL) and (FInternalStyles.FMultiCommentLeft <> '') and (s <> '') and
        (FInternalStyles.FMultiCommentRight <> '') then
      begin
        while s <> '' do
        begin
          if (not comment) and (not bracket) then
          begin
            ll := AnsiPos(FInternalStyles.FMultiCommentLeft,s);
            if ll = 1 then
            begin
              comment := true;
              Delete(s,1,length(FInternalStyles.FMultiCommentLeft));
            end;
          end;

          if s = '' then
            Break;

          if (comment) and (not bracket) then
          begin
            ll := AnsiPos(FInternalStyles.FMultiCommentRight,s);
            if ll = 1 then
            begin
              comment := False;
              Delete(s,1,length(FInternalStyles.FMultiCommentRight));
            end;
          end;
          
          if s = '' then
            Break;

          if (not comment) and (not bracket) then
          begin
            ll := AnsiPos(FInternalStyles.FLineComment,s);
            if ll = 1 then
            begin
              linecomment := True;
              Break;
            end;
          end;

          if not comment then
          begin
            for allb := 0 to FInternalStyles.FAllStyles.Count - 1 do
              if (FInternalStyles.FAllStyles.Items[allb].FStyleType = stBracket) and
                 (FInternalStyles.FAllStyles.Items[allb].FBracket <> #0) then
              begin
                if not bracket then
                begin
                  ch := FInternalStyles.FAllStyles.Items[allb].FBracket;
                  Result.Index := allb;
                end;

                if s[1] = ch then
                begin
                  bracket := not bracket;
                  Break;
                end;
              end;
          end;
          Delete(s,1,1);
       end; //while s
     end; //if
    end; //for urls

    if (i mod 50 = 0) then
    begin
      if not GetLineStyle(i,AStyle) then
      begin
        AStyle.isComment := comment;
        AStyle.isBracket := bracket;
        AStyle.EndBracket := ch;
        AStyle.Index := Result.Index;
        SetLineStyle(i,AStyle);
      end;
    end;

  end; //for

  urls.Free;
  Result.isComment := comment;
  Result.isBracket := bracket;
  Result.EndBracket := ch;
  SetLineStyle(stopat,Result);
end;



function TAdvCustomMemo.GetBreakPoint(Index: Integer): Boolean;
var
  Tlp: TlineProp;
begin
  Tlp := Lines.GetLineProp(Index);
  if Assigned(Tlp) and (tlp is TLineProp) then
    Result := tlp.BreakPoint
  else
    Result := False;
end;

function TAdvCustomMemo.GetExecutable(Index: Integer): Boolean;
var
  Tlp: TlineProp;
begin
  Tlp := Lines.GetLineProp(index);
  if (Tlp <> nil) and (tlp is TLineProp) then
    Result := tlp.Executable
  else
    Result := False;
end;

procedure TAdvCustomMemo.SetBreakPoint(Index: Integer;
  const Value: Boolean);
var
  Tlp: TlineProp;
begin
  Tlp := Lines.GetLineProp(index);
  if Tlp = nil then
    tlp := Lines.CreateProp(index);
  tlp.BreakPoint := Value;
  Lines.SetLineProp(index,tlp);
  Invalidate;
end;

function TAdvCustomMemo.GetLineStyle(Index: Integer; var LineStyle: TStyle): Boolean;
var
  Tlp:TlineProp;
begin
  Tlp := Lines.GetLineProp(index);
  if (Tlp <> nil) and (tlp is TLineProp) then
  begin
    Result := tlp.CachedStyle;
    if tlp.CachedStyle then
      LineStyle := tlp.Style
  end    
  else
    Result := False;
end;

procedure TAdvCustomMemo.ClearLineStyles;
var
  i: Integer;
begin
  for i := 0 to Lines.FlinesProp.Count - 1 do
  begin
    TLineProp(Lines.FlinesProp[i]).CachedStyle := False;
  end;
end;

procedure TAdvCustomMemo.SetLineStyle(Index: Integer; const LineStyle: TStyle);
var
  Tlp:TlineProp;
begin
  Tlp := lines.GetLineProp(index);
  if Tlp = nil then
    tlp := lines.CreateProp(index);
  tlp.Style := LineStyle;
  tlp.CachedStyle := True;
  Lines.SetLineProp(index,tlp);
end;

procedure TAdvCustomMemo.SetExecutable(Index: Integer;
  const Value: Boolean);
var
  Tlp:TlineProp;
begin
  Tlp := lines.GetLineProp(index);
  if Tlp = nil then
    tlp := lines.CreateProp(index);
  tlp.Executable := value;
  Lines.SetLineProp(index,tlp);
  Invalidate;
end;

procedure TAdvCustomMemo.SWAPColors;
var
  c:Tcolor;
begin
  c := FLineBitmap.Canvas.Brush.Color;
  FLineBitmap.Canvas.Brush.Color := FLineBitmap.Canvas.Font.Color;
  FLineBitmap.Canvas.Font.Color := c;
end;

procedure TAdvCustomMemo.ClearBreakpoints;
var
  i: Integer;
begin
  for i := 0 to Lines.FlinesProp.Count - 1 do
  begin
    TLineProp(Lines.FlinesProp[i]).BreakPoint := False;
  end;
  Invalidate;
end;

procedure TAdvCustomMemo.ClearExecutableLines;
var
  i: Integer;
begin
  for i := 0 to Lines.FlinesProp.Count - 1 do
  begin
    TlineProp(Lines.FlinesProp[i]).Executable := False;
  end;
  Invalidate;
end;

//--------------------------------------------------------------
//        DRAW LINE
//--------------------------------------------------------------
procedure TAdvCustomMemo.DrawLine(ACanvas: TCanvas; LineNo: Integer; var style: TStyle;DM: TDrawMode; PR: TRect);
var
  eRect, rct0, rct1, rct, lineRct: TRect;
  LineSelStart, LineSelEnd, posln, i, ep: integer;
  urls: TStringList;
  S, S1, S2, S3: string;
  xSelStartX, xSelStartY, xSelEndX, xSelEndY: integer;
  isinlinecomment:boolean;
  backupstyle:Tstyle;
  backupstring:string;
  LineCanvas: TCanvas;
  Tlp: TLineProp;
  
  function Equal(s1, s2: string): boolean;
  begin
    if FCaseSensitive then
      Result := s1 = s2
    else
      Result := AnsiLowerCase(s1) = AnsiLowerCase(s2);
  end;

  //--------- FIND LINE SELECTION -------------
  procedure FindLineSelection(Selpart: string);
  var
    len: integer;
  begin
    s1 := '';
    s2 := '';
    s3 := '';

    if not Focused and not FSearching then
    begin
      s1 := Selpart;
      Exit;
    end;

    if (lineno < xSelStartY) or (lineno > xSelEndY) then
    begin // outside selection lines (vertically)
      s1 := Selpart;
      Exit;
    end;

    if (xSelStartY < LineNo) and (LineNo < xSelEndY) then
    begin // inside multiple selection
      s2 := Selpart;
      Exit;
    end;

    len := length(Selpart);
    LineSelStart := 0;
    LineSelEnd := 0;

    if (xSelStartY = xSelEndY) then // single line selection
    begin
      if xSelStartX = xSelEndX then
      begin // nothing is selected
        s1 := Selpart;
        exit;
      end;
      if xSelStartX >= posln + len then // selection didn't start
      begin
        s1 := Selpart;
        Exit;
      end;
      if xSelEndX <= posln then // selection ended
      begin
        s3 := Selpart;
        Exit;
      end;
      LineSelStart := xSelStartX - posln;
      LineSelEnd := xSelEndX - posln;
    end
    else
    begin// selection on 2 or more lines
      if (xSelStartY = LineNo) then
      begin
        LineSelStart := xSelStartX - posln;
        LineSelEnd := len;
      end;
      if (xSelEndY = LineNo) then
      begin
        LineSelEnd := xSelEndX - posln;;
      end;
    end;

    if LineSelEnd > len then LineSelEnd := len;
    if LineSelEnd < 0 then LineSelEnd := 0;
    if LineSelStart < 0 then LineSelStart := 0;
    if LineSelStart > len then LineSelStart := len;

    S1 := Copy(Selpart, 1, LineSelStart);
    S2 := Copy(Selpart, LineSelStart + 1, LineSelEnd - LineSelStart);
    S3 := Copy(Selpart, LineSelEnd + 1, len - LineSelEnd);
  end;

  //------------- DRAW PART ---------------------
  procedure DrawPart(Part: string; var Drawstyle: TStyle);
  var
    len, selcol, brushcol: integer;

    procedure loadfromitemstyle;
    begin
      with LineCanvas do
      begin
        try
          Font.Color := FInternalStyles.FAllStyles.Items[DrawStyle.index].Font.Color;
          Font.Style := FInternalStyles.FAllStyles.Items[DrawStyle.index].Font.Style;
          Brush.Color := FInternalStyles.FAllStyles.Items[DrawStyle.index].FBGColor;
        except
          on Exception do
          begin
            Font.Color := Self.Font.Color;
            Font.Style := Self.Font.Style;
            Brush.Color := Self.BkColor;
          end;
        end;
      end;
    end;

  begin
    len := Length(Part);

    if len > 0 then
    begin

      if DM = dmHTML then
      begin
        DrawHTML(part,Drawstyle,lineno);
        inc(posln, length(Part));
        Exit;
      end;
      
      with LineCanvas do
      begin
        Font.Color := Self.Font.Color;
        Font.Style := Self.Font.Style;
        Brush.Color := Self.BkColor;
        begin
          if (DrawStyle.isComment) and (not DrawStyle.isURL) then
          begin
            Font.Color := FInternalStyles.CommentStyle.FTextColor;
            Font.Style := FInternalStyles.CommentStyle.FStyle;
            Brush.Color := FInternalStyles.CommentStyle.FBkColor;
          end
          else
          begin
            if (DrawStyle.isBracket) and (not DrawStyle.isURL) then
              LoadFromItemStyle
            else
            begin
              if DrawStyle.isnumber then
              begin
                Font.Color := FInternalStyles.FNumberStyle.FTextColor;
                Font.Style := FInternalStyles.FNumberStyle.Style;
                Brush.Color := FInternalStyles.FNumberStyle.FBkColor;
              end;
              if DrawStyle.isdelimiter then loadfromitemstyle;
              if DrawStyle.iskeyWord then loadfromitemstyle;
              if DrawStyle.isURL then
              begin
                Font.Color := FUrlStyle.FTextColor;
                Font.Style := FUrlStyle.Style;
                Brush.Color := FUrlStyle.FBkColor;
              end;
            end;
          end;
        end;

        if LineNo = ActiveLine then
        begin
          Font.Color := clYellow;
          Brush.Color := clNavy;
        end;

        if BreakPoint[LineNo] then
        begin
          Font.Color := clWhite;
          Brush.Color := clRed;
        end;


        if part <> '' then
        begin
          FindLineSelection(part);
          selcol := LineCanvas.Font.Color;
          brushcol := LineCanvas.Brush.Color;
          if s1 <> '' then
          begin
            DrawText(LineCanvas.Handle, PChar(s1), length(s1), rct1,
              DT_LEFT or DT_SINGLELINE or DT_NOPREFIX or DT_NOCLIP);
            rct1.Left := rct1.Left + LineCanvas.TextWidth(s1);
          end;
          if s2 <> '' then
          begin
            if (LineNo = ActiveLine) or (BreakPoint[LineNo]) then
              SWAPColors
            else
            begin
              LineCanvas.Font.Color := Self.FSelColor;
              LineCanvas.Brush.Color := Self.FSelBkColor;
            end;
            DrawText(LineCanvas.Handle, PChar(s2), length(s2), rct1,
              DT_LEFT or DT_SINGLELINE or DT_NOPREFIX or DT_NOCLIP);
              rct1.Left := rct1.Left + LineCanvas.TextWidth(s2);
          end;
          if s3 <> '' then
          begin
            LineCanvas.Font.Color := selcol;
            LineCanvas.Brush.Color := brushcol;
            DrawText(LineCanvas.Handle, PChar(s3), length(s3), rct1,
              DT_LEFT or DT_SINGLELINE or DT_NOPREFIX or DT_NOCLIP);
            rct1.Left := rct1.Left + LineCanvas.TextWidth(s3);;
          end;
          Inc(posln, length(Part));
        end;
      end;
    end;
  end;

  procedure bufferingdraw(part:string;var bufstyle: TStyle);

    function egalstyle(stl1,stl2:Tstyle): Boolean;
    begin
      Result :=
      (stl1.isComment       = stl2.isComment) and
      (stl1.isBracket       = stl2.isBracket) and
      (stl1.isnumber        = stl2.isnumber)  and
      (stl1.iskeyWord       = stl2.iskeyWord) and
      (stl1.isdelimiter     = stl2.isdelimiter) and
      (stl1.isURL           = stl2.isURL) and
      (stl1.EndBracket      = stl2.EndBracket) and
      (stl1.index           = stl2.index);
    end;

    procedure resetPartStyle;
    begin
      bufstyle.isnumber := False;
      bufstyle.iskeyWord := False;
      bufstyle.isdelimiter := False;
      bufstyle.isURL := False;
    end;

  begin
    if egalstyle(bufstyle,backupstyle)  then
    begin
      backupstring := backupstring + part;
    end
    else
    begin
      DrawPart(backupstring,backupstyle);
      backupstyle := bufstyle;
      backupstring := part;
    end;
    resetPartStyle;
  end;

  //------------- DRAW SEGMENTS ---------------------
  procedure DrawSegments(S: string; var rct: TRect;
    var SegmentStyle: Tstyle);
  var
    i, j, len, toStart, toEnd, Innr, lc, rc: integer;
    done, WasPoint: boolean;
    validno: boolean;
    part: string;
    numsallowed:string;
  begin
    s := string(PChar(s));
    if not Assigned(FInternalStyles) then
    begin
      BufferingDraw(s, SegmentStyle);
      Exit;
    end;

    if (SegmentStyle.isURL) and (FUrlAware) then
    begin
      BufferingDraw(s, SegmentStyle);
      Exit;
    end;
    
    toStart := 1;
    validno := True;
    done := false;
    while S <> '' do
    begin
      Len := Length(S);
      if (len = 0) or (tostart > len) then
        Exit;
        
      if not done then
      begin
        validno := (toStart = 1) or (s[toStart] = #32) or
          (AnsiPos(S[toStart], FTempdelimiters) > 0);
      end;

      done := False;
      // Parse for multi-line comments

      if (not SegmentStyle.isBracket) then
      if (FInternalStyles.FMultiCommentLeft <> '') and
        (FInternalStyles.FMultiCommentRight <> '') then
      begin
        if SegmentStyle.isComment then
        begin
          rc := ansipos(FInternalStyles.FMultiCommentRight, s);
          if (rc > 0) then
          begin
            BufferingDraw(copy(s, 1,
              rc + length(FInternalStyles.FMultiCommentRight) - 1), SegmentStyle);
            Delete(s, 1, rc + length(FInternalStyles.FMultiCommentRight) - 1);
            SegmentStyle.isComment := False;
            len := length(s);
            if len = 0 then exit;
          end
          else
          begin
            BufferingDraw(s, SegmentStyle);
            exit;
          end;
        end
        else
        begin
          rc := ansipos(FInternalStyles.FLineComment, s);
          // For canceling the multi-line comment
          lc := ansipos(FInternalStyles.FMultiCommentLeft, s);
          if (lc > 0) and ((lc < rc) or (rc = 0)) and (not SegmentStyle.isBracket) then
          begin
            part := copy(s, 1, lc - 1);
            BufferingDraw(part, SegmentStyle);
            Delete(s, 1, (lc - 1) + length(FInternalStyles.FMultiCommentLeft));
            SegmentStyle.isComment := True;
            BufferingDraw(FInternalStyles.FMultiCommentLeft, SegmentStyle);
            len := length(s);
            if len = 0 then exit;
            done := True;
          end
        end;
      end;
      if not done then
      begin
        // line comment
        if (not SegmentStyle.isComment)  then
        begin
          if (AnsiPos(FInternalStyles.LineComment, s) = tostart) and (not SegmentStyle.isBracket) then
          begin
            part := copy(s, tostart, len - tostart + 1);
            SegmentStyle.isComment := True;
            BufferingDraw(part, SegmentStyle);
            isinlinecomment := True;
            Exit;
          end;
          // parse for bracket
          if (SegmentStyle.isBracket) and (SegmentStyle.EndBracket <> #0) then
          begin
            // end of bracket string detected here
            if s[tostart] = SegmentStyle.EndBracket then
            begin
              BufferingDraw(s[tostart], SegmentStyle);
              Delete(s, tostart, 1);
              SegmentStyle.isBracket := False;
              validno := False;
              done := True;
              Continue;
            end
            else
            begin
              BufferingDraw(s[tostart], SegmentStyle);
              inc(tostart);
              len := length(s);
              if tostart > len then
                Exit;
              done := True;
            end;
          end
          else
          begin
            SegmentStyle.EndBracket := #0;
            
            for lc := 0 to FInternalStyles.FAllStyles.Count - 1 do
            begin
              if FInternalStyles.FAllStyles.Items[lc].FStyleType <> stBracket then
                Continue;

              SegmentStyle.EndBracket :=
                FInternalStyles.FAllStyles.Items[lc].Bracket;

              SegmentStyle.index := lc;
              if (SegmentStyle.EndBracket <> #0) and
                (s[toStart] = SegmentStyle.EndBracket) then
              begin
                SegmentStyle.isBracket := True;
                SegmentStyle.EndBracket := FInternalStyles.FAllStyles.Items[lc].Bracket;
                Break;
              end;
            end;

            if SegmentStyle.isBracket then
            begin
              BufferingDraw(s[toStart], SegmentStyle);
              Delete(s, toStart, 1);
              Continue;
            end;
          end;
        end;
      end; //End if not done

      len := length(s);
      if (Len = 0) or (toStart > len) then
        Exit;

      if not done then
        for i := 0 to FInternalStyles.FAllStyles.Count - 1 do
        begin
          if FInternalStyles.FAllStyles.Items[i].FStyleType <> stSymbol then
            Continue;

          if (toStart <= len) and
             (AnsiPos(S[toStart], FInternalStyles.FAllStyles.Items[i].FSymbols) > 0) then
          begin
            SegmentStyle.isDelimiter := True;
            SegmentStyle.index := i;
            BufferingDraw(s[toStart], SegmentStyle);
            Delete(s, toStart, 1);
            validno := True;
            Len := Length(S);
            done := True;
            Break;
          end;
        end;

      if done then
        Continue;

      toEnd := tostart;
      if (len = 0) or (tostart > Len) then
        Exit;

      if validno then
        if (AnsiPos(UpCase(S[tostart]),FtmpNoStart) > 0) then
        begin
          if pos(FtmpNoHex,Uppercase(s)) = toStart then
          begin
            numsallowed := FtmpNo + 'ABCDEF';
            toEnd := toEnd + length(ftmpnohex);
          end
          else
            numsallowed := FtmpNo;

          WasPoint := False;
          Innr := toStart;

          while ((toEnd <= Len) and (AnsiPos(UpCase(S[toEnd]),numsallowed) > 0))  do
          begin
            if UpperCase(copy(s,tostart,toend)) = FtmpNoHex then
              numsallowed := FtmpNo + 'ABCDEF';

            if S[toEnd] = '.' then
            begin
              if WasPoint then
              begin
                toEnd := Innr;
                Break;
              end;
              WasPoint := True;
              Innr := toEnd;
            end;
            Inc(toEnd);
          end;

          Dec(toEnd);

          if (tostart <= toend) then
          begin
            SegmentStyle.isDelimiter := False;
            SegmentStyle.isNumber := True;
            part := copy(s, tostart, toend - tostart + 1);
            Delete(s, tostart, toend - tostart + 1);
            BufferingDraw(part, SegmentStyle);
            validno := False;
            done := True;
          end;
        end;
      if done then continue;

      Len := Length(S);
      if (len = 0) or (tostart > Len) then exit;


      toend := tostart;
      while (toend <= Len) and (S[toend] <> #32) and
        (AnsiPos(S[toend], FTempdelimiters) = 0) do
          Inc(toend);
      part := Copy(S, toStart, toEnd - toStart);
      if (part <> '') and (validno) then
        for i := 0 to FInternalStyles.FAllStyles.Count - 1 do
        begin
          if FInternalStyles.FAllStyles.Items[i].FStyleType = stKeyword then
          begin
            if done then Break;
            for j := 0 to FInternalStyles.FAllStyles.Items[i].FKeyWords.Count - 1 do
              if Equal(part, FInternalStyles.FAllStyles.Items[i].FKeyWords.Strings[j]) then
              begin
                SegmentStyle.iskeyWord := True;
                SegmentStyle.index := i;
                BufferingDraw(part, SegmentStyle);
                Delete(s, toStart, toend - tostart);
                done := True;
                Break;
              end;
          end;
        end;
      if done then continue;

      if not done then
      begin
        BufferingDraw(s[toStart], SegmentStyle);
      end;
      inc(toStart);
    end;
  end;

begin

  if not (DM = dmHTML) then
  begin
    eRect := EditorRect;
    rct := CellRect(0, LineNo - FTopLine);
    rct0 := Rect(eRect.Left, rct.Top, eRect.Right, rct.Bottom);
    lineRct := rct0;
  end;

  case DM of
  dmScreen:  LineCanvas:= FLineBitmap.Canvas;
  dmPrinter: LineCanvas := ACanvas;
  end;

  if LineNo < Lines.Count then
  begin
    rct := rct0;
    S := Lines[LineNo];

    if not (DM = dmHTML) then
    begin
      xSelStartX := FSelStartX;
      xSelEndX := FSelEndX;
      xSelStartY := FSelStartY;
      xSelEndY := FSelEndY;
      OrderPos(xSelStartX, xSelStartY, xSelEndX, xSelEndY);
      rct1 := rct;
      rct1.Left := rct1.Left - eRect.Left;
      rct1.Right := rct1.Right - eRect.Left;
      rct1.Top := rct1.Top - rct.Top;
      rct1.Bottom := rct1.Bottom - rct.Top;
      rct1.Left := rct1.Left - FLeftCol * FCellSize.W;
    end;

    if DM = dmPrinter then
      OffsetRect(rct1,0,PR.Top);

    posln := 0;

    urls := TStringList.Create;
    backupstyle := style;
    ExtractURL(s, urls);
    isinlinecomment := False;

    for i := 0 to urls.Count - 1 do
    begin
      if FUrlAware then
        style.isURL := (ansipos('http://', LowerCase(urls.Strings[i])) = 1) or
          (ansipos('mailto:', LowerCase(urls.Strings[i])) = 1)
      else
        style.isURL := False;

      DrawSegments(urls.Strings[i], rct1, style);
    end;

    urls.Free;

    DrawPart(BackupString,BackupStyle);

    if isinlinecomment then
      style.isComment := False;

    if (DM = dmHTML) then
      Exit;

    with LineCanvas do
    begin
      if BreakPoint[LineNo] then
        Brush.color := clRed
      else
      begin
        if LineNo = ActiveLine then
          Brush.color := clNavy
        else
         Brush.Color := BkColor;
      end;
       FillRect(rct1);

      Tlp := Lines.GetLineProp(LineNo);

      if Assigned(Tlp) then
      begin
        for ep := 1 to Tlp.FErrStart.Count do
        begin
          DrawError(LineCanvas,Rect(Tlp.FErrStart.Items[ep - 1] * FCellSize.W,FCellSize.H - 2,
            (Tlp.FErrStart.Items[ep - 1] + Tlp.FErrLen.Items[ep - 1]) * FCellSize.W,FCellSize.H - 2));
        end;
      end;

      if (LineNo = BSelLine) and (BSelStart >= 0) then
      begin
        LineCanvas.Pen.Color := FBlockLineColor;
        LineCanvas.MoveTo(BSelStart * FCellSize.W,FCellSize.H - 2);
        LineCanvas.LineTo((BSelStart + BSelLen) * FCellSize.W,FCellSize.H - 2);
      end;
    end;

    if DM = dmScreen then
      with LineRct do
        BitBlt(ACanvas.Handle, Left, Top, Right - Left, Bottom - Top,
          LineCanvas.Handle, 0, 0, SRCCOPY);


  end
  else
    with ACanvas do
    begin
      Brush.Color := BkColor;
      case DM of
      dmScreen: FillRect(rct0);
      dmPrinter: FillRect(PR);
      end;
    end;
end;

procedure TAdvCustomMemo.Paint;
var
  eRect,pRect: TRect;
  i: integer;
  clipRgn: HRGN;
  LineStyle: TStyle;
begin
  if TAdvMemoStrings(Lines).FLockCount > 0 then
    Exit;

  with Canvas do
  begin
    if FCellSize.H = 0 then
      SetFont(FFont);
    FreshLineBitmap;
    DrawGutter;
    DrawMargin;


    if BorderStyle <> bsNone then
    begin
      if Ctl3D then
        Border(Canvas, Rect(-10, - 10, Width , Height), btLowered)
      else
      begin
        Pen.Color := clGray;
        Pen.Width := 1;
        MoveTo(0, Height);
        LineTo(0, 0);
        LineTo(Width-1, 0);
        LineTo(Width-1, Height-1);
        LineTo(0,Height-1);
      end;
    end;

    eRect := EditorRect;
    Canvas.Brush.color := FbkColor;
    Canvas.Pen.Color := FBkColor;
    FillRect(eRect);

    clipRgn := CreateRectRgn(eRect.Left, eRect.Top, eRect.Right, eRect.Bottom);
    ExtSelectClipRgn(Canvas.Handle, clipRgn, RGN_AND);
    DeleteObject(clipRgn);

    if TopLine = FbackupTopLine then
      LineStyle := FbackupTopStyle
    else
    begin
      FLetRefresh := False;
      LineStyle := GetUpStyle(TopLine);
      FLetRefresh := True;      
      FbackupTopStyle := LineStyle;
      FbackupTopLine := TopLine;
    end;

    if Assigned(FInternalStyles) then
    begin
      FtmpNoStart := UpperCase(FInternalStyles.FNumericChars + FInternalStyles.FHexIdentifier);
      FtmpNo := UpperCase(FInternalStyles.FNumericChars) + 'E';
      FtmpNoHex := Uppercase(FInternalStyles.FHexIdentifier);
    end
    else
    begin
      FtmpNoStart := '';
      FtmpNo := '';
    end;

    for i := FTopLine to FTopLine + VisibleLineCount do
    begin
      if Lines.Count <= i then
        Break;
      DrawLine(Canvas,i,LineStyle,dmScreen,pRect);
    end;
  end;
  inherited;
end;

//--------------------------------------------------------------
//        GET VISIBLE
//--------------------------------------------------------------
function TAdvCustomMemo.GetVisible(Index: integer): integer;
var
  Coord: TFullPos;
  Cell: TCellPos;
  eRect: TRect;
begin
  eRect := EditorRect;
  Coord := CharFromPos(eRect.Right - 1, eRect.Bottom - 1);
  Cell := CellFromPos(eRect.Right - 1, eRect.Bottom - 1);
  case Index of
    0: Result := Cell.X;
    1: Result := Cell.Y;
    2: Result := Coord.Pos - 1;
    3: Result := Coord.LineNo - 1;
    else
      Result := 0;
  end;
end;

//--------------------------------------------------------------
//        MAKE VISIBLE
//--------------------------------------------------------------

procedure TAdvCustomMemo.MakeVisible;
var
  Modified: boolean;
begin

  Modified := False;
  if CurX < FLeftCol then
  begin
    FLeftCol := CurX - 2;
    if FLeftCol < 0 then FLeftCol := 0;
    Modified := True;
  end;

  if CurX > LastVisiblePos then
  begin
    if (FScrollBars in [ssBoth, ssHorizontal]) or
      (ScrollMode = smAuto) then
    begin
      FLeftCol := FLeftCol + CurX - LastVisiblePos + 2;
      if FLeftCol < 0 then
        FLeftCol := 0;
    end
    else
      CurX := LastVisiblePos;
    Modified := True;
  end;

  if CurY < FTopLine then
  begin
    FTopLine := CurY;
    if FTopLine < 0 then
      FTopLine := 0;
    Modified := True;
  end;

  if CurY > LastVisibleLine then
  begin
    if (FScrollBars in [ssBoth, ssVertical]) or
      (ScrollMode = smAuto) then
    begin
      FTopLine := FTopLine + CurY - LastVisibleLine;
    end
    else
      CurY := LastVisibleLine;
    Modified := True;
  end;

  if Modified then
    Invalidate;
end;
//--------------------------------------------------------------
//        RESIZE EDITOR
//--------------------------------------------------------------

procedure TAdvCustomMemo.ResizeEditor;
begin
  ResizeScrollBars;
  ResizeGutter;
  MakeVisible;
  Invalidate;
end;

//--------------------------------------------------------------
//        RESIZE SCROLLBARS
//--------------------------------------------------------------
procedure TAdvCustomMemo.ResizeScrollBars;
var
  eRect, sbRect: TRect;
  MaxLen, OldMax: integer;
  V,H:Boolean;
begin
  if not (FScrollBars in [ssBoth, ssVertical]) then
    sbVert.Visible := False;
  if not(FScrollBars in [ssBoth, ssHorizontal]) then
    sbHorz.Visible := False;

  if not FLetRefresh then
    Exit;

  V := sbVert.Visible;
  H := sbHorz.Visible;
  eRect := EditorRect;

  if FScrollBars in [ssBoth, ssVertical] then
  begin
    with sbVert do
    begin
      Width := 16;
      Height := eRect.Bottom - eRect.Top + 1;
      Left := eRect.Right;
      if (VisibleLineCount > 0) and
        (Lines.Count > VisibleLineCount) then
      begin
        oldmax := max;
        position := Ftopline;
        if oldmax <> Lines.Count then
          sbVert.max := Lines.Count;
        sbVert.pagesize := VisibleLineCount + 1;
        sbVert.Visible := true;
        sbRect := sbVert.ClientRect;
        InvalidateRect(Handle, @sbRect, True);
      end
      else
      begin
        sbVert.pagesize := -1;
        FTopLine:=0;
        sbVert.visible := False;
      end;
    end;
  end;

  if FScrollBars in [ssBoth, ssHorizontal] then
  begin
    MaxLen := MaxLength;
    with sbHorz do
    begin
      if FScrollBars = ssBoth then
        Width := Width - sbVert.Width;
      Height := 16;
      Left := 2;
      Top := eRect.Bottom;
     if (VisiblePosCount > 0) and
        (MaxLen > VisiblePosCount) then
      begin
        oldmax := sbHorz.max;
        if oldmax <> MaxLen then
          sbHorz.max := MaxLen;
        sbHorz.PageSize := VisiblePosCount + 1;
        Position := FLeftCol;
        sbHorz.Visible :=  true;
        sbRect := sbHorz.ClientRect;
        InvalidateRect(Handle, @sbRect, True);
      end
      else
      begin
        if curx < VisiblePosCount then
        begin
        sbHorz.Visible := False;
        sbHorz.PageSize := -1;
        end;
        FLeftCol := 0;
      end;
    end;
  end;


  if (sbVert.Visible <> V) or (sbHorz.Visible <> h) then
    ResizeScrollBars;

  FGutter.Invalidate;
  eRect := EditorRect;
  InvalidateRect(Handle, @eRect, True);
  if FScrollBars in [ssBoth, ssVertical] then
    ScrollVChange(nil);
  if FScrollBars in [ssBoth, ssHorizontal] then
    ScrollHChange(nil);
end;

//--------------------------------------------------------------
//        RESIZE GUTTER
//--------------------------------------------------------------
procedure TAdvCustomMemo.ResizeGutter;
var
  eRect: TRect;
begin
  eRect := EditorRect;
  with FGutter do
  begin
    Height := eRect.Bottom - eRect.Top;
  end;
end;

procedure TAdvCustomMemo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FInternalStyles) then
  begin
    FInternalStyles := nil;
    inherited;
    Invalidate;
    Exit;
  end;
  inherited;
end;

//--------------------------------------------------------------
//        CREATE PARAMS
//--------------------------------------------------------------
procedure TAdvCustomMemo.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or WS_CLIPCHILDREN;
end;

//--------------------------------------------------------------
//        UNDO, REDO
//--------------------------------------------------------------
procedure TAdvCustomMemo.Undo;
begin
  FUndoList.Undo;
end;

procedure TAdvCustomMemo.Redo;
begin
  FUndoList.Redo;
end;

//--------------------------------------------------------------
//        SET UNDO LIMIT
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetUndoLimit(Value: integer);
begin
  if (FUndoLimit <> Value) then 
  begin
    if Value <= 0 then Value := 1;
    if Value > 100 then Value := 100;
    FUndoLimit := Value;
    FUndoList.Limit := Value;
  end;
end;

//--------------------------------------------------------------
//        UNDO (REDO) CHANGE
//--------------------------------------------------------------
procedure TAdvCustomMemo.UndoChange;
begin
  if Assigned(FOnUndoChange) then
    FOnUndoChange(Self, FUndoList.Pos < FUndoList.Count,
      FUndoList.Pos > 0);
end;

//--------------------------------------------------------------
//        CAN UNDO
//--------------------------------------------------------------
function TAdvCustomMemo.CanUndo: boolean;
begin
  Result := FUndoList.FPos < FUndoList.Count;
end;

//--------------------------------------------------------------
//        CAN REDO
//--------------------------------------------------------------
function TAdvCustomMemo.CanRedo: boolean;
begin
  Result := FUndoList.FPos > 0;
end;

//--------------------------------------------------------------
//        CLEAR UNDO LIST
//--------------------------------------------------------------
procedure TAdvCustomMemo.ClearUndoList;
begin
  FUndoList.Clear;
end;

//--------------------------------------------------------------
//        SET SCROLL BARS
//--------------------------------------------------------------
procedure TAdvCustomMemo.SetScrollBars(Value: TScrollStyle);
begin
  if FScrollBars <> Value then
  begin
    FScrollBars := Value;
    ResizeEditor;
    Invalidate;
  end;
end;

//--------------------------------------------------------------
//        CREATE
//--------------------------------------------------------------
constructor TAdvCustomMemo.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csCaptureMouse, csClickEvents,
    csDoubleClicks, csReplicatable ];
  FAutoCompletionWidth := 200;
  FletgetCaretTime:=true;
  FCaretX := 0;
  FCarety := 0;
  FBlockShow := True;
  FBlockLineColor := clGray;
  FAutoCompletionHeight := 100;
  FAutoCompletion := True;
  FBackupTopLine := -1;
  FGutterWidth := 45;
  FUrlAware := True;
  FUrlStyle := TCharStyle.Create;
  FUrlStyle.FTextColor := clBlue;
  FUrlStyle.FBkColor := clWhite;
  FUrlStyle.FStyle := [fsUnderline];
  FUrlDelimiters := #32#34#39#44;
  FLetRefresh := True;
  FLineNumbers := True;
  Width := 100;
  Height := 40;
  TabStop := True;
  Cursor := crIBeam;
  FBorderStyle := bsSingle;
  FCtl3D := False;
  FActiveLine := -1;
  FCaseSensitive := False;
  FFont := TFont.Create;
  FFont.Name := 'Courier New';
  FFont.Size := 10;
  FFont.OnChange := FontChanged;
  Canvas.Font.Assign(FFont);
  FHintShowing := False;
  FHiddenCaret := False;
  FCaretVisible := False;
  html := TStringList.Create;
  FCurX := 0;
  FCurY := 0;
  FLeftCol := 0;
  FTopLine := 0;
  FTabSize := 4;
  FMargin := 2;
  FAutoIndent := True;
  FLines := TAdvMemoStrings.Create;
  FLines.Add(''); // Please leave the add here, before assigning OnChange
  FLines.OnChange := LinesChanged;
  FLines.Memo := Self;
  FPrintOptions := TPrintOptions.Create;

  FScrollBars := ssBoth;
  sbVert := TScrollBar.Create(Self);
  with sbVert do
  begin
    Parent := Self;
    Visible := False;
    Kind := sbVertical;
    Align := alRight;
    Top := 0;
    Width := 16;
    DoubleBuffered := True;
    TabStop := False;
    SmallChange := 1;
    pagesize := -1;
    ControlStyle := ControlStyle + [csNoDesignVisible];
    OnScroll := ScrollBarScroll;
    OnChange := ScrollVChange;
    Enabled := True;
  end;

  sbHorz := TScrollBar.Create(Self);
  with  sbHorz do
  begin
    Kind := sbHorizontal;
    Align := alBottom;
    Visible := False;
    Parent := self;
    Height := 16;
    DoubleBuffered := True;
    TabStop := False;
    pagesize := -1;
    ControlStyle := ControlStyle + [csNoDesignVisible];
    OnScroll := ScrollBarScroll;
    OnChange := ScrollHChange;
  end;

  FGutter := TAdvGutter.Create;
  with FGutter do
  begin
    FLeft := 1;
    FTop := 1;
    FWidth := 45;
    FHeight := 0;
    FColor := clBtnFace;
    FColorTo := clNone;
    Memo := Self;
  end;

  FSelStartX := 0;
  FSelStartY := 0;
  FSelEndX := 0;
  FSelEndY := 0;

  FBkColor := clWhite;
  FSelColor := clWhite;
  FSelBkColor := clNavy;

  FSelCharPos.LineNo := -1;
  FSelCharPos.Pos := -1;

  FLineBitmap := TBitmap.Create;

  FLeftButtonDown := False;
  FScrollMode := smAuto;

  FUndoList := TAdvUndoList.Create;
  FUndoList.Memo := Self;

  FUndoLimit := 100;
  FSearching := False;
  {$IFDEF DELPHI4_LVL}
  FormAutocompletion:=TAdvAutoform.CreateNew(self,0);
  {$ELSE}
  FormAutocompletion := TAdvAutoform.CreateNew(self);
  {$ENDIF}
  FormAutocompletion.BorderStyle := bsNone;
  FormAutocompletion.FormStyle := fsStayOnTop;
  FormAutocompletion.Visible := False;
  FormAutocompletion.OnClose := FormClose;

  Flistcompletion := TListBox.Create(FormAutocompletion);
  Flistcompletion.Parent := FormAutocompletion;
  Flistcompletion.Align := alClient;
  Flistcompletion.Cursor := crArrow;
  FListcompletion.Ctl3D := False;

  {$IFDEF DELPHI4_LVL}
    FHintForm := TAdvHintform.CreateNew(self,0);
  {$ELSE}
    FHintForm := TAdvHintform.CreateNew(self);
  {$ENDIF}

  FHintForm.BorderStyle := bsnone;
  FHintForm.FormStyle := fsStayOnTop;
  FHintForm.Visible := False;
  FHintForm.OnClose := FormHintClose;

  FHintForm.OnMouseDown := FormHintMouseDown;

  Timer := TTimer.Create(nil);
  Timer.OnTimer := TimerHint;
  Timer.Interval := 2500;
  Timer.Enabled := False;
  FAutoHintParameters := hpAuto;

  BSelLine := -1;
  BSelStart := -1;
  BSelLen := -1;
end;

function TAdvCustomMemo.GetCursorEx: TCursor;
begin
  Result := inherited Cursor;
end;

procedure TAdvCustomMemo.SetCursorEx(const Value: TCursor);
begin
  inherited Cursor := Value;
  FoldCursor := Value;
end;

function TAdvCustomMemo.WordAtCursor: string;
var
  p: integer;

begin
  Result := WordAtCursorPos(p);
end;

function TAdvCustomMemo.WordAtCursorPos(var Pos: Integer): string;
var
  s:string;
  i: integer;
  fb, fe: integer;
begin
  Result := '';

  if Lines.Count = 0 then
    Exit
  else
    if Lines.Count <= CurY then
      CurY := Lines.Count - 1;

  s := Lines.Strings[CurY];

  if (CurX > Length(s)) then
      Exit;

  fe := CurX;
  fb := CurX + 1;

  for i := CurX + 1 to Length(s) do
    if not IsWordBoundary(s[i]) then
      fe := i
  else
    Break;

  for i := CurX downto 1 do
    if not IsWordBoundary(s[i]) then
      fb := i
  else
    Break;
  Pos := fb;
  Result := Copy(s,fb,fe - fb + 1);
end;


procedure TAdvCustomMemo.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  s: string;
  i: integer;
  fb, fe: integer;
begin
  if Message.XPos < GutterWidth then
    Exit;

  if not PointInRect(Point(Message.xpos, Message.YPos), EditorRect) then Exit;
  if Message.XPos > Width then
    Exit;

  s := Lines.Strings[CurY];

  if (CurX + 1 > Length(s)) or IsWordBoundary(s[CurX + 1]) then
      Exit;

  fe := 0;
  fb := 0;

  for i := CurX to Length(s) do
    if not IsWordBoundary(s[i]) then
      fe := i
  else
    Break;

  for i := CurX downto 1 do
    if not IsWordBoundary(s[i]) then
      fb := i - 1
  else
    Break;

  ClearSelection;

  if (fb < Fe) then
  begin
    FSelStartX := fb;
    FSelEndX := fe;
    FSelStartY := curY;
    FSelEndY := curY;
  end;
  SelectionChanged;
  Invalidate;
end;

function TAdvCustomMemo.IsWordBoundary(ch: char): boolean;
begin
  Result := (ch = #32);
end;

procedure TAdvCustomMemo.LinesChanged(Sender: TObject);
begin
  if FLetRefresh then
  begin
    if Assigned(FOnChange) then
      FOnChange(Self);
    SetMaxLength;
    ResizeScrollBars;
    Invalidate;
  end;
end;

//--------------------------------------------------------------
//        DESTROY
//--------------------------------------------------------------
destructor TAdvCustomMemo.Destroy;
begin
  FPrintOptions.Free;
  html.Free;
  FLines.OnChange := nil;
  FFont.Free;
  FLines.Free;
  FGutter.Free;
  sbVert.Free;
  sbHorz.Free;
  FurlStyle.Free;
  FLineBitmap.Free;
  FUndoList.Free;
  Flistcompletion.Free;
  FormAutocompletion.Free;
  Timer.Enabled := False;
  Timer.Free;
  FHintForm.Free;
  inherited Destroy;
end;

function TAdvCustomMemo.EditCanModify: Boolean;
begin
  Result := True;
end;

function HTMLClr(color: TColor): string;
begin
  Result := '#'+inttohex(GetRValue(color),2)+
                inttohex(GetGValue(color),2)+
                inttohex(GetBValue(color),2);
end;

procedure TAdvCustomMemo.Print;
var
  hstl: TStyle;
  i: Integer;
  pRect: TRect;
  cRect: TRect;
  th: Integer;
  Page: Integer;

  procedure PrintCentered(ACanvas: TCanvas; s: string; r: TRect);
  var
    tw: Integer;
  begin
    ACanvas.Font.Assign(Font);
    tw := ACanvas.TextWidth(s);
    if tw < r.Right - r.Left then
      r.Left := r.Left + ((r.Right - r.Left) - tw) div 2;

    ACanvas.TextOut(r.Left,r.Top,s);
  end;

begin
  hstl.isComment := False;
  hstl.isBracket := False;
  hstl.isnumber := False;
  hstl.iskeyWord := False;
  hstl.isdelimiter := False;
  hstl.isURL := False;
  hstl.EndBracket := #0;
  hstl.index := 0;

  with Printer do
  begin
    if PrintOptions.JobName <> '' then
      Title := PrintOptions.JobName
    else
      Title := 'AdvMemo print job';

    BeginDoc;
    Canvas.Font.Assign(Font);
    cRect := Canvas.ClipRect;

    cRect.Left := cRect.Left + PrintOptions.MarginLeft;
    cRect.Right := cRect.Right - PrintOptions.MarginRight;
    cRect.Top := cRect.Top + PrintOptions.MarginTop;
    cRect.Bottom := cRect.Bottom - PrintOptions.MarginBottom;

    th := Canvas.TextHeight('gh') + 2;
    pRect := Rect(cRect.Left,cRect.Top,cRect.Right,cRect.Top + th);

    if PrintOptions.Title <> '' then
    begin
      PrintCentered(Printer.Canvas,PrintOptions.Title,pRect);
      OffsetRect(pRect,0,th);
    end;

    Page := 1;

    for i := 1 to Lines.Count do
    begin
      DrawLine(Canvas,i - 1,hstl,dmPrinter,pRect);
      OffsetRect(pRect,0,th);

      if (pRect.Bottom > cRect.Bottom) or
         (PrintOptions.PageNr and (pRect.Bottom + th > cRect.Bottom))  then
      begin
        if PrintOptions.PageNr then
          PrintCentered(Printer.Canvas,PrintOptions.PagePrefix+ ' '+IntToStr(Page),pRect);

        NewPage;
        pRect := Rect(cRect.Left,cRect.Top,cRect.Right,cRect.Top + th);
        if PrintOptions.Title <> '' then
        begin
          PrintCentered(Printer.Canvas,PrintOptions.Title,pRect);
          OffsetRect(pRect,0,th);
        end;
        inc(Page);
      end;
    end;

    if PrintOptions.PageNr then
    begin
      pRect := Rect(cRect.Left,cRect.Bottom - th,cRect.Right,cRect.Bottom);
      PrintCentered(Printer.Canvas,PrintOptions.PagePrefix+ ' '+IntToStr(Page),pRect);
    end;

    EndDoc;
  end;
end;

function TAdvCustomMemo.SaveToHTML(FileName: string;
                                   Fixedfonts:Boolean = True): Boolean;
begin
  Result := False;
  OutputHTML(FixedFonts);
  try
    html.SaveToFile(FileName);
    Result := True;
  except
    on Exception do;
  end;
end;

procedure TAdvCustomMemo.CopyHTMLToClipboard;
begin
  OutputHTML(False);
  ClipBoard.SetTextBuf(PChar(html.Text));
end;

procedure TAdvCustomMemo.DoFind;
begin
  if Assigned(FonFind) then
    FOnFind(self);
end;

procedure TAdvCustomMemo.DoReplace;
begin
  if Assigned(FonReplace) then
    FOnReplace(self);
end;

procedure TAdvCustomMemo.OutputHTML(Fixedfonts:Boolean);
var
  i: Integer;
  hstl: TStyle;
  pRect: TRect;
begin
  html.Clear;
  html.Add('<!-- saved from TAdvMemo -->');
  html.Add('<HTML>');
  html.Add('<BODY bgColor='+HTMLClr(FBkColor)+' LINK='+HTMLClr(UrlStyle.FTextColor)+' VLINK='+HTMLClr(UrlStyle.FTextColor)+' ALINK='+HTMLClr(UrlStyle.FTextColor)+'>');
  html.Add('<PRE>');

  if FixedFonts then
    html.Add('<FONT style="font-family:' + Font.Name + '; font-size:' + IntToStr(font.Size)+'">')
  else
    html.Add('<FONT style="font-family:' + Font.Name + ';">');

  hstl.isComment := False;
  hstl.isBracket := False;
  hstl.isnumber := False;
  hstl.iskeyWord := False;
  hstl.isdelimiter := False;
  hstl.isURL := False;
  hstl.EndBracket := #0;
  hstl.index := 0;
  htmlfont := '';

  for i := 0 to Lines.Count - 1 do
  begin
    html.Add('');
    DrawLine(Canvas,i,hstl,dmHTML,pRect);
  end;

  if htmlfont<>'' then
    html.Add('</FONT>');

  html.Add('</FONT>');
  html.Add('</PRE>');
  html.Add('</BODY>');
  html.Add('</HTML>');
end;

procedure TAdvCustomMemo.DrawHTML(Part: string; var Drawstyle: Tstyle;lineno:integer);
var
  bc,c:Tcolor;
  sl:Tfontstyles;
  localhtmlfont,shtml:string;

  procedure loadfromitemstyle;
  begin
    with FLineBitmap.Canvas do
    begin
      try
        C := FInternalStyles.FAllStyles.Items[DrawStyle.index].Font.Color;
        Sl := FInternalStyles.FAllStyles.Items[DrawStyle.index].Font.Style;
        BC := FInternalStyles.FAllStyles.Items[DrawStyle.index].FBGColor;
      except
        on Exception do
        begin
          C  := Self.Font.Color;
          Sl := Self.Font.Style;
          BC := Self.BkColor;
        end;
      end;
    end;
  end;

  function tagstrl(stc:Tfontstyles):string;
  var
    rz:string;
  begin
    rz := '';
    if fsbold in stc then rz := rz + ' bold';
    if fsItalic in stc then rz := rz + ' italic';
    if rz <> '' then rz := 'font:'#39 + rz + #39';';
    if fsUnderline in stc then
       rz := rz+'text-decoration:'#39+'underline'+#39';';
    Result := rz;
  end;

begin
  if html.Count<=0 then exit;
  C := Self.Font.Color;
  Sl:= Self.Font.Style;
  BC := Self.BkColor;
  begin
    if (DrawStyle.isComment) and (not DrawStyle.isURL) then
    begin
      C := FInternalStyles.CommentStyle.FTextColor;
      SL := FInternalStyles.CommentStyle.FStyle;
      BC := FInternalStyles.CommentStyle.FBkColor;
    end
    else
    begin
      if (DrawStyle.isBracket) and (not DrawStyle.isURL) then loadfromitemstyle
      else
      begin
        if DrawStyle.isnumber then
        begin
          C  := FInternalStyles.FNumberStyle.FTextColor;
          SL := FInternalStyles.FNumberStyle.Style;
          BC := FInternalStyles.FNumberStyle.FBkColor;
        end;
        if DrawStyle.isdelimiter then loadfromitemstyle;
        if DrawStyle.iskeyWord then loadfromitemstyle;
        if DrawStyle.isURL then
        begin
          C := FurlStyle.FTextColor;
          SL := FurlStyle.Style;
          BC := FurlStyle.FBkColor;
        end;
      end;
    end;
  end;

  if part <> '' then
  begin
    // Needded only for HTTP comment rest of simbols solved by tag <PRE>
    part := StringReplace(part,'<','&lt',[rfReplaceAll]);
    part := StringReplace(part,'>','&gt',[rfReplaceAll]);

    if Drawstyle.isURL then
      part := '<a href="' + part + '">' + part + '</a>';
    localhtmlfont := '<FONT style="background-color: ' + HTMLClr(bc) +';color:' + HTMLClr(C) +';'+tagstrl(sl)+'">';
    if localhtmlfont=htmlfont then
      shtml := html.Strings[html.Count-1]+part
    else
    begin
      if htmlfont <> '' then
        shtml := html.Strings[html.Count - 1]+'</FONT>'+localhtmlfont+part
      else
        shtml := html.Strings[html.Count - 1]+localhtmlfont+part;
    end;
    htmlfont := localhtmlfont;
    html.Strings[html.Count - 1] := shtml;
  end;
end;

procedure TAdvCustomMemo.WMCommand(var Message: TWMCommand);
begin
  case message.itemid of
  1: CopyToClipboard;
  2: CutToClipboard;
  3: PasteFromClipboard;
  4: SelectAll;
  end;
end;

procedure TAdvCustomMemo.WMContextMenu(var Message: TWMContextMenu);
var
  popmenu: THandle;
  OldCursor: TCursor;
begin
  SetFocus;
  inherited;
  if not Assigned(PopupMenu) then
  begin
    popMenu := CreatePopupMenu;

    clipboard.HasFormat(cf_Text);

    if SelLength > 0 then
    begin
      InsertMenu(popmenu,$FFFFFFFF,MF_BYPOSITION ,1,pchar('Copy'#9'Ctrl-C'));
      InsertMenu(popmenu,$FFFFFFFF,MF_BYPOSITION ,2,pchar('Cut'#9'Ctrl-X'));
    end
    else
    begin
      InsertMenu(popmenu,$FFFFFFFF,MF_BYPOSITION or MF_GRAYED ,1,pchar('Copy'#9'Ctrl-C'));
      InsertMenu(popmenu,$FFFFFFFF,MF_BYPOSITION or MF_GRAYED ,2,pchar('Cut'#9'Ctrl-X'));
    end;

    if Clipboard.HasFormat(cf_Text) then
      InsertMenu(popmenu,$FFFFFFFF,MF_BYPOSITION ,3,pchar('Paste'#9'Ctrl-V'))
    else
      InsertMenu(popmenu,$FFFFFFFF,MF_BYPOSITION or MF_GRAYED,3,pchar('Paste'#9'Ctrl-V'));

    InsertMenu(popmenu,$FFFFFFFF,MF_SEPARATOR ,0,pchar('null'));
    InsertMenu(popmenu,$FFFFFFFF,MF_BYPOSITION ,4,pchar('Select All'#9'Ctrl-A'));
    OldCursor := Cursor;
    Cursor := crDefault;
    TrackPopupMenu(popmenu,TPM_LEFTALIGN or TPM_LEFTBUTTON,Message.XPos,Message.YPos,0,Handle,nil);

    DestroyMenu(popmenu);

    Cursor := OldCursor;
  end;
end;

//-------------------- SET PARAMS -----------------------
procedure TAdvGutter.SetParams(Index: integer; Value: integer);
begin
  case Index of
  0: FLeft := Value;
  1: FTop := Value;
  2: FWidth := Value;
  3: FHeight := Value;
  end;
end;

//-------------------- PAINT TO -----------------------
procedure TAdvGutter.PaintTo(ACanvas: TCanvas);
var
  LineNo, T, H: integer;
begin
  with ACanvas do
  begin
    Pen.Color := clGray;
    MoveTo(Left + Width - 1, Top);
    LineTo(Left + Width - 1, Top + Height);
    Pen.Color := clWhite;
    MoveTo(Left + Width - 2, Top);
    LineTo(Left + Width - 2, Top + Height);
    Brush.Color := Self.FColor;

    if FColorTo = clNone then
      FillRect(Rect(Left, Top, Left + Width - 2, Top + Height))
    else
      DrawGradient(ACanvas,FColor,FColorTo,48,Rect(Left,Top,Left+Width-2,Top+Height),True);  

    if Assigned(Memo.OnGutterDraw) then
    begin
      T := Top;
      H := Memo.FCellSize.H;
      LineNo := Memo.FTopLine;
      while T < Top + Height do
      begin
        Memo.OnGutterDraw(Memo, ACanvas, LineNo, Rect(Left, T, Left + Width - 2, T + H));
        T := T + H;
        Inc(LineNo);
        if LineNo >= Memo.Lines.Count then
          Break;
      end;
    end;
  end;
end;

//-------------------- INVALIDATE -----------------------
procedure TAdvGutter.Invalidate;
var
  gRect: TRect;
begin
  gRect := Rect(Left, Top, Left + Width, Top + Height);
  InvalidateRect(Memo.Handle, @gRect, True);
end;

//-------------------- GET RECT -----------------------
function TAdvGutter.GetRect: TRect;
begin
  Result := Rect(Left, Top, Left + Width, Top + Height);
end;

//--------------------------------------------------------------
//        Adv MEMO STRINGS
//--------------------------------------------------------------
destructor TAdvMemoStrings.Destroy;
begin
  ClearLinesProp;
  FlinesProp.Free;
  FListLengths.Free;
  inherited;
end;

//-------------------- ADD ----------------------
function TAdvMemoStrings.DoAdd(const S: string): integer;
begin
  Result := TStringList(Self).Add(s);
end;

//-------------------- DO INSERT ----------------------
procedure TAdvMemoStrings.DoInsert(Index: integer; const S: string);
var
  s1:string;
begin
  if Assigned(memo) then
  begin
    s1 := StringReplace(S,#9,stringofchar(#32,memo.tabsize),[rfreplaceall]);
    if index < memo.FTopLine then memo.FbackupTopLine:=-1;
    FListLengths.Insert(Index,pointer(length(s1)));
    inherited Insert(Index,s1);
  end
  else
  begin
    FListLengths.Insert(Index,pointer(length(s)));
    inherited Insert(Index, s);
  end;
end;

//-------------------- DELETE ----------------------
procedure TAdvMemoStrings.Delete(Index: integer);
var
  SaveCurY, SaveCurX: integer;
begin
  if (Index < 0) or (Index > Count - 1) then Exit;
  if FDeleting or (not Assigned(Memo)) then
  begin
    FListLengths.Delete(index);
    inherited;
  end
  else
  begin
    if index<memo.FTopLine then memo.FbackupTopLine:=-1;
    FDeleting := True;
    SaveCurX := Memo.CurX;
    SaveCurY := Memo.CurY;
    if Index < SaveCurY then Dec(SaveCurY);
    if Count = 1 then SaveCurX := 0;
    Memo.CurY := Index;
    Memo.DeleteLine;
    Memo.CurX := SaveCurX;
    Memo.CurY := SaveCurY;
    FDeleting := False;
  end;
end;

procedure TAdvMemoStrings.Insert(Index: integer; const S: string);
begin
  Memo.ClearSelection;
  DoInsert(index,s);
  Memo.curx := Memo.curx;
  Memo.curY := Memo.curY;
  Memo.Invalidate;
end;

//-------------------- LOAD FROM FILE ----------------------
procedure TAdvMemoStrings.LoadFromFile(const FileName: string);
var
  i,len,mx:integer;
  s:string;
begin
  with Memo do
  begin
    ClearSelection;
    ClearUndoList;
    CurX := 0;
    CurY := 0;
    FLetRefresh := False;
  end;
  Memo.Lines.OnChange := nil;
  inherited LoadFromFile(FileName);
  Memo.FbackupTopLine := -1;
  Memo.CurX := 0;
  Memo.CurY := 0;
  mx := 0;
  for i := 0 to Memo.Lines.Count - 1 do
  begin
    s := StringReplace(Strings[i],#9,stringofchar(#32,memo.TabSize),[rfreplaceall]);
    Strings[i] := s;
    len := Length(s);
    if len > mx then
      mx := len;
  end;
  Memo.FmaxLength := mx;
  memo.Lines.OnChange := Memo.LinesChanged;
  Memo.FLetRefresh := True;
  Memo.LinesChanged(nil);
  Memo.Refresh;
end;

//-------------------- GET OBJECT ---------------------------
function  TAdvMemoStrings.GetObject(Index: Integer): TObject;
begin
  Result := nil;

  if (Index >= 0) and (Index < Count) then
  begin
    Result := inherited GetObject(Index);
    if Assigned(Result) and (Result is TLineProp) then
      Result := TLineProp(Result).FObject;
  end;
end;

//-------------------- PUT OBJECT ---------------------------
procedure TAdvMemoStrings.PutObject(Index: Integer; AObject: TObject);
var
  P: TObject;
begin
  if (Index >= 0) and (Index < Count) then
  begin
    P := inherited GetObject(Index);
    if Assigned(P) and (P is TLineProp) then
      TLineProp(P).FObject := AObject
    else
      inherited PutObject(Index,AObject);
  end;    
end;

function TAdvMemoStrings.Get(Index: Integer): string;
begin
  Result := inherited Get(Index);
end;

procedure TAdvMemoStrings.Put(Index: Integer; const S: string);
var
 sz:string;
begin
  if not Assigned(memo) then
    inherited Put(index,s)
  else
  begin
    sz := (StringReplace(s, #9,StringOfChar(#32,memo.Tabsize), [rfreplaceall]));
    if Index < FListLengths.Count then
      FListLengths.Items[Index] := pointer(length(sz))
    else
      FListLengths.Add(pointer(length(sz)));

    inherited Put(Index,sz);
    if Index < Memo.FTopLine then
      Memo.FbackupTopLine := -1;
  end;
end;


//-------------------- SET UPDATE STATE ----------------------
procedure TAdvMemoStrings.SetUpdateState(Updating: boolean);
begin
  if Updating then
    Inc(FLockCount)
  else
    if FLockCount > 0 then
      Dec(FLockCount);
end;

function TAdvMemoStrings.CreateProp(Index: integer): TLineProp;
begin
  Result := TLineProp.Create;
  with Result do
    FObject := inherited GetObject(Index);

  inherited PutObject(Index, Result);
  FLinesProp.Add(Pointer(result));
end;

procedure TAdvMemoStrings.Clear;
begin
  ClearLinesProp;
  FListLengths.Clear;
  inherited;
end;

constructor TAdvMemoStrings.Create;
begin
  inherited;
  FLinesProp := TList.Create;
  FListLengths := TList.Create;
end;

procedure TAdvMemoStrings.ClearLinesProp;
var
  P: TLineProp;
  i: Integer;
begin
  for i := 0 to FLinesProp.Count - 1 do
  begin
    p := FLinesProp[i];
    if p <> nil then
    begin
      if Assigned(p) then
      begin
        p.Free;
      end;
    end;
  end;
  FLinesProp.Clear;
end;

function TAdvMemoStrings.GetLineProp(Index: Integer): TlineProp;
var
  P:Tobject;
begin
  if (index < Count) and (Index >= 0) then
  begin
    p := inherited GetObject(Index);
    if p is TlineProp then
      Result := TlineProp(p)
    else
      Result := nil;
  end
  else
    Result := nil;
end;

procedure TAdvMemoStrings.SetLineProp(Index: Integer;
  const Value: TlineProp);
begin
  if (Index < Count) and (Index >= 0) then
    inherited PutObject(index,value)
end;

//--------------------------------------------------------------
//        TUNDO LIST
//--------------------------------------------------------------
constructor TUndo.Create(ACurX0, ACurY0, ACurX, ACurY: integer; AText: string);
begin
  inherited Create;
  FUndoCurX0 := ACurX0;
  FUndoCurY0 := ACurY0;
  FUndoCurX := ACurX;
  FUndoCurY := ACurY;
  FUndoText := AText;
end;

procedure TUndo.Undo;
begin
  if Assigned(Memo) then
    with Memo do
    begin
      CurY := FUndoCurY;
      CurX := FUndoCurX;
      PerformUndo;
      CurY := FUndoCurY0;
      CurX := FUndoCurX0;
    end;
end;

procedure TUndo.Redo;
begin
  if Assigned(Memo) then
    with Memo do
    begin
      CurY := FUndoCurY0; 
      CurX := FUndoCurX0;
      PerformRedo;
      CurY := FUndoCurY;  
      CurX := FUndoCurX;
    end;
end;

function TUndo.Append(NewUndo: TUndo): boolean;
begin
  Result := False;   
end;

//----------------  TINSERTCHARUNDO --------------------------
procedure TInsertCharUndo.PerformUndo;
var 
  i: integer;
  CurrLine: string;
begin
  for i := Length(FUndoText) downto 1 do 
  begin
    CurrLine := Memo.Lines[Memo.CurY];
    if ((FUndoText[i] = #13) and (Memo.CurX = 0)) or
      (FUndoText[i] = CurrLine[Memo.CurX]) then
      Memo.BackSpace;
  end;
end;

procedure TInsertCharUndo.PerformRedo;
var 
  i: Integer;
begin
  with Memo do
    for i := 1 to Length(FUndoText) do
      if FUndoText[i] = #13 then
        NewLine
  else 
    InsertChar(FUndoText[i]);
end;

function TInsertCharUndo.Append(NewUndo: TUndo): boolean;
begin
  Result := False;
  if not ((NewUndo is TInsertCharUndo) and
    (NewUndo.UndoCurX0 = FUndoCurX) and
    (NewUndo.UndoCurY0 = FUndoCurY)) then Exit;
  FUndoText := FUndoText + NewUndo.FUndoText;
  FUndoCurX := NewUndo.UndoCurX;
  FUndoCurY := NewUndo.UndoCurY;
  Result := True;
end;

//----------------  TDELETECHARUNDO --------------------------
procedure TDeleteCharUndo.PerformUndo;
var 
  i: integer;
begin
  with Memo do
    for i := 1 to Length(FUndoText) do 
    begin
      if not FIsBackspace then 
      begin
        Memo.CurY := FUndoCurY0;
        Memo.CurX := FUndoCurX0;
      end;
      if FUndoText[i] = #13 then
        NewLine
      else 
        InsertChar(FUndoText[i]);
    end;
end;

procedure TDeleteCharUndo.PerformRedo;
var 
  i: integer;
begin
  with Memo do
    for i := 1 to Length(FUndoText) do
      if FIsBackspace then
        BackSpace
  else
    DeleteChar(-1, - 1);
end;

function TDeleteCharUndo.Append(NewUndo: TUndo): boolean;
begin
  Result := False;
  if not ((NewUndo is TDeleteCharUndo) and
    (NewUndo.UndoCurX0 = FUndoCurX) and
    (NewUndo.UndoCurY0 = FUndoCurY)) then Exit;
  if TDeleteCharUndo(NewUndo).FIsBackspace <> FIsBackspace then Exit;
  FUndoText := NewUndo.FUndoText + FUndoText;
  FUndoCurX := NewUndo.UndoCurX;
  FUndoCurY := NewUndo.UndoCurY;
  Result := True;
end;

//----------------  TDELETE BUF, LINE UNDO --------------------------
procedure TDeleteLineUndo.PerformUndo;
begin
  with Memo do
  begin
    ClearSelection;
    SetSelText(PChar(FUndoText + #13#10));
  end;
end;

procedure TDeleteLineUndo.PerformRedo;
begin
  Memo.DeleteLine;
end;

procedure TDeleteBufUndo.PerformUndo;
begin
  with Memo do
  begin
    ClearSelection;
    SetSelText(PChar(FUndoText));
  end;
end;

procedure TDeleteBufUndo.PerformRedo;
begin
  with Memo do
  begin
    FSelStartX := FUndoSelStartX;
    FSelStartY := FUndoSelStartY;
    FSelEndX := FUndoSelEndX;
    FSelEndY := FUndoSelEndY;
    DeleteSelection(True);
  end;
end;

//----------------  TPASTE UNDO --------------------------
procedure TPasteUndo.PerformUndo;
begin
  with Memo do
  begin
    FSelStartX := FUndoCurX0;
    FSelStartY := FUndoCurY0;
    FSelEndX := FUndoCurX;
    FSelEndY := FUndoCurY;
    DeleteSelection(True);
  end;
end;

procedure TPasteUndo.PerformRedo;
begin
  with Memo do 
  begin
    ClearSelection;
    SetSelText(PChar(FUndoText));
  end;
end;


//----------------  TUNDO LIST --------------------------
constructor TAdvUndoList.Create;
begin
  inherited;
  FPos := 0;
  FIsPerforming := False;
  FLimit := 100;
end;

destructor TAdvUndoList.Destroy;
begin
  Clear;
  inherited;
end;

function TAdvUndoList.Get(Index: integer): TUndo;
begin
  Result := TUndo(inherited Get(Index));
end;

function TAdvUndoList.Add(Item: Pointer): integer;
begin
  Result := -1;
  if FIsPerforming then 
  begin
    TUndo(Item).Free;
    Exit;
  end;

  if (Count > 0) and
    Items[0].Append(TUndo(Item)) then 
  begin
    TUndo(Item).Free;
    Exit;
  end;

  TUndo(Item).Memo := Self.Memo;
  if FPos > 0 then
    while FPos > 0 do 
    begin
      Delete(0);
      Dec(FPos);
    end;
  Insert(0, Item);
  if Count > FLimit then Delete(Count - 1);
  Memo.UndoChange;
  Result := 0;
end;

procedure TAdvUndoList.Clear;
begin
  while Count > 0 do
    Delete(0);
    
  FPos := 0;
  with Memo do
    if not (csDestroying in ComponentState) then UndoChange;
end;

procedure TAdvUndoList.Delete(Index: integer);
begin
  TUndo(Items[Index]).Free;
  inherited;
end;

procedure TAdvUndoList.Undo;
var 
  OldAutoIndent: boolean;
begin
  if FPos < Count then 
  begin
    OldAutoIndent := Memo.AutoIndent;
    Memo.AutoIndent := False;
    FIsPerforming := True;
    Items[FPos].Undo;
    Inc(FPos);
    FIsPerforming := False;
    Memo.AutoIndent := OldAutoIndent;
    Memo.UndoChange;
  end;
end;

procedure TAdvUndoList.Redo;
var 
  OldAutoIndent: boolean;
begin
  if FPos > 0 then 
  begin
    OldAutoIndent := Memo.AutoIndent;
    Memo.AutoIndent := False;
    FIsPerforming := True;
    Dec(FPos);
    Items[FPos].Redo;
    FIsPerforming := False;
    Memo.AutoIndent := OldAutoIndent;
    Memo.UndoChange;
  end;
end;

procedure TAdvUndoList.SetLimit(Value: integer);
begin
  if FLimit <> Value then 
  begin
    if Value <= 0 then Value := 10;
    if Value > 0 then Value := 100;
    FLimit := Value;
    Clear;
  end;
end;

procedure TAdvCustomMemo.ScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: integer);
var
  delta: integer;
begin
  if not Focused then
    SetFocus;

  if (TScrollBar(Sender).Kind = sbVertical) then
  case ScrollCode of
  scPageUp: ScrollPos := ScrollPos - VisibleLineCount;
  scPageDown: ScrollPos := ScrollPos + VisibleLineCount;
  end;

  delta := TScrollBar(Sender).Position - ScrollPos;
  DoScroll(TScrollBar(Sender), - delta);

  Invalidate;
end;

//--------------------------------------------------------------
//        TAdvMemo - CREATE
//--------------------------------------------------------------
constructor TAdvMemo.Create(AOwner: TComponent);
begin
  inherited;
  SetBounds(0, 0, 350, 250);
  BkColor := clWhite;
  HiddenCaret := False;
  DelErase := True;
  CaseSensitive := False;
  ReadOnly := False;
  Font.Name := 'COURIER NEW';
  Font.Charset := DEFAULT_CHARSET;
  Font.Color := clBlack;
  Font.Height := -13;
  Font.Style := [];
  DoubleBuffered := True;
  OnGutterClick := AdvSyntaxMemoGutterClick;
  OnGutterDraw := AdvSyntaxMemoGutterDraw;
  OnChange := AdvSyntaxMemoChange;
  FInBrackets := -1;
  FInComment := False;
end;

//--------------------------------------------------------------
//        TAdvMemo - DESTROY
//--------------------------------------------------------------
destructor TAdvMemo.Destroy;
begin
  inherited;
end;

//--------------------------------------------------------------
//        TAdv STRING LIST - READ STRINGS
//--------------------------------------------------------------
procedure TAdvStringList.ReadStrings(Reader: TReader);
var 
  i: integer;
begin
  try
    Reader.ReadListBegin;
    Clear;
    while not Reader.EndOfList do 
    begin
      i := Add(Reader.ReadString);
      Objects[i] := TObject(Reader.ReadInteger);
    end;
    Reader.ReadListEnd;
  finally
  end;
end;

//--------------------------------------------------------------
//        TAdv STRING LIST - WRITE STRINGS
//--------------------------------------------------------------
procedure TAdvStringList.WriteStrings(Writer: TWriter);
var 
  i: integer;
begin
  with Writer do 
  begin
    WriteListBegin;
    for i := 0 to Count - 1 do 
    begin
      WriteString(Strings[i]);
      WriteInteger(integer(Objects[i]));
    end;
    WriteListEnd;
  end;
end;

//--------------------------------------------------------------
//        TAdv STRING LIST - DEFINE PROPERTIES
//--------------------------------------------------------------
procedure TAdvStringList.DefineProperties(Filer: TFiler);
begin
  Filer.Defineproperty('Strings', ReadStrings, WriteStrings, Count > 0);
end;

{ TElementStyles }

function TElementStyles.Add: TElementStyle;
begin
  Result := TElementStyle(inherited Add);
end;

constructor TElementStyles.Create(AOwner: TComponent);
begin
  FModified := False;
  inherited Create(AOwner, CreateItemClass);
end;

function TElementStyles.CreateItemClass: TCollectionItemClass;
begin
  Result := TElementStyle;
end;


function TElementStyles.GetItem(Index: integer): TElementStyle;
begin
  Result := TElementStyle(inherited Items[Index]);
end;

function TElementStyles.Insert(index: integer): TElementStyle;
begin
  Result := TElementStyle(inherited Insert(Index));
  if Assigned(FOwner) then
    FOwner.LoadStyle;
end;

function TElementStyles.IsWordBoundary(ch: char): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 1 to Count do
  begin
    if Items[i - 1].FStyleType = stSymbol then
      if Pos(ch, Items[i - 1].Symbols) > 0 then
      begin
        Result := True;
        Break;
      end;
      
    if Items[i - 1].FStyleType = stBracket then
      if (ch = Items[i - 1].Bracket) then
      begin
        Result := True;
        Break;
      end;
  end;
end;

procedure TElementStyles.SetItem(Index: integer; const Value: TElementStyle);
begin
  inherited Items[Index] := Value;
  if Assigned(FOwner) then
    FOwner.LoadStyle;
end;

procedure TElementStyles.Update(Item: TCollectionItem);
begin
  inherited;
  if Assigned(Item) then
  begin
    if Assigned(FOwner) then
      FOwner.LoadStyle;
  end;
end;

{ TElementStyle }

procedure TElementStyle.Changed;
begin
  TElementStyles(GetOwner).Update(Self);
end;

constructor TElementStyle.Create(Collection: TCollection);
begin
  inherited;
  FKeyWords := TStringList.Create;
  FFont := TFont.Create;
  FFont.Name := 'Courier New';
  FFont.Style := [];
  if Assigned(TElementStyles(GetOwner).FOwner) then
    FBGColor := TElementStyles(GetOwner).FOwner.BkColor
  else
    FBGColor := clWhite;
  FFont.Color := clblack;
  FFont.Size := 8;
  FStyleType := stKeyword;
  StyleNo := -1;
  FBracket := #0;
end;

destructor TElementStyle.Destroy;
begin
  TElementStyles(GetOwner).FModified := True;
  FKeyWords.Free;
  FFont.Free;
  inherited;
end;

procedure TElementStyle.SetBracket(const Value: char);
begin
  FBracket := Value;
  Changed;
end;

procedure TElementStyle.SetSymbols(const Value: string);
begin
  FSymbols := Value;
  Changed;
end;

procedure TElementStyle.SetColorbg(const Value: Tcolor);
begin
  FBGColor := Value;
  Changed;
end;

procedure TElementStyle.SetStyleType(const Value: TStyleType);
begin
  FStyleType := Value;
  Changed;
end;

procedure TElementStyle.SetFont(const Value: Tfont);
begin
  FFont.Assign(Value);
  Changed;
end;

procedure TElementStyle.SetKeyWords(const Value: TStrings);
begin
  FKeyWords.Assign(Value);
  Changed;
end;


procedure TAdvMemo.AdvSyntaxMemoChange(Sender: TObject);
begin
  invalidate;
end;

procedure TAdvMemo.AdvSyntaxMemoGutterClick(Sender: TObject;
  LineNo: integer);
begin
  CurY := LineNo;
end;

procedure TAdvMemo.AdvSyntaxMemoGutterDraw(Sender: TObject;
  ACanvas: TCanvas; LineNo: integer; rct: TRect);
var
  XC: integer;
  TmpBrushStyle: TBrushStyle;
begin
  with rct, ACanvas do
  begin
    if FLineNumbers then
    begin
      XC := (Left + Right) div 2 - TextWidth(IntToStr(LineNo + 1)) div 2;
      TmpBrushStyle := Brush.Style;
      Brush.Style := bsClear;
      TextOut(XC + 1, TOP, IntToStr(LineNo + 1));
      Brush.Style := TmpBrushStyle;
    end;

    if LineNo < Lines.Count then
    begin

      if Executable[LineNo] then
      begin
        Brush.Color := clBlue;
        Pen.Color := clNavy;
        ACanvas.Ellipse(Left+5,Top+8,Left+9,Top+12);
        Pen.Color := clAqua;
        Pen.Width := 1;
        ACanvas.MoveTo(Left+6,Top+8);
        ACanvas.LineTo(Left+4,Top+10);
      end;

      if BreakPoint[LineNo] then
      begin
        Brush.Color := clRed;
        Pen.Color := clBlack;
        ACanvas.Ellipse(Left+2,Top+4,Left+12,Top+14);
      end;

      if LineNo = ActiveLine then
      begin
        Brush.Color := clLime;
        Pen.Color := clGray;
        Polygon([Point(Left + 13, Top + 7), Point(Left + 13, Top + 11),
          Point(Left + 16, Top + 11),
          Point(Left + 16, Top + 14), Point(Left + 21, Top + 9),
          Point(Left + 16, Top + 4),
          Point(Left + 16, Top + 7)]);
      end;
    end;
  end;
end;



function TElementStyle.GetDisplayName: string;
begin
  if Info <> '' then
    Result := Info
  else
    Result := inherited GetDisplayName;
end;

procedure TElementStyle.Assign(Source: TPersistent);
begin
  if Source is TElementStyle then
  begin
    KeyWords.Assign(TElementStyle(Source).KeyWords);
    Font.Assign(TElementStyle(Source).Font);
    BGColor := TElementStyle(Source).BGColor;
    StyleType := TElementStyle(Source).StyleType;
    Bracket := TElementStyle(Source).Bracket;
    Symbols := TElementStyle(Source).Symbols;
    Info := TElementStyle(Source).Info;
  end;
end;

procedure TAdvCustomMemoStyler.SetStyles(const Value: TElementStyles);
begin
  FAllStyles.Assign(Value);
  Update;
end;


constructor TAdvCustomMemoStyler.Create(AOwner: TComponent);
begin
  inherited;

  FAllStyles := TElementStyles.Create(Self);
  FCommentStyle := TCharStyle.Create;
  FlistAuto := TStringList.Create;
  FHintParameter := THintParameter.Create;

  with FCommentStyle do
  begin
    TextColor := clSilver;
    BkColor := clWhite;
    Style := [fsItalic];
  end;

  FNumberStyle := TCharStyle.Create;
  with FNumberStyle do
  begin
    TextColor := clNavy;
    BkColor := clWhite;
    Style := [fsBold];
  end;

  FNumericChars := '+-.0123456789';
  FHexIdentifier := '';
end;

destructor TAdvCustomMemoStyler.Destroy;
begin
  FlistAuto.free;
  FNumberStyle.Free;
  FCommentStyle.Free;
  FAllStyles.Free;
  fHintParameter.free;
  inherited;
end;

procedure TAdvCustomMemoStyler.SetStyle(const Index: integer;
  const Value: TCharStyle);
begin
  case Index of
    1: FCommentStyle := Value;
    2: FNumberStyle := Value;
  end;
end;



procedure TAdvMemo.LoadStyle;
begin
end;



procedure TAdvCustomMemoStyler.Update;
begin
  if Assigned(FAllStyles.FOwner) then
    FAllStyles.FOwner.loadstyle;
end;

procedure TAdvCustomMemoStyler.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FAllStyles.FOwner) then
  begin
    if assigned(FAllStyles) then
    begin
      FAllStyles.FOwner := nil;
    end;
  end;
  inherited;
end;


procedure TAdvCustomMemoStyler.Loaded;
begin
  inherited;
  if not FAllStyles.FModified then
    FAllStyles.Clear;
  Update;
end;

procedure TAdvMemo.Loaded;
begin
  inherited;
  LoadStyle;
  SetMaxLength;
  ResizeScrollBars;
end;

function TAdvMemo.IsWordBoundary(ch: char): boolean;
begin
  Result := inherited IsWordBoundary(ch);

  if Assigned(FInternalStyles) then
    Result := Result or FInternalStyles.FAllStyles.IsWordBoundary(ch);
end;

procedure TAdvMemo.RefreshMemo;
begin
  curx := curx;
  cury := cury;
  SetMaxLength;
  ResizeScrollBars;
  Invalidate;
end;

procedure TAdvCustomMemo.SetActiveLine(const Value: integer);
begin
  FActiveLine := Value;
  Invalidate;
end;

procedure TAdvCustomMemo.UpdateGutter;
begin
  if FBorderStyle = bsSingle then
  begin
    if Ctl3D then
    begin
      FGutter.Left := 2;
      FGutter.Top := 2;
      FGutter.Width := FGutterWidth;
    end
    else
    begin
      FGutter.Left := 1;
      FGutter.Top := 1;
      FGutter.Width := FGutterWidth;
    end;
  end
  else
  begin
    FGutter.Left := 0;
    FGutter.Top := 0;
    FGutter.Width := FGutterWidth + 2;
  end;
end;

procedure TAdvCustomMemo.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;

  UpdateGutter;
  Invalidate;
end;

procedure TAdvCustomMemo.SetCtl3D(const Value: boolean);
begin
  FCtl3D := Value;
  UpdateGutter;
  Invalidate;
end;


procedure TAdvCustomMemo.SetLeftCol(const Value: integer);
begin
  if FLeftCol >= 0 then
  begin
    FLeftCol := Value;
    sbHorz.Position := FLeftCol;
    Invalidate;
  end;  
end;

procedure TAdvCustomMemo.SetMemoStyler(Value: TAdvCustomMemoStyler);
begin
  FInternalStyles := Value;
  if Value <> nil then
  begin
    Value.FreeNotification(Self);
    FInternalStyles.FAllStyles.FOwner := TAdvMemo(Self);
  end;
  FbackupTopLine:=-1;
//  SetTopLine(0);
  Invalidate;
end;

procedure TAdvCustomMemo.SetTopLine(const Value: integer);
begin
  if (Value >= 0) and (Value + VisibleLineCount < Lines.Count) then
  begin
    FTopLine := Value;
    sbVert.Position := FTopLine;
    Invalidate;
  end;
end;

{$IFDEF DELPHI5_LVL}
function TAdvCustomMemo.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean;
begin
  Result := inherited DoMousewheelDown(Shift, MousePos);
  if TopLine + VisibleLineCount < Lines.Count then
    TopLine := TopLine + 4;
end;

function TAdvCustomMemo.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean;
begin
  Result := inherited DoMousewheelUp(Shift, MousePos);
  if TopLine > 4 then
    TopLine := TopLine - 4
  else
    TopLine := 0;
end;
{$ENDIF}


procedure TAdvCustomMemo.SetUrlAware(const Value: boolean);
begin
  if FUrlAware <> Value then
  begin
    FUrlAware := Value;
    invalidate;
  end;
end;

procedure TAdvCustomMemo.TestforURLClick(s: string);
var
  i, dlhttp, dlmail, x, locx: integer;
  urls: TStringList;
begin
  if not FUrlAware then exit;
  urls := TStringList.Create;
  ExtractURL(s, urls);
  x := 0;
  locx := curx;
  for i := 0 to urls.Count - 1 do
  begin
    if (x <= locx) and (x + length(urls[i]) > locX) then
    begin
      dlhttp := ansipos('http://', LowerCase(urls[i]));
      dlmail := ansipos('mailto:', lowercase(urls[i]));
      if (dlmail = 1) or (dlhttp = 1) then
        if assigned(FOnURLClick) then
          FOnURLClick(self, urls[i]);
    end;
    x := x + length(urls[i]);
  end;
  urls.Free;
end;

procedure TAdvCustomMemo.SetUrlStyle(const Value: TCharStyle);
begin
  FUrlStyle := Value;
  inherited;
end;

procedure TAdvCustomMemo.ExtractURL(s: string; var urls: TStringList);
var
  s1: string;
  txt, i: integer;
begin
  if not Assigned(urls) then
    Exit;
  urls.Clear;
  if not FUrlAware then
  begin
    urls.Add(s);
    Exit;
  end;

  txt := -1;
  s1 := '';
  for i := 1 to length(s) do
  begin
    if AnsiPos(s[i], Furldelimiters) > 0 then
    begin
      if txt = 0 then
      begin
        urls.Add(s1);
        s1 := '';
      end;
      txt := 1;
      s1 := s1 + s[i];
    end
    else
    begin
      if txt = 1 then
      begin
        urls.Add(s1);
        s1 := '';
      end;
      txt := 0;
      s1 := s1 + s[i];
    end;
  end;
  if s1 <> '' then urls.Add(s1);
end;

function TAdvCustomMemo.TestforURLMove(s: string; locx: integer): boolean;
var
  i, dlhttp, dlmail, x: integer;
  urls: TStringList;
begin
  if not FUrlAware then
  begin
    Result := False;
    Exit;
  end;

  urls := TStringList.Create;
  ExtractURL(s, urls);
  x := 0;
  Result := False;
  for i := 0 to urls.Count - 1 do
  begin
    if (x <= locx) and (x + length(urls[i]) > locX) then
    begin
      dlhttp := ansipos('http://', LowerCase(urls[i]));
      dlmail := ansipos('mailto:', lowercase(urls[i]));
      if (dlmail = 1) or (dlhttp = 1) then
      begin
        Result := True;
      end;
    end;
    x := x + length(urls[i]);
  end;
  urls.Free;
end;

procedure TAdvCustomMemo.ScrollHChange(Sender: TObject);
var
  delta: integer;
begin
  if not sbHorz.Visible then exit;
  delta := sbHorz.Max - sbHorz.PageSize + 1;
  if (sbHorz.Position > delta) and (sbHorz.PageSize > 0) then
    sbHorz.Position := delta+1;
  FLeftCol := sbHorz.Position;
end;

procedure TAdvCustomMemo.ScrollVChange(Sender: TObject);
var
  delta: integer;
begin
  if not sbVert.Visible then
    Exit;
  delta := sbVert.Max - sbVert.PageSize + 1;
  if (sbVert.Position > delta) and (sbVert.PageSize > 0) then
    sbVert.Position := delta;
  Ftopline := sbVert.Position;
end;

function TAdvCustomMemo.FindText(SearchStr: string; Options: TFindOptions): integer;
var
  i, j, cit: integer;
  s: string;

  function compareLinetext: integer;
  var
    position: integer;
  begin
    if frMatchCase in Options then
    begin
      if frDown in Options then position := ansipos(SearchStr, s)
      else
        position := ansiRPos(SearchStr, s);
    end
    else
    begin
      if frDown in Options then position := ansipos(LowerCase(SearchStr), LowerCase(s))
      else
        position := ansiRPos(LowerCase(SearchStr), LowerCase(s));
    end;

    Result := position;
    if (frWholeWord in Options) and (position > 0) then
    begin
      if length(s) = position + length(SearchStr) - 1 then
      begin
        if position = 1 then
          Exit;
        if s[position - 1] = #32 then
          Exit;
      end;

      if (position = 1) and (s[length(SearchStr) + 1] = #32) then
        Exit;


      if (s[position - 1] = #32) and (s[length(SearchStr) + position ] = #32) then
        Exit;

      Result := 0;
    end;
  end;

  procedure nextline;
  begin
    if frDown in Options then inc(i)
    else
      dec(i);
  end;

begin
  Result := -1;
  if SearchStr = '' then
    Exit;
    
  i := CurY;
  cit := 0;

  while (i <= Lines.Count - 1) and (i >= 0) do
  begin
    s := Lines[i];
    s := TrimRight(s);
    if (i = FSelStartY) and
      (FSelStartY = FSelEndY) then
    begin
      if frDown in Options then
      begin
        if FSelEndX >= length(s) then
        begin
          nextline;
          Continue;
        end;
        Delete(s, 1, FSelEndX);
        cit := FSelEndX;
      end
      else
      begin
        Delete(s, FSelStartX + 1, (length(s) - FSelStartX));
        cit := -(length(s) - FSelStartX);
      end;
    end
    else
      cit := 0;

    j := compareLinetext;
    if j > 0 then
    begin
      CurY := i;
      Curx := (j - 1) + cit;

      FSelStartX := Curx;
      FSelEndX := Curx + Length(SearchStr);
      FSelStartY := CurY;
      FSelEndY := CurY;
      
      Result := GetSelStart;
      Invalidate;
      Exit;
    end;
    nextline;
  end;
  
  FSelStartX := 0;
  FSelStartY := 0;
  FSelEndX := 0;
  FSelEndY := 0;
  Invalidate;
end;


function TAdvCustomMemo.FindTextPos(SearchStr: string; Options: TFindOptions): integer;
var
  i, j, cit: integer;
  s: string;

  function compareLinetext: integer;
  var
    position: integer;
  begin
    if frMatchCase in Options then
    begin
      if frDown in Options then position := ansipos(SearchStr, s)
      else
        position := ansiRPos(SearchStr, s);
    end
    else
    begin
      if frDown in Options then
        position := ansipos(LowerCase(SearchStr), LowerCase(s))
      else
        position := ansiRPos(LowerCase(SearchStr), LowerCase(s));
    end;

    Result := position;
    if (frWholeWord in Options) and (position > 0) then
    begin
      if length(s) = position + length(SearchStr) - 1 then
      begin
        if position = 1 then
          Exit;
        if s[position - 1] = #32 then
          Exit;
      end;
      
      if (position = 1) and (s[length(SearchStr) + 1] = #32) then
        Exit;
      if (s[position - 1] = #32) and (s[length(SearchStr) + 1] = #32) then
        Exit;

      Result := 0;
    end;
  end;

  procedure nextline;
  begin
    if frDown in Options then inc(i)
    else
      dec(i);
  end;

begin
  Result := -1;
  if SearchStr = '' then
    Exit;
    
  i := CurY;
  cit := 0;

  while (i <= Lines.Count - 1) and (i >= 0) do
  begin
    s := Lines[i];
    s := TrimRight(s);
    if (i = FSelStartY) and
      (FSelStartY = FSelEndY) then
    begin
      if frDown in Options then
      begin
        if FSelEndX >= length(s) then
        begin
          nextline;
          Continue;
        end;
        Delete(s, 1, FSelEndX);
        cit := FSelEndX;
      end
      else
      begin
        Delete(s, FSelStartX + 1, (length(s) - FSelStartX));
        cit := -(length(s) - FSelStartX);
      end;
    end
    else
      cit := 0;

    j := compareLinetext;
    if j > 0 then
    begin
      TextFromPos((j - 1) + cit,i,Result);
      Exit;
    end;
    NextLine;
  end;
end;


function TAdvMemoStrings.GetRealcount: integer;
begin
  if (Text = '') or (Text = #13#10) then
    Result := 0
  else
    Result := inherited Count;
end;

function TAdvMemoStrings.Add(const S: string): integer;
var
  sz:string;
begin
  if not assigned(memo) then
  begin
    Result := inherited Add(s);
    FListLengths.Add(pointer(length(s)));
  end
  else
  begin
    sz := StringReplace(s, #9,StringOfChar(#32,memo.tabsize), [rfreplaceall]);
    Result := inherited Add(sz);
    FListLengths.Add(pointer(length(sz)));
    Memo.LinesChanged(nil);
  end;
end;



{ TAdvMemoFindDialog }

constructor TAdvMemoFindDialog.Create(AOwner: TComponent);
begin
  inherited;
  FindDialog := TFindDialog.Create(nil);
  FindDialog.OnFind := Find;
  FindDialog.OnClose := Close;
  FDisplayMessage := True;
  FNotFoundMessage := 'Text not found';
end;

destructor TAdvMemoFindDialog.Destroy;
begin
  FindDialog.Free;
  inherited;
end;

procedure TAdvMemoFindDialog.Execute;
var
  p: Tpoint;
begin
  if Assigned(FAdvMemo) then
  begin
    FAdvMemo.FSelStartX := 0;
    FAdvMemo.FSelStartY := 0;
    FAdvMemo.FSelEndX := 0;
    FAdvMemo.FSelEndY := 0;
    FAdvMemo.Searching := True;
    FindDialog.FindText := FFindText;
    p := Point(FAdvMemo.Left, FAdvMemo.top);
    p := FAdvMemo.ClientToScreen(p);
    if not PointInRect(p, rect(0, 0, screen.Width, screen.Height)) then p := point(0, 0);

    FindDialog.Position := p;
    FindDialog.Execute;
  end;
end;

procedure TAdvMemoFindDialog.Close(Sender: TObject);
begin
  if Assigned(FAdvMemo) then
    FAdvMemo.Searching := False;
end;

procedure TAdvMemoFindDialog.Find(Sender: TObject);
var
  rz: Integer;
begin
  if not Assigned(FAdvMemo) then
    Exit;
  rz := FAdvMemo.FindText(FindDialog.FindText, FindDialog.Options);
  if (rz = -1) and (FDisplayMessage) then
    MessageDlg(FNotFoundMessage, mtInformation, [mbYes], 0);
end;

procedure TAdvMemoFindDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FAdvMemo) then
    FAdvMemo := nil;
  inherited;
end;

{ TAdvMemoFindReplaceDialog }

constructor TAdvMemoFindReplaceDialog.Create(AOwner: TComponent);
begin
  inherited;
  ReplaceDialog := TReplaceDialog.Create(nil);
  ReplaceDialog.OnFind := Find;
  ReplaceDialog.OnClose := Close;
  ReplaceDialog.OnReplace := Replace;
  FDisplayMessage := True;
  FNotFoundMessage := 'Text not found';
end;

destructor TAdvMemoFindReplaceDialog.Destroy;
begin
  ReplaceDialog.Free;
  inherited;
end;

procedure TAdvMemoFindReplaceDialog.Execute;
var
  p: TPoint;
begin
  if Assigned(FAdvMemo) then
  begin
    FAdvMemo.FSelStartX := 0;
    FAdvMemo.FSelStartY := 0;
    FAdvMemo.FSelEndX := 0;
    FAdvMemo.FSelEndY := 0;
    ReplaceDialog.FindText := FFindText;
    ReplaceDialog.ReplaceText := FReplaceText;
    p := Point(FAdvMemo.Left, FAdvMemo.top);
    p := FAdvMemo.ClientToScreen(p);
    if not PointInRect(p, rect(0, 0, screen.Width, screen.Height)) then p := point(0, 0);
    ReplaceDialog.Position := p;
    FAdvMemo.Searching := True;
    ReplaceDialog.Execute;
  end;
end;

procedure TAdvMemoFindReplaceDialog.Close(Sender: TObject);
begin
  if Assigned(FAdvMemo) then
  begin
    FAdvMemo.Searching := False;
  end;  
end;

procedure TAdvMemoFindReplaceDialog.Find(Sender: TObject);
var
  rz: integer;
begin
  if not assigned(FAdvMemo) then exit;
  rz := FAdvMemo.FindText(ReplaceDialog.FindText, ReplaceDialog.Options);
  if (rz = -1) and (FDisplayMessage) then
    MessageDlg(FNotFoundMessage, mtInformation, [mbYes], 0);
end;

procedure TAdvMemoFindReplaceDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FAdvMemo) then
  begin
    FAdvMemo := nil;
  end;
  inherited;
end;

procedure TAdvMemoFindReplaceDialog.Replace(Sender: TObject);
var
  rz, oldrz: integer;
begin
  if not assigned(FadvMemo) then exit;
  with ReplaceDialog do
  begin
    if frReplaceAll in Options then
    begin
      oldrz := -1;
      repeat
        rz := FAdvMemo.FindText(FindText, Options);
        if rz = oldrz then Break;
        oldrz := rz;
        if rz>-1 then
          FAdvMemo.Selection := replacetext;
      until rz = -1;
    end
    else
    begin
      if FAdvMemo.Selection = '' then
      begin
        rz := FAdvMemo.FindText(FindText, Options);
        FAdvMemo.Invalidate;
        if (rz = -1) and (FDisplayMessage) then
          MessageDlg(FNotFoundMessage, mtInformation, [mbYes], 0);
      end
      else
      begin
        FAdvMemo.Selection := replacetext;
        Replace(nil);
      end;
    end;
  end;
  FAdvMemo.Invalidate;
end;



{ TlineProp }

constructor TLineProp.Create;
begin
  inherited;
  Executable := False;
  BreakPoint := False;
  FErrStart := TIntList.Create;
  FErrLen := TIntList.Create;

end;

destructor TLineProp.destroy;
begin
  FErrStart.Free;
  FErrLen.Free;
  inherited;
end;


{ TAdvMemoStrings }


procedure TAdvMemoStrings.Assign(Source: TPersistent);
var
  i:integer;
begin
  if Source is TStrings then
  begin
    if Assigned(Memo) then
    begin
      Memo.FBackupTopLine := -1;
      Memo.SetLines(TAdvMemoStrings(Source));
      FListLengths.Clear;
      for i := 1 to TAdvMemoStrings(Source).Count do
        FListLengths.Add(pointer(Length(TAdvMemoStrings(Source)[i - 1])));
      Memo.SetMaxLength;
      Memo.ResizeScrollBars;
    end
    else
      inherited Assign(Source);
  end
  else
    inherited Assign(Source);


end;


procedure TAdvCustomMemoStyler.SetlistAuto(const Value: Tstringlist);
begin
  FListAuto.Assign(Value);
end;

procedure TAdvCustomMemo.HideForm;
begin
  if FormAutocompletion.Visible then
  begin
    FormAutoCompletion.Hide;
    SetFocus;
  end;
end;

procedure TAdvCustomMemo.ShowForm;
var
  s:string;
  i:integer;
  ab,ae:integer;
  p:TPoint;
begin
  if not FAutoCompletion then
    Exit;
    
  if ReadOnly then
    Exit;

  if Assigned(FInternalStyles) then
  begin
    if FInternalStyles.FlistAuto.Count = 0 then
      Exit;
  end
  else
    Exit;
    
  P := Point(0, 0);
  P := ClientToScreen(P);
  FormAutocompletion.Left := p.x+FGutter.Width+FCellSize.W*(FCurx - FLeftCol);
  FormAutocompletion.Top := p.y+FCellSize.H*(Fcury-FTopLine+1);
  FormAutocompletion.Width := FAutoCompletionWidth;
  FormAutocompletion.Height := FAutoCompletionHeight;

  FListCompletion.Items.Clear;
  if Assigned(FInternalStyles) then
    Flistcompletion.Items.AddStrings(FInternalStyles.FlistAuto);

  s := Lines[cury];
  ae := Length(s);
  if ae > 0 then
  begin
    for i := curx+1 to Length(s) do
      if s[i] = #32 then
      begin
       ae := i - 1;
       Break;
      end;
    ab := 1;
    for i := curx + 1 downto 1 do
      if s[i] = #32 then
      begin
        ab := i + 1;
        Break;
      end;
    s := copy(s,ab,ae-ab+1);

    {$IFDEF TMSDEBUG}
    OutputDebugString(pchar('READ FROM CURSOR '+s));
    {$ENDIF}
  end
  else
    s := '';

  SetEventAutoCompletion;

  if Assigned(FOnStartAutoCompletion) then
    FOnStartAutoCompletion(self);

  Flistcompletion.Sorted := True;
  FormAutocompletion.Show;

  Flistcompletion.SetFocus;
  for i := 1 to length(s) do
    SendMessage(Flistcompletion.Handle,wm_char,ord(s[i]),1); //Simulate keypress into the listbox to find field

  Flistcompletion.ItemIndex := Flistcompletion.ItemIndex;
end;

procedure TAdvCustomMemo.hideauto(sender: Tobject);
begin
  if Assigned(FOnCanceltAutoCompletion) then
    FOnCanceltAutoCompletion(Self);
  HideForm;
end;

procedure TAdvCustomMemo.ListKeyDown(sender: Tobject; var Key: word;
  Shift: TShiftState);
var
  s:string;
  i,ae,ab:integer;
begin
  case key of
  VK_ESCAPE,VK_TAB:
    begin
      HideForm;
      ShowCaret(true);
    end;
  VK_RETURN:
    begin
      if FListCompletion.ItemIndex > -1 then
      begin
        s := Lines[cury];
        ae := length(s);
        ab:=1;
        if ae>0 then
        begin
          for i:=curx+1 to length(s) do
            if s[i] = #32 then
            begin
              ae:=i-1;
              break;
            end;
          for i:=curx+1 downto 1 do
            if s[i] = #32 then
            begin
              ab:=i+1;
              break;
            end;
          //s:=copy(lines[cury],1,ab-1)+Flistcompletion.items[Flistcompletion.ItemIndex]+copy(lines[cury],ae,length(s)-ae);
        end;
        s := Flistcompletion.items[Flistcompletion.ItemIndex];
        FSelStartY := cury;
        FSelEndY := cury;
        FSelStartX := ab-1;
        FSelEndX := ae;
        if Assigned(FOnAutoCompletion) then
          FOnAutoCompletion(self);
        SetSelText(s);
        KilleventAutoCompletion;
        HideForm;
        ShowCaret(True);
      end;
    end;
  VK_BACK:if not ReadOnly then BackSpace;
  VK_DELETE:if not ReadOnly then DeleteChar(-1, - 1);
  VK_LEFT,VK_UP,VK_DOWN,VK_RIGHT,VK_HOME,VK_END,VK_PRIOR,VK_NEXT:;
  else
    begin
      if Key in [ord('a')..ord('z'),ord('A')..ord('Z')] then
        InsertChar(chr(key))
      else
      begin
        if Assigned(FOnCanceltAutoCompletion) then
          FOnCanceltAutoCompletion(self);
        HideForm;
        ShowCaret(true);
      end;
    end;
  end;
end;

procedure TAdvCustomMemo.KillEventAutoCompletion;
begin
  FormAutocompletion.OnDeactivate := nil;
  Flistcompletion.OnExit := nil;
  Flistcompletion.OnKeyDown := nil;
end;

procedure TAdvCustomMemo.SetEventAutoCompletion;
begin
  FormAutocompletion.OnDeactivate := HideAuto;
  Flistcompletion.OnExit := HideAuto;
  Flistcompletion.OnKeyDown := ListKeyDown;
end;

procedure TAdvCustomMemo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := cafree;
end;


{ TAdvAutoform }

procedure TAdvAutoform.WMClose(var Msg: TMessage);
begin
  inherited;
end;

procedure TAdvCustomMemo.PrepareShowHint;
var
  p:TPoint;
  bp,np: string;

begin
  if not Assigned(FInternalStyles) then
    Exit;

  if (cury < FTopLine) or (cury > FTopLine + VisibleLineCount) then
    Exit;


  if SearchParameter then
  begin

    P := Point(0, 0);
    P := ClientToScreen(P);

    with FHintForm do
    begin
      Left := p.x + FGutter.Width + FCellSize.W * (Fcurx-FLeftCol);
      if FAutoHintParameterPos = hpBelowCode then
        Top := p.y + FCellSize.H * (FCury - FTopLine + 1)
      else
        Top := p.y + FCellSize.H * (FCury - FTopLine - 1);
        
      bp := '';
      np := '';
      case FHintFOrm.active of
      0: np := part1+part2+part3;
      1: begin
           np := part2+part3;
           bp := part1;
         end;
      2:begin
           np := part1+part3;
           bp := part2;
        end;
      3:begin
           np := part1+part2;
           bp := part3;
        end;
      end;
      Height := Canvas.TextHeight('h,g_`') + 4;
      Width := Canvas.TextWidth(np);
      Canvas.Font.Style := Canvas.Font.Style + [fsBold];
      Width := Width + Canvas.TextWidth(bp) + 6;
      Canvas.Font.Style := Canvas.Font.Style - [fsBold];

      Color := FInternalStyles.HintParameter.FBkColor;
      Font.Color := FInternalStyles.HintParameter.FTextColor;
    end;

    FHintShowing := True;
    FHintForm.Visible := True;
    FHintForm.Refresh;
    SetFocus;
    FHintShowing := False;    
  end;
end;

procedure TAdvCustomMemo.FormHintClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := cafree;
end;

procedure TAdvCustomMemo.TimerHint(Sender: TObject);
begin
  FHintForm.Hide;
  Timer.Enabled := False;
end;

{ TAdvHintform }

procedure TAdvHintform.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;

begin
  inherited CreateParams(Params);

  if (Win32Platform = VER_PLATFORM_WIN32_NT) and
     ((Win32MajorVersion > 5) or
      ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1))) then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TAdvHintform.Paint;
var
  x: Integer;

begin
  inherited;

  Canvas.Pen.Color := clGray;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Color := Color;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(ClientRect);
  Canvas.Font.Style := [];

  case Active of
   0:begin
       Canvas.TextOut(2,2,part1 + part2 + part3);
     end;
   1:begin
       Canvas.Font.Style := [fsBold];
       Canvas.TextOut(2,2,part1);
       x := Canvas.TextWidth(part1);
       Canvas.Font.Style := [];
       Canvas.TextOut(x + 2,2,part2+part3);
     end;
    2:begin
       Canvas.TextOut(2,2,part1);
       x := Canvas.TextWidth(part1);
       Canvas.Font.Style := [fsBold];
       Canvas.TextOut(x + 2,2,part2);
       x := x + Canvas.TextWidth(part2);
       Canvas.Font.Style:=[];
       Canvas.TextOut(x + 2,2,part3);
      end;
    3:begin
       Canvas.TextOut(2,2,part1+part2);
       x := Canvas.TextWidth(part1+part2);
       Canvas.Font.Style := [fsBold];
       Canvas.TextOut(x + 2,2,part3);
      end;
   end;
end;

{ THintParameter }

constructor THintParameter.Create;
begin
  FParameters := TStringList.Create;
  FTextColor := clBlack;
  FBkColor := clInfoBk;
  FStartchar := '(';
  FEndchar := ')';
  FDelimiterChar := ';';
  FWriteDelimiterChar := ',';
end;

destructor THintParameter.Destroy;
begin
  FParameters.free;
  inherited;
end;

procedure ThintParameter.SetParameters(const Value: Tstringlist);
begin
  FParameters.Assign(Value);
end;

function TAdvCustomMemo.SearchParameter: Boolean;
var
  i,x,j,fnd,fnds,fnd_chb,fnd_che,Cx:integer;
  s,st,stemp:string;
  paridx: Integer;

  function ApplyCS(s:string):string;
  begin
    if FCaseSensitive then
      Result := s
    else
      Result := UpperCase(s);
  end;

  function NearestStart(s:string; fromX: integer;var res: string;var ParNum: Integer): integer;
  var
    found: boolean;
    space: Integer;
  begin
    ParNum := 0;
    res := '';

    if fromX > length(s) then
      fromX := length(s);

    found := False;

    space := 0;

    while (fromX > 0) and not found and (space < 5) do
    begin
      if (s[fromX] = FInternalStyles.FHintParameter.FWriteDelimiterChar) then
        inc(ParNum);

      if s[fromX] = ' ' then
        inc(space)
      else
        space := 0;

      if s[fromX] = FInternalStyles.FHintParameter.FEndChar then
      begin
        Result := -1;
        Exit;
      end;

      if s[fromX] = FInternalStyles.FHintParameter.FStartChar then
        found := true;

      dec(fromX);
    end;

    if space >= 5 then
    begin
      Result := -1;
      Exit;
    end;

    Result := fromX;

    if found then
    begin
      found := false;
      while (fromX > 0) and not found do
      begin
        if s[fromX] in [FInternalStyles.FHintParameter.FStartchar,FInternalStyles.FHintParameter.FEndchar] then
          found := true
        else
        begin
          if s[fromX]=' ' then break;//17 ap
          res := s[fromX] + res;
          dec(fromX);
        end;
      end;
    end;
  end;

begin
  Result := False;

  if not Assigned(FInternalStyles) then
    Exit;

  if Lines.Count = 0 then
    Exit;

  st := ApplyCS(Lines[cury]);
  s := '';

  cx := curx;
  x := NearestStart(st,cx,stemp,paridx);

  if x = -1 then
  begin
    FHintForm.Hide;
    Exit;
  end;

  stemp := Trim(stemp);

  // tracked the function to look for here
  {$IFDEF TMSDEBUG}
  outputdebugstring(pchar(inttostr(x)+':'+stemp+';'+inttostr(paridx)));
  {$ENDIF}

  for i := 0 to FInternalStyles.FHintParameter.FParameters.Count - 1 do
  begin
    s := FInternalStyles.FHintParameter.FParameters[i];
    st := ApplyCS(s);
    if AnsiPos(stemp,st) = 0 then
      Continue;

    x:=AnsiPos(FInternalStyles.FHintParameter.FStartchar,s);
    if x>0 then  delete(s,1,x);
    x:=AnsiPos(FInternalStyles.FHintParameter.FEndchar,s);
    if x>0 then  delete(s,x,length(s)-x);

    fnd := paridx;

    fnds := 0;
    fnd_chb := 0;
    fnd_che := Length(s);

    // extract the parameter to highlight
    for j := 1 to Length(s) do
    begin
      if (s[j] = FInternalStyles.FHintParameter.FWritedelimiterChar) or
        (s[j] = FInternalStyles.FHintParameter.FDelimiterChar) then
      begin
        inc(fnds);
        if fnds = fnd then
          fnd_chb := j;
        if fnds = fnd + 1 then
        begin
          fnd_che := j;
          Break;
        end;
      end;
    end;

    if fnd >= fnds then
      Continue;

    FHintForm.part1 := copy(s,1,fnd_chb);
    FHintForm.part2 := copy(s,fnd_chb+1,fnd_che-fnd_chb);
    FHintForm.part3 := copy(s,fnd_che+1,length(s)-fnd_che);

    {$IFDEF TMSDEBUG}
    OutputDebugString(pchar('1="'+FHintForm.part1+'"'));
    OutputDebugString(pchar('2="'+FHintForm.part2+'"'));
    OutputDebugString(pchar('3="'+FHintForm.part3+'"'));
    {$ENDIF}

    if FHintForm.part2 = '' then
      FHintForm.Active := 1
    else
      FHintForm.Active := 2;

    Timer.Enabled := False;
    Result := True;
    Timer.Enabled := True;
    Exit;
  end;
  FHintForm.Hide;
end;

procedure TAdvCustomMemo.FormHintMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetFocus;
  ShowCaret(true);
  Invalidate;
  Setfocus;
end;

procedure TAdvCustomMemo.SetAutoHintParameters(
  const Value: TAutoHintParameters);
begin
  FAutoHintParameters := Value;
  FHintForm.Hide;
end;

procedure TAdvCustomMemo.HideHint;
begin
  if FHintForm.Visible then
    FHintForm.Visible := False;
end;

{ TPrintOptions }

procedure TPrintOptions.Assign(Source: TPersistent);
begin
  FJobName := (Source as TPrintOptions).JobName;
  FTitle := (Source as TPrintOptions).FTitle;
  FMarginLeft := (Source as TPrintOptions).FMarginLeft;
  FMarginRight := (Source as TPrintOptions).FMarginRight;
  FMarginTop := (Source as TPrintOptions).FMarginTop;
  FMarginBottom := (Source as TPrintOptions).FMarginBottom;
  FPageNr := (Source as TPrintOptions).FPageNr;
  FPagePrefix := (Source as TPrintOptions).FPagePrefix;
end;

procedure TAdvCustomMemo.SetPrintOptions(const Value: TPrintOptions);
begin
  FPrintOptions.Assign(Value);
end;


procedure TAdvCustomMemo.KeyUp(var Key: word; Shift: TShiftState);
begin
  {$IFDEF BLINK}
  SetCaretBlinkTime(FCaretTime);
  FletgetCaretTime := True;
  {$ENDIF}
  if not FHiddenCaret then
  ShowCaret(True);
  inherited;
end;

procedure TAdvCustomMemo.SetGutterColorTo(const Value: TColor);
begin
  FGutter.FColorTo := Value;
  Invalidate;
end;

procedure TAdvCustomMemo.SetLineNumbers(const Value: Boolean);
begin
  FLineNumbers := Value;
  Invalidate;
end;

function TAdvCustomMemo.GetGutterColorTo: TColor;
begin
  Result := FGutter.FColorTo;
end;

procedure TAdvCustomMemo.CursorChanged;
var
  wac,s,wstart,wend: string;
  i,b,vp1,vp2: Integer;
  flg: Boolean;

  function varpos(su,s:string;var vp: integer): integer;
  var
    sg,eg: Boolean;
  begin
    Result := 0;
    vp := Pos(su,s);

    if vp > 0 then
    begin
      sg := True;
      if (vp > 1) then
        sg := IsWordBoundary(s[vp - 1]);

      eg := True;
      //if (vp + Length(su) -1 <= Length(s)) then
      //  eg := IsWordBoundary(s[vp + Length(su) - 1]);

      if eg and sg then
        Result := vp;
    end;
  end;

begin
  if Assigned(SyntaxStyles) then
  begin
    wstart := UpperCase(SyntaxStyles.BlockStart);
    wend := UpperCase(SyntaxStyles.BlockEnd);
  end;

  if (wstart <> '') and (wend <> '') then
  begin
    wac := Uppercase(WordAtCursor);

    if (wac = wstart) then
    begin
      b := 0;
      i := CurY;
      flg := False;

      while (i < TopLine + VisibleLineCount) and not flg do
      begin
        if i < Lines.Count then
        begin
          s := Uppercase(Lines[i]);

          while (varpos(wstart,s,vp1) > 0) or (varpos(wend,s,vp2) > 0) do
          begin
            if (vp1 > 0) and ((vp1 < vp2) or (vp2 = 0)) then
              inc(b);

            if (vp2 > 0) and ((vp2 < vp1) or (vp1 = 0)) then
              dec(b);

            if (vp2 > 0) and (b = 0) then
            begin
              SetBlockMatch(i,vp2 - 1,Length(wend));
              flg := true;
              Break;
            end;

            if vp1 > 0 then
              delete(s,1,vp1 + Length(wend))
            else
              s := '';
          end;

        end;
        inc(i);
      end;
    end;

    if (wac = wend) then
    begin
      b := 0;
      i := CurY;
      flg := False;

      while (i > TopLine) and not flg do
      begin
        if i < Lines.Count then
        begin
          s := Uppercase(Lines[i]);

          while (varpos(wend,s,vp1) > 0) or (varpos(wstart,s,vp2) > 0) do
          begin
            if (vp1 > 0) and ((vp1 < vp2) or (vp2 = 0)) then
              inc(b);

            if (vp2 > 0) and ((vp2 < vp1) or (vp1 = 0)) then
              dec(b);

            if (vp2 > 0) and (b = 0) then
            begin
              SetBlockMatch(i,vp2 - 1,Length(wstart));
              flg := true;
              Break;
            end;

            if vp1 > 0 then
              delete(s,1,vp1 + Length(wstart))
            else
              s := '';
          end;

        end;
        dec(i);
      end;
    end;

    if (wac <> wstart) and (wac <> wend) then
      SetBlockMatch(-1,-1,-1);
  end;

  if Assigned(FOnCursorChange) then
    FOnCursorChange(Self);
end;


{ TIntList }

constructor TIntList.Create;
begin
  inherited Create;
end;

procedure TIntList.SetInteger(Index: Integer; Value: Integer);
begin
  inherited Items[Index] := Pointer(Value);
end;

function TIntList.GetInteger(Index: Integer): Integer;
begin
  Result := Integer(inherited Items[Index]);
end;

procedure TIntList.Add(Value: Integer);
begin
  inherited Add(Pointer(Value));
end;

procedure TIntList.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;


procedure TAdvCustomMemo.ClearErrors;
var
  i: Integer;
  Tlp: TLineProp;
begin
  for i := 1 to Lines.Count do
  begin
    Tlp := Lines.GetLineProp(i - 1);
    if Assigned(Tlp) then
    begin
      Tlp.FErrStart.Clear;
      Tlp.FErrLen.Clear;
    end;
  end;
  Invalidate;
end;

procedure TAdvCustomMemo.ClearLineErrors(LineNo: Integer);
var
  Tlp: TLineProp;
begin
  Tlp := Lines.GetLineProp(LineNo);
  if Assigned(Tlp) then
  begin
    Tlp.FErrStart.Clear;
    Tlp.FErrLen.Clear;
  end;
end;


procedure TAdvCustomMemo.SetError(LineNo, ErrPos, ErrLen: Integer);
var
  Tlp:TlineProp;
  r: TRect;
begin
  Tlp := Lines.GetLineProp(LineNo);
  if Tlp = nil then
    tlp := Lines.CreateProp(LineNo);
  tlp.FErrStart.Add(ErrPos);
  tlp.FErrLen.Add(ErrLen);
  Lines.SetLineProp(LineNo,tlp);
  r := LineRect(LineNo);
  InvalidateRect(Handle,@r,True);
end;

procedure TAdvCustomMemo.SetBlockMatch(LineNo, BlockStart,
  BlockLen: Integer);
var
  r: TRect;
begin
  if (BOldSelLine <> -1) and (BOldSelLine < Lines.Count) then
  begin
    r := LineRect(BOldSelLine);
    InvalidateRect(Handle,@r,True);
  end;

  BSelLine := LineNo;
  BSelStart := BlockStart;
  BSelLen := BlockLen;

  BOldSelLine := BSelLine;
  r := LineRect(BOldSelLine);
  InvalidateRect(Handle,@r,True);
end;

end.
