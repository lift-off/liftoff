{$I TMSDEFS.INC}
{***********************************************************************}
{ TDBPlanner component                                                  }
{ for Delphi & C++Builder                                               }
{ version 1.5                                                           }
{                                                                       }
{ written by TMS Software                                               }
{            copyright © 1999-2002                                      }
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


unit DBPlanner;

interface

uses
  Planner, Classes, DB, Windows, SysUtils, Graphics, Dialogs, ComObj, ActiveX;


const
  CDaysInMonth:array[1..12] of word = (31,28,31,30,31,30,31,31,30,31,30,31);

  MAJ_VER = 1; // Major version nr.
  MIN_VER = 5; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 6; // Build nr.
  DATE_VER = 'June, 2003'; // Month version


type
  TDBItemSource = class;

  TCreateKeyEvent = procedure(Sender:TObject; APlannerItem: TPlannerItem; var Key:string) of object;

  TAcceptEvent = procedure(Sender:TObject; Fields:TFields; var Accept: Boolean) of object;

  TDBItemSQLEvent = procedure(Sender:TObject; APlannerItem:TPlannerItem) of object;

  TItemSource = class(TComponent)
  private
    FPlanner: TPlanner;
    FUpdateCount: Integer;
    FOnCreateKey: TCreateKeyEvent;
    FActive: Boolean;
    FOnSetFilter: TNotifyEvent;
    FOnResetFilter: TNotifyEvent;
    FOnAccept: TAcceptEvent;
    FLocateIdx: Integer;
    FLocateSpecifier: string;
    FLocateParams: TFindTextParams;
    procedure SetPlanner(Value: TPlanner);
    procedure SetActive(const Value: Boolean);
  protected
  public
    procedure ClearDBItems; virtual;
    procedure ReadDBItems; virtual;
    procedure WriteDBItem; virtual;
    procedure ReadDBItem; virtual;
    procedure SynchDBItems; virtual;
    procedure AddDBItem; virtual;
    procedure GotoDBItem; virtual;
    procedure DeleteDBItem(APlanner:TPlanner); virtual;
    procedure ItemChanged(DBKey:string); virtual;
    procedure Refresh; virtual;
    procedure Reload; virtual;
    procedure Next; virtual;
    procedure Prev; virtual;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure PlannerChanged; virtual;
    property Planner:TPlanner read FPlanner write SetPlanner;
    procedure BeginUpdate;
    procedure EndUpdate;
    function IsUpdating: Boolean;
    function CreateKey:string; virtual;
    function LocateFirstItem(Specifier: string; Params: TFindTextParams;
      var StartTime,EndTime: TDateTime;var Key:string): Boolean; virtual;
    function LocateNextItem(var StartTime,EndTime: TDateTime;
      var Key:string):Boolean; virtual;
    function PosToDay(Pos: Integer): TDateTime; virtual;
    function PosToRes(Pos: Integer): Integer; virtual;
    procedure MapItemTimeOnPlanner(APlannerItem: TPlannerItem); virtual;
  published
    property Active: Boolean read FActive write SetActive default true;
    property OnCreateKey: TCreateKeyEvent read FOnCreateKey write FOnCreateKey;
    property OnResetFilter: TNotifyEvent read FOnResetFilter write FOnResetFilter;
    property OnSetFilter: TNotifyEvent read FOnSetFilter write FOnSetFilter;
    property OnAccept: TAcceptEvent read FOnAccept write FOnAccept;
  end;

  TDBPlannerDataLink = class(TDataLink)
  private
    FDBItemSource: TDBItemSource;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure RecordChanged(Field: TField); override;
  public
    constructor Create(ADBItemSource: TDBItemSource);
    destructor Destroy; override;
  end;

  TFieldsItemEvent = procedure(Sender: TObject; Fields:TFields; Item: TPlannerItem) of object;

  TResourceToPosEvent = procedure(Sender: TObject; Field: TField;
    var Position: Integer; var Accept: Boolean) of object;

  TPosToResourceEvent = procedure(Sender: TObject; Field: TField;
    Position: Integer) of object;

  TDBItemSource = class(TItemSource)
  private
    FEndTimeField: string;
    FStartTimeField: string;
    FKeyField: string;
    FResourceField: string;
    FSubjectField: string;
    FNotesField: string;
    FAutoIncKey: Boolean;
    FDataLink: TDBPlannerDataLink;
    FOnFieldsToItem: TFieldsItemEvent;
    FOnItemToFields: TFieldsItemEvent;
    FOnChangeQuery: TNotifyEvent;
    FOnPositionToResource: TPosToResourceEvent;
    FOnResourceToPosition: TResourceToPosEvent;
    FReadOnly: Boolean;
    FOnInsertItem: TDBItemSQLEvent;
    FOnDeleteItem: TDBItemSQLEvent;
    FOnUpdateItem: TDBItemSQLEvent;
    FOnItemsRead: TNotifyEvent;
    FUpdateByQuery: Boolean;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetEndTimeField(const Value: string);
    procedure SetStartTimeField(const Value: string);
    procedure SetKeyField(const Value: string);
    procedure SetNotesField(const Value: string);
    procedure SetSubjectField(const Value: string);
    procedure SetResourceField(const Value: string);
    procedure SetReadOnly(const Value: Boolean);
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    function CheckDataSet: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Next; override;
    procedure Prev; override;
    function LocateFirstItem(Specifier: string; Params: TFindTextParams;
      var StartTime,EndTime: TDateTime;var Key:string): Boolean; override;
    function LocateNextItem(var StartTime,EndTime: TDateTime;
      var Key:string):Boolean; override;
  published
    property AutoIncKey: Boolean read FAutoIncKey write FAutoIncKey;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property StartTimeField: string read FStartTimeField write SetStartTimeField;
    property EndTimeField: string read FEndTimeField write SetEndTimeField;
    property KeyField: string  read FKeyField write SetKeyField;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property ResourceField: string read FResourceField write SetResourceField;
    property SubjectField: string read FSubjectField write SetSubjectField;
    property NotesField: string read FNotesField write SetNotesField;
    property UpdateByQuery: Boolean read FUpdateByQuery write FUpdateByQuery;
    property OnFieldsToItem: TFieldsItemEvent read FOnFieldsToItem write FOnFieldsToItem;
    property OnItemToFields: TFieldsItemEvent read FOnItemToFields write FOnItemToFields;
    property OnChangeQuery: TNotifyEvent read FOnChangeQuery write FOnChangeQuery;
    property OnResourceToPosition: TResourceToPosEvent read FOnResourceToPosition
      write FOnResourceToPosition;
    property OnPositionToResource: TPosToResourceEvent read FOnPositionToResource
      write FOnPositionToResource;
    property OnInsertItem: TDBItemSQLEvent read FOnInsertItem write FOnInsertItem;
    property OnDeleteItem: TDBItemSQLEvent read FOnDeleteItem write FOnDeleteItem;
    property OnUpdateItem: TDBItemSQLEvent read FOnUpdateItem write FOnUpdateItem;
    property OnItemsRead: TNotifyEvent read FOnItemsRead write FOnItemsRead;
  end;

  TDBDayMode = (dmMultiDay, dmMultiResource, dmMultiDayRes, dmMultiResDay);

  TResourceNameEvent = procedure(Sender: TObject; ResourceIndex: Integer; var ResourceName: string) of object;

  TDBDaySource = class(TDBItemSource)
  private
    FMode: TDBDayMode;
    FDayIncrement: Integer;
    FDay: TDateTime;
    FAutoHeaderUpdate: Boolean;
    FDateFormat: string;
    FNumberOfDays: Integer;
    FNumberOfResources: Integer;
    FOnGetResourceName: TResourceNameEvent;
    procedure SetDay(const Value: TDateTime);
    procedure SetMode(const Value: TDBDayMode);
    procedure SetNumberOfDays(const Value: Integer);
    procedure SetNumberOfResources(const Value: Integer);
    procedure ConfigurePlanner(var Span: Integer);
    function CalcItemPos(DatePos,ResourcePos: Integer): Integer;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SynchDBItems; override;
    procedure ReadDBItems; override;
    procedure WriteDBItem; override;
    procedure ReadDBItem; override;
    procedure AddDBItem; override;
    procedure GotoDBItem; override;
    procedure DeleteDBItem(APlanner: TPlanner); override;
    procedure ItemChanged(DBKey:string); override;
    procedure Next; override;
    procedure Prev; override;
    procedure PlannerChanged; override;
    function PosToDay(Pos: Integer): TDateTime; override;
    function PosToRes(Pos: Integer): Integer; override;
    procedure MapItemTimeOnPlanner(APlannerItem: TPlannerItem); override;
  published
    property AutoHeaderUpdate: Boolean read FAutoHeaderUpdate write FAutoHeaderUpdate default False;
    property DateFormat: string read FDateFormat write FDateFormat;
    property Day: TDateTime read FDay write SetDay;
    property DayIncrement: Integer read FDayIncrement write FDayIncrement default 1;
    property Mode: TDBDayMode read FMode write SetMode;
    property NumberOfDays: Integer read FNumberOfDays write SetNumberOfDays default 7;
    property NumberOfResources: Integer read FNumberOfResources write SetNumberOfResources default 1;
    property OnGetResourceName: TResourceNameEvent read FOnGetResourceName write FOnGetResourceName;
  end;

  TDBCustomPeriodSource = class(TDBItemSource)
  private
    FNumberOfResources: Integer;
    FOnGetResourceName: TResourceNameEvent;
    FAutoHeaderUpdate: Boolean;
    procedure ConfigurePlanner;
    procedure SetNumberOfResources(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    procedure SynchDBItems; override;
    procedure ReadDBItems; override;
    procedure WriteDBItem; override;
    procedure ReadDBItem; override;
    procedure AddDBItem; override;
    procedure GotoDBItem; override;
    procedure DeleteDBItem(APlanner: TPlanner); override;
    procedure ItemChanged(DBKey:string); override;
    procedure Next; override;
    procedure Prev; override;
  public
  published
    property AutoHeaderUpdate: Boolean read FAutoHeaderUpdate write FAutoHeaderUpdate default False;
    property NumberOfResources: Integer read FNumberOfResources write SetNumberOfResources default 1;
    property OnGetResourceName: TResourceNameEvent read FOnGetResourceName write FOnGetResourceName;
  end;

  TDBPeriodSource = class(TDBCustomPeriodSource)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    procedure SetEndDate(const Value: TDateTime);
    procedure SetStartDate(const Value: TDateTime);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    procedure PlannerChanged; override;
    procedure UpdatePlanner; virtual;
  published
    property StartDate: TDateTime read FStartDate write SetStartDate;
    property EndDate: TDateTime read FEndDate write SetEndDate;
  end;

  TDBHalfDayPeriodSource = class(TDBPeriodSource)
  private
  public
    procedure PlannerChanged; override;
    procedure UpdatePlanner; override;
  published
  end;

  TDBMonthSource = class(TDBCustomPeriodSource)
  private
    FMonth: integer;
    FYear: integer;
    procedure SetMonth(const Value: integer);
    procedure SetYear(const Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    procedure PlannerChanged; override;
    procedure UpdatePlanner;
  published
    property Month: integer read FMonth write SetMonth;
    property Year: integer read FYear write SetYear;
  end;

  TDBWeekSource = class(TDBCustomPeriodSource)
  private
    FMonth: Integer;
    FYear: Integer;
    FWeekStart: Integer;
    FWeeks: Integer;
    procedure SetMonth(const Value: integer);
    procedure SetYear(const Value: integer);
    procedure SetWeekStart(const Value: Integer);
    procedure SetWeeks(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    procedure PlannerChanged; override;
    procedure UpdatePlanner;
  published
    property Month: Integer read FMonth write SetMonth;
    property Year: Integer read FYear write SetYear;
    property WeekStart: Integer read FWeekStart write SetWeekStart;
    property Weeks: Integer read FWeeks write SetWeeks;
  end;

  TDBMultiMonthSource = class(TDBItemSource)
  private
    FNumberOfMonths: Integer;
    FStartMonth: Integer;
    FYear: Integer;
    FStartDate, FEndDate: TDateTime;
    FAutoHeaderUpdate: Boolean;
    procedure ConfigurePlanner;    
    procedure SetNumberOfMonths(const Value: Integer);
    procedure SetStartMonth(const Value: Integer);
    procedure SetYear(const Value: Integer);
  public
    procedure Loaded; override;
    procedure PlannerChanged; override;
    procedure UpdatePlanner;
    constructor Create(AOwner: TComponent); override;
    procedure SynchDBItems; override;
    procedure ReadDBItems; override;
    procedure WriteDBItem; override;
    procedure ReadDBItem; override;
    procedure AddDBItem; override;
    procedure GotoDBItem; override;
    procedure DeleteDBItem(APlanner: TPlanner); override;
    procedure ItemChanged(DBKey:string); override;
    procedure Next; override;
    procedure Prev; override;
  published
    property AutoHeaderUpdate: Boolean read FAutoHeaderUpdate write FAutoHeaderUpdate default False;
    property StartMonth: Integer read FStartMonth write SetStartMonth;
    property Year: Integer read FYear write SetYear;
    property NumberOfMonths: Integer read FNumberOfMonths write SetNumberOfMonths;
  end;

  TDBTimeLineSource = class(TDBItemSource)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    procedure SetEndDate(const Value: TDateTime);
    procedure SetStartDate(const Value: TDateTime);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SynchDBItems; override;
    procedure ReadDBItems; override;
    procedure WriteDBItem; override;
    procedure ReadDBItem; override;
    procedure AddDBItem; override;
    procedure GotoDBItem; override;
    procedure DeleteDBItem(APlanner: TPlanner); override;
    procedure ItemChanged(DBKey:string); override;
    procedure Next; override;
    procedure Prev; override;
    procedure PlannerChanged; override;
    procedure UpdatePlanner;
    function PosToRes(Pos: Integer): Integer; override;
  published
    property StartDate: TDateTime read FStartDate write SetStartDate;
    property EndDate: TDateTime read FEndDate write SetEndDate;
  end;


  TDBPlanner = class(TPlanner)
  private
    FItemSource: TItemSource;
    procedure SetItemSource(const Value: TItemSource);
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure NextClick(Sender: TObject); override;
    procedure PrevClick(Sender: TObject); override;
    procedure ItemMoved(FromBegin, FromEnd, FromPos, ToBegin, ToEnd, ToPos: Integer); override;
    procedure ItemSized(FromBegin, FromEnd, ToBegin, ToEnd: Integer); override;
    procedure ItemEdited(Item: TPlannerItem); override;
    procedure ItemSelected(Item: TPlannerItem); override;
    procedure LoadItems;
    procedure MapItemTimeOnPlanner(APlannerItem: TPlannerItem); override;
    function GetVersionNr: Integer; override;
    function GetVersionString:string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Refresh; override;
    procedure FreeItem(APlannerItem:TPlannerItem); override;
    procedure UpdateItem(APlannerItem:TPlannerItem); override;
    procedure RefreshItem(APlannerItem:TPlannerItem); override;
    function CreateItem: TPlannerItem; override;
    function CreateItemAtSelection:TPlannerItem; override;
    function CreateNonDBItem: TPlannerItem;
    function CreateNonDBItemAtSelection: TPlannerItem;
    function PosToDay(Pos: Integer): TDateTime; override;
  published
    property ItemSource: TItemSource read FItemSource write SetItemSource;
  end;



implementation

uses
  PlanUtil
{$IFDEF TMSCODESITE}
//  , CsIntf
{$ENDIF TMSCODESITE}
  ;

{$IFDEF TMSCODESITE}
procedure SendMsg(s:string);
begin
  outputdebugstring(pchar(s));
end;
{$ENDIF TMSCODESITE}


{ TDBPlanner }

constructor TDBPlanner.Create(AOwner: TComponent);
begin
  inherited;
  FItemSource := nil;
  Caption.Title := ClassName;
end;

function TDBPlanner.CreateItem: TPlannerItem;
begin
  Result := inherited CreateItem;
  Items.DBItem := Result;
  if Assigned(FItemSource) then
    FItemSource.AddDBItem;
end;

function TDBPlanner.CreateNonDBItem: TPlannerItem;
begin
  Result := inherited CreateItem;
  Result.NonDBItem := True;
end;

function TDBPlanner.CreateNonDBItemAtSelection: TPlannerItem;
begin
  Result := inherited CreateItemAtSelection;
  Result.NonDBItem := True;
end;

destructor TDBPlanner.Destroy;
begin
  if Assigned(FItemSource) then
    FItemSource.Planner := nil;
  inherited;
end;

procedure TDBPlanner.FreeItem(APlannerItem: TPlannerItem);
begin
  Items.DBItem := APlannerItem.ParentItem;
  if not Items.DBItem.NonDBItem then
  begin
    if Assigned(FItemSource) then
      FItemSource.DeleteDBItem(Self);
  end;

  inherited FreeItem(APlannerItem);
end;

procedure TDBPlanner.ItemEdited(Item: TPlannerItem);
begin
  inherited;
  if Item.NonDBItem then
    Exit;

  Items.DBItem := Item.ParentItem;
  if Assigned(FItemSource) then
    FItemSource.WriteDBItem;
end;

procedure TDBPlanner.ItemMoved(FromBegin, FromEnd, FromPos, ToBegin, ToEnd,
  ToPos: Integer);
begin
  inherited;

  if Items.Selected.NonDBItem then
    Exit;

  Items.DBItem := Items.Selected.ParentItem;
  if Assigned(FItemSource) then
    FItemSource.WriteDBItem;
end;

procedure TDBPlanner.ItemSized(FromBegin, FromEnd, ToBegin,
  ToEnd: Integer);
begin
  inherited;

  if Items.Selected.NonDBItem then
    Exit;


  Items.DBItem := Items.Selected.ParentItem;
  if Assigned(FItemSource) then
    FItemSource.WriteDBItem;
end;

procedure TDBPlanner.Loaded;
begin
  inherited;
end;

procedure TDBPlanner.NextClick(Sender: TObject);
begin
  SetFocus;
  if Assigned(FItemSource) then
    FItemSource.Next;
  inherited;
end;

procedure TDBPlanner.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;
  if (AOperation = opRemove) and
     (AComponent = FItemSource) then
    begin
      FItemSource := Nil;
      Items.Clear;
    end;
end;

procedure TDBPlanner.PrevClick(Sender: TObject);
begin
  SetFocus;
  if Assigned(FItemSource) then
    FItemSource.Prev;
  inherited;
end;

procedure TDBPlanner.SetItemSource(const Value: TItemSource);
begin
  if Assigned(Value) and Assigned(Value.Planner) then
  begin
    if FItemSource = Value then
      Exit;

    if Value.Planner = Self then
    begin
      ShowMessage('Cannot assign itemsource to multiple TDBPlanner components');
      Exit;
    end;
  end;

  if Assigned(FItemSource) and (Value <> FItemSource) then
    FItemSource.Planner := nil;

  FItemSource := Value;
  if Assigned(FItemSource) then
  begin
    FItemSource.Planner := Self;
    if not (csLoading in ComponentState) then LoadItems;
  end
  else
  begin
    Items.BeginUpdate;
    Items.Clear;
    Items.EndUpdate;
  end;
end;

procedure TDBPlanner.RefreshItem(APlannerItem: TPlannerItem);
begin
  inherited;

  if APlannerItem.NonDBItem then
    Exit;

  Items.DBItem := APlannerItem.ParentItem;
  if Assigned(FItemSource) then
  begin
    FItemSource.GotoDBItem;
    FItemSource.ReadDBItem;
  end;
  Items.Select(Items.DBItem);
end;

procedure TDBPlanner.UpdateItem(APlannerItem: TPlannerItem);
begin
  inherited;

  if APlannerItem.NonDBItem then
    Exit;

  Items.DBItem := APlannerItem.ParentItem;
  if Assigned(FItemSource) then
  begin
    FItemSource.WriteDBItem;
    RefreshItem(APlannerItem);
  end;  

end;

procedure TDBPlanner.MapItemTimeOnPlanner(APlannerItem: TPlannerItem);
begin
  if Assigned(FItemSource) then
    FItemSource.MapItemTimeOnPlanner(APlannerItem);
end;

procedure TDBPlanner.LoadItems;
begin
  Items.BeginUpdate;
  Items.ClearDB;
  FItemSource.ReadDBItems;
  Items.EndUpdate;
end;

procedure TDBPlanner.ItemSelected(Item: TPlannerItem);
begin
  if Item.NonDBItem then
    Exit;

  Items.DBItem := Item.ParentItem;
  if Assigned(FItemSource) then
    FItemSource.GotoDBItem;

  inherited;
end;

function TDBPlanner.CreateItemAtSelection: TPlannerItem;
begin
  Result := Inherited CreateItemAtSelection;
  Items.DBItem := Result;
  if Assigned(FItemSource) then
    FItemSource.AddDBItem;
end;

procedure TDBPlanner.Refresh;
begin
  inherited;
  if Assigned(ItemSource) then
    ItemSource.Reload;
end;

function TDBPlanner.PosToDay(Pos: Integer): TDateTime;
begin
  if Assigned(ItemSource) then
    Result := ItemSource.PosToDay(Pos)
  else
    Result := inherited PosToDay(Pos);
end;

function TDBPlanner.GetVersionNr: Integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

function TDBPlanner.GetVersionString:string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)))+' '+DATE_VER;
end;



{ TItemSource }

procedure TItemSource.AddDBItem;
begin

end;

constructor TItemSource.Create(AOwner: TComponent);
begin
  inherited;
  FPlanner := Nil;
  FUpdateCount := 0;
  FActive := True;
end;


procedure TItemSource.DeleteDBItem(APlanner: TPlanner);
begin

end;

destructor TItemSource.Destroy;
begin
  inherited;
end;


procedure TItemSource.Next;
begin
  ClearDBItems;
  ReadDBItems;
end;

procedure TItemSource.Prev;
begin
  ClearDBItems;
  ReadDBItems;
end;

procedure TItemSource.ReadDBItems;
begin
end;

procedure TItemSource.ItemChanged(DBKey: string);
begin
end;

procedure TItemSource.WriteDBItem;
begin
end;

procedure TItemSource.ReadDBItem;
begin
end;

procedure TItemSource.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TItemSource.EndUpdate;
begin
  if FUpdateCount > 0 then Dec(FUpdateCount);
end;

function TItemSource.IsUpdating: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TItemSource.SynchDBItems;
begin
end;

procedure TItemSource.ClearDBItems;
begin
  // 1.5.0.3 optimization
  if IsUpdating then
    Exit;
    
  if Assigned(FPlanner) then
  begin
    FPlanner.Items.BeginUpdate;
    FPlanner.Items.ClearDB;
    FPlanner.Items.EndUpdate;
    FPlanner.Items.Selected := nil;
  end;
end;

procedure TItemSource.Refresh;
begin
  if Assigned(FPlanner) then
    FPlanner.Invalidate;
end;

procedure TItemSource.GotoDBItem;
begin

end;


function TItemSource.CreateKey: string;
var
  GUID: TGUID;
  Key: string;
begin
  Key := '';

  if Assigned(FOnCreateKey) then
    FOnCreateKey(Self,FPlanner.Items.DBItem, Key)
  else
  begin
    CoCreateGUID(GUID);
    Key := GUIDToString(GUID);
  end;

  Result := Key;
end;

procedure TItemSource.SetPlanner(Value :TPlanner);
begin
  FPlanner := Value;
  PlannerChanged;
end;

procedure TItemSource.PlannerChanged;
begin

end;

procedure TItemSource.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    if not FActive then
    begin
      ClearDBItems;
      Inc(FUpdateCount)
    end
    else
    begin
      if FUpdateCount > 0 then
      begin
        Dec(FUpdateCount);
        if FUpdateCount = 0 then Reload;
      end;  
    end;
  end;
end;

procedure TItemSource.Reload;
begin
  ClearDBItems;
  ReadDBItems;
end;

function TItemSource.LocateFirstItem(Specifier: string; Params: TFindTextParams;
  var StartTime, EndTime: TDateTime;var Key:string): Boolean;
begin
  Result := False;
end;

function TItemSource.LocateNextItem(var StartTime,
  EndTime: TDateTime;var Key:string): Boolean;
begin
  Result := False;
end;

function TItemSource.PosToDay(Pos: Integer): TDateTime;
begin
  Result := 0;
end;

function TItemSource.PosToRes(Pos: Integer): Integer;
begin
  Result := 0;
end;

procedure TItemSource.MapItemTimeOnPlanner(APlannerItem: TPlannerItem);
begin

end;

{ TDBPlannerDataLink }

procedure TDBPlannerDataLink.ActiveChanged;
begin
  inherited;
  {$IFDEF TMSCODESITE}
  SendMsg('ActiveChanged');
  {$ENDIF}
  FDBItemSource.ClearDBItems;
  FDBItemSource.ReadDBItems;
  FDBItemSource.Refresh;
end;


constructor TDBPlannerDataLink.Create(ADBItemSource: TDBItemSource);
begin
  inherited Create;
  FDBItemSource := ADBItemSource;
end;

procedure TDBPlannerDataLink.DataSetChanged;
begin
  inherited;
  {$IFDEF TMSCODESITE}
  SendMsg('DatasetChanged');
  {$ENDIF}
end;

procedure TDBPlannerDataLink.DataSetScrolled(Distance: Integer);
begin
  inherited;
  {$IFDEF TMSCODESITE}
  SendMsg('DatasetScrolled');
  {$ENDIF}
end;

destructor TDBPlannerDataLink.Destroy;
begin
  inherited;
end;

procedure TDBPlannerDataLink.RecordChanged(Field: TField);
begin
  inherited;

  if FDBItemSource.IsUpdating then Exit;

  {what is the connected planner ??}

  if Assigned(DataSet) then
    if DataSet.Active then
    begin
      {$IFDEF TMSCODESITE}
      if Assigned(Field) then
       SendMsg('RecordChanged : '+Field.FieldName +' of '+DataSet.FieldByName(FDBItemSource.KeyField).AsString)
      else
       SendMsg('RecordChanged : '+DataSet.FieldByName(FDBItemSource.KeyField).AsString);
      {$ENDIF}
      if DataSet.State = dsBrowse then
      FDBItemSource.ItemChanged(DataSet.FieldByName(FDBItemSource.KeyField).AsString);
    end;
end;


{ TDBItemSource }

constructor TDBItemSource.Create(AOwner: TComponent);
begin
  inherited;
  FDataLink := TDBPlannerDataLink.Create(Self);
end;

destructor TDBItemSource.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

function TDBItemSource.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBItemSource.SetDataSource(const Value: TDataSource);
begin
  if FDataLink.DataSource <> Value then
  begin
    FDataLink.DataSource := Value;
  end;
end;

procedure TDBItemSource.SetStartTimeField(const Value: string);
begin
  FStartTimeField := Value;
end;

procedure TDBItemSource.SetKeyField(const Value: string);
begin
  FKeyField := Value;
end;

procedure TDBItemSource.SetResourceField(const Value: string);
begin
  FResourceField := Value;
end;

procedure TDBItemSource.SetEndTimeField(const Value: string);
begin
  FEndTimeField := Value;
end;

procedure TDBItemSource.SetNotesField(const Value: string);
begin
  FNotesField := Value;
end;

procedure TDBItemSource.SetSubjectField(const Value: string);
begin
  FSubjectField := Value;
end;


procedure TDBItemSource.Next;
begin
  inherited;
  if Assigned(FOnChangeQuery) then
    FOnChangeQuery(Self);
end;

procedure TDBItemSource.Prev;
begin
  inherited;
  if Assigned(FOnChangeQuery) then
    FOnChangeQuery(Self);
end;

procedure TDBItemSource.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;
  if (AOperation = opRemove) and (AComponent = FDataLink.DataSource) then
     FDataLink.DataSource := nil;
end;

procedure TDBItemSource.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

function MatchItem(Specifier,Subject,Notes: string; Param: TFindTextParams): Boolean;
var
  SrchText: string;

begin
  Result := False;

  if fnCaptionText in Param then
  begin
    SrchText := Subject;

    if fnIgnoreHTMLTags in Param then
      SrchText := HTMLStrip(SrchText);

    if not (fnMatchCase in Param) then
    begin
      SrchText := AnsiUpperCase(SrchText);
      Specifier := AnsiUpperCase(Specifier);
    end;

    if fnMatchFull in Param then
      Result := (Specifier = SrchText)
    else
      if fnMatchStart in Param then
        Result := Pos(Specifier,SrchText) = 1
      else
        if fnMatchRegular in Param then
          Result := MatchStr(Specifier,SrchText,fnMatchCase in Param);
  end;

  if Result then Exit;

  if fnText in Param then
  begin
    SrchText := Notes;

    if fnIgnoreHTMLTags in Param then
      SrchText := HTMLStrip(SrchText);

    if not (fnMatchCase in Param) then
    begin
      SrchText := AnsiUpperCase(SrchText);
      Specifier := AnsiUpperCase(Specifier);
    end;

    if fnMatchFull in Param then
      Result := (Specifier = SrchText)
    else
      if fnMatchStart in Param then
        Result := Pos(Specifier,SrchText) = 1
      else
        if fnMatchRegular in Param then
          Result := MatchStr(Specifier,SrchText,fnMatchCase in Param);
  end;
end;


function TDBItemSource.LocateFirstItem(Specifier: string;
  Params: TFindTextParams; var StartTime, EndTime: TDateTime;var Key:string): Boolean;
var
  D: TDataSet;
  B: TBookMark;
  Subject,Notes: string;

begin
  Result := False;

  if IsUpdating then Exit;
  if not CheckDataSet then Exit;

  FLocateIdx := 0;
  FLocateSpecifier := Specifier;
  FLocateParams := Params;

  BeginUpdate;

  D := DataSource.DataSet;

  D.DisableControls;

  B := D.GetBookMark;

  D.First;

  while not D.Eof do
  begin
    Inc(FLocateIdx);

    Subject := '';
    Notes := '';

    if SubjectField <> '' then
      Subject := D.FieldByName(SubjectField).AsString;
    if NotesField <> '' then
      Notes := D.FieldByName(NotesField).AsString;

    if MatchItem(FLocateSpecifier,Subject,Notes,FLocateParams) then
    begin
      StartTime := D.FieldByName(StartTimeField).AsDateTime;
      EndTime := D.FieldByName(EndTimeField).AsDateTime;
      Key := D.FieldByName(KeyField).AsString;
      Result := True;
      Break;
    end;
    D.Next;

  end;

  D.GotoBookMark(B);

  D.EnableControls;

  D.FreeBookMark(B);

  EndUpdate;
end;

function TDBItemSource.LocateNextItem(var StartTime,
  EndTime: TDateTime;var Key:string): Boolean;
var
  D: TDataSet;
  B: TBookMark;
  Subject,Notes: string;

begin
  Result := False;

  if IsUpdating then Exit;
  if not CheckDataSet then Exit;

  BeginUpdate;

  D := DataSource.DataSet;

  D.DisableControls;

  B := D.GetBookMark;

  D.First;
  D.MoveBy(FLocateIdx);


  while not D.Eof do
  begin
    Inc(FLocateIdx);
    Subject := '';
    Notes := '';

    if SubjectField <> '' then
      Subject := D.FieldByName(SubjectField).AsString;
    if NotesField <> '' then
      Notes := D.FieldByName(NotesField).AsString;

    if MatchItem(FLocateSpecifier,Subject,Notes,FLocateParams) then
    begin
      StartTime := D.FieldByName(StartTimeField).AsDateTime;
      EndTime := D.FieldByName(EndTimeField).AsDateTime;
      Key := D.FieldByName(KeyField).AsString;
      Result := True;
      Break;
    end;

    D.Next;


  end;

  D.GotoBookMark(B);

  D.EnableControls;

  D.FreeBookMark(B);

  EndUpdate;
end;

function TDBItemSource.CheckDataSet: Boolean;
begin
  Result := False;

  if KeyField = '' then Exit;
  if not Assigned(FPlanner) then Exit;

  if Assigned(DataSource) then
  begin
    if Assigned(DataSource.DataSet) then
    begin
      if DataSource.DataSet.Active then
      begin
        Result := (StartTimeField <> '') AND (EndTimeField <> '') AND (KeyField <> '');
      end;
    end
  end;
end;



{ TDBDaySource }

procedure TDBDaySource.ReadDBItems;
var
  D: TDataSet;
  B: TBookMark;
  dts,dte: TDateTime;
  plIt: TPlannerItem;
  Span, j: Integer;
  Accept: Boolean;
  ResourcePos,DatePos: Integer;
  Zone: TDateTime;

begin
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg(FPlanner.Name+' READ DB ITEMS : '+FPlanner.Name);
  {$ENDIF}

  BeginUpdate;

  if Assigned(FOnSetFilter) then
    FOnSetFilter(Self);


  D := DataSource.DataSet;

  D.DisableControls;

  B := D.GetBookMark;

  D.First;

  ConfigurePlanner(Span);

  j := FPlanner.Display.DisplayUnit * FPlanner.Display.DisplayStart;
  j := j mod 1440;

  Zone := EncodeTime(j div 60,j mod 60,0,0);


  FPlanner.Items.BeginUpdate;

  while not D.Eof do
  begin
    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    {$IFDEF TMSCODESITE}
    SendMsg(FPlanner.Name+' READ ITEM '+D.FieldByName(KeyField).AsString);
    SendMsg(FormatDateTime('dd/mm/yyyy hh:nn',FDay)+'->'+FormatDateTime('dd/mm/yyyy hh:nn',FDay+Span));
    {$ENDIF}

    Accept := True;

    // resource based item acception
    if (ResourceField <> '') and
       (Mode in [dmMultiResource,dmMultiDayRes,dmMultiResDay]) and
       (dte >= FDay + Zone) and (dts < FDay + Span + Zone) then
    begin
      if Assigned(FOnResourceToPosition) then
        FOnResourceToPosition(Self,D.FieldByName(ResourceField),ResourcePos, Accept)
      else
        ResourcePos := D.FieldByName(ResourceField).AsInteger;
    end;

    // date based item acception
    if (dte >= FDay + Zone) and (dts < FDay + Span + Zone) and Accept and Assigned(FOnAccept) then
    begin
      FOnAccept(Self,D.Fields,Accept);
    end;

    if (dte >= FDay + Zone) and (dts < FDay + Span + Zone) and Accept then
    begin
      plIt := FPlanner.Items.FindKey(D.FieldByName(KeyField).AsString);

      if not Assigned(plIt) then
      begin
        {$IFDEF TMSCODESITE}
        SendMsg(FPlanner.Name+' ADD ITEM '+D.FieldByName(KeyField).AsString + ' ' +D.FieldByName(StartTimeField).AsString + ' ' +D.FieldByName(EndTimeField).AsString);
        {$ENDIF}
        plIt := FPlanner.Items.Add;
      end;

      with plIt do
      begin
        FPlanner.RemoveClones(plIt);

        // set time here correct

        ItemRealStartTime := dts;
        ItemRealEndTime := dte;

        ItemStartTime := dts;
        ItemEndTime := dte;

        InHeader := dte - dts > 1;
        RealTime := true;

        // map to start of day
        if (Int(dts) < Int(FDay)) and not InHeader then
          ChangeCrossing;

        if dts > FDay then
          DatePos := Round(Int(dts - FDay))
        else
          DatePos := 0;

        ItemPos := CalcItemPos(DatePos,ResourcePos);

        if KeyField <> '' then
          DBKey := D.FieldByName(KeyField).AsString;
        if SubjectField <> '' then
          CaptionText := D.FieldByName(SubjectField).AsString;
        if NotesField <> '' then
          Text.Text := D.FieldByName(NotesField).AsString;

        if FReadOnly then
        begin
          FixedPos := True;
          FixedSize := True;
          ReadOnly := True;
        end;
      end;

      if Assigned(FOnFieldsToItem) then
        FOnFieldsToItem(Self, D.Fields, plIt);

      if plIt.InHeader then
      begin
        if dts < Day then
          dts := Day;

        for j := 1  to Round(Int(dte) - Int(dts)) do
        begin
          if j + plIt.ItemPos < FPlanner.Positions then
            with FPlanner.CloneItem(plIt) do
            begin
              DatePos := DatePos + 1;
              ItemPos := CalcItemPos(DatePos,ResourcePos);
            end;
        end;
      end;
    end;

    D.Next;
  end;

  D.GotoBookMark(B);

  D.EnableControls;

  D.FreeBookMark(B);

  if Assigned(FOnResetFilter) then
    FOnResetFilter(Self);

  EndUpdate;

  FPlanner.Items.EndUpdate;

  if Assigned(OnItemsRead) then
    OnItemsRead(Self);

  if FPlanner.Header.AutoSize then
   FPlanner.AutoSizeHeader;

  {$IFDEF TMSCODESITE}
  SendMsg('DONE READ DB ITEMS');
  {$ENDIF}
end;

procedure TDBDaySource.SetDay(const Value: TDateTime);
begin
  if FDay <> Value then
  begin
    FDay := Int(Value);
    ClearDBItems;
    ReadDBItems;
  end;
end;

procedure TDBDaySource.Next;
begin
  FDay := FDay + FDayIncrement;
  inherited;
end;

procedure TDBDaySource.Prev;
begin
  FDay := FDay - FDayIncrement;
  inherited;
end;

procedure TDBDaySource.WriteDBItem;
var
  D: TDataSet;
  B: TBookMark;
  DTE, DTS: TDateTime;
  ResPos: Integer;

begin
  if IsUpdating then Exit;

  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('write selected here?');
  {$ENDIF}

  if Assigned(FOnUpdateItem) then
  begin
    BeginUpdate;
    FOnUpdateItem(Self,FPlanner.Items.DBItem);
    EndUpdate;
    if not FUpdateByQuery then
      Exit;
  end;

  BeginUpdate;

  D := DataSource.DataSet;

  B := D.GetBookMark;

  D.Locate(KeyField,FPlanner.Items.DBItem.DBKey,[]);
  D.Edit;

  if FPlanner.Items.DBItem.RealTime then
  begin
    DTS := FPlanner.Items.DBItem.ItemRealStartTime;
    DTE := FPlanner.Items.DBItem.ItemRealEndTime;
  end
  else
  begin
    DTS := FPlanner.Items.DBItem.ItemStartTime;
    DTE := FPlanner.Items.DBItem.ItemEndTime;
  end;

  {$IFDEF TMSCODESITE}
  SendMsg('writedb:'+formatdatetime('dd/mm/yyyy hh:nn',dts)+'-'+formatdatetime('dd/mm/yyyy hh:nn',dte));
  {$ENDIF}

  FPlanner.Items.DBItem.RealTime := False;

  //  if DTE < DTS then
  //    DTE := DTE + 1;

  D.FieldByName(StartTimeField).AsDateTime := DTS;
  D.FieldByName(EndTimeField).AsDateTime := DTE;

  if (ResourceField <> '') and (Mode in [dmMultiResource,dmMultiDayRes,dmMultiResDay]) then
  begin
    ResPos := PosToRes(FPlanner.Items.DBItem.ItemPos);

    if Assigned(FOnPositionToResource) then
      FOnPositionToResource(Self,D.FieldByName(ResourceField),ResPos)
    else
      D.FieldByName(ResourceField).AsInteger := ResPos;
  end;

  if SubjectField <> '' then
    D.FieldByName(SubjectField).AsString := FPlanner.Items.DBItem.CaptionText;

  if NotesField <> '' then
    D.FieldByName(NotesField).AsString := FPlanner.Items.DBItem.ItemText;

  if Assigned(FOnItemToFields) then
    FOnItemToFields(Self, D.Fields, FPlanner.Items.DBItem);

  try
    D.Post;
  finally
    D.GotoBookMark(B);
    D.FreeBookMark(B);
    EndUpdate;
  end;

end;


procedure TDBDaySource.SetMode(const Value: TDBDayMode);
begin
  if FMode <> Value then
  begin
    FMode := Value;
    case FMode of
    dmMultiDay:
      if Assigned(FPlanner) then
      begin
        FPlanner.PositionGroup := 0;
        FPlanner.Positions := NumberOfDays;
      end;
    dmMultiResource:
      if Assigned(FPlanner) then
      begin
        FPlanner.PositionGroup := 0;
        FPlanner.Positions := NumberOfResources;
      end;
    end;
    ClearDBItems;
    ReadDBItems;
  end;
end;

procedure TDBDaySource.AddDBItem;
var
  D: TDataSet;
  B: TBookMark;
  DTS, DTE: TDateTime;
  ResPos: Integer;

begin
  inherited;

  if not CheckDataSet then Exit;


  {$IFDEF TMSCODESITE}
  SendMsg('add selected here?');
  {$ENDIF}

  if Assigned(FOnInsertItem) then
  begin
    BeginUpdate;
    FOnInsertItem(Self,FPlanner.Items.DBItem);
    EndUpdate;
    Exit;
  end;

  BeginUpdate;

  D := DataSource.DataSet;

  B := D.GetBookMark;

  D.Append;

  if not AutoIncKey then
  begin
    D.FieldByName(KeyField).AsString := CreateKey;
    FPlanner.Items.DBItem.DBKey := D.FieldByName(KeyField).AsString;
  end;

  DTS := FPlanner.Items.DBItem.ItemStartTime;
  DTE := FPlanner.Items.DBItem.ItemEndTime;

  FPlanner.Items.DBItem.ItemRealStartTime := DTS;
  FPlanner.Items.DBItem.ItemRealEndTime := DTE;

  D.FieldByName(StartTimeField).AsDateTime := DTS;
  D.FieldByName(EndTimeField).AsDateTime := DTE;

  if (ResourceField <> '') and (Mode in [dmMultiResource,dmMultiDayRes,dmMultiResDay]) then
  begin
    ResPos := PosToRes(FPlanner.Items.DBItem.ItemPos);

    if Assigned(FOnPositionToResource) then
      FOnPositionToResource(Self, D.FieldByName(ResourceField), ResPos)
    else
      D.FieldByName(ResourceField).AsInteger := ResPos;
  end;

  if SubjectField <> '' then
    D.FieldByName(SubjectField).AsString := FPlanner.Items.DBItem.CaptionText;

  if NotesField <> '' then
    D.FieldByName(NotesField).AsString := FPlanner.Items.DBItem.ItemText;

  if Assigned(FOnItemToFields) then
    FOnItemToFields(Self, D.Fields, FPlanner.Items.DBItem);

  try
    D.Post;
    if AutoIncKey then
      FPlanner.Items.DBItem.DBKey := D.FieldByName(KeyField).AsString;
  finally
    D.GotoBookMark(B);
    D.FreeBookMark(B);
    EndUpdate;
  end;
end;

procedure TDBDaySource.DeleteDBItem(APlanner: TPlanner);
var
  D: TDataSet;
begin
  inherited;
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('delete selected here?');
  {$ENDIF}

  if Assigned(FOnDeleteItem) then
  begin
    BeginUpdate;
    FOnDeleteItem(Self,APlanner.Items.DBItem);
    EndUpdate;
    Exit;
  end;

  BeginUpdate;
  D := DataSource.DataSet;
  D.Locate(KeyField,APlanner.Items.DBItem.DBKey,[]);
  D.Delete;
  EndUpdate;
end;


procedure TDBDaySource.ItemChanged(DBKey: string);
var
  plIt: TPlannerItem;
  dt: TDateTime;
  Span: Integer;
  D: TDataSet;

begin
  inherited;
  if IsUpdating then Exit;
  if (DBKEY='') then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;

  {$IFDEF TMSCODESITE}
  SendMsg(FPlanner.Name+' Itemchanged: '+DBKEY);
  {$ENDIF}

  plIt := FPlanner.Items.FindKey(DBKey);

  if Assigned(plIt) then
  begin
    {$IFDEF TMSCODESITE}
    SendMsg('Found it : '+ plIt.Name);
    {$ENDIF}

    FPlanner.Items.DBItem := plIt;
    ReadDBItem;

    FPlanner.Items.Select(plIt);
  end
  else
  begin
    {$IFDEF TMSCODESITE}
    SendMsg('Add it to '+inttostr(FPlanner.Items.Count)+' items');
    {$ENDIF}

    if not CheckDataSet then Exit;

    D := DataSource.DataSet;
    dt := D.FieldByName(StartTimeField).AsDateTime;

    if Mode = dmMultiResource then
      Span := 1
    else
      Span := FPlanner.Positions;


    if (dt > FDay) and (dt < FDay + Span) then
    begin
      plIt := FPlanner.Items.Add;
      plIt.DBKey := DBKey;
      FPlanner.Items.DBItem := plIt;
      ReadDBItem;
    end;

  end;

  EndUpdate;
end;

procedure TDBDaySource.ReadDBItem;
var
  D: TDataSet;
  dts,dte: TDateTime;
  ResourcePos,DatePos,j: Integer;
  Accept: Boolean;
  Zone: TDateTime;
  Span: Integer;

begin
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('read selected');
  {$ENDIF}

  D := DataSource.DataSet;

  FPlanner.RemoveClones(FPlanner.Items.DBItem);

  j := FPlanner.Display.DisplayUnit * FPlanner.Display.DisplayStart;
  j := j mod 1440;

  Zone := EncodeTime(j div 60,j mod 60,0,0);

  case Mode of
  dmMultiDay,dmMultiDayRes,dmMultiResDay: Span := NumberOfDays;
  dmMultiResource: Span := 1;
  end;

  ConfigurePlanner(Span);

  with FPlanner.Items.DBItem do
  begin
    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    {$IFDEF TMSCODESITE}
    SendMsg('read:'+formatdatetime('dd/mm/yyyy hh:nn',dts)+'-'+formatdatetime('dd/mm/yyyy hh:nn',dte));
    {$ENDIF}
    
    ItemStartTime := dts;
    ItemEndTime := dte;
    ItemRealStartTime := dts;
    ItemRealEndTime := dte;

    InHeader := dte - dts > 1;

    // resource based item acception
    if (ResourceField <> '') and
       (Mode in [dmMultiResource,dmMultiDayRes,dmMultiResDay]) and
       (dte >= FDay + Zone) and (dts < FDay + Span + Zone) then
    begin
      if Assigned(FOnResourceToPosition) then
        FOnResourceToPosition(Self,D.FieldByName(ResourceField),ResourcePos,Accept)
      else
        ResourcePos := D.FieldByName(ResourceField).AsInteger;
    end;

    // date based item acception
    if (dte >= FDay + Zone) and (dts < FDay + Span + Zone) then
    begin
      FPlanner.RemoveClones(FPlanner.Items.DBItem);

      DatePos := Round(Int(D.FieldByName(StartTimeField).AsDateTime - FDay));

      ItemPos := CalcItemPos(DatePos,ResourcePos);

      if SubjectField <> '' then
        CaptionText := D.FieldByName(SubjectField).AsString;

      if NotesField <> '' then
        Text.Text := D.FieldByName(NotesField).AsString;

      if FReadOnly then
      begin
        FixedPos := True;
        FixedSize := True;
        ReadOnly := True;
      end;
      
      if InHeader then
      begin
        if dts < Day then
          dts := Day;

        for j := 1  to Round(Int(dte) - Int(dts)) do
        begin
          if j + ItemPos < FPlanner.Positions then
            with FPlanner.CloneItem(FPlanner.Items.DBItem) do
            begin
              DatePos := DatePos + 1;
              ItemPos := CalcItemPos(DatePos,ResourcePos);
            end;
        end;
      end;


      if Assigned(FOnFieldsToItem) then
        FOnFieldsToItem(Self, D.Fields, FPlanner.Items.DBItem);
    end
    else
    begin
      FPlanner.Items.DBItem.Free;
    end;
  end;

  if FPlanner.Header.AutoSize then
   FPlanner.AutoSizeHeader;
end;

procedure TDBDaySource.SynchDBItems;
var
  D: TDataSet;
  B: TBookMark;
  dt: TDateTime;
  plIt: TPlannerItem;
  Span,i: Integer;

begin
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;

  if Assigned(FOnSetFilter) then
    FOnSetFilter(Self);

  D := DataSource.DataSet;
  B := D.GetBookMark;
  D.First;

  if Mode = dmMultiResource then
    Span := 1
  else
  begin
    Span := FPlanner.Positions;
  end;

  for i := 1 to FPlanner.Items.Count do
    FPlanner.Items[i - 1].Synched := False;

  while not D.Eof do
  begin
    dt := D.FieldByName(StartTimeField).AsDateTime;

    if (dt > FDay) and (dt < FDay + Span) then
    begin
      plIt := FPlanner.Items.FindKey(D.FieldByName(KeyField).AsString);
      if Assigned(plIt) then
        plIt.Synched := True;
    end;
    
    D.Next;
  end;

  for i := FPlanner.Items.Count downto 1 do
  begin
    if not FPlanner.Items[i - 1].Synched then
      FPlanner.Items[i - 1].Free;
  end;

  D.GotoBookMark(B);
  D.FreeBookMark(B);

  if Assigned(FOnResetFilter) then
    FOnResetFilter(Self);

  EndUpdate;
end;

procedure TDBDaySource.GotoDBItem;
var
  D: TDataSet;
begin
  inherited;
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;
  D := DataSource.DataSet;
  D.Locate(KeyField,FPlanner.Items.DBItem.DBKey,[]);
  EndUpdate;
end;

constructor TDBDaySource.Create(AOwner: TComponent);
begin
  inherited;
  FDayIncrement := 1;
  FDateFormat := 'mm/dd/yyyy';
  FNumberOfDays := 7;
  FNumberOfResources := 1;
end;

procedure TDBDaySource.PlannerChanged;
begin
  inherited;
  if Assigned(FPlanner) then
    FPlanner.Mode.PlannerType := plDay;
end;

function TDBDaySource.PosToDay(Pos: Integer): TDateTime;
begin
  case Mode of
  dmMultiDay:
    Result := FDay + Pos;
  dmMultiResource:
    Result := Day;
  dmMultiDayRes:
    Result := FDay + (Pos mod NumberOfDays);
  dmMultiResDay:
    Result := FDay + (Pos div NumberOfResources);
  else
    Result := FDay;
  end;
end;

function TDBDaySource.PosToRes(Pos: Integer): Integer;
begin
  case Mode of
  dmMultiDay:
    Result := 0;
  dmMultiResource:
    Result := Pos;
  dmMultiDayRes:
    Result := Pos div NumberOfDays;
  dmMultiResDay:
    Result := Pos mod NumberOfResources;
  else
    Result := 0;
  end;
end;


procedure TDBDaySource.SetNumberOfDays(const Value: Integer);
begin
  if Value <= 0 then
    Exit;

  if FNumberOfDays <> Value then
  begin
    FNumberOfDays := Value;
    ClearDBItems;
    ReadDBItems;
  end;
end;

procedure TDBDaySource.SetNumberOfResources(const Value: Integer);
begin
  if Value <= 0 then
    Exit;
  if FNumberOfResources <> Value then
  begin
    FNumberOfResources := Value;
    ClearDBItems;
    ReadDBItems;
  end;
end;

procedure TDBDaySource.ConfigurePlanner(var Span: Integer);
var
  i,j,k,dx: Integer;
  ResName: string;
begin
  if not Assigned(FPlanner) then
    Exit;

  case Mode of
  dmMultiResource:
    begin
      FPlanner.Positions := NumberOfResources;
      Span := 1;
      if FAutoHeaderUpdate then
      begin
        if FPlanner.Header.Captions.Count = 0 then
          FPlanner.Header.Captions.Add('');

        for i := 1 to NumberOfResources do
        begin
          ResName := '';
          if Assigned(FOnGetResourceName) then
            FOnGetResourceName(Self,i,ResName);
          if ResName <> '' then
          begin
            if FPlanner.Header.Captions.Count <= i then
              FPlanner.Header.Captions.Add(ResName)
            else
              FPlanner.Header.Captions.Strings[i] := ResName;
          end;
        end;
      end;
      FPlanner.Display.CurrentPosFrom := -1;
      FPlanner.Display.CurrentPosTo := -1;
    end;
  dmMultiDay:
    begin
      FPlanner.Positions := NumberOfDays;
      Span := NumberOfDays;
      if FAutoHeaderUpdate then
      begin
        if FPlanner.Header.Captions.Count = 0 then
          FPlanner.Header.Captions.Add('');

        for i := 1 to NumberOfDays do
        begin
          if FPlanner.Header.Captions.Count <= i then
            FPlanner.Header.Captions.Add(FormatDateTime(FDateFormat,Day + i - 1))
          else
            FPlanner.Header.Captions.Strings[i] := FormatDateTime(FDateFormat,Day + i - 1);
        end;
      end;
      dx := Round(Int(Now) - Int(Day));
      FPlanner.Display.CurrentPosFrom := dx;
      FPlanner.Display.CurrentPosTo := dx;
    end;
  dmMultiDayRes:
    begin
      FPlanner.Positions := NumberOfResources * NumberOfDays;
      FPlanner.PositionGroup := NumberOfDays;
      Span := NumberOfDays;

      if FAutoHeaderUpdate then
        for i := 1 to NumberOfResources do
        begin
          for j := 1 to NumberOfDays do
          begin
             k := j + (i - 1) * NumberOfDays;
             if FPlanner.Header.Captions.Count < k then
               FPlanner.Header.Captions.Add(FormatDateTime(FDateFormat,Day + j - 1))
             else
               FPlanner.Header.Captions.Strings[k] := FormatDateTime(FDateFormat,Day + j - 1);
          end;

          ResName := '';
          if Assigned(FOnGetResourceName) then
            FOnGetResourceName(Self,i,ResName);

          if FPlanner.Header.GroupCaptions.Count < i then
            FPlanner.Header.GroupCaptions.Add(ResName)
          else
            FPlanner.Header.GroupCaptions[i - 1] := ResName;
        end;
      FPlanner.Display.CurrentPosFrom := -1;
      FPlanner.Display.CurrentPosTo := -1;
    end;
  dmMultiResDay:
    begin
      FPlanner.PositionGroup := NumberOfResources;
      FPlanner.Positions := NumberOfResources * NumberOfDays;
      Span := NumberOfDays;

      if FAutoHeaderUpdate then
      begin
        for i := 1 to NumberOfDays do
        begin
          if FPlanner.Header.GroupCaptions.Count < i then
            FPlanner.Header.GroupCaptions.Add(FormatDateTime(FDateFormat,Day + i - 1))
          else
            FPlanner.Header.GroupCaptions[i - 1] := FormatDateTime(FDateFormat,Day + i - 1);
        end;

        for i := 1 to NumberOfDays do
          for j := 1 to NumberOfResources do
          begin
            ResName := '';
            if Assigned(FOnGetResourceName) then
              FOnGetResourceName(Self,j,ResName);
            k := j + (i - 1) * NumberOfResources;
            if FPlanner.Header.Captions.Count < k then
              FPlanner.Header.Captions.Add(ResName)
            else
              FPlanner.Header.Captions.Strings[k] := ResName;
          end;
      end;
      dx := Round(Int(Now) - Int(Day));
      FPlanner.Display.CurrentPosFrom := dx * NumberOfResources;
      FPlanner.Display.CurrentPosTo := (dx + 1) * NumberOfResources - 1;
    end;
  end;

end;

function TDBDaySource.CalcItemPos(DatePos, ResourcePos: Integer): Integer;
begin
  case Mode of
  dmMultiDay:
    Result := DatePos;
  dmMultiResource:
    Result := ResourcePos;
  dmMultiResDay:
    Result := ResourcePos + NumberOfResources * DatePos;
  dmMultiDayRes:
    Result := ResourcePos * NumberOfDays + DatePos;
  else
    Result := DatePos;
  end;
end;


procedure TDBDaySource.MapItemTimeOnPlanner(APlannerItem: TPlannerItem);
var
  dts,dte: TDateTime;
  j, DatePos: Integer;
begin
  with APlannerItem do
  begin
    RealTime := True;
    dts := ItemRealStartTime;
    dte := ItemRealEndTime;

    // map to start of day
    if Int(dts) < Int(FDay) then
      ChangeCrossing;

    InHeader := dte - dts > 1;

    DatePos := Round(Int(dts - FDay));

    ItemPos := CalcItemPos(DatePos,ItemPos);

    if APlannerItem.InHeader then
    begin
      for j := 1  to round(Int(dte) - Int(dts)) do
        begin
          if j + APlannerItem.ItemPos < FPlanner.Positions then
            with FPlanner.CloneItem(APlannerItem) do
              ItemPos := ItemPos + j;
        end;
    end;
  end;
end;

{ TDBCustomPeriodSource }

procedure TDBCustomPeriodSource.AddDBItem;
var
  D: TDataSet;
  B: TBookMark;

begin
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('add selected here?');
  {$ENDIF}

  if Assigned(FOnInsertItem) then
  begin
    BeginUpdate;
    FOnInsertItem(Self,FPlanner.Items.DBItem);
    EndUpdate;
    Exit;
  end;

  BeginUpdate;

  D := DataSource.DataSet;

  B := D.GetBookMark;

  D.Append;

  if not AutoIncKey then
  begin
    D.FieldByName(KeyField).AsString := CreateKey;
    FPlanner.Items.DBItem.DBKey := D.FieldByName(KeyField).AsString;
  end;

  D.FieldByName(StartTimeField).AsDateTime := FPlanner.Items.DBItem.ItemRealStartTime;
  D.FieldByName(EndTimeField).AsDateTime := FPlanner.Items.DBItem.ItemRealEndTime;

  if (ResourceField <> '') then
  begin
    if Assigned(FOnPositionToResource) then
      FOnPositionToResource(Self, D.FieldByName(ResourceField), FPlanner.Items.DBItem.ItemPos)
    else
      D.FieldByName(ResourceField).AsInteger := FPlanner.Items.DBItem.ItemPos;
  end;

  if SubjectField <> '' then
    D.FieldByName(SubjectField).AsString := FPlanner.Items.DBItem.CaptionText;

  if NotesField <> '' then
    D.FieldByName(NotesField).AsString := FPlanner.Items.DBItem.ItemText;

  if Assigned(FOnItemToFields) then
    FOnItemToFields(Self, D.Fields, FPlanner.Items.DBItem);

  try
    D.Post;
    if AutoIncKey then
      FPlanner.Items.DBItem.DBKey := D.FieldByName(KeyField).AsString;
  finally
    D.GotoBookMark(B);
    D.FreeBookMark(B);
    EndUpdate;
  end;

end;


procedure TDBCustomPeriodSource.ConfigurePlanner;
var
  i: Integer;
  ResName: string;
begin
  FPlanner.Positions := NumberOfResources;

  if FAutoHeaderUpdate then
    for i := 1 to NumberOfResources do
    begin
      ResName := '';
      if Assigned(FOnGetResourceName) then
        FOnGetResourceName(Self,i,ResName);
      if ResName <> '' then
        FPlanner.Header.Captions.Strings[i] := ResName;
    end;
end;

constructor TDBCustomPeriodSource.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TDBCustomPeriodSource.DeleteDBItem(APlanner: TPlanner);
var
  D: TDataSet;
begin
  inherited;
  {$IFDEF TMSCODESITE}
  SendMsg('delete selected here?');
  {$ENDIF}

  BeginUpdate;
  D := DataSource.DataSet;
  D.Locate(KeyField,APlanner.Items.DBItem.DBKey,[]);
  D.Delete;
  EndUpdate;
end;

procedure TDBCustomPeriodSource.GotoDBItem;
var
  D: TDataSet;
begin
  inherited;
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;
  D := DataSource.DataSet;
  D.Locate(KeyField,FPlanner.Items.DBItem.DBKey,[]);
  EndUpdate;
end;

procedure TDBCustomPeriodSource.ItemChanged(DBKey: string);
var
  plIt: TPlannerItem;
  dts,dte: TDateTime;
  D: TDataSet;

begin
  inherited;
  if IsUpdating then Exit;
  if (DBKEY='') then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;

  {$IFDEF TMSCODESITE}
  SendMsg(FPlanner.Name+' Itemchanged: '+DBKEY);
  {$ENDIF}

  plIt := FPlanner.Items.FindKey(DBKey);

  if Assigned(plIt) then
  begin
    {$IFDEF TMSCODESITE}
    SendMsg('Found it : '+ plIt.Name);
    {$ENDIF}
    FPlanner.Items.DBItem := plIt;
    ReadDBItem;

    FPlanner.Items.Select(plIt);
  end
  else
  begin
    {$IFDEF TMSCODESITE}
    SendMsg('Add it to '+inttostr(FPlanner.Items.Count)+' items');
    {$ENDIF}

    if not CheckDataSet then Exit;

    D := DataSource.DataSet;

    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    if (dts < FPlanner.Mode.PeriodEndDate) and
       (dte > FPlanner.Mode.PeriodStartDate) then
    begin
      plIt := FPlanner.Items.Add;
      plIt.DBKey := DBKey;
      FPlanner.Items.DBItem := plIt;
      ReadDBItem;
    end;
  end;

  EndUpdate;
end;

procedure TDBCustomPeriodSource.Next;
begin
  inherited;

end;

procedure TDBCustomPeriodSource.Prev;
begin
  inherited;

end;

procedure TDBCustomPeriodSource.ReadDBItem;
var
  D: TDataSet;
  dt: TDateTime;
  ResourcePos: Integer;
  Accept: Boolean;
  B: TBookmark;

begin
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('read selected');
  {$ENDIF}

  D := DataSource.DataSet;

  B := D.GetBookMark;
  D.Locate(KeyField,FPlanner.Items.DBItem.DBKey,[]);

  with FPlanner.Items.DBItem do
  begin
    dt := D.FieldByName(StartTimeField).AsDateTime;
    ItemStartTime := dt;
    dt := D.FieldByName(EndTimeField).AsDateTime;
    ItemEndTime := dt;

    if (ResourceField <> '') then
    begin
      if Assigned(FOnResourceToPosition) then
      begin
        Accept := True;
        FOnResourceToPosition(Self,D.FieldByName(ResourceField),ResourcePos, Accept);
        ItemPos := ResourcePos;
      end
      else
        ItemPos := D.FieldByName(ResourceField).AsInteger;
    end;

    if SubjectField <> '' then
      CaptionText := D.FieldByName(SubjectField).AsString;

    if NotesField <> '' then
      Text.Text := D.FieldByName(NotesField).AsString;

    if FReadOnly then
    begin
      FixedPos := True;
      FixedSize := True;
      ReadOnly := True;
    end;
  end;

  if Assigned(FOnFieldsToItem) then
    FOnFieldsToItem(Self, D.Fields, FPlanner.Items.DBItem);

  D.GotoBookMark(B);
  D.FreeBookMark(B);
end;

procedure TDBCustomPeriodSource.ReadDBItems;
var
  D: TDataSet;
  B: TBookMark;
  dt,dts,dte: TDateTime;
  plIt: TPlannerItem;
  Accept: Boolean;
  ResourcePos: Integer;

begin
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('READ DB ITEMS : '+FPlanner.Name);
  {$ENDIF}

  BeginUpdate;

  if Assigned(FOnSetFilter) then
    FOnSetFilter(Self);

  D := DataSource.DataSet;

  D.DisableControls;

  B := D.GetBookMark;

  D.First;

  ConfigurePlanner;

  FPlanner.Items.BeginUpdate;

  while not D.Eof do
  begin
    Accept := True;

    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    if (ResourceField <> '') and
       (dts < FPlanner.Mode.PeriodEndDate + 1) and
       (dte >= FPlanner.Mode.PeriodStartDate) then
    begin
      if Assigned(FOnResourceToPosition) then
        FOnResourceToPosition(Self,D.FieldByName(ResourceField),ResourcePos, Accept)
    end;

    if (dts < FPlanner.Mode.PeriodEndDate + 1) and
       (dte >= FPlanner.Mode.PeriodStartDate) and
       Accept and Assigned(FOnAccept) then
    begin
      FOnAccept(Self,D.Fields,Accept);
    end;

    if (dts < FPlanner.Mode.PeriodEndDate + 1) and
       (dte >= FPlanner.Mode.PeriodStartDate) and Accept then
    begin
      plIt := FPlanner.Items.FindKey(D.FieldByName(KeyField).AsString);

      if not Assigned(plIt) then
      begin
        {$IFDEF TMSCODESITE}
        SendMsg(FPlanner.Name+' Add:'+D.FieldByName(KeyField).AsString);
        {$ENDIF}
        plIt := FPlanner.Items.Add;
      end;

      with plIt do
      begin
        Assign(FPlanner.DefaultItem);
        dt := D.FieldByName(StartTimeField).AsDateTime;
        ItemStartTime := dt;
        dt := D.FieldByName(EndTimeField).AsDateTime;
        ItemEndTime := dt;

        if (ResourceField <> '') then
        begin
          if Assigned(FOnResourceToPosition) then
            ItemPos := ResourcePos
          else
            ItemPos := D.FieldByName(ResourceField).AsInteger;
        end;
        if KeyField <> '' then
          DBKey := D.FieldByName(KeyField).AsString;
        if SubjectField <> '' then
          CaptionText := D.FieldByName(SubjectField).AsString;
        if NotesField <> '' then
          Text.Text := D.FieldByName(NotesField).AsString;

        if FReadOnly then
        begin
          FixedPos := True;
          FixedSize := True;
          ReadOnly := True;
        end;

      end;

      if Assigned(FOnFieldsToItem) then
        FOnFieldsToItem(Self, D.Fields, plIt);

    end;
    D.Next;
  end;

  D.GotoBookMark(B);
  D.EnableControls;
  D.FreeBookMark(B);

  if Assigned(FOnResetFilter) then
    FOnResetFilter(Self);

  EndUpdate;

  FPlanner.Items.EndUpdate;

  if Assigned(OnItemsRead) then
    OnItemsRead(Self);  
  
  {$IFDEF TMSCODESITE}
  SendMsg('DONE READ DB ITEMS');
  {$ENDIF}
end;


procedure TDBCustomPeriodSource.SetNumberOfResources(const Value: Integer);
begin
  if Value <= 0 then
    Exit;
  if FNumberOfResources <> Value then
  begin
    FNumberOfResources := Value;
    ClearDBItems;
    ReadDBItems;
  end;
end;

procedure TDBCustomPeriodSource.SynchDBItems;
var
  D: TDataSet;
  B: TBookMark;
  dts,dte: TDateTime;
  plIt: TPlannerItem;
  i: Integer;

begin
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;

  if Assigned(FOnSetFilter) then
    FOnSetFilter(Self);

  D := DataSource.DataSet;
  B := D.GetBookMark;
  D.First;


  for i := 1 to FPlanner.Items.Count do
    FPlanner.Items[i - 1].Synched := False;

  while not D.Eof do
  begin
    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    if (dts < FPlanner.Mode.PeriodEndDate) and
       (dte > FPlanner.Mode.PeriodStartDate) then
    begin
      plIt := FPlanner.Items.FindKey(D.FieldByName(KeyField).AsString);
      if Assigned(plIt) then
        plIt.Synched := True;
    end;
    D.Next;
  end;

  for i := FPlanner.Items.Count downto 1 do
  begin
    if not FPlanner.Items[i - 1].Synched then
      FPlanner.Items[i - 1].Free;
  end;

  D.GotoBookMark(B);
  D.FreeBookMark(B);

  if Assigned(FOnResetFilter) then
    FOnResetFilter(Self);

  EndUpdate;
end;

procedure TDBCustomPeriodSource.WriteDBItem;
var
  D: TDataSet;
  B: TBookMark;
begin
  if IsUpdating then Exit;

  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('write selected here?');
  {$ENDIF}

  if Assigned(FOnUpdateItem) then
  begin
    BeginUpdate;
    FOnUpdateItem(Self,FPlanner.Items.DBItem);
    EndUpdate;
    if not FUpdateByQuery then
      Exit;
  end;

  BeginUpdate;

  D := DataSource.DataSet;

  B := D.GetBookMark;

  D.Locate(KeyField,FPlanner.Items.DBItem.DBKey,[]);
  D.Edit;

  if FPlanner.Items.DBItem.RealTime then
  begin
    D.FieldByName(StartTimeField).AsDateTime := FPlanner.Items.DBItem.ItemRealStartTime;
    D.FieldByName(EndTimeField).AsDateTime := FPlanner.Items.DBItem.ItemRealEndTime;
  end
  else
  begin
    D.FieldByName(StartTimeField).AsDateTime := FPlanner.Items.DBItem.ItemStartTime;
    D.FieldByName(EndTimeField).AsDateTime := FPlanner.Items.DBItem.ItemEndTime;
  end;

  if ResourceField <> '' then
  begin
    if Assigned(FOnPositionToResource) then
      FOnPositionToResource(Self,D.FieldByName(ResourceField),FPlanner.Items.DBItem.ItemPos)
    else
      D.FieldByName(ResourceField).AsInteger := FPlanner.Items.DBItem.ItemPos;
  end;

  if SubjectField <> '' then
    D.FieldByName(SubjectField).AsString := FPlanner.Items.DBItem.CaptionText;

  if NotesField <> '' then
    D.FieldByName(NotesField).AsString := FPlanner.Items.DBItem.ItemText;

  if Assigned(FOnItemToFields) then
    FOnItemToFields(Self, D.Fields, FPlanner.Items.DBItem);

  try
    D.Post;
  finally
    D.GotoBookMark(B);
    D.FreeBookMark(B);
    EndUpdate;
  end;
end;

{ TDBPeriodSource }

constructor TDBPeriodSource.Create(AOwner: TComponent);
begin
  inherited;
  // initialize it to a default 14 day period
  FStartDate := Trunc(Now);
  FEndDate := Trunc(Now) + 14;
end;

procedure TDBPeriodSource.Loaded;
begin
  inherited;
  if Assigned(FPlanner) then
    UpdatePlanner;
end;

procedure TDBPeriodSource.PlannerChanged;
begin
  inherited;
  if Assigned(FPlanner) then
    UpdatePlanner;
end;

procedure TDBPeriodSource.SetEndDate(const Value: TDateTime);
begin
  if (FEndDate <> Value) and (Value > FStartDate) then
  begin
    FEndDate := Value;
    if not Assigned(FPlanner) then
      Exit;
    if csLoading in ComponentState then
      Exit;

    FPlanner.Mode.PeriodEndDate := Value;
  end;
end;

procedure TDBPeriodSource.SetStartDate(const Value: TDateTime);
begin
  if (FStartDate <> Value) and (Value < FEndDate) then
  begin
    FStartDate := Value;
    if not Assigned(FPlanner) then
      Exit;
    if csLoading in ComponentState then
      Exit;

    FPlanner.Mode.PeriodStartDate := Value;
  end;
end;

procedure TDBPeriodSource.UpdatePlanner;
begin
  if Assigned(FPlanner) and (FUpdateCount = 0) then
  begin
    FPlanner.Mode.PlannerType := plDayPeriod;
    FPlanner.Mode.BeginUpdate;
    FPlanner.Mode.PeriodEndDate := FEndDate;
    FPlanner.Mode.PeriodStartDate := FStartDate;
    FPlanner.Mode.EndUpdate;
    FPlanner.Items.BeginUpdate;
    ClearDBItems;
    ReadDBItems;
    FPlanner.Items.EndUpdate;
  end;
end;

{ TDBMonthSource }

function DaysInMonth(mo,ye:word):word;
begin
  if (mo < 1) or (mo > 12) then
    mo := 1;

  if (mo <> 2) then
    Result := CDaysInMonth[mo]
  else
  begin
    if ye mod 4 = 0 then
      Result := 29
    else
      Result := 28;

    if ye mod 100 = 0 then

      Result := 28;

    if ye mod 400 = 0 then
      Result := 29;
  end;
end;

constructor TDBMonthSource.Create(AOwner: TComponent);
var
  da,mo,ye: word;
begin
  inherited;
  DecodeDate(Now,ye,mo,da);
  FMonth := mo;
  FYear := ye;
end;

procedure TDBMonthSource.Loaded;
begin
  inherited;
  if Assigned(FPlanner) then
  begin
    FPlanner.Mode.PlannerType := plMonth;
    FPlanner.Mode.Year := FYear;
    FPlanner.Mode.Month := FMonth;
    FPlanner.Display.DisplayStart := 0;
    FPlanner.Display.DisplayEnd := DaysInMonth(FMonth,FYear) - 1;
  end;
end;

procedure TDBMonthSource.PlannerChanged;
begin
  inherited;
  if Assigned(FPlanner) then
  begin
    FPlanner.Mode.PlannerType := plMonth;
    FPlanner.Mode.Year := FYear;
    FPlanner.Mode.Month := FMonth;
  end;
end;


procedure TDBMonthSource.SetMonth(const Value: integer);
begin
  if (Value > 0) and (Value < 13) and (Value <> FMonth) then
  begin
    FMonth := Value;

    if not Assigned(FPlanner) then Exit;
    if csLoading in ComponentState then Exit;
    FPlanner.Mode.Month := Value;

    { reload items to reflect the new month }
    if CheckDataSet then
      UpdatePlanner;
  end;
end;


procedure TDBMonthSource.SetYear(const Value: integer);
begin
  if (Value > 0) and (Value <> FYear) then
  begin
    FYear := Value;
    if not Assigned(FPlanner) then Exit;
    if csLoading in ComponentState then Exit;

    FPlanner.Mode.Year := Value;

    { reload items to reflect the new month }
    if CheckDataSet then
      UpdatePlanner;
  end;
end;

procedure TDBMonthSource.UpdatePlanner;
begin
  if Assigned(FPlanner) then
  begin
    FPlanner.Display.DisplayStart := 0;
    FPlanner.Display.DisplayEnd := DaysInMonth(FMonth,FYear) - 1;

    FPlanner.Items.BeginUpdate;
    ClearDBItems;
    ReadDBItems;
    FPlanner.Items.EndUpdate;
  end;
end;

{ TDBWeekSource }

constructor TDBWeekSource.Create(AOwner: TComponent);
var
  da,mo,ye: word;
begin
  inherited;
  DecodeDate(Now,ye,mo,da);
  FMonth := mo;
  FYear := ye;
  FWeekStart := 0;
  FWeeks := 4;
end;


procedure TDBWeekSource.Loaded;
begin
  inherited;
  if Assigned(FPlanner) then
  begin
    FPlanner.Mode.PlannerType := plWeek;
    FPlanner.Mode.Year := FYear;
    FPlanner.Mode.Month := FMonth;
    FPlanner.Mode.WeekStart := FWeekStart;
    FPlanner.Display.DisplayStart := 0;
    FPlanner.Display.DisplayEnd := FWeeks * 7;
  end;
end;

procedure TDBWeekSource.PlannerChanged;
begin
  inherited;
  if Assigned(FPlanner) then
  begin
    FPlanner.Mode.PlannerType := plWeek;
    FPlanner.Mode.Year := FYear;
    FPlanner.Mode.Month := FMonth;
    FPlanner.Mode.WeekStart := FWeekStart;
  end;
end;

procedure TDBWeekSource.SetMonth(const Value: integer);
begin
  if (Value > 0) and (Value < 13) and (Value <> FMonth) then
  begin
    FMonth := Value;

    if not Assigned(FPlanner) then Exit;
    if csLoading in ComponentState then Exit;
    FPlanner.Mode.Month := Value;

    { reload items to reflect the new month }
    if CheckDataSet then
      UpdatePlanner;
  end;
end;

procedure TDBWeekSource.SetWeeks(const Value: Integer);
begin
  if FWeeks <> Value then
  begin
    FWeeks := Value;
    if CheckDataSet then
      UpdatePlanner;
  end;
end;

procedure TDBWeekSource.SetWeekStart(const Value: Integer);
begin
  FWeekStart := Value;
  if Assigned(FPlanner) then
  begin
    FPlanner.Mode.WeekStart := FWeekStart;
  end;
end;

procedure TDBWeekSource.SetYear(const Value: integer);
begin
  if (Value > 0) and (Value <> FYear) then
  begin
    FYear := Value;
    if not Assigned(FPlanner) then Exit;
    if csLoading in ComponentState then Exit;

    FPlanner.Mode.Year := Value;

    { reload items to reflect the new month }
    if CheckDataSet then
      UpdatePlanner;
  end;
end;

procedure TDBWeekSource.UpdatePlanner;
begin
  FPlanner.Display.DisplayStart := 0;
  FPlanner.Display.DisplayEnd := FWeeks * 7;

  FPlanner.Items.BeginUpdate;
  ClearDBItems;
  ReadDBItems;
  FPlanner.Items.EndUpdate;
end;

{ TDBMultiMonthSource }

procedure TDBMultiMonthSource.AddDBItem;
var
  D: TDataSet;
  B: TBookMark;
begin
  inherited;
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('add selected here?');
  {$ENDIF}

  if Assigned(FOnInsertItem) then
  begin
    BeginUpdate;
    FOnInsertItem(Self,FPlanner.Items.DBItem);
    EndUpdate;
    Exit;
  end;

  BeginUpdate;

  D := DataSource.DataSet;

  B := D.GetBookMark;

  D.Append;

  if not AutoIncKey then
  begin
    D.FieldByName(KeyField).AsString := CreateKey;
    FPlanner.Items.DBItem.DBKey := D.FieldByName(KeyField).AsString;
  end;  

  D.FieldByName(StartTimeField).AsDateTime := FPlanner.Items.DBItem.ItemRealStartTime;
  D.FieldByName(EndTimeField).AsDateTime := FPlanner.Items.DBItem.ItemRealEndTime;

  if SubjectField <> '' then
    D.FieldByName(SubjectField).AsString := FPlanner.Items.DBItem.CaptionText;

  if NotesField <> '' then
    D.FieldByName(NotesField).AsString := FPlanner.Items.DBItem.ItemText;

  if Assigned(FOnItemToFields) then
    FOnItemToFields(Self, D.Fields, FPlanner.Items.DBItem);

  try
    D.Post;
    if AutoIncKey then
      FPlanner.Items.DBItem.DBKey := D.FieldByName(KeyField).AsString;
  finally
    D.GotoBookMark(B);
    D.FreeBookMark(B);
    EndUpdate;
  end;

end;

procedure TDBMultiMonthSource.ConfigurePlanner;
var
  i,j: Integer;
begin
  FPlanner.Positions := NumberOfMonths;
  FPlanner.Display.DisplayStart := 0;
  FPlanner.Display.DisplayEnd := 30;

  if FAutoHeaderUpdate then
  begin
    j := FStartMonth;
    for i := 1 to NumberOfMonths do
    begin
      FPlanner.Header.Captions.Strings[i] := LongMonthNames[j];
      inc(j);
      if j > 12 then
        j := 1;
    end;
  end;  
end;

constructor TDBMultiMonthSource.Create(AOwner: TComponent);
var
  da,mo,ye: word;
begin
  inherited;
  FStartMonth := 1;
  FNumberOfMonths := 3;
  DecodeDate(Now, ye, mo, da);
  FYear := ye;
end;

procedure TDBMultiMonthSource.DeleteDBItem(APlanner: TPlanner);
var
  D: TDataSet;
begin
  inherited;
  {$IFDEF TMSCODESITE}
  SendMsg('delete selected here?');
  {$ENDIF}

  BeginUpdate;
  D := DataSource.DataSet;
  D.Locate(KeyField,APlanner.Items.DBItem.DBKey,[]);
  D.Delete;
  EndUpdate;
end;

procedure TDBMultiMonthSource.GotoDBItem;
var
  D: TDataSet;
begin
  inherited;
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;
  D := DataSource.DataSet;
  D.Locate(KeyField,FPlanner.Items.DBItem.DBKey,[]);
  EndUpdate;
end;

procedure TDBMultiMonthSource.ItemChanged(DBKey: string);
var
  plIt: TPlannerItem;
  dts,dte: TDateTime;
  D: TDataSet;

begin
  inherited;
  if IsUpdating then Exit;
  if (DBKEY='') then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;

  {$IFDEF TMSCODESITE}
  SendMsg(FPlanner.Name+' Itemchanged: '+DBKEY);
  {$ENDIF}

  plIt := FPlanner.Items.FindKey(DBKey);

  if Assigned(plIt) then
  begin
    {$IFDEF TMSCODESITE}
    SendMsg('Found it : '+ plIt.Name);
    {$ENDIF}
    FPlanner.Items.DBItem := plIt;
    ReadDBItem;
    FPlanner.Items.Select(plIt);
  end
  else
  begin
    {$IFDEF TMSCODESITE}
    SendMsg('Add it to '+inttostr(FPlanner.Items.Count)+' items');
    {$ENDIF}

    if not CheckDataSet then Exit;

    D := DataSource.DataSet;

    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    if (dts <= FEndDate) and
       (dte >= FStartDate) then
    begin
      plIt := FPlanner.Items.Add;
      plIt.DBKey := DBKey;
      FPlanner.Items.DBItem := plIt;
      ReadDBItem;
    end;
  end;

  EndUpdate;
end;

procedure TDBMultiMonthSource.Loaded;
begin
  inherited;
  if Assigned(FPlanner) then
    UpdatePlanner;
end;

procedure TDBMultiMonthSource.Next;
var
  NSM,NSY: Integer;
begin
  inherited;
  NSM := StartMonth + 1;
  NSY := Year;
  if NSM > 12 then
  begin
    NSM := 1;
    NSY := Year + 1;
  end;
  StartMonth := NSM;
  Year := NSY;
end;

procedure TDBMultiMonthSource.PlannerChanged;
begin
  inherited;
  if Assigned(FPlanner) then
    UpdatePlanner;
end;

procedure TDBMultiMonthSource.Prev;
var
  NSM,NSY: Integer;
begin
  inherited;
  NSM := StartMonth - 1;
  NSY := Year;
  if NSM < 1 then
  begin
    NSM := 12;
    NSY := Year - 1;
  end;
  StartMonth := NSM;
  Year := NSY;

end;

procedure TDBMultiMonthSource.ReadDBItem;
var
  D: TDataSet;
  dt, dts, dte: TDateTime;
  smo,sye,sda: word;
  emo,eye,eda: word;

begin
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('read selected');
  {$ENDIF}

  D := DataSource.DataSet;

//  B := D.GetBookMark;
//  D.Locate(KeyField,APlanner.Items.Selected.DBKey,[]);

  FPlanner.RemoveClones(FPlanner.Items.DBItem);

  dts := D.FieldByName(StartTimeField).AsDateTime;
  dte := D.FieldByName(EndTimeField).AsDateTime;
  dt := dts;

  if dts >= FStartDate then
    DecodeDate(dts,sye,smo,sda)
  else
    DecodeDate(FStartDate,sye,smo,sda);

  if dte <= FEndDate then
    DecodeDate(dte,eye,emo,eda)
  else
    DecodeDate(FEndDate,eye,emo,eda);

  if (smo <> emo) then
  begin
    with FPlanner.Items.DBItem do
    begin
      Assign(FPlanner.DefaultItem);

      if dts >= FStartDate then
        ItemStartTime := dts
      else
        ItemStartTime := FStartDate;

      if dte <= FEndDate then
        ItemEndTime := EndOfMonth(dts)
      else
        ItemEndTime := FEndDate;

      FixedPos := True;
      FixedPosition := True;
      FixedSize := True;

      RealTime := True;
      ItemRealStartTime := dts;
      ItemRealEndTime := dte;

      if KeyField <> '' then
        DBKey := D.FieldByName(KeyField).AsString;
      if SubjectField <> '' then
        CaptionText := D.FieldByName(SubjectField).AsString;
      if NotesField <> '' then
        Text.Text := D.FieldByName(NotesField).AsString;

      if FReadOnly then
      begin
        FixedPos := True;
        FixedSize := True;
        ReadOnly := True;
      end;

      while (smo < emo) do
      begin
        dts := EndOfMonth(dts) + 1;
        smo := NextMonth(smo);
        with FPlanner.CloneItem(FPlanner.Items.DBItem) do
        begin
          ItemStartTime := dts;
          if smo = emo then
            ItemEndTime := dte
          else
            ItemEndTime := EndOfMonth(dts);

          RealTime := True;
          ItemRealStartTime := dt;
          ItemRealEndTime := dte;
        end;
      end;
    end;
  end
  else
  begin
    with FPlanner.Items.DBItem do
    begin
      Assign(FPlanner.DefaultItem);

      if dts >= FStartDate then
        ItemStartTime := dts
      else
        ItemStartTime := FStartDate;

      if dte <= FEndDate then
        ItemEndTime := dte
      else
        ItemEndTime := FEndDate;

      RealTime := True;
      ItemRealStartTime := dts;
      ItemRealEndTime := dte;

      if KeyField <> '' then
        DBKey := D.FieldByName(KeyField).AsString;
      if SubjectField <> '' then
        CaptionText := D.FieldByName(SubjectField).AsString;
      if NotesField <> '' then
        Text.Text := D.FieldByName(NotesField).AsString;

      if FReadOnly then
      begin
        FixedPos := True;
        FixedSize := True;
        ReadOnly := True;
      end;

    end;
  end;

  if Assigned(FOnFieldsToItem) then
    FOnFieldsToItem(Self, D.Fields, FPlanner.Items.DBItem);
end;

procedure TDBMultiMonthSource.ReadDBItems;
var
  D: TDataSet;
  B: TBookMark;
  dt,dts,dte: TDateTime;
  plIt: TPlannerItem;
  Accept: Boolean;
  smo,sye,sda: word;
  emo,eye,eda: word;

begin
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('READ DB ITEMS : '+FPlanner.Name);
  {$ENDIF}

  BeginUpdate;

  if Assigned(FOnSetFilter) then
    FOnSetFilter(Self);

  D := DataSource.DataSet;

  D.DisableControls;

  B := D.GetBookMark;

  D.First;

  ConfigurePlanner;

  FPlanner.Items.BeginUpdate;

  while not D.Eof do
  begin
    Accept := True;

    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;
    dt := dts;

    if (dts <= FEndDate) and
       (dte >= FStartDate) and
       Accept and Assigned(FOnAccept) then
    begin
      FOnAccept(Self,D.Fields,Accept);
    end;

    if (dts <= FEndDate) and
       (dte >= FStartDate) and Accept then
    begin
      plIt := FPlanner.Items.FindKey(D.FieldByName(KeyField).AsString);

      if not Assigned(plIt) then
      begin
        {$IFDEF TMSCODESITE}
        SendMsg(FPlanner.Name+' Add:'+D.FieldByName(KeyField).AsString);
        {$ENDIF}
        plIt := FPlanner.Items.Add;
      end;

      if dts >= FStartDate then
        DecodeDate(dts,sye,smo,sda)
      else
        DecodeDate(FStartDate,sye,smo,sda);

      if dte <= FEndDate then
        DecodeDate(dte,eye,emo,eda)
      else
        DecodeDate(FEndDate,eye,emo,eda);

      if (smo <> emo) then
      begin
        with plIt do
        begin
          Assign(FPlanner.DefaultItem);
          
          if dts >= FStartDate then
            ItemStartTime := dts
          else
            ItemStartTime := FStartDate;

          if dte <= FEndDate then
            ItemEndTime := EndOfMonth(dts)
          else
            ItemEndTime := FEndDate;

          FixedPos := True;
          FixedSize := True;
          FixedPosition := True;

          RealTime := True;

          ItemRealStartTime := dts;
          ItemRealEndTime := dte;

          if KeyField <> '' then
            DBKey := D.FieldByName(KeyField).AsString;
          if SubjectField <> '' then
            CaptionText := D.FieldByName(SubjectField).AsString;
          if NotesField <> '' then
            Text.Text := D.FieldByName(NotesField).AsString;

          if FReadOnly then
          begin
            FixedPos := True;
            FixedSize := True;
            ReadOnly := True;
          end;

          while (smo < emo) do
          begin
            dts := EndOfMonth(dts) + 1;
            smo := NextMonth(smo);

            with FPlanner.CloneItem(plIt) do
            begin
              ItemStartTime := dts;
              if smo = emo then
                ItemEndTime := dte
              else
                ItemEndTime := EndOfMonth(dts);

              RealTime := True;
              ItemRealStartTime := dt;
              ItemRealEndTime := dte;

            end;
          end;

        end;
      end
      else
      begin
        with plIt do
        begin
          Assign(FPlanner.DefaultItem);

          if dts >= FStartDate then
            ItemStartTime := dts
          else
            ItemStartTime := FStartDate;

          if dte <= FEndDate then
            ItemEndTime := dte
          else
            ItemEndTime := FEndDate;

          RealTime := True;

          ItemRealStartTime := dts;
          ItemRealEndTime := dte;


          if KeyField <> '' then
            DBKey := D.FieldByName(KeyField).AsString;
          if SubjectField <> '' then
            CaptionText := D.FieldByName(SubjectField).AsString;
          if NotesField <> '' then
            Text.Text := D.FieldByName(NotesField).AsString;

          if FReadOnly then
          begin
            FixedPos := True;
            FixedSize := True;
            ReadOnly := True;
          end;

        end;
      end;
      if Assigned(FOnFieldsToItem) then
        FOnFieldsToItem(Self, D.Fields, plIt);

    end;
    D.Next;
  end;

  D.GotoBookMark(B);
  D.EnableControls;
  D.FreeBookMark(B);

  if Assigned(FOnResetFilter) then
    FOnResetFilter(Self);

  EndUpdate;

  FPlanner.Items.EndUpdate;

  if Assigned(OnItemsRead) then
    OnItemsRead(Self);  
  
  {$IFDEF TMSCODESITE}
  SendMsg('DONE READ DB ITEMS');
  {$ENDIF}
end;

procedure TDBMultiMonthSource.SetNumberOfMonths(const Value: Integer);
begin
  FNumberOfMonths := Value;
  if CheckDataSet then
    UpdatePlanner;
end;

procedure TDBMultiMonthSource.SetStartMonth(const Value: Integer);
begin
  if (Value <= 0) or (Value > 12) then
    Exit;

  FStartMonth := Value;
  if CheckDataSet then
    UpdatePlanner;
end;

procedure TDBMultiMonthSource.SetYear(const Value: Integer);
begin
  FYear := Value;
  { reload items to reflect the new year }
  if CheckDataSet then
    UpdatePlanner;
end;

procedure TDBMultiMonthSource.SynchDBItems;
var
  D: TDataSet;
  B: TBookMark;
  dts,dte: TDateTime;
  plIt: TPlannerItem;
  i: Integer;

begin
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;

  if Assigned(FOnSetFilter) then
    FOnSetFilter(Self);

  D := DataSource.DataSet;
  B := D.GetBookMark;
  D.First;

  for i := 1 to FPlanner.Items.Count do
    FPlanner.Items[i - 1].Synched := False;

  while not D.Eof do
  begin
    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    if (dts <= FEndDate) and
       (dte >= FStartDate) then
    begin
      plIt := FPlanner.Items.FindKey(D.FieldByName(KeyField).AsString);
      if Assigned(plIt) then
        plIt.Synched := True;
    end;
    D.Next;
  end;

  for i := FPlanner.Items.Count downto 1 do
  begin
    if not FPlanner.Items[i - 1].Synched then
      FPlanner.Items[i - 1].Free;
  end;

  D.GotoBookMark(B);
  D.FreeBookMark(B);

  if Assigned(FOnResetFilter) then
    FOnResetFilter(Self);

  EndUpdate;

end;

procedure TDBMultiMonthSource.UpdatePlanner;
var
  Ey,Em: Integer;

begin
  FPlanner.Positions := FNumberOfMonths;
  FPlanner.Mode.Month := FStartMonth;
  FPlanner.Mode.Year := FYear;
  FPlanner.Mode.PlannerType := plMultiMonth;

  FStartDate := EncodeDate(FYear,FStartMonth,1);

//  Ey := FYear + (FStartMonth + FNumberOfMonths - 1) div 12;

  Ey := FYear;

  Em := (FStartMonth + FNumberOfMonths - 1);

  while Em > 12 do
  begin
    Em := Em - 12;
    Inc(Ey);
  end;

  FEndDate := EncodeDate(Ey,Em,DaysInMonth(Em,Ey));

  ConfigurePlanner;
  FPlanner.Items.BeginUpdate;
  ClearDBItems;
  ReadDBItems;
  FPlanner.Items.EndUpdate;
end;

procedure TDBMultiMonthSource.WriteDBItem;
var
  D: TDataSet;
  B: TBookMark;
begin
  if IsUpdating then Exit;

  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('write selected here?');
  {$ENDIF}

  if Assigned(FOnUpdateItem) then
  begin
    BeginUpdate;
    FOnUpdateItem(Self,FPlanner.Items.DBItem);
    EndUpdate;
    if not FUpdateByQuery then
      Exit;
  end;

  BeginUpdate;

  D := DataSource.DataSet;

  B := D.GetBookMark;

  D.Locate(KeyField,FPlanner.Items.DBItem.DBKey,[]);
  D.Edit;

  D.FieldByName(StartTimeField).AsDateTime := FPlanner.Items.DBItem.ItemRealStartTime;
  D.FieldByName(EndTimeField).AsDateTime := FPlanner.Items.DBItem.ItemRealEndTime - 1;

  if SubjectField <> '' then
    D.FieldByName(SubjectField).AsString := FPlanner.Items.DBItem.CaptionText;

  if NotesField <> '' then
    D.FieldByName(NotesField).AsString := FPlanner.Items.DBItem.ItemText;

  if Assigned(FOnItemToFields) then
    FOnItemToFields(Self, D.Fields, FPlanner.Items.DBItem);

  ReadDBItem;
  FPlanner.Items.Select(FPlanner.Items.DBItem);

  try
    D.Post;
  finally
    D.GotoBookMark(B);
    D.FreeBookMark(B);
    EndUpdate;
  end;

end;

{ TDBTimeLineSource }

procedure TDBTimeLineSource.AddDBItem;
var
  D: TDataSet;
  B: TBookMark;

begin
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('add selected here?');
  {$ENDIF}

  if Assigned(FOnInsertItem) then
  begin
    BeginUpdate;
    FOnInsertItem(Self,FPlanner.Items.DBItem);
    EndUpdate;
    Exit;
  end;

  BeginUpdate;

  D := DataSource.DataSet;

  B := D.GetBookMark;

  D.Append;

  if not AutoIncKey then
  begin
    D.FieldByName(KeyField).AsString := CreateKey;
    FPlanner.Items.DBItem.DBKey := D.FieldByName(KeyField).AsString;
  end;

  D.FieldByName(StartTimeField).AsDateTime := FPlanner.Items.DBItem.ItemStartTime;
  D.FieldByName(EndTimeField).AsDateTime := FPlanner.Items.DBItem.ItemEndTime;

  if (ResourceField <> '') then
  begin
    if Assigned(FOnPositionToResource) then
      FOnPositionToResource(Self, D.FieldByName(ResourceField), FPlanner.Items.DBItem.ItemPos)
    else
      D.FieldByName(ResourceField).AsInteger := FPlanner.Items.DBItem.ItemPos;
  end;

  if SubjectField <> '' then
    D.FieldByName(SubjectField).AsString := FPlanner.Items.DBItem.CaptionText;

  if NotesField <> '' then
    D.FieldByName(NotesField).AsString := FPlanner.Items.DBItem.ItemText;

  if Assigned(FOnItemToFields) then
    FOnItemToFields(Self, D.Fields, FPlanner.Items.DBItem);

  try
    D.Post;
    if AutoIncKey then
      FPlanner.Items.DBItem.DBKey := D.FieldByName(KeyField).AsString;
  finally
    D.GotoBookMark(B);
    D.FreeBookMark(B);
    EndUpdate;
  end;
end;

constructor TDBTimeLineSource.Create(AOwner: TComponent);
begin
  inherited;
  FStartDate := Int(Now);
  FEndDate := Int(Now) + 3;
end;

procedure TDBTimeLineSource.DeleteDBItem(APlanner: TPlanner);
var
  D: TDataSet;
begin
  inherited;
  {$IFDEF TMSCODESITE}
  SendMsg('delete selected here?');
  {$ENDIF}

  BeginUpdate;
  D := DataSource.DataSet;
  D.Locate(KeyField,APlanner.Items.DBItem.DBKey,[]);
  D.Delete;
  EndUpdate;
end;

procedure TDBTimeLineSource.GotoDBItem;
var
  D: TDataSet;
begin
  inherited;
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;
  D := DataSource.DataSet;
  D.Locate(KeyField,FPlanner.Items.DBItem.DBKey,[]);
  EndUpdate;
end;

procedure TDBTimeLineSource.ItemChanged(DBKey: string);
var
  plIt: TPlannerItem;
  dts,dte: TDateTime;
  D: TDataSet;

begin
  inherited;
  if IsUpdating then Exit;
  if (DBKEY='') then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;

  {$IFDEF TMSCODESITE}
  SendMsg(FPlanner.Name+' Itemchanged: '+DBKEY);
  {$ENDIF}

  plIt := FPlanner.Items.FindKey(DBKey);

  if Assigned(plIt) then
  begin
    {$IFDEF TMSCODESITE}
    SendMsg('Found it : '+ plIt.Name);
    {$ENDIF}
    FPlanner.Items.DBItem := plIt;
    ReadDBItem;

    FPlanner.Items.Select(plIt);
  end
  else
  begin
    {$IFDEF TMSCODESITE}
    SendMsg('Add it to '+inttostr(FPlanner.Items.Count)+' items');
    {$ENDIF}

    if not CheckDataSet then Exit;

    D := DataSource.DataSet;

    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    if (dts < FPlanner.Mode.PeriodEndDate) and
       (dte > FPlanner.Mode.PeriodStartDate) then
    begin
      plIt := FPlanner.Items.Add;
      plIt.DBKey := DBKey;
      FPlanner.Items.DBItem := plIt;
      ReadDBItem;
    end;
  end;

  EndUpdate;
end;

procedure TDBTimeLineSource.Next;
begin
  inherited;
end;

procedure TDBTimeLineSource.PlannerChanged;
begin
  inherited;
  UpdatePlanner;
end;

function TDBTimeLineSource.PosToRes(Pos: Integer): Integer;
begin
  Result := Pos;
end;

procedure TDBTimeLineSource.Prev;
begin
  inherited;
end;

procedure TDBTimeLineSource.ReadDBItem;
var
  D: TDataSet;
  dts, dte: TDateTime;
  ResourcePos: Integer;
  Accept: Boolean;

begin
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('read selected');
  {$ENDIF}

  D := DataSource.DataSet;

//  B := D.GetBookMark;
//  D.Locate(KeyField,APlanner.Items.Selected.DBKey,[]);

  FPlanner.RemoveClones(FPlanner.Items.DBItem);

  dts := D.FieldByName(StartTimeField).AsDateTime;
  dte := D.FieldByName(EndTimeField).AsDateTime;

  with FPlanner.Items.DBItem do
  begin
    Assign(FPlanner.DefaultItem);

    ItemStartTime := dts;
    ItemEndTime := dte;

    if KeyField <> '' then
      DBKey := D.FieldByName(KeyField).AsString;
    if SubjectField <> '' then
      CaptionText := D.FieldByName(SubjectField).AsString;
    if NotesField <> '' then
      Text.Text := D.FieldByName(NotesField).AsString;

    if (ResourceField <> '') then
    begin
      if Assigned(FOnResourceToPosition) then
        FOnResourceToPosition(Self,D.FieldByName(ResourceField),ResourcePos, Accept)
      else
        ResourcePos := D.FieldByName(ResourceField).AsInteger;

      ItemPos := ResourcePos;
    end;


    if FReadOnly then
    begin
      FixedPos := True;
      FixedSize := True;
      ReadOnly := True;
    end;
  end;

  if Assigned(FOnFieldsToItem) then
    FOnFieldsToItem(Self, D.Fields, FPlanner.Items.DBItem);
end;

procedure TDBTimeLineSource.ReadDBItems;
var
  D: TDataSet;
  B: TBookMark;
  dts,dte: TDateTime;
  plIt: TPlannerItem;
  Accept: Boolean;
  ResourcePos: Integer;

begin
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('READ DB ITEMS : '+FPlanner.Name);
  {$ENDIF}

  BeginUpdate;

  if Assigned(FOnSetFilter) then
    FOnSetFilter(Self);

  D := DataSource.DataSet;

  D.DisableControls;

  B := D.GetBookMark;

  D.First;

//  ConfigurePlanner;

  FPlanner.Items.BeginUpdate;

  while not D.Eof do
  begin
    Accept := True;

    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    if (dts <= FEndDate) and
       (dte >= FStartDate) and
       Accept and Assigned(FOnAccept) then
    begin
      FOnAccept(Self,D.Fields,Accept);
    end;

    if (dts <= FEndDate) and
       (dte >= FStartDate) and Accept then
    begin
      plIt := FPlanner.Items.FindKey(D.FieldByName(KeyField).AsString);

      if not Assigned(plIt) then
      begin
        {$IFDEF TMSCODESITE}
        SendMsg(FPlanner.Name+' Add:'+D.FieldByName(KeyField).AsString);
        {$ENDIF}
        plIt := FPlanner.Items.Add;
      end;

      with plIt do
      begin
        Assign(FPlanner.DefaultItem);

        ItemStartTime := dts;
        ItemEndTime := dte;

        if KeyField <> '' then
           DBKey := D.FieldByName(KeyField).AsString;
        if SubjectField <> '' then
          CaptionText := D.FieldByName(SubjectField).AsString;
        if NotesField <> '' then
          Text.Text := D.FieldByName(NotesField).AsString;

        if (ResourceField <> '') then
        begin
          if Assigned(FOnResourceToPosition) then
            FOnResourceToPosition(Self,D.FieldByName(ResourceField),ResourcePos, Accept)
          else
            ResourcePos := D.FieldByName(ResourceField).AsInteger;

          ItemPos := ResourcePos;
        end;

        if FReadOnly then
        begin
          FixedPos := True;
          FixedSize := True;
          ReadOnly := True;
        end;
      end;

      if Assigned(FOnFieldsToItem) then
        FOnFieldsToItem(Self, D.Fields, plIt);

    end;
    D.Next;
  end;

  D.GotoBookMark(B);
  D.EnableControls;
  D.FreeBookMark(B);

  if Assigned(FOnResetFilter) then
    FOnResetFilter(Self);

  EndUpdate;

  FPlanner.Items.EndUpdate;

  if Assigned(OnItemsRead) then
    OnItemsRead(Self);  

  {$IFDEF TMSCODESITE}
  SendMsg('DONE READ DB ITEMS');
  {$ENDIF}
end;

procedure TDBTimeLineSource.SetEndDate(const Value: TDateTime);
begin
  FEndDate := Value;
  UpdatePlanner;
end;

procedure TDBTimeLineSource.SetStartDate(const Value: TDateTime);
begin
  FStartDate := Value;
  UpdatePlanner;
end;

procedure TDBTimeLineSource.SynchDBItems;
var
  D: TDataSet;
  B: TBookMark;
  dts,dte: TDateTime;
  plIt: TPlannerItem;
  i: Integer;

begin
  if IsUpdating then Exit;
  if not CheckDataSet then Exit;
  if not Assigned(FPlanner) then Exit;

  BeginUpdate;

  if Assigned(FOnSetFilter) then
    FOnSetFilter(Self);

  D := DataSource.DataSet;
  B := D.GetBookMark;
  D.First;

  for i := 1 to FPlanner.Items.Count do
    FPlanner.Items[i - 1].Synched := False;

  while not D.Eof do
  begin
    dts := D.FieldByName(StartTimeField).AsDateTime;
    dte := D.FieldByName(EndTimeField).AsDateTime;

    if (dts <= FEndDate) and
       (dte >= FStartDate) then
    begin
      plIt := FPlanner.Items.FindKey(D.FieldByName(KeyField).AsString);
      if Assigned(plIt) then
        plIt.Synched := True;
    end;
    D.Next;
  end;

  for i := FPlanner.Items.Count downto 1 do
  begin
    if not FPlanner.Items[i - 1].Synched then
      FPlanner.Items[i - 1].Free;
  end;

  D.GotoBookMark(B);
  D.FreeBookMark(B);

  if Assigned(FOnResetFilter) then
    FOnResetFilter(Self);

  EndUpdate;
end;

procedure TDBTimeLineSource.UpdatePlanner;
begin
  if Assigned(FPlanner) then
  begin

    FPlanner.Mode.PlannerType := plTimeLine;

    FPlanner.Mode.TimeLineStart := FStartDate;

    if FPlanner.Display.DisplayUnit > 0 then
      FPlanner.Display.DisplayEnd := ((Round(FEndDate - FStartDate)) * MININDAY) div FPlanner.Display.DisplayUnit;
  end;   
end;

procedure TDBTimeLineSource.WriteDBItem;
var
  D: TDataSet;
  B: TBookMark;
  ResPos: Integer;
begin
  if IsUpdating then Exit;

  if not CheckDataSet then Exit;

  {$IFDEF TMSCODESITE}
  SendMsg('write selected here?');
  {$ENDIF}

  if Assigned(FOnUpdateItem) then
  begin
    BeginUpdate;
    FOnUpdateItem(Self,FPlanner.Items.DBItem);
    EndUpdate;
    if not FUpdateByQuery then
      Exit;
  end;

  BeginUpdate;

  D := DataSource.DataSet;

  B := D.GetBookMark;

  D.Locate(KeyField,FPlanner.Items.DBItem.DBKey,[]);
  D.Edit;

  D.FieldByName(StartTimeField).AsDateTime := FPlanner.Items.DBItem.ItemStartTime;
  D.FieldByName(EndTimeField).AsDateTime := FPlanner.Items.DBItem.ItemEndTime;

  if SubjectField <> '' then
    D.FieldByName(SubjectField).AsString := FPlanner.Items.DBItem.CaptionText;

  if NotesField <> '' then
    D.FieldByName(NotesField).AsString := FPlanner.Items.DBItem.ItemText;

  if (ResourceField <> '') then
  begin
    ResPos := PosToRes(FPlanner.Items.DBItem.ItemPos);

    if Assigned(FOnPositionToResource) then
      FOnPositionToResource(Self,D.FieldByName(ResourceField),ResPos)
    else
      D.FieldByName(ResourceField).AsInteger := ResPos;
  end;

  if Assigned(FOnItemToFields) then
    FOnItemToFields(Self, D.Fields, FPlanner.Items.DBItem);

  ReadDBItem;

  FPlanner.Items.Select(FPlanner.Items.DBItem);

  try
    D.Post;
  finally
    D.GotoBookMark(B);
    D.FreeBookMark(B);
    EndUpdate;
  end;

end;

{ TDBHalfDayPeriodSource }

procedure TDBHalfDayPeriodSource.PlannerChanged;
begin
  inherited;
  UpdatePlanner;
end;

procedure TDBHalfDayPeriodSource.UpdatePlanner;
begin
  if Assigned(FPlanner) then
  begin
    FPlanner.Mode.PlannerType := plHalfDayPeriod;
    FPlanner.Display.DisplayStart := 0;
    FPlanner.Display.DisplayEnd := 2 * Round(Int(FEndDate) - Int(FStartDate));
  end;
end;

initialization
  {$IFDEF TMSCODESITE}
//  CodeSite.Clear;
  {$ENDIF}
end.
