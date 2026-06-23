unit SnackbarMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Styles, Demo.Frame.Snackbar, Demo.MainForm.Template;

type
  TFormSnackbarDemo = class(TDemoMainForm)
  protected
    function CreateFrame: TFrame; override;
    function GetFormTitle: string; override;
  end;

var
  FormSnackbarDemo: TFormSnackbarDemo;

implementation

{$R *.dfm}

function TFormSnackbarDemo.CreateFrame: TFrame;
begin
  Result := TFrameSnackbarDemo.Create(Self);
end;

function TFormSnackbarDemo.GetFormTitle: string;
begin
  Result := 'Snackbar Component Demo - SkiaVclControls';
end;

end.
