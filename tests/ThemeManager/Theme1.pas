unit Theme1;

interface

uses
  System.SysUtils, System.Classes, GsTheme, Vcl.ImgList, Vcl.Controls;

type
  TGsTheme1 = class(TCustomGsTheme)
    TplImages16: TImageList;
    TplImages24: TImageList;
    TplImages32: TImageList;
    TplImages48: TImageList;
    TplImages64: TImageList;
    TplImages128: TImageList;
    TplImages256: TImageList;
    TplDisabledImages16: TImageList;
    TplDisabledImages24: TImageList;
    TplDisabledImages32: TImageList;
    TplDisabledImages48: TImageList;
    TplDisabledImages64: TImageList;
    TplDisabledImages128: TImageList;
    TplDisabledImages256: TImageList;
    procedure CustomGsThemeCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  GsTheme1: TGsTheme1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Dialogs;

procedure TGsTheme1.CustomGsThemeCreate(Sender: TObject);
var
  I: Integer;
begin
  inherited;

  for I := 0 to Images.Count - 1 do
  begin
    //MessageDlg(Format('%d: %s', [I, ImagePaths.PathItems[I].DisplayName]), mtInformation, [mbOK], 0);
  end;
end;

end.
