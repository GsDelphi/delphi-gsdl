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
unit GsDynControlEngine;

{$I Gilbertsoft.inc}

interface

uses
  JvDynControlEngine, Classes, Controls,
  GsDynControlEngineIntf,
  JvDynControlEngineIntf, JvDynControlEngineVCL;

type
  TGSDynControlType = TJvDynControlType;

const
  gctLabel = jctLabel;
  gctStaticText = jctStaticText;
  gctPanel = jctPanel;
  gctScrollBox = jctScrollBox;
  gctEdit = jctEdit;
  gctCheckBox = jctCheckBox;
  gctComboBox = jctComboBox;
  gctGroupBox = jctGroupBox;
  gctImage = jctImage;
  gctRadioGroup = jctRadioGroup;
  gctRadioButton = jctRadioButton;
  gctMemo = jctMemo;
  gctRichEdit = jctRichEdit;
  gctListBox = jctListBox;
  gctCheckListBox = jctCheckListBox;
  gctDateTimeEdit = jctDateTimeEdit;
  gctDateEdit = jctDateEdit;
  gctTimeEdit = jctTimeEdit;
  gctCalculateEdit = jctCalculateEdit;
  gctSpinEdit = jctSpinEdit;
  gctDirectoryEdit = jctDirectoryEdit;
  gctFileNameEdit = jctFileNameEdit;
  gctButton = jctButton;
  gctButtonEdit = jctButtonEdit;
  gctTreeView = jctTreeView;
  gctForm = jctForm;
  gctProgressBar = jctProgressBar;
  gctPageControl = jctPageControl;
  gctTabControl = jctTabControl;
  gctRTTIInspector = jctRTTIInspector;
  gctColorComboBox = jctColorComboBox;

  gctMaskEdit = TGSDynControlType('MaskEdit');
  gctNumericEdit = TGSDynControlType('NumericEdit');
  gctObjectEditor = TGSDynControlType('ObjectEditorControl');
  (*
  gct = TGSDynControlType('');
  *)

type
  TGSControlClass = JvDynControlEngine.TControlClass;

  { DynControlEngine }
  TGSDynControlEngine = class(TJvCustomDynControlEngine)
  private
    FAutoAlignControls: Boolean;
    FAutoAlignBorder: TBorderWidth;
  protected
//    procedure RegisterControls; override;
  public
    constructor Create; override;

    function CreateControlClass(AControlClass: TGSControlClass; AOwner: TComponent; AParentControl: TWinControl; AControlName: String): TControl; override;
    function IsControlTypeValid(const ADynControlType: TGSDynControlType; AControlClass: TGSControlClass): Boolean; override;

    function CreateLabel(AOwner: TComponent; AParentControl: TWinControl; const AControlName, ACaption: string; AFocusControl: TWinControl = nil): TControl; virtual;
    (*
    function CreateStaticTextControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName, ACaption: string): TWinControl; virtual;
    *)
    function CreatePanel(AOwner: TComponent; AParentControl: TWinControl; const AControlName, ACaption: String; AAlign: TAlign): TWinControl; virtual;
    function CreateScrollBox(AOwner: TComponent; AParentControl: TWinControl; const AControlName: string): TWinControl; virtual;
    (*
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
    *)
    function CreateButton(AOwner: TComponent; AParentControl: TWinControl; const AButtonName, ACaption, AHint: string; AOnClick: TNotifyEvent; ADefault: Boolean = False; ACancel: Boolean = False): TWinControl; virtual;
    (*
    function CreateRadioButton(AOwner: TComponent; AParentControl: TWinControl;
      const ARadioButtonName, ACaption: String): TWinControl; virtual;
    function CreateButtonEditControl(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName: String; AOnButtonClick: TNotifyEvent): TWinControl; virtual;
    function CreateColorComboboxControl(AOwner: TComponent; AParentControl:
        TWinControl; const AControlName: String; ADefaultColor: TColor):
        TWinControl; virtual;
    function CreateForm(const ACaption, AHint: String): TCustomForm; virtual;

    function CreateLabelControlPanel(AOwner: TComponent; AParentControl: TWinControl;
      const AControlName, ACaption: String; AFocusControl: TWinControl;
      ALabelOnTop: Boolean = True; ALabelDefaultWidth: Integer = 0): TWinControl; virtual;
    function CreateProgressbarControl(AOwner: TComponent; AParentControl:
        TWinControl; const AControlName: String; AMin: Integer = 0; AMax: Integer =
        100; AStep: Integer = 1): TWinControl; virtual;
    function CreateRTTIInspectorControl(AOwner: TComponent; AParentControl:
        TWinControl; const AControlName: String; AOnDisplayProperty:
        TJvDynControlInspectorControlOnDisplayPropertyEvent;
        AOnTranslatePropertyName:
        TJvDynControlInspectorControlOnTranslatePropertyNameEvent): TWinControl;
        virtual;
    *)


    function CreateLabledEdit(AOwner: TComponent; AParentControl: TWinControl; const ACaption: String; AEditControl: TWinControl): TWinControl; virtual;
//    function CreateObjectEditorControl(AOwner: TComponent; AParentControl: TWinControl; const AControlName: String): TWinControl; virtual;
  published
    property AutoAlignControls: Boolean read FAutoAlignControls write FAutoAlignControls;
    property AutoAlignBorder: TBorderWidth read FAutoAlignBorder write FAutoAlignBorder;
  end;

procedure SetDefaultDynControlEngine(AEngine: TGSDynControlEngine);
function DefaultDynControlEngine: TGSDynControlEngine;

implementation

uses
  SysUtils, GSVclConsts, ExtCtrls, Forms;

var
  GlobalDefaultDynControlEngine: TGSDynControlEngine = nil;

procedure SetDefaultDynControlEngine(AEngine: TGSDynControlEngine);
begin
  if AEngine is TGSDynControlEngine then
    GlobalDefaultDynControlEngine := AEngine;
end;

function DefaultDynControlEngine: TGSDynControlEngine;
begin
  Result := GlobalDefaultDynControlEngine;
end;

{ TGSDynControlEngine }

constructor TGSDynControlEngine.Create;
begin
  inherited;

  FAutoAlignControls := True;
  FAutoAlignBorder := 4;
end;

function TGSDynControlEngine.CreateButton(AOwner: TComponent;
  AParentControl: TWinControl; const AButtonName, ACaption, AHint: string;
  AOnClick: TNotifyEvent; ADefault, ACancel: Boolean): TWinControl;
var
  DynCtrlCaption: IJvDynControlCaption;
  DynCtrlButton: IJvDynControlButton;
  DynControl: IJvDynControl;
  DynCtrlFont: IJvDynControlFont;
begin
  Result := TWinControl(CreateControl(gctButton, AOwner, AParentControl, AButtonName));
  Result.Hint := AHint;

  if (ACaption <> '') then
  begin
    IntfCast(Result, IJvDynControlCaption, DynCtrlCaption);
    DynCtrlCaption.ControlSetCaption(ACaption);
  end;

  IntfCast(Result, IJvDynControlButton, DynCtrlButton);
  DynCtrlButton.ControlSetDefault(ADefault);
  DynCtrlButton.ControlSetCancel(ACancel);

  if Assigned(AOnClick) then
  begin
    IntfCast(Result, IJvDynControl, DynControl);
    DynControl.ControlSetOnClick(AOnClick);
  end;

  if not AutoAlignControls then
  begin
    IntfCast(Result, IJvDynControlFont, DynCtrlFont);
    Result.Width := GetControlTextWidth(Result, DynCtrlFont.ControlFont, ACaption + 'XXXX');
  end;
end;

function TGSDynControlEngine.CreateControlClass(
  AControlClass: JvDynControlEngine.TControlClass; AOwner: TComponent;
  AParentControl: TWinControl; AControlName: String): TControl;
var
  DynCtrlBevelBorder: IJvDynControlBevelBorder;
begin
  Result := inherited CreateControlClass(AControlClass, AOwner, AParentControl, AControlName);

  if AutoAlignControls then
  begin
    Result.Align := alBottom;
    Result.Align := alTop;

    if (Result is TCustomPanel) and Supports(Result, IJvDynControlBevelBorder, DynCtrlBevelBorder) then
    begin
      DynCtrlBevelBorder.ControlSetBevelInner(bvNone);
      DynCtrlBevelBorder.ControlSetBevelOuter(bvNone);
      DynCtrlBevelBorder.ControlSetBevelKind(bkNone);
      DynCtrlBevelBorder.ControlSetBorderStyle(bsNone);
      DynCtrlBevelBorder.ControlSetBorderWidth(AutoAlignBorder div 2);
    end;
  end;
end;

function TGSDynControlEngine.CreateLabel(AOwner: TComponent;
  AParentControl: TWinControl; const AControlName, ACaption: String;
  AFocusControl: TWinControl): TControl;
var
  DynCtrlCaption: IJvDynControlCaption;
  DynCtrlLabel: IJvDynControlLabel;
begin
  Result := CreateControl(gctLabel, AOwner, AParentControl, AControlName);

  IntfCast(Result, IJvDynControlCaption, DynCtrlCaption);
  DynCtrlCaption.ControlSetCaption(ACaption);

  if Assigned(AFocusControl) then
  begin
    IntfCast(Result, IJvDynControlLabel, DynCtrlLabel);
    DynCtrlLabel.ControlSetFocusControl(AFocusControl);
  end;
end;

function TGSDynControlEngine.CreateLabledEdit(AOwner: TComponent;
  AParentControl: TWinControl; const ACaption: String;
  AEditControl: TWinControl): TWinControl;
var
  LabelCtrl: TControl;
begin
  if not Assigned(AEditControl) then
    {$IFDEF CLR}
    raise Exception.Create(SDynControlEngineErrorNoFocusControl);
    {$ELSE}
    raise Exception.CreateRes(@SDynControlEngineErrorNoFocusControl);
    {$ENDIF CLR}

  Result := CreatePanel(AOwner, AParentControl, AEditControl.Name, '', alNone);

  LabelCtrl := CreateLabel(AOwner, Result, '', ACaption, AEditControl);
  AEditControl.Parent := Result;

  if AutoAlignControls then
  begin
    Result.Height := AutoAlignBorder + LabelCtrl.Height + AEditControl.Height;

    AEditControl.Align := alBottom;
    AEditControl.Align := alTop;
  end
  else
  begin
    LabelCtrl.Top := 1;
    LabelCtrl.Left := 1;

    (*
    if ALabelOnTop then
    begin
    *)
      AEditControl.Top := LabelCtrl.Height + 1 {DistanceBetweenLabelAndControlVert};
      AEditControl.Left := 1;

      if LabelCtrl.Width > AEditControl.Width then
        Result.Width := LabelCtrl.Width
      else
        Result.Width := AEditControl.Width;

      Result.Height := AEditControl.Top + AEditControl.Height;
    (*
    end
    else
    begin
      if ALabelDefaultWidth > 0 then
        LabelControl.Width := ALabelDefaultWidth;
      AFocusControl.Left := LabelControl.Width + DistanceBetweenLabelAndControlHorz;
      AFocusControl.Top := 1;
      if LabelControl.Height > AFocusControl.Height then
        Panel.Height := LabelControl.Height
      else
        Panel.Height := AFocusControl.Height;
      Panel.Width := AFocusControl.Width + AFocusControl.Left;
    end;
    *)

    Result.Width := Result.Width + 1;
    Result.Height := Result.Height + 1;
  end;
end;

function TGSDynControlEngine.CreatePanel(AOwner: TComponent;
  AParentControl: TWinControl; const AControlName, ACaption: String;
  AAlign: TAlign): TWinControl;
var
  DynCtrlCaption: IJvDynControlCaption;
begin
  Result := TWinControl(CreateControl(gctPanel, AOwner, AParentControl, AControlName));

  if (ACaption <> '') then
  begin
    IntfCast(Result, IJvDynControlCaption, DynCtrlCaption);
    DynCtrlCaption.ControlSetCaption(ACaption);
  end;

  if not AutoAlignControls then
    Result.Align := AAlign;
end;

function TGSDynControlEngine.CreateScrollBox(AOwner: TComponent;
  AParentControl: TWinControl; const AControlName: String): TWinControl;
begin
  Result := TWinControl(CreateControl(gctScrollBox, AOwner, AParentControl, AControlName));
end;

function TGSDynControlEngine.IsControlTypeValid(
  const ADynControlType: TJvDynControlType;
  AControlClass: JvDynControlEngine.TControlClass): Boolean;
begin
  Result := inherited IsControlTypeValid(ADynControlType, AControlClass);

  (*
  if (ADynControlType = jctGSObjectEditor) then
    Result := Result and Supports(AControlClass, IJvDynControlPanel);
  *)
  if (ADynControlType = gctMaskEdit) or
     (ADynControlType = gctNumericEdit) then
    Result := Result and Supports(AControlClass, IJvDynControlData);
end;

end.
