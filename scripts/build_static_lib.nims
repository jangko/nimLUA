import os, strutils

const
  compatFlag = "-DLUA_COMPAT_ALL" # or "-DLUA_COMPAT_5_2"

type
  FileName = tuple[dir, name, ext: string]

proc getCFiles(dir: string): seq[FileName] =
  var files = listFiles(dir)
  result = @[]
  for c in files:
    let x = c.splitFile
    if cmpIgnoreCase(x.name, "lua") == 0: continue
    if cmpIgnoreCase(x.name, "luac") == 0: continue
    if cmpIgnoreCase(x.ext, ".c") == 0:
      result.add x

proc toString(names: seq[string]): string =
  result = ""
  for c in names:
    result.add c
    result.add " "

proc objList(): string =
  let src = getCFiles("lua" / "src")
  var objs: seq[string] = @[]

  for x in src:
    let fileName = x.dir / x.name
    let buildCmd = "gcc -O2 -Wall $1 -c -o $2.o $2.c" % [compatFlag, fileName]
    try:
      exec(buildCmd)
      echo buildCmd
      objs.add(fileName & ".o")
    except:
      echo "failed to build ", fileName

  result = toString(objs)

proc makeLib() =
  let linkCmd = "ar rcs external/liblua.a " & objList()
  echo linkCmd
  exec(linkCmd)

makeLib()
