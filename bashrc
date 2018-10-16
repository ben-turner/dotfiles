export PROJECTS=$HOME/Projects/
export SOURCE=$PROJECTS/src
export GO2MOBI=$SOURCE/github.com/go2mobi/
export GOPATH=$PROJECTS
export GOROOT=/usr/local/go1.9.3
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin:$SOURCE/github.com/ben-turner/dotfiles/scripts:$HOME/.node_modules/bin/:/home/ben/.gem/ruby/2.5.0/bin
export EDITOR=/usr/bin/nvim
if [ "${TERM}" = "xterm-kitty" ]; then
  export TERM="xterm"
fi

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

function _update_ps1() {
  PS1="$(powerline-shell $?)"
}
if [ "$TERM" != "linux" ]; then
  PROMPT_COMMAND="_update_ps1;"
fi

open() {
  mapfile -t options < <(find $SOURCE -maxdepth 5 -not -path '*/\.+' -name "*$1*" -type d | awk '{ print length, $0 }' | sort -n -s | cut -d" " -f2-)

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

new() {
  mkdir -p $SOURCE/$1
  cd $SOURCE/$1
}

db() {
  connection="/tmp/mysocket$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"
  control="/tmp/mysocket$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"
  while [[ -f "${connection}" || -f "${control}" ]]; do
    connection="/tmp/mysocket$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"
    control="/tmp/mysocket$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"
  done;
  ssh -M -S "${control}" -fnNT -L "${connection}:${1}.cybe5vwfyrgh.us-east-1.rds.amazonaws.com:3306" go2mobi@a.g3admin.com
  mysql -S "${connection}" -p -u ${2}
  ssh -S "${control}" -O exit go2mobi@a.g3admin.com
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

alias pac='sudo pacman -S'
alias grep='grep --color'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias a='setxkbmap -variant turner us'
alias serve='python -m http.server'
alias keks='KUBECONFIG=~/.kube/eks kubectl'


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ben/google-cloud-sdk/path.bash.inc' ]; then source '/home/ben/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/ben/google-cloud-sdk/completion.bash.inc' ]; then source '/home/ben/google-cloud-sdk/completion.bash.inc'; fi

# Kubectl Autocomplete
source <(kubectl completion bash)
