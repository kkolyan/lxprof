local xprof = {}
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

function xprof.start()
    jit_prof.start("f", function(thread, samples, vmstate)
        local stack = jit_prof.dumpstack(thread, "pFZ;", -100)

        parseStack(stack, samples)
    end)
end

function xprof.stop()
    jit_prof.stop()
end

function xprof.report(n)
    print("Samples: " .. tree.samples)
    generateReport(tree, "", n or 100)
end

function xprof.reset()
    tree = newNode()
end

return xprof
