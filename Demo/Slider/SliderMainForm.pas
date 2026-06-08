unit SliderMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Frame.Slider;

type
  TFormSliderDemo = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FFrame: TFrameSliderDemo;
  end;

var
  FormSliderDemo: TFormSliderDemo;

implementation

{$R *.dfm}

procedure TFormSliderDemo.FormCreate(Sender: TObject);
begin
  FFrame := TFrameSliderDemo.Create(Self);
  FFrame.Parent := Self;
  FFrame.Align := alClient;
end;

end.
