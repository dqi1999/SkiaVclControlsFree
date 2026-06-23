object FrameStepperDemo: TFrameStepperDemo
  Left = 0
  Top = 0
  Width = 1121
  Height = 656
  Color = clBtnFace
  ParentColor = False
  TabOrder = 0
  object pnlHeader: TDSkPanel
    Left = 0
    Top = 0
    Width = 1121
    Height = 57
    Align = alTop
    Caption = 'Stepper Component Demo'
    CaptionPosition = cpTopCenter
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWhite
    CaptionFont.Height = -20
    CaptionFont.Name = 'Microsoft YaHei UI'
    CaptionFont.Style = []
    CaptionMargin = 8.000000000000000000
    ChildPadding = 8.000000000000000000
    BackgroundHover = xFFEEEEEE
    BackgroundColor = xFF16389B
    BorderColor = xFFE0E0E0
    BorderWidth = 0.000000000000000000
  end
  object pnlControl: TDSkPanel
    Left = 0
    Top = 57
    Width = 200
    Height = 599
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
    object lblOrientation: TDSkLabel
      Left = 16
      Top = 16
      Width = 52
      Height = 9
      Caption = 'Orientation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      FontColor = claNull
      GradientStartColor = xFF1976D2
      GradientEndColor = xFF42A5F5
      StrokeColor = claWhite
      StrokeWidth = 1.000000000000000000
      ShadowColor = x60000000
      ShadowBlur = 4.000000000000000000
      ShadowOffsetY = 2.000000000000000000
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object lblVariant: TDSkLabel
      Left = 16
      Top = 128
      Width = 35
      Height = 9
      Caption = 'Variant'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      FontColor = claNull
      GradientStartColor = xFF1976D2
      GradientEndColor = xFF42A5F5
      StrokeColor = claWhite
      StrokeWidth = 1.000000000000000000
      ShadowColor = x60000000
      ShadowBlur = 4.000000000000000000
      ShadowOffsetY = 2.000000000000000000
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object lblColor: TDSkLabel
      Left = 16
      Top = 240
      Width = 63
      Height = 9
      Caption = 'Color Scheme'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      FontColor = claNull
      GradientStartColor = xFF1976D2
      GradientEndColor = xFF42A5F5
      StrokeColor = claWhite
      StrokeWidth = 1.000000000000000000
      ShadowColor = x60000000
      ShadowBlur = 4.000000000000000000
      ShadowOffsetY = 2.000000000000000000
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
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
      Height = 80
      ItemIndex = 0
      Items.Strings = (
        'Linear'
        'Non-Linear')
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
      Top = 264
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
    object chkAutoFit: TDSkCheckbox
      Left = 16
      Top = 452
      Width = 248
      Height = 28
      Checked = True
      Caption = 'Auto Fit Spacing'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkAutoFitCheckChanged
    end
  end
  object pnlPreview: TDSkPanel
    Left = 200
    Top = 57
    Width = 921
    Height = 599
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
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 915
      Height = 12
      Align = alTop
      Caption = 'Preview Area'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      FontColor = claNull
      GradientStartColor = xFF1976D2
      GradientEndColor = xFF42A5F5
      StrokeColor = claWhite
      StrokeWidth = 1.000000000000000000
      ShadowColor = x60000000
      ShadowBlur = 4.000000000000000000
      ShadowOffsetY = 2.000000000000000000
      TextAlign = ltaLeft
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object lblInfo: TDSkLabel
      Left = 32
      Top = 396
      Width = 94
      Height = 12
      Caption = 'Current: Step 1 of 4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      FontColor = claNull
      GradientStartColor = xFF1976D2
      GradientEndColor = xFF42A5F5
      StrokeColor = claWhite
      StrokeWidth = 1.000000000000000000
      ShadowColor = x60000000
      ShadowBlur = 4.000000000000000000
      ShadowOffsetY = 2.000000000000000000
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
    object stepperMain: TDSkStepper
      AlignWithMargins = True
      Left = 3
      Top = 21
      Width = 915
      Height = 81
      Align = alTop
      Steps = <
        item
          Caption = 'Step 1'
          Description = 'Basic info'
          Status = ssCompleted
        end
        item
          Caption = 'Step 2'
          Description = 'Details'
          Status = ssActive
        end
        item
          Caption = 'Step 3'
          Description = 'Confirm'
        end>
      StepSize = 32.000000000000000000
      StepSpacing = 60.000000000000000000
      AutoFit = True
      ConnectorThickness = 2.000000000000000000
      StepFont.Charset = DEFAULT_CHARSET
      StepFont.Color = clWindowText
      StepFont.Height = -20
      StepFont.Name = 'Microsoft YaHei UI'
      StepFont.Style = [fsBold]
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -20
      LabelFont.Name = 'Microsoft YaHei UI'
      LabelFont.Style = []
      DescriptionFont.Charset = DEFAULT_CHARSET
      DescriptionFont.Color = 7697781
      DescriptionFont.Height = -17
      DescriptionFont.Name = 'Microsoft YaHei UI'
      DescriptionFont.Style = []
      BackgroundColor = claNull
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
      ExplicitLeft = 40
      ExplicitTop = 56
      ExplicitWidth = 785
    end
    object btnPrev: TDSkButton
      Left = 32
      Top = 432
      Width = 100
      Height = 40
      OnClick = btnPrevClick
      ButtonText = 'Previous'
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
    object btnNext: TDSkButton
      Left = 152
      Top = 432
      Width = 100
      Height = 40
      OnClick = btnNextClick
      ButtonText = 'Next'
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
      Left = 272
      Top = 432
      Width = 100
      Height = 40
      OnClick = btnResetClick
      ButtonText = 'Reset'
      ButtonColor = claNull
      ButtonHover = xFFD32F2F
      ButtonPressed = xFFC62828
      ButtonDisabled = xFFBDBDBD
      ButtonChecked = xFF1565C0
      FontColor = xFFD32F2F
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
      MUIStyle = muiText
      BackgroundColor = claWhite
      BorderColor = claNull
      BorderWidth = 0.000000000000000000
    end
  end
end
