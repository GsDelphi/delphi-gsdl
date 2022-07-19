unit GsSlackLogger;

interface

uses
  GsLogger,
  BPEventLog,
  BPFileUtils,
  BPTaskScheduler,
  BPTimers,
  Data.Win.ADODB,
  GsComObj,
  GsSlackApi,
  GsSLogger,
  GsSyslog,
  GsSysUtils,
  GsWindows,
  IdIntercept,
  IdMessage,
  IdReplySMTP,
  IdSMTP,
  IdSMTPBase,
  IdSMTPRelay,
  Soap.Rio,
  SynCommons,
  System.Classes,
  System.Contnrs,
  System.Diagnostics,
  System.SyncObjs,
  System.SysUtils,
  Vcl.SvcMgr,
  Winapi.Messages,
  Winapi.Windows;

type
  IGsSlackLoggerConfiguration = interface(IGsLoggerConfiguration)
    ['{B1CC8D9A-AE20-4852-873F-EDAEBA74260E}']
    function GetWebhookURL: WebhookURL;
    property WebhookURL: WebhookURL read GetWebhookURL;
  end;

  TGsSlackLoggerConfiguration = class(TInterfacedObject, IGsSlackLoggerConfiguration)
  private
    FWebhookURL: WebhookURL;
    function GetWebhookURL: WebhookURL;
    procedure SetWebhookURL(const Value: WebhookURL);
  public
    property WebhookURL: WebhookURL read GetWebhookURL write SetWebhookURL;
  end;

  TGsSlackLogger = class(TAbstractGsLogger)
  private
  protected
    procedure AssignMessage(Source: TGsLogMessage; Dest: TGsSlackMessage);
  protected
    function DispatchMessage(AMessage: TGsLogMessage; AContext: TObjectList): Boolean; override;
  end;

implementation

uses
  BPSvcMgr,
  GsSURI,
  SynCrtSock;

{ TGsSlackLoggerConfiguration }

function TGsSlackLoggerConfiguration.GetWebhookURL: WebhookURL;
begin
  Result := FWebhookURL;
end;

procedure TGsSlackLoggerConfiguration.SetWebhookURL(const Value: WebhookURL);
begin
  FWebhookURL := Value;
end;

{ TGsSlackLogger }

procedure TGsSlackLogger.AssignMessage(Source: TGsLogMessage;
  Dest: TGsSlackMessage);
var
  Header: SlackString;
begin
  with Dest do
  begin
    Header := SlackString(Format('*%s [%s] on %s*', [Source.FSource,
            Settings.ApplicationContext.Caption {ALogMessage.FApplicationContext}, FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',
            Source.FDateTimeStamp)]));

    if Source.FEventType in [msEmergency..msError] then
      Header := '@Channel ' + Header;

    Text := Header;

    with AddSectionBlock do
    begin
      Text.Text := Header;

      AddField.Text := '*Source*';
      AddField(ttPlainText).Text := SlackString(Source.FSource);

      AddField.Text := '*Version*';
      AddField(ttPlainText).Text := SlackString(Source.FVersion);

      AddField.Text := '*Context*';
      AddField(ttPlainText).Text := SlackString(Settings.ApplicationContext.Caption);

      AddField.Text := '*User*';
      AddField(ttPlainText).Text := SlackString(Source.FUser);

      AddField.Text := '*Computer*';
      AddField(ttPlainText).Text := SlackString(Source.FComputer);
    end;

    AddDividerBlock;

    with AddSectionBlock do
    begin
      Text.Text := '*Event details:*';

      AddField.Text := '*DateTimeStamp*';
      AddField(ttPlainText).Text := SlackString(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Source.FDateTimeStamp));

      AddField.Text := '*Type*';
      AddField(ttPlainText).Text := SlackString(GetLogMessageTypeCaption(Source.FEventType));

      AddField.Text := '*Category*';
      AddField(ttPlainText).Text := SlackString(IntToStr(Source.FCategory));

      AddField.Text := '*Event*';
      AddField(ttPlainText).Text := SlackString(IntToStr(Source.FID));
    end;

    with AddSectionBlock do
    begin
      Text.TextType := ttPlainText;
      Text.Text := SlackString(Source.FMessage);
    end;

    AddDividerBlock;

    with AddContextBlock do
    begin
      AddText.Text := SlackString(Format('Created by GsLogger on %s', [FormatDateTime('c', Now)]))
    end;

    (*

          case ALogMessage.FEventType of
            msEmergency..msError: Priority := mpHighest;
            msWarning: Priority            := mpHigh;
            msInfo: Priority               := mpLow;
            msDebug: Priority              := mpLowest;
          else
            Priority := mpNormal;
          end;

          ExtraHeaders.AddValue('Epm-Message-Severity-Code', IntToStr(Ord(ALogMessage.FEventType)));
          ExtraHeaders.AddValue('Epm-Message-Severity', GetLogMessageTypeCaption(ALogMessage.FEventType));
    *)
  end;
end;

function TGsSlackLogger.DispatchMessage(AMessage: TGsLogMessage;
  AContext: TObjectList): Boolean;
var
  SlackMessage: TGsSlackMessage;
begin
  SlackMessage := TGsSlackMessage.Create;

  try
    AssignMessage(AMessage, SlackMessage);
    TGsSlackApi.SendMessage(AWebhookURL, SlackMessage);
  finally
    SlackMessage.Free;
  end;
end;

initialization
  RegisterLogger(TGsSlackLogger);
finalization
end.

{ TGsLogMessage }

procedure TGsLogMessage.AssignTo(Dest: TPersistent);
begin
  if Dest is TGsSlackMessage then
    end
  else
    inherited;
end;

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

