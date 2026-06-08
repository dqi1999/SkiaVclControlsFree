unit SkiaVclControls.Register;

interface

procedure Register;

implementation

{$R SkiaVclControls.DesignIcons.dcr}

uses
  System.Classes,
  SkiaVclControls.LabelControl,
  SkiaVclControls.Button,
  SkiaVclControls.ButtonGroup,
  SkiaVclControls.Panel,
  SkiaVclControls.Radio,
  SkiaVclControls.RadioGroup,
  SkiaVclControls.Checkbox,
  SkiaVclControls.CheckboxGroup,
  SkiaVclControls.Switch,
  SkiaVclControls.SwitchGroup,
  SkiaVclControls.Slider,
  SkiaVclControls.Tabs;

procedure Register;
begin
  RegisterComponents('SkiaVclControlsfree', [
    TDSkLabel,
    TDSkButton,
    TDSkButtonGroup,
    TDSkPanel,
    TDSkRadio,
    TDSkRadioGroup,
    TDSkCheckbox,
    TDSkCheckboxGroup,
    TDSkSwitch, 
    TDSkSwitchGroup,
    TDSkSlider,
    TDSkTabs
  ]);
end;

end.
