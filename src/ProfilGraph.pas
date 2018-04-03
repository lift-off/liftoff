{-----------------------------------------------------------------------------
 Unit Name: ProfilGraph
 Author:    marc
 Purpose:
 History:
-----------------------------------------------------------------------------}


unit ProfilGraph;

interface

uses
  classes, windows, sysutils, controls, graphics, profile;

type

  TSchwerpunktZeichen = (spKeiner, spEiner, spDrei );

  TProfilCoordPainter = class(TGraphicControl)
  private
    FProfil: TProfil;
    FSelectedIndex: integer;
    FShowPoints: boolean;
    FShowSchwerpunkte: TSchwerpunktZeichen;
    FSchwerpunkt1: currency;
    FSchwerpunkt3: currency;
    FSchwerpunkt2: currency;
    FSchwerpunkt1Text: string;
    FSchwerpunkt3Text: string;
    FSchwerpunkt2Text: string;
    FAlignTopLeft: boolean;
    procedure SetProfil(const Value: TProfil);
    procedure SetSelectedIndex(const Value: integer);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintToCanvas( ACanvas: TCanvas );
    property Profil: TProfil read FProfil write SetProfil;
    property SelectedIndex: integer read FSelectedIndex write SetSelectedIndex;
  published
    property ShowPoints: boolean read FShowPoints write FShowPoints;
    property ShowSchwerpunkte: TSchwerpunktZeichen read FShowSchwerpunkte write FShowSchwerpunkte;
    property Schwerpunkt1: currency read FSchwerpunkt1 write FSchwerpunkt1;
    property Schwerpunkt1Text: string read FSchwerpunkt1Text write FSchwerpunkt1Text;
    property Schwerpunkt2: currency read FSchwerpunkt2 write FSchwerpunkt2;
    property Schwerpunkt2Text: string read FSchwerpunkt2Text write FSchwerpunkt2Text;
    property Schwerpunkt3: currency read FSchwerpunkt3 write FSchwerpunkt3;
    property Schwerpunkt3Text: string read FSchwerpunkt3Text write FSchwerpunkt3Text;
    property AlignTopLeft: boolean read FAlignTopLeft write FAlignTopLeft;
  end;

implementation

{ TProfilCoordPainter }

constructor TProfilCoordPainter.Create(AOwner: TComponent);
begin
  inherited;
  FProfil := nil;
  FSelectedIndex := -1;
  FShowPoints:= true;
  FShowSchwerpunkte:= spKeiner;
  FSchwerpunkt1:= 0;
  FSchwerpunkt3:= 0;
  FSchwerpunkt2:= 0;
  FAlignTopLeft:= false;
end;

procedure TProfilCoordPainter.Paint;
begin
  PaintToCanvas( Canvas );
end;

procedure TProfilCoordPainter.PaintToCanvas(ACanvas: TCanvas);
var
  i : integer;
  MinX, MaxX,
  MinY, MaxY,
  BaseX, BaseY : integer;
  FaktorX, FaktorY : real;

  procedure CalcDims;
  var
    i : integer;
  begin
    MinX := 0;
    MaxX := 1;
    MinY := 0;
    MaxY := 1;

    for i := 0 to pred(Profil.Koordinaten.Count) do begin
      if Profil.Koordinaten.Items[i].x > MaxX then MaxX := round(Profil.Koordinaten.Items[i].X);
      if Profil.Koordinaten.Items[i].x < MinX then MinX := round(Profil.Koordinaten.Items[i].Y);
      if Profil.Koordinaten.Items[i].y > MaxY then MaxY := round(Profil.Koordinaten.Items[i].Y);
      if Profil.Koordinaten.Items[i].y < MinY then MinY := round(Profil.Koordinaten.Items[i].Y);
    end;

    FaktorX := (Width - 20) / (MaxX - MinX);
    FaktorY := (Height - 20) / (MaxY - MinY);

    if FaktorX > FaktorY then FaktorX := FaktorY
    else FaktorY := FaktorX;

    if not AlignTopLeft then begin
      BaseX := round((Width - ((MaxX - MinX) * FaktorX)) / 2);
      BaseY := round((Height - ((MaxY - MinY) * FaktorY)) / 2);
    end else begin
      BaseX := round(MinX * FaktorX);
      BaseY := round(Height - ((MaxY - MinY) * FaktorY) - 5);
    end;

  end {CalcDims};

  function CalcX(x: Currency) : integer;
  begin
    result := BaseX + round((x - MinX) * FaktorX);
  end {CalcX};

  function CalcY(y: Currency) : integer;
  begin
    result := Height - BaseY - round((y - MinY) * FaktorY);
  end {CalcY};

  procedure LineFromTo(x1, y1, x2, y2: integer);
  begin
    with ACanvas do begin
      MoveTo(x1,y1);
      LineTo(x2,y2);
    end;
  end {LineFromTo};

  procedure DrawKoordPoint(i: integer);
  var
    x, y : integer;
  begin
    if Profil.Koordinaten.Count < i + 1 then exit;
    x := CalcX(Profil.Koordinaten.Items[i].x);
    y := CalcY(Profil.Koordinaten.Items[i].y);

    with ACanvas do begin

      with Pen do begin
        Width := 1;
        Style := psSolid;
        if i = SelectedIndex then begin
          Width := 2;
          Color := clRed;
        end else begin
          Width := 1;
          Color := clGray;
        end;
      end;

      Ellipse(x - 4, y - 4, x + 4, y + 4);

    end;
  end {DrawKoordPoint};

  procedure DrawSchwerpunktLine( ASchwerpunkt: currency; AText: string; ALineLength: integer );
  begin
    with ACanvas do begin
      with Pen do begin
        Width := 2;
        Style := psSolid;
        Color := clBlack;
        LineFromTo(
          CalcX( ASchwerpunkt ),
          CalcY(0),
          CalcX( ASchwerpunkt),
          CalcY(-4 -ALineLength ) + TextHeight('H') );
        //Width := 1;
        Font.Color:= clBlack;
        Font.Name:= 'Arial';
        Font.Size:= 7;
        TextOut( CalcX(ASchwerpunkt)+3, CalcY(-6-ALineLength) , AText );
      end;
    end;
  end {DrawSchwerpunktLine};

begin

  with ACanvas do begin

    { Clear Background }
    with Brush do begin
      Color := clWhite;
      Style := bsSolid;
    end;
    Pen.Style := psClear;
    Rectangle(GetClientRect);

    if not assigned(Profil) then exit;

    if Profil.Koordinaten.Count > 0 then begin

      CalcDims;

      { Draw Zero-Y Line }
      with Pen do begin
        Width := 1;
        Style := psDashDot;
        Color := clRed;
        LineFromTo(0, CalcY(0), ClientWidth, CalcY(0));
      end;


      with Profil.Koordinaten do begin

        { Draw Coord-Markers }
        if ShowPoints then begin
          for i := 0 to pred(Count) do begin
            DrawKoordPoint(i);
          end;
          if SelectedIndex > -1 then
            DrawKoordPoint(SelectedIndex);
        end;

        { Draw Profil line }
        with Pen do begin
          Width := 1;
          Style := psSolid;
          Color := clBlue;
        end;
        Brush.Style := bsClear;
        MoveTo(CalcX(Items[0].x), CalcY(Items[0].y));
        for i := 1 to pred(Count) do
          LineTo(CalcX(Items[i].x), CalcY(Items[i].y));

      end;

      { Schwerpunkte einzeichnen }
      case ShowSchwerpunkte of
        spEiner: DrawSchwerpunktLine( Schwerpunkt1, Schwerpunkt1Text, 0 );
        spDrei:  begin
                   DrawSchwerpunktLine( Schwerpunkt1, Schwerpunkt1Text, 6 );
                   DrawSchwerpunktLine( Schwerpunkt2, Schwerpunkt2Text, 3 );
                   DrawSchwerpunktLine( Schwerpunkt3, Schwerpunkt3Text, 0 );
                 end;
      end;

    end;

  end;
end;

procedure TProfilCoordPainter.SetProfil(const Value: TProfil);
begin
  FProfil := Value;
  Invalidate;
end;

procedure TProfilCoordPainter.SetSelectedIndex(const Value: integer);
begin
  FSelectedIndex := Value;
  Invalidate;
end;

end.
