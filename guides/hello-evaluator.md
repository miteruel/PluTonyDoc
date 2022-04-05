---
description: Jupyter→0MQ→ Delphi→TBindingExpression
---

# Hello evaluator

We can take another big step forward by including some way to run Pascal scripts.

Delphi's RTTI has a pascal expression evaluator engine which may be a first approach. Through the TBindingExpression class you can do simple evaluations.

In the same way that we have already created functions for python that pass data to the delphi program and return a result, we will create a function that receives the text of a script as a parameter, which is evaluated in the delphi program and returns a string as a result. This is somewhat "far-fetched" and with many limitations, but it is a starting point to be able to use Pascal from Jupyter.

The advantage is that we don't have to make a specific kernel, since we use the python standard. But we have created a python function that receives an evaluable text in delphi as a parameter and returns the result of the evaluation.

For it to be of any use, it must be able to access external variables and functions, and this is done by connecting those variables and functions to the evaluation engine. But this problem is extensible to other solutions.
