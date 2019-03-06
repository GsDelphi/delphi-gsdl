unit GsSIdTLS;

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
  TGsSPIdUseTLS = class(TCustomBPSettingsEnumProperty,
    IBPSettingsEditorOrdinalPropertySupport,
    IBPSettingsEditorEnumPropertySupport,
    IBPSettingsEditorComboBoxSupport)
  private
    FValue:        TIdUseTLS;
    FDefaultValue: TIdUseTLS;
  protected
    { IBPSettingsEditorEnumPropertySupport }
    function GetEnumCaptionLocalized(AEnumValue: Longint): string; override;

    { TGsSPIdUseTLS }
    function GetDefaultValue: TIdUseTLS; virtual;
    function GetValue: TIdUseTLS; virtual;
    procedure SetDefaultValue(const Value: TIdUseTLS); virtual;
    procedure SetValue(const Value: TIdUseTLS); virtual;
  public
    constructor CreateIdUseTLS(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      ADefaultValue: TIdUseTLS = DEF_USETLS);
      virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); override;
  published
    { Properties }
    property Value: TIdUseTLS read GetValue write SetValue;
    property DefaultValue: TIdUseTLS read GetDefaultValue write SetDefaultValue;
  end;

resourcestring
  SNoTLSSupport   = 'Ohne';
  SUseImplicitTLS = 'Immer';            // ssl iohandler req, allways tls
  SUseRequireTLS  = 'Anmeldung';        // ssl iohandler req, user command only accepted when in tls
  SUseExplicitTLS = 'Benutzerdefiniert';// < user can choose to use tls

const
  USE_TLS_CAPTIONS: array[TIdUseTLS] of PResStringRec =
    (@SNoTLSSupport, @SUseImplicitTLS, @SUseRequireTLS, @SUseExplicitTLS
    );

implementation

{ TGsSPIdUseTLS }

constructor TGsSPIdUseTLS.Create(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
  AImageIndex: TImageIndex);
begin
  CreateIdUseTLS(AOwner, AName, CaptionRes, HintRes);
end;

constructor TGsSPIdUseTLS.CreateIdUseTLS(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec; ADefaultValue: TIdUseTLS);
begin
  inherited Create(AOwner, AName, CaptionRes, HintRes);

  FValue        := ADefaultValue;
  FDefaultValue := ADefaultValue;
end;

function TGsSPIdUseTLS.GetDefaultValue: TIdUseTLS;
begin
  Result := FDefaultValue;
end;

function TGsSPIdUseTLS.GetEnumCaptionLocalized(AEnumValue: Integer): string;
begin
  Result := LoadResString(USE_TLS_CAPTIONS[TIdUseTLS(AEnumValue)]);
end;

function TGsSPIdUseTLS.GetValue: TIdUseTLS;
begin
  Result := FValue;
end;

procedure TGsSPIdUseTLS.SetDefaultValue(const Value: TIdUseTLS);
begin
  FDefaultValue := Value;
end;

procedure TGsSPIdUseTLS.SetValue(const Value: TIdUseTLS);
begin
  if (Value <> FValue) then
  begin
    FValue := Value;
    Change;
  end;
end;

end.

