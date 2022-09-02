unit GsAppExplorer;

interface

uses
  Classes;

const
  SCOPE_LOCAL  = '.';
  SCOPE_GLOBAL = '*';

type
  TScope1 = (sLocal, sRemote, sDomain, sPrimaryDomain);
  TScope  = type String;

  TMailslot = record
    Domain:    string;
    Namespace: string;
    Server:    THandle;
    Client:    THandle;
  end;

  TGsAppExplorer = class(TComponent)
  private
    FMailslots: array of THandle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Listen(const Domain, Namespace: string);
    procedure Discover(const Domain, Namespace, Service: string; List: TStrings);
  end;

implementation

uses
  SysUtils,
  Windows;

const
  MAILSLOT_SCOPE: array[TScope1] of string = ('.', '%s', '%s', '*');
  MAILSLOT_FORMAT      = '\\%s\mailslot\%s';
  MAILSLOT_MAX_MSG_LEN = 424;

resourcestring
  SErrorCreateMailslot = 'Der Mailslot ''%s'' konnte nicht erzeugt werden: %s';

type
  TMailslotMsg = packed record
    CompiledFile, UnitName, ClassName, ProcName: array[0..MaxMailSlotFieldLenW - 1] of WideChar;
    Line, Offset: Integer;
    Compiled: TDateTime;
  end;



{ TGsAppExplorer }

constructor TGsAppExplorer.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TGsAppExplorer.Destroy;
begin

  inherited;
end;

procedure TGsAppExplorer.Discover(const Scope, Namespace, Service: string; List: TStrings);
var
  Stream: TFileStream;
begin

end;

procedure TGsAppExplorer.Listen(const Scope, Namespace: string);
var
  Handle: THandle;
begin
  Handle := CreateMailslot(PChar(Format(MAILSLOT_FORMAT, [MAILSLOT_SCOPE[sPrimaryDomain], Namespace])), 0, 0, nil);

  if (Handle = INVALID_HANDLE_VALUE) then
    raise Exception.CreateResFmt(@SErrorCreateMailslot, [Namespace, SysErrorMessage(GetLastError)]);

  SetLength(FMailslots, Length(FMailslots) + 1);
  FMailslots[High(FMailslots)] := Handle;
end;

end.
