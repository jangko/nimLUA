local a = {FRUIT.BANANA, FRUIT.APPLE, FRUIT.PLUM, FRUIT.PEACH}
local b = seq.fruitQ(a)
local c = seq.fruitQA(a)
assert(#b == #a)
assert(#c == #a)
for i=1, #b do
  assert(b[i] == a[i])
  assert(c[i] == a[i])
end

local a = {DNA.GUANINE, DNA.THYMINE, DNA.ADENINE, DNA.CYTOSINE}
local b = seq.geneQ(a)
local c = seq.geneQA(a)
assert(#b == #a)
assert(#c == #a)
for i=1, #b do
  assert(b[i] == a[i])
  assert(c[i] == a[i])
end

local a = {"mama", "mia", "lezatos", "hmm"}
local b = seq.stringQ(a)
local c = seq.stringQA(a)
assert(#b == #a)
assert(#c == #a)
for i=1, #b do
  assert(b[i] == a[i])
  assert(c[i] == a[i])
end

local b = seq.rootv(11.5)
for i=1, 10 do
  local c = (i-1) * 11.5
  assert(c == b[i])
end
