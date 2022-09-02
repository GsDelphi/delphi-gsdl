unit ThemeMgrMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GsThemeMgr, Vcl.StdCtrls, RzLstBox,
  Vcl.ExtCtrls, RzPanel, GsFileCtrl, BPExtCtrls, RzLabel, RzPrgres,
  Vcl.ComCtrls, RzListVw, Vcl.ImgList, RzButton, Vcl.ExtDlgs, GsClasses, RzTabs,
  GsImageListEditorFrame;

type
  TForm1 = class(TForm)
    GsThemeController1: TGsThemeController;
    GrpStockImages: TRzGroupBox;
    LstFileList: TRzListBox;
    RzListBox1: TRzListBox;
    BPTimer1: TBPTimer;
    RzPanel1: TRzPanel;
    RzProgressBar1: TRzProgressBar;
    RzLabel1: TRzLabel;
    ImageList1: TImageList;
    OpenDialog: TOpenPictureDialog;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    RzToolbar1: TRzToolbar;
    RzToolButton1: TRzToolButton;
    BtnEdit: TRzToolButton;
    GsImageListEditor1: TGsImageListEditor;
    TUpdateUI: TBPTimer;
    procedure FormActivate(Sender: TObject);
    procedure LstFileListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LstFileListStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure RzListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure RzListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure RzListBox1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure LstFileListEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure BPTimer1Timer(Sender: TObject);
    procedure RzToolButton1Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure RzPageControl1Change(Sender: TObject);
    procedure TUpdateUITimer(Sender: TObject);
  private
    { Private-Deklarationen }
    FFileList: TGsImageFileList;
    FTextMaxWidth: Integer;
    Start: Cardinal;
    procedure UpdateProgress;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  { Enabled support for various image formats }
  pngimage, jpeg, GIFImg,
  Theme1, ImgEdit, Math;

resourcestring
  SProgress = 'Datei %d von %d';

procedure TForm1.BPTimer1Timer(Sender: TObject);
var
  C,
  I: Integer;
begin
  BPTimer1.Stop;

  if Start = 0 then
  begin
    Start := GetTickCount;
    LstFileList.Items.BeginUpdate;
  end;

  try
    //LstFileList.Visible := False;
    //LstFileList.Clear;

    if LstFileList.Count < FFileList.Count then
    begin
      C := 0;
      I := LstFileList.Count;
      //LstFileList.Items.BeginUpdate;

      try
        while (I < FFileList.Count) and (C < 10) do
        begin
          LstFileList.AddObject(FFileList[I].FileName, FFileList[I]);
          Inc(C);
          Inc(I);
        end;
      finally
        //LstFileList.Items.EndUpdate;
      end;
    end
    else
    begin
      while LstFileList.Count > FFileList.Count do
        LstFileList.Delete(LstFileList.Count - 1);

      for I := 0 to FFileList.Count - 1 do
      begin
        LstFileList.Items.Strings[I] := FFileList[I].FileName;
        LstFileList.Items.Objects[I] := FFileList[I];

        if I mod 50 = 0 then
          Application.ProcessMessages;
      end;
    end;
  finally
    UpdateProgress;

    if LstFileList.Count <> FFileList.Count then
      BPTimer1.Start
    else
    begin
      LstFileList.Items.EndUpdate;
      //LstFileList.Visible := True;
      LstFileList.Repaint;
      MessageDlg(Format('Listupdate Time: %d', [GetTickCount - Start]), mtInformation, [mbOK], 0)
    end;
  end;
end;

procedure TForm1.BtnEditClick(Sender: TObject);
begin
  EditImageList(ImageList1);
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  I: Integer;
begin
  (*
  for I := 0 to GsThemeController1.ImageSizes.Count - 1 do
  begin
    //MessageDlg(Format('%d: %s / %s', [I, GsThemeController1.ImageSizes.SizeItems[I].Images.Name, GsThemeController1.ImageSizes.SizeItems[I].DisabledImages.Name]), mtInformation, [mbOK], 0);
  end;
  *)

  (*
  for I := 0 to GsTheme1.ImagePaths.Count - 1 do
  begin
    GsTheme1.ImagePaths[I].ImageFiles.Path := IncludeTrailingPathDelimiter(GsTheme1.ImagePaths.BasePath) + GsTheme1.ImagePaths[I].Path;
  end;
  *)

  FFileList := GsTheme1.Images[0].Stock.ImageFiles;
  GsTheme1.Test;
  //FFileList.Path := 'D:\SW-Projekte\Images\iconex_o2\o_collection\o_collection_png\blue_dark_grey\16x16';

  (*
  LstFileList.Clear;
  BPTimer1.Start;
  UpdateProgress;
  *)
  TUpdateUI.Start;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //FFileList := TGsImageFileList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //FFileList.Free;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  LstFileList.Columns := LstFileList.Width div (Max(FTextMaxWidth, 100) + 22 + 2 + 8);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
//
end;

procedure TForm1.LstFileListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  TextOffset: Integer;
  Picture: TPicture;
begin
  LstFileList.Canvas.FillRect(Rect);   // Clear area for icon and text

  if Assigned(LstFileList.Items.Objects[Index]) then
  begin
    Picture := TPicture.Create;

    try
      if TGsImageFileListItem(LstFileList.Items.Objects[Index]).GetImage(Picture) then
        LstFileList.Canvas.Draw(Rect.Left - 22, Rect.Top + 2, Picture.Graphic);
    finally
      Picture.Free;
    end;
  end;

//  Inc( Rect.Left, 26 );
  TextOffset := ((Rect.Bottom - Rect.Top) - LstFileList.Canvas.TextHeight('Pp')) div 2;
  FTextMaxWidth := Max(FTextMaxWidth, LstFileList.Canvas.TextWidth(LstFileList.Items[Index]));
  LstFileList.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + TextOffset, LstFileList.Items[Index]);
end;

procedure TForm1.LstFileListEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  P: TPoint;
  I: Integer;
begin
  (*
  P.X := X;
  P.Y := Y;
  P := LstFileList.ScreenToClient(P);
  I := LstFileList.ItemAtPos(P, True);
  *)
  I := LstFileList.ItemIndex;
  MessageDlg(Format('%d / %d / %d', [X, Y, I]), mtInformation, [mbOK], 0);
end;

procedure TForm1.LstFileListStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
//DragObject.
end;

procedure TForm1.RzListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  I: Integer;
begin
  if Source = LstFileList then
  begin
    I := LstFileList.ItemIndex;
  end;
  MessageDlg(Format('%d / %d / %d', [X, Y, I]), mtInformation, [mbOK], 0);
end;

procedure TForm1.RzListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  //
end;

procedure TForm1.RzListBox1EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
//
end;

procedure TForm1.RzPageControl1Change(Sender: TObject);
begin
  if RzPageControl1.ActivePage = TabSheet2 then
    GsImageListEditor1.Theme := GsTheme1;
end;

procedure TForm1.RzToolButton1Click(Sender: TObject);
var
  I: Integer;
  IWidth, IHeight: Integer;
  XDiv, YDiv: Integer;
  InsertIndex: Integer;
  MsgDlgBtns: TMsgDlgButtons;
  DialogResult: TModalResult;
  Picture: TPicture;
  PNG: TPngImage;
begin
  DialogResult := mrNo;
  OpenDialog.Title := 'Bilder hinzufügen';
  OpenDialog.DefaultExt := GraphicExtension(TGraphic);
  OpenDialog.Filter := GraphicFilter(TGraphic);
  if OpenDialog.Execute(Handle) then
  begin
    Screen.Cursor := crHourglass;
    try
      Picture := TPicture.Create;
      try
        (*
        PNG.
        Picture.
        ImageList1.Insert(0, )

        if Sender = ReplaceBtn then
          DeleteSelectedImages;
        if (ImageView.Selected <> nil) then
        begin
          InsertIndex := ImageView.Selected.Index;
          if Sender = Add then
            Inc(InsertIndex);
        end
        else
          InsertIndex := ImageView.Items.Count;
        ImageView.Selected := nil;
        IWidth := FImages.Width;
        IHeight := FImages.Height;
        MsgDlgBtns := [mbYes, mbNo];
        if OpenDialog.Files.Count > 1 then
          msgDlgBtns := MsgDlgBtns + [mbNoToAll, mbYesToAll];
        * )
        for I := 0 to OpenDialog.Files.Count - 1 do
        begin
          Picture.LoadFromFile(OpenDialog.Files[I]);
          if Picture.Graphic is TIcon then
          begin
            Inc(InsertIndex, DoAdd(TIcon(Picture.Graphic), InsertIndex))
          end
          else
          begin
            if (Picture.Width > IWidth) and (Picture.Width mod IWidth = 0) then
              XDiv := Picture.Width div IWidth
            else
              XDiv := 1;
            if (Picture.Height > IHeight) and (Picture.Height mod IHeight = 0) then
              YDiv := Picture.Height div IHeight
            else
              YDiv := 1;
            // Check to see if should split
            if not (DialogResult in [mrNoToAll, mrYesToAll]) then
              DialogResult := mrNo;
            if ((XDiv > 1) or (YDiv > 1)) and
              not (DialogResult in [mrNoToAll, mrYesToAll]) then
              DialogResult := MessageDlg(Format(SImageListDivide,
                [ExtractFileName(OpenDialog.Files[I]), XDiv * YDiv]),
                mtConfirmation, MsgDlgBtns, 0);
            if DialogResult in [mrNo, mrNoToAll] then //Add it as is
              Inc(InsertIndex, DoAdd(Picture.Graphic, InsertIndex))
            else //Split into smaller images
              Inc(InsertIndex, DoAdd(Picture.Graphic, InsertIndex, XDiv, YDiv));
          end;
        end;
        UpdateUI(True);
        ImageView.ItemIndex := InsertIndex - 1;
        ImageView.Selected.MakeVisible(False);
        *)
      finally
        Picture.Free;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TForm1.TUpdateUITimer(Sender: TObject);
begin
  TUpdateUI.Stop;
  RzPageControl1.OnChange(RzPageControl1);
end;

procedure TForm1.UpdateProgress;
begin
  RzProgressBar1.TotalParts := FFileList.Count;
  RzProgressBar1.PartsComplete := LstFileList.Count;
  RzLabel1.Caption := Format(SProgress, [RzProgressBar1.PartsComplete, RzProgressBar1.TotalParts]);
  RzPanel1.Visible := LstFileList.Count <> FFileList.Count;
end;

end.
