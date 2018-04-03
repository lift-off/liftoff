{***********************************************************************}
{ TDBADVLUEDIT component                                                }
{ for Delphi 3.0,4.0,5.0,C++Builder 3.0,4.0,5.0,6.0                     }
{ version 1.1 - rel. Aug, 2002                                          }
{                                                                       }
{ written by TMS Software                                               }
{           copyright � 2000 - 2002                                     }
{           Email : info@tmssoftware.com                                }
{           Web : http://www.tmssoftware.com                            }
{                                                                       }
{ The source code is given as is. The author is not responsible         }
{ for any possible damage done due to the use of this code.             }
{ The component can be freely used in any application. The complete     }
{ source code remains property of the author and may not be distributed,}
{ published, given or sold in any form as such. No parts of the source  }
{ code can be included in any other component or application without    }
{ written authorization of the author.                                  }
{***********************************************************************}

unit dbadvle;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdvLuEd, db, dbctrls;

type
  TDBAdvLUEdit = class(TAdvLUEdit)
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
    procedure WMChar(var Message: TWMKeyDown); message WM_CHAR;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
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
    function EditCanModify: Boolean; virtual;    
  public
    { Public declarations }
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;
    {$IFDEF DELPHI4_LVL}
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    {$ENDIF}
    procedure Change; override;
    procedure Loaded; override;
  published
    { Published declarations }
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataLookup: boolean read fDataLookup write SetDataLookup;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;


implementation


{ TDBAdvEdit }


procedure TDBAdvLUEdit.ResetMaxLength;
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

procedure TDBAdvLUEdit.Change;
begin
  FDataLink.Modified;
  inherited;
end;

procedure TDBAdvLUEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;


procedure TDBAdvLUEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBAdvLUEdit.CMExit(var Message: TWMNoParams);
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

procedure TDBAdvLUEdit.CMEnter(var Message: TWMNoParams);
begin
 inherited;
 if FDataLink.CanModify then inherited ReadOnly := False;
end;

constructor TDBAdvLUEdit.Create(aOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := DataUpdate;
  FDataLink.OnActiveChange := ActiveChange;
end;

procedure TDBAdvLUEdit.DataChange(Sender: TObject);

begin
  if Assigned(FDataLink.Field) then
  begin
    MaxLength := FDataLink.Field.Size;
    self.Text := FDataLink.Field.AsString;
  end;
end;

procedure TDBAdvLUEdit.ActiveChange(Sender: TObject);
begin
 if assigned(FDataLink.dataset) then
  begin
   //if not (csLoading in ComponentState) then LoadFromDatasource;
   if fDataLink.DataSet.Active and fDataLookup then LoadLookup else LookupItems.Clear;
  end;
end;

procedure TDBAdvLUEdit.DataUpdate(Sender: TObject);
begin
 if assigned(FDataLink.Field) then
  FDataLink.Field.AsString := self.Text;
end;

destructor TDBAdvLUEdit.Destroy;
begin
  FDataLink.Free;                                  { always destroy owned objects first... }
  inherited Destroy;
end;


function TDBAdvLUEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TDBAdvLUEdit.GetDataSource: TDataSource;
begin
 Result := FDataLink.DataSource;
end;

function TDBAdvLUEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDBAdvLUEdit.SetDataField(const Value: string);
begin
  if not (csDesigning in ComponentState) then ResetMaxLength;
  FDataLink.FieldName := Value;
end;

procedure TDBAdvLUEdit.SetDataSource(const Value: TDataSource);
begin
 FDataLink.DataSource := Value;
end;

procedure TDBAdvLUEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TDBAdvLUEdit.WMCut(var Message: TMessage);
begin
  if FDataLink.Edit then
    inherited;
end;

procedure TDBAdvLUEdit.WMPaste(var Message: TMessage);
begin
  if not FDataLink.Readonly then
   begin
    if FDataLink.Edit then
      inherited;
   end;
end;

procedure TDBAdvLUEdit.WMChar(var Message: TWMChar);
begin
  if not EditCanModify then
  begin
    Message.Result := 1;
    Message.CharCode := 0;
  end;
  inherited;
end;

procedure TDBAdvLUEdit.WMKeyDown(var Message: TWMKeyDown);
begin
  if not EditCanModify then
  begin
    Message.Result := 1;
    Message.CharCode := 0;
  end;
  inherited;
end;

procedure TDBAdvLUEdit.WMUndo(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TDBAdvLUEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if FDataLink.ReadOnly and (key=VK_DELETE) then key:=0;
  inherited KeyDown(Key, Shift);
  if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
    FDataLink.Edit;
end;

procedure TDBAdvLUEdit.KeyPress(var Key: Char);
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

procedure TDBAdvLUEdit.Loaded;
begin
  inherited Loaded;
  ResetMaxLength;
end;


{$IFDEF DELPHI4_LVL}
function TDBAdvLUEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TDBAdvLUEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;
{$ENDIF}

procedure TDBAdvLUEdit.LoadLookup;
var
  cb:TBookMark;
  s:string;

begin
  if not Assigned(FDatalink.Dataset) then
    Exit;

  if DataField = '' then
    Exit;

  if not Assigned(FDataLink.Field) then
    Exit;

  FDataLink.DataSource.DataSet.DisableControls;

  LookupItems.Clear;

  with FDataLink.DataSource.DataSet do
  begin
    cb := GetBookMark;
    First;

    while not FDataLink.DataSource.DataSet.Eof do
    begin
      s := FDataLink.Field.AsString;
      if LookUpItems.IndexOf(s)=-1 then LookupItems.Add(s);
      Next;
    end;

    GotoBookMark(cb);
    FreeBookMark(cb);
  end;

  FDataLink.DataSource.DataSet.EnableControls;
end;

procedure TDBAdvLUEdit.SetDataLookup(const Value: boolean);
begin
  FDataLookup := Value;
  if not (csLoading in ComponentState) and Value then
    LoadLookup;
end;

function TDBAdvLUEdit.EditCanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;

end.
