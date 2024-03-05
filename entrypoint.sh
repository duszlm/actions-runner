#!/bin/bash

url="https://github.com/${org}"
if [ -n "$repo" ]; then
  url+="/${repo}"
fi
echo "url is ${url}"


if [ ! -f ".runner" ]; then
  ./config.sh \
    --name $name \
    --token $token \
    --url $url \
    --labels $labels \
    --runnergroup $group \
    --unattended \
    --replace "${ARGS[@]}"
fi

./run.sh