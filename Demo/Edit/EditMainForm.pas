unit EditMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Styles, Demo.Frame.Edit, Demo.MainForm.Template;

type
  TFormEditDemo = class(TDemoMainForm)
  protected
    function CreateFrame: TFrame; override;
    function GetFormTitle: string; override;
  end;

var
  FormEditDemo: TFormEditDemo;

implementation

{$R *.dfm}

function TFormEditDemo.CreateFrame: TFrame;
begin
  Result := TFrameEditDemo.Create(Self);
end;

function TFormEditDemo.GetFormTitle: string;
begin
  Result := 'Edit Component Demo - SkiaVclControls';
end;

end.
