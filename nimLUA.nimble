packageName   = "nimLUA"
version       = "0.3.8"
author        = "Andri Lim"
description   = "glue code generator to bind Nim and Lua together using Nim's powerful macro"
license       = "MIT"
skipDirs      = @["test", "scripts"]

requires: "nim >= 1.2.2"

task tests, "Run all tests":
  exec "nim c -r -d:nimDebugDlOpen tests/test_features"
  exec "nim c -r -d:nimDebugDlOpen -d:release tests/test_features"
  exec "nim c -r -d:importLogging tests/test_bug19"
  exec "nim c -r -d:importLogging -d:release tests/test_bug19"

