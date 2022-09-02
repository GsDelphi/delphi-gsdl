{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2019 Simon Gilli
    Gilbertsoft | https://delphi.gilbertsoft.org

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
}
{
  @abstract(Gilbertsoft Service Discovery)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2019-03-17)
  @cvs($Date:$)

  @name contains the service discovery classes.
}
unit GsServiceDiscovery;

{.$I gsdl.inc}

{$B-}

interface

uses
  Classes,
  Contnrs,
  mORMot,
  SyncObjs,
  SynCommons,
  SysUtils,
  Windows;

const
  SCOPE_LOCAL  = '.';
  SCOPE_GLOBAL = '*';

  MAX_MAILSLOT_MSG_LEN = 424;
  MAX_SERVICE_NAME     = 20;
  MAX_HOST_NAME        = MAX_PATH;

  DEFAULT_TTL = 10 * SecsPerMin;
  DEFAULT_SERIALIZATION_OPTIONS: TTextWriterWriteObjectOptions =
    [woDontStoreDefault, woStoreClassName, woDontStoreEmptyString, woDontStore0];

type
  // Exceptions
  EGsServiceDiscoveryError = class(Exception);

  // Mailslot info record
  TGsMailslotInfo = record
    Domain:    string;
    Namespace: string;
    Service:   string;
    Server:    THandle;
    Client:    THandle;
  end;

  // Mailslot raw messages and queuing
  TGsMailslotRawMessage      = type RawUTF8;
  PGsMailslotRawMessage      = ^TGsMailslotRawMessage;
  TGsMailslotRawMessageStamp = type Int64;

  PGsMailslotMessageRec = ^TGsMailslotMessageRec;

  TGsMailslotMessageRec = record
    Message:   PGsMailslotRawMessage;
    ReadStamp: TGsMailslotRawMessageStamp;
  end;

  TGsMailslotMessages = array of TGsMailslotMessageRec;

  // Service messages
  TGsServiceMessage = class;

  TGsServiceMessageQueue = class(TObject)
  private
    FList: TObjectListLocked;
    function GetCount: Integer;
    function GetItem(Index: Integer): TGsServiceMessage;
    procedure SetCount(const Value: Integer);
  protected
    function Add(AMessage: TGsServiceMessage): Integer; inline;
  public
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: TGsServiceMessage read GetItem; default;
  end;

  TGsServiceMessageStamp       = type TGsMailslotRawMessageStamp;
  TGsServiceMessageServiceName = type String;
  TGsServiceMessageTTL         = type Cardinal;

  TGsServiceMessageSender = record
    Computer, User: string;
  end;

  TGsServiceMessage = class(TSynPersistent)
  private
    FCreated:     TGsServiceMessageStamp;
    FServiceName: TGsServiceMessageServiceName;
    FSender:      TGsServiceMessageSender;
    FTTL:         TGsServiceMessageTTL;
  protected
    function InternalEquals(AMessage: TGsServiceMessage): Boolean; virtual; abstract;
    property ServiceName: TGsServiceMessageServiceName read FServiceName write FServiceName;
  public
    constructor Create; overload; override;
    class function CreateFromMessage(AMessage: TGsMailslotMessageRec): TGsServiceMessage; overload; virtual;

    function Equals(Obj: TObject): Boolean; override;
    function ToMailslotMessage: TGsMailslotRawMessage;

    property Created: TGsServiceMessageStamp read FCreated;
  published
    property Sender: TGsServiceMessageSender read FSender write FSender;
    property TTL: TGsServiceMessageTTL read FTTL write FTTL;
  end;

  TGsServiceAnnouncement = class(TGsServiceMessage)
  protected
    function InternalEquals(AMessage: TGsServiceMessage): Boolean; override;
  published
    property ServiceName;
  end;

  TGsServiceQuery = class(TGsServiceMessage)
  protected
    function InternalEquals(AMessage: TGsServiceMessage): Boolean; override;
  published
    property ServiceName;
  end;

  // Service discovery
  TGsServiceDiscovery = class;

  TScope1 = (sLocal, sRemote, sDomain, sPrimaryDomain);
  TScope  = type String;

  TServiceTransport = (spNamedPipes, spHTTP, spWebSockets);

  TServiceOptions = record
    case Transport: TServiceTransport of
      spNamedPipes: ();
      spHTTP,
      spWebSockets: (
        Host: array[0..MAX_HOST_NAME - 1] of AnsiChar;
        Port: Word);
  end;

  TGsServiceItem = class(TPersistent)
  private
    FName:    string;
    FOptions: TServiceOptions;
  protected
  public
    constructor Create(const AName: string; AOptions: TServiceOptions); virtual;
    property Name: string read FName;
    property Options: TServiceOptions read FOptions;
  end;

  TGsServiceList = class(TObject)
  private
    FList: TObjectList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TGsServiceItem;
    procedure SetCount(const Value: Integer);
  protected
    function Add(AService: TGsServiceItem): Integer; inline;
  public
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: TGsServiceItem read GetItem; default;
  end;

  TGsServiceDiscoveryServerThread = class(TThread)
  private
    FOwner: TGsServiceDiscovery;
    FQueue: TSynQueue;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TGsServiceDiscovery); virtual;
    destructor Destroy; override;

    procedure MoveQueuedMessages(ADestination: TGsServiceMessageQueue);
  end;

  TGsServiceDiscovery = class(TComponent)
  private
    FMailslots:        array of TGsMailslotInfo;
    FMailslotsChanged: TEvent;
    FQueue:            TGsServiceMessageQueue;
    FServerThread:     TGsServiceDiscoveryServerThread;
  protected
    procedure Listen(const Domain, Namespace, Service: string);
    procedure AnnounceService();
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // Mailslot helppers
    class function GetMailslotName(AMailslot: TGsMailslotInfo): string;
    //class function GetMailslotMessageCount(AMailslot: TGsMailslotInfo): Integer;
    //class function GetMailslotMessageSize(AMailslot: TGsMailslotInfo): Integer;
    //class function GetMailslotMessage(AMailslot: TGsMailslotInfo): TGsMailslotMessage;
    class procedure SendMailslotMessage(AMailslot: TGsMailslotInfo; AMessage: TGsMailslotRawMessage);

    procedure ProcessMessages;

    procedure RegisterService(const Domain, Namespace, Service: string; Options: TServiceOptions);
    procedure Discover(const Domain, Namespace, Service: string; List: TStrings);
  end;

implementation

uses
  Diagnostics,
  GsServiceDiscoveryConsts,
  GsWindows;

const
  MAILSLOT_SCOPE: array[TScope1] of string = ('.', '%s', '%s', '*');
  MAILSLOT_FORMAT = '\\%s\mailslot\%s';

{ TGsServiceMessageQueue }

function TGsServiceMessageQueue.Add(AMessage: TGsServiceMessage): Integer;
begin

end;

function TGsServiceMessageQueue.GetCount: Integer;
begin

end;

function TGsServiceMessageQueue.GetItem(Index: Integer): TGsServiceMessage;
begin

end;

procedure TGsServiceMessageQueue.SetCount(const Value: Integer);
begin

end;

{ TGsServiceMessage }

constructor TGsServiceMessage.Create;
begin
  inherited;

  FCreated         := TStopwatch.GetTimeStamp;
  FSender.Computer := GetComputerNameEx(ComputerNameDnsFullyQualified);
  FSender.User     := GetUserName;
  FTTL             := DEFAULT_TTL;
end;

class function TGsServiceMessage.CreateFromMessage(AMessage: TGsMailslotMessageRec): TGsServiceMessage;
var
  Valid: Boolean;
  Obj:   TObject;
begin
  Obj := JSONToNewObject(PUTF8Char(AMessage.Message), Valid);

  if not Valid then
    raise EGsServiceDiscoveryError.CreateResFmt(@SErrorInvalidMessage, [String(AMessage.Message)]);

  try
    Result          := Obj as TGsServiceMessage;
    Result.FCreated := AMessage.ReadStamp;
  except
    on E: Exception do
      raise EGsServiceDiscoveryError.CreateResFmt(@SErrorInvalidTypeCast, [Obj.ClassName,
        TGsServiceMessage.ClassName, E.Message]);
  end;
end;

function TGsServiceMessage.Equals(Obj: TObject): Boolean;
var
  AMessage: TGsServiceMessage absolute Obj;
begin
  Result := (ClassType = Obj.ClassType) and SameText(FServiceName, AMessage.FServiceName) and
    SameText(FSender.Computer, AMessage.FSender.Computer) and SameText(FSender.User, AMessage.FSender.User) and
    InternalEquals(AMessage);
end;

function TGsServiceMessage.ToMailslotMessage: TGsMailslotRawMessage;
begin
  Result := ObjectToJSON(Self, DEFAULT_SERIALIZATION_OPTIONS);
end;

{ TGsServiceAnnouncement }
function TGsServiceAnnouncement.InternalEquals(AMessage: TGsServiceMessage): Boolean;
begin
  Result := True;
end;

{ TGsServiceQuery }

function TGsServiceQuery.InternalEquals(AMessage: TGsServiceMessage): Boolean;
begin
  Result := True;
end;

{ TGsServiceItem }

constructor TGsServiceItem.Create(const AName: string; AOptions: TServiceOptions);
begin

end;

{ TGsServiceList }

function TGsServiceList.Add(AService: TGsServiceItem): Integer;
begin

end;

function TGsServiceList.GetCount: Integer;
begin

end;

function TGsServiceList.GetItem(Index: Integer): TGsServiceItem;
begin

end;

procedure TGsServiceList.SetCount(const Value: Integer);
begin

end;

{ TGsServiceDiscoveryServerThread }

constructor TGsServiceDiscoveryServerThread.Create(AOwner: TGsServiceDiscovery);
begin
  Priority := tpTimeCritical;

  inherited Create(True);

  FOwner := AOwner;
  FQueue := TSynQueue.Create(TypeInfo(TGsMailslotMessages));

  Start;
end;

destructor TGsServiceDiscoveryServerThread.Destroy;
begin
  FQueue.Free;
  FOwner := nil;

  inherited;
end;

procedure TGsServiceDiscoveryServerThread.Execute;
var
  MsgSize:     DWORD;
  Msg:         PUTF8Char;
  Handles:     TWOHandleArray;
  H:           Integer;
  I:           Integer;
  MaxMsgSize:  DWORD;
  Dummy:       DWORD;
  MsgCount:    DWORD;
  M:           Integer;
  BytesRead:   DWORD;
  MailslotMsg: PGsMailslotMessageRec;
begin
  MaxMsgSize := MAX_MAILSLOT_MSG_LEN;
  MsgSize    := MaxMsgSize;
  Msg        := GetMemory(MsgSize);

  try
    while not Terminated do
    begin
      // Cache mailslot changed event for later wait
      FOwner.FMailslotsChanged.ResetEvent;
      Handles[0] := FOwner.FMailslotsChanged.Handle;
      H          := 1;

      // Process each mailslot
      I := 0;
      while (I < Length(FOwner.FMailslots)) do
      begin
        MsgCount := 0;

        // Continue with next mailslot if not initialized or no message available
        if (FOwner.FMailslots[I].Server = INVALID_HANDLE_VALUE) or not
          GetMailslotInfo(FOwner.FMailslots[I].Server, Pointer(MaxMsgSize), Dummy, Pointer(MsgCount), nil) or
          (MsgCount < 1) then
          Continue;

        // Cache handles for later wait
        Handles[H] := FOwner.FMailslots[I].Server;
        Inc(H);

        // Increase message size
        if (MsgSize < MaxMsgSize) then
        begin
          MsgSize := MaxMsgSize;
          Msg     := ReallocMemory(Msg, MsgSize);
        end;

        // Get messages
        for M := 0 to MsgCount - 1 do
        begin
          if ReadFile(FOwner.FMailslots[I].Server, Msg, MaxMsgSize, BytesRead, nil) then
          begin
            New(MailslotMsg);
            MailslotMsg.ReadStamp := TStopwatch.GetTimeStamp;
            MailslotMsg.Message   := AllocMem(BytesRead + 1);
            MoveFast(Msg, MailslotMsg.Message, BytesRead);
            FQueue.Push(MailslotMsg);
          end;
        end;

        Inc(I);
      end;

      // Wait for new messages or mailslot
      WaitForMultipleObjects(H, @Handles, False, SecsPerMin * MSecsPerSec);
      //MsgWaitForMultipleObjects()
    end;
  finally
    FreeMemory(Msg);
  end;
end;

procedure TGsServiceDiscoveryServerThread.MoveQueuedMessages(ADestination: TGsServiceMessageQueue);
var
  MailslotMsg: PGsMailslotMessageRec;
begin
  while FQueue.Pending do
  begin
    FQueue.Pop(MailslotMsg);

    try
      ADestination.Add(TGsServiceMessage.CreateFromMessage(MailslotMsg^));
    except
      // Simply ignore unknown messages
    end;
  end;
end;

{ TGsServiceDiscovery }

procedure TGsServiceDiscovery.AnnounceService;
begin

end;

constructor TGsServiceDiscovery.Create(AOwner: TComponent);
begin
  inherited;

  FMailslotsChanged := TEvent.Create(nil, True, False, ClassName + 'MailslotsChangedEvent');
  FQueue            := TGsServiceMessageQueue.Create;
  FServerThread     := TGsServiceDiscoveryServerThread.Create(Self);
end;

destructor TGsServiceDiscovery.Destroy;
var
  I: Integer;
begin
  FServerThread.Free;
  FQueue.Free;
  FMailslotsChanged.Free;

  for I := Length(FMailslots) - 1 downto 0 do
  begin
    CloseHandle(FMailslots[I].Server);
    CloseHandle(FMailslots[I].Client);
  end;

  SetLength(FMailslots, 0);

  inherited;
end;

procedure TGsServiceDiscovery.Discover(const Domain, Namespace, Service: string; List: TStrings);
begin

end;

class function TGsServiceDiscovery.GetMailslotName(AMailslot: TGsMailslotInfo): string;
begin
  Result := Format('\\%s\mailslot\%s', [AMailslot.Domain, AMailslot.Namespace]);

  if (AMailslot.Service <> '') then
    Result := Result + '\' + AMailslot.Service;
end;

procedure TGsServiceDiscovery.Listen(const Domain, Namespace, Service: string);
var
  Mailslot: TGsMailslotInfo;
begin
  Mailslot.Domain    := Domain;
  Mailslot.Namespace := Namespace;
  Mailslot.Service   := Service;
  Mailslot.Server    := CreateMailslot(PChar(GetMailslotName(Mailslot)), 0, 0, nil);

  if (Mailslot.Server = INVALID_HANDLE_VALUE) then
    raise Exception.CreateResFmt(@SErrorCreateMailslot, [Namespace, SysErrorMessage(GetLastError)]);

  SetLength(FMailslots, Length(FMailslots) + 1);
  FMailslots[High(FMailslots)] := Mailslot;
  FMailslotsChanged.SetEvent;
end;

procedure TGsServiceDiscovery.ProcessMessages;
begin
  FServerThread.MoveQueuedMessages(FQueue);
end;

procedure TGsServiceDiscovery.RegisterService(const Domain, Namespace, Service: string; Options: TServiceOptions);
begin

end;

class procedure TGsServiceDiscovery.SendMailslotMessage(AMailslot: TGsMailslotInfo; AMessage: TGsMailslotRawMessage);
var
  BytesWritten: DWORD;
begin
  if (AMailslot.Client = INVALID_HANDLE_VALUE) then
    raise EGsServiceDiscoveryError.CreateResFmt(@SErrorInvalidMailslot, [GetMailslotName(AMailslot)]);

  if (Length(AMessage) > MAX_MAILSLOT_MSG_LEN) then
    raise EGsServiceDiscoveryError.CreateResFmt(@SErrorMailslotMessageLength,
      [Length(AMessage), MAX_MAILSLOT_MSG_LEN]);

  try
    Win32Check(WriteFile(AMailslot.Client, Pointer(AMessage), Length(AMessage), BytesWritten, nil));
  except
    on E: Exception do
      raise EGsServiceDiscoveryError.CreateResFmt(@SErrorWriteMailslot, [E.Message]);
  end;
end;

initialization
  TJSONSerializer.RegisterClassForJSON([TGsServiceAnnouncement, TGsServiceQuery]);
end.

