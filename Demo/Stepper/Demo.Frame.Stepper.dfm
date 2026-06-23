object FrameStepperDemo: TFrameStepperDemo
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
    Caption = 'Stepper Component Demo'
  end
  pnlControl: TDSkPanel
    Height = 576
    object lblOrientation: TDSkLabel
      Left = 16
      Top = 16
      Width = 72
      Height = 17
      Caption = 'Orientation'
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
      Items.Strings = (
        'Horizontal'
        'Vertical')
      ItemIndex = 0
      ColorScheme = muiPrimary
      OnItemClick = rgOrientationItemClick
    end
    object lblVariant: TDSkLabel
      Left = 16
      Top = 128
      Width = 48
      Height = 17
      Caption = 'Variant'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object rgVariant: TDSkRadioGroup
      Left = 16
      Top = 152
      Width = 248
      Height = 80
      Items.Strings = (
        'Linear'
        'Non-Linear')
      ItemIndex = 0
      ColorScheme = muiPrimary
      OnItemClick = rgVariantItemClick
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
    object chkAutoFit: TDSkCheckbox
      Left = 16
      Top = 452
      Width = 248
      Height = 28
      Caption = 'Auto Fit Spacing'
      Checked = True
      ColorScheme = muiPrimary
      OnCheckChanged = chkAutoFitCheckChanged
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
    object stepperMain: TDSkStepper
      Left = 40
      Top = 56
      Width = 600
      Height = 120
      Orientation = stoHorizontal
      Variant = svLinear
      ColorScheme = muiPrimary
      AutoFit = True
    end
    object lblInfo: TDSkLabel
      Left = 40
      Top = 196
      Width = 200
      Height = 17
      Caption = 'Current: Step 1 of 4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
    end
    object btnPrev: TDSkButton
      Left = 40
      Top = 232
      Width = 100
      Height = 40
      ButtonText = 'Previous'
      MUIColorScheme = muiSecondary
      MUIStyle = muiOutlined
      OnClick = btnPrevClick
    end
    object btnNext: TDSkButton
      Left = 160
      Top = 232
      Width = 100
      Height = 40
      ButtonText = 'Next'
      MUIColorScheme = muiPrimary
      MUIStyle = muiContained
      OnClick = btnNextClick
    end
    object btnReset: TDSkButton
      Left = 280
      Top = 232
      Width = 100
      Height = 40
      ButtonText = 'Reset'
      MUIColorScheme = muiError
      MUIStyle = muiText
      OnClick = btnResetClick
    end
  end
end