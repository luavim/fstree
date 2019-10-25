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

function View.get()
    local self = setmetatable({}, View)

    local bt = vim.api.nvim_buf_get_option(0, "bt")
    if bt == BUFOPTS.bt then
        return self
    end

    local buf = vim.api.nvim_create_buf(false, true)
    for k, v in pairs(BUFOPTS) do
        vim.api.nvim_buf_set_option(buf, k, v)
    end

    vim.api.nvim_set_current_buf(buf)
    return self
end

function View:add_lines(pos, lines)
    self:set_content(pos, pos, true, lines)
end

function View:set_lines(pos, lines)
    self:set_content(pos, pos + #lines, false, lines)
end

function View:del_lines(pos, len)
    self:set_content(pos, pos + len, false, {})
end

function View:clear()
    self:set_content(0, vim.api.nvim_buf_line_count(0), false, {})
end

function View:set_content(a, b, strict, lines)
    vim.api.nvim_buf_set_option(self.buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(self.buf, a, b, strict, lines)
    vim.api.nvim_buf_set_option(self.buf, "modifiable", false)
end

function View:set_name(name)
    vim.api.nvim_buf_set_name(self.buf, name)
end

function View:linenr()
    return vim.api.nvim_win_get_cursor(0)[1]
end

return {get = View.get}
