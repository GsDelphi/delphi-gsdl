unit GsSSmtp;

{$I gsdl.inc}

interface

uses
  BPSettings,
  BPSettingsEditorIntf,
  Classes,
  IdAssignedNumbers,
  IdExplicitTLSClientServerBase,
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  TGsSSmtp = class(TCustomBPSubSettings)
  private
    FHost:        TBPSPString;
    FPort:        TBPSPInteger;
    FUsername:    TBPSPString;
    FPassword:    TBPSPPassword;
    FDefaultHost: String;
    FDefaultPort: Integer;
    FDefaultUsername: String;
    FDefaultPassword: String;
    function GetHost: String;
    function GetPassword: String;
    function GetPort: Word;
    function GetUsername: String;
    procedure SetHost(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetPort(const Value: Word);
    procedure SetUsername(const Value: String);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    constructor CreateSmtp(AOwner: TCustomBPSettings; AName: String;
      CaptionRes, HintRes: PResStringRec; ADefaultHost: String = '';
      ADefaultPort: Word = Id_PORT_submission; ADefaultUsername: String = '';
      ADefaultPassword: String = ''); virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: String;
      CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex = -1); override;

    { TPersistent }
    //procedure Assign(Source: TPersistent); override;

    { Settings properties }
    property _Host: TBPSPString read FHost;
    property _Port: TBPSPInteger read FPort;
    property _Username: TBPSPString read FUsername;
    property _Password: TBPSPPassword read FPassword;

    { Easy property access }
    property Host: String read GetHost write SetHost;
    property Port: Word read GetPort write SetPort;
    property Username: String read GetUsername write SetUsername;
    property Password: String read GetPassword write SetPassword;
  end;

  TBPSPIdUseTLS = class(TCustomBPSettingsEnumProperty,
    IBPSettingsEditorOrdinalPropertySupport,
    IBPSettingsEditorEnumPropertySupport,
    IBPSettingsEditorComboBoxSupport)
  private
    FValue:        TIdUseTLS;
    FDefaultValue: TIdUseTLS;
  protected
    { IBPSettingsEditorEnumPropertySupport }
    //function GetEnumCaptionLocalized(AEnumValue: Longint): String; override;

    { TBPSPIdUseTLS }
    function GetDefaultValue: TIdUseTLS; virtual;
    function GetValue: TIdUseTLS; virtual;
    procedure SetDefaultValue(const Value: TIdUseTLS); virtual;
    procedure SetValue(const Value: TIdUseTLS); virtual;
  public
    constructor CreateIdUseTLS(AOwner: TCustomBPSettings; AName: String;
      CaptionRes, HintRes: PResStringRec; ADefaultValue: TIdUseTLS = DEF_USETLS);
      virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: String;
      CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex = -1); override;
  published
    property Value: TIdUseTLS read GetValue write SetValue;
    property DefaultValue: TIdUseTLS read GetDefaultValue write SetDefaultValue;
  end;

  TGsSIdSmtp = class(TGsSSmtp)
  private
    FUseTLS:        TBPSPIdUseTLS;
    FDefaultUseTLS: TIdUseTLS;
    function GetUseTLS: TIdUseTLS;
    procedure SetUseTLS(const Value: TIdUseTLS);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    constructor CreateIdSmtp(AOwner: TCustomBPSettings; AName: String;
      CaptionRes, HintRes: PResStringRec; ADefaultHost: String = '';
      ADefaultPort: Word = Id_PORT_submission; ADefaultUsername: String = '';
      ADefaultPassword: String = ''; ADefaultUseTLS: TIdUseTLS = DEF_USETLS); virtual;

    { TGsSIdSmtp }
    property UseTLS: TIdUseTLS read GetUseTLS write SetUseTLS;
  published
    property _UseTLS: TBPSPIdUseTLS read FUseTLS;
  end;

implementation

uses
  IdSmtp,
  IdSmtpBase;

{ TGsSSmtp }

procedure TGsSSmtp.AssignTo(Dest: TPersistent);
begin
  if Dest is TIdSMTP then
  begin
    with TIdSMTP(Dest) do
    begin
      Host := Self.Host;
      Port := Self.Port;
      Username := Self.Username;
      Password := Self.Password;
    end;
  end
  else
    inherited;
end;

constructor TGsSSmtp.Create(AOwner: TCustomBPSettings; AName: String;
  CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateSmtp(AOwner, AName, CaptionRes, HintRes);
end;

procedure TGsSSmtp.CreateProperties;
resourcestring
  SHost = 'Hostname';
  SHostHint = 'Name des SMTP Server für den Versand.';
  SPort = 'Port';
  SPortHint = 'TCP Port des SMTP Server für den Versand.';
  SUsername = 'Benutzername';
  SUsernameHint = 'Name des Benutzers für den Versand.';
  SPassword = 'Kennwort';
  SPasswordHint = 'Kennwort des Benutzers für den Versand.';
begin
  inherited;

  FHost := TBPSPString.CreateString(Self, 'Host', @SHost, @SHostHint, FDefaultHost);
  FPort := TBPSPInteger.CreateInteger(Self, 'Port', @SPort, @SPortHint, FDefaultPort);
  FUsername := TBPSPString.CreateString(Self, 'Username', @SUsername,
    @SUsernameHint, FDefaultUsername);
  FPassword := TBPSPPassword.CreateString(Self, 'Password', @SPassword,
    @SPasswordHint, FDefaultPassword);
end;

constructor TGsSSmtp.CreateSmtp(AOwner: TCustomBPSettings; AName: String;
  CaptionRes, HintRes: PResStringRec; ADefaultHost: String; ADefaultPort: Word;
  ADefaultUsername, ADefaultPassword: String);
begin
  FDefaultHost := ADefaultHost;
  FDefaultPort := ADefaultPort;
  FDefaultUsername := ADefaultUsername;
  FDefaultPassword := ADefaultPassword;

  inherited Create(AOwner, AName, CaptionRes, HintRes);
end;

function TGsSSmtp.GetHost: String;
begin
  Result := _Host.Value;
end;

function TGsSSmtp.GetPassword: String;
begin
  Result := _Password.Value;
end;

function TGsSSmtp.GetPort: Word;
begin
  Result := _Port.Value;
end;

function TGsSSmtp.GetUsername: String;
begin
  Result := _Username.Value;
end;

procedure TGsSSmtp.SetHost(const Value: String);
begin
  _Host.Value := Value;
end;

procedure TGsSSmtp.SetPassword(const Value: String);
begin
  _Password.Value := Value;
end;

procedure TGsSSmtp.SetPort(const Value: Word);
begin
  _Port.Value := Value;
end;

procedure TGsSSmtp.SetUsername(const Value: String);
begin
  _Username.Value := Value;
end;

{ TBPSPIdUseTLS }

constructor TBPSPIdUseTLS.Create(AOwner: TCustomBPSettings; AName: String;
  CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateIdUseTLS(AOwner, AName, CaptionRes, HintRes);
end;

constructor TBPSPIdUseTLS.CreateIdUseTLS(AOwner: TCustomBPSettings;
  AName: String; CaptionRes, HintRes: PResStringRec; ADefaultValue: TIdUseTLS);
begin
  inherited Create(AOwner, AName, CaptionRes, HintRes);

  FValue := ADefaultValue;
  FDefaultValue := ADefaultValue;
end;

function TBPSPIdUseTLS.GetDefaultValue: TIdUseTLS;
begin
  Result := FDefaultValue;
end;

function TBPSPIdUseTLS.GetValue: TIdUseTLS;
begin
  Result := FValue;
end;

procedure TBPSPIdUseTLS.SetDefaultValue(const Value: TIdUseTLS);
begin
  FDefaultValue := Value;
end;

procedure TBPSPIdUseTLS.SetValue(const Value: TIdUseTLS);
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
      UseTLS := Self.UseTLS;
    end;
  end;
end;

constructor TGsSIdSmtp.CreateIdSmtp(AOwner: TCustomBPSettings;
  AName: String; CaptionRes, HintRes: PResStringRec; ADefaultHost: String;
  ADefaultPort: Word; ADefaultUsername, ADefaultPassword: String;
  ADefaultUseTLS: TIdUseTLS);
begin
  FDefaultUseTLS := ADefaultUseTLS;

  CreateSmtp(AOwner, AName, CaptionRes, HintRes, ADefaultHost,
    ADefaultPort, ADefaultUsername, ADefaultPassword);
end;

procedure TGsSIdSmtp.CreateProperties;
resourcestring
  SUseTLS = 'Benutze TLS';
  SUseTLSHint = '';
begin
  inherited;

  FUseTLS := TBPSPIdUseTLS.CreateIdUseTLS(Self, 'UseTLS', @SUseTLS,
    @SUseTLSHint, FDefaultUseTLS);
end;

function TGsSIdSmtp.GetUseTLS: TIdUseTLS;
begin
  Result := _UseTLS.Value;
end;

procedure TGsSIdSmtp.SetUseTLS(const Value: TIdUseTLS);
begin
  _UseTLS.Value := Value;
end;

end.
