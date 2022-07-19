unit GsLogger;

interface

uses
  GsSyslog,
  GsSysUtils,
  System.Classes,
  System.Contnrs;
  (*
  BPEventLog,
  BPFileUtils,
  BPTaskScheduler,
  Data.Win.ADODB,
  GsSlackApi,
  GsSLogger,
  GsWindows,
  IdIntercept,
  IdMessage,
  IdReplySMTP,
  IdSMTP,
  IdSMTPBase,
  IdSMTPRelay,
  Soap.Rio,
  SynCommons,
  System.Diagnostics,
  System.SysUtils,
  Vcl.Controls,
  Vcl.SvcMgr,
  Winapi.Messages,
  *)

type
  EGsLoggerError = class(EGilbertsoft);

  TGsLogMessage = class;
  TAbstractGsLogger = class;
  TCustomGsLoggerDestination = class;
  TGsLoggerDestinationClass = class of TCustomGsLoggerDestination;
  TGsLoggerMessageDispatcher = class;
  TGsLogger = class;

  IGsLogMessage = interface(IInterface)
    ['{67D0FCAD-E6AA-4227-9308-5308D49539A5}']
    (*
    FSource, FVersion, {FApplicationContext,} FUser, FComputer, FMessage: string;
    FEventType:             TGsSyslogMessageSeverity;
    FCategory, FID, FMsgNo: Integer;
    FDateTimeStamp:         TDateTime;
    *)
    function GetDateTimeStamp: TDateTime;
    function GetFacility: TGsSyslogMessageFacility;
    function GetSeverity: TGsSyslogMessageSeverity;
    function GetMessage: string;
    property DateTimeStamp: TDateTime read GetDateTimeStamp;
    property Facility: TGsSyslogMessageFacility read GetFacility;
    property Severity: TGsSyslogMessageSeverity read GetSeverity;
    property Message: string read GetMessage;
  end;

  IGsSendMessage = interface(IInterface)
    ['{36A368FA-DF9D-472C-B07D-B24E22E9C962}']
    procedure Log(AMessage: TGsLogMessage; Contexts: TObjectList);
  end;

  IGsLoggerDestination = interface(IInterface)
    ['{638499DF-DC7C-48BD-81AC-5CB9088BEBDA}']
    (*
    function GetDefaultSource: string;
    procedure SetDefaultSource(const Value: string);
    *)

    procedure Initialize;
    procedure Finalize;

    procedure ProcessMessagesBefore;
    procedure ProcessMessagesAfter;

    procedure ProcessMessage(ALogMessage: TGsLogMessage; Contexts: TObjectList; var Handled: Boolean);

    (*
    procedure BeforeDispatching;
    procedure AfterDispatching;
    function DispatchMessage(AMessage: TGsLogMessage; Contexts: TObjectList): Boolean;
    procedure ThreadInitialize;
    procedure ThreadFinalize;

    (*
    procedure LogMessage(Source, Message: string; EventType: TGsSyslogMessageSeverity = msEmergency;
      Category: Integer = 0; ID: Integer = 0; DateTimeStamp: TDateTime = 0); overload;
    procedure LogMessage(Message: string; EventType: TGsSyslogMessageSeverity = msEmergency;
      Category: Integer = 0; ID: Integer = 0; DateTimeStamp: TDateTime = 0); overload;

    property DefaultSource: string read GetDefaultSource write SetDefaultSource;
    *)
  end;

  IGsLoggerRealtimeDestination = interface(IInterface)
    ['{17B850D1-25D5-43E4-B3F9-5B04774120D0}']
  end;

  IGsLoggerContext = interface(IInterface)
    ['{330A0F8A-5814-44B9-BFC0-622CE3B2A32A}']
    (*
    function GetMaxMessageSeverity: TGsSyslogMessageSeverity;
    function GetValue(const Key: string): Variant;
    property MaxMessageSeverity: TGsSyslogMessageSeverity read GetMaxMessageSeverity;
    *)
  end;

  IGsLogger = interface(IGsLoggerContext)
    ['{C320B08F-0340-463C-B3EC-EAC0A968F588}']
    function GetLoggerDestination(AClass: TGsLoggerDestinationClass): TCustomGsLoggerDestination;
  end;

  IGsLoggerApplicationInformation = interface(IGsLoggerContext)
    ['{B89314C7-2635-4521-913F-F273B2660D81}']
  end;

  IGsLoggerApplicationContext = interface(IGsLoggerContext)
    ['{84F0CE6C-B428-4FFA-A4C1-6A229705434E}']
    function GetCaption: string;
    function GetIsDevelopment: Boolean;
    function GetIsProduction: Boolean;
    function GetIsTesting: Boolean;

    property Caption: string read GetCaption;
    property IsProduction: Boolean read GetIsProduction;
    property IsTesting: Boolean read GetIsTesting;
    property IsDevelopment: Boolean read GetIsDevelopment;
  end;

  IGsLoggerConfiguration = interface(IGsLoggerContext)
    ['{C320B08F-0340-463C-B3EC-EAC0A968F588}']
    function GetMaxMessageSeverity: TGsSyslogMessageSeverity;
    property MaxMessageSeverity: TGsSyslogMessageSeverity read GetMaxMessageSeverity;
  end;

  IGsLoggerMessageDispatchHelper = interface(IGsLoggerContext)
    ['{054F6255-6356-4AF1-B07E-6BD8B90A5867}']
    //function GetIsRealtime: Boolean;
    //function Supports(AClass: TGsLoggerClass): Boolean; overload;
    //function Supports(AObject: TAbstractGsLogger): Boolean; overload;
    function CanDispatch(ADestination: TGsLoggerDestinationClass): Boolean;
    function DispatchMessage(AMessage: TGsLogMessage; Contexts: TObjectList): Boolean;
    //property IsRealtime: Boolean read GetIsRealtime;
  end;

  TGsLogMessage = class(TInterfacedPersistent, IGsLogMessage)
  private
    FSource, FVersion, {FApplicationContext,} FUser, FComputer, FMessage: string;
    FEventType:             TGsSyslogMessageSeverity;
    FCategory, FID, FMsgNo: Integer;
    FDateTimeStamp:         TDateTime;
  protected
    //procedure AssignTo(Dest: TPersistent); override;
    { IGsLogMessage }
    function GetDateTimeStamp: TDateTime; virtual;
    function GetFacility: TGsSyslogMessageFacility; virtual;
    function GetSeverity: TGsSyslogMessageSeverity; virtual;
    function GetMessage: string; virtual;
  public
    constructor Create(const ASource, AVersion, {AApplicationContext,} AUser, AComputer, AMessage: string;
      AEventType: TGsSyslogMessageSeverity; ACategory, AID, AMsgNo: Integer; ADateTimeStamp: TDateTime);

    property DateTimeStamp: TDateTime read GetDateTimeStamp;
    property Facility: TGsSyslogMessageFacility read GetFacility;
    property Severity: TGsSyslogMessageSeverity read GetSeverity;
    property Message: string read GetMessage;
  end;

  TAbstractGsLogger = class(TComponent)
  end;

  TCustomGsLoggerDestination = class(TAbstractGsLogger, IGsLoggerDestination)
  private
  protected
    { IGsLoggerDestination }
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure ProcessMessagesBefore; virtual;
    procedure ProcessMessagesAfter; virtual;
    procedure ProcessMessage(ALogMessage: TGsLogMessage; Contexts: TObjectList; var Handled: Boolean); virtual; abstract;
  protected
    function FindContext(const Contexts: TObjectList; const IID: TGUID; out Intf): TObject; virtual;
    function GetContext(const Contexts: TObjectList; const IID: TGUID; out Intf): TObject; virtual;
    function GetApplicationContext(const Contexts: TObjectList; out Intf): TObject; virtual;
  end;

  (*
  TGsLogDispatcher = class(TComponent, IGsLogger)
  private
    class var FLogger: TGsLogDispatcher;
    //class constructor Create;
    class destructor Destroy;
    class function GetInstance: TGsLogDispatcher;
    class function GetInterface: IGsLogger;
    class procedure ReleaseInterface;
  private
    FDefaultSource: string;
    FEventLogger:   TEventLogger;
    FEventLoggers:  TStrings;
    FLoggerThread:  TAbstractGsLoggerThread;
    function GetDefaultSource: string;
    procedure SetDefaultSource(const Value: string);
  protected
    function EventLogger(const Source: string = ''): TEventLogger;
    procedure InternalLogMessage(Source, Message: string; EventType: TGsSyslogMessageSeverity;
      Category: Integer; ID: Integer; DateTimeStamp: TDateTime); inline;
    procedure PostSlack(AWebhookURL: WebhookURL; ALogMessage: TGsLogMessage);
    procedure ProcessMessagesBefore; virtual; abstract;
    procedure ProcessMessage(ALogMessage: TGsLogMessage; var Handled: Boolean); virtual; abstract;
    procedure ProcessMessagesAfter; virtual; abstract;
    procedure ThreadInitialize; virtual;
    procedure ThreadFinalize; virtual;

    function DispatchMessage(AMessage: TGsLogMessage; Contexts: TObjectList): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LogMessage(Source, Message: string; EventType: TGsSyslogMessageSeverity = msEmergency;
      Category: Integer = 0; ID: Integer = 0; DateTimeStamp: TDateTime = 0); overload; inline;
    procedure LogMessage(Message: string; EventType: TGsSyslogMessageSeverity = msEmergency;
      Category: Integer = 0; ID: Integer = 0; DateTimeStamp: TDateTime = 0); overload; inline;

    property DefaultSource: string read GetDefaultSource write SetDefaultSource;
  end;
  *)

  TAbstractGsLoggerMessageDispatcherThread = class(TThread)
  private
    FOwner: TGsLoggerMessageDispatcher;
  protected
    //function DispatchMessage(AMessage: TGsLogMessage; Contexts: TObjectList): Boolean; virtual; abstract;
    function GetOwner: TPersistent; dynamic;

    function GetLoggerDestination(AClass: TGsLoggerDestinationClass): TCustomGsLoggerDestination; dynamic;
  public
    constructor Create(AOwner: TGsLoggerMessageDispatcher); virtual;
    procedure Log(AMessage: TGsLogMessage; Contexts: TObjectList); virtual; abstract;
  end;

  TGsLoggerMessageDispatcher = class(TInterfacedPersistent, IGsLogger, IGsSendMessage)
  private
    FOwner: TGsLogger;
    FLoggerThread:  TAbstractGsLoggerMessageDispatcherThread;
  protected
    { TPersistent }
    function GetOwner: TPersistent; override;

    { IGsLogger }
    function GetLoggerDestination(AClass: TGsLoggerDestinationClass): TCustomGsLoggerDestination; dynamic;
  public
    constructor Create(AOwner: TGsLogger); virtual;

    { IGsSendMessage }
    procedure Log(AMessage: TGsLogMessage; Contexts: TObjectList);
  end;

  TGsLogger = class(TAbstractGsLogger, IGsLogger, IGsSendMessage)
  private
    FDispatcher:  TGsLoggerMessageDispatcher;
    FContexts: TObjectList;
    FDestinations: TObjectList;
    //FLogDispatcher: TGsLogDispatcher;
  protected
    procedure CreateLoggerDestinations;

    { IGsLogger }
    function GetLoggerDestination(AClass: TGsLoggerDestinationClass): TCustomGsLoggerDestination; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { IGsSendMessage }
    procedure Log(AMessage: TGsLogMessage; Contexts: TObjectList);

    procedure LogMessage(Source, Message: string; EventType: TGsSyslogMessageSeverity = msEmergency;
      Category: Integer = 0; ID: Integer = 0; DateTimeStamp: TDateTime = 0); overload; inline;
    procedure LogMessage(Message: string; EventType: TGsSyslogMessageSeverity = msEmergency;
      Category: Integer = 0; ID: Integer = 0; DateTimeStamp: TDateTime = 0); overload; inline;

    procedure RegisterContext(AContext: TObject);
    procedure UnregisterContext(AContext: TObject);
  end;

procedure RegisterLoggerDestination(AClass: TGsLoggerDestinationClass);

implementation

uses
  BPTimers,
  GsComObj,
  System.SyncObjs,
  System.SysUtils,
  Winapi.Windows;
  (*
  BPSvcMgr,
  SynCrtSock;
  *)

const
  LOGGER_THREAD_DELAY       = 2 * MSecsPerSec;

resourcestring
  SGsLoggerStarting     = 'Logger wird gestartet';
  SGsLoggerStarted      = 'Logger wurde gestartet';
  SGsLoggerShuttingDown = 'Logger wird beendet';
  SGsLoggerShutDown     = 'Logger wurde beendet';

  SErrorContextMissing  = 'Interface %s wurde im Context nicht gefunden!';

type
  TGsCachedLogMessage = class(TObject)
  private
    FMessage: TGsLogMessage;
    FContexts: TObjectList;
  public
    constructor Create(AMessage: TGsLogMessage; Contexts: TObjectList); virtual;
    destructor Destroy; override;

    property Message: TGsLogMessage read FMessage;
    property Contexts: TObjectList read FContexts;
  end;

  TObjectListLocked = class(TObjectList)
  protected
    FSafe: TCriticalSection;
  public
    /// initialize the list instance
    // - the stored TObject instances will be owned by this TObjectListLocked,
    // unless AOwnsObjects is set to false
    constructor Create(AOwnsObjects: Boolean = True); reintroduce;
    /// release the list instance (including the locking resource)
    destructor Destroy; override;
    /// Add an TObject instance using the global critical section
    function SafeAdd(AObject: TObject): Integer;
    /// find and delete a TObject instance using the global critical section
    function SafeRemove(AObject: TObject): Integer;
    /// find a TObject instance using the global critical section
    function SafeExists(AObject: TObject): Boolean;
    /// returns the number of instances stored using the global critical section
    function SafeCount: Integer;
    /// delete all items of the list using global critical section
    procedure SafeClear;
    /// the critical section associated to this list instance
    // - could be used to protect shared resources within the internal process
    // - use Safe.Lock/TryLock with a try ... finally Safe.Unlock block
    property Safe: TCriticalSection read FSafe;
  end;

  TGsLoggerMessageDispatcherThread = class(TAbstractGsLoggerMessageDispatcherThread)
  private
    //FLogger:            TGsLogger;
    FLoggers:           TObjectList;
    FDataAvailable:     TEvent;
    FDataTimer:         TBPWaitableTimer;
    FTerminate:         TEvent;
    FCachedLogMessages: TObjectListLocked;
    FMsgNo:             Integer;
  protected
    procedure TerminatedSet; override;
    procedure Execute; override;
  protected
    procedure DestinationsInitialize;
    procedure DestinationsFinalize;
    procedure DestinationsProcessMessagesBefore;
    procedure DestinationsProcessMessagesAfter;
    procedure DestinationsProcessMessage(ALogMessage: TGsLogMessage; Contexts: TObjectList; out Handled: Boolean; RealtimeDispatch: Boolean);

    procedure ProcessCachedLogMessages;

    procedure LogMessage(Message: string; EventType: TGsSyslogMessageSeverity = msEmergency;
      Category: Integer = 0; ID: Integer = 0; DateTimeStamp: TDateTime = 0); inline;
    //property LoggerSettings: TGsSLogger read GetLoggerSettings;
  public
    constructor Create(AOwner: TGsLoggerMessageDispatcher); override;
    destructor Destroy; override;

    procedure Log(AMessage: TGsLogMessage; Contexts: TObjectList); override;

    (*procedure LogMessage(Source, Message: string; EventType: TGsSyslogMessageSeverity;
      Category: Integer; ID: Integer; DateTimeStamp: TDateTime); override;*)
  end;

var
  FLoggerDestinations: TList;

function LoggerDestinations: TList;
begin
  if FLoggerDestinations = nil then
    FLoggerDestinations := TClassList.Create;
  Result := FLoggerDestinations;
end;

procedure RegisterLoggerDestination(AClass: TGsLoggerDestinationClass);
begin
  LoggerDestinations.Add(AClass);
end;

{ TGsCachedLogMessage }

constructor TGsCachedLogMessage.Create(AMessage: TGsLogMessage;
  Contexts: TObjectList);
begin
  inherited Create;

  FMessage := AMessage;
  FContexts := Contexts;
end;

destructor TGsCachedLogMessage.Destroy;
begin
  FContexts.Free;
  FMessage.Free;

  inherited;
end;

{ TObjectListLocked }

constructor TObjectListLocked.Create(AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);

  FSafe := TCriticalSection.Create;
end;

destructor TObjectListLocked.Destroy;
begin
  FSafe.Free;

  inherited Destroy;
end;

function TObjectListLocked.SafeAdd(AObject: TObject): Integer;
begin
  FSafe.Enter;
  try
    Result := Add(AObject);
  finally
    FSafe.Leave;
  end;
end;

procedure TObjectListLocked.SafeClear;
begin
  FSafe.Enter;
  try
    Clear;
  finally
    FSafe.Leave;
  end;
end;

function TObjectListLocked.SafeCount: Integer;
begin
  FSafe.Enter;
  try
    Result := Count;
  finally
    FSafe.Leave;
  end;
end;

function TObjectListLocked.SafeExists(AObject: TObject): Boolean;
begin
  FSafe.Enter;
  try
    Result := IndexOf(AObject) >= 0;
  finally
    FSafe.Leave;
  end;
end;

function TObjectListLocked.SafeRemove(AObject: TObject): Integer;
begin
  FSafe.Enter;
  try
    Result := Remove(AObject);
  finally
    FSafe.Leave;
  end;
end;

{ TAbstractGsLoggerMessageDispatcherThread }

constructor TAbstractGsLoggerMessageDispatcherThread.Create(
  AOwner: TGsLoggerMessageDispatcher);
begin
  FOwner := AOwner;

  inherited Create(False);
end;

function TAbstractGsLoggerMessageDispatcherThread.GetLoggerDestination(
  AClass: TGsLoggerDestinationClass): TCustomGsLoggerDestination;
var
  Intf: IGsLogger;
begin
  if Supports(FOwner, IGsLogger, Intf) then
    Result := Intf.GetLoggerDestination(AClass)
  else
    Result := nil;
end;

function TAbstractGsLoggerMessageDispatcherThread.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{ TGsLoggerMessageDispatcherThread }

constructor TGsLoggerMessageDispatcherThread.Create(AOwner: TGsLoggerMessageDispatcher);
begin
  Priority := tpLowest;

  inherited Create(AOwner);

  FLoggers           := TObjectList.Create(True);
  FDataAvailable     := TEvent.Create(nil, True, False, ClassName + 'DataAvailableEvent', False);
  FDataTimer         := TBPWaitableTimer.Create(LOGGER_THREAD_DELAY, ClassName, True, True);
  FTerminate         := TEvent.Create(nil, True, False, ClassName + 'TerminateEvent', False);
  FCachedLogMessages := TObjectListLocked.Create(True);
  FMsgNo             := 1;
end;

procedure TGsLoggerMessageDispatcherThread.DestinationsFinalize;
var
  I: Integer;
begin
  for I := 0 to LoggerDestinations.Count - 1 do
    try
      GetLoggerDestination(TGsLoggerDestinationClass(LoggerDestinations.Items[I])).Finalize;
    except
      on E: Exception do
        LogMessage(Format('Exception in %s.Finalize : %s', [TGsLoggerDestinationClass(LoggerDestinations.Items[I]).ClassName, E.Message]), msEmergency);
    end;
end;

procedure TGsLoggerMessageDispatcherThread.DestinationsInitialize;
var
  I: Integer;
begin
  for I := 0 to LoggerDestinations.Count - 1 do
    try
      GetLoggerDestination(TGsLoggerDestinationClass(LoggerDestinations.Items[I])).Initialize;
    except
      on E: Exception do
        LogMessage(Format('Exception in %s.Initialize : %s', [TGsLoggerDestinationClass(LoggerDestinations.Items[I]).ClassName, E.Message]), msEmergency);
    end;
end;

procedure TGsLoggerMessageDispatcherThread.DestinationsProcessMessage(
  ALogMessage: TGsLogMessage; Contexts: TObjectList; out Handled: Boolean;
  RealtimeDispatch: Boolean);
var
  I, J: Integer;
  RealtimeDestination: Boolean;
  DispHelper: IGsLoggerMessageDispatchHelper;
  Dispatched: Boolean;
begin
  Handled := False;

  for I := 0 to LoggerDestinations.Count - 1 do
  begin
    Dispatched := False;

    // Try to dispatch by a context
    for J := 0 to Contexts.Count - 1 do
    begin
      RealtimeDestination := Supports(Contexts.Items[J], IGsLoggerRealtimeDestination);
      if (RealtimeDispatch and not RealtimeDestination) or
        (not RealtimeDispatch and RealtimeDestination) then
        Continue;

      try
        if Supports(Contexts.Items[J], IGsLoggerMessageDispatchHelper, DispHelper) and
          DispHelper.CanDispatch(TGsLoggerDestinationClass(LoggerDestinations.Items[I])) then
        begin
          Dispatched := DispHelper.DispatchMessage(ALogMessage, Contexts);
        end;

        if Dispatched then
          Break;
      except
        on E: Exception do
          LogMessage(Format('Exception in %s.DispatchMessage : %s', [Contexts.Items[J].ClassName, E.Message]), msEmergency);
      end;
    end;

    // Finally if not already dispatched send to destination directly
    if not Dispatched then
    begin
      RealtimeDestination := Supports(GetLoggerDestination(TGsLoggerDestinationClass(LoggerDestinations.Items[I])), IGsLoggerRealtimeDestination);
      if (RealtimeDispatch and not RealtimeDestination) or
        (not RealtimeDispatch and RealtimeDestination) then
        Continue;

      try
        GetLoggerDestination(TGsLoggerDestinationClass(LoggerDestinations.Items[I])).ProcessMessage(ALogMessage, Contexts, Dispatched);
      except
        on E: Exception do
          LogMessage(Format('Exception in %s.ProcessMessage : %s', [TGsLoggerDestinationClass(LoggerDestinations.Items[I]).ClassName, E.Message]), msEmergency);
      end;
    end;

    Handled := Handled or Dispatched;
  end;
end;

procedure TGsLoggerMessageDispatcherThread.DestinationsProcessMessagesAfter;
var
  I: Integer;
begin
  for I := 0 to LoggerDestinations.Count - 1 do
    try
      GetLoggerDestination(TGsLoggerDestinationClass(LoggerDestinations.Items[I])).ProcessMessagesAfter;
    except
      on E: Exception do
        LogMessage(Format('Exception in %s.ProcessMessagesAfter : %s', [TGsLoggerDestinationClass(LoggerDestinations.Items[I]).ClassName, E.Message]), msEmergency);
    end;
end;

procedure TGsLoggerMessageDispatcherThread.DestinationsProcessMessagesBefore;
var
  I: Integer;
begin
  for I := 0 to LoggerDestinations.Count - 1 do
    try
      GetLoggerDestination(TGsLoggerDestinationClass(LoggerDestinations.Items[I])).ProcessMessagesBefore;
    except
      on E: Exception do
        LogMessage(Format('Exception in %s.ProcessMessagesBefore : %s', [TGsLoggerDestinationClass(LoggerDestinations.Items[I]).ClassName, E.Message]), msEmergency);
    end;
end;

destructor TGsLoggerMessageDispatcherThread.Destroy;
begin
  inherited;

  FCachedLogMessages.Free;
  FTerminate.Free;
  FDataAvailable.Free;
  FDataTimer.Free;
  FLoggers.Free;

  //FLogger := nil;
end;

procedure TGsLoggerMessageDispatcherThread.Execute;
var
  Handles: array of THandle;
begin
  NameThreadForDebugging(ClassName);

  try
    InitializeCOM;

    try
      CreateMessageQueue;

      // Get data event handle
      SetLength(Handles, 3);
      Handles[0] := FDataAvailable.Handle;
      Handles[1] := FDataTimer.Handle;
      Handles[2] := FTerminate.Handle;

      //
      DestinationsInitialize;

      try
        try
          while not Terminated or (FCachedLogMessages.SafeCount > 0) do
          begin
            case MsgWaitForMultipleObjects(Length(Handles), Handles[0], False, INFINITE, QS_ALLINPUT) of
              WAIT_OBJECT_0: ProcessCachedLogMessages;
              WAIT_OBJECT_0 + 1..WAIT_OBJECT_0 + 2: FDataAvailable.SetEvent;
              WAIT_OBJECT_0 + 3: ProcessMessages;
            else
              // Do nothing for other events
            end;
          end;
        finally
          FTerminate.ResetEvent;
        end;
      finally
        DestinationsFinalize;
      end;
    finally
      FinalizeCOM;
    end;
  except
    on E: Exception do
      LogMessage(Format('Exception in Execute: %s', [E.Message]), msEmergency);
  end;
end;

(*
function TGsLoggerMessageDispatcherThread.GetLoggerSettings: TGsSLogger;
begin
  if Settings.ApplicationContext.IsProduction then
    Result := Settings.Global.EnergyService.Logging.Production
  else
    Result := Settings.Global.EnergyService.Logging.Testing;
end;
*)

procedure TGsLoggerMessageDispatcherThread.Log(AMessage: TGsLogMessage; Contexts: TObjectList);
var
  Handled: Boolean;
  //LLoggerSettings: TGsSLogger;
begin
  try
    {$IFDEF MSWINDOWS}
    // Write to debug log
    OutputDebugString(PChar(AMessage.Message));

    (*
    // Save to Windows eventlog
    LLoggerSettings := LoggerSettings;

    if (EventType <= msNotice) or not LLoggerSettings.Loaded or (EventType <= LLoggerSettings.EventLog.Value) then
      FLogger.EventLogger(Source).LogMessage(Message, LogMessageTypeToEventLogType(EventType), Category, ID);
    *)
    {$ENDIF}

    // Handle realtime loggers
    DestinationsProcessMessagesBefore;

    try
      DestinationsProcessMessage(AMessage, Contexts, Handled, True);
    finally
      DestinationsProcessMessagesAfter;
    end;

    // Add to cache for later handling
    FCachedLogMessages.SafeAdd(TGsCachedLogMessage.Create(AMessage, Contexts));
    (*
    Source, BPFileUtils.GetFileVersion(
      Application.FileVersionInfo), {Settings.ApplicationContext.Caption,} GsWindows.GetUserName,
      GsWindows.GetComputerName, Message, EventType, Category, ID, FMsgNo, DateTimeStamp));
    *)
    Inc(FMsgNo);

    // Reactivate loop in case of waiting
    FDataTimer.Start;
  except
    on E: Exception do
      LogMessage(Format('Exception in LogMessage: %s', [E.Message]), msEmergency);
  end;
end;

procedure TGsLoggerMessageDispatcherThread.LogMessage(Message: string;
  EventType: TGsSyslogMessageSeverity; Category, ID: Integer;
  DateTimeStamp: TDateTime);
begin

end;

procedure TGsLoggerMessageDispatcherThread.ProcessCachedLogMessages;
var
  CachedMessage:      TGsCachedLogMessage;
  //LLoggerSettings: TGsSLogger;
  Handled:         Boolean;
  I:               Integer;
begin
  FDataAvailable.ResetEvent;

  if (FCachedLogMessages.SafeCount > 0) then
  begin
    try
      // Process cached messages
      DestinationsProcessMessagesBefore;

      try
        while (FCachedLogMessages.SafeCount > 0) do
        begin
          CachedMessage := TGsCachedLogMessage(FCachedLogMessages.First);

          (*
          LLoggerSettings := LoggerSettings;

          // Slack logging
          for I := 0 to LLoggerSettings.Slack.Count - 1 do
          begin
            if (LogMessage.FEventType <= msNotice) or not LLoggerSettings.Loaded or
              (LogMessage.FEventType <= LLoggerSettings.Slack.Items[I].LoggingLevel) then
            begin
              try
                FLogger.PostSlack(WebhookURL(LLoggerSettings.Slack.Items[I].URI), LogMessage);
              except
                on E: Exception do
                begin
                  FLogger.EventLogger.LogMessage(Format('Exception in FLogger.PostSlack: %s', [E.Message]),
                    EVENTLOG_ERROR_TYPE, CAT_SERVICE, MSG_SUCCESS);
                end;
              end;
            end;
          end;

          // Forward to custom method
          Handled := True;

          try
            FLogger.ProcessMessage(LogMessage, Handled);
          except
            on E: Exception do
            begin
              Handled := True;
              FLogger.EventLogger.LogMessage(Format('Exception in FLogger.ProcessMessage: %s', [E.Message]),
                EVENTLOG_ERROR_TYPE, CAT_SERVICE, MSG_SUCCESS);
            end;
          end;
          *)

          try
            DestinationsProcessMessage(CachedMessage.Message, CachedMessage.Contexts, Handled, False);
          except
            on E: Exception do
            begin
              Handled := True;
              LogMessage(Format('Exception in DestinationsProcessMessage: %s', [E.Message]), msEmergency);
            end;
          end;

          // Delete processed message
          if Handled or Terminated then
            FCachedLogMessages.SafeRemove(CachedMessage);
        end;
      finally
        DestinationsProcessMessagesAfter;
      end;

      if not FDataTimer.IsRunning and FDataTimer.IsSignaled then
        FDataTimer.Restart;
    except
      on E: Exception do
        LogMessage(Format('Exception in ProcessCachedLogMessages: %s', [E.Message]), msEmergency);
    end;
  end;
end;

procedure TGsLoggerMessageDispatcherThread.TerminatedSet;
begin
  inherited;

  FTerminate.SetEvent;
end;

{ TGsLogMessage }

constructor TGsLogMessage.Create(const ASource, AVersion, {AApplicationContext,} AUser, AComputer, AMessage: string;
  AEventType: TGsSyslogMessageSeverity; ACategory, AID, AMsgNo: Integer; ADateTimeStamp: TDateTime);
begin
  inherited Create;

  FSource             := ASource;
  FVersion            := AVersion;
  //FApplicationContext := AApplicationContext;
  FUser               := AUser;
  FComputer           := AComputer;
  FMessage            := AMessage;
  FEventType          := AEventType;
  FCategory           := ACategory;
  FID                 := AID;
  FMsgNo              := AMsgNo;
  FDateTimeStamp      := ADateTimeStamp;
end;

function TGsLogMessage.GetDateTimeStamp: TDateTime;
begin

end;

function TGsLogMessage.GetFacility: TGsSyslogMessageFacility;
begin

end;

function TGsLogMessage.GetMessage: string;
begin

end;

function TGsLogMessage.GetSeverity: TGsSyslogMessageSeverity;
begin

end;

{ TCustomGsLoggerDestination }

procedure TCustomGsLoggerDestination.Finalize;
begin
  // do nothing, override in descendents
end;

function TCustomGsLoggerDestination.FindContext(const Contexts: TObjectList;
  const IID: TGUID; out Intf): TObject;
var
  I: Integer;
begin
  // Search for the interface from bottom to top to priorize later added ones
  for I := Contexts.Count - 1 downto 0 do
  begin
    Result := Contexts.Items[I];

    if Supports(Result, IID, Intf) then
      Exit;
  end;

  Result := nil;
end;

function TCustomGsLoggerDestination.GetApplicationContext(
  const Contexts: TObjectList; out Intf): TObject;
begin
  Result := GetContext(Contexts, IGsLoggerApplicationContext, Intf);
end;

function TCustomGsLoggerDestination.GetContext(const Contexts: TObjectList;
  const IID: TGUID; out Intf): TObject;
begin
  Result := FindContext(Contexts, IID, Intf);

  if Result = nil then
    raise EGsLoggerError.CreateResFmt(@SErrorContextMissing, [GUIDToString(IID)]);
end;

procedure TCustomGsLoggerDestination.Initialize;
begin
  // do nothing, override in descendents
end;

procedure TCustomGsLoggerDestination.ProcessMessagesAfter;
begin
  // do nothing, override in descendents
end;

procedure TCustomGsLoggerDestination.ProcessMessagesBefore;
begin
  // do nothing, override in descendents
end;

{ TGsLoggerMessageDispatcher }

constructor TGsLoggerMessageDispatcher.Create(AOwner: TGsLogger);
begin
  FOwner := AOwner;

  inherited Create;
end;

function TGsLoggerMessageDispatcher.GetLoggerDestination(
  AClass: TGsLoggerDestinationClass): TCustomGsLoggerDestination;
var
  Intf: IGsLogger;
begin
  if Supports(FOwner, IGsLogger, Intf) then
    Result := Intf.GetLoggerDestination(AClass)
  else
    Result := nil;
end;

function TGsLoggerMessageDispatcher.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TGsLoggerMessageDispatcher.Log(AMessage: TGsLogMessage;
  Contexts: TObjectList);
begin

end;

{ TGsLogger }

constructor TGsLogger.Create(AOwner: TComponent);
begin
  (*
  if Assigned(FLogger) then
    RaiseSingletonExistsError(EGsLoggerError, Self);

  FLogger := Self;
  *)

  inherited;

  FContexts := TObjectList.Create(False);
  FDestinations := TObjectList.Create(True);
  FDispatcher := TGsLoggerMessageDispatcher.Create(Self);

  (*
  FDefaultSource := SVC_NAME;
  FEventLoggers  := TStringList.Create(True);

  EventLogger.LogMessage(SGsLoggerStarting, EVENTLOG_INFORMATION_TYPE, CAT_SERVICE, MSG_SUCCESS);

  FLoggerThread := TGsLoggerMessageDispatcherThread.Create(Self);
  *)

  LogMessage(SGsLoggerStarted, msNotice);
end;

procedure TGsLogger.CreateLoggerDestinations;
var
  I: Integer;
begin
  for I := 0 to LoggerDestinations.Count - 1 do
    FDestinations.Add(TGsLoggerDestinationClass(LoggerDestinations.Items[I]).Create(Owner));
end;

destructor TGsLogger.Destroy;
begin
  LogMessage(SGsLoggerShuttingDown, msNotice);

  FDispatcher.Free;

  inherited;

  //EventLogger.LogMessage(SGsLoggerShutDown, EVENTLOG_INFORMATION_TYPE, CAT_SERVICE, MSG_SUCCESS);

  FDestinations.Free;
  FContexts.Free;
end;

function TGsLogger.GetLoggerDestination(
  AClass: TGsLoggerDestinationClass): TCustomGsLoggerDestination;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to FDestinations.Count - 1 do
    if FDestinations.Items[I] is AClass then
    begin
      Result := TCustomGsLoggerDestination(FDestinations.Items[I]);
      Break;
    end;
end;

procedure TGsLogger.Log(AMessage: TGsLogMessage; Contexts: TObjectList);
var
  OwnedContexts: TObjectList;
begin
  OwnedContexts := TObjectList.Create(True);
  OwnedContexts.Assign(FContexts);
  OwnedContexts.Assign(Contexts);
  FDispatcher.Log(AMessage, OwnedContexts);
end;

procedure TGsLogger.LogMessage(Message: string;
  EventType: TGsSyslogMessageSeverity; Category, ID: Integer;
  DateTimeStamp: TDateTime);
begin

end;

procedure TGsLogger.LogMessage(Source, Message: string;
  EventType: TGsSyslogMessageSeverity; Category, ID: Integer;
  DateTimeStamp: TDateTime);
begin

end;

procedure TGsLogger.RegisterContext(AContext: TObject);
begin
  FContexts.Add(AContext);
end;

procedure TGsLogger.UnregisterContext(AContext: TObject);
begin
  FContexts.Remove(AContext);
end;

initialization
finalization
end.


{ TGsLogDispatcher }


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

