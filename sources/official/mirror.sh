#!/bin/bash

cd $(dirname $0)

if [[ $(jq -r .reference.P854 meta.json) == http* ]]
then
  CURLOPTS='-L -c /tmp/cookies -A eps/1.2 --insecure'
  curl $CURLOPTS -o official.html  $(jq -r .reference.P854 meta.json)
  curl $CURLOPTS -o official2.html $(jq -r .continued meta.json)
fi

cd ~-
