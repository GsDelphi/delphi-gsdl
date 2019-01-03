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
  @abstract(Gilbertsoft COM Database)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains system constants and resourcestrings.
}
unit GsComDB;

{$I gsdl.inc}
{$I windowsonly.inc}
{$R-,T-,H+,X+}

interface

uses
  SysUtils, MSPORTS, SyncObjs, Messages, GSClasses;

type
  { exceptions }
  EGSComDBError = class(Exception);



  { user types }
	TGSComPort = 1..COMDB_MAX_PORTS_ARBITRATED;

  TGSComPortStatus = array [TGSComPort] of Boolean;

  TGSComPortProperties = record
    case IsFTDI: Boolean of
      True: (VendorID: String[20];
             ProductID: String[20];
             Serial: String[20]);
      False: ();
  end;

  TGSComPortPropertiesList = array [TGSComPort] of TGSComPortProperties;

  { com database }
  TAbstractGSComDatabase = class(TObject)
  protected
    function GetPortAccessible(APort: TGSComPort): Boolean; virtual; abstract;
    function GetPortAvailable(APort: TGSComPort): Boolean; virtual; abstract;
    function GetPortProperties(APort: TGSComPort): TGSComPortProperties; virtual; abstract;
    function GetUpdateTerminatedEvent: TSimpleEvent; virtual; abstract;
    function GetUpdatingPorts: Boolean; virtual; abstract;
    procedure DoUpdate; virtual; abstract;
  public
    procedure Update;

    property PortAvailable[APort: TGSComPort]: Boolean read GetPortAvailable;
    property PortAccessible[APort: TGSComPort]: Boolean read GetPortAccessible;
    property PortProperties[APort: TGSComPort]: TGSComPortProperties read GetPortProperties;

    property UpdatingPorts: Boolean read GetUpdatingPorts;
    property UpdateTerminatedEvent: TSimpleEvent read GetUpdateTerminatedEvent;
  end;

  TCustomGSComDatabase = class(TAbstractGSComDatabase)
  protected
    function GetPortAccessible(APort: TGSComPort): Boolean; override;
    function GetPortAvailable(APort: TGSComPort): Boolean; override;
    function GetPortProperties(APort: TGSComPort): TGSComPortProperties; override;
    function GetUpdateTerminatedEvent: TSimpleEvent; override;
    function GetUpdatingPorts: Boolean; override;
    procedure DoUpdate; override;
  end;

  TGSComDatabase = class(TCustomGSComDatabase)
  public
  end;

implementation

uses
  {$IFDEF USE_CODESITE}BPLogging,{$ENDIF}
  JwaWindows, devguid, Classes, GSDevices, Registry, GSIDEUtils,
  BPUtils, BPSystem;

type
  { forward class declarations }
  TGSComDatabaseUpdateThread = class;

  TGlobalGSComDatabase = class(TAbstractGSComDatabase)
  private
    FAvailablePorts: TGSComPortStatus;
    FPropertiesList: TGSComPortPropertiesList;
    FUpdateThread: TGSComDatabaseUpdateThread;
    FUpdateTerminatedEvent: TSimpleEvent;
  protected
    function GetPortAccessible(APort: TGSComPort): Boolean; override;
    function GetPortAvailable(APort: TGSComPort): Boolean; override;
    function GetPortProperties(APort: TGSComPort): TGSComPortProperties; override;
    function GetUpdateTerminatedEvent: TSimpleEvent; override;
    function GetUpdatingPorts: Boolean; override;

    procedure DeviceChangeEvent(ASender: TObject; var AMessage: TMessage);
    procedure DoUpdate; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TGSComDatabaseUpdateThread = class(TGSThread)
  private
    FOwner: TGlobalGSComDatabase;
    procedure DoUpdate;
    procedure RaiseLastOSError(CalledFunction: String);
  protected
		procedure ExecuteNew; override;
	public
		constructor Create(AOwner: TGlobalGSComDatabase);

    class function Name: String; override;
  end;

var
  lGlobalGSComDatabase: TGlobalGSComDatabase;

{ TGlobalGSComDatabase }

constructor TGlobalGSComDatabase.Create;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

  inherited;

  FUpdateThread := TGSComDatabaseUpdateThread.Create(Self);
  FUpdateTerminatedEvent := TSimpleEvent.Create;
  GSDeviceChangeHandlerAddNotify(DeviceChangeEvent);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

destructor TGlobalGSComDatabase.Destroy;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Destroy');{$ENDIF}

  GSDeviceChangeHandlerRemoveNotify(DeviceChangeEvent);
  FUpdateTerminatedEvent.Free;

  FUpdateThread.Terminate;

  while FUpdateThread.Suspended do
    FUpdateThread.Resume;

  FUpdateThread.Free;

  inherited;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Destroy');{$ENDIF}
end;

procedure TGlobalGSComDatabase.DeviceChangeEvent(ASender: TObject;
  var AMessage: TMessage);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DeviceChangeEvent');{$ENDIF}

  { TODO: try to get a more detailed info with RegisterDeviceNotification}
  if (AMessage.WParam = DBT_DEVNODES_CHANGED) then
  begin
    Update;
  end;

  {
  if (AMessage.WParam = DBT_DEVICEARRIVAL) or (AMessage.WParam = DBT_DEVICEREMOVECOMPLETE) then
  begin
    case DEV_BROADCAST_HDR(Pointer(AMessage.LParam)^).dbch_devicetype of
      (*
      DBT_DEVTYP_OEM: begin
        DEV_BROADCAST_OEM(Pointer(AMessage.LParam)^).dbco_devicetype
      end;
      DBT_DEVTYP_PORT: begin
        DEV_BROADCAST_PORT(Pointer(AMessage.LParam)^).dbco_devicetype
      end;
      *)
      DBT_DEVTYP_DEVICEINTERFACE: begin
        if IsEqualGUID(DEV_BROADCAST_DEVICEINTERFACE(Pointer(AMessage.LParam)^).dbcc_classguid, GUID_DEVCLASS_PORTS) then
          Update;
      end;
    end;
  end;
  }

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DeviceChangeEvent');{$ENDIF}
end;

procedure TGlobalGSComDatabase.DoUpdate;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoUpdate');{$ENDIF}

  FUpdateTerminatedEvent.ResetEvent;

  while FUpdateThread.Suspended do
    FUpdateThread.Resume;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoUpdate');{$ENDIF}
end;

function TGlobalGSComDatabase.GetPortAccessible(APort: TGSComPort): Boolean;
var
  PortHandle: THandle;
  Error: DWORD;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetPortAccessible');{$ENDIF}

  Result := False;

  if PortAvailable[APort] or (APort < 20) then
  begin
    {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Testing port');{$ENDIF}
    {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Port', APort);{$ENDIF}

    try
      {$IFDEF SUPPORTS_UNICODE}
      PortHandle := CreateFile(PWideChar(Format('\\.\COM%d', [APort])), (GENERIC_READ or GENERIC_WRITE), 0, nil, OPEN_EXISTING, 0, 0);
      {$ELSE ~SUPPORTS_UNICODE}
      PortHandle := CreateFile(PAnsiChar(Format('\\.\COM%d', [APort])), (GENERIC_READ or GENERIC_WRITE), 0, nil, OPEN_EXISTING, 0, 0);
      {$ENDIF ~SUPPORTS_UNICODE}

      try
        if (PortHandle = INVALID_HANDLE_VALUE) then
          Error := GetLastError
        else
          Error := ERROR_SUCCESS;

        if (Error in [ERROR_SUCCESS, ERROR_ACCESS_DENIED]) then
        begin
          FAvailablePorts[APort] := True;
          Result := (Error = ERROR_SUCCESS);
        end
        else
        begin
          {$IFDEF USE_CODESITE}BPC_CodeSite.SendWinError('CreateFile', Error);{$ENDIF}
          Result := False;
        end;
      finally
        if (PortHandle <> INVALID_HANDLE_VALUE) then
          CloseHandle(PortHandle);
      end;
    finally
      {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Port available', FAvailablePorts[APort]);{$ENDIF}
      {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Port accessible', Result);{$ENDIF}
      {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Testing port');{$ENDIF}
    end;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetPortAccessible');{$ENDIF}
end;

function TGlobalGSComDatabase.GetPortAvailable(APort: TGSComPort): Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetPortAvailable');{$ENDIF}

  Result := FAvailablePorts[APort];

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetPortAvailable');{$ENDIF}
end;

function TGlobalGSComDatabase.GetPortProperties(
  APort: TGSComPort): TGSComPortProperties;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetPortProperties');{$ENDIF}

  Result := FPropertiesList[APort];

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetPortProperties');{$ENDIF}
end;

function TGlobalGSComDatabase.GetUpdateTerminatedEvent: TSimpleEvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetUpdateTerminatedEvent');{$ENDIF}

  Result := FUpdateTerminatedEvent;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetUpdateTerminatedEvent');{$ENDIF}
end;

function TGlobalGSComDatabase.GetUpdatingPorts: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetUpdating');{$ENDIF}

  Result := not FUpdateThread.Suspended;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetUpdating');{$ENDIF}
end;

{ TGSComDatabaseUpdateThread }

constructor TGSComDatabaseUpdateThread.Create(
  AOwner: TGlobalGSComDatabase);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

  inherited Create(True);

	Priority := tpLowest;
  FOwner := AOwner;

  Resume;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

procedure TGSComDatabaseUpdateThread.DoUpdate;
var
  ComDB: HCOMDB;
  Buf: PByte;
  BufSize: DWORD;
  DBError: LONG;
  Dummy: DWORD;
  P: TGSComPort;
  DevCount,
  lDev,
  i: Integer;
  DevList: TStrings;
  PName,
  DevStr: String;
  Reg: TRegistry;
  cPort: TGSComPort;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoUpdate');{$ENDIF}

  if (ComDBOpen(ComDB) = LONG(ERROR_SUCCESS)) then
  begin
    { get size of com db port usage }
    Buf := nil;

    DBError := ComDBGetCurrentPortUsage(ComDB, Buf^, 0, 0, BufSize);

    if (DBError <> LONG(ERROR_SUCCESS)) then
    begin
      if (DBError <> LONG(ERROR_NOT_CONNECTED)) then
        SetLastError(DBError);

      RaiseLastOSError('ComDBGetCurrentPortUsage');
    end;


    { get com db port usage }
    GetMem(Buf, BufSize);

    try

      DBError := ComDBGetCurrentPortUsage(ComDB, Buf^, BufSize, CDB_REPORT_BYTES, Dummy);

      if (DBError <> LONG(ERROR_SUCCESS)) then
      begin
        if (DBError <> LONG(ERROR_NOT_CONNECTED)) then
          SetLastError(DBError);

        RaiseLastOSError('ComDBGetCurrentPortUsage');
      end;

      for P := Low(P) to High(P) do
      begin
        FOwner.FAvailablePorts[P] := False;
        FOwner.FPropertiesList[P].IsFTDI := False;

        if (P <= BufSize) then
        begin
          FOwner.FAvailablePorts[P] := (PByteArray(Buf)^[P - 1] > 0);
        end;
      end;
    finally
      FreeMem(Buf);

      if (ComDBClose(ComDB) <> LONG(ERROR_SUCCESS)) then
        RaiseLastOSError('ComDBClose');
    end;
  end
  else
    RaiseLastOSError('ComDBOpen');


  { search ftdi chips }
  Reg := TRegistry.Create(KEY_READ);

  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    if Reg.OpenKeyReadOnly(REGSTR_PATH_SERVICES + '\FTSER2K\' + REGSTR_PATH_ENUM) then
    begin
      if Reg.ValueExists('Count') then
      begin
        DevList := TStringList.Create;

        try
          DevCount := Reg.ReadInteger('Count');

          for i := 0 to DevCount - 1 do
          begin
            if Reg.ValueExists(IntToStr(i)) then
              DevList.Add(Reg.ReadString(IntToStr(i)));
          end;

          for i := 0 to DevList.Count - 1 do
          begin
            Reg.CloseKey;

            if Reg.OpenKeyReadOnly(REGSTR_PATH_SYSTEMENUM + '\' +
                                   DevList.Strings[i] + '\' +
                                   REGSTR_KEY_DEVICEPARAMETERS) then
            begin
              if Reg.ValueExists(REGSTR_VAL_PORTNAME) then
              begin
                PName := Reg.ReadString(REGSTR_VAL_PORTNAME);
                {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Check port for FTDI', PName);{$ENDIF}

                if (Copy(PName, 1, 3) = 'COM') then
                begin
                  try
                    PName := Copy(PName, 4, Length(PName));
                    cPort := SysUtils.StrToInt(PName);

                    DevStr := GetStrEx(2, DevList.Strings[i], '\');
                    lDev := Length(DevStr);

                    FOwner.FPropertiesList[cPort].IsFTDI := True;
                    FOwner.FPropertiesList[cPort].VendorID := ShortString(Copy(GetStrEx(1, DevStr, '+'), 5, lDev));
                    FOwner.FPropertiesList[cPort].ProductID := ShortString(Copy(GetStrEx(2, DevStr, '+'), 5, lDev));
                    FOwner.FPropertiesList[cPort].Serial := ShortString(Copy(GetStrEx(3, DevStr, '+'), 1, 8));

                    {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Port is FTDI', FOwner.FPropertiesList[cPort].IsFTDI);{$ENDIF}
                  except
                  end;
                end;
              end;
            end;
          end;
        finally
          DevList.Free;
        end;
      end;
    end;
  finally
    Reg.Free;
  end;

{  // Create a HDEVINFO with all present devices.
  DeviceInfo := SetupDiGetClassDevs(nil,
      nil, // Enumerator
      0,
      DIGCF_PRESENT or DIGCF_ALLCLASSES );

  if (DWORD(DeviceInfo) = INVALID_HANDLE_VALUE) then
  begin
      // Insert error handling here.
      Exit;
  end;

  // Enumerate through all devices in Set.
  DeviceInfoData.cbSize := sizeof(SP_DEVINFO_DATA);
  i := 0;

  while (SetupDiEnumDeviceInfo(DeviceInfo, i, DeviceInfoData)) do
  begin
    buffer := nil;
    buffersize := 0;

    //
    // Call function with null to begin with,
    // then use the returned buffer size
    // to Alloc the buffer. Keep calling until
    // success or an unknown failure.
    //

    while not SetupDiGetDeviceRegistryProperty(
        DeviceInfo,
        DeviceInfoData,
        SPDRP_DEVICEDESC,
        @DataT,
        PBYTE(buffer),
        buffersize,
        @buffersize) do
    begin
      if (GetLastError() = ERROR_INSUFFICIENT_BUFFER) then
      begin
        // Change the buffer size.
        if Assigned(buffer) then
          LocalFree(HLOCAL(buffer));

        buffer := LPTSTR(LocalAlloc(LPTR, buffersize));
      end
      else
      begin
        // Insert error handling here.
        System.Break;
      end;
    end;

    printf("Device: %s\n",buffer);

    if (buffer) then
      LocalFree(buffer);

    Inc(i);
  end;

  if ( GetLastError()!=NO_ERROR &&
       GetLastError()!=ERROR_NO_MORE_ITEMS )
  begin
      // Insert error handling here.
      return 1;
  end;

  //  Cleanup
  SetupDiDestroyDeviceInfoList(DeviceInfo);

  return 0;}

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoUpdate');{$ENDIF}
end;

procedure TGSComDatabaseUpdateThread.ExecuteNew;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ExecuteNew');{$ENDIF}

  while not Terminated do
  begin
    if not Suspended then
    begin
      try
        try
          FOwner.UpdateTerminatedEvent.ResetEvent;
          DoUpdate;
        except
          on E: Exception do
            {$IFDEF USE_CODESITE}BPC_CodeSite.SendException(E);{$ENDIF}
        end;
      finally
        FOwner.UpdateTerminatedEvent.SetEvent;
        {$IFDEF USE_CODESITE}BPC_CodeSite.Send('Suspend Thread');{$ENDIF}
        Suspend;
      end;
    end;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ExecuteNew');{$ENDIF}
end;

class function TGSComDatabaseUpdateThread.Name: String;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('TGSComDatabaseUpdateThread.Name');{$ENDIF}

  Result := 'ComDatabaseUpdateThread';

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('TGSComDatabaseUpdateThread.Name');{$ENDIF}
end;

procedure TGSComDatabaseUpdateThread.RaiseLastOSError(
  CalledFunction: String);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'LogLastWinError');{$ENDIF}

  try
    {$IFDEF USE_CODESITE}BPC_CodeSite.AddCheckPoint;{$ENDIF}
    {$IFDEF USE_CODESITE}BPC_CodeSite.SendWinError(CalledFunction, GetLastError);{$ENDIF}
    {$IFDEF USE_CODESITE}BPC_CodeSite.AddSeparator;{$ENDIF}

    SysUtils.RaiseLastOSError;
  finally
    SetLastError(ERROR_SUCCESS);
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'LogLastWinError');{$ENDIF}
end;

{ TAbstractGSComDatabase }

procedure TAbstractGSComDatabase.Update;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Update');{$ENDIF}

  DoUpdate;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Update');{$ENDIF}
end;

{ TCustomGSComDatabase }

procedure TCustomGSComDatabase.DoUpdate;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'DoUpdate');{$ENDIF}

  lGlobalGSComDatabase.Update;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'DoUpdate');{$ENDIF}
end;

function TCustomGSComDatabase.GetPortAccessible(
  APort: TGSComPort): Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetPortAccessible');{$ENDIF}

  Result := lGlobalGSComDatabase.PortAccessible[APort];

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetPortAccessible');{$ENDIF}
end;

function TCustomGSComDatabase.GetPortAvailable(APort: TGSComPort): Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetPortAvailable');{$ENDIF}

  Result := lGlobalGSComDatabase.PortAvailable[APort];

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetPortAvailable');{$ENDIF}
end;

function TCustomGSComDatabase.GetPortProperties(
  APort: TGSComPort): TGSComPortProperties;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetPortProperties');{$ENDIF}

  Result := lGlobalGSComDatabase.PortProperties[APort];

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetPortProperties');{$ENDIF}
end;

function TCustomGSComDatabase.GetUpdateTerminatedEvent: TSimpleEvent;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetUpdateTerminatedEvent');{$ENDIF}

  Result := lGlobalGSComDatabase.UpdateTerminatedEvent;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetUpdateTerminatedEvent');{$ENDIF}
end;

function TCustomGSComDatabase.GetUpdatingPorts: Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetUpdatingPorts');{$ENDIF}

  Result := lGlobalGSComDatabase.UpdatingPorts;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetUpdatingPorts');{$ENDIF}
end;

initialization
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterInitialization('GSComDB');{$ENDIF}

  if not IsRunningAtIDE and not IsMsiLibrary then
    lGlobalGSComDatabase := TGlobalGSComDatabase.Create
  else
    lGlobalGSComDatabase := nil;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitInitialization('GSComDB');{$ENDIF}
finalization
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterFinalization('GSComDB');{$ENDIF}

  if Assigned(lGlobalGSComDatabase) then
    lGlobalGSComDatabase.Free;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitFinalization('GSComDB');{$ENDIF}
end.

