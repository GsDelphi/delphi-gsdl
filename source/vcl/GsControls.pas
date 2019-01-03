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
unit GsControls;

{$R-} { Disable range checks }

interface

uses
  Classes,
  Controls,
  GsSystem;

(*
{$IFDEF mORMot}
  SynCommons;
{$ELSE ~mORMot}
  TypInfo;
{$ENDIF ~mORMot}
*)

type
  TCustomAssignEnumProc = procedure(AControl: TControl;
    DescriptorInfo: TEnumDescriptorInfo; Value: Integer);
  PCustomAssignEnumProc = ^TCustomAssignEnumProc;

procedure AssignEnum(AControl: TControl; DescriptorInfo: TEnumDescriptorInfo;
  Value: Integer = -1);
function GetSelectedEnum(AControl: TControl; DescriptorInfo: TEnumDescriptorInfo;
  DefaultValue: Integer = -1): Cardinal;

procedure RegisterCustomAssignEnumProc(AControlClass: TControlClass;
  CustomProc: PCustomAssignEnumProc);

//    GetEnumName(TypeInfo: PTypeInfo; Value: Integer): string;

implementation

uses
  SysUtils,
  StdCtrls,
  Windows,
  RzRadGrp;

type
  TCustomAssignEnumItem = record
    ControlClass: TControlClass;
    CustomProc: TCustomAssignEnumProc;
  end;

  PCustomAssignEnumItem = ^TCustomAssignEnumItem;

  TCustomAssignEnumProcList = class(TList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  end;

  TCustomAssignEnumList = class(TObject)
  private
    FList: TCustomAssignEnumProcList;
    FLastFound: Integer;
    function GetItem(Index: Integer): TCustomAssignEnumItem;
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function Add(AControlClass: TControlClass;
      CustomProc: PCustomAssignEnumProc): Integer;
    function Find(AControlClass: TControlClass; AExact: Boolean = False;
      AStartAt: Integer = 0): Integer;
    function LastFound: Integer;

    property Items[Index: Integer]: TCustomAssignEnumItem read GetItem; default;
  end;

var
  lItemsAssignedValue: Integer = 0;
  CustomAssignEnumProcs: TCustomAssignEnumList = nil;


procedure RaiseControlClassNotFound(AControl: TControl);

  function ReturnAddr: Pointer;
  asm
    MOV     EAX,[EBP+4]
  end;

resourcestring
  SErrorControlClassNotImplemented =
    'Klasse ''%s'' ist nicht implementiert!';
var
  ClassPath: String;
  ParentClass: TClass;
begin
  ClassPath := AControl.ClassName;
  ParentClass := AControl.ClassParent;

  while (ParentClass <> nil) do
  begin
    ClassPath := ClassPath + ' > ' + ParentClass.ClassName;
    ParentClass := ParentClass.ClassParent;
  end;

  raise Exception.CreateResFmt(@SErrorControlClassNotImplemented, [ClassPath])
  at ReturnAddr;
end;

procedure RaiseItemsNotAssigned(AControl: TControl);

  function ReturnAddr: Pointer;
  asm
    MOV     EAX,[EBP+4]
  end;

resourcestring
  SErrorItemsNotAssigned =
    'Die Elemente von ''%s'' wurden nicht durch ''AssignEnum'' zugewiesen!';
begin
  raise Exception.CreateResFmt(@SErrorItemsNotAssigned, [AControl.Name]) at ReturnAddr;
end;

function GetItemsAssignedValue: Integer;
begin
  if (lItemsAssignedValue = 0) then
    lItemsAssignedValue := Integer(GetTickCount);

  Result := lItemsAssignedValue;
end;

procedure AssignEnum(AControl: TControl; DescriptorInfo: TEnumDescriptorInfo;
  Value: Integer);
var
  ItemsCount: Integer;
  ItemsAssigned: Boolean;

  function GetItemsCount: Integer;
  var
    I: Integer;
  begin
    if (ItemsCount = 0) then
    begin
      for I := 0 to DescriptorInfo.Length - 1 do
      begin
        if (DescriptorInfo.Descriptors^[Cardinal(I)].ItemIndex > -1) then
          Inc(ItemsCount);
      end;
    end;

    Result := ItemsCount;
  end;

  function AssignItems(Items: TStrings): Integer;

    function GetItemIndex: Integer;
    var
      I: Integer;
    begin
      Result := -1;

      for I := 0 to Items.Count - 1 do
      begin
        if Value = Integer(Items.Objects[I]) then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;

  resourcestring
    SErrorIndexNotFound = 'Index %d wurde nicht gefunden!';
  var
    C, I{, L}: Integer;
    J: Cardinal;
  begin
    Result := -1;

    if ItemsAssigned then
    begin
      Result := GetItemIndex;
      Exit;
    end;

    C := GetItemsCount;
    //L := DescriptorsCount;

    Items.Clear;
    Items.Capacity := C;

    for I := 0 to C - 1 do
    begin
      J := 0;

      while (Cardinal(J) < DescriptorInfo.Length) and (DescriptorInfo.Descriptors^[J].ItemIndex <> I) do
        Inc(J);

      if (J = DescriptorInfo.Length) then
        raise Exception.CreateResFmt(@SErrorIndexNotFound, [I]);

      { TODO : allow adding the index or value e.g. "Caption (value)" }
      Items.AddObject(LoadResString(DescriptorInfo.Descriptors^[J].Caption),
        TObject(J));

      if (Value > -1) and (J = Cardinal(Value)) then
        Result := I;
    end;
  end;

resourcestring
  SErrorAssignEnum =
    'Fehler ''%s'' in Prozedur ''AssignEnum'': %s';
var
  RzRadioGroup: TRzRadioGroup;
  CustomCombo: TCustomCombo;
  CustomListBox: TCustomListBox;
begin
  try
    { Important! Initialize cache variables }
    ItemsCount := 0;
    ItemsAssigned := AControl.Tag = GetItemsAssignedValue;

    if Assigned(CustomAssignEnumProcs) and
      (CustomAssignEnumProcs.Find(TControlClass(AControl.ClassType)) > -1) then
    begin
      CustomAssignEnumProcs.Items[CustomAssignEnumProcs.LastFound].CustomProc(
        AControl, DescriptorInfo, Value);
    end
    else if AControl is TRzRadioGroup then
    begin
      RzRadioGroup := AControl as TRzRadioGroup;
      RzRadioGroup.ItemIndex := AssignItems(RzRadioGroup.Items);
    end
    else if AControl is TCustomCombo then
    begin
      CustomCombo := AControl as TCustomCombo;
      CustomCombo.ItemIndex := AssignItems(CustomCombo.Items);
    end
    else if AControl is TCustomListBox then
    begin
      CustomListBox := AControl as TCustomListBox;
      CustomListBox.ItemIndex := AssignItems(CustomListBox.Items);
    end
    else
    begin
      RaiseControlClassNotFound(AControl);
    end;

    AControl.Tag := GetItemsAssignedValue;
  except
    on E: Exception do
      raise Exception.CreateResFmt(@SErrorAssignEnum, [E.ClassName, E.Message]);
  end;
end;

function GetSelectedEnum(AControl: TControl; DescriptorInfo: TEnumDescriptorInfo;
  DefaultValue: Integer): Cardinal;

  function GetDefaultValue: Cardinal;
  var
    I: Integer;
  begin
    if DefaultValue > -1 then
      Result := DefaultValue
    else
    begin
      Result := 0;

      for I := 0 to DescriptorInfo.Length - 1 do
      begin
        if (DescriptorInfo.Descriptors^[I].ItemIndex = -1) then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  end;

var
  RzRadioGroup: TRzRadioGroup;
  CustomCombo: TCustomCombo;
  CustomListBox: TCustomListBox;
begin
  if (AControl.Tag <> GetItemsAssignedValue) then
    RaiseItemsNotAssigned(AControl);

  if Assigned(CustomAssignEnumProcs) and
    (CustomAssignEnumProcs.Find(TControlClass(AControl.ClassType)) > -1) then
  begin
    {TODO 1 : implement }
(*    CustomAssignEnumProcs.Items[CustomAssignEnumProcs.LastFound].CustomProc(
      AControl, Descriptors, Value);*)
  end
  else if AControl is TRzRadioGroup then
  begin
    RzRadioGroup := AControl as TRzRadioGroup;
    if RzRadioGroup.ItemIndex > -1 then
      Result := Cardinal(RzRadioGroup.Items.Objects[RzRadioGroup.ItemIndex])
    else
      Result := GetDefaultValue;
  end
  else if AControl is TCustomCombo then
  begin
    CustomCombo := AControl as TCustomCombo;
    if CustomCombo.ItemIndex > -1 then
      Result := Cardinal(CustomCombo.Items.Objects[CustomCombo.ItemIndex])
    else
      Result := GetDefaultValue;
  end
  else if AControl is TCustomListBox then
  begin
    CustomListBox := AControl as TCustomListBox;
    if CustomListBox.ItemIndex > -1 then
      Result := Cardinal(CustomListBox.Items.Objects[CustomListBox.ItemIndex])
    else
      Result := GetDefaultValue;
  end
  else
  begin
    RaiseControlClassNotFound(AControl);
  end;
end;

procedure RegisterCustomAssignEnumProc(AControlClass: TControlClass;
  CustomProc: PCustomAssignEnumProc);
begin
  if not Assigned(CustomAssignEnumProcs) then
    CustomAssignEnumProcs := TCustomAssignEnumList.Create;

  CustomAssignEnumProcs.Add(AControlClass, CustomProc);
end;

{ TCustomAssignEnumProcList }

procedure TCustomAssignEnumProcList.Notify(Ptr: Pointer; Action: TListNotification);
var
  CustomAssignEnumItem: PCustomAssignEnumItem;
begin
  if Action = lnDeleted then
  begin
    CustomAssignEnumItem := Ptr;
    Dispose(CustomAssignEnumItem);
  end;

  inherited Notify(Ptr, Action);
end;

{ TCustomAssignEnumList }

function CustomAssignEnumListSortCompare(Item1, Item2: Pointer): Integer;
begin
  if PCustomAssignEnumItem(Item1)^.ControlClass.InheritsFrom(
    PCustomAssignEnumItem(Item2)^.ControlClass) then
    Result := -1
  else if PCustomAssignEnumItem(Item2)^.ControlClass.InheritsFrom(
    PCustomAssignEnumItem(Item1)^.ControlClass) then
    Result := 1
  else
  begin
    Result := CompareStr(PCustomAssignEnumItem(Item1)^.ControlClass.ClassName,
      PCustomAssignEnumItem(Item2)^.ControlClass.ClassName);
  end;
end;

function TCustomAssignEnumList.Add(AControlClass: TControlClass;
  CustomProc: PCustomAssignEnumProc): Integer;
resourcestring
  SErrorClassAlreadyRegistered = 'Klasse ''%s'' ist bereits registriert!';
var
  CustomAssignEnumItem: PCustomAssignEnumItem;
begin
  if (Find(AControlClass, True) > -1) then
    raise Exception.CreateResFmt(@SErrorClassAlreadyRegistered,
      [AControlClass.ClassName]);

  New(CustomAssignEnumItem);
  CustomAssignEnumItem^.ControlClass := AControlClass;
  CustomAssignEnumItem^.CustomProc := CustomProc^;

  FList.Add(CustomAssignEnumItem);
  FList.Sort(CustomAssignEnumListSortCompare);

  Result := FList.IndexOf(CustomAssignEnumItem);
end;

constructor TCustomAssignEnumList.Create;
begin
  inherited Create;

  FList := TCustomAssignEnumProcList.Create;
end;

destructor TCustomAssignEnumList.Destroy;
begin
  FList.Free;

  inherited;
end;

function TCustomAssignEnumList.Find(AControlClass: TControlClass;
  AExact: Boolean; AStartAt: Integer): Integer;
var
  I: Integer;
begin
  FLastFound := -1;

  for I := AStartAt to FList.Count - 1 do
    if (AExact and (Items[I].ControlClass = AControlClass)) or
      (not AExact and Items[I].ControlClass.InheritsFrom(AControlClass)) then
    begin
      FLastFound := I;
      Break;
    end;

  Result := FLastFound;
end;

function TCustomAssignEnumList.GetItem(Index: Integer): TCustomAssignEnumItem;
begin
  Result := PCustomAssignEnumItem(FList.Items[Index])^;
end;

function TCustomAssignEnumList.LastFound: Integer;
begin
  Result := FLastFound;
end;

end.
