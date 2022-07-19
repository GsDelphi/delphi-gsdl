unit GsSURI;

{$I gsdl.inc}

interface

uses
  BPSettings,
  Classes,
  Controls,
  GsSSyslog,
  GsSyslog,
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  TGsSURIList = class;
  TGsSURINotificationList = class;



  TGsSURI = class(TCustomBPSubSettings)
  private
    FURI:  TBPSPString;
    FDescription: TBPSPString;
    function GetDescription: string;
    function GetURI: string;
    procedure SetDescription(const Value: string);
    procedure SetURI(const Value: string);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    { Settings properties }
    property _URI: TBPSPString read FURI;
    property _Description: TBPSPString read FDescription;

    { Easy property access }
    property URI: string read GetURI write SetURI;
    property Description: string read GetDescription write SetDescription;
  end;

  TGsSURIItem = class(TAbstractBPSettingsPropertyListItem)
  private
    FURI: TBPSPString;
    FDescription: TBPSPString;
    function GetDescription: string;
    function GetURI: string;
    procedure SetDescription(const Value: string);
    procedure SetURI(const Value: string);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;

    { IBPSettingsEditorSupport }
    function GetCaption: TCaption; override;
  public
    constructor CreateURI(AOwner: TGsSURIList;
      AURI: string = ''; ADescription: string = '';
      AImageIndex: TImageIndex = -1); virtual;
    constructor CreateItem(AOwner: TBPSettingsPropertyList;
      AImageIndex: TImageIndex = -1); override;

    { Settings properties }
    property _URI: TBPSPString read FURI;
    property _Description: TBPSPString read FDescription;

    { Easy property access }
    property URI: string read GetURI write SetURI;
    property Description: string read GetDescription write SetDescription;
  end;

  TGsSURIList = class(TBPSettingsPropertyList)
  private
    function GetItem(Index: Integer): TGsSURIItem;
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor CreateURIList(AOwner: TCustomBPSettings;
      AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); virtual;

    { Properties }
    property Items[Index: Integer]: TGsSURIItem read GetItem; default;
  end;

  TGsSURINotificationItem = class(TGsSURIItem)
  private
    FLoggingLevel: TGsSPLoggingLevel;
    function GetLoggingLevel: TGsSyslogMessageSeverity;
    procedure SetLoggingLevel(const Value: TGsSyslogMessageSeverity);
  protected
    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    constructor CreateNotificationItem(AOwner: TGsSURINotificationList;
      AURI: string = ''; ADescription: string = '';
      ALoggingLevel: TGsSyslogMessageSeverity = High(TGsSyslogMessageSeverity);
      AImageIndex: TImageIndex = -1); virtual;
    constructor CreateURI(AOwner: TGsSURIList;
      AURI: string = ''; ADescription: string = '';
      AImageIndex: TImageIndex = -1); override;

    { Settings properties }
    property _LoggingLevel: TGsSPLoggingLevel read FLoggingLevel;

    { Easy property access }
    property LoggingLevel: TGsSyslogMessageSeverity
      read GetLoggingLevel write SetLoggingLevel;
  end;

  TGsSURINotificationList = class(TGsSURIList)
  private
    function GetItem(Index: Integer): TGsSURINotificationItem;
  public
    constructor CreateNotificationList(AOwner: TCustomBPSettings;
      AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); virtual;
    constructor CreateURIList(AOwner: TCustomBPSettings;
      AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); override;

    { Methods }
    (*
    procedure AssignToEmailList(ALoggingLevel: TGsSyslogMessageSeverity;
      AList: TIdEMailAddressList);
    *)

    { Properties }
    property Items[Index: Integer]: TGsSURINotificationItem read GetItem; default;
  end;

implementation

uses
  SysUtils;

{ TGsSURI }

procedure TGsSURI.AssignTo(Dest: TPersistent);
begin
  (*
  if Dest is TIdEMailAddressItem then
  begin
    with TIdEMailAddressItem(Dest) do
    begin
      Address := Self.Address;
      Name := Self.FullName;
    end;
  end
  else
  *)
    inherited;
end;

procedure TGsSURI.CreateProperties;
resourcestring
  SURI  = 'URI';
  SURIHint = '';
  SDescription = 'Beschreibung';
  SDescriptionHint = '';
begin
  inherited;

  FURI  := TBPSPString.CreateString(Self, 'URI', @SURI, @SURIHint, '');
  FDescription := TBPSPString.CreateString(Self, 'Description', @SDescription,
    @SDescriptionHint, '');
end;

function TGsSURI.GetDescription: string;
begin
  Result := FDescription.Value;
end;

function TGsSURI.GetURI: string;
begin
  Result := FURI.Value;
end;

procedure TGsSURI.SetDescription(const Value: string);
begin
  FDescription.Value := Value;
end;

procedure TGsSURI.SetURI(const Value: string);
begin
  FURI.Value := Value;
end;

{ TGsSURIItem }

procedure TGsSURIItem.AssignTo(Dest: TPersistent);
begin
  (*
  if Dest is TIdEMailAddressItem then
  begin
    with TIdEMailAddressItem(Dest) do
    begin
      Address := Self.Address;
      Name := Self.FullName;
    end;
  end
  else
  *)
    inherited;
end;

constructor TGsSURIItem.CreateItem(AOwner: TBPSettingsPropertyList;
  AImageIndex: TImageIndex);
begin
  CreateURI(AOwner as TGsSURIList, '', '', AImageIndex);
end;

procedure TGsSURIItem.CreateProperties;
resourcestring
  SURI  = 'URI';
  SURIHint = '';
  SDescription = 'Beschreibung';
  SDescriptionHint = '';
begin
  inherited;

  FURI  := TBPSPString.CreateString(Self, 'URI', @SURI, @SURIHint, '');
  FDescription := TBPSPString.CreateString(Self, 'Description', @SDescription,
    @SDescriptionHint, '');
end;

constructor TGsSURIItem.CreateURI(AOwner: TGsSURIList; AURI,
  ADescription: string; AImageIndex: TImageIndex);
begin
  inherited CreateItem(AOwner, AImageIndex);

  URI  := AURI;
  Description := ADescription;
end;

function TGsSURIItem.GetCaption: TCaption;
begin
  Result := Format('%s <%s> (%u)', [Description, URI, Index]);
end;

function TGsSURIItem.GetDescription: string;
begin
  Result := FDescription.Value;
end;

function TGsSURIItem.GetURI: string;
begin
  Result := FURI.Value;
end;

procedure TGsSURIItem.SetDescription(const Value: string);
begin
  FDescription.Value := Value;
end;

procedure TGsSURIItem.SetURI(const Value: string);
begin
  FURI.Value := Value;
end;

{ TGsSURIList }

procedure TGsSURIList.AssignTo(Dest: TPersistent);
var
  I: Integer;
begin
  (*
  if Dest is TIdEMailAddressList then
  begin
    TIdEMailAddressList(Dest).Clear;

    for I := 0 to Count - 1 do
      TIdEMailAddressList(Dest).Add.Assign(Items[I]);
  end
  else
  *)
    inherited;
end;

constructor TGsSURIList.CreateURIList(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateList(AOwner, AName, CaptionRes, HintRes, TGsSURIItem, AImageIndex);
end;

function TGsSURIList.GetItem(Index: Integer): TGsSURIItem;
begin
  Result := TGsSURIItem(inherited Items[Index]);
end;

{ TGsSURINotificationItem }

constructor TGsSURINotificationItem.CreateNotificationItem(AOwner: TGsSURINotificationList;
  AURI, ADescription: string; ALoggingLevel: TGsSyslogMessageSeverity;
  AImageIndex: TImageIndex);
begin
  inherited CreateURI(AOwner, AURI, ADescription, AImageIndex);

  FLoggingLevel.Value := ALoggingLevel;
end;

procedure TGsSURINotificationItem.CreateProperties;
resourcestring
  SLoggingLevel = 'Logging-Level';
  SLoggingLevelHint = '';
begin
  inherited;

  FLoggingLevel := TGsSPLoggingLevel.CreateLoggingLevel(Self,
    'LoggingLevel', @SLoggingLevel, @SLoggingLevelHint);
end;

constructor TGsSURINotificationItem.CreateURI(AOwner: TGsSURIList; AURI,
  ADescription: string; AImageIndex: TImageIndex);
begin
  CreateNotificationItem(AOwner as TGsSURINotificationList, AURI, ADescription,
    High(TGsSyslogMessageSeverity), AImageIndex);
end;

function TGsSURINotificationItem.GetLoggingLevel: TGsSyslogMessageSeverity;
begin
  Result := FLoggingLevel.Value;
end;

procedure TGsSURINotificationItem.SetLoggingLevel(const Value: TGsSyslogMessageSeverity);
begin
  FLoggingLevel.Value := Value;
end;

{ TGsSURINotificationList }

(*
procedure TGsSURINotificationList.AssignToEmailList(
  ALoggingLevel: TGsSyslogMessageSeverity;
  AList: TIdEMailAddressList);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if ALoggingLevel <= Items[I].LoggingLevel then
      AList.Add.Assign(Items[I]);
end;
*)

constructor TGsSURINotificationList.CreateNotificationList(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateList(AOwner, AName, CaptionRes, HintRes, TGsSURINotificationItem, AImageIndex);
end;

constructor TGsSURINotificationList.CreateURIList(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateNotificationList(AOwner, AName, CaptionRes, HintRes, AImageIndex);
end;

function TGsSURINotificationList.GetItem(Index: Integer): TGsSURINotificationItem;
begin
  Result := TGsSURINotificationItem(inherited Items[Index]);
end;

end.

