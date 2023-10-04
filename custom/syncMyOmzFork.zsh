syncMyOmzFork() {
  curDir=$(pwd)
  cd /home/$USER/.oh-my-zsh && git fetch upstream && git merge upstream/master && git push
  cd "$curDir" || return
}
