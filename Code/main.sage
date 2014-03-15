"""
Main body of classes for the paper entitled 'Measuring the Price of Anarchy in Critical Care Unit Interactions'.

The abstract for this paper reads as follows:

> Hospital throughput is often studied and optimised in isolation, ignoring the interactions between hospitals.
> In this paper Critical Care Unit (CCU) interaction is placed within a game theoretic framework.
> The methodology involves the use of a normal form game underpinned by a two dimensional continuous Markov chain.
> A theoretical result is given that ensures the existence of a Nash equilibrium.

> The effect of target policies is investigated justifying the use of these to align the interests of individual hospitals and social welfare.
> In particular, we identify the lowest value of a utilisation target that aligns these.

Usage:

There are 3 classes in this script:

- CCU: a class for each CCU (corresponding to players of our game);
- StrategyPair: a class to hold data for a given pair of cutoffs;
- Model: a class for a game theoretical model (uses the above two classes). This class is inherited by two further classes:

    - Model 1: The class for the strict diversion model of the paper;
    - Model 2: The class for the soft diversion model of the paper.
"""

class CCU():
    """
    A class for a CCU (the player of our game)

    Attributes:

        - capacity: c
        - servicerate: mu
        - demandrate: lambda
        - states: a list of integers corresponding to occupancy levels
        - pi: propability distribution over the states

    Methods:

        - throughput: a method that calculates the throughput for the current pi attribute
        - utilisation: a method that calculates the utilisation for the current pi attribute

    """
    def __init__(self, capacity, servicerate, demandrate):
        """
        Initialises a ccu with given attributes (notes that pi is initialised as 0).
        """
        self.capacity = capacity
        self.servicerate = servicerate
        self.demandrate = demandrate
        self.states = range(self.capacity + 1)
        self.pi = [0 for s in self.states]
    def throughput(self):
        """
        Returns the throughput for self.pi
        """
        return self.servicerate * sum([pair[0] * pair[1] for pair in zip(self.pi, range(self.capacity + 1))])
    def utilisation(self):
        """
        Returns the utilisation for self.pi
        """
        return sum([pair[0] * pair[1] for pair in zip(self.pi, range(self.capacity + 1))]) / self.capacity


class StrategyPair():
    """
    A class to hold data (doesn't do anything clever at all, just an easy way to point towards the correct data).

    Attributes:

        - utilisation1: utilisation for CCU1
        - utilisation2: utilisation for CCU2
        - utilisation1: utilisation for CCU1
        - utilisation2: utilisation for CCU2
    """
    def __init__(self, throughput1, utilisation1, throughput2, utilisation2):
        self.throughput1 = throughput1
        self.throughput2 = throughput2
        self.utilisation1 = utilisation1
        self.utilisation2 = utilisation2
    def __str__(self):
        """
        The string representation of a strategy pair.

        Prints a 4-tuple with the data.
        """
        return str([self.throughput1, self.utilisation1, self.throughput2, self.utilisation2])


class Model():
    """
    A class for an interaction of CCUs

    Attributes:

        - ccus: a list of instances of the CCU class
        - dimensions: a list of the capacities of the ccus
        - demand: a list of the demand rate for each ccus
        - states: the two dimensional state space of the underlying Markov chain

        - Q: the transition rate matrix for the underlying Markov chain (obtained by running the obtaniQ method)
        - pi: the steady state distribution for the two dimensional chain (obtained by running the steadystate method)
        - pi_dict: a dictionary {state: probability}

        - data: a dictionary {state: StrategyPair} (obtained by running sweepcutoffs)

        - Nash: a list of Nash equilibria (obtained by running obtainPoA)
        - optimalthroughput: the optimal throughput (obtained by running obtainPoA)
        - PoA: the PoA (obtained by running obtainPoA)

    Methods:

        - steadystate: calculates the steady state vectors for each CCU for a given set of threshold strategies.
        - sweepcutoffs: sweeps through the entire set of threshold strategy pairs and obtains corresponding instance of StrategyPair (ie saves throughput and utilisation data).
        - obtainPoA: will sweep cutoffs if needed but otherwise will find pair of best responses. Note that this takes advantage of problem structure proved in the paper (ie the non decreasing nature of the best response function).
    """
    def __init__(self, capacitylist, serviceratelist, demandratelist):
        """
        Initiliases the instance by creating and storing the relevant instances of the CCU class.
        """
        self.ccus = [CCU(capacitylist[0], serviceratelist[0], demandratelist[0]), CCU(capacitylist[1], serviceratelist[1], demandratelist[1])]  # Create two players in game
        self.dimensions = [c.capacity for c in self.ccus]
        self.demand = sum([c.demandrate for c in self.ccus])
        self.states = [vector([i,j]) for i in range(self.ccus[0].capacity + 1) for j in range(self.ccus[1].capacity + 1)]

    def steadystate(self, k1, k2):
        """
        Obtains the steady state distribution of the two dimensional Markov chain for a given set of threshold policies.
        """
        self.obtainQ(k1, k2)  # Obtains the transition rate matrix Q (This is different for each model and corresponds to either equation 3 or 4 of the paper).
        self.pi = kernel(self.Q).basis()[0]  # Obtain a basis of the Kernel of Q
        self.pi = vector([k / sum(self.pi) for k in self.pi])  # Normalises the basis to get a steady state distribution
        self.pi_dict = dict([[str(pair[0]), pair[1]] for pair in zip(self.states, self.pi)])  # Obtains a dictionary with keys: states and values: probabilities.
        for ccu in self.ccus:  # Loops over the CCUs to obtain the relevant steady state probalities for each (from the overall steady state probabilities)
            ccu.pi = [0 for s in self.states]  # sets probabilities to zero before overwriting
        for state in self.states:  # Loop over all states of 2 dimensional chain and sum where relevant
            for i in range(len(self.ccus)):
                self.ccus[i].pi[state[i]] += self.pi_dict[str(state)]

    def sweepcutoffs(self):
        """
        Obtains the throughout and utilisation for each and every strategy pair.
        """
        self.data = {}
        for k1 in range(self.ccus[0].capacity + 1):
            for k2 in range(self.ccus[1].capacity + 1):
                self.steadystate(k1, k2)  # For any given pair calculates steady state vetors (for overall chain and each ccu)
                self.data[str([k1,k2])] = StrategyPair(self.ccus[0].throughput(),self.ccus[0].utilisation(),self.ccus[1].throughput(),self.ccus[1].utilisation())  # Updates data dictionary (note that I'm using str as key value but technically should use tuples instead)

    def obtainPoA(self, target, hardconstraint=False):
        """
        Calculate the PoA of the model.

        Takes advantage of problem structure (non-decreasing nature of best response function) and also claculates 'worst-case' Nash equilibria.
        """
        try:  # If data already obtained (note that obtaining the data is independent of t, so if demand does not change there is no need to resolve the Markov chain).
            self.data
        except:
            self.sweepcutoffs()

        # Looking for the first CCUs best reponses

        self.ccus[0].bestresponse = {-1:0}  # Sets best response to be 0 for fake strategy -1 so that can use structure of problem (for state 0 we will start to look at best response for -1 etc...)
        for k2 in range(self.ccus[1].capacity + 1):  #  Loop over all strategies of the second CCU
            dist = []  # Create empy list to hold distance from target
            for k1 in range(self.ccus[0].bestresponse[k2 - 1], self.ccus[0].capacity + 1):  # Looping over potential values of k1 (to find best response), starting at value of best response for previous value of k2
                if hardconstraint:  # This is by default set to False (here in case at some point wanted to look at t being a hard upper bound on utilisation: note that this would not necessarily imply that a best response exists.
                    if self.data[str([k1,k2])].utilisation1 <= target:
                        dist.append(abs(self.data[str([k1,k2])].utilisation1 - target))
                else:
                    dist.append(abs(self.data[str([k1,k2])].utilisation1 - target))  # Append the distance (absolute value of difference) to dist
            self.ccus[0].bestresponse[k2] = min(range(len(dist)), key=lambda x: dist[x]) + self.ccus[0].bestresponse[k2 - 1]  # Find k1 that minimises this distance

        self.ccus[1].bestresponse = {-1:0}  # Sets best response to be 0 for fake strategy -1 so that can use structure of problem (for state 0 we will start to look at best response for -1 etc...)
        for k1 in range(self.ccus[0].capacity + 1):
            dist = []  # Create empy list to hold distance from target
            for k2 in range(self.ccus[1].bestresponse[k1 - 1], self.ccus[1].capacity + 1):  # Looping over potential values of k2 (to find best response), starting at value of best response for previous value of k1
                if hardconstraint:  # This is by default set to False (here in case at some point wanted to look at t being a hard upper bound on utilisation: note that this would not necessarily imply that a best response exists.
                    if self.data[str([k1,k2])].utilisation1 <= target:
                        dist.append(abs(self.data[str([k1,k2])].utilisation2 - target))
                else:
                    dist.append(abs(self.data[str([k1,k2])].utilisation2 - target))  # Append the distance (absolute value of difference) to dist
            self.ccus[1].bestresponse[k1] = min(range(len(dist)), key=lambda x: dist[x]) + self.ccus[1].bestresponse[k1 - 1]  # Find k2 that minises this distance

        self.Nash = []  # Find equilibria
        for k2 in self.ccus[0].bestresponse:
            if self.ccus[1].bestresponse[self.ccus[0].bestresponse[k2]] == k2:  # Looks for pairs of best reponses
                self.Nash.append([self.ccus[0].bestresponse[k2],k2])  # Add to Nash list

        self.optimalthroughput = max([self.data[pair].throughput1 + self.data[pair].throughput2 for pair in self.data])  # Find optimal throughput

        self.PoA = self.optimalthroughput / min([self.data[str(ne)].throughput1 + self.data[str(ne)].throughput2 for ne in self.Nash])  # Find PoA by finding worst Nash

    def obtainQ(self, k1, k2):
        """
        Obtains transition matrix Q, using method q for each state to state transition. This depends on each model.

        Every calculation done in rationals so as to avoid numerical error.
        """
        self.Q=matrix(QQ,[[self.q(s1, s2, k1, k2) for s2 in self.states] for s1 in self.states])

class Model1(Model):
    def q(self, state1, state2, k1, k2):
        """
        Returns the probability of going from state1 to state2, assuming thresholds k1, k2. This is the transition rates for model 1.
        """
        if state1 - state2 == vector([1,0]):
            return Rational(self.ccus[0].servicerate*state1[0])
        if state1 - state2 == vector([0,1]):
            return Rational(self.ccus[1].servicerate*state1[1])
        if (state1[0] < k1 and state1[1] < k2) and state1 - state2 == vector([-1,0]):
            return Rational(self.ccus[0].demandrate)
        if (state1[0] < k1 and state1[1] < k2) and state1 - state2 == vector([0,-1]):
            return Rational(self.ccus[1].demandrate)
        if (state1[0] < k1 and state1[1] >= k2 and state1 - state2 == vector([-1,0])) or (state1[0] >= k1 and state1[1] < k2 and state1 - state2 == vector([0,-1])):
            return Rational(self.ccus[0].demandrate + self.ccus[1].demandrate)
        if state1 == state2:
            return -sum([Rational(self.q(state1, s, k1, k2)) for s in self.states if s != state1])  # Obtain diagonal entries
        return 0


class Model2(Model):
    def q(self, state1, state2, k1, k2):
        """
        Returns the probability of going from state1 to state2, assuming thresholds k1, k2. This is the transition rates for model 1.
        """
        if state1 - state2 == vector([1,0]):
            return Rational(self.ccus[0].servicerate*state1[0])
        if state1 - state2 == vector([0,1]):
            return Rational(self.ccus[1].servicerate*state1[1])
        if ((state1[0] < k1 and state1[1] < k2) or (state1[0] >= k1 and state1[1] >= k2)) and state1 - state2 == vector([-1,0]):
            return Rational(self.ccus[0].demandrate)
        if ((state1[0] < k1 and state1[1] < k2) or (state1[0] >= k1 and state1[1] >= k2)) and state1 - state2 == vector([0,-1]):
            return Rational(self.ccus[1].demandrate)
        if ((state1[0] < k1 and state1[1] >= k2) and state1 - state2 == vector([-1,0])) or ((state1[0] >= k1 and state1[1] < k2) and state1 - state2 == vector([0,-1])):
            return Rational(self.ccus[0].demandrate + self.ccus[1].demandrate)
        if state1 == state2:
            return -sum([Rational(self.q(state1, s, k1, k2)) for s in self.states if s != state1])  # Obtain diagonal entries
        return 0
