unit _Udatabase;

interface

uses System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, Sqlite, SqlConst, Data.SqlExpr, FireDAC.Comp.Client,
  FireDAC.Stan.Def, FireDAC.Stan.Async, FireDAC.DApt;

type
  TConnect = class
  private
    class var FDConnection1: TFDConnection;
    class function ConnectDb(const Value: string): string; static;
  public

  end;

implementation

{$R *.fmx}

class function TConnect.ConnectDb(const Value: string): string;

begin
  FDConnection1.DriverName := 'SQL';
  FDConnection1.Params.Add('localhost');
  FDConnection1.Params.Add('db');
  FDConnection1.Params.Add('User_Name=root');
  FDConnection1.Params.Add('Passwor');
  FDConnection1.Params.Add('Port');
  FDConnection1.Connected := True;

end;

end.
