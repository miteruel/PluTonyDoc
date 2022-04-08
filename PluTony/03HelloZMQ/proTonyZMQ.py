
import PluTony as Ply
#
#   Hello World client in Python
#   Connects REQ socket to tcp://localhost:5555
#   Sends "Hello" to server, expects "World" back
#
import zmq
import zeropython as zero

hostControl="tcp://localhost:57503";

print("Connecting to hello world server…")
socket = zero.zeroConnect(hostControl,'control')


#  Do 10 requests, waiting each time for a response
for request in range(10):
    print("Sending request %s …" % request)
    message =socket.script("Hello server")
    # run_zero(hostControl,'control',"Hello server")

    # socket.send(b"Hello server")

    #  Get the reply.
    # message = socket.recv_multipart()
    print("Received reply [ %s ]" % ( message))

# x=Ply.rtti_rec.XMLSample()
#  print (x)
#  sa=x.ToXmls
#  print (sa)
# print (dir(sa))

# z=Ply.ZeroServer('tcp://*:5555')
z=Ply.doServezmq('tcp://*:5555')
cliz=Ply.doClientPub('tcp://localhost:5555')

for i in range(0,9):
  cliz.send('hola')
  s=z.recv('')
  print (s)
  z.send('adios');
  s=cliz.recv('')
  print (s)

cliz=Ply.doClientPub('tcp://localhost:57503')
for i in range(0,9):
  cliz.send('hola')
  s=cliz.recv('')
  print ('****',s)

'''
clisub=Ply.doClientSub('tcp://localhost:40885')
for i in range(0,99):
  s=clisub.recSub('')
  print (s)
'''

def parse_list(string):
    try:
        s = eval(string)
        if type(s) == list:
            return s
        return None
    except:
        return None

def parse_tuple(string):
    try:
        s = eval(string)
        if type(s) == tuple:
            return s
        return None
    except:
        return None
sample1 ="('A', 'B', 'C')"
tupla= parse_tuple(sample1)
print ("++++tupla++++")
print (tupla)

sample2 ="['A', 'B', 'C']"
lista = parse_list(sample2)

print (lista)

sample3=Ply.rtti_rec.Makelist(1);
print (sample3)

lista3 = parse_list(sample3)
print (lista3)
tupla = parse_tuple(sample3)
print (tupla)

L = Ply.PyXStringList(1, 2, 3, 4)


print (L)
for i in L:
  print (i, type(i))
print ('Iter')
i = iter(L)
print (i)
try:
  while True:
    print (next(i))
except StopIteration:
  print ("Done")


'''
print ('elisa')

print (Ply.Elisa)

elisa=Ply.Elisa.dama('T:\Elisapil')
# print (dir(elisa))
print (elisa)
Ply.Elisa.SetWsAcceso(2)
print ('WsAcceso',Ply.Elisa.WsAcceso())

a=elisa.WsAgroseguroElisa.GetAgroseguro()
print (a)
print (dir(a))


di =dir(elisa)
po=elisa.Poliza
print (po)
# print (dir(po))
if not po.Active:
   po.Open()

acti=po.Active
print (acti)

print (Ply.patoConfig)
print (Ply.patoConfig.WrapperFilesDir,Ply.patoConfig.StaticFilesDir,
        Ply.patoConfig.ROOTpublic,Ply.patoConfig.ROOTNAME,Ply.patoConfig.PORT)


    APP_NAME: SString;
    PortRest: SString;

    CONNECTION_TIMEOUT: Integer;
    SERVICE_INSTANCE_IMPLEMENTATION: TServiceInstanceImplementation;
    NAMED_PIPE_NAME: String;
    UserBasic: String;
    passwordUserBasic: String;
'''

x=None
# dato =Ply.rtti_rec.SubRecord.dato('midato')
# print(dato)
# rest= Ply.RestServe('889')
# print (rest)

def sumst(*args):
    sum = ''
    for n in args:
        print (n)
        sum = sum + n + ' '
    return sum

def info (*args):
    print (sumst(*args))


def trace (*args):
   return
#   print (sumst(*args))


n = Ply.rtti_rec.count_primes(120)
print(n)
os = Ply.rtti_rec.SubRecord.dato('120')
print(os)
Ply.rtti_rec.SubRecord.fdato='otrodato'
os = Ply.rtti_rec.SubRecord.dato('120')
print(os)

prog="var s : String = 'Hello from delphi script!'; Print(s);"
result=Ply.rtti_rec.ExecDWS(prog)
print(prog)
print(result)



D = Ply.Directory(Ply.Exe.RootDir())

print (D)
od = D/'hola'
print (od)
# D.scope='dir'
# for j in D:
#        print (j)

sub = D.childir

def readFile (root):
  fi=Ply.GetFile(root);
  for s in fi:
     print (s)
def recursivedir2 (dir):
  print (dir)
  for f in dir:
        print (f)
  for s in dir.childir:
        chi=Ply.Directory(s)
#        recursivedir2 (chi)

def recursivedir (dir):
  print (dir)
  for s in dir:
        chi=Ply.Directory(s)
        chi.scope=dir
        recursivedir (chi)

# readFile ('e:/d/d2009/utiles.pas');

# recursivedir(sub)
# recursivedir2(sub)

# for k in D.childir:
#        print (k)


print ('holaL')
# D=None
# L = Ply.Strings(1, 2, 3, 4)

# L = Ply.PyXStringList(1, 2, 3, 4)

print (L[2])
N = int(L[2])
n2 = N *2

L[2] = "" + str(n2)
print (L[2], type(L[2]))
print (L[ L.add(10) ])
# L=None

dirBase = 'E:\python\python4delphi\miteruel'

# read a file in string list buffer
def read_file (root):
  trace ('read_file ',root.root)
  fi=Ply.GetFile(root.root)
  L = Ply.PyXStringList()
  for s in fi:
     L.Add (s)
  return L




import unittest
import jupyter_kernel_test

class MyKernelTests(jupyter_kernel_test.KernelTests):
    # Required --------------------------------------

    # The name identifying an installed kernel to run the tests against
    kernel_name = "eco_master"

    # language_info.name in a kernel_info_reply should match this
    language_name = "mylanguage"

    # Optional --------------------------------------

    # Code in the kernel's language to write "hello, world" to stdout
    code_hello_world = "print 'hello, world'"

    # Pager: code that should display something (anything) in the pager
    code_page_something = "help(something)"

    # Samples of code which generate a result value (ie, some text
    # displayed as Out[n])
    code_execute_result = [
        {'code': '6*7', 'result': '42'}
    ]

    # Samples of code which should generate a rich display output, and
    # the expected MIME type
    code_display_data = [
        {'code': 'show_image()', 'mime': 'image/png'}
    ]

    # You can also write extra tests. We recommend putting your kernel name
    # in the method name, to avoid clashing with any tests that
    # jupyter_kernel_test adds in the future.
    def test_mykernel_stderr(self):
        self.flush_channels()
        reply, output_msgs = self.execute_helper(code='print_err "oops"')
        self.assertEqual(output_msgs[0]['header']['msg_type'], 'stream')
        self.assertEqual(output_msgs[0]['content']['name'], 'stderr')
        self.assertEqual(output_msgs[0]['content']['text'], 'oops\n')

if __name__ == '__main__':
    unittest.main()
'''

# simple_kernel.py
# by Doug Blank <doug.blank@gmail.com>
#
# This sample kernel is meant to be able to demonstrate using zmq for
# implementing a language backend (called a kernel) for IPython. It is
# written in the most straightforward manner so that it can be easily
# translated into other programming languages. It doesn't use any code
# from IPython, but only standard Python libraries and zmq.
#
# It is also designed to be able to run, showing the details of the
# message handling system.
#
# To adjust debug output, set debug_level to:
#  0 - show no debugging information
#  1 - shows basic running information
#  2 - also shows loop details
#  3 - also shows message details
#
# Start with a command, such as:
# ipython console --KernelManager.kernel_cmd="['python', 'simple_kernel.py',
#                                              '{connection_file}']"

from __future__ import print_function

## General Python imports:
import sys
import json
import hmac
import uuid
import errno
import hashlib
import datetime
import threading
from pprint import pformat

# zmq specific imports:
import zmq
from zmq.eventloop import ioloop, zmqstream
from zmq.error import ZMQError

PYTHON3 = sys.version_info.major == 3

#Globals:
DELIM = b"<IDS|MSG>"

debug_level = 3 # 0 (none) to 3 (all) for various levels of detail
exiting = False
engine_id = str(uuid.uuid4())

# Utility functions:
def shutdown():
    global exiting
    exiting = True
    ioloop.IOLoop.instance().stop()

def dprint(level, *args, **kwargs):
    """ Show debug information """
    if level <= debug_level:
        print("DEBUG:", *args, **kwargs)
        sys.stdout.flush()

def msg_id():
    """ Return a new uuid for message id """
    return str(uuid.uuid4())

def str_to_bytes(s):
    return s.encode('ascii') if PYTHON3 else bytes(s)

def sign(msg_lst):
    """
    Sign a message with a secure signature.
    """
    h = auth.copy()
    for m in msg_lst:
        h.update(m)
    return str_to_bytes(h.hexdigest())

def new_header(msg_type):
    """make a new header"""
    return {
            "date": datetime.datetime.now().isoformat(),
            "msg_id": msg_id(),
            "username": "kernel",
            "session": engine_id,
            "msg_type": msg_type,
            "version": "5.0",
        }

def send(stream, msg_type, content=None, parent_header=None, metadata=None, identities=None):
    header = new_header(msg_type)
    if content is None:
        content = {}
    if parent_header is None:
        parent_header = {}
    if metadata is None:
        metadata = {}

    def encode(msg):
        return str_to_bytes(json.dumps(msg))

    msg_lst = [
        encode(header),
        encode(parent_header),
        encode(metadata),
        encode(content),
    ]
    signature = sign(msg_lst)
    parts = [DELIM,
             signature,
             msg_lst[0],
             msg_lst[1],
             msg_lst[2],
             msg_lst[3]]
    if identities:
        parts = identities + parts
    dprint(3, "send parts:", parts)
    stream.send_multipart(parts)
    stream.flush()

def run_thread(loop, name):
    dprint(2, "Starting loop for '%s'..." % name)
    while not exiting:
        dprint(2, "%s Loop!" % name)
        try:
            loop.start()
        except ZMQError as e:
            dprint(2, "%s ZMQError!" % name)
            if e.errno == errno.EINTR:
                continue
            else:
                raise
        except Exception:
            dprint(2, "%s Exception!" % name)
            if exiting:
                break
            else:
                raise
        else:
            dprint(2, "%s Break!" % name)
            break

def heartbeat_loop():
    dprint(2, "Starting loop for 'Heartbeat'...")
    while not exiting:
        dprint(3, ".", end="")
        try:
            zmq.device(zmq.FORWARDER, heartbeat_socket, heartbeat_socket)
        except zmq.ZMQError as e:
            if e.errno == errno.EINTR:
                continue
            else:
                raise
        else:
            break


# Socket Handlers:
def shell_handler(msg):
    global execution_count
    dprint(1, "shell received:", msg)
    position = 0
    identities, msg = deserialize_wire_msg(msg)

    # process request:

    if msg['header']["msg_type"] == "execute_request":
        dprint(1, "simple_kernel Executing:", pformat(msg['content']["code"]))
        content = {
            'execution_state': "busy",
        }
        send(iopub_stream, 'status', content, parent_header=msg['header'])
        #######################################################################
        content = {
            'execution_count': execution_count,
            'code': msg['content']["code"],
        }
        send(iopub_stream, 'execute_input', content, parent_header=msg['header'])
        #######################################################################
        content = {
            'name': "stdout",
            'text': "hello, world",
        }
        send(iopub_stream, 'stream', content, parent_header=msg['header'])
        #######################################################################
        content = {
            'execution_count': execution_count,
            'data': {"text/plain": "result!"},
            'metadata': {}
        }
        send(iopub_stream, 'execute_result', content, parent_header=msg['header'])
        #######################################################################
        content = {
            'execution_state': "idle",
        }
        send(iopub_stream, 'status', content, parent_header=msg['header'])
        #######################################################################
        metadata = {
            "dependencies_met": True,
            "engine": engine_id,
            "status": "ok",
            "started": datetime.datetime.now().isoformat(),
        }
        content = {
            "status": "ok",
            "execution_count": execution_count,
            "user_variables": {},
            "payload": [],
            "user_expressions": {},
        }
        send(shell_stream, 'execute_reply', content, metadata=metadata,
            parent_header=msg['header'], identities=identities)
        execution_count += 1
    elif msg['header']["msg_type"] == "kernel_info_request":
        content = {
            "protocol_version": "5.0",
            "ipython_version": [1, 1, 0, ""],
            "language_version": [0, 0, 1],
            "language": "simple_kernel",
            "implementation": "simple_kernel",
            "implementation_version": "1.1",
            "language_info": {
                "name": "simple_kernel",
                "version": "1.0",
                'mimetype': "",
                'file_extension': ".py",
                'pygments_lexer': "",
                'codemirror_mode': "",
                'nbconvert_exporter': "",
            },
            "banner": ""
        }
        send(shell_stream, 'kernel_info_reply', content, parent_header=msg['header'], identities=identities)
        content = {
            'execution_state': "idle",
        }
        send(iopub_stream, 'status', content, parent_header=msg['header'])
    elif msg['header']["msg_type"] == "history_request":
        dprint(1, "unhandled history request")
    else:
        dprint(1, "unknown msg_type:", msg['header']["msg_type"])

def deserialize_wire_msg(wire_msg):
    """split the routing prefix and message frames from a message on the wire"""
    delim_idx = wire_msg.index(DELIM)
    identities = wire_msg[:delim_idx]
    m_signature = wire_msg[delim_idx + 1]
    msg_frames = wire_msg[delim_idx + 2:]

    def decode(msg):
        return json.loads(msg.decode('ascii') if PYTHON3 else msg)

    m = {}
    m['header']        = decode(msg_frames[0])
    m['parent_header'] = decode(msg_frames[1])
    m['metadata']      = decode(msg_frames[2])
    m['content']       = decode(msg_frames[3])
    check_sig = sign(msg_frames)
    if check_sig != m_signature:
        raise ValueError("Signatures do not match")

    return identities, m

def control_handler(wire_msg):
    global exiting
    dprint(1, "control received:", wire_msg)
    identities, msg = deserialize_wire_msg(wire_msg)
    # Control message handler:
    if msg['header']["msg_type"] == "shutdown_request":
        shutdown()

def iopub_handler(msg):
    dprint(1, "iopub received:", msg)

def stdin_handler(msg):
    dprint(1, "stdin received:", msg)

def bind(socket, connection, port):
    if port <= 0:
        return socket.bind_to_random_port(connection)
    else:
        socket.bind("%s:%s" % (connection, port))
    return port

## Initialize:
ioloop.install()

if len(sys.argv) > 1:
    dprint(1, "Loading simple_kernel with args:", sys.argv)
    dprint(1, "Reading config file '%s'..." % sys.argv[1])
    config = json.loads("".join(open(sys.argv[1]).readlines()))
else:
    dprint(1, "Starting simple_kernel with default args...")
    config = {
        'control_port'      : 0,
        'hb_port'           : 0,
        'iopub_port'        : 0,
        'ip'                : '127.0.0.1',
        'key'               : str(uuid.uuid4()),
        'shell_port'        : 0,
        'signature_scheme'  : 'hmac-sha256',
        'stdin_port'        : 0,
        'transport'         : 'tcp'
    }

connection = config["transport"] + "://" + config["ip"]
secure_key = str_to_bytes(config["key"])
signature_schemes = {"hmac-sha256": hashlib.sha256}
auth = hmac.HMAC(
    secure_key,
    digestmod=signature_schemes[config["signature_scheme"]])
execution_count = 1

##########################################
# Heartbeat:
ctx = zmq.Context()
heartbeat_socket = ctx.socket(zmq.REP)
config["hb_port"] = bind(heartbeat_socket, connection, config["hb_port"])

##########################################
# IOPub/Sub:
# aslo called SubSocketChannel in IPython sources
iopub_socket = ctx.socket(zmq.PUB)
config["iopub_port"] = bind(iopub_socket, connection, config["iopub_port"])
iopub_stream = zmqstream.ZMQStream(iopub_socket)
iopub_stream.on_recv(iopub_handler)

##########################################
# Control:
control_socket = ctx.socket(zmq.ROUTER)
config["control_port"] = bind(control_socket, connection, config["control_port"])
control_stream = zmqstream.ZMQStream(control_socket)
control_stream.on_recv(control_handler)

##########################################
# Stdin:
stdin_socket = ctx.socket(zmq.ROUTER)
config["stdin_port"] = bind(stdin_socket, connection, config["stdin_port"])
stdin_stream = zmqstream.ZMQStream(stdin_socket)
stdin_stream.on_recv(stdin_handler)

##########################################
# Shell:
shell_socket = ctx.socket(zmq.ROUTER)
config["shell_port"] = bind(shell_socket, connection, config["shell_port"])
shell_stream = zmqstream.ZMQStream(shell_socket)
shell_stream.on_recv(shell_handler)

dprint(1, "Config:", json.dumps(config))
dprint(1, "Starting loops...")

hb_thread = threading.Thread(target=heartbeat_loop)
hb_thread.daemon = True
hb_thread.start()

dprint(1, "Ready! Listening...")

'''

def create_msgs(service,sourceCode):
    frame = b""
    frame += b'\x05'
    b2 = array.array("B",  [ord(c) for c in service])
    b3 = array.array("B",  [ord(c) for c in sourceCode])
    # b3 = bytes(sourceCode)
    frame2 = b""
    frame2 += b'\x00'
    frame2 += b'\x00'
    frame2 += b'\x00'
    frame2 += b'\x00'
    return [frame,b2,  b3,frame2]



def create_msg2(service,sourceCode):
    frame = b'\x05'
    b2 = array.array("B",  [ord(c) for c in service])
    b3 = array.array("B",  [ord(c) for c in sourceCode])
    frame2 = b'\x00\x00\x00\x00'
    # frame2 = b'\x00'+ b'\x00' + b'\x00' + b'\x00'
    return [frame,b2,  b3,frame2]


def run_app(server,service,sourceCode):
    ctx = zmq.Context()
    pub = ctx.socket(zmq.REQ)
    pub.connect(server)
    msg =create_msg(service,sourceCode)
    pub.send_multipart(msg)
    # pub.send_multipart([s,service,  sourceCode])


    #  Get the reply.
    message = pub.recv_multipart()
    print("Received reply [ %s ]" % ( message))


def create_msg(service,sourceCode):
    frame2 = array.array("B",  [ord(c) for c in service])
    frame3 = array.array("B",  [ord(c) for c in sourceCode])
    return [b'\x05', frame2,  frame3, b'\x00\x00\x00\x00']

