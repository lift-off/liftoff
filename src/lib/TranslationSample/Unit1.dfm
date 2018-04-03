object Form1: TForm1
  Left = 360
  Top = 122
  Width = 497
  Height = 458
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblLang: TLabel
    Left = 16
    Top = 40
    Width = 51
    Height = 13
    Caption = 'Language:'
  end
  object SpeedButton1: TSpeedButton
    Left = 104
    Top = 40
    Width = 97
    Height = 22
    GroupIndex = 1
    Down = True
    Caption = 'English (Default)'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 208
    Top = 40
    Width = 105
    Height = 22
    GroupIndex = 1
    Caption = 'German '#228
    OnClick = SpeedButton2Click
  end
  object Button3: TButton
    Left = 320
    Top = 32
    Width = 75
    Height = 33
    Caption = 'Write'
    TabOrder = 0
    OnClick = Button3Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 72
    Width = 473
    Height = 329
    ActivePage = TabSheet1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Standard'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 32
        Height = 13
        Caption = 'Label1'
      end
      object Label2: TLabel
        Left = 8
        Top = 24
        Width = 32
        Height = 13
        Caption = 'Label2'
      end
      object Label3: TLabel
        Left = 8
        Top = 40
        Width = 32
        Height = 13
        Caption = 'Label3'
      end
      object Edit1: TEdit
        Left = 96
        Top = 8
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'Edit1'
      end
      object Memo1: TMemo
        Left = 96
        Top = 32
        Width = 185
        Height = 89
        Lines.Strings = (
          'Memo1')
        PopupMenu = PopupMenu1
        TabOrder = 1
      end
      object btnTest: TButton
        Left = 16
        Top = 136
        Width = 97
        Height = 25
        Caption = 'Testbutton'
        TabOrder = 2
      end
      object btnShowMessage: TButton
        Left = 120
        Top = 136
        Width = 105
        Height = 25
        Caption = 'Show Message ...'
        TabOrder = 3
        OnClick = btnShowMessageClick
      end
      object cbTest1: TCheckBox
        Left = 16
        Top = 176
        Width = 137
        Height = 17
        Caption = 'This is a checkbox'
        TabOrder = 4
      end
      object rb1: TRadioButton
        Left = 16
        Top = 208
        Width = 113
        Height = 17
        Caption = 'Radio Button 1'
        Checked = True
        TabOrder = 5
        TabStop = True
      end
      object rb2: TRadioButton
        Left = 16
        Top = 224
        Width = 113
        Height = 17
        Caption = 'Radio Button 2'
        TabOrder = 6
      end
      object gbTest1: TGroupBox
        Left = 16
        Top = 248
        Width = 233
        Height = 49
        Caption = 'This is a group box'
        TabOrder = 7
      end
      object rgGroup1: TRadioGroup
        Left = 296
        Top = 8
        Width = 161
        Height = 73
        Caption = 'Radio Group'
        Items.Strings = (
          'Item 1'
          'Item 2'
          'Item 3')
        TabOrder = 8
      end
      object pnlTest: TPanel
        Left = 296
        Top = 88
        Width = 161
        Height = 57
        Caption = 'This is a panel'
        TabOrder = 9
      end
      object Panel1: TPanel
        Left = 264
        Top = 168
        Width = 193
        Height = 129
        TabOrder = 10
        object Panel2: TPanel
          Left = 8
          Top = 8
          Width = 177
          Height = 113
          BevelOuter = bvLowered
          TabOrder = 0
          object Panel3: TPanel
            Left = 1
            Top = 1
            Width = 175
            Height = 24
            Align = alTop
            Caption = 'Panel3'
            TabOrder = 0
          end
          object btnCasc1: TButton
            Left = 24
            Top = 40
            Width = 129
            Height = 25
            Caption = 'Cascaded Button 1'
            TabOrder = 1
          end
          object btnCasc2: TButton
            Left = 24
            Top = 72
            Width = 129
            Height = 25
            Caption = 'Cascaded Button 1'
            TabOrder = 2
          end
        end
      end
      object Button1: TButton
        Left = 176
        Top = 184
        Width = 75
        Height = 25
        Action = actTest1
        TabOrder = 11
      end
      object Button2: TButton
        Left = 176
        Top = 216
        Width = 75
        Height = 25
        Action = actTest2
        TabOrder = 12
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Dev Express'
      ImageIndex = 1
      object cxCheckBox1: TcxCheckBox
        Left = 8
        Top = 8
        Width = 145
        Height = 21
        Properties.DisplayUnchecked = 'False'
        TabOrder = 0
      end
      object cxRadioButton1: TcxRadioButton
        Left = 8
        Top = 32
        Width = 113
        Height = 17
        Caption = 'cxRadioButton1'
        TabOrder = 1
      end
      object cxRadioButton2: TcxRadioButton
        Left = 8
        Top = 48
        Width = 113
        Height = 17
        Caption = 'cxRadioButton2'
        TabOrder = 2
      end
      object cxRadioGroup1: TcxRadioGroup
        Left = 168
        Top = 8
        Width = 185
        Height = 57
        Alignment = alTopLeft
        Properties.Items = <>
        TabOrder = 3
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 432
    object miFile: TMenuItem
      Caption = 'File'
      object miNew: TMenuItem
        Caption = 'New'
      end
      object Action31: TMenuItem
        Action = actTest3
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = '&Exit'
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 400
    object miTest1: TMenuItem
      Caption = 'Test 1'
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miTest2: TMenuItem
      Caption = 'Test 2'
    end
  end
  object ActionList1: TActionList
    Left = 400
    Top = 32
    object actTest1: TAction
      Caption = 'Action 1'
    end
    object actTest2: TAction
      Caption = 'Action 2'
    end
    object actTest3: TAction
      Caption = 'Action 3'
    end
  end
  object dxBarManager1: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Bars = <
      item
        Caption = 'Custom 1'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 404
        FloatTop = 343
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = View
            Visible = True
          end>
        Name = 'Custom 1'
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = True
        WholeRow = False
      end>
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    Style = bmsFlat
    UseSystemFont = True
    Left = 432
    Top = 32
    DockControlHeights = (
      0
      0
      23
      0)
    object View: TdxBarSubItem
      Caption = '&View'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxBarButton1
          Visible = True
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actTest1
      Category = 0
    end
  end
  object Translator: TidTranslator
    DataProvider = TranslatorDataINI
    Left = 80
    Top = 8
  end
  object TranslatorData: TidTlXMLDataProvider
    DefaultLanguage = 'EN'
    Language = 'EN'
    Left = 112
    Top = 8
  end
  object TranslatorDataINI: TidTlINIDataProvider
    DefaultLanguage = 'EN'
    Language = 'EN'
    Left = 144
    Top = 8
  end
end
