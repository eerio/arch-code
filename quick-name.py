#!/usr/bin/env python3
from string import ascii_lowercase
from random import choice, randint

alph = ascii_lowercase
vowels = 'aeiou'
cons = ''.join(set(alph).difference(set(vowels)))

def gen(len):
    v = [choice(vowels) for _ in range(len // 2)]
    c = [choice(cons) for _ in range(len // 2 + 1)]
    return ''.join(j+i for (i, j) in zip(v, c)) + c[3]

for _ in range(10):
    #len = randint(6,9)
    print(gen(7))

