object frmMain: TfrmMain
  Left = 211
  Top = 112
  Width = 588
  Height = 646
  Caption = 'Profili Airfoil Importer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    580
    617)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 28
    Width = 56
    Height = 13
    Caption = 'Select .mdb'
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 61
    Height = 13
    Caption = 'Outputfolder:'
  end
  object edMdb: TEdit
    Left = 88
    Top = 24
    Width = 445
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object btnBrwoseMdb: TButton
    Left = 540
    Top = 24
    Width = 27
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '..'
    TabOrder = 1
    OnClick = btnBrwoseMdbClick
  end
  object edOutputFolder: TEdit
    Left = 88
    Top = 48
    Width = 445
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object btnBrowseOutputFolder: TButton
    Left = 540
    Top = 48
    Width = 27
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '..'
    TabOrder = 3
    OnClick = btnBrowseOutputFolderClick
  end
  object btnStart: TButton
    Left = 88
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 4
    OnClick = btnStartClick
  end
  object btnAbort: TButton
    Left = 168
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Abort'
    Enabled = False
    TabOrder = 5
    OnClick = btnAbortClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 128
    Width = 565
    Height = 483
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Progress'
    TabOrder = 6
    DesignSize = (
      565
      483)
    object Label3: TLabel
      Left = 8
      Top = 32
      Width = 28
      Height = 13
      Caption = 'Airfoil:'
    end
    object lblAirfoilCount: TLabel
      Left = 80
      Top = 32
      Width = 6
      Height = 13
      Caption = '?'
    end
    object Label4: TLabel
      Left = 8
      Top = 88
      Width = 21
      Height = 13
      Caption = 'Log:'
    end
    object lblAirfoilName: TLabel
      Left = 152
      Top = 32
      Width = 6
      Height = 13
      Caption = '?'
    end
    object prgAirfoilcount: TProgressBar
      Left = 80
      Top = 56
      Width = 469
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Smooth = True
      TabOrder = 0
    end
    object memLog: TMemo
      Left = 80
      Top = 88
      Width = 469
      Height = 382
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object cbNewOnly: TCheckBox
    Left = 88
    Top = 72
    Width = 297
    Height = 17
    Caption = 'Only new profiles'
    TabOrder = 7
  end
  object ProfiliConnection: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\development\dev\' +
      'delphi\projects\liftoff\profili_packs\Profili1.mdb;Mode=Read;Per' +
      'sist Security Info=False;Jet OLEDB:Compact Without Replica Repai' +
      'r=True'
    IsolationLevel = ilBrowse
    LoginPrompt = False
    Mode = cmRead
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 112
    Top = 232
  end
  object tabProfile: TADOTable
    AutoCalcFields = False
    Connection = ProfiliConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    TableDirect = True
    TableName = 'Profili'
    Left = 184
    Top = 232
  end
  object dlgBrowseMdb: TOpenDialog
    DefaultExt = 'mdb'
    Filter = 'Access Databases|*.mdb|All files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select Access Database (.mdb)'
    Left = 448
    Top = 8
  end
  object dlgBrowseOutputFolder: TcxShellBrowserDialog
    LookAndFeel.NativeStyle = True
    ShowInfoTips = True
    Title = 'Select output folder:'
    Left = 440
    Top = 56
  end
  object XPManifest1: TXPManifest
    Left = 272
    Top = 32
  end
  object qryPolarkoordinaten: TADOQuery
    Connection = ProfiliConnection
    Parameters = <>
    Left = 416
    Top = 232
  end
  object qryPolarkoepfe: TADOQuery
    Connection = ProfiliConnection
    Parameters = <>
    Left = 336
    Top = 232
  end
  object qryKoordinaten: TADOQuery
    Connection = ProfiliConnection
    Parameters = <>
    Left = 256
    Top = 232
  end
end
