import os, strutils

when defined(unix):
  const
    extraFlag = "-fPIC" #"-DLUA_BUILD_AS_DLL"
    compatFlag = "-DLUA_COMPAT_ALL" # or "-DLUA_COMPAT_5_2"
    linkFlags = ""
else:
  when defined(build32):
    const extraFlag = "-m32"
  else:
    const extraFlag = ""

  const
    compatFlag = "-DLUA_COMPAT_ALL" # or "-DLUA_COMPAT_5_2"
    linkFlags = ""

when defined(MACOSX):
  const LIB_NAME* = "liblua5.3.dylib"
elif defined(FREEBSD):
  const LIB_NAME* = "liblua-5.3.so"
elif defined(UNIX):
  const LIB_NAME* = "liblua5.3.so"
else:
  const LIB_NAME* = "lua53.dll"

type
  FileName = tuple[dir, name, ext: string]

proc getCFiles(dir: string): seq[FileName] =
  debugEcho dir
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

let src = getCFiles("lua" / "src")
var objs: seq[string] = @[]

for x in src:
  let fileName = x.dir / x.name
  let buildCmd = "gcc -O2 -Wall $1 $2 -c -o $3.o $3.c $4" % [extraFlag, compatFlag, fileName, linkFlags]
  try:
    exec(buildCmd)
    echo buildCmd
    objs.add(fileName & ".o")
  except:
    echo "failed to build ", fileName

let objList = toString(objs)
let linkCmd = "gcc -shared $4 -o $1$2$3 $5" % [".", $DirSep, LIB_NAME, extraFlag, objList]
echo linkCmd
exec(linkCmd)
