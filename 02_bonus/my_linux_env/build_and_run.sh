#!/bin/bash

BASEDIR=$(dirname "$0")"/"

if [ -d ~/.ssh ]
then
	cp -r ~/.ssh $BASEDIR
	mv $BASEDIR".ssh/known_hosts" $BASEDIR"tmp"
	cat $BASEDIR"tmp" | grep "github" > $BASEDIR".ssh/known_hosts"
	rm $BASEDIR"tmp"
	docker build -t my_linux_env --build-arg extra_repo=docker $BASEDIR
	rm -rf $BASEDIR".ssh"
	docker run -it --name my_linux my_linux_env
else
	echo "ssh keys folder not found."
fi