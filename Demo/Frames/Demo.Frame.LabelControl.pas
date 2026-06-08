unit Demo.Frame.LabelControl;

interface

uses
  System.Classes,
  Vcl.Forms, Vcl.Controls,
  SkiaVclControls.Panel, SkiaVclControls.LabelControl;

type
  TFrameLabelDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    lblControlTitle: TDSkLabel;
    lblControlDesc: TDSkLabel;
    lblPropGradientName: TDSkLabel;
    lblPropGradientValue: TDSkLabel;
    lblPropOutlineName: TDSkLabel;
    lblPropOutlineValue: TDSkLabel;
    lblPropGlowName: TDSkLabel;
    lblPropGlowValue: TDSkLabel;
    lblPropAlignName: TDSkLabel;
    lblPropAlignValue: TDSkLabel;
    lblPropDisabledName: TDSkLabel;
    lblPropDisabledValue: TDSkLabel;
    pnlControlBadge: TDSkPanel;
    lblControlBadge: TDSkLabel;
    lblPreviewTitle: TDSkLabel;
    cardHero: TDSkPanel;
    lblHeroTitle: TDSkLabel;
    lblHeroDesc: TDSkLabel;
    cardOutline: TDSkPanel;
    lblOutlineCaption: TDSkLabel;
    lblOutline: TDSkLabel;
    cardNeon: TDSkPanel;
    lblNeonCaption: TDSkLabel;
    lblNeon: TDSkLabel;
    cardAlign: TDSkPanel;
    lblAlignCaption: TDSkLabel;
    pnlAlignBox: TDSkPanel;
    lblAlignText: TDSkLabel;
    cardDisabled: TDSkPanel;
    lblDisabledCaption: TDSkLabel;
    lblDisabled: TDSkLabel;
    lblDisabledDesc: TDSkLabel;
  end;

implementation

{$R *.dfm}

end.
