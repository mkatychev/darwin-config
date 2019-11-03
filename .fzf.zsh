# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/mkatychev/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/mkatychev/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/mkatychev/.fzf/shell/completion.zsh" 2> /dev/null
FZF_CTRL_T_COMMAND="fd --type f"
FZF_ALT_C_COMMAND="fd --type d"
# Key bindings
# ------------
source "/Users/mkatychev/.fzf/shell/key-bindings.zsh"
