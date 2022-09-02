object GsTheme1: TGsTheme1
  OldCreateOrder = False
  OnCreate = CustomGsThemeCreate
  Images.BasePath = 
    'D:\SW-Projekte\Images\iconex_o2\o_collection\o_collection_bmp\bl' +
    'ue_dark_grey'
  Images = <
    item
      ImageSize = is16x16
      List.ImageList = TplImages16
      List.DisabledImageList = TplDisabledImages16
      Stock.Path = '16x16'
      Stock.DisabledPath = 'disabled\16x16'
    end
    item
      ImageSize = is24x24
      List.ImageList = TplImages24
      List.DisabledImageList = TplDisabledImages24
      Stock.Path = '24x24'
      Stock.DisabledPath = 'disabled\24x24'
    end
    item
      ImageSize = is32x32
      List.ImageList = TplImages32
      List.DisabledImageList = TplDisabledImages32
      Stock.Path = '32x32'
      Stock.DisabledPath = 'disabled\32x32'
    end
    item
      ImageSize = is48x48
      List.ImageList = TplImages48
      List.DisabledImageList = TplDisabledImages48
      Stock.Path = '48x48'
      Stock.DisabledPath = 'disabled\48x48'
    end
    item
      ImageSize = is64x64
      List.ImageList = TplImages64
      List.DisabledImageList = TplDisabledImages64
      Stock.Path = '64x64'
      Stock.DisabledPath = 'disabled\64x64'
    end
    item
      ImageSize = is128x128
      List.ImageList = TplImages128
      List.DisabledImageList = TplDisabledImages128
      Stock.Path = '128x128'
      Stock.DisabledPath = 'disabled\128x128'
    end
    item
      ImageSize = is256x256
      List.ImageList = TplImages256
      List.DisabledImageList = TplDisabledImages256
      Stock.Path = '256x256'
      Stock.DisabledPath = 'disabled\256x256'
    end>
  Height = 109
  Width = 681
  object TplImages16: TImageList
    Tag = 1
    Left = 32
    Top = 8
  end
  object TplImages24: TImageList
    Tag = 1
    Height = 24
    Width = 24
    Left = 128
    Top = 8
  end
  object TplImages32: TImageList
    Tag = 1
    Height = 32
    Width = 32
    Left = 224
    Top = 8
  end
  object TplImages48: TImageList
    Tag = 1
    Height = 48
    Width = 48
    Left = 320
    Top = 8
  end
  object TplImages64: TImageList
    Tag = 1
    Height = 64
    Width = 64
    Left = 416
    Top = 8
  end
  object TplImages128: TImageList
    Tag = 1
    Height = 128
    Width = 128
    Left = 512
    Top = 8
  end
  object TplImages256: TImageList
    Tag = 1
    Height = 256
    Width = 256
    Left = 608
    Top = 8
  end
  object TplDisabledImages16: TImageList
    Tag = 2
    Left = 32
    Top = 56
  end
  object TplDisabledImages24: TImageList
    Tag = 2
    Height = 24
    Width = 24
    Left = 128
    Top = 56
  end
  object TplDisabledImages32: TImageList
    Tag = 2
    Height = 32
    Width = 32
    Left = 224
    Top = 56
  end
  object TplDisabledImages48: TImageList
    Tag = 2
    Height = 48
    Width = 48
    Left = 320
    Top = 56
  end
  object TplDisabledImages64: TImageList
    Tag = 2
    Height = 64
    Width = 64
    Left = 416
    Top = 56
  end
  object TplDisabledImages128: TImageList
    Tag = 2
    Height = 128
    Width = 128
    Left = 512
    Top = 56
  end
  object TplDisabledImages256: TImageList
    Tag = 2
    Height = 256
    Width = 256
    Left = 608
    Top = 56
  end
end
