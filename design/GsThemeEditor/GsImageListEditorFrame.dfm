object GsImageListEditor: TGsImageListEditor
  Left = 0
  Top = 0
  Width = 600
  Height = 300
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  TabOrder = 0
  OnResize = FrameResize
  DesignSize = (
    600
    300)
  object RzSplitter1: TRzSplitter
    Left = 0
    Top = 29
    Width = 600
    Height = 271
    MarginMax = 150
    MarginMin = 150
    Position = 150
    Percent = 25
    PercentMax = 90
    PercentMin = 10
    Align = alClient
    TabOrder = 1
    BarSize = (
      150
      0
      154
      271)
    UpperLeftControls = (
      GBImageList)
    LowerRightControls = (
      GBImageFiles)
    object GBImageList: TRzGroupBox
      Left = 0
      Top = 0
      Width = 150
      Height = 271
      Align = alClient
      BorderWidth = 4
      Caption = 'B&ildliste'
      TabOrder = 0
      object LBImageList: TRzListBox
        Left = 5
        Top = 14
        Width = 140
        Height = 252
        Align = alClient
        DoubleBuffered = False
        DragMode = dmAutomatic
        ExtendedSelect = False
        FrameVisible = True
        HorzScrollBar = True
        ItemHeight = 18
        OwnerDrawIndent = 26
        ParentDoubleBuffered = False
        Sorted = True
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnDrawItem = LBImageListDrawItem
      end
    end
    object GBImageFiles: TRzGroupBox
      Left = 0
      Top = 0
      Width = 446
      Height = 271
      Align = alClient
      BorderWidth = 4
      Caption = 'Bilddateien'
      TabOrder = 0
      object LBImageFileList: TRzListBox
        Left = 5
        Top = 14
        Width = 436
        Height = 252
        Align = alClient
        DoubleBuffered = False
        DragMode = dmAutomatic
        ExtendedSelect = False
        FrameVisible = True
        HorzScrollBar = True
        ItemHeight = 34
        OwnerDrawIndent = 34
        ParentDoubleBuffered = False
        Sorted = True
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnDblClick = LBImageFileListDblClick
        OnDrawItem = LBImageFileListDrawItem
        OnEndDrag = LBImageFileListEndDrag
        OnStartDrag = LBImageFileListStartDrag
      end
    end
  end
  object RzToolbar1: TRzToolbar
    Left = 0
    Top = 0
    Width = 600
    Height = 29
    ShowDivider = False
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdTop]
    BorderWidth = 0
    TabOrder = 0
  end
  object PProgess: TRzPanel
    Left = 129
    Top = 115
    Width = 299
    Height = 57
    Anchors = [akLeft, akRight]
    BorderOuter = fsPopup
    TabOrder = 2
    Transparent = True
    Visible = False
    DesignSize = (
      299
      57)
    object PBProgress: TRzProgressBar
      Left = 8
      Top = 24
      Width = 281
      Anchors = [akLeft, akTop, akRight]
      BarStyle = bsGradient
      BorderWidth = 0
      InteriorOffset = 0
      PartsComplete = 0
      Percent = 0
      TotalParts = 0
    end
    object LProgress: TRzLabel
      Left = 8
      Top = 5
      Width = 47
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'LProgress'
    end
  end
end
