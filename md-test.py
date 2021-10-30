from math import gcd

def lcm(a, b):
    return abs(a * b) // gcd(a, b)

nwd = gcd
nww = lcm

def A(a, b, c, d):
    return nww(nwd(a,b), nwd(c,d)) == nww(nwd(a,c), nwd(b,d))
def B(a, b, c):
    return nwd(a,nww(b,c)) == nwd(b, nww(a,c))
def C(a, b, c):
    return nww(a,nww(b,c)) == nww(b,nww(c,a))

