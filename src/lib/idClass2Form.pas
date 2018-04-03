{-----------------------------------------------------------------------------
 Unit Name: idClass2Form
 Author:    marc
 Purpose:   Fills in a forms edit's from a classes published properties and
            vice versa.
 History:
-----------------------------------------------------------------------------}


unit idClass2Form;

interface

uses
  classes, sysutils, windows, forms, Controls;

type

  TidClass2FormAdapter = class
  private
  protected
    FForm: TCustomForm;
    FDataObject: TObject;
    FComponentPrefixes: TStringList;
    FComponentProperties: TStringList;
    procedure RegisterComponentPrefixes; virtual;
    procedure RegisterComponentProperties; virtual;
    function FindControlForProperty( APropertyName: string ): TControl; virtual;
    function CheckComponentName(AControlName, APropertyName: string): boolean; virtual;
    procedure StorePropertyToControl(AControl: TControl; APropertyName: string); virtual;
    procedure StoreControlToProperty(AControl: TControl; APropertyName: string); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure StoreObjectInForm;
    procedure StoreFormInObject;

    property Form: TCustomForm read FForm write FForm;
    property DataObject: TObject read FDataObject write FDataObject;
  end;


implementation

uses
  typinfo;

{ TidClass2FormAdapter }

constructor TidClass2FormAdapter.Create;
begin
  FComponentPrefixes:= TStringList.Create;
  FComponentProperties:= TStringList.Create;

  RegisterComponentPrefixes;
  RegisterComponentProperties;
end;

destructor TidClass2FormAdapter.Destroy;
begin
  FreeAndNil( FComponentPrefixes );
  FreeAndNil( FComponentProperties );
  inherited;
end;

procedure TidClass2FormAdapter.RegisterComponentPrefixes;
begin
  with FComponentPrefixes do begin
    Add( 'edt' );    // edit
    Add( 'ed' );     // edit
    Add( 'cb' );     // checkbox
    Add( 'rb' );     // radiobox
    Add( 'mem' );    // memo
  end;
end;

procedure TidClass2FormAdapter.RegisterComponentProperties;
begin
  with FComponentProperties do begin
    Values['TEdit']:= 'Text';
    Values['TCheckbox']:= 'Checked';
    Values['TCombobox']:= 'ItemIndex';
    Values['TUpDown']:= 'Position';
    Values['TTrackBar']:= 'Position';
  end;
end;

function TidClass2FormAdapter.CheckComponentName( AControlName, APropertyName: string): boolean;
var
  iPrefix: Integer;
begin
  AControlName:= LowerCase( AControlName );
  APropertyName:= LowerCase( APropertyName );

  // 1:1
  result:= AControlName = APropertyName;

  if not result then begin
    // if it wasn't found yet try comparing names with prefixes
    if FComponentPrefixes.Count > 0 then begin
      for iPrefix:= 0 to pred( FComponentPrefixes.Count ) do begin
        if FComponentPrefixes[iPrefix] + APropertyName = AControlName then begin
          result:= true;
          break;
        end;
      end;
    end;
  end;

end;

function TidClass2FormAdapter.FindControlForProperty(
  APropertyName: string): TControl;

  function ScanControl( AControl: TControl ): TControl;
  var
    iComponent: Integer;
  begin
    result:= nil;

    if AControl.ComponentCount > 0 then begin
      for iComponent:= 0 to pred( AControl.ComponentCount ) do begin
        if CheckComponentName( AControl.Components[iComponent].Name, APropertyname ) then begin
          result:= AControl.Components[iComponent] as TControl;
          break;
        end else begin
          if AControl.Components[iComponent] is TControl then
            ScanControl( AControl.Components[iComponent] as TControl );
        end;
      end;
    end;
  end;

begin
  result:= ScanControl( Form as TControl );
end;

procedure TidClass2FormAdapter.StorePropertyToControl(AControl: TControl;
  APropertyName: string);
var
  iComponentPropReg: integer;
  className,
  propertyName: string;
begin
  assert( assigned( AControl ), 'Parameter AControl not assigned yet!' );

  if FComponentProperties.Count > 0 then begin
    for iComponentPropReg:= pred( FComponentProperties.Count ) downto 0 do begin
      className:= FComponentProperties.Names[ iComponentPropReg ];

      if AControl.ClassNameIs( className ) then begin
        propertyName:= FComponentProperties.Values[ className ];
        SetPropValue( AControl, propertyName, GetPropValue(DataObject, APropertyName) );
      end;

    end;
  end;
end;

procedure TidClass2FormAdapter.StoreControlToProperty(AControl: TControl;
  APropertyName: string);
var
  iComponentPropReg: integer;
  className,
  propertyName: string;
begin
  assert( assigned( AControl ), 'Parameter AControl not assigned yet!' );

  if FComponentProperties.Count > 0 then begin
    for iComponentPropReg:= pred( FComponentProperties.Count ) downto 0 do begin
      className:= FComponentProperties.Names[ iComponentPropReg ];

      if AControl.ClassNameIs( className ) then begin
        propertyName:= FComponentProperties.Values[ className ];
        SetPropValue( DataObject, APropertyName, GetPropValue(AControl, propertyName) );
      end;

    end;
  end;
end;

procedure TidClass2FormAdapter.StoreFormInObject;
var
  control: TControl;
  propertyName: string;
  iProperty: Integer;
  propertyCount: Integer;
  propertyList: PPropList;
begin
  assert( assigned(DataObject), 'TidClass2FormAdapter: property DataObject needs to be assigned!' );
  assert( assigned(Form), 'TidClass2FormAdapter: property Form needs to be assigned!' );

  propertyCount:= GetPropList( DataObject, propertyList );

  if propertyCount > 0 then begin
    for iProperty:= 0 to pred( propertyCount ) do begin
      propertyName:= propertyList^[iProperty].Name;
      control:= FindControlForProperty( propertyName );
      if assigned( control ) then begin
        StoreControlToProperty( control, propertyName );
      end;
    end;
  end;

end;

procedure TidClass2FormAdapter.StoreObjectInForm;
var
  control: TControl;
  propertyName: string;
  iProperty: Integer;
  propertyCount: Integer;
  propertyList: PPropList;
begin
  assert( assigned(DataObject), 'TidClass2FormAdapter: property DataObject needs to be assigned!' );
  assert( assigned(Form), 'TidClass2FormAdapter: property Form needs to be assigned!' );

  propertyCount:= GetPropList( DataObject, propertyList );

  if propertyCount > 0 then begin
    for iProperty:= 0 to pred( propertyCount ) do begin
      propertyName:= propertyList^[iProperty].Name;
      control:= FindControlForProperty( propertyName );
      if assigned( control ) then begin
        StorePropertyToControl( control, propertyName );
      end;
    end;
  end;

end;

end.
