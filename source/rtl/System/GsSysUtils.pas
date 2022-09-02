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
  EGsNotImplemented = class(EGilbertsoft);
  EGsInvalidOwner = class(EGilbertsoft);
  EGsSingletonExists = class(EGilbertsoft);
  { @name is thrown on case of a conversion error }
  EGsConvertError = class(EGilbertsoft);

  EGsArgumentException = class(EGilbertsoft);
  EGsArgumentOutOfRangeException = class(EGsArgumentException);
  EGsArgumentNilException = class(EGsArgumentException);

  EGsUnexpectedError = class(EGilbertsoft);

{ @name converts an integer to its hexadecimal representation.
  @param(Value is the integer or Int64 value to be converted)
  @param(Digits is the number of nibbles used for the output)
  @param(Group is the number of nibbles used for grouping)
  @returns(Hexadecimal representation of the value)
  @raises(EGSConvertError if the value could not be converted) }
function IntToHex(Value: Integer; Digits: Integer; Group: Integer = 0): string; overload;
{ @name converts an int64 to its hexadecimal representation.
  @param(Value is the int64 to be converted)
  @param(Digits is the number of nibbles used for the output)
  @param(Group is the number of nibbles used for grouping)
  @returns(Hexadecimal representation of the value)
  @raises(EGSConvertError if the value could not be converted) }
function IntToHex(Value: Int64; Digits: Integer; Group: Integer = 0): string; overload;
{ @name }
function HexToInt(const H: string): Integer;
{ @name }
function StrToHex(const S: string; Group: Integer = 0): string;
{ @name }
function HexToStr(const H: string): string;
{ @name }
function StrToBin(const S: string; OrdinalValues: Boolean = False): string;
{ @name }
function BinToStr(const B: string): string;
{ @name }
function HexToBin(const H: string; OrdinalValues: Boolean = False): string;
{ @name }
function BinToHex(const B: string; Digits: Integer; Group: Integer = 0): string;
{ @name }
function BinToInt(const B: string): Cardinal;
{ @name }
function IntToBin(Value: Cardinal; Digits: Integer; OrdinalValues: Boolean = False): string; overload;
{ @name }
function IntToBin(Value: Cardinal; OrdinalValues: Boolean = False): string; overload;
{ @name }
function IntToBin(Value: Word; OrdinalValues: Boolean = False): string; overload;
{ @name }
function IntToBin(Value: Byte; OrdinalValues: Boolean = False): string; overload;

procedure RaiseNotImplementedError(AExceptClass: ExceptClass; const AName: string; AClass: TClass;
  const AValue: string = ''); overload;
procedure RaiseNotImplementedError(AExceptClass: ExceptClass; const AName: string; AObject: TObject;
  const AValue: string = ''); overload;

procedure RaiseInvalidOwnerError(AExceptClass: ExceptClass; AOwner, AObject: TObject; AValidOwner: TClass); overload;
procedure RaiseInvalidOwnerError(AExceptClass: ExceptClass; AOwner, AObject: TObject;
  ValidOwners: array of TClass); overload;

procedure RaiseSingletonExistsError(AExceptClass: ExceptClass; AObject: TObject);

procedure RaiseUnexpectedError(AExceptClass: ExceptClass; AClass: TClass; AMethod: string; AException: Exception);

implementation

uses
  GsConsts,
  {$IFDEF MSWINDOWS}GSSysUtilsWindows,{$ENDIF}
  {$IFDEF UNIX}GSSysUtilsUnix,{$ENDIF}
  GSSysUtilsAbstracts;

function BinToHex(const B: string; Digits: Integer; Group: Integer): string;
begin
  Result := GSConv.BinToHex(B, Digits, Group);
end;

function BinToInt(const B: string): Cardinal;
begin
  Result := GSConv.BinToInt(B);
end;

function BinToStr(const B: string): string;
begin
  Result := GSConv.BinToStr(B);
end;

function HexToBin(const H: string; OrdinalValues: Boolean): string;
begin
  Result := GSConv.HexToBin(H, OrdinalValues);
end;

function HexToInt(const H: string): Integer;
begin
  Result := GSConv.HexToInt(H);
end;

function HexToStr(const H: string): string;
begin
  Result := GSConv.HexToStr(H);
end;

function IntToBin(Value: Byte; OrdinalValues: Boolean): string;
begin
  Result := GSConv.IntToBin(Value, OrdinalValues);
end;

function IntToBin(Value: Cardinal; Digits: Integer; OrdinalValues: Boolean): string;
begin
  Result := GSConv.IntToBin(Value, Digits, OrdinalValues);
end;

function IntToBin(Value: Cardinal; OrdinalValues: Boolean): string;
begin
  Result := GSConv.IntToBin(Value, OrdinalValues);
end;

function IntToBin(Value: Word; OrdinalValues: Boolean): string;
begin
  Result := GSConv.IntToBin(Value, OrdinalValues);
end;

function IntToHex(Value: Integer; Digits: Integer; Group: Integer): string;
begin
  Result := GSConv.IntToHex(Value, Digits, Group);
end;

function IntToHex(Value: Int64; Digits: Integer; Group: Integer): string;
begin
  Result := GSConv.IntToHex(Value, Digits, Group);
end;

function StrToBin(const S: string; OrdinalValues: Boolean): string;
begin
  Result := GSConv.StrToBin(S, OrdinalValues);
end;

function StrToHex(const S: string; Group: Integer): string;
begin
  Result := GSConv.StrToHex(S, Group);
end;

resourcestring
  SNilValue = 'nil';
  SOrValue  = 'oder';

function LastExceptionAddr: Pointer;
asm
  MOV     EAX,[EBP+4]
end;

function GetClassName(AClass: TClass): string; overload;
begin
  if Assigned(AClass) then
    Result := AClass.ClassName
  else
    Result := SNilValue;
end;

function GetClassName(AObject: TObject): string; overload;
begin
  if Assigned(AObject) then
    Result := AObject.ClassName
  else
    Result := SNilValue;
end;

function GetExceptClass(AExceptClass, ADefaultExceptClass: ExceptClass): ExceptClass;
begin
  if Assigned(AExceptClass) then
    Result := AExceptClass
  else
    Result := ADefaultExceptClass;
end;

procedure InternalRaiseNotImplementedError(AExceptClass: ExceptClass; const AName: string;
  AClass: TClass; const AValue: string; ErrorAddr: Pointer);

  function ClassName: string;
  begin
    Result := GetClassName(AClass);
  end;

begin
  raise GetExceptClass(AExceptClass, EGsNotImplemented).CreateResFmt(@SErrorNotImplemented, [AName, ClassName, AValue])
  at ErrorAddr;
end;

procedure RaiseNotImplementedError(AExceptClass: ExceptClass; const AName: string; AClass: TClass;
  const AValue: string = ''); overload;
begin
  InternalRaiseNotImplementedError(AExceptClass, AName, AClass, AValue, LastExceptionAddr);
end;

procedure RaiseNotImplementedError(AExceptClass: ExceptClass; const AName: string; AObject: TObject;
  const AValue: string);

  function GetClass: TClass;
  begin
    if Assigned(AObject) then
      Result := AObject.ClassType
    else
      Result := nil;
  end;

var
  ErrorAddr: Pointer;
begin
  ErrorAddr := LastExceptionAddr;
  InternalRaiseNotImplementedError(AExceptClass, AName, GetClass, AValue, ErrorAddr);
end;

procedure InternalRaiseInvalidOwnerError(AExceptClass: ExceptClass; AOwner, AObject: TObject;
  ValidOwners: array of TClass; ErrorAddr: Pointer);

  function Owner: string;
  begin
    Result := GetClassName(AOwner);
  end;

  function ClassName: string;
  begin
    Result := GetClassName(AObject);
  end;

  function ValidOwnersToString: string;

    function ValidOwnerToString(Index: Integer): string;
    begin
      Result := GetClassName(ValidOwners[Index]);
    end;

  var
    I: Integer;
  begin
    if (Length(ValidOwners) > 0) then
    begin
      Result := ValidOwnerToString(0);

      if (Length(ValidOwners) > 1) then
      begin
        for I := Low(ValidOwners) + 1 to High(ValidOwners) - 1 do
          Result := Result + ''', ''' + ValidOwnerToString(I);

        Result := Result + ''' ' + SOrValue + ' ''' + ValidOwnerToString(High(ValidOwners)) + '''';
      end;
    end
    else
      Result := SNilValue;
  end;

begin
  raise GetExceptClass(AExceptClass, EGsInvalidOwner).CreateResFmt(@SErrorInvalidOwner,
    [Owner, ClassName, ValidOwnersToString]) at ErrorAddr;
end;

procedure RaiseInvalidOwnerError(AExceptClass: ExceptClass; AOwner, AObject: TObject; AValidOwner: TClass);
begin
  InternalRaiseInvalidOwnerError(AExceptClass, AOwner, AObject, [AValidOwner], LastExceptionAddr);
end;

procedure RaiseInvalidOwnerError(AExceptClass: ExceptClass; AOwner, AObject: TObject; ValidOwners: array of TClass);
begin
  InternalRaiseInvalidOwnerError(AExceptClass, AOwner, AObject, ValidOwners, LastExceptionAddr);
end;

procedure RaiseSingletonExistsError(AExceptClass: ExceptClass; AObject: TObject);

  function ClassName: string;
  begin
    Result := GetClassName(AObject);
  end;

var
  ErrorAddr: Pointer;
begin
  ErrorAddr := LastExceptionAddr;
  raise GetExceptClass(AExceptClass, EGsSingletonExists).CreateResFmt(@SErrorSingletonExists, [ClassName])
  at ErrorAddr;
end;

procedure RaiseUnexpectedError(AExceptClass: ExceptClass; AClass: TClass; AMethod: string; AException: Exception);
var
  ErrorAddr: Pointer;
begin
  ErrorAddr := LastExceptionAddr;
  raise GetExceptClass(AExceptClass, EGsUnexpectedError).CreateResFmt(@SErrorUnexpected,
    [AException.ClassName, AClass.ClassName + '.' + AMethod, AException.Message]) at ErrorAddr;
end;

initialization

finalization
end.

