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
{$R-}{ Disable range checks }

interface

uses
  System.Classes,
  System.TypInfo;

type
  TGsEnumSymbolStatus = set of (sDefault, sHidden, sSeparator);

  TGsEnumSymbolInfo = record
    Caption:  PResStringRec;
    //ItemIndex: Integer;
    IntValue: Integer;
    Status:   TGsEnumSymbolStatus;
  end;
  //PGsEnumSymbolInfo = ^TGsEnumSymbolInfo;

  TGsEnumSymbolInfoArray = array[0..0] of TGsEnumSymbolInfo;
  //TGsEnumSymbolInfoArray = array[0..0] of PGsEnumSymbolInfo;
  PGsEnumSymbolInfoArray = ^TGsEnumSymbolInfoArray;

  TGsEnumInfo = record
    TypeInfo:    PTypeInfo;
    Descriptors: PGsEnumSymbolInfoArray;
  end;

  TCustomAssignEnumProc = procedure(AControl: TComponent; AEnumInfo: TGsEnumInfo; ADefaultValue: Integer);
  PCustomAssignEnumProc = ^TCustomAssignEnumProc;

  TAddItemFunc = function(Items: TStrings; AOrdinalValue: Integer; AEnumSymbolInfo: TGsEnumSymbolInfo): Integer;
  TAddItemFilterFunc = function(AOrdinalValue: Integer; AEnumSymbolInfo: TGsEnumSymbolInfo): Boolean;

  TGsEnum = class(TObject)
  protected
    class procedure GetEssentialProperties(AControl: TComponent; out Items: TStrings; var ItemIndex: Integer);

    // Default methods
    class function DefaultAssignItemsFunc(AInfo: TGsEnumInfo; Items: TStrings; AOrdinalValue: Integer = -1;
      AAddItemFilterFunc: TAddItemFilterFunc = nil; AAddItemFunc: TAddItemFunc = nil): Integer;
    class function DefaultAddItemProc(Items: TStrings; AOrdinalValue: Integer;
      AEnumSymbolInfo: TGsEnumSymbolInfo): Integer;
  public
    // Enumeration conversion
    class function SymbolToInt(ATypeInfo: PTypeInfo; const EnumValueInfoArray; AOrdinalValue: Integer): Integer;
    class function IntToSymbol(ATypeInfo: PTypeInfo; const EnumValueInfoArray; AValue: Integer): Integer;

    // Control support
    class procedure AssignTo(AControl: TComponent; ATypeInfo: PTypeInfo; const EnumValueInfoArray;
      AOrdinalValue: Integer = -1; AAddItemFilterFunc: TAddItemFilterFunc = nil; AAddItemFunc: TAddItemFunc = nil);
    class function GetSelected(AControl: TComponent; ATypeInfo: PTypeInfo; const EnumValueInfoArray;
      ADefaultOrdinalValue: Integer = -1): Integer;

    // Enumeration info
    class function GetEnumInfo(ATypeInfo: PTypeInfo; const EnumValueInfoArray): TGsEnumInfo;
    class function GetEnumSymbolInfo(ATypeInfo: PTypeInfo; const EnumValueInfoArray;
      AOrdinalValue: Integer): TGsEnumSymbolInfo;
  end;

function ExtractEnumName(TypeInfo: PTypeInfo; Value: Integer; RemovePrefixChars: Integer = 0;
  const AddPrefix: string = ''): string;

implementation

uses
  GsConsts,
  GsSysUtils,
  //RTLConsts,
  SysUtils;

{ TGsEnum }

function LastExceptionAddr: Pointer;
asm
  MOV     EAX,[EBP+4]
end;

procedure RaiseInvalidItemsProp(AControl: TComponent);
begin
  raise EGsArgumentException.CreateResFmt(@SErrorInvalidItemsProp, ['Items', AControl.ClassName, TStrings.ClassName])
  at LastExceptionAddr;
end;

procedure RaiseInvalidItemIndexProp(AControl: TComponent);
begin
  raise EGsArgumentException.CreateResFmt(@SErrorInvalidItemIndexProp,
    ['ItemIndex', AControl.ClassName, GetEnumName(TypeInfo(TTypeKind), Ord(tkInteger))]) at LastExceptionAddr;
end;

procedure RaiseItemsNotAssigned(AClass: TClass; AControl: TComponent);
begin
  raise EGsArgumentException.CreateResFmt(@SErrorItemsNotAssigned, [AControl.Name, AClass.ClassName + '.AssignTo'])
  at LastExceptionAddr;
end;

function ExtractEnumName(TypeInfo: PTypeInfo; Value: Integer; RemovePrefixChars: Integer;
  const AddPrefix: string): string;
begin
  Result := AddPrefix + Copy(GetEnumName(TypeInfo, Value), RemovePrefixChars + 1, MaxInt);
end;

{ TGsEnum }

class procedure TGsEnum.AssignTo(AControl: TComponent; ATypeInfo: PTypeInfo; const EnumValueInfoArray;
  AOrdinalValue: Integer; AAddItemFilterFunc: TAddItemFilterFunc; AAddItemFunc: TAddItemFunc);
var
  Items:     TStrings;
  I:         Integer;
  ItemIndex: Integer;
begin
  try
    // Get essential and check properties
    GetEssentialProperties(AControl, Items, ItemIndex);

    // Check items are already assigned
    if (AControl.Tag = NativeInt(@EnumValueInfoArray)) then
    begin
      // Set item index only
      ItemIndex := -1;

      if (AOrdinalValue > -1) then
      begin
        for I := 0 to Items.Count - 1 do
        begin
          if (Integer(Items.Objects[I]) = AOrdinalValue) then
          begin
            ItemIndex := I;
            Break;
          end;
        end;
      end;
    end
    else
    begin
      // Assign values
      ItemIndex := DefaultAssignItemsFunc(GetEnumInfo(ATypeInfo, EnumValueInfoArray), Items,
        AOrdinalValue, AAddItemFilterFunc, AAddItemFunc);
    end;

    // Update item index
    SetPropValue(AControl, 'ItemIndex', ItemIndex);

    // Store constant pointer
    AControl.Tag := NativeInt(@EnumValueInfoArray);
  except
    on E: Exception do
      RaiseUnexpectedError(nil, Self, 'AssignTo', E);
  end;
end;

class function TGsEnum.DefaultAddItemProc(Items: TStrings; AOrdinalValue: Integer;
  AEnumSymbolInfo: TGsEnumSymbolInfo): Integer;
begin
  Result := -1;

  if (sHidden in AEnumSymbolInfo.Status) then
    Exit;

  Result := Items.AddObject(LoadResString(AEnumSymbolInfo.Caption), TObject(AOrdinalValue));
end;

class function TGsEnum.DefaultAssignItemsFunc(AInfo: TGsEnumInfo; Items: TStrings;
  AOrdinalValue: Integer; AAddItemFilterFunc: TAddItemFilterFunc; AAddItemFunc: TAddItemFunc): Integer;
var
  I:       Integer;
  Data:    PTypeData;
  AddItem: Boolean;
  Index:   Integer;
begin
  Result := -1;

  Data := GetTypeData(AInfo.TypeInfo);

  Items.Clear;
  Items.Capacity := Data^.MaxValue - Data^.MinValue + 1;

  for I := Data^.MinValue to Data^.MaxValue do
  begin
    if (@AAddItemFilterFunc <> nil) then
      AddItem := AAddItemFilterFunc(I, AInfo.Descriptors^[I])
    else
      AddItem := True;

    if AddItem then
    begin
      if (@AAddItemFunc <> nil) then
        Index := AAddItemFunc(Items, I, AInfo.Descriptors^[I])
      else
        Index := DefaultAddItemProc(Items, I, AInfo.Descriptors^[I]);

      if (Index > -1) and (I = AOrdinalValue) then
        Result := Index;
    end;
  end;
end;

class function TGsEnum.GetEnumInfo(ATypeInfo: PTypeInfo; const EnumValueInfoArray): TGsEnumInfo;
var
  EnumDescriptorArray: TGsEnumSymbolInfoArray absolute EnumValueInfoArray;
begin
  if (ATypeInfo = nil) then
    raise EGsArgumentNilException.CreateResFmt(@SParamIsNil, ['ATypeInfo']);

  if (ATypeInfo^.Kind <> tkEnumeration) then
    raise EGsArgumentOutOfRangeException.CreateResFmt(@SParamIsIllegalType, ['ATypeInfo', ATypeInfo^.Name]);

  if (@EnumDescriptorArray = nil) then
    raise EGsArgumentNilException.CreateResFmt(@SParamIsNil, ['EnumValueInfoArray']);

  Result.TypeInfo    := ATypeInfo;
  Result.Descriptors := @EnumDescriptorArray;
end;

class function TGsEnum.GetEnumSymbolInfo(ATypeInfo: PTypeInfo; const EnumValueInfoArray;
  AOrdinalValue: Integer): TGsEnumSymbolInfo;
var
  EnumInfo: TGsEnumInfo;
  Data:     PTypeData;
begin
  EnumInfo := GetEnumInfo(ATypeInfo, EnumValueInfoArray);

  if (EnumInfo.TypeInfo = nil) then
    raise EGsArgumentNilException.CreateResFmt(@SParamIsNil, ['AEnumInfo.TypeInfo']);

  if (EnumInfo.Descriptors = nil) then
    raise EGsArgumentNilException.CreateResFmt(@SParamIsNil, ['AEnumInfo.Descriptors']);

  Data := GetTypeData(EnumInfo.TypeInfo);

  if (AOrdinalValue < Data^.MinValue) or (AOrdinalValue > Data^.MaxValue) then
    raise EGsArgumentOutOfRangeException.CreateResFmt(@SParamIsOutOfRange,
      ['AOrdinalValue', EnumInfo.TypeInfo^.Name, AOrdinalValue]);

  Result := EnumInfo.Descriptors^[AOrdinalValue];
  // + Pointer(Value * SizeOf(TEnumDescriptor)))^;
  //Result := PEnumDescriptor(Pointer(DescriptorInfo.Descriptors) + Pointer(Value * SizeOf(TEnumDescriptor)))^;
end;

class procedure TGsEnum.GetEssentialProperties(AControl: TComponent; out Items: TStrings; var ItemIndex: Integer);
var
  ItemsProp: PPropInfo;
begin
  if (AControl = nil) then
    raise EGsArgumentNilException.CreateResFmt(@SParamIsNil, ['AControl']);

  ItemsProp := GetPropInfo(AControl, 'Items');
  Items     := TStrings(GetObjectProp(AControl, ItemsProp, TStrings));

  if (Items = nil) then
    RaiseInvalidItemsProp(AControl);

  if not PropIsType(AControl, 'ItemIndex', tkInteger) then
    RaiseInvalidItemIndexProp(AControl);

  ItemIndex := GetPropValue(AControl, 'ItemIndex');
end;

class function TGsEnum.GetSelected(AControl: TComponent; ATypeInfo: PTypeInfo; const EnumValueInfoArray;
  ADefaultOrdinalValue: Integer): Integer;
var
  Items:     TStrings;
  ItemIndex: Integer;
  I:         Integer;
begin
  Result := -1;

  try
    // Get essential and check properties
    GetEssentialProperties(AControl, Items, ItemIndex);

    if (AControl.Tag <> NativeInt(@EnumValueInfoArray)) then
      RaiseItemsNotAssigned(Self, AControl);

    if (ItemIndex > -1) then
      Result := Integer(Items.Objects[ItemIndex])
    else
    begin
      for I := 0 to Items.Count - 1 do
      begin
        if (Integer(Items.Objects[I]) = ADefaultOrdinalValue) then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  except
    on E: Exception do
      RaiseUnexpectedError(nil, Self, 'GetSelected', E);
  end;
end;

class function TGsEnum.IntToSymbol(ATypeInfo: PTypeInfo; const EnumValueInfoArray; AValue: Integer): Integer;
var
  //  L: Cardinal;
  Info:       TGsEnumInfo;
  Data:       PTypeData;
  DefaultSet: Boolean;
  Default:    Integer;
begin
  Info := GetEnumInfo(ATypeInfo, EnumValueInfoArray);
  Data := GetTypeData(Info.TypeInfo);

  Result := Data^.MinValue;

  //  L := DescriptorsCount;
  DefaultSet := False;
  Default    := Data^.MinValue;

  while (Result <= Data^.MaxValue) and (Info.Descriptors^[Result].IntValue <> AValue) do
  begin
    if not DefaultSet and (sDefault in Info.Descriptors^[Result].Status) then
    begin
      DefaultSet := True;
      Default    := Result;
    end;

    Inc(Result);
  end;

  if (Result > Data^.MaxValue) then
  begin
    if DefaultSet then
      Result := Default
    else
      raise EGsArgumentOutOfRangeException.CreateResFmt(@SParamIsOutOfRange,
        ['AValue', Info.TypeInfo^.Name, AValue]);
  end;
end;

class function TGsEnum.SymbolToInt(ATypeInfo: PTypeInfo; const EnumValueInfoArray; AOrdinalValue: Integer): Integer;
begin
  Result := GetEnumSymbolInfo(ATypeInfo, EnumValueInfoArray, AOrdinalValue).IntValue;
end;

end.

