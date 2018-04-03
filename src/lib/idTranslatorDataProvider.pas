unit idTranslatorDataProvider;

interface

uses
  classes;

type

  { Used to handle abstract form of locations in object oriented manner. }
  TidTlLocatorNode = class
  private
    FNodeName: string;
    FPrevNode: TidTlLocatorNode;
    FNextNode: TidTlLocatorNode;
    FRootNode: TidTlLocatorNode;
    function GetAsText: string;
  public
    constructor Create(ANodeName: string; APrevNode, ARootNode: TidTlLocatorNode);
    destructor Destroy; override;

    property NodeName: string read FNodeName write FNodeName;
    property PrevNode: TidTlLocatorNode read FPrevNode write FPrevNode;
    property NextNode: TidTlLocatorNode read FNextNode write FNextNode;
    property RootNode: TidTlLocatorNode read FRootNode write FRootNode;
    property AsText: string read GetAsText;
  end;

  { Abstract base class for all kind of translation data providers }
  TidTlCustomDataProvider = class(TComponent)
  private
    FLanguage: string;
    FDefaultLanguage: string;
  protected
    FAttachedTranslators: TList;
    procedure SetLanguage(const Value: string); virtual;
    function GetBiDiMode: TBiDiMode; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AttachTranslator(ATranslator: TObject);
    procedure DetacheTranslator(ATranslator: TObject);

    function GetPropTranslation(ALocatorNode: TidTlLocatorNode;
                                APropName: string): string; virtual; abstract;
    property BiDiMode: TBiDiMode read GetBiDiMode;

    { Writer-Methods to generate default datafile }
    function WriteBegin: boolean; virtual; abstract;
    function WriteProperty(ALocatorNode: TidTlLocatorNode; APropName, APropValue: string): boolean; virtual; abstract;
    function WriteEnd: boolean; virtual; abstract;

  published
    property DefaultLanguage: string read FDefaultLanguage write FDefaultLanguage;
    property Language: string read FLanguage write SetLanguage;
  end;

implementation

uses
  SysUtils, forms, idTranslator;

{ TidTlLocatorNode }

constructor TidTlLocatorNode.Create(ANodeName: string;
  APrevNode, ARootNode: TidTlLocatorNode);
begin
  assert(ANodeName <> '', 'Empty translation locator node names not allowed!');
  FNodeName := ANodeName;
  FPrevNode := APrevNode;
  FRootNode := ARootNode;
  if assigned(APrevNode) then begin
    APrevNode.NextNode := self;
  end;
end;

destructor TidTlLocatorNode.Destroy;
begin
  if assigned(FPrevNode) then begin
    FPrevNode.NextNode := nil;
  end;
  inherited;
end;

function TidTlLocatorNode.GetAsText: string;
var
  node: TidTlLocatorNode;
begin
  result:= '';
  node:= self;
  while assigned( node ) do begin
    if result <> '' then result:= '.' + Result;
    result:= node.NodeName + result;
    node:= node.PrevNode;
  end;

end;

{ TidTlCustomDataProvider }

procedure TidTlCustomDataProvider.AttachTranslator(ATranslator: TObject);
begin
  if FAttachedTranslators.IndexOf(ATranslator) = -1 then
    FAttachedTranslators.Add(ATranslator);
end;

constructor TidTlCustomDataProvider.Create(AOwner: TComponent);
begin
  inherited;
  FAttachedTranslators := TList.Create;
  FDefaultLanguage := 'EN';
end;

destructor TidTlCustomDataProvider.Destroy;
var
  i : integer;
begin
  if assigned(FAttachedTranslators) then begin
    if FAttachedTranslators.Count > 0 then
      for i := pred(FAttachedTranslators.Count) downto 0 do
        TidTranslator(FAttachedTranslators[i]).DataProvider := nil;
    FreeAndNil(FAttachedTranslators);
  end;
  inherited;
end;

procedure TidTlCustomDataProvider.DetacheTranslator(ATranslator: TObject);
begin
  if FAttachedTranslators.IndexOf(ATranslator) > -1 then
    FAttachedTranslators.Remove(ATranslator);
end;

procedure TidTlCustomDataProvider.SetLanguage(const Value: string);
var
  i: integer;
begin
  if FLanguage <> Value then begin
    { Switch language }
    FLanguage := Value;

    { Notify all attached translators }
    if FAttachedTranslators.Count > 0 then
      for i := 0 to pred(FAttachedTranslators.Count) do
        TidTranslator(FAttachedTranslators[i]).DataProviderChangedData;
  end;
end;

{ TidTlXMLDataProvider }

end.
