unit RadioMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Styles, Demo.Frame.Radio, Demo.MainForm.Template;

type
  TFormRadioDemo = class(TDemoMainForm)
  protected
    function CreateFrame: TFrame; override;
    function GetFormTitle: string; override;
  end;

var
  FormRadioDemo: TFormRadioDemo;

implementation

{$R *.dfm}

function TFormRadioDemo.CreateFrame: TFrame;
begin
  Result := TFrameRadioDemo.Create(Self);
end;

function TFormRadioDemo.GetFormTitle: string;
begin
  Result := 'Radio Component Demo - SkiaVclControls';
end;

end.
