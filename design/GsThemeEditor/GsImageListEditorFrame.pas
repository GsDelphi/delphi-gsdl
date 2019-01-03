unit GsImageListEditorFrame;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  RzLstBox,
  RzPanel,
  RzSplit,
  GsTheme, RzLabel, RzPrgres;

type
  TGsImageListEditor = class(TFrame)
    RzSplitter1: TRzSplitter;
    GBImageList: TRzGroupBox;
    GBImageFiles: TRzGroupBox;
    RzToolbar1: TRzToolbar;
    LBImageList: TRzListBox;
    LBImageFileList: TRzListBox;
    PProgess: TRzPanel;
    PBProgress: TRzProgressBar;
    LProgress: TRzLabel;
    procedure LBImageFileListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LBImageFileListDblClick(Sender: TObject);
    procedure LBImageFileListEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure LBImageFileListStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure FrameResize(Sender: TObject);
    procedure LBImageListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private-Deklarationen }
    // FFileList: TGsImageFileList;
    FILMaxTextWidth: Integer;
    FIFLMaxTextWidth: Integer;
    FTheme: TCustomGsTheme;
    function GetIFLMaxTextWidth: Integer;
    function GetILMaxTextWidth: Integer;
    procedure SetIFLMaxTextWidth(const Value: Integer);
    procedure SetILMaxTextWidth(const Value: Integer);
    procedure SetTheme(const Value: TCustomGsTheme);
    procedure UpdateImageFileListProgress(Sender: TObject; TotalParts,
      PartsComplete: Integer; var Continue: Boolean; const Msg: string);
  protected
    const
      IL_ICON_SIZE = 32;
      IFL_ICON_SIZE = 32;

    procedure UpdateUI;

    //procedure UpdateList(AListBox: TRzListBox; );

    procedure UpdateImageFileList;
    procedure ResizeImageFileList;

    procedure UpdateImageList;
    procedure ResizeImageList;

    property ILMaxTextWidth: Integer read GetILMaxTextWidth write SetILMaxTextWidth;
    property IFLMaxTextWidth: Integer read GetIFLMaxTextWidth write SetIFLMaxTextWidth;
  public
    { Public-Deklarationen }
    property Theme: TCustomGsTheme read FTheme write SetTheme;
  end;

implementation

{$R *.dfm}

uses
  GsFileCtrl,
  Math;

procedure TGsImageListEditor.FrameResize(Sender: TObject);
begin
  ResizeImageFileList;
end;

function TGsImageListEditor.GetIFLMaxTextWidth: Integer;
begin
  Result := Max(FIFLMaxTextWidth, 50);
end;

function TGsImageListEditor.GetILMaxTextWidth: Integer;
begin
  Result := Max(FILMaxTextWidth, 50);
end;

procedure TGsImageListEditor.LBImageFileListDblClick(Sender: TObject);
begin
  { Add image to image lists }
  if Sender is TRzListBox and (TRzListBox(Sender).ItemIndex <> -1) then
    with Sender as TRzListBox do
    begin
      Theme.AddImage(TGsImageFileListItem(Items.Objects[ItemIndex]));
      UpdateImageList;
    end;
end;

procedure TGsImageListEditor.LBImageFileListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  TextOffset: Integer;
  Picture: TPicture;
begin
  with Control as TRzListBox do
  begin
    { Clear area for icon and text }
    Canvas.FillRect(Rect);

    { Draw icon }
    if Assigned(Items.Objects[Index]) then
    begin
      Picture := TPicture.Create;

      try
        if TGsImageFileListItem(Items.Objects[Index]).GetImage(Picture) then
          Canvas.Draw(Rect.Left - IFL_ICON_SIZE - 5, Rect.Top + 1, Picture.Graphic);
      finally
        Picture.Free;
      end;
    end;

    { Draw text }
    TextOffset := ((Rect.Bottom - Rect.Top) - Canvas.TextHeight('Pp')) div 2;
    IFLMaxTextWidth := Canvas.TextWidth(Items[Index]) + 4;
    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + TextOffset, Items[Index]);
  end;
end;

procedure TGsImageListEditor.LBImageFileListEndDrag(Sender, Target: TObject;
  X, Y: Integer);
begin
  //
end;

procedure TGsImageListEditor.LBImageFileListStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  //
end;

procedure TGsImageListEditor.LBImageListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  TextOffset: Integer;
  Picture: TPicture;
begin
  with Control as TRzListBox do
  begin
    { Clear area for icon and text }
    Canvas.FillRect(Rect);

    { Draw icon }
    if Assigned(Items.Objects[Index]) then
    begin
      Picture := TPicture.Create;

      try
        if TGsImageListItem(Items.Objects[Index]).GetImage(Picture) then
          Canvas.Draw(Rect.Left - IL_ICON_SIZE - 5, Rect.Top + 1, Picture.Graphic);
      finally
        Picture.Free;
      end;
    end;

    { Draw text }
    TextOffset := ((Rect.Bottom - Rect.Top) - Canvas.TextHeight('Pp')) div 2;
    ILMaxTextWidth := Canvas.TextWidth(Items[Index]) + 4;
    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + TextOffset, Items[Index]);
  end;
end;

procedure TGsImageListEditor.ResizeImageFileList;
begin
  LBImageFileList.Columns := LBImageFileList.Width div (IFL_ICON_SIZE + 2 + 4 + IFLMaxTextWidth);
end;

procedure TGsImageListEditor.ResizeImageList;
begin
  LBImageList.Columns := LBImageList.Width div (IL_ICON_SIZE + 2 + 4 + ILMaxTextWidth);
end;

procedure TGsImageListEditor.SetIFLMaxTextWidth(const Value: Integer);
begin
  if FIFLMaxTextWidth < Value then
  begin
    FIFLMaxTextWidth := Value;
    ResizeImageFileList;
  end;
end;

procedure TGsImageListEditor.SetILMaxTextWidth(const Value: Integer);
begin
  if FILMaxTextWidth < Value then
  begin
    FILMaxTextWidth := Value;
    ResizeImageList;
  end;
end;

procedure TGsImageListEditor.SetTheme(const Value: TCustomGsTheme);
begin
  if (FTheme <> Value) then
  begin
    FTheme := Value;
    UpdateUI;
  end;
end;

procedure TGsImageListEditor.UpdateImageFileList;
var
  ImageFiles: TGsImageFileList;
begin
  with LBImageFileList do
  begin
    Screen.Cursor := crHourGlass;
    Visible := False;
    Items.BeginUpdate;

    try
      ImageFiles := Theme.Images[2].Stock.ImageFiles;
      ImageFiles.OnProgress := UpdateImageFileListProgress;

      //ImageFiles.
      //LBImageFiles.OwnerDrawIndent := ImageFiles.

      ItemHeight := IFL_ICON_SIZE + 2;
      OwnerDrawIndent := IFL_ICON_SIZE + 6;

      Items.Assign(ImageFiles);
      // Refresh;
      //ResizeImageFileList;
    finally
      Items.EndUpdate;
      Visible := True;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TGsImageListEditor.UpdateImageFileListProgress(Sender: TObject;
  TotalParts, PartsComplete: Integer; var Continue: Boolean; const Msg: string);
resourcestring
  SProgress = '%s, Schritt %d von %d...';
begin
  PBProgress.TotalParts := TotalParts;
  PBProgress.PartsComplete := PartsComplete;
  LProgress.Caption := Format(SProgress, [Msg, PartsComplete, TotalParts]);
  PProgess.Visible := TotalParts <> PartsComplete;
end;

procedure TGsImageListEditor.UpdateImageList;
var
  ImageFiles: TGsImageList;
begin
  with LBImageList do
  begin
    Screen.Cursor := crHourGlass;
    Visible := False;
    Items.BeginUpdate;

    try
      ImageFiles := Theme.Images[2].List.ImageFiles;
      ImageFiles.OnProgress := UpdateImageFileListProgress;

      //ImageFiles.
      //LBImageFiles.OwnerDrawIndent := ImageFiles.

      ItemHeight := IFL_ICON_SIZE + 2;
      OwnerDrawIndent := IFL_ICON_SIZE + 6;

      Items.Assign(ImageFiles);
      // Refresh;
      //ResizeImageFileList;
    finally
      Items.EndUpdate;
      Visible := True;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TGsImageListEditor.UpdateUI;
begin
  UpdateImageFileList;
  UpdateImageList;
end;

end.
