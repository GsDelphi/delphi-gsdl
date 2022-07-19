unit GsSSmtp;

{$I gsdl.inc}

interface

uses
  BPSettings,
  BPSettingsEditorIntf,
  Classes,
  GsSIdTLS,
  IdAssignedNumbers,
  IdExplicitTLSClientServerBase,
  IdSmtp,
  IdSmtpBase,
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  TGsSSmtp = class(TCustomBPSubSettings)
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
    constructor CreateSmtp(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
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

  TGsSPIdSMTPAuthenticationType = class(TCustomBPSettingsEnumProperty,
    IBPSettingsEditorOrdinalPropertySupport,
    IBPSettingsEditorEnumPropertySupport,
    IBPSettingsEditorComboBoxSupport)
  private
    FValue:        TIdSMTPAuthenticationType;
    FDefaultValue: TIdSMTPAuthenticationType;
  protected
    { IBPSettingsEditorEnumPropertySupport }
    function GetEnumCaptionLocalized(AEnumValue: Longint): string; override;

    { TGsSPIdSMTPAuthenticationType }
    function GetDefaultValue: TIdSMTPAuthenticationType; virtual;
    function GetValue: TIdSMTPAuthenticationType; virtual;
    procedure SetDefaultValue(const Value: TIdSMTPAuthenticationType); virtual;
    procedure SetValue(const Value: TIdSMTPAuthenticationType); virtual;
  public
    constructor CreateIdSMTPAuthenticationType(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec; ADefaultValue: TIdSMTPAuthenticationType = DEF_SMTP_AUTH); virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); override;
  published
    { Properties }
    property Value: TIdSMTPAuthenticationType read GetValue write SetValue;
    property DefaultValue: TIdSMTPAuthenticationType read GetDefaultValue write SetDefaultValue;
  end;

resourcestring
  SSMTPAuthenticationTypeNone   = 'Ohne';
  SSMTPAuthenticationTypeDefault = 'Vorgabe';
  SSMTPAuthenticationTypeSASL  = 'SASL';

const
  SMTP_AUTHENTICATION_TYPE_CAPTIONS: array[TIdSMTPAuthenticationType] of PResStringRec =
    (@SSMTPAuthenticationTypeNone, @SSMTPAuthenticationTypeDefault, @SSMTPAuthenticationTypeSASL
    );

type
  TGsSIdSmtp = class(TGsSSmtp)
  private
    FMailAgent: TBPSPString;
    FHeloName:  TBPSPString;
    FUseEhlo:   TBPSPBoolean;
    FPipeLine:  TBPSPBoolean;
    FAuthType:  TGsSPIdSMTPAuthenticationType;
    FUseTLS:    TGsSPIdUseTLS;
    FValidateAuthLoginCapability: TBPSPBoolean;
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    (*
    constructor CreateIdSmtp(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      ADefaultHost: string = ''; ADefaultPort: Word = Id_PORT_submission; ADefaultUsername: string = '';
      ADefaultPassword: string = ''; ADefaultUseTLS: TIdUseTLS = DEF_USETLS); virtual;
    *)

    { Settings properties }
    property MailAgent: TBPSPString read FMailAgent;
    property HeloName: TBPSPString read FHeloName;
    property UseEhlo: TBPSPBoolean read FUseEhlo;
    property PipeLine: TBPSPBoolean read FPipeLine;
    property AuthType: TGsSPIdSMTPAuthenticationType read FAuthType;
    property UseTLS: TGsSPIdUseTLS read FUseTLS;
    property ValidateAuthLoginCapability: TBPSPBoolean read FValidateAuthLoginCapability;

    { Easy property access }
    (*
    property AuthType;
    property MailAgent;
    property HeloName;
    property PipeLine;
    property UseEhlo;
    property UseTLS: TIdUseTLS read GetUseTLS write SetUseTLS;
    property ValidateAuthLoginCapability;
    *)
  end;

implementation

{ TGsSSmtp }

procedure TGsSSmtp.AssignTo(Dest: TPersistent);
begin
  if Dest is TIdSMTP then
  begin
    with TIdSMTP(Dest) do
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

constructor TGsSSmtp.Create(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
  AImageIndex: TImageIndex);
begin
  CreateSmtp(AOwner, AName, CaptionRes, HintRes);
end;

procedure TGsSSmtp.CreateProperties;
resourcestring
  SHost         = 'Hostname';
  SHostHint     = 'Name des SMTP Servers für den Versand.';
  SPort         = 'Port';
  SPortHint     = 'TCP Port des SMTP Servers für den Versand.';
  SUsername     = 'Benutzername';
  SUsernameHint = 'Name des Benutzers für den Versand.';
  SPassword     = 'Kennwort';
  SPasswordHint = 'Kennwort des Benutzers für den Versand.';
begin
  inherited;

  FHost     := TBPSPString.CreateString(Self, 'Host', @SHost, @SHostHint, FDefaultHost);
  FPort     := TBPSPInteger.CreateInteger(Self, 'Port', @SPort, @SPortHint, FDefaultPort);
  FUsername := TBPSPString.CreateString(Self, 'Username', @SUsername, @SUsernameHint, FDefaultUsername);
  FPassword := TBPSPPassword.CreateString(Self, 'Password', @SPassword, @SPasswordHint, FDefaultPassword);
end;

constructor TGsSSmtp.CreateSmtp(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
  ADefaultHost: string; ADefaultPort: Word; ADefaultUsername, ADefaultPassword: string);
begin
  FDefaultHost     := ADefaultHost;
  FDefaultPort     := ADefaultPort;
  FDefaultUsername := ADefaultUsername;
  FDefaultPassword := ADefaultPassword;

  inherited Create(AOwner, AName, CaptionRes, HintRes);
end;

function TGsSSmtp.GetHost: string;
begin
  Result := _Host.Value;
end;

function TGsSSmtp.GetPassword: string;
begin
  Result := _Password.Value;
end;

function TGsSSmtp.GetPort: Word;
begin
  Result := _Port.Value;
end;

function TGsSSmtp.GetUsername: string;
begin
  Result := _Username.Value;
end;

procedure TGsSSmtp.SetHost(const Value: string);
begin
  _Host.Value := Value;
end;

procedure TGsSSmtp.SetPassword(const Value: string);
begin
  _Password.Value := Value;
end;

procedure TGsSSmtp.SetPort(const Value: Word);
begin
  _Port.Value := Value;
end;

procedure TGsSSmtp.SetUsername(const Value: string);
begin
  _Username.Value := Value;
end;

{ TGsSPIdSMTPAuthenticationType }

constructor TGsSPIdSMTPAuthenticationType.Create(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateIdSMTPAuthenticationType(AOwner, AName, CaptionRes, HintRes);
end;

constructor TGsSPIdSMTPAuthenticationType.CreateIdSMTPAuthenticationType(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; ADefaultValue: TIdSMTPAuthenticationType);
begin
  inherited Create(AOwner, AName, CaptionRes, HintRes);

  FValue        := ADefaultValue;
  FDefaultValue := ADefaultValue;
end;

function TGsSPIdSMTPAuthenticationType.GetDefaultValue: TIdSMTPAuthenticationType;
begin
  Result := FDefaultValue;
end;

function TGsSPIdSMTPAuthenticationType.GetEnumCaptionLocalized(AEnumValue: Integer): string;
begin
  Result := LoadResString(SMTP_AUTHENTICATION_TYPE_CAPTIONS[TIdSMTPAuthenticationType(AEnumValue)]);
end;

function TGsSPIdSMTPAuthenticationType.GetValue: TIdSMTPAuthenticationType;
begin
  Result := FValue;
end;

procedure TGsSPIdSMTPAuthenticationType.SetDefaultValue(const Value: TIdSMTPAuthenticationType);
begin
  FDefaultValue := Value;
end;

procedure TGsSPIdSMTPAuthenticationType.SetValue(const Value: TIdSMTPAuthenticationType);
begin
  if (Value <> FValue) then
  begin
    FValue := Value;
    Change;
  end;
end;

{ TGsSIdSmtp }

procedure TGsSIdSmtp.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TIdSMTP then
  begin
    with TIdSMTP(Dest) do
    begin
      (*
      property Host;
      property Password;
      property Port default IdPORT_SMTP;
      property Username;

      property AuthType: TIdSMTPAuthenticationType read FAuthType write FAuthType default DEF_SMTP_AUTH;
      property SASLMechanisms : TIdSASLEntries read FSASLMechanisms write SetSASLMechanisms;
      property UseTLS;
      property ValidateAuthLoginCapability: Boolean read FValidateAuthLoginCapability
        write FValidateAuthLoginCapability default True;

      property MailAgent: string read FMailAgent write FMailAgent;
      property HeloName : string read FHeloName write FHeloName;
      property UseEhlo: Boolean read FUseEhlo write SetUseEhlo default IdDEF_UseEhlo;
      property PipeLine : Boolean read FPipeLine write SetPipeline default DEF_SMTP_PIPELINE;
      property UseVerp: Boolean read FUseVerp write FUseVerp default IdDEF_UseVerp;
      property VerpDelims: string read FVerpDelims write FVerpDelims;
      *)

      AuthType  := Self.AuthType.Value;
      HeloName  := Self.HeloName.Value;
      MailAgent := Self.MailAgent.Value;
      PipeLine  := Self.PipeLine.Value;
      UseEhlo   := Self.UseEhlo.Value;
      UseTLS    := Self.UseTLS.Value;
      ValidateAuthLoginCapability := Self.ValidateAuthLoginCapability.Value;
    end;
  end;
end;

procedure TGsSIdSmtp.CreateProperties;
resourcestring
  SMailAgent     = 'Mail Agent';
  SMailAgentHint = '';
  SHeloName      = 'Helo Name';
  SHeloNameHint  = '';
  SUseEhlo       = 'Benutze EHLO';
  SUseEhloHint   = '';
  SPipeLine      = 'PipeLine';
  SPipeLineHint  = '';
  SAuthType      = 'Authentifizierung';
  SAuthTypeHint  = '';
  SUseTLS        = 'Benutze TLS';
  SUseTLSHint    = '';
  SValidateAuthLoginCapability = 'Überprüfe Login-Fähigkeiten';
  SValidateAuthLoginCapabilityHint = '';
begin
  inherited;

  FMailAgent := TBPSPString.CreateString(Self, 'MailAgent', @SMailAgent, @SMailAgentHint, '');
  FHeloName  := TBPSPString.CreateString(Self, 'HeloName', @SHeloName, @SHeloNameHint, '');
  FUseEhlo   := TBPSPBoolean.CreateBoolean(Self, 'UseEhlo', @SUseEhlo, @SUseEhloHint, IdDEF_UseEhlo);
  FPipeLine  := TBPSPBoolean.CreateBoolean(Self, 'PipeLine', @SPipeLine, @SPipeLineHint, DEF_SMTP_PIPELINE);
  FAuthType  := TGsSPIdSMTPAuthenticationType.CreateIdSMTPAuthenticationType(Self, 'AuthType', @SAuthType, @SAuthTypeHint, DEF_SMTP_AUTH);
  FUseTLS    := TGsSPIdUseTLS.CreateIdUseTLS(Self, 'UseTLS', @SUseTLS, @SUseTLSHint, DEF_USETLS);
  FValidateAuthLoginCapability := TBPSPBoolean.CreateBoolean(Self, 'ValidateAuthLoginCapability', @SValidateAuthLoginCapability,
    @SValidateAuthLoginCapabilityHint, True);
end;

end.

