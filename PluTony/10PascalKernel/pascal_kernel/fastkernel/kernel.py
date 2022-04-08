from ipykernel.kernelbase import Kernel
# import PluTonyKernel_Dll
# import PluTony as Ply
import zmq


import array

app=Ply.rtti_app

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

hostMain = "tcp://127.0.0.1:54321"
modoscript = 0
SERVICE="MyService"


def run_script(sourceCode):
    global hostMain
    global SERVICE
    return run_zero(hostMain,SERVICE,sourceCode)


class PascalKernel(Kernel):
    implementation = 'Pascal'
    implementation_version = '1.0'
    language = 'Delphi'
    language_version = '0.1'
    language_info = {
        'name': 'pascal',
        'mimetype': 'text/x-pascal',
        'file_extension': '.pas',
    }
    banner = "Echo kernel - as useful as a parrot"


    def do_execute_modo(self, code):
        # return "modomase_Ok_ok"
        global modoscript
        global hostMain
        global SERVICE

        if (code=="///localmode"):
           modoscript=0
           return "local mode"

        if (code=="///remotemode"):
           modoscript=1
           return "local mode"

        par = code.split ('=')
        if (len(par)==2):
          co1=par[0];
          co2=par[1];
          if (co1 =="///host"):
            modoscript=1
            hostMain=co2
            return "now, host is "+hostMain

          if (co1 =="///service"):
            SERVICE=co2
            return "service is "+SERVICE
        if (modoscript==0):
            resulta=app.ExecPascal(code)
            return resulta
        if (modoscript==1):
            resulta=run_script(code)
            return resulta
        return "modo Ok"


    def do_execute(self, code, silent, store_history=True, user_expressions=None,
                   allow_stdin=False):

        if not silent:
            resulta=self.do_execute_modo(code)
            resulta=resulta # + ' - test -  '
            stream_content = {'name': 'stdout', 'text': resulta}
            self.send_response(self.iopub_socket, 'stream', stream_content)

        return {'status': 'ok',
                # The base class increments the execution count
                'execution_count': self.execution_count,
                'payload': [],
                'user_expressions': {},
               }

    def do_history(self, hist_access_type, output, raw, session=None, start=None,
                   stop=None, n=None, pattern=None, unique=False):
        """Override in subclasses to access history.
        """
        return {'status': 'ok', 'history': []}

    def do_complete(self, code, cursor_pos):
        """Override in subclasses to find completions.
        """
        return {'matches' : [],
                'cursor_end' : cursor_pos,
                'cursor_start' : cursor_pos,
                'metadata' : {},
                'status' : 'ok'}


    def __init__(self, **kwargs):
        Kernel.__init__(self, **kwargs)
        # self.context = zmq.Context()
        # self.socket = self.context.socket(zmq.REQ)
        # self.socket.connect("tcp://localhost:57503")
        # self.socket.send(b"HELLO")
        # message = self.socket.recv()
        # self._start_bash()

    '''



    def process_output(self, output):
        self.socket.send(b"output")
        message = self.socket.recv()
        return Kernel.process_output(self, output)

        #



    '''
