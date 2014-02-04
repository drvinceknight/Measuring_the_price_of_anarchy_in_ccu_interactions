# Code for the paper entitled: "Measuring the Price of Anarchy in Critical Care Unit Interactions"

This repo contains two files:

- CCU_QG_M1.py
- CCU_QG_M2.py

Both contain functions that can be used to obtain the results shown in the paper entitled "Measuring the Price of Anarchy in Critical Care Unit Interactions" by Komenda, I. Griffiths, G. and Knight, VA.

To run a basic example type:

    $ python CCU_GQ_M1.py

The output is 1, implying a PoA of 1 for the base parameters of the paper for Model 1.

The scripts can be passed a target value:

    $ python CCU_GQ_M1.py .6

This returns a value of ...

The files can also be used as libraries and imported in scripts: `import CCU_GC_M1`.

Notes: Technically, the coding in this could and should be improved. The PoA calculation has a caching mechanism which improves the speed but even this could be made faster.
