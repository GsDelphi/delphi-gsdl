object GsThemeEditor: TGsThemeEditor
  Left = 193
  Top = 114
  BorderIcons = [biSystemMenu]
  Caption = ' - Image Selector'
  ClientHeight = 490
  ClientWidth = 673
  Color = clBtnFace
  Constraints.MinHeight = 458
  Constraints.MinWidth = 665
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    673
    490)
  PixelsPerInch = 96
  TextHeight = 13
  object ImgGroove: TImage
    Left = 28
    Top = 492
    Width = 18
    Height = 18
    AutoSize = True
    Picture.Data = {
      07544269746D61704E010000424D4E0100000000000076000000280000001200
      0000120000000100040000000000D80000000000000000000000100000001000
      000000000000000080000080000000808000800000008000800080800000C0C0
      C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00666666666666666666000000666666668F66666666000000666666668F66
      666666000000666666668F66666666000000666666668F666666660000006666
      66668F66666666000000666666668F66666666000000666666668F6666666600
      0000666666668F66666666000000666666668F66666666000000666666668F66
      666666000000666666668F66666666000000666666668F666666660000006666
      66668F66666666000000666666668F66666666000000666666668F6666666600
      0000666666668F66666666000000666666666666666666000000}
    Visible = False
  end
  object ImgSpacer: TImage
    Left = 52
    Top = 492
    Width = 18
    Height = 18
    AutoSize = True
    Picture.Data = {
      07544269746D61704E010000424D4E0100000000000076000000280000001200
      0000120000000100040000000000D80000000000000000000000100000001000
      000000000000000080000080000000808000800000008000800080800000C0C0
      C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00666666666666666666000000666660060060066666000000666660666666
      0666660000006666606666660666660000006666666666666666660000006666
      6666666666666600000066666066666606666600000066666066666606666600
      0000666666666666666666000000666666666666666666000000666660666666
      0666660000006666606666660666660000006666666666666666660000006666
      6666666666666600000066666066666606666600000066666066666606666600
      0000666660060060066666000000666666666666666666000000}
    Visible = False
  end
  object BtnDone: TRzButton
    Left = 588
    Top = 463
    ModalResult = 1
    Caption = 'Close'
    HotTrack = True
    TabOrder = 0
  end
  object RzPageControl1: TRzPageControl
    Left = 8
    Top = 8
    Width = 657
    Height = 449
    Hint = ''
    ActivePage = TabSheet2
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 1
    TabOrder = 1
    OnChange = RzPageControl1Change
    FixedDimension = 19
    object TabSheet1: TRzTabSheet
      Caption = 'TabSheet1'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet2: TRzTabSheet
      Caption = 'TabSheet2'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GrpImageList: TRzGroupBox
        Left = 3
        Top = 13
        Width = 169
        Height = 410
        BorderWidth = 4
        Caption = 'Images'
        TabOrder = 0
        object LstImageList: TRzListBox
          Left = 5
          Top = 14
          Width = 159
          Height = 391
          Align = alClient
          Columns = 3
          ExtendedSelect = False
          FrameVisible = True
          HorzScrollBar = True
          ItemHeight = 18
          OwnerDrawIndent = 26
          Sorted = True
          Style = lbOwnerDrawFixed
          TabOrder = 0
          OnClick = LstImageListClick
          OnDrawItem = LstImageListDrawItem
        end
      end
      object GrpStockImages: TRzGroupBox
        Left = 178
        Top = 13
        Width = 466
        Height = 253
        BorderWidth = 4
        Caption = 'Stock Images'
        TabOrder = 1
        object LstFileList: TRzListBox
          Left = 5
          Top = 14
          Width = 456
          Height = 234
          Align = alClient
          Columns = 2
          ExtendedSelect = False
          FrameVisible = True
          HorzScrollBar = True
          ItemHeight = 18
          OwnerDrawIndent = 26
          Sorted = True
          Style = lbOwnerDrawFixed
          TabOrder = 0
          OnClick = LstFileListClick
          OnDrawItem = LstFileListDrawItem
          OnStartDrag = LstFileListStartDrag
        end
        object PnlUpdateFiles: TRzPanel
          Left = 124
          Top = 98
          Width = 217
          Height = 57
          BorderOuter = fsNone
          TabOrder = 1
          Transparent = True
          Visible = False
          object PrgUpdateFiles: TRzProgressBar
            Left = 8
            Top = 24
            BarStyle = bsGradient
            BorderWidth = 0
            InteriorOffset = 0
            PartsComplete = 0
            Percent = 0
            TotalParts = 0
          end
          object LblUpdateFiles: TRzLabel
            Left = 8
            Top = 5
            Width = 81
            Height = 13
            Caption = 'LblUpdateFiles'
          end
        end
      end
      object GrpCustomImages: TRzGroupBox
        Left = 178
        Top = 272
        Width = 466
        Height = 110
        BorderWidth = 4
        Caption = 'Custom Images'
        TabOrder = 2
        object SbxCustom: TScrollBox
          Left = 5
          Top = 14
          Width = 456
          Height = 91
          VertScrollBar.Tracking = True
          Align = alClient
          BorderStyle = bsNone
          PopupMenu = MnuCustomImages
          TabOrder = 0
          OnResize = SbxCustomResize
        end
        object RzListView1: TRzListView
          Left = 5
          Top = 14
          Width = 456
          Height = 91
          Align = alClient
          Columns = <>
          Items.ItemData = {
            05220000000100000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000
            00045400650073007400}
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 8
          ExplicitWidth = 250
          ExplicitHeight = 150
        end
      end
      object ChkSetHint: TRzCheckBox
        Left = 178
        Top = 388
        Width = 105
        Height = 15
        Caption = 'Set Button &Hint'
        HotTrack = True
        State = cbUnchecked
        TabOrder = 3
      end
      object ChkAddDisabled: TRzCheckBox
        Left = 414
        Top = 388
        Width = 230
        Height = 28
        Caption = 
          'Add Disabled glyphs (if available) to ImageList when adding new ' +
          'images'
        Checked = True
        HotTrack = True
        State = cbChecked
        TabOrder = 4
        Visible = False
        WordWrap = True
      end
    end
    object TabSheet3: TRzTabSheet
      AlignWithMargins = True
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'TabSheet3'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      inline GsImageListEditor1: TGsImageListEditor
        Left = 0
        Top = 0
        Width = 645
        Height = 418
        Align = alClient
        Constraints.MinHeight = 300
        Constraints.MinWidth = 600
        TabOrder = 0
        ExplicitWidth = 645
        ExplicitHeight = 418
        inherited RzSplitter1: TRzSplitter
          Width = 645
          Height = 389
          Percent = 23
          ExplicitWidth = 645
          ExplicitHeight = 389
          UpperLeftControls = (
            GBImageList)
          LowerRightControls = (
            GBImageFiles)
          inherited GBImageList: TRzGroupBox
            Height = 389
            ExplicitHeight = 389
            inherited LBImageList: TRzListBox
              Height = 370
              ExplicitHeight = 370
            end
          end
          inherited GBImageFiles: TRzGroupBox
            Width = 491
            Height = 389
            ExplicitWidth = 491
            ExplicitHeight = 389
            inherited LBImageFileList: TRzListBox
              Width = 481
              Height = 370
              ExplicitWidth = 481
              ExplicitHeight = 370
            end
          end
        end
        inherited RzToolbar1: TRzToolbar
          Width = 645
          ExplicitWidth = 645
        end
        inherited PProgess: TRzPanel
          Top = 166
          Width = 344
          ExplicitTop = 166
          ExplicitWidth = 344
          inherited PBProgress: TRzProgressBar
            Width = 326
            ExplicitWidth = 334
          end
          inherited LProgress: TRzLabel
            Width = 56
            ExplicitWidth = 56
          end
        end
      end
    end
  end
  object MnuStock: TPopupMenu
    Left = 192
    Top = 368
    object MnuEditStockHint: TMenuItem
      Caption = 'Edit Hint...'
      OnClick = MnuEditStockHintClick
    end
  end
  object MnuCustomImages: TPopupMenu
    Left = 244
    Top = 320
    object AddCustomImage1: TMenuItem
      Caption = 'Add Custom Image...'
      OnClick = MnuAddClick
    end
  end
  object DlgOpenPicture: TOpenPictureDialog
    DefaultExt = 'bmp'
    FileName = 
      'D:\SW-Projekte\Images\iconex_o2\o_collection\o_collection_png\bl' +
      'ue_dark_grey\24x24\3d_glasses.png'
    Filter = 
      'All Image Files|*.bmp;*.png|Bitmap Files (*.bmp)|*.bmp|PNG File ' +
      '(*.png)|*.png'
    InitialDir = 
      'D:\SW-Projekte\Images\iconex_o2\o_collection\o_collection_png\bl' +
      'ue_dark_grey\16x16'
    Options = [ofHideReadOnly, ofNoChangeDir, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofNoTestFileCreate, ofNoNetworkButton, ofNoDereferenceLinks, ofEnableSizing]
    OptionsEx = [ofExNoPlacesBar]
    Left = 612
    Top = 340
  end
  object MnuCustom: TPopupMenu
    Left = 252
    Top = 364
    object MnuAdd: TMenuItem
      Caption = 'Add Image...'
      OnClick = MnuAddClick
    end
    object MnuSep1: TMenuItem
      Caption = '-'
    end
    object MnuEditCustomHint: TMenuItem
      Caption = 'Edit Hint...'
      OnClick = MnuEditCustomHintClick
    end
    object MnuDelete: TMenuItem
      Caption = 'Delete'
      OnClick = MnuDeleteClick
    end
  end
end
