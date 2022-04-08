unit Plutony_SynTest;

{$I plutonidef.inc}
// {$DEFINE USE_XUNIT}

(*
  Copyright (c) 2022  Antonio Alcázar Ruiz
  PluTony : Jupyter Pascal extensions.

  This unit uses mORMot or XUnit.
  By default, Plutony test run in SynTest(mORMot) mode.
  If you define {$DEFINE USE_XUNIT}, then run in DUnitX mode.
*)

interface

uses
  // monada_system,
{$IFDEF COMPACMODE}
  Monadas_Pascal,

{$ELSE}
  Monada_Abstract,
{$ENDIF}
{$IFDEF USE_XUNIT}
  System.SysUtils,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.StackTrace.Jcl,
  DUnitX.TestFramework;
{$ELSE}
SynTests;
{$ENDIF}

type

  TMiInfoTest = record
  public
    memo1_, memo2: Int64;
    // claseMain__: TObject;
    procedure Init;
    function Resta: Integer;
    procedure InitMem;
  end;

{$IFDEF USE_XUNIT}

  TSynTestCaseClass = TClass;

  TMiTestCase = class(TObject)
{$ELSE}
  TMiTestCase = class(TSynTestCase)
{$ENDIF}
  public

{$IFDEF USE_XUNIT}
    fRunConsoleMemoryUsed: Integer;

    [SetupFixture]
    procedure SetupFixture;
    [TearDownFixture]
    procedure TearDownFixture;

{$ELSE}
    constructor Create(Owner: TSynTests; const Ident: String = ''); override;

{$ENDIF}
    procedure SetupFix; virtual;
    procedure TearDownFix; virtual;

  protected
    info__: TMiInfoTest;

    procedure WriteMem_;
    procedure InitMem;
    procedure writs(const s: string); overload;
    procedure writs(const a: array of const); overload;
    procedure Print(const s: string);

  end;

{$IFDEF USE_XUNIT}

  TTestSuitPlutony = class(TObject)
{$ELSE}
  TTestSuitPlutony = class(TSynTests)
{$ENDIF}
  published
    procedure MyTestSuit;
  end;

  tarraystring = array of string;

procedure AutoTest_Plutony;

function GetArrayExamples(): tarraystring;
function GetArrayExamples2(): tarraystring;
//procedure SimpleTest(const atc:array of TSynTestCaseClass; const mainscript:String);


const
  proPascal1 = 'program pro1;' + eol_ + 'function hola:string;' + eol_ +
    'begin result:=''hola world mundo''; end;' + eol_ + 'var s:String;' + eol_ +
  // 'begin   s:=hola; SHOWMESSAGE(s); end.' + eol_;

    'begin  s:=hola; Print(s); end.' + eol_;

  proPascal2 = 'program pro2;' + eol_ +
  // 'begin   s:=hola; SHOWMESSAGE(s); end.' + eol_;

    'begin  SHOWMESSAGE(s); s:=hola; SHOWMESSAGE(s); end.' + eol_;

  proPascal3 = 'program pro1;' + eol_ + 'function hola:string;' + eol_ +
    'begin result:=''hola mundo''; end;' + eol_ + 'var s:String;' + eol_ +
  // 'begin   s:=hola; SHOWMESSAGE(s); end.' + eol_;
    'var n,plus:integer;' + eol_ +

    'begin  n:=10; plus:=n*n; s:=inttostr(plus); print(s); s:=hola; print(s); end.'
    + eol_;

const
  proPython1 = 'n="hello from python";' + eol_ + 'm=n+" bye";' + eol_ +
    'print(m)' + eol_;
  // function RunSimplePython(const source: String): String;

var
  MainTestCase: array of TSynTestCaseClass = [];
  mainScript: String = 'protony0.py'; // 'proTonyZMQ.py';

implementation

function MemUsed: Integer;
var
  heap: THeapStatus;
begin
  heap := GetHeapStatus;
  result := heap.TotalAllocated;
end;

procedure TMiInfoTest.InitMem;
begin

  memo1_ := MemUsed;
end;

procedure TMiTestCase.InitMem;
begin
  // memo1:=CurrentProcessMemoryUsage;
  info__.InitMem;
  // memo1__ := MemUsed;
end;

procedure TMiInfoTest.Init;
begin

end;

procedure TMiTestCase.SetupFix;
begin
  info__.Init;
  fRunConsoleMemoryUsed := 1;
end;

procedure TMiTestCase.TearDownFix;
begin
  // inherited;
  // info__.Init;

end;

{$IFDEF USE_XUNIT}

procedure TMiTestCase.SetupFixture;
begin
  inherited;
  SetupFix;
end;

procedure TMiTestCase.TearDownFixture;
begin
  TearDownFix;
  inherited;
end;
{$ELSE}

constructor TMiTestCase.Create(Owner: TSynTests; const Ident: String = '');
begin
  inherited;
  SetupFix;

end;

{$ENDIF}

function TMiInfoTest.Resta: Integer;
begin
  memo2 := MemUsed; // CurrentProcessMemoryUsage;
  result := memo2 - memo1_;
end;

procedure TMiTestCase.WriteMem_;
var
  n: Int64;
begin
  n := info__.Resta;
  fRunConsoleMemoryUsed := n;
  // Writeln(memo2-memo1);
end;

procedure TMiTestCase.Print(const s: string);
begin
  writeln(s)
  //
end;

procedure TMiTestCase.writs(const s: string);
begin
  //
end;

procedure TMiTestCase.writs(const a: array of const);
begin
  // ?
end;

{$IFDEF USE_XUNIT}

procedure ExecuteTest;
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger: ITestLogger;
begin

  try
    // Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    // Create the test runner
    runner := TDUnitX.CreateRunner;
    // Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    // tell the runner how we will log things
    // Log to the console window
    logger := TDUnitXConsoleLogger.Create(False);
    runner.AddLogger(logger);
    // Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create
      (TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False;
    // When true, Assertions must be made during tests;

    // Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    // TDUnitX.Options.ExitBehavior := TDUnitXExitBehavior.Continue;
{$IFNDEF CI}
    // We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
{$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure TTestSuitPlutony.MyTestSuit;
var
  o: TClass;
begin

  for o in MainTestCase do
  begin
    TDUnitX.RegisterTestFixture(o);

  end;
  ExecuteTest
end;

{$ELSE}

procedure TTestSuitPlutony.MyTestSuit;
begin
  AddCase(MainTestCase);
end;
{$ENDIF}

procedure AutoTest_Plutony;
begin

  with TTestSuitPlutony.Create do
    try
{$IFDEF USE_XUNIT}
      MyTestSuit;

{$ELSE}
      Run;

{$ENDIF}
      readln;
    finally
      Free;
    end;
end;

const
  KGetArrayExamples: array [0 .. 5] of string =

    ('python:' + proPython1, 'MyService2:' + proPascal1,
    'MyService2:' + proPascal3,
    // 'MyService:' + proPascal1,
    // 'MyService:' + proPascal3,

    'fast:' + proPascal1, 'fast:' + proPascal2, 'fast:' + proPascal3);

  KGetArrayExamples0: array [0 .. 5] of string =

    ('python:' + proPython1, 'MyService2:' + proPascal1,
    'MyService2:' + proPascal3,
    // 'MyService:' + proPascal1,
    // 'MyService:' + proPascal3,

    'MyService:' + proPascal1, 'MyService:' + proPascal2,
    'MyService:' + proPascal3);

function GetArrayExamples(): tarraystring;
var
  i, lon: Integer;
begin
  lon := Length(KGetArrayExamples);
  SetLength(result, lon);
  for i := 0 to lon - 1 do
  begin
    result[i] := KGetArrayExamples[i]
  end;

end;

const
  KGetArrayExamples2: array [0 .. 5] of string =

    ('dws:' + proPascal1, 'dws:' + proPascal1, 'dws:' + proPascal3,
    // 'MyService:' + proPascal1,
    // 'MyService:' + proPascal3,

    'dws:' + proPascal1, 'dws:' + proPascal2, 'dws:' + proPascal3);

function GetArrayExamples2(): tarraystring;
var
  i, lon: Integer;
begin
  lon := Length(KGetArrayExamples2);
  SetLength(result, lon);
  for i := 0 to lon - 1 do
  begin
    result[i] := KGetArrayExamples2[i]
  end;

end;

(**
procedure SimpleTest(const atc:array of TSynTestCaseClass; const mainscript:String);
begin
  // LunchServerCustomTest();
  MainTestCase := atc;
  mainScript := mainscript;

  AutoTest_Plutony;
end;
*)


end.
