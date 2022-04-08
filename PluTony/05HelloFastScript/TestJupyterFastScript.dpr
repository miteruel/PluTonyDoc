program TestJupyterFastScript;

{$APPTYPE CONSOLE}

uses
 // Classes,
 // Math,
 // SysUtils,
  PythonEngine,
  WrapDelphi,
  Monadas_Pascal,
  Test_ZMQ in '..\Test_ZMQ.pas',
  PluTony_Zero_FastScript,
  PluTony_Zero_Brokers,
  PluTony_Py_ZMQ ,
  Plutony_SynTest in '..\Plutony_SynTest.pas',
  Test_Basic_Jupyter in '..\Test_Basic_Jupyter.pas',
  PluTony_Python_Classes in '..\PluTony_Python_Classes.pas';

begin
  modoconsole:=true;
  KFunInjectorTest_ := [@InjectSimpleFastScript];

  MainTestCase:=[ //TTestScriptsFS,
  TTestMonaPython,TTestMonaZMQs];
  // serve:=TestServe;

  // TestDataBase;
  // MakeHash;
  // TestInflateDeflateZip();
  AutoTest_Plutony;

end.



 0001:0017A0D0 000005DC C=CODE     S=.text    G=(none)   M=Plutony_SynTest ACBP=A9

 0001:0017A6AC 00004CC0 C=CODE     S=.text    G=(none)   M=Monada_System ACBP=A9
 0001:0017F36C 000070C4 C=CODE     S=.text    G=(none)   M=ToDo_Monada_Abstract ACBP=A9

 0001:00186430 0000176C C=CODE     S=.text    G=(none)   M=PluTony_Classes ACBP=A9

 0001:00187B9C 000003B4 C=CODE     S=.text    G=(none)   M=Test_Basic_Jupyter ACBP=A9


 0001:0018E814 00001740 C=CODE     S=.text    G=(none)   M=Todo_IScript ACBP=A9
 0001:0018FF54 000015D4 C=CODE     S=.text    G=(none)   M=Mono_ZMQ ACBP=A9
 0001:00191528 000022E8 C=CODE     S=.text    G=(none)   M=PluTony_ZMQ ACBP=A9
 0001:00193810 000006F4 C=CODE     S=.text    G=(none)   M=PluTony_Runtime_Example ACBP=A9
 0001:00193F04 000007CC C=CODE     S=.text    G=(none)   M=Test_ZMQ ACBP=A9



 0001:001BA8A8 00000458 C=CODE     S=.text    G=(none)   M=Test_Basic_Script_FS ACBP=A9

 0001:001C08F4 00001ED4 C=CODE     S=.text    G=(none)   M=PluTony_String ACBP=A9
 0001:001C27C8 00003524 C=CODE     S=.text    G=(none)   M=PluTony_System ACBP=A9
 0001:001C5CEC 00000438 C=CODE     S=.text    G=(none)   M=Mono_FastScript ACBP=A9
 0001:001C6124 000048D8 C=CODE     S=.text    G=(none)   M=TestJupyterFastScript ACBP=A9


 ToDo_Hash_CountMax

 multinifile
 Midbcontrol
 ToDo_Duerme
 Todo_Thread

   Damaelisa in 'T:\d2009\Forms2006xe\elisa2021\Damaelisa.pas',
  Elisa_Test_Base in 'T:\d2009\elisa\tests\Elisa_Test_Base.pas',
ToDo_Hash_CountMax

gpobjects

  SGT.Parser.ZToken in '..\tools\Expression-evaluator-master\SGT.Parser.ZToken.pas',
  SGT.Parser.ZParser in '..\tools\Expression-evaluator-master\SGT.Parser.ZParser.pas',
  SGT.Parser.ZMatch in '..\tools\Expression-evaluator-master\SGT.Parser.ZMatch.pas',
  SGT.Parser.ZFunctions in '..\tools\Expression-evaluator-master\SGT.Parser.ZFunctions.pas',

  Patos_Config

  ToDo_MixValue


  VariantAsMormot

  fs_xml

  ToDo_Log_User


