unit GsDB;

interface

uses
  Classes,
  SysUtils,
  System.Generics.Collections;

type
  TGsSqlTable = class(TCollectionItem)
  private
  protected
  public
  end;

  TGsSqlTables<TGsSqlTable> = class(TCollection);

  TGsSqlField = class(TCollectionItem)
  private
  protected
  public
  end;

  TGsSqlFields<TGsSqlField> = class(TCollection);

  TGsSqlCondition = class(TCollectionItem)
  private
  protected
  public
  end;

  TGsSqlConditions<TGsSqlCondition> = class(TCollection);

  TGsSqlBuilder = class
  private
    FSqlStr: TStringBuilder;
    (*
    function GetCapacity: Integer;
    function GetLength: Integer;
    function GetMaxCapacity: Integer;
    procedure SetCapacity(const Value: Integer);
    procedure SetLength(const Value: Integer);
    *)
  protected
  public
    constructor Create; overload;
    //constructor Create(aCapacity: Integer); overload;
    //constructor Create(const Value: string); overload;
    //constructor Create(aCapacity: Integer; aMaxCapacity: Integer); overload;
    //constructor Create(const Value: string; aCapacity: Integer); overload;
    //constructor Create(const Value: string; StartIndex: Integer; Length: Integer; aCapacity: Integer); overload;
    destructor Destroy; override;

    (*
    procedure AddField(const FieldName: string); overload;
    procedure AddField(const FieldName, Alias: string); overload;
    procedure AddField(const TabbleName, FieldName, Alias: string); overload;

    function GetInsert: string;
    function GetSelect: string;
    function GetUpdate: string;
    function GetDelete: string;
    *)


    //function Append(const Value: Boolean): TStringBuilder; overload;
    //function Append(const Value: Byte): TStringBuilder; overload;

    //function ToString: string; overload; override;
    //function ToString(StartIndex: Integer; StrLength: Integer): string; reintroduce; overload;

    //property Capacity: Integer read GetCapacity write SetCapacity;
    //property Chars[index: Integer]: Char read GetChars write SetChars; default;
    //property Length: Integer read GetLength write SetLength;
    //property MaxCapacity: Integer read GetMaxCapacity;
  end;

implementation

{ TGsSqlBuilder }

constructor TGsSqlBuilder.Create;
begin
  inherited;

  FSqlStr := TStringBuilder.Create(1024);
end;

destructor TGsSqlBuilder.Destroy;
begin
  FSqlStr.Free;

  inherited;
end;

end.

function TGsSqlBuilder.GetCapacity: Integer;
begin
  Result := FSqlStr.Capacity;
end;

function TGsSqlBuilder.GetLength: Integer;
begin
  Result := FSqlStr.Length;
end;

function TGsSqlBuilder.GetMaxCapacity: Integer;
begin
  Result := FSqlStr.MaxCapacity;
end;

procedure TGsSqlBuilder.SetCapacity(const Value: Integer);
begin
  FSqlStr.Capacity := Value;
end;

procedure TGsSqlBuilder.SetLength(const Value: Integer);
begin
  FSqlStr.Length := Value;
end;

function TGsSqlBuilder.ToString: string;
begin
  Result := FSqlStr.ToString;
end;

