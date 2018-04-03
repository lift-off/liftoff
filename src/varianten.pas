{-----------------------------------------------------------------------------
 Unit Name: modell
 Author:    marc
 Purpose:   Beinhalt die Klasse für ein Flugmodell
 History:
-----------------------------------------------------------------------------}

{ Umsetzung von Variablennamen:

  AERO.BAS                           AERO.PAS
  B                                  SpannweiteInMeter
}

unit varianten;

interface

uses
  Classes, SysUtils, Windows, Contnrs, variants, XMLIntf, ad_consts, profile,
  materialien;

type

  EVariantenError = class(exception) end;

  TArtDerSteckung = ( adsNone, adsRechteckigerQueryschnitt, adsRunderQuerschnitt );

  TModellVariante = class;

  TLeistungsItem = class
  private
    Fcwges: currency;
    FVs: currency;
    Fca: currency;
    Fcwp: currency;
    FEWD: currency;
    FV_kmh: currency;
    FE: currency;
    Fcwi: currency;
    FV_ms: currency;
    Fcw: currency;
    FRei: currency;
    FRea: currency;
    FD: currency;
    FRem: currency;
    FSP: currency;
  public
    constructor Create; virtual;

    property Ca: currency read Fca write Fca;
    property V_ms: currency read FV_ms write FV_ms;
    property V_kmh: currency read FV_kmh write FV_kmh;
    property Rei: currency read FRei write FRei;
    property Rem: currency read FRem write FRem;
    property Rea: currency read FRea write FRea;
    property cwp: currency read Fcwp write Fcwp;
    property cwi: currency read Fcwi write Fcwi;
    property cw: currency read Fcw write Fcw;
    property cwges: currency read Fcwges write Fcwges;
    property E: currency read FE write FE;
    property Vs: currency read FVs write FVs;
    property EWD: currency read FEWD write FEWD;
    property D: currency read FD write FD;
    property SP: currency read FSP write FSP;
  end;

  TLeistungsdaten = class(TObjectList)
  private
    function  Get(Index: Integer): TLeistungsItem;
    procedure Put(Index: Integer; Item: TLeistungsItem);
  public
    property Items[Index: Integer]: TLeistungsItem read Get write Put;
    function GetDforCA( ACA: currency ): currency;
    function GetSPforCA(ACA: currency): currency;
    function GetEWDforCA(ACA: currency): currency;
  end;

  { Pfeilungsdaten }
  TPfeilungsItem = class
  private
    FPfeilung: integer;
    FFluegeltiefe: integer;
    FAbstand: integer;
    FProfildicke: currency;
  public
    property Abstand: integer read FAbstand write FAbstand;
    property Fluegeltiefe: integer read FFluegeltiefe write FFluegeltiefe;
    property Pfeilung: integer read FPfeilung write FPfeilung;
    property ProfilDicke: currency read FProfildicke write FProfildicke;
  end;

  TPfeilungsItems = class(TObjectList)
  private
    function  Get(Index: Integer): TPfeilungsItem;
    procedure Put(Index: Integer; Item: TPfeilungsItem);
  public
    property Items[Index: Integer]: TPfeilungsItem read Get write Put;
  end;

  { Druckpunktdaten }
  TDruckpunkt = class
  private
    Fca: currency;
    FDruckpunkt: currency;
  public
    constructor Create; virtual;

    property ca: currency read Fca write Fca;
    property Druckpunkt: currency read FDruckpunkt write FDruckpunkt;
  end;

  TSchwerpunkt = class
  private
    Fca: currency;
    FDP: currency;
    FEWD: currency;
    FVariante: TModellVariante;
    function GetStab1: currency;
    function GetStab2: currency;
    function GetStab3: currency;
  public
    property CA: currency read Fca write Fca;
    property DP: currency read FDP write FDP;
    property EWD: currency read FEWD write FEWD;
    property Stab1: currency read GetStab1;
    property Stab2: currency read GetStab2;
    property Stab3: currency read GetStab3;
    property Variante: TModellVariante read FVariante write FVariante;
  end;


  TDruckpunktItems = class(TObjectList)
  private
    function  Get(Index: Integer): TSchwerpunkt;
    procedure Put(Index: Integer; Item: TSchwerpunkt);
  public
    function Add(ACa, ADp: currency; AVariante: TModellVariante): TSchwerpunkt;
    property Items[Index: Integer]: TSchwerpunkt read Get write Put;
    function ItemByCa( ACA: currency): TSchwerpunkt;
  end;

  { Holme }
  THolmItem = class
  private
    FBiegemoment: currency;
    FSchubkraftbeanspruchung: currency;
    FHolmgurthoehe: currency;
    FQueryschnittsflaeche: currency;
    FSteghoehe: currency;
    FWiderstandsmoment: currency;
    FQuerkraft: currency;
    FAbstand: currency;
    FProfilhoehe: currency;
    FDickeStegwand: currency;
    FHolmbreite: currency;
    FAnzahlRovings: integer;
    FProfilhoeheReduziert: currency;
    FStahl_Mindeststabbreite: currency;
    FGFK_MaximaleStabbreite: currency;
    FStahl_MaximaleStabbreite: currency;
    FGFK_Stabhoehe: currency;
    FCFK_Stabhoehe: currency;
    FCFK_Mindeststabbreite: currency;
    FStahl_Stabhoehe: currency;
    FCFK_MaximaleStabbreite: currency;
    FGFK_Mindeststabbreite: currency;
  public

    { Holmberechnung }
    property Abstand: currency read FAbstand write FAbstand;
    property Holmbreite: currency read FHolmbreite write FHolmbreite;
    property Biegemoment: currency read FBiegemoment write FBiegemoment;
    property Querkraft: currency read FQuerkraft write FQuerkraft;
    property Profilhoehe: currency read FProfilhoehe write FProfilhoehe;
    property ProfilhoeheReduziert: currency read FProfilhoeheReduziert write FProfilhoeheReduziert;
    property Widerstandsmoment: currency read FWiderstandsmoment write FWiderstandsmoment;
    property Querschnittsflaeche: currency read FQueryschnittsflaeche write FQueryschnittsflaeche;
    property Steghoehe: currency read FSteghoehe write FSteghoehe;
    property Holmgurthoehe: currency read FHolmgurthoehe write FHolmgurthoehe;
    property AnzahlRovings: integer read FAnzahlRovings write FAnzahlRovings;
    property DickeStegwand: currency read FDickeStegwand write FDickeStegwand;
    property Schubkraftbeanspruchung: currency read FSchubkraftbeanspruchung write FSchubkraftbeanspruchung;

    { Steckung }
    { CFK }
    property CFK_Mindeststabbreite: currency read FCFK_Mindeststabbreite write FCFK_Mindeststabbreite; // Berechnete Mindeststabbreite in mm
    property CFK_MaximaleStabbreite: currency read FCFK_MaximaleStabbreite write FCFK_MaximaleStabbreite; // maximal mögliche Stabbreite aufgrund der gewählten Holmstegbreite in mm
    property CFK_Stabhoehe: currency read FCFK_Stabhoehe write FCFK_Stabhoehe; // Stabhöhe in der Rechnung in mm
    { GFK }
    property GFK_Mindeststabbreite: currency read FGFK_Mindeststabbreite write FGFK_Mindeststabbreite; // Berechnete Mindeststabbreite in mm
    property GFK_MaximaleStabbreite: currency read FGFK_MaximaleStabbreite write FGFK_MaximaleStabbreite; // maximal mögliche Stabbreite aufgrund der gewählten Holmstegbreite in mm
    property GFK_Stabhoehe: currency read FGFK_Stabhoehe write FGFK_Stabhoehe; // Stabhöhe in der Rechnung in mm
    { Stahl }
    property Stahl_Mindeststabbreite: currency read FStahl_Mindeststabbreite write FStahl_Mindeststabbreite; // Berechnete Mindeststabbreite in mm
    property Stahl_MaximaleStabbreite: currency read FStahl_MaximaleStabbreite write FStahl_MaximaleStabbreite; // maximal mögliche Stabbreite aufgrund der gewählten Holmstegbreite in mm
    property Stahl_Stabhoehe: currency read FStahl_Stabhoehe write FStahl_Stabhoehe; // Stabhöhe in der Rechnung in mm

  end;

  THolmList = class(TObjectList)
  private
    function  Get(Index: Integer): THolmItem;
    procedure Put(Index: Integer; Item: THolmItem);
  public
    function Add: THolmItem;
    property Items[Index: Integer]: THolmItem read Get write Put;
  end;

  { Grundklasse für ein Modell }
  TModellVariante = class
  private
    FProfilAussen: TProfil;
    FProfilInnen: TProfil;
    FVariantenName: string;
    FModell: TObject;
    FSpannweite: word;
    FFlaechenbelastung: currency;
    FSchwerpunkt: currency;
    FWurzeltiefe: currency;
    FTiefeRandbogen: currency;
    FLeitwerkshebel: currency;
    FTiefeTrapezstoss: currency;
    FLageTrapezstoss: currency;
    FStabilitaetsmass: currency;
    FBF: currency;
    Fcm0zwi: currency;
    FFAI: currency;
    FTMF: currency;
    FZ: currency;
    FNE: currency;
    FSTFS: currency;
    FNP: currency;
    FNasWu: currency;
    FXTMF: currency;
    FRH: currency;
    FT4: currency;
    FVH: currency;
    FTMH: currency;
    FDP: currency;
    FLHLw: currency;
    FT3F: currency;
    FSTFH: currency;
    FFS: currency;
    Fcm0: currency;
    FFH: currency;
    FAlpha0: currency;
    FG: currency;
    FBHLw: currency;
    FNPNeu: currency;
    FF: currency;
    FL1: currency;
    FLeistungsdaten: TLeistungsdaten;
    FLKZ: currency;
    FLKZTH: currency;
    FLKZSTR: currency;
    FVariantenBeschreibung: string;
    FPflgFlRandbogen: currency;
    FPflgFlKnicke: TPfeilungsItems;
    FPflgHlwRandbogen: currency;
    FPflgHlwWurzeltiefe: currency;
    FPflgHlwAussentiefe: currency;
    FPflgHlwKnicke: TPfeilungsItems;
    FPflgHlwSpannweite: word;
    FPflgHlwAbstandFluegelHlw: word;
    FSchwerpunkte: TDruckpunktItems;
    FLA: currency;
    FFLW: currency;
    FXN: currency;
    FLM: currency;
    FLAH: currency;
    FXNH: currency;
    FLMH: currency;
    FFLWH: currency;
    FRL: currency;
    FXNAlth: currency;
    FXNPerseke: currency;
    FXNSchenk: currency;
    FSP1: currency;
    FSP3: currency;
    FSP2: currency;
    FAuftrieb: currency;
    FMaxBiegemoment: currency;
    FOertlicheBeanspruchung: currency;
    FQuerkraftbeanspruchungHolm: currency;
    FHolme: THolmList;
    FHolmbreiteWurzel: integer;
    FHolmbreiteRandbogen: integer;
    FProfildickeWurzel: currency;
    FProfildickeRandbogen: currency;
    FNpVonCa,
    FNpBisCa: currency;
    FMaxV: byte;
    FMaxCa: currency;
    FHolmart: integer;
    FArtSteckverbindung: byte;
    function  GetSpannweiteInMeter: currency;
    procedure SetVariantenName(const Value: string);
    procedure SetProfilAussen(const Value: TProfil);
    procedure SetProfilnnen(const Value: TProfil);
    procedure SetSpannweite(const Value: word);
    function GetModell: TObject;
    procedure InitFields;
    function GetLeistungsdaten: TLeistungsdaten;
    procedure CalcLeistungsdaten;
    procedure SetVariantenBeschreibung(const Value: string);
    procedure SetTiefeTrapezStoss( value: currency );
  public
    constructor Create(AModell: TObject); virtual;
    destructor  Destroy; override;
    procedure SetAltered;

    function Save(ANode: IXMLNode) : boolean;
    function Load(ANode: IXMLNode) : boolean;

    { Berechnungsmethoden }
    procedure AuslegungBerechnen;
    procedure NeutralpunktBerechnung(AVonCa, ABisCA: currency);
    procedure Holmberechnung(ACa, AMaxV: currency; AHolmart: THolmart; AArtDerSteckung: TArtDerSteckung);

    property Modell: TObject read GetModell;
    property VariantenName: string read FVariantenName write SetVariantenName;
    property VariantenBeschreibung: string read FVariantenBeschreibung write SetVariantenBeschreibung;

    { Read / Write Properties }
    property ProfilInnen: TProfil read FProfilInnen write SetProfilnnen;
    property ProfilAussen: TProfil read FProfilAussen write SetProfilAussen;
    property Spannweite: word read FSpannweite write SetSpannweite; // Spannweite in MM
    property Flaechenbelastung: currency read FFlaechenbelastung write FFlaechenbelastung; // Flächenbelastung in g/dm2
    property Wurzeltiefe: currency read FWurzeltiefe write FWurzeltiefe; // Wurzeltiefe in mm
    property LageTrapezstoss: currency read FLageTrapezstoss write FLageTrapezstoss; // Lage Trapezstoss in mm
    property TiefeTrapezstoss: currency read FTiefeTrapezstoss write SetTiefeTrapezStoss; // Tiefe am Trapezstoss in mm
    property TiefeRandbogen: currency read FTiefeRandbogen write FTiefeRandbogen; // Tiefe am Randbogen
    property Leitwerkshebel: currency read FLeitwerkshebel write FLeitwerkshebel; // Leitwerkshebel
    property Stabilitatsmass: currency read FStabilitaetsmass write FStabilitaetsmass; // Gewünschtes Stabilitätsmass
    property Schwerpunkt: currency read FSchwerpunkt write FSchwerpunkt; // Schwehrpunkt
    property HolmbreiteWurzel: integer read FHolmbreiteWurzel write FHolmbreiteWurzel; // Holmbreite an der Wurzel
    property HolmbreiteRandbogen: integer read FHolmbreiteRandbogen write FHolmbreiteRandbogen; // Holmbreite am Randbogen
    property ProfildickeWurzel: currency read FProfildickeWurzel write FProfildickeWurzel; // Profildicke in % an der Wurzel
    property ProfildickeRandbogen: currency read FProfildickeRandbogen write FProfildickeRandbogen; // Profildicke in % am Randbogen

    function RealeLageTrapezstoss: currency;
    function RealeTiefeTrapezstoss: currency;

    { Neutralpunkte-Properties }
    { Fläche }
    property PflgFlRandbogen: currency read FPflgFlRandbogen write FPflgFlRandbogen;
    property PflgFlKnicke: TPfeilungsItems read FPflgFlKnicke write FPflgFlKnicke;
    { Höhenleitwerk }
    property PflgHlwAbstandFluegelHlw: word read FPflgHlwAbstandFluegelHlw write FPflgHlwAbstandFluegelHlw;
    property PflgHlwSpannweite: word read FPflgHlwSpannweite write FPflgHlwSpannweite;
    property PflgHlwWurzeltiefe: currency read FPflgHlwWurzeltiefe write FPflgHlwWurzeltiefe;
    property PflgHlwAussentiefe: currency read FPflgHlwAussentiefe write FPflgHlwAussentiefe;
    property PflgHlwPfeilung: currency read FPflgHlwRandbogen write FPflgHlwRandbogen;
    property PflgHlwKnicke: TPfeilungsItems read FPflgHlwKnicke write FPflgHlwKnicke;

    { Read-Only Properties (wird berechnet in AuslegungBerechnen() ) }
    property SpannweiteInMeter: currency read GetSpannweiteInMeter; // Spannweite in M
    property F: currency read FF; // Tragflügelfläche in dm2
    property T4: currency read FT4; // Mittlere Flügeltiefe (arithmetisch) in mm
    property TMF: currency read FTMF; // Mittlere Flügeltiefe (geometrisch) in mm
    property XTMF: currency read FXTMF; // Berechnung Abstand tmF/4 von Längsachse
    property G: currency read FG; // Modellgewicht in Gramm
    property RH: currency read FRH; // Leitwerkshebelarm in dm
    property cm0: currency read Fcm0;
    property cm0zwi: currency read Fcm0zwi;
    property Alpha0: currency read FAlpha0;
    property NE: currency read FNE; // Neutralpunktrücklage in mm
    property DP: currency read FDP; // Schwerpunkt (=Druckpunkt) -lage für Entwurfs-Ca hinter Profilnase bei tmF nach Perseke
    property NasWu: currency read FNasWu; // Rücklage der Nase in mm bei TMF gegen Nasenlage Wurzelprofil
    property NP: currency read FNP; // Gewünschte Neutralpunktlage in mm hinter TmF
    property NPNeu: currency read FNPNeu; // Neue Berechnung Stabilitätsmass nach cm0
    property LHLw: currency read FLHLw; // ergibt Streckung zwischen ca. 3.5 und 7 (bei 7m)
    property BF: currency read FBF; // Berichtigungsfaktor
    property FH: currency read FFH; // HLW-Fläche in dm2
    property VH: currency read FVH; // Flächenverhältnis von HLW zu Tragflügelin %
    property FAI: currency read FFAI; // Flächenbelastung in g/qdm gem. FAI -Bestimmungen
    property BHLw: currency read FBHLw; // Spannweite HLW in mm
    property TMH: currency read FTMH; // Mittlere Tiefe (arithmetisch) in mm
    property FS: currency read FFS; // Fläche Seitenleitwerk
    property STFH: currency read FSTFH; // Stabilitätsfaktor HLW
    property STFS: currency read FSTFS; // Stabilitärsfaktor (Seitenstabilität nach Thies)
    property T3F: currency read FT3F; // Zuspitzungsberechnung
    property Z: currency read FZ; // Effektive Zuspitzung
    property L1: currency read FL1; // Streckung (Lambda) des Tragflügels
    property LKZ: currency read FLKZ; // Allround (Modell-Ca von 0.3 bis 0.9)
    property LKZTH: currency read FLKZTH; // Thermik (Modell-Ca von 0.6 bis 1.0)
    property LKZSTR: currency read FLKZSTR; // Hang/Strecke (Modell-Ca von 0.2 bis 0.6)

    property Leistungsdaten: TLeistungsdaten read GetLeistungsdaten write FLeistungsdaten;

    { Neutralpunktberechnungen }
    property Schwerpunkte: TDruckpunktItems read FSchwerpunkte write FSchwerpunkte; // Druckpunkte für momentfreies Fliegen
    property RL: currency read FRL write FRL; // Leiterwerkshebelarm
    property XNAlth: currency read FXNAlth write FXNAlth; // Neutralpunkt nach Althaus
    property XNPerseke: currency read FXNPerseke write FXNPerseke; // Neutralpunkt nach Perseke
    property XNSchenk: currency read FXNSchenk write FXNSchenk; // Neutralpunkt nach Schenk
    property SP1: currency read FSP1 write FSP1; // Scherpunktlage 1
    property SP2: currency read FSP2 write FSP2; // Scherpunktlage 2
    property SP3: currency read FSP3 write FSP3; // Scherpunktlage 3
    { Flügel }
    property FLW: currency read FFLW write FFLW; // Streckung
    property LA: currency read FLA write FLA; // Flächeninhalt
    property LM: currency read FLM write FLM; // Bezugsflügeltiefe
    property XN: currency read FXN write FXN; // Neutralpunktlage hinter Nase Wurzel
    { HLW }
    property FHLW: currency read FFLWH write FFLWH; // Streckung HLW
    property LAH: currency read FLAH write FLAH; // Flächeninhalt HLW
    property LMH: currency read FLMH write FLMH; // Bezugsflügeltiefe HLW
    property XNH: currency read FXNH write FXNH; // Neutralpunktlage hinter Nase Wurzel HLW

    { Holmberechnung }
    property Auftrieb: currency read FAuftrieb; // Auftrieb
    property MaxBiegemoment: currency read FMaxBiegemoment; // maximale Biegemoment
    property OertlicheBeanspruchung: currency read FOertlicheBeanspruchung; // Örtliche Beanspruchung
    property QuerkraftbeanspruchungHolm: currency read FQuerkraftbeanspruchungHolm; // Querkraftbeanspruchung des Flächenholms
    property Holme: THolmList read FHolme; // Holmliste

    { Berechnungsparameter }
    property NpVonCa: currency read FNpVonCa write FNpVonCa;
    property NpBisCa: currency read FNpBisCa write FNpBisCa;

    property Holmart: integer read FHolmart write FHolmart;
    property MaxCa: currency read FMaxCa write FMaxCa;
    property MaxV: byte read FMaxV write FMaxV;
    property ArtSteckverbindung: byte read FArtSteckverbindung write FArtSteckverbindung;
  end;

  TModellVarianten = class(TObjectList)
  private
    FModell : TObject;
    function  Get(Index: Integer): TModellVariante;
    procedure Put(Index: Integer; Item: TModellVariante);
    function GetVarianteByName(AName: string): TModellVariante;
  public
    constructor Create(AModell: TObject); virtual;
    function AddVariante(AVarianteName: string) : TModellVariante;
    function Save(ANode: IXMLNode) : boolean;
    function Load(ANode: IXMLNode) : boolean;
    function CheckNewName(AName: string) : boolean;
    function DeleteVariante(AVariante: TModellVariante): boolean;
    procedure CalcLeistungsdaten;

    property VarianteByName[AName: string] : TModellVariante read GetVarianteByName;
    property Items[Index: Integer]: TModellVariante read Get write Put;
  end;


implementation

uses
  math, main, modell, ad_utils, maindata;

{ TModellVariante }

function TModellVariante.GetSpannweiteInMeter: currency;
begin
  result := FSpannweite / 1000;
end;

procedure TModellVariante.SetSpannweite(const Value: word);
begin
  if FSpannweite <> Value then begin
    if Value <= 0 then
      raise EVariantenError.Create(dmMain.Translator.GetLit('ValidationWingSpanRequired'))
    else begin
      FSpannweite := Value;
    end;
  end;
end;

procedure TModellVariante.SetVariantenName(const Value: string);
begin
  FVariantenName := Value;
end;

constructor TModellVariante.Create(AModell: TObject);
begin
  FModell := AModell;
  FProfilInnen := TProfil.Create;
  FProfilAussen := TProfil.Create;
  FLeistungsdaten := nil;
  PflgFlKnicke := TPfeilungsItems.Create;
  PflgHlwKnicke := TPfeilungsItems.Create;
  FSchwerpunkte := TDruckpunktItems.Create(true);
  FHolme:= THolmList.Create;
  InitFields;
end;

destructor TModellVariante.Destroy;
begin
  FreeAndNil(FSchwerpunkte);
  FreeAndNil(FPflgHlwKnicke);
  FreeAndNil(FPflgFlKnicke);
  FreeAndNil(FLeistungsdaten);
  FreeAndNil(FProfilInnen);
  FreeAndNil(FProfilAussen);
  FreeAndNil(FHolme);
  inherited;
end;

procedure TModellVariante.SetProfilAussen(const Value: TProfil);
begin
  FProfilAussen := Value;
end;

procedure TModellVariante.SetProfilnnen(const Value: TProfil);
begin
  FProfilInnen := Value;
end;

procedure TModellVariante.AuslegungBerechnen;
var
 dbg : currency;
begin
  if (Schwerpunkt = 0) then exit;

  try

    // Prüfung auf Tragflügelgeometrie
    if RealeTiefeTrapezstoss = Wurzeltiefe then FWurzeltiefe := FWurzeltiefe + 0.1;
    if TiefeRandbogen = RealeTiefeTrapezstoss then TiefeRandbogen := TiefeRandbogen - 0.1;

    FF := (Spannweite * (RealeTiefeTrapezstoss + TiefeRandbogen) / 2 + RealeLageTrapezstoss * (Wurzeltiefe - TiefeRandbogen)) / 10000; // Tragflügelfläche in dm2
    FT4 := F / Spannweite * 10000; // Mittlere Flügeltiefe (arithmetisch) in mm

    // Prüfung auf Rechteck- oder Einfachtrapezfläche
    if RealeLageTrapezstoss / (Wurzeltiefe - RealeTiefeTrapezstoss) = Spannweite / 2 / (Wurzeltiefe - TiefeRandbogen) then
    begin
      FTMF := SQRT((Power(Wurzeltiefe, 2) + Power(TiefeRandbogen, 2)) / 2); // Mittlere Flügeltiefe (geometrisch) in mm, s. Perseke, Bd. 3, S. 125 (gilt nur für Rechteck- und Einfachtrapezflügel)
      FXTMF := Spannweite / 2 * (Wurzeltiefe - TMF) / (Wurzeltiefe - TiefeRandbogen); // Berechnung Abstand tmF/4 von Längsachse gem. "AERO 1" in mm für Rechteck- und Einfachtrapezflügel
    end else begin
      // Prüfung auf Lage des tmF/4-Punktes im Aussentrapez
      if (Wurzeltiefe + RealeTiefeTrapezstoss) / 2 * RealeLageTrapezstoss < 10000 * F / 4 then begin
        FTMF := SQRT(Power(TiefeRandbogen, 2) + 10000 * F / (Spannweite / 2 - RealeLageTrapezstoss) / 2 * (RealeTiefeTrapezstoss - TiefeRandbogen)); // Mittlere Tiefe (geometrisch), wenn tmF/4-Punkt im Aussentrapez
        FXTMF := Spannweite / 2 - ((10000 * F / 4) / ((TMF + TiefeRandbogen) / 2)) // Abstand tmF/4-Punkt von Längsachse, wenn tmF/4-Punkt im Aussentrapez
      end else begin
        dbg := Power(Wurzeltiefe, 2) - 10000 * F / 2 / RealeLageTrapezstoss * (Wurzeltiefe - RealeTiefeTrapezstoss);
        FTMF := SQRT(dbg); // Mittlere Flügeltiefe (geometrisch) bei Doppeltrapezflügel, wenn tmF/4-Punkt im Innentrapez
        FXTMF := RealeLageTrapezstoss * (Wurzeltiefe - TMF) / (Wurzeltiefe - RealeTiefeTrapezstoss); // Abstand tmF/4-Punkt von Längsachse in mm bei Doppeltrapezflügel, wenn TmF/4 im Innentrapez
      end;
    end;
    {
    4160 IF (T1 + T2) / 2 * L < 10000 * F / 4 THEN 4190 ' Prfung auf Lage des tmF/4-Punktes im Auáentrapez
    TMF = SQR(T1 ^ 2 - 10000 * F / 2 / L * (T1 - T2)) ' Mittlere Flgeltiefe (geometrisch) bei Doppeltrapezflgel, wenn tmF/4-Punkt im Innentrapez
    XTMF = L * (T1 - TMF) / (T1 - T2): GOTO 4210 ' Abstand tmF/4-Punkt von L„ngsachse in mm bei Doppeltrapezflgel, wenn TmF/4 im Innentrapez
    4190 TMF = SQR(T3 ^ 2 + 10000 * F / (B / 2 - L) / 2 * (T2 - T3)) ' MIttlere Tiefe (geometrisch), wenn tmF/4-Punkt im Auáentrapez
    XTMF = B / 2 - ((10000 * F / 4) / ((TMF + T3) / 2)) ' Abstand tmF/4-Punkt von L„ngsachse, wenn tmF/4-Punkt im Auáentrapez
    }

    FL1 := Power(Spannweite, 2) / F / 10000; // Streckung (Lambda) des Tragflügels
    FG := Flaechenbelastung * F; // Modellgewicht in Gramm

    // RH bei vorgegebenem Leitwerkshebelarm
    if Leitwerkshebel = 0 then begin
      FRH := (0.0476 * (Spannweite / 1000 - 1.8) + 0.7) * Power(L1, 1/8) * SQRT(F / 100) * 10;
      // Leitwerkshebelarm in dm; s. Perseke, Bd. 3, S. 124; alte Formel
      // RH = ((.11 * (LOG(B / 1000) - .56) + .67) * (L1 ^ (1 / 8) * ((F / 100) ^ (1 / 2)) * 10))' neue Formel nach Perseke
      // RH hier in dm!
    end else
      FRH := Leitwerkshebel;

    Fcm0 := ProfilInnen.cm0 + 2 * XTMF * (ProfilAussen.cm0 - ProfilInnen.cm0) / Spannweite;
    Fcm0zwi := cm0;
    FAlpha0 := ProfilInnen.Alpha0 + 2 * XTMF * (ProfilAussen.Alpha0 - ProfilInnen.Alpha0) / Spannweite;
    // FStabilitaetsmass := Power(ABS(cm0), (1 / STM)) * 68.2; // Stab.-Mass Sigma in % der mittleren
    //        Tragflügeltiefe n. Perseke,Bd. 3,S. 112 (Diagr. 4); Wert kann je nach
    //        gewünschtem Stab.-Mass zw. 1.9 (gross) u. 1.4 (klein) gewählt werden;
    //        bei Profilen m. grossem cm0 auch wesentl. kleiner
    //        entspricht dem Abstand zwischen Schwerpunkt und Neutralpunkt
    FNE := TMF * Stabilitatsmass / 100; // [mm] Neutralpunktrüclage hinter dem Schwerpunkt in mm nach Perseke, Bd. 3, S. 125
    FDP := TMF * (-cm0 / Schwerpunkt + 0.25); // [mm] Schwerpunkt(=Druckpunkt)lage für Entwufs-Ca hinter Profilnase bei tmF nach Perseke, Bd. 3, S. 125
    FNasWu := (Wurzeltiefe - TMF) / 4; // Rücklage der Nase in mm bei TMF gegen Nasenlage Wurzelprofil
    FNP := DP + NE; // Gewünschte Neutralpunktlage in mm hinter Tmf nach Perseke, Bd. 3, S. 125, Formel 16
    FNPNeu := Power(ABS(cm0), (1 / 2)) * 48 - Power((12.66 * ABS(cm0)), 1.38) + 2.65; // Neue Berechnung Stabilitätsmass nach cm0 gem. Perseke
    // LHLw = 3.5 + (B / 1000) ^ (1 / 3) ' Streckung HLW gem. Formel aus FMT 4/83, S. 308
    // LHLw=2.35*B^(1/2.1)  ' Streckung HLW errechnen; Formel s. Brief
    //       Perseke v. 14.01.89  Anm.: Grosse Skepsis; evtl. 2.35 +; aber auch dann sehr kleine Streckungen
    FLHLw := 3 + Spannweite / 2000; // ergibt Streckungen zwischen  ca. 3.5 und 7 (bei 7m)
    // BF = ((L1 - 3) ^ (1 / ((L1 - 4) * .13 + 7)) + 2 * (LOG(LHLw) / LOG(10))) / 5.45
    //     Berichtigungsfaktor fr HLW gem. Perseke, bd. 3, S 118
    FBF := (Power((L1 - 3.2), (1 / ((L1 - 4) * 0.13 + 7))) + 2 * (Log10(LHLw) / Log10(10))) / 5.287;  // Berichtigungsf. gem. Perseke, geänderte Formel, s. Brief v. 14.1.89
    FFH := ((NP - 0.25 * TMF) * FF) / (RH * 100 * BF); // HLW-Fläche in dm2 nach Perseke, Bd. 3, S. 125
    //	FH = ((NP - .25 * TMF) * F) / (RH * 100 * BF) ' HLW-Fl„che in dmý nach Perseke, Bd. 3, S. 125
    FDP := DP + NasWu; // Druckpunktlage hinter Wurzelnase
    FNP := NP + NasWu; // Neutralpunktlage hinter Wurzelnase
    FVH := (FH / F) * 100; // Flächenverhältnis von HLW zu Tragflügel in %
    {
    if VH <= 1 then
      raise EVariantenError.Create('Die Rechnung ergibt unsinnige Werte! U.U. haben Sie für ein symmetrisches '+
                                   'oder ein S-Schlag-Profil ein zu kleines Stabilitätsmass gewählt. '+
                                   'Bitte ändern Sie Ihre Werte.');
    }
    FFAI := {10 * }G / (F + FH); // Flächenbelastung in g/qdm gem. FAI-Bestimmungen
    FBHLw := SQRT(LHLw * FH) * 100; // Spannweite HLW in mm nach Perseke, Bd. 3, S. 125
    FTMH := FH / (BHLw / 10000); // Mittlere Tiefe (arithmetisch) in mm gem. Perseke, Bd. 3, S. 125
    FFS := ((F / 100) * (Spannweite / 1000)) / ((35.5 * Power((1.4 / (Spannweite / 1000)), (1 / 3))) * (RH / 1000) * 2);
    // Fläche Seitenleitwerk gem. Perseke, Bd. 3, S. 125; Faktor 2.57
    // (statt 1.4) nach Perseke ergibt zu kleine SLW bei Vergleich mit Stab.-Faktor nach Thies
    FSTFH := RH * FH / F / TMF * 100; // Stabilitätsfaktor HLW
    // (Längsstabilität) nach Thies, Bd. 1, S. 78 ff.
    FSTFS := ((F * (Spannweite / 2 * 100)) / (RH * FS)) / 10000; // Stabilitätsfaktor
    // Seitenstabilität nach Thies, Bd. 1, S. 91 ff.
    FT3F := 20000 * F / Spannweite - Wurzeltiefe; // Ersatzaussentiefe des Tragflügels für Zuspitzungsberechnung, gültig für Trapez- und Doppeltrapezflügel
    FZ := T3F / Wurzeltiefe; // Effektive Zuspitzung Trapez- und Doppeltrapezflügel

    CalcLeistungsdaten;

  except
   
  end;

end;

function TModellVariante.GetModell: TObject;
begin
  if assigned(FModell) then
    result := FModell
  else
    Result := CurrentModell;
end;

procedure TModellVariante.SetAltered;
begin
  TModell(FModell).Altered := true;
end;

procedure TModellVariante.InitFields;
begin
  VariantenName := '';

  Spannweite := 0;
  Flaechenbelastung := 0;
  Wurzeltiefe := 0;
  LageTrapezstoss := 0;
  TiefeTrapezstoss := 0;
  TiefeRandbogen := 0;
  Leitwerkshebel := 0;
  Stabilitatsmass := 0;
  Schwerpunkt := 0;

  PflgFlRandbogen := 0;
  PflgHlwSpannweite := 0;
  PflgHlwWurzeltiefe := 0;
  PflgHlwAussentiefe := 0;
  PflgHlwPfeilung := 0;

  FNpVonCa := 0.2;
  FNpBisCa := 0.9;
end;

function TModellVariante.Save(ANode: IXMLNode): boolean;
var
  i : integer;
begin
  result := true;

  with ANode.AddChild('variante') do begin
    Attributes['name'] := FVariantenName;
    Attributes['beschreibung'] := FVariantenBeschreibung;
    with AddChild('ProfilInnen') do Text := ProfilInnen.Dateiname;
    with AddChild('ProfilAussen') do Text := ProfilAussen.Dateiname;
    with AddChild('Spannweite') do Text := IntToStr(Spannweite);
    with AddChild('Flaechenbelastung') do Text := ADCurrToStr(Flaechenbelastung);
    with AddChild('Wurzeltiefe') do Text := ADCurrToStr(Wurzeltiefe);
    with AddChild('LageTrapezstoss') do Text := ADCurrToStr(LageTrapezstoss);
    with AddChild('TiefeTrapezstoss') do Text := ADCurrToStr(TiefeTrapezstoss);
    with AddChild('TiefeRandbogen') do Text := ADCurrToStr(TiefeRandbogen);
    with AddChild('Leitwerkshebel') do Text := ADCurrToStr(Leitwerkshebel);
    with AddChild('Stabilitaetsmass') do Text := ADCurrToStr(Stabilitatsmass);
    with AddChild('Schwerpunkt') do Text := ADCurrToStr(Schwerpunkt);

    { Berechnungsparameter }
    with AddChild('ParamFromCa') do Text := ADCurrToStr( NpVonCa );
    with AddChild('ParamToCa') do Text := ADCurrToStr( NpBisCa );
    with AddChild('ParamHolmart') do Text := IntToStr( Holmart );
    with AddChild('ParamMaxCa') do Text := ADCurrToStr( MaxCa );
    with AddChild('ParamMaxV') do Text := ADCurrToStr( MaxV );
    with AddChild('ParamArtSteckverbindung') do Text := IntToStr( ArtSteckverbindung );

    { Subnode mit "Pfeilung" }
    with AddChild('Details') do begin

      { Subnode für Pfeilung > Fläche }
      with AddChild('Flaeche') do begin
        with AddChild('Randbogen') do Text := ADCurrToStr(PflgFlRandbogen);
        with AddChild('HolmbreiteWurzel') do Text:= IntToStr( HolmbreiteWurzel );
        with AddChild('HolmbreiteRandbogen') do Text:= IntToStr( HolmbreiteRandbogen );
        with AddChild('ProfildickeWurzel') do Text:= ADCurrToStr(ProfildickeWurzel);
        with AddChild('ProfildickeRandbogen') do Text:= ADCurrToStr(ProfildickeRandbogen);

        { Knicke der Fläche }
        with AddChild('Knicke') do begin
           if PflgFlKnicke.Count > 0 then
             for i:= 0 to pred(PflgFlKnicke.Count) do
               with AddChild('Knick') do begin
                 with AddChild('Abstand') do Text := IntToStr(PflgFlKnicke.Items[i].Abstand);
                 with AddChild('Fluegeltiefe') do Text := IntToStr(PflgFlKnicke.Items[i].Fluegeltiefe);
                 with AddChild('Pfeilung') do Text := IntToStr(PflgFlKnicke.Items[i].Pfeilung);
                 with AddChild('Profildicke') do Text := ADCurrToStr(PflgFlKnicke.Items[i].ProfilDicke);
               end;

        end;

      end;

      { Subnode für Pfeilung > HLW }
      with AddChild('Hlw') do begin
        with AddChild('AbstandFluegelHlw') do Text := IntToStr(PflgHlwAbstandFluegelHlw);
        with AddChild('Spannweite') do Text := IntToStr(PflgHlwSpannweite);
        with AddChild('Wurzeltiefe') do Text := ADCurrToStr(PflgHlwWurzeltiefe);
        with AddChild('Aussentiefe') do Text := ADCurrToStr(PflgHlwAussentiefe);
        with AddChild('Pfeilung') do Text := ADCurrToStr(PflgHlwPfeilung);

        { Knicke des HLW }
        with AddChild('Knicke') do begin
           if PflgHlwKnicke.Count > 0 then
             for i:= 0 to pred(PflgHlwKnicke.Count) do
               with AddChild('Knick') do begin
                 with AddChild('Abstand') do Text := IntToStr(PflgHlwKnicke.Items[i].Abstand);
                 with AddChild('Fluegeltiefe') do Text := IntToStr(PflgHlwKnicke.Items[i].Fluegeltiefe);
                 with AddChild('Pfeilung') do Text := IntToStr(PflgHlwKnicke.Items[i].Pfeilung);
               end;

        end;
      end;
    end;
  end;

end;

function TModellVariante.Load(ANode: IXMLNode): boolean;
var
  DetNode,
  Det2Node : IXMLNode;

  function GetStrAttr(AName: string): string;
  begin
    result := '';
    if ANode.Attributes[AName] <> null then result := ANode.Attributes[AName];
  end;

  function GetStrChild(AName: string; AChildNode: IXMLNode = nil): string;
  begin
    result := '';

    if AChildNode = nil then AChildNode := ANode;

    if  (AChildNode.ChildValues[AName] <> null)
    and (VarIsStr(AChildNode.ChildValues[AName])) then
      result := AChildNode.ChildValues[AName];
  end;

  procedure GetKnickeFor(ADetailNode: IXMLNode; APfeilungsItems: TPfeilungsItems);
  var
    i : integer;
    KNode: IXMLNode;                  // "Knicke"-Node
    PfItem : TPfeilungsItem;
  begin
    APfeilungsItems.Clear;

    { Node "Knicke" suchen }
    KNode := ADetailNode.ChildNodes.FindNode('Knicke');
    if  (assigned(KNode))
    and (KNode.ChildNodes.Count > 0) then

      { Nodes "Knick" abarbeiten }
      for i := 0 to pred( KNode.ChildNodes.Count ) do begin
        PfItem := TPfeilungsItem.Create;

        PfItem.Abstand := StrToIntDef( GetStrChild('Abstand', KNode.ChildNodes[i]), 0);
        PfItem.Fluegeltiefe := StrToIntDef( GetStrChild('Fluegeltiefe', KNode.ChildNodes[i]), 0);
        PfItem.Pfeilung := StrToIntDef( GetStrChild('Pfeilung', KNode.ChildNodes[i]), 0);
        PfItem.Profildicke := ADStrToCurr( GetStrChild('Profildicke', KNode.ChildNodes[i]), 0);

        APfeilungsItems.Add(PfItem);
      end;

  end;

begin

  { Allgemeines (1. Seite) }
  FVariantenName := GetStrAttr('name');
  FVariantenBeschreibung := GetStrAttr('beschreibung');
  ProfilInnen.Dateiname := GetStrChild('ProfilInnen');
  ProfilAussen.Dateiname := GetStrChild('ProfilAussen');
  Spannweite := StrToIntDef(GetStrChild('Spannweite'), 0);
  Flaechenbelastung := ADStrToCurr(GetStrChild('Flaechenbelastung'));
  Wurzeltiefe := ADStrToCurr(GetStrChild('Wurzeltiefe'));
  LageTrapezstoss := ADStrToCurr(GetStrChild('LageTrapezstoss'));
  TiefeTrapezstoss := ADStrToCurr(GetStrChild('TiefeTrapezstoss'));
  TiefeRandbogen := ADStrToCurr(GetStrChild('TiefeRandbogen'));
  Leitwerkshebel := ADStrToCurr(GetStrChild('Leitwerkshebel'));
  Stabilitatsmass := ADStrToCurr(GetStrChild('Stabilitaetsmass'));
  Schwerpunkt := ADStrToCurr(GetStrChild('Schwerpunkt'));

  { Berechnungsparameter }
  NpVonCa:= ADStrToCurr(GetStrChild('ParamFromCa'), 0.1);
  NpBisCa:= ADStrToCurr(GetStrChild('ParamToCa'), 1.1);
  Holmart:= StrToIntDef(GetStrChild('ParamHolmart'), 0);
  MaxCa:= ADStrToCurr(GetStrChild('ParamMaxCa'), 1.0);
  MaxV:= StrToIntDef(GetStrChild('ParamMaxV'), 40);
  ArtSteckverbindung:= StrToIntDef(GetStrChild('ParamArtSteckverbindung'), 0);

  { Details }
  PflgFlKnicke.Clear;
  PflgHlwKnicke.Clear;

  DetNode := ANode.ChildNodes.FindNode('Details');
  if assigned(DetNode) then begin

    { Fläche }
    Det2Node := DetNode.ChildNodes.FindNode('Flaeche');
    if assigned(Det2Node) then begin
      PflgFlRandbogen := ADStrToCurr( GetStrChild('Randbogen', Det2Node), 0);
      HolmbreiteWurzel := StrToIntDef( GetStrChild( 'HolmbreiteWurzel', Det2Node), 0 );
      HolmbreiteRandbogen := StrToIntDef( GetStrChild( 'HolmbreiteRandbogen', Det2Node), 0 );
      ProfildickeWurzel := ADStrToCurr( GetStrChild('ProfildickeWurzel', Det2Node), 0 );
      ProfildickeRandbogen := ADStrToCurr( GetStrChild('ProfildickeRandbogen', Det2Node), 0 );
      GetKnickeFor(Det2Node, PflgFlKnicke);
    end;
    Det2Node := nil;

    { HLW }
    Det2Node := DetNode.ChildNodes.FindNode('Hlw');
    if assigned(Det2Node) then begin
      PflgHlwAbstandFluegelHlw := StrToIntDef( GetStrChild('AbstandFluegelHlw', Det2Node), 0);
      PflgHlwSpannweite := StrToIntDef( GetStrChild('Spannweite', Det2Node), 0);
      PflgHlwWurzeltiefe := ADStrToCurr( GetStrChild('Wurzeltiefe', Det2Node), 0);
      PflgHlwAussentiefe := ADStrToCurr( GetStrChild('Aussentiefe', Det2Node), 0);
      PflgHlwPfeilung := ADStrToCurr( GetStrChild('Pfeilung', Det2Node), 0);
      GetKnickeFor(Det2Node, PflgHlwKnicke);
    end;
    Det2Node := nil;

  end;

  result := true;
end;

function TModellVariante.GetLeistungsdaten: TLeistungsdaten;
begin
  if not assigned(FLeistungsdaten) then
    FLeistungsdaten := TLeistungsdaten.Create;
  Result := FLeistungsdaten;
end;

procedure TModellVariante.CalcLeistungsdaten;
var
  c, x1, c6, c7, r5, r6, e1,
  f1, f2, r,
  c2z, c3z, c4z, c5z : currency;
  Ez, Sz, EWDz, Dz : currency;
  iZeile : integer;
  Leistung : TLeistungsItem;
  EndP : word;
  EMax: currency;
  DE, DS, DESTR, DSSTR, DETH, DSTH : currency;

  function Leistungsberechnung(AProfil : TProfil): boolean;
  var
    F3, F4, F5, F6, Fl, Ch,
    S1, R4, L2, T5: currency;

    procedure CalcCWI;  // 7140
    begin
      // Berechnung cwi für Rechteckfläche berichtigt gem. Perseke, Bd. 3, S. 17
      Leistung.cwi := power(C, 2) / ((4 * ArcTan(1)) * L1 * ((100 - (power((TiefeRandbogen / Wurzeltiefe), 2)) * power(L1, 2.3) / power(L1, 1.5)) / 100));
    end;

    procedure CalcS1;  // 7100
    begin
      // Integration des cwp über die Spannweite
      S1 := S1 + X1 * C6 * power((R5 / (70 * Leistung.V_ms)), E1) * (power(F1, (1 - E1)) - power(F2, (1 - E1))) / ((F1 - F2) * (1 - E1));
    end;

    procedure CalcCWP; // 7040
    var
      i : integer;
    begin
      C6 := 0;
      C7 := 0;
      R5 := 0;
      R6 := 0;

//      if r <= R4 then i := 0
//      else i := 1;

      i:= AProfil.Polaren.GetNearestByRe( r );

      if (AProfil.Polaren.Count-1 >= i)
        and ( i > 0 )
      then begin
        C6 := AProfil.Polaren.Items[i-1].GetCWcalcByCA(c);
        C6 := C6 - int(C6);
        R5 := AProfil.Polaren.Items[i-1].re;
      end;
      if (AProfil.Polaren.Count >= i)
        and (i > -1) then begin
        C7 := AProfil.Polaren.Items[i].GetCWcalcByCA(c);
        C7 := C7 - int(C7);
        R6 := AProfil.Polaren.Items[i].re;
      end;
      if (C6 = 0) or (C7 = 0) or (R6 = 0) or (R5 = 0) then begin
        EndP := 1;
      end else begin
        E1 := Log10(C6 / C7) / Log10(R6 / R5); // Log. Interpolation des cwp zwischen den Polaren
//        E1 := Log10(C7) / Log10(R6); // Log. Interpolation des cwp zwischen den Polaren
      end;
    end;


  begin

    result := true;
    S1 := 0;
    F3 := 0;
    F4 := 0;
    F5 := 0;
    F6 := 0;
    Fl := 0;
    Ch := 0;
    R4 := 0;
    L2 := 0;
    T5 := 0;
    with Leistung do begin
      V_ms := 4 * SQRT(Flaechenbelastung / (C*10));      // Geschwindigkeit in m/s
      V_kmh := V_ms * 3.6;                         // Geschwindigkeit in km/h
      Rem := 70 * V_ms * TMF;               // Re (mittlere bei aerodyn. Flügelmitte)
      Rei := 70 * V_ms * Wurzeltiefe;       // Re innen
      Rea := 70 * V_ms * TiefeRandbogen;    // Re aussen
      S1 := 0;
//      if AProfil.Polaren.Count > 1 then            // ??? Warum wird hier wohl die 2. RE-Zahl genommen ??? Ist aus dem alten Aerodesign übernommen.
//        R4 := AProfil.Polaren.Items[1].re
//      else
//        R4 := 0;
      R4:= AProfil.Polaren.Items[ AProfil.Polaren.GetNearestByRe( Rei )].re;
      T5 := R4 / 70 / V_ms;

      if (T5 > Wurzeltiefe) or (T5 < TiefeRandbogen) then begin
        T5 := (Wurzeltiefe + RealeTiefeTrapezstoss) / 2;
        L2 := RealeLageTrapezstoss * (Wurzeltiefe - T5) / (Wurzeltiefe - RealeTiefeTrapezstoss);
        F3 := T5;
        F4 := L2;
        F5 := RealeTiefeTrapezstoss;
        F6 := Spannweite / 2 - RealeLageTrapezstoss;
        Fl := 0
      end else
      if (T5 >= RealeTiefeTrapezstoss) then begin
        L2 := RealeLageTrapezstoss + (Spannweite / 2 - RealeLageTrapezstoss) * (RealeTiefeTrapezstoss - T5) / (RealeTiefeTrapezstoss - TiefeRandbogen);
	      F3 := RealeTiefeTrapezstoss;
        F4 := RealeLageTrapezstoss;
        F5 := T5;
        F6 := Spannweite / 2 - L2;
        Fl := 1;
      end else begin
        T5 := (Wurzeltiefe + RealeTiefeTrapezstoss) / 2;
        L2 := RealeLageTrapezstoss * (Wurzeltiefe - T5) / (Wurzeltiefe - RealeTiefeTrapezstoss);
        F3 := T5;
        F4 := L2;
        F5 := RealeTiefeTrapezstoss;
        F6 := Spannweite / 2 - RealeLageTrapezstoss;
        Fl := 0
      end;

      r := Rei;
      CalcCWP;
      F1 := Wurzeltiefe;
      F2 := F3;
      X1 := F4;
      CalcS1;
      if Fl = 0 then begin
        r := 70 * V_ms * T5;
        CalcCWI;
      end;
      F1 := F3;
      F2 := F5;
      X1 := ABS(RealeLageTrapezstoss - L2);
      CalcS1;
      if Fl = 1 then begin
        r := 70 * V_ms * T5;
        CalcCWP;
      end;
      Fl := F5;
      F2 := TiefeRandbogen;
      X1 := F6;
      CalcS1;
      cwp := S1 / 10 / Spannweite * 2;

      // Prüfung auf Rechteckfläche und Streckung < 8
      if (RealeTiefeTrapezstoss = Wurzeltiefe) and (RealeTiefeTrapezstoss = TiefeRandbogen) and (L1 < 8) then
      begin
        // Induzierter Widerstand
        cwi := Power(C, 2) / ((4 * ArcTan(1)) * L1);
      end else begin
        // Berechnung cwi für Rechteckfläche berichtigt gem. Perseke, Bd. 3, S. 17
        cwi := Power(C, 2) / ((4 * ArcTan(1)) * L1 * ((100 - (power((TiefeRandbogen / Wurzeltiefe), 2)) * power(L1, 2.3) / power(L1, 1.5)) / 100));
      end;

      cw := (8 / 1000) * (C - 0.3) + 0.0025; // Rumpf- und Interferenzwiderstandsbeiwert nach Dr. Torunski, FMT 7/85, S. 572
      Ch := 0.036 * ((power(0.3, 2.4) / 20) + (28 / power((v_ms * 70 * TMH), 0.7))) * (VH / 100); // HLW-Widerstand; Beiwert nach Dr. Torunski, FMT 7/85, S. 572, anteilmässig entsprechend prozenzualem Verhältnis HLW zu Flügelfläche
      EWD := 9.119 * C * (1 + (2 / L1)) + AProfil.Alpha0;
      EWD := EWD - 9.119 * C / L1 * (1 + SQRT(1 + power(((L1 * TMF) / (200 * RH)), 2)));
      // Einstellwinkeldifferenz (EWD) für alle Ca gem. Perseke, Bd. 3, S. 125
      cwges := cw + cwp + cwi + Ch; // Cwges; in Bildschirmdarstellung und Ausdruck wird CH nicht gesondert ausgegeben
      E := C / cwges; // Modellgleitzahl
      Vs := v_ms / E; // Modellsinkgeschwindigkeit
      D := TMF * (4 * (-AProfil.cm0) + C) / (4 * C); // Druckpunkt hinter Flügelnase bei tmF/4 gem. Dubs, S. 184
    end;
  end;

begin
  Leistungsdaten.Clear;
  EndP := 0;
  EMax := 0;
  DE := 0;
  DS := 0;
  DESTR := 0;
  DSSTR := 0;
  DETH := 0;
  DSTH := 0;

  FLKZ := 0;
  FLKZTH := 0;
  FLKZSTR := 0;

  if (ProfilInnen.Polaren.Count < 1)
  or (ProfilAussen.Polaren.Count < 1) then
    exit;

  for iZeile := 1 to 11 do begin
    c := iZeile / 10;

    Leistung := TLeistungsItem.Create;

    with Leistung do begin

      ca := C;

      // Erst Berechnungen mit Profil-Innen durchführen
      Leistungsberechnung(ProfilInnen);

      // Werte backupen
      c3z := cwp;
      c4z := cwi;
      c2z := cw;
      c5z := cwges;
      Ez := E;
      Sz := Vs;
      EWDz := EWD;
      Dz := D;

      // Dann Berechnungen mit Profil-Aussen durchführen
      Leistungsberechnung(ProfilAussen);

      cwp := C3z + 2 * XTMF * (cwp - C3z) / Spannweite;
      cwi := C4z + 2 * XTMF * (cwi - C4z) / Spannweite;
      cw := C2z + 2 * XTMF * (cw - C2z) / Spannweite;
      cwges := C5z + 2 * XTMF * (cwges - C5z) / Spannweite;
      E := Ez + 2 * XTMF * (E - Ez) / Spannweite;
      Vs := Sz + 2 * XTMF * (Vs - Sz) / Spannweite;
      EWD := EWDz + 2 * XTMF * (EWD - EWDz) / Spannweite;
      D := Dz + 2 * XTMF * (D - Dz) / Spannweite + NasWu;
      SP := D - (D / 100 * NPNeu);

      if EndP = 1 then
        Break
      else begin

        if (C >= 0.2) and (C <= 1.0) then begin

          if E > EMax then EMax := E;

          if (C >= 0.3) and (C <= 0.9) then begin
            DE := DE + E;
            DS := DS + Vs;
          end;

          if C <= 0.6 then begin
            DESTR := DESTR + E;
            DSSTR := DSSTR + Vs;
          end;

          if C >= 0.6 then begin
            DETH := DETH + E;
            DSTH := DSTH + Vs;
          end;

        end;
      end;
    end;

    Leistungsdaten.Add(Leistung);

  end;

  FLKZ := Int(100 * (DE * 1000) / (DS * Spannweite)) / 100 * SQRT(G / 100); // Leistungskennzahl gem. FMT-Kolleg Nr. 5
  FLKZTH := Int(100 * (DETH * 1000) / (DSTH * Spannweite)) / 100 * SQRT(G / 100);
  FLKZSTR := Int(100 * (DESTR * 1000) / (DSSTR * Spannweite)) / 100 * SQRT(G / 100);

//  FLKZ:= FLKZ / 1000;
//  FLKZTH:= FLKZTH / 1000;
//  FLKZSTR:= FLKZSTR / 1000;
end;

procedure TModellVariante.SetVariantenBeschreibung(const Value: string);
begin
  FVariantenBeschreibung := Value;
end;

function TModellVariante.RealeLageTrapezstoss: currency;
begin
  if LageTrapezstoss = 0 then begin
    result:= Spannweite / 4;
  end else begin
    result:= LageTrapezstoss;
  end;
end;

function TModellVariante.RealeTiefeTrapezstoss: currency;
begin
  if LageTrapezstoss = 0 then begin
    result:= (Wurzeltiefe + TiefeRandbogen) / 2;
  end else begin
    result:= FTiefeTrapezstoss;
  end;
end;

procedure TModellVariante.SetTiefeTrapezStoss( value: currency );
begin
  FTiefeTrapezstoss:= value;
end;

procedure TModellVariante.NeutralpunktBerechnung(AVonCa, ABisCA: currency);
var
  { Fläche }
  AN: integer;
  i: Integer;
  i1, i2: currency;
  B, T, PF, DB, DT, DPf, SL,
  K1, K2, K3, K4, K5, K6, K7, K8: array of currency;

  { HLW }
  ANH: integer;
  iH: Integer;
  iH1, iH2: currency;
  HV: currency;
  BH, TH, DBH, DTH, DPfH, SLH, DLH, DPH, PH,
  K1H, K2H, K3H, K4H, K5H, K6H, K7H, K8H: array of currency;

  NLM,                             // Nasenlage Bezugsflügeltiefe
  AW,                              // Abwindfaktor Flügel
  CS,                              // Auftriebsanstieg Flügel
  CN,                              // Anstieg Nickmoment HLW
  BF,                              // Berichtigungsfaktor
  ZN: currency;                    // Modellneutralpunkt in % der mittl. (arithmetischen) Flügeltiefe
  tmpCA: currency;
  tmpDP: currency;
  CA1: currency;
  XNS: currency;
  ET: currency;
  AWX: currency;
  RBX: currency;
  C3: currency;
  C2: currency;
  C1: currency;
  BHLX: currency;
  BVX: currency;

  procedure CalcSchwerpunkte;
  var
    i: integer;
  begin
    { Schwerpunkte }
    XNS := Min(XNSchenk, XNAlth);
    XNS := Min(XNS, XNPerseke);
    SP1 := XNS - 0.2 * LM;
    SP2 := XNS - 0.1 * LM;
    SP3 := XNS - 0.02 * LM;
    CA1 := ProfilInnen.cm0 * (1 / (0.25 + (NLM - SP1) / LM));
    tmpCA := AVonCa;
    i := 0;
    while tmpCA <= AbisCA do begin
      if tmpCa < 0.01 then tmpCA := 0.01;
      tmpDP := NLM + LM * 0.25 - LM * ProfilInnen.cm0 / tmpCA; // Druckpunktlage hinter WuNase
      Schwerpunkte.Items[i].CA := tmpCA;
      Schwerpunkte.Items[i].DP := tmpDP;
      Schwerpunkte.Items[i].EWD := Leistungsdaten.GetEWDforCA(Schwerpunkte.Items[i].CA);
      tmpCA := tmpCA + 0.1;
      inc(i);
    end;
  end;

begin
  if AVonCA = 0 then AVonCA := 0.5;
  if ABisCA = 0 then ABisCA := 0.8;

  AuslegungBerechnen();

  Schwerpunkte.Clear;

  { Anm. von Marc zum folgenden Code:
    Der Code wurde von dem alten Basic-Programm "AERO2.BAS" übernommen.
    Da Aufbau dieses Codes relativ komplex und nicht allzu strukturiert ist,
    konnnten nur wenig Änderungen bzw. Umbauten vorgenommen werden, sodass es
    nicht mehr unbedingt einen zeitgemässen und klaren Programmierstil darstellt. }

  { ------------------------------ Flächen --------------------------- }

  { Array's für Fläche initialisieren }

  tmpCA := AVonCa;
  while tmpCA <= AbisCA do begin
    Schwerpunkte.Add(tmpCA, 0, self);
    tmpCA := tmpCA + 0.1;
  end;


  AN:= PflgFlKnicke.Count + 1;
  ANH := PflgHlwKnicke.Count + 1;

  SetLength(B,   AN+2);
  SetLength(T,   AN+2);
  SetLength(PF,  AN+2);
  SetLength(DB,  AN+2);
  SetLength(DT,  AN+2);
  SetLength(DPf, AN+2);
  SetLength(SL,  AN+2);
  SetLength(K1,  AN+2);
  SetLength(K2,  AN+2);
  SetLength(K3,  AN+2);
  SetLength(K4,  AN+2);
  SetLength(K5,  AN+2);
  SetLength(K6,  AN+2);
  SetLength(K7,  AN+2);
  SetLength(K8,  AN+2);

  SetLength(BH,   ANH+2);
  SetLength(TH,   ANH+2);
  SetLength(DLH,  ANH+2);
  SetLength(DBH,  ANH+2);
  SetLength(DTH,  ANH+2);
  SetLength(DPH,  ANH+2);
  SetLength(DPfH, ANH+2);
  SetLength(SLH,  ANH+2);
  SetLength(K1H,  ANH+2);
  SetLength(K2H,  ANH+2);
  SetLength(K3H,  ANH+2);
  SetLength(K4H,  ANH+2);
  SetLength(K5H,  ANH+2);
  SetLength(K6H,  ANH+2);
  SetLength(K7H,  ANH+2);
  SetLength(K8H,  ANH+2);
  SetLength(PH,  ANH+2);


  { Benutzereingaben in die Array's abfüllen }

  B[AN]   := Spannweite;
  T[0]    := Wurzeltiefe;
  T[AN]   := TiefeRandbogen;
  PF[AN]  := PflgFlRandbogen;

  if AN > 0 then begin
    for i:= 1 to an-1 do begin
      B[i]  := 2 * PflgFlKnicke.Items[i-1].Abstand;
      T[i]  := PflgFlKnicke.Items[i-1].Fluegeltiefe;
      PF[i] := PflgFlKnicke.Items[i-1].Pfeilung;
    end;
  end;

  { Hilfsgrössen }

  for i:= 1 to AN do begin
    DT[i] := (T[i] - T[i - 1]);
    DB[i] := B[i] - B[i - 1];
    DPf[i] := PF[i] - PF[i - 1];
    SL[i] := T[i] + T[i - 1];
  end;

  { Flächeninhalt/Streckung }
  FLW := 0;
  for i:= 1 to AN do begin
    FLW := FLW + SL[i] * DB[i] / 2;
  end;
  LA := Power(B[AN], 2) / FLW;
  //FLW:= FLW / 10000;

  { Bezugsflügeltiefe }

  i1 := 0;
  for i := 1 to AN do begin  // Iterate
    K1[i] := Power(T[i - 1], 2) + DT[i] / DB[i] * B[i - 1] * (DT[i] / DB[i] * B[i - 1] - 2 * T[i - 1]);
    K2[i] := 4 * DT[i] / DB[i] * (T[i - 1] - DT[i] / DB[i] * B[i - 1]);
    K3[i] := 4 * Power(DT[i], 2) / power(DB[i], 2);
    i1 := i1 + K1[i] / 2 * (B[i] - B[i - 1]);
    i1 := i1 + K2[i] / 8 * (Power(B[i], 2) - Power(B[i - 1], 2));
    i1 := i1 + K3[i] / 24 * (Power(B[i], 3) - Power(B[i - 1], 3));
  end;     // for
  LM := 2 * i1 / FLW; // Bezugsflügeltiefe

(*
  i1 := 0;
  for i := 1 to AN do begin     // Iterate
    K1[i] := Power(T[i - 1], 2) + DT[i] / DB[i] * B[i - 1] * (DT[i] / DB[i] * B[i - 1] - 2 * T[i - 1]);
    K2[i] := 4 * DT[i] / DB[i] * (T[i - 1] - DT[i] / DB[i] * B[i - 1]);
    K3[i] := 4 * Power(DT[i], 2) / power(DB[i], 2);
    i1 := i1 + K1[i] / 2 * (B[i] - B[i - 1]);
    i1 := i1 + K2[i] / 8 * (Power(B[i], 2) - Power(B[i - 1], 2));
    i1 := i1 + K3[i] / 24 * (Power(B[i], 3) - Power(B[i - 1], 3));
  end;     // for
  LM := 2 * i1 / FLW; // Bezugsflügeltiefe
*)

  { Neutralpunktlage (geom. Neutralpukt des Flügels) }
  i2 := 0;
  for i := 1 to AN do begin     // Iterate
    K4[i] := PF[i - 1] - DPf[i] / DB[i] * B[i - 1] + T[i - 1] / 4 - DT[i] / DB[i] * B[i - 1] / 4;
    K5[i] := 2 * DPf[i] / DB[i] + DT[i] / DB[i] / 2;
    K6[i] := K4[i] * (T[i - 1] - DT[i] / DB[i] * B[i - 1]);
    K7[i] := K5[i] * (T[i - 1] - DT[i] / DB[i] * B[i - 1]) + 2 * K4[i] * DT[i] / DB[i];
    K8[i] := 2 * K5[i] * DT[i] / DB[i];
    i2 := i2 + K6[i] / 2 * (B[i] - B[i - 1]);
    i2 := i2 + K7[i] / 8 * (Power(B[i], 2) - Power(B[i - 1], 2));
    i2 := i2 + K8[i] / 24 * (Power(B[i], 3) - Power(B[i - 1], 3));
  end;     // for
  XN := 2 * i2 / FLW;      // Neutralpunktlage hinter Nase Wurzel


  { -------------------------- Höhenleitwerk (HLW) ----------------------- }

  BH[ANH]  := PflgHlwSpannweite;
  TH[0]    := PflgHlwWurzeltiefe;
  TH[ANH]  := PflgHlwAussentiefe;
  RL       := PflgHlwAbstandFluegelHlw;
  PH[ANH]  := PflgHlwPfeilung;

  if ANH > 0 then begin
    for i:= 1 to ANH-1 do begin
      BH[i]  := 2 * PflgHlwKnicke.Items[i-1].Abstand;
      TH[i]  := PflgHlwKnicke.Items[i-1].Fluegeltiefe;
      PH[i] := PflgHlwKnicke.Items[i-1].Pfeilung;
    end;
  end;

  { Hilfsgrössen }

  for i := 1 to ANH do begin
    DLH[i] := (TH[i] - TH[i - 1]);
    DBH[i] := BH[i] - BH[i - 1];
    DPH[i] := PH[i] - PH[i - 1];
    SLH[i] := TH[i] + TH[i - 1];
  end;

  { HLW-Flächeninhalt und -Streckung }

  FHLW := 0;
//  if ANH > 0 then begin
    for i := 1 to ANH do begin     // Iterate
      FHLW := FHLW + SLH[i] * DBH[i] / 2;
    end;     // for
//  end else begin
//    FHLW := ((PflgHlwWurzeltiefe + PflgHlwAussentiefe) / 2) * PflgHlwSpannweite;
//  end;
  LAH := Power(BH[ANH], 2) / FHLW;

  { Bezugsflügeltiefe HLW }

  iH1 := 0;
  for i := 1 to ANH do begin     // Iterate
    K1H[i] := Power(TH[i - 1], 2) + DLH[i] / DBH[i] * BH[i - 1] * (DLH[i] / DBH[i] * BH[i - 1] - 2 * TH[i - 1]);
    K2H[i] := 4 * DLH[i] / DBH[i] * (TH[i - 1] - DLH[i] / DBH[i] * BH[i - 1]);
    K3H[i] := 4 * Power(DLH[i], 2) / power(DBH[i], 2);
    iH1 := iH1 + K1H[i] / 2 * (BH[i] - BH[i - 1]);
    iH1 := iH1 + K2H[i] / 8 * (Power(BH[i], 2) - Power(BH[i - 1], 2));
    iH1 := iH1 + K3H[i] / 24 * (Power(BH[i], 3) - Power(BH[i - 1], 3));
  end;     // for
  LMH := 2 * iH1 / FHLW;

  { Neutralpunktlage HLW }
  iH2 := 0;
  for i := 1 to ANH do begin     // Iterate
    K4H[i] := PH[i - 1] - DPH[i] / DBH[i] * BH[i - 1] + TH[i - 1] / 4 - DLH[i] / DBH[i] * BH[i - 1] / 4;
    K5H[i] := 2 * DPH[i] / DBH[i] + DLH[i] / DBH[i] / 2;
    K6H[i] := K4H[i] * (TH[i - 1] - DLH[i] / DBH[i] * BH[i - 1]);
    K7H[i] := K5H[i] * (TH[i - 1] - DLH[i] / DBH[i] * BH[i - 1]) + 2 * K4H[i] * DLH[i] / DBH[i];
    K8H[i] := 2 * K5H[i] * DLH[i] / DBH[i];
    iH2 := iH2 + K6H[i] / 2 * (BH[i] - BH[i - 1]);
    iH2 := iH2 + K7H[i] / 8 * (Power(BH[i], 2) - Power(BH[i - 1], 2));
    iH2 := iH2 + K8H[i] / 24 * (Power(BH[i], 3) - Power(BH[i - 1], 3));
  end;     // for
  XNH := 2 * iH2 / FHLW; // Neutralpunktlage hinter Nase Wurzel HLW

  RL := RL - XN + XNH;
  HV := (FHLW / FLW) * (RL / LM);

  { Modellneutralpunkt/Schwerpunkt nach Althaus }

  NLM := XN - 0.25 * LM;                    // Nasenlage Bezugsflügeltiefe
  AW := 4 / (LA + 2);                       // Abwindfaktor Flügel
  CS := 2 * Pi * LA / (LA + 2);             // Auftriebsanstieg Flügel
  CN := -0.9 * HV * LAH * Pi / (1 + SQRT(1 + Power((LAH / 2), 2))); // Anstieg Nickmoment HLW
  ZN := 0.25 - CN / CS * (1 - AW);          // Modellneutralpunkt in % der mittl. (arithmetischen) Flügeltiefe
  XNAlth := NLM + LM * ZN;                  // Modellneutralpunkt hinter Profilnase an der Flügelwurzel

  { Modellneutralpunkt nach Perseke, Perseke Bd. 3, s. 118 }
  {TODO: Prüfen ob die richtigen LOG() Funktionen verwendet werden }
  BF := (Power((LA - 3), (1 / ((LA - 4) * 0.13 + 7))) + 2 * (Log10(LAH) / Log10(10))) / 5.45;
  XNPerseke := NLM + FHLW * RL * BF / FLW + LM / 4;

  { Berechnung des Neutralpunktes nach Schenk, s. FMT-Kolleg 7/90 }

  BVX := 0;
  for i := 1 to AN do begin     // Iterate
    BVX := BVX + B[i];
  end;     // for

  BHLX := 0;
  for i := 1 to ANH do begin     // Iterate
    BHLX := BHLX + BH[i];
  end;     // for

  C1 := FLW / FHLW;
  C2 := LA * (LAH + 2) / LAH / (LA + 2);
  C3 := 1;
  // if BVX < BHLX then C3 := BVX / BHLX;
  if B[AN] < BH[ANH] then C3 := B[AN] / BH[ANH];
  // RBX := 2 * RL / BVX;
  RBX := 2 * RL / B[AN];
  AWX := 1.65;
  if RBX <= 0.2 then begin
    raise EVariantenError.Create(dmMain.Translator.GetLit('CalcErrorStabilityMarginToLow'));
    exit;
  end;
  if RBX < 1.6 then AWX := 2.05 - 0.25 * RBX;
  if RBX < 1 then AWX := 2.92 - 1.12 * RBX;
  if RBX < 0.6 then AWX := 4.05 - 3 * RBX;
  if RBX < 0.4 then AWX := 6.14 - 8.25 * RBX;
  ET := 1 - 1 / (1 + 0.5 * LA) * C3 * AWX;
  XNSchenk := XN + RL / (C1 * C2 / ET + 1); // mm hinter Nase Wurzel

  CalcSchwerpunkte;

end;

procedure TModellVariante.Holmberechnung(ACa, AMaxV: currency; AHolmart: THolmart; AArtDerSteckung: TArtDerSteckung );
var
  SigmaZul:  currency;  // N/mm2
  TauZul:    currency;  // N/mm2
  TauKern:   currency;  // N/mm2
  holm: THolmItem;
  iHolm: Integer;
  holmbreite: currency;
  profildicke: currency;
  tmp1,
  tmp2,
  tmp3: currency;
  p: real;
  anzahlHolmpunkte: integer;

  procedure GetInterpolierteDatenAt( _abstand: currency;
    var _holmbreite, _profildicke: currency );
  var
    iKnick: integer;
    breite1, breite2, breiteDelta: currency;
    found: boolean;
    abstand1, abstand2, deltaAbstand, totalAbstand: currency;
    profildicke1, profildicke2, dickedelta: currency;
    tiefe1, tiefe2: currency;
    profildickeProzent: currency;
    effektiveFluegeltiefe: currency;
  begin

    if PflgFlKnicke.Count > 0 then begin
      iKnick:= 0;
      found:= false;
      abstand1:= 0;
      totalAbstand:= 0;

      repeat

        if _abstand <= totalAbstand + PflgFlKnicke.Items[ iKnick ].Abstand then begin
          found:= true;
          if iKnick < 1 then begin
            // Erstes Trapez: Wurzel -> Knick 1
            abstand1:= 0;
            abstand2:= PflgFlKnicke.Items[ iKnick ].Abstand;
            profildicke1:= ProfildickeWurzel;
            profildicke2:= PflgFlKnicke.Items[ iKnick ].ProfilDicke;
            tiefe1:= Wurzeltiefe;
            tiefe2:= PflgFlKnicke.Items[ iKnick ].Fluegeltiefe;
          end else begin
            // Zwischentrapeze: Kick n-1 -> Knick n
            abstand2:= abstand1 + PflgFlKnicke.Items[ iKnick ].Abstand;
            profildicke1:= PflgFlKnicke.Items[ iKnick-1 ].ProfilDicke;
            profildicke2:= PflgFlKnicke.Items[ iKnick ].ProfilDicke;
            tiefe1:= PflgFlKnicke.Items[ iKnick-1 ].Fluegeltiefe;
            tiefe2:= PflgFlKnicke.Items[ iKnick ].Fluegeltiefe;
          end;
        end else begin

          abstand1:= abstand1 + PflgFlKnicke.Items[ iKnick ].Abstand;
          totalAbstand:= abstand1;
          inc( iKnick );

        end;

      until found or (iKnick >= PflgFlKnicke.Count);

      // Wurde kein passender Knick gefunden, gehen wir davon aus, dass der
      // _abstand grösser ist als der letzte Knick und rechnen mit den
      // Randbogenmasen.
      if not found then begin
        if totalAbstand > Spannweite / 2 then begin
          abstand1:= Spannweite / 2;
          abstand2:= Spannweite / 2;
          profildicke1:= ProfildickeRandbogen;
          profildicke2:= ProfildickeRandbogen;
          tiefe1:= TiefeRandbogen;
          tiefe2:= TiefeRandbogen;
        end else begin
          // Letzes Trapez: Knick max -> Randbogen
          abstand2:= (Spannweite / 2);
          profildicke1:= PflgFlKnicke.Items[ PflgFlKnicke.Count-1 ].ProfilDicke;
          profildicke2:= ProfildickeRandbogen;
          tiefe1:= PflgFlKnicke.Items[ PflgFlKnicke.Count-1 ].Fluegeltiefe;
          tiefe2:= TiefeRandbogen
        end;
     end;

    end else begin
      abstand1:= 0;
      abstand2:= Spannweite / 2;
      profildicke1:= ProfildickeWurzel;
      profildicke2:= ProfildickeRandbogen;
      tiefe1:= Wurzeltiefe;
      tiefe2:= TiefeRandbogen;
    end;

    { Holmbreite }
    breiteDelta:= breite1 - breite2;
    if breiteDelta = 0 then begin
      _holmbreite:= breite1;
    end else begin
      deltaAbstand:= _abstand - totalAbstand;
      _holmbreite:= HolmbreiteWurzel - ((HolmbreiteWurzel-HolmbreiteRandbogen) / (Spannweite/2) * (_abstand) );
    end;

    { Profildicke }
    dickeDelta:= profildicke1 - profildicke2;
    if dickeDelta = 0 then begin
      profildickeProzent:= profildicke1;
    end else begin
      profildickeProzent:= profildicke1 - ((dickeDelta) / (abstand2 - abstand1) * (_abstand - abstand1) );
    end;

    { Profildicke % umrechnen in effektive Profildicke (mm) }
    if tiefe1 - tiefe2 = 0 then begin
      { Rechteckiges Trapez }
      _profildicke:= tiefe1 * profildickeProzent / 100;
    end else begin
      { Trapez }
      effektiveFluegeltiefe:= tiefe1 - ((tiefe1 - tiefe2) / (abstand2 - abstand1) * (_abstand - abstand1));
      _profildicke:= effektiveFluegeltiefe * profildickeProzent / 100;
    end;

  end {GetHolmbreiteAt};

begin {Holmberechnung}

  SigmaZul:= AHolmart.SigmaZul;
  TauZul:= AHolmart.TauZul;
  TauKern:= AHolmart.TauKern;

  FAuftrieb:= 0.6 * ACa * AMaxV * AMaxV * (F / 100);
  FMaxBiegemoment:= Auftrieb / 2 * Spannweite / 4;  // GEPRÜFT

  { Für die Berechnung der örtlichen Beanspruchung, z.B. an einer beliebigen
    Stelle der Tragfläche, ist ausgehend von diesem bisher berechnetem Mb(max)
    das Mb an jeder Stelle der Tragfläche folgendermaßen zu berechnen:

    Mb(x) = q x X**2 / 2

    mit dem maximalen Biegemoment (Mb(max)) erhält man durch Umstellen der
    Gleichung die örtliche Beanspruchung. }

  FOertlicheBeanspruchung:= MaxBiegemoment * 2 / (Spannweite / 2) / (Spannweite / 2); // GEPRÜFT
  FQuerkraftbeanspruchungHolm:= FOertlicheBeanspruchung * (Spannweite / 2); // GEPRÜFT

  { Holmliste berechnen }
  Holme.Clear;
  anzahlHolmpunkte:= trunc((Spannweite / 2) / 100) + 1;
  for iHolm:= 0 to anzahlHolmpunkte do begin
    holm:= Holme.Add;
    holm.Abstand:= iHolm * 100;
    GetInterpolierteDatenAt( holm.Abstand, holmbreite, profildicke );
    holm.Holmbreite:= holmbreite; // GEPRÜFT
    holm.Biegemoment:= FOertlicheBeanspruchung * ((Spannweite / 2) - holm.Abstand) *((Spannweite / 2) - holm.Abstand) / 2; // GEPRÜFT
    if holm.Biegemoment < 0 then holm.Biegemoment:= 0;
    if (iHolm > 0) and (THolmItem(Holme[iHolm-1]).Biegemoment < holm.Biegemoment) then begin
       holm.Biegemoment:= THolmItem(Holme[iHolm-1]).Biegemoment;
    end;
    holm.Querkraft:=  FOertlicheBeanspruchung * ((Spannweite / 2) - holm.Abstand); // GEPRÜFT
    if holm.Querkraft < 0 then holm.Querkraft:= 0;
    holm.Profilhoehe:= profildicke; // GEPRÜFT
    holm.ProfilhoeheReduziert:= holm.Profilhoehe - 1.6; // GEPRÜFT
    holm.Widerstandsmoment:= holm.Biegemoment / SigmaZul; // GEPRÜFT
    holm.Querschnittsflaeche:= holm.Querkraft / TauZul; // GEPRÜFT

    { BEGIN DEBUG CODE }
    tmp1:= holm.Holmbreite * holm.ProfilhoeheReduziert * holm.ProfilhoeheReduziert * holm.ProfilhoeheReduziert;
    tmp2:= 6 * holm.ProfilhoeheReduziert * holm.Widerstandsmoment;
    tmp3:= (tmp1-tmp2) / holm.Holmbreite;
    p:= 1 / 3;
    if tmp3 <= 0 then begin
      raise EVariantenError.Create(dmMain.Translator.GetLit('CalcErrorNotPossible'));
    end;
    { END DEBUG CODE }

    holm.Steghoehe:= Power(tmp3, p);
    holm.Holmgurthoehe:= (holm.ProfilhoeheReduziert - holm.Steghoehe) / 2;
    holm.AnzahlRovings:= round(holm.Holmgurthoehe * holm.Holmbreite / 1.4);
    holm.DickeStegwand:= holm.Querschnittsflaeche / (2 * holm.Steghoehe);
    if (AHolmart.BerechnungsMethode = 2)
      and (holm.DickeStegwand < 0.8) then
    begin
      holm.DickeStegwand:= 0.8;
    end;
    holm.Schubkraftbeanspruchung:= TauKern * holm.Holmbreite * holm.Steghoehe;

    { Berechne zusätzliche Werte für die Streckung }
    if AArtDerSteckung <> adsNone then begin
      if AArtDerSteckung = adsRechteckigerQueryschnitt then begin

        { --- Mit rechteckigem Querschnitt --- }
        try
          holm.CFK_Mindeststabbreite:= (holm.Biegemoment * 6) / (800 * (holm.Steghoehe - 3) * (holm.Steghoehe - 3));
        except
          holm.CFK_Mindeststabbreite:= 0;
        end;
        holm.CFK_MaximaleStabbreite:= holm.Holmbreite - 3;
        holm.CFK_Stabhoehe:= holm.Steghoehe - 3;
        { GFK }
        try
          holm.GFK_Mindeststabbreite:= (holm.Biegemoment * 6) / (750 * (holm.Steghoehe - 3) * (holm.Steghoehe - 3));
        except
          holm.GFK_Mindeststabbreite:= 0;
        end;
        holm.GFK_MaximaleStabbreite:= holm.Holmbreite - 3;
        holm.GFK_Stabhoehe:= holm.Steghoehe - 3;
        { Stahl }
        try
          holm.Stahl_Mindeststabbreite:= (holm.Biegemoment * 6) / (1200 * (holm.Steghoehe - 3) * (holm.Steghoehe - 3));
        except
          holm.Stahl_Mindeststabbreite:= 0;
        end;
        holm.Stahl_MaximaleStabbreite:= holm.Holmbreite - 3;
        holm.Stahl_Stabhoehe:= holm.Steghoehe - 3;

      end else begin

        { --- Mit rundem Querschnitt --- }
        holm.CFK_Mindeststabbreite:= Power( ((holm.Biegemoment / (800 * 0.1))), (1/3) );
        holm.CFK_MaximaleStabbreite:= holm.Holmbreite - 3;
        holm.GFK_Mindeststabbreite:= Power( ((holm.Biegemoment / (750 * 0.1))), (1/3) );
        holm.GFK_MaximaleStabbreite:= holm.Holmbreite - 3;
        holm.Stahl_Mindeststabbreite:= Power( ((holm.Biegemoment / (1200 * 0.1))), (1/3) );
        holm.Stahl_MaximaleStabbreite:= holm.Holmbreite - 3;

      end;
    end;

  end;

end {Holmberechnung};

{ TModellVarianten }

function TModellVarianten.AddVariante(
  AVarianteName: string): TModellVariante;
begin
  if assigned(VarianteByName[AVarianteName]) then begin
    raise EVariantenError.CreateFmt(dmMain.Translator.GetLit('ValidationVersionAlreadyExists'),
                                    [AVarianteName]);
  end else begin
    result := TModellVariante.Create(FModell);
    result.VariantenName := AVarianteName;
    inherited Add(result);
    frmMain.AddVariante(result);
  end;
end;

procedure TModellVarianten.CalcLeistungsdaten;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do    // Iterate
  begin
    Items[i].AuslegungBerechnen;
    Items[i].CalcLeistungsdaten;
  end;    // for
end;

function TModellVarianten.CheckNewName(AName: string): boolean;
begin
  result := false;

  if AName = '' then
    raise EVariantenError.Create(
      dmMain.Translator.GetLit('ValidationVersionNameMustNotBeEmpy'))
  else
  if assigned(VarianteByName[AName]) then
    EVariantenError.CreateFmt(
      dmMain.Translator.GetLit('ValidationModelAlreadyContainsThatVersion'),
      [AName])
  else
    result := true;
end;

constructor TModellVarianten.Create(AModell: TObject);
begin
  FModell := AModell;
end;

function TModellVarianten.DeleteVariante(
  AVariante: TModellVariante): boolean;
var
  bSwitchCurVar : boolean;
begin
  bSwitchCurVar := false;
  if AVariante = TModell(FModell).Variante then
    bSwitchCurVar := true;

  frmMain.cmbVariante.ItemsEx.Delete(frmMain.cmbVariante.Items.IndexOfObject(AVariante));
  Delete(IndexOf(AVariante));

  if bSwitchCurVar then
    TModell(FModell).Variante := Items[0];
  result := true;
end;

function TModellVarianten.Get(Index: Integer): TModellVariante;
begin
  result := inherited Get(Index);
end;

function TModellVarianten.GetVarianteByName(
  AName: string): TModellVariante;
var
  i : integer;
begin
  result := nil;
  if Count > 0 then
    for i := 0 to pred(Count) do
      if Items[i].VariantenName = AName then begin
        result := Items[i];
        break;
      end;
end;

function TModellVarianten.Load(ANode: IXMLNode): boolean;
var
  i : integer;
begin
  Clear;
  frmMain.cmbVariante.Clear;
  if ANode.HasChildNodes then
    for i := 0 to pred(ANode.ChildNodes.Count) do
      AddVariante(ANode.ChildNodes[i].Attributes['name']).Load(ANode.ChildNodes[i]);
  result := true;
end;

procedure TModellVarianten.Put(Index: Integer; Item: TModellVariante);
begin
  inherited Put(Index, Item);
end;

function TModellVarianten.Save(ANode: IXMLNode): boolean;
var
  i : integer;
begin
  if Count > 0 then
    for i := 0 to pred(Count) do
      Items[i].Save(ANode);
  result := true;
end;

{ TLeistungsdaten }

function TLeistungsdaten.Get(Index: Integer): TLeistungsItem;
begin
  result := inherited Get(Index);
end;

function TLeistungsdaten.GetDforCA(ACA: currency): currency;
var
  i: integer;
begin
  result:= 0;
  for i:= 0 to pred( Count ) do begin
    if Items[i].Ca = ACA then begin
      result:= Items[i].D;
      break;
    end;
  end;
end;

function TLeistungsdaten.GetSPforCA(ACA: currency): currency;
var
  i: integer;
begin
  result:= 0;
  for i:= 0 to pred( Count ) do begin
    if Items[i].Ca = ACA then begin
      result:= Items[i].SP;
      break;
    end;
  end;
end;

function TLeistungsdaten.GetEWDforCA(ACA: currency): currency;
var
  i: integer;
begin
  result:= 0;
  for i:= 0 to pred( Count ) do begin
    if Items[i].Ca = ACA then begin
      result:= Items[i].EWD;
      break;
    end;
  end;
end;

procedure TLeistungsdaten.Put(Index: Integer; Item: TLeistungsItem);
begin
  inherited Put(Index, Item);
end;

{ TLeistungsItem }

constructor TLeistungsItem.Create;
begin
  Fcwges := 0;
  FVs := 0;
  Fca := 0;
  Fcwp := 0;
  FEWD := 0;
  FV_kmh := 0;
  FE := 0;
  Fcwi := 0;
  FV_ms := 0;
  Fcw := 0;
  FRei := 0;
  FRea := 0;
  FD := 0;
  FRem := 0;
end;

{ TPfeileungsItems }

function TPfeilungsItems.Get(Index: Integer): TPfeilungsItem;
begin
  result := inherited Get(Index);
end;

procedure TPfeilungsItems.Put(Index: Integer; Item: TPfeilungsItem);
begin
  inherited Put(Index, Item);
end;

{ TDruckpunktItems }

function TDruckpunktItems.Get(Index: Integer): TSchwerpunkt;
begin
  result:= inherited Get(Index);
end;

procedure TDruckpunktItems.Put(Index: Integer; Item: TSchwerpunkt);
begin
  inherited Put(Index, Item);
end;

function TDruckpunktItems.Add(ACa, ADp: currency; AVariante: TModellVariante): TSchwerpunkt;
var
  dp : TSchwerpunkt;
begin
  dp:= TSchwerpunkt.Create;
  with dp do begin
    ca := ACa;
    DP := ADp;
    Variante := AVariante;
  end;
  inherited Add(dp);
  result := dp;
end;
function TDruckpunktItems.ItemByCa(ACA: currency): TSchwerpunkt;
var
  i: integer;
begin
  result:= nil;
  for i:= 0 to pred( Count ) do begin
    if Items[i].CA = ACA then begin
      result:= Items[i];
      break;
    end;
  end;
end;

{ TDruckpunkt }

constructor TDruckpunkt.Create;
begin
  assert( self = nil );
  ca := 0;
  Druckpunkt := 0;
end;


{ TSchwerpunkt }

function TSchwerpunkt.GetStab1: currency;
var
  spvorlageProzent: currency;
begin
  spvorlageProzent:= Variante.NPNeu - ((ca - 0.4) * 10) * 2.0;
  result:= dp / 100 * (100 - spvorlageProzent) * 0.977;
end;

function TSchwerpunkt.GetStab2: currency;
var
  spvorlageProzent: currency;
begin
  result := GetStab1 * 1.05;
end;

function TSchwerpunkt.GetStab3: currency;
var
  spvorlageProzent: currency;
begin
  result := GetStab1 * 1.1;
end;

{ THolmList }

function THolmList.Add: THolmItem;
begin
  result:= THolmItem.Create;
  inherited Add( result );
end;

function THolmList.Get(Index: Integer): THolmItem;
begin
  result:= inherited Get( Index );
end;

procedure THolmList.Put(Index: Integer; Item: THolmItem);
begin
  inherited Put( Index, Item );
end;

end.
