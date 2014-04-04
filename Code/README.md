# Code for the paper entitled: "Measuring the Price of Anarchy in Critical Care Unit Interactions"

This repository contains various files.

- The main file with the required classes is `main.sage`. That library is well documented.

    The following is an example of how to obtain the PoA for a small problem with target .4:

        sage: m, n, mu1, mu2, lmbda1, lmbda2 = 2, 3, 1, .5, 2, 2
        sage: p = Model1([m, n],[mu1, mu2],[lmbda1, lmbda2])
        sage: p.obtainPoA(.4)
        sage: p.PoA

    This returns `2.14177802814966`.

- `M1rundemand.sage` and `M2rundemand.sage`: these run demand experiments (code is parallelized) for model 1 and 2 respectively. The code outputs a `.p` file which is a pickled file of the relevant data dictionary. While the pickled files take more space there are useful when needed to quickly obtain similar results (although they take a while to load given their size - this is perhaps a bit lazy and doing everything via csv would have been better...).
- `M1analysedemand.sage` and `M2analysedemand.sage`: these analyse the relevant pickle files.
- `M1runcapacity.sage` and `M2runcapacity.sage`: these run capacity experiments (code is parallelized) for model 1 and 2 respectively. The code outputs a `.p` file which is a pickled file of the relevant data dictionary.
- `M1analysecapacity.sage` and `M2analysecapacity.sage`: these analyse the relevant pickle files.

*Note that the Sage worksheet used to analyse the data and obtain the plots in the paper can be found [here](https://sage.maths.cf.ac.uk/home/pub/122/).*
=======
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
