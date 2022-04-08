//{$I incspynET}
{.$define enufaster}
{.$define enulogger}
{$IFDEF ver330}{$DEFINE ver270}{$ENDIF ver330}
{$IFDEF ver320}{$DEFINE ver270}{$ENDIF ver320}
{$IFDEF ver310}{$DEFINE ver270}{$DEFINE xe6}{$ENDIF ver310}
{$IFDEF ver300}{$DEFINE ver270}{$ENDIF ver300}
{$IFDEF ver290}{$DEFINE ver270}{$ENDIF ver290}
{$IFDEF ver280}{$DEFINE ver270}{$ENDIF ver280}

{$IFDEF ver270}
{$DEFINE DelphiDx}
{$DEFINE ver260}
{$ENDIF ver270}
{$IFDEF ver260}{$DEFINE ver250}{$ENDIF ver260}
{$IFDEF ver250}{$DEFINE ver240}{$ENDIF ver250}
{$IFDEF ver240}
{$DEFINE ver230}
{$DEFINE xe5}
{$DEFINE ver200}
{$ENDIF ver240}
{$IFDEF ver230}{$DEFINE ver220}{$ENDIF ver230}
{$IFDEF ver220}{$DEFINE ver210}{$ENDIF ver220}
{$IFDEF ver210}{$DEFINE ver200}{$ENDIF ver210}
{$IFDEF ver200}{$DEFINE ver190}{$ENDIF ver200}
{$IFDEF ver190}{$DEFINE ver180}{$ENDIF ver190}
{$IFDEF ver180}
{$DEFINE ver170}
{$DEFINE d10}
{$UNDEF lessv150}
{$ENDIF ver180}
{$IFDEF ver170}{$DEFINE ver160}{$ENDIF ver170}
{$IFDEF ver160}{$DEFINE ver150}{$ENDIF ver160}
{$IFDEF ver150}{$DEFINE ver150Up}{$ENDIF}
{$IFDEF CPU64}
1
{$DEFINE PUREPASCAL}
{$ENDIF CPU64}
{$DEFINE indy10}
{$DEFINE jpeg}
{$DEFINE veryfast}
{ .$DEFINE mixprofile }
{$DEFINE sinproTGlobalObject}
{$IFNDEF mixprofile}
{$DEFINE MiProf}
{$DEFINE sinpro}
{$DEFINE todos}
{$DEFINE todoe}
{$DEFINE todox}
{$ENDIF mixprofile}
{$DEFINE sinprosp}
{$IFDEF android}
{$DEFINE DelphiDx}
{$DEFINE NoAnsiMode}
{$ELSE android}
{$IFDEF xe5}
{$DEFINE NoAnsiMode}
// {$DEFINE AnsiModeDX }
// {$DEFINE AnsiMode }
{$ELSE xe5}
{$DEFINE AnsiPure}
{$ENDIF xe5}
{$ENDIF android}
{$DEFINE sinpromix}
{$IFDEF CIL}
{$DEFINE netnet}
{$DEFINE netnetlike}
{$DEFINE dina}
{$DEFINE DotNet}
{$ENDIF}
{$IFDEF netnet}
{$DEFINE tonet}
{$DEFINE noTip}
{$ELSE netnet}
{$DEFINE trayicon}
{$DEFINE gif}
{$DEFINE migif}
{$ENDIF netnet}
{$DEFINE inspector}
{$DEFINE gpalone}
{$DEFINE quitar}
{$DEFINE sslgp}
{$DEFINE mibmp}
{$DEFINE mijpeg}
{$DEFINE gpintraweb}
{$DEFINE spice}
{$IFDEF netnet}
{$UNDEF mibmp}
{$UNDEF mijpeg}
{$UNDEF spice}
{$ENDIF netnet}
{$IFDEF miw}
{$UNDEF spice}
{$DEFINE minimo}
{$UNDEF gpintraweb}
{$ENDIF miw}
{$DEFINE listuser}
{$IFDEF netnet}{$DEFINE mini}{$ENDIF netnet}
{$UNDEF spice}
{$DEFINE wem}
{$DEFINE traza}
{$DEFINE dependencias}
{$DEFINE dependenciasDbIB}
{$DEFINE dependenciasDb}
{$IFNDEF xe5}
{$DEFINE enufaster}
{$DEFINE dependenciasDbIB}
{$DEFINE dependenciasVcl}
{$ELSE }
{$UNDEF veryfast}
{$ENDIF xe5}
{$IFNDEF xe6}
{$DEFINE dependenciasDbIB}
{$DEFINE dependenciasDb}
{$ENDIF }
{$DEFINE COMUNICACIONES}
{$IFDEF ver100}
{$DEFINE Delphi3}
{$ELSE }
{$DEFINE D4PLUS}
{$DEFINE Delphi7}
{$ENDIF}
{$DEFINE ibelisa}
{$DEFINE extenso}
{$IFNDEF xe5}
{$DEFINE dependencias}
{$DEFINE dependenciasDb}
{$DEFINE dependenciasDbIB}
{$DEFINE dependenciasVcl}
{$DEFINE webservices}
{$ENDIF xe5}
{$DEFINE veryfast}
{$IFDEF DelphiDx}
{$UNDEF veryfast}
{$DEFINE PUREPASCAL}
{$ENDIF DelphiDx}
{$DEFINE minimal}
{$DEFINE dependeWinForms}
{$IFDEF FPC}
{$DEFINE lazarus}
{$DEFINE todox}
{$DEFINE todos}
{$DEFINE delphi}
{$UNDEF dependencias}
{$UNDEF veryfast}
1
{$DEFINE PUREPASCAL}
{$DEFINE mimormot}
{$UNDEF mipdf}
{$UNDEF dependenciasDbIB}
{$ELSE FPC}
{$DEFINE mimormot}
{$ENDIF FPC}
{$IFDEF DelphiDx}
{$DEFINE NoAnsi}
{$ENDIF DelphiDx}
{$IFDEF netnet}
1
{$DEFINE PUREPASCAL}
{$ENDIF netnet}
{$DEFINE StaticEnum}
{$DEFINE webservices}
{$IFDEF AnsiMode}
{$IFDEF DelphiDx}
{$DEFINE AnsiModeDx}
{$ENDIF DelphiDx}
{$ENDIF AnsiMode}
// {$DEFINE ANSI STREAM}
{ .$DEFINE ZEROSMODE }
// {$ZEROBASEDSTRINGS ON}
{$IFDEF android}
{$ZEROBASEDSTRINGS OFF} // for Delphi desktop compilers
{$UNDEF mimormot}
{$UNDEF veryfast}
{$DEFINE sinpro}
{$DEFINE unixpath}
{$ENDIF android}
{ .$define MINIMIZAMEM }
{ . $DEFINE ToDoSoap }

{ .$UNDEF mimormot }
{ .$define checkmems }
{ .$define SinBdeIB }
{ .$DEFINE SINBDE }
{$IFDEF FPC}
{$UNDEF mimormot }
{$ENDIF FPC}
{$DEFINE NewFast }
{ .$define TracesXml }
{$UNDEF mimormot }
{$IFDEF xe5}

{$DEFINE COMPACMODE}
{$DEFINE PUREPASCAL}
{$else}
                   1

{$ENDIF}
{.$undef PUREPASCAL}

{.$DEFINE COMPACMODE}


{$DEFINE version5}

{$DEFINE ZMQ_NORIGINAL}
{$DEFINE PLUTONY_FASTSCRIPT}
{$DEFINE PLUTONY_REM}
{$DEFINE PLUTONY_DWS}
{.$define DWSKinks}

{1.$DEFINE PLUTONY_EXPRESSION}
{$DEFINE PLUTONY_ZEROPY}
{.$DEFINE USE_XUNIT}
{$define mormotExt}
