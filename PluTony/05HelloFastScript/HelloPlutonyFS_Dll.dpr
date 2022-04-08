library HelloPlutonyFS_Dll;

uses
  SysUtils,
  Classes,
  PythonEngine,
  PluTony_Python_Classes,
  PluTony_Py_ZMQ,
  PluTony_Zero_FastScript in '..\PluTony_Zero_FastScript.pas';

function PyInit_HelloPlutonyFS_Dll: PPyObject;
begin
  Result := PluTony_.PyInit_PluTony_dll_;
  // PluTonyExtension.RegisterElisaWrapper;
end;

exports
  // initdatabase,
  PyInit_HelloPlutonyFS_Dll;
{$E pyd}

begin

end.
