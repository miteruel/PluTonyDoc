library HelloPlutonyZQM_Dll;

uses
//  SysUtils,
//  Classes,
  PythonEngine,
  PluTony_Py_ZMQ ,
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas';



function PyInit_HelloPlutonyZQM_Dll: PPyObject;
begin
  Result := PluTony_.PyInit_PluTony_dll_;
end;

exports
  // This is then only one object shared,
  PyInit_HelloPlutonyZQM_Dll;
// is for custom dll extension for python .pyd
{$E pyd}

begin

end.
