unit TestGsSystem;

interface

uses
  GsSystem,
  GsSysUtils,
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  Vcl.Forms,
  TestFramework;

type
  TestTGsEnum = class(TTestCase)
  strict private
    //FGsEnum: TGsEnum;
    FItems: TStringList;
  private
  protected
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGetEnumInfo;
    procedure TestGetEnumInfoParamIsNil;
    procedure TestGetEnumInfoParamIsIllegalType;
    procedure TestGetEnumSymbolInfo;
    procedure TestGetEnumSymbolInfoParamIsNil;
    procedure TestGetEnumSymbolInfoParamIsOutOfRangeLow;
    procedure TestGetEnumSymbolInfoParamIsOutOfRangeHigh;
    procedure TestDefaultAssignItemsFunc;
    procedure TestDefaultAddItemFunc;

    procedure TestSymbolToInt;
    procedure TestIntToSymbol;
    procedure TestIntToSymbolParamIsOutOfRangeLow;
    procedure TestIntToSymbolParamIsOutOfRangeHigh;
    procedure TestAssignTo;
    procedure TestGetSelected;
  end;

implementation

uses
  TestFormRTLUnit;

type
  TTestEnum = (teUnknown, teFirst, teSecond, teThird, teFourth, teFifth, teSixth, teSeventh,
    teEighth, teNinth, teLast);

{$M+}
  TTestEnum2 = (te2Unknown = -5, te2First, te2Second, te2Third, te2Fourth, te2Fifth, te2Sixth, te2Seventh,
    te2Eighth, te2Ninth, te2Last);

resourcestring
  SUnknown = 'Unknown';
  SFirst   = 'First';
  SSecond  = 'Second';
  SThird   = 'Third';
  SFourth  = 'Fourth';
  SFifth   = 'Fifth';
  SSixth   = 'Sixth';
  SSeventh = 'Seventh';
  SEighth  = 'Eighth';
  SNinth   = 'Ninth';
  SLast    = 'Last';

(*
type
  TTestEnumDescriptors = array [TTestEnum] of TGsEnumDescriptor;
  TTestEnumDescriptorDynArray = array of TGsEnumDescriptor;
*)

const
  TEST_ENUM_DEFS: array [TTestEnum] of TGsEnumSymbolInfo = (
    (Caption: @SUnknown; IntValue: 0; Status: [sHidden]),
    (Caption: @SFirst; IntValue: 10),
    (Caption: @SSecond; IntValue: 9; Status: [sDefault]),
    (Caption: @SThird; IntValue: 8),
    (Caption: @SFourth; IntValue: 7),
    (Caption: @SFifth; IntValue: 6),
    (Caption: @SSixth; IntValue: 5),
    (Caption: @SSeventh; IntValue: 4),
    (Caption: @SEighth; IntValue: 3),
    (Caption: @SNinth; IntValue: 2),
    (Caption: @SLast; IntValue: 1; Status: [sHidden])
    );

  TEST_ENUM2_DEFS: array [TTestEnum2] of TGsEnumSymbolInfo = (
    (Caption: @SUnknown; IntValue: 0; Status: [sDefault, sHidden]),
    (Caption: @SFirst; IntValue: 10),
    (Caption: @SSecond; IntValue: 9),
    (Caption: @SThird; IntValue: 8),
    (Caption: @SFourth; IntValue: 7),
    (Caption: @SFifth; IntValue: 6),
    (Caption: @SSixth; IntValue: 5),
    (Caption: @SSeventh; IntValue: 4),
    (Caption: @SEighth; IntValue: 3),
    (Caption: @SNinth; IntValue: 2),
    (Caption: @SLast; IntValue: 1; Status: [sHidden])
    );

{ TestTGsEnum }

procedure TestTGsEnum.SetUp;
begin
  FItems    := TStringList.Create;
  Application.CreateForm(TTestFormRTL, TestFormRTL);
end;

procedure TestTGsEnum.TearDown;
begin
  TestFormRTL.Free;
  FItems.Free;
end;

procedure TestTGsEnum.TestAssignTo;
var
  Count: Integer;
  S:     TTestEnum;
begin
  Count := 0;

  for S := Low(S) to High(S) do
    if not (sHidden in TGsEnum.GetEnumSymbolInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(S)).Status) then
      Inc(Count);

  TGsEnum.AssignTo(TestFormRTL.ComboBox1, TypeInfo(TTestEnum), TEST_ENUM_DEFS);
  CheckEquals(Count, TestFormRTL.ComboBox1.Items.Count);
  CheckEquals(-1, TestFormRTL.ComboBox1.ItemIndex);

  TGsEnum.AssignTo(TestFormRTL.RzComboBox1, TypeInfo(TTestEnum), TEST_ENUM_DEFS);
  CheckEquals(Count, TestFormRTL.RzComboBox1.Items.Count);
  CheckEquals(-1, TestFormRTL.RzComboBox1.ItemIndex);

  TGsEnum.AssignTo(TestFormRTL.RadioGroup1, TypeInfo(TTestEnum), TEST_ENUM_DEFS);
  CheckEquals(Count, TestFormRTL.RadioGroup1.Items.Count);
  CheckEquals(-1, TestFormRTL.RadioGroup1.ItemIndex);

  TGsEnum.AssignTo(TestFormRTL.RzRadioGroup1, TypeInfo(TTestEnum), TEST_ENUM_DEFS);
  CheckEquals(Count, TestFormRTL.RzRadioGroup1.Items.Count);
  CheckEquals(-1, TestFormRTL.RzRadioGroup1.ItemIndex);

  (*
  TGsEnum.AssignTo(TestFormRTL.ListBox1, TypeInfo(TTestEnum), TEST_ENUM_DEFS);
  CheckEquals(Count, TestFormRTL.ListBox1.Items.Count);

  TGsEnum.AssignTo(TestFormRTL.RzListBox1, TypeInfo(TTestEnum), TEST_ENUM_DEFS);
  CheckEquals(Count, TestFormRTL.RzListBox1.Items.Count);
  *)

  Count := -1;

  for S := Low(S) to High(S) do
  begin
    if not (sHidden in TGsEnum.GetEnumSymbolInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(S)).Status) then
      Inc(Count);

    TGsEnum.AssignTo(TestFormRTL.ComboBox1, TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(S));

    if (sHidden in TGsEnum.GetEnumSymbolInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(S)).Status) then
      CheckEquals(-1, TestFormRTL.ComboBox1.ItemIndex, GetEnumName(TypeInfo(TTestEnum), Ord(S)))
    else
      CheckEquals(Count, TestFormRTL.ComboBox1.ItemIndex, GetEnumName(TypeInfo(TTestEnum), Ord(S)));
  end;
end;

procedure TestTGsEnum.TestDefaultAddItemFunc;
var
  S:         TTestEnum;
  I:         TGsEnumSymbolInfo;
  OldCount:  Integer;
  ItemAdded: Boolean;
begin
  CheckTrue(True);
  (*
  FItems.Clear;

  for S := Low(S) to High(S) do
  begin
    I         := TGsEnum.GetEnumSymbolInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(S));
    OldCount  := FItems.Count;
    ItemAdded := TGsEnum.DefaultAddItemProc(FItems, Ord(S), I);

    CheckEquals(not (sHidden in I.Status), ItemAdded);

    if ItemAdded then
    begin
      CheckEquals(OldCount + 1, FItems.Count);
      CheckEquals(LoadResString(TEST_ENUM_DEFS[S].Caption), FItems.Strings[FItems.Count - 1], 'Strings');
      CheckEquals(Ord(S), Integer(FItems.Objects[FItems.Count - 1]), 'Objects');
    end
    else
      CheckEquals(OldCount, FItems.Count);
  end;
  *)
end;

procedure TestTGsEnum.TestDefaultAssignItemsFunc;
var
  I: TGsEnumInfo;
  S: TTestEnum;
begin
  CheckTrue(True);
  (*
  I := TGsEnum.GetEnumInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS);
  for S := Low(S) to High(S) do
  begin
    if (sHidden in TGsEnum.GetEnumSymbolInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(S)).Status) then
      CheckEquals(-1, TGsEnum.DefaultAssignItemsFunc(I, FItems, Ord(S)))
    else
      CheckEquals(Ord(S), TGsEnum.DefaultAssignItemsFunc(I, FItems, Ord(S)));
  end;
  *)
end;

procedure TestTGsEnum.TestGetEnumInfo;
var
  I: TGsEnumInfo;
begin
  I := TGsEnum.GetEnumInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS);
  Check(TypeInfo(TTestEnum) = I.TypeInfo, 'TypeInfo');
  Check(@TEST_ENUM_DEFS = I.Descriptors, 'Descriptors');

  (*
  Info := EnumDescriptorInfo(TypeInfo(TTestEnum2), TEST_ENUM2_DEFS);
  Check(TypeInfo(TTestEnum2) = Info.TypeInfo, 'TypeInfo');
  Check(@TEST_ENUM2_DEFS = Info.Descriptors, 'Descriptors');
  *)
end;

procedure TestTGsEnum.TestGetEnumInfoParamIsIllegalType;
begin
  StartExpectingException(EGsArgumentOutOfRangeException);
  TGsEnum.GetEnumInfo(TypeInfo(Integer), TEST_ENUM_DEFS);
end;

procedure TestTGsEnum.TestGetEnumInfoParamIsNil;
begin
  StartExpectingException(EGsArgumentNilException);
  TGsEnum.GetEnumInfo(nil, TEST_ENUM_DEFS);
end;

procedure TestTGsEnum.TestGetEnumSymbolInfo;
var
  I: TGsEnumSymbolInfo;
  S: TTestEnum;
begin
  for S := Low(S) to High(S) do
  begin
    I := TGsEnum.GetEnumSymbolInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(S));
    Check(TEST_ENUM_DEFS[S].Caption = I.Caption, 'Caption');
    CheckEquals(TEST_ENUM_DEFS[S].IntValue, I.IntValue, 'IntValue');
    Check(TEST_ENUM_DEFS[S].Status = I.Status, 'Status');
  end;
end;

procedure TestTGsEnum.TestGetEnumSymbolInfoParamIsNil;
begin
  StartExpectingException(EGsArgumentNilException);
  TGsEnum.GetEnumSymbolInfo(nil, TEST_ENUM_DEFS, Ord(Low(TTestEnum)));
end;

procedure TestTGsEnum.TestGetEnumSymbolInfoParamIsOutOfRangeHigh;
begin
  StartExpectingException(EGsArgumentOutOfRangeException);
  TGsEnum.GetEnumSymbolInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(Low(TTestEnum)) - 1);
end;

procedure TestTGsEnum.TestGetEnumSymbolInfoParamIsOutOfRangeLow;
begin
  StartExpectingException(EGsArgumentOutOfRangeException);
  TGsEnum.GetEnumSymbolInfo(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(High(TTestEnum)) + 1);
end;

procedure TestTGsEnum.TestGetSelected;
var
  S: TTestEnum;
begin
  for S := Low(S) to High(S) do
  begin
    TGsEnum.AssignTo(TestFormRTL.ComboBox1, TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(S));
  end;
end;

procedure TestTGsEnum.TestIntToSymbol;
var
  S: TTestEnum;
begin
  for S := Low(S) to High(S) do
    CheckEquals(Ord(S), TGsEnum.IntToSymbol(TypeInfo(TTestEnum), TEST_ENUM_DEFS, TEST_ENUM_DEFS[S].IntValue));
end;

procedure TestTGsEnum.TestIntToSymbolParamIsOutOfRangeHigh;
begin
  CheckEquals(2, TGsEnum.IntToSymbol(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(High(TTestEnum)) + 1));
end;

procedure TestTGsEnum.TestIntToSymbolParamIsOutOfRangeLow;
begin
  CheckEquals(2, TGsEnum.IntToSymbol(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(Low(TTestEnum)) - 1));
end;

procedure TestTGsEnum.TestSymbolToInt;
var
  S: TTestEnum;
begin
  for S := Low(S) to High(S) do
    CheckEquals(TEST_ENUM_DEFS[S].IntValue, TGsEnum.SymbolToInt(TypeInfo(TTestEnum), TEST_ENUM_DEFS, Ord(S)));
end;

initialization
  RegisterTest(TestTGsEnum.Suite);
end.

