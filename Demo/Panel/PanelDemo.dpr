program PanelDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Panel in '..\Frames\Demo.Frame.Panel.pas' {FramePanelDemo: TFrame},
  PanelMainForm in 'PanelMainForm.pas' {FormPanelDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPanelDemo, FormPanelDemo);
  Application.Run;
end.
