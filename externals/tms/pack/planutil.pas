{***********************************************************************}
{ TPLANNER utility functions                                            }
{ for Delphi & C++Builder                                               }
{ version 1.7, Dec 2002                                                 }
{                                                                       }
{ written by TMS Software                                               }
{            copyright © 1999-2002                                      }
{            Email: info@tmssoftware.com                                }
{            Web: http://www.tmssoftware.com                            }
{                                                                       }
{ The source code is given as is. The author is not responsible         }
{ for any possible damage done due to the use of this code.             }
{ The component can be freely used in any application. The complete     }
{ source code remains property of the author and may not be distributed,}
{ published, given or sold in any form as such. No parts of the source  }
{ code can be included in any other component or application without    }
{ written authorization of the author.                                  }
{***********************************************************************}

{$I TMSDEFS.INC}

unit planutil;

interface

uses
  Classes, Windows, Graphics, SysUtils;

type
  TArrowDirection = (adUp,adDown,adRight,adLeft);

  TVAlignment = (vtaCenter, vtaTop, vtaBottom);


  TDateTimeObject = class(TObject)
  private
    FDT: TDateTime;
  published
    property DT: TDateTime read FDT write FDT;
  end;

  TDateTimeList = class(TList)
  private
    function GetDT(index: Integer): TDateTime;
    procedure SetDT(index: Integer; const Value: TDateTime);
  public
    property Items[index: Integer]: TDateTime read GetDT write SetDT; default;
    procedure Add(Value: TDateTime);
    procedure Insert(Index: Integer; Value: TDateTime);
    procedure Delete(Index: Integer);
    {$IFDEF DELPHI4_LVL}
    procedure Clear; override;
    {$ELSE}
    procedure Clear;    
    {$ENDIF}
  end;

function DaysInMonth(mo, ye: word): word;  
function AlignToFlag(alignment:TAlignment): DWord;
function VAlignToFlag(VAlignment: TVAlignment): DWord;
procedure RectLine(canvas:TCanvas;r:TRect;Color:TColor;width:integer);
procedure RectHorz(canvas:TCanvas;r:TRect;Color,pencolor:TColor);
procedure RectVert(canvas:TCanvas;r:TRect;Color,pencolor:TColor);
procedure RectHorzEx(Canvas:TCanvas;r:TRect;Color,BKColor,PenColor1,PenColor2:TColor;PenWidth: Integer;BrushStyle: TBrushStyle);
procedure RectVertEx(Canvas:TCanvas;r:TRect;Color,BKColor,PenColor:TColor;PenWidth: Integer;BrushStyle:TBrushStyle);
procedure RectLineEx(Canvas:TCanvas;R:TRect;Color:TColor;Width:integer);
procedure RectLineExEx(Canvas:TCanvas;R:TRect;Color:TColor;Width:integer);
procedure DrawArrow(Canvas:TCanvas;Color:TColor;X,Y:Integer;ADir:TArrowDirection);

function LFToCLF(s:string):string;
function MatchStr(s1,s2:string;DoCase:Boolean): Boolean;
function HTMLStrip(s:string):string;

procedure DrawBitmapTransp(DstRect:TRect;Canvas:TCanvas;Bitmap:TBitmap;BKColor:TColor;SrcRect:TRect);
procedure DrawBumpVert(Canvas:TCanvas;r: TRect;Color: TColor);
procedure DrawBumpHorz(Canvas:TCanvas;r: TRect;Color: TColor);

procedure DrawGradient(Canvas: TCanvas; FromColor,ToColor: TColor; Steps: Integer;R:TRect; Direction: Boolean);

function BlendColor(Col1,Col2:TColor; BlendFactor:Integer): TColor;

function EndOfMonth(dt: TDateTime): TDateTime;
function NextMonth(mo: word): word;

function Limit(Value,vmin,vmax: integer): Integer;


implementation

type
  TCharSet = set of char;

function EndOfMonth(dt: TDateTime): TDateTime;
var
  da,mo,ye: word;
begin
  DecodeDate(dt,ye,mo,da);
  da := DaysInMonth(mo,ye);
  Result := EncodeDate(ye,mo,da);
end;

function NextMonth(mo: word): word;
begin
  Result := mo + 1;
  if mo = 13 then
    Result := 1;
end;

function Limit(Value,vmin,vmax: integer): Integer;
begin
  Result := Value;
  if Value < vmin then
    Result := vmin;
  if Value > vmax then
    Result := vmax;
end;


procedure DrawGradient(Canvas: TCanvas; FromColor,ToColor: TColor; Steps: Integer;R:TRect; Direction: Boolean);
var
  diffr,startr,endr: Integer;
  diffg,startg,endg: Integer;
  diffb,startb,endb: Integer;
  iend: Integer;
  rstepr,rstepg,rstepb,rstepw: Real;
  i,stepw: Word;

begin
  if Steps = 0 then
    Steps := 1;

  FromColor := ColorToRGB(FromColor);
  ToColor := ColorToRGB(ToColor);  

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
    for i := 0 to Steps - 1 do
    begin
      endr := startr + Round(rstepr*i);
      endg := startg + Round(rstepg*i);
      endb := startb + Round(rstepb*i);
      stepw := Round(i*rstepw);
      Pen.Color := endr + (endg shl 8) + (endb shl 16);
      Brush.Color := Pen.Color;
      if Direction then
      begin
        iend := R.Left + stepw + Trunc(rstepw) + 1;
        if iend > R.Right then
          iend := R.Right;
        Rectangle(R.Left + stepw,R.Top,iend,R.Bottom)
      end
      else
      begin
        iend := R.Top + stepw + Trunc(rstepw)+1;
        if iend > r.Bottom then
          iend := r.Bottom;
        Rectangle(R.Left,R.Top + stepw,R.Right,iend);
      end;  
    end;
  end;
end;


function DaysInMonth(mo, ye: word): word;
const
  ADaysInMonth: array[1..13] of word = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 29);
begin
  if mo <> 2 then
    DaysInMonth := ADaysInMonth[mo]
  else
  begin
    if (ye mod 4 = 0) then DaysInMonth := 29
    else
      DaysInMonth := 28;
    if (ye mod 100 = 0) then DaysInMonth := 28;
    if (ye mod 400 = 0) then DaysInmonth := 29;
  end;
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
  

function HTMLStrip(s:string):string;
var
  Res: string;
  i: Integer;
begin
  Res := '';
  //replace line breaks by linefeeds
  {$IFNDEF DELPHI4_LVL}
  while Pos('<br>',UpperCase(s)) > 0 do s := StringReplace(s,'<br>',chr(13)+chr(10));
  while Pos('<BR>',UpperCase(s)) > 0 do s := StringReplace(s,'<BR>',chr(13));
  while Pos('<hr>',UpperCase(s)) > 0 do s := StringReplace(s,'<hr>',chr(13));
  while Pos('<HR>',UpperCase(s)) > 0 do s := StringReplace(s,'<HR>',chr(13));
  {$ELSE}
  while Pos('<BR>',UpperCase(s)) > 0 do s := StringReplace(s,'<BR>',chr(13)+chr(10),[rfIgnoreCase]);
  while Pos('<HR>',UpperCase(s)) > 0 do s := StringReplace(s,'<HR>',chr(13)+chr(10),[rfIgnoreCase]);
  {$ENDIF}

  {remove all other tags}
  while Pos('<',s) > 0 do
  begin
    i := Pos('<',s);
    Res := Res + Copy(s,1,i-1);
    if Pos('>',s) > 0 then
      Delete(s,1,Pos('>',s));
  end;

  Result := Res + s;
end;


function AlignToFlag(Alignment:TAlignment): DWord;
begin
  case Alignment of
  taLeftJustify:Result := DT_LEFT;
  taRightJustify:Result := DT_RIGHT;
  taCenter:Result := DT_CENTER;
  else Result := DT_LEFT;
  end;
end;

function VAlignToFlag(VAlignment: TVAlignment): DWord;
begin
  case VAlignment of
    vtaTop: Result := DT_TOP;
    vtaCenter: Result := DT_VCENTER;
    vtaBottom: Result := DT_BOTTOM;
  else
    Result := DT_TOP;
  end;
end;

procedure RectLine(Canvas:TCanvas;R:TRect;Color:TColor;Width:integer);
begin
  if Color=clNone then Exit;
  Canvas.Pen.Color := Color;
  Canvas.Pen.Width := Width;
  Canvas.MoveTo(r.Left,r.Top);
  Canvas.LineTo(r.Right,r.Top);
  Canvas.LineTo(r.Right,r.Bottom);
  Canvas.LineTo(r.Left,r.Bottom);
  Canvas.LineTo(r.Left,r.Top);
end;

procedure RectLineEx(Canvas:TCanvas;R:TRect;Color:TColor;Width:integer);
begin
  if Color=clNone then Exit;
  Canvas.Pen.Color := Color;
  Canvas.Pen.Width := Width;
  Canvas.MoveTo(r.Left,r.Top);
  Canvas.LineTo(r.Right,r.Top);
  Canvas.LineTo(r.Right,r.Bottom);
  Canvas.MoveTo(r.Left,r.Bottom);
  Canvas.LineTo(r.Left,r.Top);
end;

procedure RectLineExEx(Canvas:TCanvas;R:TRect;Color:TColor;Width:integer);
begin
  if Color = clNone then Exit;
  Canvas.Pen.Color := Color;
  Canvas.Pen.Width := Width;
  Canvas.MoveTo(r.Left,r.Top);
  Canvas.LineTo(r.Right,r.Top);
  Canvas.MoveTo(r.Right,r.Bottom);
  Canvas.LineTo(r.Left,r.Bottom);
  Canvas.LineTo(r.Left,r.Top);
end;

procedure RectHorz(Canvas:TCanvas;r:TRect;Color,PenColor:TColor);
begin
  Canvas.Brush.Color := Color;
  Canvas.Pen.Color := Color;
  Canvas.FillRect(r);
  if PenColor = clNone then
    Exit;
  Canvas.Pen.Color := PenColor;
  Canvas.MoveTo(r.left,r.top-1);
  Canvas.LineTo(r.right,r.top-1);
  Canvas.MoveTo(r.left,r.bottom-1);
  Canvas.LineTo(r.right,r.bottom-1);
end;

procedure RectHorzEx(Canvas:TCanvas;r:TRect;Color,BKColor,PenColor1,PenColor2:TColor;PenWidth: Integer;BrushStyle:TBrushStyle);
begin
  if Color <> clNone then
  begin
    Canvas.Brush.Color := Color;

    if BrushStyle <> bsSolid then
    begin
      Canvas.Brush.Style := BrushStyle;
      SetBkMode(Canvas.Handle,TRANSPARENT);
      SetBkColor(Canvas.Handle,ColorToRGB(BkColor));
    end;

    Canvas.Pen.Color := Color;
    Canvas.Pen.Width := 1;
    Canvas.FillRect(r);
  end;

  if PenColor1 = clNone then Exit;

  {
  Canvas.Pen.Color := PenColor1;
  Canvas.Pen.Width := 1;
  Canvas.MoveTo(r.Left,r.Top);
  Canvas.LineTo(r.Right,r.Top);
  }
  if PenColor2 = clNone then
    Exit;

  Canvas.Pen.Color := PenColor2;
  Canvas.Pen.Width := PenWidth;
  Canvas.MoveTo(r.Left,r.Bottom - PenWidth );
  Canvas.LineTo(r.Right,r.Bottom - PenWidth );
  Canvas.Pen.Width := 1;
end;

procedure RectVert(Canvas:TCanvas;r:TRect;Color,PenColor:TColor);
begin
  Canvas.Brush.Color := Color;
  Canvas.Pen.Color := Color;
  Canvas.FillRect(r);
  if PenColor = clNone then
    Exit;
  Canvas.Pen.Color:=PenColor;
  Canvas.MoveTo(r.Right-1,r.Top);
  Canvas.LineTo(r.Right-1,r.Bottom);
end;

procedure RectVertEx(Canvas:TCanvas;r:TRect;Color,BKColor,PenColor:TColor;PenWidth: Integer;BrushStyle: TBrushStyle);
begin
  if Color <> clNone then
  begin
    Canvas.Brush.Color := Color;
    
    if BrushStyle <> bsSolid then
    begin
      Canvas.Brush.Style := BrushStyle;
      SetBkMode(Canvas.Handle,TRANSPARENT);
      SetBkColor(Canvas.Handle,ColorToRGB(BkColor));
    end;

    Canvas.Pen.Color := Color;
    Canvas.FillRect(r);
  end;  
  if PenColor = clNone then Exit;
  Canvas.Pen.Color := PenColor;
  Canvas.Pen.Width := PenWidth;
  Canvas.MoveTo(r.Right - 1 ,r.Top);
  Canvas.LineTo(r.Right - 1,r.Bottom);
  Canvas.Pen.Width := 1;
end;


function LFToCLF(s:string):string;
var
  res: string;
  i: Integer;
begin
  res := '';
  for i := 1 to length(s) do
  begin
    if s[i] = #13 then
      res := res+'\n'
    else
      if s[i] <> #10 then
        res := res + s[i];
  end;
  Result := res;
end;


procedure DrawArrow(Canvas:TCanvas;Color:TColor;X,Y:Integer;ADir:TArrowDirection);
begin
  with Canvas do
  begin
    Pen.Width := 2;
    Pen.Color := Color;

    case ADir of
    adRight:
      begin
        MoveTo(X,Y);
        LineTo(X + 3,Y + 3);
        LineTo(X,Y + 6);
        MoveTo(X + 5,Y);
        LineTo(X + 8,Y + 3);
        LineTo(X + 5,Y + 6);
      end;
    adLeft:
      begin
        MoveTo(X + 3,Y);
        LineTo(X ,Y + 3);
        LineTo(X + 3,Y + 6);
        MoveTo(X + 8,Y);
        LineTo(X + 5,Y + 3);
        LineTo(X + 8,Y + 6);
      end;
    adDown:
      begin
        MoveTo(X,Y);
        Lineto(X + 3,Y + 3);
        LineTo(X + 6,Y);
        MoveTo(X,Y + 4);
        LineTo(X + 3,Y + 7);
        LineTo(X + 6,Y + 4);
      end;
    adUp:
      begin
        MoveTo(X,Y + 3);
        LineTo(X + 3,Y);
        LineTo(X + 6,Y + 3);
        MoveTo(X,Y + 7);
        LineTo(X + 3,Y + 4);
        LineTo(X + 6,Y + 7);
      end;
    end;
  end;
end;

function VarPos(su,s:string;var Respos:Integer):Integer;
begin
  Respos := Pos(su,s);
  Result := Respos;
end;

function IsDate(s:string;var dt:TDateTime):boolean;
var
  su: string;
  da,mo,ye: word;
  err: Integer;
  dp,mp,yp,vp: Integer;
begin
  Result := False;

  su := UpperCase(ShortDateFormat);
  dp := pos('D',su);
  mp := pos('M',su);
  yp := pos('Y',su);

  da := 0;
  mo := 0;
  ye := 0;

  if VarPos(DateSeparator,s,vp) > 0 then
  begin
    su := Copy(s,1,vp - 1);

    if (dp < mp) and
       (dp < yp) then
       Val(su,da,err)
    else
    if (mp < dp) and
       (mp < yp) then
       Val(su,mo,err)
    else
    if (yp < mp) and
       (yp < dp) then
       Val(su,ye,err);

    if err <> 0 then Exit;
    Delete(s,1,vp);

    if VarPos(DateSeparator,s,vp) > 0 then
    begin
      su := Copy(s,1,vp - 1);

      if ((dp > mp) and (dp < yp)) or
         ((dp > yp) and (dp < mp)) then
         Val(su,da,err)
      else
      if ((mp > dp) and (mp < yp)) or
         ((mp > yp) and (mp < dp)) then
         val(su,mo,err)
      else
      if ((yp > mp) and (yp < dp)) or
         ((yp > dp) and (yp < mp)) then
         Val(su,ye,err);

      if err <> 0 then Exit;
      Delete(s,1,vp);

      if (dp > mp) and
         (dp > yp) then
         Val(s,da,err)
      else
      if (mp > dp) and
         (mp > yp) then
         Val(s,mo,err)
      else
      if (yp > mp) and
         (yp > dp) then
         Val(s,ye,err);

      if err <> 0 then Exit;
      if da > 31 then Exit;
      if mo > 12 then Exit;

      Result := True;

      try
        dt := EncodeDate(ye,mo,da);
      except
        Result := False;
      end;
    end;
  end;
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
  matching,done: Boolean;
  len: longint;
  s0,s1,s2,s3: PChar;
  oksmaller,oklarger,negflag: Boolean;
  compstr:array[0..255] of Char;
  flag1,flag2,flag3: Boolean;
  equal: Boolean;
  n1,n2: Double;
  code1,code2: Integer;
  dt1,dt2: TDateTime;

begin
  oksmaller := True;
  oklarger := True;
  flag1 := False;
  flag2 := False;
  flag3 := False;
  negflag := False;
  equal := False;

  { [<>] string [&|] [<>] string }

  s2 := StrPos(s0a,larger);

  if s2 <> nil then
  begin
    inc(s2);
    if (s2^='=') then
    begin
      Equal := True;
      inc(s2);
    end;

    while (s2^ = ' ') do inc(s2);

    s3 := s2;
    len := 0;
    while (s2^ <> ' ') and (s2^ <> NULL) and (s2^ <> '&') and (s2^ <> '|')  do
    begin
      inc(s2);
      inc(len);
    end;

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
         oklarger := StrLComp(compstr,s1a,255) <= 0
        else
         oklarger := StrLComp(compstr,s1a,255) < 0;
      end;
    end;
    flag1 := True;
  end;

  equal := False;
  s2 := StrPos(s0a,smaller);
  if s2 <> nil then
  begin
    inc(s2);
    if (s2^ = '=') then
    begin
      equal := True;
      inc(s2);
    end;

    while s2^ = ' ' do inc(s2);
    s3 := s2;
    len := 0;
    while (s2^ <> ' ') and (s2^ <> NULL) and (s2^ <> '&') and (s2^ <> '|') do
    begin
      inc(s2);
      inc(len);
    end;

    StrLCopy(compstr,s3,len);

    Val(s1a,n1,code1);
    Val(compstr,n2,code2);

    if (code1 = 0) and (code2 = 0) then //both are numeric types
    begin
      if equal then
        oksmaller := n1 <= n2
      else
        oksmaller := n1 < n2;
    end
    else
    begin
      //check for dates here ?}
      if IsDate(StrPas(compstr),dt2) and IsDate(StrPas(s1a),dt1) then
      begin
        if equal then
          oksmaller := dt1 <= dt2
        else
          oksmaller := dt1 < dt2;
      end
      else
      begin
        if equal then
          oksmaller := StrLComp(compstr,s1a,255) >= 0
        else
          oksmaller := StrLComp(compstr,s1a,255) > 0;
      end;
    end;
    flag2 := True;
  end;

  s2 := StrPos(s0a,negation);
  if s2 <> nil then
  begin
    inc(s2);
    while s2^ = ' ' do inc(s2);
    s3 := s2;
    len := 0;
    while (s2^ <> ' ') and (s2^ <> NULL) and (s2^ <> '&') and (s2^ <> '|') do
    begin
      inc(s2);
      inc(len);
    end;
    StrLCopy(compstr,s3,len);
    flag3 := True;
  end;

  if flag3 then
  begin
    if StrPos(s0a,larger) = nil then
      flag1 := flag3;
    if StrPos(s0a,smaller) = nil then
      flag2 := flag3;
  end;

  if StrPos(s0a,logor) <> nil then
    if flag1 or flag2 then
    begin
      Matches := oksmaller or oklarger;
      Exit;
    end;

  if StrPos(s0a,logand) <> nil then
    if flag1 and flag2 then
    begin
      Matches := oksmaller and oklarger;
      Exit;
    end;

  if ((StrPos(s0a,larger) <> nil) and oklarger) or
     ((StrPos(s0a,smaller) <> nil) and oksmaller) then
  begin
    Matches := True;
    Exit;
  end;

  s0 := s0a;
  s1 := s1a;

  matching:=True;

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
         negflag := True;
         inc(s0);
      end;
    asterix:
      begin
        repeat
          inc(s0)
        until s0^ <> asterix;
        len := StrLen(s1);
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
          s0 := StrEnd(s0);
          s1 := StrEnd(s1);
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



function MatchStr(s1,s2:string;DoCase:Boolean): Boolean;
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
  while VarPos('& ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('; ',s1,sep) > 0 do Delete(s1,sep+1,1);
  while VarPos('^ ',s1,sep) > 0 do Delete(s1,sep+1,1);

  LastOp := #0;
  Res := True;

  repeat
    ch := FirstChar([';','^','&'],s1);
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
        ';','^':Res := Res or NewRes;
        '&':Res := Res and NewRes;
        end;

      LastOp := ch;
     end;

  until ch = #0;

  if DoCase then
    NewRes := Matches(PChar(s1),PChar(s2))
  else
    NewRes := Matches(PChar(AnsiUpperCase(s1)),PChar(AnsiUpperCase(s2)));

  if LastOp = #0 then
    Res := NewRes
  else
    case LastOp of
    ';','^':Res := Res or NewRes;
    '&':Res := Res and NewRes;
    end;

  Result := Res;
end;


procedure DrawBitmapTransp(DstRect:TRect;Canvas:TCanvas;Bitmap:TBitmap;BKColor:TColor;SrcRect:TRect);
var
  tmpbmp: TBitmap;
  TgtRect: TRect;
  srcColor: TColor;
begin
  TmpBmp := TBitmap.Create;
  TmpBmp.Height := Bitmap.Height;
  TmpBmp.Width := Bitmap.Width;
  TgtRect.Left :=0;
  TgtRect.Top :=0;
  TgtRect.Right := Bitmap.Width;
  TgtRect.Bottom := Bitmap.Height;

  // r.bottom := r.top + bmp.height;
  // r.Right := r.Left + bmp.width;

  TmpBmp.Canvas.Brush.Color := BKColor;

  SrcColor := Bitmap.Canvas.Pixels[0,0];
  TmpBmp.Canvas.BrushCopy(TgtRect,Bitmap,TgtRect,srcColor);
  Canvas.CopyRect(DstRect, TmpBmp.Canvas, SrcRect);
  
  TmpBmp.Free;
end;



procedure DrawBumpVert(Canvas:TCanvas;r: TRect;Color: TColor);
var
  i,j,k: integer;
  Bump: Longint;
  BumpR,BumpG,BumpB: Longint;
begin
  Bump := ColorToRGB(Color);

  BumpR := (Bump and $FF0000) shr 17;
  BumpG := (Bump and $00FF00) shr 9;
  BumpB := (Bump and $0000FF) shr 1;

  Bump := (BumpR shl 16) + (BumpG shl 16) + BumpB;

  j := r.Top;
  k := 0;

  while j < r.Bottom do
  begin
    if odd(k) then
      i := r.Left
    else
      i := r.Left + 2;

    Canvas.Pen.Color := Bump;

    Canvas.MoveTo(i + 3,j);
    Canvas.LineTo(i + 3,j + 2);
    Canvas.LineTo(i ,j + 2);

    Canvas.Pixels[i + 1,j + 1] := clWhite;

    j := j + 8;
    inc(k);

  end;

end;

procedure DrawBumpHorz(Canvas:TCanvas;r: TRect;Color: TColor);
var
  i,j,k: integer;
  Bump: Longint;
  BumpR,BumpG,BumpB: Longint;
begin
  Bump := ColorToRGB(Color);

  BumpR := (Bump and $FF0000) shr 17;
  BumpG := (Bump and $00FF00) shr 9;
  BumpB := (Bump and $0000FF) shr 1;

  Bump := (BumpR shl 16) + (BumpG shl 16) + BumpB;

  i := r.Left;
  k := 0;

  while i < r.Right do
  begin
    if odd(k) then
      j := r.Top + 2
    else
      j := r.Top + 4;

    Canvas.Pen.Color := Bump;

    Canvas.MoveTo(i + 3,j);
    Canvas.LineTo(i + 3,j + 2);
    Canvas.LineTo(i ,j + 2);

    Canvas.Pixels[i + 1,j + 1] := clWhite;

    i := i + 8;
    inc(k);
  end;

end;




function BlendColor(Col1,Col2:TColor; BlendFactor:Integer): TColor;
var
  r1,g1,b1: Integer;
  r2,g2,b2: Integer;

begin
  if BlendFactor = 100 then
  begin
    Result := Col1;
    Exit;
  end;

  Col1 := Longint(ColorToRGB(Col1));
  r1 := GetRValue(Col1);
  g1 := GetGValue(Col1);
  b1 := GetBValue(Col1);

  Col2 := Longint(ColorToRGB(Col2));
  r2 := GetRValue(Col2);
  g2 := GetGValue(Col2);
  b2 := GetBValue(Col2);

  r1 := Round( BlendFactor/100 * r1 + (1 - BlendFactor/100) * r2);
  g1 := Round( BlendFactor/100 * g1 + (1 - BlendFactor/100) * g2);
  b1 := Round( BlendFactor/100 * b1 + (1 - BlendFactor/100) * b2);

  Result := RGB(r1,g1,b1);
end;

{ TDateTimeList }

procedure TDateTimeList.Add(Value: TDateTime);
var
  tdt: TDateTimeObject;
begin
  tdt := TDateTimeObject.Create;
  tdt.DT := Value;
  inherited Add(tdt);
end;

procedure TDateTimeList.Delete(Index: Integer);
begin
  TDateTimeObject(inherited Items[Index]).Free;
  inherited Delete(Index);
end;

function TDateTimeList.GetDT(index: Integer): TDateTime;
begin
  Result := TDateTimeObject(inherited Items[Index]).DT;
end;

procedure TDateTimeList.Insert(Index: Integer; Value: TDateTime);
var
  tdt: TDateTimeObject;
begin
  tdt := TDateTimeObject.Create;
  tdt.DT := Value;
  inherited Insert(Index,tdt);
end;

procedure TDateTimeList.Clear;
begin
  while Count > 0 do
    Delete(0);
end;

procedure TDateTimeList.SetDT(index: Integer; const Value: TDateTime);
begin
  TDateTimeObject(inherited Items[Index]).DT := Value;
end;

end.
