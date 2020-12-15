local c = {1,3,5,7}

x = 0
for i=1, #c do
  x = x + c[i]
end

assert(wow.opa(c) == x)