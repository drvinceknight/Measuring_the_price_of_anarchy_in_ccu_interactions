"""
Script to run demand and pickle data attribute
"""
import pickle
load('Measuring_the_price_of_anarchy_in_ccu_interactions.sage')

m = 8
n = 16

mu1 = .262
mu2 = .198

baselmbda1 = 1.5
baselmbda2 = 2.24

# Function

@parallel
def pickleforgivendemand(x):

    lmbda1 = (1 + x) * baselmbda1
    lmbda2 = (1 + x) * baselmbda2

    p = Model1([m, n], [mu1, mu2], [lmbda1, lmbda2])
    p.sweepcutoffs()
    p.obtainPoA(.6)
    print p.PoA
    return p.data

# Script

filename = "M1-%s-%s-%s-%s-%s-%s.p" % (m, n, mu1, mu2, baselmbda1, baselmbda2)

d = {}
parameters = srange(-.9,2,.005)

r = pickleforgivendemand(parameters)
for result in r:
    x = result[0][0][0]
    data = result[1]
    d[x] = data
    f = open(filename, 'w')
    pickle.dump(d, f)
    f.close()
