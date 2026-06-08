unit ButtonMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Frame.Button, System.Skia, Vcl.Skia, SkiaVclControls.Base,
  SkiaVclControls.RadioGroup;

type
  TFormButtonDemo = class(TForm)
    FrameButton: TFrameButtonDemo;
  end;

var
  FormButtonDemo: TFormButtonDemo;

implementation

{$R *.dfm}

end.
