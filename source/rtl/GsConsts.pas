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
  @abstract(Gilbertsoft Constants)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains global constants and resourcestrings.
}

unit GsConsts;

{$I gsdl.inc}

interface

const
  AUTHOR_COMPANY  = 'Gilbertsoft GmbH';
  AUTHOR_NAME     = 'Simon Gilli';
  PRODUCT_VERSION = '0.0.0.0';

resourcestring
  SErrorNotImplemented  = '''%0:s'' ist nicht vollständig implementiert in ''%1:s'' (''%2:s'')';
  SErrorInvalidOwner    =
    'Ungültiger Eigentümer ''%0:s'' für Klasse ''%1:s''. Eigentümer muss vom Typ ''%2:s'' sein';
  SErrorSingletonExists = '''%s'' unterstützt nur eine Instanz pro Prozess';

  SParamIsNil           = 'Parameter ''%s'' darf nicht Nil sein';
  SParamIsIllegalObject = 'Ungültiges Objekt für ''%s'': %s';
  SParamIsIllegalType   = 'Ungültiger Datentyp für ''%s'': %s';
  SParamIsOutOfRange    = 'Parameter ''%s'' liegt liegt ausserhalb des Gültigkeitsbereiches von ''%s'': %u';

  SErrorUnexpected = 'Unerwarteter Fehler ''%s'' beim Aufruf von ''%s'': %s';

  SErrorInvalidItemsProp     = 'Die Eigenschaft ''%s'' von Klasse ''%s'' ist kein Nachfahre von ''%s''';
  SErrorInvalidItemIndexProp = 'Die Eigenschaft ''%s'' von Klasse ''%s'' ist nicht vom Typ ''%s''';
  SErrorItemsNotAssigned     = 'Die Elemente von ''%s'' wurden nicht durch ''%s'' zugewiesen';

implementation

initialization

finalization

end.
