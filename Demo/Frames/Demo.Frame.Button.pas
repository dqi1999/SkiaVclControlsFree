unit Demo.Frame.Button;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Button, SkiaVclControls.Types,
  SkiaVclControls.RadioGroup, SkiaVclControls.Checkbox, SkiaVclControls.Slider,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameButtonDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    pnlPreview: TDSkPanel;
    rgStyle: TDSkRadioGroup;
    rgColor: TDSkRadioGroup;
    lblPreviewTitle: TDSkLabel;
    btnContained: TDSkButton;
    btnOutlined: TDSkButton;
    btnDisabled: TDSkButton;
    btnToggle: TDSkButton;
    btnCustom: TDSkButton;
    btnText: TDSkButton;
    rgHover: TDSkRadioGroup;
    DSkPanel1: TDSkPanel;
    sliderCornerRadius: TDSkSlider;
    lblRadius: TDSkLabel;
    chkToggle: TDSkCheckbox;
    chkEnabled: TDSkCheckbox;
    lblOptions: TDSkLabel;
    procedure rgStyleItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgHoverItemClick(Sender: TObject; RadioIndex: Integer);
    procedure chkEnabledCheckChanged(Sender: TObject);
    procedure chkToggleCheckChanged(Sender: TObject);
    procedure sliderCornerRadiusChange(Sender: TObject; Value: Single);
  private
    procedure UpdateButtonStyles;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TFrameButtonDemo.Create(AOwner: TComponent);
begin
  inherited;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameButtonDemo.rgStyleItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateButtonStyles;
end;

procedure TFrameButtonDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateButtonStyles;
end;

procedure TFrameButtonDemo.rgHoverItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateButtonStyles;
end;

procedure TFrameButtonDemo.chkEnabledCheckChanged(Sender: TObject);
begin
  btnContained.Enabled := chkEnabled.Checked;
  btnOutlined.Enabled := chkEnabled.Checked;
  btnText.Enabled := chkEnabled.Checked;
  btnToggle.Enabled := chkEnabled.Checked;
  btnCustom.Enabled := chkEnabled.Checked;
end;

procedure TFrameButtonDemo.chkToggleCheckChanged(Sender: TObject);
begin
  if chkToggle.Checked then
  begin
    btnContained.ButtonType := btToggle;
    btnOutlined.ButtonType := btToggle;
    btnText.ButtonType := btToggle;
  end
  else
  begin
    btnContained.ButtonType := btNormal;
    btnOutlined.ButtonType := btNormal;
    btnText.ButtonType := btNormal;
  end;
end;

procedure TFrameButtonDemo.sliderCornerRadiusChange(Sender: TObject; Value: Single);
var
  LRadius: Single;
begin
  LRadius := sliderCornerRadius.Value;
  btnContained.ButtonRound := LRadius;
  btnContained.CornerRadius := LRadius;
  btnOutlined.ButtonRound := LRadius;
  btnOutlined.CornerRadius := LRadius;
  btnText.ButtonRound := LRadius;
  btnText.CornerRadius := LRadius;
  btnDisabled.ButtonRound := LRadius;
  btnDisabled.CornerRadius := LRadius;
  btnToggle.ButtonRound := LRadius;
  btnToggle.CornerRadius := LRadius;
  btnCustom.ButtonRound := LRadius;
  btnCustom.CornerRadius := LRadius;
end;

procedure TFrameButtonDemo.UpdateButtonStyles;
var
  LColorScheme: TDSkMUIColorScheme;
  LMUIStyle: TDSkMUIStyle;
  LHover: TDSkHoverEffect;
begin
  case rgColor.ItemIndex of
    1: LColorScheme := muiSecondary;
    2: LColorScheme := muiError;
    3: LColorScheme := muiWarning;
    4: LColorScheme := muiInfo;
    5: LColorScheme := muiSuccess;
  else
    LColorScheme := muiPrimary;
  end;

  case rgStyle.ItemIndex of
    1: LMUIStyle := muiOutlined;
    2: LMUIStyle := muiText;
  else
    LMUIStyle := muiContained;
  end;

  case rgHover.ItemIndex of
    1: LHover := heRipple;
    2: LHover := heGlow;
    3: LHover := heScaleUp;
  else
    LHover := heNone;
  end;

  btnContained.MUIColorScheme := LColorScheme;
  btnContained.MUIStyle := LMUIStyle;
  btnContained.HoverEffect := LHover;

  btnOutlined.MUIColorScheme := LColorScheme;
  btnOutlined.MUIStyle := muiOutlined;
  btnOutlined.HoverEffect := LHover;

  btnText.MUIColorScheme := LColorScheme;
  btnText.MUIStyle := muiText;
  btnText.HoverEffect := LHover;

  btnDisabled.MUIColorScheme := LColorScheme;
  btnDisabled.MUIStyle := LMUIStyle;

  btnToggle.MUIColorScheme := LColorScheme;
  btnToggle.MUIStyle := LMUIStyle;
  btnToggle.HoverEffect := LHover;
end;

end.
