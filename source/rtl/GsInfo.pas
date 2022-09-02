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
{
  @abstract(Gilbertsoft Application Infos)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains system constants and resourcestrings.
}
unit GSInfo;

{$I gsdl.inc}

interface

uses
  BPInfo; // important to override BPRegBPKeysProc hook!

implementation

uses
  BPRegistry, BPLogging;

const
  { Company info }
  GS_COMPANY_NAME = 'Gilbertsoft';
//  GS_COMPANY_NAME_PREVIOUS = 'Brupel AG' deprecated;

var
//  SaveBPRegCompanyKeysProc: TBPRegCompanyKeys;
  SaveBPRegBPKeysProc: TBPRegBPKeys;
//  SaveBPRegAppKeysProc: TBPRegAppKeys;

function RegBPKeys(const ARoot: TBPRegKey): TBPRegSubKeys;
begin
  if (BPCompanyNamePrevious <> '') then
  begin
    SetLength(Result, 2);
    Result[1] := BP_KEY_ROOT_SOFTWARE + BP_KEY_PATH_DELIMITER + BPCompanyNamePrevious;
  end
  else
    SetLength(Result, 1);

  Result[0] := BP_KEY_ROOT_SOFTWARE + BP_KEY_PATH_DELIMITER + GS_COMPANY_NAME;
end;

initialization
  BPC_CodeSite.EnterInitialization('GSInfo');

  SaveBPRegBPKeysProc := BPRegBPKeysProc;

  BPRegBPKeysProc := RegBPKeys;

  BPC_CodeSite.ExitInitialization('GSInfo');
finalization
  BPC_CodeSite.EnterFinalization('GSInfo');

  BPRegBPKeysProc := SaveBPRegBPKeysProc;

  BPC_CodeSite.ExitFinalization('GSInfo');
end.
