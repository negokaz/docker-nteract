#!/bin/bash

cd "$(dirname "$0")"

[ -f .env ] && source .env

url="http://${BIND_IP:-127.0.0.1}:${BIND_PORT:-8888}"


if which start > /dev/null 2>&1; then
  # for windows
  start "${url}"
elif which open > /dev/null 2>&1; then
  # for mac
  open "${url}"
elif which xdg-open > /dev/null 2>&1; then
  # for linux
  xdg-open "${url}"
else
  cat <<EOS

Please open the following URL in your browser:

${url}

EOS
fi

compose_file="nteract-docker-compose.yml"

trap "docker-compose --file '${compose_file}' down" EXIT

docker-compose --file "${compose_file}" up
