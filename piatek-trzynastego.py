import datetime

today = datetime.datetime.today()
print(today.weekday)

def get_weekday(n: int) -> int:
    return (today + datetime.timedelta(days=n)).weekday()

def get_day(n: int) -> int:
    return (today + datetime.timedelta(days=n)).day

def search():
    shift = 0
    
    while True:
        if get_weekday(shift) == 4 and get_day(shift) == 13:
            yield today + datetime.timedelta(days=shift)

        shift += 1

for i, day in zip(range(10), search()):
    print(day)
        
