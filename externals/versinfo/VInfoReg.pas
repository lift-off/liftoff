unit VInfoReg;

interface

{$I DFS.INC}

{$IFDEF DFS_WIN32}
  {$R VERSINFO.RES}
{$ELSE}
  {$R VERSINFO.R16}
{$ENDIF}


procedure Register;

implementation

uses
  {$IFDEF DFS_NO_DSGNINTF}
  DesignIntf,
  DesignEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  VersInfo, DFSAbout, Classes, TypInfo, StdCtrls, Forms,
  {$IFDEF DFS_WIN32} ComCtrls, {$ELSE} Grids, {$ENDIF}
  {$IFDEF DFS_COMPILER_5_UP}
  Contnrs,
  {$ENDIF}
  Controls, Dialogs;

type
{--- Version editor -----------------------------------------------------------}
{ double click opens the filename edit dialog }
{ right click gives two options - show the resources in a grid now }
{ and edit the filename }
  TVersionEditor = class(TDefaultEditor)
    procedure Edit; override;
    {$IFDEF DFS_IPROPERTY}
    procedure EditProp(const Prop: IProperty);
    {$ELSE}
    procedure EditProp(Prop: TPropertyEditor);
    {$ENDIF}
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  private
    procedure ShowVersInfoForm(const Filename: string);
  end;

{--- filename property editor .. fileopen dialog box --------------------------}
  TVersionFilenameProperty = class (TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure TVersionFilenameProperty.Edit;
begin
  with TOpenDialog.Create(Application) do
  begin
    Filename := GetValue;
    Filter := 'Executables (*.exe)|*.exe|' +
              'Libraries (*.dll)|*.dll|' +
              'Packages (*.dpl)|*.dpl|' +
              'Drivers (*.drv,*.386,*.vxd)|*.drv;*.386;*.vxd|' +
              'Any file (*.*)|*.*';
    Options := Options + [ofPathMustExist, ofFileMustExist, ofHideReadOnly];
    try
      if Execute then
        SetValue(Filename)
    finally
      Free
    end
  end
end;


function TVersionFilenameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog {$IFDEF DFS_WIN32}, paRevertable {$ENDIF}]
end;

procedure TVersionEditor.Edit;
var
  {$IFDEF DFS_DESIGNERSELECTIONS}
  Components: IDesignerSelections;
  {$ELSE}
  {$IFDEF DFS_COMPILER_5_UP}
  Components: TDesignerSelectionList;
  {$ELSE}
  Components: TComponentList;
  {$ENDIF}
  {$ENDIF}
begin
  {$IFDEF DFS_DESIGNERSELECTIONS}
  Components := CreateSelectionList;
  {$ELSE}
  {$IFDEF DFS_COMPILER_5_UP}
  Components := TDesignerSelectionList.Create;
  {$ELSE}
  Components := TComponentList.Create;
  {$ENDIF}
  {$ENDIF}
  try
    Components.Add(Component);
    GetComponentProperties(Components, tkAny, Designer, EditProp)
  finally
    {$IFNDEF DFS_DESIGNERSELECTIONS}
  	Components.Free;
    {$ENDIF}
  end
end;

procedure TVersionEditor.EditProp(
  {$IFDEF DFS_IPROPERTY}
  const Prop: IProperty
  {$ELSE}
  Prop: TPropertyEditor
  {$ENDIF}
);
begin
  {$IFDEF DFS_IPROPERTY}
  Prop.Edit;
  Designer.Modified;
  {$ELSE}
  if Prop is TVersionFilenameProperty then
  begin
    TVersionFilenameProperty(Prop).Edit;
    Designer.Modified
  end
  {$ENDIF}
end;

procedure TVersionEditor.ShowVersInfoForm(const Filename: string);
var
  Frm: TForm;
  btnClose: TButton;
  VerInfo: TdfsVersionInfoResource;
  VersionDisplay: {$IFDEF DFS_WIN32} TListView {$ELSE} TStringGrid {$ENDIF};
begin
  Frm := TForm.Create(Application);
  try
    Frm.BorderStyle := bsDialog;
    Frm.Caption := 'Version Info';
    Frm.Position := poScreenCenter;
    Frm.SetBounds(0, 0, 384, 238);
    btnClose := TButton.Create(frm);
    btnClose.Parent := Frm;
    btnClose.SetBounds(147, 180, 80, 25);
    btnClose.Cancel := TRUE;
    btnClose.Caption := '&Close';
    btnClose.Default := True;
    btnClose.ModalResult := mrOK;
    VerInfo := TdfsVersionInfoResource.Create(Frm);
    VerInfo.Filename := Filename;

    {$IFDEF DFS_WIN32}
    VersionDisplay := TListView.Create(Frm);
    with VersionDisplay do
    begin
      Parent := Frm;
      Left := 8;
      Top := 8;
      Width := 358;
      Height := 164;
      ColumnClick := FALSE;
      with Columns.Add do
      begin
        Caption := 'Resource';
        Width := 85;
      end;
      with Columns.Add do
      begin
        Caption := 'Value';
        Width := 265;
      end;
      ReadOnly := True;
      TabOrder := 0;
      ViewStyle := vsReport;
    end;
    VerInfo.VersionListView := VersionDisplay;
    {$ELSE}
    VersionDisplay := TStringGrid.Create(Frm);
    with VersionDisplay do
    begin
      Parent := Frm;
      Left := 8;
      Top := 8;
      Width := 358;
      Height := 164;
      ColCount := 2;
      FixedCols := 0;
      FixedRows := 0;
      Options := [goDrawFocusSelected, goColSizing, goRowSelect];
      TabOrder := 0;
      ColWidths[0] := 85;
      ColWidths[1] := 265;
    end;
    VerInfo.VersionGrid := VersionDisplay;
    {$ENDIF}

    Frm.ShowModal;
  finally
    { Everything created above is owned by Frm, so it will free them. }
    Frm.Free;
  end;
end;

procedure TVersionEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0 : ShowVersInfoForm(TdfsVersionInfoResource(Component).Filename);
    1 : Edit;
  end
end;

function TVersionEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0 : Result := 'Show Version Info';
    1 : Result := 'Set Filename';
  end
end;

function TVersionEditor.GetVerbCount: Integer;
begin
  Result := 2
end;


procedure Register;
begin
  RegisterComponents('DFS', [TdfsVersionInfoResource]);
  RegisterPropertyEditor(TypeInfo(TVersionFilename), NIL, '',
     TVersionFilenameProperty);
  RegisterPropertyEditor(TypeInfo(string), TdfsVersionInfoResource, 'Version',
     TDFSVersionProperty);
  RegisterComponentEditor(TdfsVersionInfoResource, TVersionEditor);
end;

end.
