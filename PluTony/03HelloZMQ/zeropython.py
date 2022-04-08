
import PluTony as Ply
#
#   Hello World client in Python
#   Connects REQ socket to tcp://localhost:5555
#   Sends "Hello" to server, expects "World" back
#
import zmq
import array

# Simple implementation of zmq mayordomo message protocol
class PyZero:
  def __init__(self, host, servi):
    self.service = servi
    self.host = host
    self.ctx = zmq.Context()
    self.pub = self.ctx.socket(zmq.REQ)

  def connect(self):
    return self.pub.connect( self.host)

  def send(self, sourceCode):
     msg =self.zmsg(sourceCode)
     return self.pub.send_multipart(msg)

  def zmsg(self, sourceCode):
    frame2 = array.array("B",  [ord(c) for c in self.service])
    frame3 = array.array("B",  [ord(c) for c in sourceCode])
    return [b'\x05', frame2,  frame3, b'\x00\x00\x00\x00']

  def msg2s(self, msg):
    n = len(msg);
    if n==4:
      return str(msg[2])
    return msg

  def recMulti(self):
    return self.pub.recv_multipart()

  def script(self,sourceCode):
    self.send(sourceCode)
    message = self.recMulti()
    return self.msg2s(message)

def zeroConnect(server,service):
    zero=PyZero(server,service)
    zero.connect()
    return zero

def run_zero(server,service,sourceCode):
    zero=zeroConnect(server,service)
    message = zero.script(sourceCode)
    return message

