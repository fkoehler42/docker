#!/bin/bash

BASEDIR=$(dirname "$0")"/"

docker build -t gitlab-ce $BASEDIR
docker run -d --name ex03 -p 80:80 -p 30022:22 gitlab-ce