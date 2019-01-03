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
  @abstract(Gilbertsoft IDE Utillities)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2018-08-15)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains system constants and resourcestrings.
}

unit GsIdeUtils;

{$UNDEF USE_CODESITE}
{$I gsdl.inc}

interface

function IsIDEPresent: Boolean;
function IsRunningAtIDE: Boolean;
function IsDebuggerPresent: Boolean;

procedure LogIsIDEPresent(AMessage: String);
procedure LogIsRunningAtIDE(AMessage: String);
procedure LogIsDebuggerPresent(AMessage: String);

procedure SetThreadName(const AName: string);

implementation

uses
{$IFDEF USE_CODESITE}
  BPLogging,
{$ENDIF ~USE_CODESITE}
  Windows, GsWindows;

function IsIDEPresent: Boolean;
begin
  { search delphi ide }
  Result := FindWindowA('TAppBuilder', nil) <> 0;
end;

function IsRunningAtIDE: Boolean;
var
  ProcessID: DWORD;
begin
  GetWindowThreadProcessId(FindWindowA('TAppBuilder', nil), ProcessID);
  Result := GetCurrentProcessId = ProcessID;
end;

function IsDebuggerPresent: Boolean;
begin
  { search debugger }
  Result := GsWindows.IsDebuggerPresent;
  { the old way
  Result := (DebugHook <> 0);}
  (* .NET
  Result:=Debugger.IsAttached;
  *)
end;

procedure LogIsIDEPresent(AMessage: String);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.SendWarning('IDE present: %s', [AMessage]);{$ENDIF}
end;

procedure LogIsRunningAtIDE(AMessage: String);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.SendWarning('Running at IDE: %s', [AMessage]);{$ENDIF}
end;

procedure LogIsDebuggerPresent(AMessage: String);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.SendWarning('Debugger present: %s', [AMessage]);{$ENDIF}
end;

procedure SetThreadName(const AName: string);
{$IFDEF WIN32_OR_WIN64_OR_WINCE}
  {$IFDEF ALLOW_NAMED_THREADS}
const
  MS_VC_EXCEPTION = $406D1388;
type
  TThreadNameInfo = record
    RecType: LongWord;  // Must be 0x1000
    Name: PAnsiChar;    // Pointer to name (in user address space)
    ThreadID: LongWord; // Thread ID (-1 indicates caller thread)
    Flags: LongWord;    // Reserved for future use. Must be zero
  end;
var
  LThreadNameInfo: TThreadNameInfo;
    {$IFDEF UNICODESTRING}
  LName: AnsiString;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
begin
{$IFDEF ALLOW_NAMED_THREADS}
  {$IFDEF DOTNET}
  // cannot rename a previously-named thread
  if System.Threading.Thread.CurrentThread.Name = nil then begin
    System.Threading.Thread.CurrentThread.Name := AName;
  end;
  {$ENDIF}

  {$IFDEF WIN32_OR_WIN64_OR_WINCE}
    {$IFDEF UNICODESTRING}
  LName := AnsiString(AName); // explicit convert to Ansi
    {$ENDIF}

  with LThreadNameInfo do begin
    RecType := $1000;
    {$IFDEF UNICODESTRING}
    Name := PAnsiChar(LName);
    {$ELSE}
    Name := PChar(AName);
    {$ENDIF}
    ThreadID := $FFFFFFFF;
    Flags := 0;
  end;
  try
    // This is a wierdo Windows way to pass the info in
    RaiseException(MS_VC_EXCEPTION, 0, SizeOf(LThreadNameInfo) div SizeOf(LongWord),
      PDWord(@LThreadNameInfo));
  except
  end;
  {$ENDIF}
  // Do nothing. No support in this compiler for it.
{$ENDIF}
end;

initialization
{ do not use *_CodeSite.E*Initialization() }
  SetThreadName('MainThread');
finalization
{ do not use *_CodeSite.E*Finalization() }
end.
