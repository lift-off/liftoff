object fraNeutralpunkte: TfraNeutralpunkte
  Left = 0
  Top = 0
  Width = 609
  Height = 547
  TabOrder = 0
  object Shape1: TShape
    Left = 0
    Top = 42
    Width = 609
    Height = 1
    Align = alTop
    Pen.Color = clGray
  end
  object Shape4: TShape
    Left = 0
    Top = 0
    Width = 609
    Height = 1
    Align = alTop
    Pen.Color = clGray
  end
  object idTitleBar1: TidTitleBar
    Left = 0
    Top = 1
    Width = 609
    Height = 41
    Align = alTop
    Alignment = taLeftJustify
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -15
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ColorStart = clWhite
    ColorEnd = 14933984
    object Label26: TLabel
      Left = 9
      Top = 1
      Width = 190
      Height = 21
      Caption = 'Neutral- und Druckpunkte'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 8
      Top = 0
      Width = 190
      Height = 21
      Caption = 'Neutral- und Druckpunkte'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 322
      Height = 13
      Caption = 'eutralpunkte und Druckpunkt von gepfeilten Mehrfachtrapezfl'#252'geln'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 400
    Width = 609
    Height = 147
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Shape5: TShape
      Left = 0
      Top = 0
      Width = 609
      Height = 1
      Align = alTop
      Pen.Color = clGray
    end
    object Shape6: TShape
      Left = 0
      Top = 23
      Width = 609
      Height = 1
      Align = alTop
      Pen.Color = clGray
    end
    object btnCalcND: TBitBtn
      Left = 8
      Top = 32
      Width = 257
      Height = 57
      Hint = 'Rechnet die Auslegung der aktuellen Modellvariante'
      Caption = 'Neutral- und Druckpunkte rechnen'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnCalcNDClick
      Glyph.Data = {
        361B0000424D361B000000000000360000002800000030000000300000000100
        180000000000001B0000000000000000000000000000000000008000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFA5827BB58A84CE9A9C6B
        41424A41398000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFAD8684C69694CE9A9C
        CE9A9CD6A2A5DEAAADE7B2B5F7BEBDC68E8C5A34314238318000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FFA58A7BA5867BAD867BB58E8CCE9A9CCE9A
        9CCE9E9CDEA6A5E7B2B5EFBABDF7BEBDFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFF
        CFCEC692946330314A3831423C315A49426B514A8465635A4D428000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFD6A29CCE9A9CCE9A9CCE
        9A9CDEA6A5DEAEADEFB6B5F7BEBDFFCBCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCE
        FFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEC692946B34318C5D5A9C65
        639C6563BD8E8C9471734A45398000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FFDEB2ADEFBEBDF7C3C6FFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCF
        CEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFF
        CFCEFFCFCEFFCFCEC692946B34319461639C6563BD8E8CBD86845A4942524539
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFEFC7B5FFCBC6FF
        CFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCE
        FFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEBD86848C5D
        5A9C6563BD8E8CB582849461634A41398000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FFEFC7BDFFCBCEFFCFCEFFCFCEFFCFCEFFCF
        CEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEFFCFCEE7B2B5DEAEADCE
        9A9CBD8684AD797B9C65639C65639C65639C6563BD8E8CB582849C65637B5952
        4A41398000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FFDEBAA5DEA6A5FFCFCEFFCFCEFFCFCEFFCFCEF7BEBDE7B2B5D69E9CC69294
        B58284A571739C65639C65639C65639C65639C65639C65639C65639C65639C65
        639C6563BD8E8CB582849C65639C65636B4D4A4A45398000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FFBD9E8C9C6563AD797BBD8E8CB582
        849C65639C65639C65639C65639C65639C65639C65639C65639C65639C65639C
        65639C65639C65639C65639C65639C65639C6563BD8E8CB582849C65639C6563
        9461634A41395249398000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FFB5928C9C65639C65639C65639C65639C65639C65639C65639C65639C6563
        9C65639C65639C65639C65639C65639C65639C65639C65639C65639C65639C65
        639C6563BD8E8CB582849C65639C65639C65638C5D5A4A3C318000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FFBD968C9C65639C65639C65639C65
        639C65639C65639C65639C65639C65639C65639C65639C65639C65639C65639C
        65639C65639C65639C65639461638C595A845152A57173AD7D7B9C65639C6563
        9C65639C65636B514A5249398000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FFAD86849C65639C65639C65639C65639C65639C65639C65639C65639C6563
        9C65639C65638C595A8C5552844D4A7B494A7341426B38396330316330316330
        31633031844D4A8451529461639C65639C65639C65639C65635A494263554A80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FFAD797B9C65639C65639C65639461
        638C595A845152844D4A73414273414263303163303163303163303163303163
        3031633031633031633031633031633031633031844D4A844D4A733C39946163
        9C65639C65639C6563845D5A5A51428000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8C5552734142733C39633031633031633031633031633031633031633031
        6330316330316330316330316330316330316330316330316330316330316330
        317B45428C595A7B494A6330317341429C65639C65639C6563845D5A5A514280
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF7341426330316330316330316330316330
        31633031633031633031633031633031633031633031633031844D4A844D4A94
        61639C6563AD797BB58284C69294CE9A9CCE9A9CB582847341426B3839633031
        7B45429C65639C65639C65635A4D428000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFBD715A63
        30316330316330316330316330316B3839844D4A844D4A9C65639C6563B58284
        B58284CE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A
        9CCE9A9CC696947B4D4A8C55527B45426330318451529C65639C656352494280
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FFCE968C9C65639C6D6BB58284BD8684CE9A9CCE9A
        9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE
        9A9CCE9694CE9694CE9694CE9694C69294C69294C692948C595A8C595A9C6563
        7B45426330318451529C65635245398000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFBD8684CE
        9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9A9CCE9694CE9694CE9694C69694C69294
        C69294C69294C68E8CBD8E8CBD8A8CBD8A8CBD8A8CBD8684B58684B58284B582
        84B57D7BB57D7B9C65639461639C65639C65637B45426B34318C5D5A5A494280
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FFAD7573C69294C68E8CC68E8CBD8A8CBD8A8CBD8A
        8CBD8684BD8684B58284B58284B58284B57D7BB57D7BAD797BAD797BAD797BAD
        7573A57573A57173A57173A56D6BA56D6BA56D6B9C6D6B9C696B9C696B9C696B
        9C6563946163733C396B34315241398000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF9C696BB5
        7D7BAD7D7BAD797BAD797BAD7573AD7573A57573A57173A57173A56D6BA56D6B
        9C6D6B9C6D6B9C696B9C696B9C696B9C696B9C6D6B946163945D5A8C55528451
        529C6D6BAD7573AD7573AD797BAD75739C65639C6563946163733C395A343180
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FFAD797B9C6D6B9C696B9C696B9C696B9C696B9C6D
        6BA56D6BA56D6B9C696B9461639461638C55528451527B494A7341426B3C3963
        30316330315A30315A30315A3031523031946163BD8A8CC68E8CBD8A8CBD8A8C
        9C65639C65639C6563946163733C394A45398000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFB59E8CB5
        7D7BAD797B9C6D6B8C5552734542734542633C395A30315A3031523031523031
        5230314A30314A30314A30314A30315A41395A41395A4139634D42634D425238
        31845552D6A2A5D6A6A5CEA2A5D6A6A5AD7D7B9C65639C65639C656394616352
        41398000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FFB58284D6A6A5C68E8CB586846330315A30315238
        315A4139634939634D42634D426B55427359427359427B654A7B654A7B654A7B
        654A7B654A7B654A7B654A7B654A5A41395A3031D6AEADE7C7C6E7C7C6E7C3C6
        CEAAAD9C65639C65639C65639C65638C5D5A63594A8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFCE
        C7BDDEB2B5D6AAAD8451525A30316349397B654A7B654A7B654A7B654A7B654A
        7B654A7B654A7B654A7B654A7B654A7B654A7B654A7B654A7B654A7B654A6349
        395A30319C7173F7E3E7F7E7E7F7E3E7F7EFEFA5797B9C65639C65639C65639C
        65637365528000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FFEFEBE7E7CBCECEAEAD5A30315A41
        397B654A7B65527B65527B65527B65527B69527B69528C755A9C82639C82639C
        8263B59673BD9E7BBD9E7BBD9E7BB58A737B4D4A633031D6C7C6FFF7F7FFF7F7
        F7EFEFCEAEAD9C65639C65639C65639C65638475638000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FFF7E7E7F7EBEFB59694845952DEBA94DEBA94DEBA94EFC79CFFD7AD
        FFD7ADFFD7ADFFD7ADFFD7ADFFD7ADFFD7ADFFD7ADFFD7ADFFD7ADFFD7ADE7BA
        9C9C6D6BBD9A9CD6B6B5EFD7D6EFD3D6E7C7C6D6AEADAD75739C65639C656394
        69639C8A738000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFEFDFDEFFF3F79C65
        63FFDBB5FFDBB5FFDBB5FFDBB5FFDBB5FFDBB5FFDBB5FFDBB5FFDBB5FFDBB5FF
        DBB5FFDBB5FFDBB5FFDBB5FFDBB5EFC3A59C6563DEBABDDEB6B5DEB2B5D6B2B5
        D6AAADCE9A9CCE9694AD797B9C696B947D6B8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FFE7C3BDA57173E7BEA5FFDFBDFFDFBDFFDFBDFFDFBD
        FFDFBDFFDFBDFFDFBDFFDFBDFFDFBDFFDFBDFFDFBDFFDFBDFFDFBDFFDFBDFFDF
        BD9C6563C69694CE9A9CCE9A9CCE9A9CCE9A9CCE9A9CBD8E8CA57D7B846D639C
        8A738000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFB582
        7BD6AA9CFFE3C6FFE3C6FFE3C6FFE3C6FFE3C6FFE3C6FFE3C6FFE3C6FFE3C6FF
        E3C6FFE3C6FFE3C6FFE3C6FFE3C6FFE3C6B5867BD6A2A5F7BEBDFFC7C6FFCFCE
        FFCFCEFFCFCE845D5A5A4D4273695A8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FFCEA294BD968CFFE7CEFFE7CEFFE7CEFFE7CE
        FFE7CEFFE7CEFFE7CEFFE7CEFFE7CEFFE7CEFFE7CEFFE7CEFFE7CEFFE7CEFFE7
        CEC69E94C69294FFCFCEFFCFCEFFCFCEFFCFCEFFCFCE9C6D6B524D428000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FFAD7D7BFFEBD6FFEBD6FFEBD6FFEBD6FFEBD6FFEBD6FFEBD6FFEBD6FFEBD6FF
        EBD6FFEBD6FFEBD6FFEBD6FFEBD6FFEBD6DEBAADB58284FFCFCEFFCFCEFFCFCE
        FFCFCEFFCFCEB58284524D428000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF9C6563FFE7D6FFEFDEFFEFDEFFEFDE
        FFEFDEFFEFDEFFEFDEFFEFDEFFEFDEFFEFDEFFEFDEFFEFDEFFEFDEFFEFDEFFEF
        DEF7DFCE9C6563FFCFCEFFCFCEFFCFCEFFCFCEFFCFCEDEA6A56351428000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF9C6563DEC7BDFFF3E7FFF3E7FFF3E7FFF3E7FFF3E7FFF3E7FFF3E7FFF3E7FF
        F3E7FFF3E7FFF3E7FFF3E7FFF3E7FFF3E7FFF3E7A57973E7B2B5FFCFCEFFCFCE
        FFCFCEFFCFCEEFBABD73594A8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FFAD6D6BC6A6A5FFF7EFFFF7EFFFF7EF
        FFF7EFFFF7EFFFF7EFFFF7EFFFF7EFFFF7EFFFF7EFFFF7EFFFF7EFFFF7EFFFF7
        EFFFF7EFBD9E9CCE9A9CFFCFCEFFCFCEFFCFCEFFCFCEFFCFCE7B5D528000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FFA5696BAD8284FFFBF7FFFBF7FFFBF7FFFBF7FFFBF7FFFBF7FFFBF7FFFBF7FF
        FBF7FFFBF7FFFBF7FFFBF7FFFBF7FFFBF7FFFBF7DEC3BDAD797BFFCFCEFFCFCE
        FFCFCEFFCFCEFFCFCEA5756B8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF9C6563F7EBE7FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFF3F79C6563AD8A84AD8E8CBD9A94BDA294C6AA9CBDA28C8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF9C5D52D6BEBDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBD96948000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FFC69A84BD9694FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFDEC7C68C65638000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF9C6563F7EFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F79C656394796B
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FFB58684C6AAADE7DBDE
        E7DBDEE7DBDEE7DBDEE7DBDEE7DBDEE7DBDEE7DBDEE7DBDEE7DBDEE7DBDEE7DB
        DEE7DBDEE7DBDEE7DBDEB58E8CA579738000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FFB58684B58684AD79739C594A9459528C615A9469639C
        6D6BA5756BA57973A57973A57973A57973A57973A57973A57973A5756B9C716B
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF
        8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        00FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF}
    end
    object idTitleBar3: TidTitleBar
      Left = 0
      Top = 1
      Width = 609
      Height = 22
      Align = alTop
      Alignment = taLeftJustify
      Caption = 'Funktionen'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      ColorStart = clWhite
      ColorEnd = 14933984
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 43
    Width = 609
    Height = 357
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 2
    object PageControl: TPageControl
      Left = 4
      Top = 4
      Width = 601
      Height = 349
      ActivePage = tsTragflaeche
      Align = alClient
      Images = ImageList1
      MultiLine = True
      TabOrder = 0
      object tsTragflaeche: TTabSheet
        Caption = 'Tragfl'#228'che'
        ImageIndex = 1
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 593
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object Label6: TLabel
            Left = 0
            Top = 12
            Width = 161
            Height = 13
            Caption = 'Pfeilung Vorderkante Randbogen:'
          end
          object edPfeilungRandbogen: TEdit
            Left = 184
            Top = 8
            Width = 121
            Height = 21
            TabOrder = 0
            OnChange = edSpannweiteChange
          end
        end
        object Panel2: TPanel
          Left = 0
          Top = 41
          Width = 593
          Height = 279
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object Shape2: TShape
            Left = 0
            Top = 0
            Width = 593
            Height = 1
            Align = alTop
            Pen.Color = clGray
          end
          object Shape3: TShape
            Left = 0
            Top = 23
            Width = 593
            Height = 1
            Align = alTop
            Pen.Color = clGray
          end
          object idTitleBar2: TidTitleBar
            Left = 0
            Top = 1
            Width = 593
            Height = 22
            Align = alTop
            Alignment = taLeftJustify
            Caption = 'Trapeze:'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            ColorStart = clWhite
            ColorEnd = 14933984
          end
          object Panel5: TPanel
            Left = 0
            Top = 247
            Width = 593
            Height = 32
            Align = alBottom
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            object Shape7: TShape
              Left = 0
              Top = 0
              Width = 593
              Height = 1
              Align = alTop
              Brush.Style = bsClear
              Pen.Color = clGray
            end
            object btnFlAdd: TSpeedButton
              Left = 8
              Top = 8
              Width = 80
              Height = 23
              Caption = 'Hinzuf'#252'gen'
              Enabled = False
              Flat = True
              OnClick = btnFlAddClick
            end
            object btnFlInsert: TSpeedButton
              Left = 96
              Top = 8
              Width = 80
              Height = 23
              Caption = 'Einf'#252'gen'
              Enabled = False
              Flat = True
              OnClick = btnFlInsertClick
            end
            object btnFlDelete: TSpeedButton
              Left = 184
              Top = 8
              Width = 80
              Height = 23
              Caption = 'L'#246'schen'
              Enabled = False
              Flat = True
              OnClick = btnFlDeleteClick
            end
          end
        end
      end
      object tsHLW: TTabSheet
        Caption = 'H'#246'henleitwerk'
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 593
          Height = 89
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object Label7: TLabel
            Left = 8
            Top = 36
            Width = 59
            Height = 13
            Caption = 'Spannweite:'
          end
          object Label8: TLabel
            Left = 8
            Top = 60
            Width = 56
            Height = 13
            Caption = 'Wurzeltiefe:'
          end
          object Label9: TLabel
            Left = 256
            Top = 36
            Width = 167
            Height = 13
            Caption = 'Aussentiefe (Tiefe am Randbogen):'
          end
          object Label10: TLabel
            Left = 256
            Top = 60
            Width = 161
            Height = 13
            Caption = 'Pfeilung Vorderkante Randbogen:'
          end
          object Label11: TLabel
            Left = 8
            Top = 12
            Width = 221
            Height = 13
            Caption = 'Abstand Vorderkante Fl'#252'gel bis H'#246'henleitwerk:'
          end
          object edHlwSpannweite: TEdit
            Left = 114
            Top = 32
            Width = 121
            Height = 21
            TabOrder = 1
            OnChange = edSpannweiteChange
          end
          object edHlwWurzeltiefe: TEdit
            Left = 114
            Top = 56
            Width = 121
            Height = 21
            TabOrder = 2
            OnChange = edSpannweiteChange
          end
          object edHlwAussentiefe: TEdit
            Left = 440
            Top = 32
            Width = 121
            Height = 21
            TabOrder = 3
            OnChange = edSpannweiteChange
          end
          object edHlwPfeilung: TEdit
            Left = 440
            Top = 56
            Width = 121
            Height = 21
            TabOrder = 4
            OnChange = edSpannweiteChange
          end
          object edAbstandFluegelHlw: TEdit
            Left = 256
            Top = 8
            Width = 121
            Height = 21
            TabOrder = 0
            OnChange = edSpannweiteChange
          end
        end
        object Panel7: TPanel
          Left = 0
          Top = 89
          Width = 593
          Height = 231
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object Shape8: TShape
            Left = 0
            Top = 0
            Width = 593
            Height = 1
            Align = alTop
            Pen.Color = clGray
          end
          object Shape9: TShape
            Left = 0
            Top = 23
            Width = 593
            Height = 1
            Align = alTop
            Pen.Color = clGray
          end
          object idTitleBar4: TidTitleBar
            Left = 0
            Top = 1
            Width = 593
            Height = 22
            Align = alTop
            Alignment = taLeftJustify
            Caption = 'Trapeze:'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            ColorStart = clWhite
            ColorEnd = 14933984
          end
          object Panel8: TPanel
            Left = 0
            Top = 199
            Width = 593
            Height = 32
            Align = alBottom
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            object Shape10: TShape
              Left = 0
              Top = 0
              Width = 593
              Height = 1
              Align = alTop
              Brush.Style = bsClear
              Pen.Color = clGray
            end
            object btnHlwAdd: TSpeedButton
              Left = 8
              Top = 8
              Width = 80
              Height = 23
              Caption = 'Hinzuf'#252'gen'
              Enabled = False
              Flat = True
              OnClick = btnHlwAddClick
            end
            object btnHlwInsert: TSpeedButton
              Left = 96
              Top = 8
              Width = 80
              Height = 23
              Caption = 'Einf'#252'gen'
              Enabled = False
              Flat = True
              OnClick = btnHlwInsertClick
            end
            object btnHlwDelete: TSpeedButton
              Left = 184
              Top = 8
              Width = 80
              Height = 23
              Caption = 'L'#246'schen'
              Enabled = False
              Flat = True
              OnClick = btnHlwDeleteClick
            end
          end
        end
      end
    end
  end
  object ImageList1: TImageList
    Left = 264
    Top = 16
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF008E8EFF008E8EFF000000FF008E8EFF008E8EFF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000A1A1A100C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0BDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0BDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F1EEEE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F1EEEE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A4A0A000A4A0
      A000A4A0A000A4A0A000A4A0A000FFFFFF00A4A0A000A4A0A000A4A0A000A4A0
      A000A4A0A000A4A0A000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000FFFF
      FF00FFFFFF00FFFFFF00DADADA00FFFFFF00C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C000000000000000000000000000000000000000FF008E8E
      FF008E8EFF008E8EFF006B6BFF008E8EFF008E8EFF008E8EFF008E8EFF008E8E
      FF008E8EFF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DADADA00FF252500C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DADADA00FF252500C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DADADA00FFD4D400C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DADADA00FFD4D400C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      F01FF83F00000000F01FF01F00000000F83FF83F00000000FEFFFEFF00000000
      FEFFFEFF00000000FEFFFEFF00000000C003C00300000000C003C00300000000
      E007E00700000000FC7FFC7F00000000FC7FFC7F00000000FEFFFEFF00000000
      FFFFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
end