unit Demo.Frame.Progress;

interface

uses
  System.Classes, System.SysUtils, System.UITypes, System.Math,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, Vcl.ExtCtrls,
  SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Button, SkiaVclControls.Types,
  SkiaVclControls.ProgressBar, SkiaVclControls.CircularProgress,
  SkiaVclControls.RadioGroup, SkiaVclControls.Slider,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameProgressDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    lblVariant: TDSkLabel;
    rgVariant: TDSkRadioGroup;
    lblColor: TDSkLabel;
    rgColor: TDSkRadioGroup;
    lblValue: TDSkLabel;
    sliderValue: TDSkSlider;
    btnSimulate: TDSkButton;
    btnReset: TDSkButton;
    lblPreviewTitle: TDSkLabel;
    lblProgress: TDSkLabel;
    pbDeterminate: TDSkProgressBar;
    pbIndeterminate: TDSkProgressBar;
    pbBuffer: TDSkProgressBar;
    cpDeterminate: TDSkCircularProgress;
    cpIndeterminate: TDSkCircularProgress;
    tmrSimulate: TTimer;
    procedure rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure sliderValueChange(Sender: TObject; Value: Single);
    procedure btnSimulateClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure tmrSimulateTimer(Sender: TObject);
  private
    FSimulating: Boolean;
    FSimProgress: Single;
    procedure UpdateProgress;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetupPanels;
  end;

implementation

{$R *.dfm}

constructor TFrameProgressDemo.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameProgressDemo.SetupPanels;
begin
  // Header
  pnlHeader.Caption := 'Progress Component Demo';
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

procedure TFrameProgressDemo.rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateProgress;
end;

procedure TFrameProgressDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateProgress;
end;

procedure TFrameProgressDemo.sliderValueChange(Sender: TObject; Value: Single);
begin
  if not FSimulating then
  begin
    pbDeterminate.Value := sliderValue.Value;
    pbBuffer.Value := sliderValue.Value;
    pbBuffer.ValueBuffer := Min(100, sliderValue.Value + 20);
    cpDeterminate.Value := sliderValue.Value;
    lblProgress.Caption := Format('Progress: %.0f%%', [sliderValue.Value]);
  end;
end;

procedure TFrameProgressDemo.btnSimulateClick(Sender: TObject);
begin
  if FSimulating then Exit;
  FSimulating := True;
  FSimProgress := 0;
  tmrSimulate.Enabled := True;
  btnSimulate.ButtonText := 'Simulating...';
end;

procedure TFrameProgressDemo.btnResetClick(Sender: TObject);
begin
  FSimulating := False;
  tmrSimulate.Enabled := False;
  FSimProgress := 0;
  sliderValue.Value := 50;
  pbDeterminate.Value := 50;
  pbBuffer.Value := 50;
  pbBuffer.ValueBuffer := 70;
  cpDeterminate.Value := 50;
  lblProgress.Caption := 'Progress: 50%';
  btnSimulate.ButtonText := 'Simulate';
end;

procedure TFrameProgressDemo.tmrSimulateTimer(Sender: TObject);
begin
  FSimProgress := FSimProgress + 1;
  if FSimProgress > 100 then
  begin
    FSimulating := False;
    tmrSimulate.Enabled := False;
    btnSimulate.ButtonText := 'Simulate';
    Exit;
  end;
  
  pbDeterminate.Value := FSimProgress;
  pbBuffer.Value := FSimProgress;
  pbBuffer.ValueBuffer := Min(100, FSimProgress + 15);
  cpDeterminate.Value := FSimProgress;
  sliderValue.Value := FSimProgress;
  lblProgress.Caption := Format('Progress: %.0f%%', [FSimProgress]);
end;

procedure TFrameProgressDemo.UpdateProgress;
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
  
  pbDeterminate.ColorScheme := LColor;
  pbIndeterminate.ColorScheme := LColor;
  pbBuffer.ColorScheme := LColor;
  cpDeterminate.ColorScheme := LColor;
  cpIndeterminate.ColorScheme := LColor;
end;

end.
