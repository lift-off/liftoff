{**************************************************************************}
{ TDBAdvSpinEdit component                                                 }
{ for Delphi & C++Builder                                                  }
{ version 1.3                                                              }
{                                                                          }
{ written by TMS Software                                                  }
{           copyright � 2000 - 2002                                        }
{           Email : info@tmssoftware.com                                   }
{           Web : http://www.tmssoftware.com                               }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit DBAdvSp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdvSpin, db, dbctrls;

type
  TDBAdvSpinEdit = class(TAdvSpinEdit)
  private
    { Private declarations }  
    FDataLink:TFieldDataLink;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetReadOnly(const Value: Boolean);
    procedure DataUpdate(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMExit(var Message: TWMNoParams); message CM_EXIT;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpClick (Sender: TObject); override;
    procedure DownClick (Sender: TObject); override;
  public
    { Public declarations }
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;


implementation

{ TDBAdvSpinEdit }

procedure TDBAdvSpinEdit.CMEnter(var Message: TCMEnter);
begin
 inherited;
 if FDataLink.CanModify then inherited ReadOnly := False;
end;

procedure TDBAdvSpinEdit.CMExit(var Message: TWMNoParams);
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

procedure TDBAdvSpinEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

constructor TDBAdvSpinEdit.Create(aOwner: TComponent);
begin
  inherited;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := DataUpdate;
end;

procedure TDBAdvSpinEdit.DataChange(Sender: TObject);
begin
 if assigned(FDataLink.Field) then
  self.Text:=FDataLink.Field.AsString;
end;

procedure TDBAdvSpinEdit.DataUpdate(Sender: TObject);
begin
 if assigned(FDataLink.Field) then
  FDataLink.Field.AsString := self.Text;
end;

destructor TDBAdvSpinEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited;
end;

procedure TDBAdvSpinEdit.DownClick(Sender: TObject);
begin
  FDataLink.Edit;
  FDataLink.Modified;
  inherited;
end;

function TDBAdvSpinEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TDBAdvSpinEdit.GetDataSource: TDataSource;
begin
 Result := FDataLink.DataSource;
end;

function TDBAdvSpinEdit.GetReadOnly: Boolean;
begin
 Result := FDataLink.ReadOnly;
end;

procedure TDBAdvSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if FDataLink.ReadOnly and (key=VK_DELETE) then key:=0;
  inherited KeyDown(Key, Shift);
  if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
   begin
    FDataLink.Edit;
    FDataLink.Modified;
   end;
end;

procedure TDBAdvSpinEdit.KeyPress(var Key: Char);
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
     begin
      FDataLink.Edit;
      FDataLink.Modified;
     end;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;
end;

procedure TDBAdvSpinEdit.Loaded;
begin
 inherited;
end;

procedure TDBAdvSpinEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (csDestroying in ComponentState) then
    Exit;

  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBAdvSpinEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

procedure TDBAdvSpinEdit.SetDataSource(const Value: TDataSource);
begin
 FDataLink.DataSource := Value;
end;

procedure TDBAdvSpinEdit.SetReadOnly(const Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TDBAdvSpinEdit.UpClick(Sender: TObject);
begin
  FDataLink.Edit;
  FDataLink.Modified;
  inherited;
end;

procedure TDBAdvSpinEdit.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TDBAdvSpinEdit.WMPaste(var Message: TMessage);
begin
 if not FDataLink.Readonly then
  begin
   FDataLink.Edit;
   FDataLink.Modified;
   inherited;
  end;
end;

procedure TDBAdvSpinEdit.WMUndo(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

end.
