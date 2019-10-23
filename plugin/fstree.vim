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


command FsTreeOpen :call s:open()
" command TreeNext :call s:next()
" command TreeBack :call s:back()
" command TreeExpand :call s:expand()
" command TreeCollapse :call s:collapse()
" command TreeLocate :call s:locate()