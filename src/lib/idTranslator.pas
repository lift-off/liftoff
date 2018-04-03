{ Copyright iDev.ch in 2003

  Component:    TidTranslator
  Purpose:      Translating component-hierarchy at the fly using XML message files
  Autor:        Marc Dürst (marc@idev.ch)
  Date:         28.03.2003

  Revisions:
  28.03.2003 Marc    - Initial release

  How to use:

  1) Place a descendant of TidTlDataProvider (eg. TidTlXMLDataProvider on a
     form or a data module or create it at runtime.

  2) Set the property XMLFileanem to the filename of the XML file containing
     the translations. Set also the properties DefaultLanguage and Language to
     the prefered languages. Note that languages are just text strings used as
     an idea. You can use whatever you like.

  3) Place a TidTranslator on the form (one per form) and assign the property
     DataProvider to the TidTlDataProvider you'd like to use for this
     Translator.

  4) To get a default of the translation data (eg. XML file) use the method
     TidTranslator.WriteDefaultTranslationData().

  5) Add the Translations to the (XML-) datafile.

  6) When the translator should switch the language just set the property
     TidTlDataProvider.Language to the value of the new language.

  7) To get translated literal texts use the method TidTranslator.GetLit() or
     TidTranslator.GetLitDef().

  8) If you like to be informed when translation of components did happen attach
     the OnTranslate event of TidTranslator. Within this event you can eg. update
     other things using the GetLit() and GetLitDef() methods.

  9) To register other standard properties use the global function
     RegisterStandardPropertiesForTranslation(). Standard properties translated
     on every component if the component have thouse properties.

  10)To register other classes and their translatable properties use the
     global function RegisterClassForTranslation(). This may be usefull for
     special / custom classes which do not get translated else.

  See the sample application for more details.

  Known limitations:
  - TRadioGroupBox does not get translated automatically but needs to be done
    manually using the OnTranslate-Event

}

unit idTranslator;

interface

{$R idTranslator.dcr}

uses
  Classes, idTranslatorDataProvider;

type

  TidTranslator = class(TComponent)
  private
    { Private declarations }
    FDataProvider: TidTlCustomDataProvider;
    FOnTranslate: TNotifyEvent;
    procedure SetDataProvider(const Value: TidTlCustomDataProvider);
  protected
    { Protected declarations }
    procedure DoTranslateComponent(AComponent: TComponent;
                                   APrevLocatorNode, ARootLocatorNode: TidTlLocatorNode;
                                   WriteMode: boolean = false); virtual;
    procedure DoTranslate(WriteMode: boolean = false); virtual;
    procedure DoDataProviderChangedData; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RefreshTranslation; virtual;

    { Functions to get literal texts out of the translation data }
    function GetLit(const ATextID: string): string;
    function GetLitDef(const ATextID: string; ADefaultValue: string): string;

    { Use this method to write a default translation file using the currently
      attached Data-Provider. eg. Write the default XML translation file }
    procedure WriteDefaultTranslationData;

    { INTERNAL ONLY: Just needed by the DataProvider's - should not be called manually }
    procedure DataProviderChangedData;
  published
    { Published declarations }
    property DataProvider: TidTlCustomDataProvider read FDataProvider write SetDataProvider;
    property OnTranslate: TNotifyEvent read FOnTranslate write FOnTranslate;
  end;

procedure Register;

{ Register a class and it's translatable properties if it get's not
  translated by default. }
procedure RegisterClassForTranslation(AClassName: string;
                                      APropertyNamesToBeTranslated: array of string);
{ Register a standard-property which should get translated in every component
  it will be found in }
procedure RegisterStandardPropertiesForTranslation(APropName: string);

implementation

uses
  SysUtils, TypInfo, Dialogs, Controls,
  id_String;

type

  TidTlClassRegister = class;

  TidTlClass = class
  private
    FNameOfClass: string;
    FPropertyNames: TStringList;
  protected
  public
    constructor Create(AOwner: TidTlClassRegister); virtual;
    destructor Destroy; override;

    property NameOfClass: string read FNameOfClass write FNameOfClass;
    property PropertyNames: TStringList read FPropertyNames write FPropertyNames;
  end;

  { Class registration containing all known classes for translation. It is
    implemented as a singelton. }
  TidTlClassRegister = class
  private
    FLastFoundClassName: string;
    FLastFoundIndex: integer;
    FStandardPropsToTranslate: TStringList;
    function GetClassByName(AClassName: string): TidTlClass;
    procedure InternalRegisterStdProps;
  protected
    FClassList: TList;

    constructor Create; virtual;
    function IsTranslatable(AObject: TObject; APropertyName: string): boolean;
    property ClassByName[AClassName: string]: TidTlClass read GetClassByName;
  public
    destructor Destroy; override;

    class function Instance: TidTlClassRegister;

    procedure RegisterClass(AClassName: string;
                            APropertyNamesToBeTranslated: array of string); virtual;
    procedure RegisterStandardProperties(APropName: string);

    function GetTranslatableMethodsOf(AObject: TObject): TStringList;
  end;

var
  idTlClassRegisterSingelton: TidTlClassRegister = nil;

procedure Register;
begin
  RegisterComponents('iDev', [TidTranslator]);
end;

procedure RegisterClassForTranslation(AClassName: string;
  APropertyNamesToBeTranslated: array of string);
begin
  TidTlClassRegister.Instance.RegisterClass(AClassName, APropertyNamesToBeTranslated);
end;

procedure RegisterStandardPropertiesForTranslation(APropName: string);
begin
  TidTlClassRegister.Instance.RegisterStandardProperties(APropName);
end;

{ TidTlClass }

constructor TidTlClass.Create(AOwner: TidTlClassRegister);
begin
  FNameOfClass := '';
  FPropertyNames := TStringList.Create;
end;

destructor TidTlClass.Destroy;
begin
  FreeAndNil(FPropertyNames);
  inherited;
end;

{ TidTlClassRegister }

constructor TidTlClassRegister.Create;
begin
  inherited;
  FClassList := TList.Create;
  FStandardPropsToTranslate := TStringList.Create;
  FLastFoundClassName := '';
  FLastFoundIndex := -1;

  InternalRegisterStdProps; // Register standard properties for unknown classes
end;

destructor TidTlClassRegister.Destroy;
var
  i : integer;
begin
  if assigned(FClassList) then begin
    { Free all items }
    if FClassList.Count > 0 then
      for i := pred(FClassList.Count) downto 0 do begin
        TidTlClass(FClassList.Items[i]).Free;
        FClassList.Delete(i);
      end;

    FreeAndNil(FClassList);
  end;

  FreeAndNil(FStandardPropsToTranslate);

  inherited;
end;

function TidTlClassRegister.GetClassByName(AClassName: string): TidTlClass;
var
  i : integer;
begin
  assert(AClassName <> '', 'Empty classname not allowed!');
  result := nil;

  { Try to use the caching before searching from scratch again }
  if  (FLastFoundClassName = AClassName)
  and (FLastFoundIndex > -1)
  and (FLastFoundIndex < FClassList.Count)
  and (FLastFoundClassName = TidTlClass(FClassList[FLastFoundIndex]).NameOfClass) then begin
    result := TidTlClass(FClassList[FLastFoundIndex]);
  end;

  { Classindex not in cache => search the list and update cache }
  if not assigned(result) then begin
    if FClassList.Count > 0 then
      for i := 0 to pred(FClassList.Count) do
        if TidTlClass(FClassList[i]).NameOfClass = AClassName then begin
          result := TidTlClass(FClassList[i]);

          { Update the cache }
          FLastFoundClassName := AClassName;
          FLastFoundIndex := i;

          { Break the loop to avoid performance leek }
          break;
        end;

  end;
end;

function TidTlClassRegister.GetTranslatableMethodsOf(
  AObject: TObject): TStringList;
var
  TlClass: TidTlClass;
  i: integer;
begin
  result:= TStringList.Create;

  { Get class from translation class registry }
  TlClass:= ClassByName[AObject.ClassName];

  { If found in registry add all translatable properties to the result }
  if assigned(TlClass) then begin
    if TlClass.PropertyNames.Count > 0 then
      for i := 0 to pred(TlClass.PropertyNames.Count) do
        { Check to add no dublicate propertynames to optimize performace later on }
        if Result.IndexOf(TlClass.PropertyNames[i]) = -1 then
          result.Add(TlClass.PropertyNames[i]);
  end;

  { Add any missing translatable standard property to the result }
  if FStandardPropsToTranslate.Count > 0 then
    for i := 0 to pred(FStandardPropsToTranslate.Count) do
      if Result.IndexOf(FStandardPropsToTranslate[i]) = -1 then
        result.Add(FStandardPropsToTranslate[i]);
end;

class function TidTlClassRegister.Instance: TidTlClassRegister;
begin
  if not assigned(idTlClassRegisterSingelton) then begin
    idTlClassRegisterSingelton:= TidTlClassRegister.Create;
  end;
  result:= idTlClassRegisterSingelton;
end;

procedure TidTlClassRegister.InternalRegisterStdProps;
begin
  RegisterStandardProperties('Caption');
  RegisterStandardProperties('Hint');
end;

function TidTlClassRegister.IsTranslatable(AObject: TObject;
  APropertyName: string): boolean;
var
  i : integer;
begin
  result := false;

  { Search the standard properties first to optimize performance }
  if FStandardPropsToTranslate.IndexOf(APropertyName) > -1 then
    result := true
  else begin
    { If it is not a standard property then search the list of known classes
      for that particilar class ... }
    if FClassList.Count > 0 then
      for i := 0 to pred(FClassList.Count) do
        if AObject.ClassNameIs(TidTlClass(FClassList[i]).NameOfClass) then begin
          result := true;
          break;
        end;
        {TODO: Search the class hierarchy for known parent classes which have translation information }

  end;
end;

procedure TidTlClassRegister.RegisterClass(AClassName: string;
  APropertyNamesToBeTranslated: array of string);
var
  i : integer;
begin
  assert(AClassName <> '', 'Empty classname not allowed!');

  { Create new class item in class registry }
  with TidTlClass.Create(self) do begin

    { Set classname which is to be translated }
    NameOfClass := AClassName;

    { Set all property names of above class }
    if Length(APropertyNamesToBeTranslated) > 0 then
      for i := Low(APropertyNamesToBeTranslated) to High(APropertyNamesToBeTranslated) do
        PropertyNames.Add(APropertyNamesToBeTranslated[i]);

  end;
end;

procedure TidTlClassRegister.RegisterStandardProperties(APropName: string);
begin
  assert(APropName <> '', 'Empty property name not allowed!');
  FStandardPropsToTranslate.Add(APropName);
end;

{ TidTranslator }

constructor TidTranslator.Create(AOwner: TComponent);
begin
  inherited;
  FDataProvider := nil;
end;

destructor TidTranslator.Destroy;
begin
  if assigned( DataProvider ) then begin
    DataProvider.DetacheTranslator( self );
  end;
  FDataProvider := nil;
  inherited;
end;

procedure TidTranslator.DoTranslateComponent(AComponent: TComponent;
  APrevLocatorNode, ARootLocatorNode: TidTlLocatorNode; WriteMode: boolean = false);
var
  i: integer;
  LocatorNode: TidTlLocatorNode;
  TransProps: TStringList;
  TransPropValue: string;
begin
  assert(assigned(AComponent), 'AComponent needs to be a valid component instance and can not be NIL!');
  TransProps := nil;

  if AComponent.Name = '' then exit;

  LocatorNode := TidTlLocatorNode.Create(AComponent.Name, APrevLocatorNode, ARootLocatorNode);
  try
    { First translate the component itself using RTTI }
    TransProps := TidTlClassRegister.Instance.GetTranslatableMethodsOf(Self);
    if TransProps.Count > 0 then
      for i := 0 to pred(TransProps.Count) do begin

        { Is the method available in that component as published property? }
        if IsPublishedProp(AComponent, TransProps[i]) then begin

          if not WriteMode then begin
            { If it is not WriteMode (default) read the data from the
              data-provider and set the propertyvalue to that value }
            TransPropValue := DataProvider.GetPropTranslation(LocatorNode, TransProps[i]);
            if TransPropValue <> '' then
              SetPropValue(AComponent, TransProps[i], TransPropValue);
          end else begin
            { If we are in WriteMode the the things go the other way: read the
              propertyvalue and write it to the data-provider }
            TransPropValue := GetPropValue(AComponent, TransProps[i], true);
            if TransPropValue <> '' then
              DataProvider.WriteProperty(LocatorNode, TransProps[i], TransPropValue);
          end;

        end;

      end;

    { Set BiDi mode
      Badly Borland introduce the puiblished BiDi stuff in each and every component
      instead of the common base class. So we have to use RTTI to check and set
      these properties the generic way. Thanks Borland! }
    try
      if IsPublishedProp( AComponent, 'ParentBiDiMode' ) then begin
        if not GetPropValue( AComponent, 'ParentBiDiMode', false ) then begin
          if IsPublishedProp( AComponent, 'BiDiMode' ) then begin
            SetPropValue( AComponent, 'BiDiMode', DataProvider.BiDiMode );
          end;
        end;
      end;
    except
    end;

    { Now loop on all child components and translate them too }
    if AComponent.ComponentCount > 0 then
      for i := 0 to pred(AComponent.ComponentCount) do
        DoTranslateComponent(AComponent.Components[i], LocatorNode, ARootLocatorNode, WriteMode);

  finally
    FreeAndNil(TransProps);
    FreeAndNil(LocatorNode);
  end;

end;

procedure TidTranslator.DoTranslate(WriteMode: boolean = false);
var
   RootNode,
   ComponentNode: TidTlLocatorNode;
begin
  assert(assigned(FDataProvider), 'No Data-Provider for translation set yet!');
  assert(assigned(Owner), 'Translator component currenty has no parent which is needed!');

  RootNode := nil;
  ComponentNode := nil;

  if WriteMode then DataProvider.WriteBegin;

  { Start translating from the parent of the component }
  try
    RootNode := TidTlLocatorNode.Create(Owner.Name +'.' + Name, nil, nil); // Create root locator
    ComponentNode := TidTlLocatorNode.Create('components', RootNode, RootNode); // Create root locator
    DoTranslateComponent(Owner, ComponentNode, RootNode, WriteMode); // Start translating on parent of the component
  finally
    { Do clean-up }
    FreeAndNil(ComponentNode);
    FreeAndNil(RootNode);
    if WriteMode then DataProvider.WriteEnd;
  end;

  if assigned(FOnTranslate) then FOnTranslate(self);

end;

procedure TidTranslator.RefreshTranslation;
begin
  DoTranslate;
end;

procedure TidTranslator.SetDataProvider(
  const Value: TidTlCustomDataProvider);
begin
  if FDataProvider <> Value then begin

    { Detach from old data provider }
    if assigned(FDataProvider) then
      FDataProvider.DetacheTranslator(self);

    { Assign new data provider }
    FDataProvider := Value;

    { Attach the new data provider }
    if assigned(FDataProvider) then
      FDataProvider.AttachTranslator(self);

  end;
end;

procedure TidTranslator.DataProviderChangedData;
begin
  DoDataProviderChangedData;
end;

procedure TidTranslator.DoDataProviderChangedData;
begin
  RefreshTranslation;
end;

procedure TidTranslator.WriteDefaultTranslationData;
begin
  DoTranslate(true);
end;

function TidTranslator.GetLit(const ATextID: string): string;
var
  RootNode,
  LitNode: TidTlLocatorNode;
begin
  result := '';

  assert(assigned(FDataProvider), 'No Data-Provider for translation set yet!');
  assert(assigned(Owner), 'Translator component currenty has no parent which is needed!');
  assert(ATextID <> '', 'Empty TextID not allowed!');

  RootNode := nil;
  LitNode := nil;

  { Start translating from the parent of the component }
  try
    RootNode := TidTlLocatorNode.Create(Owner.Name +'.' + Name, nil, nil); // Create root locator
    LitNode := TidTlLocatorNode.Create('literals', RootNode, RootNode); // Create root locator

    result := DataProvider.GetPropTranslation(LitNode, ATextID);
    result:= ReplaceStr( result, '#13', #13 );
    result:= ReplaceStr( result, '#10', #10);

  finally
    { Do clean-up }
    FreeAndNil(LitNode);
    FreeAndNil(RootNode);
  end;
end;

function TidTranslator.GetLitDef(const ATextID: string;
  ADefaultValue: string): string;
begin
  result := GetLit(ATextID);
  if result = '' then
    result := ADefaultValue;
end;

end.
