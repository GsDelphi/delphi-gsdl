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
  @abstract(Gilbertsoft logging routines)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2019-01-09)
  @cvs($Date:$)

  @name contains system constants and resourcestrings.
}
unit GsLogging;

{$I gsdl.inc}

interface

uses
  Classes,
  GsSyslog,
  SysUtils,
  Types,
  TypInfo,
  UITypes,
  WideStrings,
  Windows;

type
  TGsLoggerClass = class of TAbstractGsLogger;

  TAbstractGsDispatcher = class(TObject)
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Send(const Msg: string); overload;
  end;

  TAbstractGsLogger = class(TObject)
  protected
    class procedure RegisterDispatcher(ADispatcher: TAbstractGsDispatcher);
    class procedure RemoveDispatcher(ADispatcher: TAbstractGsDispatcher);
  public
    class procedure Disable;
    class procedure Enable;
    class function Enabled: Boolean;

    // Overloaded Send Methods
    class procedure Send(const Msg: string); overload;
    (*
    class procedure Send(const Fmt: string; const Args: array of const); overload;
    class procedure Send(const Msg: string; const Value: string); overload;
    class procedure Send(const Msg: string; Value: Char); overload;
    class procedure Send(const Msg: string; Value: PChar); overload;
    class procedure Send(const Msg: string; Value: Integer); overload;
    class procedure Send(const Msg: string; Value: Word); overload;
    class procedure Send(const Msg: string; Value: LongWord;
      AsHex: Boolean = False); overload;
    class procedure Send(const Msg: string; Value: Int64); overload;
    class procedure Send(const Msg: string; Value: Extended;
      Precision: Integer = 2); overload;
    class procedure Send(const Msg: string; Expression: Boolean); overload;
    {$IFNDEF CODESITE_EXPRESS}
    class procedure Send(const Msg: string; Value: TPoint); overload;
    class procedure Send(const Msg: string; Value: TSmallPoint); overload;
    class procedure Send(const Msg: string; Value: TRect); overload;
    {$ENDIF}
    class procedure Send(const Msg: string; List: TStrings); overload;
    class procedure Send(const Msg: string; List: TWideStrings); overload;
    {$IFNDEF CODESITE_EXPRESS}
    class procedure Send(const Msg: string; Collection: TCollection); overload;
    class procedure Send(const Msg: string; Bitmap: TBitmap); overload;
    //class procedure Send( const Msg: string; PngImage: TPngImage ); overload;
    //class procedure Send( const Msg: string; Icon: TIcon ); overload;
    //class procedure Send( const Msg: string; Picture: TPicture ); overload;
    //class procedure Send( const Msg: string; Graphic: TGraphic ); overload;
    {$ENDIF}
    class procedure Send(const Msg: string; const Obj: TObject); overload;

    // Overloaded Send Methods with MsgType
    class procedure Send(MsgType: Integer; const Msg: string); overload;
    class procedure Send(MsgType: Integer; const Fmt: string;
      const Args: array of const); overload;
    class procedure Send(MsgType: Integer; const Msg: string;
      const Value: string); overload;
    class procedure Send(MsgType: Integer; const Msg: string; Value: Char); overload;
    class procedure Send(MsgType: Integer; const Msg: string; Value: PChar); overload;
    class procedure Send(MsgType: Integer; const Msg: string;
      Value: Integer); overload;
    class procedure Send(MsgType: Integer; const Msg: string; Value: Word); overload;
    class procedure Send(MsgType: Integer; const Msg: string;
      Value: LongWord; AsHex: Boolean = False); overload;
    class procedure Send(MsgType: Integer; const Msg: string; Value: Int64); overload;
    class procedure Send(MsgType: Integer; const Msg: string;
      Value: Extended; Precision: Integer = 2); overload;
    class procedure Send(MsgType: Integer; const Msg: string;
      Expression: Boolean); overload;
    {$IFNDEF CODESITE_EXPRESS}
    class procedure Send(MsgType: Integer; const Msg: string; Value: TPoint); overload;
    class procedure Send(MsgType: Integer; const Msg: string;
      Value: TSmallPoint); overload;
    class procedure Send(MsgType: Integer; const Msg: string; Value: TRect); overload;
    {$ENDIF}
    class procedure Send(MsgType: Integer; const Msg: string;
      List: TStrings); overload;
    class procedure Send(MsgType: Integer; const Msg: string;
      List: TWideStrings); overload;
    {$IFNDEF CODESITE_EXPRESS}
    class procedure Send(MsgType: Integer; const Msg: string;
      Collection: TCollection); overload;
    class procedure Send(MsgType: Integer; const Msg: string;
      Bitmap: TBitmap); overload;
    //class procedure Send( MsgType: Integer; const Msg: string; PngImage: TPngImage ); overload;
    //class procedure Send( MsgType: Integer; const Msg: string; Icon: TIcon ); overload;
    //class procedure Send( MsgType: Integer; const Msg: string; Picture: TPicture ); overload;
    //class procedure Send( MsgType: Integer; const Msg: string; Graphic: TGraphic ); overload;
    {$ENDIF}
    class procedure Send(MsgType: Integer; const Msg: string;
      const Obj: TObject); overload;


    // Simple Messages
    class procedure SendMsg(const Msg: string); overload;
    class procedure SendMsg(MsgType: Integer; const Msg: string); overload;
    class procedure SendFmtMsg(const Fmt: string; const Args: array of const);
      overload;
    class procedure SendFmtMsg(MsgType: Integer; const Fmt: string;
      const Args: array of const); overload;

    // Notes, Errors, Warnings, and Reminders
    class procedure SendNote(const Msg: string); overload;
    class procedure SendNote(const Fmt: string; const Args: array of const); overload;
    class procedure SendError(const Msg: string); overload;
    class procedure SendError(const Fmt: string; const Args: array of const); overload;
    class procedure SendWarning(const Msg: string); overload;
    class procedure SendWarning(const Fmt: string; const Args: array of const);
      overload;
    class procedure SendReminder(const Reminder: string); overload;
    class procedure SendReminder(const Fmt: string; const Args: array of const);
      overload;

    // Strings, Chars, and PChars
    class procedure SendAssigned(const Msg: string; Value: Pointer); overload;
    class procedure SendAssigned(MsgType: Integer; const Msg: string;
      Value: Pointer); overload;

    // Colors
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendColor(const Msg: string; Value: TColor); overload;
    class procedure SendColor(MsgType: Integer; const Msg: string;
      Value: TColor); overload;
    class procedure SendColorARGB(const Msg: string; Value: LongWord); overload;
    class procedure SendColorARGB(MsgType: Integer; const Msg: string;
      Value: LongWord); overload;
    {$ENDIF}

    // Currency
    class procedure SendCurrency(const Msg: string; Value: Currency); overload;
    class procedure SendCurrency(MsgType: Integer; const Msg: string;
      Value: Currency); overload;

    // Dates and Times
    class procedure SendDateTime(const Msg: string; Value: TDateTime;
      const Fmt: string = ''); overload;
    class procedure SendDateTime(MsgType: Integer; const Msg: string;
      Value: TDateTime; const Fmt: string = ''); overload;

    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendScreenShot(const Msg: string; Wnd: Cardinal); overload;
    class procedure SendScreenShot(MsgType: Integer; const Msg: string;
      Wnd: Cardinal); overload;
    {$ENDIF}

    // Enumerations and Sets
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendEnum(const Msg: string; EnumTypeInfo: PTypeInfo;
      Value: Integer); overload;
    class procedure SendEnum(MsgType: Integer; const Msg: string;
      EnumTypeInfo: PTypeInfo; Value: Integer); overload;

    class procedure SendSet(const Msg: string; Info: PTypeInfo; const Value); overload;
    class procedure SendSet(MsgType: Integer; const Msg: string;
      Info: PTypeInfo; const Value); overload;
    {$ENDIF}

    // Objects and Properties
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendProperty(const Msg: string; Obj: TObject;
      const PropName: string); overload;
    class procedure SendProperty(MsgType: Integer; const Msg: string;
      Obj: TObject; const PropName: string); overload;
    class procedure SendComponentAsText(const Msg: string; Obj: TComponent);
    {$ENDIF}

    // Win32
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendKey(const Msg: string; Key: Word; Shift: TShiftState);
      overload;
    class procedure SendKey(MsgType: Integer; const Msg: string;
      Key: Word; Shift: TShiftState); overload;
    class procedure SendMouseButton(const Msg: string; Button: TMouseButton;
      Shift: TShiftState); overload;
    class procedure SendMouseButton(MsgType: Integer; const Msg: string;
      Button: TMouseButton; Shift: TShiftState); overload;

    class procedure SendMemoryManagerStatus(MsgType: Integer);
    class procedure SendHeapStatus(MsgType: Integer);
    class procedure SendMemoryStatus(MsgType: Integer);

    class procedure SendRegistry(const Key: string; ProcessSubKeys: Boolean = False);
      overload;
    class procedure SendRegistry(MsgType: Integer; const Key: string;
      ProcessSubKeys: Boolean = False); overload;
    class procedure SendRegistry(RootKey: HKey; const Key: string;
      ProcessSubKeys: Boolean = False); overload;
    class procedure SendRegistry(MsgType: Integer; RootKey: HKey;
      const Key: string; ProcessSubKeys: Boolean = False); overload;

    class procedure SendVersionInfo(MsgType: Integer);
    class procedure SendFileVersionInfo(const FileName: string); overload;
    class procedure SendFileVersionInfo(MsgType: Integer;
      const FileName: string); overload;
    class procedure SendWinError(const Msg: string; LastError: LongWord); overload;
    class procedure SendSystemInfo(MsgType: Integer);

    class procedure SendWindowHandle(const Msg: string; Wnd: Cardinal); overload;
    class procedure SendWindowHandle(MsgType: Integer; const Msg: string;
      Wnd: Cardinal); overload;
    {$ENDIF}

    // Pointers
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendPointer(const Msg: string; Value: Pointer); overload;
    class procedure SendPointer(MsgType: Integer; const Msg: string;
      Value: Pointer); overload;
    {$ENDIF}

    // Variants
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendVariant(const Msg: string; Value: Variant); overload;
    class procedure SendVariant(MsgType: Integer; const Msg: string;
      Value: Variant); overload;
    {$ENDIF}

    // Files, Memory, and Streams
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendTextFile(const Msg, FileName: string); overload;
    class procedure SendTextFile(MsgType: Integer; const Msg, FileName: string);
      overload;

    class procedure SendMemoryAsHex(const Msg: string; Buffer: Pointer;
      Size: Integer); overload;
    class procedure SendMemoryAsHex(MsgType: Integer; const Msg: string;
      Buffer: Pointer; Size: Integer); overload;

    class procedure SendStreamAsText(const Msg: string; Stream: TStream); overload;
    class procedure SendStreamAsText(MsgType: Integer; const Msg: string;
      Stream: TStream); overload;

    class procedure SendStreamAsHex(const Msg: string; Stream: TStream); overload;
    class procedure SendStreamAsHex(MsgType: Integer; const Msg: string;
      Stream: TStream); overload;

    class procedure SendFileAsHex(const Msg: string; const FileName: string); overload;
    class procedure SendFileAsHex(MsgType: Integer; const Msg: string;
      const FileName: string); overload;
    {$ENDIF}

    // Xml Data
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendXmlFile(const Msg, FileName: string); overload;
    class procedure SendXmlFile(MsgType: Integer; const Msg, FileName: string);
      overload;

    class procedure SendXmlData(const Msg: string; XmlData: TStrings); overload;
    class procedure SendXmlData(MsgType: Integer; const Msg: string;
      XmlData: TStrings); overload;
    class procedure SendXmlData(const Msg, XmlData: string); overload;
    class procedure SendXmlData(MsgType: Integer; const Msg, XmlData: string);
      overload;
    {$ENDIF}

    // Parents, Controls, Components
    {$IFNDEF CODESITE_EXPRESS}
    //class procedure SendControls( const Msg: string; Control: TControl ); overload;
    //class procedure SendControls( MsgType: Integer; const Msg: string; Control: TControl ); overload;

    class procedure SendComponents(const Msg: string; Component: TComponent); overload;
    class procedure SendComponents(MsgType: Integer; const Msg: string;
      Component: TComponent); overload;

    //class procedure SendParents( const Msg: string; Control: TControl ); overload;
    //class procedure SendParents( MsgType: Integer; const Msg: string; Control: TControl ); overload;
    {$ENDIF}

    // Method Tracing
    class procedure EnterMethod(const MethodName: string); overload; virtual;
    class procedure EnterMethod(Obj: TObject; const MethodName: string);
      overload; virtual;

    class procedure ExitMethod(const MethodName: string); overload; virtual;
    class procedure ExitMethod(Obj: TObject; const MethodName: string);
      overload; virtual;
    class procedure ExitMethod(Obj: TObject; const MethodName: string;
      Result: Variant); overload; virtual;

    {$IFNDEF CODESITE_EXPRESS}
    class procedure ExitMethodCollapse(const MethodName: string); overload; virtual;
    class procedure ExitMethodCollapse(Obj: TObject; const MethodName: string);
      overload; virtual;
    class procedure ExitMethodCollapse(Obj: TObject; const MethodName: string;
      Result: Variant); overload; virtual;

    {
    class function TraceMethod( const MethodName: string; Option: TCodeSiteTraceMethodOption = tmoTraceOnly;
                          TimingFormat: TCodeSiteTimingFormat = tfMilliseconds ): ICodeSiteMethodTracer; overload;
    class function TraceMethod( Obj: TObject; const MethodName: string; Option: TCodeSiteTraceMethodOption = tmoTraceOnly;
                          TimingFormat: TCodeSiteTimingFormat = tfMilliseconds ): ICodeSiteMethodTracer; overload;

    class function TraceMethodCollapse( const MethodName: string; Option: TCodeSiteTraceMethodOption = tmoTraceOnly;
                                  TimingFormat: TCodeSiteTimingFormat = tfMilliseconds ): ICodeSiteMethodTracer; overload;
    class function TraceMethodCollapse( Obj: TObject; const MethodName: string; Option: TCodeSiteTraceMethodOption = tmoTraceOnly;
                                  TimingFormat: TCodeSiteTimingFormat = tfMilliseconds ): ICodeSiteMethodTracer; overload;
    }
    {$ENDIF}

    // Custom Data
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendCustomData(MsgContent: Integer; const Msg: string;
      var Data); overload;
    class procedure SendCustomData(MsgType, MsgContent: Integer;
      const Msg: string; var Data); overload;
    //class procedure SendCustomData( const Msg: string; CustomData: ICodeSiteCustomData ); overload;
    //class procedure SendCustomData( MsgType: Integer; const Msg: string; CustomData: ICodeSiteCustomData ); overload;
    //class procedure Send( const Msg: string; CustomData: ICodeSiteCustomData ); overload;
    //class procedure Send( MsgType: Integer; const Msg: string; CustomData: ICodeSiteCustomData ); overload;
    {$ENDIF}

    // Assertions and Exceptions
    class procedure Assert(Expression: Boolean; const Msg: string);
    class procedure ExceptionHandler(Sender: TObject; E: Exception);
    class procedure SendException(E: Exception); overload;
    class procedure SendException(const Msg: string; E: Exception); overload;

    // SendIf Methods
    {$IFNDEF CODESITE_EXPRESS}
    class procedure SendIf(Expression: Boolean; const Msg: string); overload;
    class procedure SendIf(Expression: Boolean; const Fmt: string;
      const Args: array of const); overload;
    class procedure SendIf(Expression: Boolean; const Msg: string;
      const Value: string); overload;
    class procedure SendIf(Expression: Boolean; const Msg: string;
      Value: Integer); overload;
    class procedure SendIf(Expression: Boolean; const Msg: string;
      List: TStrings); overload;
    class procedure SendIf(Expression: Boolean; const Msg: string;
      const Obj: TObject); overload;
    class procedure SendDateTimeIf(Expression: Boolean; const Msg: string;
      Value: TDateTime; const Fmt: string = ''); overload;

    class procedure SendIf(Expression: Boolean; MsgType: Integer;
      const Msg: string); overload;
    class procedure SendIf(Expression: Boolean; MsgType: Integer;
      const Fmt: string; const Args: array of const); overload;
    class procedure SendIf(Expression: Boolean; MsgType: Integer;
      const Msg: string; const Value: string); overload;
    class procedure SendIf(Expression: Boolean; MsgType: Integer;
      const Msg: string; Value: Integer); overload;
    class procedure SendIf(Expression: Boolean; MsgType: Integer;
      const Msg: string; List: TStrings); overload;
    class procedure SendIf(Expression: Boolean; MsgType: Integer;
      const Msg: string; const Obj: TObject); overload;
    class procedure SendDateTimeIf(Expression: Boolean; MsgType: Integer;
      const Msg: string; Value: TDateTime; const Fmt: string = ''); overload;
    {$ENDIF}

    // Check Points and Separators
    class procedure AddCheckPoint;
    class procedure ResetCheckPoint;
    class procedure AddSeparator;
    class procedure AddResetSeparator;

    // Scratch Pad Methods
    {$IFNDEF CODESITE_EXPRESS}
    class procedure Write(const LineID: string; const Value: string); overload;
    class procedure Write(const LineID: string; const Msg: string;
      const Value: string); overload;
    class procedure Write(const LineID: string; const Fmt: string;
      const Args: array of const); overload;

    class procedure Write(const LineID: string; const Msg: string;
      Value: Integer); overload;
    class procedure Write(const LineID: string; Value: Integer); overload;

    class procedure Write(const LineID: string; const Msg: string;
      Value: LongWord; AsHex: Boolean = False); overload;
    class procedure Write(const LineID: string; Value: LongWord;
      AsHex: Boolean = False); overload;

    class procedure Write(const LineID: string; const Msg: string;
      Value: Int64); overload;
    class procedure Write(const LineID: string; Value: Int64); overload;
    class procedure Write(const LineID: string; const Msg: string;
      Value: Extended; Precision: Integer = 2); overload;
    class procedure Write(const LineID: string; Value: Extended;
      Precision: Integer = 2); overload;

    class procedure Write(const LineID: string; const Msg: string;
      Value: Boolean); overload;
    class procedure Write(const LineID: string; Value: Boolean); overload;

    class procedure WriteColor(const LineID: string; const Msg: string;
      Value: TColor); overload;
    class procedure WriteColor(const LineID: string; Value: TColor); overload;

    class procedure WriteCurrency(const LineID: string; const Msg: string;
      Value: Currency); overload;
    class procedure WriteCurrency(const LineID: string; Value: Currency); overload;

    class procedure WriteDateTime(const LineID: string; const Msg: string;
      Value: TDateTime; const Fmt: string = ''); overload;
    class procedure WriteDateTime(const LineID: string; Value: TDateTime;
      const Fmt: string = ''); overload;

    class procedure Write(const LineID: string; const Msg: string;
      Value: TPoint); overload;
    class procedure Write(const LineID: string; Value: TPoint); overload;

    class procedure Write(const LineID: string; const Msg: string;
      Value: TSmallPoint); overload;
    class procedure Write(const LineID: string; Value: TSmallPoint); overload;

    class procedure Write(const LineID: string; const Msg: string;
      Value: TRect); overload;
    class procedure Write(const LineID: string; Value: TRect); overload;
    {$ENDIF}

    // Event Log Methods
    {$IFNDEF CODESITE_EXPRESS}
    class procedure LogEvent(const Msg: string; EventID: Cardinal = 0;
      Category: Word = 0);
    class procedure LogWarning(const Msg: string; EventID: Cardinal = 0;
      Category: Word = 0);
    class procedure LogError(const Msg: string; EventID: Cardinal = 0;
      Category: Word = 0);
    {$ENDIF}
    *)
  end;


  // Easy access classes
  GsLogger = class(TAbstractGsLogger);
  GsAppLogger = class(GsLogger);
  GsLibLogger = class(GsLogger);
  GsPkgLogger = class(GsLibLogger);


  // Compatibility for BPLogging
  {$IFDEF RFC5424_TYPES}
  TBPLogType  = TGsSyslogMessageSeverity;
  {$ELSE}
  TBPLogType  = (ltMethod, ltInfo, ltError, ltDebug, ltComponent, ltAll);
  {$ENDIF}
  TBPLogTypes = set of TBPLogType;

function BP_CodeSite(AType: TBPLogType = ltDebug): TGsLoggerClass;
function BPC_CodeSite(AType: TBPLogType = ltDebug): TGsLoggerClass;

implementation

function BP_CodeSite(AType: TBPLogType = ltDebug): TGsLoggerClass;
begin
  Result := GsAppLogger;
end;

function BPC_CodeSite(AType: TBPLogType = ltDebug): TGsLoggerClass;
begin
  Result := GsPkgLogger;
end;

{ TAbstractGsDispatcher }

constructor TAbstractGsDispatcher.Create;
begin
  TAbstractGsLogger.RegisterDispatcher(Self);

  inherited Create;
end;

destructor TAbstractGsDispatcher.Destroy;
begin
  inherited;

  TAbstractGsLogger.RemoveDispatcher(Self);
end;

procedure TAbstractGsDispatcher.Send(const Msg: string);
begin

end;

{ TAbstractGsLogger }

var
  LDispatcher: TList = nil;
  LDisabled: Boolean = False;

class procedure TAbstractGsLogger.Disable;
begin
  LDisabled := True;
end;

class procedure TAbstractGsLogger.Enable;
begin
  LDisabled := False;
end;

class function TAbstractGsLogger.Enabled: Boolean;
begin
  Result := not LDisabled;
end;

class procedure TAbstractGsLogger.RegisterDispatcher(
  ADispatcher: TAbstractGsDispatcher);
begin
  if (LDispatcher = nil) then
    LDispatcher := TList.Create;

  if (LDispatcher.IndexOf(Pointer(ADispatcher)) = -1) then
    LDispatcher.Add(Pointer(ADispatcher));
end;

class procedure TAbstractGsLogger.RemoveDispatcher(
  ADispatcher: TAbstractGsDispatcher);
begin
  LDispatcher.Remove(Pointer(ADispatcher));

  if (LDispatcher.Count = 0) then
    FreeAndNil(LDispatcher);
end;

class procedure TAbstractGsLogger.Send(const Msg: string);
var
  I: Integer;
begin
  if not LDisabled then
    for I := 0 to LDispatcher.Count - 1 do
      TAbstractGsDispatcher(LDispatcher.Items[I]).Send(Msg);
end;

end.

