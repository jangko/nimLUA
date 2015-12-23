import nimLUA, macros, os

type
  Ship = object
    speed*: int
    power: int
  
proc mew[T, K](a: T, b: K): T =
  echo a, " ", b
  result = a
  
proc test(L: PState, fileName: string) =
  if L.doFile("test" & DirSep & fileName) != 0.cint:
    echo L.toString(-1)
    L.pop(1)
    quit()
  else:
    echo fileName & " .. OK"
    
proc opa(arg: openArray[int]): int = 
  result = 0
  for i in arg:
    inc(result, i)
    
proc main() =
  var test = 1237
  proc cl(): string =
    echo test
    result = $test
    
  var L = newNimLua()

  L.bindObject(Ship):
    speed(set)
    speed(get, set) -> "cepat"
  
  L.bindFunction("wow"):
    [cl]
    [cl] -> "clever"
    mew[int, int]
    mew[int, string] -> "mewt"
    opa
  
  L.test("generic.lua")
  L.test("closure.lua")
  L.test("openarray.lua")
  
  L.close()
  
main()

#TODO:
#tuple
#tuple test
#getter/setter
#getter/setter test 
 