unit PluTony_Zero_Expresion;

interface

(*
  PluTony : Jupyter Pascal extensions.
  Copyright (c) 2022  Antonio Alcázar Ruiz

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

*)

{$I plutonidef.inc}

uses

  PluTony_Runtime_App,

{$IFDEF COMPACMODE}
  Monadas_Pascal;
{$ELSE}
ToDoSsum,
  todo_iScript,

  // TodoAbstract,
  Monada_Abstract,
  ToDoComponent;
{$ENDIF}

type

  StringScript = String;

  TScriptExpression = class(TScriptAbstract)
    constructor Create(const obj: TObject = nil); reintroduce; overload;
    destructor Destroy; override;
    function Runs(const req: TScriptRequest): TScriptResponse; override;

  end;

  TTestExpression = record
    resulta: String;

    procedure Init;
    class function Exec(s: string): string; static;

  end;

function InjectScriptExpresion: IScript;

implementation

uses
  System.Bindings.Expression,
  System.Bindings.Helper,
  rtti,
  Variants
  // , todossum
    ;

function RunSimpleExpression(const req: string): string;
var
  LExpression: TBindingExpression;
  va: TValue;
  v: Variant;
begin
  result := '';
  LExpression := TBindings.CreateExpression([], req);
  try
    va := LExpression.Evaluate.GetValue;
    v := va.AsVariant;
    result := v;
  finally
    LExpression.Free;
  end;
end;

function InjectScriptExpresion: IScript;
var
  se: TScriptExpression;
begin
  se := TScriptExpression.Create();
  result := se;
end;

function CreateScriptExpresion: TScriptExpression;
begin
  result := TScriptExpression.Create();
  result.DoReferenced(false);
  // result := se;
end;

{ TAutoFree }

constructor TScriptExpression.Create(const obj: TObject = nil);
begin
  inherited Create(obj);

end;

destructor TScriptExpression.Destroy;
begin

  inherited Destroy;
end;

function TScriptExpression.Runs(const req: TScriptRequest): TScriptResponse;
begin
  result.Init(RunSimpleExpression(req));
end;

{ TTestExpression }

class function TTestExpression.Exec(s: string): string;
begin
  result := RunSimpleExpression(s);
end;

procedure TTestExpression.Init;
begin
  resulta := ''
end;

procedure AddInjectorExpresion;
begin
  RunAppExample.AddInject('Expresion', InjectScriptExpresion)
end;

initialization

AddInjectorExpresion;

end.
