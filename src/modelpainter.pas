unit modelpainter;

interface

uses
  classes, windows, sysutils, controls, graphics, Contnrs,
  profile, modell, varianten;

type

  TDrawMode = (dmAuto, dmSimple, dmDetailed);
  TPanDirection = (pdUp, pdDown, pdLeft, pdRight);

  TTrapez = class
  private
    FInnentiefe: currency;
    FBreite: currency;
    FPfeilung: currency;
    FAussentiefe: currency;
  public
    property Aussentiefe: currency read FAussentiefe write FAussentiefe;
    property Innentiefe: currency read FInnentiefe write FInnentiefe;
    property Breite: currency read FBreite write FBreite;
    property Pfeilung: currency read FPfeilung write FPfeilung;
  end;

  TModellData = class
  private
    FVorderkanteNasen: currency;
    FFluegeltrapeze: TObjectList;
    FHlwTrapeze: TObjectList;
    FNasenlaenge: currency;
    FRumpflaenge: currency;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property VorderkanteNasen: currency read FVorderkanteNasen write FVorderkanteNasen;
    property FluegelTrapeze: TObjectList read FFluegeltrapeze write FFluegeltrapeze;
    property HlwTrapeze: TObjectList read FHlwTrapeze write FHlwTrapeze;
    property Nasenlaenge: currency read FNasenlaenge write FNasenlaenge;
    property Rumpflaenge: currency read FRumpflaenge write FRumpflaenge;
  end;

  TModellPainter = class(TGraphicControl)
  private
    procedure SetModellVariante(const Value: TModellVariante);
  protected
    FModellVariante: TModellVariante;
    FNeedsUpdate: boolean;
    FDrawData: TModellData;
    FAutoScale: boolean;
    FShowGrid: boolean;
    FDrawMode: TDrawMode;
    FZoom: byte;
    FBasePoint: TPoint;
    FPanSize: integer;
    FSmallPen: boolean;
    procedure Paint; override;
    procedure SetZoom(const Value: byte);
    procedure SetDrawMode(const Value: TDrawMode);
    procedure SetAutoScale(const Value: boolean);
    procedure SetBasePoint(const Value: TPoint);
    procedure SetShowGrid(const Value: boolean);
    procedure UpdateModelDataToDraw;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure NeedsUpdate;
    procedure Pan( APanDirection: TPanDirection );

    property ModellVariante: TModellVariante read FModellVariante write SetModellVariante;
    property ShowGrid: boolean read FShowGrid write SetShowGrid;
    property AutoScale: boolean read FAutoScale write SetAutoScale;
    property DrawMode: TDrawMode read FDrawMode write SetDrawMode;
    property Zoom: byte read FZoom write SetZoom;
    property BasePoint: TPoint read FBasePoint write SetBasePoint;
    property PanSize: integer read FPanSize write FPanSize;
    property SmallPen: boolean read FSmallPen write FSmallPen;

  end;


implementation

uses
  maindata;

{ TModellData }

constructor TModellData.Create;
begin
  inherited;
  FFluegeltrapeze:= TObjectList.Create( true );
  FHlwTrapeze:= TObjectList.Create( true );
end;

destructor TModellData.Destroy;
begin
  FreeAndNil( FFluegeltrapeze );
  FreeAndNil( FHlwTrapeze );
  inherited;
end;

{ TModellPainter }

constructor TModellPainter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDrawData:= TModellData.Create;

  FShowGrid:= true;
  FAutoScale:= true;
  FDrawMode:= dmAuto;
  FZoom:= 1;
  FPanSize:= 10;
  FSmallPen:= false;

  FNeedsUpdate:= true;

end;

destructor TModellPainter.Destroy;
begin
  FreeAndNil( FDrawData );
  inherited;
end;

procedure TModellPainter.SetZoom(const Value: byte);
begin
  if FZoom > 0 then
    FZoom := Value
  else
    FZoom := 1;
  invalidate;
end;

procedure TModellPainter.NeedsUpdate;
begin
  FNeedsUpdate:= true;
  Invalidate;
end;

procedure TModellPainter.Paint;
var
  scale,
  scaleX,
  scaleY: currency;

  function CmToCoord( ACM: currency ): integer;
  begin
    result:= round( ACM * scale );
  end {CmToCoord};

  procedure DrawGrid;
  var
    x, y: integer;
    size: integer;
    i: byte;
  begin
    size:= CmToCoord( 100 );
    y:= BasePoint.Y;
    i:= 1;
    Canvas.Pen.Color:= Rgb( 205, 205, 255 );
    while y < Height do begin
      if i >= 3 then begin
        Canvas.Pen.Style:= psSolid;
        i:= 0;
      end else begin
        Canvas.Pen.Style:= psDot;
      end;

      Canvas.MoveTo( 0, y );
      Canvas.LineTo( ClientWidth, y );
      inc( y, size );
      inc( i );
    end;
    y:= BasePoint.Y;
    i:= 3;
    while y > 0 do begin
      if i >= 3 then begin
        Canvas.Pen.Style:= psSolid;
        i:= 0;
      end else begin
        Canvas.Pen.Style:= psDot;
      end;

      Canvas.MoveTo( 0, y );
      Canvas.LineTo( ClientWidth, y );
      dec( y, size );
      inc( i );
    end;

    x:= BasePoint.X;
    i:= 1;
    while x < ClientWidth do begin
      if i >= 3 then begin
        Canvas.Pen.Style:= psSolid;
        i:= 0;
      end else begin
        Canvas.Pen.Style:= psDot;
      end;

      Canvas.MoveTo( x, 0 );
      Canvas.LineTo( x, ClientHeight );
      inc( x, size );
      inc( i );
    end;
    x:= BasePoint.X;
    i:= 3;
    while x > 0 do begin
      if i >= 3 then begin
        Canvas.Pen.Style:= psSolid;
        i:= 0;
      end else begin
        Canvas.Pen.Style:= psDot;
      end;

      Canvas.MoveTo( x, 0 );
      Canvas.LineTo( x, ClientHeight );
      Dec( x, size );
      inc( i );
    end;
  end {DrawGrid};

  procedure DrawWing( ATop: integer; AIsLeft: boolean; AWingData: TObjectList );
  var
    i: Integer;
    trapez: TTrapez;
    baseX: integer;
    baseY: integer;

    function AddToX( AX, ADeltaX: integer ): integer;
    begin
      if AIsLeft then result:= AX - ADeltaX
      else result:= AX + ADeltaX;
    end {AddToX};

  begin

    if AWingData.Count > 0 then begin

      baseX:= BasePoint.X;
      baseY:= ATop;


      for i:= 0 to pred( AWingData.Count ) do begin
        trapez:= TTrapez( AWingData[ i ] );

        with Canvas do begin

          Pen.Color:= clBlack;
          Pen.Style:= psSolid;
          if SmallPen then Pen.Width:= 2
          else Pen.Width:= 2;

          { Nasenkante }
          MoveTo( baseX, baseY );
          LineTo( AddToX( baseX, CmToCoord( trapez.Breite ) ),
                  baseY + CmToCoord( trapez.Pfeilung ));

          { Hinterkante }
          MoveTo( baseX, baseY + CmToCoord(trapez.Innentiefe)  );
          LineTo( AddToX( baseX, CmToCoord( trapez.Breite ) ),
                  baseY + CmToCoord( trapez.Pfeilung + trapez.Aussentiefe ));

          { Aussenkante }
          if i < AWingData.Count -1 then begin
            { Wenn nicht Aussenkante der Fläche, dann muss der Pen umgestellt
              werden, da es sich nur um eine Konstruktionslinie handelt. }
            Pen.Color:= clGray;
            Pen.Style:= psSolid;
            Pen.Width:= 1;
          end;
          MoveTo( AddToX( baseX, CmToCoord( trapez.Breite ) ),
                  baseY + CmToCoord( trapez.Pfeilung ));
          LineTo( AddToX( baseX, CmToCoord( trapez.Breite ) ),
                  baseY + CmToCoord( trapez.Pfeilung + trapez.Aussentiefe ));

          { t/4 Linie }
          Pen.Color:= clRed;
          Pen.Style:= psDashDot;
          Pen.Width:= 1;
          MoveTo( baseX,
                  baseY + CmToCoord(trapez.Innentiefe * 0.25)  );
          LineTo( AddToX( baseX, CmToCoord( trapez.Breite ) ),
                  baseY + CmToCoord( trapez.Pfeilung + (trapez.Aussentiefe * 0.25) ));

          baseX:= AddToX( baseX, CmToCoord( trapez.Breite ));
          baseY:= baseY + CmToCoord( trapez.Pfeilung );

        end;

      end;
    end;

  end;

  procedure DrawRumpf( ATop: integer; ARumplaenge: currency );
  begin
    with Canvas do begin
      Pen.Style:= psSolid;
      Pen.Color:= clBlack;
      if SmallPen then Pen.Width:= 3
      else Pen.Width:= 5;

      MoveTo( BasePoint.X, ATop );
      LineTo( BasePoint.X, ATop + CmToCoord( ARumplaenge ) );

    end;
  end {DrawRumpf};

begin {Paint}
  with Canvas do begin

    { Clear Background }
    with Brush do begin
      Color := clWhite;
      Style := bsSolid;
    end;

    with Pen do begin
      Color := clGray;
      Style := psSolid;
      Width := 1;
    end;

    Rectangle(GetClientRect);

    if Assigned( FModellVariante ) then begin

      if FNeedsUpdate then begin
        UpdateModelDataToDraw;
      end;

      { Calculate scaling }
      if AutoScale then begin
        FBasePoint.X:= round(ClientWidth / 2);
        FBasePoint.Y:= 10;

        scaleX:= 1 / FModellVariante.Spannweite * (ClientWidth - 20 );
        scaleY:= 1 / FDrawData.Rumpflaenge * (ClientHeight - 20 );
        if scaleX < scaleY then scale:= scaleX
        else scale:= scaleY;

      end else begin
        scale:= (1 / FModellVariante.Spannweite * (ClientWidth - 20 )) *
                ( 1 + (Zoom / 60) );
      end;

      { Grid pinseln }
      if FShowGrid then begin
        DrawGrid;
      end;

      if FDrawData.FluegelTrapeze.Count > 0 then begin
        { Flügel zeichnen  }
        DrawWing( BasePoint.Y + CmToCoord( FDrawData.Nasenlaenge ),
                  true,
                  FDrawData.FluegelTrapeze );
        DrawWing( BasePoint.Y + CmToCoord( FDrawData.Nasenlaenge ),
                  false,
                  FDrawData.FluegelTrapeze );
        { HLW }
        DrawWing( BasePoint.Y + CmToCoord( FDrawData.Nasenlaenge + FDrawData.VorderkanteNasen ),
                  true,
                  FDrawData.HlwTrapeze );
        DrawWing( BasePoint.Y + CmToCoord( FDrawData.Nasenlaenge + FDrawData.VorderkanteNasen ),
                  false,
                  FDrawData.HlwTrapeze );
        { Rumpf }
        DrawRumpf( BasePoint.Y, FDrawData.Rumpflaenge );

        { Modellname / Variante }
        Canvas.Pen.Width:= 1;
        Canvas.Pen.Style:= psSolid;
        if Assigned( ModellVariante ) then begin
          TextOut( 10, 10,
            Format('%s %s / %s',
              [dmMain.Translator.GetLit('ModelpainterModelLabel'),
               TModell(ModellVariante.Modell).ModellName,
               ModellVariante.VariantenName]));
        end;
      end else begin
        { Konnten keine Trapeze ermittelt werden, so kann die Modellgrafik
          noch nicht gezeichnet werden. }
        with Canvas do begin
          with Pen do begin
            Width:= 1;
            Style:= psSolid;
          end;

          TextOut( 10, 10, dmMain.Translator.GetLit('ModelpainterMissingData') );
        end;
      end;

    end;

  end;

end {Paint};


procedure TModellPainter.UpdateModelDataToDraw;
var
  trapez: TTrapez;
  i: integer;
  bisherigeBreite: currency;
  bisherigePfeilung: currency;
begin
  { Diese Methode bereitet die Zeichnungsdaten anhand der bereits erfassten
    Modelldaten auf. Die Zeichnungsdaten werden von der Paint-Methode dann
    gezeichnet (nicht die Modelldaten). Dies dient der Abstraktion der
    Zeichnungsroutinen. }

  FDrawData.VorderkanteNasen:= 0;
  FDrawData.FluegelTrapeze.Clear;
  FDrawData.HlwTrapeze.Clear;

  if Assigned( ModellVariante ) then begin

    { Wurden lediglich die Basisdaten erfasst? }
    FDrawData.Nasenlaenge:= ModellVariante.Wurzeltiefe * 1.2;
    if ( DrawMode = dmSimple)
      or ( ( ModellVariante.PflgHlwAbstandFluegelHlw = 0 ) and (DrawMode = dmAuto))
    then begin
      { Es wurden erste die Basisdaten erfasst. Ensprechend wird auch eine
        grobe Darstellung des Modelles gezeichnet. }
      try
        FModellVariante.AuslegungBerechnen;

        FDrawData.VorderkanteNasen:= ( ModellVariante.RH * 100 )+
                                     ( ModellVariante.Wurzeltiefe / 4 ) -
                                     ( ModellVariante.TMH / 4 );

        { 1. Trapez: Wurzel bis Trapezstoss }
        trapez:= TTrapez.Create;
        trapez.Aussentiefe:= ModellVariante.RealeTiefeTrapezstoss;
        trapez.Innentiefe:= ModellVariante.Wurzeltiefe;
        trapez.Breite:= ModellVariante.RealeLageTrapezstoss;
        trapez.Pfeilung:= (trapez.Innentiefe * 0.25) - (trapez.Aussentiefe * 0.25);
        FDrawData.FluegelTrapeze.Add( trapez );

        { 2. Trapez: Trapezstoss bis Randbogen }
        trapez:= TTrapez.Create;
        trapez.Aussentiefe:= ModellVariante.TiefeRandbogen;
        trapez.Innentiefe:= ModellVariante.RealeTiefeTrapezstoss;
        trapez.Breite:= (ModellVariante.Spannweite / 2) - ModellVariante.RealeLageTrapezstoss;
        trapez.Pfeilung:= (trapez.Innentiefe * 0.25) - (trapez.Aussentiefe * 0.25);
        FDrawData.FluegelTrapeze.Add( trapez );

        { HLW }
        trapez:= TTrapez.Create;
        trapez.Aussentiefe:= ModellVariante.TMH * 0.9;
        trapez.Innentiefe:= ModellVariante.TMH * 1.1;
        trapez.Breite:= ModellVariante.BHLw / 2;
        trapez.Pfeilung:= (trapez.Innentiefe * 0.25) - (trapez.Aussentiefe * 0.25);
        FDrawData.FHlwTrapeze.Add( trapez );

        FDrawData.Rumpflaenge:= FDrawData.Nasenlaenge + FDrawData.VorderkanteNasen + ModellVariante.TMH * 1.1;

      except
      end;

    end else
    if ( DrawMode = dmDetailed ) or ( DrawMode = dmAuto ) then begin
      { Die detailierte Flügelgeometrie wurde erfasst und es kann somit eine
        detailiertere Darstellung erfolgen. }

      FDrawData.VorderkanteNasen:= ModellVariante.PflgHlwAbstandFluegelHlw ;

      { Flügeltrapeze }
      bisherigeBreite:= 0;
      bisherigePfeilung:= 0;
      if ModellVariante.PflgFlKnicke.Count > 0 then begin
        for i:= 0 to ModellVariante.PflgFlKnicke.Count -1 do begin

          trapez:= TTrapez.Create;
          trapez.Aussentiefe:= ModellVariante.PflgFlKnicke.Items[i].Fluegeltiefe;
          if i = 0 then begin
            trapez.Innentiefe:= ModellVariante.Wurzeltiefe;
          end else begin
            trapez.Innentiefe:= ModellVariante.PflgFlKnicke.Items[i-1].Fluegeltiefe;
          end;
          trapez.Pfeilung:= ModellVariante.PflgFlKnicke.Items[i].Pfeilung - bisherigePfeilung;
          trapez.Breite:= ModellVariante.PflgFlKnicke.Items[i].Abstand - bisherigeBreite;
          FDrawData.FluegelTrapeze.Add( trapez );

          bisherigeBreite:= ModellVariante.PflgFlKnicke.Items[i].Abstand;
          bisherigePfeilung:= ModellVariante.PflgFlKnicke.Items[i].Pfeilung;
        end;

        { Letztes Trapez manuell anhängen }
        trapez:= TTrapez.Create;
        trapez.Aussentiefe:= ModellVariante.TiefeRandbogen;
        trapez.Innentiefe:= ModellVariante.PflgFlKnicke.Items[ModellVariante.PflgFlKnicke.Count-1].Fluegeltiefe;
        trapez.Pfeilung:= ModellVariante.PflgFlRandbogen - bisherigePfeilung;
        trapez.Breite:= ModellVariante.Spannweite / 2 - bisherigeBreite;
        FDrawData.FluegelTrapeze.Add( trapez );

      end else begin
        { Ohne Knicke nur ein Trapez von Wurzel bis zum Randbogen }
        trapez:= TTrapez.Create;
        trapez.Aussentiefe:= ModellVariante.TiefeRandbogen;
        trapez.Innentiefe:= ModellVariante.Wurzeltiefe;
        trapez.Breite:= ModellVariante.Spannweite / 2;
        trapez.Pfeilung:= ModellVariante.PflgFlRandbogen;
        FDrawData.FluegelTrapeze.Add( trapez );

        { BEGIN OLD CODE - DELETE IF NOT NEEDED ANYMORE }
        { 1. Trapez: Wurzel bis Trapezstoss }
        {
        trapez:= TTrapez.Create;
        trapez.Aussentiefe:= ModellVariante.RealeTiefeTrapezstoss;
        trapez.Innentiefe:= ModellVariante.Wurzeltiefe;
        trapez.Breite:= ModellVariante.RealeLageTrapezstoss;
        trapez.Pfeilung:= ModellVariante.PflgFlRandbogen;
        FDrawData.FluegelTrapeze.Add( trapez );
        }
        { 2. Trapez: Trapezstoss bis Randbogen }
        {
        trapez:= TTrapez.Create;
        trapez.Aussentiefe:= ModellVariante.TiefeRandbogen;
        trapez.Innentiefe:= ModellVariante.RealeTiefeTrapezstoss;
        trapez.Breite:= (ModellVariante.Spannweite / 2) - ModellVariante.RealeLageTrapezstoss;
        trapez.Pfeilung:= ModellVariante.PflgFlRandbogen;
        FDrawData.FluegelTrapeze.Add( trapez );
        }
        { END OLD CODE }

      end;

      { HLW }
      bisherigeBreite:= 0;
      bisherigePfeilung:= 0;
      if ModellVariante.PflgHlwKnicke.Count > 0 then begin
        for i:= 0 to ModellVariante.PflgHlwKnicke.Count -1 do begin

          trapez:= TTrapez.Create;
          trapez.Aussentiefe:= ModellVariante.PflgHlwKnicke.Items[i].Fluegeltiefe;
          if i = 0 then begin
            trapez.Innentiefe:= ModellVariante.PflgHlwWurzeltiefe;
          end else begin
            trapez.Innentiefe:= ModellVariante.PflgHlwKnicke.Items[i-1].Fluegeltiefe;
          end;
          trapez.Pfeilung:= ModellVariante.PflgHlwKnicke.Items[i].Pfeilung - bisherigePfeilung;
          trapez.Breite:= ModellVariante.PflgHlwKnicke.Items[i].Abstand - bisherigeBreite;
          FDrawData.HlwTrapeze.Add( trapez );

          bisherigeBreite:= ModellVariante.PflgHlwKnicke.Items[i].Abstand;
          bisherigePfeilung:= ModellVariante.PflgHlwKnicke.Items[i].Pfeilung;
        end;

        { Letztes HLW-Trapez manuell anhängen }

        trapez:= TTrapez.Create;
        trapez.Aussentiefe:= ModellVariante.PflgHlwAussentiefe;
        trapez.Innentiefe:= ModellVariante.PflgHlwKnicke.Items[ModellVariante.PflgHlwKnicke.Count-1].Fluegeltiefe;
        trapez.Pfeilung:= ModellVariante.PflgHlwKnicke.Items[ModellVariante.PflgHlwKnicke.Count-1].Pfeilung;
        trapez.Breite:= ModellVariante.PflgHlwSpannweite / 2 - bisherigeBreite;
        FDrawData.HlwTrapeze.Add( trapez );

      end else begin
        trapez:= TTrapez.Create;
        trapez.Aussentiefe:= ModellVariante.PflgHlwAussentiefe;
        trapez.Innentiefe:= ModellVariante.PflgHlwWurzeltiefe;
        trapez.Pfeilung:= ModellVariante.PflgHlwPfeilung;
        trapez.Breite:= ModellVariante.PflgHlwSpannweite / 2;
        FDrawData.HlwTrapeze.Add( trapez );
      end;

      FDrawData.Rumpflaenge:= FDrawData.Nasenlaenge + FDrawData.VorderkanteNasen + ModellVariante.PflgHlwWurzeltiefe;

    end;

  end;

  FNeedsUpdate:= false;

end;

procedure TModellPainter.SetDrawMode(const Value: TDrawMode);
begin
  FDrawMode := Value;
  NeedsUpdate;
end;

procedure TModellPainter.SetAutoScale(const Value: boolean);
begin
  FAutoScale := Value;
  Invalidate;
end;

procedure TModellPainter.SetBasePoint(const Value: TPoint);
begin
  FBasePoint := Value;
  invalidate;
end;

procedure TModellPainter.Pan(APanDirection: TPanDirection);
begin
  case APanDirection of
    pdUp:    FBasePoint.Y:= FBasePoint.Y + PanSize;
    pdDown:  FBasePoint.Y:= FBasePoint.Y - PanSize;
    pdLeft:  FBasePoint.X:= FBasePoint.X + PanSize;
    pdRight: FBasePoint.X:= FBasePoint.X - PanSize;
    else Assert( false, 'Unknown pan direction! Check sourcecode.' );
  end;
  Invalidate;
end;

procedure TModellPainter.SetShowGrid(const Value: boolean);
begin
  FShowGrid := Value;
  invalidate;
end;

procedure TModellPainter.SetModellVariante(const Value: TModellVariante);
begin
  FModellVariante := Value;
end;

end.
