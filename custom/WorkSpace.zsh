#!/usr/bin/zsh
WorkSpace() {
  sessionName=$1

  if [[ -z $1 ]]
  then
		echo 'please input name for workspace'
		read sessionName
	fi

  case $sessionName in
    SWPrep) SWPrep
      ;;
    *) tmux -u attach -t $sessionName >/dev/null 2>&1 || tmux -u new -s $sessionName
      ;;
  esac
}

_WorkSpace() {
  compadd "base" "SWPrep"
}

compdef _WorkSpace WorkSpace
