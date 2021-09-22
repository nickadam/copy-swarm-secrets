#!/bin/bash

usage() {
  echo
  echo "  Usage: $0 SOURCE DESTINATION SECRET [SECRET]..."
  echo
  echo "  SOURCE or DESTINATION can be localhost otherwise ssh will be used"
  echo
  exit $1
}

fatal() {
  echo Error: $*
  usage 1
}

[ "$1" = -h ] && usage 0
[ "$1" = --help ] && usage 0

[ $# -lt 1 ] && fatal No params specified
[ $# -lt 2 ] && fatal Destination and secret not specified
[ $# -lt 3 ] && fatal Secret not specified

SRC=$1
DST=$2

SECRET_ARGS=''
for secret in "${@:3}"
do
  SECRET_ARGS=$SECRET_ARGS' --secret '$secret
done

COMMAND="docker service create --restart-condition=none --name copy-swarm-secrets $SECRET_ARGS -d nickadam/copy-swarm-secrets >/dev/null; sleep 3; docker service logs --raw copy-swarm-secrets; docker service rm copy-swarm-secrets >/dev/null"

if [ "$SRC" = "localhost" ]
then
  secrets=$(eval $COMMAND)
else
  secrets=$(ssh $SRC $COMMAND)
fi

COMMAND="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nickadam/copy-swarm-secrets $secrets"

if [ "$DST" = "localhost" ]
then
  eval $COMMAND
else
  ssh $DST $COMMAND
fi
