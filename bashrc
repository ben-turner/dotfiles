export PROJECTS=$HOME/Projects/
export SOURCE=$PROJECTS/src
export GO2MOBI=$SOURCE/github.com/go2mobi/
export GOPATH=$PROJECTS
export GOROOT=/usr/local/go
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin:$HOME/dotfiles/scripts

function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "[$RETVAL]"
}

export PS1="\[\e[31m\]\`nonzero_return\`\[\e[m\] \[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\] [\W]: "

if [ $VIM ]
then
  export PS1="\[\e[31m\][vim]\[\e[m\]"$PS1
  alias vim="exit"
fi

