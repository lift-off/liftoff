{***************************************************************************}
{ TThumbnailList component                                                  }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0                       }
{ version 1.0 - rel. April 2001                                             }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2001                                               }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

{$I TMSDEFS.INC}

unit ThumbnailList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  StdCtrls, ComObj, ActiveX;


type
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
    FFrame:Integer;
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

  TThumbnails = class;

  TThumbnailSource = (tsPicture,tsFile);

  TThumbnail = class(TCollectionItem)
  private
    FPicture: TIPicture;
    FFilename: string;
    FSource: TThumbnailSource;
    FCaption: string;
    FTag: Integer;
    procedure SetPicture(const Value: TIPicture);
    procedure SetFileName(const Value: string);
    procedure SetCaption(const Value: string);
    procedure Changed;
    procedure PictureChanged(Sender: TObject);
  protected
  public
    constructor Create(Collection:TCollection); override;
    destructor Destroy; override;
  published
    property Picture: TIPicture read FPicture write SetPicture;
    property Source: TThumbnailSource read FSource write FSource;
    property Filename: string read FFilename write SetFileName;
    property Caption: string read FCaption write SetCaption;
    property Tag: Integer read FTag write FTag;
  end;

  TThumbnailList = class;

  TThumbnails = class(TCollection)
  private
    FOwner: TThumbnailList;
    FThumbnailCount: Integer;
    function GetItem(Index: Integer): TThumbnail;
    procedure SetItem(Index: Integer; const Value: TThumbnail);
    procedure Changed(Sender:TObject);
  protected
    function GetOwner: TPersistent; override;
    procedure AddThumb;
    procedure RemoveThumb;
  public
    constructor Create(AOwner:TThumbnailList);
    function Add:TThumbnail;
    function Insert(index:integer): TThumbnail;
    property Items[Index: Integer]: TThumbnail read GetItem write SetItem;
  end;

  TThumbnailOrientation = (toVertical, toHorizontal);

  TThumbnailList = class(TCustomListBox)
  private
    FThumbnails: TThumbnails;
    FUpdateCount: Integer;
    FShowCaption: Boolean;
    FOrientation: TThumbnailOrientation;
    FThumbnailSize: Integer;
    FBuffered: Boolean;
    FShowSelection: Boolean;
    { Private declarations }
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetThumbnails(const Value: TThumbnails);
    procedure BuildItems;
    procedure SetShowCaption(const Value: Boolean);
    procedure SetOrientation(const Value: TThumbnailOrientation);
    procedure SetThumbnailSize(const Value: Integer);
    procedure SetShowSelection(const Value: Boolean);
  protected
    { Protected declarations }
    procedure DrawItem(Index: Integer; ARect: TRect;AState: TOwnerDrawState); override;
    procedure CreateParams(var Params:TCreateParams); override;
    procedure UpdateHorzScroll;
    property Items;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;    
    procedure ShowFolder(FolderName: string);
    procedure BeginUpdate;
    procedure EndUpdate;
  published
    { Published declarations }
    property Align;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    {$ENDIF}
    property BorderStyle;
    property Buffered: Boolean read FBuffered write FBuffered default True;
    property Color;
    property Columns;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property MultiSelect;
    property Orientation: TThumbnailOrientation read FOrientation
      write SetOrientation default toVertical;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowCaption: Boolean read FShowCaption
      write SetShowCaption default True;
    property ShowHint;
    property ShowSelection: Boolean read FShowSelection write SetShowSelection;
    property TabOrder;
    property TabStop;
    property Thumbnails: TThumbnails read FThumbnails write SetThumbnails;
    property ThumbnailSize: Integer read FThumbnailSize write SetThumbnailSize;
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
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;



implementation

const
  HIMETRIC_INCH = 2540;
  TIMER_ID = 500;

procedure TThumbnailList.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
    {$IFDEF DELPHI5_LVL}
    State := TOwnerDrawState(LongRec(itemState).Lo);
    {$ELSE}
    State := TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
    {$ENDIF}
    Canvas.Handle := hDC;
    Canvas.Font := Font;
    Canvas.Brush := Brush;
    if Integer(itemID) >= 0 then DrawItem(itemID, rcItem, State);
    Canvas.Handle := 0;
  end;
end;


constructor TThumbnailList.Create(AOwner: TComponent);
begin
  inherited;
  FThumbnails := TThumbnails.Create(Self);
  Style := lbOwnerDrawFixed;
  FThumbnailSize := 64;
  FBuffered := True;
  FShowCaption := True;
end;

destructor TThumbnailList.Destroy;
begin
  FThumbnails.Free;
  inherited;
end;

procedure TThumbnailList.DrawItem(Index: Integer; ARect: TRect;
  AState: TOwnerDrawState);
var
  Rx, Ry: Double;
  Width,Height, TH: Integer;
  DrawRect: TRect;
  TempPic, Pic: TIPicture;
begin

  if (odSelected in AState) and FShowSelection then
  begin
    Canvas.Brush.Color := clHighlight;
    Canvas.Pen.Color := clHighlight;
    Canvas.Font.Color := clHighlightText;
    Canvas.Pen.Width := 2;
    Canvas.Rectangle(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom);
  end
  else
  begin
    Canvas.Brush.Color := Color;
    Canvas.Pen.Color := Color;
    Canvas.Font.Color := Font.Color;
    Canvas.Pen.Width := 2;
    Canvas.Rectangle(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom);
  end;

  //Make sure the focus rect. is redrawn
  Canvas.MoveTo(ARect.Left,ARect.Top);
  Canvas.LineTo(ARect.Right,ARect.Top);
  Canvas.LineTo(ARect.Right,ARect.Bottom);
  Canvas.LineTo(ARect.Left,ARect.Bottom);
  Canvas.LineTo(ARect.Left,ARect.Top);

  TH := 0;

  InflateRect(ARect,-2,-2);

  if (Index >= 0) and (Index < FThumbnails.Count) then
  begin
    with FThumbnails.Items[Index] do
    begin
      TempPic := nil;
      Pic := Picture;

      if FBuffered then
      begin
        if Picture.Empty and (Filename <> '') and (Source = tsFile) then
        begin
          TempPic := TIPicture.Create;
          TempPic.LoadFromFile(Filename);
          Pic := TempPic;
          Picture.LoadFromFile(Filename);
        end;
      end;

      if FShowCaption then
      begin
        DrawTextEx(Canvas.Handle,pchar(Caption),Length(Caption),ARect,DT_CENTER or DT_BOTTOM or DT_SINGLELINE or DT_END_ELLIPSIS,nil);
        TH := Canvas.TextHeight('gh');
        ARect.Bottom := ARect.Bottom - TH;
      end;

      Width := ARect.Right - ARect.Left;
      Height := ARect.Bottom - ARect.Top;

      if (Width > 0) and (Height > 0) then
      begin
        rx := Pic.GetMaxWidth/Width;
        ry := Pic.GetMaxHeight/Height;

        if (rx > 1) or (ry > 1) then
        begin
          if rx > ry then
            DrawRect := Rect(0,0,Width,Trunc(Pic.GetMaxHeight/rx))
          else
            DrawRect := Rect(0,0,Trunc(Pic.GetMaxWidth/ry),Height);
        end
        else
          DrawRect := Rect(0,0,Pic.GetMaxWidth,Pic.GetMaxHeight);

        {Center the drawing rectangle}
        OffsetRect(DrawRect,ARect.Left + (Width - DrawRect.Right + DrawRect.Left) shr 1,
                            ARect.Top + (Height - DrawRect.Bottom + DrawRect.Top) shr 1);

        Canvas.StretchDraw(DrawRect,Pic);
      end;

      if Assigned(TempPic) then
        TempPic.Free;

    end;
  end;

  InflateRect(ARect,2,2);
  ARect.Bottom := ARect.Bottom + TH;
  if odFocused in AState then DrawFocusRect(Canvas.Handle,ARect);
end;

procedure TThumbnailList.SetOrientation(const Value: TThumbnailOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    SetThumbnailSize(FThumbnailSize);
    Invalidate;
  end;
end;


procedure TThumbnailList.BuildItems;
begin
  if csLoading in ComponentState then
    Exit;

  if csDestroying in ComponentState then
    Exit;

  if FUpdateCount > 0 then
    Exit;

  while Items.Count > FThumbnails.FThumbnailCount do
    Items.Delete(Items.Count-1);

  while Items.Count < FThumbnails.FThumbnailCount do
    Items.Add('');

  UpdateHorzScroll;
  SetThumbnailSize(FThumbnailSize);

  Invalidate;
end;

procedure TThumbnailList.SetThumbnails(const Value: TThumbnails);
begin
  FThumbnails.Assign(Value);
end;


{ TIPicture }

procedure TIPicture.Assign(Source: TPersistent);
begin
  FIsEmpty := True;
  gpPicture := nil;
  if Source = nil then
  begin
    FDataStream.Clear;
    if Assigned(OnChange) then
      OnChange(Self);
  end
  else
  begin
    if (Source is TIPicture) then
    begin
      FDataStream.LoadFromStream(TIPicture(Source).FDataStream);
      FIsEmpty := False;
      LoadPicture;
      if assigned(OnChange) then OnChange(self);
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
end;

destructor TIPicture.Destroy;
begin
  FDataStream.Free;
  inherited;
end;

procedure TIPicture.SetFrame(const Value:Integer);
begin
 fFrame:=Value;
 if (fDataStream.Size>0) then
   begin
    LoadPicture;
    if assigned(OnFrameChange) then OnFrameChange(self);
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
  gifstream:tmemorystream;
  i:Integer;
  b,c,d,e:byte;
  skipimg:Boolean;
  imgidx:Integer;
begin
  hGlobal := GlobalAlloc(GMEM_MOVEABLE, fDataStream.Size);
  if (hGlobal = 0) then
    raise Exception.Create('Could not allocate memory for image');

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
    Gifstream:=TMemoryStream.Create;
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

  if (not (hr=S_OK)) then
   raise Exception.Create('Could not load image. Invalid format')
  else if (gpPicture = nil) then
   raise Exception.Create('Could not load image');
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
  if FindResource(Instance,PChar(ResName),RT_BITMAP)<>0 then
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
  if gpPicture = nil then
    Result := 0
  else
  begin
    if FAnimMaxY > 0 then
      Result := FAnimMaxY
    else
    begin
      gpPicture.get_Height(hmHeight);
      Result := MulDiv(hmHeight, FLogPixY, HIMETRIC_INCH);
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



{ TThumbnail }

procedure TThumbnail.Changed;
begin
  (Collection as TThumbnails).Changed(Self);
end;

constructor TThumbnail.Create(Collection: TCollection);
begin
  inherited;
  FPicture := TIPicture.Create;
  FPicture.OnChange := PictureChanged;
  (Collection as TThumbnails).AddThumb;
end;

destructor TThumbnail.Destroy;
begin
  (Collection as TThumbnails).RemoveThumb;
  FPicture.Free;
  inherited;
end;

procedure TThumbnail.PictureChanged(Sender: TObject);
begin
  Changed;
end;

procedure TThumbnail.SetCaption(const Value: string);
begin
  FCaption := Value;
  Changed;
end;

procedure TThumbnail.SetFileName(const Value: string);
begin
  FFilename := Value;
  Changed;
end;

procedure TThumbnail.SetPicture(const Value: TIPicture);
begin
  FPicture.Assign(Value);
  Changed;
end;

{ TThumbnails }

function TThumbnails.Add: TThumbnail;
begin
  Result := TThumbnail(inherited Add);
end;

procedure TThumbnails.AddThumb;
begin
  FThumbnailCount :=  FThumbnailCount + 1;
  FOwner.BuildItems;
end;

procedure TThumbnails.Changed(Sender: TObject);
begin
  FOwner.BuildItems;
end;

constructor TThumbnails.Create(AOwner: TThumbnailList);
begin
  inherited Create(TThumbnail);
  FOwner := AOwner;
  FThumbnailCount := 0;
end;

function TThumbnails.GetItem(Index: Integer): TThumbnail;
begin
  Result := TThumbnail(inherited Items[Index]);
end;

function TThumbnails.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TThumbnails.Insert(Index: Integer): TThumbnail;
begin
  {$IFDEF DELPHI4_LVL}
  Result := TThumbnail(inherited Insert(Index));
  {$ELSE}
  Result := TThumbnail(inherited Add);
  {$ENDIF}
end;

procedure TThumbnails.RemoveThumb;
begin
  if FThumbnailCount >0 then
    FThumbnailCount :=  FThumbnailCount - 1;
  FOwner.BuildItems;
end;

procedure TThumbnails.SetItem(Index: Integer; const Value: TThumbnail);
begin
  inherited SetItem(Index, Value);
end;

procedure TThumbnailList.Loaded;
begin
  inherited;
  BuildItems;
end;

procedure TThumbnailList.SetShowCaption(const Value: Boolean);
begin
  if FShowCaption <> Value then
  begin
    FShowCaption := Value;
    Invalidate;
  end;
end;

procedure TThumbnailList.UpdateHorzScroll;
begin
  if Orientation <> toVertical then
    Columns := FThumbnails.Count;
end;

procedure TThumbnailList.CreateParams(var Params:TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_HSCROLL;
end;


procedure TThumbnailList.SetThumbnailSize(const Value: Integer);
begin
  FThumbnailSize := Value;

  if Orientation = toVertical then
  begin
    ItemHeight := Value;
    if Columns > 0 then
      SendMessage(Handle,LB_SETCOLUMNWIDTH,Value,0);
  end
  else
  begin
    SendMessage(Handle,LB_SETCOLUMNWIDTH,Value,0);
    ItemHeight := Height - GetSystemMetrics(SM_CYHSCROLL) - 4 * GetSystemMetrics(SM_CYBORDER);
    Columns := FThumbnails.Count;
  end;
end;

procedure TThumbnailList.WMSize(var Message: TWMSize);
var
  NewItemHeight: Integer;
begin
  inherited;

  if Orientation = toHorizontal then
  begin
    if FThumbnailSize > 0 then
      SendMessage(Handle,LB_SETCOLUMNWIDTH,FThumbnailSize,0);

    if not (csLoading in ComponentState) then
    begin
      NewItemHeight := Height - GetSystemMetrics(SM_CYHSCROLL) - 4 * GetSystemMetrics(SM_CYBORDER);
      if NewItemHeight > 0 then
        ItemHeight := NewItemHeight;
    end;
  end
  else
  begin
    Invalidate;
  end;
end;

procedure TThumbnailList.ShowFolder(FolderName: string);
var
  SR: TSearchRec;

  procedure AddToList(Name:string);
  var
    Ext: string;
  begin
    Ext := Uppercase(ExtractFileExt(Name));
    if (Ext = '.JPG') or (Ext = '.JPEG') or (Ext = '.GIF') or
       (Ext = '.BMP') or (Ext = '.ICO') or (Ext = '.WMF') then
      with FThumbnails.Add do
      begin
        FileName := ExtractFilePath(FolderName) + Name;
        Source := tsFile;
        Caption := Name;
        if not FBuffered then
          Picture.LoadFromFile(Filename);
      end;
  end;

begin
  FThumbnails.Clear;

  if FindFirst(FolderName,faAnyFile,SR) = 0 then
  begin
    AddToList(SR.Name);
    while FindNext(SR) = 0 do
    begin
      AddToList(SR.Name);
    end;
  end;

  FindClose(SR);
end;

procedure TThumbnailList.SetBounds(ALeft, ATop, AWidth, AHeight: Integer); 
var
  NewC: Integer;
begin
  inherited;
  if (Columns > 0) and (Orientation = toVertical) then
  begin
    NewC := AWidth div FThumbnailSize;

    if (NewC > 0) and (NewC <> Columns) then
      Columns := NewC;
  end;
end;

procedure TThumbnailList.SetShowSelection(const Value: Boolean);
begin
  if FShowSelection <> Value then
  begin
    FShowSelection := Value;
    Invalidate;
  end;
end;

procedure TThumbnailList.BeginUpdate;
begin
  inc(FUpdateCount);
end;

procedure TThumbnailList.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    dec(FUpdateCount);
    if FUpdateCount = 0 then
      BuildItems;
  end;
end;

end.
