"""
Script to run demand and pickle data attribute
"""
import csv
load('Measuring_the_price_of_anarchy_in_ccu_interactions.sage')

mmax = 16
nmax = 32

mu1 = .262
mu2 = .198

lmbda1 = 1.5
lmbda2 = 2.24

t = .8

# Function

@parallel
def poaforgivendemand(m,n):

    p = Model2([m, n], [mu1, mu2], [lmbda1, lmbda2])
    p.sweepcutoffs()
    p.obtainPoA(t)
    return p.PoA

# Script

filename = "M2-%s-%s-%s-%s-%s.csv" % (mu1, mu2, lmbda1, lmbda2, t)

parameters = [(m, n) for m in range(1, mmax + 1) for n in range(1, nmax + 1)]

f = open(filename, 'r')
csvrdr = csv.reader(f)
data = [row for row in csvrdr]
completedparameters = [(eval(row[0]),eval(row[1])) for row in data]
parameters = [row for row in parameters if row not in completedparameters]
f.close()

r = poaforgivendemand(parameters)
for result in r:
    print result
    m, n = result[0][0]
    data = result[1]
    f = open(filename, 'a')
    csvwtr = csv.writer(f)
    csvwtr.writerow([m, n, data])
    f.close()
