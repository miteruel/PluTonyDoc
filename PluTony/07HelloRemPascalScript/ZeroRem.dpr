program ZeroRem;

{$APPTYPE CONSOLE}
{$I plutonidef.inc}
{ %TogetherDiagram 'ModelSupport_TestTodoJargonOnly\default.txaPackage' }

uses
//  Plutony_SynTest in '..\Plutony_SynTest.pas',
  Plutony_Zero_RemScript in '..\Plutony_Zero_RemScript.pas',
{$IFDEF COMPACMODE}
  Monadas_Pascal,
{$ELSE}
  Monada_Abstract,
{$ENDIF }
  PluTony_Zero_Brokers in '..\PluTony_Zero_Brokers.pas';



begin
 // SERVICE_NAME__ := 'rem';
  modoconsole := true;
  LunchBroker(InjectScriptRem());
end.
