unit GsSPop3;

{$I gsdl.inc}

interface

uses
  BPSettings,
  BPSettingsEditorIntf,
  Classes,
  IdAssignedNumbers,
  IdExplicitTLSClientServerBase,
  IdPOP3,
  GsSIdTLS,
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  TGsSPop3 = class(TCustomBPSubSettings)
  private
    FHost:            TBPSPString;
    FPort:            TBPSPInteger;
    FUsername:        TBPSPString;
    FPassword:        TBPSPPassword;
    FDefaultHost:     string;
    FDefaultPort:     Integer;
    FDefaultUsername: string;
    FDefaultPassword: string;
    function GetHost: string;
    function GetPassword: string;
    function GetPort: Word;
    function GetUsername: string;
    procedure SetHost(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetPort(const Value: Word);
    procedure SetUsername(const Value: string);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    constructor CreatePop3(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      ADefaultHost: string = ''; ADefaultPort: Word = Id_PORT_submission; ADefaultUsername: string = '';
      ADefaultPassword: string = ''); virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); override;

    { TPersistent }
    //procedure Assign(Source: TPersistent); override;

    { Settings properties }
    property _Host: TBPSPString read FHost;
    property _Port: TBPSPInteger read FPort;
    property _Username: TBPSPString read FUsername;
    property _Password: TBPSPPassword read FPassword;

    { Easy property access }
    property Host: string read GetHost write SetHost;
    property Port: Word read GetPort write SetPort;
    property Username: string read GetUsername write SetUsername;
    property Password: string read GetPassword write SetPassword;
  end;

  TGsSPIdPOP3AuthType = class(TCustomBPSettingsEnumProperty,
    IBPSettingsEditorOrdinalPropertySupport,
    IBPSettingsEditorEnumPropertySupport,
    IBPSettingsEditorComboBoxSupport)
  private
    FValue:        TIdPOP3AuthenticationType;
    FDefaultValue: TIdPOP3AuthenticationType;
  protected
    { IBPSettingsEditorEnumPropertySupport }
    //function GetEnumCaptionLocalized(AEnumValue: Longint): String; override;

    { Property access }
    function GetDefaultValue: TIdPOP3AuthenticationType; virtual;
    function GetValue: TIdPOP3AuthenticationType; virtual;
    procedure SetDefaultValue(const Value: TIdPOP3AuthenticationType); virtual;
    procedure SetValue(const Value: TIdPOP3AuthenticationType); virtual;
  public
    constructor CreateIdPOP3AuthType(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec; ADefaultValue: TIdPOP3AuthenticationType = DEF_ATYPE);
      virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); override;
  published
    { Properties }
    property Value: TIdPOP3AuthenticationType read GetValue write SetValue;
    property DefaultValue: TIdPOP3AuthenticationType read GetDefaultValue write SetDefaultValue;
  end;

  TGsSIdPop3 = class(TGsSPop3)
  private
    FAuthType:        TGsSPIdPOP3AuthType;
    FDefaultAuthType: TIdPOP3AuthenticationType;
    FAutoLogin:       TBPSPBoolean;
    FUseTLS:          TGsSPIdUseTLS;
    FDefaultUseTLS:   TIdUseTLS;
    function GetAuthType: TIdPOP3AuthenticationType;
    function GetAutoLogin: Boolean;
    function GetUseTLS: TIdUseTLS;
    procedure SetAuthType(const Value: TIdPOP3AuthenticationType);
    procedure SetAutoLogin(const Value: Boolean);
    procedure SetUseTLS(const Value: TIdUseTLS);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    constructor CreateIdPop3(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      ADefaultHost: string = ''; ADefaultPort: Word = Id_PORT_submission; ADefaultUsername: string = '';
      ADefaultPassword: string = ''; ADefaultAuthType: TIdPOP3AuthenticationType = DEF_ATYPE;
      ADefaultUseTLS: TIdUseTLS = DEF_USETLS); virtual;

    { Settings properties }
    property _AuthType: TGsSPIdPOP3AuthType read FAuthType;
    property _AutoLogin: TBPSPBoolean read FAutoLogin;
    property _UseTLS: TGsSPIdUseTLS read FUseTLS;

    { Easy property access }
    property AuthType: TIdPOP3AuthenticationType read GetAuthType write SetAuthType;
    property AutoLogin: Boolean read GetAutoLogin write SetAutoLogin;
    property UseTLS: TIdUseTLS read GetUseTLS write SetUseTLS;
  end;

implementation

{ TGsSPop3 }

procedure TGsSPop3.AssignTo(Dest: TPersistent);
begin
  if Dest is TIdPOP3 then
  begin
    with TIdPOP3(Dest) do
    begin
      Host     := Self.Host;
      Port     := Self.Port;
      Username := Self.Username;
      Password := Self.Password;
    end;
  end
  else
    inherited;
end;

constructor TGsSPop3.Create(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
  AImageIndex: TImageIndex);
begin
  CreatePop3(AOwner, AName, CaptionRes, HintRes);
end;

procedure TGsSPop3.CreateProperties;
resourcestring
  SHost         = 'Hostname';
  SHostHint     = 'Name des POP3 Servers für den Empfang.';
  SPort         = 'Port';
  SPortHint     = 'TCP Port des POP3 Servers für den Empfang.';
  SUsername     = 'Benutzername';
  SUsernameHint = 'Name des Benutzers für den Empfang.';
  SPassword     = 'Kennwort';
  SPasswordHint = 'Kennwort des Benutzers für den Empfang.';
begin
  inherited;

  FHost     := TBPSPString.CreateString(Self, 'Host', @SHost, @SHostHint, FDefaultHost);
  FPort     := TBPSPInteger.CreateInteger(Self, 'Port', @SPort, @SPortHint, FDefaultPort);
  FUsername := TBPSPString.CreateString(Self, 'Username', @SUsername, @SUsernameHint, FDefaultUsername);
  FPassword := TBPSPPassword.CreateString(Self, 'Password', @SPassword, @SPasswordHint, FDefaultPassword);
end;

constructor TGsSPop3.CreatePop3(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
  ADefaultHost: string; ADefaultPort: Word; ADefaultUsername, ADefaultPassword: string);
begin
  FDefaultHost     := ADefaultHost;
  FDefaultPort     := ADefaultPort;
  FDefaultUsername := ADefaultUsername;
  FDefaultPassword := ADefaultPassword;

  inherited Create(AOwner, AName, CaptionRes, HintRes);
end;

function TGsSPop3.GetHost: string;
begin
  Result := _Host.Value;
end;

function TGsSPop3.GetPassword: string;
begin
  Result := _Password.Value;
end;

function TGsSPop3.GetPort: Word;
begin
  Result := _Port.Value;
end;

function TGsSPop3.GetUsername: string;
begin
  Result := _Username.Value;
end;

procedure TGsSPop3.SetHost(const Value: string);
begin
  _Host.Value := Value;
end;

procedure TGsSPop3.SetPassword(const Value: string);
begin
  _Password.Value := Value;
end;

procedure TGsSPop3.SetPort(const Value: Word);
begin
  _Port.Value := Value;
end;

procedure TGsSPop3.SetUsername(const Value: string);
begin
  _Username.Value := Value;
end;

{ TGsSPIdPOP3AuthType }

constructor TGsSPIdPOP3AuthType.Create(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateIdPOP3AuthType(AOwner, AName, CaptionRes, HintRes);
end;

constructor TGsSPIdPOP3AuthType.CreateIdPOP3AuthType(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec; ADefaultValue: TIdPOP3AuthenticationType);
begin
  inherited Create(AOwner, AName, CaptionRes, HintRes);

  FValue        := ADefaultValue;
  FDefaultValue := ADefaultValue;
end;

function TGsSPIdPOP3AuthType.GetDefaultValue: TIdPOP3AuthenticationType;
begin
  Result := FDefaultValue;
end;

function TGsSPIdPOP3AuthType.GetValue: TIdPOP3AuthenticationType;
begin
  Result := FValue;
end;

procedure TGsSPIdPOP3AuthType.SetDefaultValue(const Value: TIdPOP3AuthenticationType);
begin
  FDefaultValue := Value;
end;

procedure TGsSPIdPOP3AuthType.SetValue(const Value: TIdPOP3AuthenticationType);
begin
  if (Value <> FValue) then
  begin
    FValue := Value;
    Change;
  end;
end;

{ TGsSIdPop3 }

procedure TGsSIdPop3.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TIdPOP3 then
  begin
    with TIdPOP3(Dest) do
    begin
      AuthType := Self.AuthType;
      AutoLogin := Self.AutoLogin;
      UseTLS   := Self.UseTLS;
    end;
  end;
end;

constructor TGsSIdPop3.CreateIdPop3(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec; ADefaultHost: string; ADefaultPort: Word;
  ADefaultUsername, ADefaultPassword: string; ADefaultAuthType: TIdPOP3AuthenticationType; ADefaultUseTLS: TIdUseTLS);
begin
  FDefaultAuthType := ADefaultAuthType;
  FDefaultUseTLS   := ADefaultUseTLS;

  CreatePop3(AOwner, AName, CaptionRes, HintRes, ADefaultHost,
    ADefaultPort, ADefaultUsername, ADefaultPassword);
end;

procedure TGsSIdPop3.CreateProperties;
resourcestring
  SAuthType      = 'Authentifizierung';
  SAuthTypeHint  = '';
  SAutoLogin     = 'Automatische Anmeldung';
  SAutoLoginHint = '';
  SUseTLS        = 'Benutze TLS';
  SUseTLSHint    = '';
begin
  inherited;

  FAuthType  := TGsSPIdPOP3AuthType.CreateIdPOP3AuthType(Self, 'AuthType', @SAuthType,
    @SAuthTypeHint, FDefaultAuthType);
  FAutoLogin := TBPSPBoolean.CreateBoolean(Self, 'AutoLogin', @SAutoLogin, @SAutoLoginHint, True);
  FUseTLS    := TGsSPIdUseTLS.CreateIdUseTLS(Self, 'UseTLS', @SUseTLS, @SUseTLSHint, FDefaultUseTLS);
end;

function TGsSIdPop3.GetAuthType: TIdPOP3AuthenticationType;
begin
  Result := FAuthType.Value;
end;

function TGsSIdPop3.GetAutoLogin: Boolean;
begin
  Result := FAutoLogin.Value;
end;

function TGsSIdPop3.GetUseTLS: TIdUseTLS;
begin
  Result := FUseTLS.Value;
end;

procedure TGsSIdPop3.SetAuthType(const Value: TIdPOP3AuthenticationType);
begin
  FAuthType.Value := Value;
end;

procedure TGsSIdPop3.SetAutoLogin(const Value: Boolean);
begin
  FAutoLogin.Value := Value;
end;

procedure TGsSIdPop3.SetUseTLS(const Value: TIdUseTLS);
begin
  FUseTLS.Value := Value;
end;

end.

