--- File system view.
---
local BUFOPTS = {
    bt = "nofile",
    ft = "fstree",
    bufhidden = "wipe",
    swapfile = false,
}

local View = {}
View.__index = View

function View.new()
    local self = setmetatable({}, View)

    self.buf = vim.api.nvim_create_buf(false, true)
    for k, v in pairs(BUFOPTS) do
        vim.api.nvim_buf_set_option(self.buf, k, v)
    end

    return self
end

function View:set_lines(pos, lines)
    vim.api.nvim_buf_set_option(self.buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(self.buf, pos, -1, true, lines)
    vim.api.nvim_buf_set_option(self.buf, "modifiable", false)
end

function View:set_name(name)
    vim.api.nvim_buf_set_name(self.buf, name)
end

function View:set_current()
    vim.api.nvim_set_current_buf(self.buf)
end

function View:linenr()
    return vim.api.nvim_eval("line(.)")
end

function View:clear()
    self:set_lines(0, {})
end

return {new = View.new}
