unit GsSLogger;

{$I gsdl.inc}

interface

uses
  BPSettings,
  GsSSyslog,
  GsSURI;

type
  TGsSLogger = class(TCustomBPSubSettings)
  private
    FEventLog: TGsSPLoggingLevel;
    FSlack:    TGsSURINotificationList;
    FDatabase: TGsSPLoggingLevel;
  protected
    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    property EventLog: TGsSPLoggingLevel read FEventLog;
    property Slack: TGsSURINotificationList read FSlack;
    property Database: TGsSPLoggingLevel read FDatabase;
  published
  end;

implementation

{ TGsSLogger }

procedure TGsSLogger.CreateProperties;
resourcestring
  SEventLog     = 'EventLog';
  SEventLogHint = '';
  SSlack        = 'Slack';
  SSlackHint    = '';
  SDatabase     = 'Database';
  SDatabaseHint = '';
begin
  inherited;

  FEventLog := TGsSPLoggingLevel.CreateLoggingLevel(Self, 'EventLog', @SEventLog, @SEventLogHint{, msInfo});
  FSlack    := TGsSURINotificationList.CreateNotificationList(Self, 'Slack', @SSlack, @SSlackHint);
  FDatabase := TGsSPLoggingLevel.CreateLoggingLevel(Self, 'Database', @SDatabase, @SDatabaseHint{, msInfo});
end;

end.
