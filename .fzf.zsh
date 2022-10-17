# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/mkatychev/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/mkatychev/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/mkatychev/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/mkatychev/.fzf/shell/key-bindings.zsh"
