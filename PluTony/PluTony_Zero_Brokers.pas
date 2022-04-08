unit PluTony_Zero_Brokers;

interface

(*
  PluTony : Jupyter Pascal extensions.
  Copyright (c) 2022  Antonio Alcázar Ruiz
  mrgarciagarcia at gmail.com

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  -------------------------------------------------------------------------------

  This unit uses PascalZMQ, ZMQ.BrokerProtocol, ZMQ.WorkerProtocol, ZMQ.Protocol,
  Copyright (c) 2020 by Grijjy, Inc.
  Adapted in 2022 by Antonio Alcázar

*)


// implementation end.

{$I plutonidef.inc}

uses
  windows,
  PluTony_Runtime_App,
  Classes,
  SysUtils,
{$IFDEF ZMQ_NORIGINAL}
  PluTony_Zero_GrijjyProtocol2006,
{$ELSE}
 /// You must fix some visiblitity of this units:
  ZMQ.API,
  ZMQ.BrokerProtocol,
  ZMQ.Protocol,

  ZMQ.Shared,
  PascalZMQ,
  /// You must undef {$DEFINE ZMQ_VERIFY_HASH} for allow more easy connection
{$ENDIF}
{$IFDEF COMPACMODE}
  Monadas_Pascal;

{$ELSE}
todo_char,
  todo_iscript,

{$IFNDEF xe5}
  ToDoAbstract,
{$ENDIF}
  Monada_Abstract;
{$ENDIF}

type
  zeroString = UTF8String;

{$IFDEF ZMQ_NORIGINAL}
{$ELSE ZMQ_NORIGINAL}

type

  TZMessageHelper = record helper for TZMessage
    class function CreateBytes(const AData: TBytes): PZMessage; static;

    procedure PushByte(const AValue: Byte);
    procedure PushCommand(const AValue: TZMQCommand);

  end;

const
  ccHeartbeat = TZMQCommand.Heartbeat;
  WorkerMessage = TZMQCommand.WorkerMessage;
  zDealer = TZSocketType.Dealer;
  caForward = TZMQAction.Forward;
  caSendTo = TZMQAction.SendTo;
  zsConnected = TZMQState.Connected;
  stRep = TZSocketType.Rep;
  stReq = TZSocketType.Req;
  stSub = TZSocketType.Sub;
  stPub = TZSocketType.Pub;
  zspInput = TZSocketPoll.Input;
  sprAvailable = TZSocketPollResult.Available;
  sprTimeout = TZSocketPollResult.Timeout;
  ZMQ_SUBSCRIBE = 6;
  ZMQ_UNSUBSCRIBE = 7;

  ccReady = TZMQCommand.Ready;
  caDiscard = TZMQAction.Discard; // TZMQCommand.Ready;
  ClientMessage = TZMQCommand.ClientMessage;

type
  TZSocketJelper = record helper for TZSocket
    procedure Subscribe(filter: AnsiString);
    procedure unSubscribe(filter: AnsiString);
  end;

{$ENDIF}

  { This event is called whenever a new message is received }
  TOnRecvw = procedure(const AMsg: PZMessage; var ARoutingFrame: PZFrame)
    of object;

  { Load average calculation thread }
  TLoadAvg = class(TThread)
  protected
    { Internal }
    FLoadAvg: String;
    function _LoadAvg: String;
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    { Returns the latest load average information on Linux or Windows }
    property LoadAvg: String read FLoadAvg;
  end;

type
  PServer0MQ = ^TServer0MQ;
  TZThread = class;

  TFunCustomThread = Procedure(const z: TZThread; contexto: Pointer);

  TClousureFun = record
  private
    Fun: TFunCustomThread;
    contexto: Pointer;
  public
    Procedure Init_(const f: TFunCustomThread = nil; contex: Pointer = nil);
    function Ok: Boolean;
    function Runs(z: TZThread): Boolean;
  end;

  TZeroMessage = record
    idop: Integer;
    service: string;
    texto: string;
    procedure Init(const s: string = ''; const t: string = ''; op: Integer = 5);
    class operator Implicit(const AValue: PZMessage): TZeroMessage;
    class operator Implicit(const AValue: TZeroMessage): String;

  end;

  TZThread = class(TThread)
  public
    server: PServer0MQ;

  private
    MaxRuns: Integer;
    cuenta: Integer;

    constructor Create(se: PServer0MQ); virtual;

    destructor Destroy; override;
    procedure DoException(const _aException_: Exception);
    function Terminating: Boolean; virtual;
    procedure Execute; override;

    procedure Terminar; virtual; // python
    procedure Run; virtual;

  end;

  TZeroMQDevice = Record
  private
    context: TZContext;
    typo: TZSocketType;
  public
    Socket: TZSocket;
    SERVICE_NAMEs: String;

  private

    FLastError: String;
    Blocked: Boolean;

  public
    procedure Inits(stype: TZSocketType = stReq);
    procedure Done;
    function runScript(const msg: UTF8String): zeroString;

    function recString: zeroString;
    function recMessage(): TZeroMessage;

    function sendString(msg: UTF8String): Boolean;
    procedure InitClientReq(const portbinding: zeroString;
      const service: zeroString);
    procedure InitClient_(const portbinding: zeroString;
      stype: TZSocketType = stReq);
    class function CreateMSGBytes_(const AData: TBytes): PZMessage; static;
    procedure InitClientSub(const portbinding: zeroString);
    function CreateMSGDef___(const source: String): PZMessage;

  private

    class function CreateMSG__(const service, source: String)
      : PZMessage; static;
    class function CreaMSG(const tip: TZeroMessage): PZMessage; static;

    function recMulti_(): PZMessage;
    function _Recv_(out AMsg: PZMessage): Boolean;
    function TextOf(const m: PZMessage): String;

    function sendMulti(var msg: PZMessage): Boolean;

  end;

  TServer0MQ = Record
    Script: TMonaScript;

    procedure Inits();
    procedure Done;
    function receive_(): UTF8String;
    function send(var msg: UTF8String): Boolean;
    procedure Init(const portbinding: String; stype: TZSocketType = stRep;
      Fun: TFunCustomThread = nil; global: Pointer = nil);
    procedure InitScriptMode(const portbinding: String;
      const si: IScript = nil);
    procedure InitThread_;
    function RunSimple(const source: String): String;

    procedure InitRep(const portbinding: String; Fun: TFunCustomThread = nil;
      global: Pointer = nil);
  private

    procedure TerminateThread;

    class operator Implicit(const AValue: String): TServer0MQ;

  private
    Zero: TZeroMQDevice;
    Zthread: TZThread;
    customFun: TClousureFun;

    procedure Bind(const portbinding: String);

  End;

  TBindServerClient = record
    bindserver, HostWorker: String;
    DefaultService: String;
    procedure Init(const bs, bc: String; const ds: string = '');
    procedure CopyFrom(const b: TBindServerClient);
    procedure InitLocalPort(port: String);
    function XeroMQClients(): TZeroMQDevice;

  end;

  // tarraystring = array of string;

  // function GetArrayExamples_(): tarraystring;

function XeroMQClients__(const bindclient: String): TZeroMQDevice;

function VerySamplePorts: TBindServerClient;
function VerySamplePortsRemote: TBindServerClient;
procedure MyRunReqResSample(const z: TZThread; contexto: Pointer);

var
  SERVICE_NAME__: string = 'pascals';///MyService';

const
  testBindPort_ = ':54321';

  bindlocalHost__ = 'tcp://*' + testBindPort_;

  testlocalHost___ = 'tcp://127.0.0.1' + testBindPort_;
  // for test purpose, you can change it:
  testRemoteHost = 'tcp://192.168.1.158' + testBindPort_;


type
  TServiceshelper = class helper for TServices
    function SendOk(const AService: String; const ACommand: TZMQCommand;
      var AMsg: PZMessage; const ASendToId: String = ''): Boolean;
    function ForwardClientMessageToWorkers(const AService: String;
      const ASentFrom: PZFrame; var AMsg: PZMessage;
      const ASendToId: String = ''): Boolean;

  end;

  PZeroTestBroker = ^TCompleteBroker;

  TServerBroker = class(TZMQBrokerProtocol)
  private
    { Receives a message from the Client }
    procedure DoRecvFromClient(const AService: String;
      const ASentFromId: String; const ASentFrom: PZFrame; var AMsg: PZMessage;
      var AAction: TZMQAction; var ASendToId: String); override;
    procedure reForwardMessageToClient(const AService: String;
      var AMsg: PZMessage);

    procedure DoRecv(const ACommand: TZMQCommand; var AMsg: PZMessage;
      var ASentFrom: PZFrame); override;

    { Receives a message from the Worker }
    procedure DoRecvFromWorker(const AService: String;
      const ASentFromId: String; const ASentFrom: PZFrame; var AMsg: PZMessage;
      var AAction: TZMQAction); override;
  end;

  TScriptWorker = class(TZMQProtocol)
  protected
    { Internal }
    FOnRecv: TOnRecvw;
    FLoadAvg__: TLoadAvg;

    { Name of the service }
    FService_: String;
    Script_: TMonaScript;
    Zero: PZeroTestBroker;
    HostService: String;

    { Receives a message from the Broker }
    procedure DoRecv(const ACommand: TZMQCommand; var AMsg: PZMessage;
      var ASentFrom: PZFrame); override;
  protected
    { Send heartbeat }
    procedure SendHeartbeat;

    { Send ready }
    procedure SendReady;

    { This method is called when a connection is established }
    procedure DoConnected; override;

    { This method is called when a heartbeat needs to be sent }
    procedure DoHeartbeat; override;
  public
    constructor Create(const Host: String; const si: IScript = nil;
      const sername: string = ''; const z: PZeroTestBroker = Nil);

    destructor Destroy; override;

    { Connect to broker }
    function Connect(const ABrokerAddress: String;
      const ABrokerPublicKey: String = '';
      const ASocketType: TZSocketType = zDealer; const AService: String = '')
      : Boolean; reintroduce;

    { This event is called whenever a new message is received }
    property OnRecv: TOnRecvw read FOnRecv write FOnRecv;

    // destructor Destroy; override;

    function WaitConnect(wait: Boolean = True): Boolean;

    { Sends a command to the Broker }
    procedure sends_(const AData: TBytes; var ARoutingFrame: PZFrame); overload;
    function Dump: String;
    property ServiceName: String read FService_ write FService_;

  end;

  TMonaWorker = Record
    worker: TScriptWorker;
    Procedure Init(const w: TScriptWorker = nil);
    Procedure Done;

  end;

  TCompleteBroker = record
    Workers: array of TScriptWorker;

    Broker: TServerBroker;

    Zeros_: TZeroMQDevice;
    globalcount: Integer;

    donebloc: Boolean;
    Commands: TCommandReqResArray;
    Bind: TBindServerClient;

    procedure InitPort(const portbinder: string = '');
    procedure Inits(const binder: TBindServerClient);

    procedure Init_(const hostbinder: string = '';
      const hostconnect: string = '');
    procedure Done;
    procedure FixBinding;
    function CreateWorkers(const si: IScript = nil; const sername: string = '';
      wait: Boolean = True; own: Boolean = True): TScriptWorker;

    procedure DoneOwnWorkers;
    procedure DoDelete(const oa: TScriptWorker);

    function WaitConnect(const worker: TScriptWorker;
      wait: Boolean = True): Boolean;

    function CreateWorker___(const Host: String; const si: IScript = nil;
      const sername: string = ''; wait: Boolean = True; own: Boolean = True)
      : TScriptWorker;

    function InitBroker_(): Boolean;
    procedure RunBrokers(const si: IScript = nil; const sername: string = '';
      wait: Boolean = false);

    procedure RunBrokers_(const Host_: String; const si: IScript = nil;
      const sername: string = ''; wait: Boolean = false);
    function CreateControlWorker(): TScriptWorker;

    function RunSimple_(const source: String): String;

    function RunSimpleMal_(const source: String): String;
    function RunSimplePython_(const source: String): String;

    function RunInService(const service, source: String): String;
    procedure AddToList(const oa: TScriptWorker);
    function Dump: String;

  end;

  TLunchBrokerParam = record
    loopCount: Integer;
    delayms: Integer;
    waitar: Boolean;
    procedure Init(loCo: Integer = 100; dela: Integer = 10;
      waita: Boolean = True);
    procedure Done;
  end;

procedure LunchBroker(const ScripEngine: IScript);

function CreateZeroControl(test: PZeroTestBroker): TCommandReqResArray;
procedure LunchBrokerDefault(const ScripEngine: IScript; const code: string);
procedure LunchServerCustomTest();
function BrokerMultiWorker(const port: string): TCompleteBroker;
procedure LunchBrokerMultiWorker(const progs: array of string);

procedure LunchBrokerSample_(const ScripEngine: IScript; const pro1: string;
  const param: TLunchBrokerParam);
procedure RunBrokerSampleLoop(const Broker: TCompleteBroker; const pro1: string;
  const param: TLunchBrokerParam);
procedure RunBrokerMultipleSampleLoop(const Broker: TCompleteBroker;
  const progs: array of string; const param: TLunchBrokerParam);
function GetSystemTimes(var lpIdleTime, lpKernelTime, lpUserTime: TFileTime)
  : BOOL; stdcall;

implementation

// uses windows;

procedure RunPubs(const z: TZThread; contexto: Pointer);
var
  semsg: UTF8String;
begin
  if z <> nil then
  begin
    // server.recv(remsg)
    semsg := 'public yyy ' + IntToStr(z.cuenta);
    z.server.send(semsg);
    // sleep(1000);
  end
end;

procedure TZThread.Run;
begin
  inherited;
  inc(cuenta);
  if server.customFun.Ok then
  begin
    server.customFun.Runs(self)
  end
  else
    case server.Zero.typo of
      stPub:
        RunPubs(self, nil);

    end;
end;

constructor TZThread.Create(se: PServer0MQ);
begin
  inherited Create(false);
  MaxRuns := 0;
  cuenta := 0;
  FreeOnTerminate := True;
  server := se;
end;

procedure TZThread.Terminar;
begin
  if not terminated then
  begin
    Terminate;
  end;
end;

destructor TZThread.Destroy;
begin
  // Disconnect;
  Terminar;
  inherited Destroy;
end;

procedure TZThread.DoException(const _aException_: Exception);
begin
end;
(*

  function XeroMQServer_(const bindserver: String): TServer0MQ;
  begin
  result:=bindserver;
  end;

  (*
  function XeroMQServer_(const bindserver: String): TServer0MQ;
  begin
  result:=bindserver;
  end;
  (*
  function XeroMQServer(const bindserver: String): TServer0MQ;
  begin
  result.Init(bindserver);
  end;
*)

function XeroMQClients__(const bindclient: String): TZeroMQDevice;
begin
  result.InitClient_(bindclient);
end;

{ TClousureFun }

procedure TClousureFun.Init_(const f: TFunCustomThread; contex: Pointer);
begin
  Fun := f;
  contexto := contex;
end;

function TClousureFun.Ok: Boolean;
begin
  result := Assigned(Fun)
end;

function TClousureFun.Runs(z: TZThread): Boolean; // Run: Boolean;
begin
  result := Ok;
  if result then
  begin
    Fun(z, contexto)
  end;
end;

procedure TZThread.Execute;
begin
  while not Terminating do
  begin
    Run;
  end;
end;

function TZThread.Terminating: Boolean;
begin
  result := terminated or ((MaxRuns > 0) and (cuenta >= MaxRuns))
end;

{ TBindServerClient }

procedure TBindServerClient.CopyFrom(const b: TBindServerClient);
begin
  Init(b.bindserver, b.HostWorker, b.DefaultService);
end;

procedure TBindServerClient.InitLocalPort(port: String);
begin
  if port = '' then
  begin
    port := testBindPort_
  end;
  Init('tcp://*' + port, 'tcp://127.0.0.1' + port);
end;

function TBindServerClient.XeroMQClients(): TZeroMQDevice;
begin
  result.InitClient_(HostWorker);
end;

procedure TBindServerClient.Init(const bs, bc: String; const ds: string = '');
begin
  bindserver := bs;
  HostWorker := bc;
  DefaultService := ds;
  if DefaultService = '' then
  begin
    DefaultService := SERVICE_NAME__; // const ds:string=''
  end;
end;

function VerySamplePorts: TBindServerClient;
begin
  result.Init('tcp://*:5555', 'tcp://localhost:5555');
end;

function VerySamplePortsRemote: TBindServerClient;
begin
  result.Init('tcp://*:5555', 'tcp://192.168.1.131:5555');
end;

procedure MyRunReqResSample(const z: TZThread; contexto: Pointer);
var
  remsg: UTF8String;
  semsg: UTF8String;
begin
  if z <> nil then
    if z.server <> nil then
    begin
      remsg := z.server.receive_();
      semsg := remsg + ' yyy ' + remsg;
      z.server.send(semsg)
    end
end;

Procedure ClearString_(var s: String);
var
  old, neo: string;
begin
  old := s;
  neo := StringReplace(old, #10, '', [rfReplaceAll]);
  neo := StringReplace(neo, #13, '', [rfReplaceAll]);
  s := neo;
end;

Procedure RunThreadScript(const z: TZThread; contexto: Pointer);
var
  semsg: UTF8String;
  noutf: String;
begin
  if z.server <> nil then
  begin
    noutf := z.server.receive_();
    ClearString_(noutf);
    semsg := z.server.Script.Run(noutf);
    if semsg = '' then
    begin
      semsg := 'Hola google'
    end;
    z.server.send(semsg)
  end
end;

procedure TServer0MQ.Bind(const portbinding: String);
begin
  try
    Zero.Socket.Bind(portbinding);
  except // silent except
  end;
end;

function TServer0MQ.RunSimple(const source: String): String;
begin

  result := Script.Run(source)

end;

procedure TServer0MQ.Init(const portbinding: String;
  stype: TZSocketType = stRep; Fun: TFunCustomThread = nil;
  global: Pointer = nil);
begin
  Script.Init();
  customFun.Init_(Fun, global);
  Zero.Inits(stype);
  Zthread := nil;
  Bind(portbinding);
end;

procedure TServer0MQ.InitScriptMode(const portbinding: String;
  const si: IScript);
begin
  Script.Init(si);
  customFun.Init_(RunThreadScript, @self);
  Zero.Inits(stRep);
  Zthread := nil;
  Bind(portbinding);
end;

procedure TServer0MQ.InitRep(const portbinding: String;
  Fun: TFunCustomThread = nil; global: Pointer = nil);
begin
  Init(portbinding, stRep, Fun, global)
end;

{ TServer0MQ }

procedure TServer0MQ.TerminateThread;
var
  th: TZThread;
  FreeOnT: Boolean;
begin
  if Zthread <> nil then
  begin
    th := Zthread;
    Zthread := nil;
    FreeOnT := th.FreeOnTerminate;
    th.Terminar;
    if not FreeOnT then
    begin
      FreeNil(th); // :=nil;
    end;
  end
end;

procedure TServer0MQ.InitThread_;
begin
  if Zthread = nil then
  begin
    Zthread := TZThread.Create(@self);
  end
end;

procedure TServer0MQ.Done;
begin
  TerminateThread;
  Zero.Done;
end;

class operator TServer0MQ.Implicit(const AValue: String): TServer0MQ;
begin
  result.Init(AValue);
end;

{ TServer0MQ }

procedure TServer0MQ.Inits;
begin
  Zero.Inits();
  Script.Init();
  Zthread := nil;
  customFun.Init_;
end;

function TServer0MQ.receive_(): UTF8String;
begin
  result := Zero.recString();
end;

function TServer0MQ.send(var msg: UTF8String): Boolean;
begin
  result := Zero.sendString(msg)
end;

procedure TZeroMQDevice.Inits(stype: TZSocketType = stReq);
begin
  typo := stype;
  context := TZContext.Create; // TZMQContext.Create;
  Socket := TZSocket.Create(context, stype);
  Blocked := True;
end;

procedure TZeroMQDevice.InitClientSub(const portbinding: zeroString);
begin
  InitClient_(portbinding, stSub)
end;

procedure TZeroMQDevice.InitClient_(const portbinding: zeroString;
  stype: TZSocketType = stReq);
begin
  typo := stype;
  context := TZContext.Create; // TZMQContext.Create;
  Socket := TZSocket.Create(context, stype);
  Socket.Connect(portbinding);
  Blocked := True;
end;

procedure TZeroMQDevice.InitClientReq(const portbinding: zeroString;
  const service: zeroString);
begin
  typo := stReq;
  SERVICE_NAMEs := service;
  context := TZContext.Create; // TZMQContext.Create;
  Socket := TZSocket.Create(context, typo);
  Socket.Connect(portbinding);
  Blocked := True;
end;

function TZeroMQDevice._Recv_(out AMsg: PZMessage): Boolean;
begin
  result := false;
  { wait for an item, timeout or error }

  case Socket.Poll(zspInput, POLLING_INTERVAL) of
    sprAvailable:
      begin
        AMsg := Socket.receive;
        if (AMsg <> nil) then
          result := True
        else
          FLastError := 'ERR_RECV_INTERRUPTED';
      end;

    sprTimeout:
      FLastError := 'ERR_TIMEOUT';
  else
    FLastError := 'ERR_POLL_INTERRUPTED';
  end;
end;

function TZeroMQDevice.recMulti_(): PZMessage;
var
  cuenta: Integer;
begin
  result := nil;
  if Blocked then
  begin
    result := Socket.receive;
  end
  else
  // if Socket <> nil then
  begin
    cuenta := 0;
    while result = nil do
    begin
      begin
        inc(cuenta);
      end;
      if cuenta > 1 then
      begin
        sleep(100);
      end;

      _Recv_(result);
      if not Blocked then
        if cuenta > 100 then
        begin
          break
        end;

    end;
  end;
end;

function TZeroMQDevice.sendString(msg: UTF8String): Boolean;
var
  msgs: PZMessage;
begin
  msgs := CreateMSG__(SERVICE_NAMEs, msg);
  result := sendMulti(msgs)

end;

function TZeroMQDevice.sendMulti(var msg: PZMessage): Boolean;
begin

  result := Socket.send(msg)

end;

procedure TZeroMQDevice.Done;
begin
  FreeAndNil(context);
  // TerminateThread;
end;

function ZeroFromMessages(const AMsg: PZMessage): TZeroMessage;
begin
  if AMsg = nil then
  begin
    result.Init();
  end
  else if AMsg.FrameCount = 3 then
  begin
    result.idop := AMsg.PopEnum(1); // PopCommand;
    result.service := AMsg.PopString;
    result.texto := AMsg.PopString;
  end
  else if AMsg.FrameCount = 2 then
  begin
    result.idop := 0; // AMsg.PopEnum(1);//PopCommand;
    result.service := AMsg.PopString;
    result.texto := AMsg.PopString;
  end
  else if AMsg.FrameCount = 1 then
  begin
    result.idop := 0; // AMsg.PopEnum(1);//PopCommand;
    result.service := '';
    result.texto := AMsg.PopString;
  end
  else if AMsg.FrameCount > 3 then
  begin
    result.idop := AMsg.PopEnum(1); // PopCommand;
    result.service := AMsg.PopString;
    result.texto := AMsg.PopString;
  end
  else
  begin
    result.Init();
  end;
end;

function TZeroMQDevice.TextOf(const m: PZMessage): String;
var
  tm: TZeroMessage;
begin
  tm := m; // StringFromMessages(m);
  result := tm.texto; // StringFromMessage(m);
end;

{ TZeroMessage }

class operator TZeroMessage.Implicit(const AValue: PZMessage): TZeroMessage;
begin
  result := ZeroFromMessages(AValue)
end;

class operator TZeroMessage.Implicit(const AValue: TZeroMessage): String;
begin
  result := AValue.texto
end;

procedure TZeroMessage.Init(const s, t: string; op: Integer);
begin
  idop := op;
  service := s;
  texto := t;
end;

{ TExampleClient }

function RunRecord(const request: TScriptRequest; contexto: Pointer)
  : TScriptResponse;
begin
  if contexto <> nil then
  begin
    if request.IsCommand(['dump']) then
    begin
      result.Init(PZeroTestBroker(contexto).Dump);
    end
    else if request.IsCommand(['hello']) then
    begin
      result.Init('Hola mundo. Hello world');
    end
    else
    begin

      result.Init('Context Ok');
    end;
  end
  else
  begin
    result.Init('');
  end;
end;

function CreateZeroControl(test: PZeroTestBroker): TCommandReqResArray;
begin
  result.Inits;
  result.Add('dump', RunRecord, test);
  result.Add('hello', RunRecord, test);
end;

{ This event is fired whenever a new message is received from a client }
procedure TServerBroker.DoRecvFromClient(const AService: String;
  const ASentFromId: String; const ASentFrom: PZFrame; var AMsg: PZMessage;
  var AAction: TZMQAction; var ASendToId: String);
begin
  // AAction := TZMQAction.Forward;
  AAction := caForward;
end;

{ This event is fired whenever a new message is received from a worker }
procedure TServerBroker.DoRecvFromWorker(const AService: String;
  const ASentFromId: String; const ASentFrom: PZFrame; var AMsg: PZMessage;
  var AAction: TZMQAction);
begin
  // AAction := TZMQAction.Forward;
  AAction := caForward;
end;

function TCompleteBroker.CreateWorker___(const Host: String;
  const si: IScript = nil; const sername: string = ''; wait: Boolean = True;
  own: Boolean = True): TScriptWorker;
begin
  result := TScriptWorker.Create(Host, si, sername);

  try
    WaitConnect(result, wait);
    if own then
    begin
      AddToList(result);
    end;
  except
    on E: Exception do
      Printsys([E.ClassName, ': ', E.Message]);
  end;
end;

function TCompleteBroker.CreateWorkers(const si: IScript = nil;
  const sername: string = ''; wait: Boolean = True; own: Boolean = True)
  : TScriptWorker;
begin
  result := TScriptWorker.Create(Bind.HostWorker, si, sername);

  try
    WaitConnect(result, wait);
    if own then
    begin
      AddToList(result);
    end;
  except
    on E: Exception do
      Printsys([E.ClassName, ': ', E.Message]);
  end;
end;

function TCompleteBroker.InitBroker_(): Boolean;
begin
  result := false;
  try
    Broker := TServerBroker.Create;
    if Broker.Bind(Bind.bindserver) then
    begin
      result := True;
    end;

  except
    on E: Exception do
      Printsys([E.ClassName, ': ', E.Message]);

    // writeln(E.ClassName, ': ', E.Message);
  end;
end;

function TCompleteBroker.CreateControlWorker(): TScriptWorker;
begin
  result := CreateWorkers(Commands.InjectResponse(), 'control');

end;

procedure TCompleteBroker.RunBrokers(const si: IScript = nil;
  const sername: string = ''; wait: Boolean = false);
begin
  try
    if InitBroker_() then
    begin
      CreateWorkers(si, sername, wait);
    end;

  except
    on E: Exception do
      Printsys([E.ClassName, ': ', E.Message]);

    // writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure TCompleteBroker.RunBrokers_(const Host_: String;
  const si: IScript = nil; const sername: string = ''; wait: Boolean = false);
begin
  try
    if InitBroker_() then
    begin
      CreateWorker___(Host_, si, sername, wait);
    end;

  except
    on E: Exception do
      Printsys([E.ClassName, ': ', E.Message]);

    // writeln(E.ClassName, ': ', E.Message);
  end;
end;

function TCompleteBroker.RunInService(const service, source: String): String;
var
  msgs: PZMessage;
  rec: TZeroMessage;
begin
  result := '';
  inc(globalcount);
  Zeros_.InitClientReq(Bind.HostWorker, service);
  msgs := Zeros_.CreateMSG__(service, source);
  try
    Zeros_.sendMulti(msgs);
    rec := Zeros_.recMessage();
    result := rec.texto;

  finally
    dec(globalcount);
    Zeros_.Done;
    if msgs <> nil then
      msgs.Free;
  end;

end;

function TCompleteBroker.RunSimpleMal_(const source: String): String;
begin
  result := RunInService('MyService2', source);
end;

function TCompleteBroker.RunSimplePython_(const source: String): String;
begin
  result := RunInService('ServicePython', source);
end;

function TCompleteBroker.RunSimple_(const source: String): String;

begin
  result := RunInService(Bind.DefaultService, source);

end;

procedure TCompleteBroker.FixBinding;
begin
  if Bind.HostWorker = '' then
  begin
    Bind.HostWorker := testlocalHost___
    // 'tcp://*' + testBindPort_;
  end;

  if Bind.bindserver = '' then
  begin
    Bind.bindserver := 'tcp://*' + testBindPort_;
  end;

end;

procedure TCompleteBroker.Inits(const binder: TBindServerClient);
begin
  SetLength(Workers, 0);
  Broker := nil;
  globalcount := 0;
  donebloc := false;
  Bind.CopyFrom(binder);
  // bindHost_ := hostbinder;
  if Bind.HostWorker = '' then
  begin
    Bind.HostWorker := testlocalHost___
    // 'tcp://*' + testBindPort_;
  end;
  // bind.
  FixBinding;
  Commands := CreateZeroControl(@self);

end;

procedure TCompleteBroker.Init_(const hostbinder: string = '';
  const hostconnect: string = '');
begin
  SetLength(Workers, 0);
  Broker := nil;
  globalcount := 0;
  donebloc := false;
  Bind.Init(hostbinder, hostconnect);
  FixBinding;
  Commands := CreateZeroControl(@self);

end;

procedure TCompleteBroker.InitPort(const portbinder: string = '');
// var port:string;
begin
  SetLength(Workers, 0);
  Broker := nil;
  globalcount := 0;
  donebloc := false;
  // port:=portbinder;
  Bind.InitLocalPort(portbinder);

  Commands := CreateZeroControl(@self);

end;

function TScriptWorker.Dump: String;
begin
  result := 'Worker ' + ServiceName + ' : ' + SelfId + Eol_;
end;

procedure TScriptWorker.sends_(const AData: TBytes; var ARoutingFrame: PZFrame);
var
  msg: PZMessage;
begin
  msg := TZeroMQDevice.CreateMSGBytes_(AData);
  // send(msg, ARoutingFrame)
  msg.Push(ARoutingFrame);
  msg.PushString(FService_);
  msg.PushCommand(WorkerMessage);
  inherited send(msg);
end;

function TScriptWorker.WaitConnect(wait: Boolean = True): Boolean;
begin
  result := false;
  try
    while True do

      if Connect(HostService, '', zDealer, ServiceName) then
      begin
        result := True;
        break;
        // WaitForCtrlC;
        // RunClient;
      end
      else
      begin
        if wait then
        begin
          sleep(1000);
        end
        else
        begin
          result := false;
          break;
        end;
      end;
  except
    on E: Exception do
      Printsys([E.ClassName, ': ', E.Message]);

    // writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure RunBrokerMultipleSampleLoop(const Broker: TCompleteBroker;
  const progs: array of string; const param: TLunchBrokerParam);
var

  i: Integer;
  respon: UTF8String;
  ran, lonlen: Integer;
  servicio, comando: string;
begin
  if param.waitar then
  begin
    readln;
  end;
  lonlen := Length(progs);

  for i := 1 to param.loopCount do
  begin
    if param.delayms > 0 then
    begin
      sleep(param.delayms);
    end;
    ran := Random(lonlen);
    comando := progs[ran];
    servicio := Fetchar(':', comando);
    respon := Broker.RunInService(servicio, comando);
    // respon := sMsg; // Cliente.receive();
    Prints('Respon: ' + respon);

  end;
  if param.waitar then
  begin
    readln;
  end;

end;

procedure RunBrokerSampleLoop(const Broker: TCompleteBroker; const pro1: string;
  const param: TLunchBrokerParam);
var
  i: Integer;
  sMsg: UTF8String;
  respon: UTF8String;
begin
  if param.waitar then
  begin
    readln;
  end;

  for i := 1 to param.loopCount do
  begin
    if param.delayms > 0 then
    begin
      sleep(param.delayms);
    end;
    (*
      if Random(10) > 7 then
      begin
      sMsg := Broker.RunSimplePython_(proPython1);
      // sMsg := Broker.RunSimpleMal(pro1);
      end
      else *)
    begin
      sMsg := Broker.RunSimple_(pro1);
    end;
    respon := sMsg; // Cliente.receive();
    Prints('Respon: ' + respon);

  end;
  if param.waitar then
  begin
    readln;
  end;

end;

procedure LunchBrokerSamplePort(const ScripEngine: IScript; const pro1: string;
  const param: TLunchBrokerParam; const port: string);
var
  Broker: TCompleteBroker;
begin
  // binder := VerySamplePorts;
  Broker.InitPort(port);
  try
    Broker.RunBrokers_('', ScripEngine);
    RunBrokerSampleLoop(Broker, pro1, param);
    // We never get here but if we did, this would be how we end
  finally
    Broker.Done;
  end;
end;


procedure LunchBroker(const ScripEngine: IScript);
var
  Broker: TCompleteBroker;
  si: IScript;
begin
  // binder := VerySamplePorts;
  Broker.Init_;
  try
    Broker.RunBrokers_(testlocalHost___, ScripEngine);
     readln;
//    RunBrokerSampleLoop(Broker, pro1, param);
    // We never get here but if we did, this would be how we end
  finally
    Broker.Done;
  end;
end;

procedure LunchBrokerSample_(const ScripEngine: IScript; const pro1: string;
  const param: TLunchBrokerParam);
var
  Broker: TCompleteBroker;
  si: IScript;
begin
  // binder := VerySamplePorts;
  Broker.Init_;
  try
    if ScripEngine = nil then
    begin
      Broker.RunBrokers_(testlocalHost___, Broker.Commands.InjectResponse);

    end
    else
    begin
      Broker.RunBrokers_(testlocalHost___, ScripEngine);
    end;
    RunBrokerSampleLoop(Broker, pro1, param);
    // We never get here but if we did, this would be how we end
  finally
    Broker.Done;
  end;
end;

procedure LunchBrokerDefault(const ScripEngine: IScript; const code: string);
var
  param: TLunchBrokerParam;

begin
  param.Init();
  LunchBrokerSample_(ScripEngine, code, param);
  param.Done;
end;

{ TLunchBrokerParam }

procedure TLunchBrokerParam.Done;
begin
  //
end;

procedure TLunchBrokerParam.Init(loCo, dela: Integer; waita: Boolean);
begin
  loopCount := loCo;
  delayms := dela;
  waitar := waita;
end;

procedure TCompleteBroker.DoDelete(const oa: TScriptWorker);
var
  o: TScriptWorker;
  i: Integer;
begin
  if donebloc then
  begin
    exit
  end;

  // len := Length(Workers);
  for i := 0 to Length(Workers) - 1 do
  begin
    o := Workers[i];
    if o = oa then
    begin
      Workers[i] := nil;

    end;
  end;
end;

procedure TCompleteBroker.AddToList(const oa: TScriptWorker);
var
  o: TScriptWorker;
  len: Integer;
begin
  for o in Workers do
  begin
    if o = oa then
    begin
      exit;
    end;
  end;
  len := Length(Workers);
  SetLength(Workers, len + 1);
  Workers[len] := oa;
end;

procedure TCompleteBroker.DoneOwnWorkers;
var
  o, tof: TScriptWorker;
begin
  donebloc := True;

  for o in Workers do
  begin
    tof := o;
    if tof <> nil then

      FreeNil(tof);
  end;
  SetLength(Workers, 0);

end;

function TCompleteBroker.Dump: String;
var
  o: TScriptWorker;
  // len: integer;

begin
  result := 'Broker ' + Eol_;
  for o in Workers do
    if o <> nil then
    begin
      result := result + o.Dump;
    end;

end;

procedure TCompleteBroker.Done;
begin
  DoneOwnWorkers;
  // FreeNil(Worker);
  FreeNil(Broker);
end;

procedure TMonaWorker.Done;
begin
  FreeNil(worker);
end;

procedure TMonaWorker.Init(const w: TScriptWorker);
begin
  worker := nil;

end;

function TZeroMQDevice.recString(): UTF8String;
var
  z: TZeroMessage;
begin
  z := recMessage();
  try
    result := z;
  except
    result := '';
  end;
end;

function TZeroMQDevice.runScript(const msg: UTF8String): zeroString;
begin
  sendString(msg);
  result := recString;
end;

function TZeroMQDevice.recMessage(): TZeroMessage;
var
  m: PZMessage;
begin
  result.Init();
  m := recMulti_();
  try
    result := m;
  finally
    if m <> nil then

      m.Free;

  end;

end;

function TCompleteBroker.WaitConnect(const worker: TScriptWorker;
  wait: Boolean = True): Boolean;
begin
  result := worker.WaitConnect(wait)
end;

class function TZeroMQDevice.CreateMSGBytes_(const AData: TBytes): PZMessage;
begin
  result := TZMessage.Create;
  result.PushBytes(AData);
end;

class function TZeroMQDevice.CreaMSG(const tip: TZeroMessage): PZMessage;
// var msgs: PZMessage;
begin

  result := TZMessage.Create;
  result.PushString(tip.texto);
  result.PushString(tip.service);
  result.PushByte(tip.idop);
  // result.PushEmptyFrame__;

  // result := msgs;
end;

class function TZeroMQDevice.CreateMSG__(const service, source: String)
  : PZMessage;
var
  tip: TZeroMessage;
begin
  tip.Init(service, source);
  result := CreaMSG(tip);
end;

function TZeroMQDevice.CreateMSGDef___(const source: String): PZMessage;
var
  tip: TZeroMessage;
begin
  tip.Init(SERVICE_NAMEs, source);
  result := CreaMSG(tip);
end;

procedure LunchServerCustomTest();
var
  binder: TBindServerClient;
  server: TServer0MQ;
  Cliente: TZeroMQDevice;
  i: Integer;
  sMsg: UTF8String;
  respon: UTF8String;

begin
  binder := VerySamplePorts;

  server.InitRep(binder.bindserver, MyRunReqResSample);
  server.InitThread_;
  Cliente := binder.XeroMQClients();
  for i := 0 to 10 do
  begin
    sMsg := 'Hello';
    // Print(Format('Sending %s %d', [sMsg, i]));
    Cliente.sendString(sMsg);
    respon := Cliente.recString();
    Prints('Respon: ' + respon);
  end;

  // We never get here but if we did, this would be how we end
  server.Done;

  // sleep(2000);
  Cliente.Done
end;

{$IFNDEF ZMQ_NORIGINAL}

procedure TZMessageHelper.PushCommand(const AValue: TZMQCommand);
begin
  /// Assert(GetTypeKind(T) = tkEnumeration);
  PushMemory(AValue, SizeOf(AValue));
end;

procedure TZMessageHelper.PushByte(const AValue: Byte);
begin
  /// Assert(GetTypeKind(T) = tkEnumeration);
  PushMemory(AValue, SizeOf(AValue));
end;

class function TZMessageHelper.CreateBytes(const AData: TBytes): PZMessage;
var
  msgs: PZMessage;
begin
  msgs := TZMessage.Create;
  // inherited Send(Msg, ARoutingFrame);

  msgs.PushBytes(AData);
  result := msgs;
end;

procedure TZSocketJelper.Subscribe(filter: AnsiString);
begin
  if filter = '' then
    zmq_setsockopt(@self, ZMQ_SUBSCRIBE, nil, 0)
    // zmq_setsockopt(FHandle,ZMQ_SUBSCRIBE, nil, 0)
  else
    zmq_setsockopt(@self, ZMQ_SUBSCRIBE, @filter[1], Length(filter));
  // zmq_setsockopt(FHandle,ZMQ_SUBSCRIBE, @filter[1], Length(filter));

end;

procedure TZSocketJelper.unSubscribe(filter: AnsiString);
begin
  if filter = '' then
    zmq_setsockopt(@self, ZMQ_UNSUBSCRIBE, nil, 0)
    // zmq_setsockopt(FHandle,ZMQ_UNSUBSCRIBE, nil, 0)

  else
    zmq_setsockopt(@self, ZMQ_UNSUBSCRIBE, @filter[1], Length(filter));
  // zmq_setsockopt(FHandle,ZMQ_UNSUBSCRIBE, @filter[1], Length(filter));

end;
{$ENDIF ZMQ_NORIGINAL}

{ Sends a message to the service.  The service determines the appropriate worker
  to service the message }
function TServiceshelper.SendOk(const AService: String;
  const ACommand: TZMQCommand; var AMsg: PZMessage;
  const ASendToId: String = ''): Boolean;
var
  service: TService;
begin
  result := false;
  { add the service if it doesn't exist }
  // you must fix the original version, doing  add function protected or public
  service := Add(AService);

  { send the message to the service }
  if service <> nil then
  begin
    // you must fix the original version, doing  send function  public

    result := service.send(ACommand, AMsg, ASendToId);
  end;
end;

{ function message from a client to a worker without modification }
function TServiceshelper.ForwardClientMessageToWorkers(const AService: String;
  const ASentFrom: PZFrame; var AMsg: PZMessage;
  const ASendToId: String = ''): Boolean;
var
  RoutingFrame: PZFrame;
begin
  { add the client reply routing frame, so the worker replies to
    the correct client }
  AMsg.PushEmptyFrame;
  RoutingFrame := ASentFrom.Clone;
  AMsg.Push(RoutingFrame);

  { send the message that was received from the client to a worker
    that handles this service }
  result := SendOk(AService, ClientMessage, AMsg, ASendToId);
end;

{ Forward worker message to client }
procedure TServerBroker.reForwardMessageToClient(const AService: String;
  var AMsg: PZMessage);
var
  RoutingFrame: PZFrame;
begin

  RoutingFrame := AMsg.Unwrap;
  try
    AMsg.PopBytes;
    AMsg.PushString('Error:' + AService);

    AMsg.PushString(AService);
    AMsg.PushCommand(ClientMessage);
    send(AMsg, RoutingFrame);
  finally
    RoutingFrame.Free;
  end;
end;

//
procedure TServerBroker.DoRecv(const ACommand: TZMQCommand; var AMsg: PZMessage;
  var ASentFrom: PZFrame);
var
  SentFromId: String;
  service: String;
  SendToId: String;
  Action: TZMQAction;
begin
  // ? inherited;
  case ACommand of

    ClientMessage:
      begin
        SentFromId := ASentFrom.ToHexString;
        service := AMsg.PopString;

        Action := caDiscard;
        DoRecvFromClient(service, SentFromId, ASentFrom, AMsg, Action,
          SendToId);
        case Action of
          caDiscard:
            ;
          caForward:
            // you must fix the original version, doing  FServices field protected or  public

            if not FServices.ForwardClientMessageToWorkers(service, ASentFrom,
              AMsg) then
            begin
              reForwardMessageToClient(service, AMsg);
            end;
          caSendTo:
            FServices.ForwardClientMessageToWorkers(service, ASentFrom, AMsg,
              SendToId);
        end;
      end;
  else
    inherited
  end;
end;



// {$ENDIF}
{ TZMQWorkerProtocol }

constructor TScriptWorker.Create(const Host: String; const si: IScript = nil;
  const sername: string = ''; const z: PZeroTestBroker = Nil); // override;
begin
  Script_.Init(si);
  HostService := Host;
  Zero := z;
  ServiceName := sername;
  if HostService = '' then
  begin
    HostService := testlocalHost___;
  end;
  if ServiceName = '' then
  begin
    ServiceName := SERVICE_NAME__;
  end;
  FLoadAvg__ := TLoadAvg.Create;
  inherited Create(True, // use heartbeats
    True, // expect reply routing frames
    True); // use thread pool
end;

destructor TScriptWorker.Destroy;
begin
  FLoadAvg__.Free;
  if Zero <> nil then
  begin
    Zero.DoDelete(self)
  end;
  Script_.Done;
  inherited;
end;

{ Connect to broker }
function TScriptWorker.Connect(const ABrokerAddress: String;
  const ABrokerPublicKey: String; const ASocketType: TZSocketType;
  const AService: String): Boolean;
begin
  FService_ := AService;
  result := inherited Connect(ABrokerAddress, ABrokerPublicKey, ASocketType);
end;

{ Send message to Broker }

{ Send heartbeat }
procedure TScriptWorker.SendHeartbeat;
var
  msg: PZMessage;
begin
  msg := TZMessage.Create;
  msg.PushString(FLoadAvg__.LoadAvg);
  msg.PushString(FService_);
  msg.PushCommand(ccHeartbeat);
  inherited send(msg);
end;

{ Send ready }
procedure TScriptWorker.SendReady;
var
  msg: PZMessage;
begin
  msg := TZMessage.Create;
  msg.PushString(FService_);
  msg.PushCommand(ccReady);
  inherited send(msg);
end;

{ Receives a command from the Broker }
procedure TScriptWorker.DoRecv(const ACommand: TZMQCommand; var AMsg: PZMessage;
  var ASentFrom: PZFrame);
var
  request, Response: TBytes;
  source, resulta: String;
begin
  request := AMsg.PopBytes;
  source := StringOf(request);
  // ?  BytesToUtf(request);
  if Assigned(FOnRecv) then
    FOnRecv(AMsg, ASentFrom);

  resulta := Script_.Run(source);

  Response := BytesOf(resulta);

  { We would analyze the request here and build a response to send back to the client }
  sends_(Response, ASentFrom);
end;

{ This method is called when a connection is established }
procedure TScriptWorker.DoConnected;
begin
  SendReady;
end;

{ This method is called when a heartbeat needs to be sent }
procedure TScriptWorker.DoHeartbeat;
begin
  SendHeartbeat;
end;

{ TLoadAvg }

constructor TLoadAvg.Create;
begin
  inherited Create(false);
  FLoadAvg := '';
end;

destructor TLoadAvg.Destroy;
begin
  inherited;
end;

type
  TSystemTimes = record
    IdleTime, UserTime, KernelTime, NiceTime: Int64;
  end;

function GetSystemTimes; external kernel32 name 'GetSystemTimes';

function miGetSystemTimes(out SystemTimes: TSystemTimes): Boolean;
var
  Idle, User, Kernel: TFileTime;
begin
  // Result :=
  GetSystemTimes(Idle, User, Kernel);
  if result then
  begin
    SystemTimes.IdleTime := UInt64(Idle.dwHighDateTime) shl 32 or
      Idle.dwLowDateTime;
    SystemTimes.UserTime := UInt64(User.dwHighDateTime) shl 32 or
      User.dwLowDateTime;
    SystemTimes.KernelTime := UInt64(Kernel.dwHighDateTime) shl 32 or
      Kernel.dwLowDateTime;
    SystemTimes.NiceTime := 0;
  end;
end;

function GetCPUUsage(var PrevSystemTimes: TSystemTimes): Int64;
var
  CurSystemTimes: TSystemTimes;
  Usage, Idle: UInt64;
begin
  result := 0;
  if miGetSystemTimes(CurSystemTimes) then
  begin
    Usage := (CurSystemTimes.UserTime - PrevSystemTimes.UserTime) +
      (CurSystemTimes.KernelTime - PrevSystemTimes.KernelTime) +
      (CurSystemTimes.NiceTime - PrevSystemTimes.NiceTime);
    Idle := CurSystemTimes.IdleTime - PrevSystemTimes.IdleTime;
    if Usage > Idle then
      result := (Usage - Idle) * 100 div Usage;
    PrevSystemTimes := CurSystemTimes;
  end;
end;

function TLoadAvg._LoadAvg: String;
var
  SystemTimes: TSystemTimes;
  Usage: Single;
begin
  Usage := GetCPUUsage(SystemTimes) * 0.01;
  result := Format('%.2f', [Usage]);
end;

const
  CMillisPerDay = Int64(MSecsPerSec * SecsPerMin * MinsPerHour * HoursPerDay);

function DateTimeToMilliseconds(const ADateTime: TDateTime): Int64;
var
  LTimeStamp: TTimeStamp;
begin
  LTimeStamp := DateTimeToTimeStamp(ADateTime);
  result := LTimeStamp.Date;
  result := (result * MSecsPerDay) + LTimeStamp.Time;
end;

function SecondsBetween(const ANow, AThen: TDateTime): Int64;
begin
  result := Abs(DateTimeToMilliseconds(ANow) - DateTimeToMilliseconds(AThen))
    div (MSecsPerSec);
end;

procedure TLoadAvg.Execute;
var
  Start: TDateTime;
begin
  while not terminated do
  begin
    FLoadAvg := _LoadAvg;
    Start := Now;
    while (not terminated) and (SecondsBetween(Now, Start) < 10) do
      sleep(10);
  end;
end;

function BrokerMultiWorker(const port: string): TCompleteBroker;
var
  Bind: TBindServerClient;
  isi: TInjectorScript;
begin
  Bind.InitLocalPort(port);
  Bind.DefaultService := 'fast';
  result.Inits(Bind);

  try
    if result.InitBroker_() then
    begin
      for isi in RunAppExample.RegisterScripts.Commands do
        if Assigned(isi.Fun) then
        begin
          result.CreateWorkers(isi.Fun(), isi.service);

        end;
      (*
        {$IFDEF PLUTONY_FASTSCRIPT}
        result.CreateWorkers(InjectSimpleFastScript(), 'fast');
        {$ENDIF}
        {$IFDEF PLUTONY_ZEROPY}
        result.CreateWorkers(InjectScriptPython(), 'python');

        {$ENDIF}
        {$IFDEF PLUTONY_EXPRESSION}
        result.CreateWorkers(InjectScriptExpresion(), 'expresion');
        {$ENDIF}
        {$IFDEF PLUTONY_DWS}
        result.CreateWorkers(InjectScriptDws(), 'dws');
        {$ENDIF}
        {$IFDEF PLUTONY_REM}
        result.CreateWorkers(InjectScriptRem(), 'rem');
        {$ENDIF}
      *)
    end;

  except
    // ? error

  end;

end;

procedure LunchBrokerMultiWorker(const progs: array of string);
var
  param: TLunchBrokerParam;
  Broker: TCompleteBroker;
begin

  param.Init(10);
  Broker := BrokerMultiWorker('');
  try

    RunBrokerMultipleSampleLoop(Broker, progs, param);

    // We never get here but if we did, this would be how we end
  finally
    param.Done;
    Broker.Done;

  end;

end;

end.
