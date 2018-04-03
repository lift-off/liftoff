{**************************************************************************}
{ TSECTIONLISTBOX component                                                }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3,4,5                            }
{ version 1.9, Aug 2001                                                    }
{                                                                          }
{ Copyright © 1998-2001                                                    }
{   TMS Software                                                           }
{   Email : info@tmssoftware.com                                           }
{   Web : http://www.tmssoftware.com                                       }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit slstreg;

interface
{$I TMSDEFS.INC}
uses
  SLstBox, SLstDE, Classes,
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
  RegisterComponents('TMS', [TSectionListBox]);
  RegisterComponentEditor(TSectionListBox, TSectionListBoxEditor);
end;


end.
