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
  @abstract(Gilbertsoft AnsiString routines)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2019-01-09)
  @cvs($Date:$)

  @name contains system constants and resourcestrings.
}
unit GsSyslog;

interface

type
  {
      From RFC 5424 see https://tools.ietf.org/html/rfc5424

          Numerical             Facility
             Code

              0             kernel messages
              1             user-level messages
              2             mail system
              3             system daemons
              4             security/authorization messages
              5             messages generated internally by syslogd
              6             line printer subsystem
              7             network news subsystem
              8             UUCP subsystem
              9             clock daemon
             10             security/authorization messages
             11             FTP daemon
             12             NTP subsystem
             13             log audit
             14             log alert
             15             clock daemon (note 2)
             16             local use 0  (local0)
             17             local use 1  (local1)
             18             local use 2  (local2)
             19             local use 3  (local3)
             20             local use 4  (local4)
             21             local use 5  (local5)
             22             local use 6  (local6)
             23             local use 7  (local7)

              Table 1.  Syslog Message Facilities
  }
  TGsSyslogMessageFacility = (
    mfKernel,
    mfUser,
    mfMailSystem,
    mfSystemDaemons,
    mfSecurityAuthorization4,
    mfSyslogd,
    mfPrinters,
    mfNetworkNews,
    mfUUCP,
    mfClockDaemon,
    mfSecurityAuthorization10,
    mfFTPDaemon,
    mfNTPDaemon,
    mfLogAudit,
    mfLogAlert,
    mfClockDaemon15,
    mfLocal0,
    mfLocal1,
    mfLocal2,
    mfLocal3,
    mfLocal4,
    mfLocal5,
    mfLocal6,
    mfLocal7
    );

  {
           Numerical         Severity
             Code

              0       Emergency: system is unusable
              1       Alert: action must be taken immediately
              2       Critical: critical conditions
              3       Error: error conditions
              4       Warning: warning conditions
              5       Notice: normal but significant condition
              6       Informational: informational messages
              7       Debug: debug-level messages

              Table 2. Syslog Message Severities

  }
  TGsSyslogMessageSeverity = (
    msEmergency,
    msAlert,
    msCritical,
    msError,
    msWarning,
    msNotice,
    msInfo,
    msDebug
    );

resourcestring
  SEmergency = 'Emergency';
  SAlert     = 'Alert';
  SCritical  = 'Critical';
  SError     = 'Error';
  SWarning   = 'Warning';
  SNotice    = 'Notice';
  SInfo      = 'Informational';
  SDebug     = 'Debug';

const
  GS_SYSLOG_MESSAGE_SEVERITY_CAPTION: array [TGsSyslogMessageSeverity] of
    PResStringRec = (@SEmergency, @SAlert, @SCritical, @SError,
    @SWarning, @SNotice, @SInfo, @SDebug
    );

function GetSyslogMessageSeverityCaption(ASeverity: TGsSyslogMessageSeverity): String;

implementation

function GetSyslogMessageSeverityCaption(ASeverity: TGsSyslogMessageSeverity): String;
begin
  Result := LoadResString(GS_SYSLOG_MESSAGE_SEVERITY_CAPTION[ASeverity]);
end;

end.
