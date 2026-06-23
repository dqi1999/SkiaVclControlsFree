program StepperDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Base in '..\Frames\Demo.Frame.Base.pas' {DemoBaseFrame: TFrame},
  Demo.Frame.Stepper in '..\Frames\Demo.Frame.Stepper.pas' {FrameStepperDemo: TFrame},
  Demo.MainForm.Template in '..\Shared\Demo.MainForm.Template.pas' {DemoMainForm},
  StepperMainForm in 'StepperMainForm.pas' {FormStepperDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormStepperDemo, FormStepperDemo);
  Application.Run;
end.
