unit PluTony_Python_Classes;
(*
  This legacy code is a complation of several old units
  Copyright (c) 2022  Antonio Alcázar Ruiz
  PluTony : Jupyter Pascal extensions.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  -------------------------------------------------------------------------------

  This unit uses python4delphi  lib from pyscripter
  https://github.com/pyscripter/python4delphi

*)

interface

{$I plutonidef.inc}

// implementation end.
uses
  System.Rtti,
{$IFDEF COMPACMODE}
  Monadas_Pascal,
{$ELSE}
  TodoString,
  Monada_File,
  ToDo_SearchRc,
  Monada_Reader,
  Todo_Search_Factory,
  todo_exe,
  Todo_IScript,
  Monada_Directory,
  Monada_Abstract,
{$ENDIF}
  WrapDelphiClasses,
  sysutils,
  classes,

  WrapDelphi,
  PythonEngine;

type
  TTipoObjeto = (Tonone, Todisk, Todir, ToFile, ToObject, Toindef);

  StringPy = String;

  TPlyDelphiWrapper = class(TPyDelphiWrapper)
  protected
    iniciado: boolean;
    procedure CreateWrappers; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure TestCreateWrappers;
  end;

  TTypePythonDef = record
    TipoClase_: TPythonType;
    TipoIterator: TPythonType;

    procedure Init(const na: String = ''; const Clase: TPyObjectClass = nil;
      const Iterator: TPyObjectClass = nil);
    function TestIterator: TPythonType;
    function CreateTipo(args: PPyObject): PPyObject;

    procedure SetEngine(const val: TPythonEngine = nil);
    function IteratorClass(const module: TPythonModule): TPythonType;

  private
    ClaseBase: TPyObjectClass;
    ClaseIterator: TPyObjectClass;
    tipName: String;
  end;

  TPyMitClase = class(TPyObject)
  private
    function SqLength: NativeInt; override;
    function GetAttr(key: PAnsiChar): PPyObject; override;
  end;

  TPyMitIterator = class(TPyObject)
    fCurrentIndex_: Integer;
    constructor Create(APythonType: TPythonType); override;
    destructor Destroy; override;
    function Iter: PPyObject; override;
    // Exposed methods
    function next(args: PPyObject): PPyObject; cdecl;
    // Class methods
    class procedure RegisterMethods(PythonType: TPythonType); override;
  end;

procedure TipicalType(const pyty: TPythonType);
function PlutonyClaseIterator(const Wrapper: TPyDelphiWrapper;
  const na: String = ''; const Clase: TPyObjectClass = nil;
  const Iterator: TPyObjectClass = nil): TTypePythonDef;

function TestIteratorClase(const module: TPythonModule;
  const ClaseIte: TPyObjectClass; const tipName: String): TPythonType;

type

  TPythonPlutonyModule = class(TPythonModule)
  public
    constructor Create(AOwner: TComponent); override;
    procedure Initialize; override;
  end;

  TPlutonyTypes = record
    selfEngine: boolean;
    gXMLModule_: TPythonModule;
    gXmlWrap__: TPlyDelphiWrapper;
    procedure TypeRecord_(const nava: string; Address: Pointer;
      Typ: TRttiStructuredType);
    function InitdatabasePly_(pio: TPythonInputOutput = nil): TPythonEngine;
    function PyInit_PluTony_dll_: PPyObject;
    procedure ExecutePython(const strings: string);
    procedure runPythonSample(const fI: TMonaFile;
      const io: TPythonInputOutput);
    function runPythonCode(const code: String;
      const io: TPythonInputOutput): boolean;

    procedure initdatabase_(const e: TPythonEngine);
    procedure Init;
    procedure Done;
    function CreateOutPut_(const event: TSendDataEvent): TPythonInputOutput;

  private

    procedure initDll;

  private

    gEngine_: TPythonEngine;

    function NewEngine_: TPythonEngine;

    procedure SetEngine(const val: TPythonEngine = nil);

    procedure CreateComponents_(AOwner: TComponent;
      const val: TPythonEngine = nil);

    procedure initModulePlutony(const e: TPythonEngine);
  public
    property Engine: TPythonEngine read gEngine_;

  end;

  TParsedPython = record
    Param: String;
    OkParsed: boolean;
    Procedure Init;

  end;

type
  TPythonEngineHelper = class helper for TPythonEngine
    procedure ExecxStrings__(strings: TxStringList);
    procedure ExecutePython(const strings: string);
  end;

var
  PluTony_: TPlutonyTypes;

function ParseString_(const masc: PAnsiChar; args: PPyObject): TParsedPython;

type
  {
    PyObject wrapping TControl
    Exposes methods Show, Hide, BringToFront, SendToBack, Update, SetBounds
    Exposes property Parent
  }
  TPyXStringList = class(TPyDelphiPersistent) // TPyDelphiPersistent)

  private
    function GetDelphiObject_: TxStringList;

    procedure SetDelphiObject(const Value: TxStringList);

  protected
    // function TestIterator_: TPythonType;

    function Get_Objects(AContext: Pointer): PPyObject; cdecl;

    function AddObject_Wrapper(args: PPyObject): PPyObject; cdecl;
    function Add_Wrapper(args: PPyObject): PPyObject; cdecl;
    function Clear_Wrapper(args: PPyObject): PPyObject; cdecl;
    function Delete_Wrapper(args: PPyObject): PPyObject; cdecl;
    function IndexOf_Wrapper(args: PPyObject): PPyObject; cdecl;
    function BeginUpdate_Wrapper(args: PPyObject): PPyObject; cdecl;
    function EndUpdate_Wrapper(args: PPyObject): PPyObject; cdecl;
    function LoadFromFile_Wrapper(args: PPyObject): PPyObject; cdecl;
    function SaveToFile_Wrapper(args: PPyObject): PPyObject; cdecl;
    function Get_Capacity(AContext: Pointer): PPyObject; cdecl;
    function Get_Text(AContext: Pointer): PPyObject; cdecl;
    function Set_Capacity(AValue: PPyObject; AContext: Pointer): Integer; cdecl;
    function Set_Text(AValue: PPyObject; AContext: Pointer): Integer; cdecl;
    // Virtual Methods
    function Assign(ASource: PPyObject): PPyObject; override;

  public

    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;
    destructor Destroy; override;
    class function GetContainerAccessClass: TContainerAccessClass; override;

    class procedure SetupType(PythonType: TPythonType); override;
    class procedure RegisterGetSets(PythonType: TPythonType); override;
    class procedure RegisterMethods(PythonType: TPythonType); override;
    function Repr: PPyObject; override;
    // Class methods

    // Mapping services
    function MpLength: NativeInt; override;
    function MpSubscript(obj: PPyObject): PPyObject; override;

    function add(args: PPyObject): PPyObject; cdecl;
    // Basic services
    function Iter: PPyObject; override;

    class function DelphiObjectClass: TClass; override;
    // Properties
    property strings: TxStringList read GetDelphiObject_;
    property DelphiObject_: TxStringList read GetDelphiObject_
      write SetDelphiObject;

    // write SetDelphiObject;
  end;

  {
    Access to the child controls of a TWinControl.Controls collection.
  }
  TpluxStringListAccess = class(TContainerAccess)
  private
    function GetContainer: TxStringList;
  public
    function GetItem(AIndex: Integer): PPyObject; override;
    function GetSize: Integer; override;
    // function IndexOf(avalue: PPyObject): integer; override;
    function SetItem(AIndex: Integer; AValue: PPyObject): boolean; override;

    class function ExpectedContainerClass: TClass; override;
    class function SupportsIndexOf: boolean; override;
    class function Name: string; override;

    property Container_: TxStringList read GetContainer;

  end;

type

  TPyMonaFile = class(TPyMitClase)
  public
    class var TipoFile: TTypePythonDef;
  private
    procedure SetStrings(const Value: StringPy);
    function GetString: StringPy;
  public
    MonoFile: TMonaFile;

    // Constructors & Destructors
    constructor Create(APythonType: TPythonType); override;
    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;
    destructor Destroy; override;
    function TestIterator_: TPythonType;

    // Basic services
    function Iter: PPyObject; override;
    // Basic services
    function GetAttr(key: PAnsiChar): PPyObject; override;
    function SetAttr(key: PAnsiChar; Value: PPyObject): Integer; override;
    function Repr: PPyObject; override;

    // Class methods
    class procedure RegisterMethods(PythonType: TPythonType); override;
    class procedure RegisterMembers(PythonType: TPythonType); override;
    class procedure RegisterGetSets(PythonType: TPythonType); override;
    class function CreatePyFile(const root: String): PPyObject;

    // properties
    property Strings_: StringPy read GetString write SetStrings;
  end;

  TPyMonaFileIterator = class(TPyMitIterator)
  private
    ffichero: TPyMonaFile;
    reader: TAnsiReaderEnumerator;

    procedure SetStringList(const Value: TPyMonaFile);
  public
    constructor Create(APythonType: TPythonType); override;
    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;
    destructor Destroy; override;

    function IterNext: PPyObject; override;

    // Class methods
    class procedure RegisterMethods(PythonType: TPythonType); override;

    // properties
    property StringList_: TPyMonaFile read ffichero write SetStringList;

  end;

type

  TPyDirectory = class(TPyMitClase)
  public
    class var TipoDirectory: TTypePythonDef;

  public
    MonoDir: TMonaDirectory;
    scope: String;
    mascara: String;

    // Constructors & Destructors
    constructor Create(APythonType: TPythonType); override;
    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;
    destructor Destroy; override;
    function TestIterator__: TPythonType;
    function Childir(): PPyObject; // override;
    function NbTrueDivide(obj: PPyObject): PPyObject; override;
    function NbFloorDivide(obj: PPyObject): PPyObject; override;
    class function CreatePyDirectory(root: UnicodeString): PPyObject;

    function GetAttrO(key: PPyObject): PPyObject; override;
    function SetAttrO(key, Value: PPyObject): Integer; override;

    // Basic services
    function Iter: PPyObject; override;
    // Basic services
    function GetAttr(key: PAnsiChar): PPyObject; override;
    function SetAttr(key: PAnsiChar; Value: PPyObject): Integer; override;
    function Repr: PPyObject; override;
    function RichCompare(obj: PPyObject; Op: TRichComparisonOpcode)
      : PPyObject; override;
    // function __truediv__(args: PPyObject): PPyObject;override;

    // Class methods
    class procedure RegisterMethods(PythonType: TPythonType); override;
    class procedure RegisterMembers(PythonType: TPythonType); override;
    class procedure RegisterGetSets(PythonType: TPythonType); override;

  end;

  TPyDirectoryIterator = class(TPyMitIterator)
  private
    directory_: TPyDirectory;

    data_: TSearchData;
    search_: TBaseSearchEnumerator;

    procedure SetStringList(const Value: TPyDirectory);
  public
    constructor Create(APythonType: TPythonType); override;
    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;
    destructor Destroy; override;

    // Basic services
    // function Iter: PPyObject; override;
    function IterNext: PPyObject; override;

    // Class methods
    class procedure RegisterMethods(PythonType: TPythonType); override;

    property DirPy: TPyDirectory read directory_ write SetStringList;

  end;

Type
  TPythonIOResult = class(TPythonInputOutput)
  public
    resulta: TTypeRuntimeResult;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SendResult_(Sender: TObject; const Data: AnsiString);

  end;

  TScriptPython = class(TScriptAbstract)
    constructor Create(const obj: TObject = nil); reintroduce; overload;
    destructor Destroy; override;
    function Runs(const req: TScriptRequest): TScriptResponse; override;

  public
    Script: String;

  end;

  TPlutonyTypesHelper = record helper for TPlutonyTypes

    function CreateOutPutS(): TPythonIOResult;

    function runPythonCodeResult(const code: String): string;
  end;

{$M+}

  TTestScriptsPython = record

    procedure Init;
    class function ExecDWS(s: string): string; static;

  end;
  // {$M-}

function InjectScriptPython(): IScript;

type

  TPluTonyRegistrationSys = class(TRegisteredUnit)
  public
    function Name: string; override;
    procedure RegisterWrappers(APyDelphiWrapper: TPyDelphiWrapper); override;
    procedure DefineVars(APyDelphiWrapper: TPyDelphiWrapper); override;
    procedure DefineFunctions(APyDelphiWrapper: TPyDelphiWrapper); override;
    function GetFile(pself, args: PPyObject): PPyObject; cdecl;
    function GetDirectory(pself, args: PPyObject): PPyObject; cdecl;

  end;

implementation

uses PluTony_Runtime_App;

procedure TTypePythonDef.SetEngine(const val: TPythonEngine = nil);
begin


  if TipoClase_ <> nil then
  begin
    TipoClase_.Engine := val;
  end;
  if TipoIterator <> nil then
  begin
    TipoIterator.Engine := val;
  end;

end;

procedure TipicalType(const pyty: TPythonType);
begin
  with pyty do
  begin
    // TypeName := nameType;
    Services.Basic := [bsRepr, bsStr, bsGetAttrO, bsSetAttrO, bsIter];
    Services.Sequence := [ssLength, ssItem, ssAssItem];
    Services.Number := [nsFloorDivide, nsAdd, nsTrueDivide];

    TypeFlags := [tpfBaseType, tpHaveVersionTag];
  end;
end;

function PlutonyClaseIterator(const Wrapper: TPyDelphiWrapper;
  const na: String = ''; const Clase: TPyObjectClass = nil;
  const Iterator: TPyObjectClass = nil): TTypePythonDef;
begin
  Result.Init(na, Clase, Iterator);
  Result.TipoClase_ := Wrapper.RegisterHelperType(Clase);
  TipicalType(Result.TipoClase_);

end;

function TTypePythonDef.CreateTipo(args: PPyObject): PPyObject;
begin
  Result := nil;
  // CheckEngine;
  if TipoClase_ <> nil then
  begin
    Result := TipoClase_.CreateInstanceWith(args)
  end;
end;

function TTypePythonDef.TestIterator: TPythonType;
begin
  Result := Nil;
  if (TipoIterator = nil) then
    if TipoClase_ <> nil then

    begin

      TipoIterator := TestIteratorClase(TipoClase_.module, ClaseIterator,
        tipName + 'Iterator');

    end;
  Result := TipoIterator
end;

// clase:TPyObjectClass; const tipName:String
procedure TTypePythonDef.Init(const na: String = '';
  const Clase: TPyObjectClass = nil; const Iterator: TPyObjectClass = nil);
begin
  TipoClase_ := nil;
  TipoIterator := nil;
  ClaseBase := Clase;
  ClaseIterator := Iterator;
  tipName := na;
end;

function TestIteratorClase(const module: TPythonModule;
  const ClaseIte: TPyObjectClass; const tipName: String): TPythonType;
var
  TipoIterator: TPythonType;
  Engin: TPythonEngine;
begin
  Result := Nil;
  TipoIterator := nil;
  if module <> nil then
    if ClaseIte <> nil then
      if (TipoIterator = nil) then
      begin
        Engin := module.Engine;
        TipoIterator := TPythonType.Create(Engin); // PythonType.Owner);
        TipoIterator.Name := tipName + 'Name';
        TipoIterator.TypeName := tipName;
        TipoIterator.Services.Basic := TipoIterator.Services.Basic +
          [bsIter, bsIterNext];
        TipoIterator.module := module;
        TipoIterator.Engine := Engin;
        TipoIterator.PyObjectClass := ClaseIte;
        TipoIterator.Initialize;
        Result := TipoIterator;

        // TipoPyFileIterator := TipoIterator;

      end;
  Result := TipoIterator;
end;

function TTypePythonDef.IteratorClass(const module: TPythonModule): TPythonType;
begin
  Result := Nil;
  if ClaseIterator <> nil then
    if (TipoIterator = nil) then
    begin
      TipoIterator := TestIteratorClase(module, ClaseIterator,
        tipName + 'Iterator');

    end;
  Result := TipoIterator;
end;

function TPyMitClase.SqLength: NativeInt;
begin
  Result := 1 // Strings.Count_;
end;

function TPyMitClase.GetAttr(key: PAnsiChar): PPyObject;
begin
  with GetPythonEngine do
  begin
    (* if key = 'root' then
      result := VariantAsPyObject(MonoFile.FileName)
      // Or  Result := PyLong_FromLong( x )

      else *)
    Result := inherited GetAttr(key);
  end;
end;

{ TPyMonaFileIterator }

constructor TPyMitIterator.Create(APythonType: TPythonType);
begin
  inherited;
  fCurrentIndex_ := -1;
end;

destructor TPyMitIterator.Destroy;
begin
  inherited;
end;

function TPyMitIterator.Iter: PPyObject;
begin
  Result := Self.GetSelf;
  GetPythonEngine.Py_INCREF(Result);
end;

function TPyMitIterator.next(args: PPyObject): PPyObject;
begin
  with GetPythonEngine do
  begin
    // We adjust the transmitted self argument
    Adjust(@Self);
    Result := Self.IterNext;
    if not Assigned(Result) and (PyErr_Occurred = nil) then
      PyErr_SetString(PyExc_StopIteration^, 'Stop iteration');
  end;
end;

class procedure TPyMitIterator.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  with PythonType do
  begin
    AddMethod('next', @TPyMitIterator.next,
      'Returns the next value from the iterable container');
  end;
end;

procedure TPlyDelphiWrapper.CreateWrappers;
begin
  if iniciado then
  begin
    inherited CreateWrappers;
  end;

end;

procedure TPlyDelphiWrapper.TestCreateWrappers;
begin
  iniciado := True;
  CreateWrappers;
end;

constructor TPlyDelphiWrapper.Create(AOwner: TComponent);
begin
  iniciado := False;
  inherited Create(AOwner);
  iniciado := True;
end;

constructor TPythonPlutonyModule.Create(AOwner: TComponent);
begin
  inherited;
  ModuleName := 'XML';
  ModuleName := 'PluTony';

  Name := 'modXML';
  with DocString do
  begin
    add('This module contains several Object Types that');
    add('will let you work with the XML.');
    add('');
  end;
  with Errors.add do
    Name := 'XMLError';
end;

procedure TPythonPlutonyModule.Initialize;
begin
  inherited;

end;

procedure TPlutonyTypes.initDll;
begin
  if not gEngine_.IsHandleValid then
  begin
    gEngine_.LoadDll;
  end;
end;

procedure TPlutonyTypes.Done;
begin
  // FreeNil(gModule____); // .Free;
  if selfEngine then
  begin
    Freenil(gEngine_);
  end;
  gEngine_ := Nil; // ?

end;

procedure TPlutonyTypes.Init;
begin
  gEngine_ := Nil;

  gXMLModule_ := nil;
  gXmlWrap__ := nil;
  selfEngine := False;
  // Rec_.Init;
end;

procedure TPlutonyTypes.SetEngine(const val: TPythonEngine = nil);
begin
  if val <> nil then
  begin
    gXmlWrap__.Engine := val;
    gXMLModule_.Engine := val;

  end;

end;

procedure TPlutonyTypes.CreateComponents_(AOwner: TComponent;
  const val: TPythonEngine = nil);

begin
  if Assigned(gXMLModule_) then
    Exit;
  gXMLModule_ := TPythonPlutonyModule.Create(AOwner);
  gXmlWrap__ := TPlyDelphiWrapper.Create(AOwner);
  gXmlWrap__.Engine := val;
  gXmlWrap__.module := gXMLModule_;
  gXmlWrap__.TestCreateWrappers;

  if val <> nil then
  begin
    SetEngine(val)
    // gXmlType.Engine:=val;

  end;

end;

procedure TPlutonyTypes.initModulePlutony(const e: TPythonEngine);
begin
  try
    CreateComponents_(e, e);
    e.LoadDll;

  except
  end;
end;

function TPlutonyTypes.NewEngine_: TPythonEngine;
begin
  Result := nil;
  try
    Result := TPythonEngine.Create(nil);
    Result.AutoFinalize := False;
    Result.UseLastKnownVersion := True;
    Result.RegVersion := '3.10';
    // <-- Use the same version as the python 3.x your main program uses
    Result.APIVersion := 1013;
    Result.DllName := 'python310.dll';

    // Result.RegVersion := '3.8';
    // gEngine.RegVersion := '3.10';

    // <-- Use the same version as the python 3.x your main program uses
    Result.APIVersion := 1013;
    // Result.DllName := 'python38.dll';
    // gEngine.DllName := 'python310.dll';
    // Result := gEngine
  except
    Result := nil;

  end;
end;

procedure TPlutonyTypes.ExecutePython(const strings: string);
begin
  Engine.Py_XDecRef(Engine.Run_CommandAsObject(Engine.EncodeString(strings),
    file_input));
end;

procedure TPlutonyTypes.initdatabase_(const e: TPythonEngine);
begin
  try
    gEngine_ := e;
    if e = nil then
    begin
      selfEngine := True;
      gEngine_ := GetPythonEngine;
      gEngine_ := NewEngine_;
    end;
    initModulePlutony(gEngine_);
  except
  end;
end;

function TPlutonyTypes.InitdatabasePly_(pio: TPythonInputOutput = nil)
  : TPythonEngine;
begin
  Result := nil;
  try
    // gEngine := GetPythonEngine;
    if gEngine_ = nil then
    begin
      gEngine_ := NewEngine_;
      if Assigned(pio) then
      begin
        gEngine_.io := pio;
        gEngine_.RedirectIO := True;
      end;
      initModulePlutony(gEngine_);

    end;
    Result := gEngine_;
  except
  end;
end;

function TPlutonyTypes.runPythonCode(const code: String;
  const io: TPythonInputOutput): boolean;
var
  en_: TPythonEngine;
begin
  Result := True;
  en_ := PluTony_.InitdatabasePly_(io); // PythonGUIInputOutput1);
  if not PythonOK then
  begin
    WriteLn('no ok')
  end
  else
  begin
    en_.ExecutePython(code)
    // AsStringList.strings);
  end;
end;

procedure TPlutonyTypes.runPythonSample(const fI: TMonaFile;
  const io: TPythonInputOutput);
var
  en_: TPythonEngine;
begin
  en_ := PluTony_.InitdatabasePly_(io); // PythonGUIInputOutput1);
  if not PythonOK then
  begin
    WriteLn('no ok')
  end
  else
  begin
    en_.ExecutePython(fI.FileContent())
    // AsStringList.strings);
  end;

end;

function TPlutonyTypes.PyInit_PluTony_dll_: PPyObject;
begin

  try
    InitdatabasePly_;
    // NewEngine_;

    // initModulePlutony__(gEngine);
    Result := gXMLModule_.module;
    // ShowMessage('init database');
  except
    Result := nil;
  end;
end;

procedure TPythonEngineHelper.ExecxStrings__(strings: TxStringList);
begin
  Py_XDecRef(Run_CommandAsObject(EncodeString(strings.Text), file_input));
end;

procedure TPythonEngineHelper.ExecutePython(const strings: string);
begin
  Py_XDecRef(Run_CommandAsObject(EncodeString(strings), file_input));
end;

function ParseString_(const masc: PAnsiChar; args: PPyObject): TParsedPython;
var
  fina: PAnsiChar;
begin
  Result.Init;
  try
    with GetPythonEngine do
    begin
      if PyArg_ParseTuple(args, masc, @fina) <> 0 then
      begin
        Result.Param := fina;
        Result.OkParsed := True
      end;
    end;
  finally

  end;
end;

{ TParsedPython }

procedure TParsedPython.Init;
begin
  OkParsed := False;
  Param := '';
end;

procedure TPlutonyTypes.TypeRecord_(const nava: string; Address: Pointer;
  Typ: TRttiStructuredType);
var
  py: PPyObject;
begin
  py := gXmlWrap__.WrapRecord(Address, Typ);
  gXMLModule_.SetVar(nava, py);
  gXmlWrap__.Engine.Py_DECREF(py);
end;

function TPlutonyTypes.CreateOutPut_(const event: TSendDataEvent)
  : TPythonInputOutput;
begin
  Result := TPythonInputOutput.Create(nil);
  Result.OnSendData := event;
end;

{ TPluTonyRegistrationSys }

function TPluTonyRegistrationSys.GetDirectory(pself, args: PPyObject)
  : PPyObject; cdecl;
var
  fina: PAnsiChar;
begin
  // FreeConsole;

  Result := nil;
  // CheckEngine;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:GetDirectory', @fina) <> 0 then
    begin
      try
        Result := TPyDirectory.CreatePyDirectory(fina);
        // Adjust(pself);

      finally

      end;
    end;
    // Result := GetPythonEngine.ReturnNone;
  end;

end;

function TPluTonyRegistrationSys.GetFile(pself, args: PPyObject)
  : PPyObject; cdecl;
var
  fina: PAnsiChar;
  // x: TXml;
begin
  // FreeConsole;

  Result := nil;
  // CheckEngine;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:GetFile', @fina) <> 0 then
    begin
      try
        Result := TPyMonaFile.CreatePyFile(fina);
      finally

      end;
    end;
    // Result := GetPythonEngine.ReturnNone;
  end;

end;

procedure TPluTonyRegistrationSys.DefineVars(APyDelphiWrapper
  : TPyDelphiWrapper);
begin
  inherited;
  PluTony_.TypeRecord_('Exe', @ExeVer,
    TRttiContext.Create.GetType(TypeInfo(TExe)) as TRttiStructuredType);

  PluTony_.TypeRecord_('rtti_app', @RunAppExample,
    TRttiContext.Create.GetType(TypeInfo(TPlyAppExample))
    as TRttiStructuredType);

  // TModalResult values
  (* APyDelphiWrapper.DefineVar('mrNone', mrNone);
    APyDelphiWrapper.DefineVar('mrOk', mrOk);
    APyDelphiWrapper.DefineVar('mrIgnore', mrIgnore);
    APyDelphiWrapper.DefineVar('mrYes', mrYes);
    APyDelphiWrapper.DefineVar('mrNo', mrNo);
    APyDelphiWrapper.DefineVar('mrAll', mrAll);
    APyDelphiWrapper.DefineVar('mrNoToAll', mrNoToAll);
    APyDelphiWrapper.DefineVar('mrYesToAll', mrYesToAll);
  *)
end;

function TPluTonyRegistrationSys.Name: string;
begin
  Result := 'pluton';
end;

procedure TPluTonyRegistrationSys.DefineFunctions(APyDelphiWrapper
  : TPyDelphiWrapper);
begin
  APyDelphiWrapper.RegisterFunction(PAnsiChar('Directory'), GetDirectory,
    PAnsiChar('Directory(s)'#10 + 'Directory.'));

  APyDelphiWrapper.RegisterFunction(PAnsiChar('GetFile'), GetFile,
    PAnsiChar('GetFile(s)'#10 + 'GetFile.'));

end;

procedure TPluTonyRegistrationSys.RegisterWrappers(APyDelphiWrapper
  : TPyDelphiWrapper);
begin
  inherited;
  TPyDirectory.TipoDirectory := PlutonyClaseIterator(APyDelphiWrapper,
    'Directory', TPyDirectory, TPyDirectoryIterator);
  TPyMonaFile.TipoFile := PlutonyClaseIterator(APyDelphiWrapper, 'MonaFile',
    TPyMonaFile, TPyMonaFileIterator);

  APyDelphiWrapper.RegisterDelphiWrapper(TPyXStringList);

end;

constructor TPyMonaFile.Create(APythonType: TPythonType);
begin
  inherited;
  // _TipoIterator := TipoPyFileIterator_;

  // ?  Assert(not Assigned(fStrings));
  MonoFile := ''; // TxStringList.Create;
end;

destructor TPyMonaFile.Destroy;
begin
  MonoFile := '';
  inherited;
end;

function TPyMonaFile.GetString: StringPy;
begin
  Result := MonoFile
end;

class function TPyMonaFile.CreatePyFile(const root: String): PPyObject;
var
  _args: PPyObject;
begin
  _args := GetPythonEngine.MakePyTuple
    ([GetPythonEngine.PyUnicodeFromString(root)]);
  try

    Result := TipoFile.CreateTipo(_args);
    // TipoClase.CreateInstanceWith(_args);

  finally
    GetPythonEngine.Py_DECREF(_args);
  end;

end;

function TPyMonaFile.TestIterator_: TPythonType;
begin
  Result := Nil;
  // if (Plutony__ <> nil) then
  begin
    Result := TipoFile.TestIterator;
    // result := PluTony_.TipoFile_.TestIterator;

  end;
  // result := TipoIterator;
end;

function TPyMonaFile.GetAttr(key: PAnsiChar): PPyObject;
begin
  with GetPythonEngine do
  begin
    if key = 'root' then
      Result := VariantAsPyObject(MonoFile.FileName)
      // Or  Result := PyLong_FromLong( x )

    else
      Result := inherited GetAttr(key);
  end;
end;

function TPyMonaFile.SetAttr(key: PAnsiChar; Value: PPyObject): Integer;
var
  ro: PAnsiString;
begin
  Result := 0;
  with GetPythonEngine do
  begin
    if key = 'root' then
    begin
      if PyArg_Parse(Value, 's:Point.SetAttr', @ro) = 0 then
        Result := -1;
    end

    else
      Result := inherited SetAttr(key, Value);
  end;
end;

class procedure TPyMonaFile.RegisterMembers(PythonType: TPythonType);
begin
  with PythonType do
  begin
    // AddMember( 'x', mtInt, NativeInt(@TPyPoint(nil).x), mfDefault, 'x coordinate');
    // AddMember( 'y', mtInt, NativeInt(@TPyPoint(nil).y), mfDefault, 'y coordinate');
  end;
end;

// get/set functions
function TPyMonaFile_GetName(obj: PPyObject; context: Pointer)
  : PPyObject; cdecl;
begin
  with GetPythonEngine do
    Result := PyUnicodeFromString(TPyMonaFile(PythonToDelphi(obj))
      .MonoFile.FileName);
end;

function TPyMonaFile_SetName(obj, Value: PPyObject; context: Pointer)
  : Integer; cdecl;
begin
  with GetPythonEngine do
  begin
    if PyUnicode_Check(Value) then
    begin
      TPyMonaFile(PythonToDelphi(obj)).MonoFile.FileName :=
        PyUnicodeAsString(Value);
      Result := 0;
    end
    else
    begin
      Result := -1;
      PyErr_SetString(PyExc_AttributeError^,
        'attribute Name expected a string value');
    end;
  end;
end;

class procedure TPyMonaFile.RegisterGetSets(PythonType: TPythonType);
begin
  with PythonType do
  begin
    AddGetSet('root', TPyMonaFile_GetName, TPyMonaFile_SetName,
      'Name of a point', nil);
  end;
end;

function TPyMonaFile.Repr: PPyObject;
begin
  with GetPythonEngine do
    Result := VariantAsPyObject(Format('(%s)', [MonoFile.FileName]));
end;

function TPyMonaFile.Iter: PPyObject;
var
  _args: PPyObject;
  ite: TPythonType;
begin
  Result := Nil;

  _args := GetPythonEngine.MakePyTuple([Self.GetSelf]);
  try
    ite := TestIterator_;
    if ite <> nil then
      Result := ite.CreateInstanceWith(_args)

      // Result := Form1.ptStringListIterators.CreateInstanceWith(_args);
  finally
    GetPythonEngine.Py_DECREF(_args);
  end;
end;

class procedure TPyMonaFile.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  with PythonType do
  begin
    // AddMethod( 'add', @TPyMonaFile.add_, 'add a new item to the list and returns the index position' );
  end;
end;

procedure TPyMonaFile.SetStrings(const Value: String);
begin
  // freeNil(fStrings);
  MonoFile := Value
  // fStrings.Assign(Value);
end;

{ TPyMonaFileIterator }

constructor TPyMonaFileIterator.Create(APythonType: TPythonType);
begin
  inherited;
  reader := nil;
end;

constructor TPyMonaFileIterator.CreateWith(PythonType: TPythonType;
  args: PPyObject);
var
  _obj: PPyObject;
  _stringList: TPyMonaFile;
begin
  inherited;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 'O:TPyMonaFileIterator constructor', @_obj) <> 0
    then
    begin
      _stringList := PythonToDelphi(_obj) as TPyMonaFile;
      StringList_ := _stringList;
    end;
  end;
end;

destructor TPyMonaFileIterator.Destroy;
begin
  Freenil(reader);
  StringList_ := nil;
  inherited;
end;

function TPyMonaFileIterator.IterNext: PPyObject;
begin
  Inc(fCurrentIndex_);
  with GetPythonEngine do
  begin

    if not reader.MoveNext then
    begin
      // PyErr_SetString(PyExc_StopIteration^, 'Stop iteration');
      Result := nil;
    end
    else
    begin
      Result := PyUnicodeFromString(reader.GetCurrent);
    end;
  end;
end;

class procedure TPyMonaFileIterator.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  (*
    with PythonType do
    begin
    AddMethod('next', @TPyMonaFileIterator.next,
    'Returns the next value from the iterable container');
    end; *)
end;

procedure TPyMonaFileIterator.SetStringList(const Value: TPyMonaFile);
begin
  if ffichero <> Value then
  begin
    if Assigned(ffichero) then
      GetPythonEngine.Py_DECREF(ffichero.GetSelf);
    ffichero := Value;
    if Assigned(ffichero) then
    begin
      // GetPythonEngine.Py_INCREF(directory.GetSelf);
      reader := TAnsiReaderEnumerator.Create(ffichero.MonoFile);
      // data.InitFiles(directory.MonoFile,'*.*');
      // search:=TBaseSearchEnumerator.Create(@data);

    end;
    fCurrentIndex_ := -1;
  end;
end;

{ TPyMonaFile }

constructor TPyMonaFile.CreateWith(PythonType: TPythonType; args: PPyObject);
var
  // i : Integer;
  aName: PAnsiChar;

begin
  inherited;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:CreateMonaFile', @aName) <> 0 then
    begin
      MonoFile := aName
    end;

  end;
end;

(*
  { Helper functions }
  function WrapFile__(APyDelphiWrapper: TPyDelphiWrapper; const APoint: TMonaFile)
  : PPyObject;
  var
  _type: TPythonType;
  begin
  _type := APyDelphiWrapper.GetHelperType('PyMonaFile');
  result := _type.CreateInstance;
  (PythonToDelphi(result) as TPyMonaFile).Strings_ := APoint;
  end;
*)

class function TPyDirectory.CreatePyDirectory(root: UnicodeString): PPyObject;
var
  _args: PPyObject;
  py: TPyObject;
begin
  Result := nil;
  _args := GetPythonEngine.MakePyTuple
    ([GetPythonEngine.PyUnicodeFromString(root)]);
  try
    // Result := gDirectoryType.CreateInstanceWith(_args);
    // TipoDirectory
    Result := TipoDirectory.CreateTipo(_args);
    if (Result <> nil) then
    begin
      py := PythonToDelphi(Result);
      if py is TPyDirectory then
      begin

        // (py as TPyDirectory).scope:='dir'
      end;
    end
    else
    begin
      Result := TipoDirectory.CreateTipo(_args);
      // Result := TipoDirectory.TipoClase_.CreateInstanceWith(_args);

      // py:=TPyDirectory.CreateWith(_args);
      py := PythonToDelphi(Result);

      if py is TPyDirectory then
      begin

        // (py as TPyDirectory).scope:='dir'
      end;
    end;
    // Result := Form1.ptStringListIterators.CreateInstanceWith(_args);
  finally
    GetPythonEngine.Py_DECREF(_args);
  end;
  { _iter := Form1.ptStringListIterator.CreateInstance as TPyMonaFileIterator;
    _iter.StringList := Self;
    Result := _iter.GetSelf; }
end;

function TPyDirectory.Childir: PPyObject;
var
  py: TPyObject;
begin
  try
    Result := CreatePyDirectory(Self.MonoDir.root);
    // Result :=WrapObjectArgs('PyDirectory', _args);
    if (Result <> nil) then
    begin
      py := PythonToDelphi(Result);
      if py is TPyDirectory then
      begin

        (py as TPyDirectory).scope := 'dir'
      end;
    end

  except
    Result := nil
  end;
end;

constructor TPyDirectory.Create(APythonType: TPythonType);
begin
  inherited;
  mascara := '*.*';
  scope := 'files';
  // ?  Assert(not Assigned(fStrings));
  MonoDir := ''; // TxStringList.Create;
end;

destructor TPyDirectory.Destroy;
begin
  MonoDir := '';
  inherited;
end;

function TPyDirectory.TestIterator__: TPythonType;
begin
  Result := TipoDirectory.TestIterator
end;

function TPyDirectory.SetAttrO(key, Value: PPyObject): Integer;
{ TODO : Remove published properties }
var
  l_sUpperKey: string;
begin
  Result := -1;
  with GetPythonEngine do
  begin
    // if not CheckField then
    // Exit;
    try
      l_sUpperKey := UpperCase(PyObjectAsString(key));
      if l_sUpperKey = 'SCOPE' then
      begin
        scope := PyObjectAsString(Value);
        Result := 0;
      end
      else

        if l_sUpperKey = 'MASK' then
      begin
        mascara := PyObjectAsString(Value);
        Result := 0;
      end
      else
        Result := inherited SetAttrO(key, Value);
    except
      on e: Exception do
      begin
        // RaiseDBError( E );
        Result := -1;
      end;
    end;
  end;
end;

function TPyDirectory.GetAttrO(key: PPyObject): PPyObject;
var
  l_sUpperKey: string;
Begin
  with GetPythonEngine do
  begin
    try
      l_sUpperKey := UpperCase(PyObjectAsString(key));
      if l_sUpperKey = 'CHILDIR' then
        Result := Childir
      else

        if l_sUpperKey = 'SCOPE' then
        Result := VariantAsPyObject(scope)
      else

        if l_sUpperKey = 'MASK' then
        Result := VariantAsPyObject(mascara)
      else
        Result := inherited GetAttrO(key);
    except
      on e: Exception do
      begin
        // RaiseDBError( E );
        Result := Nil;
      end;
    end;
  end;
end;

function TPyDirectory.GetAttr(key: PAnsiChar): PPyObject;
begin
  with GetPythonEngine do
  begin
    if key = 'mask' then
      Result := VariantAsPyObject(mascara)
      // Or  Result := PyLong_FromLong( x )

    else

      if key = 'root' then
      Result := VariantAsPyObject(MonoDir.root)
      // Or  Result := PyLong_FromLong( x )

    else
      Result := inherited GetAttr(key);
  end;
end;

function TPyDirectory.SetAttr(key: PAnsiChar; Value: PPyObject): Integer;
var
  ro: PAnsiChar;
begin
  Result := 0;
  with GetPythonEngine do
  begin
    if key = 'mask' then
    begin
      if PyArg_Parse(Value, 's:Point.SetAttr', @ro) = 0 then
        Result := -1
      else
        mascara := ro
    end
    else

      if key = 'root' then
    begin
      if PyArg_Parse(Value, 's:Point.SetAttr', @ro) = 0 then
        Result := -1;
    end
    else
      Result := inherited SetAttr(key, Value);
  end;
end;

(*
  class procedure TPyPoint.RegisterMethods( PythonType : TPythonType );
  begin
  inherited;
  with PythonType do
  begin
  AddMethod( 'OffsetBy', @TPyPoint.DoOffsetBy, 'Point.OffsetBy( dx, dy )' );
  AddMethod( 'RaiseError', @TPyPoint.DoRaiseError, 'Point.RaiseError()' );
  end;
  end; *)

class procedure TPyDirectory.RegisterMembers(PythonType: TPythonType);
begin
  with PythonType do
  begin
    // AddMember( 'x', mtInt, NativeInt(@TPyPoint(nil).x), mfDefault, 'x coordinate');
    // AddMember( 'y', mtInt, NativeInt(@TPyPoint(nil).y), mfDefault, 'y coordinate');
  end;
end;

// get/set functions
function TPyDirectory_GetName(obj: PPyObject; context: Pointer)
  : PPyObject; cdecl;
begin
  with GetPythonEngine do
    Result := PyUnicodeFromString(TPyDirectory(PythonToDelphi(obj))
      .MonoDir.root);
end;

function TPyDirectory_SetName(obj, Value: PPyObject; context: Pointer)
  : Integer; cdecl;
begin
  with GetPythonEngine do
  begin
    if PyUnicode_Check(Value) then
    begin
      TPyDirectory(PythonToDelphi(obj)).MonoDir.root :=
        PyUnicodeAsString(Value);
      Result := 0;
    end
    else
    begin
      Result := -1;
      PyErr_SetString(PyExc_AttributeError^,
        'attribute Name expected a string value');
    end;
  end;
end;

class procedure TPyDirectory.RegisterGetSets(PythonType: TPythonType);
begin
  with PythonType do
  begin
    AddGetSet('root', TPyDirectory_GetName, TPyDirectory_SetName,
      'Name of a point', nil);
  end;
  // PythonType.AddGetSet('Controls', @TPyDirectory.Get_Controls, nil,
  // 'Returns an itera tor over contained controls', nil);
end;

function TPyDirectory.Repr: PPyObject;
begin
  with GetPythonEngine do
    Result := VariantAsPyObject(Format('(%s)', [MonoDir.root]));
end;

function TPyDirectory.RichCompare(obj: PPyObject; Op: TRichComparisonOpcode)
  : PPyObject;
begin
  with GetPythonEngine do
    Result := PyLong_FromLong(1);
  // Return True by default, just for testing the API.
end;

function TPyDirectory.Iter: PPyObject;
var
  _args: PPyObject;
  ite: TPythonType;
begin
  Result := Nil;
  _args := GetPythonEngine.MakePyTuple([Self.GetSelf
    // ,GetPythonEngine.VariantAsPyObject(Self.mascara)
    ]);
  try
    ite := TestIterator__;

    if ite <> nil then
      Result := ite.CreateInstanceWith(_args)

  finally
    GetPythonEngine.Py_DECREF(_args);
  end;
  { _iter := Form1.ptStringListIterator.CreateInstance as TPyDirectoryIterator;
    _iter.StringList := Self;
    Result := _iter.GetSelf; }
end;

class procedure TPyDirectory.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  with PythonType do
  begin
    // AddMethod('__truediv__', @TPyDirectory.__truediv__,
    // 'Returns the next value from the iterable container');

    // AddMethod( 'add', @TPyDirectory.add_, 'add a new item to the list and returns the index position' );
  end;
end;

{ TPyDirectoryIterator }

constructor TPyDirectoryIterator.Create(APythonType: TPythonType);
begin
  inherited;
  data_.Inits_();
  search_ := nil; // TBaseSearchEnumerator;

end;

constructor TPyDirectoryIterator.CreateWith(PythonType: TPythonType;
  args: PPyObject);
var
  _obj: PPyObject;
  // _stringList: TPyDirectory;
begin
  inherited;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 'O:TPyDirectoryIterator constructor', @_obj) <> 0
    then
    begin
      DirPy := PythonToDelphi(_obj) as TPyDirectory;
      // DirPy := _stringList;
    end;
  end;
end;

destructor TPyDirectoryIterator.Destroy;
begin
  DirPy := nil;
  inherited;
end;

(*
  function TPyDirectoryIterator.Iter: PPyObject;
  begin
  result := Self.GetSelf;
  GetPythonEngine.Py_INCREF(result);
  end;
*)

function TPyDirectoryIterator.IterNext: PPyObject;
begin
  Inc(fCurrentIndex_);
  with GetPythonEngine do
  begin
    if not search_.MoveNext then
    begin
      Result := nil;
    end
    else
    begin
      Result := PyUnicodeFromString(search_.NameFileActual);
    end;
  end;
end;

// __truediv__(self, other)

class procedure TPyDirectoryIterator.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  (*
    with PythonType do
    begin
    AddMethod('next', @TPyDirectoryIterator.next,
    'Returns the next value from the iterable container');
    end; *)
end;

procedure TPyDirectoryIterator.SetStringList(const Value: TPyDirectory);
begin
  if directory_ <> Value then
  begin
    if Assigned(directory_) then
      GetPythonEngine.Py_DECREF(directory_.GetSelf);
    directory_ := Value;
    if Assigned(directory_) then
    begin
      GetPythonEngine.Py_INCREF(directory_.GetSelf);
      if directory_.scope = 'files' then
      begin
        data_.InitFiles(directory_.MonoDir, directory_.mascara);
      end
      else
      begin
        data_.InitDirectorys(directory_.MonoDir);
      end;
      // data.InitFiles(directory.MonoDir, '*.*');
      search_ := TBaseSearchEnumerator.Create(@data_);
    end;
    fCurrentIndex_ := -1;
  end;
end;

{ TPyDirectory }

constructor TPyDirectory.CreateWith(PythonType: TPythonType; args: PPyObject);
var
  // i: Integer;
  aName: PAnsiChar;
begin
  inherited;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:CreateMonaDir', @aName) <> 0 then
    begin
      MonoDir := aName
    end;

  end;
end;
// __floordiv__(self, other)

// function  NbFloorDivide( obj : PPyObject) : PPyObject; virtual;
function TPyDirectory.NbFloorDivide(obj: PPyObject): PPyObject;
var
  s: String;
begin
  Result := nil;
  if obj <> nil then
  begin
    s := GetPythonEngine.PyObjectAsString(obj);
    Result := CreatePyDirectory(MonoDir / s);

  end;

end;

function TPyDirectory.NbTrueDivide(obj: PPyObject): PPyObject;
var
  s: String;
begin
  Result := nil;
  if obj <> nil then
  begin

    s := GetPythonEngine.PyObjectAsString(obj);
    Result := TPyMonaFile.CreatePyFile(MonoDir / s);

  end;

end;

(*
  function TPyXStringList.TestIterator_: TPythonType;
  var
  tipo: TPythonType;
  begin
  result := nil;
  tipo := PluTony_.TipoStringList_.TipoIterator; // TipoPyStringIterator;
  if (tipo = nil) then
  begin
  tipo := TestIteratorClase(GetModule, TPyStringListIterator,
  'TPyStringListIterator');
  PluTony_.TipoStringList_.TipoIterator := tipo;
  end;
  result := tipo
  end;
*)
class procedure TPyXStringList.SetupType(PythonType: TPythonType);
begin
  inherited;

  PythonType.Services.Mapping := PythonType.Services.Mapping +
    [msLength, msSubscript];

  PythonType.TypeName := 'PyXStringList';
  PythonType.Services.Basic := [bsRepr, bsStr, bsGetAttrO, bsSetAttrO, bsIter,
    bsIterNext];
  PythonType.Services.Sequence := [ssLength, ssItem, ssAssItem];
  PythonType.TypeFlags := [tpfBaseType, tpHaveVersionTag];

  // PythonType.Services.Basic := [bsRepr, bsStr, bsIter, bsIterNext];
  // PythonType.Services.Mapping  := PythonType.Services.Mapping  + [msLength, msSubscript];
end;

class function TPyXStringList.GetContainerAccessClass: TContainerAccessClass;
begin
  Result := TpluxStringListAccess
  // inherited GetContainerAccessClass // TpluxStringListAccess;
end;

constructor TPyXStringList.CreateWith(PythonType: TPythonType; args: PPyObject);
var
  i: Integer;
begin
  inherited;
  with GetPythonEngine do
  begin
    // if Strings=nil then

    for i := 0 to PyTuple_Size(args) - 1 do
    begin
      strings.add(PyObjectAsString(PyTuple_GetItem(args, i)));
    end;
  end;
end;
(*
  function TPyXStringList.SqAssItem(idx: NativeInt; obj: PPyObject): integer;
  begin
  with GetPythonEngine do
  begin
  if idx < Strings.Count then
  begin
  Strings[idx] := PyObjectAsString(obj);
  Result := 0;
  end
  else
  begin
  PyErr_SetString(PyExc_IndexError^, 'list index out of range');
  Result := -1;
  end;
  end;
  end;
*)
{ TPyDelphiControl }

class function TPyXStringList.DelphiObjectClass: TClass;
begin
  Result := TxStringList;
end;

function TPyXStringList.GetDelphiObject_: TxStringList;
var
  dox: TObject;
begin
  dox := inherited DelphiObject;
  if dox = nil then
  begin
    DelphiObject := TxStringList.Create();
    dox := inherited DelphiObject;

  end;
  Result := TxStringList(dox);

end;

{ TpluxStringListAccess }

class function TpluxStringListAccess.ExpectedContainerClass: TClass;
begin
  Result := TxStringList;
end;

function TpluxStringListAccess.GetContainer: TxStringList;
begin
  Result := TxStringList(inherited Container);
end;

function TpluxStringListAccess.GetItem(AIndex: Integer): PPyObject;
begin
  Result := GetPythonEngine.PyUnicodeFromString(Container_[AIndex])
  // Wrap(Container[AIndex]);
end;

function TpluxStringListAccess.SetItem(AIndex: Integer;
  AValue: PPyObject): boolean;
begin

  with GetPythonEngine do
  begin
    if PyUnicode_Check(AValue) then
    begin
      Container_[AIndex] := PyUnicodeAsString(AValue);
      Result := True;
    end
    else
    begin
      Result := False;
      PyErr_SetString(PyExc_AttributeError^,
        'You can only assign strings to TStrings items');
    end;
  end
end;

function TpluxStringListAccess.GetSize: Integer;
begin
  if Container_ = nil then
  begin
    Result := 0;
    Exit;
  end;
  Result := Container_.Count;
end;

class function TpluxStringListAccess.Name: string;
begin
  Result := 'Attributes';
end;

class function TpluxStringListAccess.SupportsIndexOf: boolean;
begin
  Result := True;
end;

destructor TPyXStringList.Destroy;
begin
  // if nonil then
  begin
    // ?  Freenil (fStrings) //Free;
  end;
  inherited;
end;

function TPyXStringList.add(args: PPyObject): PPyObject;
var
  _obj: PPyObject;
begin
  with GetPythonEngine do
  begin
    // We adjust the transmitted self argument
    Adjust(@Self);
    if PyArg_ParseTuple(args, 'O:add', @_obj) <> 0 then
    begin
      Result := PyLong_FromLong(strings.add(PyObjectAsString(_obj)));
    end
    else
      Result := nil;
  end;
end;

function TPyXStringList.AddObject_Wrapper(args: PPyObject): PPyObject;
Var
  PStr: PPyObject;
  _obj: PPyObject;
  _value: TObject;
begin
  // We adjust the transmitted self argument
  Adjust(@Self);
  with GetPythonEngine do
    if PyArg_ParseTuple(args, 'OO:AddObject', @PStr, @_obj) <> 0 then
    begin
      if CheckObjAttribute(_obj, 'The second argument of AddObject', TObject,
        _value) then
        Result := PyLong_FromLong
          (strings.AddObject(PyObjectAsString(PStr), _value))
      else
        Result := nil;
    end
    else
      Result := nil;
end;

procedure TPyXStringList.SetDelphiObject(const Value: TxStringList);
begin
  (* if fDelphiObject <> Value then
    begin
    if Assigned(Value) then
    Assert(Value.InheritsFrom(DelphiObjectClass));
    if Assigned(fDelphiObject)then
    begin
    UnSubscribeToFreeNotification;
    if Owned then
    fDelphiObject.Free;
    end;
    fDelphiObject := Value;
    if Assigned(fDelphiObject) then
    SubscribeToFreeNotification;
    end;
    //  inherited DelphiObject *)
  // fDelphiObject := Value;
  inherited DelphiObject := TStrings(Value);
end;

function TPyXStringList.Add_Wrapper(args: PPyObject): PPyObject;
Var
  PStr: PPyObject;
begin
  // We adjust the transmitted self argument
  Adjust(@Self);
  with GetPythonEngine do
    if PyArg_ParseTuple(args, 'O:Add', @PStr) <> 0 then
      Result := PyLong_FromLong(strings.add(PyObjectAsString(PStr)))
    else
      Result := nil;
end;

function TPyXStringList.Assign(ASource: PPyObject): PPyObject;
var
  i: Integer;
  _item: PPyObject;
  ss: TxStringList;
begin
  with GetPythonEngine do
  begin
    if not IsDelphiObject(ASource) and (PySequence_Check(ASource) <> 0) then
    begin
      ss := strings;
      ss.BeginUpdate;
      try
        ss.Clear;
        ss.Capacity := PySequence_Length(ASource);
        for i := 0 to PySequence_Length(ASource) - 1 do
        begin
          _item := PySequence_GetItem(ASource, i);
          try
            ss.add(PyObjectAsString(_item));
          finally
            Py_DECREF(_item);
          end;
        end;
      finally
        ss.EndUpdate;
      end;
      Result := ReturnNone;
    end
    else
      Result := inherited Assign(ASource);
  end;
end;

function TPyXStringList.Get_Text(AContext: Pointer): PPyObject;
begin
  Adjust(@Self);
  Result := GetPythonEngine.PyUnicodeFromString
    (CleanString(strings.Text, False));
end;

function TPyXStringList.IndexOf_Wrapper(args: PPyObject): PPyObject;
Var
  PStr: PPyObject;
begin
  // We adjust the transmitted self argument
  Adjust(@Self);
  with GetPythonEngine do
    if PyArg_ParseTuple(args, 'O:IndexOf', @PStr) <> 0 then
      Result := GetPythonEngine.PyLong_FromLong
        (strings.IndexOf(PyObjectAsString(PStr)))
    else
      Result := nil;
end;

function TPyXStringList.LoadFromFile_Wrapper(args: PPyObject): PPyObject;
Var
  PStr: PAnsiChar;
begin
  // We adjust the transmitted self argument
  Adjust(@Self);
  if GetPythonEngine.PyArg_ParseTuple(args, 's:LoadFromFile', @PStr) <> 0 then
  begin
    strings.LoadFromFile(string(PStr));
    Result := GetPythonEngine.ReturnNone;
  end
  else
    Result := nil;
end;

function TPyXStringList.SaveToFile_Wrapper(args: PPyObject): PPyObject;
Var
  PStr: PAnsiChar;
begin
  // We adjust the transmitted self argument
  Adjust(@Self);
  if GetPythonEngine.PyArg_ParseTuple(args, 's:SaveToFile', @PStr) <> 0 then
  begin
    strings.SaveToFile(string(PStr));
    Result := GetPythonEngine.ReturnNone;
  end
  else
    Result := nil;
end;

function TPyXStringList.Set_Capacity(AValue: PPyObject;
  AContext: Pointer): Integer;
var
  _capacity: Integer;
begin
  with GetPythonEngine do
  begin
    Adjust(@Self);
    if CheckIntAttribute(AValue, 'Capacity', _capacity) then
    begin
      strings.Capacity := _capacity;
      Result := 0;
    end
    else
      Result := -1;
  end;
end;

function TPyXStringList.Set_Text(AValue: PPyObject; AContext: Pointer): Integer;
var
  _text: string;
begin
  with GetPythonEngine do
  begin
    Adjust(@Self);
    if CheckStrAttribute(AValue, 'Text', _text) then
    begin
      strings.Text := _text;
      Result := 0;
    end
    else
      Result := -1;
  end;
end;

function TPyXStringList.MpSubscript(obj: PPyObject): PPyObject;
Var
  s: string;
  Index: Integer;
begin
  with GetPythonEngine do
  begin
    if PyLong_Check(obj) then
      Result := SqItem(PyLong_AsLong(obj))
    else
    begin
      s := PyObjectAsString(obj);
      if s <> '' then
      begin
        Index := strings.IndexOf(s);
        if Index >= 0 then
        begin
          if Assigned(strings.Objects[Index]) then
            Result := Wrap(strings.Objects[Index])
          else
            Result := GetPythonEngine.ReturnNone;
        end
        else
          with GetPythonEngine do
          begin
            PyErr_SetString(PyExc_KeyError^, PAnsiChar(AnsiString(s)));
            Result := nil;
          end;
      end
      else
        with GetPythonEngine do
        begin
          PyErr_SetString(PyExc_KeyError^, '<Empty String>');
          Result := nil;
        end;
    end;
  end;
end;

function TPyXStringList.MpLength: NativeInt;
begin
  Result := strings.Count;
end;

function TPyXStringList.Get_Capacity(AContext: Pointer): PPyObject;
begin
  Adjust(@Self);
  Result := GetPythonEngine.PyLong_FromLong(strings.Capacity);
end;

function TPyXStringList.EndUpdate_Wrapper(args: PPyObject): PPyObject;
begin
  // We adjust the transmitted self argument
  Adjust(@Self);
  if GetPythonEngine.PyArg_ParseTuple(args, ':EndUpdate') <> 0 then
  begin
    strings.EndUpdate;
    Result := GetPythonEngine.ReturnNone;
  end
  else
    Result := nil;
end;

function TPyXStringList.BeginUpdate_Wrapper(args: PPyObject): PPyObject;
begin
  // We adjust the transmitted self argument
  Adjust(@Self);
  if GetPythonEngine.PyArg_ParseTuple(args, ':BeginUpdate') <> 0 then
  begin
    strings.BeginUpdate;
    Result := GetPythonEngine.ReturnNone;
  end
  else
    Result := nil;
end;

function TPyXStringList.Clear_Wrapper(args: PPyObject): PPyObject;
begin
  // We adjust the transmitted self argument
  Adjust(@Self);
  if GetPythonEngine.PyArg_ParseTuple(args, ':Clear') <> 0 then
  begin
    strings.Clear;
    Result := GetPythonEngine.ReturnNone;
  end
  else
    Result := nil;
end;

function TPyXStringList.Delete_Wrapper(args: PPyObject): PPyObject;
Var
  Index: Integer;
begin
  // We adjust the transmitted self argument
  Adjust(@Self);
  if GetPythonEngine.PyArg_ParseTuple(args, 'i:Delete', @Index) <> 0 then
  begin
    if CheckIndex(Index, strings.Count) then
    begin
      strings.Delete(Index);
      Result := GetPythonEngine.ReturnNone;
    end
    else
      Result := nil
  end
  else
    Result := nil;
end;

class procedure TPyXStringList.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  with PythonType do
  begin
    AddMethod('addd', @TPyXStringList.add,
      'add a new item to the list and returns the index position');
  end;

  PythonType.AddMethod('Add', @TPyXStringList.Add_Wrapper,
    'TStrings.Add(s)'#10 +
    'Adds a string to the TStrings object and returns the index position');
  PythonType.AddMethod('AddObject', @TPyXStringList.AddObject_Wrapper,
    'TStrings.AddObject(s, delphiobject)'#10 +
    'Adds a string and an associated Delphi object to the Strings and returns the index position');
  PythonType.AddMethod('Clear', @TPyXStringList.Clear_Wrapper,
    'TStrings.Clear()'#10 +
    'Clears all strings from a TStrings (and the associated objects');
  PythonType.AddMethod('Delete', @TPyXStringList.Delete_Wrapper,
    'TStrings.Delete(i)'#10 +
    'Deletes the string at Index i (and the associated object');
  PythonType.AddMethod('IndexOf', @TPyXStringList.IndexOf_Wrapper,
    'TStrings.IndexOf(s)'#10 +
    'Returns the Index of a string s or -1 if not found');
  PythonType.AddMethod('BeginUpdate', @TPyXStringList.BeginUpdate_Wrapper,
    'TStrings.BeginUpdate()'#10 +
    'Enables the TStrings object to track when the list of strings is changing.');
  PythonType.AddMethod('EndUpdate', @TPyXStringList.EndUpdate_Wrapper,
    'TStrings.EndUpdate()'#10 +
    'Enables the TStrings object to keep track of when the list of strings has finished changing.');
  PythonType.AddMethod('LoadFromFile', @TPyXStringList.LoadFromFile_Wrapper,
    'TStrings.LoadFromFile(filename)'#10 +
    'Fills the list with the lines of text in a specified file.');
  PythonType.AddMethod('SaveToFile', @TPyXStringList.SaveToFile_Wrapper,
    'TStrings.SaveToFile(filename)'#10 +
    'Saves the strings in the list to the specified file.');
end;

function TPyXStringList.Get_Objects(AContext: Pointer): PPyObject;
begin
  Adjust(@Self);
  Result := Self.PyDelphiWrapper.DefaultContainerType.CreateInstance;
  with PythonToDelphi(Result) as TPyDelphiContainer do
    Setup(Self.PyDelphiWrapper,
      TStringsObjectsAccess.Create(Self.PyDelphiWrapper, Self.DelphiObject));
end;

class procedure TPyXStringList.RegisterGetSets(PythonType: TPythonType);
begin
  inherited;
  with PythonType do
  begin
    AddGetSet('Capacity', @TPyXStringList.Get_Capacity,
      @TPyXStringList.Set_Capacity,
      'Indicates the number of strings the TStrings object can hold.', nil);
    AddGetSet('Text', @TPyXStringList.Get_Text, @TPyXStringList.Set_Text,
      'Lists the strings in the TStrings object as a single string with the individual strings delimited by carriage returns and line feeds.',
      nil);
    AddGetSet('Objects', @TPyXStringList.Get_Objects, nil,
      'Represents a set of objects that are associated one with each of the strings in the Strings property.',
      nil);
  end;
end;

function TPyXStringList.Repr: PPyObject;
begin
  Result := GetPythonEngine.PyUnicodeFromString
    (Format('<Delphi TStrings at %x>', [NativeInt(Self)]));
end;

function TPyXStringList.Iter: PPyObject;
begin
  Result := inherited Iter
end;

function InjectScriptPython(): IScript;
begin
  Result := TScriptPython.Create(nil);
end;

procedure TTestScriptsPython.Init;
begin
  // SubRecord.Init
end;

constructor TScriptPython.Create(const obj: TObject);
begin
  inherited Create(obj);
  Script := '';
end;

destructor TScriptPython.Destroy;
begin
  Script := '';
  inherited Destroy;
end;

function TPlutonyTypesHelper.CreateOutPutS(): TPythonIOResult;
begin
  Result := TPythonIOResult.Create(nil);
  // result.OnSendData := event;
end;

function TPlutonyTypesHelper.runPythonCodeResult(const code: String): string;
var
  en_: TPythonEngine;
  io: TPythonIOResult;
  iold: TPythonInputOutput;

begin
  iold := nil;
  if Engine <> nil then
  begin
    iold := Engine.io;
  end;
  io := CreateOutPutS();
  try

    // Resulta_.Reset;
    en_ := PluTony_.InitdatabasePly_(io); // PythonGUIInputOutput1);
    if Engine <> nil then
    begin
      Engine.io := io;
    end;

    if not PythonOK then
    begin
      WriteLn('no ok')
    end
    else
    begin
      en_.ExecutePython(code)
      // AsStringList.strings);
    end;
    Result := io.resulta.resulta;
  finally
    if en_ <> nil then
    begin
      en_.io := iold;
    end;
    io.Free;
    // freeNil(io);
  end;
end;

function TScriptPython.Runs(const req: TScriptRequest): TScriptResponse;
begin
  try
    Result.Init(PluTony_.runPythonCodeResult(req.Source))
  except
    Result.Init('Error: TScriptPython.Run')

  end;
end;

class function TTestScriptsPython.ExecDWS(s: string): string;
begin
  Result := PluTony_.runPythonCodeResult(s)
end;

{ TPythonIOResult }

constructor TPythonIOResult.Create(AOwner: TComponent);
begin
  inherited;
  resulta.Reset;
  OnSendData := SendResult_;
end;

destructor TPythonIOResult.Destroy;
begin
  resulta.Reset;

  inherited;
end;

procedure TPythonIOResult.SendResult_(Sender: TObject; const Data: AnsiString);
begin
  resulta.Print(Data);
  // WriteLn(Data);
end;

initialization

PluTony_.Init;
TPyMonaFile.TipoFile.Init;
TPyDirectory.TipoDirectory.Init;

RegisteredUnits.add(TPluTonyRegistrationSys.Create);

finalization

PluTony_.Done;

end.

  function TPyDirectory.__truediv__
(args: PPyObject): PPyObject;

var
  ss: PAnsiChar;

begin
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:__truediv__', @ss) <> 0 then
    begin
      Result := TPyMonaFile.CreatePyFile(MonoDir / ss);
      // Result := CreatePyDirectory(MonoDir / ss);
    end;
  end;
end;
