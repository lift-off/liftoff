{***************************************************************************}
{ TAdvPicture                                                               }
{ for Delphi 3.0, 4.0, 5.0, 6.0 C++Builder 3,4,5                            }
{ version 1.2                                                               }
{                                                                           }
{ written by                                                                }
{   TMS Software                                                            }
{   copyright � 2001                                                        }
{   Email : info@tmssoftware.com                                            }
{   Web : http://www.tmssoftware.com                                        }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit AdvPicture;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, ComObj, ActiveX, SysUtils;

type
  TPicturePosition = (bpTopLeft,bpTopRight,bpBottomLeft,bpBottomRight,bpCenter,
                      bpTiled,bpStretched,bpStretchedWithAspect);

  TStretchMode = (smNever,smShrink);

  TIPicture = class;

  TIPicture = class(TGraphic)
  private
    { Private declarations }
    gpPicture:IPicture;
    FDatastream:TMemoryStream;
    FIsEmpty:Boolean;
    FStretched:Boolean;
    FLogPixX,FLogPixY:Integer;
    FID:string;
    FFrame: Integer;
    FFrameCount: Integer;
    FOnFrameChange: TNotifyEvent;
    FFrameXPos: Word;
    FFrameYPos: Word;
    FFrameXSize: Word;
    FFrameYSize: Word;
    FFrameTransp: Boolean;
    FFrameDisposal: Word;
    FAnimMaxX,FAnimMaxY: Word;
    procedure LoadPicture;
    function GetFrameCount: Integer;
    function IsGIFFile: Boolean;
    function GetFrameTime(i: Integer): Integer;
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
    procedure SetFrame(const Value:Integer);
  public
    { Public declarations }
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromFile(const FileName: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromResourceName(Instance: THandle; const ResName: String);
    procedure LoadFromResourceID(Instance: THandle; ResID: Integer);
    procedure LoadFromURL(url:string);
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;
    property ID:string read fID write fID;
    property IsGIF: Boolean read IsGIFFile;
    property FrameCount:Integer read GetFrameCount;
    property FrameTime[i:Integer]:Integer read GetFrameTime;
    function GetMaxHeight: Integer;
    function GetMaxWidth: Integer;
  published
    { Published declarations }
    property Stretch:Boolean read FStretched write FStretched;
    property Frame:Integer read FFrame write SetFrame;
    property OnFrameChange: TNotifyEvent read FOnFrameChange write FOnFrameChange;
  end;

  THelperWnd = class(TWinControl)
  private
    FOnTimer: TNotifyEvent;
    procedure WMTimer(var Msg:TMessage); message WM_TIMER;
    procedure WMDestroy(var Msg:TMessage); message WM_DESTROY;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure CreateWnd; override;
  published
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;

  TAdvPicture = class(TGraphicControl)
  private
    { Private declarations }
    FAnimate: Boolean;
    FAutoSize: Boolean;
    FIPicture: TIPicture;
    FPicturePosition: TPicturePosition;
    FHelperWnd: THelperWnd;
    FTimerCount: Integer;
    FNextCount: Integer;
    FAnimatedGif: Boolean;
    FOnFrameChange: TNotifyEvent;
    FStretchMode: TStretchMode;
    procedure SetAutoSizeP(const Value: Boolean);
    procedure SetIPicture(const Value: TIPicture);
    procedure PictureChanged(sender:TObject);
    procedure FrameChanged(sender:TObject);
    procedure Timer(sender:TObject);
    procedure SetPicturePosition(const Value: TPicturePosition);
    procedure SetAnimate(const Value: Boolean);
    procedure SetStretchMode(const Value: TStretchMode);
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
    property Animate: Boolean read fAnimate write SetAnimate;
    property AutoSize: Boolean read FAutoSize write SetAutoSizeP default False;
    property Picture:TIPicture read FIPicture write SetIPicture;
    property PicturePosition:TPicturePosition read FPicturePosition write SetPicturePosition;
    { inherited published properties}
    property Align;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property Constraints;
    property DragKind;
    {$ENDIF}
    property DragCursor;
    property DragMode;
    property Hint;
    property ParentShowHint;
    property ShowHint;
    property StretchMode: TStretchMode read FStretchMode write SetStretchMode default smNever;
    property Visible;
    property OnClick;
    {$IFDEF DELPHI5_LVL}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF DELPHI4_LVL}
    property OnEndDock;
    property OnStartDock;
    {$ENDIF}
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnStartDrag;
    property OnFrameChange: TNotifyEvent read FOnFrameChange write FOnFrameChange;
  end;


implementation

const
  HIMETRIC_INCH = 2540;
  TIMER_ID = 500;
  
{ TIPicture }

procedure TIPicture.Assign(Source: TPersistent);
begin
  FIsEmpty := True;
  FFrameCount := -1;
  gpPicture := nil;
  if Source = nil then
  begin
    FDataStream.Clear;
    if Assigned(OnChange) then
      OnChange(Self);
  end
  else
  begin
    if Source is TIPicture then
    begin
      FDataStream.LoadFromStream(TIPicture(Source).FDataStream);
      FIsEmpty := False;
      LoadPicture;
      if Assigned(OnChange) then
        OnChange(self);
    end;
  end;
end;

constructor TIPicture.Create;
begin
  inherited;
  FDataStream := TMemoryStream.Create;
  FIsEmpty := True;
  gpPicture := nil;
  FLogPixX := 96;
  FLogPixY := 96;
  FFrame := 0;
  FFrameCount := -1; 
end;

destructor TIPicture.Destroy;
begin
  FDataStream.Free;
  inherited;
end;

procedure TIPicture.SetFrame(const Value:Integer);
begin
  FFrame := Value;
  if (FDataStream.Size > 0) then
  begin
    LoadPicture;
    if Assigned(OnFrameChange) then
      OnFrameChange(self);
  end;
end;

procedure TIPicture.LoadPicture;
const
  IID_IPicture: TGUID = (
  D1:$7BF80980;D2:$BF32;D3:$101A;D4:($8B,$BB,$00,$AA,$00,$30,$0C,$AB));

var
  hGlobal:thandle;
  pvData:pointer;
  pstm:IStream;
  hr:hResult;
  gifstream: TMemoryStream;
  i:Integer;
  b,c,d,e:byte;
  skipimg:Boolean;
  imgidx:Integer;
begin
  hGlobal := GlobalAlloc(GMEM_MOVEABLE, fDataStream.Size);
  if (hGlobal = 0) then raise Exception.Create('Could not allocate memory for image');

  try
    pvData := GlobalLock(hGlobal);
    FDataStream.Position:=0;

    FFrameXPos := 0;
    FFrameYPos := 0;
    FAnimMaxX := 0;
    FAnimMaxY := 0;

    {skip first image ctrl}

    if IsGIF and (FrameCount>0) then
     begin
      //manipulate the stream here for animated GIF ?
      Gifstream := TMemoryStream.Create;
      imgidx:=1;
      skipimg:=false;

      fDataStream.Position:=6;
      fDataStream.Read(FAnimMaxX,2);
      fDataStream.Read(FAnimMaxY,2);

      for i:=1 to fDataStream.Size do
       begin
         fDataStream.Position:=i-1;
         fDataStream.Read(b,1);

         if (b=$21) and (i+8<fDataStream.Size) then
          begin
           fDataStream.Read(c,1);
           fDataStream.Read(d,1);
           fDataStream.Position:=fDataStream.Position+5;

           fDataStream.Read(e,1);
           if (c=$F9) and (d=$4) and (e=$2C) then
             begin
               if imgidx=fFrame then
                begin
                 fDataStream.Read(FFrameXPos,2);
                 fDataStream.Read(FFrameYPos,2);
                 fDataStream.Read(FFrameXSize,2);
                 fDataStream.Read(FFrameYSize,2);
                end;

               inc(imgidx);
               if imgidx<=fFrame then skipimg:=true else
                                skipimg:=false;

             end;
          end;
        if not skipimg then gifstream.write(b,1);
       end;
      GifStream.Position:=0;
      GifStream.ReadBuffer(pvData^,GifStream.Size);
      GifStream.Free;
     end
    else
     fDataStream.ReadBuffer(pvData^,fDataStream.Size);

    GlobalUnlock(hGlobal);

    pstm := nil;

    // Create IStream* from global memory
    hr := CreateStreamOnHGlobal(hGlobal, TRUE, pstm);

    if (not hr = S_OK) then
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

    if (not (hr=S_OK)) then
     raise Exception.Create('Could not load image. Invalid format')
    else if (gpPicture = nil) then
     raise Exception.Create('Could not load image');
  finally
    GlobalFree(hGlobal);
  end;
end;

procedure TIPicture.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  hmWidth: Integer;
  hmHeight: Integer;
  DrwRect: TRect;

begin
  if Empty then
    Exit;
  if gpPicture=nil then
    Exit;

  hmWidth  := 0;
  hmHeight := 0;
  gpPicture.get_Width(hmWidth);
  gpPicture.get_Height(hmHeight);

  DrwRect := Rect;

  OffsetRect(DrwRect,FFrameXPos,FFrameYPos);

  gpPicture.Render(ACanvas.Handle,DrwRect.Left,DrwRect.Bottom,DrwRect.Right-DrwRect.Left,
                   -(DrwRect.Bottom-DrwRect.Top),0,0, hmWidth,hmHeight, DrwRect);
end;

function TIPicture.GetEmpty: Boolean;
begin
  Result := FIsEmpty;
end;

function TIPicture.GetHeight: Integer;
var
  hmHeight: Integer;
begin
  if gpPicture = nil then
    Result := 0
  else
  begin
    gpPicture.get_Height(hmHeight);
    Result := MulDiv(hmHeight, FLogPixY, HIMETRIC_INCH);
  end;
end;

function TIPicture.GetWidth: Integer;
var
  hmWidth: Integer;
begin
  if gpPicture = nil then
    Result := 0
  else
  begin
    gpPicture.get_Width(hmWidth);
    Result := MulDiv(hmWidth, fLogPixX, HIMETRIC_INCH);
  end;
end;

procedure TIPicture.LoadFromFile(const FileName: string);
begin
  try
    FDataStream.LoadFromFile(Filename);
    FIsEmpty := False;
    FFrame := 1;
    FAnimMaxX := 0;
    FAnimMaxY := 0;

    LoadPicture;
    if Assigned(OnChange) then
      OnChange(self);
  except
    FIsEmpty:=true;
  end;
end;

procedure TIPicture.LoadFromStream(Stream: TStream);
begin
  if Assigned(Stream) then
  begin
    FDataStream.LoadFromStream(Stream);
    FIsEmpty := False;
    FFrame := 1;
    FAnimMaxX := 0;
    FAnimMaxY := 0;
    LoadPicture;
    if Assigned(OnChange) then
      OnChange(self);
  end;
end;

procedure TIPicture.ReadData(Stream: TStream);
begin
  if assigned(Stream) then
  begin
    FDataStream.LoadFromStream(stream);
    FIsEmpty := False;
    LoadPicture;
  end;
end;

procedure TIPicture.SaveToStream(Stream: TStream);
begin
  if Assigned(Stream) then
    FDataStream.SaveToStream(Stream);
end;

procedure TIPicture.LoadFromResourceName(Instance: THandle; const ResName: string);
var
  Stream: TCustomMemoryStream;
begin
  if FindResource(Instance,PChar(ResName),RT_RCDATA) <> 0 then
  begin
    Stream := TResourceStream.Create(Instance, ResName, RT_RCDATA);
    try
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TIPicture.LoadFromResourceID(Instance: THandle; ResID: Integer);
var
  Stream: TCustomMemoryStream;
begin
  Stream := TResourceStream.CreateFromID(Instance, ResID, RT_RCDATA);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;


procedure TIPicture.SetHeight(Value: Integer);
begin

end;

procedure TIPicture.SetWidth(Value: Integer);
begin

end;

procedure TIPicture.WriteData(Stream: TStream);
begin
  if Assigned(Stream) then
  begin
    FDataStream.SaveToStream(stream);
  end;
end;

procedure TIPicture.LoadFromURL(url: string);
begin
  if (pos('RES://',UpperCase(url))=1) then
  begin
    ID := url;
    Delete(url,1,6);
    if (url<>'') then
      LoadFromResourceName(hinstance,url);
    Exit;
  end;

  if (pos('FILE://',uppercase(url))=1) then
  begin
    ID:=url;
    Delete(url,1,7);
    if (url<>'')
      then LoadFromFile(url);
  end;
end;

procedure TIPicture.LoadFromClipboardFormat(AFormat: Word;
  AData: THandle; APalette: HPALETTE);
begin
end;

procedure TIPicture.SaveToClipboardFormat(var AFormat: Word;
  var AData: THandle; var APalette: HPALETTE);
begin
end;

function TIPicture.GetFrameCount: Integer;
var
  i: Integer;
  b,c,d,e: Byte;
  Res: Integer;
begin
  Result := -1;

  if FFrameCount <> -1 then
    Result := FFrameCount
  else
    if IsGIFFile then
    begin
      Res := 0;
      for i := 1 to FDataStream.Size do
      begin
        FDataStream.Position := i - 1;
        FDataStream.Read(b,1);
        if (b = $21) and (i + 8 < FDataStream.Size) then
        begin
          FDataStream.Read(c,1);
          FDataStream.Read(d,1);
          FDataStream.Position:=fDataStream.Position+5;
          FDataStream.Read(e,1);
          if (c = $F9) and (d = $4) and (e = $2C) then Inc(res);
        end;
      end;
      FFrameCount := Res;  // cached FrameCount value
      Result := Res;
      FDataStream.Position := 0;
    end;
end;

function TIPicture.IsGIFFile: Boolean;
var
  buf: array[0..4] of char;
begin
  Result := False;
  if FDataStream.Size>4 then
  begin
    FDataStream.Position := 0;
    FDataStream.Read(buf,4);
    buf[4] := #0;
    Result := Strpas(buf) = 'GIF8';
    FDataStream.Position := 0;
  end;
end;

function TIPicture.GetFrameTime(i: Integer): Integer;
var
 j: Integer;
 b,c,d,e: Byte;
 res: Integer;
 ft: Word;

begin
  Result := -1;

  if IsGIFFile then
  begin
    Res := 0;
    for j := 1 to FDataStream.Size do
    begin
      fDataStream.Position := j-1;
      fDataStream.Read(b,1);
      if (b = $21) and (i + 8 < FDataStream.Size) then
      begin
        FDataStream.Read(c,1);
        FDataStream.Read(d,1);
        FDataStream.Read(b,1);
        {transp. flag here}

        FDataStream.Read(ft,2);
        FDataStream.Position:=fDataStream.Position+2;

        FDataStream.Read(e,1);
        if (c = $F9) and (d = $4) and (e = $2C) then
        begin
          Inc(res);
          if res = i then
          begin
            Result := ft;
            fFrameTransp := b and $01=$01;
            fFrameDisposal := (b shr 3) and $7;
          end;
        end;
      end;
    end;
  end;
  FDataStream.Position := 0;
end;

function TIPicture.GetMaxHeight: Integer;
var
  hmHeight: Integer;
begin
  if gpPicture=nil then Result:=0 else
  begin
    if FAnimMaxY>0 then Result:=FAnimMaxY
    else
    begin
      gpPicture.get_Height(hmHeight);
      Result := MulDiv(hmHeight, fLogPixY, HIMETRIC_INCH);
    end;
  end;

end;

function TIPicture.GetMaxWidth: Integer;
var
  hmWidth: Integer;
begin
  if gpPicture = nil then
    Result := 0
  else
  begin
    if FAnimMaxX > 0 then
      Result := FAnimMaxX
    else
    begin
      gpPicture.get_Width(hmWidth);
      Result := MulDiv(hmWidth, fLogPixX, HIMETRIC_INCH);
    end;
  end;
end;

{ TAdvPicture }

constructor TAdvPicture.Create(aOwner: TComponent);
begin
  inherited;
  FIPicture := TIPicture.Create;
  FIPicture.OnChange := PictureChanged;
  FIPicture.OnFrameChange := FrameChanged;
  Width := 100;
  Height := 100;
  FAnimatedGIF := False;
end;

destructor TAdvPicture.Destroy;
begin
  FIPicture.Free;
  FIPicture := nil;
  inherited;
end;

procedure TAdvPicture.Loaded;
begin
  inherited;
  FIPicture.fLogPixX := GetDeviceCaps(canvas.handle,LOGPIXELSX);
  FIPicture.fLogPixY := GetDeviceCaps(canvas.handle,LOGPIXELSY);
  if not FIPicture.Empty then
  begin
    FAnimatedGIF := FIPicture.IsGIF and (FIPicture.FrameCount > 1);
  end;
end;

procedure TAdvPicture.Paint;
var
  xo,yo: Integer;
  rx,ry: Double;
  NewWidth,NewHeight: Integer;

  function Max(a,b:Integer): Integer;
  begin
     if a > b then Result := a else Result := b;
  end;

begin
  inherited;

  if not Assigned(FIPicture) then
    Exit;

  if FIPicture.Empty then
    Exit;

  NewWidth := FIPicture.GetMaxWidth;
  NewHeight := FIPicture.GetMaxHeight;

  if (Width > 0) and (Height > 0) then
  begin
    rx := FIPicture.GetMaxWidth/Width;
    ry := FIPicture.GetMaxHeight/Height;

    if (rx > 1) or (ry > 1) then
    begin
      if rx > ry then
      begin
        NewHeight := Trunc(FIPicture.GetMaxHeight/rx);
        NewWidth := Width;
      end
      else
      begin
        NewWidth := Trunc(FIPicture.GetMaxWidth/ry);
        NewHeight := Height;
      end;
    end;
  end
  else
    Exit;

  case FPicturePosition of
  bpTopLeft:
  begin
    if FStretchMode = smNever then
      Canvas.Draw(0,0,FIPicture)
    else
      Canvas.StretchDraw(Rect(0,0,NewWidth,NewHeight),FIPicture)
  end;

  bpTopRight:
  begin
    if FStretchMode = smNever then
      Canvas.Draw(Max(0,Width - FIPicture.GetMaxWidth),0,FIPicture)
    else
      Canvas.StretchDraw(Rect(Max(0,Width - NewWidth),0,Max(0,Width - NewWidth)+NewWidth,NewHeight),FIPicture);
  end;
  bpBottomLeft:
  begin
    if FStretchMode = smNever then
      Canvas.Draw(0,Max(0,Height - FIPicture.GetMaxHeight),FIPicture)
    else
      Canvas.StretchDraw(Rect(0,Max(0,Height - NewHeight),NewWidth, Height),FIPicture);
  end;
  bpBottomRight:
  begin
    if FStretchMode = smNever then
      Canvas.Draw(Max(0,Width - FIPicture.GetMaxWidth),Max(0,Height - FIPicture.GetMaxHeight),FIPicture)
    else
      Canvas.StretchDraw(Rect(Max(0,Width - NewWidth),Max(0,Height - NewHeight),Width,Height),FIPicture);
  end;
  bpCenter:
  begin
    if FStretchMode = smNever then
      Canvas.Draw(Max(0,Width - FIPicture.GetMaxWidth) shr 1,Max(0,Height - FIPicture.GetMaxHeight) shr 1,FIPicture)
    else
      Canvas.StretchDraw(Rect(Max(0,Width - NewWidth) shr 1,Max(0,Height - NewHeight) shr 1,
                              (Max(0,Width - NewWidth) shr 1) + NewWidth,
                              (Max(0,Height - NewHeight) shr 1) + NewHeight),FIPicture);
  end;
  bpTiled:
  begin
    yo := 0;
    while yo < Height do
    begin
      xo := 0;
      while xo < Width do
      begin
        Canvas.Draw(xo,yo,FIPicture);
        xo := xo + FIPicture.GetMaxWidth;
      end;
      yo := yo + FIPicture.GetMaxHeight;
    end;
  end;

  bpStretched:
  begin
    Canvas.StretchDraw(Rect(0,0,Width,Height),FIPicture)
  end;

  bpStretchedWithAspect:
  begin
    rx := FIPicture.GetMaxWidth/Width;
    ry := FIPicture.GetMaxHeight/Height;

    if rx > ry then
      Canvas.StretchDraw(Rect(0,0,Width,Trunc(FIPicture.GetMaxHeight/rx)),FIPicture)
    else
      Canvas.StretchDraw(Rect(0,0,Trunc(FIPicture.GetMaxWidth/ry),Height),FIPicture);
  end;
  end;
end;

procedure TAdvPicture.PictureChanged(sender: TObject);
begin
  if FAutoSize and not FIPicture.Empty then
  begin
    SetAutoSizeP(FAutoSize);
  end;

  if not FIPicture.Empty then
  begin
    FAnimatedGIF := FIPicture.IsGIF and (FIPicture.FrameCount>1);
    FIPicture.Frame:=0;
  end;
  Invalidate;
end;

procedure TAdvPicture.FrameChanged(sender: TObject);
var
  R: TRect;
begin
  case FIPicture.FFrameDisposal of
  0:Paint;
  1:Invalidate;
  2:begin
      with FIPicture do
      begin
        R := Rect(fFrameXPos,fFrameXPos,fFrameXPos+fFrameXSize,fFrameYPos+fFrameYSize);
        if Parent.HandleAllocated then
          InvalidateRect(Parent.Handle,@R,true);
      end;
    end;
  3:Paint;
  end;
  if Assigned(FOnFrameChange) then
    FOnFrameChange(Self);
end;

procedure TAdvPicture.Timer(sender:TObject);
begin
 if not Assigned(FIPicture) then
   Exit;

  if FAnimatedGIF and not FIPicture.Empty then
  begin
    if FTimerCount = FNextCount then
    begin
      if FIPicture.Frame < FIPicture.FrameCount then
        FIPicture.frame := FIPicture.Frame + 1
      else
        FIPicture.Frame := 1;

      FNextCount := FNextCount + FIPicture.FrameTime[FIPicture.Frame];
    end;
    Inc(FTimerCount);
  end;
end;

procedure TAdvPicture.SetAutoSizeP(const Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize and not FIPicture.Empty then
  begin
    Self.Width := FIPicture.Width;
    Self.Height := FIPicture.Height;
  end;
end;

procedure TAdvPicture.SeTIPicture(const Value: TIPicture);
begin
  FIPicture.Assign(Value);
  Invalidate;
end;

procedure TAdvPicture.SetPicturePosition(const Value: TPicturePosition);
begin
  if FPicturePosition <> Value then
  begin
    FPicturePosition := Value;
    Invalidate;
  end;
end;

procedure TAdvPicture.SetAnimate(const Value: Boolean);
begin
  if FAnimate <> Value then
  begin
    FAnimate := Value;
    if not (csDesigning in ComponentState) then
    begin
      if FAnimate then
      begin
        FHelperWnd := THelperWnd.Create(nil);
        FHelperWnd.Parent := Self.Parent;
        FTimerCount := 0;
        FNextCount := 0;
        FHelperWnd.OnTimer := Timer;
      end
      else
      begin
        FHelperWnd.Free;
      end;
    end;
  end;
end;

procedure TAdvPicture.SetStretchMode(const Value: TStretchMode);
begin
  if FStretchMode <> Value then
  begin
    FStretchMode := Value;
    Invalidate;
  end;
end;

{ THelperWnd }

constructor THelperWnd.Create(aOwner: TComponent);
begin
  inherited;
end;

procedure THelperWnd.CreateWnd;
begin
  inherited;
  SetTimer(Self.Handle,TIMER_ID,10,nil);
end;

destructor THelperWnd.Destroy;
begin
  inherited;
end;

procedure THelperWnd.WMDestroy(var Msg: TMessage);
begin
  KillTimer(Self.Handle,TIMER_ID);
  inherited;
end;

procedure THelperWnd.WMTimer(var Msg: TMessage);
begin
  if Assigned(FOnTimer) then
    FOnTimer(self);
end;

end.
