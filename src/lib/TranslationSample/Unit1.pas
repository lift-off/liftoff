unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, StdCtrls, Menus,
  idTranslator, idTranslatorDataProvider, idTranslatorDataProviderXML,
  Buttons, xmldom, XMLIntf,
  msxmldom, XMLDoc, ComCtrls, dxBar, cxRadioGroup, cxControls, cxContainer,
  cxEdit, cxCheckBox, cxGroupBox, idTranslatorDataProviderINI;

type
  TForm1 = class(TForm)
    lblLang: TLabel;
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miExit: TMenuItem;
    N1: TMenuItem;
    miNew: TMenuItem;
    PopupMenu1: TPopupMenu;
    miTest1: TMenuItem;
    N2: TMenuItem;
    miTest2: TMenuItem;
    ActionList1: TActionList;
    actTest1: TAction;
    actTest2: TAction;
    actTest3: TAction;
    Action31: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button3: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
    btnTest: TButton;
    btnShowMessage: TButton;
    cbTest1: TCheckBox;
    rb1: TRadioButton;
    rb2: TRadioButton;
    gbTest1: TGroupBox;
    rgGroup1: TRadioGroup;
    pnlTest: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    btnCasc1: TButton;
    btnCasc2: TButton;
    Button1: TButton;
    Button2: TButton;
    cxCheckBox1: TcxCheckBox;
    cxRadioButton1: TcxRadioButton;
    cxRadioButton2: TcxRadioButton;
    cxRadioGroup1: TcxRadioGroup;
    dxBarManager1: TdxBarManager;
    View: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    Translator: TidTranslator;
    TranslatorData: TidTlXMLDataProvider;
    TranslatorDataINI: TidTlINIDataProvider;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnShowMessageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
{
  FTranslationData:= TidTlXMLDataProvider.Create(self);
  FTranslationData.XMLFileName := ExtractFilePath(ParamStr(0)) + 'translation.xml';

  FTranslator:= TidTranslator.Create(self);
  FTranslator.Name := 'MyTestTranslator';
  FTranslator.DataProvider := FTranslationData;
}
  TranslatorData.XMLFileName := ExtractFilePath(ParamStr(0)) + 'translation.xml';
  TranslatorDataINI.INIFileName := ExtractFilePath(ParamStr(0)) + 'translation.lng';
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  Translator.DataProvider.Language := 'DE';
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Translator.DataProvider.Language := 'EN';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Translator.WriteDefaultTranslationData;
end;

procedure TForm1.btnShowMessageClick(Sender: TObject);
begin
  ShowMessage(Translator.GetLit('Testtext'));
end;

end.
