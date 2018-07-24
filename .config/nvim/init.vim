set clipboard+=unnamedplus
set mouse=n
set relativenumber number
set timeoutlen=1000
set ttimeoutlen=0
call plug#begin('~/.vim/plugged')
Plug 'FredKSchott/CoVim'
Plug 'https://github.com/miconda/lucariox.vim.git'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-surround'
call plug#end()
colorscheme lucariox
highlight LineNr ctermfg=white ctermbg=darkgrey
highlight Normal ctermbg=black
