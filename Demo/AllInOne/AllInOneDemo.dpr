program AllInOneDemo;

uses
  Vcl.Forms,
  Vcl.Skia,
  System.Skia,
  AllInOneMainForm in 'AllInOneMainForm.pas' {FormAllInOne};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormAllInOne, FormAllInOne);
  Application.Run;
end.
