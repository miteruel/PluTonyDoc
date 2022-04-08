program TestPluTonySimpleHost;

{$APPTYPE CONSOLE}
{$I ..\plutonidef.inc}
{ %TogetherDiagram 'ModelSupport_TestTodoJargonOnly\default.txaPackage' }

uses
  Classes,
  PluTony_Runtime_App,

{$IFDEF COMPACMODE}
  Monadas_Pascal,

{$ELSE}
  Monada_Abstract,
  Todo_IScript in '..\Todo_IScript.pas',
{$ENDIF}
  Plutony_SynTest in '..\Plutony_SynTest.pas',

  PluTony_Zero_Brokers in '..\PluTony_Zero_Brokers.pas';

type
  TTestMonaZMQ = class(TMiTestCase)

  published

    procedure LunchBroker2006();

  end;

procedure TTestMonaZMQ.LunchBroker2006();
var
  Commands: TCommandReqResArray;
  param: TLunchBrokerParam;
  Broker: TCompleteBroker;
begin
  Broker.Init_;
  param.init();
  Commands := CreateZeroControl(@Broker);

  try
    Broker.RunBrokers_('', Commands.InjectResponse());
    RunBrokerSampleLoop(Broker, proPascal1, param);

    // We never get here but if we did, this would be how we end
  finally
    Broker.Done;
    Commands.Done;
  end;

end;

begin
  modoconsole := True;
  MainTestCase := [TTestMonaZMQ  ];
  AutoTest_Plutony;

end.
