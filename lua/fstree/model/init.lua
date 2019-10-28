local fs = require("fstree.model.fs")
local order = require("fstree.model.sort")
local Tree = require("fstree.model.tree")


--- Create filter function from array of exclude patterns.
-- @param patterns: list of patterns to be excluded
-- @return function: filter function
local function filter(patterns)
    return function(name)
        for k, v in pairs(patterns) do
            if string.match(name, v) then
                return true
            end
        end
        return false
    end
end

--- Creaate formatter according to the configuration provieded.
-- @param expannded table: table of expanded directories
-- @return (entry) -> string: directory entry formatter
local function formatter(expanded)
    local cfg = vim.api.nvim_get_var("fstree_fmt")

    local prefix = {
        [fs.TYPE.DIR] = function(e, expanded)
            return expanded[e.path] and cfg.sigopen or cfg.sigclos
        end,
    
        [fs.TYPE.REG] = function(e, expanded)
            return " "
        end,
    
        [fs.TYPE.LNK] = function(e, expanded)
            return " "
        end,
    }

    return function(entry)
        local indent = string.rep(" ", cfg.indent * entry.level)
        local prefix = prefix[entry.type](entry, expanded)
        return string.format("%s%s %s", indent, prefix, entry.name)
    end
end


Model = {}
Model.__index = Model

function Model.open(cfg, dir)
    if cfg.state is nil or cfg.state.cwd ~= dir then
        cfg.state = {
            cwd = dir,
            expanded = {},
            tree = Tree.scan(dir, 0, {}, filter(cfg.exclude), order[cfg.order]),
        }
    end

    setmetatable(cfg.state, Model)
    setmetatable(cfg.state.tree, Tree)

    return cfg.state
end

function Model:expand(linenr)
end

function Model:collapse(linenr)
end

function Model:mkdir(linenr, name)
end

function Model:mkfile(linenr, name)
end

function Model:delete(linenr)
end

function Model:locate(path)
end

return {new = model.new}
