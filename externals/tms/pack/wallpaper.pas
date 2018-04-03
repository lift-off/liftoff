{*******************************************************************}
{ TWallPaper component                                              }
{ for Delphi 4.0,5.0,6.0 C++Builder 4,5                             }
{ version 1.2                                                       }
{                                                                   }
{ written by TMS Software                                           }
{  Copyright © 2000 - 2001                                          }
{  Email : info@tmssoftware.com                                     }
{  Web : http://www.tmssoftware.com                                 }
{                                                                   }
{ The source code is given as is. The author is not responsible     }
{ for any possible damage done due to the use of this code.         }
{ The component can be freely used in any application. The source   }
{ code remains property of the writer and may not be distributed    }
{freely as such.                                                    }
{*******************************************************************}

unit WallPaper;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,comobj,activex,math;

type
  TImagePosition = (ipTopLeft,ipTopRight,ipBottomLeft,ipBottomRight,ipCenter,ipTiled,ipStretched);

  TAdvImage = class(TGraphic)
  private
    { Private declarations }
    FDatastream: TMemoryStream;
    FIsEmpty: Boolean;
    gpPicture: IPicture;
    FLogPixX,FLogPixY: Integer;
    procedure LoadPicture;
  protected
    { Protected declarations }
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
    procedure SetHeight(Value: Integer); override;
    procedure SetWidth(Value: Integer); override;
    procedure ReadData(Stream: TStream); override;
    procedure WriteData(Stream: TStream); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
  public
    { Public declarations }
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromFile(const FileName: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;
  published
    { Published declarations }
  end;

  TWallPaper = class(TGraphicControl)
  private
    { Private declarations }
    FAdvImage:TAdvImage;
    FImagePosition:TImagePosition;
    procedure SetAdvImage(const Value: TAdvImage);
    procedure PictureChanged(sender:TObject);
    procedure SetImagePosition(const Value: TImagePosition);
  protected
    { Protected declarations }
     procedure Paint; override;
  public
    { Public declarations }
    constructor Create(aOwner:TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
  published
    { Published declarations }
    property AdvImage:TAdvImage read fAdvImage write SetAdvImage;
    property ImagePosition:TImagePosition read fImagePosition write SetImagePosition;
    { inherited published properties}
    property Align;
    property Anchors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Hint;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property OnClick;
    {$IFDEF DELPHI5_LVL}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnStartDock;
    property OnStartDrag;
  end;


implementation

const
  HIMETRIC_INCH = 2540;

{ TAdvImage }

procedure TAdvImage.Assign(Source: TPersistent);
begin
  FIsEmpty := True;
  gpPicture := nil;
  if (Source = nil) then
    FDataStream.Clear
  else
  begin
    if (Source is TAdvImage) then
    begin
      FDataStream.LoadFromStream(TAdvImage(Source).FDataStream);
      FIsEmpty := False;
      LoadPicture;
      if Assigned(OnChange) then OnChange(self);
    end;
  end;
end;

constructor TAdvImage.Create;
begin
  inherited;
  FDataStream := TMemoryStream.Create;
  FIsEmpty := True;
  gpPicture := nil;
  FLogPixX := 96;
  FLogPixY := 96;
end;

destructor TAdvImage.Destroy;
begin
  FDataStream.Free;
  inherited;
end;

procedure TAdvImage.LoadPicture;
const
  IID_IPicture: TGUID = (
    D1:$7BF80980;D2:$BF32;D3:$101A;D4:($8B,$BB,$00,$AA,$00,$30,$0C,$AB));

var
  hGlobal: THandle;
  pvData: Pointer;
  pstm: IStream;
  hr: hresult;

begin
  hGlobal := GlobalAlloc(GMEM_MOVEABLE, fDataStream.Size);
  if (hGlobal = 0) then
    raise Exception.Create('Could not allocate memory for image');

  pvData := GlobalLock(hGlobal);

  fDataStream.Position:=0;
  fDataStream.ReadBuffer(pvData^,fDataStream.Size);

  GlobalUnlock(hGlobal);

  pstm := nil;

  // create IStream* from global memory
  hr := CreateStreamOnHGlobal(hGlobal, TRUE, pstm);

  if (not hr=S_OK) then
      raise Exception.Create('Could not create image stream')
  else
    if (pstm = nil) then
      raise Exception.Create('Empty image stream created');

   // Create IPicture from image file

    hr := OleLoadPicture(pstm,
                          fDataStream.Size,
                          FALSE,
                          IID_IPicture,
                          gpPicture);

    if (not (hr=S_OK)) then raise Exception.Create('Could not load image. Invalid format')

    else if (gpPicture = nil) then
      raise Exception.Create('Could not load image');
end;

procedure TAdvImage.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  hmWidth: Integer;
  hmHeight: Integer;

begin
  if Empty then Exit;
  if (gpPicture = nil) then Exit;

  hmWidth  := 0;
  hmHeight := 0;
  gpPicture.get_Width(hmWidth);
  gpPicture.get_Height(hmHeight);

  gpPicture.Render(ACanvas.Handle,rect.Left,rect.Top,rect.Right - rect.Left,(rect.Bottom - rect.Top),0,hmHeight,
    hmWidth,-hmHeight,rect);
end;

function TAdvImage.GetEmpty: Boolean;
begin
  Result := FIsEmpty;
end;

function TAdvImage.GetHeight: integer;
var
  hmHeight: Integer;
begin
  if gpPicture = nil then
    Result := 0
  else
  begin
    gpPicture.get_Height(hmHeight);
    Result := MulDiv(hmHeight, fLogPixY, HIMETRIC_INCH);
  end;
end;

function TAdvImage.GetWidth: integer;
var
 hmWidth:integer;
begin
  if gpPicture=nil then result:=0 else
   begin
    gpPicture.get_Width(hmWidth);
    Result := MulDiv(hmWidth, fLogPixX, HIMETRIC_INCH);
   end;
end;

procedure TAdvImage.LoadFromFile(const FileName: string);
begin
  try
    FDataStream.LoadFromFile(Filename);
    FIsEmpty := False;
    LoadPicture;
    if Assigned(OnChange) then OnChange(self);

  except
    FIsEmpty := True;
  end;
end;

procedure TAdvImage.LoadFromStream(Stream: TStream);
begin
  if Assigned(Stream) then
  begin
    FDataStream.LoadFromStream(Stream);
    FIsEmpty := False;
    LoadPicture;
  end;
end;

procedure TAdvImage.ReadData(Stream: TStream);
begin
  if Assigned(Stream) then
  begin
    FDataStream.LoadFromStream(stream);
    FIsEmpty := False;
    LoadPicture;
  end;
end;

procedure TAdvImage.SaveToStream(Stream: TStream);
begin
  if Assigned(Stream) then FDataStream.SaveToStream(Stream);
end;

procedure TAdvImage.SetHeight(Value: integer);
begin

end;

procedure TAdvImage.SetWidth(Value: integer);
begin

end;

procedure TAdvImage.WriteData(Stream: TStream);
begin
  if Assigned(Stream) then
  begin
     FDataStream.SaveToStream(Stream);
  end;
end;

procedure TAdvImage.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
begin
end;

procedure TAdvImage.SaveToClipboardFormat(var AFormat: Word;
  var AData: THandle; var APalette: HPALETTE);
begin
end;

{ TWallPaper }

constructor TWallPaper.Create(aOwner: TComponent);
begin
  inherited;
  FAdvImage := TAdvImage.Create;
  FAdvImage.OnChange := PictureChanged;
  Width := 100;
  Height := 100;
end;

destructor TWallPaper.Destroy;
begin
  FAdvImage.Free;
  inherited;
end;

procedure TWallPaper.Loaded;
begin
  inherited;
  FAdvImage.FLogPixX := GetDeviceCaps(Canvas.Handle,LOGPIXELSX);
  FAdvImage.FLogPixY := GetDeviceCaps(Canvas.Handle,LOGPIXELSY);
end;

procedure TWallPaper.Paint;
var
  xo,yo:integer;
begin
  inherited;
  if assigned(fAdvImage) then
  begin
    if not fAdvImage.Empty then
    case fImagePosition of
    ipTopLeft:Canvas.Draw(0,0,fAdvImage);
    ipTopRight:Canvas.Draw(Max(0,width-fAdvImage.Width),0,fAdvImage);
    ipBottomLeft:Canvas.Draw(0,Max(0,height-fAdvImage.Height),fAdvImage);
    ipBottomRight:Canvas.Draw(Max(0,width-fAdvImage.Width),Max(0,height-fAdvImage.Height),fAdvImage);
    ipCenter:Canvas.Draw(Max(0,width-fAdvImage.Width) shr 1,Max(0,height-fAdvImage.Height) shr 1,fAdvImage);
    ipTiled:
      begin
        yo := 0;
        while yo < Height do
        begin
          xo := 0;
          while xo < Width do
          begin
            Canvas.Draw(xo,yo,fAdvImage);
            xo := xo + FAdvImage.Width;
          end;
          yo := yo + FAdvImage.Height;
        end;
      end;
    ipStretched:Canvas.StretchDraw(rect(0,0,width,height),FAdvImage) else
    end;
  end;
end;

procedure TWallPaper.PictureChanged(sender: TObject);
begin
  Invalidate;
end;

procedure TWallPaper.SetAdvImage(const Value: TAdvImage);
begin
  FAdvImage.Assign(Value);
  Invalidate;
end;

procedure TWallPaper.SetImagePosition(const Value: TImagePosition);
begin
  if (FImagePosition <> Value) then
  begin
    FImagePosition := Value;
    Invalidate;
  end;
end;



end.
