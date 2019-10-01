#! python


FIT = 0
UNFIT = 1
DEAD = 2
EXERCISE = 1
RELAX = 0

exerciseProbabilities = [[0.891, 0.009, 0.100], [0.180, 0.720, 0.100], [0, 0, 1]]
exerciseRewards = [[8, 8, 0], [0, 0, 0], [0, 0, 0]]

relaxProbabilities = [[0.693, 0.297, 0.01], [0.0, 0.99, 0.01], [0, 0, 1]]
relaxRewards = [[10, 10, 0], [5, 5, 0], [0, 0, 0]]


def main():
    n = int(input("Please enter a value for n (n >= 0): "))
    while n < 0:
        n = int(input("(n >= 0)!! Please enter a value for n: "))

    global g
    g = float(input("Please Enter a value for G (0<G<1): "))
    while g <= 0 or g >= 1:
        g = float(input("(0<G<0)!! Please enter a value for G: "))

    s = input("Please Enter a state (Fit, Unfit, or Dead) capitalised and in quotation marks (i.e 'Fit'):")
    while s != "Fit" and s != "Unfit" and s != "Dead":
        s = input("State must be either Fit, Unfit or Dead!! Please Enter a state: ")

    if s == "Fit":
        state = FIT
    elif s == "Unfit":
        state = UNFIT
    else:
        state = DEAD
    if q(state, EXERCISE, n) >= q(state, RELAX, n):
        decision = "Exercise"
    else:
        decision = "Relax"

    for i in range(0, n+1):
        print('n= %d Exercise: %f Relax: %f pi: %s' % (i, q(state, EXERCISE, i), q(state, RELAX, i), decision))


def q(state, action, n):
    q0 = (p(state, action, FIT) * r(state, action, FIT)) + (p(state, action, UNFIT) * r(state, action, UNFIT))
    if n == 0:
        return q0
    else:
        return q0 + (g * ((p(state, action, FIT) * v(FIT, n-1)) + (p(state, action, UNFIT) * v(UNFIT, n-1))))


def p(state, action, resultstate):
    if action == EXERCISE:
        return exerciseProbabilities[state][resultstate]
    else:
        return relaxProbabilities[state][resultstate]


def r(state, action, resultstate):
    if action == EXERCISE:
        return exerciseRewards[state][resultstate]
    else:
        return relaxRewards[state][resultstate]


def v(state, n):
    return max(q(state, EXERCISE, n), q(state, RELAX, n))


if __name__ == '__main__':
    main()
