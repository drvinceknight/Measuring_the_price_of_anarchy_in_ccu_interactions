"""
Script to run demand and pickle data attribute
"""
import pickle
import csv
load('Measuring_the_price_of_anarchy_in_ccu_interactions.sage')

m = 8
n = 16

mu1 = .262
mu2 = .198

baselmbda1 = 1.5
baselmbda2 = 2.24


d = pickle.load(open('M2-%s-%s-%s-%s-%s-%s.p' % (m, n, mu1, mu2, baselmbda1, baselmbda2), 'r'))

# Script

filename = "M2-%s-%s-%s-%s-%s-%s.csv" % (m, n, mu1, mu2, baselmbda1, baselmbda2)
f = open(filename, 'w')
csvwtr = csv.writer(f)
csvwtr.writerow(['target', 'demand', 'PoA'])


for x in d:
    lmbda1, lmbda2 = (1+x)*baselmbda1, (1+x)*baselmbda2
    p = Model2([m, n], [mu1, mu2], [lmbda1, lmbda2])
    p.data = d[x]
    for t in srange(0,1,.005):
        p.obtainPoA(t)
        csvwtr.writerow([t,x,p.PoA])

f.close()
