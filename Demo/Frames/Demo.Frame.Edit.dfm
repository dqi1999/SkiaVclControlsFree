object FrameEditDemo: TFrameEditDemo
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
    Height = 48
    Align = alTop
    Caption = 'Edit Component Demo'
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
    Top = 48
    Width = 280
    Height = 592
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
    object rgVariant: TDSkRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 274
      Height = 134
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'Outlined'
        'Filled'
        'Underline')
      Caption = 'Variant'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = 13792793
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
      Width = 274
      Height = 96
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'Medium'
        'Small')
      Caption = 'Size'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = 13792793
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
      ExplicitTop = 121
    end
    object rgColor: TDSkRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 245
      Width = 274
      Height = 239
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
      CaptionFont.Color = 13792793
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
      Left = 16
      Top = 490
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
    object chkPassword: TDSkCheckbox
      Left = 16
      Top = 524
      Width = 248
      Height = 28
      Caption = 'Password Mode'
      CheckboxSize = 20.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft YaHei UI'
      Font.Style = []
      OnCheckChanged = chkPasswordCheckChanged
    end
    object chkError: TDSkCheckbox
      Left = 16
      Top = 558
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
    Left = 280
    Top = 48
    Width = 744
    Height = 592
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
    object edtBasic: TDSkEdit
      Left = 40
      Top = 56
      Width = 280
      Height = 62
      Text = 'Hello World'
      Label_ = 'Basic Input'
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
      TabOrder = 0
    end
    object edtLabel: TDSkEdit
      Left = 40
      Top = 136
      Width = 280
      Height = 62
      Text = 'Sample Text'
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
      TabOrder = 1
    end
    object edtPlaceholder: TDSkEdit
      Left = 40
      Top = 216
      Width = 280
      Height = 62
      Text = ''
      Label_ = 'Placeholder'
      Placeholder = 'Enter text here...'
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
      TabOrder = 2
    end
    object edtClearable: TDSkEdit
      Left = 40
      Top = 296
      Width = 280
      Height = 62
      Text = 'Clear me!'
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
      TabOrder = 3
    end
    object edtPassword: TDSkEdit
      Left = 40
      Top = 376
      Width = 280
      Height = 62
      Text = 'secret123'
      Label_ = 'Password'
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
      TabOrder = 4
    end
    object edtError: TDSkEdit
      Left = 40
      Top = 456
      Width = 280
      Height = 62
      Text = ''
      Label_ = 'Error State'
      ErrorText = 'This field is required'
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
      TabOrder = 5
    end
  end
end
