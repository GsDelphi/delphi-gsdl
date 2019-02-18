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
unit GsSystem;

{$I gsdl.inc}
{$R-} { Disable range checks }

interface

type
  TEnumDescriptor = record
    Caption:   PResStringRec;
    ItemIndex: Integer;
    Value:     Integer;
  end;

  TEnumDescriptors = array [0..0] of TEnumDescriptor;
  PEnumDescriptors = ^TEnumDescriptors;

  TEnumDescriptorInfo = record
    Length: Cardinal;
    Descriptors: PEnumDescriptors;
  end;

function EnumDescriptor(DescriptorInfo: TEnumDescriptorInfo; Value: Cardinal): TEnumDescriptor;
function EnumToInt(DescriptorInfo: TEnumDescriptorInfo; Value: Cardinal): Integer;
function IntToEnum(DescriptorInfo: TEnumDescriptorInfo; Value: Integer): Cardinal;

implementation

uses
  SysUtils;

resourcestring
  SErrorRange = 'Index ''%d'' ist grösser als die Anzahl Elemente ''%d''';

function EnumDescriptor(DescriptorInfo: TEnumDescriptorInfo; Value: Cardinal): TEnumDescriptor;
begin
  if Value >= DescriptorInfo.Length then
    raise Exception.CreateResFmt(@SErrorRange, [Value, DescriptorInfo.Length]);

  Result := DescriptorInfo.Descriptors^[Value];
end;

function EnumToInt(DescriptorInfo: TEnumDescriptorInfo;
  Value: Cardinal): Integer;
begin
  if Value >= DescriptorInfo.Length then
    raise Exception.CreateResFmt(@SErrorRange, [Value, DescriptorInfo.Length]);

  Result := DescriptorInfo.Descriptors^[Value].Value;
end;

function IntToEnum(DescriptorInfo: TEnumDescriptorInfo;
  Value: Integer): Cardinal;
var
//  L: Cardinal;
  I: Integer;
begin
  Result := 0;
//  L := DescriptorsCount;
  I := -1;

  while (Result < DescriptorInfo.Length) and (DescriptorInfo.Descriptors^[Result].Value <> Value) do
  begin
    if (I = -1) and (DescriptorInfo.Descriptors^[Result].ItemIndex < 0) then
      I := Result;

    Inc(Result);
  end;

  if (Result = DescriptorInfo.Length) then
  begin
    if (I > -1) then
      Result := I
    else
      raise Exception.CreateResFmt(@SErrorRange, [Value, DescriptorInfo.Length]);
  end;
end;

end.
