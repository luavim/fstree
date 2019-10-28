local Model = require("fstree.model")

local Controller = {}

function Controller.open(model, view, path, line)
    view:clear()
    view:set_lines(1, model:lines(1))
    view:set_name(path)
    view:set_linenr(line or 1)
    return model
end

function Controller.expand(model, view, linenr)
    local len = model:expand(linenr)
    view:add_lines(linenr + 1, model:lines(linenr + 1, len))
    view:set_lines(linenr, model:lines(linenr, 1))
    return model
end

function Controller.collapse(model, view, linenr)
    local len = model.collapse(linenr)
    view:del_lines(linenr + 1, len)
    view:set_lines(linenr, model:lines(linenr, 1))
    return model
end

function Controller.mkdir(model, view, linenr, name)
    view.add_lines(model:mkdir(linenr, name))
    return model
end

function Controller.mkfile(model, view)
    view.add_lines(model:mkdir(linenr, name))
    return model
end

function Controller.delete(model, view, linenr)
    view:del_lines(model:delete(linenr))
    return model
end

function Controller.locate(model, view, path)
    local linenr = model:locate(path)
    return Controller.open(model, view, linenr)
end

return Controller
