{-----------------------------------------------------------------------------
 Unit Name: idFrameContainer
 Author:    Marc Dürst (marc@idev.ch, www.idev.ch)
 Purpose:   TidFrameContainer something like to old TNoteBook was but using
            frames for its childdata.
 History:

-----------------------------------------------------------------------------}


unit idFrameContainer;

interface

uses
  classes, windows, sysutils, controls, forms, ExtCtrls;

type

  TidFrameCollectionItem = class;
  TidFrameCollection = class;
  TidFrameContainer = class;
  TidFrameClass = class of TFrame;
  TidFrameCommand = class;
  TidFrameCommandCollection = class;
  TidOnBeforeChangeEvent = procedure(Sender: TObject; NewFrameItem: TidFrameCollectionItem; var AllowChange: boolean) of object;
  TidOnAfterChangedEvent = procedure(Sender: TObject; OldFrameItem: TidFrameCollectionItem) of object;
  TidOnFrameChanged = procedure(Sender: TObject; OldFrame, NewFrame: TidFrameCollectionItem) of object;
  TidOnFrameCommand = procedure(Sender: TObject; var AidFrameCommand: TidFrameCommand; var ASuccessful: boolean) of object;

  TidFrameContainer = class(TWinControl)
  private
    fFrames : TidFrameCollection;
    FActiveFrameItem: TidFrameCollectionItem;
    FOnFrameChanged: TidOnFrameChanged;
    FCommands: TidFrameCommandCollection;
    procedure SetCommands(const Value: TidFrameCommandCollection);
  protected
    procedure SetFrames(const Value: TidFrameCollection); virtual;
    procedure SetActiveFrameItem(const Value: TidFrameCollectionItem); virtual;
    function  SendCommand(AFrameItem: TidFrameCollectionItem; var ACommand: TidFrameCommand): boolean; virtual;

    property Caption; // Hide "Caption" because it is never used
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SendCommandToActive(var ACommand: TidFrameCommand): boolean; virtual;
    function SendCommandToAll(var ACommand: TidFrameCommand): boolean; virtual;


  published
    property ActiveFrameItem: TidFrameCollectionItem read FActiveFrameItem write SetActiveFrameItem;
    property Commands: TidFrameCommandCollection read FCommands write SetCommands;
    property Frames: TidFrameCollection read FFrames write SetFrames;

    property Align;

    property OnFrameChanged: TidOnFrameChanged read FOnFrameChanged write FOnFrameChanged;
  end;

  TidFrameCollectionItem = class(TCollectionItem)
  private
    FOnAfterChanged: TidOnAfterChangedEvent;
    FOnBeforeChange: TidOnBeforeChangeEvent;
    FName: string;
    FOnCommand: TidOnFrameCommand;
  protected
    FOwnerCollection: TidFrameCollection;
    FFrameClass: TidFrameClass; // Class of the frame created
    FFrame: TFrame;             // Reference to the frame instance
    function GetDisplayName: string; override;
    function GetFrame: TFrame; virtual;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;

    function  SendCommand(var ACommand: TidFrameCommand): boolean; virtual;

    property Frame: TFrame read GetFrame;

  published
    property Name: string read FName write FName;
    property FrameClass: TidFrameClass read FFrameClass write FFrameClass;

    property OnBeforeChange: TidOnBeforeChangeEvent read FOnBeforeChange write FOnBeforeChange;
    property OnAfterChanged: TidOnAfterChangedEvent read FOnAfterChanged write FOnAfterChanged;
    property OnCommand: TidOnFrameCommand read FOnCommand write FOnCommand;
  end;

  TidFrameCollection = class(TCollection)
  private
    FOwner: TidFrameContainer;
    function GetItem(Index: Integer): TidFrameCollectionItem;
    procedure SetItem(Index: Integer; Value: TidFrameCollectionItem);
    function GetItemByName(AName: string): TidFrameCollectionItem;
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(ItemClass: TCollectionItemClass);
    function Add: TidFrameCollectionItem;
    property OwnerContainer: TidFrameContainer read FOwner write FOwner;
    property Items[Index: Integer]: TidFrameCollectionItem read GetItem write SetItem; default;
    property ByName[AName: string]: TidFrameCollectionItem read GetItemByName;
  end;

  TidFrameCommand = class(TCollectionItem)
  private
    FCommandName: string;
    FCommandID: integer;
  protected
    FOwnerCollection: TidFrameCommandCollection;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;
  published
    property CommandName: string read FCommandName write FCommandName;
    property CommandID: integer read FCommandID write FCommandID;
  end;

  TidFrameCommandCollection = class(TCollection)
  private
    FOwner: TidFrameContainer;
    function GetItem(Index: Integer): TidFrameCommand;
    procedure SetItem(Index: Integer; Value: TidFrameCommand);
    function GetItemByCommandName(ACommandName: string): TidFrameCommand;
    function GetItemByID(ACommandID: integer): TidFrameCommand;
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(ItemClass: TCollectionItemClass);
    function Add: TidFrameCommand;

    property Items[Index: Integer]: TidFrameCommand read GetItem write SetItem; default;
    property ByCommandName[AName: string]: TidFrameCommand read GetItemByCommandName;
    property ByCommandID[ACommandID: integer]: TidFrameCommand read GetItemByID;
    property OwnerContainer: TidFrameContainer read FOwner write FOwner;
  end;

  EidFrameContainerError = class(Exception)
  private
    FFrameContainer: TidFrameContainer;
  public
    constructor Create(AFrameContainer: TidFrameContainer; const AMessage: string);
    property FrameContainer: TidFrameContainer read FFrameContainer;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('iDev', [TidFrameContainer]);
end;


{ TidFrameCollectionItem }

constructor TidFrameCollectionItem.Create(Collection: TCollection);
begin
  inherited;
  FFrame := nil;
  FOwnerCollection := TidFrameCollection(Collection);
  FOnAfterChanged := nil;
  FOnBeforeChange := nil;
  FOnCommand := nil;
end;

destructor TidFrameCollectionItem.Destroy;
begin
  if assigned(FFrame) then FreeAndNil(FFrame);
  inherited;
end;

function TidFrameCollectionItem.GetDisplayName: string;
begin
  Result := Name;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TidFrameCollectionItem.GetFrame: TFrame;
begin
  if not assigned(FFrame) then begin
    FFrame := FFrameClass.Create(nil);
    FFrame.Visible := false;
    FFrame.Parent := FOwnerCollection.OwnerContainer;
    FFrame.Align := alClient;
  end;
  result := FFrame;
end;

function TidFrameCollectionItem.SendCommand(
  var ACommand: TidFrameCommand): boolean;
var Successful : boolean;
begin
  Successful := true;
  if assigned(OnCommand) then OnCommand(self, ACommand, Successful);
  result := Successful;
end;

{ TidFrameCollection }

function TidFrameCollection.Add: TidFrameCollectionItem;
begin
  Result := TidFrameCollectionItem(inherited Add);
end;

constructor TidFrameCollection.Create(ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
end;

function TidFrameCollection.GetItem(
  Index: Integer): TidFrameCollectionItem;
begin
  Result := TidFrameCollectionItem(inherited GetItem(Index));
end;

function TidFrameCollection.GetItemByName(
  AName: string): TidFrameCollectionItem;
var
  i : integer;
begin
  result := nil;
  if Count > 0 then
    for i := 0 to pred(Count) do
      if Items[i].Name = AName then begin
        result := Items[i];
        Break;
      end;
end;

function TidFrameCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TidFrameCollection.SetItem(Index: Integer;
  Value: TidFrameCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TidFrameCollection.Update(Item: TCollectionItem);
begin
  inherited;
  { Not used yet but will be in future i guess. }
end;

{ TidFrameContainer }

constructor TidFrameContainer.Create(AOwner: TComponent);
begin
  inherited;
  FActiveFrameItem := nil;
  FOnFrameChanged := nil;
  FFrames := TidFrameCollection.Create(TidFrameCollectionItem);
  FFrames.OwnerContainer := self;
  FCommands := TidFrameCommandCollection.Create(TidFrameCommand);
  FCommands.OwnerContainer := self;
  Caption := '';
  BevelOuter := bvLowered;
end;

destructor TidFrameContainer.Destroy;
begin
  FActiveFrameItem := nil;
  if assigned(FCommands) then FreeAndNil(FCommands);
  if assigned(FFrames) then FreeAndNil(FFrames);
  inherited;
end;

function TidFrameContainer.SendCommand(AFrameItem: TidFrameCollectionItem;
  var ACommand: TidFrameCommand): boolean;
begin
  result := AFrameItem.SendCommand(ACommand);
end;

function TidFrameContainer.SendCommandToActive(
  var ACommand: TidFrameCommand): boolean;
begin
  result := true;
  if assigned(ActiveFrameItem) then
    result := SendCommand(ActiveFrameItem, ACommand);
end;

function TidFrameContainer.SendCommandToAll(
  var ACommand: TidFrameCommand): boolean;
var
  i : integer;
begin
  result := true;
  if Frames.Count > 0 then
    for i := 0 to pred(Frames.Count) do
      if not Frames.Items[i].SendCommand(ACommand) then result := false;
end;

procedure TidFrameContainer.SetActiveFrameItem(
  const Value: TidFrameCollectionItem);
var
  AllowChange: boolean;
  OldFrameItem: TidFrameCollectionItem;
begin

  if FActiveFrameItem <> Value then begin

    AllowChange := true;

    { Asking current frame to leave }
    if  (not (csDesigning in ComponentState))
    and (assigned(FActiveFrameItem))
    and (assigned(FActiveFrameItem.OnBeforeChange)) then
      Value.OnBeforeChange(self, Value, AllowChange);

    if AllowChange then begin

      { Leaving old frame }
      OldFrameItem := FActiveFrameItem;
      if assigned(FActiveFrameItem) then
        FActiveFrameItem.Frame.Visible := false;

      { Enter new frame }
      FActiveFrameItem := Value;
      if assigned(FActiveFrameItem) then
        FActiveFrameItem.Frame.Visible := true;

      { Inform new frame about changes done }
      if  (not (csDesigning in ComponentState))
      and (assigned(FActiveFrameItem))
      and (assigned(FActiveFrameItem.OnAfterChanged)) then
        FActiveFrameItem.OnAfterChanged(self, OldFrameItem);

      { Inform collection about changes done }
      if  (not (csDesigning in ComponentState))
      and (assigned(FOnFrameChanged)) then
        OnFrameChanged(self, OldFrameItem, FActiveFrameItem);

    end;

  end;
end;

procedure TidFrameContainer.SetCommands(
  const Value: TidFrameCommandCollection);
begin
  if not assigned(Value) then raise EidFrameContainerError.Create(self, 'Commands property can not be set to NIL!');
  if FCommands <> Value then
    FCommands := Value;
end;

procedure TidFrameContainer.SetFrames(const Value: TidFrameCollection);
begin
  if not assigned(Value) then raise EidFrameContainerError.Create(self, 'Frames property can not be set to NIL!');

  if FFrames <> Value then begin
    FFrames := Value;
  end;
end;

{ EidFrameContainerError }

constructor EidFrameContainerError.Create(
  AFrameContainer: TidFrameContainer; const AMessage: string);
begin
  inherited Create(AMessage);
  FFrameContainer := AFrameContainer;
end;

{ TidFrameCommand }

constructor TidFrameCommand.Create(Collection: TCollection);
begin
  inherited;
  FOwnerCollection := TidFrameCommandCollection(Collection);
  CommandName := '';
  CommandID := -1;
end;

destructor TidFrameCommand.Destroy;
begin
  inherited;
end;

function TidFrameCommand.GetDisplayName: string;
begin
  Result := CommandName;
  if Result = '' then Result := inherited GetDisplayName;
end;


{ TidFrameCommandCollection }

function TidFrameCommandCollection.Add: TidFrameCommand;
begin
  result := TidFrameCommand(inherited Add);
end;

constructor TidFrameCommandCollection.Create(ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
end;

function TidFrameCommandCollection.GetItem(
  Index: Integer): TidFrameCommand;
begin
  result := TidFrameCommand(inherited GetItem(Index));
end;

function TidFrameCommandCollection.GetItemByID(
  ACommandID: integer): TidFrameCommand;
var
  i : integer;
begin
  result := nil;
  if Count > 0 then
    for i := 0 to pred(count) do
      if Items[i].CommandID = ACommandID then begin
        result := Items[i];
        Break;
      end;
end;

function TidFrameCommandCollection.GetItemByCommandName(
  ACommandName: string): TidFrameCommand;
var
  i : integer;
begin
  result := nil;
  if Count > 0 then
    for i := 0 to pred(count) do
      if Items[i].CommandName = ACommandName then begin
        result := Items[i];
        Break;
      end;
end;

function TidFrameCommandCollection.GetOwner: TPersistent;
begin
  result := FOwner;
end;

procedure TidFrameCommandCollection.SetItem(Index: Integer;
  Value: TidFrameCommand);
begin
  inherited SetItem(Index, Value);
end;

procedure TidFrameCommandCollection.Update(Item: TCollectionItem);
begin
  inherited;
end;

end.
