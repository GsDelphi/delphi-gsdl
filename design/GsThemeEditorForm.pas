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
unit GsThemeEditorForm;

interface

uses
  {$IFDEF USE_CS}
  CodeSiteLogging,
  {$ENDIF}
  DesignWindows,
  ToolWnds,
  SysUtils,
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  DesignIntf,
  DesignMenus,
  DesignEditors,
  VCLEditors,
  Forms,
  Dialogs,
  Buttons,
  StdCtrls,
  RzPanel,
  ExtCtrls,
  ImgList,
  Menus,
  RzButton,
//  RzDesignEditors,
  RzRadChk,
  RzLstBox,
  RzLabel,
  RzStatus,
  RzSpnEdt,
  ExtDlgs,
  GsTheme,
  Vcl.FileCtrl,
  RzFilSys,
  Vcl.ComCtrls,
  RzListVw,
  RzShellCtrls,
  GsFileCtrl, BPExtCtrls, RzPrgres, RzTabs, GsImgEdit, GsImageListEditorFrame;

type
  //TGsThemeEditor = class(TForm)
  TGsThemeEditor = class(TDesignWindow)
  //TGsThemeEditor = class(TToolbarDesignWindow)
    BtnDone: TRzButton;
    MnuStock: TPopupMenu;
    MnuEditStockHint: TMenuItem;
    ImgGroove: TImage;
    ImgSpacer: TImage;
    MnuCustomImages: TPopupMenu;
    AddCustomImage1: TMenuItem;
    DlgOpenPicture: TOpenPictureDialog;
    MnuCustom: TPopupMenu;
    MnuAdd: TMenuItem;
    MnuSep1: TMenuItem;
    MnuEditCustomHint: TMenuItem;
    MnuDelete: TMenuItem;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    GrpImageList: TRzGroupBox;
    LstImageList: TRzListBox;
    GrpStockImages: TRzGroupBox;
    LstFileList: TRzListBox;
    PnlUpdateFiles: TRzPanel;
    PrgUpdateFiles: TRzProgressBar;
    LblUpdateFiles: TRzLabel;
    GrpCustomImages: TRzGroupBox;
    SbxCustom: TScrollBox;
    RzListView1: TRzListView;
    ChkSetHint: TRzCheckBox;
    ChkAddDisabled: TRzCheckBox;
    TabSheet3: TRzTabSheet;
    GsImageListEditor1: TGsImageListEditor;
    procedure FormCreate(Sender: TObject);
    procedure ToolbarButtonClick(Sender: TObject);
    procedure MnuAddClick(Sender: TObject);
    procedure MnuDeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MnuEditStockHintClick(Sender: TObject);
    procedure MnuEditCustomHintClick(Sender: TObject);
    procedure SbxCustomResize(Sender: TObject);
    procedure LstImageListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LstImageListClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LstFileListClick(Sender: TObject);
    procedure LstFileListStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure LstFileListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TmrUpdateFilesTimer(Sender: TObject);
    procedure RzPageControl1Change(Sender: TObject);
  private
    FObject: TPersistent;
    FImageList: TCustomImageList;
    FHasImageListProp: Boolean;
    FHasGlyphProp: Boolean;
    FIsToolButton: Boolean;
    FCustomImages: TStringList;
    FFileList: TGsImageFileList;

    procedure RearrangeCustomButtons;
    function CreateCustomButton( const S: string ): TRzToolbarButton;
    function GetFileNameFromString( const S: string ): string;
    function GetHintFromString( const S: string ): string;

    procedure AddImageToImgList( ImageList: TCustomImageList; Glyph: TBitmap );
    procedure HandleTextChange( Sender: TObject );

    function GetObjectImageIndex: Integer;
    procedure SetObjectImageIndex( Value: Integer );
    procedure SetObjectDisabledIndex( Value: Integer );
    procedure SetObjectCaption( const Value: string );
    procedure SetObjectHint( const Value: string );
    procedure SetObjectGlyph( Glyph: TBitmap );
    procedure SetObjectNumGlyphs( Value: Integer );

    procedure UpdateProgress;
  public
    ThemeModule: TCustomGsTheme;
    //FPropertyEditor: TGsCustomImageIndexProperty;
    FEditingProperty: Boolean;
    SelectedBtn: TRzToolbarButton;
    CompOwner: TComponent;
    //TextChangeType: TRzTextChangeType;
    procedure Reposition;
    procedure UpdateControls;
  end;

  TGsThemeEditorClass = class of TGsThemeEditor;

procedure ShowThemeEditor(ADesigner: IDesigner; AThemeModule: TCustomGsTheme{;
  ACollection: TCollection; const PropertyName: string});
function ShowThemeEditorClass(ADesigner: IDesigner;
  ThemeEditorClass: TGsThemeEditorClass; AThemeModule: TCustomGsTheme{;
  ACollection: TCollection; const PropertyName: string;
  ColOptions: TColOptions = [coAdd, coDelete, coMove]}): TGsThemeEditor;

implementation

{$R *.dfm}

uses
  { Enabled support for various image formats }
  pngimage, jpeg, GIFImg,

  RzCommon,
  IniFiles,
  TypInfo,
  Registry,
  RzAnimtr,
  RzGroupBar,
  RzPathBar,
  RzTray;

const
  CustomButtonsSection = 'CustomButtons';
  StockHintsSection = 'StockHints';
  ToolbarButtonsSection = 'ToolbarButtons';
  SelectImageSection = 'SelectImage';

resourcestring
  SProgress = 'Datei %d von %d';

  (*
var
  LThemeEditor: TGsThemeEditDlg;
  *)

var
  ThemeEditorsList: TList = nil;

function ShowThemeEditorClass(ADesigner: IDesigner;
  ThemeEditorClass: TGsThemeEditorClass; AThemeModule: TCustomGsTheme{;
  ACollection: TCollection; const PropertyName: string;
  ColOptions: TColOptions}): TGsThemeEditor;
var
  I: Integer;
begin
  if ThemeEditorsList = nil then
    ThemeEditorsList := TList.Create;

  for I := 0 to ThemeEditorsList.Count - 1 do
  begin
    Result := TGsThemeEditor(ThemeEditorsList[I]);
    with Result do
      if (Designer = ADesigner) and (ThemeModule = AThemeModule){
        and (Collection = ACollection)
        and (CompareText(CollectionPropertyName, PropertyName) = 0)} then
      begin
        Show;
        BringToFront;
        Exit;
      end;
  end;

  Result := ThemeEditorClass.Create(Application);
  with Result do
    try
      //Options := ColOptions;
      Designer := ADesigner;
      ThemeModule := AThemeModule;
      {
      Collection := ACollection;
      FCollectionClassName := ACollection.ClassName;
      CollectionPropertyName := PropertyName;
      UpdateListbox;
      }
      Show;
    except
      Free;
    end;
end;

procedure ShowThemeEditor(ADesigner: IDesigner; AThemeModule: TCustomGsTheme{;
  ACollection: TCollection; const PropertyName: string});
begin
  ShowThemeEditorClass(ADesigner, TGsThemeEditor, AThemeModule{,
    ACollection, PropertyName});
end;

procedure TGsThemeEditor.FormCreate(Sender: TObject);
var
  BtnCount: Integer;
  I: Integer;
  S: string;
  R: TRegIniFile;
begin
  ThemeEditorsList.Add(Self);
  {$IFDEF VCL90_OR_HIGHER}
  PopupMode := pmAuto;
  {$ENDIF}
  Position := poDesigned;

  Icon.Handle := LoadIcon( HInstance, 'RZDESIGNEDITORS_SELECT_IMAGE_ICON' );

  FCustomImages := TStringList.Create;

  (*
  R := TRegIniFile.Create( RC_SettingsKey );
  try
    // Read in stock hints
    BtnNew.Hint := R.ReadString( StockHintsSection, 'New', 'New' );
    BtnOpen.Hint := R.ReadString( StockHintsSection, 'Open', 'Open' );
    BtnSave.Hint := R.ReadString( StockHintsSection, 'Save', 'Save' );
    BtnSaveAll.Hint := R.ReadString( StockHintsSection, 'SaveAll', 'Save All' );
    BtnFileDelete.Hint := R.ReadString( StockHintsSection, 'Delete', 'Delete' );
    BtnPrint.Hint := R.ReadString( StockHintsSection, 'Print', 'Print' );
    BtnPrintPreview.Hint := R.ReadString( StockHintsSection, 'PrintPreview', 'Print Preview' );
    BtnPreviewPrev.Hint := R.ReadString( StockHintsSection, 'PreviewPreviousPage', 'Preview Previous Page' );
    BtnPreviewNext.Hint := R.ReadString( StockHintsSection, 'PreviewNextPage', 'Preview Next Page' );
    BtnImport.Hint := R.ReadString( StockHintsSection, 'Import', 'Import' );
    BtnExport.Hint := R.ReadString( StockHintsSection, 'Export', 'Export' );
    BtnFolderOpen.Hint := R.ReadString( StockHintsSection, 'Open', 'Open' );
    BtnFolderClosed.Hint := R.ReadString( StockHintsSection, 'Close', 'Close' );
    BtnFolderUp.Hint := R.ReadString( StockHintsSection, 'UpOneLevel', 'Up One Level' );
    BtnFolderNew.Hint := R.ReadString( StockHintsSection, 'NewFolder', 'New Folder' );
    BtnFolderSelect.Hint := R.ReadString( StockHintsSection, 'SelectFolder', 'Select Folder' );
    BtnExit.Hint := R.ReadString( StockHintsSection, 'Exit', 'Exit' );
    BtnCut.Hint := R.ReadString( StockHintsSection, 'Cut', 'Cut' );
    BtnCopy.Hint := R.ReadString( StockHintsSection, 'Copy', 'Copy' );
    BtnPaste.Hint := R.ReadString( StockHintsSection, 'Paste', 'Paste' );
    BtnUndo.Hint := R.ReadString( StockHintsSection, 'Undo', 'Undo' );
    BtnRedo.Hint := R.ReadString( StockHintsSection, 'Redo', 'Redo' );
    BtnSelectAll.Hint := R.ReadString( StockHintsSection, 'SelectAll', 'Select All' );
    BtnClear.Hint := R.ReadString( StockHintsSection, 'Clear', 'Clear' );
    BtnRecycle.Hint := R.ReadString( StockHintsSection, 'Recycle', 'Recycle' );
    BtnRecycleXP.Hint := R.ReadString( StockHintsSection, 'Recycle', 'Recycle' );
    BtnCopyAll.Hint := R.ReadString( StockHintsSection, 'CopyAll', 'Copy All' );
    BtnMove.Hint := R.ReadString( StockHintsSection, 'Move', 'Move' );
    BtnProperties.Hint := R.ReadString( StockHintsSection, 'Properties', 'Properties' );
    BtnOptions.Hint := R.ReadString( StockHintsSection, 'ChangeOptions', 'Change Options' );
    BtnCalendarDate.Hint := R.ReadString( StockHintsSection, 'DateView', 'Date View' );
    BtnCalendarWeek.Hint := R.ReadString( StockHintsSection, 'WeekView', 'Week View' );
    BtnCalendarMonth.Hint := R.ReadString( StockHintsSection, 'MonthView', 'Month View' );
    BtnSearchFind.Hint := R.ReadString( StockHintsSection, 'Find', 'Find' );
    BtnSearchReplace.Hint := R.ReadString( StockHintsSection, 'Replace', 'Replace' );
    BtnSearchFindNext.Hint := R.ReadString( StockHintsSection, 'FindNext', 'Find Next' );
    BtnSearchJumpToLine.Hint := R.ReadString( StockHintsSection, 'JumpToLine', 'Jump to Line' );
    BtnDBFirst.Hint := R.ReadString( StockHintsSection, 'FirstRecord', 'First Record' );
    BtnDBPrevious.Hint := R.ReadString( StockHintsSection, 'PreviousRecord', 'Previous Record' );
    BtnDBNext.Hint := R.ReadString( StockHintsSection, 'NextRecord', 'Next Record' );
    BtnDBLast.Hint := R.ReadString( StockHintsSection, 'LastRecord', 'Last Record' );
    BtnDBInsert.Hint := R.ReadString( StockHintsSection, 'InsertRecord', 'Insert Record' );
    BtnDBDelete.Hint := R.ReadString( StockHintsSection, 'DeleteRecord', 'Delete Record' );
    BtnDBEdit.Hint := R.ReadString( StockHintsSection, 'EditRecord', 'Edit Record' );
    BtnDBPost.Hint := R.ReadString( StockHintsSection, 'PostRecord', 'Post' );
    BtnDBCancel.Hint := R.ReadString( StockHintsSection, 'CancelChanges', 'Cancel' );
    BtnDBRefresh.Hint := R.ReadString( StockHintsSection, 'Refresh', 'Refresh' );
    BtnHelp.Hint := R.ReadString( StockHintsSection, 'Help', 'Help' );
    BtnHelpBook.Hint := R.ReadString( StockHintsSection, 'HelpBook', 'Help' );
    BtnHelpContext.Hint := R.ReadString( StockHintsSection, 'ContextHelp', 'Context Help' );
    BtnNetWeb.Hint := R.ReadString( StockHintsSection, 'Internet', 'Internet' );
    BtnNetNews.Hint := R.ReadString( StockHintsSection, 'Newsgroups', 'Newsgroups' );
    BtnWindowCascade.Hint := R.ReadString( StockHintsSection, 'Cascade', 'Cascade' );
    BtnWindowHorzTile.Hint := R.ReadString( StockHintsSection, 'HorizTile', 'Horizontal Tile' );
    BtnWindowVertTile.Hint := R.ReadString( StockHintsSection, 'VertTile', 'Vertical Tile' );
    BtnWindowTile.Hint := R.ReadString( StockHintsSection, 'Tile', 'Tile' );
    BtnViewIcons.Hint := R.ReadString( StockHintsSection, 'ViewIcons', 'View Icons' );
    BtnViewList.Hint := R.ReadString( StockHintsSection, 'ViewList', 'View List' );
    BtnViewDetails.Hint := R.ReadString( StockHintsSection, 'ViewDetails', 'View Details' );
    BtnViewZoom.Hint := R.ReadString( StockHintsSection, 'View', 'View' );
    BtnViewZoomOut.Hint := R.ReadString( StockHintsSection, 'ZoomOut', 'Zoom Out' );
    BtnViewZoomIn.Hint := R.ReadString( StockHintsSection, 'ZoomIn', 'Zoom In' );
    BtnAlign.Hint := R.ReadString( StockHintsSection, 'Align', 'Align' );
    BtnAlignLeft.Hint := R.ReadString( StockHintsSection, 'AlignLeft', 'Align Left' );
    BtnAlignTop.Hint := R.ReadString( StockHintsSection, 'AlignTop', 'Align Top' );
    BtnAlignRight.Hint := R.ReadString( StockHintsSection, 'AlignRight', 'Align Right' );
    BtnAlignBottom.Hint := R.ReadString( StockHintsSection, 'AlignBottom', 'Align Bottom' );
    BtnAlignClient.Hint := R.ReadString( StockHintsSection, 'AlignClient', 'Align Client' );
    BtnAlignNone.Hint := R.ReadString( StockHintsSection, 'AlignNone', 'Align None' );
    BtnFormatBold.Hint := R.ReadString( StockHintsSection, 'Bold', 'Bold' );
    BtnFormatItalics.Hint := R.ReadString( StockHintsSection, 'Italic', 'Italic' );
    BtnFormatUnderline.Hint := R.ReadString( StockHintsSection, 'Underline', 'Underline' );
    BtnFormatFont.Hint := R.ReadString( StockHintsSection, 'Font', 'Font' );
    BtnFormatLeft.Hint := R.ReadString( StockHintsSection, 'LeftJustify', 'Left Justify' );
    BtnFormatCenter.Hint := R.ReadString( StockHintsSection, 'CenterJustify', 'Center Justify' );
    BtnFormatRight.Hint := R.ReadString( StockHintsSection, 'RightJustify', 'Right Justify' );
    BtnFormatJustify.Hint := R.ReadString( StockHintsSection, 'Justify', 'Justify' );
    BtnFormatBullets.Hint := R.ReadString( StockHintsSection, 'Bullets', 'Bullets' );
    BtnFormatWordWrap.Hint := R.ReadString( StockHintsSection, 'WordWrap', 'Word Wrap' );
    BtnFormatTabs.Hint := R.ReadString( StockHintsSection, 'SetTabs', 'Set Tabs' );
    BtnOrderBackOne.Hint := R.ReadString( StockHintsSection, 'BackOne', 'Back One' );
    BtnOrderFrontOne.Hint := R.ReadString( StockHintsSection, 'ForwardOne', 'Forward One' );
    BtnOrderToBack.Hint := R.ReadString( StockHintsSection, 'SendToBack', 'Send to Back' );
    BtnOrderToFront.Hint := R.ReadString( StockHintsSection, 'BringToFront', 'Bring to Front' );
    BtnArrowLeft.Hint := R.ReadString( StockHintsSection, 'Left', 'Left' );
    BtnArrowRight.Hint := R.ReadString( StockHintsSection, 'Right', 'Right' );
    BtnArrowUp.Hint := R.ReadString( StockHintsSection, 'Up', 'Up' );
    BtnArrowDown.Hint := R.ReadString( StockHintsSection, 'Down', 'Down' );
    BtnMoveAllLeft.Hint := R.ReadString( StockHintsSection, 'MoveAllLeft', 'Move All Left' );
    BtnMoveLeft.Hint := R.ReadString( StockHintsSection, 'MoveLeft', 'Move Left' );
    BtnMoveRight.Hint := R.ReadString( StockHintsSection, 'MoveRight', 'Move Right' );
    BtnMoveAllRight.Hint := R.ReadString( StockHintsSection, 'MoveAllRight', 'Move All Right' );
    BtnMediaSkipBackward.Hint := R.ReadString( StockHintsSection, 'SkipBackward', 'Skip Backward' );
    BtnMediaRewind.Hint := R.ReadString( StockHintsSection, 'Rewind', 'Rewind' );
    BtnMediaPlay.Hint := R.ReadString( StockHintsSection, 'Play', 'Play' );
    BtnMediaPause.Hint := R.ReadString( StockHintsSection, 'Pause', 'Pause' );
    BtnMediaStop.Hint := R.ReadString( StockHintsSection, 'Stop', 'Stop' );
    BtnMediaRecord.Hint := R.ReadString( StockHintsSection, 'Record', 'Record' );
    BtnMediaFastForward.Hint := R.ReadString( StockHintsSection, 'FastForward', 'Fast Forward' );
    BtnMediaSkipForward.Hint := R.ReadString( StockHintsSection, 'SkipForward', 'Skip Forward' );
    BtnToolsSpeaker.Hint := R.ReadString( StockHintsSection, 'Volume', 'Volume' );
    BtnOK.Hint := R.ReadString( StockHintsSection, 'OK', 'OK' );
    BtnCancel.Hint := R.ReadString( StockHintsSection, 'Cancel', 'Cancel' );
    BtnSignalInfo.Hint := R.ReadString( StockHintsSection, 'Information', 'Information' );
    BtnSignalWarning.Hint := R.ReadString( StockHintsSection, 'Warning', 'Warning' );
    BtnSignalError.Hint := R.ReadString( StockHintsSection, 'Error', 'Error' );
    BtnSignalReminder.Hint := R.ReadString( StockHintsSection, 'Reminder', 'Reminder' );
    BtnSignalFinish.Hint := R.ReadString( StockHintsSection, 'Finish', 'Finish' );
    BtnSignalRed.Hint := R.ReadString( StockHintsSection, 'Red', '' );
    BtnSignalOrange.Hint := R.ReadString( StockHintsSection, 'Orange', '' );
    BtnSignalYellow.Hint := R.ReadString( StockHintsSection, 'Yellow', '' );
    BtnSignalGreen.Hint := R.ReadString( StockHintsSection, 'Green', '' );
    BtnSignalLtBlue.Hint := R.ReadString( StockHintsSection, 'LtBlue', '' );
    BtnSignalBlue.Hint := R.ReadString( StockHintsSection, 'Blue', '' );
    BtnSignalViolet.Hint := R.ReadString( StockHintsSection, 'Violet', '' );
    BtnSignalGray.Hint := R.ReadString( StockHintsSection, 'Gray', '' );
    BtnEmail.Hint := R.ReadString( StockHintsSection, 'SendEMail', 'Send EMail' );
    BtnAttach.Hint := R.ReadString( StockHintsSection, 'AttachFiles', 'Attach Files' );
    BtnNotebook.Hint := R.ReadString( StockHintsSection, 'Notebook', 'Note' );
    BtnNotePage.Hint := R.ReadString( StockHintsSection, 'NotePage', 'Note' );
    BtnNote.Hint := R.ReadString( StockHintsSection, 'Note', 'Note' );
    BtnToolsPen.Hint := R.ReadString( StockHintsSection, 'Pen', 'Edit' );
    BtnToolsPencil.Hint := R.ReadString( StockHintsSection, 'Pencil', 'Edit' );
    BtnToolsPin.Hint := R.ReadString( StockHintsSection, 'Pin', 'Attach' );
    BtnToolsRuler.Hint := R.ReadString( StockHintsSection, 'Ruler', 'Ruler' );
    BtnToolsCursor.Hint := R.ReadString( StockHintsSection, 'Select', 'Select' );
    BtnToolsHammer.Hint := R.ReadString( StockHintsSection, 'Utilities', 'Utilities' );
    BtnToolsKey.Hint := R.ReadString( StockHintsSection, 'Key', 'Security' );
    BtnToolsImage.Hint := R.ReadString( StockHintsSection, 'InsertImage', 'Insert Image' );
    BtnToolsPlug.Hint := R.ReadString( StockHintsSection, 'PlugIns', 'Plug-Ins' );
    BtnExecute.Hint := R.ReadString( StockHintsSection, 'Execute', 'Execute' );


    // Handle Custom Buttons
    BtnCount := R.ReadInteger( CustomButtonsSection, 'Count', 0 );
    for I := 0 to BtnCount - 1 do
    begin
      S := R.ReadString( CustomButtonsSection, 'Button' + IntToStr( I ), '' );
      if S <> '' then
      begin
        FCustomImages.AddObject( S, CreateCustomButton( S ) );
      end;

    end;
    RearrangeCustomButtons;

    ChkAddDisabled.Checked := R.ReadBool( SelectImageSection, 'AddDisabled', True );

    // Read in Set Hint Setting
    ChkSetHint.Checked := R.ReadBool( StockHintsSection, 'SetHint', True );

    Width := R.ReadInteger( SelectImageSection, 'Width', 665 );
    Height := R.ReadInteger( SelectImageSection, 'Height', 457 );

  finally
    R.Free;
  end;
  *)
end; {= TRzSelectImageEditDlg.FormCreate =}


procedure TGsThemeEditor.FormDestroy(Sender: TObject);
var
  I: Integer;
  R: TRegIniFile;
begin
  (*
  R := TRegIniFile.Create( RC_SettingsKey );
  try
    // Save Stock Hints
    R.WriteString( StockHintsSection, 'New', BtnNew.Hint );
    R.WriteString( StockHintsSection, 'Open', BtnOpen.Hint );
    R.WriteString( StockHintsSection, 'Save', BtnSave.Hint );
    R.WriteString( StockHintsSection, 'SaveAll', BtnSaveAll.Hint );
    R.WriteString( StockHintsSection, 'Delete', BtnFileDelete.Hint );
    R.WriteString( StockHintsSection, 'Print', BtnPrint.Hint );
    R.WriteString( StockHintsSection, 'PrintPreview', BtnPrintPreview.Hint );
    R.WriteString( StockHintsSection, 'PreviewPreviousPage', BtnPreviewPrev.Hint );
    R.WriteString( StockHintsSection, 'PreviewNextPage', BtnPreviewNext.Hint );
    R.WriteString( StockHintsSection, 'Import', BtnImport.Hint );
    R.WriteString( StockHintsSection, 'Export', BtnExport.Hint );
    R.WriteString( StockHintsSection, 'Open', BtnFolderOpen.Hint );
    R.WriteString( StockHintsSection, 'Close', BtnFolderClosed.Hint );
    R.WriteString( StockHintsSection, 'UpOneLevel', BtnFolderUp.Hint );
    R.WriteString( StockHintsSection, 'NewFolder', BtnFolderNew.Hint );
    R.WriteString( StockHintsSection, 'SelectFolder', BtnFolderSelect.Hint );
    R.WriteString( StockHintsSection, 'Exit', BtnExit.Hint );
    R.WriteString( StockHintsSection, 'Cut', BtnCut.Hint );
    R.WriteString( StockHintsSection, 'Copy', BtnCopy.Hint );
    R.WriteString( StockHintsSection, 'Paste', BtnPaste.Hint );
    R.WriteString( StockHintsSection, 'Undo', BtnUndo.Hint );
    R.WriteString( StockHintsSection, 'Redo', BtnRedo.Hint );
    R.WriteString( StockHintsSection, 'SelectAll', BtnSelectAll.Hint );
    R.WriteString( StockHintsSection, 'Clear', BtnClear.Hint );
    R.WriteString( StockHintsSection, 'Recycle', BtnRecycle.Hint );
    R.WriteString( StockHintsSection, 'Recycle', BtnRecycleXP.Hint );
    R.WriteString( StockHintsSection, 'CopyAll', BtnCopyAll.Hint );
    R.WriteString( StockHintsSection, 'Move', BtnMove.Hint );
    R.WriteString( StockHintsSection, 'Properties', BtnProperties.Hint );
    R.WriteString( StockHintsSection, 'ChangeOptions', BtnOptions.Hint );
    R.WriteString( StockHintsSection, 'DateView', BtnCalendarDate.Hint );
    R.WriteString( StockHintsSection, 'WeekView', BtnCalendarWeek.Hint );
    R.WriteString( StockHintsSection, 'MonthView', BtnCalendarMonth.Hint );
    R.WriteString( StockHintsSection, 'Find', BtnSearchFind.Hint );
    R.WriteString( StockHintsSection, 'Replace', BtnSearchReplace.Hint );
    R.WriteString( StockHintsSection, 'FindNext', BtnSearchFindNext.Hint );
    R.WriteString( StockHintsSection, 'JumpToLine', BtnSearchJumpToLine.Hint );
    R.WriteString( StockHintsSection, 'FirstRecord', BtnDBFirst.Hint );
    R.WriteString( StockHintsSection, 'PreviousRecord', BtnDBPrevious.Hint );
    R.WriteString( StockHintsSection, 'NextRecord', BtnDBNext.Hint );
    R.WriteString( StockHintsSection, 'LastRecord', BtnDBLast.Hint );
    R.WriteString( StockHintsSection, 'InsertRecord', BtnDBInsert.Hint );
    R.WriteString( StockHintsSection, 'DeleteRecord', BtnDBDelete.Hint );
    R.WriteString( StockHintsSection, 'EditRecord', BtnDBEdit.Hint );
    R.WriteString( StockHintsSection, 'PostRecord', BtnDBPost.Hint );
    R.WriteString( StockHintsSection, 'CancelChanges', BtnDBCancel.Hint );
    R.WriteString( StockHintsSection, 'Refresh', BtnDBRefresh.Hint );
    R.WriteString( StockHintsSection, 'Help', BtnHelp.Hint );
    R.WriteString( StockHintsSection, 'HelpBook', BtnHelpBook.Hint );
    R.WriteString( StockHintsSection, 'ContextHelp', BtnHelpContext.Hint );
    R.WriteString( StockHintsSection, 'Internet', BtnNetWeb.Hint );
    R.WriteString( StockHintsSection, 'Newsgroups', BtnNetNews.Hint );
    R.WriteString( StockHintsSection, 'Cascade', BtnWindowCascade.Hint );
    R.WriteString( StockHintsSection, 'HorizTile', BtnWindowHorzTile.Hint );
    R.WriteString( StockHintsSection, 'VertTile', BtnWindowVertTile.Hint );
    R.WriteString( StockHintsSection, 'Tile', BtnWindowTile.Hint );
    R.WriteString( StockHintsSection, 'ViewIcons', BtnViewIcons.Hint );
    R.WriteString( StockHintsSection, 'ViewList', BtnViewList.Hint );
    R.WriteString( StockHintsSection, 'ViewDetails', BtnViewDetails.Hint );
    R.WriteString( StockHintsSection, 'View', BtnViewZoom.Hint );
    R.WriteString( StockHintsSection, 'ZoomOut', BtnViewZoomOut.Hint );
    R.WriteString( StockHintsSection, 'ZoomIn', BtnViewZoomIn.Hint );
    R.WriteString( StockHintsSection, 'Align', BtnAlign.Hint );
    R.WriteString( StockHintsSection, 'AlignLeft', BtnAlignLeft.Hint );
    R.WriteString( StockHintsSection, 'AlignTop', BtnAlignTop.Hint );
    R.WriteString( StockHintsSection, 'AlignRight', BtnAlignRight.Hint );
    R.WriteString( StockHintsSection, 'AlignBottom', BtnAlignBottom.Hint );
    R.WriteString( StockHintsSection, 'AlignClient', BtnAlignClient.Hint );
    R.WriteString( StockHintsSection, 'AlignNone', BtnAlignNone.Hint );
    R.WriteString( StockHintsSection, 'Bold', BtnFormatBold.Hint );
    R.WriteString( StockHintsSection, 'Italic', BtnFormatItalics.Hint );
    R.WriteString( StockHintsSection, 'Underline', BtnFormatUnderline.Hint );
    R.WriteString( StockHintsSection, 'Font', BtnFormatFont.Hint );
    R.WriteString( StockHintsSection, 'LeftJustify', BtnFormatLeft.Hint );
    R.WriteString( StockHintsSection, 'CenterJustify', BtnFormatCenter.Hint );
    R.WriteString( StockHintsSection, 'RightJustify', BtnFormatRight.Hint );
    R.WriteString( StockHintsSection, 'Justify', BtnFormatJustify.Hint );
    R.WriteString( StockHintsSection, 'Bullets', BtnFormatBullets.Hint );
    R.WriteString( StockHintsSection, 'WordWrap', BtnFormatWordWrap.Hint );
    R.WriteString( StockHintsSection, 'SetTabs', BtnFormatTabs.Hint );
    R.WriteString( StockHintsSection, 'BackOne', BtnOrderBackOne.Hint );
    R.WriteString( StockHintsSection, 'ForwardOne', BtnOrderFrontOne.Hint );
    R.WriteString( StockHintsSection, 'SendToBack', BtnOrderToBack.Hint );
    R.WriteString( StockHintsSection, 'BringToFront', BtnOrderToFront.Hint );
    R.WriteString( StockHintsSection, 'Left', BtnArrowLeft.Hint );
    R.WriteString( StockHintsSection, 'Right', BtnArrowRight.Hint );
    R.WriteString( StockHintsSection, 'Up', BtnArrowUp.Hint );
    R.WriteString( StockHintsSection, 'Down', BtnArrowDown.Hint );
    R.WriteString( StockHintsSection, 'MoveAllLeft', BtnMoveAllLeft.Hint );
    R.WriteString( StockHintsSection, 'MoveLeft', BtnMoveLeft.Hint );
    R.WriteString( StockHintsSection, 'MoveRight', BtnMoveRight.Hint );
    R.WriteString( StockHintsSection, 'MoveAllRight', BtnMoveAllRight.Hint );
    R.WriteString( StockHintsSection, 'SkipBackward', BtnMediaSkipBackward.Hint );
    R.WriteString( StockHintsSection, 'Rewind', BtnMediaRewind.Hint );
    R.WriteString( StockHintsSection, 'Play', BtnMediaPlay.Hint );
    R.WriteString( StockHintsSection, 'Pause', BtnMediaPause.Hint );
    R.WriteString( StockHintsSection, 'Stop', BtnMediaStop.Hint );
    R.WriteString( StockHintsSection, 'Record', BtnMediaRecord.Hint );
    R.WriteString( StockHintsSection, 'FastForward', BtnMediaFastForward.Hint );
    R.WriteString( StockHintsSection, 'SkipForward', BtnMediaSkipForward.Hint );
    R.WriteString( StockHintsSection, 'Volume', BtnToolsSpeaker.Hint );
    R.WriteString( StockHintsSection, 'OK', BtnOK.Hint );
    R.WriteString( StockHintsSection, 'Cancel', BtnCancel.Hint );
    R.WriteString( StockHintsSection, 'Information', BtnSignalInfo.Hint );
    R.WriteString( StockHintsSection, 'Warning', BtnSignalWarning.Hint );
    R.WriteString( StockHintsSection, 'Error', BtnSignalError.Hint );
    R.WriteString( StockHintsSection, 'Reminder', BtnSignalReminder.Hint );
    R.WriteString( StockHintsSection, 'Finish', BtnSignalFinish.Hint );
    R.WriteString( StockHintsSection, 'Red', BtnSignalRed.Hint );
    R.WriteString( StockHintsSection, 'Orange', BtnSignalOrange.Hint );
    R.WriteString( StockHintsSection, 'Yellow', BtnSignalYellow.Hint );
    R.WriteString( StockHintsSection, 'Green', BtnSignalGreen.Hint );
    R.WriteString( StockHintsSection, 'LtBlue', BtnSignalLtBlue.Hint );
    R.WriteString( StockHintsSection, 'Blue', BtnSignalBlue.Hint );
    R.WriteString( StockHintsSection, 'Violet', BtnSignalViolet.Hint );
    R.WriteString( StockHintsSection, 'Gray', BtnSignalGray.Hint );
    R.WriteString( StockHintsSection, 'SendEMail', BtnEmail.Hint );
    R.WriteString( StockHintsSection, 'AttachFiles', BtnAttach.Hint );
    R.WriteString( StockHintsSection, 'Notebook', BtnNotebook.Hint );
    R.WriteString( StockHintsSection, 'NotePage', BtnNotePage.Hint );
    R.WriteString( StockHintsSection, 'Note', BtnNote.Hint );
    R.WriteString( StockHintsSection, 'Pen', BtnToolsPen.Hint );
    R.WriteString( StockHintsSection, 'Pencil', BtnToolsPencil.Hint );
    R.WriteString( StockHintsSection, 'Pin', BtnToolsPin.Hint );
    R.WriteString( StockHintsSection, 'Ruler', BtnToolsRuler.Hint );
    R.WriteString( StockHintsSection, 'Select', BtnToolsCursor.Hint );
    R.WriteString( StockHintsSection, 'Utilities', BtnToolsHammer.Hint );
    R.WriteString( StockHintsSection, 'Key', BtnToolsKey.Hint );
    R.WriteString( StockHintsSection, 'InsertImage', BtnToolsImage.Hint );
    R.WriteString( StockHintsSection, 'PlugIns', BtnToolsPlug.Hint );
    R.WriteString( StockHintsSection, 'Execute', BtnExecute.Hint );

    // Save Custom Button Information
    R.WriteInteger( CustomButtonsSection, 'Count', FCustomImages.Count );
    for I := 0 to FCustomImages.Count - 1 do
    begin
      R.WriteString( CustomButtonsSection, 'Button' + IntToStr( I ), FCustomImages[ I ] );
    end;

    // Save Set Hint Setting
    R.WriteBool( StockHintsSection, 'SetHint', ChkSetHint.Checked );
    R.WriteBool( SelectImageSection, 'AddDisabled', ChkAddDisabled.Checked );
    R.WriteInteger( SelectImageSection, 'Height', Height );
    if GrpImageList.Visible then
      R.WriteInteger( SelectImageSection, 'Width', Width )
    else
      R.WriteInteger( SelectImageSection, 'Width', Width + GrpImageList.Width + 20 );
  finally
    R.Free;
  end;
  *)

  FCustomImages.Free;

  if ThemeEditorsList <> nil then
    ThemeEditorsList.Remove(Self);
end; {= TRzSelectImageEditDlg.FormDestroy =}

function TGsThemeEditor.GetObjectImageIndex: Integer;
begin
  if IsPublishedProp( FObject, 'ImageIndex' ) then
    Result := GetOrdProp( FObject, 'ImageIndex' )
  else
    Result := -1;
end;


procedure TGsThemeEditor.SetObjectImageIndex( Value: Integer );
begin
{
  if FEditingProperty then
    TGsCustomImageIndexProperty( FPropertyEditor ).SetOrdValue( Value )
  else if IsPublishedProp( FObject, 'ImageIndex' ) then
    SetOrdProp( FObject, 'ImageIndex', Value );
}
end;


procedure TGsThemeEditor.SetObjectDisabledIndex( Value: Integer );
begin
  if IsPublishedProp( FObject, 'DisabledIndex' ) then
    SetOrdProp( FObject, 'DisabledIndex', Value );
end;


procedure TGsThemeEditor.SetObjectCaption( const Value: string );
begin
  if IsPublishedProp( FObject, 'Caption' ) then
    SetStrProp( FObject, 'Caption', Value );
end;


procedure TGsThemeEditor.SetObjectHint( const Value: string );
begin
  if IsPublishedProp( FObject, 'Hint' ) then
    SetStrProp( FObject, 'Hint', Value );
end;


procedure TGsThemeEditor.SetObjectGlyph( Glyph: TBitmap );
begin
  if IsPublishedProp( FObject, 'Glyph' ) then
  begin
    SetObjectProp( FObject, 'Glyph', Glyph );
    if Glyph.Width <> 0 then
      SetObjectNumGlyphs( Glyph.Width div Glyph.Height );
  end;
end;


procedure TGsThemeEditor.SetObjectNumGlyphs( Value: Integer );
begin
  if IsPublishedProp( FObject, 'NumGlyphs' ) then
    SetOrdProp( FObject, 'NumGlyphs', Value );
end;



procedure TGsThemeEditor.UpdateControls;
var
  I: Integer;
begin
  if FHasImageListProp then
  begin
    Constraints.MinWidth := 665;
    ChkAddDisabled.Visible := FImageList <> nil;

    if FImageList = nil then
    begin
      if FHasGlyphProp then
      begin
        // Allow user to select an image for the Glyph property;
        Constraints.MinWidth := 490;
        GrpImageList.Visible := False;
        ChkAddDisabled.Visible := False;
        Width := Width - GrpImageList.Width - 20;
      end
      else
      begin
        GrpStockImages.Enabled := False;
        GrpCustomImages.Enabled := False;
        for I := 0 to FCustomImages.Count - 1 do
          TRzToolbarButton( FCustomImages.Objects[ I ] ).Enabled := False;
        GrpImageList.Enabled := False;
        LstImageList.Color := clBtnFace;
        (*
        LblNoImageListTitle.Visible := True;
        LblNoImageListTitle.Enabled := True;
        LblNoImageListTitle.Height := 120;
        LblNoImageListTitle.BringToFront;
        if FObject <> nil then
        begin
          if FObject is TComponent then
            LblNoImageListMsg.Caption := Format( LblNoImageListMsg.Caption, [ TComponent( FObject ).Name ] )
          else
            LblNoImageListMsg.Caption := Format( LblNoImageListMsg.Caption, [ FObject.ClassName + ' instance' ] )
        end;
        LblNoImageListMsg.Visible := True;
        LblNoImageListMsg.Height := 190;
        LblNoImageListMsg.Enabled := True;
        LblNoImageListMsg.BringToFront;
        *)
      end;
    end
    else
    begin
      GrpImageList.Caption := Format( '%s Images', [ FImageList.Name ] );
      for I := 0 to FImageList.Count - 1 do
        LstImageList.Items.Add( IntToStr( I ) );
      {
      if FEditingProperty then
        LstImageList.ItemIndex := TGsCustomImageIndexProperty( FPropertyEditor ).GetOrdValue
      else
        LstImageList.ItemIndex := GetObjectImageIndex;
      }
    end;
  end
  else
  begin
    Constraints.MinWidth := 490;
    GrpImageList.Visible := False;
    ChkAddDisabled.Visible := False;
    Width := Width - GrpImageList.Width - 20;
  end;

  {
  case TextChangeType of
    tctNone:
      ChkSetHint.Visible := False;

    tctCaption:
      ChkSetHint.Caption := 'Set Button Caption';

    tctHint:
      ChkSetHint.Caption := 'Set Button Hint';
  end;
  }
end;

procedure TGsThemeEditor.UpdateProgress;
begin
  PrgUpdateFiles.TotalParts := FFileList.Count;
  PrgUpdateFiles.PartsComplete := LstFileList.Count;
  LblUpdateFiles.Caption := Format(SProgress, [PrgUpdateFiles.PartsComplete, PrgUpdateFiles.TotalParts]);
  PnlUpdateFiles.Visible := LstFileList.Count <> FFileList.Count;
end;

procedure TGsThemeEditor.Reposition;
var
  T, L: Integer;
  R, DeskRect: TRect;
  P: TPoint;
begin
  if FObject <> nil then
  begin
    if FObject is TControl then
    begin
      R := TControl( FObject ).BoundsRect;
      P := Point( R.Left, R.Top + 25 );

      P := GetParentForm( TControl( FObject ) ).ClientToScreen( P );

      T := P.Y + 5;
      L := P.X + 5;
      DeskRect := GetDesktopClientRect;
      if L < 0 then
        L := 0;
      if L + Width > DeskRect.Right then
        L := DeskRect.Right - Width;

      if T < 0 then
        T := 0;
      if T + Height > DeskRect.Bottom then
        T := DeskRect.Bottom - Height;

      Top := T;
      Left := L;
    end
    else if FObject is TComponent then
    begin
      Position := poScreenCenter;
    end;
  end;
end;

procedure TGsThemeEditor.RzPageControl1Change(Sender: TObject);
begin
  if RzPageControl1.ActivePage = TabSheet3 then
    GsImageListEditor1.Theme :=ThemeModule;
end;

procedure TGsThemeEditor.AddImageToImgList( ImageList: TCustomImageList; Glyph: TBitmap );
var
  ImageIndex, DisabledIndex: Integer;
  DM: TDataModule;
  I: Integer;
  F: TForm;
begin
  if ( ImageList <> nil ) and ( Glyph <> nil ) then
  begin
    AddImageToImageList( ImageList, Glyph, ChkAddDisabled.Checked, ImageIndex, DisabledIndex );

    if ( ImageList.Owner <> nil ) and ( ImageList.Owner is TDataModule ) then
    begin
      // If the ImageList is on a DataModule, we must get to the DataModule's
      // designer and tell it that is has been modified.
      
      DM := TDataModule( ImageList.Owner );
      
      for I := 0 to Screen.FormCount - 1 do
      begin
        F := Screen.Forms[ I ];
        if ( F.Caption = DM.Name ) and ( F.ClassName = 'TDataModuleForm' ) then
        begin
          if F.Designer <> nil then
            F.Designer.Modified;
          Break;
        end;
      end;
    end;

    SetObjectImageIndex( ImageIndex );

    LstImageList.Items.Add( IntToStr( ImageIndex ) );
    if DisabledIndex <> -1 then
    begin
      if not FEditingProperty then
        SetObjectDisabledIndex( DisabledIndex );
      LstImageList.Items.Add( IntToStr( DisabledIndex ) );
    end;

    LstImageList.ItemIndex := ImageIndex;
  end;
end;


procedure TGsThemeEditor.TmrUpdateFilesTimer(Sender: TObject);
var
  C,
  I: Integer;
begin
  //TmrUpdateFiles.Stop;

  try
    if LstFileList.Count < FFileList.Count then
    begin
      C := 0;
      I := LstFileList.Count;
      LstFileList.Items.BeginUpdate;

      try
        while (I < FFileList.Count) and (C < 10) do
        begin

          LstFileList.AddObject(FFileList[I].FileName, FFileList[I]);
          Inc(C);
          Inc(I);
        end;
      finally
        LstFileList.Items.EndUpdate;
      end;
    end
    else if LstFileList.Count > FFileList.Count then
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

    (*
    if LstFileList.Count <> FFileList.Count then
      TmrUpdateFiles.Start;
    *)
  end;
end;

procedure TGsThemeEditor.ToolbarButtonClick(Sender: TObject);
begin
  if CompOwner <> nil then
  begin
    SelectedBtn := TRzToolbarButton( Sender );

    if ( FImageList <> nil ) and not FEditingProperty then
    begin
      (*
      if Sender = BtnClearImage then
      begin
        SetObjectImageIndex( -1 );
        SetObjectDisabledIndex( -1 );
      end
      else
      *)
      begin
        AddImageToImgList( FImageList, SelectedBtn.Glyph );
      end;

      HandleTextChange( Sender );
    end
    else if FHasGlyphProp then
    begin
      SetObjectGlyph( SelectedBtn.Glyph );
      HandleTextChange( Sender );
    end
    else if FEditingProperty then
    begin
      (*
      if Sender = BtnClearImage then
      begin
        TGsCustomImageIndexProperty( FPropertyEditor ).SetOrdValue( -1 );
      end
      else
      *)
      begin
        AddImageToImgList( FImageList, SelectedBtn.Glyph );
        //TGsCustomImageIndexProperty( FPropertyEditor ).SetOrdValue( LstImageList.ItemIndex );
      end;
    end;
  end;
end; {= TRzSelectImageEditDlg.ToolbarButtonClick =}


procedure TGsThemeEditor.HandleTextChange( Sender: TObject );
begin
  if ChkSetHint.Checked then
  begin
    {
    if TextChangeType = tctCaption then
    begin
      if Sender = BtnClearImage then
        SetObjectCaption( '' )
      else
        SetObjectCaption( SelectedBtn.Hint );
    end
    else if TextChangeType = tctHint then
    begin
      if Sender = BtnClearImage then
        SetObjectHint( '' )
      else
        SetObjectHint( SelectedBtn.Hint );
    end;
    }
  end;
end;


procedure TGsThemeEditor.RearrangeCustomButtons;
var
  B: TRzToolbarButton;
  I, N: Integer;
begin
  for I := 0 to FCustomImages.Count - 1 do
  begin
    B := FCustomImages.Objects[ I ] as TRzToolbarButton;
    N := SbxCustom.Width div 25;
    B.Left := ( I mod N ) * 25;
    B.Top := ( I div N ) * 25;
  end;
end;


function TGsThemeEditor.CreateCustomButton( const S: string ): TRzToolbarButton;
var
  N: Integer;
begin
  Result := TRzToolbarButton.Create( Self );
  Result.Parent := SbxCustom;
  Result.Glyph.LoadFromFile( GetFileNameFromString( S ) );

  N := 1;
  if ( Result.Glyph.Height <> 0 ) and ( Result.Glyph.Width mod Result.Glyph.Height = 0 ) then
  begin
    N := Result.Glyph.Width div Result.Glyph.Height;
    if N > 4 then
      N := 1;
  end;
  Result.NumGlyphs := N;

  Result.Hint := GetHintFromString( S );
  Result.PopupMenu := MnuCustom;
  Result.OnClick := ToolbarButtonClick;
end;


function TGsThemeEditor.GetFileNameFromString( const S: string ): string;
begin
  Result := Copy( S, Pos( '|', S ) + 1, 255 );
end;


function TGsThemeEditor.GetHintFromString( const S: string ): string;
begin
  Result := Copy( S, 1, Pos( '|', S ) - 1 );
end;


procedure TGsThemeEditor.MnuAddClick(Sender: TObject);
var
  S, FName, HintStr: string;
begin
  DlgOpenPicture.FileName := '';
  if DlgOpenPicture.Execute then
  begin
    FName := DlgOpenPicture.FileName;
    HintStr := LowerCase( ChangeFileExt( ExtractFileName( FName ), '' ) );
    HintStr[ 1 ] := UpCase( HintStr[ 1 ] );

    S := HintStr + '|' + FName;
    FCustomImages.AddObject( S, CreateCustomButton( S ) );
    RearrangeCustomButtons;
  end;
end;


procedure TGsThemeEditor.MnuDeleteClick(Sender: TObject);
var
  S: string;
  Idx: Integer;
begin
  SelectedBtn := MnuCustom.PopupComponent as TRzToolbarButton;
  S := Format( 'Delete %s custom image?', [ SelectedBtn.Hint ] );
  if MessageDlg( S, mtConfirmation, [ mbYes, mbNo ], 0 ) = mrYes then
  begin
    Idx := FCustomImages.IndexOfObject( SelectedBtn );
    SelectedBtn.Free;
    if Idx <> -1 then
      FCustomImages.Delete( Idx );
    RearrangeCustomButtons;
  end;
end;


procedure TGsThemeEditor.MnuEditCustomHintClick(Sender: TObject);
var
  NewHint: string;
begin
  SelectedBtn := MnuCustom.PopupComponent as TRzToolbarButton;
  if SelectedBtn <> nil then
  begin
    NewHint := SelectedBtn.Hint;
    if InputQuery( 'Custom Image Hint', 'Enter New Hint', NewHint ) then
      SelectedBtn.Hint := NewHint;
  end;
end;


procedure TGsThemeEditor.MnuEditStockHintClick(Sender: TObject);
var
  NewHint: string;
begin
  SelectedBtn := MnuStock.PopupComponent as TRzToolbarButton;
  if SelectedBtn <> nil then
  begin
    NewHint := SelectedBtn.Hint;
    if InputQuery( 'Stock Image Hint', 'Enter New Hint', NewHint ) then
      SelectedBtn.Hint := NewHint;
  end;
end;


procedure TGsThemeEditor.SbxCustomResize(Sender: TObject);
begin
  RearrangeCustomButtons;
end;

procedure TGsThemeEditor.LstFileListClick(Sender: TObject);
begin
//
end;

procedure TGsThemeEditor.LstFileListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
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
  LstFileList.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + TextOffset, LstFileList.Items[Index]);
end;

procedure TGsThemeEditor.LstFileListStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
//
end;

procedure TGsThemeEditor.LstImageListDrawItem( Control: TWinControl; Index: Integer; Rect: TRect;
                                                      State: TOwnerDrawState );
var
  TextOffset: Integer;
begin
  LstImageList.Canvas.FillRect( Rect );   // Clear area for icon and text

  if FImageList <> nil then
    FImageList.Draw( LstImageList.Canvas, Rect.Left - 22, Rect.Top + 2, Index );

//  Inc( Rect.Left, 26 );
  TextOffset := ( ( Rect.Bottom - Rect.Top ) - LstImageList.Canvas.TextHeight( 'Pp' ) ) div 2;
  LstImageList.Canvas.TextRect( Rect, Rect.Left + 2, Rect.Top + TextOffset, IntToStr( Index ) );
end; {= TRzSelectImageEditDlg.LstCustomBmpsDrawItem =}

procedure TGsThemeEditor.LstImageListClick( Sender: TObject );
begin
  SetObjectImageIndex( LstImageList.ItemIndex );
end;


procedure TGsThemeEditor.FormResize(Sender: TObject);
begin
  if GrpImageList.Visible then
  begin
    GrpImageList.Height := ClientHeight - 14;
    GrpStockImages.Width := ClientWidth - 191;
    GrpCustomImages.Width := ClientWidth - 191;
  end
  else
  begin
    GrpStockImages.Left := 8;
    GrpStockImages.Width := ClientWidth - 16;
    GrpCustomImages.Left := 8;
    GrpCustomImages.Width := ClientWidth - 16;
    ChkSetHint.Left := 8;
    ChkAddDisabled.Left := 156;
  end;

  GrpCustomImages.Height := ClientHeight - 314;
  BtnDone.Top := ClientHeight - 31;
  BtnDone.Left := ClientWidth - 82;
  ChkSetHint.Top := ClientHeight - 37;
  ChkAddDisabled.Top := ClientHeight - 37;
end;

procedure TGsThemeEditor.FormShow(Sender: TObject);
begin
  FImageList := ThemeModule.Images16;
  FFileList := ThemeModule.Images[0].Stock.ImageFiles;
  FFileList.Path := IncludeTrailingPathDelimiter(ThemeModule.Images.BasePath) + ThemeModule.Images[0].Stock.Path;

  //LstFileList.Clear;
  //TmrUpdateFiles.Start;
  //UpdateProgress;

  (*
  LstFileList.Visible := False;
  try
    Application.ProcessMessages;
    S := GetTickCount;
    LstFileList.Clear;

    for I := 0 to FFileList.Count - 1 do
    begin
      LstFileList.AddObject(FFileList[I].FileName, FFileList[I]);

    end;
    MessageDlg(Format('Assign images: %d', [GetTickCount - S]), mtInformation, [mbOK], 0);
  finally
    LstFileList.Visible := True;
    LstFileList.BringToFront;
  end;
  *)
end;

initialization
  ThemeEditorsList := nil;
finalization
  ThemeEditorsList.Free;
  ThemeEditorsList := nil;
  {
  if Assigned(LThemeEditor) then
    LThemeEditor.Release;
  }
end.

