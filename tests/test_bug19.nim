when defined(importLogging):
  import nimLUA, os, sequtils, logging, unittest
else:
  import nimLUA, os, sequtils, json, random, unittest

type
  Foo = ref object
    name: string

proc newFoo(name: string): Foo =
  new(result)
  result.name = name

proc addv(f: Foo, a, b: int): int =
  result = 2 * (a + b)

proc addv(f: Foo, a, b: string): string =
  result = "hello: my name is , here is my message: " & a & b & f.name

var L = newNimLua()

L.bindObject(Foo):
  newFoo -> constructor
  addv

test "bug19":
  let luaScript = """
local foo = Foo.new("jacky")
assert(foo:addv(1,2) == 6)
assert(foo:addv("apple","banana") == "hello: my name is , here is my message: applebananajacky")
"""
  check L.doString(luaScript) == 0.cint

L.close()