unit Plutony_Zero_RemScript;

{$I plutonidef.inc}
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

  This unit uses pascalscript lib from remobjects
  https://www.remobjects.com/ps.aspx

*)


interface

// implementation end.
uses
  PluTony_Runtime_App,

{$IFDEF COMPACMODE}
  Monadas_Pascal,
{$ELSE}
  Todo_IScript,
{$ENDIF}
  Classes, uPSComponent, uPSCompiler, uPSRuntime,
  // fpcunit,
  uPSC_std, uPSC_classes,
  uPSR_std, uPSR_classes;

Type
  TSampleScript = record
    last_script: string;
    fengine: TIFPS3CompExec;

    procedure Init_();
    procedure Done;
    function Run(const s: String = ''): String;

    function Engine: TIFPS3CompExec;
    procedure SetUp;

    procedure Compile(script: string);

    procedure OnCompile(Sender: TPSScript); // virtual;
    procedure OnExecute(Sender: TPSScript); // virtual;
    procedure OnCompImport(Sender: TObject; x: TIFPSPascalCompiler); // virtual;
    procedure OnExecImport(Sender: TObject; se: TIFPSExec;
      x: TIFPSRuntimeClassImporter); // virtual;
    // procedure Print(const s: string);
  end;

  TScriptRem = class(TScriptAbstract)
    constructor Create(const obj: TObject = nil); reintroduce; overload;
    destructor Destroy; override;
    function Runs(const req: TScriptRequest): TScriptResponse; override;

  public
    scrip: TSampleScript;

  end;

function InjectScriptRem(): IScript;

implementation

uses

{$IFDEF COMPACMODE}
{$ELSE}
  // Monada_Abstract,
{$ENDIF}

  SysUtils, TypInfo, Types;

var
  resulta: TTypeRuntimeResult;

function InjectScriptRem(): IScript;
begin
  result := TScriptRem.Create(nil)
end;

{ TSampleScript }

procedure TSampleScript.Init_();
begin
  fengine := nil;
end;

procedure TSampleScript.Done;
begin
  if fengine <> nil then
  begin
    fengine.Free;
    fengine := Nil;
  end;
end;

constructor TScriptRem.Create(const obj: TObject);
begin
  inherited Create(obj);
  scrip.Init_;

end;

destructor TScriptRem.Destroy;
begin
  scrip.Done;

  inherited Destroy;
end;

function TScriptRem.Runs(const req: TScriptRequest): TScriptResponse;
begin
  result.Init(scrip.Run(req))
end;

function MyFormat_(const Format: string; const Args: array of const): string;
begin
  result := SysUtils.Format(Format, Args);
end;

function TSampleScript.Run(const s: String = ''): String;

var
  ok: boolean;
begin
  resulta.Reset;
  last_script := s;

  Compile(s);

  ok := fengine.Execute;
  result := resulta.resulta;

  (*
    Check(ok, 'Exec Error:' + Script + #13#10 +
    CompExec.ExecErrorToString + ' at ' +
    Inttostr(CompExec.ExecErrorProcNo) + '.' +
    Inttostr(CompExec.ExecErrorByteCodePosition));
  *)
end;

procedure MyWriteln(const s: string);
begin
  writeln(s)
end;

procedure Print(const s: string);
begin
  resulta.Print(s)

  // writeln(s)
end;

function MyReadln(const question: string): string;
begin

  result := '' // InputBox(question, '', '');
end;

procedure TSampleScript.OnCompile(Sender: TPSScript);
begin
  Sender.AddFunction(@MyFormat_,
    'function Format(const Format: string; const Args: array of const): string;');
  Sender.AddFunction(@MyWriteln, 'procedure Writeln(s: string);');
  Sender.AddFunction(@Print, 'procedure Print(s: string);');
  Sender.AddFunction(@MyReadln, 'function Readln(question: string): string;');
  // Sender.AddFunction(@ImportTest, 'function ImportTest(S1: string; s2: Longint; s3: Byte; s4: word; var s5: string): string;');
  Sender.AddRegisteredVariable('vars', 'Variant');
  // Sender.AddRegisteredVariable('Application', 'TApplication');
  // Sender.AddRegisteredVariable('Self', 'TForm');
  // Sender.AddRegisteredVariable('Memo1', 'TMemo');
  // Sender.AddRegisteredVariable('Memo2', 'TMemo');

end;

procedure TSampleScript.OnCompImport(Sender: TObject; x: TIFPSPascalCompiler);
begin
  SIRegister_Std(x);
  SIRegister_Classes(x, true);
  (* SIRegister_Graphics(x, true);

    SIRegister_ComObj(x);
  *)
end;

procedure TSampleScript.OnExecImport(Sender: TObject; se: TIFPSExec;
  x: TIFPSRuntimeClassImporter);
begin
  RIRegister_Std(x);
  RIRegister_Classes(x, true);
  (*
    RIRegister_Graphics(x, True);

    RIRegister_ComObj(exec);
  *)
end;

procedure TSampleScript.OnExecute(Sender: TPSScript);
begin
  // Sender.SetVarToInstance('SELF', Self);
end;

procedure TSampleScript.Compile(script: string);
var
  OutputMessages: string;
  ok: boolean;
  i: Longint;
begin
  if Engine = nil then
  begin
    exit
  end;
  fengine.script.Clear;
  fengine.script.Add(script);

  OutputMessages := '';
  ok := fengine.Compile;
  if (NOT ok) then
  begin
    // Get Compiler Messages now.
    for i := 0 to fengine.CompilerMessageCount - 1 do
      OutputMessages := OutputMessages + fengine.CompilerErrorToStr(i);
  end;
  // Check(ok, 'Compiling failed:' + Script + #13#10 + OutputMessages);

end;

function TSampleScript.Engine: TIFPS3CompExec;
begin
  if fengine = nil then
  begin
    SetUp;
  end;
  result := fengine

end;

procedure TSampleScript.SetUp;
begin
  fengine := TIFPS3CompExec.Create(nil);
  fengine.OnCompile := {$IFDEF FPC}@{$ENDIF}OnCompile;
  fengine.OnExecute := {$IFDEF FPC}@{$ENDIF}OnExecute;
  fengine.OnCompImport := {$IFDEF FPC}@{$ENDIF}OnCompImport;
  fengine.OnExecImport := {$IFDEF FPC}@{$ENDIF}OnExecImport;
end;

procedure AddInjectorRem;
begin
  RunAppExample.AddInject('REM',InjectScriptRem)
end;

initialization
  AddInjectorRem;

end.
// 383
