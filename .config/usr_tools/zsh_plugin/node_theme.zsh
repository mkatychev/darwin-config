autoload colors && colors
GREEN="%{$fg_bold[green]%}"
YELLOW="%{$fg_bold[yellow]%}"
CYAN="%{$fg_bold[cyan]%}"
RED="%{$fg_bold[red]%}"
WHITE="%{$fg_bold[white]%}"
RESET="%{$reset_color%}"

prompt_status()
{
    if [ $? = 0 ]
    then
        echo -n "$GREEN⬢ ";
    else
        echo -n "$RED⬢ "
    fi
}

# PROMPT='$(prompt_status)$YELLOW%c $(git_prompt_info) $RESET '
PROMPT='$(prompt_status)$YELLOW%c$(git_prompt_info 2> /dev/null)$RESET 
$ '

ZSH_THEME_GIT_PROMPT_PREFIX=" $CYAN"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="$RED∆"
ZSH_THEME_GIT_PROMPT_CLEAN=""
