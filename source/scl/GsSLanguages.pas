unit GsSLanguages;

{$I gsdl.inc}

interface

uses
  BPSettings,
  BPSettingsEditorIntf,
  Classes,
  Controls,
  GsISO639,
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  TGsSPLanguage = class(TCustomBPSettingsEnumProperty,
    IBPSettingsEditorOrdinalPropertySupport,
    IBPSettingsEditorEnumPropertySupport,
    IBPSettingsEditorComboBoxSupport
    )
  private
    FValue:        TGsLanguageIdentifier;
    FDefaultValue: TGsLanguageIdentifier;
  protected
    { IBPSettingsEditorEnumPropertySupport }
    function GetEnumCaption(AEnumValue: Longint): string; override;
    function GetEnumCaptionLocalized(AEnumValue: Longint): string; override;

    { Property access }
    function GetDefaultValue: TGsLanguageIdentifier; virtual;
    function GetValue: TGsLanguageIdentifier; virtual;
    procedure SetDefaultValue(const Value: TGsLanguageIdentifier); virtual;
    procedure SetValue(const Value: TGsLanguageIdentifier); virtual;
  public
    constructor CreateLanguage(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec;
      ADefaultValue: TGsLanguageIdentifier = lcUndefined); virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex = -1); override;

    { TPersistent }
    procedure Assign(Source: TPersistent); override;
  published
    property Value: TGsLanguageIdentifier read GetValue write SetValue;
    property DefaultValue: TGsLanguageIdentifier
      read GetDefaultValue write SetDefaultValue;
  end;

  TGsSPLanguages = class(TCustomBPSettingsSetProperty,
    IBPSettingsEditorOrdinalPropertySupport,
    IBPSettingsEditorEnumPropertySupport,
    IBPSettingsEditorSetPropertySupport
    )
  private
    FValue:        TGsLanguageIdentifiers;
    FDefaultValue: TGsLanguageIdentifiers;
  protected
    { IBPSettingsEditorPropertySupport }
    //procedure SetText(const Value: TCaption); override;

    { IBPSettingsEditorEnumPropertySupport }
    function GetEnumCaption(AEnumValue: Longint): string; override;
    function GetEnumCaptionLocalized(AEnumValue: Longint): string; override;

    { Property access }
    function GetDefaultValue: TGsLanguageIdentifiers; virtual;
    function GetValue: TGsLanguageIdentifiers; virtual;
    procedure SetDefaultValue(const Value: TGsLanguageIdentifiers); virtual;
    procedure SetValue(const Value: TGsLanguageIdentifiers); virtual;
  public
    constructor CreateLanguages(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec; ADefaultValue: TGsLanguageIdentifiers = [];
      AImageIndex: TImageIndex = -1); virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: string;
      CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex = -1); override;

    procedure Assign(Source: TPersistent); override;

    { Properties }
    property Value: TGsLanguageIdentifiers read GetValue write SetValue;
    property DefaultValue: TGsLanguageIdentifiers
      read GetDefaultValue write SetDefaultValue;
  end;

implementation

{ TGsSPLanguage }

procedure TGsSPLanguage.Assign(Source: TPersistent);
begin
  inherited;

  if Source is TGsSPLanguage then
    with TGsSPLanguage(Source) do
    begin
      Self.FValue := FValue;
      Self.FDefaultValue := FDefaultValue;
    end;
end;

constructor TGsSPLanguage.Create(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateLanguage(AOwner, AName, CaptionRes, HintRes);
end;

constructor TGsSPLanguage.CreateLanguage(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec;
  ADefaultValue: TGsLanguageIdentifier);
begin
  inherited Create(AOwner, AName, CaptionRes, HintRes);

  FValue := ADefaultValue;
  FDefaultValue := ADefaultValue;
end;

function TGsSPLanguage.GetDefaultValue: TGsLanguageIdentifier;
begin
  Result := FDefaultValue;
end;

function TGsSPLanguage.GetEnumCaption(AEnumValue: Integer): string;
begin
  Result := string(GetLanguageIdentifierIsoAlpha2(TGsLanguageIdentifier(AEnumValue)));
end;

function TGsSPLanguage.GetEnumCaptionLocalized(AEnumValue: Integer): string;
begin
  Result := GetLanguageIdentifierCaptionEnglish(TGsLanguageIdentifier(AEnumValue));
end;

function TGsSPLanguage.GetValue: TGsLanguageIdentifier;
begin
  Result := FValue;
end;

procedure TGsSPLanguage.SetDefaultValue(const Value: TGsLanguageIdentifier);
begin
  FDefaultValue := Value;
end;

procedure TGsSPLanguage.SetValue(const Value: TGsLanguageIdentifier);
begin
  if (Value <> FValue) then
  begin
    FValue := Value;
    Change;
  end;
end;

{ TGsSPLanguages }

procedure TGsSPLanguages.Assign(Source: TPersistent);
begin
  inherited;

  if Source is TGsSPLanguages then
    with TGsSPLanguages(Source) do
    begin
      Self.FValue := FValue;
      Self.FDefaultValue := FDefaultValue;
    end;
end;

constructor TGsSPLanguages.Create(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateLanguages(AOwner, AName, CaptionRes, HintRes, [], AImageIndex);
end;

constructor TGsSPLanguages.CreateLanguages(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec;
  ADefaultValue: TGsLanguageIdentifiers; AImageIndex: TImageIndex);
begin
  inherited Create(AOwner, AName, CaptionRes, HintRes);

  FValue := ADefaultValue;
  FDefaultValue := ADefaultValue;
end;

function TGsSPLanguages.GetDefaultValue: TGsLanguageIdentifiers;
begin
  Result := FDefaultValue;
end;

function TGsSPLanguages.GetEnumCaption(AEnumValue: Integer): string;
begin
  Result := string(GetLanguageIdentifierIsoAlpha2(TGsLanguageIdentifier(AEnumValue)));
end;

function TGsSPLanguages.GetEnumCaptionLocalized(AEnumValue: Integer): string;
begin
  Result := GetLanguageIdentifierCaptionEnglish(TGsLanguageIdentifier(AEnumValue));
end;

function TGsSPLanguages.GetValue: TGsLanguageIdentifiers;
begin
  Result := FValue;
end;

procedure TGsSPLanguages.SetDefaultValue(const Value: TGsLanguageIdentifiers);
begin
  FDefaultValue := Value;
end;

procedure TGsSPLanguages.SetValue(const Value: TGsLanguageIdentifiers);
begin
  if (Value <> FValue) then
  begin
    FValue := Value;
    Change;
  end;
end;

end.

