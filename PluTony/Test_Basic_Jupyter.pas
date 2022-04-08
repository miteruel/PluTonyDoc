unit Test_Basic_Jupyter;

{$I plutonidef.inc}
(*
  Copyright (c) 2022  Antonio Alcázar Ruiz
  PluTony : Jupyter Pascal extensions.

  This unit uses mORMot or XUnit.
  By default, Plutony test run in SynTest(mORMot) mode.
  If you define {$DEFINE USE_XUNIT}, then run in DUnitX mode.
*)

interface

uses
{$IFDEF COMPACMODE}
  Monadas_Pascal,
{$ELSE}
  ToDo_Exe,
  Monada_Abstract,
{$ENDIF}
  Plutony_SynTest,
  PythonEngine;

type
  TTestMonaPython = class(TMiTestCase)
  public
    procedure SetupFix; override;
    destructor Destroy; override;
  published
    procedure runPython;
  private
    io: TPythonInputOutput;
    procedure PythonInputOutput1SendData(Sender: TObject;
      const Data: AnsiString);
  end;

implementation

uses PluTony_Python_Classes;

destructor TTestMonaPython.Destroy;
begin
  Freenil(io);
  inherited Destroy;
end;

procedure TTestMonaPython.SetupFix;
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
begin
  Plutony_.runPythonSample(ExeVer / mainScript, io);
end;

end.
