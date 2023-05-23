autocmd BufNewFile,BufRead * if search('{{.\+\.Chart.\+}}', 'nw') | setlocal filetype=gotmpl | endif
