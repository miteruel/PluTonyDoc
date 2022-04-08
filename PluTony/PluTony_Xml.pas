unit PluTony_Xml;

interface

//{$I incspynET}
{$I plutonidef.inc}
{$IFDEF COMPACMODE}

uses

  WrapDelphi,

  PythonEngine,
  ToDo_Xml_Delphi,
//  Monada_System,
  Monadas_Pascal;

{$ELSE}

uses
  UtilCsv,

  WrapDelphi,
  TodoString,

  PythonEngine,
  dxobject;
{$ENDIF}
// {$I ..\Definition.Inc}

type
  (* IPyPlutoniXMLs = interface
    function Get_toXml(): PPyObject; cdecl;
    procedure set_toXml(const avalue: PPyObject); cdecl;
    property toXml: PPyObject read Get_toXml write set_toXml; // cdecl;
    end;
  *)
  TPyPlutoniXML = class(TPyDelphiObject) // , IPyPlutoniXMLs)

  private
    function GetDelphiObject: TXML;
    procedure SetDelphiObject(const Value: TXML);
  protected

    function Get_Controls(AContext: Pointer): PPyObject; cdecl;
    function Get_toXml(): PPyObject; cdecl;
    procedure set_toXml(const avalue: PPyObject); cdecl;

    // Property Getters
    function Get_Parent(AContext: Pointer): PPyObject; cdecl;
    function Get_Attributes(AContext: Pointer): PPyObject; cdecl;

    // Property Setters
    function Set_Parent(avalue: PPyObject; AContext: Pointer): integer; cdecl;
    function ToCSV(args: PPyObject): PPyObject; cdecl;
  public
    constructor Create(APythonType: TPythonType); override;
    constructor CreateWith(PythonType: TPythonType; args: PPyObject); override;
    destructor Destroy; override;
    class function GetContainerAccessClass: TContainerAccessClass; override;
    class procedure SetupType(PythonType: TPythonType); override;
    function GetAttrO(key: PPyObject): PPyObject; override;

    function SqAssItem(idx: NativeInt; obj: PPyObject): integer; override;

    // Class methods
    class procedure RegisterMethods(PythonType: TPythonType); override;

    // Exposed methods
    function add_(args: PPyObject): PPyObject; cdecl;

    class function DelphiObjectClass: TClass; override;
    class procedure RegisterGetSets(PythonType: TPythonType); override;
    // class procedure RegisterMethods( PythonType : TPythonType ); override;
    // Properties
    property XMLObject: TXML read GetDelphiObject write SetDelphiObject;

  end;

  {
    Access to the child controls of a TWinControl.Controls collection.
  }
  TpluXMLControlsAccess = class(TContainerAccess)
  private
    function GetContainer: TXML;
  public
    function GetItem(AIndex: integer): PPyObject; override;
    function GetSize: integer; override;
    function IndexOf(avalue: PPyObject): integer; override;

    class function ExpectedContainerClass: TClass; override;
    class function SupportsIndexOf: Boolean; override;
    class function Name: string; override;

    property Container: TXML read GetContainer;
  end;

  TPluTonyRegistrationXml = class(TRegisteredUnit)
  public
    function Name: string; override;
    procedure RegisterWrappers(APyDelphiWrapper: TPyDelphiWrapper); override;
    procedure DefineVars(APyDelphiWrapper: TPyDelphiWrapper); override;
    procedure DefineFunctions(APyDelphiWrapper: TPyDelphiWrapper); override;
    function GetXmlPlutoni(pself, args: PPyObject): PPyObject; cdecl;
    function Getnolose(pself, args: PPyObject): PPyObject; cdecl;


  end;

implementation

uses
  SysUtils,

//  PluTony_classes,
  PluTony_Python_Classes,
  ToDo_Xml_Reader;


constructor TPyPlutoniXML.Create(APythonType: TPythonType);
begin
  inherited Create(APythonType);
  // TipoIterator_    :=TipoPyXMLIterator;
  // nonil:=false;

end;

class function TPyPlutoniXML.GetContainerAccessClass: TContainerAccessClass;
begin
  Result := TpluXMLControlsAccess;
end;

function TPyPlutoniXML.add_(args: PPyObject): PPyObject;
var
  _obj: PPyObject;
begin
  with GetPythonEngine do
  begin
    // We adjust the transmitted self argument
    Adjust(@Self);

    if PyArg_ParseTuple(args, 'O:add', @_obj) <> 0 then
    begin
      // Result := PyLong_FromLong(XMLObject.AddX(TPyPlutoniXML(_obj).XMLObject));
    end
    else
    begin

    end;

    Result := nil;
  end;
end;

constructor TPyPlutoniXML.CreateWith(PythonType: TPythonType; args: PPyObject);
var
  // ?  i: integer;
  FVal: PPyObject;
begin
  inherited;
  with GetPythonEngine do
  begin
    FVal := PyTuple_GetItem(args, 0);

    set_toXml(FVal);
    (* for i := 0 to PyTuple_Size(args)-1 do
      begin
      Strings.Add(PyObjectAsString(PyTuple_GetItem(args, i)));
      end; *)
  end;
end;

class procedure TPyPlutoniXML.SetupType(PythonType: TPythonType);
begin
  inherited;
  PythonType.TypeName := 'PyDelphiXml';
  PythonType.Services.Basic := [bsRepr, bsStr, bsGetAttrO, bsSetAttrO, bsIter];
  PythonType.Services.Sequence := [ssLength, ssItem, ssAssItem];
  PythonType.TypeFlags := [tpfBaseType, tpHaveVersionTag];

  // PythonType.Services.Mapping  := PythonType.Services.Mapping  + [msLength, msSubscript];
end;

function TPyPlutoniXML.SqAssItem(idx: NativeInt; obj: PPyObject): integer;
begin
  with GetPythonEngine do
  begin
    if idx < SqLength then
    begin
      // Strings[idx] := PyObjectAsString(obj);
      Result := 0;
    end
    else
    begin
      PyErr_SetString(PyExc_IndexError^, 'list index out of range');
      Result := -1;
    end;
  end;
end;

function TPyPlutoniXML.ToCSV(args: PPyObject): PPyObject;
var
  x: TXStringList;
begin
  with GetPythonEngine do
  begin

    Adjust(@Self);
    x := ExportaXML2Csv(GetDelphiObject);
    Result := Wrap(x);
  end;
end;

{ Register the wrappers, the globals and the constants }

{ TPluTonyRegistrationXml }

procedure TPluTonyRegistrationXml.DefineVars(APyDelphiWrapper
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

function TPluTonyRegistrationXml.Name: string;
begin
  Result := 'regplutonxml';
end;

function TPluTonyRegistrationXml.GetXmlPlutoni(pself, args: PPyObject): PPyObject; cdecl;
var
  fina: pansichar;
  x: TXML;
begin
  // FreeConsole;

  Result := nil;
  // CheckEngine;
  with GetPythonEngine do
  begin
    if PyArg_ParseTuple(args, 's:FileXml', @fina) <> 0 then
    begin
      try
        // Adjust(pself);
        x := LoadXmlXit(fina);
        Result := PluTony_.gXmlWrap__.Wrap(x, soOwned);

        // result:=GetPythonEngine.
      finally

      end;
    end;
    // Result := GetPythonEngine.ReturnNone;
  end;

end;


function TPluTonyRegistrationXml.Getnolose(pself, args: PPyObject): PPyObject; cdecl;
begin
  // FreeConsole;

  Result := nil;
  // CheckEngine;
  with GetPythonEngine do
  begin

        Result := nil

  end;

end;



procedure TPluTonyRegistrationXml.DefineFunctions(APyDelphiWrapper
  : TPyDelphiWrapper);
begin
  inherited;

    APyDelphiWrapper.RegisterFunction(pansichar('fileXml'), GetXmlPlutoni,
    pansichar('fileXml(s)'#10 + 'fileXml.'));

end;

procedure TPluTonyRegistrationXml.RegisterWrappers(APyDelphiWrapper
  : TPyDelphiWrapper);
begin
  inherited;
  // with APyDelphiWrapper.RegisterDelphiWrapper(TPyPlutoniXML) do
  APyDelphiWrapper.RegisterDelphiWrapper(TPyPlutoniXML);



end;

{ TPyDelphiControl }

class function TPyPlutoniXML.DelphiObjectClass: TClass;
begin
  Result := TXML;
end;

function TPyPlutoniXML.GetDelphiObject: TXML;
begin
  Result := TXML(inherited DelphiObject);
end;

function TPyPlutoniXML.Get_Attributes(AContext: Pointer): PPyObject;
begin
  Adjust(@Self);
  Result := Wrap(XMLObject.Attributes);
end;

function TPyPlutoniXML.Get_Parent(AContext: Pointer): PPyObject;
begin
  Adjust(@Self);
  Result := Wrap(TXML(XMLObject.ParentNode));
end;

function TPyPlutoniXML.Get_toXml: PPyObject;
var
  x: TXML;
begin
  Adjust(@Self);

  Result := nil;
  x := GetDelphiObject;
  if x <> nil then
  begin
    Result := GetPythonEngine.PyUnicodeFromString(x.toXml)
  end;

end;

function TPyPlutoniXML.Get_Controls(AContext: Pointer): PPyObject;
begin
  Adjust(@Self);
  Result := Self.PyDelphiWrapper.DefaultContainerType.CreateInstance;
  with PythonToDelphi(Result) as TPyDelphiContainer do
    Setup(Self.PyDelphiWrapper,
      TpluXMLControlsAccess.Create(Self.PyDelphiWrapper, Self.DelphiObject));
end;

function TPyPlutoniXML.GetAttrO(key: PPyObject): PPyObject;
var
  l_sUpperKey: string;
  l_oDataset: TXML;
begin
  with GetPythonEngine do
  begin
    try
      l_oDataset := XMLObject;
      l_sUpperKey := UpperCase(PyObjectAsString(key));
      (* if l_sUpperKey = 'BOF' then
        Result := VariantAsPyObject( l_oDataset.BOF )
        else if l_sUpperKey = 'CANMODIFY' then
        Result := VariantAsPyObject( l_oDataset.CanModify )
        else if l_sUpperKey = 'EOF' then
        Result := VariantAsPyObject( l_oDataset.EOF )
        else if l_sUpperKey = 'FIELDCOUNT'  then
        Result := VariantAsPyObject( l_oDataset.FieldCount )
      *)
      (* if l_sUpperKey = 'ATTRIBUTE'  then
        Result := Wrap(TXML(XMLObject.Attributes))
        //        Result :=Get_Attributes(nil)
        // VariantAsPyObject( l_oDataset.RecNo )
        else *)
      Result := inherited GetAttrO(key);
    except
      on E: Exception do
      begin
        // RaiseDBError( E );
        Result := Nil;
      end;
    end;
  end;
end;

class procedure TPyPlutoniXML.RegisterGetSets(PythonType: TPythonType);
begin
  inherited;
  PythonType.AddGetSet('ToXmls', @TPyPlutoniXML.Get_toXml,
    @TPyPlutoniXML.set_toXml, 'Returns/Sets the Control Parent', nil);
  PythonType.AddGetSet('Attribute', @TPyPlutoniXML.Get_Attributes, nil,
    'Returns atributes', nil);

  PythonType.AddGetSet('Parent', @TPyPlutoniXML.Get_Parent,
    @TPyPlutoniXML.Set_Parent, 'Returns/Sets the Control Parent', nil);
  PythonType.AddGetSet('Controls', @TPyPlutoniXML.Get_Controls, nil,
    'Returns an iterat or over contained controls', nil);

end;

class procedure TPyPlutoniXML.RegisterMethods(PythonType: TPythonType);
begin
  inherited;
  (*
    PythonType.AddMethod('Show', @TPyPlutoniXML.Show_Wrapper,
    'TControl.Show()'#10 + 'Shows the wrapped Control');
    PythonType.AddMethod('Hide', @TPyDelphiControl.Hide_Wrapper,
    'TControl.Hide()'#10 +
    'Hides the wrapped Control');
    PythonType.AddMethod('SendToBack', @TPyPlutoniXML.SendToBack_Wrapper,
    'TControl.SendToBack()'#10 +
    'Puts a windowed control behind all other windowed controls, or puts a non-windowed control behind all other non-windowed controls.');

    PythonType.AddMethod('Update', @TPyPlutoniXML.Update_Wrapper,
    'TControl.Update()'#10 +
    'Processes any pending paint messages immediately.');
  *)

  with PythonType do
  begin

    AddMethod('CSV', @TPyPlutoniXML.ToCSV, 'to csv convert');

    AddMethod('add', @TPyPlutoniXML.add_,
      'add a new item to the list and returns the index position');
  end;
  (*
    PythonType.AddMethod('SetBounds', @TPyPlutoniXML.SetBounds_Wrapper,
    'TControl.SetBounds(Left, Top, Width, Height)'#10 +
    'Sets the Left, Top, Width, and Height properties all at once.');
    (*  PythonType.AddMethod('Invalidate', @TPyDelphiControl.Invalidate_Wrapper,
    'TControl.Invalidate()'#10 +
    'Completely repaint control.');

    PythonType.AddMethod('Repaint', @TPyPlutoniXML.Repaint_Wrapper,
    'TControl.Repaint()'#10 +
    'Forces the control to repaint its image on the screen. ');


    PythonType.AddMethod('ScreenToClient', @TPyPlutoniXML.ScreenToClient_Wrapper,
    'TControl.ScreenToClient()'#10 +
    'Converts the screen coordinates of a specified point on the screen to client coordinates.');
  *)
end;

procedure TPyPlutoniXML.SetDelphiObject(const Value: TXML);
begin
  inherited DelphiObject := Value;
end;

function TPyPlutoniXML.Set_Parent(avalue: PPyObject; AContext: Pointer)
  : integer;
var
  _object: TObject;
begin
  Adjust(@Self);
  if CheckObjAttribute(avalue, 'Parent', TXML, _object) then
  begin
    Self.XMLObject.SetParent(TXML(_object));
    Result := 0;
  end
  else
    Result := -1;
end;

procedure TPyPlutoniXML.set_toXml(const avalue: PPyObject);
var
  x: TXML;
  s: String;
begin
  s := GetPythonEngine.PyObjectAsString(avalue);
  x := String2Xml(s);
  SetDelphiObject(x);
  Owned := true;

end;

{ TpluXMLControlsAccess }

class function TpluXMLControlsAccess.ExpectedContainerClass: TClass;
begin
  Result := TXML;
end;

function TpluXMLControlsAccess.GetContainer: TXML;
begin
  Result := TXML(inherited Container);
end;

function TpluXMLControlsAccess.GetItem(AIndex: integer): PPyObject;
begin
  Result := Wrap(Container[AIndex]);
end;

function TpluXMLControlsAccess.GetSize: integer;
begin
  Result := Container.CountNodes_;
end;

function TpluXMLControlsAccess.IndexOf(avalue: PPyObject): integer;
var
  i: integer;
  s: string;
  _obj: TPyObject;
  _value: TObject;
  _ctrl: TXML;
begin
  Result := -1;
  with GetPythonEngine do
  begin
    if PyUnicode_Check(avalue) then
    begin
      s := PyUnicodeAsString(avalue);
      for i := 0 to Container.CountNodes_ - 1 do
        if SameText(Container[i].Name, s) then
        begin
          Result := i;
          Break;
        end;
    end
    else if IsDelphiObject(avalue) then
    begin
      _obj := PythonToDelphi(avalue);
      if _obj is TPyDelphiObject then
      begin
        _value := TPyDelphiObject(_obj).DelphiObject;
        if _value is TXML then
        begin
          _ctrl := TXML(_value);
          for i := 0 to Container.CountNodes_ - 1 do
            if Container[i] = _ctrl then
            begin
              Result := i;
              Break;
            end;
        end;
      end;
    end;
  end;
end;

class function TpluXMLControlsAccess.Name: string;
begin
  Result := 'XMLS';
end;

class function TpluXMLControlsAccess.SupportsIndexOf: Boolean;
begin
  Result := true;
end;

destructor TPyPlutoniXML.Destroy;
begin
  // if nonil then
  begin
    // ?  Freenil (fStrings) //Free;
  end;
  inherited;
end;

{ Global Functions }

initialization

RegisteredUnits.Add(TPluTonyRegistrationXml.Create);

end

