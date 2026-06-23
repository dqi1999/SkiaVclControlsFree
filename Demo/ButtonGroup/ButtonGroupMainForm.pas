unit ButtonGroupMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Styles, Demo.Frame.ButtonGroup, Demo.MainForm.Template;

type
  TFormButtonGroupDemo = class(TDemoMainForm)
  protected
    function CreateFrame: TFrame; override;
    function GetFormTitle: string; override;
  end;

var
  FormButtonGroupDemo: TFormButtonGroupDemo;

implementation

{$R *.dfm}

function TFormButtonGroupDemo.CreateFrame: TFrame;
begin
  Result := TFrameButtonGroupDemo.Create(Self);
end;

function TFormButtonGroupDemo.GetFormTitle: string;
begin
  Result := 'ButtonGroup Component Demo - SkiaVclControls';
end;

end.
