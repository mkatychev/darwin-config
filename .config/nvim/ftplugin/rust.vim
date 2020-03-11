"call onedark#GetColors()
"call one#highlight('rustModPathSep', '', '1d2025', 'none')
"call onedark#extend_highlight('rustModPathSep', {'fg': s:colors.white})
set autoindent
" set nofoldenable
let g:rustfmt_command = 'rustfmt +nightly'
let g:rustfmt_options = '--print-config current .'
let g:rustfmt_emit_files = 1
let g:rustfmt_autosave = 0
" let g:rust_conceal_mod_path = 1

let g:rainbow_conf = {
            \   'separately': {
            \       'rust': {
            \           'parentheses': ['start=/(/ end=/)/', 'start=/</ end=/>/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold'],
            \       }
            \   }
            \}
