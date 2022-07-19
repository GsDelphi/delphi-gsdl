{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2017-2019 Simon Gilli
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
unit GsComObj;

{$I gsdl.inc}
{$I windowsonly.inc}

interface

procedure InitializeCOM;
procedure FinalizeCOM;

procedure InitializeComObj;
procedure FinalizeComObj;

procedure CreateMessageQueue;
procedure ProcessMessages;

implementation

uses
  ActiveX,
  ComObj,
  Messages,
  Windows;

threadvar
  InitComObjCalled:   Boolean;
  NeedToUninitialize: Boolean;

procedure InitializeCOM;
var
  Res: HRESULT;
begin
  if InitComObjCalled then
    Exit;

  if (CoInitFlags <> -1) and Assigned(ComObj.CoInitializeEx) then
  begin
    Res           := ComObj.CoInitializeEx(nil, CoInitFlags);
    IsMultiThread := IsMultiThread or ((CoInitFlags and COINIT_APARTMENTTHREADED) <> 0) or
      (CoInitFlags = COINIT_MULTITHREADED);  // this flag has value zero
  end
  else
    Res := CoInitialize(nil);

  if Res = RPC_E_CHANGED_MODE then
    Res := CoInitialize(nil);

  NeedToUninitialize := Succeeded(Res) or NeedToUninitialize;

  (*
  if not NeedToUninitialize then
    EpmService.LogMessage(SysErrorMessage(Res), msWarning);
  *)

  InitComObjCalled := True;
end;

procedure FinalizeCOM;
begin
  if NeedToUninitialize then
  begin
    CoUninitialize;
    NeedToUninitialize := False;
    InitComObjCalled   := False;
  end;
end;

procedure InitializeComObj;
begin
  InitializeCOM;
end;

procedure FinalizeComObj;
begin
  FinalizeCOM;
end;

procedure CreateMessageQueue;
var
  Msg: TMsg;
begin
  PeekMessage(Msg, 0, WM_USER, WM_USER, PM_NOREMOVE);
end;

procedure ProcessMessages;
var
  Msg: TMsg;
begin
  while PeekMessage(msg, 0, 0, 0, PM_REMOVE) do
    DispatchMessage(msg);
end;

end.

