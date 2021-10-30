from heapq import heappush, heappop

a = [7,9,-3,5,-4,-100,10,15,-5,20]

heap = []
for n in a:
    heappush(heap, -n)

for i in range(5):
    print(f'#{i+1} largest element:', -heappop(heap))
