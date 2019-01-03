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
unit GsDevices;

{$I gsdl.inc}
{$I windowsonly.inc}

interface

uses
  Messages, Windows, Classes;

type
  TGSDeviceChangeEvent = procedure(ASender: TObject; var AMessage: TMessage) of object;

  TGSDeviceChangeHandler = class(TObject)
  private
    FActive: Boolean;
    FWindowReceiver: HWND;
    FNotifyList: TList;
  protected
    procedure DeleteItem(AItemIndex: Integer);
    procedure WndProc(var AMessage: TMessage);
    procedure BroadcastToList(var AMessage: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(AToNotify: TGSDeviceChangeEvent);
    procedure Remove(AToNotify: TGSDeviceChangeEvent);
    property Active: Boolean read FActive write FActive;
  end;

procedure GSDeviceChangeHandlerAddNotify(AToNotify: TGSDeviceChangeEvent);
procedure GSDeviceChangeHandlerRemoveNotify(AToNotify: TGSDeviceChangeEvent);
procedure GSDeviceChangeHandlerActivate;
procedure GSDeviceChangeHandlerDeactivate;

//function GSDeviceChangeHandler: TGSDeviceChangeHandler;

implementation

uses
  SysUtils;

var
  lDeviceChangeHandler: TGSDeviceChangeHandler;
  lFinalized: Boolean;

function GSDeviceChangeHandler: TGSDeviceChangeHandler;
begin
  if not Assigned(lDeviceChangeHandler) then
    lDeviceChangeHandler := TGSDeviceChangeHandler.Create;

  Result := lDeviceChangeHandler;
end;

procedure GSDeviceChangeHandlerAddNotify(AToNotify: TGSDeviceChangeEvent);
begin
  if not lFinalized then
    GSDeviceChangeHandler.Add(AToNotify);
end;

procedure GSDeviceChangeHandlerRemoveNotify(AToNotify: TGSDeviceChangeEvent);
begin
  if not lFinalized then
    GSDeviceChangeHandler.Remove(AToNotify);
end;

procedure GSDeviceChangeHandlerActivate;
begin
  if not lFinalized then
    GSDeviceChangeHandler.Active := True;
end;

procedure GSDeviceChangeHandlerDeactivate;
begin
  if not lFinalized then
    GSDeviceChangeHandler.Active := False;
end;

{ TGSDeviceChangeHandler }

type
  PMethod = ^TMethod;

const
  AM_DEFERRED_UPDATE = WM_USER + 100;

procedure TGSDeviceChangeHandler.Add(AToNotify: TGSDeviceChangeEvent);
var
  MethodData: PMethod;
begin
  New(MethodData);
  MethodData^ := TMethod(AToNotify);
  FNotifyList.Add(MethodData);
end;

procedure TGSDeviceChangeHandler.BroadcastToList(var AMessage: TMessage);
var
  MethodData: PMethod;
  Index: Integer;
begin
  if not Active then
    Exit;

  for Index := 0 to FNotifyList.Count - 1 do
  begin
    MethodData := PMethod(FNotifyList[Index]);

    try
      TGSDeviceChangeEvent(MethodData^)(Self, AMessage);
    except
      if Assigned(Classes.ApplicationHandleException) then
        Classes.ApplicationHandleException(ExceptObject)
      else
        ShowException(ExceptObject, ExceptAddr);
    end;
  end;
end;

constructor TGSDeviceChangeHandler.Create;
begin
  inherited Create;

  FNotifyList := TList.Create;
  FWindowReceiver := Classes.AllocateHWnd(WndProc);
  Active := True;
end;

procedure TGSDeviceChangeHandler.DeleteItem(AItemIndex: Integer);
begin
  Dispose(PMethod(FNotifyList[AItemIndex]));
  FNotifyList.Delete(AItemIndex);
end;

destructor TGSDeviceChangeHandler.Destroy;
begin
  Active := False;
  Classes.DeallocateHWnd(FWindowReceiver);
  FNotifyList.Free;

  inherited;
end;

procedure TGSDeviceChangeHandler.Remove(AToNotify: TGSDeviceChangeEvent);
var
  Index: Integer;
  ThisItem: PMethod;
begin
  for Index := 0 to FNotifyList.Count - 1 do
  begin
    ThisItem := PMethod(FNotifyList[Index]);

    if (ThisItem.Code = TMethod(AToNotify).Code) and (ThisItem.Data = TMethod(AToNotify).Data) then
    begin
      DeleteItem(Index);
      Exit;
    end;
  end;
end;

procedure TGSDeviceChangeHandler.WndProc(var AMessage: TMessage);
begin
  case AMessage.Msg of
    WM_DEVICECHANGE: begin
      PostMessage(FWindowReceiver, AM_DEFERRED_UPDATE, AMessage.WParam, AMessage.LParam);
      AMessage.Result := DefWindowProc(FWindowReceiver, AMessage.Msg, AMessage.WParam, AMessage.LParam);
    end;
    AM_DEFERRED_UPDATE:
      BroadcastToList(AMessage);
  else
    AMessage.Result := DefWindowProc(FWindowReceiver, AMessage.Msg, AMessage.WParam, AMessage.LParam);
  end;
end;

initialization
finalization
  try
    lDeviceChangeHandler.Free;
    lDeviceChangeHandler := nil;
    lFinalized := True;
  except
    lDeviceChangeHandler := nil;
    lFinalized := True;
  end;
end.
