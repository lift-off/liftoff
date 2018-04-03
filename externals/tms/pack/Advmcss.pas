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

unit Advmcss;

interface
{DISABLED $DEFINE TMSDEBUG}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,math, AdvMemo;

type
   TAdvCSSMemoStyler=class(TAdvCustomMemoStyler)
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

{ TAdvCSSMemoStyler }
constructor TAdvCSSMemoStyler.Create(AOwner: TComponent);
var
  itm:TElementStyle;
begin
  inherited;
  LineComment := '//';
  CommentStyle.TextColor := clNavy;
  CommentStyle.BkColor := clWhite;
  CommentStyle.Style := [fsItalic];
  NumberStyle.TextColor := clFuchsia;
  NumberStyle.BkColor := clWhite;
  NumberStyle.Style := [fsBold];
  //------------CSS Standard Default-------------
  itm:=AllStyles.Add;
  itm.Info:='CSS Standard Default';
  itm.Font.Color:=clGreen;
  itm.Font.Style:=[];
  with itm.KeyWords do
    begin
      add('.H1');
      add('.H2');
      add('.H3');
      add('.H4');
      add('.H5');
      add('.BORDER');
      add('.COMMENT');
    end;
  //------------Simple Quote ' '----------------
  itm:=AllStyles.Add;
  itm.StyleType:=stBracket;
  itm.Info:='Simple Quote';
  itm.Font.Color:=clBlue;
  itm.Font.Style:=[];
  itm.Bracket:=#39;
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
