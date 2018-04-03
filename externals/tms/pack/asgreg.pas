{*********************************************************************}
{ TADVSTRINGGRID component                                            }
{ for Delphi & C++Builder                                             }
{ version 2.5.x.x                                                     }
{                                                                     }
{ written by TMS Software                                             }
{            copyright © 1996-2003                                    }
{            Email : info@tmssoftware.com                             }
{            Web : http://www.tmssoftware.com                         }
{*********************************************************************}

unit ASGReg;

interface
{$I TMSDEFS.INC}

uses
  Classes, Advgrid, BaseGrid, AsgCheck, AsgMemo,
  AsgReplaceDialog, AsgFindDialog, AsgPrev, AsgPrint, AsgHTML, FrmCtrlLink;

{$R ASGREG.RES}  

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Grids', [TAdvStringGrid]);
  RegisterComponents('TMS Grids', [TCapitalCheck]);
  RegisterComponents('TMS Grids', [TMemoEditLink]);
  RegisterComponents('TMS Grids', [TAdvGridUndoRedo]);
  RegisterComponents('TMS Grids', [TAdvGridReplaceDialog]);
  RegisterComponents('TMS Grids', [TAdvGridFindDialog]);
  RegisterComponents('TMS Grids', [TAdvPreviewDialog]);
  RegisterComponents('TMS Grids', [TAdvGridPrintSettingsDialog]);
  RegisterComponents('TMS Grids', [TAdvGridHTMLSettingsDialog]);
  RegisterComponents('TMS Grids', [TFormControlEditLink]);      
end;

end.

