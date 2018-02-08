export PROJECTS=$HOME/Projects/
export SOURCE=$PROJECTS/src
export GO2MOBI=$SOURCE/github.com/go2mobi/
export GOPATH=$PROJECTS
export GOROOT=/usr/local/go
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin:$SOURCE/github.com/ben-turner/dotfiles/scripts
export EDITOR=/usr/bin/nvim

function _update_ps1() {
  PS1="$(powerline-shell $?)"
}
if [ "$TERM" != "linux" ]; then
  PROMPT_COMMAND="_update_ps1;"
fi

open() {
  mapfile -t options < <(find $SOURCE -not -path '*/\.+' -name "*$1*" -type d | awk '{ print length, $0 }' | sort -n -s | cut -d" " -f2-)

  if [[ ${#options[@]} -eq 0 ]]
  then
    echo "No matches found"
    return 1
  fi
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
  cd "$options"
}

edit() {
  open $1 && nvim
}

ssh() {
  if [[ "$(ssh-add -l)" = "The agent has no identities." ]]; then
    sudo mount /dev/disk/by-uuid/bef6b086-527f-46fd-88c1-7a252f751904 /keys
    /keys/load.sh
  fi
  /usr/bin/ssh "$@";
}

keys() {
  sudo mount /dev/disk/by-uuid/bef6b086-527f-46fd-88c1-7a252f751904 /keys
  /keys/load.sh
}

dbtunnel() {
  ssh -f -N -L3306:g3.cybe5vwfyrgh.us-east-1.rds.amazonaws.com:3306 admin@a.g3admin.com
}
db() {
  connection="/tmp/mysocket$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"
  control="/tmp/mysocket$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"
  while [[ -f "${connection}" || -f "${control}" ]]; do
    connection="/tmp/mysocket$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"
    control="/tmp/mysocket$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"
  done;
  ssh -M -S "${control}" -fnNT -L "${connection}:g3.cybe5vwfyrgh.us-east-1.rds.amazonaws.com:3306" admin@a.g3admin.com
  mysql -S "${connection}" -p -u g3user
  ssh -S "${control}" -O exit admin@a.g3admin.com
  rm -f "${connection}" "${control}"
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

alias pac="sudo pacman -S"
alias grep="grep --color"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias a='setxkbmap -variant turner us'

