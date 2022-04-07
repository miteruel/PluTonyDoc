# Python vs Pascal



![](.gitbook/assets/pythonvspascal.png)

The first thing I did was look up whether there was Jupyter support for
Pascal or Delphi. But there was nothing really definitive that would
allow an easy connection.

The essence of lazarus and delphi is that they are very sophisticated
compilers that generate machine code and Jupyter is not intended to be a
compiler, but rather an intelligent script executor.

In fact, one thing is that the code viewer allows pascal syntax, and
another thing is that this code can be executed correctly by something
and connect to components of your application. Would it be exactly the
same language support? How do they connect? Who executes the scripts?

There are kernel versions in other languages ​​that compile the source
and capture the output of the executable, but in my opinion it is
impractical to do so in Pascal and ultimately we return to the same
problem. Although we create an executable in delphi, how does it connect
to the data we want? In addition, the vulnerability to errors and the
complex configurations make the problem very complex and we want to be
more practical.

If we want to be able to use pascal code from Jupyter, we need a script
engine to execute the code. And it is not the intention to make a new
one, as there are several known FastReport, DWS and Rem Pascal engines.

Each one has its pros and cons, and they don\'t usually have all the
syntactic power of lazarus or delphi. (DWS and Rem Pascal have very
sophisticated extensions )

But keep in mind that if you only want to use pascal from jupyter, it
will be much more difficult to use other typical python tools and
libraries, unless you make complex specific interfaces for each one.


Python

It is not the objective to talk about which language is better, Python
or Pascal, each one has an ideal context of use. If you are a Pascal
programmer, you should already know the advantages and disadvantages.
Its strength is the speed of execution of compiled code compared to
interpreted languages ​​such as Python. But it must be recognized that
Python has a lot of power within its ecosystem, especially as a script
language.

It has a clear, simple and very powerful syntax.

Easy to understand whatever language you come from.

It intelligently exploits the different imperative, object-oriented and
functional paradigms.

It is supported across multiple operating systems and contexts.

It has clear support for typical structures like lists, tuples,
dictionaries, etc.

In summary. Python is ideal for use in Jupyter and although we would
like to be able to use a Pascal syntax, it is not the first priority as
an interpreted pascal does not guarantee an easier connection with our
delphi application.

It is also interesting to be able to make tools that can be used in
Delphi and Python. Open a new way to make your old Pascal programs
useful or integrate new python libraries.