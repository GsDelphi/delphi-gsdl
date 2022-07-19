unit GsADODB;

interface

uses
  BPADO,
  Data.DB,
  Data.Win.ADODB,
  GsSysUtils,
  System.Classes,
  System.SysUtils,
  System.TypInfo;

const
  SQL_MAX          = High(Integer);
  SQL_DEFAULT_NOW  = '(getdate())';
  SQL_DEFAULT_ZERO = 'CONVERT(DATETIME, ''1899-12-30 00:00:00'', 102)';
  SQL_SIZE_INTEGER = 4;
  SQL_SIZE_INT64   = 8;

  DEFAULT_REQUIRED = False;

type
  EGsAdoDbError = class(EGilbertsoft);

  EGsAdoDbSqlError = class(EGsAdoDbError)
  private
    FSQL: string;
  public
    constructor Create(ResStringRec: PResStringRec; const Args: array of const; const SQL: string); overload;
    property SQL: string read FSQL write FSQL;
  end;



(*
const
  cDummyColumn = '_tmp_';

type
  TSQLColumn = record
    Name: String;
    Definition: String;
    AllowZeroLength: Boolean;
  end;

  TSQLColumns = array of TSQLColumn;
*)



  TGsSqlTableName = type String;

  TGsSqlFieldName        = type String;
  TGsSqlFieldPrecision   = type Integer;
  TGsSqlFieldSize        = type Integer;
  TGsSqlFieldCollation   = type String;
  TGsSqlFieldDefault     = type String;
  TGsSqlFieldLookupTable = type String;
  TGsSqlFieldLookupField = type String;
  TGsSqlFieldCheck       = type String;
  TGsSqlFieldDefinition  = type String;

  TGsSqlFieldAttribute  = (
    sfaIdentity,
    sfaRequired,
    sfaPrimaryKey,
    sfaUnique
    );
  TGsSqlFieldAttributes = set of TGsSqlFieldAttribute;

  TGsSqlFieldType = (
    // Special types
    sftUnknown,
    sftAutoInc,
    // Character strings
    sftChar,
    sftVarChar,
    sftText { deprecated, use varchar(max) instead },
    // Unicode character strings
    sftUnicodeChar,
    sftUnicodeVarChar,
    sftUnicodeText { deprecated, use nvarchar(max) instead },
    // Binary strings
    sftBinary,
    sftVarBinary,
    sftImage { deprecated, use varbinary(max) instead },
    // Exact numerics
    sftBit,
    sftInteger,
    sftBigInt,
    sftSmallInt,
    sftTinyInt,
    sftMoney,
    sftSmallMoney,
    sftDecimal,
    sftNumeric,
    // Approximate numerics
    sftFloat,
    sftReal,
    // Date and time
    //sftDate,
    sftDateTime { deprecated, use datetime2 instead },
    //sftDateTime2,
    //sftDateTimeOffset,
    sftSmallDateTime,
    //sftTime,
    //sftTimeStamp { deprecated },
    // Other data types
    sftUniqueIdentifier,
    sftSqlVariant,
    sftXml
    );

  (*
  TFieldType = (ftUnknown, ftString, ftSmallint, ftInteger, ftWord, // 0..4
    ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime, // 5..11
    ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo, // 12..18
    ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString, // 19..24
    ftLargeint, ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob, // 25..31
    ftVariant, ftInterface, ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd, // 32..37
    ftFixedWideChar, ftWideMemo, ftOraTimeStamp, ftOraInterval, // 38..41
    ftLongWord, ftShortint, ftByte, ftExtended, ftConnection, ftParams, ftStream, //42..48
    ftTimeStampOffset, ftObject, ftSingle); //49..51
  *)

  PGsSqlFieldDef = ^TGsSqlFieldDef;

  TGsSqlFieldDef = record
    Name:            TGsSqlFieldName;
    Attributes:      TGsSqlFieldAttributes;
    DataType:        TGsSqlFieldType;
    Precision:       TGsSqlFieldPrecision;
    Size:            TGsSqlFieldSize;
    Collation:       TGsSqlFieldCollation;
    Default:         TGsSqlFieldDefault;
    LookupTable:     TGsSqlFieldLookupTable;
    LookupField:     TGsSqlFieldLookupField;
    Check:           TGsSqlFieldCheck;
    Definition:      TGsSqlFieldDefinition;
    // Forcing flags
    Change:          Boolean;
    Drop:            Boolean;
    // Internal
    Exists:          Boolean;
    // Compatibility
    AllowZeroLength: Boolean;
  end;

  TGsSqlFieldDefs = array of TGsSqlFieldDef;

  TGsSqlNewFieldDef = record
    FieldDef: PGsSqlFieldDef;
    constructor Create(var AFieldDef: TGsSqlFieldDef);
    function Init(ADataType: TGsSqlFieldType; ASize: Integer = 0; Required: Boolean = DEFAULT_REQUIRED;
        APrecision: Integer = 0; const ADefault: TGsSqlFieldDefault = '';
        const AFieldDefinition: TGsSqlFieldDefinition = ''): PGsSqlFieldDef;

    /// Easy typed init
    // String types
    function AsString(ASize: Integer; Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;
    function AsText(Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;
    function AsWideString(ASize: Integer; Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;
    function AsWideText(Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;

    function AsBinary(ASize: Integer; Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;
    function AsImage(Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;

    // Integer
    function AsBoolean(Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;
    function AsInteger(Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;
    function AsAutoInc(ASize: Integer = 4): PGsSqlFieldDef;

    function AsCurrency(Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;

    function AsDateTime(Required: Boolean = DEFAULT_REQUIRED; ADefault: string = ''): PGsSqlFieldDef;
    function AsDateTimeDefaultGetDate(Required: Boolean = DEFAULT_REQUIRED): PGsSqlFieldDef;
    function AsDateTimeDefaultZero(Required: Boolean = DEFAULT_REQUIRED): PGsSqlFieldDef;

    function AsDecimal(APrecision: Integer = 18; AScale: Integer = 0; Required: Boolean = DEFAULT_REQUIRED;
        ADefault: string = ''): PGsSqlFieldDef;
    function AsNumeric(APrecision: Integer = 18; AScale: Integer = 0; Required: Boolean = DEFAULT_REQUIRED;
        ADefault: string = ''): PGsSqlFieldDef;

    // Custom type
    function AsCustom(const AFieldDefinition: TGsSqlFieldDefinition; ADataType: TGsSqlFieldType = sftUnknown;
        ASize: Integer = 0): PGsSqlFieldDef;

    function AsDeleteable: PGsSqlFieldDef;
  end;



  TGsSqlIndexName       = type String;
  TGsSqlIndexDefinition = type String;

  TGsSqlIndexType          = (
    sitIndex,
    sitUniqueIndex
    );
  TGsSqlIndexSortDirection = (
    sisdAscending,
    sisdDescending
    );

  TGsSqlIndexColumn = record
    Name:          TGsSqlFieldName;
    SortDirection: TGsSqlIndexSortDirection;
  end;

  TGsSqlIndexColumns = array of TGsSqlIndexColumn;


  PGsSqlIndexDef = ^TGsSqlIndexDef;

  TGsSqlIndexDef = record
    Name:         TGsSqlIndexName;
    IndexType:    TGsSqlIndexType;
    IndexColumns: TGsSqlIndexColumns;
    Definition:   TGsSqlIndexDefinition;
    // Forcing flags
    Change:       Boolean;
    Drop:         Boolean;
    // Internal
    Exists:       Boolean;
  end;

  TGsSqlIndexDefs = array of TGsSqlIndexDef;


  //PGsSqlNewIndexDef = ^TGsSqlNewIndexDef;

  TGsSqlNewIndexDef = record
    IndexDef: PGsSqlIndexDef;
    constructor Create(var AIndexDef: TGsSqlIndexDef);
    function Init(AIndexType: TGsSqlIndexType; const AIndexDefinition: TGsSqlIndexDefinition = ''): PGsSqlIndexDef;

    /// Easy typed init
    function AddColumn(AName: TGsSqlFieldName;
        ASortDirection: TGsSqlIndexSortDirection = sisdAscending): TGsSqlNewIndexDef;
    function AsIndex: PGsSqlIndexDef;
    function AsUniqueIndex: PGsSqlIndexDef;
    function AsCustom(const AIndexDefinition: TGsSqlIndexDefinition;
        AIndexType: TGsSqlIndexType = sitIndex): PGsSqlIndexDef;

    function AsDeleteable: PGsSqlIndexDef;
  end;


  TGsSqlConstraintName       = type String;
  TGsSqlConstraintDefinition = type String;

  TGsSqlConstraintType = (
    sctDefault,
    sctPrimaryKey,
    sctUnique,
    sctForeignKey,
    sctCheck
    );

  PGsSqlConstraintDef = ^TGsSqlConstraintDef;

  TGsSqlConstraintDef = record
    Name:           TGsSqlConstraintName;
    ConstraintType: TGsSqlConstraintType;
    Columns:        TGsSqlIndexColumns;
    Default:        TGsSqlFieldDefault;
    LookupTable:    TGsSqlFieldLookupTable;
    LookupField:    TGsSqlFieldLookupField;
    Check:          TGsSqlFieldCheck;
    Definition:     TGsSqlConstraintDefinition;
    // Forcing flags
    Change:         Boolean;
    Drop:           Boolean;
    // Internal
    Exists:         Boolean;
  end;

  TGsSqlConstraintDefs = array of TGsSqlConstraintDef;

  TGsSqlNewConstraintDef = record
    ConstraintDef: PGsSqlConstraintDef;
    constructor Create(var AConstraintDef: TGsSqlConstraintDef);
    function Init(AConstraintType: TGsSqlConstraintType; const ADefault: TGsSqlFieldDefault = '';
        const ALogicalExpression: TGsSqlFieldCheck = ''; const ALookupTable: TGsSqlFieldLookupTable = '';
        const ALookupField: TGsSqlFieldLookupField = '';
        const AConstraintDefinition: TGsSqlConstraintDefinition = ''): PGsSqlConstraintDef; overload;

    /// Easy typed init
    function AddColumn(AName: TGsSqlFieldName;
        ASortDirection: TGsSqlIndexSortDirection = sisdAscending): TGsSqlNewConstraintDef;
    function AsDefault(const ADefault: TGsSqlFieldDefault): PGsSqlConstraintDef;
    function AsPrimaryKey: PGsSqlConstraintDef;
    function AsUnique: PGsSqlConstraintDef;
    function AsForeignKey(const ALookupTable: TGsSqlFieldLookupTable;
        const ALookupField: TGsSqlFieldLookupField): PGsSqlConstraintDef;
    function AsCheck(const ALogicalExpression: TGsSqlFieldCheck): PGsSqlConstraintDef;
    function AsCustom(const AConstraintDefinition: TGsSqlConstraintDefinition;
        AConstraintType: TGsSqlConstraintType): PGsSqlConstraintDef;
  end;



  TGsSqlColumnDefinitionType     = (scdtCreateTable, scdtAlterColumn, scdtAddColumn, scdtDropColumn);
  TGsSqlIndexDefinitionType      = (sidtCreateIndex, sidtDropIndex);
  TGsSqlConstraintDefinitionType = (scdtAddConstraint, scdtDropConstraint);

  TGsSqlNotifyEvent = (
    neBeforeProcessTable,
    neAfterProcessTable,
    neBeforeCreateTable,
    neAfterCreateTable,
    neBeforeUpdateTable,
    neAfterUpdateTable,
    neBeforeDropTable,
    neAfterDropTable
    );

  TGsSqlTableState = (
    tsCreated,
    tsUpdated,
    tsDropped,
    tsExists,
    tsEmpty
    );

  TGsSqlTableStates = set of TGsSqlTableState;

  TGsSqlNotifyProc = reference to procedure (Event: TGsSqlNotifyEvent;
    {Connection: TADOConnection;} const TableName: TGsSqlTableName; var FieldDefs: TGsSqlFieldDefs;
    var ConstraintDefs: TGsSqlConstraintDefs; var IndexDefs: TGsSqlIndexDefs; var TableState: TGsSqlTableStates);

  TGsSql = class
  private
  protected
    class function GetQuery(const Caller: string; AdoObject: TComponent; out Release: Boolean): TADOQuery;

    class function GetSqlColumnDefinition(ColumnDefinitionType: TGsSqlColumnDefinitionType;
      const TableName: TGsSqlTableName; FieldDef: TGsSqlFieldDef; Force: Boolean): string;
    class function GetSqlColumnDefinitions(ColumnDefinitionType: TGsSqlColumnDefinitionType;
      const TableName: TGsSqlTableName; FieldDefs: TGsSqlFieldDefs; Force: Boolean): string;
    class function GetSqlIndexDefinition(IndexDefinitionType: TGsSqlIndexDefinitionType;
      const TableName: TGsSqlTableName; IndexDef: TGsSqlIndexDef; Force: Boolean): string;
    class function GetSqlIndexColumnDefinition(IndexDefinitionType: TGsSqlIndexDefinitionType;
      const TableName: TGsSqlTableName; IndexDef: TGsSqlIndexDef; Force: Boolean): string;
    class function GetSqlConstraintColumnDefinition(ConstraintDefinitionType: TGsSqlConstraintDefinitionType;
      const TableName: TGsSqlTableName; ConstraintDef: TGsSqlConstraintDef; Force: Boolean): string;
    class function GetSqlConstraintColumnDefinitions(ConstraintDefinitionType: TGsSqlConstraintDefinitionType;
      const TableName: TGsSqlTableName; ConstraintDefs: TGsSqlConstraintDefs; Force: Boolean): string;

    class procedure SqlCreateTable(AdoObject: TComponent; const ATableName: TGsSqlTableName;
      var AFieldDefs: TGsSqlFieldDefs);
    class procedure SqlAlterTableAlterColumn(AdoObject: TComponent; AField: TField;
      const ATableName: TGsSqlTableName; var AFieldDef: TGsSqlFieldDef; Force: Boolean);
    class procedure SqlAlterTableAddColumns(AdoObject: TComponent; const ATableName: TGsSqlTableName;
      var AFieldDefs: TGsSqlFieldDefs; Force: Boolean);
    class procedure SqlAlterTableAddConstraints(AdoObject: TComponent; const ATableName: TGsSqlTableName;
      var AConstraintDefs: TGsSqlConstraintDefs; Force: Boolean);
    class procedure SqlAlterTableDropColumns(AdoObject: TComponent; const ATableName: TGsSqlTableName;
      var AFieldDefs: TGsSqlFieldDefs; Force: Boolean);
    class procedure SqlAlterTableDropConstraints(AdoObject: TComponent; const ATableName: TGsSqlTableName;
      var AConstraintDefs: TGsSqlConstraintDefs; Force: Boolean);
    class procedure SqlDropTable(AdoObject: TComponent; const ATableName: TGsSqlTableName);

    class procedure SqlCreateIndex(AdoObject: TComponent; const ATableName: TGsSqlTableName;
      var AIndexDef: TGsSqlIndexDef);
    class procedure SqlDropIndex(AdoObject: TComponent; const ATableName: TGsSqlTableName;
      var AIndexDef: TGsSqlIndexDef);

    class function ConcatDefinitions(const Definition, NewDefinition: string): string;

    class procedure DoEvent(const EventProc: TGsSqlNotifyProc; Event: TGsSqlNotifyEvent; {Connection: TADOConnection;}
      const TableName: TGsSqlTableName; var FieldDefs: TGsSqlFieldDefs; var ConstraintDefs: TGsSqlConstraintDefs;
      var IndexDefs: TGsSqlIndexDefs; var TableState: TGsSqlTableStates);

    class procedure CreateTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var FieldDefs: TGsSqlFieldDefs; const EventProc: TGsSqlNotifyProc; var TableState: TGsSqlTableStates); overload;
    class procedure UpdateTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var FieldDefs: TGsSqlFieldDefs; var ConstraintDefs: TGsSqlConstraintDefs;
      var IndexDefs: TGsSqlIndexDefs; const EventProc: TGsSqlNotifyProc; var TableState: TGsSqlTableStates); overload;
  public
    class function AddField(var FieldDefs: TGsSqlFieldDefs; const AName: TGsSqlFieldName): TGsSqlNewFieldDef; overload;
    class function AddConstraint(var ConstraintDefs: TGsSqlConstraintDefs;
      const AName: TGsSqlConstraintName): TGsSqlNewConstraintDef;
    class function AddIndex(var IndexDefs: TGsSqlIndexDefs; const AName: TGsSqlIndexName): TGsSqlNewIndexDef;

    class function AddField(var FieldDefs: TGsSqlFieldDefs; const AName: TGsSqlFieldName;
      ADataType: TFieldType; ASize: Integer = 0; Required: Boolean = False; APrecision: Integer = 0): PGsSqlFieldDef;
      overload; deprecated;

    class procedure ProcessTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
      FieldDefs: TGsSqlFieldDefs; ConstraintDefs: TGsSqlConstraintDefs; IndexDefs: TGsSqlIndexDefs;
      const EventProc: TGsSqlNotifyProc);

    class function TableExists(Connection: TADOConnection; const TableName: TGsSqlTableName): Boolean;
    class function TableRecordCount(Connection: TADOConnection; const TableName: TGsSqlTableName): Integer;
    class function TableState(Connection: TADOConnection; const TableName: TGsSqlTableName): TGsSqlTableStates;

    class function GetSqlLineBreak: string;
    class function GetSqlObjectName(const ATableOrViewName: string; const ASchemaName: string = '';
      const ADatabaseName: string = ''): string;
    class function GetSqlConstraintName(AType: TGsSqlConstraintType; const ATableOrViewName: string;
      const AFieldName: string = ''): string;
    class function GetSqlIndexName(AType: TGsSqlIndexType; const ATableOrViewName: string;
      const AFieldName: string = ''): string;

    class procedure CreateTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var FieldDefs: TGsSqlFieldDefs; const EventProc: TGsSqlNotifyProc); overload;
    class procedure UpdateTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var FieldDefs: TGsSqlFieldDefs; var ConstraintDefs: TGsSqlConstraintDefs;
      var IndexDefs: TGsSqlIndexDefs; const EventProc: TGsSqlNotifyProc); overload;
    class procedure DropTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
      const EventProc: TGsSqlNotifyProc);

    class procedure AlterColumn(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var FieldDef: TGsSqlFieldDef; Force: Boolean = False);
    class procedure AlterColumns(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var FieldDefs: TGsSqlFieldDefs; ForceAll: Boolean = False);
    class procedure AddColumns(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var FieldDefs: TGsSqlFieldDefs; ForceAll: Boolean = False);
    class procedure DropColumns(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var FieldDefs: TGsSqlFieldDefs; ForceAll: Boolean = False);

    class procedure AddIndexes(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var IndexDefs: TGsSqlIndexDefs; ForceAll: Boolean = False);
    class procedure DropIndex(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var IndexDef: TGsSqlIndexDef; Force: Boolean = False);
    class procedure DropIndexes(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var IndexDefs: TGsSqlIndexDefs; ForceAll: Boolean = False);
    class procedure DropAllIndexes(Connection: TADOConnection; const TableName: TGsSqlTableName);

    class procedure AddConstraints(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var ConstraintDefs: TGsSqlConstraintDefs; Force: Boolean = False);
    class procedure DropConstraints(Connection: TADOConnection; const TableName: TGsSqlTableName;
      var ConstraintDefs: TGsSqlConstraintDefs; Force: Boolean = False);

    class procedure ConvertSQLColumns(var SqlFieldDefs: TGsSqlFieldDefs; SQLColumns: TSQLColumns); overload;
    class procedure ConvertSQLColumns(var SqlIndexDefs: TGsSqlIndexDefs; SQLColumns: TSQLColumns); overload;
  end;

implementation

type
  TDataTypeSizeInfo = (siNone, siSingle, siDouble);

  TDataTypeInfo = record
    DataType: string;
    Size:     TDataTypeSizeInfo;
  end;

const
  SqlDataTypes: array[TGsSqlFieldType] of TDataTypeInfo = (
    (DataType: ''),                          // sftUnknown
    (DataType: ''),                          // sftAutoInc
    (DataType: 'char'; Size: siSingle),      // sftChar,
    (DataType: 'varchar'; Size: siSingle),   // sftVarChar,
    (DataType: 'text'),                      // sftText,
    (DataType: 'nchar'; Size: siSingle),     // sftUnicodeChar,
    (DataType: 'nvarchar'; Size: siSingle),  // sftUnicodeVarChar,
    (DataType: 'ntext'),                     // sftUnicodeText,
    (DataType: 'binary'; Size: siSingle),    // sftBinary,
    (DataType: 'varbinary'; Size: siSingle), // sftVarBinary,
    (DataType: 'image'),                     // sftImage,
    (DataType: 'bit'),                       // sftBit,
    (DataType: 'int'),                       // sftInteger,
    (DataType: 'bigint'),                    // sftBigInt,
    (DataType: 'smallint'),                  // sftSmallInt,
    (DataType: 'tinyint'),                   // sftTinyInt,
    (DataType: 'money'),                     // sftMoney,
    (DataType: 'smallmoney'),                // sftSmallMoney,
    (DataType: 'decimal'; Size: siDouble),   // sftDecimal,
    (DataType: 'numeric'; Size: siDouble),   // sftNumeric,
    (DataType: 'float'; Size: siSingle),     // sftFloat,
    (DataType: 'real'),                      // sftReal,
    //(DataType: 'date'),                      // sftDate,
    (DataType: 'datetime'),                  // sftDateTime,
    //(DataType: 'datetime2'),                 // sftDateTime2,
    //(DataType: 'datetimeoffset'),            // sftDateTimeOffset,
    (DataType: 'smalldatetime'),             // sftSmallDateTime,
    //(DataType: 'time'),                      // sftTime,
    (DataType: 'uniqueidentifier'),          // sftUniqueIdentifier,
    (DataType: 'sql_variant'),               // sftSqlVariant,
    (DataType: 'xml')                        // sftXml
    );

  FieldTypeToSqlFieldType: array[TFieldType] of TGsSqlFieldType = (
    sftUnknown,          // ftUnknown
    sftVarChar,          // ftString
    sftSmallint,         // ftSmallint
    sftInteger,          // ftInteger
    sftInteger,          // ftWord
    sftBit,              // ftBoolean
    sftFloat,            // ftFloat
    sftMoney,            // ftCurrency
    sftDecimal,          // ftBCD
    sftDateTime,         // ftDate
    sftDateTime,         // ftTime
    sftDateTime,         // ftDateTime
    sftBinary,           // ftBytes
    sftVarBinary,        // ftVarBytes
    sftAutoInc,          // ftAutoInc
    sftVarBinary,        // ftBlob
    sftText,             // ftMemo
    sftImage,            // ftGraphic
    sftUnknown,          // ftFmtMemo
    sftUnknown,          // ftParadoxOle
    sftUnknown,          // ftDBaseOle
    sftUnknown,          // ftTypedBinary
    sftUnknown,          // ftCursor
    sftChar,             // ftFixedChar
    sftUnicodeVarChar,   // ftWideString
    sftBigInt,           // ftLargeInt
    sftUnknown,          // ftADT
    sftUnknown,          // ftArray
    sftUnknown,          // ftReference
    sftUnknown,          // ftDataSet
    sftUnknown,          // ftOraBlob
    sftUnknown,          // ftOraClob
    sftSqlVariant,       // ftVariant
    sftUnknown,          // ftInterface
    sftUnknown,          // ftIDispatch
    sftUniqueIdentifier, // ftGuid
    sftUnknown,          // ftTimeStamp
    sftUnknown,          // ftFMTBcd
    sftUnicodeChar,      // ftFixedWideChar
    sftUnicodeText,      // ftWideMemo
    sftUnknown,          // ftOraTimeStamp
    sftUnknown,          // ftOraInterval
    sftBigInt,           // ftLongWord
    sftUnknown,          // ftShortInt
    sftTinyInt,          // ftByte
    sftDecimal,          // ftExtended
    sftUnknown,          // ftConnection
    sftUnknown,          // ftParams
    sftUnknown,          // ftStream
    sftUnknown,          // ftTimeStampOffset
    sftUnknown,          // ftObject
    sftReal              // ftSingle
    );

  SqlConstraintPrefixes: array[TGsSqlConstraintType] of string = (
    'DF', // sctDefault
    'PK', // sctPrimaryKey
    'UK', // sctUnique
    'FK', // sctForeignKey
    'CK'  // sctCheck
    );

  SqlIndexPrefixes: array[TGsSqlIndexType] of string = (
    'IX', // sitIndex
    'UX'  // sitUniqueIndex
    );

{ EGsAdoDbSqlError }

constructor EGsAdoDbSqlError.Create(ResStringRec: PResStringRec; const Args: array of const; const SQL: string);
begin
  CreateResFmt(ResStringRec, Args);
  FSQL := SQL;
end;

{ TGsSqlNewFieldDef }

function TGsSqlNewFieldDef.AsAutoInc(ASize: Integer): PGsSqlFieldDef;
begin
  Result            := Init(sftAutoInc, ASize);
  Result.Attributes := [sfaIdentity, sfaPrimaryKey];
end;

function TGsSqlNewFieldDef.AsBinary(ASize: Integer; Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := Init(sftVarBinary, ASize, Required, 0, ADefault);
end;

function TGsSqlNewFieldDef.AsBoolean(Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := Init(sftBit, 0, Required, 0, ADefault);
end;

function TGsSqlNewFieldDef.AsCurrency(Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := Init(sftMoney, 0, Required, 0, ADefault);
end;

function TGsSqlNewFieldDef.AsCustom(const AFieldDefinition: TGsSqlFieldDefinition;
  ADataType: TGsSqlFieldType; ASize: Integer): PGsSqlFieldDef;
begin
  Result := Init(ADataType, ASize, False, 0, '', AFieldDefinition);
end;

function TGsSqlNewFieldDef.AsDateTime(Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := Init(sftDateTime, 0, Required, 0, ADefault);
end;

function TGsSqlNewFieldDef.AsDateTimeDefaultGetDate(Required: Boolean): PGsSqlFieldDef;
begin
  Result := AsDateTime(Required, SQL_DEFAULT_NOW);
end;

function TGsSqlNewFieldDef.AsDateTimeDefaultZero(Required: Boolean): PGsSqlFieldDef;
begin
  Result := AsDateTime(Required, SQL_DEFAULT_ZERO);
end;

function TGsSqlNewFieldDef.AsDecimal(APrecision, AScale: Integer; Required: Boolean;
  ADefault: string): PGsSqlFieldDef;
begin
  Result := Init(sftDecimal, AScale, Required, APrecision, ADefault);
end;

function TGsSqlNewFieldDef.AsDeleteable: PGsSqlFieldDef;
begin
  Result      := Init(sftUnknown);
  Result.Drop := True;
end;

function TGsSqlNewFieldDef.AsImage(Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := AsBinary(SQL_MAX, Required, ADefault);
end;

function TGsSqlNewFieldDef.AsInteger(Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := Init(sftInteger, 0, Required, 0, ADefault);
end;

function TGsSqlNewFieldDef.AsNumeric(APrecision, AScale: Integer; Required: Boolean;
  ADefault: string): PGsSqlFieldDef;
begin
  Result := Init(sftNumeric, AScale, Required, APrecision, ADefault);
end;

function TGsSqlNewFieldDef.AsString(ASize: Integer; Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := Init(sftVarChar, ASize, Required, 0, ADefault);
end;

function TGsSqlNewFieldDef.AsText(Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := AsString(SQL_MAX, Required, ADefault);
end;

function TGsSqlNewFieldDef.AsWideString(ASize: Integer; Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := Init(sftUnicodeVarChar, ASize, Required, 0, ADefault);
end;

function TGsSqlNewFieldDef.AsWideText(Required: Boolean; ADefault: string): PGsSqlFieldDef;
begin
  Result := AsWideString(SQL_MAX, Required, ADefault);
end;

constructor TGsSqlNewFieldDef.Create(var AFieldDef: TGsSqlFieldDef);
begin
  FieldDef := @AFieldDef;
end;

function TGsSqlNewFieldDef.Init(ADataType: TGsSqlFieldType; ASize: Integer; Required: Boolean;
  APrecision: Integer; const ADefault: TGsSqlFieldDefault;
  const AFieldDefinition: TGsSqlFieldDefinition): PGsSqlFieldDef;
const
  TypeSizes: packed array[TGsSqlFieldType] of Byte = (
    0,  // sftUnknown
    4,  // sftAutoInc
    20, // sftChar
    20, // sftVarChar
    0,  // sftText
    20, // sftUnicodeChar
    20, // sftUnicodeVarChar
    0,  // sftUnicodeText
    16, // sftBinary
    16, // sftVarBinary
    0,  // sftImage
    2,  // sftBit
    4,  // sftInteger
    8,  // sftBigInt
    2,  // sftSmallInt
    1,  // sftTinyInt
    0,  // sftMoney
    0,  // sftSmallMoney
    0,  // sftDecimal
    0,  // sftNumeric
    8,  // sftFloat
    4,  // sftReal
        //0,  // sftDate
    8,  // sftDateTime
        //0,  // sftDateTime2
        //0,  // sftDateTimeOffset
    8,  // sftSmallDateTime
        //0,  // sftTime
        //0, // sftTimeStamp
    39, // sftUniqueIdentifier
    0,  // sftSqlVariant
    0   // sftXml
    );
begin
  Result := FieldDef;

  with Result^ do
  begin
    if Required then
      Attributes := [sfaRequired]
    else
      Attributes := [];

    DataType  := ADataType;
    Precision := APrecision;

    if (ASize > 0) then
      Size := ASize
    else
      Size := TypeSizes[ADataType];

    Default    := ADefault;
    Definition := AFieldDefinition;

    Change          := False;
    Drop            := False;
    Exists          := False;
    AllowZeroLength := False;
  end;
end;

{ TGsSqlNewIndexDef }

function TGsSqlNewIndexDef.AddColumn(AName: TGsSqlFieldName;
  ASortDirection: TGsSqlIndexSortDirection): TGsSqlNewIndexDef;
var
  L: Integer;
begin
  Result := Self;

  with Result do
  begin
    L := Length(IndexDef^.IndexColumns);
    SetLength(IndexDef^.IndexColumns, L + 1);
    IndexDef^.IndexColumns[L].Name          := AName;
    IndexDef^.IndexColumns[L].SortDirection := ASortDirection;
  end;
end;

function TGsSqlNewIndexDef.AsCustom(const AIndexDefinition: TGsSqlIndexDefinition;
  AIndexType: TGsSqlIndexType): PGsSqlIndexDef;
begin
  Result := Init(AIndexType, AIndexDefinition);
end;

function TGsSqlNewIndexDef.AsDeleteable: PGsSqlIndexDef;
begin
  Result      := Init(sitIndex);
  Result.Drop := True;
end;

function TGsSqlNewIndexDef.AsIndex: PGsSqlIndexDef;
begin
  Result := Init(sitIndex);
end;

function TGsSqlNewIndexDef.AsUniqueIndex: PGsSqlIndexDef;
begin
  Result := Init(sitUniqueIndex);
end;

constructor TGsSqlNewIndexDef.Create(var AIndexDef: TGsSqlIndexDef);
begin
  IndexDef := @AIndexDef;
end;

function TGsSqlNewIndexDef.Init(AIndexType: TGsSqlIndexType;
  const AIndexDefinition: TGsSqlIndexDefinition): PGsSqlIndexDef;
begin
  Result := IndexDef;

  with Result^ do
  begin
    IndexType  := AIndexType;
    Definition := AIndexDefinition;
    Change     := False;
    Drop       := False;
    Exists     := False;
  end;
end;

{ TGsSqlNewConstraintDef }

function TGsSqlNewConstraintDef.AddColumn(AName: TGsSqlFieldName;
  ASortDirection: TGsSqlIndexSortDirection): TGsSqlNewConstraintDef;
var
  L: Integer;
begin
  Result := Self;

  with Result do
  begin
    L := Length(ConstraintDef^.Columns);
    SetLength(ConstraintDef^.Columns, L + 1);
    ConstraintDef^.Columns[L].Name          := AName;
    ConstraintDef^.Columns[L].SortDirection := ASortDirection;
  end;
end;

function TGsSqlNewConstraintDef.AsCheck(const ALogicalExpression: TGsSqlFieldCheck): PGsSqlConstraintDef;
begin
  Result := Init(sctCheck);
end;

function TGsSqlNewConstraintDef.AsCustom(const AConstraintDefinition: TGsSqlConstraintDefinition;
  AConstraintType: TGsSqlConstraintType): PGsSqlConstraintDef;
begin
  Result := Init(AConstraintType, '', '', '', '', AConstraintDefinition);
end;

function TGsSqlNewConstraintDef.AsDefault(const ADefault: TGsSqlFieldDefault): PGsSqlConstraintDef;
begin
  Result := Init(sctDefault, ADefault);
end;

function TGsSqlNewConstraintDef.AsForeignKey(const ALookupTable: TGsSqlFieldLookupTable;
  const ALookupField: TGsSqlFieldLookupField): PGsSqlConstraintDef;
begin
  Result := Init(sctForeignKey, '', '', ALookupTable, ALookupField);
end;

function TGsSqlNewConstraintDef.AsPrimaryKey: PGsSqlConstraintDef;
begin
  Result := Init(sctPrimaryKey);
end;

function TGsSqlNewConstraintDef.AsUnique: PGsSqlConstraintDef;
begin
  Result := Init(sctUnique);
end;

constructor TGsSqlNewConstraintDef.Create(var AConstraintDef: TGsSqlConstraintDef);
begin
  ConstraintDef := @AConstraintDef;
end;

function TGsSqlNewConstraintDef.Init(AConstraintType: TGsSqlConstraintType;
  const ADefault: TGsSqlFieldDefault; const ALogicalExpression: TGsSqlFieldCheck;
  const ALookupTable: TGsSqlFieldLookupTable; const ALookupField: TGsSqlFieldLookupField;
  const AConstraintDefinition: TGsSqlConstraintDefinition): PGsSqlConstraintDef;
begin
  Result := ConstraintDef;

  with Result^ do
  begin
    ConstraintType := AConstraintType;
    Default        := ADefault;
    LookupTable    := ALookupTable;
    LookupField    := ALookupField;
    Check          := ALogicalExpression;
    Definition     := AConstraintDefinition;
    Change         := False;
    Drop           := False;
    Exists         := False;
  end;
end;

{ TGsSql }

class procedure TGsSql.AddColumns(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var FieldDefs: TGsSqlFieldDefs; ForceAll: Boolean);
resourcestring
  SErrorAddColumns = 'Fehler beim Hinzufügen der Spalten der Tabelle ''%s'': %s';
var
  Table:        TADOTable;
  FieldsExists: Boolean;
  I:            Integer;
begin
  if not TableExists(Connection, TableName) then
    Exit;

  Table := TADOTable.Create(nil);

  try
    Table.Connection := Connection;
    Table.TableName  := TableName;

    FieldsExists := True;

    for I := Low(FieldDefs) to High(FieldDefs) do
    begin
      if not FieldDefs[I].Exists then
      begin
        if not Table.Active then
          Table.Open;

        FieldDefs[I].Exists := (Table.FindField(FieldDefs[I].Name) <> nil);
      end;

      FieldsExists := FieldsExists and FieldDefs[I].Exists;
    end;
  finally
    Table.Free;
  end;

  if FieldsExists then
    Exit;

  SqlAlterTableAddColumns(Connection, TableName, FieldDefs, ForceAll);
end;

class function TGsSql.AddConstraint(var ConstraintDefs: TGsSqlConstraintDefs;
  const AName: TGsSqlConstraintName): TGsSqlNewConstraintDef;
var
  L: Integer;
begin
  L := Length(ConstraintDefs);
  SetLength(ConstraintDefs, L + 1);
  Result.Create(ConstraintDefs[L]);
  Result.ConstraintDef.Name := AName;
end;

class procedure TGsSql.AddConstraints(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var ConstraintDefs: TGsSqlConstraintDefs; Force: Boolean);
begin
  if not TableExists(Connection, TableName) then
    Exit;

  SqlAlterTableAddConstraints(Connection, TableName, ConstraintDefs, Force);
end;

class function TGsSql.AddField(var FieldDefs: TGsSqlFieldDefs; const AName: TGsSqlFieldName): TGsSqlNewFieldDef;
var
  L: Integer;
begin
  L := Length(FieldDefs);
  SetLength(FieldDefs, L + 1);
  Result.Create(FieldDefs[L]);
  Result.FieldDef.Name := AName;
end;

class function TGsSql.AddField(var FieldDefs: TGsSqlFieldDefs; const AName: TGsSqlFieldName;
  ADataType: TFieldType; ASize: Integer; Required: Boolean; APrecision: Integer): PGsSqlFieldDef;
var
  L: Integer;
  N: TGsSqlNewFieldDef;
begin
  L := Length(FieldDefs);
  SetLength(FieldDefs, L + 1);
  N.Create(FieldDefs[L]);
  N.FieldDef.Name := AName;
  Result          := N.Init(FieldTypeToSqlFieldType[ADataType], ASize, Required, APrecision);
end;

class function TGsSql.AddIndex(var IndexDefs: TGsSqlIndexDefs; const AName: TGsSqlIndexName): TGsSqlNewIndexDef;
var
  L: Integer;
begin
  L := Length(IndexDefs);
  SetLength(IndexDefs, L + 1);
  Result.Create(IndexDefs[L]);
  Result.IndexDef.Name := AName;
end;

class procedure TGsSql.AddIndexes(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var IndexDefs: TGsSqlIndexDefs; ForceAll: Boolean);
resourcestring
  SErrorAddIndexes = 'Fehler beim Hinzufügen der Indizes der Tabelle ''%s'': %s';
var
  lQuery:  TADOQuery;
  lTable:  TADOTable;
  Indexes: TStrings;
  I:       Integer;
begin
  if not TableExists(Connection, TableName) then
    Exit;

  lQuery := TADOQuery.Create(nil);
  lTable := TADOTable.Create(nil);

  try
    lQuery.Connection := Connection;
    lTable.Connection := Connection;
    lTable.TableName  := TableName;

    Indexes := TStringList.Create;

    try
      try
        for I := Low(IndexDefs) to High(IndexDefs) do
        begin
          if not IndexDefs[I].Exists then
          begin
            if not lTable.Active then
            begin
              lTable.Open;
              lTable.GetIndexNames(Indexes);
            end;

            IndexDefs[I].Exists := (Indexes.IndexOf(GetSqlIndexName(IndexDefs[I].IndexType,
              TableName, IndexDefs[I].Name)) > -1);
          end;

          if (not IndexDefs[I].Exists and not IndexDefs[I].Drop) or ForceAll then
          begin
            SqlCreateIndex(Connection, TableName, IndexDefs[I]);
            IndexDefs[I].Exists := True;
          end;
        end;
      except
        on E: Exception do
          raise EGsAdoDbError.CreateResFmt(@SErrorAddIndexes, [TableName, E.Message]);
      end;
    finally
      Indexes.Free;
    end;
  finally
    lTable.Free;
    lQuery.Free;
  end;
end;

class procedure TGsSql.AlterColumn(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var FieldDef: TGsSqlFieldDef; Force: Boolean);
var
  Table: TADOTable;
  Field: TField;
begin
  if not TableExists(Connection, TableName) then
    Exit;

  Table := TADOTable.Create(nil);

  try
    Table.Connection := Connection;
    Table.TableName  := TableName;
    Table.Open;
    Field           := Table.FindField(FieldDef.Name);
    FieldDef.Exists := Assigned(Field);

    if not FieldDef.Exists then
      Exit;

    SqlAlterTableAlterColumn(Connection, Field, TableName, FieldDef, Force);
  finally
    Table.Free;
  end;
end;

class procedure TGsSql.AlterColumns(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var FieldDefs: TGsSqlFieldDefs; ForceAll: Boolean);
var
  Query: TADOQuery;
  Table: TADOTable;
  I:     Integer;
  Field: TField;
begin
  if not TableExists(Connection, TableName) then
    Exit;

  Query := TADOQuery.Create(nil);
  Table := TADOTable.Create(nil);

  try
    Query.Connection := Connection;
    Table.Connection := Connection;
    Table.TableName  := TableName;
    Table.Open;

    for I := Low(FieldDefs) to High(FieldDefs) do
    begin
      Field               := Table.FindField(FieldDefs[I].Name);
      FieldDefs[I].Exists := Assigned(Field);

      if FieldDefs[I].Exists then
        SqlAlterTableAlterColumn(Query, Field, TableName, FieldDefs[I], ForceAll);
    end;
  finally
    Table.Free;
    Query.Free;
  end;
end;

class procedure TGsSql.ConvertSQLColumns(var SqlFieldDefs: TGsSqlFieldDefs; SQLColumns: TSQLColumns);
var
  I: Integer;
begin
  SetLength(SqlFieldDefs, Length(SQLColumns));

  for I := Low(SQLColumns) to High(SQLColumns) do
  begin
    SqlFieldDefs[I].Name       := SQLColumns[I].Name;
    SqlFieldDefs[I].DataType   := sftUnknown;
    SqlFieldDefs[I].Definition := SQLColumns[I].Definition;
  end;
end;

class function TGsSql.ConcatDefinitions(const Definition, NewDefinition: string): string;
begin
  Result := Definition;

  if (NewDefinition <> '') then
  begin
    if (Result <> '') then
      Result := Result + ',' + GetSqlLineBreak;

    Result := Result + NewDefinition;
  end;
end;

class procedure TGsSql.ConvertSQLColumns(var SqlIndexDefs: TGsSqlIndexDefs; SQLColumns: TSQLColumns);
var
  I: Integer;
begin
  SetLength(SqlIndexDefs, Length(SQLColumns));

  for I := Low(SQLColumns) to High(SQLColumns) do
  begin
    SqlIndexDefs[I].Name       := SQLColumns[I].Name;
    SqlIndexDefs[I].Definition := SQLColumns[I].Definition;
  end;
end;

class procedure TGsSql.CreateTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var FieldDefs: TGsSqlFieldDefs; const EventProc: TGsSqlNotifyProc; var TableState: TGsSqlTableStates);
resourcestring
  SErrorCreateTable = 'Fehler beim Erstellen der Tabelle ''%s'': Tabelle ist bereits vorhanden.';
var
  ConstraintDefs: TGsSqlConstraintDefs;
  IndexDefs:      TGsSqlIndexDefs;
begin
  if (tsExists in TableState) then
    raise EGsAdoDbError.CreateResFmt(@SErrorCreateTable, [TableName]);

  DoEvent(EventProc, neBeforeCreateTable, TableName, FieldDefs, ConstraintDefs, IndexDefs, TableState);
  SqlCreateTable(Connection, TableName, FieldDefs);
  TableState := [tsCreated, tsExists, tsEmpty];
  DoEvent(EventProc, neAfterCreateTable, TableName, FieldDefs, ConstraintDefs, IndexDefs, TableState);
end;

class procedure TGsSql.CreateTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var FieldDefs: TGsSqlFieldDefs; const EventProc: TGsSqlNotifyProc);
var
  TableState: TGsSqlTableStates;
begin
  TableState := Self.TableState(Connection, TableName);
  CreateTable(Connection, TableName, FieldDefs, EventProc, TableState);
end;

class procedure TGsSql.DoEvent(const EventProc: TGsSqlNotifyProc; Event: TGsSqlNotifyEvent;
  {Connection: TADOConnection;}
  const TableName: TGsSqlTableName; var FieldDefs: TGsSqlFieldDefs; var ConstraintDefs: TGsSqlConstraintDefs;
  var IndexDefs: TGsSqlIndexDefs; var TableState: TGsSqlTableStates);
resourcestring
  SErrorInEventProc = 'Fehler bei der Ausführung des Ereignisses ''%s'' der Tabelle ''%s'': %s';
begin
  try
    if @EventProc <> nil then
      EventProc(Event, {Connection,} TableName, FieldDefs, ConstraintDefs, IndexDefs, TableState);
  except
    on E: Exception do
      raise EGsAdoDbError.CreateResFmt(@SErrorInEventProc, [GetEnumName(TypeInfo(TGsSqlNotifyEvent), Ord(Event)),
        TableName, E.Message]);
  end;
end;

class procedure TGsSql.DropAllIndexes(Connection: TADOConnection; const TableName: TGsSqlTableName);
resourcestring
  SErrorDropAllIndexes = 'Fehler beim Löschen des Index ''%s'' der Tabelle ''%s'': %s';
var
  Query:   TADOQuery;
  Table:   TADOTable;
  Indexes: TStrings;
  I:       Integer;
begin
  if not TableExists(Connection, TableName) then
    Exit;

  Query := TADOQuery.Create(nil);
  Table := TADOTable.Create(nil);

  try
    Query.Connection := Connection;
    Table.Connection := Connection;
    Table.TableName  := TableName;
    Table.Open;

    Indexes := TStringList.Create;

    try
      Table.GetIndexNames(Indexes);

      for I := 0 to Indexes.Count - 1 do
      begin
        if (Pos(SqlConstraintPrefixes[sctPrimaryKey], Indexes.Strings[I]) > 0) then
          Continue;

        with Query do
        begin
          with SQL do
          begin
            Clear;
            Add('DROP INDEX [' + Indexes.Strings[I] + ']');
            Add('ON ' + GetSqlObjectName(TableName));
          end;

          ExecSQL;
        end;
      end;
    finally
      Indexes.Free;
    end;
  finally
    Table.Free;
    Query.Free;
  end;
end;

class procedure TGsSql.DropColumns(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var FieldDefs: TGsSqlFieldDefs; ForceAll: Boolean);
var
  Table: TADOTable;
  I:     Integer;
begin
  if not TableExists(Connection, TableName) then
    Exit;

  Table := TADOTable.Create(nil);

  try
    Table.Connection := Connection;
    Table.TableName  := TableName;

    for I := Low(FieldDefs) to High(FieldDefs) do
    begin
      if not FieldDefs[I].Drop and not ForceAll then
        Continue;

      if not Table.Active then
        Table.Open;

      FieldDefs[I].Exists := (Table.FindField(FieldDefs[I].Name) <> nil);
    end;

    // Drop dummy field
    AddField(FieldDefs, cDummyColumn).AsDeleteable.Exists := (Table.FindField(cDummyColumn) <> nil);

    SqlAlterTableDropColumns(Connection, TableName, FieldDefs, False);
  finally
    Table.Free;
  end;
end;

class procedure TGsSql.DropConstraints(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var ConstraintDefs: TGsSqlConstraintDefs; Force: Boolean);
begin
  if not TableExists(Connection, TableName) then
    Exit;

  SqlAlterTableDropConstraints(Connection, TableName, ConstraintDefs, Force);
end;

class procedure TGsSql.DropIndex(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var IndexDef: TGsSqlIndexDef; Force: Boolean);
var
  lTable:  TADOTable;
  Indexes: TStrings;
begin
  if not TableExists(Connection, TableName) or (not IndexDef.Drop and not Force) then
    Exit;

  if not IndexDef.Exists then
  begin
    lTable := TADOTable.Create(nil);

    try
      lTable.Connection := Connection;
      lTable.TableName  := TableName;

      Indexes := TStringList.Create;

      try
        lTable.Open;
        lTable.GetIndexNames(Indexes);
        IndexDef.Exists := (Indexes.IndexOf(GetSqlIndexName(IndexDef.IndexType, TableName, IndexDef.Name)) > -1);
      finally
        Indexes.Free;
      end;
    finally
      lTable.Free;
    end;
  end;

  if not IndexDef.Exists then
    Exit;

  SqlDropIndex(Connection, TableName, IndexDef);
end;

class procedure TGsSql.DropIndexes(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var IndexDefs: TGsSqlIndexDefs; ForceAll: Boolean);
var
  Query:   TADOQuery;
  Table:   TADOTable;
  Indexes: TStrings;
  I:       Integer;
begin
  if not TableExists(Connection, TableName) then
    Exit;

  Query := TADOQuery.Create(nil);
  Table := TADOTable.Create(nil);

  try
    Query.Connection := Connection;
    Table.Connection := Connection;
    Table.TableName  := TableName;

    Indexes := TStringList.Create;

    try
      for I := Low(IndexDefs) to High(IndexDefs) do
      begin
        if not ForceAll and not IndexDefs[I].Drop then
          Continue;

        if not IndexDefs[I].Exists then
        begin
          if not Table.Active then
            Table.Open;

          Table.GetIndexNames(Indexes);
          IndexDefs[I].Exists := (Indexes.IndexOf(GetSqlIndexName(IndexDefs[I].IndexType,
            TableName, IndexDefs[I].Name)) > -1);
        end;

        if not IndexDefs[I].Exists then
          Continue;

        SqlDropIndex(Query, TableName, IndexDefs[I]);
      end;
    finally
      Indexes.Free;
    end;
  finally
    Table.Free;
    Query.Free;
  end;
end;

class procedure TGsSql.DropTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
  const EventProc: TGsSqlNotifyProc);
resourcestring
  SErrorDropTable = 'Fehler beim Löschen der Tabelle ''%s'': Tabelle wurde nicht gefunden.';
var
  TableState:     TGsSqlTableStates;
  FieldDefs:      TGsSqlFieldDefs;
  ConstraintDefs: TGsSqlConstraintDefs;
  IndexDefs:      TGsSqlIndexDefs;
begin
  TableState := Self.TableState(Connection, TableName);

  if not (tsExists in TableState) then
    raise EGsAdoDbError.CreateResFmt(@SErrorDropTable, [TableName]);

  DoEvent(EventProc, neBeforeDropTable, TableName, FieldDefs, ConstraintDefs, IndexDefs, TableState);
  SqlDropTable(Connection, TableName);
  TableState := [tsDropped];
  DoEvent(EventProc, neAfterDropTable, TableName, FieldDefs, ConstraintDefs, IndexDefs, TableState);
end;

class function TGsSql.GetQuery(const Caller: string; AdoObject: TComponent; out Release: Boolean): TADOQuery;

  function GetClassName(AObject: TComponent): string;
  begin
    if Assigned(AObject) then
      Result := AObject.ClassName
    else
      Result := 'nil';
  end;

begin
  Result  := nil;
  Release := False;

  if (AdoObject is TADOQuery) then
    Result := TADOQuery(AdoObject)
  else
  if (AdoObject is TADOConnection) then
  begin
    Result            := TADOQuery.Create(AdoObject);
    Result.Connection := TADOConnection(AdoObject);
    Release           := True;
  end
  else
    RaiseNotImplementedError(EGsAdoDbError, Caller, Self, GetClassName(AdoObject));
end;

class function TGsSql.GetSqlColumnDefinition(ColumnDefinitionType: TGsSqlColumnDefinitionType;
  const TableName: TGsSqlTableName; FieldDef: TGsSqlFieldDef; Force: Boolean): string;

  function GetSizeStr(FieldDef: TGsSqlFieldDef): string;
  var
    Size: Integer;
  begin
    if (FieldDef.DataType = sftFloat) then
    begin
      if (FieldDef.Size > 4) then
        Size := 53
      else
        Size := 24;
    end
    else
      Size := FieldDef.Size;

    if (Size = SQL_MAX) then
      Result := ' (max)'
    else
    if (Size < 1) then
      Result := ''
    else
      Result := ' (' + IntToStr(Size) + ')';
  end;

resourcestring
  SUnsupportedFieldType = 'Der Feldtyp ''%s'' wird nicht unterstützt.';

(*
  SAutoIncFieldDef      = '[%s] IDENTITY(%u,%u) NOT FOR REPLICATION CONSTRAINT [%s_PK] PRIMARY KEY';
const
  SQL_FIELD_TYPES: array[TFieldType] of string = (
    '',                     // ftUnknown
    '',                     // ftString
    '[smallint]',           // ftSmallint
    '[int]',                // ftInteger
    '[tinyint]',            // ftWord
    '[bit]',                // ftBoolean
    '[float]',              // ftFloat
    '[money]',              // ftCurrency
    '[decimal]',            // ftBCD
    '[datetime]',           // ftDate
    '[datetime]',           // ftTime
    '[datetime]',           // ftDateTime
    '[binary]',             // ftBytes
    '[varbinary]',          // ftVarBytes
    '',                     // ftAutoInc
    '[image]',              // ftBlob
    '[text]',               // ftMemo
    '',                     // ftGraphic
    '',                     // ftFmtMemo
    '',                     // ftParadoxOle
    '',                     // ftDBaseOle
    '',                     // ftTypedBinary
    '',                     // ftCursor
    '[char]',               // ftFixedChar
    '',                     // ftWideString
    '[bigint]',             // ftLargeint
    '',                     // ftADT
    '',                     // ftArray
    '',                     // ftReference
    '',                     // ftDataSet
    '',                     // ftOraBlob
    '',                     // ftOraClob
    '[sql_variant]',        // ftVariant
    '',                     // ftInterface
    '',                     // ftIDispatch
    '[uniqueidentifier]',   // ftGuid
    '',                     // ftTimeStamp
    '',                     // ftFMTBcd
    '[nchar]',              // ftFixedWideChar
    '[ntext]',              // ftWideMemo
    '',                     // ftOraTimeStamp
    '',                     // ftOraInterval
    '',                     // ftLongWord
    '',                     // ftShortint
    '',                     // ftByte
    '',                     // ftExtended
    '',                     // ftConnection
    '',                     // ftParams
    '',                     // ftStream
    '',                     // ftTimeStampOffset
    '',                     // ftObject
    ''                      // ftSingle
    );
  SIZED_FIELDS: set of TFieldType = [ftString, ftBytes, ftVarBytes, ftFixedChar, ftWideString, ftFixedWideChar];
  DBL_SIZED_FIELDS: set of TFieldType = [ftBCD];

(*
< column_definition > ::= { column_name data_type }
    [ COLLATE < collation_name > ]
    [ [ DEFAULT constant_expression ]
        | [ IDENTITY [ ( seed , increment ) [ NOT FOR REPLICATION ] ] ]
    ]
    [ ROWGUIDCOL ]
    [ < column_constraint > ] [ ...n ]

< column_constraint > ::= [ CONSTRAINT constraint_name ]
    { [ NULL | NOT NULL ]
        | [ { PRIMARY KEY | UNIQUE }
            [CLUSTERED | NONCLUSTERED]
            [WITH FILLFACTOR = fillfactor]
            [ON {filegroup | DEFAULT} ]]
        ]
        | [ [ FOREIGN KEY ]
            REFERENCES ref_table [ ( ref_column ) ]
            [ ON DELETE { CASCADE | NO ACTION } ]
            [ ON UPDATE { CASCADE | NO ACTION } ]
            [NOT FOR REPLICATION]
        ]
        | CHECK [NOT FOR REPLICATION]
        ( logical_expression )
    }

< table_constraint > ::= [ CONSTRAINT constraint_name ]
    { [ { PRIMARY KEY | UNIQUE }
        [CLUSTERED | NONCLUSTERED]
        { ( column [ ASC | DESC ] [ ,...n ] ) }
        [WITH FILLFACTOR = fillfactor]
        [ON {filegroup | DEFAULT} ]
    ]
    | FOREIGN KEY
        [ ( column [ ,...n ] ) ]
        REFERENCES ref_table [ ( ref_column [ ,...n ] ) ]
        [ ON DELETE { CASCADE | NO ACTION } ]
        [ ON UPDATE { CASCADE | NO ACTION } ]
        [NOT FOR REPLICATION]
    | CHECK [NOT FOR REPLICATION]
        ( search_conditions )
    }

  SAutoIncFieldDef      = '[%s] IDENTITY(%u,%u) NOT FOR REPLICATION CONSTRAINT [%s_PK] PRIMARY KEY';
*)
begin
  Result := '';

  if not Force and (((ColumnDefinitionType in [scdtCreateTable, scdtAddColumn]) and FieldDef.Exists) or
    ((ColumnDefinitionType in [scdtAlterColumn, scdtDropColumn]) and not FieldDef.Exists) or
    ((ColumnDefinitionType in [scdtCreateTable, scdtAlterColumn, scdtAddColumn]) and FieldDef.Drop) or
    ((ColumnDefinitionType in [scdtDropColumn]) and not FieldDef.Drop)) then
    Exit;

  Result := '[' + FieldDef.Name + '] ';

  if (ColumnDefinitionType in [scdtDropColumn]) then
    Exit;

  if (FieldDef.Definition <> '') then
    Result := Result + FieldDef.Definition
  else
  begin
    // Data type
    case FieldDef.DataType of
      sftUnknown: raise Exception.CreateResFmt(@SUnsupportedFieldType,
          [GetEnumName(TypeInfo(TGsSqlFieldType), Ord(FieldDef.DataType))]);
      sftAutoInc:
      begin
        if (FieldDef.Size = 1) then
          Result := Result + '[' + SqlDataTypes[sftTinyInt].DataType + ']'
        else
        if (FieldDef.Size = 2) then
          Result := Result + '[' + SqlDataTypes[sftSmallInt].DataType + ']'
        else
        if (FieldDef.Size > 4) then
          Result := Result + '[' + SqlDataTypes[sftBigInt].DataType + ']'
        else
          Result := Result + '[' + SqlDataTypes[sftInteger].DataType + ']';
      end;
    else
      Result := Result + '[' + SqlDataTypes[FieldDef.DataType].DataType + ']';
    end;


    // Sizes
    if (SqlDataTypes[FieldDef.DataType].Size = siSingle) and (FieldDef.Size > 0) then
      Result := Result + GetSizeStr(FieldDef);

    if (SqlDataTypes[FieldDef.DataType].Size = siDouble) and (FieldDef.Precision > 0) then
    begin
      Result := Result + ' (' + IntToStr(FieldDef.Precision);

      if (FieldDef.Size > 0) then
        Result := Result + ', ' + IntToStr(FieldDef.Size) + ')';

      Result := Result + ')';
    end;


    // COLLATE for char, varchar, text, nchar, nvarchar, and ntext
    if (FieldDef.Collation <> '') and (FieldDef.DataType in [sftChar, sftVarChar, sftText,
      sftUnicodeChar, sftUnicodeVarChar, sftUnicodeText]) then
      Result := Result + ' COLLATE ' + FieldDef.Collation;


    // IDENTITY or DEFAULT
    if (ColumnDefinitionType in [scdtCreateTable, scdtAddColumn]) then
    begin
      if (sfaIdentity in FieldDef.Attributes) then
        Result := Result + Format(' IDENTITY (%u, %u)', [1, 1])
      else
      if (FieldDef.Default <> '') then
        Result := Result + Format(' CONSTRAINT [%s] DEFAULT %s',
          [GetSqlConstraintName(sctDefault, TableName, FieldDef.Name), FieldDef.Default]);
    end;


    // (not) required constraint
    if (sfaRequired in FieldDef.Attributes) or (sfaIdentity in FieldDef.Attributes) or
      (sfaPrimaryKey in FieldDef.Attributes) then
      Result := Result + ' NOT';

    Result := Result + ' NULL';


    // Column constraints
    if (ColumnDefinitionType in [scdtCreateTable, scdtAddColumn]) then
    begin
      if (sfaPrimaryKey in FieldDef.Attributes) then
        Result := Result + Format(' CONSTRAINT [%s] PRIMARY KEY',
          [GetSqlConstraintName(sctPrimaryKey, TableName)])
      else
      begin
        if (sfaUnique in FieldDef.Attributes) then
          Result := Result + Format(' CONSTRAINT [%s] UNIQUE',
            [GetSqlConstraintName(sctUnique, TableName, FieldDef.Name)]);

        if (FieldDef.LookupTable <> '') and (FieldDef.LookupField <> '') then
          Result := Result + Format(' CONSTRAINT [%s] FOREIGN KEY REFERENCES %s (%s)',
            [GetSqlConstraintName(sctForeignKey, TableName, FieldDef.Name), FieldDef.LookupTable,
            FieldDef.LookupField]);
      end;

      if (FieldDef.Check <> '') then
        Result := Result + Format(' CONSTRAINT [%s] CHECK (%s)',
          [GetSqlConstraintName(sctCheck, TableName, FieldDef.Name), FieldDef.Check]);
    end;
  end;
end;

class function TGsSql.GetSqlColumnDefinitions(ColumnDefinitionType: TGsSqlColumnDefinitionType;
  const TableName: TGsSqlTableName; FieldDefs: TGsSqlFieldDefs; Force: Boolean): string;
var
  I: Integer;
begin
  Result := '';

  for I := Low(FieldDefs) to High(FieldDefs) do
    Result := ConcatDefinitions(Result, GetSqlColumnDefinition(ColumnDefinitionType, TableName, FieldDefs[I], Force));
end;

class function TGsSql.GetSqlConstraintColumnDefinition(ConstraintDefinitionType: TGsSqlConstraintDefinitionType;
  const TableName: TGsSqlTableName; ConstraintDef: TGsSqlConstraintDef; Force: Boolean): string;
begin

end;

class function TGsSql.GetSqlConstraintColumnDefinitions(ConstraintDefinitionType: TGsSqlConstraintDefinitionType;
  const TableName: TGsSqlTableName; ConstraintDefs: TGsSqlConstraintDefs; Force: Boolean): string;
var
  I: Integer;
begin
  Result := '';

  for I := Low(ConstraintDefs) to High(ConstraintDefs) do
    Result := ConcatDefinitions(Result, GetSqlConstraintColumnDefinition(ConstraintDefinitionType,
      TableName, ConstraintDefs[I], Force));
end;

class function TGsSql.GetSqlConstraintName(AType: TGsSqlConstraintType;
  const ATableOrViewName, AFieldName: string): string;
begin
  Result := SqlConstraintPrefixes[AType] + '_' + ATableOrViewName;

  if (AFieldName <> '') then
    Result := Result + '_' + AFieldName;
end;

class function TGsSql.GetSqlIndexColumnDefinition(IndexDefinitionType: TGsSqlIndexDefinitionType;
  const TableName: TGsSqlTableName; IndexDef: TGsSqlIndexDef; Force: Boolean): string;
const
  SORT_DIRECTION: array[TGsSqlIndexSortDirection] of string = ('ASC', 'DESC');
var
  I: Integer;
begin
  for I := Low(IndexDef.IndexColumns) to High(IndexDef.IndexColumns) do
    Result := ConcatDefinitions(Result, IndexDef.IndexColumns[I].Name + ' ' +
      SORT_DIRECTION[IndexDef.IndexColumns[I].SortDirection]);
end;

class function TGsSql.GetSqlIndexDefinition(IndexDefinitionType: TGsSqlIndexDefinitionType;
  const TableName: TGsSqlTableName; IndexDef: TGsSqlIndexDef; Force: Boolean): string;
begin
  Result := '';

  if not Force and (((IndexDefinitionType in [sidtCreateIndex]) and IndexDef.Exists) or
    ((IndexDefinitionType in [sidtDropIndex]) and not IndexDef.Exists) or
    ((IndexDefinitionType in [sidtCreateIndex]) and IndexDef.Drop) or
    ((IndexDefinitionType in [sidtDropIndex]) and not IndexDef.Drop)) then
    Exit;

  if (IndexDefinitionType in [sidtCreateIndex]) then
  begin
    Result := 'CREATE ';

    if (IndexDef.IndexType = sitUniqueIndex) then
      Result := Result + 'UNIQUE ';
  end
  else
    Result := 'DELETE ';

  Result := Result + 'INDEX [' + GetSqlIndexName(IndexDef.IndexType, TableName, IndexDef.Name) + ']';

  if (IndexDefinitionType in [sidtCreateIndex]) then
  begin
    Result := Result + GetSqlLineBreak + 'ON ' + GetSqlObjectName(TableName) + ' (' + GetSqlLineBreak;

    if (IndexDef.Definition <> '') then
      Result := Result + IndexDef.Definition
    else
      Result := Result + GetSqlIndexColumnDefinition(IndexDefinitionType, TableName, IndexDef, Force);

    Result := Result + GetSqlLineBreak + ')';
  end;
end;

class function TGsSql.GetSqlIndexName(AType: TGsSqlIndexType; const ATableOrViewName, AFieldName: string): string;
begin
  Result := SqlIndexPrefixes[AType] + '_' + ATableOrViewName;

  if (AFieldName <> '') then
    Result := Result + '_' + AFieldName;
end;

class function TGsSql.GetSqlLineBreak: string;
begin
  Result := #13#10;
end;

class function TGsSql.GetSqlObjectName(const ATableOrViewName, ASchemaName, ADatabaseName: string): string;
begin
  Result := '[' + ATableOrViewName + ']';

  if (ASchemaName <> '') then
    Result := '[' + ASchemaName + '].' + Result;

  if (ADatabaseName <> '') then
    Result := '[' + ADatabaseName + '].' + Result;
end;

class procedure TGsSql.ProcessTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
  FieldDefs: TGsSqlFieldDefs; ConstraintDefs: TGsSqlConstraintDefs; IndexDefs: TGsSqlIndexDefs;
  const EventProc: TGsSqlNotifyProc);
var
  TableState: TGsSqlTableStates;
begin
  TableState := Self.TableState(Connection, TableName);
  DoEvent(EventProc, neBeforeProcessTable, TableName, FieldDefs, ConstraintDefs, IndexDefs, TableState);

  if not (tsExists in TableState) then
    CreateTable(Connection, TableName, FieldDefs, EventProc, TableState);

  UpdateTable(Connection, TableName, FieldDefs, ConstraintDefs, IndexDefs, EventProc, TableState);

  DoEvent(EventProc, neAfterProcessTable, TableName, FieldDefs, ConstraintDefs, IndexDefs, TableState);
end;

class procedure TGsSql.SqlAlterTableAddColumns(AdoObject: TComponent; const ATableName: TGsSqlTableName;
  var AFieldDefs: TGsSqlFieldDefs; Force: Boolean);
resourcestring
  SErrorSqlAlterTableAddColumns = 'Fehler beim Anfügen von Spalten an die Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
  S:            string;
  I:            Integer;
begin
  Query := GetQuery('SqlAlterTableAddColumns', AdoObject, ReleaseQuery);

  try
    try
      with Query do
      begin
        with SQL do
        begin
          Clear;
          Add('ALTER TABLE ' + GetSqlObjectName(ATableName));
          Add('ADD');
        end;

        S := GetSqlColumnDefinitions(scdtAddColumn, ATableName, AFieldDefs, Force);

        if (S <> '') then
        begin
          SQL.Add(S);
          ExecSQL;

          for I := Low(AFieldDefs) to High(AFieldDefs) do
            if Force or not AFieldDefs[I].Drop then
              AFieldDefs[I].Exists := True;
        end;
      end;
    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorSqlAlterTableAddColumns, [ATableName, E.Message], Query.SQL.Text);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class procedure TGsSql.SqlAlterTableAddConstraints(AdoObject: TComponent; const ATableName: TGsSqlTableName;
  var AConstraintDefs: TGsSqlConstraintDefs; Force: Boolean);
resourcestring
  SErrorSqlAlterTableAddConstraints = 'Fehler beim Anfügen von Einschränkungen an die Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
  S:            string;
  I:            Integer;
begin
  Query := GetQuery('SqlAlterTableAddConstraints', AdoObject, ReleaseQuery);

  try
    try
      with Query do
      begin
        with SQL do
        begin
          Clear;
          Add('ALTER TABLE ' + GetSqlObjectName(ATableName));
          Add('ADD');
        end;

        S := GetSqlConstraintColumnDefinitions(scdtAddConstraint, ATableName, AConstraintDefs, Force);

        if (S <> '') then
        begin
          SQL.Add(S);
          ExecSQL;

          for I := Low(AConstraintDefs) to High(AConstraintDefs) do
            if Force or not AConstraintDefs[I].Drop then
              AConstraintDefs[I].Exists := True;
        end;
      end;
    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorSqlAlterTableAddConstraints, [ATableName, E.Message], Query.SQL.Text);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class procedure TGsSql.SqlAlterTableAlterColumn(AdoObject: TComponent; AField: TField;
  const ATableName: TGsSqlTableName; var AFieldDef: TGsSqlFieldDef; Force: Boolean);

  function DbSize(FieldDef: TGsSqlFieldDef): Integer;
  begin
    if (FieldDef.DataType in [sftChar, sftVarChar]) then
      Result := FieldDef.Size + 1
    else
    if (FieldDef.DataType in [sftUnicodeChar, sftUnicodeVarChar]) then
      Result := (FieldDef.Size + 1) * 2
    else
    if (FieldDef.DataType in [sftVarBinary]) then
      Result := FieldDef.Size + 2
    else
    if (FieldDef.DataType in [sftTinyInt]) then
      Result := 2
    else
    if (FieldDef.DataType in [sftMoney, sftSmallMoney, sftDecimal, sftNumeric]) then
      Result := 34
    else
      Result := FieldDef.Size;
  end;

const
  DbFieldType: array[TGsSqlFieldType] of TFieldType = (
    ftUnknown,         // sftUnknown
    ftAutoInc,         // sftAutoInc
    ftString,          // sftChar
    ftString,          // sftVarChar
    ftMemo,            // sftText
    ftWideString,      // sftUnicodeChar
    ftWideString,      // sftUnicodeVarChar
    ftWideMemo,        // sftUnicodeText
    ftBytes,           // sftBinary
    ftVarBytes,        // sftVarBinary
    ftBlob,            // sftImage
    ftBoolean,         // sftBit
    ftInteger,         // sftInteger
    ftLargeint,        // sftBigInt
    ftSmallint,        // sftSmallInt
    ftWord,            // sftTinyInt
    ftBCD,             // sftMoney
    ftBCD,             // sftSmallMoney
    ftBCD,             // sftDecimal
    ftBCD,             // sftNumeric
    ftFloat,           // sftFloat
    ftFloat,           // sftReal
                       //ftDateTime,        // sftDate
    ftDateTime,        // sftDateTime
                       //ftDateTime,        // sftDateTime2
                       //ftTimeStampOffset, // sftDateTimeOffset
    ftDateTime,        // sftSmallDateTime
                       //ftTime,            // sftTime
    ftGuid,            // sftUniqueIdentifier
    ftVariant,         // sftSqlVariant
    ftWideMemo         // sftXml
    );
resourcestring
  SErrorSqlAlterTableAlterColumn = 'Fehler beim Ändern der Spalte ''%s'' der Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
  Constraints:  TGsSqlConstraintDefs;
begin
  // Ignore changes on unknown and auto inc fields
  if not Force and ((AFieldDef.DataType = sftUnknown) or (AFieldDef.DataType = sftAutoInc)) then
    Exit;

  Query := GetQuery('SqlAlterTableAlterColumn', AdoObject, ReleaseQuery);

  try
    if Force or (DbFieldType[AFieldDef.DataType] <> AField.DataType) or (DbSize(AFieldDef) > AField.DataSize) then
    begin
      try
        with Query do
        begin
          with SQL do
          begin
            Clear;
            Add('ALTER TABLE ' + GetSqlObjectName(ATableName));
            Add('ALTER COLUMN ' + GetSqlColumnDefinition(scdtAlterColumn, ATableName, AFieldDef, Force));
          end;

          ExecSQL;
        end;
      except
        on E: Exception do
          raise EGsAdoDbSqlError.Create(@SErrorSqlAlterTableAlterColumn, [AFieldDef.Name, ATableName, E.Message],
            Query.SQL.Text);
      end;

      // Create constraint
      if (sfaPrimaryKey in AFieldDef.Attributes) then
        AddConstraint(Constraints, GetSqlConstraintName(sctPrimaryKey, ATableName)).AddColumn(
          AFieldDef.Name).AsPrimaryKey
      else
      begin
        if (AFieldDef.Default <> '') then
          AddConstraint(Constraints, GetSqlConstraintName(sctDefault, ATableName,
            AFieldDef.Name)).AddColumn(AFieldDef.Name).AsDefault(AFieldDef.Default);

        if (sfaUnique in AFieldDef.Attributes) then
          AddConstraint(Constraints, GetSqlConstraintName(sctUnique, ATableName)).AddColumn(AFieldDef.Name).AsUnique;

        if (AFieldDef.LookupTable <> '') and (AFieldDef.LookupField <> '') then
          AddConstraint(Constraints, GetSqlConstraintName(sctForeignKey, ATableName)).AddColumn(
            AFieldDef.Name).AsForeignKey(
            AFieldDef.LookupTable, AFieldDef.LookupField);
      end;

      if (AFieldDef.Check <> '') then
        AddConstraint(Constraints, GetSqlConstraintName(sctCheck, ATableName)).AddColumn(AFieldDef.Name).AsCheck(
          AFieldDef.Check);

      SqlAlterTableDropConstraints(Query, ATableName, Constraints, True);
      SqlAlterTableAddConstraints(Query, ATableName, Constraints, False);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class procedure TGsSql.SqlAlterTableDropColumns(AdoObject: TComponent; const ATableName: TGsSqlTableName;
  var AFieldDefs: TGsSqlFieldDefs; Force: Boolean);
resourcestring
  SErrorSqlAlterTableDropColumns = 'Fehler beim Löschen von Spalten der Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
  S:            string;
  I:            Integer;
begin
  Query := GetQuery('SqlAlterTableDropColumns', AdoObject, ReleaseQuery);

  try
    try
      with Query do
      begin
        with SQL do
        begin
          Clear;
          Add('ALTER TABLE ' + GetSqlObjectName(ATableName));
          Add('DROP COLUMN');
        end;

        S := GetSqlColumnDefinitions(scdtDropColumn, ATableName, AFieldDefs, Force);

        if (S <> '') then
        begin
          SQL.Add(S);
          ExecSQL;

          for I := Low(AFieldDefs) to High(AFieldDefs) do
            if Force or AFieldDefs[I].Drop then
              AFieldDefs[I].Exists := False;
        end;
      end;

    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorSqlAlterTableDropColumns, [ATableName, E.Message], Query.SQL.Text);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class procedure TGsSql.SqlAlterTableDropConstraints(AdoObject: TComponent; const ATableName: TGsSqlTableName;
  var AConstraintDefs: TGsSqlConstraintDefs; Force: Boolean);
resourcestring
  SErrorSqlAlterTableDropConstraints = 'Fehler beim Löschen von Einschränkungen der Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
  S:            string;
  I:            Integer;
begin
  Query := GetQuery('SqlAlterTableDropConstraints', AdoObject, ReleaseQuery);

  try
    try
      with Query do
      begin
        with SQL do
        begin
          Clear;
          Add('ALTER TABLE ' + GetSqlObjectName(ATableName));
          Add('DROP CONSTRAINT');
        end;

        S := GetSqlConstraintColumnDefinitions(scdtDropConstraint, ATableName, AConstraintDefs, Force);

        if (S <> '') then
        begin
          SQL.Add(S);
          ExecSQL;

          for I := Low(AConstraintDefs) to High(AConstraintDefs) do
            if Force or AConstraintDefs[I].Drop then
              AConstraintDefs[I].Exists := False;
        end;
      end;
    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorSqlAlterTableDropConstraints, [ATableName, E.Message], Query.SQL.Text);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class procedure TGsSql.SqlCreateIndex(AdoObject: TComponent; const ATableName: TGsSqlTableName;
  var AIndexDef: TGsSqlIndexDef);
resourcestring
  SErrorSqlCreateIndex = 'Fehler beim Erstellen des Index ''%s'' der Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
begin
  Query := GetQuery('SqlCreateIndex', AdoObject, ReleaseQuery);

  try
    try
      with Query do
      begin
        with SQL do
        begin
          Clear;
          Add(GetSqlIndexDefinition(sidtCreateIndex, ATableName, AIndexDef, False));
        end;

        ExecSQL;
      end;
    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorSqlCreateIndex,
          [GetSqlIndexName(AIndexDef.IndexType, ATableName, AIndexDef.Name), ATableName, E.Message], Query.SQL.Text);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class procedure TGsSql.SqlCreateTable(AdoObject: TComponent; const ATableName: TGsSqlTableName;
  var AFieldDefs: TGsSqlFieldDefs);
(*
CREATE TABLE
    [ database_name.[ owner ] . | owner. ] table_name
    ( { < column_definition >
        | column_name AS computed_column_expression
        | < table_constraint > ::= [ CONSTRAINT constraint_name ] }

            | [ { PRIMARY KEY | UNIQUE } [ ,...n ]
    )

[ ON { filegroup | DEFAULT } ]
[ TEXTIMAGE_ON { filegroup | DEFAULT } ]

< column_definition > ::= { column_name data_type }
    [ COLLATE < collation_name > ]
    [ [ DEFAULT constant_expression ]
        | [ IDENTITY [ ( seed , increment ) [ NOT FOR REPLICATION ] ] ]
    ]
    [ ROWGUIDCOL ]
    [ < column_constraint > ] [ ...n ]

< column_constraint > ::= [ CONSTRAINT constraint_name ]
    { [ NULL | NOT NULL ]
        | [ { PRIMARY KEY | UNIQUE }
            [CLUSTERED | NONCLUSTERED]
            [WITH FILLFACTOR = fillfactor]
            [ON {filegroup | DEFAULT} ]]
        ]
        | [ [ FOREIGN KEY ]
            REFERENCES ref_table [ ( ref_column ) ]
            [ ON DELETE { CASCADE | NO ACTION } ]
            [ ON UPDATE { CASCADE | NO ACTION } ]
            [NOT FOR REPLICATION]
        ]
        | CHECK [NOT FOR REPLICATION]
        ( logical_expression )
    }

< table_constraint > ::= [ CONSTRAINT constraint_name ]
    { [ { PRIMARY KEY | UNIQUE }
        [CLUSTERED | NONCLUSTERED]
        { ( column [ ASC | DESC ] [ ,...n ] ) }
        [WITH FILLFACTOR = fillfactor]
        [ON {filegroup | DEFAULT} ]
    ]
    | FOREIGN KEY
        [ ( column [ ,...n ] ) ]
        REFERENCES ref_table [ ( ref_column [ ,...n ] ) ]
        [ ON DELETE { CASCADE | NO ACTION } ]
        [ ON UPDATE { CASCADE | NO ACTION } ]
        [NOT FOR REPLICATION]
    | CHECK [NOT FOR REPLICATION]
        ( search_conditions )
    }
*)

resourcestring
  SErrorSqlCreateTable = 'Fehler beim Erstellen der Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
begin
  Query := GetQuery('SqlCreateTable', AdoObject, ReleaseQuery);

  try
    try
      with Query do
      begin
        with SQL do
        begin
          Clear;
          Add('CREATE TABLE ' + GetSqlObjectName(ATableName));
          Add('(');
          Add(GetSqlColumnDefinitions(scdtCreateTable, ATableName, AFieldDefs, False));
          Add(')');
        end;

        Query.ExecSQL;
      end;
    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorSqlCreateTable, [ATableName, E.Message], Query.SQL.Text);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class procedure TGsSql.SqlDropIndex(AdoObject: TComponent; const ATableName: TGsSqlTableName;
  var AIndexDef: TGsSqlIndexDef);
resourcestring
  SErrorSqlDropIndex = 'Fehler beim Löschen des Index ''%s'' der Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
begin
  Query := GetQuery('SqlDropIndex', AdoObject, ReleaseQuery);

  try
    try
      with Query do
      begin
        with SQL do
        begin
          Clear;
          Add('DROP INDEX ' + GetSqlIndexName(AIndexDef.IndexType, ATableName, AIndexDef.Name));
          Add('ON ' + GetSqlObjectName(ATableName));
        end;

        ExecSQL;
      end;
    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorSqlDropIndex,
          [GetSqlIndexName(AIndexDef.IndexType, ATableName, AIndexDef.Name), ATableName, E.Message], Query.SQL.Text);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class procedure TGsSql.SqlDropTable(AdoObject: TComponent; const ATableName: TGsSqlTableName);
resourcestring
  SErrorSqlDropTable = 'Fehler beim Löschen der Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
begin
  Query := GetQuery('SqlDropTable', AdoObject, ReleaseQuery);

  try
    try
      with Query do
      begin
        with SQL do
        begin
          Clear;
          Add('DROP TABLE ' + GetSqlObjectName(ATableName));
        end;

        ExecSQL;
      end;
    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorSqlDropTable, [ATableName, E.Message], Query.SQL.Text);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class function TGsSql.TableExists(Connection: TADOConnection; const TableName: TGsSqlTableName): Boolean;
var
  Tables: TStrings;
begin
  try
    Tables := TStringList.Create;

    try
      Connection.GetTableNames(Tables);

      Result := (Tables.Count > 0) and (Tables.IndexOf(TableName) > -1);
    finally
      Tables.Free;
    end;
  except
    Result := False;
  end;
end;

class function TGsSql.TableRecordCount(Connection: TADOConnection; const TableName: TGsSqlTableName): Integer;
resourcestring
  SErrorTableRecordCount = 'Fehler beim Zählen der Datensätze der Tabelle ''%s'': %s';
var
  Query:        TADOQuery;
  ReleaseQuery: Boolean;
begin
  Result := -1;
  Query  := GetQuery('TableRecordCount', Connection, ReleaseQuery);

  try
    try
      with Query do
      begin
        with SQL do
        begin
          Clear;
          Add('SELECT COUNT(*) AS [Count]');
          Add('  FROM ' + GetSqlObjectName(TableName));
        end;

        Open;

        try
          Result := FieldByName('Count').AsInteger;
        finally
          Close;
        end;
      end;
    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorTableRecordCount, [TableName, E.Message], Query.SQL.Text);
    end;
  finally
    if ReleaseQuery then
      Query.Free;
  end;
end;

class function TGsSql.TableState(Connection: TADOConnection; const TableName: TGsSqlTableName): TGsSqlTableStates;
begin
  if TableExists(Connection, TableName) then
  begin
    if TableRecordCount(Connection, TableName) = 0 then
      Result := [tsExists, tsEmpty]
    else
      Result := [tsExists];
  end
  else
    Result := [];
end;

class procedure TGsSql.UpdateTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var FieldDefs: TGsSqlFieldDefs; var ConstraintDefs: TGsSqlConstraintDefs; var IndexDefs: TGsSqlIndexDefs;
  const EventProc: TGsSqlNotifyProc; var TableState: TGsSqlTableStates);

  procedure UpdateTableState(var TableState: TGsSqlTableStates);
  begin
    if TableRecordCount(Connection, TableName) = 0 then
      Include(TableState, tsEmpty)
    else
      Exclude(TableState, tsEmpty);
  end;

resourcestring
  SErrorUpdateTable = 'Fehler beim Aktualisieren der Tabelle ''%s'': Tabelle wurde nicht gefunden.';
begin
  if not (tsExists in TableState) then
    raise EGsAdoDbError.CreateResFmt(@SErrorUpdateTable, [TableName]);

  DoEvent(EventProc, neBeforeUpdateTable, TableName, FieldDefs, ConstraintDefs, IndexDefs, TableState);
  UpdateTableState(TableState);

  //DropAllIndexes(Connection, TableName);

  DropIndexes(Connection, TableName, IndexDefs);
  DropConstraints(Connection, TableName, ConstraintDefs);

  AddColumns(Connection, TableName, FieldDefs);
  AlterColumns(Connection, TableName, FieldDefs);
  DropColumns(Connection, TableName, FieldDefs);

  AddConstraints(Connection, TableName, ConstraintDefs);

  AddIndexes(Connection, TableName, IndexDefs);

  UpdateTableState(TableState);
  DoEvent(EventProc, neAfterUpdateTable, TableName, FieldDefs, ConstraintDefs, IndexDefs, TableState);
end;

class procedure TGsSql.UpdateTable(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var FieldDefs: TGsSqlFieldDefs; var ConstraintDefs: TGsSqlConstraintDefs; var IndexDefs: TGsSqlIndexDefs;
  const EventProc: TGsSqlNotifyProc);
var
  TableState: TGsSqlTableStates;
begin
  TableState := Self.TableState(Connection, TableName);
  UpdateTable(Connection, TableName, FieldDefs, ConstraintDefs, IndexDefs, EventProc, TableState);
end;



(*
class procedure TGsSql.AddIndexDefinitions(SQL: TStrings; const TableName: TGsSqlTableName;
  IndexDefs: TGsSqlIndexDefs; ForceAll: Boolean);
var
  C: Integer;
begin
  for C := Low(IndexDefs) to High(IndexDefs) do
    if (not IndexDefs[C].Exists and not IndexDefs[C].Drop) or ForceAll then
      SQL.Add(BPADO.SQLIndexName(TableName, IndexDefs[C].Name)
      BPADO.SQLColumnDefinition(IndexDefs[C].Name, GetIndexDefinition(TableName, IndexDefs[C])) + ',');

  SQL.Text := Copy(SQL.Text, 1, Length(SQL.Text) - 3);
end;

class function TGsSql.GetIndexDefinitions(const TableName: TGsSqlTableName; IndexDefs: TGsSqlIndexDefs;
  ForceAll: Boolean): string;
var
  SQL: TStrings;
begin
  SQL := TStringList.Create;

  try
    AddIndexDefinitions(SQL, TableName, IndexDefs, ForceAll);
    Result := SQL.Text;
  finally
    SQL.Free;
  end;
end;

class function TGsSql.AddIndex(var IndexDefs: TGsSqlIndexDefs; const AName: TGsSqlIndexName;
  const ADefinition: string): PGsSqlIndexDef;
var
  L: Integer;
  N: TGsSqlNewIndexDef;
begin
  L := Length(IndexDefs);
  SetLength(IndexDefs, L + 1);
  N.Create(IndexDefs[L]);
  N.IndexDef.Name := AName;
  Result          := N.Init(sitIndex);

  with Result^ do
  begin
    Name       := AName;
    Definition := ADefinition;
  end;
end;

class procedure TGsSql.AddColumnDefinitions(SQL: TStrings; const TableName: TGsSqlTableName;
  FieldDefs: TGsSqlFieldDefs; ForceAll: Boolean);
var
  C: Integer;
begin
  for C := Low(FieldDefs) to High(FieldDefs) do
    if (not FieldDefs[C].Exists and not FieldDefs[C].Drop) or ForceAll then
      SQL.Add(GetColumnDefinition(cdtCreateTable, TableName, FieldDefs[C], ForceAll) + ',');

  SQL.Text := Copy(SQL.Text, 1, Length(SQL.Text) - 3);
end;

class function TGsSql.GetColumnDefinitions(const TableName: TGsSqlTableName; FieldDefs: TGsSqlFieldDefs;
  ForceAll: Boolean): string;
var
  SQL: TStrings;
begin
  SQL := TStringList.Create;

  try
    AddColumnDefinitions(SQL, TableName, FieldDefs, ForceAll);
    Result := SQL.Text;
  finally
    SQL.Free;
  end;
end;

class procedure TGsSql.DropColumn(Connection: TADOConnection; const TableName: TGsSqlTableName;
  var FieldDef: TGsSqlFieldDef; Force: Boolean);
resourcestring
  SErrorDropColumn = 'Fehler beim Löschen der Spalte ''%s'' der Tabelle ''%s'': %s';
var
  lQuery: TADOQuery;
  lTable: TADOTable;
begin
  if not TableExists(Connection, TableName) or (not FieldDef.Drop and not Force) then
    Exit;

  FieldDef.Drop := True;

  if not FieldDef.Exists then
  begin
    lTable := TADOTable.Create(nil);

    try
      lTable.Connection := Connection;
      lTable.TableName  := TableName;
      lTable.Open;
      FieldDef.Exists := (lTable.FindField(FieldDef.Name) <> nil);
    finally
      lTable.Free;
    end;
  end;

  if not FieldDef.Exists then
    Exit;

  SqlAlterTableDropColumns();

  lQuery := TADOQuery.Create(nil);

  try
    lQuery.Connection := Connection;

    try
      with lQuery do
      begin
        SQL.Clear;
        SQL.Add(BPADO.SQLAlterTable(TableName));
        SQL.Add(BPADO.SQLDropColumn(FieldDef.Name));
        ExecSQL;
      end;

      FieldDef.Exists := False;
    except
      on E: Exception do
        raise EGsAdoDbSqlError.Create(@SErrorDropColumn, [FieldDef.Name, TableName, E.Message], lQuery.SQL.Text);
    end;
  finally
    lQuery.Free;
  end;
end;






ALTER TABLE dbo._ATestTable ADD CONSTRAINT
  DF__ATestTable_VarChar DEFAULT 'VarChar' FOR VarChar

ALTER TABLE [dbo].[_ATestTable] ADD  CONSTRAINT [DF__ATestTable_DateTimeDefault]  DEFAULT (getdate()) FOR [DateTimeDefault]


ALTER TABLE [dbo].[_ATestTable] ADD  CONSTRAINT [PK__ATestTable] PRIMARY KEY CLUSTERED
(
  [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE dbo._ATestTable ADD CONSTRAINT
  IX__ATestTable_VarChar UNIQUE NONCLUSTERED
  (
  VarChar
  ) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]



*)



end.

