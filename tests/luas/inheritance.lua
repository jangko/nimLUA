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
assert(av4.name == "seamonkey") -- good, it works

local av5 = pn:getAvocado(0)
assert(av5 ~= nil)
assert(av5.name == "nanas")
assert(av5.id == 123)

local av6 = pn:getAvocado(1)
assert(av6 == nil)

local av7 = Avocado.new("garbage")
assert(av7 == nil)
