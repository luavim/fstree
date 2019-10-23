--- Data structure to store directory entries.
---
local fs = require("fstree.fs")


local Tree = {}
Tree.__index = Tree

--- Creates directory scanner with the names filter provided.
-- @param dir string: directory path to scan
-- @param level int: directory level
-- @param expanded table: table of expanded subdirectories
-- @param filter (e) -> bool: returns true if an item should be skipped
-- @param order (a, b) -> bool: ordering function
-- @return Tree representing directory hierarchy
local function scan(dir, level, expanded, filter, order)
    local tree = Tree.new()

    for e in fs.lsdir(dir) do
        if not filter(e.name) then
            e.level = level
            e.path = fs.join(dir, e.name)
            tree:append(e)
        end
    end

    tree:sort(order)

    for k, v in pairs(expanded) do
        local pos = tree.revers[k]
        if pos then
            local subtree = scan(k, expanded, level + 1)
            tree:insert(pos + 1, subtree)
        end
    end

    return tree
end

--- Creates new empty Tree.
function Tree.new()
    local self = setmetatable({}, Tree)

    self.entries = {}
    self.revers = {}

    return self
end

--- Sort tree items using the order function provided.
-- @param  order (a, b) => int: comparator defining sorting order
function Tree:sort(order)
    table.sort(self.entries, order)

    self.revers = {}
    for k, v in pairs(self.entries) do
        self.revers[v.path] = k
    end
end

--- Adds an entry after the last position.
-- @param  entry table: entry to be added
function Tree:append(entry)
    self.entries[#self.entries + 1] = entry
    self.revers[entry.path] = #self.entries
end

--- Inserts new items starting from the position provided.
-- @param  pos number: position of the first item in the new set
-- @param  new array: new items to be inserted
function Tree:insert(pos, new)
    for k, v in pairs(new.entries) do
        local i = pos + k - 1
        table.insert(self.entries, i, v)
        self.revers[v.path] = i
    end

    for i = pos + #new, #self.entries do
        self.revers[self.entries[i].path] = i
    end
end

--- Removes len entries from the tree starting from the position pos.
-- @param  pos number: remove items starting from this position
-- @param  len number: how many items should be removed
function Tree:remove(pos, len)
    for i = 1, len do
        local e = table.remove(self.entries, pos)
        self.revers[e.path] = nil
    end

    for i = pos, #self.entries do
        local id = self.entries[i].path
        self.revers[id] = self.revers[id] - len
    end
end

--- Remove all items from the tree.
function Tree:clear()
    self.tree = {}
    self.revers = {}
end

--- Insert child in parent directory in the right position according to the
--- order provided.
-- @param  parent string: parent directory
-- @param  child string: child item
-- @param  order (a, b) -> bool: ordering function
function Tree:push(parent, child, order)
    local k = -1
    local n = self.revers[parent] or 0

    for i = n + 1, #self.entries do
        local e = self.entries[i]
        if e.level == child.level and order(child, e) then
            k = i
            table.insert(self.entries, k, child)
            self.revers[child.path] = k
            break
        end
    end

    return k
end

--- Get parent entry of the provided one.
-- @param  entry table: entry which parent is requested
function Tree:parent(entry)
    local pos = self.revers[entry.path]
    for i = pos, 1, -1 do
        local e = self.entries[i]
        if e.level < entry.level and e.type == fs.TYPE.DIR then
            return e
        end
    end
    return nil
end

--- Count child items in the entry.
-- @param  entry table: entry which child items should be counted
-- @return 0 if entriy is not a directory else number of directory items
function Tree:count(entry)
    local cnt = 0
    for i = self.revers[entry.path] + 1, #self.entries do
        if self.entries[i].level <= entry.level then
            break
        end
        cnt = cnt + 1
    end
    return cnt
end

return {new = Tree.new, scan = scan}
