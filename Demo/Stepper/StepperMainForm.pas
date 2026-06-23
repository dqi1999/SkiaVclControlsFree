unit StepperMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Styles, Demo.Frame.Stepper, Demo.MainForm.Template;

type
  TFormStepperDemo = class(TDemoMainForm)
  protected
    function CreateFrame: TFrame; override;
    function GetFormTitle: string; override;
  end;

var
  FormStepperDemo: TFormStepperDemo;

implementation

{$R *.dfm}

function TFormStepperDemo.CreateFrame: TFrame;
begin
  Result := TFrameStepperDemo.Create(Self);
end;

function TFormStepperDemo.GetFormTitle: string;
begin
  Result := 'Stepper Component Demo - SkiaVclControls';
end;

end.
