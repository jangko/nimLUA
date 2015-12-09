-- fun.lua

-- Because the metatable has been exposed 
-- to us, we can actually add new functions
-- to Foo
function Foo:speak()
    print("Hello, I am a Foo")
end

local foo = Foo.new("fred")
local m = foo:add(3, 4)

-- "fred: 3 + 4 = 7"
print(m)

-- "Hello, I am a Foo"
foo:speak()

-- Let's rig the original metatable
Foo.add_ = Foo.add
function Foo:add(a, b)
    return "here comes the magic: " .. self:add_(a, b)
end

m = foo:add(9, 8)
assert(m == "here comes the magic: fred: 9 + 8 = 17")

-- "here comes the magic: fred: 9 + 8 = 17"
print(m)

assert(foo:addv(4,5) == 2 * (4+5))
print(foo:addv("abc", "nop"))