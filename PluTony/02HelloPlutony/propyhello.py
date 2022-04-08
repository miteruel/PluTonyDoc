
import PluTony  as Ply
#
# x=Ply.rtti_rec.XMLSample()
#  print (x)
#  sa=x.ToXmls
#  print (sa)
# print (dir(sa))

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

sample3=Ply.rtti_app.Makelist(1);
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


simple = Ply.rtti_app.Mor.FilesInCSV('*.*')
print (simple)



x=None
# dato =Ply.rtti_app.SubRecord.dato('midato')
# print(dato)
# rest= Ply.RestServe('889')
# print (rest)

def sumst(*args):
    sum = ''
    for n in args:
        sum = sum + n + ' '
        # print (n)
    return sum

def info (*args):
    print (sumst(*args))


def trace (*args):
  return
  print (sumst(*args))
  #   return

app = Ply.rtti_app

os = app.SubRecord.dato('120')
print(os)
app.SubRecord.fdato='otrodato'
os = app.SubRecord.dato('120')
print(os)

prog="var s : String = 'Hello from delphi script!'; Print(s);"
result=app.ExecPascal(prog)
print(prog)
print(result)



D = Ply.Directory('e:/')
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


print ('advent of code')


dirBase = 'E:/python/miteruel/advent'
recursivedir(Ply.Directory(dirBase))

# read a file in string list buffer
def read_file (root):
  # trace ('read_file ',root.root)
  L = Ply.PyXStringList()
  for s in root:
     L.Add (s)
     print ('ref ',s)
  return L

def infor (tit,root):
  info (tit,root.root)



def dia1_1 (root):
  infor ('dia1_1',root)
  antes =''
  nincremento = 0
  # for s in fi:
  for s in root:
     trace (s)
     if antes!='' :
        if int(s)>int(antes) :
                nincremento = nincremento + 1
     antes=s
  return nincremento
def dia1_2 (root):
  ventana =[0,0,0]
  nincremento = 0
  antes=-1
  lin =0
  # for s in fi:

  for s in root:
     mo = lin % 3
     ventana[mo]=int(s)
     lin +=1
     if lin>2 :
        ahora =ventana[0]+ventana[1]+ventana[2]
        if antes!=-1 :
           if ahora>antes :
              trace (s+' ++')
              nincremento = nincremento + 1
           else:
              trace (s+' --')
        antes=ahora
  return nincremento

Di = Ply.Directory(dirBase)
print (Di)
r1=dia1_1(Di/'input1.txt')
print (r1)
# r1=dia1_2(Di/'input1.txt')

# print (r1)


FORWARD = 'forward'
DOWN = 'down'
UP = 'up'


def dia2_1 (root):
  infor ('dia2.1',root)

  nincremento = 0
  horizontal = 0
  depth =0
  for s in root:
     print (s)
     valores = s.split()
     print (valores)
     comando = valores[0]
     valor =  int(valores[1])
     if comando==FORWARD :
             horizontal +=valor
             print ('h',horizontal)

     elif comando==DOWN :
             depth +=valor
             print ('d',depth)

     elif comando==UP :
             print (s)
             depth -=valor
             print ('d',depth)

  return (horizontal * depth)


def dia2_2 (root):
  print ('dia2.2')
  nincremento = 0
  horizontal = 0
  aim=0
  depth =0
  for s in root:
     print (s)
     valores = s.split()
     print (valores)
     comando = valores[0]
     valor =  int(valores[1])
     if comando==FORWARD :
             horizontal +=valor
             depth +=valor*aim

             print ('h',horizontal)

     elif comando==DOWN :
             aim+=valor
             print (aim,' d ',depth)

     elif comando==UP :
             print (s)
             aim-=valor
             print (aim,' up ',depth)
  print ('h ', horizontal, ' a ',aim,' d ',depth)
  return (horizontal * depth)


print ('dia2')
# r1=dia2_1(Di/'input2.txt')

# print (' result ',r1)

# r1=dia2_2(Di/'input2.txt')
# print (' result ',r1)

def dia3_1 (root):
  print ('dia3.1')
  aa0 =[0,0,0,0,0,0,0,0,0,0,0,0]
  aa1 =[0,0,0,0,0,0,0,0,0,0,0,0]
  total=0
  for s in root:
     total +=1
     trace (s)
     id=0
     for c in s:
       if c=='1':
         aa1[id] +=1
       else:
         aa0[id] +=1
       id +=1


  gamma=''
  epsilon =''
  for i in range (12):
        if (aa1[i]>aa0[i]):
           gamma+='1'
           epsilon +='0'
        else:
           gamma+='0'
           epsilon +='1'
  gammaint=int(gamma,2)
  epsilonint =int(epsilon,2)

  print ('gamma ',gamma, ' = ', gammaint)
  print ('epsilon ',epsilon, ' = ', epsilonint)

  return gammaint*epsilonint
# 3813416
r1=dia3_1(Di/'input3.txt')
print (' result ',r1)

def dia3_read (root):
  info ('dia3_read')
  L = Ply.PyXStringList()
  for s in root:
     L.Add (s)
  return L

def dia3_mayor (Lmain, posbit):
  print ('dia3_mayor ',Lmain.Count)
  aa0 =0
  aa1 =0
  for s in Lmain:
       c=s[posbit]
       if c=='1':
         aa1 +=1
       else:
         aa0 +=1
  if aa0>aa1 :
        return '0'
  else:
        return '1'

def dia3_menor (Lmain, posbit):
  print ('dia3_menor ',Lmain.Count)
  mas = dia3_mayor(Lmain, posbit)
  if mas=='1' :
        return '0'
  else:
        return '1'


def dia3_filtro (Lmain,posbit,fun):
  print ('dia3_filtro ',Lmain.Count)
  L = Ply.PyXStringList()
  domina=fun (Lmain, posbit)
#  domina=dia3_mayor (Lmain, posbit)
  for s in Lmain:
       c=s[posbit]
       if c==domina:
         L.Add(s)
  return L

def dia3_filtrofun (root,fun):
  print ('dia3_filtrofun')
  L = read_file (root)
  for i in range (12):
        if L.Count<2 :
                break
        nuevo=dia3_filtro (L,i,fun)
        if nuevo.Count>0:
          L=nuevo
  print (' resuls ')
  for s in L:
         print(s)
         return int(s,2)
  return 0

def dia3_2 (root):
  print ('dia3.2')
  oxigeno=dia3_filtrofun(root,dia3_mayor)
  co2=dia3_filtrofun(root,dia3_menor)
  print ('oxigeno ',oxigeno,' co2 ',co2)
  return oxigeno*co2

# r1=dia3_2(Di/'input3.txt')
# print (' result 3 ',r1)

elementline = 5
linesbingo = 5
nulo='x'

class Linea:
    # elemento = []
    # acertados = []


    def __init__(self,s):
        self.elemento = s.split()
        self.acertados = []
        for e in self.elemento:
            self.acertados.append(e)

    def testNumber(self,n):
        for i in range (len(self.acertados)):
            if self.acertados[i]==n:
                self.acertados[i]=nulo

        # print ('test ',n, self.acertados)
        # print ('test ',n, self.acertados)

    def countUnmarked(self):
        cu=0;
        for s in self.acertados:
            if s!=nulo:
                cu+=int(s)
        return cu


    def isfill(self):
        cu=0;
        for s in self.acertados:
            if s!=nulo:
                cu+=1
        return (cu==0)

    def show(self):
        # print ('showline ',len(self.elemento))
        s = ' '.join(self.elemento)
        print (s)
        s = ' '.join(self.acertados)
        print ('acerta ',s)


class Carton:

    def show(self):
        print ('showcarton ',len(self.lineas))
        for lin in self.lineas:
           lin.show()

    def __init__(self):
       self.lineas = []

    def countUnmarked(self):
        cu=0;
        for lin in self.lineas:
           cu += lin.countUnmarked()
        return cu

    def testNumber(self,n):
        for lin in self.lineas:
           lin.testNumber(n)

    def isfillcolumn(self,n):
        cu=0;
        for lin in self.lineas:
             if lin.acertados[n]!=nulo:
                cu+=1
        return (cu==0)

    def isWinner(self):
        for lin in self.lineas:
            if lin.isfill():
                return True
        for i in range (5):
           if self.isfillcolumn (i):
               print ('isfill')
               return True
        return False

    def readNext(self,s):
        print ('nextcarton ',s)

        if (s==''):
                return False
        lin = Linea(s)
        print (lin)
        self.lineas.append (lin)
        return True

class Bingo:


     def __init__(self):
       self.cartones = []
       self.last = None

     def show(self):
        print ('Bingo ',len(self.cartones),' cartones ')
        for car in self.cartones:
          pass
          car.show()

     def testNumber(self,n):
        for i in range(len(self.cartones)):
             self.cartones[i].testNumber(n)

     #  for car in self.cartones:
     #      car.testNumber(n)

     def isWinner(self):
        for car in self.cartones:
            if car.isWinner():
                return car
        return None


     def readNext(self,s):
        # print ('next',s)
        if (s==''):
             print (' nuevo carton')
             self.last=None
             self.last=Carton ()
             self.cartones.append(self.last)
        else:
          if self.last!=None:
              self.last.readNext(s)



def splitnumbers (st):
  L =st.split(',')
  return L

def dia4_1 (root):
  print ('dia4.1')
  L = read_file (root)
  numeros = splitnumbers(L[0])
#  for n in numeros:
#        print (n)
  bi = Bingo ();
#  print (bi)
  for s in range (1,L.Count):
        bi.readNext(L[s])
  print ('*** end reader ***')
#  print (bi)

  bi.show()
  for i in range(len(numeros)):
     n=numeros[i]
     print ('test number :',n);
     bi.testNumber(n)
     car=bi.isWinner ()
     if car!=None:
        print ('winner is: ',car);
        car.show()
        cu = car.countUnmarked();
        print ('uncount: ',cu, ' last ',n)
        resulta= cu*int(n)
        return resulta


        break;
 

  return 0

def dia4_2 (root):
  print ('dia4.2')
  L = read_file (root)
  numeros = splitnumbers(L[0])
  bi = Bingo ();
  for s in range (1,L.Count):
        bi.readNext(L[s])
  print ('*** end reader ***')

#  bi.show()
  print ('numeros ',len(numeros))

  for i in range(len(numeros)):
     n=numeros[i]
     print ('test number :',n);
     bi.testNumber(n)
     car=bi.isWinner ()
     while (car!=None):
        # print ('winner is: ',car);
        car.show()
        cu = car.countUnmarked();
        print ('uncount: ',cu, ' last ',n)
        if len(bi.cartones)==1:
                car=bi.cartones[0]
                print ('last winner is: ',car);
                car.show()
                cu = car.countUnmarked();
                print ('uncount: ',cu, ' last ',n)
                resulta= cu*int(n)
                return resulta

        bi.cartones.remove(car)
        print ('quedan : ',len(bi.cartones))
        car=bi.isWinner ()


  return 0



# r1=dia4_1(Di/'input4.txt')
# print (' result 4 ',r1)

# r1=dia4_2(Di/'input4.txt')
# print (' result 4_2 ',r1)

mil =1000
class Board:
    def __init__(self):
       self.lines = []
       self.sumove = 0

       for li in range(mil):
          line=[]
          for n in range(mil):
              line.append(0)
          self.lines.append(line)

    def marca (self,s, diagonal=False):
        par = s.split (' -> ')
        co1=par[0].split(',');
        co2=par[1].split(',');
        x1=int(co1[0])
        y1=int(co1[1])
        x2=int(co2[0])
        y2=int(co2[1])

        if (x1==x2):
           if y1>y2:
                y=y1
                y1=y2
                y2=y

           ove =0;
           for i in range (y1,y2+1):
                self.lines[i][x1]+=1
                if self.lines[i][x1]==2:
                  ove+=1
           if ove>0:
                self.sumove+=ove
                #  print (ove,' x ',s, 'x1 ',x1,' y1 ',y1,' x2 ',x2,' y2 ',y2)


        elif (y1==y2):
           if x1>x2:
                x=x1
                x1=x2
                x2=x

           ove =0;
           for i in range (x1,x2+1):
                self.lines[y1][i]+=1
                if self.lines[y1][i]==2:
                  ove+=1
           if ove>0:
                self.sumove+=ove
                # print (ove,' sum ',self.sumove, ' yt ',s, 'x1 ',x1,' y1 ',y1,' x2 ',x2,' y2 ',y2)
        elif (diagonal):
           if abs(x2-x1)==abs(y2-y1):
                ove =0;
                y=y1
                dy=1
                if (y1>y2):
                    dy=-1
                x=x1
                dx=1
                inix=x1
                finx=x2
                if (x1>x2):
                  dx=-1
                  inix=x2
                  finx=x1
                for i in range (inix,finx+1):
                        self.lines[y][x]+=1
                        y+=dy
                        x+=dx



    def cuentamas2(self):
       cu=0
       for li in range(mil):
          for n in range(mil):
                if self.lines[li][n]>=2:
                        cu+=1
       return cu



def dia5_1 (root):
  print ('dia5.1')
  L = read_file (root)
  bo=Board()
  for s in L:
        bo.marca(s)
        # cuenta=bo.cuentamas2()
        # print ('parcial ',cuenta)
  cuenta=bo.cuentamas2()
  return cuenta


# r1=dia5_1(Di/'input5.txt')
# print (' result 5_1 ',r1)


def dia5_2 (root):
  print ('dia5.2')
  L = read_file (root)
  bo=Board()
  for s in L:
        bo.marca(s,True)
  cuenta=bo.cuentamas2()
  return cuenta

# r1=dia5_2(Di/'input5.txt')
# print (' result 5_2 ',r1)


ocho=8
seis=6

def dia6_1 (root):
  print ('dia6.1')
  L = read_file (root)
  entrada =splitnumbers(L[0])
  linterna =[]
  for s in entrada:
    linterna.append (int(s))
  print (linterna)
  print ('ini ', len(linterna))
  for dia in range (80):
     mas=0
     for i in range (len(linterna)):
         if linterna[i]==0:
            linterna[i]=6
         else:
            linterna[i]-=1
         if linterna[i]==0:
            mas+=1
     print ('dia ',dia, len(linterna), ' mas ',mas)
     if dia!=79:
        for no in range(mas):
                linterna.append(9)
     # print (linterna)

  cuenta=len(linterna)
  return cuenta

# r1=dia6_1(Di/'input6.txt')
# print (' result 6_1 ',r1)




def dia6_2 (root):
  print ('dia6.2')
  L = read_file (root)
  entrada =splitnumbers(L[0])
  linternas =[0,0,0,0,0,0,0,0,0]
  for s in entrada:
    n=int(s)
    linternas[n]+=1
  print (linternas)
  print ('ini ', len(linternas))
  for dia in range (256):
     mas=linternas[0]
     for i in range (len(linternas)-1):
         linternas[i]=linternas[i+1]
     linternas[ocho]=mas
     linternas[seis]+=mas

  cuenta=0
  for i in range (len(linternas)):
        cuenta+= linternas[i]
  return cuenta


r1=dia6_2(Di/'input6.txt')
print (' result 6_2 ',r1)

def dia7fun1 (n1,n2):
  dif = abs (n1-n2)
  return dif

def dia7fun2 (n1,n2):
  dif = abs (n1-n2)
  cu=0
  pe=0
  for i in range (dif):
     pe+=1
     cu+=pe
  return cu

def dia7fun2bis (n1,n2):
  dif = abs (n1-n2)
  return (1+dif)*dif//2


def dia7_1 (root):
  print ('dia7.1')
  L = read_file (root)
  entrada =splitnumbers(L[0])

  cangrejos=[]
  coste =[]
  for s in entrada:
     cangrejos.append( int(s))
     coste.append(0)

  for i in range (len(coste)):
     cu=0
     for s in cangrejos:
        cu+=abs(i-s)
     coste[i]=cu
  menor=coste[0]
  idmenor=0
  for i in range (len(coste)):
     cu=coste[i]
     if cu<menor:
        menor=cu
        idmenor=i
  print (' menor ',menor,' id ', idmenor)
  return menor

r1=dia7_1(Di/'input7.txt')
print (' result 7_1 ',r1)

def dia7_x (root,fun):
  info ('dia7.x')
  L = read_file (root)
  entrada =splitnumbers(L[0])

  cangrejos=[]
  coste =[]
  for s in entrada:
     cangrejos.append( int(s))
     coste.append(0)

  for i in range (len(coste)):
     cu=0
     for s in cangrejos:
        cu+=fun(i,s)
     coste[i]=cu
  menor=coste[0]
  idmenor=0
  for i in range (len(coste)):
     cu=coste[i]
     if cu<menor:
        menor=cu
        idmenor=i
  print (' menor ',menor,' id ', idmenor)
  return menor



def dia7_2 (root):
  print ('dia7.2')
  dia7_x (root,dia7fun1)

  return dia7_x (root,dia7fun2bis)

  return dia7_x (root,dia7fun2)

r1=dia7_2(Di/'input7.txt')
print (' result 7_2 ',r1)

setsimple ={2,3,4,7}

def dia8_1 (root):
  print ('dia8.1')
  L = read_file (root)
  cu=0
  for s in L:
     linea=s.split(' | ')
     output = linea[1].split()
     for nn in output:
        le=len(nn)
        if le in setsimple:
          cu+=1
  return cu

r1=dia8_1(Di/'input8.txt')
print (' result 8_1 ',r1)

## the number with only 2 segments
def deduce1 (input):
     for nn in input:
        le=len(nn)
        if le == 2:
          return (nn)
     return ''

## the number with only 4 segments
def deduce4 (input):
     for nn in input:
        le=len(nn)
        if le == 4:
          return (nn)
     return ''

## the number with only 7 segments
def deduce8 (input):
     for nn in input:
        le=len(nn)
        if le == 7:
          return (nn)
     return ''


## the number with only 3 segments
def deduce7 (input):
     for nn in input:
        le=len(nn)
        if le == 3:
          return (nn)
     return ''

def shared (s1,s2):
   cu=0
   for c in s1:
     if s2.find(c)>=0:
        cu+=1
   return cu

## the number of 5 segments with 3 sharing with 7
def deduce3 (input):
     d7=deduce7(input)
     for nn in input:
        le=len(nn)
        if le == 5:
          cu =shared (d7,nn)
          if cu==3:
                return (nn)
     return ''

## the number of 6 segments with 5 sharing with 3
def deduce9 (input):
     d3=deduce3(input)
     for nn in input:
        if len(nn) == 6:
          cu =shared (d3,nn)
          if cu==5:
                return (nn)
     return ''

## the number of 5 segments different than d3 with 5 sharing with 9
def deduce5 (input):
     d3=deduce3(input)
     d9=deduce9(input)
     for nn in input:
        if nn!=d3:   # different than d3
           if len(nn) == 5:
                cu =shared (d9,nn)
                if cu==5:
                        return (nn)
     return ''

## the number of 5 segments different than d3 and d5
def deduce2 (input):
     d3=deduce3(input)
     d5=deduce5(input)
     for nn in input:
        if len(nn) == 5:
           if nn!=d3:   # different than d3
              if nn!=d5:
                return (nn)
     return ''


## the number of 6 segments different than d9 share 2 segment with d1
def deduce0 (input):
     d9=deduce9(input)
     d1=deduce1(input)
     for nn in input:
        if len(nn) == 6:
           if nn!=d9:   # different than d3
                cu =shared (d1,nn)
                if cu==2:
                        return (nn)
     return ''

## the number of 6 segments different than d9 share 1 segment with d1
def deduce6 (input):
     d9=deduce9(input)
     d1=deduce1(input)
     for nn in input:
        if len(nn) == 6:
           if nn!=d9:   # different than d3
                cu =shared (d1,nn)
                if cu==1:
                        return (nn)
     return ''

def sortchars(texto):
        sorted_characters = sorted(texto)
        a_string = "". join(sorted_characters)
        return a_string

## the number with only 3 digits
def deduceAA (input):
     d7=deduce7(input)
     d1=deduce1(input)
     s=d7
     for c in d1:
       s.replace (c,'')
     return s

# if element is found it returns index of element else returns None

def find_element_in_list(element, list_element):
    try:
        index_element = list_element.index(element)
        return index_element
    except ValueError:
        return None


def dia8_2 (root):
  print ('dia8.2')
  L = read_file (root)
  cu=0
  for s in L:
     linea=s.split(' | ')
     output = linea[1].split()
     input =linea[0].split()
     d1= deduce1(input)
     print ('d1 ',d1)
     d7= deduce7(input)
     print ('d7 ',d7)
     d3= deduce3(input)
     print ('d3 ',d3)
     d0= deduce0(input)
     d2= deduce2(input)
     d4= deduce4(input)
     d5= deduce5(input)
     d6= deduce6(input)
     d8= deduce8(input)
     d9= deduce9(input)
     digitsno= [d0,d1,d2,d3,d4,d5,d6,d7,d8,d9]
     print ('digitsno ',digitsno)

     digits= []
     for s in digitsno:
        digits.append (sortchars(s))
     cifra=''
     print ('output ',output)

     for s in output:
        os=sortchars(s)
        n=find_element_in_list(os,digits)
        if n!=None:
                cifra=cifra+str(n)

     print (cifra,' digits ',digits)
     cu+=int(cifra)


#     break

  return cu

# r1=dia8_2(Di/'input8.txt')
# print (' result 8_2 ',r1)

def dia9_1 (root):
  print ('dia9.1')
  L = read_file (root)
  columns = len (L[0])
  matrix=[]
  for lin in L:
     line=[]
     for c in lin:
        line.append(int(c))
     matrix.append(line)
  lines = len(matrix)
  cu=0

  for li in range(lines):
     columns = len (matrix[li])
     for co in range(columns):
        minimo=matrix[li][co]
        ok=True
        ## up
        if li>0:
           ok=minimo<matrix[li-1][co]
        ## left
        if ok:
           if co>0:
              ok=minimo<matrix[li][co-1]

        ## rigth
        if ok:
           if co<columns-1:
              ok=minimo<matrix[li][co+1]

        ## down
        if ok:
           if li<lines-1:
              ok=minimo<matrix[li+1][co]
        if ok:
             print (matrix[li])
             print ('li ',li,' co ',co,' valor ',minimo)
             cu+=minimo+1
  return cu

# r1=dia9_1(Di/'input9.txt')
# print (' result 9_1 ',r1)

nueve=9

class Matrix:
    def __init__(self, Lcopy):
        self.matrix=[]
        for lin in Lcopy:
            line=[]
            for co in lin:
               line.append(co)
            self.matrix.append(line)

    def value (self,li,co):
       return self.matrix[li][co]

    def ifok(self,li,co):
       if li<0:
         return False
       if co<0:
         return False
       if li>=len(self.matrix):
         return False
       line=self.matrix[li]
       if co>=len(line):
         return False
       return self.value(li,co)!=nueve


class Tortuga:
    def __init__(self,lin,col,Lcopy):
        self.line = lin
        self.column = col
        self.Lmain= Lcopy
        self.valor = self.Lmain.value(lin,col)
        self.left = None
        self.up = None
        self.rigth = None
        self.down = None
        self.Lmain.matrix[self.line][self.column]=nueve


    def ifTurtle(self,li,c):
        if self.Lmain.ifok ( li,c):
           return Tortuga (li,c,self.Lmain)
        return None

    def cicle (self):
        cu=1
        self.Lmain.matrix[self.line][self.column]=nueve
        self.left = self.ifTurtle(self.line,self.column-1)
        self.up = self.ifTurtle (self.line-1,self.column)
        self.rigth= self.ifTurtle (self.line,self.column+1)
        self.down = self.ifTurtle (self.line+1,self.column)
        if self.left!=None:
                cu+=self.left.cicle()
        if self.up!=None:
                cu+=self.up.cicle()

        if self.rigth!=None:
                cu+=self.rigth.cicle()

        if self.down!=None:
                cu+=self.down.cicle()
        return cu

    def done(self):
        self.Lmain.matrix[self.line][self.column]=self.valor
        if self.left!=None:
                self.left.done()
                self.left=None
        if self.up!=None:
                self.up.done()
                self.up=None


        if self.rigth!=None:
                self.rigth.done()
                self.rigth=None


        if self.down!=None:
                self.down.done()
                self.down=None




def dia9_2 (root):
  print ('dia9.2')
  L = read_file (root)
  columns = len (L[0])
  matrix=[]
  for lin in L:
     line=[]
     for c in lin:
        line.append(int(c))
     matrix.append(line)
  lines = len(matrix)
  cu=0
  cuentas =[]
  for li in range(lines):
     columns = len (matrix[li])
     for co in range(columns):
        minimo=matrix[li][co]
        ok=True
        ## up
        if li>0:
           ok=minimo<matrix[li-1][co]
        ## left
        if ok:
           if co>0:
              ok=minimo<matrix[li][co-1]

        ## rigth
        if ok:
           if co<columns-1:
              ok=minimo<matrix[li][co+1]

        ## down
        if ok:
           if li<lines-1:
              ok=minimo<matrix[li+1][co]
        if ok:
             matriz=Matrix (matrix)
             turtle=Tortuga(li,co,matriz)
             num=turtle.cicle()
             turtle.done()
             print ('area ',num)
             cuentas.append(num)
  cu=1
  print('cuentas ' ,cuentas)
  sortlist=sorted(cuentas)
  lon=len(sortlist)

  print('sortlist ',lon,' : ',sortlist)
  for i in range (3):
        id=lon-i-1
        print('lon ',lon,' id ',id)
        n=int(sortlist[id])
        cu*=n

  return cu

# r1=dia9_2(Di/'input9.txt')
# print (' result 9_2 ',r1)

openclose = {
 '(':')',
 '[':']',
 '{':'}',
 '<':'>'
}

openclosepoints = {
 ')':3,
 ']':57,
 '}':1197,
 '>':25137
}

fixclosepoints = {
 ')':1,
 ']':2,
 '}':3,
 '>':4
}




def ifopen(cha):
  for v in openclose:
        if v==cha:
                return True
  return False


class Chunk:
    def __init__(self,star):
        self.start = star
        self.end=openclose[star]
        self.chucs =[]
        self.sub =None
        self.own =None


    def chunkopen(self,star):
        if self.sub==None:
           self.sub=Chunk(star)
           self.sub.own=self
           return self.sub
        else:
           return self.sub.chunkopen(star)

    def chunkclose(self,fin):
        if self.sub!=None:
           re= self.sub.chunkclose(fin)
           if re==None:
                return re
           if re:
                self.sub=None
                # print(' ****** closed ***')

           return False
        elif self.end==fin:
           return True
        else:
           return None

    def charTest(self,cha):
         iso=ifopen(cha)
         if iso:
                self.chunkopen(cha)
                return 0
         else:
                re=self.chunkclose(cha)
                if re==None:
                      return  openclosepoints[cha]
                return 0

    def score(self):
         re=0
         if self.sub!=None:
            re=self.sub.score()
         re*=5
         re+=fixclosepoints[self.end]
         print ('score ',re)
         return re


def isCorrupted(st):
  if ifopen(st[0]):
     chu=Chunk(st[0])
     for i in range(1,len(st)):
        re= chu. charTest(st[i])
        if re>0:
           return re
     return 0
  else:
      return openclosepoints[st[0]]

def isIncomplete(st):
  if ifopen(st[0]):
     chu=Chunk(st[0])
     for i in range(1,len(st)):
        re= chu. charTest(st[i])
        if re>0:
           print(' ****** nal ***')
           return 0
     return chu.score()
  else:
      return 0

def dia10_1 (root):
  print ('dia10.1')
  L = read_file (root)
  cu=0
  for s in L:
      print(s)
      n= isCorrupted(s)
      if n>0:
        cu+=n
  return cu


#  r1=dia10_1(Di/'input10.txt')
# print (' result 10_1 ',r1)

def dia10_2 (root):
  print ('dia10.2')
  L = read_file (root)
  mal=0
  bien=0
  num=0
  scores=[]
  for s in L:
      print(s)
      cu= isCorrupted(s)
      if cu>0:
        mal+=cu
      else:
        cu=isIncomplete(s)
        bien+=cu
        num+=1
        scores.append(cu)
  sor=sorted(scores)
  mid=num // 2
  return sor[mid]


r1=dia10_2(Di/'input10.txt')
print (' result 10_2 ',r1)




