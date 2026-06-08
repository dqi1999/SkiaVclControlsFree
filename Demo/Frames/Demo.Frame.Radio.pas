unit Demo.Frame.Radio;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Types,
  SkiaVclControls.Radio, SkiaVclControls.RadioGroup, SkiaVclControls.Checkbox,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameRadioDemo = class(TFrame)
    lblLayout: TDSkLabel;
    rgLayout: TDSkRadioGroup;
    lblColor: TDSkLabel;
    rgColor: TDSkRadioGroup;
    lblLabelPos: TDSkLabel;
    rgLabelPos: TDSkRadioGroup;
    lblPreviewTitle: TDSkLabel;
    rgVertical: TDSkRadioGroup;
    rgHorizontal: TDSkRadioGroup;
    radioStandalone1: TDSkRadio;
    radioStandalone2: TDSkRadio;
    radioStandalone3: TDSkRadio;
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    procedure rgLayoutItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgLabelPosItemClick(Sender: TObject; RadioIndex: Integer);
  private
    procedure SetupPanels;
    procedure UpdateRadios;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameRadioDemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetupPanels;
  UpdateRadios;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameRadioDemo.SetupPanels;
begin
  // Header
  pnlHeader.Caption := 'Radio Component Demo';
  pnlHeader.CaptionPosition := cpLeftCenter;
  pnlHeader.CaptionFont.Size := 20;
  pnlHeader.CaptionFont.Style := [fsBold];
  pnlHeader.CaptionFont.Name := '微软雅黑';
  pnlHeader.CaptionMargin := 24;
  pnlHeader.ChildPadding := 8;
  pnlHeader.PanelStyle := psSurface;
  pnlHeader.BackgroundColor := MD3_SURFACE_CONTAINER;
  pnlHeader.CornerRadius := 0;
  pnlHeader.BorderWidth := 0;

  // Control panel
  pnlControl.Caption := '';
  pnlControl.CaptionPosition := cpTopLeft;
  pnlControl.ChildPadding := 16;
  pnlControl.PanelStyle := psElevated;
  pnlControl.BackgroundColor := MD3_SURFACE_CONTAINER;
  pnlControl.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  pnlControl.BorderWidth := 0;

  // Preview panel
  pnlPreview.Caption := '';
  pnlPreview.CaptionPosition := cpTopLeft;
  pnlPreview.ChildPadding := 24;
  pnlPreview.PanelStyle := psOutlined;
  pnlPreview.BackgroundColor := MD3_SURFACE_CONTAINER;
  pnlPreview.CornerRadius := MD3_CORNER_RADIUS_MEDIUM;
  pnlPreview.BorderColor := MD3_OUTLINE;
  pnlPreview.BorderWidth := 1;
end;

procedure TFrameRadioDemo.rgLayoutItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateRadios;
end;

procedure TFrameRadioDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateRadios;
end;

procedure TFrameRadioDemo.rgLabelPosItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateRadios;
end;

procedure TFrameRadioDemo.UpdateRadios;
var
  LColor: TDSkMUIColorScheme;
  LLabelPos: TDSkRadioLabelPlacement;
begin
  case rgColor.ItemIndex of
    1: LColor := muiSecondary;
    2: LColor := muiError;
    3: LColor := muiWarning;
    4: LColor := muiInfo;
    5: LColor := muiSuccess;
  else
    LColor := muiPrimary;
  end;
  
  case rgLabelPos.ItemIndex of
    1: LLabelPos := rlpLeft;
    2: LLabelPos := rlpTop;
    3: LLabelPos := rlpBottom;
  else
    LLabelPos := rlpRight;
  end;
  
  case rgLayout.ItemIndex of
    0: begin
      rgVertical.Orientation := rgoVertical;
      rgHorizontal.Orientation := rgoHorizontal;
    end;
    1: begin
      rgVertical.Orientation := rgoHorizontal;
      rgHorizontal.Orientation := rgoVertical;
    end;
  end;
  
  rgVertical.ColorScheme := LColor;
  rgHorizontal.ColorScheme := LColor;
  rgVertical.LabelPlacement := LLabelPos;
  rgHorizontal.LabelPlacement := LLabelPos;
  radioStandalone1.ColorScheme := LColor;
  radioStandalone2.ColorScheme := LColor;
  radioStandalone3.ColorScheme := LColor;
  radioStandalone1.LabelPlacement := LLabelPos;
  radioStandalone2.LabelPlacement := LLabelPos;
  radioStandalone3.LabelPlacement := LLabelPos;
end;



end.
