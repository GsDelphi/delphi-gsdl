unit TestGsTemplateProcessor;

{

  Delphi DUnit-Testfall
  ----------------------
  Diese Unit enthält ein Skeleton einer Testfallklasse, das vom Experten für Testfälle erzeugt wurde.
  Ändern Sie den erzeugten Code so, dass er die Methoden korrekt einrichtet und aus der
  getesteten Unit aufruft.

}

interface

uses
  GsTemplateProcessor,
  SysUtils,
  TestFramework,
  TypInfo;

type
  // Testmethoden für Klasse TGsTemplateProcessor

  TestTGsTemplateProcessor = class(TTestCase)
  strict private
    //FGsTemplateProcessor: TGsTemplateProcessor;
    FProperties: TObject;
  protected
    procedure DoTest(Expected, Template: string);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestProcess;
    procedure TestProcessException;
    procedure TestProcessFormat;
    procedure TestProcessMulti;
    procedure TestProcessRanges;
    procedure TestExtractMarkers;
  end;

implementation

uses
  Classes,
  Math;

type
  TTestEnum = (
    e00, e01, e02, e03, e04, e05, e06, e07, e08, e09, e0a, e0b, e0c, e0d, e0e, e0f,
    e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e1a, e1b, e1c, e1d, e1e, e1f,
    e20, e21, e22, e23, e24, e25, e26, e27, e28, e29, e2a, e2b, e2c, e2d, e2e, e2f,
    e30, e31, e32, e33, e34, e35, e36, e37, e38, e39, e3a, e3b, e3c, e3d, e3e, e3f,
    e40, e41, e42, e43, e44, e45, e46, e47, e48, e49, e4a, e4b, e4c, e4d, e4e, e4f,
    e50, e51, e52, e53, e54, e55, e56, e57, e58, e59, e5a, e5b, e5c, e5d, e5e, e5f,
    e60, e61, e62, e63, e64, e65, e66, e67, e68, e69, e6a, e6b, e6c, e6d, e6e, e6f,
    e70, e71, e72, e73, e74, e75, e76, e77, e78, e79, e7a, e7b, e7c, e7d, e7e, e7f,
    e80, e81, e82, e83, e84, e85, e86, e87, e88, e89, e8a, e8b, e8c, e8d, e8e, e8f,
    e90, e91, e92, e93, e94, e95, e96, e97, e98, e99, e9a, e9b, e9c, e9d, e9e, e9f,
    ea0, ea1, ea2, ea3, ea4, ea5, ea6, ea7, ea8, ea9, eaa, eab, eac, ead, eae, eaf,
    eb0, eb1, eb2, eb3, eb4, eb5, eb6, eb7, eb8, eb9, eba, ebb, ebc, ebd, ebe, ebf,
    ec0, ec1, ec2, ec3, ec4, ec5, ec6, ec7, ec8, ec9, eca, ecb, ecc, ecd, ece, ecf,
    ed0, ed1, ed2, ed3, ed4, ed5, ed6, ed7, ed8, ed9, eda, edb, edc, edd, ede, edf,
    ee0, ee1, ee2, ee3, ee4, ee5, ee6, ee7, ee8, ee9, eea, eeb, eec, eed, eee, eef,
    ef0, ef1, ef2, ef3, ef4, ef5, ef6, ef7, ef8, ef9, efa, efb, efc, efd, efe, eff
    );

  TTestProperties = class(TPersistent)
  private
    FTestDate:  TDate;
    FTestDouble: Double;
    FTestComp:  Comp;
    FTestUInt32: UInt32;
    FTestUInt8: UInt8;
    FTestInt32: Int32;
    FTestTime:  TTime;
    FTestInt8:  Int8;
    FTestDateTime: TDateTime;
    FTestExtended: Extended;
    FTestUInt16: UInt16;
    FTestString1: string;
    FTestInt16: Int16;
    FTestUInt64: UInt64;
    FTestInt64: Int64;
    FTestInteger1: Integer;
    FTestSingle: Single;
    FTestByte1: Byte;
    FTestAnsiString1: AnsiString;
    FTestCurrency: Currency;
    FUnicodeString1: UnicodeString;
    FVariant1: Variant;
    FShortString1: ShortString;
    FAnsiChar1: AnsiChar;
    FWideString1: WideString;
    FWideChar1: WideChar;
    FAnsiString1: AnsiString;
  published
    { Enum tests }
    (*
    property TestBoolean: Boolean read FTestBoolean write FTestBoolean;
    property TestByteBool: ByteBool read FTestByteBool write FTestByteBool;
    property TestWordBool: WordBool read FTestWordBool write FTestWordBool;
    property TestLongBool: LongBool read FTestLongBool write FTestLongBool;
    property TestEnum: TTestEnum read FTestEnum write FTestEnum;
    *)

    { Integer tests }
    property TestInt8: Int8 read FTestInt8 write FTestInt8;
    property TestInt16: Int16 read FTestInt16 write FTestInt16;
    property TestInt32: Int32 read FTestInt32 write FTestInt32;
    property TestInt64: Int64 read FTestInt64 write FTestInt64;
    property TestUInt8: UInt8 read FTestUInt8 write FTestUInt8;
    property TestUInt16: UInt16 read FTestUInt16 write FTestUInt16;
    property TestUInt32: UInt32 read FTestUInt32 write FTestUInt32;
    property TestUInt64: UInt64 read FTestUInt64 write FTestUInt64;

    { Float tests }
    property TestSingle: Single read FTestSingle write FTestSingle;
    property TestDouble: Double read FTestDouble write FTestDouble;
    property TestExtended: Extended read FTestExtended write FTestExtended;
    property TestComp: Comp read FTestComp write FTestComp;
    property TestCurrency: Currency read FTestCurrency write FTestCurrency;

    property TestDateTime: TDateTime read FTestDateTime write FTestDateTime;
    property TestDate: TDate read FTestDate write FTestDate;
    property TestTime: TTime read FTestTime write FTestTime;

    { String tests }
    property TestString1: string read FTestString1 write FTestString1;
    property TestAnsiString1: AnsiString read FTestAnsiString1 write FTestAnsiString1;

    //property Test: Boolean read F write F;

    property TestByte1: Byte read FTestByte1 write FTestByte1;
    property TestInteger1: Integer read FTestInteger1 write FTestInteger1;

    property AnsiChar1: AnsiChar read FAnsiChar1;
    property WideChar1: WideChar read FWideChar1;
    property ShortString1: ShortString read FShortString1;
    property AnsiString1: AnsiString read FAnsiString1;
    property WideString1: WideString read FWideString1;
    property UnicodeString1: UnicodeString read FUnicodeString1;
    property Variant1: Variant read FVariant1;
  end;

  TTestMarkersObj2 = class(TPersistent)
  private
    FValue3: Integer;
  published
    property Value3: Integer read FValue3;
  end;

  TTestMarkersObj1 = class(TPersistent)
  private
    FValue2:  Integer;
    FObject2: TTestMarkersObj2;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Value2: Integer read FValue2;
    property Object2: TTestMarkersObj2 read FObject2;
  end;

  TTestMarkers = class(TPersistent)
  private
    FValue1:  Integer;
    FObject1: TTestMarkersObj1;
    FUnicodeString1: UnicodeString;
    FVariant1: Variant;
    FShortString1: ShortString;
    FAnsiChar1: AnsiChar;
    FWideString1: WideString;
    FWideChar1: WideChar;
    FAnsiString1: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Value1: Integer read FValue1;
    property Object1: TTestMarkersObj1 read FObject1;

    property AnsiChar1: AnsiChar read FAnsiChar1;
    property WideChar1: WideChar read FWideChar1;
    property ShortString1: ShortString read FShortString1;
    property AnsiString1: AnsiString read FAnsiString1;
    property WideString1: WideString read FWideString1;
    property UnicodeString1: UnicodeString read FUnicodeString1;
    property Variant1: Variant read FVariant1;
  end;

{ TTestMarkersObj1 }

constructor TTestMarkersObj1.Create;
begin
  inherited Create;

  FValue2  := 145;
  FObject2 := TTestMarkersObj2.Create;
end;

destructor TTestMarkersObj1.Destroy;
begin
  FObject2.Free;

  inherited;
end;

{ TTestMarkers }

constructor TTestMarkers.Create;
begin
  inherited Create;

  FValue1  := 133;
  FObject1 := TTestMarkersObj1.Create;
end;

destructor TTestMarkers.Destroy;
begin
  FObject1.Free;

  inherited;
end;

{ TestTGsTemplateProcessor }

procedure TestTGsTemplateProcessor.DoTest(Expected, Template: string);
begin
  CheckEqualsString(Expected, TGsTemplateProcessor.Process(Template, FProperties));
end;

procedure TestTGsTemplateProcessor.SetUp;
begin
  Randomize;

  //FGsTemplateProcessor := TGsTemplateProcessor.Create;
  FProperties := TTestProperties.Create;

  with TTestProperties(FProperties) do
  begin
    TestString1  := 'Abcdefg Hijklmnop';
    TestInteger1 := 1234567890;

    TestDateTime := Now;
    TestDate := TestDateTime;
    TestTime := TestDateTime;
  end;
end;

procedure TestTGsTemplateProcessor.TearDown;
begin
  FProperties.Free;
  FProperties := nil;

  //FGsTemplateProcessor.Free;
  //FGsTemplateProcessor := nil;
end;

procedure TestTGsTemplateProcessor.TestExtractMarkers;
var
  Strs: TStrings;
  Obj:  TTestMarkers;
begin
  Obj := TTestMarkers.Create;

  try
    Strs := TGsTemplateProcessor.ExtractMarkers(Obj);

    try
      CheckNotNull(Strs);
      CheckEqualsString(
        '"%Value1% | %Value1(Format)%","%Object1.Value2% | %Object1.Value2(Format)%","%Object1.Object2.Value3% | %Object1.Object2.Value3(Format)%",%AnsiChar1%,%WideChar1%,%ShortString1%,%AnsiString1%,%WideString1%,%UnicodeString1%,%Variant1%',
        Strs.CommaText);
    finally
      Strs.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure TestTGsTemplateProcessor.TestProcess;
var
  ReturnValue: string;
  Template: string;
begin
  Template :=
    '%TestString1%%TestInteger1%%TestDateTime%%TestDate%%TestTime%%TestDateTime(YYMMDD)%';

  ReturnValue := TGsTemplateProcessor.Process(Template, FProperties);

  with TTestProperties(FProperties) do
  begin
    CheckEqualsString(TestString1 + IntToStr(TestInteger1) +
      DateTimeToStr(TestDateTime) + DateToStr(TestDate) +
      TimeToStr(TestTime) + FormatDateTime('YYMMDD', TestDateTime),
      ReturnValue);
  end;
end;

procedure TestTGsTemplateProcessor.TestProcessException;
begin
  StartExpectingException(Exception);
  TGsTemplateProcessor.Process('%TestDateTime(YYMMDD)', FProperties);
  StopExpectingException;
end;

procedure TestTGsTemplateProcessor.TestProcessFormat;

  procedure IntTest;
  begin
    DoTest(IntToHex(TTestProperties(FProperties).TestInt8, 8), '%TestInt8(8)%');
    DoTest(IntToHex(TTestProperties(FProperties).TestInt16, 8), '%TestInt16(8)%');
    DoTest(IntToHex(TTestProperties(FProperties).TestInt32, 8), '%TestInt32(8)%');
    DoTest(IntToHex(TTestProperties(FProperties).TestInt64, 8), '%TestInt64(8)%');
    DoTest(IntToHex(TTestProperties(FProperties).TestUInt8, 8), '%TestUInt8(8)%');
    DoTest(IntToHex(TTestProperties(FProperties).TestUInt16, 8), '%TestUInt16(8)%');
    DoTest(IntToHex(TTestProperties(FProperties).TestUInt32, 8), '%TestUInt32(8)%');
    DoTest(IntToHex(TTestProperties(FProperties).TestUInt64, 8), '%TestUInt64(8)%');
    DoTest(FormatCurr('###,##0.00', TTestProperties(FProperties).TestCurrency), '%TestCurrency(###,##0.00)%');
  end;

begin
  with TTestProperties(FProperties) do
  begin
    TestInt8  := Random(Trunc(IntPower(2, SizeOf(TestInt8)) - 1));
    TestInt16 := Random(Trunc(IntPower(2, SizeOf(TestInt16)) - 1));
    TestInt32 := Random(Trunc(IntPower(2, SizeOf(TestInt32)) - 1));
    TestInt64 := Random(Trunc(IntPower(2, SizeOf(TestInt64)) - 1));
    TestUInt8 := Random(Trunc(IntPower(2, SizeOf(TestUInt8)) - 1));
    TestUInt16 := Random(Trunc(IntPower(2, SizeOf(TestUInt16)) - 1));
    TestUInt32 := Random(Trunc(IntPower(2, SizeOf(TestUInt32)) - 1));
    TestUInt64 := Random(Trunc(IntPower(2, SizeOf(TestUInt64)) - 1));
    TestCurrency := 1234.5678;
  end;

  IntTest;
end;

procedure TestTGsTemplateProcessor.TestProcessMulti;
var
  ReturnValue: string;
  Template: string;
begin
  Template := '%TestString1%' + '%TestString1%' + '%TestString1%';

  ReturnValue := TGsTemplateProcessor.Process(Template, FProperties);

  with TTestProperties(FProperties) do
  begin
    CheckEqualsString(TestString1 + TestString1 + TestString1, ReturnValue);
  end;
end;

procedure TestTGsTemplateProcessor.TestProcessRanges;

  procedure IntTest;
  begin
    DoTest(IntToStr(TTestProperties(FProperties).TestInt8), '%TestInt8%');
    DoTest(IntToStr(TTestProperties(FProperties).TestInt16), '%TestInt16%');
    DoTest(IntToStr(TTestProperties(FProperties).TestInt32), '%TestInt32%');
    DoTest(IntToStr(TTestProperties(FProperties).TestInt64), '%TestInt64%');
    DoTest(UIntToStr(TTestProperties(FProperties).TestUInt8), '%TestUInt8%');
    DoTest(UIntToStr(TTestProperties(FProperties).TestUInt16), '%TestUInt16%');
    DoTest(UIntToStr(TTestProperties(FProperties).TestUInt32), '%TestUInt32%');
    DoTest(UIntToStr(TTestProperties(FProperties).TestUInt64), '%TestUInt64%');
  end;

begin
  with TTestProperties(FProperties) do
  begin
    TestInt8  := Low(TestInt8);
    TestInt16 := Low(TestInt16);
    TestInt32 := Low(TestInt32);
    TestInt64 := Low(TestInt64);
    TestUInt8 := Low(TestUInt8);
    TestUInt16 := Low(TestUInt16);
    TestUInt32 := Low(TestUInt32);
    TestUInt64 := Low(TestUInt64);
  end;

  IntTest;


  with TTestProperties(FProperties) do
  begin
    TestInt8  := High(TestInt8);
    TestInt16 := High(TestInt16);
    TestInt32 := High(TestInt32);
    TestInt64 := High(TestInt64);
    TestUInt8 := High(TestUInt8);
    TestUInt16 := High(TestUInt16);
    TestUInt32 := High(TestUInt32);
    TestUInt64 := High(TestUInt64);
  end;

  IntTest;
end;

initialization
  // Alle Testfälle beim Testprogramm registrieren
  RegisterTest(TestTGsTemplateProcessor.Suite);
end.

