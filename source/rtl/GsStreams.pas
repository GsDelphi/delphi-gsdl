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
  @abstract(Gilbertsoft Streams)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains system constants and resourcestrings.
}
unit GsStreams;

{$I gsdl.inc}

interface

uses
  SysUtils, Classes, GSZlib, DECCipher, DECUtil, SyncObjs;

type
  { Streaming }
  EGSSecureStream = class(Exception);

  TGSSecureStream = class(TStream)
//  TGSSecureStream = class(TMemoryStream)
  private
    FDataStream: TMemoryStream;
    FCompressionLevel: TCompressionLevel;
    FCipherClass: TDECCipherClass;
    FCipher: TDECCipher;
    FCipherKey: Binary;
    FUseCompression: Boolean;
    FUseEncryption: Boolean;
  protected
    FIsCompressed: Boolean;
    FIsEncrypted: Boolean;

    function GetSize: Int64; override;
    procedure SetSize(NewSize: Longint); override;

    procedure SetCompressionLevel(const Value: TCompressionLevel);
    procedure SetCipherClass(const Value: TDECCipherClass);
    procedure SetCipherKey(const Value: Binary);
    procedure SetUseCompression(const Value: Boolean);
    procedure SetUseEncryption(const Value: Boolean);

    procedure CreateCipher;

    property IsCompressed: Boolean read FIsCompressed;
    property IsEncrypted: Boolean read FIsEncrypted;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(const FileName: String);

    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;

    property CipherClass: TDECCipherClass read FCipherClass write SetCipherClass;
    property CipherKey: Binary read FCipherKey write SetCipherKey;
    property CompressionLevel: TCompressionLevel read FCompressionLevel write SetCompressionLevel;
    property UseCompression: Boolean read FUseCompression write SetUseCompression;
    property UseEncryption: Boolean read FUseEncryption write SetUseEncryption;
  end;

  TGSQueueStream = class(TMemoryStream)
  private
    FCriticalSection: TCriticalSection;
    FPositionRead: Int64;
    FPositionWrite: Int64;
  protected
    function GetSize: Int64; override;
    function Realloc(var NewCapacity: Longint): Pointer; override;
  public
    constructor Create;
    destructor Destroy; override;

    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    procedure SetSize(NewSize: Longint); override;

    procedure Push(const Buffer: AnsiString);
    function Pop(var Buffer: AnsiString; Count: Integer = 0): Integer;
  end;

  {
  TRarStream = class(TStream)
  public
    property Password: String;
    property UseCompression: Boolean;
  end;
  }

implementation

uses
  {$IFDEF USE_CODESITE}BPLogging,{$ENDIF}
  BPClasses, Math;

{ TGSSecureStream }

resourcestring
  SNoCipherKeyDefined = 'Schlüssel für die Verschlüsselung ist nicht definiert!';
  SInvalidStreamHeader = 'Fehlerhafter Stream!';

const
  GS_SECURE_STREAM_HEADER = 'GSSecureStream'#0;

procedure TGSSecureStream.Clear;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Clear');{$ENDIF}

  FDataStream.Clear;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Clear');{$ENDIF}
end;

constructor TGSSecureStream.Create;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

  inherited;

  FDataStream := TMemoryStream.Create;

  FCompressionLevel := clMax;
  FCipherClass := TCipher_Rijndael;
  FUseCompression := True;
  FUseEncryption := True;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

procedure TGSSecureStream.CreateCipher;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'CreateCipher');{$ENDIF}

  if Assigned(FCipher) then
    Exit;

  if (FCipherKey = '') then
    raise EGSSecureStream.Create(SNoCipherKeyDefined);

  FCipher := FCipherClass.Create;
  FCipher.Init(FCipherKey);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'CreateCipher');{$ENDIF}
end;

destructor TGSSecureStream.Destroy;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Destroy');{$ENDIF}

  if Assigned(FCipher) then
    FCipher.Free;

  FDataStream.Free;

  inherited;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Destroy');{$ENDIF}
end;

function TGSSecureStream.GetSize: Int64;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetSize');{$ENDIF}

  Result := FDataStream.Size;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetSize');{$ENDIF}
end;

procedure TGSSecureStream.LoadFromFile(const FileName: String);
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

procedure TGSSecureStream.LoadFromStream(Stream: TStream);
var
  DecompStream: TDecompressionStream;
  TmpStream: TMemoryStream;
  DataSize: Int64;
  {
  Buf: array[0..8191] of Char;
  I: Integer;
  }
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'LoadFromStream');{$ENDIF}

  { read header }
  if not ReadStreamHeader(Stream, GS_SECURE_STREAM_HEADER) then
    raise EGSSecureStream.Create(SInvalidStreamHeader);

  { DONE 1: read bytes are not checked!! }
  Stream.ReadBuffer(FIsCompressed, SizeOf(FIsCompressed));
  Stream.ReadBuffer(FIsEncrypted, SizeOf(FIsEncrypted));
  Stream.ReadBuffer(DataSize, SizeOf(DataSize));

  { read data }
  TmpStream := TMemoryStream.Create;

  try
    { clear data }
    Clear;

    { read data }
    if IsEncrypted then
    begin
      CreateCipher;

      FCipher.DecodeStream(Stream, TmpStream, DataSize);
      FCipher.Done;
    end
    else
      TmpStream.CopyFrom(Stream, DataSize);

    { set to start }
    TmpStream.Position := 0;

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

    Position := 0;
  finally
    TmpStream.Free;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'LoadFromStream');{$ENDIF}
end;

function TGSSecureStream.Read(var Buffer; Count: Integer): Longint;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Read');{$ENDIF}

  Result := FDataStream.Read(Buffer, Count);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Read');{$ENDIF}
end;

procedure TGSSecureStream.SaveToFile(const FileName: String);
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

procedure TGSSecureStream.SaveToStream(Stream: TStream);
var
  CompStream: TCompressionStream;
  TmpStream1,
  TmpStream2: TStream;
  DataSize: Int64;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SaveToStream');{$ENDIF}

  TmpStream1 := nil;
  TmpStream2 := nil;

  try
    if FUseCompression then
    begin
      TmpStream1 := TMemoryStream.Create;
      CompStream := TCompressionStream.Create(FCompressionLevel, TmpStream1);

      try
        Position := 0;
        CompStream.CopyFrom(Self, Size);
      finally
        CompStream.Free;
      end;
    end
    else
      TmpStream1 := Self;

    if FUseEncryption then
    begin
      TmpStream2 := TMemoryStream.Create;
      CreateCipher;

      TmpStream1.Position := 0;
      FCipher.EncodeStream(TmpStream1, TmpStream2, TmpStream1.Size);
      FCipher.Done;
    end
    else
      TmpStream2 := TmpStream1;

    { set to start }
    TmpStream2.Position := 0;

    { write header and data }
    DataSize := TmpStream2.Size;

    Stream.WriteBuffer(GS_SECURE_STREAM_HEADER, Length(GS_SECURE_STREAM_HEADER));
    Stream.WriteBuffer(FUseCompression, SizeOf(FUseCompression));
    Stream.WriteBuffer(FUseEncryption, SizeOf(FUseEncryption));
    Stream.WriteBuffer(DataSize, SizeOf(DataSize));

    Stream.CopyFrom(TmpStream2, DataSize);
  finally
    if Assigned(TmpStream1) and (TmpStream1 <> Self) and (TmpStream1 <> TmpStream2) then
      TmpStream1.Free;

    if Assigned(TmpStream2) and (TmpStream2 <> Self) then
      TmpStream2.Free;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SaveToStream');{$ENDIF}
end;

function TGSSecureStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Seek');{$ENDIF}

  Result := FDataStream.Seek(Offset, Origin);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Seek');{$ENDIF}
end;

procedure TGSSecureStream.SetCipherClass(const Value: TDECCipherClass);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetCipherClass');{$ENDIF}

  if (Value <> FCipherClass) then
  begin
    FreeAndNil(FCipher);
    FCipherClass := Value;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetCipherClass');{$ENDIF}
end;

procedure TGSSecureStream.SetCipherKey(const Value: Binary);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetCipherKey');{$ENDIF}

  if (Value <> FCipherKey) then
  begin
    FreeAndNil(FCipher);
    FCipherKey := Value;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetCipherKey');{$ENDIF}
end;

procedure TGSSecureStream.SetCompressionLevel(
  const Value: TCompressionLevel);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetCompressionLevel');{$ENDIF}

  FCompressionLevel := Value;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetCompressionLevel');{$ENDIF}
end;

procedure TGSSecureStream.SetSize(NewSize: Longint);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetSize');{$ENDIF}

  FDataStream.Size := NewSize;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetSize');{$ENDIF}
end;

procedure TGSSecureStream.SetUseCompression(const Value: Boolean);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetUseCompression');{$ENDIF}

  FUseCompression := Value;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetUseCompression');{$ENDIF}
end;

procedure TGSSecureStream.SetUseEncryption(const Value: Boolean);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetUseEncryption');{$ENDIF}

  FUseEncryption := Value;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetUseEncryption');{$ENDIF}
end;

function TGSSecureStream.Write(const Buffer; Count: Integer): Longint;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Write');{$ENDIF}

  Result := FDataStream.Write(Buffer, Count);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Write');{$ENDIF}
end;

{ TGSQueueStream }

constructor TGSQueueStream.Create;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Create');{$ENDIF}

  inherited Create;

  FCriticalSection := TCriticalSection.Create;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Create');{$ENDIF}
end;

destructor TGSQueueStream.Destroy;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Destroy');{$ENDIF}

  inherited;

  { release critical section at the end, is used for clearing stream }
  FCriticalSection.Free;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Destroy');{$ENDIF}
end;

function TGSQueueStream.GetSize: Int64;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'GetSize');{$ENDIF}

  Result := FPositionWrite - FPositionRead;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'GetSize');{$ENDIF}
end;

function TGSQueueStream.Pop(var Buffer: AnsiString; Count: Integer): Integer;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Pop');{$ENDIF}

  FCriticalSection.Enter;

  try
    if (Count = 0) then
    begin
      if (FPositionWrite - FPositionRead <= MaxInt) then
        Count := FPositionWrite - FPositionRead
      else
        Count := MaxInt;
    end
    else if (Count > Size) then
      Count := Size;

    SetLength(Buffer, Count);

    if (Count > 0) then
    begin
      Result := Read(Buffer[1], Count);
      SetLength(Buffer, Result);
    end
    else
      Result := 0;
  finally
    FCriticalSection.Leave;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Pop');{$ENDIF}
end;

procedure TGSQueueStream.Push(const Buffer: AnsiString);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Push');{$ENDIF}

  FCriticalSection.Enter;

  try
    Write(Buffer[1], Length(Buffer));
  finally
    FCriticalSection.Leave;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Push');{$ENDIF}
end;

function TGSQueueStream.Read(var Buffer; Count: Integer): Longint;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Read');{$ENDIF}

  FCriticalSection.Enter;

  try
    Position := FPositionRead;
    Result := inherited Read(Buffer, Count);
    FPositionRead := Position;

    if (FPositionRead = FPositionWrite) then
    begin
      Clear;
      FPositionRead := 0;
      FPositionWrite := 0;
    end;
  finally
    FCriticalSection.Leave;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Read');{$ENDIF}
end;

function TGSQueueStream.Realloc(var NewCapacity: Integer): Pointer;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Realloc');{$ENDIF}

  FCriticalSection.Enter;

  try
    Result := inherited Realloc(NewCapacity);
  finally
    FCriticalSection.Leave;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Realloc');{$ENDIF}
end;

procedure TGSQueueStream.SetSize(NewSize: Integer);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'SetSize');{$ENDIF}

  FCriticalSection.Enter;

  try
    inherited SetSize(NewSize);
  finally
    FCriticalSection.Leave;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'SetSize');{$ENDIF}
end;

function TGSQueueStream.Write(const Buffer; Count: Integer): Longint;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod(Self, 'Write');{$ENDIF}

  FCriticalSection.Enter;

  try
    Position := FPositionWrite;
    Result := inherited Write(Buffer, Count);
    FPositionWrite := Position;
  finally
    FCriticalSection.Leave;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod(Self, 'Write');{$ENDIF}
end;

end.


