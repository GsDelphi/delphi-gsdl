unit GsSSyslog;

{$I gsdl.inc}

interface

uses
  BPSettings,
  BPSettingsEditorIntf,
  Classes,
  GsSyslog,
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  TGsSPLoggingLevel = class(TCustomBPSettingsEnumProperty,
    IBPSettingsEditorOrdinalPropertySupport,
    IBPSettingsEditorEnumPropertySupport,
    IBPSettingsEditorComboBoxSupport
    )
  private
    FValue:        TGsSyslogMessageSeverity;
    FDefaultValue: TGsSyslogMessageSeverity;
  protected
    { IBPSettingsEditorEnumPropertySupport }
    function GetEnumCaptionLocalized(AEnumValue: Longint): string; override;

    { Property access }
    function GetDefaultValue: TGsSyslogMessageSeverity; virtual;
    function GetValue: TGsSyslogMessageSeverity; virtual;
    procedure SetDefaultValue(const Value: TGsSyslogMessageSeverity); virtual;
    procedure SetValue(const Value: TGsSyslogMessageSeverity); virtual;
  public
    constructor CreateLoggingLevel(AOwner: TCustomBPSettings;
      AName: string; CaptionRes, HintRes: PResStringRec;
      ADefaultValue: TGsSyslogMessageSeverity = High(TGsSyslogMessageSeverity));
      virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex = -1); override;

    { TPersistent }
    procedure Assign(Source: TPersistent); override;
  published
    property Value: TGsSyslogMessageSeverity read GetValue write SetValue;
    property DefaultValue: TGsSyslogMessageSeverity
      read GetDefaultValue write SetDefaultValue;
  end;

implementation

{ TGsSPLoggingLevel }

procedure TGsSPLoggingLevel.Assign(Source: TPersistent);
begin
  inherited;

  if Source is TGsSPLoggingLevel then
    with TGsSPLoggingLevel(Source) do
    begin
      Self.FValue := FValue;
      Self.FDefaultValue := FDefaultValue;
    end;
end;

constructor TGsSPLoggingLevel.Create(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateLoggingLevel(AOwner, AName, CaptionRes, HintRes);
end;

constructor TGsSPLoggingLevel.CreateLoggingLevel(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec;
  ADefaultValue: TGsSyslogMessageSeverity);
begin
  inherited Create(AOwner, AName, CaptionRes, HintRes);

  FValue := ADefaultValue;
  FDefaultValue := ADefaultValue;
end;

function TGsSPLoggingLevel.GetDefaultValue: TGsSyslogMessageSeverity;
begin
  Result := FDefaultValue;
end;

function TGsSPLoggingLevel.GetEnumCaptionLocalized(AEnumValue: Integer): string;
begin
  Result := GetSyslogMessageSeverityCaption(TGsSyslogMessageSeverity(AEnumValue));
end;

function TGsSPLoggingLevel.GetValue: TGsSyslogMessageSeverity;
begin
  Result := FValue;
end;

procedure TGsSPLoggingLevel.SetDefaultValue(const Value: TGsSyslogMessageSeverity);
begin
  FDefaultValue := Value;
end;

procedure TGsSPLoggingLevel.SetValue(const Value: TGsSyslogMessageSeverity);
begin
  if (Value <> FValue) then
  begin
    FValue := Value;
    Change;
  end;
end;

end.
