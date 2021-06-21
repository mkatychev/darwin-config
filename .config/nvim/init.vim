""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
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
set viewoptions-=options,folds
" Make Russian work in normal mode.
set langmap=АБСДЕФГЧИЙКЛМНОПЯРСТУВШХЫЗ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,абсдефгчийклмнопярстувшхыз;abcdefghijklmnopqrstuvwxyz
" set signcolumn=number # hides current line if error on line, follow up
set signcolumn=yes
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prelude configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
" let g:polyglot_disabled = ['sensible', 'rust', 'go']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" '<,'>sort/.*\//
call plug#begin('~/.vim/plugged')
" Language Client
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-go', {'do': 'go get -u github.com/nsf/gocode' }
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-racer'
Plug 'roxma/nvim-yarp', {'do': '/usr/bin/python2 -m pip install pynvim' }
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
" Plug 'blueyed/vim-diminactive'
" Plug 'rakr/vim-one'
Plug 'luochen1990/rainbow'
" Plug 'ap/vim-css-color'
" syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'ARM9/arm-syntax-vim'
Plug 'kevinoid/vim-jsonc'
Plug 'mtdl9/vim-log-highlighting'
Plug 'plasticboy/vim-markdown'
Plug 'swinman/vim-nc', { 'branch': 'scaled_error' } " G-Code highlighting
Plug 'sirtaj/vim-openscad'
Plug 'uarun/vim-protobuf'
Plug 'mkatychev/vim-toml'
Plug 'ron-rs/ron.vim'
" motions
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'
" Plug 'triglav/vim-visual-increment'
" misc
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar', { 'do': 'brew install --HEAD universal-ctags/universal-ctags/universal-ctags' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Python
" Plug 'Yggdroot/indentLine'
" Plug 'ryanoasis/vim-devicons'
" Plug 'AndrewRadev/dsf.vim'
" Plug 'ncm2/float-preview.nvim'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LanguageClient
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ 'python': ['pyls'],
    \ 'go': ['gopls'],
    \ 'yaml': ['yaml-language-server', '--stdio'],
    \ 'sql': ['sql-language-server', 'up', '--method', 'stdio'],
    \ 'javascript': ['typescript-language-server', '--stdio'],
    \ 'php': ['tcp://127.0.0.1:11111'],
    \ 'c': ['clangd', '--background-index', '--clang-tidy', '--cross-file-rename'],
    \ 'cpp': ['clangd'],
    \ 'objc': ['clangd'],
    \ }
let g:LanguageClient_hoverPreview = 'Always'
let g:LanguageClient_useVirtualText = 'No'
let g:LanguageClient_diagnosticsList = 'Location'
let g:LanguageClient_useFloatingHover = 1
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_settingsPath = s:path . '/settings.json'
let g:LanguageClient_trace = "verbose"
let g:LanguageClient_preferredMarkupKind = ['markdown']
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <MiddleMouse> <LeftMouse> :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <2-MiddleMouse> <LeftMouse> :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gD :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> gH :call LanguageClient#textDocument_documentHighlight()<CR>
nnoremap <silent> gC :call LanguageClient#clearDocumentHighlight()<CR>
nnoremap <silent> gh :call LanguageClient#explainErrorAtPoint()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> gA :call LanguageClient#textDocument_codeAction()<CR>
" refresh langserver
noremap <leader>r :call LanguageClient#exit() <bar> :call LanguageClient#startServer() <CR>
" go to next error declaration
nnoremap <silent> g[ :call LanguageClient_diagnosticsPrevious()<CR>
nnoremap <silent> g] :call LanguageClient_diagnosticsNext()<CR>
" autoformat go code on save
" au! BufWritePre *.go,*.py, :call LanguageClient#textDocument_formatting_sync()
au! BufWritePre *.go,*.py,*.rs :call LanguageClient#textDocument_formatting_sync()
" yaml inline langserver settings
" enable ncm2 on buffer enter
autocmd BufEnter  *  call ncm2#enable_for_buffer()
" allow completion on single var match for ncm2
set completeopt=menuone,noinsert,noselect
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tree-sitter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gni",
      node_incremental = "gnn",
      scope_incremental = "gno",
      node_decremental = "gnd",
    },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ib"] = "@conditional.inner",
        ["ab"] = "@conditional.outer",
        ["iC"] = "@call.inner",
        ["aC"] = "@call.outer",
        ["ip"] = "@parameter.inner",
        ["ap"] = "@parameter.outer",
        ["it"] = "@statement.inner",
        ["at"] = "@statement.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]r"] = "@parameter.outer",
      },
      goto_next_end = {
        ["]ef"] = "@function.outer",
        ["]ec"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
      goto_previous_end = {
        ["[ef"] = "@function.outer",
        ["[ec"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>ir"] = "@parameter.inner",
        ["<leader>af"] = "@function.outer",
        ["<leader>if"] = "@function.inner",
      },
      swap_previous = {
        ["<leader>Ir"] = "@parameter.inner",
        ["<leader>Af"] = "@function.outer",
        ["<leader>If"] = "@function.inner",
      },
    },
  },
}
EOF

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype Aliases
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au! BufNewFile,BufRead *.json,*.geojson set filetype=json
au! BufNewFile,BufRead *.yaml,*.yml set filetype=yaml
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

highlight! link ALEErrorSign LineNr
highlight! link ALEError ErrorMsg



" let g:one_allow_italics = 1
" colorscheme one
" call one#highlight('LineNr', 'f2bf93', '230f38', '')
" call one#highlight('CursorLineNr', '616162', 'ffffff', '')
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
let g:vim_markdown_fenced_languages = ['rust', 'go']
let g:highlightedyank_highlight_duration = 200
let g:rainbow_active = 0
let g:vim_json_syntax_conceal = 0
" NERDTree/Comment setup
" If more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
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
let g:airline_theme='bubblegum'
" truncate lengthy branch names
let g:airline#extensions#branch#displayed_head_limit = 10

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

" iTerm C-Tab & C-S-Tab mapped to non ASCII chars ¯\\_(ツ)_/¯
" <C-Tab> \x09\xe2\x88\x8f
noremap <silent>∏ :bn<CR>
inoremap <silent>∏ <Esc>:bn<CR>
" <C-Shift-Tab>
noremap <silent>Ø :bp<CR>
inoremap <silent>Ø <Esc>:bp<CR>
" <M-[>
" noremap <silent>Â :NERDTree <bar> :wincmd p <bar> :NERDTreeFind<CR>
noremap <silent><leader>[ :NERDTree <bar> :wincmd p <bar> :NERDTreeFind<CR>
noremap <silent>Ú :tabNext<CR> 
noremap <D-i> dd<CR>
" <M-]>
" <M-i>
noremap <silent>˘ :tabnew<CR> 
" <M-I>
" <M-W> \xe2\x80\a6
noremap <silent>… :call CloseBuffer()<CR>
" <M-\> \xc2\xbb
noremap <silent><leader>] :NERDTreeToggle<CR>
inoremap <silent><leader>]<Esc>:NERDTreeToggle<CR>

" fuzzy buffer search
map z/ <Plug>(incsearch-fuzzy-/)

" command mode emacs bindings
cnoremap <C-A> <C-B>
inoremap <C-A> <C-B>
" clear highlight
nnoremap <silent> <C-L> :nohl<CR>


" unnmap middle mouse click
:imap <2-MiddleMouse> <Nop>
:map <3-MiddleMouse> <Nop>
:imap <3-MiddleMouse> <Nop>
:map <4-MiddleMouse> <Nop>
:imap <4-MiddleMouse> <Nop>
nmap =j :%!python3.10 -m json.tool --indent 2<CR>

" FZF commands
let g:fzf_layout = { 'window': 'call OpenFloatingWin()' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Rguu
  \ call fzf#vim#grep(
  \   'rg -uu --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat --style=numbers --color=always {} | head -500']}, <bang>0)

noremap <C-F>f :Files   <CR>
noremap <C-F>m :Maps    <CR>
noremap <C-F>b :Buffers <CR>
noremap <C-F>h :History:<CR>
noremap <C-F>c :Commits <CR>
noremap <C-F>/ :BLines <CR>
noremap <C-F>r :Rg <CR>
noremap <C-F>g :GGrep <CR>

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

command! -range=% Sqlf <line1>,<line2>call Format("sql-formatter -l mysql -u")

command! -range=% Shf <line1>,<line2>call Format("shfmt -i 2")

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
    autocmd WinLeave __LCNHover__ ++nested call <SID>fixLanguageClientHover()
augroup END

function! s:fixLanguageClientHover()
    setlocal modifiable
    setlocal nonu nornu
    setlocal conceallevel=2
    normal i
    setlocal nonu nornu
    setlocal nomodifiable
endfunction


augroup CursorLineOnlyInActiveWindow
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

" https://stackoverflow.com/questions/63906439/how-to-disable-line-numbers-in-neovim-terminal
autocmd TermOpen * setlocal nonumber norelativenumber


" makro =0f"lyi"$v%"0pysiw}ysa}"a$
