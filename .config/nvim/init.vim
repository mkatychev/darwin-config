"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" " Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" set expandtab
" set hidden
" set mouse=a
" set laststatus=1
syntax off

" let g:rnu = get(g:, 'rnu', 1)
" " Relative number implementation
" if g:rnu
"     set relativenumber number
"     au! InsertLeave * set relativenumber
"     au! InsertEnter * set relativenumber!
"     augroup CursorLineOnlyInActiveNormalWindow
"       autocmd!
"       autocmd VimEnter,WinEnter,BufWinEnter *
"       \ if !&readonly && &modifiable
"       \|     setlocal relativenumber
"       \| endif
"       autocmd WinLeave *
"       \ if !&readonly && &modifiable
"       \|     setlocal norelativenumber
"       \| endif
"     augroup END
" else
"     set number
" endif
" allow absolute numbers in insert mode
set shiftwidth=2
set tabstop=2
set termguicolors
set foldlevelstart=99
set viewoptions-=options,folds
" Make Russian work in normal mode.
set langmap=АБСДЕФГЧИЙКЛМНОПЯРСТУВШХЫЗ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,абсдефгчийклмнопярстувшхыз;abcdefghijklmnopqrstuvwxyz
" set signcolumn=number # hides current line if error on line, follow up
set signcolumn=yes
set nocompatible
" nmap <M-/> <Plug>(comment_toggle_linewise_current)
" vmap <M-/> <Plug>(comment_toggle_linewise_visual)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prelude configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" auto resize split buffers in window resize
au! VimResized * wincmd =
set t_8b=[48;2;%lu;%lu;%lum
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set t_8f=[38;2;%lu;%lu;%lum
" let g:polyglot_disabled = ['sensible', 'rust', 'go']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" '<,'>sort/.*\//
" call plug#begin('~/.vim/plugged')
" Language Client
" searching
" Plug 'junegunn/fzf.vim'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Git
" Plug 'ap/vim-css-color'
" syntax
" Plug 'ARM9/arm-syntax-vim'
" Plug 'mtdl9/vim-log-highlighting'
" Plug 'swinman/vim-nc', { 'branch': 'scaled_error' } " G-Code highlighting
" " Plug 'sirtaj/vim-openscad'
" " Plug 'dcharbon/vim-flatbuffers'
" " motions
" Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-fugitive'
" " misc
" Plug 'godlygeek/tabular'
" Plug 'majutsushi/tagbar', { 'do': 'brew install --HEAD universal-ctags/universal-ctags/universal-ctags' }
" " Tmux
" Plug 'sunaku/tmux-navigate'
" call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LanguageClient
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua require('init')
au! BufWritePre *.go,*.rs,*.svelte,*.js :lua vim.lsp.buf.format()
" " yaml inline langserver settings
" allow completion on single var match for ncm2
set completeopt=menuone,noinsert,noselect

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype Aliases
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au! BufNewFile,BufRead *.json,*.geojson set filetype=json
au! BufNewFile,BufRead *.fbs :syntax on
au! BufNewFile,BufRead .env* set filetype=sh
" au! BufNewFile,BufRead *.yaml,*.yml set filetype=yaml
au! BufNewFile,BufRead *.html,*.xml,*.plist set filetype=xml
au BufNewFile,BufRead *.s,*.S set filetype=arm | set tabstop=8
" au VimEnter,BufWinEnter,BufRead,BufNewFile justfile setlocal commentstring=#\ %s
" au VimEnter,BufWinEnter,BufRead,BufNewFile *.just setlocal filetype=just | commentstring=#\ %s
" au VimEnter,BufWinEnter,BufRead,BufNewFile justfile setlocal filetype=just | commentstring=#\ %s
" au VimEnter,BufWinEnter,BufRead,BufNewFile Justfile setlocal filetype=just | commentstring=#\ %s
" au VimEnter,BufWinEnter,BufRead,BufNewFile .justfile setlocal filetype=just | commentstring=#\ %s
" au VimEnter,BufWinEnter,BufRead,BufNewFile .Justfile setlocal filetype=just | commentstring=#\ %s


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc Global Vars
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:openbrowser_github_select_current_line = 1
" :checkhealth paths
let g:python3_host_prog = 'python3'
let g:python_host_prog = 'python2'
let g:ruby_host_prog = 'ruby'
" markdown config
" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_conceal = 0
" let g:vim_markdown_fenced_languages = ['rust', 'go', 'python']
let g:vim_json_syntax_conceal = 0
let g:netrw_fastbrowse = 0

" autocmd FileType rs let b:surround_11="Option<\r>"
" autocmd FileType rs let b:surround_114="Result<\r>"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't lose visual selection when indenting
vmap > >gv
vmap < <gv
noremap Y y$
" system clipboard Put/Yank
map <C-P> "*P
nmap <C-p> "*p
nmap <C-Y> "*Y
nmap <C-y> "*y

" Yank entire buffer
noremap <silent><F4> gg"*yG<CR>
" Overwrite entire buffer with clipboard
noremap <silent><F5> :%d<CR>"*P<CR>

" <M-[>
noremap <D-i> dd<CR>
noremap <silent><M-w> :BufferClose<CR>

" fuzzy buffer search
noremap <silent><leader>/ <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({case_mod=ignore_case, disable_coordinates=true})<cr>
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)

" command mode emacs bindings
cnoremap <C-A> <C-B>
inoremap <C-A> <C-B>
" clear highlight
nnoremap <silent> <C-L> :nohl <bar> :lua vim.lsp.buf.clear_references()<CR>


" unnmap middle mouse click
:imap <2-MiddleMouse> <Nop>
:map <3-MiddleMouse> <Nop>
:imap <3-MiddleMouse> <Nop>
:map <4-MiddleMouse> <Nop>
:imap <4-MiddleMouse> <Nop>

" FZF commands
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Rguu
  \ call fzf#vim#grep(
  \   'rg -uu --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)


command! -bang -nargs=? -complete=dir Fduu
  \ call s:fzf_command('fd -uu --type f --exclude .git --hidden --follow'.shellescape(<q-args>))

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat --style=numbers --color=always {} | head -500']}, <bang>0)

function! s:fzf_command(...)
   let args = copy(a:000)
   let cmd = copy(args[0])
   call remove(args, 0)
   let prev_default_command = $FZF_DEFAULT_COMMAND
   let $FZF_DEFAULT_COMMAND = cmd
   call fzf#vim#files(args, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat --style=numbers --color=always {} | head -500']})
   let $FZF_DEFAULT_COMMAND = prev_default_command
endfunction

" autocmd User TelescopeFindPre setlocal nonumber norelativenumber
nnoremap <C-F>f <cmd>Telescope fd<CR>
noremap <C-F>m <cmd>Telescope keymaps<CR>
noremap <C-F>b :Buffers <CR>
nnoremap <space>b <cmd>Telescope buffers<cr>
noremap <C-F>h :History:<CR>
noremap <C-F>c :Commits <CR>
noremap <C-F>/ <cmd>lua require('telescope.builtin').live_grep({grep_open_files=true, disable_coordinates=true})<cr>
noremap <C-F>r <cmd> :Rg <CR>
noremap <C-F>g :GGrep <CR>

noremap <C-\> :TagbarToggle <CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Print object syntax inheritance
map <F10> :TSHighlightCapturesUnderCursor<CR>

" https://vim.fandom.com/wiki/Swapping_characters,_words_and_lines
" To use gw to swap the current word with the next, without changing cursor position: (See note.)
:nnoremap <silent> gw dWWPBB

" https://vim.fandom.com/wiki/Search_for_visually_selected_text
" Search for selected text, forwards or backwards.
" forwards
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> <F8> d:execute 'normal i' . join(sort(split(getreg('"'))), ' ')<CR>

:command! Camel s#_\(\l\)#\u\1#g
:command! Snake s#\C\(\<[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
" Prevent wrapping from breaking up words
command! Doc :set wrap linebreak nolist
command! Ls :!ls

" Formatters
function! Format(formatter) range
  execute a:firstline . "," . a:lastline . "!" . a:formatter
endfunction

function! s:Format2(formatter) abort range
    " " Check whether a range was passed to the function
    if exists('a:firstline')
        execute 'keepjumps keeppatterns ' .
                    \ a:firstline . "," . a:lastline . "!" . a:formatter
    else
        execute 'keepjumps keeppatterns ' .
                    \ "!" . a:formatter
    endif
    " " Restore the state of the window (useful for not losing cursor position)
    call winrestview(b:winview)
endfunction

command! -range=% Sqlf let b:winview = winsaveview() |
            \ <line1>,<line2>call <SID>Format2("sql-formatter --config ~/.sqlf_config.json")
command! -range=% Jq <line1>,<line2>call Format("jq")
command! -range=% Shf <line1>,<line2>call Format("shfmt -i 2 -sr")
command! -range=% Yq <line1>,<line2>call Format("yamkix -n -s")
command! -range=% Yqk <line1>,<line2>call Format("yamkix -s")
command! -range=% Lua let b:winview = winsaveview() |
            \ <line1>,<line2>call <SID>Format2("stylua --indent-width 2 --indent-type Spaces  --collapse-simple-statement Always --call-parentheses NoSingleTable -")




" The function switches all windows pointing to the current buffer (that you are closing)
" to the next buffer (or a new buffer if the current buffer is the last one).
"
" https://stackoverflow.com/questions/4298910/vim-close-buffer-but-not-split-windowanswer-29236158
function! CloseBuffer()
    let curBuf = bufnr('%')
    let curTab = tabpagenr()
    exe 'bnext'

    " If in last buffer, create empty buffer
    if curBuf == bufnr('%')
        exe 'enew'
    endif

    " Loop through tabs
    for i in range(tabpagenr('$'))
        " Go to tab (is there a way with inactive tabs?)
        exe 'tabnext ' . (i + 1)
        " Store active window nr to restore later
        let curWin = winnr()
        " Loop through windows pointing to buffer
        let winnr = bufwinnr(curBuf)
        while (winnr >= 0)
            " Go to window and switch to next buffer
            exe winnr . 'wincmd w | bnext'
            " Restore active window
            exe curWin . 'wincmd w'
            let winnr = bufwinnr(curBuf)
        endwhile
    endfor

    " Close buffer, restore active tab
    exe 'bd' . curBuf
    exe 'tabnext ' . curTab
endfunction



" augroup remember_folds
"   autocmd!
"   autocmd BufWinLeave *.* mkview
"   autocmd BufWinEnter *.* silent! loadview
" augroup END
"
function Gdev()
     let file = expand('%')
     exe 'Gedit develop:' . file
endfunction

command! Gdev call Gdev()



function! MoveFile(newspec)
     let old = expand('%')
     " could be improved:
     if (old == a:newspec)
         return 0
     endif
     exe 'sav' fnameescape(a:newspec)
     call delete(old)
endfunction

command! -nargs=1 -complete=file -bar MoveFile call MoveFile('<args>')





" https://stackoverflow.com/questions/63906439/how-to-disable-line-numbers-in-neovim-terminal
autocmd TermOpen * setlocal nonumber norelativenumber

" https://stackoverflow.com/questions/37552913/vim-how-to-keep-folds-on-save
" augroup remember_folds
"   autocmd!
"   autocmd BufWinLeave ?*.* mkview
"   autocmd BufWinEnter ?*.* silent! loadview
" augroup END

" makro =0f"lyi"$v%"0pysiw}ysa}"a$
