{********************************************************************
TPICKDLG component
for Delphi 1.0,2.0, 3.0, 4.0, 5.0 & C++Builder 1.0, 3.0, 4.0
version 1.1

written by TMS Software
           copyright © 1998-1999
           Email : info@tmssoftware.com
           Web : http://www.tmssoftware.com
{********************************************************************}
unit pdlgreg;

interface
{$I TMSDEFS.INC}
uses
  Pickdlg, Classes,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


type


 TPickDialogEditor = class(TComponentEditor)
                      public
                        function GetVerb(index:integer):string; override;
                        function GetVerbCount:integer; override;
                        procedure ExecuteVerb(Index:integer); override;
                      end;

                     
procedure Register;

implementation

{ TPickDialogEditor }

procedure TPickDialogEditor.ExecuteVerb(Index: integer);
begin
 (component as TPickDialog).execute;
end;

function TPickDialogEditor.GetVerb(index: integer): string;
begin
 result:='&Show dialog';
end;

function TPickDialogEditor.GetVerbCount: integer;
begin
 result:=1;
end;

procedure Register;
begin
 RegisterComponents('TMS',[TPickDialog]);
 RegisterComponentEditor(TPickDialog,TPickDialogEditor);
end;

end.
 
