library HelloPlutony_Dll;



uses

  PluTony_Runtime_App in '..\PluTony_Runtime_App.pas',
  PythonEngine,
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas',
  Monadas_Pascal in '..\Monadas_Pascal.pas';

function PyInit_HelloPlutony_Dll: PPyObject;
begin
  Result := PluTony_.PyInit_PluTony_dll_;
end;

exports
  // This is then only one object shared,
  PyInit_HelloPlutony_Dll;
  // is for custom dll extension for python .pyd
  {$E pyd}
begin

end.




