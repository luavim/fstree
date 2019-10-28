let g:fstree_fmt = {"indent": 2, "sigopen": "-", "sigclos": "+"}
let g:fstree_sorting = "dirontop"
let g:fstree_exclude = ["^%.$", "^%..$"]

lua fstree = require("fstree")

command FsTreeOpen :lua fstree.open()
command FsTreeExpand :lua fstree.expand()
command FsTreeCollapse :lua fstree.collapse()
command FsTreeLocate :lua fstree.locate()
command FsTreeNext :lua fstree.next()
command FsTreeBack :lua fstree.back()
command FsTreeMkDir :lua fstree.mkdir()
command FsTreeMkFile :lua fstree.mkfile()
