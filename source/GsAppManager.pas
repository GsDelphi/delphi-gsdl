unit GsAppManager;

interface

uses
  BPSettings,
  BPSettingsDBADO,
  Classes,
  Controls,
  SysUtils,
  Windows;

type
  EGsAppMgrSettings = class(Exception);
  EGsAppMgrSettingsInitialization = class(EGsAppMgrSettings);


  TGsFileItem = class;
  TAbstractGsPackage  = class;


  TGsFileInfo = class(TPersistent)
  private
    FFileItem:   TGsFileItem;
    FVersion:    string;
    FName:       string;
    FAttributes: Cardinal;
    FTime:       TDateTime;
  protected
  public
    constructor Create(FileItem: TGsFileItem); virtual;
    destructor Destroy; override;

    property FileItem: TGsFileItem read FFileItem;
  published
    property Name: string read FName write FName;
    property Time: TDateTime read FTime write FTime;
    property Attributes: Cardinal read FAttributes write FAttributes;
    property Version: string read FVersion write FVersion;
  end;

  TGsFileItem = class(TCollectionItem)
  private
    FInfo: TGsFileInfo;
    FData: TMemoryStream;
    procedure DataRead(Stream: TStream);
    procedure DataWrite(Stream: TStream);
  protected
    { TPersistent }
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);
  published
    property Info: TGsFileInfo read FInfo write FInfo;
    //property Data: string read FFileData write FFileData;
  end;

  TGsPackageContent = class(TOwnedCollection)
  private
    FBasePath: string;
    procedure SetBasePath(const Value: string);
  protected
  public
    constructor Create(AOwner: TPersistent);

    property BasePath: string read FBasePath write SetBasePath;
  published
  end;

  TGsPackageHeader = class(TPersistent)
  private
    FOwner: TAbstractGsPackage;
  protected
  public
    //constructor Create(AOwner: TAbstractGsPackage);
  published
    //property Version: Cardinal read FVersion write FVersion;
    //property GUID: TGUID read FGUID write FGUID;
  end;

  TAbstractGsPackage = class(TComponent)
  private
    FHeader: TGsPackageHeader;
    FContent: TGsPackageContent;
    procedure ReadContent(Stream: TStream);
    procedure WriteContent(Stream: TStream);
  protected
    { TPersistent }
    procedure DefineProperties(Filer: TFiler); override;

    { Class methods }
    class function Id: TGUID; virtual; abstract;
    class function Key: string; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);

    procedure ExtractFiles(const Dir: string);

    procedure AddFile(const AFileName: string);

    property Content: TGsPackageContent read FContent;
  published
    property Header: TGsPackageHeader read FHeader;
  end;

  TGsAppMgrApplicationImage = class(TCustomBPSubSettings)
  private
    FFileName:       TBPSPString;
    FFileTime:       TBPSPDateTime;
    FFileAttributes: TBPSPCardinal;
    FFileVersion:    TBPSPString;
    FData:           TBPSPBinaryString;
  protected
    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);

    { Properties }
    property FileName: TBPSPString read FFileName;
    property FileTime: TBPSPDateTime read FFileTime;
    property FileAttributes: TBPSPCardinal read FFileAttributes;
    property FileVersion: TBPSPString read FFileVersion;
    property Data: TBPSPBinaryString read FData;
  end;

  TCustomGsAppMgrApplicationImage = class(TAbstractBPSettingsPropertyListItem)
  private
    FImage: TGsAppMgrApplicationImage;
    function GetImagePath: string;
  protected
    { TAbstractBPSettings }
    procedure CreateProperties; override;
  public
    procedure Execute;

    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);

    { Properties }
    property Image: TGsAppMgrApplicationImage read FImage;

    property ImagePath: string read GetImagePath;
  end;

  TGsAppMgrApplicationImages = class(TBPSettingsPropertyList)
  private
    function GetActive: TCustomGsAppMgrApplicationImage;
    function GetImage(Index: Integer): TCustomGsAppMgrApplicationImage;
  public
    property Active: TCustomGsAppMgrApplicationImage read GetActive;
    property Images[Index: Integer]: TCustomGsAppMgrApplicationImage read GetImage;
      default;
  end;

  TCustomGsAppMgrApplication = class(TAbstractBPSettingsPropertyListItem)
  private
    FGUID:   TBPSPGUID;
    FImages: TGsAppMgrApplicationImages;
    function GetGUID: TGUID;
  protected
    { TAbstractBPSettings }
    procedure CreateProperties; override;

    { Methods }
    class function ApplicationId: TGUID; virtual; abstract;

    { Properties }
    property _GUID: TBPSPGUID read FGUID;
  public
    procedure Execute;

    { Properties }
    property GUID: TGUID read GetGUID;
    property Images: TGsAppMgrApplicationImages read FImages;
    //property ImagePath: string read GetImagePath;
  end;

  TGsAppMgrApplications = class(TBPSettingsPropertyList)
  private
    function GetApplication(GUID: TGUID): TCustomGsAppMgrApplication;
  public
    function FindGUID(GUID: TGUID): TCustomGsAppMgrApplication;

    property Applications[GUID: TGUID]: TCustomGsAppMgrApplication read GetApplication;
      default;
  end;

  TGsAppManagerSettings = class(TBPSettings)
  private
    FApplicationDatabaseADO: TBPSSDBADO;
    procedure SetApplicationDatabaseADO(const Value: TBPSSDBADO);
  protected
    { IBPSettingsSupport }
    function GetName: TComponentName; override;
    function GetStorePath: string; override;

    { IBPSettingsEditorSupport }
    //function GetCaption: TCaption; override;
    function GetHint: string; override;
    //function GetImagesBig: TImageList; override;
    //function GetImagesSmall: TImageList; override;
  public
    //constructor Create; override;
    //destructor Destroy; override;

    { Instance access }
    class function Instance: TGsAppManagerSettings; overload; virtual;
    class function Instance(ApplicationDatabase: TBPSSDBADO): TGsAppManagerSettings;
      overload; virtual;

    { Properties }
    property ApplicationDatabaseADO: TBPSSDBADO
      read FApplicationDatabaseADO write SetApplicationDatabaseADO;
  end;

implementation

uses
  BPInfo,
  BPSysUtils,
  GsStreams,
  GsZLib,
  JclFileUtils;

const
  AppManagerSettingsName = 'GsAppManager';

resourcestring
  SAppManagerSettingsCaption = 'Einstellungen';
  SAppManagerSettingsHint = 'Application Manager Einstellungen';

var
  LUserName, LComputerName: string;
  LSettings: TGsAppManagerSettings;

function GetUserName: string;
var
  Size: DWORD;
begin
  if (LUserName = '') then
  begin
    Windows.GetUserName(nil, Size);

    SetLength(LUserName, Size * SizeOf(LUserName[1]));

    if not Windows.GetUserName(@LUserName[1], Size) then
      LUserName := '';
  end;

  Result := LUserName;
end;

function GetComputerName: string;
var
  Size: DWORD;
begin
  if (LComputerName = '') then
  begin
    Windows.GetComputerNameEx(ComputerNameDnsFullyQualified, nil, Size);

    SetLength(LComputerName, Size * SizeOf(LComputerName[1]));

    if not Windows.GetComputerNameEx(ComputerNameDnsFullyQualified,
      @LComputerName[1], Size) then
      LComputerName := '';
  end;

  Result := LComputerName;
end;

function FileTimeToDateTime(AFileTime: TFileTime): TDateTime;
var
  LFileTime: TFileTime;
  SysTime: TSystemTime;
begin
  Result := 0;

  if FileTimeToLocalFileTime(AFileTime, LFileTime) then
    if FileTimeToSystemTime(LFileTime, SysTime) then
      Result := SystemTimeToDateTime(SysTime);
end;

function DateTimeToFileTime(ADateTime: TDateTime): TFileTime;
var
  LFileTime: TFileTime;
  SysTime: TSystemTime;
begin
  Result.dwLowDateTime  := 0;
  Result.dwHighDateTime := 0;

  DateTimeToSystemTime(ADateTime, SysTime);

  if SystemTimeToFileTime(SysTime, LFileTime) then
    LocalFileTimeToFileTime(LFileTime, Result);
end;

{ TGsFileInfo }

constructor TGsFileInfo.Create(FileItem: TGsFileItem);
begin
  inherited Create;

  FFileItem := FileItem;
end;

destructor TGsFileInfo.Destroy;
begin

  inherited;
end;

{ TGsFileItem }

constructor TGsFileItem.Create(Collection: TCollection);
begin
  inherited;

  FInfo := TGsFileInfo.Create(Self);
  FData := TMemoryStream.Create;
end;

procedure TGsFileItem.DataRead(Stream: TStream);
begin
  FData.LoadFromStream(Stream);
end;

procedure TGsFileItem.DataWrite(Stream: TStream);
begin
  FData.SaveToStream(Stream);
end;

procedure TGsFileItem.DefineProperties(Filer: TFiler);

  function HasData: Boolean;
  begin
    Result := (FData.Size > 0);
  end;

begin
  inherited;

  Filer.DefineBinaryProperty('Data', DataRead, DataWrite, HasData);
end;

destructor TGsFileItem.Destroy;
begin
  FData.Free;
  FInfo.Free;

  inherited;
end;

procedure TGsFileItem.LoadFromFile(const AFileName: string);
begin

end;

procedure TGsFileItem.SaveToFile(const AFileName: string);
begin

end;

{ TGsPackageContent }

constructor TGsPackageContent.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TGsFileItem);
end;

procedure TGsPackageContent.SetBasePath(const Value: string);
begin
  if (Length(FBasePath) = 0) then
    FBasePath := Value;

  if (FBasePath = '') then
    FBasePath := Value;
end;

{ TAbstractGsPackage }

procedure TAbstractGsPackage.AddFile(const AFileName: string);
begin
  //Files.BasePath := ExtractFilePath(AFileName);
  //Files.Add;
end;

constructor TAbstractGsPackage.Create(AOwner: TComponent);
begin
  inherited;

  //FFiles := TGsPackageContent.Create(Self);
end;

procedure TAbstractGsPackage.DefineProperties(Filer: TFiler);
begin
  inherited;

  Filer.DefineBinaryProperty('Content', ReadContent, WriteContent, True);
end;

destructor TAbstractGsPackage.Destroy;
begin
  //FFiles.Free;

  inherited;
end;

procedure TAbstractGsPackage.ExtractFiles(const Dir: string);
begin

end;

procedure TAbstractGsPackage.LoadFromFile(const AFileName: string);
begin
  ReadComponentResFile(AFileName, Self);
end;

procedure TAbstractGsPackage.ReadContent(Stream: TStream);
begin

end;

procedure TAbstractGsPackage.SaveToFile(const AFileName: string);
begin
  WriteComponentResFile(AFileName, Self);
end;

procedure TAbstractGsPackage.WriteContent(Stream: TStream);
(*
var
  Content: T*)
begin
//  Writer
end;

{ TGsAppMgrApplicationImage }

procedure TGsAppMgrApplicationImage.CreateProperties;
begin
  inherited;

end;

procedure TGsAppMgrApplicationImage.LoadFromFile(const AFileName: string);
var
  FileStream: TFileStream;
  StringStream: TStringStream;
  CompressionStream: TZCompressionStream;
  FileInfo: TByHandleFileInformation;
  FileVersionInfo: TJclFileVersionInfo;
begin
  FileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);

  try
    if Windows.GetFileInformationByHandle(FileStream.Handle, FileInfo) then
    begin
      FileName.Value := AFileName;
      FileTime.Value := FileTimeToDateTime(FileInfo.ftCreationTime);
      FileAttributes.Value := FileInfo.dwFileAttributes;

      FileVersionInfo := TJclFileVersionInfo.Create(FileStream.Handle);
      //FileVersionInfo := TJclFileVersionInfo.Create(Stream.Handle AFileName);

      try
        FileVersion.Value := FileVersionInfo.BinFileVersion;
      finally
        FileVersionInfo.Free;
      end;

      //FILE_ATTRIBUTE_

      StringStream := TStringStream.Create;

      try
        CompressionStream := TZCompressionStream.Create(StringStream, zcMax);

        try
          CompressionStream.CopyFrom(FileStream, 0);
          Data.Value := StringStream.DataString;
        finally
          CompressionStream.Free;
        end;
      finally
        StringStream.Free;
      end;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TGsAppMgrApplicationImage.SaveToFile(const AFileName: string);
var
  FileStream: TFileStream;
  StringStream: TStringStream;
  CompressionStream: TZDecompressionStream;
begin
  FileStream := TFileStream.Create(AFileName, fmCreate);

  try
    StringStream := TStringStream.Create(Data.Value);

    try
      CompressionStream := TZDecompressionStream.Create(StringStream);

      try
        FileStream.CopyFrom(CompressionStream, 0);
      finally
        CompressionStream.Free;
      end;
    finally
      StringStream.Free;
    end;

  finally
    FileStream.Free;

    SetFileCreation(AFileName, FileTime.Value);
    SetFileAttributes(LPCWSTR(AFileName), FileAttributes.Value);
  end;
end;

{ TCustomGsAppMgrApplicationImage }

procedure TCustomGsAppMgrApplicationImage.CreateProperties;
begin
  inherited;

end;

procedure TCustomGsAppMgrApplicationImage.Execute;
begin

end;

function TCustomGsAppMgrApplicationImage.GetImagePath: string;
begin
  Result := GetKnownFolderPath(kfiLocalAppDataPrograms, [kffCreate]) +
    BPCompanyName + PathDelim + BPProductName + PathDelim +
    Image.FileVersion.Value + PathDelim;

  ForceDirectories(Result);
end;

procedure TCustomGsAppMgrApplicationImage.LoadFromFile(const AFileName: string);
begin
  Image.LoadFromFile(AFileName);
end;

procedure TCustomGsAppMgrApplicationImage.SaveToFile(const AFileName: string);
begin
  Image.SaveToFile(AFileName);
end;

{ TGsAppMgrApplicationImages }

function TGsAppMgrApplicationImages.GetActive: TCustomGsAppMgrApplicationImage;
begin
  GetUserName;
  GetComputerName;
end;

function TGsAppMgrApplicationImages.GetImage(Index: Integer):
TCustomGsAppMgrApplicationImage;
begin

end;

{ TCustomGsAppMgrApplication }

procedure TCustomGsAppMgrApplication.CreateProperties;
resourcestring
  SGUID = '';
  SGUIDHint = '';
begin
  inherited;

  FGUID := TBPSPGUID.CreateGuid(Self, 'GUID', @SGUID, @SGUIDHint, ApplicationId);
end;

procedure TCustomGsAppMgrApplication.Execute;
begin

end;

function TCustomGsAppMgrApplication.GetGUID: TGUID;
begin
  Result := _GUID.GUID;
end;

{ TGsAppMgrApplications }

function TGsAppMgrApplications.FindGUID(GUID: TGUID): TCustomGsAppMgrApplication;
var
  I: Integer;
begin
  I := 0;

  while (I < Count) do
  begin
    Result := TCustomGsAppMgrApplication(Items[I]);

    if (Result.GUID = GUID) then
      Exit;

    Inc(I);
  end;

  Result := nil;
end;

function TGsAppMgrApplications.GetApplication(GUID: TGUID): TCustomGsAppMgrApplication;
begin
  Result := FindGUID(GUID);
end;

{ TGsAppManagerSettings }

function TGsAppManagerSettings.GetHint: string;
begin
  Result := SAppManagerSettingsHint;
end;

function TGsAppManagerSettings.GetName: TComponentName;
begin
  Result := AppManagerSettingsName;
end;

function TGsAppManagerSettings.GetStorePath: string;
begin
  Result := AppManagerSettingsName;
end;

class function TGsAppManagerSettings.Instance: TGsAppManagerSettings;
begin
  if (LSettings = nil) then
    raise EGsAppMgrSettingsInitialization.Create(
      'Call to TGsAppManagerSettings.Instance(ApplicationDatabase) missing.');

  Result := LSettings;
end;

class function TGsAppManagerSettings.Instance(
  ApplicationDatabase: TBPSSDBADO): TGsAppManagerSettings;
begin
  if (LSettings = nil) then
  begin
    LSettings := Self.Create;
    LSettings.ApplicationDatabaseADO := ApplicationDatabase;
  end;

  Result := Instance;
end;

procedure TGsAppManagerSettings.SetApplicationDatabaseADO(const Value: TBPSSDBADO);
begin
  if (FApplicationDatabaseADO = nil) then
    FApplicationDatabaseADO := Value;
end;

initialization
  LSettings := nil;

finalization
  LSettings.Free;
end.

