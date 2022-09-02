{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2019 Simon Gilli
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
  @abstract(Gilbertsoft Service Discovery constants)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2019-03-17)
  @cvs($Date:$)

  @name contains constants and resourcestrings.
}
unit GsServiceDiscoveryConsts;

{.$I gsdl.inc}

interface

resourcestring
  SErrorInvalidMessage  = 'Fehler bei der Verarbeitung der Nachricht: %s';
  SErrorInvalidTypeCast = 'Fehler bei der Umwandlung der Klasse ''%s'' zu ''%s'': %s';
  SErrorSendingMessage  = 'Fehler beim Senden der Nachricht ''%s'': %s';

  SErrorCreateMailslot        = 'Der Mailslot ''%s'' konnte nicht erzeugt werden: %s';
  SErrorInvalidMailslot       = 'Ungültiger Handle für Mailslot ''%s''.';
  SErrorMailslotEmpty         = 'Kein Nachricht im Mailslot vorhanden.';
  SErrorMailslotMessageLength = 'Die Nachricht (%u Zeichen) übersteigt das Maximum von %u Zeichen.';
  SErrorWriteMailslot         = 'Fehler beim Senden an den Mailslot: %s';

implementation

end.
