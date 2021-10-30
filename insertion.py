from typing import List
from bisect import bisect_right, insort_right


def insertion_sort(arr: List[int]) -> List[int]:
    for i in range(1, len(arr)):
        elem = arr[i]
        
        # insertion_point = i
        # while elem < arr[insertion_point - 1] and insertion_point > 0:
        #     insertion_point -= 1

        # insertion_point = bisect_right(arr, elem, lo=0, hi=i)
        
        # arr[insertion_point + 1: i + 1] = arr[insertion_point: i]
        # arr[insertion_point] = elem
        
        del arr[i]
        insort_right(arr, elem, lo=0, hi=i)
        
        print(arr)
    return arr

print(insertion_sort([1,10,-1,5]))
