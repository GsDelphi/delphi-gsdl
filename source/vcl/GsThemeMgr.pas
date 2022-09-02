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
unit GsThemeMgr;

interface

uses
  GsClasses, System.SysUtils, System.Classes, Vcl.ImgList, Vcl.Controls,
  Vcl.PlatformDefaultStyleActnCtrls, System.Actions, Vcl.ActnList, Vcl.ActnMan;

type
  TGsThemeManager = class;



  { Exceptions }
  ECustomGsThemeManager = class(Exception);
  EGsThemeManager = class(ECustomGsThemeManager);
  EGsThemeController = class(ECustomGsThemeManager);

  { TCustomGsThemeManagerComponent }
  TAbstractGsThemeManagerComponent = class(TGsComponent)
  private
  protected
    function GetThemeManager: TGsThemeManager; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ThemeManager: TGsThemeManager read GetThemeManager;
  end;

  TCustomGsThemeManagerComponent = class(TAbstractGsThemeManagerComponent)
  private
    procedure Dummy;
  protected
  public
  end;



  { TGsThemeController }
  TAbstractGsThemeController = class;
  TActionManagerCollection = class;

  TActionManagerItem = class(TCollectionItem)
  private
    FActionManager: TCustomActionManager;
    FCaption: String;
    procedure SetActionManager(const Value: TCustomActionManager);
    function GetCaption: String;
  protected
    function GetDisplayName: String; override;
    function Owner: TActionManagerCollection;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property ActionManager: TCustomActionManager read FActionManager write SetActionManager;
    property Caption: String read GetCaption write FCaption;
  end;

  TActionManagerCollection = class(TOwnedCollection)
  private
    function GetListItem(Index: Integer): TActionManagerItem;
    function GetThemeController: TAbstractGsThemeController;
    procedure SetListItem(Index: Integer; const Value: TActionManagerItem);
  public
    property ListItems[Index: Integer]: TActionManagerItem read GetListItem
      write SetListItem; default;
    property ThemeController: TAbstractGsThemeController read GetThemeController;
  end;


  TAbstractImageListCollection = class;

  TCustomImageListItem = class(TCollectionItem)
  private
    FImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
  protected
    function GetDisplayName: String; override;
    function IsImagesStored: Boolean; virtual;
    function Owner: TAbstractImageListCollection;
  public
    procedure Assign(Source: TPersistent); override;

    property Images: TCustomImageList read FImages write SetImages stored IsImagesStored;
  end;

  TAbstractImageListCollection = class(TOwnedCollection)
  protected
    function ItemClass: TCollectionItemClass; virtual; abstract;
  public
    constructor Create(AOwner: TPersistent); virtual;
  end;


  TImageListItem = class(TCustomImageListItem)
  published
    property Images;
  end;

  TImageListCollection = class(TAbstractImageListCollection)
  private
    function GetListItem(Index: Integer): TImageListItem;
    procedure SetListItem(Index: Integer;
      const Value: TImageListItem);
  protected
    function ItemClass: TCollectionItemClass; override;
  public
    property ListItems[Index: Integer]: TImageListItem read GetListItem
      write SetListItem; default;
  published
  end;


  TAbstractImageSizeCollection = class;

  TImageSize = (
      isUnknown,
      is16x16,
      is24x24,
      is32x32,
      is48x48,
      is64x64,
      is128x128,
      is256x256
    );

  TImageHeight = type Integer;
  TImageWidth = type Integer;

  TCustomImageSizeItem = class(TCustomImageListItem)
  private
    FDisabledImages: TCustomImageList;
    FImageSize: TImageSize;
    function GetHeight: TImageHeight;
    function GetSize: TImageSize;
    function GetWidth: TImageWidth;
    procedure SetHeight(const Value: TImageHeight);
    procedure SetSize(const Value: TImageSize);
    procedure SetWidth(const Value: TImageWidth);
  protected
    function GetDisplayName: String; override;
    function IsImagesStored: Boolean; override;

    function GetDisabledImages: TCustomImageList; virtual;
    function IsDisabledImagesStored: Boolean; virtual;
    function IsSizeStored: Boolean; virtual;
    procedure SetDisabledImages(const Value: TCustomImageList); virtual;

    function Owner: TAbstractImageSizeCollection;
  public
    procedure Assign(Source: TPersistent); override;

    property DisabledImages: TCustomImageList read GetDisabledImages write SetDisabledImages stored IsDisabledImagesStored;
    property Size: TImageSize read GetSize write SetSize stored IsSizeStored;
    property Height: TImageHeight read GetHeight write SetHeight stored False;
    property Width: TImageWidth read GetWidth write SetWidth stored False;
  end;

  TAbstractImageSizeCollection = class(TAbstractImageListCollection)
  private
    function GetImageSize(Size: TImageSize): TCustomImageSizeItem;
    function GetImageSizeItem(Index: Integer): TCustomImageSizeItem;
    procedure SetImageSize(Size: TImageSize; const Value: TCustomImageSizeItem);
    procedure SetImageSizeItem(Index: Integer;
      const Value: TCustomImageSizeItem);
  protected
  public
    //procedure AfterConstruction; override;
    function IndexOf(ASize: TImageSize): Integer;

    //function GetThemeController: TAbstractGsThemeController;
    //property ThemeController: TAbstractGsThemeController read GetThemeController;
    property ImageSizeItems[Index: Integer]: TCustomImageSizeItem read GetImageSizeItem write SetImageSizeItem;
    property ImageSizes[Size: TImageSize]: TCustomImageSizeItem read GetImageSize write SetImageSize; default;
  end;

  //TImageSizeCollectionClass = class of TAbstractImageSizeCollection;


  TImageSizeItem = class(TCustomImageSizeItem)
  published
    property DisabledImages;
    property Size;
    property Height;
    property Width;
  end;

  TImageSizeCollection = class(TAbstractImageSizeCollection)
  private
    function GetImageSizeItemNew(Index: Integer): TImageSizeItem;
    procedure SetImageSizeItemNew(Index: Integer; const Value: TImageSizeItem);
  protected
    function ItemClass: TCollectionItemClass; override;
  public
    property ImageSizeItems[Index: Integer]: TImageSizeItem read GetImageSizeItemNew write SetImageSizeItemNew;
  end;


  TAbstractGsThemeController = class(TCustomGsThemeManagerComponent)
  private
    FLinkedActionLists: TActionListCollection;
    FLinkedActionManagers: TActionManagerCollection;
    function GetImageSizes: TImageSizeCollection;
    function GetLinkedActionLists: TActionListCollection;
    function GetLinkedActionManagers: TActionManagerCollection;
    function IsLinkedActionListsStored: Boolean;
    function IsLinkedActionManagersStored: Boolean;
    procedure SetImageSizes(const Value: TImageSizeCollection);
    procedure SetLinkedActionLists(const Value: TActionListCollection);
    procedure SetLinkedActionManagers(const Value: TActionManagerCollection);
  protected
    //property ActionBars: TActionBars read FActionBars write SetActionBars stored IsActionBarsStored;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ThemeManager: TGsThemeManager read GetThemeManager;
    property LinkedActionLists: TActionListCollection read GetLinkedActionLists write SetLinkedActionLists stored IsLinkedActionListsStored;
    property LinkedActionManagers: TActionManagerCollection read GetLinkedActionManagers write SetLinkedActionManagers stored IsLinkedActionManagersStored;
    property ImageSizes: TImageSizeCollection read GetImageSizes write SetImageSizes stored False;
  end;

  TCustomGsThemeController = class(TAbstractGsThemeController)
  private
    procedure Dummy;
  protected
  public
  end;

  TGsThemeController = class(TCustomGsThemeController)
  private
    procedure Dummy;
  protected
  public
  published
    property LinkedActionLists;
    property LinkedActionManagers;
    property ImageSizes;
  end;

  TAbstractGsThemeStyler = class(TCustomGsThemeManagerComponent)
  private
    procedure Dummy;
  protected
  public
    //constructor Create(AOwner: TComponent); override;
    //destructor Destroy; override;
  published
  end;

  TCustomGsThemeStyler = class(TAbstractGsThemeStyler)
  private
    procedure Dummy;
  protected
  public
  published
  end;

  TGsThemeStyler = class(TCustomGsThemeStyler)
  private
    procedure Dummy;
  protected
  public
  published
  end;



  { TGsThemeManager }
  TGsStylerList = class(TStringList);

  TAbstractGsThemeManager = class(TDataModule)
    Images16: TImageList;
    Images24: TImageList;
    Images32: TImageList;
    Images48: TImageList;
    Images64: TImageList;
    Images128: TImageList;
    Images256: TImageList;
    DisabledImages16: TImageList;
    DisabledImages24: TImageList;
    DisabledImages32: TImageList;
    DisabledImages48: TImageList;
    DisabledImages64: TImageList;
    DisabledImages128: TImageList;
    DisabledImages256: TImageList;
  private
  protected
    { TComponent }
    //procedure Loaded; override;
    procedure ReadState(Reader: TReader); override;

    { TAbstractGsThemeManager }
    function GetController: TAbstractGsThemeController; virtual;
    //function GetImageSizeCollectionClass: TImageSizeCollectionClass; virtual; abstract;
    function GetImageSizes: TImageSizeCollection; virtual; abstract;
    function GetLinkedActionLists: TActionListCollection; virtual;
    function GetLinkedActionManagers: TActionManagerCollection; virtual;
    function GetStylers: TGsStylerList; virtual; abstract;
    procedure SetImageSizes(const Value: TImageSizeCollection); virtual; abstract;
    procedure SetLinkedActionLists(const Value: TActionListCollection); virtual;
    procedure SetLinkedActionManagers(const Value: TActionManagerCollection); virtual;
    procedure SetStylers(const Value: TGsStylerList); virtual; abstract;

    //function CreateImageSizes: TAbstractImageSizeCollection;
  public
    destructor Destroy; override;

    property Controller: TAbstractGsThemeController read GetController;
    property Stylers: TGsStylerList read GetStylers write SetStylers;

    property ImageSizes: TImageSizeCollection read GetImageSizes write SetImageSizes;

    property LinkedActionLists: TActionListCollection read GetLinkedActionLists write SetLinkedActionLists;
    property LinkedActionManagers: TActionManagerCollection read GetLinkedActionManagers write SetLinkedActionManagers;
  end;

  TGsThemeManager = class(TAbstractGsThemeManager)
  private
    FImageSizes: TImageSizeCollection;
    FStylers: TGsStylerList;
  protected
    { TComponent }
    //procedure Loaded; override;
    //procedure ReadState(Reader: TReader); override;

    { TAbstractGsThemeManager }
    //function GetImageSizeCollectionClass: TImageSizeCollectionClass; override;
    function GetImageSizes: TImageSizeCollection; override;
    function GetStylers: TGsStylerList; override;
    procedure SetImageSizes(const Value: TImageSizeCollection); override;
    procedure SetStylers(const Value: TGsStylerList); override;
  protected
    { TComponent }
    //procedure Loaded; override;

    //procedure DoCreate; override;
    //procedure DoDestroy; override;
    //procedure InitImageSizes;
    function CreateImageSizes: TImageSizeCollection;
  protected
    procedure ComponentRegistration(AComponent: TAbstractGsThemeManagerComponent);
    procedure RemoveComponentRegistration(AComponent: TAbstractGsThemeManagerComponent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TImageDimensions = record
    Height: TImageHeight;
    Width: TImageWidth;
  end;

var
  GsThemeController: TAbstractGsThemeController;
  GsThemeManager: TGsThemeManager;

//function GsThemeManager: TGsThemeManager;

function GetImageDimensions(ASize: TImageSize): TImageDimensions;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Vcl.Forms,
  Vcl.Consts;

resourcestring
  SErrorControllerFound = 'Der ThemeController wurde bereits auf Formular ''%s'' gefunden, es wird nur eine Instanz pro Applikation unterstützt!';
  SErrorInvalidComponentRegistered = 'Ungültige Klasse ''%s'' wurde registriert!';
  SErrorInvalidComponentRemoved = 'Ungültige Klasse ''%s'' wurde entfernt!';

const
  IMAGE_SIZE_16            = $00000010;
  IMAGE_SIZE_24            = $00000018;
  IMAGE_SIZE_32            = $00000020;
  IMAGE_SIZE_48            = $00000030;
  IMAGE_SIZE_64            = $00000040;
  IMAGE_SIZE_128           = $00000080;
  IMAGE_SIZE_256           = $00000100;

  IMAGE_SIZES: array [TImageSize] of TImageDimensions = (
      (Height: 0; Width: 0),
      (Height: IMAGE_SIZE_16; Width: IMAGE_SIZE_16),
      (Height: IMAGE_SIZE_24; Width: IMAGE_SIZE_24),
      (Height: IMAGE_SIZE_32; Width: IMAGE_SIZE_32),
      (Height: IMAGE_SIZE_48; Width: IMAGE_SIZE_48),
      (Height: IMAGE_SIZE_64; Width: IMAGE_SIZE_64),
      (Height: IMAGE_SIZE_128; Width: IMAGE_SIZE_128),
      (Height: IMAGE_SIZE_256; Width: IMAGE_SIZE_256)
    );

  IMAGE_LIST_TAG_ENABLED_MASK = $00000001;
  IMAGE_LIST_TAG_DISABLED_MASK = $00000002;

(*
function GsThemeManager: TGsThemeManager;
begin
end;
*)

function GetImageDimensions(ASize: TImageSize): TImageDimensions;
begin
  Result := IMAGE_SIZES[ASize];
end;

{ TAbstractGsThemeManagerComponent }

constructor TAbstractGsThemeManagerComponent.Create(AOwner: TComponent);
begin
  inherited;

  ThemeManager.ComponentRegistration(Self);
end;

destructor TAbstractGsThemeManagerComponent.Destroy;
begin
  ThemeManager.RemoveComponentRegistration(Self);

  inherited;
end;

function TAbstractGsThemeManagerComponent.GetThemeManager: TGsThemeManager;
begin
  Result := GsThemeManager;
end;

{ TCustomGsThemeManagerComponent }

procedure TCustomGsThemeManagerComponent.Dummy;
begin

end;

{ TActionManagerItem }

procedure TActionManagerItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TActionManagerItem then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      ActionManager := TActionManagerItem(Source).ActionManager;
      Caption := TActionManagerItem(Source).Caption;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end;
end;

function TActionManagerItem.GetCaption: String;
begin
  Result := FCaption;

  if (Length(Result) = 0) then
    if Assigned(FActionManager) then
      Result := FActionManager.Name
    else
      Result := SNoName;
end;

function TActionManagerItem.GetDisplayName: String;
begin
  if Assigned(FActionManager) then
    Result := Caption
  else
    Result := inherited GetDisplayName;
end;

function TActionManagerItem.Owner: TActionManagerCollection;
begin
  Result := TActionManagerCollection(Collection);
end;

procedure TActionManagerItem.SetActionManager(
  const Value: TCustomActionManager);
begin
  if (FActionManager <> Value) then
  begin
    if Assigned(FActionManager) then
      FActionManager.RemoveFreeNotification(Owner.ThemeController);
    FActionManager := Value;
    if Assigned(FActionManager) then
      FActionManager.FreeNotification(Owner.ThemeController);
  end;
end;

{ TActionManagerCollection }

function TActionManagerCollection.GetListItem(
  Index: Integer): TActionManagerItem;
begin
  Result := TActionManagerItem(Items[Index]);
end;

function TActionManagerCollection.GetThemeController: TAbstractGsThemeController;
begin
  Result := TAbstractGsThemeController(Owner);
end;

procedure TActionManagerCollection.SetListItem(Index: Integer;
  const Value: TActionManagerItem);
begin
  Items[Index].Assign(Value);
end;

{ TCustomImageListItem }

procedure TCustomImageListItem.Assign(Source: TPersistent);
begin
  if Source is TCustomImageListItem then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      Images := TCustomImageListItem(Source).Images;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

function TCustomImageListItem.GetDisplayName: String;
begin
  if Assigned(FImages) then
    Result := FImages.Name
  else
    Result := inherited GetDisplayName;
end;

function TCustomImageListItem.IsImagesStored: Boolean;
begin
  Result := True;
end;

function TCustomImageListItem.Owner: TAbstractImageListCollection;
begin
  Result := TAbstractImageListCollection(Collection);
end;

procedure TCustomImageListItem.SetImages(const Value: TCustomImageList);
begin
  if not Assigned(FImages) then
    FImages := Value;
end;

{ TAbstractImageListCollection }

constructor TAbstractImageListCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, ItemClass);
end;

{ TImageListCollection }

function TImageListCollection.GetListItem(Index: Integer): TImageListItem;
begin
  Result := TImageListItem(Items[Index]);
end;

function TImageListCollection.ItemClass: TCollectionItemClass;
begin
  Result := TImageListItem;
end;

procedure TImageListCollection.SetListItem(Index: Integer;
  const Value: TImageListItem);
begin
  Items[Index].Assign(Value);
end;

{ TCustomImageSizeItem }

procedure TCustomImageSizeItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TCustomImageSizeItem then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      DisabledImages := TCustomImageSizeItem(Source).DisabledImages;
      Size := TCustomImageSizeItem(Source).Size;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end;
end;

function TCustomImageSizeItem.GetDisabledImages: TCustomImageList;
begin
  Result := FDisabledImages;
end;

function TCustomImageSizeItem.GetDisplayName: String;
begin
  if Assigned(FImages) or Assigned(FDisabledImages) then
    Result := Format('%1:dx%0:d', [Height, Width])
  else
    Result := inherited GetDisplayName;
end;

function TCustomImageSizeItem.GetHeight: TImageHeight;
begin
  if Assigned(FImages) then
    Result := FImages.Height
  else if Assigned(FDisabledImages) then
    Result := FDisabledImages.Height
  else
    Result := 0;
end;

function TCustomImageSizeItem.GetSize: TImageSize;
var
  I: TImageSize;
begin
  Result := FImageSize;

  if (FImageSize = isUnknown) and (Assigned(FImages) or Assigned(FDisabledImages)) then
  begin
    for I := Low(IMAGE_SIZES) to High(IMAGE_SIZES) do
    begin
      if (Height = IMAGE_SIZES[I].Height) and (Width = IMAGE_SIZES[I].Width) then
      begin
        FImageSize := I;
        Break;
      end;
    end;

    Result := FImageSize;
  end;
end;

function TCustomImageSizeItem.GetWidth: TImageWidth;
begin
  if Assigned(FImages) then
    Result := FImages.Width
  else if Assigned(FDisabledImages) then
    Result := FDisabledImages.Width
  else
    Result := 0;
end;

function TCustomImageSizeItem.IsDisabledImagesStored: Boolean;
begin
  Result := False;
end;

function TCustomImageSizeItem.IsImagesStored: Boolean;
begin
  Result := False;
end;

function TCustomImageSizeItem.IsSizeStored: Boolean;
begin
  Result := False;
end;

function TCustomImageSizeItem.Owner: TAbstractImageSizeCollection;
begin
  Result := TAbstractImageSizeCollection(Collection);
end;

procedure TCustomImageSizeItem.SetDisabledImages(const Value: TCustomImageList);
begin
  if not Assigned(FDisabledImages) then
    FDisabledImages := Value;
end;

procedure TCustomImageSizeItem.SetHeight(const Value: TImageHeight);
begin
  { readonly property, do nothing }
end;

procedure TCustomImageSizeItem.SetSize(const Value: TImageSize);
begin
  if FImageSize = isUnknown then
    FImageSize := Value;
end;

procedure TCustomImageSizeItem.SetWidth(const Value: TImageWidth);
begin
  { readonly property, do nothing }
end;

{ TAbstractImageSizeCollection }

function TAbstractImageSizeCollection.GetImageSize(
  Size: TImageSize): TCustomImageSizeItem;
begin
  Result := TCustomImageSizeItem(Items[IndexOf(Size)]);
end;

function TAbstractImageSizeCollection.GetImageSizeItem(
  Index: Integer): TCustomImageSizeItem;
begin
  Result := TCustomImageSizeItem(Items[Index]);
end;

function TAbstractImageSizeCollection.IndexOf(ASize: TImageSize): Integer;
begin
  for Result := 0 to Count - 1 do
    if ImageSizeItems[Result].Size = ASize then
      Exit;
  Result := -1;
end;

procedure TAbstractImageSizeCollection.SetImageSize(Size: TImageSize;
  const Value: TCustomImageSizeItem);
begin
  { readonly property, do nothing }
end;

procedure TAbstractImageSizeCollection.SetImageSizeItem(Index: Integer;
  const Value: TCustomImageSizeItem);
begin
  { readonly property, do nothing }
end;

{ TImageSizeCollection }

function TImageSizeCollection.GetImageSizeItemNew(
  Index: Integer): TImageSizeItem;
begin
  Result := TImageSizeItem(inherited ImageSizeItems[Index]);
end;

function TImageSizeCollection.ItemClass: TCollectionItemClass;
begin
  Result := TImageSizeItem;
end;

procedure TImageSizeCollection.SetImageSizeItemNew(Index: Integer;
  const Value: TImageSizeItem);
begin
  inherited ImageSizeItems[Index] := Value;
end;

{ TAbstractGsThemeController }

constructor TAbstractGsThemeController.Create(AOwner: TComponent);
begin
  if Assigned(GsThemeController) then
    raise EGsThemeController.CreateResFmt(@SErrorControllerFound, [GsThemeController.Owner.Name]);

  GsThemeController := Self;

  inherited;

end;

destructor TAbstractGsThemeController.Destroy;
begin

  inherited;

  if GsThemeController = Self then
    GsThemeController := nil;
end;

function TAbstractGsThemeController.GetImageSizes: TImageSizeCollection;
begin
  Result := ThemeManager.ImageSizes;
end;

function TAbstractGsThemeController.GetLinkedActionLists: TActionListCollection;
begin
  if not Assigned(FLinkedActionLists) then
    FLinkedActionLists := TActionListCollection.Create(Self, TActionListItem);

  Result := FLinkedActionLists;
end;

function TAbstractGsThemeController.GetLinkedActionManagers: TActionManagerCollection;
begin
  if not Assigned(FLinkedActionManagers) then
    FLinkedActionManagers := TActionManagerCollection.Create(Self, TActionManagerItem);

  Result := FLinkedActionManagers;
end;

function TAbstractGsThemeController.IsLinkedActionListsStored: Boolean;
begin
  Result := Assigned(FLinkedActionLists) and (LinkedActionLists.Count > 0);
end;

function TAbstractGsThemeController.IsLinkedActionManagersStored: Boolean;
begin
  Result := Assigned(FLinkedActionManagers) and (LinkedActionManagers.Count > 0);
end;

procedure TAbstractGsThemeController.SetImageSizes(
  const Value: TImageSizeCollection);
begin
  { readonly property, do nothing }
end;

procedure TAbstractGsThemeController.SetLinkedActionLists(
  const Value: TActionListCollection);
begin
  if not Assigned(FLinkedActionLists) then
    FLinkedActionLists := TActionListCollection.Create(Self, TActionListItem);

  FLinkedActionLists.Assign(Value);
end;

procedure TAbstractGsThemeController.SetLinkedActionManagers(
  const Value: TActionManagerCollection);
begin
  if not Assigned(FLinkedActionManagers) then
    FLinkedActionManagers := TActionManagerCollection.Create(Self, TActionManagerItem);

  FLinkedActionManagers.Assign(Value);
end;

{ TCustomGsThemeController }

procedure TCustomGsThemeController.Dummy;
begin

end;

{ TGsThemeController }

procedure TGsThemeController.Dummy;
begin

end;

{ TAbstractGsThemeStyler }

procedure TAbstractGsThemeStyler.Dummy;
begin

end;

{ TCustomGsThemeStyler }

procedure TCustomGsThemeStyler.Dummy;
begin

end;

{ TGsThemeStyler }

procedure TGsThemeStyler.Dummy;
begin

end;

{ TAbstractGsThemeManager }

destructor TAbstractGsThemeManager.Destroy;
begin
  inherited;
end;

function TAbstractGsThemeManager.GetController: TAbstractGsThemeController;
begin
  Result := GsThemeController;
end;

function TAbstractGsThemeManager.GetLinkedActionLists: TActionListCollection;
begin
  Result := Controller.LinkedActionLists;
end;

function TAbstractGsThemeManager.GetLinkedActionManagers: TActionManagerCollection;
begin
  Result := Controller.LinkedActionManagers;
end;

procedure TAbstractGsThemeManager.ReadState(Reader: TReader);
begin
  inherited;

  OldCreateOrder := False;
end;

procedure TAbstractGsThemeManager.SetLinkedActionLists(
  const Value: TActionListCollection);
begin
  { readonly property, do nothing }
end;

procedure TAbstractGsThemeManager.SetLinkedActionManagers(
  const Value: TActionManagerCollection);
begin
  { readonly property, do nothing }
end;

{ TGsThemeManager }

procedure TGsThemeManager.ComponentRegistration(
  AComponent: TAbstractGsThemeManagerComponent);
begin
  if AComponent is TAbstractGsThemeController then
  begin
  end
  else if AComponent is TAbstractGsThemeStyler then
  begin

  end
  else
    raise EGsThemeManager.CreateResFmt(@SErrorInvalidComponentRegistered, [AComponent.ClassName]);
end;

constructor TGsThemeManager.Create(AOwner: TComponent);
begin
  inherited;

  FStylers := TGsStylerList.Create;
end;

function TGsThemeManager.CreateImageSizes: TImageSizeCollection;

  function FindSizes(AImageSizeCollection: TImageSizeCollection;
    AHeight: TImageHeight; AWidth: TImageWidth): TImageSizeItem;
  var
    I: Integer;
  begin
    Result := nil;

    with AImageSizeCollection do
    begin
      for I := 0 to Count - 1 do
      begin
        if (ImageSizeItems[I].Height = AHeight) and (ImageSizeItems[I].Width = AWidth) then
        begin
          Result := ImageSizeItems[I];
          Break;
        end;
      end;
    end;
  end;

var
  I: Integer;
  Item: TImageSizeItem;
begin
  Result := TImageSizeCollection.Create(Self);

  for I := 0 to ComponentCount - 1 do
  begin
    if (Components[I].Tag > 0) and (Components[I] is TCustomImageList) then
    begin
      Item := FindSizes(Result, TCustomImageList(Components[I]).Height, TCustomImageList(Components[I]).Width);

      if not Assigned(Item) then
        Item := TImageSizeItem(Result.Add);

      if ((Components[I].Tag and IMAGE_LIST_TAG_ENABLED_MASK) <> 0) then
        Item.Images := TCustomImageList(Components[I])
      else if ((Components[I].Tag and IMAGE_LIST_TAG_DISABLED_MASK) <> 0) then
        Item.DisabledImages := TCustomImageList(Components[I]);
    end;
  end;
end;

destructor TGsThemeManager.Destroy;
begin
  if Assigned(FImageSizes) then
    FImageSizes.Free;

  FStylers.Free;

  inherited;
end;

function TGsThemeManager.GetImageSizes: TImageSizeCollection;
begin
  if not Assigned(FImageSizes) then
    FImageSizes := CreateImageSizes;

  Result := FImageSizes;
end;

function TGsThemeManager.GetStylers: TGsStylerList;
begin
  Result := FStylers;
end;

procedure TGsThemeManager.RemoveComponentRegistration(
  AComponent: TAbstractGsThemeManagerComponent);
begin
  if AComponent is TAbstractGsThemeController then
  begin
  end
  else if AComponent is TAbstractGsThemeStyler then
  begin

  end
  else
    raise EGsThemeManager.CreateResFmt(@SErrorInvalidComponentRemoved, [AComponent.ClassName]);
end;

procedure TGsThemeManager.SetImageSizes(const Value: TImageSizeCollection);
begin
  { readonly property, do nothing }
end;

procedure TGsThemeManager.SetStylers(const Value: TGsStylerList);
begin
  FStylers.Assign(Value);
end;

initialization
  GsThemeManager := TGsThemeManager.Create(nil);
finalization
  GsThemeManager.Free;
end.
