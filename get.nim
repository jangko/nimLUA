import nimLUA, macros

type
  Ship = object
    speed*: int
    power: int
  
proc mew[T, K](a: T, b: K): T =
  discard
  
proc main() =
  var test = 1237
  proc cl() =
    echo test
    
  var L = newNimLua()

  L.bindObject(Ship):
    speed(set)
    speed(get, set) -> "cepat"
  
  L.bindFunction:
    # [cl]
    # [cl] -> "clever"
    mew[int, int]
    mew[int, string] -> "mewt"
  
  L.close()
  
main()

  