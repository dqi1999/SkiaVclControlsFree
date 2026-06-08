program SwitchDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Switch in '..\Frames\Demo.Frame.Switch.pas' {FrameSwitchDemo: TFrame},
  Demo.MainForm.Template in '..\Shared\Demo.MainForm.Template.pas' {DemoMainForm},
  SwitchMainForm in 'SwitchMainForm.pas' {FormSwitchDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormSwitchDemo, FormSwitchDemo);
  Application.Run;
end.
