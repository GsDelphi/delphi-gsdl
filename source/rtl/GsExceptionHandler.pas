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
  @abstract(Gilbertsoft Exception Handler)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains system constants and resourcestrings.
}
unit GsExceptionHandler;

{$UNDEF USE_CODESITE}
{$I gsdl.inc}

interface

uses
  Classes;

function GSExceptionNotify(Obj: TObject; Addr: Pointer): Boolean;
function GSGetCurrentCallStack(Strings: TStrings): Boolean;

type
  TGSExceptionNotifyHook = function (Obj: TObject; Addr: Pointer): Boolean;
  TGSGetCurrentCallStackHook = function (Strings: TStrings): Boolean;

var
  GSExceptionNotifyHook: TGSExceptionNotifyHook;
  GSGetCurrentCallStackHook: TGSGetCurrentCallStackHook;

implementation

function GSExceptionNotify(Obj: TObject; Addr: Pointer): Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('GSExceptionNotify');{$ENDIF}

  if Assigned(GSExceptionNotifyHook) then
    Result := GSExceptionNotifyHook(Obj, Addr)
  else
    Result := False;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('GSExceptionNotify');{$ENDIF}
end;

function GSGetCurrentCallStack(Strings: TStrings): Boolean;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('GSGetCurrentCallStack');{$ENDIF}

  if Assigned(GSGetCurrentCallStackHook) then
    Result := GSGetCurrentCallStackHook(Strings)
  else
    Result := False;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('GSGetCurrentCallStack');{$ENDIF}
end;

end.

