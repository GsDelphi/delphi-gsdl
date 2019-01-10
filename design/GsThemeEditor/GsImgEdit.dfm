object ImageListEditor: TImageListEditor
  Left = 0
  Top = 0
  Width = 892
  Height = 603
  Constraints.MinHeight = 306
  Constraints.MinWidth = 592
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  OnResize = FormResize
  DesignSize = (
    892
    603)
  object OK: TButton
    Left = 809
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Cancel: TButton
    Left = 809
    Top = 37
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
  end
  object Apply: TButton
    Left = 809
    Top = 67
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #220'&bernehmen'
    TabOrder = 2
    OnClick = ApplyClick
  end
  object RzSplitter1: TRzSplitter
    Left = 0
    Top = 0
    Width = 799
    Height = 603
    Position = 344
    Percent = 43
    Align = alLeft
    TabOrder = 3
    BarSize = (
      344
      0
      348
      603)
    UpperLeftControls = (
      ImageListGroup)
    LowerRightControls = (
      ImageGroup
      RzGroupBox1)
    object ImageListGroup: TRzGroupBox
      Left = 0
      Top = 0
      Width = 344
      Height = 603
      Align = alClient
      BorderWidth = 4
      Caption = 'B&ildliste'
      TabOrder = 0
      DesignSize = (
        344
        603)
      object ImageView: TRzListView
        Left = 5
        Top = 43
        Width = 334
        Height = 456
        Align = alTop
        Columns = <
          item
            Caption = 'asdf'
            Width = 100
          end>
        DragCursor = crArrow
        DragMode = dmAutomatic
        FrameColor = 12164479
        FrameVisible = True
        HideSelection = False
        IconOptions.Arrangement = iaLeft
        IconOptions.AutoArrange = True
        IconOptions.WrapText = False
        MultiSelect = True
        ReadOnly = True
        TabOrder = 0
        OnCompare = ImageViewCompare
        OnDragDrop = ImageViewDragDrop
        OnDragOver = ImageViewDragOver
        OnEndDrag = ImageViewEndDrag
        OnSelectItem = ImageViewSelectItem
      end
      object Add: TButton
        Left = 10
        Top = 480
        Width = 100
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Hin&zuf'#252'gen...'
        TabOrder = 1
        OnClick = AddClick
      end
      object Delete: TButton
        Left = 10
        Top = 511
        Width = 100
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = '&L'#246'schen'
        Enabled = False
        TabOrder = 2
        OnClick = DeleteClick
      end
      object Clear: TButton
        Left = 116
        Top = 511
        Width = 100
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = '&Alle l'#246'schen'
        Enabled = False
        TabOrder = 3
        OnClick = ClearClick
      end
      object ReplaceBtn: TButton
        Left = 116
        Top = 480
        Width = 100
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = '&Ersetzen...'
        Enabled = False
        TabOrder = 4
        OnClick = AddClick
      end
      object RzToolbar1: TRzToolbar
        Left = 5
        Top = 14
        Width = 334
        Height = 29
        Images = ActionImages
        ShowDivider = False
        BorderInner = fsNone
        BorderOuter = fsNone
        BorderSides = [sdTop]
        BorderWidth = 0
        TabOrder = 5
        ToolbarControls = (
          TBNew
          TBOpen
          TBRefresh
          RzSpacer1
          TBSaveAll
          RzSpacer2
          TBExport
          TBDelete
          TBClear
          RzSpacer3
          TBUp
          TBDown)
        object TBSaveAll: TRzToolButton
          Left = 87
          Top = 2
          Hint = 'Save All'
          DisabledIndex = 1
          ImageIndex = 4
          Caption = 'Save All'
        end
        object TBDelete: TRzToolButton
          Left = 145
          Top = 2
          Hint = 'Delete'
          DisabledIndex = 3
          ImageIndex = 5
          Caption = 'Delete'
        end
        object TBClear: TRzToolButton
          Left = 170
          Top = 2
          Hint = 'Clear'
          DisabledIndex = 5
          ImageIndex = 6
          Caption = 'Clear'
        end
        object TBRefresh: TRzToolButton
          Left = 54
          Top = 2
          Hint = 'Refresh'
          DisabledIndex = 7
          ImageIndex = 2
          Caption = 'Refresh'
        end
        object TBUp: TRzToolButton
          Left = 203
          Top = 2
          Hint = 'Up'
          DisabledIndex = 9
          ImageIndex = 7
          Caption = 'Up'
        end
        object TBDown: TRzToolButton
          Left = 228
          Top = 2
          Hint = 'Down'
          DisabledIndex = 11
          ImageIndex = 8
          Caption = 'Down'
        end
        object RzSpacer1: TRzSpacer
          Left = 79
          Top = 2
        end
        object RzSpacer2: TRzSpacer
          Left = 112
          Top = 2
        end
        object RzSpacer3: TRzSpacer
          Left = 195
          Top = 2
        end
        object TBExport: TRzToolButton
          Left = 120
          Top = 2
          Hint = 'Export'
          DisabledIndex = 13
          ImageIndex = 3
          Caption = 'Export'
        end
        object TBNew: TRzToolButton
          Left = 4
          Top = 2
          Hint = 'New'
          DisabledIndex = 15
          ImageIndex = 0
          Caption = 'New'
        end
        object TBOpen: TRzToolButton
          Left = 29
          Top = 2
          Hint = 'Open'
          DisabledIndex = 17
          ImageIndex = 1
          Caption = 'Open'
        end
      end
    end
    object ImageGroup: TRzGroupBox
      Left = 0
      Top = 0
      Width = 451
      Height = 145
      Align = alTop
      Caption = ' Ausge&w'#228'hltes Bild '
      TabOrder = 0
      DesignSize = (
        451
        145)
      object OptionsPanel: TRzPanel
        Left = 93
        Top = 11
        Width = 355
        Height = 131
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderOuter = fsNone
        TabOrder = 1
        DesignSize = (
          355
          131)
        object FillLabel: TRzLabel
          Left = 10
          Top = 42
          Width = 372
          Height = 13
          AutoSize = False
          Caption = '&F'#252'llfarbe:'
          Transparent = False
        end
        object TransparentLabel: TRzLabel
          Left = 10
          Top = 0
          Width = 372
          Height = 13
          AutoSize = False
          Caption = '&Transparente Farbe:'
          Transparent = False
        end
        object OptionsGroup: TRzRadioGroup
          Left = 10
          Top = 82
          Width = 338
          Height = 37
          Anchors = [akLeft, akTop, akRight]
          Caption = ' Optionen '
          Columns = 3
          Enabled = False
          ItemFrameColor = 8409372
          ItemHotTrack = True
          ItemHighlightColor = 2203937
          ItemIndex = 0
          Items.Strings = (
            'Z&uschneiden'
            '&Dehnen'
            'Ze&ntrieren')
          TabOrder = 0
          OnClick = OptionsGroupClick
        end
        object FillColor: TColorBox
          Left = 10
          Top = 56
          Width = 338
          Height = 22
          DefaultColorColor = clWindow
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnChange = FillColorChange
        end
        object TransparentColor: TColorBox
          Left = 10
          Top = 14
          Width = 338
          Height = 22
          DefaultColorColor = clWindow
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          OnChange = TransparentColorChange
        end
      end
      object MainPanel: TRzPanel
        Left = 10
        Top = 18
        Width = 78
        Height = 78
        BorderOuter = fsFlatRounded
        BorderWidth = 5
        ParentColor = True
        TabOrder = 0
        object MainImage: TImage
          Left = 7
          Top = 7
          Width = 64
          Height = 64
          Align = alClient
          Stretch = True
          OnMouseDown = MainImageMouseDown
          OnMouseMove = MainImageMouseMove
          OnMouseUp = MainImageMouseUp
          ExplicitLeft = 5
          ExplicitTop = 5
          ExplicitWidth = 60
          ExplicitHeight = 60
        end
      end
    end
    object RzGroupBox1: TRzGroupBox
      Left = 0
      Top = 145
      Width = 451
      Height = 458
      Align = alClient
      BorderWidth = 4
      Caption = 'RzGroupBox1'
      TabOrder = 1
      object FileView: TRzListView
        Left = 5
        Top = 14
        Width = 441
        Height = 439
        Align = alClient
        Columns = <
          item
            Caption = 'asdf'
            Width = 100
          end>
        DragCursor = crArrow
        DragMode = dmAutomatic
        FrameColor = 12164479
        FrameVisible = True
        HideSelection = False
        IconOptions.Arrangement = iaLeft
        IconOptions.AutoArrange = True
        IconOptions.WrapText = False
        MultiSelect = True
        ReadOnly = True
        TabOrder = 0
        OnCompare = ImageViewCompare
        OnDragDrop = ImageViewDragDrop
        OnDragOver = ImageViewDragOver
        OnEndDrag = ImageViewEndDrag
        OnSelectItem = ImageViewSelectItem
      end
    end
  end
  object OpenDialog: TOpenPictureDialog
    HelpContext = 27000
    DefaultExt = 'bmp'
    Filter = 
      'Alle (*.bmp, *.ico)|*.bmp;*.ico|Bitmaps (*.bmp)|*.bmp|Symbole (*' +
      '.ico)|*.ico'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Title = 'Bilder hinzuf'#252'gen'
    Left = 32
    Top = 232
  end
  object DragTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = DragTimerTimer
    Left = 32
    Top = 280
  end
  object SaveDialog: TSavePictureDialog
    HelpContext = 27010
    DefaultExt = 'bmp'
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Options = [ofOverwritePrompt, ofEnableSizing]
    Title = 'Bilder exportieren'
    Left = 32
    Top = 184
  end
  object ActionImages: TImageList
    Left = 32
    Top = 136
    Bitmap = {
      494C010109005400540010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001001000000000000018
      00000000000000000000000000000000000000000000B556CF62C96AC472C272
      A072806E806A406644626C5AB556000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000CE62E772E772067B257F227F
      007FE07EC07A8072606A2062005E6B5A00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000E772087B487F477F247F227F
      007FE07EC07AA0768072606E2062E05900000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000CC6AE772487F267F247F027F
      007FE07EA07AA0768072606E005E485A00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000B556E772077B467F247F027F
      007FE07EA07AA07680724066005EB55600000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CF62E772477F247F027F
      007FE07AC07AA076807220626C5A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000E772E676247F017F
      007FC07AC076A076406620620000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000D15EC672247F017F
      007FC07AC076A0724062905A0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C772C476227F
      007FE07AC07A8242832E632A693A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B35AC472017F
      007FE07AA0766242C432A432893A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000C86AC172
      007FE07E606A8442C432C432893A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000B55AC272
      C07AC24EA342A32EE432C432832E88368A3A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AA66
      A072A062C432E43204370437A432832EB24E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      A072806ED14EC332E432E432A32EB04A00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      AD62AD5E0000CE46E332C432AE46000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000CB42CB420000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B456893A02260932B456
      00008E29113EF85A185F5B675A67F0354C2500000000B556CF62C96AC472C272
      A072806E806A406644626C5AB5560000000000000000B456893A02260932B456
      0000B5560661725A00000000525AA458B55600000000B556CF62C96AC472C272
      A072806E806A40666442673EB55600000000B4528836632A632A432AE221E221
      272EAE2D744A5446F856DE77BE77333E6C250000CE62E772E772067B257F227F
      007FE07EC07A8072606A2062005E6B5A0000B4528836632A632A432AE221E221
      272E07610765E660725A725AC55CC55CA4580000CE62E772E772067B257F227F
      007FE07EC07A8156832E632A214A6B5A0000832E832EC432C432632A23262326
      E221AE2D5446D756195F9D739D6F123E6D250000E772087B487F477F247F227F
      007F28692765076106650665066506650665832E832EC432C432632A23262326
      E221C33107650765E664E660E660C55C525A0000E772087B487F477F247F227F
      007FE07EC166A32EA432A42E632A004E0000832EE436E432C432832A4326432A
      432AAF2DCC41CB45CB45AB41AB41AB3D6D250000CC6AE772487F267F247F027F
      007F486949752871286D286D286D28710665832EE436E432C432832A4326432A
      432A0322426E0765286D276DE660C15D905A0000CC6AE772487F267F247F027F
      007FE06EC432C4320437E436A32E832AB24EA32EE432C436C432832E432A432A
      432AAF2D0576037E237E237E237E05766D290000B556E772077B467F247F027F
      007F496D2869286507610661066506650665A32EE432C436C432832E432A432A
      432A432A817607692871286D0665E161E0590000B556E772077B467F247F027F
      007FE24EC346C332E436E432832E87368A3EA32EE436C432C432832E632A632A
      632AAF319E67DF6FDF6BDF6BDF6B9E5F8D2500000000CF62E772477F247F027F
      007FE07AC07AA076807220626C5A00000000A32EE436C432C432832E632A632A
      632A243628652869276507650765E660E55900000000CF62E772477F247F027F
      007FE07AC07AC24A04370437863E00000000A32E0437E43204370437C332832E
      632AAF31BE6BDF73DF6FDF6FDF6F9E676D29000000000000E772E676247F017F
      007FC07AC076A07640662062000000000000A32E0437E43204370437C332832E
      632A496D496D28658176617207650665E660000000000000E772E676247F017F
      007FC07AC076C24A243B0437AA3E00000000C432E436243B24370437E436E436
      C32ECF313A637C677C677C637C673A5B8E29000000000000D15EC672247F017F
      007FC07AC076A0724062905A000000000000C432E436243B24370437E436E436
      C32E842E496DA27AC07EA07601660765B556000000000000D15EC672247F017F
      007FC07AC076E34AE432C332C93E00000000CF4AE436E4320437243704370433
      643EE66A237F007FC07AA0724062B55600000000000000000000C772C476227F
      007FE07AC07A606A42620000000000000000CF4AE436E4320437243704370433
      643EE66A237F007FC07AA0724062B55600000000000000000000C772C476227F
      007FE07AC07A606A42620000000000000000000000004C52A64A4437A546A865
      28710676237F007FE07E606A685E000000000000000000000000B35AC472017F
      007FE07AA0764066B25A0000000000000000000000004C52A64A4437A546A865
      28710676237F007FE07E606A685E000000000000000000000000B35AC472017F
      007FE07AA0764066B25A000000000000000000000000EE658B75CB758B796A79
      4971286D037F007FA076606AB5560000000000000000000000000000C86AC172
      007FE07E606A66620000000000000000000000000000EE658B75CB758B796A79
      4971286D037F007FA076606AB5560000000000000000000000000000C86AC172
      007FE07E606A666200000000000000000000000000001062AC6DCE79CD798B79
      69752871E575007F806E896200000000000000000000000000000000B55AC272
      C07AA076606AB55600000000000000000000000000001062AC6DCE79CD798B79
      69752871E575007F806E896200000000000000000000000000000000B55AC272
      C07AA076606AB5560000000000000000000000000000945AEE6D0F76EE79AC79
      6A79286D0765C07A806E0000000000000000000000000000000000000000AA66
      A072806E8A6200000000000000000000000000000000945AEE6D0F76EE79AC79
      6A79286D0765C07A806E0000000000000000000000000000000000000000AA66
      A072806E8A620000000000000000000000000000000000005166EE6DED75AC79
      697127658C5DAB62AA6200000000000000000000000000000000000000000000
      A072806E00000000000000000000000000000000000000005166EE6DED75AC79
      697127658C5DAB62AA6200000000000000000000000000000000000000000000
      A072806E000000000000000000000000000000000000000000003162AC6D6A6D
      4869CE5D0000B556B55600000000000000000000000000000000000000000000
      AD62AD5E000000000000000000000000000000000000000000003162AC6D6A6D
      4869CE5D0000B556B55600000000000000000000000000000000000000000000
      AD62AD5E00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B556CF62C96AC472C272
      A072806E806A605E842E642EB24E000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B456893A02260932B456
      0000973E7B167B167A1A5A0E5A12B64A00000000000000000000000000000000
      0000B64E98320000000000000000000000000000CE62E772E772067B257F227F
      007FE07EC07A8166A536843220566B5A00000000000000000000000000000000
      000000000000000000000000000000000000B4528836632A632A432AE221E221
      272E954A7B1ABD1E7A265A165B0E5A0EB64A00000000B35268360226072E9352
      B64E7A16792A0000000000000000000000000000E772087B487F477F247F227F
      007FE172C16EA162C636A53241520052B25200006666804D804D804D804D804D
      804D804D804D804D804D2C67000000000000832E832EC432C432632A23262326
      E221791A7B1A953A953AB05AB6467B0E5A12B04A8532632A832E632AE2210522
      7A1A7B1A7B167A125B125B0E9742000000000000CC6AE772487F267F247F027F
      007FE73AE73AC636E73AC63AA532A532842E66666666F37F2C7F2C7F2C7F2C7F
      2C7F2C7F2C7F2C7F6666804D000000000000832EE436E432C432832A4326432A
      432A7B1A9826C076A072606A4066581A5B0E832E832EC432C432632A2326462A
      DC22BD1E7B1A7B1A7B167B165A12983600000000B556E772077B467F247F027F
      007F083F083FE73A073FE73AC636C636A532666666662C7FF37FF37FF37FF37F
      F37FF37FF37FF37F2C7F804D666600000000A32EE432C436C432832E432A432A
      432A7B1A982A017FE07EC0768072581A5B12832EE436C432C432832A4326432A
      452ABB2299320000B5569A269C165A12B65200000000CF62E772477F247F027F
      007FE16EC16EC262073FE73A8A4EB252B252666666662C7FF37FF37FF37FF37F
      F37FF37FF37FF37F2C7F2C67804D00000000A32EE436C432C432832E632A632A
      632A9A1E9B22E66AC07A8F3E6F427A165A16832EE432E432C432832E432A432A
      632A462A8C52A072806E606E96327B169836000000000000E772E676247F017F
      007FC07AC076C16E2843073FD3520000000066662C7F6666F37FF37FF37FF37F
      F37FF37FF37FF37F2C7FF37F804D66660000A32E0437E43204370437C332832E
      632A882A9B229B22982E962EBD1E7B1AB54EA32EE436E432E432C432632A632A
      632A632AC07A017FE07EA076AF46BD1A2F36000000000000D15EC672247F017F
      007FC07AC076C16A2943083FD3520000000066662C7F2C672C67F37FF37FF37F
      F37FF37FF37FF37F2C7FF37F2C67804D0000C432E436243B24370437E436E436
      C32E832A086F9926BB229A227B1A7B1A9742A32E0437243B243B0437E436C432
      832E832AC07A007FC07AA07AD7369C1E513A0000000000000000C772C476227F
      007FE07AC07A606A426200000000000000006666F37F2C7F6666F97FF97FF97F
      F97FF97FF97FF97FF37FF97FF97F804D0000CF4AE436E4320437243704370433
      643EE66A237F007FC07AA0724062B5560000E632243B443B2437243BE432E436
      C332C442237F007FC07AA172DB2A9B22B5520000000000000000B35AC472017F
      007FE07AA0764066B25A00000000000000006666F37FF37F2C7F666666666666
      66666666666666666666666666662C7F0000000000004C52A64A4437A546A865
      28710676237F007FE07E606A685E00000000792A991ACA2EE336E432C332A636
      E962E67A247F007FC07EA076435E9242000000000000000000000000C86AC172
      007FE07E606A6662000000000000000000006666F97FF37FF37FF37FF37FF97F
      F97FF97FF97FF97F804D000000000000000000000000EE658B75CB758B796A79
      4971286D037F007FA076606AB55600000000983A7B167B16D456CC42B4567932
      B64E057B037F007FC07A806E4066B556000000000000000000000000B55AC272
      C07AA076606AB5560000000000000000000000006666F97FF97FF97FF97F6666
      666666666666666600000000000000000000000000001062AC6DCE79CD798B79
      69752871E575007F806E8962000000000000B6527B1A7B169A26B65600007826
      5B0ACE5E037F007FE07E606A8B5E00000000000000000000000000000000AA66
      A072806E8A620000000000000000000000000000000066666666666666660000
      000000000000000000000000D300D300D30000000000945AEE6D0F76EE79AC79
      6A79286D0765C07A806E00000000000000000000983E7B1A9B167A165B125B12
      9D127D0AE66EC07AA072606A0000000000000000000000000000000000000000
      A072806E00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D300D3000000000000005166EE6DED75AC79
      697127658C5DAB62AA62000000000000000000000000B7469B1A7B1A7B1A7B16
      7B125B0EAF56A072806EAE5E0000000000000000000000000000000000000000
      AD62AD5E00000000000000000000000000000000000000000000000000000000
      00000000D300000000000000D3000000D30000000000000000003162AC6D6A6D
      4869CE5D0000B556B5560000000000000000000000000000000000000000992E
      7A16B64E0000A072806E00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D300D300D3000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009836
      B64E00000000B15EB15E0000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00C0030000000000008001000000000000
      800100000000000080010000000000008001000000000000C003000000000000
      E007000000000000E007000000000000F003000000000000F003000000000000
      F803000000000000F800000000000000FC00000000000000FE01000000000000
      FE43000000000000FFE7000000000000C100C003C118C0030000800100008001
      0000800000008001000080000000800000008000000080000000C0030000C003
      0000E0070000E0030000E0070000E0030001F00F0001F00FC003F00FC003F00F
      C003F81FC003F81FC007F81FC007F81FC00FFC3FC00FFC3FE00FFE7FE00FFE7F
      F04FFE7FF04FFE7FFFFFFFFFFFFFFFFFC003FFFFC101FF3F8001FFFF0000C03F
      800080070000000380000007000000018000000300000020C000000300000000
      E003000100000000E003000100000000F00F000100010000F00F0001C0030001
      F81F000FC0030001F81F801FC0070403FC3FC3F8C00F8007FE7FFFFCE00FC007
      FE7FFFBAF04FFC4FFFFFFFC7FFFFFCCF00000000000000000000000000000000
      000000000000}
  end
end