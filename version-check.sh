diskver="$(pacman -Qi linux | grep Version | awk '{print $3}' | cut -d'.' -f1,2,3)"
memver="$(uname -r | cut -f1 -d'-')"

if [ "$diskver" != "$memver" ]
then
  echo "\e[91m!\e[39m"
else
  echo "\e[92m✔\e[39m"
fi

