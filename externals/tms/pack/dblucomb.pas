{***********************************************************************}
{ DB LOOKUP components : TDBLUEdit & TDBLUCombo                         }
{ for Delphi & C++Builder                                               }
{ version 1.2                                                           }
{                                                                       }
{ written by                                                            }
{  TMS Software                                                         }
{  copyright © 2000 - 2002                                              }
{  Email : info@tmssoftware.com                                         }
{  Web : http://www.tmssoftware.com                                     }
{                                                                       }
{ The source code is given as is. The author is not responsible         }
{ for any possible damage done due to the use of this code.             }
{ The component can be freely used in any application. The source       }
{ code remains property of the author and may not be distributed        }
{ freely as such.                                                       }
{***********************************************************************}

unit dblucomb;
                          
{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LuCombo, db, dbctrls;


type
  TLookupMode = (lmEdit,lmGoto);

  TDBLUCombo = class(TLUCombo)
  private
    { Private declarations }
    fDataLink: TFieldDataLink;
    fDataLookup: boolean;
    fLookupMode: TLookupMode;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure DataUpdate(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure ActiveChange(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMExit(var Message: TWMNoParams); message CM_EXIT;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure ResetMaxLength;
    procedure SetDataLookup(const Value: boolean);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure LoadLookup;
  public
    { Public declarations }
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;
    procedure Change; override;
    procedure Loaded; override;    
    {$IFDEF DELPHI4_LVL}
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    {$ENDIF}
  published
    { Published declarations }
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataLookup: boolean read fDataLookup write SetDataLookup;
    property LookUpMode: TLookUpMode read fLookupMode write fLookupMode;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;

  TDBLUEdit = class(TLUEdit)
  private
    { Private declarations }
    FDataLink: TFieldDataLink;
    fDataLookup: boolean;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure DataUpdate(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure ActiveChange(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMExit(var Message: TWMNoParams); message CM_EXIT;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure ResetMaxLength;
    procedure SetDataLookup(const Value: boolean);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure LoadLookup;
  public
    { Public declarations }
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;
    procedure Change; override;
    procedure Loaded; override;
    {$IFDEF DELPHI4_LVL}
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    {$ENDIF}
  published
    { Published declarations }
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataLookup: boolean read fDataLookup write SetDataLookup;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;


implementation

procedure TDBLUCombo.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString {$IFDEF DELPHI4_LVL}, ftWideString {$ENDIF} ]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

procedure TDBLUCombo.Change;
begin
  if fLookupMode = lmEdit then
   begin
    FDataLink.Edit;
    FDataLink.Modified;
    inherited;
   end
  else
   begin
    inherited;
    if (itemindex>=0) then
     begin
      if assigned(FDataLink.DataSet) then
         with FDataLink.DataSet do
          begin
           First;
           MoveBy(integer(self.Items.Objects[itemindex]));
          end;
     end;
   end;
end;

procedure TDBLUCombo.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;


procedure TDBLUCombo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBLUCombo.CMExit(var Message: TWMNoParams);
begin
 if not FDataLink.ReadOnly then
  begin
   try
      FDataLink.UpdateRecord;                          { tell data link to update database }
   except
      on Exception do SetFocus;                      { if it failed, don't let focus leave }
   end;
  end;
  inherited;
end;

procedure TDBLUCombo.CMEnter(var Message: TWMNoParams);
begin
 inherited;
 if FDataLink.CanModify then ReadOnly := False;
end;

constructor TDBLUCombo.Create(aOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := DataUpdate;
  FDataLink.OnActiveChange := ActiveChange;
end;

procedure TDBLUCombo.DataChange(Sender: TObject);
begin
 if assigned(FDataLink.Field) then
  self.Text:=FDataLink.Field.AsString;
end;

procedure TDBLUCombo.ActiveChange(Sender: TObject);
begin
  if Assigned(FDataLink.dataset) then
  begin
    //if not (csLoading in ComponentState) then LoadFromDatasource;
    if FDataLink.DataSet.Active and FDataLookup then LoadLookup;
  end;
end;

procedure TDBLUCombo.DataUpdate(Sender: TObject);
begin
 if assigned(FDataLink.Field) then
  FDataLink.Field.AsString := self.Text;
end;

destructor TDBLUCombo.Destroy;
begin
  FDataLink.Free;                                  { always destroy owned objects first... }
  inherited Destroy;
end;


function TDBLUCombo.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TDBLUCombo.GetDataSource: TDataSource;
begin
 Result := FDataLink.DataSource;
end;

function TDBLUCombo.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDBLUCombo.SetDataField(const Value: string);
begin
  if not (csDesigning in ComponentState) then ResetMaxLength;
  FDataLink.FieldName := Value;
end;

procedure TDBLUCombo.SetDataSource(const Value: TDataSource);
begin
 FDataLink.DataSource := Value;
end;

procedure TDBLUCombo.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TDBLUCombo.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TDBLUCombo.WMPaste(var Message: TMessage);
begin
  if not FDataLink.Readonly then
   begin
    FDataLink.Edit;
    inherited;
   end;
end;

procedure TDBLUCombo.WMUndo(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TDBLUCombo.KeyDown(var Key: Word; Shift: TShiftState);
begin

  if FDataLink.ReadOnly and (key=VK_DELETE) then key:=0;

  inherited KeyDown(Key, Shift);

  if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
    FDataLink.Edit;

end;

procedure TDBLUCombo.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);

  if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
    not FDataLink.Field.IsValidChar(Key) or (FDataLink.ReadOnly) then
  begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

end;

procedure TDBLUCombo.Loaded;
begin
  inherited Loaded;
  ResetMaxLength;
end;

{$IFDEF DELPHI4_LVL}
function TDBLUCombo.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TDBLUCombo.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;
{$ENDIF}

procedure TDBLUCombo.LoadLookup;
var
  cb: TBookMark;
  s: string;
  i: Integer;
begin
  if not assigned(FDatalink.Dataset) then
    Exit;

  FDataLink.DataSource.DataSet.DisableControls;

  Items.Clear;
  i:=0;

  with FDataLink.DataSource.DataSet do
  begin
    cb := GetBookMark;
    First;

    while not FDataLink.DataSource.DataSet.Eof do
    begin
      s := FDataLink.Field.AsString;
      if (Items.IndexOf(s) = -1) and (s <> '') then
        Items.AddObject(s,TObject(i));
      Next;
      inc(i);
    end;

    GotoBookMark(cb);
    FreeBookMark(cb);
  end;
  FDataLink.DataSource.DataSet.EnableControls;
end;

procedure TDBLUCombo.SetDataLookup(const Value: boolean);
begin
  FDataLookup := Value;
  if not (csLoading in ComponentState) and value then LoadLookup;
end;



{ TDBAdvEdit }


procedure TDBLUEdit.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString {$IFDEF DELPHI4_LVL}, ftWideString {$ENDIF} ]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

procedure TDBLUEdit.Change;
begin
  FDataLink.Modified;
  inherited;
end;

procedure TDBLUEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;


procedure TDBLUEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBLUEdit.CMExit(var Message: TWMNoParams);
begin
 if not FDataLink.ReadOnly then
  begin
   try
      FDataLink.UpdateRecord;                          { tell data link to update database }
   except
      on Exception do SetFocus;                      { if it failed, don't let focus leave }
   end;
  end;
  inherited;
end;

procedure TDBLUEdit.CMEnter(var Message: TWMNoParams);
begin
 inherited;
 if FDataLink.CanModify then inherited ReadOnly := False;
end;

constructor TDBLUEdit.Create(aOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := DataUpdate;
  FDataLink.OnActiveChange := ActiveChange;  
end;

procedure TDBLUEdit.DataChange(Sender: TObject);
begin
 if assigned(FDataLink.Field) then
  self.text:=FDataLink.Field.AsString;
end;

procedure TDBLUEdit.DataUpdate(Sender: TObject);
begin
 if assigned(FDataLink.Field) then
  FDataLink.Field.AsString := self.Text;
end;

destructor TDBLUEdit.Destroy;
begin
  FDataLink.Free;                                  { always destroy owned objects first... }
  inherited Destroy;
end;


function TDBLUEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TDBLUEdit.GetDataSource: TDataSource;
begin
 Result := FDataLink.DataSource;
end;

function TDBLUEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDBLUEdit.SetDataField(const Value: string);
begin
  if not (csDesigning in ComponentState) then ResetMaxLength;
  FDataLink.FieldName := Value;
end;

procedure TDBLUEdit.SetDataSource(const Value: TDataSource);
begin
 FDataLink.DataSource := Value;
end;

procedure TDBLUEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TDBLUEdit.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TDBLUEdit.WMPaste(var Message: TMessage);
begin
  if not FDataLink.Readonly then
   begin
    FDataLink.Edit;
    inherited;
   end;
end;

procedure TDBLUEdit.WMUndo(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TDBLUEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if FDataLink.ReadOnly and (key=VK_DELETE) then key:=0;
  inherited KeyDown(Key, Shift);
  if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
    FDataLink.Edit;
end;

procedure TDBLUEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
    not FDataLink.Field.IsValidChar(Key) or (FDataLink.ReadOnly) then
  begin
    MessageBeep(0);
    Key := #0;
  end;
  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;

end;

procedure TDBLUEdit.Loaded;
begin
  inherited Loaded;
  ResetMaxLength;
end;

procedure TDBLUEdit.ActiveChange(Sender: TObject);
begin
 if assigned(FDataLink.dataset) then
  begin
   if fDataLink.DataSet.Active and fDataLookup then LoadLookup else LookupItems.Clear;
  end;
end;

procedure TDBLUEdit.LoadLookup;
var
 cb:TBookMark;
 s:string;

begin
 if not assigned(fDatalink.Dataset) then exit;

 FDataLink.DataSource.DataSet.DisableControls;

 LookupItems.Clear;

 with FDataLink.DataSource.DataSet do
  begin
   cb:=GetBookMark;
   First;

   while not FDataLink.DataSource.DataSet.Eof do
    begin
     s:=FDataLink.Field.AsString;
     if (LookupItems.IndexOf(s)=-1) and (s<>'') then LookupItems.Add(s);
     Next;
    end;

   GotoBookMark(cb);
   FreeBookMark(cb);
  end;

 FDataLink.DataSource.DataSet.EnableControls;
end;

procedure TDBLUEdit.SetDataLookup(const Value: boolean);
begin
  fDataLookup := Value;
  if not (csLoading in ComponentState) and value then LoadLookup;
end;

{$IFDEF DELPHI4_LVL}
function TDBLUEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TDBLUEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;
{$ENDIF}



end.
