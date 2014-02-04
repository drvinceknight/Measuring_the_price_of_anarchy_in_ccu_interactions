"""
Re-writing everything to try and fix/figure out what is going no with Iza's messy code.
"""

class CCU():
    """
    A class for a CCU (the player of our game)
    """
    def __init__(self, capacity, servicerate, demandrate):
        self.capacity = capacity
        self.servicerate = servicerate
        self.demandrate = demandrate
        self.states = range(self.capacity + 1)
        self.pi = [0 for s in self.states]
    def throughput(self):
        return self.servicerate * sum([pair[0] * pair[1] for pair in zip(self.pi, range(self.capacity + 1))])
    def utilisation(self):
        return sum([pair[0] * pair[1] for pair in zip(self.pi, range(self.capacity + 1))]) / self.capacity


class strategypair():
    """
    A class to hold data
    """
    def __init__(self, throughput1, utilisation1, throughput2, utilisation2):
        self.throughput1 = throughput1
        self.throughput2 = throughput2
        self.utilisation1 = utilisation1
        self.utilisation2 = utilisation2
    def __str__(self):
        return str([self.throughput1, self.utilisation1, self.throughput2, self.utilisation2])


class Model():
    """
    A class for an interaction of CCUs
    """
    def __init__(self, capacitylist, serviceratelist, demandratelist):
        self.ccus = [CCU(capacitylist[0], serviceratelist[0], demandratelist[0]), CCU(capacitylist[1], serviceratelist[1], demandratelist[1])]  # Create two players in game
        self.dimensions = [c.capacity for c in self.ccus]
        self.demand = sum([c.demandrate for c in self.ccus])
        self.states = [vector([i,j]) for i in range(self.ccus[0].capacity + 1) for j in range(self.ccus[1].capacity + 1)]

    def steadystate(self, k1, k2):
        self.obtainQ(k1, k2)
        self.pi = kernel(self.Q).basis()[0]
        self.pi = vector([k / sum(self.pi) for k in self.pi])
        self.pi_dict = dict([[str(pair[0]), pair[1]] for pair in zip(self.states, self.pi)])
        for ccu in self.ccus:
            ccu.pi = [0 for s in self.states]
        for state in self.states:
            for i in range(len(self.ccus)):
                self.ccus[i].pi[state[i]] += self.pi_dict[str(state)]

    def sweepcutoffs(self):
        self.data = {}
        for k1 in range(self.ccus[0].capacity + 1):
            for k2 in range(self.ccus[1].capacity + 1):
                self.steadystate(k1, k2)
                self.data[str([k1,k2])] = strategypair(self.ccus[0].throughput(),self.ccus[0].utilisation(),self.ccus[1].throughput(),self.ccus[1].utilisation())

    def obtainPoA(self, target, hardconstraint=False):
        try:
            self.data
        except:
            self.sweepcutoffs()

        self.ccus[0].bestresponse = {k:0 for k in range(-1,self.ccus[0].capacity + 1)}
        for k2 in range(self.ccus[1].capacity + 1):
            dist = []
            for k1 in range(self.ccus[0].bestresponse[k2 - 1], self.ccus[0].capacity + 1):
                if hardconstraint:
                    if self.data[str([k1,k2])].utilisation1 <= target:
                        dist.append(abs(self.data[str([k1,k2])].utilisation1 - target))
                else:
                    dist.append(abs(self.data[str([k1,k2])].utilisation1 - target))
            self.ccus[0].bestresponse[k2] = min(range(len(dist)), key=lambda x: dist[x]) + self.ccus[0].bestresponse[k2 - 1]

        self.ccus[1].bestresponse = {k:0 for k in range(-1,self.ccus[1].capacity + 1)}
        for k1 in range(self.ccus[0].capacity + 1):
            dist = []
            for k2 in range(self.ccus[1].bestresponse[k1 - 1], self.ccus[1].capacity + 1):
                if hardconstraint:
                    if self.data[str([k1,k2])].utilisation1 <= target:
                        dist.append(abs(self.data[str([k1,k2])].utilisation2 - target))
                else:
                    dist.append(abs(self.data[str([k1,k2])].utilisation2 - target))
            self.ccus[1].bestresponse[k1] = min(range(len(dist)), key=lambda x: dist[x]) + self.ccus[1].bestresponse[k1 - 1]

        self.Nash = []
        for k2 in self.ccus[0].bestresponse:
            if self.ccus[1].bestresponse[self.ccus[0].bestresponse[k2]] == k2:
                self.Nash.append([self.ccus[0].bestresponse[k2],k2])

        self.optimalthroughput = max([self.data[pair].throughput1 + self.data[pair].throughput2 for pair in self.data])
        self.PoA = self.optimalthroughput / min([self.data[str(ne)].throughput1 + self.data[str(ne)].throughput2 for ne in self.Nash])

    def obtainQ(self, k1, k2):
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
