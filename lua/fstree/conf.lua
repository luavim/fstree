local fs = require("fstree.fs")

local CFG = vim.api.nvim_get_var("fstree_cfg")

local PREFIX = {
    [fs.TYPE.DIR] = function(e, expanded)
        return expanded[e.path] and CFG.sigopen or CFG.sigclos
    end,

    [fs.TYPE.REG] = function(e, expanded)
        return " "
    end,

    [fs.TYPE.LNK] = function(e, expanded)
        return " "
    end,
}

--- Create filter function from array of exclude patterns.
-- @param  patterns array: exclude patterns
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

--- Defines sorting order of directory items where directories are always on
-- top and all items ordered alphabetically.
-- @param  a table: left value
-- @param  b table: right value
-- @return bool: true if a < b, otherwise false
local function order_dirontop(a, b)
    if a.type == fs.TYPE.DIR then
        if b.type == fs.TYPE.DIR then
            return a.name < b.name
        else
            return true
        end
    else
        if b.type == fs.TYPE.DIR then
            return false
        else
            return a.name < b.name
        end
    end
end

--- Creaate formatter according to the configuration provieded.
-- @param expannded table: table of expanded directories
-- @return (entry) -> string: directory entry formatter
local function formatter(expanded)
    return function(entry)
        local indent = string.rep(" ", CFG.indent * entry.level)
        local prefix = PREFIX[entry.type](entry, expanded)
        return string.format("%s%s %s", indent, prefix, entry.name)
    end
end

local ORDERS = {dirontop = order_dirontop}

local _M = {}

function _M.filter()
    return filter(CFG.exclude)
end

function _M.order()
    -- error(CFG.ordering)
    -- local x = ORDERS[CFG.ordering]
    -- if x == nil then error(string.format( "%s", ORDERS["ordering"] )) end
    return ORDERS[CFG.ordering]
end

function _M.formatter(expanded)
    return formatter(expanded)
end

return _M
