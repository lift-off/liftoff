{*********************************************************************}
{ TAdvFilenameEdit                                                    }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0                 }
{ version 1.0                                                         }
{                                                                     }
{ written by                                                          }
{  TMS Software                                                       }
{  copyright © 2002                                                   }
{  Email : info@tmssoftware.com                                       }
{  Web : http://www.tmssoftware.com                                   }
{                                                                     }
{ The source code is given as is. The author is not responsible       }
{ for any possible damage done due to the use of this code.           }
{ The component can be freely used in any application. The source     }
{ code remains property of the author and may not be distributed      }
{ freely as such.                                                     }
{*********************************************************************}

unit AdvFileNameEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdvEdit, AdvEdBtn;

type
  TFileDialogKind = (fdOpen, fdSave, fdOpenPicture, fdSavePicture);

  TAdvFileNameEdit = class(TAdvEditBtn)
  private
    { Private declarations }
    FDummy: Byte;
    FDefaultExt: string;
    FFilter: string;
    FFilterIndex: Integer;
    FInitialDir: string;
    FDialogOptions: TOpenOptions;
    FDialogTitle: string;
    FDialogKind: TFileDialogKind;
    FOnClickBtn:TNotifyEvent;
    FOnValueValidate: TValueValidateEvent;
    function GetFileName: TFileName;
    procedure SetFileName (const Value: TFileName);
  protected
    { Protected declarations }
    procedure BtnClick (Sender: TObject); override;
    procedure ValueValidate(Sender: TObject; Value: String; Var IsValid: Boolean); Virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    property AutoThousandSeparator: Byte read FDummy;
    property EditAlign: Byte read FDummy;
    property EditType: Byte read FDummy;
    property ExcelStyleDecimalSeparator: Byte read FDummy;
    property PasswordChar: Byte read FDummy;
    property Precision: Byte read FDummy;
    property Signed: Byte read FDummy;
    property ShowURL: Byte read FDummy;
    property URLColor: Byte read FDummy;
    property DefaultExt: string read FDefaultExt write FDefaultExt;
    property FileName: TFileName read GetFileName write SetFileName Stored False;
    property Filter: string read FFilter write FFilter;
    property FilterIndex: Integer read FFilterIndex write FFilterIndex default 1;
    property InitialDir: string read FInitialDir write FInitialDir;
    property DialogOptions: TOpenOptions read FDialogOptions write FDialogOptions default [ofHideReadOnly, ofEnableSizing];
    property DialogTitle: string read FDialogTitle write FDialogTitle;
    property DialogKind: TFileDialogKind read FDialogKind write FDialogKind;
    property OnClickBtn: TNotifyEvent read FOnClickBtn;
    property OnValueValidate: TValueValidateEvent read fOnValueValidate;
  end;

implementation

Uses ExtDlgs;
{$R *.RES}

constructor TAdvFileNameEdit.Create(AOwner: TComponent);
Begin
  Inherited;
  Glyph.LoadFromResourceName (HInstance, 'AdvFileNameEdit');
  Button.OnClick := BtnClick;
  Inherited OnValueValidate := ValueValidate;
  ButtonWidth := 18;
End;

procedure TAdvFileNameEdit.BtnClick (Sender: TObject);
Var
  Dialog: TOpenDialog;

begin
  Dialog := Nil;
  Case FDialogKind Of
    fdOpen:         Dialog := TOpenDialog.Create (Nil);
    fdOpenPicture:  Dialog := TOpenPictureDialog.Create (Nil);
    fdSave:         Dialog := TSaveDialog.Create (Nil);
    fdSavePicture:  Dialog := TSavePictureDialog.Create (Nil);
  End;

  With Dialog Do
  Begin
    FileName := Self.FileName;
    DefaultExt := FDefaultExt;
    Filter := FFilter;
    FilterIndex := FFilterIndex;
    InitialDir := FInitialDir;
    Options := FDialogOptions;
    Title := FDialogTitle;
  End;

  Try
    if Dialog.Execute Then
    Begin
      Text := Dialog.FileName;
      Modified := True;
    End;
  Finally
    Dialog.Free;
  End;
end;

procedure TAdvFileNameEdit.ValueValidate(Sender: TObject; Value: String; Var IsValid: Boolean);
begin
  IsValid := FileExists (Value);
end;

function TAdvFileNameEdit.GetFileName: TFileName;
Begin
  Result := Text;
End;

procedure TAdvFileNameEdit.SetFileName (const Value: TFileName);
Begin
  Text := Value;
End;

End.
