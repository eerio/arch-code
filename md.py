
p = 3

for a in range(1000):
    result = (a ** (a ** (p-1))) % p == a % p
    if not result:
        print(a)
