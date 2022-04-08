unit Test_ZMQ;

{$I plutonidef.inc}
(*
  Copyright (c) 2022  Antonio Alcázar Ruiz
  PluTony : Jupyter Pascal extensions.

  This unit uses mORMot or XUnit.
  By default, Plutony test run in SynTest(mORMot) mode.
  If you define {$DEFINE USE_XUNIT}, then run in DUnitX mode.
*)

interface

uses

  Plutony_SynTest,
  PluTony_Runtime_App,
{$IFDEF COMPACMODE}
  Monadas_Pascal;
{$ELSE}
TodoString,
  todo_iscript,

  Monada_Abstract;
{$ENDIF}

type

  TFunInjectorTest = array of tFunInjectScript;

  TTestMonaZMQs = class(TMiTestCase)

  published
    procedure LunchBroker();

    procedure LunchServerFastScript();

  public
    procedure LunchServerCustom();

     procedure LunchServerScript(const funs: array of tFunInjectScript;
      const code: string);
    procedure LunchBrokers(const funs: array of tFunInjectScript;
      const code: string);

  end;

type

  TTestMonaZMQCommand = class(TMiTestCase)

  public
    procedure LunchServerCommad();
    procedure SetupFix; override;

  protected
    info: TPlyAppExample;

  end;

var
  KFunInjectorTest_: TFunInjectorTest = [];

implementation

uses
  PluTony_Zero_Brokers,
  PluTony_Rtti,

  SysUtils;

procedure TTestMonaZMQCommand.SetupFix;
begin
  inherited;
  info.init;
end;

const
  arrayCommands: Array of string = ['Hello', 'hello'];

procedure TTestMonaZMQCommand.LunchServerCommad();
var
  Commands: TCommandReqResArray;
  binder: TBindServerClient;
  s: String;

  server: TServer0MQ;
  Cliente: TZeroMQDevice;
  i: Integer;
  sMsg: Utf8String;
  respon: Utf8String;
  ResponserSimple: TResponserSimple;
begin
  Commands := CreateTResponserSimple(@info);
  ResponserSimple := Commands.CreateResponser;
  binder := VerySamplePorts;
  server.InitScriptMode(binder.bindserver, ResponserSimple);
  server.InitThread_;
  Cliente := binder.XeroMQClients;
  for s in arrayCommands do
  begin
    sMsg := s;
    Print(Format('Sending %s %d', [sMsg, i]));
    Cliente.sendString(sMsg);
    // msg_ := TZMQMsg.Create;

    // respon:=
    respon := Cliente.recString();
    WriteLn('Respon: ' + respon);

  end;

  // We never get here but if we did, this would be how we end
  server.Done;

  // sleep(2000);
  Cliente.Done

end;

function LunchSampleServer(const si: IScript): TServer0MQ;
var
  binder: TBindServerClient;
begin
  binder := VerySamplePorts;
  Result.InitScriptMode(binder.bindserver, si);
  Result.InitThread_;
end;

procedure LunchServerClientFastScript(const si: IScript; const pro1: string);
var
  binder: TBindServerClient;
  server: TServer0MQ;
  Cliente: TZeroMQDevice;
  i: Integer;
  sMsg: Utf8String;
  respon: TZeroMessage;
begin
  binder := VerySamplePorts; // Remote;
  server := LunchSampleServer(si);
  Cliente := binder.XeroMQClients();
  for i := 1 to 10 do
  begin
    sMsg := pro1;
    // Print(Format('Sending %s %d', [sMsg, i]));
    Cliente.sendString(sMsg);
    // msg_ := TZMQMsg.Create;

    respon := Cliente.recMessage();

  end;

  // We never get here but if we did, this would be how we end
  server.Done;

  // sleep(2000);
  Cliente.Done

end;

procedure TTestMonaZMQs.LunchServerCustom();

begin
  LunchServerCustomTest();

end;

procedure TTestMonaZMQs.LunchServerFastScript();
begin
  LunchServerScript(KFunInjectorTest_, proPascal1);
end;

procedure TTestMonaZMQs.LunchBroker();
begin
  LunchBrokers(KFunInjectorTest_, proPascal1);
end;

(*
  procedure TTestMonaZMQs.LunchBroker(const ScripEngine: IScript;
  const code: string);
  begin
  LunchBrokerDefault(ScripEngine, code);
  end;
*)

procedure TTestMonaZMQs.LunchServerScript(const funs: array of tFunInjectScript;
  const code: string);
var
  fun: tFunInjectScript;
begin
  for fun in funs do
    if assigned(fun) then

      LunchServerClientFastScript(fun(), code);
end;

procedure TTestMonaZMQs.LunchBrokers(const funs: array of tFunInjectScript;
  const code: string);
var
  fun: tFunInjectScript;
begin
  for fun in funs do
    if assigned(fun) then

      LunchBrokerDefault(fun(), code);
end;

end.
