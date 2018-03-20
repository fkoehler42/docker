#!/bin/bash

BASEDIR=$(dirname "$0")"/"

cp -r ~/.ssh $BASEDIR
mv $BASEDIR".ssh/known_hosts" $BASEDIR"tmp"
cat $BASEDIR"tmp" | grep "github" > $BASEDIR".ssh/known_hosts"
rm $BASEDIR"tmp"
docker build -t my_linux_env $BASEDIR
docker run -it --name my_linux my_linux_env
