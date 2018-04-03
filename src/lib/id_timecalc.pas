{----------------------------------------------------
  Unit:     iDev Time Calculations
  Autor:    Marc Dürst
  Purpose:  Do misc. time- and date calculations.
  Rev.:     -
 ----------------------------------------------------}
unit id_timecalc;

interface

var
  tcSecFac      : double; // Seconds-Factor
  tcMinFac      : double; // Minutes-Factor
  tcHourFac     : double; // Hour-Factor

function AddSecs(Time : TDateTime; Secs : double) : TDateTime; // Add SECS seconds to TIME
function AddMins(Time : TDateTime; Mins : double) : TDateTime; // Add MINS minutes to TIME
function AddHours(Time : TDateTime; Hours : double) : TDateTime; // Add HOURS hours to TIME

{ Liefert True, wenn AOldTime + ASecCount älter (kleiner) ist, als ANewTime }
function IsLaterThan( AOldTime, ANewTime: TDateTime; ASecCount: double ): boolean;

implementation

function AddSecs(Time : TDateTime; Secs : double) : TDateTime;
begin
  result := Time + (tcSecFac * Secs);
end;

function AddMins(Time : TDateTime; Mins : double) : TDateTime;
begin
  result := Time + (tcMinFac * Mins);
end;

function AddHours(Time : TDateTime; Hours : double) : TDateTime;
begin
  result := Time + (tcHourFac * Hours);
end;

function IsLaterThan( AOldTime, ANewTime: TDateTime; ASecCount: double ): boolean;
begin
  result:= AOldTime + ASecCount * tcSecFac < ANewTime;
end;

initialization
  tcHourFac    := 1 / 24;
  tcMinFac     := 1 / 24 / 60;
  tcSecFac     := 1 / 24 / 60 /60;
end.
