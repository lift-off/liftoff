object frmEnterAuslegung: TfrmEnterAuslegung
  Left = 716
  Top = 169
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Experteneinstellungen'
  ClientHeight = 110
  ClientWidth = 246
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
  object Label5: TLabel
    Left = 8
    Top = 12
    Width = 143
    Height = 13
    Caption = 'Maximaler Auftriebsbeiwert ca:'
  end
  object Label7: TLabel
    Left = 8
    Top = 36
    Width = 156
    Height = 13
    Caption = 'Maximale Fluggeschwindigkeit V:'
  end
  object edCa: TEdit
    Left = 176
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    OnChange = edCaChange
  end
  object edV: TEdit
    Left = 176
    Top = 32
    Width = 57
    Height = 21
    TabOrder = 1
    OnChange = edCaChange
  end
  object btnOk: TButton
    Left = 42
    Top = 70
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 122
    Top = 70
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object translator: TidTranslator
    DataProvider = dmMain.idTranslationProvider
    Left = 8
    Top = 72
  end
end
