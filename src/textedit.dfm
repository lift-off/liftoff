object frmTextEdit: TfrmTextEdit
  Left = 487
  Top = 106
  Width = 418
  Height = 384
  BorderStyle = bsSizeToolWin
  Caption = 'Modellbeschreibung'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 312
    Width = 410
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    Color = clWhite
    TabOrder = 0
    object Shape1: TShape
      Left = 2
      Top = 2
      Width = 406
      Height = 1
      Align = alTop
      Pen.Color = clSilver
    end
    object btnOk: TButton
      Left = 8
      Top = 10
      Width = 75
      Height = 25
      Caption = '&Ok'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 88
      Top = 10
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Ab&brechen'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 410
    Height = 312
    Align = alClient
    BorderStyle = bsNone
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object translator: TidTranslator
    DataProvider = dmMain.idTranslationProvider
    Left = 184
    Top = 304
  end
end
