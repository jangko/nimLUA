function contains(t, e)
  for i = 1,#t do
    if t[i] == e then return true end
  end
  return false
end

local a = {FRUIT.BANANA, FRUIT.APPLE}
local b = set.fruitS(a)
assert(#a == #b)
for i=1, #b do
  assert(contains(a, b[i]))
end

local a = {1, 3, 5}
local b = set.alphaS(a)
assert(#a == #b)
for i=1, #b do
  assert(contains(a, b[i]))
end

local a = {1, 3, 5}
local b = set.alphaSA(a)
assert(#a == #b)
for i=1, #b do
  assert(contains(a, b[i]))
end

local a = {FRUIT.BANANA, FRUIT.APPLE}
local b = set.fruitSA(a)
assert(#a == #b)
for i=1, #b do
  assert(contains(a, b[i]))
end
