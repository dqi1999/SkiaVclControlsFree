unit ProgressMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Styles, Demo.Frame.Progress, Demo.MainForm.Template;

type
  TFormProgressDemo = class(TDemoMainForm)
  protected
    function CreateFrame: TFrame; override;
    function GetFormTitle: string; override;
  end;

var
  FormProgressDemo: TFormProgressDemo;

implementation

{$R *.dfm}

function TFormProgressDemo.CreateFrame: TFrame;
begin
  Result := TFrameProgressDemo.Create(Self);
end;

function TFormProgressDemo.GetFormTitle: string;
begin
  Result := 'Progress Component Demo - SkiaVclControls';
end;

end.
