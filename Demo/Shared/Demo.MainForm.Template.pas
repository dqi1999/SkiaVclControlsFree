unit Demo.MainForm.Template;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.Graphics,
  SkiaVclControls.Types, System.Skia, Vcl.Skia,
  Demo.Styles;

type
  TDemoMainForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FFrame: TFrame;
    procedure SetupForm;
  protected
    function CreateFrame: TFrame; virtual; abstract;
    function GetFormTitle: string; virtual;
  end;

implementation

{$R *.dfm}

function TDemoMainForm.GetFormTitle: string;
begin
  Result := 'Component Demo - SkiaVclControls';
end;

procedure TDemoMainForm.FormCreate(Sender: TObject);
begin
  SetupForm;
end;

procedure TDemoMainForm.SetupForm;
begin
  Caption := GetFormTitle;
  Width := 1100;
  Height := 700;
  Position := poScreenCenter;
  Color := clWhite;
  
  FFrame := CreateFrame;
  FFrame.Parent := Self;
  FFrame.Align := alClient;
end;

end.
