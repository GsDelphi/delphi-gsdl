{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2018 Simon Gilli
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
unit GsTheme;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Graphics,
  GsThemeMgr,
  Vcl.ImgList,
  Vcl.Controls,
  GsTypes,
  GsClasses,
  GsFileCtrl;

type
  { TGsTheme }
  TGsThemeImageItem = class;
  TGsThemeImageCollection = class;
  TCustomGsTheme = class;
  TGsImageList = class;
  TGsThemeImageList = class;



  EAddImage = class(Exception);

  TImagePath = type TGsFolderPath;

  TGsImageListFileNames = TStrings;

  TCustomGsThemeImages = class(TGsPersistent)
  private
    FOwner: TGsThemeImageItem;
  protected
    function GetOwner: TPersistent; override;
    function Owner: TGsThemeImageItem;
  public
    constructor Create(AOwner: TGsThemeImageItem); virtual;
  end;


  TGsImageListItem = class(TGsPersistent)
  private
    FOwner: TGsImageList;
    //function GetImage: TPicture;
    //function GetImageLoaded: Boolean;
    function GetIndex: Integer;
    function GetFileName: TGsImageFileName;
  protected
    function GetOwner: TPersistent; override;
    function Owner: TGsImageList;
    //function LoadImageFromFile(Image: TPicture): Boolean;
  public
    constructor Create(AOwner: TGsImageList);
    //destructor Destroy; override;

    //procedure LoadImage;
    function GetImage(Image: TPicture): Boolean;

    property Index: Integer read GetIndex;
    property FileName: TGsImageFileName read GetFileName;
    //property Image: TPicture read GetImage;
    //property ImageLoaded: Boolean read GetImageLoaded;
  end;

  TGsImageList = class(TGsPersistent)
  private
    FOwner: TGsThemeImageList;
    //FPath: String;
    //FCacheImages: Boolean;
    FImages: TList<TGsImageListItem>;
    FImageList: TCustomImageList;
    FImageListFileNames: TGsImageListFileNames;
    //FCachedImages: TImageList;
    FOnProgress: TGsProgressEvent;
    //function GetCachedImages: TImageList;
    function GetCount: Integer;
    function GetImage(Index: Integer): TGsImageListItem;
    //procedure SetCacheImages(const Value: Boolean);
    //procedure SetPath(const Value: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    //function Owner: TGsThemeImageList;
    function Progress(TotalParts, PartsComplete: Integer; const Msg: string): Boolean;
  public
    constructor Create(AOwner: TGsThemeImageList; AImageList: TCustomImageList; AImageListFileNames: TGsImageListFileNames);
    destructor Destroy; override;

    //function FindName(AFileName: TGsImageFileName): TGsImageFileListItem;

    //property Path: String read FPath write SetPath;
    property Images[Index: Integer]: TGsImageListItem
      read GetImage; default;
    property Count: Integer read GetCount;
    //property CacheImages: Boolean read FCacheImages write SetCacheImages;
    //property CachedImages: TImageList read GetCachedImages;
    property OnProgress: TGsProgressEvent read FOnProgress write FOnProgress;
  end;

  TGsThemeImageList = class(TCustomGsThemeImages)
  private
    FImageFiles: TGsImageList;
    FDisabledImageFiles: TGsImageList;
    FImageList: TCustomImageList;
    FImageListFileNames: TGsImageListFileNames;
    FDisabledImageList: TCustomImageList;
    FDisabledImageListFileNames: TGsImageListFileNames;
    FOnProgress: TGsProgressEvent;
    function GetDisabledImageFiles: TGsImageList;
    function GetDisabledImageListFileNames: TGsImageListFileNames;
    function GetImageFiles: TGsImageList;
    function GetImageListFileNames: TGsImageListFileNames;
    procedure SetDisabledImageList(const Value: TCustomImageList);
    procedure SetDisabledImageListFileNames(const Value: TGsImageListFileNames);
    procedure SetImageList(const Value: TCustomImageList);
    procedure SetImageListFileNames(const Value: TGsImageListFileNames);
  protected
    //procedure AssignTo(Dest: TPersistent); override;
    //function Progress(TotalParts, PartsComplete: Integer; const Msg: string): Boolean;
    procedure SynchronizeLists(Source: TCustomImageList; Dest: TGsImageListFileNames);
  public
    constructor Create(AOwner: TGsThemeImageItem); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property ImageFiles: TGsImageList read GetImageFiles;
    property DisabledImageFiles: TGsImageList read GetDisabledImageFiles;
    //property OnProgress: TGsProgressEvent read FOnProgress write FOnProgress;
  published
    property ImageList: TCustomImageList read FImageList write SetImageList;
    property ImageListFileNames: TGsImageListFileNames read GetImageListFileNames write SetImageListFileNames;
    property DisabledImageList: TCustomImageList read FDisabledImageList write SetDisabledImageList;
    property DisabledImageListFileNames: TGsImageListFileNames read GetDisabledImageListFileNames write SetDisabledImageListFileNames;
  end;

  TGsThemeImageStock = class(TCustomGsThemeImages)
  private
    FPath: TImagePath;
    FDisabledPath: TImagePath;
    FImageFiles: TGsImageFileList;
    FDisabledImageFiles: TGsImageFileList;
    function GetDisabledImageFiles: TGsImageFileList;
    function GetImageFiles: TGsImageFileList;
    procedure SetDisabledPath(const Value: TImagePath);
    procedure SetPath(const Value: TImagePath);
    function GetBasePath: TImagePath;
  protected
    function ExpandPath(ARelPath: TImagePath): TImagePath;
    procedure BasePathUpdated;
  public
    constructor Create(AOwner: TGsThemeImageItem); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property BasePath: TImagePath read GetBasePath;
    property ImageFiles: TGsImageFileList read GetImageFiles;
    property DisabledImageFiles: TGsImageFileList read GetDisabledImageFiles;
  published
    property Path: TImagePath read FPath write SetPath;
    property DisabledPath: TImagePath read FDisabledPath write SetDisabledPath;
  end;

  //TGsThemeImageItem = class(TCustomImageSizeItem)
  TGsThemeImageItem = class(TCollectionItem)
  private
    (*
    FPath: TImagePath;
    FDisabledPath: TImagePath;
    FImageFiles: TGsImageFileList;
    FImagesFileNames: TGsImageListFileNames;
    FDisabledImageFiles: TGsImageFileList;
    FDisabledImagesFileNames: TGsImageListFileNames;
    *)
    FImageSize: TImageSize;
    FList: TGsThemeImageList;
    FStock: TGsThemeImageStock;
    procedure SetImageSize(const Value: TImageSize);
    procedure SetList(const Value: TGsThemeImageList);
    procedure SetStock(const Value: TGsThemeImageStock);
    function GetImageHeight: TImageHeight;
    function GetImageWidth: TImageWidth;
    procedure SetImageHeight(const Value: TImageHeight);
    procedure SetImageWidth(const Value: TImageWidth);
  protected
    //function GetDisabledImages: TCustomImageList; override;
    //function IsImagesStored: Boolean; override;
    //function IsDisabledImagesStored: Boolean; override;
    //function IsSizeStored: Boolean; override;
    { TCollectionItem }
    function GetDisplayName: String; override;

    function Owner: TGsThemeImageCollection;
    function ExpandPath(ARelPath: TImagePath): TImagePath;
    procedure BasePathUpdated;
    procedure InternalAddImage(AImageFile: TGsImageFileListItem; StockImageFiles: TGsImageFileList; ImageList: TCustomImageList; ImageListFileNames: TGsImageListFileNames);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure AddImage(AImageFile: TGsImageFileListItem);

    (*
    property Path: TImagePath read FPath write SetPath stored IsPathStored;
    property DisabledPath: TImagePath read FDisabledPath write SetDisabledPath stored IsDisabledPathStored;
    property ImageFiles: TGsImageFileList read GetImageFiles;
    property ImagesFileNames: TGsImageListFileNames read GetImagesFileNames write SetImagesFileNames;
    property DisabledImageFiles: TGsImageFileList read GetDisabledImageFiles;
    property DisabledImagesFileNames: TGsImageListFileNames read GetDisabledImagesFileNames write SetDisabledImagesFileNames;
    *)
  published
    property ImageSize: TImageSize read FImageSize write SetImageSize;
    property ImageHeight: TImageHeight read GetImageHeight write SetImageHeight stored False;
    property ImageWidth: TImageWidth read GetImageWidth write SetImageWidth stored False;

    property List: TGsThemeImageList read FList write SetList;
    property Stock: TGsThemeImageStock read FStock write SetStock;
  end;

  TImagePathItem1 = class(TGsThemeImageItem)
  published
    (*
    property Images;
    property DisabledImages;
    property Size;
    property Path;
    property ImagesFileNames;
    property DisabledPath;
    property DisabledImagesFileNames;
    *)
  end;

  TGsThemeImageCollection = class(TOwnedCollection)
  private
    FBasePath: TImagePath;
    function GetImage(Size: TImageSize): TGsThemeImageItem;
    function GetImageItem(Index: Integer): TGsThemeImageItem;
    function GetTheme: TCustomGsTheme;
    function IsBasePathStored: Boolean;
    procedure SetBasePath(const Value: TImagePath);
    procedure SetImage(Size: TImageSize; const Value: TGsThemeImageItem);
    procedure SetImageItem(Index: Integer; const Value: TGsThemeImageItem);
  protected
    procedure SynchronizeItems(AImageSizeCollection: TImageSizeCollection);
  public
    constructor Create(AOwner: TCustomGsTheme); virtual;

    procedure AddImage(AImageFile: TGsImageFileListItem);
    function IndexOf(ASize: TImageSize): Integer;
    function Find(ASize: TImageSize): TGsThemeImageItem;

    property Theme: TCustomGsTheme read GetTheme;
    property ImageItems[Index: Integer]: TGsThemeImageItem read GetImageItem write SetImageItem; default;
    property Images[Size: TImageSize]: TGsThemeImageItem read GetImage write SetImage;
    //property PathItems[Index: Integer]: TGsThemeImageItem read GetPathItem write SetPathItem; default;
  published
    property BasePath: TImagePath read FBasePath write SetBasePath stored IsBasePathStored;
  end;

  TCustomGsTheme = class(TAbstractGsThemeManager)
  private
    FImages: TGsThemeImageCollection;
    function GetThemeManager: TGsThemeManager;
    function GetImages: TGsThemeImageCollection;
    function IsImagesStored: Boolean;
    procedure SetImages(const Value: TGsThemeImageCollection);
  protected
    { TPersistent }
    //procedure DefineProperties(Filer: TFiler); override;

    { TComponent }
    procedure Loaded; override;
    //procedure ReadState(Reader: TReader); override;

    { TAbstractGsThemeManager }
    //function GetImageSizeCollectionClass: TImageSizeCollectionClass; override;
    function GetImageSizes: TImageSizeCollection; override;
    function GetStylers: TGsStylerList; override;
    procedure SetImageSizes(const Value: TImageSizeCollection); override;
    procedure SetStylers(const Value: TGsStylerList); override;

    { TCustomGsTheme }
    procedure CreateImageLists; dynamic;
    //procedure ReadImages(Reader: TReader); dynamic;
    //procedure ReadDisabledImages(Reader: TReader); dynamic;
    //procedure WriteImages(Writer: TWriter); dynamic;
    //procedure WriteDisabledImages(Writer: TWriter); dynamic;

    //function CreateImageSizes: TImageSizeCollection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Test;
    procedure AddImage(AImageFile: TGsImageFileListItem);

    (*
    function Add(Image, Mask: TBitmap): Integer;
    function AddIcon(Image: TIcon): Integer;
    function AddImage(Value: TCustomImageList; Index: Integer): Integer;
    procedure AddImages(Value: TCustomImageList);
    function AddMasked(Image: TBitmap; MaskColor: TColor): Integer;
    procedure Insert(Index: Integer; Image, Mask: TBitmap);
    procedure InsertIcon(Index: Integer; Image: TIcon);
    procedure InsertMasked(Index: Integer; Image: TBitmap; MaskColor: TColor);
    *)

    property ThemeManager: TGsThemeManager read GetThemeManager;
  published
    property Images: TGsThemeImageCollection read GetImages write SetImages stored IsImagesStored;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Vcl.Dialogs,
  Math;

resourcestring
  SErrorImageNotFound = 'Die Bilddatei ''%0:s'' in der Grösse %2:dx%1:d wurde nicht gefunden!';
  SErrorImageExists = 'Eine Bilddatei mit Namen ''%0:s'' und Grösse %2:dx%1:d ist bereits vorhanden!';

{ TCustomGsThemeImages }

constructor TCustomGsThemeImages.Create(AOwner: TGsThemeImageItem);
begin
  FOwner := AOwner;

  inherited Create;
end;

function TCustomGsThemeImages.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TCustomGsThemeImages.Owner: TGsThemeImageItem;
begin
  Result := FOwner;
end;

{ TGsImageListItem }

constructor TGsImageListItem.Create(AOwner: TGsImageList);
begin
  FOwner := AOwner;

  inherited Create;
end;

function TGsImageListItem.GetFileName: TGsImageFileName;
begin
  Result := Owner.FImageListFileNames.Values[IntToStr(Index)];
end;

function TGsImageListItem.GetImage(Image: TPicture): Boolean;
begin
  Result := (Image <> nil);

  if Result then
    Result := Owner.FImageList.GetBitmap(Index, Image.Bitmap);
end;

function TGsImageListItem.GetIndex: Integer;
begin
  Result := Owner.FImages.IndexOf(Self);
end;

function TGsImageListItem.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TGsImageListItem.Owner: TGsImageList;
begin
  Result := FOwner;
end;

{ TGsImageList }

procedure TGsImageList.AssignTo(Dest: TPersistent);
resourcestring
  SAddingFiles = 'Bilder werden geladen';
  SDeletingFiles = 'Bilder werden gelöscht';
var
  I,
  TotalParts: Integer;
  Item: TGsImageListItem;
begin
  if Dest is TStrings then
  begin
    with Dest as TStrings do
    begin
      TotalParts := Max(Count, Self.Count) + 1;
      BeginUpdate;

      try
        { Add or replace items }
        if not Progress(TotalParts, 0, SAddingFiles) then
          Exit;

        for I := 0 to Self.Count - 1 do
        begin
          Item := Self[I];

          if Count < Self.Count then
            AddObject(Item.FileName, Item)
          else
          begin
            Strings[I] := Item.FileName;
            Objects[I] := Item;
          end;

          if not Progress(TotalParts, I, SAddingFiles) then
            Exit;
        end;

        { Delete old resting images }
        while Count > Self.Count do
        begin
          Delete(Count - 1);

          if not Progress(TotalParts, TotalParts - Count - Self.Count, SDeletingFiles) then
            Exit;
        end;
      finally
        EndUpdate;
        Progress(TotalParts, TotalParts, '');
      end;
    end;
  end
  else
    inherited;
end;

constructor TGsImageList.Create(AOwner: TGsThemeImageList; AImageList: TCustomImageList; AImageListFileNames: TGsImageListFileNames);
begin
  FOwner := AOwner;

  inherited Create;

  FImages := TList<TGsImageListItem>.Create;
  FImageList := AImageList;
  FImageListFileNames := AImageListFileNames;
end;

destructor TGsImageList.Destroy;
begin
  FImages.Free;

  inherited;
end;

function TGsImageList.GetCount: Integer;
begin
  Result := FImageList.Count;
end;

function TGsImageList.GetImage(Index: Integer): TGsImageListItem;
begin
  while Index >= FImages.Count do
    FImages.Add(TGsImageListItem.Create(Self));

  Result := TGsImageListItem(FImages.Items[Index]);
end;

function TGsImageList.Progress(TotalParts, PartsComplete: Integer;
  const Msg: string): Boolean;
begin
  Result := True;

  if Assigned(FOnProgress) then
    FOnProgress(Self, TotalParts, PartsComplete, Result, Msg);
end;

{ TGsThemeImageList }

procedure TGsThemeImageList.Assign(Source: TPersistent);
begin
  if Source is TGsThemeImageList then
  begin
    with Source as TGsThemeImageList do
    begin
      Self.ImageList := ImageList;
      Self.ImageListFileNames := ImageListFileNames;
      Self.DisabledImageList := DisabledImageList;
      Self.DisabledImageListFileNames := DisabledImageListFileNames;
    end;
  end
  else
    inherited;
end;

constructor TGsThemeImageList.Create(AOwner: TGsThemeImageItem);
begin
  inherited;
end;

destructor TGsThemeImageList.Destroy;
begin
  if Assigned(FDisabledImageListFileNames) then
    FDisabledImageListFileNames.Free;

  if Assigned(FImageListFileNames) then
    FImageListFileNames.Free;

  inherited;
end;

function TGsThemeImageList.GetDisabledImageFiles: TGsImageList;
begin
  if not Assigned(FDisabledImageFiles) then
    FDisabledImageFiles := TGsImageList.Create(Self, DisabledImageList, DisabledImageListFileNames);

  Result := FDisabledImageFiles;
end;

function TGsThemeImageList.GetDisabledImageListFileNames: TGsImageListFileNames;
begin
  if not Assigned(FDisabledImageListFileNames) then
  begin
    FDisabledImageListFileNames := TStringList.Create;

    if not (csLoading in Owner.Owner.Theme.ComponentState) then
      SynchronizeLists(DisabledImageList, FDisabledImageListFileNames);
  end;

  Result := FDisabledImageListFileNames;
end;

function TGsThemeImageList.GetImageFiles: TGsImageList;
begin
  if not Assigned(FImageFiles) then
    FImageFiles := TGsImageList.Create(Self, ImageList, ImageListFileNames);

  Result := FImageFiles;
end;

function TGsThemeImageList.GetImageListFileNames: TGsImageListFileNames;
begin
  if not Assigned(FImageListFileNames) then
  begin
    FImageListFileNames := TStringList.Create;

    if not (csLoading in Owner.Owner.Theme.ComponentState) then
      SynchronizeLists(ImageList, FImageListFileNames);
  end;

  Result := FImageListFileNames;
end;

procedure TGsThemeImageList.SetDisabledImageList(const Value: TCustomImageList);
begin
  if not Assigned(FDisabledImageList) then
    FDisabledImageList := Value;
end;

procedure TGsThemeImageList.SetDisabledImageListFileNames(
  const Value: TGsImageListFileNames);
begin
  DisabledImageListFileNames.Assign(Value);
  SynchronizeLists(DisabledImageList, DisabledImageListFileNames);
end;

procedure TGsThemeImageList.SetImageList(const Value: TCustomImageList);
begin
  if not Assigned(FImageList) then
    FImageList := Value;
end;

procedure TGsThemeImageList.SetImageListFileNames(
  const Value: TGsImageListFileNames);
begin
  ImageListFileNames.Assign(Value);
  SynchronizeLists(ImageList, ImageListFileNames);
end;

procedure TGsThemeImageList.SynchronizeLists(Source: TCustomImageList;
  Dest: TGsImageListFileNames);
var
  I,
  V: Integer;
begin
  if not Assigned(Source) or not Assigned(Dest) then
    Exit;

  I := 0;

  while I < Dest.Count do
  begin
    V := StrToInt(Dest.Names[I]);

    if V >= Source.Count then
      Dest.Delete(I)
    else
      Inc(I);
  end;

  for I := 0 to Source.Count - 1 do
  begin
    V := Dest.IndexOfName(IntToStr(I));

    if V = -1 then
    begin
      Dest.Values[IntToStr(I)] := ' ';
    end;
  end;
end;

{ TGsThemeImageStock }

procedure TGsThemeImageStock.Assign(Source: TPersistent);
begin
  if Source is TGsThemeImageStock then
  begin
    with Source as TGsThemeImageStock do
    begin
      Self.Path := Path;
      Self.DisabledPath := DisabledPath;
    end;
  end
  else
    inherited;
end;

procedure TGsThemeImageStock.BasePathUpdated;
begin
  ImageFiles;
  DisabledImageFiles;
end;

constructor TGsThemeImageStock.Create(AOwner: TGsThemeImageItem);
begin
  inherited;
end;

destructor TGsThemeImageStock.Destroy;
begin
  if Assigned(FDisabledImageFiles) then
    FDisabledImageFiles.Free;

  if Assigned(FImageFiles) then
    FImageFiles.Free;

  inherited;
end;

function TGsThemeImageStock.ExpandPath(ARelPath: TImagePath): TImagePath;
begin
  Result := ExpandFileName(IncludeTrailingPathDelimiter(BasePath) + ARelPath);
end;

function TGsThemeImageStock.GetBasePath: TImagePath;
begin
  Result := Owner.Owner.BasePath;
end;

function TGsThemeImageStock.GetDisabledImageFiles: TGsImageFileList;
begin
  if (DisabledPath = '') or (DisabledPath = Path) then
    Result := ImageFiles
  else
  begin
    if not Assigned(FDisabledImageFiles) then
      FDisabledImageFiles := TGsImageFileList.Create(ExpandPath(DisabledPath), Owner.ImageSize = is16x16)
    else
      FDisabledImageFiles.Path := ExpandPath(DisabledPath);

    Result := FDisabledImageFiles;
  end;
end;

function TGsThemeImageStock.GetImageFiles: TGsImageFileList;
begin
  if not Assigned(FImageFiles) then
    FImageFiles := TGsImageFileList.Create(ExpandPath(Path), Owner.ImageSize = is16x16)
  else
    FImageFiles.Path := ExpandPath(Path);

  Result := FImageFiles;
end;

procedure TGsThemeImageStock.SetDisabledPath(const Value: TImagePath);
var
  LBasePath,
  LRelPath: String;
begin
  LBasePath := IncludeTrailingPathDelimiter(BasePath);
  LRelPath := ExtractRelativePath(LBasePath, Value);

  if Path <> LRelPath then
  begin
    if FDisabledPath <> LRelPath then
    begin
      FDisabledPath := LRelPath;
      DisabledImageFiles.Path := ExpandFileName(LBasePath + LRelPath);
    end;
  end
  else
    FDisabledPath := '';
end;

procedure TGsThemeImageStock.SetPath(const Value: TImagePath);
var
  LBasePath,
  LRelPath: String;
begin
  LBasePath := IncludeTrailingPathDelimiter(BasePath);
  LRelPath := ExtractRelativePath(LBasePath, Value);

  if FPath <> LRelPath then
  begin
    FPath := LRelPath;
    ImageFiles.Path := ExpandFileName(LBasePath + LRelPath);
  end;
end;

{ TGsThemeImageItem }

procedure TGsThemeImageItem.AddImage(AImageFile: TGsImageFileListItem);
begin
  InternalAddImage(AImageFile, Stock.ImageFiles, List.ImageList, List.ImageListFileNames);
  InternalAddImage(AImageFile, Stock.DisabledImageFiles, List.DisabledImageList, List.DisabledImageListFileNames);
end;

procedure TGsThemeImageItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TGsThemeImageItem then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      ImageSize := TGsThemeImageItem(Source).ImageSize;
      List := TGsThemeImageItem(Source).List;
      Stock := TGsThemeImageItem(Source).Stock;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end;
end;

procedure TGsThemeImageItem.BasePathUpdated;
begin
  Stock.BasePathUpdated;
end;

constructor TGsThemeImageItem.Create(Collection: TCollection);
begin
  inherited;

  FList := TGsThemeImageList.Create(Self);
  FStock := TGsThemeImageStock.Create(Self);
end;

destructor TGsThemeImageItem.Destroy;
begin
  FStock.Free;
  FList.Free;

  inherited;
end;

function TGsThemeImageItem.ExpandPath(ARelPath: TImagePath): TImagePath;
begin
  Result := ExpandFileName(IncludeTrailingPathDelimiter(Owner.BasePath) + ARelPath);
end;

function TGsThemeImageItem.GetDisplayName: String;
begin
  Result := Format('%1:dx%0:d', [ImageHeight, ImageWidth]);
end;

function TGsThemeImageItem.GetImageHeight: TImageHeight;
var
  Dim: TImageDimensions;
begin
  Dim := GetImageDimensions(ImageSize);
  Result := Dim.Height;
end;

function TGsThemeImageItem.GetImageWidth: TImageWidth;
var
  Dim: TImageDimensions;
begin
  Dim := GetImageDimensions(ImageSize);
  Result := Dim.Width;
end;

procedure TGsThemeImageItem.InternalAddImage(AImageFile: TGsImageFileListItem;
  StockImageFiles: TGsImageFileList; ImageList: TCustomImageList;
  ImageListFileNames: TGsImageListFileNames);
var
  FileName: TGsImageFileName;
  ImageFile: TGsImageFileListItem;
  I: Integer;
begin
  FileName := AImageFile.FileName;
  ImageFile := StockImageFiles.FindName(FileName);

  if Assigned(ImageFile) then
  begin
    I := 0;
    while I < ImageListFileNames.Count do
    begin
      if ImageListFileNames.Values[IntToStr(I)] = FileName then
        Break;

      Inc(I);
    end;

    if I = ImageListFileNames.Count then
      I := -1;

    if I = -1 then
    begin
      ImageFile.LoadImage;
      I := ImageList.AddImage(StockImageFiles.CachedImages, ImageFile.ImageIndex);
      ImageListFileNames.Values[IntToStr(I)] := FileName;
    end
    else
      raise EAddImage.CreateResFmt(@SErrorImageExists, [FileName, ImageHeight, ImageWidth]);
  end
  else
    raise EAddImage.CreateResFmt(@SErrorImageNotFound, [FileName, ImageHeight, ImageWidth]);
end;

function TGsThemeImageItem.Owner: TGsThemeImageCollection;
begin
  Result := TGsThemeImageCollection(Collection);
end;

procedure TGsThemeImageItem.SetImageHeight(const Value: TImageHeight);
begin
  { readonly property, do nothing }
end;

procedure TGsThemeImageItem.SetImageSize(const Value: TImageSize);
begin
  if FImageSize = isUnknown then
    FImageSize := Value;
end;

procedure TGsThemeImageItem.SetImageWidth(const Value: TImageWidth);
begin
  { readonly property, do nothing }
end;

procedure TGsThemeImageItem.SetList(const Value: TGsThemeImageList);
begin
  List.Assign(Value);
end;

procedure TGsThemeImageItem.SetStock(const Value: TGsThemeImageStock);
begin
  Stock.Assign(Value);
end;

{ TGsThemeImageCollection }

procedure TGsThemeImageCollection.AddImage(AImageFile: TGsImageFileListItem);
var
  I: Integer;
begin
  try
    for I := 0 to Count - 1 do
      ImageItems[I].AddImage(AImageFile);
  except
    on E: EAddImage do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  else
    raise;
  end;
end;

constructor TGsThemeImageCollection.Create(AOwner: TCustomGsTheme);
begin
  inherited Create(AOwner, TGsThemeImageItem);
end;

function TGsThemeImageCollection.Find(ASize: TImageSize): TGsThemeImageItem;
var
  I: Integer;
begin
  I := IndexOf(ASize);

  if I <> -1 then
    Result := ImageItems[I]
  else
    Result := nil;
end;

function TGsThemeImageCollection.GetImage(Size: TImageSize): TGsThemeImageItem;
begin
  Result := Find(Size);
end;

function TGsThemeImageCollection.GetImageItem(
  Index: Integer): TGsThemeImageItem;
begin
  Result := TGsThemeImageItem(Items[Index]);
end;

function TGsThemeImageCollection.GetTheme: TCustomGsTheme;
begin
  Result := TCustomGsTheme(Owner);
end;

function TGsThemeImageCollection.IndexOf(ASize: TImageSize): Integer;
begin
  for Result := 0 to Count - 1 do
    if ImageItems[Result].ImageSize = ASize then
      Exit;

  Result := -1;
end;

function TGsThemeImageCollection.IsBasePathStored: Boolean;
begin
  Result := BasePath <> '';
end;

procedure TGsThemeImageCollection.SetBasePath(const Value: TImagePath);
var
  I: Integer;
begin
  if FBasePath <> Value then
  begin
    FBasePath := Value;

    if not (csLoading in Theme.ComponentState) then
      for I := 0 to Count - 1 do
        ImageItems[I].BasePathUpdated;
  end;
end;

procedure TGsThemeImageCollection.SetImage(Size: TImageSize;
  const Value: TGsThemeImageItem);
begin
  Images[Size] := Value;
end;

procedure TGsThemeImageCollection.SetImageItem(Index: Integer;
  const Value: TGsThemeImageItem);
begin
  Items[Index].Assign(Value);
end;

procedure TGsThemeImageCollection.SynchronizeItems(
  AImageSizeCollection: TImageSizeCollection);

  (*
  function FindSize(ASize: TImageSize): TGsThemeImageItem;
  var
    I: Integer;
  begin
    Result := nil;

    for I := 0 to Count - 1 do
    begin
      if (ImageItems[I].ImageSize = ASize) then
      begin
        Result := ImageItems[I];
        Break;
      end;
    end;
  end;
  *)

var
  I: Integer;
  Item: TGsThemeImageItem;
begin
  for I := 0 to AImageSizeCollection.Count - 1 do
  begin
    Item := Find(AImageSizeCollection.ImageSizeItems[I].Size);

    if not Assigned(Item) then
      Item := TGsThemeImageItem(Insert(I));

    Item.ImageSize := AImageSizeCollection.ImageSizeItems[I].Size;
  end;
end;

{ TCustomGsTheme }

procedure TCustomGsTheme.AddImage(AImageFile: TGsImageFileListItem);
begin
  Images.AddImage(AImageFile);
end;

constructor TCustomGsTheme.Create(AOwner: TComponent);
begin
  FImages := TGsThemeImageCollection.Create(Self);

  inherited;
end;

procedure TCustomGsTheme.CreateImageLists;

  function InternalCreate(ASize: TImageSize; Disabled: Boolean): TCustomImageList;
  const
    IL_NAMES_ENABLED: array [TImageSize] of string = (
        '',
        'ResImages16',
        'ResImages24',
        'ResImages32',
        'ResImages48',
        'ResImages64',
        'ResImages128',
        'ResImages256'
      );
    IL_NAMES_DISABLED: array [TImageSize] of string = (
        '',
        'ResDisabledImages16',
        'ResDisabledImages24',
        'ResDisabledImages32',
        'ResDisabledImages48',
        'ResDisabledImages64',
        'ResDisabledImages128',
        'ResDisabledImages256'
      );
  var
    Dim: TImageDimensions;
  begin
    Result := TImageList.Create(Self);

    if Disabled then
      Result.Name := IL_NAMES_DISABLED[ASize]
    else
      Result.Name := IL_NAMES_ENABLED[ASize];

    Dim := GetImageDimensions(ASize);

    Result.Height := Dim.Height;
    Result.Width := Dim.Width;
  end;

var
  I: Integer;
begin
  Images.SynchronizeItems(ImageSizes);

  (*
  for I := 0 to ImagePaths.Count - 1 do
  begin
    if (ImagePaths[I].Images = nil) then
      ImagePaths[I].Images := InternalCreate(ImagePaths[I].Size, False);

    if (ImagePaths[I].DisabledImages = nil) then
      ImagePaths[I].DisabledImages := InternalCreate(ImagePaths[I].Size, True);
  end;
  *)
end;

destructor TCustomGsTheme.Destroy;
begin
  inherited;

  FImages.Free;
end;

function TCustomGsTheme.GetImages: TGsThemeImageCollection;
begin
  Result := FImages;
end;

function TCustomGsTheme.GetImageSizes: TImageSizeCollection;
begin
  Result := ThemeManager.ImageSizes;
end;

function TCustomGsTheme.GetStylers: TGsStylerList;
begin
  Result := ThemeManager.Stylers;
end;

function TCustomGsTheme.GetThemeManager: TGsThemeManager;
begin
  Result := GsThemeManager;
end;

function TCustomGsTheme.IsImagesStored: Boolean;
begin
  Result := (Images.Count > 0);
end;

procedure TCustomGsTheme.Loaded;
begin
  inherited;

  if csDesigning in ComponentState then
    CreateImageLists;
end;

procedure TCustomGsTheme.SetImages(const Value: TGsThemeImageCollection);
begin
  FImages.Assign(Value);
end;

procedure TCustomGsTheme.SetImageSizes(const Value: TImageSizeCollection);
begin
  ThemeManager.ImageSizes := Value;
end;

procedure TCustomGsTheme.SetStylers(const Value: TGsStylerList);
begin
  ThemeManager.Stylers := Value;
end;

procedure TCustomGsTheme.Test;
var
  I,
  P: Integer;
begin
  (*
  for P := 0 to 0 {ImagePaths.Count - 1} do
  begin
    for I := 0 to ImagePaths[P].ImageFiles.Count - 1 do
    begin
      ImagePaths[P].ImageFiles[I].LoadImage;
    end;

    ImagePaths[P].Images.AddImages(ImagePaths[P].ImageFiles.CachedImages);
  end;

  Images16.AddImages(ImagePaths[0].Images);
  *)
end;

end.

procedure TCustomGsTheme.DefineProperties(Filer: TFiler);

  function DoWriteImages: Boolean;
  begin
    //Result := (Images.Count > 0);
  end;

  function DoWriteDisabledImages: Boolean;
  begin
    //Result := (DisabledImages.Count > 0);
  end;

begin
  inherited DefineProperties(Filer);

//  Filer.DefineProperty('Images', ReadImages, WriteImages, DoWriteImages);
//  Filer.DefineProperty('DisabledImages', ReadDisabledImages, WriteDisabledImages, DoWriteDisabledImages);
end;

procedure TCustomGsTheme.ReadDisabledImages(Reader: TReader);
begin
  //Reader.ReadCollection(FDisabledImages);
end;

procedure TCustomGsTheme.ReadImages(Reader: TReader);
begin
  //Reader.ReadCollection(FImages);
end;

procedure TCustomGsTheme.WriteDisabledImages(Writer: TWriter);
begin
  //Writer.WriteCollection(FDisabledImages);
end;

procedure TCustomGsTheme.WriteImages(Writer: TWriter);
begin
  //Writer.WriteCollection(FImages);
end;


