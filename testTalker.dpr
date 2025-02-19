program testTalker;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMain in 'UMain.pas' {Form1},
  UTalker in 'UTalker.pas',
  UShouter in 'UShouter.pas',
  Ucrypt in 'Ucrypt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
