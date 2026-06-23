object FormAdminDemo: TFormAdminDemo
  Left = 0
  Top = 0
  Caption = 'SkiaVclControls Admin Demo'
  ClientHeight = 859
  ClientWidth = 1320
  Color = 16251388
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Microsoft YaHei UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 17
  object pnlSidebar: TDSkPanel
    Left = 0
    Top = 0
    Width = 260
    Height = 859
    Align = alLeft
    Caption = ''
    CaptionPosition = cpTopLeft
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -20
    CaptionFont.Name = 'Microsoft YaHei UI'
    CaptionFont.Style = []
    CaptionMargin = 8.000000000000000000
    ChildPadding = 8.000000000000000000
    BackgroundHover = claWhite
    BackgroundColor = xFFF8FBFF
    BorderColor = xFFDDE6F2
    BorderWidth = 1.000000000000000000
    ExplicitHeight = 820
    object pnlBrand: TDSkPanel
      Left = 16
      Top = 16
      Width = 228
      Height = 84
      Caption = ''
      CaptionPosition = cpTopLeft
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -20
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      ChildPadding = 8.000000000000000000
      BackgroundHover = xFFEAF4FF
      CornerRadius = 16.000000000000000000
      BackgroundColor = xFFEAF4FF
      BorderColor = xFFD8E9FF
      BorderWidth = 1.000000000000000000
      object lblBrandTitle: TDSkLabel
        Left = 20
        Top = 18
        Width = 125
        Height = 17
        Caption = 'Skia Controls'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12608789
        Font.Height = -19
        Font.Name = 'Microsoft YaHei UI'
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
      object lblBrandSubtitle: TDSkLabel
        Left = 21
        Top = 45
        Width = 137
        Height = 15
        Caption = 'Component workbench'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8219479
        Font.Height = -12
        Font.Name = 'Microsoft YaHei UI'
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
    end
    object sideNav: TDSkTabs
      Left = 16
      Top = 120
      Width = 228
      Height = 672
      Items.Strings = (
        'Label:1'
        'Button:0'
        'Panel:2'
        'Radio:5'
        'Checkbox:6'
        'Switch:7'
        'Slider:8'
        'Progress:9'
        'Select:4'
        'Edit:3'
        'Snackbar:10'
        'Button Group:11'
        'Tabs:12'
        'Stepper:13')
      ItemIndex = 0
      Alignment = taFullWidth
      Orientation = toVertical
      TabFont.Charset = DEFAULT_CHARSET
      TabFont.Color = -570425344
      TabFont.Height = -15
      TabFont.Name = 'Microsoft YaHei UI'
      TabFont.Style = []
      TabHeight = 48.000000000000000000
      IndicatorHeight = 4.000000000000000000
      TabPadding = 18.000000000000000000
      Images = SVGIconImageList1
      OnItemClick = sideNavItemClick
      BackgroundColor = x00FFFFFF
      BorderColor = x00FFFFFF
      BorderWidth = 0.000000000000000000
    end
  end
  object pnlMain: TDSkPanel
    Left = 260
    Top = 0
    Width = 1060
    Height = 859
    Align = alClient
    Caption = ''
    CaptionPosition = cpTopLeft
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -20
    CaptionFont.Name = 'Microsoft YaHei UI'
    CaptionFont.Style = []
    CaptionMargin = 8.000000000000000000
    ChildPadding = 8.000000000000000000
    BackgroundHover = xFFF7F9FC
    BackgroundColor = xFFF7F9FC
    BorderColor = x00FFFFFF
    BorderWidth = 0.000000000000000000
    ExplicitHeight = 820
    object pnlHeader: TDSkPanel
      Left = 0
      Top = 0
      Width = 1060
      Height = 76
      Align = alTop
      Caption = ''
      CaptionPosition = cpTopLeft
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -20
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      ChildPadding = 8.000000000000000000
      BackgroundHover = claWhite
      BackgroundColor = claWhite
      BorderColor = xFFE6EAF0
      BorderWidth = 0.000000000000000000
      object lblHeaderTitle: TDSkLabel
        Left = 28
        Top = 16
        Width = 369
        Height = 19
        Caption = 'SkiaVclControls Admin Dashboard'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2171169
        Font.Height = -21
        Font.Name = 'Microsoft YaHei UI'
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
      object lblHeaderSubtitle: TDSkLabel
        Left = 30
        Top = 45
        Width = 353
        Height = 15
        Caption = 'Material Design 3 inspired VCL controls built with Delphi Skia'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7697781
        Font.Height = -12
        Font.Name = 'Microsoft YaHei UI'
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
    end
    object pnlContent: TDSkPanel
      Left = 0
      Top = 76
      Width = 1060
      Height = 783
      Align = alClient
      Caption = ''
      CaptionPosition = cpTopLeft
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -20
      CaptionFont.Name = 'Microsoft YaHei UI'
      CaptionFont.Style = []
      CaptionMargin = 8.000000000000000000
      ChildPadding = 8.000000000000000000
      BackgroundHover = xFFF7F9FC
      BackgroundColor = xFFF7F9FC
      BorderColor = x00FFFFFF
      BorderWidth = 0.000000000000000000
      ExplicitHeight = 744
      object pnlPageHeader: TDSkPanel
        Left = 0
        Top = 0
        Width = 1060
        Height = 86
        Align = alTop
        Caption = ''
        CaptionPosition = cpTopLeft
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -20
        CaptionFont.Name = 'Microsoft YaHei UI'
        CaptionFont.Style = []
        CaptionMargin = 8.000000000000000000
        ChildPadding = 8.000000000000000000
        BackgroundHover = xFFF7F9FC
        BackgroundColor = xFFF7F9FC
        BorderColor = x00FFFFFF
        BorderWidth = 0.000000000000000000
        object lblPageTitle: TDSkLabel
          Left = 4
          Top = 4
          Width = 92
          Height = 22
          Caption = 'Button'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 2171169
          Font.Height = -27
          Font.Name = 'Microsoft YaHei UI'
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
        object lblPageDescription: TDSkLabel
          Left = 6
          Top = 43
          Width = 355
          Height = 15
          Caption = 'Filled, outlined, text, toggle, icon and interaction states.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 7697781
          Font.Height = -13
          Font.Name = 'Microsoft YaHei UI'
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
      end
      object pnlFrameHost: TDSkPanel
        Left = 0
        Top = 86
        Width = 1060
        Height = 697
        Align = alClient
        Caption = ''
        CaptionPosition = cpTopLeft
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -20
        CaptionFont.Name = 'Microsoft YaHei UI'
        CaptionFont.Style = []
        CaptionMargin = 8.000000000000000000
        ChildPadding = 8.000000000000000000
        BackgroundHover = claWhite
        CornerRadius = 18.000000000000000000
        BackgroundColor = claWhite
        BorderColor = xFFE4E9F1
        BorderWidth = 1.000000000000000000
        ExplicitHeight = 658
        inline frameButton: TFrameButtonDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          TabOrder = 1
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 633
            ExplicitHeight = 594
            inherited rgStyle: TDSkRadioGroup
              ExplicitTop = 171
            end
            inherited rgHover: TDSkRadioGroup
              ExplicitTop = 3
              ExplicitWidth = 274
            end
          end
          inherited pnlPreview: TDSkPanel
            Width = 780
            Height = 633
            ExplicitWidth = 780
            ExplicitHeight = 594
          end
        end
        inline framePanel: TFramePanelDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          TabOrder = 2
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 633
            ExplicitHeight = 594
          end
          inherited pnlPreview: TDSkPanel
            Width = 780
            Height = 633
            ExplicitWidth = 780
            ExplicitHeight = 594
          end
        end
        inline frameButtonGroup: TFrameButtonGroupDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          TabOrder = 3
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 633
            ExplicitHeight = 594
          end
          inherited pnlPreview: TDSkPanel
            Width = 772
            Height = 633
            ExplicitWidth = 772
            ExplicitHeight = 594
          end
        end
        inline frameRadio: TFrameRadioDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 4
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 633
            ExplicitHeight = 594
          end
          inherited pnlPreview: TDSkPanel
            Width = 780
            Height = 633
            ExplicitWidth = 780
            ExplicitHeight = 594
          end
        end
        inline frameCheckbox: TFrameCheckboxDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 5
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 633
            ExplicitHeight = 594
          end
          inherited pnlPreview: TDSkPanel
            Left = 280
            Width = 780
            Height = 633
            ExplicitLeft = 280
            ExplicitWidth = 780
            ExplicitHeight = 594
          end
        end
        inline frameSwitch: TFrameSwitchDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 6
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
        end
        inline frameSelect: TFrameSelectDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 7
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 547
            ExplicitTop = 150
            ExplicitHeight = 508
          end
          inherited pnlPreview: TDSkPanel
            Width = 860
            Height = 547
            ExplicitLeft = 200
            ExplicitTop = 150
            ExplicitWidth = 860
            ExplicitHeight = 508
          end
        end
        inline frameEdit: TFrameEditDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 8
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 649
            ExplicitHeight = 610
            inherited rgSize: TDSkRadioGroup
              ExplicitTop = 143
            end
          end
          inherited pnlPreview: TDSkPanel
            Width = 780
            Height = 649
            ExplicitWidth = 780
            ExplicitHeight = 610
          end
        end
        inline frameSlider: TFrameSliderDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 9
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
        end
        inline frameProgress: TFrameProgressDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 10
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 633
            ExplicitHeight = 594
          end
          inherited pnlPreview: TDSkPanel
            Width = 780
            Height = 633
            ExplicitWidth = 780
            ExplicitHeight = 594
          end
        end
        inline frameStepper: TFrameStepperDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 11
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 640
            ExplicitHeight = 601
          end
          inherited pnlPreview: TDSkPanel
            Width = 860
            Height = 640
            ExplicitWidth = 860
            ExplicitHeight = 601
            inherited lblPreviewTitle: TDSkLabel
              Width = 854
              ExplicitWidth = 854
            end
            inherited stepperMain: TDSkStepper
              Top = 24
              Width = 854
              ExplicitLeft = 3
              ExplicitTop = 24
              ExplicitWidth = 854
            end
          end
        end
        inline frameTabs: TFrameTabsDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          TabOrder = 12
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 633
            ExplicitHeight = 594
          end
          inherited pnlPreview: TDSkPanel
            Width = 780
            Height = 633
            ExplicitWidth = 780
            ExplicitHeight = 594
          end
        end
        inline frameLabel: TFrameLabelDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 13
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
          inherited pnlHeader: TDSkPanel
            Width = 1060
            ExplicitWidth = 1060
          end
          inherited pnlControl: TDSkPanel
            Height = 633
            ExplicitHeight = 594
            inherited pnlControlBadge: TDSkPanel
              ChildPadding = 8.000000000000000000
            end
          end
          inherited pnlPreview: TDSkPanel
            Width = 780
            Height = 633
            ExplicitWidth = 780
            ExplicitHeight = 594
            inherited cardHero: TDSkPanel
              ChildPadding = 8.000000000000000000
            end
            inherited cardOutline: TDSkPanel
              ChildPadding = 8.000000000000000000
            end
            inherited cardNeon: TDSkPanel
              ChildPadding = 8.000000000000000000
              inherited lblNeon: TDSkLabel
                ShadowOffsetY = 2.000000000000000000
              end
            end
            inherited cardAlign: TDSkPanel
              ChildPadding = 8.000000000000000000
              inherited pnlAlignBox: TDSkPanel
                ChildPadding = 8.000000000000000000
              end
            end
            inherited cardDisabled: TDSkPanel
              ChildPadding = 8.000000000000000000
            end
          end
        end
        inline frameSnackbar: TFrameSnackbarDemo
          Left = 0
          Top = 0
          Width = 1060
          Height = 697
          Align = alClient
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          Visible = False
          ExplicitWidth = 1060
          ExplicitHeight = 658
        end
      end
    end
  end
  object SVGIconImageList1: TSVGIconImageList
    SVGIconItems = <
      item
        IconName = 'button'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M5 7h14a3 ' +
          '3 0 0 1 3 3v4a3 3 0 0 1-3 3H5a3 3 0 0 1-3-3v-4a3 3 0 0 1 3-3zm0 ' +
          '2a1 1 0 0 0-1 1v4a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-4a1 1 0 0 0-1-' +
          '1H5zm3 2h8v2H8v-2z"/></svg>'
      end
      item
        IconName = 'label'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M4 5h16v3h' +
          '-2V7h-5v10h2v2H9v-2h2V7H6v1H4V5zm3 9h2l-2 5H5l2-5zm10 0l2 5h-2l-' +
          '2-5h2z"/></svg>'
      end
      item
        IconName = 'panel'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M4 4h16a2 ' +
          '2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2zm0 ' +
          '5v9h16V9H4zm0-3v1h16V6H4z"/></svg>'
      end
      item
        IconName = 'edit'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M4 5h10v2H' +
          '6v10h12v-5h2v7H4V5zm13.7-.3 1.6 1.6-7.9 7.9-2.4.8.8-2.4 7.9-7.9z' +
          'M20.4 3.6l.8.8a1 1 0 0 1 0 1.4l-.7.7-2.3-2.3.8-.6a1 1 0 0 1 1.4 ' +
          '0z"/></svg>'
      end
      item
        IconName = 'select'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M5 5h14a2 ' +
          '2 0 0 1 2 2v4H3V7a2 2 0 0 1 2-2zm0 2v2h14V7H5zm-2 6h18v4a2 2 0 0' +
          ' 1-2 2H5a2 2 0 0 1-2-2v-4zm5 1.5L12 18l4-3.5H8z"/></svg>'
      end
      item
        IconName = 'radio'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M7 7a5 5 0' +
          ' 1 1 0 10A5 5 0 0 1 7 7zm0 2a3 3 0 1 0 0 6 3 3 0 0 0 0-6zm7 1h7v' +
          '2h-7v-2zm0 4h5v2h-5v-2z"/></svg>'
      end
      item
        IconName = 'checkbox'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M4 5h8v8H4' +
          'V5zm2 2v4h4V7H6zm10.6-.6L18 7.8l-4.6 4.6L11 10l1.4-1.4 1 1 3.2-3' +
          '.2zM4 16h8v2H4v-2zm12 0h5v2h-5v-2z"/></svg>'
      end
      item
        IconName = 'switch'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M8 7h8a5 5' +
          ' 0 0 1 0 10H8A5 5 0 0 1 8 7zm0 2a3 3 0 0 0 0 6h8a3 3 0 0 0 0-6H8' +
          'zm8 1a2 2 0 1 1 0 4 2 2 0 0 1 0-4z"/></svg>'
      end
      item
        IconName = 'slider'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M4 7h10v2H' +
          '4V7zm14-2a3 3 0 1 1 0 6 3 3 0 0 1 0-6zM4 15h4v2H4v-2zm8-2a3 3 0 ' +
          '1 1 0 6 3 3 0 0 1 0-6zm6 2h2v2h-2v-2z"/></svg>'
      end
      item
        IconName = 'progress'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M5 5h14v2H' +
          '5V5zm0 6h14v8H5v-8zm2 2v4h7v-4H7zm9 0v4h1v-4h-1z"/></svg>'
      end
      item
        IconName = 'snackbar'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M5 5h14a2 ' +
          '2 0 0 1 2 2v7a2 2 0 0 1-2 2h-7l-4 3v-3H5a2 2 0 0 1-2-2V7a2 2 0 0' +
          ' 1 2-2zm0 2v7h5v1l1.3-1H19V7H5zm2 2h10v2H7V9z"/></svg>'
      end
      item
        IconName = 'button-group'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M4 7h16a2 ' +
          '2 0 0 1 2 2v6a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2zm0 2' +
          'v6h5V9H4zm7 0v6h5V9h-5zm7 0v6h2V9h-2z"/></svg>'
      end
      item
        IconName = 'tabs'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M3 5h7v4H3' +
          'V5zm9 0h9v4h-9V5zM3 11h18v8H3v-8zm2 2v4h14v-4H5z"/></svg>'
      end
      item
        IconName = 'stepper'
        SVGText = 
          '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M6 5a3 3 0' +
          ' 0 1 2.8 2h6.4A3 3 0 1 1 18 11a3 3 0 0 1-2.8-2H8.8A3 3 0 1 1 6 5' +
          'zm0 2a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm12 0a1 1 0 1 0 0 2 1 1 0 0 0 ' +
          '0-2zM6 14a3 3 0 0 1 2.8 2H20v2H8.8A3 3 0 1 1 6 14zm0 2a1 1 0 1 0' +
          ' 0 2 1 1 0 0 0 0-2z"/></svg>'
      end>
    Scaled = True
    Left = 932
    Top = 642
  end
end
