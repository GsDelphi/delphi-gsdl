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
unit GsFileCtrl;

interface

uses
  Classes,
  SysUtils,
  Graphics,
  Contnrs,
  SyncObjs,
  Controls,
  System.Generics.Collections,
  GsTypes,
  GsClasses;

type
  TGsImageFileList = class;

  TGsImageFolderPath = type TGsFolderPath;
  TGsImageFileName = type TGsFileName;
  TGsImageFilePath = type TGsFilePath;

  (*
  TCustomGsImageFileThread = class(TThread)
  private
  protected
    { TThread }
    procedure Execute; override;

    class function GetInstance: TCustomGsImageFileThread; virtual; abstract;
    class function GetWaitingObjs: TObjectList; virtual; abstract;
    class procedure FreeObjs(AInstance: TCustomGsImageFileThread);
      virtual; abstract;

    procedure InternalExecute; virtual; abstract;
    function Owner: TGsImageFileList;
  public
    constructor Create;
    // class function Run(AOwner: TGsImageFileList): TCustomGsImageFileThread;
  end;

  TGsImageFileLoader = class(TCustomGsImageFileThread)
  private
  class var
    FInstance: TGsImageFileLoader;
    FWaitingObjs: TObjectList;
    FEvents: TObjectList;
  protected
    FImageIndex: Integer;
    FImageCount: Integer;
    class function GetInstance: TCustomGsImageFileThread; override;
    class function GetWaitingObjs: TObjectList; override;
    class procedure FreeObjs(AInstance: TCustomGsImageFileThread); override;
    class function GetEvents: TObjectList;

    procedure InternalExecute; override;
    function Finished: TEvent;
  protected
    procedure DoUpdateImageCount;
    procedure DoLoadImage;
  public
    class function Run(AOwner: TGsImageFileList): TEvent;
  end;

  TGsImageFileSeeker = class(TCustomGsImageFileThread)
  private
  class var
    FInstance: TGsImageFileSeeker;
    FWaitingObjs: TObjectList;
    FCacheImages: TList<Boolean>;
  protected
    class function GetInstance: TCustomGsImageFileThread; override;
    class function GetWaitingObjs: TObjectList; override;
    class procedure FreeObjs(AInstance: TCustomGsImageFileThread); override;
    class function GetCacheImages: TList<Boolean>;

    procedure InternalExecute; override;
    function CacheImages: Boolean;
  public
    class procedure Run(AOwner: TGsImageFileList; CacheImages: Boolean = False);
  end;
  *)

  TGsImageFileListItem = class(TGsPersistent)
  private
    FOwner: TGsImageFileList;
    FFileName: TGsImageFileName;
    FImageIndex: Integer;
    FImageLoaded: Boolean;
    //function GetImage: TPicture;
    function GetImageLoaded: Boolean;
    function GetIndex: Integer;
  protected
    function GetOwner: TPersistent; override;
    function Owner: TGsImageFileList;
    function LoadImageFromFile(Image: TPicture): Boolean;
    property ImageLoaded: Boolean read GetImageLoaded;
  public
    constructor Create(AOwner: TGsImageFileList; AFileName: TGsImageFileName);
    destructor Destroy; override;

    procedure LoadImage;
    function GetImage(Image: TPicture): Boolean;

    property Index: Integer read GetIndex;
    property FileName: TGsImageFileName read FFileName;
    //property Image: TPicture read GetImage;
    property ImageIndex: Integer read FImageIndex;
  end;

  TGsImageFileList = class(TGsPersistent)
  private
    FPath: String;
    FCacheImages: Boolean;
    FImages: TList<TGsImageFileListItem>;
    FCachedImages: TImageList;
    FOnProgress: TGsProgressEvent;
    function GetCachedImages: TImageList;
    function GetCount: Integer;
    function GetImage(Index: Integer): TGsImageFileListItem;
    procedure SetCacheImages(const Value: Boolean);
    procedure SetPath(const Value: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure StartFileSeeker;
    function Progress(TotalParts, PartsComplete: Integer; const Msg: string): Boolean;
  public
    constructor Create(APath: TGsImageFolderPath;
      ACacheImages: Boolean = False);
    destructor Destroy; override;

    function FindName(AFileName: TGsImageFileName): TGsImageFileListItem;

    property Path: String read FPath write SetPath;
    property Images[Index: Integer]: TGsImageFileListItem
      read GetImage; default;
    property Count: Integer read GetCount;
    property CacheImages: Boolean read FCacheImages write SetCacheImages;
    property CachedImages: TImageList read GetCachedImages;
    property OnProgress: TGsProgressEvent read FOnProgress write FOnProgress;
  end;

implementation

uses
  RzCommon,
  Types,
  pngimage,
  Forms,
  Masks,
  System.IOUtils;

var
  LLock: TCriticalSection = nil;

function Lock: TCriticalSection;
begin
  if not Assigned(LLock) then
    LLock := TCriticalSection.Create;

  Result := LLock;
end;

var
  LFilters: TStrings;

function FileFilter(const Path: string; const SearchRec: TSearchRec): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := False;

  for I := 0 to LFilters.Count - 1 do
  begin
    S := LFilters.Strings[I];

    if S <> '' then
      Result := Result or MatchesMask(SearchRec.Name, S);

    if Result then
      Break;
  end;
end;

procedure UpdateFileList(AImageFileList: TGsImageFileList;
  const Path, FileMask: string);
var
  LMask: string;
  LList: TStringDynArray;
  I: Integer;
  Item: TGsImageFileListItem;
  BasePath: string;
begin
  if FileMask = '' then
    LMask := GraphicFileMask(TGraphic)
  else
    LMask := FileMask;

  LFilters := TStringList.Create;

  try
    LFilters.Delimiter := ';';
    LFilters.QuoteChar := #0;
    LFilters.StrictDelimiter := True;
    LFilters.DelimitedText := LMask;
    LList := TDirectory.GetFiles(Path, FileFilter);
  finally
    LFilters.Free;
  end;

  { Add or replace items with current search }
  BasePath := IncludeTrailingPathDelimiter(AImageFileList.Path);

  for I := 0 to Length(LList) - 1 do
  begin
    Item := TGsImageFileListItem.Create(AImageFileList, ExtractRelativePath(BasePath, LList[I]));

    if I < AImageFileList.Count then
      AImageFileList.FImages.Items[I] := Item
    else
      AImageFileList.FImages.Add(Item);

    if Application.Terminated then
      Exit;
  end;

  { Delete old resting images }
  if not Application.Terminated and (AImageFileList.Count > Length(LList)) then
  begin
    AImageFileList.FImages.DeleteRange(Length(LList), AImageFileList.Count - Length(LList));
  end;

  (*
    Finished := nil;
    FileAttrs := 0;

    Res := SysUtils.FindFirst(IncludeTrailingPathDelimiter(Owner.Path) + '*.png',
    FileAttrs, SR);

    try
    I := 0;

    { add or replace items with current search }
    while not Terminated and (Res = 0) do
    begin
    Item := TGsImageFileListItem.Create(Owner, SR.Name);

    if I < Owner.Count then
    Owner.FImages.Items[I] := Item
    else
    Owner.FImages.Add(Item);

    Res := SysUtils.FindNext(SR);

    if (I = -1) and CacheImages then
    Finished := TGsImageFileLoader.Run(Owner);

    Inc(I);
    Sleep(1);
    end;

    { Delete old resting images }
    if (Res <> 0) and (Owner.Count > I) then
    begin
    Owner.FImages.DeleteRange(I, Owner.Count - I);
    end;
    finally
    SysUtils.FindClose(SR);

    if Assigned(Finished) then
    Finished.SetEvent;

    GetCacheImages.Delete(0);
    end;
  *)
end;

{ TCustomGsImageFileThread }
(*
constructor TCustomGsImageFileThread.Create;
begin
  inherited Create;

  FreeOnTerminate := True;
  Priority := tpLowest;
end;

procedure TCustomGsImageFileThread.Execute;
begin
  NameThreadForDebugging(ClassName);

  try
    while not Terminated and (GetWaitingObjs.Count > 0) do
    begin
      try
        InternalExecute;
      finally
        GetWaitingObjs.Delete(0);
        Sleep(1);
      end;
    end;
  finally
    Lock.Acquire;

    try
      FreeObjs(Self);
    finally
      Lock.Release;
    end;
  end;
end;

function TCustomGsImageFileThread.Owner: TGsImageFileList;
begin
  Result := TGsImageFileList(GetWaitingObjs.Items[0]);
end;

{ TGsImageFileLoader }

procedure TGsImageFileLoader.DoLoadImage;
begin
  Owner.Images[FImageIndex].LoadImage;
end;

procedure TGsImageFileLoader.DoUpdateImageCount;
begin
  FImageCount := Owner.Count;
end;

function TGsImageFileLoader.Finished: TEvent;
begin
  Result := TEvent(GetEvents.Items[0]);
end;

class procedure TGsImageFileLoader.FreeObjs
  (AInstance: TCustomGsImageFileThread);
begin
  if Assigned(FWaitingObjs) and (FWaitingObjs.Count = 0) then
  begin
    try
      FWaitingObjs.Free;
      FWaitingObjs := nil;
    except
      FWaitingObjs := nil;
    end;
  end;

  if FInstance = AInstance then
    FInstance := nil;
end;

class function TGsImageFileLoader.GetEvents: TObjectList;
begin
  if not Assigned(FEvents) then
    FEvents := TObjectList.Create(False);

  Result := FEvents;
end;

class function TGsImageFileLoader.GetInstance: TCustomGsImageFileThread;
begin
  if not Assigned(FInstance) then
    FInstance := Create;

  Result := FInstance;
end;

class function TGsImageFileLoader.GetWaitingObjs: TObjectList;
begin
  if not Assigned(FWaitingObjs) then
    FWaitingObjs := TObjectList.Create(False);

  Result := FWaitingObjs;
end;

procedure TGsImageFileLoader.InternalExecute;
var
  I: Integer;
begin
  I := 0;

  try
    while not Terminated do
    begin
      Synchronize(DoUpdateImageCount);
      if (I < FImageCount) then
      // if (I < Owner.Count) then
      begin
        Synchronize(DoLoadImage);
        // Owner.Images[I].LoadImage;
        Inc(I);
        Sleep(1);
      end
      else
      begin
        if Finished.WaitFor(50) = wrSignaled then
          Break;
      end;
    end;
  finally
    GetEvents.Delete(0);
  end;
end;

class function TGsImageFileLoader.Run(AOwner: TGsImageFileList): TEvent;
var
  I: Integer;
begin
  Lock.Acquire;

  try
    I := GetWaitingObjs.IndexOf(AOwner);
    if I = -1 then
    begin
      GetWaitingObjs.Add(AOwner);
      I := GetEvents.Add(TEvent.Create(nil, True, False,
        Format('%s(%p)', [AOwner.ClassName, Pointer(AOwner)])));
    end;

    GetInstance;
    Result := TEvent(GetEvents.Items[I]);
  finally
    Lock.Release;
  end;
end;

{ TGsImageFileSeeker }

function TGsImageFileSeeker.CacheImages: Boolean;
begin
  Result := GetCacheImages[0];
end;

class procedure TGsImageFileSeeker.FreeObjs
  (AInstance: TCustomGsImageFileThread);
begin
  if Assigned(FWaitingObjs) and (FWaitingObjs.Count = 0) then
  begin
    try
      FWaitingObjs.Free;
      FWaitingObjs := nil;
    except
      FWaitingObjs := nil;
    end;
  end;

  if FInstance = AInstance then
    FInstance := nil;
end;

class function TGsImageFileSeeker.GetCacheImages: TList<Boolean>;
begin
  if not Assigned(FCacheImages) then
    FCacheImages := TList<Boolean>.Create;

  Result := FCacheImages;
end;

class function TGsImageFileSeeker.GetInstance: TCustomGsImageFileThread;
begin
  if not Assigned(FInstance) then
    FInstance := Create;

  Result := FInstance;
end;

class function TGsImageFileSeeker.GetWaitingObjs: TObjectList;
begin
  if not Assigned(FWaitingObjs) then
    FWaitingObjs := TObjectList.Create(False);

  Result := FWaitingObjs;
end;

procedure TGsImageFileSeeker.InternalExecute;
var
  FileAttrs: Integer;
  SR: TSearchRec;
  Res: Integer;
  I: Integer;
  Item: TGsImageFileListItem;
  Finished: TEvent;
begin
  Finished := nil;
  FileAttrs := 0;

  Res := SysUtils.FindFirst(IncludeTrailingPathDelimiter(Owner.Path) + '*.png',
    FileAttrs, SR);

  try
    I := 0;

    { Add or replace items with current search }
    while not Terminated and (Res = 0) do
    begin
      Item := TGsImageFileListItem.Create(Owner, SR.Name);

      if I < Owner.Count then
        Owner.FImages.Items[I] := Item
      else
        Owner.FImages.Add(Item);

      Res := SysUtils.FindNext(SR);

      if (I = -1) and CacheImages then
        Finished := TGsImageFileLoader.Run(Owner);

      Inc(I);
      Sleep(1);
    end;

    { Delete old resting images }
    if (Res <> 0) and (Owner.Count > I) then
    begin
      Owner.FImages.DeleteRange(I, Owner.Count - I);
    end;
  finally
    SysUtils.FindClose(SR);

    if Assigned(Finished) then
      Finished.SetEvent;

    GetCacheImages.Delete(0);
  end;
end;

class procedure TGsImageFileSeeker.Run(AOwner: TGsImageFileList;
  CacheImages: Boolean);
begin
  Lock.Acquire;

  try
    if GetWaitingObjs.IndexOf(AOwner) = -1 then
    begin
      GetWaitingObjs.Add(AOwner);
      GetCacheImages.Add(CacheImages);
    end;

    GetInstance;
  finally
    Lock.Release;
  end;
end;
*)

{ TGsImageFileListItem }

constructor TGsImageFileListItem.Create(AOwner: TGsImageFileList;
  AFileName: TGsImageFileName);
begin
  FOwner := AOwner;

  inherited Create;

  FFileName := ExtractRelativePath(IncludeTrailingPathDelimiter(Owner.Path), AFileName);
  FImageLoaded := False;
end;

destructor TGsImageFileListItem.Destroy;
begin

  inherited;
end;

function TGsImageFileListItem.GetImage(Image: TPicture): Boolean;
begin
  if not Owner.CacheImages then
    Result := LoadImageFromFile(Image)
  else
  begin
    Result := (Image <> nil);

    if Result then
    begin
      LoadImage;
      Result := Owner.CachedImages.GetBitmap(FImageIndex, Image.Bitmap);
    end;
  end;
end;

function TGsImageFileListItem.GetImageLoaded: Boolean;
begin
  Result := FImageLoaded or not Owner.CacheImages;
end;

function TGsImageFileListItem.GetIndex: Integer;
begin
  Result := Owner.FImages.IndexOf(Self);
end;

function TGsImageFileListItem.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TGsImageFileListItem.LoadImage;
var
  Picture: TPicture;
  Graphic: TGraphic;
  I: Integer;
  Bmp: TBitmap;
  FillColor,
  TransparentColor: TColor;
  R: TRect;
begin
  if FImageLoaded or not Owner.CacheImages then
    Exit;

  Picture := TPicture.Create;

  try
    if not LoadImageFromFile(Picture) then
      Exit;

    Graphic := Picture.Graphic;

    { set size if not done so far }
    if Owner.CachedImages.Count = 0 then
      Owner.CachedImages.SetSize(Picture.Graphic.Width, Graphic.Height);

    { fill image list up to index }
    (*
    I := Index;
    while Owner.CachedImages.Count <= I do
    *)
    FImageIndex := Owner.CachedImages.Add(nil, nil);

    Bmp := TBitmap.Create;

    try
      FillColor := clBlack;

      { handle transparency }
      if Graphic is TBitmap and (TBitmap(Graphic).AlphaFormat = afIgnored) then
        TransparentColor := TBitmap(Graphic).TransparentColor and $FFFFFF
      else if Graphic is TPngImage and Graphic.Transparent then
      begin
        TransparentColor := TPngImage(Graphic).TransparentColor and $FFFFFF
        //FillColor := clFuchsia;
        //TransparentColor := clFuchsia;
      end
      else if Graphic.Transparent then
      begin
        Bmp.SetSize(Graphic.Width, Graphic.Height);
        Bmp.PixelFormat := pf32bit;
        Bmp.AlphaFormat := afIgnored;
        Bmp.Canvas.StretchDraw(Rect(0, 0, Bmp.Width, Bmp.Height), Graphic);

        TransparentColor := Bmp.Canvas.Pixels[0, Bmp.Height - 1];
      end
      else
        TransparentColor := clDefault;

      { draw image to bitmap }
      Bmp.SetSize(Owner.CachedImages.Width, Owner.CachedImages.Height);
      Bmp.PixelFormat := pf32bit;
      Bmp.AlphaFormat := afIgnored;
      Bmp.Canvas.Brush.Color := FillColor;
      Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
      Bmp.Canvas.StretchDraw(Rect(0, 0, Bmp.Width, Bmp.Height), Graphic);

      { add bitmap to image list }
      if TransparentColor = clDefault then
      begin
        Owner.CachedImages.Replace(FImageIndex, Bmp, nil);
      end
      else
      begin
        Owner.CachedImages.ReplaceMasked(FImageIndex, Bmp, TransparentColor);
      end;

      { Set loaded flag to force image list access }
      FImageLoaded := True;
    finally
      Bmp.Free;
    end;
  finally
    Picture.Free;
  end;
end;

function TGsImageFileListItem.LoadImageFromFile(Image: TPicture): Boolean;
begin
  Result := (Image <> nil);

  if Result then
    Image.LoadFromFile(IncludeTrailingPathDelimiter(Owner.Path) + FileName);
end;

function TGsImageFileListItem.Owner: TGsImageFileList;
begin
  Result := FOwner;
end;

{ TGsImageFileList }

procedure TGsImageFileList.AssignTo(Dest: TPersistent);
resourcestring
  SAddingFiles = 'Bilder werden geladen';
  SDeletingFiles = 'Bilder werden gelöscht';
var
  I,
  TotalParts: Integer;
  Item: TGsImageFileListItem;
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

constructor TGsImageFileList.Create(APath: TGsImageFolderPath;
  ACacheImages: Boolean);
begin
  inherited Create;

  FPath := APath;
  FCacheImages := True; //ACacheImages;
  FImages := TList<TGsImageFileListItem>.Create;

  StartFileSeeker;
end;

destructor TGsImageFileList.Destroy;
begin
  if Assigned(FCachedImages) then
    FCachedImages.Free;

  FImages.Free;

  inherited;
end;

function TGsImageFileList.FindName(
  AFileName: TGsImageFileName): TGsImageFileListItem;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Images[I].FileName = AFileName then
    begin
      Result := Images[I];
      Exit;
    end;
  end;

  Result := nil;
end;

function TGsImageFileList.GetCachedImages: TImageList;
begin
  if not Assigned(FCachedImages) and CacheImages then
    FCachedImages := TImageList.Create(nil);

  Result := FCachedImages;
end;

function TGsImageFileList.GetCount: Integer;
begin
  Result := FImages.Count;
end;

function TGsImageFileList.GetImage(Index: Integer): TGsImageFileListItem;
begin
  Result := TGsImageFileListItem(FImages.Items[Index]);
end;

function TGsImageFileList.Progress(TotalParts,
  PartsComplete: Integer; const Msg: string): Boolean;
begin
  Result := True;

  if Assigned(FOnProgress) then
    FOnProgress(Self, TotalParts, PartsComplete, Result, Msg);
end;

procedure TGsImageFileList.SetCacheImages(const Value: Boolean);
begin
  if FCacheImages <> Value then
  begin
    FCacheImages := Value;
    StartFileSeeker;
  end;
end;

procedure TGsImageFileList.SetPath(const Value: String);
begin
  if FPath <> Value then
  begin
    FPath := Value;
    StartFileSeeker;
  end;
end;

procedure TGsImageFileList.StartFileSeeker;
begin
  UpdateFileList(Self, Path, '');
  //TGsImageFileSeeker.Run(Self, FCacheImages);
end;

initialization

LLock := nil;

finalization

if Assigned(LLock) then
  LLock.Free;

end.
