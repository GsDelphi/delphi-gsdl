unit GsSlackApi;

interface

uses
  mORMot,
  SynCommons,
  SynCrtSock,
  System.Classes,
  System.SysUtils;

type
  SlackString     = type RawUTF8;
  WebhookURL      = type SockString;
  WebhookResponse = type SockString;

  EGsSlackError = class(Exception);

  EGsSlackUnsupportedItem = class(EGsSlackError)
  public
    constructor Create(ATypeInfo: Pointer; AIndex: Integer);
  end;

  EGsSlackMaxError = class(EGsSlackError)
  protected
    function GetMessage: string; virtual; abstract;
  public
    constructor Create(const AName: string; AMax: Integer);
  end;

  EGsSlackMaxItems = class(EGsSlackMaxError)
  protected
    function GetMessage: string; override;
  end;

  EGsSlackMaxSize = class(EGsSlackMaxError)
  protected
    function GetMessage: string; override;
  end;

  TGsSlackObject = class(TPersistent)
  private
  protected
    (*
    class procedure SlackWriter(const aSerializer: TJSONSerializer; aValue: TObject;
      aOptions: TTextWriterWriteObjectOptions); virtual; abstract;
    class function SlackReader(const aValue: TObject; aFrom: PUTF8Char; var aValid: Boolean;
      aOptions: TJSONToObjectOptions): PUTF8Char; virtual; abstract;
    *)
    function JSONOptions: TTextWriterWriteObjectOptions; dynamic;
    procedure Validate; virtual; abstract;
  public
    constructor Create; virtual;
    function ToJSON: RawJSON;
  published
  end;

  TGsSlackMessageObject = class(TGsSlackObject);

  TGsSlackMessageContentObject = class(TGsSlackMessageObject);
  TGsSlackMessageContentObjects = array of TGsSlackMessageContentObject;


  TGsSlackMessageCompositionObject = class(TGsSlackMessageContentObject);
  TGsSlackMessageCompositionObjects = array of TGsSlackMessageCompositionObject;

  TGsSlackTextType = (
    ttUnknown,
    ttPlainText,
    ttMrkdwn
    );

  TGsSlackMCOText = class(TGsSlackMessageCompositionObject)
  private
    FTextType: TGsSlackTextType;
    FVerbatim: Boolean;
    FEmoji:    Boolean;
    FText:     SlackString;
    function IsEmojiStored: Boolean;
    function IsVerbatimStored: Boolean;
  protected
    procedure Validate; override;
    function GetTypeAsString: SlackString; virtual;
    procedure SetTypeAsString(const Value: SlackString); virtual;
  public
    class function TextTypeToStr(AType: TGsSlackTextType): SlackString;
    class function StrToTypeText(AValue: SlackString): TGsSlackTextType;
    constructor Create; override;
    property TextType: TGsSlackTextType read FTextType write FTextType;
  published
    /// The formatting to use for this text object. Can be one of plain_text or
    // mrkdwn.
    property TypeAsString: SlackString read GetTypeAsString write SetTypeAsString;
    /// The text for the block. This field accepts any of the standard text
    // formatting markup when type is mrkdwn.
    property Text: SlackString read FText write FText;
    /// Indicates whether emojis in a text field should be escaped into the
    // colon emoji format. This field is only usable when type is plain_text.
    property Emoji: Boolean read FEmoji write FEmoji stored IsEmojiStored default False;
    /// When set to false (as is default) URLs will be auto-converted into
    // links, conversation names will be link-ified, and certain mentions will
    // be automatically parsed.
    // Using a value of true will skip any preprocessing of this nature,
    // although you can still include manual parsing strings. This field is only
    // usable when type is mrkdwn.
    property Verbatim: Boolean read FVerbatim write FVerbatim stored IsVerbatimStored default False;
  end;

  TGsSlackMCOTexts = array of TGsSlackMCOText;

  TGsSlackMCOConfirmationDialog = class(TGsSlackMessageCompositionObject);
  TGsSlackMCOOption = class(TGsSlackMessageCompositionObject);
  TGsSlackMCOOptionGroup = class(TGsSlackMessageCompositionObject);


  TGsSlackMessageBlockElementType = (
    mbetUnknown,
    mbetImage,
    mbetButton,
    mbetStaticSelect,
    mbetExternalSelect,
    mbetUsersSelect,
    mbetConversationsSelect,
    mbetChannelsSelect,
    mbetOverflow,
    mbetDatePicker
    );

  TGsSlackMessageBlockElementClass = class of TGsSlackMessageBlockElement;

  TGsSlackMessageBlockElement = class(TGsSlackMessageContentObject)
  private
    function GetTypeAsString: SlackString;
    procedure SetTypeAsString(const Value: SlackString);
  protected
    class function ElementTypeToClass(AElementType: TGsSlackMessageBlockElementType): TGsSlackMessageBlockElementClass;
    class function StrToElementType(AElementType: SlackString): TGsSlackMessageBlockElementType;
    function GetType: TGsSlackMessageBlockElementType; virtual; abstract;
  public
    class function CreateMessageBlockElement(AElementType: TGsSlackMessageBlockElementType):
      TGsSlackMessageBlockElement; overload;
    class function CreateMessageBlockElement(AElementType: SlackString): TGsSlackMessageBlockElement; overload;
    property ElementType: TGsSlackMessageBlockElementType read GetType;
    property TypeAsString: SlackString read GetTypeAsString write SetTypeAsString;
  end;

  TGsSlackMessageBlockElements = array of TGsSlackMessageBlockElement;

  TGsSlackMBEImage = class(TGsSlackMessageBlockElement)
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageBlockElementType; override;
  published
    property TypeAsString;
  end;

  TGsSlackMBEButton = class(TGsSlackMessageBlockElement)
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageBlockElementType; override;
  published
    property TypeAsString;
  end;

  TGsSlackMBEStaticSelect = class(TGsSlackMessageBlockElement)
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageBlockElementType; override;
  published
    property TypeAsString;
  end;

  TGsSlackMBEExternalSelect = class(TGsSlackMessageBlockElement)
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageBlockElementType; override;
  published
    property TypeAsString;
  end;

  TGsSlackMBEUsersSelect = class(TGsSlackMessageBlockElement)
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageBlockElementType; override;
  published
    property TypeAsString;
  end;

  TGsSlackMBEConversationsSelect = class(TGsSlackMessageBlockElement)
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageBlockElementType; override;
  published
    property TypeAsString;
  end;

  TGsSlackMBEChannelsSelect = class(TGsSlackMessageBlockElement)
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageBlockElementType; override;
  published
    property TypeAsString;
  end;

  TGsSlackMBEOverflow = class(TGsSlackMessageBlockElement)
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageBlockElementType; override;
  published
    property TypeAsString;
  end;

  TGsSlackMBEDatePicker = class(TGsSlackMessageBlockElement)
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageBlockElementType; override;
  published
    property TypeAsString;
  end;

  TGsSlackMessageLayoutBlockType = (
    mlbtUnknown,
    mlbtSection,
    mlbtDivider,
    mlbtImage,
    mlbtActions,
    mlbtContext
    );

  TGsSlackMessageLayoutBlockClass = class of TGsSlackMessageLayoutBlock;

  TGsSlackMessageLayoutBlock = class(TGsSlackMessageContentObject)
  private
    FBlockId: SlackString;
    function GetTypeAsString: SlackString;
    procedure SetTypeAsString(const Value: SlackString);
    function IsBlockIdStored: Boolean;
  protected
    procedure Validate; override;
    class function BlockTypeToClass(ABlockType: TGsSlackMessageLayoutBlockType): TGsSlackMessageLayoutBlockClass;
    class function StrToBlockType(ABlockType: SlackString): TGsSlackMessageLayoutBlockType;
    function GetType: TGsSlackMessageLayoutBlockType; virtual; abstract;
  public
    class function CreateMessageLayoutBlock(ABlockType: TGsSlackMessageLayoutBlockType): TGsSlackMessageLayoutBlock;
      overload;
    class function CreateMessageLayoutBlock(ABlockType: SlackString): TGsSlackMessageLayoutBlock; overload;
    /// The type of block as enumeration. Do not publish!
    property BlockType: TGsSlackMessageLayoutBlockType read GetType;
    /// The type of block. To be published at descendants.
    property TypeAsString: SlackString read GetTypeAsString write SetTypeAsString;
    /// A string acting as a unique identifier for a block. You can use this
    // block_id when you receive an interaction payload to identify the source
    // of the action. If not specified, one will be generated. Maximum length
    // for this field is 255 characters. block_id should be unique for each
    // message and each iteration of a message. If a message is updated, use a
    // new block_id. To be published at descendants.
    property BlockId: SlackString read FBlockId write FBlockId stored IsBlockIdStored;
  end;

  TGsSlackMessageLayoutBlocks = array of TGsSlackMessageLayoutBlock;

  TGsSlackMLBSection = class(TGsSlackMessageLayoutBlock)
  private
    FText:      TGsSlackMCOText;
    FFields:    TGsSlackMCOTexts;
    FAccessory: TGsSlackMessageBlockElement;
    function IsAccessoryStored: Boolean;
    function IsFieldsStored: Boolean;
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageLayoutBlockType; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddField(ATextType: TGsSlackTextType = ttMrkdwn): TGsSlackMCOText;
  published
    /// The type of block. For a section block, type will always be section.
    property TypeAsString;
    /// The text for the block, in the form of a text object. Maximum length for
    // the text in this field is 3000 characters.
    property Text: TGsSlackMCOText read FText;
    /// A string acting as a unique identifier for a block. You can use this
    // block_id when you receive an interaction payload to identify the source
    // of the action. If not specified, one will be generated. Maximum length
    // for this field is 255 characters. block_id should be unique for each
    // message and each iteration of a message. If a message is updated, use a
    // new block_id.
    property BlockId;
    /// An array of text objects. Any text objects included with fields will be
    // rendered in a compact format that allows for 2 columns of side-by-side
    // text. Maximum number of items is 10. Maximum length for the text in each
    // item is 2000 characters. Click here for an example.
    property Fields: TGsSlackMCOTexts read FFields stored IsFieldsStored;
    /// One of the available element objects.
    property Accessory: TGsSlackMessageBlockElement read FAccessory write FAccessory stored IsAccessoryStored;
  end;

  TGsSlackMLBDivider = class(TGsSlackMessageLayoutBlock)
  private
  protected
    //procedure Validate; override;
    function GetType: TGsSlackMessageLayoutBlockType; override;
  public
  published
    /// The type of block. For a divider block, type is always divider.
    property TypeAsString;
    /// A string acting as a unique identifier for a block. You can use this
    // block_id when you receive an interaction payload to identify the source
    // of the action. If not specified, one will be generated. Maximum length
    // for this field is 255 characters.
    property BlockId;
  end;

  TGsSlackMLBImage = class(TGsSlackMessageLayoutBlock)
  private
  protected
    //procedure Validate; override;
    function GetType: TGsSlackMessageLayoutBlockType; override;
  public
  published
    /// The type of block. For an image block, type is always image.
    property TypeAsString;
(*
image_url   String   Yes   The URL of the image to be displayed. Maximum length for this field is 3000 characters.
alt_text   String   Yes   A plain-text summary of the image. This should not contain any markup. Maximum length for this field is 2000 characters.
title   Object   No   An optional title for the image in the form of a text object that can only be of type: plain_text. Maximum length for the text in this field is 2000 characters.
*)
    /// A string acting as a unique identifier for a block. You can use this
    // block_id when you receive an interaction payload to identify the source
    // of the action. If not specified, a block_id will be generated. Maximum
    // length for this field is 255 characters.
    property BlockId;
  end;

  TGsSlackMLBActions = class(TGsSlackMessageLayoutBlock)
  private
    FElements: TGsSlackMessageBlockElements;
    function IsElementsStored: Boolean;
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageLayoutBlockType; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    /// The type of block. For an actions block, type is always actions.
    property TypeAsString;
    /// An array of interactive element objects - buttons, select menus,
    // overflow menus, or date pickers. There is a maximum of 5 elements in each
    // action block.
    property Elements: TGsSlackMessageBlockElements read FElements stored IsElementsStored;
    /// A string acting as a unique identifier for a block. You can use this
    // block_id when you receive an interaction payload to identify the source
    // of the action. If not specified, a block_id will be generated. Maximum
    // length for this field is 255 characters.
    property BlockId;
  end;

  TGsSlackMLBContext = class(TGsSlackMessageLayoutBlock)
  private
    FElements: TGsSlackMessageContentObjects;
    function IsElementsStored: Boolean;
  protected
    procedure Validate; override;
    function GetType: TGsSlackMessageLayoutBlockType; override;
  public
    function AddText(ATextType: TGsSlackTextType = ttMrkdwn): TGsSlackMCOText;
    function AddImage: TGsSlackMBEImage;
  published
    /// The type of block. For a context block, type is always context.
    property TypeAsString;
    /// An array of image elements and text objects. Maximum number of items is 10.
    property Elements: TGsSlackMessageContentObjects read FElements stored IsElementsStored;
    /// A string acting as a unique identifier for a block. You can use this
    // block_id when you receive an interaction payload to identify the source
    // of the action. If not specified, a block_id will be generated. Maximum
    // length for this field is 255 characters.
    property BlockId;
  end;

  TGsSlackMessage = class(TGsSlackMessageObject)
  private
    FText:     SlackString;
    FBlocks:   TGsSlackMessageLayoutBlocks;
    FThreadTs: SlackString;
    FMrkdwn:   Boolean;
    function IsBlocksStored: Boolean;
    function IsThreadTsStored: Boolean;
  protected
    procedure Validate; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddBlock(ABlockType: TGsSlackMessageLayoutBlockType): TGsSlackMessageLayoutBlock;
    function AddSectionBlock: TGsSlackMLBSection;
    function AddDividerBlock: TGsSlackMLBDivider;
    function AddImageBlock: TGsSlackMLBImage;
    function AddActionsBlock: TGsSlackMLBActions;
    function AddContextBlock: TGsSlackMLBContext;
  published
    /// The usage of this field changes depending on whether you're using blocks
    // or not. If you are, this is used as a fallback string to display in
    // notifications. If you aren't, this is the main body text of the message.
    // It can be formatted as plain text, or with mrkdwn. This field is not
    // enforced as required when using blocks, however it is highly recommended
    // that you include it as the aforementioned fallback.
    property Text: SlackString read FText write FText;
    /// An array of layout blocks in the same format as described in the layout
    // block guide.
    property Blocks: TGsSlackMessageLayoutBlocks read FBlocks stored IsBlocksStored;
    /// An array of legacy secondary attachments. We recommend you use blocks
    // instead.
    //property Attachments
    /// The ID of another un-threaded message to reply to.
    property ThreadTs: SlackString read FThreadTs write FThreadTs stored IsThreadTsStored;
    /// Determines whether the text field is rendered according to mrkdwn
    // formatting or not. Defaults to true.
    property Mrkdwn: Boolean read FMrkdwn write FMrkdwn default True;
  end;

  TGsSlackApi = class(TComponent)
  private
  protected
  public
    //constructor Create(AOwner: TComponent); override;
    //destructor Destroy; override;
    class function SendMessage(AWebhookURL: WebhookURL; AMessage: TGsSlackMessage): WebhookResponse;
  published
  end;

implementation

procedure FreeObjArray(var ObjArray);
begin
  while Length(TObjectDynArray(ObjArray)) > 0 do
  begin
    TObjectDynArray(ObjArray)[High(TObjectDynArray(ObjArray))].Free;
    SetLength(TObjectDynArray(ObjArray), High(TObjectDynArray(ObjArray)));
  end;
end;

{ EGsSlackUnsupportedItem }

constructor EGsSlackUnsupportedItem.Create(ATypeInfo: Pointer; AIndex: Integer);
resourcestring
  SUnsupportedItem = '''%s'' is not a supported item';
begin
  CreateResFmt(@SUnsupportedItem, [GetCaptionFromEnum(ATypeInfo, AIndex)]);
end;

{ EGsSlackMaxError }

constructor EGsSlackMaxError.Create(const AName: string; AMax: Integer);
begin
  CreateFmt(GetMessage, [AName, AMax]);
end;

{ EGsSlackMaxItems }

function EGsSlackMaxItems.GetMessage: string;
resourcestring
  SMaxItemsReached = '''%s'' supports a maximum of %d items';
begin
  Result := SMaxItemsReached;
end;

{ EGsSlackMaxSize }

function EGsSlackMaxSize.GetMessage: string;
resourcestring
  SMaxSizeReached = '''%s'' supports a maximum size of %d characters';
begin
  Result := SMaxSizeReached;
end;

{ TGsSlackObject }

constructor TGsSlackObject.Create;
begin
  inherited;
end;

function TGsSlackObject.JSONOptions: TTextWriterWriteObjectOptions;
begin
  Result := [woDontStoreDefault{, woObjectListWontStoreClassName, woDontStore0}];
end;

function TGsSlackObject.ToJSON: RawJSON;
begin
  Validate;
  Result := ObjectToJSON(Self, JSONOptions);
end;

{ TGsSlackMCOText }

const
  TEXT_TYPES: array [TGsSlackTextType] of SlackString = (
    '',
    'plain_text',
    'mrkdwn'
    );

constructor TGsSlackMCOText.Create;
begin
  inherited;

  FTextType := ttMrkdwn;
end;

function TGsSlackMCOText.GetTypeAsString: SlackString;
begin
  Result := TextTypeToStr(TextType);

  if Result = '' then
    raise EGsSlackUnsupportedItem.Create(TypeInfo(TGsSlackTextType), Ord(TextType));
end;

function TGsSlackMCOText.IsEmojiStored: Boolean;
begin
  Result := TextType = ttPlainText;
end;

function TGsSlackMCOText.IsVerbatimStored: Boolean;
begin
  Result := TextType = ttMrkdwn;
end;

procedure TGsSlackMCOText.SetTypeAsString(const Value: SlackString);
begin
  TextType := StrToTypeText(Value);
end;

class function TGsSlackMCOText.StrToTypeText(
  AValue: SlackString): TGsSlackTextType;
begin
  for Result := Low(Result) to High(Result) do
    if SynCommons.LowerCase(AValue) = TextTypeToStr(Result) then
      Exit;

  Result := ttUnknown;
end;

class function TGsSlackMCOText.TextTypeToStr(
  AType: TGsSlackTextType): SlackString;
begin
  Result := TEXT_TYPES[AType];
end;

procedure TGsSlackMCOText.Validate;
begin
  if FTextType = ttUnknown then
    raise EGsSlackUnsupportedItem.Create(TypeInfo(TGsSlackTextType), Ord(FTextType));
end;

{ TGsSlackMessageBlockElement }

const
  ELEMENT_TYPES: array [TGsSlackMessageBlockElementType] of SlackString = (
    '',
    'image',
    'button',
    'static_select',
    'external_select',
    'users_select',
    'conversations_select',
    'channels_select',
    'overflow',
    'datepicker'
    );

class function TGsSlackMessageBlockElement.CreateMessageBlockElement(
  AElementType: TGsSlackMessageBlockElementType): TGsSlackMessageBlockElement;
var
  ElementClass: TGsSlackMessageBlockElementClass;
begin
  ElementClass := ElementTypeToClass(AElementType);

  if Assigned(ElementClass) then
    Result := ElementClass.Create
  else
    raise EGsSlackUnsupportedItem.Create(TypeInfo(TGsSlackMessageBlockElementType), Ord(AElementType));
end;

class function TGsSlackMessageBlockElement.CreateMessageBlockElement(AElementType: SlackString):
TGsSlackMessageBlockElement;
begin
  Result := CreateMessageBlockElement(StrToElementType(AElementType));
end;

class function TGsSlackMessageBlockElement.ElementTypeToClass(AElementType: TGsSlackMessageBlockElementType):
TGsSlackMessageBlockElementClass;
begin
  case AElementType of
    mbetImage: Result               := TGsSlackMBEImage;
    mbetButton: Result              := nil;
    mbetStaticSelect: Result        := nil;
    mbetExternalSelect: Result      := nil;
    mbetUsersSelect: Result         := nil;
    mbetConversationsSelect: Result := nil;
    mbetChannelsSelect: Result      := nil;
    mbetOverflow: Result            := nil;
    mbetDatePicker: Result          := nil;
  else
    Result := nil;
  end;
end;

function TGsSlackMessageBlockElement.GetTypeAsString: SlackString;
begin
  Result := ELEMENT_TYPES[ElementType];

  if Result = '' then
    raise EGsSlackUnsupportedItem.Create(TypeInfo(TGsSlackMessageBlockElementType), Ord(ElementType));
end;

procedure TGsSlackMessageBlockElement.SetTypeAsString(const Value: SlackString);
begin

end;

class function TGsSlackMessageBlockElement.StrToElementType(AElementType: SlackString):
TGsSlackMessageBlockElementType;
begin
  for Result := Low(Result) to High(Result) do
    if ELEMENT_TYPES[Result] = SynCommons.LowerCase(AElementType) then
      Exit;

  Result := mbetUnknown;
end;

{ TGsSlackMBEImage }

function TGsSlackMBEImage.GetType: TGsSlackMessageBlockElementType;
begin
  Result := mbetImage;
end;

procedure TGsSlackMBEImage.Validate;
begin

end;

{ TGsSlackMBEButton }

function TGsSlackMBEButton.GetType: TGsSlackMessageBlockElementType;
begin
  Result := mbetButton;
end;

procedure TGsSlackMBEButton.Validate;
begin

end;

{ TGsSlackMBEStaticSelect }

function TGsSlackMBEStaticSelect.GetType: TGsSlackMessageBlockElementType;
begin
  Result := mbetStaticSelect;
end;

procedure TGsSlackMBEStaticSelect.Validate;
begin

end;

{ TGsSlackMBEExternalSelect }

function TGsSlackMBEExternalSelect.GetType: TGsSlackMessageBlockElementType;
begin
  Result := mbetExternalSelect;
end;

procedure TGsSlackMBEExternalSelect.Validate;
begin

end;

{ TGsSlackMBEUsersSelect }

function TGsSlackMBEUsersSelect.GetType: TGsSlackMessageBlockElementType;
begin
  Result := mbetUsersSelect;
end;

procedure TGsSlackMBEUsersSelect.Validate;
begin

end;

{ TGsSlackMBEConversationsSelect }

function TGsSlackMBEConversationsSelect.GetType: TGsSlackMessageBlockElementType;
begin
  Result := mbetConversationsSelect;
end;

procedure TGsSlackMBEConversationsSelect.Validate;
begin

end;

{ TGsSlackMBEChannelsSelect }

function TGsSlackMBEChannelsSelect.GetType: TGsSlackMessageBlockElementType;
begin
  Result := mbetChannelsSelect;
end;

procedure TGsSlackMBEChannelsSelect.Validate;
begin

end;

{ TGsSlackMBEOverflow }

function TGsSlackMBEOverflow.GetType: TGsSlackMessageBlockElementType;
begin
  Result := mbetOverflow;
end;

procedure TGsSlackMBEOverflow.Validate;
begin

end;

{ TGsSlackMBEDatePicker }

function TGsSlackMBEDatePicker.GetType: TGsSlackMessageBlockElementType;
begin
  Result := mbetDatePicker;
end;

procedure TGsSlackMBEDatePicker.Validate;
begin

end;

{ TGsSlackMessageLayoutBlock }

const
  BLOCK_TYPES: array [TGsSlackMessageLayoutBlockType] of SlackString = (
    '',
    'section',
    'divider',
    'image',
    'actions',
    'context'
    );

class function TGsSlackMessageLayoutBlock.BlockTypeToClass(ABlockType: TGsSlackMessageLayoutBlockType):
TGsSlackMessageLayoutBlockClass;
begin
  case ABlockType of
    mlbtSection: Result := TGsSlackMLBSection;
    mlbtDivider: Result := TGsSlackMLBDivider;
    mlbtImage: Result   := TGsSlackMLBImage;
    mlbtActions: Result := TGsSlackMLBActions;
    mlbtContext: Result := TGsSlackMLBContext;
  else
    Result := nil;
  end;
end;

class function TGsSlackMessageLayoutBlock.CreateMessageLayoutBlock(
  ABlockType: TGsSlackMessageLayoutBlockType): TGsSlackMessageLayoutBlock;
var
  BlockClass: TGsSlackMessageLayoutBlockClass;
begin
  BlockClass := BlockTypeToClass(ABlockType);

  if Assigned(BlockClass) then
    Result := BlockClass.Create
  else
    raise EGsSlackUnsupportedItem.Create(TypeInfo(TGsSlackMessageLayoutBlockType), Ord(ABlockType));
end;

class function TGsSlackMessageLayoutBlock.CreateMessageLayoutBlock(ABlockType: SlackString):
TGsSlackMessageLayoutBlock;
begin
  Result := CreateMessageLayoutBlock(StrToBlockType(ABlockType));
end;

function TGsSlackMessageLayoutBlock.GetTypeAsString: SlackString;
begin
  Result := BLOCK_TYPES[BlockType];

  if Result = '' then
    raise EGsSlackUnsupportedItem.Create(TypeInfo(TGsSlackMessageLayoutBlockType), Ord(BlockType));
end;

function TGsSlackMessageLayoutBlock.IsBlockIdStored: Boolean;
begin
  Result := BlockId <> '';
end;

procedure TGsSlackMessageLayoutBlock.SetTypeAsString(const Value: SlackString);
begin

end;

class function TGsSlackMessageLayoutBlock.StrToBlockType(ABlockType: SlackString): TGsSlackMessageLayoutBlockType;
begin
  for Result := Low(Result) to High(Result) do
    if BLOCK_TYPES[Result] = SynCommons.LowerCase(ABlockType) then
      Exit;

  Result := mlbtUnknown;
end;

procedure TGsSlackMessageLayoutBlock.Validate;
begin
  if Length(FBlockId) > 255 then
    raise EGsSlackMaxSize.Create('LayoutBlock.BlockId', 255);
end;

{ TGsSlackMLBSection }

function TGsSlackMLBSection.AddField(ATextType: TGsSlackTextType): TGsSlackMCOText;
begin
  if Length(FFields) >= 10 then
    raise EGsSlackMaxItems.Create('SectionBlock.Fields', 10);

  Result          := TGsSlackMCOText.Create;
  Result.TextType := ATextType;
  SetLength(FFields, Length(FFields) + 1);
  FFields[High(FFields)] := Result;
end;

constructor TGsSlackMLBSection.Create;
begin
  inherited;

  FText := TGsSlackMCOText.Create;
end;

destructor TGsSlackMLBSection.Destroy;
begin
  if Assigned(FAccessory) then
    FAccessory.Free;

  FreeObjArray(FFields);
  FText.Free;

  inherited;
end;

function TGsSlackMLBSection.GetType: TGsSlackMessageLayoutBlockType;
begin
  Result := mlbtSection;
end;

function TGsSlackMLBSection.IsAccessoryStored: Boolean;
begin
  Result := Assigned(FAccessory);
end;

function TGsSlackMLBSection.IsFieldsStored: Boolean;
begin
  Result := Length(FFields) > 0;
end;

procedure TGsSlackMLBSection.Validate;
var
  I: Integer;
begin
  inherited;

  if Length(FText.FText) > 3000 then
    raise EGsSlackMaxSize.Create('Section.Text', 3000);

  for I := Low(FFields) to High(FFields) do
    if Length(FFields[I].FText) > 2000 then
      raise EGsSlackMaxSize.Create('Section.Fields.Text', 2000);
end;

{ TGsSlackMLBDivider }

function TGsSlackMLBDivider.GetType: TGsSlackMessageLayoutBlockType;
begin
  Result := mlbtDivider;
end;

{ TGsSlackMLBImage }

function TGsSlackMLBImage.GetType: TGsSlackMessageLayoutBlockType;
begin
  Result := mlbtImage;
end;

{ TGsSlackMLBActions }

constructor TGsSlackMLBActions.Create;
begin
  inherited;

  //FElementsDA := TObjectDynArrayWrapper.Create(FElements);
end;

destructor TGsSlackMLBActions.Destroy;
begin
  FreeObjArray(FElements);
  //FElementsDA.Free;

  inherited;
end;

function TGsSlackMLBActions.GetType: TGsSlackMessageLayoutBlockType;
begin
  Result := mlbtActions;
end;

function TGsSlackMLBActions.IsElementsStored: Boolean;
begin
  Result := Length(FElements) > 0;
end;

procedure TGsSlackMLBActions.Validate;
begin
  inherited;

  if Length(FElements) > 5 then
    raise EGsSlackMaxItems.Create('Actions.Elements', 5);
end;

{ TGsSlackMLBContext }

function TGsSlackMLBContext.AddImage: TGsSlackMBEImage;
begin
  if Length(FElements) >= 10 then
    raise EGsSlackMaxItems.Create('Context.Elements', 10);

  Result := TGsSlackMBEImage.Create;
  SetLength(FElements, Length(FElements) + 1);
  FElements[High(FElements)] := Result;
end;

function TGsSlackMLBContext.AddText(ATextType: TGsSlackTextType): TGsSlackMCOText;
begin
  if Length(FElements) >= 10 then
    raise EGsSlackMaxItems.Create('Context.Elements', 10);

  Result          := TGsSlackMCOText.Create;
  Result.TextType := ATextType;
  SetLength(FElements, Length(FElements) + 1);
  FElements[High(FElements)] := Result;
end;

function TGsSlackMLBContext.GetType: TGsSlackMessageLayoutBlockType;
begin
  Result := mlbtContext;
end;

function TGsSlackMLBContext.IsElementsStored: Boolean;
begin
  Result := Length(Elements) > 0;
end;

procedure TGsSlackMLBContext.Validate;
begin
  inherited;

  if Length(FElements) > 10 then
    raise EGsSlackMaxItems.Create('Context.Elements', 10);
end;

{ TGsSlackMessage }

function TGsSlackMessage.AddActionsBlock: TGsSlackMLBActions;
begin
  Result := AddBlock(mlbtActions) as TGsSlackMLBActions;
end;

function TGsSlackMessage.AddBlock(ABlockType: TGsSlackMessageLayoutBlockType): TGsSlackMessageLayoutBlock;
begin
  Result := TGsSlackMessageLayoutBlock.CreateMessageLayoutBlock(ABlockType);
  SetLength(FBlocks, Length(FBlocks) + 1);
  FBlocks[High(FBlocks)] := Result;
end;

function TGsSlackMessage.AddContextBlock: TGsSlackMLBContext;
begin
  Result := AddBlock(mlbtContext) as TGsSlackMLBContext;
end;

function TGsSlackMessage.AddDividerBlock: TGsSlackMLBDivider;
begin
  Result := AddBlock(mlbtDivider) as TGsSlackMLBDivider;
end;

function TGsSlackMessage.AddImageBlock: TGsSlackMLBImage;
begin
  Result := AddBlock(mlbtImage) as TGsSlackMLBImage;
end;

function TGsSlackMessage.AddSectionBlock: TGsSlackMLBSection;
begin
  Result := AddBlock(mlbtSection) as TGsSlackMLBSection;
end;

constructor TGsSlackMessage.Create;
begin
  inherited;

  FMrkdwn := True;
end;

destructor TGsSlackMessage.Destroy;
begin
  FreeObjArray(FBlocks);

  inherited;
end;

function TGsSlackMessage.IsBlocksStored: Boolean;
begin
  Result := Length(FBlocks) > 0;
end;

function TGsSlackMessage.IsThreadTsStored: Boolean;
begin
  Result := ThreadTs <> '';
end;

procedure TGsSlackMessage.Validate;
begin

end;

{ TGsSlackApi }

class function TGsSlackApi.SendMessage(AWebhookURL: WebhookURL; AMessage: TGsSlackMessage): WebhookResponse;
var
  JSON: RawUTF8;
begin
  JSON := AMessage.ToJSON;

  Result := TWinHTTP.Post(AWebhookURL, JSON, 'Content-Type: application/json', False);
end;

initialization
  //TJSONSerializer.RegisterCustomSerializer(TGsSlackObject, TGsSlackObject.SlackReader, TGsSlackObject.SlackWriter);
  TJSONSerializer.RegisterCustomSerializerFieldNames(TGsSlackMCOText,
    ['TypeAsString', 'Text', 'Emoji', 'Verbatim'],
    ['type', 'text', 'emoji', 'verbatim']);
  (*
  TJSONSerializer.RegisterCustomSerializerFieldNames(TGsSlackMessageLayoutBlock,
    ['TypeAsString', 'BlockId'],
    ['type', 'block_id']);
  *)
  TJSONSerializer.RegisterCustomSerializerFieldNames(TGsSlackMLBSection,
    ['TypeAsString', 'BlockId', 'Text', 'Fields', 'Accessory'],
    ['type', 'block_id', 'text', 'fields', 'accessory']);
  TJSONSerializer.RegisterCustomSerializerFieldNames(TGsSlackMLBDivider,
    ['TypeAsString', 'BlockId'],
    ['type', 'block_id']);
  TJSONSerializer.RegisterCustomSerializerFieldNames(TGsSlackMLBImage,
    ['TypeAsString', 'BlockId'],
    ['type', 'block_id']);
  TJSONSerializer.RegisterCustomSerializerFieldNames(TGsSlackMLBActions,
    ['TypeAsString', 'BlockId', 'Elements'],
    ['type', 'block_id', 'elements']);
  TJSONSerializer.RegisterCustomSerializerFieldNames(TGsSlackMLBContext,
    ['TypeAsString', 'BlockId', 'Elements'],
    ['type', 'block_id', 'elements']);
  TJSONSerializer.RegisterCustomSerializerFieldNames(TGsSlackMessage,
    ['Text', 'Blocks', 'ThreadTs', 'Mrkdwn'],
    ['text', 'blocks', 'thread_ts', 'mrkdwn']);
  //TJSONSerializer.RegisterClassForJSON([TGsSlackTextObjects, TGsSlackMessageBlockElements, TGsSlackMessageLayoutBlocks]);
  TJSONSerializer.RegisterObjArrayForJSON([                                        // dummy content to prevent styling
    TypeInfo(TGsSlackMessageContentObjects), TGsSlackMessageContentObject,         // content object array
    TypeInfo(TGsSlackMessageCompositionObjects), TGsSlackMessageCompositionObject, // composition object array
    TypeInfo(TGsSlackMCOTexts), TGsSlackMCOText,                                   // text arrays
    TypeInfo(TGsSlackMessageBlockElements), TGsSlackMessageBlockElement,           // block element arrays
    TypeInfo(TGsSlackMessageLayoutBlocks), TGsSlackMessageLayoutBlock              // layout block arrays
    ]);

(*
class function TGsSlackMCOText.SlackReader(const aValue: TObject; aFrom: PUTF8Char; var aValid: Boolean;
  aOptions: TJSONToObjectOptions): PUTF8Char;
var
  Values: array[0..3] of TValuePUTF8Char;
begin // '{"Major":2,"Minor":2002,"Release":3002,"Build":4002,"Main":"2","BuildDateTime":"1911-03-15"}'
  Result := JSONDecode(aFrom, ['type', 'text', 'emoji', 'verbatim'], @Values);
  aValid := (Result <> nil);
  if aValid then
    with aValue as TGsSlackMCOText do
    begin
      TypeAsString := Values[0].ToUTF8;
      Text         := Values[1].ToUTF8;

      if Values[2].Value <> nil then
        Emoji := GetBoolean(Values[2].Value);

      if Values[3].Value <> nil then
        Verbatim := GetBoolean(Values[3].Value);
    end;
end;

class procedure TGsSlackMCOText.SlackWriter(const aSerializer: TJSONSerializer; aValue: TObject;
  aOptions: TTextWriterWriteObjectOptions);
begin
  with aValue as TGsSlackMCOText do
  begin
    aSerializer.AddJSONEscape(['type', TypeAsString, 'text', Text]);

    if TextType = ttPlainText then
      aSerializer.AddJSONEscape(['emoji', Emoji]);

    if TextType = ttMrkdwn then
      aSerializer.AddJSONEscape(['verbatim', Verbatim]);
  end;
end;

class function TGsSlackMessageLayoutBlock.SlackReader(const aValue: TObject; aFrom: PUTF8Char;
  var aValid: Boolean; aOptions: TJSONToObjectOptions): PUTF8Char;
begin

end;

class procedure TGsSlackMessageLayoutBlock.SlackWriter(const aSerializer: TJSONSerializer;
  aValue: TObject; aOptions: TTextWriterWriteObjectOptions);
begin
  with aValue as TGsSlackMessageLayoutBlock do
  begin
    aSerializer.AddJSONEscape(['type', TypeAsString]);

    if BlockId <> '' then
      aSerializer.AddJSONEscape(['block_id', BlockId]);
  end;
end;

class function TGsSlackMLBSection.SlackReader(const aValue: TObject; aFrom: PUTF8Char;
  var aValid: Boolean; aOptions: TJSONToObjectOptions): PUTF8Char;
begin

end;

class procedure TGsSlackMLBSection.SlackWriter(const aSerializer: TJSONSerializer;
  aValue: TObject; aOptions: TTextWriterWriteObjectOptions);
begin
  inherited;

  with aValue as TGsSlackMessageLayoutBlock do
  begin
    aSerializer.AddJSONEscape(['type', TypeAsString]);

    if BlockId <> '' then
      aSerializer.AddJSONEscape(['block_id', BlockId]);
  end;
end;

class function TGsSlackMLBDivider.SlackReader(const aValue: TObject; aFrom: PUTF8Char;
  var aValid: Boolean; aOptions: TJSONToObjectOptions): PUTF8Char;
begin

end;

class procedure TGsSlackMLBDivider.SlackWriter(const aSerializer: TJSONSerializer;
  aValue: TObject; aOptions: TTextWriterWriteObjectOptions);
begin
  inherited;

  with aValue as TGsSlackMessageLayoutBlock do
  begin
    aSerializer.AddJSONEscape(['type', TypeAsString]);

    if BlockId <> '' then
      aSerializer.AddJSONEscape(['block_id', BlockId]);
  end;
end;

class function TGsSlackMLBImage.SlackReader(const aValue: TObject; aFrom: PUTF8Char;
  var aValid: Boolean; aOptions: TJSONToObjectOptions): PUTF8Char;
begin

end;

class procedure TGsSlackMLBImage.SlackWriter(const aSerializer: TJSONSerializer;
  aValue: TObject; aOptions: TTextWriterWriteObjectOptions);
begin
  inherited;

  with aValue as TGsSlackMessageLayoutBlock do
  begin
    aSerializer.AddJSONEscape(['type', TypeAsString]);

    if BlockId <> '' then
      aSerializer.AddJSONEscape(['block_id', BlockId]);
  end;
end;

class function TGsSlackMLBActions.SlackReader(const aValue: TObject; aFrom: PUTF8Char;
  var aValid: Boolean; aOptions: TJSONToObjectOptions): PUTF8Char;
begin

end;

class procedure TGsSlackMLBActions.SlackWriter(const aSerializer: TJSONSerializer;
  aValue: TObject; aOptions: TTextWriterWriteObjectOptions);
begin
  inherited;

  with aValue as TGsSlackMessageLayoutBlock do
  begin
    aSerializer.AddJSONEscape(['type', TypeAsString]);

    if BlockId <> '' then
      aSerializer.AddJSONEscape(['block_id', BlockId]);
  end;
end;

class function TGsSlackMLBContext.SlackReader(const aValue: TObject; aFrom: PUTF8Char;
  var aValid: Boolean; aOptions: TJSONToObjectOptions): PUTF8Char;
begin

end;

class procedure TGsSlackMLBContext.SlackWriter(const aSerializer: TJSONSerializer;
  aValue: TObject; aOptions: TTextWriterWriteObjectOptions);
begin
  inherited;

  with aValue as TGsSlackMessageLayoutBlock do
  begin
    aSerializer.AddJSONEscape(['type', TypeAsString]);

    if BlockId <> '' then
      aSerializer.AddJSONEscape(['block_id', BlockId]);
  end;
end;

class function TGsSlackMessage.SlackReader(const aValue: TObject; aFrom: PUTF8Char;
  var aValid: Boolean; aOptions: TJSONToObjectOptions): PUTF8Char;
begin

end;

class procedure TGsSlackMessage.SlackWriter(const aSerializer: TJSONSerializer; aValue: TObject;
  aOptions: TTextWriterWriteObjectOptions);
begin
  with aValue as TGsSlackMessage do
  begin
    aSerializer.AddJSONEscape(['text', Text]);
    aSerializer.AddDynArrayJSONAsString(TypeInfo(TGsSlackMessageLayoutBlocks), FBlocks);
  end;
end;


*)
end.

