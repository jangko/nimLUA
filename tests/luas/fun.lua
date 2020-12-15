-- fun.lua

-- Because the metatable has been exposed
-- to us, we can actually add new functions
-- to Foo
function Foo:speak()
  return "Hello, I am a Foo"
end

local foo = Foo.new("fred")
local m = foo:add(3, 4)

-- "fred: 3 + 4 = 7"
assert(m == "fred: 3 + 4 = 7")

-- "Hello, I am a Foo"
assert(foo:speak() == "Hello, I am a Foo")

-- Let's rig the original metatable
Foo.add_ = Foo.add
function Foo:add(a, b)
  return "here comes the magic: " .. self:add_(a, b)
end

m = foo:add(9, 8)
assert(m == "here comes the magic: fred: 9 + 8 = 17")

assert(foo:addv(4,5) == 2 * (4+5))
assert(foo:addv("abc", "nop") == "hello: my name is fred, here is my message: abc, nop")

local mee = Foo.new(3, 8)
assert(mee:add(1,2) == "here comes the magic: 38: 1 + 2 = 3")

local x = Foo.newFoo("cat")
assert(x:add(1,10) == "here comes the magic: cat: 1 + 10 = 11")

local y = Foo.whatever("king")
assert(y:add(10,10) == "here comes the magic: king: 10 + 10 = 20")
