unit GsArgon2;

interface

type
  TArgon2 = class(TObject)
  private
    (*
    FMemorySizeKB:   Integer;
    FDegreeOfParallelism: Integer;
    FIterations:     Integer;
    FSalt:           TBytes;
    FKnownSecret:    TBytes;
    FAssociatedData: TBytes;
    class function StringToUtf8(Source: UnicodeString): TBytes;
    class function PasswordStringPrep(Source: UnicodeString): UnicodeString;
    procedure Burn;
    *)
  protected
    (*
    FHashType: Cardinal; //0=Argon2d, 1=Argon2i, 2=Argon2id

    function GenerateSeedBlock(const Passphrase;
      PassphraseLength, DesiredNumberOfBytes: Integer): TBytes;
    function GenerateInitialBlock(const H0: TBytes;
      ColumnIndex, LaneIndex: Integer): TBytes;
    function GenerateSalt: TBytes;

    //Utility functions
    class procedure BurnBytes(var Data: TBytes);
    class procedure BurnString(var s: UnicodeString);

    class function PasswordToBytes(Source: UnicodeString): TBytes;

    class function Base64Encode(const Data: array of Byte): string;
    class function Base64Decode(const s: string): TBytes;

    class function Tokenize(const s: string; Delimiter: Char): TStringDynArray;
    class function GenRandomBytes(len: Integer; const Data: Pointer): HRESULT;
    class function Hash(const Buffer; BufferLen: Integer; DigestSize: Cardinal): TBytes;
    class function UnicodeStringToUtf8(const Source: UnicodeString): TBytes;
    class function TimingSafeSameString(const Safe, User: string): Boolean;

    //The main Argon2 alorithm
    function DeriveBytes(const Passphrase; PassphraseLength: Integer;
      DesiredNumberOfBytes: Integer): TBytes;
    procedure GetBlockIndexes(i, j: Integer; out iRef, jRef: Integer);
      virtual; //implementation depends if you're using 2i, 2d, or 2id

    procedure GetDefaultParameters(out Iterations, MemoryFactor, Parallelism: Integer);
    function TryParseHashString(HashString: string; out Algorithm: string;
      out Version, Iterations, MemoryFactor, Parallelism: Integer;
      out Salt: TBytes; out Data: TBytes): Boolean;
    function FormatPasswordHash(const Algorithm: string; Version: Integer;
      const Iterations, MemorySizeKB, Parallelism: Integer;
      const Salt, DerivedBytes: array of Byte): string;

    class function CreateHash(AlgorithmName: string; cbHashLen: Integer;
      const Key; const cbKeyLen: Integer): IUnknown;
    *)
  public
    (*
    constructor Create;
    destructor Destroy; override;

    //Get a number of bytes using the default Cost, Parallelization, and Memory factors
    class function GetBytes(const Passphrase; PassphraseLength: Integer;
      DesiredNumberOfBytes: Integer): TBytes; overload;

    //Get a number of bytes, specifying the desired cost, parallelization, and memory factor
    class function GetBytes(const Passphrase; PassphraseLength: Integer;
      const Salt: TBytes; Iterations, MemorySizeKB, Parallelism: Integer;
      DesiredNumberOfBytes: Integer): TBytes; overload;

    //Hashes a password into the standard Argon2 OpenBSD password-file format
    class function HashPassword(const Password: UnicodeString): string; overload;
    class function HashPassword(const Password: UnicodeString;
      const Iterations, MemorySizeKB, Parallelism: Integer): string; overload;
    class function CheckPassword(const Password: UnicodeString;
      const ExpectedHashString: string; out PasswordRehashNeeded: Boolean): Boolean; overload;

    property Iterations: Integer read FIterations write FIterations;
    //must be at least 1 iteration
    property MemorySizeKB: Integer read FMemorySizeKB write FMemorySizeKB;
    //must be at least 4 KB
    property DegreeOfParallelism: Integer read FDegreeOfParallelism
      write FDegreeOfParallelism; //must be at least 1 thread
    property Salt: TBytes read FSalt write FSalt;
    property KnownSecret: TBytes read FKnownSecret write FKnownSecret;
    property AssociatedData: TBytes read FAssociatedData write FAssociatedData;

    class function CreateObject(ObjectName: string): IUnknown;
    *)
  end;

implementation

{.$L argon2\blake2b.obj}
{.$L argon2\thread.obj}
{.$L argon2\core.obj}
{.$L argon2\opt.obj}
{.$L argon2\encoding.obj}
{.$L argon2\argon2.obj}

type
  TArgon2Type = (
    Argon2_d = 0,
    Argon2_i = 1,
    Argon2_id = 2
    );
(*
function argon2_hash(t_cost, m_cost, parallelism: UInt32; pwd: Pointer;
  pwdlen: NativeUInt;
  salt: Pointer;
  saltlen: NativeUInt; hash: Pointer;
  hashlen: NativeUInt; encoded: PAnsiChar;
  encodedlen: NativeUInt; atype: TArgon2Type;
  version: UInt32): Integer; external;
  *)


end.
