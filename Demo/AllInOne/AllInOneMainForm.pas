unit AllInOneMainForm;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs,
  SkiaVclControls.Types, SkiaVclControls.Button, SkiaVclControls.Panel,
  SkiaVclControls.ButtonGroup, SkiaVclControls.Radio, SkiaVclControls.RadioGroup,
  SkiaVclControls.Checkbox, SkiaVclControls.CheckboxGroup,
  SkiaVclControls.Switch, SkiaVclControls.SwitchGroup,
  System.Skia, Vcl.Skia, SkiaVclControls.Base;

type
  TFormAllInOne = class(TForm)
    // 布局容器
    pnlMain: TDSkPanel;
    pnlHeader: TDSkPanel;
    pnlContent: TDSkPanel;
    pnlLeft: TDSkPanel;
    pnlRight: TDSkPanel;

    // 左侧：组件展示区
    pnlButtons: TDSkPanel;
    pnlRadios: TDSkPanel;
    pnlCheckboxes: TDSkPanel;
    pnlSwitches: TDSkPanel;
    pnlButtonGroup: TDSkPanel;
    pnlStyleControl: TDSkPanel;
    pnlStateControl: TDSkPanel;

    // 按钮组件
    btnPrimary: TDSkButton;
    btnSecondary: TDSkButton;
    btnSuccess: TDSkButton;
    btnWarning: TDSkButton;
    btnDanger: TDSkButton;
    btnInfo: TDSkButton;
    btnToggle: TDSkButton;

    // 按钮组
    bgActions: TDSkButtonGroup;
    bgHome: TDSkButton;
    bgData: TDSkButton;
    bgSettings: TDSkButton;

    // 单选按钮组
    rgColorScheme: TDSkRadioGroup;
    rgStyle: TDSkRadioGroup;

    // 复选框组
    cgFeatures: TDSkCheckboxGroup;
    cbEnabled: TDSkCheckbox;
    cbVisible: TDSkCheckbox;
    cbAnimated: TDSkCheckbox;

    // 开关
    swDarkMode: TDSkSwitch;
    swNotifications: TDSkSwitch;
    swAutoSave: TDSkSwitch;

    // 操作按钮
    btnReset: TDSkButton;
    btnAbout: TDSkButton;
    lblResult: TLabel;

    // 事件
    procedure FormCreate(Sender: TObject);
    procedure rgColorSchemeItemClick(Sender: TObject; RadioIndex: Integer);
    procedure rgStyleItemClick(Sender: TObject; RadioIndex: Integer);
    procedure cgFeaturesItemClick(Sender: TObject; ItemIndex: Integer; Checked: Boolean);
    procedure btnPrimaryClick(Sender: TObject);
    procedure btnSecondaryClick(Sender: TObject);
    procedure btnSuccessClick(Sender: TObject);
    procedure btnWarningClick(Sender: TObject);
    procedure btnDangerClick(Sender: TObject);
    procedure btnInfoClick(Sender: TObject);
    procedure btnToggleClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure swDarkModeSwitch(Sender: TObject);
    procedure swNotificationsSwitch(Sender: TObject);
    procedure swAutoSaveSwitch(Sender: TObject);
    procedure cbEnabledCheckChanged(Sender: TObject);
    procedure cbVisibleCheckChanged(Sender: TObject);
    procedure cbAnimatedCheckChanged(Sender: TObject);
    procedure bgActionsItemClick(Sender: TObject; ButtonIndex: Integer);
  private
    procedure UpdateColorScheme(AIndex: Integer);
    procedure UpdateStyle(AIndex: Integer);
    procedure UpdateComponentStates;
    procedure LogResult(const AMsg: string);
  end;

var
  FormAllInOne: TFormAllInOne;

implementation

{$R *.dfm}

procedure TFormAllInOne.FormCreate(Sender: TObject);
begin
  // 初始化颜色方案
  rgColorScheme.ItemIndex := 0;
  UpdateColorScheme(0);

  // 初始化样式
  rgStyle.ItemIndex := 0;
  UpdateStyle(0);

  // 设置按钮文字（DFM已设置，这里确认）
  btnToggle.ButtonType := btToggle;

  // 初始化复选框组
  cgFeatures.Items.Clear;
  cgFeatures.Items.Add('Feature A - Basic');
  cgFeatures.Items.Add('Feature B - Advanced');
  cgFeatures.Items.Add('Feature C - Premium');
  cgFeatures.Items.Add('Feature D - Enterprise');

  // 初始化开关
  swDarkMode.Checked := False;
  swNotifications.Checked := True;
  swAutoSave.Checked := True;

  UpdateComponentStates;
  LogResult('Welcome! Try the controls on the right panel.');
end;

procedure TFormAllInOne.rgColorSchemeItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateColorScheme(RadioIndex);
  LogResult('Color scheme: ' + rgColorScheme.Items[RadioIndex]);
end;

procedure TFormAllInOne.rgStyleItemClick(Sender: TObject; RadioIndex: Integer);
begin
  UpdateStyle(RadioIndex);
  LogResult('Button style: ' + rgStyle.Items[RadioIndex]);
end;

procedure TFormAllInOne.cgFeaturesItemClick(Sender: TObject; ItemIndex: Integer; Checked: Boolean);
var
  LMsg: string;
begin
  if Checked then
    LMsg := 'Enabled: ' + cgFeatures.Items[ItemIndex]
  else
    LMsg := 'Disabled: ' + cgFeatures.Items[ItemIndex];
  LogResult(LMsg);
end;

procedure TFormAllInOne.btnPrimaryClick(Sender: TObject);
begin
  LogResult('Primary button clicked!');
end;

procedure TFormAllInOne.btnSecondaryClick(Sender: TObject);
begin
  LogResult('Secondary button clicked!');
end;

procedure TFormAllInOne.btnSuccessClick(Sender: TObject);
begin
  LogResult('Success! Operation completed.');
  ShowMessage('Success! This is a success notification.');
end;

procedure TFormAllInOne.btnWarningClick(Sender: TObject);
begin
  LogResult('Warning! Please check your input.');
  ShowMessage('Warning! This is a warning notification.');
end;

procedure TFormAllInOne.btnDangerClick(Sender: TObject);
begin
  LogResult('Danger! This action cannot be undone.');
  if MessageDlg('Are you sure you want to delete?', mtWarning, mbYesNo, 0) = mrYes then
    LogResult('Item deleted.')
  else
    LogResult('Deletion cancelled.');
end;

procedure TFormAllInOne.btnInfoClick(Sender: TObject);
begin
  LogResult('Info: Here is some useful information.');
  ShowMessage('This is an informational message from the component library.');
end;

procedure TFormAllInOne.btnToggleClick(Sender: TObject);
begin
  if btnToggle.Checked then
    LogResult('Toggle button: ON')
  else
    LogResult('Toggle button: OFF');
end;

procedure TFormAllInOne.bgActionsItemClick(Sender: TObject; ButtonIndex: Integer);
begin
  case ButtonIndex of
    0: LogResult('ButtonGroup: Home clicked');
    1: LogResult('ButtonGroup: Data clicked');
    2: LogResult('ButtonGroup: Settings clicked');
  end;
end;

procedure TFormAllInOne.btnResetClick(Sender: TObject);
begin
  // 重置所有状态
  rgColorScheme.ItemIndex := 0;
  rgStyle.ItemIndex := 0;
  btnToggle.Checked := False;
  btnToggle.ButtonType := btToggle;

  cgFeatures.ClearCheckedItems;

  swDarkMode.Checked := False;
  swNotifications.Checked := True;
  swAutoSave.Checked := True;

  cbEnabled.Checked := True;
  cbVisible.Checked := True;
  cbAnimated.Checked := True;

  UpdateColorScheme(0);
  UpdateStyle(0);
  UpdateComponentStates;

  LogResult('All settings reset to default.');
end;

procedure TFormAllInOne.btnAboutClick(Sender: TObject);
begin
  ShowMessage(
    'SkiaVclControlsFree - All-in-One Demo' + sLineBreak + sLineBreak +
    'This demo showcases all available components:' + sLineBreak +
    '- TDSkButton / TDSkButtonGroup' + sLineBreak +
    '- TDSkRadio / TDSkRadioGroup' + sLineBreak +
    '- TDSkCheckbox / TDSkCheckboxGroup' + sLineBreak +
    '- TDSkSwitch' + sLineBreak +
    '- TDSkPanel' + sLineBreak + sLineBreak +
    'Material Design 3 style with Skia rendering.'
  );
end;

procedure TFormAllInOne.swDarkModeSwitch(Sender: TObject);
begin
  if swDarkMode.Checked then
    LogResult('Dark mode: Enabled')
  else
    LogResult('Dark mode: Disabled');
end;

procedure TFormAllInOne.swNotificationsSwitch(Sender: TObject);
begin
  if swNotifications.Checked then
    LogResult('Notifications: Enabled')
  else
    LogResult('Notifications: Disabled');
end;

procedure TFormAllInOne.swAutoSaveSwitch(Sender: TObject);
begin
  if swAutoSave.Checked then
    LogResult('Auto-save: Enabled')
  else
    LogResult('Auto-save: Disabled');
end;

procedure TFormAllInOne.cbEnabledCheckChanged(Sender: TObject);
begin
  UpdateComponentStates;
  if cbEnabled.Checked then
    LogResult('Components: Enabled')
  else
    LogResult('Components: Disabled');
end;

procedure TFormAllInOne.cbVisibleCheckChanged(Sender: TObject);
begin
  // 切换左侧展示面板的可见性
  pnlLeft.Visible := cbVisible.Checked;

  if cbVisible.Checked then
    LogResult('Components: Visible')
  else
    LogResult('Components: Hidden');
end;

procedure TFormAllInOne.cbAnimatedCheckChanged(Sender: TObject);
begin
  // 切换动画效果
  if cbAnimated.Checked then
  begin
    btnPrimary.HoverEffect := heRipple;
    btnSecondary.HoverEffect := heRipple;
    btnSuccess.HoverEffect := heRipple;
    btnWarning.HoverEffect := heRipple;
    btnDanger.HoverEffect := heRipple;
    btnInfo.HoverEffect := heRipple;
    btnToggle.HoverEffect := heRipple;
    btnReset.HoverEffect := heRipple;
    btnAbout.HoverEffect := heRipple;
    bgHome.HoverEffect := heRipple;
    bgData.HoverEffect := heRipple;
    bgSettings.HoverEffect := heRipple;
    LogResult('Animations: Enabled');
  end
  else
  begin
    btnPrimary.HoverEffect := heNone;
    btnSecondary.HoverEffect := heNone;
    btnSuccess.HoverEffect := heNone;
    btnWarning.HoverEffect := heNone;
    btnDanger.HoverEffect := heNone;
    btnInfo.HoverEffect := heNone;
    btnToggle.HoverEffect := heNone;
    btnReset.HoverEffect := heNone;
    btnAbout.HoverEffect := heNone;
    bgHome.HoverEffect := heNone;
    bgData.HoverEffect := heNone;
    bgSettings.HoverEffect := heNone;
    LogResult('Animations: Disabled');
  end;
end;

procedure TFormAllInOne.UpdateColorScheme(AIndex: Integer);
var
  LColorScheme: TDSkMUIColorScheme;
begin
  case AIndex of
    1: LColorScheme := muiSecondary;
    2: LColorScheme := muiError;
    3: LColorScheme := muiWarning;
    4: LColorScheme := muiInfo;
    5: LColorScheme := muiSuccess;
  else
    LColorScheme := muiPrimary;
  end;

  // 更新按钮颜色（保持各自的颜色方案）
  btnPrimary.MUIColorScheme := muiPrimary;
  btnSecondary.MUIColorScheme := muiSecondary;
  btnSuccess.MUIColorScheme := muiSuccess;
  btnWarning.MUIColorScheme := muiWarning;
  btnDanger.MUIColorScheme := muiError;
  btnInfo.MUIColorScheme := muiInfo;
  btnToggle.MUIColorScheme := LColorScheme;

  // 更新按钮组
  bgActions.ColorScheme := LColorScheme;

  // 更新单选按钮组
  rgColorScheme.ColorScheme := LColorScheme;
  rgStyle.ColorScheme := LColorScheme;

  // 更新复选框
  cgFeatures.ColorScheme := LColorScheme;
  cbEnabled.ColorScheme := LColorScheme;
  cbVisible.ColorScheme := LColorScheme;
  cbAnimated.ColorScheme := LColorScheme;

  // 更新开关
  swDarkMode.ColorScheme := LColorScheme;
  swNotifications.ColorScheme := LColorScheme;
  swAutoSave.ColorScheme := LColorScheme;

  // 更新操作按钮
  btnReset.MUIColorScheme := LColorScheme;
end;

procedure TFormAllInOne.UpdateStyle(AIndex: Integer);
var
  LStyle: TDSkMUIStyle;
begin
  case AIndex of
    1: LStyle := muiOutlined;
    2: LStyle := muiText;
  else
    LStyle := muiContained;
  end;

  btnPrimary.MUIStyle := LStyle;
  btnSecondary.MUIStyle := LStyle;
  btnSuccess.MUIStyle := LStyle;
  btnWarning.MUIStyle := LStyle;
  btnDanger.MUIStyle := LStyle;
  btnInfo.MUIStyle := LStyle;
  btnToggle.MUIStyle := LStyle;

  // 更新按钮组样式
  case AIndex of
    1: bgActions.Variant := bgvOutlined;
    2: bgActions.Variant := bgvText;
  else
    bgActions.Variant := bgvContained;
  end;
end;

procedure TFormAllInOne.UpdateComponentStates;
var
  LEnabled: Boolean;
begin
  LEnabled := cbEnabled.Checked;

  // 启用/禁用所有展示组件
  btnPrimary.Enabled := LEnabled;
  btnSecondary.Enabled := LEnabled;
  btnSuccess.Enabled := LEnabled;
  btnWarning.Enabled := LEnabled;
  btnDanger.Enabled := LEnabled;
  btnInfo.Enabled := LEnabled;
  btnToggle.Enabled := LEnabled;

  bgActions.Enabled := LEnabled;

  rgColorScheme.Enabled := LEnabled;
  rgStyle.Enabled := LEnabled;
  cgFeatures.Enabled := LEnabled;

  swDarkMode.Enabled := LEnabled;
  swNotifications.Enabled := LEnabled;
  swAutoSave.Enabled := LEnabled;
end;

procedure TFormAllInOne.LogResult(const AMsg: string);
begin
  lblResult.Caption := AMsg;
end;

end.