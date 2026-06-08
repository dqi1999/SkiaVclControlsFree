unit TabsMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Styles, Demo.Frame.Tabs, Demo.MainForm.Template;

type
  TFormTabsDemo = class(TDemoMainForm)
  protected
    function CreateFrame: TFrame; override;
    function GetFormTitle: string; override;
  end;

var
  FormTabsDemo: TFormTabsDemo;

implementation

{$R *.dfm}

function TFormTabsDemo.CreateFrame: TFrame;
begin
  Result := TFrameTabsDemo.Create(Self);
end;

function TFormTabsDemo.GetFormTitle: string;
begin
  Result := 'Tabs Component Demo - SkiaVclControls';
end;

end.
