{$A+,B-,D-,E-,F-,I+,L-,N-,O-,R-,S+,V+}
unit id_string;

interface

uses
  classes;


const
  TAB = #9;    // Tabulator
  LF  = #10;   // LineFeet
  CR  = #13;   // Enter/Return
  ESC = #27;   // Escape
  SPC = #32;   // Leerzeichen


type
  CharSet = set of CHAR; // Charset-Typendef.

function  HexB(b:BYTE): string;    // Byte in einen HEX-string konvertieren
function  HexW(w:WORD): string;    // Word in einen HEX-string konvertieren
function  HexL(l:LONGINT): string; // Longint in einen HEX-string konvertieren
function  HexP(p:POINTER): string; // Pointer in einen HEX-string konvertieren
function  BinB(b:BYTE): string;    // Byte in einen Binär-string konvertieren
function  BinW(w:WORD): string;    // Word in einen Binär-string konvertieren
function  BinL(l:LONGINT): string; // Longint in einen Binär-string konvertieren
function  IntToStrEx(l:LONGINT;len:integer): string; // Integer in einen string konvertieren
function  StrToIntEx(St: string):LONGINT; // string in einen Integer konvertieren
function  RealToStr(r:REAL; Len,Dez:integer): string; // Real-Zahl in string konvertieren
function  StrToReal(St: string):REAL; // string in Real-Zahl konvertieren
function  TrimLeft(St: string): string; // Führende Leerzeichen entfernen
function  TrimRight(St: string): string; // Abschliessende Leerzeichen entfernen
function  Trim(St: string): string; // TrimLeft+TrimRight
function   Right( const s: string; len: integer ): string; // Right LEN chats from string S
function  CopyEnd(s: string; StartPos: integer): string; // von StartPos bis zum Ende alles kopieren
function  TimeToStr(hour,min,sec : WORD): string; // Konvertierung
function  DateToStr(day,month,year:WORD): string; // Konvertierung
function  UpCase(Ch:CHAR):CHAR; // UpCase mit Umlauten
function  LoCase(Ch:CHAR):CHAR; // LoCase mit Umlauten
function  FirstUpperCase(s: string): string; // Ersten Buchstaben gross schreiben
function  StUpCase(St: string): string; // string in Grossbuchstaben
function  StLoCase(St: string): string; // string in Kleinbuchstaben
function  CharStr(Ch:CHAR; Len:integer): string; // string der Länge LEN mit Zeichen CH
function  FillStr(St: string; Ch:CHAR; Len:integer; FillLeft: boolean = false): string; // string auffüllen
function  Center(St: string; Len:integer): string; // Variable ST auf LEN-Zeichen zentrieren
function  LastPos(SubStr,St: string):integer; // Letzte Position von SUBSTR in ST
function  DefaultExtension(fn,ext: string): string; // Vorgabeerweiterung EXT
function  ForceExtension(fn,ext: string): string; // Erweiterung EXT erzwingen
function  ItemCount(St: string;Sep:CharSet):integer; // Anzahl Wörter in ST
function  ExtractItem(Num:integer;St: string;Sep:CharSet): string; // Wort NUM aus ST
function  LargeInt(zahl : longint; len : integer) : string; // Tausender-Trennzeichen
function  AddBackslash(s : string) : string;  // evtl. Backslash am Ende anhängen
function  CleanBackslash(s : string) : string; // evtl.Backslash am Ende entfernen
function  Codestring(password : string) : string; // Ver-/Entschlüsseln eines strings
function  GetIOMessage(no : integer) : string; // IO-Message ermitteln
function  CalcStrChecksum(s : string; zerobased : boolean) : longint; // Quersumme berechnen
function  ReplaceChars(s: string; OldChars: CharSet; NewChar: char) : string;
function  GetShortDayStr(DayOfWeek: integer) : string; // "Sun", "Mon", ... (all in english)
function  GetShortMonthStr(ADate: TDateTime) : string; // "Jan", "Feb", ... (all in english)
function  ReplaceStr(s, OldSubStr, NewSubStr: string; IgnoreCase: boolean = false) : string; // In S alle OldSubStr mit NewSubStr ersetzen
function  BuildADOConnectionStr(AConnectionstring, ADataSourcePath: string) : string; // Liefert einen Connection-string mit dem eingesetzten Pfad zurück
function  RemoveBorders(s: string; BorderChar: char) : string; // Wenn als erstes oder letztes Zeichen das BORDERCHAR vorhanden ist, dieses entfernen
function  StrContainChars(s: string; Chars: charset): boolean; // Kommt eines der Zeichen CHARS im string S vor ?
function  FindTextStr(Astring, ASubstring: string; AStartPos: integer = 0; ACaseSesitive: boolean = false; AUpwards: boolean = false) : integer; // Sucht in Astring nach ASubstring und gibt die Fundposition zurück
function  DateTimeToStr14(ADateTime: TDateTime) : string; // Zeit/Datum in string YYYYMMDDHHMMSS konvertieren
function  Str14ToDateTime(Astring: string) : TDateTime; // string YYYYMMDDHHMMSS in Zeit/Datum konvertieren
procedure ParseCommandLine(var CommandLineParms: TStringList); // Liefert die aktuellen Kommandozeilenparamter in einer stringlist (berücksichtigt Quotes eg. -FILE"die ist ein test"
function  IsVersionNewer(OldVersion, NewVersion: string) : boolean; // Ist NewVersion grösser als OldVersion? Formatbsp. "1.0.12.2912"
function  SplittString( _s: string; _sepChar: char = #32; _quoteChar: char = '"' ): TStringList;
function  IsTextContainedInStr( AText, AString: string ) : boolean; // Liefert TRUE wenn AText in AString vorkommt (caseinsensitive)
function  PadIpZero(s: String): String; // Führende Nullen in IP-Adresse-Bereich 00n.0xx. ....
function  FirstPos( substr, inString: string; offset: integer; caseSesitive: boolean = false ): integer;
function  MakeValidFileName( AFileName: string ): string; // Entfernt / Ersetzt ungültige Zeichen innerhalb eines Dateinames

{ Standard Conversions }
function  AnsiToOEM(s : string) : string;
function  OemToAnsi(s : string) : string;

implementation

uses windows, sysutils, StrUtils;

TYPE
  HiLo = RECORD
    LoWord : WORD;
    HiWord : WORD;
  end;

function  IsTextContainedInStr( AText, AString: string ) : boolean;
begin
  AText:= UpperCase( AText );
  AString:= UpperCase( AString );
  result:= Pos( AText, AString ) > 0;
end;

function IsVersionNewer(OldVersion, NewVersion: string) : boolean;
const
    Sep: Charset = ['.',','];
var i : integer;
    OldNo,
    NewNo : integer;
begin
  result := false;
  if NewVersion = '' then exit;
  if OldVersion = '' then begin
    result := true;
    exit;
  end;

  for i := 1 to ItemCount(OldVersion, Sep) do begin
    OldNo := StrToInt(ExtractItem(i, OldVersion, Sep));
    if ItemCount(NewVersion, Sep) >= i then begin
      NewNo := StrToInt(ExtractItem(i, NewVersion, Sep));
      if NewNo > OldNo then begin
        result := true;
        Break;
      end else
      if NewNo < OldNo then begin
        result := false;
        Break;
      end;
    end else begin
      Break;
    end;
  end;
end;

function SplittString( _s: string; _sepChar: char = #32; _quoteChar: char = '"' ): TStringList;
var i: integer;
    s: string;
    InQuotes: boolean;
begin
  result := TstringList.Create;
  if Length(_s) > 0 then begin
    { string nun parsen, da evtl. lange Filenamen mit Hochkomma's kommen können }
    _s := Trim(_s);
    InQuotes := false;
    s := '';

    for i := 1 to Length(_s) do begin
      if (Copy(_s,i,1) = _sepChar) and (not InQuotes) then begin
        result.Add(s);
        s := '';
      end else begin
        if Copy(_s,i,1) = _quoteChar then InQuotes := not InQuotes;
        s := s + Copy(_s,i,1);
      end;
    end;
    if InQuotes then s := s + _quoteChar;
    if Trim(s) <> '' then result.Add(s);
  end;
end;

procedure ParseCommandLine(var CommandLineParms: TstringList);
var
  CommandLine : string;
begin
  CommandLine := '';
  CommandLine := GetCommandLine;
  CommandLineParms:= SplittString( CommandLine );
end;

function RemoveBorders(s: string; BorderChar: char) : string;
begin
  result := s;
  if (length(result) > 0) and (Copy(result,1,1) = BorderChar) then
    Delete(result,1,1);
  if (Length(result) > 0) and (Copy(result, Length(result), 1) = BorderChar) then
    Delete(result,Length(result),1);
end;

function StrContainChars(s: string; Chars: charset): boolean;
var i : integer;
begin
  result := false;
  if Length(s) > 0 then
    for i := 1 to length(s) do
      if s[i] in Chars then begin
        result := true;
        Break;
      end;
end;

function FindTextStr(Astring, ASubstring: string; AStartPos: integer = 0;
  ACaseSesitive: boolean = false; AUpwards: boolean = false) : integer;
var
  CurPos : integer;
  quit : boolean;

  function CompareCurStr: boolean;
  begin
    result := false;

    if ACaseSesitive then begin
      if  (Length(Astring) >= CurPos + Length(ASubstring))
      and (Copy(Astring, CurPos, Length(ASubstring)) = ASubstring) then
        result := true
    end else begin
      if  (Length(Astring) >= CurPos + Length(ASubstring))
      and (UpperCase(Copy(Astring, CurPos, Length(ASubstring))) = UpperCase(ASubstring)) then
        result := true;
    end;
  end;

begin
  result := -1;

  { erst die fälle rausfiltern, in welchen sicher keine suche gestartet werden muss }
  if (Astring = '')
  or (ASubstring = '')
  or (Length(Astring) < Length(ASubstring))
  then
    exit;

  { startposition setzen }
  CurPos := AStartPos;
  if CurPos > Length(Astring) then CurPos := Length(Astring);
  if CurPos < 1 then
    if AUpwards then
      CurPos := Length(Astring)
    else
      CurPos := 1;

  quit := false;
  repeat
    if CompareCurStr then begin
      Quit := true;
      Result := CurPos;
    end;

    { neue Position berechnen }
    if not quit then begin
      if AUpwards then Dec(CurPos)
      else Inc(CurPos);

      if (CurPos < 1) or (CurPos > Length(Astring)) then
        quit := true;
    end;
  until quit;
end;

// Zeit/Datum in string YYYYMMDDHHMMSS konvertieren
function DateTimeToStr14(ADateTime: TDateTime) : string;
var
  y, mo, d : word;
  h, m, s, ms : word;
begin
  result := '';
  DecodeDate(ADateTime, y, mo, d);
  DecodeTime(ADateTime, h, m, s, ms);
  result := IntToStrEx(y, 4) +
            IntToStrEx(mo, 2) +
            IntToStrEx(d, 2) +
            IntToStrEx(h, 2) +
            IntToStrEx(m, 2) +
            IntToStrEx(s, 2);
end;

// string YYYYMMDDHHMMSS in Zeit/Datum konvertieren
function Str14ToDateTime(Astring: string) : TDateTime;
begin
  result := 0;
  if Length(Astring) <> 14 then exit;

  result := EncodeDate(StrToInt(Copy(Astring, 1, 4)),
                       StrToInt(Copy(Astring, 5, 2)),
                       StrToInt(Copy(Astring, 7, 2)));
  result := result + EncodeTime(StrToInt(Copy(Astring, 9,2)),
                                StrToInt(Copy(Astring, 11, 2)),
                                StrToInt(Copy(Astring, 13, 2)),
                                0);

end;

function FirstUpperCase(s: string): string;
begin
  result := UpperCase(Copy(s, 1, 1)) + CopyEnd(s, 2)
end;

function AnsiToOEM(s : string) : string;
var buffer : array[0..2048] of char;
begin
  StrPCopy(buffer, s);
  CharToOEM(buffer, Buffer);
  result := buffer;
end;

function OemToAnsi(s : string) : string;
var buffer : array[0..2048] of char;
begin
  StrPCopy(buffer, s);
  OEMtoChar(buffer, Buffer);
  result := buffer;
end;

function  CalcStrChecksum(s : string; zerobased : boolean) : longint;
var i : integer;
    L : integer;
begin
  result := 0;
  l := Length(s);
  if l > 0 then
  begin
    for i := 1 to l do
      if zerobased then
        inc(result,Ord(s[i])-65)
      else
        inc(result,Ord(s[i]));
  end;
end;

function AddBackslash(s : string) : string;
begin
  if Copy(s,length(s),1) = '\' then result := s
  else result := s + '\';
end;

function CleanBackslash(s : string) : string;
begin
  if Copy(s,Length(s),1) = '\' then result := Copy(s,1,Length(s)-1)
  else result := s;
end;

function  HexB(b:BYTE): string;
CONST
  HexChar : ARRAY[0..15] of CHAR = '0123456789ABCDEF';
begin
  HexB:=HexChar[b SHR 4]+HexChar[b and $0F];
end;

function  HexW(w:WORD): string;
begin
  HexW:=HexB(Hi(w))+HexB(Lo(w));
end;

function  HexL(l:LONGINT): string;
var
  HL : HiLo ABSOLUTE l;
begin
  HexL:=HexW(HL.HiWord)+HexW(HL.LoWord);
end;

function  HexP(p:POINTER): string;
var
  HL : HiLo ABSOLUTE p;
begin
  HexP:=HexW(HL.HiWord)+':'+HexW(HL.LoWord);
end;

function  BinB(b:BYTE): string;
var
  s : string;
  i : WORD;
begin
  s:='';
  for i:=7 downto 0 do
    if (b and (1 SHL i))>0 then
      s:=s+'1'
    else
      s:=s+'0';
  BinB:=s;
end;

function  BinW(w:WORD): string;
var
  s : string;
  i : WORD;
begin
  s:='';
  for i:=15 downto 0 do
    if (w and (1 SHL i))>0 then
      s:=s+'1'
    else
      s:=s+'0';
  BinW:=s;
end;

function  BinL(l:LONGINT): string;
var
  HL : HiLo absolute l;
begin
  BinL:=BinW(HL.HiWord)+BinW(HL.LoWord);
end;

function  IntToStrEx(l:LONGINT;len:integer): string;
var s: string;
begin
  Str(l,s);
  while Length(s)<len do
    s:='0'+s;
  result := s;
end;

function  StrToIntEx(St: string):LONGINT;
var
  w  : LONGINT;
  Err: INTEGER;
begin
  Val(St,w,Err);
  result := w;
end;

function  RealToStr(r:REAL; Len,Dez:integer): string;
var St: string;
begin
  Str(r:len:dez,St);
  RealToStr:=St;
end;

function  StrToReal(St: string):REAL;
var
  r   : REAL;
  Err : INTEGER;
begin
  Val(St,r,Err);
  StrToReal:=r;
end;

function  TrimLeft(St: string): string;
begin
  while (Length(St)>0) and (St[1]=SPC) do
    Delete(St,1,1);
  TrimLeft:=St;
end;

function  TrimRight(St: string): string;
begin
  while (Length(St)>0) and (St[Length(St)]=SPC) do
    Delete(St,Length(St),1);
  TrimRight:=St;
end;

function  Trim(St: string): string;
begin
  Trim:=TrimLeft(TrimRight(St));
end;

function  TimeToStr(hour,min,sec : WORD): string;
begin
  TimeToStr:=IntToStrEx(hour,2)+':'+
             IntToStrEx(min,2)+':'+
             IntToStrEx(sec,2);
end;

function  DateToStr(day,month,year:WORD): string;
begin
  DateToStr:=IntToStrEx(day,2)+'.'+
             IntToStrEx(month,2)+'.'+
             IntToStrEx(year MOD 100,2);
end;

function  UpCase(Ch:CHAR):CHAR;
begin
  case Ch of
    'ä' : UpCase:='Ä';
    'ö' : UpCase:='Ö';
    'ü' : UpCase:='Ü';
    else  UpCase:=System.UpCase(Ch);
  end;
end;

function  LoCase(Ch:CHAR):CHAR;
begin
  case Ch of
    'Ä' : LoCase:='ä';
    'Ö' : LoCase:='ö';
    'Ü' : LoCase:='ü';
    else begin
      if (Ch>='A') and (Ch<='Z') then
        LoCase:=Chr(Ord(ch)+$20)
      else
        LoCase:=Ch;
    end;
  end;
end;

function  StUpCase(St: string): string;
var
  i : integer;
begin
  for i:=1 to Length(St) do
    St[i]:=UpCase(St[i]);
  StUpCase:=St;
end;

function  StLoCase(St: string): string;
var
  i : integer;
begin
  for i:=1 to Length(St) do
    St[i]:=LoCase(St[i]);
  StLoCase:=St;
end;

function  CharStr(Ch:CHAR; Len:integer): string;
var
  St : string;
begin
  St:='';
  while Length(St)<Len do
    St:=St+Ch;
  CharStr:=St;
end;

function  FillStr(St: string; Ch:CHAR; Len:integer; FillLeft: boolean = false): string;
begin
  while Length(St)<Len do begin
    if FillLeft then begin
      St:= Ch + St;
    end else begin
      St:= St + Ch;
    end;
  end;
  result:=Copy(St,1,Len);
end;

function  Center(St: string; Len:integer): string;
begin
  while Length(St)<Len do St:=' '+St+' ';
  Center:=Copy(St,1,Len);
end;

function  LastPos(SubStr,St: string): integer;
var
  Found,Len,Pos : integer;
begin
  Pos:=Length(St);
  Len:=Length(SubStr);
  Found:=0;
  while (Pos>0) and (Found=0) do begin
    if Copy(St,Pos,Len)=SubStr then
      Found:=Pos;
    Dec(Pos);
  end;
  LastPos:=Found;
end;

function  DefaultExtension(fn,ext: string): string;
begin
  if LastPos('.',fn)=0 then
    DefaultExtension:=fn+'.'+Ext
  else
    DefaultExtension:=fn;
end;

function  ForceExtension(fn,ext: string): string;
begin
  if LastPos('.',fn)=0 then
    ForceExtension:=fn+'.'+ext
  else
    ForceExtension:=Copy(fn,1,LastPos('.',fn)-1)+'.'+Ext;
end;

function  ItemCount(St: string;Sep:CharSet):integer;
var
  i,Count,Len : integer;
begin
  Count:=0; i:=1;
  Len:=Length(St);
  if Len > 0 then begin
    if st[len] in Sep then Delete(st,len,1);
    if (st <> '') and (st[1] in Sep) then Delete(st,1,1);
    count := 1;
    Len:=Length(St);
    while (i<=Len) do begin
      if (St[i] in Sep) then inc(count);
      inc(i);
    end;
  end;
  result:=Count;
end;

function  ExtractItem(Num:integer;St: string;Sep:CharSet): string;
var
  i, Count, Len : integer;
begin
  Count:=1; i:=1;
  Len:=Length(St);
  result :='';
  while (i<=Len) and (Count<=Num) do begin
    while (i<=Len) and (St[i] in Sep) do
    begin
      inc(i);
      if i<=Len then inc(Count);
    end;
    while (i<=Len) and NOT(St[i] in Sep) do begin
      if Count=Num then
        result := result +St[i];
      Inc(I);
    end;
  end;
end;

function LargeInt(zahl : longint; len : integer) : string;
var d, s : string;
    i    : integer;
    k    : integer;
begin
  if zahl <= 0 then begin
    LargeInt:= '';
    exit;
  end;
  d := '';
  s := IntToStrEx(zahl,len);
  k := 0;
  for i := Length(s) downto 1 do begin
    if k = 3 then begin
       d := '''' + d;
       k := 1;
    end else
       inc(k);
    d := s[i] + d;
  end;
  LargeInt := d;
end;

{ Um das Passwort zu kodieren, werden vier wiederholende Schlüssel
  eingesetzt }
function Codestring(password : string) : string;
const
  { Schlüsselwerte für Passwortkodierung }
  PassKey    : array[1..4] of byte = (23,45,130,230);
var i : integer;
    s : string[255];
    c : array[0..255] of byte absolute s;
    k : byte;
begin
  s := Password;
  if  (length(s) > 0)
  and (s <> '') then
    for i := 1 to Length(s) do
    begin
      k := round(Frac(i/4)*100);
      case k of
       25 : c[i] := Passkey[1] xor c[i];
       50 : c[i] := Passkey[2] xor c[i];
       75 : c[i] := Passkey[3] xor c[i];
       else c[i] := Passkey[4] xor c[i];
      end;
    end;
  result := s;
end;

function GetIOMessage(no : integer) : string;
begin
  case no of
    0  : result := 'Fehlerfreie Ausführung';
    2  : result := 'Datei nicht gefunden';
    3  : result := 'Pfad nicht gefunden';
    4  : result := 'Maximalzahl an Dateien bereits offen';
    5  : result := 'Dateizugriff verweigert';
    6  : result := 'Dateihandle nicht definiert bzw. ungültig';
    12 : result := 'Ungültiger Dateimodus';
    15 : result := 'Laufwerksnummer unzulässig';
    16 : result := 'Als Standard gesetztes Verzeichnis kann nicht gelöscht werden';
    17 : result := 'RENAME kann keine Dateien über Laufwerke verschieben';
    32 : result := 'Zugriff auf Datei verweigert (Filelock)';
    100: result := 'Fehler beim Lesen';
    102: result := 'Fehler beim Schreiben';
    103: result := 'Datei nicht offen';
    104: result := 'Datei wurde nicht für Leseoperationen geöffnet';
    105: result := 'Datei wurde nicht für Schreiboperationn geöffnet';
    106: result := 'Ungültiges numerisches Format';
    150: result := 'Diskette ist schreibgeschützt';
    151: result := 'Peripheriegerät nicht bekannt/nicht angeschlossen';
    152: result := 'Laufwerk ist nicht betriebsbereit';
    153: result := 'Ungültiger DOS-Funktionscode/Funktion nicht definiert';
    154: result := 'Prüfsummen-Fehler beim Lesen von Diskette/Platte';
    155: result := 'Ungültiger Disk-Parameterblock';
    156: result := 'Kopf-Positionierungsfehler auf Diskette/Platte';
    159: result := 'Drucker hat kein Papier mehr';
    200: result := 'Division durch Null';
    else result := 'Unbekannter Fehler';
  end;
end;

function  ReplaceChars(s: string; OldChars: CharSet; NewChar: char) : string;
var i : integer;
begin
  result := '';
  if Length(s) > 0 then begin
    for i := 1 to Length(s) do
      if s[i] in OldChars then result := result + NewChar
      else result := result + s[i];
  end;
end;

function GetShortDayStr(DayOfWeek: integer) : string;
begin
  result := '';
  case DayOfWeek of
    1 : result := 'Sun';
    2 : result := 'Mon';
    3 : result := 'Tue';
    4 : result := 'Wed';
    5 : result := 'Thu';
    6 : result := 'Fri';
    7 : result := 'Sat';
  end;
end;

function GetShortMonthStr(ADate: TDateTime) : string;
var
  Year, Month, Day: word;
begin
  result := '';
  DecodeDate(ADate, Year, Month, Day);
  case Month of
    1 : result := 'Jan';
    2 : result := 'Feb';
    3 : result := 'Mar';
    4 : result := 'Apr';
    5 : result := 'May';
    6 : result := 'Jun';
    7 : result := 'Jun';
    8 : result := 'Aug';
    9 : result := 'Sep';
    10: result := 'Oct';
    11: result := 'Nov';
    12: result := 'Dec';
  end;
end;

function  ReplaceStr(s, OldSubStr, NewSubStr: string; IgnoreCase: boolean = false) : string; // In S alle OldSubStr mit NewSubStr ersetzen
var
  i : integer;
  OldSubLen,
  TotalLength : integer;
begin
  result := '';
  if s <> '' then begin

    if IgnoreCase then s:= LowerCase(s);

    OldSubLen := Length(OldSubStr); // für die Performance
    TotalLength := Length(s);
    i := 1;
    while i <= TotalLength do begin
      if  (i <= TotalLength - OldSubLen + 1)
      and (((not ignoreCase) and (Copy(s, i, OldSubLen) = OldSubStr))
       or ((ignoreCase) and (Copy(s, i, OldSubLen) = LowerCase(OldSubStr)))) then begin
        result := result + NewSubStr;
        Inc(i, OldSubLen);
      end else begin
        result := result + s[i];
        Inc(i);
      end;
    end;
  end;
end;

function  CopyEnd(s: string; StartPos: integer): string;
begin
  result := '';
  if StartPos <= Length(s) then
    result := Copy(s, startpos, Length(s) - startpos +1);
end;

// Liefert einen Connection-string mit dem eingesetzten Pfad zurück
function  BuildADOConnectionStr(AConnectionstring, ADataSourcePath: string) : string;
var
  i,c,p : integer;
  sTmp : string;
begin
  result := '';
  c := ItemCount(AConnectionstring, [';']); // performace tuning
  if c > 0 then
    for i := 1 to c do begin
      if result <> '' then result := result + ';';
      sTmp := ExtractItem(i, AConnectionstring, [';']);
      p := Pos('=', sTmp);
      if  (p > 1)
      and (UpperCase(Copy(sTmp, 1, p-1)) = 'DATA SOURCE') then
        result := result + 'Data Source=' + ADataSourcePath
      else
        result := result + sTmp;
    end;
end;

function Right( const s: string; len: integer ): string;
var
  l: integer;
begin
  l:= Length( s );
  if len >= l then begin
    result:= s;
  end else begin
    result:= Copy( s, l - len + 1, len );
  end;
end {Right};

function PadIpZero(s: String): String;
begin
  if length(s) < 2 then
    s := '0' + s;
  Result := s;
end;

function  FirstPos( substr, inString: string; offset: integer; caseSesitive: boolean = false ): integer;
begin
  if not caseSesitive then begin
    result:= PosEx( LowerCase( substr ), LowerCase( inString ), offset );
  end else begin
    result:= PosEx( substr, inString, offset );
  end;
end;

// Entfernt / Ersetzt ungültige Zeichen innerhalb eines Dateinames
function  MakeValidFileName( AFileName: string ): string;
begin
  result:= ReplaceChars( AFileName,
                         ['/', '\', '*', '?', '|', ':', '<', '>', '"'],
                         '_' );
end;

end.

