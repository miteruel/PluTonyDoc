program PluTonyKernel;

{$APPTYPE CONSOLE}
{$I ..\plutonidef.inc}
{ %TogetherDiagram 'ModelSupport_TestTodoJargonOnly\default.txaPackage' }

uses
  PluTony_Runtime_App,
  PythonEngine,
  WrapDelphi,
{$IFDEF COMPACMODE}
  Monadas_Pascal,
{$ELSE}
  monada_abstract,
  Todo_IScript in '..\Todo_IScript.pas',
{$ENDIF }
{$IFDEF PLUTONY_DWS}
{$ENDIF }
{$IFDEF PLUTONY_REM}
  Plutony_Zero_RemScript in '..\Plutony_Zero_RemScript.pas',
{$ENDIF }
  Test_ZMQ in '..\Test_ZMQ.pas',
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas',
  PluTony_Py_ZMQ in '..\PluTony_Py_ZMQ.pas',
  Plutony_SynTest in '..\Plutony_SynTest.pas',
  Test_Basic_Jupyter in '..\Test_Basic_Jupyter.pas',
  Classes,
  ZMQ.API2006,
  PluTony_Zero_Brokers in '..\PluTony_Zero_Brokers.pas',

{$IFDEF PLUTONY_FASTSCRIPT}
  PluTony_Zero_FastScript,
{$ENDIF }
{$IFDEF PLUTONY_EXPRESSION}
  PluTony_Zero_Expresion,
{$ENDIF }
{$IFDEF PLUTONY_DWS}
  Plutony_Zero_DWS,
{$ENDIF }
  SysUtils;

type
  TTestKernel = class(TMiTestCase)
  published
    procedure GenerateKernel;
    procedure GenerateDllKernel;
    procedure LunchBroker();

  private
    procedure CopyDllKernel;

  end;

  { TTestKernel }

function DllPyPath: String;
begin
  result := ExeVer / 'PluTonyKernel_Dll.pyd';
end;

procedure TTestKernel.CopyDllKernel;
var
  f: TMonaFile;
  tex, tem, fin: String;
  nuevo: TMonaFile;
  destino: TMonaDirectory;
begin
  f := DllPyPath;
  if f.Exists then
  begin
    RunAppExample.CreateKernels(ExeVer / 'pascal_kernel',
      ExeVer / 'target\p4dll', 'pascalkernel');

    tex := f.FileContent();
    if tex <> '' then
    begin

      destino := ExeVer / 'target\p4dll\pascalkernel';

      nuevo := destino.Barra_(f.SimpleName);
      nuevo.SaveToFile(tex);
    end;

  end;

end;

procedure TTestKernel.GenerateDllKernel;
begin
  CopyDllKernel;
  // LunchBrokerMultiWorker(GetArrayExamples());
end;

procedure TTestKernel.GenerateKernel;
begin
  RunAppExample.CreateKernels(ExeVer / 'zmqkernel',
    ExeVer / 'target\zerokernel', 'pascalkernel');
  // CopyDllKernel;
  // LunchBrokerMultiWorker(GetArrayExamples());
end;

procedure TTestKernel.LunchBroker;
begin
  LunchBrokerMultiWorker(GetArrayExamples());
end;

begin
  writeln(sizeof(nativeint));
  writeln(sizeof(cardinal));
  writeln(sizeof(Integer));
  writeln(sizeof(SmallInt));
  writeln(sizeof(cardinal));

  writeln(sizeof(zmq_pollitem_t));

  modoconsole := true;
  mainScript := 'HolaPascalKernel.py';
  MainTestCase := [TTestKernel
   ,TTestMonaPython
  // ,TTestKernel
    ];
  // serve:=TestServe;

  // TestDataBase;
  // MakeHash;
  // TestInflateDeflateZip();
  AutoTest_Plutony;
  // AutoTest_Monadas;
  // ToMMUninstall;

  // SaveProfile_;
end.
