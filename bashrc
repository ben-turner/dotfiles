export PROJECTS=$HOME/Projects/
export SOURCE=$PROJECTS/src
export GO2MOBI=$SOURCE/github.com/go2mobi/
export GOPATH=$PROJECTS
export GOROOT=/usr/local/go
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin:$SOURCE/github.com/ben-turner/dotfiles/scripts
export EDITOR=/usr/bin/nvim

function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "[$RETVAL]"
}

source $PROJECTS/src/github.com/ben-turner/dotfiles/prompt.sh

if [ $VIM ]
then
  export PS1="\[\e[31m\][vim]\[\e[m\]"$PS1
  alias vim="exit"
fi

title() {
  export PROMPT_COMMAND_BAK=$PROMPT_COMMAND
  export PROMPT_COMMAND=''
  echo -ne "\033]0;$1\007"
}

restitle() {
  export PROMPT_COMMAND=$PROMPT_COMMAND_BAK
}

open() {
  mapfile -t options < <(find $SOURCE -name "*$1*" -type d)

  if [[ ${#options[@]} -gt 1 ]]
  then
    echo "Multiple matches found. Choose one:"
    select opt in "${options[@]}"
    do
      options=$opt
      break
    done
  else
    options=${options[0]}
  fi
  cd "$options" && title $(basename "$options")
}

edit() {
  open $1 && nvim
}

ssh() {
  if [[ "$(ssh-add -l)" = "The agent has no identities." ]]; then
    mount /dev/disk/by-uuid/9c0da0a8-8777-4c20-b668-f3e851a251fa /keys
    /keys/load.sh
  fi
  /usr/bin/ssh "$@";
}

alias pac="sudo pacman -S"
alias grep="grep --color"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

