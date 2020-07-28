local a = {3,7,9,11,12,123,345}
local b = arr.chemA(a)
assert(#b == 6)
for i=1, #b do
  assert(b[i]==a[i])
end


local c = {DNA.GUANINE, DNA.THYMINE, DNA.ADENINE, DNA.CYTOSINE}
local d = arr.geneA(c)
assert(#d == 3)
for i=1, #d do
  assert(d[i] == c[i])
end

local e = {FRUIT.PEACH, FRUIT.PLUM, FRUIT.BANANA}
local f = arr.fruitA(e)
assert(#f == 3)
for i=1, #f do
  assert(f[i] == e[i])
end

local g = {DNA.GUANINE, DNA.THYMINE, DNA.ADENINE, DNA.CYTOSINE, DNA.THYMINE, DNA.ADENINE, DNA.CYTOSINE}
local h = arr.geneB(g)
assert(#h == 7)
for i=1, #h do
  assert(h[i] == g[i])
end