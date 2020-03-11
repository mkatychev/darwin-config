let g:vim_markdown_conceal = 1
set conceallevel=3
autocmd BufEnter * if &buftype == '' | set conceallevel=0 | endif
