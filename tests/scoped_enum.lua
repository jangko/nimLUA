assert(GENE.ADENINE == 0)
assert(GENE.CYTOSINE == 1)
assert(GENE.GUANINE == 2)
assert(GENE.THYMINE == 3)

assert(ATOM.ELECTRON == 0)
assert(ATOM.PROTON == 1)
assert(ATOM.NEUTRON == 2)

assert(FRUIT.APPLE == 0)
assert(FRUIT.BANANA == 1)
assert(FRUIT.PEACH == 2)
assert(FRUIT.PLUM == 3)

-- since nim 1.2.2 accquoted enum
-- become ident
-- assert(_G["`poncho`"]["`glucho`"] == 0)
-- assert(_G["`poncho`"]["`becho`"] == 1)
-- assert(_G["`poncho`"]["`type`"] == 2)

assert(_G["`poncho`"]["glucho"] == 0)
assert(_G["`poncho`"]["becho"] == 1)
assert(_G["`poncho`"]["type"] == 2)
