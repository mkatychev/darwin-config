autoload colors && colors
GREEN="%{$fg_bold[green]%}"
YELLOW="%{$fg_bold[yellow]%}"
CYAN="%{$fg_bold[cyan]%}"
RED="%{$fg_bold[red]%}"
WHITE="%{$fg_bold[white]%}"
RESET="%{$reset_color%}"

prompt_status() {
  if [ $? = 0 ]; then
    echo -n "$GREEN⬢ "
  else
    echo -n "$RED⬢ "
  fi
}

GIT_PROMPT_PREFIX=" $YELLOW$CYAN"
GIT_PROMPT_SUFFIX=""
GIT_PROMPT_DIRTY="$RED∆"
GIT_PROMPT_CLEAN=""

source ~/gitstatus/gitstatus.plugin.zsh


# my_set_prompt_w() {
#     my_set_prompt '$(prompt_status)'
# }
my_set_prompt() {
  RPROMPT=""
  PROMPT='$(prompt_status)$YELLOW%2d$RESET'
  # PROMPT="$YELLOW%2d$RESET"

  if gitstatus_query MY && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
    PROMPT+="$GIT_PROMPT_PREFIX$CYAN${${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}//\%/%%} "  # escape %
    if [[ $VCS_STATUS_NUM_UNTRACKED -gt 1 ]]; then
      PROMPT+="$YELLOW "
    elif [[ $VCS_STATUS_NUM_UNTRACKED -eq 1 ]]; then
      PROMPT+="$YELLOW "
    fi
    if [[ $VCS_STATUS_NUM_UNSTAGED -gt 1 ]]; then
      PROMPT+="$RED "
    elif [[ $VCS_STATUS_NUM_UNSTAGED -eq 1 ]]; then
      PROMPT+="$RED "
    fi
    if [[ $VCS_STATUS_NUM_STAGED -gt 1 ]]; then
      PROMPT+="$GREEN "
    elif [[ $VCS_STATUS_NUM_STAGED -eq 1 ]]; then
      PROMPT+="$GREEN "
    fi
  fi
  PROMPT+="$RESET
$ "

  # setopt no_prompt_{bang,subst} prompt_percent  # enable/disable correct prompt expansions
}

basic_prompt() {
    PROMPT='$ '
}

gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
autoload -Uz add-zsh-hook
add-zsh-hook precmd my_set_prompt
# add-zsh-hook precmd basic_prompt
