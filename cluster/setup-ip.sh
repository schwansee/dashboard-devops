#!/bin/bash

SCRIPT_ROOT=$(dirname "${BASH_SOURCE}")
DEPLOY_ENV_FILE=$SCRIPT_ROOT/deploy/deploy_env

for i in `seq $#`
do
  if [ $i -eq 1 ]; then
    roles=$roles" a"
  else
    roles=$roles" i"
  fi
done

NUM_NODES=$(($# -1))

sed -i "s/nodes:\-.*/nodes:\-\"$*\"}/g" $DEPLOY_ENV_FILE
sed -i "s/roles:\-.*/roles:\-\"${roles}\"}/g" $DEPLOY_ENV_FILE
sed -i "s/NUM_NODES:\-.*/NUM_NODES:\-\"${NUM_NODES}\"}/g" $DEPLOY_ENV_FILE
