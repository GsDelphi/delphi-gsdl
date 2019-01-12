unit GsSettingsDBSynDB;

{$I gsdl.inc}

interface

uses
  BPSettings,
  BPSettingsDB,
  BPSettingsIntf,
  BPSettingsEditorIntf,
  SynCommons,
  SynDB,
  mORMot,
  Classes,
  Forms,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  TSQLDBConnectionPropertiesClasses = array of TSQLDBConnectionPropertiesClass;
  TSQLRestClasses = array of TSQLRestClass;

  TBPSPSynDBKind = class(TBPSPString, IBPSettingsEditorOrdinalPropertySupport,
    IBPSettingsEditorEnumPropertySupport, IBPSettingsEditorComboBoxSupport)
  private
  protected
    function GetDefaultEditFrameClass: TCustomFrameClass; override;

    { IBPSettingsEditorComboBoxSupport }
    procedure GetValues(Proc: TGetValueStrProc); virtual;
    procedure SetValues(Func: TSetValueStrFunc); virtual;

    function IsClassAllowed(AClass: TClass): Boolean;
  public
    constructor CreateSynDBKind(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec; DefaultValue: string;
      AImageIndex: TImageIndex = -1); virtual;
    constructor CreateString(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec; DefaultValue: string;
      AImageIndex: TImageIndex = -1); override;

    class function GetEngineName(AClass: TClass): string;
  published
  end;

  TBPSSDBSynDB = class(TCustomBPSSDatabase)
  private
    FConnectionDefinition: TSynConnectionDefinition;
    FKind: TBPSPSynDBKind;
    FServerName: TBPSPString;
    FPropertiesClasses: TSQLDBConnectionPropertiesClasses;
    FRestClasses: TSQLRestClasses;
    FDatabaseName: TBPSPString;
    FDefaultKind: String;
    FDefaultServerName: String;
    FDefaultDatabaseName: string;
    function GetConnectionDefinition: TSynConnectionDefinition;
    function GetDatabaseName: string;
    function GetKind: string;
    function GetServerName: string;
    procedure SetDatabaseName(const Value: string);
    procedure SetKind(const Value: string);
    procedure SetServerName(const Value: string);
  protected
    procedure DoLoad; override;
    // procedure AssignTo(Dest: TPersistent); override;
    procedure CreateProperties; override;
    procedure PropChange(Sender: TObject);
    procedure UpdateConnectionDefinition;

    { Allow GUI access only, FConnectionDefinition holds data }
    property _Kind: TBPSPSynDBKind read FKind;
    property _ServerName: TBPSPString read FServerName;
    property _DatabaseName: TBPSPString read FDatabaseName;
    property _User;
    property _Password;
  public
    constructor CreateDBSynDB(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec;
      PropertiesClasses: array of TSQLDBConnectionPropertiesClass;
      RestClasses: array of TSQLRestClass; AImageIndex: TImageIndex = -1;
      DefaultKind: string = ''; DefaultServerName: string = '';
      DefaultDatabaseName: string = ''; DefaultUser: string = '';
      DefaultPassword: string = ''); virtual;
    constructor CreateDatabase(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex = -1;
      DefaultUser: string = ''; DefaultPassword: string = '';
      DefaultConnectionTimeout: Integer = 15;
      DefaultCommandTimeout: Integer = 30); override;
    destructor Destroy; override;

    function IsClassAllowed(AClass: TClass): Boolean;

    property ConnectionDefinition: TSynConnectionDefinition
      read GetConnectionDefinition;
  published
    property Kind: string read GetKind write SetKind;
    property ServerName: string read GetServerName write SetServerName;
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property User;
    property Password;
    property DefaultKind: string read FDefaultKind write FDefaultKind;
    property DefaultServerName: string read FDefaultServerName
      write FDefaultServerName;
    property DefaultDatabaseName: string read FDefaultDatabaseName
      write FDefaultDatabaseName;
    property DefaultUser;
    property DefaultPassword;
  end;

procedure RegisterClassForSettings(APropertiesClass
  : TSQLDBConnectionPropertiesClass); overload;
procedure RegisterClassForSettings(PropertiesClasses
  : TSQLDBConnectionPropertiesClasses); overload;
procedure RegisterClassForSettings(ARestClass: TSQLRestClass); overload;
procedure RegisterClassForSettings(RestClasses: TSQLRestClasses); overload;

function IsClassForSettings(APropertiesClass: TSQLDBConnectionPropertiesClass)
  : Boolean; overload;
function IsClassForSettings(ARestClass: TSQLRestClass): Boolean; overload;

implementation

uses
  SysUtils,
  BPSPEFComboBox;

var
  GlobalDefinitions: array of TClass;

procedure RegisterClassForSettings(APropertiesClass
  : TSQLDBConnectionPropertiesClass);
begin
  // TClass stored as TObject
  ObjArrayAddOnce(GlobalDefinitions, TObject(APropertiesClass));
end;

procedure RegisterClassForSettings(PropertiesClasses
  : TSQLDBConnectionPropertiesClasses);
var
  I: Integer;
begin
  for I := Low(PropertiesClasses) to High(PropertiesClasses) do
    RegisterClassForSettings(PropertiesClasses[I]);
end;

procedure RegisterClassForSettings(ARestClass: TSQLRestClass);
begin
  // TClass stored as TObject
  ObjArrayAddOnce(GlobalDefinitions, TObject(ARestClass));
end;

procedure RegisterClassForSettings(RestClasses: TSQLRestClasses);
var
  I: Integer;
begin
  for I := Low(RestClasses) to High(RestClasses) do
    RegisterClassForSettings(RestClasses[I]);
end;

function IsClassForSettings(APropertiesClass
  : TSQLDBConnectionPropertiesClass): Boolean;
begin
  // TClass stored as TObject
  Result := ObjArrayFind(GlobalDefinitions, TObject(APropertiesClass)) <> -1;
end;

function IsClassForSettings(ARestClass: TSQLRestClass): Boolean;
begin
  // TClass stored as TObject
  Result := ObjArrayFind(GlobalDefinitions, TObject(ARestClass)) <> -1;
end;

{ TBPSPSynDBKind }

constructor TBPSPSynDBKind.CreateString(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; DefaultValue: string;
  AImageIndex: TImageIndex);
begin
  CreateSynDBKind(AOwner, AName, CaptionRes, HintRes, DefaultValue,
    AImageIndex);
end;

constructor TBPSPSynDBKind.CreateSynDBKind(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; DefaultValue: string;
  AImageIndex: TImageIndex);
begin
  inherited CreateString(AOwner, AName, CaptionRes, HintRes, DefaultValue,
    AImageIndex);
end;

function TBPSPSynDBKind.GetDefaultEditFrameClass: TCustomFrameClass;
begin
  Result := TBPSPComboBoxEditFrame;
end;

class function TBPSPSynDBKind.GetEngineName(AClass: TClass): string;
begin
  if AClass.InheritsFrom(TSQLDBConnectionProperties) then
    Result := string(TSQLDBConnectionPropertiesClass(AClass).EngineName)
  else if AClass.InheritsFrom(TSQLRest) then
  begin
    Result := AClass.ClassName;
    if IdemPChar(Pointer(Result), 'TSQL') then
      Delete(Result, 1, 8)
    else if Result[1] = 'T' then
      Delete(Result, 1, 1);
  end
  else
    Result := ''
end;

procedure TBPSPSynDBKind.GetValues(Proc: TGetValueStrProc);
var
  I: Integer;
begin
  for I := 0 to Length(GlobalDefinitions) - 1 do
  begin
    if IsClassAllowed(GlobalDefinitions[I]) then
    begin
      Proc(GetEngineName(GlobalDefinitions[I]),
        Value = GlobalDefinitions[I].ClassName);
    end;
  end;
end;

function TBPSPSynDBKind.IsClassAllowed(AClass: TClass): Boolean;
begin
  if Parent is TBPSSDBSynDB then
    Result := TBPSSDBSynDB(Parent).IsClassAllowed(AClass)
  else
    Result := True;
end;

procedure TBPSPSynDBKind.SetValues(Func: TSetValueStrFunc);
var
  I: Integer;
begin
  for I := 0 to Length(GlobalDefinitions) - 1 do
  begin
    if IsClassAllowed(GlobalDefinitions[I]) and
      Func(GetEngineName(GlobalDefinitions[I])) then
    begin
      Value := GlobalDefinitions[I].ClassName;
      Exit;
    end;
  end;
end;

{ TBPSSDBSynDB }

constructor TBPSSDBSynDB.CreateDatabase(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex;
  DefaultUser, DefaultPassword: string; DefaultConnectionTimeout,
  DefaultCommandTimeout: Integer);
begin
  CreateDBSynDB(AOwner, AName, CaptionRes, HintRes, [], [], AImageIndex, '', '',
    '', DefaultUser, DefaultPassword);
end;

constructor TBPSSDBSynDB.CreateDBSynDB(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec;
  PropertiesClasses: array of TSQLDBConnectionPropertiesClass;
  RestClasses: array of TSQLRestClass; AImageIndex: TImageIndex;
  DefaultKind, DefaultServerName, DefaultDatabaseName, DefaultUser,
  DefaultPassword: string);
var
  I: Integer;
begin
  SetLength(FPropertiesClasses, Length(PropertiesClasses));
  for I := Low(PropertiesClasses) to High(PropertiesClasses) do
    FPropertiesClasses[I] := PropertiesClasses[I];

  SetLength(FRestClasses, Length(RestClasses));
  for I := Low(RestClasses) to High(RestClasses) do
    FRestClasses[I] := RestClasses[I];

  FDefaultKind := DefaultKind;
  FDefaultServerName := DefaultServerName;
  FDefaultDatabaseName := DefaultDatabaseName;

  inherited CreateDatabase(AOwner, AName, CaptionRes, HintRes, AImageIndex,
    DefaultUser, DefaultPassword);
end;

procedure TBPSSDBSynDB.CreateProperties;
resourcestring
  SKind = 'Provider';
  SKindHint = 'Treiber für den Datenbankzugriff.';
  SServerName = 'Servername';
  SServerNameHint =
    'Der Datenbankserver, zu welchem die Verbindung hergestellt wird.';
  SDatabaseName = 'Datenbank';
  SDatabaseNameHint =
    'Die Datenbank, welche für die Applikation verwendet wird.';
begin
  inherited;

  _User.EnabledAndVisible := True;
  _User.OnChange := PropChange;
  _Password.EnabledAndVisible := True;
  _Password.OnChange := PropChange;
  _ConnectionTimeout.EnabledAndVisible := False;
  _CommandTimeout.EnabledAndVisible := False;

  FKind := TBPSPSynDBKind.CreateSynDBKind(Self, 'Kind', @SKind, @SKindHint,
    FDefaultKind);
  FKind.OnChange := PropChange;
  FServerName := TBPSPString.CreateString(Self, 'ServerName', @SServerName,
    @SServerNameHint, FDefaultServerName);
  FServerName.OnChange := PropChange;
  FDatabaseName := TBPSPString.CreateString(Self, 'DatabaseName',
    @SDatabaseName, @SDatabaseNameHint, FDefaultDatabaseName);
  FDatabaseName.OnChange := PropChange;
end;

destructor TBPSSDBSynDB.Destroy;
begin
  if Assigned(FConnectionDefinition) then
    FreeAndNil(FConnectionDefinition);

  inherited;
end;

procedure TBPSSDBSynDB.DoLoad;
begin
  inherited DoLoad;

  UpdateConnectionDefinition;
end;

function TBPSSDBSynDB.GetConnectionDefinition: TSynConnectionDefinition;
begin
  if not Assigned(FConnectionDefinition) then
  begin
    FConnectionDefinition := TSynConnectionDefinition.Create;
    UpdateConnectionDefinition; // can force a single reecursion which is ok
  end;

  Result := FConnectionDefinition;
end;

function TBPSSDBSynDB.GetDatabaseName: string;
begin
  Result := string(FConnectionDefinition.DatabaseName);
end;

function TBPSSDBSynDB.GetKind: string;
begin
  Result := FConnectionDefinition.Kind;
end;

function TBPSSDBSynDB.GetServerName: string;
begin
  Result := string(FConnectionDefinition.ServerName);
end;

function TBPSSDBSynDB.IsClassAllowed(AClass: TClass): Boolean;
begin
  if AClass.InheritsFrom(TSQLDBConnectionProperties) then
    Result := IsClassForSettings(TSQLDBConnectionPropertiesClass(AClass))
  else if AClass.InheritsFrom(TSQLRest) then
    Result := IsClassForSettings(TSQLRestClass(AClass))
  else
    Result := False;
end;

procedure TBPSSDBSynDB.PropChange(Sender: TObject);
begin
  UpdateConnectionDefinition;
end;

procedure TBPSSDBSynDB.SetDatabaseName(const Value: string);
begin
  FConnectionDefinition.DatabaseName := RawUTF8(Value);
end;

procedure TBPSSDBSynDB.SetKind(const Value: string);
begin
  FConnectionDefinition.Kind := Value;
end;

procedure TBPSSDBSynDB.SetServerName(const Value: string);
begin
  FConnectionDefinition.ServerName := RawUTF8(Value);
end;

procedure TBPSSDBSynDB.UpdateConnectionDefinition;
begin
  ConnectionDefinition.Kind := Kind;
  ConnectionDefinition.ServerName := RawUTF8(ServerName);
  ConnectionDefinition.DatabaseName := RawUTF8(DatabaseName);
  ConnectionDefinition.User := RawUTF8(User);
  ConnectionDefinition.PassWordPlain := RawUTF8(Password);
end;

end.
