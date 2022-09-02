unit GsSignTool;

{$I gsdl.inc}
{$DEFINE Compiler5_Up}
{$DEFINE Compiler9_Up}

interface

uses
  ToolsAPI;

implementation

uses
  BPLaunch,
  Classes,
  Dialogs,
  RzLaunch,
  SysUtils,
  Windows;

type
  TIDENotifier = class(TInterfacedObject,
    IOTAIDENotifier
    {$IFDEF Compiler5_Up}, IOTAIDENotifier50{$ENDIF}
    {$IFDEF Compiler9_Up}, IOTAIDENotifier80{$ENDIF})
  private
    FProjectFiles: TStringList;
    FProject: IOTAProject;
    procedure AddProjectFile(const AFileName: String);
    procedure RemoveProjectFile(const AFileName: String);
    function LaunchSignTool(const AFileName: String): Integer;
  protected
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Modified;
    procedure FileNotification(NotifyCode: TOTAFileNotification;
      const FileName: String; var Cancel: Boolean);

    procedure BeforeCompile(const Project: IOTAProject; var Cancel: Boolean); overload;
    procedure BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean;
      var Cancel: Boolean); overload;

    procedure AfterCompile(Succeeded: Boolean); overload;
    procedure AfterCompile(Succeeded: Boolean; IsCodeInsight: Boolean); overload;
    procedure AfterCompile(const Project: IOTAProject; Succeeded: Boolean;
      IsCodeInsight: Boolean); overload;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  FIDENotifierIndex: Integer;

procedure RegisterNotifier;
var
  OTAServices: IOTAServices;
  IDENotifier: IOTAIDENotifier;
begin
  FIDENotifierIndex := -1;

  if Supports(BorlandIDEServices, IOTAServices, OTAServices) then
  begin
    IDENotifier := TIDENotifier.Create;
    FIDENotifierIndex := OTAServices.AddNotifier(IDENotifier);
  end;
end;

procedure RemoveNotifier;
var
  OTAServices: IOTAServices;
begin
  if (FIDENotifierIndex >= 0) and Supports(BorlandIDEServices,
    IOTAServices, OTAServices) then
  begin
    OTAServices.RemoveNotifier(FIDENotifierIndex);
    FIDENotifierIndex := -1;
  end;
end;

procedure AddCompilerMsg(const AFileName, AMessage: String);
var
  MessageSvc: IOTAMessageServices40;
begin
  if not Supports(BorlandIDEServices, IOTAMessageServices40, MessageSvc) then
  begin
    (*
    DebugDump(Format('[%s] (%s): %s', ['EurekaLog', ExtractFileName(AFileName), AMessage]));
    Result := inherited AddCompilerMsg(AFileName, AMessage, AKind, AParent);
    *)
    Exit;
  end;

  MessageSvc.AddToolMessage(AFileName, AMessage, 'GsSignTool', -1, -1);
end;

{ TIDENotifier }

procedure TIDENotifier.AddProjectFile(const AFileName: String);
begin
  FProjectFiles.Add(AFileName);
end;

procedure TIDENotifier.AfterCompile(const Project: IOTAProject;
  Succeeded, IsCodeInsight: Boolean);
var
  FileName: String;
  Index: Integer;
  Start: Cardinal;
  ONs: TOTAOptionNameArray;
  I: Integer;
begin
  try
    if IsCodeInsight or (FProjectFiles.Count = 0) then
      Exit;

    Exit;
    ShowMessage(Format('Project files: %u / %s / %s', [FProjectFiles.Count, FProjectFiles[0], Project.FileName]));

    if Project <> nil then
      FProject := Project;

    ONs := Project.ProjectOptions.GetOptionNames;

    for I := Low(ONs) to High(ONs) do
      FileName := FileName + ONs[I].Name + ', ';

    Delete(FileName, Length(FileName) - 1, 2);

    ShowMessage(FileName);

    (*
      TOTAOptionNameArray

    if Assigned(Project) then
      Index := ModuleOptions.FindByName(Project.FileName)
    else
      Index := ModuleOptions.FindByName(FProjectFiles[0]);

    if (Index >= 0) and FileExists(ModuleOptions[Index].CompiledFile) then
    begin
      if Succeeded then
      begin
        Start := GetTickCount;
        AddCompilerMsg(FileName, 'Signing project file');
        //AddCompilerMsg(FileName, Format('Exit Code: %u', [LaunchSignTool(FileName)]));
        AddCompilerMsg(FileName, Format('Signing done in %u ms', [GetTickCount - Start]));
      end;
    end;
    *)

    if Assigned(Project) then
      RemoveProjectFile(Project.FileName)
    else
      RemoveProjectFile(FProjectFiles[0]);

    FProject := nil;
  except
    on E: Exception do
      ShowMessage(Format('Exception in %s.%s. Error ''%s''',
        [ClassName, 'AfterCompile', E.Message]));
  end;
end;

procedure TIDENotifier.AfterCompile(Succeeded: Boolean);
begin
  {$IFNDEF DELPHI5_UP}
  AfterCompile(Succeeded, False);
  {$ENDIF}
end;

procedure TIDENotifier.AfterCompile(Succeeded, IsCodeInsight: Boolean);
begin
  {$IFNDEF DELPHI8_UP}
  AfterCompile(FProject, Succeeded, IsCodeInsight);
  {$ENDIF}
end;

procedure TIDENotifier.AfterSave;
begin
  { do nothing, stub only }
end;

procedure TIDENotifier.BeforeCompile(const Project: IOTAProject;
  IsCodeInsight: Boolean; var Cancel: Boolean);
begin
  if IsCodeInsight or (Project = nil) then
    Exit;

  { Save the first given project }
  if (FProject = nil) then
    FProject := Project;

  AddProjectFile(Project.FileName);
end;

procedure TIDENotifier.BeforeCompile(const Project: IOTAProject; var Cancel: Boolean);
begin
  {$IFNDEF DELPHI5_UP}
  BeforeCompile(Project, False, Cancel);
  {$ENDIF}
end;

procedure TIDENotifier.BeforeSave;
begin
  { do nothing, stub only }
end;

constructor TIDENotifier.Create;
begin
  inherited Create;

  FProjectFiles := TStringList.Create;
end;

destructor TIDENotifier.Destroy;
begin
  FProjectFiles.Free;

  inherited Destroy;
end;

procedure TIDENotifier.Destroyed;
begin
  { do nothing, stub only }
end;

procedure TIDENotifier.FileNotification(NotifyCode: TOTAFileNotification;
  const FileName: String; var Cancel: Boolean);
begin
  { do nothing, stub only }
end;

function TIDENotifier.LaunchSignTool(const AFileName: String): Integer;
var
  SignTool: TBPLauncher;
begin
  Result := -1;

  if not FileExists(AFileName) then
    Exit;

  SignTool := TBPLauncher.Create(nil);

  try
    SignTool.WaitType := wtProcessMessages;
    SignTool.WaitUntilFinished := True;
    SignTool.FileName := 'D:\SW-Projekte\Scripts\keys\signit.bat';
    SignTool.Parameters := '"' + AFileName + '"';

    SignTool.Launch;
    Result := SignTool.ExitCode;
  finally
    SignTool.Free;
  end;
end;

procedure TIDENotifier.Modified;
begin
  { do nothing, stub only }
end;

procedure TIDENotifier.RemoveProjectFile(const AFileName: String);
var
  I: Integer;
begin
  I := FProjectFiles.IndexOf(AFileName);
  if I > -1 then
    FProjectFiles.Delete(I);
end;

initialization
  RegisterNotifier;

finalization
  RemoveNotifier;

end.

