# If you come from bash you might have to change your $PATH.
export PATH=~/.symlinks:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH=$HOME/.cargo/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH=/Users/$USER/.oh-my-zsh
export ZSH_THEME="node"
export ZSH_DISABLE_COMPFIX=true
# Set name of the theme to load. Optionally, if you set this to "random"
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# PYTHON PATHS
alias pipup='pip freeze --local | grep -v ^-e | cut -d = -f 2  | xargs -n1 pip install -U'
# export PATH="$(brew --prefix python)/libexec/bin:$(brew --prefix)/opt/gdal2/bin:$(brew --prefix)/bin:$PATH"
# export VIRTUALENVWRAPPER_PYTHON=`which python`
# source `which virtualenvwrapper.sh`
# export PATH="/usr/local/opt/python@2/bin:$PATH"
# export PYTHONPATH="/usr/local/lib/python3.6/site-packages"
# filepath aliasing
alias cdp="~/Documents/python/"
alias cdr="~/Documents/rust/"
alias cdt="~/Documents/triad-ontologies"
alias firefox="/Applications/Firefox.app/Contents/MacOS/firefox"
alias gitconf="(mv .git .got || mv .got .git) 2> /dev/null"
[[ $TMUX != "" ]] && export TERM="screen-256color"

# initialize theme
bindkey ^v vi-cmd-mode
