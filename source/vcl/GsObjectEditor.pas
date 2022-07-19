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
unit GsObjectEditor;

{$I Gilbertsoft.inc}

interface

uses
  GsClasses, SysUtils, GsObjectEditorIntf, Classes, TypInfo, BPTypInfo, Forms,
  GsDynControlEngineRC, Controls, Contnrs;

type
  { exception }
  EGSObjectEditor = class(Exception);


  { forward declaration }
  TGSObjectEditorImpl = class;
  TGSObjectEditorImplClass = class of TGSObjectEditorImpl;


  { object editor base objects }
  TGSOEPersistent = class(TInterfacedPersistent, IGSObjectEditorSupport)
  private
    FObjectEditorImpl: TGSObjectEditorImpl;
  protected
    { IGSObjectEditorSupport }
    function GetOEObjectName: String; virtual;
    function GetOEObjectInfo: PTypeInfo; virtual;
    function GetOEObjectCaption: String; virtual;
    function GetOEObjectEnabled: Boolean; virtual;
    function GetOEObjectHint: String; virtual;
    function GetOEObjectVisible: Boolean; virtual;
    function GetOEPropertyCount: Integer; virtual;
    function GetOEPropertyName(Index: Integer): TSymbolName; virtual;
    function GetOEPropertyInfo(Index: Integer): PPropInfo; virtual;
    function GetOEPropertyCaption(Index: Integer): String; virtual;
    function GetOEPropertyEditClass(Index: Integer): TGSObjectEditorPropertyEditClass; virtual;
    function GetOEPropertyEnabled(Index: Integer): Boolean; virtual;
    function GetOEPropertyHint(Index: Integer): String; virtual;
    function GetOEPropertyValue(Index: Integer): String; virtual;
    function GetOEPropertyVisible(Index: Integer): Boolean; virtual;
    procedure SetOEPropertyValue(Index: Integer; const Value: String); virtual;

    { easy interface and implementation access }
    function GetObjectEditorImpl: TGSObjectEditorImpl; virtual;
    function GetObjectEditorSupport: IGSObjectEditorSupport; virtual;

    property ObjectEditorImpl: TGSObjectEditorImpl read GetObjectEditorImpl;
    property ObjectEditorSupport: IGSObjectEditorSupport read GetObjectEditorSupport;
  public
    destructor Destroy; override;

    function Clone: TPersistent;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);

    procedure LoadDefsFromFile(const FileName: String);
    procedure LoadDefsFromStream(Stream: TStream);
    procedure SaveDefsToFile(const FileName: String);
    procedure SaveDefsToStream(Stream: TStream);

    function OEPropertyIndexOfName(const AName: String): Integer;
  end;

  TGSOEComponent = class(TGsComponent, IGSObjectEditorSupport)
  private
    FObjectEditorImpl: TGSObjectEditorImpl;
  protected
    { IGSObjectEditorSupport }
    function GetOEObjectName: String; virtual;
    function GetOEObjectInfo: PTypeInfo; virtual;
    function GetOEObjectCaption: String; virtual;
    function GetOEObjectEnabled: Boolean; virtual;
    function GetOEObjectHint: String; virtual;
    function GetOEObjectVisible: Boolean; virtual;
    function GetOEPropertyCount: Integer; virtual;
    function GetOEPropertyName(Index: Integer): TSymbolName; virtual;
    function GetOEPropertyInfo(Index: Integer): PPropInfo; virtual;
    function GetOEPropertyCaption(Index: Integer): String; virtual;
    function GetOEPropertyEditClass(Index: Integer): TGSObjectEditorPropertyEditClass; virtual;
    function GetOEPropertyEnabled(Index: Integer): Boolean; virtual;
    function GetOEPropertyHint(Index: Integer): String; virtual;
    function GetOEPropertyValue(Index: Integer): String; virtual;
    function GetOEPropertyVisible(Index: Integer): Boolean; virtual;
    procedure SetOEPropertyValue(Index: Integer; const Value: String); virtual;

    { easy interface and implementation access }
    function GetObjectEditorImpl: TGSObjectEditorImpl; virtual;
    function GetObjectEditorSupport: IGSObjectEditorSupport; virtual;

    property ObjectEditorImpl: TGSObjectEditorImpl read GetObjectEditorImpl;
    property ObjectEditorSupport: IGSObjectEditorSupport read GetObjectEditorSupport;
  public
    destructor Destroy; override;

    function Clone: TPersistent;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);

    procedure LoadDefsFromFile(const FileName: String);
    procedure LoadDefsFromStream(Stream: TStream);
    procedure SaveDefsToFile(const FileName: String);
    procedure SaveDefsToStream(Stream: TStream);

    function OEPropertyIndexOfName(const AName: String): Integer;
  end;

  TGSOEObject = TGSOEPersistent;


  { object editor }
  TPanelList = class(TComponentList)
  private
    function GetWCtrlItem(Index: Integer): TWinControl;
    procedure SetWCtrlItem(Index: Integer; const Value: TWinControl);
  public
    function ShowPanel(AOwner: TComponent; AParentControl: TWinControl; AClass: TClass): Integer;
    property Items[Index: Integer]: TWinControl read GetWCtrlItem write SetWCtrlItem; default;
  end;

  TGSObjectEditorControl = class(TGSDynControlRCPanel)
  private
    FInstance: TPersistent;
    FReadOnly: Boolean;
    FScrollBox: TWinControl;
    FPanels: TPanelList;
    procedure SetInstance(const Value: TPersistent);
    procedure SetReadOnly(const Value: Boolean);
  protected
    procedure CreateControls;
    procedure DestroyControls;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Instance: TPersistent read FInstance write SetInstance;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
  end;

  TGsObjectEditorForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FObjectEditorControl: TGSObjectEditorControl;
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure SetInstance(const Value: TPersistent);
    procedure SetReadOnly(const Value: Boolean);
    function GetInstance: TPersistent;
    function GetReadOnly: Boolean;
  protected
    procedure CreateFormControls;
    procedure DestroyFormControls;
  public
    property Instance: TPersistent read GetInstance write SetInstance;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  end;


  { default implementation for IGSObjectEditorSupport }
  TGSObjectEditorImpl = class(TInterfacedObject, IGSObjectEditorSupport)
  private
    FOEObjectName: String;
    FOEObjectCaption: String;
    FOEObjectEnabled: Boolean;
    FOEObjectHint: String;
    FOEObjectVisible: Boolean;

    FObjectEditorSupport: IGSObjectEditorSupport;
    FPropertyList: PPropList;

    { IGSObjectEditorSupport }
    function GetOEObjectName: String;
    function GetOEObjectInfo: PTypeInfo;
    function GetOEObjectCaption: String;
    function GetOEObjectEnabled: Boolean;
    function GetOEObjectHint: String;
    function GetOEObjectVisible: Boolean;
    function GetOEPropertyCount: Integer;
    function GetOEPropertyName(Index: Integer): TSymbolName;
    function GetOEPropertyInfo(Index: Integer): PPropInfo;
    function GetOEPropertyCaption(Index: Integer): String;
    function GetOEPropertyEditClass(Index: Integer): TGSObjectEditorPropertyEditClass;
    function GetOEPropertyEnabled(Index: Integer): Boolean;
    function GetOEPropertyHint(Index: Integer): String;
    function GetOEPropertyValue(Index: Integer): String;
    function GetOEPropertyVisible(Index: Integer): Boolean;
    procedure SetOEPropertyValue(Index: Integer; const Value: String);

    { easy interface access }
    function GetObjectEditorSupport: IGSObjectEditorSupport;
  protected
    FOwner: TPersistent;
  public
    constructor Create(AOwner: TPersistent); reintroduce; virtual;
    destructor Destroy; override;

    function Clone: TPersistent;
    procedure Assign(Source: TPersistent);

    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);

    procedure LoadDefsFromFile(const FileName: String);
    procedure LoadDefsFromStream(Stream: TStream);
    procedure SaveDefsToFile(const FileName: String);
    procedure SaveDefsToStream(Stream: TStream);

    { easy interface access }
    property ObjectEditorSupport: IGSObjectEditorSupport read GetObjectEditorSupport;

    { object properties }
    property OEObjectName: String read GetOEObjectName;
    property OEObjectInfo: PTypeInfo read GetOEObjectInfo;
    property OEObjectCaption: String read GetOEObjectCaption;
    property OEObjectEnabled: Boolean read GetOEObjectEnabled;
    property OEObjectHint: String read GetOEObjectHint;
    property OEObjectVisible: Boolean read GetOEObjectVisible;

    { property support properties }
    function OEPropertyIndexOfName(const AName: String): Integer;

    property OEPropertyCount: Integer read GetOEPropertyCount;
    property OEPropertyName[Index: Integer]: TSymbolName read GetOEPropertyName;
    property OEPropertyInfo[Index: Integer]: PPropInfo read GetOEPropertyInfo;
    property OEPropertyCaption[Index: Integer]: String read GetOEPropertyCaption;
    property OEPropertyEditClass[Index: Integer]: TGSObjectEditorPropertyEditClass read GetOEPropertyEditClass;
    property OEPropertyEnabled[Index: Integer]: Boolean read GetOEPropertyEnabled;
    property OEPropertyHint[Index: Integer]: String read GetOEPropertyHint;
    property OEPropertyValue[Index: Integer]: String read GetOEPropertyValue write SetOEPropertyValue;
    property OEPropertyVisible[Index: Integer]: Boolean read GetOEPropertyVisible;
  end;

function EditObject(Instance: TPersistent; ReadOnly: Boolean = False): Boolean; overload;

implementation

{$R *.dfm}

uses
  RzEdit, RzCmboBx, RzChkLst, Variants, VarCmplx, VarConv, StdCtrls,
  JvDynControlEngineIntf, GSDynControlEngine, GSVclConsts, RzPanel, ExtCtrls,
  RTLConsts, RzCommon, RzButton, GSDynControlEngineIntf;

resourcestring
  SErrorNoOwner = 'Es wurde kein Eigentümer angegeben!';
  SErrorMissingInterface = 'Der Eigentümer unterstützt nicht die Schnittstelle "IGSObjectEditorSupport"!';
  SErrorCloneNotImplemented = 'Funktion "Clone" ist bei der Klasse "%s" nicht implementiert!';

var
  lGSObjectEditorForm: TGSObjectEditorForm;

function EditObject(Instance: TPersistent; ReadOnly: Boolean): Boolean; overload;
var
  InstanceCopy: TPersistent;
  ObjectEditorSupport: IGSObjectEditorSupport;
begin
  Result := False;

  if not Assigned(Instance) then
    Exit;

  if not Supports(Instance, IGSObjectEditorSupport, ObjectEditorSupport) then
    Exit;

  InstanceCopy := ObjectEditorSupport.Clone;

  if not Assigned(lGSObjectEditorForm) then
    lGSObjectEditorForm := TGSObjectEditorForm.Create(Application);

  try
    { assign cloned data }
    lGSObjectEditorForm.Instance := InstanceCopy;
    lGSObjectEditorForm.ReadOnly := ReadOnly;

    { show form }
    Result := (lGSObjectEditorForm.ShowModal = mrOk);

    { assign from copy }
    if Result then
      Instance.Assign(InstanceCopy);
  finally
    InstanceCopy.Free;
  end;
end;

{ TPanelList }

function TPanelList.GetWCtrlItem(Index: Integer): TWinControl;
begin
  Result := inherited Items[Index] as TWinControl;
end;

procedure TPanelList.SetWCtrlItem(Index: Integer;
  const Value: TWinControl);
begin
  inherited Items[Index] := Value;
end;

function TPanelList.ShowPanel(AOwner: TComponent; AParentControl: TWinControl; AClass: TClass): Integer;
var
  I: Integer;
  TmpBevelBorder: IJvDynControlBevelBorder;
begin
  Result := -1;

  for I := 0 to Count - 1 do
  begin
    Items[I].Visible := False;

    if (Items[I].Name = AClass.ClassName) then
    begin
      Items[I].Visible := True;
      Items[I].BringToFront;
      Result := I;
    end;
  end;

  if (Result < 0) then
  begin
    Result := Add(DefaultDynControlEngine.CreatePanel(AOwner, AParentControl, AClass.ClassName, '', alClient));

    if Supports(Items[Result], IJvDynControlBevelBorder, TmpBevelBorder) then
      TmpBevelBorder.ControlSetBevelOuter(bvNone);

    if IsPublishedProp(Items[Result], 'BorderWidth') then
      SetOrdProp(Items[Result], 'BorderWidth', 2);
  end;
end;

{ TGSObjectEditorControl }

constructor TGSObjectEditorControl.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TGSObjectEditorControl.CreateControls;
var
  ObjectEditorSupport: IGSObjectEditorSupport;
  I,
  C: Integer;
  ClassPanel,
  Panel: TWinControl;
  EditCtrl: TWinControl;
  LabelCtrl: TControl;
  IsNewPage: Boolean;
  TmpBevelBorder: IJvDynControlBevelBorder;
  TmpData: IJvDynControlData;
  TmpCaption: IJvDynControlCaption;
begin
  if not Assigned(FScrollBox) then
  begin
    FScrollBox := DefaultDynControlEngine.CreateScrollBox(Owner, Self, 'ScrollBox');
    FScrollBox.Align := alClient;
    FPanels := TPanelList.Create;
  end;

  ClassPanel := FPanels[FPanels.ShowPanel(Owner, FScrollBox, Instance.ClassType)];

  IsNewPage := (ClassPanel.Tag = 0);

  if Supports(Instance, IGSObjectEditorSupport, ObjectEditorSupport) then
  begin
    Enabled := ObjectEditorSupport.OEObjectEnabled;
    Hint := ObjectEditorSupport.OEObjectHint;
    Visible := ObjectEditorSupport.OEObjectVisible;

    if IsNewPage then
    begin
      for I := 0 to ObjectEditorSupport.OEPropertyCount - 1 do
      begin
        EditCtrl := TWinControl(DefaultDynControlEngine.CreateControlClass(ObjectEditorSupport.OEPropertyEditClass[I], Owner, ClassPanel, Instance.ClassName + '.E' + String(ObjectEditorSupport.OEPropertyName[I])));

        Panel := DefaultDynControlEngine.CreateLabledEdit(Owner, ClassPanel, Instance.ClassName + '.' + String(ObjectEditorSupport.OEPropertyName[I]), EditCtrl);

        (*
        if Supports(Panel, IJvDynControlBevelBorder, TmpBevelBorder) then
          TmpBevelBorder.ControlSetBevelOuter(bvNone);

        if IsPublishedProp(Panel, 'BorderWidth') then
          SetOrdProp(Panel, 'BorderWidth', 2);

        Panel.Align := alTop;


        LabelCtrl := DefaultDynControlEngine.CreateLabe(Owner, Panel, Instance.ClassName + '.L' + ObjectEditorSupport.OEPropertyName[I], ObjectEditorSupport.OEPropertyCaption[I], EditCtrl);

        LabelCtrl.Top := 2;
        LabelCtrl.Align := alTop;
        LabelCtrl.Hint := ObjectEditorSupport.OEPropertyHint[I];
        EditCtrl.Top := LabelCtrl.Top + LabelCtrl.Height;
        EditCtrl.Align := alTop;
        EditCtrl.Hint := ObjectEditorSupport.OEPropertyHint[I];

        Panel.Height := LabelCtrl.Height + EditCtrl.Height + 4;
        *)
        Panel.Hint := ObjectEditorSupport.OEPropertyHint[I];
        Panel.Enabled := ObjectEditorSupport.OEPropertyEnabled[I];
        Panel.Visible := ObjectEditorSupport.OEPropertyVisible[I];
      end;

      ClassPanel.Tag := 1;
    end;

    for I := 0 to ObjectEditorSupport.OEPropertyCount - 1 do
      for C := 0 to Owner.ComponentCount - 1 do
        if (Owner.Components[C].Name = Instance.ClassName + '.E' + String(ObjectEditorSupport.OEPropertyName[I])) then
          if Supports(Owner.Components[C], IJvDynControlData, TmpData) then
            TmpData.ControlValue := ObjectEditorSupport.OEPropertyValue[I]
          else if Supports(Owner.Components[C], IJvDynControlCaption, TmpCaption) then
            TmpCaption.ControlCaption := Format(SObjectEditorEditObject, [ObjectEditorSupport.OEPropertyCaption[I]])
//          else if Supports(Owner.Components[C], IJvDynControlData, TmpData) then
          else
            raise EGSObjectEditor.CreateResFmt(@SObjectEditorErrorNoDataSupport, [ObjectEditorSupport.OEPropertyName[I], Instance.ClassName]);

  end
  else
  begin
  end;
end;

destructor TGSObjectEditorControl.Destroy;
begin
  DestroyControls;

  inherited;
end;

procedure TGSObjectEditorControl.DestroyControls;
begin
  FPanels.Free;
  FreeAndNil(FScrollBox);
end;

procedure TGSObjectEditorControl.SetInstance(const Value: TPersistent);
begin
  FInstance := Value;

  CreateControls;
end;

procedure TGSObjectEditorControl.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

{ TGSObjectEditorForm }

procedure TGsObjectEditorForm.CancelButtonClick(Sender: TObject);
begin
  // do not remove
end;

procedure TGsObjectEditorForm.CreateFormControls;
var
  BottomPanel: TWinControl;
  Button: TWinControl;
  TmpBevelBorder: IJvDynControlBevelBorder;
  DynCtrlButton: IGSDynControlButton;
begin
  BottomPanel := DefaultDynControlEngine.CreatePanel(Self, Self, 'BottomPanel', '', alBottom);

  Button := DefaultDynControlEngine.CreateButton(Self, BottomPanel, 'OKButton', SObjectEditorDialogButtonOk, '', OkButtonClick);
  Button.Align := alNone;
  Button.Top := 3;
  Button.Width := 75;
  Button.Height := 25;
  Button.Left := BottomPanel.Width - 2 * Button.Width - 10;
  Button.Anchors := [akTop, akRight];

  if Supports(Button, IGSDynControlButton, DynCtrlButton) then
    DynCtrlButton.ControlSetModalResult(mrOk);

  Button := DefaultDynControlEngine.CreateButton(Self, BottomPanel, 'CancelButton', SObjectEditorDialogButtonCancel, '', CancelButtonClick);
  Button.Align := alNone;
  Button.Top := 3;
  Button.Width := 75;
  Button.Height := 25;
  Button.Left := BottomPanel.Width - Button.Width - 5;
  Button.Anchors := [akTop, akRight];

  if Supports(Button, IGSDynControlButton, DynCtrlButton) then
    DynCtrlButton.ControlSetModalResult(mrCancel);

  FObjectEditorControl := TGSObjectEditorControl.Create(Self);
  FObjectEditorControl.Parent := Self;
  FObjectEditorControl.TabOrder := 0;
  FObjectEditorControl.Align := alClient;

  BottomPanel.Height := 2 * Button.Top + Button.Height + 1;
  BottomPanel.TabOrder := 1;
  BottomPanel.Align := alBottom;

  if Supports(BottomPanel, IJvDynControlBevelBorder, TmpBevelBorder) then
    TmpBevelBorder.ControlSetBevelOuter(bvNone);
end;

procedure TGsObjectEditorForm.DestroyFormControls;
begin
  FreeAndNil(FObjectEditorControl);
end;

procedure TGsObjectEditorForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //
end;

procedure TGsObjectEditorForm.FormCreate(Sender: TObject);
begin
  CreateFormControls;
end;

procedure TGsObjectEditorForm.FormDestroy(Sender: TObject);
begin
  DestroyFormControls;
end;

procedure TGsObjectEditorForm.FormShow(Sender: TObject);
var
  TmpObjectEditor: IGSObjectEditorSupport;
begin
  if Supports(Instance, IGSObjectEditorSupport, TmpObjectEditor) then
    Caption := Format(SObjectEditorDialogCaptionEditPropertiesOf, [TmpObjectEditor.OEObjectCaption])
  else
    Caption := SObjectEditorDialogCaptionEditProperties;
end;

function TGsObjectEditorForm.GetInstance: TPersistent;
begin
  Result := FObjectEditorControl.Instance;
end;

function TGsObjectEditorForm.GetReadOnly: Boolean;
begin
  Result := FObjectEditorControl.ReadOnly;
end;

procedure TGsObjectEditorForm.OkButtonClick(Sender: TObject);
begin
  // do not remove
end;

procedure TGsObjectEditorForm.SetInstance(const Value: TPersistent);
begin
  FObjectEditorControl.Instance := Value;
end;

procedure TGsObjectEditorForm.SetReadOnly(const Value: Boolean);
begin
  FObjectEditorControl.ReadOnly := Value;
end;

{ TGSObjectEditorImpl }

procedure TGSObjectEditorImpl.Assign(Source: TPersistent);
var
  SourceObjectEditorSupport: IGSObjectEditorSupport;
  I: Integer;
  SrcObj,
  DstObj: TObject;
begin
  if Supports(Source, IGSObjectEditorSupport, SourceObjectEditorSupport) then
    for I := 0 to OEPropertyCount - 1 do
    begin
      case OEPropertyInfo[I]^.PropType^^.Kind of
        tkInteger, tkChar, tkEnumeration, tkSet, tkWChar:
          SetOrdProp(FOwner, OEPropertyInfo[I], GetOrdProp(Source, SourceObjectEditorSupport.OEPropertyInfo[I]));
        tkFloat:
          SetFloatProp(FOwner, OEPropertyInfo[I], GetFloatProp(Source, SourceObjectEditorSupport.OEPropertyInfo[I]));
        tkString, tkLString:
          SetStrProp(FOwner, OEPropertyInfo[I], GetStrProp(Source, SourceObjectEditorSupport.OEPropertyInfo[I]));
        tkClass:
        begin
          SrcObj := GetObjectProp(Source, SourceObjectEditorSupport.OEPropertyInfo[I]);
          DstObj := GetObjectProp(FOwner, OEPropertyInfo[I]);

          if (SrcObj is TPersistent) and (DstObj is TPersistent) then
            (DstObj as TPersistent).Assign(SrcObj as TPersistent)
          else
            raise EPropertyConvertError.CreateResFmt(@SInvalidPropertyType, [SourceObjectEditorSupport.OEPropertyInfo[I]^.PropType^^.Name]);
        end;
//        tkMethod:
//          Result := PropInfo^.PropType^.Name;
        tkWString:
          SetWideStrProp(FOwner, OEPropertyInfo[I], GetWideStrProp(Source, SourceObjectEditorSupport.OEPropertyInfo[I]));
        tkVariant:
          SetVariantProp(FOwner, OEPropertyInfo[I], GetVariantProp(Source, SourceObjectEditorSupport.OEPropertyInfo[I]));
//        tkArray:
//        tkRecord:
//        tkInterface:
        tkInt64:
          SetInt64Prop(FOwner, OEPropertyInfo[I], GetInt64Prop(Source, SourceObjectEditorSupport.OEPropertyInfo[I]));
//        tkDynArray:
//          SetInt64Prop(FOwner, OEPropertyInfo[I], GetInt64Prop(Source, SourceObjectEditorSupport.OEPropertyInfo[I]));
//          DynArrayToVariant(Result, Pointer(GetOrdProp(Instance, PropInfo)), PropInfo^.PropType^);
      else
        raise EPropertyConvertError.CreateResFmt(@SInvalidPropertyType, [SourceObjectEditorSupport.OEPropertyInfo[I]^.PropType^^.Name]);
      end;
    end;
end;

function TGSObjectEditorImpl.Clone: TPersistent;
begin
//  _CopyObject()
  if (FOwner is TGSOEComponent) then
    Result := TGSOEComponent(FOwner.NewInstance)
  else
    Result := TGSOEPersistent(FOwner.NewInstance);

  try
    if (FOwner is TGSOEComponent) then
      TGSOEComponent(Result).Create(TGSOEComponent(FOwner).Owner)
    else
      TGSOEPersistent(Result).Create;

    (*
    FOwner.NewInstance
    if (FOwner is TGSOEComponent) then
      Result := TGSOEComponent(FOwner.ClassType).Create(TGSOEComponent(FOwner).Owner)
    else
      Result := TGSOEPersistent(FOwner.ClassType).Create;
    *)

    Result.Assign(FOwner);
  except
    Result.Free;
    raise;
  end;
end;

constructor TGSObjectEditorImpl.Create(AOwner: TPersistent);
begin
  inherited Create;

  if not Assigned(AOwner) then
    raise EGSObjectEditor.CreateRes(@SErrorNoOwner);

  if not Supports(AOwner, IGSObjectEditorSupport, FObjectEditorSupport) then
    raise EGSObjectEditor.CreateRes(@SErrorMissingInterface);

  FOwner := AOwner;
  FOEObjectName := '';
  FOEObjectCaption := '';
  FOEObjectEnabled := True;
  FOEObjectHint := '';
  FOEObjectVisible := True;
end;

destructor TGSObjectEditorImpl.Destroy;
begin
  if (FPropertyList <> nil) then
    FreeMem(FPropertyList);

  FObjectEditorSupport := nil;

  inherited;
end;

function TGSObjectEditorImpl.GetObjectEditorSupport: IGSObjectEditorSupport;
begin
  Result := FObjectEditorSupport;
end;

function TGSObjectEditorImpl.GetOEObjectCaption: String;
begin
  if (FOEObjectCaption = '') then
    FOEObjectCaption := ObjectEditorSupport.OEObjectName;

  Result := FOEObjectCaption;
end;

function TGSObjectEditorImpl.GetOEObjectEnabled: Boolean;
begin
  Result := FOEObjectEnabled;
end;

function TGSObjectEditorImpl.GetOEObjectHint: String;
begin
  Result := FOEObjectHint;
end;

function TGSObjectEditorImpl.GetOEObjectInfo: PTypeInfo;
begin
  Result := PTypeInfo(FOwner.ClassInfo);
end;

function TGSObjectEditorImpl.GetOEObjectName: String;
begin
  if (FOEObjectName = '') then
    FOEObjectName := FOwner.ClassName;

  Result := FOEObjectName;
end;

function TGSObjectEditorImpl.GetOEObjectVisible: Boolean;
begin
  Result := FOEObjectVisible;
end;

function TGSObjectEditorImpl.GetOEPropertyCaption(Index: Integer): String;
begin
  Result := String(ObjectEditorSupport.OEPropertyName[Index]);
end;

function TGSObjectEditorImpl.GetOEPropertyCount: Integer;
begin
  Result := GetTypeData(ObjectEditorSupport.OEObjectInfo)^.PropCount;
end;

function TGSObjectEditorImpl.GetOEPropertyEditClass(
  Index: Integer): TGSObjectEditorPropertyEditClass;
var
  V: Variant;
begin
  Result := nil;

  case ObjectEditorSupport.OEPropertyInfo[Index]^.PropType^^.Kind of
    tkInteger,
    tkFloat,
    tkInt64:
      Result := TGSDynControlRCNumericEdit;
    tkChar,
    tkString,
    tkWChar,
    tkLString,
    tkWString:
      Result := TGSDynControlRCEdit;
    tkEnumeration:
      Result := TGSDynControlRCComboBox;
    tkSet:
      Result := TGSDynControlRCCheckListBox;
    tkClass:
      Result := TGSDynControlRCButton;
    tkVariant: begin
      V := GetVariantProp(FOwner, String(ObjectEditorSupport.OEPropertyName[Index]));

      if VarIsNumeric(V) or VarIsError(V) then
        Result := TGSDynControlRCNumericEdit
      else if VarIsStr(V) then
        Result := TGSDynControlRCEdit
//      else if VarIsArray(V) then
    end;
  end;

  (*
    tkUnknown,
    tkClass,
    tkMethod,
    tkArray,
    tkRecord,
    tkInterface,
    tkDynArray
  Result := t
  *)
end;

function TGSObjectEditorImpl.GetOEPropertyEnabled(Index: Integer): Boolean;
begin
  Result := True;
end;

function TGSObjectEditorImpl.GetOEPropertyHint(Index: Integer): String;
begin
  Result := '';
end;

function TGSObjectEditorImpl.GetOEPropertyInfo(Index: Integer): PPropInfo;
var
  Count: Integer;
begin
  Result := nil;

  if (FPropertyList = nil) then
    Count := GetPropList(FOwner, FPropertyList);

  if (Count > 0) then
    if (Index >= Low(FPropertyList^)) and (Index <= High(FPropertyList^)) then
      Result := FPropertyList^[Index];
end;

function TGSObjectEditorImpl.GetOEPropertyName(Index: Integer): TSymbolName;
begin
  Result := ObjectEditorSupport.OEPropertyInfo[Index]^.Name;
end;

function TGSObjectEditorImpl.GetOEPropertyValue(Index: Integer): String;
begin
  Result := GetPropValue(FOwner, String(ObjectEditorSupport.OEPropertyName[Index]), True);
end;

function TGSObjectEditorImpl.GetOEPropertyVisible(Index: Integer): Boolean;
begin
  Result := True;
end;

procedure TGSObjectEditorImpl.LoadDefsFromFile(const FileName: String);
begin

end;

procedure TGSObjectEditorImpl.LoadDefsFromStream(Stream: TStream);
begin

end;

procedure TGSObjectEditorImpl.LoadFromFile(const FileName: String);
begin

end;

procedure TGSObjectEditorImpl.LoadFromStream(Stream: TStream);
begin

end;

function TGSObjectEditorImpl.OEPropertyIndexOfName(
  const AName: String): Integer;
begin
  Result := 0;

  while (Result < OEPropertyCount) do
    if (CompareText(String(OEPropertyName[Result]), AName) = 0) then
      Exit
    else
      Inc(Result);

  Result := -1;
end;

procedure TGSObjectEditorImpl.SaveDefsToFile(const FileName: String);
begin

end;

procedure TGSObjectEditorImpl.SaveDefsToStream(Stream: TStream);
begin

end;

procedure TGSObjectEditorImpl.SaveToFile(const FileName: String);
begin

end;

procedure TGSObjectEditorImpl.SaveToStream(Stream: TStream);
begin

end;

procedure TGSObjectEditorImpl.SetOEPropertyValue(Index: Integer;
  const Value: String);
begin
  SetPropValue(FOwner, String(ObjectEditorSupport.OEPropertyName[Index]), Value);
end;

{ TGSOEPersistent }

procedure TGSOEPersistent.Assign(Source: TPersistent);
begin
  if (Source.ClassType = Self.ClassType) then
    ObjectEditorImpl.Assign(Source)
  else
    inherited;
end;

function TGSOEPersistent.Clone: TPersistent;
begin
  Result := ObjectEditorImpl.Clone;
end;

destructor TGSOEPersistent.Destroy;
begin
  if Assigned(FObjectEditorImpl) then
    FObjectEditorImpl.Free;

  inherited;
end;

function TGSOEPersistent.GetObjectEditorImpl: TGSObjectEditorImpl;
begin
  if not Assigned(FObjectEditorImpl) then
    FObjectEditorImpl := TGSObjectEditorImpl.Create(Self);

  Result := FObjectEditorImpl;
end;

function TGSOEPersistent.GetObjectEditorSupport: IGSObjectEditorSupport;
begin
  Result := ObjectEditorImpl.ObjectEditorSupport;
end;

function TGSOEPersistent.GetOEObjectCaption: String;
begin
  Result := ObjectEditorImpl.OEObjectCaption;
end;

function TGSOEPersistent.GetOEObjectEnabled: Boolean;
begin
  Result := ObjectEditorImpl.OEObjectEnabled;
end;

function TGSOEPersistent.GetOEObjectHint: String;
begin
  Result := ObjectEditorImpl.OEObjectHint;
end;

function TGSOEPersistent.GetOEObjectInfo: PTypeInfo;
begin
  Result := ObjectEditorImpl.OEObjectInfo;
end;

function TGSOEPersistent.GetOEObjectName: String;
begin
  Result := ObjectEditorImpl.OEObjectName;
end;

function TGSOEPersistent.GetOEObjectVisible: Boolean;
begin
  Result := ObjectEditorImpl.OEObjectVisible;
end;

function TGSOEPersistent.GetOEPropertyCaption(Index: Integer): String;
begin
  Result := ObjectEditorImpl.OEPropertyCaption[Index];
end;

function TGSOEPersistent.GetOEPropertyCount: Integer;
begin
  Result := ObjectEditorImpl.OEPropertyCount;
end;

function TGSOEPersistent.GetOEPropertyEditClass(
  Index: Integer): TGSObjectEditorPropertyEditClass;
begin
  Result := ObjectEditorImpl.OEPropertyEditClass[Index];
end;

function TGSOEPersistent.GetOEPropertyEnabled(Index: Integer): Boolean;
begin
  Result := ObjectEditorImpl.OEPropertyEnabled[Index];
end;

function TGSOEPersistent.GetOEPropertyHint(Index: Integer): String;
begin
  Result := ObjectEditorImpl.OEPropertyHint[Index];
end;

function TGSOEPersistent.GetOEPropertyInfo(Index: Integer): PPropInfo;
begin
  Result := ObjectEditorImpl.OEPropertyInfo[Index];
end;

function TGSOEPersistent.GetOEPropertyName(Index: Integer): TSymbolName;
begin
  Result := ObjectEditorImpl.OEPropertyName[Index];
end;

function TGSOEPersistent.GetOEPropertyValue(Index: Integer): String;
begin
  Result := ObjectEditorImpl.OEPropertyValue[Index];
end;

function TGSOEPersistent.GetOEPropertyVisible(Index: Integer): Boolean;
begin
  Result := ObjectEditorImpl.OEPropertyVisible[Index];
end;

procedure TGSOEPersistent.LoadDefsFromFile(const FileName: String);
begin

end;

procedure TGSOEPersistent.LoadDefsFromStream(Stream: TStream);
begin

end;

procedure TGSOEPersistent.LoadFromFile(const FileName: String);
begin

end;

procedure TGSOEPersistent.LoadFromStream(Stream: TStream);
begin

end;

function TGSOEPersistent.OEPropertyIndexOfName(
  const AName: String): Integer;
begin
  Result := ObjectEditorImpl.OEPropertyIndexOfName(AName);
end;

procedure TGSOEPersistent.SaveDefsToFile(const FileName: String);
begin

end;

procedure TGSOEPersistent.SaveDefsToStream(Stream: TStream);
begin

end;

procedure TGSOEPersistent.SaveToFile(const FileName: String);
begin

end;

procedure TGSOEPersistent.SaveToStream(Stream: TStream);
begin

end;

procedure TGSOEPersistent.SetOEPropertyValue(Index: Integer;
  const Value: String);
begin
  ObjectEditorImpl.OEPropertyValue[Index] := Value;
end;

{ TGSOEComponent }

procedure TGSOEComponent.Assign(Source: TPersistent);
begin
  if (Source.ClassType = Self.ClassType) then
    ObjectEditorImpl.Assign(Source)
  else
    inherited;
end;

function TGSOEComponent.Clone: TPersistent;
begin
  Result := ObjectEditorImpl.Clone;
end;

destructor TGSOEComponent.Destroy;
begin
  if Assigned(FObjectEditorImpl) then
    FObjectEditorImpl.Free;

  inherited;
end;

function TGSOEComponent.GetObjectEditorImpl: TGSObjectEditorImpl;
begin
  if not Assigned(FObjectEditorImpl) then
    FObjectEditorImpl := TGSObjectEditorImpl.Create(Self);

  Result := FObjectEditorImpl;
end;

function TGSOEComponent.GetObjectEditorSupport: IGSObjectEditorSupport;
begin
  Result := ObjectEditorImpl.ObjectEditorSupport;
end;

function TGSOEComponent.GetOEObjectCaption: String;
begin
  Result := ObjectEditorImpl.OEObjectCaption;
end;

function TGSOEComponent.GetOEObjectEnabled: Boolean;
begin
  Result := ObjectEditorImpl.OEObjectEnabled;
end;

function TGSOEComponent.GetOEObjectHint: String;
begin
  Result := ObjectEditorImpl.OEObjectHint;
end;

function TGSOEComponent.GetOEObjectInfo: PTypeInfo;
begin
  Result := ObjectEditorImpl.OEObjectInfo;
end;

function TGSOEComponent.GetOEObjectName: String;
begin
  Result := ObjectEditorImpl.OEObjectName;
end;

function TGSOEComponent.GetOEObjectVisible: Boolean;
begin
  Result := ObjectEditorImpl.OEObjectVisible;
end;

function TGSOEComponent.GetOEPropertyCaption(Index: Integer): String;
begin
  Result := ObjectEditorImpl.OEPropertyCaption[Index];
end;

function TGSOEComponent.GetOEPropertyCount: Integer;
begin
  Result := ObjectEditorImpl.OEPropertyCount;
end;

function TGSOEComponent.GetOEPropertyEditClass(
  Index: Integer): TGSObjectEditorPropertyEditClass;
begin
  Result := ObjectEditorImpl.OEPropertyEditClass[Index];
end;

function TGSOEComponent.GetOEPropertyEnabled(Index: Integer): Boolean;
begin
  Result := ObjectEditorImpl.OEPropertyEnabled[Index];
end;

function TGSOEComponent.GetOEPropertyHint(Index: Integer): String;
begin
  Result := ObjectEditorImpl.OEPropertyHint[Index];
end;

function TGSOEComponent.GetOEPropertyInfo(Index: Integer): PPropInfo;
begin
  Result := ObjectEditorImpl.OEPropertyInfo[Index];
end;

function TGSOEComponent.GetOEPropertyName(Index: Integer): TSymbolName;
begin
  Result := ObjectEditorImpl.OEPropertyName[Index];
end;

function TGSOEComponent.GetOEPropertyValue(Index: Integer): String;
begin
  Result := ObjectEditorImpl.OEPropertyValue[Index];
end;

function TGSOEComponent.GetOEPropertyVisible(Index: Integer): Boolean;
begin
  Result := ObjectEditorImpl.OEPropertyVisible[Index];
end;

procedure TGSOEComponent.LoadDefsFromFile(const FileName: String);
begin

end;

procedure TGSOEComponent.LoadDefsFromStream(Stream: TStream);
begin

end;

procedure TGSOEComponent.LoadFromFile(const FileName: String);
begin

end;

procedure TGSOEComponent.LoadFromStream(Stream: TStream);
begin

end;

function TGSOEComponent.OEPropertyIndexOfName(
  const AName: String): Integer;
begin
  Result := ObjectEditorImpl.OEPropertyIndexOfName(AName);
end;

procedure TGSOEComponent.SaveDefsToFile(const FileName: String);
begin

end;

procedure TGSOEComponent.SaveDefsToStream(Stream: TStream);
begin

end;

procedure TGSOEComponent.SaveToFile(const FileName: String);
begin

end;

procedure TGSOEComponent.SaveToStream(Stream: TStream);
begin

end;

procedure TGSOEComponent.SetOEPropertyValue(Index: Integer;
  const Value: String);
begin
  ObjectEditorImpl.OEPropertyValue[Index] := Value;
end;

initialization
  DefaultDynControlEngine.RegisterControlType(jctGSObjectEditor, TGSObjectEditorControl);
end.
