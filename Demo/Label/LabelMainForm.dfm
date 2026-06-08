object FormLabelDemo: TFormLabelDemo
  Left = 0
  Top = 0
  Caption = 'Label Component Demo - SkiaVclControls'
  ClientHeight = 760
  ClientWidth = 1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Microsoft YaHei UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 17
  inline FrameLabel: TFrameLabelDemo
    Left = 0
    Top = 0
    Width = 1080
    Height = 760
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    ExplicitWidth = 1080
    ExplicitHeight = 760
    inherited pnlHeader: TDSkPanel
      Width = 1080
      ExplicitWidth = 1080
    end
    inherited pnlControl: TDSkPanel
      Height = 696
      ExplicitHeight = 696
      inherited pnlControlBadge: TDSkPanel
        ChildPadding = 8.000000000000000000
      end
    end
    inherited pnlPreview: TDSkPanel
      Width = 800
      Height = 696
      ExplicitWidth = 800
      ExplicitHeight = 696
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
        inherited lblDisabled: TDSkLabel
          Width = 147
          Height = 46
          AutoSize = True
          ExplicitWidth = 147
          ExplicitHeight = 46
        end
      end
    end
  end
end
