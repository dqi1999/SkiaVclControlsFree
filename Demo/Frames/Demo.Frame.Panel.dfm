object FramePanelDemo: TFramePanelDemo
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
    Caption = 'Panel Component Demo'
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
    object lblOptions: TDSkLabel
      Left = 26
      Top = 724
      Width = 43
      Height = 15
      Caption = 'Options'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object rgStyle: TDSkRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 274
      Height = 281
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'Elevated'
        'Filled'
        'Outlined'
        'Surface'
        'Primary Container'
        'Secondary Container'
        'Error Container')
      Caption = 'Style'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = -9079435
      CaptionFont.Height = -13
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      RadioSize = 20.000000000000000000
      ItemFont.Charset = DEFAULT_CHARSET
      ItemFont.Color = -570425344
      ItemFont.Height = -17
      ItemFont.Name = 'Microsoft YaHei UI'
      ItemFont.Style = []
      OnItemClick = rgStyleItemClick
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object rgCaptionPos: TDSkRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 290
      Width = 274
      Height = 352
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'Top Left'
        'Top Center'
        'Top Right'
        'Left Center'
        'Center'
        'Right Center'
        'Bottom Left'
        'Bottom Center'
        'Bottom Right')
      Caption = 'Caption Position'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = -9079435
      CaptionFont.Height = -13
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      RadioSize = 20.000000000000000000
      ItemFont.Charset = DEFAULT_CHARSET
      ItemFont.Color = -570425344
      ItemFont.Height = -17
      ItemFont.Name = 'Microsoft YaHei UI'
      ItemFont.Style = []
      OnItemClick = rgCaptionPosItemClick
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object edtCaption: TDSkEdit
      AlignWithMargins = True
      Left = 3
      Top = 648
      Width = 274
      Height = 62
      Align = alTop
      Text = 'Panel Title'
      Label_ = 'Caption Text'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5722185
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = -9079435
      LabelFont.Height = -16
      LabelFont.Name = 'Microsoft YaHei UI'
      LabelFont.Style = []
      OnChange = edtCaptionChange
      TabOrder = 2
    end
    object chkHover: TDSkCheckbox
      Left = 26
      Top = 748
      Width = 248
      Height = 28
      Caption = 'Enable Hover Effect'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkHoverCheckChanged
    end
    object chkBorder: TDSkCheckbox
      Left = 26
      Top = 780
      Width = 248
      Height = 28
      Caption = 'Show Border'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkBorderCheckChanged
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
    object pnlMain: TDSkPanel
      Left = 40
      Top = 56
      Width = 600
      Height = 160
      Caption = 'Panel Title'
      CaptionPosition = cpTopLeft
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -16
      CaptionFont.Name = 'Segoe UI'
      CaptionFont.Style = [fsBold]
      CaptionMargin = 16.000000000000000000
      ChildPadding = 16.000000000000000000
      BackgroundHover = claWhitesmoke
      PanelStyle = psElevated
      CornerRadius = 12.000000000000000000
      BackgroundColor = claWhite
      BorderColor = xFFE0E0E0
      BorderWidth = 0.500000000000000000
    end
    object pnlCard1: TDSkPanel
      Left = 40
      Top = 236
      Width = 180
      Height = 140
      Caption = 'Card 1'
      CaptionPosition = cpCenter
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -14
      CaptionFont.Name = 'Segoe UI'
      CaptionFont.Style = [fsBold]
      CaptionMargin = 8.000000000000000000
      ChildPadding = 12.000000000000000000
      BackgroundHover = xFFEEEEEE
      PanelStyle = psFilled
      CornerRadius = 12.000000000000000000
      BackgroundColor = claWhitesmoke
      BorderColor = xFFE0E0E0
      BorderWidth = 0.000000000000000000
    end
    object pnlCard2: TDSkPanel
      Left = 240
      Top = 236
      Width = 180
      Height = 140
      Caption = 'Card 2'
      CaptionPosition = cpCenter
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -14
      CaptionFont.Name = 'Segoe UI'
      CaptionFont.Style = [fsBold]
      CaptionMargin = 8.000000000000000000
      ChildPadding = 12.000000000000000000
      BackgroundHover = claWhitesmoke
      PanelStyle = psOutlined
      CornerRadius = 12.000000000000000000
      BackgroundColor = claWhite
      BorderColor = xFFE0E0E0
      BorderWidth = 1.000000000000000000
    end
    object pnlCard3: TDSkPanel
      Left = 440
      Top = 236
      Width = 180
      Height = 140
      Caption = 'Card 3'
      CaptionPosition = cpCenter
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -14
      CaptionFont.Name = 'Segoe UI'
      CaptionFont.Style = [fsBold]
      CaptionMargin = 8.000000000000000000
      ChildPadding = 12.000000000000000000
      BackgroundHover = xFFF0F0F0
      PanelStyle = psSurface
      CornerRadius = 12.000000000000000000
      BackgroundColor = xFFFAFAFA
      BorderColor = xFFE0E0E0
      BorderWidth = 0.000000000000000000
    end
    object pnlContainer: TDSkPanel
      Left = 40
      Top = 400
      Width = 600
      Height = 120
      Caption = 'Container with Buttons'
      CaptionPosition = cpTopLeft
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -14
      CaptionFont.Name = 'Segoe UI'
      CaptionFont.Style = []
      CaptionMargin = 12.000000000000000000
      ChildPadding = 12.000000000000000000
      BackgroundHover = xFFBBDEFB
      PanelStyle = psPrimaryContainer
      CornerRadius = 12.000000000000000000
      BackgroundColor = xFFE3F2FD
      BorderColor = xFFBBDEFB
      BorderWidth = 0.000000000000000000
    end
  end
end
