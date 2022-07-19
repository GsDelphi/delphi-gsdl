unit GsSettings;

interface

uses
  BPSettings,
  BPSettingsEditorIntf,
  System.SysUtils,
  System.UITypes,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.Themes;

type
  TGsSPPasswordHash = class(TBPSPString)
  protected
    { TBPSPString }
    procedure SetValue(const Value: string); override;
  public
    function CheckPassword(const Password: string; out PasswordRehashNeeded: Boolean): Boolean;
  end;

  TGsSPThemeStyle = class(TCustomBPSettingsProperty,
    IBPSettingsEditorComboBoxSupport)
  private
    FValue:        string;
    FDefaultValue: string;
  protected
    function GetDefaultValue: string; virtual;
    function GetValue: string; virtual;
    procedure SetValue(const Value: string); virtual;
  protected
    { TCustomBPSettingsProperty }
    procedure DoLoad; override;
    procedure DoSave; override;

    function GetDefaultEditFrameClass: TCustomFrameClass; override;

    { IBPSettingsEditorComboBoxSupport }
    procedure GetValues(Proc: TGetValueStrProc); virtual;
    procedure SetValues(Func: TSetValueStrFunc); virtual;
  public
    constructor CreateThemeStyle(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      ADefaultValue: string = ''); virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); override;

    procedure Apply;
  published
    property Value: string read GetValue write SetValue;
    property DefaultValue: string read GetDefaultValue write FDefaultValue;
  end;

implementation

uses
  BPSPEFComboBox,
  GsCrypto;

{ TGsSPPasswordHash }

function TGsSPPasswordHash.CheckPassword(const Password: string; out PasswordRehashNeeded: Boolean): Boolean;
begin
  Result := GsCrypto.CheckPassword(Password, Value, PasswordRehashNeeded);
end;

procedure TGsSPPasswordHash.SetValue(const Value: string);
begin
  inherited SetValue(GsCrypto.HashPassword(Value));
end;

{ TGsSPThemeStyle }

procedure TGsSPThemeStyle.Apply;
begin
  DefaultValue; // ensure default value is set before applying style

  if (TStyleManager.ActiveStyle.Name <> Value) and (Value <> '') then
    TStyleManager.TrySetStyle(Value);
end;

constructor TGsSPThemeStyle.Create(AOwner: TCustomBPSettings; AName: string;
  CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateThemeStyle(AOwner, AName, CaptionRes, HintRes);
end;

constructor TGsSPThemeStyle.CreateThemeStyle(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; ADefaultValue: string);
begin
  inherited Create(AOwner, AName, CaptionRes, HintRes);

  FValue := ADefaultValue;
  FDefaultValue := ADefaultValue;
end;

procedure TGsSPThemeStyle.DoLoad;
begin
  inherited;

  Apply;
end;

procedure TGsSPThemeStyle.DoSave;
resourcestring
  SRestartApplicationToApplyStyle = 'Der gewählte Stil ''%s'' wird beim nächsten Start aktiviert.';
begin
  inherited;

  MessageDlg(Format(SRestartApplicationToApplyStyle, [Value]), mtInformation, [mbOK], 0);
  //Apply;
end;

function TGsSPThemeStyle.GetDefaultEditFrameClass: TCustomFrameClass;
begin
  Result := TBPSPComboBoxEditFrame;
end;

function TGsSPThemeStyle.GetDefaultValue: string;
begin
  if FDefaultValue = '' then
    FDefaultValue := TStyleManager.ActiveStyle.Name;

  Result := FDefaultValue;
end;

function TGsSPThemeStyle.GetValue: string;
begin
  if FValue = '' then
    FValue := DefaultValue;

  Result := FValue;
end;

procedure TGsSPThemeStyle.GetValues(Proc: TGetValueStrProc);
var
  StyleNames:      TArray<string>;
  ActiveStyleName: string;
  I:               Integer;
begin
  StyleNames      := TStyleManager.StyleNames;
  ActiveStyleName := Value;

  for I := Low(StyleNames) to High(StyleNames) do
    Proc(StyleNames[I], StyleNames[I] = ActiveStyleName);
end;

procedure TGsSPThemeStyle.SetValue(const Value: string);
begin
  if (Value <> FValue) then
  begin
    FValue := Value;
    Change;
  end;
end;

procedure TGsSPThemeStyle.SetValues(Func: TSetValueStrFunc);
var
  StyleNames: TArray<string>;
  I:          Integer;
begin
  StyleNames := TStyleManager.StyleNames;

  for I := Low(StyleNames) to High(StyleNames) do
    if Func(StyleNames[I]) then
      Value := StyleNames[I];
end;

end.

