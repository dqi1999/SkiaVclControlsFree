object FrameSnackbarDemo: TFrameSnackbarDemo
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
    Caption = 'Snackbar Component Demo'
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
    Width = 288
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
    object lblSeverity: TDSkLabel
      Left = 16
      Top = 16
      Width = 47
      Height = 15
      Caption = 'Severity'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object lblPosition: TDSkLabel
      Left = 16
      Top = 228
      Width = 44
      Height = 15
      Caption = 'Position'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object lblVariant: TDSkLabel
      Left = 16
      Top = 480
      Width = 39
      Height = 15
      Caption = 'Variant'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object lblDuration: TDSkLabel
      Left = 16
      Top = 632
      Width = 49
      Height = 15
      Caption = 'Duration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object rgSeverity: TDSkRadioGroup
      Left = 16
      Top = 40
      Width = 248
      Height = 180
      ItemIndex = 0
      Items.Strings = (
        'Success'
        'Error'
        'Warning'
        'Info'
        'None')
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
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object rgPosition: TDSkRadioGroup
      Left = 16
      Top = 252
      Width = 248
      Height = 220
      ItemIndex = 0
      Items.Strings = (
        'Top Left'
        'Top Center'
        'Top Right'
        'Bottom Left'
        'Bottom Center'
        'Bottom Right')
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
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object rgVariant: TDSkRadioGroup
      Left = 16
      Top = 504
      Width = 248
      Height = 120
      ItemIndex = 0
      Items.Strings = (
        'Standard'
        'Filled'
        'Outlined')
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
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object rgDuration: TDSkRadioGroup
      Left = 16
      Top = 656
      Width = 248
      Height = 160
      ItemIndex = 1
      Items.Strings = (
        '2 seconds'
        '4 seconds'
        '6 seconds'
        'No auto hide')
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
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object chkAction: TDSkCheckbox
      Left = 16
      Top = 824
      Width = 248
      Height = 28
      Caption = 'Show Action Button'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
    end
    object chkClose: TDSkCheckbox
      Left = 16
      Top = 860
      Width = 248
      Height = 28
      Caption = 'Show Close Button'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
    end
  end
  object pnlPreview: TDSkPanel
    Left = 288
    Top = 64
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
    object lblInfo: TDSkLabel
      Left = 40
      Top = 180
      Width = 245
      Height = 15
      Caption = 'Click buttons to show different snackbar styles'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
    end
    object btnShow: TDSkButton
      Left = 40
      Top = 56
      Width = 200
      Height = 48
      OnClick = btnShowClick
      ButtonText = 'Show Snackbar'
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
    object btnSuccess: TDSkButton
      Left = 40
      Top = 120
      Width = 120
      Height = 40
      OnClick = btnSuccessClick
      ButtonText = 'Success'
      ButtonColor = xFF2E7D32
      ButtonHover = xFF4CAF50
      ButtonPressed = xFF1B5E20
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
      MUIColorScheme = muiSuccess
      MUIStyle = muiContained
      BackgroundColor = claWhite
      BorderColor = xFF2E7D32
      BorderWidth = 0.000000000000000000
    end
    object btnError: TDSkButton
      Left = 180
      Top = 120
      Width = 120
      Height = 40
      OnClick = btnErrorClick
      ButtonText = 'Error'
      ButtonColor = xFFD32F2F
      ButtonHover = xFFEF5350
      ButtonPressed = xFFC62828
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
      MUIColorScheme = muiError
      MUIStyle = muiContained
      BackgroundColor = claWhite
      BorderColor = xFFD32F2F
      BorderWidth = 0.000000000000000000
    end
    object btnWarning: TDSkButton
      Left = 320
      Top = 120
      Width = 120
      Height = 40
      OnClick = btnWarningClick
      ButtonText = 'Warning'
      ButtonColor = xFFED6C02
      ButtonHover = xFFFF9800
      ButtonPressed = xFFE65100
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
      MUIColorScheme = muiWarning
      MUIStyle = muiContained
      BackgroundColor = claWhite
      BorderColor = xFFED6C02
      BorderWidth = 0.000000000000000000
    end
    object btnInfo: TDSkButton
      Left = 460
      Top = 120
      Width = 120
      Height = 40
      OnClick = btnInfoClick
      ButtonText = 'Info'
      ButtonColor = xFF0288D1
      ButtonHover = xFF03A9F4
      ButtonPressed = xFF01579B
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
      MUIColorScheme = muiInfo
      MUIStyle = muiContained
      BackgroundColor = claWhite
      BorderColor = xFF0288D1
      BorderWidth = 0.000000000000000000
    end
    object mainSnackbar: TDSkSnackbar
      Left = 200
      Top = 300
      Width = 369
      Height = 40
      Visible = False
      Message = 'Snackbar Message'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      ActionFont.Charset = DEFAULT_CHARSET
      ActionFont.Color = clWhite
      ActionFont.Height = -20
      ActionFont.Name = 'Microsoft YaHei UI'
      ActionFont.Style = [fsBold]
      OnAction = mainSnackbarAction
      OnClose = mainSnackbarClose
      OnShow = mainSnackbarShow
    end
  end
end
