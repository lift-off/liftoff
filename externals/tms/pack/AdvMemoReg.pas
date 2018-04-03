{***************************************************************************}
{ TAdvMemo component                                                        }
{ for Delphi & C++Builder                                                   }
{ version 1.3                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2001 - 2003                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of TMS software.                                    }
{***************************************************************************}

unit AdvMemoReg;

interface

{$I TMSDEFS.INC}

uses
  Classes, AdvMemo, AdvMCSS, AdvmPs, AdvmBS, AdvmWS, AdvmSQLs, AdvMemoDE
  {$IFNDEF TMSPERSONAL}
  , DBAdvMemo
  {$ENDIF}
  {$IFDEF DELPHI6_LVL}
  , DesignIntf, DesignEditors
  {$ELSE}
  , DsgnIntf
  {$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Memo', [TAdvMemo,
{$IFNDEF TMSPERSONAL}
                                  TDBAdvMemo,
{$ENDIF}
                                  TAdvHTMLMemoStyler,
                                  TAdvJSMemoStyler,
                                  TAdvWebMemoStyler,
                                  TAdvPascalMemoStyler,
                                  TAdvBasicMemoStyler,
                                  TAdvCSSMemoStyler,
                                  TAdvSQLMemoStyler,
                                  TAdvMemoFindDialog,
                                  TAdvMemoFindReplaceDialog]);

  RegisterPropertyEditor(TypeInfo(TAdvMemoStrings),TAdvMemo,'Lines',TAdvMemoProperty);
  RegisterComponentEditor(TAdvMemo,TAdvMemoEditor);  
end;

end.
