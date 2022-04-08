from distutils.core import setup


setup(
    name='fastkernel',
    version='1.1',
    packages=['fastkernel'],
    description='Simple pas example kernel for Jupyter',
    long_description='Simple pas example kernel for Jupyter',
    author='Antonio Alcazar Ruiz',
    author_email='mrgarciagarcia@gmail.com',
    url='https://github.com/miteruel/plutony',
    install_requires=[
        'jupyter_client', 'IPython', 'ipykernel'
    ],
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Programming Language :: Delphi :: Pascal',
    ],
)
