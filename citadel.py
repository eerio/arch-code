from __future__ import annotations
from collections import deque

nums = [1,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,7,11,11,11,11]

def solve(nums: list[int]) -> int:
    if not nums:
        return 0

    ind = 0
    result = 0
    t = nums[0]

    quotas = {
        '60s': (-1, 60),
        '10s': (-1, 20),
        '1s': (-1, 3)
    }

    while ind < len(nums):
        for key in quotas:
            quotas[key][0]
:wq


print(len(nums))
print(solve(nums))
