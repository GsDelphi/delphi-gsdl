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
unit GsClasses;

interface

uses
  Classes,
  GsTypes;

type
  { Standard events }
  TGsNotifyEvent = TNotifyEvent;
  TGsGetStrProc = TGetStrProc;
  TGsProgressEvent = procedure(Sender: TObject;
    TotalParts, PartsComplete: Integer; var Continue: Boolean;
    const Msg: string) of object;

  TGsPersistent = class(TPersistent);

  TGsComponent = class(TComponent)
  private
    FAboutInfo: TGsAboutInfo;
  published
    property About: TGsAboutInfo read FAboutInfo write FAboutInfo stored False;
  end;

  TGsThread = class(TThread)
  private
    FAboutInfo: TGsAboutInfo;
  protected
    procedure Execute; override; deprecated;
    procedure ExecuteNew; virtual; abstract;
  public
    class function Name: String; virtual;
    function WaitForInISAPI: LongWord;
  end;

implementation

uses
  GSIDEUtils,
  Windows;

{ TGsThread }

procedure TGsThread.Execute;
begin
{$IFDEF USE_CODESITE} if (BPC_CodeSite <> nil) then
    BPC_CodeSite.EnterMethod(Self, 'Execute'); {$ENDIF}
  SetThreadName(Name);

  ExecuteNew;

{$IFDEF USE_CODESITE} if (BPC_CodeSite <> nil) then
    BPC_CodeSite.ExitMethod(Self, 'Execute'); {$ENDIF}
end;

class function TGsThread.Name: String;
begin
  Result := ClassName;
end;

function TGsThread.WaitForInISAPI: LongWord;
begin
  MainThreadID := GetCurrentThreadID;
  Result := WaitFor;
end;

end.
