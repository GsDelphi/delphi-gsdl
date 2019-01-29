{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2017-2018 Simon Gilli
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
unit GsDynControlEngineRC;

{$I Gilbertsoft.inc}

interface

uses
  ActnList,
  Buttons,
  Classes,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
  FileCtrl,
  Forms,
  Graphics,
  GsDynControlEngine,
  GsDynControlEngineIntf,
  ImgList,
  JvDynControlEngineIntf,
  RzBtnEdt,
  RzButton,
  RzChkLst,
  RzCmboBx,
  RzCommon,
  RzEdit,
  RzLabel,
  RzLstBox,
  RzPanel,
  RzPrgres,
  RzRadChk,
  RzRadGrp,
  RzSpnEdt,
  RzTabs,
  RzTreeVw,
  StdCtrls;

const
  jctGSObjectEditor = TGSDynControlType('GSObjectEditorControl');
  jctGSMaskEdit     = TGSDynControlType('GSMaskEdit');
  jctGSNumericEdit  = TGSDynControlType('GSNumericEdit');
  (*
  jctGS = TJvDynControlType('GS');
  jctGS = TJvDynControlType('GS');
  *)

type
  { DynControlEngine }
  TGSDynControlEngineRC = class(TGSDynControlEngine)
  private
    FFrameController: TRzFrameController;
    procedure SetFrameController(const Value: TRzFrameController);
  protected
    procedure RegisterControls; override;
  public
    function CreateControlClass(AControlClass: TGSControlClass;
      AOwner: TComponent; AParentControl: TWinControl; AControlName: string): TControl;
      override;
    function IsControlTypeValid(const ADynControlType: TGSDynControlType;
      AControlClass: TGSControlClass): Boolean; override;

    (*
    function CreateLabelControl(AOwner: TComponent; AParentControl: TWinControl;
        const AControlName, ACaption: string; AFocusControl: TWinControl = nil):
        TControl; virtual;
    function CreateStaticTextControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName, ACaption: string): TWinControl; virtual;
    function CreatePanelControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName, ACaption: string; AAlign: TAlign): TWinControl; virtual;
    function CreateScrollBoxControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateEditControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateCheckboxControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName, ACaption: string): TWinControl; virtual;
    function CreateComboBoxControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string; AItems: TStrings): TWinControl; virtual;
    function CreateGroupBoxControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName, ACaption: string): TWinControl; virtual;
    function CreateImageControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateRadioGroupControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName, ACaption: string; AItems: TStrings;
      AItemIndex: Integer = 0): TWinControl; virtual;
    function CreateMemoControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateRichEditControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateListBoxControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string; AItems: TStrings): TWinControl; virtual;
    function CreateCheckListBoxControl(AOwner: TComponent; AParentControl:
        TWinControl; const AControlName: string; AItems: TStrings): TWinControl;
        virtual;
    function CreateDateTimeControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateDateControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateTimeControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateCalculateControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateSpinControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateDirectoryControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateFileNameControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreateTreeViewControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string): TWinControl; virtual;
    function CreatePageControlControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string; APages : TStrings): TWinControl; virtual;
    function CreateTabControlControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string; ATabs : TStrings): TWinControl; virtual;
    function CreateButton(AOwner: TComponent; AParentControl: TWinControl;
      const AButtonName, ACaption, AHint: string;
      AOnClick: TNotifyEvent; ADefault: Boolean = False;
      ACancel: Boolean = False): TButton; virtual;
    function CreateRadioButton(AOwner: TComponent; AParentControl: TWinControl;
      const ARadioButtonName, ACaption: string): TWinControl; virtual;
    function CreateButtonEditControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: string; AOnButtonClick: TNotifyEvent): TWinControl; virtual;
    function CreateColorComboboxControl(AOwner: TComponent; AParentControl:
        TWinControl; const AControlName: string; ADefaultColor: TColor):
        TWinControl; virtual;
    function CreateForm(const ACaption, AHint: string): TCustomForm; virtual;

    function CreateLabelControlPanel(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName, ACaption: string; AFocusControl: TWinControl;
      ALabelOnTop: Boolean = True; ALabelDefaultWidth: Integer = 0): TWinControl; virtual;
    function CreateProgressbarControl(AOwner: TComponent; AParentControl:
        TWinControl; const AControlName: string; AMin: Integer = 0; AMax: Integer =
        100; AStep: Integer = 1): TWinControl; virtual;
    function CreateRTTIInspectorControl(AOwner: TComponent; AParentControl:
        TWinControl; const AControlName: string; AOnDisplayProperty:
        TJvDynControlInspectorControlOnDisplayPropertyEvent;
        AOnTranslatePropertyName:
        TJvDynControlInspectorControlOnTranslatePropertyNameEvent): TWinControl;
        virtual;
    *)


    function CreateObjectEditorControl(AOwner: TComponent;
      AParentControl: TWinControl; const AControlName: string): TWinControl; virtual;
  published
    property FrameController: TRzFrameController
      read FFrameController write SetFrameController;
  end;


  { Interfaces }
  IGSDynControlNumericEdit = interface
    ['{29C0460A-5ED5-4F68-ADA7-BC5A3E62E40F}']
    procedure ControlSetDisplayFormat(Value: string);
    procedure ControlSetMinValue(Value: Extended);
    procedure ControlSetMaxValue(Value: Extended);
    procedure ControlSetIntegersOnly(Value: Boolean);
    procedure ControlSetCheckRange(Value: Boolean);
  end;

  IGSDynControlButtonEdit = interface
    ['{5965DAB5-1691-4CF4-8198-6F51639A5F95}']
    procedure ControlSetButtonKind(Value: TButtonKind);
  end;


  { Raize Components }
  TGSDynControlRCEdit = class(TRzEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlReadOnly, IJvDynControlEdit)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    { IJvDynControlEdit }
    procedure ControlSetPasswordChar(Value: Char);
    procedure ControlSetEditMask(const Value: string);
  end;

  TGSDynControlRCMaskEdit = class(TRzMaskEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlReadOnly, IJvDynControlEdit)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    { IJvDynControlEdit }
    procedure ControlSetPasswordChar(Value: Char);
    procedure ControlSetEditMask(const Value: string);
  end;

  TGSDynControlRCNumericEdit = class(TRzNumericEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlReadOnly,
    IGSDynControlNumericEdit)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    { IGSDynControlNumericEdit }
    procedure ControlSetDisplayFormat(Value: string);
    procedure ControlSetMinValue(Value: Extended);
    procedure ControlSetMaxValue(Value: Extended);
    procedure ControlSetIntegersOnly(Value: Boolean);
    procedure ControlSetCheckRange(Value: Boolean);
  end;

  TGSDynControlRCButtonEdit = class(TRzButtonEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlReadOnly, IJvDynControlEdit,
    IJvDynControlButtonEdit, IJvDynControlButton, IGSDynControlButtonEdit)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    { IJvDynControlEdit }
    procedure ControlSetPasswordChar(Value: Char);
    procedure ControlSetEditMask(const Value: string);

    { IJvDynControlButtonEdit }
    procedure ControlSetOnButtonClick(Value: TNotifyEvent);
    procedure ControlSetButtonCaption(const Value: string);

    { IJvDynControlButton }
    procedure ControlSetGlyph(Value: TBitmap);
    procedure ControlSetNumGlyphs(Value: Integer);
    procedure ControlSetLayout(Value: TButtonLayout);
    procedure ControlSetDefault(Value: Boolean);
    procedure ControlSetCancel(Value: Boolean);

    { IGSDynControlButtonEdit }
    procedure ControlSetButtonKind(Value: TButtonKind);
  end;

  TGSDynControlRCCalcEdit = class(TRzNumericEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlReadOnly,
    IGSDynControlNumericEdit)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    { IGSDynControlNumericEdit }
    procedure ControlSetDisplayFormat(Value: string);
    procedure ControlSetMinValue(Value: Extended);
    procedure ControlSetMaxValue(Value: Extended);
    procedure ControlSetIntegersOnly(Value: Boolean);
    procedure ControlSetCheckRange(Value: Boolean);
  end;

  TGSDynControlRCSpinEdit = class(TRzSpinEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlReadOnly, IJvDynControlSpin)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    { IJvDynControlSpin }
    procedure ControlSetIncrement(Value: Integer);
    procedure ControlSetMinValue(Value: Double);
    procedure ControlSetMaxValue(Value: Double);
    procedure ControlSetUseForInteger(Value: Boolean);
  end;

  TGSDynControlRCFileNameEdit = class(TGSDynControlRCButtonEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlFileName,
    IJvDynControlReadOnly)
  private
    FInitialDir:    string;
    FFilterIndex:   Integer;
    FFilter:        string;
    FDialogOptions: TOpenOptions;
    FDialogKind:    TJvDynControlFileNameDialogKind;
    FDialogTitle:   string;
    FDefaultExt:    string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DefaultOnButtonClick(Sender: TObject);

    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    // IJvDynControlFileName
    procedure ControlSetInitialDir(const Value: string);
    procedure ControlSetDefaultExt(const Value: string);
    procedure ControlSetDialogTitle(const Value: string);
    procedure ControlSetDialogOptions(Value: TOpenOptions);
    procedure ControlSetFilter(const Value: string);
    procedure ControlSetFilterIndex(Value: Integer);
    procedure ControlSetDialogKind(Value: TJvDynControlFileNameDialogKind);
  end;

  TGSDynControlRCDirectoryEdit = class(TGSDynControlRCButtonEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlDirectory,
    IJvDynControlReadOnly)
  private
    FInitialDir:    string;
    FDialogOptions: TSelectDirOpts;
    FDialogTitle:   string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DefaultOnButtonClick(Sender: TObject);

    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    { IJvDynControlEdit }
    procedure ControlSetPasswordChar(Value: Char);
    procedure ControlSetEditMask(const Value: string);

    // IJvDynControlDirectory
    procedure ControlSetInitialDir(const Value: string);
    procedure ControlSetDialogTitle(const Value: string);
    procedure ControlSetDialogOptions(Value: TSelectDirOpts);
  end;

  TGSDynControlRCDateTimeEdit = class(TRzPanel, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlDate)
  private
    FDatePicker: TRzDateTimeEdit;
    FTimePicker: TRzDateTimeEdit;
  protected
    procedure ControlResize(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    // IJvDynControlDate
    procedure ControlSetMinDate(Value: TDateTime);
    procedure ControlSetMaxDate(Value: TDateTime);
    procedure ControlSetFormat(const Value: string);
  end;

  TGSDynControlRCDateEdit = class(TRzDateTimeEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlDate)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    // IJvDynControlDate
    procedure ControlSetMinDate(Value: TDateTime);
    procedure ControlSetMaxDate(Value: TDateTime);
    procedure ControlSetFormat(const Value: string);
  end;

  TGSDynControlRCTimeEdit = class(TRzDateTimeEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlTime)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    { IJvDynControlEdit }
    procedure ControlSetPasswordChar(Value: Char);
    procedure ControlSetEditMask(const Value: string);


    procedure ControlSetFormat(const Value: string);
  end;

  TGSDynControlRCCheckBox = class(TRzCheckBox, IUnknown,
    IJvDynControl, IJvDynControlCaption, IJvDynControlData,
    IJvDynControlCheckBox, IJvDynControlFont)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    function ControlGetCaption: string;
    procedure ControlSetCaption(const Value: string);


    //IJvDynControlCheckBox
    procedure ControlSetAllowGrayed(Value: Boolean);
    procedure ControlSetState(Value: TCheckBoxState);
    function ControlGetState: TCheckBoxState;

    //IJvDynControlFont
    procedure ControlSetFont(Value: TFont);
    function ControlGetFont: TFont;
  end;

  TGSDynControlRCMemo = class(TRzMemo, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlItems, IJvDynControlMemo,
    IJvDynControlReadOnly, IJvDynControlAlignment)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    procedure ControlSetSorted(Value: Boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;

    procedure ControlSetWantTabs(Value: Boolean);
    procedure ControlSetWantReturns(Value: Boolean);
    procedure ControlSetWordWrap(Value: Boolean);
    procedure ControlSetScrollBars(Value: TScrollStyle);
    //IJvDynControlAlignment
    procedure ControlSetAlignment(Value: TAlignment);
  end;

  TGSDynControlRCRichEdit = class(TRzRichEdit, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlItems, IJvDynControlMemo,
    IJvDynControlReadOnly)
  public
    { IJvDynControl }
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    { IJvDynControlData }
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    { IJvDynControlReadOnly }
    procedure ControlSetReadOnly(Value: Boolean);

    procedure ControlSetSorted(Value: Boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;

    procedure ControlSetWantTabs(Value: Boolean);
    procedure ControlSetWantReturns(Value: Boolean);
    procedure ControlSetWordWrap(Value: Boolean);
    procedure ControlSetScrollBars(Value: TScrollStyle);
  end;

  TGSDynControlRCRadioGroup = class(TRzRadioGroup, IUnknown,
    IJvDynControl, IJvDynControlCaption, IJvDynControlData, IJvDynControlItems,
    IJvDynControlRadioGroup)
  public
    function ControlGetCaption: string;
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(const Value: string);
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    procedure ControlSetSorted(Value: Boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;

    procedure ControlSetColumns(Value: Integer);
  end;

  TGSDynControlRCListBox = class(TRzListBox, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlItems, IJvDynControlItemIndex,
    IJvDynControlDblClick)
  public
    function ControlGetItemIndex: Integer;
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    procedure ControlSetSorted(Value: Boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;
    procedure ControlSetItemIndex(const Value: Integer);

    procedure ControlSetOnDblClick(Value: TNotifyEvent);
  end;

  TGSDynControlRCCheckListBox = class(TRzCheckList, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlItems, IJvDynControlDblClick,
    IJvDynControlCheckListBox)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    procedure ControlSetSorted(Value: Boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;

    procedure ControlSetOnDblClick(Value: TNotifyEvent);

    //IJvDynControlCheckListBox = interface
    procedure ControlSetAllowGrayed(Value: Boolean);
    procedure ControlSetChecked(Index: Integer; Value: Boolean);
    procedure ControlSetItemEnabled(Index: Integer; Value: Boolean);
    procedure ControlSetState(Index: Integer; Value: TCheckBoxState);
    function ControlGetChecked(Index: Integer): Boolean;
    function ControlGetItemEnabled(Index: Integer): Boolean;
    function ControlGetState(Index: Integer): TCheckBoxState;
    procedure ControlSetHeader(Index: Integer; Value: Boolean);
    function ControlGetHeader(Index: Integer): Boolean;
  end;

  TGSDynControlRCComboBox = class(TRzComboBox, IUnknown,
    IJvDynControl, IJvDynControlData, IJvDynControlItems, IJvDynControlComboBox)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    procedure ControlSetSorted(Value: Boolean);
    procedure ControlSetItems(Value: TStrings);
    function ControlGetItems: TStrings;

    procedure ControlSetNewEntriesAllowed(Value: Boolean);
  end;

  TGSDynControlRCGroupBox = class(TRzGroupBox, IUnknown,
    IJvDynControl, IJvDynControlCaption)
  public
    function ControlGetCaption: string;
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(const Value: string);
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);
  end;

  TGSDynControlRCPanel = class(TRzPanel, IUnknown,
    IJvDynControl, IJvDynControlCaption, IJvDynControlPanel, IJvDynControlAlign,
    IJvDynControlAutoSize, IJvDynControlBevelBorder, IJvDynControlColor,
    IJvDynControlAlignment)
  public
    function ControlGetCaption: string;
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(const Value: string);
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    procedure ControlSetBorder(ABevelInner: TPanelBevel; ABevelOuter: TPanelBevel;
      ABevelWidth: Integer; ABorderStyle: TBorderStyle; ABorderWidth: Integer);

    // IJvDynControlAlign
    procedure ControlSetAlign(Value: TAlign);

    // IJvDynControlAutoSize
    procedure ControlSetAutoSize(Value: Boolean);

    // IJvDynControlBevelBorder
    procedure ControlSetBevelInner(Value: TBevelCut);
    procedure ControlSetBevelKind(Value: TBevelKind);
    procedure ControlSetBevelOuter(Value: TBevelCut);
    procedure ControlSetBorderStyle(Value: TBorderStyle);
    procedure ControlSetBorderWidth(Value: Integer);
    // IJvDynControlColor
    procedure ControlSetColor(Value: TColor);
    procedure ControlSetParentColor(Value: Boolean);
    //IJvDynControlAlignment
    procedure ControlSetAlignment(Value: TAlignment);
  end;

  TGSDynControlRCLabel = class(TRzLabel, IUnknown,
    IJvDynControl, IJvDynControlCaption, IJvDynControlLabel, IJvDynControlAlign,
    IJvDynControlAutoSize, IJvDynControlColor,
    IJvDynControlAlignment, IJvDynControlFont)
  public
    function ControlGetCaption: string;
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(const Value: string);
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    procedure ControlSetFocusControl(Value: TWinControl);
    procedure ControlSetWordWrap(Value: Boolean);

    // IJvDynControlAlign
    procedure ControlSetAlign(Value: TAlign);

    // IJvDynControlAutoSize
    procedure ControlSetAutoSize(Value: Boolean);

    // IJvDynControlColor
    procedure ControlSetColor(Value: TColor);
    procedure ControlSetParentColor(Value: Boolean);

    //IJvDynControlAlignment
    procedure ControlSetAlignment(Value: TAlignment);

    //IJvDynControlFont
    procedure ControlSetFont(Value: TFont);
    function ControlGetFont: TFont;
  end;

  TGSDynControlRCButton = class(TRzBitBtn, IUnknown,
    IJvDynControl, IJvDynControlCaption, IJvDynControlButton,
    IGSDynControlButton, IJvDynControlAction)
  public
    function ControlGetCaption: string;
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(const Value: string);
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    procedure ControlSetGlyph(Value: TBitmap);
    procedure ControlSetNumGlyphs(Value: Integer);
    procedure ControlSetLayout(Value: TButtonLayout);
    procedure ControlSetDefault(Value: Boolean);
    procedure ControlSetCancel(Value: Boolean);

    // IJvDynControlAction
    procedure ControlSetAction(Value: TCustomAction);

    { IGSDynControlButton }
    procedure ControlSetModalResult(Value: TModalResult);
  end;

  TGSDynControlRCRadioButton = class(TRzRadioButton, IUnknown,
    IJvDynControl, IJvDynControlCaption, IJvDynControlData)
  public
    function ControlGetCaption: string;
    procedure ControlSetDefaultProperties;
    procedure ControlSetCaption(const Value: string);
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    // IJvDynControlData
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;
  end;

  TGSDynControlRCTreeView = class(TRzTreeView, IUnknown,
    IJvDynControl, IJvDynControlTreeView, IJvDynControlReadOnly, IJvDynControlDblClick)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    // IJvDynControlReadOnly
    procedure ControlSetReadOnly(Value: Boolean);

    // IJvDynControlTreeView
    procedure ControlSetAutoExpand(Value: Boolean);
    procedure ControlSetHotTrack(Value: Boolean);
    procedure ControlSetShowHint(Value: Boolean);
    procedure ControlSetShowLines(Value: Boolean);
    procedure ControlSetShowRoot(Value: Boolean);
    procedure ControlSetToolTips(Value: Boolean);
    procedure ControlSetItems(Value: TTreeNodes);
    function ControlGetItems: TTreeNodes;
    procedure ControlSetImages(Value: TCustomImageList);
    procedure ControlSetStateImages(Value: TCustomImageList);
    function ControlGetSelected: TTreeNode;
    procedure ControlSetSelected(const Value: TTreeNode);
    procedure ControlSetOnChange(Value: TTVChangedEvent);
    procedure ControlSetOnChanging(Value: TTVChangingEvent);
    procedure ControlSetSortType(Value: TSortType);
    procedure ControlSortItems;

    //IJvDynControlDblClick = interface
    procedure ControlSetOnDblClick(Value: TNotifyEvent);
  end;

  TGSDynControlRCProgressBar = class(TRzProgressBar, IUnknown, IJvDynControl,
    IJvDynControlCaption, IJvDynControlAlign, IJvDynControlProgressBar)
  public
    //IJvDynControl
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);
    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);
    //IJvDynControlCaption
    function ControlGetCaption: string;
    procedure ControlSetCaption(const Value: string);
    //IJvDynControlAlign
    procedure ControlSetAlign(Value: TAlign);
    //IJvDynControlProgressBar
    procedure ControlSetMarquee(Value: Boolean);
    procedure ControlSetMax(Value: Integer);
    procedure ControlSetMin(Value: Integer);
    procedure ControlSetOrientation(Value: TProgressBarOrientation);
    procedure ControlSetPosition(Value: Integer);
    procedure ControlSetSmooth(Value: Boolean);
    procedure ControlSetStep(Value: Integer);
  end;

  TGSDynControlRCTabControl = class(TRzTabControl, IUnknown,
    IJvDynControl, IJvDynControlTabControl)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    //IJvDynControlTabControl
    procedure ControlCreateTab(const AName: string);
    procedure ControlSetOnChangeTab(OnChangeEvent: TNotifyEvent);
    procedure ControlSetOnChangingTab(OnChangingEvent: TTabChangingEvent);
    procedure ControlSetTabIndex(Index: Integer);
    function ControlGetTabIndex: Integer;
    procedure ControlSetMultiLine(Value: Boolean);
    procedure ControlSetScrollOpposite(Value: Boolean);
    procedure ControlSetHotTrack(Value: Boolean);
    procedure ControlSetRaggedRight(Value: Boolean);
  end;

  TGSDynControlRCPageControl = class(TRzPageControl, IUnknown,
    IJvDynControl, IJvDynControlTabControl, IJvDynControlPageControl)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: string);
    procedure ControlSetAnchors(Value: TAnchors);

    //IJvDynControlTabControl
    procedure ControlCreateTab(const AName: string);
    procedure ControlSetOnChangeTab(OnChangeEvent: TNotifyEvent);
    procedure ControlSetOnChangingTab(OnChangingEvent: TTabChangingEvent);
    procedure ControlSetTabIndex(Index: Integer);
    function ControlGetTabIndex: Integer;
    procedure ControlSetMultiLine(Value: Boolean);
    procedure ControlSetScrollOpposite(Value: Boolean);
    procedure ControlSetHotTrack(Value: Boolean);
    procedure ControlSetRaggedRight(Value: Boolean);

    //IJvDynControlPageControl
    function ControlGetPage(const PageName: string): TWinControl;
  end;

  {$IFDEF DELPHI6_UP}
  TGSDynControlRCColorComboBox = class(TRzColorComboBox, IUnknown, IJvDynControl,
      IJvDynControlColorComboBoxControl)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: String);
    procedure ControlSetAnchors(Value: TAnchors);

    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;

    //IJvDynControlColorComboBoxControl
    function ControlGetColorName(AColor: TColor): String;
    function ControlGetSelectedColor: TColor;
    procedure ControlSetSelectedColor(const Value: TColor);
    function GetControlDefaultColor: TColor; stdcall;
    procedure SetControlDefaultColor(const Value: TColor); stdcall;
  end;
  {$ENDIF DELPHI6_UP}

  (*
  TGSDynControlRCCalcEdit = class(TRzCalcEdit, IUnknown, IJvDynControl,
    IJvDynControlData, IJvDynControlReadOnly)
  public
    procedure ControlSetDefaultProperties;
    procedure ControlSetReadOnly(Value: Boolean);
    procedure ControlSetTabOrder(Value: Integer);

    procedure ControlSetOnEnter(Value: TNotifyEvent);
    procedure ControlSetOnExit(Value: TNotifyEvent);
    procedure ControlSetOnChange(Value: TNotifyEvent);
    procedure ControlSetOnClick(Value: TNotifyEvent);
    procedure ControlSetHint(const Value: String);

    procedure ControlSetValue(Value: Variant);
    function ControlGetValue: Variant;
    procedure ControlSetAnchors(Value: TAnchors);
  end;
  *)

function DynControlEngineRC: TGSDynControlEngineRC;

implementation

uses
  BPLogging,
  GSDynControlEngineVCL,
  Mask,
  SysUtils,
  TypInfo;

var
  IntDynControlEngineRC: TGSDynControlEngineRC = nil;

function DynControlEngineRC: TGSDynControlEngineRC;
begin
  Result := IntDynControlEngineRC;
end;

function TGSDynControlEngineRC.CreateControlClass(AControlClass: TGSControlClass;
  AOwner: TComponent; AParentControl: TWinControl; AControlName: string): TControl;
begin
  Result := inherited CreateControlClass(AControlClass, AOwner,
    AParentControl, AControlName);

  if Assigned(FrameController) and IsPublishedProp(Result, 'FrameController') then
    SetObjectProp(Result, 'FrameController', FrameController);
end;

function TGSDynControlEngineRC.CreateObjectEditorControl(AOwner: TComponent;
  AParentControl: TWinControl; const AControlName: string): TWinControl;
begin
  Result := TWinControl(CreateControl(jctGSObjectEditor, AOwner,
    AParentControl, AControlName));
end;

function TGSDynControlEngineRC.IsControlTypeValid(
  const ADynControlType: TGSDynControlType; AControlClass: TGSControlClass): Boolean;
begin
  Result := inherited IsControlTypeValid(ADynControlType, AControlClass);

  (*
  if (ADynControlType = jctGSObjectEditor) then
    Result := Result and Supports(AControlClass, IJvDynControlPanel);
  *)
  if (ADynControlType = jctGSMaskEdit) or (ADynControlType = jctGSNumericEdit) then
    Result := Result and Supports(AControlClass, IJvDynControlData);

  if (ADynControlType = jctGSNumericEdit) then
    Result := Result and Supports(AControlClass, IGSDynControlNumericEdit);
end;

procedure TGSDynControlEngineRC.RegisterControls;
begin
  RegisterControlType(gctLabel, TGSDynControlRCLabel);
  RegisterControlType(gctStaticText, TGSDynControlVCLStaticText);
  RegisterControlType(gctButton, TGSDynControlRCButton);
  RegisterControlType(gctRadioButton, TGSDynControlRCRadioButton);
  RegisterControlType(gctScrollBox, TGSDynControlVCLScrollBox);
  RegisterControlType(gctGroupBox, TGSDynControlRCGroupBox);
  RegisterControlType(gctPanel, TGSDynControlRCPanel);
  RegisterControlType(gctImage, TGSDynControlVCLImage);
  RegisterControlType(gctCheckBox, TGSDynControlRCCheckBox);
  RegisterControlType(gctComboBox, TGSDynControlRCComboBox);
  RegisterControlType(gctListBox, TGSDynControlRCListBox);
  RegisterControlType(gctCheckListBox, TGSDynControlRCCheckListBox);
  RegisterControlType(gctRadioGroup, TGSDynControlRCRadioGroup);
  RegisterControlType(gctDateTimeEdit, TGSDynControlRCDateTimeEdit);
  RegisterControlType(gctTimeEdit, TGSDynControlRCTimeEdit);
  RegisterControlType(gctDateEdit, TGSDynControlRCDateEdit);
  RegisterControlType(gctEdit, TGSDynControlRCEdit);
  RegisterControlType(gctMaskEdit, TGSDynControlRCMaskEdit);
  RegisterControlType(gctNumericEdit, TGSDynControlRCNumericEdit);
  RegisterControlType(gctCalculateEdit, TGSDynControlRCCalcEdit);
  RegisterControlType(gctSpinEdit, TGSDynControlRCSpinEdit);
  RegisterControlType(gctDirectoryEdit, TGSDynControlRCDirectoryEdit);
  RegisterControlType(gctFileNameEdit, TGSDynControlRCFileNameEdit);
  RegisterControlType(gctMemo, TGSDynControlRCMemo);
  RegisterControlType(gctRichEdit, TGSDynControlRCRichEdit);
  RegisterControlType(gctButtonEdit, TGSDynControlRCButtonEdit);
  RegisterControlType(gctTreeView, TGSDynControlRCTreeView);
  RegisterControlType(gctProgressbar, TGSDynControlRCProgressbar);
  RegisterControlType(gctTabControl, TGSDynControlRCTabControl);
  RegisterControlType(gctPageControl, TGSDynControlRCPageControl);
  {$IFDEF DELPHI6_UP}
  RegisterControlType(gctColorComboBox, TGSDynControlVCLColorComboBox);
  {$ENDIF DELPHI6_UP}
end;

procedure TGSDynControlEngineRC.SetFrameController(const Value: TRzFrameController);
begin
  FFrameController := Value;
end;

{ TGSDynControlRCEdit }

function TGSDynControlRCEdit.ControlGetValue: Variant;
begin
  Result := Text;
end;

procedure TGSDynControlRCEdit.ControlSetAnchors(Value: TAnchors);
begin
  Anchors := Value;
end;

procedure TGSDynControlRCEdit.ControlSetDefaultProperties;
begin
end;

procedure TGSDynControlRCEdit.ControlSetEditMask(const Value: string);
begin
end;

procedure TGSDynControlRCEdit.ControlSetHint(const Value: string);
begin
  Hint := Value;
end;

procedure TGSDynControlRCEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  OnChange := Value;
end;

procedure TGSDynControlRCEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TGSDynControlRCEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TGSDynControlRCEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TGSDynControlRCEdit.ControlSetPasswordChar(Value: Char);
begin
  PasswordChar := Value;
end;

procedure TGSDynControlRCEdit.ControlSetReadOnly(Value: Boolean);
begin
  ReadOnly := Value;
end;

procedure TGSDynControlRCEdit.ControlSetTabOrder(Value: Integer);
begin
  TabOrder := Value;
end;

procedure TGSDynControlRCEdit.ControlSetValue(Value: Variant);
begin
  Text := Value;
end;

{ TGSDynControlRCMaskEdit }

function TGSDynControlRCMaskEdit.ControlGetValue: Variant;
begin
  Result := Text;
end;

procedure TGSDynControlRCMaskEdit.ControlSetAnchors(Value: TAnchors);
begin
  Anchors := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetDefaultProperties;
begin
end;

procedure TGSDynControlRCMaskEdit.ControlSetEditMask(const Value: string);
begin
  EditMask := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetHint(const Value: string);
begin
  Hint := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  OnChange := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetPasswordChar(Value: Char);
begin
  PasswordChar := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetReadOnly(Value: Boolean);
begin
  ReadOnly := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetTabOrder(Value: Integer);
begin
  TabOrder := Value;
end;

procedure TGSDynControlRCMaskEdit.ControlSetValue(Value: Variant);
begin
  Text := Value;
end;

{ TGSDynControlRCNumericEdit }

function TGSDynControlRCNumericEdit.ControlGetValue: Variant;
begin
  if IntegersOnly then
    Result := IntValue
  else
    Result := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetAnchors(Value: TAnchors);
begin
  Anchors := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetCheckRange(Value: Boolean);
begin
  CheckRange := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetDefaultProperties;
begin
end;

procedure TGSDynControlRCNumericEdit.ControlSetDisplayFormat(Value: string);
begin
  DisplayFormat := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetHint(const Value: string);
begin
  Hint := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetIntegersOnly(Value: Boolean);
begin
  IntegersOnly := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetMaxValue(Value: Extended);
begin
  Max := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetMinValue(Value: Extended);
begin
  Min := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  OnChange := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetReadOnly(Value: Boolean);
begin
  ReadOnly := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetTabOrder(Value: Integer);
begin
  TabOrder := Value;
end;

procedure TGSDynControlRCNumericEdit.ControlSetValue(Value: Variant);
begin
  if IntegersOnly then
    IntValue := Value
  else
    Self.Value := Value;
end;

{ TGSDynControlRCButtonEdit }

function TGSDynControlRCButtonEdit.ControlGetValue: Variant;
begin
  Result := Text;
end;

procedure TGSDynControlRCButtonEdit.ControlSetAnchors(Value: TAnchors);
begin
  Anchors := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetButtonCaption(const Value: string);
begin
  Button.Caption := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetButtonKind(Value: TButtonKind);
begin
  ButtonKind := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetCancel(Value: Boolean);
begin
end;

procedure TGSDynControlRCButtonEdit.ControlSetDefault(Value: Boolean);
begin
end;

procedure TGSDynControlRCButtonEdit.ControlSetDefaultProperties;
begin
end;

procedure TGSDynControlRCButtonEdit.ControlSetEditMask(const Value: string);
begin
end;

procedure TGSDynControlRCButtonEdit.ControlSetGlyph(Value: TBitmap);
begin
  ButtonGlyph.Assign(Value);
end;

procedure TGSDynControlRCButtonEdit.ControlSetHint(const Value: string);
begin
  Hint := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetLayout(Value: TButtonLayout);
begin
end;

procedure TGSDynControlRCButtonEdit.ControlSetNumGlyphs(Value: Integer);
begin
  ButtonNumGlyphs := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetOnButtonClick(Value: TNotifyEvent);
begin
  OnButtonClick := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  OnChange := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetPasswordChar(Value: Char);
begin
  PasswordChar := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetReadOnly(Value: Boolean);
begin
  ReadOnly := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetTabOrder(Value: Integer);
begin
  TabOrder := Value;
end;

procedure TGSDynControlRCButtonEdit.ControlSetValue(Value: Variant);
begin
  Self.Text := Value;
end;

{ TGSDynControlRCCalcEdit }

function TGSDynControlRCCalcEdit.ControlGetValue: Variant;
begin
  if IntegersOnly then
    Result := IntValue
  else
    Result := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetAnchors(Value: TAnchors);
begin
  Anchors := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetCheckRange(Value: Boolean);
begin
  CheckRange := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetDefaultProperties;
begin
  CalculatorVisible := True;
  IntegersOnly := False;
end;

procedure TGSDynControlRCCalcEdit.ControlSetDisplayFormat(Value: string);
begin
  DisplayFormat := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetHint(const Value: string);
begin
  Hint := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetIntegersOnly(Value: Boolean);
begin
  IntegersOnly := False;
end;

procedure TGSDynControlRCCalcEdit.ControlSetMaxValue(Value: Extended);
begin
  Max := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetMinValue(Value: Extended);
begin
  Min := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetOnChange(Value: TNotifyEvent);
begin
  OnChange := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetReadOnly(Value: Boolean);
begin
  ReadOnly := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetTabOrder(Value: Integer);
begin
  TabOrder := Value;
end;

procedure TGSDynControlRCCalcEdit.ControlSetValue(Value: Variant);
begin
  if IntegersOnly then
    IntValue := Value
  else
    Self.Value := Value;
end;

{ TGSDynControlRCSpinEdit }

function TGSDynControlRCSpinEdit.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetIncrement(Value: Integer);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetMaxValue(Value: Double);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetMinValue(Value: Double);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetUseForInteger(Value: Boolean);
begin

end;

procedure TGSDynControlRCSpinEdit.ControlSetValue(Value: Variant);
begin

end;

{ TGSDynControlRCFileNameEdit }

function TGSDynControlRCFileNameEdit.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetDefaultExt(const Value: string);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetDialogKind(
  Value: TJvDynControlFileNameDialogKind);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetDialogOptions(Value: TOpenOptions);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetDialogTitle(const Value: string);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetFilter(const Value: string);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetFilterIndex(Value: Integer);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetInitialDir(const Value: string);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCFileNameEdit.ControlSetValue(Value: Variant);
begin

end;

constructor TGSDynControlRCFileNameEdit.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TGSDynControlRCFileNameEdit.DefaultOnButtonClick(Sender: TObject);
begin

end;

destructor TGSDynControlRCFileNameEdit.Destroy;
begin

  inherited;
end;

{ TGSDynControlRCDirectoryEdit }

function TGSDynControlRCDirectoryEdit.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetDialogOptions(Value: TSelectDirOpts);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetDialogTitle(const Value: string);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetEditMask(const Value: string);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetInitialDir(const Value: string);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetPasswordChar(Value: Char);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCDirectoryEdit.ControlSetValue(Value: Variant);
begin

end;

constructor TGSDynControlRCDirectoryEdit.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TGSDynControlRCDirectoryEdit.DefaultOnButtonClick(Sender: TObject);
begin

end;

destructor TGSDynControlRCDirectoryEdit.Destroy;
begin

  inherited;
end;

{ TGSDynControlRCDateTimeEdit }

function TGSDynControlRCDateTimeEdit.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlResize(Sender: TObject);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetFormat(const Value: string);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetMaxDate(Value: TDateTime);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetMinDate(Value: TDateTime);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCDateTimeEdit.ControlSetValue(Value: Variant);
begin

end;

constructor TGSDynControlRCDateTimeEdit.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TGSDynControlRCDateTimeEdit.Destroy;
begin

  inherited;
end;

{ TGSDynControlRCDateEdit }

function TGSDynControlRCDateEdit.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetFormat(const Value: string);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetMaxDate(Value: TDateTime);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetMinDate(Value: TDateTime);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCDateEdit.ControlSetValue(Value: Variant);
begin

end;

{ TGSDynControlRCTimeEdit }

function TGSDynControlRCTimeEdit.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetEditMask(const Value: string);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetFormat(const Value: string);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetPasswordChar(Value: Char);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCTimeEdit.ControlSetValue(Value: Variant);
begin

end;

{ TGSDynControlRCCheckBox }

function TGSDynControlRCCheckBox.ControlGetCaption: string;
begin

end;

function TGSDynControlRCCheckBox.ControlGetFont: TFont;
begin

end;

function TGSDynControlRCCheckBox.ControlGetState: TCheckBoxState;
begin

end;

function TGSDynControlRCCheckBox.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetAllowGrayed(Value: Boolean);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetCaption(const Value: string);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetFont(Value: TFont);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetState(Value: TCheckBoxState);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCCheckBox.ControlSetValue(Value: Variant);
begin

end;

{ TGSDynControlRCMemo }

function TGSDynControlRCMemo.ControlGetItems: TStrings;
begin

end;

function TGSDynControlRCMemo.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCMemo.ControlSetAlignment(Value: TAlignment);
begin

end;

procedure TGSDynControlRCMemo.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCMemo.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCMemo.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCMemo.ControlSetItems(Value: TStrings);
begin

end;

procedure TGSDynControlRCMemo.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCMemo.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCMemo.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCMemo.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCMemo.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCMemo.ControlSetScrollBars(Value: TScrollStyle);
begin

end;

procedure TGSDynControlRCMemo.ControlSetSorted(Value: Boolean);
begin

end;

procedure TGSDynControlRCMemo.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCMemo.ControlSetValue(Value: Variant);
begin

end;

procedure TGSDynControlRCMemo.ControlSetWantReturns(Value: Boolean);
begin

end;

procedure TGSDynControlRCMemo.ControlSetWantTabs(Value: Boolean);
begin

end;

procedure TGSDynControlRCMemo.ControlSetWordWrap(Value: Boolean);
begin

end;

{ TGSDynControlRCRichEdit }

function TGSDynControlRCRichEdit.ControlGetItems: TStrings;
begin

end;

function TGSDynControlRCRichEdit.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetItems(Value: TStrings);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetScrollBars(Value: TScrollStyle);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetSorted(Value: Boolean);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetValue(Value: Variant);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetWantReturns(Value: Boolean);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetWantTabs(Value: Boolean);
begin

end;

procedure TGSDynControlRCRichEdit.ControlSetWordWrap(Value: Boolean);
begin

end;

{ TGSDynControlRCRadioGroup }

function TGSDynControlRCRadioGroup.ControlGetCaption: string;
begin

end;

function TGSDynControlRCRadioGroup.ControlGetItems: TStrings;
begin

end;

function TGSDynControlRCRadioGroup.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetCaption(const Value: string);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetColumns(Value: Integer);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetItems(Value: TStrings);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetSorted(Value: Boolean);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCRadioGroup.ControlSetValue(Value: Variant);
begin

end;

{ TGSDynControlRCListBox }

function TGSDynControlRCListBox.ControlGetItemIndex: Integer;
begin

end;

function TGSDynControlRCListBox.ControlGetItems: TStrings;
begin

end;

function TGSDynControlRCListBox.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCListBox.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCListBox.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCListBox.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCListBox.ControlSetItemIndex(const Value: Integer);
begin

end;

procedure TGSDynControlRCListBox.ControlSetItems(Value: TStrings);
begin

end;

procedure TGSDynControlRCListBox.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCListBox.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCListBox.ControlSetOnDblClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCListBox.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCListBox.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCListBox.ControlSetSorted(Value: Boolean);
begin

end;

procedure TGSDynControlRCListBox.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCListBox.ControlSetValue(Value: Variant);
begin

end;

{ TGSDynControlRCCheckListBox }

function TGSDynControlRCCheckListBox.ControlGetChecked(Index: Integer): Boolean;
begin

end;

function TGSDynControlRCCheckListBox.ControlGetHeader(Index: Integer): Boolean;
begin

end;

function TGSDynControlRCCheckListBox.ControlGetItemEnabled(Index: Integer): Boolean;
begin

end;

function TGSDynControlRCCheckListBox.ControlGetItems: TStrings;
begin

end;

function TGSDynControlRCCheckListBox.ControlGetState(Index: Integer): TCheckBoxState;
begin

end;

function TGSDynControlRCCheckListBox.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetAllowGrayed(Value: Boolean);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetChecked(Index: Integer; Value: Boolean);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetHeader(Index: Integer; Value: Boolean);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetItemEnabled(Index: Integer;
  Value: Boolean);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetItems(Value: TStrings);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetOnDblClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetSorted(Value: Boolean);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetState(Index: Integer;
  Value: TCheckBoxState);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCCheckListBox.ControlSetValue(Value: Variant);
begin

end;

{ TGSDynControlRCComboBox }

function TGSDynControlRCComboBox.ControlGetItems: TStrings;
begin

end;

function TGSDynControlRCComboBox.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCComboBox.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCComboBox.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetItems(Value: TStrings);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetNewEntriesAllowed(Value: Boolean);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetSorted(Value: Boolean);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCComboBox.ControlSetValue(Value: Variant);
begin

end;

{ TGSDynControlRCGroupBox }

function TGSDynControlRCGroupBox.ControlGetCaption: string;
begin

end;

procedure TGSDynControlRCGroupBox.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCGroupBox.ControlSetCaption(const Value: string);
begin

end;

procedure TGSDynControlRCGroupBox.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCGroupBox.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCGroupBox.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCGroupBox.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCGroupBox.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCGroupBox.ControlSetTabOrder(Value: Integer);
begin

end;

{ TGSDynControlRCPanel }

function TGSDynControlRCPanel.ControlGetCaption: string;
begin
  Result := Caption;
end;

procedure TGSDynControlRCPanel.ControlSetAlign(Value: TAlign);
begin
  Align := Value;
end;

procedure TGSDynControlRCPanel.ControlSetAlignment(Value: TAlignment);
begin
  Alignment := Value;
end;

procedure TGSDynControlRCPanel.ControlSetAnchors(Value: TAnchors);
begin
  Anchors := Value;
end;

procedure TGSDynControlRCPanel.ControlSetAutoSize(Value: Boolean);
begin
  AutoSize := Value;
end;

procedure TGSDynControlRCPanel.ControlSetBevelInner(Value: TBevelCut);
begin
  BevelInner := Value;
end;

procedure TGSDynControlRCPanel.ControlSetBevelKind(Value: TBevelKind);
begin
  BevelKind := Value;
end;

procedure TGSDynControlRCPanel.ControlSetBevelOuter(Value: TBevelCut);
begin
  BevelOuter := Value;
end;

procedure TGSDynControlRCPanel.ControlSetBorder(ABevelInner, ABevelOuter: TPanelBevel;
  ABevelWidth: Integer; ABorderStyle: TBorderStyle; ABorderWidth: Integer);
begin
  BorderWidth := ABorderWidth;
  BorderStyle := ABorderStyle;
  BevelInner  := ABevelInner;
  BevelOuter  := ABevelOuter;
  BevelWidth  := ABevelWidth;
end;

procedure TGSDynControlRCPanel.ControlSetBorderStyle(Value: TBorderStyle);
begin
  BorderStyle := Value;
end;

procedure TGSDynControlRCPanel.ControlSetBorderWidth(Value: Integer);
begin
  BorderWidth := Value;
end;

procedure TGSDynControlRCPanel.ControlSetCaption(const Value: string);
begin
  Caption := Value;
end;

procedure TGSDynControlRCPanel.ControlSetColor(Value: TColor);
begin
  Color := Value;
end;

procedure TGSDynControlRCPanel.ControlSetDefaultProperties;
begin
  BevelInner  := bvNone;
  BevelOuter  := bvNone;
  BorderInner := fsNone;
  BorderOuter := fsNone;
end;

procedure TGSDynControlRCPanel.ControlSetHint(const Value: string);
begin
  Hint := Value;
end;

procedure TGSDynControlRCPanel.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TGSDynControlRCPanel.ControlSetOnEnter(Value: TNotifyEvent);
begin
  OnEnter := Value;
end;

procedure TGSDynControlRCPanel.ControlSetOnExit(Value: TNotifyEvent);
begin
  OnExit := Value;
end;

procedure TGSDynControlRCPanel.ControlSetParentColor(Value: Boolean);
begin
  ParentColor := Value;
end;

procedure TGSDynControlRCPanel.ControlSetTabOrder(Value: Integer);
begin
  TabOrder := Value;
end;

{ TGSDynControlRCLabel }

function TGSDynControlRCLabel.ControlGetCaption: string;
begin
  Result := Caption;
end;

function TGSDynControlRCLabel.ControlGetFont: TFont;
begin
  Result := Font;
end;

procedure TGSDynControlRCLabel.ControlSetAlign(Value: TAlign);
begin
  Align := Value;
end;

procedure TGSDynControlRCLabel.ControlSetAlignment(Value: TAlignment);
begin
  Alignment := Value;
end;

procedure TGSDynControlRCLabel.ControlSetAnchors(Value: TAnchors);
begin
  Anchors := Value;
end;

procedure TGSDynControlRCLabel.ControlSetAutoSize(Value: Boolean);
begin
  AutoSize := Value;
end;

procedure TGSDynControlRCLabel.ControlSetCaption(const Value: string);
begin
  if Caption <> Value then
    Caption := Value;
end;

procedure TGSDynControlRCLabel.ControlSetColor(Value: TColor);
begin
  Color := Value;
end;

procedure TGSDynControlRCLabel.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCLabel.ControlSetFocusControl(Value: TWinControl);
begin
  FocusControl := Value;
end;

procedure TGSDynControlRCLabel.ControlSetFont(Value: TFont);
begin
  Font.Assign(Value);
end;

procedure TGSDynControlRCLabel.ControlSetHint(const Value: string);
begin
  Hint := Value;
end;

procedure TGSDynControlRCLabel.ControlSetOnClick(Value: TNotifyEvent);
begin
end;

procedure TGSDynControlRCLabel.ControlSetOnEnter(Value: TNotifyEvent);
begin
end;

procedure TGSDynControlRCLabel.ControlSetOnExit(Value: TNotifyEvent);
begin
end;

procedure TGSDynControlRCLabel.ControlSetParentColor(Value: Boolean);
begin
  ParentColor := Value;
end;

procedure TGSDynControlRCLabel.ControlSetTabOrder(Value: Integer);
begin
end;

procedure TGSDynControlRCLabel.ControlSetWordWrap(Value: Boolean);
begin
  WordWrap := Value;
end;

{ TGSDynControlRCButton }

function TGSDynControlRCButton.ControlGetCaption: string;
begin
  Result := Caption;
end;

procedure TGSDynControlRCButton.ControlSetAction(Value: TCustomAction);
begin
  Action := Value;
end;

procedure TGSDynControlRCButton.ControlSetAnchors(Value: TAnchors);
begin
  Anchors := Value;
end;

procedure TGSDynControlRCButton.ControlSetCancel(Value: Boolean);
begin
  Cancel := Value;
end;

procedure TGSDynControlRCButton.ControlSetCaption(const Value: string);
begin
  if Caption <> Value then
    Caption := Value;
end;

procedure TGSDynControlRCButton.ControlSetDefault(Value: Boolean);
begin
  Default := Value;
end;

procedure TGSDynControlRCButton.ControlSetDefaultProperties;
begin
end;

procedure TGSDynControlRCButton.ControlSetGlyph(Value: TBitmap);
begin
  Glyph.Assign(Value);
end;

procedure TGSDynControlRCButton.ControlSetHint(const Value: string);
begin
  Hint := Value;
end;

procedure TGSDynControlRCButton.ControlSetLayout(Value: TButtonLayout);
begin
  Layout := Value;
end;

procedure TGSDynControlRCButton.ControlSetModalResult(Value: TModalResult);
begin
  ModalResult := Value;
end;

procedure TGSDynControlRCButton.ControlSetNumGlyphs(Value: Integer);
begin
  NumGlyphs := Value;
end;

procedure TGSDynControlRCButton.ControlSetOnClick(Value: TNotifyEvent);
begin
  OnClick := Value;
end;

procedure TGSDynControlRCButton.ControlSetOnEnter(Value: TNotifyEvent);
begin
end;

procedure TGSDynControlRCButton.ControlSetOnExit(Value: TNotifyEvent);
begin
end;

procedure TGSDynControlRCButton.ControlSetTabOrder(Value: Integer);
begin
end;

{ TGSDynControlRCRadioButton }

function TGSDynControlRCRadioButton.ControlGetCaption: string;
begin

end;

function TGSDynControlRCRadioButton.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetCaption(const Value: string);
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetOnChange(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCRadioButton.ControlSetValue(Value: Variant);
begin

end;

{ TGSDynControlRCTreeView }

function TGSDynControlRCTreeView.ControlGetItems: TTreeNodes;
begin

end;

function TGSDynControlRCTreeView.ControlGetSelected: TTreeNode;
begin

end;

procedure TGSDynControlRCTreeView.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetAutoExpand(Value: Boolean);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCTreeView.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetHotTrack(Value: Boolean);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetImages(Value: TCustomImageList);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetItems(Value: TTreeNodes);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetOnChange(Value: TTVChangedEvent);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetOnChanging(Value: TTVChangingEvent);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetOnDblClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetReadOnly(Value: Boolean);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetSelected(const Value: TTreeNode);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetShowHint(Value: Boolean);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetShowLines(Value: Boolean);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetShowRoot(Value: Boolean);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetSortType(Value: TSortType);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetStateImages(Value: TCustomImageList);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCTreeView.ControlSetToolTips(Value: Boolean);
begin

end;

procedure TGSDynControlRCTreeView.ControlSortItems;
begin

end;

{ TGSDynControlRCProgressBar }

function TGSDynControlRCProgressBar.ControlGetCaption: string;
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetAlign(Value: TAlign);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetCaption(const Value: string);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetMarquee(Value: Boolean);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetMax(Value: Integer);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetMin(Value: Integer);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetOrientation(
  Value: TProgressBarOrientation);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetPosition(Value: Integer);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetSmooth(Value: Boolean);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetStep(Value: Integer);
begin

end;

procedure TGSDynControlRCProgressBar.ControlSetTabOrder(Value: Integer);
begin

end;

{ TGSDynControlRCTabControl }

procedure TGSDynControlRCTabControl.ControlCreateTab(const AName: string);
begin

end;

function TGSDynControlRCTabControl.ControlGetTabIndex: Integer;
begin

end;

procedure TGSDynControlRCTabControl.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCTabControl.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetHotTrack(Value: Boolean);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetMultiLine(Value: Boolean);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetOnChangeTab(OnChangeEvent: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetOnChangingTab(
  OnChangingEvent: TTabChangingEvent);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetRaggedRight(Value: Boolean);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetScrollOpposite(Value: Boolean);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetTabIndex(Index: Integer);
begin

end;

procedure TGSDynControlRCTabControl.ControlSetTabOrder(Value: Integer);
begin

end;

{ TGSDynControlRCPageControl }

procedure TGSDynControlRCPageControl.ControlCreateTab(const AName: string);
begin

end;

function TGSDynControlRCPageControl.ControlGetPage(
  const PageName: string): TWinControl;
begin

end;

function TGSDynControlRCPageControl.ControlGetTabIndex: Integer;
begin

end;

procedure TGSDynControlRCPageControl.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCPageControl.ControlSetHint(const Value: string);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetHotTrack(Value: Boolean);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetMultiLine(Value: Boolean);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetOnChangeTab(
  OnChangeEvent: TNotifyEvent);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetOnChangingTab(
  OnChangingEvent: TTabChangingEvent);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetOnClick(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetOnEnter(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetOnExit(Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetRaggedRight(Value: Boolean);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetScrollOpposite(Value: Boolean);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetTabIndex(Index: Integer);
begin

end;

procedure TGSDynControlRCPageControl.ControlSetTabOrder(Value: Integer);
begin

end;

{ TGSDynControlRCColorComboBox }

{$IFDEF DELPHI6_UP}

function TGSDynControlRCColorComboBox.ControlGetColorName(
  AColor: TColor): String;
begin

end;

function TGSDynControlRCColorComboBox.ControlGetSelectedColor: TColor;
begin

end;

function TGSDynControlRCColorComboBox.ControlGetValue: Variant;
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetAnchors(Value: TAnchors);
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetDefaultProperties;
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetHint(const Value: String);
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetOnChange(
  Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetOnClick(
  Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetOnEnter(
  Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetOnExit(
  Value: TNotifyEvent);
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetSelectedColor(
  const Value: TColor);
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetTabOrder(Value: Integer);
begin

end;

procedure TGSDynControlRCColorComboBox.ControlSetValue(Value: Variant);
begin

end;

function TGSDynControlRCColorComboBox.GetControlDefaultColor: TColor;
begin

end;

procedure TGSDynControlRCColorComboBox.SetControlDefaultColor(
  const Value: TColor);
begin

end;

{$ENDIF DELPHI6_UP}

initialization
  BPC_CodeSite.EnterInitialization('GSDynControlEngineRC');

  IntDynControlEngineRC := TGSDynControlEngineRC.Create;
  SetDefaultDynControlEngine(IntDynControlEngineRC);

  BPC_CodeSite.ExitInitialization('GSDynControlEngineRC');

finalization
  BPC_CodeSite.EnterFinalization('GSDynControlEngineRC');

  FreeAndNil(IntDynControlEngineRC);

  BPC_CodeSite.ExitFinalization('GSDynControlEngineRC');
end.

