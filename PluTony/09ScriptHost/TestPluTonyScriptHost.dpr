program TestPluTonyScriptHost;

{$APPTYPE CONSOLE}
{$I ..\plutonidef.inc}

uses
  SysUtils,
  windows,
  SynTests,
  PluTony_Runtime_App,
{$IFDEF COMPACMODE}
  Monadas_Pascal,
{$ELSE}
  Monada_Abstract,
  Todo_IScript in '..\Todo_IScript.pas',
{$ENDIF }
{$IFDEF PLUTONY_REM}
{$ENDIF }
  // PluTony_Router_Kernel in '..\PluTony_Router_Kernel.pas',
  Plutony_SynTest in '..\Plutony_SynTest.pas',
{$IFDEF PLUTONY_REM}
  Plutony_Zero_RemScript in '..\Plutony_Zero_RemScript.pas',
{$ENDIF }
{$IFDEF PLUTONY_ZEROPY}
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas',
{$ENDIF }
  Classes,

  PluTony_Py_ZMQ,
  PluTony_Zero_Brokers in '..\PluTony_Zero_Brokers.pas',
  PluTony_Zero_FastScript in '..\PluTony_Zero_FastScript.pas';

type
  TTestMonaZMQ = class(TMiTestCase)
  published

    procedure LunchBrokerMulti();

  private

    procedure LunchServerCustom();

  end;

procedure TTestMonaZMQ.LunchBrokerMulti();
begin
  LunchBrokerMultiWorker(GetArrayExamples());
  // LunchBrokerMultiWorker();

end;

procedure TTestMonaZMQ.LunchServerCustom();
begin
  LunchServerCustomTest();
end;

begin
  modoconsole := true;


  MainTestCase := [TTestMonaZMQ // , TTestMonaPython
    ];
  mainScript := 'proTonyZMQ.py';

  AutoTest_Plutony;

end.

 RunAppExample.CreateKernelTemplate('samplekernel');

