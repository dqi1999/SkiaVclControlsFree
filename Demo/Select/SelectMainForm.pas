unit SelectMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Styles, Demo.Frame.Select, Demo.MainForm.Template;

type
  TFormSelectDemo = class(TDemoMainForm)
  protected
    function CreateFrame: TFrame; override;
    function GetFormTitle: string; override;
  end;

var
  FormSelectDemo: TFormSelectDemo;

implementation

{$R *.dfm}

function TFormSelectDemo.CreateFrame: TFrame;
begin
  Result := TFrameSelectDemo.Create(Self);
end;

function TFormSelectDemo.GetFormTitle: string;
begin
  Result := 'Select Component Demo - SkiaVclControls';
end;

end.
