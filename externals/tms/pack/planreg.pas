{$I TMSDEFS.INC}

{***********************************************************************}
{ TPlanner component                                                    }
{ for Delphi & C++Builder                                               }
{ version 1.7, Dec 2002                                                 }
{                                                                       } 
{ written by TMS Software                                               }
{            copyright © 1999-2002                                      }
{            Email : info@tmssoftware.com                               }
{            Web : http://www.tmssoftware.com                           }
{***********************************************************************}

unit planreg;

interface

uses
  Classes, Planner, PlanDE, PlanCheck
  , PlanItemEdit, PlanSimpleEdit, PlanPeriodEdit
  {$IFDEF DELPHI5_LVL}
  , PlanDraw
  {$ENDIF}
  {$IFDEF DELPHI6_LVL}
  , DesignIntf
  {$ELSE}
  , DsgnIntf
  {$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
 RegisterComponents('TMS Planner', [TPlanner]);
 RegisterComponents('TMS Planner', [TCapitalPlannerCheck]);
 RegisterComponents('TMS Planner', [TAlarmMessage]);

 RegisterComponents('TMS Planner', [TSimpleItemEditor]);
 RegisterComponents('TMS Planner', [TDefaultItemEditor]);
 RegisterComponents('TMS Planner', [TPeriodItemEditor]);  

 {$IFDEF DELPHI5_LVL}
 RegisterComponents('TMS Planner',[TShapeDrawTool]);
 {$ENDIF}

 RegisterComponentEditor(TPlanner, TPlannerEditor);


end;



end.

