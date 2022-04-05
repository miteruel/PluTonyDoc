# Kernel Pascal

---
description: Create an iPython Kernel for Pascal.
---
We have already seen that we can set up a Broker, to which we can subscribe different script services, such as workers of different programs and servers. What we want is to communicate the Kernel class to the Broker service.

As a first example, we will start with a simple wrapper in python code.

Basically we have to rewrite the do\_execute method of demo kernet.py unit&#x20;

```
import zeropython
...
def do_execute(self, code, silent, store_history=True, user_expressions=None,
allow_stdin=False):
if not silent:
results=zeropython.run_script(code)
stream_content = {'name ': 'stdout', 'text': output}
self.send_response(self.iopub_socket, 'stream', stream_content)
...
```



