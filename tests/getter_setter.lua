local a = Foos.newFoos("kodok")
assert(a.name == "kodok")
assert(a:getName() == "kodok")

local b = Ship.newShip()
assert(b.cepat == 11)
b.cepat = 17
assert(b.cepat == 17)

b.speed = 19
assert(b.speed == nil)