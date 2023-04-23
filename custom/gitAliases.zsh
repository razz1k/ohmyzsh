alias ggPull='git pull origin "$(git_current_branch)"'
alias ggPush='git push origin "$(git_current_branch)"'
alias ggCommit='[[ $(git branch | grep \* | sed -E "s/\* ([^-]*).*/\1/") = "SU" ]] && yarn; git commit --message'
