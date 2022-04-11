# What is PluTony?

![](.gitbook/assets/logoply1.png)

PluTony was born as an experiment with the objective of "connecting" [\[Jupyter\]](https://jupyter.org), with programs made in Pascal.


The concept "connect" is intentionally ambiguous. Since there are many ways to connect and not all of them may be useful in the real world of your application scenario.

> * One thing is that from jupyter you read data from files generated by an application or read data from a Rest server made in Pascal.
> * Another thing is that from jupyter you can interact with libraries and code made in Pascal using Python.
> * And one more is to use Pascal scripts from Jupyter.
> * Or to be able to combine Pascal built into Python, or Python built into Pascal.

> There are also many combinations regarding the objectives, if you want to essentially consume data, or be able to interact with code in one or more languages.
>
> Also, where is the data being consumed from, from a lab application on your computer? From an application on your local network? From a computer on the internet? Or how about from Google Colab?

## Getting Started

****

![](.gitbook/assets/image5.png)

It is necessary to have the main tools installed.

1. Download and install Python. [download Python](https://www.python.org/downloads/) 
2. Install Jupyter. > pip install notebook
3. You must compile and execute one of following executables. This runs ZeroBroker router using different pascal script engines.
 * 05HelloFastScript\ZeroFastScript
 * 06HelloDWS\ZeroDWS
 * 07HelloRemPascalScript\ZeroRem
 * 10PascalKernel\PlutonyKernel
4. You must register the new pascal-kernel, wich connects with previous Brokers.  >zerokernel\run_install.bat
5. Run Jupyter: > jupyter notebook


 
> 
> The code in [**\[MVP\]**](https://en.wikipedia.org/wiki/Minimum\_viable\_product) Each component has a complete functionality, but in minimal expression.
> 

You can access to runtime example in
[PluTony exanoke](https://ee62-88-6-67-95.ngrok.io)

> Sorry if link is broken, actually i run it in a virtual envitoment and not 100% accesible.
> You can contribute by setting online brokers or jupyter node examples, send me an email to mrgarciagarcia@gmail.com for more details.
> 

### Routes/Guides:

This text is a small guide that describes some ways to make this connection using popular libraries. As if it were a trip I will call them routes, and in which I will try to describe the path. The source code encapsulates these connections, in the simplest possible and composable structures, which you can combine according to the context.

An obvious way to get data is to generate json or csv files and read them from jupyter. Somewhat more sophisticated, you can run your program passing parameters and get a variable result. But it is not my goal to delve into this way, as it is described elsewhere (the bass kernel) and is not unique to Delphi.


* [hello-jupyter.md](guides/hello-jupyter.md)
* [hello-plutony.md](guides/hello-plutony.md)
* [hello-zeromq.md](guides/hello-zeromq.md)
* [hello-evaluator.md](guides/hello-evaluator.md)
* [hello-script.md](guides/hello-script.md)
* [hello-dws.md](guides/hello-dws.md)
* [hello-rem.md](guides/hello-rem.md)
* [kernel-pascal.md](guides/kernel-pascal.md)


> 
> This guides matches with source code samples.
> 


### Fundamentals: 

Some concepts and  dependences. 


* [What is Jupyter](fundamentals/what-is-jupyter.md)
* [Python vs Pascal](fundamentals/python-vs-pascal.md)
* [Other project dependences](fundamentals/project-dependences.md)

> 
> Splitting PluTony into fundamental concepts, objects, or areas.
> 
> 