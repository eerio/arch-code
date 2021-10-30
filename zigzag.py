
"""
p     i        n
a   l s     i  g
y a   h  r
p     i

r = 4
mod = 6
0     6        12
1   5 7     11 13
2 4   8  10
3     9

0, 6, 12 ,...
1, 5, 7, 11, 13, ...
2, 4, 8, 10, ...
3, 9, ...
"""

def convert(s: str, r: int) -> str:
    # paypalishiring, 3 -> pay p ali s hir i ng
    # paypalishiring, 4 -> payp a l ishi r i ng

    # 0, 4, 8, ...
    # 1, 3, 5, 7, 9, ...
    # 2, 6, 10, ...
    result = ''
    result += s[:: r + (r - 2)]

    for i in range(1, r - 1):
        for j in range(i, len(s)):
            if j % (r + (r - 2)) in [i, r + (r - 2) - i]:
                result += s[j]

    result += s[r - 1 :: r + (r - 2)]
    return result


print(convert('PAYPALISHIRING', 3))
print(convert('PAYPALISHIRING', 4))
