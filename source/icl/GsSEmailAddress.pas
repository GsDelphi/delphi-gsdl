unit GsSEmailAddress;

{$I gsdl.inc}

interface

uses
  BPSettings,
  Classes,
  Controls,
  GsSSyslog,
  GsSyslog,
  IdEMailAddress,
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  TGsSEmailAddressList = class;
  TGsSNotificationList = class;



  TGsSEmailAddress = class(TCustomBPSubSettings)
  private
    FFullName: TBPSPString;
    FAddress:  TBPSPString;
    function GetAddress: string;
    function GetFullName: string;
    procedure SetAddress(const Value: string);
    procedure SetFullName(const Value: string);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;

    { Properties }
    property _Address: TBPSPString read FAddress;
    property _FullName: TBPSPString read FFullName;
  public
    { Properties }
    property Address: string read GetAddress write SetAddress;
    property FullName: string read GetFullName write SetFullName;
  published
  end;

  TGsSEmailAddressItem = class(TAbstractBPSettingsPropertyListItem)
  private
    FAddress:  TBPSPString;
    FFullName: TBPSPString;
    function GetAddress: string;
    function GetFullName: string;
    procedure SetAddress(const Value: string);
    procedure SetFullName(const Value: string);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;

    { IBPSettingsEditorSupport }
    function GetCaption: TCaption; override;

    { Properties }
    property _Address: TBPSPString read FAddress;
    property _FullName: TBPSPString read FFullName;
  public
    constructor CreateEmailAddress(AOwner: TGsSEmailAddressList;
      AAddress: string = ''; AFullName: string = '';
      AImageIndex: TImageIndex = -1); virtual;
    constructor CreateItem(AOwner: TBPSettingsPropertyList;
      AImageIndex: TImageIndex = -1); override;

    { Properties }
    property Address: string read GetAddress write SetAddress;
    property FullName: string read GetFullName write SetFullName;
  published
  end;

  TGsSEmailAddressList = class(TBPSettingsPropertyList)
  private
    function GetItem(Index: Integer): TGsSEmailAddressItem;
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor CreateEmailAddressList(AOwner: TCustomBPSettings;
      AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); virtual;

    { Properties }
    property Items[Index: Integer]: TGsSEmailAddressItem read GetItem; default;
  end;

  TGsSNotificationItem = class(TGsSEmailAddressItem)
  private
    FLoggingLevel: TGsSPLoggingLevel;
    function GetLoggingLevel: TGsSyslogMessageSeverity;
    procedure SetLoggingLevel(const Value: TGsSyslogMessageSeverity);
  protected
    { TAbstractBPSettings }
    procedure CreateProperties; override;

    { Properties }
    property _LoggingLevel: TGsSPLoggingLevel read FLoggingLevel;
  public
    constructor CreateNotificationItem(AOwner: TGsSNotificationList;
      AAddress: string = ''; AFullName: string = '';
      ALoggingLevel: TGsSyslogMessageSeverity = High(TGsSyslogMessageSeverity);
      AImageIndex: TImageIndex = -1); virtual;
    constructor CreateEmailAddress(AOwner: TGsSEmailAddressList;
      AAddress: string = ''; AFullName: string = '';
      AImageIndex: TImageIndex = -1); override;

    { Properties }
    property LoggingLevel: TGsSyslogMessageSeverity
      read GetLoggingLevel write SetLoggingLevel;
  end;

  TGsSNotificationList = class(TGsSEmailAddressList)
  private
    function GetItem(Index: Integer): TGsSNotificationItem;
  public
    constructor CreateNotificationList(AOwner: TCustomBPSettings;
      AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); virtual;
    constructor CreateEmailAddressList(AOwner: TCustomBPSettings;
      AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); override;

    { Methods }
    procedure AssignToEmailList(ALoggingLevel: TGsSyslogMessageSeverity;
      AList: TIdEMailAddressList);

    { Properties }
    property Items[Index: Integer]: TGsSNotificationItem read GetItem; default;
  end;

implementation

uses
  SysUtils;

{ TGsSEmailAddress }

procedure TGsSEmailAddress.AssignTo(Dest: TPersistent);
begin
  if Dest is TIdEMailAddressItem then
  begin
    with TIdEMailAddressItem(Dest) do
    begin
      Address := Self.Address;
      Name := Self.FullName;
    end;
  end
  else
    inherited;
end;

procedure TGsSEmailAddress.CreateProperties;
resourcestring
  SAddress  = 'E-Mail-Adresse';
  SAddressHint = '';
  SFullName = 'Name';
  SFullNameHint = '';
begin
  inherited;

  FAddress  := TBPSPString.CreateString(Self, 'Address', @SAddress, @SAddressHint, '');
  FFullName := TBPSPString.CreateString(Self, 'FullName', @SFullName,
    @SFullNameHint, '');
end;

function TGsSEmailAddress.GetAddress: string;
begin
  Result := FAddress.Value;
end;

function TGsSEmailAddress.GetFullName: string;
begin
  Result := FFullName.Value;
end;

procedure TGsSEmailAddress.SetAddress(const Value: string);
begin
  FAddress.Value := Value;
end;

procedure TGsSEmailAddress.SetFullName(const Value: string);
begin
  FFullName.Value := Value;
end;

{ TGsSEmailAddressItem }

procedure TGsSEmailAddressItem.AssignTo(Dest: TPersistent);
begin
  if Dest is TIdEMailAddressItem then
  begin
    with TIdEMailAddressItem(Dest) do
    begin
      Address := Self.Address;
      Name := Self.FullName;
    end;
  end
  else
    inherited;
end;

constructor TGsSEmailAddressItem.CreateEmailAddress(AOwner: TGsSEmailAddressList;
  AAddress, AFullName: string; AImageIndex: TImageIndex);
begin
  inherited CreateItem(AOwner, AImageIndex);

  Address  := AAddress;
  FullName := AFullName;
end;

constructor TGsSEmailAddressItem.CreateItem(AOwner: TBPSettingsPropertyList;
  AImageIndex: TImageIndex);
begin
  CreateEmailAddress(AOwner as TGsSEmailAddressList, '', '', AImageIndex);
end;

procedure TGsSEmailAddressItem.CreateProperties;
resourcestring
  SAddress  = 'E-Mail-Adresse';
  SAddressHint = '';
  SFullName = 'Name';
  SFullNameHint = '';
begin
  inherited;

  FAddress  := TBPSPString.CreateString(Self, 'Address', @SAddress, @SAddressHint, '');
  FFullName := TBPSPString.CreateString(Self, 'FullName', @SFullName,
    @SFullNameHint, '');
end;

function TGsSEmailAddressItem.GetAddress: string;
begin
  Result := FAddress.Value;
end;

function TGsSEmailAddressItem.GetCaption: TCaption;
begin
  Result := Format('%s <%s> (%u)', [FullName, Address, Index]);
end;

function TGsSEmailAddressItem.GetFullName: string;
begin
  Result := FFullName.Value;
end;

procedure TGsSEmailAddressItem.SetAddress(const Value: string);
begin
  FAddress.Value := Value;
end;

procedure TGsSEmailAddressItem.SetFullName(const Value: string);
begin
  FFullName.Value := Value;
end;

{ TGsSEmailAddressList }

procedure TGsSEmailAddressList.AssignTo(Dest: TPersistent);
var
  I: Integer;
begin
  if Dest is TIdEMailAddressList then
  begin
    TIdEMailAddressList(Dest).Clear;

    for I := 0 to Count - 1 do
      TIdEMailAddressList(Dest).Add.Assign(Items[I]);
  end
  else
    inherited;
end;

constructor TGsSEmailAddressList.CreateEmailAddressList(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateList(AOwner, AName, CaptionRes, HintRes, TGsSEmailAddressItem, AImageIndex);
end;

function TGsSEmailAddressList.GetItem(Index: Integer): TGsSEmailAddressItem;
begin
  Result := TGsSEmailAddressItem(inherited Items[Index]);
end;

{ TGsSNotificationItem }

constructor TGsSNotificationItem.CreateEmailAddress(AOwner: TGsSEmailAddressList;
  AAddress, AFullName: string; AImageIndex: TImageIndex);
begin
  CreateNotificationItem(AOwner as TGsSNotificationList, AAddress, AFullName,
    High(TGsSyslogMessageSeverity), AImageIndex);
end;

constructor TGsSNotificationItem.CreateNotificationItem(AOwner: TGsSNotificationList;
  AAddress, AFullName: string; ALoggingLevel: TGsSyslogMessageSeverity;
  AImageIndex: TImageIndex);
begin
  inherited CreateEmailAddress(AOwner, AAddress, AFullName, AImageIndex);

  FLoggingLevel.Value := ALoggingLevel;
end;

procedure TGsSNotificationItem.CreateProperties;
resourcestring
  SLoggingLevel = 'Logging-Level';
  SLoggingLevelHint = '';
begin
  inherited;

  FLoggingLevel := TGsSPLoggingLevel.CreateLoggingLevel(Self,
    'LoggingLevel', @SLoggingLevel, @SLoggingLevelHint);
end;

function TGsSNotificationItem.GetLoggingLevel: TGsSyslogMessageSeverity;
begin
  Result := FLoggingLevel.Value;
end;

procedure TGsSNotificationItem.SetLoggingLevel(const Value: TGsSyslogMessageSeverity);
begin
  FLoggingLevel.Value := Value;
end;

{ TGsSNotificationList }

procedure TGsSNotificationList.AssignToEmailList(
  ALoggingLevel: TGsSyslogMessageSeverity;
  AList: TIdEMailAddressList);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if ALoggingLevel <= Items[I].LoggingLevel then
      AList.Add.Assign(Items[I]);
end;

constructor TGsSNotificationList.CreateEmailAddressList(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateNotificationList(AOwner, AName, CaptionRes, HintRes, AImageIndex);
end;

constructor TGsSNotificationList.CreateNotificationList(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateList(AOwner, AName, CaptionRes, HintRes, TGsSNotificationItem, AImageIndex);
end;

function TGsSNotificationList.GetItem(Index: Integer): TGsSNotificationItem;
begin
  Result := TGsSNotificationItem(inherited Items[Index]);
end;

end.
