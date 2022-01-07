if [ -f /etc/profile ]; then
  PATH=""
  source /etc/profile
fi

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
