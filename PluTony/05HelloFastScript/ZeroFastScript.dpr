program ZeroFastScript;

{$APPTYPE CONSOLE}


uses
  Classes,
  SysUtils,
  Monadas_Pascal,
  PluTony_Zero_Brokers,
  PluTony_Zero_FastScript ;

begin
  modoconsole:=true;

 // SERVICE_NAME__ := 'rem';

  LunchBroker(InjectSimpleFastScript());


end.

