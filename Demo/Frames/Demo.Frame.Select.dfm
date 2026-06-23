object FrameSelectDemo: TFrameSelectDemo
  Left = 0
  Top = 0
  Width = 1205
  Height = 819
  Color = clBtnFace
  ParentColor = False
  TabOrder = 0
  object pnlHeader: TDSkPanel
    Left = 0
    Top = 0
    Width = 1205
    Height = 150
    Align = alTop
    Caption = 'Select Component Demo'
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
    ExplicitWidth = 1024
  end
  object pnlControl: TDSkPanel
    Left = 0
    Top = 150
    Width = 200
    Height = 669
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
    ExplicitTop = 0
    ExplicitHeight = 576
    object rgVariant: TDSkRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 194
      Height = 134
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'Outlined'
        'Filled'
        'Underline')
      Caption = 'Variant'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = 16098626
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
      AlignWithMargins = True
      Left = 3
      Top = 143
      Width = 194
      Height = 98
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'Medium'
        'Small')
      Caption = 'Size'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = 16098626
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
      AlignWithMargins = True
      Left = 3
      Top = 247
      Width = 194
      Height = 242
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
      CaptionFont.Color = 16098626
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
    object chkClearable: TDSkCheckbox
      Left = 24
      Top = 532
      Width = 248
      Height = 28
      Caption = 'Clearable'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkClearableCheckChanged
    end
    object chkError: TDSkCheckbox
      Left = 24
      Top = 568
      Width = 248
      Height = 28
      Caption = 'Error State'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkErrorCheckChanged
    end
  end
  object pnlPreview: TDSkPanel
    Left = 200
    Top = 150
    Width = 1005
    Height = 669
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
    ExplicitLeft = 296
    ExplicitTop = 232
    ExplicitWidth = 736
    ExplicitHeight = 576
    object lblPreviewTitle: TDSkLabel
      Left = 40
      Top = 24
      Width = 75
      Height = 11
      Caption = 'Preview Area'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
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
    object selBasic: TDSkSelect
      Left = 40
      Top = 56
      Width = 280
      Height = 62
      Items.Strings = (
        'Item 1'
        'Item 2'
        'Item 3')
      Text = ''
      Label_ = 'Basic Select'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5722185
      Font.Height = -20
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = -9079435
      LabelFont.Height = -20
      LabelFont.Name = 'Microsoft YaHei UI'
      LabelFont.Style = []
    end
    object selLabel: TDSkSelect
      Left = 40
      Top = 136
      Width = 280
      Height = 62
      Items.Strings = (
        'Item 1'
        'Item 2'
        'Item 3')
      Text = ''
      Label_ = 'With Label'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5722185
      Font.Height = -20
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = -9079435
      LabelFont.Height = -20
      LabelFont.Name = 'Microsoft YaHei UI'
      LabelFont.Style = []
    end
    object selPlaceholder: TDSkSelect
      Left = 40
      Top = 216
      Width = 280
      Height = 62
      Items.Strings = (
        'Item 1'
        'Item 2'
        'Item 3')
      Text = ''
      Label_ = 'Placeholder'
      Placeholder = 'Choose an option...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5722185
      Font.Height = -20
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = -9079435
      LabelFont.Height = -20
      LabelFont.Name = 'Microsoft YaHei UI'
      LabelFont.Style = []
    end
    object selClearable: TDSkSelect
      Left = 40
      Top = 296
      Width = 280
      Height = 62
      Items.Strings = (
        'Item 1'
        'Item 2'
        'Item 3')
      Text = ''
      Label_ = 'Clearable'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5722185
      Font.Height = -20
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = -9079435
      LabelFont.Height = -20
      LabelFont.Name = 'Microsoft YaHei UI'
      LabelFont.Style = []
    end
    object selError: TDSkSelect
      Left = 40
      Top = 376
      Width = 280
      Height = 62
      Items.Strings = (
        'Item 1'
        'Item 2'
        'Item 3')
      Text = ''
      Label_ = 'Error State'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5722185
      Font.Height = -20
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = -9079435
      LabelFont.Height = -20
      LabelFont.Name = 'Microsoft YaHei UI'
      LabelFont.Style = []
      ErrorText = 'Please select a value'
    end
  end
end
