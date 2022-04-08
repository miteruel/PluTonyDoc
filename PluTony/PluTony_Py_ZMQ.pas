unit PluTony_Py_ZMQ;
(*
  Copyright (c) 2022  Antonio Alcázar Ruiz
  PluTony : Jupyter Pascal extensions.

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

  This unit uses python4delphi  lib from pyscripter
  https://github.com/pyscripter/python4delphi

*)

interface

{$I plutonidef.inc}

uses

  WrapDelphi,
  PluTony_Zero_Brokers,

{$IFDEF COMPACMODE}
  Monadas_Pascal,

{$ELSE}
  Todo_IScript,

{$ENDIF}
  //
  PluTony_Python_Classes,
  PythonEngine;

type

  TPyZMQResponser = class(TPyMitClase)

  public

    Server_: TServer0MQ;

    // Constructors & Destructors
    constructor Create(APythonType: TPythonType); override;
    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;
    destructor Destroy; override;
    function sendHelper(args: PPyObject): PPyObject; cdecl;
    function recvhelper(args: PPyObject): PPyObject; cdecl;
    // Basic services
    function runScript(args: PPyObject): PPyObject; cdecl;

    function CreateServer(const bidserver: String): boolean; virtual;

    function SetAttr(key: PAnsiChar; Value: PPyObject): Integer; override;

    // Class methods
    class procedure RegisterMethods(PythonType: TPythonType); override;
    class procedure RegisterMembers(PythonType: TPythonType); override;
    class procedure RegisterGetSets(PythonType: TPythonType); override;
    class function CreatePyServer(root: UnicodeString): PPyObject; virtual;
    class function CreateInstance(const args: PPyObject): PPyObject; virtual;
    class function InjectScript(): IScript; virtual;

  end;

  TPyServer0MQ = class(TPyZMQResponser)
  class var
    TipoServer0MQ_: TTypePythonDef;
  public
    class function CreateInstance(const args: PPyObject): PPyObject; override;
  end;

{$IFDEF PLUTONY_ZEROPY}

  TPyZeroScriptPython = class(TPyZMQResponser)
  class var
    TipoPyZeroPython: TTypePythonDef;
  public

    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;
    destructor Destroy; override;

    class function InjectScript: IScript; override;

    class function CreateZeroPython(root: UnicodeString): PPyObject;
    class function CreateInstance(const args: PPyObject): PPyObject; override;

  end;
{$ENDIF}

  TPyClient0MQ = class(TPyMitClase)

  public

    Client__: TZeroMQDevice;

    // Constructors & Destructors
    constructor Create(APythonType: TPythonType); override;
    destructor Destroy; override;

    function recvhelper_(args: PPyObject): PPyObject; cdecl;
    function runScripthelper(args: PPyObject): PPyObject; cdecl;

    function recvSub(args: PPyObject): PPyObject; cdecl;

    function sendHelper(args: PPyObject): PPyObject; cdecl;
    function Get_Service(obj: PPyObject; AContext: Pointer): PPyObject; cdecl;
    function Set_Service(obj, avalue: PPyObject; AContext: Pointer)
      : Integer; cdecl;

    function SetAttr(key: PAnsiChar; Value: PPyObject): Integer; override;

    // Class methods
    class procedure RegisterMethods(PythonType: TPythonType); override;
    class procedure RegisterMembers(PythonType: TPythonType); override;
    class procedure RegisterGetSets(PythonType: TPythonType); override;
    // class function doRestServe_(pself, args: PPyObject): PPyObject; cdecl;

  end;

  TPyClient0MQPub = class(TPyClient0MQ)
  class var
    TipoClient0MQ_: TTypePythonDef;
    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;

    class function CreatePyClientReq(root, ser: UnicodeString): PPyObject;

  end;

  TPluTonyRegistration0MQ = class(TRegisteredUnit)
  public
    function Name: string; override;
    procedure RegisterWrappers(APyDelphiWrapper: TPyDelphiWrapper); override;
    procedure DefineVars(APyDelphiWrapper: TPyDelphiWrapper); override;
    procedure DefineFunctions(APyDelphiWrapper: TPyDelphiWrapper); override;

    function doServezmq(pself, args: PPyObject): PPyObject; cdecl;
    function doClientZmqPub(pself, args: PPyObject): PPyObject; cdecl;
    function doZeroBroker(pself, args: PPyObject): PPyObject; cdecl;
{$IFDEF PLUTONY_ZEROPY}
    function doServePyScript(pself, args: PPyObject): PPyObject; cdecl;
{$ENDIF}
  end;

type

  TPyRouterScript = class(TPyMitClase)
  class var
    TipoRestServer: TTypePythonDef;

  public

    Broker: TCompleteBroker;

    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;
    destructor Destroy; override;

    function runScript(args: PPyObject): PPyObject; cdecl;
    function runService(args: PPyObject): PPyObject; cdecl;

    function Info(args: PPyObject): PPyObject; cdecl;

    function SetAttr(key: PAnsiChar; Value: PPyObject): Integer; override;

    // Class methods
    class procedure RegisterMethods(PythonType: TPythonType); override;
    class procedure RegisterMembers(PythonType: TPythonType); override;
    class procedure RegisterGetSets(PythonType: TPythonType); override;
    class function CreatePyServer(root: UnicodeString): PPyObject;

  end;

implementation

uses
  // rtti,
  SysUtils;

constructor TPyZMQResponser.Create(APythonType: TPythonType);
begin
  inherited;
  Server_.Inits();
end;

destructor TPyZMQResponser.Destroy;
begin
  // MonoFile := '';
  Server_.Done;
  inherited;
end;

class function TPyZMQResponser.InjectScript: IScript;
begin
  result := nil
end;

function TPyZMQResponser.SetAttr(key: PAnsiChar; Value: PPyObject): Integer;
var
  ro: PAnsiString;
begin
  result := 0;
  with GetPythonEngine do
  begin
    if key = 'root' then
    begin
      if PyArg_Parse(Value, 's:Point.SetAttr', @ro) = 0 then
        result := -1;
    end

    else
      result := inherited SetAttr(key, Value);
  end;
end;

function TPyZMQResponser.recvhelper(args: PPyObject): PPyObject;
var
  ss: TParsedPython;
  re: Integer;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  ss := ParseString_('s:recv', args);
  if ss.OkParsed then
  begin
    msg := Server_.receive_();
    result := GetPythonEngine.VariantAsPyObject(msg);
  end;
end;

function TPluTonyRegistration0MQ.doServezmq(pself, args: PPyObject)
  : PPyObject; cdecl;
var
  fina: TParsedPython;
begin
  result := nil;
  fina := ParseString_('s:DoServe', args);
  if fina.OkParsed then
  begin
    result := TPyServer0MQ.CreatePyServer(fina.Param);
  end;
end;

class function TPyZeroScriptPython.CreateZeroPython(root: UnicodeString)
  : PPyObject;

begin
  result := CreatePyServer(root);

end;

function TPyZMQResponser.sendHelper(args: PPyObject): PPyObject;
var
  ss: PAnsiChar;
  re: boolean;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:send', @ss) <> 0 then
    begin
      msg := ss;
      re := Server_.send(msg);
      result := GetPythonEngine.PyBool_FromLong(Integer(re));
    end;
  end;
end;

class procedure TPyZMQResponser.RegisterMembers(PythonType: TPythonType);
begin
  with PythonType do
  begin
    // AddMember( 'x', mtInt, NativeInt(@TPyPoint(nil).x), mfDefault, 'x coordinate');
    // AddMember( 'y', mtInt, NativeInt(@TPyPoint(nil).y), mfDefault, 'y coordinate');
  end;
end;

class procedure TPyZMQResponser.RegisterGetSets(PythonType: TPythonType);
begin
  with PythonType do
  begin
    // AddGetSet('root', TPyRestServer GetName, TPyRestServer SetName,
    // 'Name of a point', nil);
  end;
end;

function TPyZMQResponser.runScript(args: PPyObject): PPyObject;
var
  ss: TParsedPython;
  re: string;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  ss := ParseString_('s:runScript', args);
  if ss.OkParsed then
  begin
    msg := ss.Param;
    re := Server_.RunSimple(msg); // Serve.recv_(msg);
    result := GetPythonEngine.VariantAsPyObject(msg);
  end;
end;

(*
  class procedure TPyFastScripts.RegisterMethods(PythonType: TPythonType);
  begin
  inherited;
  with PythonType do
  begin

  AddMethod('runScript', @TPyFastScripts.runScript,
  'Returns the result for script');
  // AddMethod('send', @TPyFastScripts.sendHelper, 'send response of server');

  end;

  end;
*)
class procedure TPyZMQResponser.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  with PythonType do
  begin

    AddMethod('recv', @TPyZMQResponser.recvhelper,
      'Returns the next value in server');
    AddMethod('send', @TPyZMQResponser.sendHelper, 'send response of server');
    AddMethod('runScript', @TPyZMQResponser.runScript,
      'Returns the result for script');
    // AddMethod('send', @TPyFastScripts.sendHelper, 'send response of server');

  end;

end;

{ TPyRestServer }

function TPyZMQResponser.CreateServer(const bidserver: String): boolean;
begin
  result := bidserver <> '';
  Server_.InitScriptMode(bidserver, InjectScript)
end;

constructor TPyZMQResponser.CreateWith(PythonType: TPythonType;
  args: PPyObject);
var
  aName: PAnsiChar;

begin
  inherited;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:RestServe', @aName) <> 0 then
    begin
      CreateServer(aName)
    end;
  end;
end;

constructor TPyClient0MQ.Create(APythonType: TPythonType);
begin
  inherited;
  Client__.Inits();
end;

destructor TPyClient0MQ.Destroy;
begin

  Client__.Done;
  inherited;
end;

function TPyClient0MQ.SetAttr(key: PAnsiChar; Value: PPyObject): Integer;
var
  ro: PAnsiString;
begin
  result := 0;
  with GetPythonEngine do
  begin
    if key = 'root' then
    begin
      if PyArg_Parse(Value, 's:Point.SetAttr', @ro) = 0 then
        result := -1;
    end
    else
      result := inherited SetAttr(key, Value);
  end;
end;

class procedure TPyClient0MQ.RegisterMembers(PythonType: TPythonType);
begin
  with PythonType do
  begin
    // AddMember( 'x', mtInt, NativeInt(@TPyPoint(nil).x), mfDefault, 'x coordinate');
    // AddMember( 'y', mtInt, NativeInt(@TPyPoint(nil).y), mfDefault, 'y coordinate');
  end;
end;

function TPyClient0MQ.Get_Service(obj: PPyObject; AContext: Pointer): PPyObject;
begin
  Adjust(@Self);
  result := GetPythonEngine.PyUnicodeFromString(Client__.SERVICE_NAMEs);
end;

function TPyClient0MQ.Set_Service(obj, avalue: PPyObject;
  AContext: Pointer): Integer;
var
  _object: string;
begin
  Adjust(@Self);
  if CheckStrAttribute(avalue, 'Service', _object) then
  begin
    Self.Client__.SERVICE_NAMEs := string(_object);
    // GetPythonEngine.PyUnicodeAsString(_object);
    result := 0;
  end
  else
    result := -1;
end;
(*
  inherited;
  PythonType.AddGetSet('Parent', @TPyDelphiControl.Get_Parent, @TPyDelphiControl.Set_Parent,
  'Returns/Sets the Control Parent', nil);
*)

class procedure TPyClient0MQ.RegisterGetSets(PythonType: TPythonType);
begin
  with PythonType do
  begin
    AddGetSet('Service', @TPyClient0MQ.Get_Service, @TPyClient0MQ.Set_Service,
      'Name of service ', nil);
  end;
end;

function TPyClient0MQ.recvhelper_(args: PPyObject): PPyObject;
var
  ss: PAnsiChar;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:recv', @ss) <> 0 then
    begin
      msg := Client__.recString();
      result := GetPythonEngine.VariantAsPyObject(msg);
    end;
  end;
end;

function TPyClient0MQ.runScripthelper(args: PPyObject): PPyObject;
var
  ss: PAnsiChar;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:runScript', @ss) <> 0 then
    begin
      Client__.sendString(ss);
      msg := Client__.recString();
      result := GetPythonEngine.VariantAsPyObject(msg);
    end;
  end;
end;

function TPyClient0MQ.recvSub(args: PPyObject): PPyObject;
var
  ss: PAnsiChar;
  // re: Integer;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:recv', @ss) <> 0 then
    begin
      msg := '';
      Client__.socket.subscribe(ss);
      msg := Client__.recString();
      result := GetPythonEngine.VariantAsPyObject(msg);
    end;
  end;
end;

function TPyClient0MQ.sendHelper(args: PPyObject): PPyObject;
var
  ss: PAnsiChar;
  re: boolean;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:send', @ss) <> 0 then
    begin
      msg := ss;
      re := Client__.sendString(msg);
      result := GetPythonEngine.PyBool_FromLong(Integer(re));
    end;
  end;
end;

class procedure TPyClient0MQ.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  with PythonType do
  begin
    AddMethod('recSub', @TPyClient0MQ.recvSub,
      'Returns the next value in server');

    AddMethod('runScript', @TPyClient0MQ.runScripthelper,
      'Returns result of the code');

    AddMethod('recv', @TPyClient0MQ.recvhelper_,
      'Returns the next value in server');
    AddMethod('send', @TPyClient0MQ.sendHelper, 'send response of server');

    // AddMethod( 'add', @TPyRestServer.add_, 'add a new item to the list and returns the index position' );
  end;
end;

{ TPyRestServer }

constructor TPyClient0MQPub.CreateWith(PythonType: TPythonType;
  args: PPyObject);
var
  aName: PAnsiChar;
  aser: PAnsiChar;
begin
  inherited;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 'ss:ClienZMQ', @aName, @aser) <> 0 then
    begin
      Client__.InitClientReq(aName, aser)
    end;
  end;
end;

class function TPyServer0MQ.CreateInstance(const args: PPyObject): PPyObject;
var
  py: TPyObject;
begin
  result := nil;
  try
    result := TipoServer0MQ_.CreateTipo(args);

    // Result := Form1.ptStringListIterators.CreateInstanceWith(_args);
  except

  end;
end;

class function TPyZMQResponser.CreateInstance(const args: PPyObject): PPyObject;
begin
  result := nil;
end;

class function TPyZMQResponser.CreatePyServer(root: UnicodeString): PPyObject;
var
  _args: PPyObject;
  py: TPyObject;
begin
  result := nil;
  _args := GetPythonEngine.MakePyTuple
    ([GetPythonEngine.PyUnicodeFromString(root)]);
  try
    result := CreateInstance(_args);
    if (result <> nil) then
    begin
      py := PythonToDelphi(result);
    end
    else
    begin
      result := (_args);
      // py := PythonToDelphi(result);
    end;
    // Result := Form1.ptStringListIterators.CreateInstanceWith(_args);
  finally
    GetPythonEngine.Py_DECREF(_args);
  end;
end;

(*
  class function TPyClient0MQPub.CreatePyClientReq(root: UnicodeString)
  : PPyObject;
  var
  _args: PPyObject;
  py: TPyObject;
  begin
  result := nil;
  _args := GetPythonEngine.MakePyTuple
  ([GetPythonEngine.PyUnicodeFromString(root)]);
  try
  // TipoDirectory
  result := TipoClient0MQ_.CreateTipo(_args);
  if (result <> nil) then
  begin
  py := PythonToDelphi(result);
  end
  else
  begin
  result := TipoClient0MQ_.CreateTipo(_args);

  end;

  finally
  GetPythonEngine.Py_DECREF(_args);
  end;

  end;
*)
class function TPyClient0MQPub.CreatePyClientReq(root, ser: UnicodeString)
  : PPyObject;
var
  _args: PPyObject;
  py: TPyObject;
begin
  result := nil;
  _args := GetPythonEngine.MakePyTuple
    ([GetPythonEngine.PyUnicodeFromString(root),
    GetPythonEngine.PyUnicodeFromString(ser)]);
  try
    // TipoDirectory
    result := TipoClient0MQ_.CreateTipo(_args);
    if (result <> nil) then
    begin
      py := PythonToDelphi(result);
    end
    else
    begin
      result := TipoClient0MQ_.CreateTipo(_args);

    end;

  finally
    GetPythonEngine.Py_DECREF(_args);
  end;

end;

{ Register the wrappers, the globals and the constants }

{ TPluTonyRegistration0MQ }

procedure TPluTonyRegistration0MQ.DefineVars(APyDelphiWrapper
  : TPyDelphiWrapper);
begin
  inherited;
  // TModalResult values
  (* APyDelphiWrapper.DefineVar('mrNone', mrNone);
    APyDelphiWrapper.DefineVar('mrOk', mrOk);
    APyDelphiWrapper.DefineVar('mrIgnore', mrIgnore);
    APyDelphiWrapper.DefineVar('mrYes', mrYes);
    APyDelphiWrapper.DefineVar('mrNo', mrNo);
    APyDelphiWrapper.DefineVar('mrAll', mrAll);
    APyDelphiWrapper.DefineVar('mrNoToAll', mrNoToAll);
    APyDelphiWrapper.DefineVar('mrYesToAll', mrYesToAll);
  *)
end;

function TPluTonyRegistration0MQ.Name: string;
begin
  result := 'PlyZMQ';
end;

function TPluTonyRegistration0MQ.doClientZmqPub(pself, args: PPyObject)
  : PPyObject; cdecl;
var
  aser, fina: PAnsiChar;
  // x: TXml;
begin
  // FreeConsole;

  result := nil;
  // CheckEngine;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 'ss:DoClient', @fina, @aser) <> 0 then
    begin
      try
        result := TPyClient0MQPub.CreatePyClientReq(fina, aser);
      finally

      end;
    end;
    // Result := GetPythonEngine.ReturnNone;
  end;
end;

function TPluTonyRegistration0MQ.doZeroBroker(pself, args: PPyObject)
  : PPyObject; cdecl;
var
  fina: TParsedPython;
begin
  result := nil;
  fina := ParseString_('s:doZeroBroker', args);
  if fina.OkParsed then
  begin
    result := TPyRouterScript.CreatePyServer(fina.Param);
  end;
end;

procedure TPluTonyRegistration0MQ.DefineFunctions(APyDelphiWrapper
  : TPyDelphiWrapper);
begin

  APyDelphiWrapper.RegisterFunction(PAnsiChar('doServezmq'), doServezmq,
    PAnsiChar('doServezmq(s)'#10 + 'doServezmq.'));
  APyDelphiWrapper.RegisterFunction(PAnsiChar('doClientPub'), doClientZmqPub,
    PAnsiChar('DoClientPub(s,h)'#10 + 'doClientPub.'));
  APyDelphiWrapper.RegisterFunction(PAnsiChar('doZeroBroker'), doZeroBroker,
    PAnsiChar('doZeroBroker(s)'#10 + 'doZeroBroker.'));

{$IFDEF PLUTONY_ZEROPY}
  (*
    APyDelphiWrapper.RegisterFunction(PAnsiChar('doZeroPython'),
    @TPyZeroScriptPython.CreateZeroPython,
    PAnsiChar('doZeroPython(s)'#10 + 'doZeroPython.'));
  *)
{$ENDIF}
end;

procedure TPluTonyRegistration0MQ.RegisterWrappers(APyDelphiWrapper
  : TPyDelphiWrapper);
begin
  inherited;

  TPyServer0MQ.TipoServer0MQ_ := PlutonyClaseIterator(APyDelphiWrapper,
    'ZeroServer', TPyServer0MQ, Nil);
  TPyClient0MQPub.TipoClient0MQ_ := PlutonyClaseIterator(APyDelphiWrapper,
    'ZeroClient', TPyClient0MQPub, Nil);

  TPyRouterScript.TipoRestServer := PlutonyClaseIterator(APyDelphiWrapper,
    'ZeroBroker', TPyRouterScript, Nil);

{$IFDEF PLUTONY_ZEROPY}
  TPyZeroScriptPython.TipoPyZeroPython := PlutonyClaseIterator(APyDelphiWrapper,
    'ZeroPythonServer', TPyZeroScriptPython, Nil);

{$ENDIF}
end;

{$IFDEF PLUTONY_ZEROPY}

function TPluTonyRegistration0MQ.doServePyScript(pself, args: PPyObject)
  : PPyObject; cdecl;
var
  fina: TParsedPython;
begin
  result := nil;
  fina := ParseString_('s:DoServe', args);
  if fina.OkParsed then
  begin
    result := TPyZeroScriptPython.CreatePyServer(fina.Param);
  end;
end;

{ TPyRestServer }

class function TPyZeroScriptPython.InjectScript: IScript;
begin
  result := InjectScriptPython()
end;

constructor TPyZeroScriptPython.CreateWith(PythonType: TPythonType;
  args: PPyObject);
var
  aName: PAnsiChar;

begin
  inherited;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:RestServe', @aName) <> 0 then
    begin
      Server_.InitScriptMode(aName, InjectScriptPython())
    end;
  end;
end;

class function TPyZeroScriptPython.CreateInstance(const args: PPyObject)
  : PPyObject;

begin
  result := nil;
  try
    result := TipoPyZeroPython.CreateTipo(args);

    // Result := Form1.ptStringListIterators.CreateInstanceWith(_args);
  except

  end;
end;

destructor TPyZeroScriptPython.Destroy;
begin
  // MonoFile := '';
  // Serve_.Done;
  inherited;
end;
{$ENDIF}

destructor TPyRouterScript.Destroy;
begin
  // MonoFile := '';
  Broker.Done;
  inherited;
end;

function TPyRouterScript.SetAttr(key: PAnsiChar; Value: PPyObject): Integer;
var
  ro: PAnsiString;
begin
  result := 0;
  with GetPythonEngine do
  begin
    if key = 'root' then
    begin
      if PyArg_Parse(Value, 's:Point.SetAttr', @ro) = 0 then
        result := -1;
    end

    else
      result := inherited SetAttr(key, Value);
  end;
end;

function TPyRouterScript.runService(args: PPyObject): PPyObject;
var
  ser, script: PAnsiChar;
  se, re: string;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 'ss:runService', @ser, @script) <> 0 then
    begin
      se := ser;
      msg := script;
      re := Broker.RunInService(ser, msg); // Serve.recv_(msg);
      result := GetPythonEngine.VariantAsPyObject(re);
    end;

  end;

end;

function ParseString_(const masc: PAnsiChar; args: PPyObject): TParsedPython;
var
  fina: PAnsiChar;
begin
  result.Init;
  try
    with GetPythonEngine do
    begin
      if PyArg_ParseTuple(args, masc, @fina) <> 0 then
      begin
        result.Param := fina;
        result.OkParsed := True
      end;
    end;
  finally

  end;
end;

function TPyRouterScript.Info(args: PPyObject): PPyObject;
var
  ss: TParsedPython;
  re: string;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  ss := ParseString_('s:Info', args);
  if ss.OkParsed then
  begin
    msg := ss.Param;
    re := Broker.Dump(); // Serve.recv_(msg);
    result := GetPythonEngine.VariantAsPyObject(re);
  end;
end;

function TPyRouterScript.runScript(args: PPyObject): PPyObject;
var
  ss: TParsedPython;
  re: string;
  msg: Utf8String;
begin
  Adjust(@Self);
  result := nil;
  ss := ParseString_('s:runScript', args);
  if ss.OkParsed then
  begin
    msg := ss.Param;
    re := Broker.RunSimple_(msg); // Serve.recv_(msg);
    result := GetPythonEngine.VariantAsPyObject(re);
  end;
end;

class procedure TPyRouterScript.RegisterMembers(PythonType: TPythonType);
begin
  with PythonType do
  begin
    // AddMember( 'x', mtInt, NativeInt(@TPyPoint(nil).x), mfDefault, 'x coordinate');
    // AddMember( 'y', mtInt, NativeInt(@TPyPoint(nil).y), mfDefault, 'y coordinate');
  end;
end;

class procedure TPyRouterScript.RegisterGetSets(PythonType: TPythonType);
begin
  with PythonType do
  begin
    // AddGetSet('root', TPyRestServer GetName, TPyRestServer SetName,
    // 'Name of a point', nil);
  end;
end;

class procedure TPyRouterScript.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  with PythonType do
  begin
    AddMethod('Info', @TPyRouterScript.Info, 'Returns the Info');
    AddMethod('runService', @TPyRouterScript.runService,
      'Returns the result for script');

    AddMethod('runScript', @TPyRouterScript.runScript,
      'Returns the result for script');
    // AddMethod('send', @TPyRouterScript.sendHelper, 'send response of server');

  end;

end;

{ TPyRestServer }

constructor TPyRouterScript.CreateWith(PythonType: TPythonType;
  args: PPyObject);
var
  aPort: PAnsiChar;

begin
  inherited;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:Broker', @aPort) <> 0 then
    begin
      Broker := BrokerMultiWorker(aPort)
    end;
  end;
end;

class function TPyRouterScript.CreatePyServer(root: UnicodeString): PPyObject;
var
  _args: PPyObject;
  py: TPyObject;
begin
  result := nil;
  _args := GetPythonEngine.MakePyTuple
    ([GetPythonEngine.PyUnicodeFromString(root)]);
  try
    result := TipoRestServer.CreateTipo(_args);
    if (result <> nil) then
    begin
      py := PythonToDelphi(result);

    end
    else
    begin
      result := TipoRestServer.CreateTipo(_args);

    end;
    // Result := Form1.ptStringListIterators.CreateInstanceWith(_args);
  finally
    GetPythonEngine.Py_DECREF(_args);
  end;
end;

initialization

{$IFDEF PLUTONY_ZEROPY}
  TPyZeroScriptPython.TipoPyZeroPython.Init;
{$ENDIF}
TPyRouterScript.TipoRestServer.Init;
TPyServer0MQ.TipoServer0MQ_.Init;
RegisteredUnits.Add(TPluTonyRegistration0MQ.Create);

end.
