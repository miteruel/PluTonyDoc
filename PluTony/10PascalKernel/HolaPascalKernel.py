
import PluTonyKernel_Dll
print(PluTonyKernel_Dll)
import PluTony as Ply
z=Ply.doZeroBroker(":4321")
print(dir(z))


brokerhost="tcp://192.168.1.158:4321"
print(z.Info(''))


# In[3]:


pascal1 ='''
program helo;
begin 
  print ('hola mundo. esto es delphi'); 
end.
'''
r=z.runService("dws",pascal1)
print(r)



# In[4]:
print('conecta cliente')


cliente=Ply.doClientPub(brokerhost,"dws")
print('conectado cliente')
# cliente.Service="dws"

ok=cliente.runScript(pascal1)
print('script cliente')

print(ok)

print('fin cliente')
cliente=None




import zmq
import array
import zeropython
#  from zmq.log.handlers import PUBHandler
print("hola1 zmq")


#  from zmq.log.handlers import PUBHandler
print("hola2")


def run_app(server,service,sourceCode):
    print("run: ",server,service,sourceCode)
    message= zeropython.run_zero(server,service,sourceCode)
    print(message)
    return message


def log_app2(msg):
    run_app(brokerhost,"MyService",msg)


print("hola3")


log_app2 ("hola delphi desde python")


# In[ ]:


print('hola2')





z=None


