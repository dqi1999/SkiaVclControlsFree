unit SwitchMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Styles, Demo.Frame.Switch, Demo.MainForm.Template;

type
  TFormSwitchDemo = class(TDemoMainForm)
  protected
    function CreateFrame: TFrame; override;
    function GetFormTitle: string; override;
  end;

var
  FormSwitchDemo: TFormSwitchDemo;

implementation

{$R *.dfm}

function TFormSwitchDemo.CreateFrame: TFrame;
begin
  Result := TFrameSwitchDemo.Create(Self);
end;

function TFormSwitchDemo.GetFormTitle: string;
begin
  Result := 'Switch Component Demo - SkiaVclControls';
end;

end.
