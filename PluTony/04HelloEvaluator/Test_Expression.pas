unit Test_Expression;

// {$i incspynET}
{$I plutonidef.inc}

interface

{$IFDEF COMPACMODE}

uses
  Monadas_Pascal,
  Plutony_SynTest;

{$ELSE}

uses
  Todo_IScript,

  Plutony_SynTest,
  ToDo_Exe,
  TodoString,
  SynTests,
  Monada_Abstract;
{$ENDIF}

type
  TTestMonaExpression = class(TMiTestCase)

  published
    procedure runScriptsExpression;

  end;

implementation

uses
  PluTony_Zero_Expresion,

  SysUtils;

procedure TTestMonaExpression.runScriptsExpression;
var
  InScript: IScript;
  s: String;
begin
  InScript := InjectScriptExpresion;
  try
    s := InScript.Runs('5+5');
    // s := v;
    WriteLn('v ', s);

  finally
    InScript := nil;
  end;

end;

end.


