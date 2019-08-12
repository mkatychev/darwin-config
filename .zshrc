module_path+=( "~/.zplugin/bin/zmodules/Src" )
zmodload zdharma/zplugin

export HISTFILE=~/.zsh_history # Where it gets saved
export HISTSIZE=10000
export SAVEHIST=10000
setopt AUTO_CD
setopt append_history # Don't overwrite, append!
setopt INC_APPEND_HISTORY # Write after each command
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_fcntl_lock # use OS file locking
setopt hist_ignore_all_dups # Delete old recorded entry if new entry is a duplicate.
#setopt hist_lex_words # better word splitting, but more CPU heavy
setopt hist_reduce_blanks # Remove superfluous blanks before recording entry.
setopt hist_save_no_dups # Don't write duplicate entries in the history file.
setopt share_history # share history between multiple shells
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.
export CASE_SENSITIVE="true"

# tab completion highlight
zstyle ':completion:*' menu select

#where jira &> /dev/null  && source <(jira --completion-script-zsh)
#where kx &> /dev/null  && source <(kx complete)
#where kubectl &> /dev/null  && source <(kubectl completion zsh)
[[ -a ~/.zshrc.aliases ]] && source ~/.zshrc.aliases
[[ -a ~/.zshrc.local ]] && source ~/.zshrc.local
# initialize theme
bindkey ^v vi-cmd-mode
bindkey "^[[3~" delete-char
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk
# A.
setopt promptsubst
ZPLGM[MUTE_WARNINGS]=1
# B.
zplugin ice wait"0" lucid
zplugin snippet OMZ::lib/git.zsh

zplugin load zdharma/history-search-multi-word

zplugin ice wait"0" atinit"zpcompinit" lucid
zplugin snippet OMZ::plugins/docker/_docker

zplugin ice wait"0" atinit"zpcompinit" lucid
zplugin snippet OMZ::plugins/docker-compose/_docker-compose

# BINS
zplugin ice from"gh-r" as"program"; zplugin load junegunn/fzf-bin


# C.
zplugin ice wait"0" atload"unalias grv" lucid
zplugin snippet OMZ::plugins/git/git.plugin.zsh

zplugin light $tool/zsh_plugin

# D.
zplugin ice wait"0" lucid
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

# F.
zplugin ice wait"0" atinit"zpcompinit" lucid
zplugin light 'zdharma/fast-syntax-highlighting'
zplugin load 'djui/alias-tips'

zplugin ice wait"0" lucid
zplugin load 'softmoth/zsh-vim-mode'

MODE_CURSOR_VICMD="green block"
MODE_CURSOR_VIINS="#20d08a bar"
MODE_CURSOR_SEARCH="#ff00ff steady underline"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
