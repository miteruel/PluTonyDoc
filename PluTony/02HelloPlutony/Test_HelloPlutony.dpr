program Test_HelloPlutony;

{$APPTYPE CONSOLE}

uses
  Monadas_Pascal in '..\Monadas_Pascal.pas',
  Plutony_SynTest in '..\Plutony_SynTest.pas',
  Test_Basic_Jupyter in '..\Test_Basic_Jupyter.pas',
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas';



begin
(*
  propyhello.py is a very simple unit
*)
  mainScript:= 'propyhello.py'; // 'proTonyZMQ.py';

  MainTestCase:=[  TTestMonaPython];

  AutoTest_Plutony;
end.



