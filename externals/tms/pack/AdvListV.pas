{************************************************************************}
{ TADVLISTVIEW component                                                 }
{ for Delphi & C++Builder                                                }
{ version 1.6                                                            }
{                                                                        }
{ written by                                                             }
{   TMS Software                                                         }
{   copyright � 1998-2003                                                }
{   Email : info@tmssoftware.com                                         }
{   Web : http://www.tmssoftware.com                                     }
{                                                                        }
{ The source code is given as is. The author is not responsible          }
{ for any possible damage done due to the use of this code.              }
{ The component can be freely used in any application. The complete      }
{ source code remains property of the author and may not be distributed, }
{ published, given or sold in any form as such. No parts of the source   }
{ code can be included in any other component or application without     }
{ written authorization of the author.                                   }
{************************************************************************}

unit AdvListV;

interface

{$I TMSDEFS.INC}
{$R ALVRES.RES}

{$DEFINE HILIGHT}
{$DEFINE REMOVEIPOSFROM}
{$DEFINE REMOVESTRIP}
{$J+}

uses
  Classes, ComCtrls, Messages, Windows, Controls, StdCtrls, SysUtils, Graphics,
  Commctrl, Forms, PictureContainer, Dialogs,
{$IFDEF DELPHI3_LVL}
  Comobj, ActiveX,
{$ELSE}
  OleAuto, OleCtnrs,
{$ENDIF}
  Clipbrd, Printers, Registry, ShellApi, AlvUtil, RichEdit
{$IFDEF DELPHI4_LVL}
  , ImgList
{$ENDIF}
{$IFDEF TMSCODESITE}
  , CSIntf
{$ENDIF}
{$IFDEF DELPHI6_LVL}
  , Variants
{$ENDIF}
  ;

type
  TVAlignment = (vtaCenter, vtaTop, vtaBottom);

const
  MAJ_VER = 1; // Major version nr.
  MIN_VER = 6; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 0; // Build nr.
  DATE_VER = 'Apr, 2003'; // Month version

  alvHDS_FILTERBAR = $100;
  alvHDI_FILTER = $100;
  alvHDFT_ISSTRING = $0;
  alvHDFT_ISNUMBER = $1;

  alvHDN_FILTERCHANGING = HDN_FIRST - 12;
  alvHDN_FILTERBTNCLICK = HDN_FIRST - 13;
  alvHDM_SETFILTERCHANGETIMEOUT = HDM_FIRST + 22;

  MAX_COLUMNS = 256;
  MAX_TEXTSIZE = 1024;

  CHECKBOX_SIZE = 14;
  COLUMN_SPACING = 2;

  crURLcursor = 8019;

{$IFNDEF DELPHI4_LVL}
  LVS_OWNERDRAWFIXED = $0400;
  HDF_BITMAP_ON_RIGHT = $1000;

  LVS_EX_GRIDLINES = $00000001; // Report mode only.
  LVS_EX_SUBITEMIMAGES = $00000002; // Report mode only.
  LVS_EX_CHECKBOXES = $00000004;
  LVS_EX_TRACKSELECT = $00000008;
  LVS_EX_HEADERDRAGDROP = $00000010; // Report mode only.
  LVS_EX_FULLROWSELECT = $00000020; // Report mode only.
  LVS_EX_ONECLICKACTIVATE = $00000040;
  LVS_EX_TWOCLICKACTIVATE = $00000080;

  LVS_EX_FLATSB = $00000100;

  LVM_SETEXTENDEDLISTVIEWSTYLE = LVM_FIRST + 54;
  LVM_GETHEADER = (LVM_FIRST + 31);
  LVM_SETHOVERTIME = (LVM_FIRST + 71);
  LVM_GETHOVERTIME = (LVM_FIRST + 72);
{$ENDIF}

{$IFDEF VER90}
  LVM_SETCOLUMNORDERARRAY = (LVM_FIRST + 58);
  LVM_GETCOLUMNORDERARRAY = (LVM_FIRST + 59);

  LVM_GETEXTENDEDLISTVIEWSTYLE = (LVM_FIRST + 55);
  LVM_GETSUBITEMRECT = LVM_FIRST + 56;
  LVM_SUBITEMHITTEST = LVM_FIRST + 57;
{$ENDIF}

{$IFDEF VER93}
  LVM_SETCOLUMNORDERARRAY = (LVM_FIRST + 58);
  LVM_GETCOLUMNORDERARRAY = (LVM_FIRST + 59);
  LVM_GETEXTENDEDLISTVIEWSTYLE = (LVM_FIRST + 55);
  LVM_GETSUBITEMRECT = LVM_FIRST + 56;
  LVM_SUBITEMHITTEST = LVM_FIRST + 57;
{$ENDIF}

{$IFNDEF DELPHI4_LVL}
  LVM_SETTOOLTIPS = LVM_FIRST + 74;

  LVIF_INDENT = $0010;
  LVIF_NORECOMPUTE = $0800;

  LVCF_IMAGE = $0010; // index of image in the image list for column header
  LVCF_ORDER = $0020; // 0 based column offset, left to right order

  LVCFMT_IMAGE = $0800; // Item displays an image from an image list
  LVCFMT_BITMAP_ON_RIGHT = $1000; // Image appears to right of text.
  LVCFMT_COL_HAS_IMAGES = $8000; // Undocumented.

  HDS_HOTTRACK = $4;

  HDM_SETIMAGELIST = (HDM_FIRST + 8);
  HDM_GETIMAGELIST = (HDM_FIRST + 9);
{$ENDIF}

  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[boolean] of Word = (DT_SINGLELINE, DT_WORDBREAK);
  EndEllips: array[boolean] of Word = (0, DT_END_ELLIPSIS);

{$IFNDEF DELPHI4_LVL}
type
  PLVBkImageA = ^TLVBkImageA;
  TLVBkImageA = packed record
    ulFlags: ULONG; // LVBKIF_*
    hbm: HBITMAP;
    pszImage: PChar;
    cchImageMax: UINT;
    xOffsetPercent: Integer;
    yOffsetPercent: Integer;
  end;

  PLVBkImageW = ^TLVBkImageW;
  TLVBkImageW = packed record
    ulFlags: ULONG; // LVBKIF_*
    hbm: HBITMAP;
    pszImage: PWideChar;
    cchImageMax: UINT;
    xOffsetPercent: Integer;
    yOffsetPercent: Integer;
  end;

  PLVBkImage = PLVBkImageA;
  TLVBkImage = TLVBkImageA;

const
  LVBKIF_SOURCE_NONE = $00000000;
  LVBKIF_SOURCE_HBITMAP = $00000001;
  LVBKIF_SOURCE_URL = $00000002;
  LVBKIF_SOURCE_MASK = $00000003;
  LVBKIF_STYLE_NORMAL = $00000000;
  LVBKIF_STYLE_TILE = $00000010;
  LVBKIF_STYLE_MASK = $00000010;

  LVM_SETBKIMAGEA = (LVM_FIRST + 68);
  LVM_SETBKIMAGEW = (LVM_FIRST + 138);
  LVM_GETBKIMAGEA = (LVM_FIRST + 69);
  LVM_GETBKIMAGEW = (LVM_FIRST + 139);

  LVM_SETBKIMAGE = LVM_SETBKIMAGEA;
  LVM_GETBKIMAGE = LVM_GETBKIMAGEA;

{$ENDIF}

type
  PHDItemExA = ^THDItemExA;
  PHDItemExW = ^THDItemExW;
  PHDItemEx = PHDItemExA;

  THDItemExA = packed record
    Mask: Cardinal;
    cxy: Integer;
    pszText: PAnsiChar;
    hbm: HBITMAP;
    cchTextMax: Integer;
    fmt: Integer;
    lParam: LPARAM;
    iImage: Integer;
    iOrder: Integer;
    hdtype: Integer;
    pvFilter: pointer;
  end;

  THDItemExW = packed record
    Mask: Cardinal;
    cxy: Integer;
    pszText: PWideChar;
    hbm: HBITMAP;
    cchTextMax: Integer;
    fmt: Integer;
    lParam: LPARAM;
    iImage: Integer;
    iOrder: Integer;
    hdtype: Integer;
    pvFilter: pointer;
  end;
  THDItemEx = THDItemExA;

  PHDTextFilter = ^THDTextFilter;
  THDTextFilter = record
    pszText: pchar;
    cchTextMax: Integer;
  end;

type
  EAdvListViewError = class(Exception);

  TSortDirection = (sdAscending, sdDescending);

  TSortIndicator = (siLeft, siRight);

  TSortStyle = (ssAutomatic, ssAlphabetic, ssNumeric, ssDate, ssAlphaNoCase, ssAlphaCase,
    ssShortDateEU, ssShortDateUS, ssCustom, ssFinancial, ssRaw);

  TLVExtendedStyle = (lvxGridLines, lvxSubItemImages, lvxCheckboxes, lvxTrackSelect,
    lvxHeaderDragDrop, lvxFullRowSelect, lvxOneClickActivate,
    lvxTwoClickActivate);

  TLVExtendedStyles = set of TLVExtendedStyle;

  TLVAnchorClick = procedure(Sender: TObject; Anchor: string) of object;

  TDrawItemProp = procedure(Sender: TObject; itemindex, subitemindex: Integer;
    AState: TOwnerDrawState;
    ABrush: TBrush; AFont: TFont;
    ItemText: string) of object;

  TDrawItemEvent = procedure(Sender: TObject;
    aCanvas: tCanvas; itemindex: Integer;
    Rect: TRect; State: TOwnerDrawState) of object;

  TPrintPageEvent = procedure(Sender: TObject; Canvas: TCanvas; pagenr, pagexsize, pageysize: Integer) of object;

  TSortStartEvent = procedure(Sender: TObject; Column: Integer; var Enable: Boolean) of object;
  TSortDoneEvent = procedure(Sender: TObject; Column: Integer) of object;

  TColumnSizeEvent = procedure(Sender: TObject; Column: Integer) of object;

  TFormatEvent = procedure(Sender: TObject; ACol: longint; var AStyle: TSortStyle; var aPrefix, aSuffix: string) of object;

  TCustomCompareEvent = procedure(Sender: TObject; ACol: longint; const str1, str2: string; var res: Integer) of object;

  TRawCompareEvent = procedure(Sender: TObject; Col, Row1, Row2: longint; var res: Integer) of object;

  TOnResizeEvent = procedure(Sender: TObject) of object;

  TDoFitToPageEvent = procedure(Sender: TObject; var ScaleFactor: Double; var Allow: Boolean) of object;

  TPrintColumnWidthEvent = procedure(Sender: TObject; ACol: Integer; var width: Integer) of object;

  TPrintNewPageEvent = procedure(Sender: TObject; ARow: Integer; var NewPage: Boolean) of object;

  TStartColumnTrackEvent = procedure(Sender: TObject; Column: Integer; var Allow: Boolean) of object;
  TEndColumnTrackEvent = procedure(Sender: TObject; Column: Integer) of object;

  TClickCellEvent = procedure(Sender: TObject; iItem, iSubItem: Integer) of object;

  TEditCellEvent = procedure(Sender: TObject; iItem, iSubItem: Integer; var Allow: Boolean) of object;

  TFilterChange = procedure(Sender: TObject; iItem: Integer) of object;
  TFilterBtnClick = procedure(Sender: TObject; iItem: Integer) of object;

  TCheckboxClickEvent = procedure(Sender: TObject; iItem: Integer; State: Boolean) of object;

  TURLClickEvent = procedure(Sender: TObject; iItem: Integer; URL: string; var Handled: Boolean) of object;

const
  API_STYLES: array[lvxGridLines..lvxTwoClickActivate] of LPARAM = (
    LVS_EX_GRIDLINES, LVS_EX_SUBITEMIMAGES, LVS_EX_CHECKBOXES,
    LVS_EX_TRACKSELECT, LVS_EX_HEADERDRAGDROP, LVS_EX_FULLROWSELECT,
    LVS_EX_ONECLICKACTIVATE, LVS_EX_TWOCLICKACTIVATE
    );

type
  TAdvListView = class;

{$IFNDEF DELPHI4_LVL}
  tagNMHEADER = packed record
    Hdr: TNMHdr;
    Item: Integer;
    Button: Integer;
    PItem: PHDItem;
  end;
{$ENDIF}

  PLVItemEx = ^TLVItemEx;
  TLVItemEx = packed record
    mask: UINT;
    iItem: Integer;
    iSubItem: Integer;
    state: UINT;
    stateMask: UINT;
    pszText: PAnsiChar;
    cchTextMax: Integer;
    iImage: Integer;
    lParam: LPARAM;
    iIndent: Integer;
  end;

  PLVHitTestInfoEx = ^TLVHitTestInfoEx;
  TLVHitTestInfoEx = packed record
    pt: TPoint;
    flags: UINT;
    iItem: Integer;
    iSubItem: Integer;
  end;

  TLVColumnEx = packed record
    mask: UINT;
    fmt: Integer;
    cx: Integer;
    pszText: PAnsiChar;
    cchTextMax: Integer;
    iSubItem: Integer;
    iImage: Integer;
    iOrder: Integer;
  end;

  THTMLSettings = class(TPersistent)
  private
    FSaveColor: Boolean;
    FSaveFonts: Boolean;
    FFooterFile: string;
    FHeaderFile: string;
    FBorderSize: Integer;
    FCellSpacing: Integer;
    FTableStyle: string;
    FPrefixTag: string;
    FSuffixTag: string;
    FWidth: Integer;
  public
    constructor Create;
  published
    property BorderSize: Integer read FBorderSize write FBorderSize default 1;
    property CellSpacing: Integer read FCellSpacing write FCellSpacing default 0;
    property SaveColor: Boolean read FSaveColor write FSaveColor default True;
    property SaveFonts: Boolean read FSaveFonts write FSaveFonts default True;
    property FooterFile: string read FFooterFile write FFooterFile;
    property HeaderFile: string read FHeaderFile write FHeaderFile;
    property TableStyle: string read FTableStyle write FTableStyle;
    property PrefixTag: string read FPrefixTag write FPrefixTag;
    property SuffixTag: string read FSuffixTag write FSuffixTag;
    property Width: Integer read FWidth write FWidth;
  end;

  TPrintPosition = (ppNone, ppTopLeft, ppTopRight, ppTopCenter, ppBottomLeft, ppBottomRight, ppBottomCenter);
  TFitToPage = (fpNever, fpGrow, fpShrink, fpAlways, fpCustom);
  TPrintBorders = (pbNoborder, pbSingle, pbDouble, pbVertical, pbHorizontal);

  TPrintsettings = class(TPersistent)
  private
    FTime: TPrintPosition;
    FDate: TPrintPosition;
    FPageNr: TPrintPosition;
    FPageNumSep: string;
    FDateFormat: string;
    FTitle: TPrintPosition;
    FFont: TFont;
    FHeaderFont: TFont;
    FFooterFont: TFont;
    FBorders: TPrintBorders;
    FBorderStyle: TPenStyle;
    FTitleText: string;
    FCentered: Boolean;
    FRepeatHeaders: Boolean;
    FFooterSize: Integer;
    FHeaderSize: Integer;
    FLeftSize: Integer;
    FRightSize: Integer;
    FColumnSpacing: Integer;
    FRowSpacing: Integer;
    FOrientation: TPrinterOrientation;
    FPagePrefix: string;
    FPageSuffix: string;
    FFixedHeight: Integer;
    FUseFixedHeight: Boolean;
    FFixedWidth: Integer;
    FUseFixedWidth: Boolean;
    FFitToPage: TFitToPage;
    FJobName: string;
    procedure SetPrintFont(value: tFont);
    procedure SetPrintHeaderFont(value: tFont);
    procedure SetPrintFooterFont(value: tFont);
  protected
  public
    constructor Create;
    destructor Destroy; override;
  published
    property FooterSize: Integer read FFooterSize write FFooterSize;
    property HeaderSize: Integer read FHeaderSize write FHeaderSize;
    property Time: TPrintPosition read FTime write FTime;
    property Date: TPrintPosition read FDate write FDate;
    property DateFormat: string read fDateFormat write FDateFormat;
    property PageNr: TPrintPosition read FPageNr write FPageNr;
    property Title: TPrintPosition read FTitle write FTitle;
    property TitleText: string read FTitleText write FTitleText;
    property Font: TFont read FFont write SetPrintFont;
    property HeaderFont: TFont read FHeaderFont write SetPrintHeaderFont;
    property FooterFont: TFont read FFooterFont write SetPrintFooterFont;
    property Borders: TPrintBorders read FBorders write FBorders;
    property BorderStyle: TPenStyle read FBorderStyle write FBorderStyle;
    property Centered: boolean read FCentered write FCentered;
    property RepeatHeaders: boolean read FRepeatHeaders write FRepeatHeaders;
    property LeftSize: Integer read FLeftSize write FLeftSize;
    property RightSize: Integer read FRightSize write FRightSize;
    property ColumnSpacing: Integer read FColumnSpacing write FColumnSpacing;
    property RowSpacing: Integer read FRowSpacing write FRowSpacing;
    property Orientation: TPrinterOrientation read FOrientation write FOrientation;
    property PagePrefix: string read FPagePrefix write FPagePrefix;
    property PageSuffix: string read FPageSuffix write FPageSuffix;
    property FixedWidth: Integer read FFixedWidth write FFixedWidth;
    property FixedHeight: Integer read FFixedHeight write FFixedHeight;
    property UseFixedHeight: Boolean read FUseFixedHeight write FUseFixedHeight;
    property UseFixedWidth: Boolean read FUseFixedWidth write FUseFixedWidth;
    property FitToPage: TFitToPage read FFitToPage write FFitToPage;
    property JobName: string read fJobName write fJobName;
    property PageNumSep: string read fPageNumSep write fPageNumSep;
  end;

{$IFDEF BACKGROUND}
  TBackground = class(TPersistent)
  private
    FListView: TAdvListView;
    FFilename: string;
    FTile: boolean;
    FXOffsetPercent: Integer;
    FYOffsetPercent: Integer;
  protected
    procedure SetFilename(const Val: string);
    procedure SetTile(Val: boolean);
    procedure SetXOffsetPercent(Val: Integer);
    procedure SetYOffsetPercent(Val: Integer);
    procedure ApplyToListView; virtual;
  public
    constructor Create(AOwner: TAdvListView); virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Filename: string read FFilename write SetFilename;
    property Tile: boolean read FTile write SetTile default FALSE;
    property XOffsetPercent: Integer read FXOffsetPercent write SetXOffsetPercent default 0;
    property YOffsetPercent: Integer read FYOffsetPercent write SetYOffsetPercent default 0;
  end;
{$ENDIF}

  TSizeStorage = (stInifile, stRegistry);

  TColumnSize = class(TPersistent)
  private
    FSave: boolean;
    FKey: string;
    FSection: string;
    FStretch: Boolean;
    FStorage: TSizeStorage;
    Owner: TComponent;
    procedure SetStretch(value: Boolean);
    procedure SetSave(value: Boolean);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property Save: Boolean read FSave write SetSave;
    property Key: string read FKey write FKey;
    property Section: string read FSection write FSection;
    property Stretch: Boolean read FStretch write SetStretch;
    property Storage: TSizeStorage read FStorage write FStorage;
  end;

  TAdvRichEdit = class(TRichEdit)
  private
    procedure SelFormat(offset: Integer);
  public
    procedure SelSubscript;
    procedure SelSuperscript;
    procedure SelNormal;
  end;

  TDetails = class(TPersistent)
  private
    FOwner: TAdvListView;
    FVisible: Boolean;
    FColumn: Integer;
    FHeight: Integer;
    FFont: TFont;
    FSplitLine: Boolean;
    FIndent: Integer;
    procedure FontChanged(Sender: TObject);
    procedure SetVisible(AValue: Boolean);
    procedure SetHeight(AValue: Integer);
    procedure SetColumn(AValue: Integer);
    procedure SetFont(AValue: TFont);
    procedure SetIndent(const Value: Integer);
    procedure SetSplitLine(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Column: Integer read FColumn write SetColumn;
    property Font: TFont read FFont write SetFont;
    property Height: Integer read FHeight write SetHeight;
    property Indent: Integer read FIndent write SetIndent;
    property SplitLine: Boolean read FSplitLine write SetSplitLine;
  end;

  TProgressSettings = class(TPersistent)
  private
    FColorTo: TColor;
    FFontColorTo: TColor;
    FColorFrom: TColor;
    FFontColorFrom: TColor;
    FOnChange: TNotifyEvent;
    procedure SetColorFrom(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
    procedure SetFontColorFrom(const Value: TColor);
    procedure SetFontColorTo(const Value: TColor);
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Changed;
  published
    property ColorFrom: TColor read FColorFrom write SetColorFrom;
    property FontColorFrom: TColor read FFontColorFrom write SetFontColorFrom;
    property ColorTo: TColor read FColorTo write SetColorTo;
    property FontColorTo: TColor read FFontColorTo write SetFontColorTo;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TAdvListView = class(TListView)
  private
{$IFNDEF DELPHI3_LVL}
    RowSelect: Boolean;
{$ENDIF}
    FLastAnchor: string;
    FInAnchor: Boolean;
    FHeaderUpdating: Boolean;
    FHeaderTracking: Boolean;
    FHeaderImages: TImageList;
    FHeaderFont: TFont;
    FDummyFont: TFont;
    FHeaderSize: Integer;
    FCanvas: TCanvas;
    FOnDrawItemProp: TDrawItemProp;
    FOnDrawItem: TDrawItemEvent;
    FOnGetFormat: TFormatEvent;
    FCustomCompare: TCustomCompareEvent;
    FRawCompare: TRawCompareEvent;
    FSortStartEvent: TSortStartEvent;
    FSortDoneEvent: TSortDoneEvent;
    FColumnSizeEvent: TColumnSizeEvent;
    FColumnRClickEvent: TColumnSizeEvent;
    FEndColumnTrack: TEndColumnTrackEvent;
    FStartColumnTrack: TStartColumnTrackEvent;
    FRightClickCell: TClickCellEvent;
    FLeftClickCell: TClickCellEvent;
    FCheckboxClick: TCheckboxClickEvent;
    FCanEditCell: TEditCellEvent;
    FAnchorClick: TLVAnchorClick;
    FAnchorEnter: TLVAnchorClick;
    FAnchorExit: TLVAnchorClick;
    FFilterChange: TFilterChange;
    FFilterBtnClick: TFilterBtnClick;
    FOldfont: TFont;
    FOldbrush: TBrush;
    FHeaderHotTrack: Boolean;
    FHeaderDragDrop: Boolean;
    FHeaderFlatStyle: Boolean;
    FHeaderOwnerDraw: Boolean;
    FHeaderColor: TColor;
    FHeaderHeight: Integer;
    FDelimiter: Char;
    FPrintSettings: TPrintSettings;
    FHTMLSettings: THTMLSettings;
    FHTMLHint: Boolean;
    FSubImages: Boolean;
{$IFDEF BACKGROUND}
    FBackground: TBackGround;
{$ENDIF}
    FWallpaper: TBitmap;
    FRichEdit: TAdvRichEdit;
{$IFNDEF DELPHI4_LVL}
    FFlatScrollBar: Boolean;
    FNOwnerDraw: Boolean;
{$ENDIF}
    FColumnIndex: Integer;
    FItemIndex: Integer;
    FItemCaption: string;
    FSubItemEdit: Boolean;
    FSubItemSelect: Boolean;
    FEditBusy: Boolean;
    FFilterBar: Boolean;
    FClipboardEnable: Boolean;
    FSortDirection: TSortDirection;
    FSortShow: Boolean;
    FSortColumn: Integer;
    FSortIndicator: TSortIndicator;
    FSortUpGlyph: TBitmap;
    FSortDownGlyph: TBitmap;
    FCheckTrueGlyph: TBitmap;
    FCheckFalseGlyph: TBitmap;
    FItemHeight: Integer;
    FOldSortCol: Integer;
{$IFNDEF DELPHI4_LVL}
    FHeaderChangeLink: TChangeLink;
{$ENDIF}
    FSaveHeader, FLoadHeader: Boolean;
    FHoverTime: Integer;
    FFilterTimeOut: Integer;
    FWordWrap: Boolean;
    FURLShow: Boolean;
    FURLFull: Boolean;
    FURLColor: TColor;
    FColumnSize: TColumnSize;
    FOldCursor: Integer;
    FScrollHintWnd: THintWindow;
    FScrollHint: Boolean;
    FOnPrintPage: TPrintPageEvent;
    FOnPrintNewPage: TPrintNewPageEvent;
    FDoFitToPage: TDoFitToPageEvent;
    FOnPrintSetColumnWidth: TPrintColumnWidthEvent;
    FOnURLClick: TURLClickEvent;
    FLastHintPos: TPoint;
    FSizeWithForm: Boolean;
    FVAlignment: TVAlignment;
    FVAlign: Integer;
    FAutoHint: Boolean;
    FSelectionColor: TColor;
    FSelectionRTFKeep: Boolean;
    FSelectionTextColor: TColor;
    FPrintpagewidth: Integer;
    FPrintcolstart: Integer;
    FPrintcolend: Integer;
    FReArrangeIndex: Integer;
    FReArrangeItems: Boolean;
    FListTimerID: Integer;
    FDetailView: TDetails;
    Showhintassigned: Boolean;
    PrevRect: TRect;
    Fontscalefactor: Double;
    MaxWidths: array[0..MAX_COLUMNS] of Integer;
    Indents: array[0..MAX_COLUMNS] of Integer;
    FComctrlVersion: Integer;
    FContainer: TPictureContainer;
    FImageCache: THTMLPictureCache;
    FOldSelIdx: Integer;
    FStretchColumn: Boolean;
    FUpdateCount: Integer;
    FProgressSettings: TProgressSettings;
    procedure RTFPaint(itemindex, subitemindex: Integer; Canvas: tCanvas; arect: TRect);
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMHintShow(var Msg: TMessage); message CM_HINTSHOW;
    procedure WMLButtonDown(var Msg: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
    procedure WMNotify(var Message: TWMNotify); message WM_NOTIFY;
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
    procedure WMVScroll(var WMScroll: TWMScroll); message WM_VSCROLL;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    procedure ShowHintProc(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    function SetValueToAPIValue(Styles: TLVExtendedStyles): LPARAM;
    function SetValueFromAPIValue(Styles: DWORD): TLVExtendedStyles;

    procedure SetSubItemImage(ItemIndex, SubItemindex, AValue: Integer);
    function GetSubItemImage(ItemIndex, SubItemindex: Integer): Integer;

    procedure SetProgress(ItemIndex, SubItemindex, AValue: Integer);
    function GetProgress(ItemIndex, SubItemindex: Integer): Integer;

    procedure SetSortImage(AColumn: Integer);
    procedure SetColumnImage(AColumn, AValue: Integer);
    function GetColumnImage(AColumn: Integer): Integer;
    procedure SetItemIndent(itemindex, subitemindex, AValue: Integer);
    function GetItemIndent(itemindex, subitemindex: Integer): Integer;
    function GetUpGlyph: TBitmap;
    procedure SetUpGlyph(Value: TBitmap);
    function GetDownGlyph: TBitmap;
    procedure SetDownGlyph(Value: TBitmap);
    procedure SetCheckTrueGlyph(Value: TBitmap);
    function GetCheckTrueGlyph: TBitmap;
    procedure SetCheckFalseGlyph(Value: TBitmap);
    function GetCheckFalseGlyph: TBitmap;
{$IFDEF BACKGROUND}
    procedure SetBackground(Value: TBackGround);
{$ENDIF}
    procedure SetWallpaper(Value: TBitmap);
    procedure WallPaperChanged;
    procedure WallPaperBitmapChange(Sender: TObject);
    procedure SetHeaderHotTrack(AValue: Boolean);
    procedure SetHeaderDragDrop(AValue: Boolean);
    procedure SetHeaderFlatStyle(AValue: Boolean);
    procedure SetHeaderOwnerDraw(AValue: Boolean);
    procedure SetHeaderColor(AValue: TColor);
    procedure SetHeaderHeight(AValue: Integer);
    procedure SetSubImages(AValue: Boolean);
    procedure SetURLColor(AColor: TColor);
    procedure SetURLShow(AValue: Boolean);
    procedure SetURLFull(AValue: Boolean);
{$IFNDEF DELPHI4_LVL}
    procedure SetFlatScrollBar(AValue: Boolean);
    procedure SetOwnerDraw(AValue: Boolean);
{$ENDIF}
    procedure SetItemHeight(AValue: Integer);
    procedure SetSortDirection(AValue: TSortDirection);
    procedure SetSortColumn(AValue: Integer);
    procedure SetSortShow(AValue: Boolean);
    procedure SetHeaderImages(AValue: TImageList);
    procedure SetHeaderList(Value: HImageList; Flags: Integer);
    procedure SetHeaderFont(value: tFont);
    procedure HeaderFontChange(Sender: TObject);
{$IFNDEF DELPHI4_LVL}
    procedure HeaderListChange(Sender: TObject);
{$ENDIF}
    procedure SetHoverTime(AValue: Integer);
    procedure SetFilterTimeOut(AValue: Integer);
    procedure SetExtendedViewStyle(astyle: Integer; AValue: Boolean);
    procedure DoSort(i: Integer);
    procedure SetVAlignment(aVAlignment: TVAlignment);
    function GetPrintColOffset(Acol: Integer): Integer;
    function GetPrintColWidth(Acol: Integer): Integer;
    procedure InputFromCSV(filename: string; insertmode: Boolean);
    procedure UpdateAlignment(iItem: Integer);
    procedure UpdateHeaderOD(iItem: Integer);
    function FocusRepaint: Integer;
    procedure CopyFunc(select: Boolean);
    procedure PasteFunc;
    procedure CutFunc;
    function GetVisibleItems: Integer;
    procedure SetContainer(AContainer: TPictureContainer);
    procedure SetColumnIndex(const Value: Integer);
    procedure SetFilterBar(const Value: Boolean);
    procedure SetStretchColumn(const Value: Boolean);
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure LVDrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure SetExtendedStyles(Val: TLVExtendedStyles);
    function GetExtendedStyles: TLVExtendedStyles;
    procedure BuildPage(Canvas: tCanvas; preview: Boolean);
    function MapFontHeight(pointsize: Integer): Integer;
    function MapFontSize(height: Integer): Integer;
    procedure ColClick(Column: TListColumn); override;
    procedure Loaded; override;
    procedure WndProc(var Message: TMessage); override;
    procedure SelectionChanged(iItem: Integer); virtual;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure LeftClickCell(item, subitem: Integer); virtual;
    procedure RightClickCell(item, subitem: Integer); virtual;
    procedure QueryDrawProp(item, subitem: Integer; aState: TOwnerDrawState;
      ABrush: TBrush; AFont: TFont; itemtext: string); virtual;
    function HeaderHandle: THandle;
    function GetRichEdit: TAdvRichEdit;
  public
    property Delimiter: char read FDelimiter write FDelimiter;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetVersionNr: Integer; virtual;
    function GetVersionString: string; virtual;
    
    { All IO methods }
    procedure SaveToFile(filename: string);
    procedure LoadFromFile(filename: string);
    procedure SaveToCSV(filename: string);
    procedure LoadFromCSV(filename: string);
    procedure InsertFromCSV(FileName: string);
    procedure SaveToDOC(Filename: string);
    procedure SaveToXLS(Filename: string);
    procedure LoadFromXLS(Filename: string);
    procedure SaveToStream(stream: TStream);
    procedure LoadFromStream(stream: TStream);
    procedure SaveToHTML(filename: string);
    procedure SaveToXML(FileName: string; ListDescr, RecordDescr: string; FieldDescr: TStringList);
    procedure SaveToAscii(filename: string);

    procedure Print;
    procedure Preview(Canvas: TCanvas; DisplayRect: TRect);
    procedure Clear; {$IFDEF DELPHI6_LVL} override; {$ENDIF}
    procedure ClearInit(r, c: Integer);
    procedure Sort;
    procedure StretchRightColumn;
    procedure AutoSizeColumn(i: Integer);
    procedure AutoSizeColumns;
    procedure LoadColumnSizes;
    procedure SaveColumnSizes;
    procedure SelectItem(aIdx: Integer);
    procedure SwapItems(aIdx1, aIdx2: Integer);
    procedure MoveItem(aIdx1, aIdx2: Integer);
    procedure MoveColumn(aIdx1, aIdx2: Integer);
    procedure SwapColumns(aIdx1, aIdx2: Integer);
    procedure RichToItem(itemindex, subitemindex: Integer; RichEditor: TRichEdit);
    procedure ItemToRich(itemindex, subitemindex: Integer; RichEditor: TRichEdit);
    function GetTextAtPoint(x, y: Integer): string;
    function GetIndexAtPoint(x, y: Integer; var iItem, iSubItem: Integer): Boolean;
    function GetTextAtColRow(c, r: Integer): string;
    procedure SetTextAtColRow(c, r: Integer; const s: string);
    function GetItemRect(iItem, iSubItem: Integer): TRect;
    procedure GetFormat(ACol: longint; var AStyle: TSortStyle; var aPrefix, aSuffix: string);
    procedure CustCompare(ACol: longint; const str1, str2: string; var res: Integer);
    procedure RawCompare(ACol, ARow1, ARow2: longint; var res: Integer);
{$IFNDEF DELPHI5_LVL}
    property Canvas: TCanvas read FCanvas;
{$ENDIF}
    property SubItemImages[ItemIndex, SubItemIndex: Integer]: Integer read GetSubItemImage write SetSubItemImage;
    property Progress[ItemIndex, SubItemIndex: Integer]: Integer read GetProgress write SetProgress;
    property ColumnImages[AColumn: Integer]: Integer read GetColumnImage write SetColumnImage;
    property ItemIndents[ItemIndex, SubItemIndex: Integer]: Integer read GetItemIndent write SetItemIndent;
    property SortColumn: Integer read FSortColumn write SetSortColumn;
    property PrintPageWidth: Integer read fPrintPageWidth;
    property PrintColWidth[aCol: Integer]: Integer read GetPrintColWidth;
    property PrintColOffset[aCol: Integer]: Integer read GetPrintColOffset;
    property PrintColStart: Integer read FPrintColStart;
    property PrintColEnd: Integer read FPrintColEnd;
    property RichEdit: TAdvRichEdit read GetRichEdit;
    property ComCtrlVersion: Integer read fComCtrlVersion;
    procedure CutToClipboard;
    procedure CopyToClipBoard;
    procedure CopySelectionToClipboard;
    procedure PasteFromClipboard;
    procedure ShowFilter(onoff: Boolean);
    function GetFilter(index: Integer; filtertype: Integer): string;
    procedure SetFilter(index, filtertype, ivalue: Integer; sValue: string);
    property VersionNr: Integer read GetVersionNr;
    property VersionString: string read GetVersionString;
    property VisibleItems: Integer read GetVisibleItems;
    procedure ReOrganize;
    procedure SetHeaderSize(AValue: Integer);
    procedure DrawHeaderItem(DrawItemStruct: TDrawItemStruct);
    procedure StartEdit(Item, SubItem: Integer);
    procedure SetEditText(const AValue: string);
    procedure HilightInList(HiText: string; DoCase: Boolean);
    procedure UnHilightInList;
    procedure HilightInItem(ItemIndex: Integer; HiText: string; DoCase: Boolean);
    procedure UnHilightInItem(ItemIndex: Integer);
    procedure MarkInList(HiText: string; DoCase: Boolean);
    procedure UnMarkInList;
    procedure MarkInItem(ItemIndex: Integer; HiText: string; DoCase: Boolean);
    procedure UnMarkInItem(ItemIndex: Integer);
    property ColumnIndex: Integer read FColumnIndex write SetColumnIndex;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BeginUpdate;
    procedure EndUpdate;
  published
{$IFNDEF DELPHI4_LVL}
    property OwnerDraw: Boolean read FNOwnerDraw write SetOwnerDraw;
    property FlatScrollBar: Boolean read FFlatScrollBar write SetFlatScrollBar;
{$ENDIF}
    property AutoHint: Boolean read FAutoHint write FAutoHint;
{$IFDEF BACKGROUND}
    property Background: TBackground read FBackground write SetBackground;
{$ENDIF}
    property CheckTrueGlyph: TBitmap read GetCheckTrueGlyph write SetCheckTrueGlyph;
    property CheckFalseGlyph: TBitmap read GetCheckFalseGlyph write SetCheckFalseGlyph;
    property Columns;
    property ClipboardEnable: Boolean read FClipboardEnable write FClipboardEnable;
    property ColumnSize: TColumnSize read FColumnSize write FColumnSize;
    property FilterBar: Boolean read FFilterBar write SetFilterBar default False;
    property FilterTimeOut: Integer read FFilterTimeOut write SetFilterTimeOut;
    property PrintSettings: TPrintSettings read FPrintSettings write FPrintSettings;
    property HTMLHint: Boolean read FHTMLHint write FHTMLHint;
    property HTMLSettings: THTMLSettings read FHTMLSettings write FHTMLSettings;
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor default clNone;
    property HeaderHotTrack: Boolean read FHeaderHotTrack write SetHeaderHotTrack;
    property HeaderDragDrop: Boolean read FHeaderDragDrop write SetHeaderDragDrop;
    property HeaderFlatStyle: Boolean read FHeaderFlatStyle write SetHeaderFlatStyle;
    property HeaderOwnerDraw: Boolean read FHeaderOwnerDraw write SetHeaderOwnerDraw;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight;
    property HeaderImages: TImageList read FHeaderImages write SetHeaderImages;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property HoverTime: Integer read FHoverTime write SetHoverTime;
    property PictureContainer: TPictureContainer read FContainer write SetContainer;
    property ProgressSettings: TProgressSettings read FProgressSettings write FProgressSettings;
    property SelectionRTFKeep: Boolean read FSelectionRTFKeep write FSelectionRTFKeep;
    property ScrollHint: Boolean read FScrollHint write FScrollHint;
    property SelectionColor: TColor read FSelectionColor write FSelectionColor;
    property SelectionTextColor: tColor read FSelectionTextColor write FSelectionTextColor;
    property SizeWithForm: Boolean read FSizeWithForm write FSizeWithForm;
    property SortDirection: TSortDirection read FSortDirection write SetSortDirection;
    property SortShow: Boolean read FSortShow write SetSortShow;
    property SortIndicator: TSortIndicator read FSortIndicator write FSortIndicator;
    property SortUpGlyph: TBitmap read GetUpGlyph write SetUpGlyph;
    property SortDownGlyph: TBitmap read GetDownGlyph write SetDownGlyph;
    property StretchColumn: Boolean read FStretchColumn write SetStretchColumn;
    property SubImages: Boolean read FSubImages write SetSubImages;
    property SubItemEdit: Boolean read FSubItemEdit write FSubItemEdit;
    property SubItemSelect: Boolean read FSubItemSelect write FSubItemSelect;
    property URLColor: TColor read FURLColor write SetURLColor default clBlue;
    property URLShow: Boolean read FURLShow write SetURLShow default False;
    property URLFull: Boolean read FURLFull write SetURLFull default False;
    property VAlignment: TVAlignment read FVAlignment write SetVAlignment;
    property Wallpaper: TBitmap read fWallPaper write SetWallpaper;
    property WordWrap: Boolean read FWordwrap write FWordWrap default False;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property SaveHeader: Boolean read FSaveHeader write FSaveHeader;
    property LoadHeader: Boolean read FLoadHeader write FLoadHeader;
    property ReArrangeItems: Boolean read FReArrangeItems write FReArrangeItems;
    property DetailView: TDetails read FDetailView write FDetailView;
    property OnDrawItemProp: TDrawItemProp read FOnDrawItemProp write FOnDrawItemProp;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnGetFormat: TFormatEvent read FOnGetFormat write FOnGetFormat;
    property OnCustomCompare: TCustomCompareEvent read FCustomCompare write FCustomCompare;
    property OnRawCompare: TRawCompareEvent read FRawCompare write FRawCompare;
    property OnSortStart: TSortStartEvent read FSortStartEvent write FSortStartEvent;
    property OnSortDone: TSortDoneEvent read FSortDoneEvent write FSortDoneEvent;
    property OnColumnSized: TColumnSizeEvent read FColumnSizeEvent write FColumnSizeEvent;
    property OnColumnRClick: TColumnSizeEvent read FColumnRClickEvent write FColumnRClickEvent;
    property OnPrintPage: TPrintPageEvent read FOnPrintPage write FOnPrintPage;
    property OnFitToPage: TDoFitToPageEvent read FDoFitToPage write FDoFitToPage;
    property OnPrintSetColumnWidth: TPrintColumnWidthEvent read FOnPrintSetColumnWidth write FOnPrintSetColumnWidth;
    property OnPrintNewPage: TPrintNewPageEvent read FOnPrintNewPage write FOnPrintNewPage;
    property OnStartColumnTrack: TStartColumnTrackEvent read FStartColumnTrack write FStartColumnTrack;
    property OnEndColumnTrack: TEndColumnTrackEvent read FEndColumnTrack write FEndColumnTrack;
    property OnRightClickCell: TClickCellEvent read FRightClickCell write FRightClickCell;
    property OnLeftClickCell: TClickCellEvent read FLeftClickCell write FLeftClickCell;
    property OnCanEditCell: TEditCellEvent read FCanEditCell write FCanEditCell;
    property OnFilterChange: TFilterChange read FFilterChange write FFilterChange;
    property OnFilterBtnClick: TFilterBtnClick read FFilterBtnClick write FFilterBtnClick;
    property OnAnchorClick: TLVAnchorClick read FAnchorClick write FAnchorClick;
    property OnAnchorEnter: TLVAnchorClick read FAnchorEnter write FAnchorEnter;
    property OnAnchorExit: TLVAnchorClick read FAnchorExit write FAnchorExit;
    property OnCheckboxClick: TCheckBoxClickEvent read FCheckboxClick write FCheckboxClick;
    property OnURLClick: TURLClickEvent read FOnURLClick write FOnURLClick;
  end;


implementation

uses
  INIFiles;

{$I HTMLENGO.PAS}

const
  LV_MAX_COLS = 255;
  CSVSeparators: array[1..10] of Char = (',', ';', '#', #9, '|', '@', '*', '-', '+', '&');

var
  wpOrigEditProc: Integer;
  wpCoord: TRect;

function EditSubclassProc(hwnd: tHandle; uMsg: Integer; wParam: word; lparam: longint): Integer; stdcall;
var
  pwp: PWindowPos;

begin
  if umsg = WM_WINDOWPOSCHANGING then
  begin
    pwp := PWindowPos(lparam);
    with pwp^ do
    begin
      x := wpCoord.Left;
      y := wpCoord.Top;
      cx := wpCoord.Right - wpCoord.Left;
      cy := wpCoord.Bottom - wpCoord.Top;
    end;
  end;

  Result := CallWindowProc(tfnwndproc(wpOrigEditProc), hwnd, uMsg, wParam, lParam);
end;

const
  comctrl = 'comctl32.dll';
  TimerID = 1222;

  {---------------------------------------------------}
  {constant definitions for OLE automation with Word  }
  {---------------------------------------------------}
  wdAlignParagraphLeft = 0;
  wdAlignParagraphCenter = 1;
  wdAlignParagraphRight = 2;
  wdAlignParagraphJustify = 3;

function GetFileVersion(filename: string): Integer;
var
  fileHandle: dword;
  l: Integer;
  pvs: PVSFixedFileInfo;
  lptr: uint;
  querybuf: array[0..MAX_TEXTSIZE - 1] of char;
  buf: pchar;
begin
  Result := -1;
  StrpCopy(querybuf, filename);
  l := GetFileVersionInfoSize(querybuf, fileHandle);
  if (l > 0) then
  begin
    GetMem(buf, l);
    GetFileVersionInfo(querybuf, fileHandle, l, buf);
    if verqueryvalue(buf, '\', pointer(pvs), lptr) then
    begin
      if (pvs^.dwSignature = $FEEF04BD) then
      begin
        Result := pvs^.dwFileVersionMS;
      end;
    end;
    FreeMem(buf);
  end;
end;


var
  FDirection, FSortColNum: Integer;

procedure TColumnSize.SetStretch(value: Boolean);
begin
  FStretch := Value;
  (Owner as TAdvListView).StretchRightColumn;
end;

procedure TColumnSize.SetSave(value: Boolean);
begin
  FSave := Value;
end;


constructor TColumnSize.Create(AOwner: TComponent);
begin
  inherited Create;
  Owner := AOwner;
end;

destructor TColumnSize.Destroy;
begin
  inherited Destroy;
end;

function Header_SetImageList(hWnd: HWND; himl: HImageList; iImageList: Integer): HImageList;
begin
  Result := HImageList(SendMessage(hWnd, HDM_SETIMAGELIST, iImageList, Longint(himl)));
end;

{
function Header_GetImageList(hWnd:HWND;iImageList: Integer):HImageList;
begin
 Result:=HImageList(SendMessage(hWnd,HDM_GETIMAGELIST,iImageList,0));
end;

function ListView_SetBkImage(LVWnd: HWnd; plvbki: PLVBkImage): BOOL;
begin
  Result := (SendMessage(LVWnd, LVM_SETBKIMAGE, 0, LPARAM(plvbki)) <> 0);
end;

function ListView_GetBkImage(LVWnd: HWnd; plvbki: PLVBkImage): BOOL;
begin
  Result := (SendMessage(LVWnd, LVM_GETBKIMAGE, 0, LPARAM(plvbki)) <> 0);
end;
}

function __CustomSort(Item1, Item2: TListItem; Data: Integer): Integer; stdcall;

  function strToShortdateUS(s: string): tdatetime;
  var
    da, mo, ye, i: word;
    code: Integer;
  begin
    Result := 0;

    i := pos('-', s);
    if i = 0 then i := pos('/', s);
    if i = 0 then i := pos('.', s);

    if (i > 0) then val(copy(s, 1, i - 1), mo, code) else Exit;
    delete(s, 1, i);

    i := pos('-', s);
    if i = 0 then i := pos('/', s);
    if i = 0 then i := pos('.', s);

    if (i > 0) then val(copy(s, 1, i - 1), da, code) else Exit;

    delete(s, 1, i);
    val(s, ye, code);
    if ye <= 25 then ye := ye + 2000 else ye := ye + 1900;
    Result := EncodeDate(ye, mo, da);
  end;

  function strToShortDateEU(s: string): tdatetime;
  var
    da, mo, ye, i: word;
    code: Integer;
  begin
    Result := 0;

    i := pos('-', s);
    if i = 0 then i := pos('/', s);
    if i = 0 then i := pos('.', s);

    if (i > 0) then val(copy(s, 1, i - 1), da, code) else Exit;
    delete(s, 1, i);

    i := pos('-', s);
    if i = 0 then i := pos('/', s);
    if i = 0 then i := pos('.', s);

    if (i > 0) then val(copy(s, 1, i - 1), mo, code) else Exit;

    delete(s, 1, i);
    val(s, ye, code);
    if ye <= 25 then ye := ye + 2000 else ye := ye + 1900;
    Result := encodedate(ye, mo, da);
  end;

var
  Str1, Str2: string;
  astyle: tSortStyle;
  prefix, suffix: string;
  r1, r2: double;
  code1, code2: Integer;
  dt1, dt2: tdatetime;
  res: Integer;

begin
  Result := 0;
  if (Item1 = nil) or (Item2 = nil) then Exit;

  if (FSortColNum = -1) then
  begin
    Str1 := Item1.Caption;
    Str2 := Item2.Caption;
  end
  else
  begin
    //check here if it's present ...
    if (item1.subitems.Count > FSortColNum) then
      Str1 := Item1.SubItems[FSortColNum]
    else
      Str1 := '';
    if (item2.subitems.Count > FSortColNum) then
      Str2 := Item2.SubItems[FSortColNum]
    else
      Str2 := '';
  end;

  aStyle := ssAlphabetic; //default sorting style

  prefix := '';
  suffix := '';

  (item1.listview as tadvlistview).GetFormat(FSortColNum, aStyle, prefix, suffix);

  res := 1;
  case aStyle of
    ssAlphabetic, ssAlphaCase:
      begin
        if (str1 > str2) then res := 1
        else
          if (str1 = str2) then res := 0
          else
            res := -1;
      end;
    ssAlphaNoCase:
      begin
        if (UpperCase(str1) > UpperCase(str2)) then res := 1
        else
          if (str1 = str2) then res := 0
          else
            res := -1;
      end;
    ssNumeric, ssFinancial:
      begin
        if (suffix <> '') then
        begin
          if (pos(suffix, str1) > 0) then delete(str1, pos(suffix, str1), length(suffix));
          if (pos(suffix, str2) > 0) then delete(str2, pos(suffix, str2), length(suffix));
        end;

        if (prefix <> '') then
        begin
          if (pos(prefix, str1) > 0) then delete(str1, pos(prefix, str1), length(prefix));
          if (pos(prefix, str2) > 0) then delete(str2, pos(prefix, str2), length(prefix));
        end;

        if (aStyle = ssFinancial) then
        begin
        {delete the thousandseparator}
          while (pos(thousandseparator, str1) <> 0) do delete(str1, pos(thousandseparator, str1), 1);
          while (pos(thousandseparator, str2) <> 0) do delete(str2, pos(thousandseparator, str2), 1);
        end;

        if {(aStyle=ssNumeric) and}(decimalseparator <> '.') then
        begin
          if (pos(decimalseparator, str1) <> 0) then str1[pos(decimalseparator, str1)] := '.';
          if (pos(decimalseparator, str2) <> 0) then str2[pos(decimalseparator, str2)] := '.';
        end;

        val(str1, r1, code1);
        val(str2, r2, code2);

        if (code1 <> 0) then
        begin
          if str1 = '' then
          begin
            r1 := 0;
            code1 := 0;
          end;
        end;
        if (code2 <> 0) then
        begin
          if str2 = '' then
          begin
            r2 := 0;
            code2 := 0;
          end;
        end;

        if (code1 <> 0) or (code2 <> 0) then res := 0
        else
        begin
          if r1 > r2 then res := 1
          else
            if r1 = r2 then res := 0
            else
              res := -1;
        end;
      end;

    ssCustom: begin
        res := 0;
        (item1.listview as tadvlistview).CustCompare(FSortColNum, str1, str2, res);
      end;

    ssRaw: begin
        res := 0;
        (item1.listview as tadvlistview).RawCompare(FSortColNum, Item1.index, Item2.index, res);
      end;

    ssDate, ssShortdateUS, ssShortDateEU:
      begin
        case aStyle of
          ssDate: begin
              try
                dt1 := StrToDatetime(str1);
              except
                dt1 := 0;
              end;
              try
                dt2 := StrToDatetime(str2);
              except
                dt2 := 0;
              end;
            end;
          ssShortDateUS: begin
              try
                dt1 := StrToShortDateUS(str1);
              except
                dt1 := 0;
              end;
              try
                dt2 := StrToShortDateUS(str2);
              except
                dt2 := 0;
              end;
            end;
          ssShortDateEU: begin
              try
                dt1 := StrToShortDateEU(str1);
              except
                dt1 := 0;
              end;
              try
                dt2 := StrToShortDateEU(str2);
              except
                dt2 := 0;
              end;
            end;
        else
          begin
            dt1 := now; dt2 := now;
          end;
        end;

        if (dt1 > dt2) then res := 1
        else
          if (dt1 = dt2) then res := 0
          else
            res := -1;
      end;
  end;

  Result := FDirection * Res; // Set direction flag.
end;

constructor THTMLSettings.Create;
begin
  inherited Create;
  FSaveColor := true;
  FSaveFonts := true;
  FBorderSize := 1;
  FCellSpacing := 0;
  FWidth := 100;
end;


constructor TPrintSettings.Create;
begin
  inherited Create;
  FFont := TFont.Create;
  FHeaderFont := TFont.Create;
  FFooterFont := TFont.Create;
  fPagePrefix := '';
  fPageSuffix := '';
  FPageNumSep := '/';
  FDateFormat := 'dd/mm/yyyy';
end;

destructor TPrintSettings.Destroy;
begin
  FFont.Free;
  FHeaderFont.Free;
  FFooterFont.Free;
  inherited Destroy;
end;

procedure TPrintSettings.SetPrintFont(value: tFont);
begin
  FFont.Assign(value);
end;

procedure TPrintSettings.SetPrintHeaderFont(value: tFont);
begin
  FHeaderFont.Assign(value);
end;

procedure TPrintSettings.SetPrintFooterFont(value: tFont);
begin
  FFooterFont.Assign(value);
end;

procedure TAdvListView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
{$IFNDEF DELPHI4_LVL}
  if FNOwnerDraw then
    Params.Style := Params.Style or LVS_OWNERDRAWFIXED
  else
    Params.Style := Params.Style and (not LVS_OWNERDRAWFIXED);
{$ENDIF}
end;

procedure TAdvListView.SetVAlignment(AVAlignment: TVAlignment);
begin
  FVAlignment := AVAlignment;
  fvAlign := DT_VCENTER;
  case fVAlignment of
    vtaTop: fvAlign := DT_TOP;
    vtaBottom: fvAlign := DT_BOTTOM;
  end;
  Repaint;
end;

{$IFDEF VER90}
function ListView_GetSubItemRect(hwndLV: HWND; iItem, iSubItem: Integer;
  code: DWORD; prc: PRect): BOOL;
begin
  if prc <> nil then
  begin
    prc^.Top := iSubItem;
    prc^.Left := code;
  end;
  Result := BOOL(SendMessage(hwndLV, LVM_GETSUBITEMRECT, iItem, Longint(prc)));
end;
{$ENDIF}

{$IFDEF VER93}
function ListView_GetSubItemRect(hwndLV: HWND; iItem, iSubItem: Integer;
  code: DWORD; prc: PRect): BOOL;
begin
  if prc <> nil then
  begin
    prc^.Top := iSubItem;
    prc^.Left := code;
  end;
  Result := BOOL(SendMessage(hwndLV, LVM_GETSUBITEMRECT, iItem, Longint(prc)));
end;
{$ENDIF}

function ListView_SubItemHitTestEx(hwndLV: HWND; plvhti: PLVHitTestInfoEx): Integer;
begin
  Result := SendMessage(hwndLV, LVM_SUBITEMHITTEST, 0, Longint(plvhti));
end;

function TAdvListView.GetItemRect(iItem, iSubItem: Integer): TRect;
var
  r: TRect;
begin
  ListView_GetSubItemRect(self.Handle, iItem, iSubItem, LVIR_LABEL, @r);
  Result := r;
end;

function TAdvListView.GetIndexAtPoint(X, Y: Integer; var iItem, iSubItem: Integer): Boolean;
var
  Info: TLVHitTestInfoEx;
var
  Index: Integer;
begin
  Result := false;
  Info.pt := Point(X, Y);
  Index := ListView_SubItemHitTestEx(Handle, @Info);
  if (Index <> -1) then
  begin
    iItem := index;
    iSubItem := 0;
    if (Info.isubItem > 0) then iSubItem := info.iSubItem;
    Result := true;
  end;
end;

function TAdvListView.GetTextAtPoint(X, Y: Integer): string;
var
  Info: TLVHitTestInfoEx;
var
  Index: Integer;
begin
  Result := '';
  if HandleAllocated then
  begin
    Info.pt := Point(X, Y);
    Index := ListView_SubItemHitTestEx(Handle, @Info);

    if (Index <> -1) then
    begin
      if (Info.isubItem > 0) then
      begin
        if (items[index].subitems.count >= info.iSubItem) then
          Result := items[index].subitems[info.isubitem - 1];
      end
      else
        Result := Items[Index].caption;
    end;
  end;
end;

procedure TAdvListView.SetTextAtColRow(c, r: Integer; const s: string);
var
  lis: TListItem;
begin
  if (c >= Columns.Count) then Exit;
  if (r >= Items.Count) then Exit;

  lis := Items[r];

  if (c = 0) then lis.caption := s
  else
  begin
    while (c) > lis.subitems.Count do lis.subitems.Add('');
    lis.subitems[c - 1] := s;
  end;
end;

function TAdvListView.GetTextAtColRow(c, r: Integer): string; {itemindex,subitemindex: Integer):string; }
var
  s: string;
begin
  Result := '';
  if (r < 0) then
  begin
    if (c < self.columns.count) then s := self.columns[c].caption;
  end
  else
  begin
    if (r < self.items.count) then
    begin
      if (c <= 0) then s := self.items[r].caption
      else
      begin
        if (c <= self.items[r].subitems.count) then s := self.items[r].subitems[c - 1];
      end;
    end;
  end;

  Result := s;
end;

procedure TAdvListView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  s: string;
  nondef: Boolean;
  iItem, iSubItem: Integer;
  r, hr: TRect;
  anchor, stripped, fa: string;
  xsize, ysize, ml, hl: Integer;
  hdc: THandle;
  Canvas: TCanvas;

begin
  nondef := False;

  s := GetTextAtPoint(X, Y);
  GetIndexAtPoint(X, Y, iItem, iSubItem);

  if FURLShow and (FReArrangeIndex = -1) then
  begin
    if ((Pos('://', s) > 0) or (Pos('mailto:', s) > 0)) and
      (Pos('</', s) = 0) then
    begin
      if not CheckBoxes or (X > 16) then
      begin
        nondef := True;
        if self.Cursor <> crURLcursor then
          self.Cursor := crURLcursor;
      end;
    end;
  end;

  if Pos('</', s) > 0 then
  begin
    GetIndexAtPoint(x, y, iItem, iSubItem);
    r := GetItemRect(iItem, iSubItem);
    hdc := GetDC(self.Handle);
    Canvas := TCanvas.Create;
    Canvas.Handle := hdc;
    r.left := r.left + 2;

    if (iSubItem > 0) then
      if (SubitemImages[iItem,iSubItem - 1] >= 0) then
        r.Left := r.Left + 16;

    if not HTMLDrawEx(Canvas, s, r, TImageList(SmallImages), x, y, -1, -1, 1, True, False, False, True, True, False, True, 1.0,
      FURLColor, clNone, clNone, clGray, Anchor, Stripped, fa, XSize, YSize, hl, ml, hr, FImageCache, FContainer) then
      Anchor := '';

    r.left := r.left - 2;
    Canvas.free;
    Releasedc(self.Handle, hdc);
    if (anchor <> '') then
    begin
      nondef := true;

      if (self.cursor <> crURLcursor) then self.cursor := crURLcursor;
      if (fInAnchor = false) and (flastAnchor <> anchor) then
      begin
        if Assigned(fAnchorEnter) then
          FAnchorEnter(self, anchor);
        FLastAnchor := anchor;
        FInAnchor := true;
      end;
    end;
  end;

  if FInAnchor and not nondef then
  begin
    if assigned(fAnchorExit) then
      fAnchorExit(self, fLastAnchor);
    fLastAnchor := '';
    finAnchor := false;
  end;

  if (FReArrangeIndex <> -1) then
  begin
    self.Cursor := crDrag;
    nondef := true;
  end;

  if not nondef and (self.Cursor <> foldcursor) then self.cursor := foldcursor;

  if (FLastHintPos.x >= 0) and (FLastHintPos.y >= 0) then
  begin
    GetIndexAtPoint(x, y, iItem, iSubItem);
    if (iSubItem <> FLastHintPos.x) or (iItem <> FLastHintPos.y) then
    begin
      Application.CancelHint;
      FLastHintPos := Point(-1, -1);
    end;
  end;

  inherited;
end;

procedure TAdvListView.ItemToRich(itemindex, subitemindex: Integer; RichEditor: TRichEdit);
var
  ms: TMemoryStream;
  s: string;
  i: Integer;
begin
  if subitemindex = -1 then
    s := Items[itemindex].Caption
  else
    s := Items[itemindex].SubItems[SubItemIndex];

  if s <> '' then
  begin
    ms := TMemoryStream.create;
    for i := 1 to Length(s) do ms.write(s[i], 1);
    ms.Position := 0;
    RichEditor.Lines.LoadFromStream(ms);
    ms.free;
  end
  else
  begin
    RichEditor.Clear;
  end;
end;

procedure TAdvListView.RichToItem(itemindex, subitemindex: Integer; RichEditor: TRichEdit);
var
  ms: TMemoryStream;
  s: string;
  i: Integer;
  ch: char;
begin
  s := '';
  ms := TMemoryStream.Create;
  RichEditor.Lines.SaveToStream(ms);
  ms.Position := 0;
  if ms.Size > 0 then
    for i := 0 to ms.Size - 1 do
    begin
      ms.Read(ch, 1);
      s := s + ch;
    end;
  ms.Free;

  if SubItemIndex = -1 then
    Items[itemindex].Caption := s
  else
    Items[itemindex].SubItems[subitemindex] := s;
end;

procedure TAdvListView.RTFPaint(itemindex, subitemindex: Integer; Canvas: TCanvas; ARect: TRect);
const
  RTF_OFFSET: Integer = 2;

type
  rFormatRange = record
    hdc: HDC;
    hdcTarget: HDC;
    rc: TRect;
    rcPage: TRect;
    chrg: TCharRange;
  end;

var
  fr: rFORMATRANGE;
  nLogPixelsX, nLogPixelsY: Integer;
  mm: Integer;
  pt: TPoint;

begin
  ItemToRich(ItemIndex, SubItemIndex, RichEdit);

  if (Items[itemindex].Selected) and (not FSelectionRTFKeep) and (Canvas = self.Canvas) then
  begin
    FRichEdit.SelStart := 0;
    FRichEdit.SelLength := 255;
    FRichEdit.SelAttributes.Color := FSelectionTextColor;
    SendMessage(FRichEdit.Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(FSelectionColor));
  end
  else
    SendMessage(FRichEdit.Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(Color));

  FillChar(fr, SizeOf(TFormatRange), 0);

  lptodp(Canvas.Handle, ARect.TopLeft, 1);
  lptodp(Canvas.Handle, ARect.BottomRight, 1);

  nLogPixelsX := GetDeviceCaps(Canvas.Handle, LOGPIXELSX);
  nLogPixelsY := GetDeviceCaps(Canvas.Handle, LOGPIXELSY);

  pt.x := 2;
  pt.y := 0;
  dptolp(Canvas.Handle, pt, 1);

  RTF_OFFSET := ((pt.x * nLogPixelsX) div 96);

  with fr do
  begin
    fr.hdc := Canvas.Handle;
    fr.hdctarget := Canvas.Handle;
    fr.rcPage.left := round(((arect.left + RTF_OFFSET) / nLogPixelsX) * 1440);
    fr.rcPage.top := round(((arect.top + RTF_OFFSET) / nLogPixelsY) * 1440);
    fr.rcPage.right := fr.rcPage.left + round(((ARect.Right - ARect.Left) / nLogPixelsX) * 1440);
    fr.rcPage.bottom := fr.rcPage.top + round(((ARect.Bottom - ARect.Top) / nLogPixelsY) * 1440);
    fr.rc.left := fr.rcPage.left; { 1440 TWIPS = 1 inch. }
    fr.rc.top := fr.rcPage.top;
    fr.rc.right := fr.rcPage.right;
    fr.rc.bottom := fr.rcPage.bottom;
    fr.chrg.cpMin := 0;
    fr.chrg.cpMax := -1;
  end;

  mm := GetMapMode(Canvas.Handle);
  SetMapMode(Canvas.Handle, mm_text);

  SendMessage(FRichEdit.Handle, EM_FORMATRANGE, 1, longint(@fr));
  SendMessage(FRichEdit.Handle, EM_FORMATRANGE, 0, 0);
  {
  canvas.Pen.Color := clred;
  canvas.MoveTo(ARect.Left,ARect.Top);
  canvas.LineTo(ARect.Right,ARect.Bottom);
  }
  SetMapMode(Canvas.Handle, mm);
end;

procedure TAdvListView.LVDrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  i, xsize, ysize, ml, hl: Integer;
  s, anchor, stripped, fa: string;
  TmpRct, OrgRect, DrwRect, r, hr: TRect;
  oldfont: TFont;
  oldbrush: TBrush;
  iw, im, ih: Integer;
  dtp: TDRAWTEXTPARAMS;
  parr: array[0..LV_MAX_COLS] of Integer;
  iCount: Integer;
  remapi: Integer;
  ColOffset: Integer;
  RemapColIdx: Integer;
  tagpos, urlpos: Integer;
  ShowSelected: Boolean;

begin
  if (Index >= Items.Count) or
    (Canvas.Handle = 0) then
    Exit;

  if Assigned(SmallImages) then
    Smallimages.DrawingStyle := dsTransparent;

  for iCount := 0 to LV_MAX_COLS do
    parr[iCount] := iCount;

  iCount := Columns.count;
  SendMessage(Handle, LVM_GETCOLUMNORDERARRAY, iCount, longint(@parr));

  if GridLines then
    Inflaterect(rect, -1, -1);

  OrgRect := Rect;
  TmpRct := Rect;

  OldFont := TFont.Create;
  OldBrush := TBrush.Create;
  OldFont.Assign(Canvas.Font); //save copy of original font
  OldBrush.Assign(Canvas.Brush); //and brush

  ColOffset := 0;
  RemapColIdx := 0;

  if FDetailView.Visible then
  begin
    Rect.Bottom := Rect.Top + ItemHeight - FDetailView.Height;
  end;

  if (Items[Index].Subitems.Count >= 0) then
  begin
    for i := -1 to Columns.Count - 2 do //use nr. of columns here !
    begin
      remapi := parr[i + 1] - 1;
      RemapColIdx := parr[FColumnIndex];
      s := '';

      Canvas.Font.Assign(Font);
      Canvas.Brush.Color := Color;

      if (Items[index].Subitems.Count > remapi) then
      begin
        if (remapi = -1) then
          s := Items[Index].Caption
        else
          s := Items[Index].SubItems[remapi];
      end;

      if ((odFocused in State) or (odselected in State)) and
        (not RowSelect and (i + 1 <> RemapColIdx)) then
      begin
        Canvas.Brush.Color := Color;
        Canvas.Font.Color := Font.Color;
      end;

      QueryDrawProp(Index, remapi, state, Canvas.Brush, Canvas.Font, s);

      ShowSelected := False;

      if ((odSelected in State) and (((SubItemSelect or SubItemEdit)
        and (i + 1 = RemapColIdx)) or (RowSelect) or (not RowSelect and (i = -1)) and not SubItemSelect)) then
      begin
        Canvas.Brush.Color := SelectionColor;
        Canvas.Font.Color := SelectionTextColor;
        ShowSelected := True;
      end;

      tagpos := pos('</', s);
      urlpos := pos('://', s);

      if (URLShow) and (not (odSelected in State) or not RowSelect) then
        if ((urlpos > 0) or (Pos('mailto:', s) > 0)) and (tagpos = 0) then
        begin
          Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];

          if (odSelected in State) then
            Canvas.Font.Color := SelectionTextColor
          else
            Canvas.Font.Color := URLColor;
        end;

      if URLShow and not URLFull and (tagpos = 0) then
      begin
        if (urlpos > 0) then system.Delete(s, 1, urlpos + 2);
        if (Pos('mailto:', s) > 0) then system.Delete(s, 1, Pos('mailto:', s) + 6);
      end;

      Rect.Left := OrgRect.Left;
      Rect.Right := OrgRect.Right;

      if (i > -1) then //recalc cols
      begin
        for iCount := 0 to i do
        begin
          Rect.Left := Rect.Left + ListView_GetColumnWidth(Handle, parr[iCount]);
          if RemapColIdx > iCount then ColOffset := Rect.Left;
        end;
      end;

      iw := 0;

      TmpRct := Rect;
      TmpRct.Right := Rect.Left + ListView_GetColumnWidth(self.Handle, parr[i + 1]);

      Canvas.Pen.Color := Canvas.Brush.Color;

      if not FWallpaper.Empty and not ShowSelected then
      begin
        SetBKMode(Canvas.Handle, Transparent);
      end
      else
      begin
        SetBKMode(Canvas.Handle, Opaque);

        if GridLines then
          Canvas.Rectangle(TmpRct.Left, OrgRect.Top, TmpRct.Right - 1, OrgRect.Bottom)
        else
          Canvas.Rectangle(TmpRct.Left, OrgRect.Top, TmpRct.Right, OrgRect.Bottom);
      end;

{$IFDEF DELPHI3_LVL}
      if (i = -1) and CheckBoxes then
      begin
        r := TmpRct;

        if not (FCheckTrueGlyph.Empty or FCheckFalseGlyph.Empty) then
        begin
          case VAlignment of
            vtaCenter: if (r.Bottom - r.Top > FCheckTrueGlyph.Height) then
                r.Top := r.Top + ((r.Bottom - r.Top) - FCheckTrueGlyph.Height) shr 1;
            vtaBottom: r.Top := r.Bottom - FCheckTrueGlyph.Height;
          end;

          r.Bottom := r.Top + FCheckTrueGlyph.Height;
          r.Left := r.Left + COLUMN_SPACING;
          r.Right := r.Left + FCheckTrueGlyph.Width;

          FCheckTrueGlyph.TransparentMode := tmAuto;
          FCheckTrueGlyph.Transparent := True;

          FCheckFalseGlyph.TransparentMode := tmAuto;
          FCheckFalseGlyph.Transparent := True;

          if Items[Index].Checked then
            Canvas.Draw(r.Left, r.Top, FCheckTrueGlyph)
          else
            Canvas.Draw(r.Left, r.Top, FCheckFalseGlyph);

          TmpRct.Left := TmpRct.Left + FCheckTrueGlyph.Width + 2 * COLUMN_SPACING;
        end
        else
        begin

          case VAlignment of
            vtaCenter: if (r.Bottom - r.Top > CHECKBOX_SIZE) then
                r.Top := r.Top + ((r.Bottom - r.Top) - CHECKBOX_SIZE) shr 1;
            vtaBottom: r.Top := r.Bottom - CHECKBOX_SIZE;
          end;

          r.Bottom := r.Top + CHECKBOX_SIZE;
          r.Left := r.Left + COLUMN_SPACING;
          r.Right := r.Left + CHECKBOX_SIZE;

          if Items[Index].Checked then
            DrawFrameControl(Canvas.Handle, r, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_FLAT or DFCS_CHECKED)
          else
            DrawFrameControl(Canvas.Handle, r, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_FLAT);

          TmpRct.Left := TmpRct.Left + CHECKBOX_SIZE + 2 * COLUMN_SPACING;
        end;
      end;
{$ENDIF}

      if (Items[Index].SubItems.Count > remapi) then
      begin
        if Assigned(SmallImages) then
        begin
          im := -1;
          ih := 0;
          if (remapi = -1) then
            im := Items[index].ImageIndex
          else
            if SubImages then
              im := GetSubItemImage(index, remapi);

          if (im >= 0) and (im < $FFFF) then
          begin
            case VAlignment of
              vtaTop: ih := Rect.top;
              vtaCenter: ih := Rect.top + ((rect.bottom - rect.top) - Smallimages.Height) div 2;
              vtaBottom: ih := Rect.bottom - smallimages.height;
            end;

            if (ih < 0) or (ih > ItemHeight) then
              ih := rect.top;
{$IFDEF DELPHI3_LVL}
            if CheckBoxes and (i = -1) then
              SmallImages.Draw(Canvas, Rect.Left + CHECKBOX_SIZE + 2 * COLUMN_SPACING, ih, im)
            else
{$ENDIF}
              SmallImages.Draw(Canvas, Rect.Left + COLUMN_SPACING, ih, im);


            iw := Smallimages.Width + COLUMN_SPACING;
          end;
        end;
      end;

      TmpRct.Left := TmpRct.Left + iw;

      dtp.cbSize := SizeOf(dtp);
      dtp.iTabLength := 0;
      dtp.iLeftMargin := 2;
      dtp.iRightMargin := 2;
      dtp.uiLengthDrawn := 0;

      DrwRect := TmpRct;
      if i = -1 then
        DrwRect.Left := DrwRect.Left + 16 * (ItemIndents[Index, 0]);

      if Pos('{\', s) = 1 then
        RTFPaint(Index, Remapi, Canvas, TmpRct)
      else
        if Pos('{|', s) = 1 then
          with FProgressSettings do
            DrawProgress(Canvas, TmpRct, ColorFrom,FontColorFrom,ColorTo,FontColorTo,StrToInt(copy(s,3,length(s))))
        else
        begin
          if TagPos > 0 then
          begin
            DrwRect.Left := DrwRect.Left + COLUMN_SPACING;

            HTMLDrawEx(Canvas, s, DrwRect, TImageList(SmallImages), 0, 0, -1, -1, 1, False, False, False, False, True, False, True, 0.0,
              FURLColor, clNone, clNone, clGray, Anchor, Stripped, FA, XSize, YSize, ml, hl, hr, FImageCache, FContainer);
          end
          else
            DrawTextEx(Canvas.Handle, PChar(s), Length(s), DrwRect,
              (DT_EXPANDTABS or DT_NOPREFIX or EndEllips[pos(#13, s) = 0] or DT_EDITCONTROL or WordWraps[FWordWrap]
              or fValign) or Alignments[self.Columns[parr[i + 1]].Alignment], @dtp);
        end;

      Canvas.Brush.Assign(OldBrush);
      Canvas.Font.Assign(OldFont);

    end; // end of for loop

    if FDetailView.Visible then
    begin
      Canvas.Font.Assign(FDetailView.Font);

      if odSelected in State then
        Canvas.Font.Color := SelectionTextColor;

      OrgRect.Right := TmpRct.Right;

      TmpRct := OrgRect;
      TmpRct.Top := TmpRct.Top + ItemHeight - FDetailView.Height;

      if FDetailView.SplitLine then
      begin
        Canvas.Pen.Color := clBlack;
        Canvas.MoveTo(TmpRct.Left, TmpRct.Top);
        Canvas.LineTo(TmpRct.Right, TmpRct.Top);
        TmpRct.Top := TmpRct.Top + 1;
      end;

      TmpRct.Left := TmpRct.Left + FDetailView.Indent;

      if FDetailView.Column = 0 then
      begin
        s := Items[Index].Caption;
      end
      else
      begin
        if (Items[Index].SubItems.Count >= FDetailView.Column) then
          s := Items[Index].SubItems[FDetailView.Column - 1]
        else
          s := '';
      end;

      if pos('</', s) > 0 then
      begin
        HTMLDrawEx(Canvas, s, TmpRct, TImagelist(SmallImages), 0, 0, -1, -1, 1, False, False, False, False, True, False, True, 0.0,
          FURLColor, clNone, clNone, clGray, Anchor, Stripped, FA, XSize, YSize, ml, hl, hr, FImageCache, FContainer);

      end
      else
      begin
        SetBkMode(Canvas.Handle, Transparent);
        DrawTextEx(Canvas.Handle, PChar(s), Length(s), TmpRct,
          (DT_EXPANDTABS or DT_NOPREFIX or DT_EDITCONTROL or DT_WORDBREAK), nil);
      end;
    end;

    Canvas.Font.Assign(FOldFont);
  end;

  if ((odFocused in State) and (odSelected in State)) and
    (GetFocus = Handle) then
  begin
    if not RowSelect then
    begin
      Orgrect.Left := ColOffset;
      Orgrect.Right := Orgrect.Left + Columns[RemapColIdx].Width;
    end;
    DrawFocusRect(Canvas.Handle, OrgRect)
  end;

  OldFont.Free;
  OldBrush.Free;

  if Assigned(FOnDrawItem) then
    FOnDrawItem(Self, FCanvas, Index, OrgRect, State);
end;

procedure TAdvListView.CNMeasureItem(var Message: TWMMeasureItem);
begin
  inherited;
  if (FItemHeight > 0) then
    Message.MeasureItemStruct.ItemHeight := FItemHeight;
end;

procedure TAdvListView.LeftClickCell(item, subitem: Integer);
begin
  if Assigned(OnLeftClickCell) then
    OnLeftClickCell(self, Item, SubItem);
end;

procedure TAdvListView.RightClickCell(item, subitem: Integer);
begin
  if Assigned(OnRightClickCell) then
    OnRightClickCell(self, Item, SubItem);
end;

procedure TAdvListView.CNNotify(var Message: TWMNotify);
var
  eh: THandle;
  r: TRect;
  s: string;
  buf: array[0..1024] of char;
  Allow: Boolean;

begin
  if Message.NMHdr^.Code <> LVN_ENDLABELEDIT then
    inherited;

  with Message.NMHdr^ do
    case code of
      NM_CLICK:
        with PNMListView(Pointer(Message.NMHdr))^ do LeftClickCell(iItem, iSubItem);
      NM_RCLICK:
        with PNMListView(Pointer(Message.NMHdr))^ do RightClickCell(iItem, iSubItem);

      LVN_BEGINLABELEDIT:
        begin
          if not FSubItemEdit then Exit;
          Allow := true;
          if Assigned(FCanEditCell) then
            FCanEditCell(self, FItemIndex, FColumnIndex, allow);
          if not Allow then
          begin
            Message.Result := 1;
            Exit;
          end;

          eh := SendMessage(Handle, LVM_GETEDITCONTROL, 0, 0);

          SetWindowLong(eh, GWL_STYLE, GetWindowLong(eh, GWL_STYLE) or ES_MULTILINE);

          wpOrigEditProc := SetWindowLong(eh, GWL_WNDPROC, longint(@EditSubclassProc));
          r := GetItemRect(FItemIndex, FColumnIndex);

          if FColumnIndex = 0 then
          begin
            if Assigned(SmallImages) then
            begin
              if Items[FItemIndex].ImageIndex >= 0 then
                r.Left := r.Left - 2
              else
                r.Left := r.Left - SmallImages.Width;
            end
            else
              r.Left := r.Left - 2;
          end;

          wpCoord := r;
          s := GetTextAtColRow(FColumnIndex, FItemIndex);
          SetWindowText(eh, pchar(s));
          FItemCaption := GetTextAtColRow(0, FItemIndex);
          FEditBusy := True;
        end;

      LVN_ENDLABELEDIT:
        begin
          if not FSubItemEdit then Exit;
          if not FEditBusy then Exit;
          eh := SendMessage(Handle, LVM_GETEDITCONTROL, 0, 0);
          GetWindowText(eh, buf, sizeof(buf));

          s := strpas(buf);

          if Assigned(OnEdited) then
            OnEdited(Self, Items[FItemIndex], s);

          SetWindowLong(eh, GWL_WNDPROC, wpOrigEditProc);
          SetTextAtColRow(FColumnIndex, FItemIndex, s);
          if (FColumnIndex > 0) then
            SetTextAtColRow(0, FItemIndex, FItemCaption);
          FEditBusy := False;
        end;

      LVN_ITEMCHANGED:
        begin
          with PNMListView(Pointer(Message.NMHdr))^ do
          begin
            FoldSelIdx := iItem;
            if (uNewState and LVIS_SELECTED <> 0) then SelectionChanged(iItem);
          end;
        end;
    end;
end;

procedure TAdvListView.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FReArrangeIndex := -1;
end;

procedure TAdvListView.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
{$IFDEF DELPHI5_LVL}
    State := TOwnerDrawState(LongRec(itemState).Lo);
{$ELSE}
    State := TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
{$ENDIF}

    FCanvas.Handle := hDC;
    FCanvas.Font.Assign(Font);
    FCanvas.Brush.Assign(Brush);
    
    if (Integer(itemID) >= 0) and (odSelected in State) then
    begin
      FCanvas.Brush.Color := SelectionColor;
      FCanvas.Font.Color := SelectionTextColor;
    end;

    if Integer(itemID) >= 0 then

      LVDrawItem(itemID, rcItem, State)
    else
      FCanvas.FillRect(rcItem);


    FCanvas.Handle := 0;
  end;
end;


procedure TAdvListView.WMSize(var Msg: TMessage);
var
  SortCol: Integer;
begin
  SortCol := FSortColumn;
  inherited;
  SetSortImage(SortCol);

  if ColumnSize.FStretch then
    StretchRightColumn;
end;

procedure TAdvListView.WMVScroll(var WMScroll: TWMScroll);
var
  s: string;
  r: TRect;
  pt: tpoint;
begin
  DefaultHandler(WMScroll);

  if not FWallpaper.Empty and
    (FWallpaper.height <> ItemHeight) then
    InvalidateRect(Handle, nil, True);

{$IFDEF DELPHI3_LVL}
  if not FScrollHint then Exit;
  if (wmScroll.scrollcode = SB_ENDSCROLL) then
    FScrollHintWnd.ReleaseHandle;

  if (wmScroll.scrollcode = SB_THUMBTRACK) then
  begin
    s := self.items[wmscroll.pos].caption;
    r := FScrollHintWnd.CalcHinTRect(100, s, nil);
    FScrollHintWnd.Caption := s;

    FScrollHintWnd.Color := application.HintColor;

    GetCursorPos(pt);
    r.Left := r.Left + pt.x + 10;
    r.Right := r.Right + pt.x + 10;
    r.Top := r.Top + pt.y;
    r.Bottom := r.Bottom + pt.y;
    FScrollHintWnd.ActivateHint(r, s);
  end;
{$ENDIF}
end;

procedure TAdvListView.WMLButtonUp(var Msg: TWMLButtonUp);
var
  targetindex, j: Integer;
begin
  inherited;

  if FReArrangeIndex <> -1 then
  begin
    if not GetIndexAtPoint(msg.xpos, msg.ypos, targetindex, j) then
      TargetIndex := -1;

    MoveItem(fReArrangeIndex, TargetIndex);

    FReArrangeIndex := -1;
  end;
end;

procedure TAdvListView.WMLButtonDown(var Msg: TWMLButtonDown);
var
  s: string;
  iItem, iSubItem: Integer;
  r, hr: TRect;
  anchor, stripped, fa: string;
  xsize, ysize, ml, hl: Integer;
  hdc: THandle;
  Canvas: TCanvas;
  tagpos: Integer;
  chk, handled: Boolean;

begin
  if not FEditBusy then
  begin
    if not GetIndexAtPoint(msg.xpos, msg.ypos, FItemIndex, FColumnIndex) then
    begin
      inherited;
      Exit;
    end;
  end;

{$IFDEF DELPHI3_LVL}
  chk := Items[FItemIndex].Checked;
{$ELSE}
  chk := False;
{$ENDIF}

  s := GetTextAtPoint(msg.xpos, msg.ypos);
  GetIndexAtPoint(msg.xpos, msg.ypos, iItem, iSubItem);

  TagPos := Pos('</', s);
  if TagPos > 0 then
  begin
    r := GetItemRect(iItem, iSubItem);
    hdc := GetDC(self.Handle);
    Canvas := TCanvas.Create;
    Canvas.Handle := hdc;
    r.left := r.left + 2;

    if not HTMLDrawEx(Canvas, s, r, TImageList(smallimages), msg.XPos, msg.YPos, -1, -1, 1, True, False, False, True, True, False, True, 0.0,
      FURLColor, clNone, clNone, clGray, Anchor, Stripped, FA, XSize, YSize, ml, hl, hr, FImageCache, FContainer) then
      Anchor := '';

    Canvas.Free;
    ReleaseDC(self.Handle, hdc);
    if Anchor <> '' then
    begin
      handled := False;
      if (pos('://', Anchor) > 0) then
      begin
        if Assigned(FOnURLClick) then
          FOnURLClick(Self, iItem, Anchor, Handled);
        if not Handled then
          ShellExecute(0, 'open', PChar(Anchor), nil, nil, SW_NORMAL)
      end
      else
        if Assigned(FAnchorClick) then
          FAnchorClick(self, Anchor);
    end;
  end;

  if FReArrangeItems then
  begin
    FReArrangeIndex := FItemIndex;
  end;

  if not (FSubItemEdit or FSubItemSelect) then
    FColumnIndex := 0;

  if FURLShow and (not CheckBoxes or (Msg.XPos > 14)) then
  begin
    s := GetTextAtPoint(msg.xpos, msg.ypos);
    if ((Pos('://', s) > 0) or (pos('mailto:', s) > 0)) and (TagPos = 0) then
    begin
      handled := False;
      if Assigned(FOnURLClick) then
        FOnURLClick(Self, FItemIndex, s, handled);
      if not handled then
        ShellExecute(Application.Handle, 'open', pchar(s), nil, nil, SW_NORMAL);
    end;
  end;

{$IFDEF DELPHI3_LVL}
  if Checkboxes and (Msg.XPos <= 14) and Ownerdraw then
  begin
    Items[FItemIndex].Checked := not Items[FItemIndex].Checked;
    if Assigned(FCheckboxClick) then
      FCheckboxClick(Self, FItemIndex, Items[FItemIndex].Checked);
    Msg.Result := 0;
    Exit;
  end;
{$ENDIF}

  inherited;

{$IFDEF DELPHI3_LVL}
  if (FItemIndex < Items.Count) and (Items.Count > 0) then
    if chk <> Items[FItemIndex].Checked then
      if Assigned(FCheckboxClick) then
        FCheckboxClick(self, FItemIndex, Items[FItemIndex].Checked);
{$ENDIF}

  GetIndexAtPoint(msg.xpos, msg.ypos, FItemIndex, FColumnIndex);
  if FSubItemEdit or FSubItemSelect then
    FocusRepaint;
end;

function TAdvListView.FocusRepaint: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Items.Count do
    if Items[i - 1].Focused then
    begin // force a single item repaint
      Result := i - 1;
      Items[i - 1].Selected := False;
      Items[i - 1].Selected := True;
    end;
end;

procedure TAdvListView.SetEditText(const AValue: string);
var
  eh: THandle;
begin
  eh := SendMessage(Handle, LVM_GETEDITCONTROL, 0, 0);
  SetWindowText(eh, pchar(AValue));
end;


procedure TAdvListView.StartEdit(Item, SubItem: Integer);
begin
  FItemIndex := Item;
  FColumnIndex := SubItem;
  ListView_EditLabel(Handle, Item);
end;

procedure TAdvListView.WMKeyDown(var Msg: TWMKeydown);
var
  f: Integer;
const
  vk_c = $43;
  vk_v = $56;
  vk_x = $58;

begin
  if FSubItemEdit or FSubItemSelect then
  begin
    if Msg.CharCode = VK_LEFT then
      if (FColumnIndex > 0) then dec(FColumnIndex);

    if msg.CharCode = VK_RIGHT then
      if fColumnIndex + 1 < Columns.Count then inc(FColumnIndex);

    if msg.charcode in [VK_LEFT, VK_RIGHT, VK_SPACE, VK_F2] then
    begin
      F := FocusRepaint;
      if ((Msg.CharCode = VK_SPACE) or (Msg.CharCode = VK_F2)) and FSubItemEdit then
      begin
        FItemIndex := f;
        ListView_EditLabel(Handle, f);
      end;
    end;
  end;

  if (Msg.CharCode = VK_SPACE) and CheckBoxes and not FSubItemEdit then
  begin
    if Assigned(FCheckboxClick) then
      FCheckboxClick(Self, FItemIndex, not Items[FItemIndex].Checked);
  end;

  if (msg.charcode = vk_x) and FClipboardEnable and
    (GetKeyState(vk_control) and $8000 = $8000) then
  begin
    CutToClipboard;
    Exit;
  end;

  if (msg.charcode = vk_v) and FClipboardEnable and
    (GetKeyState(vk_control) and $8000 = $8000) then
  begin
    PasteFromClipboard;
    Exit;
  end;

  if (msg.charcode = vk_c) and FClipboardEnable and
    (GetKeyState(vk_control) and $8000 = $8000) then
  begin
    CopySelectionToClipboard;
    Exit;
  end;

  if (msg.charcode = vk_insert) and FClipboardEnable and
    (GetKeyState(vk_control) and $8000 = $8000) then
  begin
    CopySelectionToClipboard;
    Exit;
  end;

  if (msg.charcode = vk_insert) and FClipboardEnable and
    (GetKeyState(vk_shift) and $8000 = $8000) then
  begin
    Pastefromclipboard;
    Exit;
  end;

  if (msg.charcode = vk_delete) and FClipboardEnable and
    (GetKeyState(vk_shift) and $8000 = $8000) then
  begin
    CutToClipboard;
    Exit;
  end;

  inherited;
end;

procedure TAdvListView.WMNotify(var Message: TWMNotify);
var
  FHeaderHandle: THandle;
  i: Integer;
begin
  inherited;
  
  FHeaderHandle := SendMessage(Handle, LVM_GETHEADER, 0, 0);

  with Message.NMHdr^ do
  begin
    if (hwndfrom = FHeaderHandle) then
    begin
      if (code = HDN_BEGINTRACK) or (code = HDN_BEGINTRACKW) then
      begin
        FHeaderTracking := True;
      end;

      if (code = HDN_ENDTRACK) or (code = HDN_ENDTRACKW) then
      begin
        FHeaderTracking := False;
        SetSortImage(SortColumn);
        SetHeaderOwnerDraw(FHeaderOwnerDraw);
      end;

      if (code = HDN_DIVIDERDBLCLICK) or
        (code = HDN_ITEMCHANGED) and not FHeaderTracking then
      begin
        FHeaderTracking := True;
        
        for i := 1 to Columns.Count do
          UpdateHeaderOD(i - 1);

        if FDetailView.Visible then
          Invalidate;

        SetSortImage(SortColumn);

        FHeaderTracking := False;
      end;

      if code = alvHDN_FILTERCHANGING then
      begin
        if Assigned(FFilterChange) then
          FFilterChange(Self, PNMListView(Pointer(Message.NMHdr))^.iItem);
      end;

      if code = alvHDN_FILTERBTNCLICK then
      begin
        if Assigned(FFilterBtnClick) then
          FFilterBtnClick(Self, PNMListView(Pointer(Message.NMHdr))^.iItem);
      end;
    end;

    if (hWndFrom = FHeaderHandle) and (code = HDN_ENDTRACK) then
    begin
      with PNMListView(Pointer(Message.NMHdr))^ do
      begin
        if (iItem - 1 = SortColumn) and (SortColumn <> -2) then
          SetSortImage(iItem);

        if iItem - 1 <> SortColumn then
          UpdateAlignment(iItem);

        if Assigned(FColumnSizeEvent) then
          FColumnSizeEvent(self, iItem);

        SetHeaderOwnerDraw(FHeaderOwnerDraw);
        SetSortImage(SortColumn);
        UpdateAlignment(iItem);
      end;
    end;
  end;
end;

procedure TAdvListView.UpdateHeaderOD(iItem: Integer);
var
  hHeader: THandle;
  hdi: THDItem;

begin
  if FHeaderOwnerDraw then
  begin
    hHeader := SendMessage(Handle, LVM_GETHEADER, 0, 0);
    hdi.mask := HDI_FORMAT;
    Header_GetItem(hHeader, iItem, hdi);
    hdi.mask := HDI_FORMAT;
    hdi.fmt := HDF_OWNERDRAW;
    Header_SetItem(hHeader, iItem, hdi);
  end
  else
  begin
    hHeader := SendMessage(self.Handle, LVM_GETHEADER, 0, 0);
    hdi.mask := HDI_FORMAT;
    Header_GetItem(hHeader, iItem, hdi);

    hdi.mask := HDI_FORMAT;
    hdi.fmt := HDF_STRING;

    {$IFDEF DELPHI4_LVL}
    if Assigned(HeaderImages) and SortShow and (iItem = SortColumn) then
      hdi.fmt := HDF_STRING or HDF_IMAGE;
    {$ENDIF}  

    Header_SetItem(hHeader, iItem, hdi);
  end;
end;

procedure TAdvListView.UpdateAlignment(iItem: Integer);
var
  lvcolumn: TLVColumn;
begin
  if Columns.Count > iItem then
  begin
    case Columns[iItem].Alignment of
      taLeftJustify: lvcolumn.fmt := LVCFMT_LEFT;
      taRightJustify: lvcolumn.fmt := LVCFMT_RIGHT;
      taCenter: lvcolumn.fmt := LVCFMT_CENTER;
    end;
    lvcolumn.mask := LVCF_FMT;
    SendMessage(Self.Handle, LVM_SETCOLUMN, iItem, longint(@lvcolumn));
  end;
end;

procedure TAdvListView.WMTimer(var Msg: TWMTimer);
var
  pt: TPoint;
  r, hr: TRect;
  hheader: THandle;
begin
  if msg.Timerid = FListTimerID then
  begin
    if FReArrangeIndex <> -1 then
    begin
      GetCursorPos(pt);
      pt := ScreenToclient(pt);
      r := GetclientRect;

      hHeader := SendMessage(self.Handle, LVM_GETHEADER, 0, 0);
      GetWindowRect(hHeader, hr);

      if (pt.y < r.top + FItemHeight + hr.bottom - hr.top) then
        SendMessage(self.Handle, WM_VSCROLL, MAKEWPARAM(SB_LINEUP, 0), 0);

      if (pt.y > r.bottom - FItemHeight) then
        SendMessage(self.Handle, WM_VSCROLL, MAKEWPARAM(SB_LINEDOWN, 0), 0);
    end;
    msg.Result := 0;
    Exit;
  end;
  inherited;
end;

constructor TAdvListView.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);

  FCanvas := TControlCanvas.Create;
  FOldfont := TFont.Create;
  FOldbrush := TBrush.Create;
  FDelimiter := #0;
  FInAnchor := True;
  FLastAnchor := '';
  FPrintSettings := TPrintSettings.Create;
  FHTMLSettings := THTMLSettings.Create;
  FDetailView := TDetails.Create(Self);
  FImageCache := THTMLPictureCache.Create;
{$IFDEF BACKGROUND}
  FBackGround := TBackGround.Create(self);
{$ENDIF}

  FProgressSettings := TProgressSettings.Create;

  FRichEdit := nil;

  FWallPaper := TBitmap.Create;
  FWallPaper.OnChange := WallPaperBitmapChange;

{$IFNDEF DELPHI4_LVL}
  FHeaderChangeLink := TChangeLink.Create;
{$ENDIF}

  FColumnSize := TColumnSize.Create(Self);
  FScrollHintWnd := THintWindow.Create(Self);
  FSortUpGlyph := TBitmap.Create;
  FSortDownGlyph := TBitmap.Create;
  FCheckTrueGlyph := TBitmap.Create;
  FCheckFalseGlyph := TBitmap.Create;

  FHeaderFont := TFont.Create;
  FDummyFont := TFont.Create;

  FHeaderFont.OnChange := HeaderFontChange;
  ShowHintAssigned := False;
  FSelectionColor := clHighLight;
  FSelectionTextColor := clHighlightText;
  FValign := DT_VCENTER;
  FComCtrlVersion := GetFileVersion(comctrl);

{$IFNDEF DELPHI4_LVL}
  FHeaderChangeLink.OnChange := HeaderListChange;
{$ENDIF}

  FURLColor := clBlue;

  FOldSortCol := -1;
  FSortColumn := -2;
  FItemHeight := 13;
  FColumnIndex := 0;
  FHeaderHeight := 13;

  FReArrangeIndex := -1;
  FListTimerID := -1;

  Screen.Cursors[crURLcursor] := LoadCursor(HInstance, PChar(crURLcursor));

  FUpdateCount := 0;

  FHeaderColor := clNone;
end;

procedure TAdvListView.BeginUpdate;
begin
  Inc(FUpdateCount);
  SendMessage(Handle, WM_SETREDRAW, Integer(false), 0);
  SendMessage(HeaderHandle, WM_SETREDRAW, Integer(false), 0);
end;

procedure TAdvListView.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
    begin
      SetHeaderOwnerDraw(HeaderOwnerDraw);
      Sendmessage(Handle, WM_SETREDRAW, integer(true), 0);
      Sendmessage(HeaderHandle, WM_SETREDRAW, integer(true), 0);
    end;
  end;
end;

procedure TAdvListView.CMHintShow(var Msg: TMessage);
{$IFNDEF DELPHI3_LVL}
type
  PHintInfo = ^THintInfo;
{$ENDIF}
var
  CanShow: Boolean;
  hi: PHintInfo;
{$IFNDEF DELPHI3_LVL}
  s: string;
{$ENDIF}

begin
  inherited;
  CanShow := True;
  hi := PHintInfo(Msg.LParam);
{$IFNDEF DELPHI3_LVL}
  s := self.Hint;
  ShowHintProc(s, CanShow, hi^);
{$ELSE}
  ShowHintProc(hi.HintStr, CanShow, hi^);
{$ENDIF}
  Msg.Result := Ord(not CanShow);
end;


procedure TAdvListView.HeaderFontChange(Sender: TObject);
var
  hHeader: THandle;
begin
  if not FHeaderOwnerDraw then
  begin
    hHeader := SendMessage(self.Handle, LVM_GETHEADER, 0, 0);
    SendMessage(hHeader, WM_SETFONT, WParam(FHeaderFont.Handle), makelparam(WORD(TRUE), 0));
    // Force full header repaint
    MoveWindow(hHeader, 0, 0, 0, 0, TRUE);
    // Force header update
    Width := Width + 1;
    Width := Width - 1;
  end;
end;

{$IFNDEF DELPHI4_LVL}
procedure TAdvListView.HeaderListChange(Sender: TObject);
var
  ImageHandle: HImageList;
begin
  if HandleAllocated then
  begin
    ImageHandle := TImageList(Sender).Handle;
    if (Sender = HeaderImages) then
      SetHeaderList(ImageHandle, TVSIL_NORMAL)
  end;
end;
{$ENDIF}

function TAdvListView.MapFontHeight(pointsize: Integer): Integer;
begin
  MapFontHeight := Round(pointsize * 254 / 72);
end;

function TAdvListView.MapFontSize(height: Integer): Integer;
begin
  MapFontSize := Round(height * 72 / 254);
end;

function TAdvListView.GetPrintColWidth(Acol: Integer): Integer;
begin
  if (ACol < MAX_COLUMNS) and (ACol >= 0) then
    Result := MaxWidths[acol]
  else
    Result := 0;
end;

function TAdvListView.GetPrintColOffset(Acol: Integer): Integer;
begin
  if (ACol < MAX_COLUMNS) and (ACol >= 0) then
    Result := Indents[ACol]
  else
    Result := 0;
end;

procedure TAdvListView.BuildPage(Canvas: tCanvas; preview: Boolean);
var
  i, j, m, tw, th, pagnum: Integer;
  yposprint: Integer;
  fntsize, lastrow: Integer;
  hfntsize, ffntsize: Integer;
  xsize, ysize: Integer;
  spacing: Integer;
  indent, topindent, footindent: Integer;
  AlignValue: TAlignment;
  fntvspace, fnthspace, fntlineheight: word;
  oldfont, newfont: TFont;
  oldbrush, newbrush: TBrush;
  totalwidth: Integer;
  headersize: Integer;
  footersize: Integer;
  startcol, endcol: Integer;
  spaceforcols, spaceforfixedcols: Integer;
  orgsize: Integer;
  forcednewpage: Boolean;
  allowfittopage: Boolean;
  scalefactor: double;
  resfactor: double;
  cbwidth: Integer;
  hdc: THandle;

 {-------------------------------------------------
  Get x,y dimensions of grid cell in Canvas mapmode
  -------------------------------------------------}
  function GetTextSize(itemindex, subitemindex: Integer): tpoint;
  var
    tmpstr, anchor, stripped, fa: string;
    r, hr: TRect;
    ml, hl: Integer;
    htmlsize: tpoint;

  begin
    tmpstr := GetTextAtColRow(subitemindex + 1, itemindex);

    if (pos('{\', tmpstr) > 0) then
    begin
      itemtorich(subitemindex, itemindex, richedit);
      tmpstr := richedit.text;
    end;
    if (pos('</', tmpstr) > 0) then
    begin
      FillChar(r, sizeof(r), 0);

      r.right := 1000;
      r.bottom := 1000;

      SetMapMode(Canvas.Handle, mm_text);
      Canvas.Font.Size := FPrintSettings.Font.Size;

      HTMLDrawEx(Canvas, tmpstr, r, TImageList(SmallImages), 0, 0, -1, -1, 1, False, True, False, True, True, False, True, 1.0,
        FURLColor, clNone, clNone, clGray, Anchor, Stripped, FA, Integer(htmlsize.x), Integer(htmlsize.y), ml, hl, hr, FImageCache, FContainer);

      // correct it for the new mapping mode
{$IFDEF TMSDEBUG}
      outputdebugstring(pchar('orig:' + inttostr(htmlsize.x)));
{$ENDIF}
      SetMapMode(Canvas.Handle, mm_lometric);
      dptolp(Canvas.Handle, htmlsize, 1);

{$IFDEF TMSDEBUG}
      outputdebugstring(pchar('->' + inttostr(htmlsize.x)));
{$ENDIF}

      Result.x := htmlsize.x;
      Result.y := -htmlsize.y;
      Exit;
    end;

    SetmapMode(Canvas.Handle, MM_LOMETRIC);
    Canvas.Font := FPrintSettings.Font;

    OldFont.Assign(Canvas.Font);
    NewFont.Assign(Canvas.Font);
    NewFont.Size := orgsize;
    QueryDrawProp(itemindex, subitemindex, [], oldbrush, newfont, tmpstr);
    Canvas.Font.Assign(newfont);
    Canvas.Font.Height := MapFontHeight(newfont.size);

    GetTextSize.x := Canvas.TextWidth(tmpstr) + cbwidth;
    GetTextSize.y := Canvas.TextHeight(tmpstr);

    Canvas.Font.Assign(OldFont);
  end;

  {-------------------------------------------------
   Calculate required column widths for all columns
   -------------------------------------------------}
  procedure CalculateWidths;
  var
    i, j: Integer;
  begin
    for j := 0 to Columns.Count - 1 do
      MaxWidths[j] := 0;

    //calculate all max. column widths
    for i := -1 to Items.Count - 1 do
    begin
      for j := 0 to Columns.Count - 1 do
      begin
        if FPrintSettings.FUseFixedWidth then
          tw := FPrintSettings.FFixedWidth
        else
          tw := GetTextSize(i, j - 1).x + fnthspace;
        if (tw > MaxWidths[j]) then
          MaxWidths[j] := tw;
      end;
    end;
  end;

  {-------------------------------------------------
   Calculate required row height
   -------------------------------------------------}
  function GetRowHeight(itemindex: Integer): Integer;
  var
    j, nh, mh: Integer;
  begin
    mh := 0;
    if FPrintSettings.UseFixedHeight then
      Result := FPrintSettings.FixedHeight
    else
    begin
      for j := 0 to Columns.Count - 1 do
      begin
        nh := GetTextSize(ItemIndex, j - 1).y;
        if (nh > mh) then
          mh := nh;
      end;
      Result := mh;
    end;
  end;

  {-------------------------------------------------
   Print a single row of the grid
   -------------------------------------------------}
  function BuildColumnsRow(ypos, col1, col2, itemindex, hght: Integer): Integer;
  var
    c: Integer;
    thm, tb: Integer;
    s: string;
    tr, tp, tg, hr: TRect;
    first: Integer;
    anchor, stripped, fa: string;
    xsize, ysize, ml, hl: Integer;
    mm: Integer;

  begin
    Result := 0;
    if Preview and (PagNum > 0) then
      Exit;

    FontScaleFactor := scalefactor;
    thm := GetRowHeight(itemindex);
    thm := thm + (thm shr 3);

    for c := col1 to col2 do
    begin
      //cn:=c;
      s := GetTextAtColRow(c, itemindex);

      Canvas.Font := FPrintSettings.Font;

      Oldbrush.assign(Canvas.Brush);
      Oldfont.assign(Canvas.Font);
      Newbrush.assign(Canvas.Brush);
      Newfont.assign(Canvas.Font); {copy everything except size, which is mapped into mm_lometric}
      Newfont.size := orgsize;
      QueryDrawProp(itemindex, c - 1, [], newbrush, newfont, s);

      Canvas.Brush.Assign(newbrush);
      Canvas.Font.Assign(newfont);
      Canvas.Font.Height := MapFontHeight(newfont.size);
      SetTextColor(Canvas.Handle, newfont.color);

      SetMapMode(Canvas.Handle, MM_LOMETRIC);

      AlignValue := columns[c].Alignment;

      //th:=Canvas.textheight('gh')+fPrintSettings.RowSpacing;
      tb := Canvas.TextWidth(s);

      first := fntvspace;

      tr.left := indents[c];
      tr.right := indents[c + 1];
      tr.top := ypos;
      tr.bottom := ypos - thm - 2 * first;

      Result := thm + 2 * first;

      tp := tr;

      if pos('{\', s) > 0 then
        RTFPaint(itemindex, c - 1, Canvas, tr)
      else
        if pos('</', s) > 0 then
        begin
          lptodp(Canvas.Handle, tr.topleft, 1);
          lptodp(Canvas.Handle, tr.bottomright, 1);
          mm := GetMapMode(Canvas.Handle);
          SetMapMode(Canvas.Handle, mm_text);
          Canvas.Font.size := fprintsettings.Font.size;
          HTMLDrawEx(Canvas, s, tr, timagelist(smallimages), 0, 0, -1, -1, 1, False, False, True, False, True, False, True, ResFactor,
            FURLColor, clNone, clNone, clGray, Anchor, Stripped, FA, XSize, YSize, ml, hl, hr, FImageCache, FContainer);
          SetMapMode(Canvas.Handle, mm);
        end
        else
        begin

          tp.top := ypos - first;
          tp.bottom := ypos - thm - first;

{$IFDEF DELPHI3_LVL}
          if (c = 0) and CheckBoxes and
            (Itemindex >= 0) and (ItemIndex < self.Items.Count) then
          begin
            tg := tp;
            tg.Right := tg.Left + cbwidth;
            tg.Bottom := tg.Top + cbwidth;

            if (self.Items[itemindex].Checked) then
              DrawFrameControl(Canvas.Handle, tg, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
            else
              DrawFrameControl(Canvas.Handle, tg, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_FLAT);

            tp.left := tp.left + cbwidth;
            tr.left := tr.left + cbwidth;
          end;
{$ENDIF}

          case AlignValue of
            taLeftJustify: tp.left := tp.left + fnthspace;
            taRightJustify: tp.left := tp.right - fnthspace - tb;
            taCenter: tp.left := tp.left + ((tp.right - tp.left - tb) shr 1);
          end;
          Canvas.TexTRect(tr, tp.left, tp.top, s);
        end;

      Canvas.Font.Assign(oldfont);
      Canvas.Brush.Assign(oldbrush);
    end;

    if (fprintsettings.fborders in [pbSingle, pbDouble, pbHorizontal]) then
    begin
      Canvas.moveto(indents[col1], ypos);
      Canvas.lineto(indents[col2 + 1], ypos);
    end;
    fontscalefactor := 1.0;
  end;

  procedure BuildHeader;
  var
    tl, tr, tc, bl, br, bc: string;

    function PagNumStr: string;
    begin
      PagNumStr := inttostr(pagnum + 1);
    end;

  begin
    tl := '';
    tr := '';
    tc := '';
    bl := '';
    br := '';
    bc := '';
    with fPrintSettings do
    begin
      case fTime of
        ppTopLeft: tl := formatdatetime('hh:nn', now) + ' ' + tl;
        ppTopRight: tr := tr + ' ' + formatdatetime('hh:nn', now);
        ppTopCenter: tc := tc + ' ' + formatdatetime('hh:nn', now);
        ppBottomLeft: bl := formatdatetime('hh:nn', now) + ' ' + bl;
        ppBottomRight: br := br + ' ' + formatdatetime('hh:nn', now);
        ppBottomCenter: bc := bc + ' ' + formatdatetime('hh:nn', now);
      end;
      case fDate of
        ppTopLeft: tl := formatdatetime(fDateFormat, now) + ' ' + tl;
        ppTopRight: tr := tr + ' ' + formatdatetime(fDateFormat, now);
        ppTopCenter: tc := tc + ' ' + formatdatetime(fDateFormat, now);
        ppBottomLeft: bl := formatdatetime(fDateFormat, now) + ' ' + bl;
        ppBottomRight: br := br + ' ' + formatdatetime(fDateFormat, now);
        ppBottomCenter: bc := bc + ' ' + formatdatetime(fDateFormat, now);
      end;
      case fPageNr of
        ppTopLeft: tl := fPagePrefix + ' ' + PagNumStr + ' ' + fPageSuffix + ' ' + tl;
        ppTopRight: tr := tr + ' ' + fPagePrefix + ' ' + PagNumStr + ' ' + fPageSuffix;
        ppTopCenter: tc := tc + ' ' + fPagePrefix + ' ' + PagNumStr + ' ' + fPageSuffix;
        ppBottomLeft: bl := fPagePrefix + ' ' + PagNumStr + ' ' + fPageSuffix + ' ' + bl;
        ppBottomRight: br := br + ' ' + fPagePrefix + ' ' + PagNumStr + ' ' + fPageSuffix;
        ppBottomCenter: bc := bc + ' ' + fPagePrefix + ' ' + PagNumStr + ' ' + fPageSuffix;
      end;
      case fTitle of
        ppTopLeft: tl := FTitleText + ' ' + tl;
        ppTopRight: tr := tr + ' ' + FTitleText;
        ppTopCenter: tc := tc + ' ' + FTitleText;
        ppBottomLeft: bl := FTitleText + ' ' + bl;
        ppBottomRight: br := br + ' ' + FTitleText;
        ppBottomCenter: bc := bc + ' ' + FTitleText;
      end;
    end;
    
{$IFDEF FREEWARE}
    if not preview then
      bc := bc + ' printed with demo version of ' + self.classname;
{$ENDIF}

    oldfont.assign(Canvas.Font);
    Canvas.Font.assign(fPrintSettings.HeaderFont);
    Canvas.Font.Height := MapFontHeight(Canvas.Font.size); {map into mm_lometric space}

    if (tl <> '') then Canvas.textout(indent, -headersize, tl);
    if (tr <> '') then Canvas.textout(xsize - Canvas.textwidth(tr) - 20 - fPrintSettings.RightSize, -headersize, tr);
    if (tc <> '') then Canvas.textout((xsize - Canvas.textwidth(tc)) shr 1, -headersize, tc);

    Canvas.Font.assign(fPrintSettings.FooterFont);
    Canvas.Font.Height := MapFontHeight(Canvas.Font.size); {map into mm_lometric space}

    if (bl <> '') then Canvas.textout(indent, ysize + ffntsize + fntvspace + footersize, bl);
    if (br <> '') then Canvas.textout(xsize - Canvas.textwidth(br) - 20 - fPrintSettings.RightSize, ysize + ffntsize + fntvspace + footersize, br);
    if (bc <> '') then Canvas.textout((xsize - Canvas.textwidth(bc)) shr 1, ysize + ffntsize + fntvspace + footersize, bc);

    Canvas.Font.assign(oldfont);
  end;

  procedure DrawBorderAround(startcol, endcol, yposprint: Integer);
  var
    k: Integer;
  begin
    if (fprintsettings.fborders in [pbSingle, pbDouble, pbHorizontal]) then
    begin
      Canvas.moveto(indents[startcol], yposprint + (fntvspace shr 1));
      Canvas.lineto(indents[endcol + 1], yposprint + (fntvspace shr 1));
    end;

    if (fprintsettings.fborders in [pbSingle, pbDouble, pbVertical]) then
    begin
      for k := startcol to endcol + 1 do
      begin
        Canvas.moveto(indents[k], -topindent);
        Canvas.lineto(indents[k], yposprint + (fntvspace shr 1));
      end;
    end;
  end;

  procedure StartNewPage;
  begin
    Printer.newpage;
    setmapmode(Canvas.Handle, MM_LOMETRIC);
    if assigned(FOnPrintPage) then
    begin
      FOnPrintPage(self, Canvas, pagnum, xsize, ysize);
    end;
  end;

begin
  FontScaleFactor := 1.0;

  SetMapMode(Canvas.Handle, MM_TEXT);

  try
    hdc := GetDC(Handle);
    ResFactor := GetDeviceCaps(Canvas.Handle, LOGPIXELSX) / GetDeviceCaps(hdc, LOGPIXELSX);
    Releasedc(Handle, hdc);
  except
    ResFactor := 0.0;
  end;

{$IFDEF TMSDEBUG}
  outputdebugstring(pchar(format('%.2f', [resfactor])));
{$ENDIF}

{$IFDEF DELPHI3_LVL}
  if CheckBoxes then
    cbwidth := Round(16 * ResFactor)
  else
    cbwidth := 0;
{$ELSE}
  cbwidth := 0;
{$ENDIF}

  SetMapMode(Canvas.Handle, MM_LOMETRIC);

  newfont := TFont.create;
  oldfont := TFont.create;
  newbrush := TBrush.create;
  oldbrush := TBrush.create;
  Canvas.pen.Color := clBlack;
  Canvas.pen.Style := fPrintSettings.fBorderStyle;
  if fPrintSettings.fBorders = pbDouble then Canvas.pen.width := 10 else Canvas.pen.width := 2;

  SetMapMode(Canvas.Handle, MM_LOMETRIC);

  Canvas.Font := fPrintSettings.HeaderFont;
  Canvas.Font.Height := MapFontHeight(Canvas.Font.size);
  hfntsize := Canvas.TextHeight('gh');

  Canvas.Font := fPrintSettings.FooterFont;
  Canvas.Font.Height := MapFontHeight(Canvas.Font.size);
  ffntsize := Canvas.TextHeight('gh');

  Canvas.Font := fPrintSettings.Font;
  orgsize := Canvas.Font.size;

  Canvas.Font.Height := MapFontHeight(Canvas.Font.size); {map into mm_lometric space}

  fntlineheight := Canvas.TextHeight('gh');

  fntsize := fntlineheight;

  fntvspace := fntsize shr 3;
  fnthspace := Canvas.textwidth('a'); {adapt for multiline}

  if not preview then
  begin
    xsize := Canvas.cliprect.right - Canvas.cliprect.left;
    ysize := Canvas.cliprect.bottom;
  end
  else
  begin {this is in other mapping mode !}
    xsize := round(254 / getdevicecaps(Canvas.Handle, LOGPIXELSX) * (prevrect.right - prevrect.Left));
    ysize := -round(254 / getdevicecaps(Canvas.Handle, LOGPIXELSY) * (prevrect.bottom - prevrect.top));
  end;

  indent := fPrintsettings.fLeftSize;

  if fPrintSettings.FUseFixedWidth then
    spacing := 0
  else
    spacing := fPrintSettings.ColumnSpacing + 20; {min. 2mm space}

  CalculateWidths;

   {total space req. for columns}
  totalwidth := 0;
  for j := 0 to columns.count - 1 do
  begin
    totalwidth := totalwidth + maxwidths[j] + spacing;
  end;

  scalefactor := 1.0;

  if (fPrintSettings.fFitToPage <> fpNever) then
  begin
    tw := (columns.count) * spacing;
    scalefactor := (xsize - FPrintSettings.FRightSize - FPrintSettings.FLeftSize - tw) / (totalwidth - tw);

    if (scalefactor > 1.0) and (fPrintSettings.fFitToPage = fpShrink) then fontscalefactor := 1.0;
    if (scalefactor < 1.0) and (fPrintSettings.fFitToPage = fpGrow) then fontscalefactor := 1.0;

    if (scalefactor <> 1.0) and (fPrintSettings.fFitToPage = fpCustom) then
    begin
      allowfittopage := true;
      if assigned(OnFitToPage) then
        OnFitToPage(self, scalefactor, allowfittopage);
      if not allowfittopage then scalefactor := 1.0;
    end;

    if (scalefactor <> 1.0) then
    begin
      for j := 0 to columns.count - 1 do
        maxwidths[j] := trunc(maxwidths[j] * scalefactor);
      totalwidth := 0;
        {recalculate total req. width}
      for j := 0 to columns.count - 1 do
      begin
        totalwidth := totalwidth + maxwidths[j] + spacing;
      end;
    end;
  end;

  if Assigned(FOnPrintSetColumnWidth) then
  begin
    for j := 0 to columns.count - 1 do
    begin
      FOnPrintSetColumnWidth(self, j, maxwidths[j]);
    end;
    totalwidth := 0;
    for j := 0 to columns.count - 1 do
    begin
      totalwidth := totalwidth + maxwidths[j] + spacing;
    end;
  end;

  startcol := 0;
  endcol := 0;
  pagnum := 0; {page counter}
  lastrow := -1;
  yposprint := 0;
  m := 0;

  while (endcol <= columns.count - 1) and ((pagnum = 0) or (preview = false)) do
  begin
      {calculate new endcol here}
    spaceforfixedcols := 0;

      {added fixed spaceforcols here if repeatfixedcols is set}

    spaceforcols := spaceforfixedcols;

    while (spaceforcols <= xsize - fPrintSettings.fRightSize) and (endcol <= columns.count - 1) do
    begin
      spaceforcols := spaceforcols + maxwidths[endcol] + spacing;
      if (spaceforcols <= xsize - fPrintSettings.fRightSize) then inc(endcol);
    end;

      {space for cols is the width of the printout}
    fPrintPageWidth := spaceforcols;

    if (endcol > columns.count - 1) then endcol := columns.count - 1;

    if not (spaceforcols <= xsize - fPrintSettings.fRightSize) then
    begin
      fPrintPageWidth := fPrintPageWidth - maxwidths[endcol] - spacing;
      dec(endcol);
    end;

    if fPrintSettings.fCentered then
    begin
      indents[startcol] := 0;
      indents[0] := 0;
    end
    else
    begin
      indents[startcol] := indent;
      indents[0] := indent;
    end;

    for j := startcol + 1 to endcol do
    begin
      indents[j] := indents[j - 1] + maxwidths[j - 1] + spacing;
    end;

    fPrintColStart := startcol;
    fPrintColEnd := endcol;

    indents[endcol + 1] := indents[endcol] + maxwidths[endcol] + spacing;

    if (fPrintSettings.fCentered) and (spaceforcols < xsize) then
    begin
      spaceforcols := (xsize - spaceforcols) shr 1;
      for j := startcol to endcol + 1 do
      begin
        indents[j] := indents[j] + spaceforcols;
      end;
    end;

       {add spacing if required for repeat fixed columns}

       {fixed columns}
    j := 0;
    topindent := 0; {reserve a line for header}

    headersize := fPrintSettings.FHeaderSize;
    footersize := fPrintSettings.FFooterSize;

    if (fPrintSettings.fTime in [ppTopLeft, ppTopCenter, ppTopRight]) or
      (fPrintSettings.fDate in [ppTopLeft, ppTopCenter, ppTopRight]) or
      (fPrintSettings.fPageNr in [ppTopLeft, ppTopCenter, ppTopRight]) or
      (fPrintSettings.fTitle in [ppTopLeft, ppTopCenter, ppTopRight]) then
    begin
      topindent := 1 * (hfntsize + fntvspace) + headersize;
    end
    else
    begin
      topindent := headersize;
    end;

    if (fPrintSettings.fTime in [ppBottomLeft, ppBottomCenter, ppBottomRight]) or
      (fPrintSettings.fDate in [ppBottomLeft, ppBottomCenter, ppBottomRight]) or
      (fPrintSettings.fPageNr in [ppBottomLeft, ppBottomCenter, ppBottomRight]) or
      (fPrintSettings.fTitle in [ppBottomLeft, ppBottomCenter, ppBottomRight]) then
    begin
      footindent := 2 * (ffntsize + fntvspace) + footersize;
    end
    else
      footindent := 1 * (ffntsize + fntvspace) + footersize;

    i := -1;

    if assigned(FOnPrintPage) then
    begin
      FOnPrintPage(self, Canvas, 0, xsize, ysize);
    end;

       {print all rows here}
    while (i < self.items.count) do
    begin
         {at start of page.. print header}
      if (j = 0) then
      begin
        yposprint := -topindent;
        BuildHeader;
      end;

      if (j = 0) and (i > 0) and
        (pagnum > 0) and
        (fPrintSettings.fRepeatHeaders) then
      begin
           {here headers are reprinted}
        th := BuildColumnsRow(yposprint, startcol, endcol, m, 0);
        yposprint := yposprint - th;
        inc(j);
      end;

      th := BuildColumnsRow(yposprint, startcol, endcol, i, 0);
      yposprint := yposprint - th;
      inc(i);
      inc(j);

      forcednewpage := false;

      if assigned(FOnPrintNewPage) then
      begin
        FOnPrintNewPage(self, i, forcednewpage);
      end;

      if ((yposprint - GetRowHeight(j) < ysize + footindent) and
        (i < self.items.count)) or
        (forcednewpage) then
      begin
        DrawBorderAround(startcol, endcol, yposprint);
        j := 0;
        lastrow := i;
        if not preview then StartNewPage;
        inc(pagnum);
      end;
    end;
    if (lastrow = -1) or ((i <> lastrow) and not preview) then
      DrawBorderAround(startcol, endcol, yposprint);
    startcol := endcol + 1;
    endcol := startcol;
    if (endcol <= columns.count - 1) and not preview then StartNewPage;
    inc(pagnum);

  end; {end of while endcol<fprinTRect.right}

  // free temporary font and brush objects
  newfont.Free;
  oldfont.Free;
  newbrush.Free;
  oldbrush.Free;
end;

procedure TAdvListView.Preview(Canvas: TCanvas; DisplayRect: TRect);
begin
  // everything in 0.1mm
  SetMapMode(Canvas.Handle, mm_lometric);
  PrevRect := DisplayRect;
  BuildPage(Canvas, true);
end;

procedure TAdvListView.Print;
begin
  with Printer do
  begin
    Orientation := FPrintSettings.Orientation;
    Title := FPrintSettings.JobName;
    BeginDoc;
    //everything in 0.1mm
    Setmapmode(Canvas.Handle, mm_lometric);
    BuildPage(Canvas, False);
    EndDoc;
  end;
end;

procedure TAdvListView.HilightInList(HiText: string; DoCase: Boolean);
var
  i, j: Integer;
begin
  Items.BeginUpdate;
  for i := 1 to Items.Count do
    with Items[i - 1] do
    begin
      Caption := Hilight(Caption, HiText, 'hi', DoCase);
      for j := 1 to SubItems.Count do
      begin
        SubItems[j - 1] := Hilight(SubItems[j - 1], HiText, 'hi', DoCase);
      end;
    end;
  Items.EndUpdate;
end;

procedure TAdvListView.UnHilightInList;
var
  i, j: Integer;
begin
  Items.BeginUpdate;
  for i := 1 to Items.Count do
    with Items[i - 1] do
    begin
      Caption := UnHilight(Caption, 'hi');
      for j := 1 to SubItems.Count do
      begin
        SubItems[j - 1] := UnHilight(SubItems[j - 1], 'hi');
      end;
    end;
  Items.EndUpdate;
end;

procedure TAdvListView.HilightInItem(ItemIndex: Integer; HiText: string; DoCase: Boolean);
var
  j: Integer;
begin
  if (ItemIndex < 0) or (ItemIndex >= Items.Count) then
    Exit;

  with Items[ItemIndex] do
  begin
    Caption := Hilight(Caption, HiText, 'hi', DoCase);
    for j := 1 to SubItems.Count do
    begin
      SubItems[j - 1] := Hilight(SubItems[j - 1], HiText, 'hi', DoCase);
    end;
  end;
end;

procedure TAdvListView.UnHilightInItem(ItemIndex: Integer);
var
  j: Integer;
begin
  if (ItemIndex < 0) or (ItemIndex >= Items.Count) then
    Exit;

  with Items[ItemIndex] do
  begin
    Caption := UnHilight(Caption, 'hi');
    for j := 1 to SubItems.Count do
    begin
      SubItems[j - 1] := UnHilight(SubItems[j - 1], 'hi');
    end;
  end;
end;

procedure TAdvListView.MarkInList(HiText: string; DoCase: Boolean);
var
  i, j: Integer;
begin
  Items.BeginUpdate;
  for i := 1 to Items.Count do
    with Items[i - 1] do
    begin
      Caption := Hilight(Caption, HiText, 'e', DoCase);
      for j := 1 to SubItems.Count do
      begin
        SubItems[j - 1] := Hilight(SubItems[j - 1], HiText, 'e', DoCase);
      end;
    end;
  Items.EndUpdate;
end;

procedure TAdvListView.UnMarkInList;
var
  i, j: Integer;
begin
  Items.BeginUpdate;
  for i := 1 to Items.Count do
    with Items[i - 1] do
    begin
      Caption := UnHilight(Caption, 'e');
      for j := 1 to SubItems.Count do
      begin
        SubItems[j - 1] := UnHilight(SubItems[j - 1], 'e');
      end;
    end;
  Items.EndUpdate;
end;

procedure TAdvListView.MarkInItem(ItemIndex: Integer; HiText: string; DoCase: Boolean);
var
  j: Integer;
begin
  if (ItemIndex < 0) or (ItemIndex >= Items.Count) then
    Exit;

  with Items[ItemIndex] do
  begin
    Caption := Hilight(Caption, HiText, 'e', DoCase);
    for j := 1 to SubItems.Count do
    begin
      SubItems[j - 1] := Hilight(SubItems[j - 1], HiText, 'e', DoCase);
    end;
  end;
end;


procedure TAdvListView.UnMarkInItem(ItemIndex: Integer);
var
  j: Integer;
begin
  if (ItemIndex < 0) or (ItemIndex >= Items.Count) then
    Exit;

  with Items[ItemIndex] do
  begin
    Caption := UnHilight(Caption, 'e');
    for j := 1 to SubItems.Count do
    begin
      SubItems[j - 1] := UnHilight(SubItems[j - 1], 'e');
    end;
  end;
end;


destructor TAdvListView.Destroy;
begin
  SaveColumnSizes;
  FCanvas.Free;
  FOldfont.Free;
  FOldbrush.Free;
  FPrintSettings.Free;
  FHTMLSettings.Free;
  FImageCache.Free;
  FDetailView.Free;
  //FRichEdit.Free;
  FScrollHintWnd.Free;
  FSortUpGlyph.Free;
  FSortDownGlyph.Free;
  FCheckTrueGlyph.Free;
  FCheckFalseGlyph.Free;
  FHeaderFont.Free;
  FDummyFont.Free;
  FColumnSize.Free;
  FProgressSettings.Free;
{$IFDEF BACKGROUND}
  FBackground.Free;
{$ENDIF}
  FWallpaper.Free;

{$IFNDEF DELPHI4_LVL}
  FHeaderChangeLink.Free;
{$ENDIF}

  inherited Destroy;
end;

procedure TAdvListView.ClearInit(r, c: Integer);
var
  lic: TListItem;
  i, j: Integer;
begin
  Items.Clear;
  {this is due to a Delphi 4 bug ! If rearrange is
   enabled, columns cannot be removed or a access violation happens}
  while Columns.Count < c do
    Columns.Add;

  for i := 0 to c - 1 do
    Columns[i].Caption := '';

  for i := 1 to r do
  begin
    lic := Items.Add;
    lic.ImageIndex := -1;
    for j := 0 to c - 1 do
    begin
      lic.SubItems.Add('');
      SubItemImages[i - 1, j] := -1;
    end;
  end;
end;

procedure TAdvListView.Clear;
{$IFDEF DELPHI4_LVL}
var
  c: Integer;
{$ENDIF}
begin
  Items.Clear;
{$IFDEF DELPHI4_LVL}
  for c := 1 to Columns.Count do
    Columns[c - 1].Caption := '';
{$ELSE}
  Columns.Clear;
{$ENDIF}

  { the column rearrange feature has a bug in Delphi 4 !!
  Columns.Free;
  Columns:=TListColumns.Create(self);
  }
end;

function TAdvListView.GetFilter(index: Integer; filtertype: Integer): string;
type
  pInteger = ^Integer;
var
  hHeader: THandle;
  hditem: ThdItemex;
  hdtextfilter: ThdTextFilter;
  filtr: array[0..255] of char;
begin
  hHeader := SendMessage(self.Handle, LVM_GETHEADER, 0, 0);

  hditem.mask := alvHDI_FILTER;
  hditem.hdtype := filtertype;
  hdtextfilter.pszText := @filtr;
  hdtextfilter.cchTextMax := 255;
  hditem.pvFilter := @hdTextFilter;
  SendMessage(hHeader, HDM_GETITEM, index, longint(@hdItem));

  if filtertype = alvHDFT_ISSTRING then
    Result := StrPas(hdtextfilter.pszText)
  else
    Result := inttostr(pInteger(hdItem.pvFilter)^);
end;

procedure TAdvListView.SetFilter(index, filtertype, ivalue: Integer; sValue: string);
var
  hHeader: THandle;
  hditem: Thditemex;
  hdtextfilter: Thdtextfilter;
  ifiltr: Integer;
begin
  hHeader := SendMessage(Handle, LVM_GETHEADER, 0, 0);
  hditem.mask := alvHDI_FILTER;
  hditem.hdtype := filtertype;
  ifiltr := ivalue;
  hdtextfilter.pszText := pchar(sValue);
  hdtextfilter.cchTextmax := 255;

  if filtertype = 1 then
    hditem.pvFilter := @ifiltr
  else
    hditem.pvFilter := @hdtextfilter;

  SendMessage(hHeader, HDM_SETITEM, index, longint(@hdItem));
end;

procedure TAdvListView.SetFilterBar(const Value: Boolean);
begin
  if Value = FFilterBar then
    Exit;

  FFilterBar := Value;

  if csLoading in ComponentState then
    Exit;

  ShowFilter(Value);
end;

procedure TAdvListView.ShowFilter(onoff: Boolean);
var
  hHeader: THandle;
  rstyle: Longint;
  layout: THDLayout;
  r: TRect;
  wp: TWindowPos;

begin
  hHeader := SendMessage(self.Handle, LVM_GETHEADER, 0, 0);

  rstyle := GetWindowLong(hHeader, GWL_STYLE);

  if onoff then
    rstyle := rstyle or alvHDS_FILTERBAR
  else
    rstyle := rstyle and (not alvHDS_FILTERBAR);

  SetWindowLong(hHeader, GWL_STYLE, rstyle);

  InvalidateRect(hHeader, nil, true);

  r.Top := 0;
  r.Left := 0;
  r.Bottom := 32;
  r.Right := Width;
  layout.Rect := @r;
  layout.WindowPos := @wp;
  Header_Layout(hHeader, @layout);

  Items.BeginUpdate;
  ItemHeight := ItemHeight + 1;
  ItemHeight := ItemHeight - 1;
  Items.EndUpdate;
end;


procedure TAdvListView.SetColumnIndex(const Value: Integer);
var
  li: TListItem;
begin
  FColumnIndex := Value;
  if Assigned(Selected) then
  begin
   li := Selected;
    Selected := nil;
    Selected := li;
  end;
end;

procedure TAdvListView.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  TempWidth: Integer;
  i: Integer;
  s: string;
  r: TRect;

begin
  inherited;
  Exit;

  if csLoading in ComponentState then
    Exit;

  if not ColumnSize.Stretch then
    Exit;

  if not Assigned(Columns) then
    Exit;

  if Columns.Count = 0 then
    Exit;

  r := GetClientRect;
  TempWidth := R.Right - R.Left;

  if Columns.Count = 1 then
  begin
    Columns[0].Width := TempWidth;
    UpdateHeaderOD(0);
    Exit;
  end;

  // Ensure that the list view always displays columns across the full
  // width because otherwise the header colour is not controllable
  try
    for i := 0 to Columns.Count - 2 do
    begin
      TempWidth := TempWidth - Columns[i].Width;
    end;

    if TempWidth < 0 then
      Exit;

    if Columns.Count - 1 > 0 then
    begin
      s := Columns[Columns.Count - 1].Caption;
      Columns[Columns.Count - 1].Caption := '';
      // MUST set the Width last
      Columns[Columns.Count - 1].Width := TempWidth - 2;
      Columns[Columns.Count - 1].Caption := s;

      UpdateHeaderOD(Columns.Count - 1);
    end;

  finally

  end;
end;


procedure TAdvListView.SetStretchColumn(const Value: Boolean);
begin
  ColumnSize.Stretch := Value;
  FStretchColumn := Value;
end;

function TAdvListView.HeaderHandle: THandle;
begin
  Result := SendMessage(Handle, LVM_GETHEADER, 0, 0);
end;

{ All IO methods }

procedure TAdvListView.SaveToXML(FileName: string; ListDescr, RecordDescr: string; FieldDescr: TStringList);
var
  i, j: Integer;
  f: TextFile;
  s: string;

begin
  AssignFile(f, filename);
{$I-}
  Rewrite(f);
{$I+}
  if IOResult <> 0 then
    raise EAdvListViewError.Create('Cannot create file ' + FileName);

  writeln(f, '<?xml version="1.0"?>');
  writeln(f, '<' + ListDescr + '>');

  for i := 1 to self.Items.Count do
  begin
    writeln(f, '<' + RecordDescr + '>');

    for j := 1 to self.Columns.Count do
    begin
      if j <= FieldDescr.Count then
        write(f, '<' + fielddescr.strings[j - 1] + '>')
      else
        write(f, '<FIELD' + inttostr(j - 1) + '>');

      if j = 1 then
        s := self.items[i - 1].caption
      else
        if (self.items[i - 1].subitems.Count > j - 2) then s := self.items[i - 1].subitems[j - 2];

      write(f, s);

      if j <= FieldDescr.Count then
        writeln(f, '</' + fielddescr.strings[j - 1] + '>')
      else
        writeln(f, '</FIELD' + inttostr(j - 1) + '>');
    end;
    writeln(f, '</' + RecordDescr + '>');
  end;

  writeln(f, '</' + ListDescr + '>');
  CloseFile(f);
end;


procedure TAdvListView.SaveToHTML(filename: string);
var
  i, j: Integer;
  s, al, ac, afs, afe, ass, ase: string;
  slist: TStringList;
  AlignValue: tAlignment;
  f, hdr: textfile;

const
  HexDigit: array[0..$F] of char = '0123456789ABCDEF';

  function MakeHex(l: longint): string;
  var
    lw, hw: word;
  begin
    lw := loword(l);
    hw := hiword(l);
    MakeHex := HexDigit[Lo(lw) shr 4] + HexDigit[Lo(lw) and $F] +
      HexDigit[Hi(lw) shr 4] + HexDigit[Hi(lw) and $F] +
      HexDigit[Lo(hw) shr 4] + HexDigit[Lo(hw) and $F];
  end;

  function MakeHREF(s: string): string;
  begin
    Result := s;
{$IFDEF WIN32}
    if not URLshow then Exit;
    if (pos('://', s) > 0) and (pos('</', s) = 0) then
    begin
      if not URLFull then
        Result := '<A HREF=' + s + '>' + copy(s, pos('://', s) + 3, 255) + '</A>'
      else
        Result := '<A HREF=' + s + '>' + s + '</A>';
    end;
    if (pos('mailto:', s) > 0) and (pos('</', s) = 0) then
    begin
      if not URLFull then
        Result := '<A HREF=' + s + '>' + copy(s, pos('mailto:', s) + 3, 255) + '</A>'
      else
        Result := '<A HREF=' + s + '>' + s + '</A>';
    end;
{$ENDIF}
  end;

begin
  if (Columns.Count <= 0) or (Items.Count <= 0) then
    Exit;

  sList := TStringList.Create;
  sList.Sorted := False;

  with SList do
  begin
    if FHTMLSettings.PrefixTag <> '' then
      Add(FHTMLSettings.PrefixTag);

    Add('<table border="' + IntToStr(FHTMLSettings.BorderSize) +
      '" cellspacing="' + IntToStr(FHTMLSettings.CellSpacing) +
      '" width="' + IntToStr(FHTMLSettings.Width) + '%">'); { begin the table }

    Add('<tr>');

    for i := 0 to Columns.Count - 1 do
    begin
      s := Column[i].Caption;
      if s = '' then s := '<BR>';
      al := '';

      if (s <> '') and (Columns[i].Alignment <> taLeftJustify) then
      begin
        AlignValue := Columns[i].Alignment;
        if AlignValue = taRightJustify then
          al := ' align="right"';
        if AlignValue = taCenter then
          al := ' align="center"';
      end;

      ac := '';
      afs := '';
      afe := '';
      if FHTMLSettings.SaveColor then
        ac := ' BGCOLOR="#' + makehex(GetSysColor(COLOR_ACTIVEBORDER)) + '"';
      Add('<td nowrap' + al + ac + '><B>' + s + '</B></td>');
    end;

    Add('</tr>');

    for i := 0 to Items.Count - 1 do
    begin
      al := ''; ac := ''; afs := ''; afe := ''; ass := ''; ase := '';
      Add('<tr>');
      s := Items[i].Caption;

      if (pos('{\', s) = 1) then
      begin
        ItemToRich(-1, i, RichEdit);
        s := RichEdit.Text;
      end;

      if s = '' then s := '<br>';
      s := MakeHREF(s);

      if (s <> '') and (Columns[0].Alignment <> taLeftJustify) then
      begin
        AlignValue := Columns[0].Alignment;
        if AlignValue = taRightJustify then
          al := ' align="right"';
        if AlignValue = taCenter then
          al := ' align="center"';
      end;

      FCanvas.Brush.color := $7FFFFFFF;
      FCanvas.Font.color := $7FFFFFFF;
      FCanvas.Font.style := [];

      QueryDrawProp(i, -1, [], FCanvas.Brush, FCanvas.Font, self.items[i].caption);

      if (Canvas.Brush.color <> $7FFFFFFF) and FHTMLSettings.SaveColor then
        ac := ' BGCOLOR="#' + makehex(longint(Canvas.Brush.color)) + '"';

      if (Canvas.Font.color <> $7FFFFFFF) and FHTMLSettings.SaveColor then
      begin
        afs := '<font color="#' + makehex(longint(FCanvas.Font.color)) + '">';
        afe := '</font>';
      end;

      if FHTMLSettings.SaveFonts then
      begin
        if (fsBold in FCanvas.Font.style) then
        begin
          ass := ass + '<B>';
          ase := ase + '</B>';
        end;
        if (fsItalic in FCanvas.Font.style) then
        begin
          ass := ass + '<I>';
          ase := '</I>' + ase;
        end;
        if (fsUnderline in FCanvas.Font.style) then
        begin
          ass := ass + '<U>';
          ase := '</U>' + ase;
        end;
      end;

      Add('<td nowrap' + al + ac + '>' + afs + ass + s + ase + afe + '</td>');

      if (Items[i].Subitems.Count > 0) then
      begin
        //for j:=0 to self.items[i].subitems.count-1 do
        for j := 0 to self.columns.Count - 2 do
        begin
          al := ''; ac := ''; afs := ''; afe := ''; ass := ''; ase := ''; s := '';
          if (Items[i].Subitems.Count > j) then
            s := Items[i].Subitems[j];

          if (pos('{\', s) = 1) then
          begin
            ItemToRich(j, i, richedit);
            s := richedit.text;
          end;

          s := MakeHREF(s);
          AlignValue := Columns[j + 1].Alignment;
          if (s <> '') and (AlignValue <> taLeftJustify) then
          begin
            if AlignValue = taRightJustify then
              al := ' align="right"';
            if AlignValue = taCenter then
              al := ' align="center"';
          end;

          FCanvas.Brush.Color := $7FFFFFFF;
          FCanvas.Font.Color := $7FFFFFFF;
          FCanvas.Font.Style := [];

          QueryDrawProp(i, j, [], FCanvas.Brush, FCanvas.Font, s);
          if s = '' then
            s := '<BR>';

          if (Canvas.Brush.color <> $7FFFFFFF) and FHTMLSettings.SaveColor then
            ac := ' BGCOLOR="#' + makehex(longint(Canvas.Brush.color)) + '"';

          if (Canvas.Font.color <> $7FFFFFFF) and FHTMLSettings.SaveColor then
          begin
            afs := '<font color="#' + makehex(longint(FCanvas.Font.color)) + '"';
            afs := afs + '>';
            afe := '</font>';
          end;

          if FHTMLSettings.SaveFonts then
          begin
            if (fsBold in FCanvas.Font.style) then
            begin
              ass := ass + '<B>';
              ase := ase + '</B>';
            end;
            if (fsItalic in FCanvas.Font.style) then
            begin
              ass := ass + '<I>';
              ase := '</I>' + ase;
            end;
            if (fsUnderline in FCanvas.Font.style) then
            begin
              ass := ass + '<U>';
              ase := '</U>' + ase;
            end;
          end;

          Add('<td nowrap' + al + ac + '>' + afs + ass + s + ase + afe + '</td>');
        end;
      end;
      Add('</tr>');
    end;

    Add('</table><p>');
    if FHTMLSettings.SuffixTag <> '' then
      Add(fHTMLSettings.SuffixTag);
  end;

  AssignFile(f, filename);
{$I-}
  Rewrite(f);
{$I+}
  if IOResult <> 0 then
  begin
    slist.free;
    raise EAdvListViewError.Create('File ' + FileName + ' not found');
  end;

  if FHTMLSettings.HeaderFile <> '' then
  begin
    AssignFile(hdr, fHTMLSettings.HeaderFile);
{$I-}
    Reset(hdr);
{$I+}
    if IOResult = 0 then
    begin
      while not eof(hdr) do
      begin
        readln(hdr, s);
        writeln(f, s);
      end;
      closefile(hdr);
    end;
  end;

  for i := 1 to slist.Count do
  begin
    writeln(f, slist.strings[i - 1]);
  end;

  if (FHTMLSettings.FooterFile <> '') then
  begin
    Assignfile(hdr, fHTMLSettings.FooterFile);
    {$I-}
    reset(hdr);
    {$I+}
    if IOResult = 0 then
    begin
      while not eof(hdr) do
      begin
        readln(hdr, s);
        writeln(f, s);
      end;
      closefile(hdr);
    end;
  end;

  CloseFile(f);
  slist.Free;
end;

procedure TAdvListView.SaveToASCII(FileName: string);
var
  s, z: Integer;
  cellstr, str, alistr, remainingstr: string;
  i: Integer;
  MultiLineList: TStringList;
  OutputFile: TextFile;
  anotherlinepos: Integer;
  blanksfiller: string;
  blankscount, NeededLines: Integer;
  AlignValue: TAlignment;
  colchars: array[0..MAX_COLUMNS] of byte;
  cells: string;
  lis: tlistitem;

  function MaxCharsInCol(acol: Integer): Integer;
  var
    i, k, res: Integer;
    s: string;
  begin
    res := 0;
    for i := 0 to self.items.count - 1 do
    begin
      lis := self.items[i];
      if acol = 0 then s := lis.caption else s := lis.subitems[acol - 1];
      k := length(s);
      if (k > res) then res := k;
    end;
    MaxCharsInCol := res;
  end;


begin
  Screen.Cursor := crHourGlass;
  AssignFile(OutputFile, FileName);
  Rewrite(OutputFile);

  for i := 0 to Columns.Count - 1 do
    ColChars[i] := MaxCharsIncol(i);

  try
    MultiLineList := TStringList.Create;
    for z := 0 to self.items.count - 1 do
    begin
      str := '';
      lis := self.items[z];
      for s := 0 to self.columns.count - 1 do
      begin
        if s = 0 then cells := lis.caption else cells := lis.subitems[s - 1];

        if (pos(#13#10, cells) > 0) then {Handle multiline cells}
        begin
          cellstr := copy(cells, 0, pos(#13#10, cells) - 1);
          remainingstr := copy(cells, pos(#13#10, cells) + 2, length(cells));
          NeededLines := 0;
          repeat
            inc(NeededLines);
            blanksfiller := '';
            blankscount := 0;

            if (MultiLineList.Count < NeededLines) then {we haven't already added a new line for an earlier colunn}
              MultiLineList.Add('');

            {nr of spaces before cell text}
            for i := 0 to s - 1 do
              blankscount := blankscount + ColChars[i] + 1;

            {add to line sufficient blanks}
            for i := 0 to (blankscount - length(MultiLineList[NeededLines - 1]) - 1) do blanksfiller := blanksfiller + ' ';

            MultiLineList[NeededLines - 1] := MultiLineList[NeededLines - 1] + blanksfiller;

            anotherlinepos := pos(#13#10, remainingstr);

            if anotherlinepos > 0 then
            begin
              alistr := copy(remainingstr, 0, anotherlinepos - 1);
              remainingstr := copy(remainingstr, pos(#13#10, remainingstr) + 2, length(remainingstr));
            end
            else
            begin
              alistr := remainingstr;
            end;

            AlignValue := self.Columns[s].Alignment;

            case AlignValue of
              taRightJustify: while (length(alistr) < colchars[s]) do alistr := ' ' + alistr;
              taCenter: while (length(alistr) < colchars[s]) do alistr := ' ' + alistr + ' ';
            end;
            MultiLineList[NeededLines - 1] := MultiLineList[NeededLines - 1] + alistr;

          until anotherlinepos = 0;
        end
        else
          if (pos(#13#10, cells) > 0) then cellstr := copy(cellstr, 0, pos(#13#10, cellstr) - 1);

        AlignValue := self.Columns[s].Alignment;

        case AlignValue of
          taRightJustify: while (length(cells) < colchars[s]) do cells := ' ' + cells;
          taCenter: while (length(cells) < colchars[s]) do cells := ' ' + cells + ' ';
        end;

        blanksfiller := '';
        blankscount := colchars[s];
        for i := 0 to (blankscount - length(cells)) do
          blanksfiller := blanksfiller + ' ';
        str := str + cells + blanksfiller;
      end; {column}

      Writeln(OutputFile, Str);
      for i := 0 to MultiLineList.Count - 1 do
        Writeln(OutputFile, MultiLineList[i]); {finally, add the extra lines for this row}
      MultiLineList.Clear;
    end; {row}
    MultiLineList.Free;
  finally
    CloseFile(OutputFile);
    Screen.Cursor := crDefault;
  end;
end;


procedure TAdvListView.LoadFromXLS(filename: string);
var
  FExcel: Variant;
  FWorkbook: Variant;
  FWorksheet: Variant;
  FArray: Variant;
  FCell: Variant;
  s, z: Integer;
  rangestr, CellText: string;
  startstr, endstr: string;
  code: Integer;
  sr, er, sc, ec: Integer;
  colcount, rowcount: Integer;
  lis: TListItem;
  ulc: Boolean;

begin
  Screen.Cursor := crHourGlass;

  try
    FExcel := CreateOleObject('excel.application');
  except
    Screen.Cursor := crDefault;
    raise EAdvListViewError.Create('Excel OLE server not found');
    Exit;
  end;

  FWorkBook := FExcel.WorkBooks.Open(Filename);

  FWorkSheet := FWorkBook.ActiveSheet;

  RangeStr := FWorkSheet.UsedRange.Address;

  // decode here how many cells are required, $A$1:$D$8 for example

  StartStr := '';
  EndStr := '';
  sr := -1; er := -1; sc := -1; ec := -1;

  Items.Clear;
  Columns.Clear;

  if (Pos(':', RangeStr) > 0) then
  begin
    StartStr := Copy(rangestr, 1, pos(':', rangestr) - 1);
    EndStr := Copy(rangestr, pos(':', rangestr) + 1, 255);

    if (pos('$', startstr) = 1) then system.delete(startstr, 1, 1);
    if (pos('$', endstr) = 1) then system.delete(endstr, 1, 1);

    ulc := not (Pos('$', startstr) > 0);

    if pos('$', startstr) > 0 then
      Val(copy(startstr, pos('$', startstr) + 1, 255), sr, code)
    else
      Val(startstr, sr, code);

    if (code <> 0) then sr := -1;

    if pos('$', endstr) > 0 then
      Val(copy(endstr, pos('$', endstr) + 1, 255), er, code)
    else
      Val(endstr, er, code);

    if (code <> 0) then er := -1;

    {now decode the columns}

    if ulc then
    begin
      sc := 1;
      ec := 256;
    end
    else
    begin
      if (pos('$', startstr) > 0) then startstr := copy(startstr, 1, pos('$', startstr) - 1);
      if (pos('$', endstr) > 0) then endstr := copy(endstr, 1, pos('$', endstr) - 1);

      if startstr <> '' then sc := ord(startstr[1]) - 64;
      if length(startstr) > 1 then sc := sc * 26 + ord(startstr[2]) - 64;

      if endstr <> '' then ec := ord(endstr[1]) - 64;
      if length(endstr) > 1 then ec := ec * 26 + ord(endstr[2]) - 64;
    end;
  end;

  ColCount := 1;
  RowCount := 1;

  if (sr <> -1) and (er <> -1) and (sc <> -1) and (ec <> -1) then
  begin
    ColCount := ec - sc + 1;
    RowCount := er - sr + 1;
  end;

  farray := VarArrayCreate([0, RowCount - 1, 0, ColCount - 1], varVariant);

  rangestr := 'A1:';

  if ColCount > 26 then
  begin
    RangeStr := RangeStr + chr(ord('A') - 1 + (ColCount div 26));
    RangeStr := RangeStr + chr(ord('A') - 1 + (ColCount mod 26));
  end
  else
    RangeStr := Rangestr + chr(ord('A') - 1 + ColCount);

  RangeStr := RangeStr + IntToStr(RowCount);

  try
    farray := FWorkSheet.Range[RangeStr].Value;

    Items.BeginUpdate;
    for z := 1 to RowCount do
    begin
      lis := Items.Add;
      for s := 1 to ColCount do
      begin
        FCell := farray[z, s];

        if not (VarType(fCell) in [varEmpty, varDispatch, varError]) then
          CellText := FCell
        else
          CellText := '';

        if (self.Columns.Count <= s) then
          self.Columns.Add;
        if s = 1 then
          lis.Caption := CellText
        else
          lis.SubItems.Add(Celltext);
      end;
    end;

    Items.EndUpdate;
  finally
    FWorkBook.Close(SaveChanges := false);
    FExcel.Quit;
    FExcel := UnAssigned;
    Screen.Cursor := crDefault;
  end;
end;

function TAdvListView.GetRichEdit: TAdvRichEdit;
begin
  if Assigned(FRichEdit) then
    Result := FRichEdit
  else
  begin
    FRichEdit := TAdvRichEdit.Create(Self);
    FRichEdit.Parent := Self;
    FRichEdit.Left := 0;
    FRichEdit.Width := 0;
    FRichEdit.Visible := False;
    FRichEdit.BorderStyle := bsNone;
    Result := FRichEdit;
  end;
end;

procedure TAdvListView.SavetoDOC(filename: string);
var
  fword: Variant;
  fdoc: Variant;
  ftable: Variant;
  frng: Variant;
  fcell: Variant;
  s, z: Integer;
  lis: TListItem;

begin
  try
    fword := CreateOLEObject('word.application');
  except
    raise Exception.Create('Word OLE server not found');
    Exit;
  end;

  {fword.visible:=false;}
  fdoc := fword.Documents.Add;
  frng := fdoc.Range(start := 0, end := 0);
  ftable := fdoc.Tables.Add(frng, numrows := items.Count, numcolumns := columns.count);

  for s := 1 to items.Count do
    for z := 1 to columns.count do
    begin
      lis := self.Items[s - 1];
      fcell := ftable.Cell(row := s, column := z);
      if z = 1 then
        fcell.Range.InsertAfter(lis.Caption)
      else
      begin
        if z - 2 < lis.subitems.Count then
          fcell.Range.InsertAfter(lis.subitems[z - 2]);
      end;

      case columns[z - 1].Alignment of
        taRightJustify: fcell.Range.ParagraphFormat.Alignment := wdAlignParagraphRight;
        taCenter: fcell.Range.ParagraphFormat.Alignment := wdAlignParagraphCenter;
      end;
      {
      .Bold = True
      .ParagraphFormat.Alignment = wdAlignParagraphCenter
      .Font.Name = "Arial"
       }
    end;

  fdoc.SaveAs(filename);
  fword.Quit;
  fword := unassigned;
end;


procedure TAdvListView.SavetoXLS(filename: string);
var
  fexcel: variant;
  fworkbook: variant;
  fworksheet: variant;
  farray: variant;
  s, z: Integer;
  rangestr: string[12];
  lis: tlistitem;

begin
  screen.cursor := crHourGlass;

  try
    FExcel := CreateOleObject('excel.application');
  except
    screen.cursor := crDefault;
    raise EAdvListViewError.Create('Excel OLE server not found');
    Exit;
  end;

  FWorkBook := FExcel.WorkBooks.Add;
  FWorkSheet := FWorkBook.WorkSheets.Add;

  farray := vararraycreate([0, self.items.count - 1, 0, self.columns.count - 1], varVariant);

  for s := 0 to self.items.count - 1 do
  begin
    lis := self.items[s];
    for z := 0 to self.columns.count - 1 do
    begin
      if z = 0 then farray[s, z] := lis.caption
      else
      begin
        if z - 1 >= lis.subitems.Count then
          farray[s, z] := ''
        else
          farray[s, z] := lis.subitems[z - 1];
      end;
    end;
  end;

  rangestr := 'A1:';

  if (self.Columns.count > 26) then
  begin
    rangestr := rangestr + chr(ord('A') - 1 + (self.columns.count div 26));
    rangestr := rangestr + chr(ord('A') - 1 + (self.columns.count mod 26));
  end
  else
    rangestr := rangestr + chr(ord('A') - 1 + self.columns.count);

  rangestr := rangestr + inttostr(self.items.count);

  FWorkSheet.Range[rangestr].Value := fArray;

  FWorkbook.SaveAs(filename);

  FExcel.Quit;
  FExcel := unassigned;

  screen.cursor := crDefault;
end;

procedure TAdvListView.SaveToFile(FileName: string);
var
  i, j, k: LongInt;
  ss: string;
  f: TextFile;
  colcount, rowcount: Integer;
  imidx: Integer;

begin
  AssignFile(f, FileName);
  Rewrite(f);

  colcount := self.columns.count;
  rowcount := self.Items.count;

  ss := IntToStr(ColCount) + ',' + IntToStr(RowCount);
  Writeln(f, ss);

  for i := 0 to colcount - 1 do
  begin
    ss := 'cw ' + inttostr(i) + ',' + inttostr(self.columns[i].width);
    Writeln(f, ss);
  end;

  k := 0;

  if fSaveHeader then
  begin
    for i := 0 to colcount - 1 do
    begin
      ss := self.columns[i].caption;
      if (ss <> '') then
      begin
        ss := IntToStr(i) + ',0,' + lftofile(ss);
        Writeln(f, ss);
      end;
    end;
    k := 1;
  end;

  for i := 0 to RowCount - 1 do
    for j := 0 to ColCount - 1 do
    begin
      ss := gettextatcolrow(j, i);

      if j = 0 then imidx := self.Items[i].imageindex else
        imidx := self.SubitemImages[i, j - 1];

      if (ss <> '') then
      begin
        ss := IntToStr(j) + ',' + IntToStr(i + k) + ',' + inttostr(imidx) + ',' + lftofile(ss);
        Writeln(f, ss);
      end;
    end;

  CloseFile(f);
end;

procedure TAdvListView.LoadFromFile(FileName: string);
var
  X, Y, CW, K: Integer;
  ss, ss1: string;
  f: TextFile;
  Colcount, Rowcount: Integer;
  imidx: Integer;

  function mStrToInt(s: string): Integer;
  var
    code, i: Integer;
  begin
    val(s, i, code);
    Result := i;
  end;

begin
  ColCount := 0;
  RowCount := 0;

  AssignFile(f, FileName);
  Reset(f);
  if (IOResult <> 0) then raise EAdvListViewError.Create('File ' + FileName + ' not found');

  Readln(f, ss);

  if (ss <> '') then
  begin
    ss1 := Copy(ss, 1, Pos(',', ss) - 1);
    ColCount := mStrToInt(ss1);
    ss1 := Copy(ss, Pos(',', ss) + 1, Length(ss));
    RowCount := mStrToInt(ss1);
  end;

  if (colcount = 0) or (rowcount = 0) then
  begin
    closefile(f);
    raise EAdvListViewError.Create('File contains no data or corrupt file ' + FileName);
  end;

  if FLoadHeader then K := 1 else K := 0;

  ClearInit(RowCount + k, ColCount);

  while not Eof(f) do
  begin
    Readln(f, ss);

    if pos('cw', ss) = 1 then
    begin
      ss1 := copy(ss, 4, pos(',', ss) - 4);
      ss := copy(ss, pos(',', ss) + 1, 255);
      CW := mstrtoint(ss1);
      if (cw >= 0) and (cw < colcount) then
        self.columns[cw].width := mstrtoint(ss);
    end
    else
    begin
      ss1 := Copy(ss, 1, Pos(',', ss) - 1);
      ss := Copy(ss, Pos(',', ss) + 1, Length(ss));
      X := mStrToInt(ss1);

      ss1 := Copy(ss, 1, Pos(',', ss) - 1);
      ss := Copy(ss, Pos(',', ss) + 1, Length(ss));
      Y := mStrToInt(ss1);

      ss1 := Copy(ss, 1, Pos(',', ss) - 1);
      ss := Copy(ss, Pos(',', ss) + 1, Length(ss));
      imidx := mStrToInt(ss1);

      if (imidx >= 0) and (subimages = false) then subimages := true;

      if FLoadHeader and (y = 0) then
        self.Columns[x].caption := filetolf(ss, false)
      else
      begin
        if (x = 0) then
          self.items[y - k].caption := filetolf(ss, false)
        else
          self.items[y - k].subitems[x - 1] := filetolf(ss, false);

        if (x = 0) then
          self.items[y - k].ImageIndex := imidx
        else
          self.SubItemImages[y - k, x - 1] := imidx;
      end;

    end;
  end;
  CloseFile(f);
end;

procedure TAdvListView.SaveToCSV(filename: string);
var
  f: textfile;
  i, j, r, c: Integer;
  s: string;
  fUsedDelimiter: char;

begin
  c := self.columns.count;
  r := self.items.count;

  if (c <= 0) then Exit;
  if (r <= 0) then Exit;

  if fDelimiter = #0 then fUsedDelimiter := ',' else fUsedDelimiter := fDelimiter;

  assignfile(f, filename);
  rewrite(f);

  if FSaveHeader then
  begin
    s := self.column[0].caption;
    for i := 1 to c - 1 do
    begin
      s := s + FUsedDelimiter + column[i].caption;
    end;
    writeln(f, s);
  end;

  for i := 0 to r - 1 do
  begin
    s := self.items[i].caption;
    for j := 0 to c - 1 do
    begin
      if (self.items[i].subitems.count > j) then s := s + FUsedDelimiter + self.items[i].subitems[j];
    end;
    writeln(f, s);
  end;
  closefile(f);
end;

procedure TAdvListView.LoadFromStream(stream: tstream);
var
  x, y: Integer;
  ss, ss1: string;
  colcount, rowcount: Integer;

  function readstring(var s: string): Integer;
  var
    c: char;
  begin
    c := '0';
    s := '';
    while (stream.position < stream.size) and (c <> #13) do
    begin
      stream.read(c, 1);
      if (c <> #13) then s := s + c;
    end;
    stream.read(c, 1); {read the #10 newline marker}
    readstring := length(s);
  end;

begin
  ColCount := 0; RowCount := 0;
  stream.position := 0;

  if (stream.position < stream.size) then
  begin
    if (Readstring(ss) > 0) then
    begin
      ss1 := Copy(ss, 1, Pos(',', ss) - 1);
      ColCount := StrToInt(ss1);
      ss1 := Copy(ss, Pos(',', ss) + 1, Length(ss));
      RowCount := StrToInt(ss1);
    end;
  end;

  if (ColCount = 0) or (RowCount = 0) then Exit;

  self.ClearInit(rowcount - 1, colcount);

  while (stream.position < stream.size) do
  begin
    ReadString(ss);
    ss1 := Copy(ss, 1, Pos(',', ss) - 1);
    ss := Copy(ss, Pos(',', ss) + 1, Length(ss));
    X := StrToInt(ss1);
    ss1 := Copy(ss, 1, Pos(',', ss) - 1);
    ss := Copy(ss, Pos(',', ss) + 1, Length(ss));
    Y := StrToInt(ss1);

    if (y = 0) then
      self.Columns[x].caption := filetolf(ss, false)
    else
    begin
      if (x = 0) then
        self.items[y - 1].caption := filetolf(ss, false)
      else
        self.items[y - 1].subitems[x - 1] := filetolf(ss, false);
    end;
  end;

end;

procedure TAdvListView.SaveToStream(stream: tstream);
var
  ss: string;
  i, j: Integer;

  procedure writestring(s: string);
  var
    buf: pchar;
    c: array[0..1] of char;
  begin
    getmem(buf, length(s) + 1);
    strplcopy(buf, s, length(s));
    stream.writebuffer(buf^, length(s));
    c[0] := #13;
    c[1] := #10;
    stream.writebuffer(c, 2);
    freemem(buf);
  end;

begin
  ss := IntToStr(self.columns.Count) + ',' + IntToStr(self.Items.Count + 1);

  Writestring(ss);

  for i := 0 to self.items.Count do
  begin
    for j := 0 to self.columns.count - 1 do
    begin
      if (i = 0) then
        ss := self.columns[j].caption
      else
      begin
        if (j = 0) then ss := self.items[i - 1].caption
        else ss := self.items[i - 1].subitems[j - 1];
      end;
      if (ss <> '') then
      begin
        ss := IntToStr(j) + ',' + IntToStr(i) + ',' + lftofile(ss);
        Writestring(ss);
      end;
    end;
  end;
end;

procedure TAdvListView.InsertFromCSV(FileName: string);
begin
  InputFromCSV(filename, true);
end;

procedure TAdvListView.LoadFromCSV(filename: string);
begin
  InputFromCSV(filename, false);
end;

procedure TAdvListView.InputFromCSV(filename: string; insertmode: Boolean);
var
  f: textfile;
  i, j, k, l: Integer;
  s, l1, l2: string;
  lis: tlistitem;
  lic: tlistcolumn;
  c1, c2, cm: Integer;
  fUsedDelimiter: char;

  function varpos(substr, s: string; var varpos: Integer): Integer;
  begin
    varpos := pos(substr, s);
    Result := varpos;
  end;

begin
  assignfile(f, filename);
{$I-}
  reset(f);
{$I+}
  if (ioResult <> 0) then
  begin
    raise EAdvListViewError.Create('File cannot be opened');
    Exit;
  end;

 {guess which CSV separator is used}
  if (fdelimiter = #0) then
  begin
    l2 := '';
    readln(f, l1);
    if not eof(f) then readln(f, l2);
    reset(f);
    cm := 0;
    for j := 1 to 5 do
    begin
      c1 := numsinglechar(CSVSeparators[j], l1);
      c2 := numsinglechar(CSVSeparators[j], l2);
      if (c1 = c2) and (c1 > cm) then
      begin
        fdelimiter := CSVSeparators[j];
        cm := c1;
      end;
    end;
  end;

  if (FDelimiter = #0) then FUsedDelimiter := ',' else FUsedDelimiter := FDelimiter;

  self.Items.BeginUpdate;

  if FLoadHeader and not insertmode then
  begin
    j := 0;
    Clear;
  end
  else j := 1;

  while not Eof(f) do
  begin
    ReadLn(f, s);
    if (j = 0) then
    begin
      i := 0;
      while (pos(FUsedDelimiter, s) > 0) do
      begin
        if (i < self.Columns.Count) then lic := self.columns[i]
        else lic := self.Columns.Add;

        if (s[1] = '"') then
        begin
          system.delete(s, 1, 1);

          k := singlepos('"', s);

          if (k > 0) then {search for next single quote}
          begin
            lic.caption := copy(s, 1, k - 1);
            system.delete(s, 1, k);
          end;
        end
        else
          lic.caption := copy(s, 1, pos(FUsedDelimiter, s) - 1);

        system.delete(s, 1, pos(FUsedDelimiter, s));
        inc(i);
      end;

      if (s <> '') then
      begin
        if (s[1] = '"') then system.delete(s, 1, 1);
        if (s[length(s)] = '"') then system.delete(s, length(s), 1);
      end;

      if (s <> '') then
      begin
        if (i < self.Columns.Count) then lic := self.columns[i]
        else lic := self.Columns.Add;
        lic.Caption := s;
      end;
    end
    else
    begin
      lis := self.Items.Add;
      lis.imageindex := -1;
      i := 0;

      while (VarPos(FUsedDelimiter, s, l) > 0) do
      begin
        if (s[1] = '"') then
        begin
          system.Delete(s, 1, 1);
          k := SinglePos('"', s);

          if (i = 0) then
            lis.Caption := Copy(s, 1, k - 1)
          else
            lis.Subitems.Add(Copy(s, 1, k - 1));

          system.Delete(s, 1, k);

          l := pos(FUsedDelimiter, s);
        end
        else
        begin
          if (i = 0) then
            lis.caption := copy(s, 1, l - 1)
          else
          begin
            if (i + 2 > self.columns.count) then
            begin
             {senddebug('extra col add '+inttostr(self.columns.count));}
              lic := Columns.Add;
              lic.Caption := '';
            end;
            lis.Subitems.Add(copy(s, 1, l - 1));
          end;
        end;

        Inc(i);
        system.Delete(s, 1, l);
      end;

      if (s <> '') then
      begin
        if (s[1] = '"') then system.delete(s, 1, 1);
        if (s[length(s)] = '"') then system.delete(s, length(s), 1);
        if (s = '') and (i > 0) then lis.subitems.add(s);
      end;

      if (s <> '') and (i > 0) then lis.subitems.add(s);
      if (s <> '') and (i = 0) then lis.caption := s;
    end;
    inc(j);
  end;

  CloseFile(f);
  Items.EndUpdate;
end;


{ Property method to get the extended style bits.}

function TAdvListView.GetExtendedStyles: TLVExtendedStyles;
begin
  Result := SetValueFromAPIValue(SendMessage(Handle, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0));
end;

{ Property method to set new style bits.}

procedure TAdvListView.SetExtendedStyles(Val: TLVExtendedStyles);
begin
  SendMessage(Handle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, SetValueToAPIValue(Val));
end;

function TAdvListView.SetValueToAPIValue(Styles: TLVExtendedStyles): LPARAM;
var
  x: TLVExtendedStyle;
begin
  Result := 0;
  { Check for each possible style. }
  for x := lvxGridLines to lvxTwoClickActivate do
    { If the style is set... }
    if x in Styles then
      { OR the appropriate value into the Result. }
      Result := Result or API_STYLES[x];
end;

{ Function to convert from the API values to our style set type.}

function TAdvListView.SetValueFromAPIValue(Styles: DWORD): TLVExtendedStyles;
var
  x: TLVExtendedStyle;
begin
  Result := [];
  { Check for each possible style. }
  for x := lvxGridLines to lvxTwoClickActivate do
    { If the style is set... }
    if (API_STYLES[x] and Styles) <> 0 then
      { OR the appropriate value into the Result. }
      Result := Result + [x];
end;

procedure TAdvListView.SetProgress(ItemIndex, SubItemindex, AValue: Integer);
begin
  SetTextAtColRow(SubItemIndex, ItemIndex, '{|' + IntToStr(AValue));
  {
  if SubItemIndex >= 0 then
    Items[ItemIndex].SubItems[SubItemIndex] := '{|' + IntToStr(AValue)
  else
    Items[ItemIndex].Caption := '{|' + IntToStr(AValue);
  }
end;

function TAdvListView.GetProgress(ItemIndex, SubItemindex: Integer): Integer;
var
  s: string;
begin
  s := GetTextAtColRow(SubItemIndex, ItemIndex);



//  if SubItemIndex >= 0 then
//    s := Items[ItemIndex].SubItems[SubItemIndex]
//  else
//    s := Items[ItemIndex].Caption;

  if pos('{|',s) = 0 then
    Result := 0
  else
    Result := StrToInt(copy(s,3,length(s)));
end;

procedure TAdvListView.SetSubItemImage(itemindex, subitemindex, AValue: Integer);
var
  Item: TLVItemEx;
begin
  Item.Mask := LVIF_IMAGE;
  Item.iItem := itemindex;
  Item.iSubItem := SubItemindex + 1;
  Item.iImage := AValue;
  SendMessage(Handle, LVM_SETITEM, itemindex, Longint(@Item));
end;

function TAdvListView.GetSubItemImage(itemindex, subitemindex: Integer): Integer;
var
  Item: TLVItemEx;
begin
  if not subimages then Result := -1 else
  begin
    Item.Mask := LVIF_IMAGE;
    Item.iItem := itemindex;
    Item.iSubItem := SubItemindex + 1;
    SendMessage(Handle, LVM_GETITEM, itemindex, Longint(@Item));
    Result := Item.iImage;
  end;
end;

procedure TAdvListView.SetItemIndent(itemindex, subitemindex, AValue: Integer);
var
  Item: TLVItemEx;
begin
  Item.Mask := LVIF_INDENT;
  Item.iItem := itemindex;
  Item.iSubItem := SubItemindex;
  Item.iIndent := AValue;
  SendMessage(Handle, LVM_SETITEM, itemindex, Longint(@Item));
end;

function TAdvListView.GetItemIndent(itemindex, subitemindex: Integer): Integer;
var
  Item: TLVItemEx;
begin
  Item.Mask := LVIF_INDENT;
  Item.iItem := ItemIndex;
  Item.iSubItem := SubItemindex;
  SendMessage(Handle, LVM_GETITEM, itemindex, Longint(@Item));
  Result := Item.iIndent;
end;

procedure TAdvListView.SetSortImage(AColumn: Integer);
var
  Item: THDItemEx;
  FHeaderHandle: THandle;
  i: Integer;
begin
  if (AColumn >= Columns.Count) or (AColumn < 0) then
    Exit;

  for i := 1 to Columns.Count do
    UpdateHeaderOD(i-1);

  if SortShow then
  begin
    if SortUpGlyph.Empty or SortDownGlyph.Empty then
    begin
      if Assigned(HeaderImages) then
      begin
        case SortDirection of
        sdAscending: ColumnImages[AColumn] := 0;
        sdDescending: ColumnImages[AColumn] := 1;
        end;
      end;
    end
    else
    begin
      FillChar(Item, SizeOf(Item), 0);

      Item.Mask := Item.Mask or (HDI_BITMAP) or (HDI_FORMAT);
      Item.Fmt := HDF_LEFT;
      case self.Columns.Items[acolumn].Alignment of
      taLeftJustify: Item.Fmt := HDF_LEFT;
      taRightJustify: Item.Fmt := HDF_RIGHT;
      taCenter: Item.Fmt := HDF_CENTER;
      end;

      if (FSortIndicator = siRight) then
        Item.fmt := Item.fmt or HDF_BITMAP_ON_RIGHT;

      if SortDirection = sdAscending then
        Item.Hbm := SortUpGlyph.Handle
      else
        Item.Hbm := SortDownGlyph.Handle;

      if FHeaderOwnerDraw then
      begin
        Item.Fmt := HDF_OWNERDRAW;
      end
      else
        Item.Fmt := Item.Fmt or HDF_BITMAP or HDF_STRING;

      FHeaderHandle := SendMessage(Handle, LVM_GETHEADER, 0, 0);
      SendMessage(FHeaderHandle, HDM_SETITEM, AColumn, Integer(@Item));
    end;
  end;  
end;


procedure TAdvListView.SetColumnImage(AColumn, AValue: Integer);
var
  Column: TLVColumnEx;
begin
  case Self.Columns.Items[AColumn].Alignment of
  taLeftJustify: Column.Fmt := LVCFMT_LEFT;
  taRightJustify: Column.Fmt := LVCFMT_RIGHT;
  taCenter: Column.Fmt := LVCFMT_CENTER;
  end;

  if (AValue >= 0) then
  begin
    Column.Fmt := Column.Fmt or LVCFMT_IMAGE;
    if (FSortIndicator = siRight) then
      Column.Fmt := Column.Fmt or HDF_BITMAP_ON_RIGHT;
  end;

  Column.Mask := LVCF_FMT;
  SendMessage(Handle, LVM_SETCOLUMN, AColumn, Longint(@column));

{$IFDEF DELPHI4_LVL}
  Columns.Items[AColumn].ImageIndex := AValue;
{$ENDIF}

  if Assigned(Headerimages) then
  begin
    if (AValue < HeaderImages.Count) and (AValue >= 0) then
    begin
      SetHeaderList(HeaderImages.Handle, LVSIL_SMALL);
      Column.Mask := LVCF_IMAGE;
      Column.iImage := AValue;
      SendMessage(Handle, LVM_SETCOLUMN, AColumn, Longint(@Column));
    end;
  end;

  UpdateHeaderOD(AColumn);
end;

function TAdvListView.GetColumnImage(AColumn: Integer): Integer;
var
  Column: TLVColumnEx;
begin
  Column.Mask := LVCF_IMAGE;
  if SendMessage(Handle, LVM_GETCOLUMN, AColumn, Longint(@Column)) > 0 then
    Result := Column.iImage
  else
    Result := -1;
end;


procedure TAdvListView.SetItemHeight(AValue: Integer);
begin
  if (AValue <> FItemHeight) and (AValue > 0) then
  begin
    FItemHeight := AValue;
    Height := Height + 1;
    Height := Height - 1;
  end;
end;


{$IFNDEF DELPHI4_LVL}
procedure TAdvListView.SetOwnerDraw(AValue: Boolean);
var
  l: Integer;
begin
  if AValue <> FNOwnerDraw then
  begin
    FNOwnerDraw := AValue;
    l := SendMessage(Handle, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0);
    ReCreatewnd;
    SendMessage(Handle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, l);
  end;
end;

procedure TAdvListView.SetFlatScrollBar(AValue: Boolean);
begin
  if AValue <> FFlatScrollBar then
  begin
    SetExtendedViewStyle(LVS_EX_FLATSB, AValue);
    FFlatScrollBar := AValue;
  end;
end;
{$ENDIF}

procedure TAdvListView.SetSubImages(AValue: Boolean);
begin
  if AValue <> FSubImages then
  begin
    SetExtendedViewStyle(LVS_EX_SUBITEMIMAGES, AValue);
    FSubImages := AValue;
  end;
end;

procedure TAdvListView.SetHeaderDragDrop(AValue: Boolean);
begin
  if AValue <> FHeaderDragDrop then
  begin
    SetExtendedViewStyle(LVS_EX_HEADERDRAGDROP, AValue);
    FHeaderDragDrop := AValue;
  end;
end;

procedure TAdvListView.SetHeaderHeight(AValue: Integer);
var
  hHeader: THandle;
begin
  FHeaderHeight := AValue;
  if FHeaderOwnerDraw then
  begin
    SetHeaderSize(FHeaderHeight);
    hHeader := SendMessage(Handle, LVM_GETHEADER, 0, 0);
    InvalidateRect(hHeader, nil, true);
  end;
end;

procedure TAdvListView.SetHeaderColor(AValue: TColor);
var
  hHeader: THandle;
begin
  FHeaderColor := AValue;
  hHeader := SendMessage(Handle, LVM_GETHEADER, 0, 0);
  InvalidateRect(hHeader, nil, true);
end;

procedure TAdvListView.SetHeaderOwnerDraw(AValue: Boolean);
var
  hHeader: THandle;
  hdi: THDItem;
  i: Integer;
  flg: Boolean;

begin
  if FHeaderUpdating then Exit;
  if FUpdateCount > 0 then Exit;

  if not AValue and FHeaderOwnerDraw then
  begin
    FHeaderOwnerDraw := AValue;
    HeaderFontChange(Self);
    Exit;
  end;

  FHeaderUpdating := True;
  FHeaderOwnerDraw := AValue;

  hHeader := SendMessage(self.Handle, LVM_GETHEADER, 0, 0);

  flg := False;

  for i := 1 to Columns.Count do
  begin
    if FHeaderOwnerDraw then
    begin
      //DbgInt('set ownerdraw',i);
      hdi.mask := HDI_FORMAT;
      Header_GetItem(hHeader, i - 1, hdi);
      hdi.mask := HDI_FORMAT;
      if hdi.fmt <> HDF_OWNERDRAW then
        Flg := True;
      hdi.fmt := HDF_OWNERDRAW;
      Header_SetItem(hHeader, i - 1, hdi);
    end
    else
    begin
      //DbgInt('set string',i);
      hdi.mask := HDI_FORMAT;
      Header_GetItem(hHeader, i - 1, hdi);
      hdi.mask := HDI_FORMAT;
      hdi.fmt := HDF_STRING;
      Header_SetItem(hHeader, i - 1, hdi);
    end;
  end;

  if FHeaderOwnerDraw then
  begin
    // forced repaint of header area
    if flg then MoveWindow(hHeader, 0, 0, 0, 0, True);
    SetHeaderHeight(FHeaderHeight);
  end
  else
  begin
    // use system font
    SendMessage(hHeader, WM_SETFONT, WParam(FHeaderFont.Handle), makelparam(WORD(TRUE), 0));
  end;

  FHeaderUpdating := False;
end;

procedure TAdvListView.SetHeaderFlatStyle(AValue: Boolean);
var
  hHeader: THandle;
  rStyle: Integer;
begin
  //get a Handle to the listview header component
  hHeader := SendMessage(self.Handle, LVM_GETHEADER, 0, 0);
  //retrieve the current style of the header
  rstyle := GetWindowLong(hHeader, GWL_STYLE);

  //set/toggle the hottrack style attribute
  if AValue then rstyle := rstyle and (not HDS_BUTTONS) else
    rstyle := rstyle or HDS_BUTTONS;

  //set the header style
  SetWindowLong(hHeader, GWL_STYLE, rstyle);

  //movewindow (hHeader,0,0, 200,30,true);
  FHeaderFlatStyle := AValue;
end;

procedure TAdvListView.SetHeaderHotTrack(AValue: Boolean);
var
  hHeader: tHandle;
  rStyle: Integer;
begin
  //get a Handle to the listview header component
  hHeader := SendMessage(self.Handle, LVM_GETHEADER, 0, 0);
  //retrieve the current style of the header
  rstyle := GetWindowLong(hHeader, GWL_STYLE);

  //set/toggle the hottrack style attribute
  if AValue then rstyle := rstyle or HDS_HOTTRACK else
    rstyle := rstyle and (not HDS_HOTTRACK);
  //set the header style
  SetWindowLong(hHeader, GWL_STYLE, rstyle);
  FHeaderHotTrack := AValue;
end;

procedure TAdvListView.SetSortShow(AValue: Boolean);
begin
  FSortShow := AValue;
  if not FSortShow then
  begin
    if (FSortColumn >= 0) and (FSortColumn < Columns.Count) then
      ColumnImages[FSortColumn] := -1;

    FSortColumn := Columns.Count + 1;
  end;
end;

procedure TAdvListView.SetContainer(AContainer: TPictureContainer);
begin
  FContainer := AContainer;
  Invalidate;
end;

procedure TAdvListView.DrawHeaderItem(DrawItemStruct: TDrawItemStruct);
var
  Canvas: TCanvas;
  s, anchor, stripped: string;
  ali: DWord;
  xsize, ysize, i: Integer;
  vcenter, iCount, ID: Integer;
  parr: array[0..LV_MAX_COLS] of Integer;
  nr: TRect;

  function Min(a, b: Integer): Integer;
  begin
    if a > b then
      Result := b
    else
      Result := a;
  end;

begin
  for iCount := 0 to LV_MAX_COLS do
    parr[iCount] := iCount;

  iCount := Columns.count;
  SendMessage(Handle, LVM_GETCOLUMNORDERARRAY, iCount, longint(@parr));

  Canvas := TCanvas.Create;

  with DrawItemStruct do
  begin
    if (Integer(itemID) < Columns.Count) then
    begin
      for i := 0 to Columns.Count - 1 do
        if parr[i] = integer(itemID) then
          s := Columns[i].Caption;

      Canvas.Handle := hDC;

      if HeaderColor <> clNone then
        Canvas.Brush.Color := HeaderColor
      else
        Canvas.Brush.Color := clBtnFace;

      Canvas.FillRect(rcItem);

      Canvas.Pen.Color := clGray;
      Canvas.Pen.Width := 1;
      Canvas.MoveTo(rcItem.Right-1,rcItem.Top);
      Canvas.LineTo(rcItem.Right-1,rcItem.Bottom);


      InflateRect(rcitem, -2, -1);

      if (Integer(itemID) = Columns.Count - 1) and (HeaderColor <> clNone) then
      begin
        nr := rcItem;
        nr.Left := nr.Right;
        nr.Right := Width;
        Canvas.Fillrect(nr);
      end;

      case Columns[itemID].Alignment of
        taLeftJustify: ali := DT_LEFT;
        taCenter: ali := DT_CENTER;
        taRightJustify: ali := DT_RIGHT;
      else
        ali := 0;
      end;

      {$IFDEF DELPHI4_LVL}
      if Assigned(HeaderImages) and (Columns[itemID].ImageIndex >= 0) and not SortShow then
      begin
        HeaderImages.Draw(Canvas, rcItem.Left, rcItem.Top, Columns[itemID].ImageIndex);
        rcItem.Left := rcItem.Left + 16;
      end;
      {$ENDIF}

      ID := ItemID;

      if (ID = SortColumn) and (SortColumn <> -2) and SortShow then
      begin
        if SortIndicator = siLeft then
          rcItem.Left := rcitem.Left + 16
        else
          rcItem.Right := rcItem.Right - 16;
      end;

      Canvas.Font.Assign(FHeaderFont);

      if (pos('</', s) > 0) then
      begin
        HTMLDraw(Canvas, s, rcItem, TImageList(SmallImages),
          0, 0, false, false, false, true, true, 0.0, FURLColor, anchor, stripped, xsize, ysize);
        if SortIndicator = siRight then
          rcItem.Right := Min(rcItem.Left + xsize, rcItem.Right);
      end
      else
      begin
        if (pos(#13, s) > 0) then
          DrawText(Canvas.Handle, pchar(s), length(s), rcItem, ali)
        else
          DrawTextEx(Canvas.Handle, pchar(s), length(s), rcItem, ali or DT_TOP or DT_SINGLELINE or DT_END_ELLIPSIS, nil);

        if SortIndicator = siRight then
          rcItem.Right := Min(rcItem.Left + Canvas.TextWidth(s), rcItem.Right);
      end;

      if SortIndicator = siLeft then
        rcItem.Left := rcitem.Left - 16
      else
        rcItem.Left := rcItem.Right;

      if (ID = SortColumn) and (SortColumn <> -2) and SortShow then
      begin
        if not SortDownGlyph.Empty and not SortUpGlyph.Empty then
        begin

          if SortDownGlyph.Height < HeaderHeight then
            vcenter := (HeaderHeight - SortDownGlyph.Height) shr 1
          else
            vcenter := 0;

          SortDownGlyph.TransparentMode := tmAuto;
          SortDownGlyph.Transparent := True;
          SortUpGlyph.TransparentMode := tmAuto;
          SortUpGlyph.Transparent := True;

          if SortDirection = sdAscending then
            Canvas.Draw(rcItem.Left, rcItem.Top + vcenter, SortDownGlyph)
          else
            Canvas.Draw(rcItem.Left, rcItem.Top + vcenter, SortUpGlyph);

          rcItem.Left := rcItem.Left + SortDownGlyph.Width + 2;

        end
        else
        begin

          if Assigned(HeaderImages) then
          begin
            if HeaderImages.Height < HeaderHeight then
              vcenter := (HeaderHeight - HeaderImages.Height) shr 1
            else
              vcenter := 0;

            if SortDirection = sdAscending then
              HeaderImages.Draw(Canvas, rcItem.Left, rcItem.Top + vcenter, 0)
            else
              HeaderImages.Draw(Canvas, rcItem.Left, rcItem.Top + vcenter, 1);

            rcItem.Left := rcItem.Left + HeaderImages.Width + 2;

          end;
        end;
      end;
    end;
  end;
  Canvas.Free;
end;


procedure TAdvListView.ReOrganize;
begin
  Height := Height + 1;
  Height := Height - 1;
end;

procedure TAdvListView.SetHeaderSize(AValue: Integer);
var
  hHeader: THandle;

begin
  if not FHeaderOwnerDraw then
    Exit;

  FHeaderSize := AValue;
  FDummyFont.Height := AValue;
  hHeader := SendMessage(Handle, LVM_GETHEADER, 0, 0);

  SendMessage(hHeader, WM_SETFONT, WParam(FDummyFont.Handle), makelparam(WORD(TRUE), 0));

  ReOrganize;
  Repaint;
end;

procedure TAdvListView.SetSortDirection(AValue: TSortDirection);
begin
  FSortDirection := AValue;
  if (FSortDirection = sdAscending) then
    FDirection := 1
  else
    FDirection := -1;
end;

procedure TAdvListView.SetSortColumn(AValue: Integer);
begin
  FSortColNum := AValue;
  FSortColumn := AValue;
  DoSort(AValue);
  SetSortImage(AValue);
end;

procedure TAdvListView.GetFormat(ACol: longint; var AStyle: TSortStyle; var aPrefix, aSuffix: string);
begin
  if Assigned(FOnGetFormat) then
    OnGetFormat(Self, FSortColNum, aStyle, aprefix, asuffix);
end;

procedure TAdvListView.CustCompare(ACol: longint; const str1, str2: string; var res: Integer);
begin
  Res := 1;
  if Assigned(FCustomCompare) then
    FCustomCompare(self, Acol, Str1, Str2, Res);
end;

procedure TAdvListView.RawCompare(ACol, ARow1, ARow2: longint; var res: Integer);
begin
  Res := 1;
  if Assigned(FRawCompare) then
    FRawCompare(self, Acol, ARow1, ARow2, res);
end;

procedure TAdvListView.Sort;
begin
  CustomSort(@__CustomSort, 0);
end;

procedure TAdvListView.SetHeaderFont(Value: TFont);
begin
  FHeaderFont.Assign(Value);
end;

procedure TAdvListView.SetHeaderList(Value: HImageList; Flags: Integer);
var
  hHeader: THandle;
begin
  { get Handle of header }
  hHeader := SendMessage(Handle, LVM_GETHEADER, 0, 0);
  Header_SetImageList(hHeader, Value, LVSIL_SMALL);
end;

procedure TAdvListView.SetHeaderImages(AValue: TImageList);
begin
{$IFNDEF DELPHI4_LVL}
  if (FHeaderImages <> nil) then
    HeaderImages.UnRegisterChanges(FHeaderChangeLink);
{$ENDIF}
  FHeaderImages := AValue;
  if (FHeaderImages <> nil) then
  begin
{$IFNDEF DELPHI4_LVL}
    HeaderImages.RegisterChanges(FHeaderChangeLink);
{$ENDIF}
    SetHeaderList(FHeaderImages.Handle, LVSIL_SMALL)
  end
  else
    SetHeaderList(0, LVSIL_SMALL);
end;

procedure TAdvListView.DestroyWnd;
begin
  if FListTimerID <> -1 then
    KillTimer(Handle, TimerID);
  FListTimerId := -1;
  inherited DestroyWnd;
end;

procedure TAdvListView.CreateWnd;
begin
  if not Assigned(Parent) then
    Exit;
  if not (Parent is TWinControl) then
    Exit;
  if not (Parent as TWinControl).HandleAllocated then
    Exit;

  inherited CreateWnd;

  if HeaderImages <> nil then
  begin
    if HeaderImages.HandleAllocated then
      SetHeaderList(HeaderImages.Handle, LVSIL_SMALL);
  end;

  FHoverTime := SendMessage(self.Handle, LVM_GETHOVERTIME, 0, 0);
  FFilterTimeOut := 500;

  if (FListTimerID = -1) then
    FListTimerid := SetTimer(Handle, TimerID, 300, nil);

  ItemHeight := FItemheight + 1;
  ItemHeight := FItemHeight - 1;
end;

procedure TAdvListView.DoSort(i: Integer);
begin
  //turn off current sort indicator
  if (i <> FOldSortCol) and (FOldSortCol >= 0) and FSortShow then
  begin
    Columnimages[FOldSortCol] := -1;
    UpdateAlignment(FOldSortCol);
  end;

  if i < Columns.Count then
  begin
    UpdateHeaderOD(FOldSortCol);

    FOldSortCol := i;
//    FSortColumn := i - 1;
    FSortColumn := i ;
    FSortColNum := i - 1;
    Sort;
    SetSortImage(FOldSortCol);
  end;

  FSortColumn := FOldSortCol;
  FSortColNum := FOldSortCol;

  if FSortShow then
    SetSortImage(FOldSortCol);
end;


procedure TAdvListView.ColClick(Column: TListColumn);
var
  Enable: Boolean;
begin
  if FSortShow then
  begin
    if (FOldSortCol = column.index) then
    begin
      if SortDirection = sdAscending then
        SortDirection := sdDescending
      else
        SortDirection := sdAscending;
    end;

    Enable := True;
    if Assigned(FSortStartEvent) then
      FSortStartEvent(self, column.index, enable);

    if Enable then
    begin
      DoSort(Column.Index);
      if Assigned(FSortDoneEvent) then
        FSortDoneEvent(self, column.index);
    end;
  end;
  inherited ColClick(Column);
end;

procedure TAdvListView.SetFilterTimeout(AValue: Integer);
var
  hdr: THandle;
begin
  hdr := SendMessage(Handle, LVM_GETHEADER, 0, 0);
  SendMessage(hdr, alvHDM_SETFILTERCHANGETIMEOUT, 0, AValue);
end;

procedure TAdvListView.SetHoverTime(AValue: Integer);
begin
  if AValue <> FHoverTime then
  begin
    FHoverTime := AValue;
    SendMessage(Handle, LVM_SETHOVERTIME, 0, AValue);
  end;
end;

procedure TAdvListView.SetExtendedViewStyle(astyle: Integer; AValue: Boolean);
begin
  if AValue then
    SendMessage(Handle, LVM_SETEXTENDEDLISTVIEWSTYLE, astyle, astyle)
  else
    SendMessage(Handle, LVM_SETEXTENDEDLISTVIEWSTYLE, astyle, 0)
end;

procedure TAdvListView.StretchRightColumn;
var
  i: Integer;
  r: TRect;
  TempWidth: Integer;

begin
  if Columns.Count = 0 then
    Exit;

  if not FColumnSize.FStretch then
    Exit;

 { colchgflg:=false; }
  if Columns.Count = 1 then
  begin
    Columns[0].Width := ClientRect.right;
    Exit;
  end;

  r := GetClientRect;
  TempWidth := r.Right - r.Left;

  for i := 0 to Columns.Count - 2 do
  begin
    TempWidth := TempWidth - Columns[i].Width;
  end;

  //get the scrollbar width here...

  if (TempWidth > 0) then
  begin

    if (VisibleItems < Items.Count) then
    begin
      Columns[Columns.Count - 1].Width := TempWidth - 1; // - GetSystemMetrics(SM_CXVSCROLL);
    end
    else
    begin
      Columns[Columns.Count - 1].Width := TempWidth - 1;
    end;
  end;
end;

procedure TAdvListView.AutoSizeColumn(i: Integer);
var
  j, mw, tw, th, im: Integer;
  s, stripped, anchor: string;
  r: TRect;

begin
  mw := 0;
  if self.Items.count <= 0 then
    Exit;
  FCanvas.Handle := GetDC(self.Handle);
  dec(i);

  for j := 0 to Items.Count - 1 do
  begin
    s := '';
    if i = -1 then
      s := Items[j].caption
    else
      if Items[j].SubItems.Count > i then
        s := Items[j].SubItems[i];

    if Pos('{\', s) > 0 then
    begin
      ItemToRich(i, j, richedit);
      s := RichEdit.Text;
    end;

    QueryDrawProp(j, i, [], FCanvas.Brush, FCanvas.Font, s);

    if Pos('</', s) > 0 then
    begin
      Fillchar(r, SizeOf(r), 0);
      r.Right := $FFFF;
      r.Bottom := $FFFF;
      HTMLDraw(FCanvas, s, r, TImageList(smallimages), 0, 0, false, false, false, true, true, 0.0, fURLColor, anchor, stripped, tw, th);
    end
    else
      tw := FCanvas.TextWidth(s);

    if Assigned(SmallImages) then
    begin
      if i = -1 then
        im := Items[j].Imageindex
      else
        im := GetSubItemImage(j, i);

      if im <> -1 then
        tw := tw + SmallImages.Width;
    end;

{$IFDEF DELPHI3_LVL}
    if (i = -1) and CheckBoxes then
      tw := tw + 16;
{$ENDIF}

    if tw > mw then
      mw := tw;
  end;

  ReleaseDC(self.Handle, FCanvas.Handle);
  Columns[i + 1].Width := mw + 10;
end;

procedure TAdvListView.AutoSizeColumns;
var
  i: Integer;
begin
  if Columns.Count <= 0 then
    Exit;
  LockWindowUpdate(self.Handle);
  for i := 0 to Columns.Count - 1 do
    AutoSizeColumn(i);
  Lockwindowupdate(0);
end;

procedure TAdvListview.LoadColumnSizes;
var
  inifile: TInifile;
  i, newwidth: Integer;

begin
  if (FColumnSize.Save) and
    (FColumnSize.Key <> '') and
    (FColumnSize.Section <> '') and
    (not (csDesigning in ComponentState)) then
  begin
    if FColumnSize.Storage = stInifile then
      Inifile := TInifile.Create(FColumnSize.Key)
    else
      Inifile := TInifile(TRegInifile.Create(FColumnSize.Key));

    with IniFile do
    begin
      for i := 0 to Columns.Count - 1 do
      begin
        newwidth := ReadInteger(FColumnSize.Section, 'col' + inttostr(i), -1);
        if newwidth <> -1 then
        begin
          Columns[i].Width := newwidth;
        end;
      end;
    end;
    Inifile.Free;
  end;
end;

procedure TAdvListview.SaveColumnSizes;
var
  inifile: TIniFile;
  i: Integer;

begin
  if (FColumnSize.Save) and
    (FColumnSize.Key <> '') and
    (FColumnSize.Section <> '') and
    (not (csDesigning in ComponentState)) then
  begin
    if FColumnSize.Storage = stInifile then
      Inifile := TInifile.Create(FColumnSize.Key)
    else
      Inifile := TInifile(TRegInifile.Create(FColumnSize.Key));

    with inifile do
    begin
      for i := 0 to self.columns.count - 1 do
      begin
        WriteInteger(FColumnSize.Section, 'col' + inttostr(i), self.columns[i].width);
      end;
    end;
    Inifile.Free;
  end;
end;

procedure TAdvListView.SelectItem(aIdx: Integer);
begin
  (Items[aIdx] as TListItem).Selected := True;
  (Items[aIdx] as TListItem).Focused := True;
  SendMessage(self.Handle, LVM_ENSUREVISIBLE, aIdx, 0);
end;

procedure TAdvListview.SwapItems(aIdx1, aIdx2: Integer);
var
  ListItem: TListItem;
  oldcheckbox: Boolean;
begin
{$IFDEF DELPHI3_LVL}
  OldCheckBox := CheckBoxes;
{$ENDIF}

  ListItem := TListItem.Create(Items);

  ListItem.Assign(Items[aidx1]);

  Items[aidx1].Assign(Items[aidx2]);
  Items[aidx2].Assign(ListItem);

  ListItem.Free;
{$IFDEF DELPHI3_LVL}
  Checkboxes := OldCheckBox;
{$ENDIF}
end;

procedure TAdvListview.MoveItem(aIdx1, aIdx2: Integer);
var
  listitem: TListItem;
  oldcheckbox: Boolean;
  sel: Boolean;

begin
  if (aIdx1 = aIdx2) or (aIdx1 = -1) then Exit;
{$IFDEF DELPHI3_LVL}
  oldcheckbox := checkboxes;
{$ENDIF}

  sel := (Items[aidx1] as TListItem).Selected;
  (Items[aidx1] as TListItem).Selected := false;
  ListItem := TListItem.Create(Items);

  ListItem.Assign(Items[aidx1]);

  Items.Delete(aidx1);

  if (aIdx2 = -1) then
  begin
    (Items.Add as TListItem).Assign(listitem);
    aIdx2 := self.Items.Count - 1;
  end
  else
    (Items.Insert(aIdx2) as TListItem).Assign(listitem);

  (Items[aidx2] as TListItem).Selected := sel;
  (Items[aidx2] as TListItem).Focused := true;

  ListItem.Free;

{$IFDEF DELPHI3_LVL}
  checkboxes := oldcheckbox;
{$ENDIF}

  Itemheight := 13;
end;

procedure TAdvListview.SwapColumns(aIdx1, aIdx2: Integer);
var
  iCount, j: Integer;
  parr: array[0..LV_MAX_COLS] of Integer;
begin
  iCount := Columns.Count;
  if aIdx1 > iCount then Exit;
  if aIdx2 > iCount then Exit;
  if aIdx1 = aIdx2 then Exit;
  if aIdx1 < 0 then Exit;
  if aIdx2 < 0 then Exit;

  if SendMessage(self.Handle, LVM_GETCOLUMNORDERARRAY, iCount, longint(@parr)) = 0 then
    Exit;

  j := parr[aIdx1];
  parr[aIdx1] := parr[aIdx2];
  parr[aIdx2] := j;

  SendMessage(self.Handle, LVM_SETCOLUMNORDERARRAY, iCount, longint(@parr));
  Repaint;
end;

procedure TAdvListview.MoveColumn(aIdx1, aIdx2: Integer);
var
  i, j, iCount: Integer;
  parr: array[0..LV_MAX_COLS] of Integer;
begin
  iCount := Columns.Count;
  if (aIdx1 > iCount) then Exit;
  if (aIdx2 > iCount) then Exit;
  if (aIdx1 = aIdx2) then Exit;
  if (aIdx1 < 0) then Exit;
  if (aIdx2 < 0) then Exit;

  if SendMessage(self.Handle, LVM_GETCOLUMNORDERARRAY, iCount, longint(@parr)) = 0 then
    Exit;

  j := parr[aIdx1];

  if aIdx1 < aIdx2 then
  begin
    for i := aIdx1 to aIdx2 - 1 do
    begin
      parr[i] := parr[i + 1];
    end;
    parr[aIdx2] := j;
  end;

  if aIdx1 > aIdx2 then
  begin
    for i := aIdx1 downto aIdx2 + 1 do
    begin
      parr[i] := parr[i - 1];
    end;
    parr[aIdx2] := j;
  end;

  SendMessage(Handle, LVM_SETCOLUMNORDERARRAY, iCount, longint(@parr));
  Repaint;
end;

procedure TAdvListView.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FHeaderImages) then
    FHeaderImages := nil;

  if (AOperation = opRemove) and (AComponent = FContainer) then
    FContainer := nil;
  inherited;
end;


procedure TAdvListview.WndProc(var Message: TMessage);
var
  ptr: ^tagNMHEADER;
  Allow: Boolean;
  ht: THDHitTestInfo;
  FHeaderHandle: THandle;

begin
  if (Message.Msg = WM_DESTROY) then
  begin
    if FListTimerID <> -1 then
      KillTimer(Handle, TimerID);
    FListTimerId := -1;

    if Assigned(FRichEdit) then
    begin
      FRichEdit.Free;
      FRichEdit := nil;
    end;
    
  end;

  if (Message.Msg = WM_DRAWITEM) then
  begin
    if (TWMDrawItem(Message).DrawItemStruct^.CtlType = ODT_HEADER) then
    begin
      DrawHeaderItem(TWMDrawItem(Message).DrawItemStruct^);
      Message.Result := 1;
      Exit;
    end;
  end;

  if (message.msg = WM_NOTIFY) then
  begin
    ptr := pointer(message.lparam);

    case ptr^.HDR.code of
      HDN_BEGINTRACK, HDN_BEGINTRACKW: if assigned(FStartColumnTrack) then
        begin
          Allow := true;
          FStartColumnTrack(self, ptr^.item, allow);
          if not Allow then
            Message.Result := 1
          else
            Message.Result := 0;
          Exit;
        end;
      HDN_ENDTRACK, HDN_ENDTRACKW:
        if Assigned(FEndColumnTrack) then
        begin
          FHeaderTracking := False;
          FEndColumnTrack(self, ptr^.item);
        end;
      NM_RCLICK:
        begin
          FHeaderHandle := SendMessage(self.Handle, LVM_GETHEADER, 0, 0);
          GetCursorPos(ht.point);
          ht.point := ScreenToClient(ht.point);
          ht.point.x := ht.point.x + GetScrollPos(self.Handle, SB_HORZ);
          SendMessage(FheaderHandle, HDM_HITTEST, 0, longint(@ht));
          if Assigned(FColumnRClickEvent) then
            FColumnRClickEvent(self, ht.Item);
        end;
    end;
  end;

  if (message.msg = WM_PAINT) then
  begin
    if ColumnSize.Stretch then
      StretchRightColumn;
  end;

  inherited;


end;


procedure TAdvListview.SelectionChanged;
begin
end;

procedure TAdvListview.Loaded;
var
  OrigOD: Boolean;
begin
  inherited Loaded;

  FOldCursor := Cursor;
  Height := Height + 1;
  Height := Height - 1;
  ViewStyle := vsReport;
  WallPaperChanged;
  // required for comctl 5+
  SendMessage(Handle, LVM_SETTOOLTIPS, 0, 0);
  SetHeaderHeight(FHeaderHeight);
  OrigOD := HeaderOwnerDraw;
  HeaderOwnerDraw := True;
//  ShowFilter(FFilterBar);
  UpdateAlignment(0);
  HeaderOwnerDraw := OrigOD;
end;

procedure TAdvListView.ShowHintProc(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var
  hintpos: TRect;
  iItem, iSubItem: Integer;
  tw: Integer;
  anchor, stripped, s: string;
  xsize, ysize: Integer;
  r: TRect;
begin
  if (Hintinfo.Hintcontrol = self) and (FAutoHint) then
  begin
    s := GetTextAtPoint(hintinfo.cursorpos.x, hintinfo.cursorpos.y);

    if (s <> '') then
    begin
      if GetIndexAtPoint(hintinfo.cursorpos.x, hintinfo.cursorpos.y, iItem, iSubItem) then
      begin
        ListView_GetSubItemRect(self.Handle, iItem, iSubItem, LVIR_LABEL, @hintpos);
        if iSubItem = 0 then hintpos.Left := 0;
        hintinfo.hintpos.x := hintpos.Left;
        hintinfo.hintpos.y := hintpos.Top;
        hintinfo.hintpos := ClientToScreen(hintinfo.hintpos);
      end;

      FLastHintPos := Point(iSubItem, iItem);

      FCanvas.Handle := getdc(self.Handle);

      QueryDrawProp(iItem, iSubItem, [], FCanvas.Brush, FCanvas.Font, s);

      if (pos('{\', s) = 1) then
      begin
        ItemToRich(iItem, isubitem - 1, FRichEdit);
        s := FRichEdit.text;
      end;

      if (pos('</', s) > 0) and not FHTMLHint then
      begin
        FillChar(r, SizeOf(r), 0);
        r.right := 1000;
        r.bottom := 1000;
        HTMLDraw(FCanvas, s, r, TImagelist(smallimages),
          0, 0, true, true, false, true, true, 0.0, fURLColor, anchor, stripped, xsize, ysize);
        s := Stripped;
      end;

      tw := FCanvas.textwidth(s);

      if iSubItem >= 0 then
        Canshow := tw + 4 > self.columns[iSubItem].width;

      hintstr := s;
    end;
  end;
end;

procedure TAdvListView.QueryDrawProp(item, subitem: Integer; AState: TOwnerDrawState;
  aBrush: TBrush; aFont: TFont; itemtext: string);
begin
  if Assigned(FOnDrawItemProp) then
    FOnDrawItemProp(self, item, subitem, aState, aBrush, aFont, itemtext);
end;

function TAdvListView.GetUpGlyph: TBitmap;
begin
  Result := FSortUpGlyph;
end;

procedure TAdvListView.SetUpGlyph(Value: TBitmap);
begin
  FSortUpGlyph.Assign(Value);
end;

function TAdvListView.GetDownGlyph: TBitmap;
begin
  Result := FSortDownGlyph;
end;

procedure TAdvListView.SetDownGlyph(Value: TBitmap);
begin
  FSortDownGlyph.Assign(Value);
end;

function TAdvListView.GetCheckFalseGlyph: TBitmap;
begin
  Result := FCheckFalseGlyph;
end;

procedure TAdvListView.SetCheckFalseGlyph(Value: TBitmap);
begin
  FCheckFalseGlyph.Assign(Value);
end;

function TAdvListView.GetCheckTrueGlyph: TBitmap;
begin
  Result := FCheckTrueGlyph;
end;

procedure TAdvListView.SetCheckTrueGlyph(Value: TBitmap);
begin
  FCheckTrueGlyph.Assign(Value);
end;


{$IFDEF BACKGROUND}
procedure TAdvListView.SetBackground(Value: TBackground);
begin
  FBackGround.Assign(Value);
end;
{$ENDIF}

procedure TAdvListView.SetWallpaper(Value: TBitmap);
begin
  FWallpaper.Assign(Value);
  WallPaperChanged;
end;

procedure TAdvRichEdit.SelNormal;
begin
  SelFormat(0);
end;

procedure TAdvRichEdit.SelSubscript;
begin
  SelFormat(-40);
end;

procedure TAdvRichEdit.SelSuperscript;
begin
  SelFormat(40);
end;

procedure TAdvRichEdit.SelFormat(offset: Integer);
var
  Format: TCharFormat; { defined in Unit RichEdit }
begin
  FillChar(Format, sizeof(Format), 0);
  with Format do
  begin
    cbSize := Sizeof(Format);
    dwMask := CFM_OFFSET;
    yOffset := offset; { superscript by 40 twips, negative values give subscripts}
  end;
  Perform(EM_SETCHARFORMAT, SCF_SELECTION, LongInt(@Format));
end;


procedure TAdvListView.WallPaperBitmapChange(Sender: TObject);
begin
  WallPaperChanged;
end;

procedure TAdvListView.WallpaperChanged;
begin
  Brush.Bitmap := nil;
  if (FWallpaper <> nil) and (not FWallpaper.Empty) then
  begin
    ListView_SetTextBkColor(Handle, $FFFFFFFF);
    Brush.Bitmap := FWallPaper;
  end
  else
  begin
    ListView_SetTextBkColor(Handle, ColorToRGB(Color));
    Brush.Color := Color;
  end;
  Invalidate;
end;

procedure TAdvListView.SetURLColor(AColor: TColor);
begin
  FURLColor := AColor;
  Invalidate;
end;

procedure TAdvListView.SetURLShow(AValue: Boolean);
begin
  FURLShow := AValue;
  Invalidate;
end;

procedure TAdvListView.SetURLFull(AValue: Boolean);
begin
  FURLFull := AValue;
  Invalidate;
end;

{ Clipboard functions }
procedure TAdvListView.CutToClipboard;
begin
  CopyFunc(true);
  CutFunc;
end;

procedure TAdvListView.CopyToClipBoard;
begin
  CopyFunc(False);
end;

procedure TAdvListView.CopySelectionToClipboard;
begin
  CopyFunc(True);
end;

procedure TAdvListView.PasteFromClipboard;
begin
  PasteFunc;
end;

procedure TAdvListView.CutFunc;
var
  i: Integer;
begin
  i := 0;
  while (i < Items.Count) do
  begin
    if Items[i].Selected then Items[i].Free else inc(i);
  end;
end;

procedure TAdvListView.PasteFunc;
var
  content: PChar;
  Data: THandle;
  endofrow: PChar;
  cr, tab: PChar;
  ct: string;
  s: Integer;
  numcells: Integer;
  lic: TListitem;

begin
  if not Clipboard.HasFormat(CF_TEXT) then Exit;

  Clipboard.Open;
  Data := GetClipboardData(CF_TEXT);
  try
    if (Data <> 0) then
      content := PChar(GlobalLock(Data))
    else
      content := nil
  finally
    if (Data <> 0) then
      GlobalUnlock(Data);

    ClipBoard.Close;
  end;

  if content = nil then Exit;

// Result:=self.PasteText(acol,arow,content);

  endofrow := StrScan(content, #0);

  if FSubItemSelect or FSubItemEdit then
  begin
    ct := StrPas(content);
    if FColumnIndex > 0 then
      Selected.SubItems[fColumnIndex - 1] := ct
    else
      Selected.Caption := ct;
    Exit;
  end;

  lic := nil;

  repeat
    cr := StrScan(content, #13);
    if (cr = nil) then
      cr := Endofrow
    else
    begin
      lic := Items.Add;
      lic.Imageindex := -1;
      lic.Selected := True;
    end;
    numcells := 0;
    s := 0;
    repeat
      tab := StrScan(content, #9);
      if (tab > cr) or (tab = nil) then tab := cr;

      ct := copy(StrPas(content), 1, tab - content);

      if numcells = 0 then
        lic.Caption := ct
      else
        lic.Subitems.Add(ct);
      inc(numcells);
      inc(s);
      if (s > self.Columns.Count) then self.columns.Add;
      content := tab + 1;
    until (Tab = Cr);

    inc(content); {delete cr marker}
    cr := StrScan(content, #13);
    if cr = nil then
      cr := Endofrow;

  until cr = endofrow;

  if Assigned(lic) then
  begin
    SendMessage(self.Handle, lvm_scroll, 0, $FFFF);
    lic.focused := true;
  end;
end;

procedure TAdvListView.CopyFunc(select: Boolean);
var
  len, i, j: Integer;
  buffer, ptr: PChar;
  ct: string;

begin
  // calculate required buffer space
  len := 1;
  buffer := nil;
  if (FSubitemselect or FSubItemEdit) and Assigned(Selected) then
  begin
    if FColumnIndex > 0 then
      ct := Selected.SubItems[FColumnIndex - 1]
    else
      ct := Selected.Caption;
  end
  else
  begin
    ct := '';
    for i := 1 to Items.Count do
    begin
      if Items[i - 1].Selected or not Select then
      begin
        ct := ct + Items[i - 1].Caption;
        for j := 1 to Items[i - 1].SubItems.Count do
          ct := ct + #9 + Items[i - 1].SubItems[j - 1];
        ct := ct + #13#10;
      end;
    end;
  end;

  try
    GetMem(buffer, length(ct) + 1);
    buffer^ := #0;
    ptr := buffer;
    ptr := StrEnd(StrPCopy(ptr, ct));
    ptr^ := #0;
    ClipBoard.SetTextBuf(buffer)
  finally
    FreeMem(buffer, len);
  end;
end;

function TAdvListView.GetVersionNr: Integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

function TAdvListView.GetVersionString: string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)))+' '+DATE_VER;
end;

function TAdvListView.GetVisibleItems: Integer;
begin
  Result := SendMessage(self.Handle, LVM_GETCOUNTPERPAGE, 0, 0);
end;

{ TDetails }

constructor TDetails.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner := AOwner as TAdvListView;
  FFont := TFont.Create;
  FFont.Color := clBlue;
  FFont.OnChange := FontChanged;
  Height := 16;
  Visible := False;
end;

destructor TDetails.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TDetails.FontChanged(Sender: TObject);
begin
  FOwner.Invalidate;
end;

procedure TDetails.SetColumn(AValue: Integer);
begin
  if (FColumn <> AValue) and (AValue >= 0) then
  begin
    FColumn := AValue;
    FOwner.Invalidate;
  end;
end;

procedure TDetails.SetFont(AValue: TFont);
begin
  FFont.Assign(AValue);
  FOwner.Invalidate;
end;

procedure TDetails.SetHeight(AValue: Integer);
begin
  if (FHeight <> AValue) and (AValue >= 0) then
  begin
    FHeight := AValue;
    FOwner.Invalidate;
  end;
end;

procedure TDetails.SetIndent(const Value: Integer);
begin
  if FIndent <> Value then
  begin
    FIndent := Value;
    FOwner.Invalidate;
  end;
end;

procedure TDetails.SetSplitLine(const Value: Boolean);
begin
  if FSplitLine <> Value then
  begin
    FSplitLine := Value;
    FOwner.Invalidate;
  end;
end;

procedure TDetails.SetVisible(AValue: Boolean);
begin
  if (FVisible <> AValue) then
  begin
    FVisible := AValue;
    FOwner.Invalidate;
  end;
end;

{$IFDEF BACKGROUND}
constructor TBackground.Create(AOwner: TAdvListView);
begin
  inherited Create;
  FListView := AOwner;
end;

procedure TBackGround.Assign(Source: TPersistent);
begin
  if Source is TBackGround then
  begin
    FFilename := TBackGround(Source).Filename;
    FTile := TBackGround(Source).Tile;
    FXOffsetPercent := TBackGround(Source).XOffsetPercent;
    FYOffsetPercent := TBackGround(Source).YOffsetPercent;
    ApplyToListView;
  end;
end;

procedure TBackGround.SetFilename(const Val: string);
begin
  if FFilename <> Val then
    FFilename := Val;
  ApplyToListView;
end;

procedure TBackGround.SetTile(Val: boolean);
begin
  if FTile <> Val then
    FTile := Val;
  ApplyToListView;
end;

procedure TBackGround.SetXOffsetPercent(Val: Integer);
begin
  if FXOffsetPercent <> Val then
    FXOffsetPercent := Val;
  ApplyToListView;
end;

procedure TBackGround.SetYOffsetPercent(Val: Integer);
begin
  if FYOffsetPercent <> Val then
    FYOffsetPercent := Val;
  ApplyToListView;
end;

procedure TBackGround.ApplyToListView;
var
  LVBkImg: TLVBkImage;
begin
  if assigned(FListView) and FListView.HandleAllocated then
  begin
    if FFilename <> '' then
      LVBkImg.ulFlags := LVBKIF_SOURCE_URL
    else
      LVBkImg.ulFlags := LVBKIF_SOURCE_NONE;
    if FTile then
      LVBkImg.ulFlags := LVBkImg.ulFlags or LVBKIF_STYLE_TILE
    else
      LVBkImg.ulFlags := LVBkImg.ulFlags or LVBKIF_STYLE_NORMAL;

    LVBkImg.hbm := 0;
    LVBkImg.pszImage := PChar(FFilename);
    LVBkImg.cchImageMax := Length(FFilename);
    LVBkImg.xOffsetPercent := FXOffsetPercent;
    LVBkImg.yOffsetPercent := FYOffsetPercent;
    ListView_SetTextBkColor(FListView.Handle, $FFFFFFFF);
    ListView_SetBkImage(FListView.Handle, @LVBkImg);
  end;
end;
{$ENDIF}



{ TProgressSettings }

procedure TProgressSettings.Assign(Source: TPersistent);
begin
  ColorTo := (Source as TProgressSettings).ColorTo;
  FontColorTo := (Source as TProgressSettings).FontColorTo;
  ColorFrom := (Source as TProgressSettings).ColorFrom;
  FontColorFrom := (Source as TProgressSettings).FontColorFrom;
end;

procedure TProgressSettings.Changed;
begin
  if Assigned(OnChange) then
    OnChange(Self);
end;

constructor TProgressSettings.Create;
begin
  inherited;
  FColorTo := clWhite;
  FFontColorTo := clGray;
  FColorFrom := clSilver;
  FFontColorFrom := clBlack;
end;

procedure TProgressSettings.SetColorFrom(const Value: TColor);
begin
  FColorFrom := Value;
  Changed;
end;

procedure TProgressSettings.SetColorTo(const Value: TColor);
begin
  FColorTo := Value;
  Changed;
end;

procedure TProgressSettings.SetFontColorFrom(const Value: TColor);
begin
  FFontColorFrom := Value;
  Changed;
end;

procedure TProgressSettings.SetFontColorTo(const Value: TColor);
begin
  FFontColorTo := Value;
  Changed;
end;

{$IFDEF BACKGROUND}
initialization
  OleInitialize(nil);

finalization
  OleUninitialize;
{$ENDIF}

end.
