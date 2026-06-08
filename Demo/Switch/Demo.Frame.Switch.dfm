object FrameSwitchDemo: TFrameSwitchDemo
  Left = 0
  Top = 0
  Width = 1024
  Height = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentColor = False
  TabOrder = 0
  pnlHeader: TDSkPanel
    Width = 1024
    Caption = 'Switch Component Demo'
  end
  pnlControl: TDSkPanel
    Height = 576
    object lblSize: TDSkLabel
      Left = 16
      Top = 16
      Width = 28
      Height = 17
      Caption = 'Size'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object rgSize: TDSkRadioGroup
      Left = 16
      Top = 40
      Width = 248
      Height = 80
      Items.Strings = (
        'Medium'
        'Small')
      ItemIndex = 0
      ColorScheme = muiPrimary
      OnItemClick = rgSizeItemClick
    end
    object lblLayout: TDSkLabel
      Left = 16
      Top = 128
      Width = 48
      Height = 17
      Caption = 'Layout'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object rgLayout: TDSkRadioGroup
      Left = 16
      Top = 152
      Width = 248
      Height = 80
      Items.Strings = (
        'Vertical'
        'Horizontal')
      ItemIndex = 0
      ColorScheme = muiPrimary
      OnItemClick = rgLayoutItemClick
    end
    object lblColor: TDSkLabel
      Left = 16
      Top = 240
      Width = 96
      Height = 17
      Caption = 'Color Scheme'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object rgColor: TDSkRadioGroup
      Left = 16
      Top = 264
      Width = 248
      Height = 180
      Items.Strings = (
        'Primary'
        'Secondary'
        'Error'
        'Warning'
        'Info'
        'Success')
      ItemIndex = 0
      ColorScheme = muiPrimary
      OnItemClick = rgColorItemClick
    end
  end
  pnlPreview: TDSkPanel
    Width = 736
    Height = 576
    object lblPreviewTitle: TDSkLabel
      Left = 40
      Top = 24
      Width = 120
      Height = 20
      Caption = 'Preview Area'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sgVertical: TDSkSwitchGroup
      Left = 40
      Top = 56
      Width = 250
      Height = 180
      Caption = 'Vertical Layout'
      Items.Strings = (
        'Wi-Fi'
        'Bluetooth'
        'Airplane Mode')
      ColorScheme = muiPrimary
      Orientation = rgoVertical
    end
    object sgHorizontal: TDSkSwitchGroup
      Left = 40
      Top = 256
      Width = 500
      Height = 80
      Caption = 'Horizontal Layout'
      Items.Strings = (
        'Option A'
        'Option B'
        'Option C')
      ColorScheme = muiPrimary
      Orientation = rgoHorizontal
    end
    object swStandalone1: TDSkSwitch
      Left = 40
      Top = 360
      Width = 200
      Height = 32
      Caption = 'Switch 1'
      Checked = True
      ColorScheme = muiPrimary
    end
    object swStandalone2: TDSkSwitch
      Left = 40
      Top = 400
      Width = 200
      Height = 32
      Caption = 'Switch 2'
      Checked = False
      ColorScheme = muiPrimary
    end
    object swStandalone3: TDSkSwitch
      Left = 40
      Top = 440
      Width = 200
      Height = 32
      Caption = 'Switch 3'
      Checked = False
      ColorScheme = muiPrimary
    end
  end
end
