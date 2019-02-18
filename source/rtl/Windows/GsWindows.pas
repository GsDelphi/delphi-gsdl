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
unit GsWindows;

interface

uses
  Windows;

function GetComputerName: string; overload;
function GetComputerNameEx(AFormat: TComputerNameFormat): string; overload
function GetUserName: string;

function IsDebuggerPresent: BOOL; stdcall;

implementation

uses
  SysUtils;

var
  LComputerName: array [TComputerNameFormat] of string;
  LUserName: string;

function GetComputerName: string;
begin
  Result := GetComputerNameEx(ComputerNameNetBIOS);
end;

function GetComputerNameEx(AFormat: TComputerNameFormat): string;
var
  Size: DWORD;
begin
  if (LComputerName[AFormat] = '') then
  begin
    Windows.GetComputerNameEx(AFormat, nil, Size);

    SetLength(LComputerName[AFormat], Size);

    if not Windows.GetComputerNameEx(AFormat,
      @LComputerName[AFormat][1], Size) then
      LComputerName[AFormat] := ''
    else
      LComputerName[AFormat] := Trim(LComputerName[AFormat]);
  end;

  Result := LComputerName[AFormat];
end;

function GetUserName: string;
var
  Size: DWORD;
begin
  if (LUserName = '') then
  begin
    Windows.GetUserName(nil, Size);

    SetLength(LUserName, Size);

    if not Windows.GetUserName(@LUserName[1], Size) then
      LUserName := ''
    else
      LUserName := Trim(LUserName);
  end;

  Result := LUserName;
end;

function IsDebuggerPresent; external kernel32 name 'IsDebuggerPresent';

initialization
{ do not use *_CodeSite.E*Initialization() }
finalization
{ do not use *_CodeSite.E*Finalization() }
end.

