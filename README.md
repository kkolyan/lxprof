# About
frontend for [LuaJit 2.1 profiler](https://blast.hk/moonloader/luajit/ext_profiler.html)

# Features
* easy programmatic use
* hierarchical report
* reports in readable YAML
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
# Report Example
(Items can be folded and expanded using any advanced text editor, so larger size is not a problem)
```yaml
Samples: 1068
100.00 % - [string] : 769
  99.91 % - xpcall
    99.91 % - [string] : 594
      97.19 % - demo/vision/init.lua : draw
        75.66 % - demo/vision/Field.lua : forEachCell
          72.00 % - demo/vision/init.lua : callback
            33.52 % - core/misc/Vector.lua : worldToScreen
              13.67 % - core/misc/meta.lua : readonly
              10.58 % - core/misc/Vector.lua : unpackIf
            22.19 % - demo/vision/Field.lua : worldToScreen
              21.44 % - core/misc/Vector.lua : ofAxes
                13.48 % - core/misc/meta.lua : readonly
                 2.81 % - core/misc/Vector.lua : unpackIf
            14.23 % - demo/vision/TextureAtlasFactory.lua : draw
        20.79 % - core/misc/utils.lua : withColor
          19.94 % - demo/vision/init.lua : callback
         0.19 % - core/misc/utils.lua : drawLinesToDisplay
         0.09 % - demo/vision/Field.lua : forEachCharacter
           0.09 % - demo/vision/init.lua : callback
       0.56 % - demo/vision/init.lua : update
         0.28 % - core/misc/utils.lua : update
           0.28 % - core/misc/FpsLabel.lua : update
             0.19 % - core/misc/utils.lua : displayLine
               0.09 % - core/misc/utils.lua : format
                 0.09 % - core/misc/tostring.lua : tostring
                   0.09 % - core/misc/tostring.lua : x
         0.09 % - core/misc/utils.lua : isPressed
VM States:
  40.45 % - interpreted code
  30.99 % - C code
  21.54 % - the garbage collector
   6.74 % - native (compiled) code
   0.28 % - the JIT compiler
```
