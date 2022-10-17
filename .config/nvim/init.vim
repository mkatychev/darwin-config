""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
set expandtab
set hidden
set mouse=a
set laststatus=1
syntax off

let g:rnu = get(g:, 'rnu', 1)
" Relative number implementation
if g:rnu
    set relativenumber number
    au! InsertLeave * set relativenumber
    au! InsertEnter * set relativenumber!
    augroup CursorLineOnlyInActiveNormalWindow
      autocmd!
      autocmd VimEnter,WinEnter,BufWinEnter * 
      \ if !&readonly && &modifiable
      \|     setlocal relativenumber
      \| endif
      autocmd WinLeave *
      \ if !&readonly && &modifiable
      \|     setlocal norelativenumber
      \| endif
    augroup END
else
    set number
endif
" allow absolute numbers in insert mode
set shiftwidth=4
set tabstop=4
set termguicolors
set timeoutlen=1000
set ttimeoutlen=0
set foldlevelstart=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set viewoptions-=options,folds
" Make Russian work in normal mode.
set langmap=АБСДЕФГЧИЙКЛМНОПЯРСТУВШХЫЗ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,абсдефгчийклмнопярстувшхыз;abcdefghijklmnopqrstuvwxyz
" set signcolumn=number # hides current line if error on line, follow up
set signcolumn=yes
set nocompatible

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
call plug#begin('~/.vim/plugged')
" Language Client
" searching
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
" Git
Plug 'tyru/open-browser-github.vim'
Plug 'tyru/open-browser.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'mattn/webapi-vim'
Plug 'itchyny/vim-gitbranch'
" display
Plug 'joshdick/onedark.vim'
" Plug 'Th3Whit3Wolf/one-nvim'
" Plug 'blueyed/vim-diminactive'
" Plug 'rakr/vim-one'
Plug 'luochen1990/rainbow'
" Plug 'ap/vim-css-color'
" syntax
Plug 'ARM9/arm-syntax-vim'
Plug 'kevinoid/vim-jsonc'
Plug 'mtdl9/vim-log-highlighting'
" Plug 'plasticboy/vim-markdown'
Plug 'swinman/vim-nc', { 'branch': 'scaled_error' } " G-Code highlighting
Plug 'sirtaj/vim-openscad'
Plug 'uarun/vim-protobuf'
Plug 'mkatychev/vim-toml'
Plug 'ron-rs/ron.vim'
Plug 'pest-parser/pest.vim'
Plug 'dcharbon/vim-flatbuffers'
Plug 'towolf/vim-helm'
" motions
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'
" Plug 'triglav/vim-visual-increment'
" misc
Plug 'glacambre/firenvim'
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar', { 'do': 'brew install --HEAD universal-ctags/universal-ctags/universal-ctags' }
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Python
" Plug 'Yggdroot/indentLine'
" Plug 'ryanoasis/vim-devicons'
" Plug 'AndrewRadev/dsf.vim'
" Rust
" Tmux
Plug 'sunaku/tmux-navigate'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LanguageClient
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua require('init')
" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['rust-analyzer'],
"     \ 'python': ['pyls'],
"     \ 'go': ['gopls'],
"     \ 'yaml': ['yaml-language-server', '--stdio'],
"     \ 'sql': ['sql-language-server', 'up', '--method', 'stdio'],
"     \ 'svelte': ['svelteserver', '--stdio'],
"     \ 'javascript': ['typescript-language-server', '--stdio'],
"     \ 'typescript': ['typescript-language-server', '--stdio'],
"     \ 'php': ['tcp://127.0.0.1:11111'],
"     \ 'c': ['clangd', '--background-index', '--clang-tidy', '--cross-file-rename'],
"     \ 'cpp': ['clangd'],
"     \ 'objc': ['clangd'],
"     \ }
" let g:LanguageClient_hoverPreview = 'Always'
" let g:LanguageClient_useVirtualText = 'No'
" let g:LanguageClient_diagnosticsList = 'Location'
" let g:LanguageClient_useFloatingHover = 1
" let g:LanguageClient_loadSettings = 1
" let g:LanguageClient_settingsPath = s:path . '/settings.json'
" let g:LanguageClient_trace = "verbose"
" let g:LanguageClient_preferredMarkupKind = ['markdown']
" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> <MiddleMouse> <LeftMouse> :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> <2-MiddleMouse> <LeftMouse> :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> gD :call LanguageClient#textDocument_references()<CR>
" nnoremap <silent> gH :call LanguageClient#textDocument_documentHighlight()<CR>
" nnoremap <silent> gC :call LanguageClient#clearDocumentHighlight()<CR>
" nnoremap <silent> gh :call LanguageClient#explainErrorAtPoint()<CR>
" nnoremap <silent> gr :call LanguageClient#textDocument_rename()<CR>
" nnoremap <silent> gA :call LanguageClient#textDocument_codeAction()<CR>
" " refresh langserver
" noremap <leader>r :call LanguageClient#exit() <bar> :call LanguageClient#startServer() <CR>
" " go to next error declaration
" nnoremap <silent> g[ :call LanguageClient_diagnosticsPrevious()<CR>
" nnoremap <silent> g] :call LanguageClient_diagnosticsNext()<CR>
" " autoformat go code on save
" " au! BufWritePre *.go,*.py, :call LanguageClient#textDocument_formatting_sync()
au! BufWritePre *.go,*.rs,*.svelte :lua vim.lsp.buf.formatting_seq_sync()
" " yaml inline langserver settings
" allow completion on single var match for ncm2
set completeopt=menuone,noinsert,noselect

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype Aliases
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au! BufNewFile,BufRead *.json,*.geojson set filetype=json
au! BufNewFile,BufRead .env* set filetype=sh
" au! BufNewFile,BufRead *.yaml,*.yml set filetype=yaml
au! BufNewFile,BufRead *.html,*.xml,*.plist set filetype=xml
au BufNewFile,BufRead *.s,*.S set filetype=arm | set tabstop=8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:onedark_terminal_italics=1
let g:onedark_termcolors=256

augroup colorextend
    autocmd!
    autocmd ColorScheme * call onedark#extend_highlight('LineNr',{'fg':{'gui':'#f2bf93'},'bg':{'gui':'#230f38'}})
    autocmd ColorScheme * call onedark#extend_highlight('CursorLineNr',{'fg':{'gui':'#616162'},'bg':{'gui':'#ffffff'}})
    autocmd ColorScheme * call onedark#extend_highlight('Normal',{'bg':{'gui':'#1d2025'}})
    autocmd ColorScheme * call onedark#extend_highlight('Normal',{'bg':{'gui':'#1d2025'}})
    autocmd ColorScheme * call onedark#set_highlight('Title',{'fg':{'cterm': '114', 'gui':'#56b6c2'}})
    autocmd ColorScheme * call onedark#set_highlight('ErrorMsg',{'fg':{'cterm': '204', 'gui':'#d73a49'}})
augroup END

colorscheme onedark

hi LspReferenceText cterm=bold gui=italic guifg=yellow
hi LspReferenceRead cterm=bold gui=italic guifg=yellow
hi LspReferenceWrite cterm=bold gui=italic guifg=yellow

" highlight! link ALEErrorSign LineNr
" highlight! link ALEError ErrorMsg



" let g:one_allow_italics = 1
" colorscheme one
" call one#highlight('LineNr', 'f2bf93', '230f38', '')
" call one#highlight('CursorLineNr', '#616162', '#ffffe6, '')
" call one#highlight('Normal', '', '1d2025', 'none')
" call one#highlight('Title', '56b6c2', '', '')
" call one#highlight('LineComment', '', '', 'italic')
" call one#highlight('ErrorMsg', 'd73a49', '', '')


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc Global Vars
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:openbrowser_github_select_current_line = 1
" :checkhealth paths
let g:python3_host_prog = 'python3'
let g:python_host_prog = 'python2'
let g:ruby_host_prog = 'ruby'
" markdown config
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['rust', 'go', 'python']
let g:highlightedyank_highlight_duration = 200
let g:rainbow_active = 0
let g:vim_json_syntax_conceal = 0
" NERDTree/Comment setup
" If more than one window and previous buffer was NERDTree, go back to it.
" autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
autocmd BufEnter NvimTree* set cursorline
let g:NERDCustomDelimiters = {
\ 'sparql': { 'left': '#'}, 
\ 'helm': { 'left': '#'},
\ 'yaml': { 'left': '#'},
\ 'openscad': { 'left': '//'},
\ 'svelte': { 'left': '<!--', 'right': '-->' },
\ }
let g:netrw_fastbrowse = 0
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign = 'left'
let g:NERDToggleCheckAllLines = 1
let g:NERDCompactSexyComs = 1
" let NERDTreeMinimalUI = 1
" let NERDTreeDirArrows = 1
" " airline setup
" nmap <leader>1 <Plug>AirlineSelectTab1
" nmap <leader>2 <Plug>AirlineSelectTab2
" nmap <leader>3 <Plug>AirlineSelectTab3
" nmap <leader>4 <Plug>AirlineSelectTab4
" nmap <leader>5 <Plug>AirlineSelectTab5
" nmap <leader>6 <Plug>AirlineSelectTab6
" nmap <leader>7 <Plug>AirlineSelectTab7
" nmap <leader>8 <Plug>AirlineSelectTab8
" nmap <leader>9 <Plug>AirlineSelectTab9
" let g:airline#extensions#tabline#buffer_idx_mode = 1
" let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#branch#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = ''
" let g:airline#extensions#tabline#right_sep = ' '
" let g:airline#extensions#tabline#right_alt_sep = ''
" let g:airline#extensions#hunks#enabled = 1
" let g:airline#extensions#hunks#non_zero_only = 0
" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let airline#extensions#tabline#tabs_label = ''
" let airline#extensions#tabline#show_splits = 0
" "let g:airline_powerline_fonts = 1
" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
" endif
" let g:airline_symbols.branch = ''
" let g:airline_theme='bubblegum'
" " truncate lengthy branch names
" let g:airline#extensions#branch#displayed_head_limit = 10

autocmd FileType rs let b:surround_11="Option<\r>"
autocmd FileType rs let b:surround_114="Result<\r>"
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

noremap <silent><F2> :RainbowToggle<CR>
inoremap <silent><F2> <Esc>:RainbowToggle<CR>a

" Yank entire buffer
noremap <silent><F4> gg"*yG<CR>
" Overwrite entire buffer with clipboard
noremap <silent><F5> :%d<CR>"*P<CR>

" <M-[>
" noremap <silent>Â :NERDTree <bar> :wincmd p <bar> :NERDTreeFind<CR>
noremap <silent>Â :NvimTreeFindFileToggle<CR>
noremap <D-i> dd<CR>
" <M-]>
" <M-i>
noremap <silent>˘ :tabnew<CR> 
" <M-I>
" <M-W> \xe2\x80\a6
noremap <silent>… :call CloseBuffer()<CR>

" fuzzy buffer search
map z/ <Plug>(incsearch-fuzzy-/)
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
nmap =j :%!python3.10 -m json.tool --indent 2<CR>

" FZF commands
" let g:fzf_layout = { 'window': 'call OpenFloatingWin()' }
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
noremap <C-F>m :Maps    <CR>
noremap <C-F>b :Buffers <CR>
nnoremap <space>b <cmd>Telescope buffers<cr>
noremap <C-F>h :History:<CR>
noremap <C-F>c :Commits <CR>
noremap <C-F>/ <cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<cr>
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
vnoremap <silent> <F2> d:execute 'normal i' . join(sort(split(getreg('"'))), ' ')<CR>

:command! Camel s#_\(\l\)#\u\1#g
:command! Snake s#\C\(\<[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
" Prevent wrapping from breaking up words
command! Doc :set wrap linebreak nolist
command! Ls :!ls

" Formatters
function! Format(formatter) range
    execute a:firstline. "," . a:lastline . "!" . a:formatter
endfunction

command! -range=% Jq <line1>,<line2>call Format("jq")
command! -range=% Yq <line1>,<line2>call Format("yamkix -n -s")
command! -range=% Yqk <line1>,<line2>call Format("yamkix -s")
command! -range=% Lua <line1>,<line2>call Format("stylua --indent-width 2 --indent-type Spaces -")

command! -range=% Sqlf <line1>,<line2>call Format("sql-formatter -l mysql --config ~/.sqlf_config.json")

command! -range=% Shf <line1>,<line2>call Format("shfmt -i 2 -sr")

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

" https://developpaper.com/use-the-floating-window-of-neovim-to-make-you-fall-in-love-with-fzf-again/
function! OpenFloatingWin()
  let height = &lines - 3
  let width = float2nr(&columns - (&columns * 2 / 10))
  let col = float2nr((&columns - width) / 2)

  "Set the position, size, etc. of the floating window.
  "The size configuration here may not be so flexible, and there's room for further improvement.
  let opts = {
        \ 'relative': 'editor',
        \ 'row': height * 0.3,
        \ 'col': col + 30,
        \ 'width': width * 2 / 3,
        \ 'height': height/2,
        \ 'style': 'minimal',
        \ }

  let buf = nvim_create_buf(v:false, v:true)
  let win = nvim_open_win(buf, v:true, opts)

  "Set Floating Window Highlighting
  call setwinvar(win, '&winhl', 'Normal:Pmenu')

  setlocal
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
        \ nonumber
        \ norelativenumber
        \ signcolumn=no
endfunction

augroup markdown_language_client_commands
    autocmd!
    autocmd WinLeave __LCNHover__,__LCNExplainError__ ++nested call <SID>fixLanguageClientHover()
augroup END


" augroup remember_folds
"   autocmd!
"   autocmd BufWinLeave *.* mkview
"   autocmd BufWinEnter *.* silent! loadview
" augroup END

function! s:fixLanguageClientHover()
    setlocal modifiable
    setlocal nonu nornu
    setlocal conceallevel=2
    normal i
    setlocal nonu nornu
    setlocal nomodifiable
endfunction

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


" makro =0f"lyi"$v%"0pysiw}ysa}"a$
