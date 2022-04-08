unit Plutony_Zero_DWS;

//{$define DWSKinks}
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

  This unit uses DelphiWebScript lib from Eric range
  https://github.com/EricGrange/DWScript
*)

{$I plutonidef.inc}

interface

// You must have DWS components
// implementation end.
uses
  PluTony_Runtime_App,

{$IFDEF COMPACMODE}
  monadas_pascal,
{$ELSE}
  Todo_IScript,
{$ENDIF}
  dwsByteBufferFunctions,
//  dwsRegister,


{$IFDEF DWSKinks}
   dwsLinq,
{$ELSE}

{$ENDIF}

  dwsJSONConnector,
  dwsComp;

function RunDWS: string;
procedure TestRunDWS;

function RunScript__(const texprog: string): String;

Type
  TSampleScript = record
    enginedws: TDelphiWebScript;
    FJSON: TdwsJSONLibModule;
    Script_: String;

{$IFDEF DWSKinks}
    FLinq : TdwsLinqFactory;

{$ENDIF}

    procedure Init(const s: String = '');
    procedure Done;
    function Run(const s: String = ''): String;

    function Engine: TDelphiWebScript;

  end;

  TScriptDWS = class(TScriptAbstract)
    constructor Create(const obj: TObject = nil); reintroduce; overload;
    destructor Destroy; override;
    function Runs(const req: TScriptRequest): TScriptResponse; override;

  public
    scrip: TSampleScript;

  end;

{$M+}

  TTestScripts = record
    // StringField: string;
    // SubRecord: TSubRecord;

    procedure Init;
    class function ExecDWS(s: string): string; static;
  private
    // class function ExecDWS(S: string): string; static;
  end;
  // {$M-}

function InjectScriptDws(): IScript;

implementation

uses

  dwsJSON,
  Classes, SysUtils, TypInfo, Types, RTTI, Variants,
  //
  dwsCompiler, dwsExprs, dwsErrors,

  dwsXPlatform;

function InjectScriptDws(): IScript;
begin
  result := TScriptDWS.Create(nil)
end;

function DwsHello_(dws: TDelphiWebScript): String;
var
  exec: IdwsProgramExecution;

  prog: IdwsProgram;
begin
  result := '';
  // compiles the script into a program
  prog := dws.Compile('var s : String = ''Hello World!'';'#13#10 + 'Print(s);');

  // if there were errors, hints or warnings, you'll find them in the Msgs
  if prog.Msgs.Count = 0 then
  begin
    // no compilation problem, we can run the script
    exec := prog.Execute;
    result := exec.result.ToString;
  end
  else
  begin

    // display the compilation problems
    // you'll have to introduce errors in the above script to get there ;)
    result := prog.Msgs.AsInfo;

  end;

end;

function RunDWS: string;
var
  dws: TDelphiWebScript;
begin
  // create the compiler component
  // internal functions (like ShowMessage) register at a global level
  // specific functions on the other hand are handled via TdwsUnit, and have
  // to be linked to each compiler (we don't have any in this sample)
  dws := TDelphiWebScript.Create(nil);
  try
    result := DwsHello_(dws);
  finally
    dws.Free;
  end;
end;

procedure TestRunDWS;
var
  s: String;
begin

  s := RunDWS;
  writeln(s)
end;

{ TSampleScript }

procedure TSampleScript.Init(const s: String);
begin
  enginedws := nil;
  Script_ := s;
end;

procedure TSampleScript.Done;
begin
  if enginedws <> nil then
  begin
    enginedws.Free;
    enginedws := Nil;

  end;

end;

function TSampleScript.Run(const s: String = ''): String;
var
  exec: IdwsProgramExecution;

  prog: IdwsProgram;
  En: TDelphiWebScript;
begin
  En := Engine;
  result := '';
  try

    prog := En.Compile(s);

    // if there were errors, hints or warnings, you'll find them in the Msgs
    if prog.Msgs.Count = 0 then
    begin

      // no compilation problem, we can run the script
      exec := prog.Execute;
      result := exec.result.ToString;
      // in a more complex case, you may want to protect execution with
      // a try-except, to catch script exception (done in the script with a raise)
      // or your own exception (happening in Delphi code invoked from the script)

    end
    else
    begin

      // display the compilation problems
      // you'll have to introduce errors in the above script to get there ;)
      result := prog.Msgs.AsInfo;

    end;

  except

  end;
end;

function TSampleScript.Engine: TDelphiWebScript;
begin
  if enginedws = nil then
  begin
    enginedws := TDelphiWebScript.Create(nil);
    {$IFDEF DWSKinks}
    FLinq := TdwsLinqFactory.Create(enginedws);
    FLinq.Script := enginedws;

{$ELSE}

{$ENDIF}


    FJSON := TdwsJSONLibModule.Create(enginedws);
    FJSON.Script := enginedws;

  end;
  result := enginedws

end;

function RunScript__(const texprog: string): String;
var
  scrpt: TSampleScript;
begin
  // create the compiler component
  // internal functions (like ShowMessage) register at a global level
  // specific functions on the other hand are handled via TdwsUnit, and have
  // to be linked to each compiler (we don't have any in this sample)
  scrpt.Init(texprog);
  try
    result := scrpt.Run
  finally
    scrpt.Done;
  end;
end;

{ TTestRecord }

class function TTestScripts.ExecDWS(s: string): string;
begin
  result := RunScript__(s)
end;

procedure TTestScripts.Init;
begin
  // SubRecord.Init
end;

constructor TScriptDWS.Create(const obj: TObject);
begin
  inherited Create(obj);
  scrip.Init;

end;

destructor TScriptDWS.Destroy;
begin
  scrip.Done;

  inherited Destroy;
end;

function TScriptDWS.Runs(const req: TScriptRequest): TScriptResponse;
begin
  result := scrip.Run(req)
end;

procedure AddInjectorDWS;
begin
  RunAppExample.AddInject('DWS',InjectScriptDws)
end;

initialization
  AddInjectorDWS;
end.
// 263

