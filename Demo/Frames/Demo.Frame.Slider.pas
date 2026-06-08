unit Demo.Frame.Slider;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Types,
  SkiaVclControls.Slider, SkiaVclControls.RadioGroup, SkiaVclControls.Checkbox,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameSliderDemo = class(TFrame)
    lblType: TDSkLabel;
    rgType: TDSkRadioGroup;
    lblColor: TDSkLabel;
    rgColor: TDSkRadioGroup;
    chkMarks: TDSkCheckbox;
    chkVertical: TDSkCheckbox;
    lblPreviewTitle: TDSkLabel;
    lblBasic: TDSkLabel;
    sliderBasic: TDSkSlider;
    lblStep: TDSkLabel;
    sliderStep: TDSkSlider;
    lblRange: TDSkLabel;
    sliderRange: TDSkSlider;
    sliderVertical: TDSkSlider;
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    procedure rgTypeItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure chkMarksCheckChanged(Sender: TObject);
    procedure chkVerticalCheckChanged(Sender: TObject);
    procedure sliderBasicChange(Sender: TObject; Value: Single);
    procedure sliderStepChange(Sender: TObject; Value: Single);
    procedure sliderRangeRangeChange(Sender: TObject; LowValue, HighValue: Single);
  private
    procedure UpdateSliders;
    procedure SetupPanels;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameSliderDemo.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameSliderDemo.SetupPanels;
begin
  // Header
  pnlHeader.Caption := 'Slider Component Demo';
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

procedure TFrameSliderDemo.rgTypeItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateSliders;
end;

procedure TFrameSliderDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateSliders;
end;

procedure TFrameSliderDemo.chkMarksCheckChanged(Sender: TObject);
begin
  sliderBasic.ShowMarks := chkMarks.Checked;
  sliderStep.ShowMarks := chkMarks.Checked;
  sliderRange.ShowMarks := chkMarks.Checked;
  sliderVertical.ShowMarks := chkMarks.Checked;
end;

procedure TFrameSliderDemo.chkVerticalCheckChanged(Sender: TObject);
begin
  sliderVertical.Visible := chkVertical.Checked;
end;

procedure TFrameSliderDemo.sliderBasicChange(Sender: TObject; Value: Single);
begin
  lblBasic.Caption := Format('Basic: %.0f', [sliderBasic.Value]);
end;

procedure TFrameSliderDemo.sliderStepChange(Sender: TObject; Value: Single);
begin
  lblStep.Caption := Format('Discrete: %.0f', [sliderStep.Value]);
end;

procedure TFrameSliderDemo.sliderRangeRangeChange(Sender: TObject; LowValue, HighValue: Single);
begin
  lblRange.Caption := Format('Range: %.0f - %.0f', [sliderRange.ValueLow, sliderRange.ValueHigh]);
end;

procedure TFrameSliderDemo.UpdateSliders;
var
  LColor: TDSkMUIColorScheme;
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
  
  sliderBasic.ColorScheme := LColor;
  sliderStep.ColorScheme := LColor;
  sliderRange.ColorScheme := LColor;
  sliderVertical.ColorScheme := LColor;
end;

end.
