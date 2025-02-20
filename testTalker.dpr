program testTalker;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMain in 'UMain.pas' {Form1} ,
  UTalker in 'UTalker.pas',
  UShouter in 'UShouter.pas',
  Ucrypt in 'Ucrypt.pas',
  URest in 'URest.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;

end.
