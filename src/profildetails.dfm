object frmProfilDetails: TfrmProfilDetails
  Left = 443
  Top = 144
  Width = 550
  Height = 669
  Caption = 'Profildetails'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001001800680300001600000028000000100000002000
    0000010018000000000040030000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000003757000000000000
    0000000000000038580000000000000000000000000000000000000000000000
    00808080D2C6C01E95DB0995D9DCCEC7808080808080119EEB80808080808080
    8080808080808080808080000000808080FFFFFFE5E3E1D6DFE626B2FFF0E3DC
    EDEDEDFFF8F001A5FFFFF8F0F8F8F8B0B0B0B0B0B0D4D4D4A4A0A00000000000
    00A4A0A0CDCDCDE3E0DEEEE1D9DDDDDDE3E3E3999999B4A59DA5A5A59C9C9CDE
    DEDED4D4D4D4D4D4A4A0A0000000000000000000A4A0A0BFBFBFB4B4B4B0B0B0
    A6A6A6FFFFFFECECECE6E6E6E0E0E0D0D0D0DBDBDBA4A0A00000000000000000
    00000000000000A4A0A0FFFFFFFFFFFFF7F7F7F3F3F3E4E4E4E0E0E0DBDBDBCE
    CECECBCBCBA4A0A0000000000000000000000000000000000000A4A0A0FFFFFF
    F9F9F9F1F1F1EDEDEDDFDFDFD7D7D7D1D1D1A4A0A00000000000000000000000
    00000000000000000000A4A0A0E7E7E7FFFFFFF0F0F0ECECECE0E0E0D3D3D3A4
    A0A0000000000000000000000000000000000000000000000000000000A4A0A0
    FFFFFFFDFDFDEFEFEFE0E0E0D4D4D4A4A0A00000000000000000000000000000
    00000000000000000000000000000000A4A0A0FFFFFFFFFFFFE5E5E5A4A0A000
    0000000000000000000000000000000000000000000000000000000000000000
    000000A4A0A0A4A0A0A4A0A0A4A0A00000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000FFFF0000FFFF0000EF7F0000800100000001000080010000C0030000E003
    0000F0070000F00F0000F80F0000FC1F0000FE1F0000FFFF0000FFFF0000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 600
    Width = 542
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      542
      40)
    object btnOk: TButton
      Left = 376
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Ok'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnCancel: TButton
      Left = 456
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'A&bbrechen'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 542
    Height = 145
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      542
      145)
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 52
      Height = 13
      Caption = 'Profilname:'
    end
    object Label3: TLabel
      Left = 96
      Top = 124
      Width = 36
      Height = 13
      Caption = 'Alpha0:'
    end
    object Label4: TLabel
      Left = 240
      Top = 124
      Width = 23
      Height = 13
      Caption = 'cm0:'
    end
    object Label5: TLabel
      Left = 8
      Top = 124
      Width = 55
      Height = 13
      Caption = 'Information:'
    end
    object Label2: TLabel
      Left = 8
      Top = 32
      Width = 52
      Height = 13
      Caption = 'Profilname:'
    end
    object edProfilname: TEdit
      Left = 96
      Top = 8
      Width = 129
      Height = 21
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 0
    end
    object edAlpha0: TEdit
      Left = 152
      Top = 120
      Width = 73
      Height = 21
      TabStop = False
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 1
    end
    object edCm0: TEdit
      Left = 296
      Top = 120
      Width = 73
      Height = 21
      TabStop = False
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 2
    end
    object edProfilbez: TMemo
      Left = 96
      Top = 32
      Width = 441
      Height = 84
      Anchors = [akLeft, akTop, akRight]
      ScrollBars = ssVertical
      TabOrder = 3
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 145
    Width = 542
    Height = 455
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 6
    object TabSheet1: TTabSheet
      Caption = 'Koordinaten'
      object Splitter1: TSplitter
        Left = 0
        Top = 262
        Width = 534
        Height = 5
        Cursor = crVSplit
        Align = alBottom
        ResizeStyle = rsUpdate
      end
      object pnlKoordGraph: TPanel
        Left = 0
        Top = 267
        Width = 534
        Height = 160
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 0
      end
      object dxBarDockControl3: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 534
        Height = 26
        Align = dalTop
        BarManager = dxBarManager1
      end
      object tlKoord: TAdvStringGrid
        Left = 0
        Top = 26
        Width = 534
        Height = 236
        Cursor = crDefault
        Align = alClient
        ColCount = 2
        Ctl3D = True
        DefaultColWidth = 100
        DefaultRowHeight = 19
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 2
        FixedRows = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLineWidth = 1
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goTabs, goThumbTracking]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
        GridLineColor = clSilver
        ActiveCellShow = False
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'MS Sans Serif'
        ActiveCellFont.Style = [fsBold]
        ActiveCellColor = clGray
        Bands.PrimaryColor = clInfoBk
        Bands.PrimaryLength = 1
        Bands.SecondaryColor = clWindow
        Bands.SecondaryLength = 1
        Bands.Print = False
        AutoNumAlign = False
        AutoSize = False
        VAlignment = vtaTop
        EnhTextSize = False
        EnhRowColMove = False
        SizeWithForm = False
        Multilinecells = False
        OnRowChanging = tlKoordRowChanging
        OnEditingDone = tlKoordEditingDone
        DragDropSettings.OleAcceptFiles = True
        DragDropSettings.OleAcceptText = True
        SortSettings.AutoColumnMerge = False
        SortSettings.Column = 0
        SortSettings.Show = False
        SortSettings.IndexShow = False
        SortSettings.IndexColor = clYellow
        SortSettings.Full = True
        SortSettings.SingleColumn = False
        SortSettings.IgnoreBlanks = False
        SortSettings.BlankPos = blFirst
        SortSettings.AutoFormat = True
        SortSettings.Direction = sdAscending
        SortSettings.InitSortDirection = sdAscending
        SortSettings.FixedCols = False
        SortSettings.NormalCellsOnly = False
        SortSettings.Row = 0
        SortSettings.UndoSort = False
        FloatingFooter.Color = clBtnFace
        FloatingFooter.Column = 0
        FloatingFooter.FooterStyle = fsFixedLastRow
        FloatingFooter.Visible = False
        ControlLook.Color = clBlack
        ControlLook.CheckSize = 15
        ControlLook.RadioSize = 10
        ControlLook.ControlStyle = csClassic
        ControlLook.DropDownAlwaysVisible = False
        ControlLook.FlatButton = False
        ControlLook.ProgressMarginX = 2
        ControlLook.ProgressMarginY = 2
        ControlLook.ProgressXP = False
        EnableBlink = False
        EnableHTML = True
        EnableWheel = True
        Flat = False
        Look = glStandard
        HintColor = clInfoBk
        SelectionColor = clHighlight
        SelectionTextColor = clHighlightText
        SelectionRectangle = False
        SelectionResizer = False
        SelectionRTFKeep = False
        HintShowCells = False
        HintShowLargeText = False
        HintShowSizing = False
        PrintSettings.FooterSize = 0
        PrintSettings.HeaderSize = 0
        PrintSettings.Time = ppNone
        PrintSettings.Date = ppNone
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.PageNr = ppNone
        PrintSettings.Title = ppNone
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'MS Sans Serif'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'MS Sans Serif'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'MS Sans Serif'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'MS Sans Serif'
        PrintSettings.FooterFont.Style = []
        PrintSettings.Borders = pbNoborder
        PrintSettings.BorderStyle = psSolid
        PrintSettings.Centered = False
        PrintSettings.RepeatFixedRows = False
        PrintSettings.RepeatFixedCols = False
        PrintSettings.LeftSize = 0
        PrintSettings.RightSize = 0
        PrintSettings.ColumnSpacing = 0
        PrintSettings.RowSpacing = 0
        PrintSettings.TitleSpacing = 0
        PrintSettings.Orientation = poPortrait
        PrintSettings.PageNumberOffset = 0
        PrintSettings.MaxPagesOffset = 0
        PrintSettings.FixedWidth = 0
        PrintSettings.FixedHeight = 0
        PrintSettings.UseFixedHeight = False
        PrintSettings.UseFixedWidth = False
        PrintSettings.FitToPage = fpNever
        PrintSettings.PageNumSep = '/'
        PrintSettings.NoAutoSize = False
        PrintSettings.NoAutoSizeRow = False
        PrintSettings.PrintGraphics = False
        PrintSettings.UseDisplayFont = True
        HTMLSettings.Width = 100
        HTMLSettings.XHTML = False
        Navigation.AlwaysEdit = True
        Navigation.AdvanceDirection = adLeftRight
        Navigation.InsertPosition = pInsertBefore
        Navigation.HomeEndKey = heFirstLastRow
        Navigation.TabToNextAtEnd = True
        Navigation.TabAdvanceDirection = adLeftRight
        ColumnSize.Location = clRegistry
        CellNode.Color = clSilver
        CellNode.ExpandOne = False
        CellNode.NodeColor = clBlack
        CellNode.NodeIndent = 12
        CellNode.ShowTree = False
        MaxEditLength = 0
        Grouping.HeaderColor = clNone
        Grouping.HeaderColorTo = clNone
        Grouping.HeaderTextColor = clNone
        Grouping.MergeHeader = False
        Grouping.MergeSummary = False
        Grouping.Summary = False
        Grouping.SummaryColor = clNone
        Grouping.SummaryColorTo = clNone
        Grouping.SummaryTextColor = clNone
        IntelliPan = ipVertical
        URLColor = clBlue
        URLShow = False
        URLFull = False
        URLEdit = False
        ScrollType = ssNormal
        ScrollColor = clNone
        ScrollWidth = 17
        ScrollSynch = False
        ScrollProportional = False
        ScrollHints = shNone
        OemConvert = False
        FixedFooters = 0
        FixedRightCols = 0
        FixedColWidth = 100
        FixedRowHeight = 19
        FixedRowAlways = True
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = []
        FixedAsButtons = False
        FloatFormat = '%.2f'
        IntegralHeight = False
        WordWrap = False
        ColumnHeaders.Strings = (
          'X'
          'Y')
        Lookup = False
        LookupCaseSensitive = False
        LookupHistory = False
        BackGround.Top = 0
        BackGround.Left = 0
        BackGround.Display = bdTile
        BackGround.Cells = bcNormal
        Filter = <>
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Polaren'
      ImageIndex = 1
      object Splitter2: TSplitter
        Left = 0
        Top = 248
        Width = 534
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ResizeStyle = rsUpdate
      end
      object Splitter3: TSplitter
        Left = 217
        Top = 0
        Height = 248
        ResizeStyle = rsUpdate
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 217
        Height = 248
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object dxBarDockControl1: TdxBarDockControl
          Left = 0
          Top = 0
          Width = 217
          Height = 26
          Align = dalTop
          BarManager = dxBarManager1
        end
        object lstRE: TListBox
          Left = 0
          Top = 45
          Width = 217
          Height = 203
          Align = alClient
          BorderStyle = bsNone
          ItemHeight = 13
          TabOrder = 1
          OnClick = lstREClick
        end
        object Panel7: TPanel
          Left = 0
          Top = 26
          Width = 217
          Height = 19
          Align = alTop
          BevelOuter = bvNone
          Caption = 'RE-Zahlen'
          TabOrder = 2
          object Shape1: TShape
            Left = 0
            Top = 0
            Width = 217
            Height = 19
            Align = alClient
            Brush.Style = bsClear
            Pen.Color = clBtnShadow
          end
        end
      end
      object graPolare: TChart
        Left = 0
        Top = 251
        Width = 534
        Height = 176
        AnimatedZoom = True
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Gradient.EndColor = clWhite
        Gradient.StartColor = 15329769
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        BottomAxis.Title.Caption = 'cw x 1000'
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.ExactDateTime = False
        LeftAxis.Increment = 0.500000000000000000
        LeftAxis.LabelsSize = 21
        LeftAxis.Maximum = 2.000000000000000000
        LeftAxis.Minimum = -1.000000000000000000
        LeftAxis.MinorTickCount = 4
        LeftAxis.TickInnerLength = 3
        LeftAxis.Title.Caption = 'ca'
        Legend.LegendStyle = lsSeries
        View3D = False
        View3DOptions.Elevation = 360
        View3DOptions.Rotation = 332
        View3DOptions.Zoom = 87
        Align = alBottom
        BevelOuter = bvLowered
        Color = clWhite
        TabOrder = 1
        object Series1: TFastLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = 16744448
          LinePen.Color = 16744448
          LinePen.Width = 2
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
      object Panel5: TPanel
        Left = 220
        Top = 0
        Width = 314
        Height = 248
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object dxBarDockControl2: TdxBarDockControl
          Left = 0
          Top = 0
          Width = 314
          Height = 26
          Align = dalTop
          BarManager = dxBarManager1
        end
        object tlPolaren: TAdvStringGrid
          Left = 0
          Top = 26
          Width = 314
          Height = 222
          Cursor = crDefault
          Align = alClient
          ColCount = 2
          Ctl3D = True
          DefaultColWidth = 100
          DefaultRowHeight = 19
          DefaultDrawing = False
          FixedCols = 0
          RowCount = 5
          FixedRows = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          GridLineWidth = 1
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goTabs, goThumbTracking]
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          GridLineColor = clSilver
          ActiveCellShow = False
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'MS Sans Serif'
          ActiveCellFont.Style = [fsBold]
          ActiveCellColor = clGray
          Bands.PrimaryColor = clInfoBk
          Bands.PrimaryLength = 1
          Bands.SecondaryColor = clWindow
          Bands.SecondaryLength = 1
          Bands.Print = False
          AutoNumAlign = False
          AutoSize = False
          VAlignment = vtaTop
          EnhTextSize = False
          EnhRowColMove = False
          SizeWithForm = False
          Multilinecells = False
          OnEditingDone = tlPolarenEditingDone
          DragDropSettings.OleAcceptFiles = True
          DragDropSettings.OleAcceptText = True
          SortSettings.AutoColumnMerge = False
          SortSettings.Column = 0
          SortSettings.Show = False
          SortSettings.IndexShow = False
          SortSettings.IndexColor = clYellow
          SortSettings.Full = True
          SortSettings.SingleColumn = False
          SortSettings.IgnoreBlanks = False
          SortSettings.BlankPos = blFirst
          SortSettings.AutoFormat = True
          SortSettings.Direction = sdAscending
          SortSettings.InitSortDirection = sdAscending
          SortSettings.FixedCols = False
          SortSettings.NormalCellsOnly = False
          SortSettings.Row = 0
          SortSettings.UndoSort = False
          FloatingFooter.Color = clBtnFace
          FloatingFooter.Column = 0
          FloatingFooter.FooterStyle = fsFixedLastRow
          FloatingFooter.Visible = False
          ControlLook.Color = clBlack
          ControlLook.CheckSize = 15
          ControlLook.RadioSize = 10
          ControlLook.ControlStyle = csClassic
          ControlLook.DropDownAlwaysVisible = False
          ControlLook.FlatButton = False
          ControlLook.ProgressMarginX = 2
          ControlLook.ProgressMarginY = 2
          ControlLook.ProgressXP = False
          EnableBlink = False
          EnableHTML = True
          EnableWheel = True
          Flat = False
          Look = glXP
          HintColor = clInfoBk
          SelectionColor = clHighlight
          SelectionTextColor = clHighlightText
          SelectionRectangle = False
          SelectionResizer = False
          SelectionRTFKeep = False
          HintShowCells = False
          HintShowLargeText = False
          HintShowSizing = False
          PrintSettings.FooterSize = 0
          PrintSettings.HeaderSize = 0
          PrintSettings.Time = ppNone
          PrintSettings.Date = ppNone
          PrintSettings.DateFormat = 'dd/mm/yyyy'
          PrintSettings.PageNr = ppNone
          PrintSettings.Title = ppNone
          PrintSettings.Font.Charset = DEFAULT_CHARSET
          PrintSettings.Font.Color = clWindowText
          PrintSettings.Font.Height = -11
          PrintSettings.Font.Name = 'MS Sans Serif'
          PrintSettings.Font.Style = []
          PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
          PrintSettings.FixedFont.Color = clWindowText
          PrintSettings.FixedFont.Height = -11
          PrintSettings.FixedFont.Name = 'MS Sans Serif'
          PrintSettings.FixedFont.Style = []
          PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
          PrintSettings.HeaderFont.Color = clWindowText
          PrintSettings.HeaderFont.Height = -11
          PrintSettings.HeaderFont.Name = 'MS Sans Serif'
          PrintSettings.HeaderFont.Style = []
          PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
          PrintSettings.FooterFont.Color = clWindowText
          PrintSettings.FooterFont.Height = -11
          PrintSettings.FooterFont.Name = 'MS Sans Serif'
          PrintSettings.FooterFont.Style = []
          PrintSettings.Borders = pbNoborder
          PrintSettings.BorderStyle = psSolid
          PrintSettings.Centered = False
          PrintSettings.RepeatFixedRows = False
          PrintSettings.RepeatFixedCols = False
          PrintSettings.LeftSize = 0
          PrintSettings.RightSize = 0
          PrintSettings.ColumnSpacing = 0
          PrintSettings.RowSpacing = 0
          PrintSettings.TitleSpacing = 0
          PrintSettings.Orientation = poPortrait
          PrintSettings.PageNumberOffset = 0
          PrintSettings.MaxPagesOffset = 0
          PrintSettings.FixedWidth = 0
          PrintSettings.FixedHeight = 0
          PrintSettings.UseFixedHeight = False
          PrintSettings.UseFixedWidth = False
          PrintSettings.FitToPage = fpNever
          PrintSettings.PageNumSep = '/'
          PrintSettings.NoAutoSize = False
          PrintSettings.NoAutoSizeRow = False
          PrintSettings.PrintGraphics = False
          PrintSettings.UseDisplayFont = True
          HTMLSettings.Width = 100
          HTMLSettings.XHTML = False
          Navigation.AlwaysEdit = True
          Navigation.AdvanceDirection = adLeftRight
          Navigation.InsertPosition = pInsertBefore
          Navigation.HomeEndKey = heFirstLastRow
          Navigation.TabToNextAtEnd = True
          Navigation.TabAdvanceDirection = adLeftRight
          ColumnSize.Location = clRegistry
          CellNode.Color = clSilver
          CellNode.ExpandOne = False
          CellNode.NodeColor = clBlack
          CellNode.NodeIndent = 12
          CellNode.ShowTree = False
          MaxEditLength = 0
          Grouping.HeaderColor = clNone
          Grouping.HeaderColorTo = clNone
          Grouping.HeaderTextColor = clNone
          Grouping.MergeHeader = False
          Grouping.MergeSummary = False
          Grouping.Summary = False
          Grouping.SummaryColor = clNone
          Grouping.SummaryColorTo = clNone
          Grouping.SummaryTextColor = clNone
          IntelliPan = ipVertical
          URLColor = clBlue
          URLShow = False
          URLFull = False
          URLEdit = False
          ScrollType = ssNormal
          ScrollColor = clNone
          ScrollWidth = 17
          ScrollSynch = False
          ScrollProportional = False
          ScrollHints = shNone
          OemConvert = False
          FixedFooters = 0
          FixedRightCols = 0
          FixedColWidth = 100
          FixedRowHeight = 19
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = []
          FixedAsButtons = False
          FloatFormat = '%.4f'
          IntegralHeight = False
          WordWrap = False
          ColumnHeaders.Strings = (
            'ca'
            'cw')
          Lookup = False
          LookupCaseSensitive = False
          LookupHistory = False
          BackGround.Top = 0
          BackGround.Left = 0
          BackGround.Display = bdTile
          BackGround.Cells = bcNormal
          Filter = <>
        end
      end
    end
  end
  object dxBarManager1: TdxBarManager
    AllowReset = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Bars = <
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'RE-Toolbar'
        DockControl = dxBarDockControl1
        DockedDockControl = dxBarDockControl1
        DockedLeft = 0
        DockedTop = 0
        FloatLeft = 362
        FloatTop = 202
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = miReAdd
            Visible = True
          end
          item
            Item = miReEdit
            Visible = True
          end
          item
            Item = miReDel
            Visible = True
          end
          item
            BeginGroup = True
            Item = miPolImport
            UserDefine = [udPaintStyle]
            UserPaintStyle = psCaptionGlyph
            Visible = True
          end>
        Name = 'RE-Toolbar'
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = True
        WholeRow = True
      end
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'Polarwerte'
        DockControl = dxBarDockControl2
        DockedDockControl = dxBarDockControl2
        DockedLeft = 0
        DockedTop = 0
        FloatLeft = 404
        FloatTop = 343
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = miPolAdd
            Visible = True
          end
          item
            Item = miPolDel
            Visible = True
          end>
        Name = 'Polarwerte'
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = True
        WholeRow = True
      end
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'Koordinaten'
        DockControl = dxBarDockControl3
        DockedDockControl = dxBarDockControl3
        DockedLeft = 0
        DockedTop = 0
        FloatLeft = 418
        FloatTop = 295
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = miCoordAdd
            Visible = True
          end
          item
            Item = miCoordDel
            Visible = True
          end
          item
            BeginGroup = True
            Item = miCoordImport
            UserDefine = [udPaintStyle]
            UserPaintStyle = psCaptionGlyph
            Visible = True
          end
          item
            Item = dxBarButton1
            UserDefine = [udPaintStyle]
            UserPaintStyle = psCaptionGlyph
            Visible = True
          end>
        Name = 'Koordinaten'
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = True
        WholeRow = True
      end>
    Categories.Strings = (
      'RE'
      'Polarwerte'
      'Koordinaten')
    Categories.ItemsVisibles = (
      2
      2
      2)
    Categories.Visibles = (
      True
      True
      True)
    Images = ImageList1
    NotDocking = [dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    Style = bmsFlat
    UseSystemFont = True
    Left = 248
    Top = 16
    DockControlHeights = (
      0
      0
      0
      0)
    object miReAdd: TdxBarButton
      Caption = 'Hinzuf'#252'gen'
      Category = 0
      Hint = 'RE-Zahl hinzuf'#252'gen'
      Visible = ivAlways
      ImageIndex = 1
      OnClick = miReAddClick
    end
    object miReDel: TdxBarButton
      Caption = 'L'#246'schen'
      Category = 0
      Hint = 'RE-Zahl l'#246'schen'
      Visible = ivAlways
      ImageIndex = 2
      OnClick = miReDelClick
    end
    object miPolAdd: TdxBarButton
      Caption = 'Hinzuf'#252'gen'
      Category = 1
      Hint = 'Hinzuf'#252'gen'
      Visible = ivAlways
      ImageIndex = 1
      OnClick = miPolAddClick
    end
    object miReEdit: TdxBarButton
      Caption = 'Bearbeiten'
      Category = 0
      Hint = 'RE-Zahl bearbeiten'
      Visible = ivAlways
      ImageIndex = 0
      OnClick = miReEditClick
    end
    object miPolDel: TdxBarButton
      Caption = 'Bearbeiten'
      Category = 1
      Hint = 'Bearbeiten'
      Visible = ivAlways
      ImageIndex = 2
      OnClick = miPolDelClick
    end
    object miCoordAdd: TdxBarButton
      Caption = '&Hinzuf'#252'gen'
      Category = 2
      Hint = 'Koordinatenpaar hinzuf'#252'gen'
      Visible = ivAlways
      ImageIndex = 1
      OnClick = miCoordAddClick
    end
    object miCoordDel: TdxBarButton
      Caption = '&L'#246'schen'
      Category = 2
      Hint = 'Koordinatenpaar l'#246'schen'
      Visible = ivAlways
      ImageIndex = 2
      OnClick = miCoordDelClick
    end
    object miCoordImport: TdxBarButton
      Caption = '&Koordinaten importieren'
      Category = 2
      Hint = 'Koordinaten importieren'
      Visible = ivAlways
      ImageIndex = 3
      OnClick = miCoordImportClick
    end
    object miPolImport: TdxBarButton
      Caption = 'Polaren importieren'
      Category = 0
      Hint = 'Polaren aus PEF-Datei importieren'
      Visible = ivAlways
      ImageIndex = 3
      OnClick = miPolImportClick
    end
    object dxBarButton1: TdxBarButton
      Caption = 'Koordinaten exportieren'
      Category = 0
      Hint = 'Koordinaten exportieren'
      Visible = ivAlways
      ImageIndex = 4
      OnClick = dxBarButton1Click
    end
  end
  object ImageList1: TImageList
    Left = 328
    Top = 16
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
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
      0000000000000000000000000000000000000000000000808000000000000000
      0000C0C0C0000000000000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000C0C0C000C0C0
      C000C0C0C000C0C0C00000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000037
      5700000000000000000000000000000000000000000000808000C0C0C000C0C0
      C000C0C0C000C0C0C00000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000D2C6C0001E95
      DB000995D900DCCEC70080808000808080000000000000808000C0C0C000C0C0
      C000C0C0C000C0C0C00000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FFFFFF00E5E3E100D6DF
      E60026B2FF00F0E3DC00EDEDED00FFF8F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A4A0A000CDCDCD00E3E0
      DE00EEE1D900DDDDDD00E3E3E30099999900B4A59D00A5A5A5009C9C9C00DEDE
      DE000000FF00D4D4D400A4A0A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A4A0A000BFBF
      BF00B4B4B400B0B0B000A6A6A600FFFFFF00ECECEC00E6E6E600E0E0E0000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A4A0
      A000FFFFFF00FFFFFF00F7F7F700F3F3F300E4E4E400E0E0E000DBDBDB00CECE
      CE000000FF00A4A0A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A4A0A000FFFFFF00F9F9F900F1F1F100EDEDED00DFDFDF00D7D7D700D1D1
      D1000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A4A0A000E7E7E700FFFFFF00F0F0F000ECECEC00E0E0E000D3D3D3000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A4A0A000E7E7E700FDFDFD000000FF000000FF000000FF00A4A0
      A000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A4A0A000FFFFFF00FFFFFF00E5E5E500A4A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A4A0A000A4A0A000A4A0A000A4A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C2C2C200C2C2C200C2C2C200C2C2C200000000000000
      00000000000000000000000000000000000000000000CECECE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000003757000000000000000000000000000000000000385800000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C2C2C200A4A0A000A4A0A000A4A0A000A4A0A000C2C2C2000000
      000000000000000000000000000000000000CECECE00A4A0A000CECECE000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000D2C6
      C0001E95DB000995D900DCCEC7008080800080808000119EEB00808080008080
      800080808000808080008080800080808000000000000000000080808000B1E1
      FE0084A9BE007695A90058717F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF8E8E00B90000009600000096000000A4A0A000C2C2C2000000
      00000000000000000000000000000000000001008000CECECE00A4A0A000CECE
      CE00000000000000000000000000000000000000000000000000000000000000
      0000CECECE000000000000000000000000000000000080808000FFFFFF00E5E3
      E100D6DFE60026B2FF00F0E3DC00EDEDED00FFF8F00001A5FF00FFF8F000F8F8
      F800B0B0B000B0B0B000D4D4D400A4A0A00000000000000000000000000093BC
      D300B1E1FE0083A9BF007695A90058717F0058717F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFB1B100FF6B6B00B900000096000000A4A0A000C2C2C2000000
      0000000000000000000000000000000000000000000001008000A4A0A000A4A0
      A000CECECE00000000000000000000000000000000000000000000000000CECE
      CE00A4A0A000CECECE0000000000000000000000000000000000A4A0A000CDCD
      CD00E3E0DE00EEE1D900DDDDDD00E3E3E30099999900B4A59D00A5A5A5009C9C
      9C00DEDEDE00D4D4D400D4D4D400A4A0A0000000000000000000000000000000
      000093BCD300B1E1FE0084A9BE007695A90057717F0058717F0058717F000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFB1B100FF6B6B00B900000096000000A4A0A000C2C2C2000000
      000000000000000000000000000000000000000000000100DB000000AB00A4A0
      A000A4A0A000CECECE0000000000000000000000000000000000000000000100
      8000A4A0A000CECECE000000000000000000000000000000000000000000A4A0
      A000BFBFBF00B4B4B400B0B0B000A6A6A600FFFFFF00ECECEC00E6E6E600E0E0
      E000D0D0D000DBDBDB00A4A0A000000000000000000000000000000000000000
      00000000000093BCD300B0E2FF0084A9BE0084A8BE007695A90058717F005770
      7F0058717F0000000000000000000000000000000000C2C2C200C2C2C200C2C2
      C200C2C2C200FFB1B100FF6B6B00B900000073000000A4A0A000C2C2C200C2C2
      C200C2C2C200C2C2C200C2C2C2000000000000000000000000000000DA000000
      B200A4A0A000A4A0A000CECECE00000000000000000000000000000000000000
      7F00A4A0A000CECECE0000000000000000000000000000000000000000000000
      0000A4A0A000FFFFFF00FFFFFF00F7F7F700F3F3F300E4E4E400E0E0E000DBDB
      DB00CECECE00CBCBCB00A4A0A000000000000000000000000000000000000000
      00000000000084A9BE0093BCD300B1E1FE0083A9BF0084A9BE0084A8BE006783
      93006783930057707F000000000000000000C2C2C200A4A0A000A4A0A000A4A0
      A000A4A0A000FFB1B100FF6B6B00B900000073000000A4A0A000A4A0A000A4A0
      A000A4A0A000A4A0A000A4A0A000C2C2C20000000000000000006463FF000000
      D7000000B500A4A0A000A4A0A000CECECE00000000000000000000007F000000
      7F00CECECE000000000000000000000000000000000000000000000000000000
      000000000000A4A0A000FFFFFF00F9F9F900F1F1F100EDEDED00DFDFDF00D7D7
      D700D1D1D100A4A0A00000000000000000000000000000000000000000000000
      0000000000000000000084A8BE0093BCD300B1E1FE0093BCD30092BCD40084A8
      BE007695A90067839300027D990000000000FFB1B10073000000730000009600
      000096000000B9000000FF6B6B00B90000007300000073000000730000007300
      00009600000096000000A4A0A000C2C2C2000000000000000000000000005D5C
      FF000000D3000000BE00A4A0A000A4A0A000CECECE000000000000007F00A4A0
      A000CECECE000000000000000000000000000000000000000000000000000000
      000000000000A4A0A000E7E7E700FFFFFF00F0F0F000ECECEC00E0E0E000D3D3
      D300A4A0A0000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084A9BE0092BCD400B1E1FE0093BCD30093BC
      D30083A9BF007695A9000395B800027D9900FFD4D400FF6B6B00B9000000B900
      0000B9000000B9000000B9000000FF252500B9000000B9000000B9000000B900
      0000B900000096000000A4A0A000C2C2C2000000000000000000000000000000
      0000000000000000D1000000C100A4A0A000A4A0A00000007F0001008000CECE
      CE00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFD00EFEFEF00E0E0E000D4D4
      D400A4A0A0000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084A8BE0084A9BE0093BCD300B1E1FE000395
      B80093BCD30084A9BE000395B9000396B900FFFFFF00FF6B6B00FF6B6B00FF6B
      6B00FF6B6B00FF6B6B00FF6B6B00B9000000FF252500FF6B6B00FF6B6B00FF6B
      6B00FF6B6B00B9000000A4A0A000C2C2C2000000000000000000000000000000
      000000000000000000000000CA000000C800A4A0A00001008000A4A0A000CECE
      CE00CECECE000000000000000000000000000000000000808000000000000000
      0000C0C0C000000000000080800000000000FFFFFF00FFFFFF00E5E5E500A4A0
      A000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084A9BE0083A8BE0093BCD3000395
      B80004B4DF002A90A8000395B8000395B800FFFFFF00FFD4D400FFD4D400FFB1
      B100FFB1B100FFB1B100FF6B6B00B9000000B9000000FFAB8E00FFB1B100FFB1
      B100FFB1B100FF8E8E00C2C2C200000000000000000000000000000000000000
      00000000000000000000CECECE000000C8001111F10000009D00A4A0A000A4A0
      A000A4A0A000CECECE00CECECE00000000000000000000808000000000000000
      000000000000000000000080800000000000A4A0A000A4A0A000A4A0A000A4A0
      A000000000000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084A8BE0084A9BE0084A9BE000396
      B90083EBFD0037D7FB002B90A8000395B8000000000000000000000000000000
      000000000000FFB1B100FF6B6B00B900000096000000A4A0A000C2C2C2000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CECECE0000008B002D2CF700706FFF003636F8000100BA000100
      8000A4A0A000A4A0A000A4A0A000CECECE000000000000808000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004B4DF0004B3DE009BF1
      FE00A6F4FE0082ECFE0037D7FB002B90A8000000000000000000000000000000
      000000000000FFB1B100FF6B6B00B900000096000000A4A0A000C2C2C2000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CECECE00000087000C0BF4006463FF00CECECE003B3AFC005959FD000000
      D9000100800001008000A4A0A000CECECE000000000000808000C0C0C000C0C0
      C000C0C0C000C0C0C00000808000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005ABED30083EB
      FE009AF2FF00A6F4FE0083EBFD0037D7FB000000000000000000000000000000
      000000000000FFD4D400FF6B6B00B900000096000000A4A0A000C2C2C2000000
      000000000000000000000000000000000000000000000000000000000000CECE
      CE0000007F000807F2006C6BFF00CECECE000000000000000000000000007474
      FE000000AB0001008000A4A0A000CECECE000000000000808000C0C0C000C0C0
      C000C0C0C000C0C0C00000808000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000059BF
      D40083EBFE009AF2FF00A6F3FD0082ECFE000000000000000000000000000000
      000000000000FFFFFF00FF6B6B00FF6B6B0096000000A4A0A000C2C2C2000000
      0000000000000000000000000000000000000000000000000000000000000100
      80000504F0007574FF00CECECE00000000000000000000000000000000000000
      0000C3C3FE000000AB00CECECE00000000000000000000808000C0C0C000C0C0
      C000C0C0C000C0C0C00000808000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005ABED30083EBFE009BF1FE00A6F3FD000000000000000000000000000000
      000000000000FFFFFF00FFD4D400FFD4D400FFB1B100C2C2C200000000000000
      000000000000000000000000000000000000000000000000000000000000A09F
      FF007978FF00CECECE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF0000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF80000000000000FF00000000000000
      FF00000000000000FF00000000000000FF00000000000000EF00000000000000
      800000000000000000000000000000008001000000000000C003000000000000
      E003000000000000F007000000000000F00F000000000000F80F000000000000
      FC1F000000000000FE1F0000000000008FFFFC3FBFFFF7BFC7FFF81F1FFFC000
      C1FFF81F0FF78000E07FF81F87E3C000F01FF81F83E3E001F8078001C1E3F001
      F8030000C0C7F803FC010000E047F807FE000000F80F8007FE000000FC07000F
      FF000001FC01000BFF00F81FF80000F1FF80F81FF00000FBFFC0F81FE0E000FB
      FFE0F81FE1F100F7FFF0F83FE3FF008F00000000000000000000000000000000
      000000000000}
  end
  object dlgImportKOO: TOpenDialog
    DefaultExt = 'koo'
    Filter = 'Koordinaten-Dateien (.KOO)|*.koo|Alle Dateien|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'KOO-Datei importieren'
    Left = 408
    Top = 16
  end
  object dlgImportPEF: TOpenDialog
    DefaultExt = 'pef'
    Filter = 'Polaren-Dateien (.PEF)|*.pef|Alle Dateien|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'PEF-Datei importieren'
    Left = 488
    Top = 16
  end
  object dlgExportKoo: TSaveDialog
    DefaultExt = 'koo'
    Filter = 'KOO Dateien|*.koo|Alle Dateien|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Exportieren in .KOO Datei'
    Left = 408
    Top = 104
  end
  object translator: TidTranslator
    DataProvider = dmMain.idTranslationProvider
    Left = 288
    Top = 56
  end
end
