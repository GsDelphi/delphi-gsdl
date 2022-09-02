unit GsEventLogger;

interface

uses
  GsLogger,
  System.Classes,
  System.Contnrs;

type
  IGsEventLoggerConfiguration = interface(IGsLoggerContext)
    ['{99478F96-ADC9-4A3A-AEBF-817BEE3DF8E0}']
    (*
    function GetMaxMessageSeverity: TGsSyslogMessageSeverity;
    function GetValue(const Key: string): Variant;
    property MaxMessageSeverity: TGsSyslogMessageSeverity read GetMaxMessageSeverity;
    *)
  end;

  TGsEventLogger = class(TCustomGsLoggerDestination)
  private
    FEventLoggers:  TStrings;
  protected
    procedure ProcessMessage(ALogMessage: TGsLogMessage; Contexts: TObjectList; var Handled: Boolean); override;
  public
  end;

implementation

{ TGsEventLogger }

procedure TGsEventLogger.ProcessMessage(ALogMessage: TGsLogMessage;
  Contexts: TObjectList; var Handled: Boolean);
var
  Configuration: IGsEventLoggerConfiguration;
begin
  GetContext(Contexts, IGsEventLoggerConfiguration, Configuration);
end;

initialization
  RegisterLoggerDestination(TGsEventLogger);
finalization
end.


{ TGsLogDispatcher }

constructor TGsLogDispatcher.Create(AOwner: TComponent);
begin
  if Assigned(FLogger) then
    RaiseSingletonExistsError(EGsLoggerError, Self);

  FLogger := Self;

  inherited;

  FDefaultSource := SVC_NAME;
  FEventLoggers  := TStringList.Create(True);

  EventLogger.LogMessage(SGsLoggerStarting, EVENTLOG_INFORMATION_TYPE, CAT_SERVICE, MSG_SUCCESS);

  FLoggerThread := TGsLoggerThread.Create(Self);

  LogMessage(SGsLoggerStarted, msNotice, CAT_SERVICE, MSG_SUCCESS);
end;

destructor TGsLogDispatcher.Destroy;
begin
  LogMessage(SGsLoggerShuttingDown, msNotice, CAT_SERVICE, MSG_SUCCESS);

  FLoggerThread.Free;

  inherited;

  EventLogger.LogMessage(SGsLoggerShutDown, EVENTLOG_INFORMATION_TYPE, CAT_SERVICE, MSG_SUCCESS);

  FEventLoggers.Free;
  FEventLogger.Free;
  FLogger := nil;
end;

class destructor TGsLogDispatcher.Destroy;
begin
  ReleaseInterface;
end;

function TGsLogDispatcher.EventLogger(const Source: string): TEventLogger;
var
  S: string;
  I: Integer;
begin
  if (Source = '') then
    S := DefaultSource
  else
    S := Source;

  if Assigned(FEventLoggers) then
  begin
    I := FEventLoggers.IndexOf(S);

    if (I = -1) then
      I := FEventLoggers.AddObject(S, TEventLogger.Create(S));

    Result := TEventLogger(FEventLoggers.Objects[I]);
  end
  else
  begin
    if not Assigned(FEventLogger) then
      FEventLogger := TEventLogger.Create(DefaultSource);

    Result := FEventLogger;
  end;
end;

function TGsLogDispatcher.GetDefaultSource: string;
begin
  Result := FDefaultSource;
end;

class function TGsLogDispatcher.GetInstance: TGsLogDispatcher;
begin
  if not Assigned(FLogger) then
    Create(nil);

  Result := FLogger;
end;

class function TGsLogDispatcher.GetInterface: IGsLogger;
begin
  Result := GetInstance;
end;

procedure TGsLogDispatcher.InternalLogMessage(Source, Message: string; EventType: TGsSyslogMessageSeverity;
  Category, ID: Integer; DateTimeStamp: TDateTime);
begin
  // First of all set date time stamp
  if (DateTimeStamp = 0) then
    DateTimeStamp := Now;

  if Assigned(FLoggerThread) then
    FLoggerThread.LogMessage(Source, Message, EventType, Category, ID, DateTimeStamp)
  else
    EventLogger(Source).LogMessage(Message, LogMessageTypeToEventLogType(EventType), Category, ID);
end;

procedure TGsLogDispatcher.LogMessage(Source, Message: string; EventType: TGsSyslogMessageSeverity;
  Category, ID: Integer; DateTimeStamp: TDateTime);
begin
  InternalLogMessage(Source, Message, EventType, Category, ID, DateTimeStamp);
end;

procedure TGsLogDispatcher.LogMessage(Message: string; EventType: TGsSyslogMessageSeverity;
  Category, ID: Integer; DateTimeStamp: TDateTime);
begin
  InternalLogMessage(DefaultSource, Message, EventType, Category, ID, DateTimeStamp);
end;

procedure TGsLogDispatcher.PostSlack(AWebhookURL: WebhookURL; ALogMessage: TGsLogMessage);
var
  SlackMessage: TGsSlackMessage;
begin
  SlackMessage := TGsSlackMessage.Create;

  try
    SlackMessage.Assign(ALogMessage);
    TGsSlackApi.SendMessage(AWebhookURL, SlackMessage);
  finally
    SlackMessage.Free;
  end;
end;

class procedure TGsLogDispatcher.ReleaseInterface;
begin
  FLogger := nil;
end;

procedure TGsLogDispatcher.SetDefaultSource(const Value: string);
begin
  FDefaultSource := Value;
end;

procedure TGsLogDispatcher.ThreadFinalize;
begin
end;

procedure TGsLogDispatcher.ThreadInitialize;
begin
end;


