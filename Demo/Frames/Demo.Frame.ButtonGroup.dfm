object FrameButtonGroupDemo: TFrameButtonGroupDemo
  Left = 0
  Top = 0
  Width = 1024
  Height = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TabOrder = 0
  object pnlHeader: TDSkPanel
    Left = 0
    Top = 0
    Width = 1024
    Height = 64
    Align = alTop
    Caption = 'ButtonGroup Component Demo'
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
    Width = 288
    Height = 576
    Align = alLeft
    Caption = ''
    CaptionPosition = cpTopLeft
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -12
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
    object lblOrientation: TDSkLabel
      Left = 16
      Top = 16
      Width = 64
      Height = 15
      Caption = 'Orientation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object lblVariant: TDSkLabel
      Left = 16
      Top = 128
      Width = 39
      Height = 15
      Caption = 'Variant'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object lblSize: TDSkLabel
      Left = 16
      Top = 280
      Width = 23
      Height = 15
      Caption = 'Size'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object lblColor: TDSkLabel
      Left = 16
      Top = 432
      Width = 77
      Height = 15
      Caption = 'Color Scheme'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object rgOrientation: TDSkRadioGroup
      Left = 16
      Top = 40
      Width = 248
      Height = 80
      ItemIndex = 0
      Items.Strings = (
        'Horizontal'
        'Vertical')
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
      OnItemClick = rgOrientationItemClick
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object rgVariant: TDSkRadioGroup
      Left = 16
      Top = 152
      Width = 248
      Height = 120
      ItemIndex = 0
      Items.Strings = (
        'Contained'
        'Outlined'
        'Text')
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
    object rgSize: TDSkRadioGroup
      Left = 16
      Top = 304
      Width = 248
      Height = 120
      ItemIndex = 1
      Items.Strings = (
        'Small'
        'Medium'
        'Large')
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
      OnItemClick = rgSizeItemClick
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object rgColor: TDSkRadioGroup
      Left = 16
      Top = 456
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
    object chkExclusive: TDSkCheckbox
      Left = 16
      Top = 644
      Width = 248
      Height = 28
      Checked = True
      Caption = 'Exclusive Selection'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkExclusiveCheckChanged
    end
    object chkFullWidth: TDSkCheckbox
      Left = 16
      Top = 676
      Width = 248
      Height = 28
      Caption = 'Full Width'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkFullWidthCheckChanged
    end
  end
  object pnlPreview: TDSkPanel
    Left = 288
    Top = 64
    Width = 736
    Height = 576
    Align = alClient
    Caption = ''
    CaptionPosition = cpTopLeft
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -12
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
    object btnGroupMain: TDSkButtonGroup
      Left = 40
      Top = 60
      Width = 500
      Height = 48
      Variant = bgvContained
      CornerRadius = 4.000000000000000000
      BackgroundColor = xFF1976D2
      BorderColor = x33000000
      BorderWidth = 0.000000000000000000
      object btnGroupItem1: TDSkButton
        Left = 0
        Top = 6
        Width = 125
        Height = 36
        ButtonText = 'Home'
        ButtonColor = xFF1976D2
        ButtonHover = xFF1565C0
        ButtonPressed = xFF1565C0
        ButtonDisabled = xFFE0E0E0
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
        ButtonRound = 4.000000000000000000
        Checked = False
        ImageIndex = -1
        ImageAlign = iaLeft
        ImageMargin = 8
        BackgroundColor = claWhite
        BorderColor = claGray
        BorderWidth = 0.000000000000000000
      end
      object btnGroupItem2: TDSkButton
        Left = 125
        Top = 6
        Width = 125
        Height = 36
        ButtonText = 'Data'
        ButtonColor = xFF1976D2
        ButtonHover = xFF1565C0
        ButtonPressed = xFF1565C0
        ButtonDisabled = xFFE0E0E0
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
        ButtonRound = 4.000000000000000000
        Checked = False
        ImageIndex = -1
        ImageAlign = iaLeft
        ImageMargin = 8
        BackgroundColor = claWhite
        BorderColor = claGray
        BorderWidth = 0.000000000000000000
      end
      object btnGroupItem3: TDSkButton
        Left = 250
        Top = 6
        Width = 125
        Height = 36
        ButtonText = 'Settings'
        ButtonColor = xFF1976D2
        ButtonHover = xFF1565C0
        ButtonPressed = xFF1565C0
        ButtonDisabled = xFFE0E0E0
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
        ButtonRound = 4.000000000000000000
        Checked = False
        ImageIndex = -1
        ImageAlign = iaLeft
        ImageMargin = 8
        BackgroundColor = claWhite
        BorderColor = claGray
        BorderWidth = 0.000000000000000000
      end
      object btnGroupItem4: TDSkButton
        Left = 375
        Top = 6
        Width = 125
        Height = 36
        ButtonText = 'Help'
        ButtonColor = xFF1976D2
        ButtonHover = xFF1565C0
        ButtonPressed = xFF1565C0
        ButtonDisabled = xFFE0E0E0
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
        ButtonRound = 4.000000000000000000
        Checked = False
        ImageIndex = -1
        ImageAlign = iaLeft
        ImageMargin = 8
        BackgroundColor = claWhite
        BorderColor = claGray
        BorderWidth = 0.000000000000000000
      end
    end
    object btnGroupVertical: TDSkButtonGroup
      Left = 24
      Top = 360
      Width = 180
      Height = 200
      Orientation = bgoVertical
      CornerRadius = 4.000000000000000000
      BackgroundColor = claWhite
      BorderColor = x801976D2
      BorderWidth = 0.000000000000000000
      object btnVertItem1: TDSkButton
        Left = 0
        Top = 0
        Width = 180
        Height = 36
        ButtonText = 'Inbox'
        ButtonColor = claWhite
        ButtonHover = xFFEDF4FB
        ButtonPressed = xFFDFECF9
        ButtonDisabled = xFFE0E0E0
        ButtonChecked = xFFD6E6F7
        FontColor = xFF1976D2
        FontHover = xFF1976D2
        FontDisabled = xFF757575
        FontChecked = xFF1976D2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Microsoft YaHei UI'
        Font.Style = []
        ButtonStyle = bsRoundRect
        ButtonType = btNormal
        ButtonRound = 4.000000000000000000
        Checked = False
        ImageIndex = -1
        ImageAlign = iaLeft
        ImageMargin = 8
        BackgroundColor = claWhite
        BorderColor = x801976D2
        BorderWidth = 1.000000000000000000
      end
      object btnVertItem2: TDSkButton
        Left = 0
        Top = 35
        Width = 180
        Height = 36
        ButtonText = 'Starred'
        ButtonColor = claWhite
        ButtonHover = xFFEDF4FB
        ButtonPressed = xFFDFECF9
        ButtonDisabled = xFFE0E0E0
        ButtonChecked = xFFD6E6F7
        FontColor = xFF1976D2
        FontHover = xFF1976D2
        FontDisabled = xFF757575
        FontChecked = xFF1976D2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Microsoft YaHei UI'
        Font.Style = []
        ButtonStyle = bsRoundRect
        ButtonType = btNormal
        ButtonRound = 4.000000000000000000
        Checked = False
        ImageIndex = -1
        ImageAlign = iaLeft
        ImageMargin = 8
        BackgroundColor = claWhite
        BorderColor = x801976D2
        BorderWidth = 1.000000000000000000
      end
      object btnVertItem3: TDSkButton
        Left = 0
        Top = 70
        Width = 180
        Height = 36
        ButtonText = 'Archive'
        ButtonColor = claWhite
        ButtonHover = xFFEDF4FB
        ButtonPressed = xFFDFECF9
        ButtonDisabled = xFFE0E0E0
        ButtonChecked = xFFD6E6F7
        FontColor = xFF1976D2
        FontHover = xFF1976D2
        FontDisabled = xFF757575
        FontChecked = xFF1976D2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Microsoft YaHei UI'
        Font.Style = []
        ButtonStyle = bsRoundRect
        ButtonType = btNormal
        ButtonRound = 4.000000000000000000
        Checked = False
        ImageIndex = -1
        ImageAlign = iaLeft
        ImageMargin = 8
        BackgroundColor = claWhite
        BorderColor = x801976D2
        BorderWidth = 1.000000000000000000
      end
      object btnVertItem4: TDSkButton
        Left = 0
        Top = 105
        Width = 180
        Height = 36
        ButtonText = 'Trash'
        ButtonColor = claWhite
        ButtonHover = xFFEDF4FB
        ButtonPressed = xFFDFECF9
        ButtonDisabled = xFFE0E0E0
        ButtonChecked = xFFD6E6F7
        FontColor = xFF1976D2
        FontHover = xFF1976D2
        FontDisabled = xFF757575
        FontChecked = xFF1976D2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Microsoft YaHei UI'
        Font.Style = []
        ButtonStyle = bsRoundRect
        ButtonType = btNormal
        ButtonRound = 4.000000000000000000
        Checked = False
        ImageIndex = -1
        ImageAlign = iaLeft
        ImageMargin = 8
        BackgroundColor = claWhite
        BorderColor = x801976D2
        BorderWidth = 1.000000000000000000
      end
    end
  end
end
