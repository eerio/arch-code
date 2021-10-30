
# yield consecutive numerators and first part of denominators
def phi_seq():
    while True:
        yield (1, 1)

def tan_seq(z: float):
    yield (z, 1)

    k = 1
    while True:
        yield (-z*z, 2*k + 1)
        k += 1


def continued_fract(seq: iter, k: int) -> float:
    assert k >= 0

    num, denom = next(seq)

    if not k:
        return num / denom

    return num / (denom + continued_fract(seq, k - 1))

from math import tan, pi, sin
x = pi/7

def sin_taylor(z: float):
    result = 0
    n = 0

    # sin(x) = sum_0^inf (-1)^n / (2n+1)! * x^(2n+1)
    neg_one = 1
    fact = 1
    z_pow = z
    result += neg_one / fact * z_pow
    yield result
    n += 1

    while True:
        neg_one *= -1
        fact *= 2*n * (2*n + 1)
        z_pow *= z * z
        result += neg_one / fact * z_pow
        yield result
        n += 1

print(f'find sin({x}) by taylor')
for i, approx in zip(range(10), sin_taylor(x)):
    print('actual sin:', sin(x), 'taylor approx:', approx)

print(f'find tan({x})')
for i in range(10):
    y = continued_fract(tan_seq(x), i)
    print('actual tan:', tan(x), 'approx:', y)

