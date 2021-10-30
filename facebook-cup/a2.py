from functools import lru_cache
from string import ascii_uppercase
from collections import deque
from math import isinf
import re
from functools import lru_cache
import sys
import networkx as nx

def _price(lfrom: str, lto: str, trans: tuple, visited: set) -> float:
    if lfrom == lto:
        return 0.0

    if lfrom in visited:
        return float('inf')
    visited.add(lfrom)

    try:
        return 1.0 + min(
                _price(trans_to, lto, trans, visited.copy()) #, visited.copy())
                for (trans_from, trans_to) in trans
                if trans_from == lfrom
        )
    except ValueError:
        return float('inf')


def price(lfrom, lto, trans) -> float:
    G = nx.DiGraph()
    G.add_edges_from(trans)
    try:
        return len(dict(nx.all_pairs_shortest_path(G))[lfrom][lto]) - 1
    except KeyError:
        return float('inf')
    # return _price(lfrom, lto, trans, set())


def _solve(case: str, trans: tuple) -> int:
    return min(
            sum(price(l, target, trans) for l in case)
            for target in ascii_uppercase
    )

def solve(case, trans):
    res = _solve(case, trans)
    if isinf(res):
        return -1
    else:
        return int(res)

if __name__ == '__main__':
    t = int(input())
    for i in range(t):
        s = input()
        k = int(input())
        trans_strs = [input().strip() for _ in range(k)]
        trans = tuple((t[0], t[1]) for t in trans_strs)
        print(f'Case #{i + 1}:', solve(s, trans))

