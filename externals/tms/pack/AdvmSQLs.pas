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

unit advmsqls;

interface
{DISABLED $DEFINE TMSDEBUG}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,math, AdvMemo;

type
   TAdvSQLMemoStyler=class(TAdvCustomMemoStyler)
   public
    constructor Create(AOwner: TComponent); override;
   published
    property    LineComment;
    property    MultiCommentLeft;
    property    MultiCommentRight;
    property    CommentStyle;
    property    NumberStyle;
    property    AllStyles;
   end;

implementation

{ TAdvBasicMemoStyler }
constructor TAdvSQLMemoStyler.Create(AOwner: TComponent);
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
  //------------Pascal Standard Default-------------
  itm := AllStyles.Add;
  itm.Info := 'SQL Standard Default';
  itm.Font.Color := clGreen;
  itm.Font.Style := [];
  with itm.KeyWords do
    begin
      Add('Proc');
      Add('Procedure');
      Add('Begin');
      Add('End');
      Add('While');
      Add('BEGIN');
      Add('END');
      Add('FOR');
      Add('TO');
      Add('DO');
      Add('NOT');
      Add('IF');
      Add('ELSE');
      Add('WHILE');
      Add('REPEAT');
      Add('UNTIL');
      Add('BREAK');
      Add('CONTINUE');
      Add('EXEC');
      Add('Insert');
      Add('Values');
      Add('Update');
      Add('From');
      Add('Delete');
      Add('Declare');
      Add('Set');
      Add('Open');
      Add('Fetch');
      Add('Close');
      Add('Deallocate');
      Add('Return');
      Add('Rollback');
      Add('Transaction');
      Add('Trans');
      Add('and');
      Add('or');
      Add('Order');
      Add('By');
      Add('Group');
      Add('Having');
      Add('Where');
      Add('Left');
      Add('Right');
      Add('Join');
      Add('Inner');
      Add('Outer');
      Add('On');
      Add('Create');
      Add('Delete');
      Add('Select');
      Add('Like');
    end;

  //------------Double Quote " "----------------
  itm:=AllStyles.Add;
  itm.StyleType:=stBracket;
  itm.Info:='Double Quote';
  itm.Font.Color:=clBlue;
  itm.Font.Style:=[];
  itm.Bracket:='"';
  //----------SYMBOL --------------
  itm:=AllStyles.Add;
  itm.StyleType:=stSymbol;
  itm.Info:='Symbols Delimiters';
  itm.Font.Color:=clTeal;
  itm.Font.Style:=[];
  itm.Symbols:= #32+',;:.(){}[]=-*/^%<>#'+#13+#10;
end;


end.



