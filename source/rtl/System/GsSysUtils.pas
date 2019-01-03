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
unit GsSysUtils;

{<

  @abstract(Gilbertsoft System Utilities)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains low level system routines.
}

{$I gsdl.inc}

interface

uses
  SysUtils;

type
  { @name is the ancestor of all exceptions }
  EGilbertsoft = class(Exception);
  { @name is thrown on case of a conversion error }
  EGSNotImplemented = class(EGilbertsoft);
  { @name is thrown on case of a conversion error }
  EGSConvertError = class(EGilbertsoft);

{ @name converts an integer to its hexadecimal representation.
  @param(Value is the integer or Int64 value to be converted)
  @param(Digits is the number of nibbles used for the output)
  @param(Group is the number of nibbles used for grouping)
  @returns(Hexadecimal representation of the value)
  @raises(EGSConvertError if the value could not be converted) }
function IntToHex(Value: Integer; Digits: Integer;
  Group: Integer = 0): String; overload;
{ @name converts an int64 to its hexadecimal representation.
  @param(Value is the int64 to be converted)
  @param(Digits is the number of nibbles used for the output)
  @param(Group is the number of nibbles used for grouping)
  @returns(Hexadecimal representation of the value)
  @raises(EGSConvertError if the value could not be converted) }
function IntToHex(Value: Int64; Digits: Integer;
  Group: Boolean = False): String; overload;
{ @name }
function HexToInt(const H: String): Integer;
{ @name }
function StrToHex(const S: String; Group: Boolean = False): String;
{ @name }
function HexToStr(const H: String): String;
{ @name }
function StrToBin(const S: String; OrdinalValues: Boolean = False): String;
{ @name }
function BinToStr(const B: String): String;
{ @name }
function HexToBin(const H: String; OrdinalValues: Boolean = False): String;
{ @name }
function BinToHex(const B: String; Digits: Integer;
  Group: Boolean = False): String;
{ @name }
function BinToInt(const B: String): Cardinal;
{ @name }
function IntToBin(Value: Cardinal; Digits: Integer;
  OrdinalValues: Boolean = False): String; overload;
{ @name }
function IntToBin(Value: Cardinal;
  OrdinalValues: Boolean = False): String; overload;
{ @name }
function IntToBin(Value: Word;
  OrdinalValues: Boolean = False): String; overload;
{ @name }
function IntToBin(Value: Byte;
  OrdinalValues: Boolean = False): String; overload;

implementation

uses
  {$IFDEF MSWINDOWS}GSSysUtilsWindows,{$ENDIF}
  {$IFDEF UNIX}GSSysUtilsUnix,{$ENDIF}
  GSSysUtilsAbstracts;

function BinToHex(const B: String; Digits: Integer; Group: Boolean): String;
begin
  Result := GSConv.BinToHex(B, Digits, Group);
end;

function BinToInt(const B: String): Cardinal;
begin
  Result := GSConv.BinToInt(B);
end;

function BinToStr(const B: String): String;
begin
  Result := GSConv.BinToStr(B);
end;

function HexToBin(const H: String; OrdinalValues: Boolean): String;
begin
  Result := GSConv.HexToBin(H, OrdinalValues);
end;

function HexToInt(const H: String): Integer;
begin
  Result := GSConv.HexToInt(H);
end;

function HexToStr(const H: String): String;
begin
  Result := GSConv.HexToStr(H);
end;

function IntToBin(Value: Byte; OrdinalValues: Boolean): String;
begin
  Result := GSConv.IntToBin(Value, OrdinalValues);
end;

function IntToBin(Value: Cardinal; Digits: Integer;
  OrdinalValues: Boolean): String;
begin
  Result := GSConv.IntToBin(Value, Digits, OrdinalValues);
end;

function IntToBin(Value: Cardinal; OrdinalValues: Boolean): String;
begin
  Result := GSConv.IntToBin(Value, OrdinalValues);
end;

function IntToBin(Value: Word; OrdinalValues: Boolean): String;
begin
  Result := GSConv.IntToBin(Value, OrdinalValues);
end;

function IntToHex(Value: Integer; Digits: Integer; Group: Integer): String;
begin
  Result := GSConv.IntToHex(Value, Digits, Group);
end;

function IntToHex(Value: Int64; Digits: Integer; Group: Boolean): String;
begin
  Result := GSConv.IntToHex(Value, Digits, Group);
end;

function StrToBin(const S: String; OrdinalValues: Boolean): String;
begin
  Result := GSConv.StrToBin(S, OrdinalValues);
end;

function StrToHex(const S: String; Group: Boolean): String;
begin
  Result := GSConv.StrToHex(S, Group);
end;

initialization
finalization
end.
