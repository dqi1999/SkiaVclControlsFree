program ButtonDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Button in '..\Frames\Demo.Frame.Button.pas' {FrameButtonDemo: TFrame},
  ButtonMainForm in 'ButtonMainForm.pas' {FormButtonDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormButtonDemo, FormButtonDemo);
  Application.Run;
end.
