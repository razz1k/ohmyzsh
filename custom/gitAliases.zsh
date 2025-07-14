alias ggPull='git pull origin "$(git_current_branch)"'
alias ggPush='git push origin "$(git_current_branch)"'
alias ggCommit='[[ "$(pwd)" == *"SWPrep/app"* ]] && yarn; git commit --message'
