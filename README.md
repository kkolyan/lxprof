# About
frontend for [LuaJit 2.1 profiler](https://blast.hk/moonloader/luajit/ext_profiler.html)

# Features
* easy programmatic use
* hierarchical report
* report can be opened as YAML in any advanced text editor with power of fold/expand, that gives experience near to pro-level profilers
* as fast as hell (thanks for LuaJit profiling backend)

# Usage
download `lxprof.lua` into the project, then:
```Lua
local lxprof = require("lxprof")

-- start gathering samples
lxprof.start()

-- stop gathering samples
lxprof.stop()

-- print report to stdout
lxprof.report()

-- delete all gathered samples
lxprof.reset()
```
