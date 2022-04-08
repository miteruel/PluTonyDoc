program ZeroDWS;

{$APPTYPE CONSOLE}
{$I ..\plutonidef.inc}

uses
  Classes,
  dwsStringResult,
  SysUtils,
  Monadas_Pascal,
  Plutony_Zero_DWS,
  {$IFDEF DWSKinks}
  dwsLinq in 'E:\todo\DWScript-master\Libraries\LinqLib\dwsLinq.pas',
  {$ENDIF }
  PluTony_Zero_Brokers;


begin
  modoconsole:=true;

 // SERVICE_NAME__ := 'rem';

  LunchBroker(InjectScriptDws());

end.
