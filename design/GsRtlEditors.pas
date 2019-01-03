{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2017-2018 Simon Gilli
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
unit GsRtlEditors;

interface

uses
  DesignIntf,
  DesignEditors,
  ToolsAPI,
  Forms,
  GsDesignEditors,
  RzShellDialogs;

type
  TGsFolderPathProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

implementation

{ TGsFolderPathProperty }

procedure TGsFolderPathProperty.Edit;
var
  DlgFolder: TRzSelectFolderDialog;
begin
  DlgFolder := TRzSelectFolderDialog.Create(Application);
  DlgFolder.SelectedPathName := GetValue;
  //DlgFolder.Filter := 'Executables|*.EXE;*.BAT;*.COM;*.PIF|All Files|*.*';
  DlgFolder.Options := DlgFolder.Options + [{ofPathMustExist, ofFileMustExist}];

  try
    if DlgFolder.Execute then
      SetValue(DlgFolder.SelectedPathName);
  finally
    DlgFolder.Free;
  end;
end;

function TGsFolderPathProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;

end.
