unit LabelMainForm;

interface

uses
  System.Classes,
  Vcl.Forms, Vcl.Controls,
  Demo.Frame.LabelControl;

type
  TFormLabelDemo = class(TForm)
    FrameLabel: TFrameLabelDemo;
  end;

var
  FormLabelDemo: TFormLabelDemo;

implementation

{$R *.dfm}

end.
