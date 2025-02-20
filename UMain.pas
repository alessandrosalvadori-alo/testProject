unit UMain;

interface

// ogni volta che si modifica il campo testo si va a salvare il contenuto del campo so un file di
// JSON e deve essere riproposto in fase di apertura programma

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.JSON, // system for JSON
  System.IOUtils, System.NetEncoding,
  UTalker, FMX.Ani, URest, UDatabase,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, UCrypt,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCGridCell, FMX.TMSFNCGridOptions, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCCustomGrid, FMX.TMSFNCGridDatabaseAdapter, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCGridData, FMX.TMSFNCGrid,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    RectangleWait: TRectangle;
    AniIndicator: TAniIndicator;
    crypt: TButton;
    Button3: TButton;
    Edit2: TEdit;
    Button4: TButton;
    Button5: TButton;
    TMSFNCGrid1: TTMSFNCGrid;
    TMSFNCGridDatabaseAdapter1: TTMSFNCGridDatabaseAdapter;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);

    procedure Edit1Validate(Sender: TObject; var Text: string);
    procedure cryptClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    FTalker: TTalker;
    procedure GenerateMessage;
    procedure OnTextReady(Sender: TObject);
    procedure PopulateData;
  public
    { Public declarations }
  end;

var
  lJSON: TJSONObject;
  Form1: TForm1;
  Result: String;
  FileStream: TFileStream;

implementation

const
  NO_OPACITY = 0;
  OPACITY = 0.7;
  FILE_NAME = 'C:\Mac\Home\Documents\Embarcadero\Studio\Projects\text.json';

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  GenerateMessage;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  RectangleWait.BringToFront;
  RectangleWait.Visible := true;
  AniIndicator.Enabled := true;
  TAnimator.AnimateFloat(RectangleWait, 'Opacity', OPACITY);

  FTalker.ThreadTalk(Edit1.Text);
  FTalker.OnTaskCompleted := OnTextReady;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  showmessage(Tcrypt.Decrypt(Edit2.Text, $FA));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  form2.AuthenticateUser('testuser', 'testpassword');
  // showmessage(form2.MakeRestRequest);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  showmessage(form2.MakeRestRequest);
end;

procedure TForm1.cryptClick(Sender: TObject);
begin

  Edit2.Text := Tcrypt.Encrypt(Edit1.Text, $FA);

end;

procedure TForm1.Edit1Validate(Sender: TObject; var Text: string);
begin
  lJSON := TJSONObject.Create;
  lJSON.AddPair('edit', Edit1.Text);

  var
  LBase64 := TNetEncoding.Base64.Encode(lJSON.ToJSON);
  TFile.WriteAllBytes(FILE_NAME, TEncoding.UTF8.GetBytes(LBase64));
  lJSON.Free

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  JSonValue: TJSonValue;
  FileValue: string;
begin
  Form3 := TForm3.Create(Self);

  FTalker := TTalker.Create;
  RectangleWait.OPACITY := NO_OPACITY;
  RectangleWait.Visible := false;
  RectangleWait.BringToFront;

  if TFile.Exists(FILE_NAME) then
  begin
    var
    LBase64Text := TFile.ReadAllText(FILE_NAME);
    var
    LDecodedText := TNetEncoding.Base64.Decode(LBase64Text);
    JSonValue := TJSONObject.ParseJSONValue(LDecodedText);
    FileValue := JSonValue.GetValue<string>('edit');
    Edit1.Text := FileValue;
  end;
  // criptare testo inserito, algoritmo di decriptaggio, salva su file in base64


  PopulateData;
  // RectangleWait.Align:=  TAlignLayout.Client;

end;

procedure TForm1.PopulateData;
var
  LRowCount: integer;
  LColumnCount: integer;
begin
{
  with Form3.FDTable1 do
  begin
    LRowCount := RecordCount;
    LColumnCount := FieldCount;
    TMSFNCGrid1.Cells[0, 0] := Fields[0].FieldName;
    TMSFNCGrid1.Cells[0, 1] := Fields[1].FieldName;
    TMSFNCGrid1.Cells[0, 2] := Fields[2].FieldName;



  end;
}
TMSFNCGrid1.ColumnWidths[50];
TMSFNCGrid1.RowHeights[50];
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FTalker.Free;

end;

// '{' + '"testo Edit":'+ '"'+ Edit1.Text+ '"' +'}'
procedure TForm1.GenerateMessage;
begin
  showmessage(Format('Il testo inserito è: %s', [FTalker.Talk(Edit1.Text)]));

end;

procedure TForm1.OnTextReady(Sender: TObject);
begin
  if Sender is TTalker then
    TThread.Synchronize(nil,
      procedure
      begin
        TAnimator.AnimateFloatWait(RectangleWait, 'Opacity', NO_OPACITY);
        RectangleWait.Visible := false;
        showmessage(TTalker(Sender).Text);
      end);

end;

end.
