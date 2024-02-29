syncMyOmzFork() {
  curDir=$(pwd)
  cd /home/$USER/.oh-my-zsh

  if ! git ls-remote --exit-code upstream >/dev/null 2>&1 ; then
    git remote add upstream git@github.com:ohmyzsh/ohmyzsh.git
  fi

  git fetch upstream && git merge upstream/master && git push
  cd "$curDir" || return
}

