object fraWingGeo: TfraWingGeo
  Left = 0
  Top = 0
  Width = 903
  Height = 611
  TabOrder = 0
  object Shape1: TShape
    Left = 0
    Top = 42
    Width = 903
    Height = 1
    Align = alTop
    Pen.Color = clGray
  end
  object Shape4: TShape
    Left = 0
    Top = 0
    Width = 903
    Height = 1
    Align = alTop
    Pen.Color = clGray
  end
  object idTitleBar1: TidTitleBar
    Left = 0
    Top = 1
    Width = 903
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
      Width = 119
      Height = 21
      Caption = 'Fl'#252'gelgeometrie'
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
      Width = 119
      Height = 21
      Caption = 'Fl'#252'gelgeometrie'
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
      Width = 403
      Height = 13
      Caption = 
        'Definieren Sie hier die detailierte Fl'#252'gelgeometrie f'#252'r die erwe' +
        'iterten Berechnungen.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 43
    Width = 903
    Height = 568
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object PageControl: TPageControl
      Left = 4
      Top = 4
      Width = 895
      Height = 508
      ActivePage = tsTragflaeche
      Align = alClient
      Images = Images
      MultiLine = True
      TabOrder = 0
      object tsTragflaeche: TTabSheet
        Caption = 'Tragfl'#228'che'
        ImageIndex = 1
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 887
          Height = 85
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
          object Label3: TLabel
            Left = 0
            Top = 36
            Width = 122
            Height = 13
            Caption = 'Holmbreite an der Wurzel:'
          end
          object Label4: TLabel
            Left = 280
            Top = 36
            Width = 132
            Height = 13
            Caption = 'Holmbreite am Randbogen::'
          end
          object Label5: TLabel
            Left = 0
            Top = 60
            Width = 143
            Height = 13
            Caption = 'Profildicke % an der Wurzel: **'
          end
          object Label12: TLabel
            Left = 280
            Top = 60
            Width = 150
            Height = 13
            Caption = 'Profildicke % am Randbogen: **'
          end
          object Label14: TLabel
            Left = 245
            Top = 60
            Width = 8
            Height = 13
            Caption = '%'
          end
          object Label15: TLabel
            Left = 245
            Top = 12
            Width = 16
            Height = 13
            Caption = 'mm'
          end
          object Label16: TLabel
            Left = 245
            Top = 36
            Width = 16
            Height = 13
            Caption = 'mm'
          end
          object Label19: TLabel
            Left = 501
            Top = 60
            Width = 8
            Height = 13
            Caption = '%'
          end
          object Label20: TLabel
            Left = 501
            Top = 36
            Width = 16
            Height = 13
            Caption = 'mm'
          end
          object edPfeilungRandbogen: TEdit
            Left = 184
            Top = 8
            Width = 57
            Height = 21
            TabOrder = 0
            OnChange = edSpannweiteChange
          end
          object edHolmbreiteWurzel: TEdit
            Left = 184
            Top = 32
            Width = 57
            Height = 21
            TabOrder = 1
            OnChange = edSpannweiteChange
          end
          object edHolmbreiteRandbogen: TEdit
            Left = 440
            Top = 32
            Width = 57
            Height = 21
            TabOrder = 2
            OnChange = edSpannweiteChange
          end
          object edProfildickeWurzel: TEdit
            Left = 184
            Top = 56
            Width = 57
            Height = 21
            TabOrder = 3
            OnChange = edSpannweiteChange
          end
          object edProfildickeRandbogen: TEdit
            Left = 440
            Top = 56
            Width = 57
            Height = 21
            TabOrder = 4
            OnChange = edSpannweiteChange
          end
        end
        object Panel2: TPanel
          Left = 0
          Top = 85
          Width = 887
          Height = 394
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object Shape2: TShape
            Left = 0
            Top = 0
            Width = 887
            Height = 1
            Align = alTop
            Pen.Color = clGray
          end
          object Shape3: TShape
            Left = 0
            Top = 23
            Width = 887
            Height = 1
            Align = alTop
            Pen.Color = clGray
          end
          object idTitleBar2: TidTitleBar
            Left = 0
            Top = 1
            Width = 887
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
            Top = 24
            Width = 887
            Height = 32
            Align = alTop
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            object Shape7: TShape
              Left = 0
              Top = 31
              Width = 887
              Height = 1
              Align = alBottom
              Brush.Style = bsClear
              Pen.Color = clGray
            end
            object btnFlAdd: TSpeedButton
              Left = 8
              Top = 4
              Width = 105
              Height = 23
              Caption = 'Knick hinzuf'#252'gen'
              OnClick = btnFlAddClick
            end
            object btnFlInsert: TSpeedButton
              Left = 120
              Top = 4
              Width = 105
              Height = 23
              Caption = 'Knick einf'#252'gen'
              Enabled = False
              OnClick = btnFlInsertClick
            end
            object btnFlDelete: TSpeedButton
              Left = 232
              Top = 4
              Width = 105
              Height = 23
              Caption = 'Knick l'#246'schen'
              Enabled = False
              OnClick = btnFlDeleteClick
            end
            object Label30: TLabel
              Left = 350
              Top = 1
              Width = 111
              Height = 13
              Caption = 'Masse in mm eingeben.'
            end
            object Label13: TLabel
              Left = 350
              Top = 16
              Width = 247
              Height = 13
              Caption = '** = Optional. Wird f'#252'r die Holmberechnung ben'#246'tigt.'
            end
          end
        end
      end
      object tsHLW: TTabSheet
        Caption = 'H'#246'henleitwerk'
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 887
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
            Left = 216
            Top = 36
            Width = 167
            Height = 13
            Caption = 'Aussentiefe (Tiefe am Randbogen):'
          end
          object Label10: TLabel
            Left = 216
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
          object Label21: TLabel
            Left = 320
            Top = 12
            Width = 16
            Height = 13
            Caption = 'mm'
          end
          object Label22: TLabel
            Left = 176
            Top = 36
            Width = 16
            Height = 13
            Caption = 'mm'
          end
          object Label23: TLabel
            Left = 176
            Top = 60
            Width = 16
            Height = 13
            Caption = 'mm'
          end
          object Label27: TLabel
            Left = 464
            Top = 60
            Width = 16
            Height = 13
            Caption = 'mm'
          end
          object Label28: TLabel
            Left = 464
            Top = 36
            Width = 16
            Height = 13
            Caption = 'mm'
          end
          object edHlwSpannweite: TEdit
            Left = 114
            Top = 32
            Width = 55
            Height = 21
            TabOrder = 1
            OnChange = edSpannweiteChange
          end
          object edHlwWurzeltiefe: TEdit
            Left = 114
            Top = 56
            Width = 55
            Height = 21
            TabOrder = 2
            OnChange = edSpannweiteChange
          end
          object edHlwAussentiefe: TEdit
            Left = 400
            Top = 32
            Width = 57
            Height = 21
            TabOrder = 3
            OnChange = edSpannweiteChange
          end
          object edHlwPfeilung: TEdit
            Left = 400
            Top = 56
            Width = 57
            Height = 21
            TabOrder = 4
            OnChange = edSpannweiteChange
          end
          object edAbstandFluegelHlw: TEdit
            Left = 256
            Top = 8
            Width = 57
            Height = 21
            TabOrder = 0
            OnChange = edSpannweiteChange
          end
        end
        object Panel7: TPanel
          Left = 0
          Top = 89
          Width = 887
          Height = 390
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object Shape8: TShape
            Left = 0
            Top = 0
            Width = 887
            Height = 1
            Align = alTop
            Pen.Color = clGray
          end
          object Shape9: TShape
            Left = 0
            Top = 23
            Width = 887
            Height = 1
            Align = alTop
            Pen.Color = clGray
          end
          object idTitleBar4: TidTitleBar
            Left = 0
            Top = 1
            Width = 887
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
            Top = 24
            Width = 887
            Height = 32
            Align = alTop
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            object Shape10: TShape
              Left = 0
              Top = 31
              Width = 887
              Height = 1
              Align = alBottom
              Brush.Style = bsClear
              Pen.Color = clGray
            end
            object btnHlwAdd: TSpeedButton
              Left = 8
              Top = 4
              Width = 105
              Height = 23
              Caption = 'Knick hinzuf'#252'gen'
              OnClick = btnHlwAddClick
            end
            object btnHlwInsert: TSpeedButton
              Left = 120
              Top = 4
              Width = 105
              Height = 23
              Caption = 'Knick einf'#252'gen'
              Enabled = False
              OnClick = btnHlwInsertClick
            end
            object btnHlwDelete: TSpeedButton
              Left = 232
              Top = 4
              Width = 105
              Height = 23
              Caption = 'Knick l'#246'schen'
              Enabled = False
              OnClick = btnHlwDeleteClick
            end
            object Label29: TLabel
              Left = 350
              Top = 1
              Width = 111
              Height = 13
              Caption = 'Masse in mm eingeben.'
            end
            object Label17: TLabel
              Left = 350
              Top = 16
              Width = 247
              Height = 13
              Caption = '** = Optional. Wird f'#252'r die Holmberechnung ben'#246'tigt.'
            end
          end
        end
      end
    end
    object Panel3: TPanel
      Left = 4
      Top = 512
      Width = 895
      Height = 52
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object BitBtn1: TBitBtn
        Left = 0
        Top = 10
        Width = 161
        Height = 41
        Caption = 'Modellgrafik anzeigen'
        TabOrder = 0
        OnClick = BitBtn1Click
        Glyph.Data = {
          360C0000424D360C000000000000360000002800000020000000200000000100
          180000000000000C000000000000000000000000000000000000800080800080
          8000808000808000808000808000808000808000808000808000805656568000
          8080008080008080008080008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          8000808000808000808000808686865656565656565656565656565656565656
          5656565656565656565656565680008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080868686CECECECECECECECECECECECE868686CECE
          CECECECECECECECECECE56565680008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080868686FFFFFFFFFFFFFFFFFFFFFFFF868686FFFF
          FFFFFFFFFFFFFFFFFFFF56565680008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          8000808000808000808000808000808686868686868686868686868686868686
          8686868686868686868680008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080A4A0A09E9E9E8686
          8680008080008080008080008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080A4A0A0AAAAAA8686
          8680008080008080008080008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080A4A0A0CECECE8686
          8680008080008080008080008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080A4A0A0FFFFFF8686
          8680008080008080008080008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080A4A0A0FFFFFF8686
          8680008080008080008080008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080A4A0A0FFFFFF8686
          8680008080008080008080008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080A4A0A0FFFFFF8686
          8680008080008080008080008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080868686565656
          565656565656565656565656565656565656565656565656A4A0A0FFFFFF8686
          8656565656565656565656565656565656565656565656565656565656565680
          0080800080800080800080800080800080800080800080800080868686E6E6E6
          CECECECECECECECECECECECECECECECECECECECECECECECEA4A0A0FFFFFF8686
          86CECECECECECECECECECECECECECECECECECECECECECECECEE6E6E656565680
          0080800080800080800080800080800080800080800080800080868686FFFFFF
          E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6A4A0A0FFFFFF4C4C
          4C999999999999999999E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6FFFFFF56565680
          0080800080800080800080800080800080800080800080800080800080868686
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4A0A0FFFFFF19C5
          FF00ACE500ACE5B2B2B2B2B2B2B2B2B2B2B2B2FFFFFFFFFFFF86868680008080
          0080800080800080800080800080800080800080800080800080800080800080
          868686868686868686868686868686868686868686868686A4A0A0FFFFFF19C5
          FF0085B219C5FF00ACE500ACE54C4C4C4C4C4C4C4C4C4C4C4C80008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080A4A0A0FFFFFF8686
          8619C5FF00ACE519C5FF19C5FF00ACE500ACE5CCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCC800080800080800080800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080A4A0A0B900008686
          8619C5FF7FDFFF7FDFFF19C5FF19C5FF914800914800800080CCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCC800080800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080FF4848FF2525B900
          0080008019C5FFFFFFFF7FDFFF19C5FF914800BB5E00914800800080800080CC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCC800080800080800080800080800080800080
          800080800080800080800080800080800080800080800080FF4848FF8E8EB900
          0080008080008019C5FFFFFFFFFF8811FF8811FF5219BB5E0091480080008080
          0080800080CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC800080800080800080
          800080800080800080800080800080800080800080800080A4A0A0FFC7B18686
          86800080800080800080FF8811FFC5B2FFC184FF8811FF5219BB5E0091480080
          0080800080800080800080CCCCCCCCCCCCCCCCCC800080800080800080800080
          8000808000808000808000808000808000808000808000808000800000FF8000
          80800080800080800080800080FF8811FFC5B2FFC184FF8811FF5219BB5E0091
          4800800080800080800080800080800080800080800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          80800080800080800080800080800080FF8811FFC5B2FFC184FF8811FF5219BB
          5E00914800800080800080800080800080800080800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          80800080800080800080800080800080800080FF8811FFC5B2FFC184FF8811FF
          5219BB5E00914800800080800080800080800080800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          80800080800080800080800080800080800080800080FF8811FFC5B2FFC184FF
          8811FF5219BB5E00914800800080800080800080800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          80800080800080800080800080800080800080800080800080FF8811FFC5B2FF
          C184FF8811FF5219BB5E00914800800080800080800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          80800080800080800080800080800080800080800080800080800080FF8811FF
          E2C6FFC184FF8811FF5219BB5E00914800800080800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          80800080800080800080800080800080800080800080800080800080800080FF
          8811FFE2C6FFC184FF8811FF5219BB5E00914800800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          8080008080008080008080008080008080008080008080008080008080008080
          0080FF8811FFE2C6FFC184FFC184FF5219BB5E00914800800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          8080008080008080008080008080008080008080008080008080008080008080
          0080800080FF8811FFFFFFFFE2C6FFE2C6FF5219FF5219800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          8080008080008080008080008080008080008080008080008080008080008080
          0080800080800080FF8811FF8811FF8811FF5219800080800080}
      end
      object btnCalcND: TBitBtn
        Left = 168
        Top = 10
        Width = 217
        Height = 41
        Hint = 'Berechne Druck-/Schwerpunkte f'#252'r momentfreies Fliegen:'
        Caption = 'Neutral- und Druckpunkte'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnCalcNDClick
        Glyph.Data = {
          360C0000424D360C000000000000360000002800000020000000200000000100
          180000000000000C000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6B6BFF6B6BFF2525FF2525
          FF2525FF2525FF0000DC0000DC0000DC0000B90000B9FF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6B6BFF6B6BFF2525
          FF2525FF2525FF0000DC0000DC0000B90000B9FF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4A0A0
          A4A0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6B6BFF6B6B
          FF2525FF0000DC0000DC0000B90000B9FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4A0A0FF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6B6B
          FF2525FF0000DC0000DC0000B9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFA4A0A0A4A0A0FF00FFFF00FFA4A0A0FF00FF
          A4A0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF6B6BFF0000DC0000B9FF00FFFF00FFFF00FFFF00FFFF00FFA4A0A0FF00FFA4
          A0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4A0A0FF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FF2525FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4A0A0FF00FFA4
          A0A0FF00FFFF00FFFF00FFFF00FFA4A0A0FF00FFA4A0A0FF00FFFF00FFFF00FF
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC0C0C0
          FFFFFFFFFFFFFFFFFFFFFFFFCECECECECECECECECECECECECECECEB6B6B6B6B6
          B6B6B6B6B6B6B6808080808080808080808080808080C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF00FFFF00FFC0C0C06B6BFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFCECECECECECE808080808080808080C0C0C0FF00FFFF00FFC0C0C0
          FF4848FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FF00FFFF00FFFF00FF
          C0C0C0FF4848FF4848FF4848FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF
          FFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C0C0C0C0FF00FFFF00FFFF00FF
          FF00FFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC0
          C0C0FFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFC0C0C0FF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4A0
          A0FF00FFA4A0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFC0C0C0FFFFFFFFFFFFC0C0C0FFFFFFFFFFFFC0C0C0FF00FFA4A0A0FF00FF
          A4A0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4A0
          A0FF00FFA4A0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFC0C0C0FFFFFFC0C0C0FFFFFFFFFFFFC0C0C0FF00FFA4A0A0FF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFC0C0C0FFFFFFFFFFFFC0C0C0C0C0C0C0C0C0FF00FFFF00FFA4A0A0
          A4A0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFC0C0C0FFFFFFFFFFFFFFFFFFC0C0C0FF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFC0C0C0C0C0C0C0C0C0FF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4A0A0FF00FFA4A0A0FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4A0A0FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4A0A0A4A0A0FF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      end
    end
  end
  object Images: TImageList
    Left = 464
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
  object Translator: TidTranslator
    DataProvider = dmMain.idTranslationProvider
    Left = 416
    Top = 8
  end
end