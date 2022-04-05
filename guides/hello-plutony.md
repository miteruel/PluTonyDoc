---
description: >-
  Useful library, which can be used in a similar way in Delphi as well as in
  Python and Jupyter.
---

# Hello Plutony

{% hint style="info" %}
Now the real adventure begins, the unexplored part. It doesn't matter if we come from delphi or python, we can understand each other and share tools to establish PluTony colony.
{% endhint %}



P4D itself comes with many components out of the box.

I'll add other elements with a fairly functional paradigm, including some monad structures (which can be easily composed). And that they have a use as similar as possible in Delphi and Python.

MonaFile , MonaDirectoy, MonaXML, MonaJson, MonaTxt, MonaParse

It is about having a minimum infrastructure that allows you to experiment and add new tools. Through python we have the possibility to connect with many libraries, and our pascal code can also use multiple libraries and resources. Depending on the type of project you can give more importance to one language or another.

You also have to work on the background more than the form. In short, the important thing is to know how to use this. What would you like to do from Jupyter?

The first thing is to get data, mainly lists of something. For example the information of a table or the result of a query. It is not necessary to connect every element of your delphi programs with Python. Basically you are only going to connect with high-level elements and functions that return an elaborate result. Similar to a web server, which receives a query and returns information.

In addition, P4D incorporates very simple RTTI connections with delphi components. That is, you can get the property of a specific object and you can also execute published or public methods. This can even be "dangerous", so you can create an add-hoc component that only publishes what is necessary or create a Record structure that publishes a function by RTTI.

P4D , allows integration with python tuples, lists and dictionaries. It allows to serialize data from a complex Variant, although it implies the use of the python engine. But there is another alternative for when this is not possible or slow, which is to serialize the information in a string that has a python-friendly format. For this we will use Mormot, which has very powerful support for Variants and

> tuple serialization: (..)
>
> list: \[..]
>
> set: {..}
>
> dict: {a:b,..}

From here we can start explain PluTony from Jupyter and vice versa. That is why the following documents will already be \*.ipynb.
