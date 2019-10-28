local model = require("fstree.model")
local view = require("fstree.view")
local controller = require("fstree.controller")


local function readlocal(key)
    local ok, val = pcall(vim.api.nvim_win_get_var, 0, key)
    if not ok then
        return nil
    end
    return val
end

local function load()
    local fmt = vim.api.nvim_get_var("fstree_fmt")
    local tree = readlocal("fstree_tree")
end

local function save(state)

end

local function input(prefix)
    vim.api.nvim_call_function("inputsave", {})
    local value = vim.api.nvim_call_function("input", {prefix})
    vim.api.nvim_call_function("inputrestore", {})
    return value
end

local function cwd()
    return vim.api.nvim_command_output("pwd")
end

local function linenr()
    return vim.api.nvim_win_get_cursor(0)[1]
end

local function curpath()
    return vim.api.nvim_eval("expand('%:p')")
end

local function cd(dir)
    vim.api.nvim_command(string.format("lcd %s", dir))
end

local function edit(path)
    vim.api.nvim_command(string.format("e %s", path))
end

local function invoke(action, ...)
    save(action(model.new(load()), view.show(), ...).state)
end

local Cmd = {}

function Cmd.next()
    local e = model.new(load()):stat(linenr())
    if e.isdir then
        cd(e.name)
        Cmd.open()
    else
        edit(e.name)
    end
end

function Cmd.back()
    cd("..")
    Cmd.open()
end

function Cmd.open()
    invoke(controller.open, cwd(), 1)
end

function Cmd.expand()
    invoke(controller.expand, linenr())
end

function Cmd.collapse()
    invoke(controller.collapse, linenr())
end

function Cmd.mkdir(name)
    invoke(controller.mkdir, linenr(), input("name: "))
end

function Cmd.mkfile()
    invoke(controller.mkfile, linenr(), input("name: "))
end

function Cmd.delete()
    invoke(controller.delete, linenr())
end

function Cmd.locate()
    invoke(controller.locate, curpath())
end

return Cmd
