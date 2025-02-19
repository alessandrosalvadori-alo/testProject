unit UCrypt;

interface

type
  Tcrypt = class
  public
    class function Encrypt(Value: string; Key: Byte): String;
    class function Decrypt(Value: string; Key: Byte): String;
  end;

implementation

uses
  SysUtils;

class function Tcrypt.Encrypt(Value: string; Key: Byte): String;
var
  byteTemp: int64;
begin
  Result := '';
  for var i := 1 to Length(Value) do
  begin
    byteTemp := Byte(Value[i]) + Key + i; // Shift di bit con criterio di posizionalità
    Result := Result + Char(byteTemp);
  end;
end;

class function Tcrypt.Decrypt(Value: string; Key: Byte): String;
var
  byteTemp: int64;
begin
  Result := '';
  for var i := 1 to Length(Value) do
  begin
    byteTemp := Byte(Value[i]) - Key - i; // Shift di bit inverso con criterio di posizionalità
    Result := Result + Char(byteTemp);
  end;
end;
end.
