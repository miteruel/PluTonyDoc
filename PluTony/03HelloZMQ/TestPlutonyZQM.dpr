program TestPlutonyZQM;

{$APPTYPE CONSOLE}
//{$i incspynET}
{ %TogetherDiagram 'ModelSupport_TestTodoJargonOnly\default.txaPackage' }

uses
  Classes,
  SysUtils,
  windows,
  PythonEngine,
  Monadas_Pascal,
  WrapDelphi,
  PluTony_Zero_FastScript,
  Test_ZMQ in '..\Test_ZMQ.pas',
  PluTony_Rtti in '..\PluTony_Rtti.pas',
  PluTony_Zero_Brokers,
  Test_Basic_Jupyter in '..\Test_Basic_Jupyter.pas',
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas',
  Plutony_SynTest in '..\Plutony_SynTest.pas',
  PluTony_Py_ZMQ in '..\PluTony_Py_ZMQ.pas';

type
  TTestMonaZMQ = class(TMiTestCase)
  public
    destructor Destroy; override;
  published
    // public
    procedure LunchBroker2006();

 private
    procedure RunInjectFree();

    procedure LunchServerCustom();

  private
    // procedure LunchBroker();


  end;

destructor TTestMonaZMQ.Destroy;
begin
  inherited Destroy;
end;


procedure TTestMonaZMQ.LunchBroker2006();
begin
  LunchBrokerDefault(InjectSimpleFastScript(), proPascal1);

end;

procedure TTestMonaZMQ.RunInjectFree();

begin
  InjectSimpleFastScript;

end;

procedure TTestMonaZMQ.LunchServerCustom();

begin

  LunchServerCustomTest();

end;

procedure Test11;
var Broker:TCompleteBroker;
begin
  broker.InitPort(  ':57503');
  if broker.InitBroker_ then

  try
   broker.CreateControlWorker;

  Writeln(sizeof(nativeint));
  //TestSampleRecord;
  MainTestCase := [TTestMonaPython,TTestMonaZMQ];//, TTestMonaPython];
  mainScript := 'proTonyZMQ.py';

  AutoTest_Plutony;
  finally
    Broker.done
  end;
end;


var Broker:TCompleteBroker;
  zmq:TServer0MQ;
begin
  modoconsole:=true;
  broker.InitPort(  ':57502');
  if broker.InitBroker_ then

  try
    zmq.InitScriptMode('tcp://*:57503',Broker.Commands.InjectResponse);
    zmq.InitThread_;
//     broker.CreateControlWorker;

  Writeln(sizeof(nativeint));
  //TestSampleRecord;
  MainTestCase := [TTestMonaZMQCommand,TTestMonaZMQ,TTestMonaPython];//, TTestMonaPython];
  mainScript := 'proTonyZMQ.py';

  AutoTest_Plutony;
  finally
    Broker.done
  end;
end.


