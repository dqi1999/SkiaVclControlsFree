program EditDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Base in '..\Frames\Demo.Frame.Base.pas' {DemoBaseFrame: TFrame},
  Demo.Frame.Edit in '..\Frames\Demo.Frame.Edit.pas' {FrameEditDemo: TFrame},
  Demo.MainForm.Template in '..\Shared\Demo.MainForm.Template.pas' {DemoMainForm},
  EditMainForm in 'EditMainForm.pas' {FormEditDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormEditDemo, FormEditDemo);
  Application.Run;
end.
