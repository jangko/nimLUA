when defined(importLogging):
  import ../nimLUA, os, sequtils, logging, unittest
else:
  import ../nimLUA, unittest

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

proc testBugFixes() =
  suite "bugfixes":
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

    test "bug23":
      let r = L.doString("a = 7 + 11aa")
      check r != LUA_OK
      check L.toString(-1) == """[string "a = 7 + 11aa"]:1: malformed number near '11aa'"""

    L.close()

testBugFixes()
