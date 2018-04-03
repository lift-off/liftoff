{$I TMSDEFS.INC}
{***********************************************************************}
{ TDBPlanner component                                                  }
{ for Delphi 4.0,5.0,6.0 & C++Builder 4.0,5.0,6.0                       }
{                                                                       }
{ written by                                                            }
{    TMS Software                                                       }
{    copyright © 2001 - 2002                                            }
{    Email : info@tmssoftware.com                                       }
{    Web : http://www.tmssoftware.com                                   }
{                                                                       }
{***********************************************************************}

unit DBPlanReg;

interface
uses
  DBPlanner, Classes, DBPlanDE,

{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Planner', [TDBPlanner]);
  RegisterComponents('TMS Planner', [TDBDaySource]);
  RegisterComponents('TMS Planner', [TDBPeriodSource]);
  RegisterComponents('TMS Planner', [TDBMonthSource]);
  RegisterComponents('TMS Planner', [TDBWeekSource]);
  RegisterComponents('TMS Planner', [TDBMultiMonthSource]);
  RegisterComponents('TMS Planner', [TDBTimeLineSource]);
  RegisterComponents('TMS Planner', [TDBHalfDayPeriodSource]);

  RegisterPropertyEditor(TypeInfo(string),TDBItemSource,'StartTimeField',TPlannerFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TDBItemSource,'EndTimeField',TPlannerFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TDBItemSource,'KeyField',TPlannerFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TDBItemSource,'NotesField',TPlannerFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TDBItemSource,'SubjectField',TPlannerFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TDBItemSource,'ResourceField',TPlannerFieldNameProperty);

end;

end.
