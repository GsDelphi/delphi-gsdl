unit TestFormRTLUnit;

interface

uses
  RzCmboBx,
  RzLstBox,
  RzPanel,
  RzRadGrp,
  System.Classes,
  System.SysUtils,
  System.Variants,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows;

type
  TTestFormRTL = class(TForm)
    ComboBox1:     TComboBox;
    RzComboBox1:   TRzComboBox;
    RadioGroup1:   TRadioGroup;
    RzRadioGroup1: TRzRadioGroup;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  TestFormRTL: TTestFormRTL;

implementation

{$R *.dfm}

end.
