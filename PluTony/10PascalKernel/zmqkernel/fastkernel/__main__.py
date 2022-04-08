from ipykernel.kernelapp import IPKernelApp
from . import PascalKernel

IPKernelApp.launch_instance(kernel_class=PascalKernel)
