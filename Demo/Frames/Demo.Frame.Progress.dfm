object FrameProgressDemo: TFrameProgressDemo
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
    Height = 64
    Align = alTop
    Caption = 'Progress Component Demo'
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
    Top = 64
    Width = 280
    Height = 576
    Align = alLeft
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
    object lblVariant: TDSkLabel
      Left = 16
      Top = 16
      Width = 39
      Height = 15
      Caption = 'Variant'
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
    object lblValue: TDSkLabel
      Left = 16
      Top = 380
      Width = 81
      Height = 15
      Caption = 'Progress Value'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object rgVariant: TDSkRadioGroup
      Left = 16
      Top = 40
      Width = 248
      Height = 120
      ItemIndex = 0
      Items.Strings = (
        'Determinate'
        'Indeterminate'
        'Buffer')
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
      OnItemClick = rgVariantItemClick
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
    object sliderValue: TDSkSlider
      Left = 16
      Top = 404
      Width = 248
      Height = 40
      ParentShowHint = False
      ShowHint = False
      Max = 100.000000000000000000
      Value = 50.000000000000000000
      ValueHigh = 100.000000000000000000
      ShowValueLabel = svldOn
      ThumbSize = 10.000000000000000000
      TrackHeight = 4.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f'
      OnChange = sliderValueChange
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object btnSimulate: TDSkButton
      Left = 16
      Top = 460
      Width = 120
      Height = 40
      OnClick = btnSimulateClick
      ButtonText = 'Simulate'
      ButtonColor = xFF1976D2
      ButtonHover = xFF42A5F5
      ButtonPressed = xFF1565C0
      ButtonDisabled = xFFBDBDBD
      ButtonChecked = xFF1565C0
      FontColor = claWhite
      FontHover = claWhite
      FontDisabled = xFF757575
      FontChecked = claWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ButtonStyle = bsRoundRect
      ButtonType = btNormal
      ButtonRound = 10.000000000000000000
      Checked = False
      ImageIndex = -1
      ImageAlign = iaLeft
      ImageMargin = 8
      MUIColorScheme = muiPrimary
      MUIStyle = muiContained
      BackgroundColor = claWhite
      BorderColor = xFF1976D2
      BorderWidth = 0.000000000000000000
    end
    object btnReset: TDSkButton
      Left = 144
      Top = 460
      Width = 120
      Height = 40
      OnClick = btnResetClick
      ButtonText = 'Reset'
      ButtonColor = claWhitesmoke
      ButtonHover = xFF9C27B0
      ButtonPressed = xFF7B1FA2
      ButtonDisabled = xFFBDBDBD
      ButtonChecked = xFF1565C0
      FontColor = xFF9C27B0
      FontHover = claWhite
      FontDisabled = xFF757575
      FontChecked = claWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ButtonStyle = bsRoundRect
      ButtonType = btNormal
      ButtonRound = 10.000000000000000000
      Checked = False
      ImageIndex = -1
      ImageAlign = iaLeft
      ImageMargin = 8
      MUIColorScheme = muiSecondary
      MUIStyle = muiOutlined
      BackgroundColor = claWhite
      BorderColor = xFF9C27B0
      BorderWidth = 2.000000000000000000
    end
  end
  object pnlPreview: TDSkPanel
    Left = 280
    Top = 64
    Width = 744
    Height = 576
    Align = alClient
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
    object lblProgress: TDSkLabel
      Left = 40
      Top = 56
      Width = 84
      Height = 17
      Caption = 'Progress: 50%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
    end
    object pbDeterminate: TDSkProgressBar
      Left = 40
      Top = 80
      Width = 500
      Height = 30
      Max = 100.000000000000000000
      Value = 50.000000000000000000
      BarColor = claNull
      TrackColor = claNull
      TrackHeight = 4.000000000000000000
      ShowLabel = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f%%'
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object pbIndeterminate: TDSkProgressBar
      Left = 40
      Top = 128
      Width = 500
      Height = 8
      Max = 100.000000000000000000
      Variant = pbvIndeterminate
      BarColor = claNull
      TrackColor = claNull
      TrackHeight = 4.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f%%'
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object pbBuffer: TDSkProgressBar
      Left = 40
      Top = 168
      Width = 500
      Height = 8
      Max = 100.000000000000000000
      Value = 50.000000000000000000
      ValueBuffer = 70.000000000000000000
      Variant = pbvBuffer
      BarColor = claNull
      TrackColor = claNull
      TrackHeight = 4.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f%%'
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object cpDeterminate: TDSkCircularProgress
      Left = 40
      Top = 228
      Width = 80
      Height = 80
      Max = 100.000000000000000000
      Value = 50.000000000000000000
      ProgressColor = claNull
      TrackColor = claNull
      CircleSize = 40.000000000000000000
      Thickness = 3.599999904632568000
      ShowLabel = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f%%'
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object cpIndeterminate: TDSkCircularProgress
      Left = 160
      Top = 228
      Width = 80
      Height = 80
      Max = 100.000000000000000000
      Variant = cpvIndeterminate
      ProgressColor = claNull
      TrackColor = claNull
      CircleSize = 40.000000000000000000
      Thickness = 3.599999904632568000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ValueLabelFormat = '%.0f%%'
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
  end
  object tmrSimulate: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tmrSimulateTimer
    Left = 720
    Top = 24
  end
end
