export CARGO_HOME=$HOME/.cargo
export GOPATH=$HOME/.go
export RUSTUP_HOME=$HOME/.rustup
export RIPGREP_CONFIG_PATH=$HOME/.rgrc
export EDITOR=nvim
export GOCACHE_PATH="~/Library/Caches/go-build"

export PATH=$CARGO_HOME/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=/usr/local/lib/python3.7/site-packages:$PATH
export PATH=/usr/local/lib/ruby/gems/2.6.0/bin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=/usr/local/Homebrew/bin:$PATH
export PATH=$HOME/.symlinks:$PATH
if [ -e /Users/mkatychev/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/mkatychev/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
