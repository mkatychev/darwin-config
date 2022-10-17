##module_path+=( "$HOME/.zinit/bin/zmodules/Src" )
##zmodload zdharma/zinit
fpath+=~/.zfunc

export HISTFILE="$HOME/.zsh_history"   # Where it gets saved
export HISTSIZE=99999
export SAVEHIST=99999
export HISTFILESIZE=999999
export KEYTIMEOUT=1

setopt APPEND_HISTORY            # Don't overwrite, append!
setopt AUTO_CD
setopt AUTO_PUSHD                # pushes the old directory onto the stack
setopt CDABLE_VARS               # expand the expression (allows 'cd -2/tmp')
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_FCNTL_LOCK           # use OS file locking
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt INC_APPEND_HISTORY        # Write after each command
setopt PUSHD_MINUS               # exchange the meanings of '+' and '-'
setopt SHARE_HISTORY             # share history between multiple shells
autoload -Uz compinit && compinit -i # load + start completion
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'
setopt hist_lex_words # better word splitting, but more CPU heavy
export CASE_SENSITIVE="true"

# tab completion highlight
zstyle ':completion:*' menu select


### Added by Zplugin's installer
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zplugin's installer chunk
# A.
setopt promptsubst
ZINIT[MUTE_WARNINGS]=1
# B.
zinit ice wait"0" lucid
zinit snippet OMZ::lib/git.zsh

# zinit load zdharma/history-search-multi-word
# command -v jira &> /dev/null  && source <(jira --completion-script-zsh)
# command -v kx &> /dev/null  && source <(kx complete)
# command -v kubectl &> /dev/null  && source <(kubectl completion zsh)
# command -v eksctl &> /dev/null  && source <(eksctl completion zsh)
# command -v cargo &> /dev/null && source <(rustup completions zsh cargo)
autoload -U +X bashcompinit && bashcompinit
source ~/.zfunc/_kubie
# initialize theme
# bindkey ^v vi-cmd-mode
bindkey "^[[3~" delete-char
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

zinit ice wait"0" atinit"zpcompinit" lucid for \
    zinit snippet OMZP::docker/_docker \
    zinit snippet OMZP::docker-compose/_docker-compose \
    zinit snippet OMZP::fd/_fd \
    zinit snippet OMZP::ripgrep/_ripgrep

# zinit ice wait"0" atinit"zpcompinit" lucid


# C.
zinit ice wait"0" atload"unalias grv" lucid
    zinit snippet OMZP::git/git.plugin.zsh
    # zinit snippet $tool/zsh_plugin/node_theme.zsh

source $tool/zsh_plugin/node_theme.zsh


# D.
zinit ice wait"0" lucid for \
    zinit snippet OMZP::colored-man-pages/colored-man-pages.plugin.zsh \
    zinit snippet OMZP::aws/aws.plugin.zsh

# F.
zinit ice wait"0" atinit"zpcompinit" lucid
zinit light 'Aloxaf/fzf-tab'
zinit light 'zdharma-continuum/fast-syntax-highlighting'
zinit load 'djui/alias-tips'
zinit snippet https://raw.githubusercontent.com/softmoth/zsh-vim-mode/master/zsh-vim-mode.plugin.zsh

zinit ice lucid nocompile

MODE_CURSOR_VICMD="green block"
MODE_CURSOR_VIINS="#20d08a bar"
MODE_CURSOR_SEARCH="#ff00ff steady underline"

[[ -a ~/.fzf.git.zsh ]] && source ~/.fzf.git.zsh
[[ -a ~/.zprofile ]] && source ~/.zprofile
[[ -a ~/.profile ]] && source ~/.profile
[[ -a ~/.zshrc.aliases ]] && source ~/.zshrc.aliases
[[ -a ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -a ~/.fzf.zsh ]] && source ~/.fzf.zsh

export KEYTIMEOUT=2
export FZF_CTRL_T_COMMAND="fd --type f"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_DEFAULT_COMMAND="fd --type f --exclude .git --hidden --follow"

# eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

export PNPM_HOME="/Users/mkatychev/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
