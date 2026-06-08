object FrameButtonDemo: TFrameButtonDemo
  Left = 0
  Top = 0
  Width = 1074
  Height = 924
  TabOrder = 0
  object pnlHeader: TDSkPanel
    Left = 0
    Top = 0
    Width = 1074
    Height = 64
    Align = alTop
    Caption = 'Button Component Demo'
    CaptionPosition = cpLeftCenter
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -20
    CaptionFont.Name = 'Segoe UI'
    CaptionFont.Style = [fsBold]
    CaptionMargin = 24.000000000000000000
    ChildPadding = 8.000000000000000000
    BackgroundHover = xFFF0F0F0
    PanelStyle = psSurface
    CornerRadius = 12.000000000000000000
    BackgroundColor = xFFFAFAFA
    BorderColor = xFFE0E0E0
    BorderWidth = 0.000000000000000000
  end
  object pnlControl: TDSkPanel
    Left = 0
    Top = 64
    Width = 280
    Height = 860
    Align = alLeft
    Caption = ''
    CaptionPosition = cpTopLeft
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -16
    CaptionFont.Name = 'Segoe UI'
    CaptionFont.Style = []
    CaptionMargin = 8.000000000000000000
    ChildPadding = 16.000000000000000000
    BackgroundHover = claWhitesmoke
    PanelStyle = psElevated
    CornerRadius = 12.000000000000000000
    BackgroundColor = claWhite
    BorderColor = xFFE0E0E0
    BorderWidth = 0.500000000000000000
    object rgStyle: TDSkRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 171
      Width = 274
      Height = 134
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'Contained'
        'Outlined'
        'Text')
      Caption = 'MUI Style'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = -9079435
      CaptionFont.Height = -17
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      RadioSize = 20.000000000000000000
      ItemFont.Charset = DEFAULT_CHARSET
      ItemFont.Color = clBlack
      ItemFont.Height = -16
      ItemFont.Name = 'Microsoft YaHei UI'
      ItemFont.Style = []
      ColorScheme = muiInfo
      OnItemClick = rgStyleItemClick
      BackgroundColor = claWhite
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
      ExplicitTop = 3
    end
    object rgColor: TDSkRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 311
      Width = 274
      Height = 234
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'Primary'
        'Secondary'
        'Error'
        'Warning'
        'Info'
        'Success')
      Caption = 'Color Scheme'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = -9079435
      CaptionFont.Height = -17
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      RadioSize = 20.000000000000000000
      ItemFont.Charset = DEFAULT_CHARSET
      ItemFont.Color = clBlack
      ItemFont.Height = -16
      ItemFont.Name = 'Microsoft YaHei UI'
      ItemFont.Style = []
      OnItemClick = rgColorItemClick
      BackgroundColor = claWhite
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object rgHover: TDSkRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 274
      Height = 162
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'None'
        'Ripple'
        'Glow'
        'Scale Up')
      Caption = 'Hover Effect'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = -9079435
      CaptionFont.Height = -17
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      RadioSize = 20.000000000000000000
      ItemFont.Charset = DEFAULT_CHARSET
      ItemFont.Color = clBlack
      ItemFont.Height = -16
      ItemFont.Name = 'Microsoft YaHei UI'
      ItemFont.Style = []
      OnItemClick = rgHoverItemClick
      BackgroundColor = claWhite
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
      ExplicitTop = 339
      ExplicitWidth = 788
    end
    object DSkPanel1: TDSkPanel
      Left = 0
      Top = 548
      Width = 280
      Height = 253
      Align = alTop
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
      PanelStyle = psElevated
      CornerRadius = 12.000000000000000000
      BackgroundColor = claWhite
      BorderColor = xFFE0E0E0
      BorderWidth = 0.500000000000000000
      object lblRadius: TDSkLabel
        Left = 11
        Top = 91
        Width = 94
        Height = 19
        Caption = 'Corner Radius'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #24494#36719#38597#40657
        Font.Style = [fsBold]
      end
      object lblOptions: TDSkLabel
        Left = 11
        Top = 8
        Width = 52
        Height = 19
        Caption = 'Options'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #24494#36719#38597#40657
        Font.Style = [fsBold]
      end
      object sliderCornerRadius: TDSkSlider
        Left = 11
        Top = 116
        Width = 248
        Height = 60
        Max = 50.000000000000000000
        Value = 12.000000000000000000
        ValueHigh = 50.000000000000000000
        Step = 1.000000000000000000
        ShowMarks = True
        ThumbSize = 10.000000000000000000
        TrackHeight = 4.000000000000000000
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft YaHei UI'
        Font.Style = []
        ValueLabelFormat = '%.0f'
        OnChange = sliderCornerRadiusChange
        BackgroundColor = claWhite
        BorderColor = claNull
        BorderWidth = 0.000000000000000000
      end
      object chkToggle: TDSkCheckbox
        Left = 26
        Top = 57
        Width = 248
        Height = 28
        Caption = 'Toggle Mode'
        CheckboxSize = 20.000000000000000000
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft YaHei UI'
        Font.Style = []
        OnCheckChanged = chkToggleCheckChanged
      end
      object chkEnabled: TDSkCheckbox
        Left = 26
        Top = 33
        Width = 248
        Height = 28
        Checked = True
        Caption = 'Enabled'
        CheckboxSize = 20.000000000000000000
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft YaHei UI'
        Font.Style = []
        OnCheckChanged = chkEnabledCheckChanged
      end
    end
  end
  object pnlPreview: TDSkPanel
    Left = 280
    Top = 64
    Width = 794
    Height = 860
    Align = alClient
    Caption = ''
    CaptionPosition = cpTopLeft
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -16
    CaptionFont.Name = 'Segoe UI'
    CaptionFont.Style = []
    CaptionMargin = 8.000000000000000000
    ChildPadding = 24.000000000000000000
    BackgroundHover = claWhitesmoke
    PanelStyle = psOutlined
    CornerRadius = 12.000000000000000000
    BackgroundColor = claWhite
    BorderColor = xFFE0E0E0
    BorderWidth = 1.000000000000000000
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
    object btnContained: TDSkButton
      Left = 40
      Top = 60
      Width = 160
      Height = 48
      ButtonText = 'Contained'
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
      Font.Height = -16
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ButtonStyle = bsRoundRect
      ButtonType = btNormal
      ButtonRound = 12.000000000000000000
      Checked = False
      ImageIndex = -1
      ImageAlign = iaLeft
      ImageMargin = 8
      HoverEffect = heRipple
      MUIColorScheme = muiPrimary
      MUIStyle = muiContained
      BackgroundColor = claWhite
      BorderColor = xFF1976D2
      BorderWidth = 0.000000000000000000
    end
    object btnOutlined: TDSkButton
      Left = 220
      Top = 60
      Width = 160
      Height = 48
      ButtonText = 'Outlined'
      ButtonColor = claWhitesmoke
      ButtonHover = xFF1976D2
      ButtonPressed = xFF1565C0
      ButtonDisabled = xFFBDBDBD
      ButtonChecked = xFF1565C0
      FontColor = xFF1976D2
      FontHover = claWhite
      FontDisabled = xFF757575
      FontChecked = claWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ButtonStyle = bsRoundRect
      ButtonType = btNormal
      ButtonRound = 12.000000000000000000
      Checked = False
      ImageIndex = -1
      ImageAlign = iaLeft
      ImageMargin = 8
      HoverEffect = heRipple
      MUIColorScheme = muiPrimary
      MUIStyle = muiOutlined
      BackgroundColor = claWhite
      BorderColor = xFF1976D2
      BorderWidth = 2.000000000000000000
    end
    object btnDisabled: TDSkButton
      Left = 40
      Top = 128
      Width = 160
      Height = 48
      Enabled = False
      ButtonText = 'Disabled'
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
      Font.Height = -16
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ButtonStyle = bsRoundRect
      ButtonType = btNormal
      ButtonRound = 12.000000000000000000
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
    object btnToggle: TDSkButton
      Left = 220
      Top = 128
      Width = 160
      Height = 48
      ButtonText = 'Toggle'
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
      Font.Height = -16
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ButtonStyle = bsRoundRect
      ButtonType = btToggle
      ButtonRound = 12.000000000000000000
      Checked = False
      ImageIndex = -1
      ImageAlign = iaLeft
      ImageMargin = 8
      HoverEffect = heRipple
      MUIColorScheme = muiPrimary
      MUIStyle = muiContained
      BackgroundColor = claWhite
      BorderColor = xFF1976D2
      BorderWidth = 0.000000000000000000
    end
    object btnCustom: TDSkButton
      Left = 400
      Top = 128
      Width = 160
      Height = 48
      ButtonText = 'Custom'
      ButtonColor = xFF6750A4
      ButtonHover = xFF9A82DB
      ButtonPressed = xFF4F378B
      ButtonDisabled = xFFBDBDBD
      ButtonChecked = xFF4F378B
      FontColor = claWhite
      FontHover = claWhite
      FontDisabled = xFF757575
      FontChecked = claWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ButtonStyle = bsRoundRect
      ButtonType = btNormal
      ButtonRound = 12.000000000000000000
      Checked = False
      ImageIndex = -1
      ImageAlign = iaLeft
      ImageMargin = 8
      HoverEffect = heGlow
      BackgroundColor = claWhite
      BorderColor = claGray
      BorderWidth = 2.000000000000000000
    end
    object btnText: TDSkButton
      Left = 400
      Top = 60
      Width = 160
      Height = 48
      ButtonText = 'Text'
      ButtonColor = claNull
      ButtonHover = xFF1976D2
      ButtonPressed = xFF1565C0
      ButtonDisabled = xFFBDBDBD
      ButtonChecked = xFF1565C0
      FontColor = xFF1976D2
      FontHover = claWhite
      FontDisabled = xFF757575
      FontChecked = claWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ButtonStyle = bsRoundRect
      ButtonType = btNormal
      ButtonRound = 12.000000000000000000
      Checked = False
      ImageIndex = -1
      ImageAlign = iaLeft
      ImageMargin = 8
      HoverEffect = heRipple
      MUIColorScheme = muiPrimary
      MUIStyle = muiText
      BackgroundColor = claWhite
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
  end
end
