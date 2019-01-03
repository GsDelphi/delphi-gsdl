{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2018 Simon Gilli
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
unit GsEventManager;

{<

  @abstract(Gilbertsoft System Utilities)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains low level system routines.
}

{$I Gilbertsoft.inc}

interface

uses
  GSEventManagerIntf,
  Classes;

type
  TGSEvent = class(TInterfacedObject, IGSEventInterface)
  private
    FTarget: TObject;
    FIsPropagationStopped: Boolean;
  protected
    function GetName: String; virtual; abstract;
    function GetTarget: TObject; virtual;
  public
    constructor Create(ATarget: TObject); virtual;
    destructor Destroy; override;

    procedure StopPropagation(Flag: Boolean);
    function IsPropagationStopped: Boolean;

    property Name: String read GetName {write SetName};
    property Target: TObject read GetTarget {write SetTarget};
  end;

  TListener = record
    Event: TGUID;
    Callback1: TGSEventManagerCallback;
    Callback2: TGSEventManagerObjectCallback;
    Priority: Integer;
  end;

  TGSEventListeners = class(TList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    function GetItem(Index: Integer): TListener;
    procedure SetItem(Index: Integer; AListener: TListener);
  public
//    constructor Create;

    function Add(AListener: TListener): Integer;
    function Extract(Item: TListener): TListener;
    function Remove(AListener: TListener): Integer;
    function IndexOf(AListener: TListener): Integer;
//    function FindInstanceOf(AClass: TClass; AExact: Boolean = True; AStartAt: Integer = 0): Integer;
    procedure Insert(Index: Integer; AListener: TListener);
    function First: TListener;
    function Last: TListener;
    property Items[Index: Integer]: TListener read GetItem write SetItem; default;
  end;

  TGSEventManager = class(TInterfacedObject, IGSEventManagerInterface)
  private
    FListeners: TList;
  protected
  public
    constructor Create; virtual;

    { @seealso(IGSEventManagerInterface.@name) }
    function Attach(const AEvent: TGUID; ACallback: TGSEventManagerCallback; APriority: Integer = 0): Boolean; overload;

    { @seealso(IGSEventManagerInterface.@name) }
    function Attach(const AEvent: TGUID; ACallback: TGSEventManagerObjectCallback; APriority: Integer = 0): Boolean; overload;

    { @seealso(IGSEventManagerInterface.@name) }
    function Detach(const AEvent: TGUID; ACallback: TGSEventManagerCallback): Boolean; overload;

    { @seealso(IGSEventManagerInterface.@name) }
    function Detach(const AEvent: TGUID; ACallback: TGSEventManagerObjectCallback): Boolean; overload;

    { @seealso(IGSEventManagerInterface.@name) }
    procedure ClearListeners(const AEvent: TGUID);

    { @seealso(IGSEventManagerInterface.@name) }
    function Trigger(AEvent: TObject): Boolean;
  end;

implementation

{ TGSEvent }

constructor TGSEvent.Create(ATarget: TObject);
begin
  FTarget := ATarget;

  inherited Create;
end;

destructor TGSEvent.Destroy;
begin
  inherited;

  FTarget := nil;
end;

function TGSEvent.GetTarget: TObject;
begin
  Result := FTarget;
end;

function TGSEvent.IsPropagationStopped: Boolean;
begin
  Result := FIsPropagationStopped;
end;

procedure TGSEvent.StopPropagation(Flag: Boolean);
begin
  FIsPropagationStopped := Flag;
end;

{ TGSEventListeners }

function TGSEventListeners.Add(AListener: TListener): Integer;
var
  Listener: ^TListener;
begin
  New(Listener);
  Listener^ := AListener;
  Result := inherited Add(Listener);
end;

function TGSEventListeners.Extract(Item: TListener): TListener;
begin
//  Result := TListener(inherited Extract(Item));
end;

function TGSEventListeners.First: TListener;
begin

end;

function TGSEventListeners.GetItem(Index: Integer): TListener;
begin

end;

function TGSEventListeners.IndexOf(AListener: TListener): Integer;
begin

end;

procedure TGSEventListeners.Insert(Index: Integer; AListener: TListener);
begin

end;

function TGSEventListeners.Last: TListener;
begin

end;

procedure TGSEventListeners.Notify(Ptr: Pointer;
  Action: TListNotification);
begin
  if Action = lnDeleted then
    Dispose(Ptr);

  inherited Notify(Ptr, Action);
end;

function TGSEventListeners.Remove(AListener: TListener): Integer;
begin

end;

procedure TGSEventListeners.SetItem(Index: Integer; AListener: TListener);
begin

end;

{ TGSEventManager }

function ListenersSortCompare(Item1, Item2: Pointer): Integer;
begin
end;

function TGSEventManager.Attach(const AEvent: TGUID;
  ACallback: TGSEventManagerCallback; APriority: Integer): Boolean;
var
  Listener: ^TListener;
begin
  New(Listener);
  Listener^.Event := AEvent;
  Listener^.Callback1 := ACallback;
  Listener^.Priority := APriority;

  FListeners.Add(Listener);
  FListeners.Sort(ListenersSortCompare);
end;

function TGSEventManager.Attach(const AEvent: TGUID;
  ACallback: TGSEventManagerObjectCallback; APriority: Integer): Boolean;
begin

end;

procedure TGSEventManager.ClearListeners(const AEvent: TGUID);
begin

end;

constructor TGSEventManager.Create;
begin
  inherited Create;

  FListeners := TList.Create;
end;

function TGSEventManager.Detach(const AEvent: TGUID;
  ACallback: TGSEventManagerObjectCallback): Boolean;
begin
end;

function TGSEventManager.Detach(const AEvent: TGUID;
  ACallback: TGSEventManagerCallback): Boolean;
begin

end;

function TGSEventManager.Trigger(AEvent: TObject): Boolean;
begin

end;

end.
