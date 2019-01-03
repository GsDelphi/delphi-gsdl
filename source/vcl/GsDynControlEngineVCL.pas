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
unit GsDynControlEngineVCL;

{$I Gilbertsoft.inc}

interface

uses
  GsDynControlEngine, GsDynControlEngineIntf, JvDynControlEngineVCL,
  Controls;

type
  { DynControlEngine }
  TGSDynControlEngineVCL = class(TGSDynControlEngine)
  protected
    procedure RegisterControls; override;
  end;


  { VCL Components }
  TGSDynControlVCLLabel = class(TJvDynControlVCLLabel);
  TGSDynControlVCLStaticText = class(TJvDynControlVCLStaticText);

  TGSDynControlVCLButton = class(TJvDynControlVCLButton, IGSDynControlButton)
  public
    { IGSDynControlButton }
    procedure ControlSetModalResult(Value: TModalResult);
  end;

  TGSDynControlVCLRadioButton = class(TJvDynControlVCLRadioButton);
  TGSDynControlVCLScrollBox = class(TJvDynControlVCLScrollBox);
  TGSDynControlVCLGroupBox = class(TJvDynControlVCLGroupBox);
  TGSDynControlVCLPanel = class(TJvDynControlVCLPanel);
  TGSDynControlVCLImage = class(TJvDynControlVCLImage);
  TGSDynControlVCLCheckBox = class(TJvDynControlVCLCheckBox);
  TGSDynControlVCLComboBox = class(TJvDynControlVCLComboBox);
  TGSDynControlVCLListBox = class(TJvDynControlVCLListBox);
  TGSDynControlVCLCheckListBox = class(TJvDynControlVCLCheckListBox);
  TGSDynControlVCLRadioGroup = class(TJvDynControlVCLRadioGroup);
  TGSDynControlVCLDateTimeEdit = class(TJvDynControlVCLDateTimeEdit);
  TGSDynControlVCLTimeEdit = class(TJvDynControlVCLTimeEdit);
  TGSDynControlVCLDateEdit = class(TJvDynControlVCLDateEdit);
  TGSDynControlVCLMaskEdit = class(TJvDynControlVCLMaskEdit);
  TGSDynControlVCLDirectoryEdit = class(TJvDynControlVCLDirectoryEdit);
  TGSDynControlVCLFileNameEdit = class(TJvDynControlVCLFileNameEdit);
  TGSDynControlVCLMemo = class(TJvDynControlVCLMemo);
  TGSDynControlVCLRichEdit = class(TJvDynControlVCLRichEdit);
  TGSDynControlVCLButtonEdit = class(TJvDynControlVCLButtonEdit);
  TGSDynControlVCLTreeView = class(TJvDynControlVCLTreeView);
  TGSDynControlVCLProgressbar = class(TJvDynControlVCLProgressbar);
  TGSDynControlVCLTabControl = class(TJvDynControlVCLTabControl);
  TGSDynControlVCLPageControl = class(TJvDynControlVCLPageControl);
  {$IFDEF DELPHI7_UP}
  TGSDynControlVCLColorComboBox = class(TJvDynControlVCLColorComboBox);
  {$ENDIF}

implementation

uses
  SysUtils, Buttons, BPLogging;

var
  IntDynControlEngineVCL: TGSDynControlEngineVCL = nil;

function DynControlEngineVCL: TGSDynControlEngineVCL;
begin
  Result := IntDynControlEngineVCL;
end;

{ TGSDynControlEngineVCL }

procedure TGSDynControlEngineVCL.RegisterControls;
begin
  inherited;

  RegisterControlType(gctLabel, TJvDynControlVCLLabel);
  RegisterControlType(gctStaticText, TJvDynControlVCLStaticText);
  RegisterControlType(gctButton, TJvDynControlVCLButton);
  RegisterControlType(gctRadioButton, TJvDynControlVCLRadioButton);
  RegisterControlType(gctScrollBox, TJvDynControlVCLScrollBox);
  RegisterControlType(gctGroupBox, TJvDynControlVCLGroupBox);
  RegisterControlType(gctPanel, TJvDynControlVCLPanel);
  RegisterControlType(gctImage, TJvDynControlVCLImage);
  RegisterControlType(gctCheckBox, TJvDynControlVCLCheckBox);
  RegisterControlType(gctComboBox, TJvDynControlVCLComboBox);
  RegisterControlType(gctListBox, TJvDynControlVCLListBox);
  RegisterControlType(gctCheckListBox, TJvDynControlVCLCheckListBox);
  RegisterControlType(gctRadioGroup, TJvDynControlVCLRadioGroup);
  RegisterControlType(gctDateTimeEdit, TJvDynControlVCLDateTimeEdit);
  RegisterControlType(gctTimeEdit, TJvDynControlVCLTimeEdit);
  RegisterControlType(gctDateEdit, TJvDynControlVCLDateEdit);
  RegisterControlType(gctEdit, TJvDynControlVCLMaskEdit);
  //  RegisterControlType(gctCalculateEdit, TJvDynControlVCLMaskEdit);
  //  RegisterControlType(gctSpinEdit, TJvDynControlVCLMaskEdit);
  RegisterControlType(gctDirectoryEdit, TJvDynControlVCLDirectoryEdit);
  RegisterControlType(gctFileNameEdit, TJvDynControlVCLFileNameEdit);
  RegisterControlType(gctMemo, TJvDynControlVCLMemo);
  RegisterControlType(gctRichEdit, TJvDynControlVCLRichEdit);
  RegisterControlType(gctButtonEdit, TJvDynControlVCLButtonEdit);
  RegisterControlType(gctTreeView, TJvDynControlVCLTreeView);
  RegisterControlType(gctProgressbar, TJvDynControlVCLProgressbar);
  RegisterControlType(gctTabControl, TJvDynControlVCLTabControl);
  RegisterControlType(gctPageControl, TJvDynControlVCLPageControl);
  {$IFDEF DELPHI7_UP}
  RegisterControlType(gctColorComboBox, TJvDynControlVCLColorComboBox);
  {$ENDIF}
end;

{ TGSDynControlVCLButton }

procedure TGSDynControlVCLButton.ControlSetModalResult(
  Value: TModalResult);
begin
  ModalResult := Value;
end;

initialization
  BPC_CodeSite.EnterInitialization('GSDynControlEngineVCL');

  IntDynControlEngineVCL := TGSDynControlEngineVCL.Create;
  SetDefaultDynControlEngine(IntDynControlEngineVCL);

  BPC_CodeSite.ExitInitialization('GSDynControlEngineVCL');
finalization
  BPC_CodeSite.EnterFinalization('GSDynControlEngineVCL');

  FreeAndNil(IntDynControlEngineVCL);

  BPC_CodeSite.ExitFinalization('GSDynControlEngineVCL');
end.
