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

{$R-}{ Disable range checks }

interface

uses
  Classes,
  Controls,
  Generics.Collections,
  GsClasses,
  GsSystem,
  RzRadGrp;

(*
{$IFDEF mORMot}
  SynCommons;
{$ELSE ~mORMot}
  TypInfo;
{$ENDIF ~mORMot}
*)

type
  TGsChangeNotifier = class;



  TEventType      = (etNotify, etIndexChanging);
  TEventID        = type Byte;
  PNotifyEventRec = ^TNotifyEventRec;

  TNotifyEventRec = record
    Control: TControl;
    EventID: TEventID;
    case EventType: TEventType of
      etNotify: (NotifyEvent: TNotifyEvent);
      etIndexChanging: (IndexChangingEvent: TRzIndexChangingEvent);
  end;

  TChangeOperation = (coChanged, coSaved);

  TChangeNotifyEvent = procedure(AChangeNotifier: TGsChangeNotifier; Operation: TChangeOperation) of object;

  IChangeNotify = interface
    ['{A670276D-1212-4516-951E-83EB16CA182D}']
    procedure Modified;
    procedure Notification(AChangeNotifier: TGsChangeNotifier; Operation: TChangeOperation);
    procedure ChangeNotification(AChangeNotifier: TGsChangeNotifier);
    procedure RemoveChangeNotification(AChangeNotifier: TGsChangeNotifier);
  end;

  TGsChangeNotifier = class(TComponent)
  private
    FList:           TList;
    FOnChange:       TGsNotifyEvent;
    FEventsDisabled: Boolean;
    //FChangeNotifies: TList<TGsChangeNotifier>;
    procedure NotifyEvent(EventID: TEventID; Sender: TObject);
    procedure NotifyEvent0(Sender: TObject);
    procedure NotifyEvent1(Sender: TObject);
    procedure NotifyEvent2(Sender: TObject);
    procedure NotifyEvent3(Sender: TObject);
    procedure NotifyEvent4(Sender: TObject);
    procedure NotifyEvent5(Sender: TObject);
    procedure NotifyEvent6(Sender: TObject);
    procedure NotifyEvent7(Sender: TObject);
    procedure NotifyEvent8(Sender: TObject);
    procedure NotifyEvent9(Sender: TObject);
    procedure IndexChangingEvent(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    //procedure RemoveNotification(AChangeNotifier: TGsChangeNotifier);
  protected
    { TComponent }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); overload; override;

    { Methods }
    //procedure Notification(AChangeNotifier: TGsChangeNotifier; Operation: TChangeOperation); overload; virtual;
    procedure ChainEvents; dynamic;
    procedure UnchainEvents; dynamic;

    procedure DoChange(Sender: TObject);

    function AddEvent: PNotifyEventRec;

    procedure RegisterEvent(AControl: TControl; AEventID: TEventID;
      AEvent: TNotifyEvent); overload;
    procedure RegisterEvent(AControl: TControl; AEvent: TRzIndexChangingEvent);
      overload;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor CreateAndChain(AOwner: TComponent; Dummy: Integer = 0); overload; virtual;
    destructor Destroy; override;

    procedure DisableEvents;
    procedure EnableEvents;
    //procedure ChangeNotification(AChangeNotifier: TGsChangeNotifier);
    //procedure RemoveChangeNotification(AChangeNotifier: TGsChangeNotifier);
  published
    property OnChange: TGsNotifyEvent read FOnChange write FOnChange;
    //property OnNotify: TChangeNotifyEvent read FOnNotify write FOnNotify;
  end;

implementation

uses
  ComCtrls,
  Dialogs,
  ExtCtrls,
  RzBtnEdt,
  RzButton,
  RzCmboBx,
  RzEdit,
  RzPanel,
  RzRadChk,
  StdCtrls,
  SysUtils,
  Types,
  UITypes,
  Windows;

resourcestring
  SErrorControlNotRegistered = 'Klasse ''%s'' ist nicht registriert in %s';

{ TGsChangeNotifier }

function TGsChangeNotifier.AddEvent: PNotifyEventRec;
begin
  New(Result);
  FList.Add(Result);
end;

procedure TGsChangeNotifier.ChainEvents;
var
  I: Integer;
  Control: TControl;
begin
  with Owner do
  begin
    for I := 0 to ComponentCount - 1 do
    begin
      if Components[I] is TControl then
      begin
        // TControl
        // |- TWinControl
        // |    |- TCustomListControl
        // |    |    |- TCustomMultiSelectListControl
        // |    |    |    |- TCustomListBox
        // |    |    |    |- TCustomListView
        // |    |    |- TCustomCombo
        // |    |- TCustomControl    TCustomHeaderControl
        // |    |    |- TCustomPanel
        // |    |- TCustomHeaderControl
        // |- TGraphicControl
        // |- TCustomLabel

        if not (Components[I] is TRzCustomRadioGroup) and not
          (Components[I] is TRzCustomCheckGroup) and not
          (Components[I] is TRzCustomCheckBox) and
          ((Components[I] is TCustomMultiSelectListControl) or
          (Components[I] is TCustomPanel) or (Components[I] is TCustomLabel) or
          (Components[I] is TRzSpacer) or (Components[I] is TRzToolButton) or
          (Components[I] is TRzToolButton) or (Components[I] is TRzCustomButton) or
          (Components[I] is TCustomHeaderControl)) then
        begin
          Continue;
        end;

        (*
          trztreeview
          trzdbgrid
          trzpagecontrol
          trztabsheet
        *)

        (*
          if (Components[I] is TCustomEdit) or
          (Components[I] is TCustomListControl) or
          (Components[I] is TRzRadioButton) or
          (Components[I] is TRzCustomCheckBox) or
          //(Components[I] is TCustomCheckBox) or
          //(Components[I] is TRadioButton) or
          (Components[I] is TRzCustomRadioGroup) or
          //(Components[I] is TRzCustomRadioGroup) or
          //(Components[I] is TRzCustomRadioGroup) or
          //(Components[I] is TRzCustomRadioGroup) or
          (Components[I] is TCustomEdit) then
          begin

          end;
        *)

        Control := TControl(Components[I]);

        if Components[I] is TRzEdit then
        begin
          RegisterEvent(Control, 0, TRzEdit(Components[I]).OnChange);
          TRzEdit(Components[I]).OnChange := NotifyEvent0;
        end
        else if Components[I] is TRzMemo then
        begin
          RegisterEvent(Control, 0, TRzMemo(Components[I]).OnChange);
          TRzMemo(Components[I]).OnChange := NotifyEvent0;
        end
        else if Components[I] is TRzComboBox then
        begin
          RegisterEvent(Control, 0, TRzComboBox(Components[I]).OnChange);
          TRzComboBox(Components[I]).OnChange := NotifyEvent0;
        end
        else if Components[I] is TRzCheckBox then
        begin
          RegisterEvent(Control, 0, TRzCheckBox(Components[I]).OnClick);
          TRzCheckBox(Components[I]).OnClick := NotifyEvent0;
        end
        else if Components[I] is TRzRadioGroup then
        begin
          RegisterEvent(Control, TRzRadioGroup(Components[I]).OnChanging);
          TRzRadioGroup(Components[I]).OnChanging := IndexChangingEvent;
        end
        else
          MessageDlg(Format(SErrorControlNotRegistered,
            [Components[I].ClassName, Self.ClassName]), mtError, [mbOK], 0);
        { TODO : activate }
        // raise Exception.CreateResFmt(@SErrorControlNotRegistered, [Components[I].ClassName, Self.ClassName]);
      end;
    end;
  end;
end;

constructor TGsChangeNotifier.Create(AOwner: TComponent);
begin
  inherited;

  FList := TList.Create;
end;

constructor TGsChangeNotifier.CreateAndChain(AOwner: TComponent; Dummy: Integer);
begin
  Create(AOwner);

  ChainEvents;
end;

destructor TGsChangeNotifier.Destroy;
begin
  if not (csDesigning in ComponentState) then
    UnchainEvents;

  while FList.Count > 0 do
    Dispose(FList.Extract(FList.Last));

  FList.Free;

  inherited;
end;

procedure TGsChangeNotifier.DisableEvents;
begin
  FEventsDisabled := True;
end;

procedure TGsChangeNotifier.DoChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Sender);
end;

procedure TGsChangeNotifier.EnableEvents;
begin
  FEventsDisabled := False;
end;

procedure TGsChangeNotifier.IndexChangingEvent(Sender: TObject;
  NewIndex: Integer; var AllowChange: Boolean);
var
  I: Integer;
begin
  if not FEventsDisabled and Assigned(Sender) and (Sender is TControl) then
  begin
    for I := 0 to FList.Count - 1 do
    begin
      if (PNotifyEventRec(FList.Items[I])^.Control = Sender) and
        (PNotifyEventRec(FList.Items[I])^.EventType = etIndexChanging) then
      begin
        DoChange(Sender);

        if @PNotifyEventRec(FList.Items[I])^.IndexChangingEvent <> nil then
          PNotifyEventRec(FList.Items[I])^.IndexChangingEvent(Sender, NewIndex,
            AllowChange);

        Break;
      end;
    end;
  end;
end;

procedure TGsChangeNotifier.Loaded;
var
  Loading: Boolean;
begin
  Loading := csLoading in ComponentState;

  inherited;

  if not (csDesigning in ComponentState) and Loading then
    ChainEvents;
end;

procedure TGsChangeNotifier.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: Integer;
begin
  if (Operation = opRemove) then
  begin
    I := 0;

    while I < FList.Count do
    begin
      if (PNotifyEventRec(FList.Items[I])^.Control = AComponent) then
      begin
        Dispose(PNotifyEventRec(FList.Items[I]));
        FList.Delete(I);
      end
      else
        Inc(I);
    end;
  end;

  inherited;
end;

procedure TGsChangeNotifier.NotifyEvent(EventID: TEventID; Sender: TObject);
var
  I: Integer;
begin
  if not FEventsDisabled and Assigned(Sender) and (Sender is TControl) then
  begin
    for I := 0 to FList.Count - 1 do
    begin
      if (PNotifyEventRec(FList.Items[I])^.Control = Sender) and
        (PNotifyEventRec(FList.Items[I])^.EventType = etNotify) and
        (PNotifyEventRec(FList.Items[I])^.EventID = EventID) then
      begin
        DoChange(Sender);

        if @PNotifyEventRec(FList.Items[I])^.NotifyEvent <> nil then
          PNotifyEventRec(FList.Items[I])^.NotifyEvent(Sender);

        Break;
      end;
    end;
  end;
end;

procedure TGsChangeNotifier.NotifyEvent0(Sender: TObject);
begin
  NotifyEvent(0, Sender);
end;

procedure TGsChangeNotifier.NotifyEvent1(Sender: TObject);
begin
  NotifyEvent(1, Sender);
end;

procedure TGsChangeNotifier.NotifyEvent2(Sender: TObject);
begin
  NotifyEvent(2, Sender);
end;

procedure TGsChangeNotifier.NotifyEvent3(Sender: TObject);
begin
  NotifyEvent(3, Sender);
end;

procedure TGsChangeNotifier.NotifyEvent4(Sender: TObject);
begin
  NotifyEvent(4, Sender);
end;

procedure TGsChangeNotifier.NotifyEvent5(Sender: TObject);
begin
  NotifyEvent(5, Sender);
end;

procedure TGsChangeNotifier.NotifyEvent6(Sender: TObject);
begin
  NotifyEvent(6, Sender);
end;

procedure TGsChangeNotifier.NotifyEvent7(Sender: TObject);
begin
  NotifyEvent(7, Sender);
end;

procedure TGsChangeNotifier.NotifyEvent8(Sender: TObject);
begin
  NotifyEvent(8, Sender);
end;

procedure TGsChangeNotifier.NotifyEvent9(Sender: TObject);
begin
  NotifyEvent(9, Sender);
end;

procedure TGsChangeNotifier.RegisterEvent(AControl: TControl;
  AEventID: TEventID; AEvent: TNotifyEvent);
begin
  with AddEvent^ do
  begin
    Control := AControl;
    EventID := AEventID;
    EventType := etNotify;
    NotifyEvent := AEvent;
  end;

  AControl.FreeNotification(Self);
end;

procedure TGsChangeNotifier.RegisterEvent(AControl: TControl;
  AEvent: TRzIndexChangingEvent);
begin
  with AddEvent^ do
  begin
    Control := AControl;
    EventID := 0;
    EventType := etIndexChanging;
    IndexChangingEvent := AEvent;
  end;

  AControl.FreeNotification(Self);
end;

procedure TGsChangeNotifier.UnchainEvents;
var
  I, J: Integer;
begin
  with Owner do
  begin
    for I := 0 to ComponentCount - 1 do
    begin
      if Components[I] is TControl then
      begin
        for J := 0 to FList.Count - 1 do
        begin
          if (PNotifyEventRec(FList.Items[J])^.Control = Pointer(Components[I]))
          then
          begin
            if Components[I] is TRzEdit then
            begin
              TRzEdit(Components[I]).OnChange :=
                PNotifyEventRec(FList.Items[J])^.NotifyEvent;
            end
            else if Components[I] is TRzMemo then
            begin
              TRzMemo(Components[I]).OnChange :=
                PNotifyEventRec(FList.Items[J])^.NotifyEvent;
            end
            else if Components[I] is TRzComboBox then
            begin
              TRzComboBox(Components[I]).OnChange :=
                PNotifyEventRec(FList.Items[J])^.NotifyEvent;
            end
            else if Components[I] is TRzCheckBox then
            begin
              TRzCheckBox(Components[I]).OnClick :=
                PNotifyEventRec(FList.Items[J])^.NotifyEvent;
            end
            else if Components[I] is TRzRadioGroup then
            begin
              TRzRadioGroup(Components[I]).OnChanging :=
                PNotifyEventRec(FList.Items[J])^.IndexChangingEvent;
            end
            else
              MessageDlg(Format(SErrorControlNotRegistered,
                [Components[I].ClassName, Self.ClassName]), mtError,
                [mbOK], 0);
            { TODO : activate }
            // raise Exception.CreateResFmt(@SErrorControlNotRegistered, [Components[I].ClassName, Self.ClassName]);
          end;
        end;
      end;
    end;
  end;
end;

end.

type
  TCustomAssignEnumProc = procedure(AControl: TControl;
    ADescriptorInfo: TGsEnumInfo; ADefaultValue: Integer);
  PCustomAssignEnumProc = ^TCustomAssignEnumProc;

  TAddItemProc = procedure(AControl: TControl; ADescriptorInfo: TGsEnumInfo;
    AValue: Integer; var Handled: Boolean);
  //PAddItemProc = ^TAddItemProc;

procedure AssignEnum1(AControl: TControl; ADescriptorInfo: TGsEnumInfo;
  AValue: Integer = -1; AAddItemProc: TAddItemProc = nil);
function GetSelectedEnum1(AControl: TControl; ADescriptorInfo: TGsEnumInfo;
  ADefaultValue: Integer = -1): Integer;

procedure RegisterCustomAssignEnumProc1(AControlClass: TControlClass;
  CustomProc: PCustomAssignEnumProc);

//    GetEnumName(TypeInfo: PTypeInfo; Value: Integer): string;

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
  ClassPath: string;
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

procedure AssignEnum1(AControl: TControl; ADescriptorInfo: TGsEnumInfo;
  AValue: Integer; AAddItemProc: TAddItemProc);
var
  ItemsCount: Integer;
  ItemsAssigned: Boolean;

  function GetItemsCount: Integer;
  var
    I: Integer;
  begin
    if (ItemsCount = 0) then
    begin
      for I := 0 to ADescriptorInfo.Length - 1 do
      begin
        if (ADescriptorInfo.Descriptors^[Cardinal(I)].ItemIndex > -1) then
          Inc(ItemsCount);
      end;
    end;

    Result := ItemsCount;
  end;

  function AssignItems(Items: TStrings): Integer;

    function GetItemIndex: Integer;
    begin
      Result := -1;

      if (AValue >= 0) and (Cardinal(AValue) < ADescriptorInfo.Length) then
        Result := ADescriptorInfo.Descriptors^[AValue].ItemIndex;
    end;

  resourcestring
    SErrorIndexNotFound = 'Index %d wurde nicht gefunden!';
  var
    C, I{, L}: Integer;
    J: Cardinal;
    Handled: Boolean;
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

      while (Cardinal(J) < ADescriptorInfo.Length) and
        (ADescriptorInfo.Descriptors^[J].ItemIndex <> I) do
        Inc(J);

      if (J = ADescriptorInfo.Length) then
        raise Exception.CreateResFmt(@SErrorIndexNotFound, [I]);

      { TODO : allow adding the index or value e.g. "Caption (value)" }
      Handled := False;
      (*
      if (AAddItemProc <> nil) then
        @AAddItemProc(Items, J, Handled);
      *)

      if not Handled then
      begin
        Items.AddObject(LoadResString(ADescriptorInfo.Descriptors^[J].Caption),
          TObject(J));

        if (AValue > -1) and (J = Cardinal(AValue)) then
          Result := I;
      end;
    end;
  end;

resourcestring
  SErrorAssignEnum =
    'Fehler ''%s'' in Prozedur ''AssignEnum'': %s';
var
  RzRadioGroup: TRzRadioGroup;
  CustomCombo:  TCustomCombo;
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
        AControl, ADescriptorInfo, AValue);
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

function GetSelectedEnum1(AControl: TControl; ADescriptorInfo: TEnumDescriptorInfo;
  ADefaultValue: Integer): Integer;

  function GetDefaultValue: Cardinal;
  var
    I: Integer;
  begin
    if ADefaultValue > -1 then
      Result := ADefaultValue
    else
    begin
      Result := 0;

      for I := 0 to ADescriptorInfo.Length - 1 do
      begin
        if (ADescriptorInfo.Descriptors^[I].ItemIndex = -1) then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  end;

var
  RzRadioGroup: TRzRadioGroup;
  CustomCombo:  TCustomCombo;
  CustomListBox: TCustomListBox;
begin
  Result := -1;

  if (AControl.Tag <> GetItemsAssignedValue) then
    RaiseItemsNotAssigned(AControl);

  if Assigned(CustomAssignEnumProcs) and
    (CustomAssignEnumProcs.Find(TControlClass(AControl.ClassType)) > -1) then
  begin
    { DONE 1 : implement }
    CustomAssignEnumProcs.Items[CustomAssignEnumProcs.LastFound].CustomProc(
      AControl, ADescriptorInfo, ADefaultValue);
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

procedure RegisterCustomAssignEnumProc1(AControlClass: TControlClass;
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


