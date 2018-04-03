
{**************************************************************************************************}
{                                                                                                  }
{                                     Delphi XML Data Binding                                      }
{                                                                                                  }
{         Generated on: 10.11.2002 14:57:57                                                        }
{       Generated from: C:\documents\development\delphi\d6\projects\aerodesgn\modelle\muster.xml   }
{   Settings stored in: C:\documents\development\delphi\d6\projects\aerodesgn\modell.xdb           }
{                                                                                                  }
{**************************************************************************************************}
unit xb_modell;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLModellType = interface;
  IXMLVariantenType = interface;
  IXMLVarianteType = interface;

{ IXMLModellType }

  IXMLModellType = interface(IXMLNode)
    ['{8D440CEF-D84C-4A4B-A71E-DD4DDE534D28}']
    { Property Accessors }
    function Get_Description: WideString;
    function Get_Varianten: IXMLVariantenType;
    procedure Set_Description(Value: WideString);
    { Methods & Properties }
    property Description: WideString read Get_Description write Set_Description;
    property Varianten: IXMLVariantenType read Get_Varianten;
  end;

{ IXMLVariantenType }

  IXMLVariantenType = interface(IXMLNodeCollection)
    ['{DFD00F25-A378-4A48-89E1-C206A189C66B}']
    { Property Accessors }
    function Get_Variante(Index: Integer): IXMLVarianteType;
    { Methods & Properties }
    function Add: IXMLVarianteType;
    function Insert(const Index: Integer): IXMLVarianteType;
    property Variante[Index: Integer]: IXMLVarianteType read Get_Variante; default;
  end;

{ IXMLVarianteType }

  IXMLVarianteType = interface(IXMLNode)
    ['{58656428-A4FF-45AA-92B9-F043646F4BB4}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_ProfilInnen: WideString;
    function Get_ProfilAussen: WideString;
    function Get_Spannweite: Integer;
    function Get_Flaechenbelastung: Integer;
    function Get_Wurzeltiefe: Integer;
    function Get_LageTrapezstoss: Integer;
    function Get_TiefeTrapezstoss: Integer;
    function Get_TiefeRandbogen: Integer;
    function Get_Leitwerkshebel: WideString;
    function Get_Stabilitaetsmass: WideString;
    function Get_Schwerpunkt: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_ProfilInnen(Value: WideString);
    procedure Set_ProfilAussen(Value: WideString);
    procedure Set_Spannweite(Value: Integer);
    procedure Set_Flaechenbelastung(Value: Integer);
    procedure Set_Wurzeltiefe(Value: Integer);
    procedure Set_LageTrapezstoss(Value: Integer);
    procedure Set_TiefeTrapezstoss(Value: Integer);
    procedure Set_TiefeRandbogen(Value: Integer);
    procedure Set_Leitwerkshebel(Value: WideString);
    procedure Set_Stabilitaetsmass(Value: WideString);
    procedure Set_Schwerpunkt(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property ProfilInnen: WideString read Get_ProfilInnen write Set_ProfilInnen;
    property ProfilAussen: WideString read Get_ProfilAussen write Set_ProfilAussen;
    property Spannweite: Integer read Get_Spannweite write Set_Spannweite;
    property Flaechenbelastung: Integer read Get_Flaechenbelastung write Set_Flaechenbelastung;
    property Wurzeltiefe: Integer read Get_Wurzeltiefe write Set_Wurzeltiefe;
    property LageTrapezstoss: Integer read Get_LageTrapezstoss write Set_LageTrapezstoss;
    property TiefeTrapezstoss: Integer read Get_TiefeTrapezstoss write Set_TiefeTrapezstoss;
    property TiefeRandbogen: Integer read Get_TiefeRandbogen write Set_TiefeRandbogen;
    property Leitwerkshebel: WideString read Get_Leitwerkshebel write Set_Leitwerkshebel;
    property Stabilitaetsmass: WideString read Get_Stabilitaetsmass write Set_Stabilitaetsmass;
    property Schwerpunkt: WideString read Get_Schwerpunkt write Set_Schwerpunkt;
  end;

{ Forward Decls }

  TXMLModellType = class;
  TXMLVariantenType = class;
  TXMLVarianteType = class;

{ TXMLModellType }

  TXMLModellType = class(TXMLNode, IXMLModellType)
  protected
    { IXMLModellType }
    function Get_Description: WideString;
    function Get_Varianten: IXMLVariantenType;
    procedure Set_Description(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLVariantenType }

  TXMLVariantenType = class(TXMLNodeCollection, IXMLVariantenType)
  protected
    { IXMLVariantenType }
    function Get_Variante(Index: Integer): IXMLVarianteType;
    function Add: IXMLVarianteType;
    function Insert(const Index: Integer): IXMLVarianteType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLVarianteType }

  TXMLVarianteType = class(TXMLNode, IXMLVarianteType)
  protected
    { IXMLVarianteType }
    function Get_Name: WideString;
    function Get_ProfilInnen: WideString;
    function Get_ProfilAussen: WideString;
    function Get_Spannweite: Integer;
    function Get_Flaechenbelastung: Integer;
    function Get_Wurzeltiefe: Integer;
    function Get_LageTrapezstoss: Integer;
    function Get_TiefeTrapezstoss: Integer;
    function Get_TiefeRandbogen: Integer;
    function Get_Leitwerkshebel: WideString;
    function Get_Stabilitaetsmass: WideString;
    function Get_Schwerpunkt: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_ProfilInnen(Value: WideString);
    procedure Set_ProfilAussen(Value: WideString);
    procedure Set_Spannweite(Value: Integer);
    procedure Set_Flaechenbelastung(Value: Integer);
    procedure Set_Wurzeltiefe(Value: Integer);
    procedure Set_LageTrapezstoss(Value: Integer);
    procedure Set_TiefeTrapezstoss(Value: Integer);
    procedure Set_TiefeRandbogen(Value: Integer);
    procedure Set_Leitwerkshebel(Value: WideString);
    procedure Set_Stabilitaetsmass(Value: WideString);
    procedure Set_Schwerpunkt(Value: WideString);
  end;

{ Global Functions }

function Getmodell(Doc: IXMLDocument): IXMLModellType;
function Loadmodell(const FileName: WideString): IXMLModellType;
function Newmodell: IXMLModellType;

implementation

{ Global Functions }

function Getmodell(Doc: IXMLDocument): IXMLModellType;
begin
  Result := Doc.GetDocBinding('modell', TXMLModellType) as IXMLModellType;
end;
function Loadmodell(const FileName: WideString): IXMLModellType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('modell', TXMLModellType) as IXMLModellType;
end;

function Newmodell: IXMLModellType;
begin
  Result := NewXMLDocument.GetDocBinding('modell', TXMLModellType) as IXMLModellType;
end;

{ TXMLModellType }

procedure TXMLModellType.AfterConstruction;
begin
  RegisterChildNode('varianten', TXMLVariantenType);
  inherited;
end;

function TXMLModellType.Get_Description: WideString;
begin
  Result := ChildNodes['description'].Text;
end;

procedure TXMLModellType.Set_Description(Value: WideString);
begin
  ChildNodes['description'].NodeValue := Value;
end;

function TXMLModellType.Get_Varianten: IXMLVariantenType;
begin
  Result := ChildNodes['varianten'] as IXMLVariantenType;
end;

{ TXMLVariantenType }

procedure TXMLVariantenType.AfterConstruction;
begin
  RegisterChildNode('variante', TXMLVarianteType);
  ItemTag := 'variante';
  ItemInterface := IXMLVarianteType;
  inherited;
end;

function TXMLVariantenType.Get_Variante(Index: Integer): IXMLVarianteType;
begin
  Result := List[Index] as IXMLVarianteType;
end;

function TXMLVariantenType.Add: IXMLVarianteType;
begin
  Result := AddItem(-1) as IXMLVarianteType;
end;

function TXMLVariantenType.Insert(const Index: Integer): IXMLVarianteType;
begin
  Result := AddItem(Index) as IXMLVarianteType;
end;


{ TXMLVarianteType }

function TXMLVarianteType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLVarianteType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLVarianteType.Get_ProfilInnen: WideString;
begin
  Result := ChildNodes['ProfilInnen'].Text;
end;

procedure TXMLVarianteType.Set_ProfilInnen(Value: WideString);
begin
  ChildNodes['ProfilInnen'].NodeValue := Value;
end;

function TXMLVarianteType.Get_ProfilAussen: WideString;
begin
  Result := ChildNodes['ProfilAussen'].Text;
end;

procedure TXMLVarianteType.Set_ProfilAussen(Value: WideString);
begin
  ChildNodes['ProfilAussen'].NodeValue := Value;
end;

function TXMLVarianteType.Get_Spannweite: Integer;
begin
  Result := ChildNodes['Spannweite'].NodeValue;
end;

procedure TXMLVarianteType.Set_Spannweite(Value: Integer);
begin
  ChildNodes['Spannweite'].NodeValue := Value;
end;

function TXMLVarianteType.Get_Flaechenbelastung: Integer;
begin
  Result := ChildNodes['Flaechenbelastung'].NodeValue;
end;

procedure TXMLVarianteType.Set_Flaechenbelastung(Value: Integer);
begin
  ChildNodes['Flaechenbelastung'].NodeValue := Value;
end;

function TXMLVarianteType.Get_Wurzeltiefe: Integer;
begin
  Result := ChildNodes['Wurzeltiefe'].NodeValue;
end;

procedure TXMLVarianteType.Set_Wurzeltiefe(Value: Integer);
begin
  ChildNodes['Wurzeltiefe'].NodeValue := Value;
end;

function TXMLVarianteType.Get_LageTrapezstoss: Integer;
begin
  Result := ChildNodes['LageTrapezstoss'].NodeValue;
end;

procedure TXMLVarianteType.Set_LageTrapezstoss(Value: Integer);
begin
  ChildNodes['LageTrapezstoss'].NodeValue := Value;
end;

function TXMLVarianteType.Get_TiefeTrapezstoss: Integer;
begin
  Result := ChildNodes['TiefeTrapezstoss'].NodeValue;
end;

procedure TXMLVarianteType.Set_TiefeTrapezstoss(Value: Integer);
begin
  ChildNodes['TiefeTrapezstoss'].NodeValue := Value;
end;

function TXMLVarianteType.Get_TiefeRandbogen: Integer;
begin
  Result := ChildNodes['TiefeRandbogen'].NodeValue;
end;

procedure TXMLVarianteType.Set_TiefeRandbogen(Value: Integer);
begin
  ChildNodes['TiefeRandbogen'].NodeValue := Value;
end;

function TXMLVarianteType.Get_Leitwerkshebel: WideString;
begin
  Result := ChildNodes['Leitwerkshebel'].Text;
end;

procedure TXMLVarianteType.Set_Leitwerkshebel(Value: WideString);
begin
  ChildNodes['Leitwerkshebel'].NodeValue := Value;
end;

function TXMLVarianteType.Get_Stabilitaetsmass: WideString;
begin
  Result := ChildNodes['Stabilitaetsmass'].Text;
end;

procedure TXMLVarianteType.Set_Stabilitaetsmass(Value: WideString);
begin
  ChildNodes['Stabilitaetsmass'].NodeValue := Value;
end;

function TXMLVarianteType.Get_Schwerpunkt: WideString;
begin
  Result := ChildNodes['Schwerpunkt'].Text;
end;

procedure TXMLVarianteType.Set_Schwerpunkt(Value: WideString);
begin
  ChildNodes['Schwerpunkt'].NodeValue := Value;
end;

end.
