unit Theme2;

interface

uses
  System.SysUtils, System.Classes, GsTheme, Vcl.ImgList, Vcl.Controls;

type
  TGsTheme2 = class(TCustomGsTheme)
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
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  GsTheme2: TGsTheme2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
