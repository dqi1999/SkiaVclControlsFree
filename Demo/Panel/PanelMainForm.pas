unit PanelMainForm;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls,
  Demo.Frame.Panel;

type
  TFormPanelDemo = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FFrame: TFramePanelDemo;
  end;

var
  FormPanelDemo: TFormPanelDemo;

implementation

{$R *.dfm}

procedure TFormPanelDemo.FormCreate(Sender: TObject);
begin
  FFrame := TFramePanelDemo.Create(Self);
  FFrame.Parent := Self;
  FFrame.Align := alClient;
end;

end.
