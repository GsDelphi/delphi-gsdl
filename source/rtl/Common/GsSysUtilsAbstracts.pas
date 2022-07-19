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
unit GsSysUtilsAbstracts;

{<

  @abstract(Gilbertsoft System Utilities Abstracts)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains abstract classes for the usage at the low level system
  routines. The implementation is done common and plattform dependant.
  @see(GSSysUtils). @see(GSSysUtilsCommon), @see(GSSysUtilsUnix) and
  @see(GSSysUtilsWindows).
}

{$I gsdl.inc}

interface

type
  { @name is the class type of TAbstractGSConv }
  TGSConvClass = class of TAbstractGSConv;

  { @name }
  TAbstractGSConv = class(TObject)
  protected
    class procedure GroupString(var Result: string; Group: Integer);
  public
    { @name replaces the used implementation of @parent.
      @param(AClass is the implementated class to be used) }
    class procedure ReplaceImplementation(AClass: TGSConvClass);
    { @see(@name) }
    class function IntToHex(Value: Integer; Digits: Integer;
      Group: Integer = 0): String; overload; virtual; abstract;
    { @see(@name) }
    class function IntToHex(Value: Int64; Digits: Integer;
      Group: Integer = 0): String; overload; virtual; abstract;
    { @see(@name) }
    class function HexToInt(const H: String): Integer; virtual; abstract;
    { @see(@name) }
    class function StrToHex(const S: String;
      Group: Integer = 0): String; virtual; abstract;
    { @see(@name) }
    class function HexToStr(const H: String): String; virtual; abstract;

    { @see(@name) }
    class function BinToHex(const B: String; Digits: Integer;
      Group: Integer = 0): String; virtual; abstract;
    { @see(@name) }
    class function StrToBin(const S: String;
      OrdinalValues: Boolean = False): String; virtual; abstract;
    { @see(@name) }
    class function HexToBin(const H: String;
      OrdinalValues: Boolean = False): String; virtual; abstract;
    { @see(@name) }
    class function IntToBin(Value: Cardinal; Digits: Integer;
      OrdinalValues: Boolean = False): String; overload; virtual; abstract;
    { @see(@name) }
    class function IntToBin(Value: Cardinal;
      OrdinalValues: Boolean = False): String; overload; virtual; abstract;
    { @see(@name) }
    class function IntToBin(Value: Word;
      OrdinalValues: Boolean = False): String; overload; virtual; abstract;
    { @see(@name) }
    class function IntToBin(Value: Byte;
      OrdinalValues: Boolean = False): String; overload; virtual; abstract;
    { @see(@name) }
    class function BinToInt(const B: String): Cardinal; virtual; abstract;
    { @see(@name) }
    class function BinToStr(const B: String): String; virtual; abstract;
  end;

function GSConv: TGSConvClass;

implementation

var
  GSConvClass: TGSConvClass = nil;

function GSConv: TGSConvClass;
begin
  if Assigned(GSConvClass) then
    Result := GSConvClass
  else
    Result := TAbstractGSConv;
end;

{ TAbstractGSConv }

class procedure TAbstractGSConv.GroupString(var Result: string; Group: Integer);
var
  I: Integer;
begin
  { TODO : test }
  if Group > 0 then
  begin
    I := Group + 1;

    while I < Length(Result) do
    begin
      Insert(' ', Result, I);
      Inc(I, Group + 1);
    end;
  end;
end;

class procedure TAbstractGSConv.ReplaceImplementation(AClass: TGSConvClass);
begin
  GSConvClass := AClass;
end;

end.
