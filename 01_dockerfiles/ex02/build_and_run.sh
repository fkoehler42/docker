#!/bin/bash

BASEDIR=$(dirname "$0")"/"

docker build -t ft-rails:on-build $BASEDIR
docker build -t ex02 $BASEDIR"app"
docker run -d --name rails-app -p 3000:3000 ex02
