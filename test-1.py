from numpy import prod

# falling factorial
def desc(x, k):
    return prod([x-i for i in range(k)])

def real(x, k):
    return sum( (-1)**i * desc(i, k) for i in range(x))

def my(x, k):
    if k <= 0:
        return ((-1)**(x+1) + 1)/2
    return desc(x, k) * (-1)**(x+1)/2 - k/2 * my(x, k-1)

def three(x):
    f = ((-1) ** (x+1)) / 2
    return desc(x, 3)*f-3/2*desc(x,2)*f+3/2*x*f-3/4*((-1)**(x+1)+1)/2

def final_me(x):
    f = ((-1) ** (x+1)) / 2
    g = ((-1) ** (x+1) + 1) / 2
    return desc(x, 3)*f + desc(x,2)*f*3/2 + x*f*1/2 - 3/4*g

def final_part(x):
    return my(x, 3) + 3*my(x, 2) + my(x, 1)

def final_ok(x):
    return sum( (-1)**i * (i**3) for i in range(x))


p=10

print('test: 3sum',
#print('real:', [final_ok(x) for x in range(p)])
#print('me:  ', [final_part(x) for x in range(p)])

import math
assert all(math.isclose(final_ok(x), final_part(x), abs_tol=1e-6) for x in range(p))
#assert all(math.isclose(final_ok(x), final_part(x), abs_tol=1e-6) for x in range(p))

import sys
sys.exit()
print('d3:')
p=10
print('real:', [real(x, 3) for x in range(p)])
print('my:  ', [three(x) for x in range(p)])

for k in range(4):
    print(f'for desc={k}:')
    p=10
    print('real:', [int(real(x, k)) for x in range(p)])
    print('my:  ', [int(my(x, k)) for x in range(p)])
