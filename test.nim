import nimLUA, os, strutils

type
  GENE {.pure.} = enum
    ADENINE, CYTOSINE, GUANINE, THYMINE

  ATOM = enum
    ELECTRON, PROTON, NEUTRON

  FRUIT = enum
    APPLE, BANANA, PEACH, PLUM

  `poncho` = enum
    `glucho`, `becho`

const
  MANGOES = 10.0
  PAPAYA = 11.0'f64
  LEMON = 12.0'f32
  MAX_DASH_PATTERN = 8
  CATHODE = 10'u8
  ANODE = 11'i8
  ELECTRON16 = 12'u16
  PROTON16 = 13'i16
  ELECTRON32 = 14'u32
  PROTON32 = 15'i32
  ELECTRON64 = 16'u64
  PROTON64 = 17'i64
  LABEL_STYLE_CH = ["D", "R", "r", "A", "a"]
  INFO_FIELD = ["Creator", "Producer", "Title", "Subject", "Author", "Keywords"]
  STAIR = [123, 456]
  HELIX = [123.4, 567.8]
  GREET = "hello world"
  connected = true
  mime = {
    "apple": "fruit",
    "men": "woman"
  }

  programme = {
    1: "state",
    2: "power",
    3: "result"
  }

proc addv(a: seq[int]): int =
  result = 0
  for k in a:
    result += k

proc mulv(a,b:int): int = a * b

proc tpc(s: string): string =
  result = s

proc tpm(s: string, v: string): string =
  result = s & " " & v

proc rootv(u: float): seq[float] =
  result = newSeq[float](10)
  for i in 0..9: result[i] = u * i.float

proc test(L: PState, fileName: string) =
  if L.doFile("test" & DirSep & fileName) != 0.cint:
    echo L.toString(-1)
    L.pop(1)
    quit()
  else:
    echo fileName & " .. OK"

proc `++`(a, b: int): int = a + b

type
  Foo = ref object
    name: string

proc newFoo(name: string): Foo =
  new(result)
  result.name = name

proc newFoo(a, b: int): Foo =
  new(result)
  result.name = $a & $b

proc addv(f: Foo, a, b: int): int =
  result = 2 * (a + b)

proc addv(f: Foo, a, b: string): string =
  result = "hello: my name is $1, here is my message: $2, $3" % [f.name, a, b]

proc addk(f: Foo, a, b: int): string =
  result = f.name & ": " & $a & " + " & $b & " = " & $(a+b)

proc machine(a, b: int): int =
  result = a + b

proc machine(a: int): int =
  result = a * 3

proc machine(a: int, b:string): string =
  result = b & $a

proc machine(a,b,c:string): string =
  result = a & b & c

proc subb(a,b: int): int = a - b

type
  Acid = object
    len: int

  Fish = object
    len: int

proc makeAcid(a: int): Acid =
  result.len = a

proc setLen(a: var Acid, len: int) =
  a.len = len

proc getLen(a: Acid): int =
  result = a.len

proc setAcid(a: Foo, b: Acid) =
  echo "setAcid"

proc setAcid2(a: Foo, b: var Acid) =
  echo "setAcid"

proc fishing(len: int): Fish =
  result.len = len

proc grill(a: Fish): string = "grill " & $a.len
proc fry(a: Fish): string = "fry " & $a.len

proc mining(): string = "mining gem"
proc polish(): string = "polishing gem"

const numFruits = 3
type
  chemArray = array[0..11, int]
  geneArray = array[7, GENE]
  fruitArray = array[numFruits, FRUIT]
  fruitSet = set[FRUIT]
  cSet = set[char]
  fruitSeq = seq[FRUIT]
  geneSeq = seq[GENE]
  stringSeq = seq[string]
  PGene = ptr GENE
  Pint = pointer
  PPGene = ptr ptr GENE

proc chemA(a: chemArray): array[0..5, int] =
  for i in 0..result.high:
    result[i] = a[i]

proc geneA(a: geneArray): array[3, GENE] =
  for i in 0..result.high:
    result[i] = a[i]

proc fruitA(a: fruitArray): array[numFruits, FRUIT] =
  for i in 0..result.high:
    result[i] = a[i]

proc geneB(a: geneArray): geneArray =
  for i in 0..result.high:
    result[i] = a[i]

proc geneC(a: array[7, GENE]): geneArray =
  for i in 0..result.high:
    result[i] = a[i]

proc fruitC(a: array[numFruits, FRUIT]): fruitArray =
  for i in 0..result.high:
    result[i] = a[i]

proc chemC(a: array[0..11, int]): chemArray =
  for i in 0..result.high:
    result[i] = a[i]

proc fruitE(a: FRUIT): ATOM =
  if a == BANANA: result = PROTON
  else: result = NEUTRON

proc fruitS(a: fruitSet): set[FRUIT] =
  for k in a: result.incl k

proc alphaS(a: cSet): set[char] =
  for k in a: result.incl k

proc fruitSA(a: set[FRUIT]): fruitSet =
  for k in a: result.incl k

proc alphaSA(a: set[char]): cSet =
  for k in a: result.incl k

proc fruitQ(a: fruitSeq): seq[FRUIT] = result = a
proc fruitQA(a: seq[FRUIT]): fruitSeq = result = a
proc geneQ(a: geneSeq): seq[GENE] = result = a
proc geneQA(a: seq[GENE]): geneSeq = result = a
proc stringQ(a: stringSeq): seq[string] = result = a
proc stringQA(a: seq[string]): stringSeq = result = a

proc seedP(): Pint = cast[Pint](123)
proc geneP(a: PGene): Pint =
  result = cast[Pint](a)

proc intP(a: Pint): PGene =
  result = cast[PGene](a)

proc genePA(a: ptr GENE): pointer =
  result = cast[pointer](a)

proc intPA(a: pointer): ptr GENE =
  result = cast[ptr GENE](a)

proc genePPA(a: PPGene): pointer =
  result = cast[pointer](a)

proc intPPA(a: ptr ptr GENE): pointer =
  result = cast[pointer](a)

proc genePPB(a: pointer): PPGene =
  result = cast[PPGEne](a)

proc intPPB(a: pointer): ptr ptr GENE =
  result = cast[ptr ptr GENE](a)

type
  arango = range[0..10]
  brango = range[5..100]

proc trangA(a: arango): brango  =
  result = a + 5

proc trangB(a: range[1..7], b: range[0..8]): range[0..100] =
  result = a + b

proc trangC(a, b: int): range[5..50] =
  result = a + b + 5

proc mew[T, K](a: T, b: K): T =
  echo a, " ", b
  result = a

proc opa(arg: openArray[int]): int =
  result = 0
  for i in arg:
    inc(result, i)

type
  myTup = tuple[a: string, b: int]

proc dino(a: myTup): string =
  result = a.a

proc saurus(a: string): myTup =
  result = (a, 10)

proc croco(a: tuple[a,b:int]): int =
  result = a.b

proc dile(a: int): tuple[a,b: string] =
  result = ($a, $a)

type
  Foos = ref object
    name: string

  Ship = object
    speed*: int
    power, engine: int

proc newFoos(name: string): Foos =
  new(result)
  result.name = name

proc getName(a: Foos): string =
  result = a.name

proc newShip(): Ship =
  result.speed = 11
  result.power = 12
  result.engine = 3

#type
#  Car = ref object
#    speed: int
#
#  Bike = object
#    wheel: int
#
#  OIL = enum
#    GREASE, LUBRICANT, PETROLEUM, GASOLINE, KEROSENE
#
#  oilArray = array[0..11, OIL]
#  oilSet = set[OIL]
#  Poil = ptr OIL
#  roil = range[5..10]

type
  BaseFruit = object of RootObj
    id: int
  Pineapple = object of BaseFruit
    name: string
  Avocado = ref object of BaseFruit
    name: string

proc newAvocado(name: string, id: int): Avocado =
  new(result)
  result.name = name
  result.id = id

proc newAvocado(foo: Foos): Avocado =
  new(result)
  result.name = foo.name
  result.id = 154

proc initPineapple(name: string, id: int): Pineapple =
  result.name = name
  result.id = id

proc getId(self: BaseFruit): int =
  self.id

proc getId(self: ref BaseFruit): int =
  self.id

proc getAvocado(self: PineApple, idx: int): Avocado =
  result = nil
  if idx == 0: result = newAvocado("nanas", 123)

proc testFromLua(L: PState) =
  type
    Layout = ref object
      name: string

  proc newLayout(): Layout =
    new(result)
    result.name = "The Layout"
    
  L.bindObject(Layout):
    name(get)

  var lay = newLayout()
  
  # store Layout reference
  L.pushLightUserData(cast[pointer](NLMaxID)) # push key
  L.pushLightUserData(cast[pointer](lay)) # push value
  L.setTable(LUA_REGISTRYINDEX)           # registry[lay.addr] = lay

  # register the only entry point of layout hierarchy to lua
  proc layoutProxy(L: PState): cint {.cdecl.} =
    getRegisteredType(Layout, mtName, pxName)
    var ret = cast[ptr pxName](L.newUserData(sizeof(pxName)))

    # retrieve Layout
    L.pushLightUserData(cast[pointer](NLMaxID)) # push key
    L.getTable(LUA_REGISTRYINDEX)           # retrieve value
    ret.ud = cast[Layout](L.toUserData(-1)) # convert to layout
    L.pop(1) # remove userdata
    GC_ref(ret.ud)
    L.nimGetMetaTable(mtName)
    discard L.setMetatable(-2)
    return 1

  L.pushCfunction(layoutProxy)
  L.setGlobal("getLayout")  
    
  #[L.getGlobal("View")     # get View table
  discard L.pushString("onClick") # push the key "onClick"
  L.rawGet(-2)            # get the function
  if L.isNil(-1):
    echo "onClick not found"
  else:
    var proxy = L.getUD(lay.root) # push first argument
    assert(proxy == lay.root)
    if L.pcall(1, 0, 0) != 0:
      let errorMsg = L.toString(-1)
      L.pop(1)
      lay.context.otherError(errLua, errorMsg)
  L.pop(1) # pop View Table]#
    
proc main() =
  var L = newNimLua()

  L.bindConst:
    MANGOES
    PAPAYA
    LEMON
    MAX_DASH_PATTERN
    CATHODE
    ANODE

  L.bindConst("mmm"):
    ELECTRON16
    PROTON16
    ELECTRON32
    PROTON32
    ELECTRON64
    PROTON64
    connected

  L.bindConst("ccc"):
    LABEL_STYLE_CH
    INFO_FIELD
    STAIR
    HELIX
    GREET
    mime
    programme

  L.bindConst:
    MANGOES -> "MANGGA"
    PAPAYA -> "PEPAYA"
    LEMON -> "JERUK"

  L.bindConst("buah"):
    MANGOES -> "MANGGA"
    PAPAYA -> "PEPAYA"
    LEMON -> "JERUK"
  L.test("constants.lua")

  L.bindEnum(GENE)
  L.test("single_scoped_enum.lua")

  L.bindEnum(GENE -> "DNA", ATOM -> GLOBAL, FRUIT)
  L.test("scoped_and_global_enum.lua")

  L.bindEnum:
    ATOM
    GENE
    FRUIT
    `poncho`
  L.test("scoped_enum.lua")

  L.bindFunction(mulv, tpc, tpm -> "goodMan")
  L.test("free_function.lua")

  L.bindFunction("gum"):
    mulv
    tpc
    tpm -> "goodMan"
    `++`
  L.test("scoped_function.lua")

  L.bindObject(Foo):
    newFoo -> constructor
    addv
    addk -> "add"
    setAcid2
    setAcid
    newFoo
    newFoo -> "whatever"
  L.test("fun.lua")

  L.bindFunction("mac"):
    machine
  L.test("ov_func.lua")

  L.bindObject(Acid):
    makeAcid -> constructor
    setLen
    getLen

  L.bindFunction("acd"):
    makeAcid

  L.bindFunction(makeAcid)
  L.bindObject(Fish):
    fishing -> constructor

  L.bindObject(Fish):
    grill
    fry

  L.bindFunction("gem", mining)
  L.bindFunction("gem", polish)
  L.bindConst("gem", ANODE)

  L.bindObject(Fish -> "kakap"):
    grill
    fry
  L.test("regular_object.lua")

  L.bindFunction(GLOBAL):
    mulv

  L.bindFunction("GLOBAL", mulv, subb)

  L.bindConst(GLOBAL):
    LEMON

  L.bindConst("GLOBAL"):
    LEMON

  L.bindEnum:
    GENE -> GLOBAL
    FRUIT -> "GLOBAL"
  L.test("namespace.lua")

  L.bindFunction("arr"):
    chemA
    geneA
    fruitA
    geneB
    geneC
    fruitC
    chemC
  L.test("array_param_ret.lua")

  L.bindFunction("proto_banana"):
    fruitE -> "radiate"
  L.test("enum_param_ret.lua")

  L.bindFunction("set"):
    fruitS
    alphaS
    fruitSA
    alphaSA
  L.test("set_param_ret.lua")

  L.bindFunction("seq"):
    fruitQ
    fruitQA
    geneQ
    geneQA
    stringQ
    stringQA
    rootv
  L.test("sequence_param_ret.lua")

  L.bindFunction("ptr"):
    seedP
    geneP
    genePA
    intP
    intPA
    genePPA
    intPPA
    genePPB
    intPPB
  L.test("ptr_pointer.lua")

  L.bindFunction("range"):
    trangA
    trangB
    trangC -> "haha"
    trangC
  L.test("range_param_ret.lua")

  var test = 1237
  proc cl(): string =
    echo test
    result = $test

  L.bindFunction("wow"):
    [cl]
    [cl] -> "clever"
    mew[int, int]
    mew[int, string] -> "mewt"
    opa

  L.test("generic.lua")
  L.test("closure.lua")
  L.test("openarray.lua")

  L.bindObject(Foos):
    newFoos
    getName
    name(get,set)

  L.bindObject(Ship):
    newShip
    speed(set)
    speed(get, set) -> "cepat"
    engine(set)
    power(get)

  L.test("getter_setter.lua")

  L.bindFunction("tup"):
    dino
    saurus
    croco
    dile

  L.test("tuple.lua")

  L.bindObject(Avocado):
    newAvocado -> "new"
    name(get)
    id(get)
    getId

  L.bindObject(Pineapple):
    initPineapple -> "init"
    name(get)
    id(get)
    getId
    getAvocado

  L.test("inheritance.lua")

  L.testFromLua()
  
  L.close()

main()
