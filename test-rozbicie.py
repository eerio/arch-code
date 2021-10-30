#!/usr/bin/python3
from numpy import prod

# x to the kth falling power
def desc(x, k):
    return prod([(x - i) for i in range(k)])

# \sum_{i=0}^{n-1} (-1)^i * (i^3)
def real(x):
    return sum( (-1)**i * (i ** 3) for i in range(x))

# \sum_{i=0}^{n-1} (-1)^i * (i^{kth falling})
def real_partial(n, k):
    return sum((-1)**x * desc(x, k) for x in range(n))

def my_partial(n):
    return real_partial(n, 3) + 3 * real_partial(n, 2) + real_partial(n, 1)

limit = 1000
for n in range(limit):
    assert real(n) == my_partial(n)
print('formula is correct for n <', limit)
