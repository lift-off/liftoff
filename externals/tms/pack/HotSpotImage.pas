{*************************************************************************}
{ THotSpotImage component                                                 }
{ for Delphi & C++Builder                                                 }
{ version 1.1 - rel. August, 2002                                         }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright © 2002                                              }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit HotSpotImage;

interface

{$I TMSDEFS.INC}

uses
  Classes, SysUtils, ExtCtrls, Windows, Math, Graphics, Messages, Controls,
  Forms, Dialogs;

const
  CornerSize = 5;
  EllipseTolerance= 0.15;
  NameLength = 50;
  HintLength = 255;
  
type
  THotSpotImage = class;

  THoverPosition = (hpNone, hpInside, hpBorder);

  TSpotShapeType = (stRectangle, stEllipse, stPolygon);

  TBorderPoly = (bNone,bInside,bPoint,bLine);

  TRealPoint = record
    x,y: Real;
  end;

  TPoints = array of TRealPoint;
  TIntPoints = array of TPoint;
  THotSpots = class;

  //class used internally; not meant to be accessed by the user
  
  THotSpotShape = class(TPersistent)
  private
    FTop: Integer;
    FLeft: Integer;
    FHeight: Integer;
    FWidth: Integer;
    FAngle: Integer;
    FShapeType: TSpotShapeType;
    FPoints: TPoints;
    FEx1,FEx2,FEy1,FEy2: Real;
    function EllipsePos(X, Y: Integer): THoverPosition;
    function PolyPos(X, Y: Integer): THoverPosition;
    procedure SetPoints(const Value: TPoints);
    procedure SetAngle(const Value: Integer);
  public
    procedure calcMargins;
    procedure fillEllipse(Canvas:TCanvas;Pts:TIntPoints);
    function BorderPolypos(X,Y:Integer;var p1,p2:integer):TBorderPoly;
    procedure EllipseToBezier;
    constructor Create(Shape: TSpotShapeType);
    destructor Destroy;override;
    function RectPos(X, Y: Integer): THoverPosition;
    function GetHoverPos(X, Y: Integer): THoverPosition;
    procedure Draw(Canvas :TCanvas);
    procedure DrawAt(Canvas :TCanvas; X,Y: Integer);
    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
    property Height: Integer read FHeight write FHeight;
    property Width: Integer read FWidth write FWidth;
    property ShapeType: TSpotShapeType read FShapeType write FShapeType;
    property Points: TPoints read FPoints write SetPoints;
    property Angle: Integer read FAngle write SetAngle;
  end;

  THotSpot = class(TCollectionItem)
  private
    FHoverPicture: TPicture;
    FClickPicture: TPicture;
    FPicture: TPicture;
    FCClick : TBitmap;
    FCHover : TBitmap;
    FShape: THotSpotShape;
    FHint: String;
    FName: String;
    FID: Integer;
    FClipped: Boolean;
    FOwner: THotSPots;
    FDown: Boolean;
    FShowClick: Boolean;
    //calculate the hover&click images based on the clipping property
    procedure CalcClip(const Pict: TPicture;var Bitm: TBitmap);
    procedure SetShapeType(const Value: TSpotShapeType);
    procedure SetClickPicture(const Value: TPicture);
    procedure SetHoverPicture(const Value: TPicture);
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetX: Integer;
    function GetY: Integer;
    function GetX2: Integer;
    function GetY2: Integer;
    function GetShapeType: TSpotShapeType;
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
    procedure SetX(const Value: Integer);
    procedure SetY(const Value: Integer);
    procedure SetX2(const Value: Integer);
    procedure SetY2(const Value: Integer);
    procedure setPolyPoints(const Value:TPoints);
    function getPolyPoints:TPoints;
    procedure setPolyPoint(i:Integer;const Value:TRealPoint);
    function getPolyPoint(i:Integer):TRealPoint;
    function GetAngle: Integer;
    procedure SetAngle(const Value: Integer);
    procedure SetClipped(const Value: Boolean);
    procedure SetDown(const Value: Boolean);
    procedure SetShowClick(const Value: Boolean);

  protected
    function GetDisplayName: String; override;
    procedure DefineProperties(Filer: TFiler);override;
    procedure StorePoints(Writer: TWriter);
    procedure LoadPoints(Reader: TReader);
    procedure HoverPictureChange(Sender: TObject);
    procedure ClickPictureChange(Sender: TObject);

  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    //scale ellipse with the factor derived from the difference p2-p1; the points
    //are rotated with the angle of the ellipse before substraction
    //used in the editor; not meant to be used by the user
    procedure ScaleEllipse(p1,p2,ps:TPoint);
    //draw the shape of the hotspot
    procedure DrawShape(Canvas: TCanvas);
    procedure DrawShapeAt(Canvas: TCanvas; X,Y: Integer);
    function AsRect: TRect;
    //is (x,y) inside ?
    function GetHoverPos(X, Y: Integer): THoverPosition;
    //get position relative to the bounding rectangle
    function GetRectHoverPos(X, Y: Integer): THoverPosition;
    //Get point position relative to the polygon, considering the following situations:
    // inside,over a point, over a segment
    function GetBorderPolypos(X,Y:Integer;var p1,p2:integer):TBorderPoly;
    procedure Assign(Source: TPersistent); override;
    //Set Bounding Rectangle
    procedure SetRect(AX1, AY1, AX2, AY2: Integer); overload;
    procedure SetRect(R: TRect); overload;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);

    property X1: Integer read GetX write SetX;
    property Y1: Integer read GetY write SetY;
    property X2: Integer read GetX2 write SetX2;
    property Y2: Integer read GetY2 write SetY2;
    //large scale manipulation of the points; to be processed only as a whole i.e.
    //DO NOT do polypoints[i]:= something
    property PolyPoints: TPoints read getPolyPoints write setPolyPoints;
    //Access one point of the polygon; it assures coherence of the width&height
    property PolyPoint[i:Integer]: TRealPoint read getPolyPoint write setPolyPoint;
  published
    //It can be one of stPolygon stEllipse; changing shapetype is NOT recommended as it merely
    //changes the way shape points are interpreted
    property ShapeType: TSpotShapeType read GetShapeType write SetShapeType;
    property Hint: String read FHint write FHint;
    property Name: String read FName write FName;
    property ID: integer read FID write FID;
    property X: Integer read GetX write SetX;
    property Y: Integer read GetY write SetY;
    //set width & height not recommended for scaling angled ellipses - the outcome is somewhat strange
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    //Hover & Click Pictures
    property HoverImage: TPicture read FHoverPicture write SetHoverPicture;
    property ClickImage: TPicture read FClickPicture write SetClickPicture;
    //Hover & Click Clipped Bitmaps
    property HoverClippedBitmap: TBitmap read FCHover;
    property ClickClippedBitmap: TBitmap read FCClick;
    // The angle of the hotspot relative to Ox
    property Angle: Integer read GetAngle write SetAngle stored False;
    //True: shape clips hover&click picture
    property Clipped : Boolean read FClipped write SetClipped;
    property Down: Boolean read FDown write SetDown;
    property ShowClick: Boolean read FShowClick write SetShowClick default false;
  end;

  THotSpots = class(TCollection)
  private
    FOwner: THotSpotImage;
    oldHeight,oldWidth:integer;
    function GetItem(Index: Integer): THotSpot;
    procedure SetItem(Index: Integer; const Value: THotSpot);
  protected
    function GetHotSpotImage: THotSpotImage;
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner: THotSpotImage);
    function Add: THotSpot;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);
    procedure SaveToFile(FName: TFileName);
    procedure LoadFromFile(FName: TFileName);
    procedure ReScale(newWidth,newHeight: Integer);overload;
    procedure ReScale(delta: Integer);overload;
    function GetOwner: TPersistent; override;
    property Items[Index: Integer]: THotSpot read GetItem write SetItem; default;
  end;

  THotSpotEvent = procedure(Sender: TObject; HotSpot: THotSpot) of object;

  THotSpotImage = class(TGraphicControl)
  private
    FOwner: TControl;
    FHotSpots: THotSpots;
    FPicture: TPicture;
    FHoveredItem: Integer;
    FClickedItem: Integer;
    FBitmap: TBitmap;
    FColor: TColor;
    isMouseUp: Boolean;
    isDblClick: Boolean;
    FOnHotSpotExit: THotSpotEvent;
    FOnHotSpotEnter: THotSpotEvent;
    FOnHotSpotClick: THotSpotEvent;
    FOnHotSpotRightClick: THotSpotEvent;
    FOnHotSpotDblClick: THotSpotEvent;
    FTransparent: Boolean;
    FAutoSize: Boolean;
    FStretch: Boolean;
    FHotSpotCursor: TCursor;
    FOrigCursor: TCursor;
    //AppEv:TApplicationEvents;
    procedure SetHotSpots(const Value: THotSpots);
    procedure SetPicture(const Value: TPicture);
    procedure SetHoveredItem(const Value: Integer);
    procedure SetColor(const Value: TColor);
    procedure SetTransparent(const Value: Boolean);
    procedure SetAutoSizeEx(const Value: Boolean);
    function  GetHotSpotXY(x, y: Integer): THotSpot;
    procedure SetStretch(const Value: Boolean);
  protected
    procedure Paint; override;
    procedure DrawHoverImage(HotSpotIndex: Integer;canv:TCanvas = nil);
    procedure DrawClickImage(HotSpotIndex: Integer;canv:TCanvas = nil);
    procedure RestoreHotSpot(HotSpotIndex: Integer);
    procedure CMHintShow(var M: TMessage); message CM_HINTSHOW;
    procedure CMMouseLeave(Var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(Var Msg: TMessage); message CM_MOUSEENTER;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DblClick; override;
    procedure PictureChanged(Sender: TObject);
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    //the number of the hovered item
    property HoveredItem: Integer read FHoveredItem write SetHoveredItem;
    property HotSpotXY[x,y: Integer]: THotSpot read GetHotSpotXY;
  published
    property Align;
    property Anchors;
    property AutoSize: Boolean read FAutoSize write SetAutoSizeEx;
    property Color: TColor read FColor write SetColor;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property HotSpotCursor: TCursor read FHotSpotCursor write FHotSpotCursor; 
    //the hotspot list
    property HotSpots: THotSpots read FHotSpots write SetHotSpots;
    //background picture
    property Picture: TPicture read FPicture write SetPicture;
    property PopupMenu;
    property ShowHint;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property Stretch: Boolean read FStretch write SetStretch;
    property Visible;
    //background color
    property OnClick;
    property OnDblClick;
    property OnHotSpotEnter: THotSpotEvent read FOnHotSpotEnter write FOnHotSpotEnter;
    property OnHotSpotExit: THotSpotEvent read FOnHotSpotExit write FOnHotSpotExit;
    property OnHotSpotClick: THotSpotEvent read FOnHotSpotClick write FOnHotSpotClick;
    property OnHotSpotRightClick: THotSpotEvent read FOnHotSpotRightClick write FOnHotSpotRightClick;
    property OnHotSpotDblClick: THotSpotEvent read FOnHotSpotDblClick write FOnHotSpotDblClick;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnStartDrag;
  end;


function ReadInteger(S: TStream): Integer;
function ReadString(S: TStream; Size: Byte): String;
procedure WriteString(S: TStream; Buffer: String);
procedure WriteInteger(S: TStream; Buffer: Integer);

function Between(Value, Min, Max: Integer): Boolean;overload;
function Between(Value, Min, Max: Real): Boolean;overload;

function Intersect(p1, p2, p3, p4:TPoint): Boolean;
function CCW(p0, p1, p2:TPoint): Integer;
function PRound(Value:TRealPoint): TPoint;
function RPoint(x,y:Real): TRealPoint;
function EmptyImage(Image: TPicture): Boolean;


//============================================================ IMPLEMENTATION ==
implementation

uses
  LineLibrary;

const
  EToBConst:Real = 0.2761423749154;



{/*************************************************************************

 * FUNCTION:   Intersect
 *
 * PURPOSE
 * Given two line segments, determine if they intersect.
 *
 * RETURN VALUE
 * TRUE if they intersect, FALSE if not.

 *************************************************************************/}
function Intersect(p1, p2, p3, p4:TPoint):boolean;
begin
   Result:=((( CCW(p1, p2, p3) * CCW(p1, p2, p4)) <= 0)
        and (( CCW(p3, p4, p1) * CCW(p3, p4, p2)  <= 0) )) ;
end;

{/*************************************************************************

 * FUNCTION:   CCW (CounterClockWise)
 *
 * PURPOSE
 * Determines, given three points, if when travelling from the first to
 * the second to the third, we travel in a counterclockwise direction.

 *
 * RETURN VALUE
 * (int) 1 if the movement is in a counterclockwise direction, -1 if
 * not.
 *************************************************************************/
}

function CCW(p0, p1, p2:TPoint):Integer;
var dx1, dx2:integer;
    dy1, dy2:integer;
begin
   dx1 := p1.x - p0.x ; dx2 := p2.x - p0.x ;
   dy1 := p1.y - p0.y ; dy2 := p2.y - p0.y ;

{   /* This is basically a slope comparison: we don't do divisions because
    * of divide by zero possibilities with pure horizontal and pure
    * vertical lines.
    */}
  if (dx1*dy2)>(dy1*dx2) then Result:=1
                         else Result:=-1;
end;

//------------------------------------------------------------------------------
function EmptyImage(Image: TPicture): Boolean;
begin
  Result := (Image.Width = 0) and (Image.Height = 0);
end;

//------------------------------------------------------------------------------
function PRound(Value:TRealPoint):TPoint;
begin
  Result.x:=Round(Value.x);
  Result.y:=Round(Value.y);
end;

//------------------------------------------------------------------------------
function RPoint(x,y:Real):TRealPoint;
begin
  Result.x:=x;
  Result.y:=y;
end;

//------------------------------------------------------------------------------
function Between(Value, Min, Max: Integer): Boolean;
begin
  Result := (Value >= Min) and (Value <=  Max);
end;

//------------------------------------------------------------------------------
function Between(Value, Min, Max: Real): Boolean;
begin
  Result := (Value >= Min) and (Value <=  Max);
end;

//------------------------------------------------------------------------------
procedure WriteInteger(S: TStream; Buffer: Integer);
begin
  S.Write(Buffer, SizeOf(Integer));
end;

//------------------------------------------------------------------------------
procedure WriteString(S: TStream; Buffer: String);
var BufSize: Integer;
begin
  BufSize := Length(Buffer);
  S.Write(Buffer[1], BufSize);
end;

//------------------------------------------------------------------------------
function ReadString(S: TStream; Size: Byte): String;
var Buffer: array[1..256] of Char;
begin
  FillChar(Buffer, 256, 0);
  S.Read(Buffer, Size);
  Result := Copy(Buffer, 1, Size);
end;

//------------------------------------------------------------------------------
function ReadInteger(S: TStream): Integer;
begin
  S.Read(Result, SizeOf(Integer));
end;

{ THotSpots }

//------------------------------------------------------------------------------
function THotSpots.Add: THotSpot;
begin
  Result := THotSpot(inherited Add);
end;

//------------------------------------------------------------------------------
procedure THotSpots.Assign(Source: TPersistent);
var
  i: Integer;
  S: THotSpots;
begin
  inherited;
  S := THotSpots(Source);
  if S=nil then exit;
  oldHeight:=S.oldHeight;
  oldWidth:=S.oldWidth;
  Clear;
  for i := 0 to S.Count-1 do
    Add.Assign(S[i]);
end;

//------------------------------------------------------------------------------
constructor THotSpots.Create(AOwner: THotSpotImage);
begin
  inherited Create(THotSpot);
  FOwner := AOwner;
end;

//------------------------------------------------------------------------------
function THotSpots.GetHotSpotImage: THotSpotImage;
begin
  Result := THotSpotImage(FOwner);
end;

//------------------------------------------------------------------------------
function THotSpots.GetItem(Index: Integer): THotSpot;
begin
  Result := THotSpot(inherited GetItem(Index));
end;

//------------------------------------------------------------------------------
function THotSpots.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

//------------------------------------------------------------------------------
procedure THotSpots.LoadFromFile(FName: TFileName);
var F: TFileStream;
begin
  F := TFileStream.Create(FName, fmOpenRead or fmShareExclusive);
  try
    LoadFromStream(F);
  finally
    F.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure THotSpots.LoadFromStream(S: TStream);
var i, n: Integer;
begin
  if ReadString(S, 4) <> 'HSF1' then
    raise Exception.Create('Incorrect data found while attempting to load hot spots.');
  n := ReadInteger(S);
  for i := 1 to n do
    Add.LoadFromStream(S);
end;

//------------------------------------------------------------------------------
procedure THotSpots.ReScale(newWidth, newHeight: Integer);
var
     i:integer;
     deltaX,deltaY,a,b,c,d:real;
begin
  if (oldWidth=0)or(newWidth=0)or
     (oldHeight=0)or(newHeight=0) then exit;
  if (FOwner<>nil) then
  if (csLoading in FOwner.ComponentState)or (csReading	in FOwner.ComponentState) then exit;
  deltaX:=newWidth/ oldWidth;
  deltaY:=newHeight/ oldHeight;
  oldWidth:=newWidth;
  oldHeight:=newHeight;
  for i:= 0 to Count-1 do
  with Items[i] do
  if FShape.ShapeType<>stEllipse then
  Begin
    a:= X1;b:=X2;c:=y1;d:=y2;
    X1 := Round(a*deltaX);
    Y1 := Round(c*deltaY);
    X2 := Round(b*deltaX);
    Y2 := Round(d*deltaY);
  End
  else
    Begin
      SetRect(Round(X1*deltaX),Round(Y1*deltaY),Round(X2*deltaX),Round(Y2*deltaY));
      CalcClip(FHoverPicture,FCHover);
      CalcClip(FClickPicture,FCClick);
    End;
  if (FOwner<>nil) then
    FOwner.Invalidate();
end;

//------------------------------------------------------------------------------
procedure THotSpots.ReScale(delta: Integer);
begin
  ReScale(oldWidth+delta,oldHeight+delta);
end;

procedure THotSpots.SaveToFile(FName: TFileName);
var F: TFileStream;
begin
  F := TFileStream.Create(FName, fmCreate or fmShareExclusive);
  try
    SaveToStream(F);
  finally
    F.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure THotSpots.SaveToStream(S: TStream);
var i: Integer;
begin
  WriteString(S, 'HSF1');
  WriteInteger(S, Count);
  for i := 0 to Count-1 do Items[i].SavetoStream(S);
end;

//------------------------------------------------------------------------------
procedure THotSpots.SetItem(Index: Integer; const Value: THotSpot);
begin
  inherited SetItem(Index, Value);
end;

{ THotSpot }

//------------------------------------------------------------------------------
function THotSpot.GetHeight: Integer;
begin
  Result := FShape.Height;
end;

//------------------------------------------------------------------------------
function THotSpot.GetWidth: Integer;
begin
  Result := FShape.Width;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetWidth(const Value: Integer);
var
  sang,i: Integer;
  f,xf,a: Real;
begin
  if FShape.Width = Value then
    Exit;

  if (FShape.Points = nil) or (FShape.Width = 0) then
  begin
    SetRect(x1,y1,FShape.Left + Value,y2);
    Exit;
  end;

  sang := Angle;

  if ShapeType = stEllipse then
  with FShape do
  begin
    Angle := 0;
    xf := FEx1 + (FEx2 - FEx1) / 2;
  end
  else
    xf := FShape.Left;

  f := Value / FShape.Width;
  a := xf - xf * f;
  for i := 0 to High(FShape.Points) do
    FShape.Points[i].x := FShape.Points[i].x * f + a;

  FShape.Width := Value;
  if ShapeType = stEllipse then
  begin
    Angle := sang;
    FShape.calcMargins;
  end;
  CalcClip(FHoverPicture,FCHover);
  CalcClip(FClickPicture,FCClick);
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetHeight(const Value: Integer);
var
  sang,i: Integer;
  yf,a,f: Real;
begin
  if (FShape.Points = nil) or (FShape.Height = 0) then
  begin
    SetRect(x1,y1,x2,FShape.Top+Value);
    Exit;
  end;

  sang := Angle;

  if ShapeType = stEllipse then
  with FShape do
  begin
    Angle := 0;
    yf := FEy1 + (FEy2 - FEy1) / 2;
  end
  else
    yf := FShape.Top;

  f := Value/FShape.Height;

  a := yf - yf * f;

  for i := 0 to High(FShape.Points) do
    FShape.Points[i].y := FShape.Points[i].y * f + a;
  FShape.Height := Value;

  if ShapeType = stEllipse then
  begin
    Angle := sang;
    FShape.calcMargins;
  end;
  
  CalcClip(FHoverPicture,FCHover);
  CalcClip(FClickPicture,FCClick);
end;

//------------------------------------------------------------------------------
function THotSpot.GetX: Integer;
begin
  Result := FShape.Left;
end;

//------------------------------------------------------------------------------
function THotSpot.GetY: Integer;
begin
  Result := FShape.Top;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetX(const Value: Integer);
var
  i,delta: Integer;
begin
  if FShape.Left = Value then
    Exit;

  delta := Value - FShape.Left;
  for i := 0 to High(FShape.Points) do
    FShape.Points[i].x := FShape.Points[i].x + delta;

  if ShapeType = stEllipse then
    FShape.CalcMargins;
    
  FShape.Left := Value;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetY(const Value: Integer);
var
  i,delta: Integer;
begin
  if FShape.Top = Value then
    Exit;

  delta := Value - FShape.Top;

  for i := 0 to High(FShape.Points) do
    FShape.Points[i].y := FShape.Points[i].y + delta;

  if ShapeType = stEllipse then
    FShape.CalcMargins;

  FShape.Top := Value;
end;

//------------------------------------------------------------------------------
function THotSpot.GetX2: Integer;
begin
  Result := X1 + Width;
end;

//------------------------------------------------------------------------------
function THotSpot.GetY2: Integer;
begin
  Result := Y1 + Height;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetX2(const Value: Integer);
begin
  Width := Value - X1;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetY2(const Value: Integer);
begin
  Height := Value - Y1;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetPolyPoints;
begin
  FShape.Points:= Value;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetPolyPoint;
begin
  if (i < 0) or (i > High(FShape.Points)) then
    Exit;

  FShape.Points[i] := Value;
  if Value.X < X then
  begin
    FShape.Width := Round(FShape.Width+x-Value.x);
    FShape.Left := Round(Value.X);
  end;

  if Value.Y<Y then
  begin
    FShape.Height := Round(FShape.Height+y-Value.y);
    FShape.Top := Round(Value.Y);
  end;

  if (Value.X-FShape.Left) > FShape.Width then
    FShape.Width := Round(Value.X-FShape.Left);

  if (Value.y-FShape.Top) > FShape.Height then
    FShape.Height := Round(Value.Y-FShape.Top);
end;

//------------------------------------------------------------------------------
procedure THotSpot.LoadPoints(Reader: TReader);
var
  i,l: Integer;
begin
  Reader.ReadListBegin;
  l := Reader.ReadInteger;
  FShape.FAngle := Reader.ReadInteger;
  if l > 0 then
  begin
    SetLength(FShape.FPoints,l);
    for i := 0 to l - 1 do
    begin
      FShape.FPoints[i].x := Reader.ReadFloat;
      FShape.FPoints[i].y := Reader.ReadFloat;
    end;
    FShape.CalcMargins;
  end;
  Reader.ReadListEnd;
end;

//------------------------------------------------------------------------------
procedure THotSpot.StorePoints(Writer: TWriter);
var
  i,l: Integer;
begin
  Writer.WriteListBegin;
  l := Length(FShape.FPoints);
  Writer.WriteInteger(l);
  Writer.WriteInteger(FShape.FAngle);
  if l > 0 then
    for i := 0 to l - 1 do
    begin
      Writer.WriteFloat(FShape.FPoints[i].x);
      Writer.writeFloat(FShape.FPoints[i].y);
    end;
  Writer.WriteListEnd;
end;

//------------------------------------------------------------------------------
procedure THotSpot.DefineProperties(Filer: TFiler);
begin
  inherited; { allow base classes to define properties }
  Filer.DefineProperty('PolyPoints', LoadPoints, StorePoints, True);
end;

//------------------------------------------------------------------------------
function THotSpot.getPolyPoints;
begin
  Result := FShape.Points;
end;

//------------------------------------------------------------------------------
function THotSpot.getPolyPoint;
begin
  if (i < 0) or (i > High(FShape.Points)) then
  begin
    Result.x := -1;
    Result.y := -1;
    Exit;
  end;
  Result := FShape.Points[i];
end;

//------------------------------------------------------------------------------
function THotSpot.GetAngle: Integer;
begin
  Result := FShape.Angle;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetAngle(const Value: Integer);
begin
  FShape.Angle := Value;
end;

//------------------------------------------------------------------------------
procedure THotSpot.ScaleEllipse;
var
  i: Integer;
  signx,signy,ew,eh,tt,tx,ty,sx,sy,cosu,sinu,a,b,c,d,e,f: Extended;
  pp1,pp2,pps: TRealPoint;
begin
  if (Shapetype <> stEllipse) or (Length(FShape.FPoints) < 12) then
    Exit;

  //calculating sinu,cosu and translation factors
  tx := -(FShape.FEx1+(FShape.FEx2-FShape.FEx1)/2);
  ty := -(FShape.FEy1+(FShape.FEy2-FShape.FEy1)/2);
  SinCos((FShape.FAngle*Pi)/180,sinu,cosu);
  //rotating the points so as to be at 0 degrees compared to the ellipse
  pp1 := RPoint(p1.x,p1.y);
  pp2 := RPoint(p2.x,p2.y);
  pps := RPoint(ps.x,ps.y);

  pp1.x := pp1.x + tx;
  pp1.y := pp1.y + ty;

  pp2.x := pp2.x + tx;
  pp2.y := pp2.y + ty;

  pps.x := pps.x + tx;
  pps.y := pps.y + ty;

  tt := pp1.x*cosu-pp1.y*sinu;
  pp1.y := pp1.y*cosu+pp1.x*sinu;
  pp1.x := tt;

  tt := pp2.x*cosu-pp2.y*sinu;
  pp2.y := pp2.y*cosu+pp2.x*sinu;
  pp2.x := tt;

  tt := pps.x*cosu-pps.y*sinu;
  pps.y := pps.y*cosu+pps.x*sinu;
  pps.x := tt;
  //adjusting the sign of scaling relative to the position of the center
  if pps.x < 0 then signx := -1
               else signx := 1;
  if pps.y < 0 then signy := -1
               else signy := 1;

  //current width&height
  with FShape do
  begin
    ew := sqrt((FPoints[6].x-FPoints[0].x)*(FPoints[6].x-FPoints[0].x)+
              (FPoints[6].y-FPoints[0].y)*(FPoints[6].y-FPoints[0].y));
    eh := sqrt((FPoints[9].x-FPoints[3].x)*(FPoints[9].x-FPoints[3].x)+
              (FPoints[9].y-FPoints[3].y)*(FPoints[9].y-FPoints[3].y));
  end;
  //scaling factors
  if (ew = 0) or (eh = 0) then
    Exit;
    
  sx := (ew-signx*(pp2.x-pp1.x))/ew;
  sy := (eh-signy*(pp2.y-pp1.y))/eh;
  
  if ((ew*sx) < 10) and (sx < 1) then
    sx := 1;
  if ((eh*sy) < 10) and (sy < 1) then
    sy := 1;

  //calculating transformation parameters
  //t:=translate(tx,ty)*rotate(u)*scale(sx,sy)*rotate(-u)*translate(-tx,-ty)
  a := cosu*cosu*sx+sy-cosu*cosu*sy;
  b := -cosu*sinu*(sx-sy);
  c := b;
  d := sx+cosu*cosu*(sy-sx);
  e := sx*cosu*cosu*tx-sx*cosu*ty*sinu+sy*tx-sy*tx*cosu*cosu+sy*sinu*ty*cosu-tx;
  f := -sx*sinu*tx*cosu+sx*ty-sx*ty*cosu*cosu+sy*cosu*tx*sinu+sy*cosu*cosu*ty-ty;
  for i := 0 to High(FShape.FPoints) do with FShape.FPoints[i] do
  begin
   tt := x*a+y*c+e;
   y := x*b+y*d+f;
   x := tt;
  end;
  //and calculating new margins
  FShape.CalcMargins;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetClipped(const Value: Boolean);
begin
  FClipped := Value;
  CalcClip(FHoverPicture,FCHover);
  CalcClip(FClickPicture,FCClick);
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetDown(const Value: Boolean);
begin
  FDown := Value;
  (Collection as THotSpots).GetHotSpotImage.Invalidate;
end;


//------------------------------------------------------------------------------
procedure THotSpot.CalcClip(const Pict: TPicture; var Bitm: TBitmap);
var
  source: TBitmap;
  images: THotSpotImage;
  i,j: Integer;
  a,b,c,d,okW,okH: Integer;
  clipRGN: HRGN;
  r: TRect;
  tempPoints: TIntPoints;
begin
  clipRGN := 0;

  images := (Collection as THotSpots).GetHotSpotImage;
  if EmptyImage(Pict) or (images = nil) then
  begin
    Bitm.Height := 0;
    Bitm.Width := 0;
    Exit;
  end;

  if images.FStretch then
  begin
    okW := Width;
    okH := Height;
    a := Round(X1 * images.FPicture.Width / images.Width);
    b := Round(Y1 * images.FPicture.Height / images.Height);
    c := Round(X2 * images.FPicture.Width / images.Width);
    d := Round(Y2 * images.FPicture.Height / images.Height);
  end
  else
  begin
    okW := min(Width,Pict.Width);
    okH := min(Height,Pict.Height);
    a := X1;
    b := Y1;
    c := X2;
    d := Y2;
  end;
  bitm.Height := okH; //background;
  bitm.Width := okW;
  if Assigned(FPicture) and (not EmptyImage(FPicture)) then
  begin
    source := TBitmap.Create;
    try
      source.PixelFormat := pf24bit;
      Source.Width := FPicture.Width;
      Source.Height := FPicture.Height;
      Source.Canvas.Draw(0,0,FPicture.Graphic);
      r := Rect(0,0,okW,okH);
      bitm.Canvas.CopyRect(r,source.Canvas,Rect(a,b,c,d));
    finally
      source.free;
    end;

    if FClipped then
    begin
      if FShape.FShapeType <> stEllipse then
      begin
        j:=High(FShape.Points);
        SetLength(tempPoints,(j+1));
        for i:=0 to j do
          begin
            tempPoints[i].x:=Round(FShape.Points[i].X)-X1;
            tempPoints[i].y:=Round(FShape.Points[i].Y)-Y1;
          end;
        clipRGN := CreatePolygonRgn(tempPoints[0],j+1,  ALTERNATE);
      end
      else
        clipRGN := CreateEllipticRgn(0,0,okW,okH);
        
      if clipRGN <> 0 then
        SelectClipRgn(bitm.Canvas.Handle,clipRGN);
    end;
    
    if images.Stretch then
      bitm.Canvas.StretchDraw(r,Pict.Graphic)
    else
      bitm.Canvas.Draw(0,0,Pict.Graphic);
      
    if FClipped then
    begin
      SelectClipRgn(bitm.Canvas.Handle,0);
      if clipRGN <> 0 then
        DeleteObject(clipRGN);
    end;
    
  end;
end;

//------------------------------------------------------------------------------
function THotSpot.GetBorderPolypos(X,Y:Integer;var p1,p2:integer):TBorderPoly;
begin
  Result := FShape.BorderPolypos(x,y,p1,p2);
end;

//------------------------------------------------------------------------------
function THotSpot.GetDisplayName: String;
begin
  Result := 'HotSpot' + IntToStr(Index);
end;

//------------------------------------------------------------------------------
procedure THotSpot.Assign(Source: TPersistent);
var
  S: THotSpot;
begin
  S := THotSpot(Source);
  Hint := S.Hint;
  SetRect(S.X1, S.Y1, S.X2, S.Y2);
  FClipped := S.FClipped;
  HoverImage.Assign(S.HoverImage);
  ClickImage.Assign(S.ClickImage);

  // Added the name,id&shapetype
  Name := S.Name;
  Id := S.Id;
  ShapeType := S.ShapeType;
  PolyPoints := S.PolyPoints;
  FShape.FAngle := S.FShape.FAngle;
end;

//------------------------------------------------------------------------------
function THotSpot.GetHoverPos(X, Y: Integer): THoverPosition;
begin
  if FPicture = nil then
  begin
    if (FOwner <> nil) and (FOwner.FOwner <> nil) then
    begin
      FPicture := (FOwner.getOwner as THotSpotImage).FPicture;
      CalcClip(FHoverPicture,FCHover);
      CalcClip(FClickPicture,FCClick);
    end;
  end
  else
    if (EmptyImage(FPicture)) then
    begin
      if (FOwner <> nil) and (FOwner.FOwner <> nil) then
      begin
        FPicture := (FOwner.GetOwner as THotSpotImage).FPicture;
        CalcClip(FHoverPicture,FCHover);
        CalcClip(FClickPicture,FCClick);
      end;
    end;
  Result := FShape.GetHoverPos(x,y);
end;

//------------------------------------------------------------------------------
function THotSpot.GetRectHoverPos(X, Y: Integer): THoverPosition;
begin
  Result := FShape.RectPos(x,y);
end;

//------------------------------------------------------------------------------
procedure THotSpot.DrawShape(Canvas: TCanvas);
begin
  FShape.Draw(Canvas);
end;

//------------------------------------------------------------------------------
procedure THotSpot.DrawShapeAt(Canvas: TCanvas;X,Y: Integer);
begin
  FShape.DrawAt(Canvas,X,Y);
end;

//------------------------------------------------------------------------------
function THotSpot.AsRect: TRect;
begin
  Result := Rect(X1, Y1, X2, Y2);
end;


// helper methods for TPicture streaming

procedure WritePicture(Stream: TStream; Picture: TPicture);
var
  s: string;
  Str: TmemoryStream;
begin
  s := GraphicExtension(TGraphicClass(Picture.Graphic.ClassType));
  SetLength(s,3);
  WriteString(Stream, S);
  Str := TMemoryStream.Create;
  try
    Picture.Graphic.SaveToStream(Str);
    WriteInteger(Stream, Str.Size);
    Str.Position := 0;
    Stream.CopyFrom(Str, Str.Size)
  finally
    Str.free
  end;
end;

function AddBackslash(const s: string): string;
begin
  if (Length(s) >= 1) and (s[Length(s)]<>'\') then
    Result := s + '\'
  else
    Result := s;
end;


function TempDirectory: string;
var
  buf: array[0..MAX_PATH] of Char;
begin
  GetTempPath(sizeof(buf),buf);
  Result := AddBackslash(StrPas(buf));
end;


procedure ReadPicture(Stream: TStream; Picture: TPicture);
var
  s: string;
  tmp: TFileStream;
  i: integer;
begin
  s := ReadString(Stream,3);
  i := ReadInteger(Stream);
  s := TempDirectory+'tmp~.'+s;
  tmp := TFileStream.Create(s, fmCreate);
  try
    tmp.CopyFrom(Stream, i);
  finally
    tmp.Free;
  end;
  Picture.LoadFromFile(s);
  DeleteFile(pchar(s));
end;

//------------------------------------------------------------------------------
procedure THotSpot.LoadFromStream(S: TStream);
var
  tt: TPoints;
  i,j: Integer;
begin
  FName := ReadString(S,NameLength);

  X1 := ReadInteger(S);
  Y1 := ReadInteger(S);
  X2 := ReadInteger(S);
  Y2 := ReadInteger(S);
  FID := ReadInteger(S);
  Shapetype := TSpotShapeType(ReadInteger(S));
  if ShapeType = stPolygon then
  begin
    j := ReadInteger(S);

    SetLength(tt,j);

    for i := 0 to High(tt) do
    begin
      tt[i].x := ReadInteger(S);
      tt[i].y := ReadInteger(S);
    end;
    FShape.Points := tt;
  end;
  FShape.FAngle := ReadInteger(S);
  if ReadInteger(S) = 0 then
    Clipped := False
  else
    Clipped := True;
  FHint := ReadString(S,HintLength);

  i := ReadInteger(S);
  if i = 1 then
    ReadPicture(S,FHoverPicture);

  i := ReadInteger(S);
  if i = 1 then
    ReadPicture(S,FClickPicture);
end;

//------------------------------------------------------------------------------
procedure THotSpot.SaveToStream(S: TStream);
var
  i: Integer;
begin
  SetLength(Fname,NameLength);
  WriteString(S, FName);
  WriteInteger(S, X1);
  WriteInteger(S, Y1);
  WriteInteger(S, X2);
  WriteInteger(S, Y2);
  WriteInteger(S, FID);
  WriteInteger(S, ord(ShapeType));
  if ShapeType = stPolygon then
  begin
    WriteInteger(S, Length(FShape.Points));
    for i := 0 to High(FShape.Points) do
    begin
      WriteInteger(S, Round(FShape.Points[i].x));
      WriteInteger(S, Round(FShape.Points[i].y));
    end;
  end;
  WriteInteger(S, FShape.FAngle);
  if Clipped then
    WriteInteger(S,1)
  else
    WriteInteger(S,0);
  SetLength(FHint,HintLength);
  WriteString(S, FHint);

  if Assigned(FHoverPicture) and Assigned(FHoverPicture.Graphic) and not FHoverPicture.Graphic.Empty then
  begin
    WriteInteger(S, 1);
    WritePicture(S, FHoverPicture);
  end
  else
    WriteInteger(S,0);

  if Assigned(FClickPicture) and Assigned(FClickPicture.Graphic) and not FClickPicture.Graphic.Empty then
  begin
    WriteInteger(S, 1);
    WritePicture(S, FClickPicture);
  end
  else
    WriteInteger(S,0);
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetRect(AX1, AY1, AX2, AY2: Integer);
var
  tp: TPoints;
begin
  case FShape.ShapeType of
  stRectangle:
    begin
      SetLength(tp,4);
      tp[0].x := Min(AX1, AX2);
      tp[0].y := Min(AY1, AY2);
      tp[2].x := Max(AX1, AX2);
      tp[2].y := Max(AY1, AY2);

      tp[1].x := tp[2].x;
      tp[1].y := tp[0].y;
      tp[3].x := tp[0].x;
      tp[3].y := tp[2].y;
      FShape.CalcMargins;
      FShape.Points := tp;
    end;
  stEllipse:
    begin
      FShape.Left := Min(AX1, AX2);
      FShape.Top := Min(AY1, AY2);
      FShape.Width := Max(AX1, AX2)-FShape.Left;
      FShape.Height := Max(AY1, AY2)-FShape.Top;
      FShape.EllipseToBezier;
    end;
 end;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetRect(R: TRect);
var
  tp: TPoints;
begin
  case FShape.ShapeType of
  stRectangle:
    begin
      SetLength(tp,4);
      tp[0].x := Min(R.Left, R.Right);
      tp[0].y := Min(R.Top, R.Bottom);
      tp[1].x := Max(R.Left, R.Right);
      tp[1].y := Max(R.Top, R.Bottom);

      tp[1].x := tp[2].x;
      tp[1].y := tp[0].y;
      tp[3].x := tp[0].x;
      tp[3].y := tp[2].y;

      FShape.Points := tp;
      FShape.CalcMargins;
    end;
  stEllipse:
    begin
      FShape.Left := Min(R.Left, R.Right);
      FShape.Top := Min(R.Top, R.Bottom);
      FShape.Width := Max(R.Left, R.Right)-FShape.Left;
      FShape.Height := Max(R.Top, R.Bottom)-FShape.Top;
      FShape.EllipseToBezier;
    end;
 end;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetShapetype(const Value: TSpotShapeType );
begin
  FShape.ShapeType := Value;
  if Value = stEllipse then
    FShape.EllipseToBezier;

  CalcClip(FHoverPicture,FCHover);
  CalcClip(FClickPicture,FCClick);
end;

//------------------------------------------------------------------------------
function THotSpot.GetShapeType: TSpotShapeType;
begin
  Result := FShape.ShapeType;
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetClickPicture(const Value: TPicture);
begin
  FClickPicture.Assign(Value);
end;

//------------------------------------------------------------------------------
procedure THotSpot.SetHoverPicture(const Value: TPicture);
begin
  FHoverPicture.Assign(Value);
end;

//------------------------------------------------------------------------------
constructor THotSpot.Create(Collection: TCollection);
begin
  inherited;
  FHoverPicture := TPicture.Create;
  FClickPicture := TPicture.Create;
  FHoverPicture.OnChange := HoverPictureChange;
  FClickPicture.OnChange := ClickPictureChange;
  FCClick := TBitmap.Create;
  FCHover := TBitmap.Create;
  FShape := THotSpotShape.Create(stRectangle);
  FShowClick:=false;
  if Collection is THotSpots then
  begin
    FOwner := Collection as THotSpots;
  end;
end;

//------------------------------------------------------------------------------
destructor THotSpot.Destroy;
begin
  FHoverPicture.Free;
  FClickPicture.Free;
  FCClick.Free;
  FCHover.Free;
  inherited;
end;

procedure THotSpot.SetShowClick(const Value: Boolean);
begin
  FShowClick := Value;
  (Collection as THotSpots).GetHotSpotImage.Invalidate;
end;

{ THotSpotImage }

//------------------------------------------------------------------------------
procedure THotSpotImage.CMHintShow(var M: TMessage);
var
  HInfo: PHintInfo;
begin
  HInfo := PHintInfo(M.LParam);
  if FHoveredItem <> -1 then
    HInfo.HintStr := FHotSpots[FHoveredItem].Hint
  else
    HInfo.HintStr := Hint;
end;

procedure THotSpotImage.CMMouseEnter(var Msg: TMessage);
begin

end;

procedure THotSpotImage.CMMouseLeave(var Msg: TMessage);
begin
  if HoveredItem <> -1 then
  begin
    if Assigned(FOnHotSpotExit) then
      FOnHotSpotExit(Self, FHotSpots[HoveredItem]);
    HoveredItem := -1;
  end;
end;


//------------------------------------------------------------------------------
constructor THotSpotImage.Create(AOwner: TComponent);
begin
  inherited;

  if AOwner is TControl then
    FOwner := TControl(AOwner)
  else
    FOwner := nil;

  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;

  FHotSpotCursor := crDefault;
  FHotSpots := THotSpots.Create(Self);
  FHoveredItem := -1;
  FClickedItem := -1;
  FBitmap := TBitmap.Create;
  Width := 200;
  Height := 200;
end;

//------------------------------------------------------------------------------
destructor THotSpotImage.Destroy;
begin
  FHotSpots.Free;
  FPicture.Free;
  FBitmap.Free;
  inherited;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.DrawClickImage(HotSpotIndex: Integer;canv:TCanvas = nil);
var
  c:^TCanvas;
begin
  if (HotSpotIndex < 0) or (HotSpotIndex>= FHotSpots.Count) then
    Exit;

  if canv=nil then c:=@canvas
              else c:=@canv;
  with FHotSpots[HotSpotIndex] do
    if not EmptyImage(ClickImage) then
        c.Draw(X,Y,FCClick);
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.DrawHoverImage(HotSpotIndex: Integer;canv:TCanvas = nil);
var
  c:^TCanvas;
begin
  if (HotSpotIndex < 0) or (HotSpotIndex>= FHotSpots.Count) then
    Exit;
  if canv=nil then c:=@canvas
              else c:=@canv;
  with FHotSpots[HotSpotIndex] do
    if not EmptyImage(HoverImage) then
        c.Draw(X,Y,FCHover);
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.Paint;
var
  i: Integer;
  B: TBitmap;
  TC: TBitmap;
  r:TRect;
begin
  if not Assigned(FPicture.Graphic) then
  begin
    Canvas.Pen.Style := psDash;
    Canvas.Pen.Color := FColor;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0,0,Width,Height);
    Exit;
  end;
  r.Left:=0;
  r.Top:=0;
  r.Right:=FPicture.Graphic.Width;
  r.Bottom:=FPicture.Graphic.Height;
  // draw the surrounding rect in design mode

  B := TBitmap.Create;

  if not FPicture.Graphic.Empty then
  begin
    B.Width := FPicture.Graphic.Width;
    B.Height := FPicture.Graphic.Height;
  end
  else
  begin
    B.Width := Width;
    B.Height := Height;
  end;

  with B.Canvas do
  try
    if not FTransparent then
    begin
      Brush.Style := bsSolid;
      Brush.Color := FColor;
      FillRect(r);
    end
    else
    begin
      Brush.Style := bsSolid;
      Brush.Color := FColor;
      FillRect(r);
    end;

    if not FPicture.Graphic.Empty then
      Draw(0, 0, FPicture.Graphic);

    // when in design mode, draw the hot spots
    if not( csDesigning in ComponentState) then
    begin
      // every time the control is painted, I save it's image into a bitmap
      // that I use to repaint the control after the mouse exits a hotspot
      FBitmap.Width := Width;
      FBitmap.Height := Height;
      if FStretch then
      Begin
        r.Right:=Width;
        r.Bottom:=Height;
      End;
      FBitmap.Canvas.StretchDraw(R, B);
      r.Right:=B.Width;
      r.Bottom:=B.Height;
    end;

  finally
    B.TransparentColor := B.Canvas.Pixels[0,0];
    B.TransparentMode := tmAuto;
    B.Transparent := FTransparent;
    r.Right:=Width;
    r.Bottom:=Height;
    TC:=TBitmap.Create;
    try
      TC.Width:=Width;
      TC.Height:=Height;
      TC.Canvas.Brush.Color:=FColor;
      TC.Canvas.FillRect(r);
      if FStretch then
        TC.Canvas.StretchDraw(r,B)
      else
        TC.Canvas.Draw(0,0,B);
      if csDesigning in ComponentState then
      begin
        TC.canvas.Pen.Style := psDot;
        TC.canvas.Pen.Mode := pmNOTXOR;
        TC.canvas.Pen.Width := 1;
        TC.canvas.Pen.Color := clBlack;
        TC.canvas.Brush.Style := bsClear;// Modified to draw the shape
        for i := 0 to FHotSpots.Count-1 do
        begin
          FHotSpots[i].DrawShape(TC.Canvas);
        end;
      end
      else
      Begin
        //Draw the hoverimage
        if (FHoveredItem >= 0) and (FClickedItem = -1) and (not FHotSpots[FHoveredItem].FShowClick) then
          DrawHoverImage(FHoveredItem,TC.Canvas);

        //Draw the clickedimage
        if (FClickedItem<>-1) then
          DrawClickImage(FClickedItem,TC.Canvas);

        for i := 1 to FHotSpots.Count do
          if FHotSpots[i - 1].Down or FHotSpots[i - 1].ShowClick then
            DrawClickImage(i-1,TC.Canvas);
      End;
    finally
      canvas.Draw(0,0,Tc);
      TC.Free;
    end;
    B.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.RestoreHotSpot(HotSpotIndex: Integer);
begin
  with FHotSpots[HotSpotIndex] do
  begin
    if not FHotSpots[HotSpotIndex].Down then
      Canvas.CopyRect(AsRect, FBitmap.Canvas, AsRect);
  end;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.SetColor(const Value: TColor);
begin
  FColor := Value;
  Repaint;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.SetHotSpots(const Value: THotSpots);
begin
  FHotSpots.Assign(Value);
  FHoveredItem := -1;
  FClickedItem := -1;
  Repaint;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.SetHoveredItem(const Value: Integer);
begin
  if FHoveredItem <> Value then
  begin
    Application.CancelHint;

    // restore the image beneath the hovered item
    if (FHoveredItem <> -1) and (FClickedItem = -1) then
    begin
      if not HotSpots[FHoveredItem].FShowClick then
        RestoreHotSpot(FHoveredItem);

      if Assigned(FOnHotSpotExit)
        then FOnHotSpotExit(Self, FHotSpots[FHoveredItem]);
    end;

    // if there is a hovered item, draw it's hover image (if assigned)
    if (Value <> -1) and (FClickedItem = -1) then
    begin
      if not HotSpots[Value].FShowClick then
        DrawHoverImage(Value);

      if Assigned(FOnHotSpotEnter) then
        FOnHotSpotEnter(Self, FHotSpots[Value]);
    end;

    FHoveredItem := Value;
  end;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.SetPicture(const Value: TPicture);
var
  i: Integer;
begin
  FPicture.Assign(Value);
  for i := 0 to FHotSpots.Count - 1 do
  begin
    FHotSpots[i].FPicture := FPicture;
    if FHotSpots[i].Clipped then
    with FHotSpots[i] do
    begin
      CalcClip(HoverImage,FCHover);
      CalcClip(ClickImage,FCClick);
    end;
  end;
  Repaint;
end;

//------------------------------------------------------------------------------

procedure THotSpotImage.DblClick;
var
  pt: TPoint;
  i: Integer;
  PM,PC1,PC2: TPoint;
begin
  inherited;

  isDblClick := true;
  
  GetCursorPos(pt);
  pt := ScreenToClient(pt);

  if FHoveredItem = -1 then
  begin
      PM.x := pt.X;
      PM.y := pt.Y;
      PC1.x := Left;
      PC1.y := Top;
      PC2.x := Width;
      PC2.y := Height;
      if (PM.x < PC1.x) or (PM.y < PC1.y) or (PM.x > PC2.x) or (PM.y > PC2.y)then
      begin
        HoveredItem := -1;
        Exit;
      end;

    for i := 0 to HotSpots.Count - 1 do
      if HotSpots[i].GetHoverPos(pt.X,pt.Y) <> hpNone then
      begin
        HoveredItem := i;

        isMouseUp := False;
        FClickedItem := i;
        DrawClickImage(i);

        if Assigned(OnHotSpotDblClick) then
          FOnHotSpotDblClick(Self,HotSpots[i]);

        Exit;
      end;
    HoveredItem := -1;
  end
  else
  begin
    isMouseUp := False;
    FClickedItem := FHoveredItem;
    DrawClickImage(FClickedItem);
    if Assigned(OnHotSpotDblClick) then
      FOnHotSpotDblClick(Self,HotSpots[FClickedItem]);
  end;
end;


//------------------------------------------------------------------------------
procedure THotSpotImage.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  i: Integer;
  PM,PC1,PC2: TPoint;
begin
  inherited;
  if isDblClick then
  begin
    isDblClick := False;
    Exit;
  end;
  //this happens when the app gets focus through click on hotspot
  if FHoveredItem = -1 then
  begin
      PM.x := X;
      PM.y := Y;
      PC1.x := Left;
      PC1.y := Top;
      PC2.x := Width;
      PC2.y := Height;
      if (PM.x < PC1.x) or (PM.y < PC1.y) or (PM.x > PC2.x) or (PM.y > PC2.y)then
      begin
        HoveredItem := -1;
        Exit;
      end;

    for i := 0 to HotSpots.Count - 1 do
      if HotSpots[i].GetHoverPos(X,Y) <> hpNone then
      begin
        HoveredItem := i;

        if Button = mbRight then
          if Assigned(FOnHotSpotRightClick) then
            FOnHotSpotRightClick(Self,HotSpots[i]);

        if Button = mbLeft then
        begin
          isMouseUp := False;
          FClickedItem := i;
          DrawClickImage(i);
        end;

        Exit;
      end;
    HoveredItem := -1;
  end
  else
  begin
    if Button = mbRight then
      if Assigned(FOnHotSpotRightClick) then
        FOnHotSpotRightClick(Self,HotSpots[HoveredItem]);

     if Button = mbLeft then
     begin
       isMouseUp := False;
       FClickedItem := FHoveredItem;
       DrawClickImage(FClickedItem);
     end;
  end;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

  //to cope with loosing focus
  if isMouseUp then
    Exit
  else
    isMouseUp := True;

  if FClickedItem <> -1 then
  begin
    with FHotSpots[FClickedItem] do
      if not HotSpots[FClickedItem].FShowClick then
      Canvas.CopyRect(AsRect, FBitmap.Canvas, AsRect);

    // the hotspot is clicked only when the mouse button is released within it's bounds
    if FHotSpots[FClickedItem].GetHoverPos(X, Y) <> hpNone then
    begin
      if Assigned(FOnHotSpotClick)
        then FOnHotSpotClick(Self, FHotSpots[FClickedItem]);
      FClickedItem := -1;
      if FHoveredItem <> -1 then
      begin
        if not HotSpots[FHoveredItem].FShowClick then
          DrawHoverImage(FHoveredItem);
      end
    end
    else
    begin
      if Assigned(FOnHotSpotExit) then
        FOnHotSpotExit(Self, FHotSpots[FClickedItem]);
      FClickedItem := -1;
      FHoveredItem := -1;
    end;
  end;

end;


//------------------------------------------------------------------------------
procedure THotSpotImage.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  PM,PC1,PC2: TPoint;
begin
  inherited;

  // the hover image only appears at runtime
  // if the left mouse button is down, the hover image does NOT appear

  if (csDesigning in ComponentState) then
    Exit;

   outputdebugstring(pchar(inttostr(x)+':'+inttostr(y)));

  PM.x := X;
  PM.y := Y;
  PC1.x := 0;
  PC1.y := 0;
  PC2.x := Width;
  PC2.y := Height;
  if (PM.x < PC1.x) or (PM.y < PC1.y) or (PM.x > PC2.x) or (PM.y > PC2.y) then
  begin
    HoveredItem := -1;
    Cursor := FOrigCursor;
    Exit;
  end;

  for i := 0 to HotSpots.Count - 1 do
    if HotSpots[i].GetHoverPos(X, Y) <> hpNone then
    begin
      HoveredItem := i;
      Cursor := FHotSpotCursor;
      Exit;
    end;

  Cursor := FOrigCursor;
  HoveredItem := -1;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  if (not FTransparent)  then
    ControlStyle := ControlStyle + [csOpaque]
  else  // picture might not cover entire clientrect
    ControlStyle := ControlStyle - [csOpaque];
  Invalidate;
end;

function THotSpotImage.GetHotSpotXY(x, y: Integer): THotSpot;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to HotSpots.Count - 1 do
    if HotSpots[i].GetHoverPos(X, Y) <> hpNone then
    begin
      Result := HotSpots[i];
      Exit;
    end;
end;


//------------------------------------------------------------------------------
procedure THotSpotImage.SetAutoSizeEx(const Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize then Stretch:=false;
  if FAutoSize and Assigned(FPicture.Graphic) then
  begin
    if not FPicture.Graphic.Empty then
    begin
      Width := FPicture.Graphic.Width;
      Height := FPicture.Graphic.Height;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.PictureChanged(Sender: TObject);
begin
  if FAutoSize then
    SetAutoSizeEx(FAutoSize);
  if not FStretch then
    Begin
      HotSpots.oldHeight:=FPicture.Height;
      HotSpots.oldWidth:=FPicture.Width;
    End;
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.SetStretch(const Value: Boolean);
begin
  if FStretch = value then exit;
  FStretch := Value;
  if FStretch then
  Begin
    AutoSize:=false;
    if (csLoading in ComponentState)or (csReading in ComponentState) then
    Begin
      HotSpots.oldHeight:=Height;
      HotSpots.oldWidth:=Width;
    End
    else
    Begin
      HotSpots.oldHeight:=FPicture.Height;
      HotSpots.oldWidth:=FPicture.Width;
      HotSpots.ReScale(Width,Height);
    End;
  End
  else
      HotSpots.ReScale(FPicture.Width,FPicture.Height);
end;

//------------------------------------------------------------------------------
procedure THotSpotImage.Resize;
begin
  if FStretch then
    HotSpots.ReScale(Width,Height);
  inherited;
end;

{ THotSpotShape }

//------------------------------------------------------------------------------
constructor THotSpotShape.Create(Shape: TSpotShapeType);
begin
  self.FShapeType := Shape;
end;

//------------------------------------------------------------------------------
Destructor THotSpotShape.Destroy;
begin
  inherited;
end;

//------------------------------------------------------------------------------
procedure THotspotShape.CalcMargins;
var
  i,minx,miny,maxx,maxy: Integer;
begin
  if Length(FPoints) < 3 then
    Exit;

  minx := Round(FPoints[0].x);
  maxx := Round(FPoints[0].x);
  miny := Round(FPoints[0].y);
  maxy := Round(FPoints[0].y);
  FEx1 := (FPoints[0].x);
  FEx2 := (FPoints[0].x);
  FEy1 := (FPoints[0].y);
  FEy2 := (FPoints[0].y);
  for i := 1 to High(FPoints) do
  begin
    if ((i mod 3) = 0) then
    begin
      if FPoints[i].x < FEx1 then FEx1 := FPoints[i].x;
      if FPoints[i].x > FEx2 then FEx2 := FPoints[i].x;
      if FPoints[i].y > FEy2 then FEy2 := FPoints[i].y;
      if FPoints[i].y < FEy1 then FEy1 := FPoints[i].y;
    end;
    if FPoints[i].x < minx then minx := Round(FPoints[i].x);
    if FPoints[i].x > maxx then maxx := Round(FPoints[i].x);
    if FPoints[i].y > maxy then maxy := Round(FPoints[i].y);
    if FPoints[i].y < miny then miny := Round(FPoints[i].y);
  end;

  FLeft := minx;
  FTop := miny;
  FWidth := maxx - minx;
  FHeight := maxy - miny;
end;

//------------------------------------------------------------------------------
procedure THotspotShape.SetPoints;
var
  i: Integer;
begin
  if Length(value) < 3 then
    Exit;

  SetLength(FPoints,Length(value));
  for i := 0 to High(value) do
  begin
    FPoints[i].x := Value[i].x;
    FPoints[i].y := Value[i].y;
  end;
  CalcMargins;
end;

//------------------------------------------------------------------------------
function THotSpotShape.GetHoverPos(X, Y: Integer): THoverPosition;
begin
  case FShapeType of
  stRectangle:Result := RectPos(x,y);
  stEllipse:Result := EllipsePos(x,y);
  stPolygon:Result := PolyPos(x,y);
  else
    Result := hpNone; //this shouldn't happen
  end;
end;

//------------------------------------------------------------------------------
function THotSpotShape.RectPos(X, Y: Integer): THoverPosition;
var
  x1,x2,y1,y2: Integer;
begin
  x1 := Left;
  y1 := Top;
  x2 := Left + Width;
  y2 := Top + Height;

  if Between(Y, Y1, Y2) and Between(X, X1, X2) then
    Result := hpInside
  else
    Result := hpNone;
end;

//------------------------------------------------------------------------------
function THotSpotShape.EllipsePos(X, Y: Integer): THoverPosition;
var
  xc,yc,sinu,cosu,tt,a,b,xe,ye: Extended;
begin
  if (Width = 0) or (Height = 0) then
  begin
    Result := hpNone;
    Exit;
  end;
  //if it's outside the bounding rectangle then out
  if (x < (FLeft - CornerSize)) or (x > (FLeft + Width + CornerSize)) or
     (y < (FTop - CornerSize)) or (y > (FTop + Height + CornerSize)) then
  begin
    Result := hpNone;
    Exit;
  end;

  //calculates the a and b ellipse parameters
  a := sqrt((FPoints[0].x-FPoints[6].x)*(FPoints[0].x-FPoints[6].x)+
          (FPoints[0].y-FPoints[6].y)*(FPoints[0].y-FPoints[6].y))/2;
  b := sqrt((FPoints[9].x-FPoints[3].x)*(FPoints[9].x-FPoints[3].x)+
          (FPoints[9].y-FPoints[3].y)*(FPoints[9].y-FPoints[3].y))/2;

  //fex,fey are width and height only for the four points of the ellipse
  xc := FEx1+(FEx2-FEx1)/2;
  yc := FEy1+(FEy2-FEy1)/2;

  //getting the center of the ellipse in the origin and rotating back to 0 deg
  xe := x - xc;
  ye := y - yc;
  SinCos((FAngle/180)*Pi,sinu,cosu);
  xe := xe*cosu-ye*sinu;
  ye := (x - xc)*sinu+ye*cosu;

  tt := (xe*xe)/(a*a)+(ye*ye)/(b*b);
  if Abs(tt-1) < EllipseTolerance then
    Result := hpBorder
  else
    if tt < 1 then
      Result := hpInside
    else
      Result := hpNone;
end;

//------------------------------------------------------------------------------
function THotSpotShape.BorderPolypos(X,Y: Integer;var p1,p2: Integer): TBorderPoly;
var
  i: Integer;
begin
  if Fpoints = nil then
  begin
    Result := bNone;
    Exit;
  end;

  if RectPos(x,y) = hpNone then
  begin
    Result := bNone;
    Exit;
  end;

  //The first point
  if Between(x,FPoints[0].X-CornerSize,FPoints[0].X+CornerSize) and
     Between(y,FPoints[0].y-CornerSize,FPoints[0].y+CornerSize) then
  begin
    Result := bPoint;
    p1 := 0;
    Exit;
  end;
  for i := 1 to high(FPoints) do
  begin
    //if it's in the vecinity of the poly points
    if Between(x,FPoints[i].X-CornerSize,FPoints[i].X+CornerSize) and
       Between(y,FPoints[i].y-CornerSize,FPoints[i].y+CornerSize) then
    begin
      Result:=bPoint;
      p1 := i;
      Exit;
    end;
    //or near one of the segments
    if NearLine(Point(x,y),PRound(FPoints[i-1]),PRound(FPoints[i])) then
    begin
      Result := bLine;
      p1 := i-1;
      p2 := i;
      Exit;
    end;
  end;
  //The line between the first and last point
  if NearLine(Point(x,y),PRound(FPoints[0]),PRound(FPoints[High(FPoints)])) then
  begin
    Result := bLine;
    p1 := 0;
    p2 := High(FPoints);
    Exit;
  end;

  if PolyPos(x,y) = hpInside then
    Result := bInside
  else
    Result := bNone;
end;

//------------------------------------------------------------------------------
procedure THotSpotShape.Draw(Canvas :TCanvas);
var
  tp: array of TPoint;
  i: Integer;
begin
  SetLength(tp,Length(FPoints));
  for i := 0 to High(FPoints) do
    tp[i] := PRound(FPoints[i]);

  case FShapeType of
  stEllipse:Canvas.PolyBezier(tp);
  stRectangle,stPolygon:if FPoints <> nil then
    Canvas.Polygon(tp);
  end;
end;

//------------------------------------------------------------------------------
procedure THotSpotShape.drawAt(Canvas :TCanvas;X,Y :Integer);
var
  i: Integer;
  tp: TIntPoints;
begin
  if Length(FPoints) = 0 then
    Exit;

  SetLength(tp,length(FPoints));
  for i := 0 to High(FPoints) do
    tp[i] := Point(Round(FPoints[i].x-FLeft),Round(FPoints[i].y-FTop));

  case FShapeType of
  stEllipse:FillEllipse(Canvas,tp);
  stPolygon,stRectangle:Canvas.Polygon(tp);
  end;
end;

//------------------------------------------------------------------------------
procedure THotSpotShape.SetAngle(const Value: Integer);
var
  i: Integer;
  a,b,tt,cosu,sinu,yc,xc: Extended;
begin
  if Value = FAngle then
    Exit;

  a := ((FAngle-Value)*Pi)/180.0;
  SinCos(a,sinu,cosu);
  xc := FLeft + FWidth/2;
  yc := FTop + FHeight/2;
  //rotation constants
  a := xc - xc * cosu + yc * sinu;
  b := yc - xc * sinu - yc * cosu;
  //calculate the new points
  for i := 0 to High(FPoints) do
  begin
    tt := (FPoints[i].x*cosu-FPoints[i].y*sinu+a);
    FPoints[i].y := (FPoints[i].y*cosu+FPoints[i].x*sinu+b);
    FPoints[i].x := tt;
  end;

  FAngle := Value;
  CalcMargins;
end;

{
/*************************************************************************

 * FUNCTION:   Polypos
 *
 * PURPOSE
 * This routine determines if the point passed is in the polygon. It uses

 * the classical polygon hit-testing algorithm: a horizontal ray starting

 * at the point is extended infinitely rightwards and the number of
 * polygon edges that intersect the ray are counted. If the number is odd,

 * the point is inside the polygon.
 *
 *************************************************************************/
}

function THotSpotShape.PolyPos(X,Y:Integer):THoverPosition;
var
  ppt: TPoint;
  i,wnumintsct: Word;
  pt1,pt2: TPoint;
begin
  if Length(FPoints)<3 then
  begin
    Result := hpNone;
    Exit;
  end;

  if (not Between(X, FLeft, FLeft+FWidth)) or (not Between(Y, FTop, FTop+FHeight)) then
  begin
    Result := hpNone;
    Exit;
  end;

  wnumintsct := 0;
  pt1.x := x;
  pt1.y := y;
  pt2.y := y;
  pt2.x := 1000;

  // Now go through each of the lines in the polygon and see if it
  // intersects
  for i := 0 to Length(FPoints) - 2 do
  begin
    ppt := PRound(FPoints[i]);
    if (Intersect(pt1, pt2, PRound(FPoints[i]), PRound(FPoints[i+1]))) then
      Inc(wnumintsct);
  end;
  // And the last line
  if (Intersect(pt1, pt2, PRound(FPoints[High(FPoints)]), PRound(FPoints[0]))) then
    Inc(wnumintsct);

  if(Odd(wnumintsct)) then
    Result := hpInside
  else
    Result := hpNone;
end;

//------------------------------------------------------------------------------
procedure THotSpotShape.EllipseToBezier;
var
  ofx,ofy,xc,yc: Real;
  a: Integer;
begin
  SetLength(FPoints,13);

  ofx := FWidth*EToBConst;
  ofy := FHeight*EToBConst;
  xc := FLeft+FWidth/2;
  yc := FTop+FHeight/2;

  FPoints[0].x  := FLeft;                     //------------------------/
  FPoints[1].x  := FLeft;                     //                        /
  FPoints[11].x := FLeft;                     //        2___3___4       /
  FPoints[12].x := FLeft;                     //     1             5    /
  FPoints[5].x  := FLeft + FWidth;            //     |             |    /
  FPoints[6].x  := FLeft + FWidth;            //     |             |    /
  FPoints[7].x  := FLeft + FWidth;            //     0,12          6    /
  FPoints[2].x  := xc - ofx;                  //     |             |    /
  FPoints[10].x := xc - ofx;                  //     |             |    /
  FPoints[4].x  := xc + ofx;                  //    11             7    /
  FPoints[8].x  := xc + ofx;                  //       10___9___8       /
  FPoints[3].x  := xc;                        //                        /
  FPoints[9].x  := xc;                        //------------------------*

  FPoints[2].y  := FTop;
  FPoints[3].y  := FTop;
  FPoints[4].y  := FTop;
  FPoints[8].y  := FTop + FHeight;
  FPoints[9].y  := FTop + FHeight;
  FPoints[10].y := FTop + FHeight;
  FPoints[7].y  := yc + ofy;
  FPoints[11].y := yc + ofy;
  FPoints[1].y  := yc - ofy;
  FPoints[5].y  := yc - ofy;
  FPoints[0].y  := yc;
  FPoints[12].y := yc;
  FPoints[6].y  := yc;

  if FAngle <> 0 then
  begin
    a := FAngle;
    FAngle := 0;
    SetAngle(a);
  end
  else
    CalcMargins;
end;

//------------------------------------------------------------------------------
procedure THotSpotShape.FillEllipse;
begin
  if Canvas.Handle = 0 then
    Exit;
  //open path bracket
  BeginPath(Canvas.Handle);
  //draw shape
  Canvas.PolyBezier(Pts);
  //close path bracket
  EndPath(Canvas.Handle);
  //fill path
  FillPath(Canvas.Handle);
end;

procedure THotSpot.ClickPictureChange(Sender: TObject);
begin
  CalcClip(FClickPicture,FCClick);
end;

procedure THotSpot.HoverPictureChange(Sender: TObject);
begin
  CalcClip(FHoverPicture,FCHover);
end;

procedure THotSpotImage.Loaded;
begin
  inherited;
  FOrigCursor := Cursor;
end;

initialization




end.
