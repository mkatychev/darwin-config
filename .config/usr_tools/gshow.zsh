#!/usr/local/bin/zsh

base=$(basename -- "$1")
end="${base##*.}"
# git show "$1" | bat --language=$end
echo "hello"
echo $1
bat --language=$end
