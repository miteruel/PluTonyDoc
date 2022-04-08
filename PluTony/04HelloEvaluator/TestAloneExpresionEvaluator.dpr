program TestAloneExpresionEvaluator;

{$APPTYPE CONSOLE}

uses
  Test_Expression,
  PluTony_Zero_Expresion,
  Plutony_SynTest in '..\Plutony_SynTest.pas';



begin
  MainTestCase:=[ TTestMonaExpression];
  // serve:=TestServe;

  // TestDataBase;
  // MakeHash;
  // TestInflateDeflateZip();
  AutoTest_Plutony;
 // AutoTest_Monadas;
  // ToMMUninstall;

  // SaveProfile_;
end.


