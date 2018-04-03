unit WingDesignerInterface;

interface

uses
  SysUtils, Classes, Dialogs, varianten;

type

  TWingDesignerElement = (wdeDeck, wdeElevator);
  TWingDesignerUnit = (wduMM, wduPercent, wduDegre);

  TdmWingDesignerMeasurement = class
  private
    FValueUnit: TWingDesignerUnit;
    FValue: currency;
  public
    property ValueUnit: TWingDesignerUnit read FValueUnit write FValueUnit;
    property Value: currency read FValue write FValue;

    function TryParseString(textValue: string): boolean;
  end;

  TdmWingDesigner = class(TDataModule)
    dlgImport: TOpenDialog;
    dlgExport: TSaveDialog;
  private
    { Private declarations }
    function ConvertFirstStringPartIntoCurrency(stringpart: string): currency;
    procedure RaiseInvalidMeasurment(valueName: string);
  public
    { Public declarations }
    function ImportFromWingDesigner(variante: TModellVariante;
      whatToImport: TWingDesignerElement) : boolean; overload;
    function ImportFromWingDesigner(variante: TModellVariante;
      whatToImport: TWingDesignerElement; s4wFilename: string) : boolean; overload;

    function ExportToWingDesigner(variante: TModellVariante;
      whatToExport: TWingDesignerElement) : boolean; overload;
    function ExportToWingDesigner(variante: TModellVariante;
      whatToExport: TWingDesignerElement; s4wFilename: string) : boolean; overload;
  end;

var
  dmWingDesigner: TdmWingDesigner;

implementation

{$R *.dfm}

uses
  Forms, Controls, Windows, IniFiles, profile, ad_consts, StrUtils, Math,
  maindata, idTranslator;

function GetStandardizedFormattingSettings() : TFormatSettings;
begin
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, result);
  with result do begin
    TimeAMString := '';
    TimePMString := '';
    ThousandSeparator := ',';
    DecimalSeparator := '.';
  end;
end;

{ TdmWingDesignerMeasurement }

function TdmWingDesignerMeasurement.TryParseString(textValue: string): boolean;
var
  part: string;
  val: currency;
  p: integer;
  floatFormatSettings: TFormatSettings;
begin
  result := true;

  if textValue = '' then begin
    ValueUnit := wduMM;
    Value := 0;
  end else begin
    floatFormatSettings := GetStandardizedFormattingSettings();

    // Extract value
    p := Pos(' ', textValue);
    part := Copy(textValue, 1, p);
    val := StrToCurrDef(part, 0, floatFormatSettings);

    // Extract unit
    part := Trim(RightStr(textValue, Length(textValue) - p + 1));
    p := Pos(' ', part);
    if p > 0 then part := Trim(LeftStr(part, p)); // Cut 3. part from value string

    if SameText(part, 'inch') then begin
      // Inches automatically get converted into MM
      ValueUnit := wduMM;
      val := val * 6.452;
    end
    else if SameText(part, 'mm') then ValueUnit := wduMM
    else if SameText(part, '%') then ValueUnit := wduPercent
    else if SameText(part, '°') then ValueUnit := wduDegre
    else
      // Unknown unit
      result := false;

    // If unit successfully parsed store value in props
    if result then begin
      Value := val;
    end;

  end;

end;

{ TdmWingDesigner }

function TdmWingDesigner.ImportFromWingDesigner(
  variante: TModellVariante; whatToImport: TWingDesignerElement) : boolean;
begin
  result := false;

  case whatToImport of
    wdeDeck:     dlgImport.Title := dmMain.Translator.GetLit('WDImportWingTitle');
    wdeElevator: dlgImport.Title := dmMain.Translator.GetLit('WDImportElevatorTitle');
  end;

  if dlgImport.Execute then begin
    result := ImportFromWingDesigner(variante, whatToImport, dlgImport.Filename);
  end;

end;

function TdmWingDesigner.ImportFromWingDesigner(variante: TModellVariante;
  whatToImport: TWingDesignerElement; s4wFilename: string) : boolean;
var
  s4wFile: TIniFile;
  wurzelProfilFilename: string;
  wurzelProfil: TProfil;
  wurzeltiefe: currency;
  wurzeldicke: currency;
  randbogenProfilFilename: string;
  randbogenProfil: TProfil;
  iSegment: integer;
  segmentSectionName: string;
  sectionExists: boolean;
  segmentlaenge: currency;
  segmenttiefe: currency;
  segmentdicke: currency;
  segmentpfeilung: currency;
  isLastSegment: boolean;
  newPfeilungsItem: TPfeilungsItem;
  bisherigePfeilung: currency;
  bisherigerAbstand: integer;
  vorherigeTiefe: currency;
  wdValue: TdmWingDesignerMeasurement;
begin
  result := false;

  if not FileExists(s4wFilename) then begin
    Application.MessageBox(
      PAnsiChar(Format(dmMain.Translator.GetLit('WDImportErrorFileNotFound'), [s4wFilename])),
      PChar(dmMain.Translator.GetLit('WDFileNotFound')),
      MB_OK + MB_ICONSTOP);

    exit;
  end;

  Screen.Cursor := crHourGlass;
  try

    s4wFile := TIniFile.Create(s4wFilename);
    try
      wdValue := TdmWingDesignerMeasurement.Create();

      case whatToImport of
        wdeDeck: begin
          // Lösche bestehende Knicke in der Fläche
          variante.PflgFlKnicke.Clear();
        end;

        wdeElevator: begin
          // Lösche bestehende Knicke im Höhenleitwerk
          variante.PflgHlwKnicke.Clear();
        end;
      end;

      // Wurzelprofil
      if (whatToImport = wdeDeck) then begin
        wurzelProfilFilename := s4wFile.ReadString('WURZELPROFIL', 'NA', '');
        if LowerCase(ExtractFileExt(wurzelProfilFilename)) = LowerCase(ProfilFileExt) then begin
          wurzelProfil := TProfil.Create();
          wurzelProfilFilename := ExtractFileName(wurzelProfilFilename);
          Delete(wurzelProfilFilename, LastDelimiter('.', wurzelProfilFilename), 9999);
          wurzelProfil.Dateiname := wurzelProfilFilename;
          if assigned(wurzelProfil) then begin
            variante.ProfilInnen := wurzelProfil;
          end;
        end;
      end;

      // Wurzelprofil: Tiefe
      if wdValue.TryParseString(s4wFile.ReadString('WURZELPROFIL', 'TI', '')) then begin
        if wdValue.ValueUnit <> wduMM then
          RaiseInvalidMeasurment(dmMain.Translator.GetLit('WDInvalidMeasurment1'));

        wurzeltiefe := wdValue.Value;
      end;

      if (whatToImport = wdeDeck) then begin
        // Wurzelprofil: Dicke
        if wdValue.TryParseString(s4wFile.ReadString('WURZELPROFIL', 'DI', '')) then begin
          if wdValue.ValueUnit <> wduPercent then
            RaiseInvalidMeasurment(dmMain.Translator.GetLit('WDInvalidMeasurment2'));

          wurzeldicke := wdValue.Value;
        end;
      end;

      // Segmente
      isLastSegment := false;
      bisherigePfeilung := 0;
      bisherigerAbstand := 0;
      vorherigeTiefe := wurzeltiefe;
      iSegment := 1;
      repeat
        segmentSectionName := Format('SEGMENT%d', [iSegment]);
        sectionExists := s4wFile.SectionExists(segmentSectionName);

        if (sectionExists) then
        begin
          if (not s4wFile.SectionExists(Format('SEGMENT%d', [iSegment+1]))) then
          begin
            isLastSegment := true;
          end;

          // Segmentlänge
          if wdValue.TryParseString(s4wFile.ReadString(segmentSectionName, 'SL', '')) then begin
            if wdValue.ValueUnit <> wduMM then
              RaiseInvalidMeasurment(Format(dmMain.Translator.GetLit('WDInvalidMeasurment3'), [segmentSectionName]));

              segmentlaenge := wdValue.Value;
          end;

          // Segmenttiefe
          if wdValue.TryParseString(s4wFile.ReadString(segmentSectionName, 'TI', '')) then begin
            if wdValue.ValueUnit <> wduMM then
              RaiseInvalidMeasurment(Format(dmMain.Translator.GetLit('WDInvalidMeasurment4'), [segmentSectionName]));

              segmenttiefe := wdValue.Value;
          end;

          if (whatToImport = wdeDeck) then begin
            // Segmentdicke
            if wdValue.TryParseString(s4wFile.ReadString(segmentSectionName, 'DI', '')) then begin
              if wdValue.ValueUnit <> wduPercent then
                RaiseInvalidMeasurment(Format(dmMain.Translator.GetLit('WDInvalidMeasurment5'), [segmentSectionName]));

                segmentdicke := wdValue.Value;
            end;
          end;

          // Pfeilung
          if s4wFile.ValueExists(segmentSectionName, 'PN') then begin
            // Pfeilung Nase
            if wdValue.TryParseString(s4wFile.ReadString(segmentSectionName, 'PN', '')) then begin
               case wdValue.ValueUnit of
                 wduMM:      segmentpfeilung := bisherigePfeilung + wdValue.Value;
                 wduDegre:   segmentpfeilung := bisherigePfeilung + (segmentlaenge * Tan(wdValue.Value*Pi/180));
                 else        RaiseInvalidMeasurment(Format(dmMain.Translator.GetLit('WDInvalidMeasurment6'), [segmentSectionName]));
               end;
            end;
          end else if s4wFile.ValueExists(segmentSectionName, 'PE') then begin
            // Pfeilung Endkante
            if wdValue.TryParseString(s4wFile.ReadString(segmentSectionName, 'PE', '')) then begin
               case wdValue.ValueUnit of
                 wduMM:      segmentpfeilung := bisherigePfeilung
                               + vorherigeTiefe
                               + segmentpfeilung
                               - segmenttiefe;
                 wduDegre:   segmentpfeilung := bisherigePfeilung
                               + vorherigeTiefe
                               + (segmentlaenge * Tan(wdValue.Value*Pi/180))
                               - segmenttiefe;
                 else        RaiseInvalidMeasurment(Format(dmMain.Translator.GetLit('WDInvalidMeasurment7'), [segmentSectionName]));
               end;
            end;
          end else begin
            // Keine Pfeilung (=gerade Pfeilung)
            segmentpfeilung := bisherigePfeilung + vorherigeTiefe - segmenttiefe;
          end;

          if not isLastSegment then begin
            newPfeilungsItem := TPfeilungsItem.Create();
            newPfeilungsItem.Abstand := Round(bisherigerAbstand + segmentlaenge);
            newPfeilungsItem.Fluegeltiefe := Round(segmenttiefe);
            newPfeilungsItem.Pfeilung := Round(segmentpfeilung);
            if (whatToImport = wdeDeck) then begin
               newPfeilungsItem.ProfilDicke := segmentdicke;
            end;
          end;

          case whatToImport of

            // Flächen Segmente
            wdeDeck: begin
              if (isLastSegment) then begin
                variante.TiefeRandbogen := Round(segmenttiefe);
                variante.ProfildickeRandbogen := Round(segmentdicke);
              end else begin
                 variante.PflgFlKnicke.Add(newPfeilungsItem);
              end;
            end; // wdeDeck

            // HLW Segmente
            wdeElevator: begin
              if (isLastSegment) then begin
                variante.PflgHlwAussentiefe := segmenttiefe;
              end else begin
                 variante.PflgHlwKnicke.Add(newPfeilungsItem);
              end;
            end; // wdeElevator

          end; // case

          bisherigePfeilung := segmentpfeilung;
          bisherigerAbstand := round(bisherigerAbstand + segmentlaenge);
          vorherigeTiefe := segmenttiefe;

        end; // if

        inc(iSegment);
      until (not sectionExists);

      case whatToImport of
        wdeDeck: begin
          variante.Spannweite := Round(bisherigerAbstand * 2);
          variante.Wurzeltiefe := Round(wurzeltiefe);
          variante.ProfildickeWurzel := Round(wurzeldicke);
          variante.PflgFlRandbogen := segmentpfeilung;

          // Dies muss evtl. das spezifische Randprofil werden.
          // Die Frage ist aber, welches als Randprofil gelten soll?
          // Einfach das letzte oder eine Annäherung? Beides ist nicht gut.
          if assigned(wurzelProfil) then begin
            variante.ProfilAussen := wurzelProfil;
          end;

          if (variante.PflgFlKnicke.Count > 0) then begin
            variante.LageTrapezstoss := variante.PflgFlKnicke.Items[0].Abstand;
            variante.TiefeTrapezstoss := variante.PflgFlKnicke.Items[0].Fluegeltiefe;
          end;

        end;

        wdeElevator: begin
          variante.PflgHlwSpannweite := Round(bisherigerAbstand * 2);
          variante.PflgHlwWurzeltiefe := Round(wurzeltiefe);
          variante.PflgHlwPfeilung := segmentpfeilung;
        end;
      end;

      result := true;
    finally
      FreeAndNil(s4wFile);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TdmWingDesigner.RaiseInvalidMeasurment(valueName: string);
var
  msg: string;
begin
  msg := Format(dmMain.Translator.GetLit('WDInvalidMeasurmentBase'), [valueName]);
  raise EInvalidArgument.Create(msg);
end;


function TdmWingDesigner.ConvertFirstStringPartIntoCurrency(stringpart: string): currency;
var
  firstPart: string;
begin
  if stringpart = '' then begin
    result := 0;
  end else begin
    firstPart := Copy(stringpart, 1, Pos(' ', stringPart));
    result := StrToCurrDef(firstPart, 0);
  end;
end;

function TdmWingDesigner.ExportToWingDesigner(variante: TModellVariante;
  whatToExport: TWingDesignerElement): boolean;
begin
  result := false;

  case whatToExport of
    wdeDeck:     dlgExport.Title := dmMain.Translator.GetLit('WDExportWingTitle');
    wdeElevator: dlgExport.Title := dmMain.Translator.GetLit('WDExportElevatorTitle');
  end;

  if dlgExport.Execute then begin
    result := ExportToWingDesigner(variante, whatToExport, dlgExport.Filename);
  end;
end;

function TdmWingDesigner.ExportToWingDesigner(variante: TModellVariante;
  whatToExport: TWingDesignerElement; s4wFilename: string): boolean;
var
  s4wFile: TIniFile;
  iKnick: integer;
  knicke: TPfeilungsItems;
  knick: TPfeilungsItem;
  segmentNr: integer;
  vorherigerAbstandRumpf: integer;
  bisherigePfeilung: integer;
  segmentname: string;
  formatSettings: TFormatSettings;
begin
  result := false;

  formatSettings := GetStandardizedFormattingSettings();

  Screen.Cursor := crHourGlass;
  try

    s4wFile := TIniFile.Create(s4wFilename);
    try

      case whatToExport of
        wdeDeck: begin
          // Verwende die Knicke der Tragfläche
          knicke := variante.PflgFlKnicke;
        end;

        wdeElevator: begin
          // Verwende die Knicke des HLW's
          knicke := variante.PflgHlwKnicke;
        end;
      end;

      // Section: GENERAL
      s4wFile.WriteString('GENERAL', 'FV', '1.3');
      s4wFile.WriteString('GENERAL', 'BZ', variante.VariantenName);

      // Section: WURZELPROFIL
      case whatToExport of
        wdeDeck: begin
          // Verwende Tragfläche
          s4wFile.WriteString('WURZELPROFIL', 'NA', variante.ProfilInnen.CalcProfilFileName());
          s4wFile.WriteString('WURZELPROFIL', 'TI', FloatToStr(variante.Wurzeltiefe, formatSettings) + ' mm');
          s4wFile.WriteString('WURZELPROFIL', 'DI', FloatToStr(variante.ProfildickeWurzel, formatSettings) + ' %');
        end;

        wdeElevator: begin
          // Verwende HLW
          s4wFile.WriteString('WURZELPROFIL', 'TI', FloatToStr(variante.PflgHlwWurzeltiefe, formatSettings) + ' mm');
        end;
      end;

      // Section: SEGMENTx
      vorherigerAbstandRumpf := 0;
      bisherigePfeilung := 0;
      segmentNr := 1;

      if knicke.Count > 0 then begin
        for iKnick := 0 to knicke.Count - 1 do begin
          knick := knicke.Items[iKnick];
          segmentname := Format('SEGMENT%d', [segmentNr]);

          s4wFile.WriteString(segmentname, 'SL', IntToStr(knick.Abstand - vorherigerAbstandRumpf) + ' mm');
          s4wFile.WriteString(segmentname, 'TI', IntToStr(knick.Fluegeltiefe) + ' mm');
          s4wFile.WriteString(segmentname, 'DI', FloatToStr(knick.ProfilDicke, formatSettings) + ' %');
          s4wFile.WriteString(segmentname, 'PN', IntToStr(knick.Pfeilung - bisherigePfeilung) + ' mm');

          vorherigerAbstandRumpf := knick.Abstand;
          bisherigePfeilung := knick.Pfeilung;
          inc(segmentNr);
        end;
      end;

      // Section SEGMENTn  (letztes Segment)
      segmentname := Format('SEGMENT%d', [segmentNr]);
      case whatToExport of
        wdeDeck: begin
          // Verwende Tragfläche
          s4wFile.WriteString(segmentname, 'NA', variante.ProfilAussen.CalcProfilFileName());
          s4wFile.WriteString(segmentname, 'SL', IntToStr(Round(variante.Spannweite / 2) - vorherigerAbstandRumpf) + ' mm');
          s4wFile.WriteString(segmentname, 'DI', FloatToStr(variante.ProfildickeRandbogen, formatSettings) + ' %');
          s4wFile.WriteString(segmentname, 'TI', FloatToStr(variante.TiefeRandbogen, formatSettings) + ' mm');
          s4wFile.WriteString(segmentname, 'PN', CurrToStr(variante.PflgFlRandbogen - bisherigePfeilung, formatSettings) + ' mm');
        end;

        wdeElevator: begin
          // Verwende HLW
          //s4wFile.WriteString(segmentname, 'NA', variante.ProfilAussen.CalcProfilFileName());
          s4wFile.WriteString(segmentname, 'SL', IntToStr(Round(variante.PflgHlwSpannweite / 2) - vorherigerAbstandRumpf) + ' mm');
          //s4wFile.WriteString(segmentname, 'DI', FloatToStr(variante.ProfildickeRandbogen) + ' %');
          s4wFile.WriteString(segmentname, 'TI', FloatToStr(variante.PflgHlwAussentiefe, formatSettings) + ' mm');
          s4wFile.WriteString(segmentname, 'PN', CurrToStr(variante.PflgHlwPfeilung - bisherigePfeilung, formatSettings) + ' mm');
        end;
      end;

      result := true;
    finally
      FreeAndNil(s4wFile);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.

