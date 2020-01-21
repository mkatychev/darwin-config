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
set foldlevelstart=99
set viewoptions-=options
:filetype on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tmux Particulars
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Intelligently navigate tmux panes and Vim splits using the same keys.
" See https://sunaku.github.io/tmux-select-pane.html for documentation.
let progname = substitute($VIM, '.*[/\\]', '', '')
set title titlestring=%{progname}\ %f\ +%l\ #%{tabpagenr()}.%{winnr()}
if &term =~ '^tmux' && !has('nvim') | exe "set t_ts=\e]2; t_fs=\7" | endif
" auto resize split buffers in window resize
au! VimResized * wincmd =
set t_8b=[48;2;%lu;%lu;%lum
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set t_8f=[38;2;%lu;%lu;%lum

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" '<,'>sort/.*\//
call plug#begin('~/.vim/plugged')
" Language Client
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-go'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-racer'
Plug 'roxma/nvim-yarp'
Plug 'racer-rust/vim-racer', { 'do': 'cargo +nightly install racer'}
" searching
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
" Git
Plug 'tyru/open-browser-github.vim'
Plug 'tyru/open-browser.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mattn/webapi-vim'
Plug 'itchyny/vim-gitbranch'
" display
Plug 'joshdick/onedark.vim'
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'luochen1990/rainbow'
Plug 'ap/vim-css-color'
Plug 'rust-lang/rust.vim'
" syntax
Plug 'kevinoid/vim-jsonc'
Plug 'mtdl9/vim-log-highlighting'
Plug 'plasticboy/vim-markdown'
Plug 'swinman/vim-nc', { 'branch': 'scaled_error' } " G-Code highlighting
Plug 'sirtaj/vim-openscad'
Plug 'sheerun/vim-polyglot'
Plug 'uarun/vim-protobuf'
Plug 'cespare/vim-toml'
" motions
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'
" misc
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar', { 'do': 'brew install --HEAD universal-ctags/universal-ctags/universal-ctags' }
Plug 'vim-airline/vim-airline'
" Python
Plug 'Yggdroot/indentLine'
" Plug 'ryanoasis/vim-devicons'
" Plug 'AndrewRadev/dsf.vim'
" Plug 'ncm2/float-preview.nvim'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LanguageClient
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:LanguageClient_serverCommands = {
    \ 'rust': ['ra_lsp_server'],
    \ 'python': ['pyls'],
    \ 'go': ['gopls'],
    \ 'yaml': ['yaml-language-server', '--stdio'],
    \ }
let g:LanguageClient_hoverPreview = 'Always'
let g:LanguageClient_useVirtualText = 'Diagnostics'
let g:LanguageClient_changeThrottle = 0.5
let g:LanguageClient_useFloatingHover = 1
let g:LanguageClient_settingsPath = "$nv/settings.json"
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <MiddleMouse> <LeftMouse> :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <2-MiddleMouse> <LeftMouse> :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gD :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> gH :call LanguageClient#textDocument_documentHighlight()<CR>
nnoremap <silent> gh :call LanguageClient#explainErrorAtPoint()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> g[ :cp<CR>
nnoremap <silent> g] :cn<CR>
" autoformat go code on save
au! BufWritePre *.go,*.py,*.rs :call LanguageClient#textDocument_formatting_sync()
" yaml inline langserver settings
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
" :checkhealth paths
let g:python3_host_prog = '/usr/local/bin/python3'
let g:python_host_prog = '/usr/local/bin/python2'
" markdown config
let g:polyglot_disabled = ['md']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['rust', 'go']
let g:highlightedyank_highlight_duration = 200
let g:rainbow_active = 0
let g:vim_json_syntax_conceal = 0
" NERDTree/Comment setup
let g:NERDCustomDelimiters = { 'sparql': { 'left': '#'} }
let g:NERDCustomDelimiters = { 'yaml': { 'left': '#'} }
let g:NERDCustomDelimiters = { 'openscad': { 'left': '//'} }
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

" iTerm C-Tab & C-S-Tab mapped to non ASCII chars ¯\\_(ツ)_/¯
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

" fuzzy buffer search
map z/ <Plug>(incsearch-fuzzy-/)

" command mode emacs bindings
cnoremap <C-A> <C-B>
" clear highlight
nnoremap <silent> <C-L> :nohl<CR>


" unnmap middle mouse click
:imap <2-MiddleMouse> <Nop>
:map <3-MiddleMouse> <Nop>
:imap <3-MiddleMouse> <Nop>
:map <4-MiddleMouse> <Nop>
:imap <4-MiddleMouse> <Nop>

" FZF commands
noremap <C-F>f :Files   <CR>
noremap <C-F>m :Maps    <CR>
noremap <C-F>b :Buffers <CR>
noremap <C-F>h :History:<CR>
noremap <C-F>c :Commits <CR>
noremap <C-F>/ :BLines <CR>
noremap <C-F>r :Rg <CR>

noremap <C-\> :TagbarToggle <CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Print object syntax inheritance
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" https://vim.fandom.com/wiki/Search_for_visually_selected_text
" Search for selected text, forwards or backwards.
" forwards
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
"backwards
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Obsolete with clang-format
" function! TabProto() range
"     :Tabularize /^\s*\S\+\zs/l0c1l0
"     :Tabularize /=/
" endfunction

:command! Camel s#_\(\l\)#\u\1#g
:command! Snake s#\C\(\<[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
" Prevent wrapping from breaking up words
command! Doc :set wrap linebreak nolist

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

