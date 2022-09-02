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
unit GsSplit;

{$I Brupel.inc}
{.$DEFINE OwnPane}

interface

uses
  RzSplit, Classes, Controls;

type
  TGsPaneData = class(TRzPaneData)
  private
  protected
//    procedure UpdateProps(const AName: String; );
    function GetName: TComponentName; virtual;
  public
    constructor Create(ASplitterPane: TRzSplitterPane); reintroduce; virtual;
  published
    property Name: TComponentName read GetName;
  end;

  TGsSplitter = class(TRzSplitter)
  private
{$IFDEF OwnPane}
    FPaneData: array [1..2] of TBPPaneData;
{$ENDIF}
  protected
    { TComponent }
    procedure SetName(const NewName: TComponentName); override;

    { TRzSplitter }
{$IFDEF OwnPane}
    function GetPaneData(Index: Integer): TRzPaneData; override;
    procedure SetPaneData(Index: Integer; Value: TRzPaneData); override;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  BPConsts;

type
  TPaneDataWritable = class(TPersistent)
  private
    FPane: TRzSplitterPane;
  public
    { Property Declarations }
    property Pane: TRzSplitterPane
      read FPane write FPane;
  end;

{ TGsPaneData }

constructor TGsPaneData.Create(ASplitterPane: TRzSplitterPane);
begin
  inherited Create;

  TPaneDataWritable(Self).Pane := ASplitterPane;
end;

function TGsPaneData.GetName: TComponentName;
resourcestring
  SPaneDataSuffix = 'Data';
begin
  Result := Pane.Name + SPaneDataSuffix;
end;

{ TGsSplitter }

constructor TGsSplitter.Create(AOwner: TComponent);
begin
  inherited;

{$IFDEF OwnPane}
  FPaneData[1] := TGsPaneData.Create(inherited GetPaneData(1).Pane);
  FPaneData[2] := TGsPaneData.Create(inherited GetPaneData(2).Pane);

//  UpperLeft.Pane.Name := 'UpperLeft';
//  LowerRight.Pane.Name := 'LowerRight';
{$ENDIF}

(*
procedure TForm1.ChangeSplitterPanes(Splitter: TRzSplitter);
var
  I: Integer;
  ULSet: Boolean;
begin
  ULSet := False;

  for I := 0 to Splitter.ComponentCount - 1 do
  begin
    if (Splitter.Components[I] is TRzSplitterPane) then
    begin
      if not ULSet then
      begin
        TRzSplitterPane(Splitter.Components[I]).Name := Splitter.Name + 'UpperLeft';
        ULSet := True;
      end
      else
      begin
        TRzSplitterPane(Splitter.Components[I]).Name := Splitter.Name + 'LowerRight';
        Break;
      end;
    end;
  end;
end;
*)
end;

destructor TGsSplitter.Destroy;
{$IFDEF OwnPane}
var
  I: Integer;
{$ENDIF}
begin
{$IFDEF OwnPane}
  for I := 1 to 2 do
    FPaneData[ I ].Free;
{$ENDIF}

  inherited;
end;

{$IFDEF OwnPane}
function TGsSplitter.GetPaneData(Index: Integer): TRzPaneData;
begin
  Result := FPaneData[Index];
end;
{$ENDIF}

procedure TGsSplitter.SetName(const NewName: TComponentName);
resourcestring
  SUpperLeft = 'UpperLeft';
  SLowerRight = 'LowerRight';
begin
  inherited;

  UpperLeft.Pane.Name := Name + SUpperLeft;
  LowerRight.Pane.Name := Name + SLowerRight;
end;

{$IFDEF OwnPane}
procedure TGsSplitter.SetPaneData(Index: Integer; Value: TRzPaneData);
begin
  FPaneData[Index].Assign(Value);
end;
{$ENDIF}

end.

