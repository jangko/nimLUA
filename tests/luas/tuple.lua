assert(tup.dino({a = "hello", b = 10}) == "hello")

local x = tup.saurus("world")
assert(x.a == "world")
assert(x.b == 10)

assert(tup.croco({a = 10, b = 11}) == 11)

local y = tup.dile(13)
assert(y.a == "13")
assert(y.b == "13")