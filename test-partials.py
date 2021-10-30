#!/usr/bin/python3
from numpy import prod

# x to the kth falling power
def desc(x, k):
    return prod([(x - i) for i in range(k)])

# \sum_{i=0}^{n-1} (-1)^i * (i^{kth falling})
def real_desc(n, k):
    return sum((-1)**x * desc(x, k) for x in range(n))

def my_desc(n, k):
    # base case: v
    phi = ((-1) ** (n+1)) / 2
    Phi = ((-1) ** (n+1) + 1) / 2

    if k == 0:
        return Phi
    elif k == 1:
        return n*phi - Phi/2
    elif k == 2:
        return desc(n, 2)*phi - n*phi + Phi/2
    elif k == 3:
        return desc(n,3)*phi -3/2*desc(n, 2)*phi +3/2*n*phi -3/4*Phi
    # recursive formula from pdf evaluated at x=n
    else:
        return desc(n, k) * ((-1)**(n+1))/2 - k/2*my_desc(n, k-1)

# \sum_{i=0}^{n-1} (-1)^i * (i^3)
def real(x):
    return sum( (-1)**i * (i ** 3) for i in range(x))

def my_partial(n):
    return real_desc(n, 3) + 3 * real_desc(n, 2) + real_desc(n, 1)


limit = 500
for k in range(4):
    for n in range(limit):
        try:
            assert real_desc(n, k) == my_desc(n, k)
        except AssertionError:
            print(n)
    print(f'formula for k={k} is correct for n <', limit)

import sys;sys.exit()

# formula from pdf, almost O(1)
def my(x):
    # let's just name these factors
    phi = ((-1) ** (x+1)) / 2
    Phi = ((-1) ** (x+1) + 1) / 4
    return desc(x, 3)*phi - 9/2*desc(x, 2)*phi + 7/2*x*phi-7/2*Phi


limit = 12
import math
for i in range(limit):
    a = real_desc(100, i)
    b = my_desc(100, i)
    print(a, b)
    assert math.isclose(a, b, rel_tol=1e-2)

print('Formula is correct for n <', limit)
