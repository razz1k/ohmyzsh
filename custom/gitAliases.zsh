alias ggPull='git pull origin "$(git_current_branch)"'
alias ggPush='git push origin "$(git_current_branch)"'
alias ggCommit='[[ "$(pwd)" == *"SavingsUnited/app"* ]] && yarn; git commit --message'
