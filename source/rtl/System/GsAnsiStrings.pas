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
  @abstract(Gilbertsoft AnsiString routines)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2019-01-09)
  @cvs($Date:$)

  @name contains system constants and resourcestrings.
}
unit GsAnsiStrings;

{$I gsdl.inc}

interface

uses
  BPUtils;

function Copy(const AStr: AnsiString; AIndex, ACount: Integer): AnsiString;
//function IntToStr(Value: Integer): AnsiString; overload;
function Pos(const ASubStr, AStr: AnsiString): Integer; overload;
function Pos(const ASubStr: string; const AStr: AnsiString): Integer; overload;
//function StrToInt(const S: AnsiString): Integer;

function Fill(Str: AnsiString; Len: Integer; Alignment: TAlignment; Value: AnsiString): AnsiString;
function FillFit(Str: AnsiString; Len: Integer; Alignment: TAlignment; Value: AnsiString): AnsiString;

implementation

uses
  SysUtils,
  AnsiStrings;

function Copy(const AStr: AnsiString; AIndex, ACount: Integer): AnsiString;
begin
  Result := AnsiString(System.Copy(string(AStr), AIndex, ACount));
end;

function IntToStr(Value: Integer): AnsiString;
begin
  Result := AnsiString(SysUtils.IntToStr(Value));
end;

function Pos(const ASubStr, AStr: AnsiString): Integer;
begin
  Result := AnsiStrings.AnsiPos(ASubStr, AStr);
end;

function Pos(const ASubStr: string; const AStr: AnsiString): Integer;
begin
  Result := AnsiStrings.AnsiPos(AnsiString(ASubStr), AStr);
end;

function StrToInt(const S: AnsiString): Integer;
begin
  Result := SysUtils.StrToInt(string(S));
end;

function Fill(Str: AnsiString; Len: Integer; Alignment: TAlignment; Value: AnsiString): AnsiString;
begin
  Result := AnsiString(BPUtils.Fill(string(Str), Len, Alignment, string(Value)));
end;

function FillFit(Str: AnsiString; Len: Integer; Alignment: TAlignment; Value: AnsiString): AnsiString;
begin
  Result := AnsiString(BPUtils.FillFit(string(Str), Len, Alignment, string(Value)));
end;

end.
