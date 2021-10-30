from collections import Counter
from string import ascii_uppercase

vow = 'AEIOU'
cons = ''.join(l for l in ascii_uppercase if l not in vow)

def solve(case: str) -> int:
    vow_cnt = Counter(''.join(l for l in case if l in vow))
    cons_cnt = Counter(''.join(l for l in case if l in cons))
    
    n_vows, n_cons = sum(vow_cnt.values()), sum(cons_cnt.values())

    best_vow = vow_cnt.most_common()[0][1] if n_vows else 0
    best_cons = cons_cnt.most_common()[0][1] if n_cons else 0
    
    to_vow, to_cons = n_cons + 2 * (n_vows - best_vow), n_vows + 2 * (n_cons - best_cons)

    return min(to_vow, to_cons)


t = int(input())
cases = [input() for _ in range(t)]

for i, case in enumerate(cases):
    print(f'Case #{i + 1}:', solve(case))
