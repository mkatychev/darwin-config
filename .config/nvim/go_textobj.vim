 " don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" ( ) motions
" { } motions
" s for sentence
" p for paragraph
" < >
" t for tag
if get(g:, "go_textobj_enabled", 1)
  onoremap <buffer> <silent> af :<c-u>call go_textobj#Function('a')<cr>
  xnoremap <buffer> <silent> af :<c-u>call go_textobj#Function('a')<cr>

  onoremap <buffer> <silent> if :<c-u>call go_textobj#Function('i')<cr>
  xnoremap <buffer> <silent> if :<c-u>call go_textobj#Function('i')<cr>

  onoremap <buffer> <silent> ac :<c-u>call go_textobj#Comment('a')<cr>
  xnoremap <buffer> <silent> ac :<c-u>call go_textobj#Comment('a')<cr>

  onoremap <buffer> <silent> ic :<c-u>call go_textobj#Comment('i')<cr>
  xnoremap <buffer> <silent> ic :<c-u>call go_textobj#Comment('i')<cr>

  " Remap ]] and [[ to jump betweeen functions as they are useless in Go
  nnoremap <buffer> <silent> ]] :<c-u>call go_textobj#FunctionJump('n', 'next')<cr>
  nnoremap <buffer> <silent> [[ :<c-u>call go_textobj#FunctionJump('n', 'prev')<cr>

  onoremap <buffer> <silent> ]] :<c-u>call go_textobj#FunctionJump('o', 'next')<cr>
  onoremap <buffer> <silent> [[ :<c-u>call go_textobj#FunctionJump('o', 'prev')<cr>

  xnoremap <buffer> <silent> ]] :<c-u>call go_textobj#FunctionJump('v', 'next')<cr>
  xnoremap <buffer> <silent> [[ :<c-u>call go_textobj#FunctionJump('v', 'prev')<cr>
endif

function! go_textobj#Comment(mode) abort
  let l:fname = expand('%:p')

  try
    if &modified
      let l:tmpname = tempname()
      call writefile(go_textobj#GetLines(), l:tmpname)
      let l:fname = l:tmpname
    endif

    let l:cmd = ['motion',
          \ '-format', 'json',
          \ '-file', l:fname,
          \ '-offset', go_textobj#OffsetCursor(),
          \ '-mode', 'comment',
          \ ]

    let l:out = system(l:cmd)
  finally
    if exists("l:tmpname")
      call delete(l:tmpname)
    endif
  endtry

  let l:result = json_decode(l:out)
  if type(l:result) != 4 || !has_key(l:result, 'comment')
    return
  endif

  let l:info = l:result.comment
  call cursor(l:info.startLine, l:info.startCol)

  " Adjust cursor to exclude start comment markers. Try to be a little bit
  " clever when using multi-line '/*' markers.
  if a:mode is# 'i'
    " trim whitespace so matching below works correctly
    let l:line = substitute(getline('.'), '^\s*\(.\{-}\)\s*$', '\1', '')

    " //text
    if l:line[:2] is# '// '
      call cursor(l:info.startLine, l:info.startCol+3)
    " // text
    elseif l:line[:1] is# '//'
      call cursor(l:info.startLine, l:info.startCol+2)
    " /*
    " text
    elseif l:line =~# '^/\* *$'
      call cursor(l:info.startLine+1, 0)
      " /*
      "  * text
      if getline('.')[:2] is# ' * '
        call cursor(l:info.startLine+1, 4)
      " /*
      "  *text
      elseif getline('.')[:1] is# ' *'
        call cursor(l:info.startLine+1, 3)
      endif
    " /* text
    elseif l:line[:2] is# '/* '
      call cursor(l:info.startLine, l:info.startCol+3)
    " /*text
    elseif l:line[:1] is# '/*'
      call cursor(l:info.startLine, l:info.startCol+2)
    endif
  endif

  normal! v

  " Exclude trailing newline.
  if a:mode is# 'i'
    let l:info.endCol -= 1
  endif

  call cursor(l:info.endLine, l:info.endCol)

  " Exclude trailing '*/'.
  if a:mode is# 'i'
    let l:line = getline('.')
    " text
    " */
    if l:line =~# '^ *\*/$'
      call cursor(l:info.endLine - 1, len(getline(l:info.endLine - 1)))
    " text */
    elseif l:line[-3:] is# ' */'
      call cursor(l:info.endLine, l:info.endCol - 3)
    " text*/
    elseif l:line[-2:] is# '*/'
      call cursor(l:info.endLine, l:info.endCol - 2)
    endif
  endif
endfunction

" Select a function in visual mode.
function! go_textobj#Function(mode) abort
  let l:fname = expand("%:p")
  if &modified
    let l:tmpname = tempname()
    call writefile(go_textobj#GetLines(), l:tmpname)
    let l:fname = l:tmpname
  endif

  let l:cmd = ['motion',
        \ '-format', 'vim',
        \ '-file', l:fname,
        \ '-offset', go_textobj#OffsetCursor(),
        \ '-mode', 'enclosing',
        \ ]

  if go_textobj#TextobjIncludeFunctionDoc()
    let l:cmd += ['-parse-comments']
  endif

  let l:out = system(l:cmd)

  " if exists, delete it as we don't need it anymore
  if exists("l:tmpname")
    call delete(l:tmpname)
  endif

  " convert our string dict representation into native Vim dictionary type
  let result = eval(out)
  if type(result) != 4 || !has_key(result, 'fn')
    return
  endif

  let info = result.fn

  if a:mode == 'a'
    " anonymous functions doesn't have associated doc. Also check if the user
    " want's to include doc comments for function declarations
    if has_key(info, 'doc') && go_textobj#TextobjIncludeFunctionDoc()
      call cursor(info.doc.line, info.doc.col)
    elseif info['sig']['name'] == '' && go_textobj#TextobjIncludeVariable()
      " one liner anonymous functions
      if info.lbrace.line == info.rbrace.line
        " jump to first nonblack char, to get the correct column
        call cursor(info.lbrace.line, 0 )
        normal! ^
        call cursor(info.func.line, col("."))
      else
        call cursor(info.func.line, info.rbrace.col)
      endif
    else
      call cursor(info.func.line, info.func.col)
    endif

    normal! v
    call cursor(info.rbrace.line, info.rbrace.col)
    return
  endif

  " rest is inner mode, a:mode == 'i'

  " if the function is a one liner we need to select only that portion
  if info.lbrace.line == info.rbrace.line
    call cursor(info.lbrace.line, info.lbrace.col+1)
    normal! v
    call cursor(info.rbrace.line, info.rbrace.col-1)
    return
  endif

  call cursor(info.lbrace.line+1, 1)
  normal! V
  call cursor(info.rbrace.line-1, 1)
endfunction

" Get the location of the previous or next function.
function! go_textobj#FunctionLocation(direction, cnt) abort
  let l:fname = expand("%:p")
  if &modified
    " Write current unsaved buffer to a temp file and use the modified content
    let l:tmpname = tempname()
    call writefile(go_textobj#GetLines(), l:tmpname)
    let l:fname = l:tmpname
  endif

  let l:cmd = ['motion',
        \ '-format', 'vim',
        \ '-file', l:fname,
        \ '-offset', go_textobj#OffsetCursor(),
        \ '-shift', a:cnt,
        \ '-mode', a:direction,
        \ ]

  if go_textobj#TextobjIncludeFunctionDoc()
    let l:cmd += ['-parse-comments']
  endif

  let l:out = system(l:cmd)

  " if exists, delete it as we don't need it anymore
  if exists("l:tmpname")
    call delete(l:tmpname)
  endif

  let l:result = json_decode(out)
  if type(l:result) != 4 || !has_key(l:result, 'fn')
    return 0
  endif

  return l:result
endfunction

function! go_textobj#FunctionJump(mode, direction) abort
  " get count of the motion. This should be done before all the normal
  " expressions below as those reset this value(because they have zero
  " count!). We abstract -1 because the index starts from 0 in motion.
  let l:cnt = v:count1 - 1

  " set context mark so we can jump back with  '' or ``
  normal! m'

  " select already previously selected visual content and continue from there.
  " If it's the first time starts with the visual mode. This is needed so
  " after selecting something in visual mode, every consecutive motion
  " continues.
  if a:mode == 'v'
    normal! gv
  endif

  let l:result = go_textobj#FunctionLocation(a:direction, l:cnt)
  if l:result is 0
    return
  endif

  " we reached the end and there are no functions. The usual [[ or ]] jumps to
  " the top or bottom, we'll do the same.
  if type(result) == 4 && has_key(result, 'err') && result.err == "no functions found"
    if a:direction == 'next'
      keepjumps normal! G
    else " 'prev'
      keepjumps normal! gg
    endif
    return
  endif

  let info = result.fn

  " if we select something ,select all function
  if a:mode == 'v' && a:direction == 'next'
    keepjumps call cursor(info.rbrace.line, 1)
    return
  endif

  if a:mode == 'v' && a:direction == 'prev'
    if has_key(info, 'doc') && go_textobj#TextobjIncludeFunctionDoc()
      keepjumps call cursor(info.doc.line, 1)
    else
      keepjumps call cursor(info.func.line, 1)
    endif
    return
  endif

  keepjumps call cursor(info.func.line, 1)
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
function! go_textobj#EchoError(msg)
  call s:echo(a:msg, 'ErrorMsg')
endfunction

" Get all lines in the buffer as a a list.
function! go_textobj#GetLines()
  let buf = getline(1, '$')
  if &encoding != 'utf-8'
    let buf = map(buf, 'iconv(v:val, &encoding, "utf-8")')
  endif
  if &l:fileformat == 'dos'
    " XXX: line2byte() depend on 'fileformat' option.
    " so if fileformat is 'dos', 'buf' must include '\r'.
    let buf = map(buf, 'v:val."\r"')
  endif
  return buf
endfunction

" Returns the byte offset for line and column
function! go_textobj#Offset(line, col) abort
  if &encoding != 'utf-8'
    let sep = go_textobj#LineEnding()
    let buf = a:line == 1 ? '' : (join(getline(1, a:line-1), sep) . sep)
    let buf .= a:col == 1 ? '' : getline('.')[:a:col-2]
    return len(iconv(buf, &encoding, 'utf-8'))
  endif
  return line2byte(a:line) + (a:col-2)
endfunction
"
" Returns the byte offset for the cursor
function! go_textobj#OffsetCursor() abort
  return go_textobj#Offset(line('.'), col('.'))
endfunction


" LineEnding returns the correct line ending, based on the current fileformat
function! go_textobj#LineEnding() abort
  if &fileformat == 'dos'
    return "\r\n"
  elseif &fileformat == 'mac'
    return "\r"
  endif

  return "\n"
endfunction

function! go_textobj#TextobjIncludeFunctionDoc() abort
  return get(g:, "go_textobj_include_function_doc", 1)
endfunction

function! go_textobj#TextobjIncludeVariable() abort
  return get(g:, "go_textobj_include_variable", 1)
endfunction

