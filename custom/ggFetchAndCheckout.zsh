ggFetchAndMerge() {
  branchCurr=$(git branch | grep \* | sed -E "s/\* ([^-]*).*/\1/")
  branchName="$1"
  git fetch origin $branchName
  git checkout $branchName
}
