program TestJupyterExpresionEvaluator;

{$APPTYPE CONSOLE}
{$i incspynET}
{ %TogetherDiagram 'ModelSupport_TestTodoJargonOnly\default.txaPackage' }

uses
  Classes,
  PythonEngine,
  WrapDelphi,
  Test_Expression,
  Plutony_SynTest in '..\Plutony_SynTest.pas',
  Test_Basic_Jupyter in '..\Test_Basic_Jupyter.pas',
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas',
  PluTony_Py_ZMQ in '..\PluTony_Py_ZMQ.pas';

begin
  MainTestCase := [TTestMonaExpression, TTestMonaPython];
  // serve:=TestServe;

  // TestDataBase;
  // MakeHash;
  // TestInflateDeflateZip();
  AutoTest_Plutony;
  // AutoTest_Monadas;
  // ToMMUninstall;

  // SaveProfile_;
end.
