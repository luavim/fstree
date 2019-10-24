-- local plugin = require("plugin")
local fs = require("fstree.fs")
local conf = require("fstree.conf")
local Tree = require("fstree.tree")
local View = require("fstree.view")


local VAR_STATE = "fstree.state"

local CREATE = {
    [fs.TYPE.DIR] = fs.mkdir,
    [fs.TYPE.REG] = fs.creat,
}

--- Transforms table using the function provided.
-- @param  tab -- table to be transformed
-- @param  fun -- transforming function
-- @return new table {k: fun(v) for k, v in tab}
local function map(tab, fn)
    local out = {}
    for k, v in pairs(tab) do
        out[k] = fn(v)
    end
    return out
end

local Controller = {}
Controller.__index = Controller

function Controller.new(view, state)
    local self = setmetatable({}, Controller)

    self.state = state
    self.view = view

    return self
end

function Controller:open()
    self:opendir(self.state.cwd)
end

function Controller:addsubdir(dir, linenr, level)
    local filter = conf.filter()
    local order = conf.order()

    local subtree = Tree.scan(dir, level, self.state.expanded, filter, order)
    self.state.tree:insert(linenr, subtree)

    local lines = map(subtree.entries, conf.formatter(self.state.expanded))
    self.view:set_lines(linenr - 1, lines)
end

function Controller:opendir(dir)
    self.state.cwd = dir

    self.state.tree:clear()
    self.view:clear()

    self:addsubdir(dir, 1, 0)
    self.view:set_name(dir)
end

local function loadstate(win)
    local ok, state = pcall(vim.api.nvim_win_get_var, win, VAR_STATE)
    if not ok then
        return nil
    end

    setmetatable(state.tree, Tree)
    return state
end

local function invoke(action)
    local win = vim.api.nvim_get_current_win()
    local cwd = vim.api.nvim_command_output("pwd")

    local state = loadstate(win)
    if state == nil or state.cwd ~= cwd then
        state = {cwd = cwd, expanded = {}, tree = Tree.new()}
    end

    local view = View.new()
    view:set_current()

    action(Controller.new(view, state))

    vim.api.nvim_win_set_var(win, VAR_STATE, state)
end

local _M = {}

--- Open new buffer with a file system tree representing the current directory.
--- Only one buffer is allowed for a window.
function _M.open()
    invoke(function(c) c:open() end)
end

--- If the current line represents a file, open that file in a new buffer.
--- If the current line represents a directory, show it's file system tree in
--- the current buffer.
function _M.next()
    invoke(function(c) c:next() end)
end

--- Open file system tree of the parrent directory in the current buffer.
function _M.back()
    invoke(function(c) c:back() end)
end

--- Create new directory.
function _M.mkdir()
    invoke(function(c) c:mkdir() end)
end

--- Create new file.
function _M.create()
    invoke(function(c) c:create() end)
end

--- Delete items selected.
function _M.delete()
    invoke(function(c) c:delete() end)
end

--- Locate current file (if any) in a file system tree.
function _M.locate()
    invoke(function(c) c:locate() end)
end

--- Expand content of the directory selected.
function _M.expand()
    invoke(function(c) c:expand() end)
end

--- Collapse the directory selected.
function _M.collapse()
    invoke(function(c) c:collapse() end)
end

return _M
