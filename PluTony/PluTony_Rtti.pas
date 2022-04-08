{$I Definition.Inc}
unit PluTony_Rtti;

interface

{$I plutonidef.inc}

// implementation end.
uses

{$IFDEF COMPACMODE}
  Monadas_Pascal,

{$ELSE}
  Todo_IScript,

{$ENDIF}
  //
  PluTony_Runtime_App,

  SysUtils, Classes,
  TypInfo, Types,
  Variants,
  Rtti,
  Contnrs;

Type

  { Base class for exposing Records and Interfaces when Extended RTTI is available }
  TMixRtti = record
  private
    fAddr: Pointer;
    fRttiType: TRttiStructuredType;
    function GetValue: TValue;
    // function Dir_Wrapper(args: PPyObject): PPyObject; cdecl;
  public
    procedure Init(const fA: Pointer; const fRtt: TRttiStructuredType);
    // override;
    function RunRecord(const request: TScriptRequest): TScriptResponse;

    procedure SetAddrAndType(Address: Pointer; Typ: TRttiStructuredType);
    function CallMethod(const MethName_: String;
      const Paramsv: Variant): Variant;

    function GetAttrO(key: string): Variant; // override;
    function SetAttrO_(key: string; const Value: Variant): Integer; // override;
    property Addr: Pointer read fAddr;
    property RttiType: TRttiStructuredType read fRttiType;
    property Value: TValue read GetValue;
    property ParentAddress: Pointer read fAddr;
    property ParentRtti: TRttiStructuredType read fRttiType;

    //
  end;

function DumpRttiRecord(const fRtt: TRttiStructuredType;
  contexto: Pointer): string;
function RunSampleRecord(const request: TScriptRequest;
  const fRtt: TRttiStructuredType; contexto: Pointer): TScriptResponse;
//Procedure TestSampleRecord;
function CreateTResponserSimple(test: PTestRecordExample__): TCommandReqResArray;

implementation

Uses
  // Todo_Garbable,
  // Math,
  // PluTony_Runtime_Example,
  RTLConsts;

resourcestring
  rs_ErrNoTypeInfo = 'TypeInfo is not available';
  rs_ErrPythonToValue = 'Unsupported conversion from Python value to TValue';
  rs_ErrUnexpected = 'Unexpected error';
  rs_NoAccess = 'Private and protected class members cannot be accessed';
  rs_NotReadable = 'The class member is not readable';
  rs_UnknownAttribute = 'Unknown attribute';
  rs_NotWritable = 'The class members  is not writable';

  { Helper functions }
function RunSampleRecord(const request: TScriptRequest;
  const fRtt: TRttiStructuredType; contexto: Pointer): TScriptResponse;
var
  mix: TMixRtti;
begin
  if contexto <> nil then
  begin
    mix.Init(contexto, fRtt);
    result := mix.RunRecord(request);
  end
  else
  begin
    result.Init('');
  end;
end;

function RunSampleRecords(const request: TScriptRequest;
  const fRtt: TRttiStructuredType; contexto: Pointer): TScriptResponse;
var
  mix: TMixRtti;
  param: Variant;
  v: Variant;
  met: String;
begin
  if contexto <> nil then
  begin
    mix.Init(contexto, fRtt);
    param := request.SerialVariant(met);

    v := mix.CallMethod(met, param);
    if v = null then
    begin
      result.Init('');
    end
    else
    begin
      result.Init(v);
    end;
  end
  else
  begin
    result.Init('');
  end;

end;

function SimplePythonToValues(PyValue: Variant; TypeInfo: PTypeInfo;
  out Value: TValue; out ErrMsg: string): Boolean;
Var
  S: string;
  // nu,
  I: Integer;
  v: TValue;
begin
  result := False;
  if TypeInfo = nil then
  begin
    ErrMsg := rs_ErrNoTypeInfo;
    Exit;
  end;
  try
    case TypeInfo^.Kind of
      tkUnknown:
        if PyValue = null then
        begin
          Value := TValue.Empty;
          result := True;
        end
        else
          ErrMsg := rs_ErrPythonToValue;
      tkString, tkWString, tkUString, tkLString, tkChar, tkWChar:
        begin
          v := String(PyValue);
          Value := v.Cast(TypeInfo);
          result := True;
        end;
      (* tkInteger:
        begin

        V := TValue.From<Variant>(PyValue);
        Value := V;
        Result := True;

        end; *)
      tkInteger:
        begin
          // nu := integer(PyValue);

          v := TValue.From<Variant>(Integer(PyValue));
          Value := v.AsInteger;
          result := True;
        end;

      tkFloat, tkInt64, tkVariant:
        begin
          v := TValue.From<Variant>(PyValue);
          if TypeInfo^.Kind = tkVariant then
            Value := v
          else
            Value := v.Cast(TypeInfo);
          result := True;
        end;
      tkEnumeration:
        begin
          S := PyValue;
          I := GetEnumValue(TypeInfo, S);
          Value := TValue.FromOrdinal(TypeInfo, I);
          result := True;
        end;
      (* tkSet:
        begin
        I := PythonToSet(TypeInfo, PyValue);
        TValue.Make(@I, TypeInfo, Value);
        Result := True;
        end; *)
      tkClass, tkMethod, tkArray, tkRecord, tkInterface, tkClassRef, tkPointer,
        tkProcedure:
        ErrMsg := rs_ErrPythonToValue;
    else
      ErrMsg := rs_ErrUnexpected;
    end;
  except
    on E: Exception do
    begin
      result := False;
      ErrMsg := E.Message;
    end;
  end
end;

procedure Rtti_Dir(SL: TStringList; RttiType: TRttiType);
var
  RttiMethod: TRttiMethod;
  RttiProperty: TRttiProperty;
  RttiField: TRttiField;
begin
  for RttiMethod in RttiType.GetMethods do
    if Ord(RttiMethod.Visibility) > Ord(mvProtected) then
      SL.Add(RttiMethod.name);
  for RttiProperty in RttiType.GetProperties do
    if Ord(RttiProperty.Visibility) > Ord(mvProtected) then
      SL.Add(RttiProperty.name);
  for RttiField in RttiType.GetFields do
    if Ord(RttiField.Visibility) > Ord(mvProtected) then
      SL.Add(RttiField.name);
end;

function GetRttiAttrs(ParentAddr: Pointer; ParentType: TRttiStructuredType;
  const AttrName: string; out ErrMsg: string): Variant;
var
  Prop: TRttiProperty;
  Meth: TRttiMethod;
  Field: TRttiField;
begin
  result := null;

  try
    Meth := ParentType.GetMethod(AttrName);
    if Meth <> nil then
    begin
      (* Result := PyDelphiWrapper.fDelphiMethodType.CreateInstance_____;
        with PythonToDelphi(Result) as TPyDelphiMethodObject do
        begin
        fDelphiWrapper := PyDelphiWrapper;
        MethName := Meth.Name;
        ParentRtti := ParentType;
        ParentAddress := ParentAddr;
        end; *)
    end
    else
    begin
      Prop := ParentType.GetProperty(AttrName);
      if Prop <> nil then
      begin
        if Ord(Prop.Visibility) < Ord(mvPublic) then
          ErrMsg := rs_NoAccess
        else if not Prop.IsReadable then
          ErrMsg := rs_NotReadable
        else if Prop.PropertyType = nil then
          ErrMsg := rs_ErrNoTypeInfo
        else
          case Prop.PropertyType.TypeKind of
            tkClass:
              result := Prop.GetValue(ParentAddr).AsVariant;
            tkInterface:
              result := Prop.GetValue(ParentAddr).AsVariant;
            (* tkMethod:
              if (ParentType is TRttiInstanceType) and
              (Prop is TRttiInstanceProperty) then
              Result := PyDelphiWrapper.fEventHandlerList_.GetCallable
              (TObject(ParentAddr), TRttiInstanceProperty(Prop).PropInfo); *)
          else
            result := Prop.GetValue(ParentAddr).AsVariant
          end;
      end
      else
      begin
        Field := ParentType.GetField(AttrName);
        if Field <> nil then
        begin
          if Ord(Field.Visibility) < Ord(mvPublic) then
            ErrMsg := rs_NoAccess
          else if Field.FieldType = nil then
            ErrMsg := rs_ErrNoTypeInfo
          else
            case Field.FieldType.TypeKind of
              tkClass:
                result := Field.GetValue(ParentAddr).AsVariant;
              // .AsObject); // Returns None if Field is nil
              tkInterface:
                result := Field.GetValue(ParentAddr).AsVariant;
              (* tkRecord:
                if Field.FieldType is TRttiStructuredType then
                // Result := PyDelphiWrapper.WrapRecord(Pointer(PPByte(ParentAddr)^ + Field.Offset),  TRttiStructuredType(Field.FieldType));
                Result := PyDelphiWrapper.WrapRecord
                (PByte(ParentAddr) + Field.Offset,
                TRttiStructuredType(Field.FieldType)); *)
            else
              result := Field.GetValue(ParentAddr).AsVariant;
            end;
        end
        else
          ErrMsg := rs_UnknownAttribute;
      end;
    end;
  except
    on E: Exception do
    begin
      result := null;
      ErrMsg := E.Message;
    end;
  end;
end;

function SetRttiAttrs(const ParentAddr: Pointer;
  ParentType: TRttiStructuredType; const AttrName: string; Value__: Variant;
  out ErrMsg: string): Boolean;
var
  Prop: TRttiProperty;
  Field: TRttiField;
  v: TValue;
  Obj: TObject;
  ValueOut: TValue;
begin
  result := False;

  Prop := ParentType.GetProperty(AttrName);
  if Prop <> nil then
    try
      if Ord(Prop.Visibility) < Ord(mvPublic) then
        ErrMsg := rs_NoAccess
      else if not Prop.IsWritable then
        ErrMsg := rs_NotWritable
      else if Prop.PropertyType = nil then
        ErrMsg := rs_ErrNoTypeInfo
      else
        case Prop.PropertyType.TypeKind of
          tkClass:
            // if ValidateClassPropertys(Value__, Prop.PropertyType.Handle, Obj) then
            begin
              Prop.SetValue(ParentAddr, Obj);
              result := True;
            end;
          (* tkInterface:
            if ValidateInterfaceProperty(Value__,
            Prop.PropertyType as TRttiInterfaceType, ValueOut, ErrMsg) then
            begin
            Prop.SetValue(ParentAddr, ValueOut);
            Result := True;
            end;
            tkRecord:
            if ValidateRecordProperty(Value_, Prop.PropertyType.Handle,
            ValueOut, ErrMsg) then
            begin
            Prop.SetValue(ParentAddr, ValueOut);
            Result := True;
            end;
            tkMethod:
            if Prop.Visibility = mvPublished then
            Result := PyDelphiWrapper_.EventHandlers.Link(TObject(ParentAddr),
            (Prop as TRttiInstanceProperty).PropInfo, Value_, ErrMsg)
            else
            ErrMsg := rs_NotPublished; *)
        else
          begin
            result := SimplePythonToValues(Value__, Prop.PropertyType.Handle,
              v, ErrMsg);
            if result then
              Prop.SetValue(ParentAddr, v);
          end;
        end;
    except
      on E: Exception do
      begin
        result := False;
        ErrMsg := E.Message;
      end;
    end
  else
  begin
    Field := ParentType.GetField(AttrName);
    if Field <> nil then
      try
        if Ord(Field.Visibility) < Ord(mvPublic) then
          ErrMsg := rs_NoAccess
        else if Field.FieldType = nil then
          ErrMsg := rs_ErrNoTypeInfo
        else
          case Field.FieldType.TypeKind of
            tkClass:
              // if ValidateClassPropertys(Value__, Prop.PropertyType.Handle, Obj) then
              begin
                Prop.SetValue(ParentAddr, Obj);
                result := True;
              end;
            (* tkInterface:
              if ValidateInterfaceProperty(Value_,
              Field.FieldType as TRttiInterfaceType, ValueOut, ErrMsg) then
              begin
              Field.SetValue(ParentAddr, ValueOut);
              Result := True;
              end; *)
            tkRecord:
              // if ValidateRecordPropertys(Value__, Field.FieldType.Handle,
              // ValueOut, ErrMsg) then
              begin
                Field.SetValue(ParentAddr, ValueOut);
                result := True;
              end;
          else
            begin
              result := SimplePythonToValues(Value__, Field.FieldType.Handle,
                v, ErrMsg);
              if result then
                Field.SetValue(ParentAddr, v);
            end;
          end;
      except
        on E: Exception do
        begin
          result := False;
          ErrMsg := E.Message;
        end;
      end
  end;
end;

// To keep the RTTI Pool alive and avoid continuously creating/destroying it
// See also https://stackoverflow.com/questions/27368556/trtticontext-multi-thread-issue
Var
  _RttiContext: TRttiContext;

procedure _InitRttiPool;
begin
  _RttiContext := TRttiContext.Create;
  _RttiContext.FindType('');
end;

{ TPyRttiObject }

function TMixRtti.RunRecord(const request: TScriptRequest): TScriptResponse;
var
  // mix: TMixRtti;
  param: Variant;
  v: Variant;
  met: String;
begin
  if ParentAddress <> nil then
  begin
    param := request.SerialVariant(met);

    v := CallMethod(met, param);
    if v = null then
    begin
      result.Init('');
    end
    else
    begin
      result.Init(v);
    end;
  end
  else
  begin
    result.Init('');
  end;

end;

procedure TMixRtti.Init(const fA: Pointer; const fRtt: TRttiStructuredType);
// override;
begin
  fAddr := fA;
  fRttiType := fRtt;
end;

// function SetAttrO_(key: string; const Value: Variant): Integer; //override;

function TMixRtti.GetAttrO(key: string): Variant;
var
  KeyName: string;
  ErrMsg: string;
begin
  result := null;
  KeyName := key;
  if (fAddr = nil) then
  begin
    Exit;
  end;

  if Assigned(RttiType) then
    result := GetRttiAttrs(fAddr, RttiType, KeyName, ErrMsg);
  (* if result=null then
    with GetPythonEngine do
    PyErr_SetObject(PyExc_AttributeError^,
    PyUnicodeFromString(Format(rs_ErrAttrGet, [KeyName, ErrMsg]))); *)
end;

function TMixRtti.SetAttrO_(key: string; const Value: Variant): Integer;
// override;

var
  KeyName: string;
  ErrMsg: string;
begin
  result := -1;
  KeyName := key;

  if SetRttiAttrs(fAddr, RttiType, KeyName, Value, ErrMsg) then
    result := 0;
end;

procedure TMixRtti.SetAddrAndType(Address: Pointer; Typ: TRttiStructuredType);
begin

  fAddr := Address;
  Assert(Assigned(Typ));
  Assert((Typ is TRttiRecordType) or (Typ is TRttiInterfaceType));
  fRttiType := Typ;
end;

{ TPyPascalRecord }

function TMixRtti.GetValue: TValue;
begin
  TValue.Make(fAddr, RttiType.Handle, result);
end;

function TMixRtti.CallMethod(const MethName_: String; const Paramsv: Variant)
  : Variant; // override;

var
  args: array of TValue;

  function FindMethod_(const MethName: string; RttiType: TRttiType)
    : TRttiMethod;
  // Deals with overloaded methods
  // Constructs the Arg Array
  // PyArgs is a Python tuple
  Var
    Method: TRttiMethod;
    Index: Integer;
    ErrMsg: string;
    Obj: TObject;
    ClassRef: TClass;
    // PyValue_: PPyObject;
    param: TRttiParameter;
    Params: TArray<TRttiParameter>;
    SearchContinue: Boolean;
    mivalue: Variant;
  begin
    result := nil;
    for Method in RttiType.GetMethods do
      if SameText(Method.name, MethName) then
      begin
        Params := Method.GetParameters;
        SetLength(args, Length(Params));
        if Length(args) = Length(Params) then
        begin
          result := Method;
          SearchContinue := False;
          for Index := 0 to Length(Params) - 1 do
          begin
            param := Params[Index];
            if (param.ParamType = nil) or
              (param.Flags * [TParamFlag.pfVar, TParamFlag.pfOut] <> []) then
            begin
              result := nil;
              SearchContinue := True;
              Break;
            end;
            mivalue := Paramsv[index];

            // PyValue := PythonType.Engine___.PyTuple_GetItem(PyArgs, Index);
            if param.ParamType = nil then
            begin
              result := nil;
              Break
            end

            else if param.ParamType.TypeKind = tkClass then
            begin
              // if ValidateClassPropertys(mivalue, Param.ParamType.Handle, Obj) then
              args[Index] := Obj
              (* else
                begin
                Result := nil;
                Break
                end *)
            end
            (*
              else if (Param.ParamType.TypeKind = tkClassRef) then
              begin
              if ValidateClassRef_(PyValue, Param.ParamType.Handle, ClassRef,
              ErrMsg) then
              args[Index] := ClassRef
              else
              begin
              Result := nil;
              Break
              end
              end
              else if (Param.ParamType.TypeKind = tkDynArray) and
              PythonType.Engine___.PyList_Check(PyValue) then
              begin
              if ParamAsDynArray__(PyValue, Param, args[Index]) then
              Continue; // to avoid last check
              end *)
            else
            begin
              if not SimplePythonToValues(mivalue, param.ParamType.Handle,
                args[Index], ErrMsg) then
              begin
                result := nil;
                Break
              end;
            end;

            if (param.ParamType <> nil) and not args[Index]
              .IsType(param.ParamType.Handle) then
            begin
              result := nil;
              Break;
            end;
          end; // for params

          if not SearchContinue then
            Break;
        end;
      end;
  end;

Var
  ArgCount: Integer;
  Meth: TRttiMethod;
  ret: TValue;
  ErrMsg: string;
  Addr: TValue;
  Obj: TObject;

begin
  result := null;
  // Ignore keyword arguments ob2
  // ob1 is a tuple with zero or more elements

  // ArgCount := PythonType.Engine___.PyTuple_Size(ob1);
  // SetLength(args, ArgCount);

  Meth := FindMethod_(MethName_, ParentRtti);

  if not Assigned(Meth) then
  begin

    Exit;
  end;

  try
    Obj := TObject(ParentAddress);
    if ParentRtti is TRttiInstanceType then
      if Meth.IsClassMethod then
        Addr := TValue.From(TObject(ParentAddress).ClassType)
      else
        Addr := TValue.From(TObject(ParentAddress))
    else if ParentRtti is TRttiInterfaceType then
      TValue.Make(@ParentAddress, ParentRtti.Handle, Addr)
    else
      Addr := TValue.From(ParentAddress);
    ret := Meth.Invoke(Addr, args);
    if ret.IsEmpty then
      result := null
    else if ret.Kind = tkClass then
    begin
      Obj := TObject(ParentAddress);
      // AOwnerships := soReference;
      result := ret.AsVariant
      // fDelphiWrapper.Wrap(ret.AsObject, AOwnerships)
    end
    else
    begin
      result := ret.AsVariant
      (* if Result = nil then
        with PythonType.Engine___ do
        PyErr_SetObject(PyExc_TypeError__^,
        PyUnicodeFromString(Format(rs_ErrInvalidRet, [MethName, ErrMsg]))); *)
    end;
  except
    on E: Exception do
    begin
      result := null;

    end;
  end;
end;

function DumpRttiRecord(const fRtt: TRttiStructuredType;
  contexto: Pointer): string;
begin
  result := '';
  if contexto <> nil then
    if fRtt <> nil then
    begin
      result := fRtt.name;
      // result.init_(PTestRecordExample(contexto).SimpleList())
    end
end;


function RunRecord(const request: TScriptRequest; contexto: Pointer)
  : TScriptResponse;
begin
  if contexto <> nil then
  begin
    result.Init(PTestRecordExample__(contexto).SimpleList())
  end
  else
  begin
    result.Init('');
  end;

end;

function CreateTResponserSimple(test: PTestRecordExample__): TCommandReqResArray;
begin
  result.Inits;
  result.Add('Hello', RunRecord, test);
  result.Add('hello', RunRecord, test);
end;

(*
Procedure TestSampleRecord;
var
  request: TScriptRequest;
  fRtt: TRttiStructuredType;
  contexto: Pointer;
  respon: TScriptResponse;
  sample: TTestRecordExample;
begin
  sample.Init;
  contexto := Addr(sample);
  fRtt := TRttiContext.Create.GetType(TypeInfo(TTestRecordExample))
    as TRttiStructuredType;
  if contexto <> nil then
  begin
    request.Init('count_primes 100');

    respon := RunSampleRecord(request, fRtt, contexto);
    writeln(respon.respon);
    request.Init('Makelist 100');
    respon := RunSampleRecord(request, fRtt, contexto);
    writeln(respon.respon);

  end
  else
  begin
    respon.Init('');
  end;

end;
*)

initialization

_InitRttiPool;

finalization

_RttiContext.Free();

end.
