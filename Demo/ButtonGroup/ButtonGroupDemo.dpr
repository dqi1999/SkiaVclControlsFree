program ButtonGroupDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Base in '..\Frames\Demo.Frame.Base.pas' {DemoBaseFrame: TFrame},
  Demo.Frame.ButtonGroup in '..\Frames\Demo.Frame.ButtonGroup.pas' {FrameButtonGroupDemo: TFrame},
  Demo.MainForm.Template in '..\Shared\Demo.MainForm.Template.pas' {DemoMainForm},
  ButtonGroupMainForm in 'ButtonGroupMainForm.pas' {FormButtonGroupDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormButtonGroupDemo, FormButtonGroupDemo);
  Application.Run;
end.
