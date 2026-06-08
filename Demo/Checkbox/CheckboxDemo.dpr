program CheckboxDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Base in '..\Frames\Demo.Frame.Base.pas' {DemoBaseFrame: TFrame},
  Demo.Frame.Checkbox in '..\Frames\Demo.Frame.Checkbox.pas' {FrameCheckboxDemo: TFrame},
  Demo.MainForm.Template in '..\Shared\Demo.MainForm.Template.pas' {DemoMainForm},
  CheckboxMainForm in 'CheckboxMainForm.pas' {FormCheckboxDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormCheckboxDemo, FormCheckboxDemo);
  Application.Run;
end.
