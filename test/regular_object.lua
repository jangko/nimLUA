local a = Acid.new(10)

assert(a:getLen() == 10)
a:setLen(11)
assert(a:getLen() == 11)