{*************************************************************************}
{ TADVEDIT & TAdvMaskEdit component                                       }
{ for Delphi & C++Builder                                                 }
{ version 2.4                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright © 1996-2003                                         }
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

unit AdvEdit;

{$I TMSDEFS.INC}

interface

uses
  {$IFDEF WIN32}
  Windows, Registry, Dialogs,
  {$ELSE}
  Wintypes, Winprocs,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Clipbrd,
  Mask, Consts, Inifiles
  {$IFDEF DELPHI3_LVL}
  , AdvEdDD, ActiveX
  {$ENDIF}
  ;

type
  TWinCtrl = class(TWinControl);

  TLabelPosition = (lpLeftTop,lpLeftCenter,lpLeftBottom,lpTopLeft,lpBottomLeft,
                    lpLeftTopLeft,lpLeftCenterLeft,lpLeftBottomLeft,lpTopCenter,
                    lpBottomCenter);

  TAdvEditType = (etString,etNumeric,etFloat,etUppercase,etMixedCase,etLowerCase,
                  etPassword,etMoney,etRange,etHex,etAlphaNumeric);

  TAutoType = (atNumeric,atFloat,atString,atDate,atTime,atHex);

  TValueValidateEvent = procedure(Sender:TObject;value:string;var IsValid: Boolean) of object;

  TClipboardEvent = procedure(Sender:TObject;value:string;var allow: Boolean) of object;

  TMaskCompleteEvent = procedure(Sender:TObject;value:string;var accept: Boolean) of object;

  TLookupSelectEvent = procedure(Sender: TObject; var Value: string) of object;

  TRangeList = class(TList)
  private
    procedure SetInteger(Index: Integer; Value: Integer);
    function GetInteger(Index: Integer): Integer;
  public
    constructor Create;
    property Items[index: Integer]: Integer read GetInteger write SetInteger; default;
    procedure Add(Value: integer);
    procedure AddMultiple(Value,Count: Integer);
    procedure Delete(Index: Integer);
    procedure Show;
    function InList(Value: integer): Boolean;
    function StrToList(s:string): Boolean;
  published
  end;

  TPersistenceLocation = (plInifile,plRegistry);

  TPersistence = class(TPersistent)
  private
    FEnable: boolean;
    FKey : string;
    FSection : string;
    {$IFDEF DELPHI3_LVL}
    FLocation: TPersistenceLocation;
    {$ENDIF}
  published
    property Enable: Boolean read FEnable write FEnable;
    property Key:string read FKey write FKey;
    property Section:string read FSection write FSection;
    {$IFDEF DELPHI3_LVL}
    property Location: TPersistenceLocation read FLocation write FLocation;
    {$ENDIF}
  end;

  TItemClickEvent = procedure(Sender: TObject; Index: Integer) of object;


  { TListHintWindow }
  TListHintWindow = class(THintWindow)
  private
    FListControl: TListBox;
    procedure WMNCButtonDown(var Message: TMessage); message WM_NCLBUTTONDOWN;
    procedure WMActivate(var Message: TMessage); message WM_ACTIVATE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ListControl: TListBox read FListControl write FListControl;
  end;

  TLookupSettings = class(TPersistent)
  private
    FDisplayList: TStringList;
    FValueList: TStringList;
    FDisplayCount: Integer;
    FColor: TColor;
    FEnabled: Boolean;
    FNumChars: Integer;
    FCaseSensitive: Boolean;
    procedure SetDisplayList(const Value: TStringList);
    procedure SetValueList(const Value: TStringList);
    procedure SetNumChars(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
    property Color: TColor read FColor write FColor;
    property DisplayCount: Integer read FDisplayCount write FDisplayCount;
    property DisplayList: TStringList read FDisplayList write SetDisplayList;
    property Enabled: Boolean read FEnabled write FEnabled;
    property NumChars: Integer read FNumChars write SetNumChars;
    property ValueList: TStringList read FValueList write SetValueList;
  end;



  TEditAlign = (eaLeft,eaRight,eaDefault,eaCenter);

  TAdvEdit = class(TCustomEdit)
  private
    { Private declarations }
    FAlignChanging: Boolean;
    FLabel: TLabel;
    FLabelFont: TFont;
    FLabelPosition: TLabelPosition;
    FLabelMargin: Integer;
    FLabelTransparent: Boolean;
    FAutoFocus: Boolean;
    FCanUndo: Boolean;
    FEditType: TAdvEditType;
    FEditAlign: TEditAlign;
    FOldEditAlign: TEditAlign;
    FOldBorder: TBorderStyle;
    FExcelStyleDecimalSeparator: Boolean;
    FTabOnFullLength: Boolean;
    FDisabledColor: TColor;
    FNormalColor: TColor;
    FFocusColor: TColor;
    FFocusFontColor: TColor;
    FErrorColor: TColor;
    FErrorFontColor: TColor;
    FError: Boolean;
    FFocusLabel: Boolean;
    FFontColor: TColor;
    FModifiedColor: TColor;
    FReturnIsTab: Boolean;
    FShowModified: Boolean;
    FIsModified: Boolean;
    FShowURL: Boolean;
    FURLColor: TColor;
    FFocusWidthInc: Integer;
    FFocusAlign: TEditAlign;
    FLengthLimit : SmallInt;
    FPrecision: SmallInt;
    FPrefix:string;
    FSuffix:string;
    FOldString:string;
    FSigned: Boolean;
    FIsUrl: Boolean;
    FFlat: Boolean;
    FMouseInControl: Boolean;
    FFlatLineColor: TColor;
    FPersistence: TPersistence;
    FOnValueValidate: TValueValidateEvent;
    FOnClipboardCut: TClipboardEvent;
    FOnClipboardPaste: TClipboardEvent;
    FOnClipboardCopy: TClipboardEvent;
    FFlatParentColor: Boolean;
    FTransparent: Boolean;
    FCaretPos: TPoint;
    FOleDropSource: Boolean;
    FOleDropTarget: Boolean;
    FOleDropTargetAssigned: Boolean;
    FIsDragSource: Boolean;
    FButtonDown: Boolean;
    FFocusBorder: Boolean;
    FHintShowLargeText: Boolean;
    FShowError: Boolean;
    FAutoThousandSeparator: Boolean;
    FEmptyText: string;
    FSoftBorder: Boolean;
    FDefaultHandling: Boolean;
    FLabelAlwaysEnabled: Boolean;
    FBorder3D: Boolean;
    FErrorMarkerLen: Integer;
    FErrorMarkerPos: Integer;
    FIndentR: Integer;
    FIndentL: Integer;
    FLoadedHeight: Integer;
    FLookupList: TListHintWindow;
    FLookupListBox: TListbox;
    FLookup: TLookupSettings;
    FOnLookupSelect: TLookupSelectEvent;
    FIsValidating: Boolean;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure WMActivate(var Message: TMessage); message WM_ACTIVATE;
    procedure CNCtlColorEdit(var Message: TWMCtlColorEdit); message CN_CTLCOLOREDIT;
    procedure CNCtlColorStatic(var Message: TWMCtlColorStatic); message CN_CTLCOLORSTATIC;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMCancelMode(var Message: TMessage); message CM_CANCELMODE;
    procedure CMHintShow(Var Msg: TMessage); Message CM_HINTSHOW;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMChar(var Msg:TWMKey); message WM_CHAR;
    procedure WMPaste(var Msg:TMessage); message WM_PASTE;
    procedure WMCut(var Message: TWMCut);   message WM_CUT;
    procedure WMCopy(var Message: TWMCopy);   message WM_COPY;
    procedure WMKeyDown(var Msg:TWMKeydown); message WM_KEYDOWN;
    procedure WMLButtonUp(var Msg:TWMMouse); message WM_LBUTTONUP;
    procedure WMLButtonDown(var Msg:TWMMouse); message WM_LBUTTONDOWN;
    procedure WMPaint(var Msg:TWMPaint); message WM_PAINT;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMDestroy(var Msg:TMessage); message wm_Destroy;
    procedure WMMouseMove(var Msg:TWMMouse); message WM_MOUSEMOVE;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    {$IFNDEF DELPHI3_LVL}
    function GetSelText:string;
    {$ENDIF}
    procedure SetEditType(value : TAdvEditType);
    function GetText:string;
    procedure SetText(value:string);
    function GetFloat: double;
    function GetInt: integer;
    function GetTextSize: integer;
    function FixedLength(s:string): Integer;
    function DecimalPos: Integer;
    procedure SetFloat(const Value: double);
    procedure SetInt(const Value: integer);
    procedure SetPrefix(const Value: string);
    procedure SetSuffix(const Value: string);
    procedure SetLabelCaption(const value: string);
    function GetLabelCaption:string;
    procedure SetLabelPosition(const value: TLabelPosition);
    procedure SetLabelMargin(const value: integer);
    procedure SetLabelTransparent(const value: boolean);
    procedure SetFlat(const value: boolean);
    procedure SetFlatRect(const Value: Boolean);
    procedure SetPrecision(const Value: SmallInt);
    function EStrToFloat(s:string):extended;
    procedure UpdateLabel;
    procedure AutoSeparators;
    function GetModified: boolean;
    procedure SetModified(const Value: boolean);
    function GetVisible: boolean;
    procedure SetVisible(const Value: boolean);
    procedure PaintEdit;
    procedure DrawControlBorder(DC: HDC);
    procedure DrawBorder;
    function Is3DBorderButton: Boolean;
    procedure SetDisabledColor(const Value: TColor);
    function GetEnabledEx: boolean;
    procedure SetEnabledEx(const Value: boolean);
    procedure SetEditAlign(const Value: TEditAlign);
    procedure SetCanUndo(const Value: boolean);
    function GetColorEx: TColor;
    procedure SetColorEx(const Value: TColor);
    procedure SetTransparent(const Value: boolean);
    procedure SetFlatLineColor(const Value: TColor);
    procedure SetFlatParentColor(const Value: boolean);
    procedure LabelFontChange(Sender:TObject);
    procedure SetLabelFont(const Value: TFont);
    function GetError: Boolean;
    procedure SetError(const Value: Boolean);
    function TestURL: Boolean;
    procedure ApplyURL(const Value: Boolean);
    procedure DrawErrorLines(Canvas: TCanvas; ErrPos,ErrLen: Integer);
    {$IFDEF DELPHI3_LVL}
    procedure SetOleDropSource(const Value: boolean);
    procedure SetOleDropTarget(const Value: boolean);
    procedure SetAutoThousandSeparator(const Value: Boolean);
    procedure SetEmptyText(const Value: string);
    procedure SetSoftBorder(const Value: Boolean);
    procedure SetLabelAlwaysEnabled(const Value: Boolean);
    procedure SetBorder3D(const Value: Boolean);
    procedure SetErrorMarkerLen(const Value: Integer);
    procedure SetErrorMarkerPos(const Value: Integer);
    procedure SetFocusBorder(const Value: Boolean);
    function GetHeightEx: Integer;
    procedure SetHeightEx(const Value: Integer);
    procedure UpdateLookup;
    procedure DoneLookup;
    procedure ListKeyPress(Sender: TObject; var Key: Char);
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    {$ENDIF}
  protected
    { Protected declarations }
    procedure Change; override;
    procedure CreateParams(var Params:TCreateParams); override;
    procedure CreateWnd; override;
    function CreateLabel: TLabel;
    procedure Loaded; override;
    procedure InvalidateCaret(pt:tpoint);
    procedure EraseCaret;
    procedure DrawCaretByCursor;
    procedure SetCaretByCursor;
    property IndentR: Integer read FIndentR write FIndentR;
    property IndentL: Integer read FIndentL write FIndentL;
    function DoValidate(value:string): Boolean; virtual;
  public
    { Public declarations }
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SelectAll;
    procedure SelectBeforeDecimal;
    procedure SelectAfterDecimal;
    procedure Init;
    function CharFromPos(pt:TPoint): Integer;
    function PosFromChar(uChar:word):TPoint;
    property FloatValue:double read GetFloat write SetFloat;
    property IntValue: Integer read GetInt write SetInt;
    property Modified: Boolean read GetModified write SetModified;
    property IsError: Boolean read GetError write SetError;
    function RangeStrToList(rangelist:TRangeList): Boolean;
    procedure ListToRangeStr(rangelist:TRangeList);
    procedure LoadPersist; virtual;
    procedure SavePersist; virtual;
    property DefaultHandling: Boolean read FDefaultHandling write FDefaultHandling;
    property EditLabel: TLabel read FLabel;
    property Border3D: Boolean read FBorder3D write SetBorder3D;
  published
    { Published declarations }
    property OnValueValidate: TValueValidateEvent read fOnValueValidate write fOnValueValidate;
    property OnClipboardCopy: TClipboardEvent read fOnClipboardCopy write fOnClipboardCopy;
    property OnClipboardCut: TClipboardEvent read fOnClipboardCut write fOnClipboardCut;
    property OnClipboardPaste: TClipboardEvent read fOnClipboardPaste write fOnClipboardPaste;
    property AutoFocus: boolean read FAutoFocus write fAutoFocus;
    property AutoThousandSeparator: Boolean read FAutoThousandSeparator write SetAutoThousandSeparator default True;
    property EditAlign: TEditAlign read FEditAlign write SetEditAlign;
    property EditType: TAdvEditType read FEditType write SetEditType;
    property EmptyText: string read FEmptyText write SetEmptyText;
    property ErrorMarkerPos: Integer read FErrorMarkerPos write SetErrorMarkerPos;
    property ErrorMarkerLen: Integer read FErrorMarkerLen write SetErrorMarkerLen;
    property ErrorColor: TColor read FErrorColor write FErrorColor;
    property ErrorFontColor: TColor read FErrorFontColor write FErrorFontColor;
    property ExcelStyleDecimalSeparator: boolean read fExcelStyleDecimalSeparator write fExcelStyleDecimalSeparator;
    property Flat: boolean read FFlat write SetFlat;
    property FlatLineColor: TColor read fFlatLineColor write SetFlatLineColor;
    property FlatParentColor: boolean read fFlatParentColor write SetFlatParentColor;
    property FocusAlign: TEditAlign read FFocusAlign write FFocusAlign;
    property FocusBorder: Boolean read FFocusBorder write SetFocusBorder;
    property FocusColor: TColor read FFocusColor write FFocusColor;
    property FocusFontColor: TColor read FFocusFontColor write FFocusFontColor;
    property FocusLabel: Boolean read FFocusLabel write FFocusLabel;
    property FocusWidthInc: Integer read FFocusWidthInc write FFocusWidthInc;
    property Height: Integer read GetHeightEx write SetHeightEx;
    property ModifiedColor: TColor read FModifiedColor write FModifiedColor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor;
    property ShowError: Boolean read FShowError write FShowError default False;
    property ShowModified: Boolean read FShowModified write FShowModified default False;
    property ShowURL: Boolean read FShowURL write FShowURL default False;
    property SoftBorder: Boolean read FSoftBorder write SetSoftBorder default False;
    property URLColor: TColor read FURLColor write FURLColor;
    property ReturnIsTab: Boolean read fReturnIsTab write fReturnIsTab;
    property LengthLimit: smallint read fLengthLimit write fLengthLimit;
    property TabOnFullLength: boolean read fTabOnFullLength write fTabOnFullLength;
    property Precision: smallint read FPrecision write SetPrecision;
    property Prefix:string read FPrefix write SetPrefix;
    property Suffix:string read FSuffix write SetSuffix;
    property LabelCaption:string read GetLabelCaption write SetLabelCaption;
    property LabelPosition:TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelMargin: Integer read FLabelMargin write SetLabelMargin;
    property LabelTransparent: Boolean read FLabelTransparent write SetLabelTransparent;
    property LabelAlwaysEnabled: Boolean read FLabelAlwaysEnabled write SetLabelAlwaysEnabled;
    property LabelFont:TFont read FLabelFont write SetLabelFont;
    property Lookup: TLookupSettings read FLookup write FLookup;
    property Persistence:TPersistence read FPersistence write FPersistence;
    {$IFDEF DELPHI6_LVL}
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property BiDiMode;
    property ParentBiDiMode;
    property Constraints;
    property DragKind;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF}
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CanUndo: boolean read FCanUndo write SetCanUndo default True;
    property Color:TColor read GetColorEx write SetColorEx;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled: Boolean read GetEnabledEx write SetEnabledEx;
    property Font;
    property HideSelection;
    property Hint;
    property HintShowLargeText: boolean read FHintShowLargeText write FHintShowLargeText;
    {$IFDEF DELPHI3_LVL}
    property ImeMode;
    property ImeName;
    {$ENDIF}
    property MaxLength;
    property OEMConvert;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    {$IFDEF DELPHI3_LVL}
    property OleDropTarget: Boolean read fOleDropTarget write SetOleDropTarget;
    property OleDropSource: Boolean read fOleDropSource write SetOleDropSource;
    {$ENDIF}
    {$IFDEF WIN32}
    property PopupMenu;
    {$ENDIF}
    property ReadOnly;
    property ShowHint;
    property Signed: Boolean read FSigned write FSigned;
    property TabOrder;
    property TabStop;
    property Text : string read GetText write SetText;
    property Transparent : boolean read FTransparent write SetTransparent;
    property Visible: Boolean read GetVisible write SetVisible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    {$IFDEF WIN32}
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnStartDrag;
    {$ENDIF}
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    {$IFDEF DELPHI5_LVL}
    property OnContextPopup;
    {$ENDIF}
    property OnLookupSelect: TLookupSelectEvent read FOnLookupSelect write FOnLookupSelect;
  end;

  TAdvMaskEdit = class(TMaskEdit)
  private
    { Private declarations }
    FLabel:TLabel;
    FAutoFocus : boolean;
    FAutoTab: Boolean;
    FReturnIsTab: Boolean;
    FAlignment: TAlignment;
    FFocusColor: TColor;
    FFocusFontColor: TColor;
    FNormalColor: TColor;
    FLoadedColor: TColor;
    FFontColor:TColor;
    FModifiedColor:tcolor;
    FShowModified: Boolean;
    FLabelMargin: integer;
    FLabelPosition: TLabelPosition;
    FLabelTransparent: boolean;
    FSelectFirstChar: boolean;
    FFlat: boolean;
    FOnMaskComplete:TMaskCompleteEvent;
    FDisabledColor: TColor;
    FOriginalValue: string;
    FCanUndo: Boolean;
    FLabelFont: TFont;
    FLabelAlwaysEnabled: Boolean;
    FFlatLineColor: TColor;
    FSoftBorder: Boolean;
    FFocusBorder: Boolean;
    FMouseInControl: Boolean;
    FBorder3D: Boolean;
    FFlatParentColor: Boolean;
    FOldBorder: TBorderStyle;
    procedure SetAlignment(value:TAlignment);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMChar(var Msg:TWMKey); message WM_CHAR;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMPaint(var Msg:TWMPaint); message WM_PAINT;
    procedure WMKeyDown(var Msg:TWMKeydown); message WM_KEYDOWN;
    function GetLabelCaption: string;
    procedure SetLabelCaption(const Value: string);
    procedure SetLabelMargin(const Value: integer);
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure UpdateLabel;
    procedure SetFlat(const Value: boolean);
    function GetModified: boolean;
    procedure SetModified(const Value: boolean);
    procedure SetLabelTransparent(const Value: boolean);
    procedure SetDisabledColor(const Value: TColor);
    function GetEnabledEx: Boolean;
    procedure SetEnabledEx(const Value: Boolean);
    function GetColorEx: TColor;
    procedure SetColorEx(const Value: TColor);
    procedure SetLabelFont(const Value: TFont);
    procedure LabelFontChanged(Sender: TObject);
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
    procedure SetFlatLineColor(const Value: TColor);
    procedure PaintEdit;
    procedure SetSoftBorder(const Value: Boolean);
    procedure DrawBorder;
    procedure DrawControlBorder(DC: HDC);
    function Is3DBorderButton: Boolean;
    procedure SetBorder3D(const Value: Boolean);
    procedure SetFlatRect(const Value: Boolean);
    procedure SetFlatParentColor(const Value: Boolean);
  protected
    { Protected declarations }
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
    procedure CreateParams(var Params:TCreateParams); override;
    procedure CreateWnd; override;
    function CreateLabel: TLabel;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    destructor Destroy; override;
    property Modified: Boolean read GetModified write SetModified;
    procedure Loaded; override;
    property Border3D: Boolean read FBorder3D write SetBorder3D;    
  published
    { Published declarations }
    property AutoFocus: Boolean read fAutoFocus write fAutoFocus;
    property AutoTab: Boolean read FAutoTab write FAutoTab default true;
    property CanUndo: Boolean read FCanUndo write FCanUndo default false;
    property Color:TColor read GetColorEx write SetColorEx;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor;
    property Enabled: Boolean read GetEnabledEx write SetEnabledEx;
    property Flat: Boolean read FFlat write SetFlat;
    property FlatLineColor: TColor read FFlatLineColor write SetFlatLineColor;
    property FlatParentColor: Boolean read FFlatParentColor write SetFlatParentColor;
    property ShowModified: boolean read FShowModified write fShowModified;
    property FocusColor:TColor read FFocusColor write FFocusColor;
    property FocusBorder: Boolean read FFocusBorder write FFocusBorder;
    property FocusFontColor:TColor read FFocusFontColor write fFocusFontColor;
    property LabelCaption:string read GetLabelCaption write SetLabelCaption;
    property LabelAlwaysEnabled: Boolean read FLabelAlwaysEnabled write FLabelAlwaysEnabled;
    property LabelPosition:TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelMargin: Integer read FLabelMargin write SetLabelMargin;
    property LabelTransparent: boolean read FLabelTransparent write SetLabelTransparent;
    property LabelFont: TFont read FLabelFont write SetLabelFont;
    property ModifiedColor:tcolor read FModifiedColor write fModifiedColor;
    property ReturnIsTab: Boolean read FReturnIsTab write fReturnIsTab default True;
    property SoftBorder: Boolean read FSoftBorder write SetSoftBorder default False;
    property Alignement:TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property SelectFirstChar: boolean read fSelectFirstChar write fSelectFirstChar;
    property Visible: Boolean read GetVisible write SetVisible;
    property OnMaskComplete:TMaskCompleteEvent read fOnMaskComplete write fOnMaskComplete;
  end;

  PQueryParams = ^TQueryParams;
  TQueryParams = record
                  Precision: Integer;
                  Flat: Boolean;
                  Lengthlimit: Integer;
                  Prefix:string;
                  Suffix:string;
                 end;

  {$IFDEF DELPHI3_LVL}
  TEditDropTarget = class(TAEDropTarget)
  private
    FAdvEdit:TAdvEdit;
  public
   constructor Create(aEdit:TAdvEdit);
   procedure DropText(pt:tpoint;s:string); override;
   procedure DragMouseMove(pt:tpoint;var allow: Boolean); override;
  end;
  {$ENDIF}


const
 BorderRec: array[TBorderStyle] of Integer = (1, -1);


function AdvInputQuery(const QueryType:tAdvEditType; QueryParams:PQueryParams; const ACaption, APrompt: string;
  var Value: string): Boolean;

implementation

{$IFNDEF VER80}
uses
  shellapi;
{$ENDIF}

const
  Ctrl_Codes    = [vk_back, vk_tab, vk_return];
  Numeric_Codes = [ord('0')..ord('9'),ord('-')];
  Money_Codes   = Numeric_Codes;
  Float_Codes   = Numeric_Codes + [ord(','),ord('.')];
  Range_Codes   = Numeric_Codes + [ord(','),ord(';')];
  Hex_Codes     = Numeric_Codes + [ord('A')..ord('F'),ord('a')..ord('f')];
  Bin_Codes     = ['0','1'];
  AlphaNum_Codes= [ord('0')..ord('9')] + [ord('a')..ord('z'),ord('A')..ord('Z')];

function RangeListCompare(Item1, Item2: Pointer): Integer;
begin
  if integer(Item1)>integer(Item2) then Result := 1 else
    if integer(Item1)=integer(Item2) then Result := 0 else Result := -1;
end;


function ShiftCase(Name: string): string;

function LowCase(C: char): char;
begin
  if C in ['A' .. 'Z'] then LowCase := Chr(Ord(C) - Ord('A') + Ord('a'))
  else Lowcase := C;
end;

const
  Terminators = [' ',',','.','-',''''];
var
  I, L: integer;
  NewName: string;
  First: boolean;
begin
  First:= true;
  NewName:= Name;
  L := Length(Name);
  for I:= 1 to L do begin
    if NewName[I] in Terminators then First:= true
    else if First then begin
      NewName[I]:= Upcase(Name[I]);
      First:= false;
    end
    else NewName[I]:= Lowcase(Name[I]);
    if (Copy(NewName, 1, I) = 'Mc') or
      ((Pos (' Mc', NewName) = I - 2) and (I > 2)) or
      ((I > L - 3) and ((Copy(NewName, I - 1, 2) = ' I') or
        (Copy(NewName, I - 2, 3) = ' II'))) then
          First:= true;
  end;
  ShiftCase := NewName;
end;

function IsType(s:string):TAutoType;
var
  i: Integer;
  isI,isF,isH: Boolean;
  th,de,mi: Integer;

begin
  Result := atString;

  isI:=true;
  isF:=true;
  isH:=true;

  if s='' then
  begin
    isI:=false;
    isF:=false;
    isH:=false;
  end;

  th:=-1; de:=0; mi:=0;

  for i:=1 to Length(s) do
  begin
    if not (ord(s[i]) in Numeric_Codes) then isI:=false;
    if not (ord(s[i]) in Float_Codes)   then isF:=false;
    if not (ord(s[i]) in Hex_Codes)     then isH:=false;

    if (s[i]=thousandseparator) and (i-th<3) then isF:=false;

    if s[i]=thousandseparator then th:=i;
    if s[i]=decimalseparator then inc(de);
    if s[i]='-' then inc(mi);
  end;

 if isH and not isI then
   Result := atHex;

  if isI then
    Result := atNumeric
  else
  begin
    if isF then
      Result := atFloat;
  end;

  if (mi>1) or (de>1) then
    Result := atString;
end;

function StripThousandSep(s:string):string;
begin
  while (Pos(ThousandSeparator,s)>0) do
    Delete(s,Pos(ThousandSeparator,s),1);
  Result := s;
end;

function TAdvEdit.EStrToFloat(s:string):extended;
begin
  if  Pos(ThousandSeparator,s) > 0 then
    s := StripThousandSep(s);

  if (FPrecision > 0) and (Length(s) > FPrecision) then
  if s[Length(s) - FPrecision] = Thousandseparator then
    s[Length(s) - FPrecision] := Decimalseparator;
  try
    Result := StrToFloat(s);
  except
    Result := 0;
  end;    
end;

function HexToInt(s:string): Integer;
var
 i: Integer;
 r,m: Integer;

 function CharVal(c:char): Integer;
 begin
  Result := 0;
  if (c in ['0'..'9']) then Result := ord(c)-ord('0');
  if (c in ['A'..'F']) then Result := ord(c)-ord('A')+10;
  if (c in ['a'..'f']) then Result := ord(c)-ord('a')+10;
 end;

begin
 r:=0;
 m:=1;
 for i:=Length(s) downto 1 do
  begin
    r:=r+m*CharVal(s[i]);
    m:=m shl 4;
  end;
 Result := r;
end;

function TAdvEdit.CharFromPos(pt:TPoint): Integer;
begin
 Result := Loword(SendMessage(self.Handle,EM_CHARFROMPOS,0,makelparam(pt.x,pt.y)));
end;

function TAdvEdit.PosFromChar(uChar:word):TPoint;
var
  pt:tpoint;
  l: Integer;
  DC:HDC;
  s:string;
  sz:TSize;
begin
  if uChar = 0 then
    Result := Point(0,0);

  l := SendMessage(Handle,EM_POSFROMCHAR,uChar,0);
  pt := Point(loword(l),hiword(l));

  Result := pt;

  if (pt.x <0 ) or (pt.y < 0) or (pt.x >= 65535) or (pt.y >= 65535) then
  begin
     s := inherited Text;

     if Length(s) = 0 then
       Result := Point(0,0)
     else
     begin
       dec(uChar);
       l := SendMessage(Handle,EM_POSFROMCHAR,uChar,0);
       pt.x := loword(l);
       pt.y := hiword(l);

       Delete(s,1,Length(s)-1);
       DC := GetDC(Handle);
       GetTextExtentPoint32(DC,pchar(s+'w'),2,sz);
       pt.x := pt.x + sz.cx;
       GetTextExtentPoint32(DC,pchar(s),2,sz);
       pt.x := pt.x - sz.cx;
       ReleaseDC(Handle,DC);
     end;

     Result := pt;
  end;
end;

function TAdvEdit.GetTextSize: Integer;
var
 DC: HDC;
 sz: TSize;
 holdFont: THandle;
begin
 DC := GetDC(Handle);
 holdFont := SelectObject(DC, Font.Handle);
 GetTextExtentPoint32(DC,pchar(Text),Length(Text),sz);
 result := sz.CX;
 SelectObject(DC, holdFont);
 ReleaseDC(Handle,DC);
end;


procedure TAdvEdit.InvalidateCaret(pt:TPoint);
var
  r: TRect;
begin
  r:=rect(pt.x,pt.y,pt.x+1,pt.y-Font.Height);
  InvalidateRect(self.Handle,@r,true);
end;

procedure TAdvEdit.EraseCaret;
var
  pt: TPoint;
begin
  pt := FCaretPos;
  FCaretPos := Point(-1,-1);
  InvalidateCaret(pt);
end;

procedure TAdvEdit.DrawCaretByCursor;
var
  nChar: Integer;
  pt,ptCursor:TPoint;
begin
  GetCursorPos(ptCursor);
  ptCursor := ScreenToClient(ptCursor);

  nChar := CharFromPos(ptCursor);

  pt := PosFromChar(nChar);

  if (fCaretPos.x <> pt.x) or (fCaretPos.y <> pt.y) then
  begin
    InvalidateCaret(fCaretPos);
    InvalidateCaret(pt);
    FCaretPos := pt;
  end;
end;

procedure TAdvEdit.SetCaretByCursor;
var
  ptCursor: TPoint;
  nChar: integer;
begin
  GetCursorPos(ptCursor);
  ptCursor := ScreenToClient(ptCursor);
  nChar := loword(SendMessage(self.Handle,EM_CHARFROMPOS,0,makelong(ptCursor.x,ptCursor.y)));
  SelStart := nChar;
  SelLength := 0;
end;




procedure TAdvEdit.WMChar(var Msg: TWMKey);
var
  oldSelStart,oldSelLength,oldprec: Integer;
  s:string;
  key:char;

  function scanprecision(s:string;inspos: Integer): Boolean;
  var
    mdist: Integer;
  begin
    Result := false;
    inspos:=inspos-Length(fPrefix);
    if FPrecision<=0 then Exit;

    if (Length(s)-inspos>FPrecision) then
    begin
      Result := false;
      exit;
    end;

    if (Pos(decimalseparator,s)>0) then
    begin
      mdist:=Length(s)-Pos(decimalseparator,s);
      if (inspos>=Pos(decimalseparator,s)) and (mdist>=FPrecision) then Result := true;
    end;
  end;

  function scandistance(s:string;inspos: Integer): Boolean;
  var
    mdist: Integer;
  begin
    Result := false;
    inspos:=inspos-Length(fPrefix);
    mdist:=Length(s);

    if (Pos(thousandseparator,s)=0) then
    begin
      Result := false;
      exit;
    end;

    while (Pos(thousandseparator,s)>0) do
    begin
      if abs(Pos(thousandseparator,s)-inspos)<mdist then mdist:=abs(Pos(thousandseparator,s)-inspos);
      if (abs(Pos(thousandseparator,s)-inspos)<3) then
      begin
        Result := true;
        break;
      end;

      if inspos>Pos(thousandseparator,s) then inspos:=inspos-Pos(thousandseparator,s);
      delete(s,1,Pos(thousandseparator,s));
    end;

    if (mdist>3) then
    begin
      Result := true;
    end;
  end;


begin
  if Msg.CharCode = VK_RETURN then
  begin
    key := #13;
    if Assigned(OnKeyPress) then
      OnKeyPress(Self,key);

    Msg.CharCode := 0;

    if not DefaultHandling then
    begin
      if (Parent is TWinControl) then
      begin
        PostMessage((Parent as TWinControl).Handle,WM_KEYDOWN,VK_RETURN,0);
        PostMessage((Parent as TWinControl).Handle,WM_KEYUP,VK_RETURN,0);
      end;
    end;

    Exit;
  end;

  if Msg.CharCode = VK_ESCAPE then
  begin
    if not DefaultHandling then
    begin
      if (Parent is TWinControl) then
      begin
        PostMessage((Parent as TWinControl).Handle,WM_KEYDOWN,VK_ESCAPE,0);
        PostMessage((Parent as TWinControl).Handle,WM_KEYUP,VK_ESCAPE,0);
      end;
    end;
  end;

  if (Msg.Charcode = VK_ESCAPE) and not FCanUndo then
  begin
    inherited;
    Exit;
  end;

  if (msg.charcode = ord('.')) and (fExcelStyleDecimalSeparator) and (msg.keydata and $400000=$400000) then
  begin
    msg.charcode:=ord(decimalseparator);
  end;

  if (msg.charcode=vk_back) and (fPrefix<>'') then
    if (SelStart<=Length(fPrefix)) and (SelLength=0) then Exit;

  if (flengthlimit>0) and (FixedLength(self.text)>flengthlimit) and
     (SelLength=0) and (SelStart < decimalpos)
     and (msg.charcode<>vk_back) and (msg.charcode<>ord(decimalseparator)) then Exit;

  if (msg.charcode=vk_back) then
  begin
    s:=self.text;
    if SelLength=0 then
      delete(s,SelStart-Length(fprefix),1)
    else
      delete(s,SelStart-Length(fprefix),SelLength);

    if (lengthlimit>0) and (fixedLength(s)-1>lengthlimit) then
    begin
      Exit;
    end;
  end;

  if (EditType in [etMoney,etNumeric,etFloat]) and not FSigned and (msg.charcode=ord('-')) then
    Exit;

  case EditType of
  etString,etPassword:inherited;
  etAlphaNumeric:if msg.charcode in AlphaNum_Codes + Ctrl_Codes then inherited;
  etNumeric:begin
             if (msg.CharCode=ord('-')) then
             begin
              s := self.Text;
              oldSelStart:=SelStart;
              oldSelLength:=SelLength;

               if (Pos('-',s)>0) then
                 begin
                  delete(s,1,1);
                  inherited Text:=s;
                  if (oldSelStart>0) and (oldSelStart>Length(fPrefix)) then SelStart:=oldSelStart-1
                  else SelStart:=Length(Prefix);
                 end
               else
                 begin
                  inherited Text:='-'+self.text;
                  SelLength:=0;
                  SelStart:=oldSelStart+1;
                  SetModified(true);
                 end;
               SelLength:=oldSelLength;
             end
            else
             begin
             if (msg.charcode in Numeric_Codes + Ctrl_Codes) then Inherited;

             if ( (GetKeyState(vk_rcontrol) and $8000=$8000) or
                  (GetKeyState(vk_lcontrol) and $8000=$8000) ) then Inherited;
             end;
           end;
 etHex:if msg.charcode in Hex_Codes + Ctrl_Codes then inherited;
 

 etRange:begin
           if msg.charcode in Range_Codes + Ctrl_Codes then
            begin
             s:=(inherited Text)+' ';
             if (msg.charcode in [ord('-'),ord(','),ord(';')]) then
               begin
                if (SelStart<=Length(fPrefix)) then exit;
                if (SelStart>Length(fPrefix)) and (s[SelStart] in ['-',',',';']) then exit;
                if (SelStart>Length(fPrefix)) and (s[SelStart+1] in ['-',',',';']) then exit;
                inherited;
               end
             else inherited;
            end;
         end;
 etMoney:begin
          if (chr(msg.charcode)=decimalseparator) and
             ((Pos(decimalseparator,self.Text)>0) or (FPrecision=0)) then
               begin
                if (FPrecision>0) then SelectAfterDecimal;
                Exit;
               end;

          if (msg.charcode in Money_Codes + Ctrl_Codes) or (chr(msg.charcode)=decimalseparator) then
           begin
             if (chr(msg.charcode) in [thousandseparator,decimalseparator]) then
              begin
               if scandistance(self.Text,SelStart) then exit;
              end;

            if scanprecision(self.Text,SelStart) and (msg.charcode in [$30..$39,ord(decimalseparator)]) and (SelLength=0) then
             begin
               if (FPrecision>0) and (SelStart-Length(fprefix)>=Pos(decimalseparator,self.text))
                  and (msg.charcode in [$30..$39]) and (SelStart-Length(fprefix)<Length(self.text)) then
                 begin
                  SelLength:=1;
                 end
               else Exit;
             end;

            if (SelStart=0) and (self.Text='') and (msg.charcode=ord(decimalseparator)) then
             begin
              inherited Text:='0'+decimalseparator;
              SelStart:=2;
              SetModified(true);
              exit;
             end;

            if (msg.charcode=ord('-')) and (SelLength=0) then
              begin
               s:=self.Text;
               oldprec:=FPrecision;
               FPrecision:=0;
               oldSelStart:=SelStart;

               if (Pos('-',s)<>0) then
                 begin
                  delete(s,1,1);
                  inherited Text:=s;
                  SetModified(true);
                  if (oldSelStart>0) and (oldSelStart>Length(fPrefix)) then SelStart:=oldSelStart-1
                  else SelStart:=Length(Prefix);
                 end
               else
                 begin
                  if (floatvalue<>0) or (1>0) then
                   begin
                     inherited Text:='-'+self.Text;
                     SelLength:=0;
                     SelStart:=oldSelStart+1;
                     SetModified(true);
                   end;
                 end;
               FPrecision:=oldprec;
               exit;
              end;

            inherited;

            if (self.Text<>'') and (self.Text<>'-') and
               (chr(msg.charcode)<>decimalseparator) then
                 begin
                  if inherited Modified then SetModified(true);
                  AutoSeparators;
                 end;
           end;
         end;
 etFloat:begin
           if (msg.charcode = ord(',')) and (DecimalSeparator <> ',') and (ThousandSeparator <> ',') then
             Exit;
           if (msg.charcode = ord('.')) and (DecimalSeparator <> '.') and (ThousandSeparator <> '.') then
             Exit;

           if (msg.charcode in Float_Codes+Ctrl_Codes) then
             begin
             if (chr(msg.charcode)=decimalseparator) and
                (Pos(decimalseparator,self.getseltext)=0) and
                ((Pos(decimalseparator,self.Text)>0) or (FPrecision=0)) then
               begin
                if (FPrecision>0) then SelectAfterDecimal;
                Exit;
               end;

             if ((msg.charcode=ord(',')) and (Pos(',',self.Text)>0) and (Pos(',',self.getSelText)=0)) and
                 (chr(msg.charcode)<>thousandseparator) then exit;

             if (chr(msg.charcode) in [thousandseparator,decimalseparator]) then
              begin
               if scandistance(self.Text,SelStart) then exit;
              end;

             if scanprecision(self.text,SelStart) and (msg.charcode in [$30..$39,ord(decimalseparator)]) and (SelLength=0) then
              begin
               if (FPrecision>0) and (SelStart-Length(fprefix)>=Pos(decimalseparator,self.Text))
                  and (msg.charcode in [$30..$39]) and (SelStart-Length(fprefix)<Length(self.Text)) then
                 begin
                  SelLength:=1;
                 end
               else exit;
              end;

             if (SelStart=0) and (self.Text='') and (msg.charcode=ord(decimalseparator)) then
              begin
               inherited Text:='0'+decimalseparator;
               SelStart:=2;
               SetModified(true);
               exit;
              end;

            if (msg.charcode=ord('-')) and (SelLength=0) then
              begin
               s:=self.Text;
               oldprec:=FPrecision;
               FPrecision:=0;
               oldSelStart:=SelStart;

               if (Pos('-',s)<>0)  then
                 begin
                  delete(s,1,1);
                  inherited Text:=s;
                  if (oldSelStart>0) and (oldSelStart>Length(fPrefix)) then SelStart:=oldSelStart-1
                  else SelStart:=Length(Prefix);
                  SetModified(true);
                 end
               else
                 begin
                   if (floatvalue<>0) or (1>0) then
                   begin
                     inherited Text:='-'+self.text;
                     SelLength:=0;
                     SelStart:=oldSelStart+1;
                     SetModified(true);
                   end;
                 end;
               FPrecision := oldprec;
               Exit;
              end;

              inherited;
             end;
         end;
  etUppercase:begin
             s:=ansiuppercase(chr(msg.charcode));
             msg.charcode:=ord(s[1]);
             inherited;
            end;
  etLowercase:begin
             s:=ansilowercase(chr(msg.charcode));
             msg.charcode:=ord(s[1]);
             inherited;
            end;
  etMixedCase:begin
                oldSelStart:=SelStart;
                inherited;
                inherited Text:=ShiftCase(self.text);
                SelStart:=oldSelStart+1;
              end;
 end;

  if (FTabOnFullLength) then
  begin
    if (FLengthlimit>0) and (FixedLength(self.text)>flengthlimit) and
      (SelLength=0) and (SelStart = fLengthlimit) then postmessage(self.handle,wm_keydown,VK_TAB,0);
  end;

  if inherited Modified then SetModified(true);

  UpdateLookup;
end;

procedure TAdvEdit.CreateParams(var Params:TCreateParams);
begin
  inherited CreateParams(params);

  if not (FEditType = etPassword) then
  begin
    Params.Style := Params.Style or ES_MULTILINE;
  end;

  case FEditAlign of
  eaRight:
    begin
      Params.Style := Params.Style AND NOT (ES_LEFT) AND NOT (ES_CENTER);
      Params.Style := Params.Style OR (ES_RIGHT);
    end;
  eaCenter:
    begin
      Params.Style := Params.Style AND NOT (ES_LEFT) AND NOT (ES_RIGHT);
      Params.Style := Params.Style OR (ES_CENTER);
    end;
  end;
end;

procedure TAdvEdit.CMFontChanged(var Message: TMessage);
begin
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then
    if FLabel<>nil then FLabel.Font.Assign(self.font);
  inherited;
  SetFlatRect(FFlat);
end;

procedure TAdvEdit.CMCancelMode(var Message: TMessage);
begin
  inherited;
  if FLookupList.Visible then
    FLookupList.Hide;
end;

procedure TAdvEdit.SetFlatRect(const Value: Boolean);
var
  loc: TRect;
begin
  if Value then
  begin
    loc.Left := 2 + IndentL;
    loc.Top := 4;
    loc.Right := Clientrect.Right - 2 - IndentR;
    loc.Bottom := Clientrect.Bottom - 4;
  end
  else
  begin
    loc.Left := IndentL;
    loc.Top := 0;
    loc.Right := ClientRect.Right - IndentR;
    loc.Bottom := ClientRect.Bottom;
  end;

  SendMessage(Handle,EM_SETRECTNP,0,longint(@loc));
end;

procedure TAdvEdit.SetFlat(const value: boolean);
var
  OldColor: TColor;

begin
  if (csLoading in ComponentState) then
  begin
    FFlat := Value;
    Exit;
  end;

  if FFlat <> Value then
  begin
    FFlat := Value;
    if FFlat then
    begin
      OldColor := Color;
      if FFlatParentColor then
      begin
        Color := (Parent as TWinControl).Brush.Color;
        FocusColor := Color;
      end
      else
      begin
        FocusColor := FFocusColor;
      end;

      FNormalColor := OldColor;
      BorderStyle := bsNone;
      SetFlatRect(True);
    end
    else
    begin
      Color := FNormalColor;
      FocusColor := FFocusColor;
      BorderStyle := FOldBorder;
      SetFlatRect(False);
    end;
    Invalidate;
  end;
end;

procedure TAdvEdit.CNCtlColorEdit(var Message: TWMCtlColorEdit);
begin
  inherited;
  if FTransparent then SetBkMode(Message.ChildDC, Windows.TRANSPARENT);
end;

procedure TAdvEdit.CNCtlColorStatic(var Message: TWMCtlColorStatic);
begin
  inherited;
  if FTransparent then SetBkMode(Message.ChildDC, Windows.TRANSPARENT);
end;


procedure TAdvEdit.SetTransparent(const Value: boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    Invalidate;
  end;
end;

procedure TAdvEdit.SetFlatLineColor(const Value: TColor);
begin
  FFlatLineColor := Value;
  Invalidate;
end;

procedure TAdvEdit.SetFlatParentColor(const Value: boolean);
begin
  FFlatParentColor := Value;
  Invalidate;
end;

procedure TAdvEdit.SetEditType(value: TAdvEditType);
var
  at: TAutoType;
begin
  if FEditType <> Value then
  begin
    FEditType := Value;
    if FEditType = etPassword then
    begin
      PassWordChar := '*';
      FCanUndo := False;
      // FEditAlign := eaLeft;
      ReCreateWnd;
    end
    else
      Passwordchar := #0;

    at := IsType(self.Text);
    case FEditType of
    etHex:if not (at in [atNumeric,atHex]) then self.IntValue := 0;
    etNumeric:if (at<>atNumeric) then self.IntValue := 0;
    etFloat,etMoney:if not (at in [atFloat,atNumeric]) then self.FloatValue := 0.0;
    end;

    if (csDesigning in ComponentState) and (FEditType = etFloat) and (Precision = 0) then
      Precision := 2;
  end;
end;

procedure TAdvEdit.SetEditAlign(const Value: TEditAlign);
begin
  if FEditAlign <> Value then
  begin
    FEditAlign := Value;
    ReCreateWnd;
    {force a proper re-alignment}
    self.Width := self.Width + 1;
    self.Width := self.Width - 1;
  end;
end;

procedure TAdvEdit.SetCanUndo(const Value: boolean);
begin
  if FCanUndo <> Value then
  begin
    FCanUndo := Value;
    //CanUndo is not compatible with etPassword style
    if FCanUndo and (FEditType = etPassWord) then
      FCanUndo := False;
    ReCreateWnd;
    {force a proper re-alignment}
    self.Width := self.Width + 1;
    self.Width := self.Width - 1;
  end;
end;

procedure TAdvEdit.WMActivate(var Message: TMessage);
begin
  inherited;
end;

procedure TAdvEdit.WMKillFocus(var Msg: TWMKillFocus);
var
  IsValid: Boolean;
begin
  if (csLoading in ComponentState) then
    Exit;

  if FLookupList.Visible and not (msg.FocusedWnd = FLookupList.Handle) then
    FLookupList.Hide;

  if not ((IsError and ShowError) or (ShowModified)) then
  begin
    Color := FNormalColor;
    if not (TestURL and ShowURL) then
      Font.Color := FFontColor;
  end;

  if fFocusLabel and (FLabel<>nil) then
    FLabel.Font.Style:=FLabel.Font.Style-[fsBold];

  if (EditType in [etFloat,etMoney]) and (self.Text='') then
    Floatvalue:=0.0;

  if (FPrecision>0) and (EditType in [etFloat,etMoney]) then
    Floatvalue:=self.Floatvalue;

  if (EditType in [etNumeric]) and (Self.Text='') then
    Text := '0';



  IsValid := DoValidate(Self.Text);
  

  if not IsValid then
  begin
    Msg.Result := 0;
  end;

  inherited;

  if FFocusBorder then
    Invalidate;

  if FAlignChanging then
    Exit;

  if FFocusWidthInc > 0 then
    Width := Width - FFocusWidthInc;

  if (FEditAlign <> FOldEditAlign) and (FFocusAlign <> eaDefault) then
  begin
    EditAlign := FOldEditAlign;
  end;

  if (EmptyText <> '') and (Text = '') then
    Invalidate;

  if ErrorMarkerLen > 0 then
    Invalidate;
end;

procedure TAdvEdit.SelectAll;
begin
  SelStart := 0;
  SelLength := Length(self.text);

  if (fPrefix <> '') then
  begin
   if (SelStart < Length(fPrefix)) then
    begin
     SelStart := Length(fPrefix);
     SelLength := Length(self.Text);
    end;
  end;

  if (fSuffix<>'') then
  begin
    SelStart := Length(fPrefix);
    SelLength := Length(self.text);
  end;

  if (Pos('://',self.Text)>0) and FShowURL then
  begin
    SelStart := Pos('://',self.text)+2;
    SelLength := Length(self.text);
  end;

  if (Pos('mailto:',self.text)>0) and FShowURL then
  begin
    SelStart := Pos('mailto:',self.text)+6;
    SelLength := Length(self.text);
  end;
end;

procedure TAdvEdit.SelectBeforeDecimal;
var
 i: Integer;
begin
 i:=Pos(decimalseparator,self.text);
 if (i>0) then
   SelStart:=i+Length(fPrefix)-1
 else
   SelStart:=Length(fPrefix);
end;

procedure TAdvEdit.SelectAfterDecimal;
var
 i: Integer;
begin
 i := Pos(decimalseparator,self.Text);

 if (i>0) then
   SelStart := i + Length(fPrefix)
 else
   SelStart := Length(fPrefix);
end;


procedure TAdvEdit.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  FOldString := Self.Text;

  if not ((IsError and ShowError) or (ShowModified)) then
  begin
    inherited Color := FFocusColor;

    if (Font.Color <> FFontColor) then
      FFontColor:= Font.Color;

    if not (TestURL and ShowURL) then
      Font.Color := FFocusFontColor;
  end;

  if AutoSelect then
    SelectAll
  else
    if EditType in [etFloat,etMoney] then
      SelectBeforeDecimal;

  if FFocusLabel and (FLabel<>nil) then
    FLabel.Font.Style := FLabel.Font.Style + [fsBold];

  if (FFocusWidthInc > 0) and not FAlignChanging then
    Width := Width + FFocusWidthInc;

  if (FEditAlign <> FFocusAlign) and (FFocusAlign <> eaDefault) then
  begin
    FOldEditAlign := EditAlign;
    FAlignChanging := True;
    EditAlign := FFocusAlign;
    FAlignChanging := False;
  end;

  if ((EmptyText <> '') and (Text = '')) or (FocusBorder) then
    Invalidate;
end;

constructor TAdvEdit.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFocusColor := clWindow;
  FFocusFontColor := clWindowText;
  FFocusAlign := eaDefault;
  FFontColor := self.Font.Color;
  FModifiedColor := clHighLight;
  FErrorColor := clRed;
  FErrorFontColor := clWhite;
  FError := False;
  FLabel:=nil;
  FLabelMargin := 4;
  FURLColor := clBlue;
  FDisabledColor := clSilver;
  FPersistence := TPersistence.Create;
  FFlatParentColor := True;
  FFlatLineColor := clBlack;
  FCaretPos := point(-1,-1);
  FButtonDown := false;
  FMouseInControl := false;
  FCanUndo := True;
  FLabelFont := TFont.Create;
  FLabelFont.OnChange := LabelFontChange;
  FAutoThousandSeparator := True;
  FDefaultHandling := True;
  FOldBorder := bsSingle;

  if not (csDesigning in ComponentState) then
  begin
    FLookupList := TListHintWindow.Create(Self);
    FLookupList.Visible := False;
    FLookupList.Width := 0;
    FLookupList.Height := 0;
    FLookupList.Parent := Self;
    FLookupListbox := TListBox.Create(FLookupList);
    with FLookupListBox do
    begin
      Parent := FLookupList;
      Align := alclient;
      Style := lbOwnerDrawFixed;
      ItemHeight := 12;
      Ctl3D := false;
      TabStop := true;
      TabOrder := 0;
      OnKeyPress := ListKeyPress;
      OnMouseUp := ListMouseUp;
    end;
    FLookupList.ListControl := FLookupListBox;
  end;  
  FLookup := TLookupSettings.Create;
end;

destructor TAdvEdit.Destroy;
begin
  if FLabel <> Nil then
    FLabel.Free;
  FLabelFont.Free;
  FPersistence.Free;
  FPersistence := Nil;
  if not (csDesigning in ComponentState) then
  begin
    FLookupListBox.Free;
    FLookupList.Free;
  end;
  FLookup.Free;
  inherited Destroy;
end;

procedure TAdvEdit.ApplyURL(const Value: Boolean);
begin
  if Value then
  begin
    Font.Style := Font.Style + [fsUnderline];
    Font.Color := FURLColor;
    FIsUrl := True;
    {$IFDEF DELPHI3_LVL}
    Cursor := crHandPoint;
    {$ENDIF}
    Invalidate;
  end
  else
  begin
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := FFontColor;
    FIsUrl := False;
    {$IFDEF DELPHI3_LVL}
    Cursor := crDefault;
    {$ENDIF}
  end;
end;

procedure TAdvEdit.CNCommand(var Message: TWMCommand);
begin
  if (Message.NotifyCode = EN_CHANGE) then
    if FTransparent then
    begin
      Invalidate;
    end;

  if (Message.NotifyCode = EN_CHANGE) and (FShowURL) then
  begin
    if TestURL and not FIsUrl then
    begin
      ApplyURL(True);
    end
    else
      if FIsUrl and not TestURL then
      begin
        ApplyURL(False);
      end;
  end;
  inherited;
end;


procedure TAdvEdit.WMKeyDown(var Msg: TWMKeydown);
var
  selp: Integer;
  s:string;
begin
  if (msg.CharCode = VK_RETURN) and FLookupList.Visible then
  begin
    DoneLookup;
    Exit;
  end;

  if (msg.CharCode = VK_HOME) and FLookupList.Visible then
  begin
    FLookupListBox.ItemIndex := 0;
    Msg.result := 1;
    Exit;
  end;

  if (msg.CharCode = VK_END) and FLookupList.Visible then
  begin
    FLookupListBox.ItemIndex := FLookupListBox.Items.Count - 1;
    Msg.result := 1;
    Exit;
  end;

  if (msg.CharCode = VK_NEXT) and FLookupList.Visible then
  begin
    if FLookupListBox.ItemIndex + FLookup.DisplayCount < FLookupListBox.Items.Count then
      FLookupListBox.ItemIndex := FLookupListBox.ItemIndex + FLookup.DisplayCount
    else
      FLookupListBox.ItemIndex := FLookupListBox.Items.Count - 1;
    Msg.result := 1;
    Exit;
  end;

  if (msg.CharCode = VK_PRIOR) and FLookupList.Visible then
  begin
    if FLookupListBox.ItemIndex > FLookup.DisplayCount then
      FLookupListBox.ItemIndex := FLookupListBox.ItemIndex - FLookup.DisplayCount
    else
      FLookupListBox.ItemIndex := 0;
    Msg.result := 1;
    Exit;
  end;

  if (msg.charcode = VK_RETURN) and (FReturnIsTab) then
  begin
    msg.charcode := VK_TAB;
    if IsWindowVisible(self.Handle) then
      PostMessage(self.Handle,WM_KEYDOWN,VK_TAB,0);
  end;

  if (msg.charcode = VK_RIGHT) and (FSuffix <> '') then
  begin
    selp := hiword(SendMessage(self.handle,EM_GETSEL,0,0));
    if selp >= Length(self.text) then
    begin
      msg.charcode:=0;
      msg.Result := 0;
      Exit;
    end;
  end;

  if (msg.charcode = VK_DELETE) and (FSuffix <> '') then
  begin
    selp := hiword(SendMessage(self.handle,EM_GETSEL,0,0));
    if (selp>=Length(self.text)) and (SelLength=0) then
    begin
      msg.charcode := 0;
      msg.Result := 0;
      Exit;
    end;
    SetModified(true);
  end;

  if (msg.charcode = VK_LEFT) and (FPrefix <> '') then
  begin
    selp := hiword(SendMessage(self.handle,EM_GETSEL,0,0));

    if selp <= Length(FPrefix) then
    begin
      msg.charcode := 0;
      msg.Result := 0;
      Exit;
    end;
  end;

  if (msg.charcode = VK_END) and (FSuffix <> '') then
  begin
    if (GetKeyState(VK_SHIFT) and $8000=0) then
    begin
      SelStart := Length(self.text);
      SelLength := 0;
    end
    else
      SelLength := Length(self.text)-SelStart;
    msg.charcode := 0;
    msg.Result := 0;
    Exit;
  end;

  if (msg.charcode = VK_HOME) and (FPrefix <> '') then
  begin
    if (getkeystate(VK_SHIFT) and $8000=0) then
    begin
      SelStart := Length(fPrefix);
      SelLength := 0;
    end
    else
    begin
      SendMessage(self.handle,EM_SETSEL,Length(fprefix)+Length(self.text),Length(fprefix));
    end;
    msg.Charcode := 0;
    msg.Result := 0;
    Exit;
  end;

  if (msg.charcode = VK_BACK)  and (FPrefix <> '') then
  begin
    if (SelStart <= Length(FPrefix) + 1) then
    begin
      msg.CharCode := 0;
      msg.Result := 0;
      Exit;
    end;
    SetModified(true);
  end;

  if (msg.CharCode = VK_DELETE) and (SelStart >= Length(FPrefix)) then
  begin
    s:=self.text;
    if SelLength=0 then
      Delete(s,SelStart-Length(fprefix)+1,1)
    else
      Delete(s,SelStart-Length(fprefix)+1,SelLength);

    if (lengthlimit>0) and (fixedLength(s)-1>lengthlimit) then
    begin
      msg.CharCode := 0;
      msg.Result := 0;
      exit;
    end;
    SetModified(true);
  end;

  if (msg.CharCode = VK_UP) and FLookupList.Visible then
  begin
    if FLookupListBox.ItemIndex > 0 then
      FLookupListBox.ItemIndex := FLookupListBox.ItemIndex - 1;
  end;

  if (msg.CharCode = VK_DOWN) and FLookupList.Visible then
  begin
    if FLookupListBox.ItemIndex + 1 < FLookupListBox.Items.Count then
      FLookupListBox.ItemIndex := FLookupListBox.ItemIndex + 1;
  end;


  inherited;

  if (msg.charcode = vk_delete) and (EditType = etMoney) then
    AutoSeparators;
    
  if (fPrefix <> '') and (SelStart < Length(fPrefix)) then
    SelStart := Length(fPrefix);
end;

procedure TAdvEdit.WMCopy(var Message: TWMCopy);
var
  Allow: Boolean;
begin
  Allow := True;
  if Assigned(FOnClipboardCopy) then
    FOnClipboardCopy(self,copy(self.Text,SelStart+1-Length(fPrefix),SelLength),allow);
  if Allow then inherited;
end;

procedure TAdvEdit.WMCut(var Message: TWMCut);
var
  Allow: Boolean;
begin
  Allow := True;
  if Assigned(FOnClipboardCut) then
    FOnClipboardCut(self,copy(self.text,SelStart+1-Length(fPrefix),SelLength),allow);
  if Allow then inherited;
end;


procedure TAdvEdit.WMPaste(var Msg: TMessage);
var
  Data: THandle;
  content: PChar;
  newstr: string;
  newss,newsl,i: Integer;
  allow: Boolean;

  function InsertString(s:string):string;
  var
    ss: Integer;
  begin
    Result := self.text;
    ss := SelStart-Length(fPrefix);
    if (SelLength=0) then
    begin
      insert(s,result,ss+1);
      newsl:=0;
      newss:=ss+Length(s)+Length(fPrefix);
    end
    else
    begin
      delete(result,ss+1,SelLength);
      insert(s,result,ss+1);
      newsl:=Length(s);
      newss:=ss+Length(fPrefix);
    end;
  end;

begin
  if ReadOnly then
    Exit;

  if ClipBoard.HasFormat(CF_TEXT) then
  begin
    ClipBoard.Open;
    Data := GetClipBoardData(CF_TEXT);
    try
      if Data <> 0 then
        Content := PChar(GlobalLock(Data))
      else
        Content := nil
    finally
      if Data <> 0 then
        GlobalUnlock(Data);
    ClipBoard.Close;
    end;

    if Content = nil then
      Exit;

    Allow := True;
    if Assigned(FOnClipboardPaste) then
      FOnClipboardPaste(self,Copy(self.text,SelStart+1,SelLength),allow);

    if not Allow then Exit;

    newstr := InsertString(StrPas(Content));

    case FEditType of
    etAlphaNumeric:
      begin
        Allow := True;
        for i := 1 to length(newstr) do
         if (ord(newstr[i]) in AlphaNum_Codes) then
           Allow := False;
        if Allow then
        begin
          Self.Text := newstr;
          SetModified(True);
        end;
      end;
    etNumeric:
      begin
        if IsType(newstr) = atNumeric then
        begin
          self.Text := newstr;
          SetModified(True);
        end;
      end;
    etFloat,etMoney:
      begin
        if IsType(newstr) in [atFloat,atNumeric] then
        begin
          if not ((FPrecision = 0) and (Pos(DecimalSeparator,StrPas(Content)) > 0)) then
          begin
            self.Text := newstr;
            Floatvalue := Floatvalue;
            SetModified(True);
          end;
        end;
      end;
    etString,etPassWord:self.Text := NewStr;
    etLowerCase:self.Text := AnsiLowerCase(NewStr);
    etUpperCase:self.Text := AnsiUpperCase(NewStr);
    etMixedCase:self.Text := ShiftCase(NewStr);
    end;

    if (FEditType = etMoney) and (Length(self.Text) > 3) then
      SelectAll
    else
    begin
      SelStart := newss;
      SelLength := newsl;
    end;

   if FEditType in [etString,etPassWord,etLowerCase,etUpperCase,etMixedCase] then
      SetModified(true);
  end;

  UpdateLookup;
end;

procedure TAdvEdit.WMPaint(var Msg:TWMPaint);
begin
  inherited;
  PaintEdit;
  if Border3D then
    DrawBorder;
end;

procedure TAdvEdit.PaintEdit;
var
  DC: HDC;
  Oldpen: HPen;
  Loc: TRect;
  Canvas: TCanvas;
begin
  if FFlat then
  begin
    DC := GetDC(Handle);

    if FFocusBorder then
      DrawControlBorder(DC)
    else
    begin
      OldPen := SelectObject(dc,CreatePen( PS_SOLID,1,ColorToRGB(FFlatLineColor)));
      SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));

      if FSoftBorder then
      begin
        MovetoEx(DC,Loc.Left - 2 + IndentL,Height - 1,nil);
        LineTo(DC,Width -  1 ,Height - 1);
        LineTo(DC,Width - 1 ,Loc.Top - 4);
        LineTo(DC,Loc.Left - 2 + IndentL,Loc.Top - 4);
        LineTo(DC,Loc.Left - 2 + IndentL,Height - 1);
      end
      else
      begin
        MovetoEx(DC,Loc.Left - 2 + IndentL,Height - 1,nil);
        LineTo(DC,Width - IndentR ,Height - 1);
      end;

      DeleteObject(SelectObject(DC,OldPen));
    end;

    ReleaseDC(Handle,DC);
  end;

  if (FCaretPos.x <> -1) and (FCaretPos.y <> -1) then
  begin
    DC := GetDC(Handle);
    Rectangle(dc,FCaretPos.x,FCaretPos.y,FCaretPos.x+1,FCaretPos.y-Font.Height);
    ReleaseDC(Handle,DC);
  end;

  if (Text = '') and (GetFocus <> Handle) and (FEmptyText <> '') then
  begin
    DC := GetDC(Handle);
    Canvas := TCanvas.Create;
    Canvas.Handle := DC;
    Canvas.Font.Color := clGray;
    SetBkMode(Canvas.Handle,windows.TRANSPARENT);
    Canvas.TextOut(2,2,FEmptyText);
    Canvas.Free;
    ReleaseDC(Handle,DC);
  end;

  if (GetFocus <> Handle) and (ErrorMarkerLen > 0) then
  begin
    DC := GetDC(Handle);
    Canvas := TCanvas.Create;
    Canvas.Handle := DC;
    DrawErrorLines(Canvas,ErrorMarkerPos,ErrorMarkerLen);
    Canvas.Free;
    ReleaseDC(Handle,DC);
  end;

end;

procedure TAdvEdit.DrawErrorLines(Canvas: TCanvas; ErrPos,ErrLen: Integer);
var
  pt1: TPoint;
  pt2: TPoint;
  l: Integer;
  o: Integer;
  ep: Integer;
  Rect: TRect;
  h: Integer;
begin
  Rect := GetClientRect;
  if ErrPos >= Length(Text) then
  begin
    ep := Length(Text);
    l := SendMessage(Handle,EM_POSFROMCHAR,ep,0);
    pt1 := Point(LoWord(l),HiWord(l));
    pt1.X := pt1.X + 4;
  end
  else
  begin
    l := SendMessage(Handle,EM_POSFROMCHAR,ErrPos,0);
    pt1 := Point(LoWord(l),HiWord(l));
  end;

  if ErrPos + ErrLen >= Length(Text) then
  begin
    ep := Length(Text) - 1;
    l := SendMessage(Handle,EM_POSFROMCHAR,ep ,0);
    pt2 := Point(LoWord(l),HiWord(l));
    pt2.X := pt2.X + 4;
    pt2.Y := pt1.Y;
  end
  else
  begin
    l := SendMessage(Handle,EM_POSFROMCHAR,ErrPos + ErrLen - 1 ,0);
    pt2 := Point(LoWord(l),HiWord(l));
  end;

  Canvas.Pen.Color := clRed;
  Canvas.Pen.Width := 2;

  Canvas.Font.Assign(Font);
  h := Canvas.TextHeight('gh') - 1;

  l := pt1.X;
  o := 3;

  Canvas.MoveTo(Rect.Left + l,Rect.Top + pt1.Y + h +  o);

  while l <= pt2.X do
  begin
    if o = 3 then o := 0 else o := 3;
    Canvas.LineTo(Rect.Left + l + 3,pt2.Y + h + o);
    Inc(l,3);
  end;

  if o = 3 then o := 0 else o := 3;
  Canvas.LineTo(Rect.Left + l + 3,Rect.Top + pt2.Y + h + o);
end;


procedure TAdvEdit.WMEraseBkGnd(var Message: TWMEraseBkGnd);
var
  DC: HDC;
  i: Integer;
  p: TPoint;
begin
  if FTransparent then
  begin
    if Assigned(Parent) then
    begin
      DC := Message.DC;
      i := SaveDC(DC);
      p := ClientOrigin;
      Windows.ScreenToClient(Parent.Handle, p);
      p.x := -p.x;
      p.y := -p.y;
      MoveWindowOrg(DC, p.x, p.y);
      SendMessage(Parent.Handle, WM_ERASEBKGND, DC, 0);
      TWinCtrl(Parent).PaintControls(DC, nil);
      RestoreDC(DC, i);
    end;
  end
  else
    inherited;
end;

procedure TAdvEdit.WMMouseMove(var Msg: TWMMouse);
{$IFDEF DELPHI3_LVL}
var
  m:pchar;
  s:string;
  dwEffects: Integer;
  isCopy: Boolean;
  hres:HResult;
{$ENDIF}

begin
  inherited;
  {$IFDEF DELPHI3_LVL}
  if (SelLength>0) and (fButtonDown) and (fOleDropSource) then
  begin
    GetMem(m,SelLength+1);
    GetSelTextBuf(m,SelLength+1);
    s:=StrPas(m);
    FreeMem(m);

    FIsDragSource:=true;
    hres:=StartTextDoDragDrop(s,'',DROPEFFECT_COPY or DROPEFFECT_MOVE,dwEffects);
    FIsDragSource:=false;

    isCopy:=(getkeystate(vk_control) and $8000=$8000);

    if not isCopy and (hres=DRAGDROP_S_DROP) then
    begin
      {cut the text here}
      ClearSelection;
      EraseCaret;
      Invalidate;
    end;

    FButtonDown := False;
  end;
 {$ENDIF} 
end;

procedure TAdvEdit.WMLButtonDown(var Msg:TWMMouse);
var
  uchar: Integer;
begin
  {$IFDEF DELPHI3_LVL}
  {click outside selection}
  uchar := CharFromPos(point(msg.xpos,msg.ypos));

  if FIsUrl and (self.Handle = GetFocus) and FShowURL then
    ShellExecute(0,'open',pchar(self.Text),nil,nil,SW_NORMAL);

  if (SelLength <= 0) or (uchar < SelStart) or (uChar > SelStart + SelLength) or
     (GetFocus <> self.Handle) then
    inherited
  else
    if (uChar >= SelStart) and (uChar <= SelStart + SelLength) and (SelLength > 0) then
      FButtonDown := True;

  {$ELSE}
  inherited;
  {$ENDIF}
end;

procedure TAdvEdit.WMLButtonUp(var Msg: TWMMouse);
var
 uchar: Integer;

begin
 if fButtonDown then
  begin
   uchar:=CharFromPos(point(msg.xpos,msg.ypos));
   SelStart:=uChar;
   SelLength:=0;
  end;

 fButtonDown:=false;

 inherited;
 if (fPrefix<>'') then
  begin
   if (SelStart<Length(fPrefix)) then
    begin
     SelStart:=Length(fPrefix);
     SelLength:=Length(self.Text);
    end;
  end;
 if (fSuffix<>'') then
  begin
   if (SelStart>Length(self.text)) then
    begin
     SelStart:=Length(self.Text);
     SelLength:=0;
    end;
   if (SelStart+SelLength>Length(self.text)) then
    begin
     SelLength:=Length(self.Text)-SelStart;
    end;
  end;
end;

procedure TAdvEdit.SetPrefix(const Value: string);
var
 s:string;
begin
  s:=self.Text;
  fPrefix := Value;
  inherited Text:=s;
  //changed for v1.8
  Text:=s;
end;

procedure TAdvEdit.SetSuffix(const Value: string);
var
 s:string;
begin
  s:=self.text;
  fSuffix := Value;
  inherited Text:=s;
  //changed for v1.8
  Text:=s;
end;

function TAdvEdit.DecimalPos: Integer;
var
 i: Integer;
begin
 i:=Pos(decimalseparator,self.text);
 if (i=0) then Result := Length(fprefix)+Length(self.text)+Length(fSuffix)+1
 else Result := Length(fPrefix)+i;
end;

function TAdvEdit.FixedLength(s:string): Integer;
var
  i: Integer;
begin
  s:=StripThousandSep(s);
  i:=Pos(decimalseparator,s);
  if (i>0) then Result := i else Result := Length(s)+1;
end;

function TAdvEdit.GetText: string;
var
  s:string;
begin
  s:=inherited Text;
  if (fPrefix<>'') and (Pos(fPrefix,s)=1) then delete(s,1,Length(fPrefix));
  if (fSuffix<>'') then delete(s,Length(s)-Length(fSuffix)+1,Length(fSuffix));
  Result := s;
end;

procedure TAdvEdit.SetText(value: string);
var
  fmt,neg:string;
begin
  if (value <> '') then
  begin
    case FEditType of
    etFloat:if not (IsType(value) in [atFloat,atNumeric]) then value:='0';
    etMoney:if not (IsType(value) in [atFloat,atNumeric]) then value:='0';
    etHex:if not (IsType(value) in [atHex,  atNumeric]) then  value:='0';
    etNumeric:if  not (IsType(value) in [atNumeric]) then value:='0';
    end;
  end;

  if (FPrecision > 0) and (value <> '') then
  begin
    if (FEditType in [etMoney]) then
    begin
      if (Pos('-',value)>0) then neg := '-' else neg := '';
      fmt  :='%.'+IntToStr(FPrecision)+'n';
      Value := Format(fmt,[EStrToFloat(Value)]);
    end;

    if (FEditType in [etFloat]) then
    begin
      fmt  :='%.'+inttostr(FPrecision)+'f';
      Value := Format(fmt,[EStrToFloat(value)]);
    end;
  end;

  if (FEditType in [etHex]) then
    Value := UpperCase(value);

  inherited Text := FPrefix + Value + FSuffix;

  SetModified(False);

  if FShowURL then ApplyURL(TestURL);
end;

function TAdvEdit.GetVisible: boolean;
begin
  Result := inherited Visible;
end;

procedure TAdvEdit.SetVisible(const Value: boolean);
begin
  inherited Visible := Value;
  if (FLabel<>nil) then FLabel.Visible := Value;
end;


function TAdvEdit.CreateLabel: TLabel;
begin
  Result := Tlabel.Create(self);
  Result.Parent:=self.parent;
  Result.FocusControl:=self;
  Result.Font.Assign(LabelFont);
end;

function TAdvEdit.GetLabelCaption: string;
begin
  if FLabel <> nil then
    Result := FLabel.Caption
  else
    Result := '';
end;

{$IFNDEF DELPHI3_LVL}
function TAdvEdit.GetSelText:string;
var
 buf:array[0..255] of char;
begin
 self.GetSelTextBuf(buf,sizeof(buf));
 Result := strpas(buf);
end;
{$ENDIF}

procedure TAdvEdit.AutoSeparators;
var
  s,si,neg: string;
  d: Double;
  Diffl,OldSelStart,OldPrec: Integer;

begin
  s := self.Text;
  Diffl := Length(s);
  OldSelStart := SelStart;

  if (s = '') then
    Exit;

  if (Pos('-',s)=1) then
  begin
    Delete(s,1,1);
    neg := '-';
  end
  else
    neg := '';

  if (Pos(DecimalSeparator,s)>0) then
    s := Copy(s,Pos(DecimalSeparator,s),255)
  else
    s := '';

  d := Trunc(Abs(self.FloatValue));

  if FAutoThousandSeparator then
    si:=format('%n',[d])
  else
    si:=Format('%f',[d]);

  si:=copy(si,1,Pos(decimalseparator,si)-1);

  OldPrec := FPrecision;
  FPrecision := 0;
  //changed 1.8
  inherited Text := FPrefix + neg + si + s + fSuffix;

  FPrecision := OldPrec;

  Diffl := Length(self.Text) - Diffl;

  SelStart := OldSelStart + Diffl;
  SelLength := 0;
end;

procedure TAdvEdit.UpdateLabel;
begin
  FLabel.Transparent:=FLabeltransparent;
  case FLabelPosition of
  lpLeftTop:
    begin
      FLabel.top := self.top;
      FLabel.left := self.left-FLabel.canvas.textwidth(FLabel.caption)-FLabelMargin;
    end;
  lpLeftCenter:
    begin
      FLabel.top := self.top+((self.height-FLabel.height) shr 1);
      FLabel.left := self.left-FLabel.canvas.textwidth(FLabel.caption)-FLabelMargin;
    end;
  lpLeftBottom:
    begin
      FLabel.top := self.top+self.height-FLabel.height;
      FLabel.left := self.left-FLabel.canvas.textwidth(FLabel.caption)-FLabelMargin;
    end;
  lpTopLeft:
    begin
      FLabel.top := self.top-FLabel.height-FLabelMargin;
      FLabel.left := self.left;
    end;
  lpTopCenter:
    begin
      FLabel.Top := self.top-FLabel.height-FLabelMargin;
      FLabeL.Left := self.Left + ((self.Width-FLabel.width) shr 1);
    end;
  lpBottomLeft:
    begin
      FLabel.top := self.top+self.height+FLabelMargin;
      FLabel.left := self.left;
    end;
  lpBottomCenter:
    begin
      FLabel.top := self.top+self.height+FLabelMargin;
      FLabeL.Left := self.Left + ((self.Width-FLabel.width) shr 1);
    end;
  lpLeftTopLeft:
    begin
      FLabel.top := self.top;
      FLabel.left := self.left-FLabelMargin;
    end;
  lpLeftCenterLeft:
    begin
      FLabel.top := self.top+((self.height-FLabel.height) shr 1);
      FLabel.left := self.left-FLabelMargin;
    end;
  lpLeftBottomLeft:
    begin
      FLabel.top:=self.top+self.height-FLabel.height;
      FLabel.left:=self.left-FLabelMargin;
    end;
  end;
  FLabel.Font.Assign(FLabelFont);
  FLabel.Visible := Visible;
end;

procedure TAdvEdit.SetLabelPosition(const value : TLabelPosition);
begin
  FLabelPosition := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvEdit.SetLabelMargin(const value : integer);
begin
  FLabelMargin := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvEdit.SetLabelFont(const Value: TFont);
begin
  FLabelFont.Assign(Value);
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvEdit.LabelFontChange(Sender: TObject);
begin
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft,ATop,AWidth,AHeight);
  if FLabel <> nil then
    UpdateLabel;

  if FFlat then
    Flat := FFlat;
end;

procedure TAdvEdit.SetLabelCaption(const value: string);
begin
  if FLabel = nil then
     FLabel := CreateLabel;
  FLabel.Caption := Value;
  UpdateLabel;
end;

procedure TAdvEdit.SetLabelTransparent(const value : boolean);
begin
  FLabelTransparent := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvEdit.CMMouseEnter(var Msg: TMessage);
begin
  inherited;
  if FAutoFocus then self.SetFocus;
  if not FMouseInControl and Enabled then
  begin
    FMouseInControl := True;
    if FFocusBorder then DrawBorder;
  end;
end;

procedure TAdvEdit.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled then
    begin
     FMouseInControl := False;
     if FFocusBorder then Invalidate;
    end;
end;

function TAdvEdit.GetFloat: double;
var
  s:string;
begin
  Result := 0;
  case FEditType of
  etHex: if self.Text <> '' then Result := HexToInt(self.Text);
  etNumeric,etFloat:if (self.Text<>'') then Result := EStrToFloat(self.Text);
  etMoney:
    if self.Text <> '' then
    begin
      s := StripThousandSep(self.Text);
      if (Pos(Decimalseparator,s) = Length(s)) then Delete(s,Pos(decimalseparator,s),1);
      if (s='') or (s='-') then Result := 0 else
        Result := EStrToFloat(s);
    end;
  end;
end;

function ValStr(s:string): Integer;
var
  err: Integer;
begin
  val(s,result,err);
end;

function TAdvEdit.GetInt: integer;
begin
  Result := 0;
  case FEditType of
  etHex:if (self.Text<>'') then Result := HexToInt(self.Text);
  etNumeric,etFloat:Result := ValStr(self.Text);
  etMoney:Result := ValStr(StripThousandSep(self.Text));
  end;
end;

procedure TAdvEdit.SetFloat(const Value: double);
begin
  case FEditType of
  etHex:self.Text:=IntToHex(trunc(value),0);
  etNumeric:if (FPrecision>=0) then self.Text:=Format('%.'+inttostr(FPrecision)+'n',[value]) else self.Text:=Format('%g',[Value]);
  etFloat:if (FPrecision>=0) then self.Text:=Format('%.'+inttostr(FPrecision)+'f',[value]) else self.Text:=Format('%g',[Value]);
  etMoney:begin
           if (FPrecision>0) then self.Text:=Format('%.'+inttostr(FPrecision)+'f',[value]) else self.Text:=Format('%g',[Value]);
           AutoSeparators;
         end;
  end;
  SetModified(True);
end;

procedure TAdvEdit.SetInt(const Value: integer);
begin
  case FEditType of
  etHex:self.text:=IntToHex(value,0);
  etNumeric:self.Text:=inttostr(value);
  etFloat:self.Text:=inttostr(value);
  etMoney:begin
          self.Text:=inttostr(value);
          AutoSeparators;
         end;
  end;
  SetModified(True);
end;

procedure TAdvEdit.SetPrecision(const Value: smallint);
var
  at:TAutoType;
begin
  if (FPrecision<>value) and (editType in [etFloat,etMoney]) then
  begin
    FPrecision := Value;
    at := IsType(self.text);
    if (at in [atFloat,atNumeric]) then
      FloatValue:=FloatValue
    else
      FloatValue:=0.0;
  end;
end;

function TAdvEdit.GetModified: boolean;
begin
 Result := fIsModified;
end;

procedure TAdvEdit.SetModified(const Value: boolean);
begin
  if csLoading in ComponentState then
    Exit;

  if ReadOnly then
    Exit;
      
  if FShowModified then
  begin
    if (value=false) then
      self.Font.Color := FFontColor
    else
      self.Font.Color := FModifiedColor;
  end;
  
  inherited Modified := value;
  FIsModified := value;
end;


procedure TAdvEdit.ListToRangeStr(rangelist:TRangeList);
var
 c: Integer;
 fstart,fcurr: Integer;
 s:string;
begin
 RangeList.sort(RangeListCompare);

 c:=1;
 fstart:=RangeList.Items[0];
 fcurr:=fstart;
 s:='';
 while (c<RangeList.Count) do
  begin
   if RangeList.Items[c]<>fCurr+1 then
    begin
     if (fStart=-2) then {new possible start?}
      begin
       fStart:=Rangelist.Items[c];
      end
     else
      begin
       if Length(s)>0 then s:=s+',';
       if (fStart<>fCurr) then s:=s+inttostr(fStart)+'-'+inttostr(fCurr) else s:=s+inttostr(fCurr);
       fStart:=Rangelist.Items[c];
      end;
    end;
    fCurr:=RangeList.Items[c];
    inc(c);
  end;

 if Length(s)>0 then s:=s+',';
 if (fStart<>fCurr) then s:=s+inttostr(fStart)+'-'+inttostr(fCurr) else s:=s+inttostr(fCurr);
 inherited Text:=s;
end;

function TAdvEdit.RangeStrToList(rangelist:TRangeList): Boolean;
begin
 Result := RangeList.StrToList(self.Text);
end;

procedure TAdvEdit.LoadPersist;
var
 Inifile:TInifile;
 {$IFDEF DELPHI3_LVL}
 RegInifile:TRegInifile;
 {$ENDIF}
 s:string;
begin
  if fPersistence.Enable then
  begin
    if {$IFDEF DELPHI3_LVL} fPersistence.Location=plInifile {$ELSE} 1>0 {$ENDIF} then
    begin
      if fPersistence.Key = '' then
        fPersistence.Key := ChangeFileExt(ParamStr(0),'.INI');
      Inifile := TInifile.Create(fPersistence.Key);
      s := Inifile.ReadString(fPersistence.Section,self.Name,'@');
      Inifile.Free;
    end
    else
    begin
      {$IFDEF DELPHI3_LVL}
      RegInifile := TRegInifile.Create(fPersistence.Key);
      s := RegInifile.ReadString(fPersistence.Section,self.Name,'@');
      RegInifile.Free;
      {$ENDIF}
    end;
    if (s<>'@') then inherited Text:=s;
  end;
end;

procedure TAdvEdit.SavePersist;
var
  Inifile: TInifile;
  {$IFDEF DELPHI3_LVL}
  RegInifile: TRegInifile;
  {$ENDIF}
begin
  if not Assigned(FPersistence) then Exit;

  if FPersistence.Enable then
  begin
    if {$IFDEF DELPHI3_LVL} fPersistence.Location=plInifile {$ELSE} 1>0 {$ENDIF} then
    begin
      if fPersistence.Key = '' then
        fPersistence.Key := ChangeFileExt(ParamStr(0),'.INI');
      Inifile:=TInifile.Create(fPersistence.Key);
      Inifile.WriteString(fPersistence.Section,self.Name,fPrefix+self.Text+fSuffix);
      Inifile.Free;
    end
    else
    begin
      {$IFDEF DELPHI3_LVL}
      RegInifile:=TRegInifile.Create(fPersistence.Key);
      RegInifile.WriteString(fPersistence.Section,self.Name,fPrefix+self.Text+fSuffix);
      RegInifile.Free;
      {$ENDIF}
    end;
  end;
end;

procedure TAdvEdit.WMDestroy(var Msg: TMessage);
begin
  if not (csDesigning in ComponentState) then
    SavePersist;
  DefaultHandler(msg);
end;

function TAdvEdit.TestURL: Boolean;
begin
  Result := (Pos('://',self.text)>0) or (Pos('@',self.text)>1);
end;

function TAdvEdit.GetError: Boolean;
begin
  Result := FError;
end;

procedure TAdvEdit.SetError(const Value: Boolean);
begin
  if (csDesigning in ComponentState) or
    (csLoading in ComponentState) then
    Exit;

  if (Value <> FError) then
  begin
    FError := Value;

    if not ShowError then
      Exit;

    if FError then
    begin
      inherited Color := FErrorColor;
      Font.Color := FErrorFontColor;
    end
    else
    begin
      if GetFocus = Handle then
      begin
        Color := FFocusColor;
        Font.Color := FFocusFontColor;
      end
      else
      begin
        Color := FNormalColor;
        Font.Color := FFontColor;
      end;
    end;
  end;
end;

procedure TAdvEdit.Change;
var
  IsValid: Boolean;
begin
  inherited Change;

  if not (csLoading in ComponentState) then
  begin
    IsValid := DoValidate(Self.Text);
    if FShowError then
        IsError := not IsValid;
  end;
end;


procedure TAdvEdit.Init;
var
  OldColor: TColor;
begin
  FNormalColor := Color;
  FFontColor := Font.Color;
  FOldBorder := BorderStyle;
  FFlat := not FFlat;
  SetFlat(not FFlat);
  if FLabel <> nil then UpdateLabel;

  if not Enabled then
  begin
    OldColor := Color;
    Color := FDisabledColor;
    FNormalColor := OldColor;
  end;
end;

procedure TAdvEdit.Loaded;
begin
  inherited Loaded;
  Init;
  Height := FLoadedHeight;
  SetBounds(Left,Top,Width,Height);
  if not (csDesigning in ComponentState) then LoadPersist;
end;

procedure TAdvEdit.DrawBorder;
var
  DC: HDC;
begin
  if not (FFlat or (FFocusBorder and FMouseInControl) or Border3D) then
    Exit;

  DC := GetWindowDC(Handle);
  try
    DrawControlBorder(DC);
  finally
    ReleaseDC(Handle,DC);
  end;
end;

procedure TAdvEdit.DrawControlBorder(DC: HDC);
var
  ARect: TRect;
  BtnFaceBrush, WindowBrush: HBRUSH;
begin
  if Is3DBorderButton then
    BtnFaceBrush := CreateSolidBrush(GetSysColor(COLOR_BTNFACE))
  else
    BtnFaceBrush := CreateSolidBrush(ColorToRGB((parent as TWinControl).Brush.color));

  WindowBrush := CreateSolidBrush(GetSysColor(COLOR_WINDOW));

  try
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);
    if Is3DBorderButton then
    begin
      DrawEdge(DC, ARect, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
      FrameRect(DC, ARect, BtnFaceBrush);
    end
    else
    begin
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, BtnFaceBrush);
    end;
  finally
    DeleteObject(WindowBrush);
    DeleteObject(BtnFaceBrush);
  end;
end;

function TAdvEdit.Is3DBorderButton: Boolean;
begin
  if csDesigning in ComponentState then
    Result := Enabled
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);

  Result := (Result and FFocusBorder) or (Border3D);
end;

{$IFDEF DELPHI3_LVL}
procedure TAdvEdit.SetOleDropSource(const Value: boolean);
begin
  FOleDropSource := Value;
end;

procedure TAdvEdit.SetOleDropTarget(const Value: boolean);
begin
  FOleDropTarget := Value;
  if not (csDesigning in ComponentState) then
  begin
    if FOleDropTarget then
    begin
      FOleDropTargetAssigned := RegisterDragDrop(self.Handle, TEditDropTarget.Create(self))=s_OK;
    end
    else
      if FOleDropTargetAssigned then RevokeDragDrop(self.Handle);
  end;
end;
{$ENDIF}

procedure TAdvEdit.WMNCPaint(var Message: TMessage);
begin
  inherited;
end;

function TAdvEdit.GetEnabledEx: boolean;
begin
  Result := inherited Enabled;
end;

procedure TAdvEdit.SetEnabledEx(const Value: boolean);
var
  OldValue: Boolean;
  OldColor: TColor;
begin
  OldValue := inherited Enabled;

  inherited Enabled := Value;

  if (csLoading in ComponentState) or
     (csDesigning in ComponentState) then
    Exit;

  if OldValue <> Value then
  begin
    if Value then
    begin
      Color := FNormalColor;
    end
    else
    begin
      OldColor := Color;
      Color := FDisabledColor;
      FNormalColor := OldColor;
    end;

    if Assigned(FLabel) then
      if not FLabelAlwaysEnabled then
        FLabel.Enabled := Value;
  end;
end;

procedure TAdvEdit.SetDisabledColor(const Value: TColor);
begin
  FDisabledColor := Value;
  Invalidate;
end;

function TAdvEdit.GetColorEx: TColor;
begin
  Result := inherited Color;
end;

procedure TAdvEdit.SetColorEx(const Value: TColor);
begin
  inherited Color := Value;
  FNormalColor := Value;
end;

procedure TAdvEdit.CMHintShow(var Msg: TMessage);
{$IFNDEF DELPHI3_LVL}
type
  PHintInfo = ^THintInfo;
{$ENDIF}
var
  hi: PHintInfo;

Begin
  if (GetTextSize>Width) and (FHintShowLargeText) then
  begin
    hi := PHintInfo(Msg.LParam);
    {$IFNDEF DELPHI3_LVL}
    Hint := Text;
    {$ELSE}
    hi.HintStr := Text;
    {$ENDIF}
    hi.HintPos := ClientToScreen(Point(0,0));
  end;
  inherited;
end;

procedure TAdvEdit.SetAutoThousandSeparator(const Value: Boolean);
begin
  FAutoThousandSeparator := Value;
  if FEditType in [etMoney,etFloat] then AutoSeparators;
end;

procedure TAdvEdit.SetEmptyText(const Value: string);
begin
  FEmptyText := Value;
  Invalidate;
end;

procedure TAdvEdit.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
var
  IsPrev: Boolean;
begin
  if (Msg.CharCode = VK_ESCAPE) and FCanUndo then
  begin
    Text := FOldString;
    Font.Color := FFocusFontColor;
    SelectAll;
    SetModified(False);
    Msg.CharCode := 0;
    Msg.Result := 0;
    // Take care of default key handling
    if (Parent is TWinControl) and FDefaultHandling then
    begin
      PostMessage((Parent as TWinControl).Handle,WM_KEYDOWN,VK_ESCAPE,0);
      PostMessage((Parent as TWinControl).Handle,WM_KEYUP,VK_ESCAPE,0);
    end;
  end;

  IsPrev := False;
  if (Parent is TForm) then
  begin
    IsPrev := (Parent as TForm).KeyPreview;
  end;

  if (Msg.CharCode = VK_RETURN) and FDefaultHandling and not IsPrev then
  begin
    // Take care of default key handling
    if (Parent is TWinControl) then
    begin
      PostMessage((Parent as TWinControl).Handle,WM_KEYDOWN,VK_RETURN,0);
      PostMessage((Parent as TWinControl).Handle,WM_KEYUP,VK_RETURN,0);
    end;
  end;

  inherited;
end;

procedure TAdvEdit.SetSoftBorder(const Value: Boolean);
begin
  if FSoftBorder <> Value then
  begin
    FSoftBorder := Value;
    Invalidate;
  end;
end;

procedure TAdvEdit.SetLabelAlwaysEnabled(const Value: Boolean);
begin
  FLabelAlwaysEnabled := Value;
  if FLabel <> nil then
    if Value then
      FLabel.Enabled := True;
  Invalidate;
end;


procedure TAdvEdit.SetBorder3D(const Value: Boolean);
begin
  FBorder3D := Value;
  Invalidate;
end;

procedure TAdvEdit.CreateWnd;
begin
  inherited;
  SetFlatRect(FFlat);
end;


procedure TAdvEdit.SetErrorMarkerLen(const Value: Integer);
begin
  FErrorMarkerLen := Value;
  Invalidate;
end;

procedure TAdvEdit.SetErrorMarkerPos(const Value: Integer);
begin
  FErrorMarkerPos := Value;
  Invalidate;
end;

procedure TAdvEdit.SetFocusBorder(const Value: Boolean);
begin
  FFocusBorder := Value;
  Invalidate;
end;

function TAdvEdit.GetHeightEx: Integer;
begin
  Result := inherited Height;
end;

procedure TAdvEdit.SetHeightEx(const Value: Integer);
begin
  if (csLoading in ComponentState) then
    FLoadedHeight := Value;
  inherited Height := Value;
end;


procedure TAdvEdit.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DoneLookup;
end;

procedure TAdvEdit.DoneLookup;
var
  idx: Integer;
  NewValue: string;
begin
  SetForegroundWindow(Handle);
  SetActiveWindow(Handle);
  Self.SetFocus;
  FLookupList.Hide;

  idx := Integer(FLookupListBox.Items.Objects[FlookupListBox.ItemIndex]);

  if (idx >= 0) and (idx < FLookup.ValueList.Count) then
    NewValue := FLookup.ValueList.Strings[idx]
  else
    NewValue := FLookupListbox.Items[FLookupListBox.ItemIndex];

  if Assigned(FOnLookupSelect) then
    FOnLookupSelect(Self,NewValue);
  Text := NewValue;  

  SelectAll;
end;

procedure TAdvEdit.ListKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    DoneLookup;
end;

procedure TAdvEdit.UpdateLookup;
var
  pt: TPoint;
  i,cnt: Integer;
  mw,tw: Integer;

begin
  if not FLookup.Enabled then
    Exit;

  if Length(Text) >= FLookup.NumChars then
  begin
    pt := ClientToScreen(Point(0,0));
    FLookupList.Text := '  ';
    FLookupList.Color := FLookup.Color;
    FLookupListbox.Color := FLookup.Color;
    FLookupListbox.Font.Name := 'Arial';
    FlookupListbox.Font.Size := 8;
    FLookupListbox.Ctl3D := False;
    FLookupList.Width := 200;
    FLookupList.Height := (12 * FLookup.DisplayCount) + 4;
    FLookupList.Top := pt.Y + Height - 6;
    FLookupList.Left := pt.X + 16;
    FLookupList.Color := clWindow;

    cnt := 0;
    FLookupListBox.Items.Clear;

    for i := 1 to FLookup.DisplayList.Count do
    begin
      if FLookup.CaseSensitive then
      begin
        if Pos(Text,FLookup.FDisplayList.Strings[i - 1]) = 1 then
        begin
          FLookupListbox.Items.AddObject(FLookup.FDisplayList.Strings[i - 1],TObject(i - 1));
          inc(cnt);
        end;
      end
      else
      begin
        if Pos(Uppercase(Text),Uppercase(FLookup.FDisplayList.Strings[i - 1])) = 1 then
        begin
          FLookupListbox.Items.AddObject(FLookup.FDisplayList.Strings[i - 1],TObject(i - 1));
          inc(cnt);
        end;
      end;
    end;

    if FLookup.FDisplayList.Count > 0 then
      FLookupListBox.ItemIndex := 0;

    if cnt < FLookup.DisplayCount then
      FLookupList.Height := (cnt * 12) + 4;

    FLookupListBox.Sorted := True;

    mw := 50;
    if cnt > 0 then
    begin
      for i := 1 to cnt do
      begin
        tw := FLookupList.Canvas.TextWidth(FLookup.FDisplayList.Strings[i - 1]);
        if tw > mw then
          mw := tw;
      end;
      FLookupList.Width := mw + 10;
    end;


    FLookupList.Visible := cnt > 0;
  end
  else
  begin
    FLookupList.Visible := False;
  end;
end;

function TAdvEdit.DoValidate(value: string): Boolean;
var
  IsValid: Boolean;
begin
  IsValid := True;

  Result := IsValid;

  if FIsValidating then
    Exit;

  FIsValidating := True;

  if Assigned(FOnValueValidate) then
    FOnValueValidate(Self,value,IsValid);

  FIsValidating := False;

  Result := IsValid;
end;


{TAdvMaskEdit}

constructor TAdvMaskEdit.Create(AOwner: TComponent);
begin
  inherited Create(aOwner);
  FAutoTab := True;
  FLabelMargin := 4;
  FReturnIsTab := True;
  FFocusColor := clWindow;
  FModifiedColor := clRed;
  FDisabledColor := clSilver;
  FLabelFont := TFont.Create;
  FLabelFont.OnChange := LabelFontChanged;
  FFlatParentColor := True;
end;

procedure TAdvMaskEdit.SetAlignment(value:tAlignment);
begin
 if FAlignment <> Value then
  begin
   FAlignment := Value;
   RecreateWnd;
  end;
end;

procedure TAdvMaskEdit.CreateParams(var Params:TCreateParams);
begin
  inherited CreateParams(params);

  if (PasswordChar = #0) then
  begin
    Params.Style := Params.Style or ES_MULTILINE;
  end;

  if (FAlignment = taRightJustify) then
  begin
    params.style := params.style AND NOT (ES_LEFT) AND NOT (ES_CENTER);
    params.style := params.style or (ES_RIGHT);
    params.style := params.style or (ES_MULTILINE);
  end;

  if (FAlignment = taCenter) then
  begin
    params.style := params.style AND NOT (ES_LEFT) AND NOT (ES_RIGHT);
    params.style := params.style or (ES_CENTER);
    params.style := params.style or (ES_MULTILINE);
  end;

end;

procedure TAdvMaskEdit.KeyUp(var Key: Word; Shift: TShiftState);
var
 accept: Boolean;

begin
 inherited keyUp(key,shift);
 if (Pos(' ',self.text)=0) and (self.SelStart=Length(self.text)) and (self.editmask<>'') then
  begin
   accept:=true;
   if assigned(fOnMaskComplete) then fOnMaskComplete(self,self.Text,accept);
   if fAutoTab and accept then postmessage(self.handle,wm_keydown,VK_TAB,0);
  end;
end;

procedure TAdvMaskEdit.DoEnter;
begin
  if (self.EditMask<>'') and fSelectFirstChar then
  begin
    self.SelStart:=0;
    self.SelLength:=1;
  end;
  inherited DoEnter;
end;

procedure TAdvMaskEdit.CMMouseEnter(var Msg: TMessage);
begin
  if FAutoFocus then self.SetFocus;
  if not FMouseInControl and Enabled then
  begin
    FMouseInControl := True;
    if FFocusBorder then DrawBorder;
  end;
end;

procedure TAdvMaskEdit.CMMouseLeave(var Msg: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled then
    begin
     FMouseInControl := False;
     if FFocusBorder then Invalidate;
    end;
end;


procedure TAdvMaskEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  inherited Color := FNormalColor;
  Font.Color := FFontColor;
end;

procedure TAdvMaskEdit.WMSetFocus(var Msg: TWMSetFocus);
begin

  inherited;

  if csLoading in ComponentState then
    Exit;

  inherited Color := FFocusColor;
  FOriginalValue := self.Text;
  Font.Color := FocusFontColor;
  if AutoSelect then
    SelectAll;
end;

procedure TAdvMaskEdit.WMChar(var Msg: TWMKey);
begin
  if (msg.charcode=vk_return) and (FReturnIsTab) then
    Exit;
  inherited;
  if FShowModified then
    self.Font.Color := FModifiedColor;
end;

function TAdvMaskEdit.GetLabelCaption: string;
begin
  if FLabel<>nil then Result := FLabel.caption else Result := '';
end;

procedure TAdvMaskEdit.SetLabelCaption(const value: string);
begin
  if FLabel=nil then FLabel:=CreateLabel;
  FLabel.caption:=value;
  UpdateLabel;
end;



function TAdvMaskEdit.CreateLabel: TLabel;
begin
  Result := TLabel.Create(Self);
  Result.Parent := Self.Parent;
  Result.FocusControl := Self;
  Result.Font.assign(Self.Font);
end;


procedure TAdvMaskEdit.SetLabelMargin(const Value: integer);
begin
  FLabelMargin := Value;
  if FLabel<>nil then UpdateLabel;
end;

procedure TAdvMaskEdit.SetLabelTransparent(const Value: boolean);
begin
  FLabelTransparent := Value;
  if FLabel<>nil then UpdateLabel;
end;


procedure TAdvMaskEdit.SetLabelPosition(const Value: TLabelPosition);
begin
  FLabelPosition := Value;
  if FLabel<>nil then UpdateLabel;
end;

procedure TAdvMaskEdit.UpdateLabel;
begin
 FLabel.Transparent := FLabeltransparent;
 case FLabelPosition of
 lpLeftTop:begin
            FLabel.top:=self.top;
            FLabel.left:=self.left-FLabel.canvas.textwidth(FLabel.caption)-FLabelMargin;
           end;
 lpLeftCenter:begin
               FLabel.top:=self.top+((self.height-FLabel.height) shr 1);
               FLabel.left:=self.left-FLabel.canvas.textwidth(FLabel.caption)-FLabelMargin;
              end;
 lpLeftBottom:begin
               FLabel.top:=self.top+self.height-FLabel.height;
               FLabel.left:=self.left-FLabel.canvas.textwidth(FLabel.caption)-FLabelMargin;
              end;
 lpTopLeft:begin
             FLabel.top:=self.top-FLabel.height-FLabelMargin;
             FLabel.left:=self.left;
           end;
 lpBottomLeft:begin
               FLabel.top:=self.top+self.height+FLabelMargin;
               FLabel.left:=self.left;
              end;
 lpLeftTopLeft:begin
                FLabel.top:=self.top;
                FLabel.left:=self.left-FLabelMargin;
               end;
 lpLeftCenterLeft:begin
                  FLabel.top:=self.top+((self.height-FLabel.height) shr 1);
                  FLabel.left:=self.left-FLabelMargin;
                  end;
 lpLeftBottomLeft:begin
                   FLabel.top:=self.top+self.height-FLabel.height;
                   FLabel.left:=self.left-FLabelMargin;
                  end;
 end;
  FLabel.Font.Assign(FLabelFont);
  FLabel.Visible := Visible;
end;


destructor TAdvMaskEdit.Destroy;
begin
  FLabelFont.Free;
  if FLabel <> Nil then FLabel.Free;
  inherited Destroy;
end;

procedure TAdvMaskEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft,ATop,AWidth,AHeight);
  if FLabel <> nil then
    UpdateLabel;
  if FFlat then
    SetFlatRect(FFlat);
end;

procedure TAdvMaskEdit.SetFlat(const Value: boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    if FFlat then
    begin
      if not (csLoading in ComponentState) then
        if FFlatParentColor then
           Color := (Parent as TWinControl).Brush.Color;
      Borderstyle := bsNone;
      SetFlatRect(True);
    end
    else
    begin
      Color := clWindow;
      BorderStyle := FOldBorder;
      SetFlatRect(False);
    end;
    Invalidate;
  end;
end;

procedure TAdvMaskEdit.CMFontChanged(var Message: TMessage);
begin
  if (csDesigning in ComponentState) then
    if FLabel<>nil then FLabel.Font.Assign(self.font);
  inherited;
  SetFlatRect(FFlat);  
end;


procedure TAdvMaskEdit.WMPaint(var Msg: TWMPaint);
begin
  inherited;
  PaintEdit;
  if Border3D then DrawBorder;
end;

procedure TAdvMaskEdit.WMKeyDown(var Msg: TWMKeydown);
begin
  if (msg.CharCode = VK_RETURN) and (FReturnIsTab) then
  begin
    msg.CharCode := VK_TAB;
    PostMessage(self.Handle,WM_KEYDOWN,VK_TAB,0);
  end;
  if (msg.CharCode = VK_ESCAPE) and (Alignement <> taLeftJustify) then
  begin
    if CanUndo then
      self.Text := FOriginalValue;
    PostMessage(Parent.Handle,WM_KEYDOWN,VK_ESCAPE,0);
  end;
  inherited;
end;

function TAdvMaskEdit.GetModified: boolean;
begin
  Result := inherited Modified;
end;

procedure TAdvMaskEdit.SetModified(const Value: boolean);
begin
  if FShowModified then
  begin
    if Value = False then
      self.Font.Color := FFontColor
    else
      self.Font.Color := FModifiedColor;
  end;

  inherited Modified := Value;
end;

procedure TAdvMaskEdit.SetDisabledColor(const Value: TColor);
begin
  FDisabledColor := Value;
  Invalidate;
end;

function TAdvMaskEdit.GetEnabledEx: Boolean;
begin
  Result := inherited Enabled;
end;

procedure TAdvMaskEdit.SetEnabledEx(const Value: Boolean);
var
  OldValue: Boolean;
  OldColor: TColor;
begin
  OldValue := inherited Enabled;

  inherited Enabled := Value;

  if (csLoading in ComponentState) or
     (csDesigning in ComponentState) then Exit;

  if (OldValue <> Value) then
  begin
    if value then
    begin
      Color := FNormalColor;
    end
    else
    begin
      OldColor := Color;
      Color := FDisabledColor;
      FNormalColor := OldColor;
    end;
  end;

  if Assigned(FLabel) then
    if not FLabelAlwaysEnabled then
      FLabel.Enabled := Value;

end;

function TAdvMaskEdit.GetColorEx: TColor;
begin
  Result := inherited Color;
end;

procedure TAdvMaskEdit.SetColorEx(const Value: TColor);
begin
  if csLoading in ComponentState then
    FLoadedColor := Value;
    
  inherited Color := Value;
  if not (csLoading in ComponentState) then
    FNormalColor := Value;
end;

procedure TAdvMaskEdit.Loaded;
var
  FOldColor: TColor;
begin
  inherited Loaded;
  FFontColor := Font.Color;
  FOldBorder := BorderStyle;

  FFlat := not FFlat;
  SetFlat(not FFlat);

  if Assigned(FLabel) and not Enabled then
    if not FLabelAlwaysEnabled then
      FLabel.Enabled := False;

  inherited Color := FLoadedColor;
  FNormalColor := FLoadedColor;

  if FlatParentColor and Flat then
    Color := (Parent as TWinControl).Brush.Color;

  if not Enabled then
  begin
    FOldColor := Color;
    Color := FDisabledColor;
    FNormalColor := FOldColor;
  end;

end;

procedure TAdvMaskEdit.SetLabelFont(const Value: TFont);
begin
  FLabelFont.Assign(Value);
  if Assigned(FLabel) then
    FLabel.Font.Assign(FLabelFont);
end;

procedure TAdvMaskEdit.LabelFontChanged(Sender: TObject);
begin
  if Assigned(FLabel) then
    FLabel.Font.Assign(FLabelFont);
end;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;


function AdvInputQuery(const QueryType:tAdvEditType; QueryParams:PQueryParams; const ACaption, APrompt: string;
  var Value: string): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TAdvEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      ClientHeight := MulDiv(63, DialogUnits.Y, 8);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        AutoSize := True;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Caption := APrompt;
      end;
      Edit := TAdvEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := MulDiv(19, DialogUnits.Y, 8);
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
        EditType:=QueryType;
        if QueryParams<>nil then
         begin
          Prefix:=QueryParams^.Prefix;
          Suffix:=QueryParams^.Suffix;
          Precision:=QueryParams^.Precision;
          LengthLimit:=QueryParams^.LengthLimit;
          Flat:=QueryParams^.Flat;
          if Flat then Height:=Height-4;
         end;
      end;
      ButtonTop := MulDiv(41, DialogUnits.Y, 8);
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        {$IFNDEF DELPHI3_LVL}
        Caption := 'Ok';
        {$ELSE}
        Caption := SMsgDlgOK;
        {$ENDIF}

        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        {$IFNDEF DELPHI3_LVL}
        Caption := 'Cancel';
        {$ELSE}
        Caption := SMsgDlgCancel;
        {$ENDIF}
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;


constructor TRangeList.Create;
begin
 inherited Create;
end;

procedure TRangeList.SetInteger(Index: Integer;Value: Integer);
begin
 inherited Items[Index]:=Pointer(Value);
end;

function TRangeList.GetInteger(Index: Integer): Integer;
begin
 Result := Integer(inherited Items[Index]);
end;

procedure TRangeList.Add(Value: Integer);
begin
 if IndexOf(pointer(value)) = -1 then inherited Add(Pointer(Value));
end;

procedure TRangeList.AddMultiple(Value,Count: Integer);
var
 i: Integer;
begin
 for i:=1 to Count do Add(value+i-1);
end;


procedure TRangeList.Delete(Index: Integer);
begin
 inherited Delete(Index);
end;

function TRangeList.InList(value: integer): Boolean;
begin
 Result := not (IndexOf(pointer(value))=-1);
end;

procedure TRangeList.Show;
var
 c: Integer;
begin
 for c:=1 to Count do outputdebugstring(pchar(inttostr(Items[c-1])));
end;

function TRangeList.StrToList(s:string): Boolean;
var
 c,code: Integer;
 res: Boolean;

 function DoRange(s:string): Boolean;
 var
  i,i1,i2: Integer;
 begin
  Result := true;
  val(copy(s,1,Pos('-',s)-1),i1,code);
  if (code<>0) then Result := false;
  val(copy(s,Pos('-',s)+1,Length(s)),i2,code);
  if (code<>0) then Result := false;
  if result then for i:=i1 to i2 do Add(i);
 end;

 function SepPos(s:string): Integer;
 var
  p1,p2: Integer;
 begin
  p1:=Pos(',',s);
  p2:=Pos(';',s);

  if ((p1<p2) and (p1>0)) or (p2=0) then Result := p1 else Result := p2;

 end;

begin
 self.Clear;
 res:=true;

 while (Length(s)>0) do
  begin
   if SepPos(s)>0 then
    begin
     if (Pos('-',s)<SepPos(s)) and (Pos('-',s)>0) then
      begin
       if not DoRange(copy(s,1,SepPos(s)-1)) then res:=false;
      end
     else
      begin
       val(copy(s,1,SepPos(s)-1),c,code);
       if (code<>0) then res:=false
       else Add(c);
      end;
     system.delete(s,1,SepPos(s));
    end
  else
    begin
     if Pos('-',s)>0 then
      begin
       if not DoRange(s) then res:=false;
      end
     else
      begin
       val(s,c,code);
       if (code<>0) then res:=false
       else Add(c);
      end;
     s:='';
    end;
  end;
  Result := res;
end;

function TAdvMaskEdit.GetVisible: Boolean;
begin
  Result := inherited Visible;
end;

procedure TAdvMaskEdit.SetVisible(const Value: Boolean);
begin
  inherited Visible := Value;
  if (FLabel<>nil) then
    FLabel.Visible := Value;
end;

procedure TAdvMaskEdit.DrawBorder;
var
  DC: HDC;
begin
  if not (FFlat or (FFocusBorder and FMouseInControl) or Border3D) then
    Exit;

  DC := GetWindowDC(Handle);
  try
    DrawControlBorder(DC);
  finally
    ReleaseDC(Handle,DC);
  end;
end;


procedure TAdvMaskEdit.DrawControlBorder(DC: HDC);
var
  ARect: TRect;
  BtnFaceBrush, WindowBrush: HBRUSH;
begin
  if Is3DBorderButton then
    BtnFaceBrush := CreateSolidBrush(GetSysColor(COLOR_BTNFACE))
  else
    BtnFaceBrush := CreateSolidBrush(ColorToRGB((parent as TWinControl).Brush.color));

  WindowBrush := CreateSolidBrush(GetSysColor(COLOR_WINDOW));

  try
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);
    if Is3DBorderButton then
    begin
      DrawEdge(DC, ARect, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
      FrameRect(DC, ARect, BtnFaceBrush);
    end
    else
    begin
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, BtnFaceBrush);
    end;
  finally
    DeleteObject(WindowBrush);
    DeleteObject(BtnFaceBrush);
  end;
end;

function TAdvMaskEdit.Is3DBorderButton: Boolean;
begin
  if csDesigning in ComponentState then
    Result := Enabled
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);

  Result := (Result and FFocusBorder) or (Border3D);
end;



{$IFDEF DELPHI3_LVL}

procedure TAdvMaskEdit.SetFlatLineColor(const Value: TColor);
begin
  FFlatLineColor := Value;
  Invalidate;
end;

procedure TAdvMaskEdit.PaintEdit;
var
  DC: HDC;
  Oldpen: HPen;
  Loc: TRect;

begin

  if FFlat then
  begin
    DC := GetDC(Handle);

    if FFocusBorder then
      DrawControlBorder(DC)
    else
    begin
      OldPen := SelectObject(dc,CreatePen( PS_SOLID,1,ColorToRGB(FFlatLineColor)));
      SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));

      if FSoftBorder then
      begin
        MovetoEx(DC,Loc.Left- 2,Height - 1,nil);
        LineTo(DC,Width - 1,Height - 1);
        LineTo(DC,Width - 1,Loc.Top - 4);
        LineTo(DC,Loc.Left - 2,Loc.Top - 4);
        LineTo(DC,Loc.Left - 2,Height - 1);
      end
      else
      begin
        MovetoEx(DC,Loc.Left- 2,Height - 1,nil);
        LineTo(DC,Width ,Height - 1);
      end;

      DeleteObject(SelectObject(DC,OldPen));
    end;

    ReleaseDC(Handle,DC);
  end;
end;

procedure TAdvMaskEdit.SetFlatRect(const Value: Boolean);
var
  loc: TRect;
begin
  if Value then
  begin
    loc.Left := 2;
    loc.Top := 4;
    loc.Right := Clientrect.Right - 2;
    loc.Bottom := Clientrect.Bottom - 4;
  end
  else
  begin
    loc.Left := 0;
    loc.Top := 0;
    loc.Right := ClientRect.Right;
    loc.Bottom := ClientRect.Bottom;
  end;

  SendMessage(self.Handle,EM_SETRECTNP,0,longint(@loc));
end;

procedure TAdvMaskEdit.SetSoftBorder(const Value: Boolean);
begin
  FSoftBorder := Value;
  Invalidate;
end;

procedure TAdvMaskEdit.SetBorder3D(const Value: Boolean);
begin
  FBorder3D := Value;
end;

procedure TAdvMaskEdit.SetFlatParentColor(const Value: Boolean);
begin
  FFlatParentColor := Value;
  Invalidate;
end;

procedure TAdvMaskEdit.CreateWnd;
begin
  inherited;
  SetFlatRect(FFlat);
end;

{ TEditDropTarget }

constructor TEditDropTarget.Create(AEdit: TAdvEdit);
begin
  inherited Create;
  FAdvEdit := AEdit;
end;

procedure TEditDropTarget.DragMouseMove(pt: tpoint; var allow: boolean);
begin
  inherited;
  pt := FAdvEdit.ScreenToClient(pt);
  FAdvEdit.DrawCaretByCursor;
end;

procedure TEditDropTarget.DropText(pt: tpoint; s: string);
var
  isCopy: Boolean;
  uchar: Integer;

begin
  inherited;

  // do not copy multiline text
  if Pos(#13,s)>0 then s := copy(s,1,Pos(#13,s)-1);
  if Pos(#10,s)>0 then s := copy(s,1,Pos(#10,s)-1);

  if (FAdvEdit.FIsDragSource) then
   begin
    uchar := FAdvEdit.CharFromPos(pt);
    if (uchar >= FAdvEdit.SelStart) and
       (uchar <= FAdvEdit.SelStart+fAdvEdit.SelLength) then
         Exit;
   end;

  isCopy := (getkeystate(vk_control) and $8000=$8000);

  if (fAdvEdit.fIsDragSource) and not isCopy then
   begin
     fAdvEdit.ClearSelection;
   end;

  FAdvEdit.EraseCaret;
  FAdvEdit.SetCaretByCursor;
  FAdvEdit.SetSelTextBuf(pchar(s));
  FAdvEdit.Invalidate;
end;

procedure Initialize;
var
  Result : HRESULT;
begin
  Result := OleInitialize (nil);
  Assert (Result in [S_OK, S_FALSE], Format ('OleInitialize failed ($%x)', [Result]));
end;


{ TListHintWindow }
constructor TListHintWindow.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TListHintWindow.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style + WS_BORDER;

  if (Win32Platform = VER_PLATFORM_WIN32_NT) and
     ((Win32MajorVersion > 5) or
      ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1))) then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;

  Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST;
end;

destructor TListHintWindow.Destroy;
begin
  inherited;
end;

procedure TListHintWindow.WMActivate(var Message: TMessage);
begin
  inherited;
  if Message.WParam = integer(False) then
    Hide
  else
    FListControl.SetFocus;
end;

procedure TListHintWindow.WMNCButtonDown(var Message: TMessage);
begin
  inherited;
end;

procedure TListHintWindow.WMNCHitTest(var Message: TWMNCHitTest);
begin
  message.Result := HTCLIENT;
end;

{ TLookupSettings }

constructor TLookupSettings.Create;
begin
  inherited Create;
  FDisplayList := TStringList.Create;
  FValueList := TStringList.Create;
  FColor := clWindow;
  FDisplayCount := 4;
  FNumChars := 2;
  FEnabled := False;
end;

destructor TLookupSettings.Destroy;
begin
  FValueList.Free;
  FDisplayList.Free;
  inherited;
end;

procedure TLookupSettings.SetDisplayList(const Value: TStringList);
begin
  FDisplayList.Assign(Value);
end;

procedure TLookupSettings.SetNumChars(const Value: Integer);
begin
  if Value > 0 then
    FNumChars := Value
end;

procedure TLookupSettings.SetValueList(const Value: TStringList);
begin
  FValueList.Assign(Value);
end;


initialization
  Initialize
finalization
  OleUninitialize

{$ENDIF}

end.
