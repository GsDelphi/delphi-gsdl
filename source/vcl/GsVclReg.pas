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
unit GsVclReg;

interface

procedure Register;

implementation

uses
  Forms,
  Classes,
  Controls,
  SysUtils,
  StdCtrls,
  Buttons,
  Dialogs,
  Graphics,
  ImgList,
  Registry,

{$IFDEF WIN32}
{$IFDEF VCL90_OR_HIGHER}
  ToolsAPI,
{$ENDIF}
  DesignIntf,
  TreeIntf,
  VCLEditors,
  // FiltEdit,
  GsDesignConsts,

  {Design Editors}
  // RzDesignEditors,
{$ENDIF}
  {Component Units}
  GsSplit,
  GsThemeMgr,
  GsTheme;

procedure Register;
begin
  RegisterComponents(GS_PAGE_PANELS, [TGsSplitter]);
  RegisterComponents(GS_PAGE_THEMES, [TGsThemeController, TGsThemeStyler]);
end;

end.
