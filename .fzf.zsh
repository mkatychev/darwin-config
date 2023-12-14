# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/mkatychev/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/mkatychev/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/Users/mkatychev/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/Users/mkatychev/.fzf/shell/key-bindings.zsh"
