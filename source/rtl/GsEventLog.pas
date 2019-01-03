{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2017-2018 Simon Gilli
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
  @abstract(Gilbertsoft Devices)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains system constants and resourcestrings.
}
unit GSEventLog;

{$I gsdl.inc}

interface

uses
  BPClasses, BPContnrs;

const
	CService = 1;
	IDSimple = 100;

type
  TBPTSLogMessage = class;
  TBPTSLogMessageType = (lmtError, lmtWarning, lmtInformation);

  TBPTSLogMessages = class(TBPObject)
  private
    function GetLines(Index: Integer): TBPTSLogMessage;
    function GetCount: Integer;
  protected
    FLines: TObjectList;
  public
    constructor Create; override; 
    destructor Destroy; override;

    procedure LogMessage(AMessage: String; AMessageType: TBPTSLogMessageType);
    procedure Clear;

    property Lines[Index: Integer]: TBPTSLogMessage read GetLines; default;
  published
    property Count: Integer read GetCount;
  end;

  TBPTSLogMessage = class(TBPObject)
  private
    FMessage: String;
    FDateTime: TDateTime;
    FMessageType: TBPTSLogMessageType;
    FID: Cardinal;
    FCategory: Word;
  public
    constructor Create(const AMsg: String;
                       const AMsgType: TBPTSLogMessageType;
                       const ACategory: Word = CService;
                       const AID: Cardinal = IDSimple;
                       ADateTime: TDateTime = 0); reintroduce; virtual;
  published
    property DateTime: TDateTime read FDateTime;
    property MessageType: TBPTSLogMessageType read FMessageType;
    property Message: String read FMessage;
    property Category: Word read FCategory;
    property ID: Cardinal read FID;
  end;

function LogMessageTypeToEventLogType(AMessageType: TBPTSLogMessageType): DWORD;
function EventLogTypeToLogMessageType(AEventType: DWORD): TBPTSLogMessageType;
function GetLogMessageTypeCaption(AMessageType: TBPTSLogMessageType): String;

implementation

resourcestring
  SScheduledEvent = 'Task %d';
  SError = 'Error';
  SWarning = 'Warning';
  SInformation = 'Information';
  SExecuteCanceled = 'Ausführung des Ereignisses "%0:s" abgebrochen (%1:d / %2:d)';
  SExecuting = 'Das Ereignis "%0:s (%1:s)" wird gestartet';
  SExecuteDone = 'Das Ereignis "%0:s (%1:s)" wurde beendet (%2:d)';
  SCheckTime = 'Zeitüberprüfung für "%0:s"';
  STaskSchedulerStarting = 'Der Aufgabenplaner wird gestartet';
  STaskSchedulerStarted = 'Der Aufgabenplaner wurde gestartet';
  STaskSchedulerRunning = 'Der Aufgabenplaner wird ausgeführt';
  STaskSchedulerStopping = 'Der Aufgabenplaner wird beendet';
  STaskSchedulerStopped = 'Der Aufgabenplaner wurde beendet';

const
  BPSE_LOG_MESSAGE_TYPE_EVENT_TYPE: array [TBPTSLogMessageType] of Cardinal = (
      EVENTLOG_ERROR_TYPE,
      EVENTLOG_WARNING_TYPE,
      EVENTLOG_INFORMATION_TYPE{,
      EVENTLOG_AUDIT_SUCCESS,
      EVENTLOG_AUDIT_FAILURE}
    );

  BPSE_LOG_MESSAGE_TYPE_CAPTION: array [TBPTSLogMessageType] of PResStringRec = (
      @SError,
      @SWarning,
      @SInformation
    );

function LogMessageTypeToEventLogType(AMessageType: TBPTSLogMessageType): DWORD;
begin
  Result := BPSE_LOG_MESSAGE_TYPE_EVENT_TYPE[AMessageType];
end;

function EventLogTypeToLogMessageType(AEventType: DWORD): TBPTSLogMessageType;
var
  e: TBPTSLogMessageType;
begin
  Result := lmtError;

  for e := Low(e) to High(e) do
  begin
    if (AEventType = BPSE_LOG_MESSAGE_TYPE_EVENT_TYPE[e]) then
      Result := e;
  end;
end;

function GetLogMessageTypeCaption(AMessageType: TBPTSLogMessageType): String;
begin
  Result := LoadResString(BPSE_LOG_MESSAGE_TYPE_CAPTION[AMessageType]);
end;

{ TBPTSLogMessage }

constructor TBPTSLogMessage.Create(const AMsg: String;
  const AMsgType: TBPTSLogMessageType; const ACategory: Word;
  const AID: Cardinal; ADateTime: TDateTime);
begin
  if (ADateTime = 0) then
    FDateTime := Now
  else
    FDateTime := ADateTime;

  FMessage := AMsg;
  FMessageType := AMsgType;
  FCategory := ACategory;
  FID := AID;

  inherited Create;
end;

{ TBPTSLogMessages }

procedure TBPTSLogMessages.Clear;
begin
  FLines.Clear;
end;

constructor TBPTSLogMessages.Create;
begin
  inherited Create;

  FLines := TObjectList.Create(True);
end;

destructor TBPTSLogMessages.Destroy;
begin
  FLines.Free;

  inherited;
end;

function TBPTSLogMessages.GetCount: Integer;
begin
  Result := FLines.Count;
end;

function TBPTSLogMessages.GetLines(Index: Integer): TBPTSLogMessage;
begin
  Result := FLines[Index] as TBPTSLogMessage;
end;

procedure TBPTSLogMessages.LogMessage(AMessage: String;
  AMessageType: TBPTSLogMessageType);
begin
  FLines.Add(TBPTSLogMessage.Create(AMessage, AMessageType));
end;

initialization
  BPC_CodeSite.EnterInitialization('GSEventLog');

(*)
  { test for hints and warnings }
  TBPTSLogMessages.Create;
  TBPTSLogMessage.Create('', lmtError);
(**)

  BPC_CodeSite.ExitInitialization('GSEventLog');
finalization
  BPC_CodeSite.EnterFinalization('GSEventLog');
  BPC_CodeSite.ExitFinalization('GSEventLog');
end.
