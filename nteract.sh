#!/bin/bash

cd "$(dirname "$0")/docker"

[ -f .env ] && source .env

function main {
  case "$1" in
    'build' ) build ;;
    *)        start ;;
  esac
}

function start {
  {
    url="http://${BIND_IP:-127.0.0.1}:${BIND_PORT:-8888}"

    seq 300 | while read i && ! curl -s "${url}"
    do
      sleep 1
    done

    if which start &> /dev/null; then
      # for windows
      start "${url}"
    elif which open &> /dev/null; then
      # for mac
      open "${url}"
    elif which xdg-open &> /dev/null; then
      # for linux
      xdg-open "${url}"
    else
      echo
      echo 'Please open the following URL in your browser:'
      echo 
      echo "${url}"
      echo
    fi
  } &

  trap on_start_exit EXIT

  docker-compose up
}

function on_start_exit {
  docker-compose down
  /usr/bin/env kill -PIPE -- -$$
}

function build {
  docker-compose build \
    ${http_proxy:+"--build-arg 'http_proxy=${http_proxy}'"} \
    ${https_proxy:+"--build-arg 'https_proxy=${https_proxy}'"} \
    --no-cache
}

main "$@"