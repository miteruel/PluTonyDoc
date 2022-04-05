---
description: →0MQ→ Delphi
---

# hello zeromq.

It is possible that you only need data from your application and that this can be obtained through a connection to a socket service (for example).

Jupyter can connect to different standard services such as a REST service. If your Delphi application has a REST service you can consume it from Jypyter, like any other program, without having to use Python4Delphi.

The Jupyter core itself works with messages implemented in a standard protocol based on 0MQ. Python, Jupyter, and different kernels and extensions connect through it.

The power of 0MQ is that it has a very easy implementation of different communication patterns in different languages. In other words, you can implement a client with only 10 lines of code in one language, and a server with another 10 lines of code in another language.

0MQ has many communication models, full of extensions and details that can confuse us. That is why we will use the simplest connections possible. REQ REP (in zeromq slang) which is question/answer.

This will be the third route, to implement a 0MQ service in delphi, which can be queried from a Jupyter notebook.

In this case you could easily integrate it into an old Legacy Application without having to add anything else. You do not need to integrate python in your application, since it is a simple 0MQ service, which can be queried from anywhere.

Will be necessary a python script that you can easily integrate into the jupyter notebook , to facilitate the connection. But it will be very simple a

At the moment we just want a simple exchange of messages. It is about implementing a kind of data server that can respond to different "commands" with serialized information compatible with python.

For a more solid and sophisticated implementation of communication we can use some distributed Broker system as [\[Grijjy\]{.underline}](https://github.com/grijjy/DelphiZeroMQ). In which there can be one or more Workers that respond to different types of commands or script execution. Workers can be on different servers and dynamically connect to the broker.

In this exchange of messages, you can add a type of message that is a source code and the result that is sent from one node to another. It can be seen as a server that receives source code, executes it and returns the result. And all this is what we will do later.
