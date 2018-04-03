{***************************************************************************}
{ TDBAdvMemo component                                                      }
{ for Delphi & C++Builder                                                   }
{ version 1.2                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2001 - 2003                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of TMS software.                                    }
{***************************************************************************}

unit DBAdvMemo;

interface

uses
  Classes, AdvMemo, DB, DBCtrls, Graphics;

type

  TDBAdvMemo = class(TAdvMemo)
  private
    FDataLink: TFieldDataLink;
    FDBUpdate: Boolean;
    procedure DataUpdate(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure ActiveChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
  protected
    function EditCanModify: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    {TControl}
    property PopupMenu;
    {TCustomControl}
    property Align;
    property Anchors;
    property AutoCompletionHeight;
    property AutoCompletionWidth;
    property AutoCompletion;
    property AutoHintParameters;
    property AutoHintParameterPosition;    
    property AutoIndent;    
    property BkColor default clWhite;    
    property BorderStyle;
    property Ctl3D;
    property Cursor;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Enabled;
    property CaseSensitive;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property GutterColor;
    property GutterWidth;
    property ScrollBars;
    property ScrollMode;
    property PrintOptions;
    property Font;
    property SelColor;
    property SelBkColor;
    property HiddenCaret;
    property URLAware;
    property URLStyle;
    property TabSize;
    property UndoLimit;
    property DelErase;
    property SyntaxStyles;
    property OnEnter;
    property OnExit;
    property OnClick;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyUp;
    property OnKeyPress;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnDragOver;
    property OnDragDrop;
    property OnEndDock;
    property OnEndDrag;
    property OnStartDock;
    property OnStartDrag;
    property OnGutterClick;
    property OnGutterDraw;
    property OnChange;
    property OnSelectionChange;
    property OnStatusChange;
    property OnUndoChange;
    property OnURLClick;
    property OnStartAutoCompletion;
    property OnAutoCompletion;
    property OnCanceltAutoCompletion;
    
  end;

implementation

{ TDBAdvMemo }

procedure TDBAdvMemo.ActiveChange(Sender: TObject);
begin
  if Assigned(FDataLink) then
  begin
    if Assigned(FDataLink.DataSet) then
    begin
      if not FDataLink.DataSet.Active then
        Clear;
    end
    else
    begin
      Clear;
    end;
  end;

end;

constructor TDBAdvMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := DataUpdate;
  FDataLink.OnActiveChange := ActiveChange;
  FDBUpdate := False;
  DelErase := True;
end;

procedure TDBAdvMemo.DataChange(Sender: TObject);
begin
  if not Assigned(FDataLink.DataSet) then
    Exit;

  if Assigned(FDataLink.Field) and not FDBUpdate then
  begin
    Lines.Text := FDataLink.Field.AsString;
    LinesChanged(nil);
    Refresh;
  end;
end;

procedure TDBAdvMemo.DataUpdate(Sender: TObject);
begin
  if Assigned(FDataLink.Field) then
    FDataLink.Field.AsString := Lines.Text;
end;

destructor TDBAdvMemo.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

function TDBAdvMemo.EditCanModify: Boolean;
begin
  Result := True;

  if not Assigned(FDataLink.DataSet) then
    Exit;

  FDBUpdate := True;
  if not (FDataLink.DataSet.State in [dsEdit,dsInsert]) then
    Result := FDataLink.Edit
  else
    Result := True;

  if Result then FDataLink.Modified;
  FDBUpdate := False;
end;

function TDBAdvMemo.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TDBAdvMemo.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TDBAdvMemo.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDBAdvMemo.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

procedure TDBAdvMemo.SetDataSource(const Value: TDataSource);
begin
  FDataLink.DataSource := Value;
end;

procedure TDBAdvMemo.SetReadOnly(const Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

end.
