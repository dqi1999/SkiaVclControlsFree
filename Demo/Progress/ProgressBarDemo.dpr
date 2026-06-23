program ProgressBarDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Progress in '..\Frames\Demo.Frame.Progress.pas' {FrameProgressDemo: TFrame},
  Demo.MainForm.Template in '..\Shared\Demo.MainForm.Template.pas' {DemoMainForm},
  ProgressMainForm in 'ProgressMainForm.pas' {FormProgressDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormProgressDemo, FormProgressDemo);
  Application.Run;
end.
