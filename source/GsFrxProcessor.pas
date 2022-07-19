unit GsFrxProcessor;

interface

uses
  Classes,
  frxClass,
  frxPrinter,
  Printers,
  SysUtils,
  Windows;

type
  EGsFrxProcessorError = class(Exception);

  TGsReportPrintOptions = class(TfrxPrintOptions)
  protected
  public
    procedure Assign(Source: TPersistent); override;
    // Is needed because TfrxPrintOptions.Assign does not call inherited method
    procedure AssignTo(Dest: TPersistent); override;
  end;

  TGsPrinterOptions = class(TPersistent)
  private
    FBin:           Integer;
    FDuplex:        Integer;
    FDefOrientation: TPrinterOrientation;
    FDefPaper:      Integer;
    FDefPaperHeight: Extended;
    FDefPaperWidth: Extended;
    FDefBin:        Integer;
    FDefDuplex:     Integer;
    FFileName:      string;
    FName:          string;
    FPaper:         Integer;
    FPaperHeight:   Extended;
    FPaperWidth:    Extended;
    FLeftMargin:    Extended;
    FTopMargin:     Extended;
    FRightMargin:   Extended;
    FBottomMargin:  Extended;
    FOrientation:   TPrinterOrientation;
    FMode:          TDeviceMode;
  protected
    //procedure AssignTo(Dest: TPersistent); override;
  public
    procedure Assign(Source: TPersistent); override;

    procedure AssignFromPrinter(Printer: TfrxPrinter);
    procedure AssignToPrinter(Printer: TfrxPrinter);

    property Bin: Integer read FBin;
    property Duplex: Integer read FDuplex;
    //property Bins: TStrings read FBins;
    //property Canvas: TfrxPrinterCanvas read FCanvas;
    property DefOrientation: TPrinterOrientation read FDefOrientation;
    property DefPaper: Integer read FDefPaper;
    property DefPaperHeight: Extended read FDefPaperHeight;
    property DefPaperWidth: Extended read FDefPaperWidth;
    property DefBin: Integer read FDefBin;
    property DefDuplex: Integer read FDefDuplex;
    //property DPI: TPoint read FDPI;
    property FileName: string read FFileName write FFileName;
    //property Handle: THandle read FHandle;
    property Name: string read FName;
    property Paper: Integer read FPaper;
    //property Papers: TStrings read FPapers;
    property PaperHeight: Extended read FPaperHeight;
    property PaperWidth: Extended read FPaperWidth;
    property LeftMargin: Extended read FLeftMargin;
    property TopMargin: Extended read FTopMargin;
    property RightMargin: Extended read FRightMargin;
    property BottomMargin: Extended read FBottomMargin;
    property Orientation: TPrinterOrientation read FOrientation;

    property DeviceMode: TDeviceMode read FMode;
  end;

  TGsStatus = class(TPersistent)
  private
    FReport:  TGsReportPrintOptions;
    FPrinter: TGsPrinterOptions;
    procedure SetPrinter(const Value: TGsPrinterOptions);
    procedure SetReport(const Value: TGsReportPrintOptions);
  protected
    //procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property Report: TGsReportPrintOptions read FReport write SetReport;
    property Printer: TGsPrinterOptions read FPrinter write SetPrinter;
  end;

  TGsReportId = string;

  TGsFrxProcessingOption  = (opPreview, opPrintDialog, opPreserveLastReport,
    opPrepareOnly, opKeepStatus, opKeepPrintDialog);
  TGsFrxProcessingOptions = set of TGsFrxProcessingOption;

  TGsFrxProcessor = class(TObject)
  private
    FReportsStatus: TStrings;
    FReportId:      TGsReportId;
    FReport:        TfrxReport;
    FReportStatus:  TGsStatus;
    FSavedOnPrintReport: TNotifyEvent;
    FDuplexActive:  Boolean;
    procedure OnPrintReport(Sender: TObject);
  protected
    function GetReportsStatus(Id: TGsReportId; Report: TfrxReport): TGsStatus;
    procedure StatusBackupToOptions(Report: TfrxReport; Status: TGsStatus);
    procedure StatusRestoreFromOptions(Report: TfrxReport; Status: TGsStatus);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure ProcessReport(Id: TGsReportId; Report: TfrxReport;
      Options: TGsFrxProcessingOptions);

    property ReportId: TGsReportId read FReportId;
    property Report: TfrxReport read FReport;
    property ReportStatus: TGsStatus read FReportStatus;
    property DuplexActive: Boolean read FDuplexActive;
  end;

function ReportProcessor: TGsFrxProcessor;

implementation

uses
  Forms;

type
  THackCustomPrinter = class(TObject)
  private
  protected
    FBin: Integer;
    FDuplex: Integer;
    FBins: TStrings;
    FCanvas: TfrxPrinterCanvas;
    FDefOrientation: TPrinterOrientation;
    FDefPaper: Integer;
    FDefPaperHeight: Extended;
    FDefPaperWidth: Extended;
    FDefDuplex: Integer;
    FDefBin: Integer;
    FDPI: TPoint;
    FFileName: string;
    FHandle: THandle;
    FInitialized: Boolean;
    FName: string;
    FPaper: Integer;
    FPapers: TStrings;
    FPaperHeight: Extended;
    FPaperWidth: Extended;
    FLeftMargin: Extended;
    FTopMargin: Extended;
    FRightMargin: Extended;
    FBottomMargin: Extended;
    FOrientation: TPrinterOrientation;
    FPort: string;
    FPrinting: Boolean;
    FTitle: string;
    FDeviceMode: THandle;
    FDC: HDC;
    FDriver: string;
    FMode: PDeviceMode;
  public
    class procedure CheckHack(AClass: TClass);
  end;

resourcestring
  SErrorPrepareReport =
    'Beim Vorbereiten des Berichtes sind folgende Fehler aufgetreten: %s';

var
  LReportProcessor: TGsFrxProcessor = nil;

function ReportProcessor: TGsFrxProcessor;
begin
  if (LReportProcessor = nil) then
    LReportProcessor := TGsFrxProcessor.Create;

  Result := LReportProcessor;
end;

{ THackCustomPrinter }

class procedure THackCustomPrinter.CheckHack(AClass: TClass);
begin
  Assert(InstanceSize = AClass.InstanceSize,
    Format('InstanceSize of %s has changed, please check hack class %s',
    [AClass.ClassName, ClassName]));
  Assert(ClassParent = TfrxCustomPrinter.ClassParent,
    Format('ClassParent of %s has changed, please check hack class %s',
    [TfrxCustomPrinter.ClassName, ClassName]));
  Assert(AClass.InheritsFrom(TfrxCustomPrinter),
    Format('%s does not inherit from %s, please check hack class %s',
    [AClass.ClassName, TfrxCustomPrinter.ClassName, ClassName]));
end;

{ TGsReportPrintOptions }

procedure TGsReportPrintOptions.Assign(Source: TPersistent);
begin
  inherited;

  if Source is TfrxPrintOptions then
    with TfrxPrintOptions(Source) do
    begin
      Self.Duplex := Duplex;
    end;
end;

procedure TGsReportPrintOptions.AssignTo(Dest: TPersistent);
begin
  if Dest is TfrxPrintOptions then
    with TfrxPrintOptions(Dest) do
    begin
      Dest.Assign(Self);
      Duplex := Self.Duplex;
    end
  else
    inherited;
end;

{ TGsPrinterOptions }

procedure TGsPrinterOptions.Assign(Source: TPersistent);
begin
  if (Source is TGsPrinterOptions) then
    with TGsPrinterOptions(Source) do
    begin
      Self.FBin  := FBin;
      Self.FDuplex := FDuplex;
      Self.FDefOrientation := FDefOrientation;
      Self.FDefPaper := FDefPaper;
      Self.FDefPaperHeight := FDefPaperHeight;
      Self.FDefPaperWidth := FDefPaperWidth;
      Self.FDefBin := FDefBin;
      Self.FDefDuplex := FDefDuplex;
      Self.FFileName := FFileName;
      Self.FName := FName;
      Self.FPaper := FPaper;
      Self.FPaperHeight := FPaperHeight;
      Self.FPaperWidth := FPaperWidth;
      Self.FLeftMargin := FLeftMargin;
      Self.FTopMargin := FTopMargin;
      Self.FRightMargin := FRightMargin;
      Self.FBottomMargin := FBottomMargin;
      Self.FOrientation := FOrientation;
      Self.FMode := FMode;
    end
  else
    inherited;
end;

procedure TGsPrinterOptions.AssignFromPrinter(Printer: TfrxPrinter);
begin
  with THackCustomPrinter(Printer) do
  begin
    Self.FBin  := FBin;
    Self.FDuplex := FDuplex;
    Self.FDefOrientation := FDefOrientation;
    Self.FDefPaper := FDefPaper;
    Self.FDefPaperHeight := FDefPaperHeight;
    Self.FDefPaperWidth := FDefPaperWidth;
    Self.FDefBin := FDefBin;
    Self.FDefDuplex := FDefDuplex;
    Self.FFileName := FFileName;
    Self.FName := FName;
    Self.FPaper := FPaper;
    Self.FPaperHeight := FPaperHeight;
    Self.FPaperWidth := FPaperWidth;
    Self.FLeftMargin := FLeftMargin;
    Self.FTopMargin := FTopMargin;
    Self.FRightMargin := FRightMargin;
    Self.FBottomMargin := FBottomMargin;
    Self.FOrientation := FOrientation;
    Self.FMode := FMode^;
  end;
end;

procedure TGsPrinterOptions.AssignToPrinter(Printer: TfrxPrinter);
begin
  with THackCustomPrinter(Printer) do
  begin
    FBin  := Self.FBin;
    FDuplex := Self.FDuplex;
    FDefOrientation := Self.FDefOrientation;
    FDefPaper := Self.FDefPaper;
    FDefPaperHeight := Self.FDefPaperHeight;
    FDefPaperWidth := Self.FDefPaperWidth;
    FDefBin := Self.FDefBin;
    FDefDuplex := Self.FDefDuplex;
    FFileName := Self.FFileName;
    FName := Self.FName;
    FPaper := Self.FPaper;
    FPaperHeight := Self.FPaperHeight;
    FPaperWidth := Self.FPaperWidth;
    FLeftMargin := Self.FLeftMargin;
    FTopMargin := Self.FTopMargin;
    FRightMargin := Self.FRightMargin;
    FBottomMargin := Self.FBottomMargin;
    FOrientation := Self.FOrientation;
    FMode^ := Self.FMode;
  end;
end;

{ TGsStatus }

procedure TGsStatus.Assign(Source: TPersistent);
begin
  if (Source is TGsStatus) then
  begin
    FReport.Assign(TGsStatus(Source).FReport);
    FPrinter.Assign(TGsStatus(Source).FPrinter);
  end
  else
    inherited;
end;

constructor TGsStatus.Create;
begin
  inherited;

  FReport  := TGsReportPrintOptions.Create;
  FPrinter := TGsPrinterOptions.Create;
end;

destructor TGsStatus.Destroy;
begin
  FPrinter.Free;
  FReport.Free;

  inherited;
end;

procedure TGsStatus.SetPrinter(const Value: TGsPrinterOptions);
begin
  FPrinter.Assign(Value);
end;

procedure TGsStatus.SetReport(const Value: TGsReportPrintOptions);
begin
  FReport.Assign(Value);
end;

{ TGsFrxProcessor }

constructor TGsFrxProcessor.Create;
begin
  inherited;

  FReportsStatus := TStringList.Create(True);
end;

destructor TGsFrxProcessor.Destroy;
begin
  FReportsStatus.Free;

  inherited;
end;

function TGsFrxProcessor.GetReportsStatus(Id: TGsReportId;
  Report: TfrxReport): TGsStatus;
var
  I: Integer;
begin
  I := FReportsStatus.IndexOf(Id);

  if (I = -1) then
  begin
    Result := TGsStatus.Create;
    Report.SelectPrinter;
    StatusBackupToOptions(Report, Result);
    FReportsStatus.AddObject(Id, Result);
  end
  else
    Result := TGsStatus(FReportsStatus.Objects[I]);
end;

procedure TGsFrxProcessor.OnPrintReport(Sender: TObject);
begin
  if Assigned(FSavedOnPrintReport) then
    FSavedOnPrintReport(Sender);

  StatusBackupToOptions(Sender as TfrxReport, FReportStatus);
  FDuplexActive := FReportStatus.FReport.Duplex in [dmVertical, dmHorizontal];
end;

procedure TGsFrxProcessor.ProcessReport(Id: TGsReportId; Report: TfrxReport;
  Options: TGsFrxProcessingOptions);
var
  SavedStatus: TGsStatus;
  SavedDuplex: TfrxDuplexMode;
begin
  FReportId := Id;
  FReport := Report;

  SavedStatus := TGsStatus.Create;

  try
    StatusBackupToOptions(Report, SavedStatus);

    try
      SavedDuplex := Report.PrintOptions.Duplex;

      try
        if not Report.PrepareReport(not (opPreserveLastReport in Options)) then
          raise EGsFrxProcessorError.CreateResFmt(@SErrorPrepareReport,
            [Report.Errors.Text]);
      finally
        Report.PrintOptions.Duplex := SavedDuplex;
      end;

      if (opPrepareOnly in Options) then
        Exit;

      // Load the last report status or create a new one
      if (opKeepStatus in Options) then
        FReportStatus := TGsStatus.Create
      else
      begin
        FReportStatus := GetReportsStatus(Id, Report);
        StatusRestoreFromOptions(Report, FReportStatus);
      end;

      try
        // Apply dialog option
        if not (opKeepPrintDialog in Options) then
          Report.PrintOptions.ShowDialog := (opPrintDialog in Options);

        // Show or print the report
        FSavedOnPrintReport := Report.OnPrintReport;

        try
          Report.OnPrintReport := OnPrintReport;

          if (opPreview in Options) then
            Report.ShowPreparedReport
          else
            Report.Print;
        finally
          Report.OnPrintReport := FSavedOnPrintReport;
        end;
      finally
        if (opKeepStatus in Options) then
          FReportsStatus.Free
        else
          FReportStatus := nil;
      end;
    finally
      StatusRestoreFromOptions(Report, SavedStatus);
    end;
  finally
    FReportId := '';
    FReport := nil;
    FSavedOnPrintReport := nil;
    FDuplexActive := False;
    SavedStatus.Free;
  end;
end;

procedure TGsFrxProcessor.StatusBackupToOptions(Report: TfrxReport; Status: TGsStatus);
begin
  Status.FReport.Assign(Report.PrintOptions);
  Status.FPrinter.AssignFromPrinter(frxPrinters.Printer as TfrxPrinter);
end;

procedure TGsFrxProcessor.StatusRestoreFromOptions(Report: TfrxReport;
  Status: TGsStatus);
begin
  frxPrinters.PrinterIndex := frxPrinters.IndexOf(Status.Printer.Name);

  Status.FReport.AssignTo(Report.PrintOptions);
  Status.FPrinter.AssignToPrinter(frxPrinters.Printer as TfrxPrinter);
end;

initialization
  try
    THackCustomPrinter.CheckHack(TfrxPrinter);
  except
    on E: Exception do
      Application.MessageBox(PChar(E.Message), 'Error');
  end;

finalization
  if LReportProcessor <> nil then
    LReportProcessor.Free;
end.

