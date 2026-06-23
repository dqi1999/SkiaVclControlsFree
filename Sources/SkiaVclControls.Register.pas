unit SkiaVclControls.Register;

interface

procedure Register;

implementation

{$R SkiaVclControls.DesignIcons.dcr}

uses
  System.Classes, SkiaVclControls.Button, SkiaVclControls.Panel,
  SkiaVclControls.ButtonGroup, SkiaVclControls.Radio, SkiaVclControls.RadioGroup,
  SkiaVclControls.Slider, SkiaVclControls.Checkbox, SkiaVclControls.CheckboxGroup,
  SkiaVclControls.Switch, SkiaVclControls.SwitchGroup, SkiaVclControls.Select,
  SkiaVclControls.Edit, SkiaVclControls.ProgressBar,
  SkiaVclControls.CircularProgress, SkiaVclControls.Stepper,
  SkiaVclControls.Tabs, SkiaVclControls.Snackbar, SkiaVclControls.LabelControl;

procedure Register;
begin
  RegisterComponents('SkiaVclControls', [TDSkButton, TDSkPanel, TDSkButtonGroup,
    TDSkRadio, TDSkRadioGroup, TDSkSlider, TDSkCheckbox, TDSkCheckboxGroup,
    TDSkSwitch, TDSkSwitchGroup, TDSkSelect, TDSkEdit,
    TDSkProgressBar, TDSkCircularProgress, TDSkStepper, TDSkTabs, TDSkSnackbar,
    TDSkLabel]);
end;

end.
