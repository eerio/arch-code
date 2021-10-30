from __future__ import annotations
from random import randint
#import sys
#sys.setrecursionlimit(100000)

def partition(arr):
    end_leq = -1
    pivot = arr[len(arr) - 1]

    for j in range(len(arr) ):
        if arr[j] <= pivot:
            end_leq += 1
            arr[end_leq], arr[j] = arr[j], arr[end_leq]

    return end_leq

def quicksort(arr):
    if len(arr) <= 1:
        return 
    p = partition(arr)
    
    l = arr[:p]
    r=arr[p+1:]
    quicksort(l)
    quicksort(r)
    arr[:p]=l
    arr[p+1:]=r
    #quicksort(arr[: p])
    #quicksort(arr[p + 1: ])

def quicksort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[0]
    return quicksort([x for x in arr if x < pivot]) + [pivot] + quicksort([x for x in arr[1: ] if x >= pivot])

def _quicksort(arr: list[int], start: int, end: int) -> None:
    if not start < end:
        return

    left, right = start, end
    pivot = arr[start]

    while left <= right:
        while arr[left] < pivot:
            left += 1

        while arr[right] > pivot:
            right -= 1

        if left <= right:
            arr[left], arr[right] = arr[right], arr[left]
            left, right = left + 1, right - 1
    
    _quicksort(arr, start, right)
    _quicksort(arr, left, end)

def quicksort(arr: list[int]) -> None:
    _quicksort(arr, 0, len(arr) - 1)

a = [1,2,3,999,-4,0,55,-1,-4,3,2,1,-9,1,1,-9,555,4]
quicksort(a)
print(a)

for _ in range(100):
    arr = [randint(-20000, 20000) for _ in range(1000)]
    barr = arr.copy()
    quicksort(arr)
    #assert quicksort(arr) == sorted(barr)
    assert arr == sorted(barr)
