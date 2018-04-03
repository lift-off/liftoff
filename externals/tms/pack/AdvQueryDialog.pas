{********************************************************************
TADVEDIT based Query dialog component
for Delphi 1.0,2.0,3.0,4.0,5.0,C++Builder 1.0,3.0,4.0,5.0
version 1.0 - rel. January, 2001

written by TMS Software
           copyright © 2001
           Email : info@tmssoftware.com
           Web : http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The complete
source code remains property of the author and may not be distributed,
published, given or sold in any form as such. No parts of the source
code can be included in any other component or application without
written authorization of the author.
********************************************************************}

unit AdvQueryDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdvEdit;

type
  TAdvQueryDialog = class(TComponent)
  private
    FCaption: string;
    FPrompt: string;
    FEditType: TAdvEditType;
    FPrecision: integer;
    FSuffix: string;
    FPrefix: string;
    FFlat: boolean;
    FText: string;
    FLengthLimit: integer;
    FCanUndo: boolean;
    FShowModified: boolean;
    FShowURL: boolean;
    FModifiedColor: TColor;
    FPasswordChar: char;
    FEditAlign: TEditAlign;
    FSigned: boolean;
    FFlatLineColor: TColor;
    FFlatParentColor: boolean;
    FExcelStyleDecimalSeparator: boolean;
    FShowHint: boolean;
    FHint: string;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    function ShowModal: TModalResult;
  published
    { Published declarations }
    property CanUndo:boolean read FCanUndo write FCanUndo;
    property Caption:string read FCaption write FCaption;
    property EditAlign:TEditAlign read FEditAlign write FEditAlign;
    property EditType:TAdvEditType read FEditType write FEditType;
    property ExcelStyleDecimalSeparator:boolean read FExcelStyleDecimalSeparator write
                                                     FExcelStyleDecimalSeparator;
    property Flat:boolean read FFlat write FFlat;
    property FlatLineColor:TColor read FFlatLineColor write FFlatLineColor;
    property FlatParentColor:boolean read FFlatParentColor write FFlatParentColor;
    property Hint:string read FHint write FHint;
    property LengthLimit:integer read FLengthLimit write FLengthLimit;
    property ModifiedColor:TColor read FModifiedColor write FModifiedColor;
    property PasswordChar:char read FPasswordChar write FPasswordChar;
    property Precision:integer read FPrecision write FPrecision;
    property Prefix:string read FPrefix write FPrefix;
    property Prompt:string read FPrompt write FPrompt;
    property ShowHint:boolean read FShowHint write FShowHint;
    property ShowModified:boolean read FShowModified write FShowModified;
    property ShowURL:boolean read FShowURL write FShowURL;
    property Signed:boolean read FSigned write FSigned;
    property Suffix:string read FSuffix write FSuffix;
    property Text:string read FText write FText;
  end;



implementation


{ TAdvQueryDialog }

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;



function TAdvQueryDialog.ShowModal: TModalResult;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TAdvEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := FCaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      ClientHeight := MulDiv(63, DialogUnits.Y, 8);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        AutoSize := True;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Caption := FPrompt;
      end;
      Edit := TAdvEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := MulDiv(19, DialogUnits.Y, 8);
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := FText;
        SelectAll;
        CanUndo := FCanUndo;
        EditType := FEditType;
        EditAlign := FEditAlign;
        ExcelStyleDecimalSeparator := FExcelStyleDecimalSeparator; 
        Precision := FPrecision;
        Prefix := FPrefix;
        Suffix := FSuffix;
        Flat := FFlat;
        FlatLineColor := FFlatLineColor;
        FlatParentColor := FFlatParentColor;
        LengthLimit := FLengthLimit;
        ShowModified := FShowModified;
        ModifiedColor := FModifiedColor;
        ShowURL := FShowURL;
        PasswordChar := FPasswordChar;
        Signed := FSigned;
        Hint := FHint;
        ShowHint := FShowHint;
        if Flat then Height := Height-4;
      end;
      ButtonTop := MulDiv(41, DialogUnits.Y, 8);
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        {$IFNDEF DELPHI3_LVL}
        Caption := 'Ok';
        {$ELSE}
        Caption := SMsgDlgOK;
        {$ENDIF}

        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        {$IFNDEF DELPHI3_LVL}
        Caption := 'Cancel';
        {$ELSE}
        Caption := SMsgDlgCancel;
        {$ENDIF}
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      
      result := ShowModal;

      if result=mrOk then FText := Edit.Text;

    finally
      Form.Free;
    end;
end;



end.
