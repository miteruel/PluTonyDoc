unit Monadas_Pascal;

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

*)

{$I plutonidef.inc}

interface

// implementation end.

uses
  sysutils,
  Classes;

Var
  modoconsole: boolean = false;

const

  BufReadLn = 255;

type
  TTipoObjeto = (Tonone, Todisk, Todir, ToFile, ToObject, Toindef);

{$IFNDEF xe5}
    TBytes = array of Byte;
{$ENDIF}

{$IFDEF AnsiModeDx}
  SString = AnsiString; //
  SChar = AnsiChar; //

  SysString = SString;

  TUrlFile = SString;
  SPChar = PAnsiChar; // PAnsiChar; //^SChar; //

{$ELSE}
  SChar = Char; // Char;

  SString = String; // String;

  SysString = String;
  TUrlFile = SysString; // TFILENAME; // SString;
  SPChar = PChar; // ^SChar; //PAnsiChar;

{$ENDIF}

{$IFNDEF mimormot}
  RawByteString = type AnsiString;
  RawUTF8 = type AnsiString;
{$ELSE mimormot}
  RawUTF8 = syncommons.RawUTF8;
{$IFDEF FPC}
  RawByteString = System.RawByteString; // type AnsiString;
{$ELSE}
{$IFNDEF DelphiDx}
  RawByteString = syncommons.RawByteString; // type AnsiString;
{$ENDIF}
{$ENDIF}
{$ENDIF mimormot}

type
  SysChar = SChar;
  TCharSet = Set Of SChar;

  PxStringItem = PStringItem;
  arrayPairs = array of SString;

  URLstring = SString;
  PStreamChar = PAnsiChar; // SPChar;

  TPath = type string;

  Tosversion = (Toswin, Toslinux);

const
  ChIgual: SChar = '=';

  MaxBuf_ = 512;

  LowSt_ = 1;
  HiSt = 0;

type

  TModeEnum = (menIni, menNext, menEnd);
  TModesEnums = set of TModeEnum;

  PtrInt = integer;

  TEnumerator = class;

  TEvaluateLong = record
    enum: TEnumerator;
    Procedure Inits(e: TEnumerator = nil);
  public
    fLast: integer;
    fIndex: integer;
  end;

  TEnumerator = class
  private
    Compone_: TObject; // Component to delete
  public
    data: Pointer;
    Id: integer;
    fLast: integer;
    fIndex: integer;

    OwnerEnumerator: TEnumerator;
  public
    constructor Create(const d: Pointer; const comp: TObject = nil); virtual;

    Destructor Destroy; override;
    property Mediador: TObject read Compone_;

  public
    function CountIni_: integer; virtual;
    function Info_(__i: integer; _mode: TModeEnum): SString; virtual;

    function EvaluarActual: TEvaluateLong; virtual;

  protected
    procedure Log_(mode: TModeEnum); virtual;
  end;

  TInfoEnumerator = record
    Base: TEnumerator;
    procedure Init(const aValue: TEnumerator);

    class operator Implicit(const aValue: TEnumerator): TInfoEnumerator;
  end;

  TSelfEnumerator = class(TEnumerator)
    function GetCurrent: TInfoEnumerator;
    property Current: TInfoEnumerator read GetCurrent;
  end;

  TxEnumFactory = class
  protected
    desde__: integer;
    data_: TObject;
    ownerEnum: TEnumerator;
  public
    constructor Create(const ds: TObject); virtual;
  end;

  TMonoEnumerator = class(TEnumerator)
    constructor Create(const d: Pointer = nil; const comp: TObject = nil);
      reintroduce; virtual; // reintroduce;
    // Destructor Destroy; override;
    function MoveNext: boolean; inline;
    function CountIni_: integer; override;
  end;

  PEnumeratorRecord = ^TEnumeratorRecord;

  TEnumeratorRecord = record
    data_: Pointer;
    Id: integer;
    fIndex, fLast_: integer;

{$IFDEF enuLocal}
    stcurrent_: SString;
{$ENDIF enuLocal}
    procedure Init(const d: Pointer; const las: integer);
    procedure InitListString(Ax_: Pointer);
    function MoveNext: boolean; inline;

    function CountIni_: integer;

    function CurrentObject: TObject;

{$IFDEF enuLocal}
    property Current: SString read stcurrent_; // GetCurrent;
{$ELSE enuLocal}
    function GetCurrent: SString; inline;
    property Current: SString read GetCurrent;
{$ENDIF enuLocal}
  end;

  TEnumeratoIndex = class(TEnumerator)
    function MoveNext: boolean; inline;
    function CountString_: integer;
  end;

  TStringEnumeratorBas = class(TEnumeratoIndex)
  public
    function CountIni_: integer; override;
  end;

  TStringEnums = class(TEnumeratoIndex)
  public

    function GetCurrent: SString;
    function CountIni_: integer; override;
    property Current: SString read GetCurrent;

  end;

  TsEnumObj = class(TStringEnumeratorBas)
  public
    function GetCurrent: PxStringItem;
    property Current: PxStringItem read GetCurrent;
  end;

  TEnumeraOnjects = class(TxEnumFactory)
  public
    function GetEnumerator: TsEnumObj;
  end;

  TModeFindAtt = (MxoUtf, MxoNoCS, MxoTrim, MxoBlanco, MxoError, Mxoexcluye,
    MxoMini, MxoCheckDel);
  TModeFindXml = set of TModeFindAtt;

  PMixString = ^TMixString;
  Reales = Double;

  TMixString = packed Record
    Ps_: SPChar;
    lon: integer;
    Procedure AsignaPChar(const s: SPChar; le: integer); inline;
    function ToSt: SString; // inline;
    Procedure NulString;
    class operator Equal(const aLeftOp, aRightOp: TMixString): boolean;

    class operator Equal(const aLeftOp: TMixString;
      const aRightOp: SString): boolean;
    class operator Equal(const aLeftOp: SString;
      const aRightOp: TMixString): boolean;
    class operator Implicit(const aValue: TMixString): SString; overload;
    class operator Implicit(const aValue: PMixString): TMixString; overload;
    function PosIgual(): integer;
    class operator Implicit(const aValue_: SString): TMixString;
    class operator NotEqual(const aLeftOp, aRightOp: TMixString): boolean;
    class operator Add(const aLeftOp: SString;
      const aRightOp: TMixString): SString;
    function FixSpaces: boolean;

    // private

    Procedure Init(const aValue_: SString); inline;
    // class operator Implicit(const aValue: TMixString): TMixString;
    class operator Implicit(const aValue: TMixString): Int64;
    class operator Implicit(const aValue: TMixString): integer;

    class operator GreaterThanOrEqual(const aLeft: TMixString;
      const aRight: TMixString): boolean;

    class operator GreaterThan(const aLeft: TMixString;
      const aRight: TMixString): boolean;
    class operator LessThan(const aLeft: TMixString;
      const aRight: TMixString): boolean;
    class operator LessThan(const aLeft: TMixString;
      const aRight: SString): boolean;
    class operator GreaterThan(const aLeft: TMixString;
      const aRight: SString): boolean;

    function IsNull: boolean;

    function ToReal: Reales; inline;
  private
    function Match(const s: SString; len: integer): boolean;
    Function UpSts: SString;
    function EqualUp(const aRightOp: SString): boolean; // overload;
    function IsUpperCases: boolean;
    procedure SetLongTo(pc: SPChar); inline;
    function ToInt64(): Int64;

  end;

  PPairMix = ^TMixPair;

  TMixPair = packed record
    Nombre: TMixString;
    valor: TMixString;
    s: SString;

    Procedure Inits(const os: SString); // inline;

    function SpaceAtrib: SString;
    function FindNameVal: SString;
{$IFDEF lazaruss}
    class function Implicit(const aValue: TMixPair): TMixPair; // override;
    class function Explicit(const aValue: SString): TMixPair;
    class function Implicit(const aValue: SString): TMixPair; override;
{$ELSE}
    // class operator Implicit(const aValue: TMixPair): TMixPair;override;
    class operator Explicit(const aValue: SString): TMixPair;
    class operator Implicit(const aValue: SString): TMixPair; // inline;
{$ENDIF}
  end;

  TAnsiStrRec = packed record
    RefCount: longint;
    Length: longint;
  end;

  PAnsiStrHeader = ^TAnsiStrRec;

  SetChar = set of SChar;
  PSetchar = ^SetChar;
  TMonaStringx = TMixString;

  TAtribute = Packed record

    Name_: TMixString;
    Value: TMixString;
    // private

    procedure Inits(const os: SString);
    function SumMixPP(): SString;
  private

  end;

  PAtribute = ^TAtribute;

  AnsiSysString = SString;

  TxStringList = class(TStringList)

  public
    function GetEnumerator: TEnumeratorRecord;
{$IFNDEF DelphiDx}
    function IndexOfName(const Name: AnsiString): integer; override;
{$ENDIF}
    procedure AddSt(const s: SString); // inline;
    procedure SetCapa(len: integer);
    procedure Ata(const na, va: SString);
    procedure Atas(const na, va: SString);
    function FastValuePc_(const namp: SString): TMixString;
    procedure FastIndexOrIncludeSorted_(const s: SString);
    function FastMatchValor_(const napavalor: SString;
      modof_: TModeFindXml): boolean;

    function MixItem(const Index: integer): TMixPair;
    function MixAtrib(const Index: integer): TAtribute;

    function ValueInt_(const namp: SString): Int64;

    function IncAttribute__(const attrName: SString;
      valor: integer = 1): integer;
    function IncAttribute(const attrName: SString; valor: Int64 = 1): Int64;

    function Objeto(n: integer): TObject;// inline;
    function Gets(Index: integer): SString;
    function Objetos: TEnumeraOnjects;
    Function Paramterst: SString;
    procedure FastIndexOrInclude(const s: SString);

  private
    function FindNames(const Name: SString): integer;

    procedure SetAttribute(const attrName: SString; const Value: SString);

    procedure Puts(Index: integer; const s: SString); // virtual;
    property Items[Index: integer]: SString read Gets; // write Put; default;

  public
{$IFDEF TracesXml}
    constructor Create;
    destructor Destroy; override;
{$ENDIF TracesXml}
    constructor Creates(const o: TxStringList = Nil);
    // function GetEnumerator: TEnumeratorRecord;

    property Stringss[Index: integer]: SString read Gets write Puts; default;
  end;

  TAutoStringList = class(TxStringList)
  public
    destructor Destroy; override;
  end;

  TStringsHelper = class helper for TStringList
  public

    function IndexObject(const s: SString): TObject;

    procedure AddSt__(const s: SString); // inline;
    Procedure AddMix(const mix: PPairMix);
    function FastValueMx(const nam: TMixString): TMixString;
    function FastIndexOf(const s: SString): integer;

  public
    procedure SetAttribute(const attrName: SString; const Value: SString);
    procedure DeleteIndexOf(pc: SPChar; le: integer);
    procedure SetAttributex(const attrName: TMixString;
      const Value: TMixString);
    procedure AddObjects(aObject: TObject); inline;
    function FastValues__(const nam: SString; mas: boolean): SString;
    procedure SetAttrib(const attrName: SString; const Value: SString;
      siempre: boolean = false);
    procedure DeleteIndexOfName(const Name: SString);
    procedure SetAttributeIfno0(const attrName: TMixString);
    function GetEnumerator: TEnumeratorRecord;
    procedure DeleteIndexMx(const nam: TMixString);
    procedure FixCapacity;

  private

    function FastIndexOfName(const Name: SString): integer;

    function MatchValue_(const nam: SString; const tomatch: SString;
      modof: TModeFindXml): boolean;

  private

    function FastIndexOfNamePL(const Name: SPChar; le: integer): integer;

  protected

    function IndexMx_(const nam: TMixString): integer;
  public
    procedure DoneObjects;

    function FastName(i: integer): TMixString;

  protected
    procedure SetAttribInt___(const attrName: SString; const Value: Int64);
  end;

const

  Barrax = '\';

{$IFDEF NoAnsiMode}
  StCharSize_ = 2;
{$ELSE NoAnsiMode}
  StCharSize_ = 1;
{$ENDIF NoAnsiMode}

const
  EOL_ = #13#10;
  // StCharSize_ = Monada_Todo.StCharSize_;

type

  StringModel = SString;

  IModel = interface
    function ModelName: StringModel;
  end;

type
  ITodoInterface = interface(IInterface)
    ['{C4A46235-088E-48C2-AF6E-A5508AA88522}']
  end;

  ITodoLocalInterface = interface(ITodoInterface)
    ['{079A44A7-AD09-4AC5-AB00-0B3C14E83569}']
    function Componente: TObject;
  end;

  PtStringItemList = Classes.PStringItemList;

  StreamString = AnsiString;

  IXitUser = Interface(ITodoLocalInterface)
    ['{BB772E64-CCE6-4273-92DE-27AFB7242272}']
    Function Numero: integer;
  end;

  ILog = interface(ITodoLocalInterface)
    ['{753B576E-AA70-42DE-8C8A-A3EA37DF29B3}']
    procedure Logs(const describe: array of const; const dato: TObject = nil);
    procedure Log_(const describe: SString; const dato: TObject = nil);
    function Input(const prom: SString): SString;
    function Cancelado: boolean;
  end;

type
  // RawUTF8 = String;

  TMiStringArray = Array of SString;

  TLogFunction = procedure(const valores: SString; const u: IXitUser = nil);

{$M+}
  TInterfacedObjectWithCustomCreate = TInterfacedObject;

  TInterfaceObject = class(TInterfacedObjectWithCustomCreate, ITodoInterface)
  protected
  strict private
    // FRefCount: integer;
    FRefenced_: boolean;
  protected
{$IFDEF FPC}
    function QueryInterface({$IFDEF FPC_HAS_CONSTREF}constref{$ELSE}const
{$ENDIF} iid: tguid; out obj): longint; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
    function _AddRef: longint; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
    function _Release: longint; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
{$ELSE}
    function QueryInterface(const iid: tguid; out obj): HResult; stdcall;

    function _AddRef: integer; stdcall;
    function _Release: integer; stdcall;

{$ENDIF}
  public
    constructor Create; virtual; // override;
    constructor Creates;
    destructor Destroy; override;

    procedure DoReferenced(const como: boolean = True);
    function Componente: TObject;

{$IFNDEF AUTOREFCOUNT}
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;

{$ELSE}
{$ENDIF}
    property RefCount: integer read FRefCount;
  end;
{$M-}

  IAutoDone = interface(ITodoInterface)
    ['{07AA00FB-677B-44F1-AAF5-6B45368AEB26}']
    function GetMonada: Pointer;
    procedure Done;

  end;

  TDoneProc = procedure(mona: Pointer);

  TRecRunAutoDone = record
    procedure Init(const obj: Pointer = nil; const doproc: TDoneProc = nil);
    procedure Done;
    procedure RunDone;

  private
  public
    fMonada: Pointer;
    DoneProc: TDoneProc;
  end;

  TClassAutoDone = class(TInterfaceObject, IAutoDone)
    constructor Create(const obj: Pointer = nil; const doproc: TDoneProc = nil);
      reintroduce; overload;
    function GetMonada: Pointer;

    destructor Destroy; override;
    procedure Done;

  private
    MonaDone: TRecRunAutoDone;
  end;

  PSearchData = ^TSearchData;

  TBaseSearchEnumerator = class;
  PSearchrec = ^tSearchrec;

  TFilterSearcher = function(const sr: PSearchrec): boolean;

  TBaseSearchEnumerator = class(TSelfEnumerator)
  public
    sr: tSearchrec;
    mascaras_: PSearchData;
  protected

    AttribFile: integer;
    doFirst: boolean;

    filter: TFilterSearcher;
    evalue_: TEvaluateLong;
  public
    constructor Create(const ds: PSearchData;
      const comp: TObject = nil); virtual;
    procedure CloseEnumerator;
    function MoveNext: boolean; virtual;
    function EvaluarActual: TEvaluateLong; override;

    Destructor Destroy; override;
    function NameFileActual: SString;
  end;

  TSearchData = Record
  public
    SearchFile_, Mask: SString;
    directory__: TUrlFile;
    AttibFile: integer;
    // private
    Search___: SString;

  public
    function GetEnumerator: TBaseSearchEnumerator;

    procedure Inits_(const dir: SString = ''; att: integer = 0;
      mascara: SString = '');
    procedure InitFileMask(const dir: SString; att: integer);

    procedure InitFiles(const dir: SString; const masc_: SString);
    procedure InitDirectorys(const dir: SString);
    function DirMask_(const dir: SString): SString;

    procedure InitMask(const mascara: SString = '';
      atributos: integer = faanyfile);

  private
    function MaskTrim_: SString;

  end;

  TRecAutoDone = record

    procedure Init;
    procedure Done;

    function GetObject: Pointer;
    function HasAuto: boolean;
    procedure SetObj_(const aValue: Pointer; const doproc: TDoneProc = nil);

  private
    auto_: IAutoDone;
  end;

  // Type
  TMonaStringList = Record
    function Add(const s: StringModel): integer;
    procedure Init(const no: TxStringList = nIL);
    procedure InitText(const cadena: SString);

    procedure InitAnd(const cadena: SString);
    procedure Done;
    procedure Clear;

    function DoneString: TxStringList;
    function Count: integer;
    function Text: SString;
    function GetEnumerator: TEnumeratorRecord;
    function IndexObject(const s: SString): TObject;
    function AddIFNot(const s: SString; const aObject: TObject = nil): integer;
    function AddIF(const s: SString): integer;
    function AddCount(const s: SString): integer;

    function Strings: TxStringList;
    function IndexOf(const s: SString): integer;
    function Existe(const s: SString): boolean;

    function GetSt(const nam: SString): SString;
    function SaveFile__(const fina: SString): boolean;
    function LoadFile(const fina: SString): boolean;

    function Intersecion(const oma: TxStringList): integer;
    function St(const nam: integer): SString;
    function Value(const nam: SString): SString;

    function Inited: boolean;
    property valor[const na: SString]: SString read GetSt; default;
    procedure setAtrib(const a, v: StringModel);

  private
  public
    ss_: TxStringList;
    Auto: TRecAutoDone;

  public
    class operator Implicit(const aValue: TMonaStringList): TxStringList;
    class operator Implicit(const aValue: TMonaStringList): TStrings;
    class operator Implicit(const aValue: TxStringList): TMonaStringList;
    class operator Implicit(const aValue: TMonaStringList): boolean;
    class operator GreaterThan(const a: TMonaStringList;
      const b: AnsiString): boolean;

  end;

  TMonaStringListhELPER = RECORD HELPER FOR TMonaStringList
    function Intersec(const oma: TMonaStringList): integer;

  end;

var
  TamBufTex: word = 5000;

Type

  TMonaText = record
  private
    tx_: Text;
    BUF_: Pointer;
    Auto: TRecAutoDone;

    procedure SetBuffer;
    procedure FreeBuffer;

  public
    Procedure WriteLns(const valores: SString);
    Procedure WriteLnst(const valores: array of const);

    function InitWrite(const na: TUrlFile): boolean;
    function InitRead(const na: TUrlFile): boolean;

    procedure Done;

    Procedure Asigna(const n: SysString);

    Function IsOpen: boolean;
    function TestIost_: boolean;
    Function Nombre: SString;
    Function Asignado: boolean;
    function eoftexto: boolean;
    Function readst: SString;

    procedure Closes;
  end;

type

  (*
    TMonaFile.
    Encapsula el nombre de un fichero forma monadica.
    Realiza diferentes transformaciones como leer el contenido del fichero
    Es equivalente a usar una string, pero con más poderes.
    Se usa muy relacionado a TMonaDirectory
  *)

  TMonaFile = record
    Context_: TSelfEnumerator;
    FileName: TUrlFile;

    function FileContent(maxi: integer = 0): StreamString;

    // private

    Function PathRoots(): SysString;
    function MoveFile(const Newpath: SString): boolean;
    // function AppendText_: TMonaText;
    Function Path(): SysString;

    function SaveToFile(const s: SString): boolean;
    function NameFull: SString;

    Function Info: PSearchrec;

    function Size: Int64;

    function SimpleName: SString;
    procedure DeleteIfEmpty();

    Function Exists(): boolean;
    Function DelFile(): boolean;
    function AsStringList: TMonaStringList;
    procedure InitFix(const aValue: SString; con: Pointer = nil);

    procedure Init(const aValue: SString; con: Pointer);
    procedure Done;

    function HasText(const search: SString): boolean;

    Procedure FixPath();
  public
    class operator Implicit(const aValue: TInfoEnumerator): TMonaFile;
    class operator Implicit(const aValue: TSelfEnumerator): TMonaFile;
    class operator Implicit(const aValue: TMonaFile): SString;
    class operator Implicit(const aValue: TMonaFile): PSearchrec;
    class operator Implicit(const aValue: TMonaFile): boolean;

    class operator Implicit(const aValue: SString): TMonaFile;
    // class operator Implicit(const aValue: TMonaFile): TMonaFile;

    class operator Divide(const aValue: TMonaFile; maxi: integer): SString;

  end;

  PMonaFile = ^TMonaFile;
function FileRenameFile(const OldName, NewName: SString): boolean;

Function ExistFile(const nam: TMonaFile): boolean;
function IsBarra(const c: SChar): boolean;
function DostoUnix(const Path: SString): SString;
function Unix2Win(const na: SysString): SysString;
Function Sospath(const na: TUrlFile): TUrlFile;
Procedure FixPath_(var na: SysString);
Function PathNomExt_(const d: SysString): TUrlFile;

Function Exists(const Name: TUrlFile): boolean;
function Unix2Dos(const Path: SString): SString;

function LastChar(const s: SString): integer; inline;

procedure ReplaceCharss___(var St: SString; const ch1, ch2: SChar);
function ValReal(const St: SString): Double;

function ValoraInt(s: SString): longint;

var
  KfastAtIndex__: boolean = false;

type

  TxSearchEnumeratorInfo = class(TBaseSearchEnumerator)
  public
    constructor Create(const ds: PSearchData;
      const comp: TObject = nil); virtual;

    function GetCurrent: TMonaFile;
    property Current: TMonaFile read GetCurrent;
  end;

  TFactorySearch = class(TxEnumFactory)
    data: TSearchData;
    constructor FactoryFiles(const dir: SString; const masc_: SString = '';
      contexto: Pointer = nil);
    constructor FactoryDirs(const dir: SString; contexto: Pointer = nil);
    function Filtro(const busca: SString): TFactorySearch;
    function GetEnumerator: TxSearchEnumeratorInfo;
  end;

type
  TMonaFileStream = Record
  private
    stream: TStream;

    procedure Init(const aValue: TStream = nil; esdel: boolean = True);
    Procedure InitOpen(const fn: TUrlFile);
    procedure InitMemory;
    procedure Done;
    function Size: Int64;
    function ReadFirtString(maxi: integer = 0): SString;
  strict private
    Tododel: boolean;
    function Ok: boolean;
    function GetPosition: Int64;
    Procedure SetPosition(const po: Int64);

  public
    property Position: Int64 read GetPosition write SetPosition;
    class operator Implicit(const aValue: TUrlFile): TMonaFileStream;
    class operator Implicit(const aValue: TMonaFile): TMonaFileStream;
  End;

function GetFileAnsi(const pathName: TMonaFile; maxi: integer = 0)
  : StreamString;

function SaveStringData(const Name: TUrlFile; const data: StreamString;
  createDir: boolean = false): boolean;
// function GetFileAnsiClear(const pathName: TUrlFile; maxi: integer): SString;

type

  TLamdaInfoFileCount = // reference to
    function(const s: TMonaFile): integer;

  TMonaDirectory = Record
    contexto_: Pointer;
    root: TUrlFile;
    procedure Init(const aValue: TUrlFile; con: Pointer = Nil);
    procedure InitPath(const aValue: TMonaFile);
    procedure Done;
    function DirCountRecursive(): integer;
    function Nulo: boolean;
    function Barra_(const mas: SString = ''): TUrlFile;
    function SinBarras: TUrlFile;
    function ChildDirs: TFactorySearch;
    function ChildFiles(const masc: SString = ''): TFactorySearch;
    procedure DelFileMask(const Mask: SString);
    FUnction MakeDir(): integer;
    Function OwnerPath(): TMonaDirectory;
    Function pathName(): SString;

    function Existe: boolean;
    class operator Implicit(const aValue: TMonaDirectory): TUrlFile;
    class operator Implicit(const aValue: TUrlFile): TMonaDirectory;
    class operator Implicit(const aValue: TMonaFile): TMonaDirectory;
    class operator Implicit(const aValue: TInfoEnumerator): TMonaDirectory;
    // s:=T*'campo'
    class operator Subtract(const aValue: TMonaDirectory; const s: SString)
      : TMonaFile;

    class operator Multiply(const aValue: TMonaDirectory; const s: SString)
      : TFactorySearch;
    (*
      class operator Divide(const aValue: TMonaDirectory;
      const S: sString): TMonaFile;
    *)
    class operator Divide(const aValue: TMonaDirectory; const s: SString)
      : TMonaDirectory;

  end;

function NewAutoDone(const aValue: Pointer; const doproc: TDoneProc = nil)
  : IAutoDone;

function NewAutoDoneClass(const aValue: Pointer; const doproc: TDoneProc = nil)
  : TClassAutoDone;

Function PathAs(const d: TUrlFile): TUrlFile;
function GetDirCount_(const dir: TMonaDirectory): integer;
Function ExisteDir(const nam: TUrlFile): boolean;
Function PathRoot(const pa: TUrlFile): SysString;
FUnction MakeDir(const Nombre: TMonaDirectory): integer;
FUnction TestMakeDir(const Nombre: TUrlFile): integer;

FUnction TestMakeDirPath_(const Nombre: TUrlFile): integer;
Function DirecNombres_(const d: TUrlFile; const nn: SysString): TUrlFile;
Function ConBarra(const Name: TUrlFile): TUrlFile;
Function SinBarra(const s: TUrlFile): TUrlFile;
Function DirecNombre(const d: TUrlFile; const nn: TUrlFile): SysString;
Function SumBarraMas(const s, nn: SysString): SysString;
Function PathRootOwner(const pa: TUrlFile): TUrlFile;
Function PathRootSin(const pa: TUrlFile): TUrlFile;

Function PathRootDir(const pa: TUrlFile): TMonaDirectory;

Function ActualDos: SString;
Procedure Fsplit__(const d: TUrlFile; var di, no, ex: SysString);
Function PathFileExtension(const d: SysString): SysString;
// Function PathCaminos(const nm1: SysString): SysString;
procedure RenameFicheros(const masc1: SysString; const d2, n2, e2: SString);

type
  TExe = record
    Dirinicial_: TMonaDirectory; // TUrlFile;
    DirDatos: SString;
    Function DirApps(const na: TUrlFile): TUrlFile;
    function ExeFile: TUrlFile;
    function ParamStr0: TUrlFile;

    Function DirRaizBarra: TUrlFile;
    function RootDir: TUrlFile;
    function ExePath_: TUrlFile;
    Function DirNombres_(const s: TUrlFile): TUrlFile;
    Function FileDirActual(const na: TUrlFile): TUrlFile;
    function ExePathSinRoot: TUrlFile;
    Function Ospath(const Name: TUrlFile): TUrlFile;
    class operator Divide(const exe: TExe; const s: TUrlFile): TUrlFile;

  private
    // - same as paramstr(0)
    ProgramFileName_: TUrlFile;

    Procedure Init;
    Procedure Done;

  end;

var
  ExeVer: TExe;

type
  TBytex = array of Byte;

  { TBufferedFileStream class }

  TBufferFileStream = class(TFileStream)
  private
    FFilePos, FBufStartPos, FBufEndPos: Int64;
    FBuffer: PByte;
    FBufferSize: integer;
    FModified: boolean;
    FBuffered: boolean;
    FSize: Int64;
  protected
    procedure SetSize(const NewSize: Int64); override;
    procedure DimBuffer(BufferSize: integer);
    procedure DoneBuffer;

    procedure SyncBuffer(ReRead: boolean);
  public
    constructor CreateRead(const AFileName: SString;
      BufferSize: integer = 32768); overload;
    constructor Create(const AFileName: SString; mode: word;
      BufferSize: integer = 32768); overload;
    constructor Create(const AFileName: SString; mode: word; Rights: Cardinal;
      BufferSize: integer = 32768); overload;
    destructor Destroy; override;
    /// <summary>
    /// FlushBuffer writes buffered and not yet written data to the file.
    /// </summary>

    procedure FlushBuffer; // inline;
    function Read(var Buffer; Count: longint): longint; override;
    function Write(const Buffer; Count: longint): longint; override;
    function Readx(Buffer: TBytex; offset, Count: longint): longint; overload;
    // override;
    function Writex(const Buffer: TBytex; offset, Count: longint): longint;
      overload; // override;
    function Seek(const offset: Int64; Origin: TSeekOrigin): Int64; override;
    function ReadLn_: StreamString;
    function Eofs: boolean;
    function FilePos: Int64;
  end;

type

  TAnsiStream = Record
  public
    Procedure Init(const localName: SString);
    procedure Done;
    // function AnsiReadLn__: StreamString;
    function Eofs: boolean;

  private
    MyStream_: TBufferFileStream;
    FFileName: SString;

    function stream_: TStream;
    class operator Implicit(const aValue: TUrlFile): TAnsiStream;

  end;

  TAnsiReaderEnumerator = class(TEnumerator)
  public
    constructor Create(const fn: SString); reintroduce;
    Destructor Destroy; override;
    function MoveNext: boolean; virtual;
    function GetCurrent: SString;
    property Current: SString read GetCurrent;
  private
    MyStream: TBufferFileStream;
    FileName: SString;
  end;

  TMonaAnsiReader = Record
  public
  private
    function GetEnumerator: TAnsiReaderEnumerator;
    procedure Init_(const fina: TUrlFile);

  private
    FileName: TUrlFile;
  public
  private
    class operator Implicit(const aValue: TUrlFile): TMonaAnsiReader;
    class operator Implicit(const aValue: TMonaFile): TMonaAnsiReader;
    class operator Implicit(const aValue: TMonaAnsiReader): TMonaFile;
    class operator Implicit(const aValue: TInfoEnumerator): TMonaAnsiReader;

  end;

  TFuncionXdb = function(const incam: SString): SString;

function Ssum(const valores: array of const): SysString;
Procedure Freenil(var oo); overload;
Function Max(a, b: longint): longint;
function Min(a, b: longint): longint; inline;

function PosIgual(const str: SString): integer;

procedure WarningX(const valores: SString);
Procedure AsignaString1(var ms: TMixString; const s: SString);
function StringSum(const valores: array of SysString): SysString;
function Str2Int(const s: SString): integer;
function PosEx(const substr, s: SString; offset: integer = 1): integer;
function PosExZes(const substr, s: SString; offset: integer = 1): integer;
// Function DisplayTextMasMenos_(const St: SString): SString;
function FetchValAnsi(var s1: SString): SString;
function FindReplace(const ss: SString; const find, replace: SString): SString;
Function Texts(a: TStrings): SString;
// function Fetch_(var s1: SString; const sDelim: SString): SString;
function SplitSt_(const cadena: SString): TxStringList;
Function Upst(const s: SysString): SysString; overload;
function CharPosA__(Ch_: SChar; const str: SString): integer;

function CompareMixs(const s1: SString; const ps2: SPChar;
  lon2: integer): integer;
function CompareMixIgual(const s1: SString; const ps2: SPChar;
  lon2: integer): boolean;
Function MiTrim_(const aString: SString): SString;
Function SLast(a: TStrings): integer;

function LoadStrings(const Name: SString): TxStringList;
function LoadStringFromFile_(listaString: TxStringList;
  const Name: SysString): boolean;
function CreaSt: TxStringList;
function CreaStauto: TAutoStringList;
procedure FreeListNodes(var lista: TxStringList); // inline;
Procedure NulString(var ms: TMixString); inline;

Procedure AsignStr(var ms: TMixString; const s: SString);
function SumMix(const aValue1, avalue2: TMixString): SString;
function Picks___(n: integer; const valores: array of const): SString;
function SCount_(re: TStrings): integer;
function EsVacia(const St: SString): boolean;
function Fetchar(sDelim: SChar; var s1: SString): SString; overload;
function FetchValDel(var s1: SString): SString;
function PosChar(const c: SChar; const s: SString): integer;
function Posi(const substr, str: SString): integer; overload;
function StIntS(Value: integer): SString;
function StrPosL(uppersubstr, str: SPChar; lon: integer): SPChar;
function CharInSt(ch: SChar; const str: SString): boolean;
function Int64Str(Value: Int64): SString;

function ValInt(const s: SString): longint;

function SumMixPP(const aValue1: SPChar; le1: integer; const avalue2: SPChar;
  le2: integer): SString;
function IGUALESSS(const na1, na2: SString): boolean;
procedure TodoError(const mas: SysString = '');
Function LIMPIASt(var s: SString): boolean;

Function CopyZero(const n: SString; ini, lon: integer): SString;
function FindReplacechar_(const ss: SString;
  const find, replace: SChar): SString;

const
  EOLs: array [0 .. 1] of SChar = (#13, #10);

type
  TLogEnums = function(const modo: TModeEnum; const enum: TEnumerator): boolean;

  TLogStaticEnum = function(const modo: TModeEnum; const enum: integer;
    const clase: TClass = nil): integer;

procedure Prints(const datos: string);
procedure Printsys(const datos: array of const);

var
  LogEnums_: TLogEnums = Nil;
  LogStatic_: TLogStaticEnum = nil;

type

  TAnsiStreamHelper = class helper for TStream

  public
    function CharSize: integer;
    procedure wmx(const mx: TMixString);
    procedure Writa(const St: StreamString);
    procedure wln(const St: SString);
    procedure __(const data: array of const);
    function WrBytes(const Buffer; Count: longint): longint;
    procedure WriteChar(const ch: SChar);
    function ReadString(Max: Int64): StreamString;
    function ReadStreamMax__(maxLen: integer = 0): StreamString;
    function ReadStreams(ini, maxLen: integer): StreamString;
  end;

var
  Osxver_: Tosversion = Toswin;

type

  PArrayParser = ^TMonaParser;

  TStaticParserEnumerator = class(TEnumerator)
    constructor Create(const ds: PArrayParser;
      const ps: PSetchar = nil); virtual;

  public
    function MoveNext: boolean; // virtual;
    function GetCurrent: PMixString;
    property Current: PMixString read GetCurrent;

  private
    function getnextwords(): boolean;

  private
    pset: PSetchar;
    ss: SString;
    mix: TMixString;
    i1: integer;
  end;

  TMonaParser = packed record
    function GetEnumerator: TStaticParserEnumerator;

  private
    s: SString;
    pset: PSetchar;
    procedure InitComa(const os: SString);
    procedure InitComas(const os: SString);

    procedure IniParser(const os: SString; const ps: PSetchar = nil);
    procedure InitFromFile(const nafi: TMonaFile);
    class operator Implicit(const aValue: SString): TMonaParser;
    class operator Implicit(const aValue: TMonaFile): TMonaParser;

  end;

function SerializaString(const sss: SString): TMonaStringList;

procedure WarningRaroS_(const _valor: SysString; const o: TObject = Nil);
procedure WarningRaro(const valores: array of const);
procedure WarningTodo(const valores: array of const);
procedure WarningException_(const e: Exception; const tit: SString);

type

  StringScript = String;

  TScriptRequest = record
    Source: String;
    ClearMem: boolean;
    procedure Init(const s: String = ''; doclear: boolean = True);
    procedure Inits(const a: array of const);

    function Command: String;
    function IsCommand(const a: array of String): boolean;
    function Serializas_(): TMonaStringList;
    function SerialVariant(out met: string): Variant;

    class operator Implicit(const aValue: TScriptRequest): String;
    class operator Implicit(const aValue: String): TScriptRequest;
  end;

  TScriptResponse = record
    respon: String;
    procedure Init(const s: String = '');
    procedure Error(const s: String);
    function AsString: String;
    class operator Implicit(const aValue: TScriptResponse): String;
    class operator Implicit(const aValue: String): TScriptResponse;

  end;

  IScript = interface
    ['{5AAAA3AF-8530-4849-89D5-F6F24393CDAD}']
    function Runs(const req: TScriptRequest): TScriptResponse;
  end;

  TScriptAbstract = class(TInterfaceObject, IScript)
    fObject: TObject;
    constructor Create(const obj: TObject = nil); reintroduce; overload;
    destructor Destroy; override;
    function Runs(const req: TScriptRequest): TScriptResponse; virtual;
  end;

  tFunInjectScript = function: IScript;


  TMonaScript = record
    Script: IScript;
    procedure Init(const Si: IScript = nil);
    function Run(const a: StringScript): StringScript;
    function Ok: boolean;

    procedure Done;
  end;


  TFunRequestResponse = function(const request: TScriptRequest;
    contexto: Pointer): TScriptResponse;

  pCommandReqRes = ^TCommandReqRes;

  TCommandReqRes = record
  private
    Command: String;
    fun: TFunRequestResponse;
    contexto: Pointer;

    function RunFun(const req: TScriptRequest): TScriptResponse;
    Procedure Init(const com: String = ''; const f: TFunRequestResponse = nil;
      contex: Pointer = nil);
  end;



  TResponserSimple = Class;

  TCommandReqResArray = record
    Procedure Inits;
    procedure Done;
    function Add(const lab: String; f: TFunRequestResponse;
      contexto: Pointer = nil): pCommandReqRes;
    function CreateResponser(const nameser: string = ''): TResponserSimple;
    function InjectResponse(): IScript;

  private
    commands: array of TCommandReqRes;
    function Count: integer;
    function Finds(const lab: String): pCommandReqRes;
    function RunSim(const req: TScriptRequest): TScriptResponse;
  end;

  PCommandReqResArray = ^TCommandReqResArray;

  TResponserSimple = class(TScriptAbstract)
    constructor Create(const obj: TObject = nil); reintroduce; overload;
    destructor Destroy; override;
    function Runs(const req: TScriptRequest): TScriptResponse; override;

  public
    Script: PCommandReqResArray;
  end;

  TTypeRuntimeResult = Record
    resulta: String;
    procedure Reset;
    procedure Print(const s: String);
  End;

procedure ReplaceCOMAs(var St: SysString);
function StLlena(c: Char; l: integer): SString;
function StCode2(n: integer): SString;
function Spaces(l: integer): SString;
function CharPosEXZero(const SearchCharacter: SChar;
  const SourceString: SString; StartPos: integer): integer;
  function GetRandomString(numChar: cardinal): SString;





implementation

uses
  // ToDo_FockString,
  Windows,
  variants;

type
{$IFDEF xe5}

  TFastMatchStringLis = class(TStrings)
  private
  public
    List: TStringItemList;
    FCount: integer;
    FCapacity: integer;
    FSorted: boolean;
    FDuplicates: TDuplicates;
    FCaseSensitive: boolean;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
    FOwnsObject: boolean;
    FCompareStringsOverriden: boolean;
    // ?    FOwnsObject_: Boolean;
  public
    // property List: TStringItemList read FList;
    property DCount_: integer read FCount;
  end;

{$ELSE xe5}


  TFastMatchStringLis = class(TStrings)
  private
  public
    FList: PStringItemList;
    FCount: integer;
    FCapacity: integer;
    FSorted: boolean;
    FDuplicates: TDuplicates;
    FCaseSensitive: boolean;
    FOnChange_: TNotifyEvent;
    FOnChanging_: TNotifyEvent;
    // ?    FOwnsObject_: Boolean;
  public
    property List: PStringItemList read FList;
    property DCount_: integer read FCount;
  end;

{$ENDIF xe5}

function LongEnumera(data: Pointer): integer;
begin
  if data = nil then
  begin
    result := 0
  end
  else
  begin
    result := TFastMatchStringLis(data).Count
  end;
end;

function GetCurrentString(data: Pointer; fIndex: integer): SString;
begin
  result := TFastMatchStringLis(data).List[fIndex].FString;
end;

{ TMonaFileStream }

Procedure Freenil(var oo); overload;
var
  mio: TObject;
begin

  // try
  mio := TObject(oo);
  if mio = nil then
  begin
    // mio := TObject(oo);
    exit;
  end;

  TObject(oo) := Nil;
  mio.free;
  /// TObject(oo) := Nil;
  // exit;

end;

function GetStreamFile(const pathName: SysString): TMonaFileStream;
begin
  result.Init(TFileStream.Create(pathName, fmOpenRead or fmShareDenyNone));
end;

procedure TMonaFileStream.Done;
begin
  Freenil(stream);
end;

procedure TMonaFileStream.Init(const aValue: TStream = nil;
  esdel: boolean = True);
begin
  stream := aValue;
  Tododel := esdel;
end;

class operator TMonaFileStream.Implicit(const aValue: TUrlFile)
  : TMonaFileStream;
begin
  result := GetStreamFile(aValue)
end;

class operator TMonaFileStream.Implicit(const aValue: TMonaFile)
  : TMonaFileStream;
begin
  result := GetStreamFile(aValue)
end;

function TMonaFileStream.Size: Int64;
begin
  if stream = nil then
  begin
    result := 0
  end
  else
  begin
    result := stream.Size;
  end;
end;

function TMonaFileStream.Ok: boolean;
begin
  result := stream <> nil;
end;

Procedure TMonaFileStream.InitOpen(const fn: TUrlFile);
var
  n: TMonaFile;
begin
  n.InitFix(fn);
  if n.Exists then
  begin
    Init(TFileStream.Create(n, fmOpenRead or fmShareDenyNone));
  end
  else
  begin
    Init();
  end;
end;

procedure TMonaFileStream.InitMemory;
begin
  Init(TMemoryStream.Create);
end;

function TMonaFileStream.ReadFirtString(maxi: integer = 0): SString;
var
  lon: Int64;
begin
  result := '';
  try
    lon := Size;
    if (maxi > 0) and (lon > maxi) then
    begin
      lon := maxi;
    end;
    Position := 0;
    if lon > 0 then
    begin
      result := stream.ReadString(lon);
    end;

  except
    result := '';
  end;
end;

function GetFileAnsi(const pathName: TMonaFile; maxi: integer = 0)
  : StreamString;
var
  fs: TMonaFileStream;
begin
  result := '';
  if not pathName.Exists then
  begin
    exit;
  end;
  try
    fs := pathName; // GetStreamFile(sn);
    try
      result := fs.ReadFirtString(maxi)
    finally
      fs.Done;
    end;
  except
    result := '';
  end;
end;

procedure TMonaFileStream.SetPosition(const po: Int64);
begin
  if stream <> nil then
  begin
    stream.Position := po
  end;
end;

function TMonaFileStream.GetPosition: Int64;
begin
  if stream = nil then
  begin
    result := 0
  end
  else
  begin
    result := stream.Position
  end;
end;

function MakeStreamName(const Name: TUrlFile): TFileStream;
Begin
  result := TFileStream.Create(Sospath(name), fmCreate);
end;

function SaveStringData(const Name: TUrlFile; const data: StreamString;
  createDir: boolean = false): boolean;
var
  fs: TFileStream;
Begin
  result := false;
  if data <> '' then
  begin
    if createDir then
    begin
      TestMakeDir(name);
    end;
    fs := MakeStreamName(Sospath(name));
    try
      fs.Writa(data);
      result := True;
    finally
      Freenil(fs);
    end;
  end;
end;

Function TMonaFile.Path(): SysString;
begin
  result := PathRoot(NameFull);
end;

class operator TMonaFile.Implicit(const aValue: TMonaFile): boolean;
begin
  result := aValue.FileName <> ''
  // Context.sr
end;

class operator TMonaFile.Implicit(const aValue: TMonaFile): PSearchrec;
begin
  result := aValue.Info
  // Context.sr
end;

function TMonaFile.AsStringList: TMonaStringList;
begin
  result.Init(LoadStrings(NameFull));
end;

function TMonaFile.DelFile: boolean;
begin
  try
    result := sysutils.DeleteFile(NameFull)
  except
    result := false
  end;
end;

class operator TMonaFile.Divide(const aValue: TMonaFile; maxi: integer)
  : SString;
begin
  result := aValue.FileContent(maxi)
end;

procedure TMonaFile.Done;
begin
  FileName := '';
  Context_ := nil;
end;

Function TMonaFile.Exists(): boolean;
begin
  result := FileExists(NameFull); // SYsUtils.exi
end;

function TMonaFile.SimpleName: SString;
begin
  if Context_ = nil then
  begin
    result := PathNomExt_(FileName)
  end
  else
  begin
    result := TBaseSearchEnumerator(Context_).sr.Name
  end;
end;

function TMonaFile.NameFull: SString;
begin
  result := FileName;
  if result = '' then
    if Context_ <> nil then

      result := TBaseSearchEnumerator(Context_).NameFileActual
end;

function tamanoFichero(const sFileToExamine: SString): integer;
var
  SearchRec: tSearchrec;
  sgPath: SString;
  inRetval, i1: integer;
begin
  sgPath := PathNomExt_(sFileToExamine);
  try
    inRetval := FindFirst(ExpandFileName(sFileToExamine), faanyfile, SearchRec);
    if inRetval = 0 then
      i1 := SearchRec.Size
    else
      i1 := -1;
  finally
    sysutils.FindClose(SearchRec);
  end;
  result := i1;
end;

function TMonaFile.Size: Int64;
begin
  if Context_ = nil then
  begin
    result := tamanoFichero(NameFull)
  end
  else
  begin
    result := TBaseSearchEnumerator(Context_).sr.Size
  end;
end;

class operator TMonaFile.Implicit(const aValue: TMonaFile): SString;
begin
  result := aValue.NameFull
end;

{ TMonaFile }

procedure TMonaFile.Init(const aValue: SString; con: Pointer);
begin
  FileName := aValue;
  FixPath_(FileName);
  Context_ := con;
end;

procedure TMonaFile.InitFix(const aValue: SString; con: Pointer);
begin
  FileName := aValue;
  Context_ := con;
  FixPath;
end;

class operator TMonaFile.Implicit(const aValue: TSelfEnumerator): TMonaFile;
begin
  result.Init(TBaseSearchEnumerator(aValue).NameFileActual, aValue)
end;

function TMonaFile.HasText(const search: SString): boolean;
var
  Gets: SString;
begin
  if search = '' then
  begin
    result := True
  end
  else
  begin
    Gets := FileContent();
    result := System.Pos(search, Gets) > 0
  end;
end;

Function TMonaFile.PathRoots(): SysString;
begin
  result := PathNomExt_(NameFull);
end;

class operator TMonaFile.Implicit(const aValue: SString): TMonaFile;
begin
  result.Init(aValue, nil);
end;

class operator TMonaFile.Implicit(const aValue: TInfoEnumerator): TMonaFile;
var
  m: TBaseSearchEnumerator;
begin
  m := TBaseSearchEnumerator(aValue);
  result.Init(m.NameFileActual, m)
  // result.Context_ := TBaseSearchEnumerator(aValue.Base)
  // fileName := aValue;
end;

Function ExistFile(const nam: TMonaFile): boolean;
begin
  result := nam.Exists
end;

function IsBarra(const c: SChar): boolean;
begin
  result := (c = '\') or (c = '/')
end;

function Unix2Win(const na: SysString): SysString;
begin
  result := na;
  FixPath_(result);
end;

Function Sospath(const na: TUrlFile): TUrlFile;
begin
  case Osxver_ of
    Toswin:
      result := Unix2Win(na);
  else
    result := DostoUnix(na);
  end;
end;

Function PathNomExt_(const d: SysString): TUrlFile;
begin
  result := ExtractFileName(d);
end;

Function Exists(const Name: TUrlFile): boolean;
begin
  result := FileExists(name);
end;

Function TMonaFile.Info: PSearchrec;
begin
  result := @TBaseSearchEnumerator(Context_).sr
end;

function FileRenameFile(const OldName, NewName: SString): boolean;
begin
  result := RenameFile(OldName, NewName);
end;

procedure ReplaceCharss___(var St: SString; const ch1, ch2: SChar);
var
  i: integer;
  uni: boolean;
Begin
  uni := True;
  for i := 1 to Length(St) do
  Begin
    if St[i] = ch1 then
    begin
      if uni then
      begin
        uni := false;
        UniqueString(St);
      end;
      St[i] := ch2;
    end;
  end;
end;

Procedure TMonaFile.FixPath();
begin
{$IFDEF android}
  ReplaceCharss___(FileName, '\', '/');
{$ELSE android}
  ReplaceCharss___(FileName, '/', '\');
{$ENDIF android}
end;

Procedure FixPath_(var na: SysString);
begin
{$IFDEF android}
  ReplaceCharss___(na, '\', '/');
{$ELSE android}
  ReplaceCharss___(na, '/', '\');
{$ENDIF android}
end;

function LastChar(const s: SString): integer; inline;
begin
  result := Length(s) - HiSt
end;

function FindReplacechar_(const ss: SString;
  const find, replace: SChar): SString;
var
  i: integer;
  uni: boolean;
  repla: SString;
begin
  repla := ss;
  uni := True;
  for i := LowSt_ to LastChar(repla) do
  Begin
    if repla[i] = find then
    begin
      if uni then
      begin
        UniqueString(repla);
        uni := false;
      end;
      repla[i] := replace;
    end;
  end;
  result := repla;
end;

function DostoUnix(const Path: SString): SString;
begin
  result := FindReplacechar_(Path, '\', '/');
end;

function Unix2Dos(const Path: SString): SString;
begin
  result := FindReplacechar_(Path, '/', '\');
end;

function TMonaFile.FileContent(maxi: integer): StreamString;
begin
  result := GetFileAnsi(NameFull, maxi);
end;

function TMonaFile.SaveToFile(const s: SString): boolean;
begin
  result := SaveStringData(NameFull, s,true);
end;

function TMonaFile.MoveFile(const Newpath: SString): boolean;
var
  Nombre, nuevo: SString;
begin
  Nombre := SimpleName; // PathNomExt_(NameFull);
  nuevo := DirecNombre(Newpath, Nombre);
  TestMakeDir(nuevo);
  result := sysutils.RenameFile(NameFull, nuevo)
end;

procedure TMonaFile.DeleteIfEmpty();
var
  f: file;
  Size: integer;
begin
  Size := 1;
  try
    AssignFile(f, FileName);
    Reset(f, 1);
    Size := System.FileSize(f);
    System.CloseFile(f);
  except
  end;
  if Size = 0 then
  begin
    sysutils.DeleteFile(FileName);
  end;
end;

Procedure DOneMonaText(p: Pointer);
begin
  TMonaText(p^).Done;
end;

Procedure TMonaText.WriteLns(const valores: SString);
Begin
  Writeln(tx_, valores);
  TestIost_;
end;

Procedure TMonaText.WriteLnst(const valores: array of const);
Begin
  if IsOpen then
  begin
    WriteLns(Ssum(valores));
  end;
end;

procedure TMonaText.Closes;
begin
  if IsOpen then
  begin
    CloseFile(tx_);
  end;
  ttextRec(tx_).mode := fmclosed;
  TestIost_;
  FreeBuffer;
end;

procedure TMonaText.FreeBuffer;
begin
  if BUF_ <> nil then
  BEGIN
    System.freemem(BUF_, TamBufTex);
    BUF_ := nil;
  END;
end;

Function TMonaText.IsOpen: boolean;
Begin
  IsOpen := not(ttextRec(tx_).mode = fmclosed);
end;

Function TMonaText.Asignado: boolean;
Begin
  Asignado := (Nombre <> '');
end;

Function TMonaText.Nombre: SString;
Begin
  Nombre := StrPas(ttextRec(tx_).Name);
end;

function TMonaText.eoftexto: boolean;
Begin
  if IsOpen then
    eoftexto := eof(tx_)
  else
    eoftexto := True;
end;

Function TMonaText.readst: SString;
Begin
  readln(tx_, result);
  TestIost_;
end;

function TMonaText.TestIost_: boolean;
var
  iost: word;
Begin
  iost := ioresult;
  result := True;
end;

Procedure TMonaText.Asigna(const n: SysString);
var
  o: SString;
begin
  Closes;
  o := n;
  System.Assign(tx_, o);
end;

procedure TMonaText.SetBuffer;
Begin
  if BUF_ = nil then
    System.getmem(BUF_, TamBufTex);
  setTextBuf(tx_, BUF_^, TamBufTex);
  Auto.SetObj_(@self, DOneMonaText);
end;

procedure TMonaText.Done;
begin
  Auto.Done;
  Closes;
end;

function TMonaText.InitWrite(const na: TUrlFile): boolean;
begin
  BUF_ := nil;
  ttextRec(tx_).mode := fmclosed;
  Auto.Init;
  Asigna(na);
  if ExistFile(na) then
  begin
    Append(tx_)
  end
  else
  begin
    TestMakeDirPath_(na);
    Rewrite(tx_);
  end;
  result := TestIost_
end;

function TMonaText.InitRead(const na: TUrlFile): boolean;
begin
  BUF_ := nil;
  ttextRec(tx_).mode := fmclosed;
  Auto.Init;
  Asigna(na);
  SetBuffer;
  if ExistFile(na) then
  begin
    Reset(tx_);
    result := TestIost_
  end
  else
  begin
    result := false
  end;
end;

Procedure DOneMonaStringList(p: Pointer);
begin
  TMonaStringList(p^).Done;
end;

function TMonaStringList.AddIFNot(const s: SString;
  const aObject: TObject = nil): integer;
begin
  if Strings = nil then
  begin
    result := -1;
    exit;
  end;
  if IndexObject(s) = aObject then
  begin
    result := -1;
    exit;
  end;
  result := ss_.AddObject(s, aObject)
end;

function TMonaStringList.AddIF(const s: SString): integer;
begin
  result := IndexOf(s);
  if result < 0 then
  begin
    result := ss_.AddObject(s, nil)
  end;
end;

function TMonaStringList.AddCount(const s: SString): integer;
var
  va: SString;
begin
  va := Value(s);
  result := ValInt(va) + 1;
  ss_.Values[s] := StIntS(result);
end;

function TMonaStringList.SaveFile__(const fina: SString): boolean;
begin
  result := false;
  if ss_ <> nil then
  begin
    try
      ss_.SaveToFile(fina);
      result := True;
    except
      result := false;
    end;
  end;
end;

function TMonaStringList.LoadFile(const fina: SString): boolean;
begin
  result := false;
  if Strings <> nil then
  begin
    try
      result := LoadStringFromFile_(Strings, fina);
    except
      result := false;
    end;
  end;
end;

function TMonaStringList.Inited: boolean;
begin
  result := ss_ <> nil
end;

function TMonaStringList.Count: integer;
begin
  result := SCount_(ss_)
end;

function TMonaStringList.DoneString: TxStringList;
begin
  result := ss_;
  ss_ := nil;
end;

function TMonaStringList.Add(const s: StringModel): integer;
begin
  result := Strings.Add(s)
end;

procedure TMonaStringList.Clear;
begin
  if Strings = nil then
  begin
    exit
  end;
  ss_.Clear;
end;

procedure TMonaStringList.Done;
begin
  Auto.Done;
  Freenil(ss_);
end;

procedure TMonaStringList.InitAnd(const cadena: SString);
var
  ac, co: SString;
begin
  Init;
  co := cadena;
  while co <> '' do
  begin
    ac := Fetchar('&', co);
    Add(ac)
  end;
end;

procedure TMonaStringList.InitText(const cadena: SString);
var
  ss: TxStringList;
begin
  Init;
  ss := Strings;
  if ss <> Nil then
  begin
    ss.Text := cadena
  end;
end;

function TMonaStringList.IndexObject(const s: SString): TObject;
begin
  if Strings = nil then
  begin
    result := Nil;
    exit;
  end;
  result := ss_.IndexObject(s);
end;

class operator TMonaStringList.Implicit(const aValue: TxStringList)
  : TMonaStringList;
begin
  result.Init(aValue);
end;

class operator TMonaStringList.Implicit(const aValue: TMonaStringList)
  : TStrings;
begin
  result := aValue.ss_
end;

class operator TMonaStringList.Implicit(const aValue: TMonaStringList)
  : TxStringList;
begin
  result := aValue.ss_
end;

class operator TMonaStringList.Implicit(const aValue: TMonaStringList): boolean;
begin
  result := aValue.ss_ <> nil
end;

class operator TMonaStringList.GreaterThan(const a: TMonaStringList;
  const b: AnsiString): boolean;
begin
  result := a.SaveFile__(b);
end;

procedure TMonaStringList.Init(const no: TxStringList);
begin
  ss_ := no;
  Auto.Init;
end;

procedure TMonaStringList.setAtrib(const a, v: StringModel);
begin
  if ss_ <> nil then
  begin
    ss_.SetAttribute(a, v)
  end;
end;

function TMonaStringList.Value(const nam: SString): SString;
begin
  if Strings = nil then
  begin
    result := ''
  end
  else
  begin
    result := ss_.Values[nam]
  end;
end;

function TMonaStringList.St(const nam: integer): SString;
begin
  if Strings = nil then
  begin
    result := ''
  end
  else
  begin
    result := ss_[nam]
  end;
end;

function TMonaStringList.Strings: TxStringList;
begin
  if ss_ = nil then
  begin
    ss_ := CreaSt;
    Auto.SetObj_(@self, DOneMonaStringList);
  end;
  result := ss_;
end;

function TMonaStringList.Text: SString;
begin
  if ss_ = nil then
  begin
    result := '';
  end
  else
  begin
    result := ss_.Text;
  end;
end;

function TMonaStringList.GetEnumerator: TEnumeratorRecord;
begin
  result.InitListString(ss_)
  // result.Init_(self,LongEnumera,GetCurrentString);
end;

function TMonaStringList.GetSt(const nam: SString): SString;
begin
  if Strings = nil then
  begin
    result := '';
  end
  else
  begin
    result := ss_.Values[nam]
  end;
end;

function TMonaStringList.Intersecion(const oma: TxStringList): integer;
var
  i: integer;
begin
  result := 0;
  if oma = nil then
  begin
    exit
  end;
  if Strings = nil then
  begin

    exit
  end;
  for i := SLast(ss_) downto 0 do
  begin
    if oma.FastIndexOf(ss_[i]) < 0 then
    begin
      ss_.Delete(i);
    end
    else
    begin
      inc(result)
    end;

  end;

end;

function TMonaStringListhELPER.Intersec(const oma: TMonaStringList): integer;
begin
  result := Intersecion(oma.ss_);

end;

function TMonaStringList.Existe(const s: SString): boolean;
begin
  result := IndexOf(s) >= 0

end;

function TMonaStringList.IndexOf(const s: SString): integer;
begin
  if Strings = nil then
  begin
    result := -1;
    exit
  end;
  result := ss_.FastIndexOf(s)

end;

{ TMonoStringListSecure }

Function PathRoot(const pa: TUrlFile): SysString;
begin
  result := ExtractFilePath(pa);
end;

Function PathCaminos_(const nm1: SysString): SysString;
Begin
  result := ConBarra(PathRoot(nm1));
end;

Function PathFileExtension(const d: SysString): SysString;
Begin
  result := ExtractFileExt(d);
end;

Procedure Fsplit__(const d: TUrlFile; var di, no, ex: SysString);
var
  nom: SysString;
begin
  di := PathRoot(d);
  nom := PathNomExt_(d); // ExtractFileName(d);
  ex := PathFileExtension(d);
  if ex = '' then
  begin
    no := nom
  end
  else
  begin
    no := Copy(nom, 1, Length(nom) - Length(ex));
  end;
end;

Function PathRootDir(const pa: TUrlFile): TMonaDirectory;
begin
  result.Init(PathRoot(pa));
end;

Function PathRootSin(const pa: TUrlFile): TUrlFile;
begin
  result := SinBarra(PathRoot(pa));
end;

Function PathRootOwner(const pa: TUrlFile): TUrlFile;
begin
  result := PathRoot(SinBarra(pa));
end;

Function PathAs(const d: TUrlFile): TUrlFile;
begin
  result := ConBarra(d) + '*.*';
end;

Function SumBarraMas(const s, nn: SysString): SysString;
var
  l: integer;
  co: boolean;
begin
  l := Length(s);
  co := false;
  While (l > 0) and IsBarra(s[l]) do
  begin
    Dec(l);
    co := True;
  end;
  if co then
  begin
    result := Copy(s, 1, l) + Barrax + nn;
  end
  else
  begin
    result := s + Barrax + nn;
  end;
end;

Function DirecNombre(const d: TUrlFile; const nn: TUrlFile): SysString;
Begin
  result := ConBarra(d) + nn;
end;

Function DirecNombres_(const d: TUrlFile; const nn: SysString): TUrlFile;
var
  n_: SysString;
  le1, le2: integer;
Begin
  n_ := nn;
  le2 := Length(n_);
  le1 := Length(d);
  if le2 >= le1 then
    if // todo_char.
      Posi(d, n_) = 1 then
    begin
      // Delete(n, 1, Length(d));
      result := nn;
      exit;
    end;
  if le2 > 0 then
  begin
    if IsBarra(n_[1]) then
    begin
      result := SinBarra(d) + n_;
      exit;
    end;
  end;
  // l := Length(d);
  if le1 > 0 then
    if d[le1] = Barrax then
    begin
      result := d + n_;
      exit;
    end;
  result := SumBarraMas(d, n_);
end;

Function SinBarra(const s: TUrlFile): TUrlFile;
var
  l: integer;
  co: boolean;
begin
  l := Length(s);
  co := false;
  While (l > 0) and IsBarra(s[l]) do
  begin
    Dec(l);
    co := True;
  end;
  if co then
  begin
    result := Copy(s, 1, l);
  end
  else
  begin
    result := s
  end;
end;

Function ConBarra(const Name: TUrlFile): TUrlFile;
Begin
  if name = '' then
  begin
    result := '';
  end
  else
  begin
    if name[Length(name)] = Barrax then
    begin
      result := name
    end
    else
    begin
      result := SinBarra(name) + Barrax
    end;
  end
end;

function CreateMonaDir(const dir: TUrlFile): TMonaDirectory;
begin
  result.Init(dir, nil);
end;

Function ExisteDir(const nam: TUrlFile): boolean;
var
  sr: tSearchrec;
begin
  try
    result := FindFirst(SinBarra(nam), faanyfile, sr) = 0;
    sysutils.FindClose(sr);
  except
    result := false;
  end;
end;

FUnction TestMakeDir(const Nombre: TUrlFile): integer;
begin
  result := MakeDir(PathRoot(Nombre));
end;

FUnction TestMakeDirPath_(const Nombre: TUrlFile): integer;
begin
  result := TestMakeDir(PathRoot(Nombre));
end;

Function CambiaDir__(const dir: TMonaDirectory): integer;
var
  d: SysString;
begin
  d := SinBarra(dir);
  result := 0;
  if d <> '' then
  Begin
    chdir(d);
    result := ioresult;
  end;
end;

function TMonaDirectory.SinBarras: TUrlFile;
begin
  result := SinBarra(root)
end;

procedure TMonaDirectory.DelFileMask(const Mask: SString);
var
  ss: TMonaFile; // sString;
begin
  for ss in ChildFiles(Mask) do
  begin
    try
      ss.DelFile
      // DeleteFile(ss);
    except
    end;

  end;

end;

function TMonaDirectory.Barra_(const mas: SString = ''): TUrlFile;
begin
  if mas = '' then
  begin
    result := ConBarra(root) + mas;
  end
  else
  begin
    result := DirecNombres_(root, mas);
  end;
end;

class operator TMonaDirectory.Implicit(const aValue: TUrlFile): TMonaDirectory;
begin
  result.Init(aValue, nil);
end;

class operator TMonaDirectory.Implicit(const aValue: TMonaDirectory): TUrlFile;
begin
  result := aValue.root
end;

procedure TMonaDirectory.Init(const aValue: TUrlFile; con: Pointer);
begin
  root := aValue;
  contexto_ := nil;
end;

procedure TMonaDirectory.InitPath(const aValue: TMonaFile);
begin
  Init(aValue.PathRoots, nil)
end;

class operator TMonaDirectory.Subtract(const aValue: TMonaDirectory;
  const s: SString): TMonaFile;
begin
  result := aValue.Barra_(s)
end;

function TMonaDirectory.Nulo: boolean;
begin
  result := root = ''
end;

function TMonaDirectory.ChildDirs: TFactorySearch;
begin
  result := TFactorySearch.FactoryDirs(root, contexto_);
end;

function TMonaDirectory.ChildFiles(const masc: SString): TFactorySearch;
begin
  result := TFactorySearch.FactoryFiles(root, masc, contexto_);
end;

function TMonaDirectory.DirCountRecursive: integer;
var
  child: TMonaDirectory;
begin
  result := 1;
  for child in ChildDirs do
    result := result + child.DirCountRecursive
end;

class operator TMonaDirectory.Multiply(const aValue: TMonaDirectory;
  const s: SString): TFactorySearch;
begin
  result := aValue.ChildFiles(s)
end;

class operator TMonaDirectory.Divide(const aValue: TMonaDirectory;
  const s: SString): TMonaDirectory;
begin
  result := aValue.Barra_(s)
end;

procedure TMonaDirectory.Done;
begin
  root := '';
  contexto_ := nil;
end;

function TMonaDirectory.Existe: boolean;
begin
  result := ExisteDir(root)
end;

class operator TMonaDirectory.Implicit(const aValue: TInfoEnumerator)
  : TMonaDirectory;
var
  fil: TMonaFile;
begin
  fil := aValue;
  result.root := fil.NameFull;
  result.contexto_ := fil.Context_;
end;

class operator TMonaDirectory.Implicit(const aValue: TMonaFile): TMonaDirectory;
begin
  result.root := aValue.NameFull;
  result.contexto_ := aValue.Context_;
end;

Function TMonaDirectory.pathName(): SString;
begin
  result := PathNomExt_(SinBarra(root));
end;

Function TMonaDirectory.OwnerPath(): TMonaDirectory;
begin
  result := PathRoot(SinBarra(root));
end;

FUnction TMonaDirectory.MakeDir(): integer;
var
  su: TMonaDirectory;
  d: SysString;
  Ok: integer;
begin
  result := 0;
  If not Existe() then
  begin
    d := SinBarra(root);
    su := PathRoot(d);
    Ok := 0;
    if Length(su.root) < Length(d) then
    begin
      Ok := su.MakeDir();
    end;
    if Ok = 0 then
    begin
      Mkdir(d);
      result := ioresult;
    end
    else
    begin
      result := Ok;
    end;
  end;
end;

FUnction MakeDir(const Nombre: TMonaDirectory): integer;
var
  su, d: SysString;
  Ok: integer;
  // var
  // log: ISynLog;

begin
  result := 0;
  TRY

    // log := TSynLog.Enter('makedir   ' + nombre.root, []);

    If not Nombre.Existe() then
    begin
      d := SinBarra(Nombre.root);
      su := PathRoot(d);
      Ok := 0;
      if Length(su) < Length(d) then
      begin
        Ok := MakeDir(su);
      end;
      if Ok = 0 then
      begin
        Mkdir(d);
        result := ioresult;
      end
      else
      begin
        result := Ok;
      end;
    end;
  except
    result := 0;
  end;
end;

function GetDirCount_(const dir: TMonaDirectory): integer;
var
  child: TMonaDirectory;
begin
  result := 1;
  for child in dir.ChildDirs do
    result := result + GetDirCount_(child);
end;

function sumaFiles_(const dir: TMonaDirectory; const masc: SString): integer;
var
  rr: TMonaFile;
begin
  result := 0;
  for rr in dir * masc do
  begin
    result := result + rr.Size;
  end;
end;

Function ActualDos: SString;
Begin
  GetDir(0, result);
end;

procedure RenameFicheros(const masc1: SysString; const d2, n2, e2: SString);
var
  ent: tSearchrec;
  d, d1, n1, e1: SysString;
begin
  d := PathRoot(masc1);
  if FindFirst(masc1, faanyfile, ent) = 0 then
    repeat
      with ent do
      begin
        Fsplit__(d + name, d1, n1, e1);
        if n2 <> '' then
          n1 := n2;
        if e2 <> '' then
          e1 := e2;
        if d2 <> '' then
          d1 := d2;
        RenameFile(d + Name, DirecNombres_(d1, n1 + e1));
      end;
    until FindNext(ent) <> 0;
  sysutils.FindClose(ent);
end;

constructor TxSearchEnumeratorInfo.Create(const ds: PSearchData;
  const comp: TObject = nil); // override;
begin
  inherited Create(ds, comp);
  mascaras_ := ds;
  doFirst := false;
  // SingleName := False;
end;

function TxSearchEnumeratorInfo.GetCurrent: TMonaFile;
begin
  result.Init(NameFileActual, self)
  // result := self
end;

{ TFactorySearchEnumerator }

constructor TFactorySearch.FactoryFiles(const dir: SString;
  const masc_: SString = ''; contexto: Pointer = nil);
begin
  data.InitFiles(dir, masc_);
  inherited Create(@data);
  ownerEnum := contexto;
  // pis:=ds_;
end;

function TFactorySearch.Filtro(const busca: SString): TFactorySearch;
begin
  data.SearchFile_ := busca;
  result := self;
end;

constructor TFactorySearch.FactoryDirs(const dir: SString;
  contexto: Pointer = nil);
begin
  data.InitDirectorys(dir);
  inherited Create(@data);
  ownerEnum := contexto;
  // pis:=ds_;

end;

function TFactorySearch.GetEnumerator: TxSearchEnumeratorInfo;
begin
  result := TxSearchEnumeratorInfo.Create(@data, self);
  result.OwnerEnumerator := ownerEnum;
end;

function TExe.RootDir: TUrlFile;
begin
  result := Dirinicial_.root;
  if result = '' then
  begin
    result := ExePath_;
  end;
end;

{ TExe }

procedure TExe.Done;
begin
  ProgramFileName_ := '';
  Dirinicial_ := '';
end;

function TExe.ExeFile: TUrlFile;
begin
  result := ProgramFileName_;
  if (result = '') then
  begin
    result := ParamStr0
  end;
end;

function TExe.ParamStr0: TUrlFile;
begin
  result := ParamStr(0);
end;

procedure TExe.Init;
begin
  ProgramFileName_ := ParamStr0;
  Dirinicial_ := ExePath_;
  DirDatos := '';
end;

Function TExe.Ospath(const Name: TUrlFile): TUrlFile;
begin
  result := DirecNombres_(ExePath_, name);
end;

function TExe.ExePathSinRoot: TUrlFile;
begin
  result := PathRoot(SinBarra(ExePath_));
end;

Function TExe.DirApps(const na: TUrlFile): TUrlFile;
Begin
  if Dirinicial_.Nulo then
  begin
    result := DirecNombres_(RootDir, na);
  end
  else
  begin
    result := Dirinicial_.Barra_(na);
  end;
end;

Function TExe.DirNombres_(const s: TUrlFile): TUrlFile;
Begin
  result := Dirinicial_.Barra_(s);
end;

Function TExe.DirRaizBarra: TUrlFile;
Begin
  result := Dirinicial_.Barra_() // ConBarra(Dirinicial_)
end;

class operator TExe.Divide(const exe: TExe; const s: TUrlFile): TUrlFile;
begin
  result := exe.DirApps(s)
end;

Function TExe.FileDirActual(const na: TUrlFile): TUrlFile;
Begin
  result := Dirinicial_.Barra_(na);
  // result := ConBarra(d) + n;
end;

function TExe.ExePath_: TUrlFile;
begin
  result := PathRoot(ExeFile);
end;

Function CountMascara(const Mask: SString; att: integer): integer;
var
  sefile: TSearchData;
  s: TInfoEnumerator;
begin
  sefile.InitFileMask(Mask, att);
  result := 0;
  for s in sefile do
  begin
    inc(result);
  end;
end;

function TSearchData.GetEnumerator: TBaseSearchEnumerator;
begin
  result := TBaseSearchEnumerator.Create(@self, nil);
end;

procedure TSearchData.InitDirectorys(const dir: SString);
begin
  directory__ := ConBarra(dir);
  InitMask(directory__ + '*.*', fadirectory or faHidden);

end;

function OkOrFilter(const f: TFilterSearcher; const sr: PSearchrec): boolean;
begin
  if assigned(f) then
  begin
    result := f(sr)
  end
  else
  begin
    result := True
  end;
end;

function TBaseSearchEnumerator.EvaluarActual: TEvaluateLong;
begin
  if fLast <= 0 then
  begin
    fLast := CountMascara(mascaras_.Mask, mascaras_.AttibFile)
  end;
  result.Inits(self);
end;

function TBaseSearchEnumerator.NameFileActual: SString;
begin
  result := mascaras_.directory__ + sr.Name
end;

function TBaseSearchEnumerator.MoveNext: boolean;
begin
  // result := False;
  if doFirst then
  begin
    result := FindNext(sr) = 0
  end
  else
  begin
    doFirst := True;
    result := FindFirst(mascaras_.Mask, AttribFile, sr) = 0;
  end;

  while result and ((((fadirectory and sr.Attr) = fadirectory) and
    ((sr.Name = '.') or (sr.Name = '..'))) or ((sr.Attr and AttribFile) = 0)) or
    (not(OkOrFilter(filter, @sr)))

    do
  begin
    (* if SR.name [1]='_' then
      begin
      result := FindNext(SR) = 0
      end else *)
    begin
      result := FindNext(sr) = 0
    end;
  end;
  inc(fIndex);
end;

constructor TBaseSearchEnumerator.Create(const ds: PSearchData;
  const comp: TObject = nil); // override;
begin
  inherited Create(ds, comp);
  mascaras_ := ds;
  AttribFile := mascaras_.AttibFile;
  evalue_.Inits;
  doFirst := false;
  filter := Nil;
  // SingleName := False;
end;

destructor TBaseSearchEnumerator.Destroy;
begin
  CloseEnumerator;
  inherited Destroy;
end;

procedure TBaseSearchEnumerator.CloseEnumerator;
begin
  if doFirst then
  begin
    sysutils.FindClose(sr)
  end;
  doFirst := false;
end;

procedure TSearchData.InitFiles(const dir: SString; const masc_: SString);
begin
  directory__ := ConBarra(dir);
  if masc_ = '' then
  begin
    Mask := directory__ + '*.*'
  end
  else
  begin
    Mask := directory__ + masc_
  end;
  AttibFile := faArchive;
end;

procedure TSearchData.Inits_(const dir: SString = ''; att: integer = 0;
  mascara: SString = '');
begin
  if mascara = '' then
  begin
    mascara := '*.*'
  end;
  directory__ := ConBarra(dir);
  Mask := DirecNombres_(directory__, mascara);
  AttibFile := att;
end;

function TSearchData.MaskTrim_: SString;
begin
  result := MiTrim_(Mask);
  // MiTrim__(Mask);
  if result = '' then
  begin
    result := '*.*';
  end;
end;

procedure TSearchData.InitFileMask(const dir: SString; att: integer);
begin
  directory__ := PathRoot(dir);
  InitMask(dir, att);
end;

procedure TSearchData.InitMask(const mascara: SString = '';
  atributos: integer = faanyfile);
begin
  if mascara = '' then
  begin
    Mask := '*.*';
  end
  else
    Mask := mascara;
  AttibFile := atributos;
end;

function TSearchData.DirMask_(const dir: SString): SString;
begin
  result := DirecNombre(dir, MaskTrim_);
end;

class operator TMonaAnsiReader.Implicit(const aValue: TUrlFile)
  : TMonaAnsiReader;
begin
  result.Init_(aValue);
end;

class operator TMonaAnsiReader.Implicit(const aValue: TMonaFile)
  : TMonaAnsiReader;
begin
  result.Init_(aValue.NameFull)
end;

class operator TMonaAnsiReader.Implicit(const aValue: TInfoEnumerator)
  : TMonaAnsiReader;
var
  fil: TMonaFile;
begin
  fil := aValue;
  result.Init_(fil.NameFull);
end;

class operator TMonaAnsiReader.Implicit(const aValue: TMonaAnsiReader)
  : TMonaFile;
begin
  result := aValue.FileName
end;

procedure TMonaAnsiReader.Init_(const fina: TUrlFile);
begin
  FileName := fina;
end;

function TMonaAnsiReader.GetEnumerator: TAnsiReaderEnumerator;
begin
  result := TAnsiReaderEnumerator.Create(FileName);
end;

class operator TAnsiStream.Implicit(const aValue: TUrlFile): TAnsiStream;
begin
  result.Init(aValue);
end;

Procedure TAnsiStream.Init(const localName: SString);
begin
  MyStream_ := Nil;
  FFileName := localName;
end;

procedure TAnsiStream.Done;
begin
  Freenil(MyStream_);
  // Freenil(MyStream);
end;

function TAnsiStream.stream_: TStream;
begin
  if MyStream_ = nil then
  begin
    MyStream_ := TBufferFileStream.CreateRead(FFileName);
  end;
  result := MyStream_;
end;

function TAnsiReaderEnumerator.MoveNext: boolean;
begin
  result := not MyStream.Eofs
end;

constructor TAnsiReaderEnumerator.Create(const fn: SString);
begin

  inherited Create(nil, nil);
  FileName := fn;
  MyStream := TBufferFileStream.CreateRead(FileName);
end;

destructor TAnsiReaderEnumerator.Destroy;
begin
  Freenil(MyStream);
  inherited Destroy;
end;

function TAnsiReaderEnumerator.GetCurrent: SString;
begin
  result := MyStream.ReadLn_
end;

function TAnsiStream.Eofs: boolean;
begin
  if MyStream_ = Nil then
  begin
    if stream_ = Nil then
    begin
      result := false
    end
    else
    begin
      result := MyStream_.Eofs
    end;
  end
  else
  begin
    result := MyStream_.Eofs
  end;
end;

function Int64Str(Value: Int64): SString;
begin
  result := IntTostr(Value)
end;

function Ssum(const valores: array of const): SysString;
var

  sss: SString;

  sta: SysString;
  ss: SysString;
  i: integer;
begin
  ss := '';
  for i := 0 to High(valores) do
  begin
    with valores[i] do
      case VType of
        vtInt64:
          begin
            sta := Int64Str(vtInt64);
            (* if VInteger<>0 then
              begin
              sta := IntToStr(VInteger);
              end; *)
          end;
        vtInteger:
          begin
            str(VInteger, sss);
            ss := ss + sss;
            continue;
            // sta := StIntS(VInteger);
          end;
        vtBoolean:
          if vBoolean then
            sta := 'YES'
          else
            sta := 'NO';
{$IFNDEF android}
        vtChar:
          begin
            sta := VChar;
          end;
        vtString:
          begin
            sta := VString^;
          end;
{$ENDIF android}
        vtExtended:
          begin
            sta := FloatToStr(VExtended^);
          end;

{$IFDEF xe5}
        vtUnicodeString:
          begin
            sta := unicodestring(VUnicodeString)
          end;
{$ENDIF xe5}
        vtPChar:
          begin
            sta := VPChar;
          end;
        vtAnsiString:
          begin
            sta := StreamString(VAnsiString);
          end;
        vtWideString:
          begin
{$IFDEF NEXTGEN}
            sta := String(VWideString);
{$ELSE}
            sta := WideString(VWideString);
{$ENDIF}
          end;
        vtObject:
{$IFDEF NEXTGEN}
          sta := TObject(VObject).ClassName;
{$ELSE}
          sta := VObject.ClassName;
{$ENDIF}
        vtWideChar:
          begin
            sta := VWideChar;
          end;

        vtClass:
          sta := VClass.ClassName;
        vtCurrency:
          sta := CurrToStr(VCurrency^);
        vtVariant:
          sta := StreamString(VVariant^);
        { else
          begin
          //             warning ('nose');
          sta:='';
          end
        }
      else
        begin
          sta := '';
          // WarningRaroS_ ( 'nose' +valores[i].VType.ToString);
        end;
      end;
    ss := ss + sta;
  end;
  result := ss;
end;

function Min(a, b: longint): longint; inline;
Begin
  if a < b then
  begin
    result := a
  end
  else
  begin
    result := b;
  end;
end;

Function Max(a, b: longint): longint;
Begin
  If a > b then
    Max := a
  else
    Max := b;
end;

function CompareMixs(const s1: SString; const ps2: SPChar;
  lon2: integer): integer;
var
  lon1: integer;
begin
  lon1 := Length(s1);
  if lon2 = lon1 then
  begin
    result := {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp
      (SPChar(s1), ps2, lon1)
  end
  else
  begin
    result := {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp
      (SPChar(s1), ps2, Min(lon1, lon2));
    if result = 0 then
    begin
      if lon1 > lon2 then
      begin
        result := 1
      end
      else
      begin
        result := -1
      end;
    end;
  end;
end;

function CompareMixIgual(const s1: SString; const ps2: SPChar;
  lon2: integer): boolean;
var
  lon1: integer;
begin
  lon1 := Length(s1);
  if lon2 = lon1 then
  begin
    result := {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp
      (SPChar(s1), ps2, lon1) = 0
  end
  else
  begin
    result := false
  end;
end;

function PosIgual(const str: SString): integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to Length(str) do
  begin
    if str[i] = ChIgual then
    begin
      result := i;
      exit;
    end;
  end;
end;

procedure WarningX(const valores: SString);
begin
  // ?  WarningRaroS_(valores);
END;

Procedure AsignaString1(var ms: TMixString; const s: SString);
begin
  ms.lon := Length(s);
  ms.Ps_ := SPChar(s);
end;

function StringSum(const valores: array of SysString): SysString;
var
  s: StreamString;
begin
  result := '';
  for s in valores do
  begin
    result := result + s
  end;
end;

Function MiTrim_(const aString: SString): SString;
var
  i, l: integer;
BEGIN
  l := LastChar(aString);
  i := LowSt_;
  while (i <= l) and (aString[i] <= ' ') do
    inc(i);
  if i > l then
    result := ''
  else
  begin
    while aString[l] <= ' ' do
      Dec(l);
    if (i = LowSt_) and (l = Length(aString)) then
    begin
      result := aString
    end
    else
      result := Copy(aString, i, l - i + 1);
  end;
END;

Function SLast(a: TStrings): integer;
begin
  if a = nil then
  begin
    result := -1;
  end
  else
  begin
    result := a.Count - 1
  end;
end;

function Str2Int(const s: SString): integer;
var
  e: integer;
begin
  Val(s, result, e);
  if e <> 0 then
    result := 0 // ConvertErrorFmt(@System.SysConst.SInvalidInteger, [S]);
end;


procedure StringReplaces(var replaceStr_: SString;
  const OldPattern, NewPattern: SString);
begin
  if System.Pos(OldPattern, replaceStr_) > 0 then
  begin
    replaceStr_ := StringReplace(replaceStr_, OldPattern, NewPattern,
      [RfReplaceAll])
  end
end;

function FetchValAnsi(var s1: SString): SString;
var
  iPos: integer;
begin
  iPos := PosIgual(s1);
  If iPos = 0 then
  begin
    result := s1;
    s1 := '';
  end
  else
  begin
    result := Copy(s1, 1, iPos - 1);
    Delete(s1, 1, iPos);
  end;
end;

function FindReplace(const ss: SString; const find, replace: SString): SString;
Var
  i: integer;
  s: SString;
begin
  s := ss;
  repeat
    i := System.Pos(find, s);
    if i > 0 then
    Begin
      Delete(s, i, Length(find));
      Insert(replace, s, i);
    end;
  until i = 0;
  result := s;
end;

Function Texts(a: TStrings): SString;
begin
  if a = nil then
  begin
    result := '';
  end
  else
  begin
    result := a.Text
  end;
end;

function SplitSt_(const cadena: SString): TxStringList;
var
  ac, co: SString;
begin
  result := CreaSt;
  co := cadena;
  while co <> '' do
  begin
    ac := Fetchar(';', co);
    result.Add(ac)
  end;
end;

Function Upst(const s: SysString): SysString; overload;
Begin
  result := AnsiUpperCase(s);
end;

function CharPosA__(Ch_: SChar; const str: SString): integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to Length(str) do
  begin
    if str[i] = Ch_ then
    begin
      result := i;
      exit;
    end;
  end;
end;

function TxStringList.Gets(Index: integer): SString;
begin
  if Cardinal(Index) >= Cardinal(Count) then
  begin
    result := ''
  end
  else
  begin
{$IFDEF veryfast}
    result := TFastMatchStringLis(self).FList[Index].FString;
{$ELSE veryfast}
    result := get(index);
{$ENDIF veryfast}
    // Error(@SListIndexError, Index);
  end;
end;

function TxStringList.MixAtrib(const Index: integer): TAtribute;
begin
  if Cardinal(Index) >= Cardinal(Count) then
  begin
    result.Inits('')
  end
  else
  begin
{$IFDEF veryfast}
    result.Inits(TFastMatchStringLis(self).FList[Index].FString);
{$ELSE veryfast}
    result.Inits(get(index));
{$ENDIF veryfast}
    // Error(@SListIndexError, Index);
  end;
end;

function TxStringList.MixItem(const Index: integer): TMixPair;
begin
  if Cardinal(Index) >= Cardinal(Count) then
  begin
    result.Inits('')
  end
  else
  begin
{$IFDEF veryfast}
    result.Inits(TFastMatchStringLis(self).FList[Index].FString);
{$ELSE veryfast}
    result.Inits(get(index));
{$ENDIF veryfast}
    // Error(@SListIndexError, Index);
  end;
end;

procedure TxStringList.Atas(const na, va: SString);
begin
  SetAttribute(na, va)
end;

procedure TxStringList.Ata(const na, va: SString);
var
  s: SString;
begin
  s := MiTrim_(va);
  if s <> '' then
  begin
    SetAttribute(na, s)
  end;
end;

procedure TxStringList.FastIndexOrInclude(const s: SString);
var
  cu, i: integer;
begin
  cu := GetCount;
  for i := 0 to cu - 1 do
  begin
    if Strings[i] = s then
    begin
      exit;
    end;
  end;
  InsertItem(cu, s, nil);
end;

procedure TxStringList.FastIndexOrIncludeSorted_(const s: SString);
var
  cu, i: integer;
  so: boolean;
begin
  if inherited IndexOf(s) >= 0 then
  begin
    exit;
  end;
  so := sorted;
  sorted := false;
  cu := GetCount;
  for i := 0 to cu - 1 do
  begin
{$IFDEF veryfast}
    if TFastMatchStringLis(self).List^[i].FString >= s then
{$ELSE veryfast}
    if Strings[i] >= s then
{$ENDIF veryfast}
    begin
      InsertItem(i, s, nil);
      if so then
      begin
        sorted := True;
      end;
      exit;
    end;
  end;
  InsertItem(cu, s, nil);
  if so then
  begin
    sorted := True;
  end;
end;

function TStringsHelper.GetEnumerator: TEnumeratorRecord;
begin
  result.InitListString(self)
end;

Procedure TStringsHelper.AddMix(const mix: PPairMix);
begin
  if mix <> nil then
  begin
    SetAttributex(mix.Nombre, mix.valor);
    // Values[mix.Nombre] := mix.valor
  end;
end;

function TxStringList.Objetos: TEnumeraOnjects;
begin
  result := TEnumeraOnjects.Create(self);
end;

procedure TxStringList.AddSt(const s: SString);
begin
{$IFDEF veryfast}
  // if (Index < 0) or (Index > FCount) then Error(@SListIndexError, Index);
  // InsertItem(Index, S, AObject);
  InsertItem(TFastMatchStringLis(self).FCount, s, nil);
{$ELSE veryfast}
  InsertItem(Count, s, nil);
{$ENDIF veryfast}
  // InsertItem(Count, S, nil);
end;

procedure TStringsHelper.AddSt__(const s: SString);
begin

  InsertItem(Count, s, nil);
end;

function TxStringList.Objeto(n: integer): TObject;
begin
{$IFDEF veryfast}
  result := TFastMatchStringLis(self).List^[n].fObject;
{$ELSE veryfast}
  result := objects[n]
{$ENDIF veryfast}
  // result:=
end;

procedure TxStringList.Puts(Index: integer; const s: SString);
begin
  Put(index, s)
end;

function TStringsHelper.FastName(i: integer): TMixString;
var
  s: SString;
  po: integer;
begin
  result.lon := 0;
  result.Ps_ := nil;
  if i < Count then
    if i > 0 then
    begin
{$IFDEF veryfast}
      s := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
      s := get(i);
{$ENDIF veryfast}
      po := PosIgual(s);
      if po <= 0 then
      begin
        po := Length(s);
      end
      else
      begin
        Dec(po);
      end;
      result.Ps_ := SPChar(s);
      result.lon := po;
    end;
end;

function LoadStringFromFile_(listaString: TxStringList;
  const Name: SysString): boolean;
begin
  result := ExistFile(name);
  if not result then
  begin
    exit;
  end;
  try
    listaString.LoadFromFile(NAME);
  except
    result := false;
  end;
end;

function LoadStrings(const Name: SString): TxStringList;
var
  listaString: TxStringList;
begin
  listaString := TxStringList.Create;
  LoadStringFromFile_(listaString, name);
  result := listaString;
end;

function CreaSt: TxStringList;
begin
  result := TxStringList.Create;
end;

constructor TxStringList.Creates(const o: TxStringList = Nil);
begin
  inherited Create;
  if o <> nil then
  begin
    AddStrings(o)
  end;
end;

function TxStringList.GetEnumerator: TEnumeratorRecord;
begin
  result.InitListString(self)
  // result.Init_(self,LongEnumera,GetCurrentString);
end;

procedure TStringsHelper.SetAttrib(const attrName: SString;
  const Value: SString; siempre: boolean = false);
var
  i: integer;
begin
  if GetCount = 0 then
  begin
    i := -1;
  end
  else
  begin
    i := FastIndexOfName(attrName);
  end;
  if (Value <> '') or siempre then
  begin
    if i < 0 then
      AddSt__(attrName + '=' + Value)
    else
      Put(i, attrName + '=' + Value);
  end
  else
  begin
    if i >= 0 then
      Delete(i);
  end;
end;

Function TxStringList.Paramterst: SString;
var
  i: integer;
  s: SString;
  na: SString;
  masc: SChar;
Begin
  result := '';
  begin
    masc := ' '
  end;
  for i := 0 to Count - 1 do
  begin
    if i > 0 then
    begin
      result := result + masc
    end;
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[i].FString;
    // s:=Get(i);
{$ELSE veryfast}
    s := get(i);
{$ENDIF veryfast}
    na := FetchValAnsi(s);
    result := result + na + '="' + s + '"'
  end;
end;

function SumMixSS(const aValue1: SString; const value2: SString): SString;
begin
  result := aValue1 + '=' + value2
end;

procedure TStringsHelper.SetAttribInt___(const attrName: SString;
  const Value: Int64);
var
  i: integer;
  resu: SysString;
begin
  if GetCount = 0 then
  begin
    i := -1;
  end
  else
  begin
    i := FastIndexOfName(attrName);
  end;
  resu := SumMixSS(attrName, Int64Str(Value));
  if i < 0 then
  begin
    InsertItem(Count, resu, nil)
  end
  else
  begin
    Put(i, resu);
  end;
end;

procedure TStringsHelper.AddObjects(aObject: TObject);
begin
  InsertItem(Count, '', aObject);
end;

function TxStringList.FindNames(const Name: SString): integer;
var
  le, p, l, H, i, c: integer;
  ss: SString;
begin
  result := -1;
  l := 0;
  H := Count - 1;
  le := Length(Name);
  p := le + 1;
  while l <= H do
  begin
    i := (l + H) shr 1;
    ss := get(i); // FList^[I].FString;
{$IFDEF AnsiModeDx}
    c := ansistrings.AnsiStrLComp(SPChar(ss), SPChar(name), le);

{$ELSE}
    c := StrLComp(SPChar(ss), SPChar(name), le);

{$ENDIF}
    if (c < 0) then
      l := i + 1
    else
    begin

      if (c = 0) then
      begin
        if (ss[p] = NameValueSeparator) then
        begin
          result := i; // True;
          Break;
        end
        else if (ss[p] < NameValueSeparator) then
        begin
          H := i - 1;
        end
        else
        begin
          l := i + 1

        end;

        // if Duplicates <> dupAccept then L := I;
      end
      else
      begin
        H := i - 1;
      end;
    end;
  end;
  // Index := L;
end;

{$IFNDEF DelphiDx}

function TxStringList.IndexOfName(const Name: SString): integer;
var
  le, i, p: integer;
  s: SString;
begin
  if sorted then
  begin
    result := FindNames(name);
    if result >= 0 then
    begin
      exit;
    end;
  end;
  le := Length(Name);
  p := le + 1;
  for i := 0 to GetCount - 1 do
  begin
    s := get(i);
    if Length(s) > le then
      if s[p] = NameValueSeparator then

        // P := AnsiPos(NameValueSeparator, S) - 1;
        if // (P = le) and // (CompareStrings(copY(s, 1, P - 1), Name) = 0) then
          (StrLComp(SPChar(s), SPChar(Name), le) = 0) then
        begin
          result := i;
          exit;
        end;
  end;
  result := -1;
end;

function TStringsHelper.FastValues__(const nam: SString; mas: boolean): SString;
var
  i: integer;
  s: SString;
  le: integer;
  pena: SPChar;
begin
  le := Length(nam);
  pena := SPChar(nam);
  for i := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
    s := get(i);
{$ENDIF veryfast}
    if Length(s) > le then
    begin
      if StrLComp(SPChar(s), pena, le) = 0 then
      // if length(s)>le then como minimo debe ser #0
      begin
        if s[le + 1] = '=' then
        begin
{$IFDEF trucar}
          result := Truco_(s, le + 2, Length(s) - le - 1); // MaxInt);
{$ELSE trucar}
          result := Copy(s, le + 2, Length(s) - le - 1); // MaxInt);
{$ENDIF  trucar}
          exit;
        end;
      end
      else if mas then
      begin
        if CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE, SPChar(s), le,
          pena, le) = 2 then
          if s[le + 1] = '=' then
          begin
{$IFDEF trucar}
            result := Truco_(s, le + 2, Length(s) - le - 1); // MaxInt);
{$ELSE trucar}
            result := Copy(s, le + 2, Length(s) - le - 1); // MaxInt);
{$ENDIF  trucar}
            exit;
          end;

      end;
    end;

  end;
  result := '';
  (* if mas then
    begin
    Result := InheritedValues(nam);
    end; *)
  // {$ENDIF DelphiDx}
end;

{$ELSE}

function TStringsHelper.FastValues__(const nam: SString; mas: boolean): SString;
var
  i: integer;
  s: SString;
  le: integer;
  pena: SPChar;
begin
  le := Length(nam);
  pena := SPChar(nam);
  for i := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
    s := get(i);
{$ENDIF veryfast}
{$IFDEF AnsiModeDx}
    if ansistrings.AnsiStrLComp(SPChar(s), pena, le) = 0 then

{$ELSE}
    if StrLComp(SPChar(s), pena, le) = 0 then

{$ENDIF}
    // if length(s)>le then como minimo debe ser #0
    begin
      if s[le + 1] = '=' then
      begin
{$IFDEF trucar}
        result := Truco_(s, le + 2, Length(s) - le - 1); // MaxInt);
{$ELSE trucar}
        result := Copy(s, le + 2, Length(s) - le - 1); // MaxInt);
{$ENDIF  trucar}
        exit;
      end;
    end
    else if mas then
    begin
{$IFDEF Android}
      if Upst(Copy(s, 1, le)) = Upst(Copy(pena, 1, le)) then
{$ELSE}
{$IFDEF AnsiModeDx}
      if CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE, SPChar(s), le,
        pena, le) = 2 then
{$ELSE}
      if CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, SPChar(s), le,
        pena, le) = 2 then
{$ENDIF}
{$ENDIF}
        if s[le + 1] = '=' then
        begin
{$IFDEF trucar}
          result := Truco_(s, le + 2, Length(s) - le - 1); // MaxInt);
{$ELSE trucar}
          result := Copy(s, le + 2, Length(s) - le - 1); // MaxInt);
{$ENDIF  trucar}
          exit;
        end;

    end;

  end;
  result := '';
  (* if mas then
    begin
    Result := InheritedValues(nam);
    end; *)
  // {$ENDIF DelphiDx}
end;

{$ENDIF}

function TStringsHelper.IndexMx_(const nam: TMixString): integer;
var
  le, i: integer;
  s: SString;
begin
  result := -1;
  le := nam.lon;
  for i := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).FList^[i].FString;
{$ELSE veryfast}
    s := get(i);
{$ENDIF veryfast}
    if Length(s) > le then
      if s[le + 1] = '=' then
      begin
{$IFDEF xe5}
        if nam.Match(s, le) then
{$ELSE }
        if StrLComp(SPChar(s), nam.Ps_, le) = 0 then
{$ENDIF }
        // if length(s)>le then como minimo debe ser #0
        begin
          // if S[le + 1] = '=' then
          begin
            result := i;
            exit;
          end;
        end;
      end;
  end;
end;

function TStringsHelper.FastValueMx(const nam: TMixString): TMixString;
var
  le1, le, i: integer;
  s: SString;
begin
  le := nam.lon;
  le1 := le + 1;
  for i := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).FList^[i].FString;
{$ELSE veryfast}
    s := get(i);
{$ENDIF veryfast}
    // ?{$IFDEF xe5}
    // if nam=s then
    // ?    if nam.Match(S, le) then
    // ?{$ELSE }
    if Length(s) > le then
      if s[1] = nam.Ps_^ then
        if s[le1] = '=' then
          if (le = 1) or ({$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}
            StrLComp(SPChar(s), nam.Ps_, le) = 0) then
          // ?{$ENDIF }
          // if length(s)>le then como minimo debe ser #0
          begin

            begin
              result.lon := Length(s) - le1;
              result.Ps_ := SPChar(s) + le1;
              // inc(Result.Ps_, le1);
              // ?           Copy(S, LE + 2, MaxInt);
              exit;
            end;
          end;
  end;
  result.lon := 0;
  result.Ps_ := nil;

end;

function TStringsHelper.MatchValue_(const nam: SString; const tomatch: SString;
  modof: TModeFindXml): boolean;
var
  i: integer;
  s: SString;
  lem, le: integer;
  atp, pena: SPChar;
begin
  result := false;
  le := Length(nam);
  pena := SPChar(nam);
  for i := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
    s := get(i);
{$ENDIF veryfast}
{$IFDEF xe5}
    if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp(SPChar(s),
      pena, le) = 0 then
      if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}AnsiStrLComp
        (SPChar(s), pena, le) = 0 then
{$ELSE }
    if StrLComp(SPChar(s), pena, le) = 0 then
{$ENDIF }
    begin
      if s[le + 1] = '=' then
      begin
        lem := Length(s) - le - 1;
        if lem = Length(tomatch) then
        begin
          atp := SPChar(s);
          inc(atp, le + 1);
          result := {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp
            (SPChar(tomatch), atp, lem) = 0
        end
        else
        begin
          result := false;
        end;
        exit;
      end;
    end;
  end;
  if MxoBlanco in modof then
  begin
    result := True;
  end;

end;

procedure TxStringList.SetCapa(len: integer);
begin
  if capacity <> len then
  begin
    SetCapacity(len);
  end;
end;

function UpperCases(const s: SString): SString;
var
  i, len: integer;
  DstP, SrcP: SPChar;
  ch: SChar;
begin
  len := Length(s);
  setLength(result, len);
  if len > 0 then
  begin
    DstP := SPChar(Pointer(result));
    SrcP := SPChar(Pointer(s));
    for i := len downto 1 do
    begin
      ch := SrcP^;
      case ch of
        'a' .. 'z':
          ch := SChar(word(ch) xor $0020);
      end;
      DstP^ := ch;
      inc(DstP);
      inc(SrcP);
    end;
  end;
end;

procedure TStringsHelper.FixCapacity;
var
  len: integer;
begin
  len := Count;
  if capacity <> len then
  begin
    SetCapacity(len);
  end;
end;

function TxStringList.FastMatchValor_(const napavalor: SString;
  modof_: TModeFindXml): boolean;
var
  i: integer;
  na, s: SString;
  lonf, ipobu, lonv,

    le: integer;
  b: boolean;
  valop_, pena, pc: SPChar;
begin
  lonf := Length(napavalor);
  ipobu := PosIgual(napavalor);
  pena := SPChar(napavalor);
  le := ipobu - 1;
  valop_ := pena;
  inc(valop_, ipobu);
  lonv := lonf - ipobu;

  if lonv > 0 then
    for i := 0 to GetCount - 1 do
    begin
{$IFDEF veryfast}
      s := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
      s := get(i);
{$ENDIF veryfast}
      pc := SPChar(s);
      b := {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp(pc,
        pena, le) = 0;
      if not b then
        if MxoNoCS in modof_ then
          if UpCase(pc^) = UpCase(pena^) then
          begin
            SetString(na, pc, le);
            b := UpperCase(na) = UpperCases(Copy(napavalor, 1, le));
          end;

      if b then
        if lonf = Length(s) then

        begin
          inc(pc, le);
          if pc^ = '=' then
          begin
            inc(pc);
            result := {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp
              (pc, valop_, lonv) = 0;

            // result := Copy(s, le + 2, MaxInt)=valor;
            exit;
          end;
        end;
    end;
  result := false;
end;

function TxStringList.ValueInt_(const namp: SString): Int64;
var
  mx: TMixString;
begin
  mx := FastValuePc_(namp);
  result := mx.ToInt64
end;

function TxStringList.FastValuePc_(const namp: SString): TMixString;
var
  i: integer;
  s: SString;
  po, le: integer;
begin

  if sorted then
  begin
    po := FindNames(namp);
    if po >= 0 then
    begin
      le := Length(namp);
      s := get(po);
      if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp(SPChar(s),
        SPChar(namp), le) = 0 then
      // if length(s)>le then como minimo debe ser #0
      begin
        if s[le + 1] = '=' then
        begin
          result.lon := Length(s) - le - 1;
          result.Ps_ := SPChar(s);
          inc(result.Ps_, le + 1);
          // ?           Copy(S, LE + 2, MaxInt);
          exit;
        end;
      end;

      // exit;
    end;
  end;

  result.lon := 0;
  result.Ps_ := nil;
  le := Length(namp);
  for i := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
    s := get(i);
{$ENDIF veryfast}
    if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp(SPChar(s),
      SPChar(namp), le) = 0 then
    // if length(s)>le then como minimo debe ser #0
    begin
      if s[le + 1] = '=' then
      begin
        result.lon := Length(s) - le - 1;
        result.Ps_ := SPChar(s);
        inc(result.Ps_, le + 1);
        // ?           Copy(S, LE + 2, MaxInt);
        exit;
      end;
    end;
  end;
end;

function TStringsHelper.IndexObject(const s: SString): TObject;
var
  os: SString;
  i, le: integer;
begin
  le := Length(s);
  result := Nil;
  for i := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    os := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
    os := get(i);
{$ENDIF veryfast}
    if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp(SPChar(s),
      SPChar(os), le) = 0 then
      if Length(os) = le then
      begin
        result := objects[i];
        exit;
      end;
  end;
end;

procedure TStringsHelper.DoneObjects;
var
  n: integer;
  o: TObject;
begin
  try
    for n := Count - 1 downto 0 do
    begin
      o := objects[n];
      objects[n] := nil;
      if o <> Nil then
      begin
        if (o = self) then
        begin
          o := nil;
        end;
        Freenil(o);
      end;
    end;
  except
    WarningX('error TNodeExtension.DoneAnalisis');
  end;
end;

function SumMixChar_(const aValue1: TMixString; avalue2: Char): SString;
begin
  result := aValue1.ToSt + '=' + avalue2
end;

function SumMix(const aValue1, avalue2: TMixString): SString;
begin

  result := aValue1.ToSt + '=' + avalue2.ToSt
end;

procedure TStringsHelper.SetAttributeIfno0(const attrName: TMixString);
var
  i: integer;
begin
  i := IndexMx_(attrName);
  if i < 0 then
  begin
    InsertItem(Count, SumMixChar_(attrName, '0'), nil)
  end;
end;

procedure TStringsHelper.SetAttributex(const attrName: TMixString;
  const Value: TMixString);
var
  i: integer;
begin
  i := IndexMx_(attrName);
  if (Value.lon > 0) then
  begin
    if i < 0 then
    begin
      InsertItem(Count, SumMix(attrName, Value), nil)
    end
    // AddSt(attrName + NameValueSeparator + value)
    else
    begin
      Put(i, SumMix(attrName, Value));
    end;
  end
  else
  begin
    if i >= 0 then
    begin
      Delete(i);
    end;
  end;
end;

function TxStringList.IncAttribute__(const attrName: SString;
  valor: integer = 1): integer;
var
  s: SString;
  p, i: integer;
  resulta: integer;
begin
  i := IndexOfName(attrName);
  if i < 0 then
  begin
    resulta := 0;
    i := Add('');
  end
  else
  begin
    s := get(i);
    p := PosIgual(s);
    if (p <> 0) then
    begin
      resulta := ValInt(Copy(s, p + 1, MaxInt));
    end
    else
    begin
      resulta := ValInt(s);
    end;
  end;
  inc(resulta, valor);
  Put(i, attrName + '=' // NameValueSeparator
    + StIntS(resulta));
  result := resulta;
end;

Function IsInitChar(const su: SChar; const St: SString): boolean;
begin
  if Length(St) >= 1 then
  begin
    result := su = St[1]
  end
  else
  begin
    result := false;
  end;
end;

function Str2Int64(const s: SString): Int64;
var
  e: integer;
begin
  if s = '' then
  begin
    result := 0
  end
  else
  begin
    Val(s, result, e);
    if e <> 0 then
      result := 0;
  end;
  // ConvertErrorFmt(@System.SysConst.SInvalidInteger, [S]);
end;

function ValInt64(s: SString): Int64;
begin
  try
    if s = '' then
    begin
      result := 0;
    end
    else
    begin
      while IsInitChar('0', s) do
      begin
        Delete(s, 1, 1);
      end;
      if s = '' then
      begin
        result := 0;
      end
      else
        result := Str2Int64(MiTrim_(s))
    end;
  except
    result := 0;
  end;
end;

function TxStringList.IncAttribute(const attrName: SString;
  valor: Int64 = 1): Int64;
var
  s: SString;
  p, i: integer;
  resulta: Int64;
begin
  i := IndexOfName(attrName);
  if i < 0 then
  begin
    resulta := 0;
    i := Add('');
  end
  else
  begin
    s := get(i);
    p := PosIgual(s);
    if (p <> 0) then
    begin
      resulta := ValInt64(Copy(s, p + 1, MaxInt));
    end
    else
    begin
      resulta := ValInt64(s);
    end;
  end;
  inc(resulta, valor);
  Put(i, attrName + '=' // NameValueSeparator
    + Int64Str(resulta));
  result := resulta;
end;

procedure TxStringList.SetAttribute(const attrName: SString;
  const Value: SString);
var
  i: integer;
begin
  i := FastIndexOfNamePL(SPChar(attrName), Length(attrName));
  if (Value <> '') then
  begin
    if i < 0 then
    begin
      InsertItem(Count, SumMixSS(attrName, Value), nil)
    end
    else
    begin
      Put(i, SumMixSS(attrName, Value));
    end;
    (* if i < 0 then
      i := Add('');
      Put(i, AttrName + NameValueSeparator + Value); *)
  end
  else
  begin
    if i >= 0 then
    begin
      Delete(i);
    end;
  end;
end;

function TStringsHelper.FastIndexOfNamePL(const Name: SPChar;
  le: integer): integer;
var
  s: SString;
begin
  for result := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[result].FString;
{$ELSE veryfast}
    s := get(result);
{$ENDIF veryfast}
    if Length(s) > le then
    begin
      if s[le + 1] = '=' then
      begin
        if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp(SPChar(s),
          name, le) = 0 then
        begin
          exit;
        end;
      end;
    end;
  end;
  result := -1;
end;

{ TAutoStringList }

destructor TAutoStringList.Destroy;
begin
  DoneObjects;
  inherited Destroy;
end;

function TStringsHelper.FastIndexOfName(const Name: SString): integer;
var
  le: integer;
  s: SString;
  pc: SPChar;
begin
  le := Length(Name);
  pc := SPChar(Name);
  for result := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[result].FString;
{$ELSE veryfast}
    s := get(result);
{$ENDIF veryfast}
    if Length(s) > le then
      if s[le + 1] = '=' then
      begin
        if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp(SPChar(s),
          pc, le) = 0 then
        begin
          exit;
        end;
      end;
  end;
  result := -1;
end;

function TStringsHelper.FastIndexOf(const s: SString): integer;
begin
  if sorted then
  begin
    result := inherited IndexOf(s);
    if result >= 0 then
    begin
      exit;
    end;
  end;
  for result := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    if CompareStr(TFastMatchStringLis(self).List^[result].FString, s) = 0 then
{$ELSE veryfast}
    if get(result) = s then
{$ENDIF veryfast}
    begin
      exit;
    end;
  end;
  result := -1;
end;

procedure TStringsHelper.DeleteIndexOfName(const Name: SString);
var
  re, le: integer;
  s: SString;
  pc: SPChar;

begin
  le := Length(Name);
  pc := SPChar(Name);
  for re := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[re].FString;
{$ELSE veryfast}
    s := get(re);
{$ENDIF veryfast}
    if Length(s) > le then
      if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp(SPChar(s),
        pc, le) = 0 then
      begin
        if s[le + 1] = '=' then
        begin
          Delete(re);
          exit;
        end;
      end;
  end;
end;

procedure TStringsHelper.SetAttribute(const attrName: SString;
  const Value: SString);
var
  i: integer;

begin
  i := FastIndexOfNamePL(SPChar(attrName), Length(attrName));
  if (Value <> '') then
  begin
    if i < 0 then
    begin
      InsertItem(Count, SumMixSS(attrName, Value), nil)
    end
    else
    begin
      Put(i, attrName + '=' + Value);
    end;
    (* if i < 0 then
      i := Add('');
      Put(i, AttrName + NameValueSeparator + Value); *)
  end
  else
  begin
    if i >= 0 then
    begin
      Delete(i);
    end;
  end;
end;

{$IFDEF veryfast}

procedure TStringsHelper.DeleteIndexOf(pc: SPChar; le: integer);
var
  re: integer;
  s: SString;
begin

  for re := 0 to TFastMatchStringLis(self).FCount - 1 do

  begin

    s := TFastMatchStringLis(self).List^[re].FString;
    if Length(s) > le then
      if pc^ = s[1] then

        if s[le + 1] = '=' then
          if StrLComp(SPChar(s), pc, le) = 0 then
          begin
            begin
              Delete(re);
              exit;
            end;
          end;
  end;
end;
{$ELSE veryfast}

procedure TStringsHelper.DeleteIndexOf(pc: SPChar; le: integer);
var
  re: integer;
  s: SString;
begin
{$IFDEF veryfast}
  for re := 0 to TFastMatchStringLis(self).FCount - 1 do
{$ELSE veryfast}
  for re := 0 to GetCount - 1 do
{$ENDIF veryfast}
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[re].FString;
{$ELSE veryfast}
    s := get(re);
{$ENDIF veryfast}
    if Length(s) > le then
      if s[le + 1] = '=' then
        if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp(SPChar(s),
          pc, le) = 0 then
        begin
          begin
            Delete(re);
            exit;
          end;
        end;
  end;
end;

{$ENDIF veryfast}

procedure TStringsHelper.DeleteIndexMx(const nam: TMixString);
var
  re: integer;
  s: SString;
  le: integer;
begin
  le := nam.lon;
{$IFDEF veryfast}
  for re := 0 to TFastMatchStringLis(self).FCount - 1 do
{$ELSE veryfast}
  for re := 0 to GetCount - 1 do
{$ENDIF veryfast}
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[re].FString;
{$ELSE veryfast}
    s := get(re);
{$ENDIF veryfast}
    if Length(s) > le then
      if nam.Ps_^ = s[1] then

        if s[le + 1] = '=' then
          if {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}StrLComp
            (SPChar(s), nam.Ps_, le) = 0 then
          begin
            begin
              Delete(re);
              exit;
            end;
          end;
  end;
end;

function CreaStauto: TAutoStringList;
begin
  result := TAutoStringList.Create;
end;

function StringInList_(const List: TxStringList; const n: SString): boolean;
begin
  if List = nil then
  begin
    result := false
  end
  else
  begin
    result := (List.FastIndexOf(n) >= 0)
  end;
end;

function StringAttributes_(const valores: array of const): TxStringList;
var
  mas, n: integer;
begin
  result := CreaSt;
  n := 0;
  mas := High(valores);
  while (n < mas) do
  begin
    result.Ata(Picks___(n, valores), Picks___(n + 1, valores));
    inc(n, 2);
  end;
end;

procedure FreeListNodes(var lista: TxStringList); // inline;
begin
  if lista <> Nil then
  begin
    lista.DoneObjects;
    Freenil(TObject(lista));
  end;
end;

function ToStrings_(const kk: array of const): TxStringList;
var
  i: integer;
  sta: SString;
begin
  result := CreaSt;
  for i := Low(kk) to High(kk) do
  begin
    sta := Picks___(i, kk);
    result.Add(sta);
  end;
end;

function SplitStChar_(Cha: SChar; const cadena: SString): TxStringList;
var
  ac, co: SString;
begin
  result := CreaSt;
  co := cadena;
  while co <> '' do
  begin
    ac := Fetchar(Cha, co);
    result.Add(ac)
  end;
end;

function ToStringSts(const kk: array of SString): TxStringList;
var
  os: SString;
begin
  result := TxStringList.Create;
  for os in kk do
  begin
    result.Add(os);
  end;
end;

function String2x(const kk: SString): TxStringList;
begin
  result := TxStringList.Create;
  result.AddSt(kk);
end;

Procedure TMixString.AsignaPChar(const s: SPChar; le: integer);
begin
  lon := le;
  Ps_ := s;
end;

function GetInt64p(p: SPChar; lon: integer): Int64;
var
  c: Cardinal;
  minus: boolean;
begin
  result := 0;
  if p = nil then
    exit;
  if p^ in [#1 .. ' '] then
    repeat
      inc(p);
      Dec(lon);
    until not(p^ in [#1 .. ' ']);
  if lon <= 0 then
  begin
    exit;
  end;
  if p^ = '-' then
  begin
    minus := True;
    repeat
      inc(p);
      Dec(lon);
    until p^ <> ' ';
  end
  else
  begin
    minus := false;
    if p^ = '+' then
      repeat
        inc(p);
        Dec(lon);
      until p^ <> ' ';
  end;
  if lon <= 0 then
  begin
    exit;
  end;
  c := Byte(p^) - 48;
  if c > 9 then
    exit;
  Int64Rec(result).Lo := c;
  inc(p);
  Dec(lon);
  if lon <= 0 then
  begin
    exit;
  end;
  repeat
    c := Byte(p^) - 48;
    if c > 9 then
      Break
    else
      Int64Rec(result).Lo := Int64Rec(result).Lo * 10 + c;
    inc(p);
    if Int64Rec(result).Lo >= high(Cardinal) div 10 then
    begin
      repeat
        c := Byte(p^) - 48;
        if c > 9 then
          Break
        else
          result := result shl 3 + result + result; // fast result := result*10
        inc(result, c);
        inc(p);
      until false;
      Break;
    end;
    Dec(lon);
    if lon <= 0 then
    begin
      exit;
    end;
  until false;
  if minus then
    result := -result;
end;

{$R-}

function TMixString.ToInt64(): Int64;
var
  l: integer;
  p: SPChar;
begin
  // p:=aValue.ps;
  l := lon;
  result := 0;
  if l > 0 then
    if (Ps_ <> Nil) then
    begin
      try
        // result:=StrToInt64(copy (aValue.ps,1,L))

        p := Ps_;
        inc(p, l);
        if p^ = #0 then
        begin
          // Result := StrToInt64(copY(aValue.Ps_, 1, l))
          result := GetInt64p(Ps_, l)
        end
        else
        begin
          result := GetInt64p(Ps_, l)
        end;
      except
        WarningX('Implicit Int64');
      end;
    end;
end;

class operator TMixString.Implicit(const aValue: TMixString): Int64;
var
  l: integer;
  p: SPChar;
begin
  // p:=aValue.ps;
  l := aValue.lon;
  result := 0;
  if l > 0 then
    if (aValue.Ps_ <> Nil) then
    begin
      try
        // result:=StrToInt64(copy (aValue.ps,1,L))

        p := aValue.Ps_;
        inc(p, l);
        if p^ = #0 then
        begin
          // Result := StrToInt64(copY(aValue.Ps_, 1, l))
          result := GetInt64p(aValue.Ps_, l)
        end
        else

        begin
          result := GetInt64p(aValue.Ps_, l)
        end;
      except
        WarningX('Implicit Int64');
      end;
    end;
end;

class operator TMixString.Implicit(const aValue: TMixString): integer;

var
  l: integer;
  p: SPChar;
begin
  // p:=aValue.ps;
  l := aValue.lon;
  result := 0;
  if l > 0 then
    if (aValue.Ps_ <> Nil) then
    begin
      try

        p := aValue.Ps_;
        inc(p, l);
        if p^ = #0 then
        begin
          // Result := StrToInt64(copY(aValue.Ps_, 1, l))
          result := GetInt64p(aValue.Ps_, l)
        end
        else
        begin
          result := GetInt64p(aValue.Ps_, l)
        end;
      except
        WarningX('Implicit Int64');
      end;
    end;
end;

{$IFDEF lazaruss}

class function
{$ELSE lazarus}
class operator
{$ENDIF lazarus}
  TMixString.LessThan(const aLeft: TMixString; const aRight: SString): boolean;
var
  compa, l, lr: integer;
begin
  l := aLeft.lon;
  lr := Length(aRight);
  if l = lr then
  begin
{$IFDEF XE5}
{$IFDEF AnsiModeDx}
    result := {$IFDEF AnsiModeDx}ansistrings.{$ENDIF AnsiModeDx}
      AnsiStrLComp(aLeft.Ps_, SPChar(aRight), l) < 0
{$ELSE AnsiModeDx}
      result := sysutils.StrLComp(aLeft.Ps_, SPChar(aRight), l) < 0
{$ENDIF AnsiModeDx}
{$ELSE XE5}
      result := sysutils.StrLComp(aLeft.Ps_, SPChar(aRight), l) < 0
{$ENDIF XE5}
  end
  else
  begin
    result := True;
    if lr <= l then
    begin
      l := lr;
      result := false;
    end;
    if l > 0 then
    begin

{$IFDEF AnsiModeDx}
      compa := ansistrings.AnsiStrLComp(aLeft.Ps_, SPChar(aRight), l);
{$ELSE}
      compa := StrLComp(aLeft.Ps_, SPChar(aRight), l);
{$ENDIF}
      if compa <> 0 then
      begin
        result := compa < 0
      end;
    end;
  end;
{$IFDEF testolds}
  if result <> (aLeft.ToSt < aRight) then
  begin
    result := not result
  end;
{$ENDIF testolds}
end;

{$IFDEF lazaruss}

class function
{$ELSE lazarus}
class operator
{$ENDIF lazarus}
  TMixString.LessThan(const aLeft: TMixString;
  const aRight: TMixString): boolean;
var
  compa, l: integer;
begin
  l := aLeft.lon;
  if l = aRight.lon then
  begin
{$IFDEF AnsiModeDx}
    result := ansistrings.AnsiStrLComp(aLeft.Ps_, aRight.Ps_, l) < 0
{$ELSE}
    result := StrLComp(aLeft.Ps_, aRight.Ps_, l) < 0
{$ENDIF}
  end
  else
  begin
    result := True;
    if aRight.lon <= l then
    begin
      l := aRight.lon;
      result := false;
    end;
    if l > 0 then
    begin
{$IFDEF AnsiModeDx}
      compa := ansistrings.AnsiStrLComp(aLeft.Ps_, aRight.Ps_, l);
{$ELSE}
      compa := StrLComp(aLeft.Ps_, aRight.Ps_, l);
{$ENDIF}
      if compa <> 0 then
      begin
        result := compa < 0
      end;
    end;
  end;
{$IFDEF testolds}
  if result <> (aLeft.ToSt < aRight.ToSt) then
  begin
    result := not result
  end;
{$ENDIF testolds}
end;

{$IFDEF lazaruss}

class function
{$ELSE lazarus}
class operator
{$ENDIF lazarus}
  TMixString.Equal(const aLeftOp, aRightOp: TMixString): boolean;
begin
  if aLeftOp.lon = aRightOp.lon then
  begin
{$IFDEF AnsiModeDx}
    result := ansistrings.AnsiStrLComp(aLeftOp.Ps_, aRightOp.Ps_,
      aLeftOp.lon) = 0
{$ELSE}
    result := StrLComp(aLeftOp.Ps_, aRightOp.Ps_, aLeftOp.lon) = 0
{$ENDIF}
  end
  else
  begin
    result := false
  end
end;

{$IFDEF lazaruss}

class function
{$ELSE lazarus}
class operator
{$ENDIF lazarus}
  TMixString.NotEqual(const aLeftOp, aRightOp: TMixString): boolean;
begin
  if aLeftOp.lon = aRightOp.lon then
  begin
{$IFDEF AnsiModeDx}
    result := ansistrings.AnsiStrLComp(aLeftOp.Ps_, aRightOp.Ps_,
      aLeftOp.lon) <> 0
{$ELSE}
    result := StrLComp(aLeftOp.Ps_, aRightOp.Ps_, aLeftOp.lon) <> 0
{$ENDIF}
  end
  else
  begin
    result := True
  end
end;

{$IFDEF lazaruss}

class function
{$ELSE lazarus}
class operator
{$ENDIF lazarus}
  TMixString.Equal(const aLeftOp: TMixString; const aRightOp: SString): boolean;
begin
  if aLeftOp.lon = Length(aRightOp) then
  begin
{$IFDEF AnsiModeDx}
    result := ansistrings.AnsiStrLComp(aLeftOp.Ps_, SPChar(aRightOp),
      aLeftOp.lon) = 0
{$ELSE}
    result := StrLComp(aLeftOp.Ps_, SPChar(aRightOp), aLeftOp.lon) = 0
{$ENDIF}
  end
  else
  begin
    result := false
  end
end;

class operator TMixString.Equal(const aLeftOp: SString;
  const aRightOp: TMixString): boolean;
begin
  if Length(aLeftOp) = aRightOp.lon then
  begin
{$IFDEF AnsiModeDx}
    result := ansistrings.AnsiStrLComp(aRightOp.Ps_, SPChar(aLeftOp),
      aRightOp.lon) = 0

{$ELSE}
    result := StrLComp(aRightOp.Ps_, SPChar(aLeftOp), aRightOp.lon) = 0
{$ENDIF}
  end
  else
  begin
    result := false
  end
end;

function TMixString.FixSpaces: boolean;

var
  p: SPChar;
begin
  result := false;
  if (lon > 0) and (Ps_ <> nil) then
  begin

    // Result := false;
    p := Ps_ + lon;
    Dec(p);
    if p^ = ' ' then
    begin
      result := True;

      Dec(lon);

      while lon > 0 do
      begin
        Dec(p);
        if p^ <> ' ' then
        begin
          Break;
        end;
        Dec(lon);

      end;
    end;
  end
  else
  begin
    // Result := false
  end;
  // Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, Ps_,    Lon, PChar(aRightOp), Length(aRightOp)) = 2;

end;

function TMixString.IsNull: boolean;
begin
  result := lon = 0
  // Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, Ps_,    Lon, PChar(aRightOp), Length(aRightOp)) = 2;

end;

function TMixString.EqualUp(const aRightOp: SString): boolean;
begin
{$IFNDEF AnsiModeDx}
  result := UpSts = UpperCase(aRightOp);

{$ELSE}
  // Result := UpSts = UpSt(aRightOp);
{$IFDEF xe5}
  result := CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE, Ps_, lon,
    SPChar(aRightOp), Length(aRightOp)) = 2;
{$ELSE xe5}
  result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, Ps_, lon,
    PChar(aRightOp), Length(aRightOp)) = 2;
{$ENDIF xe5}
{$ENDIF}
end;

class operator TMixString.Implicit(const aValue_: SString): TMixString;
begin
  result.Ps_ := SPChar(aValue_);
  result.lon := Length(aValue_);
end;

class operator TMixString.Implicit(const aValue: PMixString): TMixString;
begin
  if aValue = nil then
  begin
    result.NulString
  end
  else
  begin
    result.AsignaPChar(aValue.Ps_, aValue.lon);
  end;
end;

class operator TMixString.GreaterThan(const aLeft: TMixString;
  const aRight: SString): boolean;
var
  compa, l, lr: integer;
begin
  l := aLeft.lon;
  lr := Length(aRight);
  result := false;
  if lr < l then
  begin
    l := lr;
    result := True;
  end;
  if l > 0 then
  begin
{$IFDEF AnsiModeDx}
    compa := ansistrings.AnsiStrLComp(aLeft.Ps_, SPChar(aRight), l);

{$ELSE }
    compa := StrLComp(aLeft.Ps_, SPChar(aRight), l);
{$ENDIF }
    if compa <> 0 then
    begin
      result := compa > 0
    end;
  end;
{$IFDEF testolds}
  if result <> (aLeft.ToSt > aRight) then
  begin
    result := not result
  end;
{$ENDIF testolds}
end;

class operator TMixString.GreaterThanOrEqual(const aLeft: TMixString;
  const aRight: TMixString): boolean;
var
  compa, l: integer;
begin
  l := aLeft.lon;
  result := false;
  if (l = aRight.lon) then
  begin
{$IFDEF AnsiModeDx}
    compa := ansistrings.AnsiStrLComp(aLeft.Ps_, aRight.Ps_, l);
{$ELSE }
    compa := StrLComp(aLeft.Ps_, aRight.Ps_, l);
{$ENDIF }
    result := compa >= 0
  end
  else
  begin

    if aRight.lon < l then
    begin
      l := aRight.lon;
      result := True;
    end;
    if l > 0 then
    begin
{$IFDEF AnsiModeDx}
      compa := ansistrings.AnsiStrLComp(aLeft.Ps_, aRight.Ps_, l);

{$ELSE }
      compa := StrLComp(aLeft.Ps_, aRight.Ps_, l);
{$ENDIF }
      if compa <> 0 then
      begin
        result := compa >= 0
      end
      else
      begin
        // Result := True;
      end;
    end;
{$IFDEF testolds}
    if result <> (aLeft.ToSt >= aRight.ToSt) then
    begin
      compa := StrLComp(aLeft.Ps_, aRight.Ps_, l);
      if compa <> 0 then
      begin
        result := compa >= 0
      end
      else
      begin
        result := True;
      end;
      if result <> (aLeft.ToSt >= aRight.ToSt) then
      begin
        result := not result
      end;
      // result:=not result
    end;
{$ENDIF testolds}
  end;

end;

class operator TMixString.GreaterThan(const aLeft: TMixString;
  const aRight: TMixString): boolean;
var
  compa, l: integer;
begin
  l := aLeft.lon;
  result := false;
  if aRight.lon < l then
  begin
    l := aRight.lon;
    result := True;
  end;
  if l > 0 then
  begin
{$IFDEF AnsiModeDx}
    compa := ansistrings.AnsiStrLComp(aLeft.Ps_, aRight.Ps_, l);
{$ELSE }
    compa := StrLComp(aLeft.Ps_, aRight.Ps_, l);
{$ENDIF }
    if compa <> 0 then
    begin
      result := compa > 0
    end;
  end;
{$IFDEF testolds}
  if result <> (aLeft.ToSt > aRight.ToSt) then
  begin
    result := not result
  end;
{$ENDIF testolds}
end;

class operator TMixString.Implicit(const aValue: TMixString): SString;
// overload;
begin

  if (aValue.lon > 0) and (aValue.Ps_ <> Nil) then
  begin
    try
      SetString(result, aValue.Ps_, aValue.lon);
    except
      result := '';
    end;
  end
  else
  begin
    result := '';
  end;
end;

function TMixString.ToSt: SString;
begin
  if (lon > 0) and (Ps_ <> Nil) then
  begin
    SetString(result, Ps_, lon);

  end
  else
  begin
    result := '';
  end;
end;

Procedure TMixString.Init(const aValue_: SString);
begin
  Ps_ := SPChar(aValue_);
  lon := Length(aValue_);
end;

function TMixString.IsUpperCases: boolean;
var
  i, len: integer;

  SrcP: SPChar;
  ch: SChar;
begin
  len := lon;
  result := True;
  if len > 0 then
  begin
    result := True;
    SrcP := Ps_;
    for i := len downto 1 do
    begin
      ch := SrcP^;
      case ch of
        'a' .. 'z':
          begin
            result := false;
            Break;
          end;
      end;

      inc(SrcP);
    end;
  end;
end;

Function TMixString.UpSts: SString;
var
  i: integer;
  // c: char;
begin
  result := '';
  if lon > 0 then
    if (Ps_ <> Nil) then
    begin
      try
        SetString(result, Ps_, lon);
        for i := LowSt_ to LastChar(result) do
        begin
          case result[i] of
            'a' .. 'z':

              Dec(result[i], Ord('a') - Ord('A'));

          end;
        end;
      except
        result := '';
      end;
    end;

end;

function TMixString.Match(const s: SString; len: integer): boolean;
begin
  if (Length(s) >= len) and (lon <= len) then
  begin
{$IFDEF AnsiModeDx}
    result := ansistrings.AnsiStrLComp(Ps_, SPChar(s), len) = 0

{$ELSE }
    result := StrLComp(Ps_, SPChar(s), len) = 0
{$ENDIF }
  end
  else
  begin
    result := false
  end
end;

Procedure TMixString.NulString;
begin
  lon := 0;
  Ps_ := nil;
end;

{$IFDEF AnsiPure}

class operator TMixString.Add(const aLeftOp: SString;
  const aRightOp: TMixString): SString;
var
  ini, le, lon: integer;
  pc: SPChar;
begin
  le := Length(aLeftOp);
  lon := le + aRightOp.lon;
  pc := SPChar(aLeftOp);
  if lon > 0 then
  begin
    if (aRightOp.Ps_ <> Nil) then
    begin
      try
        if result = '' then
        begin
          setLength(result, lon);
        end
        else
        begin
          result := ''; // UniqueString(result);
          setLength(result, lon);
        end;

        if le > 0 then
        begin
          move(pc^, result[1], le * StCharSize_);
          ini := le + 1
        end
        else
        begin
          ini := 1
        end;
        move(aRightOp.Ps_^, result[ini], aRightOp.lon * StCharSize_);
      except
        result := '';
      end;
    end
    else
    begin
      result := aLeftOp
    end;
  end
  else
  begin
    result := '';
  end;
end;

{$ELSE AnsiPure}

class operator TMixString.Add(const aLeftOp: SString;
  const aRightOp: TMixString): SString;

begin

  result := aLeftOp + aRightOp.ToSt;

end;

{$ENDIF AnsiPure}
{ TMixPair }

procedure ReplaceCOMA(var St: SString);
var
  i: word;
Begin
  for i := 1 to Length(St) do
  Begin
    if St[i] = ',' then
    begin
      UniqueString(St);
      St[i] := '.';
      exit;
    end;
  end;
end;

function ValReal(const St: SString): Double;
var
  r: Double;
  c: integer;
  s: SString;
begin
  result := 0;
  s := St;
  if LIMPIASt(s) then
  Begin
    ReplaceCOMA(s);
    // ReplaceChars(s, ',', '.');
    try
      c := 0;
      Val(s, r, c);
      while not((c = 0) or (c > Length(s)) or (Length(s) = 0)) do
      begin
        Delete(s, c, 1);
        Val(s, r, c)
      end;
      if Length(s) <> 0 then
      begin
        result := r
      end;
    except
      result := 0;
    end;
  end;
end;

function TMixString.ToReal: Reales;
// var  c: INTEGER;
begin
  result := ValReal(ToSt);
end;

procedure TMixString.SetLongTo(pc: SPChar);
begin
  lon := pc - Ps_;
end;

function TMixString.PosIgual(): integer;
var
  i: integer;
  Pp: SPChar;
begin
  result := 0;
  Pp := Ps_;
  if Pp <> nil then

    for i := 1 to lon do
    begin
      if Pp^ = ChIgual then

      begin
        result := i;
        exit;
      end;
      inc(Pp)
    end;
end;

procedure TMixPair.Inits(const os: SString);
var
  po: integer;
begin
  po := PosIgual(os);
  if po > 0 then
  begin
    s := os;
    Nombre.Ps_ := SPChar(s);
    Nombre.lon := po - 1;
    valor.Ps_ := SPChar(s) + po;
    valor.lon := Length(os) - po;
  end
  (* else if s = '' then
    begin
    NulString(Nombre);
    NulString(Valor);
    end *)
  else
  begin
    Nombre.lon := Length(os);
    s := os;
    Nombre.Ps_ := SPChar(s);
    // AsignarString(Nombre, s, 1, Length(os));
    NulString(valor);
  end;
end;

class operator TMixPair.Explicit(const aValue: SString): TMixPair;
begin
  result.Inits(aValue);

end;

class operator TMixPair.Implicit(const aValue: SString): TMixPair;
begin
  result.Inits(aValue);
end;

{ TPairData }

function TMixPair.SpaceAtrib: SString;
begin
  result := ' ' + Nombre + '="' + valor + '"'
end;

type
  Int64Rec = packed record
    case integer of
      0:
        (Lo, Hi: Cardinal);
      1:
        (Cardinals: array [0 .. 1] of Cardinal);
      2:
        (Words: array [0 .. 3] of word);
      3:
        (Bytes: array [0 .. 7] of Byte);
  end;

Procedure NulString(var ms: TMixString); inline;
begin
  ms.lon := 0;
  ms.Ps_ := nil;
end;

function SumMixChars(const aValue1: TMixString;
  const value2: TMixString): SString;
begin
  result := aValue1.ToSt + '.' + value2.ToSt
end;

function TMixPair.FindNameVal: SString;
begin
  result := SumMixChars(Nombre, valor)
end;

function TAnsiStreamHelper.WrBytes(const Buffer; Count: longint): longint;
var
  ss: TStream;
begin
  ss := self;
  if ss <> nil then
  begin
    ss.Write(Buffer, Count)
  end;
end;

{$IFDEF NoAnsiMode}

procedure TAnsiStreamHelper.Writa(const St: StreamString);
var
  Encoding: TEncoding;
  Buffer, Preamble: TBytes;
begin
  Encoding := TEncoding.ANSI;
  Buffer := Encoding.GetBytes(St);
  if St <> '' then
  begin
    WriteBuffer(Buffer, Length(Buffer));
    // ss.Write(st[1], Length(st))
  end;

end;

procedure TAnsiStreamHelper.WriteChar(const ch: SChar);
begin
  Writa(ch);
end;

{$ELSE}

procedure TAnsiStreamHelper.Writa(const St: StreamString);
begin
  if St <> '' then
  begin
    Write(St[1], Length(St))
  end;

end;

procedure TAnsiStreamHelper.WriteChar(const ch: SChar);
begin
  Write(ch, 1);
end;

{$ENDIF}

procedure TAnsiStreamHelper.wln(const St: SString);
begin
  Writa(St + EOL_)
end;

procedure TAnsiStreamHelper.wmx(const mx: TMixString);
begin
  Writa(mx) // optimizas
end;

procedure TAnsiStreamHelper.__(const data: array of const);
begin
  Writa(Ssum(data))
end;

{$IFDEF xe5}
{$IFDEF AnsiModeDx}

function TAnsiStreamHelper.ReadString(Max: Int64): StreamString;
begin
  result := '';
  try
    if Max = 0 then
    begin
      Max := Size
    end;
    if Max > 0 then
    begin
      setLength(result, Max);
      Read(result[1], Max);
    end;
  except
    result := '';
  end;
end;

{$ELSE AnsiModeDx}

function TAnsiStreamHelper.ReadString(Max: Int64): StreamString;
var
  AEncoding: TEncoding;
  Buffer: TBytes;
  Si: integer;
begin
  result := '';
  AEncoding := nil;
  try
    setLength(Buffer, Max);
    Read(Buffer, 0, Max);
    Si := TEncoding.GetBufferEncoding(Buffer, AEncoding, TEncoding.Default);
    // SetEncoding(Encoding); // Keep Encoding in case the stream is saved
    result := AEncoding.GetString(Buffer, Si, Length(Buffer) - Si);

  except
    result := '';
  end;
end;

{$ENDIF AnsiModeDx}
{$ELSE xe5}

function TAnsiStreamHelper.ReadString(Max: Int64): StreamString;
begin
  result := '';
  try
    if Max > 0 then
    begin
      setLength(result, Max);
      Read(result[1], Max);
    end;
  except
    result := '';
  end;
end;

{$ENDIF xe5}

function TAnsiStreamHelper.ReadStreams(ini, maxLen: integer): StreamString;
var
  lon: integer;
begin
  try
    result := '';
    if self <> Nil then
    begin
      Position := ini;
      lon := Size - ini; // ss.Position;
      if (maxLen > 0) and (lon > maxLen) then
      begin
        lon := maxLen;
      end;
      result := ReadString(lon);
    end;
  except
    result := ''
  end;
end;

function TAnsiStreamHelper.CharSize: integer;
begin
  result := 1
end;

function TAnsiStreamHelper.ReadStreamMax__(maxLen: integer = 0): StreamString;
var
  // size,
  lon: integer;
  // Buffer: TBytes;
begin
  result := '';
  if self <> Nil then
  begin
    lon := Size;
    if (maxLen > 0) and (lon > maxLen) then
    begin
      lon := maxLen;
    end;
    Position := 0;
    result := ReadString(lon);
  end;
end;

{$IFDEF AnsiPure}

(*
function TAtribute.SumMix(): SString;
begin
  result := Name_.ToSt + '=' + Value.ToSt
end;
*)

function TAtribute.SumMixPP(): SString;
var
  pr: SPChar;
  lon: integer;
begin
  lon := Name_.lon + Value.lon + 1;
  setLength(result, lon);
  pr := SPChar(result);
  if Name_.Ps_ <> Nil then
  begin
    move(Name_.Ps_^, pr^, Name_.lon * StCharSize_);
  end;
  inc(pr, Name_.lon);
  pr^ := '=';
  inc(pr);
  if Value.lon > 0 then
  begin
    move(Value.Ps_^, pr^, Value.lon * StCharSize_);
  end;
end;

{$ELSE AnsiPure}

function TAtribute.SumMixPP(): SString;
var
  pr: SPChar;
  lon: integer;
begin
  lon := Name_.lon + Value.lon + 1;
  setLength(result, lon);
  pr := SPChar(result);
  if Name_.Ps_ <> Nil then
  begin
    move(Name_.Ps_^, pr^, Name_.lon * StCharSize_);
  end;
  inc(pr, Name_.lon);
  pr^ := '=';
  inc(pr);
  if Value.lon > 0 then
  begin
    move(Value.Ps_^, pr^, Value.lon * StCharSize_);
  end;
end;

{$ENDIF AnsiPure}

procedure TAtribute.Inits(const os: SString);
var
  po: integer;
begin
  po := PosIgual(os);
  if po > 0 then
  begin
    Name_.Ps_ := SPChar(os);
    Name_.lon := po - 1;
    Value.Ps_ := SPChar(os) + po;
    Value.lon := Length(os) - po;
  end
  else
  begin
    Name_.lon := Length(os);
    Name_.Ps_ := SPChar(os);
    // AsignarString(Nombre, s, 1, Length(os));
    NulString(Value);
  end;
end;

Procedure AsignStr(var ms: TMixString; const s: SString);
begin
  ms.lon := Length(s);
  ms.Ps_ := SPChar(s);
end;

function SCount_(re: TStrings): integer;
begin
  if re = nil then
  begin
    result := 0
  end
  else
  begin
    result := re.Count;
  end;
end;

function Picks___(n: integer; const valores: array of const): SString;
var
  sta: SString;
begin
  with valores[n] do
    case VType of
      vtInteger:
        sta := StIntS(VInteger);
      vtBoolean:
        if vBoolean then
          sta := 'YES'
        else
          sta := 'NO';
      vtAnsiString:
        sta := SString(VAnsiString);
      vtChar:
        sta := VChar;
      vtPChar:
        sta := VPChar;
{$IFNDEF android}
      vtWideString:
        sta := WideString(VWideString);
      vtString:
        sta := VString^;

      vtObject:
        (* ?
          if VObject is TXml then
          begin
          sta := RenderFree(VObject as TXml)
          end
          else
        *)
        sta := VObject.ClassName;

{$ENDIF android}
      vtExtended:
        sta := FloatToStr(VExtended^);
      vtClass:
        sta := VClass.ClassName;

      vtCurrency:
        sta := CurrToStr(VCurrency^);
      vtVariant:
        sta := SString(VVariant^);

      vtWideChar:
        sta := VWideChar;

      vtInt64:
        sta := StIntS(VInteger);
{$IFDEF xe5}
      // vtString
      vtUnicodeString:
        sta := unicodestring(VUnicodeString);

{$ENDIF }
      // vtPointer       = 5;
      // vtPWideChar     = 10;
      // vtInterface     = 14;

    else
      begin
        sta := '';
      end;
    end;

  // end;
  result := sta;
end;

procedure TEvaluateLong.Inits(e: TEnumerator);
begin
  if e <> nil then
  begin
    fLast := e.fLast;
    fIndex := e.fLast;
  end
  else
  begin
    fLast := 0;
    fIndex := 0;
  end;
  enum := e;
end;

procedure TEnumerator.Log_(mode: TModeEnum);
begin
  if assigned(LogEnums_) then
  begin
    LogEnums_(mode, self);
  end;
end;

destructor TEnumerator.Destroy;
begin
  if assigned(LogEnums_) then
  begin
    LogEnums_(menEnd, self);
  end;
  // Log(menEnd);
  if Compone_ <> nil then
  begin
    Compone_.free;
    Compone_ := Nil;
  end;
  inherited Destroy;
end;

function TEnumerator.Info_(__i: integer; _mode: TModeEnum): SString;
begin
  result := ''
end;

function TEnumerator.CountIni_: integer;
begin
  result := -1;
end;

constructor TEnumerator.Create(const d: Pointer; const comp: TObject);
begin
  inherited Create;

  data := d;
  Id := -1;
  fIndex := -1;
  fLast := CountIni_;
  OwnerEnumerator := nil;

  Compone_ := comp;

  Log_(menIni);
end;

function TEnumerator.EvaluarActual: TEvaluateLong;
begin
  result.Inits(self)
end;

function TStringEnums.GetCurrent: SString;
begin
{$IFDEF enufaster}
  result := TFastMatchStringLis(data).List[fIndex].FString;
{$ELSE enufaster}
  result := TStringList(data).Strings[fIndex];
{$ENDIF enufaster}
end;

function TStringEnums.CountIni_: integer;
begin
  result := CountString_
end;

function TStringEnumeratorBas.CountIni_: integer;
begin
  if data = nil then
  begin
    result := 0
  end
  else
  begin
{$IFDEF enufaster}
    result := TFastMatchStringLis(data).Count;
{$ELSE enufaster}
    result := TStringList(data).Count
{$ENDIF enufaster}
  end;
end;

function TEnumeraOnjects.GetEnumerator: TsEnumObj;
begin
  result := TsEnumObj.Create(data_, self);
end;
{$IFDEF enulogger}

function TEnumeratorRecord.MoveNext: boolean;
begin
  inc(fIndex);
  if fIndex >= fLast_ then
  begin
    result := false;
    if assigned(LogStatic) then
    begin
      LogStatic(menEnd, Id);
    end;
  end
  else
  begin
    result := True
  end;
end;

{$ELSE  enulogger}

function TEnumeratorRecord.MoveNext: boolean;
begin
  inc(fIndex);

{$IFDEF enuLocal}
  if fIndex < fLast_ then
  begin
    result := True;
{$IFDEF enufaster}
    stcurrent := PtStringItemList(data_)^[fIndex].FString;
{$ELSE enufaster}
    stcurrent := TStringList(data_)[fIndex];
{$ENDIF enufaster}
  end
  else
  begin
    result := false;
    stcurrent := ''
  end;
{$ELSE enuLocal}
  result := fIndex < fLast_;
{$ENDIF enuLocal}
end;

{$ENDIF enulogger}

procedure TEnumeratorRecord.Init(const d: Pointer; const las: integer);
begin
  data_ := d;
  Id := -1;
  fIndex := -1;
  fLast_ := las;
end;

function TEnumeratorRecord.CurrentObject: TObject;
begin
{$IFDEF enufaster}
  result := PtStringItemList(data_)^[fIndex].fObject;
{$ELSE enufaster}
  result := TStringList(data_).objects[fIndex];
{$ENDIF enufaster}
end;

{$IFNDEF enuLocal}

function TEnumeratorRecord.GetCurrent: SString;
begin
{$IFDEF enufaster}
  result := PtStringItemList(data_)^[fIndex].FString;
{$ELSE enufaster}
  result := TStringList(data_)[fIndex];
{$ENDIF enufaster}
end;
{$ENDIF enuLocal}

procedure TEnumeratorRecord.InitListString(Ax_: Pointer);
begin
  fIndex := -1;
  if assigned(Ax_) then
  begin
{$IFDEF enufaster}
    fLast_ := TFastMatchStringLis(Ax_).Count;;
{$IFDEF xe5}
    data_ := @TFastMatchStringLis(Ax_).List;
{$ELSE xe5}
    data_ := TFastMatchStringLis(Ax_).List;
{$ENDIF xe5}
{$ELSE enufaster}
    fLast_ := TStringList(Ax_).Count;
    data_ := Ax_;
{$ENDIF enufaster}
  end
  else
  begin
    data_ := Ax_;
    fLast_ := 0
  end;
{$IFDEF enulogger}
  if assigned(LogStatic) then
  begin
    Id := LogStatic(menIni, fLast_);
  end
  else
  begin
    Id := 0;
  end;
{$ENDIF enulogger}
end;

function TEnumeratorRecord.CountIni_: integer;
begin
  if data_ = nil then
  begin
    result := 0
  end
  else
  begin
{$IFDEF enufaster}
    result := TFastMatchStringLis(data_).Count;
{$ELSE enufaster}
    result := TStringList(data_).Count
{$ENDIF enufaster}
  end;
end;

function TEnumeratoIndex.MoveNext: boolean;
begin
  inc(fIndex);
  result := fIndex < fLast;
  // inc(REC.fIndex);
  // result := REC.fIndex < REC.FLast_;
end;

function TEnumeratoIndex.CountString_: integer;
begin
  if data = nil then
  begin
    result := 0
  end
  else
  begin
{$IFDEF enufaster}
    result := TFastMatchStringLis(data).Count;
{$ELSE enufaster}
    result := TStringList(data).Count
{$ENDIF enufaster}
  end;
end;

function TMonoEnumerator.CountIni_: integer;
begin
  result := 1
end;

constructor TMonoEnumerator.Create(const d: Pointer = nil;
  const comp: TObject = nil);
begin
  inherited Create(d, comp);
end;

function TMonoEnumerator.MoveNext: boolean;
begin
  inc(fIndex);
  result := fIndex < fLast;
end;

procedure TInfoEnumerator.Init(const aValue: TEnumerator);
begin
  self.Base := aValue
end;

class operator TInfoEnumerator.Implicit(const aValue: TEnumerator)
  : TInfoEnumerator;
begin
  result.Base := aValue
end;

function TSelfEnumerator.GetCurrent: TInfoEnumerator;
begin
  result.Init(self) // := self
end;

constructor TxEnumFactory.Create(const ds: TObject);
begin
  inherited Create;
  // filtro_.Init_;
  ownerEnum := nil;
  desde__ := 0;
  data_ := ds;
end;

function TsEnumObj.GetCurrent: PxStringItem;
begin
  result := @TFastMatchStringLis(data).List[fIndex];

  // result := @TFastMatchStringLis(data).List[fIndex];

end;

function isLimpiarSt(const St: SString): boolean;
var
  i, l: word;
BEGIN
  result := false;
  l := Length(St);
  i := 1;
  while (i <= l) do
  Begin
    if (St[i] = ' ') or (Ord(St[i]) = 0) then
      inc(i)
    else
      Break;
  end;
  if i > l then
  Begin
    result := True;
  end
end;

function Fetchar(sDelim: SChar; var s1: SString): SString; overload;
var
  iPos: integer;
begin
  iPos := CharPosA__(sDelim, s1);
  If iPos = 0 then
  begin
    result := s1;
    s1 := '';
  end
  else
  begin
    result := Copy(s1, 1, iPos - 1); // ? string0?
    Delete(s1, 1, iPos); // ? string0?
  end;
end;

function EsVacia(const St: SString): boolean;
begin
  result := St = '';
  if not result then
  begin
    result := isLimpiarSt(St); // Length(Trim(st)) = 0;
  end;
end;

function FetchValDel(var s1: SString): SString;
var
  iPos: integer;
begin
  iPos := PosIgual(s1);
  If iPos = 0 then
  begin
    result := s1;
    s1 := '';
  end
  else
  begin
    result := Copy(s1, 1, iPos - 1);
    Delete(s1, 1, iPos + 1);
  end;
end;

function Posi(const substr, str: SString): integer; overload;
begin
  result := PosEx(substr, str, 1);
end;

function PosChar(const c: SChar; const s: SString): integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to Length(s) do
  begin
    if s[i] = c then
    begin
      result := i;
      exit;
    end;
  end;
end;

function StIntS(Value: integer): SString;
begin
  result := IntTostr(Value);
end;

function IdemPCharL(p: SPChar; up: SPChar; lon: integer): boolean;
// if the beginning of p^ is same as up^ (ignore case - up^ must be already Upper)
begin
  result := false;
  if (p = nil) or (up = nil) then
    exit;

  while up^ <> #0 do
  begin
    if (up^ <> p^) then
      exit;
    inc(up);
    inc(p);
    Dec(lon);
    if lon = 0 then
    begin
      Break;
    end;
  end;
  result := True;
end;

function StrPosL(uppersubstr, str: SPChar; lon: integer): SPChar;
var
  c: SChar;
begin
  if (uppersubstr <> nil) and (str <> nil) then
  begin
    c := uppersubstr^;
    result := str;
    while result^ <> #0 do
    begin
      if result^ = c then
        if IdemPCharL(result + 1, SPChar(uppersubstr) + 1, lon) then
          exit;
      inc(result);
    end;
  end;
  result := nil;
end;

function CharPosZero(Ch_: SChar; const str: SString): integer;
var
  i: integer;
begin
  result := -1;
  for i := LowSt_ to LastChar(str) do
  begin
    if str[i] = Ch_ then
    begin
      result := i;
      exit;
    end;
  end;
end;

function CharInSt(ch: SChar; const str: SString): boolean;
begin
  result := CharPosZero(ch, str) >= LowSt_
end;

function SumMixPP(const aValue1: SPChar; le1: integer; const avalue2: SPChar;
  le2: integer): SString;
var
  pr: SPChar;
  lon: integer;
begin
  try
    if le1 <= 0 then
    BEGIN
      result := '';
      exit;
    end;
    if le2 < 0 then
    BEGIN
      result := '';
      exit;
    end;
    (* if le1 >= 100 then
      BEGIN
      Result := '';
      Exit;
      end; *)
    lon := le1 + le2 + 1;
    setLength(result, lon);
    pr := SPChar(result);
    if aValue1 <> Nil then
    begin
      move(aValue1^, pr^, le1 * StCharSize_);
    end;
    inc(pr, le1);
    pr^ := '=';
    inc(pr);
    if le2 > 0 then
    begin
      move(avalue2^, pr^, le2 * StCharSize_);
    end;
  except
    result := ''
  end;
end;

function ValoraInt(s: SString): longint;
begin
  try
    if s = '' then
    begin
      result := 0;
    end
    else
    begin
      while IsInitChar('0', s) do
      begin
        Delete(s, 1, 1);
      end;
      if s = '' then
      begin
        result := 0;
      end
      else
        result := Str2Int(MiTrim_(s))
    end;
  except
    result := 0;
  end;
end;

function ValInt(const s: SString): longint;
begin
  try
    result := ValoraInt(s);
  except
    result := 0;
  end;
end;

function IGUALESSS(const na1, na2: SString): boolean;
begin
  result := CompareText(na1, na2) = 0;
end;

procedure TodoError(const mas: SysString = '');
begin
  raise Exception.Create(mas);
end;

Function LIMPIASt(var s: SString): boolean;
var
  i, l, len: integer;
Begin
  if s = '' then
  begin
    result := True;
    exit;
  end;
  len := Length(s);

  if (s[1] <= ' ') then
  begin
    i := 2;
    while (i <= len) and (s[i] <= ' ') do
      inc(i);
    if i > len then
    begin
      s := '';
      result := True;
      exit;
    end;
  end
  else
  begin
    i := 1;
  end;

  begin
    l := len;
    while s[l] <= ' ' do
      Dec(l);
    if (i > 1) or (l < len) then
    begin
      s := Copy(s, i, l - i + 1);
    end;
  end;

  result := s <> '';
end;

Function CopyZero(const n: SString; ini, lon: integer): SString;
Begin
  result := Copy(n, ini, lon)

end;

constructor TInterfaceObject.Create;
begin
  inherited Create;
  FRefenced_ := True;
{$IFDEF TracesXml}
  AddgListObject(self);
{$ENDIF TracesXml}
  // FRefCount := 0;
end;

constructor TInterfaceObject.Creates;
begin
  inherited Create;
  FRefenced_ := True;
  // FRefCount := 0;
end;

destructor TInterfaceObject.Destroy;
begin
{$IFDEF TracesXml}
  RemoveListObjects(self);
{$ENDIF TracesXml}
  // if FRefCount <> 0 then    WarningTodo(['TInterfaceObject.beforedestruc']);
  inherited Destroy;
end;

procedure TInterfaceObject.DoReferenced(const como: boolean);
begin
  FRefenced_ := como;
end;

{$IFNDEF AUTOREFCOUNT}

procedure TInterfaceObject.AfterConstruction;
begin
  // Release the constructor's implicit refcount
{$IFDEF Android}
  // Result :=
  AtomicDecrement(FRefCount);
{$ELSE}
  InterlockedDecrement(FRefCount);
{$ENDIF}
end;

procedure TInterfaceObject.BeforeDestruction;
begin
  if FRefCount <> 0 then
  begin
    WarningX('before destruc');
  end;
end;

class function TInterfaceObject.NewInstance: TObject;
begin
  result := inherited NewInstance;
  TInterfaceObject(result).FRefCount := 1;
end;

{$ELSE}
{$ENDIF}

function TInterfaceObject.Componente: TObject;
begin
  result := self
end;

{$IFDEF FPC}

function TInterfaceObject.QueryInterface
  ({$IFDEF FPC_HAS_CONSTREF}constref{$ELSE}const
{$ENDIF} iid: tguid; out obj): longint; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
{$ELSE}

function TInterfaceObject.QueryInterface(const iid: tguid; out obj): HResult;
{$ENDIF}
begin
  if GetInterface(iid, obj) then
    result := 0
  else
    result := E_NOINTERFACE;
end;

{$IFDEF FPC}

function TInterfaceObject._AddRef: longint; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
{$ELSE}

function TInterfaceObject._AddRef: integer;
{$ENDIF}
begin
{$IFDEF Android}
  result := __ObjAddRef;
  // AtomicIncrement(FRefCount);
{$ELSE}
  result := InterlockedIncrement(FRefCount);
{$ENDIF}
  if result > 2 then
  begin
    if result > 100 then
    begin
      WarningX('muchos');
    end;
  end;
end;

{$IFDEF FPC}

function TInterfaceObject._Release: longint; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
{$ELSE}

function TInterfaceObject._Release: integer;
{$ENDIF}
begin
{$IFDEF Android}
  result := __ObjRelease;
  // AtomicDecrement(FRefCount);
{$ELSE}
  result := InterlockedDecrement(FRefCount);
{$ENDIF}
  if (result = 0) and FRefenced_ then
  begin
    Destroy;
  end;
end;

constructor TClassAutoDone.Create(const obj: Pointer = nil;
  const doproc: TDoneProc = nil);
begin
  inherited Creates;
  MonaDone.Init(obj, doproc);
  // syn:=nil;
  // fMonada := obj;
end;

destructor TClassAutoDone.Destroy;
begin
  MonaDone.RunDone;
  inherited;
end;

procedure TClassAutoDone.Done;
begin
  MonaDone.Done
end;

function TClassAutoDone.GetMonada: Pointer;
begin
  result := MonaDone.fMonada
end;

{ TRecAutoDone }
function NewAutoDoneClass(const aValue: Pointer; const doproc: TDoneProc = nil)
  : TClassAutoDone;
begin
  result := TClassAutoDone.Create(aValue, doproc);
end;

function NewAutoDone(const aValue: Pointer; const doproc: TDoneProc = nil)
  : IAutoDone;
begin
  result := TClassAutoDone.Create(aValue, doproc);
end;

procedure TRecAutoDone.SetObj_(const aValue: Pointer;
  const doproc: TDoneProc = nil);
begin
  auto_ := Nil;
  if aValue <> nil then
  begin
    auto_ := NewAutoDone(aValue, doproc);
  end;
end;

procedure TRecAutoDone.Done;
begin
  if auto_ <> nil then
  begin
    auto_.Done;
  end
end;

function TRecAutoDone.GetObject: Pointer;
begin
  if auto_ = nil then
  begin
    result := nil
  end
  else
  begin
    result := auto_.GetMonada
  end;
end;

function TRecAutoDone.HasAuto: boolean;
begin
  result := auto_ <> nil
end;

procedure TRecAutoDone.Init;
begin
  auto_ := nil
end;

{ TRecRunAutoDone }

procedure TRecRunAutoDone.Init(const obj: Pointer; const doproc: TDoneProc);
begin
  fMonada := obj;
  DoneProc := doproc;
end;

procedure TRecRunAutoDone.Done;
begin
  fMonada := Nil;
  DoneProc := Nil;
end;

procedure TRecRunAutoDone.RunDone;
begin
  if fMonada <> nil then
    if assigned(DoneProc) then
    begin
      DoneProc(fMonada)
    end;
  inherited;
end;

constructor TBufferFileStream.CreateRead(const AFileName: SString;
  BufferSize: integer);
begin
  Create(AFileName, fmOpenRead or fmShareDenyNone, 0, BufferSize);
end;

constructor TBufferFileStream.Create(const AFileName: SString; mode: word;
  BufferSize: integer);
begin

  Create(AFileName, mode, 0, BufferSize);

end;

procedure TBufferFileStream.DimBuffer(BufferSize: integer);
begin
  FBufferSize := BufferSize;
  getmem(FBuffer, FBufferSize);
end;

procedure TBufferFileStream.DoneBuffer;
begin
  SyncBuffer(false);
  freemem(FBuffer, FBufferSize);
end;

constructor TBufferFileStream.Create(const AFileName: SString; mode: word;
  Rights: Cardinal; BufferSize: integer);
begin
  inherited Create(AFileName, mode, Rights);
  FSize := 0;
  DimBuffer(BufferSize);
  FBuffered := True;
  SyncBuffer(True);
  FSize := Size;

end;

destructor TBufferFileStream.Destroy;
begin
  // SyncBuffer(False);
  DoneBuffer;
  inherited Destroy;
end;

procedure TBufferFileStream.SyncBuffer(ReRead: boolean);
begin
  if FModified then
  begin
    inherited Seek(FBufStartPos, soBeginning);
    inherited Write(FBuffer^, NativeInt(FBufEndPos - FBufStartPos));
    FModified := false;
  end;
  if ReRead then
  begin
    FBufStartPos := inherited Seek(FFilePos, soBeginning);
    FBufEndPos := FBufStartPos + inherited Read(FBuffer^, FBufferSize);
  end
  else
  begin
    inherited Seek(FFilePos, soBeginning);
    FBufEndPos := FBufStartPos;
  end;
end;

procedure TBufferFileStream.FlushBuffer;
begin
  SyncBuffer(false);
end;

function TBufferFileStream.ReadLn_: StreamString;
var
  pfin, PSrc, pstar, pend: PStreamChar;
  num_: integer;
  s: StreamString;
  Ok: boolean;
begin
  result := '';
  if self = nil then
    exit;
  begin
    if (FBufStartPos > FFilePos) or (FFilePos + BufReadLn > FBufEndPos) then
      SyncBuffer(True);

    Ok := false;
    repeat
      PSrc := PStreamChar(FBuffer);
      pfin := PStreamChar(FBuffer);
      inc(PSrc, (FFilePos - FBufStartPos));
      inc(pfin, FBufferSize - 1);
      pstar := PSrc;
      pend := PSrc;
      while PStreamChar(PSrc) < PStreamChar(pfin) do
      begin
        // PSrc := FBuffer + (FFilePos - FBufStartPos);
        case PSrc^ of
          #10:
            begin
              pend := PSrc;
              Ok := True;
              Break;
            end;
          #13:
            begin
              pend := PSrc;
              inc(PSrc);
              if PSrc^ <> #10 then
              begin
                Dec(PSrc)
              end;
              Ok := True;
              Break;
            end;
        else
          inc(PSrc);
        end;
      end;
      if Ok then
      begin
        num_ := pend - pstar;
        if num_ > 0 then
        begin
          // ansistrings.
          SetString(s, PStreamChar(pstar), num_);
          if result = '' then
          begin
            result := s
          end
          else
          begin
            result := result + s;
          end;
        end
        else
        begin
          s := '';
        end;

        inc(FFilePos, PSrc - pstar + 1);
        /// Break;
      end
      else
      begin

        num_ := PSrc - pstar + 1;

        SetString(s, PStreamChar(pstar), num_);
        result := result + s;
        FFilePos := FFilePos + num_;
        if Eofs then
        begin
          Break;
        end;
        SyncBuffer(True);

      end;
    until Ok;

  end;

end;

function TBufferFileStream.Read(var Buffer; Count: longint): longint;
var
  PSrc: PByte;
begin
  if Count >= FBufferSize then
  begin
    SyncBuffer(false);
    result := inherited Read(Buffer, Count)
  end
  else
  begin
    if (FBufStartPos > FFilePos) or (FFilePos + Count > FBufEndPos) then
      SyncBuffer(True);
    if Count < FBufEndPos - FFilePos then
      result := Count
    else
      result := FBufEndPos - FFilePos;
    PSrc := FBuffer;
    inc(PSrc, (FFilePos - FBufStartPos));
    // PSrc := FBuffer + (FFilePos - FBufStartPos);

    case result of
      SizeOf(Byte):
        PByte(@Buffer)^ := PByte(PSrc)^;
      SizeOf(word):
        PWord(@Buffer)^ := PWord(PSrc)^;
      SizeOf(Cardinal):
        PCardinal(@Buffer)^ := PCardinal(PSrc)^;
    else
      move(PSrc^, Buffer, result);
    end;

  end;
  FFilePos := FFilePos + result;
end;

function TBufferFileStream.Write(const Buffer; Count: longint): longint;
var
  PDest: PByte;
begin
  if Count >= FBufferSize then
  begin
    SyncBuffer(false);
    result := inherited Write(Buffer, Count);
    FFilePos := FFilePos + result;
  end
  else
  begin
    if (FBufStartPos > FFilePos) or
      (FFilePos + Count > FBufStartPos + FBufferSize) then
      SyncBuffer(True);
    result := Count;
    PDest := FBuffer;
    inc(PDest, (FFilePos - FBufStartPos));

    case result of
      SizeOf(Byte):
        PByte(PDest)^ := PByte(@Buffer)^;
      SizeOf(word):
        PWord(PDest)^ := PWord(@Buffer)^;
      SizeOf(Cardinal):
        PCardinal(PDest)^ := PCardinal(@Buffer)^;
    else
      move(Buffer, PDest^, result);
    end;

    FModified := True;
    FFilePos := FFilePos + result;
    if FFilePos > FBufEndPos then
      FBufEndPos := FFilePos;
  end;
end;

function TBufferFileStream.Readx(Buffer: TBytex;
  offset, Count: longint): longint;
begin
  result := Read(Buffer[offset], Count);
end;

function TBufferFileStream.Writex(const Buffer: TBytex;
  offset, Count: longint): longint;
begin
  result := Write(Buffer[offset], Count);
end;

function TBufferFileStream.Eofs: boolean;
begin
  result := FFilePos >= FSize;

end;

function TBufferFileStream.FilePos: Int64;
begin
  result := FFilePos

end;

function TBufferFileStream.Seek(const offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
  if not FBuffered then
    FFilePos := inherited Seek(offset, Origin)
  else
    case Origin of
      soBeginning:
        begin
          if (offset < FBufStartPos) or (offset > FBufEndPos) then
            SyncBuffer(false);
          FFilePos := offset;
        end;
      soCurrent:
        begin
          if (FFilePos + offset < FBufStartPos) or
            (FFilePos + offset > FBufEndPos) then
            SyncBuffer(false);
          FFilePos := FFilePos + offset;
        end;
      soEnd:
        begin
          SyncBuffer(false);
          FFilePos := inherited Seek(offset, soEnd);
        end;
    end;
  result := FFilePos;
end;

procedure TBufferFileStream.SetSize(const NewSize: Int64);
begin
  if NewSize < FBufEndPos then
    SyncBuffer(false);
  FBuffered := false;
  try
    inherited SetSize(NewSize);
  finally
    FBuffered := True;
  end;
end;

procedure Prints(const datos: string);
begin
  if modoconsole then
    if datos <> '' then

      Writeln(datos);

end;

procedure Printsys(const datos: array of const);
begin
  Prints(Ssum(datos))
end;

function SerializaString(const sss: SString): TMonaStringList;
var
  s: PMixString;
  pol: SString;
  parser: TMonaParser;
begin
  pol := sss;
  // deletechars(pol, '[]');
  result.Init;
  parser.IniParser(pol, nil);
  for s in parser do
    if s <> nil then
    begin
      result.Add(s^.ToSt)
    end;
end;

const
  Kdelims2enne_: set of SChar = ['Ñ', 'ñ'];
  KdelimsTodos_: set of SChar = [' ', '.', ',', '(', ')', ':', ';', '"', '{',
    '}', '`', '''', '%', '&', '@', '=', '<', '>', ']', '[', '-', '+', '*', '^',
    '/', '\', '$', '!', '#', '?', '|'];

  KdelimsComillas: set of SChar = [';'];
  KdelimsComas: set of SChar = [','];
  KdelimsSpace: set of SChar = [' '];

function TStaticParserEnumerator.getnextwords(): boolean;
var
  le, Lons, i2: integer;
begin
  Lons := Length(ss);

  result := i1 <= Lons;
  if not result then
    exit;

  while (i1 < Lons) and ((ss[i1] in pset^) or (ss[i1] < ' ') or
    (ss[i1] > 'z')) do
  begin
    if ss[i1] in Kdelims2enne_ then
    begin
      Break;
    end;
    inc(i1);
  end;

  i2 := i1;
  while (i2 <= Lons) and (not((ss[i2] in pset^) or (ss[i2] < ' '))) do
  begin
    inc(i2);
  end;
  // mix.add(SPchar(s[i1]), i2 - i1);
  le := i2 - i1;
  if le > 0 then
  begin
    mix.AsignaPChar(@ss[i1], le);
  end
  else
  begin
    result := i1 < Lons;
  end;
  i1 := i2 + 1;

end;

function TStaticParserEnumerator.MoveNext: boolean;
begin
  // inc(fIndex);
  result := getnextwords;
end;

constructor TStaticParserEnumerator.Create(const ds: PArrayParser;
  const ps: PSetchar = nil);
begin
  inherited Create(ds);
  ss := ds.s;
  mix.NulString;
  i1 := 1;
  if ps = nil then
  begin
    pset := @KdelimsTodos_
  end
  else
  begin
    pset := ps
  end;
end;

function TStaticParserEnumerator.GetCurrent: PMixString;
begin
  result := @mix;
end;

procedure TMonaParser.InitComas(const os: SString);
begin
  s := os;
  pset := @KdelimsComas;
end;

procedure TMonaParser.InitComa(const os: SString);
begin
  s := os;
  pset := @KdelimsComillas;
end;

class operator TMonaParser.Implicit(const aValue: SString): TMonaParser;
begin
  result.IniParser(aValue);
end;

procedure TMonaParser.IniParser(const os: SString; const ps: PSetchar = nil);
begin
  s := os;
  pset := ps;
end;

function TMonaParser.GetEnumerator: TStaticParserEnumerator;
begin

  result := TStaticParserEnumerator.Create(@self, pset);

end;

class operator TMonaParser.Implicit(const aValue: TMonaFile): TMonaParser;
begin
  result.InitFromFile(aValue);
end;

procedure TMonaParser.InitFromFile(const nafi: TMonaFile);
begin
  IniParser(nafi.FileContent());
end;

procedure WarningTodo(const valores: array of const);
begin
  WarningX(Ssum(valores));
END;

procedure WarningRaro(const valores: array of const);
begin
  WarningRaroS_(Ssum(valores));
END;

procedure WarningRaroS_(const _valor: SysString; const o: TObject = Nil);
begin
  // DependeVisual.MSGTrace_('error ' + _valor);
  // ? MonoLog.LogTimes(_valor);
END;

procedure WarningException_(const e: Exception; const tit: SString);
begin
  if e = Nil then
  begin
    WarningRaroS_(tit);
  end
  else
  begin
    WarningRaro([tit, ' ', e.Message]);
  end;
END;

constructor TScriptAbstract.Create(const obj: TObject = nil);
begin
  inherited Creates;
  // syn:=nil;
  fObject := obj;
end;

destructor TScriptAbstract.Destroy;
begin
  if fObject <> nil then
  begin
    fObject.free;
  end;
  inherited;
end;

function TScriptAbstract.Runs(const req: TScriptRequest): TScriptResponse;
begin
  result.Init('');
end;

{ TMonaScript }

procedure TMonaScript.Done;
begin
  Script := nil
end;

procedure TMonaScript.Init(const Si: IScript);
begin
  Script := Si
end;

function TMonaScript.Ok: boolean;
begin
  result := Script <> nIL
end;

function TMonaScript.Run(const a: StringScript): StringScript;
begin
  if Script <> nil then
  begin
    result := Script.Runs(a)
  end
  else
  begin
    result := ''
  end;
end;

{ TScriptRequest }

function TScriptRequest.Command: String;
var
  s: string;
begin
  s := Source;
  result := Fetchar(' ', s);
end;

function TScriptRequest.IsCommand(const a: array of String): boolean;
var
  co, s: string;
begin
  result := false;
  co := Command;
  for s in a do
  begin
    if s = co then
    begin
      result := True;
      Break;
    end;
  end;
end;

class operator TScriptRequest.Implicit(const aValue: TScriptRequest): String;
begin
  result := aValue.Source
end;

class operator TScriptRequest.Implicit(const aValue: String): TScriptRequest;
begin
  result.Init(aValue);
end;

procedure TScriptRequest.Init(const s: String = ''; doclear: boolean = True);
begin
  Source := s;
  ClearMem := doclear;
end;

procedure TScriptRequest.Inits(const a: array of const);
begin
  Source := Ssum(a);
  ClearMem := false;
end;

function TScriptRequest.Serializas_: TMonaStringList;
begin
  result := SerializaString(Source)
end;

function TScriptRequest.SerialVariant(out met: string): Variant;
var
  params: TMonaStringList;
  cuenta, i: integer;
  v: Variant;
begin
  params := Serializas_;
  try
    // SerializaString(request.Serializa sss: SString): TMonaStringList;
    cuenta := params.Count - 1;
    result := VarArrayCreate([0, cuenta - 1], varVariant);
    for i := 1 to cuenta do
    begin
      v := params.ss_[i];
      result[i - 1] := v
    end;
    // Result := param;
    met := params.ss_[0];

  finally
    params.Done; // ?
  end;

end;

{ TScriptResponse }

function TScriptResponse.AsString: String;
begin
  result := respon
end;

class operator TScriptResponse.Implicit(const aValue: TScriptResponse): String;
begin
  result := aValue.respon
end;

class operator TScriptResponse.Implicit(const aValue: String): TScriptResponse;
begin
  result.Init(aValue);
end;

procedure TScriptResponse.Error(const s: String);
begin
  respon := respon + '-error:' + s
end;

procedure TScriptResponse.Init(const s: String);
begin
  respon := s
end;

{ TCommandReqRes }

procedure TCommandReqRes.Init(const com: String; const f: TFunRequestResponse;
  contex: Pointer);
begin
  Command := com;
  fun := f;
  contexto := contex
end;

function TCommandReqRes.RunFun(const req: TScriptRequest): TScriptResponse;
begin
  if assigned(fun) then
  begin
    result := fun(req, contexto);
  end
  else
  begin
    result.Init();
  end;
end;

constructor TResponserSimple.Create(const obj: TObject);
begin
  inherited Create(obj);
  Script := nil;
end;

destructor TResponserSimple.Destroy;
begin
  inherited Destroy;
end;

function TResponserSimple.Runs(const req: TScriptRequest): TScriptResponse;
begin
  result.Init();
  if Script <> nil then
  begin
    result := Script.RunSim(req);
  end;
end;

function TCommandReqResArray.Add(const lab: String; f: TFunRequestResponse;
  contexto: Pointer): pCommandReqRes;
var
  Id: integer;
begin
  result := Finds(lab);
  if result <> nil then
  begin
    result := nil;
    // ? Si ya existe el comando, ignora nueva definicion ?
  end
  else
  begin
    Id := Count;
    setLength(commands, Id + 1);
    result := @commands[Id];
  end;
  if result <> nil then
  begin
    commands[Id].Command := lab;
    commands[Id].fun := f;
    commands[Id].contexto := contexto;
  end;
end;

function TCommandReqResArray.Count: integer;
begin
  result := Length(commands)
end;

function TCommandReqResArray.Finds(const lab: String): pCommandReqRes;
var
  Id: integer;
begin
  result := nil;
  for Id := 0 to Count - 1 do
  begin
    if lab = commands[Id].Command then
    begin
      result := @commands[Id];
      exit;
    end;
  end;
  (* for id := 0 to Count - 1 do
    begin
    if AnsiString(commands[id].Command) = AnsiString(lab) then
    begin
    Result := @commands[id];
    Exit;
    end;
    end; *)
  for Id := 0 to Count - 1 do
  begin
    if commands[Id].Command = '?' then
    begin
      result := @commands[Id];
    end;
  end;
end;

procedure TCommandReqResArray.Inits;
begin
  setLength(commands, 0);
end;

function TCommandReqResArray.RunSim(const req: TScriptRequest): TScriptResponse;
var
  com: pCommandReqRes;
begin
  result.Init();
  com := Finds(req.Command);
  if com <> nil then
  begin
    result := com^.RunFun(req)
  end
  else
  begin
    result.Init('No command');
  end;
end;


function TCommandReqResArray.InjectResponse(): IScript;
begin
  result := CreateResponser();
end;

function TCommandReqResArray.CreateResponser(const nameser: string)
  : TResponserSimple;
begin
  result := TResponserSimple.Create(nil);
  result.Script := @self;
end;

procedure TCommandReqResArray.Done;
begin
  setLength(commands, 0);
end;

procedure deletechars(var St: SysString; const chartodel: SString);
var
  i: integer;
Begin
  // for i := 1 to Length(st) do
  for i := LowSt_ to LastChar(chartodel) do
  Begin
    // DeleteCharSt(st, chartodel[i]);
  end;
end;

procedure TTypeRuntimeResult.Print(const s: String);
begin
  if resulta <> '' then
  begin
    resulta := resulta + EOL_;
  end;
  resulta := resulta + s;
end;

procedure TTypeRuntimeResult.Reset;
begin
  resulta := '';
end;

function ClearThings(const a: StringScript): StringScript;
var
  s: string;
begin
  s := FindReplace(a, #10, '');
  result := s;
  result := a;

end;


procedure ReplaceCOMAs(var St: SysString);
var
  i: word;
Begin
  for i := 1 to Length(St) do
  Begin
    if St[i] = ',' then
    begin
      UniqueString(St);
      St[i] := '.';
      exit;
    end;
  end;
end;

function StLlena(c: Char; l: integer): SString;
Var
  St: SString;
{$IFDEF ZEROSMODE}
  i: integer;
{$ENDIF ZEROSMODE}
Begin
{$IFDEF ZEROSMODE}
  If l < 0 then
  begin
    l := 0;
  end;
  result := '';
  for i := 1 to i do
  begin
    result := result + c;
  end;
{$ELSE ZEROSMODE}
  If l <= 0 then
  begin
    result := '';
    exit;
  end;
  UniqueString(St); // ?

  setLength(St, l);

  FillChar(St[1], l, Ord(c));
  result := St; // Copy(st,1,l);
{$ENDIF ZEROSMODE}
end;

function StCode2(n: integer): SString;
var
  s: SString;
  i: integer;
begin
  str(n: 2, s);
  for i := 1 to Length(s) do
  Begin
    if s[i] = ' ' then
      s[i] := '0';
  end;
  result := s;
end;

function Spaces(l: integer): SString;
Begin
  result := StLlena(' ', l);
end;


function CharPosEXZero(const SearchCharacter: SChar;
  const SourceString: SString; StartPos: integer): integer;
var
  ch: SChar;
  i: integer;
  LStrLen: integer;
begin
  result := -1;
  LStrLen := Length(SourceString) - HiSt;
  if (LStrLen = 0) then
  begin
    exit;
  end;
  ch := SearchCharacter;
  for i := StartPos to LStrLen do
    if SourceString[i] = ch then
    begin
      result := i;
      exit;
    end;
end;


{$IFNDEF PUREPASCAL} // from Aleksandr Sharahov's PosEx_Sha_Pas_2()

function PosEx(const substr, s: SString; offset: Integer = 1): Integer;
asm  // eax=SubStr, edx=S, ecx=Offset
  push    ebx
  push    esi
  push    edx                 // @Str
  test    eax,eax
  jz      @@NotFound          // Exit if SubStr = ''
  test    edx,edx
  jz      @@NotFound          // Exit if Str = ''
  mov     esi,ecx
  mov     ecx,[edx-4]         // Length(Str)
  mov     ebx,[eax-4]         // Length(Search SString)
  add     ecx,edx
  sub     ecx,ebx             // ecx = Max Start Pos for Full Match
  lea     edx,[edx+esi-1]     // edx = Start Position
  cmp     edx,ecx
  jg      @@NotFound          // StartPos > Max Start Pos
  cmp     ebx,1               // Length(SubStr)
  jle     @@SingleChar        // Length(SubStr) <= 1
  push    edi
  push    ebp
  lea     edi,[ebx-2]         // edi = Length(Search SString) - 2
  mov     esi,eax             // esi = Search SString
  movzx   ebx,byte ptr [eax]  // bl = Search Character
@@Loop:                       // Compare 2 Characters per Loop
  cmp     bl,[edx]
  je      @@Char1Found
@@NotChar1:
  cmp     bl,[edx+1]
  je      @@Char2Found
@@NotChar2:
  lea     edx,[edx+2]
  cmp     edx,ecx             // Next Start Position <= Max Start Position
  jle     @@Loop
  pop     ebp
  pop     edi
@@NotFound:
  xor     eax,eax            // returns 0 if not found
  pop     edx
  pop     esi
  pop     ebx
  ret
@@Char1Found:
  mov     ebp,edi             // ebp = Length(Search SString) - 2
@@Char1Loop:
  movzx   eax,word ptr [esi+ebp]
  cmp     ax,[edx+ebp]       // Compare 2 Chars per Char1Loop (may include #0)
  jne     @@NotChar1
  sub     ebp,2
  jnc     @@Char1Loop
  pop     ebp
  pop     edi
  jmp     @@SetResult
@@Char2Found:
  mov     ebp,edi             // ebp = Length(Search SString) - 2
@@Char2Loop:
  movzx   eax,word ptr [esi+ebp]
  cmp     ax,[edx+ebp+1]     // Compare 2 Chars per Char2Loop (may include #0)
  jne     @@NotChar2
  sub     ebp,2
  jnc     @@Char2Loop
  pop     ebp
  pop     edi
  jmp     @@CheckResult
@@SingleChar:
  jl      @@NotFound          // Needed for Zero-Length Non-NIL Strings
  movzx   eax,byte ptr [eax]  // Search Character
@@CharLoop:
  cmp     al,[edx]
  je      @@SetResult
  cmp     al,[edx+1]
  je      @@CheckResult
  lea     edx,[edx+2]
  cmp     edx,ecx
  jle     @@CharLoop
  jmp     @@NotFound
@@CheckResult:                // Check within AnsiString
  cmp     edx,ecx
  jge     @@NotFound
  add     edx,1
@@SetResult:
  pop     ecx                 // @Str
  pop     esi
  pop     ebx
  neg     ecx
  lea     eax,[edx+ecx+1]
end;

function PosExZes(const substr, s: SString; offset: Integer = 1): Integer;
asm  // eax=SubStr, edx=S, ecx=Offset
  push    ebx
  push    esi
  push    edx                 // @Str
  test    eax,eax
  jz      @@NotFound          // Exit if SubStr = ''
  test    edx,edx
  jz      @@NotFound          // Exit if Str = ''
  mov     esi,ecx
  mov     ecx,[edx-4]         // Length(Str)
  mov     ebx,[eax-4]         // Length(Search SString)
  add     ecx,edx
  sub     ecx,ebx             // ecx = Max Start Pos for Full Match
  lea     edx,[edx+esi-1]     // edx = Start Position
  cmp     edx,ecx
  jg      @@NotFound          // StartPos > Max Start Pos
  cmp     ebx,1               // Length(SubStr)
  jle     @@SingleChar        // Length(SubStr) <= 1
  push    edi
  push    ebp
  lea     edi,[ebx-2]         // edi = Length(Search SString) - 2
  mov     esi,eax             // esi = Search SString
  movzx   ebx,byte ptr [eax]  // bl = Search Character
@@Loop:                       // Compare 2 Characters per Loop
  cmp     bl,[edx]
  je      @@Char1Found
@@NotChar1:
  cmp     bl,[edx+1]
  je      @@Char2Found
@@NotChar2:
  lea     edx,[edx+2]
  cmp     edx,ecx             // Next Start Position <= Max Start Position
  jle     @@Loop
  pop     ebp
  pop     edi
@@NotFound:
  xor     eax,eax            // returns 0 if not found
  pop     edx
  pop     esi
  pop     ebx
  ret
@@Char1Found:
  mov     ebp,edi             // ebp = Length(Search SString) - 2
@@Char1Loop:
  movzx   eax,word ptr [esi+ebp]
  cmp     ax,[edx+ebp]       // Compare 2 Chars per Char1Loop (may include #0)
  jne     @@NotChar1
  sub     ebp,2
  jnc     @@Char1Loop
  pop     ebp
  pop     edi
  jmp     @@SetResult
@@Char2Found:
  mov     ebp,edi             // ebp = Length(Search SString) - 2
@@Char2Loop:
  movzx   eax,word ptr [esi+ebp]
  cmp     ax,[edx+ebp+1]     // Compare 2 Chars per Char2Loop (may include #0)
  jne     @@NotChar2
  sub     ebp,2
  jnc     @@Char2Loop
  pop     ebp
  pop     edi
  jmp     @@CheckResult
@@SingleChar:
  jl      @@NotFound          // Needed for Zero-Length Non-NIL Strings
  movzx   eax,byte ptr [eax]  // Search Character
@@CharLoop:
  cmp     al,[edx]
  je      @@SetResult
  cmp     al,[edx+1]
  je      @@CheckResult
  lea     edx,[edx+2]
  cmp     edx,ecx
  jle     @@CharLoop
  jmp     @@NotFound
@@CheckResult:                // Check within AnsiString
  cmp     edx,ecx
  jge     @@NotFound
  add     edx,1
@@SetResult:
  pop     ecx                 // @Str
  pop     esi
  pop     ebx
  neg     ecx
  lea     eax,[edx+ecx+1]
end;
{$ELSE}

function PosEx(const substr, s: SString; offset: integer = 1): integer;
begin;
  result := Pos(substr, s, offset)
end;

function PosExZes(const substr, s: SString; offset: integer = 1): integer;
begin;
  result := Pos(substr, s, offset)
end;

{$ENDIF PUREPASCAL}




const
  CharMap__: SString =
    'qwertzuiopasdfghjklyxcvbnmQWERTZUIOPASDFGHJKLYXCVBNM1234567890';

function GetRandomString(numChar: cardinal): SString;
var
  i: Integer;
  s: SString;
begin
  randomize;
  s := '';
  for i := 1 to numChar do
  begin
    s := s + CharMap__[Random(length(CharMap__)) + 1];
    // result := result + CharMap_[Random(maxChar) + 1];
  end;
  result := s;
end;



initialization

ExeVer.Init;

finalization

ExeVer.Done;

end.

{ TMonaScriptManager }

procedure TMonaScriptManager.Done;
begin
  ScriptMan := nil;

end;

procedure TMonaScriptManager.Init(const Si: IScriptManager);
begin
  ScriptMan := Si;
end;

function TMonaScriptManager.Ok: boolean;
begin
  result := ScriptMan <> nil;

end;

function TMonaScriptManager.Run(const a: StringScript): StringScript;
begin
  if Ok then
  begin
    result := ScriptMan.RunScript(a)
  end
  else
  begin
    result := ''
  end;
end;

