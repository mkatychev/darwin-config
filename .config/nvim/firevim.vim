let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
set mouse=a
set relativenumber number
set shiftwidth=4
set tabstop=4
set timeoutlen=1000
set noruler
set laststatus=0
set langmap=АБСДЕФГЧИЙКЛМНОПЯРСТУВШХЫЗ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,абсдефгчийклмнопярстувшхыз;abcdefghijklmnopqrstuvwxyz
set guifont=Fira_Code:h9

call plug#begin('/Users/mkatychev/.vim/plugged')
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'tpope/vim-surround'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-repeat'
call plug#end()

tmap <D-v> <C-w>"+
nnoremap <D-v> "+p
vnoremap <D-v> "+p
inoremap <D-v> <C-R><C-O>+
cnoremap <D-v> <C-R><C-O>+

let g:firenvim_config = { 
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'text',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'never',
        \ },
    \ }
\ }
let g:highlightedyank_highlight_duration = 200
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
" command mode emacs bindings
cnoremap <C-A> <C-B>
inoremap <C-A> <C-B>
" clear highlight
nnoremap <silent> <C-L> :nohl<CR>
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
" Search for selected text, forwards or backwards.
" forwards
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
" Prevent wrapping from breaking up words
command! Doc :set wrap linebreak nolist
