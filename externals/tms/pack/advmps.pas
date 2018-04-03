{***************************************************************************}
{ TAdvMemo styler component                                                 }
{ for Delphi & C++Builder                                                   }
{ version 1.0                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2002 - 2003                                        }
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

unit Advmps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,math, AdvMemo;

type
  TAdvPascalMemoStyler=class(TAdvCustomMemoStyler)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property BlockStart;
    property BlockEnd;
    property LineComment;
    property MultiCommentLeft;
    property MultiCommentRight;
    property CommentStyle;
    property NumberStyle;
    property AllStyles;
    property AutoCompletion;
    property HintParameter;
    property HexIdentifier;
  end;


implementation

{ TAdvPascalMemoStyler }
constructor TAdvPascalMemoStyler.Create(AOwner: TComponent);
var
  itm:TElementStyle;
begin
  inherited;
  LineComment := '//';
  MultiCommentLeft := '{';
  MultiCommentRight := '}';
  CommentStyle.TextColor := clNavy;
  CommentStyle.BkColor := clWhite;
  CommentStyle.Style := [fsItalic];
  NumberStyle.TextColor := clFuchsia;
  NumberStyle.BkColor := clWhite;
  NumberStyle.Style := [fsBold];
  BlockStart := 'begin';
  BlockEnd := 'end';
  HexIdentifier := '$';
  //------------Pascal Standard Default-------------
  itm := AllStyles.Add;
  itm.Info := 'Pascal Standard Default';
  itm.Font.Color := clGreen;
  itm.Font.Style := [fsBold];
  with itm.KeyWords do
  begin
    Add('UNIT');
    Add('INTERFACE');
    Add('IMPLEMENTATION');
    Add('USES');
    Add('CONST');
    Add('PROGRAM');
    Add('PRIVATE');
    Add('PUBLIC');
    Add('PUBLISHED');
    Add('PROTECTED');
    Add('PROPERTY');
    Add('FUNCTION');
    Add('FINALISE');
    Add('INITIALISE');
    Add('VAR');
    Add('BEGIN');
    Add('WITH');
    Add('END');
    Add('FOR');
    Add('TO');
    Add('DO');
    Add('NOT');
    Add('IF');
    Add('THEN');
    Add('ELSE');
    Add('CLASS');
    Add('TYPE');
    Add('WHILE');
    Add('REPEAT');
    Add('UNTIL');
    Add('BREAK');
    Add('CONTINUE');
    Add('VIRTUAL');
    Add('OVERRIDE');
    Add('DEFAULT');
    Add('CLASS');
    Add('STORED');
    Add('INHERITED');
    Add('PROCEDURE');
    Add('CONSTRUCTOR');
    Add('DESTRUCTOR');
  end;
  
  //------------Simple Quote ' '----------------
  itm := AllStyles.Add;
  itm.StyleType := stBracket;
  itm.Info := 'Simple Quote';
  itm.Font.Color := clBlue;
  itm.Font.Style := [];
  itm.Bracket := #39;
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
  itm.Font.Color := clred;
  itm.Font.Style := [];
  itm.Symbols := #32+',;:.(){}[]=-*/^%<>#'+#13+#10;


  with HintParameter.Parameters do
  begin
    Add('ShowMessage(const Msg: string);');
    Add('MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer);');
  end;

  with AutoCompletion do
  begin
    Add('ShowMessage');
    Add('MessageDlg');
  end;

end;


end.



