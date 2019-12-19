# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/mkatychev/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/mkatychev/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/mkatychev/.fzf/shell/completion.zsh" 2> /dev/null
export FZF_CTRL_T_COMMAND="fd --type f"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_DEFAULT_COMMAND="fd --type f --exclude .git"
# Key bindings
# ------------
source "/Users/mkatychev/.fzf/shell/key-bindings.zsh"
