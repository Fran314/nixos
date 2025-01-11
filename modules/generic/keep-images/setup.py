from setuptools import setup

setup(
    name='@pname@',
    version='@version@',
    author='deter0',
    description='@desc@',
    # install_requires=['pycairo', 'requests', 'PyGObject'],
    install_requires=['PyGObject'],
    scripts=[
        'keep-images',
    ],
)
