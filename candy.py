from typing import List


def foo(ratings: List[int]) -> int:
    candies = [0 for _ in ratings]
    candies[0] = 1

    for i, (rate, nxt_rate) in enumerate(zip(ratings, ratings[1: ])):
        if nxt_rate > rate:
            candies[i + 1] = candies[i] + 1
        else:
            candies[i + 1] = 1

    for i in range(len(ratings) - 1, 0, -1):
        rate, prev_rate = candies[i], candies[i - 1]
        if prev_rate > rate:
            candies[i - 1] = max(candies[i - 1], candies[i] + 1)

    return sum(candies)

def test() -> None:
    print(foo([1, 2, 3, 1, 2, 3]))
    foo([1, 2, 3, 5, 6, 7])
    return 
    foo([1, 38, 21, 1])
    foo([1, 2, 3, 1, 2, 3])
    foo([1, 2, 2, 10, 1])
    foo([1, 2, 2, 10, 9, 8, 1])
    foo([10, 8, 6, 1, 2])

if __name__ == '__main__':
    test()

