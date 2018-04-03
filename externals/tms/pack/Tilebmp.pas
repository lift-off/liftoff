{********************************************************************
TTileBMP component
for Delphi 1.0,2.0,3.0,4.0,5.0 & C++Builder 1.0,3.0,4.0
version 1.1

written by TMS Software
           copyright © 1998-2000
           Email: info@tmssoftware.com
           Web: http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The source
code remains property of the author and may not be distributed
freely as such.
********************************************************************}


unit Tilebmp;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, ExtCtrls;

const
   DefaultWidth  = 32;
   DefaultHeight = 32;

type
  TTileBmp = class(TGraphicControl)
  private
    FBmpWidth         : Integer;
    FBmpHeight        : Integer;
    FBitMap           : TBitmap;
    procedure SetBitMap(Value : TBitMap);
    procedure WMSize(var Message: TWMSize); message WM_PAINT;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property BitMap : TBitMap read FBitMap write SetBitMap;
    property Height default 30;
    property Width default 30;
    property ShowHint;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Visible;
  end;

procedure Register;

implementation

constructor TtileBmp.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 Width  := DefaultWidth;
 Height := DefaultHeight;
 FBmpWidth  := DefaultWidth;
 FBmpHeight := DefaultHeight;
 FBitMap := TBitMap.Create;
 ControlStyle := ControlStyle +[csOpaque];
end;

destructor TtileBmp.Destroy;
begin
   FBitMap.Free;
inherited Destroy;
end;

procedure TtileBmp.WMSize(var Message: TWMSize);
begin
   inherited;
   {No resizing allowed}
   FBmpWidth :=FBmpWidth;
   FBmpHeight:=FBmpHeight;
end;

procedure TtileBmp.SetBitMap(Value : TBitMap);
begin
   FBitMap.Assign(Value);
   FBmpHeight := FBitMap.Height;
   FBmpWidth  := FBitMap.Width;
   {
   Height := FBmpHeight;
   Width  := FBmpWidth;
   }
   if Height = 0 then
      Height := DefaultHeight;
   if Width = 0 then
      Width := DefaultWidth;
   self.repaint;
end;

procedure TtileBmp.Paint;
var
  ARect, BRect : TRect;
  x,y,xo,yo:word;

begin
   ARect := Rect(0,0,Width,Height);
   if (FBitMap.Height > 0) and (FBitmap.Width>0) then
   begin
     x:=FBitMap.Width;
     y:=FBitmap.Height;

     ARect := Rect(0,0,x,y);
     Brect := Rect(0,0,x,y);

     yo:=0;
     while (yo<height) do
      begin
       xo:=0;
       while (xo<width) do
         begin
          ARect := Rect(xo,yo,x+xo,y+yo);
          Canvas.CopyRect(ARect,FBitmap.Canvas, BRect);
          xo:=xo+FBitmap.Width;
         end;
       yo:=yo+FBitmap.Height;
      end;
   end
   else
   begin   {fill it with white color}
      Canvas.Brush.Color := clWhite;
      Canvas.FillRect(BoundsRect);
   end;
   if csDesigning in ComponentState then
   begin    {To see the outline of the Bitmap at designing time}
      Canvas.Pen.Style := psDash;
      Canvas.Brush.Style := bsClear;
      Canvas.Rectangle(0, 0, Width, Height);
   end;
end;

procedure Register;
begin
   RegisterComponents('TMS', [TTileBmp]);
end;

end.
