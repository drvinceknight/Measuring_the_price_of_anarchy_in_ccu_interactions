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
