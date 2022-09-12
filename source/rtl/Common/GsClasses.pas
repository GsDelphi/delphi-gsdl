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
unit GsClasses;

{$I gsdl.inc}

interface

uses
  Classes,
  DECCiphers,
  DECFormat,
  DECHash,
  DECUtil,
  GsCrypto,
  GsTypes,
  GsZLib,
  SysUtils;

type
  { Standard events }
  TGsNotifyEvent   = TNotifyEvent;
  TGsGetStrProc    = TGetStrProc;
  TGsProgressEvent = procedure(Sender: TObject; TotalParts, PartsComplete: Integer;
    var Continue: Boolean; const Msg: string) of object;

  TGsPersistent = class(TPersistent);

  { TGsStream }
  EGsStreamError = class(EStreamError);
  EGsStreamSignatureError = class(EGsStreamError);

  TGsSignature          = type String;
  TGsDataSize           = type Int64;
  TGsHeaderSize         = type Int32;
  TGsHeaderVersion      = type Int32;
  TGsCompressionEnabled = type Boolean;
  TGsCryptionEnabled    = type Boolean;

  TGsStream = class(TStream)
  private
    FData:           TMemoryStream;
    FCompEnabled:    TGsCompressionEnabled;
    FCompLevel:      TZCompressionLevel;
    FCryptEnabled:   TGsCryptionEnabled;
    FCryptPassword:  string;
    FCryptCipherClass: TDECCipherClass;
    FCryptCipherMode: TCipherMode;
    FCryptFormatClass: TDECFormatClass;
    FCryptHashClass: TDECHashClass;
    FCryptKDFIndex:  LongWord;
    FSignature:      TGsSignature;
    FIsCompressed:   TGsCompressionEnabled;
    FIsEncrypted:    TGsCryptionEnabled;
    function GetSignature: TGsSignature;
  protected
    function GetSize: Int64; override;
    procedure SetSize(NewSize: Longint); overload; override;
    procedure SetSize(const NewSize: Int64); overload; override;

    property IsCompressed: TGsCompressionEnabled read FIsCompressed;
    property IsEncrypted: TGsCryptionEnabled read FIsEncrypted;
  public
    constructor Create; overload;
    constructor Create(const APassword: string); overload;
    constructor Create(const APassword: string; ALevel: TZCompressionLevel); overload;
    constructor Create(ALevel: TZCompressionLevel); overload;
    destructor Destroy; override;

    // Methods
    procedure Clear;
    procedure ClearProtected;

    // Methods implementing cryption and compression
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);

    // Redirects
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;

    // Properties
    property CompressionEnabled: TGsCompressionEnabled
      read FCompEnabled write FCompEnabled;
    property CompressionLevel: TZCompressionLevel read FCompLevel write FCompLevel;

    property CryptionEnabled: TGsCryptionEnabled read FCryptEnabled write FCryptEnabled;
    property CryptionPassword: string read FCryptPassword write FCryptPassword;
    property CryptionCipherClass: TDECCipherClass
      read FCryptCipherClass write FCryptCipherClass;
    property CryptionCipherMode: TCipherMode
      read FCryptCipherMode write FCryptCipherMode;
    property CryptionFormatClass: TDECFormatClass
      read FCryptFormatClass write FCryptFormatClass;
    property CryptionHashClass: TDECHashClass
      read FCryptHashClass write FCryptHashClass;
    property CryptionKDFIndex: LongWord read FCryptKDFIndex write FCryptKDFIndex;

    property Signature: TGsSignature read GetSignature write FSignature;
  end;

  TGsComponent = class(TComponent)
  private
    FAboutInfo: TGsAboutInfo;
  published
    property About: TGsAboutInfo read FAboutInfo write FAboutInfo stored False;
  end;

  TGsThread = class(TThread)
  private
    FAboutInfo: TGsAboutInfo;
  protected
    procedure Execute; override; deprecated;
    procedure ExecuteNew; virtual; abstract;
  public
    class function Name: string; virtual;
    function WaitForInISAPI: LongWord;
  end;

procedure ReadSignature(Stream: TStream; const ExpectedSignature: TGsSignature);
  overload;
procedure ReadSignature(Stream: TStream; const ExpectedSignatures: array of TGsSignature;
  out Signature: TGsSignature); overload;
procedure WriteSignature(Stream: TStream; const Signature: TGsSignature);

implementation

uses
  {$IFDEF USE_CODESITE}BPLogging,{$ENDIF}
  AnsiStrings,
  BPClasses,
  GsIDEUtils,
  GsStreams,
  Math,
  Windows;

const
  STREAM_HEADER_SIZE: TGsHeaderSize = 32;
  STREAM_HEADER_VERSION: TGsHeaderVersion = 0;

resourcestring
  SInvalidSignature = 'Keine Stream-Signaturen übergeben.';
  SInvalidStream = 'Ungültiges Stream-Format.';
  SInvalidCryptionPassword = 'Schlüssel für die Verschlüsselung ist nicht definiert.';

procedure ReadSignature(Stream: TStream; const ExpectedSignature: TGsSignature);
var
  Signature: TGsSignature;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('ReadSignature');{$ENDIF}

  ReadSignature(Stream, [ExpectedSignature], Signature);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('ReadSignature');{$ENDIF}
end;

procedure ReadSignature(Stream: TStream; const ExpectedSignatures: array of TGsSignature;
  out Signature: TGsSignature);

  function MaxSignatureLength: Integer;
  var
    I: Integer;
  begin
    Result := 0;

    for I := Low(ExpectedSignatures) to High(ExpectedSignatures) do
      if (Length(ExpectedSignatures[I]) > 0) then
        Result := Max(Result, (Length(ExpectedSignatures[I]) *
          SizeOf(ExpectedSignatures[I][1])) + 1);
  end;

var
  S, L, ReadCount: Integer;
  HeaderBytes: TBytes;
  Header:  TGsSignature;
  AHeader: AnsiString;
  ASignature: AnsiString;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('ReadSignature');{$ENDIF}

  // Check ExpectedSignatures
  if (Length(ExpectedSignatures) = 0) then
    raise EGsStreamSignatureError.CreateRes(@SInvalidSignature);

  // Read largest signature byte length
  SetLength(HeaderBytes, MaxSignatureLength + 1);
  FillChar(HeaderBytes[0], Length(HeaderBytes), 0);
  ReadCount := Stream.Read(HeaderBytes, 0, Length(HeaderBytes) - 1);
  Header  := TEncoding.UTF8.GetString(HeaderBytes);
  AHeader := Ansistring(TEncoding.ANSI.GetString(HeaderBytes));

  // Compare with expected signatures
  for S := Low(ExpectedSignatures) to High(ExpectedSignatures) do
  begin
    Signature := ExpectedSignatures[S];
    L := Length(Signature);

    // Verify signature trailer, must be null terminated
    if (L = 0) or (Signature[L] <> #0) then
      Signature := Signature + #0;

    // Convert signature to an ansistring
    ASignature := Ansistring(Signature);

    // Compare signature
    if ((ReadCount > (Length(Signature) * SizeOf(Signature[1]))) and
      SysUtils.SameText(Signature, Header)) then
    begin
      // multi byte signature found, reset position properly and exit
      Stream.Seek((Length(Signature) * SizeOf(Signature[1])) - ReadCount, soFromCurrent);
      Exit;
    end
    else if ((ReadCount > (Length(ASignature) * SizeOf(ASignature[1]))) and
      SameText(ASignature, AHeader)) then
    begin
      // 1 byte signature found, reset position properly and exit
      Stream.Seek((Length(ASignature) * SizeOf(ASignature[1])) -
        ReadCount, soFromCurrent);
      Exit;
    end
    else if (Signature = #0) and (S = High(ExpectedSignatures)) then
    begin
      // old stream without signature found, reset position properly and exit
      Signature := '';
      Stream.Seek(-ReadCount, soFromCurrent);
      Exit;
    end;
  end;

  raise EGsStreamSignatureError.CreateRes(@SInvalidStream);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('ReadSignature');{$ENDIF}
end;

procedure WriteSignature(Stream: TStream; const Signature: TGsSignature);
var
  NameBytes: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('WriteSignature');{$ENDIF}

  // Convert signature to UTF8
  NameBytes := TEncoding.UTF8.GetBytes(Signature);

  // Verify signature trailer, must be null terminated
  if (NameBytes[High(NameBytes)] <> 0) then
  begin
    SetLength(NameBytes, Length(NameBytes) + 1);
    NameBytes[High(NameBytes)] := 0;
  end;

  // Write signature
  Stream.WriteBuffer(NameBytes[0], Length(NameBytes));

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('WriteSignature');{$ENDIF}
end;


{ TGsStream }

procedure TGsStream.Clear;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Clear');{$ENDIF}

  FData.Clear;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Clear');{$ENDIF}
end;

procedure TGsStream.ClearProtected;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'ClearProtected');{$ENDIF}

  ProtectStream(Self, Size);
  Clear;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'ClearProtected');{$ENDIF}
end;

constructor TGsStream.Create(const APassword: string; ALevel: TZCompressionLevel);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

  Create;

  FCompEnabled := True;
  FCompLevel := ALevel;
  FCryptEnabled := True;
  FCryptPassword := APassword;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

constructor TGsStream.Create(ALevel: TZCompressionLevel);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

  Create;

  FCompEnabled := True;
  FCompLevel := ALevel;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

constructor TGsStream.Create;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

  inherited;

  FData := TMemoryStream.Create;

  FCompEnabled := False;
  FCompLevel := zcDefault;
  FCryptEnabled := False;
  FCryptCipherClass := DEFAULT_CIPHER_CLASS;
  FCryptCipherMode := DEFAULT_CIPHER_MODE;
  FCryptFormatClass := TFormat_Copy;
  FCryptHashClass := DEFAULT_HASH_CLASS;
  FCryptKDFIndex := DEFAULT_KDF_INDEX;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

constructor TGsStream.Create(const APassword: string);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

  Create;

  FCryptEnabled  := True;
  FCryptPassword := APassword;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

destructor TGsStream.Destroy;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Destroy');{$ENDIF}

  FData.Free;

  inherited;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Destroy');{$ENDIF}
end;

function TGsStream.GetSignature: TGsSignature;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetSignature');{$ENDIF}

  if (FSignature = '') then
    Result := ClassName
  else
    Result := FSignature;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetSignature');{$ENDIF}
end;

function TGsStream.GetSize: Int64;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetSize');{$ENDIF}

  Result := FData.Size;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetSize');{$ENDIF}
end;

procedure TGsStream.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'LoadFromFile');{$ENDIF}

  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);

  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'LoadFromFile');{$ENDIF}
end;

procedure TGsStream.LoadFromStream(Stream: TStream);
var
  FoundSignature: TGsSignature;
  SecureStreamMode: Boolean;
  DataSize:  TGsDataSize;
  HeaderSize: TGsHeaderSize;
  HeaderVersion: TGsHeaderVersion;
  Reserved:  TBytes;
  HeaderPos: Int64;
  DecompStream: TZDecompressionStream;
  TmpStream: TMemoryStream;
  Cipher: TDECCipher;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'LoadFromStream');{$ENDIF}

  // Read signature
  ReadSignature(Stream, [Signature, GS_SECURE_STREAM_HEADER, ClassName,
    TGsStream.ClassName], FoundSignature);

  // Determine mode
  SecureStreamMode := SysUtils.SameText(FoundSignature, GS_SECURE_STREAM_HEADER);

  // Read header
  if SecureStreamMode then
  begin
    /// Read header with the secure stream structure
    // - Int8   IsCompressed
    // - Int8   IsEncrypted
    // - Int64  DataSize
    Stream.ReadBuffer(FIsCompressed, SizeOf(FIsCompressed));
    Stream.ReadBuffer(FIsEncrypted, SizeOf(FIsEncrypted));
    Stream.ReadBuffer(DataSize, SizeOf(DataSize));
  end
  else
  begin
    HeaderPos := Stream.Position;

    /// Read header with the following structure
    // - Int64  DataSize
    // - Int32  HeaderSize
    // - Int32  HeaderVersion
    // - Int8   IsCompressed
    // - Int8   IsEncrypted
    Stream.ReadBuffer(DataSize, SizeOf(DataSize));
    Stream.ReadBuffer(HeaderSize, SizeOf(HeaderSize));
    Stream.ReadBuffer(HeaderVersion, SizeOf(HeaderVersion));
    Stream.ReadBuffer(FIsCompressed, SizeOf(FIsCompressed));
    Stream.ReadBuffer(FIsEncrypted, SizeOf(FIsEncrypted));

    // Read up to header size
    SetLength(Reserved, HeaderSize - Stream.Position - HeaderPos);
    Stream.ReadBuffer(Reserved, Length(Reserved));
  end;

  // Process data
  TmpStream := TMemoryStream.Create;

  try
    Clear;

    // Decrypt data
    if IsEncrypted then
    begin
      if (CryptionPassword = '') then
        raise EGsStreamError.CreateRes(@SInvalidCryptionPassword);

      if SecureStreamMode then
      begin
        Cipher := CryptionCipherClass.Create;

        try
          Cipher.Init(RawByteString(CryptionPassword));
          Cipher.DecodeStream(Stream, TmpStream, DataSize);
          Cipher.Done;
        finally
          Cipher.Free;
        end;
      end
      else
        DecryptStream(Stream, TmpStream, DataSize, CryptionPassword,
          nil, CryptionCipherClass, CryptionCipherMode, CryptionHashClass,
          CryptionKDFIndex);
    end
    else
      TmpStream.CopyFrom(Stream, DataSize);

    // Reset to start
    TmpStream.Position := 0;

    // Decompress data
    if IsCompressed then
    begin
      DecompStream := TDecompressionStream.Create(TmpStream);

      try
        CopyFrom(DecompStream, DecompStream.Size);
      finally
        DecompStream.Free;
      end;
    end
    else
      CopyFrom(TmpStream, TmpStream.Size);
  finally
    TmpStream.Free;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'LoadFromStream');{$ENDIF}
end;

function TGsStream.Read(var Buffer; Count: Integer): Longint;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Read');{$ENDIF}

  Result := FData.Read(Buffer, Count);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Read');{$ENDIF}
end;

procedure TGsStream.SaveToFile(const FileName: string);
var
  Stream: TStream;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SaveToFile');{$ENDIF}

  Stream := TFileStream.Create(FileName, fmCreate);

  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SaveToFile');{$ENDIF}
end;

procedure TGsStream.SaveToStream(Stream: TStream);
var
  TmpStream, PreparedData: TStream;
  CompStream: TZCompressionStream;
  PreparedDataSize: TGsDataSize;
  HeaderPos: Int64;
  Reserved: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SaveToStream');{$ENDIF}

  TmpStream := nil;
  PreparedData := nil;

  try
    // Compress data
    if CompressionEnabled then
    begin
      TmpStream  := TMemoryStream.Create;
      CompStream := TZCompressionStream.Create(TmpStream, CompressionLevel);

      try
        CompStream.CopyFrom(Self, Size);
      finally
        CompStream.Free;
      end;
    end
    else
      TmpStream := Self;

    // Encrypt data
    if CryptionEnabled then
    begin
      PreparedData := TMemoryStream.Create;
      TmpStream.Position := 0;

      EncryptStream(TmpStream, PreparedData, TmpStream.Size, CryptionPassword,
        nil, CryptionCipherClass, CryptionCipherMode, CryptionHashClass,
        CryptionKDFIndex);
    end
    else
      PreparedData := TmpStream;

    // Write signature
    WriteSignature(Stream, Signature);

    PreparedData.Position := 0;
    PreparedDataSize := PreparedData.Size;

    HeaderPos := Stream.Position;

    /// Write header with the following structure
    // - Int64  DataSize
    // - Int32  HeaderSize
    // - Int32  HeaderVersion
    // - Int8   CompressionEnabled
    // - Int8   CryptionEnabled
    Stream.WriteBuffer(PreparedDataSize, SizeOf(PreparedDataSize));
    Stream.WriteBuffer(STREAM_HEADER_SIZE, SizeOf(STREAM_HEADER_SIZE));
    Stream.WriteBuffer(STREAM_HEADER_VERSION, SizeOf(STREAM_HEADER_VERSION));
    Stream.WriteBuffer(FCompEnabled, SizeOf(FCompEnabled));
    Stream.WriteBuffer(FCryptEnabled, SizeOf(FCryptEnabled));

    // Fill up to header size
    SetLength(Reserved, STREAM_HEADER_SIZE - Stream.Position - HeaderPos);
    FillChar(Reserved[0], Length(Reserved), 0);
    Stream.WriteBuffer(Reserved, Length(Reserved));

    // Copy processed data
    Stream.CopyFrom(PreparedData, PreparedDataSize);
  finally
    if Assigned(TmpStream) and (TmpStream <> Self) and
      (TmpStream <> PreparedData) then
      TmpStream.Free;

    if Assigned(PreparedData) and (PreparedData <> Self) then
      PreparedData.Free;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SaveToStream');{$ENDIF}
end;

function TGsStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Seek');{$ENDIF}

  Result := FData.Seek(Offset, Origin);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Seek');{$ENDIF}
end;

function TGsStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Seek');{$ENDIF}

  Result := FData.Seek(Offset, Origin);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Seek');{$ENDIF}
end;

procedure TGsStream.SetSize(const NewSize: Int64);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetSize');{$ENDIF}

  FData.Size := NewSize;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetSize');{$ENDIF}
end;

procedure TGsStream.SetSize(NewSize: Integer);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetSize');{$ENDIF}

  FData.Size := NewSize;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetSize');{$ENDIF}
end;

function TGsStream.Write(const Buffer; Count: Integer): Longint;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Write');{$ENDIF}

  Result := FData.Write(Buffer, Count);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Write');{$ENDIF}
end;

{ TGsThread }

procedure TGsThread.Execute;
begin
  {$IFDEF USE_CODESITE} if (BPC_CodeSite <> nil) then
    BPC_CodeSite.EnterMethod(Self, 'Execute');{$ENDIF}

  SetThreadName(Name);

  ExecuteNew;

  {$IFDEF USE_CODESITE} if (BPC_CodeSite <> nil) then
    BPC_CodeSite.ExitMethod(Self, 'Execute');{$ENDIF}
end;

class function TGsThread.Name: string;
begin
  Result := ClassName;
end;

function TGsThread.WaitForInISAPI: LongWord;
begin
  MainThreadID := GetCurrentThreadID;
  Result := WaitFor;
end;

end.

