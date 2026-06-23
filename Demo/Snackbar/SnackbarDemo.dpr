program SnackbarDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Snackbar in '..\Frames\Demo.Frame.Snackbar.pas' {FrameSnackbarDemo: TFrame},
  Demo.MainForm.Template in '..\Shared\Demo.MainForm.Template.pas' {DemoMainForm},
  SnackbarMainForm in 'SnackbarMainForm.pas' {FormSnackbarDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormSnackbarDemo, FormSnackbarDemo);
  Application.Run;
end.
