object frmIdWebupdateDownload: TfrmIdWebupdateDownload
  Left = 381
  Top = 122
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Downloading Update'
  ClientHeight = 229
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblPleaseWait: TLabel
    Left = 16
    Top = 88
    Width = 170
    Height = 13
    Caption = 'Downloading update. Please wait ...'
  end
  object lblEstimatedTime: TLabel
    Left = 16
    Top = 144
    Width = 71
    Height = 13
    Caption = 'Estimated time:'
  end
  object lblDownloadRate: TLabel
    Left = 16
    Top = 160
    Width = 72
    Height = 13
    Caption = 'Download rate:'
  end
  object lblEstimated: TLabel
    Left = 120
    Top = 144
    Width = 3
    Height = 13
    Caption = '-'
  end
  object lblRate: TLabel
    Left = 120
    Top = 160
    Width = 3
    Height = 13
    Caption = '-'
  end
  object Ani: TAnimate
    Left = 16
    Top = 8
    Width = 272
    Height = 60
    CommonAVI = aviCopyFiles
    StopFrame = 31
  end
  object btnCancel: TButton
    Left = 216
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ProgressBar: TProgressBar
    Left = 16
    Top = 112
    Width = 273
    Height = 17
    Smooth = True
    TabOrder = 2
  end
end
