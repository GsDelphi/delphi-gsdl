program GsThemeManager;

uses
  Vcl.Forms,
  ThemeMgrMain in 'ThemeMgrMain.pas' {Form1},
  Theme1 in 'Theme1.pas' {GsTheme1: TCustomGsTheme},
  ImgEdit in 'ImgEdit.pas' {ImageListEditor},
  GsImageListEditorFrame in '..\..\design\GsThemeEditor\GsImageListEditorFrame.pas' {GsImageListEditor: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TGsTheme1, GsTheme1);
  Application.Run;
end.
