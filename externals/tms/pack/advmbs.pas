{***************************************************************************}
{ TAdvMemo styler component                                                 }
{ for Delphi & C++Builder                                                   }
{ version 1.0                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2002                                               }
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

unit advmbs;

interface
{DISABLED $DEFINE TMSDEBUG}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,math, AdvMemo;

type
  TAdvBasicMemoStyler=class(TAdvCustomMemoStyler)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property LineComment;
    property MultiCommentLeft;
    property MultiCommentRight;
    property CommentStyle;
    property NumberStyle;
    property AllStyles;
    property HexIdentifier;
    property AutoCompletion;
    property HintParameter;
  end;

implementation

{ TAdvBasicMemoStyler }
constructor TAdvBasicMemoStyler.Create(AOwner: TComponent);
var
  itm:TElementStyle;
begin
  inherited;
  LineComment := #39;
  MultiCommentLeft := '{';
  MultiCommentRight := '}';
  CommentStyle.TextColor := clNavy;
  CommentStyle.BkColor := clWhite;
  CommentStyle.Style := [fsItalic];
  NumberStyle.TextColor := clFuchsia;
  NumberStyle.BkColor := clWhite;
  NumberStyle.Style := [fsBold];
  HexIdentifier := '0x';
  //------------Pascal Standard Default-------------
  itm:=AllStyles.Add;
  itm.Info:='Basic Standard Default';
  itm.Font.Color:=clGreen;
  itm.Font.Style:=[];
  with itm.KeyWords do
    begin
      add('ALIAS');
      add('ALL');
      add('AND');
      add('AS');
      add('ATTACH');
      add('AUTO');
      add('AUTOX');
      add('CASE');
      add('CFUNCTION');
      add('CLEAR');
      add('DCOMPLEX');
      add('DEC');
      add('DECLARE');
      add('DEFAULT');
      add('DIM');
      add('DO');
      add('DOUBLE');
      add('EACH');
      add('ELSE');
      add('ELSEIF');
      add('END');
      add('ENDIF');
      add('ERROR');
      add('EXIT');
      add('EXPLICIT');
      add('EXPORT');
      add('EXTERNAL');
      add('FALSE');
      add('FOR');
      add('FOR NEXT');
      add('FUNCADDR');
      add('FUNCTION');
      add('GIANT');
      add('GOADDR');
      add('GOSUB');
      add('GOTO');
      add('IF');
      add('IFF');
      add('IFT');
      add('IFZ');
      add('IMPORT');
      add('IN');
      add('INC');
      add('INTERNAL');
      add('IS');
      add('LIBRARYS');
      add('LOOP');
      add('MOD');
      add('MODULE');
      add('NEXT');
      add('NEW');
      add('NOT');
      add('NOTHING');
      add('OFF');
      add('ON');
      add('OPTION');
      add('OR');
      add('PRINT');
      add('PROGRAM');
      add('PROTECTED');
      add('PUBLIC');
      add('QUIT');
      add('READ');
      add('REDIM');
      add('RETURN');
      add('SBYTE');
      add('SCOMPLEX');
      add('SELECT');
      add('SHARED');
      add('SFUNCTION');
      add('SHARED');
      add('SINGLE');
      add('SLONG');
      add('SSHORT');
      add('STATIC');
      add('STEP');
      add('STOP');
      add('STRING');
      add('SUB');
      add('SUBADDR');
      add('SWAP');
      add('THEN');
      add('TO');
      add('TRUE');
      add('TYPE');
      add('TYPEOF');
      add('UBYTE');
      add('ULONG');
      add('UNION');
      add('UNTIL');
      add('USHORT');
      add('VERSION');
      add('VOID');
      add('WHEN');
      add('WHILE');
      add('WRITE');
      add('XLONG');
      add('XOR');
    end;

  //------------Double Quote " "----------------
  itm := AllStyles.Add;
  itm.StyleType := stBracket;
  itm.Info := 'Double Quote';
  itm.Font.Color := clBlue;
  itm.Font.Style := [];
  itm.Bracket := '"';
  //----------SYMBOL --------------
  itm := AllStyles.Add;
  itm.StyleType := stSymbol;
  itm.Info := 'Symbols Delimiters';
  itm.Font.Color := clTeal;
  itm.Font.Style := [];
  itm.Symbols := #32+',;:.(){}[]=-*/^%<>#'+#13+#10;

  with AutoCompletion do
  begin
    Add('ShowMessage');
    Add('MessageDlg');
  end;

  HintParameter.HintCharDelimiter := ';';
  HintParameter.HintCharWriteDelimiter := ',';

  with HintParameter.Parameters do
  begin
    Add('ShowMessage(string Msg)');
    Add('MessageDlg(string Msg; TMsgDlgType DlgType; TMsgDlgButtons Buttons; LongInt: HelpCtx)');
  end;

  
end;


end.



