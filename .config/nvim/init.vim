"set clipboard+=unnamedplus
"set termguicolors
set mouse=n
set relativenumber number
set timeoutlen=1000
set ttimeoutlen=0
set tabstop=4
set shiftwidth=4
set expandtab
au BufRead,BufNewFile *.rs set filetype=json
call plug#begin('~/.vim/plugged')
Plug 'miconda/lucariox.vim'
Plug 'srijs/vim-colors-rusty'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'rakr/vim-one'
Plug 'cespare/vim-toml'
Plug 'niklasl/vim-rdf'
Plug 'elzr/vim-json'
Plug 'rvesse/vim-sparql'
call plug#end()
colorscheme one
set background=dark
call one#highlight('LineNr', '616162', 'white', '')
"highlight LineNr ctermfg=white ctermbg=green
"highlight Normal ctermbg=black
let g:solarized_termcolors=16
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
