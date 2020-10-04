if exists('g:loaded_nind')
  finish
endif
let g:loaded_nind = 1

command! -nargs=? -complete=customlist,nind#complete
\   NindEnable call nind#enable(<q-args>)
command! -nargs=? -complete=customlist,nind#complete
\   NindDisable call nind#disable(<q-args>)
command! -nargs=? -complete=customlist,nind#complete
\   NindToggle call nind#toggle(<q-args>)
command! -nargs=1 -complete=customlist,nind#complete
\   NindReset call nind#reset(<q-args>)

augroup plugin-nind
  autocmd!
  autocmd CursorMoved * call nind#adjust()
augroup END
