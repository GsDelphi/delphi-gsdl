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
  @abstract(Gilbertsoft cryptographic routines)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2019-01-23)
  @cvs($Date:$)

  @name Contains various cryptographic routines.
}

unit GsCrypto;

{$I gsdl.inc}

interface

uses
  Classes,
  DECCipher,
  DECFmt,
  DECHash,
  DECUtil,
  SysUtils;

type
  EGsCrypto = class(Exception);

const
  DEFAULT_CIPHER_MODE = cmCBCx;
  DEFAULT_KDF_INDEX   = 1;

var
  DEFAULT_FORMAT_CLASS: TDECFormatClass = TFormat_Copy;
  DEFAULT_CIPHER_CLASS: TDECCipherClass = TCipher_Rijndael;
  DEFAULT_HASH_CLASS:   TDECHashClass = THash_Whirlpool;

{ Crypto functions }

procedure Encrypt(const Source: TBytes; var Dest: TBytes; const APassword: TBytes;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

function Encrypt(const AText: string; const APassword: string;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX): string; overload;

function Encrypt(const AText: AnsiString; const APassword: AnsiString;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX): AnsiString;
  overload;

function Encrypt(const AText: WideString; const APassword: WideString;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX): WideString;
  overload;

function Encrypt(const AText: RawByteString; const APassword: RawByteString;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX): RawByteString; overload;


procedure Decrypt(const Source: TBytes; var Dest: TBytes; const APassword: TBytes;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

function Decrypt(const AText: string; const APassword: string;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX): string; overload;

function Decrypt(const AText: AnsiString; const APassword: AnsiString;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX): AnsiString;
  overload;

function Decrypt(const AText: WideString; const APassword: WideString;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX): WideString;
  overload;

function Decrypt(const AText: RawByteString; const APassword: RawByteString;
  ATextFormat: TDECFormatClass = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX): RawByteString;
  overload;


procedure EncryptFile(const Source, Dest: string; const APassword: TBytes;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure EncryptFile(const Source, Dest: string; const APassword: string;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure EncryptFile(const Source, Dest: string; const APassword: AnsiString;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure EncryptFile(const Source, Dest: string; const APassword: WideString;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure EncryptFile(const Source, Dest: string; const APassword: RawByteString;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;


procedure DecryptFile(const Source, Dest: string; const APassword: TBytes;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure DecryptFile(const Source, Dest: string; const APassword: string;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure DecryptFile(const Source, Dest: string; const APassword: AnsiString;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure DecryptFile(const Source, Dest: string; const APassword: WideString;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure DecryptFile(const Source, Dest: string; const APassword: RawByteString;
  const Progress: IDECProgress = nil; ACipherClass: TDECCipherClass = nil;
  ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE; AHashClass: TDECHashClass = nil;
  AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;


procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: TBytes; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: string; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: AnsiString; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: WideString; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: RawByteString; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: ShortString; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;


procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: TBytes; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: string; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: AnsiString; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: WideString; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: RawByteString; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: ShortString; const Progress: IDECProgress = nil;
  ACipherClass: TDECCipherClass = nil; ACipherMode: TCipherMode = DEFAULT_CIPHER_MODE;
  AHashClass: TDECHashClass = nil; AKDFIndex: LongWord = DEFAULT_KDF_INDEX); overload;


function HashPassword(const Password: UnicodeString): string; overload;
//function HashPassword(const Password: UnicodeString; const Iterations, MemorySizeKB, Parallelism: Integer): string; overload;
function CheckPassword(const Password: UnicodeString; const ExpectedHashString: string;
  out PasswordRehashNeeded: Boolean): Boolean; overload;

implementation

uses
  {$IFDEF USE_CODESITE}BPLogging,{$ENDIF}
  Argon2,
  JclSysInfo,
  System.Diagnostics;

resourcestring
  SErrorDecodingData = 'Fehler beim Dekodieren der Daten!';
  SErrorDecryptingData = 'Fehler beim Entschlüsseln der Daten!';

const
  DEFAULT_SALT_LEN = 16;

procedure Encrypt(const Source: TBytes; var Dest: TBytes; const APassword: TBytes;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
var
  ASalt: Binary;
  AKey:  Binary;
  AData: Binary;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Encrypt');{$ENDIF}

  if (Length(Source) < 1) then
    Exit;

  { Set default parameters }
  if ATextFormat = nil then
    ATextFormat := DEFAULT_FORMAT_CLASS;

  if ACipherClass = nil then
    ACipherClass := DEFAULT_CIPHER_CLASS;

  if AHashClass = nil then
    AHashClass := DEFAULT_HASH_CLASS;

  { Process data }
  with ValidCipher(ACipherClass).Create, Context do
    try
      { Generate a salt }
      ASalt := RandomBinary(DEFAULT_SALT_LEN);

      { Calculate the key }
      AKey := ValidHash(AHashClass).KDFx(APassword[0], Length(APassword),
        ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);

      { Encode data }
      Mode := ACipherMode;
      Init(AKey);
      SetLength(AData, Length(Source));
      Encode(Source[0], AData[1], Length(AData));

      { Format encoded data }
      AData := ValidFormat(ATextFormat).Encode(ASalt + AData + CalcMAC);

      { Return the encoded data }
      SetLength(Dest, Length(AData));
      Move(AData[1], Dest[0], Length(Dest));
    finally
      Free;
      ProtectBinary(ASalt);
      ProtectBinary(AKey);
      ProtectBinary(AData);
    end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Encrypt');{$ENDIF}
end;

function Encrypt(const AText: string; const APassword: string;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord): string;
var
  AData: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Encrypt');{$ENDIF}

  try
    Encrypt(BytesOf(AText), AData, BytesOf(APassword), ATextFormat,
      ACipherClass, ACipherMode, AHashClass, AKDFIndex);
    Result := StringOf(AData);
  finally
    ProtectBuffer(AData[0], Length(AData));
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Encrypt');{$ENDIF}
end;

function Encrypt(const AText: AnsiString; const APassword: AnsiString;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord): AnsiString;
var
  AData: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Encrypt');{$ENDIF}

  try
    Encrypt(BytesOf(AText), AData, BytesOf(APassword), ATextFormat,
      ACipherClass, ACipherMode, AHashClass, AKDFIndex);
    SetLength(Result, Length(AData));
    Move(AData[0], Result[1], Length(Result));
  finally
    ProtectBuffer(AData[0], Length(AData));
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Encrypt');{$ENDIF}
end;

function Encrypt(const AText: WideString; const APassword: WideString;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord): WideString;
var
  AData: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Encrypt');{$ENDIF}

  try
    Encrypt(BytesOf(AText), AData, BytesOf(APassword), ATextFormat,
      ACipherClass, ACipherMode, AHashClass, AKDFIndex);
    Result := WideStringOf(AData);
  finally
    ProtectBuffer(AData[0], Length(AData));
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Encrypt');{$ENDIF}
end;

function Encrypt(const AText: RawByteString; const APassword: RawByteString;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass;
  AKDFIndex: LongWord): RawByteString;
var
  AData: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Encrypt');{$ENDIF}

  try
    Encrypt(BytesOf(AText), AData, BytesOf(APassword), ATextFormat,
      ACipherClass, ACipherMode, AHashClass, AKDFIndex);
    SetLength(Result, Length(AData));
    Move(AData[0], Result[1], Length(Result));
  finally
    ProtectBuffer(AData[0], Length(AData));
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Encrypt');{$ENDIF}
end;

procedure Decrypt(const Source: TBytes; var Dest: TBytes; const APassword: TBytes;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
var
  ASalt: Binary;
  ALen:  Integer;
  AData: Binary;
  AMAC:  Binary;
  AKey:  Binary;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Decrypt');{$ENDIF}

  if (Length(Source) < 1) then
    Exit;

  { Set default parameters }
  if ATextFormat = nil then
    ATextFormat := DEFAULT_FORMAT_CLASS;

  if ACipherClass = nil then
    ACipherClass := DEFAULT_CIPHER_CLASS;

  if AHashClass = nil then
    AHashClass := DEFAULT_HASH_CLASS;

  { Process data }
  with ValidCipher(ACipherClass).Create, Context do
    try
      { Extract salt, data and check hash }
      ASalt := ValidFormat(ATextFormat).Decode(Source[0], Length(Source));
      ALen  := Length(ASalt) - DEFAULT_SALT_LEN - BufferSize;

      if (ALen < 1) then
        raise EGsCrypto.CreateRes(@SErrorDecodingData);

      AData := System.Copy(ASalt, DEFAULT_SALT_LEN + 1, ALen);
      AMAC  := System.Copy(ASalt, ALen + DEFAULT_SALT_LEN + 1, BufferSize);
      SetLength(ASalt, DEFAULT_SALT_LEN);

      { Calculate the key }
      AKey := ValidHash(AHashClass).KDFx(APassword[0], Length(APassword),
        ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);

      { Decode data }
      Mode := ACipherMode;
      Init(AKey);
      SetLength(Dest, ALen);
      Decode(AData[1], Dest[0], ALen);

      { Verify MAC }
      if (AMAC <> CalcMAC) then
      begin
        ProtectBuffer(Dest[0], ALen);
        SetLength(Dest, 0);
        raise EGsCrypto.CreateRes(@SErrorDecryptingData);
      end;
    finally
      Free;
      ProtectBinary(ASalt);
      ProtectBinary(AData);
      ProtectBinary(AMAC);
      ProtectBinary(AKey);
    end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Decrypt');{$ENDIF}
end;

function Decrypt(const AText: string; const APassword: string;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord): string;
var
  AData: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Decrypt');{$ENDIF}

  try
    Decrypt(BytesOf(AText), AData, BytesOf(APassword), ATextFormat,
      ACipherClass, ACipherMode, AHashClass, AKDFIndex);
    Result := StringOf(AData);
  finally
    ProtectBuffer(AData[0], Length(AData));
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Decrypt');{$ENDIF}
end;

function Decrypt(const AText: AnsiString; const APassword: AnsiString;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord): AnsiString;
var
  AData: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Decrypt');{$ENDIF}

  try
    Decrypt(BytesOf(AText), AData, BytesOf(APassword), ATextFormat,
      ACipherClass, ACipherMode, AHashClass, AKDFIndex);
    SetLength(Result, Length(AData));
    Move(AData[0], Result[1], Length(Result));
  finally
    ProtectBuffer(AData[0], Length(AData));
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Decrypt');{$ENDIF}
end;

function Decrypt(const AText: WideString; const APassword: WideString;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord): WideString;
var
  AData: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Decrypt');{$ENDIF}

  try
    Decrypt(BytesOf(AText), AData, BytesOf(APassword), ATextFormat,
      ACipherClass, ACipherMode, AHashClass, AKDFIndex);
    Result := WideStringOf(AData);
  finally
    ProtectBuffer(AData[0], Length(AData));
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Decrypt');{$ENDIF}
end;

function Decrypt(const AText: RawByteString; const APassword: RawByteString;
  ATextFormat: TDECFormatClass; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass;
  AKDFIndex: LongWord): RawByteString;
var
  AData: TBytes;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('Decrypt');{$ENDIF}

  try
    Decrypt(BytesOf(AText), AData, BytesOf(APassword), ATextFormat,
      ACipherClass, ACipherMode, AHashClass, AKDFIndex);
    SetLength(Result, Length(AData));
    Move(AData[0], Result[1], Length(Result));
  finally
    ProtectBuffer(AData[0], Length(AData));
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('Decrypt');{$ENDIF}
end;

procedure EncryptFile(const Source, Dest: string; const APassword: TBytes;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
var
  Src, Dst: TStream;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptFile');{$ENDIF}

  Src := TFileStream.Create(Source, fmOpenRead or fmShareDenyNone);

  try
    Dst := TFileStream.Create(Dest, fmCreate);

    try
      EncryptStream(Src, Dst, Src.Size, APassword, Progress, ACipherClass,
        ACipherMode, AHashClass, AKDFIndex);
    finally
      Dst.Free;
    end;
  finally
    Src.Free;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptFile');{$ENDIF}
end;

procedure EncryptFile(const Source, Dest: string; const APassword: string;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptFile');{$ENDIF}

  EncryptFile(Source, Dest, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptFile');{$ENDIF}
end;

procedure EncryptFile(const Source, Dest: string; const APassword: AnsiString;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptFile');{$ENDIF}

  EncryptFile(Source, Dest, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptFile');{$ENDIF}
end;

procedure EncryptFile(const Source, Dest: string; const APassword: WideString;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptFile');{$ENDIF}

  EncryptFile(Source, Dest, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptFile');{$ENDIF}
end;

procedure EncryptFile(const Source, Dest: string; const APassword: RawByteString;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptFile');{$ENDIF}

  EncryptFile(Source, Dest, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptFile');{$ENDIF}
end;

procedure DecryptFile(const Source, Dest: string; const APassword: TBytes;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
var
  Src, Dst: TStream;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptFile');{$ENDIF}

  Src := TFileStream.Create(Source, fmOpenRead or fmShareDenyNone);

  try
    Dst := TFileStream.Create(Dest, fmCreate);

    try
      DecryptStream(Src, Dst, Src.Size, APassword, Progress, ACipherClass,
        ACipherMode, AHashClass, AKDFIndex);
    finally
      Dst.Free;
    end;
  finally
    Src.Free;
  end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptFile');{$ENDIF}
end;

procedure DecryptFile(const Source, Dest: string; const APassword: string;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptFile');{$ENDIF}

  DecryptFile(Source, Dest, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptFile');{$ENDIF}
end;

procedure DecryptFile(const Source, Dest: string; const APassword: WideString;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptFile');{$ENDIF}

  DecryptFile(Source, Dest, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptFile');{$ENDIF}
end;

procedure DecryptFile(const Source, Dest: string; const APassword: AnsiString;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptFile');{$ENDIF}

  DecryptFile(Source, Dest, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptFile');{$ENDIF}
end;

procedure DecryptFile(const Source, Dest: string; const APassword: RawByteString;
  const Progress: IDECProgress; ACipherClass: TDECCipherClass;
  ACipherMode: TCipherMode; AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptFile');{$ENDIF}

  DecryptFile(Source, Dest, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptFile');{$ENDIF}
end;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: TBytes; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
var
  ASalt: Binary;
  AKey:  Binary;
  AMAC:  Binary;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptStream');{$ENDIF}

  if (DataSize < 1) then
    Exit;

  { Set default parameters }
  if ACipherClass = nil then
    ACipherClass := DEFAULT_CIPHER_CLASS;

  if AHashClass = nil then
    AHashClass := DEFAULT_HASH_CLASS;

  { Process data }
  with ValidCipher(ACipherClass).Create, Context do
    try
      { Generate a salt }
      ASalt := RandomBinary(DEFAULT_SALT_LEN);

      { Calculate the key }
      AKey := ValidHash(AHashClass).KDFx(APassword[0], Length(APassword),
        ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);

      { Add salt }
      Dest.WriteBuffer(ASalt[1], Length(ASalt));

      { Encode data }
      Mode := ACipherMode;
      Init(AKey);
      EncodeStream(Source, Dest, DataSize, Progress);

      { Add MAC }
      AMAC := CalcMAC;
      Dest.WriteBuffer(AMAC[1], Length(AMAC));
    finally
      Free;
      ProtectBinary(ASalt);
      ProtectBinary(AKey);
      ProtectBinary(AMAC);
    end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptStream');{$ENDIF}
end;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: string; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptStream');{$ENDIF}
end;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: WideString; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptStream');{$ENDIF}
end;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: AnsiString; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptStream');{$ENDIF}
end;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: RawByteString; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptStream');{$ENDIF}
end;

procedure EncryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: ShortString; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('EncryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('EncryptStream');{$ENDIF}
end;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: TBytes; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
var
  SavedPosSource, SavedPosDest: Int64;
  ASalt: Binary;
  AKey:  Binary;
  AMAC:  Binary;
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptStream');{$ENDIF}

  if (DataSize < 1) then
    Exit;

  { Set default parameters }
  if ACipherClass = nil then
    ACipherClass := DEFAULT_CIPHER_CLASS;

  if AHashClass = nil then
    AHashClass := DEFAULT_HASH_CLASS;

  SavedPosSource := Source.Position;
  SavedPosDest := Dest.Position;

  with ValidCipher(ACipherClass).Create, Context do
    try
      { Extract salt }
      SetLength(ASalt, DEFAULT_SALT_LEN);
      Source.ReadBuffer(ASalt[1], Length(ASalt));

      { Calculate the key }
      AKey := ValidHash(AHashClass).KDFx(APassword[0], Length(APassword),
        ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);

      { Decode data }
      Mode := ACipherMode;
      Init(AKey);
      DecodeStream(Source, Dest, DataSize - Length(ASalt) - BufferSize, Progress);

      { Read MAC }
      SetLength(AMAC, BufferSize);
      Source.ReadBuffer(AMAC[1], Length(AMAC));

      { Verify MAC }
      if (AMAC <> CalcMAC) then
      begin
        Source.Position := SavedPosSource;
        Dest.Position := SavedPosDest;
        ProtectStream(Dest, DataSize - Length(ASalt) - BufferSize);
        Dest.Position := SavedPosDest;
        Dest.Size := SavedPosDest;
        raise EGsCrypto.CreateRes(@SErrorDecryptingData);
      end;
    finally
      Free;
      ProtectBinary(ASalt);
      ProtectBinary(AKey);
      ProtectBinary(AMAC);
    end;

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptStream');{$ENDIF}
end;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: string; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptStream');{$ENDIF}
end;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: AnsiString; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptStream');{$ENDIF}
end;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: WideString; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptStream');{$ENDIF}
end;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: RawByteString; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptStream');{$ENDIF}
end;

procedure DecryptStream(const Source, Dest: TStream; const DataSize: Int64;
  const APassword: ShortString; const Progress: IDECProgress;
  ACipherClass: TDECCipherClass; ACipherMode: TCipherMode;
  AHashClass: TDECHashClass; AKDFIndex: LongWord);
begin
  {$IFDEF USE_CODESITE}BPC_CodeSite.EnterMethod('DecryptStream');{$ENDIF}

  EncryptStream(Source, Dest, DataSize, BytesOf(APassword), Progress, ACipherClass,
    ACipherMode, AHashClass, AKDFIndex);

  {$IFDEF USE_CODESITE}BPC_CodeSite.ExitMethod('DecryptStream');{$ENDIF}
end;

var
  HashIterations:  Integer;
  HashMemorySizeKB: Integer;
  HashParallelism: Integer;

procedure InitHashing;
var
  Watch: TStopwatch;
begin
  HashParallelism := ProcessorCount * 2;
  HashMemorySizeKB := 128 * 1024;
  HashIterations := 10000;

  Watch := TStopwatch.StartNew;
  HashPassword('Test');
  Watch.Stop;

  while (Watch.ElapsedMilliseconds < 500) do
  begin
    HashIterations := HashIterations shl 1;
    Watch.Start;
    HashPassword('Test');
    Watch.Stop;
  end;
end;

function HashPassword(const Password: UnicodeString): string;
begin
  Result := TArgon2.HashPassword(Password, HashIterations, HashMemorySizeKB,
    HashParallelism);
end;

function CheckPassword(const Password: UnicodeString; const ExpectedHashString: string;
  out PasswordRehashNeeded: Boolean): Boolean; overload;
begin
  Result := TArgon2.CheckPassword(Password, ExpectedHashString, PasswordRehashNeeded);
end;

initialization
  //InitHashing;
end.

