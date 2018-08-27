"set clipboard+=unnamedplus
set termguicolors
set mouse=n
set relativenumber number
set timeoutlen=1000
set ttimeoutlen=0
set tabstop=4
set shiftwidth=4
set expandtab
call plug#begin('~/.vim/plugged')
Plug 'cespare/vim-toml'
Plug 'elzr/vim-json'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-highlightedyank'
Plug 'miconda/lucariox.vim'
Plug 'niklasl/vim-rdf'
Plug 'rakr/vim-one'
Plug 'rust-lang/rust.vim'
Plug 'rvesse/vim-sparql'
Plug 'scrooloose/nerdtree'
Plug 'srijs/vim-colors-rusty'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
call plug#end()
colorscheme one
set background=dark
call one#highlight('LineNr', '616162', 'white', '')
call one#highlight('Normal', '', '1d2025', 'none')
call one#highlight('rustModPathSep', '', '1d2025', 'none')
"call one#highlight('rustDeriveTrait', '616162', '', '')
"highlight LineNr ctermfg=white ctermbg=green
"highlight Normal ctermbg=black
let g:rainbow_active = 0
let g:solarized_termcolors=256
let g:highlightedyank_highlight_duration = 200
let g:rust_conceal_mod_path = 1
let g:rainbow_conf = {
\   'separately': {
\       'rust': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/</ end=/>/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold'],
\       }
\   }
\}
set viewoptions-=options
"augroup vimrc
"    autocmd BufWritePost *.*
"    \   if expand('%') != '' && &buftype !~ 'nofile'
"    \|      mkview
"    \|  endif
"    autocmd BufRead *.*
"    \   if expand('%') != '' && &buftype !~ 'nofile'
"    \|      silent loadview
"    \|  endif
"augroup END
"" o/O                   Start insert mode with [count] blank lines.
"                       The default behavior repeats the insertion [count]
"                       times, which is not so useful.
nnoremap <leader>O O<ESC>O
nnoremap <leader>o o<cr>
nnoremap <C-\> :NERDTreeToggle<CR>
nnoremap <silent><F2> :RainbowToggle<CR>
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
