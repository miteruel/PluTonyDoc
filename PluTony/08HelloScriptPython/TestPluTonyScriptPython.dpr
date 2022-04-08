program TestPluTonyScriptPython;

{$APPTYPE CONSOLE}
{$I plutonidef.inc}

uses
  Plutony_SynTest in '..\Plutony_SynTest.pas',
 // Plutony_Scripts_Python in '..\Plutony_Scripts_Python.pas',
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas',

{$IFDEF COMPACMODE}
  Monadas_Pascal,

{$ELSE}
  Monada_Abstract,
  Todo_IScript in '..\Todo_IScript.pas',

{$ENDIF}
  PluTony_Zero_Brokers in '..\PluTony_Zero_Brokers.pas';

type
  TTestMonaZMQ = class(TMiTestCase)
  published

    procedure LunchBrokerPthon();

  end;

procedure TTestMonaZMQ.LunchBrokerPthon();
begin
  LunchBrokerDefault(InjectScriptPython(), proPython1);
end;

begin
  modoconsole := True;

  MainTestCase := [TTestMonaZMQ // , TTestMonaPython
    ];
  mainScript := 'proTonyZMQ.py';

  AutoTest_Plutony;
  // AutoTest_Monadas;
  // ToMMUninstall;

  // SaveProfile_;
end.
