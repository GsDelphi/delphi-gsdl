unit GsSvcMgr;

interface

uses
  BPSvcMgr,
  Classes,
  GsLogger,
  Forms;

const
  { Command line switches }
  CMD_SWITCH_SETTINGS = 'Setup';
  CMD_SWITCH_SVC      = 'Svc';

type
  TGsServiceApplication = class(TBPServiceApplication)
  private
    SavedApplication: Forms.TApplication;
  public
    procedure Run(AppFormClass: TComponentClass; var AppFormReference; SettingsShowEditor: TMethod;
      Logger: TGsLogger); overload;
  end;

implementation

uses
  BPAppGui,
  BPCmdLineMgr,
  SysUtils,
  SvcMgr;

{ TGsServiceApplication }

procedure TGsServiceApplication.Run(AppFormClass: TComponentClass; var AppFormReference;
  SettingsShowEditor: TMethod; Logger: TGsLogger);
begin
  // Show settings
  if CmdLineSwitches.Find(CMD_SWITCH_SETTINGS) then
  begin
    if not Assigned(SettingsShowEditor) then
      raise Exception.Create('SettingsShowEditor is not assigned!');

    { TODO : migrate to settings framework first }
    (*
    Settings.Load;
    Settings.Databases.ShowEditor;
    *)
    SettingsShowEditor;

    BPAppGui.Application.Terminate;
    BPAppGui.Application.Run;
  end
  // Run as service
  else
  if CmdLineSwitches.Find(CMD_SWITCH_SVC) or Application.Installing then
  begin
    Application.Run;
  end
  // Fallback to vcl app
  else
  begin
    if Assigned(AppFormReference) then
      raise Exception.Create('AppFormReference is already assigned!');

    { TODO : implement logger first }
    if Assigned(Logger) then
      Logger.LogMessage(SApplicationStart, msNotice, CAT_SERVICE, MSG_SUCCESS);

    try
      { currently not used }
      //EpmServiceProcessor;
      Forms.Application.ProcessMessages;
      SavedApplication := Forms.Application;

      try
        Forms.Application := TApplication.Create(nil);

        try
          Application.CreateForm(AppFormClass, AppFormReference);
          BPAppGui.Application.Run;
        finally
          Forms.Application.Free;
        end;
      finally
        Forms.Application := SavedApplication;
      end;
    finally
      if Assigned(Logger) then
        Logger.LogMessage(SApplicationEnd, msNotice, CAT_SERVICE, MSG_SUCCESS);
    end;
  end;
end;

end.
