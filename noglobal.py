import types


def noglobal(fun):
    new_fun = types.FunctionType(
        fun.__code__,
        {},
        fun.__name__)
    return new_fun

def noglobal(fun):
    return exec(fun.__code__, {})
        
x = {'a': 0}

def foo():
    x['a'] += 1

@noglobal
def bar():
    x['a'] += 1

print(x)
foo()
print(x)
bar()
print(x)
