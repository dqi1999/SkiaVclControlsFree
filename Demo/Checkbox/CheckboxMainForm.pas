unit CheckboxMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics,
  Demo.Styles, Demo.Frame.Checkbox;

type
  TFormCheckboxDemo = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FFrame: TFrameCheckboxDemo;
    procedure SetupForm;
  end;

var
  FormCheckboxDemo: TFormCheckboxDemo;

implementation

{$R *.dfm}

procedure TFormCheckboxDemo.FormCreate(Sender: TObject);
begin
  SetupForm;
end;

procedure TFormCheckboxDemo.SetupForm;
begin
  Caption := 'Checkbox Component Demo - SkiaVclControls';
  Width := 1100;
  Height := 700;
  Position := poScreenCenter;
  Color := clWhite;

  FFrame := TFrameCheckboxDemo.Create(Self);
  FFrame.Parent := Self;
  FFrame.Align := alClient;
end;

end.
