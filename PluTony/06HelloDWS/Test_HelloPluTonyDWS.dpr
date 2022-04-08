program Test_HelloPluTonyDWS;

{$APPTYPE CONSOLE}
{$I ..\plutonidef.inc}

uses
  Classes,
  dwsStringResult,
  SysUtils,
  PythonEngine,
  Monadas_Pascal,
  WrapDelphi,
  SynTests,
  Plutony_Zero_DWS,

{$IFDEF DWSKinks}
  dwsLinq in 'E:\todo\DWScript-master\Libraries\LinqLib\dwsLinq.pas',

{$ENDIF}
  PluTony_Zero_Brokers,
  Plutony_SynTest in '..\Plutony_SynTest.pas',
  Test_Basic_Jupyter in '..\Test_Basic_Jupyter.pas';



type
  TTestMonaZMQ = class(TMiTestCase)
  published

    procedure LunchBroker2006();

  private
    // procedure LunchBroker();

    procedure LunchServerCustom();

  end;

procedure TTestMonaZMQ.LunchBroker2006();
begin

  LunchBrokerDefault(InjectScriptDws(), proPascal3);

end;

procedure TTestMonaZMQ.LunchServerCustom();

begin

  LunchServerCustomTest();

end;

begin
  modoconsole:=true;
  MainTestCase := [TTestMonaZMQ, TTestMonaPython];
  AutoTest_Plutony;

end.
