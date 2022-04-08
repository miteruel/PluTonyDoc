unit PluTony_Zero_FastScript;

interface

{$I plutonidef.inc}
(*
  PluTony : Jupyter Pascal extensions.
  Copyright (c) 2022  Antonio Alcázar Ruiz.
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

  This unit uses FastScript  lib from FastReport
  https://www.fast-report.com/

*)

{$IFNDEF PLUTONY_FASTSCRIPT}

implementation

end.
{$ENDIF}
  uses PluTony_Runtime_App,

  classes,

{$IFDEF COMPACMODE}
// fs_iInterpreter, fs_ipascal,

fix_fs_iInterpreter, fix_fs_ipascal,

  Monadas_Pascal;
{$ELSE}
Todo_IScript,

  fs_iInterpreter, ToDoSsum, ToDoAbstract, Monada_Abstract, fs_ipascal;
{$ENDIF}
//

Type
  TScriptFs = class;

  TScriptPascal = Record
    Procedure Init;
    procedure Done;
    function Run(const req: TScriptRequest): TScriptResponse;

  private

    function RunFun(const fun: String; Params: Variant): Variant;
    function Traza_(): Variant;

  private

    fsScript: TfsScript;
    fsPascal1_: TfsPascal;
    procedure SetLines(const pro: String);
    function getLines: String;

    procedure Reset;
  public
    property Script: string read getLines write SetLines;
  end;

  TScriptFs = class(TScriptAbstract)
    constructor Create(const obj: TObject = nil); reintroduce; overload;
    destructor Destroy; override;

    function Runs(const req: TScriptRequest): TScriptResponse; override;
  public
    scrip: TScriptPascal;

  end;

  TTypeRuntimeResultFs = TTypeRuntimeResult;

function RunScripts(const texprog: string): String;

  function InjectSimpleFastScript: IScript;

  var
    resultas: TTypeRuntimeResultFs;

implementation

uses Variants;

type
{$IFDEF version5}
  TFunctionsResult = class(TfsRTTIModule)

{$ELSE}
  TFunctionsResult = class(TObject)

{$ENDIF}
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;

    procedure AddClasses(const scrip: TfsScript);

  public

{$IFDEF version5}
    constructor Create(AScript: TfsScript); override;
{$ELSE}
    constructor Create;
{$ENDIF}
    destructor Destroy; override;
  end;

procedure TFunctionsResult.AddClasses(const scrip: TfsScript);
begin
  resultas.Reset;
  with fsGlobalUnit do
  begin
    AddedBy := Self;

    AddMethod('procedure print( s: string);', CallMethod);
    AddMethod('procedure prints( s: string);', CallMethod);

  end;

end;

{$IFDEF version5}

constructor TFunctionsResult.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  AddClasses(AScript);
end;

{$ELSE}

constructor TFunctionsResult.Create;
begin
  inherited Create();
  AddClasses(fsGlobalUnit);
end;

{$ENDIF}

destructor TFunctionsResult.Destroy;
begin
  if fsGlobalUnit <> nil then
    fsGlobalUnit.RemoveItems(Self);
  inherited;
end;

function TFunctionsResult.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
// var  tex:Texto;
begin

  Result := 0;
  if ClassType = Nil then
  begin

    if MethodName = 'PRINT' then
    begin
      resultas.Print(Params[0])
    end
    else if MethodName = 'PRINTS' then
    begin
      resultas.Print(Params[0])
    end

  end

end;

{ TTypeRuntimeResultFs }

function InjectSimpleFastScript: IScript;
begin
  Result := TScriptFs.Create(nil);
end;

function RunScripts(const texprog: string): String;
var
  scrpt: TScriptPascal;
begin
  scrpt.Init();
  try
    Result := scrpt.Run(texprog);
  finally
    scrpt.Done;
  end;
end;

{ TScriptFs }

constructor TScriptFs.Create(const obj: TObject);
begin
  inherited Create(obj);
  scrip.Init;

end;

destructor TScriptFs.Destroy;
begin
  scrip.Done;

  inherited Destroy;
end;

function TScriptFs.Runs(const req: TScriptRequest): TScriptResponse;
begin
  Result := scrip.Run(req)
end;

function Trazafs(fs: TfsScript): Variant;
(* var
  i: integer;
  Itemss: TStringList;
  custom: TfsCustomVariable;
*)
begin

  (*
    Itemss := fs.Itemss;
    for i := 0 to Itemss.Count - 1 do
    begin
    // writeln (Itemss[i]);

    custom := TfsCustomVariable(Itemss.Objects[i]);
    // Enginefs.fsScript1.GetItem(I);

    end;
  *)
end;

function TScriptPascal.Traza_(): Variant;

begin
  Result := null;
  exit;
  Trazafs(fsScript);
  Trazafs(fsGlobalUnit);
end;

procedure TScriptPascal.Done;
begin
  FreeNil(fsPascal1_);
  FreeNil(fsScript);
end;

function TScriptPascal.getLines: String;
begin
  Result := fsScript.lines.Text
end;

procedure TScriptPascal.SetLines(const pro: String);
begin
  fsScript.lines.Text := pro;
end;


// RunSimple

function TScriptPascal.Run(const req: TScriptRequest): TScriptResponse;
begin
  try
    Result := '';
    resultas.Reset;
    if req.ClearMem then
    begin
      Reset()
    end;
    Script := req.source;
    if not fsScript.Compile then
    begin
      Result.Error(fsScript.ErrorMsg); // exec.result.ToString;
      exit;

    end;

    // Traza();

    fsScript.Execute;
    Result.Init(resultas.resulta); // exec.result.ToString;
    // Result := true;

  except
    Result.Error('broker error:');

    // Result. := False;
  end;
end;

function TScriptPascal.RunFun(const fun: String; Params: Variant): Variant;
begin
  try
    Result := 0;
    if fun <> '' then
    begin
      if fsScript.FindLocal(fun) <> Nil then
      begin
        Result := fsScript.CallFunction(fun, Params)
      end;
    end
    else
    begin
      fsScript.Execute;
    end;
    Result := true;

  except
    Result := False;
  end;
end;

procedure TScriptPascal.Init;
begin
  fsPascal1_ := TfsPascal.Create(nil);
  fsScript := TfsScript.Create(nil);

  fsScript.Parent := fsGlobalUnit;
end;

procedure TScriptPascal.Reset;
begin
  fsScript.clear
end;

procedure AddInjectorFs;
begin
  RunAppExample.AddInject('fast', InjectSimpleFastScript)
  // RunAppExample.AddInject('FS',InjectSimpleFastScript)
end;

{$IFDEF version5}

initialization

AddInjectorFs;
fsRTTIModules.Add(TFunctionsResult);

finalization

fsRTTIModules.Remove(TFunctionsResult);
{$ELSE}
// end.

var
  Functions: TFunctionsResult;

initialization

AddInjectorFs;
// trace_ ('fs_Elisartti');
{$IFNDEF MINIMIZAMEM}
Functions := TFunctionsResult.Create;
{$ENDIF MINIMIZAMEM}

finalization

{$IFNDEF MINIMIZAMEM}
  Functions.Free;
{$ENDIF MINIMIZAMEM}
{$ENDIF}

end.
