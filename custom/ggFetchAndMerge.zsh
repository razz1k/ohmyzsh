ggFetchAndMerge() {
  branchCurr=$(git branch | grep \* | sed -E "s/\* ([^-]*).*/\1/")
  ggFetchAndCheckout $1
  git checkout $branchCurr
  git merge $1
}
