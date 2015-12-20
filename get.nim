import nimLUA, macros

type
  Ship = object
    speed*: int
    power: int
  
proc main() =
  var L = newNimLua()
  
  L.bindObject(Ship):
    speed(set)
    speed(get, set) -> "cepat"
    
  L.close()
  
main()
