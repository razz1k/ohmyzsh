#!/usr/bin/zsh
SavingsUnitedPrepare() {
  ! command -v tmux 1>/dev/null && echo 'please install tmux' && return
  curDir=$(pwd)
  sessionName="SavingsUnited"
  projectDir="/home/razz1k/projects/SavingsUnited"
  rerunMessage="press Enter for restart"

  [ ! -d "$projectDir/app" ] && echo 'invalid projectDir, please configure the script'
  cd "$projectDir/app" || return

  if ! tmux -u has-session -t $sessionName >/dev/null 2>&1
  then
    SHELL=$(which zsh) && tmux -u new -d -s $sessionName -n 'helpers'
    tmux split -v -t $sessionName:0.0
    tmux split -h -t $sessionName:0.0
    tmux send-keys -t $sessionName:0.1 "clear; while true; do read '?run migrate'; bin/rails db:migrate RAILS_ENV=development && git restore db/schema.rb; done" Enter
    tmux send-keys -t $sessionName:0.0 "clear; while true; do read '?update database'; echo 'run update db' && zcat $projectDir/production-dump.sql.gz | mysql -u root -p pannacotta; notify-send -t 3000 'mysql' 'dump uploaded'; echo 'copy rake file' && cp $projectDir/update-domains.rake $projectDir/app/lib/tasks/; echo 'update domains' && rake development:update_domains; echo 'remove rake file' && rm $projectDir/app/lib/tasks/update-domains.rake; echo 'restore db/schema.rb' && git restore db/schema.rb; echo 'done'; done" Enter
    tmux new-window -t $sessionName -n 'development'
    tmux split -h -t $sessionName:1.0 htop -d 25
    tmux send-keys -t $sessionName:1.1 F4 webpack Enter
    tmux split -v -p 80 -t $sessionName:1.1
    tmux split -v -p 20 -t $sessionName:1.0
    tmux send-keys -t $sessionName:1.0 "clear; while true; do bundle install; rails s; read '?$rerunMessage rails'; done" Enter
    tmux send-keys -t $sessionName:1.3 "clear; sleep 5; while true; do rm -rf ./public/{assets,packs}; yarn install; ./bin/webpack-dev-server; read '?$rerunMessage dev'; done" Enter
    tmux send-keys -t $sessionName:1.1 "clear; while true; do read '?production'; rm -rf ./public/{assets,packs}; NODE_ENV=production yarn install && NODE_ENV=production rake assets:precompile; done" Enter
  fi

  if wmctrl -l | grep -E "space $sessionName" | grep -Ev 'grep|workSpace|Chrome' >/dev/null
  then
    wmctrl -ia "$(wmctrl -l | grep -E "space $sessionName" | grep -Ev 'grep|workSpace|Chrome' | awk '{print $1;}')"
  else
    gnome-terminal --window -t "space $sessionName" -- tmux -u at -t $sessionName
  fi

  cd "$curDir" || return
}
