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

proc rootv(u: float): seq[int] =
  result = newSeq[int](10)
  for i in 0..9: result[i] = int(u * i.float)

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
  
proc main() =
  var L = newNimLua()

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
  
  L.close()

main()
