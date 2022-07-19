unit GsSettingsSlackLogger;

{$I gsdl.inc}

interface

uses
  BPSettings,
  GsLogger,
  GsSlackApi,
  GsSlackLogger,
  GsSURI,
  System.Contnrs,
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}UITypes{$ELSE}ImgList{$ENDIF};

type
  TGsSSlackLoggerItem = class(TGsSURINotificationItem, IGsSlackLoggerConfiguration)
  protected
    function GetWebhookURL: WebhookURL; virtual;
  end;

  TGsSSlackLogger = class(TGsSURINotificationList, IGsLoggerDispatcher)
  private
  protected
    function GetIsRealtime: Boolean; virtual;
    //function Supports(AClass: TGsLoggerClass): Boolean; overload;
    function Supports(AObject: TAbstractGsLogger): Boolean; virtual; overload;
    function DispatchMessage(AObject: TAbstractGsLogger; AMessage: TGsLogMessage; AContext: TObjectList): Boolean; virtual;
  public
    constructor CreateSlackLogger(AOwner: TCustomBPSettings;
      AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); virtual;
    constructor CreateNotificationList(AOwner: TCustomBPSettings;
      AName: string; CaptionRes, HintRes: PResStringRec;
      AImageIndex: TImageIndex = -1); override;
  end;

implementation

{ TGsSSlackLoggerItem }

function TGsSSlackLoggerItem.GetWebhookURL: WebhookURL;
begin
  Result := URI;
end;

{ TGsSSlackLogger }

constructor TGsSSlackLogger.CreateNotificationList(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateSlackLogger(AOwner, AName, CaptionRes, HintRes, AImageIndex);
end;

constructor TGsSSlackLogger.CreateSlackLogger(AOwner: TCustomBPSettings;
  AName: string; CaptionRes, HintRes: PResStringRec; AImageIndex: TImageIndex);
begin
  CreateList(AOwner, AName, CaptionRes, HintRes, TGsSSlackLoggerItem, AImageIndex);
end;

function TGsSSlackLogger.DispatchMessage(AObject: TAbstractGsLogger;
  AMessage: TGsLogMessage; AContext: TObjectList): Boolean;
var
  I: Integer;
begin
  if AObject is TGsSlackLogger then
  begin
    for I := 0 to Count - 1 do
    begin
      if (AMessage.FEventType <= msNotice) or not Loaded or
        (AMessage.FEventType <= Items[I].LoggingLevel) then
      begin
        try
          (AObject as IGsLogger).DispatchMessage(AMessage, AContext);
          FLogger.PostSlack(WebhookURL(LLoggerSettings.Slack.Items[I].URI), LogMessage);
        except
          on E: Exception do
          begin
            FLogger.EventLogger.LogMessage(Format('Exception in FLogger.PostSlack: %s', [E.Message]),
              EVENTLOG_ERROR_TYPE, CAT_SERVICE, MSG_SUCCESS);
          end;
        end;
      end;
    end;
  end
  else
    Result := False;
end;

function TGsSSlackLogger.GetIsRealtime: Boolean;
begin
  Result := False
end;

function TGsSSlackLogger.Supports(AObject: TAbstractGsLogger): Boolean;
begin
  Result := AObject is TGsSlackLogger;
end;

initialization
finalization
end.

