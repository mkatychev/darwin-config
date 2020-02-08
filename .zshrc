module_path+=( "$HOME/.zplugin/bin/zmodules/Src" )
zmodload zdharma/zplugin

export HISTFILE="$HOME/.zsh_history"   # Where it gets saved
export HISTSIZE=10000
export SAVEHIST=10000
export KEYTIMEOUT=1

setopt AUTO_CD
setopt APPEND_HISTORY            # Don't overwrite, append!
setopt INC_APPEND_HISTORY        # Write after each command
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_FCNTL_LOCK           # use OS file locking
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt SHARE_HISTORY             # share history between multiple shells
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt AUTO_PUSHD                # pushes the old directory onto the stack
setopt PUSHD_MINUS               # exchange the meanings of '+' and '-'
setopt CDABLE_VARS               # expand the expression (allows 'cd -2/tmp')
autoload -U compinit && compinit # load + start completion
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'
setopt hist_lex_words # better word splitting, but more CPU heavy
export CASE_SENSITIVE="true"

# tab completion highlight
zstyle ':completion:*' menu select

#where jira &> /dev/null  && source <(jira --completion-script-zsh)
#where kx &> /dev/null  && source <(kx complete)
#where kubectl &> /dev/null  && source <(kubectl completion zsh)
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

zplugin snippet https://raw.githubusercontent.com/luiz1361/zsh-vim-mode/master/zsh-vim-mode.plugin.zsh

MODE_CURSOR_VICMD="green block"
MODE_CURSOR_VIINS="#20d08a bar"
MODE_CURSOR_SEARCH="#ff00ff steady underline"

[[ -a ~/.zprofile ]] && source ~/.zprofile
[[ -a ~/.profile ]] && source ~/.profile
[[ -a ~/.zshrc.aliases ]] && source ~/.zshrc.aliases
[[ -a ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -a ~/.fzf.zsh ]] && source ~/.fzf.zsh

export KEYTIMEOUT=2
export FZF_CTRL_T_COMMAND="fd --type f"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_DEFAULT_COMMAND="fd --type f --exclude .git --hidden --follow"

