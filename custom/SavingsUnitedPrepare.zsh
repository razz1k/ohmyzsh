#!/usr/bin/zsh
SavingsUnitedPrepare() {
  sessionName="SavingsUnited"
  projectDir="/home/razz1k/projects/SavingsUnited"

  if ! tmux -u has-session -t $sessionName >/dev/null 2>&1
  then
    cd $projectDir"/app"
    tmux -u new -d -s $sessionName -n 'helpers'
    tmux split -v -t $sessionName:0.0
    tmux split -h -t $sessionName:0.0
    tmux send-keys -t $sessionName:0.1 "clear; while true; do echo 'run migrate'; read; bin/rails db:migrate RAILS_ENV=development && git restore db/schema.rb; done" Enter
    tmux send-keys -t $sessionName:0.0 "clear; while true; do echo 'update database'; read; echo 'update db' && zcat $projectDir/production-dump.sql.gz | mysql -u root -p pannacotta; notify-send -t 3000 'mysql' 'dump uploaded'; echo 'copy rake file' && cp $projectDir/update-domains.rake $projectDir/app/lib/tasks/; echo 'update domains' && rake development:update_domains; echo 'remove rake file' && rm $projectDir/app/lib/tasks/update-domains.rake; echo 'restore db/schema.rb' && git restore db/schema.rb; echo 'done'; done" Enter
    tmux new-window -t $sessionName -n 'development'
    sleep 0.3
    tmux split -h -t $sessionName:1.0 htop -d 25 -s PERCENT_MEM
    tmux send-keys -t $sessionName:1.1 F4 webpack Enter
    tmux split -v -p 80 -t $sessionName:1.1
    tmux split -v -p 20 -t $sessionName:1.0
    tmux send-keys -t $sessionName:1.0 "clear; while true; do bundle install; rails s; read; done" Enter
    tmux send-keys -t $sessionName:1.3 "clear; sleep 5; while true; do echo 'dev'; rm -rf ./public/{assets,packs}; yarn install; ./bin/webpack-dev-server; read; done" Enter
    tmux send-keys -t $sessionName:1.1 "clear; while true; do echo 'production'; read; rm -rf ./public/{assets,packs}; NODE_ENV=production yarn install && NODE_ENV=production rake assets:precompile; done" Enter
  fi

  if wmctrl -l | grep -E "$sessionName" | grep -Ev 'grep|workSpace|Chrome' >/dev/null
  then
    wmctrl -ia $(wmctrl -l | grep -E "$sessionName" | grep -Ev 'grep|workSpace|Chrome' | awk '{print $1;}')
  else
    gnome-terminal --window -t $sessionName -- tmux -u at -t $sessionName
  fi
}
