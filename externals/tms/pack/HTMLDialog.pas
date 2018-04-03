{********************************************************************
HTMLDialog component
for Delphi 2.0,3.0,4.0,5.0 & C++Builder 1.0, 3.0, 4.0,5.0
version 1.0

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

unit HTMLDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HTMLabel, StdCtrls;

type

  TAnchorClick = procedure (Sender:TObject; Anchor:string) of object;

  TButtonProperties = class(TPersistent)
  private
    { Private declarations }
    FVisible: boolean;
    FCaption: string;
    FModalResult: TModalResult;
    FCancel: boolean;
    FDefault: boolean;
  published
    { Published declarations }
    property Cancel: boolean read FCancel write FCancel;
    property Caption: string read FCaption write FCaption;
    property Default: boolean read FDefault write FDefault;
    property ModalResult: TModalResult read FModalResult write FModalResult;
    property Visible: boolean read FVisible write FVisible;
  end;

  THTMLDialog = class(TComponent)
  private
    { Private declarations }
    FCaption: string;
    FColor: TColor;
    FImages: TImageList;
    FHTMLText: TStringList;
    FFont: TFont;
    FHover: boolean;
    FHoverColor: TColor;
    FHoverFontColor: TColor;
    FShadowOffset: Integer;
    FShadowColor: TColor;
    FURLColor: TColor;
    FAnchorExit: TAnchorClick;
    FAnchorClick: TAnchorClick;
    FAnchorEnter: TAnchorClick;
    FLeftButton:TButtonProperties;
    FCenterButton:TButtonProperties;
    FRightButton:TButtonProperties;
    FPosition: TPosition;
    FHeight: integer;
    FWidth: integer;
    procedure SetHTMLText(const Value: TStringList);
    procedure SetImages(const Value: TImageList);
    procedure SetFont(const Value: TFont);
    procedure SetCenterButton(const Value: TButtonProperties);
    procedure SetLeftButton(const Value: TButtonProperties);
    procedure SetRightButton(const Value: TButtonProperties);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    function ShowModal:integer;
  published
    { Published declarations }
    property Caption:string read FCaption write FCaption;
    property CenterButton:TButtonProperties read FCenterButton write SetCenterButton;
    property Color:TColor read FColor write FColor default clBtnFace;
    property Font:TFont read FFont write SetFont;
    property Height:integer read FHeight write FHeight;
    property Hover:boolean read FHover write FHover;
    property HoverColor:TColor read FHoverColor write FHoverColor;
    property HoverFontColor:TColor read FHoverFontColor write FHoverFontColor;
    property HTMLText:TStringList read FHTMLText write SetHTMLText;
    property Images:TImageList read FImages write SetImages;
    property LeftButton:TButtonProperties read FLeftButton write SetLeftButton;
    property Position:TPosition read FPosition write FPosition;
    property RightButton:TButtonProperties read FRightButton write SetRightButton;
    property ShadowColor:TColor read FShadowColor write FShadowColor default clGray;
    property ShadowOffset:Integer read FShadowOffset write FShadowOffset default 1;
    property URLColor:TColor read FURLColor write FURLColor default clBlue;
    property Width:integer read FWidth write FWidth;
    property OnAnchorClick:TAnchorClick read FAnchorClick write FAnchorClick;
    property OnAnchorEnter:TAnchorClick read FAnchorEnter write FAnchorEnter;
    property OnAnchorExit:TAnchorClick read FAnchorExit write FAnchorExit;
  end;

implementation

{ THTMLDialog }

constructor THTMLDialog.Create(aOwner: TComponent);
begin
  inherited;
  FImages := nil;
  FHTMLText := TStringList.Create;
  FFont := TFont.Create;
  FURLColor := clBlue;
  FShadowColor := clGray;
  FShadowOffset := 1;
  FHoverColor := clNone;
  FHoverFontColor := clNone;
  FCenterButton := TButtonProperties.Create;
  FLeftButton := TButtonProperties.Create;
  FRightButton := TButtonProperties.Create;

  FCenterButton.Caption := 'Ok';
  FCenterButton.Default := true;
  FCenterButton.Visible := true;
  FCenterButton.ModalResult := mrOk;

  FRightButton.Caption := 'Cancel';
  FRightButton.Cancel := true;
  FRightButton.Visible := true;
  FRightButton.ModalResult := mrCancel;

  FPosition := poScreenCenter;

  FWidth := 180;
  FHeight := 90;
  FColor := clBtnFace;
end;

destructor THTMLDialog.Destroy;
begin
  FHTMLText.Free;
  FFont.Free;
  FCenterButton.Free;
  FLeftButton.Free;
  FRightButton.Free;
  inherited;
end;


procedure THTMLDialog.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation=opRemove) and (AComponent=FImages) then FImages:=nil;
  inherited;
end;

procedure THTMLDialog.SetCenterButton(const Value: TButtonProperties);
begin
  FCenterButton.Assign(Value);
end;

procedure THTMLDialog.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure THTMLDialog.SetHTMLText(const Value: TStringList);
begin
  FHTMLText.Assign(Value);
end;

procedure THTMLDialog.SetImages(const Value: TImageList);
begin
  FImages := Value;
end;

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


procedure THTMLDialog.SetLeftButton(const Value: TButtonProperties);
begin
  FLeftButton.Assign(Value);
end;

procedure THTMLDialog.SetRightButton(const Value: TButtonProperties);
begin
  FRightButton.Assign(Value);
end;

function THTMLDialog.ShowModal: integer;
var
  Form: TForm;
  HTMLabel: THTMLabel;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  OffsX, OffsY: Integer;

begin
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := FCaption;

      Color := FColor;

      ClientWidth := FWidth;
      ClientHeight := FHeight;
      Position := FPosition;

      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      ButtonTop := ClientHeight - ButtonHeight -4;

      HTMLabel := THTMLabel.Create(Form);
      with HTMLabel do
      begin
        Parent := Form;
        Font.Assign(FFont);

        OffsX := MulDiv(8, DialogUnits.X, 4);
        OffsY := MulDiv(8, DialogUnits.Y, 8);

        Left := OffsX;
        Top := OffsY;
        Width := Parent.Width - 2* OffsX;

        Images := FImages;
        HTMLText.Assign(FHTMLText);
        Hover := FHover;
        HoverFontColor := FHoverFontColor;
        HoverColor := FHoverColor;
        URLColor := FURLColor;
        ShadowColor := FShadowColor;
        ShadowOffset := FShadowOffset;

        OnAnchorClick := FAnchorClick;
        OnAnchorEnter := FAnchorEnter;
        OnAnchorExit := FAnchorExit;

        AutoSizing := True;
      end;

      if FLeftButton.Visible then
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := FLeftButton.Caption;
        ModalResult := FLeftButton.ModalResult;
        Default := FLeftButton.Default;
        Cancel := FLeftButton.Cancel;
        SetBounds(Form.ClientWidth - 3*(ButtonWidth+10), ButtonTop, ButtonWidth, ButtonHeight);
      end;

      if FCenterButton.Visible then
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := FCenterButton.Caption;
        ModalResult := FCenterButton.ModalResult;
        Default := FCenterButton.Default;
        Cancel := FCenterButton.Cancel;
        SetBounds(Form. ClientWidth - 2*(ButtonWidth+10), ButtonTop, ButtonWidth, ButtonHeight);
      end;

      if FRightButton.Visible then
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := FRightButton.Caption;
        ModalResult := FRightButton.ModalResult;
        Default := FRightButton.Default;
        Cancel := FRightButton.Cancel;
        SetBounds(Form.ClientWidth - (ButtonWidth+10), ButtonTop, ButtonWidth, ButtonHeight);
      end;

      result := ShowModal;

    finally
      Form.Free;
    end;

end;

end.
