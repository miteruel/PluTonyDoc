unit Test_Monada_PluTony;

{$i incspynET}

interface

// implementation end.

{$IFDEF FPC}
{$MODE Delphi}
{$ELSE}
{$DEFINE OtrasXml}
{$ENDIF}
{$I incspynET.pas}
{$IFDEF xe5}
{$UNDEF OtrasXml}
{$ENDIF}
{$UNDEF OtrasXml}

uses

  // Test_Jargon_Base,
  SynTests,
  //
  // ToDoAbstract,
  Monada_Abstract;

procedure AutoTest_Monadas;

type

  TTestSuitMonada = class(TSynTestsLogged)
  published
    procedure MyTestSuit;
  end;

implementation

uses


  plutony_module,
  Monada_File,
  ToDo_Exe,
  TodoString,
  UniTest_MiSynTest,
  PythonEngine,
  WrapDelphi, Dialogs, Controls,

  SysUtils;

type
  TPythonEngineHelper = class helper for TPythonEngine
    procedure ExecxStrings(strings: TxStringList);
  end;

procedure TPythonEngineHelper.ExecxStrings(strings: TxStringList);
begin
  Py_XDecRef(Run_CommandAsObject(EncodeString(strings.Text), file_input));
end;

procedure AutoTest_Monadas;
begin

  with TTestSuitMonada.Create do
    try
      Run;
      readln;
    finally
      Free;
    end;
end;

type
  TTestMonaPython = class(TTestMiXmlCase)
  public
    constructor Create(Owner: TSynTests; const Ident_: String = ''); override;
    destructor Destroy; override;
  published
    procedure runPython;
  private
    io: TPythonInputOutput;
    procedure PythonInputOutput1SendData(Sender: TObject;
      const Data: AnsiString);

  end;

destructor TTestMonaPython.Destroy;
begin
  Freenil(io);
  inherited Destroy;
end;

constructor TTestMonaPython.Create(Owner: TSynTests; const Ident_: String);
begin
  inherited;
  io := TPythonInputOutput.Create(nil);
  io.OnSendData := PythonInputOutput1SendData;
end;

procedure TTestMonaPython.PythonInputOutput1SendData(Sender: TObject;
  const Data: AnsiString);
begin
  WriteLn(Data);
end;

procedure TTestMonaPython.runPython;
var
  en: TPythonEngine;
  fI: TMonaFile;
begin
  fI := ExeVer / 'protony1.py';

  // ? CaptureConsoleOutput ('node','-v',Memo2);
 en := PlyModule.InitdatabasePly(io); // PythonGUIInputOutput1);
  // ?  en.IO:= PythonGUIInputOutput1;
  // initdatabase;
  // initdatabaseEngine_ ( PythonEngine1s);
  PlyModule.initDll;
  (*
    if not PythonEngine1s.IsHandleValid then
    begin
    PythonEngine1s.LoadDll;
    end;
  *)
  if not PythonOK then
  begin
    WriteLn('no ok')

  end
  else
  begin
    en.ExecxStrings(fI.AsStringList.strings);
  end;
end;

{ TTestSuit }

procedure TTestSuitMonada.MyTestSuit;
begin
  AddCase([TTestMonaPython]);
end;

end
