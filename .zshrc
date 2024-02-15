##module_path+=( "$HOME/.zinit/bin/zmodules/Src" )
##zmodload zdharma/zinit
fpath+="$HOME/.zfunc"

ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
setopt hist_lex_words # better word splitting, but more CPU heavy
export CASE_SENSITIVE="true"

# tab completion highlight
# zstyle ':completion:*' menu select
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust



autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zplugin's installer chunk
# A.
setopt promptsubst
ZINIT[MUTE_WARNINGS]=1
# B.
# zinit ice wait"0" lucid
# zinit snippet OMZ::lib/git.zsh

# zinit load zdharma/history-search-multi-word
# command -v jira &> /dev/null  && source <(jira --completion-script-zsh)
# command -v kx &> /dev/null  && source <(kx complete)
# command -v kubectl &> /dev/null  && source <(kubectl completion zsh)
# command -v eksctl &> /dev/null  && source <(eksctl completion zsh)
# command -v cargo &> /dev/null && source <(rustup completions zsh cargo)
autoload -U +X bashcompinit && bashcompinit
# initialize theme
# bindkey ^v vi-cmd-mode
bindkey "^[[3~" delete-char
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^R" fzf-history-widget


# zinit ice wait"0" atinit"zpcompinit" lucid
[[ -a ~/.fzf.git.zsh ]] && source ~/.fzf.git.zsh
[[ -a ~/.zprofile ]] && source ~/.zprofile
[[ -a ~/.profile ]] && source ~/.profile
[[ -a ~/.zshrc.aliases ]] && source ~/.zshrc.aliases
[[ -a ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -a ~/.fzf.zsh ]] && source ~/.fzf.zsh


# command -v cargo &> /dev/null && source <(rustup completions zsh cargo)


# C.
zinit ice wait"0" atload"unalias glo" lucid
    zinit snippet OMZP::git/git.plugin.zsh
    # zinit snippet $tool/zsh_plugin/node_theme.zsh

source $tool/zsh_plugin/node_theme.zsh


# D.
zinit ice wait"0" lucid for \
    zinit snippet OMZP::colored-man-pages/colored-man-pages.plugin.zsh \
    zinit snippet OMZP::aws/aws.plugin.zsh

RAW="https://raw.githubusercontent.com"
# F.
zinit ice wait"0" atinit"zpcompinit" lucid
zinit light 'Aloxaf/fzf-tab'
zinit light 'zdharma-continuum/fast-syntax-highlighting'
zinit light 'djui/alias-tips'
zinit light jeffreytse/zsh-vi-mode
# zinit snippet https://raw.githubusercontent.com/softmoth/zsh-vim-mode/master/zsh-vim-mode.plugin.zsh
zinit ice as"completion" for \
  zinit snippet $RAW/eza-community/eza/main/completions/zsh/_eza \
  zinit snippet $RAW/sharkdp/fd/master/contrib/completion/_fd \
  zinit snippet ~/.local/share/zinit/zinit.git/_zinit \
  zinit snippet ~/.zfunc/_kubectl \
  zinit snippet ~/.zfunc/_kubie \
  zinit snippet ~/.zfunc/_sg
# kubie doesn't play nice with completion setup


MODE_CURSOR_VICMD="green block"
MODE_CURSOR_VIINS="#20d08a bar"
MODE_CURSOR_SEARCH="#ff00ff steady underline"

export KEYTIMEOUT=2
export FZF_CTRL_T_COMMAND="fd --type f"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_DEFAULT_COMMAND="fd --type f --exclude .git --hidden --follow"

# eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

export PNPM_HOME="$USER/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# have zsh-fzf-history-search support those options
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="--preview '(eza --tree --icons --level 3 --color=always --group-directories-first {} || tree -NC {} || ls --color=always --group-directories-first {}) 2>/dev/null | head -200'"

ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT


### End of Zinit's installer chunk
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')
function zvm_after_lazy_keybindings() {
  # In normal mode, press Ctrl-E to invoke this widget
  zvm_bindkey vicmd '^R' fzf-history-widget
  zvm_bindkey viins '^R' fzf-history-widget
}

eval "$(atuin init zsh)"
