{*************************************************************************}
{ TAdvPanel component                                                     }
{ for Delphi & C++Builder                                                 }
{ version 1.5                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{            copyright © 2000-2002                                        }
{            Email : info@tmssoftware.com                                 }
{            Website : http://www.tmssoftware.com/                        }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit AdvPanel;

{$I TMSDEFS.INC}

{$DEFINE REMOVESTRIP}
{$DEFINE REMOVEDRAW}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AdvImage, Inifiles, Registry, PictureContainer, APXPVS;

type
  TCustomAdvPanel = class;

  TAdvPanelStyler = class;

  TBackGroundPosition = (bpTopLeft,bpTopRight,bpBottomLeft,bpBottomRight,bpTiled,bpStretched,bpCenter);

  TTextVAlignment = (tvaTop,tvaCenter,tvaBottom);

  TAnchorEvent = procedure (Sender:TObject; Anchor:string) of object;

  TAnchorHintEvent = procedure (Sender:TObject;var Anchor:string) of object;

  TPanelPositionLocation = (clRegistry,clInifile);

  TPanelPosition = class(TPersistent)
  private
    FSave: Boolean;
    FKey : string;
    FSection : string;
    {$IFDEF DELPHI4_LVL}
    FLocation: TPanelPositionLocation;
    {$ENDIF}
    FOwner: TComponent;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Save: Boolean read FSave write FSave;
    property Key:string read FKey write FKey;
    property Section:string read FSection write FSection;
    {$IFDEF DELPHI4_LVL}
    property Location:TPanelPositionLocation read FLocation write FLocation;
    {$ENDIF}
  end;

  TShadeType =(	stNormal, stNoise, stDiagShade, stHShade, stVShade, stHBump, stVBump,
                stSoftBump, stHardBump, stLMetal, stRMetal, stIRadial, stORadial,
                stHShadeInv, stVShadeInv, stXPCaption, stBitmap, stBitmapRStretch, stBitmapLStretch);

  TCaptionShape = (csRectangle,csRounded,csSemiRounded);

  TCaptionButtonPosition = (cbpRight,cbpLeft);

  TPanelCaption = class(TPersistent)
  private
    FHeight: integer;
    FText: string;
    FColor: TColor;
    FFont: TFont;
    FVisible: boolean;
    FCloseButton: boolean;
    FMinMaxButton: boolean;
    FMinMaxButtonColor: TColor;
    FCloseButtonColor: TColor;
    FMinGlyph: TBitmap;
    FCloseMinGlyph: TBitmap;
    FCloseMaxGlyph: TBitmap;
    FMaxGlyph: TBitmap;
    FCloseColor: TColor;
    FShadeLight: Integer;
    FShadeGrain: Byte;
    FShadeType: TShadeType;
    FShape: TCaptionShape;
    FFlat: Boolean;
    FBackground: TBitmap;
    FIndent: Integer;
    FTop: Integer;
    FbuttonPosition: TCaptionButtonPosition;
    FColorTo: TColor;
    FOnChange: TNotifyEvent;
    FOnShadeChange: TNotifyEvent;
    FOnStateChange: TNotifyEvent;
    procedure SetColor(const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure SetHeight(const Value: integer);
    procedure SetText(const Value: string);
    procedure SetVisible(const Value: boolean);
    procedure SetCloseButton(const Value: boolean);
    procedure SetMinMaxButton(const Value: boolean);
    procedure SetCloseButtonColor(const Value: TColor);
    procedure SetMinMaxButtonColor(const Value: TColor);
    procedure FontChanged(Sender: TObject);
    procedure SetCloseColor(const Value: TColor);
    procedure SetMaxGlyph(const Value: TBitmap);
    procedure SetMinGlyph(const Value: TBitmap);
    procedure SetCloseMaxGlyph(const Value: TBitmap);
    procedure SetCloseMinGlyph(const Value: TBitmap);
    procedure SetShadeLight(const Value: Integer);
    procedure SetShadeGrain(const Value: Byte);
    procedure SetShadeType(const Value: TShadeType);
    procedure SetCaptionShape(const Value: TCaptionShape);
    procedure SetFlat(const Value: Boolean);
    procedure SetBackground(const Value: TBitmap);
    procedure SetIndent(const Value: Integer);
    procedure SetTopIndent(const Value: Integer);
    procedure SetColorTo(const Value: TColor);
    procedure Changed;
    procedure StateChanged;
    procedure ShadeChanged;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Background: TBitmap read FBackground write SetBackground;
    property ButtonPosition: TCaptionButtonPosition read FbuttonPosition write FButtonPosition;
    property Color: TColor read FColor write SetColor;
    property ColorTo: TColor read FColorTo write SetColorTo;
    property CloseColor: TColor read FCloseColor write SetCloseColor;
    property CloseButton: Boolean read fCloseButton write SetCloseButton;
    property CloseButtonColor: TColor read fCloseButtonColor write SetCloseButtonColor;
    property CloseMinGlyph: TBitmap read FCloseMinGlyph write SetCloseMinGlyph;
    property CloseMaxGlyph: TBitmap read FCloseMaxGlyph write SetCloseMaxGlyph;
    property Flat: Boolean read FFlat write SetFlat;
    property Font: TFont read FFont write SetFont;
    property Height: Integer read FHeight write SetHeight;
    property Indent: Integer read FIndent write SetIndent;
    property MaxGlyph: TBitmap read FMaxGlyph write SetMaxGlyph;
    property MinGlyph: TBitmap read FMinGlyph write SetMinGlyph;
    property MinMaxButton: Boolean read FMinMaxButton write SetMinMaxButton;
    property MinMaxButtonColor: TColor read FMinMaxButtonColor write SetMinMaxButtonColor;
    property ShadeLight: Integer read FShadeLight write SetShadeLight;
    property ShadeGrain: Byte read FShadeGrain write SetShadeGrain;
    property ShadeType: TShadeType read FShadeType write SetShadeType;
    property Shape: TCaptionShape read FShape write SetCaptionShape;
    property Text: string read FText write SetText;
    property TopIndent: Integer read FTop write SetTopIndent;
    property Visible: Boolean read FVisible write SetVisible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnStateChange: TNotifyEvent read FOnStateChange write FOnStateChange;
    property OnShadeChange: TNotifyEvent read FOnShadeChange write FOnShadeChange;
  end;

  TAutoSize = class(TPersistent)
  private
    FOwner: TCustomAdvPanel;
    FHeight: Boolean;
    FWidth: Boolean;
    FEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
  public
    constructor Create(AOwner: TCustomAdvPanel);
    procedure Assign(Source: TPersistent); override;
  published
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Height: Boolean read FHeight write FHeight;
    property Width: Boolean read FWidth write FWidth;
  end;

  TAdvPanelSettings = class(TPersistent)
  private
    FFixedHeight: Boolean;
    FCanMove: Boolean;
    FFixedWidth: Boolean;
    FHover: Boolean;
    FAutoHideChildren: Boolean;
    FAnchorHint: Boolean;
    FFixedLeft: Boolean;
    FCanSize: Boolean;
    FShowHint: Boolean;
    FFixedTop: Boolean;
    FCollaps: Boolean;
    FShowMoveCursor: Boolean;
    FCollapsDelay: Integer;
    FBevelWidth: Integer;
    FCollapsSteps: Integer;
    FHeight: Integer;
    FShadowOffset: Integer;
    FText: string;
    FHint: string;
    FBevelOuter: TBevelCut;
    FBevelInner: TBevelCut;
    FHoverColor: TColor;
    FCollapsColor: TColor;
    FBorderColor: TColor;
    FHoverFontColor: TColor;
    FShadowColor: TColor;
    FColor: TColor;
    FColorTo: TColor;
    FURLColor: TColor;
    FFont: TFont;
    FCaption: TPanelCaption;
    FPosition: TPanelPosition;
    FTextVAlign: TTextVAlignment;
    FBorderStyle: TBorderStyle;
    FCursor: TCursor;
    FBorderShadow: Boolean;
    FIndent: Integer;
    FTopIndent: Integer;
    FOnChange: TNotifyEvent;
    FWidth: Integer;
    FUpdateCount: Integer;
    FBorderWidth: Integer;
    procedure SetBorderColor(const Value: TColor);
    procedure SetCaption(const Value: TPanelCaption);
    procedure SetCollaps(const Value: Boolean);
    procedure SetFont(const Value: TFont);
    procedure SetBorderShadow(const Value: Boolean);
    procedure CaptionChanged(Sender: TObject);
    procedure Changed;
    procedure SetAnchorHint(const Value: Boolean);
    procedure SetAutoHideChildren(const Value: Boolean);
    procedure SetBevelInner(const Value: TBevelCut);
    procedure SetBevelOuter(const Value: TBevelCut);
    procedure SetBevelWidth(const Value: Integer);
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetCanMove(const Value: Boolean);
    procedure SetCanSize(const Value: Boolean);
    procedure SetCollapsColor(const Value: TColor);
    procedure SetCollapsDelay(const Value: Integer);
    procedure SetCollapsSteps(const Value: Integer);
    procedure SetColorTo(const Value: TColor);
    procedure SetCursor(const Value: TCursor);
    procedure SetHover(const Value: Boolean);
    procedure SetHoverColor(const Value: TColor);
    procedure SetHoverFontColor(const Value: TColor);
    procedure SetIndent(const Value: Integer);
    procedure SetText(const Value: string);
    procedure SetTextVAlign(const Value: TTextVAlignment);
    procedure SetTopIndent(const Value: Integer);
    procedure SetURLColor(const Value: TColor);
    procedure SetBorderWidth(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
  published
    property AnchorHint: Boolean read FAnchorHint write SetAnchorHint;
    property AutoHideChildren: Boolean read FAutoHideChildren write SetAutoHideChildren;
    property BevelInner: TBevelCut read FBevelInner write SetBevelInner;
    property BevelOuter: TBevelCut read FBevelOuter write SetBevelOuter;
    property BevelWidth: Integer read FBevelWidth write SetBevelWidth;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property BorderShadow: Boolean read FBorderShadow write SetBorderShadow;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
    property CanMove: Boolean read FCanMove write SetCanMove;
    property CanSize: Boolean read FCanSize write SetCanSize;
    property Caption:TPanelCaption read FCaption write SetCaption;
    property Collaps: Boolean read FCollaps write SetCollaps;
    property CollapsColor: TColor read FCollapsColor write SetCollapsColor;
    property CollapsDelay: Integer read FCollapsDelay write SetCollapsDelay;
    property CollapsSteps: Integer read FCollapsSteps write SetCollapsSteps;
    property Color: TColor read FColor write FColor;
    property ColorTo: TColor read FColorTo write SetColorTo;
    property Cursor: TCursor read FCursor write SetCursor;
    property Font: TFont read FFont write SetFont;
    property FixedTop: Boolean read FFixedTop write FFixedTop;
    property FixedLeft: Boolean read FFixedLeft write FFixedLeft;
    property FixedHeight: Boolean read FFixedHeight write FFixedHeight;
    property FixedWidth: Boolean read FFixedWidth write FFixedWidth;
    property Height: Integer read FHeight write FHeight;
    property Hint: string read FHint write FHint;
    property Hover: Boolean read FHover write SetHover;
    property HoverColor: TColor read FHoverColor write SetHoverColor;
    property HoverFontColor: TColor read FHoverFontColor write SetHoverFontColor;
    property Indent: Integer read FIndent write SetIndent;
    property Position: TPanelPosition read FPosition write FPosition;
    property ShadowColor: TColor read FShadowColor write FShadowColor;
    property ShadowOffset: Integer read FShadowOffset write FShadowOffset;
    property ShowHint: Boolean read FShowHint write FShowHint;
    property ShowMoveCursor: Boolean read FShowMoveCursor write FShowMoveCursor;
    property Text:string read FText write SetText;
    property TextVAlign: TTextVAlignment read FTextVAlign write SetTextVAlign;
    property TopIndent: Integer read FTopIndent write SetTopIndent;
    property URLColor: TColor read FURLColor write SetURLColor;
    property Width: Integer read FWidth write FWidth;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TCustomAdvPanel = class(TCustomPanel)
  private
    FText: string;
    FImage:TAdvImage;
    FBackgroundPosition: TBackgroundPosition;
    FCaption: TPanelCaption;
    FImages: TImageList;
    FURLColor: TColor;
    FOldColor: TColor;
    FCollaps: Boolean;
    FFullHeight: Integer;
    FAnchor: string;
    FHoverHyperLink: integer;
    FOldHoverHyperLink: integer;
    FCaptionHoverHyperLink: integer;
    FCurrHoverRect: trect;
    FCaptionCurrHoverRect: trect;
    FAnchorHint: boolean;
    FAnchorExit: TAnchorEvent;
    FAnchorClick: TAnchorEvent;
    FAnchorEnter: TAnchorEvent;
    FHover: boolean;
    FHoverColor: TColor;
    FHoverFontColor: TColor;
    FShadowOffset: Integer;
    FShadowColor: TColor;
    FCanSize: Boolean;
    FCanMove: Boolean;
    FTextVAlign: TTextVAlignment;
    FOnAnchorHint: TAnchorHintEvent;
    FOnClose: TNotifyEvent;
    FOnMinimize: TNotifyEvent;
    FOnMaximize: TNotifyEvent;
    FPosition: TPanelPosition;
    FOnCaptionClick: TNotifyEvent;
    FFixedHeight: Boolean;
    FFixedLeft: Boolean;
    FFixedWidth: Boolean;
    FFixedTop: Boolean;
    FTopLeft: TPoint;
    FWidthHeight: TPoint;
    FOnEndMoveSize: TNotifyEvent;
    FOldCursor: TCursor;
    FInMove: Boolean;
    FContainer: TPictureContainer;
    FImageCache: THTMLPictureCache;
    FShowMoveCursor: Boolean;
    FShadedHeader: TBitmap;
    FIsWinXP: Boolean;
    FFreeOnClose: Boolean;
    FIsCollapsing: Boolean;
    FOnCaptionDblClick: TNotifyEvent;
    FCollapsDelay: Integer;
    FCollapsSteps: Integer;
    FCollapsColor: TColor;
    FAutoSize: TAutoSize;
    FAutoHideChildren: Boolean;
    FCanUpdate: Boolean;
    FColorTo: TColor;
    FBorderColor: TColor;
    FIndex: Integer;
    FBuffered: Boolean;
    FBorderShadow: Boolean;
    FIndent: Integer;
    FTopIndent: Integer;
    FStyler: TAdvPanelStyler;
    FOnEndCollapsExpand: TNotifyEvent;
    procedure SetText(const Value: string);
    procedure SetBackgroundPosition(const Value: TBackgroundPosition);
    procedure SetImage(const Value: TAdvImage);
    procedure BackgroundChanged(sender: TObject);
    procedure SetCaption(const Value: TPanelCaption);
    procedure SetImages(const Value: TImageList);
    procedure SetURLColor(const Value: TColor);
    procedure SetCollaps(const Value: boolean);
    function GetHeightEx: integer;
    procedure SetHeightEx(const Value: integer);
    function IsAnchor(x,y:integer;var hoverrect:TRect):string;
    procedure SetHover(const Value: boolean);
    procedure CMHintShow(Var Msg: TMessage); message CM_HINTSHOW;
    procedure CMMouseLeave(Var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(Var Msg: TMessage); message CM_MOUSEENTER;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMEraseBkGnd(var Message:TMessage); message WM_ERASEBKGND;
    procedure WMSizing(var Msg: TMessage); message WM_SIZING;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    procedure WMMoving(var Msg: TMessage); message WM_MOVING;
    procedure WMExitSizeMove(var Msg: TMessage); message WM_EXITSIZEMOVE;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMLDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMPaint(var Msg: TWMPAINT); message WM_PAINT;
    procedure SetShadowColor(const Value: TColor);
    procedure SetShadowOffset(const Value: integer);
    procedure SetCanSize(const Value: boolean);
    procedure SetTextVAlign(const Value: TTextVAlignment);
    procedure ShowHideChildren(Show: Boolean);
    procedure SetAutoSizeEx(const Value: TAutoSize);
    procedure SetColorTo(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetIndex(const Value: Integer);
    procedure CaptionChange(Sender: TObject);
    procedure CaptionStateChange(Sender: TObject);
    procedure CaptionShadeChange(Sender: TObject);
    procedure SetBorderShadow(const Value: Boolean);
    procedure SetIndent(const Value: Integer);
    procedure SetTopIndent(const Value: Integer);
    procedure SetStyler(const Value: TAdvPanelStyler);
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function DoVisualStyles: Boolean;
    procedure Paint; override;
    procedure Resize; override;
    procedure DrawCaptionBkg(Canvas: TCanvas;r: TRect);
    procedure ShadeHeader; virtual;
    procedure WndProc(var Message: TMessage); override;
    procedure CreateWnd; override;
    procedure DefineProperties(Filer: TFiler);override;
    procedure StoreFullHeight(Writer: TWriter);
    procedure LoadFullHeight(Reader: TReader);
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure DoAutoSize;
    procedure StateChange; virtual;
    procedure AssignSettings(Settings: TAdvPanelSettings);
    procedure AssignStyle(Settings: TAdvPanelSettings);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadPosition;
    procedure SavePosition;
    procedure Synchronize;
    property FullHeight: Integer read FFullHeight write FFullHeight;
    property Index: Integer read FIndex write SetIndex;
  // properties to make published
    property AnchorHint: Boolean read FAnchorHint write FAnchorHint;
    property AutoSize: TAutoSize read FAutoSize write SetAutoSizeEx;
    property AutoHideChildren: Boolean read FAutoHideChildren write FAutoHideChildren;
    property Background: TAdvImage read FImage write SetImage;
    property BackgroundPosition: TBackgroundPosition read FBackgroundPosition write SetBackgroundPosition;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property BorderShadow: Boolean read FBorderShadow write SetBorderShadow;    
    property Buffered: Boolean read FBuffered write FBuffered;
    property CanMove: Boolean read FCanMove write FCanMove;
    property CanSize: Boolean read FCanSize write SetCanSize;
    property Caption:TPanelCaption read fCaption write SetCaption;
    property Collaps: Boolean read FCollaps write SetCollaps;
    property CollapsColor: TColor read FCollapsColor write FCollapsColor;
    property CollapsDelay: Integer read FCollapsDelay write FCollapsDelay;
    property CollapsSteps: Integer read FCollapsSteps write FCollapsSteps;
    property ColorTo: TColor read FColorTo write SetColorTo;
    property FixedTop: Boolean read FFixedTop write FFixedTop;
    property FixedLeft: Boolean read FFixedLeft write FFixedLeft;
    property FixedHeight: Boolean read FFixedHeight write FFixedHeight;
    property FixedWidth: Boolean read FFixedWidth write FFixedWidth;
    property FreeOnClose: Boolean read FFreeOnClose write FFreeOnClose;
    property Height: Integer read GetHeightEx write SetHeightEx;
    property Hover: Boolean read FHover write SetHover;
    property HoverColor: TColor read FHoverColor write FHoverColor;
    property HoverFontColor: TColor read FHoverFontColor write fHoverFontColor;
    property Images: TImageList read FImages write SetImages;
    property Indent: Integer read FIndent write SetIndent;
    property PictureContainer: TPictureContainer read FContainer write FContainer;
    property Position: TPanelPosition read FPosition write FPosition;
    property ShadowColor: TColor read FShadowColor write SetShadowColor;
    property ShadowOffset: Integer read FShadowOffset write SetShadowOffset;
    property ShowMoveCursor: Boolean read FShowMoveCursor write FShowMoveCursor;
    property Styler: TAdvPanelStyler read FStyler write SetStyler;
    property Text:string read FText write SetText;
    property TextVAlign: TTextVAlignment read FTextVAlign write SetTextVAlign;
    property TopIndent: Integer read FTopIndent write SetTopIndent;
    property URLColor: TColor read FURLColor write SetURLColor;
    property OnCaptionClick: TNotifyEvent read FOnCaptionClick write FOnCaptionClick;
    property OnCaptionDBlClick: TNotifyEvent read FOnCaptionDblClick write FOnCaptionDblClick;
    property OnAnchorClick:TAnchorEvent read FAnchorClick write FAnchorClick;
    property OnAnchorEnter:TAnchorEvent read FAnchorEnter write FAnchorEnter;
    property OnAnchorExit:TAnchorEvent read FAnchorExit write FAnchorExit;
    property OnAnchorHint:TAnchorHintEvent read FOnAnchorHint write FOnAnchorHint;
    property OnClose: TNotifyEvent read fOnClose write fOnClose;
    property OnEndMoveSize: TNotifyEvent read FOnEndMoveSize write FOnEndMoveSize;
    property OnMinimize: TNotifyEvent read FOnMinimize write FOnMinimize;
    property OnMaximize: TNotifyEvent read FOnMaximize write FOnMaximize;
    property OnEndCollapsExpand: TNotifyEvent read FOnEndCollapsExpand write FOnEndCollapsExpand;
  published
     property Align;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    {$ENDIF}
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderStyle;
    property Color;
    {$IFDEF DELPHI4_LVL}
    property Constraints;
    {$ENDIF}
    property Cursor;
    {$IFDEF DELPHI4_LVL}
    property DockSite;
    {$ENDIF}
    property DragCursor;
    {$IFDEF DELPHI4_LVL}
    property DragKind;
    {$ENDIF}
    property DragMode;
    property Enabled;
    property Font;
    property HelpContext;
    property Hint;
    property Locked;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Tag;
    {$IFDEF DELPHI4_LVL}
    property UseDockManager;
    {$ENDIF}
    property Visible;

    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;

    {$IFDEF DELPHI4_LVL}
    property OnConstrainedResize;
    {$ENDIF}
    {$IFDEF DELPHI5_LVL}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    {$IFDEF DELPHI4_LVL}
    property OnDockDrop;
    property OnDockOver;
    {$ENDIF}
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF DELPHI4_LVL}
    property OnEndDock;
    {$ENDIF}
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$IFDEF DELPHI4_LVL}
    property OnGetSiteInfo;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    property OnCanResize;
    {$ENDIF}
    property OnClick;
    property OnResize;
    {$IFDEF DELPHI4_LVL}
    property OnStartDock;
    {$ENDIF}
    property OnStartDrag;
    {$IFDEF DELPHI4_LVL}
    property OnUnDock;
    {$ENDIF}
  end;

  TAdvPanel = class(TCustomAdvPanel)
  published
    property AnchorHint;
    property AutoSize;
    property AutoHideChildren;
    property Background;
    property BackgroundPosition;
    property BorderColor;
    property BorderShadow;
    property BorderWidth;
    property Buffered;
    property CanMove;
    property CanSize;
    property Caption;
    property Collaps;
    property CollapsColor;
    property CollapsDelay;
    property CollapsSteps;
    property ColorTo;
    property FixedTop;
    property FixedLeft;
    property FixedHeight;
    property FixedWidth;
    property FreeOnClose;
    property Height;
    property Hover;
    property HoverColor;
    property HoverFontColor;
    property Images;
    property Indent;
    property PictureContainer;
    property Position;
    property ShadowColor;
    property ShadowOffset;
    property ShowMoveCursor;
    property Styler;
    property Text;
    property TextVAlign;
    property TopIndent;
    property URLColor;
    property OnCaptionClick;
    property OnCaptionDBlClick;
    property OnAnchorClick;
    property OnAnchorEnter;
    property OnAnchorExit;
    property OnAnchorHint;
    property OnClose;
    property OnEndMoveSize;
    property OnMinimize;
    property OnMaximize;
    property OnEndCollapsExpand;
  end;

  TGroupStyle = (gsVertical, gsHorizontal);

  TAdvPanelGroup = class(TAdvPanel)
  private
    FUpdateCount: Integer;
    FHorzPadding: Integer;
    FVertPadding: Integer;
    FGroupStyle: TGroupStyle;
    FIsArranging: Boolean;
    FScrollBar: TScrollBar;
    FPanels: TList;
    FDefaultPanel: TAdvPanelSettings;
    FColumns: Integer;
    FCode: Boolean;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    procedure SetHorzPadding(const Value: Integer);
    procedure SetVertPadding(const Value: Integer);
    procedure SetGroupStyle(const Value: TGroupStyle);
    function GetPanel(Index: Integer): TCustomAdvPanel;
    procedure SetPanel(Index: Integer; const Value: TCustomAdvPanel);
    procedure SetDefaultPanel(const Value: TAdvPanelSettings);
    procedure SetColumns(const Value: Integer);
  protected
    procedure ArrangeControlsVert;
    procedure ArrangeControlsHorz;
    procedure ArrangeControls;
    procedure Scroll(Sender: TObject);
    function PanelHeights: Integer;
    function PanelWidths: Integer;
    procedure UpdateScrollbar;
    procedure StateChange; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure ChildPanelChanged(APanel: TCustomAdvPanel);
    property IsArranging: Boolean read FIsArranging;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure OpenAllPanels;
    procedure CloseAllPanels;
    procedure SavePanelPositions;
    procedure LoadPanelPositions;
    procedure UpdateGroup;
    procedure Clear;
    procedure BeginUpdate;
    procedure EndUpdate;
    function AddPanel: TCustomAdvPanel;
    function InsertPanel(Index: Integer): TCustomAdvPanel;
    procedure RemovePanel(Index: Integer);
    procedure MovePanel(FromIndex,ToIndex: Integer);
    property Panels[Index: Integer]: TCustomAdvPanel read GetPanel write SetPanel;
  published
    property Columns: Integer read FColumns write SetColumns;
    property DefaultPanel: TAdvPanelSettings read FDefaultPanel write SetDefaultPanel;
    property GroupStyle: TGroupStyle read FGroupStyle write SetGroupStyle;
    property HorzPadding: Integer read FHorzPadding write SetHorzPadding;
    property VertPadding: Integer read FVertPadding write SetVertPadding;
  end;

  TAdvPanelStyle = (psXP, psFlat, psTMS, psClassic);

  TAdvPanelStyler = class(TComponent)
  private
    FSettings: TAdvPanelSettings;
    FComments: string;
    FTag: Integer;
    FStyle: TAdvPanelStyle;
    procedure SetSettings(const Value: TAdvPanelSettings);
    procedure SetStyle(const Value: TAdvPanelStyle);
  protected
    procedure Changed(Sender: TObject);  
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Settings: TAdvPanelSettings read FSettings write SetSettings;
    property Comments: string read FComments write FComments;
    property Style: TAdvPanelStyle read FStyle write SetStyle;
    property Tag: Integer read FTag write FTag;

  end;

implementation

uses
 {$IFDEF DELPHI4_LVL} ImgList,{$ENDIF} ShellApi, Commctrl, Math;

{$I HTMLENGO.PAS}

function BlendColor(Col1,Col2:TColor; BlendFactor:Integer): TColor;
var
  r1,g1,b1: Integer;
  r2,g2,b2: Integer;

begin
  if BlendFactor = 100 then
  begin
    Result := Col1;
    Exit;
  end;

  Col1 := Longint(ColorToRGB(Col1));
  r1 := GetRValue(Col1);
  g1 := GetGValue(Col1);
  b1 := GetBValue(Col1);

  Col2 := Longint(ColorToRGB(Col2));
  r2 := GetRValue(Col2);
  g2 := GetGValue(Col2);
  b2 := GetBValue(Col2);

  r1 := Round( BlendFactor/100 * r1 + (1 - BlendFactor/100) * r2);
  g1 := Round( BlendFactor/100 * g1 + (1 - BlendFactor/100) * g2);
  b1 := Round( BlendFactor/100 * b1 + (1 - BlendFactor/100) * b2);

  Result := RGB(r1,g1,b1);
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


{ TAdvPanel }

procedure TCustomAdvPanel.BackgroundChanged(Sender: TObject);
begin
  Invalidate;
end;

constructor TCustomAdvPanel.Create(AOwner: TComponent);
var
  dwVersion:Dword;
  dwWindowsMajorVersion,dwWindowsMinorVersion:Dword;
begin
  inherited;
  FImage := TAdvImage.Create;
  FCaption := TPanelCaption.Create;
  FCaption.OnChange := CaptionChange;
  FCaption.OnStateChange := CaptionStateChange;
  FCaption.OnShadeChange := CaptionShadeChange;
  FImage.OnChange := BackgroundChanged;
  FURLColor := clBlue;
  FHoverColor := clNone;
  FHoverFontColor := clNone;
  FShadowColor := clGray;
  FShadowOffset := 2;
  FPosition := TPanelPosition.Create(Self);
  FImageCache := THTMLPictureCache.Create;
  {$IFDEF DELPHI4_LVL}
  DoubleBuffered := True;
  {$ENDIF}
  FShadedHeader := TBitmap.Create;
  FIsCollapsing := False;
  FCollapsDelay := 20;
  FCollapsColor := clGray;
  FBuffered := True;

  dwVersion := GetVersion;
  dwWindowsMajorVersion :=  DWORD(LOBYTE(LOWORD(dwVersion)));
  dwWindowsMinorVersion :=  DWORD(HIBYTE(LOWORD(dwVersion)));

  FIsWinXP := (dwWindowsMajorVersion > 5) OR
    ((dwWindowsMajorVersion = 5) AND (dwWindowsMinorVersion >= 1));

  FAutoSize := TAutoSize.Create(Self);
  FAutoHideChildren := True;
  FCanUpdate := True;
  FOldColor := Color;
  FColorTo := clNone;  
end;

destructor TCustomAdvPanel.Destroy;
begin
  FImage.Free;
  FCaption.Free;
  FPosition.Free;
  FImageCache.Free;
  FShadedHeader.Free;
  FAutoSize.Free;
  inherited;
end;

procedure TCustomAdvPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  r,hr: TRect;
  anchor: string;
  GW: Integer;

begin
  inherited;

  if (csDesigning in ComponentState) then
    Exit;

  if FCaption.Visible then
  begin
    r := ClientRect;

    GW := 12;

    if (not FCaption.CloseMinGlyph.Empty and not FCaption.CloseMaxGlyph.Empty) then
      GW := FCaption.CloseMinGlyph.Width;

    if (not FCaption.MaxGlyph.Empty and not FCaption.MinGlyph.Empty)  then
      GW := FCaption.MaxGlyph.Width;

    if (FCaption.ShadeType = stXPCaption) and DoVisualStyles then
      GW := 16;


    if FCaption.ButtonPosition = cbpRight then
    begin
      if PtInRect(Rect(r.Right-2-GW,r.Top+2,r.Right-2,r.Top+2+GW),point(x,y)) and FCaption.CloseButton then
      begin
        Visible := False;
        if Assigned(FOnClose) then
          FOnClose(Self);
        Synchronize;

        if FreeOnClose then
        begin
          Free;
          Exit;
        end;
      end;
    end
    else
    begin
      if PtInRect(Rect(r.Left+2,r.Top+2,r.Left + GW + 2,r.Top + 2 + GW),point(x,y)) and FCaption.CloseButton then
      begin
        Visible := False;
        if Assigned(FOnClose) then
          FOnClose(Self);
        Synchronize;

        if FreeOnClose then
        begin
          Free;
          Exit;
        end;
      end;
    end;

    if FCaption.ButtonPosition = cbpRight then
    begin
      if FCaption.CloseButton then
        r.Right := r.Right - GW;
    end
    else
    begin
      if FCaption.CloseButton then
        r.Left := r.Left + GW;
    end;

    if FCaption.ButtonPosition = cbpRight then
    begin
      if PtInRect(Rect(r.Right-2-GW,r.Top+2,r.Right-2,r.Top+2+GW),point(x,y)) and FCaption.MinMaxButton then
      begin
        Collaps := not Collaps;
      end;
    end
    else
    begin
      if PtInRect(Rect(r.Left + 2,r.Top + 2,r.Left + 2 + GW,r.Top+2+GW),point(x,y)) and FCaption.MinMaxButton then
      begin
        Collaps := not Collaps;
      end;
    end;  

    if PtInRect(rect(r.left,r.Top,r.Right-2,r.Top + FCaption.Height),point(x,y)) then
    begin
      if Assigned(FOnCaptionClick) then
        FOnCaptionClick(Self);
    end;

   end;

  Anchor := IsAnchor(X,Y,hr);
  if Anchor <> '' then
  begin
    if (Pos('://',Anchor)>0) or (Pos('mailto:',Anchor)>0) then
      ShellExecute(0,'open',PChar(Anchor),nil,nil,SW_NORMAL)
    else
      begin
        if Assigned(FAnchorClick) then
          FAnchorClick(Self,Anchor);
      end;
  end;
end;

procedure TCustomAdvPanel.ShadeHeader;
var
  a,x,y,xs,i,j,h,k,s,sizeX,sizeY: Integer;
  d : TColor;
  R: Trect;
  Light: Byte;
  rr,br,gr: Integer;

  function Dist(x1,y1,x2,y2: Integer): Integer;
  begin
    Result := Round(sqrt( sqr(x1-x2) + sqr(y1 - y2)));
  end;

begin
  rr := GetRValue(ColorToRGB(FCaption.Color));
  gr := GetGValue(ColorToRGB(FCaption.Color));
  br := GetBValue(ColorToRGB(FCaption.Color));

  Light := FCaption.ShadeLight;
  FShadedHeader.Width := Width;
  FShadedHeader.Height := FCaption.FHeight;

  Randomize;
  SizeX := FShadedHeader.Width;
  SizeY := FShadedHeader.Height;

  if SizeX = 0 then
    SizeX := 100;
  if SizeY = 0 then
    SizeY := 20;

  FShadedHeader.Canvas.Brush.Color := clWhite;
  r := Rect(0,0,SizeX,SizeY);
  FShadedHeader.Canvas.FillRect(r); //clear the bitmap

  case FCaption.ShadeType of
  stIRADIAL,stORADIAL:
    begin
      h := Dist(0,SizeX,0,SizeY);
      x := sizeX div 2;
      y := sizeY div 2;

      for i := 0 to x do
        for j := 0 to y do
        begin
          k := Dist(i,j,x,y);

          if FCaption.ShadeType = stIRADIAL then
            k := Round((h - k) / h * Light)
          else
            k := Round(k / h * Light);

          d := RGB( (rr*k) div 255,(gr*k) div 255,(br*k) div 255);

          FShadedHeader.Canvas.Pixels[i,j] := d;
          FShadedHeader.Canvas.Pixels[sizex - i,sizey - j] := d;
          FShadedHeader.Canvas.Pixels[sizex - i,j] := d;
          FShadedHeader.Canvas.Pixels[i,sizey - j] := d;
        end;
    end;
  stLMETAL,stRMETAL:
    begin
      for a := 0 to 250 do
      begin
        x := Random(sizeX);
        y := Random(sizeY);
        xs := Random(Min(sizeX,sizeY) div 2);
        i := Light - Random(40);
        d := RGB( (rr*i) div 255,(gr*i) div 255,(br*i) div 255);
        for i := 0 to xs - 1 do
        begin
          if FCaption.ShadeType = stLMetal then
          begin
            if (((x-i)>0)and((y+i)<sizeY)) then
              FShadedHeader.Canvas.Pixels[x + i,y + i] := d;
            if (((x+i)<sizeX)and((y-i)>0)) then
              FShadedHeader.Canvas.Pixels[x - i,y - i] := d;
          end
          else
          begin
            if (((x-i)>0)and((y+i)<sizeY)) then
              FShadedHeader.Canvas.Pixels[x - i,y + i] := d;
            if (((x+i)<sizeX)and((y-i)>0)) then
              FShadedHeader.Canvas.Pixels[x + i,y - i] := d;
          end;
        end;
      end;
      a := 120;
      for i := 0 to sizeX do
        for j := 0 to sizeY do
        begin
          d := FShadedHeader.Canvas.Pixels[i,j];
          x := GetBValue(d);
          x := Light - x;
          x := x + ((a*i) div sizeX)+((a*j) div sizeY);
          x := Light - x div 2;
          d := RGB( (rr*x) div 255,(gr*x) div 255,(br*x) div 255);
          FShadedHeader.Canvas.Pixels[i,j] := d;
        end;
    end;
  stHARDBUMP:
    begin
      for i := 0 to sizeY do
      begin
        x := (255*i div sizeY)-127;
        x := (x*(x*x) div 128) div 128;
        x := ((x*112) div 128) +128;
        for j:= 0 to sizeX do
        begin
          y := Light - x div 2; //offset
          d := RGB( (rr*y) div 255,(gr*y) div 255,(br*y) div 255);
          FShadedHeader.Canvas.Pixels[j,i] := d;
        end;
      end;
      k := min(16, sizeX div 6);
      a := (sizeY*sizeY) div 4;
      for i := 0 to sizeY do
      begin
        y := i - sizeY div 2;
        for j := 0 to sizeX do
        begin
          x  := j - sizeX div 2;
          xs := sizeX div 2 - k + (y*y*k) div a;
          if (x > xs)   then
          begin
            s := 8 + (((sizeX-j)*128) div k);
            s := Light - s div 2;//offset
            d := RGB( (rr*s) div 255,(gr*s) div 255,(br*s) div 255);
            FShadedHeader.Canvas.Pixels[j,i] := d;
          end;
          if (x + xs) < 0   then
          begin
            s := 247 - ((j*128) div k);
            s := Light - s div 2;//offset
            d := RGB( (rr*s) div 255,(gr*s) div 255,(br*s) div 255);
            FShadedHeader.Canvas.Pixels[j,i] := d;
          end;
        end;
      end;
    end;
  stSOFTBUMP:
    begin
      for i := 0 to sizeY do
      begin
        h := ((255 * i) div sizeY) - 127;
        for j := 0 to sizeX do
        begin
          k := 255 * (sizeX - j) div sizeX - 127;
          k := ((h * (h * h)) div 128) div 128 + (k * ( k * k) div 128) div 128;
          k := k * (128 - 8) div 128 + 128;
          if (k < 8)  then k := 8;
          if (k > 247) then k := 247;
          s := Light - k div 2;  //offset
          d := RGB( (rr*s) div 255,(gr*s) div 255,(br*s) div 255);
          FShadedHeader.Canvas.Pixels[j,i] := d;
        end;
      end;
    end;
  stHBUMP:
    begin
      for j := 0 to sizeX do
      begin
        k := (255*(sizeX - j)div sizeX)-127;
        k := (k*(k*k)div 128)div 128;
        k := (k*(128 - 8))div 128 + 128;
        for i := 0 to sizeY do
        begin
          s := Light - k div 2;//offset
          d := RGB( (rr*s) div 255,(gr*s) div 255,(br*s) div 255);
          FShadedHeader.Canvas.Pixels[j,i] := d;
        end;
      end;
    end;
  stVBUMP:
    begin
      for i := 0 to sizeY do
      begin
        k := (255*i div sizeY)-127;
        k := (k*(k*k)div 128)div 128;
        k := (k*(128 - 8))div 128 + 128;
        for j := 0 to sizeX do
        begin
          s := Light - k div 2;//offset
          d := RGB( (rr*s) div 255,(gr*s) div 255,(br*s) div 255);
          FShadedHeader.Canvas.Pixels[j,i] := d;
        end;
      end;
    end;
  stDIAGSHADE:
    begin
      a := 129;
      for i := 0 to sizeX do
        for j := 0 to sizeY do
        begin
          d := FShadedHeader.Canvas.Pixels[i,j];
          x := GetBValue(d);
          x := Light-x;
          x := x+((a*i) div sizeX)+((a*j) div sizeY);
          x := Light-x div 2;//offset
          d := RGB( (rr*x) div 255,(gr*x) div 255,(br*x) div 255);
          FShadedHeader.Canvas.Pixels[i,j] := d;
        end;
      end;
  stVSHADE,stVSHADEInv:
    begin
      a := 239;
      for i := 0 to sizeY do
      begin
        k := a * i div sizeY +8;
        k := Light-k div 2;//offset
        d := RGB( (rr*k) div 255,(gr*k) div 255,(br*k) div 255);
        for j := 0 to sizeX do
          if FCaption.ShadeType = stVSHADEInv then
            FShadedHeader.Canvas.Pixels[j,i] := d
          else
            FShadedHeader.Canvas.Pixels[sizeX - j,i] := d
      end;
    end;
  stHSHADE,stHShadeInv:
    begin
      a := 239;
      for j := 0 to sizeX do
      begin
        k := a * (sizeX-j) div sizeX +8;
        k := Light-k div 2;//offset
        d := RGB( (rr*k) div 255,(gr*k) div 255,(br*k) div 255);
        for i := 0 to sizeY do
          if FCaption.ShadeType = stHSHADE then
            FShadedHeader.Canvas.Pixels[j,i] := d
          else
            FShadedHeader.Canvas.Pixels[sizeX - j,i] := d
      end;
    end;
  stNOISE:
    begin
      for i := 0 to sizeX do
        for j := 0 to sizeY do
        begin
          k := 128 + random(FCaption.ShadeGrain) ;
          k := Light-k div 2;//offset
          d := RGB( (rr*k) div 255,(gr*k) div 255,(br*k) div 255);
          FShadedHeader.Canvas.Pixels[i,j] := d;
        end;
      end;
  stNORMAL,stXPCaption, stBitmap, stBitmapLStretch, stBitmapRStretch:
    begin  //for normal we use the panel caption color
      FShadedHeader.Canvas.Brush.Color:= FCaption.Color;
      FShadedHeader.Canvas.FillRect(r);
    end;
  end;
end;

procedure TCustomAdvPanel.DrawCaptionBkg(Canvas: TCanvas; r: TRect);
var
  tRgn,rgn1,rgn2: HRGN;
  BorderColor1, BorderColor2: TColor;
  ind: Integer;
  HTheme: THandle;
begin

  BorderColor1 := clWhite;
  BorderColor2 := clGray;

  if (FCaption.ShadeType = stXPCaption) and DoVisualStyles then
  begin
    HTheme := OpenThemeData(Handle,'window');
    InflateRect(r,1,1);
    //Hot := Panel.Index = FMousePanel;
    //Down := Hot and FMouseDown;
    DrawThemeBackground(HTheme,Canvas.Handle,WP_CAPTION,CS_ACTIVE,@r,nil);

    CloseThemeData(HTheme);
  end;


  if (FCaption.ShadeType in [stBitmap, stBitmapLStretch, stBitmapRStretch]) then
  begin
    if not FCaption.Background.Empty then
    begin
      if FCaption.ShadeType = stBitmapLStretch then
      begin
        ind := Width - FCaption.Background.Width;
        if ind < 0 then ind := 0;
        Canvas.Draw(r.Left + Ind, r.Top, FCaption.Background);

        Canvas.CopyRect(Rect(0,r.Top,Ind,R.Bottom),FCaption.Background.Canvas,
          Rect(0,0,2,FCaption.Background.Height));
      end;

      if FCaption.ShadeType = stBitmapRStretch then
      begin
        ind := FCaption.Background.Width;

        Canvas.Draw(r.Left, r.Top, FCaption.Background);

        Canvas.CopyRect(Rect(ind,r.Top,R.Right,R.Bottom),FCaption.Background.Canvas,
          Rect(FCaption.Background.Width -3 ,0,FCaption.Background.Width,FCaption.Background.Height));
      end;

      if FCaption.ShadeType = stBitmap then
      begin
        Canvas.StretchDraw(r,FCaption.Background);
      end;
    end;
  end;


  if not (FCaption.ShadeType in [stXPCaption, stBitmap, stBitmapLStretch, stBitmapRStretch]) then
  begin
    trgn := 0;
    rgn1 := 0;
    rgn2 := 0;
    
    case FCaption.Shape of
    csRectangle:
      begin
        if not FCaption.Flat then
        begin
          Canvas.Pen.Color := BorderColor2;         //lines for 3D effect
          Canvas.MoveTo(R.Left,R.Bottom - 1);
          Canvas.LineTo(R.Right - 1,R.Bottom - 1);
          Canvas.LineTo(R.Right - 1,R.Top);
          Canvas.Pen.Color := BorderColor1;
          Canvas.LineTo(R.Left,R.Top);
          Canvas.LineTo(R.Left,R.Bottom - 1);
          InflateRect(R,-1,-1);
        end;

        tRgn := CreateRectRgn(R.Left,R.Top,R.Right,R.Bottom);
      end;                    //standard rectangle
    csRounded:
      begin
        Canvas.Pen.Color := BorderColor2;         //Round Rects for 3D effect
        tRgn := CreateRoundRectRgn(R.Left,R.Top+(r.Bottom-r.Top)div 2,R.Right,R.Bottom,32,32);
        SelectClipRgn(Canvas.Handle,tRgn);
        Canvas.RoundRect(R.Left,R.Top,R.Right,R.Bottom,32,32);
        Canvas.Pen.Color := BorderColor1;
        tRgn := CreateRoundRectRgn(R.Left,R.Top,R.Right,R.Bottom-(r.Bottom-r.Top)div 2,32,32);
        SelectClipRgn(Canvas.Handle,0);
        DeleteObject(tRgn);

        Canvas.RoundRect(R.Left,R.Top,R.Right,R.Bottom,32,32);
        tRgn := CreateRectRgn(0,0,Width,height);
        SelectClipRgn(Canvas.Handle,tRgn);
        Canvas.Pen.Color := BorderColor2;
        Canvas.MoveTo(R.Left + 16,r.Bottom - 1);
        Canvas.LineTo(r.Right - 16,r.Bottom - 1);
        R.Top := R.Top + 1;
        SelectClipRgn(Canvas.Handle,0);
        DeleteObject(tRgn);
        tRgn := CreateRoundRectRgn(R.Left,R.Top,R.Right,R.Bottom,32,32);
      end;              //round rectangle
    csSemiRounded:
      begin
        Canvas.Pen.Color := BorderColor2;     //Round Rects for 3D effect
        tRgn := CreateRoundRectRgn(R.Left,R.Top + (r.Bottom - r.Top)div 2,R.Right,R.Bottom,32,32);
        SelectClipRgn(Canvas.Handle,tRgn);
        Canvas.RoundRect(R.Left,R.Top,R.Right,R.Bottom,32,32);
        Canvas.Pen.Color := BorderColor1;
        SelectClipRgn(Canvas.Handle,0);
        DeleteObject(tRgn);
        tRgn := CreateRoundRectRgn(R.Left,R.Top,R.Right,R.Bottom-(r.Bottom - r.Top)div 2,32,32);
        SelectClipRgn(Canvas.Handle,tRgn);
        Canvas.RoundRect(R.Left,R.Top,R.Right,R.Bottom,32,32);
        SelectClipRgn(Canvas.Handle,0);
        DeleteObject(tRgn);
        tRgn := CreateRectRgn(0,0,Width,height);
        SelectClipRgn(Canvas.Handle,tRgn);
        Canvas.Pen.Color := BorderColor1;          //Lines for 3D effect
        Canvas.MoveTo(R.Left + (r.Right - r.Left)div 2,r.Top);
        Canvas.LineTo(R.Left,r.Top);
        Canvas.LineTo(R.Left,r.Bottom - 1);
        Canvas.Pen.Color := BorderColor2;
        Canvas.LineTo(r.Right - 16,r.Bottom - 1);
        SelectClipRgn(Canvas.Handle,0);
        DeleteObject(tRgn);
        R.Top := R.Top + 1;
        R.Left := R.Left + 1;
        rgn1 := CreateRoundRectRgn(R.Left,R.Top,R.Right,R.Bottom,32,32);
        rgn2  := CreateRectRgn(R.Left,R.Top,R.Right-(r.Right-r.Left)div 2,R.Bottom-1);
        CombineRgn(tRgn,rgn1,rgn2,RGN_OR);//round rectangle + rectangle
      end;
    end;

    SelectClipRgn(Canvas.Handle,tRgn);    //Set the Canvas Clip region
    Canvas.Draw(R.Left ,R.Top ,FShadedHeader);  //Put the shade

    SelectClipRgn(Canvas.Handle,0);   //Restore the Canvas Clip region
    DeleteObject(tRgn);
    if FCaption.Shape = csSemiRounded then
    begin
      DeleteObject(rgn1);
      DeleteObject(rgn2);
    end;
  end;
end;

{$WARNINGS OFF}
procedure TCustomAdvPanel.Paint;
var
  a,s,fa:string;
  xsize,ysize:integer;
  r,hr,cr,dr:trect;
  xo,yo,hl,ml:integer;
  hrgn:THandle;
  TopColor, BottomColor: TColor;
  HTheme: THandle;
  sz: TSize;
  bmp: TBitmap;
  ACanvas: TCanvas;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

  function Max(a,b:integer):integer;
  begin
    if a>b then result:=a else result:=b;
  end;

begin
  R := ClientRect;

  if FBuffered then
  begin
    bmp := TBitmap.Create;
    bmp.Width := r.Right - r.Left;
    bmp.Height := r.Bottom - r.Top;
    ACanvas := bmp.Canvas;
  end
  else
    ACanvas := Canvas;

  if ColorTo <> clNone then
    DrawGradient(ACanvas,Color,ColorTo,64,r,False)
  else
  begin
    ACanvas.Brush.Color := Color;
    ACanvas.Pen.Color := Color;
    ACanvas.FillRect(r);
  end;

  if (BorderColor <> clNone) and (BorderWidth > 0) then
  begin
    ACanvas.Brush.Style := bsClear;
    ACanvas.Pen.Color := BorderColor;

    if FBorderShadow then
    begin
      r.Right := r.Right - 2;
      r.Bottom := r.Bottom - 2;
    end;

    ACanvas.Rectangle(r.Left,r.Top,r.Right,r.Bottom);

    if FBorderShadow then
    begin
      ACanvas.MoveTo(r.Right + 0,r.Top);
      ACanvas.Pen.Color := BlendColor(BorderColor,clBtnFace,50);
      ACanvas.LineTo(r.Right + 0,r.Bottom + 0);
      ACanvas.LineTo(r.Left,r.Bottom + 0);

      ACanvas.MoveTo(r.Right + 1,r.Top);
      ACanvas.Pen.Color := BlendColor(BorderColor,clBtnFace,20);
      ACanvas.LineTo(r.Right + 1,r.Bottom + 1);
      ACanvas.LineTo(r.Left,r.Bottom + 1);
    end;

    ACanvas.Brush.Style := bsSolid;
  end;


  if BevelOuter <> bvNone then
  begin
    AdjustColors(BevelOuter);
    Frame3D(ACanvas, R, TopColor, BottomColor, BevelWidth);
  end;

  if BorderColor = clNone then
    Frame3D(ACanvas, R, Color, Color, 1);

  if BevelInner <> bvNone then
  begin
    AdjustColors(BevelInner);
    Frame3D(ACanvas, R, TopColor, BottomColor, BevelWidth);
  end;

  ACanvas.Brush.Color := Color;
  ACanvas.Pen.Color := Color;

  R := GetClientRect;

  if FCaption.Visible then
    R.Top := R.Top + FCaption.Height - 2 * BevelWidth;

  if FBorderShadow then
  begin
    R.Right := R.Right - 2;
    R.Bottom := R.Bottom - 3;
  end;

  hrgn := CreateRectRgn(R.Left, R.Top, R.Right,R.Bottom);
  SelectClipRgn(ACanvas.Handle, hrgn);

  if Assigned(FImage) then
  begin

    if not FImage.Empty then
    case FBackgroundPosition of
    bpTopLeft:ACanvas.Draw(r.Left,r.Top,FImage);
    bpTopRight:ACanvas.Draw(Max(r.Left,r.Right - r.Left - FImage.Width - BevelWidth),r.top,FImage);
    bpBottomLeft:ACanvas.Draw(r.left,Max(r.top,Height - FImage.Height - BevelWidth),FImage);
    bpBottomRight:ACanvas.Draw(Max(r.Left,r.Right - r.Left - FImage.Width-BevelWidth),Max(r.Top,Height - FImage.Height - BevelWidth),FImage);
    bpCenter:ACanvas.Draw(Max(r.Left,r.Right - r.Left - FImage.Width - BevelWidth) shr 1,Max(r.Top,Height - FImage.Height - BevelWidth) shr 1,FImage);
    bpTiled:begin
              yo := r.Top;
              while (yo < Height) do
              begin
                xo := r.Left;
                while (xo<Width) do
                begin
                  ACanvas.Draw(xo,yo,FImage);
                  xo := xo + FImage.Width;
                end;
                yo := yo + FImage.Height;
              end;
            end;
    bpStretched:ACanvas.StretchDraw(R,FImage);
    else
    end;

  end;

  InflateRect(r,-BorderWidth,-BorderWidth);

  r.Left := r.Left + Indent;
  r.Top := r.Top + TopIndent;
  
  ACanvas.Font.Assign(self.Font);

  if FTextVAlign in [tvaCenter,tvaBottom] then
  begin
    dr := r;

    HTMLDrawEx(ACanvas,Text,dr,FImages,0,0,-1,FHoverHyperLink,FShadowOffset,true,false,false,false,false,fHover,true,1.0,fURLColor,fHoverColor,fHoverFontColor,fShadowColor,a,s,fa,
                      xsize,ysize,hl,ml,hr,FImageCache,FContainer);


    if FCaption.Visible then
      r.Top := r.Top + FCaption.Height - 2 * BevelWidth;

    if YSize < (r.Bottom - r.Top) then
    case FTextVAlign of
    tvaCenter:r.Top := r.Top + (((r.Bottom - r.Top) - YSize) div 2);
    tvaBottom:r.Top := r.Bottom - YSize;
    end;
  end;


  HTMLDrawEx(ACanvas,Text,r,FImages,0,0,-1,FHoverHyperLink,FShadowOffset,false,false,false,false,false,FHover,true,
    1.0,FURLColor,FHoverColor,fHoverFontColor,fShadowColor,a,s,fa,xsize,ysize,hl,ml,hr,FImageCache,FContainer);

  SelectClipRgn(ACanvas.handle, 0);
  DeleteObject(hrgn);

  if FCaption.Visible then
  begin
    r := ClientRect;

    if FBorderShadow then
    begin
      r.Right := r.Right - 2;
      r.Bottom := r.Bottom - 2;
    end;

    if (bevelInner <> bvNone) or (bevelOuter <> bvNone) then
      Inflaterect(r,-BevelWidth,-BevelWidth);

    if not FCollaps then
    begin
      ACanvas.Brush.Color := FCaption.Color;
      ACanvas.Pen.Color := FCaption.Color;
    end
    else
    begin
      ACanvas.Brush.Color := FCaption.CloseColor;
      ACanvas.Pen.Color := FCaption.CloseColor;
    end;

    if (FCaption.ShadeType = stNormal) or
       ((FCaption.ShadeType = stXPCaption) and not DoVisualStyles) then
    begin
      if FCaption.ColorTo <> clNone then
        DrawGradient(ACanvas,FCaption.Color,FCaption.ColorTo,64,
          Rect(r.Left,r.Top,r.Right,r.top+fCaption.Height - 2 * BevelWidth),true)
      else
        ACanvas.Rectangle(r.Left,r.Top,r.Right,r.Top + FCaption.Height - 2 * BevelWidth)
    end
    else
      DrawCaptionBkg(ACanvas,Rect(r.Left,r.Top,r.Right,r.Top + FCaption.Height - 2 * BevelWidth));

    if FCaption.CloseButton then
    begin
      if (FCaption.ShadeType = stXPCaption) and DoVisualStyles then
      begin
        HTheme := OpenThemeData(self.Handle,'window');
        sz.Cx := 14;
        sz.Cy := 14;
        if FCaption.ButtonPosition = cbpRight then
        begin
          cr := Rect(r.Right - sz.cx - 2, r.Top + 4,r.Right - 2, r.Top + Sz.cY + 4);
          r.Right := r.Right - 14;
        end
        else
        begin
          cr := Rect(r.Left + 2,r.Top + 4, r.Left + sz.cx + 2,r.Top + sz.cy + 4);
          r.Left := r.Left + 14;
        end;
        DrawThemeBackground(HTheme,ACanvas.Handle,WP_CLOSEBUTTON,CS_ACTIVE,@cr,nil);
        CloseThemeData(HTheme);
      end
      else
      begin
        if FCaption.CloseMinGlyph.Empty or FCaption.CloseMaxGlyph.Empty then
        begin

          ACanvas.Pen.Width := 2;
          ACanvas.Pen.Color := FCaption.FCloseButtonColor;

          if FCaption.ButtonPosition = cbpRight then
          begin
            ACanvas.MoveTo(r.Right - 10,r.Top + 4);
            ACanvas.LineTo(r.Right - 4,r.Top + 10);
            ACanvas.MoveTo(r.Right - 4,r.Top + 4);
            ACanvas.LineTo(r.Right - 10,r.Top + 10);
            r.Right := r.Right - 12;
          end
          else
          begin
            ACanvas.MoveTo(r.Left + 4,r.Top + 4);
            ACanvas.MoveTo(r.Left + 4,r.Top + 4);
            ACanvas.LineTo(r.Left + 10,r.Top + 10);
            ACanvas.MoveTo(r.Left + 10,r.Top + 4);
            ACanvas.LineTo(r.Left + 4,r.Top + 10);
            r.Left := r.Left + 12;
          end;

        end
        else
        begin
          if FCollaps then
          begin
            FCaption.CloseMinGlyph.TransparentMode := tmAuto;
            FCaption.CloseMinGlyph.Transparent := true;

            if FCaption.ButtonPosition = cbpRight then
            begin
              ACanvas.Draw(r.Right - FCaption.CloseMinGlyph.Width,r.Top + 2,FCaption.CloseMinGlyph);
              r.Right := r.Right - FCaption.CloseMinGlyph.Width;
            end
            else
            begin
              ACanvas.Draw(r.Left,r.Top + 2,FCaption.CloseMinGlyph);
              r.Left := r.Left + FCaption.CloseMinGlyph.Width;
            end;
          end
          else
          begin
            FCaption.CloseMaxGlyph.TransparentMode := tmAuto;
            FCaption.CloseMaxGlyph.Transparent := true;

            if FCaption.ButtonPosition = cbpRight then
            begin
              ACanvas.Draw(r.Right - FCaption.CloseMaxGlyph.Width,r.Top + 2,FCaption.CloseMaxGlyph);
              r.Right := r.Right - FCaption.CloseMaxGlyph.Width;
            end
            else
            begin
              ACanvas.Draw(r.Left,r.Top + 2,FCaption.CloseMaxGlyph);
              r.Left := r.Left + FCaption.CloseMaxGlyph.Width;
            end;
          end;
        end;
      end;
    end;

    if FCaption.MinMaxButton and FCollaps then
    begin
      if (FCaption.ShadeType = stXPCaption) and DoVisualStyles then
      begin
        HTheme := OpenThemeData(self.Handle,'window');
        sz.Cx := 14;
        sz.Cy := 14;
        if FCaption.ButtonPosition = cbpRight then
          cr := Rect(r.Right - sz.cx - 2, r.Top + 4,r.Right - 2, r.Top + Sz.cY + 4)
        else
          cr := Rect(r.Left + 2, r.Top + 4,r.Left + 2 + sz.cx, r.Top + Sz.cY + 4);

        DrawThemeBackground(HTheme,ACanvas.Handle,WP_MAXBUTTON,CS_ACTIVE,@cr,nil);

        CloseThemeData(HTheme);
      end
      else
      begin
        if FCaption.MaxGlyph.Empty then
        begin
          ACanvas.Pen.Width := 1;
          ACanvas.Pen.Color := FCaption.fMinMaxButtonColor;
          ACanvas.Brush.Color := FCaption.fMinMaxButtonColor;
          if FCaption.ButtonPosition = cbpRight then
            ACanvas.Polygon([point(r.Right-10,r.Top + 5),point(r.right-4,r.top+5),point(r.right-7,r.top+8)])
          else
            ACanvas.Polygon([point(r.Left + 4,r.Top + 5),point(r.Left + 10,r.Top + 5),point(r.Left + 7,r.Top+8)]);
        end
        else
        begin
          FCaption.MaxGlyph.TransparentMode := tmAuto;
          FCaption.MaxGlyph.Transparent := true;
          if FCaption.ButtonPosition = cbpRight then
            ACanvas.Draw(r.Right - FCaption.MaxGlyph.Width,r.Top + 2,FCaption.MaxGlyph)
          else
            ACanvas.Draw(r.Left,r.Top + 2,FCaption.MaxGlyph);
        end;
      end;
    end;

    if FCaption.MinMaxButton and not FCollaps then
    begin
      if (FCaption.ShadeType = stXPCaption) and DoVisualStyles then
      begin
        HTheme := OpenThemeData(self.Handle,'window');
        sz.Cx := 14;
        sz.Cy := 14;

        if FCaption.ButtonPosition = cbpRight then
          cr := Rect(r.Right - sz.cx - 2, r.Top + 4,r.Right - 2, r.Top + Sz.cY + 4)
        else
          cr := Rect(r.Left +  2, r.Top + 4,r.Left + sz.cx + 2, r.Top + Sz.cY + 4);

        DrawThemeBackground(HTheme,ACanvas.Handle,WP_MINBUTTON,CS_ACTIVE,@cr,nil);
        CloseThemeData(HTheme);
      end
      else
      begin
        if FCaption.MinGlyph.Empty then
        begin
          ACanvas.Pen.Width := 1;
          ACanvas.Pen.Color := FCaption.FMinMaxButtonColor;
          ACanvas.Brush.Color := FCaption.FMinMaxButtonColor;
          if FCaption.ButtonPosition = cbpRight then
            ACanvas.Polygon([Point(r.Right-10,r.top+8),point(r.right-4,r.Top+8),Point(r.Right-7,r.Top+5)])
          else
            ACanvas.Polygon([Point(r.Left + 4,r.Top+8),point(r.Left + 10,r.Top+8),Point(r.Left+7,r.Top+5)])

        end
        else
        begin
          FCaption.MinGlyph.TransparentMode := tmAuto;
          FCaption.MinGlyph.Transparent := true;
          if FCaption.ButtonPosition = cbpRight then
            ACanvas.Draw(r.Right - FCaption.MinGlyph.Width,r.Top + 2,FCaption.MinGlyph)
          else
            ACanvas.Draw(r.Left,r.Top + 2,FCaption.MinGlyph)

        end;
      end;
    end;

    if FCaption.ButtonPosition = cbpRight then
    begin
      if FCaption.CloseButton then
        r.Right := r.Right - 20;
      if FCaption.MinMaxButton then
        r.Right := r.Right - 20;
    end
    else
    begin
      if FCaption.CloseButton then
        r.Left := r.Left + 20;
      if FCaption.MinMaxButton then
        r.Left := r.Left + 20;
    end;

    r.Bottom := r.Top + FCaption.Height;

    ACanvas.Font.Assign(FCaption.Font);

    r.Left := r.Left + FCaption.Indent;
    r.Top := r.Top + FCaption.TopIndent;

    HTMLDrawEx(ACanvas,FCaption.Text,r,fImages,0,0,-1,FCaptionHoverHyperLink,FShadowOffset,false,false,false,false,false,fHover,true,1.0,
      FURLColor,FHoverColor,FHoverFontColor,FShadowColor,a,s,fa,xsize,ysize,hl,ml,hr,FImageCache,FContainer);
  end;


  if not Collaps and FCanSize then
  begin
    r := ClientRect;
    if (bevelInner <> bvNone) or (bevelOuter <> bvNone) then
      Inflaterect(r,-2*BevelWidth,-2*BevelWidth);

    if FBorderShadow then
    begin
      r.Right := r.Right - 4;
      r.Bottom := r.Bottom - 4;
    end;

    r.left := r.right - GetSystemMetrics(SM_CXVSCROLL);
    r.top := r.bottom - GetSystemMetrics(SM_CXHSCROLL);

    with ACanvas do
    begin
      Pen.Color := clGray;
      Pen.Width := 2;
      MoveTo(r.right,r.bottom-11);
      Lineto(r.right-11,r.bottom);
      MoveTo(r.right,r.bottom-6);
      Lineto(r.right-7,r.bottom);
      MoveTo(r.right,r.bottom-3);
      Lineto(r.right-3,r.bottom);

      Pen.Color := clWhite;
      Pen.Width := 1;
      MoveTo(r.right,r.bottom - 12);
      Lineto(r.right - 12,r.bottom);
      MoveTo(r.right,r.bottom - 8);
      Lineto(r.right-8,r.bottom);
      MoveTo(r.right,r.bottom-4);
      Lineto(r.right-4,r.bottom);
    end;
  end;


  if FBuffered then
  begin
    Canvas.Draw(0,0,bmp);
    bmp.Free;
  end;

end;
{$WARNINGS ON}

procedure TCustomAdvPanel.SetBackgroundPosition(
  const Value: TBackgroundPosition);
begin
  FBackgroundPosition := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.SetCaption(const Value: TPanelCaption);
begin
  FCaption.Assign(Value);
end;

procedure TCustomAdvPanel.SetImage(const Value: TAdvImage);
begin
  FImage.Assign(Value);
  Invalidate;
end;

procedure TCustomAdvPanel.SetImages(const Value: TImageList);
begin
  FImages := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FImages) then
    FImages := nil;

  if (AOperation = opRemove) and (AComponent = FContainer) then
    FContainer := nil;

  if (AOperation = opRemove) and (AComponent = FStyler) then
    FStyler := nil;

  inherited;
end;

procedure TCustomAdvPanel.SetText(const Value: string);
begin
  FText := Value;
  Invalidate;
  DoAutoSize;
end;

procedure TCustomAdvPanel.SetURLColor(const Value: TColor);
begin
  FURLColor := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.SetCollaps(const Value: boolean);
var
  i,delta: Integer;
begin
  if FCollaps and not Value and Assigned(FOnMaximize) then
    FOnMaximize(Self);
  if not FCollaps and Value and Assigned(FOnMinimize) then
    FOnMinimize(Self);

  if FIsCollapsing then
    Exit;
      
  if Value <> FCollaps then
  begin
    FIsCollapsing := True;
    FCollaps := Value;
    if not (csLoading in ComponentState) then
    begin
      if FCollaps then
      begin
        FFullHeight := Height;
        if FAutoHideChildren then
          ShowHideChildren(False);
        FOldColor := Color;
        if CollapsSteps > 0 then
        begin
          Color := CollapsColor;
          delta := (Height - FCaption.Height) div CollapsSteps;
          for i := 1 to CollapsSteps do
          begin
            Height := Height - delta;
            Application.ProcessMessages;
            Synchronize;
            Sleep(CollapsDelay);
          end;
        end;

        Height := FCaption.Height;
      end
      else
      begin

        if CollapsSteps > 0 then
        begin
          Color := FOldColor;

          delta := (FullHeight - FCaption.Height) div CollapsSteps;

          for i := 1 to CollapsSteps do
          begin
            Height := Height + delta;
            Application.ProcessMessages;
            Synchronize;
            Sleep(CollapsDelay);
          end;
        end;

        Height := FFullHeight;
        if FAutoHideChildren then
          ShowHideChildren(True);
      end;

      Synchronize;
    end;
    FIsCollapsing := False;
  end;
  StateChange;

  if Assigned(FOnEndCollapsExpand) then
    FOnEndCollapsExpand(Self);

end;

procedure TCustomAdvPanel.Loaded;
begin
  inherited;
  
//  FFullHeight := Height;
//  if Collaps then Collaps := Collaps;

  if FPosition.Save then LoadPosition;

  FTopLeft := ClientOrigin;
  FWidthHeight := Point(Width, Height);
  FOldCursor := Cursor;
  FOldColor := Color;
  if Assigned(Styler) then
    AssignStyle(Styler.Settings);
end;

function TCustomAdvPanel.GetHeightEx: integer;
begin
  Result := inherited Height;
end;

procedure TCustomAdvPanel.SetHeightEx(const Value: integer);
begin
  inherited Height := Value;
  if not FCollaps and not FIsCollapsing then
    FFullHeight := Value;
end;

function TCustomAdvPanel.IsAnchor(x, y: integer; var HoverRect: TRect): string;
var
  r,hr: TRect;
  xsize,ysize: Integer;
  a,s,fa: string;
  hl,ml: Integer;
  DrwRes: Boolean;
begin
  Result := '';

  r := Clientrect;

  if (bevelInner <> bvNone) or (bevelOuter <> bvNone) then
  begin
    InflateRect(r,-BevelWidth,-BevelWidth);
  end;



  if FBorderShadow then
  begin
    r.Right := r.Right - 2;
    r.Bottom := r.Bottom - 2;
  end;

  InflateRect(r,-BorderWidth, -BorderWidth);
  

  a := '';

  Canvas.Font.Assign(Font);

  if FTextVAlign in [tvaCenter,tvaBottom] then
  begin
    HTMLDrawEx(Canvas,Text,r,FImages,0,0,-1,fHoverHyperLink,fShadowOffset,true,false,false,false,false,fHover,true,1.0,
      fURLColor,fHoverColor,FHoverFontColor,fShadowColor,a,s,fa,xsize,ysize,hl,ml,hr,FImageCache,FContainer);
  end;

  if FCaption.Visible and (y < FCaption.Height) then
  begin
    r.Bottom := r.Top + FCaption.Height;

    if FTextVAlign in [tvaCenter,tvaBottom] then
    begin
      if ysize < (r.Bottom - r.Top) then
      case FTextVAlign of
      tvaCenter:r.Top := r.Top + (((r.Bottom - r.Top) - ysize) shr 1);
      tvaBottom:r.Top := r.Bottom - ysize;
      end;
    end;
    Canvas.Font.Assign(FCaption.Font);

    r.Left := r.Left + FCaption.Indent;
    r.Top := r.Top + FCaption.TopIndent;

    DrwRes := HTMLDrawEx(Canvas,FCaption.Text,r,fImages,x,y,-1,-1,2,true,false,false,false,false,false,true,1.0,
      FURLColor,clBlue,clRed,clgray,a,s,fa,xsize,ysize,hl,FCaptionHoverHyperlink,hoverrect,FImageCache,FContainer);
  end
  else
  begin
    if FCaption.Visible then
      r.Top := r.Top + FCaption.Height;

    if FTextVAlign in [tvaCenter,tvaBottom] then
    begin
      if ysize < (r.Bottom - r.Top) then
      case fTextVAlign of
      tvaCenter:r.Top := r.top + (((r.Bottom - r.Top) - ysize) shr 1);
      tvaBottom:r.Top := r.bottom - ysize;
      end;
    end;

    Canvas.Font.Assign(Font);

    DrwRes := HTMLDrawEx(Canvas,Text,r,FImages,x,y,-1,-1,2,true,false,false,false,false,false,true,1.0,
      FURLColor,clBlue,clRed,clgray,a,s,fa,xsize,ysize,hl,FHoverHyperlink,hoverrect,FImageCache,FContainer);
  end;

  if DrwRes then
    Result := a;
end;

procedure TCustomAdvPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  hr: TRect;
  Anchor: string;

begin
  inherited;

  Anchor := IsAnchor(x,y,hr);

  FInMove := False;

  if (y < FCaption.Height) and FCaption.Visible then
  begin

    if FHoverHyperLink <> -1 then
    begin
      if FHover then InvalidateRect(Handle,@FCurrHoverRect,True);
      FHoverHyperLink := -1;
      FOldHoverHyperLink := -1;
    end;

    if Anchor <> '' then
    begin
      if (FAnchor <> Anchor) or not Equalrect(FCaptionCurrHoverRect,hr) or
         (FCaptionHoverHyperlink = -1) then
      begin
        if FAnchor <> '' then
          if FHover then InvalidateRect(Handle,@FCaptionCurrHoverRect,True);

        if FHover then InvalidateRect(Handle,@hr,True);
      end;

      if (Cursor = FOldCursor) or (FAnchor <> Anchor) then
      begin
        if FAnchorHint then Application.CancelHint;
        Cursor := crHandPoint;
        if Assigned(FAnchorEnter) then FAnchorEnter(self,anchor);
        if FHover then InvalidateRect(Handle,@hr,true);
       end;

       FAnchor := Anchor;
       FCaptionCurrHoverRect := hr;
     end
    else
    begin
      if Cursor = crHandPoint then
      begin
        Cursor := FOldCursor;
        if Assigned(FAnchorExit) then FAnchorExit(self,anchor);
        FCaptionHoverHyperlink := -1;
        if FHover then InvalidateRect(self.handle,@FCaptionCurrHoverRect,True);
      end;
    end;
  end
  else
  begin
    if FCaptionHoverHyperLink <> -1 then
    begin
      FCaptionHoverHyperlink := -1;
      if FHover then InvalidateRect(self.handle,@FCaptionCurrHoverRect,True);
    end;

    if Anchor <> '' then
    begin
      if (FAnchor <> Anchor) or not Equalrect(FCurrHoverRect,hr) or
         (FHoverHyperlink = -1) or (FHoverHyperLink <> FOldHoverHyperLink) then
      begin
        InflateRect(FCurrHoverRect,1,1);
        if FHover then InvalidateRect(Handle,@FCurrHoverRect,True);
        if FHover then InvalidateRect(Handle,@hr,True);
      end;

      if (Cursor = FOldCursor) or (FAnchor <> Anchor) then
      begin
        if FAnchorHint then Application.CancelHint;
        Cursor := crHandPoint;
        if Assigned(FAnchorEnter) then FAnchorEnter(Self,Anchor);
        if FHover then InvalidateRect(self.handle,@hr,true);
      end;

      FAnchor := Anchor;
      FCurrHoverRect := hr;
      FOldHoverHyperLink := FHoverHyperLink;
    end
    else
    begin
      if (Cursor = crHandPoint) then
      begin
        Cursor := FOldCursor;
        if Assigned(FAnchorExit) then FAnchorExit(Self,Anchor);

        Inflaterect(FCurrHoverRect,1,1);

        FHoverHyperLink := -1;
        FOldHoverHyperLink := -1;

        if FHover then InvalidateRect(Handle,@FCurrHoverRect,True);
      end;
    end;
  end;
end;

procedure TCustomAdvPanel.SetHover(const Value: boolean);
begin
  fHover := Value;
end;

procedure TCustomAdvPanel.CMMouseEnter(var Msg: TMessage);
begin
  inherited;
end;

procedure TCustomAdvPanel.CMMouseLeave(var Msg: TMessage);
begin
 if (FHoverHyperlink>=0) then
   begin
    FHoverHyperlink:=-1;
    inflaterect(fCurrHoverRect,1,1);
    if fHover then invalidaterect(self.handle,@fcurrhoverrect,true);
   end;

 if (FCaptionHoverHyperlink>=0) then
   begin
    FCaptionHoverHyperlink:=-1;
    inflaterect(fCaptionCurrHoverRect,1,1);
    if fHover then invalidaterect(self.handle,@fcaptioncurrhoverrect,true);
   end;

 inherited;
end;

procedure TCustomAdvPanel.SetShadowColor(const Value: TColor);
begin
  FShadowColor := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.SetShadowOffset(const Value: integer);
begin
  FShadowOffset := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.WMNCHitTest(var Msg: TWMNCHitTest);
var
  r: TRect;
  pt: TPoint;
  GW: Integer;

begin
  inherited;

  if (csDesigning in ComponentState) then Exit;

  GW := 12;

  if not FCaption.CloseMinGlyph.Empty and not FCaption.CloseMaxGlyph.Empty then
    GW := FCaption.CloseMinGlyph.Width;

  if not FCaption.MinGlyph.Empty and not FCaption.MaxGlyph.Empty then
    GW := FCaption.MinGlyph.Width;

  if (FCaption.ShadeType = stXPCaption) and DoVisualStyles then
    GW := 16;

  r := ClientRect;
  if FCaption.ButtonPosition = cbpRight then
  begin
    if FCaption.FCloseButton then r.Right := r.Right - GW;
    if FCaption.FMinMaxButton then r.Right := r.Right - GW;
  end
  else
  begin
    if FCaption.FCloseButton then r.Left := r.Left + GW;
    if FCaption.FMinMaxButton then r.Left := r.Left + GW;
  end;

  pt := ScreenToClient(point(msg.xpos,msg.ypos));


  if (pt.y < FCaption.Height) and
     (FCaption.Visible) and
     (pt.x < r.right) and (pt.X > r.Left) and
     (IsAnchor(pt.x,pt.y,r)='') and
     (Msg.Result = htClient) and FCanMove then
  begin
    MouseMove([],pt.X,pt.Y);

    Msg.Result := htCaption;
    FInMove := true;

    SetWindowPos(Handle, HWND_TOP,0,0,0,0,  SWP_NOMOVE or SWP_NOSIZE);
  end;

  if (pt.y > height - GetSystemMetrics(SM_CYHSCROLL)) and
     (pt.x > width - GetSystemMetrics(SM_CXHSCROLL)) and
     (Msg.Result = htClient) and FCanSize and not FCollaps then
  begin
    SetWindowPos(Handle, HWND_TOP,0,0,0,0,  SWP_NOMOVE or SWP_NOSIZE);
    Msg.Result := HTBOTTOMRIGHT;
  end;


end;

procedure TCustomAdvPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TCustomAdvPanel.SetCanSize(const Value: boolean);
begin
  FCanSize := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.SetBorderShadow(const Value: Boolean);
begin
  FBorderShadow := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.SetTextVAlign(const Value: TTextVAlignment);
begin
  FTextVAlign := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.CMHintShow(var Msg: TMessage);
var
  CanShow: Boolean;
  hi: PHintInfo;
  anchor:string;
  hr:trect;

Begin
  CanShow := True;
  hi := PHintInfo(Msg.LParam);

  if FAnchorHint then
  begin
    anchor := IsAnchor(hi^.cursorPos.x,hi^.cursorpos.y,hr);
    if (anchor<>'') then
    begin
      if Assigned(FOnAnchorHint) then
        FOnAnchorHint(self,anchor);

     hi^.HintPos := clienttoscreen(hi^.CursorPos);
     hi^.hintpos.y := hi^.hintpos.y-10;
     hi^.hintpos.x := hi^.hintpos.x+10;
     hi^.HintStr := anchor;
    end;
  end;
 Msg.Result := Ord(Not CanShow);

end;

procedure TCustomAdvPanel.WMEraseBkGnd(var Message: TMessage);
begin
  message.Result := 1;
  Exit;
  inherited;
end;

procedure TCustomAdvPanel.SavePosition;
var
  {$IFDEF DELPHI4_LVL}
  IniFile: TCustomIniFile;
  {$ELSE}
  IniFile: TIniFile;
  {$ENDIF}

begin
  if (FPosition.Key <> '') and
     (FPosition.Section <> '') and
     (not (csDesigning in ComponentState)) then
  begin
    {$IFDEF DELPHI4_LVL}
    if FPosition.Location = clRegistry then
      IniFile := TRegistryIniFile.Create(FPosition.Key)
    else
   {$ENDIF}
      IniFile := TIniFile.Create(FPosition.Key);

    with IniFile do
    begin
      WriteInteger(FPosition.Section,'Top',Top);
      WriteInteger(FPosition.Section,'Left',Left);
      WriteInteger(FPosition.Section,'Height',Height);
      WriteInteger(FPosition.Section,'FullHeight',FFullHeight);
      WriteInteger(FPosition.Section,'Width',Width);
      if Collaps then
        WriteInteger(FPosition.Section,'Collaps',1)
      else
        WriteInteger(FPosition.Section,'Collaps',0);
    end;
    IniFile.Free;
  end;
end;

procedure TCustomAdvPanel.LoadPosition;
var
  {$IFDEF DELPHI4_LVL}
  IniFile: TCustomIniFile;
  {$ELSE}
  IniFile: TInifile;
  {$ENDIF}
begin
  if (FPosition.Key<>'') and
     (FPosition.Section<>'') and
     (not (csDesigning in ComponentState)) then
  begin
    {$IFDEF DELPHI4_LVL}
    if FPosition.Location = clRegistry then
      Inifile := TRegistryIniFile.Create(FPosition.Key)
    else
    {$ENDIF}
      Inifile := TIniFile.Create(FPosition.Key);

    with Inifile do
    begin
      Top := ReadInteger(FPosition.Section,'Top',Top);
      Left := ReadInteger(FPosition.Section,'Left',Left);
      Height := ReadInteger(FPosition.Section,'Height',Height);
      Width := ReadInteger(FPosition.Section,'Width',Width);
      Collaps := ReadInteger(FPosition.Section,'Collaps',0) = 1;
      FFullHeight := ReadInteger(FPosition.Section,'FullHeight',Height);
    end;

    IniFile.Free;
  end;
end;

procedure TCustomAdvPanel.WndProc(var Message: tMessage);
begin
  inherited;
  if Message.Msg = WM_DESTROY then
    if Assigned(FPosition) then
      if FPosition.Save then SavePosition;
end;

procedure TCustomAdvPanel.WMSizing(var Msg: TMessage);
var
  r: PRect;

begin
  if csDesigning in ComponentState then
    inherited
  else
  begin
    r := PRect(msg.LParam);

    if FFixedWidth then
    begin
      r.Right := r.Left + FWidthHeight.X;
    end;

    if FFixedHeight then
    begin
      r.Bottom := r.Top + FWidthHeight.Y;
    end;

    FFullHeight := r.Bottom - r.Top;

    msg.Result := 0;

    if r.Right - r.Left <> Width then
      ShadeHeader;
  end;

end;

procedure TCustomAdvPanel.WMSize(var Msg: TMessage);
begin
  inherited;
  if Width <> FShadedHeader.Width then
    ShadeHeader;

end;

procedure TCustomAdvPanel.WMMoving(var Msg: TMessage);
var
  r: PRect;
  w: Integer;
begin
  FTopLeft := ClientOrigin;

  if csDesigning in ComponentState then
    inherited
  else
  begin
    r := PRect(msg.LParam);
    if FFixedLeft then
    begin
      w := r.Right - r.Left;
      r.Left := FTopLeft.X;
      r.Right := r.Left + w;
    end;

    if FFixedTop then
    begin
      w := r.Bottom - r.Top;
      r.Top := FTopLeft.Y;
      r.Bottom := r.Top + w;
    end;

    msg.Result := 0;
  end;
end;


procedure TCustomAdvPanel.WMExitSizeMove(var Msg: TMessage);
begin
  inherited;
  if Assigned(FOnEndMoveSize) then
    FOnEndMoveSize(Self);
  Synchronize;
end;

procedure TCustomAdvPanel.CreateWnd;
var
  APG: TAdvPanelGroup;
begin
  inherited;
  if (Parent is TAdvPanelGroup) and (csDesigning in ComponentState) then
  begin
    APG := Parent as TAdvPanelGroup;

    if APG.FGroupStyle = gsVertical then
    begin
      Width := APG.Width - 2*APG.HorzPadding;
      Left := APG.HorzPadding;
      if Top < APG.VertPadding then
        Top := APG.VertPadding;
    end;

    if APG.FGroupStyle = gsHorizontal then
    begin
      Height := APG.Height - 2*APG.HorzPadding;
      Top := APG.VertPadding;
      if Left < APG.HorzPadding then
        Left := APG.HorzPadding;
    end;
  end;
end;


procedure TCustomAdvPanel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  i: Integer;
begin
  inherited;
  if csDesigning in ComponentState then
    Synchronize;

  for i := 1 to ControlCount do
  begin
    Controls[i - 1].Invalidate;
  end;

  Invalidate;
end;

procedure TCustomAdvPanel.Synchronize;
begin
  if (Parent is TAdvPanelGroup) then
    with (Parent as TAdvPanelGroup) do
      ChildPanelChanged(Self);
end;

procedure TCustomAdvPanel.WMSetCursor(var Msg: TWMSetCursor);
begin
  inherited;
  if FInMove and FShowMoveCursor then
  begin
    {$IFDEF DELPHI4_LVL}
    SetCursor(Screen.Cursors[crSizeAll]);
    {$ENDIF}
  end;
end;

function TCustomAdvPanel.DoVisualStyles: Boolean;
begin
  if FIsWinXP then
    Result := IsThemeActive
  else
    Result := False;
end;


procedure TCustomAdvPanel.ShowHideChildren(Show: Boolean);
var
  i: Integer;
begin
  for i := 1 to ControlCount do
  begin
    Controls[i - 1].Visible := Show;
  end;
end;

procedure TCustomAdvPanel.WMLDblClk(var Message: TWMLButtonDblClk);
var
  r: TRect;
begin
  inherited;
  if FCaption.Visible then
  begin
    r := ClientRect;
    if PtInRect(rect(r.Left,r.Top,r.Right-2,r.Top + FCaption.Height),point(Message.XPos,Message.YPos)) then
    begin
      if Assigned(FOnCaptionDblClick) then
        FOnCaptionDblClick(Self);
    end;
  end;
end;

procedure TCustomAdvPanel.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('FullHeight', LoadFullHeight, StoreFullHeight, True);
end;

procedure TCustomAdvPanel.LoadFullHeight(Reader: TReader);
begin
  FFullHeight := Reader.ReadInteger;
end;

procedure TCustomAdvPanel.StoreFullHeight(Writer: TWriter);
begin
  Writer.WriteInteger(FFullHeight);
end;


procedure TCustomAdvPanel.AlignControls(AControl: TControl; var Rect: TRect);
begin
  if FCaption.Visible then
  begin
    if Rect.Top < FCaption.Height then
      Rect.Top := FCaption.Height;
  end;
  inherited;
end;

procedure TCustomAdvPanel.SetAutoSizeEx(const Value: TAutoSize);
begin
  FAutoSize.Assign(Value);
end;

procedure TCustomAdvPanel.DoAutoSize;
var
  r: TRect;
  a,s,fa: string;
  hr: TRect;
  hl,ml: Integer;
  XSize,YSize: Integer;
begin
  if not FAutoSize.Enabled then
    Exit;

  r := Rect(0,0,0,0);
  if FAutoSize.Width then
    r.Right := $FFFF
  else
    r.Right := Width - 2 * BevelWidth;

  if FAutoSize.Height then
    r.Bottom := $FFFF
  else
    r.Bottom := Height - 2 * BevelWidth;

  Canvas.Font.Assign(self.Font);

  HTMLDrawEx(Canvas,Text,r,FImages,0,0,-1,FHoverHyperLink,FShadowOffset,false,True,false,false,false,FHover,true,
    1.0,FURLColor,FHoverColor,fHoverFontColor,fShadowColor,a,s,fa,xsize,ysize,hl,ml,hr,FImageCache,FContainer);

  if FAutoSize.Width then
    Width := Xsize + 2 * BevelWidth;

  if FAutoSize.Height then
  begin
    if FCaption.Visible then
      Height := YSize + FCaption.Height + 2 * BevelWidth
    else
      Height := YSize + 2 * BevelWidth;
  end;

  Synchronize;
end;

procedure TCustomAdvPanel.StateChange;
begin

end;

procedure TCustomAdvPanel.Resize;
begin
  Paint;
  inherited Resize;
end;

procedure TCustomAdvPanel.WMPaint(var Msg: TWMPAINT);
var
  DC: HDC;
begin

  DC := GetDC(Handle);

  Canvas.Handle := DC;
  Canvas.Brush.Color := clWhite;

  ReleaseDC(Handle,DC);

  inherited;
end;

procedure TCustomAdvPanel.SetColorTo(const Value: TColor);
begin
  FColorTo := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.SetIndex(const Value: Integer);
begin
  FIndex := Value;
end;

procedure TCustomAdvPanel.Assign(Source: TPersistent);
begin

  AnchorHint := (Source as TCustomAdvPanel).AnchorHint;
//  AutoSize := (Source as TCustomAdvPanel).AutoSize;
  AutoHideChildren := (Source as TCustomAdvPanel).AutoHideChildren;
  Background.Assign((Source as TCustomAdvPanel).Background);
  BackgroundPosition := (Source as TCustomAdvPanel).BackgroundPosition;
  BevelInner := (Source as TCustomAdvPanel).BevelInner;
  BevelOuter := (Source as TCustomAdvPanel).BevelOuter;
  BevelWidth := (Source as TCustomAdvPanel).BevelWidth;
  BorderColor := (Source as TCustomAdvPanel).BorderColor;
  BorderShadow := (Source as TCustomAdvPanel).BorderShadow;
  BorderStyle := (Source as TCustomAdvPanel).BorderStyle;
  CanMove := (Source as TCustomAdvPanel).CanMove;
  CanSize := (Source as TCustomAdvPanel).CanSize;
  Caption.Assign((Source as TCustomAdvPanel).Caption);
//  Collaps := (Source as TCustomAdvPanel).Collaps;
  CollapsColor := (Source as TCustomAdvPanel).CollapsColor;
  CollapsDelay := (Source as TCustomAdvPanel).CollapsDelay;
  CollapsSteps := (Source as TCustomAdvPanel).CollapsSteps;
  Color := (Source as TCustomAdvPanel).Color;
  ColorTo := (Source as TCustomAdvPanel).ColorTo;
  {$IFDEF DELPHI4_LVL}
//  Constraints := (Source as TCustomAdvPanel).Constraints;
  {$ENDIF}
  Cursor := (Source as TCustomAdvPanel).Cursor;
  {$IFDEF DELPHI4_LVL}
//  DockSite := (Source as TCustomAdvPanel).DockSite;
  {$ENDIF}
//  DragCursor := (Source as TCustomAdvPanel).DragCursor;
  {$IFDEF DELPHI4_LVL}
//  DragKind := (Source as TCustomAdvPanel).DragKind;
  {$ENDIF}
//  DragMode := (Source as TCustomAdvPanel).DragMode;
  Enabled := (Source as TCustomAdvPanel).Enabled;
  Font.Assign((Source as TCustomAdvPanel).Font);
  FixedTop := (Source as TCustomAdvPanel).FixedTop;
  FixedLeft := (Source as TCustomAdvPanel).FixedLeft;
  FixedHeight := (Source as TCustomAdvPanel).FixedHeight;
  FixedWidth := (Source as TCustomAdvPanel).FixedWidth;
  FreeOnClose := (Source as TCustomAdvPanel).FreeOnClose;
  Height := (Source as TCustomAdvPanel).Height;
  HelpContext := (Source as TCustomAdvPanel).HelpContext;
  Hint := (Source as TCustomAdvPanel).Hint;
  Hover := (Source as TCustomAdvPanel).Hover;
  HoverColor := (Source as TCustomAdvPanel).HoverColor;
  HoverFontColor := (Source as TCustomAdvPanel).HoverFontColor;
  Images := (Source as TCustomAdvPanel).Images;
//  Locked := (Source as TCustomAdvPanel).Locked;
  ParentColor := (Source as TCustomAdvPanel).ParentColor;
  ParentFont := (Source as TCustomAdvPanel).ParentFont;
  ParentShowHint := (Source as TCustomAdvPanel).ParentShowHint;
  PictureContainer := (Source as TCustomAdvPanel).PictureContainer;
  PopupMenu := (Source as TCustomAdvPanel).PopupMenu;
  Position := (Source as TCustomAdvPanel).Position;
  ShadowColor := (Source as TCustomAdvPanel).ShadowColor;
  ShadowOffset := (Source as TCustomAdvPanel).ShadowOffset;
  ShowHint := (Source as TCustomAdvPanel).ShowHint;
  ShowMoveCursor := (Source as TCustomAdvPanel).ShowMoveCursor;
  TabStop := (Source as TCustomAdvPanel).TabStop;
  Tag := (Source as TCustomAdvPanel).Tag;
  Text := (Source as TCustomAdvPanel).Text;
  TextVAlign := (Source as TCustomAdvPanel).TextVAlign;
  URLColor := (Source as TCustomAdvPanel).URLColor;
  {$IFDEF DELPHI4_LVL}
//  UseDockManager := (Source as TCustomAdvPanel).UseDockManager;
  {$ENDIF}
  Visible := (Source as TCustomAdvPanel).Visible;
end;

procedure TCustomAdvPanel.CaptionChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TCustomAdvPanel.CaptionShadeChange(Sender: TObject);
begin
  ShadeHeader;
end;

procedure TCustomAdvPanel.CaptionStateChange(Sender: TObject);
begin
  StateChange;
end;

procedure TCustomAdvPanel.AssignSettings(Settings: TAdvPanelSettings);
begin
  AssignStyle(Settings);
  Height := Settings.Height;
  Width := Settings.Width;
  Hint := Settings.Hint;
end;

procedure TCustomAdvPanel.AssignStyle(Settings: TAdvPanelSettings);
begin
  AnchorHint := Settings.AnchorHint;
  AutoHideChildren := Settings.AutoHideChildren;
  BevelInner := Settings.BevelInner;
  BevelOuter := Settings.BevelOuter;
  BevelWidth := Settings.BevelWidth;
  BorderColor := Settings.BorderColor;
  BorderShadow := Settings.BorderShadow;
  BorderStyle := Settings.BorderStyle;
  BorderWidth := Settings.BorderWidth;
  CanMove := Settings.CanMove;
  CanSize := Settings.CanSize;
  Caption.Assign(Settings.Caption);
  Collaps := Settings.Collaps;
  CollapsColor := Settings.CollapsColor;
  CollapsDelay := Settings.CollapsDelay;
  CollapsSteps := Settings.CollapsSteps;
  Color := Settings.Color;
  ColorTo := Settings.ColorTo;
  Cursor := Settings.Cursor;
  Font.Assign(Settings.Font);
  FixedTop := Settings.FixedTop;
  FixedLeft := Settings.FixedLeft;
  FixedHeight := Settings.FixedHeight;
  FixedWidth := Settings.FixedWidth;
  Hover := Settings.Hover;
  HoverColor := Settings.HoverColor;
  HoverFontColor := Settings.HoverFontColor;
  Indent := Settings.Indent;
  Position := Settings.Position;
  ShadowColor := Settings.ShadowColor;
  ShadowOffset := Settings.ShadowOffset;
  ShowHint := Settings.ShowHint;
  ShowMoveCursor := Settings.ShowMoveCursor;
  // Text := Settings.Text;
  TextVAlign := Settings.TextVAlign;
  TopIndent := Settings.TopIndent;
  URLColor := Settings.URLColor;
end;


procedure TCustomAdvPanel.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.SetTopIndent(const Value: Integer);
begin
  FTopIndent := Value;
  Invalidate;
end;

procedure TCustomAdvPanel.SetStyler(const Value: TAdvPanelStyler);
begin
  FStyler := Value;
  if not (csLoading in ComponentState) then
    if Assigned(FStyler) then
      if Assigned(FStyler.Settings) then
        AssignStyle(FStyler.Settings);
end;



{ TPanelCaption }

procedure TPanelCaption.Assign(Source: TPersistent);
begin
  Background.Assign((Source as TPanelCaption).Background);
  ButtonPosition := (Source as TPanelCaption).ButtonPosition;
  Color := (Source as TPanelCaption).Color;
  ColorTo := (Source as TPanelCaption).ColorTo;
  CloseColor := (Source as TPanelCaption).CloseColor;
  CloseButton := (Source as TPanelCaption).CloseButton;
  CloseButtonColor := (Source as TPanelCaption).CloseButtonColor;
  CloseMinGlyph.Assign((Source as TPanelCaption).CloseMinGlyph);
  CloseMaxGlyph.Assign((Source as TPanelCaption).CloseMaxGlyph);
  Flat := (Source as TPanelCaption).Flat;
  Font.Assign((Source as TPanelCaption).Font);
  Height := (Source as TPanelCaption).Height;
  Indent := (Source as TPanelCaption).Indent;
  MaxGlyph.Assign((Source as TPanelCaption).MaxGlyph);
  MinGlyph.Assign((Source as TPanelCaption).MinGlyph);
  MinMaxButton := (Source as TPanelCaption).MinMaxButton;
  MinMaxButtonColor := (Source as TPanelCaption).MinMaxButtonColor;
  ShadeLight := (Source as TPanelCaption).ShadeLight;
  ShadeGrain := (Source as TPanelCaption).ShadeGrain;
  ShadeType := (Source as TPanelCaption).ShadeType;
  Shape := (Source as TPanelCaption).Shape;
  // Text := (Source as TPanelCaption).Text;
  TopIndent := (Source as TPanelCaption).TopIndent;
  Visible := (Source as TPanelCaption).Visible;
end;

procedure TPanelCaption.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TPanelCaption.Create;
begin
  inherited Create;
  FFont := TFont.Create;
  FColor := clHighlight;
  FCloseColor := clBtnFace;
  FHeight := 20;
  FMinMaxButtonColor := clBlack;
  FCloseButtonColor := clBlack;
  FFont.OnChange := FontChanged;
  FFont.Color := clHighLightText;
  FCloseMinGlyph := TBitmap.Create;
  FCloseMaxGlyph := TBitmap.Create;
  FCloseButtonColor := clWhite;
  FMinMaxButtonColor := clWhite;
  FMinGlyph := TBitmap.Create;
  FMaxGlyph := TBitmap.Create;
  FShadeLight := 200;
  FShadeGrain := 32;
  FBackground := TBitmap.Create;
  FColorTo := clNone;
end;

destructor TPanelCaption.Destroy;
begin
  FFont.Free;
  FCloseMinGlyph.Free;
  FCloseMaxGlyph.Free;
  FMinGlyph.Free;
  FMaxGlyph.Free;
  FBackground.Free;
  inherited;
end;

procedure TPanelCaption.FontChanged(Sender: TObject);
begin
  Changed;
end;

procedure TPanelCaption.SetBackground(const Value: TBitmap);
begin
  FBackground.Assign(Value);
  ShadeChanged;
end;

procedure TPanelCaption.SetCaptionShape(const Value: TCaptionShape);
begin
  FShape := Value;
  ShadeChanged;
end;

procedure TPanelCaption.SetCloseButton(const Value: boolean);
begin
  if (FCloseButton <> Value) then
  begin
    FCloseButton := Value;
    Changed;
  end;
end;

procedure TPanelCaption.SetCloseButtonColor(const Value: TColor);
begin
  if (fCloseButtonColor <> Value) then
  begin
    FCloseButtonColor := Value;
    Changed;
  end;
end;

procedure TPanelCaption.SetCloseColor(const Value: TColor);
begin
  if FCloseColor <> Value then
  begin
    FCloseColor := Value;
    Changed;
  end;
end;

procedure TPanelCaption.SetCloseMaxGlyph(const Value: TBitmap);
begin
  FCloseMaxGlyph.Assign(Value);
  Changed;
end;

procedure TPanelCaption.SetCloseMinGlyph(const Value: TBitmap);
begin
  FCloseMinGlyph.Assign(Value);
  Changed;
end;

procedure TPanelCaption.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    ShadeChanged;
  end;
end;

procedure TPanelCaption.SetColorTo(const Value: TColor);
begin
  FColorTo := Value;
  Changed;
end;

procedure TPanelCaption.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
  ShadeChanged;
end;

procedure TPanelCaption.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  Changed;
end;

procedure TPanelCaption.SetHeight(const Value: integer);
begin
  if (FHeight <> Value) then
  begin
    FHeight := Value;
    Changed;
  end;
end;

procedure TPanelCaption.SetIndent(const Value: Integer);
begin
  if FIndent <> Value then
  begin
    FIndent := Value;
    Changed;
  end;  
end;

procedure TPanelCaption.SetMaxGlyph(const Value: TBitmap);
begin
  FMaxGlyph.Assign(Value);
end;

procedure TPanelCaption.SetMinGlyph(const Value: TBitmap);
begin
  FMinGlyph.Assign(Value);
end;

procedure TPanelCaption.SetMinMaxButton(const Value: boolean);
begin
  if FMinMaxButton <> Value then
  begin
    FMinMaxButton := Value;
    Changed;
  end;
end;

procedure TPanelCaption.SetMinMaxButtonColor(const Value: TColor);
begin
  if FMinMaxButtonColor <> Value then
  begin
    FMinMaxButtonColor := Value;
    Changed;
  end;
end;

procedure TPanelCaption.SetShadeGrain(const Value: Byte);
begin
  FShadeGrain := Value;
  ShadeChanged;
end;

procedure TPanelCaption.SetShadeLight(const Value: Integer);
begin
  if Value < 200 then
    FShadeLight := 200
  else
    FShadeLight := Value;
  ShadeChanged;
end;

procedure TPanelCaption.SetShadeType(const Value: TShadeType);
begin
  FShadeType := Value;
  ShadeChanged;
end;

procedure TPanelCaption.SetText(const Value: string);
begin
  FText := Value;
  Changed;
end;

procedure TPanelCaption.SetTopIndent(const Value: Integer);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    Changed;
  end;
end;

procedure TPanelCaption.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  Changed;
  StateChanged;
end;

procedure TPanelCaption.ShadeChanged;
begin
  if Assigned(FOnShadeChange) then
    FOnShadeChange(Self);
  //FOwner.ShadeHeader;
  Changed;
end;

procedure TPanelCaption.StateChanged;
begin
  if Assigned(FOnStateChange) then
    FOnStateChange(Self);
end;

{ TPanelPosition }

procedure TPanelPosition.Assign(Source: TPersistent);
begin
  Key := (Source as TPanelPosition).Key;
  Section := (Source as TPanelPosition).Section;
  Save := (Source as TPanelPosition).Save;
  Location := (Source as TPanelPosition).Location;
end;

constructor TPanelPosition.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TPanelPosition.Destroy;
begin
  inherited;
end;

{ TCustomAdvPanelGroup }

procedure TAdvPanelGroup.ArrangeControlsVert;
var
  PL: TList;
  i, T1,T2,H: Integer;
  Sorted: Boolean;
  S: Pointer;

begin
  PL := TList.Create;

  for i := 1 to ControlCount do
  begin
    if (Controls[i - 1] is TCustomAdvPanel) then
      PL.Add(Controls[i - 1]);
  end;

  Sorted := False;

  // perform a simple bubble sort, nr. of subpanels should be small

  while not Sorted do
  begin
    Sorted := True;
    for i := 2 to PL.Count do
    begin
      if FCode then
      begin
        T1 := TCustomAdvPanel(PL.Items[i - 2]).Index;
        T2 := TCustomAdvPanel(PL.Items[i - 1]).Index;
      end
      else
      begin
        T1 := TCustomAdvPanel(PL.Items[i - 2]).Top;
        T2 := TCustomAdvPanel(PL.Items[i - 1]).Top;
      end;

      if T1 > T2 then
      begin
        Sorted := False;
        S := PL.Items[i - 2];
        PL.Items[i - 2] := PL.Items[i - 1];
        PL.Items[i - 1] := S;
      end;
    end;
  end;

  H := VertPadding;

  if Assigned(FScrollBar) then
  begin
    if FScrollBar.Visible then
      H := VertPadding - FScrollBar.Position;
  end;

  if Assigned(Caption) then
  begin
    if Caption.Visible then
      H := H + Caption.Height;
  end;

  for i := 1 to PL.Count do
  begin
    TCustomAdvPanel(PL.Items[i - 1]).Top := H;


    if FScrollBar.Visible then
    begin
      TCustomAdvPanel(PL.Items[i - 1]).Left := HorzPadding + ((Width - FScrollBar.Width - HorzPadding) div Columns) * ((i - 1) mod Columns);
      TCustomAdvPanel(PL.Items[i - 1]).Width := (Width - 2* HorzPadding - FScrollBar.Width) div Columns
    end
    else
    begin
      TCustomAdvPanel(PL.Items[i - 1]).Left := HorzPadding + ((Width - HorzPadding) div Columns) * ((i - 1) mod Columns);
      TCustomAdvPanel(PL.Items[i - 1]).Width := (Width - 2* HorzPadding) div Columns;
    end;

    if TCustomAdvPanel(PL.Items[i - 1]).Visible then
      if (i mod Columns = 0) then
        H := H + TCustomAdvPanel(PL.Items[i - 1]).Height + VertPadding;
  end;

  PL.Free;

end;

procedure TAdvPanelGroup.ArrangeControlsHorz;
var
  PL: TList;
  i, T1,T2,H: Integer;
  Sorted: Boolean;
  S: Pointer;
begin
  PL := TList.Create;

  for i := 1 to ControlCount do
  begin
    if (Controls[i - 1] is TCustomAdvPanel) then
      PL.Add(Controls[i - 1]);
  end;

  Sorted := False;

  // perform a simple bubble sort, nr. of subpanels should be small

  while not Sorted do
  begin
    Sorted := True;
    for i := 2 to PL.Count do
    begin
      T1 := TCustomAdvPanel(PL.Items[i - 2]).Left;
      T2 := TCustomAdvPanel(PL.Items[i - 1]).Left;
      if T1 > T2 then
      begin
        Sorted := False;
        S := PL.Items[i - 2];
        PL.Items[i - 2] := PL.Items[i - 1];
        PL.Items[i - 1] := S;
      end;
    end;
  end;

  H := HorzPadding;

  if Assigned(FScrollBar) then
  begin
  if not FScrollBar.Visible then
    H := HorzPadding
  else
    H := HorzPadding - FScrollBar.Position;
  end;

  for i := 1 to PL.Count do
  begin
    TCustomAdvPanel(PL.Items[i - 1]).Left := H;
    TCustomAdvPanel(PL.Items[i - 1]).Top := VertPadding;

    if FScrollBar.Visible then
      TCustomAdvPanel(PL.Items[i - 1]).Height := Height - 2* VertPadding - FScrollBar.Height
    else
      TCustomAdvPanel(PL.Items[i - 1]).Height := Height - 2* VertPadding;

    if TCustomAdvPanel(PL.Items[i - 1]).Visible then
      H := H + TCustomAdvPanel(PL.Items[i - 1]).Width + HorzPadding;
  end;

  PL.Free;
end;

procedure TAdvPanelGroup.ArrangeControls;
begin
  if (csLoading in ComponentState) then
    Exit;

  if FIsArranging then
    Exit;
  if FUpdateCount > 0 then
    Exit;

  FIsArranging := True;
  if GroupStyle = gsVertical then
    ArrangeControlsVert
  else
    ArrangeControlsHorz;
  FIsArranging := False;
end;

procedure TAdvPanelGroup.ChildPanelChanged(APanel: TCustomAdvPanel);
begin
  UpdateScrollBar;
  ArrangeControls;
end;

constructor TAdvPanelGroup.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls];
  FScrollBar := TScrollBar.Create(nil);
  FScrollBar.Parent := Self;
  FScrollBar.Align := alRight;

  FScrollBar.Position := 0;
  FScrollBar.Kind := sbVertical;
  FScrollBar.OnChange := Scroll;
  FScrollBar.Visible := False;
  FScrollBar.LargeChange := 20;
  FScrollBar.SmallChange := 2;
  FScrollBar.TabStop := False;

  FHorzPadding := 8;
  FVertPadding := 8;
  FPanels := TList.Create;

  FColumns := 1;
  FDefaultPanel := TAdvPanelSettings.Create;
end;

procedure TAdvPanelGroup.SetGroupStyle(const Value: TGroupStyle);
begin
  if FGroupStyle <> Value then
  begin
    FGroupStyle := Value;
    UpdateScrollBar;
    ArrangeControls;
  end;
end;

procedure TAdvPanelGroup.SetHorzPadding(const Value: Integer);
begin
  if FHorzPadding <> Value then
  begin
    FHorzPadding := Value;
    ArrangeControls;
  end;
end;

procedure TAdvPanelGroup.SetVertPadding(const Value: Integer);
begin
  if FVertPadding <> Value then
  begin
    FVertPadding := Value;
    ArrangeControls;
  end;
end;

procedure TAdvPanelGroup.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  ArrangeControls;
end;

destructor TAdvPanelGroup.Destroy;
var
  i: Integer;
begin
  for i := 1 to FPanels.Count do
    TCustomAdvPanel(FPanels[i - 1]).Free;
  FPanels.Free;
  FScrollBar.Free;
  FDefaultPanel.Free;
  inherited;
end;

procedure TAdvPanelGroup.Scroll(Sender: TObject);
begin
  if FScrollbar.Position > FScrollbar.Max - FScrollbar.Pagesize then
    FScrollbar.Position := FScrollbar.Max - FScrollbar.Pagesize;
  ArrangeControls;
end;

function TAdvPanelGroup.PanelHeights: Integer;
var
  H, i: Integer;
begin
  H := VertPadding;

  for i := 1 to ControlCount do
  begin
    if (Controls[i - 1] is TCustomAdvPanel) then
      if TCustomAdvPanel(Controls[i - 1]).Visible then
        if (i mod Columns = 0) then
          H := H + TCustomAdvPanel(Controls[i - 1]).Height + VertPadding;
  end;

  Result := H;
end;

function TAdvPanelGroup.PanelWidths: Integer;
var
  W, i: Integer;
begin
  W := HorzPadding;
  for i := 1 to ControlCount do
  begin
    if (Controls[i - 1] is TCustomAdvPanel) then
      if TCustomAdvPanel(Controls[i - 1]).Visible then
        W := W + TCustomAdvPanel(Controls[i - 1]).Width +  HorzPadding;
  end;

  Result := W;
end;

procedure TAdvPanelGroup.Loaded;
begin
  inherited;
  UpdateScrollBar;
  ArrangeControls;
end;

procedure TAdvPanelGroup.UpdateScrollbar;
var
  TH: Integer;
begin
  if FUpdateCount > 0 then
    Exit;

  if GroupStyle = gsVertical then
  begin
    if FScrollBar.Kind = sbHorizontal then
    begin
      FScrollBar.Kind := sbVertical;
    end;

    FScrollBar.Width := 16;
    TH := PanelHeights;
    if (TH > Height) and (TH > 0) then
    begin
      if FScrollBar.Position > TH then
        FScrollBar.Position := TH;
      FScrollBar.PageSize := Height;
      FScrollBar.Max := TH;
    end;
    FScrollBar.Visible := TH > Height;
    FScrollBar.Invalidate;
  end
  else
  begin
    if FScrollBar.Kind = sbVertical then
      FScrollBar.Kind := sbHorizontal;

    if FScrollBar.Align = alRight then
    begin
      FScrollBar.Align := alBottom;
    end;
    FScrollBar.Height := 16;

    TH := PanelWidths;
    if TH > Width then
    begin
      if FScrollBar.Position > TH then
        FScrollBar.Position := TH;
      FScrollBar.PageSize := Width;
      FScrollBar.Max := TH;
    end;

    FScrollBar.Visible := TH > Width;
    FScrollBar.Invalidate;
  end;
end;

procedure TAdvPanelGroup.CloseAllPanels;
var
  i: Integer;
begin
  BeginUpdate;
  for i := 1 to ControlCount do
  begin
    if (Controls[i - 1] is TCustomAdvPanel) then
      TCustomAdvPanel(Controls[i - 1]).Collaps := True;
  end;
  EndUpdate;
end;

procedure TAdvPanelGroup.OpenAllPanels;
var
  i: Integer;
begin
  BeginUpdate;
  for i := 1 to ControlCount do
  begin
    if (Controls[i - 1] is TCustomAdvPanel) then
      TCustomAdvPanel(Controls[i - 1]).Collaps := False;
  end;
  EndUpdate;
end;

procedure TAdvPanelGroup.WMSize(var Msg: TMessage);
begin
  inherited;
  UpdateScrollBar;
end;

procedure TAdvPanelGroup.LoadPanelPositions;
var
  i: Integer;
  pp: TPanelPosition;
  ap: TCustomAdvPanel;
begin
  pp := TPanelPosition.Create(Self);

  for i := 1 to ControlCount do
  begin
    if (Controls[i - 1] is TCustomAdvPanel) then
    begin
      ap := TCustomAdvPanel(Controls[i - 1]);
      PP.Assign(ap.Position);
      ap.Position.Assign(Self.Position);
      ap.Position.Section := ap.Name;
      ap.LoadPosition;
      ap.Position.Assign(pp);
    end;
  end;

  PP.Free;
end;

procedure TAdvPanelGroup.SavePanelPositions;
var
  i: Integer;
  pp: TPanelPosition;
  ap: TCustomAdvPanel;
begin
  pp := TPanelPosition.Create(Self);

  for i := 1 to ControlCount do
  begin
    if (Controls[i - 1] is TCustomAdvPanel) then
    begin
      ap := TCustomAdvPanel(Controls[i - 1]);
      PP.Assign(ap.Position);
      ap.Position.Assign(Self.Position);
      ap.Position.Section := ap.Name;
      ap.SavePosition;
      ap.Position.Assign(pp);
    end;
  end;
  PP.Free;
end;

procedure TAdvPanelGroup.StateChange;
begin
  inherited;
  ArrangeControls;
  UpdateScrollBar;
end;

procedure TAdvPanelGroup.UpdateGroup;
begin
  ArrangeControls;
  UpdateScrollBar;
  Height := Height + 1;
  Height := Height - 1;
end;

procedure TAdvPanelGroup.Clear;
var
  i: Integer;
begin
  i := 0;
  while (i < ControlCount) do
  begin
    if (Controls[i] is TCustomAdvPanel) then
      Controls[i - 1].Free
    else
      inc(i);
  end;
end;

function TAdvPanelGroup.AddPanel: TCustomAdvPanel;
begin
  Result := TCustomAdvPanel.Create(Self);
  Result.Parent := Self;
  Result.AssignSettings(DefaultPanel);
  Result.Index := FPanels.Count;
  FPanels.Add(Pointer(Result));
  UpdateScrollbar;
  ArrangeControls;
  UpdateScrollbar;
end;

function TAdvPanelGroup.InsertPanel(Index: Integer): TCustomAdvPanel;
var
  i: Integer;
begin
  Result := TCustomAdvPanel.Create(Self);
  Result.Parent := Self;
  Result.AssignSettings(DefaultPanel);
  Result.Index := Index;
  FPanels.Insert(Index,Pointer(Result));

  for i := 1 to FPanels.Count do
  begin
    TCustomAdvPanel(FPanels[i - 1]).Index := i - 1;
  end;

  UpdateScrollBar;
  ArrangeControls;
  UpdateScrollBar;
end;

procedure TAdvPanelGroup.RemovePanel(Index: Integer);
var
  i: Integer;
begin
  if (Index < FPanels.Count) and (Index >= 0) then
  begin
    TCustomAdvPanel(FPanels[Index]).Free;
    FPanels.Delete(Index);

    for i := 1 to FPanels.Count do
    begin
      TCustomAdvPanel(FPanels[i - 1]).Index := i - 1;
    end;
    ArrangeControls;
  end;
end;

function TAdvPanelGroup.GetPanel(Index: Integer): TCustomAdvPanel;
begin
  Result := TCustomAdvPanel(FPanels[Index]);
end;

procedure TAdvPanelGroup.SetPanel(Index: Integer; const Value: TCustomAdvPanel);
begin
  TCustomAdvPanel(FPanels[Index]).Assign(Value);
end;

procedure TAdvPanelGroup.MovePanel(FromIndex, ToIndex: Integer);
var
  i: Integer;
begin
  FPanels.Move(FromIndex,ToIndex);
  for i := 1 to FPanels.Count do
  begin
    TCustomAdvPanel(FPanels[i - 1]).Index := i - 1;
  end;
  FCode := True;
  ArrangeControls;
  FCode := False;  
end;

procedure TAdvPanelGroup.SetDefaultPanel(const Value: TAdvPanelSettings);
begin
  FDefaultPanel.Assign(Value);
end;

procedure TAdvPanelGroup.BeginUpdate;
begin
  SendMessage(Handle,WM_SETREDRAW,Integer(False),0);
  inc(FUpdateCount);
end;

procedure TAdvPanelGroup.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    dec(FUpdateCount);
    if FUpdateCount = 0 then
    begin
      SendMessage(Handle,WM_SETREDRAW,Integer(True),0);
      UpdateScrollBar;
      ArrangeControls;
      UpdateScrollBar;
    end;
  end;
end;

procedure TAdvPanelGroup.SetColumns(const Value: Integer);
begin
  if (Value >= 1) then
  begin
    FColumns := Value;
    UpdateScrollBar;
    ArrangeControls;
    UpdateScrollBar;    
  end;
end;

{ TAutoSize }

procedure TAutoSize.Assign(Source: TPersistent);
begin
  Enabled := (Source as TAutoSize).Enabled;
  Height := (Source as TAutoSize).Height;
  Width := (Source as TAutoSize).Width;
end;

constructor TAutoSize.Create(AOwner: TCustomAdvPanel);
begin
  inherited Create;
  FOwner := TCustomAdvPanel(AOwner);
  FHeight := True;
  FWidth := True;
end;

procedure TAutoSize.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  if FEnabled then
    FOwner.DoAutoSize;
end;


{ TCustomAdvPanelSettings }

procedure TAdvPanelSettings.Assign(Source: TPersistent);
begin

end;

procedure TAdvPanelSettings.Changed;
begin
  if FUpdateCount = 0 then
    if Assigned(FOnChange) then
      FOnChange(Self);
end;

procedure TAdvPanelSettings.CaptionChanged(Sender: TObject);
begin
  if FUpdateCount = 0 then
    if Assigned(FOnChange) then
      FOnChange(Self);
end;


constructor TAdvPanelSettings.Create;
begin
  inherited Create;
  FCaption := TPanelCaption.Create;
  FCaption.OnChange := CaptionChanged;
  FColor := clBtnFace;
  FColorTo := clNone;
  FHeight := 120;
  FBorderStyle := bsSingle;
  FFont := TFont.Create;
  FBevelWidth := 1;
  FCollapsColor := clBtnFace;
  FURLColor := clBlue;
  FUpdateCount := 0;
end;

destructor TAdvPanelSettings.Destroy;
begin
  FFont.Free;
  FCaption.Free;
  inherited;
end;

procedure TAdvPanelSettings.SetAnchorHint(const Value: Boolean);
begin
  FAnchorHint := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetAutoHideChildren(const Value: Boolean);
begin
  FAutoHideChildren := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetBevelInner(const Value: TBevelCut);
begin
  FBevelInner := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetBevelOuter(const Value: TBevelCut);
begin
  FBevelOuter := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetBevelWidth(const Value: Integer);
begin
  FBevelWidth := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetBorderShadow(const Value: Boolean);
begin
  FBorderShadow := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetCanMove(const Value: Boolean);
begin
  FCanMove := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetCanSize(const Value: Boolean);
begin
  FCanSize := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetCaption(const Value: TPanelCaption);
begin
  FCaption := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetCollaps(const Value: Boolean);
begin
  FCollaps := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetCollapsColor(const Value: TColor);
begin
  FCollapsColor := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetCollapsDelay(const Value: Integer);
begin
  FCollapsDelay := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetCollapsSteps(const Value: Integer);
begin
  FCollapsSteps := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetColorTo(const Value: TColor);
begin
  FColorTo := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetCursor(const Value: TCursor);
begin
  FCursor := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetFont(const Value: TFont);
begin
  FFont := Value;
  Changed;
end;



procedure TAdvPanelSettings.SetHover(const Value: Boolean);
begin
  FHover := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetHoverColor(const Value: TColor);
begin
  FHoverColor := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetHoverFontColor(const Value: TColor);
begin
  FHoverFontColor := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetText(const Value: string);
begin
  FText := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetTextVAlign(const Value: TTextVAlignment);
begin
  FTextVAlign := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetTopIndent(const Value: Integer);
begin
  FTopIndent := Value;
  Changed;
end;

procedure TAdvPanelSettings.SetURLColor(const Value: TColor);
begin
  FURLColor := Value;
  Changed;
end;

procedure TAdvPanelSettings.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TAdvPanelSettings.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    dec(FUpdateCount);
    if FUpdateCount = 0 then
      Changed;
  end;
end;

procedure TAdvPanelSettings.SetBorderWidth(const Value: Integer);
begin
  FBorderWidth := Value;
  Changed;
end;

{ TCustomAdvPanelStyler }

procedure TAdvPanelStyler.Changed(Sender: TObject);
var
  i: Integer;
begin
  if csLoading in ComponentState then
    Exit;
  
  for i := 1 to Owner.ComponentCount do
    if (Owner.Components[i - 1] is TCustomAdvPanel) then
    begin
      if TCustomAdvPanel(Owner.Components[i - 1]).Styler = Self then
        TCustomAdvPanel(Owner.Components[i - 1]).AssignStyle(Settings);
    end;
end;

constructor TAdvPanelStyler.Create(AOwner: TComponent);
begin
  inherited;
  FSettings := TAdvPanelSettings.Create;
  FSettings.OnChange := Changed;
  SetStyle(psXP);
end;

destructor TAdvPanelStyler.Destroy;
begin
  FSettings.Free;
  inherited;
end;

procedure TAdvPanelStyler.SetSettings(const Value: TAdvPanelSettings);
begin
  FSettings := Value;
end;

procedure TAdvPanelStyler.SetStyle(const Value: TAdvPanelStyle);
begin
  if csLoading in ComponentState then
    Exit;
  FStyle := Value;
  Settings.BeginUpdate;
  case FStyle of
  psXP:
    with Settings do
    begin
      Color := clWhite;
      ColorTo := $00E3F0F2;
      Font.Name := 'Verdana';
      Caption.Font.Name := 'Verdana';
      Caption.Font.Color := clHighLightText;
      Caption.ShadeType := stNormal;
      BevelInner := bvNone;
      BevelOuter := bvNone;
      BorderColor := clGray;
      BorderShadow := True;
      BorderStyle := bsNone;
      CollapsColor := clBtnFace;
      Caption.Color := clHighLight;
      Caption.ColorTo := clBlue;
      Caption.Visible := True;
      Caption.FHeight := 20;
      Caption.Indent := 2;
    end;
  psFlat:
    with Settings do
    begin
      Color := clBtnFace;
      ColorTo := clNone;
      Font.Name := 'Tahoma';
      Font.Color := clWindowText;
      Caption.Font.Name := 'Tahoma';
      Caption.Font.Color := clHighLightText;
      Caption.ShadeType := stNormal;      
      BevelInner := bvNone;
      BevelOuter := bvNone;
      BorderColor := clGray;
      BorderShadow := False;
      BorderStyle := bsNone;
      CollapsColor := clBtnFace;
      Caption.Color := clHighLight;
      Caption.ColorTo := clNone;
      Caption.Visible := True;
      Caption.Height := 20;
      Caption.Indent := 0;
    end;
  psTMS:
    with Settings do
    begin
      Color := clWhite;
      ColorTo := $00E4E4E4;
      Caption.ShadeGrain := 32;
      Caption.ShadeLight := 255;
      Caption.ShadeType := stRMetal;
      Font.Name := 'Tahoma';
      Font.Color := clWindowText;
      Caption.Font.Name := 'Tahoma';
      Caption.Font.Color := clBlack;
      Caption.Indent := 4;
      BevelInner := bvNone;
      BevelOuter := bvNone;
      BorderColor := clGray;
      BorderShadow := True;
      BorderStyle := bsNone;
      CollapsColor := clBtnFace;
      Caption.Color := clWhite;
      Caption.ColorTo := clNone;
      Caption.Visible := True;
      Caption.FHeight := 20;
    end;
  psClassic:
    with Settings do
    begin
      Color := clBtnFace;
      ColorTo := clNone;
      Caption.ShadeGrain := 32;
      Caption.ShadeLight := 255;
      Caption.ShadeType := stNormal;
      Font.Name := 'MS Sans Serif';
      Font.Color := clWindowText;
      Caption.Font.Name := 'MS Sans Serif';
      Caption.Font.Color := clHighLightText;
      BevelInner := bvNone;
      BevelOuter := bvRaised;
      BorderColor := clGray;
      BorderShadow := False;
      BorderStyle := bsNone;
      CollapsColor := clBtnFace;
      Caption.Color := clWhite;
      Caption.ColorTo := clNone;
      Caption.Visible := False;
    end;
  end;
  Settings.EndUpdate;    
end;



initialization

end.
