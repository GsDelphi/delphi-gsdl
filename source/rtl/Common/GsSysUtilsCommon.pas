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
unit GsSysUtilsCommon;

{<

  @abstract(Gilbertsoft System Utilities Common implementations )
  @seealso(SecLicence License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains the common implementations of the low level system routines.
  @see(GSSysUtils).
}

{$I gsdl.inc}

interface

uses
  GSSysUtilsAbstracts;

type
  TGSConvCommon = class(TAbstractGSConv)
  public
    class function IntToHex(Value: Integer; Digits: Integer;
      Group: Integer = 0): String; overload; override;
    class function IntToHex(Value: Int64; Digits: Integer;
      Group: Boolean = False): String; overload; override;
    class function BinToHex(const B: String; Digits: Integer;
      Group: Boolean = False): String; override;
    class function StrToHex(const S: String;
      Group: Boolean = False): String; override;

    class function StrToBin(const S: String;
      OrdinalValues: Boolean = False): String; override;
    class function HexToBin(const H: String;
      OrdinalValues: Boolean = False): String; override;
    class function IntToBin(Value: Cardinal; Digits: Integer;
      OrdinalValues: Boolean = False): String; overload; override;
    class function IntToBin(Value: Cardinal;
      OrdinalValues: Boolean = False): String; overload; override;
    class function IntToBin(Value: Word;
      OrdinalValues: Boolean = False): String; overload; override;
    class function IntToBin(Value: Byte;
      OrdinalValues: Boolean = False): String; overload; override;

    class function HexToInt(const H: String): Integer; override;
    class function BinToInt(const B: String): Cardinal; override;

    class function HexToStr(const H: String): String; override;
    class function BinToStr(const B: String): String; override;
  end;

implementation

uses
  SysUtils;

{ TGSConvCommon }

class function TGSConvCommon.BinToHex(const B: String; Digits: Integer;
  Group: Boolean): String;
begin

end;

class function TGSConvCommon.BinToInt(const B: String): Cardinal;
begin

end;

class function TGSConvCommon.BinToStr(const B: String): String;
begin

end;

class function TGSConvCommon.HexToBin(const H: String;
  OrdinalValues: Boolean): String;
var
  Len,
  I: Integer;
begin
  Result := '';

  Len := Length(H) div 2;

  for I := 1 to Len do
    Result := Result + IntToBin(StrToInt(HexDisplayPrefix + H[I * 2 - 1] + H[I * 2]), 8, OrdinalValues);
end;

class function TGSConvCommon.HexToInt(const H: String): Integer;
begin

end;

class function TGSConvCommon.HexToStr(const H: String): String;
begin

end;

class function TGSConvCommon.IntToBin(Value: Byte;
  OrdinalValues: Boolean): String;
begin
  Result := IntToBin(Value, SizeOf(Value) * 8, OrdinalValues);
end;

class function TGSConvCommon.IntToBin(Value: Cardinal; Digits: Integer;
  OrdinalValues: Boolean): String;
var
  Counter,
  Pow: Integer;
  BitSet: Char;
begin
  if OrdinalValues then
  begin
    Result := StringOfChar(#0, Digits);
    BitSet := #1;
  end
  else
  begin
    Result := StringOfChar('0', Digits);
    BitSet := '1';
  end;

  Pow := 1 shl (Digits - 1);

  if Value <> 0 then
    for Counter := 0 to Digits - 1 do
    begin
      if (Value and (Pow shr Counter)) <> 0 then
        Result[Counter + 1] := BitSet;
    end;
end;

class function TGSConvCommon.IntToBin(Value: Cardinal;
  OrdinalValues: Boolean): String;
begin
  Result := IntToBin(Value, SizeOf(Value) * 8, OrdinalValues);
end;

class function TGSConvCommon.IntToBin(Value: Word;
  OrdinalValues: Boolean): String;
begin
  Result := IntToBin(Value, SizeOf(Value) * 8, OrdinalValues);
end;

class function TGSConvCommon.IntToHex(Value, Digits,
  Group: Integer): String;
begin

end;

class function TGSConvCommon.IntToHex(Value: Int64; Digits: Integer;
  Group: Boolean): String;
begin

end;

class function TGSConvCommon.StrToBin(const S: String;
  OrdinalValues: Boolean): String;
var
  Len,
  I: Integer;
begin
  Result := '';

  Len := Length(S);

  for I := 1 to Len do
    Result := Result + IntToBin(Ord(S[I]), SizeOf(S[I]), OrdinalValues);
end;

class function TGSConvCommon.StrToHex(const S: String;
  Group: Boolean): String;
begin

end;

end.


function IntToHex(Value: Integer; Digits: Integer; Group: Integer): String;
begin
  EGSNotImplemented.CreateFmt('Not implemented: %s!', ['GSSysUtils.IntToHex']);
end;

function IntToHex(Value: Int64; Digits: Integer; Group: Boolean): String;
begin
  EGSNotImplemented.CreateFmt('Not implemented: %s!', ['GSSysUtils.IntToHex']);
end;

function BinToHex(const B: String; Digits: Integer; Group: Boolean): String;
begin
  EGSNotImplemented.CreateFmt('Not implemented: %s!', ['GSSysUtils.BinToHex']);
end;

function StrToHex(const S: String; Group: Boolean): String;
begin
  EGSNotImplemented.CreateFmt('Not implemented: %s!', ['GSSysUtils.StrToHex']);
end;

function HexToInt(const H: String): Integer;
begin
  EGSNotImplemented.CreateFmt('Not implemented: %s!', ['GSSysUtils.HexToInt']);
end;

function BinToInt(const B: String): Cardinal;
begin
  EGSNotImplemented.CreateFmt('Not implemented: %s!', ['GSSysUtils.BinToInt']);
end;

function HexToStr(const H: String): String;
begin
  EGSNotImplemented.CreateFmt('Not implemented: %s!', ['GSSysUtils.HexToStr']);
end;

function BinToStr(const B: String): String;
begin
  EGSNotImplemented.CreateFmt('Not implemented: %s!', ['GSSysUtils.BinToStr']);
end;

