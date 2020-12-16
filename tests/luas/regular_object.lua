local a = Acid.new(10)

assert(a:getLen() == 10)
a:setLen(11)
assert(a:getLen() == 11)


local b = makeAcid(12)
assert(b:getLen() == 12)

local c = acd.makeAcid(13)
assert(c:getLen() == 13)

local f = Fish.new(15)
assert(f:grill() == "grill 15")
assert(f:fry() == "fry 15")

assert(gem.mining() == "mining gem")
assert(gem.polish() == "polishing gem")
assert(gem.ANODE == 11)

local k = kakap.new(16)
assert(k:grill() == "grill 16")
assert(k:fry() == "fry 16")
