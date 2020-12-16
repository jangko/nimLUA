packageName   = "nimLUA"
version       = "0.3.8"
author        = "Andri Lim"
description   = "glue code generator to bind Nim and Lua together using Nim's powerful macro"
license       = "MIT"
skipDirs      = @["test", "scripts"]

requires: "nim >= 1.2.2"

### Helper functions
proc test(env, path: string) =
  # Compilation language is controlled by TEST_LANG
  var lang = "c"
  if existsEnv"TEST_LANG":
    lang = getEnv"TEST_LANG"
    debugEcho "LANG: ", lang

  when defined(unix):
    const libm = "-lm"
  else:
    const libm = ""

  when defined(macosx):
    # nim bug, incompatible pointer assignment
    # see nim-lang/Nim#16123
    if lang == "cpp":
      lang = "c"

  if not dirExists "build":
    mkDir "build"
  exec "nim " & lang & " " & env &
    " --outdir:build -r --hints:off --warnings:off " &
    " -d:lua_static_lib --passL:\"-Lexternal -llua " & libm & " \" " & path

task test, "Run all tests":
  test "-d:nimDebugDlOpen", "tests/test_features"
  test "-d:nimDebugDlOpen -d:release", "tests/test_features"
  test "-d:importLogging", "tests/test_bugfixes"
  test "-d:importLogging -d:release", "tests/test_bugfixes"
