let g:fstree_cfg = {
    \ "indent": 2,
    \ "sigopen": "-",
    \ "sigclos": "+",
    \ "exclude": ["^%.$", "^%..$"],
    \ "ordering": "dirontop"
\ }

function s:open()
    lua require("fstree").open()
endfunction

function s:expand()
    lua require("fstree").expand()
endfunction

function s:collapse()
    lua require("fstree").collapse()
endfunction

function s:clear()
    lua require("fstree").clear()
endfunction

command FsTreeOpen :call s:open()
command FsTreeExpand :call s:expand()
command FsTreeCollapse :call s:collapse()
" command TreeNext :call s:next()
" command TreeBack :call s:back()
" command TreeCollapse :call s:collapse()
" command TreeLocate :call s:locate()
command FsTreeClear :call s:clear()