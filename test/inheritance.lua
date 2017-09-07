local av = Avocado.new("alpukat", 123)
local pn = Pineapple.init("nanas", 134)

assert(av.name == "alpukat")
assert(av.id == 123)
assert(av:getId() == 123)
assert(pn.name == "nanas")
assert(pn.id == 134)
assert(pn:getId() == 134)

local av2 = Avocado.new() -- missing argument or wrong argument type result in nil
assert(av2 == nil)

local av3 = Avocado.new("gull")
assert(av3 == nil)

local foo = Foos.newFoos("seamonkey")
local av4 = Avocado.new(foo)
print(av4.name)
assert(av4.name == "seamonkey") -- good, it works
