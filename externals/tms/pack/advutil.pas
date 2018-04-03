{*************************************************************************}
{ TADVSTRINGGRID HELPER FUNCTIONS                                         }
{ for Delphi & C++Builder                                                 }
{ version 2.4.0.0                                                         }
{                                                                         }
{ written by                                                              }
{  TMS Software                                                           }
{  copyright © 1996-2002                                                  }
{  Email : info@tmssoftware.com                                           }
{  Web : http://www.tmssoftware.com                                       }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}
unit AdvUtil;

{$H+}

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Graphics, Grids, Classes, Controls, StdCtrls;

type
  TAutoType = (atNumeric,atFloat,atString,atDate,atTime);

  TTextType = (ttText,ttHTML,ttRTF,ttFormula,ttURL,ttUnicode);

  TCharSet = set of char;

  function Matches(s0a,s1a:PChar):Boolean;
  function MatchStr(s1,s2:string;DoCase:Boolean):boolean;
  function MatchStrEx(s1,s2:string;DoCase:Boolean):boolean;
  procedure LineFeedsToCSV(var s:string);
  procedure CSVToLineFeeds(var s:string);
  procedure LineFeedsToJava(var s:string);
  procedure JavaToLineFeeds(var s:string);
  function LineFeedsToXLS(s:string):string;
  function LfToFile(s:string):string;
  function CRToLF(s:string):string;  
  function FileToLf(s:string;multiline:Boolean):string;
  function DoubleToSingleChar(ch:char;const s:string):string;
  function GetNextLine(var s:string;multiline:Boolean):string;
  function LinesInText(s:string;multiline:Boolean):Integer;
  procedure OemToString(var s:string);
  procedure StringToOem(var s:string);
  procedure StringToPassword(var s:string;passwordchar:char);
  function RectString(r:trect):string;
  function FixDecimalSeparator(s:string):string;
  function GetNextDate(d:TDateTime;dye,dmo,dda:word;dtv:TDateTime):TDateTime;
  procedure DrawBitmapTransp(Canvas:TCanvas;bmp:TBitmap;bkcolor: TColor;r: TRect);
  procedure DrawBitmapResourceTransp(Canvas: TCanvas; bkColor: TColor; r: TRect; ResName:string);
  procedure DrawErrorLines(Parent:TWinControl;Canvas: TCanvas; TmpStr:string; Rect:TRect; Height,ErrPos,ErrLen: Integer);
  function SinglePos(p:char;s:string;var sp:Integer):Integer;
  function NumSingleChar(p:char;s:string):Integer;
  function NumChar(p:char;s:string):Integer;
  function IsType(s:string):TAutoType;
  function CLFToLF(s:string):string;
  function LFToCLF(s:string):string;
  function HTMLColor(l:dword):string;
  function HTMLLineBreaks(s:string):string;
  function TextType(s:string;allowhtml:boolean):TTextType;
  function NameToCell(s:string;var cell:tpoint):boolean;
  function RemoveSeps(s:string):string;
  function VarPos(su,s:string;var respos:Integer):Integer;
  function FirstChar(charset:TCharSet;s:string):char;
  function IsURL(const s:string):boolean;
  procedure StripURLProtocol(var s:string);
  function Max(i1,i2:Integer):Integer;
  function Min(i1,i2:Integer):Integer;
  function GetToken(var s:string;separator:string):string;
  function ShiftCase(Name: string): string;
  function StrToShortdateUS(s:string):TDateTime;
  function StrToShortDateEU(s:string):TDateTime;
  function IsInGridRect(rc:TGridRect;c,r: Integer): Boolean;
  function StringListToText(st:TStringList):string;
  function FIPos(su,s:string): Integer;
  function CharPos(ch: Char; const s: string): Integer;
  function VarCharPos(ch: Char; const s: string; var Res: Integer): Integer;
  function VarCharPosNC(ch: Char; const s: string; var Res: Integer): Integer;
  function DarkenColor(Color: TColor): TColor;
  function CheckLimits(Value,LowLimit,UpLimit: Integer): Integer;
  function NumCharInStr(p:char; s:string):Integer;
  function CSVQuotes(const S: string): string;
  procedure DrawProgressPie(Canvas: TCanvas; r: TRect;Color: TColor; p: Integer);
  procedure DrawProgressLin(Canvas: TCanvas; r: TRect; Color1,TColor1,Color2,TColor2: TColor; p,Mx,My:Integer);
  procedure DrawGradient(Canvas: TCanvas; FromColor,ToColor: TColor; Steps: Integer; R: TRect; Direction: Boolean);
  procedure DrawComboButton(Canvas: TCanvas;Handle: THandle; ARect: TRect;WinXP,Flat: Boolean);
  function DecodeWideStr(s:string): widestring;
  function EncodeWideStr(s:widestring): string;
  function StrPosWide(SubStr, Str: widestring): integer;

implementation

uses
  AdvXPVS;

const
  LINEFEED = #13;

function CSVQuotes(const s: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to length(s) do
  begin
    Result := Result + s[i];
    if s[i]='"' then
      Result := Result + '"';
  end;
end;


function CheckLimits(Value,LowLimit,UpLimit: Integer): Integer;
begin
  Result := Value;

  if LowLimit <> UpLimit then
  begin
    if (Value < LowLimit) and (LowLimit > 0) then
      Result := LowLimit;
    if (Value > Uplimit) and (UpLimit > 0) then
      Result := UpLimit;
  end;
end;


function DarkenColor(Color: TColor): TColor;
var
  r,g,b: longint;
  l: longint;
begin
  l := ColorToRGB(Color);
  r := ((l AND $FF0000) shr 1) and $FF0000;
  g := ((l AND $FF00) shr 1) and $FF00;
  b := ((l AND $FF) shr 1) and $FF;
  Result := r or g or b;
end;

function FIPos(su,s:string):Integer;
begin
  Result := Pos(su,UpperCase(s));
end;

function VarCharPos(ch: Char; const s: string; var Res: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(s) do
    if s[i] = ch then
    begin
      Res := i;
      Result := i;
      Break;
    end;
end;

function VarCharPosNC(ch: Char; const s: string; var Res: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(s) do
    if upcase(s[i]) = ch then
    begin
      Res := i;
      Result := i;
      Break;
    end;
end;


function CharPos(ch: Char; const s: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(s) do
    if s[i] = ch then
    begin
      Result := i;
      Break;
    end;
end;

function IsInGridRect(rc:TGridRect;c,r: Integer): Boolean;
begin
  Result := (c >= rc.Left) and (c <= rc.Right) and (r >= rc.Top) and (r <= rc.Bottom);
end;


function GetToken(var s:string;separator:string):string;
var
  sp:Integer;
begin
  Result := '';
  sp := Pos(separator,s);
  if sp > 0 then
  begin
    Result := Copy(s,1,sp - 1);
    Delete(s,1,sp);
  end;
end;

function Max(i1,i2:Integer):Integer;
begin
  if i1 > i2 then
    Result := i1
  else
    Result := i2;
end;

function Min(i1,i2:Integer):Integer;
begin
  if i1 < i2 then
    Result := i1
  else
    Result := i2;
end;

function StringListToText(st:TStringList):string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to st.Count do
    Result := Result + st.Strings[i - 1];
end;

function VarPos(su,s:string;var Respos:Integer):Integer;
begin
  Respos := Pos(su,s);
  Result := Respos;
end;

function FirstChar(Charset:TCharSet;s:string):char;
var
  i:Integer;
begin
  i := 1;
  Result := #0;
  while i <= Length(s) do
  begin
    if s[i] in Charset then
    begin
      Result := s[i];
      Break;
    end;
    Inc(i);
  end;
end;

{parse RxCy naming}
function NameToCell(s:string;var Cell:TPoint):Boolean;
var
  code1,code2,cp: Integer;
  r,c: Integer;
begin
  s := Uppercase(s);
  Result := False;
  if Length(s) >= 4 then
  begin
    if s[1] = 'R' then
    begin
      Delete(s,1,1);
      if VarPos('C',s,cp) > 0 then
      begin
        Val(Copy(s,1,cp - 1),r,code1);
        Val(Copy(s,cp + 1,Length(s)),c,code2);
        if (code1 = 0) and (code2 = 0) then
        begin
          Cell.x := c;
          Cell.y := r;
          Result := True;
        end;
      end;
    end;
  end;
end;

function IsURL(const s:string):boolean;
begin
  Result := (Pos('://',s) > 0) or (Pos('mailto:',s) > 0);
end;

procedure StripURLProtocol(var s:string);
var
 vp: Integer;
begin
  if VarPos('://',s,vp)>0 then Delete(s,1,vp + 2)
  else
   if VarPos('mailto:',s,vp)>0 then Delete(s,1,vp + 6);
end;

function TextType(s:string;AllowHTML:Boolean):TTextType;
begin
  Result := ttText;
  s := s + ' ';

  if Length(s) > 1 then
  begin
    if s[1] = '=' then
      Result := ttFormula
    else
    begin
      if (s[1] = '|') and (s[2] = '\') then
      begin
        Result := ttUnicode;
        Exit;
      end;

      if (s[1] = '{') and (s[2] = '\') then
      begin
        Result := ttRTF;
        Exit;
      end;  

      if AllowHTML then
      begin
        if (Pos('</',s) > 0) or (Pos('<B',s) > 0) or (Pos('<I',s) > 0) then
          Result := ttHTML;
      end;
    end;
    
  end;
end;

function RemoveSeps(s:string):string;
var
  i: Integer;
  Neg: Boolean;
begin
  Result := '';
  Neg := False;

  if Length(s) = 0 then Exit;

  // delete leading and / or trailing spaces
  Trim(s);

  // delete currency () negative value brackets  
  if Length(s) > 0 then
  begin
    if (s[1] = '(') and (s[Length(s)] = ')') then
      Neg := True;
  end;

  while (Length(s) > 1) and
    not (s[1] in ['0'..'9',ThousandSeparator,DecimalSeparator]) do
    begin
      if s[1] = '-' then
        Neg := True;
      Delete(s,1,1);
    end;

  for i := 1 to Length(s) do
  begin
    if s[i] <> ThousandSeparator then
      if s[i] = DecimalSeparator then
        Result := Result + '.'
      else
      begin
        if s[i] in ['0'..'9','.','-'] then
          Result := Result + s[i]
        else
          Break;
      end;
  end;

  if Neg then
    Result := '-' + Result;

end;

{$IFNDEF DELPHI4_LVL}
function StringReplace(const S, OldPattern, NewPattern: string): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  SearchStr := S;
  Patt := OldPattern;

  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    {$IFDEF DELPHI3_LVL}
    Offset := AnsiPos(Patt, SearchStr);
    {$ELSE}
    Offset := Pos(Patt, SearchStr);
    {$ENDIF}

    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    Result := Result + NewStr;
    Break;
  end;
end;
{$ENDIF}


function HTMLLineBreaks(s:string):string;
var
  i:Integer;
  res: String;
begin
  res := '';
  if Pos(#13,s) = 0 then
    res := s
  else
    for i := 1 to Length(s) do
    begin
      if s[i] <> #13 then
        res := res + s[i]
      else
        res := res + '<br>';
    end;

  {$IFDEF DELPHI4_LVL}
  res := StringReplace(res,'&','&amp;',[rfReplaceAll]);
  if pos('>',s) = 0 then
    res := StringReplace(res,'<','&lt;',[rfReplaceAll]);
  if pos('<',s) = 0 then
    res := StringReplace(res,'>','&gt;',[rfReplaceAll]);
  res := StringReplace(res,'"','&quot;',[rfReplaceAll]);
  {$ELSE}
  res := StringReplace(res,'&','&amp;');
  if pos('<',s) = 0 then
    res := StringReplace(res,'>','&gt;');
  if pos('>',s) = 0 then
    res := StringReplace(res,'<','&lt;');
  res := StringReplace(res,'"','&quot;');
  {$ENDIF}


  Result := res;

end;

function HTMLColor(l:dword):string;
const
  HexDigit:array[0..$F] of char = '0123456789ABCDEF';

var
  lw,hw: Word;
begin
  lw := loword(l);
  hw := hiword(l);
  HTMLColor:=HexDigit[Lo(lw) shr 4]+HexDigit[Lo(lw) and $F]+
             HexDigit[Hi(lw) shr 4]+HexDigit[Hi(lw) and $F]+
             HexDigit[Lo(hw) shr 4]+HexDigit[Lo(hw) and $F];
end;

function IsType(s:string):TAutoType;
var
  i: Integer;
  isI,isF: Boolean;
  th,de,mi: Integer;

begin
  Result := atString;
  if s = '' then Exit;

  isI := True;
  isF := True;

  th := -1;
  de := 0;
  mi := 0;

  for i := 1 to Length(s) do
  begin
    if not (s[i] in ['0'..'9','-']) then isI := False;
    if not (s[i] in ['0'..'9','-',Thousandseparator,Decimalseparator]) then isF := False;
    if (s[i] = ThousandSeparator) and (i - th < 3) then isF := False;
    if s[i] = ThousandSeparator then th := i;
    if s[i] = DecimalSeparator then Inc(de);
    if s[i] = '-' then inc(mi);
  end;

  if isI then
    Result := atNumeric
  else
  begin
    if isF then
      Result := atFloat;
  end;

  if (mi > 1) or (de > 1) then
    Result := atString;
end;

function CLFToLF(s:string):string;
var
  vp: Integer;
begin
  while VarPos('\n',s,vp)>0 do
  begin
    s := Copy(s,1,vp - 1) + #13 + Copy(s,vp + 2,Length(s));
  end;
  Result := s;
end;

function LFToCLF(s:string):string;
var
  res:string;
  i:Integer;
begin
  Res := '';
  for i := 1 to Length(s) do
  begin
    if s[i] = #13 then
      Res := Res + '\n'
    else
      if s[i] <> #10 then
        Res := Res + s[i];
   end;
  Result:=res;
end;


procedure StringToPassword(var s:string;passwordchar:char);
var
  i: Integer;
begin
  for i := 1 to Length(s) do
    s[i] := PasswordChar;
end;

procedure StringToOem(var s:string);
var
  pin,pout: PChar;
begin
  {$IFDEF WIN32}
  GetMem(pin,Length(s)+1);
  GetMem(pout,Length(s)+1);
  StrLCopy(pin,PChar(s),Length(s));
  CharToOem(pin,pout);
  s := StrPas(pout);
  FreeMem(pin);
  FreeMem(pout);
 {$ENDIF}
end;

procedure OemToString(var s:string);
var
  pin,pout: PChar;
begin
  {$IFDEF WIN32}
  GetMem(pin,Length(s) + 1);
  GetMem(pout,Length(s) + 1);
  StrPLCopy(pin,s,Length(s));
  OemToChar(pin,pout);
  s := StrPas(pout);
  FreeMem(pin);
  FreeMem(pout);
  {$ENDIF}
end;

function DoubleToSingleChar(ch: Char;const s:string):string;
var
  Res: string;
  i: Integer;
begin
  if (s = '') or (CharPos(ch,s) = 0) then
  begin
    DoubleToSingleChar := s;
    Exit;
  end;

  res := '';
  i   := 1;

  repeat
    if s[i] <> ch then
      Res := Res + s[i]
    else
      if ((s[i] = ch) and (s[i + 1] = ch)) then
        begin
        Inc(i);
        Res := Res + s[i];
        end;
    Inc(i);
  until (i > Length(s));

  DoubleToSingleChar := Res;

  {
  res := s[1];
  for i := 2 to Length(s) do
  begin
   if s[i] <> ch then
     Res := Res + s[i]
   else
     if ((s[i] = ch) and (s[i - 1] <> ch)) then
       Res := Res + s[i];
  end;
  DoubleToSingleChar := Res;
  }
end;

procedure LineFeedsToCSV(var s:string);
var
  vp: Integer;
begin
  while VarPos(#13#10,s,vp)>0 do
    Delete(s,vp,1);
  s := '"' + s + '"';
end;

procedure CSVToLineFeeds(var s:string);
var
  res: string;
  i: Integer;
begin
  if CharPos(#10,s) = 0 then
    Exit;
  Res := '';
  for i := 1 to Length(s) do
    if s[i] = #10 then
      Res := Res + #13#10
    else
      Res := Res + s[i];
  s := Res;
end;

procedure LineFeedsToJava(var s:string);
var
  i: Integer;
  Res: string;
begin
  Res := '';
  for i := 1 to Length(s) do
    if s[i] = #13 then
      Res := Res + '~'
    else
    begin
      if s[i] <> #10 then
        Res := Res + s[i];
    end;
  s := res;
end;

procedure JavaToLineFeeds(var s:string);
var
  Res: string;
  i: Integer;
begin
  Res := '';
  for i := 1 to Length(s) do
    if s[i] = '~' then
      Res := Res + #13#10
    else
      Res := Res + s[i];
  s := Res;
end;

function IsDate(s:string;var dt:TDateTime):boolean;
var
  su: string;
  da,mo,ye: word;
  err: Integer;
  dp,mp,yp,vp: Integer;
begin
  Result:=False;

  su := UpperCase(shortdateformat);
  dp := pos('D',su);
  mp := pos('M',su);
  yp := pos('Y',su);

  da := 0;
  mo := 0;
  ye := 0;

  if VarPos(Dateseparator,s,vp)>0 then
  begin
    su := Copy(s,1,vp - 1);

    if (dp<mp) and
       (dp<yp) then
       val(su,da,err)
    else
    if (mp<dp) and
       (mp<yp) then
       val(su,mo,err)
    else
    if (yp<mp) and
       (yp<dp) then
       val(su,ye,err);

    if err<>0 then Exit;
    Delete(s,1,vp);

    if VarPos(DateSeparator,s,vp)>0 then
    begin
      su := Copy(s,1,vp - 1);

      if ((dp>mp) and (dp<yp)) or
         ((dp>yp) and (dp<mp)) then
         val(su,da,err)
      else
      if ((mp>dp) and (mp<yp)) or
         ((mp>yp) and (mp<dp)) then
         val(su,mo,err)
      else
      if ((yp>mp) and (yp<dp)) or
         ((yp>dp) and (yp<mp)) then
         val(su,ye,err);

      if err<>0 then Exit;
      Delete(s,1,vp);

      if (dp>mp) and
         (dp>yp) then
         val(s,da,err)
      else
      if (mp>dp) and
         (mp>yp) then
         val(s,mo,err)
      else
      if (yp>mp) and
         (yp>dp) then
         val(s,ye,err);

      if err<>0 then Exit;
      if (da>31) then Exit;
      if (mo>12) then Exit;

      Result:=True;

      try
        dt := EncodeDate(ye,mo,da);
      except
        Result := False;
      end;

     end;

  end;
end;

{
function IsTime(s:string;var dt:TDateTime):boolean;
var
 su:string;
 ho,mi:word;
 err:Integer;
begin
 Result:=False;
 if (pos(timeseparator,s)>0) then
  begin
    su:=copy(s,1,pos(timeseparator,s)-1);
    val(su,ho,err);
    delete(s,1,pos(timeseparator,s)+1);
    val(su,mi,err);
    if ho>23 then Exit;
    if mi>59 then Exit;
    Result:=True;
    try
     dt:=encodetime(ho,mi,0,0);
    except
     Result:=False;
    end;
  end;
end;
}


function MatchStrEx(s1,s2:string;DoCase:Boolean): Boolean;
var
  ch,lastop: Char;
  sep: Integer;
  res,newres: Boolean;

begin
 {remove leading & trailing spaces}
  s1 := Trim(s1);
 {remove spaces between multiple filter conditions}
  while VarPos(' &',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos(' ;',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos(' ^',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos(' |',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos(' =',s1,sep) > 0 do Delete(s1,sep,1);
  while VarPos('& ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('; ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('^ ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('| ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('= ',s1,sep) > 0 do Delete(s1,sep+1,1);

  while VarPos('=',s1,sep) > 0 do Delete(s1,sep,1);    

  LastOp := #0;
  Res := True;

  repeat
    ch := FirstChar([';','^','&','|'],s1);
    {extract first part of filter}
    if ch <> #0 then
    begin
      VarPos(ch,s1,sep);
      NewRes := MatchStr(Copy(s1,1,sep-1),s2,DoCase);
      Delete(s1,1,sep);

      if LastOp = #0 then
        Res := NewRes
      else
        case LastOp of
        ';','^','|':Res := Res or NewRes;
        '&':Res := Res and NewRes;
        end;

      LastOp := ch;
     end;

  until ch = #0;

  NewRes := MatchStr(s1,s2,DoCase);

  if LastOp = #0 then
    Res := NewRes
  else
    case LastOp of
    ';','^','|':Res := Res or NewRes;
    '&':Res := Res and NewRes;
    end;
    
  Result := Res;
end;

function MatchStr(s1,s2:string;DoCase:Boolean):Boolean;
begin
  if DoCase then
    MatchStr := Matches(PChar(s1),PChar(s2))
  else
    MatchStr := Matches(PChar(AnsiUpperCase(s1)),PChar(AnsiUpperCase(s2)));
end;

function Matches(s0a,s1a:PChar):boolean;
const
  larger = '>';
  smaller = '<';
  logand  = '&';
  logor   = '^';
  asterix = '*';
  qmark = '?';
  negation = '!';
  null = #0;

var
  matching:boolean;
  done:boolean;
  len:longint;
  lastchar:char;
  s0,s1,s2,s3:pchar;
  oksmaller,oklarger,negflag:boolean;
  compstr:array[0..255] of char;
  flag1,flag2,flag3:boolean;
  equal:boolean;
  n1,n2:double;
  code1,code2:Integer;
  dt1,dt2:TDateTime;

begin
  oksmaller := True;
  oklarger := True;
  flag1 := False;
  flag2 := False;
  flag3 := False;
  negflag := False;
  equal := False;

  { [<>] string [&|] [<>] string }


  // do larger than or larger than or equal
  s2 := StrPos(s0a,larger);
  if s2 <> nil then
  begin
    inc(s2);
    if (s2^ = '=') then
    begin
      Equal := True;
      inc(s2);
    end;

    while (s2^ = ' ') do
      inc(s2);

    s3 := s2;
    len := 0;

    lastchar := #0;

    while (s2^ <> ' ') and (s2^ <> NULL) and (s2^ <> '&') and (s2^ <> '|')  do
    begin
      if (len = 0) and (s2^ = '"') then
        inc(s3)
      else
        inc(len);

      lastchar := s2^;
      inc(s2);
    end;

    if (len > 0) and (lastchar = '"') then
      dec(len);

    StrLCopy(compstr,s3,len);

    Val(s1a,n1,code1);
    Val(compstr,n2,code2);

    if (code1 = 0) and (code2 = 0) then {both are numeric types}
    begin
      if equal then
        oklarger := n1 >= n2
      else
        oklarger := n1 > n2;
    end
    else
    begin
      if IsDate(StrPas(compstr),dt2) and IsDate(StrPas(s1a),dt1) then
      begin
        if equal then
         oklarger := dt1 >= dt2
        else
         oklarger := dt1 > dt2;
      end
      else
      begin
        if equal then
         oklarger := (strlcomp(compstr,s1a,255)<=0)
        else
         oklarger := (strlcomp(compstr,s1a,255)<0);
      end;
    end;
    flag1 := True;
  end;

  equal := False;

  // do smaller than or smaller than or equal
  s2 := strpos(s0a,smaller);
  if (s2 <> nil) then
  begin
    inc(s2);
    if (s2^ = '=') then
      begin
       equal := True;
       inc(s2);
      end;
      
    lastchar := #0;

    while (s2^=' ') do inc(s2);
    s3 := s2;
    len := 0;
    while (s2^ <> ' ') and (s2^ <> NULL) and (s2^ <> '&') and (s2^ <> '|') do
    begin
      if (len = 0) and (s2^ = '"') then
        inc(s3)
      else
        inc(len);

      lastchar := s2^;
      inc(s2);
    end;

    if (len > 0) and (lastchar = '"') then
      dec(len);

    strlcopy(compstr,s3,len);

    val(s1a,n1,code1);
    val(compstr,n2,code2);

    if (code1 = 0) and (code2 = 0) then // both are numeric types
     begin
      if equal then
       oksmaller := n1 <= n2
      else
       oksmaller := n1 < n2;
     end
    else
     begin
      // check for dates here ?
      if IsDate(strpas(compstr),dt2) and IsDate(strpas(s1a),dt1) then
       begin
        if equal then
         oksmaller := dt1 <= dt2
        else
         oksmaller := dt1 < dt2;
       end
      else
       begin
        if equal then
          oksmaller := (strlcomp(compstr,s1a,255)>=0)
        else
          oksmaller := (strlcomp(compstr,s1a,255)>0);
       end;
     end;

    flag2 := True;
  end;

  s2 := strpos(s0a,negation);
  
  if (s2 <> nil) then
  begin
    inc(s2);
    while (s2^=' ') do
      inc(s2);
    s3 := s2;
    len := 0;

    lastchar := #0;

    while (s2^ <> ' ') and (s2^ <> NULL) and (s2^ <> '&') and (s2^ <> '|') do
    begin
      if (len = 0) and (s2^ = '"') then
        inc(s3)
      else
        inc(len);
        
      lastchar := s2^;
      inc(s2);
    end;

    if (len > 0) and (lastchar = '"') then
      dec(len);

    strlcopy(compstr,s3,len);
    flag3 := True;
  end;

  if (flag3) then
  begin
    if strpos(s0a,larger) = nil then
      flag1 := flag3;
    if strpos(s0a,smaller) = nil then
      flag2 := flag3;
  end;

  if (strpos(s0a,logor) <> nil) then
    if flag1 or flag2 then
    begin
      matches := oksmaller or oklarger;
      Exit;
    end;

  if (strpos(s0a,logand)<>nil) then
    if flag1 and flag2 then
    begin
      matches := oksmaller and oklarger;
      Exit;
    end;

  if ((strpos(s0a,larger) <> nil) and (oklarger)) or
     ((strpos(s0a,smaller) <> nil) and (oksmaller)) then
  begin
    matches := True;
    Exit;
  end;

  s0 := s0a;
  s1 := s1a;

  matching := True;

  done := (s0^ = NULL) and (s1^ = NULL);

  while not done and matching do
  begin
    case s0^ of
    qmark:
      begin
        matching := s1^ <> NULL;
        if matching then
        begin
          inc(s0);
          inc(s1);
        end;
      end;
    negation:
      begin
        negflag:=True;
        inc(s0);
      end;
    '"':
      begin
        inc(s0);
      end;
    asterix:
      begin
        repeat
          inc(s0)
        until (s0^ <> asterix);
        len := strlen(s1);
        inc(s1,len);
        matching := matches(s0,s1);
        while (len >= 0) and not matching do
        begin
         dec(s1);
         dec(len);
         matching := Matches(s0,s1);
       end;
       if matching then
       begin
         s0 := strend(s0);
         s1 := strend(s1);
       end;
     end;
   else
     begin
       matching := s0^ = s1^;

       if matching then
       begin
         inc(s0);
         inc(s1);
       end;
     end;
   end;

   Done := (s0^ = NULL) and (s1^ = NULL);
  end;

  if negflag then
    Matches := not matching
  else
    Matches := matching;
end;

function Lftofile(s:string):string;
var
  i:Integer;
begin
  if Pos(#13,s) > 0 then
    for i := 1 to Length(s) do
    begin
      if s[i] = #13 then s[i] := #9;
      if s[i] = #10 then s[i] := #8;
    end;
  LFToFile := s;
end;

function FileToLF(s:string;multiline:boolean):string;
var
  i:Integer;
begin
  if Pos(#8,s)>0 then
    for i := 1 to Length(s) do
    begin
      if s[i] = #9 then s[i] := #13;
      if s[i] = #8 then s[i] := #10;
    end;
  if not MultiLine then
    FileToLF := GetNextLine(s,multiline)
  else
    FiletoLF := s;
end;

function GetNextLine(var s:string;multiline:boolean):string;
var
  vp: Integer;
begin
  if VarPos(LINEFEED,s,vp) > 0 then
  begin
    Result := Copy(s,1,vp-1);
    Delete(s,1,vp);
    if s<>'' then
      if s[1] = #10 then
        Delete(s,1,1);
    if not Multiline then
      s := '';
  end
  else
  begin
    Result := s;
    s := '';
  end;
end;

function LinesInText(s:string;multiline:boolean):Integer;
var
  vp: Integer;
begin
  Result := 1;
  if not Multiline then Exit;
  while VarPos(LINEFEED,s,vp)>0 do
  begin
    Inc(Result);
    Delete(s,1,vp);
  end;
end;

function RectString(r:trect):string;
begin
  Result := '['+inttostr(r.left)+':'+inttostr(r.top)+']['+inttostr(r.right)+':'+inttostr(r.left)+']';
end;

function FixDecimalSeparator(s:string):string;
var
  vp: Integer;
begin
  if Decimalseparator = ',' then
    if VarPos(',',s,vp)>0 then
      s[vp]:='.';

  Result := s;
end;

function GetNextDate(d:TDateTime;dye,dmo,dda:word;dtv:TDateTime):TDateTime;
var
  ye,mo,da:word;
begin
  decodedate(d,ye,mo,da);
  if (dmo=0) and (dye=0) and (dda<>0) then {equal month + equal year}
  begin
    Result:=d+dda;
  end
  else
  if (dmo=0) and (dye<>0) and (dda=0) then
  begin
    Result:=encodedate(ye+dye,mo,da);
  end
  else
  if (dmo<>0) and (dye=0) and (dda=0) then
  begin
    mo:=mo+dmo;
    if (mo<=0) then
    begin
      mo:=mo+12;
      dec(ye);
    end;
    if (mo>12) then
    begin
      mo:=mo-12;
      inc(ye);
    end;
    Result:=encodedate(ye,mo,da);
  end
  else
    Result := d + dtv;
end;

procedure DrawBitmapResourceTransp(Canvas: TCanvas; bkColor: TColor; r: TRect; ResName:string);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.LoadFromResourceName(hinstance,ResName);
  DrawBitmapTransp(Canvas,bmp,bkColor,r);
  bmp.Free;
end;

procedure DrawBitmapTransp(Canvas:TCanvas;bmp:TBitmap;bkcolor:TColor;r:TRect);
var
  tmpbmp: TBitmap;
  srcColor: TColor;
  tgtrect: TRect;
begin
  TmpBmp := TBitmap.Create;
  TmpBmp.Height := bmp.Height;
  TmpBmp.Width := bmp.Width;
  tgtrect.left :=0;
  tgtrect.top :=0;
  tgtrect.right := bmp.width;
  tgtrect.bottom := bmp.Height;
  r.bottom := r.top + bmp.height;
  r.Right := r.Left + bmp.width;
  TmpBmp.Canvas.Brush.Color := bkcolor;
  srcColor := bmp.canvas.pixels[0,0];
  TmpBmp.Canvas.BrushCopy(tgtrect,bmp,tgtrect,srcColor);
  Canvas.CopyRect(r, TmpBmp.Canvas, tgtrect);
  TmpBmp.Free;
end;

function SinglePos(p:char;s:string;var sp: Integer):Integer;
var
  i: Integer;
  QuoteCount: Integer;
begin
  i := 1;
  QuoteCount:= 0;
  while i <= Length(s) do
  begin
    if s[i] = p then
    begin
      if i < Length(s) then
        Inc(QuoteCount)
      else
        if i = Length(s) then
        begin
          Result := i;
          sp := i;
          Exit;
        end;
    end
    else
    begin
      if (Odd(QuoteCount)) then
      begin
        Result := i - 1;
        sp := i - 1;
        Exit;
      end
      else
        QuoteCount := 0;
    end;
    Inc(i);
  end;
  Result := 0;
  sp := 0;
end;

function NumSingleChar(p:char;s:string):Integer;
var
  Res,sp: Integer;
begin
  Res := 0;
  while SinglePos(p,s,sp) > 0 do
  begin
    Delete(s,1,sp);
    Inc(Res);
  end;
  Result := Res;
end;

function NumChar(p:char;s:string):Integer;
var
  Res,vp: Integer;
begin
  Res := 0;
  while VarPos(p,s,vp) > 0 do
  begin
    Delete(s,1,vp);
    Inc(Res);
  end;
  Result := Res;
end;

function NumCharInStr(p:char; s:string):Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(s) do
    if s[i] = p then
      Result := Result + 1;
end;

function LineFeedsToXLS(s:string):string;
var
  Res: string;
  i: Integer;
begin
  Res := '';
  for i := 1 to Length(s) do
    if s[i] <> #13 then
      Res := Res + s[i];
  Result := res;
end;

function CRToLF(s:string):string;
var
  i: integer;
  res:string;
begin
  res := '';

  for i := 1 to length(s) do
    if (s[i] <> #13) then
      res := res + s[i];

  Result := res;
end;

function ShiftCase(Name: string): string;

 function LowCase(C: char): char;
 begin
  if C in ['A' .. 'Z'] then LowCase := Chr(Ord(C) - Ord('A') + Ord('a'))
  else Lowcase := C;
 end;

const
  Terminators = [' ',',','.','-',''''];
var
  I, L: Integer;
  NewName: string;
  First: Boolean;
begin
  First := True;
  NewName := Name;
  L := Length(Name);

  for I := 1 to L do
  begin
    if NewName[I] in Terminators then
      First:= True
    else
      if First then
      begin
        NewName[I] := Upcase(Name[I]);
        First := False;
      end
      else
        NewName[I] := Lowcase(Name[I]);

    if (Copy(NewName, 1, I) = 'Mc') or
       ((Pos (' Mc', NewName) = I - 2) and (I > 2)) or
       ((I > L - 3) and ((Copy(NewName, I - 1, 2) = ' I') or
       (Copy(NewName, I - 2, 3) = ' II'))) then
       First:= True;
  end;

  Result := NewName;
end;


function StrToShortdateUS(s:string):TDateTime;
var
  Da,Mo,Ye,i: Word;
  Code: Integer;
  su: string;
begin
  Result := 0;

  i := Pos('/',s);
  if i = 0 then i := Pos('.',s);
  if i = 0 then i := Pos('-',s);

  if i > 0 then
  begin
    su := s[i];
    Val(Copy(s,1,i - 1),mo,Code);
    if Code <> 0 then Exit;
  end
  else
    Exit;

  Delete(s,1,i);

  i := pos(su,s);

  if i > 0 then
  begin
    Val(copy(s,1,i-1),Da,Code);
    if Code <> 0 then Exit;
  end
  else
    Exit;

  Delete(s,1,i);
  Val(s,ye,Code);
  if Code <> 0 then Exit;

  if ye <= 25 then
    ye := ye + 2000
  else
    ye := ye + 1900;

  Result := EncodeDate(ye,mo,da);
end;

function StrToShortDateEU(s:string):TDateTime;
var
  Da,Mo,Ye,i: Word;
  Code: Integer;
  su : string;

begin
  Result := 0;

  i := Pos('/',s);
  if i = 0 then i := Pos('.',s);
  if i = 0 then i := Pos('-',s);

  if i > 0 then
  begin
    su := s[i];
    Val(Copy(s,1,i-1),Da,Code);
    if Code <> 0 then Exit;
  end
  else
    Exit;

  Delete(s,1,i);
  i := Pos(su,s);

  if i > 0 then
  begin
    Val(Copy(s,1,i - 1),Mo,Code);
    if Code <> 0 then Exit;
  end
  else
    Exit;

  Delete(s,1,i);
  Val(s,ye,code);
  if Code <> 0 then Exit;

  if ye <= 25 then
    ye := ye + 2000
  else
    ye := ye + 1900;

  Result := Encodedate(ye,mo,da);
end;

procedure DrawErrorLines(Parent:TWinControl;Canvas: TCanvas; TmpStr:string; Rect:TRect; Height,ErrPos,ErrLen: Integer);
var
  Edit: TEdit;
  pt1: TPoint;
  pt2: TPoint;
  l: Integer;
  o: Integer;
  ep: Integer;
begin
  Edit := TEdit.Create(Parent);
  Edit.Visible := false;
  Edit.Parent := Parent;

  Edit.Top := Rect.Top;
  Edit.Left := Rect.Left;
  Edit.Width := Rect.Right - Rect.Left;
  Edit.Height := Rect.Bottom - Rect.Top;

  Edit.Text := TmpStr;

  if ErrPos >= Length(TmpStr) then
  begin
    ep := Length(TmpStr);
    l := SendMessage(Edit.Handle,EM_POSFROMCHAR,ep,0);
    pt1 := Point(LoWord(l),HiWord(l));
    pt1.X := pt1.X + 4;
  end
  else
  begin
    l := SendMessage(Edit.Handle,EM_POSFROMCHAR,ErrPos,0);
    pt1 := Point(LoWord(l),HiWord(l));
  end;

  if ErrPos + ErrLen >= Length(TmpStr) then
  begin
    ep := Length(TmpStr) - 1;
    l := SendMessage(Edit.Handle,EM_POSFROMCHAR,ep ,0);
    pt2 := Point(LoWord(l),HiWord(l));
    pt2.X := pt2.X + 4;
    pt2.Y := pt1.Y;
  end
  else
  begin
    l := SendMessage(Edit.Handle,EM_POSFROMCHAR,ErrPos + ErrLen - 1 ,0);
    pt2 := Point(LoWord(l),HiWord(l));
  end;

  Edit.Free;

  Canvas.Pen.Color := clRed;
  Canvas.Pen.Width := 2;

  l := pt1.X;
  o := 3;

  Canvas.MoveTo(Rect.Left + l,Rect.Top + pt1.Y + Height + o);

  while l <= pt2.X do
  begin
    if o = 3 then o := 0 else o := 3;
    Canvas.LineTo(Rect.Left + l + 3,Rect.Top + pt2.Y + Height + o);
    Inc(l,3);
  end;

  if o = 3 then o := 0 else o := 3;
  Canvas.LineTo(Rect.Left + l + 3,Rect.Top + pt2.Y + Height + o);
end;

procedure DrawProgressLin(Canvas: TCanvas; r: TRect; Color1,TColor1,Color2,TColor2: TColor; p,Mx,My: Integer);
var
  SrcColor: TColor;
  SrcRect: TRect;
  TgtRect: TRect;
begin
  SrcColor := Canvas.Brush.Color;

  Canvas.Brush.Color := Color1;
  Canvas.Pen.Color := Color1;
  Canvas.Font.Color := TColor1;

  Inflaterect(r,-Mx,-My);
  SrcRect := r;
  SrcRect.Right := SrcRect.Left+round( (SrcRect.Right-SrcRect.Left)*(p)/100);
  TgtRect.Left := r.Left + (((r.Right-r.Left) - Canvas.TextWidth(IntToStr(p)+'%')) div 2);
  TgtRect.Top := r.Top + (((r.Bottom-r.Top) - Canvas.TextHeight(IntToStr(p)+'%')) div 2);
  Canvas.TextRect(SrcRect,TgtRect.Left,TgtRect.Top,IntToStr(p)+'%');

  Canvas.Brush.Color := Color2;
  Canvas.Pen.Color := Color2;

  Canvas.Font.Color := TColor2;

  SrcRect.Left := SrcRect.Right;
  SrcRect.Right := r.Right;
  Canvas.TextRect(SrcRect,TgtRect.Left,TgtRect.Top,IntToStr(p)+'%');

  Canvas.Brush.Color := clBlack;
  Canvas.Pen.Color := SrcColor;
  Inflaterect(r,1,1);

  Canvas.FrameRect(r);
  Canvas.Brush.Color := SrcColor;
  Inflaterect(r,1,1);
  Canvas.FrameRect(r);
end;

procedure DrawProgressPie(Canvas: TCanvas; r: TRect; Color: TColor; p: Integer);
var
  x,y: Integer;
begin
  Canvas.Pen.Color := clGray;
  Canvas.Pen.Width := 1;
  Canvas.Ellipse(r.Left,r.Top,r.Right,r.Bottom);
  Canvas.MoveTo(r.Left + (r.Right - r.Left) div 2,r.Top);
  Canvas.LineTo(r.Left + (r.Right - r.Left) div 2,r.Top + (r.Bottom - r.Top) div 2);

  x := round(0.5 * succ(r.Right - r.Left) * sin( p/100*2*PI ));
  y := round(0.5 * succ(r.Bottom - r.Top) * cos( p/100*2*PI ));

  Canvas.LineTo( r.Left + x + (r.Right - r.Left) div 2,r.Top - y + (r.Bottom - r.Top) div 2);

  Canvas.Brush.Color := Color;
  Canvas.FloodFill(r.Left + 1 + (r.Right - r.Left) div 2,r.Top + 1,clGray,fsBorder);
end;

procedure DrawGradient(Canvas: TCanvas; FromColor,ToColor: TColor; Steps: Integer; R: TRect; Direction: Boolean);
var
  diffr,startr,endr: Integer;
  diffg,startg,endg: Integer;
  diffb,startb,endb: Integer;
  rstepr,rstepg,rstepb,rstepw: Real;
  i,stepw: Word;

begin
  if Steps = 0 then
    Steps := 1;

  startr := (FromColor and $0000FF);
  startg := (FromColor and $00FF00) shr 8;
  startb := (FromColor and $FF0000) shr 16;
  endr := (ToColor and $0000FF);
  endg := (ToColor and $00FF00) shr 8;
  endb := (ToColor and $FF0000) shr 16;

  diffr := endr - startr;
  diffg := endg - startg;
  diffb := endb - startb;

  rstepr := diffr / steps;
  rstepg := diffg / steps;
  rstepb := diffb / steps;

  if Direction then
    rstepw := (R.Right - R.Left) / Steps
  else
    rstepw := (R.Bottom - R.Top) / Steps;

  with Canvas do
  begin
    for i := 0 to steps-1 do
    begin
      endr := startr + Round(rstepr*i);
      endg := startg + Round(rstepg*i);
      endb := startb + Round(rstepb*i);
      stepw := Round(i*rstepw);
      Pen.Color := endr + (endg shl 8) + (endb shl 16);
      Brush.Color := Pen.Color;
      if Direction then
        Rectangle(R.Left + stepw,R.Top,R.Left + stepw + Round(rstepw)+1,R.Bottom)
      else
        Rectangle(R.Left,R.Top + stepw,R.Right,R.Top + stepw + Round(rstepw)+1);
    end;
  end;
end;

procedure DrawComboButton(Canvas: TCanvas;Handle: THandle; ARect: TRect;WinXP,Flat: Boolean);
var
  htheme: THandle;
begin
  ARect.Left := ARect.Right - 16;

  InflateRect(ARect, 0, -1);
  OffsetRect(ARect,-2,0);

  if WinXP then
  begin
    htheme := OpenThemeData(Handle,'combobox');
    DrawThemeBackground(htheme,Canvas.Handle,CP_DROPDOWNBUTTON,CBXS_NORMAL,@ARect,nil);
    CloseThemeData(htheme);
  end
  else
  begin
    DrawFrameControl(Canvas.Handle, ARect, DFC_SCROLL, DFCS_SCROLLCOMBOBOX or DFCS_FLAT);
  end;
end;


function DecodeWideStr(s:string): widestring;
var
  wc: widechar;
  wsi: Integer;

begin
  {$IFDEF DELPHI4_LVL}
  Result := '';
  if pos('|\',s) = 1 then
  begin
    delete(s,1,2);
    for wsi := 1 to length(s) div 2 do
    begin
      wc := widechar(smallint(ord(s[wsi * 2]) + 256 * ord(s[wsi * 2 - 1])));
      Result := Result + wc;
    end;
  end
  else
    Result := s;
  {$ENDIF}
end;

function EncodeWideStr(s:widestring): string;
var
  k: Integer;
  wc: widechar;
  d: string;
begin
  {$IFDEF DELPHI4_LVL}
  d := '|\'; // unicode start marker

  for k := 1 to length(s) do
  begin
    wc := s[k];
    d := d + chr(((smallint(wc) and $FF00) shr 8));
    d := d + chr(smallint(wc) and $FF);
  end;
  Result := d;
  {$ENDIF}
end;

function StrPosW(Str, SubStr: PWideChar): PWideChar;
// returns a pointer to the first occurance of SubStr in Str
asm
         PUSH EDI
         PUSH ESI
         PUSH EBX
         OR EAX, EAX
         JZ @@2
         OR EDX, EDX
         JZ @@2
         MOV EBX, EAX
         MOV EDI, EDX
         XOR AX, AX
         MOV ECX, 0FFFFFFFFH
         REPNE SCASW
         NOT ECX
         DEC ECX
         JZ @@2
         MOV ESI, ECX
         MOV EDI, EBX
         MOV ECX, 0FFFFFFFFH
         REPNE SCASW
         NOT ECX
         SUB ECX, ESI
         JBE @@2
         MOV EDI, EBX
         LEA EBX, [ESI - 1] // Note: 2 would be wrong here, we are dealing with numbers not an address
@@1:     MOV ESI, EDX
         LODSW
         REPNE SCASW
         JNE @@2
         MOV EAX, ECX
         PUSH EDI
         MOV ECX, EBX
         REPE CMPSW
         POP EDI
         MOV ECX, EAX
         JNE @@1
         LEA EAX, [EDI - 2]
         JMP @@3

@@2:     XOR EAX, EAX
@@3:     POP EBX
         POP ESI
         POP EDI
end;

function StrPosWide(SubStr, Str: widestring): integer;
var
  wc: PWideChar;
begin
  wc := StrPosW(PWideChar(Str), PWideChar(SubStr));
  if (wc <> nil) then
    Result := 1 + (integer(wc) - integer(PWideChar(Str))) div 2
  else
    Result := 0;

end;


begin
end.
