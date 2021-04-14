--[[
  
MIT License

Copyright (c) 2021 Nikolay Plekhanov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]--

local lib = {}
local jit_prof = require("jit.profile")

local function newNode()
    return { samples = 0, children = {} }
end

local tree = newNode()

local function generateReport(node, indent, remainingDepth)
    local children = {}
    for k, v in pairs(node.children) do
        table.insert(children, { name = k, node = v })
    end
    table.sort(children, function(a, b)
        return a.node.samples > b.node.samples
    end)
    if remainingDepth <= 0 then
        print(indent .. "...")
    else
        for i, v in ipairs(children) do
            local w = v.node.samples / tree.samples
            local pct = string.format("%.2f", 100 * w)
            pct = string.rep(" ", 5 - #pct) .. pct
            local name = v.name
            name = string.gsub(name, ":", " : ")
            name = string.gsub(name, " : /", ":/") -- windows disk letter
            print(indent .. pct .. " % - " .. name)
            generateReport(v.node, indent .. "  ", remainingDepth - 1)
        end
    end
end

local function calcRelWeights(node)
    local w = node.samples / tree.samples
    node.weight = string.format("%.2f %%", 100 * w)
    for k, v in pairs(node.children) do
        if type(v) == 'table' then
            calcRelWeights(v)
        end
    end
end

local function append(node, element, samples)
    local child = node.children[element]
    if not child then
        child = newNode()
        node.children[element] = child
    end
    child.samples = child.samples + samples

    return child
end

local function parseStack(stack, samples)
    local offset = 1
    local node = tree
    node.samples = node.samples + samples
    while true do
        local index = string.find(stack, ";", offset, true)
        if not index then
            node = append(node, string.sub(stack, offset), samples)
            break
        end
        node = append(node, string.sub(stack, offset, index - 1), samples)
        offset = index + 1
    end
end

function lib.start()
    jit_prof.start("f", function(thread, samples, vmstate)
        local stack = jit_prof.dumpstack(thread, "pFZ;", -100)

        parseStack(stack, samples)
    end)
end

function lib.stop()
    jit_prof.stop()
end

function lib.report(n)
    print("Samples: " .. tree.samples)
    generateReport(tree, "", n or 100)
end

function lib.reset()
    tree = newNode()
end

return lib
