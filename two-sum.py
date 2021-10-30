from typing import List
# nums, target = [2, 7, 11, 15], 9
# nums, target = [3,2,4], 6
nums, target = [3,3],6



def solve(nums: list, target: int) -> List[int]:
    known = {}
    for i, n in enumerate(nums):
        diff = target - n
        if diff in known:
            return known[diff], i
        else:
            known[n] = i

print(solve(nums, target))
