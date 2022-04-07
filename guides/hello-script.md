---
description: ( Jupyter→0MQ→ Delphi→FastScript )
---

# hello script

> 
> Let's forget about Jupyter for a moment, and think only about how to run pascal scripts in your application, as simply as possible.
> 

It is easy to use any script library, but it has quite a few limitations. Not only because of the power of the language itself, but you have to program some connections with your other elements for it to have any use. This is the crux of the problem, if you have a good script system in your applications, you are already half way there.

Including a script engine in your programs is a very clever way to extend functionality. If you use them, you may already have some connections made with internal components of your program. It's about being able to reuse this within python and Jupyter, and similar to what we did with TBindingExpression you can include a python function that runs more complex Pascal scripts.

I have already discussed that it is important to choose a good pascal script engine that has the features you want. I don't know ahead of time which will be the best pascal interpreter to use, so I'll experiment with several and comment on first impressions of each.

They all have things in common; You must add connections to classes and functions of your application specifically. Each one has its strategy, but the objective is the same.

We will start with FastScript (from FastReport), it has multi-language support and allows you to execute more or less complex scripts in pascal, c and javascript and there is no problem with the language since they are equivalent, the important thing is how they connect with your "other objects" of the application. Although they are very different, Jupyter is similar to FastScript, it carries engines for several languages, you connect it to "things" made in other languages ​​and it is capable of interacting with the result to achieve its purpose.

FastScript is solid and well known. It is relatively compact and has very complete integration with many standard delphi components and classes.

But the syntax is somewhat rigid. It is also intended for a single compilation and execution. Each piece of program would have to be "self-sufficient". Although I will try to find a solution, since it is a common problem.

The idea is that it can be used in 2 ways, as a built-in python function that executes pascal scripts, and as a ZMQ service that can respond to script execution
