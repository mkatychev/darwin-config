export CARGO_HOME=$HOME/.cargo
export GOPATH=$HOME/.go
export RUSTUP_HOME=$HOME/.rustup
export RIPGREP_CONFIG_PATH=$HOME/.rgrc
export EDITOR=nvim
export GOCACHE_PATH="~/Library/Caches/go-build"
export GEM_PATH=$HOME/.gem
# export DOCKER_HOST=unix://$HOME/docker.sock

export PATH=$CARGO_HOME/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$GEM_PATH/bin:$PATH
export PATH=/usr/local/lib/ruby/gems/2.6.0/bin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=~/Library/Python/3.9/bin:$PATH
# export PATH=$HOME/.nix-profile/bin:$PATH

export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=/usr/local/Homebrew/bin:$PATH
export PATH=$HOME/.symlinks:$PATH
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
export PATH="/usr/local/Homebrew/opt/openssl@3/bin:$PATH"
export PATH=~/.local/bin:$PATH
export PATH=$PATH:/Users/mkatychev/.linkerd2/bin

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
