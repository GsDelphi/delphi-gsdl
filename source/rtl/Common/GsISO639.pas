unit GsISO639;

{$DEFINE mORMot}

interface

uses
  Classes,
  {$IFDEF mORMot}
  mORMot,
  SynCommons,
  SynTests,
  {$ELSE ~mORMot}
  {$ENDIF ~mORMot}
  {$IFDEF MSWINDOWS}
  Windows
  {$ELSE ~MSWINDOWS}
  {$ENDIF ~MSWINDOWS}  ;

type
  {$IFNDEF mORMot}
  {$IFDEF UNICODE}
  RawUTF8 = type AnsiString(CP_UTF8); // Codepage for an UTF8 string
  {$ELSE ~UNICODE}
  RawUTF8 = type Ansistring;
  {$ENDIF ~UNICODE}
  {$ENDIF ~!mORMot}

  /// Language identifiers, following ISO 639-1 Alpha-2 code
  TLanguageIdentifier = (lcUndefined,
    lcAB, lcAA, lcAF, lcAK, lcSQ, lcAM, lcAR, lcAN, lcHY, lcAS, lcAV,
    lcAE, lcAY, lcAZ, lcBM, lcBA, lcEU, lcBE, lcBN, lcBH, lcBI, lcBS,
    lcBR, lcBG, lcMY, lcCA, lcKM, lcCH, lcCE, lcNY, lcZH, lcCU, lcCV,
    lcKW, lcCO, lcCR, lcHR, lcCS, lcDA, lcDV, lcNL, lcDZ, lcEN, lcEO,
    lcET, lcEE, lcFO, lcFJ, lcFI, lcFR, lcFF, lcGD, lcGL, lcLG, lcKA,
    lcDE, lcEL, lcGN, lcGU, lcHT, lcHA, lcHE, lcHZ, lcHI, lcHO, lcHU,
    lcIS, lcIO, lcIG, lcID, lcIA, lcIE, lcIU, lcIK, lcGA, lcIT, lcJA,
    lcJV, lcKL, lcKN, lcKR, lcKS, lcKK, lcKI, lcRW, lcKY, lcKV, lcKG,
    lcKO, lcKJ, lcKU, lcLO, lcLA, lcLV, lcLI, lcLN, lcLT, lcLU, lcLB,
    lcMK, lcMG, lcMS, lcML, lcMT, lcGV, lcMI, lcMR, lcMH, lcMN, lcNA,
    lcNV, lcNG, lcNE, lcND, lcSE, lcNO, lcNB, lcNN, lcOC, lcOJ, lcOR,
    lcOM, lcOS, lcPI, lcPA, lcPS, lcFA, lcPL, lcPT, lcQU, lcRO, lcRM,
    lcRN, lcRU, lcSM, lcSG, lcSA, lcSC, lcSR, lcSN, lcII, lcSD, lcSI,
    lcSK, lcSL, lcSO, lcNR, lcST, lcES, lcSU, lcSW, lcSS, lcSV, lcTL,
    lcTY, lcTG, lcTA, lcTT, lcTE, lcTH, lcBO, lcTI, lcTO, lcTS, lcTN,
    lcTR, lcTK, lcTW, lcUG, lcUK, lcUR, lcUZ, lcVE, lcVI, lcVO, lcWA,
    lcCY, lcFY, lcWO, lcXH, lcYI, lcYO, lcZA, lcZU);

  TLanguageIdentifiers = set of TLanguageIdentifier;

  TLanguageIsoAlpha2  = type RawUTF8;
  TLanguageIsoAlpha3  = type RawUTF8;
  TLanguageIsoAlpha3T = type TLanguageIsoAlpha3;
  TLanguageIsoAlpha3B = type TLanguageIsoAlpha3;
  {$IFDEF MSWINDOWS}
  //TLanguageId        = type LANGID;
  {$ELSE ~MSWINDOWS}
  //TLanguageId        = type RawUTF8;
  {$ENDIF ~MSWINDOWS}

  /// Language object
  // - includes conversion methods for ISO 639 alpha-2 / alpha-3 codes
  // as explained in https://en.wikipedia.org/wiki/ISO_639
  // - includes conversion methods for Windows API LANGID
  TLanguage = class({$IFDEF mORMot}TSynPersistent{$ELSE}TPersistent{$ENDIF})
  private
    function GetNative: RawUTF8;
    procedure SetLangID(const Value: LANGID);
  protected
    FIso:   TLanguageIsoAlpha3T;
    FCache: packed record
      Identifier: TLanguageIdentifier;
      Iso:        TLanguageIsoAlpha3T;
    end;
    function GetIdentifier: TLanguageIdentifier;
    function GetIsoAlpha2: TLanguageIsoAlpha2;
    function GetIsoAlpha3T: TLanguageIsoAlpha3T;
    function GetIsoAlpha3B: TLanguageIsoAlpha3B;
    procedure SetIdentifier(const Value: TLanguageIdentifier);
    procedure SetIsoAlpha2(const Value: TLanguageIsoAlpha2);
    procedure SetIsoAlpha3T(const Value: TLanguageIsoAlpha3T);
    procedure SetIsoAlpha3B(const Value: TLanguageIsoAlpha3B);
    function GetEnglish: RawUTF8;
    function GetLangID: LANGID;
  public
    /// built-in simple unit tests
    //class procedure RegressionTests(test: TSynTestCase);
    /// returns TRUE if both Language instances have the same content
    // - slightly faster than global function ObjectEquals(self,another)
    function Equals(ALanguage: TLanguage): Boolean; reintroduce;
    /// internal enumerate corresponding to this language
    property Identifier: TLanguageIdentifier read GetIdentifier write SetIdentifier;
    /// the ISO 639-1 alpha-2 code of this language, e.g. 'fr' or 'en'
    property Alpha2: TLanguageIsoAlpha2 read GetIsoAlpha2 write SetIsoAlpha2;
    /// the ISO 639-2/T alpha-3 code of this language, e.g. 'fra' or 'eng'
    property Alpha3T: TLanguageIsoAlpha3T read GetIsoAlpha3T write SetIsoAlpha3T;
    /// the ISO 639-2/B alpha-3 code of this language, e.g. 'fre' or 'eng'
    property Alpha3B: TLanguageIsoAlpha3B read GetIsoAlpha3B write SetIsoAlpha3B;
    /// plain English text of this language, e.g. 'French' or 'English'
    property English: RawUTF8 read GetEnglish;
    /// plain native text of this language, e.g. 'Français' or 'English'
    property Native: RawUTF8 read GetNative;
    {$IFDEF MSWINDOWS}
    /// Windows LANGID
    property LangID: LANGID read GetLangID write SetLangID;
    {$ENDIF ~MSWINDOWS}
  published
    /// the stored and transmitted value is this ISO 639-1 alpha-2 code
    property Iso: TLanguageIsoAlpha2 read FIso write FIso;
  end;

const
  lcFirst = Succ(Low(TLanguageIdentifier));
  lcLast  = High(TLanguageIdentifier);
  lcAll   = [lcFirst..lcLast];

implementation

uses
  SysUtils,
  TypInfo;

resourcestring
  SUndefined = '';
  SEnglishAB = 'Abkhazian';
  SEnglishAA = 'Afar';
  SEnglishAF = 'Afrikaans';
  SEnglishAK = 'Akan';
  SEnglishSQ = 'Albanian';
  SEnglishAM = 'Amharic';
  SEnglishAR = 'Arabic';
  SEnglishAN = 'Aragonese';
  SEnglishHY = 'Armenian';
  SEnglishAS = 'Assamese';
  SEnglishAV = 'Avaric';
  SEnglishAE = 'Avestan';
  SEnglishAY = 'Aymara';
  SEnglishAZ = 'Azerbaijani';
  SEnglishBM = 'Bambara';
  SEnglishBA = 'Bashkir';
  SEnglishEU = 'Basque';
  SEnglishBE = 'Belarusian';
  SEnglishBN = 'Bengali';
  SEnglishBH = 'Bihari languages';
  SEnglishBI = 'Bislama';
  SEnglishBS = 'Bosnian';
  SEnglishBR = 'Breton';
  SEnglishBG = 'Bulgarian';
  SEnglishMY = 'Burmese';
  SEnglishCA = 'Catalan, Valencian';
  SEnglishKM = 'Central Khmer';
  SEnglishCH = 'Chamorro';
  SEnglishCE = 'Chechen';
  SEnglishNY = 'Chichewa, Chewa, Nyanja';
  SEnglishZH = 'Chinese';
  SEnglishCU =
    'Church Slavic, Old Slavonic, Church Slavonic, Old Bulgarian, Old Church Slavonic';
  SEnglishCV = 'Chuvash';
  SEnglishKW = 'Cornish';
  SEnglishCO = 'Corsican';
  SEnglishCR = 'Cree';
  SEnglishHR = 'Croatian';
  SEnglishCS = 'Czech';
  SEnglishDA = 'Danish';
  SEnglishDV = 'Divehi, Dhivehi, Maldivian';
  SEnglishNL = 'Dutch, Flemish';
  SEnglishDZ = 'Dzongkha';
  SEnglishEN = 'English';
  SEnglishEO = 'Esperanto';
  SEnglishET = 'Estonian';
  SEnglishEE = 'Ewe';
  SEnglishFO = 'Faroese';
  SEnglishFJ = 'Fijian';
  SEnglishFI = 'Finnish';
  SEnglishFR = 'French';
  SEnglishFF = 'Fulah';
  SEnglishGD = 'Gaelic, Scottish Gaelic';
  SEnglishGL = 'Galician';
  SEnglishLG = 'Ganda';
  SEnglishKA = 'Georgian';
  SEnglishDE = 'German';
  SEnglishEL = 'Greek, Modern (1453-)';
  SEnglishGN = 'Guarani';
  SEnglishGU = 'Gujarati';
  SEnglishHT = 'Haitian, Haitian Creole';
  SEnglishHA = 'Hausa';
  SEnglishHE = 'Hebrew';
  SEnglishHZ = 'Herero';
  SEnglishHI = 'Hindi';
  SEnglishHO = 'Hiri Motu';
  SEnglishHU = 'Hungarian';
  SEnglishIS = 'Icelandic';
  SEnglishIO = 'Ido';
  SEnglishIG = 'Igbo';
  SEnglishID = 'Indonesian';
  SEnglishIA = 'Interlingua (International Auxiliary Language Association)';
  SEnglishIE = 'Interlingue, Occidental';
  SEnglishIU = 'Inuktitut';
  SEnglishIK = 'Inupiaq';
  SEnglishGA = 'Irish';
  SEnglishIT = 'Italian';
  SEnglishJA = 'Japanese';
  SEnglishJV = 'Javanese';
  SEnglishKL = 'Kalaallisut, Greenlandic';
  SEnglishKN = 'Kannada';
  SEnglishKR = 'Kanuri';
  SEnglishKS = 'Kashmiri';
  SEnglishKK = 'Kazakh';
  SEnglishKI = 'Kikuyu, Gikuyu';
  SEnglishRW = 'Kinyarwanda';
  SEnglishKY = 'Kirghiz, Kyrgyz';
  SEnglishKV = 'Komi';
  SEnglishKG = 'Kongo';
  SEnglishKO = 'Korean';
  SEnglishKJ = 'Kuanyama, Kwanyama';
  SEnglishKU = 'Kurdish';
  SEnglishLO = 'Lao';
  SEnglishLA = 'Latin';
  SEnglishLV = 'Latvian';
  SEnglishLI = 'Limburgan, Limburger, Limburgish';
  SEnglishLN = 'Lingala';
  SEnglishLT = 'Lithuanian';
  SEnglishLU = 'Luba-Katanga';
  SEnglishLB = 'Luxembourgish, Letzeburgesch';
  SEnglishMK = 'Macedonian';
  SEnglishMG = 'Malagasy';
  SEnglishMS = 'Malay';
  SEnglishML = 'Malayalam';
  SEnglishMT = 'Maltese';
  SEnglishGV = 'Manx';
  SEnglishMI = 'Maori';
  SEnglishMR = 'Marathi';
  SEnglishMH = 'Marshallese';
  SEnglishMN = 'Mongolian';
  SEnglishNA = 'Nauru';
  SEnglishNV = 'Navajo, Navaho';
  SEnglishNG = 'Ndonga';
  SEnglishNE = 'Nepali';
  SEnglishND = 'North Ndebele';
  SEnglishSE = 'Northern Sami';
  SEnglishNO = 'Norwegian';
  SEnglishNB = 'Norwegian Bokmål';
  SEnglishNN = 'Norwegian Nynorsk';
  SEnglishOC = 'Occitan';
  SEnglishOJ = 'Ojibwa';
  SEnglishOR = 'Oriya';
  SEnglishOM = 'Oromo';
  SEnglishOS = 'Ossetian, Ossetic';
  SEnglishPI = 'Pali';
  SEnglishPA = 'Panjabi, Punjabi';
  SEnglishPS = 'Pashto, Pushto';
  SEnglishFA = 'Persian';
  SEnglishPL = 'Polish';
  SEnglishPT = 'Portuguese';
  SEnglishQU = 'Quechua';
  SEnglishRO = 'Romanian, Moldavian, Moldovan';
  SEnglishRM = 'Romansh';
  SEnglishRN = 'Rundi';
  SEnglishRU = 'Russian';
  SEnglishSM = 'Samoan';
  SEnglishSG = 'Sango';
  SEnglishSA = 'Sanskrit';
  SEnglishSC = 'Sardinian';
  SEnglishSR = 'Serbian';
  SEnglishSN = 'Shona';
  SEnglishII = 'Sichuan Yi, Nuosu';
  SEnglishSD = 'Sindhi';
  SEnglishSI = 'Sinhala, Sinhalese';
  SEnglishSK = 'Slovak';
  SEnglishSL = 'Slovenian';
  SEnglishSO = 'Somali';
  SEnglishNR = 'South Ndebele';
  SEnglishST = 'Southern Sotho';
  SEnglishES = 'Spanish, Castilian';
  SEnglishSU = 'Sundanese';
  SEnglishSW = 'Swahili';
  SEnglishSS = 'Swati';
  SEnglishSV = 'Swedish';
  SEnglishTL = 'Tagalog';
  SEnglishTY = 'Tahitian';
  SEnglishTG = 'Tajik';
  SEnglishTA = 'Tamil';
  SEnglishTT = 'Tatar';
  SEnglishTE = 'Telugu';
  SEnglishTH = 'Thai';
  SEnglishBO = 'Tibetan';
  SEnglishTI = 'Tigrinya';
  SEnglishTO = 'Tonga (Tonga Islands)';
  SEnglishTS = 'Tsonga';
  SEnglishTN = 'Tswana';
  SEnglishTR = 'Turkish';
  SEnglishTK = 'Turkmen';
  SEnglishTW = 'Twi';
  SEnglishUG = 'Uighur, Uyghur';
  SEnglishUK = 'Ukrainian';
  SEnglishUR = 'Urdu';
  SEnglishUZ = 'Uzbek';
  SEnglishVE = 'Venda';
  SEnglishVI = 'Vietnamese';
  SEnglishVO = 'Volapük';
  SEnglishWA = 'Walloon';
  SEnglishCY = 'Welsh';
  SEnglishFY = 'Western Frisian';
  SEnglishWO = 'Wolof';
  SEnglishXH = 'Xhosa';
  SEnglishYI = 'Yiddish';
  SEnglishYO = 'Yoruba';
  SEnglishZA = 'Zhuang, Chuang';
  SEnglishZU = 'Zulu';
  SNativeAB  = 'аҧсуа бызшәа, аҧсшәа';
  SNativeAA  = 'Afaraf';
  SNativeAF  = 'Afrikaans';
  SNativeAK  = 'Akan';
  SNativeSQ  = 'Shqip';
  SNativeAM  = 'አማርኛ';
  SNativeAR  = 'العربية';
  SNativeAN  = 'aragonés';
  SNativeHY  = 'Հայերեն';
  SNativeAS  = 'অসমীয়া';
  SNativeAV  = 'авар мацӀ, магӀарул мацӀ';
  SNativeAE  = 'avesta';
  SNativeAY  = 'aymar aru';
  SNativeAZ  = 'azərbaycan dili';
  SNativeBM  = 'bamanankan';
  SNativeBA  = 'башҡорт теле';
  SNativeEU  = 'euskara, euskera';
  SNativeBE  = 'беларуская мова';
  SNativeBN  = 'বাংলা';
  SNativeBH  = 'भोजपुरी';
  SNativeBI  = 'Bislama';
  SNativeBS  = 'bosanski jezik';
  SNativeBR  = 'brezhoneg';
  SNativeBG  = 'български език';
  SNativeMY  = 'ဗမာစာ';
  SNativeCA  = 'català, valencià';
  SNativeKM  = 'ខ្មែរ, ខេមរភាសា, ភាសាខ្មែរ';
  SNativeCH  = 'Chamoru';
  SNativeCE  = 'нохчийн мотт';
  SNativeNY  = 'chiCheŵa, chinyanja';
  SNativeZH  = '中文 (Zhōngwén), 汉语, 漢語';
  SNativeCU  = 'ѩзыкъ словѣньскъ';
  SNativeCV  = 'чӑваш чӗлхи';
  SNativeKW  = 'Kernewek';
  SNativeCO  = 'corsu, lingua corsa';
  SNativeCR  = 'ᓀᐦᐃᔭᐍᐏᐣ';
  SNativeHR  = 'hrvatski jezik';
  SNativeCS  = 'čeština, český jazyk';
  SNativeDA  = 'dansk';
  SNativeDV  = 'ދިވެހި';
  SNativeNL  = 'Nederlands, Vlaams';
  SNativeDZ  = 'རྫོང་ཁ';
  SNativeEN  = 'English';
  SNativeEO  = 'Esperanto';
  SNativeET  = 'eesti, eesti keel';
  SNativeEE  = 'Eʋegbe';
  SNativeFO  = 'føroyskt';
  SNativeFJ  = 'vosa Vakaviti';
  SNativeFI  = 'suomi, suomen kieli';
  SNativeFR  = 'français, langue française';
  SNativeFF  = 'Fulfulde, Pulaar, Pular';
  SNativeGD  = 'Gàidhlig';
  SNativeGL  = 'Galego';
  SNativeLG  = 'Luganda';
  SNativeKA  = 'ქართული';
  SNativeDE  = 'Deutsch';
  SNativeEL  = 'ελληνικά';
  SNativeGN  = 'Avañe''ẽ';
  SNativeGU  = 'ગુજરાતી';
  SNativeHT  = 'Kreyòl ayisyen';
  SNativeHA  = '(Hausa) هَوُسَ';
  SNativeHE  = 'עברית';
  SNativeHZ  = 'Otjiherero';
  SNativeHI  = 'हिन्दी, हिंदी';
  SNativeHO  = 'Hiri Motu';
  SNativeHU  = 'magyar';
  SNativeIS  = 'Íslenska';
  SNativeIO  = 'Ido';
  SNativeIG  = 'Asụsụ Igbo';
  SNativeID  = 'Bahasa Indonesia';
  SNativeIA  = 'Interlingua';
  SNativeIE  = 'Originally called Occidental; then Interlingue after WWII';
  SNativeIU  = 'ᐃᓄᒃᑎᑐᑦ';
  SNativeIK  = 'Iñupiaq, Iñupiatun';
  SNativeGA  = 'Gaeilge';
  SNativeIT  = 'Italiano';
  SNativeJA  = '日本語 (にほんご)';
  SNativeJV  = 'ꦧꦱꦗꦮ, Basa Jawa';
  SNativeKL  = 'kalaallisut, kalaallit oqaasii';
  SNativeKN  = 'ಕನ್ನಡ';
  SNativeKR  = 'Kanuri';
  SNativeKS  = 'कश्मीरी, كشميري‎';
  SNativeKK  = 'қазақ тілі';
  SNativeKI  = 'Gĩkũyũ';
  SNativeRW  = 'Ikinyarwanda';
  SNativeKY  = 'Кыргызча, Кыргыз тили';
  SNativeKV  = 'коми кыв';
  SNativeKG  = 'Kikongo';
  SNativeKO  = '한국어';
  SNativeKJ  = 'Kuanyama';
  SNativeKU  = 'Kurdî, کوردی‎';
  SNativeLO  = 'ພາສາລາວ';
  SNativeLA  = 'latine, lingua latina';
  SNativeLV  = 'latviešu valoda';
  SNativeLI  = 'Limburgs';
  SNativeLN  = 'Lingála';
  SNativeLT  = 'lietuvių kalba';
  SNativeLU  = 'Kiluba';
  SNativeLB  = 'Lëtzebuergesch';
  SNativeMK  = 'македонски јазик';
  SNativeMG  = 'fiteny malagasy';
  SNativeMS  = 'Bahasa Melayu, بهاس ملايو‎';
  SNativeML  = 'മലയാളം';
  SNativeMT  = 'Malti';
  SNativeGV  = 'Gaelg, Gailck';
  SNativeMI  = 'te reo Māori';
  SNativeMR  = 'मराठी';
  SNativeMH  = 'Kajin M̧ajeļ';
  SNativeMN  = 'Монгол хэл';
  SNativeNA  = 'Dorerin Naoero';
  SNativeNV  = 'Diné bizaad';
  SNativeNG  = 'Owambo';
  SNativeNE  = 'नेपाली';
  SNativeND  = 'isiNdebele';
  SNativeSE  = 'Davvisámegiella';
  SNativeNO  = 'Norsk';
  SNativeNB  = 'Norsk Bokmål';
  SNativeNN  = 'Norsk Nynorsk';
  SNativeOC  = 'occitan, lenga d''òc';
  SNativeOJ  = 'ᐊᓂᔑᓈᐯᒧᐎᓐ';
  SNativeOR  = 'ଓଡ଼ିଆ';
  SNativeOM  = 'Afaan Oromoo';
  SNativeOS  = 'ирон æвзаг';
  SNativePI  = 'पाऴि';
  SNativePA  = 'ਪੰਜਾਬੀ';
  SNativePS  = 'پښتو';
  SNativeFA  = 'فارسی';
  SNativePL  = 'język polski, polszczyzna';
  SNativePT  = 'Português';
  SNativeQU  = 'Runa Simi, Kichwa';
  SNativeRO  = 'Română';
  SNativeRM  = 'Rumantsch Grischun';
  SNativeRN  = 'Ikirundi';
  SNativeRU  = 'русский';
  SNativeSM  = 'gagana fa''a Samoa';
  SNativeSG  = 'yângâ tî sängö';
  SNativeSA  = 'संस्कृतम्';
  SNativeSC  = 'sardu';
  SNativeSR  = 'српски језик';
  SNativeSN  = 'chiShona';
  SNativeII  = 'ꆈꌠ꒿ Nuosuhxop';
  SNativeSD  = 'सिन्धी, سنڌي، سندھی‎';
  SNativeSI  = 'සිංහල';
  SNativeSK  = 'Slovenčina, Slovenský Jazyk';
  SNativeSL  = 'Slovenski Jezik, Slovenščina';
  SNativeSO  = 'Soomaaliga, af Soomaali';
  SNativeNR  = 'isiNdebele';
  SNativeST  = 'Sesotho';
  SNativeES  = 'Español';
  SNativeSU  = 'Basa Sunda';
  SNativeSW  = 'Kiswahili';
  SNativeSS  = 'SiSwati';
  SNativeSV  = 'Svenska';
  SNativeTL  = 'Wikang Tagalog';
  SNativeTY  = 'Reo Tahiti';
  SNativeTG  = 'тоҷикӣ, toçikī, تاجیکی‎';
  SNativeTA  = 'தமிழ்';
  SNativeTT  = 'татар теле, tatar tele';
  SNativeTE  = 'తెలుగు';
  SNativeTH  = 'ไทย';
  SNativeBO  = 'བོད་ཡིག';
  SNativeTI  = 'ትግርኛ';
  SNativeTO  = 'Faka Tonga';
  SNativeTS  = 'Xitsonga';
  SNativeTN  = 'Setswana';
  SNativeTR  = 'Türkçe';
  SNativeTK  = 'Türkmen, Түркмен';
  SNativeTW  = 'Twi';
  SNativeUG  = 'ئۇيغۇرچە‎, Uyghurche';
  SNativeUK  = 'Українська';
  SNativeUR  = 'اردو';
  SNativeUZ  = 'Oʻzbek, Ўзбек, أۇزبېك‎';
  SNativeVE  = 'Tshivenḓa';
  SNativeVI  = 'Tiếng Việt';
  SNativeVO  = 'Volapük';
  SNativeWA  = 'Walon';
  SNativeCY  = 'Cymraeg';
  SNativeFY  = 'Frysk';
  SNativeWO  = 'Wollof';
  SNativeXH  = 'isiXhosa';
  SNativeYI  = 'ייִדיש';
  SNativeYO  = 'Yorùbá';
  SNativeZA  = 'Saɯ cueŋƅ, Saw cuengh';
  SNativeZU  = 'isiZulu';

const
  LANGUAGE_NAME_EN: array[TLanguageIdentifier] of PResStringRec =
    (@SUndefined, @SEnglishAB, @SEnglishAA, @SEnglishAF, @SEnglishAK,
    @SEnglishSQ, @SEnglishAM, @SEnglishAR, @SEnglishAN, @SEnglishHY,
    @SEnglishAS, @SEnglishAV, @SEnglishAE, @SEnglishAY, @SEnglishAZ,
    @SEnglishBM, @SEnglishBA, @SEnglishEU, @SEnglishBE, @SEnglishBN,
    @SEnglishBH, @SEnglishBI, @SEnglishBS, @SEnglishBR, @SEnglishBG,
    @SEnglishMY, @SEnglishCA, @SEnglishKM, @SEnglishCH, @SEnglishCE,
    @SEnglishNY, @SEnglishZH, @SEnglishCU, @SEnglishCV, @SEnglishKW,
    @SEnglishCO, @SEnglishCR, @SEnglishHR, @SEnglishCS, @SEnglishDA,
    @SEnglishDV, @SEnglishNL, @SEnglishDZ, @SEnglishEN, @SEnglishEO,
    @SEnglishET, @SEnglishEE, @SEnglishFO, @SEnglishFJ, @SEnglishFI,
    @SEnglishFR, @SEnglishFF, @SEnglishGD, @SEnglishGL, @SEnglishLG,
    @SEnglishKA, @SEnglishDE, @SEnglishEL, @SEnglishGN, @SEnglishGU,
    @SEnglishHT, @SEnglishHA, @SEnglishHE, @SEnglishHZ, @SEnglishHI,
    @SEnglishHO, @SEnglishHU, @SEnglishIS, @SEnglishIO, @SEnglishIG,
    @SEnglishID, @SEnglishIA, @SEnglishIE, @SEnglishIU, @SEnglishIK,
    @SEnglishGA, @SEnglishIT, @SEnglishJA, @SEnglishJV, @SEnglishKL,
    @SEnglishKN, @SEnglishKR, @SEnglishKS, @SEnglishKK, @SEnglishKI,
    @SEnglishRW, @SEnglishKY, @SEnglishKV, @SEnglishKG, @SEnglishKO,
    @SEnglishKJ, @SEnglishKU, @SEnglishLO, @SEnglishLA, @SEnglishLV,
    @SEnglishLI, @SEnglishLN, @SEnglishLT, @SEnglishLU, @SEnglishLB,
    @SEnglishMK, @SEnglishMG, @SEnglishMS, @SEnglishML, @SEnglishMT,
    @SEnglishGV, @SEnglishMI, @SEnglishMR, @SEnglishMH, @SEnglishMN,
    @SEnglishNA, @SEnglishNV, @SEnglishNG, @SEnglishNE, @SEnglishND,
    @SEnglishSE, @SEnglishNO, @SEnglishNB, @SEnglishNN, @SEnglishOC,
    @SEnglishOJ, @SEnglishOR, @SEnglishOM, @SEnglishOS, @SEnglishPI,
    @SEnglishPA, @SEnglishPS, @SEnglishFA, @SEnglishPL, @SEnglishPT,
    @SEnglishQU, @SEnglishRO, @SEnglishRM, @SEnglishRN, @SEnglishRU,
    @SEnglishSM, @SEnglishSG, @SEnglishSA, @SEnglishSC, @SEnglishSR,
    @SEnglishSN, @SEnglishII, @SEnglishSD, @SEnglishSI, @SEnglishSK,
    @SEnglishSL, @SEnglishSO, @SEnglishNR, @SEnglishST, @SEnglishES,
    @SEnglishSU, @SEnglishSW, @SEnglishSS, @SEnglishSV, @SEnglishTL,
    @SEnglishTY, @SEnglishTG, @SEnglishTA, @SEnglishTT, @SEnglishTE,
    @SEnglishTH, @SEnglishBO, @SEnglishTI, @SEnglishTO, @SEnglishTS,
    @SEnglishTN, @SEnglishTR, @SEnglishTK, @SEnglishTW, @SEnglishUG,
    @SEnglishUK, @SEnglishUR, @SEnglishUZ, @SEnglishVE, @SEnglishVI,
    @SEnglishVO, @SEnglishWA, @SEnglishCY, @SEnglishFY, @SEnglishWO,
    @SEnglishXH, @SEnglishYI, @SEnglishYO, @SEnglishZA, @SEnglishZU);

  LANGUAGE_NAME_NATIVE: array[TLanguageIdentifier] of PResStringRec =
    (@SUndefined, @SNativeAB, @SNativeAA, @SNativeAF, @SNativeAK,
    @SNativeSQ, @SNativeAM, @SNativeAR, @SNativeAN, @SNativeHY, @SNativeAS,
    @SNativeAV, @SNativeAE, @SNativeAY, @SNativeAZ, @SNativeBM, @SNativeBA,
    @SNativeEU, @SNativeBE, @SNativeBN, @SNativeBH, @SNativeBI, @SNativeBS,
    @SNativeBR, @SNativeBG, @SNativeMY, @SNativeCA, @SNativeKM, @SNativeCH,
    @SNativeCE, @SNativeNY, @SNativeZH, @SNativeCU, @SNativeCV, @SNativeKW,
    @SNativeCO, @SNativeCR, @SNativeHR, @SNativeCS, @SNativeDA, @SNativeDV,
    @SNativeNL, @SNativeDZ, @SNativeEN, @SNativeEO, @SNativeET, @SNativeEE,
    @SNativeFO, @SNativeFJ, @SNativeFI, @SNativeFR, @SNativeFF, @SNativeGD,
    @SNativeGL, @SNativeLG, @SNativeKA, @SNativeDE, @SNativeEL, @SNativeGN,
    @SNativeGU, @SNativeHT, @SNativeHA, @SNativeHE, @SNativeHZ, @SNativeHI,
    @SNativeHO, @SNativeHU, @SNativeIS, @SNativeIO, @SNativeIG, @SNativeID,
    @SNativeIA, @SNativeIE, @SNativeIU, @SNativeIK, @SNativeGA, @SNativeIT,
    @SNativeJA, @SNativeJV, @SNativeKL, @SNativeKN, @SNativeKR, @SNativeKS,
    @SNativeKK, @SNativeKI, @SNativeRW, @SNativeKY, @SNativeKV, @SNativeKG,
    @SNativeKO, @SNativeKJ, @SNativeKU, @SNativeLO, @SNativeLA, @SNativeLV,
    @SNativeLI, @SNativeLN, @SNativeLT, @SNativeLU, @SNativeLB, @SNativeMK,
    @SNativeMG, @SNativeMS, @SNativeML, @SNativeMT, @SNativeGV, @SNativeMI,
    @SNativeMR, @SNativeMH, @SNativeMN, @SNativeNA, @SNativeNV, @SNativeNG,
    @SNativeNE, @SNativeND, @SNativeSE, @SNativeNO, @SNativeNB, @SNativeNN,
    @SNativeOC, @SNativeOJ, @SNativeOR, @SNativeOM, @SNativeOS, @SNativePI,
    @SNativePA, @SNativePS, @SNativeFA, @SNativePL, @SNativePT, @SNativeQU,
    @SNativeRO, @SNativeRM, @SNativeRN, @SNativeRU, @SNativeSM, @SNativeSG,
    @SNativeSA, @SNativeSC, @SNativeSR, @SNativeSN, @SNativeII, @SNativeSD,
    @SNativeSI, @SNativeSK, @SNativeSL, @SNativeSO, @SNativeNR, @SNativeST,
    @SNativeES, @SNativeSU, @SNativeSW, @SNativeSS, @SNativeSV, @SNativeTL,
    @SNativeTY, @SNativeTG, @SNativeTA, @SNativeTT, @SNativeTE, @SNativeTH,
    @SNativeBO, @SNativeTI, @SNativeTO, @SNativeTS, @SNativeTN, @SNativeTR,
    @SNativeTK, @SNativeTW, @SNativeUG, @SNativeUK, @SNativeUR, @SNativeUZ,
    @SNativeVE, @SNativeVI, @SNativeVO, @SNativeWA, @SNativeCY, @SNativeFY,
    @SNativeWO, @SNativeXH, @SNativeYI, @SNativeYO, @SNativeZA, @SNativeZU);

  LANGUAGE_ISO3T: array[TLanguageIdentifier] of array[0..3] of AnsiChar = ('',
    'abk', 'aar', 'afr', 'aka', 'sqi', 'amh', 'ara', 'arg', 'hye', 'asm',
    'ava', 'ave', 'aym', 'aze', 'bam', 'bak', 'eus', 'bel', 'ben', 'bih',
    'bis', 'bos', 'bre', 'bul', 'mya', 'cat', 'khm', 'cha', 'che', 'nya',
    'zho', 'chu', 'chv', 'cor', 'cos', 'cre', 'hrv', 'ces', 'dan', 'div',
    'nld', 'dzo', 'eng', 'epo', 'est', 'ewe', 'fao', 'fij', 'fin', 'fra',
    'ful', 'gla', 'glg', 'lug', 'kat', 'deu', 'ell', 'grn', 'guj', 'hat',
    'hau', 'heb', 'her', 'hin', 'hmo', 'hun', 'isl', 'ido', 'ibo', 'ind',
    'ina', 'ile', 'iku', 'ipk', 'gle', 'ita', 'jpn', 'jav', 'kal', 'kan',
    'kau', 'kas', 'kaz', 'kik', 'kin', 'kir', 'kom', 'kon', 'kor', 'kua',
    'kur', 'lao', 'lat', 'lav', 'lim', 'lin', 'lit', 'lub', 'ltz', 'mkd',
    'mlg', 'msa', 'mal', 'mlt', 'glv', 'mri', 'mar', 'mah', 'mon', 'nau',
    'nav', 'ndo', 'nep', 'nde', 'sme', 'nor', 'nob', 'nno', 'oci', 'oji',
    'ori', 'orm', 'oss', 'pli', 'pan', 'pus', 'fas', 'pol', 'por', 'que',
    'ron', 'roh', 'run', 'rus', 'smo', 'sag', 'san', 'srd', 'srp', 'sna',
    'iii', 'snd', 'sin', 'slk', 'slv', 'som', 'nbl', 'sot', 'spa', 'sun',
    'swa', 'ssw', 'swe', 'tgl', 'tah', 'tgk', 'tam', 'tat', 'tel', 'tha',
    'bod', 'tir', 'ton', 'tso', 'tsn', 'tur', 'tuk', 'twi', 'uig', 'ukr',
    'urd', 'uzb', 'ven', 'vie', 'vol', 'wln', 'cym', 'fry', 'wol', 'xho',
    'yid', 'yor', 'zha', 'zul');

  LANGUAGE_ISO3B: array[TLanguageIdentifier] of array[0..3] of AnsiChar = ('',
    'abk', 'aar', 'afr', 'aka', 'alb', 'amh', 'ara', 'arg', 'arm', 'asm',
    'ava', 'ave', 'aym', 'aze', 'bam', 'bak', 'baq', 'bel', 'ben', 'bih',
    'bis', 'bos', 'bre', 'bul', 'bur', 'cat', 'khm', 'cha', 'che', 'nya',
    'chi', 'chu', 'chv', 'cor', 'cos', 'cre', 'hrv', 'cze', 'dan', 'div',
    'dut', 'dzo', 'eng', 'epo', 'est', 'ewe', 'fao', 'fij', 'fin', 'fre',
    'ful', 'gla', 'glg', 'lug', 'geo', 'ger', 'gre', 'grn', 'guj', 'hat',
    'hau', 'heb', 'her', 'hin', 'hmo', 'hun', 'ice', 'ido', 'ibo', 'ind',
    'ina', 'ile', 'iku', 'ipk', 'gle', 'ita', 'jpn', 'jav', 'kal', 'kan',
    'kau', 'kas', 'kaz', 'kik', 'kin', 'kir', 'kom', 'kon', 'kor', 'kua',
    'kur', 'lao', 'lat', 'lav', 'lim', 'lin', 'lit', 'lub', 'ltz', 'mac',
    'mlg', 'may', 'mal', 'mlt', 'glv', 'mao', 'mar', 'mah', 'mon', 'nau',
    'nav', 'ndo', 'nep', 'nde', 'sme', 'nor', 'nob', 'nno', 'oci', 'oji',
    'ori', 'orm', 'oss', 'pli', 'pan', 'pus', 'per', 'pol', 'por', 'que',
    'rum', 'roh', 'run', 'rus', 'smo', 'sag', 'san', 'srd', 'srp', 'sna',
    'iii', 'snd', 'sin', 'slo', 'slv', 'som', 'nbl', 'sot', 'spa', 'sun',
    'swa', 'ssw', 'swe', 'tgl', 'tah', 'tgk', 'tam', 'tat', 'tel', 'tha',
    'tib', 'tir', 'ton', 'tso', 'tsn', 'tur', 'tuk', 'twi', 'uig', 'ukr',
    'urd', 'uzb', 'ven', 'vie', 'vol', 'wln', 'wel', 'fry', 'wol', 'xho',
    'yid', 'yor', 'zha', 'zul');

type
  TLocaleListOption = (lloAll, lloPrimary, lloSub);

var
  LANGUAGE_ISO2: array[TLanguageIdentifier] of Word;

  Locales: TStringList = nil;
  PrimaryLocales: TStringList = nil;
  SubLocales: TStringList = nil;

procedure Initialize;
var
  L: TLanguageIdentifier;
  S: PAnsiChar; // circumvent FPC compilation issue
begin
  for L := lcFirst to lcLast do
  begin
    S := Pointer(GetEnumName(TypeInfo(TLanguageIdentifier), Ord(L)));
    LANGUAGE_ISO2[L] := PWord(S + 3)^;
  end;
end;

function LeftStr(const ASeparator, AText: string): string; overload;
var
  P: Integer;
begin
  P := Pos(ASeparator, AText);

  if (P > 0) then
    Result := Copy(AText, 1, P - 1)
  else
    Result := AText;
end;

function GetPrimaryLanguageID(const ALocale: Windows.LCID): Windows.LANGID;
begin
  Result := ALocale and $3ff;
end;

function GetLocaleInfo(const ALocale: Windows.LCID; const ALocaleType: LCTYPE): string;
var
  Size, Res: Integer;
begin
  Size := Windows.GetLocaleInfo(ALocale, ALocaleType, nil, 0);
  SetLength(Result, Size * SizeOf(Char));

  Res := Windows.GetLocaleInfo(ALocale, ALocaleType, @Result[1], Length(Result));

  if Res <> Size then
    RaiseLastOSError(GetLastError, 'Error getting locale info');
end;

var
  EnumLocaleList: TStringList;

function EnumLocalesProc(lpLocaleString: LPTSTR): BOOL; stdcall;
var
  Locale: Windows.LCID;
  LocaleInfo: string;
begin
  Result := True;
  //LocaleInfo := '';

  if Length(String(lpLocaleString)) = 0 then
    Exit;

  Locale := Windows.LCID(StrToInt(HexDisplayPrefix + String(lpLocaleString)));

  try
    LocaleInfo := GetLocaleInfo(Locale, LOCALE_SLANGUAGE);
  except
    Exit;
  end;

  if (LocaleInfo = '') then
    Exit;

  EnumLocaleList.AddObject(LocaleInfo, Pointer(Locale));
end;

procedure InternalGetLocaleList(AList: TStrings; AOption: TLocaleListOption);
var
  PrimaryLanguage: LANGID;
  I, J:  Integer;
  Found: Boolean;
begin
  AList.Clear;
  EnumLocaleList := TStringList.Create;

  try
    EnumSystemLocales(@EnumLocalesProc, LCID_SUPPORTED);

    I := 0;

    case AOption of
      lloAll:
      begin
        while (i < EnumLocaleList.Count - 1) do
        begin
          PrimaryLanguage := GetPrimaryLanguageID(
            Windows.LCID(EnumLocaleList.Objects[I]));
          if (EnumLocaleList.IndexOfObject(Pointer(PrimaryLanguage)) < 0) then
          begin
            J := I + 1;
            Found := False;

            while (J < EnumLocaleList.Count) do
            begin
              if (PrimaryLanguage = GetPrimaryLanguageID(
                Windows.LCID(EnumLocaleList.Objects[J]))) then
              begin
                Found := True;
                Break;
              end;

              Inc(J);
            end;

            if Found then
            begin
              EnumLocaleList.InsertObject(I, LeftStr('(', EnumLocaleList.Strings[I]),
                Pointer(PrimaryLanguage));
              Inc(I);
            end;
          end;

          Inc(I);
        end;
      end;
      lloPrimary:
      begin
        while (I < EnumLocaleList.Count) do
        begin
          PrimaryLanguage := GetPrimaryLanguageID(
            Windows.LCID(EnumLocaleList.Objects[I]));
          Found := False;
          J := I + 1;

          while (J < EnumLocaleList.Count) do
          begin
            if (PrimaryLanguage = GetPrimaryLanguageID(
              Windows.LCID(EnumLocaleList.Objects[J]))) then
            begin
              Found := True;
              EnumLocaleList.Delete(J);
            end
            else
              Inc(J);
          end;

          if Found then
          begin
            EnumLocaleList.Strings[I] := LeftStr('(', EnumLocaleList.Strings[I]);
            EnumLocaleList.Objects[I] := Pointer(PrimaryLanguage);
          end;

          Inc(I);
        end;
      end;
    end;

    AList.Assign(EnumLocaleList);
  finally
    EnumLocaleList.Free;
  end;
end;

procedure GetLocaleList(AList: TStrings; AOption: TLocaleListOption);
resourcestring
  SErrorOptionNotImplemented = 'Option ''%s'' not implemented in GetLocaleList.';
var
  Cache: ^TStrings;
begin
  case AOption of
    lloAll: Cache := @Locales;
    lloPrimary: Cache := @PrimaryLocales;
    lloSub: Cache := @SubLocales;
  else
    raise ENotImplemented.CreateResFmt(@SErrorOptionNotImplemented,
      [GetEnumName(TypeInfo(TLocaleListOption), Ord(AOption))]);
  end;

  if not Assigned(Cache^) then
  begin
    Cache^ := TStringList.Create;
    InternalGetLocaleList(Cache^, AOption);
  end;

  AList.Assign(Cache^);
end;

function ISO6391CodeByLocale(const ALocale: Windows.LCID): string;
begin
  Result := GetLocaleInfo(ALocale, LOCALE_SISO639LANGNAME);
end;

function LocaleByISO6391Code(const AAlpha2Code: string): Windows.LCID;
var
  I: Integer;
  List: TStrings;
begin
  List := TStringList.Create;

  try
    GetLocaleList(List, lloPrimary);

    for I := 0 to List.Count - 1 do
    begin
      Result := Windows.LCID(List.Objects[I]);

      if (CompareText(ISO6391CodeByLocale(Result), AAlpha2Code) = 0) then
        Exit;
    end;

    Result := 0;
  finally
    List.Free;
  end;
end;

{ TLanguage }

function TLanguage.Equals(ALanguage: TLanguage): Boolean;
begin
  if (Self = nil) or (ALanguage = nil) then
    Result := ALanguage = Self
  else
    Result := ALanguage.FIso = FIso;
end;

function TLanguage.GetEnglish: RawUTF8;
begin
  Result := LoadResString(LANGUAGE_NAME_EN[Identifier]);
end;

function TLanguage.GetIdentifier: TLanguageIdentifier;
begin

end;

function TLanguage.GetIsoAlpha2: TLanguageIsoAlpha2;
begin
  SetString(Result, PAnsiChar(@LANGUAGE_ISO2[GetIdentifier]), 2);
end;

function TLanguage.GetIsoAlpha3B: TLanguageIsoAlpha3B;
begin
  SetString(Result, PAnsiChar(@LANGUAGE_ISO3B[GetIdentifier]), 3);
end;

function TLanguage.GetIsoAlpha3T: TLanguageIsoAlpha3T;
begin
  SetString(Result, PAnsiChar(@LANGUAGE_ISO3T[GetIdentifier]), 3);
end;

function TLanguage.GetLangID: LANGID;
begin
  Result := LocaleByISO6391Code(Alpha2);
end;

function TLanguage.GetNative: RawUTF8;
begin
  Result := LoadResString(LANGUAGE_NAME_NATIVE[Identifier]);
end;

procedure TLanguage.SetIdentifier(const Value: TLanguageIdentifier);
begin

end;

procedure TLanguage.SetIsoAlpha2(const Value: TLanguageIsoAlpha2);
begin

end;

procedure TLanguage.SetIsoAlpha3B(const Value: TLanguageIsoAlpha3B);
begin

end;

procedure TLanguage.SetIsoAlpha3T(const Value: TLanguageIsoAlpha3T);
begin

end;

procedure TLanguage.SetLangID(const Value: LANGID);
begin

end;

end.

