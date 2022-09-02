unit GsOtaRepositoryUtils;

interface

uses
  JclOtaRepositoryUtils,
  ToolsAPI;

type
  TGsOtaRepositoryExpert = class(TJclOtaRepositoryExpert,
    IOTARepositoryWizard160)
  protected
    { IOTARepositoryWizard160 }
    function GetFrameworkTypes: TArray<string>; virtual; abstract;
    function GetPlatforms: TArray<string>; virtual; abstract;
  public
    property FrameworkTypes: TArray<string> read GetFrameworkTypes;
    property Platforms: TArray<string> read GetPlatforms;
  end;

implementation

end.
