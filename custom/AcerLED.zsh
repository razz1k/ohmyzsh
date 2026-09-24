#!/usr/bin/zsh
#
#  curl --url 'https://lenta.selmash.keenetic.link/json/si' \
#    -H 'Content-Type: application/json; charset=UTF-8' \
#    --data-raw '{"on":true}'
#
#  curl --url 'https://lenta.selmash.keenetic.link/json/si' \
#    -H 'Content-Type: application/json; charset=UTF-8' \
#    --data-raw '{"on":true}'

AcerLED() {
  local url headers
  url='https://lenta.selmash.keenetic.link/json/si'
  headers='Content-Type: application/json; charset=UTF-8'

  function getState() {
    curl -s $url -H $headers --data-raw '{"v":true}' | jq '.state.on' | grep -q 'true'
  }

  if getState; then
    curl -s $url -H $headers --data-raw '{"on":false}' > /dev/null
  else
    curl -s $url -H $headers --data-raw '{"on":true}' > /dev/null
  fi
}
