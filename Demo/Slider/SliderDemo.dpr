program SliderDemo;

uses
  Vcl.Forms,
  Demo.Styles in '..\Shared\Demo.Styles.pas',
  Demo.Frame.Slider in '..\Frames\Demo.Frame.Slider.pas' {FrameSliderDemo: TFrame},
  SliderMainForm in 'SliderMainForm.pas' {FormSliderDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormSliderDemo, FormSliderDemo);
  Application.Run;
end.
