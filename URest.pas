unit URest;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.JSON,
  REST.Client,
  REST.Types,
  REST.Authenticator.Basic;

type
  TForm2 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FRestClient: TRESTClient;
    FRestRequest: TRESTRequest;
    FRestResponse: TRESTResponse;

    FToken: string;

  public
    function AuthenticateUser(const AUsername, APassword: string): string;
    function MakeRestRequest: string;

  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

{ TForm2 }
function TForm2.AuthenticateUser(const AUsername, APassword: string): string;

begin
  Result := '';
  FRestRequest.Method := TRESTRequestMethod.rmPOST;
  FRestRequest.Resource := '/auth/login';
  FRestClient.ContentType := 'application/x-www-from-urlencoded';

  FRestRequest.Params.AddItem('username', AUsername,
    TRESTRequestParameterKind.pkREQUESTBODY);
  FRestRequest.Params.AddItem('password', APassword,
    TRESTRequestParameterKind.pkREQUESTBODY);

  FRestRequest.Execute();
  FRestRequest.Response.GetSimpleValue('access_token', Result);
  FToken := Result;
  showmessage(Result);

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FRestClient := TRESTClient.Create(Self);
  FRestClient.BAseURL := 'https://shell.alo.zone/api/v1';
  FRestResponse := TRESTResponse.Create(Self);

  FRestRequest := TRESTRequest.Create(Self);
  FRestRequest.Client := FRestClient;
  FRestRequest.Response := FRestResponse;
end;

function TForm2.MakeRestRequest: string;
begin

  if FToken <> '' then
  begin
    FRestRequest.Method := TRESTRequestMethod.rmGET;
    FRestRequest.Resource := '/hello';
    var param := FRestRequest.Params.AddItem('Authorization', 'Bearer ' + FToken, TRESTRequestParameterKind.pkHTTPHEADER);
    param.Options := [poDoNotEncode];

    FRestRequest.Execute();
    FRestRequest.Response.GetSimpleValue('message', Result);

  end;
end;

end.
