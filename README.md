
# nimLUA
glue code generator to bind Nim and Lua together using Nim's powerful macro

- - -

**Features**:

* bind free proc
* bind proc as lua method
* bind const
* bind enum
* bind object
* automatic resolve overloaded proc
* easy namespace creation
* easy debugging
* consistent simple API
* can rename exported symbol
* support automatic type conversion
* generate clean and optimized glue code that you can inspect at compile time
* it's free

planned features:

* out value or param with reference type
* complex data types conversion, at least standard container
* don't know, any ideas?

- - -
**Current version API**:
no need to remember complicated API,  the API is simple but powerful

* bindEnum
* bindConst
* bindFunction
* bindObject

- - -

##**HOW TO USE**

###**1. bindEnum**

```nimrod
import nimLUA, os

type
  FRUIT = enum
    APPLE, BANANA, PEACH, PLUM
  SUBATOM = enum
    ELECTRON, PROTON, NEUTRON
  GENE = enum
    ADENINE, CYTOSINE, GUANINE, THYMINE

proc test(L: PState, fileName: string) =
  if L.doFile("test" & DirSep & fileName) != 0.cint:
    echo L.toString(-1)
    L.pop(1)
  else:
    echo fileName & " .. OK"
       
proc main() =
  var L = newNimLua()
  L.bindEnum(FRUIT, SUBATOM, GENE)
  L.test("test.lua")
  L.close()

main()
```
and you can access them at lua side like this:

```lua
assert(FRUIT.APPLE == 0)
assert(FRUIT.BANANA == 1)
assert(FRUIT.PEACH == 2)
assert(FRUIT.PLUM == 3)

assert(GENE.ADENINE == 0)
assert(GENE.CYTOSINE == 1)
assert(GENE.GUANINE == 2)
assert(GENE.THYMINE == 3)

assert(SUBATOM.ELECTRON == 0)
assert(SUBATOM.PROTON == 1)
assert(SUBATOM.NEUTRON == 2)
```

another style:

```nimrod
L.bindEnum:
  FRUIT
  SUBATOM
  GENE
```
if you want to rename the namespace, you can do this:
```nimrod
L.bindEnum:
  GENE -> "DNA"
  SUBATOM -> GLOBAL
```
or
```nimrod
L.bindEnum(GENE -> "DNA", SUBATOM -> GLOBAL)
```
**GLOBAL** or "GLOBAL" have special meaning, it will not create namespace in lua side but will bind the symbol in lua globalspace

now lua side will become:

```lua
assert(DNA.ADENINE == 0)
assert(DNA.CYTOSINE == 1)
assert(DNA.GUANINE == 2)
assert(DNA.THYMINE == 3)

assert(ELECTRON == 0)
assert(PROTON == 1)
assert(NEUTRON == 2)
```

###**2. bindConst**

```nimrod
import nimLUA

const
  MANGOES = 10.0
  PAPAYA = 11.0'f64
  LEMON = 12.0'f32
  GREET = "hello world"
  connected = true

proc main() =
  var L = newNimLua()
  L.bindConst(MANGOES, PAPAYA, LEMON)
  L.bindConst:
    GREET
    connected
  L.close()

main()
```

by default, bindConst will not generate namespace, so how do you create namespace for const? easy:

```nimrod
L.bindConst("fruites", MANGOES, PAPAYA, LEMON)
L.bindConst("status"):
  GREET
  connected
```
first argument(actually second) to bindConst will become the namespace. Without namespace, symbol will be put into global namespace

if you use **GLOBAL** or "GLOBAL" as namespace name, it will have no effect

operator `->` have same meaning with bindEnum, to rename exported symbol on lua side

###**3. bindFunction**
```nimrod
import nimLUA

proc abc(a, b: int): int =
  result = a + b

var L = newNimLua()
L.bindFunction(abc)
L.bindFunction:
  abc -> "cba"
L.bindFunction("alphabet", abc)
```
bindFunction more or less behave like bindConst, without namespace, it will bind symbol to global namespace.

overloaded procs will be automatically resolved by their params count and types

operator `->` have same meaning with bindEnum, to rename exported symbol on lua side

###**4. bindObject**

```nimrod
import nimLUA

type
  Foo = ref object
    name: string

proc newFoo(name: string): Foo =
  new(result)
  result.name = name
  
proc addv(f: Foo, a, b: int): int =
  result = 2 * (a + b)

proc addv(f: Foo, a, b: string): string =
  result = "hello: my name is $1, here is my message: $2, $3" % [f.name, a, b]
  
proc addk(f: Foo, a, b: int): string =
  result = f.name & ": " & $a & " + " & $b & " = " & $(a+b)

proc main() =
  var L = newNimLua()
  L.bindObject(Foo):
    newFoo -> constructor
    addv
    addk -> "add"
  L.close()

main()
```
this time, Foo will become object name and also namespace name in lua

"newFoo `->` constructor" have special meaning, it will create constructor on lua side with special name: `new`

operator `->` on non constructor will behave the same as other binder.

overloaded proc will automatically resolved by their params count and types

destructor will be generated automatically

```lua
local foo = Foo.new("fred")
local m = foo:add(3, 4)

-- "fred: 3 + 4 = 7"
print(m)

assert(foo:addv(4,5) == 2 * (4+5))

-- "hello: my name is fred, here is my message: abc, nop"
print(foo:addv("abc", "nop"))
```

##**HOW TO DEBUG**

you can call **nimLuaDebug** with **true/false** parameter

```nimrod
nimLuaDebug(true) #turn on debug
L.bindEnum:
  GENE
  SUBATOM
  
nimLuaDebug(false) #turn off debug mode
L.bindFunction:
  machine
  engine
```

##**HOW TO ACCESS LUA CODE FROM NIM?**

still under development, contributions are welcome

