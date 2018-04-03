{***********************************************************************}
{ TPLANNERCALENDAR component                                            }
{ for Delphi & C++Builder                                               }
{ version 1.3                                                           }
{                                                                       }
{ written by :                                                          }
{            TMS Software                                               }
{            copyright © 1999-2003                                      }
{            Email : info@tmssoftware.com                               }
{            Website : http://www.tmssoftware.com                       }
{***********************************************************************}
unit PlannerCalReg;

interface
{$I TMSDEFS.INC}
uses
  PlannerCal, PlannerDatePicker, Classes, AdvImage, AdvImgDE
{$IFDEF DELPHI6_LVL}
  ,DesignIntf, DesignEditors
{$ELSE}
  ,DsgnIntf
{$ENDIF}
  ;

type
  TPlannerCalendarEditProperty = class(TClassProperty);

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Planner', [TPlannerCalendar]);
  RegisterPropertyEditor(TypeInfo(TAdvImage), TPlannerCalendar, 'Background', TAdvImageProperty);

  RegisterComponents('TMS Planner', [TPlannerCalendarGroup]);

  RegisterPropertyEditor(TypeInfo(TAdvImage), TPlannerCalendarGroup, 'Background', TAdvImageProperty);

  RegisterComponents('TMS Planner', [TPlannerDatePicker]);
  RegisterPropertyEditor(TypeInfo(TPlannerCalendar), TPlannerDatePicker, 'Calendar', TPlannerCalendarEditProperty);
end;



end.


