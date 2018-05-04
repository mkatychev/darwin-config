set clipboard+=unnamedplus
set mouse=n
set relativenumber number
call plug#begin('~/.vim/plugged')
Plug 'https://github.com/miconda/lucariox.vim.git'
call plug#end()
colorscheme lucariox
highlight LineNr ctermfg=white ctermbg=darkgrey
highlight Normal ctermbg=black
