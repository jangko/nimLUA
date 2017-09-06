#
#* $Id: lua.h,v 1.283 2012/04/20 13:18:26 roberto Exp $
#* Lua - A Scripting Language
#* Lua.org, PUC-Rio, Brazil (http://www.lua.org)
#* See Copyright Notice at the end of this file
#
const
  LUA_VERSION_MAJOR* = "5"
  LUA_VERSION_MINOR* = "3"
  LUA_VERSION_NUM* = 531
  LUA_VERSION_RELEASE* = "1"
  LUA_VERSION* = "Lua " & LUA_VERSION_MAJOR & "." & LUA_VERSION_MINOR
  #LUA_RELEASE = LUA_VERSION & "." & LUA_VERSION_RELEASE
  #LUA_COPYRIGHT = LUA_RELEASE & " Copyright (C) 1994-2012 Lua.org, PUC-Rio"
  #LUA_AUTHORS = "R. Ierusalimschy, L. H. de Figueiredo, W. Celes"

#{.deadCodeElim: on.}
#when defined(useLuaJIT):
#  {.warning: "Lua JIT does not support Lua 5.3 at this time."}

when not defined(useLuaJIT):
  when defined(MACOSX):
    const
      LIB_NAME* = "liblua5.3.dylib"
  elif defined(UNIX):
    const
      LIB_NAME* = "liblua(5.3.so|.so.5.3)"
  else:
    when defined(cpu64):
      const
        LIB_NAME* = "lua53x64.dll"
    else:
      const
        LIB_NAME* = "lua53.dll"
else:
  when defined(MACOSX):
    const
      LIB_NAME* = "libluajit.dylib"
  elif defined(UNIX):
    const
      LIB_NAME* = "libluajit.so"
  else:
    const
      LIB_NAME* = "luajit.dll"

const
  # mark for precompiled code ('<esc>Lua')
  LUA_SIGNATURE* = "\x1BLua"

  # option for multiple returns in 'lua_pcall' and 'lua_call'
  LUA_MULTRET* = (-1)

#
#* pseudo-indices
#
#@@ LUAI_MAXSTACK limits the size of the Lua stack.
#* CHANGE it if you need a different limit. This limit is arbitrary;
#* its only purpose is to stop Lua to consume unlimited stack
#* space (and to reserve some numbers for pseudo-indices).
#
when sizeof(int) >= 4: #LUAI_BITSINT >= 32:
  const
    LUAI_MAXSTACK* = 1000000
else:
  const
    LUAI_MAXSTACK* = 15000

# reserve some space for error handling
const
  LUAI_FIRSTPSEUDOIDX* = (-LUAI_MAXSTACK - 1000)
  LUA_REGISTRYINDEX* = LUAI_FIRSTPSEUDOIDX

proc upvalueindex*(i: int): int {.inline.} = LUA_REGISTRYINDEX - i

# thread status
type TThreadStatus* {.size:sizeof(cint).}= enum
  Thread_OK = 0, Thread_Yield, Thread_ErrRun, Thread_ErrSyntax,
  Thread_ErrMem, Thread_ErrGCMM, Thread_ErrErr

const
  LUA_OK* = 0
  LUA_YIELD* = 1
  LUA_ERRRUN* = 2
  LUA_ERRSYNTAX* = 3
  LUA_ERRMEM* = 4
  LUA_ERRGCMM* = 5
  LUA_ERRERR* = 6

type
  PState* = distinct pointer
  lua_State* = PState
  TCFunction* = proc (L: PState): cint{.cdecl.}

  #* functions that read/write blocks when loading/dumping Lua chunks
  TReader* = proc (L: PState; ud: pointer; sz: var csize): cstring {.cdecl.}
  TWriter* = proc (L: PState; p: pointer; sz: csize; ud: pointer): cint {.cdecl.}

  #* prototype for memory-allocation functions
  TAlloc* = proc (ud, p: pointer; osize, nsize: csize): pointer

#* basic types
const
  LUA_TNONE* = (-1)
  LUA_TNIL* = 0
  LUA_TBOOLEAN* = 1
  LUA_TLIGHTUSERDATA* = 2
  LUA_TNUMBER* = 3
  LUA_TSTRING* = 4
  LUA_TTABLE* = 5
  LUA_TFUNCTION* = 6
  LUA_TUSERDATA* = 7
  LUA_TTHREAD* = 8
  LUA_NUMTAGS* = 9

type
  LUA_TYPE* = enum
    LNONE = -1, LNIL, LBOOLEAN, LLIGHTUSERDATA, LNUMBER,
    LSTRING, LTABLE, LFUNCTION, LUSERDATA, LTHREAD, LNUMTAGS

# minimum Lua stack available to a C function
const
  LUA_MINSTACK* = 20

# predefined values in the registry
const
  LUA_RIDX_MAINTHREAD* = 1
  LUA_RIDX_GLOBALS* = 2
  LUA_RIDX_LAST* = LUA_RIDX_GLOBALS

type
  lua_Number* = float64  # type of numbers in Lua
  lua_Integer* = int64    # ptrdiff_t \ type for integer functions

{.push callconv: cdecl, dynlib: LIB_NAME .} # importc: "lua_$1"  was not allowed?
{.pragma: ilua, importc: "lua_$1".} # lua.h
{.pragma: iluaLIB, importc: "lua$1".} # lualib.h
{.pragma: iluaL, importc: "luaL_$1".} # lauxlib.h

proc newstate*(f: TAlloc; ud: pointer): PState {.ilua.}
proc close*(L: PState) {.ilua.}
proc newthread*(L: PState): PState {.ilua.}
proc atpanic*(L: PState; panicf: TCFunction): TCFunction {.ilua.}
proc version*(L: PState): ptr lua_Number {.ilua.}

#
#* basic stack manipulation
#
proc absindex*(L: PState; idx: cint): cint {.ilua.}
proc gettop*(L: PState): cint {.ilua.}
proc settop*(L: PState; idx: cint) {.ilua.}
proc pushvalue*(L: PState; idx: cint) {.ilua.}
proc rotate*(L: PState; idx, n: cint) {.ilua.}

proc copy*(L: PState; fromidx: cint; toidx: cint) {.ilua.}
proc checkstack*(L: PState; sz: cint): cint {.ilua.}
proc xmove*(src: PState; dst: PState; n: cint) {.ilua.}

proc pop*(L: PState; n: cint) {.inline.} = L.settop(-n - 1)
proc insert*(L: PState, idx: cint) {.inline.} = L.rotate(idx, 1)
proc remove*(L: PState, idx: cint) {.inline.} = L.rotate(idx, -1); L.pop(1)
proc replace*(L: PState, idx: cint) {.inline.} = L.copy(-1, idx); L.pop(1)

#
#* access functions (stack -> C)
#
proc isnumber*(L: PState; idx: cint): cint {.ilua.}
proc isstring*(L: PState; idx: cint): cint {.ilua.}
proc iscfunction*(L: PState; idx: cint): cint {.ilua.}
proc isuserdata*(L: PState; idx: cint): cint {.ilua.}
proc isinteger*(L: PState; idx: cint): cint {.ilua.}
proc luatype*(L: PState; idx: cint): cint {.importc: "lua_type".}
proc typename*(L: PState; tp: cint): cstring {.ilua.}
proc tonumberx*(L: PState; idx: cint; isnum: ptr cint): lua_Number {.ilua.}
proc tointegerx*(L: PState; idx: cint; isnum: ptr cint): lua_Integer {.ilua.}
proc toboolean*(L: PState; idx: cint): cint {.ilua.}
proc tolstring*(L: PState; idx: cint; len: ptr csize): cstring {.ilua.}
proc rawlen*(L: PState; idx: cint): csize {.ilua.}
proc tocfunction*(L: PState; idx: cint): TCFunction {.ilua.}
proc touserdata*(L: PState; idx: cint): pointer {.ilua.}
proc tothread*(L: PState; idx: cint): PState {.ilua.}
proc topointer*(L: PState; idx: cint): pointer {.ilua.}

#
#* Comparison and arithmetic functions
#
const
  LUA_OPADD* = 0            # ORDER TM
  LUA_OPSUB* = 1
  LUA_OPMUL* = 2
  LUA_OPDIV* = 3
  LUA_OPMOD* = 4
  LUA_OPPOW* = 5
  LUA_OPUNM* = 6
proc arith*(L: PState; op: cint) {.ilua.}

const
  LUA_OPEQ* = 0
  LUA_OPLT* = 1
  LUA_OPLE* = 2
proc rawequal*(L: PState; idx1: cint; idx2: cint): cint {.ilua.}
proc compare*(L: PState; idx1: cint; idx2: cint; op: cint): cint {.ilua.}

#
#* push functions (C -> stack)
#
proc pushnil*(L: PState) {.ilua.}
proc pushnumber*(L: PState; n: lua_Number) {.ilua.}
proc pushinteger*(L: PState; n: lua_Integer) {.ilua.}
proc pushlstring*(L: PState; s: cstring; len: csize): cstring {.ilua.}
proc pushstring*(L: PState; s: cstring): cstring {.ilua.}
proc pushvfstring*(L: PState; fmt: cstring): cstring {.varargs,ilua.}
proc pushfstring*(L: PState; fmt: cstring): cstring {.varargs,ilua.}
proc pushcclosure*(L: PState; fn: TCFunction; n: cint) {.ilua.}
proc pushboolean*(L: PState; b: cint) {.ilua.}
proc pushlightuserdata*(L: PState; p: pointer) {.ilua.}
proc pushthread*(L: PState): cint {.ilua.}

#
#* get functions (Lua -> stack)
#
proc getglobal*(L: PState; variable: cstring) {.ilua.}
proc gettable*(L: PState; idx: cint) {.ilua.}
proc getfield*(L: PState; idx: cint; k: cstring) {.ilua.}
proc rawget*(L: PState; idx: cint) {.ilua.}
proc rawgeti*(L: PState; idx: cint; n: cint) {.ilua.}
proc rawgetp*(L: PState; idx: cint; p: pointer) {.ilua.}
proc createtable*(L: PState; narr: cint; nrec: cint) {.ilua.}
proc newuserdata*(L: PState; sz: csize): pointer {.ilua.}
proc getmetatable*(L: PState; idx: cint): cint {.ilua.}
proc getuservalue*(L: PState; idx: cint) {.ilua.}

#
#* set functions (stack -> Lua)
#
proc setglobal*(L: PState; variable: cstring) {.ilua.}
proc settable*(L: PState; idx: cint) {.ilua.}
proc setfield*(L: PState; idx: cint; k: cstring) {.ilua.}
proc rawset*(L: PState; idx: cint) {.ilua.}
proc rawseti*(L: PState; idx: cint; n: lua_Integer) {.ilua.}
proc rawsetp*(L: PState; idx: cint; p: pointer) {.ilua.}
proc setmetatable*(L: PState; objindex: cint): cint {.ilua.}
proc setuservalue*(L: PState; idx: cint) {.ilua.}

#
#* 'load' and 'call' functions (load and run Lua code)
#
proc callk*(L: PState; nargs, nresults, ctx: cint; k: TCFunction) {.ilua.}
proc call*(L: PState; n, r: cint) {.inline.} = L.callk(n, r, 0, nil)

#proc getctx*(L: PState; ctx: ptr cint): cint {.ilua.}
proc pcallk*(L: PState; nargs, nresults, errfunc, ctx: cint; k: TCFunction): cint {.ilua.}
proc pcall*(L: PState; nargs, nresults, errFunc: cint): cint {.inline.} =
  L.pcallK(nargs, nresults, errFunc, 0, nil)

proc load*(L: PState; reader: TReader; dt: pointer; chunkname, mode: cstring): cint {.ilua.}
proc dump*(L: PState; writer: TWriter; data: pointer): cint {.ilua.}

#
#* coroutine functions
#
proc yieldk*(L: PState; nresults: cint; ctx: cint; k: TCFunction): cint {.ilua.}
proc luayield*(L: PState, n: cint): cint {.inline.} = L.yieldk(n, 0, nil)
proc resume*(L: PState; fromL: PState; narg: cint): cint {.ilua.}
proc status*(L: PState): cint {.ilua.}

#
#* garbage-collection function and options
#
const
  LUA_GCSTOP* = 0
  LUA_GCRESTART* = 1
  LUA_GCCOLLECT* = 2
  LUA_GCCOUNT* = 3
  LUA_GCCOUNTB* = 4
  LUA_GCSTEP* = 5
  LUA_GCSETPAUSE* = 6
  LUA_GCSETSTEPMUL* = 7
  LUA_GCSETMAJORINC* = 8
  LUA_GCISRUNNING* = 9
  LUA_GCGEN* = 10
  LUA_GCINC* = 11
proc gc*(L: PState; what: cint; data: cint): cint {.ilua.}

#
#* miscellaneous functions
#
proc error*(L: PState): cint {.ilua.}
proc next*(L: PState; idx: cint): cint {.ilua.}
proc concat*(L: PState; n: cint) {.ilua.}
proc len*(L: PState; idx: cint) {.ilua.}
proc getallocf*(L: PState; ud: var pointer): TAlloc {.ilua.}
proc setallocf*(L: PState; f: TAlloc; ud: pointer) {.ilua.}

#
#* ===============================================================
#* some useful macros
#* ===============================================================
#
proc tonumber*(L: PState; i: cint): lua_Number {.inline.} = L.tonumberx(i, nil)
proc tointeger*(L: PState; i: cint): lua_Integer {.inline.} = L.tointegerx(i, nil)
proc newtable*(L: PState) {.inline.} = L.createtable(0,0)
proc pushcfunction*(L: PState; fn: TCfunction) {.inline.} = L.pushCclosure(fn, 0)
proc register*(L: PState, n: string, f :TCFunction) {.inline.} =
  L.pushcfunction(f); L.setglobal(n)

proc isfunction* (L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TFUNCTION

proc istable* (L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TTABLE

proc islightuserdata*(L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TLIGHTUSERDATA

proc isnil*(L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TNIL

proc isboolean*(L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TBOOLEAN

proc isthread* (L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TTHREAD

proc isnone* (L: PState; n: cint): bool {.inline.} =
  L.luatype(n) == LUA_TNONE

proc isnoneornil*(L: PState; n: cint): bool {.inline.} =
  L.luatype(n) <= 0

proc pushliteral*(L: PState, s: string): cstring {.inline, discardable.} =
  L.pushlstring(s, s.len)

proc pushglobaltable*(L: PState) {.inline.} =
  L.rawgeti(LUA_REGISTRYINDEX, LUA_RIDX_GLOBALS)

proc tostring*(L: PState; index: cint): string =
  var len: cint = 0
  var s = L.tolstring(index, addr(len))
  result = newString(len)
  copyMem(result.cstring, s, len)

proc tobool*(L: PState; index: cint): bool =
  result = if L.toboolean(index) == 1: true else: false

proc gettype*(L: PState, index: int): LUA_TYPE =
  result = LUA_TYPE(L.luatype(index.cint))

#
#* {======================================================================
#* Debug API
#* =======================================================================
#
#
#* Event codes
#
const
  LUA_HOOKCALL* = 0
  LUA_HOOKRET* = 1
  LUA_HOOKLINE* = 2
  LUA_HOOKCOUNT* = 3
  LUA_HOOKTAILCALL* = 4
#
#* Event masks
#
const
  LUA_MASKCALL* = (1 shl LUA_HOOKCALL)
  LUA_MASKRET* = (1 shl LUA_HOOKRET)
  LUA_MASKLINE* = (1 shl LUA_HOOKLINE)
  LUA_MASKCOUNT* = (1 shl LUA_HOOKCOUNT)
# activation record


#@@ LUA_IDSIZE gives the maximum size for the description of the source
#@* of a function in debug information.
#* CHANGE it if you want a different size.
#
const
  LUA_IDSIZE* = 60

# Functions to be called by the debugger in specific events
type
  PDebug* = ptr lua.TDebug
  TDebug* {.pure, final.} = object
    event*: cint
    name*: cstring        # (n)
    namewhat*: cstring    # (n) 'global', 'local', 'field', 'method'
    what*: cstring        # (S) 'Lua', 'C', 'main', 'tail'
    source*: cstring      # (S)
    currentline*: cint    # (l)
    linedefined*: cint    # (S)
    lastlinedefined*: cint # (S)
    nups*: cuchar         # (u) number of upvalues
    nparams*: cuchar      # (u) number of parameters
    isvararg*: char       # (u)
    istailcall*: char     # (t)
    short_src*: array[LUA_IDSIZE, char] # (S) \ # private part
    i_ci: pointer#ptr CallInfo   # active function


type
  lua_Hook* = proc (L: PState; ar: PDebug) {.cdecl.}
proc getstack*(L: PState; level: cint; ar: PDebug): cint {.ilua.}
proc getinfo*(L: PState; what: cstring; ar: PDebug): cint {.ilua.}
proc getlocal*(L: PState; ar: PDebug; n: cint): cstring {.ilua.}
proc setlocal*(L: PState; ar: PDebug; n: cint): cstring {.ilua.}
proc getupvalue*(L: PState; funcindex: cint; n: cint): cstring {.ilua.}
proc setupvalue*(L: PState; funcindex: cint; n: cint): cstring {.ilua.}
proc upvalueid*(L: PState; fidx: cint; n: cint): pointer {.ilua.}
proc upvaluejoin*(L: PState; fidx1: cint; n1: cint; fidx2: cint; n2: cint) {.ilua.}
proc sethook*(L: PState; fn: lua_Hook; mask: cint; count: cint): cint {.ilua.}
proc gethook*(L: PState): lua_Hook {.ilua.}
proc gethookmask*(L: PState): cint {.ilua.}
proc gethookcount*(L: PState): cint {.ilua.}

# }======================================================================
#*****************************************************************************
# Copyright (C) 1994-2012 Lua.org, PUC-Rio.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#****************************************************************************




#
#* $Id: lualib.h,v 1.43 2011/12/08 12:11:37 roberto Exp $
#* Lua standard libraries
#* See Copyright Notice in lua.h
#

proc open_base*(L: PState): cint {.iluaLIB.}
const
  LUA_COLIBNAME* = "coroutine"
proc open_coroutine*(L: PState): cint {.iluaLIB.}
const
  LUA_TABLIBNAME* = "table"
proc open_table*(L: PState): cint {.iluaLIB.}
const
  LUA_IOLIBNAME* = "io"
proc open_io*(L: PState): cint {.iluaLIB.}
const
  LUA_OSLIBNAME* = "os"
proc open_os*(L: PState): cint {.iluaLIB.}
const
  LUA_STRLIBNAME* = "string"
proc open_string*(L: PState): cint {.iluaLIB.}
const
  LUA_UTF8LIBNAME* = "utf8"
proc open_utf8*(L: PState): cint {.iluaLIB.}
const
  LUA_BITLIBNAME* = "bit32"
proc open_bit32*(L: PState): cint {.iluaLIB.}
const
  LUA_MATHLIBNAME* = "math"
proc open_math*(L: PState): cint {.iluaLIB.}
const
  LUA_DBLIBNAME* = "debug"
proc open_debug*(L: PState): cint {.iluaLIB.}
const
  LUA_LOADLIBNAME* = "package"
proc open_package*(L: PState): cint {.iluaLIB.}
# open all previous libraries
proc openlibs*(L: PState) {.iluaL.}

when not defined(lua_assert):
  template lua_assert*(x: typed): typed =
    (cast[nil](0))


#
#* $Id: lauxlib.h,v 1.120 2011/11/29 15:55:08 roberto Exp $
#* Auxiliary functions for building Lua libraries
#* See Copyright Notice in lua.h
#

# extra error code for `luaL_load'
const
  LUA_ERRFILE* = Thread_ErrErr.cint + 1'i32 #(LUA_ERRERR + 1)

type
  luaL_Reg* {.pure, final.} = object
    name*: cstring
    fn*: TCFunction

const
  LUAL_NUMSIZES = (sizeof(lua_Integer)*16 + sizeof(lua_Number))

### IMPORT FROM "luaL_$1"
proc checkversion*(L: PState; ver: lua_Number; sz: csize) {.importc: "luaL_checkversion_".}
proc checkversion*(L: PState) {.inline.} = L.checkversion(LUA_VERSION_NUM, LUAL_NUMSIZES)

proc getmetafield*(L: PState; obj: cint; e: cstring): cint {.iluaL.}
proc callmeta*(L: PState; obj: cint; e: cstring): cint {.iluaL.}
#proc tolstring*(L: PState; idx: cint; len: ptr csize): cstring {.importc: "luaL_tolstring".}
# ^ duplicate?
proc argerror*(L: PState; numarg: cint; extramsg: cstring): cint {.iluaL.}
proc checklstring*(L: PState; arg: cint; len: ptr csize): cstring {.iluaL.}
proc optlstring*(L: PState; arg: cint; def: cstring; len: ptr csize): cstring {.iluaL.}
proc checknumber*(L: PState; arg: cint): lua_Number {.iluaL.}
proc optnumber*(L: PState; arg: cint; def: lua_Number): lua_Number {.iluaL.}
proc checkinteger*(L: PState; arg: cint): lua_Integer {.iluaL.}
proc optinteger*(L: PState; arg: cint; def: lua_Integer): lua_Integer {.iluaL.}
proc checkstack*(L: PState; sz: cint; msg: cstring) {.iluaL.}
proc checktype*(L: PState; arg: cint; t: cint) {.iluaL.}
proc checkany*(L: PState; arg: cint) {.iluaL.}
proc newmetatable*(L: PState; tname: cstring): cint {.iluaL.}
proc setmetatable*(L: PState; tname: cstring) {.iluaL.}
proc testudata*(L: PState; ud: cint; tname: cstring): pointer {.iluaL.}
proc checkudata*(L: PState; ud: cint; tname: cstring): pointer {.iluaL.}
proc where*(L: PState; lvl: cint) {.iluaL.}
proc error*(L: PState; fmt: cstring): cint {.varargs, iluaL.}
proc checkoption*(L: PState; arg: cint; def: cstring; lst: var cstring): cint {.iluaL.}
proc fileresult*(L: PState; stat: cint; fname: cstring): cint {.iluaL.}
proc execresult*(L: PState; stat: cint): cint {.iluaL.}

# pre-defined references
const
  LUA_NOREF* = (- 2)
  LUA_REFNIL* = (- 1)
proc luaref*(L: PState; t: cint): cint {.iluaL, importc:"luaL_ref".}
proc unref*(L: PState; t: cint; iref: cint) {.iluaL.}
proc loadfilex*(L: PState; filename: cstring; mode: cstring): cint {.iluaL.}
proc loadfile*(L: PState; filename: cstring): cint = L.loadfilex(filename, nil)

proc loadbufferx*(L: PState; buff: cstring; sz: csize; name, mode: cstring): cint {.iluaL.}
proc loadstring*(L: PState; s: cstring): cint {.iluaL.}
proc newstate*(): PState {.iluaL.}
proc llen*(L: PState; idx: cint): cint {.iluaL, importc:"luaL_len".}
proc gsub*(L: PState; s: cstring; p: cstring; r: cstring): cstring {.iluaL.}
proc setfuncs*(L: PState; L2: ptr luaL_Reg; nup: cint) {.iluaL.}
proc getsubtable*(L: PState; idx: cint; fname: cstring): cint {.iluaL.}
proc traceback*(L: PState; L1: PState; msg: cstring; level: cint) {.iluaL.}
proc requiref*(L: PState; modname: cstring; openf: TCFunction; glb: cint) {.iluaL.}
#
#* ===============================================================
#* some useful macros
#* ===============================================================
#

proc newlibtable*(L: PState, arr: openArray[luaL_Reg]){.inline.} =
  createtable(L, 0, (arr.len - 1).cint)

proc newlib*(L: PState, arr: var openArray[luaL_Reg]) {.inline.} =
  newlibtable(L, arr)
  setfuncs(L, cast[ptr luaL_reg](addr(arr)), 0)

proc argcheck*(L: PState, cond: bool, numarg: int, extramsg: string) {.inline.} =
  if not cond: discard L.argerror(numarg.cint, extramsg)

proc checkstring*(L: PState, n: int): cstring {.inline.} = L.checklstring(n.cint, nil)
proc optstring*(L: PState, n: int, d: string): cstring {.inline.} = L.optlstring(n.cint, d, nil)

proc checkint*(L: PState, n: lua_Integer): lua_Integer {.inline.} = L.checkinteger(n.cint)
proc optint*(L: PState, n, d: lua_Integer): lua_Integer {.inline.} = L.optinteger(n.cint, d)
proc checklong*(L: PState, n: int, d: clong): clong {.inline.} = cast[clong](L.checkinteger(n.cint))
proc optlong*(L: PState, n: int, d: lua_Integer): clong = cast[clong](L.optinteger(n.cint, d))

proc Ltypename*(L: PState, i: cint): cstring {.inline.} =
  L.typename(L.luatype(i))

proc dofile*(L: PState, file: string): cint {.inline, discardable.} =
  result = L.loadfile(file) or L.pcall(0, LUA_MULTRET, 0)

proc dostring*(L: PState, s: string): cint {.inline, discardable.} =
  result = L.loadstring(s) or L.pcall(0, LUA_MULTRET, 0)

proc getmetatable*(L: PState, s: string) {.inline.} =
  L.getfield(LUA_REGISTRYINDEX, s)

template opt*(L: PState, f: TCFunction, n, d: typed): typed =
  if L.isnoneornil(n): d else: L.f(n)

proc loadbuffer*(L: PState, buff: string, name: string): cint =
  L.loadbufferx(buff, buff.len, name, nil)

#
#@@ TBufferSIZE is the buffer size used by the lauxlib buffer system.
#* CHANGE it if it uses too much C-stack space.
#
const
  Lua_BufferSIZE* = 8192'i32 # BUFSIZ\
    ## COULD NOT FIND BUFSIZE ?? on my machine this is 8192
#
#* {======================================================
#* Generic Buffer manipulation
#* =======================================================
#
type
  PBuffer* = ptr TBuffer
  TBuffer* {.pure, final.} = object
    b*: cstring             # buffer address
    size*: csize           # buffer size
    n*: csize              # number of characters in buffer
    L*: PState
    initb*: array[Lua_BufferSIZE, char] # initial buffer

proc buffinit*(L: PState; B: PBuffer) {.iluaL.}
proc prepbuffsize*(B: PBuffer; sz: csize): cstring {.iluaL.}
proc addlstring*(B: PBuffer; s: cstring; len: csize) {.iluaL.}
proc addstring*(B: PBuffer; s: cstring) {.iluaL.}
proc addvalue*(B: PBuffer) {.iluaL.}
proc pushresult*(B: PBuffer) {.iluaL.}
proc pushresultsize*(B: PBuffer; sz: csize) {.iluaL.}
proc buffinitsize*(L: PState; B: PBuffer; sz: csize): cstring {.iluaL.}
proc addchar*(B: PBuffer, c: char) =
  if B.n < B.size: discard B.prepbuffsize(1)
  B.b[B.n] = c
  inc B.n

proc addsize*(B: PBuffer, s: int) {.inline.} = inc(B.n, s)
proc prepbuffer*(B: PBuffer): cstring {.inline.} = prepbuffsize(B, Lua_BufferSIZE)

# }======================================================
#
#* {======================================================
#* File handles for IO library
#* =======================================================
#
#
#* A file handle is a userdata with metatable 'LUA_FILEHANDLE' and
#* initial structure 'luaL_Stream' (it may contain other fields
#* after that initial structure).
#
const
  LUA_FILEHANDLE* = "FILE*"
type
  luaL_Stream* {.pure, final.} = object
    f*: File            # stream (NULL for incompletely created streams)
    closef*: TCFunction  # to close stream (NULL for closed streams)

# }======================================================
# compatibility with old module system
when defined(LUA_COMPAT_MODULE):
  proc pushmodule*(L: PState; modname: cstring; sizehint: cint){.iluaL.}
  proc openlib*(L: PState; libname: cstring; ls: ptr luaL_Reg; nup: cint){.iluaL.}
  proc register*(L: PState, n: string, ls: var openArray[luaL_Reg]) {.inline.} =
    L.openlib(n, cast[ptr luaL_reg](addr(ls)), 0)

when isMainModule:
  #import lua52
  import strutils

  echo "Starting Lua"
  var L = newState()

  proc myPanic(L: PState): cint {.cdecl.} =
    echo "panic"

  #discard L.atpanic(myPanic)

  var regs = [
    luaL_Reg(name: "abc", fn: myPanic),
    luaL_Reg(name: nil, fn: nil)
  ]

  L.newlib(regs)
  L.setglobal("mylib")
  echo L.dostring("mylib.abc()")

  #echo "Loading libraries"
  #L.openLibs
  #
  #when defined (Lua_REPL):
  #  import rdstdin
  #  echo "To leave the REPL, hit ^D, type !!!, or call quit()"
  #
  #  var line: string = ""
  #  while readlineFromStdin ("> ", line):
  #
  #    if line == "!!!": break
  #
  #    let result = L.loadString(line).TThreadStatus
  #    if result == Thread_OK:
  #      let result =  L.pcall(0, LUA_MULTRET, 0).TThreadStatus
  #      case result
  #      of Thread_OK:     discard
  #      else:             echo result
  #    else:
  #      echo result
  #
  #else:
  #  proc testFunc (L: PState): cint {.cdecl.} =
  #    #foo
  #    echo "Hello thar"
  #
  #  echo "Setting testFunc"
  #  L.pushCfunction testFunc
  #  L.setGlobal "testFunc"
  #
  #  const LuaScript = "testFunc()"
  #  echo "Loading script: \"\"\"\L$1\L\"\"\"".format(LuaScript)
  #
  #  let result = L.loadString(LuaScript).TThreadStatus
  #  echo "return: ", result
  #
  #  if result == Thread_OK:
  #    echo "Running script"
  #    let result = L.pcall (0, LUA_MULTRET, 0)

  echo "Closing Lua state"
  #L.close


