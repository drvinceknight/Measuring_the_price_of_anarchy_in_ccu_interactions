#!/usr/bin/env python
from __future__ import division
import copy
import csv
"""Measuring the Price of Anarchy in Critical Care Unit Interactions

Code to obtain the PoA by exhaustive search of best responses for model 1 of the paper.

usage:
    python CCU_QG_M1.py [t]

The above will run a basic example with parameters written after `if __name__ == '__main__'` statement in this file.
If a value of t is passed then the PoA will be calculated with that value of t as a target.

Alternatively (and indeed how this was run for the paper) this file can be used as a library: `import CCU_QG_M1`.
"""


def name_state_i(k,n):
    """
    A function used to keep track of states for player 1.
    """
    return int((k-1)/(n+1))

def name_state_j(k,n):
    """
    A function used to keep track of states for player 2.
    """
    return (k-1)%(n+1)

def q(a,b,c,d,k1,k2,mu1,mu2,lmbda1,lmbda2,m,n):
    """
    Returns the probability of going from state (a,b) to state (c,d), assuming thresholds k1, k2. This is the transition rates for model 1.
    """

    if (a-c,b-d)==(1,0):
        return mu1*a
    if (a-c,b-d)==(0,1):
        return mu2*b
    if (a < k1 and b < k2) and (a-c,b-d)==(-1,0):
        return lmbda1
    if (a < k1 and b < k2) and (a-c,b-d)==(0,-1):
        return lmbda2
    if ((a-c,b-d)==(-1,0) and a < k1 and b >= k2) or ((a-c,b-d)==(0,-1) and a >= k1 and b < k2):
        return lmbda1 + lmbda2
    if (a,b) == (c,d):
        return -sum([q(a,b,i,j,k1,k2,mu1,mu2,lmbda1,lmbda2,m,n) for i in range(m+1) for j in range(n+1) if (i,j)!=(a,b)])  # Obtain diagonal entries
    return 0


def Transition_Rate_Matrix(m,n,k1,k2,mu1,mu2,lmbda1,lmbda2):
    """
    Obtain the transition rate matrix.
    """
    return [[q(name_state_i(u,n),name_state_j(u,n),name_state_i(l,n),name_state_j(l,n),k1,k2,mu1,mu2,lmbda1,lmbda2,m,n) for l in range(1,(m+1)*(n+1)+1)] for u in range(1,(m+1)*(n+1)+1)]


def GaussianElimination(Q, precision=10):
    """
    Carry out basic Gaussian Elimination on a matrix (returns normalised probability distribution)
    """
    n=len(Q)
    A=zip(*Q)
    A=[list(row) for row in A]

    for i in range(n):
        if A[i][i]!=0:
            for j in range(i+1,n):
                A[j][i]/=-A[i][i]
            for j in range(i+1,n):
                for k in range(i+1,n):
                    A[j][k]+=A[j][i]*A[i][k]

    boolean=True
    while boolean:
        try:
            n_star=[round(A[i][i],precision) for i in range(n)].index(0)
            if len([round(A[i][i],precision) for i in range(n) if round(A[i][i],precision)==0])==1:
                boolean=False
        except:
            precision+=1

    x=[0 for i in range(n)]
    x[n_star]=1

    for i in range(n-1,-1,-1):
        if i!=n_star:
            for j in range(i,n):
                x[i]+=A[i][j]*x[j]
            x[i]/=-A[i][i]

    x=[round(e/sum(x),2*precision) for e in x]
    return x

def Markov_Chain_Solver(Q,k1,k2,m,n,cache={}):
    """
    Basic linear algebra techniques to obtain the steady state probabilities for our matrix. Uses caching so things aren't calculated twice later on (the code later on should be re-written but this is a quick fix).
    """
    inputstr = "%s-%s-%s-%s-%s" % (Q,k1,k2,m,n)
    if inputstr in cache:  # Checking if this value is cached
        return cache[inputstr]

    x=GaussianElimination(Q)
    s = len(Q)
    probnh=[0 for i in range(m+1)]
    for u in range(s):
        for i in range(m+1):
            if name_state_i(u+1,n)==i:
                probnh[i]+=x[u]

    probrg=[0 for j in range(n+1)]
    for u in range(s):
        for j in range(n+1):
            if name_state_j(u+1,n)==j:
                probrg[j]+=x[u]
    cache[inputstr] = [probnh, probrg]
    return [probnh,probrg]


def utilisation(prob):
    """
    Obtain the utilisation for a given probability.
    """
    m=len(prob)
    util=0
    for j in range(m):
        util+=prob[j]*j
    util/=(m-1)
    return util

def throughput(mu,prob):
    """
    Obtain the throughouput for a given probability
    """
    m=len(prob)
    return sum([prob[i]*i*mu for i in range(m)])

def PoA(m,n,mu1,mu2,lmbda1,lmbda2,target):
    """
    Obtains the PoA for a given system and a given target.
    """

    cache = {}

    bestrg={}
    for k2 in range(n+1):  # Loop over all strategies for player 1
        devsqmin=100
        for k1 in range(m+1):  # Find the best response for player 2
            prob_rg=Markov_Chain_Solver(Transition_Rate_Matrix(m,n,k1,k2,mu1,mu2,lmbda1,lmbda2),k1,k2,m,n, cache=cache)[1]
            util=utilisation(prob_rg)
            if (util-target)**2<devsqmin and util<target:
                devsqmin = (util - target) ** 2  # Keep new best utilisation
                bestrg[k2] = k1

    bestnh={}
    through={}

    for k1 in range(m+1):  # Loop over all stratgies for player 2
        devsqmin=100
        for k2 in range(n+1):  # Find the best response for player 1
            prob_nh,prob_rg = Markov_Chain_Solver(Transition_Rate_Matrix(m,n,k1,k2,mu1,mu2,lmbda1,lmbda2),k1,k2,m,n,cache=cache)  # Keeping track of both probabilities
            util = utilisation(prob_nh)
            if (util-target)**2<devsqmin and util<target:
                devsqmin=(util-target)**2  # Keep new best utilisation
                bestnh[k1] = k2
                through['[%s,%s]'%(k1,k2)] = throughput(mu2,prob_rg) + throughput(mu1,prob_nh)


    Nash_dict={}

    for rg_best_key in bestrg:  # Loop over all best responses
        if bestnh[bestrg[rg_best_key]] == rg_best_key:  # Identify intersection of best responses
            k1 = rg_best_key
            k2 = bestrg[rg_best_key]
            prob_nh,prob_rg = Markov_Chain_Solver(Transition_Rate_Matrix(m,n,k1,k2,mu1,mu2,lmbda1,lmbda2),k1,k2,m,n)
            Nash_dict['[%s,%s]'%(k1,k2)]=throughput(mu2,prob_rg)+throughput(mu1,prob_nh)

    Worst_Nash_Throughput = Nash_dict[min(Nash_dict,key=Nash_dict.get)]
    Optimal_Throughput = through[max(through, key=through.get)]


    if Worst_Nash_Throughput==0:
        PoA="oo"
    else:
        PoA=Optimal_Throughput/Worst_Nash_Throughput
    return PoA

if __name__ == '__main__':
    from sys import argv
    if len(argv)>1:
        t = float(argv[1])
    else:
        t = .8
    m=8
    n=16

    mu1=.262
    mu2=.198

    lmbda1=1.5
    lmbda2=2.24

    print PoA(m, n, mu1, mu2, lmbda1, lmbda2, t)
