program AdminDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Button in '..\Frames\Demo.Frame.Button.pas' {FrameButtonDemo: TFrame},
  Demo.Frame.Panel in '..\Frames\Demo.Frame.Panel.pas' {FramePanelDemo: TFrame},
  Demo.Frame.ButtonGroup in '..\Frames\Demo.Frame.ButtonGroup.pas' {FrameButtonGroupDemo: TFrame},
  Demo.Frame.Radio in '..\Frames\Demo.Frame.Radio.pas' {FrameRadioDemo: TFrame},
  Demo.Frame.Checkbox in '..\Frames\Demo.Frame.Checkbox.pas' {FrameCheckboxDemo: TFrame},
  Demo.Frame.Switch in '..\Frames\Demo.Frame.Switch.pas' {FrameSwitchDemo: TFrame},
  Demo.Frame.Slider in '..\Frames\Demo.Frame.Slider.pas' {FrameSliderDemo: TFrame},
  Demo.Frame.Tabs in '..\Frames\Demo.Frame.Tabs.pas' {FrameTabsDemo: TFrame},
  Demo.Frame.LabelControl in '..\Frames\Demo.Frame.LabelControl.pas' {FrameLabelDemo: TFrame},
  AdminMainForm in 'AdminMainForm.pas' {FormAdminDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormAdminDemo, FormAdminDemo);
  Application.Run;
end.
