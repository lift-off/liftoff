{********************************************************************}
{ TAdvDBLookupComboBox component                                     }
{ for Delphi & C++Builder                                            }
{ version 1.2                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2002 - 2003                                 }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The component can be freely used in any application. The source    }
{ code remains property of the author and may not be distributed     }
{ freely as such.                                                    }
{********************************************************************}

unit AdvDBLookupComboBox;

{$I TMSDEFS.INC}

interface

uses Windows, Classes, StdCtrls, ExtCtrls, Controls, Messages, SysUtils,
  Forms, Graphics, Buttons, Grids, DB, Dialogs, Math
  {$IFDEF DELPHI6_LVL}
  , Variants
  {$ENDIF}
  ;

type
  TAdvDBLookupComboBox = class;

  TFindList = class(TStringlist)
  private
    BaseIndex: Integer;
    KeyField :String;
    FGrid: TAdvDBLookupComboBox;
  public
    constructor Create(Agrid:TAdvDBLookupComboBox);
    destructor Destroy; override;
  end;

  TLookupErrorEvent = procedure(Sender: TObject; LookupValue: string) of object;

  TLookupSuccessEvent = procedure(Sender: TObject; LookupValue,LookupResult: string) of object;

  TLabelPosition = (lpLeftTop,lpLeftCenter,lpLeftBottom,lpTopLeft,lpBottomLeft,
                    lpLeftTopLeft,lpLeftCenterLeft,lpLeftBottomLeft,lpTopCenter,
                    lpBottomCenter, lpRightTop,lpRightCenter,lpRightBottom);


  TDropDownType = (ddUser,ddAuto,ddOnError);

  TSortType = (stAscendent,stDescendent);

  TDBGridLookupDataLink = class(TDataLink)
  private
    FGrid:TAdvDBLookupComboBox;
  protected
    procedure Modify;
    procedure DataSetScrolled(distance:integer); override;
    procedure ActiveChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure DataSetChanged; override;
  public
    constructor Create(AGrid: TAdvDBLookupComboBox);
    destructor Destroy; override;
  end;

  TDBGridDataLink = class(TDataLink)
  private
    FGrid:TAdvDBLookupComboBox;
    FNumberRecords:integer;
    OldState:TDataSetState;
  protected
    procedure ActiveChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure DataSetChanged; override;
  public
    constructor Create(AGrid: TAdvDBLookupComboBox);
    destructor Destroy; override;
  end;

  TEllipsType = (etNone, etEndEllips, etPathEllips);

  TLabelEx = class(TLabel)
  private
    FEllipsType: TEllipsType;
    procedure SetEllipsType(const Value: TEllipsType);
    { Private declarations }
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
  published
    { Published declarations }
    property EllipsType: TEllipsType read FEllipsType write SetEllipsType;
  end;

  TDBColumnType = (ctText,ctImage);

  TDBColumnItem = class(TCollectionItem)
  private
    FWidth: Integer;
    FAlignment: TAlignment;
    FFont: TFont;
    FColor: TColor;
    FColumnType: TDBColumnType;
    FListField: string;
    FTitle: string;
    FName: string;
    FTitleFont: TFont;
    procedure SetWidth(const value:integer);
    procedure SetAlignment(const value:tAlignment);
    procedure SetFont(const value:TFont);
    procedure SetColor(const value:TColor);
    function  GetListField: string;
    procedure SetListField(const Value: string);
    procedure SetColumnType(const Value: TDBColumnType);
    function GetCombo: TAdvDBLookupComboBox;
    function GetName: string;
    procedure SetName(const Value: string);
    procedure SetTitleFont(const Value: TFont);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Combo: TAdvDBLookupComboBox read GetCombo;
  published
    property Color:TColor read fColor write SetColor;
    property ColumnType: TDBColumnType read FColumnType write SetColumnType;
    property Width:integer read fWidth write SetWidth;
    property Alignment:TAlignment read fAlignment write SetAlignment;
    property Font:TFont read FFont write SetFont;
    property ListField: string read GetListField write SetListField;
    property Name: string read GetName write SetName;
    property Title: string read FTitle write FTitle;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
  end;

  TDBColumnCollection = class(TCollection)
  private
    FOwner:TAdvDBLookupComboBox;
    function GetItem(Index: Integer): TDBColumnItem;
    procedure SetItem(Index: Integer; const Value: TDBColumnItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add:TDBColumnItem;
    function Insert(index:integer): TDBColumnItem;
    property Items[Index: Integer]: TDBColumnItem read GetItem write SetItem; default;
    constructor Create(AOwner: TAdvDBLookupComboBox);
    function GetOwner: TPersistent; override;
  end;

  {TDropForm}

  TDropForm = class(TForm)
  private
    FSizeable: Boolean;
    procedure WMClose(var Msg:TMessage); message WM_CLOSE;
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  published
    property Sizeable: Boolean read FSizeable write FSizeable;
  end;

  {TInplaceStringGrid}
  TInplaceStringGrid = class(TStringGrid)
  private
    FParentEdit: TAdvDBLookupComboBox;
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
  protected
    procedure DoExit; override;
  property
    ParentEdit:TAdvDBLookupComboBox read FParentEdit write FParentEdit;
  end;

  { TDropGridListButton }
  TDropGridListButton = class(TSpeedButton)
  private
    FFocusControl: TWinControl;
    FMouseClick: TNotifyEvent;
    FArrEnabled: TBitmap;
    procedure WMLButtonDown(var Msg:TMessage); message WM_LBUTTONDOWN;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure Paint; override;
  public
    procedure Click; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FocusControl: TWinControl read FFocusControl write FFocusControl;
    property MouseClick:TNotifyEvent read FMouseClick write FMouseClick;
  end;

  TGridListItemToText = procedure(sender:TObject;var aText:string) of object;
  TTextToGridListItem = procedure(sender:TObject;var aItem:string) of object;

  TDropDirection = (ddDown,ddUp);

  TLookupMethod = (lmNormal,lmFast,lmRequired);

  TLookupLoad = (llAlways, llOnNeed);

  { TAdvDBLookupComboBox }

  TAdvDBLookupComboBox = class(TCustomEdit)
  private
    FButton: TDropGridListButton;
    FEditorEnabled: Boolean;
    FOnClickBtn: TNotifyEvent;
    FStringGrid: TInplaceStringGrid;
    FDropHeight: Integer;
    FDropWidth: Integer;
    FSortColumns: Integer;
    FDropColor: TColor;
    FDropFont: TFont;
    FDropSorted: Boolean;
    fDropDirection: TDropDirection;
    FChkForm:TDropForm;
    FChkClosed: Boolean;
    FCloseClick: Boolean;
    FOnGridListItemToText: TGridListItemToText;
    FOnTextToGridListItem: TTextToGridListItem;
    FColumns: TDBColumnCollection;
    FListDataLink: TDBGridDataLink;
    FDataSourceLink: TDBGridLookupDataLink;
    FAllfields: TList;
    FBitmapUp,FBitmapdown:TBitmap;
    FDataScroll: Boolean;
    FItemIndex, FOldItemIndex:integer;
    FKeyField: string;
    FDataField: string;
    FHeaderColor: Tcolor;
    FSelectionColor: Tcolor;
    FCurrentSearch:string;
    FAccept: Boolean;
    FSensSorted: TSortType;
    FSelectionTextColor: TColor;
    FGridLines: Boolean;
    FFilterValue: string;
    FFilterField: string;
    FBookmark:TBookmark;
    FLookupMethod: TLookupMethod;
    FLabelAlwaysEnabled: Boolean;
    FLabelTransparent: Boolean;
    FLabelMargin: Integer;
    FLabelFont: TFont;
    FLabelPosition: TLabelPosition;
    FLabel: TLabelEx;
    FDropDownType: TDropDownType;
    FOnLookupError: TLookupErrorEvent;
    FOnLookupSuccess: TLookupSuccessEvent;
    FLabelField: string;
    FSortColumn: string;
    FLabelWidth: Integer;
    FGridRowHeight: Integer;
    FLookupLoad: TLookupLoad;
    FDisableChange: Boolean;
    FInLookup: Boolean;
    FDropSizeable: Boolean;
    function GetMinHeight: Integer;
    procedure SetEditRect;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
    procedure WMPaste(var Message: TWMPaste);   message WM_PASTE;
    procedure WMCut(var Message: TWMCut);   message WM_CUT;
    procedure WMKeyDown(var Msg:TWMKeydown); message WM_KEYDOWN;
    procedure WMSysKeyDown(var Msg:TWMKeydown); message WM_SYSKEYDOWN;
    function  GridToString:string;
    procedure ShowGridList(Focus:boolean);
    procedure HideGridList;
    procedure UpdateLookup;
    procedure FormDeactivate(Sender: TObject);
    procedure MouseClick(Sender: TObject);
    procedure DownClick(Sender: TObject);
    procedure SetDropFont(const Value: TFont);
    function GetText: string;
    procedure SetText(const Value: string);
    function CheckDataSet:boolean;
    function CheckEditDataSet:boolean;
    function GetListsource: TDatasource;
    procedure SetListsource(const Value: TDatasource);
    function GetItemIndex: integer;
    procedure SetItemIndex(Value: integer);
    function GetDatasource: TDatasource;
    procedure SetDatasource(const Value: TDatasource);
    procedure SetSortColumns(const Value: Integer);
    function GetRealItemIndex(Index: Integer): Integer;
    procedure SetFilterField(const Value: string);
    procedure SetFilterValue(const Value: string);
    function GetLabelCaption: string;
    procedure SetLabelAlwaysEnabled(const Value: Boolean);
    procedure SetLabelCaption(const Value: string);
    procedure SetLabelFont(const Value: TFont);
    procedure SetLabelMargin(const Value: Integer);
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelTransparent(const Value: Boolean);
    procedure UpdateLabel;
    procedure LabelFontChange(Sender: TObject);
    procedure SetLabelField(const Value: string);
    procedure SetSortColumn(const Value: string);
    procedure SetLabelWidth(const Value: Integer);
    procedure SetSortDownGlyph(const Value: TBitmap);
    procedure SetSortUpGlyph(const Value: TBitmap);
    procedure SetLookupLoad(const Value: TLookupLoad);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function GetParentForm(Control: TControl): TCustomForm; virtual;
    Procedure LoadGridOptions;
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGridKeyPress(Sender: TObject; var Key: Char);
    procedure  StringGridSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    function LoadFromListSource: Integer;
    //procedure UpdateFromListSource;
    procedure SetActive(Active: Boolean);
    procedure Change; override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function FindField(Value: string): Boolean;
    function CreateLabel: TLabelEx;
    procedure UpdateText(s:string);
    property SortColumns: Integer read FSortColumns write SetSortColumns default 0;
  public
   {$IFDEF TMSDEBUG}
      procedure DebugTest;
   {$ENDIF}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    property Button: TDropGridListButton read FButton;
    property Text: string read GetText write SetText;
    property ItemIndex: Integer Read GetItemIndex write SetItemIndex;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
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
    property DropDownType: TDropDownType read FDropDownType write FDropDownType default ddUser;
    property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled default True;
    property Enabled;
    property FilterField: string read FFilterField write SetFilterField;
    property FilterValue: string read FFilterValue write SetFilterValue;
    property Font;
    property LabelCaption:string read GetLabelCaption write SetLabelCaption;
    property LabelPosition:TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelMargin: Integer read FLabelMargin write SetLabelMargin;
    property LabelTransparent: Boolean read FLabelTransparent write SetLabelTransparent;
    property LabelAlwaysEnabled: Boolean read FLabelAlwaysEnabled write SetLabelAlwaysEnabled;
    property LabelField: string read FLabelField write SetLabelField;
    property LabelFont:TFont read FLabelFont write SetLabelFont;
    property LabelWidth: Integer read FLabelWidth write SetLabelWidth;
    property LookupMethod: TLookupMethod read FLookupMethod write FLookupMethod;
    property LookupLoad: TLookupLoad read FLookupLoad write SetLookupLoad;
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
    property Columns: TDBColumnCollection read FColumns write FColumns;
    property DataField: string read FDataField write FDataField;
    property DataSource: TDatasource read GetDatasource write SetDatasource;
    property DropWidth: Integer read FDropWidth write FDropWidth;
    property DropHeight: Integer read FDropHeight write FDropHeight;
    property DropColor: TColor read FDropColor write fDropColor;
    property DropFont: TFont read FDropFont write SetDropFont;
    property DropDirection: TDropDirection read FDropDirection write FDropDirection;
    property DropSorted: Boolean read FDropSorted write FDropSorted;
    property DropSizeable: Boolean read FDropSizeable write FDropSizeable;    
    property GridLines: Boolean read FGridLines write FGridLines;
    property GridRowHeight: Integer read FGridRowHeight write FGridRowheight;
    property HeaderColor: TColor read FHeaderColor write FHeaderColor default clBtnFace;
    property KeyField: string read FKeyField write FKeyField;
    property ListSource: TDatasource read GetListsource write SetListsource;
    property SelectionColor: TColor read FSelectionColor write FSelectionColor;
    property SelectionTextColor: TColor read FSelectionTextColor write FSelectionTextColor;
    property SortColumn: string read FSortColumn write SetSortColumn;
    property SortUpGlyph: TBitmap read FBitmapDown write SetSortUpGlyph;
    property SortDownGlyph: TBitmap read FBitmapUp write SetSortDownGlyph;
    property OnClickBtn: TNotifyEvent read FOnClickBtn write FOnClickBtn;
    property OnTextToGridListItem: TTextToGridListItem read FOnTextToGridListItem write FOnTextToGridListItem;
    property OnGridListItemToText: TGridListItemToText read FOnGridListItemToText write FOnGridListItemToText;
    property OnLookupError: TLookupErrorEvent read FOnLookupError write FOnLookupError;
    property OnLookupSuccess: TLookupSuccessEvent read FOnLookupSuccess write FOnLookupSuccess;
  end;

implementation

{$R ADVDBCOMBO.RES}

type

  TCharSet = set of char;

const
  ALIGNSTYLE : array[TAlignment] of DWORD = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WORDWRAPSTYLE : array[Boolean] of DWORD = (DT_SINGLELINE, DT_WORDBREAK);
  LAYOUTSTYLE : array[TTextLayout] of DWORD = (0,DT_VCENTER,DT_BOTTOM);
  ELLIPSSTYLE : array[TEllipsType] of DWORD = (0,DT_END_ELLIPSIS,DT_PATH_ELLIPSIS);
  ACCELSTYLE : array[Boolean] of DWORD = (DT_NOPREFIX,0);
  

function VarPos(su,s:string;var Respos:Integer):Integer;
begin
  Respos := Pos(su,s);
  Result := Respos;
end;

function FirstChar(Charset:TCharSet;s:string):char;
var
  i:Integer;
begin
  i := 1;
  Result := #0;
  while i <= Length(s) do
  begin
    if s[i] in Charset then
    begin
      Result := s[i];
      Break;
    end;
    Inc(i);
  end;
end;

function IsDate(s:string;var dt:TDateTime):boolean;
var
  su: string;
  da,mo,ye: word;
  err: Integer;
  dp,mp,yp,vp: Integer;
begin
  Result:=False;

  su := UpperCase(shortdateformat);
  dp := pos('D',su);
  mp := pos('M',su);
  yp := pos('Y',su);

  da := 0;
  mo := 0;
  ye := 0;

  if VarPos(Dateseparator,s,vp)>0 then
  begin
    su := Copy(s,1,vp - 1);

    if (dp<mp) and
       (dp<yp) then
       val(su,da,err)
    else
    if (mp<dp) and
       (mp<yp) then
       val(su,mo,err)
    else
    if (yp<mp) and
       (yp<dp) then
       val(su,ye,err);

    if err<>0 then Exit;
    Delete(s,1,vp);

    if VarPos(DateSeparator,s,vp)>0 then
    begin
      su := Copy(s,1,vp - 1);

      if ((dp>mp) and (dp<yp)) or
         ((dp>yp) and (dp<mp)) then
         val(su,da,err)
      else
      if ((mp>dp) and (mp<yp)) or
         ((mp>yp) and (mp<dp)) then
         val(su,mo,err)
      else
      if ((yp>mp) and (yp<dp)) or
         ((yp>dp) and (yp<mp)) then
         val(su,ye,err);

      if err<>0 then Exit;
      Delete(s,1,vp);

      if (dp>mp) and
         (dp>yp) then
         val(s,da,err)
      else
      if (mp>dp) and
         (mp>yp) then
         val(s,mo,err)
      else
      if (yp>mp) and
         (yp>dp) then
         val(s,ye,err);

      if err<>0 then Exit;
      if (da>31) then Exit;
      if (mo>12) then Exit;

      Result:=True;

      try
        dt := EncodeDate(ye,mo,da);
      except
        Result := False;
      end;

     end;

  end;
end;


function Matches(s0a,s1a:PChar):boolean;
const
  larger = '>';
  smaller = '<';
  logand  = '&';
  logor   = '^';
  asterix = '*';
  qmark = '?';
  negation = '!';
  null = #0;

var
  matching:boolean;
  done:boolean;
  len:longint;
  lastchar:char;
  s0,s1,s2,s3:pchar;
  oksmaller,oklarger,negflag:boolean;
  compstr:array[0..255] of char;
  flag1,flag2,flag3:boolean;
  equal:boolean;
  n1,n2:double;
  code1,code2:Integer;
  dt1,dt2:TDateTime;

begin
  oksmaller := True;
  oklarger := True;
  flag1 := False;
  flag2 := False;
  flag3 := False;
  negflag := False;
  equal := False;

  { [<>] string [&|] [<>] string }


  // do larger than or larger than or equal
  s2 := StrPos(s0a,larger);
  if s2 <> nil then
  begin
    inc(s2);
    if (s2^ = '=') then
    begin
      Equal := True;
      inc(s2);
    end;

    while (s2^ = ' ') do
      inc(s2);

    s3 := s2;
    len := 0;

    lastchar := #0;

    while (s2^ <> ' ') and (s2^ <> NULL) and (s2^ <> '&') and (s2^ <> '|')  do
    begin
      if (len = 0) and (s2^ = '"') then
        inc(s3)
      else
        inc(len);

      lastchar := s2^;
      inc(s2);
    end;

    if (len > 0) and (lastchar = '"') then
      dec(len);

    StrLCopy(compstr,s3,len);

    Val(s1a,n1,code1);
    Val(compstr,n2,code2);

    if (code1 = 0) and (code2 = 0) then {both are numeric types}
    begin
      if equal then
        oklarger := n1 >= n2
      else
        oklarger := n1 > n2;
    end
    else
    begin
      if IsDate(StrPas(compstr),dt2) and IsDate(StrPas(s1a),dt1) then
      begin
        if equal then
         oklarger := dt1 >= dt2
        else
         oklarger := dt1 > dt2;
      end
      else
      begin
        if equal then
         oklarger := (strlcomp(compstr,s1a,255)<=0)
        else
         oklarger := (strlcomp(compstr,s1a,255)<0);
      end;
    end;
    flag1 := True;
  end;

  equal := False;

  // do smaller than or smaller than or equal
  s2 := strpos(s0a,smaller);
  if (s2 <> nil) then
  begin
    inc(s2);
    if (s2^ = '=') then
      begin
       equal := True;
       inc(s2);
      end;
      
    lastchar := #0;

    while (s2^=' ') do inc(s2);
    s3 := s2;
    len := 0;
    while (s2^ <> ' ') and (s2^ <> NULL) and (s2^ <> '&') and (s2^ <> '|') do
    begin
      if (len = 0) and (s2^ = '"') then
        inc(s3)
      else
        inc(len);

      lastchar := s2^;
      inc(s2);
    end;

    if (len > 0) and (lastchar = '"') then
      dec(len);

    strlcopy(compstr,s3,len);

    val(s1a,n1,code1);
    val(compstr,n2,code2);

    if (code1 = 0) and (code2 = 0) then // both are numeric types
     begin
      if equal then
       oksmaller := n1 <= n2
      else
       oksmaller := n1 < n2;
     end
    else
     begin
      // check for dates here ?
      if IsDate(strpas(compstr),dt2) and IsDate(strpas(s1a),dt1) then
       begin
        if equal then
         oksmaller := dt1 <= dt2
        else
         oksmaller := dt1 < dt2;
       end
      else
       begin
        if equal then
          oksmaller := (strlcomp(compstr,s1a,255)>=0)
        else
          oksmaller := (strlcomp(compstr,s1a,255)>0);
       end;
     end;

    flag2 := True;
  end;

  s2 := strpos(s0a,negation);
  
  if (s2 <> nil) then
  begin
    inc(s2);
    while (s2^=' ') do
      inc(s2);
    s3 := s2;
    len := 0;

    lastchar := #0;

    while (s2^ <> ' ') and (s2^ <> NULL) and (s2^ <> '&') and (s2^ <> '|') do
    begin
      if (len = 0) and (s2^ = '"') then
        inc(s3)
      else
        inc(len);
        
      lastchar := s2^;
      inc(s2);
    end;

    if (len > 0) and (lastchar = '"') then
      dec(len);

    strlcopy(compstr,s3,len);
    flag3 := True;
  end;

  if (flag3) then
  begin
    if strpos(s0a,larger) = nil then
      flag1 := flag3;
    if strpos(s0a,smaller) = nil then
      flag2 := flag3;
  end;

  if (strpos(s0a,logor) <> nil) then
    if flag1 or flag2 then
    begin
      matches := oksmaller or oklarger;
      Exit;
    end;

  if (strpos(s0a,logand)<>nil) then
    if flag1 and flag2 then
    begin
      matches := oksmaller and oklarger;
      Exit;
    end;

  if ((strpos(s0a,larger) <> nil) and (oklarger)) or
     ((strpos(s0a,smaller) <> nil) and (oksmaller)) then
  begin
    matches := True;
    Exit;
  end;

  s0 := s0a;
  s1 := s1a;

  matching := True;

  done := (s0^ = NULL) and (s1^ = NULL);

  while not done and matching do
  begin
    case s0^ of
    qmark:
      begin
        matching := s1^ <> NULL;
        if matching then
        begin
          inc(s0);
          inc(s1);
        end;
      end;
    negation:
      begin
        negflag:=True;
        inc(s0);
      end;
    '"':
      begin
        inc(s0);
      end;
    asterix:
      begin
        repeat
          inc(s0)
        until (s0^ <> asterix);
        len := strlen(s1);
        inc(s1,len);
        matching := matches(s0,s1);
        while (len >= 0) and not matching do
        begin
         dec(s1);
         dec(len);
         matching := Matches(s0,s1);
       end;
       if matching then
       begin
         s0 := strend(s0);
         s1 := strend(s1);
       end;
     end;
   else
     begin
       matching := s0^ = s1^;

       if matching then
       begin
         inc(s0);
         inc(s1);
       end;
     end;
   end;

   Done := (s0^ = NULL) and (s1^ = NULL);
  end;

  if negflag then
    Matches := not matching
  else
    Matches := matching;
end;

function MatchStr(s1,s2:string;DoCase:Boolean):Boolean;
begin
  if DoCase then
    MatchStr := Matches(PChar(s1),PChar(s2))
  else
    MatchStr := Matches(PChar(AnsiUpperCase(s1)),PChar(AnsiUpperCase(s2)));
end;

function MatchStrEx(s1,s2:string;DoCase:Boolean): Boolean;
var
  ch,lastop: Char;
  sep: Integer;
  res,newres: Boolean;

begin
 {remove leading & trailing spaces}
  s1 := Trim(s1);
 {remove spaces between multiple filter conditions}
  while VarPos(' &',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos(' ;',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos(' ^',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos(' |',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos(' =',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos('& ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('; ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('^ ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('| ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('= ',s1,sep) > 0 do Delete(s1,sep+1,1);

  while VarPos('=',s1,sep) > 0 do Delete(s1,sep,1);

  LastOp := #0;
  Res := True;

  repeat
    ch := FirstChar([';','^','&','|'],s1);
    {extract first part of filter}
    if ch <> #0 then
    begin
      VarPos(ch,s1,sep);
      NewRes := MatchStr(Copy(s1,1,sep-1),s2,DoCase);
      Delete(s1,1,sep);

      if LastOp = #0 then
        Res := NewRes
      else
        case LastOp of
        ';','^','|':Res := Res or NewRes;
        '&':Res := Res and NewRes;
        end;

      LastOp := ch;
     end;

  until ch = #0;

  NewRes := MatchStr(s1,s2,DoCase);

  if LastOp = #0 then
    Res := NewRes
  else
    case LastOp of
    ';','^','|':Res := Res or NewRes;
    '&':Res := Res and NewRes;
    end;

  Result := Res;
end;




{ TDropGridListButton }
constructor TDropGridListButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Cursor := crArrow;
  FArrEnabled := TBitmap.Create;
  FArrEnabled.LoadFromResourceName(HInstance,'AC_ARROW_DOWN');
  Glyph.Assign(FArrEnabled);
end;

procedure TDropGridListButton.Paint;
begin
  inherited Paint;
end;

procedure TDropGridListButton.Click;
begin
  if (FFocusControl <> nil) and FFocusControl.CanFocus and (GetFocus <> FFocusControl.Handle) then
  FFocusControl.SetFocus;
  inherited Click;
end;

procedure TDropGridListButton.WMLButtonDown(var Msg: TMessage);
begin
  if Assigned(FMouseClick) then FMouseClick(self);
  inherited;
end;

procedure TDropGridListButton.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
end;

destructor TDropGridListButton.Destroy;
begin
  FArrEnabled.Free;
  inherited;
end;

{ TAdvDBLookupComboBox }
constructor TAdvDBLookupComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmapUp := TBitmap.Create;
  FBitmapUp.Handle := LoadBitmap(HInstance, 'AC_MINIARROW_UP');
  FBitmapUp.Transparent := True;

  FBitmapDown := TBitmap.Create;
  FBitmapDown.Handle := LoadBitmap(HInstance, 'AC_MINIARROW_DOWN');
  FBitmapDown.Transparent := True;
  
  SetBounds(left,top,250,Height);
  FAllfields := Tlist.Create;
  FSensSorted := stAscendent;
  FHeaderColor := clBtnFace;
  FSelectionColor := clHighLight;
  FSelectionTextColor := clHighLightText;
  FSortColumns := 0;
  FColumns := TDBColumnCollection.Create(self);
  FListDataLink := TDBGridDataLink.Create(self);
  FDataSourceLink := TDBGridLookupDataLink.Create(Self);
  FButton := TDropGridListButton.Create (Self);
  FButton.Width := 15;
  FButton.Height := 17;
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.FocusControl := Self;
  FButton.MouseClick := MouseClick;
  FButton.OnClick := DownClick;
  FButton.Enabled := False;
  Text := '';
  ControlStyle := ControlStyle - [csSetCaption];
  FEditorEnabled := True;
  FDropHeight := 100;
  FDropWidth := self.Width;
  FDropSorted := False;
  FDropColor := clWindow;
  FDropFont := TFont.Create;
  FChkClosed := True;

  FGridRowHeight := 21; 

  FLabel := nil;
  FLabelFont := TFont.Create;
  FLabelFont.OnChange := LabelFontChange;
  FLabelMargin := 4;
  FLabelWidth := 0;
  FInLookup := False;

  FDisableChange := False;
end;

destructor TAdvDBLookupComboBox.Destroy;
var
  i: Integer;
begin
  if Assigned(FBookmark) then
    if FListDataLink.DataSource.DataSet.BookmarkValid(FBookmark) then
      FListDataLink.DataSource.DataSet.FreeBookmark(FBookmark);

  for i := 0 to FAllfields.Count - 1 do
    TFindList(FAllfields.Items[i]).Free;

  FAllfields.Free;
  FListDataLink.Free;
  FDataSourceLink.Free;
  FButton.Free;
  FColumns.Free;
  FDropFont.Free;
  FBitmapUp.Free;
  FBitmapDown.Free;
  FLabelFont.Destroy;
  if FLabel <> nil then
    FLabel.Free;
  inherited Destroy;
end;

function TAdvDBLookupComboBox.CreateLabel: TLabelEx;
begin
  Result := TLabelEx.Create(self);
  Result.Parent := Self.Parent;
  Result.FocusControl := Self;
  Result.Font.Assign(LabelFont);
end;

procedure TAdvDBLookupComboBox.UpdateLabel;
begin
  if FLabel = nil then
    Exit;
    
  FLabel.Transparent := FLabeltransparent;
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
  lpRightTop:
    begin
      FLabel.Top := self.Top;
      FLabel.Left := self.Left + self.Width + FLabelMargin;
    end;
  lpRightCenter:
    begin
      FLabel.top := self.top+((self.height-FLabel.height) shr 1);
      FLabel.Left := self.Left + self.Width + FLabelMargin;
    end;
  lpRightBottom:
    begin
      FLabel.Left := self.Left + self.Width + FLabelMargin;
      FLabel.Top := self.Top + self.Height - FLabel.Height;          
    end;
  end;
  FLabel.Font.Assign(FLabelFont);

  FLabel.AutoSize := FLabelWidth = 0;
  if FLabelWidth <> 0 then
  begin
    FLabel.Width := FLabelWidth;
    FLabel.EllipsType := etEndEllips;
  end
  else
    FLabel.EllipsType := etNone;

  if not CheckDataSet then
  begin
    if LabelField <> '' then
      FLabel.Caption := '';
  end;

  if CheckDataSet then
  begin
    if (LabelField <> '') then
    begin
      if (Text = '') then
        FLabel.Caption := '';
    end;
  end;

  FLabel.Visible := Visible;
end;

procedure TAdvDBLookupComboBox.LabelFontChange(Sender: TObject);
begin
  if Assigned(FLabel) then
    UpdateLabel;
end;

function TAdvDBLookupComboBox.GetParentForm(Control: TControl): TCustomForm;
begin
  Result := nil;
  if Assigned(Control) then
    if Control is TCustomForm then
    begin
      Result := Control as TCustomForm;
      Exit;
    end else
    begin
      if Assigned(Control.Parent) then
        Result := GetParentForm(Control.Parent);
    end;
end;

procedure TAdvDBLookupComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TAdvDBLookupComboBox.DestroyWnd;
begin
  inherited;
end;

procedure TAdvDBLookupComboBox.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
  self.ReadOnly := not EditorEnabled;
end;

function TAdvDBLookupComboBox.LoadFromListsource:integer;
var
  d: TDataset;
  cb,ct: TBookMark;
  i,index: Integer;
  fldlist:TFindList;
  fltr: TField;
  DoAdd: Boolean;
  
begin
  Result := -1;

  FButton.Enabled := False;

  if not CheckDataSet then
    Exit;

  if FLookupLoad = llOnNeed then
    if GetFocus <> self.Handle then
      Exit;

  if FColumns.Count = 0 then
    Exit;

  for i := 0 to FAllfields.Count - 1 do
    TFindList(FAllfields.Items[i]).Free;

  FAllfields.Clear;

  d := FListDataLink.DataSource.DataSet;
  FDataScroll := True;
  Index := 0;

  with d do
  begin
    DisableControls;
    cb := GetBookMark;
    First;
    while not Eof do
    begin
      // Iterate through the fields array and put data in cells

      DoAdd := True;

      if (FilterField <> '') and (FilterValue <> '') then
      begin
        fltr := FieldByName(FilterField);
        if Assigned(fltr) then
          DoAdd := MatchStrEx(FilterValue,fltr.DisplayText,False);
      end;

      if DoAdd then
      begin
        fldlist := TFindlist.Create(self);
        fldlist.BaseIndex := Index;
        fldlist.KeyField := FieldByName(KeyField).DisplayText;
        ct := GetBookmark;
        if CompareBookmarks(ct,cb) = 0 then
          Result := Index;

        FreeBookmark(ct);

        for i := 1 to Columns.Count do
        begin
          if (Columns.Items[i - 1].ListField <> '') then
          begin
            try
              if (Columns.Items[i - 1].FColumnType = ctText) then
                fldlist.Add(FieldByName(Columns.Items[i - 1].ListField).DisplayText)
              else
                fldlist.Add('Binary')
            except
              on Exception do fldlist.Add('');
            end;
          end
          else
            fldlist.Add('');
        end;

        FAllfields.Add(pointer(fldlist));
      end;

      Inc(Index);
      Next;
    end;
    GotoBookMark(cb);
    FreeBookMark(cb);
    FListDataLink.FNumberRecords := d.RecordCount;
    EnableControls;
  end;

  FButton.Enabled := FAllFields.Count > 0;

  {$IFDEF TMSDEBUG}
  if FButton.Enabled then
    outputdebugstring('set btn= enabled');
  {$ENDIF}

  FDataScroll := False;
  SortColumns := FSortColumns;
end;

function SortField(Item1, Item2: Pointer): Integer;
var
  index:integer;
begin
  index := TFindList(Item1).FGrid.FSortColumns;
  if TFindList(Item1).FGrid.FSensSorted = stAscendent then
    Result := CompareText(TFindList(Item1).Strings[index],TFindList(Item2).Strings[index])
  else
    Result := CompareText(TFindList(Item2).Strings[index],TFindList(Item1).Strings[index]);
end;

procedure TAdvDBLookupComboBox.ShowGridList(Focus:Boolean);
var
  P: TPoint;
  fOldDropDirection: TDropDirection;
  i,j,tmpix:integer;
  
begin
  FAccept := False;
  FOldItemIndex := ItemIndex;
  if FColumns.Count = 0 then
    Exit;
  if not CheckDataSet then
    Exit;

  if FAllFields.Count = 0 then
    Exit;

  FOldDropDirection := FDropDirection;
  FDataScroll := True;

  P := Point(0, 0);
  P := Self.ClientToScreen(P);

  if P.y + FDropHeight >= GetSystemMetrics(SM_CYSCREEN) then
    FDropDirection := ddUp;

  if P.y - FDropHeight <= 0 then
    FDropDirection := ddDown;

  {$IFDEF DELPHI4_LVL}
  FChkForm := TDropForm.CreateNew(self,0);
  {$ELSE}
  FChkForm := TDropForm.CreateNew(self);
  {$ENDIF}
  FChkForm.Sizeable := FDropSizeable;
  FChkForm.BorderStyle := bsNone;
  FChkForm.FormStyle := fsStayOnTop;
  FChkForm.Visible := False;
  FChkForm.Width := FDropWidth;
  FChkForm.Height := FDropHeight;
  FChkForm.OnDeactivate := FormDeactivate;

  FStringGrid := TInplaceStringGrid.Create(FChkForm);
  FStringGrid.Parent := FChkForm;
  FStringGrid.Align := alClient;
  LoadGridOptions;

  if FSortColumns >= FColumns.Count then
    FSortColumns := 0;
    
  // FSensSorted := stAscendent;
  tmpix := TFindList(FAllfields.Items[ItemIndex]).BaseIndex;
  FAllfields.Sort(SortField);

  FStringGrid.RowCount := FAllfields.Count + 1;
  FStringGrid.colCount := FColumns.Count;

  for i := 0 to FColumns.Count - 1 do
  begin
    FStringGrid.Cells[i,0] := FColumns.Items[i].FListField;
    FStringGrid.RowHeights[0] := Height;
    FStringGrid.ColWidths[i] := FColumns.Items[i].FWidth;
    for j := 0 to FAllfields.Count - 1 do
    begin
      FStringGrid.Cells[i,j + 1] := TFindList(FAllfields.Items[j]).Strings[i];
      FStringGrid.RowHeights[j] := Height;
      if TFindList(FAllfields.Items[j]).BaseIndex = tmpix then
        FItemIndex := j;
    end;
  end;

  FStringGrid.FixedRows := 1;
  FStringGrid.Font.Assign(FDropFont);
  FStringGrid.Font.Assign(FDropFont);
  FStringGrid.ParentEdit := Self;
  FStringGrid.TabStop := True;

  if FGridLines then
    FStringGrid.GridLineWidth := 1
  else
    FStringGrid.GridLineWidth := 0;

  FStringGrid.DefaultRowHeight := FGridRowHeight;  

  P := Point(0, 0);
  P := ClientToScreen(P);
  FChkForm.Left := P.x;

  if (FDropDirection = ddDown) then
    FChkForm.Top := P.y + self.Height
  else
    FChkForm.Top := P.y - FDropHeight;
  FStringGrid.Visible := True;
  FChkForm.Show;
  if Focus then
    FStringGrid.SetFocus;
  FStringGrid.Height := FStringGrid.Height + 1;
  FStringGrid.Height := FStringGrid.Height - 1;
  FDropDirection := FOldDropDirection;
  FChkClosed := False;
  FDataScroll := False;
  FStringGrid.Row := FItemIndex + 1; //row=0=> header=>+1
  if Assigned(FBookmark) then
    if FListDataLink.DataSource.DataSet.BookmarkValid(fbookmark) then
    FListDataLink.DataSource.DataSet.GotoBookmark(fbookmark);
end;

procedure TAdvDBLookupComboBox.UpdateLookup;
begin
  if CheckEditDataSet  and (not FDataScroll) and FAccept then
  begin
    {$IFDEF TMSDEBUG}
    outputdebugstring(pchar('MODIFY IN TO:'+FListDataLink.Datasource.DataSet.FieldByName(FKeyField).DisplayText));
    {$ENDIF}
    try
      if FListDataLink.Datasource.DataSet.FieldByName(FKeyField).IsNull then
        FDataSourceLink.Datasource.DataSet.FieldByName(FDataField).Clear
      else
        FDataSourceLink.Datasource.DataSet.FieldByName(FDataField).AsVariant :=
          FListDataLink.Datasource.DataSet.FieldByName(FKeyField).AsVariant;
    
      FOldItemIndex := Itemindex;
      FAccept := False;
    except
      on e:Exception do
        MessageDlg(e.Message, mtWarning, [mbYes], 0);
    end;
  end;
end;

procedure TAdvDBLookupComboBox.HideGridList;
begin
  if FChkClosed then
    Exit;
    
  {$IFDEF TMSDEBUG}
  outputdebugstring(pchar(FListDataLink.Datasource.DataSet.FieldByName(FKeyField).DisplayText));
  {$ENDIF}
  UpdateLookup;
  FDataSourceLink.Modify;
  Change;
  PostMessage(FChkForm.Handle,WM_CLOSE,0,0);
  FChkClosed := True;
end;

procedure TAdvDBLookupComboBox.SetEditRect;
var
  Loc: TRect;
begin
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := ClientWidth - FButton.Width - 3;
  if self.BorderStyle=bsNone then
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
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));  {debug}
end;

procedure TAdvDBLookupComboBox.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
  Dist:integer;
begin
  inherited;
  if BorderStyle = bsNone then
    Dist := 2
  else
    Dist := 5;

  MinHeight := GetMinHeight;
  { Windows text edit bug: if size to less than minheight, then edit ctrl does
    not display the text }

  if Height < MinHeight then
    Height := MinHeight
  else if FButton <> nil then
  begin
    if NewStyleControls and Ctl3D then
      FButton.SetBounds(Width - FButton.Width - Dist, 0, FButton.Width, Height - Dist)
    else FButton.SetBounds (Width - FButton.Width, 1, FButton.Width, Height - 3);
    SetEditRect;
  end;
end;

function TAdvDBLookupComboBox.GetMinHeight: Integer;
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

procedure TAdvDBLookupComboBox.WMPaste(var Message: TWMPaste);
var
  ch: Char;
begin
  inherited;

  FCurrentSearch := Text;
  ch := #0;
  Keypress(ch);
end;

procedure TAdvDBLookupComboBox.WMCut(var Message: TWMPaste);
var
  ch: Char;
begin
  inherited;

  FCurrentSearch := Text;
  ch := #0;
  Keypress(ch);
end;

procedure TAdvDBLookupComboBox.CMExit(var Message: TCMExit);
begin
  if DropDownType = ddAuto then
    HideGridList;
  inherited;
end;

procedure TAdvDBLookupComboBox.WMKeyDown(var Msg:TWMKeydown);
begin
  inherited;
  if (msg.CharCode = VK_DOWN) or (msg.CharCode = VK_F4) then
  begin
    ShowGridList(true);
  end;
  if (msg.CharCode = VK_ESCAPE) and Assigned(Parent) then
    SendMessage(Parent.Handle, CM_DIALOGKEY , ord(VK_ESCAPE),0);
end;

procedure TAdvDBLookupComboBox.WMSysKeyDown(var Msg: TWMKeydown);
begin
  inherited;
  if (msg.CharCode = VK_DOWN) and (GetKeyState(VK_MENU) and $8000 = $8000)  then
    ShowGridList(true);
end;

procedure TAdvDBLookupComboBox.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll;

  inherited;

  if CheckDataSet then
  begin
    if (LookupLoad = llOnNeed) and (FAllFields.Count = 0) then
    begin
      LoadFromListSource;
      FDataSourceLink.Modify;
    end;
  end;

  if DropDownType = ddAuto then
    ShowGridList(True);
end;

function TAdvDBLookupComboBox.GridToString: string;
var
  fld: TField;
  s:string;
  LookupFields: string;
begin
  if (csLoading in ComponentState) then
    Exit;

  Result := '';
  try
    if FColumns.Count > 0 then
    begin
      if CheckDataSet then
      begin
        if (FAllFields.Count = 0) and (LookupLoad = llOnNeed) then
        begin
          fld := DataSource.DataSet.Fields.FieldByName(DataField);
          if Assigned(fld) then
          begin
            FInLookup := True;

            if FilterField <> '' then
            begin
              LookupFields := KeyField + ';' + FilterField;
              Result := ListSource.DataSet.Lookup(LookupFields,VarArrayOf([fld.AsVariant,FilterValue]),FColumns.Items[0].FListField);
            end
            else
            begin
              LookupFields := KeyField;
              Result := ListSource.DataSet.Lookup(LookupFields,fld.AsVariant,FColumns.Items[0].FListField);
            end;

            if LabelField <> '' then
            begin
              if FilterField <> '' then
              begin
                LookupFields := KeyField + ';' + FilterField;
                s := ListSource.DataSet.Lookup(LookupFields,VarArrayOf([fld.AsVariant,FilterValue]),FLabelField);
              end
              else
              begin
                LookupFields := KeyField;
                s := ListSource.DataSet.Lookup(LookupFields,fld.AsVariant,FLabelField);
              end;


              {$IFDEF TMSDEBUG}
              outputdebugstring(pchar('gridtostring:'+s));
              {$ENDIF}
              LabelCaption := s;
            end;

            FInLookup := False;
          end;
        end
        else
        begin
          Result := TFindList(FAllfields.Items[FItemIndex]).Strings[0]
        end;
      end
      else
      begin
        Result := FColumns.Items[0].FListField;
      end;
    end;
  except
    on Exception do;
  end;

  if Assigned(OnGridListItemToText) then
    OnGridListItemToText(Self,Result);

end;


procedure TAdvDBLookupComboBox.FormDeactivate(Sender: TObject);
var
  pt: TPoint;
  r: TRect;
begin
  {Grid cursor here...}
  GetCursorPos(pt);
  pt := ScreenToClient(pt);
  r := ClientRect;
  r.left := r.right - 16;
  FCloseClick := PtInRect(r,pt);
  HideGridList;
end;

procedure TAdvDBLookupComboBox.Loaded;
begin
  inherited;
  if FLabel <> nil then
    UpdateLabel;

  UpdateText(GridToString);
end;

procedure TAdvDBLookupComboBox.DownClick(Sender: TObject);
begin
  if FChkClosed then
  begin
    if not FCloseClick then
      ShowGridList(true);
  end;
  FCloseClick := False;
  if Assigned(FOnClickBtn) then
    FOnClickBtn(Self);
end;

procedure TAdvDBLookupComboBox.MouseClick(Sender: TObject);
begin
  if not FChkClosed then
  begin
    HideGridList;
  end;
end;

procedure TAdvDBLookupComboBox.SetDropFont(const Value: TFont);
begin
  FDropFont.Assign(Value);
end;

function TAdvDBLookupComboBox.GetText: string;
begin
  Result := inherited Text;
end;

procedure TAdvDBLookupComboBox.SetText(const Value: string);
begin
  if Value <> Text then
    inherited Text := Value;
end;

function TAdvDBLookupComboBox.CheckDataSet: boolean;
begin
  Result := False;
  if not Assigned(FListDataLink) then
    Exit;
  if not Assigned(FListDataLink.Datasource) then
    Exit;
  if not Assigned(FListDataLink.Datasource.DataSet) then
    Exit;
  if not Assigned(FDataSourceLink) then
    Exit;
  if not Assigned(FDataSourceLink.Datasource) then
    Exit;
  if not Assigned(FDataSourceLink.Datasource.DataSet) then
    Exit;
  if not FListDataLink.Datasource.DataSet.Active then
    Exit;
  if not FDataSourceLink.Datasource.DataSet.Active then
    Exit;
    Result := True;
end;

procedure TAdvDBLookupComboBox.SetActive(Active: boolean);
var
  i:integer;
  df:string;
begin
  for i := 0 to FAllfields.count-1 do
    Tfindlist(FAllfields.Items[i]).Free;
  FAllfields.Clear;

  if  Active then
    if not (csLoading in ComponentState)
       then LoadFromListsource;

  if not CheckDataSet then
   begin
     Text := '';
     Exit;
   end;
   
  df := DataSource.DataSet.FieldByName(DataField).DisplayText;
  for i := 0 to FAllfields.Count - 1 do
    if TFindList(FAllfields.Items[i]).KeyField = df then
    begin
      Itemindex := i;
      Exit;
    end;

  if LookupLoad <> llOnNeed then
    Text := '';
end;

function TAdvDBLookupComboBox.GetListsource: TDatasource;
begin
  Result := FListDataLink.Datasource;
end;

procedure TAdvDBLookupComboBox.SetListsource(const Value: TDatasource);
begin
  if (Value = nil) then
    SetActive(false);

  if (FListDataLink.Datasource <> Value) then
  begin
    if (FDataSourceLink.Datasource = VALUE) AND (Value <> nil) then
      raise Exception.Create('Circular referance: ' + Value.Name);
    FListDataLink.Datasource := Value;
  end;

  if (Value <> nil) then
    Value.FreeNotification(Self)
  else
    UpdateLabel;  
end;

procedure TAdvDBLookupComboBox.StringGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  stl,ofsy:integer;
  s:string;
begin
  FStringGrid.Canvas.Pen.Width := 1;

  if ARow = 0 then
    FStringGrid.Canvas.Font.Assign(FColumns.Items[ACol].TitleFont)
  else
    FStringGrid.Canvas.Font.Assign(FColumns.Items[ACol].Font);

  if gdFixed in state then
  begin
    FStringGrid.Canvas.Brush.Color := FHeaderColor;
    FStringGrid.Canvas.FillRect(Rect);
    rect.Left := rect.Left + 1;
    if Acol = FSortColumns then
    begin
      ofsy := rect.top + ((rect.Bottom - rect.top)-FbitmapUP.Height) div 2;
      if FSensSorted = stAscendent then
        FStringGrid.Canvas.Draw(rect.Left + 1,ofsy,FbitmapDown)
      else
        FStringGrid.Canvas.Draw(rect.Left + 1,ofsy,FbitmapUp);

      rect.Left := rect.Left + FBitmapdown.Width + 3; //Draw text after bitmap
    end;
  end
  else
  begin
    FStringGrid.Canvas.Brush.Color := FColumns.Items[ACol].FColor;
    if (gdSelected in state)  then
    begin
      FStringGrid.Canvas.Brush.Color := FSelectionColor;
      FStringGrid.Canvas.Font.Color := FSelectionTextColor;
    end;
    FStringGrid.Canvas.FillRect(Rect);
  end;

  case FColumns.Items[ACol].FAlignment of
  taLeftJustify :  Stl := DT_LEFT;
  taRightJustify : Stl := DT_RIGHT;
  taCenter       : Stl := DT_CENTER;
  else
    Stl := DT_LEFT;
  end;

  rect.Right := rect.Right - 2;
  rect.Left := rect.Left + 2;

  stl := stl or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS or DT_NOPREFIX;

  if ARow = 0 then
  begin
    if FColumns.Items[ACol].Title <> '' then
      s := FColumns.Items[ACol].Title
    else
      s := FColumns.Items[ACol].FListField
  end    
  else
     s := FStringGrid.Cells[acol,arow];

  DrawText(FStringGrid.Canvas.Handle,pchar(s),length(s),rect,stl);
end;

procedure TAdvDBLookupComboBox.LoadGridOptions;
begin
  FCurrentSearch := '';
  FStringGrid.Options:= [goFixedVertLine,
                         goFixedHorzLine,
                         goVertLine,
                         goHorzLine,
                         goDrawFocusSelected,
                         //goColSizing,
                         goTabs,
                         goRowSelect];

  FStringGrid.Left := 0;
  FStringGrid.Top := 0;
  FStringGrid.Width := FDropWidth;
  FStringGrid.Height := FDropHeight;
  FStringGrid.Color := FDropColor;
  FStringGrid.ColCount := FColumns.Count;
  FStringGrid.FixedCols := 0;
  FStringGrid.RowCount := 2;
  FStringGrid.DefaultDrawing := False;
  FStringGrid.GridLineWidth := 1;

  FStringGrid.OnDrawCell := StringGridDrawCell;
  FStringGrid.OnMouseDown := Gridmousedown;
  FStringGrid.OnKeyPress := StringGridKeyPress;
  FStringGrid.OnSelectCell := StringGridSelectCell;
end;

function TAdvDBLookupComboBox.GetItemIndex: integer;
begin
  Result := FItemIndex;
end;

procedure TAdvDBLookupComboBox.SetItemIndex(Value: integer);
begin
  if FColumns.Count > 0 then
  begin
    if Value >= FAllfields.Count then
      Value := FAllfields.Count
  end
  else
    Value := 0;

  if Value < 0 then Value := 0;

  FItemIndex := Value;
  if FAllFields.Count = 0 then
  begin
    Exit;
  end;

  try
    Text := GridToString;
  except
    on Exception do;
  end;

  if FChkClosed then
    Exit;
  try
    FStringGrid.Row := FItemIndex + 1;
  except
    on Exception do;
  end;
end;

function TAdvDBLookupComboBox.GetLabelCaption: string;
begin
  if FLabel <> nil then
    Result := FLabel.Caption
  else
    Result := '';
end;

procedure TAdvDBLookupComboBox.SetLabelAlwaysEnabled(const Value: Boolean);
begin
  FLabelAlwaysEnabled := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvDBLookupComboBox.SetLabelCaption(const Value: string);
begin
  if FLabel = nil then
     FLabel := CreateLabel;
  FLabel.Caption := Value;
  UpdateLabel;
end;

procedure TAdvDBLookupComboBox.SetLabelFont(const Value: TFont);
begin
  FLabelFont.Assign(Value);
end;

procedure TAdvDBLookupComboBox.SetLabelMargin(const Value: Integer);
begin
  FLabelMargin := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvDBLookupComboBox.SetLabelPosition(const Value: TLabelPosition);
begin
  FLabelPosition := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TAdvDBLookupComboBox.SetLabelTransparent(const Value: Boolean);
begin
  FLabelTransparent := Value;
  if FLabel <> nil then UpdateLabel;
end;


procedure TAdvDBLookupComboBox.GridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  r,c,i,j: Integer;
begin
  FStringGrid.MouseToCell(x,y,c,r);
  if (c < 0) or (r < 0) then // click outside grid cells
    Exit;

  if r > 0 then
  begin
    FAccept := True;
    // ItemIndex := r - 1;
    HideGridList;
  end
  else
  begin
    r := TFindList(FAllfields.Items[ItemIndex]).BaseIndex;
    if FSortColumns = c then
    begin
      if FSensSorted = stAscendent then
        FSensSorted := stDescendent
      else
        FSensSorted := stAscendent;
    end
    else
    begin
      FSensSorted := stAscendent;
      FSortColumns := c;
      FSortColumn := Columns[c].Name;
    end;
    FAllfields.Sort(sortfield);

    for i:=0 to fColumns.Count-1 do
    begin
      for j:=0 to FAllfields.Count-1 do
      begin
        FStringGrid.Cells[i,j+1] := TFindList(FAllfields.Items[j]).Strings[i];
        if TFindList(FAllfields.Items[j]).BaseIndex = r then
        begin
          ItemIndex := j;
        end;
      end;
    end;
    FStringGrid.Invalidate;
  end;
end;

procedure TAdvDBLookupComboBox.StringGridKeyPress(Sender: TObject; var Key: Char);
var
  i,lx: Integer;
  s: string;
  OldSearch: string;
begin
  if not CheckDataSet then
    Exit;

  if FChkClosed then
    Exit;

  if Key = #13 then
  begin
    FAccept := True;
    HideGridList;
    Exit;
  end;

  if FColumns.Count = 0 then
    Exit;

  lx := -1;

  if (Key = #8) then
  begin
    if (Length(FCurrentSearch) > 0) then
      Delete(FCurrentSearch,Length(FCurrentSearch),1)
  end
  else
    FCurrentSearch := AnsiUpperCase(FCurrentSearch + Key);

  OldSearch := FCurrentSearch;

  for i := 0 to FAllfields.Count - 1 do
  begin
    s := UpperCase(TFindlist(FAllfields.items[i]).Strings[FSortColumns]);

    if AnsiPos(FCurrentSearch,s)=1 then
    begin
      ItemIndex := i;

      if Assigned(FOnLookupSuccess) then
        FOnLookupSuccess(Self,FCurrentSearch,s);

      FCurrentSearch := OldSearch;
      Exit;
    end;
    if AnsiPos(UpperCase(key),s)=1 then
      lx := i;
  end;

  FCurrentSearch := OldSearch;

  if not (LookupMethod = lmFast) then
    Exit;

  if lx > -1 then
  begin
    FCurrentsearch := key;
    ItemIndex := lx;
  end
  else
    FCurrentSearch := '';
end;

procedure TAdvDBLookupComboBox.StringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if FDataScroll  then
    Exit;
  // compares (arow-1<>FitemIndex)
  if (ARow > 0) and (ARow - 1 <> FItemIndex) then
  begin
    ItemIndex := ARow - 1;
  end;  
  FCurrentSearch := '';
end;

procedure TAdvDBLookupComboBox.Change;
var
  Fld: TField;
  s:string;
begin
  if not FDisableChange then
    inherited;
  
  if CheckDataSet and not FDataScroll then
  begin
    FDataScroll := True;

    if (LookupLoad = llOnNeed) and (FAllFields.Count = 0) then
      Exit;

    if Assigned(FBookmark) and (FChkClosed) then
    if FListDataLink.DataSource.DataSet.BookmarkValid(FBookMark) then
       FListDataLink.DataSource.DataSet.FreeBookmark(FBookMark);
    FListDataLink.DataSource.DataSet.DisableControls;

    with FListDataLink.DataSource.DataSet do
    begin
      First;
      while not Eof do
      begin
        if (FieldByName(KeyField).DisplayText = TFindList(FAllfields.Items[FItemIndex]).KeyField) then
        begin
          if (FilterField <> '') and (FilterValue <> '') then
          begin
            fld := FieldByName(FilterField);
            if Assigned(fld) then
            begin
              if MatchStrEx(FilterValue,fld.DisplayText,False) then
                Break;
            end
            else
              Break;
          end
          else
            Break;
        end;
        Next;
      end;

      if LabelField <> '' then
      begin
        if Text = '' then
          LabelCaption := ''
        else
        begin
          Fld := FieldByName(LabelField);

          if Assigned(Fld) then
          begin
            s := Fld.DisplayText;
            {$IFDEF TMSDEBUG}
            outputdebugstring(pchar('change:'+text+':'+s));
            {$ENDIF}
            LabelCaption := s;
          end;
        end;
      end;
    end;

    if FChkClosed then
      FBookmark := FListDataLink.DataSource.DataSet.GetBookmark;
    FListDataLink.DataSource.DataSet.EnableControls;
    FDataScroll := False;
  end;
end;

function TAdvDBLookupComboBox.GetDatasource: TDatasource;
begin
  Result := FDataSourceLink.Datasource;
end;

procedure TAdvDBLookupComboBox.SetDatasource(const Value: TDatasource);
begin
  if (FDataSourceLink.Datasource <> Value) then
  begin
    if (Value = FListDataLink.Datasource) AND (Value <> nil) then
      raise Exception.Create('Circular Referance: ' + Value.Name);
    FDataSourceLink.Datasource := Value;
  end;

  if (Value <> nil) then
    Value.FreeNotification(Self)
  else
    UpdateLabel;  
end;

function TAdvDBLookupComboBox.CheckEditDataSet: boolean;
begin
  Result := False;
  if FColumns.Count < 1 then
    Exit;

  if (FDataField = '') or (FKeyField = '') then
    Exit;
  if not CheckDataSet then  Exit;
  FDataSourceLink.Datasource.Edit;
  Result :=true;
end;

procedure TAdvDBLookupComboBox.SetSortColumns(const Value: Integer);
var
  tmpix:Integer;
begin
  if (Value >= FColumns.Count) or (Value < 0) then
    Exit;
  if (ItemIndex < 0) or (ItemIndex >= FAllfields.Count) then
    Exit;
  FSortColumns := Value;
  tmpix := TFindList(FAllfields.items[ItemIndex]).BaseIndex;
  FAllfields.Sort(SortField);
  ItemIndex := GetRealItemIndex(tmpix);
end;

function TAdvDBLookupComboBox.GetRealItemIndex(index: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FAllfields.Count - 1 do
  begin
    if TFindList(FAllfields.Items[i]).BaseIndex = Index then
    begin
      Result := i;
      Exit;
    end;
  end;
end;


procedure TAdvDBLookupComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_DELETE) then
  begin
    if SelLength > 0 then
    begin
      FCurrentSearch := AnsiUpperCase(Copy(Text,1,SelStart));
    end
    else
      FCurrentSearch := '';
  end;
end;


function TAdvDBLookupComboBox.FindField(Value:string): Boolean;
var
  i: Integer;
  s: string;
begin
  Result := False;
  for i := 0 to FAllfields.Count - 1 do
  begin
    s := UpperCase(TFindlist(FAllfields.Items[i]).Strings[0]);
    if AnsiPos(Value,s) = 1 then
    begin
      Result := True;
      Exit;
    end;
  end;
end;


procedure TAdvDBLookupComboBox.KeyPress(var Key: Char);
var
  lx,i, OldSS: Integer;
  s: string;
  OldSearch: string;
begin

  if not EditorEnabled then
  begin
    Key := #0;
    Exit;
  end;

  if Key = #27 then
  begin
    inherited;
    Exit;
  end;
  


  if (Key = #8) then
  begin
    s := Text;
    OldSS := SelStart;
    system.Delete(s,SelStart,SelLength+1);
    FCurrentSearch := s;
    Text := s;
    Key := #0;
    SelStart := OldSS;
    Exit;

    {
    end
    else
    begin
      if (Length(FCurrentSearch) > 0) then
        Delete(FCurrentSearch,Length(FCurrentSearch),1);
    end;
    OldSearch := FCurrentSearch;    
    }

  end
  else
  begin
    OldSearch := FCurrentSearch;
    FCurrentSearch := AnsiUpperCase(FCurrentSearch + Key);
  end;

  if SelLength > 0 then
  begin
    FCurrentSearch := AnsiUpperCase(Copy(Text,1,SelStart) + Key);
  end;

  if Assigned(OnTextToGridListItem) then
    OnTextToGridListItem(Self,FCurrentSearch);

  if LookupMethod = lmRequired then
  begin
    if not FindField(FCurrentSearch) then
    begin
      Key := #0;

      if Assigned(FOnLookupError) then
        FOnLookupError(Self,FCurrentSearch);

      FCurrentSearch := OldSearch;

      if DropDownType = ddOnError then
        ShowGridList(True);

      inherited;  
      Exit;
    end;
  end;

  inherited;

  lx := -1;

  for i := 0 to FAllfields.Count - 1 do
  begin
    s := UpperCase(TFindlist(FAllfields.Items[i]).Strings[0]);

    if AnsiPos(FCurrentSearch,s) = 1 then
    begin
      ItemIndex := i;
      Key := #0;

      FAccept := True;
      UpdateLookup;

      if Assigned(FOnLookupSuccess) then
        FOnLookupSuccess(Self,FCurrentSearch,s);

      SelStart := Length(FCurrentSearch);
      SelLength := Length(Text) - SelStart;

      Exit;
    end;
    if AnsiPos(UpperCase(key),s) = 1 then
      lx := i;
  end;

  if not (LookupMethod = lmFast) then
    Exit;

  if lx > -1 then
  begin
    FCurrentSearch := key;

    ItemIndex := lx;
    Key := #0;
    FAccept := True;
    UpdateLookup;
    SelStart := 1;
    SelLength := Length(Text);
  end
  else
  begin
    FCurrentSearch := '';
  end;

end;


procedure TAdvDBLookupComboBox.SetFilterField(const Value: string);
begin
  if (FFilterField <> Value) then
  begin
    FFilterField := Value;
    LoadFromListSource;
  end;  
end;

procedure TAdvDBLookupComboBox.SetFilterValue(const Value: string);
begin
  if FFilterValue <> Value then
  begin
    FFilterValue := Value;
    LoadFromListSource;
  end;
end;

{$IFDEF TMSDEBUG}
procedure TAdvDBLookupComboBox.DebugTest;
begin
  Showmessage('Jump to Bookmark and Folditemindex = '+Inttostr(Folditemindex)+' Fitemindex='+Inttostr(Fitemindex));
  if Assigned(fbookmark) then
    if FListDataLink.DataSource.DataSet.BookmarkValid(FBookmark) then
       FListDataLink.DataSource.DataSet.GotoBookmark(FBookmark);
end;
{$ENDIF}


procedure TAdvDBLookupComboBox.SetLabelField(const Value: string);
begin
  FLabelField := Value;
  GridToString;
end;

procedure TAdvDBLookupComboBox.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
begin
  inherited;
  if FLabel <> nil then
    UpdateLabel;
end;

procedure TAdvDBLookupComboBox.SetSortColumn(const Value: string);
var
  i: Integer;
begin
  FSortColumn := Value;
  for i := 1 to Columns.Count do
  begin
    if Value = Columns[i - 1].Name then
      FSortColumns := i - 1;
  end;
end;

procedure TAdvDBLookupComboBox.SetLabelWidth(const Value: Integer);
begin
  FLabelWidth := Value;
  if Assigned(FLabel) then
    UpdateLabel;
end;

procedure TAdvDBLookupComboBox.SetSortDownGlyph(const Value: TBitmap);
begin
  FBitmapUp.Assign(Value);
end;

procedure TAdvDBLookupComboBox.SetSortUpGlyph(const Value: TBitmap);
begin
  FBitmapDown.Assign(Value);
end;

procedure TAdvDBLookupComboBox.UpdateText(s: string);
begin
  FDisableChange := true;
  Text := s;
  FDisableChange := false;
end;

procedure TAdvDBLookupComboBox.SetLookupLoad(const Value: TLookupLoad);
var
  s: string;
begin
  FLookupLoad := Value;
  if FLookupLoad = llAlways then
  begin
    s := Text;
    LoadFromListSource;
    Text := s;
  end;
end;

{ TInplaceStringGrid }

procedure TInplaceStringGrid.WMKeyDown(var Msg: TWMKeydown);
begin
  if (msg.CharCode = VK_TAB) then
    Exit;

  if (msg.Charcode = VK_ESCAPE) or (msg.CharCode = VK_F4) or
     ((msg.CharCode = VK_UP) and (GetKeyState(VK_MENU) and $8000 = $8000)) then
  begin
    PostMessage((Parent as TForm).Handle,WM_CLOSE,0,0);
  end;

  inherited;
end;

procedure TInplaceStringGrid.DoExit;
begin
  inherited;
  if Visible then
    ParentEdit.HideGridList;
end;

{ TDropForm }

procedure TDropForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  { Create a sizeable window with no caption }
  if FSizeable then
    Params.Style := WS_ThickFrame or WS_PopUp or WS_Border;
end;

procedure TDropForm.WMClose(var Msg: TMessage);
begin
  inherited;
  self.Free;
end;

//----------------------------------------------------
{ TDBColumnItem }

procedure TDBColumnItem.Assign(Source: TPersistent);
begin
  if Source is TDBColumnItem then
  begin
    Color := TDBColumnItem(source).Color;
    ColumnType := TDBColumnItem(source).ColumnType;
    Width := TDBColumnItem(source).Width;
    Alignment := TDBColumnItem(source).Alignment;
    Font.Assign(TDBColumnItem(source).Font);
    Title := TDBColumnItem(Source).Title;
    TitleFont.Assign(TDBColumnItem(source).TitleFont);
  end;
end;

constructor TDBColumnItem.Create(Collection: TCollection);
begin
  inherited;
  FFont := TFont.Create;
  FTitleFont := TFont.Create;
  FWidth := 100;
  FColor := clWindow;
end;

destructor TDBColumnItem.Destroy;
begin
  FFont.Free;
  FTitleFont.Free;
  inherited;
end;

function TDBColumnItem.GetListField: string;
begin
  Result := FListField;
end;

function TDBColumnItem.GetDisplayName: string;
begin
  Result := Name;
end;

procedure TDBColumnItem.SetAlignment(const value: tAlignment);
begin
  FAlignment := Value;
  TDBColumnCollection(collection).FOwner.Invalidate;
end;

procedure TDBColumnItem.SetColor(const value: TColor);
begin
  FColor := Value;
  TDBColumnCollection(collection).FOwner.Invalidate;
end;

procedure TDBColumnItem.SetColumnType(const Value: TDBColumnType);
begin
  FColumnType := Value;
  TDBColumnCollection(collection).FOwner.Invalidate;

end;

procedure TDBColumnItem.SetListField(const Value: string);
begin
  FListField := Value;
  with (Collection as TDBColumnCollection) do
  begin
    with (GetOwner as TAdvDBLookupComboBox) do
    begin
      if (csDesigning in ComponentState) and
        not (csLoading in ComponentState) then
          LoadFromListsource;
    end;
  end;
end;

procedure TDBColumnItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  TDBColumnCollection(collection).FOwner.Invalidate;
end;

procedure TDBColumnItem.SetWidth(const Value: integer);
begin
  FWidth := Value;
  TDBColumnCollection(collection).FOwner.Invalidate;
end;

function TDBColumnItem.GetCombo: TAdvDBLookupComboBox;
begin
  Result := TDBColumnCollection(Collection).FOwner;//22 Octombrie
  // Old source not compiled under D5 
end;

function TDBColumnItem.GetName: string;
begin
  if FName <> '' then
    Result := FName
  else
    Result := 'Column' + IntToStr(Index);
end;

procedure TDBColumnItem.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TDBColumnItem.SetTitleFont(const Value: TFont);
begin
  FTitleFont.Assign(Value);
end;

{ TDBColumnCollection }

function TDBColumnCollection.Add: TDBColumnItem;
begin
  Result := TDBColumnItem(inherited Add);
end;

constructor TDBColumnCollection.Create(AOwner: TAdvDBLookupComboBox);
begin
  inherited Create(TDBColumnItem);
  FOwner := AOwner;
end;

function TDBColumnCollection.GetItem(Index: Integer): TDBColumnItem;
begin
  Result := TDBColumnItem(inherited Items[index]);
end;

function TDBColumnCollection.GetOwner: tPersistent;
begin
  Result := FOwner;
end;

function TDBColumnCollection.Insert(index: integer): TDBColumnItem;
begin
  {$IFNDEF DELPHI4_LVL}
  Result := TDBColumnItem(inherited Add);
  {$ELSE}
  Result := TDBColumnItem(inherited Insert(index));
  {$ENDIF}
end;

procedure TDBColumnCollection.SetItem(Index: Integer;
  const Value: TDBColumnItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TDBColumnCollection.Update(Item: TCollectionItem);
begin
  inherited;
end;


{ TDBGridDataLink }

procedure TDBGridDataLink.ActiveChanged;
begin
  inherited;
  if Assigned(FGrid) and Assigned(DataSet) then
  begin
    with FGrid do
    begin
      SetActive(Dataset.Active);
      FButton.Enabled := (DataSet.Active) and (FAllFields.Count > 0);

      if (LookupLoad = llOnNeed) and (FAllFields.Count = 0) then
      begin
        Text := GridToString;
      end;  
      UpdateLabel;  
    end;  
  end;
end;

constructor TDBGridDataLink.Create(AGrid: TAdvDBLookupComboBox);
begin
  inherited Create;
  FGrid := AGrid;
  FNumberRecords := 0;
end;


procedure TDBGridDataLink.RecordChanged(Field: TField);
begin
  inherited;
  {$IFDEF TMSDEBUG}
  outputdebugstring(pchar('in recordchanged:'));
  {$ENDIF}

  if Assigned(FGrid) and Assigned(DataSet) then
  begin
    if not FGrid.FInLookup then
    begin
      case  DataSet.State of
      dsBrowse:
        begin
          if (OldState = dsEdit) or (FNumberRecords <> DataSet.RecordCount) then
            begin
            OldState := dsBrowse;
            FGrid.LoadFromListsource;
            FGrid.FDataSourceLink.Modify;
            end;
          OldState := dsBrowse;
          FGrid.UpdateLabel;
         end;
      dsEdit:
        begin
          OldState := dsEdit;
        end;
      end; //end csse
    end;
  end;
end;



destructor TDBGridDataLink.Destroy;
begin
  inherited;
end;



procedure TDBGridDataLink.DataSetChanged;
begin
  inherited;

  with FGrid do
  begin
    if CheckDataSet and not FGrid.FInLookup then
    begin
      if (LookupLoad = llOnNeed) and (FAllFields.Count = 0) then
      begin
        Text := GridToString;
      end;
      UpdateLabel;
    end;
  end;
end;

{ TFindList }

constructor TFindList.Create;
begin
  inherited Create;
  FGrid := Agrid;
end;

destructor Tfindlist.Destroy;
begin
  inherited;
end;

{ TglobalList }

{ TDBGridLookupDataLink }

procedure TDBGridLookupDataLink.ActiveChanged;
begin
  inherited;
  if Assigned(FGrid) and Assigned(DataSet) then
  begin
    with FGrid do
    begin
      SetActive(Dataset.Active);
      FButton.Enabled := (DataSet.Active) and (FAllFields.Count > 0);

      if (LookupLoad = llOnNeed) and (FAllFields.Count = 0) then
      begin
        Text := GridToString;
      end;
      UpdateLabel;  
    end;

  end;
end;

constructor TDBGridLookupDataLink.Create(AGrid: TAdvDBLookupComboBox);
begin
  inherited Create;
  FGrid := AGrid;
end;

procedure TDBGridLookupDataLink.DataSetChanged;
begin
  inherited;
  Modify;

  with FGrid do
  begin
    if CheckDataSet and not FGrid.FInLookup then
    begin
      if (LookupLoad = llOnNeed) and (FAllFields.Count = 0) then
      begin
        Text := GridToString;
      end;
      UpdateLabel;
    end;
  end;
end;

procedure TDBGridLookupDataLink.DataSetScrolled(distance: integer);
begin
  inherited;
  Modify;
end;

destructor TDBGridLookupDataLink.Destroy;
begin
  inherited;
end;

procedure TDBGridLookupDataLink.Modify;
Var
  df: String;
  i: Integer;
begin
  if Assigned(FGrid) and Assigned(DataSet) then
  begin
    if FGrid.DataField = '' then
      Exit;
    df := DataSource.DataSet.FieldByName(FGrid.DataField).DisplayText;
    with FGrid do
    begin
      if not Assigned(FGrid.ListSource.DataSet) then Exit;
      if (FAccept) then
      begin
        Change;
        Exit;
      end;

      if (FAllFields.Count = 0) and (LookupLoad = llOnNeed) then
      begin
        Text := GridToString;
        Exit;
      end;

      for i := 0 to FAllfields.Count - 1 do
        if TFindList(FAllfields.Items[i]).KeyField = df then
        begin
          FItemindex := i;
          Text := GridToString;
          Exit;
        end;
      Text := '';
    end;
  end;
end;

procedure TDBGridLookupDataLink.RecordChanged(Field: TField);
begin
  inherited;
  if not FGrid.FInLookup then
    Modify;
  FGrid.UpdateLabel;
end;

{ TEllipsLabel }

procedure TLabelEx.Paint;
var
  R: TRect;
  DrawStyle: DWORD;

begin
  R := GetClientRect;

  if not Transparent then
  begin
    Canvas.Brush.Color := Color;
    Canvas.Pen.Color := Color;
    Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
  end;

  Canvas.Brush.Style := bsClear;

  DrawStyle := ALIGNSTYLE[Alignment] or WORDWRAPSTYLE[WordWrap] or
    LAYOUTSTYLE[Layout] or ELLIPSSTYLE[FEllipsType] or ACCELSTYLE[ShowAccelChar];

  {$IFDEF DELPHI4_LVL}
  DrawStyle := DrawTextBiDiModeFlags(DrawStyle);
  {$ENDIF}

  Canvas.Font := Font;

  if not Enabled then
  begin
    OffsetRect(R, 1, 1);
    Canvas.Font.Color := clBtnHighlight;
    DrawTextEx(Canvas.Handle,PChar(Caption),Length(Caption),R, DrawStyle, nil);
    OffsetRect(R, -1, -1);
    Canvas.Font.Color := clBtnShadow;
    DrawTextEx(Canvas.Handle,PChar(Caption),Length(Caption),R, DrawStyle, nil);
  end
  else
    DrawTextEx(Canvas.Handle,PChar(Caption),Length(Caption),R, DrawStyle, nil);
end;

procedure TLabelEx.SetEllipsType(const Value: TEllipsType);
begin
  if FEllipsType <> Value then
  begin
    FEllipsType := Value;
    Invalidate;
  end;
end;


initialization


end.

