unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  UTalker, FMX.Ani,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    RectangleWait: TRectangle;
    AniIndicator: TAniIndicator;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FTalker: TTalker;
    procedure GenerateMessage;
    procedure OnTextReady(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

const
  NO_OPACITY = 0;
  OPACITY = 0.7;

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

procedure TForm1.FormCreate(Sender: TObject);
begin
  FTalker := TTalker.Create;
  RectangleWait.Opacity := NO_OPACITY;
  RectangleWait.Visible := False;
  // RectangleWait.Align:=  TAlignLayout.Client;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FTalker.Free;

end;

procedure TForm1.GenerateMessage;
begin
  Showmessage(Format('Il testo inserito è: %s', [FTalker.Talk(Edit1.Text)]));

end;

procedure TForm1.OnTextReady(Sender: TObject);
begin
  if Sender is TTalker then
    TThread.Synchronize(nil,
      procedure
      begin
        TAnimator.AnimateFloatWait(RectangleWait, 'Opacity', NO_OPACITY);
        RectangleWait.Visible := False;
        Showmessage(TTalker(Sender).Text);
      end);

end;

end.
