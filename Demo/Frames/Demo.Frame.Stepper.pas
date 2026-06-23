unit Demo.Frame.Stepper;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, SkiaVclControls.LabelControl, SkiaVclControls.Panel, SkiaVclControls.Button, SkiaVclControls.Types,
  SkiaVclControls.Stepper, SkiaVclControls.RadioGroup, SkiaVclControls.Checkbox,
  System.Skia, Vcl.Skia, Demo.Styles, SkiaVclControls.Base;

type
  TFrameStepperDemo = class(TFrame)
    pnlHeader: TDSkPanel;
    pnlControl: TDSkPanel;
    lblOrientation: TDSkLabel;
    rgOrientation: TDSkRadioGroup;
    lblVariant: TDSkLabel;
    rgVariant: TDSkRadioGroup;
    lblColor: TDSkLabel;
    rgColor: TDSkRadioGroup;
    chkAutoFit: TDSkCheckbox;
    pnlPreview: TDSkPanel;
    lblPreviewTitle: TDSkLabel;
    lblInfo: TDSkLabel;
    stepperMain: TDSkStepper;
    btnPrev: TDSkButton;
    btnNext: TDSkButton;
    btnReset: TDSkButton;
    procedure rgOrientationItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgColorItemClick(Sender: TObject; RadioIndex: Integer);
    procedure chkAutoFitCheckChanged(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
  private
    function IsStepperCompleted: Boolean;
    procedure ResetStepper;
    procedure UpdateStepper;
    procedure UpdateInfo;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetupPanels;
  end;

implementation

{$R *.dfm}



procedure TFrameStepperDemo.rgOrientationItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateStepper;
end;

procedure TFrameStepperDemo.rgVariantItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateStepper;
end;

procedure TFrameStepperDemo.rgColorItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateStepper;
end;

procedure TFrameStepperDemo.chkAutoFitCheckChanged(Sender: TObject);
begin
  stepperMain.AutoFit := chkAutoFit.Checked;
end;

procedure TFrameStepperDemo.btnPrevClick(Sender: TObject);
begin
  stepperMain.PrevStep;
  UpdateInfo;
end;

procedure TFrameStepperDemo.btnNextClick(Sender: TObject);
begin
  stepperMain.NextStep;
  UpdateInfo;
end;

procedure TFrameStepperDemo.btnResetClick(Sender: TObject);
begin
  ResetStepper;
end;

function TFrameStepperDemo.IsStepperCompleted: Boolean;
var
  I: Integer;
begin
  Result := stepperMain.Steps.Count > 0;
  for I := 0 to stepperMain.Steps.Count - 1 do
    if stepperMain.Steps[I].Status <> ssCompleted then
      Exit(False);
end;

procedure TFrameStepperDemo.ResetStepper;
var
  I: Integer;
begin
  for I := 0 to stepperMain.Steps.Count - 1 do
    stepperMain.Steps[I].Status := ssPending;
  if stepperMain.Steps.Count > 0 then
    stepperMain.Steps[0].Status := ssActive;
  stepperMain.ActiveStep := 0;
  UpdateInfo;
end;

procedure TFrameStepperDemo.UpdateStepper;
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
  
  case rgOrientation.ItemIndex of
    0: stepperMain.Orientation := stoHorizontal;
    1: stepperMain.Orientation := stoVertical;
  end;
  
  case rgVariant.ItemIndex of
    0: stepperMain.Variant := svLinear;
    1: stepperMain.Variant := svNonLinear;
  end;
  
  stepperMain.ColorScheme := LColor;
end;

procedure TFrameStepperDemo.UpdateInfo;
begin
  if IsStepperCompleted then
    lblInfo.Caption := Format('Completed: %d steps', [stepperMain.Steps.Count])
  else
    lblInfo.Caption := Format('Current: Step %d of %d',
      [stepperMain.ActiveStep + 1, stepperMain.Steps.Count]);
end;

constructor TFrameStepperDemo.Create(AOwner: TComponent);
begin
  inherited;
  SetupPanels;
  ResetStepper;
  ApplyAdminFrameStyle(Self);
end;

procedure TFrameStepperDemo.SetupPanels;
begin
  // 初始化面板布局
  pnlHeader.Align := alTop;
  pnlHeader.Height := 40;
  pnlControl.Align := alLeft;
  pnlControl.Width := 280;
  pnlPreview.Align := alClient;
end;

end.
