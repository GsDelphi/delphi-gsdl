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
  @abstract(Gilbertsoft COM Port)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains system constants and resourcestrings.
}
unit GsComPort;

{$I gsdl.inc}
{$I windowsonly.inc}

interface

uses
  GsClasses, SysUtils, GSComDB, BPClasses, Windows, Classes, SyncObjs, BPConsts,
  GSStreams, Messages;

type
	{ exceptions }
	EGSComPortError = class(Exception);
  EInvalidHandleError = class(EGSComPortError);
  EImplementationMissingError = class(EGSComPortError);



	{ user types }
  TGSIOMode = (ioSynchronous, ioAsynchronous);
	TGSSystemComPort = GSComDB.TGSComPort;
  TGSBaudRate = (br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
    br19200, br38400, br56000, br57600, br115200, br128000, br256000);
	TGSDataBits = (db5, db6, db7, db8, db9);
	TGSParity = (pNone, pOdd, pEven, pMark, pSpace);
	TGSStopBits = (sb1, sb15, sb2);
	TGSFlowControl = (fcNone, fcRTS_CTS, fcDTR_DSR, fcXON_XOF);


	TGSOpModes = (rxNormal, rxMessage);
	TGSMsgState = (msNone, msStarted, msEnded, msDone);
//	TNotifyError = (neDialog, neEvent, neNone);
	TGSModemInSignal = (msCTS, msDSR, msRing, msRLSD);
  TGSModemInSignals = set of TGSModemInSignal;
	TGSModemOutSignal = (msRTS, msDTR);
  TGSModemOutSignals = set of TGSModemOutSignal;



	{ event procedures }
	TRxMessageEvent = procedure(Sender: TObject; RxMessage: AnsiString) of object;
	TSignalChangeEvent = procedure(Sender: TObject; Signal: TGSModemInSignal; SignalState: Boolean) of object;
//	TWriteCompletedEvent = procedure of object;



const
  DEFAULT_IO_MODE = ioAsynchronous;
  DEFAULT_PORT = 1;
  DEFAULT_BAUDRATE = br9600;
  DEFAULT_FLOW_MODE = fcNone;
  DEFAULT_PARITY_CHECK = False;
  DEFAULT_ABORT_ON_ERROR = False;
  DEFAULT_XON_LIM = 0;
  DEFAULT_XOFF_LIM = 0;
  DEFAULT_DATA_BITS = db8;
  DEFAULT_PARITY = pNone;
  DEFAULT_STOP_BITS = sb1;
  DEFAULT_XON_CHAR = DC1;
  DEFAULT_XOFF_CHAR = DC3;
  DEFAULT_ERROR_CHAR = '?';
  DEFAULT_EOF_CHAR = ETX;
  DEFAULT_EVT_CHAR = BEL;
  DEFAULT_RX_QUEUE_SIZE = 1024;
  DEFAULT_TX_QUEUE_SIZE = 1024;
  DEFAULT_RX_EVENT_MODE = rxNormal;
  DEFAULT_MESSAGE_START_CHAR = STX;
  DEFAULT_MESSAGE_END_CHAR = ETX;
  DEFAULT_MESSAGE_APPEND_COUNT = 0;
  DEFAULT_SIGNALS_OUT = [];
  DEFAULT_LOG_EVENTS = True;

  WM_COM_FIRST                  = WM_USER + $0400;
  WM_COM_TX_EVENT               = WM_COM_FIRST + 0;
  WM_COM_RX_EVENT               = WM_COM_FIRST + 1;
  WM_COM_MSG_EVENT              = WM_COM_FIRST + 2;
  WM_COM_CTS_EVENT              = WM_COM_FIRST + 3;
  WM_COM_DSR_EVENT              = WM_COM_FIRST + 4;
  WM_COM_RLSD_EVENT             = WM_COM_FIRST + 5;
  WM_COM_BREAK_EVENT            = WM_COM_FIRST + 6;
  WM_COM_RING_EVENT             = WM_COM_FIRST + 7;
  WM_COM_LAST                   = WM_COM_RING_EVENT;



type
  { forward class declarations }
	TBPComPortEventThread = class;
	TBPComPortComThread = class;



	{ TCustomGSComPort }
	TCustomGSComPort = class(TGsComponent)
  private
    { property fields }
    FActive: Boolean;
		FPort: TGSSystemComPort;
		FBaudrate: TGSBaudRate;
		FFlowMode: TGSFlowControl;          // flow control mode
    FParityCheck: Boolean;              // Check parity flag
    FAbortOnError: Boolean;             // abort on error flag
    FXonLim: Word;
    FXoffLim: Word;
		FDataBits: TGSDataBits;
		FParity: TGSParity;
		FStopBits: TGSStopBits;
    FXonChar: AnsiChar;
    FXoffChar: AnsiChar;
    FErrorChar: AnsiChar;
    FEofChar: AnsiChar;
    FEvtChar: AnsiChar;
		FRxQSize: Word;                     // Input queue size
		FTxQSize: Word;                     // Output queue size
		FRxEventMode: TGSOpModes;           // message trap mode
		FMessageStartChar: AnsiChar;        // message start character
		FMessageEndChar: AnsiChar;          // message end character
		FMessageAppendCount: Word;          // number of bytes to add after end character
    FSignalsOut: TGSModemOutSignals;    // modem output signals
		FLogEvents: Boolean;                // log all events

		{ event fields }
		FOnRxData: TNotifyEvent;
		FOnTxEmpty: TNotifyEvent;
		FOnMessage: TRxMessageEvent;
		FOnBreak: TNotifyEvent;
		FOnRing: TNotifyEvent;
		FOnSignalChange: TSignalChangeEvent;

		{ variables }
    FIOMode: TGSIOMode;
		FPortHandle: THandle;               // Comms id returned by CreateFile

		FMessageState: TGSMsgState;         // Message state flags
		FMessageAppendLeft: Word;           // Message overrun count
		FMessage: AnsiString;               // Message captured
    FWindowHandle: HWND;                // receives messages


		{ comm helpper variables }
		FDCB: TDCB;                         // DCB for Windows API
		FCommTimeouts: TCommTimeouts;       // Comms timeouts structure
    FComErrors: DWORD;
		FComStatus: TComStat;

		{ objects }
		FEventThread: TBPComPortEventThread;
    FComDatabase: TGSComDatabase;
    function GetActive: Boolean;
    function GetCTS: Boolean;
    function GetDSR: Boolean;
    function GetDTR: Boolean;
    function GetPortHandle: THandle;
    function GetRing: Boolean;
    function GetRLSD: Boolean;
    function GetRTS: Boolean;
    function GetRxQueueWaiting: Cardinal;
    function GetRxWaiting: Cardinal;
    function GetSignalsIn: TGSModemInSignals;
    function GetTxQueueWaiting: Cardinal;
    function GetTxWaiting: Cardinal;
    procedure SetAbortOnError(const Value: Boolean);
    procedure SetActive(const Value: Boolean);
    procedure SetBaudrate(const Value: TGSBaudRate);
    procedure SetDataBits(const Value: TGSDataBits);
    procedure SetDTR(const Value: Boolean);
    procedure SetEofChar(const Value: AnsiChar);
    procedure SetErrorChar(const Value: AnsiChar);
    procedure SetEvtChar(const Value: AnsiChar);
    procedure SetFlowMode(const Value: TGSFlowControl);
    procedure SetParity(const Value: TGSParity);
    procedure SetParityCheck(const Value: Boolean);
    procedure SetPort(const Value: TGSSystemComPort);
    procedure SetRTS(const Value: Boolean);
    procedure SetRxQSize(const Value: Word);
    procedure SetSignalsIn(const Value: TGSModemInSignals);
    procedure SetSignalsOut(const Value: TGSModemOutSignals);
    procedure SetStopBits(const Value: TGSStopBits);
    procedure SetTxQSize(const Value: Word);
    procedure SetXoffChar(const Value: AnsiChar);
    procedure SetXoffLim(const Value: Word);
    procedure SetXonChar(const Value: AnsiChar);
    procedure SetXonLim(const Value: Word);
  protected
		{ design time properties }
		property Port: TGSSystemComPort read FPort write SetPort default DEFAULT_PORT;
		property Baudrate: TGSBaudRate read FBaudrate write SetBaudrate default DEFAULT_BAUDRATE;
		property FlowMode: TGSFlowControl read FFlowMode write SetFlowMode default DEFAULT_FLOW_MODE;
		property ParityCheck: Boolean read FParityCheck write SetParityCheck default DEFAULT_PARITY_CHECK;

		property AbortOnError: Boolean read FAbortOnError write SetAbortOnError default DEFAULT_ABORT_ON_ERROR;
		property XonLim: Word read FXonLim write SetXonLim default DEFAULT_XON_LIM;
		property XoffLim: Word read FXoffLim write SetXoffLim default DEFAULT_XOFF_LIM;
		property DataBits: TGSDataBits read FDataBits write SetDataBits default DEFAULT_DATA_BITS;
		property Parity: TGSParity read FParity write SetParity default DEFAULT_PARITY;
		property StopBits: TGSStopBits read FStopBits write SetStopBits default DEFAULT_STOP_BITS;
		property XonChar: AnsiChar read FXonChar write SetXonChar default DEFAULT_XON_CHAR;
		property XoffChar: AnsiChar read FXoffChar write SetXoffChar default DEFAULT_XOFF_CHAR;
		property ErrorChar: AnsiChar read FErrorChar write SetErrorChar default DEFAULT_ERROR_CHAR;
		property EofChar: AnsiChar read FEofChar write SetEofChar default DEFAULT_EOF_CHAR;
		property EvtChar: AnsiChar read FEvtChar write SetEvtChar default DEFAULT_EVT_CHAR;

		property RxQueueSize: Word read FRxQSize write SetRxQSize default DEFAULT_RX_QUEUE_SIZE;
		property TxQueueSize: Word read FTxQSize write SetTxQSize default DEFAULT_TX_QUEUE_SIZE;

		property RxEventMode: TGSOpModes read FRxEventMode write FRxEventMode default DEFAULT_RX_EVENT_MODE;
		property MessageStartChar: AnsiChar read FMessageStartChar write FMessageStartChar default DEFAULT_MESSAGE_START_CHAR;
		property MessageEndChar: AnsiChar read FMessageEndChar write FMessageEndChar default DEFAULT_MESSAGE_END_CHAR;
		property MessageAppendCount: Word read FMessageAppendCount write FMessageAppendCount default DEFAULT_MESSAGE_APPEND_COUNT;

    property SignalsIn: TGSModemInSignals read GetSignalsIn write SetSignalsIn;
    property SignalsOut: TGSModemOutSignals read FSignalsOut write SetSignalsOut default DEFAULT_SIGNALS_OUT;

//		property EnableBuffer: Boolean read FEnableBuffer write FEnableBuffer;
    property LogEvents: Boolean read FLogEvents write FLogEvents default DEFAULT_LOG_EVENTS;

		{ event properties }
		property OnRxData: TNotifyEvent read FOnRxData write FOnRxData;
		property OnTxEmpty: TNotifyEvent read FOnTxEmpty write FOnTxEmpty;
		property OnMessage: TRxMessageEvent read FOnMessage write FOnMessage;
//		property OnError: TNotifyEvent read FOnError write FOnError;
		property OnBreak: TNotifyEvent read FOnBreak write FOnBreak;
		property OnRing : TNotifyEvent read FOnRing write FOnRing;
		property OnSignalChange: TSignalChangeEvent read FOnSignalChange write FOnSignalChange;
//		property OnWriteCompleted: TWriteCompletedEvent read FOnWriteCompleted write FOnWriteCompleted;
	protected
  	procedure CreatePortHandle(AComPort: TGSSystemComPort; var AHandle: THandle);
    procedure ClosePortHandle(var AHandle: THandle);

    procedure RaiseLastError(AFunction: String);
    procedure RaiseActiveError;
    procedure RaiseNotActiveError;

    procedure DoOpen;
    procedure DoClose;

		procedure SetupComPort;
		procedure UpdateComErrorsAndStatus;
		procedure EnableEvents;
		procedure DisableEvents;
    procedure SetSignal(ASignal: TGSModemOutSignal; AStatus: Boolean);

    procedure WndProc(var Msg: TMessage);

		procedure TxEvent;
		procedure RxEvent;
		procedure MsgEvent;
		procedure CTSEvent(const SignalState: Boolean);
		procedure DSREvent(const SignalState: Boolean);
		procedure RLSDEvent(const SignalState: Boolean);
		procedure BreakEvent;
		procedure RingEvent;


    { run time properties }
    property PortHandle: THandle read GetPortHandle;

		property RxWaiting: Cardinal read GetRxWaiting;
		property TxWaiting: Cardinal read GetTxWaiting;
		property RxQueueWaiting: Cardinal read GetRxQueueWaiting;
		property TxQueueWaiting: Cardinal read GetTxQueueWaiting;

    property CTS: Boolean read GetCTS;
    property DSR: Boolean read GetDSR;
    property Ring: Boolean read GetRing;
    property RLSD: Boolean read GetRLSD;

    property RTS: Boolean read GetRTS write SetRTS;
    property DTR: Boolean read GetDTR write SetDTR;

    (*
		property NotifyErrors: TNotifyError read FNotifyErrors write FNotifyErrors;
		property ErrorCode: DWORD read FErrorCode;
    property LogFile: Byte read fLogFile write fLogFile default LOG_SERIAL3;
    *)
    property ComDatabase: TGSComDatabase read FComDatabase;
	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;

    procedure LogError(ErrorCode: Longword; Description: String; Module: String = 'TCustomGSComPort.LogError'); deprecated;

    { Status }
    procedure Open;
    procedure Close;

		{ I/O }
		function ReadChar(var C: AnsiChar): Cardinal;
		function ReadString(var S: AnsiString; const Count: Cardinal = 0): Cardinal;
		procedure WriteChar(const C: AnsiChar);
		procedure WriteString(const S: AnsiString);

    {  }
		procedure ZapTxQueue;
		procedure ZapRxQueue;
		procedure ClearTxQueue;
		procedure ClearRxQueue;
		procedure Break(ADuration: Cardinal);

    procedure RefreshComPorts; virtual;

		{ run time properties }
		property Active: Boolean read GetActive write SetActive default False;
	end;

	TGSComPort = class(TCustomGSComPort)
  public
		property RxWaiting;
		property TxWaiting;
		property RxQueueWaiting;
		property TxQueueWaiting;

    property CTS;
    property DSR;
    property Ring;
    property RLSD;

    property RTS;
    property DTR;

    property ComDatabase;
	published
		{ design time properties }
		property Port;
		property Baudrate;
		property FlowMode;
		property ParityCheck;
		property DataBits;
		property Parity;
		property StopBits;
		property RxQueueSize;
		property TxQueueSize;
		property RxEventMode;
		property MessageStartChar;
		property MessageEndChar;
		property MessageAppendCount;
    property SignalsIn;
    property SignalsOut;
//		property NotifyErrors;
//		property ErrorCode;
//		property EnableBuffer;
//    property LogFile;
    property LogEvents;

		{ event properties }
		property OnRxData;
		property OnTxEmpty;
		property OnMessage;
//		property OnError;
		property OnBreak;
		property OnRing;
		property OnSignalChange;
//		property OnWriteCompleted;
	end;

	{ event handling thread }
	TBPComPortEventThread = class(TBPThread)
	private
		FOwner: TCustomGSComPort;
    FComThread: TBPComPortComThread;
    FEvent: TSimpleEvent;
    FOverlapped: TOverlapped;
		FCTSSignalState: Boolean;
		FDSRSignalState: Boolean;
		FRLSDSignalState: Boolean;
	protected
		procedure DoTxEvent;
		procedure DoRxEvent;
		procedure DoMsgEvent;
		procedure DoCTSEvent;
		procedure DoDSREvent;
		procedure DoRLSDEvent;
		procedure DoBreakEvent;
		procedure DoRingEvent;
    procedure EventSignaled(EventMask: DWORD);

		procedure DoExecute; override;
	public
		constructor Create(AOwner: TCustomGSComPort);
    destructor Destroy; override;

    class function Name: String; override;
	end;

	{ communication handling thread }
	TBPComPortComThread = class(TBPThread)
	private
		FOwner: TBPComPortEventThread;
    FSendData,
    FDataSent,
    FReceiveData,
    FDataReceived,
    FEvent: TSimpleEvent;
    FOverlapped: TOverlapped;
    FInBuffer,
    FOutBuffer: TGSQueueStream;
    procedure SetReceiveData(const Value: Boolean);
    procedure SetSendData(const Value: Boolean);
	protected
    function DoSendData: Boolean;
    function DoReceiveData: Boolean;
		procedure DoExecute; override;
	public
		constructor Create(AOwner: TBPComPortEventThread);
    destructor Destroy; override;

    class function Name: String; override;

		function ReadString(var S: AnsiString): Cardinal;
		procedure WriteString(const S: AnsiString);

    property SendData: Boolean write SetSendData;
//    property DataSent: TSimpleEvent read FDataSent;
    property ReceiveData: Boolean write SetReceiveData;
//    property DataReceived: TSimpleEvent read FDataReceived;
	end;

function IntToBaudRate(Value: DWORD): TGSBaudRate;
function BaudRateToInt(Value: TGSBaudRate): DWORD;

implementation

uses
  BPTimers, BPLogging, BPApp, BPUtils, Math, BPSystem, BPSysUtils;

const
	BAUD_RATES: array [TGSBaudRate] of DWORD = (
      CBR_110,
      CBR_300,
      CBR_600,
      CBR_1200,
      CBR_2400,
      CBR_4800,
      CBR_9600,
      CBR_14400,
      CBR_19200,
      CBR_38400,
      CBR_56000,
      CBR_57600,
      CBR_115200,
      CBR_128000,
      CBR_256000
    );

	DATA_BITS: array [TGSDataBits] of Byte = (5, 6, 7, 8, 9);
	PARITIES: array [TGSParity] of Byte = (NOPARITY, ODDPARITY, EVENPARITY, MARKPARITY, SPACEPARITY);
	STOP_BITS: array [TGSStopBits] of Byte = (ONESTOPBIT, ONE5STOPBITS, TWOSTOPBITS);


resourcestring
  SErrorInvalidHandle = 'Das Handle der Schnittstelle ist ungültig!';
  SErrorActiveInterface = 'Eine aktive Schnittstelle kann nicht konfiguriert werden!';

const
  MIN_TIMEOUT = 30000;

function IntToBaudRate(Value: DWORD): TGSBaudRate;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('IntToBaudRate');{$ENDIF}
  Result := Low(Result);

  try
    repeat
      if (Value = BAUD_RATES[Result]) then
        Exit
      else if (Result < High(Result)) then
        Result := Pred(Result);
    until (Result = High(Result));

    Result := br9600;
  finally
    {$IFDEF USE_CODESITE}BPC_CodeSite.SendEnum('Result', TypeInfo(TGSBaudRate), Ord(Result));{$ENDIF}
    {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('IntToBaudRate');{$ENDIF}
  end;
end;

function BaudRateToInt(Value: TGSBaudRate): DWORD;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('BaudRateToInt');{$ENDIF}

  Result := BAUD_RATES[Value];

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('BaudRateToInt');{$ENDIF}
end;

{ TCustomGSComPort }

procedure TCustomGSComPort.Break(ADuration: Cardinal);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('TCustomGSComPort');{$ENDIF}

  if Active then
  begin
    if SetCommBreak(PortHandle) then
    begin
      Wait(ADuration);
      ClearCommBreak(PortHandle);
    end;
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('TCustomGSComPort');{$ENDIF}
end;

procedure TCustomGSComPort.BreakEvent;
begin
	{ Execute OnBreak event }
  if Assigned(FOnBreak) then
		FOnBreak(Self);
end;

procedure TCustomGSComPort.ClearRxQueue;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ClearRxQueue');{$ENDIF}

  if Active then
  begin
    if not PurgeComm(PortHandle, PURGE_RXCLEAR) then
      RaiseLastError('PurgeComm');
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ClearRxQueue');{$ENDIF}
end;

procedure TCustomGSComPort.ClearTxQueue;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ClearTxQueue');{$ENDIF}

  if Active then
  begin
    if not PurgeComm(PortHandle, PURGE_TXCLEAR) then
      RaiseLastError('PurgeComm');
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ClearTxQueue');{$ENDIF}
end;

procedure TCustomGSComPort.Close;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Close');{$ENDIF}

  DoClose;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Close');{$ENDIF}
end;

procedure TCustomGSComPort.ClosePortHandle(var AHandle: THandle);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ClosePortHandle');{$ENDIF}

  try
    if not CloseHandle(AHandle) then
      RaiseLastError('CloseHandle');
  finally
    AHandle := INVALID_HANDLE_VALUE;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ClosePortHandle');{$ENDIF}
end;

constructor TCustomGSComPort.Create(AOwner: TComponent);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

	inherited Create(AOwner);

  if not (csDesigning in ComponentState) then
  begin
  	{ create objects }
    FComDatabase := TGSComDatabase.Create;
 	  FEventThread := TBPComPortEventThread.Create(Self);
    FWindowHandle := Classes.AllocateHWnd(WndProc);
  end;

  { set fields }
  FActive := False;
	FPort := DEFAULT_PORT;
	FBaudrate := DEFAULT_BAUDRATE;
	FFlowMode := DEFAULT_FLOW_MODE;
	FParityCheck := DEFAULT_PARITY_CHECK;
  FAbortOnError := DEFAULT_ABORT_ON_ERROR;
  FXonLim := DEFAULT_XON_LIM;
  FXoffLim := DEFAULT_XOFF_LIM;
	FDataBits := DEFAULT_DATA_BITS;
	FParity := DEFAULT_PARITY;
	FStopBits := DEFAULT_STOP_BITS;
	FXonChar := DEFAULT_XON_CHAR;
	FXoffChar := DEFAULT_XOFF_CHAR;
	FErrorChar := DEFAULT_ERROR_CHAR;
  FEofChar := DEFAULT_EOF_CHAR;
	FEvtChar := DEFAULT_EVT_CHAR;
	FRxQSize := DEFAULT_RX_QUEUE_SIZE;
	FTxQSize := DEFAULT_TX_QUEUE_SIZE;
	FRxEventMode := DEFAULT_RX_EVENT_MODE;
	FMessageStartChar := DEFAULT_MESSAGE_START_CHAR;
	FMessageEndChar := DEFAULT_MESSAGE_END_CHAR;
	FMessageAppendCount := DEFAULT_MESSAGE_APPEND_COUNT;
  FSignalsOut := DEFAULT_SIGNALS_OUT;
  FLogEvents := DEFAULT_LOG_EVENTS;

  FIOMode := DEFAULT_IO_MODE;
	FPortHandle := INVALID_HANDLE_VALUE;
//  FCriticalSectionActive := False;
	FMessageState := msNone;
	FMessageAppendLeft := 0;
  FMessage := '';

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

procedure TCustomGSComPort.CreatePortHandle(AComPort: TGSSystemComPort;
  var AHandle: THandle);
var
  Flags: DWORD;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'CreatePortHandle');{$ENDIF}

  if (FIOMode = ioAsynchronous) then
    Flags := FILE_FLAG_OVERLAPPED
  else
    Flags := 0;

  {$IFDEF SUPPORTS_UNICODE}
  AHandle := CreateFile(PWideChar(Format('\\.\COM%d', [AComPort])),
                      (GENERIC_READ or GENERIC_WRITE),
                       0,
                       nil,
                       OPEN_EXISTING,
                       Flags,
                       0);
  {$ELSE ~SUPPORTS_UNICODE}
  AHandle := CreateFile(PAnsiChar(Format('\\.\COM%d', [AComPort])),
                      (GENERIC_READ or GENERIC_WRITE),
                       0,
                       nil,
                       OPEN_EXISTING,
                       Flags,
                       0);
  {$ENDIF ~SUPPORTS_UNICODE}

  if (AHandle = INVALID_HANDLE_VALUE) then
    RaiseLastError('CreateFile');

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'CreatePortHandle');{$ENDIF}
end;

procedure TCustomGSComPort.CTSEvent(const SignalState: Boolean);
begin
	{ Execute OnSignalChange event for CTS }
  if Assigned(FOnSignalChange) then
		FOnSignalChange(Self, msCTS, SignalState);
end;

destructor TCustomGSComPort.Destroy;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Destroy');{$ENDIF}

  { close port }
  if Active then
    Close;

  if not (csDesigning in ComponentState) then
  begin
    Classes.DeallocateHWnd(FWindowHandle);
    
    { terminate event thread }
    FEventThread.Terminate;

    while FEventThread.Suspended do
      FEventThread.Resume;

    FEventThread.Free;

    FComDatabase.Free;
  end;

  inherited;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Destroy');{$ENDIF}
end;

procedure TCustomGSComPort.DisableEvents;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DisableEvents');{$ENDIF}

  if Active then
  begin
    if not (csDesigning in ComponentState) then
    begin
      {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Suspend EventThread');{$ENDIF}
      FEventThread.Suspend;

      if not SetCommMask(PortHandle, 0) then
        RaiseLastError('SetCommMask');
    end;
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DisableEvents');{$ENDIF}
end;

procedure TCustomGSComPort.DoClose;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoClose');{$ENDIF}

  if Active then
  begin
    try
      { Wipe TX and RX queue }
      try
        if not PurgeComm(PortHandle, PURGE_TXABORT or PURGE_RXABORT) then
          RaiseLastError('PurgeComm');
      except
      end;

      try
        if not FlushFileBuffers(PortHandle) then
          RaiseLastError('FlushFileBuffers');
      except
      end;

      { disable events }
      DisableEvents;

      { disable RTS & DTR }
      SetSignal(msRTS, False);
      SetSignal(msDTR, False);
    finally
      { clear active flag }
      FActive := False;

      { close handle }
      ClosePortHandle(FPortHandle);
    end;
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoClose');{$ENDIF}
end;

procedure TCustomGSComPort.DoOpen;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoOpen');{$ENDIF}

  if not Active then
  begin
    if ComDatabase.PortAvailable[FPort] then
    begin
      { get handle }
      CreatePortHandle(FPort, FPortHandle);

      if (FPortHandle <> INVALID_HANDLE_VALUE) then
      begin
        try
          { set active flag }
          FActive := True;

          { setup com properties }
          SetupComPort;

          { enable RTS & DTR }
          SetSignal(msRTS, msRTS in SignalsOut);
          SetSignal(msDTR, msDTR in SignalsOut);

          { enable events }
          EnableEvents;
        except
          FActive := False;
          ClosePortHandle(FPortHandle);
          raise;
        end;
      end;
    end
    else
    begin
      {$IFDEF USE_CODESITE}BPC_CodeSite.SendError('Port is not available = %u', [FPort]);{$ENDIF}
    end;
  end
  else
    RaiseActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoOpen');{$ENDIF}
end;

procedure TCustomGSComPort.DSREvent(const SignalState: Boolean);
begin
	{ Execute OnSignalChange event for DSR }
	if Assigned(FOnSignalChange) then
		FOnSignalChange(Self, msDSR, SignalState);
end;

procedure TCustomGSComPort.EnableEvents;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'EnableEvents');{$ENDIF}

  if Active then
  begin
    if not (csDesigning in ComponentState) then
    begin
      if not SetCommMask(PortHandle,
                         EV_RXCHAR or
  //                       EV_RXFLAG or
                         EV_TXEMPTY or
                         EV_CTS or
                         EV_DSR or
                         EV_RLSD or
                         EV_BREAK or
  //                       EV_ERR or
                         EV_RING) then
        RaiseLastError('SetCommMask');

      while FEventThread.Suspended do
        FEventThread.Resume;
    end;
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'EnableEvents');{$ENDIF}
end;

function TCustomGSComPort.GetActive: Boolean;
begin
  Result := (FPortHandle <> INVALID_HANDLE_VALUE) and FActive;
end;

function TCustomGSComPort.GetCTS: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetCTS');{$ENDIF}

  Result := msCTS in SignalsIn;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetCTS');{$ENDIF}
end;

function TCustomGSComPort.GetDSR: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetDSR');{$ENDIF}

  Result := msDSR in SignalsIn;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetDSR');{$ENDIF}
end;

function TCustomGSComPort.GetDTR: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetDTR');{$ENDIF}

  Result := msDTR in SignalsOut;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetDTR');{$ENDIF}
end;

function TCustomGSComPort.GetPortHandle: THandle;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetPortHandle');{$ENDIF}

  if (FPortHandle = INVALID_HANDLE_VALUE) then
  begin
    {$IFDEF USE_CODESITE}BPC_CodeSite.SendError('%s in %s', [SErrorInvalidHandle, 'GetPortHandle']);{$ENDIF}
    {$IFDEF USE_CODESITE}BPC_CodeSite.AddSeparator;{$ENDIF}
    raise EInvalidHandleError.CreateRes(@SErrorInvalidHandle);
  end
  else
    Result := FPortHandle;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetPortHandle');{$ENDIF}
end;

function TCustomGSComPort.GetRing: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetRing');{$ENDIF}

  Result := msRing in SignalsIn;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetRing');{$ENDIF}
end;

function TCustomGSComPort.GetRLSD: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetRLSD');{$ENDIF}

  Result := msRLSD in SignalsIn;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetRLSD');{$ENDIF}
end;

function TCustomGSComPort.GetRTS: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetRTS');{$ENDIF}

  Result := msRTS in SignalsOut;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetRTS');{$ENDIF}
end;

function TCustomGSComPort.GetRxQueueWaiting: Cardinal;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetRxQueueWaiting');{$ENDIF}

  Result := FEventThread.FComThread.FInBuffer.Size;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetRxQueueWaiting');{$ENDIF}
end;

function TCustomGSComPort.GetRxWaiting: Cardinal;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetRxWaiting');{$ENDIF}

  UpdateComErrorsAndStatus;
  Result := FComStatus.cbInQue;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetRxWaiting');{$ENDIF}
end;

function TCustomGSComPort.GetSignalsIn: TGSModemInSignals;
var
  ModemStat: DWORD;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetSignalsIn');{$ENDIF}

  Result := [];

  if Active then
  begin
    if not GetCommModemStatus(PortHandle, ModemStat) then
      RaiseLastError('GetCommModemStatus');

    if ((ModemStat and MS_CTS_ON) > 0) then
      Result := Result + [msCTS];

    if ((ModemStat and MS_DSR_ON) > 0) then
      Result := Result + [msDSR];

    if ((ModemStat and MS_RING_ON) > 0) then
      Result := Result + [msRing];

    if ((ModemStat and MS_RLSD_ON) > 0) then
      Result := Result + [msRLSD];
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetSignalsIn');{$ENDIF}
end;

function TCustomGSComPort.GetTxQueueWaiting: Cardinal;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetTxQueueWaiting');{$ENDIF}

  Result := FEventThread.FComThread.FOutBuffer.Size;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetTxQueueWaiting');{$ENDIF}
end;

function TCustomGSComPort.GetTxWaiting: Cardinal;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetTxWaiting');{$ENDIF}

  UpdateComErrorsAndStatus;
  Result := FComStatus.cbOutQue;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetTxWaiting');{$ENDIF}
end;

{$WARNINGS OFF}procedure TCustomGSComPort.LogError(ErrorCode: Longword;
  Description, Module: String);{$WARNINGS ON}
begin
  if (ErrorCode <> NO_ERROR) then
    {$IFDEF USE_CODESITE}BPC_CodeSite.SendWinError(Module + ' - ' + Description, ErrorCode){$ENDIF}
  else
    {$IFDEF USE_CODESITE}BPC_CodeSite.Send(Module + ' - ' + Description);{$ENDIF}
end;

procedure TCustomGSComPort.MsgEvent;
begin
	{ Execute OnRxMessage event }
	if Assigned(FOnMessage) then
		FOnMessage(Self, FMessage);
end;

procedure TCustomGSComPort.Open;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Open');{$ENDIF}

  DoOpen;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Open');{$ENDIF}
end;

procedure TCustomGSComPort.RaiseActiveError;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'RaiseActiveError');{$ENDIF}

  {$IFDEF USE_CODESITE}BPC_CodeSite.SendWarning('Port is active');{$ENDIF}

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'RaiseActiveError');{$ENDIF}
end;

procedure TCustomGSComPort.RaiseLastError(AFunction: String);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'RaiseLastError');{$ENDIF}

  try
    {$IFDEF USE_CODESITE}BPC_CodeSite.SendWinError(AFunction, GetLastError);{$ENDIF}
    {$IFDEF USE_CODESITE}BPC_CodeSite.AddSeparator;{$ENDIF}
    RaiseLastOSError;
  finally
    SetLastError(ERROR_SUCCESS);
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'RaiseLastError');{$ENDIF}
end;

procedure TCustomGSComPort.RaiseNotActiveError;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'RaiseNotActiveError');{$ENDIF}

  {$IFDEF USE_CODESITE}BPC_CodeSite.SendWarning('Port is not active');{$ENDIF}

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'RaiseNotActiveError');{$ENDIF}
end;

function TCustomGSComPort.ReadChar(var C: AnsiChar): Cardinal;
var
  TmpString: AnsiString;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ReadChar');{$ENDIF}

  Result := ReadString(TmpString, 1);

  if (Result > 0) then
    C := TmpString[1]
  else
    C := #0;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ReadChar');{$ENDIF}
end;

function TCustomGSComPort.ReadString(var S: AnsiString;
  const Count: Cardinal): Cardinal;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ReadString');{$ENDIF}

  Result := 0;

  if Active then
  begin
    if (Count > 0) then
      SetLength(S, Count)
    else if (Length(S) = 0) then
      SetLength(S, RxWaiting);

    if (Length(S) > 0) then
    begin
      Result := FEventThread.FComThread.ReadString(S);
    end;
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ReadString');{$ENDIF}
end;

procedure TCustomGSComPort.RefreshComPorts;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'RefreshComPorts');{$ENDIF}

  if not (csDesigning in ComponentState) then
    FComDatabase.Update;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'RefreshComPorts');{$ENDIF}
end;

procedure TCustomGSComPort.RingEvent;
begin
	{ Execute OnRing event }
	if Assigned(FOnRing) then
		FOnRing(Self);
end;

procedure TCustomGSComPort.RLSDEvent(const SignalState: Boolean);
begin
	{ Execute OnSignalChange event for RLSD }
	if Assigned(FOnSignalChange) then
		FOnSignalChange(Self, msRLSD, SignalState);
end;

procedure TCustomGSComPort.RxEvent;
begin
	{ Execute OnRxData event }
	if Assigned(FOnRxData) then
		FOnRxData(Self);
end;

procedure TCustomGSComPort.SetAbortOnError(const Value: Boolean);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetAbortOnError');{$ENDIF}

  if (Value <> FAbortOnError) then
  begin
    FAbortOnError := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetAbortOnError');{$ENDIF}
end;

procedure TCustomGSComPort.SetActive(const Value: Boolean);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetActive');{$ENDIF}

  if Value then
    Open
  else
    Close;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetActive');{$ENDIF}
end;

procedure TCustomGSComPort.SetBaudrate(const Value: TGSBaudRate);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetBaudrate');{$ENDIF}

  if (Value <> FBaudrate) then
  begin
    FBaudrate := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetBaudrate');{$ENDIF}
end;

procedure TCustomGSComPort.SetDataBits(const Value: TGSDataBits);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetDataBits');{$ENDIF}

  if (Value <> FDataBits) then
  begin
    FDataBits := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetDataBits');{$ENDIF}
end;

procedure TCustomGSComPort.SetDTR(const Value: Boolean);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetDTR');{$ENDIF}

  if Value then
    SignalsOut := SignalsOut + [msDTR]
  else
    SignalsOut := SignalsOut - [msDTR];

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetDTR');{$ENDIF}
end;

procedure TCustomGSComPort.SetEofChar(const Value: AnsiChar);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetEofChar');{$ENDIF}

  if (Value <> FEofChar) then
  begin
    FEofChar := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetEofChar');{$ENDIF}
end;

procedure TCustomGSComPort.SetErrorChar(const Value: AnsiChar);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetErrorChar');{$ENDIF}

  if (Value <> FErrorChar) then
  begin
    FErrorChar := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetErrorChar');{$ENDIF}
end;

procedure TCustomGSComPort.SetEvtChar(const Value: AnsiChar);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetEvtChar');{$ENDIF}

  if (Value <> FEvtChar) then
  begin
    FEvtChar := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetEvtChar');{$ENDIF}
end;

procedure TCustomGSComPort.SetFlowMode(const Value: TGSFlowControl);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetFlowMode');{$ENDIF}

  if (Value <> FFlowMode) then
  begin
    FFlowMode := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetFlowMode');{$ENDIF}
end;

procedure TCustomGSComPort.SetParity(const Value: TGSParity);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetParity');{$ENDIF}

  if (Value <> FParity) then
  begin
    FParity := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetParity');{$ENDIF}
end;

procedure TCustomGSComPort.SetParityCheck(const Value: Boolean);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetParityCheck');{$ENDIF}

  if (Value <> FParityCheck) then
  begin
    FParityCheck := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetParityCheck');{$ENDIF}
end;

procedure TCustomGSComPort.SetPort(const Value: TGSSystemComPort);
var
  WasActive: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetPort');{$ENDIF}

  if (Value <> FPort) then
  begin
    WasActive := Active;

    if WasActive then
      Close;

    FPort := Value;

    if WasActive then
      Open;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetPort');{$ENDIF}
end;

procedure TCustomGSComPort.SetRTS(const Value: Boolean);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetRTS');{$ENDIF}

  if Value then
    SignalsOut := SignalsOut + [msRTS]
  else
    SignalsOut := SignalsOut - [msRTS];

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetRTS');{$ENDIF}
end;

procedure TCustomGSComPort.SetRxQSize(const Value: Word);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetRxQSize');{$ENDIF}

  if (Value <> FRxQSize) then
  begin
    FRxQSize := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetRxQSize');{$ENDIF}
end;

procedure TCustomGSComPort.SetSignal(ASignal: TGSModemOutSignal;
  AStatus: Boolean);
var
	Func: DWORD;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetSignal');{$ENDIF}

  if Active then
  begin
    case ASignal of
      msRTS: begin
        if AStatus then
          Func := Windows.SETRTS
        else
          Func := CLRRTS;
      end;
      msDTR: begin
        if AStatus then
          Func := Windows.SETDTR
        else
          Func := CLRDTR;
      end;
    else
      raise EImplementationMissingError.CreateResFmt(@SErrorImplementationMissing, ['SetSignal', ClassName, IntToStr(Ord(ASignal))]);
    end;

    if not EscapeCommFunction(PortHandle, Func) then
      RaiseLastError('EscapeCommFunction');
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetSignal');{$ENDIF}
end;

procedure TCustomGSComPort.SetSignalsIn(const Value: TGSModemInSignals);
begin
  { do nothing, read only! }
end;

procedure TCustomGSComPort.SetSignalsOut(const Value: TGSModemOutSignals);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetSignalsOut');{$ENDIF}

  if (Value <> FSignalsOut) then
  begin
    FSignalsOut := Value;

    if not (csDesigning in ComponentState) and Active then
    begin
      SetSignal(msRTS, msRTS in FSignalsOut);
      SetSignal(msDTR, msDTR in FSignalsOut);
    end;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetSignalsOut');{$ENDIF}
end;

procedure TCustomGSComPort.SetStopBits(const Value: TGSStopBits);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetStopBits');{$ENDIF}

  if (Value <> FStopBits) then
  begin
    FStopBits := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetStopBits');{$ENDIF}
end;

procedure TCustomGSComPort.SetTxQSize(const Value: Word);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetTxQSize');{$ENDIF}

  if (Value <> FTxQSize) then
  begin
    FTxQSize := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetTxQSize');{$ENDIF}
end;

procedure TCustomGSComPort.SetupComPort;
const
  DCB_FLAG_BINARY              = $00000001; // bit 0
  DCB_FLAG_PARITY              = $00000002; // bit 1
  DCB_FLAG_OUTX_CTS_FLOW       = $00000004; // bit 2
  DCB_FLAG_OUTX_DSR_FLOW       = $00000008; // bit 3
  DCB_FLAG_DTR_CONTROL         = $00000030; // bit 4-5, 2 bit mask
  DCB_FLAG_DSR_SENSITIVITY     = $00000040; // bit 6
  DCB_FLAG_TX_CONTINUE_ON_XOFF = $00000080; // bit 7
  DCB_FLAG_OUT_X               = $00000100; // bit 8
  DCB_FLAG_IN_X                = $00000200; // bit 9
  DCB_FLAG_ERROR_CHAR          = $00000400; // bit 10
  DCB_FLAG_NULL                = $00000800; // bit 11
  DCB_FLAG_RTS_CONTROL         = $00003000; // bit 12-13, 2 bit mask
  DCB_FLAG_ABORT_ON_ERROR      = $00004000; // bit 14
  DCB_FLAG_DUMMY_2             = $FFFF8000; // bit 15-31, 17 bit mask
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetupComPort');{$ENDIF}

  if Active then
  begin
    { DONE: perhaps active but rewrite}
    while (TxWaiting > 0) do
      if IsMainThread then
        BPApplication.ProcessMessagesEx(50, 5)
      else
        Sleep(5);

    { setup comm }
    if not SetupComm(PortHandle, FRxQSize, FTxQSize) then
      RaiseLastError('SetupComPortm');

    { setup DCB parameters }
    FDCB.DCBlength := SizeOf(TDCB);
    FDCB.BaudRate := BAUD_RATES[FBaudRate];

    FDCB.Flags := DCB_FLAG_BINARY;

    if FParityCheck then
      FDCB.Flags := FDCB.Flags or DCB_FLAG_PARITY;

    case FFlowMode of
      fcRTS_CTS: FDCB.Flags := FDCB.Flags or (RTS_CONTROL_HANDSHAKE shl 12) or DCB_FLAG_OUTX_CTS_FLOW;
      fcDTR_DSR: FDCB.Flags := FDCB.Flags or (DTR_CONTROL_HANDSHAKE shl 4) or DCB_FLAG_OUTX_DSR_FLOW;
      fcXON_XOF: FDCB.Flags := FDCB.Flags or (RTS_CONTROL_TOGGLE shl 12) or DCB_FLAG_OUT_X or DCB_FLAG_IN_X;
    end;

    FDCB.XonLim := FRxQSize div 3;                { Send XON when 1/3 full }
    FDCB.XoffLim := FRxQSize div 3;               { Send XOF when 2/3 full }
    FDCB.ByteSize := DATA_BITS[FDataBits];
    FDCB.Parity := PARITIES[FParity];
    FDCB.StopBits := STOP_BITS[FStopBits];

    FDCB.XonChar := FXonChar;
    FDCB.XoffChar := FXoffChar;
    FDCB.ErrorChar := FErrorChar;
    FDCB.EofChar := FEofChar;
    FDCB.EvtChar := FEvtChar;

    if not SetCommState(PortHandle, FDCB) then
      RaiseLastError('SetCommState');

    { setup comm timeouts }
    FCommTimeouts.ReadIntervalTimeout := MAXDWORD; { Non-blocking read }
    FCommTimeouts.ReadTotalTimeoutMultiplier := 0;
    FCommTimeouts.ReadTotalTimeoutConstant := 0;

    { Block writes only if flow control is active }
    if (FFlowMode <> fcNone) then
    begin
      FCommTimeouts.WriteTotalTimeoutMultiplier := 0;
      FCommTimeouts.WriteTotalTimeoutConstant := 10000;
    end;

    if not SetCommTimeouts(PortHandle, FCommTimeouts) then
      RaiseLastError('SetCommTimeouts');
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetupComPort');{$ENDIF}
end;

procedure TCustomGSComPort.SetXoffChar(const Value: AnsiChar);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetXoffChar');{$ENDIF}

  if (Value <> FXoffChar) then
  begin
    FXoffChar := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetXoffChar');{$ENDIF}
end;

procedure TCustomGSComPort.SetXoffLim(const Value: Word);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetXoffLim');{$ENDIF}

  if (Value <> FXoffLim) then
  begin
    FXoffLim := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetXoffLim');{$ENDIF}
end;

procedure TCustomGSComPort.SetXonChar(const Value: AnsiChar);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetXonChar');{$ENDIF}

  if (Value <> FXonChar) then
  begin
    FXonChar := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetXonChar');{$ENDIF}
end;

procedure TCustomGSComPort.SetXonLim(const Value: Word);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetXonLim');{$ENDIF}

  if (Value <> FXonLim) then
  begin
    FXonLim := Value;

    if Active then
      SetupComPort;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetXonLim');{$ENDIF}
end;

procedure TCustomGSComPort.TxEvent;
begin
	{ Execute OnTxEmpty event }
  if Assigned(FOnTxEmpty) then
		FOnTxEmpty(Self);
end;

procedure TCustomGSComPort.UpdateComErrorsAndStatus;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'UpdateComErrorsAndStatus');{$ENDIF}

  if not ClearCommError(PortHandle, FComErrors, @FComStatus) then
    RaiseLastError('ClearCommError');

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'UpdateComErrorsAndStatus');{$ENDIF}
end;

procedure TCustomGSComPort.WndProc(var Msg: TMessage);
begin
  try
    with Msg do
      case Msg of
        WM_COM_TX_EVENT: TxEvent;
        WM_COM_RX_EVENT: RxEvent;
        WM_COM_MSG_EVENT: MsgEvent;
        WM_COM_CTS_EVENT: CTSEvent(WParam = 1);
        WM_COM_DSR_EVENT: DSREvent(WParam = 1);
        WM_COM_RLSD_EVENT: RLSDEvent(WParam = 1);
        WM_COM_BREAK_EVENT: BreakEvent;
        WM_COM_RING_EVENT: RingEvent;
      else
        Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
      end;
  except
    if csDesigning in ComponentState then
      if Assigned(Classes.ApplicationHandleException) then
        Classes.ApplicationHandleException(ExceptObject)
      else
        ShowException(ExceptObject, ExceptAddr)
    else
      raise;
  end
end;

procedure TCustomGSComPort.WriteChar(const C: AnsiChar);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'WriteChar');{$ENDIF}

  WriteString(C);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'WriteChar');{$ENDIF}
end;

procedure TCustomGSComPort.WriteString(const S: AnsiString);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'WriteString');{$ENDIF}

  if Active then
  begin
    if (Length(S) > 0) then
    begin
      FEventThread.FComThread.WriteString(S);
    end;
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'WriteString');{$ENDIF}
end;

procedure TCustomGSComPort.ZapRxQueue;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ZapRxQueue');{$ENDIF}

  if Active then
  begin
    if not PurgeComm(PortHandle, PURGE_RXABORT) then
      RaiseLastError('PurgeComm');
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ZapRxQueue');{$ENDIF}
end;

procedure TCustomGSComPort.ZapTxQueue;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ZapTxQueue');{$ENDIF}

  if Active then
  begin
    if not PurgeComm(PortHandle, PURGE_TXABORT) then
      RaiseLastError('PurgeComm');
  end
  else
    RaiseNotActiveError;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ZapTxQueue');{$ENDIF}
end;

{ TBPComPortEventThread }

constructor TBPComPortEventThread.Create(AOwner: TCustomGSComPort);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

	inherited Create(True);

	Priority := tpTimeCritical;

	FOwner := AOwner;
  FComThread := TBPComPortComThread.Create(Self);
  FEvent := TSimpleEvent.Create;
	FOverlapped.hEvent := FEvent.Handle;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

destructor TBPComPortEventThread.Destroy;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Destroy');{$ENDIF}

  FOverlapped.hEvent := 0;
  FEvent.Free;

  { terminate communication thread }
  FComThread.Terminate;

  while FComThread.Suspended do
    FComThread.Resume;

  FComThread.Free;

  inherited;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Destroy');{$ENDIF}
end;

procedure TBPComPortEventThread.DoBreakEvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoBreakEvent');{$ENDIF}

  PostMessage(FOwner.FWindowHandle, WM_COM_BREAK_EVENT, 0, 0);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoBreakEvent');{$ENDIF}
end;

procedure TBPComPortEventThread.DoCTSEvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoCTSEvent');{$ENDIF}

  PostMessage(FOwner.FWindowHandle, WM_COM_CTS_EVENT, BoolToInt(FCTSSignalState), 0);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoCTSEvent');{$ENDIF}
end;

procedure TBPComPortEventThread.DoDSREvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoDSREvent');{$ENDIF}

  PostMessage(FOwner.FWindowHandle, WM_COM_DSR_EVENT, BoolToInt(FDSRSignalState), 0);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoDSREvent');{$ENDIF}
end;

procedure TBPComPortEventThread.DoExecute;
var
	EventMask: DWORD;
  Overlapped: POverlapped;
  NumberOfBytesTransferred: DWORD;
  Timer: Cardinal;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoExecute');{$ENDIF}

  Timer := 0;

  while not Terminated do
  begin
    if not Suspended then
    begin
      with FOwner do
      begin
        if Active then
        begin
          { Wait for the comms event }
          EventMask := 0;

          if (FIOMode = ioSynchronous) then
            Overlapped := nil
          else
            Overlapped := @FOverlapped;

          FEvent.ResetEvent;

          if not WaitCommEvent(PortHandle, EventMask, Overlapped)	then
          begin
            if (GetLastError = ERROR_IO_PENDING) then
            begin
              if GetOverlappedResult(PortHandle, Overlapped^, NumberOfBytesTransferred, True) then
                EventSignaled(EventMask)
              else
                try
                  RaiseLastError('GetOverlappedResult');
                except
                end;
            end
            else
              try
                RaiseLastError('WaitCommEvent');
              except
              end;
          end
          else
            EventSignaled(EventMask);
        end
        else
        begin
          { suspend the thread if idle }
          if (Timer = 0) then
          begin
            Timer := StartTimer;
            {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Thread is idle');{$ENDIF}
          end
          else if TimerDone(Timer, 5000) then
          begin
            Timer := 0;
            {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Suspend Thread');{$ENDIF}
            Suspend;
          end;
        end;
      end;
    end;
	end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoExecute');{$ENDIF}
end;

procedure TBPComPortEventThread.DoMsgEvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoMsgEvent');{$ENDIF}

  PostMessage(FOwner.FWindowHandle, WM_COM_MSG_EVENT, 0, 0);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoMsgEvent');{$ENDIF}
end;

procedure TBPComPortEventThread.DoRingEvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoRingEvent');{$ENDIF}

  PostMessage(FOwner.FWindowHandle, WM_COM_RING_EVENT, 0, 0);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoRingEvent');{$ENDIF}
end;

procedure TBPComPortEventThread.DoRLSDEvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoRLSDEvent');{$ENDIF}

  PostMessage(FOwner.FWindowHandle, WM_COM_RLSD_EVENT, BoolToInt(FRLSDSignalState), 0);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoRLSDEvent');{$ENDIF}
end;

procedure TBPComPortEventThread.DoRxEvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoRxEvent');{$ENDIF}

  PostMessage(FOwner.FWindowHandle, WM_COM_RX_EVENT, 0, 0);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoRxEvent');{$ENDIF}
end;

procedure TBPComPortEventThread.DoTxEvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoTxEvent');{$ENDIF}

  PostMessage(FOwner.FWindowHandle, WM_COM_TX_EVENT, 0, 0);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoTxEvent');{$ENDIF}
end;

procedure TBPComPortEventThread.EventSignaled(EventMask: DWORD);
var
  InSignals: TGSModemInSignals;
  LogEvents: Boolean;
  C: AnsiChar;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'EventSignaled');{$ENDIF}

  InSignals := FOwner.SignalsIn;
  LogEvents := FOwner.FLogEvents;

  {$IFDEF USE_CODESITE}BPC_CodeSite.Send('EventMask', EventMask);{$ENDIF}
  {$IFDEF USE_CODESITE}BPC_CodeSite.SendSet('InSignals', TypeInfo(TGSModemInSignals), InSignals);{$ENDIF}
  {$IFDEF USE_CODESITE}BPC_CodeSite.Send('LogEvents', LogEvents);{$ENDIF}

  if (EventMask and EV_CTS) > 0 then
  begin
    FCTSSignalState := msCTS in InSignals;

		if LogEvents then
      BPC_CodeSite.Send('CTS Event', FCTSSignalState);

    DoCTSEvent;
  end;

  if (EventMask and EV_DSR) > 0 then
  begin
    FDSRSignalState := msDSR in InSignals;

		if LogEvents then
      BPC_CodeSite.Send('DSR Event', FDSRSignalState);

    DoDSREvent;
  end;

  if (EventMask and EV_RLSD) > 0 then
  begin
    FRLSDSignalState := msRLSD in InSignals;

		if LogEvents then
      BPC_CodeSite.Send('RLSD Event', FRLSDSignalState);

    DoRLSDEvent;
  end;

  if (EventMask and EV_TXEMPTY) > 0 then
  begin
		if LogEvents then
      BPC_CodeSite.SendMsg('TX Event');

    DoTxEvent;
  end;

  if (EventMask and EV_BREAK) > 0 then
  begin
		if LogEvents then
      BPC_CodeSite.SendMsg('Break event');

    DoBreakEvent;
  end;

  if (EventMask and EV_RING) > 0 then
  begin
		if LogEvents then
      BPC_CodeSite.SendMsg('Ring Event');

    DoRingEvent;
  end;

  if (EventMask and EV_RXCHAR) > 0 then
  begin
		if LogEvents then
      BPC_CodeSite.SendMsg('RX Event');

    case FOwner.FRxEventMode of
      rxNormal: begin
        FComThread.ReceiveData := True;
      end;
      rxMessage: begin
        with FOwner do
        begin
          { Check for OnMessage event }
          if Assigned(FOnMessage) then
          begin
            try
              ReadChar(C);

              if (FMessageState = msEnded) then
              begin
                FMessage := FMessage + C;
                Dec(FMessageAppendLeft);

                if (FMessageAppendLeft <= 0) then
                begin
                  { Append count completed - call event }
                  FMessageState := msDone;

                  if LogEvents then
                    BPC_CodeSite.SendMsg('Msg Event');

                  DoMsgEvent;
                end;
              end
              else
              begin
                if (C = FMessageStartChar) then
                begin
                  { Always set start of message }
                  FMessageState := msStarted;
                  FMessage := C;
                end
                else if (C = FMessageEndChar) then
                begin
                  { Set ended if running }
                  if (FMessageState = msStarted) then
                  begin
                    FMessage := FMessage + C;
                    FMessageState := msEnded;

                    if FMessageAppendCount = 0 then
                    begin
                      FMessageState := msDone;

                      if LogEvents then
                        BPC_CodeSite.SendMsg('Msg Event');

                      DoMsgEvent;
                    end
                    else
                    begin
                      FMessageAppendLeft := FMessageAppendCount;
                    end;
                  end;
                end
                else
                begin
                  if (FMessageState = msStarted) then
                  begin
                    FMessage := FMessage + C;
                  end;
                end;
              end;
            except
              on E: Exception do
              begin
                BPC_CodeSite.SendException(E);
                FMessageState := msNone;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'EventSignaled');{$ENDIF}
end;

class function TBPComPortEventThread.Name: String;
begin
  Result := 'ComPortEventThread';
end;

{ TBPComPortComThread }

constructor TBPComPortComThread.Create(AOwner: TBPComPortEventThread);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

  inherited Create(True);

  Priority := tpHighest;

  FOwner := AOwner;
  FSendData := TSimpleEvent.Create;
  FDataSent := TSimpleEvent.Create;
  FReceiveData := TSimpleEvent.Create;
  FDataReceived := TSimpleEvent.Create;
  FEvent := TSimpleEvent.Create;
  FOverlapped.hEvent := FEvent.Handle;
  FInBuffer := TGSQueueStream.Create;
  FOutBuffer := TGSQueueStream.Create;

  Resume;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

destructor TBPComPortComThread.Destroy;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Destroy');{$ENDIF}

  FOutBuffer.Free;
  FInBuffer.Free;
  FOverlapped.hEvent := 0;
  FEvent.Free;
  FDataReceived.Free;
  FReceiveData.Free;
  FDataSent.Free;
  FSendData.Free;

  inherited;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Destroy');{$ENDIF}
end;

procedure TBPComPortComThread.DoExecute;
var
  Timer: Cardinal;
  EventHandles: TWOHandleArray;
  WaitResult: DWORD;
  Idle: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoExecute');{$ENDIF}

  Timer := 0;
  EventHandles[0] := FSendData.Handle;
  EventHandles[1] := FReceiveData.Handle;

  while not Terminated do
  begin
    if not Suspended then
    begin
      Idle := True;

      if FOwner.FOwner.Active then
      begin
        WaitResult := WaitForMultipleObjects(2, @EventHandles, False, 500);

        case WaitResult of
          WAIT_OBJECT_0 + 0: begin
            {$IFDEF USE_CODESITE}BPC_CodeSite.Send('SendData signaled');{$ENDIF}

            if DoSendData then
              FDataSent.SetEvent
            else
              FSendData.ResetEvent;
          end;
          WAIT_OBJECT_0 + 1: begin
            {$IFDEF USE_CODESITE}BPC_CodeSite.Send('ReceiveData signaled');{$ENDIF}

            if DoReceiveData then
              FDataReceived.SetEvent
            else
              FReceiveData.ResetEvent;
          end;
          WAIT_ABANDONED_0 + 0: ;
          WAIT_ABANDONED_0 + 1: ;
          WAIT_TIMEOUT: ;
        else
        end;

        Idle := not (FSendData.WaitFor(0) = wrSignaled) and not (FReceiveData.WaitFor(0) = wrSignaled);
      end;

      if Idle and not Terminated then
      begin
        { suspend the thread if idle }
        if (Timer = 0) then
        begin
          Timer := StartTimer;
          {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Thread is idle');{$ENDIF}
        end
        else if TimerDone(Timer, 60000) then
        begin
          Timer := 0;
          {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Suspend Thread');{$ENDIF}
          Suspend;
        end;
      end;
    end;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoExecute');{$ENDIF}
end;

function TBPComPortComThread.DoReceiveData: Boolean;
var
  Overlapped: POverlapped;
  NumberOfBytesTransferred: DWORD;
  Str: AnsiString;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoReceiveData');{$ENDIF}

  Result := False;

  try
    SetLength(Str, FOwner.FOwner.RxWaiting);
  except
    SetLength(Str, 0);
  end;

  if (Length(Str) > 0) then
  begin
    if (FOwner.FOwner.FIOMode = ioSynchronous) then
      Overlapped := nil
    else
      Overlapped := @FOverlapped;

    {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Number of bytes to read', Length(Str));{$ENDIF}

    FEvent.ResetEvent;

    if not ReadFile(FOwner.FOwner.PortHandle, Str[1], Length(Str), NumberOfBytesTransferred, Overlapped) then
    begin
      if (GetLastError = ERROR_IO_PENDING) then
      begin
        if GetOverlappedResult(FOwner.FOwner.PortHandle, Overlapped^, NumberOfBytesTransferred, True) then
        begin
          SetLength(Str, NumberOfBytesTransferred);
          {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Chars read', StrToHex(Str));{$ENDIF}
          FInBuffer.Push(Str);
          Result := True;
        end
        else
        begin
          try
            FOwner.FOwner.RaiseLastError('GetOverlappedResult');
          except
          end;
        end;
      end
      else
      begin
        try
          FOwner.FOwner.RaiseLastError('ReadFile');
        except
        end;
      end;
    end
    else
    begin
      SetLength(Str, NumberOfBytesTransferred);
      {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Chars read', StrToHex(Str));{$ENDIF}
      FInBuffer.Push(Str);
      Result := True;
    end;

    FOwner.DoRxEvent;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoReceiveData');{$ENDIF}
end;

function TBPComPortComThread.DoSendData: Boolean;
var
  Overlapped: POverlapped;
  NumberOfBytesTransferred: DWORD;
  Str: AnsiString;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoSendData');{$ENDIF}

  Result := False;

  if (FOutBuffer.Size > 0) then
  begin
    FOutBuffer.Pop(Str, 0);

    {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Chars to write', StrToHex(Str));{$ENDIF}

    if (FOwner.FOwner.FIOMode = ioSynchronous) then
      Overlapped := nil
    else
      Overlapped := @FOverlapped;

    FEvent.ResetEvent;

    if not WriteFile(FOwner.FOwner.PortHandle, Str[1], Length(Str), NumberOfBytesTransferred, Overlapped) then
    begin
      if (GetLastError = ERROR_IO_PENDING) then
      begin
        if GetOverlappedResult(FOwner.FOwner.PortHandle, Overlapped^, NumberOfBytesTransferred, True) then
        begin
          Result := True;
        end
        else
        begin
          try
            FOwner.FOwner.RaiseLastError('GetOverlappedResult');
          except
          end;
        end;
      end
      else
      begin
        try
          FOwner.FOwner.RaiseLastError('WriteFile');
        except
        end;
      end;
    end
    else
      Result := True;

    {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Number of bytes written', NumberOfBytesTransferred);{$ENDIF}
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoSendData');{$ENDIF}
end;

class function TBPComPortComThread.Name: String;
begin
  Result := 'ComPortComThread';
end;

function TBPComPortComThread.ReadString(var S: AnsiString): Cardinal;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ReadString');{$ENDIF}

  Result := FInBuffer.Pop(S, Length(S));

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ReadString');{$ENDIF}
end;

procedure TBPComPortComThread.SetReceiveData(const Value: Boolean);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetReceiveData');{$ENDIF}

  FDataReceived.ResetEvent;
  FReceiveData.SetEvent;

  while Suspended do
    Resume;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetReceiveData');{$ENDIF}
end;

procedure TBPComPortComThread.SetSendData(const Value: Boolean);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetSendData');{$ENDIF}

  FDataSent.ResetEvent;
  FSendData.SetEvent;

  while Suspended do
    Resume;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetSendData');{$ENDIF}
end;

procedure TBPComPortComThread.WriteString(const S: AnsiString);
var
  Timer: Cardinal;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'WriteString');{$ENDIF}

  FOutBuffer.Push(S);

  SendData := True;

  Timer := StartTimer;

  { TODO: complete error handling}
  repeat
    case FDataSent.WaitFor(10) of
      wrSignaled: Break;
      wrTimeout: ;
      wrAbandoned: ;
      wrError: ;
    else
    end;

    if IsMainThread then
      BPApplication.ProcessMessagesEx(50, 5)
    else
      Sleep(5);
  until TimerDone(Timer, 5000);

  (*
  if TimerDone(Timer, 60000) then
    raise
  *)

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'WriteString');{$ENDIF}
end;

end.

