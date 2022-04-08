program Test_HelloRemPascl;

{$APPTYPE CONSOLE}
{$I plutonidef.inc}
{ %TogetherDiagram 'ModelSupport_TestTodoJargonOnly\default.txaPackage' }

uses
  PythonEngine,
  Plutony_SynTest in '..\Plutony_SynTest.pas',
  Test_Basic_Jupyter in '..\Test_Basic_Jupyter.pas',
  Plutony_Zero_RemScript in '..\Plutony_Zero_RemScript.pas',
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas',

{$IFDEF COMPACMODE}
  Monadas_Pascal,

{$ELSE}
  Monada_Abstract,
{$ENDIF}

  PluTony_Zero_Brokers in '..\PluTony_Zero_Brokers.pas',
  ZMQ.API2006 in '..\zero2006\ZMQ.API2006.pas';

type
  TTestMonaZMQ = class(TMiTestCase)

  published

    procedure LunchBroker2006();

  private

    procedure LunchServerCustom();

  end;

procedure TTestMonaZMQ.LunchBroker2006();
begin
  LunchBrokerDefault(InjectScriptRem(), proPascal1);
end;

procedure TTestMonaZMQ.LunchServerCustom();

begin

  LunchServerCustomTest();

end;

begin
  SERVICE_NAME__:='rem';
  modoconsole := true;
  // TestRunScriptRem;

  MainTestCase := [TTestMonaZMQ, TTestMonaPython];

  // TestInflateDeflateZip();
  AutoTest_Plutony;
  // AutoTest_Monadas;
  // ToMMUninstall;

  // SaveProfile_;
end.
