program LabelDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.LabelControl in '..\Frames\Demo.Frame.LabelControl.pas' {FrameLabelDemo: TFrame},
  LabelMainForm in 'LabelMainForm.pas' {FormLabelDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormLabelDemo, FormLabelDemo);
  Application.Run;
end.
