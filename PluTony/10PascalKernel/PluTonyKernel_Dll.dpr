library PluTonyKernel_Dll;
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



{$I ..\plutonidef.inc}

uses
  PluTony_Runtime_App,
  PythonEngine,
  WrapDelphi,
  {$IFDEF COMPACMODE}
  Monadas_Pascal,
  {$ELSE}
  monada_abstract,
  Todo_IScript in '..\Todo_IScript.pas',
  {$ENDIF }
  {$IFDEF PLUTONY_DWS}
  {$ENDIF }
  {$IFDEF PLUTONY_REM}
  Plutony_Zero_RemScript in '..\Plutony_Zero_RemScript.pas',
  {$ENDIF }
  Test_ZMQ in '..\Test_ZMQ.pas',
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas',
  PluTony_Py_ZMQ in '..\PluTony_Py_ZMQ.pas',
 // PluTony_Xml,
  Plutony_SynTest in '..\Plutony_SynTest.pas',
  Test_Basic_Jupyter in '..\Test_Basic_Jupyter.pas',
  Classes,
  PluTony_Zero_Brokers in '..\PluTony_Zero_Brokers.pas',
  {$IFDEF ZMQ_NORIGINAL}
  PluTony_Zero_GrijjyProtocol2006 in '..\zero2006\PluTony_Zero_GrijjyProtocol2006.pas',
  {$ELSE}
  {$ENDIF }
  {$IFDEF PLUTONY_FASTSCRIPT}
  PluTony_Zero_FastScript,
  {$ENDIF }
  {$IFDEF PLUTONY_EXPRESSION}
  PluTony_Zero_Expresion,
  {$ENDIF }
  {$IFDEF PLUTONY_DWS}
  Plutony_Zero_DWS,
  {$ENDIF }
  SysUtils;

function PyInit_PluTonyKernel_Dll: PPyObject;
begin

{$IFDEF PLUTONY_DWS}
  RunAppExample.SetInjector(InjectScriptDws);
//  RunAppExample.funInjectorScript := InjectScriptDws;
{$ELSE}
  RunAppExample.SetInjector(InjectSimpleFastScript);
  ///RunAppExample.funInjectorScript := InjectSimpleFastScript;
{$ENDIF }
  Result := PluTony_.PyInit_PluTony_dll_;
end;

exports
  PyInit_PluTonyKernel_Dll;

{$E pyd}

begin

end.
