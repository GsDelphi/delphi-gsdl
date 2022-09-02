{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2018 Simon Gilli
    Gilbertsoft | https://delphi.gilbertsoft.org

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
}
unit GsThemeModuleExpert;

{.$I gsdl.inc}

interface

procedure Register;

implementation

{.$R GsThemeModuleExpertCodeSnipets.res}
{$R GsThemeModuleExpertIcons.res}

uses
  GsOtaRepositoryUtils,
  JclIDEUtils,
  GsPreProcessorThemeModuleTemplates,
  DMForm,
  Classes,
  GsThemeMgr,
  GsTheme,
  DesignIntf,
  ToolsAPI,
  JclOtaConsts,
  Windows,
  JclOtaRepositoryUtils,
  SysUtils,
  JclFileUtils,
  JclPreProcessorTemplates,
  PlatformAPI,
  GsConsts;
(*  ,
  DesignEditors,
  JclOtaRepositoryReg;
  *)

type
  { TGsThemeModuleExpert }
  TGsThemeModuleExpert = class(TGsOtaRepositoryExpert)
  protected
    function GetFrameworkTypes: TArray<string>; override;
    function GetPlatforms: TArray<string>; override;
  public
    constructor Create; override;

    procedure DoExecute(const Personality: TJclBorPersonality); override;
    function IsVisible(const Personality: TJclBorPersonality): Boolean; override;

    procedure CreateThemeModule(const Params: TGsThemeModuleParams);
  end;

resourcestring
  SGsThemeModuleExpertName = 'Thememodul';
  SGsThemeModuleExpertPage = 'Delphi-Dateien';
  SGsThemeModuleExpertComment = 'Erstellt ein neues Thememodul für den GsThemeManager.';

procedure Register;
begin
  //if TJclOTAExpertBase.IsPersonalityLoaded(JclDelphiPersonality) then
  begin
    RegisterPackageWizard(TGsThemeModuleExpert.Create as IOTAWizard);
  end;

  (*
  RegisterPropertyEditor( TypeInfo( string ), TRzLauncher, 'FileName', TRzFileNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TRzLauncher, 'Action', TRzActionProperty );
  GroupDescendentsWith( TRzLauncher, Controls.TControl );
  RegisterComponentEditor( TCustomImageList, TRzImageListEditor );
  *)
end;

{ TGsThemeModuleExpert }

constructor TGsThemeModuleExpert.Create;
begin
  inherited Create(LoadResString(@SGsThemeModuleExpertName), LoadResString(@SGsThemeModuleExpertComment),
    AUTHOR_COMPANY, LoadResString(@SGsThemeModuleExpertPage), JclRepositoryCategoryDelphiFiles,
    JclDesignerVcl, JclDelphiPersonality, LoadIcon(FindResourceHInstance(HInstance), 'GsThemeModule'), ritForm);
end;

procedure TGsThemeModuleExpert.CreateThemeModule(
  const Params: TGsThemeModuleParams);

  function LoadTemplate(const FileName: string): string;
  var
    AFileStream: TFileStream;
    StreamLength: Int64;
    AnsiResult: AnsiString;
  begin
    AnsiResult := '';
    if FileExists(FileName) then
    begin
      AFileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
      try
        StreamLength := AFileStream.Size;
        SetLength(AnsiResult, StreamLength);
        AFileStream.ReadBuffer(AnsiResult[1], StreamLength);
      finally
        AFileStream.Free;
      end;
    end;
    Result := string(AnsiResult);
  end;

  function PathGetAbsolutePath(const P: string): string;
  var
    ActiveEditBuffer: IOTAEditBuffer;
    ActiveProject: IOTAProject;
    CurrentDirectory: string;
  begin
    if not PathIsAbsolute(P) then
    begin
      CurrentDirectory := '';
      ActiveEditBuffer := GetActiveEditBuffer;
      if Assigned(ActiveEditBuffer) then
        CurrentDirectory := ExtractFileDir(ActiveEditBuffer.FileName);
      if CurrentDirectory = '' then
      begin
        ActiveProject := GetActiveProject;
        if Assigned(ActiveProject) then
          CurrentDirectory := ExtractFileDir(ActiveProject.FileName);
      end;
      if CurrentDirectory <> '' then
        Result := PathGetRelativePath(PathAddSeparator(CurrentDirectory), P)
      else
        Result := P;
    end
    else
      Result := P;
  end;
const
  TemplateSubDir = 'experts\repository\ThemeModule\Templates\';
  DelphiTemplate = 'ThemeModule.Delphi32';
  BCBTemplate = 'ThemeModule.CBuilder32';
var
  TemplatePath, FormExtension, FormTemplate, FormContent, FormFileName,
  HeaderExtension, HeaderTemplate, HeaderContent, HeaderFileName,
  SourceExtension, SourceTemplate, SourceContent, SourceFileName: string;
begin
  TemplatePath := PathAddSeparator('D:\SW-Projekte\Components\GSDL\gsdl'{JCLRootDir}) + TemplateSubDir;

  case Params.Language of
    bpDelphi32:
      begin
        FormExtension := JclBorDesignerFormExtension[Params.Designer];
        FormTemplate := DelphiTemplate + FormExtension;
        HeaderExtension := '';
        HeaderTemplate := '';
        SourceExtension := SourceExtensionPAS;
        SourceTemplate := DelphiTemplate + SourceExtension;
      end;
    bpBCBuilder32:
      begin
        FormExtension := JclBorDesignerFormExtension[Params.Designer];
        FormTemplate := BCBTemplate + FormExtension;
        HeaderExtension := SourceExtensionH;
        HeaderTemplate := BCBTemplate + HeaderExtension;
        SourceExtension := SourceExtensionCPP;
        SourceTemplate := BCBTemplate + SourceExtension;
      end;
  else
      begin
        FormExtension := '';
        FormTemplate := '';
        HeaderExtension := '';
        HeaderTemplate := '';
        SourceExtension := '';
        SourceTemplate := '';
      end;
  end;

  FormTemplate := LoadTemplate(TemplatePath + FormTemplate);
  HeaderTemplate := LoadTemplate(TemplatePath + HeaderTemplate);
  SourceTemplate := LoadTemplate(TemplatePath + SourceTemplate);

  FormContent := ApplyTemplate(FormTemplate, Params);
  HeaderContent := ApplyTemplate(HeaderTemplate, Params);
  SourceContent := ApplyTemplate(SourceTemplate, Params);

  if Params.FileName <> '' then
  begin
    FormFileName := PathGetAbsolutePath(ChangeFileExt(Params.FileName, FormExtension));
    HeaderFileName := PathGetAbsolutePath(ChangeFileExt(Params.FileName, HeaderExtension));
    SourceFileName := PathGetAbsolutePath(ChangeFileExt(Params.FileName, SourceExtension));
  end
  else
  begin
    FormFileName := '';
    HeaderFileName := '';
    SourceFileName := '';
  end;

  CreateForm(Params.FormAncestor, Params.FormName, FormFileName, FormContent, SourceFileName,
    SourceContent, HeaderFileName, HeaderContent);
end;

procedure TGsThemeModuleExpert.DoExecute(const Personality: TJclBorPersonality);
var
  AParams: TGsThemeModuleParams;
begin
  AParams := TGsThemeModuleParams.Create;

  try
    AParams.Languages := [bpDelphi32];
    AParams.Language := bpDelphi32;
    AParams.ActivePersonality := bpDelphi32;

    (*
    if ExcDlgWizard(AParams) and (AParams.Language <> bpUnknown) then
      CreateExceptionDialog(AParams);
    *)

    CreateThemeModule(AParams);
  finally
    AParams.Free;
  end;
end;

function TGsThemeModuleExpert.GetFrameworkTypes: TArray<string>;
begin
  Result := TArray<string>.Create(sFrameworkTypeVCL);
end;

function TGsThemeModuleExpert.GetPlatforms: TArray<string>;
begin
  Result := TArray<string>.Create(cWin32Platform, cWin64Platform);
end;

function TGsThemeModuleExpert.IsVisible(
  const Personality: TJclBorPersonality): Boolean;
begin
  Result := Personality = bpDelphi32;
end;

end.
