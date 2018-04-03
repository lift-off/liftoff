{***********************************************************************}
{ TDBPLANNERCALENDAR & TDBPLANNERDATEPICKER components                  }
{ for Delphi & C++Builder                                               }
{ version 1.1                                                           }
{                                                                       }
{ written by :                                                          }
{            TMS Software                                               }
{            copyright © 1999-2003                                      }
{            Email : info@tmssoftware.com                               }
{            Website : http://www.tmssoftware.com                       }
{***********************************************************************}
unit DBPlannerCalReg;

interface
{$I TMSDEFS.INC}
uses
  Classes,DBPlannerCal,DBPlannerCalDE,DBPlannerDatePicker,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;

type
  TDBPlannerCalendarEditProperty = class(TClassProperty);


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Planner', [TDBPlannerCalendar]);
  RegisterPropertyEditor(TypeInfo(string),TDBPlannerCalendar,'StartTimeField',TPlannerCalendarFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TDBPlannerCalendar,'EndTimeField',TPlannerCalendarFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TDBPlannerCalendar,'SubjectField',TPlannerCalendarFieldNameProperty);

  RegisterComponents('TMS Planner', [TDBPlannerDatePicker]);
  RegisterPropertyEditor(TypeInfo(TDBPlannerCalendar), TDBPlannerDatePicker, 'Calendar', TDBPlannerCalendarEditProperty);

  RegisterClass(TDBPlannerCalendar);
end;




end.
 