object FormButtonDemo: TFormButtonDemo
  Left = 0
  Top = 0
  Caption = 'Button Component Demo - SkiaVclControls'
  ClientHeight = 844
  ClientWidth = 1220
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  inline FrameButton: TFrameButtonDemo
    Left = 0
    Top = 0
    Width = 1220
    Height = 844
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 1098
    ExplicitHeight = 692
    inherited pnlHeader: TDSkPanel
      Width = 1220
      ExplicitWidth = 1098
    end
    inherited pnlControl: TDSkPanel
      Height = 780
      ExplicitHeight = 628
      inherited lblOptions: TDSkLabel
      end
      inherited lblRadius: TDSkLabel
      end
    end
    inherited pnlPreview: TDSkPanel
      Width = 940
      Height = 780
      ExplicitWidth = 818
      ExplicitHeight = 628
      inherited lblPreviewTitle: TDSkLabel
      end
    end
  end
end
