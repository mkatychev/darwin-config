""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set hidden
set mouse=a

" Relative number implementation
set relativenumber number
" allow absolute numbers in insert mode
au! InsertLeave * set relativenumber
au! InsertEnter * set relativenumber!
set shiftwidth=4
set tabstop=4
set termguicolors
set timeoutlen=1000
set ttimeoutlen=0
set t_8b=[48;2;%lu;%lu;%lum
set t_8f=[38;2;%lu;%lu;%lum
set foldlevelstart=99
set viewoptions-=options
"set cedit
" Intelligently navigate tmux panes and Vim splits using the same keys.
" See https://sunaku.github.io/tmux-select-pane.html for documentation.
let progname = substitute($VIM, '.*[/\\]', '', '')
set title titlestring=%{progname}\ %f\ +%l\ #%{tabpagenr()}.%{winnr()}
if &term =~ '^tmux' && !has('nvim') | exe "set t_ts=\e]2; t_fs=\7" | endif
:filetype on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" '<,'>sort/.*\//
call plug#begin('~/.vim/plugged')
Plug 'haya14busa/incsearch.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-python/python-syntax'
Plug 'luochen1990/rainbow'
Plug 'rust-lang/rust.vim'
Plug 'godlygeek/tabular'
Plug 'ap/vim-css-color'
Plug 'machakann/vim-highlightedyank'
Plug 'elzr/vim-json'
Plug 'vimjas/vim-python-pep8-indent'
Plug 'niklasl/vim-rdf'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'rvesse/vim-sparql'
Plug 'tpope/vim-surround'
Plug 'cespare/vim-toml'
Plug 'mattn/webapi-vim'
" Plug 'fatih/vim-go'
Plug 'Yggdroot/indentLine'
Plug 'swinman/vim-nc', { 'branch': 'scaled_error' }
" Plug 'zchee/deoplete-go', { 'do': 'make' }
" Plug 'Shougo/deoplete.nvim'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Plug 'stamblerre/gocode', { 'rtp': 'nvim', 'do': '$GOPATH/src/github.com/stamblerre/gocode/nvim/symlink.sh' }
Plug 'itchyny/vim-gitbranch'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'uarun/vim-protobuf'
Plug 'majutsushi/tagbar'
Plug 'mtdl9/vim-log-highlighting'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'sirtaj/vim-openscad'
Plug 'plasticboy/vim-markdown'
" Plug 'ncm2/float-preview.nvim'
"Plug 'stephpy/vim-yaml'
"Plug 'w0rp/ale'
call plug#end()

set hidden

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LanguageClient
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'go': ['gopls'],
    \ 'yaml': ['yaml-language-server', '--stdio'],
    \ }
let g:LanguageClient_hoverPreview = 'Always'
let g:LanguageClient_useVirtualText = 1
let g:LanguageClient_changeThrottle = 0.5
let g:LanguageClient_useFloatingHover = 1
" let g:LanguageClient_completionPreferTextEdit = 1
" let g:float_preview#docked = 0
" let g:float_preview#max_width = 100
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <MiddleMouse> <LeftMouse> :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <2-MiddleMouse> <LeftMouse> :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gD :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> gH :call LanguageClient#textDocument_documentHighlight()<CR>
nnoremap <silent> gh :call LanguageClient#explainErrorAtPoint()<CR>
" autoformat go code on save
au! BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
au! BufWritePre *.py :call LanguageClient#textDocument_formatting_sync()
" yaml inline langserver settings
let settings = json_decode('
\{
\    "yaml": {
\        "completion": true,
\        "hover": true,
\        "validate": true,
\        "schemas": {
\            "Kubernetes": "/*"
\        },
\        "format": {
\            "enable": true
\        }
\    },
\    "http": {
\        "proxyStrictSSL": true
\    }
\}')
augroup LanguageClient_config
    autocmd!
    autocmd User LanguageClientStarted call LanguageClient#Notify(
        \ 'workspace/didChangeConfiguration', {'settings': settings})
augroup END
" enable ncm2 on buffer enter
autocmd BufEnter  *  call ncm2#enable_for_buffer()
" allow completion on single var match for ncm2
set completeopt=menuone,noinsert,noselect

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype Aliases
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au! BufNewFile,BufRead *.json,*.geojson set filetype=json
au! BufNewFile,BufRead *.yaml,*.yml set filetype=yaml
au! BufNewFile,BufRead *.html,*.xml,*.plist set filetype=xml
" auto resize split buffers in window resize
au! VimResized * wincmd =

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme onedark

let g:onedark_terminal_italics=1
let g:onedark_termcolors=256
call onedark#extend_highlight('LineNr',
            \ {'fg': { 'gui': '#f2bf93'},'bg': { 'gui': '#230f38'}
            \ })
call onedark#extend_highlight('CursorLineNr',
            \ {'fg': { 'gui': '#616162'},'bg': { 'gui': '#ffffff'}
            \ })
call onedark#extend_highlight('Normal',
            \ {'bg': { 'gui': '#1d2025'}
            \ })
call onedark#extend_highlight('Comment', {'gui': 'italic'})

"colorscheme one
"let g:one_allow_italics = 1
"call one#highlight('LineNr', 'f2bf93', '230f38', '')
"call one#highlight('CursorLineNr', '616162', 'ffffff', '')
"call one#highlight('Normal', '', '1d2025', 'none')
"call one#highlight('vimLineComment', '', '', 'italic')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc Global Vars
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:polyglot_disabled = ['md']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['rust', 'go']
let g:deoplete#enable_at_startup = 1
let g:highlightedyank_highlight_duration = 200
let g:python3_host_prog = '/usr/local/bin/python3'
let g:python_host_prog = '/usr/local/bin/python2'
let g:rainbow_active = 0
let g:vim_json_syntax_conceal = 0
let g:NERDCustomDelimiters = { 'sparql': { 'left': '#'} }
let g:NERDCustomDelimiters = { 'yaml': { 'left': '# '} }
let g:NERDCustomDelimiters = { 'openscad': { 'left': '// '} }
let g:netrw_fastbrowse = 0
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign = 'left'
let g:NERDToggleCheckAllLines = 1
let g:NERDCompactSexyComs = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
" airline setup
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline#extensions#tabline#buffer_nr_format = '№%s '
let airline#extensions#tabline#tabs_label = ''
let airline#extensions#tabline#show_splits = 0
"let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
" truncate lengthy branch names
let g:airline#extensions#branch#displayed_head_limit = 10

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
noremap <silent><F4> gg"*yG<CR>
noremap <silent><F5> :%d<CR>"*P<CR>
" Print object syntax inheritance
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" iterm C-Tab & C-S-Tab mapped to non ASCII chars ¯\\_(ツ)_/¯
" <C-Tab> \x09\xe2\x88\x8f
noremap <silent>∏ :bn<CR>
inoremap <silent>∏ <Esc>:bn<CR>
" <C-Shift-Tab>
noremap <silent>Ø :bp<CR>
inoremap <silent>Ø <Esc>:bp<CR>
" <M-[>
" noremap <silent>Æ :tabnext<CR> 
noremap <silent>Æ :NERDTree <bar> :wincmd p <bar> :NERDTreeFind<CR>
noremap <silent>Ú :tabNext<CR> 
" <M-]>
" <M-i>
noremap <silent>˘ :tabnew<CR> 
" <M-I>
" <M-W> \xe2\x80\a6
noremap <silent>… :call CloseBuffer()<CR>
" <M-\> \xc2\xbb
noremap <silent>» :NERDTreeToggle<CR>
inoremap <silent>» <Esc>:NERDTreeToggle<CR>
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

nnoremap <silent> <F12> :bn<CR>

" command mode emacs bindings
cnoremap <C-A> <C-B>

" unnmap middle mouse click
:imap <2-MiddleMouse> <Nop>
:map <3-MiddleMouse> <Nop>
:imap <3-MiddleMouse> <Nop>
:map <4-MiddleMouse> <Nop>
:imap <4-MiddleMouse> <Nop>




function! TabProto() range
    :Tabularize /^\s*\S\+\zs/l0c1l0
    :Tabularize /=/
endfunction

command! -range=% TabProto call TabProto()
:command! Camel s#_\(\l\)#\u\1#g
:command! Snake s#\C\(\<[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g

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

