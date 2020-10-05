if !exists('g:nind#enable')
  let g:nind#enable = v:true
endif

function nind#adjust() abort
  if !nind#is_enabled() || mode(1) isnot# 'n'
    return
  endif

  let prev_cursor = get(w:, 'nind_prev_cursor', [])
  let current_cursor = getcurpos()
  if current_cursor == prev_cursor
    return
  endif
  let w:nind_prev_cursor = current_cursor

  let line = getline('.')
  if line !~# '\S'
    return
  endif

  let indent = len(matchstr(line, '^\s*'))
  if current_cursor[2] <= indent
    let current_cursor[4] = current_cursor[2]
    let current_cursor[2] = indent + 1
    call setpos('.', current_cursor)
  endif
endfunction

function nind#is_enabled(...) abort
  let winid = a:0 ? a:1 : win_getid()
  let v = getwinvar(winid, 'nind_enable', v:null)
  if v isnot# v:null
    return v
  endif
  let v = gettabvar(win_id2tabwin(winid)[0], 'nind_enable', v:null)
  if v isnot# v:null
    return v
  endif
  let v = getbufvar(winbufnr(winid), 'nind_enable', v:null)
  if v isnot# v:null
    return v
  endif
  return g:nind#enable
endfunction

function nind#enable(scope) abort
  let [dict, key] = s:enable_var(a:scope)
  let dict[key] = v:true
endfunction

function nind#disable(scope) abort
  let [dict, key] = s:enable_var(a:scope)
  let dict[key] = v:false
endfunction

function nind#toggle(scope) abort
  let [dict, key] = s:enable_var(a:scope)
  let v = has_key(dict, key) ? dict[key] : nind#is_enabled()
  let dict[key] = !v
endfunction

function nind#reset(scope) abort
  let [dict, key] = s:enable_var(a:scope)
  if dict isnot g:
    unlet! dict[key]
  endif
endfunction

function s:enable_var(scope) abort
  if a:scope is# 'buffer'
    return [b:, 'nind_enable']
  endif
  if a:scope is# 'tabpage'
    return [t:, 'nind_enable']
  endif
  if a:scope is# 'window'
    return [w:, 'nind_enable']
  endif
  return [g:, 'nind#enable']
endfunction

function nind#complete(lead, cmd, pos) abort
  let scopes = ['window', 'tabpage', 'buffer', 'global']
  return filter(scopes, 'v:val =~# "^" . a:lead')
endfunction
