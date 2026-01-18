program CRONTest;

uses
  Vcl.Forms,
  uFrmTest in 'uFrmTest.pas' {Form1},
  CRON in 'CRON.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
