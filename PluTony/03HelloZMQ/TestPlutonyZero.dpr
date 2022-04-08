program TestPlutonyZero;

{$APPTYPE CONSOLE}
{$I ../plutonidef.inc}


uses
  Classes,
  SysUtils,
  Plutony_SynTest in '..\Plutony_SynTest.pas',
  PluTony_Zero_Brokers in '..\PluTony_Zero_Brokers.pas',
  Monadas_Pascal in '..\Monadas_Pascal.pas',
  PluTony_Runtime_App in '..\PluTony_Runtime_App.pas';

type
  TTestMonaZMQ = class(TMiTestCase)

  published
    // public
    procedure LunchServerCustom();

    procedure LunchBroker2006();


  end;

procedure TTestMonaZMQ.LunchBroker2006();
begin
  LunchBrokerDefault(Nil, proPascal1);
end;

procedure TTestMonaZMQ.LunchServerCustom();
begin
  LunchServerCustomTest();
end;



begin
  modoconsole := true;

    try
   //?   zmq.InitScriptMode('tcp://*:57503', Broker.Commands.InjectResponse);
   //?      zmq.InitThread_;
      // broker.CreateControlWorker;

      Writeln(sizeof(nativeint));
      // TestSampleRecord;
      MainTestCase := [TTestMonaZMQ
      // ,TTestMonaPython
        ]; // , TTestMonaPython];
      mainScript := 'proTonyZMQ.py';

      AutoTest_Plutony;
    finally
    //?     zmq.done
    end;

end.


