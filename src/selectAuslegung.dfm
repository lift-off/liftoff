object frmSelectAuslegung: TfrmSelectAuslegung
  Left = 444
  Top = 128
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Auslegung w'#228'hlen'
  ClientHeight = 180
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lvAuslegung: TListView
    Left = 0
    Top = 0
    Width = 318
    Height = 143
    Align = alClient
    Columns = <
      item
        Caption = 'Bezeichnung'
        Width = 170
      end
      item
        Caption = 'Ca'
      end
      item
        Caption = 'Vmax'
        Width = 80
      end>
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvAuslegungClick
    OnDblClick = lvAuslegungDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 143
    Width = 318
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOk: TButton
      Left = 154
      Top = 6
      Width = 75
      Height = 25
      Caption = '&Ok'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 234
      Top = 6
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object translator: TidTranslator
    DataProvider = dmMain.idTranslationProvider
    OnTranslate = translatorTranslate
    Left = 32
    Top = 136
  end
end
