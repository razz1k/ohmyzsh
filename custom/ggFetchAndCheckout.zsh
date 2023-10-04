ggFetchAndCheckout() {
  branchName="$1"
  git fetch origin $branchName
  git checkout $branchName
}
