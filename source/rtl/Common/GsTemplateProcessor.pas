unit GsTemplateProcessor;

interface

uses
  TypInfo;

type
  TGsTemplateProcessor = class
  private
  protected
    class function GetMarker(const AName: TSymbolName): string; dynamic;
    class function GetPMarkerStart(const AName: TSymbolName): string; dynamic;
    class function GetPMarkerEnd: string; dynamic;

    class function GetPropValue(Instance: TObject; PropInfo: PPropInfo;
      const Format: string = ''): string; dynamic;

    class function ProcessMarker(const Template: string; Instance: TObject;
      PropInfo: PPropInfo): string; dynamic;
    class function ProcessPMarker(const Template: string; Instance: TObject;
      PropInfo: PPropInfo): string; dynamic;
  public
    class function Process(const Template: string; Properties: TObject): string;
  end;

(*
resourcestring
  STemplateProcessorFormat = '';

  STemplateProcessorFormatInteger = '';
Der Parameter Digits legt die Mindestanzahl der zurückgegebenen Hexadezimalstellen fest.

  STemplateProcessorFormatFloat =
'0  Platzhalter für Ziffern. Wenn der formatierte Wert an der Stelle eine Ziffer enthält, an der im Format-String das Zeichen 0 (Null) steht, wird die betreffende Ziffer in den Ausgabe-String übernommen. Andernfalls wird das Zeichen 0 an dieser Position im Ausgabe-String gespeichert.' + sLineBreak +
'#  Platzhalter für Ziffern. Wenn der formatierte Wert an der Stelle eine Ziffer enthält, an der im Format-String das Zeichen # steht, dann wird diese Ziffer in den Ausgabe-String übernommen. Andernfalls wird an dieser Position kein Zeichen im Ausgabe-String gespeichert.' + sLineBreak +
'.  Dezimalzeichen. Das erste ''.''-Zeichen im Format-String bestimmt die Position des Dezimalzeichens im formatierten Wert. Alle weiteren dieser Zeichen werden ignoriert. Das tatsächlich im Ausgabe-String verwendete Zeichen wird mit der globalen Variable DecimalSeparator bzw. ihrer TFormatSettings-Entsprechung festgelegt.' + sLineBreak +
',  Tausendertrennzeichen. Enthält der Format-String ein oder mehrere '',''-Zeichen, werden in den Ausgabe-String links des Dezimalzeichens nach jeder Gruppe von drei Ziffern Tausendertrennzeichen eingefügt. Die Position und Anzahl der ','-Trennzeichen im Format-String wirkt sich nicht auf die Ausgabe aus. Sie geben nur an, dass Trennzeichen eingefügt werden sollen. Das tatsächlich im Ausgabe-String verwendete Tausendertrennzeichen wird mit der globalen Variable ThousandSeparator bzw. ihrer TFormatSettings-Entsprechung festgelegt.' + sLineBreak +
'E+  Wissenschaftliche Notation. Sind die Zeichen ''E+'', ''E-'', ''e+'' oder ''e-'' im Format-String enthalten, wird die Zahl in der wissenschaftlichen Schreibweise formatiert. Bis zu vier '0'-Zeichen können direkt nach 'E+', 'E-', 'e+' oder 'e-' angegeben werden, um die minimale Anzahl der Stellen im Exponenten festzulegen. Bei den Formaten 'E+' und 'e+' wird für positive Exponenten ein Pluszeichen und für negative Exponenten ein Minuszeichen in den String eingefügt. Bei den Formaten ''E-'' und ''e-'' wird lediglich für negative Exponenten ein Vorzeichen ausgegeben.' + sLineBreak +
'''xx''/"xx"  In halbe oder ganze Anführungszeichen eingeschlossene Zeichen wirken sich nicht auf die Formatierung aus und werden wie eingegeben angezeigt.' + sLineBreak +
';  Trennt Abschnitte für positive, negative und Nullwerte im Format-String.';

  STemplateProcessorFormatDateTime = '';
c
 Zeigt das Datum in dem in der globalen Variablen ShortDateFormat angegebenen Format an. Dahinter wird die Uhrzeit, in dem in der globalen Variablen LongTimeFormat festgelegten Format dargestellt. Die Uhrzeit erscheint nicht, wenn der Datums-/Zeitwert exakt Mitternacht ergibt.

d
 Zeigt den Tag als Zahl ohne führende Null an (1-31).

dd
 Zeigt den Tag als Zahl mit führender Null an (01-31).

ddd
 Zeigt den Wochentag als Abkürzung (Son-Sam) in den in der globalen Variablen ShortDayNames festgelegten Strings an.

dddd
 Zeigt den ausgeschriebenen Wochentag (Sonntag-Samstag) in den in der globalen Variablen LongDayNames festgelegten Strings an.

ddddd
 Zeigt das Datum in dem in der globalen Variablen ShortDateFormat angegebenen Format an.

dddddd
 Zeigt das Datum in dem in der globalen Variablen LongDateFormat angegebenen Format an.

e
 (Nur Windows) Zeigt das Jahr in der aktuellen Datums-/Zeitangabe als Zahl ohne führende Null an (gilt nur für die japanische, koreanische und taiwanesische Ländereinstellung).

ee
 (Nur Windows) Zeigt das Jahr in der aktuellen Datums-/Zeitangabe als Zahl mit führender Null an (gilt nur für die japanische, koreanische und taiwanesische Ländereinstellung).

g
 (Nur Windows) Zeigt die Datums-/Zeitangabe als Abkürzung an (gilt nur für die japanische und taiwanesische Ländereinstellung).

gg
 (Nur Windows) Zeigt die Datums-/Zeitangabe in ausgeschriebener Form an (gilt nur für die japanische und taiwanesische Ländereinstellung).

m
 Zeigt den Monat als Zahl ohne führende Null an (1-12). Wenn auf den Bezeichner m unmittelbar der Bezeichner h oder hh folgt, werden an Stelle des Monats die Minuten angezeigt.

mm
 Zeigt den Monat als Zahl mit führender Null an (01-12). Wenn auf den Bezeichner mm unmittelbar der Bezeichner h oder hh folgt, werden an Stelle des Monats die Minuten angezeigt.

mmm
 Zeigt den Monatsnamen als Abkürzung (Jan-Dez) in den in der globalen Variablen ShortMonthNames festgelegten Strings an.

mmmm
 Zeigt den ausgeschriebenen Monatsnamen (Januar-Dezember) in den in der globalen Variablen LongMonthNames festgelegten Strings an.

yy
 Zeigt das Jahr als zweistellige Zahl an (00-99).

yyyy
 Zeigt das Jahr als vierstellige Zahl an (0000-9999).

h
 Zeigt die Stunde ohne führende Null an (0-23).

hh
 Zeigt die Stunde mit führender Null an (00-23).

n
 Zeigt die Minute ohne führende Null an (0-59).

nn
 Zeigt die Minute mit führender Null an (00-59).

s
 Zeigt die Sekunde ohne führende Null an (0-59).

ss
 Zeigt die Sekunde mit führender Null an (00-59).

z
 Zeigt die Millisekunde ohne führende Null an (0-999).

zzz
 Zeigt die Millisekunde mit führender Null an (000-999).

t
 Zeigt die Uhrzeit in dem in der globalen Variablen ShortTimeFormat angegebenen Format an.

tt\
 Zeigt die Uhrzeit in dem in der globalen Variablen LongTimeFormat angegebenen Format an.

am/pm
 Verwendet die 12-Stunden-Zeitanzeige für den vorhergehenden Bezeichner h oder hh und zeigt alle Stunden vor Mittag mit dem String 'am' und alle Stunden nach Mittag mit dem String 'pm' an. Der Bezeichner am/pm kann in Großbuchstaben, in Kleinbuchstaben oder in gemischter Schreibweise eingegeben werden. Die Ausgabe wird entsprechend angepasst.

a/p
 Verwendet die 12-Stunden-Zeitanzeige für den vorhergehenden Bezeichner h oder hh und zeigt alle Stunden vor Mittag mit dem Zeichen 'a' und alle Stunden nach Mittag mit dem Zeichen 'p' an. Der Bezeichner a/p kann in Großbuchstaben, in Kleinbuchstaben oder in gemischter Schreibweise eingegeben werden. Die Ausgabe wird entsprechend angepasst.

ampm
 Verwendet die 12-Stunden-Zeitanzeige für den vorhergehenden Bezeichner h oder hh und zeigt alle Stunden vor Mittag mit dem String aus der globalen Variablen TimeAMString und alle Stunden nach Mittag mit dem String aus der globalen Variable TimePMString an.

/
 Zeigt als Datumstrennzeichen das in der globalen Variablen DateSeparator angegebene Zeichen an.

 Zeigt als Uhrzeittrennzeichen das in der globalen Variablen TimeSeparator angegebene Zeichen an.

'xx'/"xx"
 In halbe oder ganze Anführungszeichen eingeschlossene Zeichen wirken sich nicht auf die Formatierung aus und werden wie eingegeben angezeigt.


  STemplateProcessorFormatCurrency = '';
See FormatFloat

*)

implementation

uses
  AnsiStrings,
  RTLConsts,
  SysUtils,
  Variants;

resourcestring
  SErrorEndMarkerNotFound = 'End marker not found!';

{ TGsTemplateProcessor }

class function TGsTemplateProcessor.GetMarker(const AName: TSymbolName): string;
begin
  Result := '%' + String(AnsiStrings.UpperCase(AName)) + '%';
end;

class function TGsTemplateProcessor.GetPMarkerEnd: string;
begin
  Result := ')%';
end;

class function TGsTemplateProcessor.GetPMarkerStart(const AName: TSymbolName): string;
begin
  Result := '%' + String(AnsiStrings.UpperCase(AName)) + '(';
end;

class function TGsTemplateProcessor.GetPropValue(Instance: TObject;
  PropInfo: PPropInfo; const Format: string): string;
begin
  case PropInfo^.PropType^^.Kind of
    tkInteger:
      case GetTypeData(PropInfo^.PropType^)^.OrdType of
        otSByte,
        otSWord,
        otSLong:
        begin
          if Format <> '' then
            Result := IntToHex(GetOrdProp(Instance, PropInfo), StrToInt(Format))
          else
            Result := IntToStr(GetOrdProp(Instance, PropInfo));
        end;
        otUByte,
        otUWord,
        otULong:
        begin
          if Format <> '' then
            Result := IntToHex(UInt32(GetOrdProp(Instance, PropInfo)), StrToInt(Format))
          else
            Result := UIntToStr(UInt32(GetOrdProp(Instance, PropInfo)));
        end;
      end;
    tkChar: Result := String(AnsiChar(GetOrdProp(Instance, PropInfo)));
    tkFloat:
      case GetTypeData(PropInfo^.PropType^)^.FloatType of
        ftSingle:
        begin
          if Format <> '' then
            FormatFloat(Format, GetFloatProp(Instance, PropInfo))
          else
            Result := FloatToStr(GetFloatProp(Instance, PropInfo));
        end;
        ftDouble:
        begin
          if PropInfo^.PropType^ = System.TypeInfo(TDate) then
          begin
            if Format <> '' then
              DateTimeToString(Result, Format, GetFloatProp(Instance, PropInfo))
            else
              Result := DateToStr(GetFloatProp(Instance, PropInfo));
          end
          else if PropInfo^.PropType^ = System.TypeInfo(TTime) then
          begin
            if Format <> '' then
              DateTimeToString(Result, Format, GetFloatProp(Instance, PropInfo))
            else
              Result := TimeToStr(GetFloatProp(Instance, PropInfo));
          end
          else if PropInfo^.PropType^ = System.TypeInfo(TDateTime) then
          begin
            if Format <> '' then
              DateTimeToString(Result, Format, GetFloatProp(Instance, PropInfo))
            else
              Result := DateTimeToStr(GetFloatProp(Instance, PropInfo));
          end
          else
          begin
            if Format <> '' then
              FormatFloat(Format, GetFloatProp(Instance, PropInfo))
            else
              Result := FloatToStr(GetFloatProp(Instance, PropInfo));
          end;
        end;
        ftExtended:
        begin
          if Format <> '' then
            FormatFloat(Format, GetFloatProp(Instance, PropInfo))
          else
            Result := FloatToStr(GetFloatProp(Instance, PropInfo));
        end;
        ftComp: Result := IntToStr(GetInt64Prop(Instance, PropInfo));
        ftCurr:
        begin
          if Format <> '' then
            FormatCurr(Format, GetFloatProp(Instance, PropInfo))
          else
            Result := CurrToStr(GetFloatProp(Instance, PropInfo));
        end;
      end;
    tkString, tkLString, tkWString, tkUString: Result := GetStrProp(Instance, PropInfo);
    tkWChar: Result := WideChar(GetOrdProp(Instance, PropInfo));
    tkVariant: Result := VarToStr(GetVariantProp(Instance, PropInfo));
    tkInt64:
      if Format <> '' then
        Result := IntToHex(GetInt64Prop(Instance, PropInfo), StrToInt(Format))
      else
        with GetTypeData(PropInfo^.PropType^)^ do
          if MinInt64Value > MaxInt64Value then
            Result := UIntToStr(GetInt64Prop(Instance, PropInfo))
          else
            Result := IntToStr(GetInt64Prop(Instance, PropInfo));
  else
    raise EPropertyConvertError.CreateResFmt(@SInvalidPropertyType,
      [GetTypeName(PropInfo.PropType^)]);
  end;
end;

class function TGsTemplateProcessor.Process(const Template: string;
  Properties: TObject): string;
var
  PropCount: Integer;
  PropList: PPropList;
  I: Integer;
begin
  Result := Template;

  { Process properties }
  PropCount := GetPropList(Properties, PropList);

  for I := 0 to PropCount - 1 do
  begin
    { Process markers }
    Result := ProcessMarker(Result, Properties, PropList^[I]);

    { Process parametered marker }
    Result := ProcessPMarker(Result, Properties, PropList^[I]);
  end;
end;

class function TGsTemplateProcessor.ProcessMarker(const Template: string;
  Instance: TObject; PropInfo: PPropInfo): string;
begin
  Result := StringReplace(Template, GetMarker(PropInfo^.Name),
    GetPropValue(Instance, PropInfo), [rfReplaceAll, rfIgnoreCase]);
end;

class function TGsTemplateProcessor.ProcessPMarker(const Template: string;
  Instance: TObject; PropInfo: PPropInfo): string;
var
  UTemplate: string;
  MS: string;
  MSLen: Integer;
  S, E: Integer;
  Format: string;
  FormattedValue: string;
  Marker: string;
begin
  Result := Template;

  { Store upper case variant for case insensitivity }
  UTemplate := UpperCase(Template);

  { Search start marker }
  MS := GetPMarkerStart(PropInfo^.Name);
  S  := Pos(MS, UTemplate);

  if (S > 0) then
  begin
    { Search end marker }
    MSLen := Length(MS);
    E := Pos(GetPMarkerEnd, UTemplate, S + MSLen);

    if E = 0 then
      raise Exception.CreateRes(@SErrorEndMarkerNotFound);

    { Extract format }
    Format := Copy(Template, S + Length(MS), E - S - MSLen);
    FormattedValue := GetPropValue(Instance, PropInfo, Format);
    Marker := MS + Format + GetPMarkerEnd;

    { Replace all }
    Result := StringReplace(Template, Marker, FormattedValue,
      [rfReplaceAll, rfIgnoreCase]);

    { Recursive call to handle other formats }
    Result := ProcessPMarker(Result, Instance, PropInfo);
  end;
end;

end.

