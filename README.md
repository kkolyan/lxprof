# About
frontend for [LuaJit 2.1 profiler](https://blast.hk/moonloader/luajit/ext_profiler.html)

# Features
* easy programmatic use
* hierarchical report
* report is YAML, so its sections can be folded and expanded using any advanced text editor
* fast as hell (thanks for LuaJit profiling backend)

# Usage
download `lxprof.lua` into the project, then:
```Lua
local lxprof = require("lxprof")

-- start gathering samples
lxprof.start()

-- stop gathering samples
lxprof.stop()

-- generate report report
lxprof.report()

-- (default) report stored to file "lxprof.latest.yaml" (overwriting) 
lxprof.dateBasedReportName = false

-- report stored to date-based file "lxprof.${date}.yaml" 
lxprof.dateBasedReportName = true

-- delete all gathered samples
lxprof.reset()
```
