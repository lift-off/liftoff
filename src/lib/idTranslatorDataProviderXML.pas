unit idTranslatorDataProviderXML;

interface

uses
  classes, xmldoc, XMLIntf, idTranslatorDataProvider;

type

  { Specialiced translation data provider for use with XML files }
  TidTlXMLDataProvider = class(TidTlCustomDataProvider)
  private
    FXMLFileName: string;
    procedure SetXMLFileName(const Value: string);
  protected
    FXMLDoc: TXMLDocument;
    procedure CheckXMLDoc(WriteMode: boolean = false);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetPropTranslation(ALocatorNode: TidTlLocatorNode;
                                APropName: string): string; override;

    { Writer-Methods to generate default datafile }
    function WriteBegin: boolean; override;
    function WriteProperty(ALocatorNode: TidTlLocatorNode; APropName, APropValue: string): boolean; override;
    function WriteEnd: boolean; override;

  published
    property XMLFileName: string read FXMLFileName write SetXMLFileName;
  end;

procedure Register;

implementation

uses
  SysUtils, forms, idTranslator;

procedure Register;
begin
  RegisterComponents('iDev', [TidTlXMLDataProvider]);
end;

{ TidTlXMLDataProvider }

procedure TidTlXMLDataProvider.CheckXMLDoc(WriteMode: boolean = false);
begin
  if not assigned(FXMLDoc) then begin
    if XMLFileName = '' then
      raise Exception.CreateFmt('Translation Data Provider %s (%s) has no XML filename set yet!',
                                [Name, ClassName])
    else
    if  (not FileExists(XMLFileName))
    and (not WriteMode) then
      raise Exception.CreateFmt('Translation datafile %s does not exist!',
                                [XMLFileName])
    else begin
      try
        FXMLDoc := TXMLDocument.Create(Application);
        FXMLDoc.Options := [doNodeAutoIndent];
        FXMLDoc.ParseOptions := [poPreserveWhiteSpace];
        if FileExists(FXMLFileName) then
          FXMLDoc.LoadFromFile(FXMLFileName);
        FXMLDoc.Active := True;
        FXMLDoc.Encoding:= 'ISO-8859-1';
        if not assigned(FXMLDoc.DocumentElement) then
          FXMLDoc.DocumentElement := FXMLDoc.AddChild('TranslationDefs');

        if FXMLDoc.IsEmptyDoc then
          raise Exception.CreateFmt('Empty XML document can not be used for translation data provider (%s)!',
                                    [Name]);
      except
        if not assigned(FXMLDoc) then begin
          FXMLDoc := TXMLDocument.Create(Application);
          FXMLDoc.Options := [doNodeAutoIndent];
          FXMLDoc.ParseOptions := [poPreserveWhiteSpace];
          FXMLDoc.Active := True;
          if not assigned(FXMLDoc.DocumentElement) then
            FXMLDoc.DocumentElement := FXMLDoc.AddChild('TranslationDefs');
        end;
      end;
    end;
  end;
end;

constructor TidTlXMLDataProvider.Create(AOwner: TComponent);
begin
  inherited;
  FXMLDoc := nil;
end;

destructor TidTlXMLDataProvider.Destroy;
begin
  FXMLDoc := nil;  // assign nil because it is an interfaced class which get's freed automatically
  inherited;
end;

function TidTlXMLDataProvider.GetPropTranslation(
  ALocatorNode: TidTlLocatorNode; APropName: string): string;
var
  XMLNode,
  XMLNode2: IXMLNode;
  i: integer;

  function FindNode(AXMLNode: IXMLNode; ALocator: TidTlLocatorNode): IXMLNode;
  var
    CurNode: IXMLNode;
  begin
    CurNode := AXMLNode.ChildNodes.FindNode(ALocator.NodeName);
    if assigned(CurNode) then begin
      { Last locator node? }
      if not assigned(ALocator.NextNode) then
        result := CurNode
      else
        result := FindNode(CurNode, ALocator.NextNode);
    end;
  end;

begin
  result := '';
  CheckXMLDoc;

  try
    { Search the XML for the component }
    XMLNode := FindNode(FXMLDoc.DocumentElement, ALocatorNode.RootNode);

    {
    if not assigned(XMLNode) then
      raise Exception.Create('Unable to find XML node containing translation!');
    }

    if assigned(XMLNode) then begin

      { Search the XML for the property }
      XMLNode2 := nil;
      if XMLNode.ChildNodes.Count > 0 then
        for i := 0 to pred(XMLNode.ChildNodes.Count) do
          if UpperCase(XMLNode.ChildNodes[i].NodeName) = UpperCase(APropName) then
          begin
            XMLNode2 := XMLNode.ChildNodes[i];
            break;
          end;

      if assigned(XMLNode2) then begin

        { Search the XML for the language }
        if  (Language <> '')
        and (XMLNode2.ChildNodes.FindNode(Language) <> nil) then
          result := XMLNode2[Language]
        else
        if  (DefaultLanguage <> '')
        and (XMLNode2.ChildNodes.FindNode(DefaultLanguage) <> nil) then
          result := XMLNode2[DefaultLanguage];

      end;
    end;

  finally
  end;

end;

procedure TidTlXMLDataProvider.SetXMLFileName(const Value: string);
begin
  if FXMLFileName <> Value then begin
    FXMLFileName := Value;
    FreeAndNil(FXMLDoc);
  end;
end;

function TidTlXMLDataProvider.WriteBegin: boolean;
begin
  result := true;
end;

function TidTlXMLDataProvider.WriteEnd: boolean;
begin
  result := false;
  try
    FXMLDoc.SaveToFile(XMLFileName);
    result := true;
  except
  end;
end;

{$HINTS OFF}
function TidTlXMLDataProvider.WriteProperty(ALocatorNode: TidTlLocatorNode;
  APropName, APropValue: string): boolean;
var
  XMLNode,
  PropNode,
  LangNode: IXMLNode;

  { Generate a XML node as child of AXMLNode using name of AGenNode. If AGenNode
    has next locator's generate them too (recurivly). }
  function GenLocatorNode(AXMLNode: IXMLNode; AGenNode: TidTlLocatorNode): IXMLNode;
  var
    TmpNode: IXMLNode;
  begin
    TmpNode := AXMLNode.ChildNodes.FindNode(AGenNode.NodeName);
    if not assigned(TmpNode) then
      TmpNode := AXMLNode.AddChild(AGenNode.NodeName);
    if AGenNode.NextNode <> nil then
      result := GenLocatorNode(TmpNode, AGenNode.NextNode)
    else
      result := TmpNode;
  end;

begin
  result := false;

  CheckXMLDoc(true);

  { Make sure the node-tree exists }
  XMLNode := GenLocatorNode(FXMLDoc.DocumentElement, ALocatorNode.RootNode);
  assert(assigned(XMLNode));

  { Generate PropertyNode }
  PropNode := XMLNode.ChildNodes.FindNode(APropName);
  if not assigned(PropNode) then
    PropNode := XmlNode.AddChild(APropName);

  { Generate Language subnode }
  LangNode := PropNode.ChildNodes.FindNode(DefaultLanguage);
  if not assigned(LangNode) then
    LangNode := PropNode.AddChild(DefaultLanguage);

  { Set property value (text) of language specific node }
  LangNode.NodeValue := APropValue;

  result := true;
end;
{$HINTS ON}

end.
end.
