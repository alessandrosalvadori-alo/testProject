unit UTalker;

interface

uses
  System.Classes, System.SysUtils, System.DateUtils, System.Threading;

type
  TTalker = class(Tobject)

  private
    FText: string;
    FOnTaskCompleted: TNotifyEvent;
    procedure SetOnTaskCompleted(const Value: TNotifyEvent);

  public
    function Talk(textPrompt: string): string; virtual;
    procedure ThreadTalk(textPrompt: string); virtual;
    property OnTaskCompleted: TNotifyEvent read FOnTaskCompleted write SetOnTaskCompleted;
    property Text: string read FText;
  end;

implementation

procedure TTalker.SetOnTaskCompleted(const Value: TNotifyEvent);
begin
  FOnTaskCompleted := Value;
end;

{ Tsayhello1 }

function TTalker.Talk(textPrompt: string): String;
begin
  var LThen := Now;
  while SecondsBetween(Now, LThen) < 20 do
  begin
     Sleep(10);
  end;

 result := textPrompt + ' (minuscolo)';

end;

procedure TTalker.ThreadTalk(textPrompt: string);
begin
  TTask.Run(
    procedure
    begin
      FText := textPrompt + ' (minuscolo)';

      var LThen := Now;
      while SecondsBetween(Now, LThen) < 10 do
      begin
         Sleep(10);
      end;
      if Assigned(FOnTaskCompleted) then
        FOnTaskCompleted(Self);
    end);
end;

end.
