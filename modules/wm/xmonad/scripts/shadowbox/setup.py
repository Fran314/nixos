from setuptools import setup

setup(
    name='@pname@',
    version='@version@',
    author='Fran314',
    description='@desc@',
    install_requires=['pycairo', 'requests', 'PyGObject'],
    scripts=[
        'shadowbox',
    ],
)
