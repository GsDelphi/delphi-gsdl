unit GsSettings;

interface

uses
  BPSettings;

type
  TGsSPPasswordHash = class(TBPSPString)
  protected
    { TBPSPString }
    procedure SetValue(const Value: String); override;
  public
    function CheckPassword(const Password: string;
      out PasswordRehashNeeded: Boolean): Boolean;
  end;

implementation

uses
  GsCrypto;

{ TGsSPPasswordHash }

function TGsSPPasswordHash.CheckPassword(const Password: string;
  out PasswordRehashNeeded: Boolean): Boolean;
begin
  Result := GsCrypto.CheckPassword(Password, Value, PasswordRehashNeeded);
end;

procedure TGsSPPasswordHash.SetValue(const Value: String);
begin
  inherited SetValue(GsCrypto.HashPassword(Value));
end;

end.
