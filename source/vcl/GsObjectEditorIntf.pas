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
unit GsObjectEditorIntf;

{$I Gilbertsoft.inc}

interface

uses
  Controls, TypInfo, BPTypInfo, Classes;

type
  TGsObjectEditorPropertyEditClass = TWinControlClass;

  { object editor support interface }
  IGSObjectEditorObjectSupport = interface(IInterface)
    ['{7B62F657-4002-416B-8E1D-0FD15B178494}']
    function GetClassName: ShortString;
    function GetName: TSymbolName;
    function GetInfo: PTypeInfo;
    function GetCaption: TCaption;
    function GetEnabled: Boolean;
    function GetHint: String;
    function GetVisible: Boolean;
    procedure SetName(const Value: TSymbolName);
    procedure SetCaption(const Value: TCaption);
    procedure SetEnabled(const Value: Boolean);
    procedure SetHint(const Value: String);
    procedure SetVisible(const Value: Boolean);

    property ClassName: ShortString read GetClassName;
    property Name: TSymbolName read GetName write SetName;
    property Info: PTypeInfo read GetInfo;
    property Caption: TCaption read GetCaption write SetCaption;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Hint: String read GetHint write SetHint;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  IGSObjectEditorObjectPropertySupport = interface(IInterface)
    ['{DE6EE545-2F76-4F16-952B-71016A57E6B7}']

    function IsNative: Boolean;
(*
    property Name: TSymbolName read GetName;
    property Info: PPropInfo read GetInfo;
    property Caption: TCaption read GetCaption;
    property EditClass: TGSObjectEditorPropertyEditClass read GetEditClass;
    property Enabled: Boolean read GetEnabled;
    property Hint: String read GetHint;
    property Visible: Boolean read GetVisible;
    property Text: String read GetEditText write SetEditText;
    property Value: Variant read GetAsVariant write SetAsVariant;
//    property AsBCD: TBcd read GetAsBCD write SetAsBCD;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsCurrency: Currency read GetAsCurrency write SetAsCurrency;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
//    property AsSQLTimeStamp: TSQLTimeStamp read GetAsSQLTimeStamp write SetAsSQLTimeStamp;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsInteger: Longint read GetAsInteger write SetAsInteger;
    property AsString: String read GetAsString write SetAsString;
    property AsVariant: Variant read GetAsVariant write SetAsVariant;
    *)
  end;

  IGSObjectEditorObjectPropertiesSupport = interface(IInterface)
    ['{DA3D6AFD-96FF-4A04-8792-866BBD9C500F}']
    (*
    property Items[Index: Integer]: IGSObjectEditorObjectPropertySupport read GetItem;
    property Names[Name: TSymbolName]: IGSObjectEditorObjectPropertySupport read GetName;
    *)
  end;

  IGSObjectEditorSupport = interface(IInterface)
    ['{59486CB2-EEA0-4D53-9388-699F59DA0EB5}']
    function GetOEObjectName: String;
    function GetOEObjectInfo: PTypeInfo;
    function GetOEObjectCaption: String;
    function GetOEObjectEnabled: Boolean;
    function GetOEObjectHint: String;
    function GetOEObjectVisible: Boolean;
    function GetOEPropertyCount: Integer;
    function GetOEPropertyName(Index: Integer): TSymbolName;
    function GetOEPropertyInfo(Index: Integer): PPropInfo;
    function GetOEPropertyCaption(Index: Integer): String;
    function GetOEPropertyEditClass(Index: Integer): TGSObjectEditorPropertyEditClass;
    function GetOEPropertyEnabled(Index: Integer): Boolean;
    function GetOEPropertyHint(Index: Integer): String;
    function GetOEPropertyValue(Index: Integer): String;
    function GetOEPropertyVisible(Index: Integer): Boolean;
    procedure SetOEPropertyValue(Index: Integer; const Value: String);

    function Clone: TPersistent;

    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: String);
    procedure SaveToStream(Stream: TStream);

    procedure LoadDefsFromFile(const FileName: String);
    procedure LoadDefsFromStream(Stream: TStream);
    procedure SaveDefsToFile(const FileName: String);
    procedure SaveDefsToStream(Stream: TStream);

    { object properties }
    property OEObjectName: String read GetOEObjectName;
    property OEObjectInfo: PTypeInfo read GetOEObjectInfo;
    property OEObjectCaption: String read GetOEObjectCaption;
    property OEObjectEnabled: Boolean read GetOEObjectEnabled;
    property OEObjectHint: String read GetOEObjectHint;
    property OEObjectVisible: Boolean read GetOEObjectVisible;

    { property support properties }
    function OEPropertyIndexOfName(const AName: String): Integer;

    property OEPropertyCount: Integer read GetOEPropertyCount;
    property OEPropertyName[Index: Integer]: TSymbolName read GetOEPropertyName;
    property OEPropertyInfo[Index: Integer]: PPropInfo read GetOEPropertyInfo;
    property OEPropertyCaption[Index: Integer]: String read GetOEPropertyCaption;
    property OEPropertyEditClass[Index: Integer]: TGSObjectEditorPropertyEditClass read GetOEPropertyEditClass;
    property OEPropertyEnabled[Index: Integer]: Boolean read GetOEPropertyEnabled;
    property OEPropertyHint[Index: Integer]: String read GetOEPropertyHint;
    property OEPropertyValue[Index: Integer]: String read GetOEPropertyValue write SetOEPropertyValue;
    property OEPropertyVisible[Index: Integer]: Boolean read GetOEPropertyVisible;

    //function EditIntf_IsPropertySimple (const PropertyName : String) : Boolean;
  end;

  IGSObjectEditorStreamingSupport = interface(IInterface)
    ['{CC7F9D1C-D602-4124-9CD9-D65C720CCC4C}']
  end;

  IGSObjectEditorDefinitionsStreamingSupport = interface(IInterface)
    ['{7719408F-A49C-4836-A7AE-EF3570AD6F51}']
  end;

implementation

end.
 