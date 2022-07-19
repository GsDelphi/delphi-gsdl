unit GsSHttp;

{$I gsdl.inc}

interface

uses
  BPSettings,
  BPSettingsEditorIntf,
  Classes,
  IdAssignedNumbers,
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  (*
  TGsSHttp = class(TCustomBPSubSettings)
  private
    FPort:        TBPSPInteger;
    FUsername:    TBPSPString;
    FPassword:    TBPSPPassword;
    FDefaultPort: Integer;
    FDefaultUsername: String;
    FDefaultPassword: String;
    function GetPassword: String;
    function GetPort: Word;
    function GetUsername: String;
    procedure SetPassword(const Value: String);
    procedure SetPort(const Value: Word);
    procedure SetUsername(const Value: String);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    constructor CreateHttpServer(AOwner: TCustomBPSettings; AName: String;
      CaptionRes, HintRes: PResStringRec; ADefaultPort: Word = IdPORT_HTTP;
      ADefaultUsername: String = ''; ADefaultPassword: String = ''); virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: String;
      CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex = -1); override;

    { TPersistent }
    //procedure Assign(Source: TPersistent); override;

    { Settings properties }
    //property _IP: TBPSPString read FHost;
    property _Port: TBPSPInteger read FPort;
    property _Username: TBPSPString read FUsername;
    property _Password: TBPSPPassword read FPassword;

    { Easy property access }
    //property IP: String read GetHost write SetHost;
    property Port: Word read GetPort write SetPort;
    property Username: String read GetUsername write SetUsername;
    property Password: String read GetPassword write SetPassword;
  end;
  *)

  TGsSHttpServer = class(TCustomBPSubSettings)
  private
    FPort:        TBPSPInteger;
    FUsername:    TBPSPString;
    FPassword:    TBPSPPassword;
    FDefaultPort: Integer;
    FDefaultUsername: String;
    FDefaultPassword: String;
    function GetPassword: String;
    function GetPort: Word;
    function GetUsername: String;
    procedure SetPassword(const Value: String);
    procedure SetPort(const Value: Word);
    procedure SetUsername(const Value: String);
  protected
    { TPersistent }
    procedure AssignTo(Dest: TPersistent); override;

    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    constructor CreateHttpServer(AOwner: TCustomBPSettings; AName: String;
      CaptionRes, HintRes: PResStringRec; ADefaultPort: Word = IdPORT_HTTP;
      ADefaultUsername: String = ''; ADefaultPassword: String = ''); virtual;
    constructor Create(AOwner: TCustomBPSettings; AName: String;
      CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex = -1); override;

    { TPersistent }
    //procedure Assign(Source: TPersistent); override;

    { Settings properties }
    //property _IP: TBPSPString read FHost;
    property _Port: TBPSPInteger read FPort;
    property _Username: TBPSPString read FUsername;
    property _Password: TBPSPPassword read FPassword;

    { Easy property access }
    //property IP: String read GetHost write SetHost;
    property Port: Word read GetPort write SetPort;
    property Username: String read GetUsername write SetUsername;
    property Password: String read GetPassword write SetPassword;
  end;

  //TIdCustomHTTPServer

implementation

uses
  IdCustomHTTPServer;

{ TGsSHttpServer }

procedure TGsSHttpServer.AssignTo(Dest: TPersistent);
begin
  if Dest is TIdCustomHTTPServer then
  begin
    with TIdCustomHTTPServer(Dest) do
    begin
      DefaultPort := Self.Port;
      //Username := Self.Username;
      //Password := Self.Password;
    end;
  end
  else
    inherited;
end;

constructor TGsSHttpServer.Create(AOwner: TCustomBPSettings; AName: String;
  CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  inherited;

end;

constructor TGsSHttpServer.CreateHttpServer(AOwner: TCustomBPSettings;
  AName: String; CaptionRes, HintRes: PResStringRec; ADefaultPort: Word;
  ADefaultUsername, ADefaultPassword: String);
begin

end;

procedure TGsSHttpServer.CreateProperties;
begin
  inherited;

end;

function TGsSHttpServer.GetPassword: String;
begin

end;

function TGsSHttpServer.GetPort: Word;
begin

end;

function TGsSHttpServer.GetUsername: String;
begin

end;

procedure TGsSHttpServer.SetPassword(const Value: String);
begin

end;

procedure TGsSHttpServer.SetPort(const Value: Word);
begin

end;

procedure TGsSHttpServer.SetUsername(const Value: String);
begin

end;

end.

