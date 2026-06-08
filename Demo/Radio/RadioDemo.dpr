program RadioDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Base in '..\Frames\Demo.Frame.Base.pas' {DemoBaseFrame: TFrame},
  Demo.Frame.Radio in '..\Frames\Demo.Frame.Radio.pas' {FrameRadioDemo: TFrame},
  Demo.MainForm.Template in '..\Shared\Demo.MainForm.Template.pas' {DemoMainForm},
  RadioMainForm in 'RadioMainForm.pas' {FormRadioDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormRadioDemo, FormRadioDemo);
  Application.Run;
end.
