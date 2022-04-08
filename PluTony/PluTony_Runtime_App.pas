unit PluTony_Runtime_App;
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

interface

uses

{$IFDEF COMPACMODE}
  Monadas_Pascal,

{$ELSE}
  Monada_Directory,
  Monada_File,
  todo_iscript,
  ToDoComponent,
  todo_char,
  todo_exe,

{$ENDIF}
{$IFDEF mormotExt}
  PluTony_Mormot,

{$ENDIF}
  Classes;

type

  TPlantillaKernel = record
  public
    Maindir: TMonaDirectory;
    targetDir: TMonaDirectory;
    OldToken: String;
    NewToken: String;
    TempToken: String;
    procedure Init(const root, target: string; const ot, nt: string);

    procedure recursivo(const origen, destino: TMonaDirectory);
    procedure change(const origen, destino: TMonaDirectory);

    procedure Run;
    function Info: String;
  end;

  tFunInjectScript = function: IScript;

  TInjectorScript = record
  private
  public
    Service: String;
    fun: tFunInjectScript;
    contexto: Pointer;

    Procedure Init(const com: String = ''; const f: tFunInjectScript = nil;
      contex: Pointer = nil);
  end;

  PInjectorScript = ^TInjectorScript;

  TScriptsInjectorArray = record
    Procedure Inits;
    procedure Done;
    function Add(const lab: String; f: tFunInjectScript;
      contexto: Pointer = nil): PInjectorScript;

  private
  public
    commands: array of TInjectorScript;
    function Count: integer;
    function Finds(const lab: String): PInjectorScript;

  end;

  IScriptManager = interface
    function RunScript(const texprog: string): String;

    function InjectScript: IScript;
  end;

  TScriptManaget = class(TInterfaceObject, IScriptManager)
  public
    injector: tFunInjectScript;
    constructor Create(const injs: tFunInjectScript); reintroduce; overload;
    function RunScript(const texprog: string): String; virtual;

    function InjectScript: IScript; virtual;
  end;

  TMonaScriptManager = record
    ScriptMan: IScriptManager;
    procedure Init(const Si: IScriptManager = nil);

    function Run(const a: StringScript): StringScript;
    function Ok: boolean;
    procedure InitManager(injector: tFunInjectScript);

    procedure Done;
  end;

{$M+}

  TSubRecord = record
    fdato: string;
    procedure Init;
    function dato(s: string): string;
  end;

  TPlyAppExample = record
    TemplateKeyKernel: String;

    SubRecord: TSubRecord;
{$IFDEF mormotExt}
    Mor: TRecordMormot;
{$ENDIF}
    Script: TMonaScript;
    funInjectorScript: tFunInjectScript; // = nil;

    function RunTemplate(const target: string; const nt: string): string;
    // static;
    function AddInject(const lab: String; f: tFunInjectScript;
      contexto: Pointer = nil): pCommandReqRes;

    function CreateKernelTemplate(const nt: string): string;
    function CreateKernels(const root, target, nt: string): string;

    procedure SetInjector(const injector: tFunInjectScript);

    procedure Init(const injector: tFunInjectScript = nil);
    class function SimpleList(): String; static;

    class function count_primes(MaxN: integer): integer; static;
    function ExecPascal(s: string): string;
    class function Makelist(MaxN: integer): String; static;

  public
    RegisterScripts: TScriptsInjectorArray;
  end;

  PTestRecordExample__ = ^TPlyAppExample;

  // {$M-}
var
  RunAppExample: TPlyAppExample;

function CreateScriptManager(const injector: tFunInjectScript)
  : TMonaScriptManager;

implementation

Uses
  variants;

function TPlyAppExample.AddInject(const lab: String; f: tFunInjectScript;
  contexto: Pointer): pCommandReqRes;
begin
  if not assigned(funInjectorScript) then
  begin
    funInjectorScript := f
  end;
  RegisterScripts.Add(lab, f, contexto)
end;

class function TPlyAppExample.count_primes(MaxN: integer): integer;
begin
  result := MaxN
end;

class function TPlyAppExample.SimpleList(): String;
begin
  result := Makelist(100)
end;

function TPlyAppExample.CreateKernelTemplate(const nt: string): string;

var
  target, root: TMonaDirectory;
begin
  root := ExeVer.DirRaizBarra;
  target := root / nt;
  RunTemplate(target, nt);
  result := target;
end;

function TPlyAppExample.RunTemplate(const target: string;
  const nt: string): string;
var
  donde, own, root: TMonaDirectory;
begin
  result := '';
  root := ExeVer.DirRaizBarra;
  donde := root / TemplateKeyKernel;
  if not donde.Existe then
  begin
    own := root.OwnerPath;
    donde := own / TemplateKeyKernel;

  end;
  if donde.Existe then
  begin
    result := CreateKernels(own / TemplateKeyKernel, target, nt);
  end;
end;

function TPlyAppExample.CreateKernels(const root, target: string;
  const nt: string): string;
var
  plan: TPlantillaKernel;
begin
  plan.Init(root, target, TemplateKeyKernel, nt);
  plan.Run;
  result := plan.Info();
  // end;
  // result := RunTemplateRoot(root, target, nt);
end;

class function TPlyAppExample.Makelist(MaxN: integer): String;
var
  CoCo: Variant;
  ComArray: Variant;
  s: String;
begin
  CoCo := VarArrayCreate([0, 3], varInteger);

  CoCo[0] := 1;
  CoCo[1] := 2;
  CoCo[2] := 3;
  CoCo[3] := 4;

  ComArray := VarArrayCreate([0, 3, 0, 2], varVariant);
  ComArray[0, 0] := 1;
  ComArray[0, 1] := 1.1;
  ComArray[0, 2] := 'a';
  ComArray[1, 0] := 2;
  ComArray[1, 1] := 2.2;
  ComArray[1, 2] := 'b';
  ComArray[2, 0] := 3;
  ComArray[2, 1] := 3.3;
  ComArray[2, 2] := 'c';
  ComArray[3, 0] := 4;
  ComArray[3, 1] := 4.4;
  ComArray[3, 2] := 'd';

  // procedure VariantToVarRec(const V: variant; var result: TVarRec);
  // doc:=  tdocVariant.NewArray (coco,[]);
  // s:= VariantSaveJSON(doc);
{$IFDEF mormotExt}
  // ?  s:=Variant2String(ComArray);
  s := Variant2StringHuge(ComArray, MaxN);
{$ELSE}
  s := ''; // ComArray;

{$ENDIF}
  result := s
end;

function TPlyAppExample.ExecPascal(s: string): string;
begin
  result := Script.Run(s)
end;

procedure TPlyAppExample.SetInjector(const injector: tFunInjectScript);
begin

  funInjectorScript := injector;
  if assigned(injector) then
  begin
    Script.Init(injector());
  end;
end;

procedure TPlyAppExample.Init(const injector: tFunInjectScript);
begin
  SubRecord.Init;
  RegisterScripts.Inits;
{$IFDEF mormotExt}
  Mor.Init;

{$ENDIF}
  funInjectorScript := injector;
  if assigned(injector) then
  begin
    Script.Init(injector());
  end
  else
  begin
    Script.Init();
  end;
  TemplateKeyKernel := 'fastkernel';

end;

{ TSubRecord }

function TSubRecord.dato(s: string): string;
begin
  result := s + fdato;
end;

procedure TSubRecord.Init;
begin
  fdato := 'datofdato'
end;

procedure TPlantillaKernel.change(const origen, destino: TMonaDirectory);
var
  f: TMonaFile;
  tex, tem, fin: String;
  nuevo: TMonaFile;

begin
  destino.MakeDir;
  for f in origen.ChildFiles() do
  begin

    tex := f.FileContent();
    tem := FindReplace(tex, OldToken, TempToken);
    fin := FindReplace(tem, TempToken, NewToken);
    nuevo := destino.Barra_(f.SimpleName);
    nuevo.SaveToFile(fin);
  end;

end;

procedure TPlantillaKernel.recursivo(const origen, destino: TMonaDirectory);
var
  des: String;

  od: TMonaDirectory;
begin

  change(origen, destino);

  for od in origen.ChildDirs do

  begin
    if pos('__', od.pathName) = 1 then
    begin
      Continue
    end;

    if IGUALESSS(od.pathName, OldToken) then
    begin
      des := destino.Barra_(NewToken);
    end
    else
    begin
      des := destino.Barra_(od.pathName);
    end;

    recursivo(od, des);
  end;

end;

function TPlantillaKernel.Info: String;
begin
  result := Maindir.root + ' -> ' + targetDir.root + ' : ' + NewToken
end;

procedure TPlantillaKernel.Init(const root, target: string;
  const ot, nt: string);

begin
  Maindir := root;
  OldToken := ot;
  NewToken := nt;
  TempToken := GetRandomString(20);
  targetDir := target;

end;

procedure TPlantillaKernel.Run;
begin
  recursivo(Maindir, targetDir);

end;

(*
  const
  SourceKernel = 'e:\python\miteruel\fastkernel';
  targetKernel = 'e:\python\miteruel\samplekernel';

  Procedure RunTemplateExample(const nt: string);
  var
  plan: TPlantillaKernel;
  begin
  plan.Init(SourceKernel, targetKernel, nt);
  plan.Run;
  end;
*)

constructor TScriptManaget.Create(const injs: tFunInjectScript);
begin
  // inherited;
  injector := injs;
end;

function TScriptManaget.RunScript(const texprog: string): String;
var
  scrpt: IScript;
begin
  scrpt := InjectScript;
  if scrpt = nil then
  begin
    result := ''
  end
  else
    result := scrpt.Runs(texprog);
  scrpt := Nil;
end;

function TScriptManaget.InjectScript: IScript;
begin
  if injector = nil then
  begin
    result := nil
  end
  else
  begin
    result := injector()
  end;
end;

function InjectManager(injector: tFunInjectScript): IScriptManager;
begin
  result := TScriptManaget.Create(injector);
end;

function CreateScriptManager(const injector: tFunInjectScript)
  : TMonaScriptManager;
begin
  result.Init(InjectManager(injector));
end;

procedure TMonaScriptManager.InitManager(injector: tFunInjectScript);
begin
  Init(TScriptManaget.Create(injector));
end;

{ TMonaScriptManager }

procedure TMonaScriptManager.Done;
begin
  ScriptMan := nil;

end;

procedure TMonaScriptManager.Init(const Si: IScriptManager);
begin
  ScriptMan := Si;
end;

function TMonaScriptManager.Ok: boolean;
begin
  result := ScriptMan <> nil;

end;

function TMonaScriptManager.Run(const a: StringScript): StringScript;
begin
  if Ok then
  begin
    result := ScriptMan.RunScript(a)
  end
  else
  begin
    result := ''
  end;
end;

{ TInjectorScript }

procedure TInjectorScript.Init(const com: String; const f: tFunInjectScript;
  contex: Pointer);
begin

  Service := com;
  fun := f;
  contexto := contex

end;

function TScriptsInjectorArray.Add(const lab: String; f: tFunInjectScript;
  contexto: Pointer): PInjectorScript;
var
  Id: integer;
begin
  result := Finds(lab);
  if result <> nil then
  begin
    result := nil;
    // ? Si ya existe el comando, ignora nueva definicion ?
  end
  else
  begin
    Id := Count;
    setLength(commands, Id + 1);
    result := @commands[Id];
  end;
  if result <> nil then
  begin
    commands[Id].Service := lab;
    commands[Id].fun := f;
    commands[Id].contexto := contexto;
  end;
end;

function TScriptsInjectorArray.Count: integer;
begin
  result := Length(commands)
end;

function TScriptsInjectorArray.Finds(const lab: String): PInjectorScript;
var
  Id: integer;
begin
  result := nil;
  for Id := 0 to Count - 1 do
  begin
    if lab = commands[Id].Service then
    begin
      result := @commands[Id];
      exit;
    end;
  end;
  (* for id := 0 to Count - 1 do
    begin
    if AnsiString(commands[id].Command) = AnsiString(lab) then
    begin
    Result := @commands[id];
    Exit;
    end;
    end; *)
  for Id := 0 to Count - 1 do
  begin
    if commands[Id].Service = '?' then
    begin
      result := @commands[Id];
    end;
  end;
end;

procedure TScriptsInjectorArray.Inits;
begin
  setLength(commands, 0);
end;

procedure TScriptsInjectorArray.Done;
begin
  setLength(commands, 0);
end;

initialization

RunAppExample.Init(Nil);

end.
