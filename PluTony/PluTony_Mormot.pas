unit PluTony_Mormot;

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

interface

{$I plutonidef.inc}
// implementation end.

{$IFDEF COMPACMODE}

uses Monadas_Pascal;
{$ELSE}

uses
  // TodoString,
  ToDoSsum,
  Mono_String,
  Monada_Directory,
  Monada_File,

  ToDoAbstract;

{$ENDIF}
function GetAllFileJson(const mask: SString; valor: boolean = false): Variant;
function GetFileJsons(const mask: SString): Variant;
function Variant2Mormot(const V: Variant): Variant;
function Variant2String(const V: Variant): string;
function Variant2StringHuge(const V: Variant; num: integer): string;

type
  TRecordMormot = record
    sepa: string;

    function FilesInJson(const mask: SString): String;
    function FilesInCSV(const mask: SString): String;
    procedure Init;

  private
    Basedir: TMonaDirectory;

  private
    function getroot: string;
    procedure setroot(const Value: string);
  public
    property root: string read getroot write setroot;

  end;

implementation

uses
{$IFDEF COMPACMODE}
{$ELSE}
  ToDo_Exe,

{$ENDIF}
  Variants,
  SynCommons,
  SysUtils;

Function Xextractpath(const pa: SString): SString;
begin
  result := ExtractFilePath(pa);
end;

Function TipoObjetoSt(tob: TTipoObjeto): SString;
begin
  if tob in [Todir, Todisk] then
  begin
    result := 'dir';
  end
  else
  begin
    result := 'file';
  end;
end;

function GetAllFileJson(const mask: SString; valor: boolean): Variant;
var
  search: TSearchrec;
  verz: SString;
  lista: Variant;
  cuenta: integer;

  procedure AddFile(const filename_: SString; tob: TTipoObjeto);
  var
    a: Variant;
    dia, mes, ano: word;
    tipo: SString;

  begin
    DecodeDate(now, ano, mes, dia);
    // DecodeTime(now, hora_, minuto, seg, mile);
    tipo := TipoObjetoSt(tob);
    (* if tob in [Todir, Todisk] then
      begin
      tipo := 'dir';
      end
      else
      begin
      tipo := 'file';
      end; *)
    a := _Obj(['id', cuenta, 'time', DateToStr(now), 'day', dia, 'month', mes,
      'zize', 0, 'group', '984', 'user', 'toni@miteruel.com', 'number', 0,
      'rights', 'drwxrwxrwx', 'type', tipo, 'name', PathNomExt_(filename_)
      // ,'fullname',filename_
      , 'date', DateTimeToStr(now)]);

    lista.add(a);
    // a.Size:=si;
  end;

var
  mascara: String;

begin
  cuenta := 0;
  result := TDocVariant.New;
  lista := _Arr([]);
  verz := ConBarra(Xextractpath(mask));
  mascara := verz + '*.*';
  if FindFirst(mascara, faAnyFile, search) = 0 then
    repeat
      If ((search.Attr and fadirectory) = fadirectory) and
        (search.Name[1] <> '.') then
      Begin
        AddFile(verz + search.Name,
          // search.Name,
          Todir);
      end
      else If search.Name[1] <> '.' then
      Begin
        AddFile(verz + search.Name,
          // search.Name,
          // search.Size,
          ToFile);
      end;
      inc(cuenta)
    until FindNext(search) <> 0;
  SysUtils.FindClose(search);
  if valor then
  begin
    result.values := lista;
  end
  else
  begin
    result.result := lista;
  end;
end;

function GetFileJsons(const mask: SString): Variant;
var

  // verz__: SString;
  lista: Variant;
  cuenta: integer;

  procedure AddFile(const filename_: SString; tob: TTipoObjeto);
  var
    a: Variant;
    dia, mes, ano: word;
    info, tipo: SString;

  begin
    DecodeDate(now, ano, mes, dia);
    // DecodeTime(now, hora_, minuto, seg, mile);
    tipo := TipoObjetoSt(tob);

    info := 'time' + DateToStr(now);
    a := _Obj(['id', cuenta, 'simple', PathNomExt_(filename_), 'url', filename_,
      'sample', '', 'info', info, 'type', tipo]);

    lista.add(a);
    inc(cuenta)
    // a.Size:=si;
  end;

var
  nafi: SString;
  dir: TMonaDirectory;
begin
  cuenta := 0;
  result := TDocVariant.New;
  lista := _Arr([]);

  // verz__ := ConBarra(Xextractpath(mask));
  dir := PathRootDir(Xextractpath(mask));

  for nafi in dir.ChildFiles() do
  begin
    AddFile(nafi, ToFile);
  end;
  for nafi in dir.ChildDirs() do
  begin
    AddFile(nafi, Todir);
  end;

  begin
    result.values := lista;

  end;
end;

type
  UnicodeString = string;

function Variant2String(const V: Variant): string;
begin
  result := VariantToString(Variant2Mormot(V))
end;

function Variant2StringHuge(const V: Variant; num: integer): string;
var
  a, re: Variant;
  i: integer;
begin
  a := VarArrayCreate([0, num], varVariant);
  for i := 0 to num do
  begin
    a[i] := V
  end;
  re := Variant2Mormot(a);
  a := null;

  result := VariantToString(re);
end;

function Variant2Mormot(const V: Variant): Variant;
Var
  DeRefV_: Variant;

  function ArrayVarDim1(const deref: Variant): Variant;
  var
    i, cpt: integer;
  begin
    result := _Arr([]); // TDocVariant.NewArray([]);
    cpt := 0;
    for i := VarArrayLowBound(deref, 1) to VarArrayHighBound(deref, 1) do
    begin
      result.add(Variant2Mormot(deref[i]));
      // PyList_SetItem( Result, cpt, VariantAsPyObject(DeRefV[i]) );
      inc(cpt);
    end;
  end;

  function ArrayVarDim2(const deref: Variant): Variant;
  var
    j, i, cpt: integer;
    temp: Variant;
    // L : PPyObject;
  begin
    // Result := PyList_New( VarArrayHighBound( DeRefV, 1 ) - VarArrayLowBound( DeRefV, 1 ) + 1 );
    result := _Arr([]); // TDocVariant.NewArray([]);

    cpt := 0;
    for i := VarArrayLowBound(deref, 1) to VarArrayHighBound(deref, 1) do
    begin
      temp := _Arr([]);
      for j := VarArrayLowBound(deref, 2) to VarArrayHighBound(deref, 2) do
      begin
        temp.add(Variant2Mormot(deref[i, j]));
        // Inc(cpt2);
      end;
      result.add(temp);
      inc(cpt);
    end;
  end;

  function ArrayVarDim3(const deref: Variant): Variant;
  var
    i, cpt: integer;
  begin
    result := _Arr([]); // TDocVariant.NewArray([]);

    // Result := PyList_New( VarArrayHighBound( DeRefV, 1 ) - VarArrayLowBound( DeRefV, 1 ) + 1 );
    cpt := 0;
    for i := VarArrayLowBound(deref, 1) to VarArrayHighBound(deref, 1) do
    begin
      result.add(ArrayVarDim2(deref[i]));
      inc(cpt);

    end;
  end;

var
  s: AnsiString;
  y, m, d, h, mi, sec, ms//, jd, wd
  : word;
  dt: TDateTime;
  dl: integer;
  wStr: UnicodeString;

begin
  // Dereference Variant
  DeRefV_ := V;
  while VarType(DeRefV_) = varByRef or varVariant do
    DeRefV_ := Variant(PVarData(TVarData(DeRefV_).VPointer)^);

  case VarType(DeRefV_) and (VarTypeMask or VarArray) of
    varBoolean:
      begin
        if DeRefV_ = true then
          result := true
        else
          result := false;
      end;
    varSmallint, varByte, varShortInt, varWord, varLongWord,
{$IFDEF FPC}
    // See https://github.com/pyscripter/python4delphi/issues/334
    varInteger:
      result := integer(DeRefV_);
{$ELSE}
    varInteger:
      result := DeRefV_;
{$ENDIF}
    varInt64:
      result := DeRefV_;
    // Int64DynArrayToCsv( DeRefV_ );
    varSingle, varDouble, varCurrency:
      result := double(DeRefV_);
    varDate:
      begin
        dt := DeRefV_;
        // DecodeDate( dt, y, m, d );
        // DecodeTime( dt, h, mi, sec, ms );
        result := dt;
      end;
    varOleStr:
      begin
        if (TVarData(DeRefV_).VOleStr = nil) or (TVarData(DeRefV_).VOleStr^ = #0)
        then
          wStr := ''
        else
          wStr := DeRefV_;
        result := wStr;
      end;
    varString:
      begin
        s := AnsiString(DeRefV_);
        result := s
        // PyBytes_FromStringAndSize(PAnsiChar(s), Length(s));
      end;
{$IFDEF xe5}
    varUString:
      begin
        wStr := DeRefV_;
        result := wStr;
      end;

{$ELSE}
{$ENDIF}
  else
    if VarType(DeRefV_) and VarArray <> 0 then
    begin
      case VarArrayDimCount(DeRefV_) of
        1:
          result := ArrayVarDim1(DeRefV_);
        2:
          result := ArrayVarDim2(DeRefV_);
        // ?  3: Result := ArrayVarDim3(DeRefV_);
      else
        raise Exception.Create
          ('Can''t convert a variant array of more than 3 dimensions to a Python sequence');
      end;
    end
    else if VarIsNull(DeRefV_) or VarIsEmpty(DeRefV_) then
    begin
      result := null;
    end
    else
      // if we cannot get something useful then
      // Result := Null;
      result := DeRefV_;
  end; // of case
end;

function VarArrayOf_(const values: array of Variant): Variant;
var
  i: integer;
begin
  result := VarArrayCreate([0, High(values)], varVariant);
  for i := 0 to High(values) do
    result[i] := values[i];
end;

function TRecordMormot.FilesInCSV(const mask: SString): String;
var
  cuenta: integer;
  fi: TMonaStringList;

  procedure AddFile(const filename_:  TMonaFile; tob: TTipoObjeto);
  var
    a: Variant;
    dia, mes, ano: word;
    ss, info, tipo: SString;

  begin
    DecodeDate(now, ano, mes, dia);
    // DecodeTime(now, hora_, minuto, seg, mile);
    tipo := TipoObjetoSt(tob);

    info := 'time' + DateToStr(now);

    ss := ssum([cuenta, sepa, filename_.SimpleName, sepa, filename_.NameFull, sepa,  Integer(filename_.Size),
      sepa, info, sepa, tipo]);
    fi.add(ss);

    // ?lista.add(a);
    inc(cuenta)
    // a.Size:=si;
  end;

var
   nafil: TMonaFile;
  ss, nafi: SString;
  dir: TMonaDirectory;

begin
  cuenta := 0;
  result := '';
  fi.Init;
  try
    ss := ssum(['id', sepa, 'simple', sepa, 'url', sepa, 'sample', sepa, 'info',
      sepa, 'type']);
    fi.add(ss);

    // verz__ := ConBarra(Xextractpath(mask));
    dir.Init(Basedir.root);
    // := PathRootDir(Xextractpath(mask));

    for nafil in dir.ChildFiles(mask) do
    begin
      AddFile(nafil, ToFile);
    end;
    for nafi in dir.ChildDirs() do
    begin
      AddFile(nafi, Todir);
    end;
    result := fi.Text;
  finally
    fi.Done;
  end;

end;

(*
  function ExportaXML2Csv(xe: TXML; sepa: SChar = ','): TxStringList;
  var
  da: sString;
  st, s, data: sString;

  i: Integer;
  fi, campos: TxStringList;
  ss: TxStringList;
  x: TXML;
  begin
  ss := TxStringList.Create;
  result := Nil;
  if xe = nil then
  exit;
  campos := xe.GetLongs();
  fi := TxStringList.Create;
  s := '';
  for i := 0 to campos.Count - 1 do
  begin
  da := campos[i];
  st := FetchValAnsi(da);
  AddStSepa(s, sepa, st);

  fi.Add(st);
  end;

  ss.Add(s);

  for x in xe do
  begin
  s := '';
  if x <> Nil then
  for i := 0 to fi.Count - 1 do
  begin
  st := fi[i];
  data := x.Attribute(st);
  AddStSepa(s, sepa, data);
  end;
  ss.Add(s);

  end;
  result := ss
  end;
*)

{ TRecordMormot }

function TRecordMormot.FilesInJson(const mask: SString): String;
begin
  result := ''
end;

function TRecordMormot.getroot: string;
begin
  result := Basedir
end;

procedure TRecordMormot.Init;
begin
  Basedir.Init(ExeVer.RootDir);
  sepa := ',';
end;

procedure TRecordMormot.setroot(const Value: string);
begin
  Basedir := Value
end;

end.

