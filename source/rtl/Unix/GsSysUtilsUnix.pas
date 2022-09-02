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
  @abstract(Gilbertsoft System Utilities Unix specific implementations )
  @seealso(SecLicence License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains the unix specific implementations of the low level system
  routines. @see(GSSysUtils).
}
unit GsSysUtilsUnix;

{$I gsdl.inc}
{.$I unixonly.inc}

interface

uses
  GSSysUtilsCommon;

type
  TGSConvUnix = class(TGSConvCommon)
  public
  end;

implementation

uses
  GSSysUtilsAbstracts;

initialization
{$IFDEF UNIX}
  GSConv.ReplaceImplementation(TGSConvUnix);
{$ENDIF}
finalization
end.
