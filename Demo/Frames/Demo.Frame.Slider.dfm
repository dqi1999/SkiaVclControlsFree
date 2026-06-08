object FrameSliderDemo: TFrameSliderDemo
  Left = 0
  Top = 0
  Width = 1024
  Height = 640
  Color = clBtnFace
  ParentColor = False
  TabOrder = 0
  object pnlHeader: TDSkPanel
    Left = 0
    Top = 0
    Width = 1024
    Height = 150
    Caption = 'Slider Component Demo'
    CaptionPosition = cpTopCenter
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -20
    CaptionFont.Name = 'Microsoft YaHei UI'
    CaptionFont.Style = []
    CaptionMargin = 8.000000000000000000
    ChildPadding = 8.000000000000000000
    BackgroundHover = claWhitesmoke
    BackgroundColor = claWhite
    BorderColor = claGray
    BorderWidth = 2.000000000000000000
  end
  object pnlControl: TDSkPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 576
    Caption = ''
    CaptionPosition = cpTopCenter
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -20
    CaptionFont.Name = 'Microsoft YaHei UI'
    CaptionFont.Style = []
    CaptionMargin = 8.000000000000000000
    ChildPadding = 8.000000000000000000
    BackgroundHover = claWhitesmoke
    BackgroundColor = claWhite
    BorderColor = claGray
    BorderWidth = 2.000000000000000000
    object lblType: TDSkLabel
      Left = 16
      Top = 16
      Width = 26
      Height = 15
      Caption = 'Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object lblColor: TDSkLabel
      Left = 16
      Top = 168
      Width = 77
      Height = 15
      Caption = 'Color Scheme'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object rgType: TDSkRadioGroup
      Left = 16
      Top = 40
      Width = 248
      Height = 120
      ItemIndex = 0
      Items.Strings = (
        'Continuous'
        'Discrete'
        'Range')
      Caption = ''
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = -9079435
      CaptionFont.Height = -17
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      RadioSize = 20.000000000000000000
      ItemFont.Charset = DEFAULT_CHARSET
      ItemFont.Color = -570425344
      ItemFont.Height = -20
      ItemFont.Name = 'Microsoft YaHei UI'
      ItemFont.Style = []
      OnItemClick = rgTypeItemClick
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object rgColor: TDSkRadioGroup
      Left = 16
      Top = 192
      Width = 248
      Height = 180
      ItemIndex = 0
      Items.Strings = (
        'Primary'
        'Secondary'
        'Error'
        'Warning'
        'Info'
        'Success')
      Caption = ''
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = -9079435
      CaptionFont.Height = -17
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      RadioSize = 20.000000000000000000
      ItemFont.Charset = DEFAULT_CHARSET
      ItemFont.Color = -570425344
      ItemFont.Height = -20
      ItemFont.Name = 'Microsoft YaHei UI'
      ItemFont.Style = []
      OnItemClick = rgColorItemClick
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object chkMarks: TDSkCheckbox
      Left = 16
      Top = 380
      Width = 248
      Height = 28
      Caption = 'Show Marks'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkMarksCheckChanged
    end
    object chkVertical: TDSkCheckbox
      Left = 16
      Top = 416
      Width = 248
      Height = 28
      Caption = 'Vertical Mode'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkVerticalCheckChanged
    end
  end
  object pnlPreview: TDSkPanel
    Left = 0
    Top = 0
    Width = 736
    Height = 576
    Caption = ''
    CaptionPosition = cpTopCenter
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -20
    CaptionFont.Name = 'Microsoft YaHei UI'
    CaptionFont.Style = []
    CaptionMargin = 8.000000000000000000
    ChildPadding = 8.000000000000000000
    BackgroundHover = claWhitesmoke
    BackgroundColor = claWhite
    BorderColor = claGray
    BorderWidth = 2.000000000000000000
    object lblPreviewTitle: TDSkLabel
      Left = 40
      Top = 24
      Width = 92
      Height = 20
      Caption = 'Preview Area'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object lblBasic: TDSkLabel
      Left = 40
      Top = 56
      Width = 45
      Height = 15
      Caption = 'Basic: 50'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
    end
    object lblStep: TDSkLabel
      Left = 40
      Top = 136
      Width = 60
      Height = 15
      Caption = 'Discrete: 25'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
    end
    object lblRange: TDSkLabel
      Left = 40
      Top = 216
      Width = 74
      Height = 15
      Caption = 'Range: 25 - 75'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
    end
    object sliderBasic: TDSkSlider
      Left = 40
      Top = 80
      Width = 500
      Height = 40
      Max = 100.000000000000000000
      Value = 50.000000000000000000
      ValueHigh = 100.000000000000000000
      ThumbSize = 10.000000000000000000
      TrackHeight = 4.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f'
      OnChange = sliderBasicChange
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object sliderStep: TDSkSlider
      Left = 40
      Top = 160
      Width = 500
      Height = 40
      Max = 100.000000000000000000
      Value = 25.000000000000000000
      ValueHigh = 100.000000000000000000
      Step = 25.000000000000000000
      ShowMarks = True
      ThumbSize = 10.000000000000000000
      TrackHeight = 4.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f'
      OnChange = sliderStepChange
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object sliderRange: TDSkSlider
      Left = 40
      Top = 240
      Width = 500
      Height = 40
      Max = 100.000000000000000000
      ValueLow = 25.000000000000000000
      ValueHigh = 75.000000000000000000
      ThumbSize = 10.000000000000000000
      TrackHeight = 4.000000000000000000
      Range = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f'
      OnRangeChange = sliderRangeRangeChange
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object sliderVertical: TDSkSlider
      Left = 40
      Top = 320
      Width = 40
      Height = 200
      Visible = False
      Max = 100.000000000000000000
      Value = 50.000000000000000000
      ValueHigh = 100.000000000000000000
      Orientation = sloVertical
      ThumbSize = 10.000000000000000000
      TrackHeight = 4.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f'
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
  end
end
