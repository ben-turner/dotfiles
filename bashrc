export PROJECTS=$HOME/Projects/
export SOURCE=$PROJECTS/src
export PATH=$PATH:$SOURCE/github.com/ben-turner/dotfiles/scripts
export EDITOR=/usr/bin/nvim

zmodload zsh/mapfile

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

open() {
  IFS=$'\n' matchingFiles=($(find $SOURCE -maxdepth 5 -not -path '*/\.+' -name "*$1*" -type d | awk '{ print length, $0 }' | sort -n -s | cut -d" " -f2-))

  if [[ ${#matchingFiles[@]} -eq 0 ]]
  then
    echo "No matches found"
    return 1
  fi
  if [[ ${#matchingFiles[@]} -gt 1 ]]
  then
    echo "Multiple matches found. Choose one:"
    select opt in "${matchingFiles[@]}"
    do
      matchingFile=$opt
      break
    done
  else
    matchingFile=${matchingFiles[1]}
  fi
  echo $matchingFile
  cd "$matchingFile"
}

edit() {
  open $1 && nvim
}

new() {
  mkdir -p $SOURCE/$1
  cd $SOURCE/$1
}

netfix() {
  sudo ip link set enp0s31f6 down
  sudo ip link set wlp1s0 down
  echo "Disabled network devices"
  sleep 10
  echo "Re-enabling network devices"
  sudo ip link set enp0s31f6 up
}

netstat() {
  echo "Use ss instead"
  return 127;
}

rfc() {
  curl -s https://www.rfc-editor.org/rfc/rfc$1.txt | less
}

alias grep='grep --color'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

