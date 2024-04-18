#!/usr/bin/zsh
SavingsUnitedPrepare() {
  uname="$(uname)"
  ! command -v zsh 1>/dev/null && read '?please install zsh' && return
  ! command -v tmux 1>/dev/null && read '?please install tmux' && return
  ! command -v tmux 1>/dev/null && read '?please install htop' && return
  ! command -v wmctrl 1>/dev/null && read '?please install wmctrl' && return

  curDir=$(pwd)
  sessionName="SavingsUnited"
  projectDir="/home/$USER/projects/SavingsUnited"
  rerunMessage="press Enter for restart"
  sqlPayload="UPDATE sites SET hostname = CONCAT(id, '.localhost');"
  sqlFullCommand='mysql --user="$SU_ENV_DB_user" --password="$SU_ENV_DB_pass" --database="$SU_ENV_DB_name" --execute='\"$sqlPayload\"

  [ ! -d "$projectDir/app" ] && echo 'invalid projectDir, please configure the script'
  cd "$projectDir/app" || return

  if ! tmux -u has-session -t $sessionName >/dev/null 2>&1
  then
    SHELL=$(which zsh) && tmux -u new -d -s $sessionName -n 'helpers'
    tmux split -v -p 80 -t $sessionName:0.0
    tmux split -h -t $sessionName:0.0
    tmux send-keys -t $sessionName:0.1 "clear; while true; do read '?run migrate'; rails db:migrate RAILS_ENV=development && git restore db/schema.rb; done" Enter
    tmux send-keys -t $sessionName:0.0 "clear; while true; do read '?update database'; echo 'run update db'; source $projectDir/.env.sh; zcat $projectDir/production-dump.sql.gz | mysql --user=\"\$SU_ENV_DB_user\" --password=\"\$SU_ENV_DB_pass\" \$SU_ENV_DB_name; notify-send -t 3000 'mysql' 'dump uploaded'; echo 'update domains' && $sqlFullCommand; echo 'done'; done" Enter
    tmux new-window -t $sessionName -n 'development'
    tmux split -h -t $sessionName:1.0 htop -d 25
    tmux send-keys -t $sessionName:1.1 F4 webpack Enter
    tmux split -v -p 80 -t $sessionName:1.1
    tmux split -v -p 20 -t $sessionName:1.0
    tmux send-keys -t $sessionName:1.0 "clear; while true; do bundle install; rails s; read '?$rerunMessage rails'; done" Enter
    tmux send-keys -t $sessionName:1.3 "clear; while true; do read '?$rerunMessage dev'; rm -rf ./public/{assets,packs}; yarn install; ./bin/shakapacker-dev-server; done" Enter
    tmux send-keys -t $sessionName:1.1 "clear; while true; do read '?$rerunMessage production'; rm -rf ./public/{assets,packs}; NODE_ENV=production yarn install && NODE_ENV=production rake assets:precompile; done" Enter
  fi

  if wmctrl -l | grep -E "space $sessionName" | grep -Ev 'grep|workSpace|Chrome' >/dev/null; then
    wmctrl -ia "$(wmctrl -l | grep -E "space $sessionName" | grep -Ev 'grep|workSpace|Chrome' | awk '{print $1;}')"
  else
    if [ "$uname" = 'Linux' ]; then
      if [ -n "$(which gnome-terminal)" ]; then
        gnome-terminal --window -t "space $sessionName" -- tmux -u at -t $sessionName
      else
        echo 'look for this line and set your terminal to automatically open a window with a prepared tmux session.'
      fi
    elif [ "$uname" == 'Darwin' ]; then
      read '?not ready yet' && return
    fi
  fi

  cd "$curDir" || return
}
