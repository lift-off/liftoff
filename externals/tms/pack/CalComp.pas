{********************************************************************
CALCOMP component
for Delphi 1.0,2.0,3.0,4.0,5.0 & C++Builder 1,3,4
version 2.1    

written by TMS Software
           copyright © 1998-1999
           Email : info@tmssoftware.com
           Website : http://www.tmssoftware.com

The source code is given as is. The author is not responsible
for any possible damage done due to the use of this code.
The component can be freely used in any application. The source
code remains property of the writer and may not be distributed
freely as such.
********************************************************************}

{$IFDEF VER110}
 {$ObjExportAll On}
{$ENDIF}

{$IFDEF VER125}
 {$ObjExportAll On}
{$ENDIF}

unit CalComp;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Moneycal;


type
   TShowMethod  = (smTop,smBottom,smDependent);
   TStartDay = (sdSunday, sdMonday, sdTuesday, sdWednesday, sdThursday, sdFriday, sdSaturday);

type
  TYearStartAt = class(TPersistent)
  private
    FStartDay:integer;
    FStartMonth:integer;
    procedure SetStartDay(d:integer);
    procedure SetStartMonth(m:integer);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property StartDay: integer read FStartDay write SetStartDay;
    property StartMonth: integer read FStartMonth write SetStartMonth;
  end;

  TNameofDays = class(TPersistent)
  private
    FMonday: TDayStr;
    FTuesday: TDayStr;
    FWednesday: TDayStr;
    FThursday: TDayStr;
    FFriday: TDayStr;
    FSaturday: TDayStr;
    FSunday: TDayStr;
  protected
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Monday: TDayStr read FMonday write FMonday;
    property Tuesday: TDayStr read FTuesday write FTuesday;
    property Wednesday: TDayStr read FWednesday write FWednesday;
    property Thursday: TDayStr read FThursday write FThursday;
    property Friday: TDayStr read FFriday write FFriday;
    property Saturday: TDayStr read FSaturday write FSaturday;
    property Sunday: TDayStr read FSunday write FSunday;
  end;

  TNameofMonths = class(TPersistent)
  private
    FJanuary: TMonthStr;
    FFebruary: TMonthStr;
    FMarch: TMonthStr;
    FApril: TMonthStr;
    FMay: TMonthStr;
    FJune: TMonthStr;
    FJuly: TMonthStr;
    FAugust: TMonthStr;
    FSeptember: TMonthStr;
    FOctober: TMonthStr;
    FNovember: TMonthStr;
    FDecember: TMonthStr;
  protected
  public
    constructor Create;
    destructor Destroy; override;
  published
    property January: TMonthStr read FJanuary write FJanuary;
    property February: TMonthStr read FFebruary write FFebruary;
    property March: TMonthStr read FMarch write FMarch;
    property April: TMonthStr read FApril write FApril;
    property May: TMonthStr read FMay write FMay;
    property June: TMonthStr read FJune write FJune;
    property July: TMonthStr read FJuly write FJuly;
    property August: TMonthStr read FAugust write FAugust;
    property September: TMonthStr read FSeptember write FSeptember;
    property October: TMonthStr read FOctober write FOctober;
    property November: TMonthStr read FNovember write FNovember;
    property December: TMonthStr read FDecember write FDecember;
  end;


  TCalComp = class(TComponent)
  private
    CalForm:tCalForm;
    FDay,FMonth,FYear:word;
    FTop,FLeft:word;
    FAlignControl:TWinControl;
    FShowMethod:tShowMethod;
    {
    FStartofWeek:word;
    }
    FFont:tFont;
    FColor:tColor;
    FTextColor:tColor;
    FSelectColor:tColor;
    FInversColor:tColor;
    FWeekendColor:tColor;
    FNameofDays:tNameofDays;
    FNameofMonths:tNameofMonths;
    FShowWeeks:boolean;
    FFirstday:tStartDay;
    FYearStartAt:TYearStartAt;
    FSelDateFrom:tdatetime;
    FSelDateTo:tdatetime;
    procedure SetAlignControl(aControl:TWincontrol);
    function GetWeek:word;
    {
    procedure SetStartofWeek(aday:word);
    }
    function GetSelDate:tdatetime;
    procedure SetSelDate(adate:tdatetime);
    procedure SetFont(value:tFont);
  protected
    procedure Notification(AComponent:TComponent;Operation:TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    property Week:word read GetWeek;
    property SelDate :tdatetime read GetSelDate write SetSelDate;
    property SelDateFrom:tdatetime read FSelDateFrom write FSelDateFrom;
    property SelDateTo:tdatetime read FSelDateTo write FSelDateTo;
  published
    property Day: word read FDay write FDay default 1;
    property Month: word read FMonth write FMonth default 1;
    property Year: word read FYear write FYear default 1;
    property CalTop:word read FTop write FTop;
    property CalLeft:word read FLeft write FLeft;
    property Color:tColor read FColor write FColor;
    property TextColor:tColor read FTextColor write FTextColor;
    property SelectColor:tColor read FSelectColor write FSelectColor;
    property InversColor:tColor read FInversColor write FInversColor;
    property WeekendColor:tColor read FWeekendColor write FWeekendColor;
    property Font:tFont read fFont write SetFont;
    {
    property Startofweek:word read fStartofWeek write fStartofweek;
    }
    property AlignControl:TWinControl read FAlignControl write SetAlignControl;
    property ShowMethod:TShowMethod read FShowMethod write FShowMethod;
    property NameofDays: TNameofDays read FNameofDays write FNameofDays;
    property NameofMonths: TNameofMonths read FNameofMonths write FNameofMonths;
    property ShowWeeks: boolean read FShowWeeks write FShowWeeks;
    property Firstday:TStartDay read fFirstDay write fFirstDay;
    property YearStartAt:TYearStartAt read FYearStartAt write FYearStartAt;
  end;

implementation

constructor TYearStartAt.Create;
begin
 inherited Create;
 FStartDay:=1;
 FStartMonth:=1;
end;

destructor TYearStartAt.Destroy;
begin
 inherited Destroy;
end;

procedure TYearStartAt.SetStartDay(d:integer);
begin
 if (d<=0) or (d>31) then
   begin
    messagedlg('Invalid day. Should be in [1..31]',mtError,[mbOK],0);
    exit;
   end;
 FStartDay:=d;
end;

procedure TYearStartAt.SetStartMonth(m:integer);
begin
 if (m<=0) or (m>12) then
   begin
    messagedlg('Invalid month. Should be in [1..12]',mtError,[mbOK],0);
    exit;
   end;
 FStartMonth:=m;
end;

constructor TNameofDays.Create;
begin
  inherited Create;
  FSunday := ShortDayNames[1];
  FMonday := ShortDayNames[2];
  FTuesday := ShortDayNames[3];
  FWednesday := ShortDayNames[4];
  FThursday := ShortDayNames[5];
  FFriday := ShortDayNames[6];
  FSaturday := ShortDayNames[7];
end;

destructor TNameofDays.Destroy;
begin
 inherited Destroy;
end;

constructor TNameofMonths.Create;
begin
 inherited Create;
 FJanuary := Shortmonthnames[1];
 FFebruary := Shortmonthnames[2];
 FMarch := Shortmonthnames[3];
 FApril := Shortmonthnames[4];
 FMay := Shortmonthnames[5];
 FJune := Shortmonthnames[6];
 FJuly := Shortmonthnames[7];
 FAugust := Shortmonthnames[8];
 FSeptember := Shortmonthnames[9];
 FOctober := Shortmonthnames[10];
 FNovember := Shortmonthnames[11];
 FDecember := Shortmonthnames[12];
end;

destructor TNameofMonths.Destroy;
begin
 inherited Destroy;
end;


constructor TCalComp.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 FNameofDays:=TNameofDays.Create;
 FNameofMonths:=TNameofMonths.Create;
 FYearStartAt:=TYearStartAt.Create;
 decodedate(now,fyear,fmonth,fday);
 fFirstDay:=sdSunday;
 FColor:=clBtnFace;
 FTextColor:=clBlack;
 FInversColor:=clWhite;
 FSelectColor:=clHighlight;
 FWeekendColor:=clBlack;
 FSelDateFrom:=-1;
 FSelDateTo:=-1;
 FFont:=tFont.Create;
end;

destructor TCalComp.Destroy;
begin
 FNameofDays.Destroy;
 FNameofMonths.Destroy;
 FYearStartAt.Destroy;
 FFont.Destroy;
 inherited Destroy;
end;
{
procedure TCalComp.Setstartofweek(aday:TStartDay);
begin
 fStartofweek:=aday;
 if (fStartOfWeek<1) then fStartofweek:=1;
 if (fStartOfWeek>7) then fStartofweek:=7;
end;
}
procedure TCalComp.SetAlignControl(aControl:TWinControl);
begin
 FAlignControl:=aControl;
end;

procedure TCalcomp.Notification(AComponent:TComponent;Operation:TOperation);
begin
  if Operation=opRemove then
   begin
    if AComponent=FAlignControl then FAlignControl:=NIL;
   end;
end;

function TCalComp.GetWeek:word;
var
 days1,days2:real;
 d1,d2:tdatetime;
 firstday:integer;

begin
 d2:=encodedate(fyear,fmonth,fday);
 d1:=encodedate(fyear,1,1);
 firstday:=dayofweek(d1);
 days2:=int(d2);
 days1:=int(d1);
 days1:=(days2-days1)+(firstday-2);
 GetWeek:=(trunc(days1) div 7)+1;
end;

function TCalComp.GetSelDate:tdatetime;
begin
 result:=encodedate(Fyear,FMonth,FDay);
end;

procedure TCalComp.SetFont(value:tFont);
begin
 fFont.Assign(value);
end;

procedure TCalComp.SetSelDate(adate:tdatetime);
begin
 decodedate(adate,Fyear,FMonth,FDay);
end;

function TCalComp.Execute: Boolean;
var
 pt:tpoint;
 d:tDayArray;
 m:tMonthArray;

begin
     { Create dialog in memory }
     CalForm := TCalForm.Create(Application);
     Calform.font.assign(font);

     { Set dialog strings }

     with FNameofDays do
      begin
        d[1]:=fmonday;
        d[2]:=ftuesday;
        d[3]:=fwednesday;
        d[4]:=fthursday;
        d[5]:=ffriday;
        d[6]:=fsaturday;
        d[7]:=fsunday;
        CalForm.SetNameofDays(d);
      end;
     with FNameofMonths do
      begin
        m[1]:=FJanuary;
        m[2]:=FFebruary;
        m[3]:=FMarch;
        m[4]:=FApril;
        m[5]:=FMay;
        m[6]:=FJune;
        m[7]:=FJuly;
        m[8]:=FAugust;
        m[9]:=FSeptember;
        m[10]:=FOctober;
        m[11]:=FNovember;
        m[12]:=FDecember;
        CalForm.SetNameofMonths(m);
      end;

     CalForm.SetDate(fday,fmonth,fyear);

     case fFirstday of
     sdMonday:CalForm.SetStartDay(1);
     sdTuesday:CalForm.SetStartDay(2);
     sdWednesday:CalForm.SetStartDay(3);
     sdThursday:CalForm.SetStartDay(4);
     sdFriday:CalForm.SetStartDay(5);
     sdSaturday:CalForm.SetStartDay(6);
     sdSunday:CalForm.SetStartDay(7);
     end;

     CalForm.SetColors(fTextColor,fSelectColor,fInversColor,fWeekendcolor);
     CalForm.Color:=FColor;
     CalForm.SetWeeks(FShowWeeks);
     CalForm.SetStarts(FYearStartAt.FStartDay,FYearStartAt.FStartMonth);
     CalForm.FromDate:=FSelDateFrom;
     CalForm.ToDate:=FSelDateTo;

     {to do : choose align up or down ... }
     if (FAlignControl<>nil) then
       begin
         pt.x:=Faligncontrol.left;
         pt.y:=FAlignControl.top;
         clienttoscreen(FAlignControl.Parent.handle,pt);
         CalForm.Left:=pt.x;

         case FShowMethod of
         smBottom:CalForm.Top:=pt.y+FAlignControl.Height;
         smTop:CalForm.Top:=pt.y-CalForm.height;
         smDependent:begin
                       if (pt.y+FAlignControl.height+Calform.height>getsystemmetrics(SM_CYSCREEN))
                        then
                         CalForm.top:=pt.y-CalForm.height
                       else
                         CalForm.top:=pt.y+FAlignControl.Height;
                     end;
         end; {end of case}
       end
     else
       begin
        CalForm.top:=FTop;
        CalForm.left:=FLeft;
       end;

     try
       execute:=(CalForm.ShowModal=mrOK);
       CalForm.GetDate(fday,fmonth,fyear);
     finally
       CalForm.Free;
     end;
end;

end.

