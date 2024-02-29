ggFetchAndCheckout() {
  git fetch origin "$1"
  git checkout "$1"
}
