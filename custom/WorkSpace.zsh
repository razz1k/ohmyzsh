#!/usr/bin/zsh
WorkSpace() {
  curDir=$(pwd)
  sessionName=$1

  if [[ -z $1 ]]
  then
		echo 'please input name for workspace'
		read sessionName
	fi

  case $sessionName in
    SavingsUnited) SavingsUnitedPrepare
      ;;
    *) tmux -u attach -t $sessionName >/dev/null 2>&1 || tmux -u new -s $sessionName
      ;;
  esac

  cd $curDir
}

_WorkSpace() {
  compadd "base" "SavingsUnited"
}

compdef _WorkSpace WorkSpace
