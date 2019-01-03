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
unit GsThemeEditors;

interface

uses
  DesignIntf,
  DesignEditors,
  ToolsAPI,
  GsDesignEditors,
  Classes,
  DMForm;

type
  { TGsThemeModuleEditor }
  //TGsThemeModuleEditor = class(TDefaultEditor)
  TGsThemeModuleEditor = class(TGsComponentEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  { TGsThemeCustomModule }
  //TGsThemeCustomModule = class(TDataModuleCustomModule)
  TGsThemeCustomModule = class(TCustomModule)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ValidateComponent(Component: TComponent); override;
  end;

procedure Register;

implementation

uses
  StrEdit,
  GsTheme,
  GsThemeEditorForm;

resourcestring
  SEditTheme = 'Theme bearbeiten...';

procedure Register;
begin
  //if TJclOTAExpertBase.IsPersonalityLoaded(JclDelphiPersonality) then
  begin
    RegisterPropertyEditor(TypeInfo(TGsImageListFileNames), TGsThemeImageList, '', TValueListProperty);
    RegisterComponentEditor(TCustomGsTheme, TGsThemeModuleEditor);
    RegisterCustomModule(TCustomGsTheme, TGsThemeCustomModule);
  end;

  (*
  RegisterPropertyEditor( TypeInfo( string ), TRzLauncher, 'FileName', TRzFileNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TRzLauncher, 'Action', TRzActionProperty );
  GroupDescendentsWith( TRzLauncher, Controls.TControl );
  RegisterComponentEditor( TCustomImageList, TRzImageListEditor );
  *)
end;

{ TGsThemeModuleEditor }

procedure TGsThemeModuleEditor.Edit;
begin
  ExecuteVerb(0);
end;

procedure TGsThemeModuleEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
  begin
    if Component is TCustomGsTheme then
      (*
      (Component as TCustomGsTheme).Test;
      *)
      ShowThemeEditor({TForm(Root.Owner).}Designer, TCustomGsTheme(Component) {,
        TCustomGsTheme(Root).Actions, 'Actions'});
  end;
end;

function TGsThemeModuleEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := SEditTheme
  else
    Result := '';
end;

function TGsThemeModuleEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TGsThemeCustomModule }

procedure TGsThemeCustomModule.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
  begin
    if Root is TCustomGsTheme then
      ShowThemeEditor({TForm(Root.Owner).}Designer, TCustomGsTheme(Root) {,
        TCustomGsTheme(Root).Actions, 'Actions'});
  end;
end;

function TGsThemeCustomModule.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := SEditTheme
  else
    Result := '';
end;

function TGsThemeCustomModule.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TGsThemeCustomModule.ValidateComponent(Component: TComponent);
begin
  inherited;
  (*
  if (Component = nil) or (Component is TControl) then
    raise Exception.CreateRes(@SControlInWebModule);
  *)
end;

end.
