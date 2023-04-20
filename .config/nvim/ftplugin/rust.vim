"call onedark#GetColors()
" call one#highlight('rustModPathSep', '', '1d2025', 'none')
" call onedark#extend_highlight('rustModPathSep', {'fg': s:colors.white})
set autoindent
" add <Result> angle brackets as match pairs
" set mps+=<:>
" set nofoldenable
let g:rustfmt_command = 'rustfmt +nightly'
let g:surround_111="Option<\r>"
let g:surround_114="Result<\r, Error>"
let g:surround_107="Ok(\r)" 
let g:surround_101="Err(\r)"
let g:surround_115="Some(\r)"
" let g:rustfmt_options = ''
let g:rustfmt_emit_files = 1
" let g:rustfmt_autosave = 1
" let g:rust_conceal_mod_path = 1

let g:rainbow_conf = {
            \   'separately': {
            \       'rust': {
            \           'parentheses': ['start=/(/ end=/)/', 'start=/</ end=/>/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold'],
            \       }
            \   }
            \}
let @s="\<Esc>ggOuse error_stack as es;\<Esc>``"
let @c="\<Esc>vac:s/Error/es::&\<CR>"
